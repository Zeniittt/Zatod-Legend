local guideManager = {}

local function init(self)
  ed.defineProperty(self, "guidingId", 0)
  ed.defineProperty(self, "preparingId", 0)
  ed.defineProperty(self, "controller", nil)
  ed.defineProperty(self, "topController", nil)
  ed.defineProperty(self, "checkResult", true)
  self.timerCount = 0
  self:listenEvents()
  return self
end

guideManager.debug = false
guideManager.isClosed = false

local function log(...)
  if not guideManager.debug then
    return
  end
  print(...)
end

guideManager.log = log

function guideManager:listenEvents()
  if guideManager.isClosed then
    return
  end
  self.scope = {}
  ListenEvent(ed.guide.eventNames.GUIDE_DATA_READY, function()
    self.layer = ed.guide.layer.create()
    self:deactiveLayer()
    CloseEvent(ed.guide.eventNames.GUIDE_DATA_READY)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.OPEN_VIEW, function(controller)
    log("OPEN_VIEW:" .. controller.identity)
    self:setTopController(controller)
    if self:isInPreparing() then
      self:startGuide(controller)
      return
    end
    if self:isInGuiding() then
      self:stopGuide()
    end
    self:checkGuideOpenView(controller)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.CLOSE_VIEW, function(controller)
    log("CLOSE_VIEW:" .. controller.identity)
    if not self:isGuideRunning() or self:isForceGuideRunning() then
      return
    end
    if ed.isElementInTable(controller.identity, self:getRunningData().ViewIdentity or {}) then
      self:stopGuide()
    end
  end, self.scope)
  ListenEvent(ed.guide.eventNames.GUIDE_NODE_CHANGE, function(node)
    if not self:isInGuiding() then
      return
    end
    local area = self.layer:getRelatedArea()
    if not area or area.node ~= node then
      return
    end
    self.layer:updateTouchAreas()
  end, self.scope)
  ListenEvent(ed.guide.eventNames.FUNCTION_OPEN, function(funcKey)
    self:checkGuideEvent(ed.guide.eventNames.FUNCTION_OPEN, funcKey)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.USE_SKILL_5V5, function(heroName)
    self:checkGuideEvent(ed.guide.eventNames.USE_SKILL_5V5, heroName)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.USE_SKILL, function()
    self:checkGuideEvent(ed.guide.eventNames.USE_SKILL)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.NEXT_WAVE, function()
    self:checkGuideEvent(ed.guide.eventNames.NEXT_WAVE)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.AFTER_DR, function()
    self:checkGuideEvent(ed.guide.eventNames.AFTER_DR)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.BATTLE_RESULT, function()
    self:checkGuideEvent(ed.guide.eventNames.BATTLE_RESULT)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.HERO_CAN_BE_SUMMONED, function()
    self:checkGuideEvent(ed.guide.eventNames.HERO_CAN_BE_SUMMONED)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.HERO_CAN_INCREASE_RANK, function()
    self:checkGuideEvent(ed.guide.eventNames.HERO_CAN_INCREASE_RANK)
  end, self.scope)
  ListenEvent(ed.guide.eventNames.COMPLETE_STAGE, function(stageId)
    self:checkGuideEvent(ed.guide.eventNames.COMPLETE_STAGE, stageId)
  end, self.scope)
end

function guideManager:checkGuideEvent(triggerEvent, eventParams)
  log("checkGuideEvent:", triggerEvent)
  local undoneIds = ed.guide.data:getUndoneIds()
  if not next(undoneIds) then
    return
  end
  log("checkGuideEvent:", tostring(eventParams))
  local startId
  for id, v in pairs(undoneIds) do
    local data = ed.guide.data:getStaticData(id)
    local checker = ed.guide.eventCheckers[triggerEvent]
    if ed.guide.data:isCanGuide(id) and data.TriggerEvent == triggerEvent and (not checker or checker.doCheck(data.TriggerParams, eventParams)) then
      log("checkGuideEvent:success!" .. triggerEvent)
      startId = startId or id
      if 11 < id then
        ed.guide.data:recordTrigger(id)
      end
    end
  end
  if not self:isGuideRunning() and startId then
    self:tryStartGuide(startId)
  end
end

function guideManager:checkGuideOpenView(controller)
  if self:isGuideRunning() then
    return
  end
  local undoneIds = ed.guide.data:getUndoneIds()
  if not next(undoneIds) then
    return
  end
  self:setController(controller)
  for id, v in pairs(undoneIds) do
    local data = ed.guide.data:getStaticData(id)
    if ed.guide.data:isCanGuide(id) and (not (not ed.guide.data:isTriggered(id) and data.TriggerEvent) or data.TriggerEvent == "") and ed.isElementInTable(controller.identity, data.ViewIdentity or {}) then
      self:tryStartGuide(id)
      return
    end
  end
end

function guideManager:tryStartGuide(id)
  log("tryStartGuide:", id)
  local data = ed.guide.data:getStaticData(id)
  local controller = self:getController()
  if controller and ed.isElementInTable(controller.identity, data.ViewIdentity or {}) then
    self:startGuide(controller, id)
  else
    self:prepareGuide(id)
  end
end

function guideManager:prepareGuide(id)
  if self:isGuideRunning() then
    return
  end
  self:setPreparingId(id)
  FireEvent(ed.guide.eventNames.GUIDE_PREPARE, id)
  log("prepareGuide:" .. id)
end

function guideManager:startGuide(controller, guideId, ignoreDelay)
  if self:isInGuiding() then
    return
  end
  local id = guideId or self:getPreparingId()
  local data = ed.guide.data:getStaticData(id)
  if not ed.isElementInTable(controller.identity, data.ViewIdentity or {}) then
    return
  end
  if not ignoreDelay and data.Delay and data.Delay > 0 then
    ListenTimer(Timer:Once(data.Delay), function()
      self:startGuide(controller, guideId, true)
    end)
    return
  end
  log("startGuide:" .. id)
  FireEvent(ed.guide.eventNames.GUIDE_START, id)
  local nodeKey = data.TargetNode
  log("nodeKey:" .. tostring(nodeKey))
  if nodeKey and nodeKey ~= "" then
    local node, area = controller:getGuideNode(nodeKey)
    local relatedNode, relatedArea = controller:getGuideRelatedNode(nodeKey)
    local clipRect = controller:getGuideClipRect(nodeKey)
    if not node or tolua.isnull(node) then
      EDLog("node is nil! guide failed! ID = " .. id)
      if self.timerCount > 4 or controller ~= self:getTopController() then
        self:stopGuide()
        return
      end
      self.timerCount = self.timerCount + 1
      ListenTimer(Timer:Once(0.1), function()
        self:startGuide(controller, guideId, true)
      end)
      return
    end
    if not area then
      area = ed.guide.helper.createNodeTouchArea(node)
    else
      area.node = node
    end
    if relatedNode then
      if not relatedArea then
        relatedArea = ed.guide.helper.createNodeTouchArea(relatedNode)
      else
        relatedArea.node = relatedNode
      end
    end
    self.layer:setTouchArea(area, relatedArea)
    self.layer:setClipRect(clipRect)
  else
    self.layer:clear()
  end
  self.timerCount = 0
  self:setController(controller)
  self:setGuidingId(id)
  self:setPreparingId(0)
  self:activeLayer(data)
  FireEvent(ed.guide.eventNames.GUIDE_PROGRESSING, id)
end

function guideManager:completeGuide()
  if not self:isInGuiding() then
    return
  end
  if not self:getCheckResult() then
    self:setCheckResult(true)
    log("check result fail!")
    return
  end
  local id = self:getGuidingId()
  ed.guide.data:saveRecord(id)
  ed.reportHUE({
    action_type = "complete_guide",
    guide_id = id
  })
  self:setGuidingId(0)
  FireEvent(ed.guide.eventNames.GUIDE_COMPLETE, id)
  log("completeGuide:" .. id)
  local data = ed.guide.data:getStaticData(id)
  if data.IsSoft or data.NextID == 0 then
    self:deactiveLayer()
  else
    self.layer:clear()
  end
  if 0 < data.NextID then
    self:tryStartGuide(data.NextID)
  else
    self:checkGuideOpenView(self:getController())
  end
  if id == 23 and EDReportEvent then
    EDReportEvent("tutorial_complete", "")
  end
end

function guideManager:completeGuideChain(controller)
  if not self:isInGuiding() then
    return
  end
  local id = self:getGuidingId()
  local data
  if controller then
    repeat
      ed.guide.data:saveRecord(id)
      data = ed.guide.data:getStaticData(id)
      id = data.NextID or 0
    until id == 0 or not ed.isElementInTable(controller.identity, data.ViewIdentity or {})
    return
  end
  repeat
    ed.guide.data:saveRecord(id)
    data = ed.guide.data:getStaticData(id)
    id = data.NextID or 0
  until id == 0
end

function guideManager:stopGuide(id)
  if not self:isGuideRunning() then
    return
  end
  if id and id ~= self:getRunningData().ID then
    return
  end
  self:setGuidingId(0)
  self:setPreparingId(0)
  self:deactiveLayer()
  log("stopGuide")
end

function guideManager:closeGuide()
  self:stopGuide()
  CloseScope(self.scope)
  log("closeGuide")
end

function guideManager:isInGuiding()
  return self:getGuidingId() > 0
end

function guideManager:isInPreparing()
  return self:getPreparingId() > 0
end

function guideManager:isGuideRunning()
  return self:isInGuiding() or self:isInPreparing()
end

function guideManager:isForceGuideRunning()
  if not self:isGuideRunning() then
    return false
  end
  return not self:getRunningData().IsSoft
end

function guideManager:getRunningData()
  local id = self:getGuidingId()
  if self:isInPreparing() then
    id = self:getPreparingId()
  end
  return ed.guide.data:getStaticData(id)
end

function guideManager:skipGuide(id)
  if id == self:getPreparingId() then
    self:stopGuide()
    ed.guide.data:saveRecord(id)
    return
  end
  if id == self:getGuidingId() then
    self:completeGuide()
    return
  end
  ed.guide.data:saveRecord(id)
end

function guideManager:skipAllGuide()
  ed.guide.data:clear()
  self:closeGuide()
end

function guideManager:getGuidingNodes()
  local controller = self:getController()
  if not controller then
    return
  end
  local id = self:getGuidingId()
  local data = ed.guide.data:getStaticData(id)
  if not data then
    return
  end
  local nodeKey = data.TargetNode
  if not nodeKey or nodeKey == "" then
    return
  end
  local node, _ = controller:getGuideNode(nodeKey)
  local relatedNode, _ = controller:getGuideRelatedNode(nodeKey)
  return node, relatedNode
end

function guideManager:activeLayer(data)
  if not self.layer then
    return
  end
  self.layer:active(data)
end

function guideManager:deactiveLayer()
  if not self.layer then
    return
  end
  return self.layer:deactive()
end

ed.guide.manager = init(guideManager)
