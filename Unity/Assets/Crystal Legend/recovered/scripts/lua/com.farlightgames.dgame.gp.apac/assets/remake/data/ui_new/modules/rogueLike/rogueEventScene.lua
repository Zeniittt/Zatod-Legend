local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueEventScene = class
ed.UITool.registViewOpenFunc("rogueEventScene", function(param)
  local window = ed.getPopWindow("rogueEventScene")
  if window then
    window:initData(param)
    window:refreshView()
  else
    window = ed.ui.rogueEventScene.create(param)
    window:popWindow()
  end
end)

function class.create(param)
  local self = base.create("rogueEventScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self:initData(param)
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.rogueEventTB = ed.getDataTable("RogueEvent")
  self.rogueChoiceTB = ed.getDataTable("RogueChoice")
  self.rogueResultTB = ed.getDataTable("RogueResult")
  self.optionBtnList = {}
  self.isShowOption = false
  self:initView()
  self:addEventListener()
  self:addTouchEvent()
  self:refreshView()
  self:showOpenAction()
end

function class:initData(param)
  param = param or {}
  self.event = param.event or {}
  self.choiceIndex = param.choiceIndex
  self.rogueChoice = self.event._choices[self.choiceIndex]
  self.eventId = self.event._event_id
end

function class:initEventData()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueEventScene)
  self.container:addChild(container)
  self.ui = ui
  local eventCfg = self.rogueEventTB[self.eventId]
  ed.setLabelString(self.ui.label_title, eventCfg.Title)
  local eventIcon = string.format("UI/alpha/1080P/rogue/instance/event/%s", eventCfg["Event Banner"])
  ed.setTexture(self.ui.image_event_type, eventIcon, true)
  self:adaptUI()
  self:initLabels()
  self:initParticle()
  self:initDescDragList()
end

function class:adaptUI()
  local diffWidth = ed.display.winSize.width - 960
  local oldPanelSize = self.ui.panel_option:getContentSize()
  self.ui.panel_option:setContentSize(CCSizeMake(oldPanelSize.width + diffWidth / 2, oldPanelSize.height))
  local oldPanelDescSize = self.ui.panel_desc:getContentSize()
  self.ui.panel_desc:setContentSize(CCSizeMake(oldPanelDescSize.width + diffWidth / 2, oldPanelDescSize.height))
  self.ui.label_title:setPositionX(self.ui.label_title:getPositionX() + diffWidth / 4)
  self.ui.image_title_dec_left:setPositionX(self.ui.label_title:getPositionX() - self.ui.label_title:getContentSize().width / 2 - self.ui.image_title_dec_right:getContentSize().width * 0.5 - 35)
  self.ui.image_title_dec_right:setPositionX(self.ui.label_title:getPositionX() + self.ui.label_title:getContentSize().width / 2 + self.ui.image_title_dec_right:getContentSize().width * 0.5 + 35)
  ed.layout.layoutWithMagin(self.ui.image_pearl_bg, {right = 10, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_retry_bg, {right = 120, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_team, {
    left = 10 + ed.display.getNotchHeight()
  }, false, true)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(10177828), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  ed.setLabelStroke(self.ui.label_team, ed.toccc3(3745055), 1)
end

function class:initParticle()
  local particle = CCParticleSystemQuad:create("UI/particle/guangd.plist")
  self.ui.image_bg:addChild(particle, 5)
  particle:setPosition(ccp(300, 100))
end

function class:showOpenAction()
  self.ui.image_bg:setOpacity(0)
  self.ui.image_bg:runAction(CCFadeIn:create(0.3))
  self.ui.image_right_bg:setOpacity(0)
  self.ui.image_right_bg:setPositionX(self.ui.image_right_bg:getPositionX() + 150)
  self.ui.image_right_bg:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.2, ccp(-150, 0)), CCFadeIn:create(0.3))))
  self.ui.event_bg_1:setOpacity(0)
  self.ui.event_bg_2:setOpacity(0)
  self.ui.event_bg_3:setOpacity(0)
  self.ui.image_event_type:setOpacity(0)
  self.ui.event_bg_2:setRotation(20)
  self.ui.event_bg_3:setRotation(-15)
  local offsetY = 200
  self.ui.event_bg_1:setPositionY(self.ui.event_bg_1:getPositionY() + offsetY)
  self.ui.event_bg_2:setPositionX(self.ui.event_bg_2:getPositionX() + 50)
  self.ui.event_bg_2:setPositionY(self.ui.event_bg_2:getPositionY() + offsetY)
  self.ui.event_bg_3:setPositionX(self.ui.event_bg_3:getPositionX() - 50)
  self.ui.event_bg_3:setPositionY(self.ui.event_bg_3:getPositionY() + offsetY)
  local moveAction1 = CCSpawn:create(ccArrayMake(CCFadeIn:create(0.25), CCMoveBy:create(0.25, ccp(0, -offsetY))))
  self.ui.event_bg_1:runAction(moveAction1)
  local moveAction2 = CCSpawn:create(ccArrayMake(CCFadeIn:create(0.25), CCMoveBy:create(0.25, ccp(0, -offsetY))))
  local rotaAction2 = CCSpawn:create(ccArrayMake(CCEaseOut:create(CCRotateTo:create(0.25, 0), 4), CCMoveBy:create(0.25, ccp(-50, 0))))
  self.ui.event_bg_2:runAction(CCSequence:create(ccArrayMake(moveAction2, rotaAction2)))
  local moveAction3 = CCSpawn:create(ccArrayMake(CCFadeIn:create(0.25), CCMoveBy:create(0.25, ccp(0, -offsetY))))
  local rotaAction3 = CCSpawn:create(ccArrayMake(CCEaseOut:create(CCRotateTo:create(0.25, 0), 4), CCMoveBy:create(0.25, ccp(50, 0))))
  self.ui.event_bg_3:runAction(CCSequence:create(ccArrayMake(moveAction3, rotaAction3)))
  self.ui.image_event_type:setPositionY(self.ui.image_event_type:getPositionY() + offsetY)
  self.ui.image_event_type:runAction(CCSpawn:create(ccArrayMake(CCFadeIn:create(0.25), CCMoveBy:create(0.25, ccp(0, -offsetY)))))
  self.ui.label_title:setOpacity(0)
  self.ui.image_title_dec_left:setOpacity(0)
  self.ui.image_title_dec_right:setOpacity(0)
  self.ui.label_title:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2), CCFadeIn:create(0.2))))
  self.ui.image_title_dec_left:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2), CCFadeIn:create(0.2))))
  self.ui.image_title_dec_right:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2), CCFadeIn:create(0.2))))
  for index, item in ipairs(self.descDragList.listItems) do
    item:setOpacity(0)
    item:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2 + index * 0.1), CCFadeIn:create(0.4))))
  end
  local delayTime = #self.descDragList.listItems * 0.2
  self.ui.image_line:setOpacity(0)
  self.ui.image_line:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime + 0.1), CCFadeIn:create(0.4))))
  self.ui.btn_continue:setCascadeOpacityEnabled(true)
  self.ui.btn_continue:setOpacity(0)
  self.ui.btn_continue:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime + 0.2), CCFadeIn:create(0.4))))
end

function class:initDescDragList()
  self.descDragList = ed.UITool.createDraglist(self.ui.panel_desc)
  self.optionDragList = ed.UITool.createDraglist(self.ui.panel_option, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    priority = -300
  })
end

function class:getPressInHandler()
  local function handle(x, y)
    if not self.ui.panel_option:isVisible() then
      return
    end
    for _, btnCfg in ipairs(self.optionBtnList) do
      local btn = btnCfg.btn
      if ed.containsPoint(btn, x, y) then
        btn:setScale(0.95)
        return btnCfg
      end
    end
  end
  
  return handle
end

function class:getClickInHandler()
  local function handle(x, y, btnCfg)
    if btnCfg then
      local btn = btnCfg.btn
      
      if ed.containsPoint(btn, x, y) then
        self:onClickOption(btnCfg)
      end
    end
  end
  
  return handle
end

function class:getCancelPressInHandler()
  local function handle(x, y, btnCfg)
    if btnCfg then
      btnCfg.btn:setScale(1)
    end
  end
  
  return handle
end

function class:refreshView()
  self.ui.panel_desc:setVisible(not self.isShowOption)
  self.ui.panel_option:setVisible(self.isShowOption)
  self:refreshDragList()
  self:refreshOptionList()
  self:refreshPearlAmount()
  self:refreshRetryTimesAmount()
end

function class:refreshOptionList()
  self.optionDragList:clearList()
  self.optionBtnList = {}
  local choiceGroup = self.rogueChoice._choice
  local panelSize = self.ui.panel_option:getContentSize()
  local posY = 0
  for choiceId, choiceCfg in ipairs(self.rogueChoiceTB[choiceGroup] or {}) do
    local btn, isEnable, tips = self:createEventChoiceBtn(choiceGroup, choiceId)
    table.insert(self.optionBtnList, {
      btn = btn,
      choiceId = choiceId,
      isEnable = isEnable,
      tips = tips
    })
    local btnSize = btn:getContentSize()
    self.optionDragList:addItem(btn)
    btn:setPosition(ccp(panelSize.width / 2, panelSize.height - posY - btnSize.height / 2))
    posY = posY + btnSize.height + 8
  end
  self.optionDragList:initListHeight(posY)
end

function class:refreshDragList()
  self.descDragList:clearList()
  local panelSize = self.ui.panel_desc:getContentSize()
  local posY = 0
  local desc = self.rogueEventTB[self.eventId].Des
  local descLabel, w, h = self:createDescLabel(desc)
  self.descDragList:addItem(descLabel)
  descLabel:setPosition(ccp(0, panelSize.height - posY - 12))
  posY = posY + h + 18
  for _, choices in ipairs(self.event._choices or {}) do
    local resultGroup = choices._result_group
    local resultId = choices._result_id
    if resultGroup and 0 < resultGroup and resultId and 0 < resultId then
      local resultDesc = self.rogueResultTB[resultGroup][resultId].Des
      local resultDescLabel, w, h = self:createDescLabel(resultDesc)
      self.descDragList:addItem(resultDescLabel)
      resultDescLabel:setPosition(ccp(0, panelSize.height - posY - 12))
      posY = posY + h + 10
    end
  end
  self.descDragList:initListHeight(posY)
  if posY > panelSize.height then
    self.descDragList:setListPos(ccp(0, posY - panelSize.height))
  end
  local posY = math.min(posY, panelSize.height)
  self.ui.image_line:setPositionX(panelSize.width / 2)
  self.ui.image_line:setPositionY(panelSize.height - posY)
  self.ui.image_line:setContentSize(CCSizeMake(panelSize.width - 20, 1))
  posY = posY + 23
  local btnSize = self.ui.btn_continue:getContentSize()
  self.ui.btn_continue:setPosition(ccp(panelSize.width / 2, panelSize.height - posY - btnSize.height / 2))
  local resultId = self.rogueChoice._result_id
  local btnText = resultId and 0 < resultId and T("\231\187\147\230\157\159") or T("\231\187\167\231\187\173")
  ed.setLabelString(self.ui.label_continue, btnText)
end

function class:createDescLabel(text)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    color = ccc3(205, 190, 139),
    fontSize = 24,
    maxWidth = self.ui.panel_desc:getContentSize().width
  })
  local w, h = autoText:getCurContentSize()
  return autoText.node, w, h
end

function class:createEventChoiceBtn(choiceGroup, choiceId)
  local choiceCfg = self.rogueChoiceTB[choiceGroup][choiceId]
  local isEnable, tips, extraVisible = self:checkChoiceBtnEnable(choiceGroup, choiceId)
  local btnBgPath
  if isEnable or extraVisible then
    btnBgPath = "UI/alpha/1080P/rogue/instance/instance_event_choice_button2.png"
  else
    btnBgPath = "UI/alpha/1080P/rogue/instance/instance_event_choice_button3.png"
  end
  local btnBg = ed.createSprite(btnBgPath)
  local titleLabel = ed.createttf(choiceCfg["Choice Describe"], 21)
  ed.setLabelColor(titleLabel, ed.toccc3(16774864))
  ed.setLabelStroke(titleLabel, ed.toccc3(10580513), 1)
  titleLabel:setAnchorPoint(ccp(0, 0.5))
  btnBg:addChild(titleLabel)
  ed.layout.layoutWithParentMagin(titleLabel, {left = 25, top = 12})
  local resultDescLabel = ed.createttf(choiceCfg["Result Describe"], 18)
  ed.setLabelDimensions(resultDescLabel, CCSizeMake(430, 0))
  ed.setLabelColor(resultDescLabel, ed.toccc3(15188857))
  resultDescLabel:setAnchorPoint(ccp(0, 0.5))
  resultDescLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
  resultDescLabel:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
  btnBg:addChild(resultDescLabel)
  ed.layout.layoutWithParentMagin(resultDescLabel, {left = 25})
  resultDescLabel:setPositionY(36.5)
  return btnBg, isEnable, tips
end

function class:checkChoiceBtnEnable(choiceGroup, choiceId)
  local choiceCfg = self.rogueChoiceTB[choiceGroup][choiceId]
  local resultGroup = choiceCfg["Result Group"]
  for resultId, resultCfg in ipairs(self.rogueResultTB[resultGroup] or {}) do
    for index = 1, 20 do
      local rewardType = resultCfg[string.format("Reward Type %s", index)]
      local param = resultCfg[string.format("Reward Param %s", index)]
      if not rewardType then
        break
      end
      local isEnable, tips, extraVisible = self.rogueLikeMgr:getRogueEventChoiceEnable(rewardType, param)
      if not isEnable then
        return false, tips, extraVisible
      end
    end
  end
  return true
end

function class:refreshPearlAmount()
  local pearl = self.rogueLikeMgr:getPearl()
  ed.setLabelString(self.ui.pearl_amount, pearl)
end

function class:refreshRetryTimesAmount()
  local leftTime = self.rogueLikeMgr:getRetryTimes()
  ed.setLabelString(self.ui.retry_amount, string.format("%s", leftTime))
end

function class:onClickBtnContinues()
  local resultId = self.rogueChoice._result_id
  if resultId and 0 < resultId then
    self:destroy({skipAnim = true})
  else
    self.isShowOption = true
    self:refreshView()
  end
end

function class:onClickOption(btnCfg)
  local isEnable = btnCfg.isEnable
  local tips = btnCfg.tips
  if not isEnable then
    if tips then
      ed.showToast(tips)
    end
    return
  end
  local choiceId = btnCfg.choiceId
  local index = self.rogueChoice._index
  ed.rogueLikeNet.sendChooseChoice(index, choiceId)
end

function class:onClickBtnTeam()
  local rogueTeamWindow = ed.ui.rogueTeamWindow.create({skipAnim = true, noShade = true})
  rogueTeamWindow:popWindow()
  ed.layout.relateLayout(self.ui.btn_team, rogueTeamWindow.ui.image_bg, {
    right = self.ui.btn_team:getContentSize().width / 2 - rogueTeamWindow.ui.image_bg:getContentSize().width
  })
  ed.layout.layoutWithMagin(rogueTeamWindow.ui.image_bg, {bottom = 0})
  rogueTeamWindow:showOpenAction()
end

function class:addEventListener()
  self:listenEvent("rogueChooseChoice", function(event)
    self.event = event
    self.eventId = self.event._event_id
    self.rogueChoice = self.event._choices[self.choiceIndex]
    self.isShowOption = false
    self:refreshView()
  end)
  self:listenEvent("rogueStartBattle", function()
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("rogueUpdatePearlAmount", function()
    self:refreshPearlAmount()
  end)
  self:listenEvent("rogueUpdateRetryTimes", function()
    self:refreshRetryTimesAmount()
  end)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_team", function()
    self:onClickBtnTeam()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_continue", function()
    self:onClickBtnContinues()
  end, {pressScale = 0.95})
end
