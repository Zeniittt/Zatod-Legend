local ed = ed
local AutoChessBattleScene = {}
local base = ed.ui.commonscene
local AutoChessBattleScene = newclass(base.mt)
ed.AutoChessBattleScene = AutoChessBattleScene

function AutoChessBattleScene:initData(stage_info, battle_info, extraInfo, forceClean)
  ed.enableFcaAutoRelease(false)
  forceClean = forceClean == nil and true or forceClean
  local extra_ui_info = (extraInfo or {}).extra_ui_info or {}
  self.battle_info = battle_info
  self.stage_info = stage_info
  self.identity = "AutoChessBattleScene"
  self.actor_list = {}
  self.effect_list = {}
  self.ui_list = {}
  self.left_list = {}
  self.frames = 0
  self.auto_combat = false
  self.open_add_speed = false
  self.pause_locks = {}
  self.loading = false
  self.running = true
  self.alreadyAddBuffIcon = false
  self.image_damage = nil
  self.signal_image_host = nil
  self.signal_image_slave = nil
  self.closeHeroPanelClick = false
  self.speedRate = 1
  self.myHeroIndex = 0
  self.handlerList = {}
  self.fcaList = {}
  self.battleModeInfo = extraInfo
  self.battleInfo = battle_info or {}
  local bg = battle_info["Background Pic"]
  self.backgroundPath = extra_ui_info.background or bg
  self.backgroundPathFirst = self.backgroundPath
  self.lastSync = 0
  ed.trackMgr:initData()
  for i, unit in ipairs(ed.AutoChessBattleEngine.unit_list) do
    unit:preload()
  end
end

function AutoChessBattleScene:adaptBattleField()
  self.contentOffsetY = self:adaptBackground()
  self.contentScale = self.background:getScale()
  if drawBattfieldRect then
    local drawNode = CCDrawNode:create()
    local maxX = ed.AutoChessBattleEngine.stage_rect.maxX
    local fixScale = ed.display.winSize.width / maxX
    drawNode:drawRect(ccp(0, ed.display.winSize.height / 2), 800 * fixScale, 240 * fixScale)
    self.content_layer:addChild(drawNode, 5)
  end
end

function AutoChessBattleScene:adaptUI()
end

function AutoChessBattleScene:adaptBackground()
  ed.layout.adaptBG(self.background, "X")
  local offsetY = (ed.display.winSize.height - ed.layout.getScaleSize(self.background).height) / 2
  if offsetY < 0 then
    return offsetY
  end
  return 0
end

function AutoChessBattleScene:initChessHintArea()
  local fin = CCFadeIn:create(0.6)
  local fout = CCFadeOut:create(0.6)
  local seq = CCSequence:createWithTwoActions(fin, fout)
  local rep = CCRepeatForever:create(seq)
  self.ui.chessHitArea:runAction(rep)
end

function AutoChessBattleScene:doMainLayerTouch()
  local function handler(event, x, y)
    for _, handler in ipairs(self.handlerList) do
      xpcall(function()
        handler(event, x, y)
      end, EDDebug)
    end
    self:checkUILayerClicked(event, x, y)
    return true
  end
  
  return handler
end

function AutoChessBattleScene:addMainLayerTouchHandler(handler)
  table.insert(self.handlerList, handler)
end

function AutoChessBattleScene:initAutoChessPanel()
  self:initChessHintArea()
end

function AutoChessBattleScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.AutoChessBattleScene)
  self.bg:setVisible(false)
  self.ui = ui
  self.mainLayer:setPosition(ccp(0, 0))
  self.mainLayer:addChild(container)
  self.damageBath_layer = self.ui.damageBath_layer
  self.background = self.ui.background
  self.ui_layer = self.ui.ui_layer
  self.main_layer = self.ui.main_layer
  self.background_layer = self.ui.background_layer
  self.top_layer = self.ui.top_layer
  self.content_layer = self.ui.content_layer
  self:adaptUI()
  self:adaptBattleField()
  self.ui.ui_layer:setTouchEnabled(true)
  self.ui.ui_layer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -129, false)
  self:initAutoChessPanel()
end

function AutoChessBattleScene:getCurrentMode()
  return "autoChessMode"
end

function AutoChessBattleScene:registerEvents()
  self:listenEvent("AutoChessSetHitAreaVisible", function(isVisible)
    self:showChessHitArea(isVisible)
  end)
end

function AutoChessBattleScene:registerTouchHandlers()
end

function AutoChessBattleScene:checkUILayerClicked(event, x, y)
  if self.alreadyAddBuffIcon == true then
    if event == "began" then
      local idx = 0
      for _, p in ipairs(self.ui_list) do
        if p.buffstack then
          if ed.containsPoint(p.node, x, y) then
            local str = T("<text|chat_channel_active|" .. p.buff.info["Icon Text"] .. ">")
            local posX, posY
            local pos = p.node:getParent():convertToWorldSpace(ccp(p.node:getPosition()))
            posX = pos.x + idx * 45
            posY = pos.y - 40
            if 660 < posX then
              posX = 650
            end
            ed.showHintText(str, ccp(posX, posY))
            return true
          end
          idx = idx + 1
        end
      end
    elseif event == "ended" then
      ed.closeHintText()
    end
  end
  return false
end

function AutoChessBattleScene.create(stage_info, battle_info, extraInfo, forceClean)
  local self = base.create("AutoChessBattleScene", {noBottomButton = true})
  setmetatable(self, AutoChessBattleScene.mt)
  self:initData(stage_info, battle_info, extraInfo, forceClean)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  ed.scene = self
  ed.sceneui = self
  self:registerOnEnterHandler("AutoChessBattleSceneEnter", function()
    self.autoChessPanel = ed.ui.AutoChessMainPanel.create()
    self.autoChessPanel:setBattleScene(self)
    self.autoChessPanel:popWindow()
  end)
  self:registerOnExitHandler("AutoChessBattleSceneExit", function()
    ed.engine = ed.commonEngine
    ed.scene = ed.commonBattleScene
    ed.sceneui = ed.commonBattleSceneUI
  end)
  return self
end

function AutoChessBattleScene:exit()
  if not ed.AutoChessBattleEngine.stage_ended then
    ed.stopMusic()
    ed.playMusic(ed.music.map)
    ed.AutoChessBattleEngine:exitStage(2, true)
  end
  self:removeAutoChessPanel()
  ed.enableFcaAutoRelease(true)
  ed.popScene()
  ed.openMemeryGC = true
  ed.memeryGC(10)
end

function AutoChessBattleScene:setContentNodeScale(node)
  local sx, sy = node:getScaleX(), node:getScaleY()
  node:setScaleX(self.contentScale * sx)
  node:setScaleY(self.contentScale * sy)
end

function AutoChessBattleScene:addActor(actor)
  if actor.node then
    table.insert(self.actor_list, actor)
    self.ui.main_layer:addChild(actor.node)
    self:setContentNodeScale(actor.node)
  end
end

function AutoChessBattleScene:syncActors()
  if self.lastSync ~= ed.AutoChessBattleEngine.ticks then
    self.lastSync = ed.AutoChessBattleEngine.ticks
    for unit in ed.AutoChessBattleEngine:foreachAliveUnit(ed.emCampBoth) do
      if unit:isAlive() and not unit.actor then
        unit.actor = ed.UnitActorCreate(unit)
        self:addActor(unit.actor)
        if unit.pet and not unit.pet.actor then
          local actor = ed.UnitActorCreate(unit.pet)
          actor.node:setVisible(false)
          unit.pet.actor = actor
          self:addActor(actor)
        end
      end
    end
    for npc in ed.AutoChessBattleEngine:foreachNpc() do
      if not npc.actor then
        npc.actor = ed.NpcActorCreate(npc)
        npc:setAction(npc.bornActionName, true)
        self:addActor(npc.actor)
      end
    end
  end
end

function AutoChessBattleScene:addEffect(effect, z)
  table.insert(self.effect_list, effect)
  z = z or 0
  if z < 0 then
    self.ui.background_layer:addChild(effect.node or effect)
    self:setContentNodeScale(effect.node or effect)
  elseif z == 0 then
    self.ui.main_layer:addChild(effect.node or effect)
    self:setContentNodeScale(effect.node or effect)
  elseif z == 1 then
    self.ui.top_layer:addChild(effect.node or effect)
    self:setContentNodeScale(effect.node or effect)
  elseif z == 2 then
    self.ui.ui_layer:addChild(effect.node or effect)
  end
end

function AutoChessBattleScene:removeEffect(effect, z)
  for i = 1, #self.effect_list do
    local item = self.effect_list[i]
    if item == effect then
      table.remove(self.effect_list, i)
    end
  end
  z = z or 0
  if z < 0 then
    self.ui.background_layer:removeChild(effect.node or effect, true)
  elseif z == 0 then
    self.ui.main_layer:removeChild(effect.node or effect, true)
  elseif z == 1 then
    self.ui.top_layer:removeChild(effect.node or effect, true)
  elseif z == 2 then
    self.ui.ui_layer:removeChild(effect.node or effect, true)
  end
end

function AutoChessBattleScene:addParticle(particle, z)
  z = z or 0
  if z < 0 then
    self.ui.background_layer:addChild(particle)
    self:setContentNodeScale(particle)
  elseif z == 0 then
    self.ui.main_layer:addChild(particle)
    self:setContentNodeScale(particle)
  elseif z == 1 then
    self.ui.top_layer:addChild(particle)
    self:setContentNodeScale(particle)
  elseif z == 2 then
    self.ui.ui_layer:addChild(particle)
  end
end

function AutoChessBattleScene:removeParticle(particle, z)
  z = z or 0
  if z < 0 then
    self.background_layer:removeChild(particle, true)
  elseif z == 0 then
    self.main_layer:removeChild(particle, true)
  elseif z == 1 then
    self.top_layer:removeChild(particle, true)
  elseif z == 2 then
    self.ui_layer:removeChild(particle, true)
  end
end

function AutoChessBattleScene:delayPlayMusic(music)
  local function handler()
    if self.scene:isRunning() then
      ed.playMusic(music)
      
      self.delayPlayMusicHandler = nil
    end
  end
  
  return handler
end

function AutoChessBattleScene:setSpeedRate(speedRate)
  self.speedRate = speedRate
end

function AutoChessBattleScene:addFca(fca)
  self.fcaList[#self.fcaList + 1] = {node = fca}
end

function AutoChessBattleScene:removeFca(fca)
  for i = #self.fcaList, 1, -1 do
    if self.fcaList[i].node == fca then
      table.remove(self.fcaList, i)
      break
    end
  end
end

function AutoChessBattleScene:update(dt)
  for k, v in pairs(self.fcaList) do
    if tolua.isnull(v.node) then
      self:removeFca(v.node)
    elseif not v.isPause and not v.beCulled then
      v.node:update(dt)
    end
  end
  for k, v in pairs(ed.globalFcaList or {}) do
    if tolua.isnull(v.node) then
      self:removeFca(v.node)
    elseif not v.isPause and not v.beCulled then
      v.node:update(dt)
    end
  end
  dt = dt * self.speedRate
  self.dt = dt
  self:updateLoading(dt)
  if battle_tick.canUpdate(dt) then
    ed.AutoChessBattleEngine:update(dt)
    ed.trackMgr:checkFrame(dt)
    self.frames = self.frames + 1
    self:syncActors()
    ed.GhostManager:getInstance():update(dt)
    local new_list = {}
    for _, actor in ipairs(self.actor_list) do
      if not actor.model.terminated then
        if not actor.model.frozen_actor then
          actor:update(dt)
          if actor.model.updateActor then
            actor.model:updateActor(dt)
          end
        end
        local md = actor.model
        if md.what == "Unit" or md.what == "ChessUnit" then
          if not actor.is_terminated then
            table.insert(new_list, actor)
          else
            actor.node:removeFromParentAndCleanup(true)
            md.actor = nil
          end
        else
          table.insert(new_list, actor)
        end
      else
        actor.node:removeFromParentAndCleanup(true)
        actor.node = nil
      end
    end
    self.actor_list = new_list
    local new_list = {}
    for _, effect in ipairs(self.effect_list) do
      if effect.update then
        effect:update(dt)
      end
      if effect:isTerminated() then
        local node = effect.node or effect
        node:removeFromParentAndCleanup(true)
      else
        table.insert(new_list, effect)
      end
    end
    self.effect_list = new_list
  end
  if self.delayPlayMusicHandler then
    self.delayPlayMusicHandler()
  end
  local new_list = {}
  for _, ui in ipairs(self.ui_list) do
    ui:update(dt)
    if ui.terminated then
    else
      table.insert(new_list, ui)
    end
  end
  self.ui_list = new_list
  if self.autoChessPanel then
    self.autoChessPanel:update(dt)
  end
end

function AutoChessBattleScene:onSceneFreezeBegin()
  self.background:setColor(ccc3(96, 96, 96))
  for _, effect in ipairs(self.effect_list) do
    effect:setActionSpeeder(0)
  end
end

function AutoChessBattleScene:onSceneFreezeEnd()
  self.background:setColor(ccc3(255, 255, 255))
  for _, effect in ipairs(self.effect_list) do
    effect:setActionSpeeder(1)
  end
end

function AutoChessBattleScene:onBackgroundHide(delay)
  self.background:runAction(CCFadeOut:create(delay))
end

function AutoChessBattleScene:onBackgroundAppear(delay, bgPath)
  if bgPath then
    self.backgroundPath = bgPath
    ed.setTexture(self.background, "UI/alpha/1080P/" .. bgPath)
  end
  self.background:runAction(CCFadeIn:create(delay))
end

function AutoChessBattleScene:playEffectOnScene(effect_name, origin, scale, height, zOrder, actionName, actionTime, angle)
  if ed.trackMgr.isShieldFullEffect then
    return nil
  end
  scale = scale or {1, 1}
  scale = FlipXVector(scale)
  height = height or 0
  local node
  local pos = FlipXPosition(origin)
  local vp = ed.toViewPosition(pos, height)
  effect_name = string.gsub(effect_name, "%.cha$", "")
  node = ed.createFcaNode(effect_name)
  if actionName ~= nil and actionName ~= "" then
    node:setStartAction(actionName)
    if actionTime then
      node:setLoopAction(actionName)
      ListenTimer(Timer:Once(actionTime), function()
        node:setLoopAction("")
      end)
    end
  end
  if angle ~= nil then
    node:setRotation(angle)
  end
  node:setPosition(vp)
  node:setScaleX(node:getScaleX() * scale[1])
  node:setScaleY(node:getScaleY() * scale[2])
  node:setZOrder(-origin[2])
  self:addEffect(node, zOrder)
  return node
end

function AutoChessBattleScene:showMonsterLoots(wave_idx, monster, lost_hp_per, old_lost_hp_per)
  local monster_idx = monster.monster_idx
  local dir_flag = monster.dir_flag or "right"
  local list
  if lost_hp_per then
    list = ed.player:getHpLootOfMonster(wave_idx, monster_idx, dir_flag, lost_hp_per, old_lost_hp_per)
  else
    list = ed.player:getStageLootOfMonster(wave_idx, monster_idx, dir_flag)
  end
  for i, v in ipairs(list) do
    local _type = v.type
    local _id = v.id
    local icon
    if _type == "equip" then
      icon = ed.lookupDataTable("equip", "Icon", _id)
    elseif _type == "hero" then
      icon = ed.getUnitPortrait(_id)
    elseif _type == "book" then
      EDDebug("Skill books not supported")
    end
    local loot = ed.LootCreate(icon, _type, monster, i, _id)
    loot.node:setScale(ed.AutoChessBattleEngine.unitScale)
    table.insert(self.ui_list, loot)
    self.ui.ui_layer:addChild(loot.node)
  end
end

function AutoChessBattleScene:startCameraShakeAnimationY(maxShakeHeight, shakeTime, shakeNum)
  if nil ~= CCDirector:sharedDirector().startCameraAnimationY then
    CCDirector:sharedDirector():startCameraAnimationY(maxShakeHeight, shakeTime, shakeNum)
  end
end

function AutoChessBattleScene:stopCameraShakeAnimationY()
  if nil ~= CCDirector:sharedDirector().stopCameraAnimationY then
    CCDirector:sharedDirector():stopCameraAnimationY()
  end
end

function AutoChessBattleScene:startCameraShakeAnimationX(maxShakeHeight, shakeTime, shakeNum)
  if nil ~= CCDirector:sharedDirector().startCameraAnimationX then
    CCDirector:sharedDirector():startCameraAnimationX(maxShakeHeight, shakeTime, shakeNum)
  end
end

function AutoChessBattleScene:stopCameraShakeAnimationX()
  if nil ~= CCDirector:sharedDirector().stopCameraAnimationX then
    CCDirector:sharedDirector():stopCameraAnimationX()
  end
end

function AutoChessBattleScene:updateLoading(dt)
  if self.loading == false and not battle_tick.canUpdate(dt) then
    ed.loadBegin(false, false)
    self.loading = true
  elseif self.loading == true and battle_tick.canUpdate(dt) then
    ed.loadEnd()
    self.loading = false
  end
end

function AutoChessBattleScene:showChessHitArea(isShow)
  self.ui.chessHitArea:setVisible(isShow)
end

function AutoChessBattleScene:removeAutoChessPanel()
  local panel = self.autoChessPanel
  if not tolua.isnull(panel) then
    panel:destroy()
  end
end
