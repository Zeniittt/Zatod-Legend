local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueBlessChooseScene = class
class.TYPE_CHOOSE_BLESS = "choose_bless"
class.TYPE_DELETE_BLESS = "delete_bless"
class.TYPE_ENHANCE_BLESS = "enhance_bless"
ed.UITool.registViewOpenFunc("rogueBlessChooseScene", function(param)
  ed.ui.rogueBlessChooseScene.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueBlessChooseScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.type = param.type or self.TYPE_CHOOSE_BLESS
  self.blessIdList = param.blessIdList or {}
  self.chooseAmount = param.chooseAmount or 0
  self.refreshMax = param.refreshMax or 0
  self.refreshTimes = param.refreshTimes or 0
  self.refreshPrice = 0
  self.tips = param.tips
  self.closeCallBack = param.closeCallBack
  self.selectCardCfg = nil
  self.selectBlessIdList = {}
  self.isShowDetail = false
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBlessChooseScene)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initDestiny()
  self:adaptUI()
  self:initEffect()
  self:initDragList()
  self:refreshTitleTips()
  self:refreshBtnDetail()
  self:refreshPearlAmount()
  self:refreshBtn()
  self:refreshDragList()
  self:showCardEnterAction()
  ed.rogueGuide.getInstance():startGuide("rogueBlessChooseScene", self.cardList[1] and self.cardList[1].card)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_refres_left_times, ed.toccc3(6364037), 1)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_bless, {left = 30})
  ed.layout.layoutWithMagin(self.ui.btn_team, {left = 16})
  ed.layout.layoutWithMagin(self.ui.image_destiny_bg, {left = 16}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_amount_bg, {right = 30})
  ed.layout.layoutWithMagin(self.ui.label_bat_tips, {right = 140})
  ed.layout.layoutWithMagin(self.ui.btn_detail, {right = 210})
  self.ui.label_bless:limitSizeByScale(110, 30)
  self.ui.label_bless:setHorizontalAlignment(kCCTextAlignmentCenter)
  local diffWidth = ed.display.winSize.width - 960
  self.ui.panel_list:setPositionX(self.ui.panel_list:getPositionX() - diffWidth / 2)
  local oldSize = self.ui.panel_list:getContentSize()
  self.ui.panel_list:setContentSize(CCSizeMake(oldSize.width + diffWidth, oldSize.height))
  self.ui.image_arrow_left:setPositionX(self.ui.image_arrow_left:getPositionX() + diffWidth / 2)
  self.ui.image_arrow_right:setPositionX(self.ui.image_arrow_right:getPositionX() - diffWidth / 2)
  local offsetX = 10
  local action1 = CCSequence:create(ccArrayMake(CCMoveBy:create(1, ccp(offsetX, 0)), CCMoveBy:create(1, ccp(-offsetX, 0))))
  self.ui.image_arrow_left:runAction(CCRepeatForever:create(action1))
  local action2 = CCSequence:create(ccArrayMake(CCMoveBy:create(1, ccp(-offsetX, 0)), CCMoveBy:create(1, ccp(offsetX, 0))))
  self.ui.image_arrow_right:runAction(CCRepeatForever:create(action2))
end

function class:initEffect()
end

function class:initDestiny()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local destinyId = curChapter._destiny
  local rogueDestinyCfg = ed.getDataTable("RogueDestiny")[destinyId]
  ed.setLabelString(self.ui.label_destiny_name, string.format(T("\229\189\147\229\137\141\229\145\189\232\191\144\239\188\154%s"), rogueDestinyCfg["Display Name"]))
  local iconPath = string.format("UI/alpha/1080P/rogue/bless/%s.png", rogueDestinyCfg.Icon)
  ed.setTexture(self.ui.image_destiny_icon, iconPath)
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    doScroll = function()
      self:refreshArrow()
    end
  })
end

function class:getPressInHandler()
  local function handle(x, y)
    for _, cardCfg in ipairs(self.cardList) do
      local card = cardCfg.card
      
      if ed.containsPoint(card, x, y) then
        card:setScale(0.95)
        return cardCfg
      end
    end
  end
  
  return handle
end

function class:getClickInHandler()
  local function handle(x, y, cardCfg)
    local card = cardCfg.card
    
    local ui = cardCfg.ui
    local blessId = cardCfg.blessId
    if self.chooseAmount == 0 then
    elseif self.chooseAmount == 1 then
      self.selectBlessIdList = {}
      self.selectBlessIdList[blessId] = 1
    elseif self.selectBlessIdList[blessId] then
      self.selectBlessIdList[blessId] = nil
    else
      local curChooseAmount = 0
      for _, _ in pairs(self.selectBlessIdList) do
        curChooseAmount = curChooseAmount + 1
      end
      if curChooseAmount < self.chooseAmount then
        self.selectBlessIdList[blessId] = 1
      else
        ed.showToast(string.format(T("\229\143\170\232\131\189\233\128\137\230\139\169%s\228\184\170\231\165\157\231\166\143"), self.chooseAmount))
      end
    end
    self:refreshBlessList()
    ed.rogueGuide.getInstance():endGuide("rogueBlessChooseScene")
  end
  
  return handle
end

function class:getCancelPressInHandler()
  local function handle(x, y, cardCfg)
    local card = cardCfg.card
    
    card:setScale(1)
  end
  
  return handle
end

function class:refreshDragList()
  self.dragList:clearList()
  local panelSize = self.ui.panel_list:getContentSize()
  local totalWidth = 0
  self.cardList = {}
  for index, blessId in ipairs(self.blessIdList) do
    local descType = self.isShowDetail and "Full Description" or "Description"
    local rogueBless = self.rogueLikeMgr:getBlessById(blessId)
    local blessCard, ui = ed.rogueLikeTool.createBlessCard(blessId, {
      descType = descType,
      isReinforce = rogueBless and rogueBless._level > 1
    })
    self.dragList:addItem(blessCard)
    ui.image_select:setVisible(self.selectBlessIdList[blessId] and true or false)
    table.insert(self.cardList, {
      card = blessCard,
      ui = ui,
      blessId = blessId
    })
    local cardSize = blessCard:getContentSize()
    totalWidth = totalWidth + cardSize.width
  end
  local posX = 0
  for index, cardCfg in ipairs(self.cardList) do
    local card = cardCfg.card
    local cardSize = card:getContentSize()
    local offset = math.max(0, (panelSize.width - totalWidth) / 2)
    card:setPosition(ccp(posX + offset + cardSize.width / 2, 180))
    posX = posX + cardSize.width
  end
  self.dragList:initListWidth(totalWidth)
  self:refreshArrow()
end

function class:createAnchorAction(card)
  return CCCallFunc:create(function()
    local posY = card:getPositionY()
    card:setAnchorPoint(ccp(0.5, 0.5))
    card:setPositionY(posY + card:getContentSize().height * 0.5)
  end)
end

function class:showCardEnterAction()
  local offsetY = 200
  local delay = 0.1
  for index, cardCfg in ipairs(self.cardList) do
    local card = cardCfg.card
    local ui = cardCfg.ui
    card:setScaleY(1.3)
    card:setOpacity(0)
    card:setAnchorPoint(ccp(0.5, 0))
    local cardSize = card:getContentSize()
    card:setPositionY(card:getPositionY() + offsetY - cardSize.height / 2)
    local delayTime = CCDelayTime:create((index - 1) * delay)
    local moveAction = CCEaseSineOut:create(CCMoveBy:create(0.20833333333333334, ccp(0, -offsetY)))
    local scaleAction = CCScaleTo:create(0.20833333333333334, 1)
    local fadeAction = CCFadeTo:create(0.20833333333333334, 255)
    local finaAction = CCSequence:create(ccArrayMake(delayTime, CCSpawn:create(ccArrayMake(moveAction, scaleAction, fadeAction)), self:createAnchorAction(card)))
    card:stopAllActions()
    card:runAction(finaAction)
    ui.descAutoTextNode:setOpacity(0)
    local delayTime1 = CCDelayTime:create((index - 1) * delay)
    local fadeAction1 = CCFadeTo:create(0.20833333333333334, 255)
    local finaAction1 = CCSequence:create(ccArrayMake(delayTime1, CCSpawn:create(ccArrayMake(fadeAction1))))
    ui.descAutoTextNode:stopAllActions()
    ui.descAutoTextNode:runAction(finaAction1)
  end
end

function class:showCardOutAction()
end

function class:refreshArrow()
  local listX, listY = self.dragList:getListPos()
  local listWidth = self.dragList.listWidth
  local panelSize = self.ui.panel_list:getContentSize()
  if listWidth < panelSize.width then
    self.ui.image_arrow_left:setVisible(false)
    self.ui.image_arrow_right:setVisible(false)
    return
  end
  if -20 < listX then
    self.ui.image_arrow_left:setVisible(false)
  else
    self.ui.image_arrow_left:setVisible(true)
  end
  if listX < panelSize.width - listWidth + 20 then
    self.ui.image_arrow_right:setVisible(false)
  else
    self.ui.image_arrow_right:setVisible(true)
  end
end

function class:refreshBlessList()
  for index, cardCfg in ipairs(self.cardList) do
    local ui = cardCfg.ui
    local blessId = cardCfg.blessId
    if self.selectBlessIdList[blessId] then
      ui.image_select:setVisible(true)
    else
      ui.image_select:setVisible(false)
    end
  end
end

function class:refreshBtnDetail()
  local btnBgPath, switchPath
  if self.isShowDetail then
    btnBgPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_on.png"
    switchPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_button2.png"
  else
    btnBgPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_close.png"
    switchPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_button1.png"
  end
  ed.setTexture(self.ui.btn_detail, btnBgPath)
  ed.setTexture(self.ui.image_detail_switch, switchPath)
end

function class:refreshPearlAmount()
  ed.setLabelString(self.ui.label_amount, self.rogueLikeMgr:getPearl())
end

function class:refreshBtn()
  if self.refreshMax > 0 then
    local leftTimes = self.refreshMax - self.refreshTimes
    ed.setLabelString(self.ui.label_refresh_left_times, leftTimes)
    if 0 < leftTimes then
      ed.setLabelColor(self.ui.label_refresh_left_times, ed.toccc3(16372208))
      ed.setLabelStroke(self.ui.label_refresh_left_times, ed.toccc3(6364037), 1)
    else
      ed.setLabelColor(self.ui.label_refresh_left_times, ed.toccc3(16735789))
      ed.setLabelStroke(self.ui.label_refresh_left_times, ed.toccc3(2368548), 1)
      ed.setSpriteGray(self.ui.btn_refresh)
    end
    ed.setLabelString(self.ui.label_refresh_left_times_max, string.format("/%s", self.refreshMax))
    self.refreshPrice = ed.getDataTable("RogueConfig")["Refresh Price"]["Script Arg"] or 0
    local curChapter = self.rogueLikeMgr:getCurChapter()
    if nil ~= curChapter._refresh_bless_param then
      table.sort(curChapter._refresh_bless_param, function(a, b)
        return a._price < b._price
      end)
      local checkVal = self.refreshTimes
      for i, v in ipairs(curChapter._refresh_bless_param) do
        if checkVal < v._times then
          self.refreshPrice = v._price
          break
        else
          checkVal = checkVal - v._times
        end
      end
    end
  else
    self.ui.btn_refresh:setVisible(false)
    self.ui.label_refresh_left_times_tips:setVisible(false)
    self.ui.label_refresh_left_times:setVisible(false)
    self.ui.label_refresh_left_times_max:setVisible(false)
    ed.layout.centerXInParent(self.ui.btn_confirm)
  end
  ed.setLabelString(self.ui.label_refresh_price, self.refreshPrice)
  local pearl = self.rogueLikeMgr:getPearl()
  if pearl < self.refreshPrice then
    ed.setSpriteGray(self.ui.btn_refresh)
  end
  ed.layout.horizontalSortNode({
    self.ui.label_refresh,
    self.ui.label_refresh_price,
    self.ui.pearl_icon
  }, {17, 4}, self.ui.btn_refresh:getContentSize().width * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.label_refresh_left_times_tips,
    self.ui.label_refresh_left_times,
    self.ui.label_refresh_left_times_max
  }, {0, 0}, self.ui.btn_refresh:getPositionX())
end

function class:refreshTitleTips()
  local autoText = ed.ui.autoText.new()
  local context, color
  if self.tips then
    context = self.tips
    if self.type == self.TYPE_DELETE_BLESS then
      color = ed.toccc3(16742502)
      ed.setTexture(self.ui.image_bg, "UI/alpha/1080P/rogue/bless/bless_choose_lose.png")
    end
  else
    local curRoomId = self.rogueLikeMgr:getCurRoomId()
    local roomData = self.rogueLikeMgr:getRoomData(curRoomId)
    if roomData.type == "normal_battle" then
      context = T("\228\189\160\229\135\187\232\180\165\228\186\134\230\153\174\233\128\154\230\149\140\228\186\186\239\188\140\232\175\183\233\128\137\230\139\1691\228\184\170\231\165\157\231\166\143")
    elseif roomData.type == "elite_battle" then
      context = T("\228\189\160\229\135\187\232\180\165\228\186\134\231\178\190\232\139\177\230\149\140\228\186\186\239\188\140\232\175\183\233\128\137\230\139\1691\228\184\170\231\165\157\231\166\143")
    elseif roomData.type == "ex_elite_battle" then
      context = T("\228\189\160\229\135\187\232\180\165\228\186\134\231\178\190\232\139\177\230\149\140\228\186\186\239\188\140\232\175\183\233\128\137\230\139\1691\228\184\170\231\165\157\231\166\143")
    else
      context = T("\232\175\183\233\128\137\230\139\169\228\184\128\228\184\170\231\165\157\231\166\143")
    end
  end
  if not context then
    return
  end
  local limitWidth = (self.ui.btn_detail:getPositionX() - self.ui.btn_detail:getContentSize().width * 0.5 - self.ui.image_tips_bg:getPositionX() - 5) * 2
  autoText:initParam({
    context = context,
    fontSize = 18,
    color = color or ed.toccc3(16776423),
    strokeColor = ed.toccc3(3085579),
    strokeSize = 1.5,
    maxWidth = 9999
  })
  self.ui.image_tips_bg:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  local adaptScale = math.min(1, limitWidth / w)
  autoText.node:setScale(adaptScale)
  autoText.node:setPosition((self.ui.image_tips_bg:getContentSize().width - w * adaptScale) / 2, (self.ui.image_tips_bg:getContentSize().height + h * adaptScale - autoText:getFirstLineHeight() * adaptScale) * 0.5)
end

function class:onClickBtnRefresh()
  local refreshLeftTimes = self.refreshMax - self.refreshTimes
  if refreshLeftTimes <= 0 then
    ed.showToast(T("\229\136\183\230\150\176\230\172\161\230\149\176\228\184\141\232\182\179"))
    return
  end
  local pearlAmount = self.rogueLikeMgr:getPearl()
  if pearlAmount < self.refreshPrice then
    ed.showToast(T("\231\143\141\231\143\160\230\149\176\233\135\143\228\184\141\232\182\179"))
    return
  end
  self.rogueLikeMgr:sendRogueRefreshBless()
end

function class:onClickBtnConfirm()
  local selectIndexList = {}
  for index, blessId in pairs(self.blessIdList) do
    if self.selectBlessIdList[blessId] then
      table.insert(selectIndexList, index)
    end
  end
  if #selectIndexList ~= self.chooseAmount then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\231\165\157\231\166\143"))
  else
    if 0 < #selectIndexList then
      self.rogueLikeMgr:sendRogueChooseReward(selectIndexList)
    end
    if self.closeCallBack then
      self.closeCallBack()
    end
  end
end

function class:onClickBtnBless()
  ed.UITool.openView("rogueBlessScene")
end

function class:onClickBtnDetail()
  self.isShowDetail = not self.isShowDetail
  local pos
  if self.isShowDetail then
    pos = ccp(40, 10)
  else
    pos = ccp(10, 10)
  end
  local moveAction = CCMoveTo:create(0.3, pos)
  local callFunc = CCCallFunc:create(function()
    self:refreshBtnDetail()
    self:refreshDragList()
  end)
  local action = CCSequence:create(ccArrayMake(moveAction, callFunc))
  self.ui.image_detail_switch:runAction(action)
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

function class:onClickDestinyIcon()
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local destinyId = curChapter._destiny
  local win = ed.ui.rogueRevelationDetailWindow.create({destinyId = destinyId})
  win:popWindow()
  ed.layout.relateLayout(self.ui.image_destiny_bg, win.ui.image_bg, {
    right = self.ui.image_destiny_bg:getContentSize().width / 2,
    top = win.ui.image_bg:getContentSize().height / 2
  })
end

function class:onClickPearl()
  ed.ui.packageDetailWin.create({type = "pearl"}):popWindow()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_refresh", function()
    self:onClickBtnRefresh()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_bless", function()
    self:onClickBtnBless()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_detail", function()
    self:onClickBtnDetail()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_team", function()
    self:onClickBtnTeam()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_destiny_bg", function()
    self:onClickDestinyIcon()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_amount_bg", function()
    self:onClickPearl()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("rogueRefreshBless", function(rogueResult)
    self.selectCardCfg = nil
    self.selectBlessIdList = {}
    self.refreshMax = rogueResult._refresh_max or 0
    self.refreshTimes = rogueResult._refresh_time or 0
    self.blessIdList = rogueResult._params or {}
    self.chooseAmount = rogueResult._need_choose or 0
    self:refreshDragList()
    self:refreshBtn()
    self:showCardEnterAction()
  end)
  self:listenEvent("rogueHandleResultStart", function(rogueResult)
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("rogueHandleResultFinish", function(rogueResult)
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("rogueUpdatePearlAmount", function()
    self:refreshPearlAmount()
  end)
end
