local base = ed.ui.popwindow
local Dialog = {}
Dialog.__index = Dialog
setmetatable(Dialog, base.mt)

function Dialog.create(param)
  local self = base.create("Dialog")
  setmetatable(self, Dialog)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow(999)
  self:show()
  return self
end

ed.showConfirmDialog = Dialog.create

function Dialog:initData(param)
  self.param = param
end

function Dialog:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  if self.param.mode == "simple" then
    readnode:addNode(ed.uieditor.package_dialogue1)
  else
    readnode:addNode(ed.uieditor.package_dialogue)
    ui.right_deco:setScaleX(-1)
  end
  ed.layout.centerInScreen(self.ui.bg, true)
  ed.setLabelShadow(ui.left_button_label, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(ui.right_button_label, ed.toccc3(0), ccp(1, 0))
  self:refreshUI()
end

function Dialog:refreshUI()
  local ui = self.ui
  ui.left_button_label:setString(self.param.leftText or T("\229\143\150\230\182\136"))
  ui.right_button_label:setString(self.param.rightText or T("\231\161\174\229\174\154"))
  local confirm
  local fontSize = self.param.fontSize or 18
  local offsetY = self.param.offsetY or 0
  local color = self.param.mode == "simple" and ccc3(254, 251, 232) or ccc3(25, 2, 3)
  ed.setLabelStroke(self.ui.label_title, ccc3(56, 38, 34), 2)
  if self.param.color then
    color = self.param.color
  end
  if self.param.autoText then
    local confirm = ed.ui.autoText.new()
    confirm:initParam({
      color = color,
      context = self.param.autoText,
      fontSize = fontSize,
      maxWidth = ui.bg:getContentSize().width * 0.8
    })
    local width, height = confirm:getCurContentSize()
    confirm.node:setPosition(ccp((ui.bg:getContentSize().width - width) * 0.5, ui.bg:getContentSize().height - (ui.bg:getContentSize().height - height) * 0.46 + offsetY))
    self.ui.bg:addChild(confirm.node)
  else
    confirm = ed.createttf(self.param.text, fontSize, nil, self.param.anchor)
    confirm:setDimensions(CCSizeMake(self.ui.bg:getContentSize().width * 0.8, 0))
    confirm:setHorizontalAlignment(kCCTextAlignmentLeft)
    confirm:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    confirm:setPosition(ccp(self.ui.bg:getContentSize().width * 0.5, self.ui.bg:getContentSize().height * 0.638 + offsetY))
    ed.setLabelColor(confirm, color)
    self.ui.bg:addChild(confirm)
  end
end

function Dialog:registerTouchHandlers()
  local ui = self.ui
  ed.UITool.registerBtn(self, "right_button", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.rightHandler
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "left_button", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.leftHandler
    })
  end, {pressScale = 0.9})
end

local AlertDialog = {}
AlertDialog.__index = AlertDialog
setmetatable(AlertDialog, base.mt)

function AlertDialog.create(param)
  local self = base.create("Dialog")
  setmetatable(self, AlertDialog)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

ed.showAlertDialog = AlertDialog.create

function AlertDialog:initData(param)
  self.param = param
end

function AlertDialog:initUI()
  local container, ui = ed.editorui(ed.uieditor.AlertDialog, {
    container = self.container,
    ui = self.ui
  })
  ed.layout.centerInScreen(self.ui.bg, true)
  self:refreshUI()
end

function AlertDialog:registerTouchHandlers()
  local ui = self.ui
  ed.UITool.registerBtn(self, "btn_ok", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.handler
    })
  end, {pressScale = 0.9})
end

function AlertDialog:createWithText()
  local alert
  local fontSize = self.param.fontSize or 18
  local offsetY = self.param.offsetY or 0
  local color = self.param.fontColor or ccc3(254, 251, 232)
  ed.setLabelStroke(self.ui.label_title, ccc3(56, 38, 34), 2)
  if self.param.title then
    self.ui.label_title:setString(self.param.title)
  end
  if self.param.autoText then
    local alert = ed.ui.autoText.new()
    alert:initParam({
      color = color,
      context = self.param.autoText,
      fontSize = fontSize,
      maxWidth = ui.bg:getContentSize().width * 0.8
    })
    local width, height = alert:getCurContentSize()
    alert.node:setPosition(ccp((ui.bg:getContentSize().width - width) * 0.5, ui.bg:getContentSize().height - (ui.bg:getContentSize().height - height) * 0.46 + offsetY))
    self.ui.bg:addChild(alert.node)
  else
    alert = ed.createttf(self.param.text, fontSize, nil, self.param.anchor)
    alert:setDimensions(CCSizeMake(self.ui.bg:getContentSize().width * 0.8, 0))
    alert:setHorizontalAlignment(kCCTextAlignmentLeft)
    alert:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    alert:setPosition(ccp(self.ui.bg:getContentSize().width * 0.5, self.ui.bg:getContentSize().height * 0.638 + offsetY))
    ed.setLabelColor(alert, color)
    self.ui.bg:addChild(alert)
  end
end

function AlertDialog:createWithSprite(info)
  if info == nil then
    info = {}
  end
  if info.sprite then
    info.sprite:setAnchorPoint(ccp(0, 0))
    info.sprite:setPosition(ccp(0, 0))
    self.bg:addChild(info.sprite)
  end
  if info.spriteLabel then
    local label = ed.createttf(info.spriteLabel, 20)
    label:setDimensions(CCSizeMake(300, 125))
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    label:setPosition(ccp(172, 135))
    ed.setLabelColor(label, ccc3(112, 103, 94))
    self.bg:addChild(label)
    if info.starshopStyle then
      label:setPosition(ccp(250, 180))
      ed.setLabelColor(label, ccc3(129, 204, 255))
    end
  end
  if info.sprite_x then
    self.bg:setScaleX(info.sprite_x / self.bg:getContentSize().width)
    info.sprite:setScaleX(self.bg:getContentSize().width / info.sprite_x)
  end
  return self
end

function AlertDialog:refreshUI()
  local ui = self.ui
  ui.label_btn_ok:setString(self.param.buttonText or T("\231\161\174\229\174\154"))
  if self.param.sprite then
    self = self:createWithSprite(self.param)
  else
    self = self:createWithText()
  end
end

local handyDialog = {
  mt = {}
}
handyDialog.mt.__index = handyDialog

function handyDialog.openMidas(config)
  local function handler()
    local callback = config.callback
    
    local refreshHandler = config.refreshHandler
    local priority = config.priority
    local ds = ed.playerlimit.getAreaUnlockPrompt("Midas")
    if ds then
      ed.showToast(ds)
      return
    end
    print("----------------------------------------")
    local scene = CCDirector:sharedDirector():getRunningScene()
    local midas = ed.ui.midasWin.create({
      callback = callback,
      refreshHandler = refreshHandler,
      priority = priority
    })
  end
  
  return handler
end

function handyDialog.openRecharge(config)
  local function handler()
    local scene = CCDirector:sharedDirector():getRunningScene()
    
    local rechargeMgr = ed.RechargeNewMgr.getInstance()
    if true == rechargeMgr:isUseNewRechargeMedule() then
      ed.pushScene(ed.ui.recharge.create({
        page = config.page or "Diamonds",
        callback = config.callback
      }))
      if config.type then
        FireEvent("RechargeGotoDiamondsLayer", config.type)
      end
    else
      local rechargeLayer = ed.ui.recharge.create(config)
      scene:addChild(rechargeLayer.mainLayer, 200)
    end
  end
  
  return handler
end

function handyDialog.openvipPower(vip)
  local function handler()
    local scene = CCDirector:sharedDirector():getRunningScene()
    
    local rechargeMgr = ed.RechargeNewMgr.getInstance()
    if true == rechargeMgr:isUseNewRechargeMedule() then
      ed.pushScene(ed.ui.recharge.create({
        page = "Diamonds",
        showDetail = true,
        showVip = vip
      }))
    else
      local rechargeLayer = ed.ui.recharge.create({type = "detail", showVip = vip})
      scene:addChild(rechargeLayer.mainLayer, 200)
    end
  end
  
  return handler
end

function handyDialog.upBuyVitality(cost, reply)
  local function handler()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    elseif ed.player._rmb < cost then
      ed.showHandyDialog("toRecharge")
    else
      ed.netreply.buyVitalityReply = reply
      ed.netdata.buyVitality = {isBuy = true, cost = cost}
      local msg = ed.upmsg.buy_vitality()
      msg._type = "vitality"
      ed.send(msg, "buy_vitality")
    end
  end
  
  return handler
end

function handyDialog.upBuyShadowRunes(cost, reply)
  local function handler()
    if not ed.player:canBuyShadowRunes() then
      ed.showToast(T("\228\189\160\231\154\132\232\131\189\233\135\143\233\157\162\229\140\133\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    elseif ed.player._rmb < cost then
      ed.showHandyDialog("toRecharge")
    else
      ed.netreply.buyVitalityReply = reply
      ed.netdata.buyVitality = {isBuy = true, cost = cost}
      local msg = ed.upmsg.buy_vitality()
      msg._type = "shadow_rune"
      ed.send(msg, "buy_vitality")
    end
  end
  
  return handler
end

function handyDialog.upBuyVitalityWithEquip(id, number, reply)
  local function handler()
    if ed.player._vitality._current >= ed.parameter.max_vitality_stock then
      ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\229\133\136\230\182\136\232\128\151\228\184\128\228\186\155\229\144\167\227\128\130"))
    else
      local item_info = ed.packItem(id, 1)
      ed.registerNetReply("eat_vitality", reply, {id = id, amount = number})
      ed.record:useItemCount(id, number)
      local msg = ed.upmsg.consume_item()
      msg._item = item_info
      ed.send(msg, "consume_item")
    end
  end
  
  return handler
end

local function createDialogIcon(text, icon)
  local sprite = CCSprite:create()
  local label = ed.createttf(text, 18)
  local num = ed.createttf("x1", 18)
  icon:setPosition(ccp(170, 120))
  label:setPosition(ccp(180, 180))
  num:setPosition(ccp(220, 120))
  ed.setLabelColor(label, ccc3(255, 255, 255))
  ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelColor(num, ccc3(255, 255, 255))
  ed.setLabelShadow(num, ccc3(0, 0, 0), ccp(0, 2))
  sprite:addChild(label)
  sprite:addChild(icon)
  sprite:addChild(num)
  return sprite
end

function handyDialog.showHandyDialog(type, param)
  param = param or {}
  local active = param.active
  local vip = param.vip
  local number = param.number
  local name = param.name
  local reply = param.reply
  local callback = param.callback
  local refreshHandler = param.refreshHandler
  local explaination = param.explaination
  local wholeText = param.wholeText
  local priority = param.priority
  local tp = param.type or nil
  local text
  local rightText = T("\231\161\174\229\174\154")
  local handler, rightHandler, sprite
  if type == "useMidas" then
    text = T("\233\135\145\229\184\129\228\184\141\232\182\179\239\188\140\230\152\175\229\144\166\228\189\191\231\148\168\231\130\185\233\135\145\230\137\139\239\188\159")
    rightHandler = handyDialog.openMidas({
      callback = callback,
      refreshHandler = refreshHandler,
      priority = priority
    })
  elseif type == "toRecharge" then
    ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
    return
  elseif type == "vipLocked" then
    ed.showToast(T("VIP\231\173\137\231\186\167\228\184\141\232\182\179"))
    return
  elseif type == "needHighervip" then
    ed.showToast(T("\228\187\138\230\151\165\229\183\178\232\190\190\230\156\128\229\164\167\232\180\173\228\185\176\230\172\161\230\149\176"))
    return
  elseif type == "buyVitalityWithDiamond" then
    if not ed.player:canBuyVitality() then
      handyDialog.showHandyDialog("needHighervip", {
        number = ed.player:getVitalityBuyTimes(),
        name = T("\232\180\173\228\185\176\228\189\147\229\138\155")
      })
      return
    end
    local cost = ed.player:getBuyVitalityCost()
    if ed.isOpenConsumeTips() then
      if ed.ui.consumeTipsWin.isEnableShowWin() then
        text = T("\232\138\177\232\180\185%d\233\146\187\231\159\179\232\180\173\228\185\176120\231\130\185\228\189\147\229\138\155\239\188\140<br/>\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159(\228\187\138\230\151\165\229\183\178\232\180\173\228\185\176%d\230\172\161)", cost, ed.player:getVitalityBuyTimes())
        ed.UITool.openView("consumeTipsWin", {
          text = text,
          rightHandler = handyDialog.upBuyVitality(cost, reply)
        })
      else
        handyDialog.upBuyVitality(cost, reply)()
      end
      return
    else
      text = T("\232\138\177\232\180\185%d\233\146\187\231\159\179\232\180\173\228\185\176120\231\130\185\228\189\147\229\138\155\239\188\140\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159(\228\187\138\230\151\165\229\183\178\232\180\173\228\185\176%d\230\172\161)", cost, ed.player:getVitalityBuyTimes())
      rightHandler = handyDialog.upBuyVitality(cost, reply)
    end
  elseif type == "buyVitality" then
    if not ed.player:canBuyVitality() then
      handyDialog.showHandyDialog("needHighervip", {
        number = ed.player:getVitalityBuyTimes(),
        name = T("\232\180\173\228\185\176\228\189\147\229\138\155")
      })
      return
    end
    text = ""
    if active then
    else
      text = T("\228\189\147\229\138\155\228\184\141\232\182\179")
    end
    handyDialog.showHandyDialog("buyVitalityWithDiamond", {active = true, reply = reply})
    return
  elseif type == "buyShadowRunes" then
    if not ed.player:canBuyShadowRunes() then
      print("not buy")
      handyDialog.showHandyDialog("needHighervip", {
        number = ed.player:getShadowRunesBuyTimes(),
        name = T("\232\180\173\228\185\176\232\131\189\233\135\143\233\157\162\229\140\133")
      })
      return
    end
    local cost = ed.player:getBuyShadowRunesCost()
    text = T("\232\138\177\232\180\185%d\233\146\187\231\159\179\232\180\173\228\185\17610\228\184\170\232\131\189\233\135\143\233\157\162\229\140\133\239\188\140\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159(\228\187\138\230\151\165\229\183\178\232\180\173\228\185\176%d\230\172\161)", cost, ed.player:getShadowRunesBuyTimes())
    rightHandler = handyDialog.upBuyShadowRunes(cost, reply)
  end
  local info = {
    text = text,
    sprite = sprite,
    rightText = rightText,
    rightHandler = rightHandler
  }
  return ed.showConfirmDialog(info)
end

ed.showHandyDialog = handyDialog.showHandyDialog

function ed.popSuperLinkAlertDialog(text, addr)
  local buttonText = T("\229\137\141\229\190\128")
  if addr == "" or addr == "DO NOT EXIT" then
    buttonText = T("\231\161\174\229\174\154")
  end
  ed.showAlertDialog({
    text = text,
    buttonText = buttonText,
    handler = function()
      if addr == "" then
        EDExit()
      elseif addr == "DO NOT EXIT" then
      else
        ed.openURL(addr)
      end
    end
  })
end

local UpdateVersionDialog = {}
UpdateVersionDialog.__index = UpdateVersionDialog
setmetatable(UpdateVersionDialog, base.mt)
local defaultUrlLinks = {
  en = {
    url = "https://discord.gg/R3JXKJAyuZ",
    text = "Discord"
  },
  ja = {
    url = "https://x.com/eikue_jp",
    text = "X"
  },
  tw = {
    url = "https://discord.gg/SpABxg6euE",
    text = "Discord"
  },
  ko = {
    url = "https://game.naver.com/lounge/Heroic_Alliance/board",
    text = "Naver"
  },
  cn = {
    url = "https://discord.gg/SpABxg6euE",
    text = "Discord"
  }
}
ed.defaultUrlLinks = defaultUrlLinks

function UpdateVersionDialog.create(param)
  param.urlLink = param.urlLink or defaultUrlLinks[EDCurLanguage]
  if not ed.isAreaOverSea() then
    param.urlLink = {
      urlFunc = function()
        local url = "https://lilith-mp-cloud-2g1ui6a856fb0544-1322303600.tcloudbaseapp.com/d/official-follow/index.html?t=" .. os.time()
        ed.openURL(url)
      end,
      text = "wxchat"
    }
  end
  if param.urlLink == nil then
    ed.showAlertDialog(param)
    return
  end
  local self = base.create("UpdateVersionDialog")
  setmetatable(self, UpdateVersionDialog)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

ed.showUpdateVersionDialog = UpdateVersionDialog.create

function UpdateVersionDialog:initData(param)
  self.param = param
end

function UpdateVersionDialog:initUI()
  local container, ui = ed.editorui(ed.uieditor.AlertDialog, {
    container = self.container,
    ui = self.ui
  })
  ed.layout.centerInScreen(self.ui.bg, true)
  self:refreshUI()
end

function UpdateVersionDialog:registerTouchHandlers()
  local ui = self.ui
  ed.UITool.registerBtn(self, "btn_ok", function()
    self:destroy({
      skipAnim = self.param.skipDestroyAnim,
      callback = self.param.handler
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_url", function()
    if self.param.urlLink.url then
      ed.openURL(self.param.urlLink.url)
    end
    if self.param.urlLink.urlFunc then
      self.param.urlLink.urlFunc()
    end
  end, {pressScale = 0.9})
end

function UpdateVersionDialog:createWithText()
  local alert
  local fontSize = self.param.fontSize or 18
  local offsetY = self.param.offsetY or 0
  local color = self.param.fontColor or ccc3(254, 251, 232)
  ed.setLabelStroke(self.ui.label_title, ccc3(56, 38, 34), 2)
  if self.param.title then
    self.ui.label_title:setString(self.param.title)
  end
  if self.param.autoText then
    local alert = ed.ui.autoText.new()
    alert:initParam({
      color = color,
      context = self.param.autoText,
      fontSize = fontSize,
      maxWidth = ui.bg:getContentSize().width * 0.8
    })
    local width, height = alert:getCurContentSize()
    alert.node:setPosition(ccp((ui.bg:getContentSize().width - width) * 0.5, ui.bg:getContentSize().height - (ui.bg:getContentSize().height - height) * 0.46 + offsetY))
    self.ui.bg:addChild(alert.node)
  else
    alert = ed.createttf(self.param.text, fontSize, nil, self.param.anchor)
    alert:setDimensions(CCSizeMake(self.ui.bg:getContentSize().width * 0.8, 125))
    alert:setHorizontalAlignment(kCCTextAlignmentLeft)
    alert:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    alert:setPosition(ccp(self.ui.bg:getContentSize().width * 0.5, self.ui.bg:getContentSize().height * 0.638 + offsetY))
    ed.setLabelColor(alert, color)
    self.ui.bg:addChild(alert)
  end
end

function UpdateVersionDialog:refreshUI()
  local ui = self.ui
  ui.label_btn_ok:setString(self.param.buttonText or T("\231\161\174\229\174\154"))
  ed.UITool.setPositionBy(ui.btn_ok, ccp(-110, 0))
  local btn_url = ed.createScale9Sprite("UI/alpha/1080P/common/button_com_mini.png", CCRectMake(50, 20, 1, 1))
  btn_url:setContentSize(CCSizeMake(130, btn_url:getContentSize().height))
  local urlIcon = ed.createSprite("UI/alpha/1080P/distribution/community/button-" .. string.lower(self.param.urlLink.text) .. ".png")
  btn_url:addChild(urlIcon)
  local urlText = ed.createLabelTTF(ed.isAreaOverSea() and self.param.urlLink.text or "\229\190\174\228\191\161\229\176\143\231\168\139\229\186\143", 16, ed.font)
  ed.setLabelColor(urlText, ed.toccc3(16577188))
  btn_url:addChild(urlText)
  ed.layout.centerInParent(urlIcon)
  ed.layout.centerInParent(urlText)
  local iconWid = urlIcon:getContentSize().width
  local textWid = urlText:getContentSize().width
  local space = 130 - iconWid - textWid
  local seqSpace = math.min(space * 0.2, 10)
  local sideSpace = (space - seqSpace) * 0.5
  urlIcon:setPositionX(sideSpace + iconWid * 0.5)
  urlText:setPositionX(130 - sideSpace - textWid * 0.5)
  self.ui.bg:addChild(btn_url)
  btn_url:setPosition(ccp(self.ui.btn_ok:getPositionX() + 210, self.ui.btn_ok:getPositionY()))
  self.ui.btn_url = btn_url
  self = self:createWithText()
end
