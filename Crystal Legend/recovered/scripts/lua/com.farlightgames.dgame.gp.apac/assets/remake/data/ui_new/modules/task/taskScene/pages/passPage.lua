local page = {}
local itemBox = {width = 77, height = 369}

function page.create(sceneSelf, dataObj)
  local container, ui = ed.editorui(ed.uieditor.passTaskLaye)
  return setmetatable({
    sceneSelf = sceneSelf,
    dataObj = dataObj,
    container = container,
    ui = ui,
    index = 1
  }, {__index = page}):init()
end

function page:init()
  self:uiCreate()
  self:dragListCreate()
  self:leftcardCreate()
  if not ed.ui.taskScene.DailyPassReplyInTime then
    self:refreshpage()
    ed.taskNetwork:taskPassPush()
  end
  self:registerEvents()
  self:registerBtnEvents()
  if ed.ui.taskScene.DailyPassReplyInTime then
    self:refreshpage("open_panel")
  end
  ed.ui.taskScene.DailyPassReplyInTime = nil
  return self
end

function page:dragListCreate()
  local thisCon = self.ui.panel_list_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.panel_list_item,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return x
    end,
    cancelPressIn = function(x, y, oldx)
      self.touch = math.abs(oldx - x) < 50
    end
  }
  self.dragList = ed.draglist.create(info)
  local oldClearList = self.dragList.clearList
  
  function self.dragList.clearList()
    oldClearList(self.dragList)
    local label = ed.createttf("(\239\188\155\226\128\178\226\140\146`)", 14)
    label:setColor(ccc3(130, 100, 100))
    self.dragList:addItem(label, ccp(-150, 200), true)
  end
end

function page:registerEvents()
  self.sceneSelf:listenEvent("passReply", function(refreshType)
    self:refreshpage(refreshType)
  end)
  self.sceneSelf:listenEvent("rechargePollingReply", function(info)
    ed.taskNetwork:taskPassPush()
  end)
end

function page:refreshpage(refreshType)
  local isAllup = refreshType == "open_panel"
  if isAllup or refreshType == "title" then
    local passData = self.dataObj.passData
    self.ui.label_level:setString((passData.level or 0) > 9 and passData.level or "0" .. passData.level)
    local exp, toExp, per = self.dataObj:getNewLvToExp()
    self.ui.label_exp_str:setString(string.format("%d/%d", exp, toExp))
    if not self.expProgressBox then
      self.expProgressBox = ed.taskProModule.new(self.ui.day_task_progress)
      self.expProgressBox:setPro(per)
    else
      self.expProgressBox:addPro(per)
    end
    if self.dataObj.isToMax then
      self.expProgressBox:setPro(1)
      self.ui.label_exp_str:setString("max")
      EDLoadShader("GrayScalingShader_2")
      ed.setSpriteShader(self.ui.btn_Buy_lv, "GrayScalingShader_2")
      self.ui.Label_Buy_lv:setColor(ccc3(86, 86, 86))
      self.ui.Label_Buy_lv_bg:setColor(ccc3(172, 172, 172))
    end
    if self.dataObj.titleText then
      ed.setLabelString(self.ui.label_title, self.dataObj.titleText)
      self.ui.label_title:setVisible(true)
      self.ui.label_title:limitWidthByScale(155)
    end
    local dt = passData.exp_end_time - ed.getServerTime()
    local ret
    self.timeOver = dt <= 0
    if 0 < dt then
      local d, h, m, s = 0, 0, 0, 0
      d = math.floor(dt / 86400)
      if 0 ~= d then
        ret = d .. T("\229\164\169")
      end
      h = math.floor(dt % 86400 / 3600)
      if 0 ~= h then
        ret = (ret or "") .. h .. T("\229\176\143\230\151\182")
      end
      if ret then
        ret = ret .. ""
      else
        ret = T("1\229\176\143\230\151\182")
      end
    else
      ret = T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159")
    end
    self.ui.label_time:setString(T(ret))
    local d = 0
    if 0 < dt then
      d = math.floor(dt / 86400)
    end
    self.cannotBuyLv = 2 < d
    if self.cannotBuyLv or self.dataObj:getMaxLevel() <= self.dataObj.passData.level then
      EDLoadShader("GrayScalingShader_2")
      ed.setSpriteShader(self.ui.btn_Buy_lv, "GrayScalingShader_2")
      self.ui.Label_Buy_lv:setColor(ccc3(86, 86, 86))
      self.ui.Label_Buy_lv_bg:setColor(ccc3(172, 172, 172))
    end
    self.ui.btn_Buy_lv:setVisible(true)
  end
  if isAllup then
    local dayPassInfo = self.dataObj:getDayPassInfo()
    self:dragListInfo(dayPassInfo)
    local passItems = self.dataObj.passItems
    local passData = self.dataObj.passData
    self:dragListRefresh(passItems, passData)
  elseif refreshType == "level_reward" then
    local passItems = self.dataObj.passItems
    local passData = self.dataObj.passData
    self:dragListRefreshFoIndex(passItems, passData, self.dataObj.levelRewardIndex)
    if self.rigSelf then
      itemBox.refresh(self.rigSelf, {
        normalRewardType = self.rigSelf.param.normalRewardType,
        advancedRewardType = self.rigSelf.param.advancedRewardType
      })
    end
  elseif refreshType == "sweep_reward" then
    local passItems = self.dataObj.passItems
    local passData = self.dataObj.passData
    self:dragListRefresh(passItems, passData)
    if self.rigSelf then
      itemBox.refresh(self.rigSelf, {
        normalRewardType = self.rigSelf.param.normalRewardType,
        advancedRewardType = self.rigSelf.param.advancedRewardType
      })
    end
  elseif refreshType == "buy_level" then
    local passItems = self.dataObj.passItems
    local passData = self.dataObj.passData
    self.ui.label_level:setString((passData.level or 0) > 9 and passData.level or "0" .. passData.level)
    local exp, toExp, per = self.dataObj:getNewLvToExp()
    self.ui.label_exp_str:setString(string.format("%d/%d", exp, toExp))
    if not self.expProgressBox then
      self.expProgressBox = ed.taskProModule.new(self.ui.day_task_progress)
      self.expProgressBox:setPro(per)
    else
      self.expProgressBox:addPro(per)
    end
    if self.dataObj.isToMax then
      self.expProgressBox:setPro(1)
      self.ui.label_exp_str:setString("max")
    end
    self:dragListRefresh(passItems, passData)
    if self.rigSelf then
      itemBox.refresh(self.rigSelf, {
        normalRewardType = self.rigSelf.param.normalRewardType,
        advancedRewardType = self.rigSelf.param.advancedRewardType
      })
    end
    if self.dataObj.isToMax then
      EDLoadShader("GrayScalingShader_2")
      ed.setSpriteShader(self.ui.btn_Buy_lv, "GrayScalingShader_2")
      self.ui.Label_Buy_lv:setColor(ccc3(86, 86, 86))
      self.ui.Label_Buy_lv_bg:setColor(ccc3(172, 172, 172))
    end
  end
  self:btnsRefresh()
end

function page:btnsRefresh()
  local passData = self.dataObj.passData
  self.ui.Label_120:limitWidthByScale(90)
  self.ui.Label_120_Copy0:limitWidthByScale(90)
  self.ui.Label_buy:limitWidthByScale(90)
  self.ui.Label_buy_Copy0:limitWidthByScale(90)
  self.ui.btn_shoping:setVisible(passData.is_advanced == 0)
  self.ui.btn_all:setVisible(0 < self.dataObj:getred())
  local posx = self.ui.btn_all:getPositionX()
  self.ui.btn_shoping:setPositionX(self.ui.btn_all:isVisible() and posx - 140.5 or posx)
end

function page:dragListInfo(dayPassInfo)
  local lv = 0
  self.items = {}
  self.itemlight = {}
  self.heightShow = {}
  self.dragList:clearList()
  for i, v in ipairs(dayPassInfo) do
    local item = itemBox.new(self, v)
    self.dragList:addItem(item.container, ccp(i * itemBox.width - itemBox.width / 2, itemBox.height / 2 - 3))
    if v.highlight then
      table.insert(self.heightShow, v.level)
    end
    for e, m in ipairs(v.advancedReward) do
      table.insert(self.itemlight, m)
    end
    table.insert(self.items, item)
    lv = v.level or lv
  end
  self.dragList:initListWidth(#self.dragList.listItems * itemBox.width + 5)
  self:rightItemsCreate()
  local fashionId = 0
  
  local function func()
    local items = self.dataObj:getAdvancedRewardToLevel(lv) or {}
    for i, v in ipairs(items) do
      if v.id and v.id > 0 then
        local id = ed.getDataTable("equip")[v.id]["Fashion ID"]
        if id then
        end
        fashionId = 0 < id and id or fashionId or fashionId
      end
    end
    if 0 < #items and fashionId <= 0 and 0 < lv then
      lv = lv - 1
      return func()
    else
      return fashionId
    end
  end
  
  self:fashionCard(func())
end

function page:dragListRefresh(passItems, passData)
  self.moveConIndex = passData.level
  for i, v in ipairs(self.items) do
    self.moveConIndex = i < self.moveConIndex and i or self.moveConIndex or self.moveConIndex
  end
  local thisCon = self.ui.panel_list_item:getContentSize()
  self.moveConIndex = ed.clamp(self.moveConIndex, 3, #self.items - (thisCon.width / itemBox.width - 3))
  local movex = (self.moveConIndex - 3) * itemBox.width * -1
  self.dragList.listLayer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(movex, 0))))
end

function page:dragListRefreshFoIndex(passItems, passData, dataObjLevelRewardIndex)
  local isAdvanced = passData.is_advanced > 0
  local level = passData.level
  local free_pass = passItems.free_pass
  local advanced_pass = passItems.advanced_pass
  
  local function itemParam(info)
    local tab1, tab2 = {}, {}
    for i = 1, 1 do
      if level < info.level then
        tab1, tab2 = {0}, {0, 0}
        break
      end
      for i, v in ipairs(info.normalReward) do
        tab1[i] = ed.isElementInTable(i, free_pass[dataObjLevelRewardIndex] or {}) and 2 or 1
      end
      if not isAdvanced then
        tab2 = {0, 0}
        break
      end
      for i, v in ipairs(info.advancedReward) do
        tab2[i] = ed.isElementInTable(i, advanced_pass[dataObjLevelRewardIndex] or {}) and 2 or 1
      end
      break
    end
    return {normalRewardType = tab1, advancedRewardType = tab2}
  end
  
  return self.items[dataObjLevelRewardIndex]:refresh(itemParam(self.items[dataObjLevelRewardIndex].param))
end

function page:uiCreate()
  self.ui.label_exp:setStroke(ccc3(96, 56, 37), 1)
  self.ui.label_exp_str:setStroke(ccc3(96, 56, 37), 1)
  self.ui.label_level:setStroke(ccc3(96, 56, 37), 1)
  self.ui.label_hero:setFontName(ed.fontBold)
  self.ui.label_warrior:setFontName(ed.fontBold)
  self.ui.img_right:setScale(0.5)
  self.ui.label_title:setStroke(ed.toccc3(11892068), 2)
  self.ui.label_title:setFontName(ed.fontBold)
  self.ui.label_title:setVisible(false)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local ui = self.ui
  ed.right2(ui.label_time, ui.Label_351, 2)
  ed.right2(ui.label_exp_str, ui.label_exp, 2)
  newWid = newWid * 0.7
  newHei = newHei * 0
  local size = ui.title_bg_img:getContentSize()
  ui.title_bg_img:setContentSize(CCSizeMake(size.width + newWid, size.height))
  size = ui.img_down:getContentSize()
  ui.img_down:setContentSize(CCSizeMake(size.width + newWid, size.height))
  local x, y = ui.label_title:getPosition()
  ui.label_title:setPosition(x - newWid / 2, y + newHei / 2)
  x, y = ui.image_icon:getPosition()
  ui.image_icon:setPosition(x - newWid / 2, y + newHei / 2)
  x, y = ui.btn_rule_img:getPosition()
  ui.btn_rule_img:setPosition(x - newWid / 2, y + newHei / 2)
  x, y = ui.day_task_progress_bg:getPosition()
  ui.day_task_progress_bg:setPosition(x - newWid / 2, y + newHei / 2)
  size = ui.day_task_progress_bg:getContentSize()
  ui.day_task_progress_bg:setContentSize(CCSizeMake(size.width + newWid, size.height))
  x, y = ui.day_task_progress:getPosition()
  ui.day_task_progress:setPosition(x - newWid / 2, y + newHei / 2)
  size = ui.day_task_progress:getContentSize()
  ui.day_task_progress:setContentSize(CCSizeMake(size.width + newWid, size.height))
  x, y = ui.label_exp:getPosition()
  ui.label_exp:setPosition(x - newWid / 2, y + newHei / 2)
  x, y = ui.label_exp_str:getPosition()
  ui.label_exp_str:setPosition(x - newWid / 2, y + newHei / 2)
  x, y = ui.btn_Buy_lv:getPosition()
  ui.btn_Buy_lv:setPosition(x + newWid / 2, y + newHei / 2)
  x, y = ui.panel_left:getPosition()
  ui.panel_left:setPosition(x - newWid / 2, y)
  x, y = ui.img_icon_bg:getPosition()
  ui.img_icon_bg:setPosition(x - newWid / 2, y)
  x, y = ui.panel_list_item:getPosition()
  ui.panel_list_item:setPosition(x - newWid / 2, y - 0.5)
  size = ui.panel_list_item:getContentSize()
  ui.panel_list_item:setContentSize(CCSizeMake(size.width + newWid, size.height + 60))
  x, y = ui.img_right:getPosition()
  ui.img_right:setPosition(x + newWid / 2, y)
  x, y = ui.btn_shoping:getPosition()
  ui.btn_shoping:setPosition(x + newWid / 2, y)
  x, y = ui.btn_all:getPosition()
  ui.btn_all:setPosition(x + newWid / 2, y)
  x, y = ui.time_bg_img:getPosition()
  ui.time_bg_img:setPosition(x - newWid / 2, y)
  self.ui.label_level:setPositionY(self.ui.label_level:getPositionY() - 3)
end

function page:registerBtnEvents()
  local index = 1
  
  local function func(node, click, press, normal)
    self.sceneSelf:btRegisterButtonClick({
      button = node,
      key = "pass_page_" .. index,
      clickHandler = click,
      force = true,
      pressScale = press or 0.9,
      normalScale = normal or 1
    })
    index = index + 1
  end
  
  func(self.ui.btn_rule_img, function()
    local rule = T(ed.taskData.ruleTxt.pass or "", self.dataObj.passData.bonus or 1)
    if self.timeOver then
      rule = T(ed.taskData.ruleTxt.passOver or "")
    end
    ed.ui.commonRulePop.create({
      title = T("\230\136\152\232\175\129\232\175\180\230\152\142"),
      txt = rule
    }):popWindow()
  end)
  func(self.ui.btn_hero_log, function()
    local passData = self.dataObj.passData
    if passData and passData.is_advanced == 0 then
      ed.UITool.openView("psssPageShopPop", {})
    end
  end)
  func(self.ui.btn_shoping, function()
    ed.UITool.openView("psssPageShopPop", {})
  end)
  func(self.ui.panel_fashion, function()
    local passData = self.dataObj.passData
    if passData and passData.is_advanced == 0 then
      ed.UITool.openView("psssPageShopPop", {})
    end
  end)
  func(self.ui.btn_all, function()
    local items = self.dataObj:getReceiveAllItems()
    if 0 < #items then
      local geftItem, exceedItem, giveItemAll = ed.itemExceeds(items)
      self.dataObj.geftItem = ed.copyProto(geftItem)
      self.dataObj.giveItemAll = ed.copyProto(giveItemAll)
      if 0 < #exceedItem then
        ed.ui.maillocalbox.create({
          type = "deleItem",
          tag = 2,
          item = exceedItem,
          clickGeft = function()
            ed.taskNetwork:sendDailyPassSweep()
          end,
          clickBack = function()
          end,
          str = T("\233\131\168\229\136\134\229\165\150\229\138\177\231\137\169\229\147\129\233\162\134\229\143\150\229\144\142\229\176\134\232\182\133\229\135\186\228\184\138\233\153\144\239\188\140\229\187\186\232\174\174\230\184\133\231\144\134\232\131\140\229\140\133\229\144\142\229\134\141\230\157\165\233\162\134\229\143\150\227\128\130(\229\188\186\232\161\140\233\162\134\229\143\150\229\176\134<lable color=mailRed>\230\184\133\233\153\164</lable>\232\182\133\228\184\138\233\153\144\233\131\168\229\136\134)<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
          btnStr = T("\229\143\150\230\182\136")
        }):popWindow()
      else
        ed.taskNetwork:sendDailyPassSweep()
      end
    else
      ed.showToast(T("\229\183\178\230\151\160\229\143\175\233\162\134\229\143\150\229\165\150\229\138\177"))
      self.dataObj:setred(0)
      self:btnsRefresh()
    end
  end)
  func(self.ui.btn_Buy_lv, function()
    if self.cannotBuyLv then
      ed.showToast(T("\230\136\152\232\175\129\229\137\169\228\189\153\230\151\182\233\151\180\229\176\143\228\186\1423\229\164\169\230\151\182\239\188\140\229\188\128\229\144\175\232\180\173\228\185\176\231\173\137\231\186\167\229\138\159\232\131\189"))
      return
    end
    if self.dataObj:getMaxLevel() <= self.dataObj.passData.level then
      return
    end
    ed.UITool.openView("psssPageBuyLevel", {})
  end)
end

local function btRegisterButtonClickToListItems()
  return function(self, param)
    self.sceneSelf:btRegisterButtonClick({
      button = param.button,
      key = "pass_page_items" .. self.index,
      radioGroupName = "items",
      param = param,
      clickHandler = function(param, x, y)
        if not ed.containsPoint(self.ui.panel_list_item, x, y) then
          return
        end
        if self.ui.img_right:isVisible() and ed.containsPoint(self.ui.img_right, x, y) and not param.isbox then
          return
        end
        if self.touch then
          local data = param.data or {}
          local state = data.state or 0
          if state == 0 then
            ed.ui.packageDetailWin.create(data):popWindow()
          elseif state == 1 then
            local overfull = {}
            if ed.player:isItemOverfull({
              id = data.id,
              type = data.type,
              amount = data.amount
            }) and data.type ~= "simple_chest" then
              table.insert(overfull, {
                id = data.id,
                amount = data.amount,
                kind = data.type,
                type = data.type
              })
            end
            if 0 < #overfull then
              local panel = ed.ui.maillocalbox.create({
                type = "deleItem",
                tag = 2,
                btnStr = T("\229\143\150\230\182\136"),
                str = T("\229\165\150\229\138\177\228\184\173\229\144\171\230\156\137\233\162\134\229\143\150\229\144\142\229\176\134\228\188\154\232\182\133\232\191\135\228\184\138\233\153\144\231\154\132\231\137\169\229\147\129,\232\182\133\228\184\138\233\153\144\231\137\169\229\147\129\229\176\134\232\162\171<lable color=mailRed>\230\184\133\233\153\164</lable>\227\128\130<br/>\232\182\133\232\191\135\228\184\138\233\153\144\231\137\169\229\147\129:"),
                item = overfull,
                clickGeft = function()
                  ed.taskNetwork:sendLevelReward(param.level, param.index, param.isAdvanced)
                end,
                clickBack = function()
                end
              }):popWindow()
            else
              ed.taskNetwork:sendLevelReward(param.level, param.index, param.isAdvanced)
            end
          elseif state == 2 then
            ed.ui.packageDetailWin.create(data):popWindow()
          end
        end
      end,
      force = true,
      pressScale = 0.75,
      normalScale = 0.8
    })
    self.index = self.index + 1
  end
end

page.btRegisterButtonClickToListItems = btRegisterButtonClickToListItems()

function page:rightItemsCreate()
  self.ui.label_right_lv:setFontName(ed.fontBold)
  self.rightItemLay = CCLayer:create()
  self.rightItemLay:setContentSize(CCSizeMake(itemBox.width, itemBox.height))
  self.rightItemLay:setPosition(25 + itemBox.width / 2, 9 + itemBox.height / 2)
  self.ui.img_right:addChild(self.rightItemLay)
  self.refreshPhaseRewardTimer = ListenTimer(Timer:Always(0.1), self:rightItemsRefresh(self.dragList))
end

function page:getNewShowIdexfunc(listX)
  local thisCon = self.ui.panel_list_item:getContentSize()
  local idex = ed.clamp(math.floor((listX + thisCon.width) / itemBox.width), 1, #self.items)
  if idex >= #self.items - 1 then
    return "end"
  end
  self.heightShow = self.heightShow or {}
  for i, v in ipairs(self.heightShow) do
    if v >= idex then
      return v
    end
  end
  return "end"
end

function page:rightItemsRefresh(drag)
  local posx, index = -50, 0
  return function()
    if not self.refreshPhaseRewardTimer then
      return
    end
    local listX = math.abs(drag.listLayer:getPositionX())
    if posx ~= listX then
      local idx = self:getNewShowIdexfunc(listX)
      if idx == "end" and idx ~= index then
        self.ui.img_right:stopAllActions()
        self.ui.img_right:runAction(CCSequence:create(ccArrayMake(unpack({
          CCEaseBackIn:create(CCScaleTo:create(0.1, 0.3)),
          CCCallFunc:create(function()
            self.ui.img_right:setVisible(false)
          end)
        }))))
      elseif type(idx) == "number" and idx ~= index then
        self.ui.img_right:stopAllActions()
        local action = {
          CCCallFunc:create(function()
            self.rightItemLay:removeAllChildrenWithCleanup(true)
            local rigSelf = {
              sceneSelf = self,
              param = setmetatable(self.items[idx].param, {
                __index = {box = true}
              }),
              ui = {
                itemsLay = self.rightItemLay,
                level = self.ui.label_right_lv
              }
            }
            self.rigSelf = rigSelf
            itemBox.create(rigSelf)
            itemBox.refresh(rigSelf, {
              normalRewardType = rigSelf.param.normalRewardType,
              advancedRewardType = rigSelf.param.advancedRewardType
            })
          end),
          CCEaseBackOut:create(CCScaleTo:create(0.1, 1))
        }
        if not self.ui.img_right:isVisible() then
          self.ui.img_right:setVisible(true)
        else
          table.insert(action, 1, CCEaseBackIn:create(CCScaleTo:create(0.1, 0.9)))
        end
        self.ui.img_right:runAction(CCSequence:create(ccArrayMake(unpack(action))))
      end
      index = idx
      posx = listX
    end
  end
end

function page:delete()
  CloseEvent("passReply")
  CloseEvent("rechargePollingReply")
  if self.refreshPhaseRewardTimer then
    CloseTimer(self.refreshPhaseRewardTimer.Name)
    self.refreshPhaseRewardTimer = nil
  end
  self.sceneSelf:removeFca(self.fashionFca)
  self.fashionFca = nil
  self.fashionSpine = nil
end

function page:leftcardCreate()
  local size = self.ui.panel_fashion:getContentSize()
  local clipLayer = CCLayer:create()
  clipLayer:setPosition(ccpAdd(ed.getCenterPos(self.ui.panel_fashion), ccp(10, 24)))
  clipLayer:setClipRect(CCRectMake(size.width / 2 * -1, size.height / 2 * -1, size.width, size.height))
  self.ui.panel_left:addChild(clipLayer)
  self.fashionCardLay = clipLayer
end

function page:fashionCard(fashion_id)
  if self.fashionFca or self.fashionSpine then
    return
  end
  if not fashion_id or fashion_id == 0 then
    print("[---   find fashion_id nil !!!   ---]")
  end
  fashion_id = fashion_id and (0 < fashion_id and fashion_id or 331) or 331
  self.ui.card_img_top:setVisible(false)
  self.ui.award_bg_img:setVisible(false)
  self.ui.label_award:setVisible(false)
  local heroId = ed.lookupDataTable("Fashion", "Hero ID", fashion_id)
  local card = ed.readhero.getHeroCard(heroId, {
    hide_star = true,
    starType = "init",
    OriSize = true,
    fashion_id = fashion_id or 0
  }, {
    index = 1,
    _tid = heroId,
    _stars = 2,
    _level = 1,
    _rank = 1,
    _items = {}
  })
  local card_ui = card.container
  card_ui:setPosition(ccp(10, -18))
  card_ui:setScale(0.78)
  self.ui.panel_left:addChild(card_ui, 998)
  for _, effect_fca in pairs(card.card_fashion_effect or {}) do
    self.sceneSelf:addFca(effect_fca)
  end
  if ed.isAreaZh() then
    local fashBg = ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashion_id, "fashionNameBg"),
      pos = ccp(2.5, 240),
      parent = self.ui.panel_left,
      z = 999
    })
    local qualityLabel = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashion_id))(ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashion_id, "qualityBg"),
      pos = ccp(22, 22),
      parent = fashBg
    }), ccp(28, 26), 18)
    qualityLabel:limitWidthByScale(45)
    local name = ed.lookupDataTable("Fashion", "Name", fashion_id)
    local label = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashion_id))(fashBg, ccp(24, 68), 19)
    ed.setLabelDimensions(label, CCSizeMake(22, 150))
    label:setString(name)
  else
    local fashBg = ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashion_id, "fashionNameBg_Globe"),
      pos = ccp(105, 65),
      parent = self.ui.panel_left,
      z = 999
    })
    local qualityLabel = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashion_id))(ed.createSpriteTools({
      res = ed.getFashionFrameRes(fashion_id, "qualityBg"),
      pos = ccp(22, 22),
      parent = fashBg
    }), ccp(28, 26), 18)
    qualityLabel:limitWidthByScale(45)
    local name = ed.lookupDataTable("Fashion", "Name", fashion_id)
    local label = ed.createFashionFrameName(ed.lookupDataTable("Fashion", "Quality", fashion_id))(fashBg, ccp(110, 22), 19)
    label:setString(name)
    ed.adaptLabel(label, {maxWidth = 120, minScale = 0.8})
  end
end

local fixWid = ed.display.halfFixedWidth * 2
local fixHei = ed.display.halfFixedHeight * 2
itemBox.width = 77
local ui_info = {
  {
    t = "Layer",
    base = {name = "itemsLay"},
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    },
    config = {
      scaleSize = CCSizeMake(itemBox.width, 210)
    }
  },
  {
    t = "Scale9Sprite",
    base = {
      name = "itemBg",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_item_bg.png",
      parent = "itemsLay",
      capInsets = CCRectMake(13.5, 34.5, 50, 300)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -6)
    },
    config = {
      scaleSize = CCSizeMake(77, 383)
    }
  },
  {
    t = "Scale9Sprite",
    base = {
      name = "itemPass",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_item_pass.jpg",
      parent = "itemsLay",
      capInsets = CCRectMake(13.5, 31, 50, 300)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -3)
    },
    config = {
      scaleSize = CCSizeMake(77, 376),
      visible = false
    }
  },
  {
    t = "Label",
    base = {
      name = "level",
      font = ed.fontBold,
      text = T("1\231\186\167"),
      size = 18,
      parent = "itemsLay"
    },
    layout = {
      position = ccp(0, itemBox.height / 2 - 18)
    },
    config = {
      color = ed.toccc3(16772224)
    }
  }
}

function itemBox.new(pgSelf, param)
  local container, ui = ed.editorui(ui_info)
  return setmetatable({
    sceneSelf = pgSelf,
    param = param,
    container = container,
    ui = ui
  }, {__index = itemBox}):create()
end

function itemBox:create()
  local param = self.param or {}
  self.ui.level:setString(T("%d\231\186\167", param.level))
  self.ui.level:limitWidthByScale(65)
  local nItems = {}
  local posy = itemBox.height / 2 / 2 - #param.normalReward * 22 - 35
  for i, v in ipairs(param.normalReward) do
    local item = ed.taskItemModule.new(self.sceneSelf, v, param.level, i, false, param.box)
    item.icon:setPosition(0, posy + i * 55)
    self.ui.itemsLay:addChild(item.icon)
    table.insert(nItems, item)
  end
  local aItems = {}
  posy = itemBox.height / 2 / 2 * -1 - #param.advancedReward * 40 - 30
  for i, v in ipairs(param.advancedReward) do
    local item = ed.taskItemModule.new(self.sceneSelf, v, param.level, i, true, param.box)
    item.icon:setPosition(0, posy + i * 80)
    self.ui.itemsLay:addChild(item.icon)
    table.insert(aItems, item)
  end
  self.items = {nItems = nItems, aItems = aItems}
  return self
end

function itemBox:refresh(param)
  self.param.normalRewardType = param.normalRewardType or {0, 0}
  self.param.advancedRewardType = param.advancedRewardType or {0, 0}
  local topShow = false
  for i, v in ipairs(self.items.nItems or {}) do
    topShow = v:refresh(self.param.normalRewardType[i]) or topShow
  end
  for i, v in ipairs(self.items.aItems or {}) do
    topShow = v:refresh(self.param.advancedRewardType[i]) or topShow
  end
  if self.ui.itemPass then
    self.ui.itemPass:setVisible(topShow)
  end
  return topShow
end

return page
