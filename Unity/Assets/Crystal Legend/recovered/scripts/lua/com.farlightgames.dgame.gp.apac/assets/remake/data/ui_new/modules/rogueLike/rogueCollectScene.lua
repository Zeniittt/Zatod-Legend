local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueCollectScene = class
ed.UITool.registViewOpenFunc("rogueCollectScene", function()
  local scene = ed.ui.rogueCollectScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("rogueCollectScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:registerRedDot()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCollectScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.ui.destiny_enter_2:setZOrder(-1)
  self.ui.destiny_enter_3:setZOrder(-2)
  self.ui.event_enter_2:setZOrder(-1)
  self.ui.event_enter_3:setZOrder(-2)
  self.ui.script_enter_2:setZOrder(-1)
  self.ui.script_enter_3:setZOrder(-2)
  self:setBackButton()
  self:initLabels()
  ed.UITool.createSceneTitle(T("\230\148\182\232\151\143\229\174\164"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  self:adaptUI()
  self:refreshDestinyProgress()
  self:refreshEventProgress()
  self:showOpenAction()
  ed.rogueLikeNet.sendOpenScript()
end

function class:registerRedDot()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("rogue_collection_destiny_entry", self, {
    handle = function(value)
      self.ui.image_destiny_entry_red:setVisible(0 < value)
    end
  })
  self.redPointMgr:registerValueChange("rogue_collection_script_entry", self, {
    handle = function(value)
      self.ui.image_script_entry_red:setVisible(0 < value)
    end
  })
  self.redPointMgr:registerValueChange("rogue_collection_event_entry", self, {
    handle = function(value)
      self.ui.image_event_entry_red:setVisible(0 < value)
    end
  })
end

function class:onPopScene()
  self.redPointMgr:unregisterAllValueChange(self)
  base.onPopScene(self)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_destiny_desc, ed.toccc3(7879872), 1)
  self.ui.label_destiny_desc:setDimensions(CCSizeMake(108, 0))
  ed.setLabelStroke(self.ui.label_event_desc, ed.toccc3(4732701), 1)
  ed.setLabelStroke(self.ui.label_script_desc, ed.toccc3(8789117), 1)
  local destinyLabel = ed.ui.gradientLabel.create({
    text = T("\229\145\189\232\191\144"),
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(15312127),
    endColor = ed.toccc3(16776423),
    strokeColor = ed.toccc3(9715153),
    strokeSize = 1.5
  })
  self.ui.panel_destiny_name:addChild(destinyLabel.node)
  ed.layout.centerInParent(destinyLabel.node)
  self.destinyLabel = destinyLabel
  local scriptLabel = ed.ui.gradientLabel.create({
    text = T("\230\188\148\231\187\142\230\179\149"),
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16753903),
    endColor = ed.toccc3(16777215),
    strokeColor = ed.toccc3(8522896),
    strokeSize = 1.5
  })
  self.ui.panel_script_name:addChild(scriptLabel.node)
  ed.layout.centerInParent(scriptLabel.node)
  self.scriptLabel = scriptLabel
  local eventLabel = ed.ui.gradientLabel.create({
    text = T("\228\186\139\228\187\182"),
    fontSize = 36,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16770983),
    endColor = ed.toccc3(16776423),
    strokeColor = ed.toccc3(8676663),
    strokeSize = 1.5
  })
  self.ui.panel_event_name:addChild(eventLabel.node)
  ed.layout.centerInParent(eventLabel.node)
  self.eventLabel = eventLabel
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
end

function class:showOpenAction()
  self.ui.destiny_enter:setPositionY(self.ui.destiny_enter:getPositionY() + 150)
  self.ui.destiny_enter:runAction(CCEaseOut:create(CCMoveBy:create(0.2, ccp(0, -150)), 4))
  self.ui.destiny_enter_2:setRotation(8)
  self.ui.destiny_enter_3:setRotation(-7)
  self.ui.destiny_enter_2:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCEaseOut:create(CCRotateTo:create(0.3, 0), 4))))
  self.ui.destiny_enter_3:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCEaseOut:create(CCRotateTo:create(0.3, 0), 4))))
  self.ui.script_enter:setPositionY(self.ui.script_enter:getPositionY() + 150)
  self.ui.script_enter:runAction(CCEaseOut:create(CCMoveBy:create(0.2, ccp(0, -150)), 4))
  self.ui.script_enter_2:setRotation(8)
  self.ui.script_enter_3:setRotation(-7)
  self.ui.script_enter_2:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCEaseOut:create(CCRotateTo:create(0.3, 0), 4))))
  self.ui.script_enter_3:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCEaseOut:create(CCRotateTo:create(0.3, 0), 4))))
  self.ui.event_enter:setPositionY(self.ui.event_enter:getPositionY() + 150)
  self.ui.event_enter:runAction(CCEaseOut:create(CCMoveBy:create(0.2, ccp(0, -150)), 4))
  self.ui.event_enter_2:setRotation(-6)
  self.ui.event_enter_3:setRotation(15)
  self.ui.event_enter_2:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCEaseOut:create(CCRotateTo:create(0.3, 0), 4))))
  self.ui.event_enter_3:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCEaseOut:create(CCRotateTo:create(0.3, 0), 4))))
end

function class:refreshDestinyProgress()
  local total = 0
  for destinyId, destinyCfg in pairs(ed.getDataTable("RogueDestiny")) do
    total = total + 1 + #destinyCfg.RevelationBless + #destinyCfg.DestinyBless
  end
  local viewBlessAmount = #self.rogueLikeMgr:getViewBless()
  local viewDestinyAmount = #self.rogueLikeMgr:getViewRevelation()
  local progress = math.floor((viewBlessAmount + viewDestinyAmount) * 100 / total)
  ed.setLabelString(self.ui.label_destiny_progress, string.format("%s%%", progress))
end

function class:refreshScriptProgress()
  local scriptAmount = 0
  local getRewardAmount = 0
  for scriptId, rogueScriptCfg in pairs(ed.getDataTable("RogueScript")) do
    local openTime = ed.dateStringToTime(rogueScriptCfg["Open Time"])
    if openTime <= ed.getFitServerTime() then
      scriptAmount = scriptAmount + 1
      local rogueScript = self.rogueLikeMgr:getScriptRewardData(scriptId)
      if rogueScript._reward_time then
        getRewardAmount = getRewardAmount + 1
      end
    end
  end
  local progress = math.floor(getRewardAmount * 100 / scriptAmount)
  ed.setLabelString(self.ui.label_script_progress, string.format("%s%%", progress))
end

function class:refreshEventProgress()
  local eventAmount = 0
  for _, _ in ipairs(ed.getDataTable("RogueEvent")) do
    eventAmount = eventAmount + 1
  end
  local viewEvent = self.rogueLikeMgr:getViewEvent() or {}
  local progress = math.floor(#viewEvent * 100 / eventAmount)
  ed.setLabelString(self.ui.label_event_progress, string.format("%s%%", progress))
end

function class:onClickDestinyEnter()
  ed.UITool.openView("rogueCollectDestinyScene")
end

function class:onClickEventEnter()
  ed.UITool.openView("rogueCollectEventScene")
end

function class:onClickScriptEnter()
  ed.UITool.openView("rogueCollectScriptScene")
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "destiny_enter", function()
    self:onClickDestinyEnter()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "event_enter", function()
    self:onClickEventEnter()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "script_enter", function()
    self:onClickScriptEnter()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("rogueOpenScript", function()
    self:refreshScriptProgress()
  end)
  self:listenEvent("rogueScriptReward", function()
    self:refreshScriptProgress()
  end)
end
