local base = ed.ui.commonscene
local SoloBattleScene = {}
local SoloBattleScene = newclass(base.mt)
ed.SoloBattleScene = SoloBattleScene

function SoloBattleScene:initData()
  ed.enableFcaAutoRelease(false)
  self.actor_list = {}
  self.effect_list = {}
  self.frames = 0
  self.speedRate = 1
  self.fcaList = {}
  self.battleModeInfo = {SoloMode = true}
  self.backgroundPath = "chesscard/chess_card_bg2.jpg"
  self.lastSync = 0
  self.count = 0
end

function SoloBattleScene:adaptUI()
  ed.layout.adaptBG(self.background, "X")
  self.contentScale = self.background:getScale()
end

function SoloBattleScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.SoloBattleScene)
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
  ed.setTexture(self.background, "UI/alpha/1080P/" .. self.backgroundPath)
end

function SoloBattleScene:getCurrentMode()
  return "SoloMode"
end

function SoloBattleScene.create()
  local self = base.create("SoloBattleScene", {noBottomButton = true})
  setmetatable(self, SoloBattleScene.mt)
  self:initData()
  self:initUI()
  ed.scene = self
  ed.sceneui = self
  self:registerOnEnterHandler("SoloBattleSceneEnter", function()
    self.SoloPanel = ed.ui.SoloMainPanel.create()
    self.SoloPanel:setBattleScene(self)
    self.SoloPanel:popWindow()
  end)
  self:registerOnExitHandler("SoloBattleSceneExit", function()
    ed.engine = ed.commonEngine
    ed.scene = ed.commonBattleScene
    ed.sceneui = ed.commonBattleSceneUI
    ed.PopupCreate = ed.tmpPopupCreate
  end)
  self:listenEvent("EventSoloBattleCheckEnd", function(winCamp)
    self.endFlag = true
    self.count = 0
    self.mainLayer:setContentSize(CCSizeMake(ed.display.winSize.width, ed.display.winSize.height))
    if winCamp == 1 then
      self.mainLayer:setAnchorPoint(ccp(0.8, 0.5))
    else
      self.mainLayer:setAnchorPoint(ccp(0.2, 0.5))
    end
    self.mainLayer:runAction(CCSequence:create(ccArrayMake({
      CCEaseSineOut:create(CCScaleTo:create(0.4, 1.3)),
      CCDelayTime:create(1.7),
      CCEaseSineOut:create(CCScaleTo:create(0.9, 1))
    })))
  end)
  return self
end

function SoloBattleScene:soloBattleEnd(dt)
  self.count = self.count + dt
  if self.count < 3 then
    self:setSpeedRate(0.4 + self.count / 2 * 0.6)
  else
    self.endFlag = false
    self.scene:setAnchorPoint(ccp(0, 0))
  end
end

function SoloBattleScene:exit()
  ed.stopMusic()
  ed.playMusic(ed.music.map)
  ed.SoloBattleEngine:exitStage(2, true)
  self:removeSoloPanel()
  ed.enableFcaAutoRelease(true)
  ed.popScene()
  ed.openMemeryGC = true
  ed.memeryGC(10)
end

function SoloBattleScene:setContentNodeScale(node)
  local sx, sy = node:getScaleX(), node:getScaleY()
  node:setScaleX(self.contentScale * sx)
  node:setScaleY(self.contentScale * sy)
end

function SoloBattleScene:addActor(actor)
  if actor.node then
    table.insert(self.actor_list, actor)
    self.ui.main_layer:addChild(actor.node)
    self:setContentNodeScale(actor.node)
  end
end

function SoloBattleScene:syncActors()
  if self.lastSync ~= ed.engine.ticks then
    self.lastSync = ed.engine.ticks
    for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
      if unit:isAlive() and not unit.actor then
        unit.actor = ed.SoloUnitActorCreate(unit)
        self:addActor(unit.actor)
      end
    end
  end
end

function SoloBattleScene:addEffect(effect, z)
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

function SoloBattleScene:removeEffect(effect, z)
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

function SoloBattleScene:addParticle(particle, z)
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

function SoloBattleScene:removeParticle(particle, z)
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

function SoloBattleScene:setSpeedRate(speedRate)
  self.speedRate = speedRate
end

function SoloBattleScene:updateActors(dt)
  local new_list = {}
  for _, actor in ipairs(self.actor_list) do
    local md = actor.model
    local isTerminated = md.terminated
    if md.what == "SoloUnit" and not isTerminated then
      isTerminated = actor.is_terminated
    end
    if isTerminated then
      actor.node:removeFromParentAndCleanup(true)
      md.actor = nil
    else
      actor:update(dt)
      table.insert(new_list, actor)
    end
  end
  self.actor_list = new_list
end

function SoloBattleScene:updateEffect(dt)
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

function SoloBattleScene:updateUI(dt)
  if self.SoloPanel then
    self.SoloPanel:update(self.dt, dt)
  end
end

function SoloBattleScene:update(dt)
  self.dt = dt * self.speedRate
  self:updateFca(self.dt)
  ed.engine:update(self.dt)
  self:syncActors()
  self:updateActors(self.dt)
  self:updateEffect(self.dt)
  self:updateUI(dt)
  self.frames = self.frames + 1
  if self.endFlag then
    self:soloBattleEnd(self.dt)
  end
end

function SoloBattleScene:playEffectOnScene(effectName, origin, scale, height, zOrder, actionName, actionTime, angle)
  scale = scale or {1, 1}
  scale = FlipXVector(scale)
  height = height or 0
  local node
  local pos = FlipXPosition(origin)
  local vp = ed.toViewPosition(pos, height)
  effectName = string.gsub(effectName, "%.cha$", "")
  node = ed.createFcaNode(effectName)
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

function SoloBattleScene:removeSoloPanel()
  local panel = self.SoloPanel
  if not tolua.isnull(panel) then
    panel:destroy()
  end
end
