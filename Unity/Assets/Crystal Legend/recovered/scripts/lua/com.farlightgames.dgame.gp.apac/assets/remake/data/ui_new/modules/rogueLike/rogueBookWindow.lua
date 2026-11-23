local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueBookWindow = class
ed.UITool.registViewOpenFunc("rogueBookWindow", function(param)
  ed.ui.rogueBookWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueBookWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.bookId = param.bookId or 1
  self.closeCallBack = param.closeCallBack
  self.selectDiff = self:getBookDiffSelect()
  self.diffTabBtnList = {}
  self.bookCfg = ed.getDataTable("RogueBook")[self.bookId]
  self.chapterId = self.bookCfg["Chapter Group"]
  self.rogueChapterCfg = ed.getDataTable("RogueChapter")[self.chapterId]
  self.firstPassRewardList = {}
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.curChapter = self.rogueLikeMgr:getCurChapter()
  self.crisisGroupId = 0
  self.crisisDiff = 0
  self.crisisMax = 0
  if self.curChapter._chapter_id == self.chapterId then
    self.selectDiff = self.curChapter._difficulty
    self.crisisDiff = self.curChapter._crisis or 0
  end
  self.isShowBlackBook = 0 < self.crisisDiff
  local techTreeId = self.rogueChapterCfg[1]["Tech Tree ID"]
  if 0 < techTreeId then
    ed.rogueLikeNet.sendOpenTech(self.chapterId)
  end
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:showOpenAction()
  self:registerRedDot()
  self.redPointMgr:setNodeValue("rogue_book_" .. self.bookId, 0)
end

function class:getBookDiffSelect()
  local key = ed.getRoleKey("RogueBook_Diff_" .. self.bookId)
  local storageDiff = ed.storage.getInt(key)
  if not storageDiff or storageDiff == 0 then
    storageDiff = 1
  end
  return storageDiff
end

function class:saveBookDiffSelect()
  local key = ed.getRoleKey("RogueBook_Diff_" .. self.bookId)
  ed.storage.setValue(key, self.selectDiff or 1)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBookWindow)
  self.container:addChild(container, 1)
  self.ui = ui
  self.ui.image_bg:setOpacity(0)
  self:initLabels()
  self:adaptUI()
  self:initEffect()
  self:initDiffButtons()
  self:initRewardDragList()
  local _, titleTxt = ed.UITool.createSceneTitle(T("\233\128\137\230\139\169\230\149\133\228\186\139"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  ed.setTexture(self.ui.image_map, self.bookCfg["Show Map"])
  ed.setLabelString(self.ui.label_chapter_name, self.bookCfg.Name)
  self.ui.label_chapter_name:limitWidthByScale(140)
  if self.isShowBlackBook then
    ed.setTexture(self.ui.image_boss_detail_bg, "UI/alpha/1080P/rogue/main/main_book_crisis_info.png")
    ed.setTexture(self.ui.image_chapter_name_bg, "UI/alpha/1080P/rogue/main/main_book_crisis_title.png")
    ed.setTexture(self.ui.image_first_title_bg, "UI/alpha/1080P/rogue/main/main_book_crisis_long.png")
  else
    ed.setTexture(self.ui.image_boss_detail_bg, "UI/alpha/1080P/rogue/main/main_book_info.png")
    ed.setTexture(self.ui.image_chapter_name_bg, "UI/alpha/1080P/rogue/main/main_book_title.png")
    ed.setTexture(self.ui.image_first_title_bg, "UI/alpha/1080P/rogue/main/main_book_short.png")
  end
  self.ui.image_first_title_bg:setCascadeOpacityEnabled(true)
  self:refreshChapterDetail()
  self:refreshDiffBtn()
  self:refreshBtnChallenge()
  self:refreshCrisisPanel()
  self:refreshRecommendGs()
end

function class:registerRedDot()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("rogue_book_tech_" .. self.bookCfg.ID, self, {
    handle = function(value)
      self.ui.image_tech_red:setVisible(0 < value)
    end
  })
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_back, {left = 0, top = 0})
  ed.right2(self.ui.btn_crisis_rule, self.ui.label_crisis_title, 5)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_tech, ed.toccc3(6308444), 2)
  ed.setLabelShadow(self.ui.label_tech, ed.toccc3(5319773), ccp(0, 4))
  ed.setLabelStroke(self.ui.label_chapter_name, ed.toccc3(6045730), 1.5)
  ed.setLabelStroke(self.ui.label_diff, ed.toccc3(6045730), 1.5)
  ed.setLabelStroke(self.ui.label_reward_score_tips, ed.toccc3(6768162), 1.5)
  ed.setLabelStroke(self.ui.label_boss_name, ed.toccc3(2891270), 1)
  ed.setLabelStroke(self.ui.label_boss_desc, ed.toccc3(2891270), 1)
  ed.setLabelDimensions(self.ui.label_boss_desc, CCSizeMake(170, 0))
  ed.setLabelStroke(self.ui.label_record, ed.toccc3(4068675), 2)
  ed.setLabelShadow(self.ui.label_record, ed.toccc3(4142960), ccp(0, 4))
  ed.setLabelStroke(self.ui.label_charm_bag, ed.toccc3(7939878), 2)
  ed.setLabelShadow(self.ui.label_charm_bag, ed.toccc3(5450539), ccp(0, 4))
  ed.setLabelStroke(self.ui.label_crisis_title, ed.toccc3(4988958), 1.5)
  ed.setLabelStroke(self.ui.label_crisis_amount, ed.toccc3(16771980), 1)
end

function class:initEffect()
  local eff_book = ed.createFcaNode("eff_UI_rogue_book_choose")
  self:addFca(eff_book)
  self.container:addChild(eff_book, 0)
  eff_book:setPosition(ccp(495, 282))
  self.eff_book = eff_book
end

function class:showOpenAction()
  if self.isShowBlackBook then
    self.eff_book:setAction("Open2")
  else
    self.eff_book:setAction("Open")
  end
  self.ui.image_map:setOpacity(0)
  self.ui.label_boss_name:setOpacity(0)
  self.ui.label_boss_desc:setOpacity(0)
  self.ui.label_chapter_name:setOpacity(0)
  self.ui.label_diff:setOpacity(0)
  self.ui.image_line:setOpacity(0)
  self.ui.label_reward_score_tips:setOpacity(0)
  self.ui.image_first_title_bg:setOpacity(0)
  self.ui.label_recommend:setOpacity(0)
  self.ui.label_left_time_tips:setOpacity(0)
  self.ui.label_left_time:setOpacity(0)
  self.ui.btn_challenge:setOpacity(0)
  self.ui.label_challenge:setOpacity(0)
  self.ui.image_chapter_name_bg:setOpacity(0)
  self.ui.image_boss_detail_bg:setOpacity(0)
  self.ui.btn_boss_detail:setOpacity(0)
  self.ui.image_boss_tag:setOpacity(0)
  self.ui.btn_tech:setCascadeOpacityEnabled(true)
  self.ui.btn_tech:setOpacity(0)
  self.ui.btn_record:setCascadeOpacityEnabled(true)
  self.ui.btn_record:setOpacity(0)
  self.ui.btn_charm_bag:setCascadeOpacityEnabled(true)
  self.ui.btn_charm_bag:setOpacity(0)
  self.ui.image_crisis_bg:setCascadeOpacityEnabled(true)
  self.ui.btn_crisis_rule:setCascadeOpacityEnabled(true)
  self.ui.btn_crisis_minus:setCascadeOpacityEnabled(true)
  self.ui.btn_crisis_add:setCascadeOpacityEnabled(true)
  self.ui.image_crisis_bg:setOpacity(0)
  self.buffDesc:setOpacity(0)
  self.bossIcon:setOpacity(0)
  for diff, btn in ipairs(self.diffTabBtnList) do
    btn:setOpacity(0)
  end
  for index, rewardCfg in ipairs(self.firstPassRewardList) do
    rewardCfg.icon:setOpacity(0)
  end
  self.mainLayer:setOpacity(0)
  self.mainLayer:runAction(CCFadeTo:create(0.5, 170))
  local delay1 = CCDelayTime:create(0.25)
  local callFunc1 = CCCallFunc:create(function()
    for diff, btn in ipairs(self.diffTabBtnList) do
      btn:setOpacity(0)
      btn:setPositionX(btn:getPositionX() + 30)
      local delay = CCDelayTime:create(diff * 0.1)
      local fadeAction = CCFadeIn:create(0.2)
      local moveAction = CCMoveBy:create(0.2, ccp(-30, 0))
      local spawn = CCSpawn:create(ccArrayMake(fadeAction, moveAction))
      local action = CCSequence:create(ccArrayMake(delay, spawn))
      btn:runAction(action)
    end
    self.ui.image_map:runAction(CCFadeIn:create(1))
    self.buffDesc:runAction(CCFadeIn:create(0.5))
    self.bossIcon:runAction(CCFadeIn:create(0.5))
    self.ui.label_boss_name:setPositionX(self.ui.label_boss_name:getPositionX() - 10)
    self.ui.label_boss_name:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.5, ccp(10, 0)), CCFadeIn:create(0.5))))
    self.ui.label_boss_desc:setPositionX(self.ui.label_boss_desc:getPositionX() - 10)
    self.ui.label_boss_desc:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.5, ccp(10, 0)), CCFadeIn:create(0.5))))
    self.ui.image_boss_detail_bg:runAction(CCFadeIn:create(0.5))
    self.ui.btn_boss_detail:runAction(CCFadeIn:create(0.5))
    self.ui.image_boss_tag:runAction(CCFadeIn:create(0.5))
    self.ui.label_chapter_name:runAction(CCFadeIn:create(0.5))
    self.ui.label_diff:runAction(CCFadeIn:create(0.5))
    self.ui.image_line:runAction(CCFadeIn:create(0.5))
    self.ui.label_reward_score_tips:runAction(CCFadeIn:create(0.5))
    self.ui.image_chapter_name_bg:runAction(CCFadeIn:create(0.5))
    self.ui.image_first_title_bg:setPositionX(self.ui.image_first_title_bg:getPositionX() - 10)
    self.ui.image_first_title_bg:runAction(CCSpawn:create(ccArrayMake(CCMoveBy:create(0.2, ccp(10, 0)), CCFadeIn:create(0.2))))
    for index, rewardCfg in ipairs(self.firstPassRewardList) do
      local delayAction = CCDelayTime:create(index * 0.1)
      local fadeAction = CCFadeIn:create(0.3)
      rewardCfg.icon:runAction(CCSequence:create(ccArrayMake(delayAction, fadeAction)))
    end
    self.ui.label_recommend:runAction(CCFadeIn:create(0.5))
    self.ui.label_left_time_tips:runAction(CCFadeIn:create(0.5))
    self.ui.label_left_time:runAction(CCFadeIn:create(0.5))
    self.ui.image_crisis_bg:runAction(CCFadeIn:create(0.5))
    self.ui.btn_challenge:runAction(CCFadeIn:create(0.5))
    self.ui.label_challenge:runAction(CCFadeIn:create(0.5))
    self.ui.btn_tech:runAction(CCFadeIn:create(0.5))
    self.ui.btn_record:runAction(CCFadeIn:create(0.5))
    self.ui.btn_charm_bag:runAction(CCFadeIn:create(0.5))
  end)
  local delay2 = CCDelayTime:create(0.375)
  local callFunc2 = CCCallFunc:create(function()
    if self.isShowBlackBook then
      self.eff_book:setAction("Opening2")
    else
      self.eff_book:setAction("Opening")
    end
  end)
  local seq = CCSequence:create(ccArrayMake(delay1, callFunc1, delay2, callFunc2))
  self.ui.image_bg:runAction(seq)
end

function class:showCloseAction()
  self.mainLayer:runAction(CCFadeTo:create(0.5, 0))
  local callFunc = CCCallFunc:create(function()
    for diff, btn in ipairs(self.diffTabBtnList) do
      local delay = CCDelayTime:create(diff * 0.05)
      local fadeAction = CCFadeOut:create(0.2)
      local moveAction = CCMoveBy:create(0.2, ccp(30, 0))
      local spawn = CCSpawn:create(ccArrayMake(fadeAction, moveAction))
      local action = CCSequence:create(ccArrayMake(delay, spawn))
      btn:runAction(action)
    end
    self.ui.image_map:stopAllActions()
    self.ui.image_map:runAction(CCFadeOut:create(0.5))
    self.buffDesc:runAction(CCFadeOut:create(0.5))
    self.bossIcon:runAction(CCFadeOut:create(0.5))
    self.ui.label_boss_name:runAction(CCFadeOut:create(0.5))
    self.ui.label_boss_desc:runAction(CCFadeOut:create(0.5))
    self.ui.image_boss_detail_bg:runAction(CCFadeOut:create(0.5))
    self.ui.btn_boss_detail:runAction(CCFadeOut:create(0.5))
    self.ui.image_boss_tag:runAction(CCFadeOut:create(0.5))
    self.ui.label_chapter_name:runAction(CCFadeOut:create(0.5))
    self.ui.label_diff:runAction(CCFadeOut:create(0.5))
    self.ui.image_line:runAction(CCFadeOut:create(0.5))
    self.ui.label_reward_score_tips:runAction(CCFadeOut:create(0.5))
    self.ui.image_chapter_name_bg:runAction(CCFadeOut:create(0.5))
    self.ui.image_first_title_bg:runAction(CCFadeOut:create(0.5))
    for index, rewardCfg in ipairs(self.firstPassRewardList) do
      rewardCfg.icon:runAction(CCFadeOut:create(0.5))
    end
    self.ui.label_recommend:runAction(CCFadeOut:create(0.5))
    self.ui.label_left_time_tips:runAction(CCFadeOut:create(0.5))
    self.ui.label_left_time:runAction(CCFadeOut:create(0.5))
    self.ui.image_crisis_bg:runAction(CCFadeOut:create(0.5))
    self.ui.btn_challenge:runAction(CCFadeOut:create(0.5))
    self.ui.label_challenge:runAction(CCFadeOut:create(0.5))
    self.ui.btn_tech:runAction(CCFadeOut:create(0.5))
    self.ui.btn_record:runAction(CCFadeOut:create(0.5))
    self.ui.btn_charm_bag:runAction(CCFadeOut:create(0.5))
  end)
  local delayTime = CCDelayTime:create(0.45)
  local effAction = CCCallFunc:create(function()
    if self.isShowBlackBook then
      self.eff_book:setAction("Close2")
    else
      self.eff_book:setAction("Close")
    end
  end)
  local delayTime2 = CCDelayTime:create(0.25)
  local endFunc = CCCallFunc:create(function()
    self:destroy({skipAnim = true})
    if self.closeCallBack then
      self.closeCallBack()
    end
  end)
  local seq = CCSequence:create(ccArrayMake(callFunc, delayTime, effAction, delayTime2, endFunc))
  self.ui.image_bg:runAction(seq)
  ed.playEffect(ed.sound.deo.rogue_book_open)
end

function class:showBookChangeAction(isBlack)
  if isBlack then
    self.eff_book:setAction("Opening2")
  else
    self.eff_book:setAction("Opening")
  end
  if self.eff_book.setTexture1ForShader then
    if self.imageBook then
      if self.scheduleId then
        self.imageBook:getScheduler():unscheduleScriptEntry(self.scheduleId)
      end
      self.imageBook:removeFromParentAndCleanup(true)
      self.imageBook = nil
    end
    if isBlack then
      self.imageBook = ed.createSprite("UI/alpha/1080P/rogue/main/main_book_bg_1.png")
    else
      self.imageBook = ed.createSprite("UI/alpha/1080P/rogue/main/main_book_crisis_bg_1.png")
    end
    self.imageBook:setTexture1ForShader(ed.createSprite("installer/noise.jpg"):getTexture())
    self.eff_book:addChild(self.imageBook)
    self.imageBook:setPosition(ccp(24, -16))
    EDLoadShader("DissolveShader1")
    ed.useShader(self.imageBook, "DissolveShader1")
    local shader = self.imageBook:getShaderProgram()
    local maskalpha = 1
    local location = shader:getUniformLocationForName("u_alphakey")
    shader:setUniformsForBuiltins()
    shader:setUniformLocationWith2f(location, maskalpha, 0)
    
    local function refreshAlpha()
      maskalpha = maskalpha - 0.02
      if maskalpha < 0.001 then
        maskalpha = 0
        if self.scheduleId then
          self.imageBook:getScheduler():unscheduleScriptEntry(self.scheduleId)
        end
        self.imageBook:removeFromParentAndCleanup(true)
        self.imageBook = nil
      end
      if self.imageBook then
        shader:use()
        shader:setUniformLocationWith2f(location, maskalpha, 0)
      end
    end
    
    self.scheduleId = self.imageBook:getScheduler():scheduleScriptFunc(refreshAlpha, 0, false)
  end
  self.ui.image_boss_detail_bg:stopAllActions()
  self.ui.image_chapter_name_bg:stopAllActions()
  self.ui.image_first_title_bg:stopAllActions()
  self.ui.image_boss_detail_bg:runAction(CCSequence:create(ccArrayMake(CCFadeOut:create(0.4), CCCallFunc:create(function()
    if isBlack then
      ed.setTexture(self.ui.image_boss_detail_bg, "UI/alpha/1080P/rogue/main/main_book_crisis_info.png")
      ed.setTexture(self.ui.image_chapter_name_bg, "UI/alpha/1080P/rogue/main/main_book_crisis_title.png")
      ed.setTexture(self.ui.image_first_title_bg, "UI/alpha/1080P/rogue/main/main_book_crisis_long.png")
    else
      ed.setTexture(self.ui.image_boss_detail_bg, "UI/alpha/1080P/rogue/main/main_book_info.png")
      ed.setTexture(self.ui.image_chapter_name_bg, "UI/alpha/1080P/rogue/main/main_book_title.png")
      ed.setTexture(self.ui.image_first_title_bg, "UI/alpha/1080P/rogue/main/main_book_short.png")
    end
  end), CCFadeIn:create(0.4))))
  self.ui.image_chapter_name_bg:runAction(CCSequence:create(ccArrayMake(CCFadeOut:create(0.4), CCFadeIn:create(0.4))))
  self.ui.image_first_title_bg:runAction(CCSequence:create(ccArrayMake(CCFadeOut:create(0.4), CCFadeIn:create(0.4))))
end

function class:refreshBookColor()
  local isShowBlackBook
  if self.crisisDiff > 0 then
    isShowBlackBook = true
  else
    isShowBlackBook = false
  end
  if isShowBlackBook == self.isShowBlackBook then
    return
  end
  self.isShowBlackBook = isShowBlackBook
  self:showBookChangeAction(isShowBlackBook)
  self:initDiffButtons()
  self:refreshDiffBtn()
  if isShowBlackBook then
    self:showDiffBtnAction()
  end
  self:refreshBtnChallenge()
end

function class:showDiffBtnAction()
  for diff, btn in pairs(self.diffTabBtnList) do
    if diff ~= self.selectDiff then
      btn.btnNormal:runAction(CCFadeIn:create(0.3))
    end
    if diff == self.selectDiff then
      btn.btnSelect:runAction(CCFadeIn:create(0.3))
    end
  end
end

function class:initRewardDragList()
  self.firstPassDragList = ed.UITool.createDraglist(self.ui.panel_first_reward_list, {
    doPressIn = function(x, y)
      for _, rewardCfg in ipairs(self.firstPassRewardList) do
        local icon = rewardCfg.icon
        if ed.containsPoint(icon, x, y) then
          return rewardCfg
        end
      end
    end,
    doClickIn = function(x, y, rewardCfg)
      local rewardData = rewardCfg.rewardData
      ed.UITool.openView("packageDetail", {
        type = rewardData.type,
        id = rewardData.id,
        count = rewardData.amount
      })
    end,
    priority = -300
  })
end

function class:initDiffButtons()
  local isBlack = self.isShowBlackBook
  if isBlack then
    for i, v in ipairs(self.removeBtns or {}) do
      if not tolua.isnull(v) then
        v:removeFromParentAndCleanup(true)
      end
    end
    self.removeBtns = {}
    for diff, btn in pairs(self.diffTabBtnList) do
      if diff == self.selectDiff then
        btn.btnSelect:runAction(CCFadeOut:create(0.5))
      else
        btn.btnNormal:runAction(CCFadeOut:create(0.5))
      end
      table.insert(self.removeBtns, btn)
    end
  else
    self.ui.panel_btn_list:removeAllChildrenWithCleanup(true)
  end
  self.diffTabBtnList = {}
  local panelSize = self.ui.panel_btn_list:getContentSize()
  local posY = 0
  for diff, _ in ipairs(self.rogueChapterCfg) do
    local btn = self:createDiffBtn(diff)
    self.diffTabBtnList[diff] = btn
    local btnSize = btn:getContentSize()
    self.ui.panel_btn_list:addChild(btn)
    btn:setPosition(ccp(panelSize.width / 2, panelSize.height - btnSize.height / 2 - posY))
    posY = posY + btnSize.height
  end
  for diff, btn in pairs(self.diffTabBtnList) do
    self:btRegisterButtonClick({
      button = btn,
      key = "btnTab" .. diff,
      clickHandler = function()
        self:onClickDiffBtn(diff)
      end,
      pressScale = 0.95,
      force = true,
      mcpMode = true
    })
  end
end

function class:createDiffBtn(diff)
  local container = CCSprite:create()
  local btnNormal
  if self.isShowBlackBook then
    btnNormal = ed.createSprite("UI/alpha/1080P/rogue/main/main_book_tab_cirsis_1.png")
  else
    btnNormal = ed.createSprite("UI/alpha/1080P/rogue/main/main_book_tab_1.png")
  end
  btnNormal:setCascadeOpacityEnabled(true)
  local size = btnNormal:getContentSize()
  container:setContentSize(size)
  container:addChild(btnNormal)
  container:setCascadeOpacityEnabled(true)
  btnNormal:setPosition(ccp(size.width / 2, size.height / 2))
  local labelDiffNormal = ed.createttf(T("\233\154\190\229\186\166"), 19)
  labelDiffNormal:setCascadeOpacityEnabled(true)
  ed.setLabelColor(labelDiffNormal, ed.toccc3(15323301))
  ed.setLabelStroke(labelDiffNormal, ed.toccc3(6045730), 1.5)
  labelDiffNormal:setPosition(ccp(48, 37))
  labelDiffNormal:limitWidthByScale(55)
  local romanNumNormal = ed.rogueLikeTool.createRomanNum(diff)
  labelDiffNormal:addChild(romanNumNormal)
  romanNumNormal:setPosition(ccp(labelDiffNormal:getContentSize().width + romanNumNormal:getContentSize().width / 2, labelDiffNormal:getContentSize().height / 2))
  btnNormal:addChild(labelDiffNormal)
  local labelDiffSelect = ed.createttf(T("\233\154\190\229\186\166"), 19)
  labelDiffSelect:setCascadeOpacityEnabled(true)
  ed.setLabelColor(labelDiffSelect, ed.toccc3(16776423))
  labelDiffSelect:setScale(labelDiffNormal:getScaleX())
  local btnSelect
  if self.isShowBlackBook then
    btnSelect = ed.createSprite("UI/alpha/1080P/rogue/main/main_book_tab_cirsis_2.png")
    btnSelect:setPosition(ccp(size.width / 2 - 7, size.height / 2))
    ed.setLabelStroke(labelDiffSelect, ed.toccc3(4860458), 1.5)
    labelDiffSelect:setPosition(ccp(61, 37))
    local iconCrisis = ed.createSprite("UI/alpha/1080P/rogue/main/main_crisis_heat_tab.png")
    btnSelect:addChild(iconCrisis)
    iconCrisis:setPosition(ccp(25, 47))
  else
    btnSelect = ed.createSprite("UI/alpha/1080P/rogue/main/main_book_tab_2.png")
    btnSelect:setPosition(ccp(size.width / 2, size.height / 2))
    ed.setLabelStroke(labelDiffSelect, ed.toccc3(6045730), 1.5)
    labelDiffSelect:setPosition(ccp(48, 37))
  end
  btnSelect:setCascadeOpacityEnabled(true)
  container:addChild(btnSelect)
  local romanNumSelect = ed.rogueLikeTool.createRomanNum(diff, {
    I = "UI/alpha/1080P/rogue/main/main_num_1_light.png",
    V = "UI/alpha/1080P/rogue/main/main_num_5_light.png"
  })
  labelDiffSelect:addChild(romanNumSelect)
  romanNumSelect:setPosition(ccp(labelDiffSelect:getContentSize().width + romanNumSelect:getContentSize().width / 2, labelDiffSelect:getContentSize().height / 2))
  btnSelect:addChild(labelDiffSelect)
  container.btnNormal = btnNormal
  container.btnSelect = btnSelect
  return container
end

function class:refreshChapterDetail()
  self.ui.label_diff:removeAllChildrenWithCleanup(true)
  local romanDiffNum = ed.rogueLikeTool.createRomanNum(self.selectDiff, {
    I = "UI/alpha/1080P/rogue/main/main_num_1_light.png",
    V = "UI/alpha/1080P/rogue/main/main_num_5_light.png"
  })
  self.ui.label_diff:addChild(romanDiffNum)
  self.ui.label_diff:setCascadeOpacityEnabled(true)
  local labelSize = self.ui.label_diff:getContentSize()
  romanDiffNum:setPosition(ccp(labelSize.width + romanDiffNum:getContentSize().width / 2 + 3, labelSize.height / 2))
  self.ui.label_diff:limitWidthByScale(50)
  local rogueChapterCfg = self.rogueChapterCfg[self.selectDiff]
  local mapId = rogueChapterCfg["Map ID"]
  local rogueChapterMapCfg = ed.getDataTable("RogueChapterMap")[mapId]
  local roundAmount = 0
  for _, _ in ipairs(rogueChapterMapCfg) do
    roundAmount = roundAmount + 1
  end
  local exp = roundAmount * 4 * rogueChapterCfg["Each Wave Exp"] + rogueChapterCfg["Final Wave Exp"]
  ed.setLabelString(self.ui.label_reward_score_tips, string.format(T("\233\128\154\229\133\179\229\143\175\232\142\183\229\190\151\231\129\171\232\138\177%s"), exp))
  self:refreshFirstPassReward()
  local buffDes = rogueChapterCfg["Buff Short Des"] or ""
  self.ui.panel_desc:removeAllChildrenWithCleanup(true)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = buffDes,
    maxWidth = self.ui.panel_desc:getContentSize().width,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(2891270),
    strokeSize = 1,
    fontSize = 13
  })
  self.ui.panel_desc:addChild(autoText.node)
  self.buffDesc = autoText.node
  local buffDescW, buffDescH = autoText:getCurContentSize()
  if buffDescH < self.ui.panel_desc:getContentSize().height then
    autoText.node:setPosition(ccp(0, self.ui.panel_desc:getContentSize().height / 2 + buffDescH / 2 - 6.5))
  else
    autoText.node:setPosition(ccp(0, self.ui.panel_desc:getContentSize().height - 6.5))
  end
  self:refreshBossInfo()
  self.ui.btn_record:setVisible(self.bookId ~= 1)
  local techTreeId = rogueChapterCfg["Tech Tree ID"]
  if not techTreeId or techTreeId == 0 then
    self.ui.btn_tech:setVisible(false)
  else
    self.ui.btn_tech:setVisible(true)
  end
  self.ui.btn_charm_bag:setVisible(nil ~= next(self.bookCfg["Charm List"] or {}))
end

function class:refreshFirstPassReward()
  self.firstPassDragList:clearList()
  local panelSize = self.ui.panel_first_reward_list:getContentSize()
  local rogueChapterCfg = self.rogueChapterCfg[self.selectDiff]
  local chapterDiffIsPass = self.rogueLikeMgr:getChapterIsPass(self.chapterId, self.selectDiff)
  self.firstPassRewardList = {}
  local width, gapX = 0, 0
  for index = 1, 20 do
    local type = rogueChapterCfg["FDS Reward Type " .. index]
    local id = rogueChapterCfg["FDS Reward ID " .. index]
    local amount = rogueChapterCfg["FDS Reward Amount " .. index]
    if not amount or amount == 0 then
      break
    end
    local icon = ed.createItemIcon({
      id = id,
      type = type,
      amount = amount
    })
    table.insert(self.firstPassRewardList, {
      icon = icon,
      rewardData = {
        id = id,
        type = type,
        amount = amount
      }
    })
    if chapterDiffIsPass then
      local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
      local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
      icon:addChild(mask, 1)
      icon:addChild(imageReceived, 2)
      imageReceived:setPosition(ccp(45, 40))
      mask:setPosition(ccp(45, 45))
    end
    local iconSize = icon:getContentSize()
    local iconScale = icon:getScale()
    self.firstPassDragList:addItem(icon)
    icon:setPosition(ccp(width + iconSize.width / 2 * iconScale, panelSize.height / 2))
    width = width + iconSize.width * iconScale + gapX
  end
  self.firstPassDragList:initListWidth(width)
end

function class:refreshBossInfo()
  local bossCfg = ed.getDataTable("RogueBoss")[self.chapterId] or {}
  ed.setLabelString(self.ui.label_boss_name, string.format(T("%s"), bossCfg["Boss Name"] or ""))
  ed.setLabelString(self.ui.label_boss_desc, bossCfg["Boss Description"] or "")
  self.ui.panel_boss_icon:removeAllChildrenWithCleanup(true)
  local bossIcon = ed.readhero.createIcon({
    id = bossCfg["Boss ID"][1]
  })
  self.ui.panel_boss_icon:addChild(bossIcon.icon)
  ed.layout.centerInParent(bossIcon.icon)
  self.bossIcon = bossIcon.icon
end

function class:refreshDiffBtn()
  for diff, btn in pairs(self.diffTabBtnList) do
    btn.btnNormal:setVisible(diff ~= self.selectDiff)
    btn.btnSelect:setVisible(diff == self.selectDiff)
  end
end

function class:refreshBtnChallenge()
  local isUnlock = self.rogueLikeMgr:getChapterIsUnlock(self.chapterId, self.selectDiff)
  if not isUnlock then
    ed.setLabelString(self.ui.label_recommend, T("\233\128\154\229\133\179\233\154\190\229\186\1661\229\144\142\232\167\163\233\148\129"))
    ed.setLabelColor(self.ui.label_recommend, ed.toccc3(12006452))
    ed.setLabelColor(self.ui.label_challenge, ed.toccc3(16776423))
    ed.setTexture(self.ui.btn_challenge, "UI/alpha/1080P/common/button_big_grey.png")
  elseif self.curChapter._chapter_id == self.chapterId and self.curChapter._difficulty == self.selectDiff then
    local curWave = self.curChapter._cur_wave or 0
    local waves = self.curChapter._waves or {}
    local totalWave = waves[#waves]._wave_id or 0
    local endTime = self.curChapter._end_time
    local leftTime = endTime - ed.getServerTime()
    self:refreshLeftTime()
    if leftTime <= 0 then
      ed.setLabelString(self.ui.label_challenge, T("\231\187\147\231\174\151\230\140\145\230\136\152"))
    else
      ed.setLabelString(self.ui.label_challenge, string.format(T("\231\187\167\231\187\173\232\191\155\229\186\166%s/%s"), curWave, totalWave))
      self:startCountDown()
    end
    self.ui.label_recommend:setVisible(false)
    self.ui.label_left_time_tips:setVisible(true)
    self.ui.label_left_time:setVisible(true)
    ed.setLabelColor(self.ui.label_challenge, ed.toccc3(16248486))
    ed.setTexture(self.ui.btn_challenge, "UI/alpha/1080P/common/button_big_common.png")
  else
    ed.setLabelString(self.ui.label_challenge, T("\230\140\145\230\136\152"))
    self.ui.label_recommend:setVisible(true)
    if self.isShowBlackBook then
      ed.setLabelColor(self.ui.label_recommend, ed.toccc3(14333348))
    else
      ed.setLabelColor(self.ui.label_recommend, ed.toccc3(4864030))
    end
    self.ui.label_left_time_tips:setVisible(false)
    self.ui.label_left_time:setVisible(false)
    ed.setLabelColor(self.ui.label_challenge, ed.toccc3(16248486))
    ed.setTexture(self.ui.btn_challenge, "UI/alpha/1080P/common/button_big_common.png")
  end
end

function class:startCountDown()
  self:listenTimer(Timer:Always(1), function()
    self:refreshLeftTime()
  end)
end

function class:refreshLeftTime()
  local endTime = self.curChapter._end_time
  local leftTime = endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local sec = leftTime % 60
  self.ui.label_left_time:setString((string.format(T("%.2d:%.2d:%.2d"), hour, min, sec)))
end

function class:refreshCrisisPanel()
  local crisisGroupId = self.rogueChapterCfg[self.selectDiff]["Crisis Group"]
  local chapterDiffIsPass = self.rogueLikeMgr:getChapterIsPass(self.chapterId, self.selectDiff)
  self.crisisGroupId = crisisGroupId
  if not crisisGroupId or crisisGroupId == 0 or not chapterDiffIsPass then
    self.ui.image_crisis_bg:setVisible(false)
    return
  end
  local rogueCrisisCfg = ed.getDataTable("RogueCrisis")[crisisGroupId]
  local crisisMax = 0
  for crisisDiff, _ in ipairs(rogueCrisisCfg) do
    crisisMax = crisisDiff
  end
  self.crisisMax = crisisMax
  self.ui.image_crisis_bg:setVisible(true)
  ed.setLabelString(self.ui.label_crisis_amount, self.crisisDiff)
  if 0 >= self.crisisDiff then
    ed.setTexture(self.ui.btn_crisis_minus, "UI/alpha/1080P/rogue/main/main_book_heat_dark.png")
    ed.setTexture(self.ui.img_crisis_minus, "UI/alpha/1080P/rogue/main/main_minus_1.png", true)
  else
    ed.setTexture(self.ui.btn_crisis_minus, "UI/alpha/1080P/rogue/main/main_book_heat_light.png")
    ed.setTexture(self.ui.img_crisis_minus, "UI/alpha/1080P/rogue/main/main_minus_2.png", true)
  end
  ed.layout.centerInParent(self.ui.img_crisis_minus)
  if self.crisisDiff >= self.crisisMax then
    ed.setTexture(self.ui.btn_crisis_add, "UI/alpha/1080P/rogue/main/main_book_heat_dark.png")
    ed.setTexture(self.ui.img_crisis_add, "UI/alpha/1080P/rogue/main/main_plus_2.png", true)
  else
    ed.setTexture(self.ui.btn_crisis_add, "UI/alpha/1080P/rogue/main/main_book_heat_light.png")
    ed.setTexture(self.ui.img_crisis_add, "UI/alpha/1080P/rogue/main/main_plus_1.png", true)
  end
  ed.layout.centerInParent(self.ui.img_crisis_add)
end

function class:refreshRecommendGs()
  local rogueChapterCfg = self.rogueChapterCfg[self.selectDiff]
  local recommendGs = rogueChapterCfg["Recommend GS"] or 0
  if 0 < self.crisisGroupId and 0 < self.crisisDiff then
    recommendGs = ed.getDataTable("RogueCrisis")[self.crisisGroupId][self.crisisDiff]["Recommend GS"]
  end
  ed.setLabelString(self.ui.label_recommend, string.format(T("\230\142\168\232\141\144\229\185\179\229\157\135\230\136\152\229\138\155%s"), recommendGs))
end

function class:onClickDiffBtn(diff)
  if self.curChapter._chapter_id == self.chapterId and self.curChapter._difficulty ~= diff then
    ed.showToast(T("\230\173\163\229\156\168\230\140\145\230\136\152\229\133\182\228\187\150\233\154\190\229\186\166"))
    return
  end
  if self.selectDiff == diff then
    return
  end
  self.selectDiff = diff
  self:refreshDiffBtn()
  self:refreshChapterDetail()
  self:refreshBtnChallenge()
  self:refreshCrisisPanel()
  self:refreshRecommendGs()
end

function class:onClickBtnChallenge()
  local isUnlock, tips = self.rogueLikeMgr:getChapterIsUnlock(self.chapterId, self.selectDiff)
  if not isUnlock then
    if tips then
      ed.showToast(tips)
    end
    return
  end
  local curChapterId = self.rogueLikeMgr:getCurChapterId()
  if curChapterId == 0 then
    local chapterCfg = ed.getDataTable("RogueChapter")[self.chapterId][self.selectDiff]
    local crisisDiff = self.crisisDiff
    if not chapterCfg["Crisis Group"] or chapterCfg["Crisis Group"] == 0 then
      crisisDiff = nil
    end
    ed.UITool.openView("rogueDestinyChooseScene", {
      chapterId = self.chapterId,
      difficulty = self.selectDiff,
      crisisGroupId = self.crisisGroupId,
      crisisDiff = crisisDiff
    })
    self:saveBookDiffSelect()
    ed.rogueLikeTool.saveLastBookId(self.bookId)
  elseif curChapterId == self.chapterId then
    local endTime = self.curChapter._end_time
    local leftTime = endTime - ed.getServerTime()
    if leftTime <= 0 then
      ed.rogueLikeNet.sendExitChapter()
      self:destroy({skipAnim = true})
    else
      ed.UITool.openView("rogueMapScene")
    end
  else
    ed.showToast(T("\229\133\182\228\187\150\231\171\160\232\138\130\230\173\163\229\156\168\232\191\155\232\161\140\228\184\173"))
  end
end

function class:onClickBtnTech()
  ed.UITool.openView("rogueTechTreeScene", {
    chapterId = self.chapterId
  })
end

function class:onClickBtnRank()
  ed.UITool.openView("rogueRankWindow", {
    chapterId = self.chapterId
  })
end

function class:onClickBtnCharm()
  ed.UITool.openView("rogueCharmBagScene", {
    bookId = self.bookId
  })
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
    txt = ed.rogueDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickBtnCrisisRule()
  if self.crisisGroupId <= 0 then
    return
  end
  ed.UITool.openView("rogueCrisisRuleWindow", {
    crisisGroupId = self.crisisGroupId
  })
end

function class:onClickBtnDetail()
  ed.UITool.openView("rogueBossDetailWindow", {
    chapterId = self.chapterId
  })
end

function class:onClickItemAmount()
  local itemId = ed.getDataTable("RogueConfig")["Use Vitality Item"]["Script Arg"]
  ed.ui.packageDetailWin.create({id = itemId, type = "item"}):popWindow()
end

function class:onClickVitality()
  ed.ui.packageDetailWin.create({
    type = "roguevitality"
  }):popWindow()
end

function class:onClickBtnCrisisMinus()
  if self.curChapter._chapter_id and self.curChapter._chapter_id > 0 then
    ed.showToast(T("\230\173\163\229\156\168\230\140\145\230\136\152\239\188\140\230\151\160\230\179\149\232\176\131\230\149\180\229\141\177\230\156\186\233\154\190\229\186\166"))
    return
  end
  if 0 >= self.crisisDiff then
    return
  end
  self.crisisDiff = self.crisisDiff - 1
  self:refreshBookColor()
  self:refreshCrisisPanel()
  self:refreshRecommendGs()
end

function class:onClickBtnCrisisAdd()
  if self.curChapter._chapter_id and self.curChapter._chapter_id > 0 then
    ed.showToast(T("\230\173\163\229\156\168\230\140\145\230\136\152\239\188\140\230\151\160\230\179\149\232\176\131\230\149\180\229\141\177\230\156\186\233\154\190\229\186\166"))
    return
  end
  if self.crisisDiff >= self.crisisMax then
    return
  end
  self.crisisDiff = self.crisisDiff + 1
  self:refreshBookColor()
  self:refreshCrisisPanel()
  self:refreshRecommendGs()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_challenge", function()
    self:onClickBtnChallenge()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_tech", function()
    self:onClickBtnTech()
  end, {normalScale = 0.9, pressScale = 0.855})
  ed.UITool.registerBtn(self, "btn_record", function()
    self:onClickBtnRank()
  end, {normalScale = 0.9, pressScale = 0.855})
  ed.UITool.registerBtn(self, "btn_charm_bag", function()
    self:onClickBtnCharm()
  end, {normalScale = 0.9, pressScale = 0.855})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_crisis_rule", function()
    self:onClickBtnCrisisRule()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_boss_detail", function()
    self:onClickBtnDetail()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_item_bg", function()
    self:onClickItemAmount()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_vitality_bg", function()
    self:onClickVitality()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_back", function()
    self:showCloseAction()
  end, {clickInterval = 1})
  ed.UITool.registerBtn(self, "btn_crisis_minus", function()
    self:onClickBtnCrisisMinus()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_crisis_add", function()
    self:onClickBtnCrisisAdd()
  end, {pressScale = 0.95})
end

function class:onWinDestroy()
  self.redPointMgr:unregisterAllValueChange(self)
  base.onWinDestroy(self)
end

function class:addEventListener()
  self:listenEvent("rogueEnterChapter", function()
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("rogueExitChapter", function()
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("rogueEnterRoom", function()
    self:refreshBtnChallenge()
  end)
  self:listenEvent("rogueOpenTech", function(chapterId)
  end)
end
