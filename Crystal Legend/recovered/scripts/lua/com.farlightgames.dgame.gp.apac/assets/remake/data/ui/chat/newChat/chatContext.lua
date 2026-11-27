local chatContext = {}
ed.ui.chatContext = chatContext
chatContext.__index = chatContext
local chatNetDataMrg = ed.chatNetDataMrg

function chatContext.new(params)
  local self = {}
  setmetatable(self, chatContext)
  self.params = params
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.eventSpace = {}
  self:init()
  self.linkList = {}
  self.headIcon = {}
  return self
end

local isLocked = false

function chatContext:setChannel(channel)
  self.curChannel = channel
end

function chatContext:init()
  self.mainLayer = CCLayer:create()
  self:createListView()
  self.ui.msg_layer:addChild(self.mainLayer)
end

function chatContext:onDestory()
  local observed = ed.ui.chatSuspension.getInstance():getObserved()
  if observed == self then
    ed.ui.chatSuspension.getInstance():setObserved(nil)
  end
  self.listView:clear()
  if self.listView.dragList.mainLayer:getParent() then
    self.listView.dragList.mainLayer:removeFromParentAndCleanup(true)
  end
  if self.mainLayer:getParent() then
    self.mainLayer:removeFromParentAndCleanup(true)
  end
end

function chatContext:createListView()
  local w, h = self.ui.msg_layer:getContentSize().width, self.ui.msg_layer:getContentSize().height
  self.listView = ed.ui.chatListView.new()
  self.listView:setPanelLayer(self.mainLayer)
  self.listView:initParem({
    base = {
      colNum = 1,
      itemWidthInner = 5,
      layoutMode = "up",
      maxItem = 50,
      heightInner = 5,
      initHeight = 0,
      initWidth = 0,
      container = self.mainLayer,
      cliprect = CCRectMake(1, 1, w, h),
      noshade = true,
      zorder = 1,
      selfDealMessage = true
    }
  })
end

function chatContext:setHide(bool, isNoUpdate)
  self.mainLayer:setVisible(not bool)
  if not isNoUpdate then
    if bool then
      self:stopRefreshMessage()
    else
      self:startRefreshMessage()
    end
  end
  if not bool then
    ed.ui.chatSuspension.getInstance():setObserved(self)
  end
end

function chatContext.Locked(lock)
  isLocked = lock
end

function chatContext:touch(event, x, y)
  if ed.chatUtil:isHide(self.mainLayer) then
    return
  end
  if isLocked then
    return
  end
  if not ed.containsPoint(self.ui.msg_layer, x, y) and (event == "began" or event == "moved") then
    return
  end
  xpcall(function()
    self.listView:touch(event, x, y)
    self:touchObjs(event, x, y)
  end, EDDebug)
end

function chatContext:addChatItem(data)
  local isSelf = data._speaker_role_id == ed.getRoleId()
  local sp = CCSprite:create()
  local ui = {}
  if isSelf then
    ed.editorui(ed.uieditor.chat_content_right, {container = sp, ui = ui})
  else
    ed.editorui(ed.uieditor.chat_content_left, {container = sp, ui = ui})
    ed.ui.chatSuspension.getInstance():addNewMsg()
  end
  local extraData = {
    chatId = data._chat_id,
    channel = self.curChannel,
    summary = data._speaker_summary,
    roleId = data._speaker_role_id,
    acc = data._summary,
    server_name = data._speaker_server_name
  }
  local params = {type = "normal"}
  self:createHeadIcon(ui, data, isSelf, params, extraData)
  self:creteContent(ui, data, isSelf, extraData, params)
  self.listView:addItem(sp, extraData, params, ui)
  if isSelf then
    self.listView.dragList:setListPos(ccp(0, 0))
  end
end

function chatContext:creteContent(ui, data, isSelf, extraData, params)
  local context = data._content or ""
  local contentType = data._content_type
  local item = self:getContentInfo(context, contentType, extraData, data)
  if item.type == "richText" then
    params.linkButton = {}
    local linkAll = item.ui:getLinkAll()
    for idx = 1, #linkAll do
      local link = item.ui:getLink(idx)
      link:setFlag(idx)
      table.insert(params.linkButton, 1, link)
    end
  end
  local ui_bubble_info
  if isSelf then
    ui_bubble_info = ed.chatUtil:getRightBubble()
  else
    ui_bubble_info = ed.chatUtil:getLeftBubble()
  end
  local ui_bubble = {}
  local readNode = ed.readnode.create(ui.content_bg, ui_bubble)
  readNode:addNode(ui_bubble_info)
  ui.ui_bubble = ui_bubble.ui_bubble
  local x, y = ui.hero_icon:getPosition()
  local offsetX = 3
  if isSelf then
    offsetX = 45
  end
  ui.ui_bubble:setPosition(ccp(x + offsetX, 50))
  local ui_height = 0
  local ui_width = 0
  local offsetY = 0
  local size = CCSizeMake(math.max(item.width + 40, 390), item.height + 18 + ui_height + 60 - 20)
  ui.ui_bubble:setContentSize(size)
  if data._content_type == 2 and data._summary then
    if data._summary._type == "top_pvp_replay" or data._summary._type == "pvp_replay" or data._summary._type == "tbc_replay" or data._summary._type == "babel_replay" or data._summary._type == "binary_replay" and data._summary._query_summary and 0 < #data._summary._query_summary or data._summary._type == "real_arena_replay" and data._summary._real_arena_replay then
      local battleRoundData = data._summary or {}
      local round_num = ed.chatBattleShareMgr:getBattleRoundNum(battleRoundData._query_summary, data._summary._type)
      local offsetPos = {
        65,
        130,
        190
      }
      ui_height = offsetPos[round_num] + 10
      ui_width = 480
      size = CCSizeMake(math.max(ui_width, 390), item.height + 18 + ui_height - 20 + 68)
      local param = {
        itemNode = ui.ui_bubble,
        extraData = extraData,
        controllers = ui,
        ui_height = ui_height,
        isSelf = isSelf
      }
      ui.ui_bubble:setContentSize(size)
      ed.chatBattleShareMgr:initBattleShare(param)
    elseif data._summary._type == "cook_asst" then
      ui_height = 50
      ui_width = 480
      size = CCSizeMake(math.max(ui_width, 390), item.height + 18 + ui_height + 60 - 20)
      ui.ui_bubble:setContentSize(size)
      ed.chatCook:initData({
        itemNode = ui.ui_bubble,
        extraData = extraData,
        controllers = ui
      }, (ui.ui_bubble:getContentSize().height - 50 - item.height - ui_height) * 0.5 + ui_height - offsetY)
    end
  end
  local x = 0
  if isSelf then
    x = 25
  else
    x = 25
  end
  local y = size.height / 2
  if item.type == "richText" then
    y = y - 22
  elseif item.type == "autoText" then
    y = y - 14
  end
  local pos = ccp(x, y)
  if ui.pvpview then
    pos = ccp(x, 30)
  end
  item.node:setPosition(pos)
  ui.ui_bubble:addChild(item.node)
  local height = ui.content_bg:getContentSize().height
  height = height + ui.ui_bubble:getContentSize().height
  params.width = 400
  params.height = height + 5 - 55
end

function chatContext:getContentInfo(content, type, extraData, data)
  local content = content
  if data._content_type == 2 and data._summary and (data._summary._type == "top_pvp_replay" or data._summary._type == "pvp_replay" or data._summary._type == "babel_replay" or data._summary._type == "tbc_replay" or data._summary._type == "binary_replay" and data._summary._query_summary and #data._summary._query_summary > 0 or data._summary._type == "real_arena_replay" and data._summary._real_arena_replay) then
    content = string.match(content, "(<text.*>)") or ""
  end
  local item
  if type == 1 then
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = content,
      color = ccc3(247, 247, 214),
      maxWidth = 430,
      fontSize = 16
    })
    autoText:setVerticalCenter()
    local width, height = autoText:getCurContentSize()
    item = {
      node = autoText.node,
      type = "autoText",
      height = height,
      width = width
    }
  else
    local text = richText:new()
    text:setAnchor(ccp(0, 0.5))
    text:setString(content, extraData)
    text:setVerticalCenter()
    local width, height = text:getSize()
    item = {
      ui = text,
      node = text:getRootNode(),
      type = "richText",
      height = height,
      width = width
    }
  end
  return item
end

function chatContext:createHeadIcon(ui, data, isSelf, params, extraData)
  local speakerSummary = data._speaker_summary
  local speakerPhoto = data._speeker_photo
  local time = self:getChatTimeDes(data._speak_time)
  local flagIcon
  if extraData.roleId ~= ed.getRoleId() then
    if self.curChannel == "world_channel" then
      if ed.friendlist.isInFriendlist(extraData.roleId) then
        flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Friend.png")
      elseif ed.chatNetDataMrg:isInGuildData(extraData.roleId) then
        flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Guild.png")
      end
    elseif self.curChannel == "personal_channel" then
      if ed.chatNetDataMrg:isInGuildData(extraData.roleId) then
        flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Guild.png")
      elseif ed.friendlist.isInFriendlist(extraData.roleId) then
        flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Friend.png")
      else
        flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Stranger.png")
      end
    end
  end
  local param = {
    id = speakerSummary._avatar
  }
  local headIcon = ed.getWholeHeadIcon(param)
  headIcon:setScale(0.57)
  headIcon:setPosition(ccp(23, 21.5))
  ui.hero_icon:addChild(headIcon)
  params.headIcon = ui.hero_icon
  if flagIcon then
    flagIcon:setPosition(ccp(1, -36))
    flagIcon:setScale(1.6)
    headIcon:addChild(flagIcon)
  end
  local enable = ed.player:getCustomPhotoSwitch()
  if isSelf then
    table.insert(self.headIcon, ui.hero_icon)
    local valid = ed.player:hasValidMonthCard()
    local isOpen = ed.player:getCustomPhoto().isOpen
    local photoId = ed.player:getCustomPhoto().photoId
    if enable and valid and isOpen and photoId then
      local frameId = ed.player:getCustomPhoto().frameId
      
      local function callback(path)
        ui.hero_icon:removeAllChildrenWithCleanup(true)
        local headIcon = ed.getWholeHeadIcon({res = path, frameId = frameId})
        headIcon:setScale(0.57)
        headIcon:setPosition(ccp(23, 21.5))
        ui.hero_icon:addChild(headIcon)
      end
      
      ed.UploadImage:getImage(photoId, true, callback)
    else
      ui.hero_icon:removeAllChildrenWithCleanup(true)
      local headIcon = ed.getWholeHeadIcon({
        id = ed.player:getAvatarId(),
        frameId = ed.player:getAvatarFrame()
      })
      headIcon:setScale(0.57)
      headIcon:setPosition(ccp(23, 21.5))
      ui.hero_icon:addChild(headIcon)
    end
  elseif enable and speakerPhoto and speakerPhoto._photo then
    local photoId = speakerPhoto._photo
    
    local function callback(path)
      ui.hero_icon:removeAllChildrenWithCleanup(true)
      local headIcon = ed.getWholeHeadIcon({
        res = path,
        frameId = speakerPhoto._frame_id
      })
      headIcon:setScale(0.57)
      headIcon:setPosition(ccp(23, 21.5))
      ui.hero_icon:addChild(headIcon)
      if flagIcon then
        flagIcon:removeFromParentAndCleanup(true)
        flagIcon:setPosition(ccp(1, -36))
        flagIcon:setScale(1.6)
        headIcon:addChild(flagIcon)
      end
    end
    
    ed.UploadImage:getImage(photoId, true, callback)
  end
  ui.lable_time:setString(time)
  ui.lable_player_name:setString(speakerSummary._name)
  ui.labl_player_level:setString(speakerSummary._level)
  local levelBgRes
  levelBgRes = ed.getLevelBg(speakerSummary._babel_level, speakerSummary._vip, levelBgRes)
  if levelBgRes then
    ui.labl_player_level:setString(speakerSummary._babel_level)
    ui.img_player_level:setVisible(false)
    ui.img_player_babel:setVisible(true)
  end
  if speakerSummary._medal and speakerSummary._medal.medal_id ~= 0 then
    local medal_id = speakerSummary._medal.medal_id
    local allTitles = ed.getDataTable("Medal")
    local meadl_info = allTitles[medal_id]
    if meadl_info then
      local res = meadl_info.Picture
      local icon = ed.createSprite(res)
      local x, y = ui.lable_player_name:getPosition()
      local width = icon:getContentSize().width * 0.2
      icon:setScale(0.5)
      if isSelf then
        ui.lable_player_name:setPosition(ccp(x - width * 2, y))
        icon:setPosition(ccp(x - width, y))
      else
        ui.lable_player_name:setPosition(ccp(x + width * 2, y))
        icon:setPosition(ccp(x + width, y))
      end
      ui.content_bg:addChild(icon, 10)
      ed.chatMedal.getInstance():addMedal({
        icon = icon,
        id = medal_id,
        get_time = speakerSummary._medal.get_time,
        expire_time = speakerSummary._medal.expire_time,
        is_new = speakerSummary._medal.is_new
      })
    end
  end
  if data._speeker_gender then
    local sex_sp, textColor
    if data._speeker_gender == "male" then
      sex_sp = ed.createSprite("UI/alpha/HVGA/chat/chat_icon_male.png")
      textColor = ccc3(37, 219, 212)
    elseif data._speeker_gender == "female" then
      sex_sp = ed.createSprite("UI/alpha/HVGA/chat/chat_icon_female.png")
      textColor = ccc3(241, 95, 181)
    end
    if sex_sp and textColor then
      sex_sp:setAnchorPoint(ccp(0, 0.5))
      local x, y = ui.lable_player_name:getPosition()
      local widthText = ui.lable_player_name:getContentSize().width
      ui.lable_player_name:setColor(textColor)
      if isSelf then
        sex_sp:setPosition(ccp(x - widthText - sex_sp:getContentSize().width - 3, y))
      else
        sex_sp:setPosition(ccp(x + widthText + 3, y))
      end
      ui.content_bg:addChild(sex_sp, 10)
    end
  end
end

function chatContext:getChatTimeDes(data)
  local time = ed.time2China(data)
  local curTime = ed.time2China()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  if 1800 < curTime - time then
    return string.format(T("%d\230\156\136%d\230\151\165 %02d:%02d"), mon, d, h, m) .. ed.getUTCLabel()
  else
    return string.format("%02d:%02d" .. ed.getUTCLabel(), h, m)
  end
end

function chatContext:startRefreshMessage()
  ListenTimer(Timer:Always(0.02), self:refreshMessage(), self.eventSpace)
  ListenEvent("refreshChatHead", function()
    self:refreshChatHead()
  end, self.eventSpace)
  self:refreshChatHead()
end

function chatContext:stopRefreshMessage()
  if self.eventSpace then
    CloseScope(self.eventSpace)
  end
end

function chatContext:refreshMessage()
  local function handler()
    xpcall(function()
      local chatMessages = chatNetDataMrg.chatMessages
      
      if not self.curChannel or self.curChannel == "" then
        return
      end
      for i = 1, 5 do
        if chatMessages[self.curChannel][1] then
          self:addChatItem(chatMessages[self.curChannel][1])
          table.remove(chatMessages[self.curChannel], 1)
        end
      end
    end, EDDebug)
  end
  
  return handler
end

function chatContext:refreshChatHead()
  local enable = ed.player:getCustomPhotoSwitch()
  local valid = ed.player:hasValidMonthCard()
  local useCustomHead = false
  if enable and valid then
    local isOpen = ed.player:getCustomPhoto().isOpen
    local photoId = ed.player:getCustomPhoto().photoId
    if isOpen and photoId then
      local frameId = ed.player:getCustomPhoto().frameId
      useCustomHead = true
      for i, heroIcon in pairs(self.headIcon) do
        if not tolua.isnull(heroIcon) then
          local function callback(path)
            heroIcon:removeAllChildrenWithCleanup(true)
            
            local headIcon = ed.getWholeHeadIcon({res = path, frameId = frameId})
            headIcon:setScale(0.57)
            headIcon:setPosition(ccp(23, 21.5))
            heroIcon:addChild(headIcon)
          end
          
          ed.UploadImage:getImage(photoId, true, callback)
        end
      end
    end
  end
  if not useCustomHead then
    for i, heroIcon in pairs(self.headIcon) do
      if not tolua.isnull(heroIcon) then
        heroIcon:removeAllChildrenWithCleanup(true)
        local headIcon = ed.getWholeHeadIcon({
          id = ed.player:getAvatarId(),
          frameId = ed.player:getAvatarFrame()
        })
        headIcon:setScale(0.57)
        headIcon:setPosition(ccp(23, 21.5))
        heroIcon:addChild(headIcon)
      end
    end
  end
end

function chatContext:linktouch(event, x, y, linkbutton)
  if event == "began" then
    for k, v in ipairs(linkbutton) do
      local done = v:touch(event, x, y)
      if done then
        self.linkController = v
        return done
      end
    end
  elseif event == "ended" and self.linkController ~= nil then
    self.linkController:touch(event, x, y)
    self.linkController = nil
    return true
  end
  return false
end

function chatContext:touchObjs(event, x, y)
  if event == "began" then
    self.touchPos = ccp(x, y)
  elseif event == "ended" and self.touchPos then
    local dis = math.abs(self.touchPos.y - y)
    if 10 < dis then
      return
    end
  end
  local objs = self.listView:getALLListData() or {}
  for _, itemData in ipairs(objs) do
    if itemData.params.type ~= "system" then
      local linkbutton = itemData.params.linkButton
      if linkbutton then
        self:linktouch(event, x, y, linkbutton)
      end
      local headIcon = itemData.params.headIcon
      if event == "began" then
        if ed.containsPoint(headIcon, x, y) then
          self.touchHeadIcon = {
            headIcon,
            itemData.extraData
          }
        end
      elseif event == "ended" and self.touchHeadIcon and ed.containsPoint(self.touchHeadIcon[1], x, y) then
        local data = self.touchHeadIcon[2]
        self.touchHeadIcon = nil
        if ed.getRoleId() ~= data.roleId then
          ed.PlayerInfoNetwork:requestHomePage(data.roleId)
        else
          ed.PlayerInfoNetwork:openPanel()
        end
      end
    end
  end
end

function chatContext:addSystemMsgItem(str)
  local ui = {}
  local sp = CCSprite:create()
  ed.editorui(ed.uieditor.chat_content_system, {container = sp, ui = ui})
  local extraData = {}
  local params = {type = "system"}
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = str,
    color = ccc3(188, 63, 24),
    maxWidth = 430,
    fontSize = 16
  })
  local width, height = autoText:getCurContentSize()
  autoText:setVerticalCenter()
  ui.sp_bubble:setContentSize(CCSizeMake(math.max(width + 20, 420), height + 38 + 30))
  local height = ui.content_bg:getContentSize().height
  height = height + ui.sp_bubble:getContentSize().height - 30
  autoText.node:setPosition((ui.sp_bubble:getContentSize().width - width) * 0.5, (ui.sp_bubble:getContentSize().height - 30) / 2)
  ui.sp_bubble:addChild(autoText.node)
  params.width = 400
  params.height = height + 5
  self.listView:addItem(sp, extraData, params, ui)
end

function chatContext:addNewFriendItem()
  local ui = {}
  local sp = CCSprite:create()
  ed.editorui(ed.uieditor.FriendApplySucceedMessage, {container = sp, ui = ui})
  local extraData = {}
  local params = {type = "system"}
  local width, height = ui.bg:getContentSize().width, ui.bg:getContentSize().height
  params.width = 400
  params.height = height + 5
  self.listView:addItem(sp, extraData, params, ui)
end

function chatContext:addTipMsg(str)
  if type(str) ~= "string" then
    str = ""
  end
  local ui = {}
  local sp = CCSprite:create()
  ed.editorui(ed.uieditor.FriendApplySucceedMessage, {container = sp, ui = ui})
  ui.label_be_friend:setString(str)
  local extraData = {}
  local params = {type = "system"}
  local width, height = ui.bg:getContentSize().width, ui.bg:getContentSize().height
  params.width = 400
  params.height = height + 5
  self.listView:addItem(sp, extraData, params, ui)
end

function chatContext:getListPos()
  return self.listView:getListPos()
end

function chatContext:setListPos(pos)
  self.listView.dragList:setListPos(pos)
end
