local base = ed.ui.popwindow
local serviceSettingWin = newclass(base.mt)
ed.ui.serviceSettingWin = serviceSettingWin
local serviceSettingOption = {
  {
    icon = "UI/alpha/1080P/playerinfo/icon_account.png",
    iconOffset = {-30, 0},
    text = T("\232\180\166\229\143\183"),
    textOffset = {13, 0},
    Alignment = kCCTextAlignmentCenter,
    fontSize = 16,
    key = "account",
    show = true,
    click = function()
      if EDFLAGIOS or EDFLAGANDROID then
        EDSwitchAccount()
      end
    end
  },
  {
    icon = "UI/alpha/1080P/playerinfo/icon_privacy.png",
    iconOffset = {-30, 0},
    text = T("\233\154\144\231\167\129\230\157\131\233\153\144"),
    textOffset = {13, 0},
    Alignment = kCCTextAlignmentCenter,
    fontSize = 16,
    key = "privacyAuthority",
    show = true,
    click = function()
      ed.ui.sdkRightsSettingWindow.open()
    end
  },
  {
    icon = "UI/alpha/1080P/playerinfo/icon_customer.png",
    iconOffset = {-30, 0},
    text = T("\229\174\162\230\156\141"),
    textOffset = {13, 0},
    Alignment = kCCTextAlignmentCenter,
    fontSize = 16,
    key = "customerService",
    show = true,
    click = function()
      if EDFLAGIOS or EDFLAGANDROID then
        if EDSDKType == 302 then
          EDOpenCustomerService(ed.getJson({bbx_region = "official"}))
        elseif EDSDKType == 301 then
          EDOpenCustomerService(ed.getJson({bbx_region = "cnptr"}))
        elseif EDSDKType == 303 then
          EDOpenCustomerService(ed.getJson({bbx_region = "official"}))
        elseif EDSDKType == 501 then
          EDOpenCustomerService(ed.getJson({
            bbx_region = "farlight%3Aglobal%3Aobt"
          }))
        else
          EDOpenCustomerService("")
        end
      end
    end
  },
  {
    icon = "UI/alpha/1080P/playerinfo/icon_service.png",
    iconOffset = {-30, 0},
    text = T("\230\156\141\229\138\161\230\157\161\230\172\190\228\184\142\233\154\144\231\167\129\230\148\191\231\173\150"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 13,
    key = "clause",
    show = true,
    click = function()
      if EDFLAGIOS or EDFLAGANDROID then
        EDGetParam("showPrivacyPolicy")
      end
    end
  },
  {
    icon = "UI/alpha/1080P/playerinfo/icon_service.png",
    iconOffset = {-30, 0},
    text = T("\231\172\172\228\184\137\230\150\185\228\191\161\230\129\175\229\133\177\228\186\171\230\184\133\229\141\149"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 13,
    key = "thirdPartyInformation",
    show = ed.isShowPersonalInformation(),
    click = function()
      if EDFLAGIOS or EDFLAGANDROID then
        EDGetParam("openThirdInfolist")
      end
    end
  },
  {
    icon = "UI/alpha/1080P/playerinfo/icon_service.png",
    iconOffset = {-30, 0},
    text = T("\228\184\170\228\186\186\228\191\161\230\129\175\230\148\182\233\155\134\230\184\133\229\141\149"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 13,
    key = "personalInformation",
    show = ed.isShowPersonalInformation(),
    click = function()
      if EDFLAGIOS or EDFLAGANDROID then
        EDGetParam("openPersonalInfolist")
      end
    end
  },
  {
    icon = "installer/login/switch_icon.png",
    iconOffset = {-30, 0},
    text = "\231\137\136\230\156\172\229\136\135\230\141\162",
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 13,
    key = "versionChange",
    show = ed.isShowVersionChange(),
    click = function()
      ed.ui.versionChangeView.create():popWindow()
    end
  },
  {
    icon = "UI/alpha/1080P/setting/setting_member_icon.png",
    iconOffset = {-30, 0},
    text = T("\232\142\137\232\142\137\228\184\157\229\164\167\228\188\154\229\145\152"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 15,
    dimensions = CCSizeMake(50, 0),
    key = "lilithvip",
    show = ed.isShowLilithVIPPage(),
    click = function()
      if EDFLAGIOS or EDFLAGANDROID then
        EDOpenLilithVipPage("https://vip.lilith.com/ingame?")
      end
    end
  },
  {
    icon = "UI/alpha/1080P/distribution/community/community_setting_icon.png",
    iconOffset = {-30, 0},
    text = T("\231\164\190\229\140\186"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentCenter,
    fontSize = 15,
    dimensions = CCSizeMake(50, 0),
    key = "community",
    show = EDSDKType ~= 303,
    click = function()
      ed.ui.communityWin.create()
    end
  },
  {
    icon = "UI/alpha/1080P/setting/xn_chilun.png",
    iconOffset = {-30, 0},
    text = ed.isBlurBg and T("\229\133\179\233\151\173\232\131\140\230\153\175\230\168\161\231\179\138") or T("\230\137\147\229\188\128\232\131\140\230\153\175\230\168\161\231\179\138"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 13,
    dimensions = CCSizeMake(50, 0),
    key = "xnms",
    show = true,
    click = function()
      ed.setBlurBg(not ed.isBlurBg)
      self:pop()
    end
  },
  {
    icon = "UI/alpha/1080P/common/global/set_language.png",
    iconOffset = {-30, 0},
    text = T("\232\175\173\232\168\128"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentCenter,
    fontSize = 13,
    dimensions = CCSizeMake(50, 0),
    key = "language",
    show = ed.isAreaOverSea(),
    click = function()
      ed.ui.languageSettingWin.create():popWindow()
    end
  },
  {
    icon = "UI/alpha/1080P/common/global/icon.png",
    iconOffset = {-30, 0},
    text = T("\232\180\167\229\184\129\232\175\166\230\131\133"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 13,
    dimensions = CCSizeMake(50, 0),
    key = "currency",
    show = ed.isAreaOverSea(),
    click = function()
      ed.ui.currencyDetailWin.create():popWindow()
    end
  },
  {
    icon = "UI/alpha/1080P/helper/helper_icon.png",
    iconOffset = {-30, 0},
    text = T("\231\153\189\232\153\142\229\176\143\229\138\169\230\137\139"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 13,
    dimensions = CCSizeMake(50, 0),
    key = "helper",
    redPointKey = "player_info_speed_helper_entry",
    show = function()
      return ed.speedHelperMgr.getInstance():getSpeedUpUnlock()
    end,
    click = function()
      ed.UITool.openView("speedHelperWindow")
    end
  },
  {
    icon = "UI/alpha/1080P/setting/xn_chilun.png",
    iconOffset = {-30, 0},
    text = ed.isNewDamageNum and T("\229\133\179\233\151\173\228\188\164\229\174\179\231\177\187\229\158\139\230\149\176\229\173\151") or T("\229\188\128\229\144\175\228\188\164\229\174\179\231\177\187\229\158\139\230\149\176\229\173\151"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 12,
    dimensions = CCSizeMake(50, 0),
    key = "closeNum",
    show = true,
    click = function(btn)
      ed.setDamageNumType(not ed.isNewDamageNum)
      ed.setString(btn.textNode, ed.isNewDamageNum and T("\229\133\179\233\151\173\228\188\164\229\174\179\231\177\187\229\158\139\230\149\176\229\173\151") or T("\229\188\128\229\144\175\228\188\164\229\174\179\231\177\187\229\158\139\230\149\176\229\173\151"))
    end
  },
  {
    icon = "UI/alpha/1080P/common/global/authentication/icon.png",
    iconOffset = {-30, 0},
    text = T("\232\174\164\232\175\129\230\180\187\229\138\168"),
    textOffset = {15, 0},
    Alignment = kCCTextAlignmentLeft,
    fontSize = 12,
    dimensions = CCSizeMake(50, 0),
    key = "authentic",
    show = ed.isAreaOverSea(),
    click = function(btn)
      ReloadModule("ui_new/modules/authentication/init")
      ed.authenticationNet:sendOpenPanel()
    end
  }
}
ed.ui.serviceSettingWin.serviceSettingOption = serviceSettingOption

function serviceSettingWin.create()
  local self = base.create("serviceSettingWin")
  setmetatable(self, serviceSettingWin.mt)
  self.serviceSettingOption = serviceSettingOption
  self:init()
  return self
end

function serviceSettingWin:init()
  if self.serviceSettingOption[10].key == "xnms" then
    self.serviceSettingOption[10].text = ed.isBlurBg and T("\229\133\179\233\151\173\232\131\140\230\153\175\230\168\161\231\179\138") or T("\230\137\147\229\188\128\232\131\140\230\153\175\230\168\161\231\179\138")
    self.serviceSettingOption[10].click = function()
      ed.setBlurBg(not ed.isBlurBg)
      self:pop()
    end
  end
  self:adjustServiceSetting()
  self:initView()
  self:addEventListener()
end

function serviceSettingWin:adjustServiceSetting()
  local showCount = 0
  for i, v in ipairs(self.serviceSettingOption) do
    if v.show then
      showCount = showCount + 1
    end
  end
  if 9 < showCount then
    ed.uieditor.serviceSetting[1].config.scaleSize = CCSizeMake(408, 261)
    ed.uieditor.serviceSetting[2].layout.position = ccp(203.5, 237.5)
    ed.uieditor.serviceSetting[3].layout.position = ccp(119.5, 236.5)
    ed.uieditor.serviceSetting[4].layout.position = ccp(289.5, 236.5)
    ed.uieditor.serviceSetting[5].config.scaleSize = CCSizeMake(370, 206)
  end
end

function serviceSettingWin:initView()
  local container, ui = ed.editorui(ed.uieditor.serviceSetting)
  self.ui = ui
  self.container:addChild(container)
  self:show()
  self.draglist = ed.UITool.createDraglist(self.ui.btns_panel, {priority = -300})
  self.draglist:clearList()
  local showCount = 0
  local size
  local panelSize = self.ui.btns_panel:getContentSize()
  local spaceCol = 30
  local spaceRow = 20
  local maxCol = 3
  for index = 1, #self.serviceSettingOption do
    local settingConfig = self.serviceSettingOption[index]
    local isShow
    if type(settingConfig.show) == "function" then
      isShow = settingConfig.show()
    else
      isShow = settingConfig.show
    end
    if isShow then
      showCount = showCount + 1
      local btn = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
      size = btn:getContentSize()
      local textDes
      if ed.isNewDamageNum then
        textDes = T("\229\133\179\233\151\173\228\188\164\229\174\179\231\177\187\229\158\139\230\149\176\229\173\151")
      else
        textDes = T("\229\188\128\229\144\175\228\188\164\229\174\179\231\177\187\229\158\139\230\149\176\229\173\151")
      end
      local text
      if settingConfig.key == "closeNum" then
        text = ed.createLabelTTF(textDes, settingConfig.fontSize)
      else
        text = ed.createLabelTTF(settingConfig.text, settingConfig.fontSize)
      end
      text:setHorizontalAlignment(settingConfig.Alignment)
      if ed.isAreaZh() then
        ed.setLabelDimensions(text, settingConfig.dimensions or CCSizeMake(70, 0))
      else
        ed.adaptLabel(text, {
          maxWidth = 60,
          maxHeight = 35,
          minScale = 0.7
        })
      end
      ed.setLabelColor(text, ccc3(253, 240, 158))
      text:setPosition(size.width / 2 + settingConfig.textOffset[1], size.height / 2 + settingConfig.textOffset[2])
      btn.textNode = text
      btn:addChild(text)
      local icon = ed.createSprite(settingConfig.icon)
      icon:setPosition(size.width / 2 + settingConfig.iconOffset[1], size.height / 2 + settingConfig.iconOffset[2])
      if settingConfig.key == "versionChange" or settingConfig.key == "xnms" then
        icon:setScale(0.6)
      end
      btn:addChild(icon)
      if settingConfig.redPointKey then
        local iconRed = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
        btn:addChild(iconRed)
        iconRed:setPosition(ccp(95, 37))
        ed.redPointMgr.getInstance():registerValueChange(settingConfig.redPointKey, self, {
          handle = function(value)
            iconRed:setVisible(0 < value)
          end
        })
      end
      self:btRegisterButtonClick({
        button = btn,
        key = settingConfig.key,
        clickInterval = 0.3,
        force = true,
        pressScale = 0.9,
        clickHandler = function()
          settingConfig.click(btn)
        end
      })
      if settingConfig.key == "customerService" then
        serviceSettingWin.createPSPRedPoint(self, btn)
      end
      local colIndex = (showCount - 1) % maxCol
      local lineIndex = math.ceil(showCount / maxCol)
      btn:setPosition(ccp((size.width + spaceCol) * colIndex + size.width * 0.5, panelSize.height - (size.height + spaceRow) * (lineIndex - 1) - size.height * 0.5))
      self.draglist:addItem(btn)
    end
  end
  local totalLine = math.ceil(showCount / maxCol)
  self.draglist:initListHeight((size.height + spaceRow) * totalLine - spaceRow)
end

function serviceSettingWin:addEventListener()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:pop()
    end,
    force = true
  })
  CloseEvent("SDKLogin")
  self:listenEvent("SDKLogin", function()
    ed.showAlertDialog({
      text = T("\229\136\135\230\141\162\232\180\166\229\143\183\230\136\144\229\138\159\239\188\140\233\135\141\229\144\175\229\144\142\231\148\159\230\149\136\227\128\130"),
      buttonText = T("\233\135\141\229\144\175"),
      handler = function()
        EDRestartGame()
      end
    })
  end)
end

function serviceSettingWin:pop()
  self:destroy()
end

function serviceSettingWin:onWinDestroy()
  ed.redPointMgr.getInstance():unregisterAllValueChange(self)
  base.onWinDestroy(self)
end

local pSPEventRedPoint = false
ListenEvent("PSPEventRedPoint", function(red)
  pSPEventRedPoint = red == "true"
end)

function serviceSettingWin.createPSPRedPoint(controller, parent)
  local redpoint = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  redpoint:setVisible(pSPEventRedPoint)
  local size = parent:getContentSize()
  redpoint:setPosition(size.width - 5, size.height - 5)
  parent:addChild(redpoint, 1)
  controller:listenEvent("PSPEventRedPoint", function(red)
    redpoint:setVisible(red == "true")
  end)
  return redpoint
end

local lilithVipEventRedPoint = false
ListenEvent("LilithVipEventRedPoint", function(red)
  lilithVipEventRedPoint = red == "true"
end)

function serviceSettingWin.createLilithVipRedPoint(controller, parent)
  local redpoint = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  redpoint:setVisible(lilithVipEventRedPoint)
  local size = parent:getContentSize()
  redpoint:setPosition(size.width - 5, size.height - 5)
  parent:addChild(redpoint, 1)
  controller:listenEvent("LilithVipEventRedPoint", function(red)
    redpoint:setVisible(red == "true")
  end)
  return redpoint
end
