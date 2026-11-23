local chatModeList = {}
ed.ui.chatModeList = chatModeList
chatModeList.__index = chatModeList
local chatModeListSpace = {}

function chatModeList.create(params)
  local self = {}
  setmetatable(self, chatModeList)
  self.parentLogic = params.parentLogic
  self:init()
  self:switchChannleMode(params.mode or "world")
  return self
end

function chatModeList:init()
  self.lastClickTime = 0
  self:createListLayer()
  self:createChannelButton()
end

function chatModeList:getModeInfo()
  return {
    [1] = {
      name = T("\229\133\168 \230\156\141"),
      channel = "chatServer_channel",
      mode = "chatServer"
    },
    [2] = {
      name = T("\230\156\172 \230\156\141"),
      channel = "world_channel",
      mode = "world"
    },
    [3] = {
      name = T("\229\133\172 \228\188\154"),
      channel = "guild_channel",
      mode = "guild"
    },
    [4] = {
      name = T("\231\167\129 \232\129\138"),
      channel = "personal_channel",
      mode = "private"
    },
    [5] = {
      name = T("\228\187\187 \229\138\161"),
      channel = "guildhero_channel",
      mode = "guildhero"
    },
    [6] = {
      name = T("\229\137\175 \230\156\172"),
      channel = "chatroom_channel",
      mode = "chatroom"
    },
    [7] = {
      name = T("\229\175\188 \229\184\136"),
      channel = "",
      mode = "mentor"
    }
  }
end

function chatModeList:createListLayer()
  local layer = self.parentLogic.ui.channel_list_layer
  local w, h = layer:getContentSize().width, layer:getContentSize().height
  local info = {
    container = layer,
    cliprect = CCRectMake(1, 1, w, h),
    noshade = false,
    zorder = 1
  }
  local draglist = ed.draglist.create(info)
  self.draglist_info = info
  self.draglist = draglist
end

function chatModeList:createChannelButton()
  local info = self:getModeInfo()
  self.channelBtnList = {}
  local listheight = 0
  local posX = 2
  local posY = 380
  local itemHeight = 49
  for i = 1, #info do
    local v = info[i]
    local sp = CCSprite:create()
    self.ui = {}
    local _, ui = ed.editorui(ed.uieditor.channel_btn, {container = sp})
    ui.lable_channel_name:setString(v.name)
    ui.btn_tab_select:setVisible(false)
    sp:setPosition(ccp(posX, posY - itemHeight * (i - 1)))
    self.channelBtnList[v.mode] = ui
    listheight = listheight + itemHeight + 2
    self.draglist:addItem(sp)
  end
  self.draglist:initListHeight(listheight)
end

local pressKey

function chatModeList:touch(event, x, y)
  if ed.chatUtil:isHide(self.parentLogic.ui.channel_list_layer) then
    return
  end
  self:settingTouch(event, x, y)
  if event == "began" then
    for key, ui in pairs(self.channelBtnList) do
      if ed.containsPoint(ui.btn_tab, x, y) then
        pressKey = key
        ui.btn_tab_select:setVisible(true)
        return true
      end
    end
  elseif event == "ended" and pressKey then
    local ui = self.channelBtnList[pressKey]
    if self.curMode ~= pressKey then
      ui.btn_tab_select:setVisible(false)
    end
    if ed.containsPoint(ui.btn_tab, x, y) then
      ed.playEffect(ed.sound.prepare.clickFilter)
      self:switchChannleMode(pressKey)
      self.lastClickTime = ed.getServerTime()
    end
  end
end

function chatModeList:switchChannleMode(modeKey)
  if modeKey == "guild" and ed.player:getGuildId() == 0 then
    ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
    return
  end
  for key, ui in pairs(self.channelBtnList) do
    if modeKey == key then
      ui.btn_tab_select:setVisible(true)
    else
      ui.btn_tab_select:setVisible(false)
    end
  end
  local ui = self.channelBtnList[self.curMode]
  if self.curMode == modeKey then
    if self.curMode == "private" then
      ui.redPoint:setVisible(false)
      ed.chatNetDataMrg.notifyPrivateCount = 0
    elseif self.curMode == "guildhero" then
      ed.chatNetDataMrg.notifyGuildHeroTaskCount = 0
      ui.redPoint:setVisible(false)
    elseif self.curMode == "chatroom" then
      ed.chatNetDataMrg.notifyChatRoomCount = 0
      ui.redPoint:setVisible(false)
    elseif self.curMode == "chatServer" then
      ed.chatNetDataMrg.notifyChatServerCount = 0
      ui.redPoint:setVisible(false)
    end
    return
  end
  self.curMode = modeKey
  self.parentLogic:switchChannel(self.curMode)
  if modeKey == "mentor" then
    if ed.getCurrentScene().identity ~= "main" then
      return
    end
    FireEvent("CloseChatView")
    local uiItem = self.channelBtnList[modeKey]
    ed.getCurrentScene().mainLayer:addChild(ed.ui.MentorFrame.create({
      callback = function(...)
      end
    }).mainLayer, 999)
    return
  end
  ui = self.channelBtnList[self.curMode]
  if self.curMode == "private" then
    ui.redPoint:setVisible(false)
    ed.chatNetDataMrg.notifyPrivateCount = 0
  elseif self.curMode == "guildhero" then
    ed.chatNetDataMrg.notifyGuildHeroTaskCount = 0
    ui.redPoint:setVisible(false)
  elseif self.curMode == "chatroom" then
    ed.chatNetDataMrg.notifyChatRoomCount = 0
    ui.redPoint:setVisible(false)
  elseif self.curMode == "chatServer" then
    ed.chatNetDataMrg.notifyChatServerCount = 0
    ui.redPoint:setVisible(false)
  end
  FireEvent("destroy_emoji_view")
end

function chatModeList:settingTouch(event, x, y)
  if event == "began" then
    if ed.containsPoint(self.parentLogic.ui.setting_btn, x, y) then
      self.isSettingPress = true
      self.parentLogic.ui.setting_btn:setScale(0.95)
    end
  elseif event == "ended" then
    if self.isSettingPress and ed.containsPoint(self.parentLogic.ui.setting_btn, x, y) then
      self:onClickSetting()
      self.isSettingPress = false
    end
    self.parentLogic.ui.setting_btn:setScale(1)
  end
end

function chatModeList:onClickSetting()
  ed.ui.chatSetting.create()
end

function chatModeList:refreshRedTip()
  for k, ui in pairs(self.channelBtnList) do
    if k ~= self.curMode then
      if k == "private" then
        if ed.chatNetDataMrg.notifyPrivateCount and ed.chatNetDataMrg.notifyPrivateCount > 0 then
          ui.redPoint:setVisible(true)
          ui.msg_num:setString(tostring(ed.chatNetDataMrg.notifyPrivateCount))
        end
      elseif k == "guildhero" then
        if ed.chatNetDataMrg.notifyGuildHeroTaskCount and 0 < ed.chatNetDataMrg.notifyGuildHeroTaskCount then
          ui.redPoint:setVisible(true)
          ui.msg_num:setString(tostring(ed.chatNetDataMrg.notifyGuildHeroTaskCount))
        end
      elseif k == "chatroom" then
        if ed.chatNetDataMrg.notifyChatRoomCount and 0 < ed.chatNetDataMrg.notifyChatRoomCount then
          ui.redPoint:setVisible(true)
          ui.msg_num:setString(tostring(ed.chatNetDataMrg.notifyChatRoomCount))
        end
      elseif k == "chatServer" and ed.chatNetDataMrg.notifyChatServerCount and 0 < ed.chatNetDataMrg.notifyChatServerCount then
        ui.redPoint:setVisible(true)
        ui.msg_num:setString(tostring(ed.chatNetDataMrg.notifyChatServerCount))
      end
    end
  end
end
