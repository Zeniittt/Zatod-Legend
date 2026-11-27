local base = ed.ui.popwindow
local playerInfoWindow = newclass(base.mt)
ed.ui.playerInfoWindow = playerInfoWindow
local mapCfg = ed.ui.configs.mainSceneMap
local BuilddingType = mapCfg.builddingType

function playerInfoWindow.create(lv, newLv, vitality)
  local self = base.create("playerInfoWindow")
  setmetatable(self, playerInfoWindow.mt)
  playerInfoWindow.eventScope = {}
  self.lv = lv
  self.newLv = newLv
  self.vitality = vitality
  self:init()
  return self
end

function playerInfoWindow:init()
  self:initView()
  self:addEventListener()
end

function playerInfoWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.playerInfo)
  self.ui = ui
  self.container:addChild(container)
  if self.ui.Label_111:getContentSize().width > 60 then
    local deltaX = self.ui.Label_111:getContentSize().width - 60
    ed.UITool.setPositionBy(self.ui.team_level, ccp(deltaX, 0))
    ed.UITool.setPositionBy(self.ui.ImageView_131, ccp(deltaX, 0))
  end
  if 60 < self.ui.Label_111_Copy0:getContentSize().width then
    ed.right2(self.ui.guild_name, self.ui.Label_111_Copy0, 2)
  end
  self:initPlayerInfo()
  self:initBottomButtons()
  self.ui.btn_personal_setting_label:setPositionY(self.ui.btn_personal_setting_label:getPositionY() + 1)
  ed.setLabelShadow(self.ui.btn_personal_setting_label, ed.toccc3(0), ccp(1, 0))
  self.ui.btn_personal_setting_label:limitWidthByScale(self.ui.btn_personal_setting:getContentSize().width - 10)
  self.ui.btn_team_honor_label:setPositionY(self.ui.btn_team_honor_label:getPositionY() + 1)
  ed.setLabelShadow(self.ui.btn_team_honor_label, ed.toccc3(0), ccp(1, 0))
  self.ui.btn_team_honor_label:limitWidthByScale(self.ui.btn_team_honor:getContentSize().width - 10)
  self.ui.ImageView_100_Copy0:setPositionX(-self.ui.ImageView_100_Copy0:getContentSize().width * 0.5 - 10)
  self.ui.ImageView_100:setPositionX(self.ui.lb_title:getContentSize().width + self.ui.ImageView_100:getContentSize().width * 0.5 + 10)
  self:show()
end

function playerInfoWindow:refreshHead()
  if not self.ui.headIcon then
    local head, headicon, headfca = ed.getHeadIcon()
    headicon:setScale(1.05)
    self.ui.headIcon = headicon
    self.ui.head = head
    self.ui.head_panel:addChild(head)
    self.headfca = headfca
    local frame, frameicon, framefca = ed.getHeadFrame({hide_icon_when_dyna = true})
    self.ui.headFrame = frame
    self.ui.frameicon = frameicon
    self.ui.head_panel:addChild(frame)
    self.framefca = framefca
    return
  end
  self.ui.frameicon:setVisible(true)
  local avatar = ed.player:getHeadIcon()
  local avatarFrame = ed.player:getHeadIconF()
  ed.setTexture(self.ui.headIcon, avatar.Picture)
  ed.setTexture(self.ui.frameicon, avatarFrame.Picture)
  local avtrFca = avatar["Dynamic Model"]
  local avtrSpine = avatar["Spine Dynamic Model"]
  if self.headfca then
    self:removeFca(self.headfca)
    self.headfca:removeFromParentAndCleanup(true)
    self.headfca = nil
  end
  if avtrSpine then
    local spine = ed.createSpineEffect(avtrSpine)
    spine:setAnimation(0, "Idle", true)
    self.ui.head:addChild(spine)
    self.headfca = spine
    spine:setScale(avatar.Scale or 1)
  elseif avtrFca then
    local fca = ed.createFcaNode(avtrFca)
    self:addFca(fca)
    self.ui.head:addChild(fca)
    self.headfca = fca
    fca:setScale(avatar.Scale or 1)
  end
  local frameFca = avatarFrame["Dynamic Model"]
  local frameSpine = avatarFrame["Spine Dynamic Model"]
  if self.framefca then
    self:removeFca(self.framefca)
    self.framefca:removeFromParentAndCleanup(true)
    self.framefca = nil
  end
  if frameSpine then
    local spine = ed.createSpineEffect(frameSpine)
    spine:setAnimation(0, "Idle", true)
    self.ui.headFrame:addChild(spine)
    self.framefca = spine
    spine:setScale(avatarFrame.Scale or 1)
    self.ui.frameicon:setVisible(false)
  elseif frameFca then
    local fca = ed.createFcaNode(frameFca)
    self:addFca(fca)
    self.ui.headFrame:addChild(fca)
    self.framefca = fca
    fca:setScale(avatarFrame.Scale or 1)
  end
end

function playerInfoWindow:initPlayerInfo()
  local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
    notClick = true,
    anchorPoint = ccp(0.5, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "rename_bg", "team_name", name)
  local max = ed.player:getLevel() >= ed.parameter.team_level_max
  self.ui.team_level:setString(max and ed.player:getLevel() or string.format("%s/%s", ed.player:getLevel(), ed.parameter.team_level_max))
  self.ui.progress_disabled:setVisible(max)
  if max then
    self.ui.progress:setVisible(false)
    self.ui.progress_text:setString(T("\229\183\178\232\190\190\229\136\176\230\156\128\229\164\167\231\173\137\231\186\167"))
    self.ui.team_level:setString(max and ed.player:getLevel())
  else
    self.ui.team_level:setString(string.format("%s/%s", ed.player:getLevel(), ed.parameter.team_level_max))
    local exp = ed.player:getExp()
    local maxexp = ed.player:getMaxExp()
    self.ui.progress_text:setString(string.format("%s/%s", exp, maxexp))
    self.ui.progress_text:setZOrder(10)
    local size = self.ui.progress:getContentSize()
    local rate = exp / maxexp
    self.ui.progress_clip:setScaleY(0.85)
    self.ui.progress_clip:setClipRect(CCRectMake(0, 0, rate * size.width, size.height))
  end
  ed.setLabelStroke(self.ui.progress_text, ed.toccc3(2368290), 1)
  self.ui.guild_name:setString(ed.player:getGuildName() or T("\230\154\130\230\151\160"))
  local svrname = ""
  local serverID, serverName = ed.processServerName(game_server_name)
  if nil ~= serverID then
    svrname = serverID .. " " .. ed.getLocalServerName(serverName)
  else
    svrname = ed.getLocalServerName(serverName)
  end
  self.ui.server_name:setString(svrname)
  self.ui.server_name:setPositionX(self.ui.Label_111_Copy1:getContentSize().width + self.ui.Label_111_Copy1:getPositionX())
  self.ui.role_id:setString(ed.getRoleId())
  self.ui.role_id:setPositionX(self.ui.Label_111_Copy3:getPositionX() + self.ui.Label_111_Copy3:getContentSize().width)
  self.ui.btn_copy:setPositionX(self.ui.role_id:getPositionX() + self.ui.role_id:getContentSize().width + 20)
  self.ui.uid:setString(ed.getUserid())
  self.ui.uid:setPositionX(self.ui.Label_111_Copy2:getContentSize().width + self.ui.Label_111_Copy2:getPositionX())
  self:switchMenu("music", ed.getSoundSwitch())
  self:switchMenu("effect", ed.getSoundEffectsSwitch())
  self:refreshHead()
  if ed.isAreaOverSea() then
    self.ui.ip_location:setVisible(false)
  else
    self.ui.ip_location:setString(T("IP\229\177\158\229\156\176:" .. ed.getIpLocation()))
  end
  self.ui.merge_svr_btn:setPositionX(self.ui.server_name:getContentSize().width + self.ui.server_name:getPositionX() + 17)
  if not ed.player.mergeSvrList then
    self.ui.merge_svr_btn:setVisible(false)
  end
end

local bottomButtons = {
  {
    type = "serviceSetting",
    visible = true,
    icon = "UI/alpha/1080P/playerinfo/icon_service.png",
    text = T("\230\156\141\229\138\161\232\174\190\231\189\174"),
    redPointKey = "player_info_service_setting_entry",
    click = function()
      ed.ui.serviceSettingWin.create():popWindow()
    end
  },
  {
    type = "exchangeCode",
    visible = true,
    icon = "UI/alpha/1080P/playerinfo/icon_cdk.png",
    text = T("\229\133\145\230\141\162\231\160\129"),
    click = function()
      ed.ui.redeemCodeWin.create():popWindow()
    end
  },
  {
    type = "notification",
    visible = false,
    icon = "UI/alpha/1080P/playerinfo/icon_push.png",
    text = T("\230\142\168\233\128\129"),
    click = function()
      ed.ui.pushNotificationWin.create():popWindow()
    end
  }
}
playerInfoWindow.bottomButtons = bottomButtons

function playerInfoWindow:initBottomButtons()
  self.buttons = {}
  local size
  local count = 0
  local minScale = 1
  for i, v in ipairs(bottomButtons) do
    if v.visible then
      local btn = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
      btn:setScale(1.2)
      size = btn:getContentSize()
      local text = ed.createLabelTTF(v.text, 15)
      ed.setLabelColor(text, ccc3(253, 240, 158))
      ed.setLabelShadow(text, ccc3(0, 0, 0), ccp(1, 0))
      text:setPosition(size.width / 2 + 15, size.height / 2 + 1)
      minScale = math.min(minScale, size.width * 0.65 / text:getContentSize().width)
      btn:addChild(text)
      local icon = ed.createSprite(v.icon)
      icon:setPosition(20, size.height / 2 + 1)
      btn:addChild(icon)
      self.ui.btns_panel:addChild(btn)
      if v.redPointKey then
        local iconRed = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
        btn:addChild(iconRed)
        iconRed:setPosition(ccp(95, 37))
        ed.redPointMgr.getInstance():registerValueChange(v.redPointKey, self, {
          handle = function(value)
            iconRed:setVisible(0 < value)
          end
        })
      end
      self:btRegisterButtonClick({
        button = btn,
        key = text,
        clickInterval = 0.3,
        force = true,
        pressScale = 1.1,
        normalScale = 1.2,
        clickHandler = function()
          v.click()
        end
      })
      self.buttons[v.type] = {
        btn = btn,
        txt = text,
        config = v
      }
      count = count + 1
    end
  end
  for i, v in pairs(self.buttons) do
    v.txt:setScale(minScale)
  end
  if size then
    local space = 50
    local maxcol = 4
    local line = math.ceil(count / maxcol)
    ed.layout.layoutChildrenWithSize(self.ui.btns_panel, CCSizeMake((size.width + space) * maxcol, size.height * line), ed.layoutType.Grid, {
      gridSize = CCSizeMake(size.width + space, size.height)
    })
    if 1 < line then
      local bgsize = self.ui.bg:getContentSize()
      self.ui.bg:setContentSize(CCSizeMake(bgsize.width, bgsize.height + (line - 1) * size.height))
    end
    self.ui.btns_panel:setPositionX(self.ui.btns_panel:getPositionX() - space / 2)
    if self.buttons.serviceSetting then
      ed.ui.serviceSettingWin.createPSPRedPoint(self, self.buttons.serviceSetting.btn)
    end
  end
end

function playerInfoWindow:onWinDestroy()
  ed.redPointMgr.getInstance():unregisterAllValueChange(self)
  base.onWinDestroy(self)
end

function playerInfoWindow:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_personal_setting,
    press = self.ui.btn_personal_setting_press,
    key = "btn_personal_setting",
    clickInterval = 0.3,
    force = true,
    pressScale = 1.1,
    normalScale = 1.2,
    clickHandler = function()
      ed.ui.headSettingWindow.create():popWindow()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_team_honor,
    press = self.ui.btn_team_honor_press,
    key = "btn_team_honor",
    clickInterval = 0.3,
    force = true,
    pressScale = 1.1,
    normalScale = 1.2,
    clickHandler = function()
      ed.PlayerInfoNetwork:openPanel()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.rename_bg,
    key = "rename",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.98,
    clickHandler = function()
      local cd = ed.player:getNameCountdown()
      if cd then
        ed.showAlertDialog({
          text = T("%s\229\144\142\229\143\175\228\187\165\229\134\141\230\172\161\232\191\155\232\161\140\230\148\185\229\144\141!", cd)
        })
        return
      end
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.ui.renameWindow.create():popWindow()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.switch_music_bg,
    key = "switch_music_bg",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      ed.turnSoundSwitch()
      self:switchMenu("music", ed.getSoundSwitch())
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.switch_effect_bg,
    key = "switch_effect_bg",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      ed.turnSoundEffect()
      self:switchMenu("effect", ed.getSoundEffectsSwitch())
    end
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event ~= "ended" then
        return false
      end
      if not ed.containsPoint(self.ui.bg, x, y) then
        CloseScope(playerInfoWindow.eventScope)
        playerInfoWindow.eventScope = nil
        self:destroy()
      end
      return false
    end,
    key = "playerInfoWindow",
    priority = -100
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_copy,
    press = self.ui.btn_copy_press,
    pressScale = 0.98,
    clickHandler = function()
      ed.copyString(ed.getRoleId())
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.merge_svr_btn,
    pressScale = 0.95,
    clickInterval = 0.3,
    clickHandler = function(event, x, y)
      ed.pt(ed.player.mergeSvrList or {is = "nil"})
      if not ed.player.mergeSvrList then
        return ed.showToast(T("\230\154\130\230\151\160\229\144\136\230\156\141\228\191\161\230\129\175"))
      end
      local str = T("<lable color=ccc3(254,251,232)>\230\156\172\230\156\141\229\189\147\229\137\141\229\183\178\228\184\142\228\187\165\228\184\139\230\156\141\229\138\161\229\153\168\229\144\136\230\156\141,\230\149\176\230\141\174\229\183\178\228\186\146\233\128\154:</lable>")
      for i, v in ipairs(ed.player.mergeSvrList or {}) do
        str = str .. string.format("<br/><lable color=ccc3(251,224,116)>%s\230\156\141 %s</lable>", v._show_svr_id, v._show_svr_mame)
      end
      ed.UITool.openView("showDictInfoPop", {
        index = 1,
        x = x,
        y = y,
        desc = T(str)
      })
    end
  })
  ListenEvent("setAvatarFrame", function(result)
    if not result then
      return
    end
    self:refreshHead()
  end, playerInfoWindow.eventScope)
  ListenEvent("medal_reply", function()
    local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
      notClick = true,
      anchorPoint = ccp(0.5, 0.5)
    })
    ed.UITool.replaceUI(self.ui, "rename_bg", "team_name", name)
  end, playerInfoWindow.eventScope)
  ListenEvent("SetNameSuccess", function()
    local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
      notClick = true,
      anchorPoint = ccp(0.5, 0.5)
    })
    ed.UITool.replaceUI(self.ui, "rename_bg", "team_name", name)
  end, playerInfoWindow.eventScope)
end

function playerInfoWindow:switchMenu(key, open)
  self.ui["close_" .. key .. "_bg"]:setVisible(not open)
  self.ui["btn_" .. key]:setPositionX(open and 34.5 or 13)
end
