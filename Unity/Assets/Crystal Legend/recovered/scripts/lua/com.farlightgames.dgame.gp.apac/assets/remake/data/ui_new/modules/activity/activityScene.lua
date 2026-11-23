local base = ed.ui.basescene
local activityScene = newclass(base.mt)
ed.ui.activityScene = activityScene
activityScene.IsShowCalenderIcon = true

function activityScene.create(param, onExit, objWork, objData)
  local self = base.create("activityScene")
  setmetatable(self, activityScene.mt)
  self.param = param or {}
  self.page = self.param.actId or 0
  self.openActType = self.param.openActType
  self.container, self.ui = ed.editorui(ed.uieditor.activity_scene)
  self.ui.Label_39:limitWidthByScale(95)
  self.mainLayer:addChild(self.container)
  ed.UITool.createSceneTitle(T("\231\178\190\229\189\169\230\180\187\229\138\168"), self.ui.ImageView_32, {
    position = ccp(44, 20)
  })
  self:autoSizeWin(self.ui)
  self:addCalendarFca(self.ui)
  self:setBackground()
  self:setBackButton(onExit)
  self:setButtonClick()
  self.btnClickHanders = {}
  self.eventHandlers = {}
  self:createRegisterButtonClick()
  self:createRemoveMainTouchHandler()
  self.objWork = objWork
  self.objData = objData
  if ed.activityHints.openUpdate then
    self.objWork:activityPull()
    ed.activityHints.openUpdate = false
  end
  return self
end

function activityScene:createPage()
  if self.newShowAct then
    local newShowAct = self.objData:getNewActivityData()
    if #newShowAct ~= #self.newShowAct then
      self.newShowAct = newShowAct
      self.page = 1
      for k, v in pairs(self.scenePage or {}) do
        if v.container and v.container:isVisible() then
          if v.setVisibleCallBack then
            v:setVisibleCallBack(false)
          end
          v.container:setVisible(false)
          self:pausePageEvent(k)
          self:pausePageBtnClick(k)
        end
      end
      self.scenePage = {}
      self:createBtnList()
      self:showActivityPage()
      return
    end
    local pageData = self.newShowAct[self.page]
    if pageData then
      self:pageUpdate({
        _act_id = pageData._id
      })
    end
    return
  end
  self.newShowAct = self.objData:getNewActivityData()
  if self.page and self.page ~= 0 then
    self.page = self.objData:getActivityIdToIndex(self.page) or 1
  elseif self.openActType then
    self.page = self.objData:getActivityTypeToIndex(self.openActType)
  else
    self.page = 1
  end
  self:createBtnList()
  self:showActivityPage()
  self:registerOnEnterHandler("onEnter", function(type)
    self.objWork:getEnterHandler()
    self:onEnterPage()
  end)
  self:registerOnPopSceneHandler("onPopScene", function(type)
    self:setShowPageInvisible()
    self:clearAllPageEvent()
    self:clearAllPageBtnClick()
  end)
  self:listenEvent("update_activity_reds", function(info)
    for k, v in pairs(self.pageReds) do
      v:setVisible(info[k] and 0 < info[k])
    end
  end)
  self:listenEvent("jumpActivityPage", function(actIds, type)
    local page
    if actIds then
      for k, v in ipairs(actIds) do
        page = page or self.objData:getActivityIdToIndex(v)
      end
    else
      page = self.objData:getActivityTypeToIndex(type)
    end
    if not page then
      ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\230\148\190"))
      return
    end
    local offset = self.page - page
    local size = self.ui.Panel_30:getContentSize()
    self.page = page
    self.btn.pas:setVisible(false)
    self.btn = self.btnPage[self.page]
    self.btn.pas:setVisible(true)
    local y1 = self.draglist:getList():getPositionY()
    self.draglist:getList():setPositionY(math.max(0, math.min(y1 - 60 * offset, #self.btnPage * 60 - size.height)))
    self:showActivityPage()
  end)
  self:listenEvent("EventHeroHaggleFcaTopView", function(price)
    local spinePrice = ed.createSpine("effect/eff_UI_Hero_haggle_Pricedown/eff_UI_Hero_haggle_Pricedown", 0.5)
    spinePrice:setAnimation(0, "Idle_" .. price, false)
    self.ui.fca_lay:addChild(spinePrice, 1)
  end)
end

function activityScene:pageUpdate(task_submit)
  local data = self.objData:getActivityInfoToKey(task_submit._act_id)
  local pageKey = data._type .. "_" .. data._id
  if self.scenePage[pageKey] and self.scenePage[pageKey].pageUpDate then
    self.scenePage[pageKey]:pageUpDate(data)
  end
end

function activityScene:autoSizeWin(ui)
  ed.layout.layoutHalfFixedMagin(ui.back_lay, {left = true, top = true})
  ed.layout.layoutHalfFixedMagin(ui.rule_lay, {right = true, top = true})
  ed.layout.layoutHalfFixedMagin(ui.btn_lay, {left = true})
  ui.btn_lay:setPositionX(ui.btn_lay:getPositionX() + ed.display.getNotchHeight() / 2)
  ui.ImageView_29:setScaleX(1.04)
end

function activityScene:addCalendarFca(ui)
  local calendarEff = ed.createFcaNode("eff_UI_Calendar_flip")
  ui.calendar_btn:addChild(calendarEff)
  ui.calendar_btn:setVisible(self.IsShowCalenderIcon)
  ed.layout.centerInParent(calendarEff)
  local activitySceneShow = ed.storage.getBool("activitySceneShow")
  local startName, loopName
  if activitySceneShow then
    startName = "Start1"
    loopName = "Loop1"
  else
    startName = "Start"
    loopName = "Loop"
    ed.storage.setValue("activitySceneShow", true)
  end
  self:addFca(calendarEff)
  calendarEff:setLoop(true)
  calendarEff:setStartAction(startName)
  calendarEff:setLoopAction(loopName)
end

function activityScene:createBtnList()
  local size = self.ui.Panel_30:getContentSize()
  if self.draglist then
    self.draglist:clearList()
  else
    self.btnListSize = size
    local info = {
      cliprect = CCRectMake(-5, 0, size.width + 20, size.height + 4),
      container = self.ui.Panel_30,
      noshade = true,
      doPressIn = self:doPressIn(),
      doClickIn = self:clickInFun(true),
      cancelPressIn = self:clickInFun(),
      cancelClickIn = self:clickInFun()
    }
    self.draglist = ed.draglist.create(info)
  end
  local reds = ed.activityHints.reds
  self.pageReds = {}
  
  local function func(i, v)
    local type = v._type or "days_login"
    if v._extend and v._extend._tag == "v2" then
      type = type .. "_v2"
    elseif v._extend and v._extend._tag and v._extend._tag ~= "" and type ~= "newyear_marketing" then
      type = type .. "_" .. v._extend._tag
    end
    local head = v._head or {}
    local txt = head._title or T("\229\144\141\231\167\176\228\184\186\231\169\186")
    local icon = head._icon
    local layer = CCLayer:create()
    local press = ed.createSprite("UI/alpha/1080P/activity/activity_tab.png")
    layer:addChild(press, 9)
    local size = press:getContentSize()
    local nameLabel = ed.createttf(txt, 18)
    ed.adaptLabel(nameLabel, {
      maxWidth = 110,
      minScale = 0.6,
      singleLine = true
    })
    ed.setLabelColor(nameLabel, ed.toccc3(16777190))
    local nameBg = ed.createScale9Sprite("UI/alpha/1080P/activity/activity_bg_img.png", CCRectMake(17, 17, 15, 11))
    local nameLabelSize = nameLabel:getContentSize()
    nameBg:setContentSize(CCSizeMake(nameLabelSize.width * nameLabel:getScale() + 30, nameLabelSize.height * nameLabel:getScale() + 22))
    nameBg:addChild(nameLabel)
    ed.layout.centerInParent(nameLabel)
    nameBg:setAnchorPoint(ccp(0, 0.5))
    nameBg:setPosition(ccp(44, size.height / 2))
    local blendFunc = ccBlendFunc()
    blendFunc.src = GL_SRC_ALPHA
    blendFunc.dst = GL_ONE
    nameLabel:setBlendFunc(blendFunc)
    press:addChild(nameBg)
    local tag = ed.createSprite("UI/alpha/1080P/activity/activity_tag_img_" .. type .. "_b.png")
    tag:setPosition(ccp(size.width / 2 - 50, size.height / 2))
    press:addChild(tag)
    local lig = ed.createSprite("UI/alpha/1080P/shop/shop_point_choose.png")
    lig:setPosition(ccp(size.width / 2 - 70, size.height / 2))
    press:addChild(lig)
    local normal = ed.createSprite("")
    normal:setContentSize(CCSizeMake(size.width, size.height))
    layer:addChild(normal, 1)
    local tag = ed.createSprite("UI/alpha/1080P/activity/activity_tag_img_" .. type .. "_a.png")
    tag:setPosition(ccp(size.width / 2 - 50, size.height / 2))
    normal:addChild(tag)
    local lig = ed.createSprite("UI/alpha/1080P/activity/activity_point_unclick.png")
    lig:setPosition(ccp(size.width / 2 - 70, size.height / 2))
    normal:addChild(lig)
    local label = ed.createttf(txt, 16)
    label:limitWidthByScale(100)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(size.width / 2 - 30, size.height / 2))
    label:setColor(ccc3(ed.colorToStr("#fffed9")))
    normal:addChild(label)
    local red = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    red:setVisible(reds[v._id] and 0 < reds[v._id])
    red:setPosition(ccp(size.width / 2 - 23, size.height / 2 - 10))
    layer:addChild(red, 99)
    self.pageReds[v._id] = red
    return layer, normal, press
  end
  
  self.btnPage = {}
  for i, v in ipairs(self.newShowAct) do
    local lay, btn, pas = func(i, v or {})
    pas:setVisible(i == self.page)
    self.draglist:addItem(lay, ccp(size.width / 2 + 8, size.height - 60 * i + 31))
    table.insert(self.btnPage, {btn = btn, pas = pas})
    if self.page == i then
      self.btn = {btn = btn, pas = pas}
    end
  end
  self.draglist:initListHeight(#(self.draglist.listItems or {}) * 60)
end

function activityScene:doPressIn()
  return function(x, y)
    if self.notTouch then
      return
    end
    
    local function func(x, y)
      local items = self.btnPage or {}
      for i, btn in ipairs(items) do
        if not btn.pas:isVisible() and ed.containsPoint(btn.btn, x, y) then
          btn.btn:setScale(1.1)
          return btn, i
        end
      end
    end
    
    self.notTouch = true
    ListenTimer(Timer:Once(0.1), function()
      self.notTouch = false
    end)
    return func(x, y)
  end
end

function activityScene:clickInFun(right)
  return function(x, y, btn, index)
    if tolua.isnull(btn.btn) then
      return false
    end
    if btn then
      btn.btn:setScale(1)
    end
    if right and btn.pas then
      btn.pas:setVisible(true)
      if self.btn then
        self.btn.pas:setVisible(false)
      end
      self.page = index
      self.btn = btn
      self:showActivityPage()
    end
  end
end

function activityScene:showActivityPage()
  self.scenePage = self.scenePage or {}
  for k, v in pairs(self.scenePage) do
    if v.container and v.container:isVisible() then
      if v.setVisibleCallBack then
        v:setVisibleCallBack(false)
      end
      v.container:setVisible(false)
      self:pausePageEvent(k)
      self:pausePageBtnClick(k)
    end
  end
  local pageData = self.newShowAct[self.page]
  if not pageData then
    print(" self.page is nil ", self.page)
    return
  end
  local pageKey = pageData._type .. "_" .. pageData._id
  local newpage = self.scenePage[pageKey]
  if newpage and newpage.container then
    if newpage.setVisibleCallBack then
      newpage:setVisibleCallBack(true)
    end
    newpage.container:setVisible(true)
    self:resumePageEvent(pageKey)
    self:resumePageBtnClick(pageKey)
  else
    local uiname = self.objData:getActUIName(pageData)
    if uiname and ed.ui[uiname] then
      local page = ed.ui[uiname].create(self, pageData, pageKey)
      self.ui.page_lay:addChild(page.container)
      self.scenePage[pageKey] = page
      page.pageKey = pageKey
      newpage = page
      if pageData._hint_key and ed.activityHints.Hints[pageData._id] and ed.activityHints.Hints[pageData._id].red then
        ed.ActivityNetwork:activityHintResolve(pageData._id)
      end
    end
  end
  local isShowBtnRule = not pageData._head or not pageData._head.notShowRuleBtn
  if newpage and newpage.getIsShowBtnRule then
    isShowBtnRule = newpage:getIsShowBtnRule()
  end
  self.ui.rule_btn:setVisible(isShowBtnRule)
end

function activityScene:onEnterPage()
  local pageData = self.newShowAct[self.page]
  if not pageData then
    print(" self.page is nil ", self.page)
    return
  end
  local pageKey = pageData._type .. "_" .. pageData._id
  local curPage = self.scenePage[pageKey]
  if curPage and curPage.container and curPage.onSceneEnter then
    curPage:onSceneEnter()
  end
end

function activityScene:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.rule_btn,
    key = "rule_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      if self.newShowAct and self.newShowAct[self.page] then
        local pageData = self.newShowAct[self.page]
        local head = pageData._head
        ed.ui.commonRulePop.create({
          title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
          txt = T(head._rules or "")
        }):popWindow()
      end
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.calendar_btn,
    key = "calendar_btn",
    force = true,
    mcpMode = true,
    pressScale = 0.96,
    clickHandler = function()
      ed.UITool.openView("activityCalenderWin")
    end
  })
end

function activityScene:setShowPageInvisible()
  self.scenePage = self.scenePage or {}
  for k, v in pairs(self.scenePage) do
    if v.container and v.container:isVisible() then
      if v.setVisibleCallBack then
        v:setVisibleCallBack(false)
      end
      v.container:setVisible(false)
      self:pausePageEvent(k)
      self:pausePageBtnClick(k)
    end
  end
end

function activityScene:clearAllPageEvent()
  for k, v in pairs(self.eventHandlers) do
    print("clearAllPageEvent", k)
    CloseScope(v.scope)
  end
  self.eventHandlers = {}
end

function activityScene:pausePageEvent(pageKey)
  local pageEvent = self.eventHandlers[pageKey]
  if nil == pageEvent then
    return
  end
  print("pausePageEvent", pageKey)
  CloseScope(pageEvent.scope)
end

function activityScene:resumePageEvent(pageKey)
  local pageEvent = self.eventHandlers[pageKey]
  if nil == pageEvent then
    return
  end
  print("resumePageEvent", pageKey)
  for _, event in ipairs(pageEvent.params) do
    ListenEvent(event.eventName, event.fun, pageEvent.scope)
  end
end

function activityScene:listenPageEvent(eventName, fun)
  local pageEvent = self.eventHandlers[self.pageKey]
  if nil == pageEvent then
    pageEvent = {
      scope = {},
      params = {}
    }
    self.eventHandlers[self.pageKey] = pageEvent
  end
  table.insert(pageEvent.params, {eventName = eventName, fun = fun})
  ListenEvent(eventName, fun, pageEvent.scope)
end

function activityScene:clearAllPageBtnClick()
  local btnClickHanders = self.btnClickHanders
  for pageKey, handlers in pairs(btnClickHanders) do
    print("clearAllPageBtnClick", pageKey)
    for key, data in pairs(handlers) do
      self.original_btRemoveMainTouchHandler(data.page, data.param)
    end
  end
end

function activityScene:pausePageBtnClick(pageKey)
  local btnClickHanders = self.btnClickHanders
  local thisPageBtnClickHanders = btnClickHanders[pageKey] or {}
  for key, data in pairs(thisPageBtnClickHanders) do
    print("pausePageBtnClick", pageKey, key)
    self.original_btRemoveMainTouchHandler(data.page, data.param)
  end
end

function activityScene:resumePageBtnClick(pageKey)
  local btnClickHanders = self.btnClickHanders
  local thisPageBtnClickHanders = btnClickHanders[pageKey] or {}
  for key, data in pairs(thisPageBtnClickHanders) do
    print("resumePageBtnClick", pageKey, key)
    self.original_btRegisterButtonClick(data.page, data.param)
  end
end

function activityScene:createRegisterButtonClick()
  local btRegisterButtonClick = self.btRegisterButtonClick
  self.original_btRegisterButtonClick = btRegisterButtonClick
  
  local function addToBtnClickHandler(page, param)
    local key = param.key
    if not key then
      return
    end
    local btnClickHanders = self.btnClickHanders
    local curPageBtnClickHanders = btnClickHanders[page.pageKey] or {}
    curPageBtnClickHanders[key] = {page = page, param = param}
    btnClickHanders[page.pageKey] = curPageBtnClickHanders
  end
  
  function self:btRegisterButtonClick(param)
    addToBtnClickHandler(self, param)
    param.key = self.pageKey .. "-" .. (param.key or "")
    btRegisterButtonClick(self, param)
  end
end

function activityScene:createRemoveMainTouchHandler()
  local btRemoveMainTouchHandler = self.btRemoveMainTouchHandler
  self.original_btRemoveMainTouchHandler = btRemoveMainTouchHandler
  
  local function removeFromBtnClickHandler(page, param)
    local key = param.key
    if not key then
      return
    end
    local btnClickHanders = self.btnClickHanders
    local curPageBtnClickHanders = btnClickHanders[page.pageKey] or {}
    curPageBtnClickHanders[key] = nil
    btnClickHanders[page.pageKey] = curPageBtnClickHanders
  end
  
  function self:btRemoveMainTouchHandler(param)
    removeFromBtnClickHandler(self, param)
    param.key = self.pageKey .. "-" .. (param.key or "")
    btRemoveMainTouchHandler(self, param)
  end
end
