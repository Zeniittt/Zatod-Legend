local base = ed.ui.commonscene
local RechargeScene = newclass(base.mt)
ed.ui.RechargeScene = RechargeScene
local RechargeSceneScope = {}
local MonthCardConfig = {
  MonthlyCard = {
    T("<sprite src=UI/alpha/1080P/icon/diamond.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\230\175\143\230\151\165\233\162\134\229\143\150dailyDiamond\233\146\187\231\159\179</lable>"),
    T("<sprite src=UI/alpha/1080P/icon/vitality.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\228\189\147\229\138\155\228\184\138\233\153\144\229\162\158\229\138\160vitalityUp\231\130\185</lable>"),
    T("<sprite scale=0.47 src=UI/alpha/1080P/fireforge/icon_mainboard.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\232\167\163\233\148\129\233\162\157\229\164\150\233\148\187\233\128\160\230\160\143\228\189\141</lable>"),
    T("<sprite src=UI/alpha/1080P/icon/fancytower_candle_small.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\229\185\187\231\148\159\231\131\155\228\184\138\233\153\144\229\162\158\229\138\160candleMaxUp\231\130\185</lable>"),
    T("<sprite src=UI/alpha/1080P/icon/vitality.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\229\133\141\232\180\185\232\161\165\233\162\134\229\142\168\229\168\152\231\148\132\233\128\137</lable>"),
    T("<sprite src=UI/alpha/1080P/icon/gold.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\230\175\143\230\151\165\233\166\150\230\172\161\231\130\185\233\135\145\230\137\139\229\133\141\232\180\185</lable>"),
    T("<sprite src=UI/alpha/1080P/icon/exp.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\229\165\150\229\138\177\230\137\190\229\155\158\232\138\177\232\180\185\228\186\1716\230\138\152</lable>")
  },
  FreeCard = {
    T("<lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>  \231\187\136\232\186\171\229\133\141\232\180\185\239\188\140\230\176\184\228\184\141\232\191\135\230\156\159\239\188\129</lable>"),
    T("<sprite src=UI/alpha/1080P/icon/diamond.png><lable color=ccc3(67,59,56) strokeColor=strokeColor2 strokeSize=1>\230\175\143\230\151\165\233\162\134\229\143\150dailyDiamond\233\146\187\231\159\179</lable>")
  }
}
if ed.isAreaOverSea() then
  table.remove(MonthCardConfig.MonthlyCard, 3)
end
local MinorTips = {
  ko = {
    shortTips = "\235\175\184\236\132\177\235\133\132\236\158\144 \234\181\172\235\167\164 \236\130\172\237\149\173",
    longTips = "\236\178\173\236\149\189\236\178\160\237\154\140\235\138\148 \234\181\172\235\167\164\236\157\188 \234\184\176\236\164\128 7\236\157\188 \236\157\180\235\130\180 \234\176\128\235\138\165(\235\139\168,\236\130\172\236\154\169 \235\176\143 \236\166\137\236\139\156 \236\160\129\236\154\169, \236\182\148\234\176\128 \237\152\156\237\131\157 \236\160\156\234\179\181 \236\131\129\237\146\136\236\157\128 \236\178\173\236\149\189\236\178\160\237\154\140 \235\182\136\234\176\128).\235\178\149\235\165\160 \235\140\128\235\166\172\236\157\184 \235\143\153\236\157\152 \236\151\134\235\138\148 \235\175\184\236\132\177\235\133\132\236\158\144 \234\178\176\236\160\156\235\138\148 \236\183\168\236\134\140 \234\176\128\235\138\165",
    superLinkText = "\236\158\144\236\132\184\237\149\156 \235\130\180\236\154\169\236\157\132 \235\179\180\235\160\164\235\169\180 \237\129\180\235\166\173\237\149\152\236\132\184\236\154\148.",
    linkUrl = "https://www.farlightgames.com/termsofservice?locale=ko"
  },
  ja = {
    shortTips = "\231\137\185\229\174\154\229\149\134\229\143\150\229\188\149\230\179\149\227\129\171\227\129\164\227\129\132\227\129\166",
    longTips = "[\230\156\170\230\136\144\229\185\180\239\188\13618\230\173\179\230\156\170\230\186\128\239\188\137\227\129\174\230\150\185\227\129\184]\227\131\128\227\130\164\227\131\164\227\130\146\232\178\183\227\129\134\230\153\130\227\129\175\227\128\129\232\166\170\230\168\169\232\128\133\227\129\171\229\191\133\227\129\154\229\144\140\230\132\143\227\130\146\227\130\130\227\130\137\227\129\163\227\129\166\227\129\139\227\130\137\227\128\129\228\184\128\231\183\146\227\129\171\232\178\183\227\129\134\227\130\136\227\129\134\227\129\171\227\129\151\227\129\166\227\129\143\227\129\149\227\129\132 1\227\131\181\230\156\136\227\129\130\227\129\159\227\130\138\227\129\174\232\179\188\229\133\165\233\153\144\229\186\166\233\161\141\227\129\175\228\187\165\228\184\139\227\129\174\233\128\154\227\130\138\227\129\167\227\129\153\227\128\130 \227\131\18716\230\173\179\230\156\170\230\186\128\239\188\1545000\229\134\134\227\129\190\227\129\167 \227\131\18716\230\173\179\228\187\165\228\184\13818\230\173\179\230\156\170\230\186\128\239\188\15420,000\229\134\134\227\129\190\227\129\167 \227\131\18718\230\173\179\228\187\165\228\184\138\239\188\154\233\153\144\229\186\166\233\161\141\227\129\170\227\129\151"
  },
  tw = {
    shortTips = "\230\156\170\230\136\144\229\185\180\232\179\188\232\178\183\230\179\168\230\132\143\228\186\139\233\160\133",
    longTips = "\230\156\137\233\153\144\229\136\182\232\161\140\231\130\186\232\131\189\229\138\155\228\186\186\230\136\150\231\132\161\232\161\140\231\130\186\232\131\189\229\138\155\228\186\186\233\156\128\231\182\147\230\179\149\229\174\154\228\187\163\231\144\134\228\186\186\229\144\140\230\132\143\230\137\141\229\143\175\232\179\188\232\178\183\227\128\130",
    superLinkText = "\233\187\158\230\147\138\230\159\165\231\156\139\232\169\179\230\131\133",
    linkUrl = "https://www.ori.tw/termofservice.html"
  }
}
RechargeScene.MinorTips = MinorTips

function RechargeScene.create(param)
  local self = base.create("RechargeScene", {noBottomButton = true})
  setmetatable(self, RechargeScene.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:registerOnEnterHandler("rechargeSceneOnEnter", function()
    self:refreshLayer()
    local all, tickedDataSum = ed.RechargeManager:getAllTicketNumber()
    if 0 < all and ed.RechargeManager.needNoticeTicket then
      if 0 < tickedDataSum then
        ed.showAlertDialog({
          text = T("\230\130\168\232\180\173\228\185\176\231\154\132\229\149\134\229\147\129\228\187\165\228\187\163\233\135\145\229\136\184\231\154\132\229\189\162\229\188\143\231\187\153\230\130\168\229\136\176\232\180\166\239\188\140\233\186\187\231\131\166\230\130\168\228\189\191\231\148\168\228\187\163\233\135\145\229\136\184\229\134\141\230\172\161\232\180\173\228\185\176\229\149\134\229\147\129")
        })
      else
        ed.showAlertDialog({
          text = T("\230\130\168\231\154\132\231\164\188\229\140\133\229\136\184\229\183\178\229\136\176\232\180\166\239\188\140\229\143\175\231\148\168\228\186\142\229\133\145\230\141\162\232\175\165\233\161\181\233\157\162\229\144\140\231\173\137\228\187\183\229\128\188\231\154\132\231\164\188\229\140\133")
        })
      end
      ed.RechargeManager.needNoticeTicket = false
    end
  end)
  self:registerOnPopSceneHandler("OnPopRechargeScene", function()
    CloseScope(RechargeSceneScope)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.RECHARGE)
    if self.callback then
      self.callback()
    end
  end)
  return self
end

function RechargeScene:createGiftTicketsPanel()
  local container, ui = ed.editorui(ed.uieditor.RechargeGiftTicketLayer)
  local btnContainer = CCSprite:create()
  local btn, btnPress = ed.createScale9Button({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    pressRes = "UI/alpha/1080P/common/button_com_mini.png",
    capInsets = CCRectMake(10, 10, 81, 22)
  })
  ui.button_switch = btn
  ui.button_switch_press = btnPress
  local imgArrow = ed.createSprite("UI/alpha/1080P/guide/tutorial_arrow_right.png")
  imgArrow:setRotation(90)
  imgArrow:setPosition(ed.getCenterPos(btn))
  btn:addChild(imgArrow)
  ui.imgArrow = imgArrow
  container:setPosition(85, 64 + ed.display.winSize.height / 2 - 270)
  btnContainer:addChild(btn)
  btnContainer:setPosition(ccp(357, 438))
  btnContainer:setScale(0.6)
  ui.panel:addChild(btnContainer)
  return container, ui
end

function RechargeScene:getTicketAmountAndRes(data)
  local amount = ed.player:getEquipAmount(data.equipId)
  local ticketNum = ed.RechargeManager:getTicketNumber(data.CNYCost)
  return {
    amount = amount + ticketNum,
    iconRes = data.iconRes,
    id = data.rechargeId
  }
end

function RechargeScene:getTicketRes(key)
  local ticketsInfo = ed.RechargeManager:getGiftTicketsInfo()
  if key == "default" then
    for _, v in ipairs(ticketsInfo) do
      local info = self:getTicketAmountAndRes(v)
      if info.amount > 0 then
        return info
      end
    end
    return self:getTicketAmountAndRes(ticketsInfo[1])
  end
  return self:getTicketAmountAndRes(ticketsInfo[key])
end

function RechargeScene:refreshGiftTicketUI(ticketsPanelOpen)
  local ui = self.giftTicketsUi
  local defaultIndex = 11
  local startLabelY, startImgY = 22.66, 22.66
  local gapY = 27.3
  local labelY, imgY = startLabelY, startImgY
  for i = 11, 1, -1 do
    local key = ticketsPanelOpen and i or "default"
    local info = self:getTicketRes(key)
    if info.id ~= 5001 or not ed.isAreaOverSea() then
      local vis = ticketsPanelOpen or i == defaultIndex
      local label, img = ui["label_ticket_" .. i], ui["img_ticket_" .. i]
      label:setVisible(vis)
      img:setVisible(vis)
      label:setPositionY(labelY)
      img:setPositionY(imgY)
      labelY = labelY + gapY
      imgY = imgY + gapY
      ed.setString(label, info.amount)
      ed.setTexture(img, info.iconRes)
    else
      local label, img = ui["label_ticket_" .. i], ui["img_ticket_" .. i]
      label:setVisible(false)
      img:setVisible(false)
    end
  end
  local size = ui.bg:getContentSize()
  local unpackHei = ed.isAreaOverSea() and 285 or 320
  local hei = self.ticketsPanelOpen and unpackHei or 43.75
  ui.bg:setContentSize(CCSizeMake(size.width, hei))
end

function RechargeScene:doSwitchGiftTicketsPanel()
  self.ticketsPanelOpen = not self.ticketsPanelOpen
  self:refreshGiftTicketUI(self.ticketsPanelOpen)
end

function RechargeScene:refreshGiftTicketsPanel()
  if tolua.isnull(self.giftTicketsPanel) then
    local giftTicketsPanel, giftTicketsUi = self:createGiftTicketsPanel()
    self.mainLayer:addChild(giftTicketsPanel, 999)
    self.giftTicketsPanel = giftTicketsPanel
    self.giftTicketsUi = giftTicketsUi
  end
  local sumOfTickets = ed.RechargeManager:getAllTicketNumber()
  self.giftTicketsPanel:setVisible(0 < sumOfTickets)
  if sumOfTickets <= 0 then
    return
  end
  if self.ticketsPanelOpen == nil then
    self.ticketsPanelOpen = false
  end
  local ui = self.giftTicketsUi
  self:refreshGiftTicketUI(self.ticketsPanelOpen)
  self:btRegisterButtonClick({
    button = ui.img_switch_touch,
    key = "giftTicketsSwitch",
    pressHandler = function()
      ui.button_switch_press:setVisible(true)
    end,
    cancelPressHandler = function()
      ui.button_switch_press:setVisible(false)
    end,
    clickHandler = function()
      if self.giftTicketsPanel:isVisible() then
        self:doSwitchGiftTicketsPanel()
      end
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5,
    priority = -101
  })
end

function RechargeScene:buySuccessReply()
  self:refreshLayer(true)
end

function RechargeScene:updateRedTag(btnIndex, visible)
  local button = self.ui["btn" .. btnIndex]
  local tag = self.ui["red_tag" .. btnIndex]
  if tolua.isnull(button) then
    return
  end
  if tolua.isnull(tag) then
    tag = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    tag:setPosition(ccp(150, 50))
    button:addChild(tag, 4)
    self.ui["red_tag" .. btnIndex] = tag
  end
  tag:setVisible(visible)
end

function RechargeScene:refreshRedTags()
  local canShow = ed.RechargeManager:canShowTabButtonRedTag("Month")
  self:updateRedTag(3, canShow)
  self.ui.secret_redlight:setVisible(ed.RechargeManager:canShowSecretRedTag())
  canShow = ed.RechargeManager:canShowTabButtonRedTag("Gift")
  self:updateRedTag(2, canShow)
  canShow = ed.RechargeManager:canShowTabButtonRedTag("ActiveGift")
  self:updateRedTag(5, canShow)
  canShow = ed.RechargeManager:canShowTabButtonRedTag("CelebrateGift")
  self:updateRedTag(4, canShow)
  canShow = ed.RechargeManager:canShowTabButtonRedTag("AllStarGift")
  self:updateRedTag(6, canShow)
  canShow = ed.RechargeManager:canShowTabButtonRedTag("FestivalGift")
  self:updateRedTag(7, canShow)
end

function RechargeScene:registerEvents()
  ListenEvent("chargeQueryResult", function(msg)
    self:onChargeQueryRsp(msg)
  end, RechargeSceneScope)
  ListenEvent("QueryDataRsp", function()
    self:buySuccessReply()
  end, RechargeSceneScope)
  self:listenEvent("NewGiftBought", function()
    if self.tabIndex == 2 or self.tabIndex == 4 or self.tabIndex == 5 or self.tabIndex == 6 or self.tabIndex == 7 then
      self:refreshLayer(true)
    end
  end)
  self:listenEvent("NewGiftDataReady", function()
    if self.tabIndex == 2 or self.tabIndex == 4 or self.tabIndex == 5 or self.tabIndex == 6 or self.tabIndex == 7 then
      self:refreshLayer(true)
    end
  end)
  self:listenEvent("RechargeOpenTabIndexNew", function(flag)
    if flag then
      self.ui.btn4:setVisible(flag)
    else
      self.ui.btn4:setVisible(false)
    end
    self:refreshRedTags()
  end)
  self:listenEvent("RechargeOpenTabIndex", function(flag)
    if flag then
      self.ui.btn5:setVisible(flag)
      if not self.ui.btn4:isVisible() then
        self.ui.btn5:setPositionY(self.posConfig[1])
      end
    else
      self.ui.btn5:setVisible(false)
    end
    self:refreshRedTags()
  end)
  self:listenEvent("RechargeOpenTabAllStar", function(flag)
    if flag then
      if not self.ui.btn4:isVisible() then
        if not self.ui.btn5:isVisible() then
          self.ui.btn6:setPositionY(self.posConfig[1])
        else
          self.ui.btn6:setPositionY(self.posConfig[2])
        end
      elseif not self.ui.btn5:isVisible() then
        self.ui.btn6:setPositionY(self.posConfig[2])
      end
    end
    self.ui.btn6:setVisible(flag)
    self:refreshRedTags()
  end)
  self:listenEvent("RechargeOpenTabFestival", function(flag)
    if flag then
      local p = 1
      for i = 4, 6 do
        if self.ui["btn" .. i]:isVisible() then
          p = p + 1
        end
      end
      if self.posConfig[p] then
        self.ui.btn7:setPositionY(self.posConfig[p])
      end
    end
    self.ui.btn7:setVisible(flag)
    self:refreshRedTags()
  end)
  self:listenEvent("RefreshGiftTickets", function()
    self:refreshGiftTicketsPanel()
    if ed.RechargeManager.enableRecharge.status == "InBuy" then
      ed.RechargeNetwork:reqRmbData()
    end
  end)
  self:listenEvent("GetMonthCardReward", function(data)
    local rewardData = data._daily_reward or {}
    for k, v in pairs(rewardData._monthcards or {}) do
      ed.player:refreshMonthCardData(v)
    end
    local rewards = rewardData._rewards or {}
    if 0 < #rewards then
      ed.player:addRewards(rewards)
      ed.UITool.showRewardsFromServer(rewards)
    end
    self:refreshLayer()
  end)
  self:listenEvent("OpenSecretBox", function(data)
    if data._vault_id ~= 0 then
      if not self.ui.bg_secret:isVisible() then
        self.ui.bg_secret:setVisible(true)
      else
        ed.pushScene(ed.ui.SecretBoxScene.create(data))
      end
    end
  end)
end

function RechargeScene:initData(param)
  self.param = param
  self.selectLayer = param.page or "Gift"
  self.callback = param.callback
  self.giftItemId = param.giftItemId
  self.tabNames = {
    "Diamonds",
    "Gift",
    "MonthCard",
    "CelebrateGift",
    "ActiveGift",
    "AllStar",
    "FestivalGift"
  }
  for k, v in ipairs(self.tabNames) do
    if v == param.page then
      self.tabIndex = k
    end
  end
  self.needUpdateItems = {}
  ed.RechargeManager:initItemData()
  ed.RechargeNetwork:sendNewGiftOpenPanel()
  ed.RechargeNetwork:sendOpenSecretBox()
end

function RechargeScene:createDiamondItems(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.StoreDiamondItem)
  local icon = ed.createSprite(data.icon)
  ed.UITool.replaceUI(ui, "bg", "icon", icon)
  ed.setLabelStroke(ui.price, ed.toccc3(5066061), 2)
  ed.setLabelStroke(ui.title, ed.toccc3(1322844), 1.5)
  ed.setLabelStroke(ui.double_num, ed.toccc3(16777215), 1.5)
  ed.setLabelStroke(ui.label_double_tips, ed.toccc3(16777215), 1.5)
  local costDisplay = ed.RechargeManager:getCostDisplayByCNYCost(data.CNYCost)
  ed.setString(ui.price, costDisplay)
  ed.setString(ui.title, data.title)
  ui.title:setZOrder(5)
  ui.bg_double:setVisible(data.limit > 0)
  if data.type == "Instant" then
    if data.limit > 0 then
      ed.setString(ui.double_num, "+" .. data.get - data.des)
    elseif data.des and data.des ~= "" then
      ui.bg_addition:setVisible(true)
      local additionText = ed.ui.autoText.new()
      local strs = string.format(T("<lable color=ccc3(255,241,215) strokeColor=strokeColor1 strokeSize=1>\232\181\160\233\128\129</lable>") .. "<sprite src=UI/alpha/1080P/icon/diamond.png scale=0.6><lable color=ccc3(255,241,215) strokeColor=strokeColor1 strokeSize=1>%d</lable>", data.des)
      additionText:initParam({context = strs, fontSize = 14})
      additionText.node:setPosition(ccp(10, 12))
      ui.bg_addition:addChild(additionText.node)
    else
      ui.bg_addition:setVisible(false)
    end
  end
  return container, ui
end

function RechargeScene:refreshDraglistOfDiamonds(oldPos)
  self.uiList = {}
  local x, y
  if oldPos then
    x, y = self.draglist.listLayer:getPosition()
  end
  self.draglist:clearList()
  local listData = ed.RechargeManager:getRechargeItems()
  local size = self.ui.layer_item:getContentSize()
  local px, py = 206, 190
  local numOfCol = math.floor(size.width / (px + 8))
  local oy = size.height
  local perOfGapX = (size.width - px * numOfCol) / (numOfCol + 1)
  local ox = perOfGapX
  px = px + perOfGapX
  
  local function getPos(index)
    local row = math.floor((index + numOfCol - 1) / numOfCol)
    local col = (index - 1) % numOfCol + 1
    return ccp(px * col - px / 2, oy - row * py + py / 2)
  end
  
  for k, v in ipairs(listData) do
    local container, ui = self:createDiamondItems(v)
    ui.data = v
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.draglist:initListWidth(0)
  self.draglist:initListHeight(py * math.floor((#listData + numOfCol - 1) / numOfCol))
  if oldPos then
    self.draglist.listLayer:setPosition(ccp(x, y))
  end
end

function RechargeScene:addUpdateNewGiftItem(item)
  table.insert(self.needUpdateItems, item)
end

function RechargeScene:onChargeQueryRsp(data)
  ed.RechargeManager:setEnableRecharge(data)
end

function RechargeScene:createGiftItems(data)
  local container, ui = ed.editorui(ed.uieditor.StoreTimelyItem)
  ed.setLabelStroke(ui.price, ed.toccc3(5066061), 2)
  ed.setLabelStroke(ui.title, ed.toccc3(2826261), 1)
  ed.setLabelStroke(ui.time, ed.toccc3(2826261), 1)
  ed.setLabelStroke(ui.label_discount_tips, ed.toccc3(16777215), 2)
  ui.label_discount_tips:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_over, ed.toccc3(2826261), 1.5)
  ui.label_over:setFontName(ed.fontBold)
  local icon = ed.createSprite(data.iconRes)
  ed.UITool.replaceUI(ui, "bg", "icon", icon)
  ed.setString(ui.title, data.title)
  ed.adaptLabel(ui.title, {maxWidth = 140, minScale = 0.8})
  ui.title:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.setString(ui.time, string.format(T("\233\153\144\232\180\173\230\149\176\233\135\143\239\188\154%d/%d"), data.buyCount, data.buyLimit))
  local pirceStr = T("\229\133\141\232\180\185\233\162\134\229\143\150")
  if data.price > 0 then
    pirceStr = ed.RechargeManager:getCostDisplayByCNYCost(data.CNYCost)
  end
  ed.setString(ui.price, pirceStr)
  if data.buyCount >= data.buyLimit then
    ui.mask:setVisible(true)
  end
  if data.bViewFlag then
    ui.red_light:setVisible(true)
  else
    ui.red_light:setVisible(false)
  end
  ed.setString(ui.price, pirceStr)
  if data.resType then
    ed.setTexture(ui.bg, string.format("UI/alpha/1080P/newshop/gift%s_bg.png", data.resType))
    ed.setTexture(ui.bg_name, string.format("UI/alpha/1080P/newshop/gift%s_text.png", data.resType))
  end
  if data.showDiscount and 0 < data.showDiscount then
    ed.setLabelStroke(ui.label_discount, ed.toccc3(10888742), 1)
    if data.classify == "allstar" then
      ed.setString(ui.label_discount_tips, T("\232\181\160\233\128\129"))
      local icon = ed.createSprite("UI/alpha/1080P/allstar/allstar_rank/feather_little.png")
      ui.bg_discount:addChild(icon)
      ed.setString(ui.label_discount, data.showDiscount)
      ed.right2(icon, ui.label_discount_tips)
      ed.right2(ui.label_discount, icon)
    elseif data.classify == "FestivalGift" then
      ed.setString(ui.label_discount_tips, T("\232\181\160\233\128\129"))
      local icon = ed.createSprite("UI/alpha/1080P/dragonboat/db_race/db_zongzi_icon.png")
      icon:setScale(0.5)
      ui.bg_discount:addChild(icon)
      ed.setString(ui.label_discount, data.showDiscount)
      ed.right2(icon, ui.label_discount_tips)
      ed.right2(ui.label_discount, icon)
    else
      ed.setString(ui.label_discount, data.showDiscount .. "%")
      ed.right2(ui.label_discount, ui.label_discount_tips)
    end
  else
    ui.bg_discount:setVisible(false)
  end
  if data.type == "once" then
    ui.bg_discount:setVisible(true)
    ed.setTexture(ui.bg_discount, "UI/alpha/1080P/newshop/foreverlimit_bg.png")
    local forever = ed.createttf(T("\231\187\136\232\186\171\233\153\144\232\180\173"), 14)
    ed.setLabelColor(forever, ed.toccc3(14901535))
    ed.setLabelStroke(forever, ed.toccc3(16777215), 1.5)
    forever:setFontName(ed.fontBold)
    forever:limitWidthByScale(70)
    ui.label_discount_tips:setVisible(false)
    ed.UITool.replaceUI(ui, "bg_discount", "label_discount", forever)
  elseif data.type == "timely" then
    ui.bg_time:setVisible(true)
    ed.setLabelStroke(ui.time1, ed.toccc3(5583873), 1)
    ed.setString(ui.time1, ed.time2dhmOnly(data.deadLine - ed.getServerTime()))
  end
  return container, ui
end

function RechargeScene:refreshDraglistOfGift(oldPos)
  self.uiList = {}
  local x, y
  if oldPos then
    x, y = self.draglist.listLayer:getPosition()
  end
  self.draglist:clearList()
  local listData = ed.RechargeManager:getGiftItems()
  local size = self.ui.layer_item:getContentSize()
  local px, py = 168, 195
  local numOfCol = math.floor(size.width / (px + 8))
  local oy = size.height - 5
  local perOfGapX = (size.width - px * numOfCol) / (numOfCol + 1)
  local ox = perOfGapX
  px = px + perOfGapX
  
  local function getPos(index)
    local row = math.floor((index + numOfCol - 1) / numOfCol)
    local col = (index - 1) % numOfCol + 1
    return ccp(px * col - px / 2, oy - row * py + py / 2)
  end
  
  local posIndex = 0
  for k, v in ipairs(listData) do
    v.CNYCost = v.price
    if v.classify == "CNDOTA" and self.tabIndex == 5 then
      posIndex = posIndex + 1
      local container, ui = self:createGiftItems(v)
      ui.data = v
      table.insert(self.uiList, ui)
      self.draglist:addItem(container)
      container:setPosition(getPos(posIndex))
    elseif v.classify == "celebration" and self.tabIndex == 4 then
      posIndex = posIndex + 1
      local container, ui = self:createGiftItems(v)
      ui.data = v
      table.insert(self.uiList, ui)
      self.draglist:addItem(container)
      container:setPosition(getPos(posIndex))
    elseif v.classify == "allstar" and self.tabIndex == 6 then
      posIndex = posIndex + 1
      local container, ui = self:createGiftItems(v)
      ui.data = v
      table.insert(self.uiList, ui)
      self.draglist:addItem(container)
      container:setPosition(getPos(posIndex))
    elseif v.classify == "FestivalGift" and self.tabIndex == 7 then
      posIndex = posIndex + 1
      local container, ui = self:createGiftItems(v)
      ui.data = v
      table.insert(self.uiList, ui)
      self.draglist:addItem(container)
      container:setPosition(getPos(posIndex))
    end
  end
  self.draglist:initListWidth(0)
  self.draglist:initListHeight(py * math.floor((posIndex + numOfCol - 1) / numOfCol))
end

function RechargeScene:classifyGift(gifts)
  local lists = {}
  for k, v in ipairs(ed.getDataTable("MallGiftTab")) do
    table.insert(lists, {
      tab = v.Tab,
      name = v["Tab Name"],
      gifts = {}
    })
  end
  table.insert(lists, {
    tab = "Normal",
    name = T("\229\133\182\228\187\150"),
    gifts = {}
  })
  for k, gift in ipairs(gifts) do
    for id, list in ipairs(lists) do
      if gift.tab == list.tab then
        table.insert(list.gifts, gift)
      end
    end
  end
  for k, v in ipairs(lists) do
    table.sort(v.gifts, function(e1, e2)
      local function getPrio(e)
        local prio = 1
        
        if e.buyCount >= e.buyLimit and not e.isFreeReward then
          prio = 0
        end
        return prio
      end
      
      local prio1 = getPrio(e1)
      local prio2 = getPrio(e2)
      if prio1 ~= prio2 then
        return prio1 > prio2
      end
      if e1.order and e2.order then
        return e1.order < e2.order
      end
      return e1
    end)
  end
  return lists
end

function RechargeScene:refreshNormalGift(oldPos)
  local newPos = false
  self.uiList = {}
  local x, y
  if oldPos then
    x, y = self.draglist:getListPos()
  end
  self.draglist:clearList()
  local listData = ed.RechargeManager:getGiftItems()
  local size = self.ui.layer_item:getContentSize()
  local px, py = 168, 195
  local numOfCol = math.floor(size.width / (px + 8))
  local oy = size.height - 5
  local perOfGapX = (size.width - px * numOfCol) / (numOfCol + 1)
  local ox = perOfGapX
  px = px + perOfGapX
  local addY = 0
  
  local function getPos(index)
    local row = math.floor((index + numOfCol - 1) / numOfCol)
    local col = (index - 1) % numOfCol + 1
    return ccp(px * col - px / 2, oy - row * py + py / 2 - addY)
  end
  
  local lists = self:classifyGift(listData)
  for id, list in ipairs(lists) do
    local posIndex = 0
    for k, v in ipairs(list.gifts) do
      v.CNYCost = v.price
      if k == 1 then
        local titleBg = ed.createSprite("UI/alpha/1080P/newshop/tab_bg.png")
        titleBg:setPosition(ccp(size.width / 2, oy - addY - 20))
        local titleName = ed.createttf(list.name, 16)
        titleBg:addChild(titleName)
        ed.layout.centerInParent(titleName)
        ed.setLabelStroke(titleName, ccc3(0, 0, 0), 1)
        self.draglist:addItem(titleBg)
        addY = addY + 40
      end
      if v.classify ~= "celebration" and v.classify ~= "CNDOTA" and v.classify ~= "FestivalGift" then
        posIndex = posIndex + 1
        local container, ui = self:createGiftItems(v)
        ui.data = v
        table.insert(self.uiList, ui)
        self.draglist:addItem(container)
        container:setPosition(getPos(k))
        if self.giftItemId and v.rewards and self.giftItemId == v.rewards[1].id then
          y = getPos(posIndex).y - self.ui.layer_item:getContentSize().height + 140
          newPos = true
        end
      end
    end
    addY = addY + math.ceil(#list.gifts / numOfCol) * py
  end
  self.draglist:initListWidth(0)
  self.draglist:initListHeight(addY)
  if newPos then
    y = -1 * y
  end
  if oldPos then
    self.draglist:setListPos(ccp(x, y), true)
  elseif y then
    self.draglist:setListPos(ccp(0, y), true)
    self.giftItemId = nil
  end
end

function RechargeScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if self.tabIndex == 1 then
        if ed.containsPoint(v.bg, x, y) then
          v.bg:setScale(0.95)
          
          return v
        end
      elseif self.tabIndex == 2 or self.tabIndex == 4 or self.tabIndex == 5 or self.tabIndex == 6 or self.tabIndex == 7 then
        if ed.containsPoint(v.bg, x, y) and v.data.buyCount < v.data.buyLimit then
          v.bg:setScale(0.95)
          return v
        end
      elseif self.tabIndex == 3 and ed.containsPoint(v.btn_buy, x, y) then
        v.btn_buy:setScale(0.95)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function RechargeScene:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if self.tabIndex == 1 then
      v.bg:setScale(1)
    elseif self.tabIndex == 2 or self.tabIndex == 4 or self.tabIndex == 5 then
      v.bg:setScale(1)
    elseif self.tabIndex == 3 and v.btn_buy and not tolua.isnull(v.btn_buy) then
      v.btn_buy:setScale(1)
    end
  end
  
  return handler
end

function RechargeScene:getRechargeItemByGift(gift)
  local price = gift.price
  local rechargeId
  local rt = ed.getDataTable("Recharge")
  for id, row in pairs(rt) do
    if type(id) == "number" then
      local type = row.Type
      if type == "GiftTicket" and row.Cost == price then
        rechargeId = row.ID
      end
    end
  end
  if not rechargeId then
    error("unsupported gift ticket price: " .. price)
  end
  local v = ed.getDataTable(resource_config.rechargecsv or "Recharge")[rechargeId]
  local cost
  if resource_config.recharge_use_locale_cost then
    local localeData = ed.localepurchase.getLocaleProduct(v.ID)
    cost = localeData.cost
  end
  local t = {
    id = v.ID,
    title = v["Display Name"],
    type = v.Type,
    order = v.Order,
    CNYCost = v.Cost,
    USDCost = v["Cost USD"],
    icon = v.Icon,
    limit = v.Limit,
    itemId = v["Item ID"],
    giftType = gift.type,
    giftId = gift.giftId,
    canUseTicket = true
  }
  return t
end

function RechargeScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local data = v.data
    if self.tabIndex == 1 then
      ed.RechargeManager:doRecharge(data)
    elseif self.tabIndex == 2 or self.tabIndex == 4 or self.tabIndex == 5 or self.tabIndex == 6 or self.tabIndex == 7 then
      if data.bViewFlag then
        ed.RechargeNetwork:sendNewGiftViewTimely(data.giftId)
        data.bViewFlag = false
        self:updateRedTag(self.tabIndex, ed.RechargeManager:canShowTabButtonRedTag(self.tabNames[self.tabIndex]))
      end
      v.red_light:setVisible(false)
      self.giftItemId = nil
      ed.ui.RechargeBuyGiftWin.create({
        data = data,
        callback = function()
          local data = self:getRechargeItemByGift(data)
          ed.RechargeManager:doRecharge(data)
        end
      })
    elseif self.tabIndex == 3 then
      if data.type == "MonthlyCard" then
        local state = ed.player:getPayMonthCardState()
        if state == "DRAW" then
          ed.RechargeNetwork:sendGetMonthCardReward("payed")
        elseif state == "RENEW" then
          local dialogInfo = {
            text = T("\231\161\174\229\174\154\231\187\173\232\180\185\229\144\151?"),
            rightHandler = function()
              ed.RechargeManager:doRecharge(data)
            end
          }
          ed.showConfirmDialog(dialogInfo)
        elseif state == "BUY" then
          ed.RechargeManager:doRecharge(data)
        else
          return
        end
      else
        local state = ed.player:getFreeMonthCardState()
        if state == "DRAW" then
          ed.RechargeNetwork:sendGetMonthCardReward("free")
        elseif state == "CanGet" then
          ed.showToast(T("\230\191\128\230\180\187\230\176\184\228\185\133\230\156\136\229\141\161"))
        elseif state == "LOCKED" then
          ed.UITool.openView("activityScene", {actId = 1})
        end
      end
    end
  end
  
  return handler
end

function RechargeScene:createMonthCardItems(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.StoreMonthCardItem)
  if data.type == "FreeCard" then
    ed.setTexture(ui.bg, "UI/alpha/1080P/newshop/forevermonthcard_bg.png")
    ed.setTexture(ui.ImageView_415, "UI/alpha/1080P/newshop/forevermonthcard_bg1.png")
    ed.setTexture(ui.title, "UI/alpha/1080P/newshop/forevermonthcard.png")
    ui.label_time:setVisible(false)
    local state = ed.player:getFreeMonthCardState()
    if state == "LOCKED" then
      ed.setString(ui.label_buy, T("\229\137\141\229\190\128\232\167\163\233\148\129"))
    elseif state == "CanGet" then
      ed.setString(ui.label_buy, T("\230\191\128\230\180\187"))
    elseif state == "DRAW" then
      ui.icon_redLight:setVisible(true)
      ed.setString(ui.label_buy, T("\233\162\134\229\143\150"))
    else
      ed.setString(ui.label_buy, T("\229\183\178\233\162\134\229\143\150"))
    end
  else
    ed.setLabelStroke(ui.label_time, ed.toccc3(4211788), 1)
    ed.setString(ui.label_time, data.des)
    ui.label_time:limitWidthByScale(240)
    local state = ed.player:getPayMonthCardState()
    if state == "RENEW" then
      local costDisplay = ed.RechargeManager:getCostDisplayByCNYCost(data.CNYCost)
      ed.setString(ui.label_buy, costDisplay .. T("(\231\187\173\229\141\161)"))
    elseif state == "BUY" then
      local costDisplay = ed.RechargeManager:getCostDisplayByCNYCost(data.CNYCost)
      ed.setString(ui.label_buy, costDisplay)
    elseif state == "DRAW" then
      ui.icon_redLight:setVisible(true)
      ed.setString(ui.label_buy, T("\233\162\134\229\143\150"))
    else
      ed.setString(ui.label_buy, T("\229\183\178\233\162\134\229\143\150"))
    end
    ui.label_buy:limitWidthByScale(95)
  end
  ed.setLabelShadow(ui.label_buy, ed.toccc3(1644562), ccp(1, 0))
  local draglist = ed.UITool.createDraglist(ui.layer_item, {priority = -200})
  local dragListSize = ui.layer_item:getContentSize()
  local autoTxtConfigArr = {}
  local txtMinScale = 1
  local bgSize
  local spaceY = 5
  local topMargin = 2
  local bottomMargin = 2
  for k, v in ipairs(MonthCardConfig[data.type]) do
    local bgRes = "UI/alpha/1080P/newshop/monthcard_bg3.png"
    if data.type == "FreeCard" then
      bgRes = "UI/alpha/1080P/newshop/forevermonthcard_bg2.png"
    end
    if data.dailyDiamond then
      v = string.gsub(v, "dailyDiamond", data.dailyDiamond)
    end
    if data.vitalityUp then
      v = string.gsub(v, "vitalityUp", data.vitalityUp)
    end
    if data.candleMaxUp then
      v = string.gsub(v, "candleMaxUp", data.candleMaxUp)
    end
    local iconRes
    v = string.gsub(v, "^<sprite src=(.-)>", function(res)
      iconRes = res
      return ""
    end)
    local bg = ed.createSprite(bgRes)
    draglist:addItem(bg)
    if nil == bgSize then
      bgSize = bg:getContentSize()
    end
    bg:setPosition(ccp(dragListSize.width / 2, dragListSize.height - topMargin - (k - 0.5) * bgSize.height - (k - 1) * spaceY))
    local sideX = ed.isAreaZh() and 30 or 7
    local posX = sideX
    if nil ~= iconRes then
      local iconImg = ed.createSprite(iconRes)
      bg:addChild(iconImg)
      local iconSize = iconImg:getContentSize()
      iconImg:setAnchorPoint(ccp(0.5, 0.5))
      iconImg:setPosition(posX + iconSize.width * 0.5, bgSize.height * 0.5)
      posX = posX + 30
    end
    local txtParam = {context = v, fontSize = 16}
    local autoText = ed.ui.autoText.new()
    autoText:initParam(txtParam)
    autoText:limitWidthByScale(bgSize.width - posX - sideX)
    txtMinScale = math.min(txtMinScale, autoText.node:getScale())
    table.insert(autoTxtConfigArr, {
      autoText = autoText,
      parent = bg,
      posX = posX,
      param = txtParam
    })
  end
  local len = #MonthCardConfig[data.type]
  draglist:initListHeight(len * bgSize.height + (len - 1) * spaceY + topMargin + bottomMargin)
  for i, v in ipairs(autoTxtConfigArr) do
    if txtMinScale ~= 1 then
      v.autoText.node:setScale(1)
      v.param.sizeScale = txtMinScale
      v.autoText:initParam(v.param)
    end
    v.autoText.node:setPosition(ccp(v.posX, bgSize.height * 0.5))
    v.parent:addChild(v.autoText.node)
  end
  return container, ui
end

function RechargeScene:refreshDraglistOfMonthCard(oldPos)
  self.uiList = {}
  local x, y
  if oldPos then
    x, y = self.draglist.listLayer:getPosition()
  end
  self.draglist:clearList()
  local listData = ed.RechargeManager:getMonthCardItems()
  local size = self.ui.layer_item:getContentSize()
  local px, py = 281, 437
  local numOfCol = 2
  local oy = size.height - 10
  local perOfGapX = (size.width - px * numOfCol) / (numOfCol + 1)
  local ox = perOfGapX
  px = px + perOfGapX
  
  local function getPos(index)
    local row = math.floor((index + numOfCol - 1) / numOfCol)
    local col = (index - 1) % numOfCol + 1
    return ccp(px * col - px / 2, size.height / 2 + 30)
  end
  
  for k, v in ipairs(listData) do
    local container, ui = self:createMonthCardItems(v)
    ui.data = v
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.draglist:initListHeight(0)
  self.draglist:initListWidth(px * #listData)
  if oldPos then
    self.draglist.listLayer:setPosition(ccp(x, y))
  end
end

function RechargeScene:refreshMinorTips()
  local areaTipsCfg = MinorTips[EDCurLanguage]
  if not areaTipsCfg then
    self.ui.btn_minor_tips:setVisible(false)
    return
  end
  self.ui.btn_minor_tips:setVisible(true)
  self.areaTipsCfg = areaTipsCfg
  ed.setLabelString(self.ui.label_minor_tips, areaTipsCfg.shortTips)
  local labelSize = self.ui.label_minor_tips:getContentSize()
  local labelPosX = self.ui.label_minor_tips:getPositionX()
  self.ui.btn_minor_tips:setContentSize(CCSizeMake(labelSize.width + labelPosX + 8, 35.5))
end

function RechargeScene:showMinorTips()
  if not self.areaTipsCfg then
    return
  end
  ed.ui.MinorBuyTipsWin.create(self.areaTipsCfg):popWindow()
end

function RechargeScene:refreshLayer(oldPos)
  self:refreshGiftTicketsPanel()
  if self.tabIndex == 1 then
    self:refreshDraglistOfDiamonds(oldPos)
  elseif self.tabIndex == 2 then
    self:refreshNormalGift(oldPos)
  elseif self.tabIndex == 3 then
    self:refreshDraglistOfMonthCard(oldPos)
  elseif self.tabIndex == 4 then
    self:refreshDraglistOfGift(oldPos)
  elseif self.tabIndex == 5 then
    self:refreshDraglistOfGift(oldPos)
  elseif self.tabIndex == 6 then
    self:refreshDraglistOfGift(oldPos)
  elseif self.tabIndex == 7 then
    self:refreshDraglistOfGift(oldPos)
  end
  self:refreshRedTags()
end

function RechargeScene:adaptUI()
  self.ui.bg:setPositionX(self.ui.bg:getPositionX() - ed.display.halfFixedWidth)
  self.ui.bg:setPositionY(self.ui.bg:getPositionY() + ed.display.halfFixedHeight)
  local layerContentSize = self.ui.layer_item:getContentSize()
  self.ui.layer_item:setPositionY(self.ui.layer_item:getPositionY() - ed.display.halfFixedHeight * 2)
  self.ui.layer_item:setContentSize(CCSizeMake(layerContentSize.width + ed.display.halfFixedWidth * 2, layerContentSize.height + ed.display.halfFixedHeight * 2))
  ed.layout.layoutWithMagin(self.ui.bg, {left = 0})
  ed.layout.layoutWithMagin(self.ui.bg_secret, {right = 220, top = 6}, false, true)
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
end

function RechargeScene:initLabels()
  ed.setLabelShadow(self.ui.btn_sname1, ed.toccc3(1189714), ccp(1, 2))
  ed.setLabelShadow(self.ui.btn_sname2, ed.toccc3(1189714), ccp(1, 2))
  ed.setLabelShadow(self.ui.btn_sname3, ed.toccc3(1189714), ccp(1, 2))
  ed.setLabelShadow(self.ui.btn_sname4, ed.toccc3(1189714), ccp(1, 2))
  ed.setLabelShadow(self.ui.btn_sname5, ed.toccc3(1189714), ccp(1, 2))
  ed.setLabelShadow(self.ui.btn_sname6, ed.toccc3(1189714), ccp(1, 2))
  ed.setLabelShadow(self.ui.btn_sname7, ed.toccc3(1189714), ccp(1, 2))
  ed.setLabelStroke(self.ui.label_secret, ed.toccc3(4659984), 1)
  ed.setLabelFontName(self.ui.label_secret, ed.fontBold)
  ed.adaptLabel(self.ui.btn_sname4, {maxWidth = 80, minScale = 0.7})
  ed.adaptLabel(self.ui.btn_name4, {maxWidth = 80, minScale = 0.7})
  self.ui.label_secret:limitWidthByScale(90)
  self.ui.btn_sname7:limitSizeByScale(90, 40)
  self.ui.btn_name7:limitSizeByScale(90, 40)
end

function RechargeScene:initUI()
  local container = self.mainLayer
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.StoreScene)
  self:setBackground("UI/alpha/1080P/bg/newshop_bg1.jpg")
  self:setBackButton(function()
    CloseScope(RechargeSceneScope)
  end)
  ui.btn5:setVisible(false)
  ui.btn4:setVisible(false)
  ui.btn6:setVisible(false)
  ui.btn7:setVisible(false)
  self.posConfig = {
    self.ui.btn4:getPositionY(),
    self.ui.btn5:getPositionY(),
    self.ui.btn6:getPositionY()
  }
  ed.UITool.createSceneTitle(T("\229\149\134 \229\159\142"), self.ui.bg_title, {
    position = ccp(26, 18)
  })
  self:adaptUI()
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(ui.layer_item, {
    priority = -100,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshBtnState()
  self:refreshMinorTips()
end

function RechargeScene:refreshBtnState()
  self.selectLayer = self.tabNames[self.tabIndex]
  for i = 1, #self.tabNames do
    self.ui["select" .. i]:setVisible(i == self.tabIndex)
    self.ui["unselect" .. i]:setVisible(i ~= self.tabIndex)
  end
end

function RechargeScene:doClickBtn(index)
  if self.tabIndex == index then
    return
  end
  self.tabIndex = index
  self:refreshBtnState()
  self:refreshLayer()
end

function RechargeScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn1", function()
    self:doClickBtn(1)
  end, {})
  ed.UITool.registerBtn(self, "btn2", function()
    ed.RechargeManager.bNewGiftNotify = false
    self:doClickBtn(2)
  end, {})
  ed.UITool.registerBtn(self, "btn3", function()
    self:doClickBtn(3)
  end, {})
  ed.UITool.registerBtn(self, "btn_secret", function()
    ed.RechargeNetwork:sendOpenSecretBox()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn4", function()
    ed.RechargeManager.bNewGiftNotify = false
    self:doClickBtn(4)
  end, {})
  ed.UITool.registerBtn(self, "btn5", function()
    ed.RechargeManager.bNewGiftNotify = false
    self:doClickBtn(5)
  end, {})
  ed.UITool.registerBtn(self, "btn6", function()
    ed.RechargeManager.bNewGiftNotify = false
    self:doClickBtn(6)
  end, {})
  ed.UITool.registerBtn(self, "btn7", function()
    ed.RechargeManager.bNewGiftNotify = false
    self:doClickBtn(7)
  end, {})
  ed.UITool.registerBtn(self, "btn_minor_tips", function()
    self:showMinorTips()
  end, {pressScale = 0.98})
end
