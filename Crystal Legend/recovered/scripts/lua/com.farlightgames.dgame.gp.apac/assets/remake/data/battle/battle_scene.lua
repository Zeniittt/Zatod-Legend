require("battle/battleui/hp_bar")
require("battle/battleui/heatBuffPanel")
require("battle/battleui/ball_bar")
require("battle/battleui/hero_panel")
require("battle/battleui/buffstack")
require("battle/battleui/goldBean")
require("battle/battleui/stageWaveProgress")
require("battle/battleui/multiHeroPanel")
require("battle/battleui/conditionScorePanel")
require("battle/edp")
require("battle/battle_engine")
require("battle/popup")
require("battle/soloPopUp")
require("battle/loot")
require("battle/battle_sceneui")
local ed = ed
local acts = require("util.cocos2dx.actions")
local Queue = require("util.queue")
local BattleScene = {}
setimplements(BattleScene, ed.ui.sceneInterface)
ed.scene = BattleScene
ed.commonBattleScene = BattleScene

function ed.setBattleScene(scene)
  ed.battleScene = scene
end

function ed.getBattleScene()
  return ed.battleScene or ed.scene
end

function BattleScene:getCurrentMode()
  if self.battleModeInfo == nil then
    return "pve"
  end
  if self.battleModeInfo.replayInfo then
    return "replay"
  end
  if self.battleModeInfo.pvpInfo then
    return self.battleModeInfo.pvpInfo.pvpMode
  end
  if self.battleModeInfo.crusadeInfo then
    return "crusade"
  end
  if self.battleModeInfo.guildInstanceInfo then
    return "guildInstance"
  end
  if self.battleModeInfo.battleCheckInfo then
    return self.battleModeInfo.battleCheckInfo.battleCheckMode
  end
  if self.battleModeInfo.SkillTowerInfo then
    return "fancyTower"
  end
  if self.battleModeInfo.fancyAbyssInfo then
    return "fancyAbyss"
  end
  if self.battleModeInfo.activityAdventureInfo then
    return "activityAdventure"
  end
  if self.battleModeInfo.hadesHeatInfo then
    return "hadesHeat"
  end
  if self.battleInfo["Stage Type"] == "dreamland" then
    return "dreamland"
  end
  if self.battleModeInfo.awakeStageInfo then
    return "awakeStage"
  end
  if self.battleModeInfo.peakArenaInfo then
    return "peakArena"
  end
  if self.battleModeInfo.cupArenaInfo then
    return "cupArena"
  end
  if self.battleModeInfo.guildClashInfo then
    return "guildClash"
  end
  if self.battleModeInfo.autoChessMode then
    return "autoChessMode"
  end
  if self.battleModeInfo.guildMountBossInfo then
    return "guildMountBoss"
  end
  if self.battleModeInfo.rogueModeInfo then
    return "rogueMode"
  end
  if self.battleModeInfo.creviceDefendInfo then
    return "crevicedefend"
  end
  local stageInfo = ed.engine.stage_info or {}
  if stageInfo["Stage ID"] and ed.stageType(stageInfo["Stage ID"]) == "act" then
    return "act"
  end
  return "pve"
end

function BattleScene:createSceneAndLayers()
  self.content_layer = CCLayer:create()
  self.background_layer = CCLayer:create()
  self.main_layer = CCLayer:create()
  self.top_layer = CCLayer:create()
  self.zoom_layer = CCLayer:create()
  self.scene = CCScene:create()
  self.scene:addChild(self.background_layer)
  self.scene:addChild(self.content_layer, 1)
  self.scene:addChild(self.zoom_layer, 3)
  self.zoom_layer:setVisible(false)
  self.background_node = ed.createSprite()
  self.background = self.background_node
  self.background_node:setCascadeOpacityEnabled(true)
  self.background_node:setCascadeColorEnabled(true)
  self.background_node:setContentSize(CCSizeMake(960, 540))
  self.protectbg = ed.createSprite("UI/alpha/1080P/common/dialogue_arrow.png")
  self.protectbg:setVisible(false)
  self.protectbg:setAnchorPoint(ed.ccpZero)
  self.background_layer:addChild(self.protectbg)
  self.background_layer:addChild(self.background_node, -1000)
  self.bgList = {}
  self.bgLength = 1
  if ed.engine.awakeStageMode and ed.engine.stage_info["Scrolls Waves"] then
    self.bgLength = ed.engine.stage_info.Waves
  end
  for index = 1, self.bgLength do
    local background = ed.createSprite("UI/alpha/1080P/battle_bg/bbg_arena.jpg")
    self.background_node:addChild(background)
    table.insert(self.bgList, background)
  end
  self.content_layer:addChild(self.main_layer, 1)
  self.content_layer:addChild(self.top_layer, 2)
  ed.engine.manualMode:InitWindow()
  local layer = ed.engine.manualMode.mainLayer
  self.manualModeLayer = layer
  self.content_layer:addChild(layer, 3)
  ed.sceneui:createUILayers(self.scene)
end

local needClearLayerNames = {
  "background_layer",
  "main_layer",
  "top_layer",
  "zoom_layer"
}
local protectedNode = {
  {
    node = "background_node",
    parent = "background_layer"
  },
  {
    node = "protectbg",
    parent = "background_layer"
  }
}

function BattleScene:clearScene()
  for i, v in ipairs(protectedNode) do
    local node = self[v.node]
    if node then
      node:retain()
    end
  end
  for i, layerName in ipairs(needClearLayerNames) do
    local layer = self[layerName]
    if layer then
      layer:stopAllActions()
      layer:removeAllChildrenWithCleanup(true)
    end
  end
  for i, v in ipairs(protectedNode) do
    local node = self[v.node]
    local parent = self[v.parent]
    if node then
      parent:addChild(node, node:getZOrder())
      node:release()
    end
  end
  ed.sceneui:clearSceneUI()
end

function BattleScene:reset(stage_info, battle_info, extraInfo, forceClean)
  ed.enableFcaAutoRelease(false)
  local extra_ui_info = (extraInfo or {}).extra_ui_info or {}
  self.identity = "battle"
  self.actor_list = {}
  self.effect_list = {}
  self.frames = 0
  self.auto_combat = false
  self.open_add_speed = false
  self.pause_locks = {}
  self.loading = false
  self.running = true
  self.myHeroIndex = 0
  self.fcaList = {}
  self.stageInfo = stage_info or {}
  self.battleInfo = battle_info or {}
  self.battleModeInfo = extraInfo
  self.obMode = extraInfo and extraInfo.obMode
  self.loadingTime = 0
  local bg = battle_info["Background Pic"]
  self.backgroundPath = extra_ui_info.background or bg
  self.backgroundPathFirst = self.backgroundPath
  ed.trackMgr:initData()
  self.lastSync = 0
  self:resetScene(forceClean)
end

function BattleScene:resetScene(forceClean)
  local stage_info = self.stageInfo
  local battle_info = self.battleInfo
  forceClean = forceClean == nil and true or forceClean
  if not self.scene or forceClean then
    self:createSceneAndLayers()
  else
    self:clearScene()
  end
  for index, bg in ipairs(self.bgList) do
    ed.initSpriteWithFrame(bg, "UI/alpha/1080P/" .. self.backgroundPath)
    local flip = battle_info["H Flip"]
    if flip then
      bg:setFlipX(true)
    end
  end
  if self.background_fca then
    self.background_fca:removeFromParentAndCleanup(true)
    self.background_fca = nil
  end
  local bg_fca = battle_info["Background Fca"]
  if bg_fca then
    self.background_fca = ed.createFcaActor(bg_fca)
    if flip then
      self.background_fca:setFlipX(true)
    end
    self.background_fca:setPosition(ed.ccpZero)
    self.background_layer:addChild(self.background_fca)
    self.background_fca:setAction("Idle")
    self.background_fca:setLoop(true)
  end
  local winSize = ed.display.winSize
  local backSize = ed.layout.getScaleSize(self.background_node)
  local sceneui = ed.sceneui
  sceneui:adaptPosition(winSize, backSize)
  self:adaptBattfield()
  sceneui:resetUI(stage_info, battle_info, self.battleModeInfo)
  local chapter = stage_info["Chapter ID"]
  if not ed.engine.autoChessMode then
    self.delayPlayMusicHandler = self:delayPlayMusic(ed.music["chapter" .. stage_info["Chapter ID"]])
  end
  local viewCamp = ed.emCampPlayer
  if self.battleModeInfo and self.battleModeInfo.replayInfo and self.battleModeInfo.replayInfo.oppoUserid == ed.getUserid() then
    viewCamp = ed.emCampEnemy
  end
  for i, unit in ipairs(ed.engine.unit_list) do
    if unit.isKael and not ed.engine:isAwakeStageMultiMode() then
      unit.displayBall = unit.camp == viewCamp
    end
    unit:preload()
  end
  if self.ClearFVTimeZone then
    self:ClearFVTimeZone()
  end
  sceneui:initUI()
  sceneui:resetExtra()
end

function BattleScene:adaptBackground()
  ed.layout.adaptBG(self.background_node, "X")
  local bgSize = self.background_node:getContentSize()
  for index, bg in ipairs(self.bgList) do
    bg:setPosition((index - 0.5) * bgSize.width, bgSize.height / 2)
  end
  local offsetY = (ed.display.winSize.height - ed.layout.getScaleSize(self.background_node).height) / 2
  if offsetY < 0 then
    self.background_node:setPositionY(self.background_node:getPositionY() + offsetY)
    return offsetY
  end
  return 0
end

function BattleScene:adaptBattfield()
  self.contentOffsetY = self:adaptBackground()
  self.contentScale = self.background_node:getScale()
  self.content_layer:setPositionY(self.contentOffsetY / 2)
  if drawBattfieldRect then
    local drawNode = CCDrawNode:create()
    local maxX = ed.engine.stage_rect.maxX
    local fixScale = ed.display.winSize.width / maxX
    drawNode:drawRect(ccp(0, ed.display.winSize.height / 2), 800 * fixScale, 240 * fixScale)
    self.content_layer:addChild(drawNode, 5)
  end
end

function BattleScene:fixBackLayerChildPos(node)
  self:setContentNodeScale(node)
end

function BattleScene:setContentNodeScale(node)
  local sx, sy = node:getScaleX(), node:getScaleY()
  node:setScaleX(self.contentScale * sx)
  node:setScaleY(self.contentScale * sy)
end

function BattleScene:pauseBattle(reason)
  self.pause_locks[reason] = true
end

function BattleScene:resumeBattle(reason)
  self.pause_locks[reason] = false
end

function BattleScene:exit()
  if not ed.engine.stage_ended then
    ed.stopMusic()
    ed.playMusic(ed.music.map)
    ed.engine:exitStage(2, true)
  end
  self.scene = nil
  if ed.scene.nextwaveAction then
    ed.scene.nextwaveAction:release()
    ed.scene.nextwaveAction = nil
  end
  ed.sceneui:exitUI()
  ed.enableFcaAutoRelease(true)
  ed.popScene()
  ed.memeryGC(10)
end

function BattleScene:resetDamageStep()
  if self:getCurrentMode() == "guildInstance" and self.previous_damage_step then
    self.previous_damage_step = 0
  end
end

function BattleScene:nextWaveBynextBtn()
  if ed.engine.awakeStageMode and ed.engine.stage_info["Scrolls Waves"] then
    self:showScrollAction()
    return
  end
  ed.engine:battleSupply()
  local maxtime = 0
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if unit.actor then
      unit.actor:gotoNextBattle()
    end
    local distance = ed.engine.stage_rect.maxX - unit.position[1]
    local time = distance / (unit.info["Walk Speed"] * ed.next_battle_walk_speeder)
    if maxtime < time then
      maxtime = time
    end
  end
  local action = CCCallFunc:create(function()
    xpcall(function()
      ed.scene:nextBattle()
      if ed.scene.nextwaveAction then
        ed.scene.nextwaveAction:release()
        ed.scene.nextwaveAction = nil
      end
    end, EDDebug)
  end)
  action = CCSequence:createWithTwoActions(CCDelayTime:create(maxtime), action)
  ed.scene.nextwaveAction = action
  action:retain()
  ed.scene.scene:runAction(action)
end

function BattleScene:showScrollAction()
  for i, unit in ipairs(ed.engine.alive_units[ed.emCampPlayer]) do
    if unit:isAlive() and unit.actor then
      local targetLogicPos = ed.scrolls_wave_position[i]
      unit.actor:gotoTargetPos(targetLogicPos)
    end
  end
  local bgSize = ed.layout.getScaleSize(self.background_node)
  local moveAction = CCMoveBy:create(2.5, ccp(-bgSize.width, 0))
  local callFunc = CCCallFunc:create(function()
    if ed.scene.backgroundNodeAction then
      ed.scene.backgroundNodeAction = nil
    end
  end)
  local action = CCSequence:create(ccArrayMake(moveAction, callFunc))
  ed.scene.backgroundNodeAction = action
  self.background_node:runAction(action)
  local scrollNextWaveAction = CCSequence:create(ccArrayMake(CCDelayTime:create(2), CCCallFunc:create(function()
    if ed.scene.scrollNextWaveAction then
      ed.scene.scrollNextWaveAction = nil
    end
    for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
      if unit:isAlive() and unit.actor then
        unit.actor.offline = false
      end
    end
    ed.sceneui:nextBattle_1()
    ed.engine:nextBattle()
    local battleTableName = ed.engine:getBattleCsvName()
    local battle_info = ed.lookupDataTable(battleTableName, nil, ed.engine.stage_info["Stage ID"], ed.engine.wave_id)
    ed.sceneui:clearSceneUI()
    ed.sceneui:resetUI(ed.engine.stage_info, battle_info, self.battleModeInfo)
    ed.sceneui:initUI()
    ed.sceneui:resetExtra()
    ed.sceneui:nextBattle_3()
  end)))
  ed.scene.scrollNextWaveAction = scrollNextWaveAction
  self.main_layer:runAction(scrollNextWaveAction)
  for index, actor in ipairs(self.actor_list) do
    if actor and actor.model and actor.model.camp == ed.emCampEnemy then
      actor.node:setVisible(false)
    end
  end
  for index, effect in ipairs(self.effect_list) do
    effect = effect.node or effect
    effect:removeFromParentAndCleanup(true)
  end
  self.effect_list = {}
end

function BattleScene:stopNextwaveAction()
  if self.nextwaveAction then
    ed.scene.scene:stopAction(self.nextwaveAction)
  end
  if self.backgroundNodeAction then
    local actionManager = ed.scene.background_node:getActionManager()
    actionManager:pauseTarget(ed.scene.background_node)
  end
  if self.scrollNextWaveAction then
    local actionManager = ed.scene.main_layer:getActionManager()
    actionManager:pauseTarget(ed.scene.main_layer)
  end
end

function BattleScene:runNextwaveAction()
  if self.nextwaveAction then
    ed.scene.scene:runAction(self.nextwaveAction)
  end
  if self.backgroundNodeAction then
    local actionManager = ed.scene.background_node:getActionManager()
    actionManager:resumeTarget(ed.scene.background_node)
  end
  if self.scrollNextWaveAction then
    local actionManager = ed.scene.main_layer:getActionManager()
    actionManager:resumeTarget(ed.scene.main_layer)
  end
end

function BattleScene:nextBattle()
  ed.sceneui:nextBattle_1()
  local auto = self.auto_combat
  local open_add_speed = self.open_add_speed
  local stage = ed.engine.stage_info
  local battleTableName = ed.engine:getBattleCsvName()
  local battle = ed.lookupDataTable(battleTableName, nil, stage["Stage ID"], ed.engine.wave_id + 1)
  self.previous_damage_step = self.damage_step
  ed.engine:nextBattle()
  self:reset(stage, battle, self.battleModeInfo, false)
  self.auto_combat = auto
  self.open_add_speed = open_add_speed
  if self.battleModeInfo and self.battleModeInfo.battleCheckInfo then
    ed.replaceScene(ed.scene)
    return
  end
  if stage["Stage ID"] == -2 then
    ed.replaceScene(ed.scene)
    ed.scene:setSpeedRate(1)
    ed.scene.auto_combat = false
    ed.sceneui:nextBattle_2()
    return
  end
  ed.sceneui:nextBattle_3()
  ed.replaceScene(ed.scene)
end

function BattleScene:ccScene()
  return self.scene
end

function BattleScene:addActor(actor)
  if actor.node then
    table.insert(self.actor_list, actor)
    self.main_layer:addChild(actor.node)
    self:setContentNodeScale(actor.node)
  end
end

function BattleScene:addFca(fca)
  self.fcaList[#self.fcaList + 1] = {node = fca}
end

function BattleScene:removeFca(fca)
  for i = #self.fcaList, 1, -1 do
    if self.fcaList[i].node == fca then
      table.remove(self.fcaList, i)
      break
    end
  end
end

function BattleScene:syncActors()
  if self.lastSync ~= ed.engine.ticks then
    self.lastSync = ed.engine.ticks
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
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
    for npc in ed.engine:foreachNpc() do
      if not npc.actor then
        npc.actor = ed.NpcActorCreate(npc)
        npc:setAction(npc.bornActionName, true)
        self:addActor(npc.actor)
      end
    end
  end
end

local function addEffect(self, effect, z)
  table.insert(self.effect_list, effect)
  z = z or 0
  if z < 0 then
    self.background_layer:addChild(effect.node or effect)
    self:fixBackLayerChildPos(effect.node or effect)
  elseif z == 0 then
    self.main_layer:addChild(effect.node or effect)
    self:setContentNodeScale(effect.node or effect)
  elseif z == 1 then
    self.top_layer:addChild(effect.node or effect)
    self:setContentNodeScale(effect.node or effect)
  elseif z == 2 then
    ed.sceneui:addEffect_UI(effect)
  end
end

BattleScene.addEffect = addEffect

local function removeEffect(self, effect, z)
  for i = 1, #self.effect_list do
    local item = self.effect_list[i]
    if item == effect then
      table.remove(self.effect_list, i)
    end
  end
  z = z or 0
  if z < 0 then
    self.background_layer:removeChild(effect.node or effect, true)
  elseif z == 0 then
    self.main_layer:removeChild(effect.node or effect, true)
  elseif z == 1 then
    self.top_layer:removeChild(effect.node or effect, true)
  elseif z == 2 then
    ed.sceneui:removeEffect_UI(effect)
  end
end

BattleScene.removeEffect = removeEffect

local function addParticle(self, particle, z)
  z = z or 0
  if z < 0 then
    self.background_layer:addChild(particle)
    self:fixBackLayerChildPos(particle)
  elseif z == 0 then
    self.main_layer:addChild(particle)
    self:setContentNodeScale(particle)
  elseif z == 1 then
    self.top_layer:addChild(particle)
    self:setContentNodeScale(particle)
  elseif z == 2 then
    ed.sceneui:addParticle_UI(particle)
  end
end

BattleScene.addParticle = addParticle

local function removeParticle(self, particle, z)
  z = z or 0
  if z < 0 then
    self.background_layer:removeChild(particle, true)
  elseif z == 0 then
    self.main_layer:removeChild(particle, true)
  elseif z == 1 then
    self.top_layer:removeChild(particle, true)
  elseif z == 2 then
    ed.sceneui:removeParticle_UI(particle)
  end
end

BattleScene.removeParticle = removeParticle

local function addSprite(self, sprite, z)
  z = z or 0
  if z < 0 then
    self.background_layer:addChild(sprite)
    self:fixBackLayerChildPos(sprite)
  elseif z == 0 then
    self.main_layer:addChild(sprite)
    self:setContentNodeScale(sprite)
  elseif z == 1 then
    self.top_layer:addChild(sprite)
    self:setContentNodeScale(sprite)
  elseif z == 2 then
    ed.sceneui:addSprite_UI(sprite)
  end
end

BattleScene.addSprite = addSprite

local function removeSprite(self, sprite, z)
  z = z or 0
  if z < 0 then
    self.background_layer:removeChild(sprite, true)
  elseif z == 0 then
    self.main_layer:removeChild(sprite, true)
  elseif z == 1 then
    self.top_layer:removeChild(sprite, true)
  elseif z == 2 then
    ed.sceneui:removeSprite_UI(sprite)
  end
end

BattleScene.removeSprite = removeSprite

local function delayPlayMusic(self, music)
  local function handler()
    if not ed.scene then
      return
    end
    if tolua.isnull(ed.scene.scene) then
      return
    end
    if ed.scene.scene:isRunning() then
      ed.playMusic(music)
      self.delayPlayMusicHandler = nil
    end
  end
  
  return handler
end

BattleScene.delayPlayMusic = delayPlayMusic

function BattleScene:setSpeedRate(speedRate)
  ed.setBattleSpeedIdx(1 < speedRate and 2 or 1)
end

local frame_count = 0
local elapsed_time = 0
local frame_time = 0
local fps = 0
local start_time = ed.getMillionTime()
local frame_records = {}

function BattleScene:calcFPS()
  if not ed.ui.server_ping then
    return
  end
  frame_count = frame_count + 1
  local current_time = ed.getMillionTime()
  elapsed_time = current_time - start_time
  if EDFLAGWIN32 then
    if ed.engine.ticks == 0 then
      frame_records = {}
    end
    table.insert(frame_records, {
      cur = current_time,
      ticks = ed.engine.ticks,
      time = current_time - frame_time,
      drive = ed.engine.driveByTypes or "null"
    })
    frame_time = current_time
  end
  if 0.25 <= elapsed_time then
    fps = frame_count / elapsed_time
    ed.ui.server_ping:refreshBattleFPS(fps)
    frame_count = 0
    start_time = current_time
  end
end

function BattleScene:recordOpsSync(tick, type, ops)
  local current_time = ed.getMillionTime()
  table.insert(frame_records, {
    cur = current_time,
    ticks = tick,
    type = type,
    ops = ops
  })
end

function BattleScene:saveFrameRecords()
  if EDFLAGWIN32 then
    local curTick = 1
    local curTime = 0
    local fileName = (ed.getDeviceId() or "") .. "_frame_records.txt"
    local fileWriter = io.open(fileName, "w")
    for i, v in ipairs(frame_records or {}) do
      if v.type then
        fileWriter:write(string.format("%s, ticks:%s, =======server========%s, %s\n", v.cur * 1000000, v.ticks, v.type, v.ops))
      elseif v.ticks == curTick then
        curTime = curTime + v.time
        fileWriter:write(string.format("%s, ticks:%s, frametime:%.1f, %s\n", v.cur * 1000000, v.ticks, v.time * 1000, v.drive))
      else
        fileWriter:write(string.format("%s, ticks:%s, frametime:%.1f, lastticktime:%.1f, %s\n", v.cur * 1000000, v.ticks, v.time * 1000, curTime * 1000, v.drive))
        curTick = v.ticks
        curTime = v.time
      end
    end
    fileWriter:close()
    frame_records = {}
    print("saveFrameRecords to " .. fileName)
  end
end

local insert = table.insert
local pairs = pairs
local ipairs = ipairs

local function update(self, dt)
  dt = dt * ed.getBattleSpeedRate()
  self.dt = dt
  local paused = false
  for k, v in pairs(self.pause_locks) do
    paused = paused or v
  end
  self:updateLoading(dt)
  if not self.fcaList then
    return
  end
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
  local sceneui = ed.sceneui
  if not paused and battle_tick.canUpdate(dt) then
    self:calcFPS(dt)
    ed.engine:update(dt)
    ed.trackMgr:checkFrame(dt)
    self.frames = self.frames + 1
    if self.background_fca then
      self.background_fca:update(dt)
    end
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
            insert(new_list, actor)
          else
            actor.node:removeFromParentAndCleanup(true)
            md.actor = nil
          end
        else
          insert(new_list, actor)
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
        insert(new_list, effect)
      end
    end
    self.effect_list = new_list
    if (self.auto_combat or self.battleModeInfo and self.battleModeInfo.guildInstanceInfo) and sceneui:isNextBtnEnable() then
      if not self.auto_next_timer then
        self.auto_next_timer = 1
      end
      self.auto_next_timer = self.auto_next_timer - dt
      if self.auto_next_timer <= 0 then
        sceneui:nextBtnTap()
      end
    end
    if self.isImageDamage then
      local damage = math.floor(ed.engine:getPlayerTotalDamage(ed.emCampPlayer))
      self.damage_account = damage - ed.dreamland.damage_step_goal * self.damage_step
      sceneui:setImageDamage(damage)
      if self.damage_account >= ed.dreamland.damage_step_goal then
        self.damage_step = self.damage_step + 1
        sceneui:playDamageGoalCompletedAnim(self.damage_step)
      end
    end
    sceneui:updateEchoSkill(dt)
  end
  if self.delayPlayMusicHandler then
    self.delayPlayMusicHandler()
  end
  sceneui:updateui(dt, paused)
end

BattleScene.update = update

local function onSceneFreezeBegin(self)
  self.background_node:setColor(ccc3(96, 96, 96))
  for _, effect in ipairs(self.effect_list) do
    effect:setActionSpeeder(0)
  end
end

BattleScene.onSceneFreezeBegin = onSceneFreezeBegin

local function onSceneFreezeEnd(self)
  self.background_node:setColor(ccc3(255, 255, 255))
  for _, effect in ipairs(self.effect_list) do
    effect:setActionSpeeder(1)
  end
end

BattleScene.onSceneFreezeEnd = onSceneFreezeEnd

local function onBackgroundHide(self, delay)
  self.background_node:runAction(CCFadeOut:create(delay))
end

BattleScene.onBackgroundHide = onBackgroundHide

local function onBackgroundAppear(self, delay, bgPath)
  if bgPath then
    self.backgroundPath = bgPath
    for index, bg in ipairs(self.bgList) do
      ed.setTexture(bg, "UI/alpha/1080P/" .. bgPath)
    end
    self:adaptBackground()
  end
  self.background_node:runAction(CCFadeIn:create(delay))
end

BattleScene.onBackgroundAppear = onBackgroundAppear
local ccp = ccp
local deepProjectionX = ed.deepProjectionX
local deepProjectionY = ed.deepProjectionY

local function toViewPosition(logical_position, height)
  local fixScale = ed.display.winSize.width / ed.engine.stage_rect.maxX
  local x = logical_position[1] * fixScale
  local y = ed.display.winSize.height / 2 + (logical_position[2] + height) * fixScale
  return FlipViewXPosition(ccp(x, y))
end

ed.toViewPosition = toViewPosition

local function toLogicPosition(viewPos, height)
  local fixScale = ed.display.winSize.width / ed.engine.stage_rect.maxX
  local x = viewPos[1] / fixScale
  local y = (viewPos[2] - ed.display.winSize.height / 2) / fixScale
  return FlipViewXPosition(ccp(x, y))
end

ed.toLogicPosition = toLogicPosition

local function playEffectOnScene(self, effect_name, origin, scale, height, zOrder, actionName, actionTime, angle)
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

BattleScene.playEffectOnScene = playEffectOnScene

local function playSpriteOnScene(self, spritePath, origin, scale, height, zOrder, angle)
  if ed.trackMgr.isShieldFullEffect then
    return nil
  end
  scale = scale or {1, 1}
  scale = FlipXVector(scale)
  height = height or 0
  local node
  local pos = FlipXPosition(origin)
  local vp = ed.toViewPosition(pos, height)
  node = ed.createSprite(spritePath)
  if angle ~= nil then
    node:setRotation(angle)
  end
  node:setPosition(vp)
  node:setScaleX(node:getScaleX() * scale[1])
  node:setScaleY(node:getScaleY() * scale[2])
  node:setZOrder(-origin[2])
  self:addSprite(node, zOrder)
  return node
end

BattleScene.playSpriteOnScene = playSpriteOnScene

local function showMonsterLoots(self, wave_idx, monster, lost_hp_per, old_lost_hp_per)
  local monster_idx = monster.monster_idx
  local dir_flag = monster.dir_flag or "right"
  local list
  if lost_hp_per then
    list = ed.player:getHpLootOfMonster(wave_idx, monster_idx, dir_flag, lost_hp_per, old_lost_hp_per)
  else
    list = ed.player:getStageLootOfMonster(wave_idx, monster_idx, dir_flag)
  end
  ed.sceneui:showMonsterLootsOnUI(list, monster)
end

BattleScene.showMonsterLoots = showMonsterLoots

function BattleScene:autoCombatHandler()
  local battleMode = self.battleModeInfo
  if battleMode.pvpInfo and battleMode.pvpInfo.pvpMode and battleMode.pvpInfo.pvpMode ~= "realarena" then
    ed.playEffect(ed.sound.deo.common_alert)
    ed.showToast(T("\231\171\158\230\138\128\229\156\186\228\184\173\229\143\170\229\133\129\232\174\184\232\135\170\229\138\168\230\136\152\230\150\151"))
  elseif battleMode.guildClashInfo then
    ed.playEffect(ed.sound.deo.common_alert)
    ed.showToast(T("\229\133\172\228\188\154\230\136\152\228\184\173\229\143\170\229\133\129\232\174\184\232\135\170\229\138\168\230\136\152\230\150\151"))
  elseif battleMode.peakArenaInfo then
    ed.playEffect(ed.sound.deo.common_alert)
    ed.showToast(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\228\184\173\229\143\170\229\133\129\232\174\184\232\135\170\229\138\168\230\136\152\230\150\151"))
  elseif battleMode.cupArenaInfo then
    ed.playEffect(ed.sound.deo.common_alert)
    ed.showToast(T("\229\165\179\231\165\158\228\185\139\230\136\152\228\184\173\229\143\170\229\133\129\232\174\184\232\135\170\229\138\168\230\136\152\230\150\151"))
  elseif battleMode.awakeStageInfo and ed.engine.stage_info["Ally Num"] > 5 then
    ed.playEffect(ed.sound.deo.common_alert)
    ed.showToast(T("\230\156\172\229\133\179\229\141\161\229\143\170\229\133\129\232\174\184\232\135\170\229\138\168\230\136\152\230\150\151"))
  elseif battleMode.creviceDefendInfo then
    ed.playEffect(ed.sound.deo.common_alert)
    ed.showToast(T("\230\156\172\229\133\179\229\141\161\229\143\170\229\133\129\232\174\184\232\135\170\229\138\168\230\136\152\230\150\151"))
  else
    ed.scene.auto_combat = not ed.scene.auto_combat
    if ed.engine.playerKaelHero then
      ed.engine.playerKaelHero.auto_combat = ed.scene.auto_combat
    end
    if ed.scene.auto_combat then
      ed.playEffect(ed.sound.battle.enableAuto)
    else
      ed.playEffect(ed.sound.battle.disenableAuto)
    end
    local currentMode = self:getCurrentMode(ed.scene)
    if "pve" == currentMode or currentMode == "awakeStage" or currentMode == "rogueMode" then
      ed.storage.setValue("BATTLE_" .. currentMode .. "_AUTO_COMBAT", ed.scene.auto_combat)
    end
  end
end

local function skipHandlerToNextBattle()
  if ed.debug_mode then
    ed.engine:passWaves(true)
  end
end

function BattleScene:isReplayMode()
  local currentMode = self:getCurrentMode()
  if ed.isElementInTable(currentMode, {
    "videoplayer",
    "replay"
  }) then
    return true
  end
end

function BattleScene:isShowCheckid()
  local currentMode = self:getCurrentMode()
  if ed.isElementInTable(currentMode, {"replay"}) then
    local replayInfo = self.battleModeInfo.replayInfo
    if replayInfo and replayInfo.notShow then
      return false
    end
    return true
  end
end

function BattleScene:canShowCalculateDamageUI()
  self.isImageDamage = false
  
  local function openDamageAccount()
    self.isImageDamage = true
    self.damage_account = 0
    if self:getCurrentMode() == "guildInstance" then
      self.damage_step = self.previous_damage_step or 0
    else
      self.damage_step = 0
    end
  end
  
  local currentMode = self:getCurrentMode()
  if self.battleModeInfo and self.battleModeInfo.replayInfo and self.battleModeInfo.replayInfo.dreamlandReplay then
    openDamageAccount()
    return true
  end
  if self.battleModeInfo and self.battleModeInfo.replayInfo and self.battleModeInfo.replayInfo.crevicedefendReplay then
    openDamageAccount()
    return true
  end
  if ed.isElementInTable(currentMode, {
    "dreamland",
    "guildInstance",
    "guildMountBoss",
    "dreamlandReplay",
    "crevicedefend"
  }) then
    openDamageAccount()
    return true
  end
  if currentMode == "videoplayer" then
    local mode = ed.scene.battleModeInfo.videoplayer.mode
    if ed.isElementInTable(mode, {
      "dreamland",
      "guildInstance"
    }) then
      openDamageAccount()
      return true
    end
  end
end

local function enterFVTimeZone(self)
  if not self.timer then
    return
  end
  if not self.FVTimeZoneLockTime then
    self.FVTimeZoneLockTime = self.timer.value
  end
  self.FVTimeZoneLevel = self.FVTimeZoneLevel and self.FVTimeZoneLevel + 1 or 1
end

BattleScene.enterFVTimeZone = enterFVTimeZone

local function exitFVTimeZone(self)
  if not self.timer then
    return
  end
  self.FVTimeZoneLevel = self.FVTimeZoneLevel and self.FVTimeZoneLevel > 1 and self.FVTimeZoneLevel - 1 or nil
  if not self.FVTimeZoneLevel then
    self.FVTimeZoneLockTime = nil
  end
end

BattleScene.exitFVTimeZone = exitFVTimeZone

local function ClearFVTimeZone(self)
  self.FVTimeZoneLevel = nil
  self.FVTimeZoneLockTime = nil
end

BattleScene.ClearFVTimeZone = ClearFVTimeZone

local function startCameraShakeAnimationY(self, maxShakeHeight, shakeTime, shakeNum)
  if nil ~= CCDirector:sharedDirector().startCameraAnimationY then
    CCDirector:sharedDirector():startCameraAnimationY(maxShakeHeight, shakeTime, shakeNum)
  end
end

BattleScene.startCameraShakeAnimationY = startCameraShakeAnimationY

local function stopCameraShakeAnimationY(self)
  if nil ~= CCDirector:sharedDirector().stopCameraAnimationY then
    CCDirector:sharedDirector():stopCameraAnimationY()
  end
end

BattleScene.stopCameraShakeAnimationY = stopCameraShakeAnimationY

local function startCameraShakeAnimationX(self, maxShakeHeight, shakeTime, shakeNum)
  if nil ~= CCDirector:sharedDirector().startCameraAnimationX then
    CCDirector:sharedDirector():startCameraAnimationX(maxShakeHeight, shakeTime, shakeNum)
  end
end

BattleScene.startCameraShakeAnimationX = startCameraShakeAnimationX

local function stopCameraShakeAnimationX(self)
  if nil ~= CCDirector:sharedDirector().stopCameraAnimationX then
    CCDirector:sharedDirector():stopCameraAnimationX()
  end
end

BattleScene.stopCameraShakeAnimationX = stopCameraShakeAnimationX

local function playZoomOnScene(self, origin, height, effect_name, actionName, actionTime, scale, zOrder, angle)
  scale = scale or {1, 1}
  scale = FlipXVector(scale)
  height = height or 0
  local zoomScale = 1.8
  local pos = FlipXPosition(origin)
  local vp = ed.toViewPosition(pos, height)
  local winSize = ed.display.winSize
  local halfWinSize_Width = winSize.width * 0.5
  local halfWinSize_Height = winSize.height * 0.5
  local offsetX = (halfWinSize_Width - vp.x) * zoomScale
  local offsetY = (halfWinSize_Height - vp.y) * zoomScale
  local contentSize = self.background_layer:getContentSize()
  local halfLayerWidth = contentSize.width * zoomScale * 0.5
  local halfLayerHeight = contentSize.height * zoomScale * 0.5
  offsetX = ed.clamp(offsetX, halfWinSize_Width - halfLayerWidth, halfLayerWidth - halfWinSize_Width)
  offsetY = ed.clamp(offsetY, halfWinSize_Height - halfLayerHeight, halfLayerHeight - halfWinSize_Height)
  local minY = halfWinSize_Height - halfLayerHeight
  local eft_node
  
  local function playEffect()
    print("playEffect")
    self:pauseBattle("zoomScene")
    effect_name = string.gsub(effect_name, "%.cha$", "")
    eft_node = ed.createFcaNode(effect_name)
    if actionName ~= nil and actionName ~= "" then
      eft_node:setStartAction(actionName)
    end
    if angle ~= nil then
      eft_node:setRotation(angle)
    end
    eft_node:setPosition(ccp(halfWinSize_Width, halfWinSize_Height))
    eft_node:setScaleX(eft_node:getScaleX() * scale[1])
    eft_node:setScaleY(eft_node:getScaleY() * scale[2])
    self.zoom_layer:addChild(eft_node)
    self:addFca(eft_node)
  end
  
  local function stopEffect()
    print("stopEffect")
    self.zoom_layer:setVisible(false)
    if eft_node then
      self:removeFca(eft_node)
    end
    self.zoom_layer:removeAllChildrenWithCleanup(true)
  end
  
  local function resumeBattleRun()
    print("resumeBattleRun")
    self:resumeBattle("zoomScene")
  end
  
  local speed = ed.getBattleSpeedRate()
  local zoomIn = 0.22
  zoomIn = zoomIn / speed
  local keepZoomIn = 0.19
  keepZoomIn = keepZoomIn / speed
  local moveUp = 0.19
  moveUp = moveUp / speed
  actionTime = actionTime / speed
  local keepTime = 0.5
  keepTime = keepTime / speed
  local zoomOut = 0.25
  zoomOut = zoomOut / speed
  local eft_width = 800
  local pause_battle_time = 2.3
  pause_battle_time = pause_battle_time / speed
  local after_resume_action_time = actionTime - pause_battle_time
  if after_resume_action_time <= 0 then
    after_resume_action_time = 0.03
  end
  
  local function blackBorder()
    print("stopEffect")
    self.zoom_layer:setVisible(true)
    local borderWidth = 130
    local leftBorder = CCLayerColor:create(ccc4(0, 0, 0, 255))
    leftBorder:setContentSize(CCSizeMake(borderWidth, ed.display.winSize.height))
    leftBorder:setPosition(ccp(-borderWidth, 0))
    self.zoom_layer:addChild(leftBorder, 100)
    local rightBorder = CCLayerColor:create(ccc4(0, 0, 0, 255))
    rightBorder:setContentSize(CCSizeMake(borderWidth, ed.display.winSize.height))
    rightBorder:setPosition(ccp(ed.display.winSize.width, 0))
    self.zoom_layer:addChild(rightBorder, 100)
    local moveInAction = CCMoveTo:create(moveUp, ccp(0, 0))
    leftBorder:runAction(moveInAction)
    moveInAction = CCMoveTo:create(moveUp, ccp(ed.display.winSize.width - borderWidth, 0))
    rightBorder:runAction(moveInAction)
  end
  
  local zoomInAction = CCSpawn:create(ccArrayMake({
    CCMoveTo:create(zoomIn, ccp(offsetX, offsetY)),
    CCScaleTo:create(zoomIn, zoomScale)
  }))
  local moveUpAction = CCEaseIn:create(CCMoveTo:create(moveUp, ccp(offsetX, minY)), 5)
  local zoomOutAction = CCSpawn:create(ccArrayMake({
    CCMoveTo:create(zoomOut, ed.ccpZero),
    CCScaleTo:create(zoomOut, 1)
  }))
  self.background_layer:runAction(CCSequence:create(ccArrayMake(zoomInAction, CCDelayTime:create(keepZoomIn), CCCallFunc:create(function()
    blackBorder()
  end), moveUpAction, CCCallFunc:create(function()
    playEffect()
  end), CCDelayTime:create(pause_battle_time), CCCallFunc:create(function()
    resumeBattleRun()
  end), CCDelayTime:create(after_resume_action_time), CCCallFunc:create(function()
    stopEffect()
  end), CCDelayTime:create(keepTime), zoomOutAction)))
  zoomInAction = CCSpawn:create(ccArrayMake({
    CCMoveTo:create(zoomIn, ccp(offsetX, offsetY)),
    CCScaleTo:create(zoomIn, zoomScale)
  }))
  moveUpAction = CCEaseIn:create(CCMoveTo:create(moveUp, ccp(offsetX, minY)), 5)
  zoomOutAction = CCSpawn:create(ccArrayMake({
    CCMoveTo:create(zoomOut, ed.ccpZero),
    CCScaleTo:create(zoomOut, 1)
  }))
  self.main_layer:runAction(CCSequence:create(ccArrayMake(zoomInAction, CCDelayTime:create(keepZoomIn), moveUpAction, CCDelayTime:create(actionTime + keepTime), zoomOutAction)))
  zoomInAction = CCSpawn:create(ccArrayMake({
    CCMoveTo:create(zoomIn, ccp(offsetX, offsetY)),
    CCScaleTo:create(zoomIn, zoomScale)
  }))
  moveUpAction = CCEaseIn:create(CCMoveTo:create(moveUp, ccp(offsetX, minY)), 5)
  zoomOutAction = CCSpawn:create(ccArrayMake({
    CCMoveTo:create(zoomOut, ed.ccpZero),
    CCScaleTo:create(zoomOut, 1)
  }))
  self.top_layer:runAction(CCSequence:create(ccArrayMake(zoomInAction, CCDelayTime:create(keepZoomIn), moveUpAction, CCDelayTime:create(actionTime + keepTime), zoomOutAction)))
end

BattleScene.playZoomOnScene = playZoomOnScene

local function updateLoading(self, dt)
  if ed.engine.wca_mode then
    self:loadingTimeOut(dt)
  end
  if self.loading == false and not battle_tick.canUpdate(dt) then
    ed.loadBegin(false, false)
    self.loading = true
  elseif self.loading == true and battle_tick.canUpdate(dt) then
    ed.loadEnd()
    self.loading = false
  end
end

BattleScene.updateLoading = updateLoading

local function loadingTimeOut(self, dt)
  if not self.loadingTime then
    self.loadingTime = 0
  end
  if self.loading == true then
    self.loadingTime = self.loadingTime + dt
  elseif self.loading == false then
    self.loadingTime = 0
  end
  if self.loadingTime >= 20 and not self.showAlert then
    self.showAlert = true
    ed.loadEnd()
    ed.showAlertDialog({
      text = T("\231\189\145\231\187\156\232\191\158\230\142\165\229\188\130\229\184\184\239\188\140\232\175\183\233\135\141\229\144\175\229\174\162\230\136\183\231\171\175\227\128\130"),
      buttonText = T("\233\128\128\229\135\186"),
      handler = function()
        EDExit()
      end
    })
  end
end

BattleScene.loadingTimeOut = loadingTimeOut
