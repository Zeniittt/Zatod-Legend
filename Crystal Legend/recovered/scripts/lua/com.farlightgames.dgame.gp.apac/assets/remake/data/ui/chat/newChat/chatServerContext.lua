local chatServerContext = {}
ed.ui.chatServerContext = chatServerContext
chatServerContext.__index = chatServerContext
local chatNetDataMrg = ed.chatNetDataMrg
chatServerContext.isLocked = false

function chatServerContext.new(params)
  local self = {}
  setmetatable(self, chatServerContext)
  self.params = params
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.eventSpace = {}
  self:init()
  self.headIcon = {}
  return self
end

function chatServerContext:init()
  self.mainLayer = CCLayer:create()
  self:createListView()
  self.ui.msg_layer:addChild(self.mainLayer)
  ListenEvent("refreshChatHead", function()
    self:refreshChatHead()
  end, self.eventSpace)
end

function chatServerContext.Locked(lock)
  isLocked = lock
end

function chatServerContext:onDestory()
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

function chatServerContext:createListView()
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

function chatServerContext:setHide(bool, isNoUpdate)
  self.mainLayer:setVisible(not bool)
  if bool and self.autoText then
    self.autoText.node:removeFromParentAndCleanup(true)
    self.autoText = nil
  end
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

function chatServerContext:touch(event, x, y)
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

function chatServerContext:addChatItem(data)
  local isSelf = data.send_user.uid == ed.getUserid() and data.send_user.svr_id == real_game_server_id
  if ed.blacklist.isInBlacklist(data.send_user.uid, data.send_user.svr_id or tonumber(real_game_server_id)) then
    return
  end
  local sp = CCSprite:create()
  local ui = {}
  if isSelf then
    ed.editorui(ed.uieditor.chat_content_right, {container = sp, ui = ui})
  else
    ed.editorui(ed.uieditor.chat_content_left, {container = sp, ui = ui})
    ed.ui.chatSuspension.getInstance():addNewMsg()
  end
  local extraData = {
    chatId = data.msg_id,
    channel = self.curChannel,
    summary = data.send_user,
    uid = data.send_user.uid,
    sid = data.send_user.svr_id or tonumber(real_game_server_id),
    acc = data.send_user,
    server_name = ""
  }
  local params = {type = "normal"}
  self:createHeadIcon(ui, data, isSelf, params, extraData)
  self:creteContent(ui, data, isSelf, extraData, params)
  self.listView:addItem(sp, extraData, params, ui)
  if isSelf then
    self.listView.dragList:setListPos(ccp(0, 0))
  end
end

function chatServerContext:creteContent(ui, data, isSelf, extraData, params)
  local context = data.content.channel_chat or ""
  local item = self:getContentInfo(context)
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
  ui.ui_bubble:setContentSize(CCSizeMake(math.max(item.width + 40, 390), item.height + 18 + ui_height + 40))
  if isSelf then
    item.node:setPosition(23, ui.ui_bubble:getContentSize().height / 2 - 15)
  else
    item.node:setPosition(23, ui.ui_bubble:getContentSize().height / 2 - 15)
  end
  ui.ui_bubble:addChild(item.node)
  local height = ui.content_bg:getContentSize().height
  height = height + ui.ui_bubble:getContentSize().height
  params.width = 430
  params.height = height + 5 - 50
end

function chatServerContext:getContentInfo(content)
  local content = content
  local item
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
  return item
end

function chatServerContext:createHeadIcon(ui, data, isSelf, params, extraData)
  local speakerSummary = data.send_user
  local speakerPhotoId = speakerSummary.cp_photo
  local speakerFrameId = speakerSummary.cp_frame_id
  local time = self:getChatTimeDes(data.timestamp)
  local param = {
    id = speakerSummary.avatar
  }
  ui.lable_time:setString(time)
  local headIcon = ed.getWholeHeadIcon(param)
  headIcon:setScale(0.57)
  headIcon:setPosition(ccp(23, 21.5))
  ui.hero_icon:addChild(headIcon)
  params.headIcon = ui.hero_icon
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
  elseif enable and speakerPhotoId then
    local function callback(path)
      ui.hero_icon:removeAllChildrenWithCleanup(true)
      
      local headIcon = ed.getWholeHeadIcon({res = path, frameId = speakerFrameId})
      headIcon:setScale(0.57)
      headIcon:setPosition(ccp(23, 21.5))
      ui.hero_icon:addChild(headIcon)
    end
    
    ed.UploadImage:getImage(speakerPhotoId, true, callback)
  end
  ui.lable_player_name:setString(speakerSummary.name)
  ui.labl_player_level:setString(speakerSummary.level)
  local levelBgRes
  levelBgRes = ed.getLevelBg(speakerSummary.babel_level, speakerSummary.vip, levelBgRes)
  if levelBgRes then
    ui.labl_player_level:setString(speakerSummary.babel_level)
    ui.img_player_level:setVisible(false)
    ui.img_player_babel:setVisible(true)
  end
  if speakerSummary.medal_id and speakerSummary.medal_id ~= 0 then
    local medal_id = speakerSummary.medal_id
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
        get_time = nil,
        expire_time = nil,
        is_new = nil
      })
    end
  end
  if speakerSummary.gender then
    local sex_sp, textColor
    print("speakerSummary.gender---->>>", speakerSummary.gender)
    if speakerSummary.gender == "male" then
      sex_sp = ed.createSprite("UI/alpha/HVGA/chat/chat_icon_male.png")
      textColor = ccc3(37, 219, 212)
    elseif speakerSummary.gender == "female" then
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

function chatServerContext:getChatTimeDes(data)
  local time = ed.time2China(data)
  local curTime = ed.time2China()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  if 1800 < curTime - time then
    return T("%d\230\156\136%d\230\151\165 %02d:%02d", mon, d, h, m) .. ed.getUTCLabel()
  else
    return string.format("%02d:%02d" .. ed.getUTCLabel(), h, m)
  end
end

function chatServerContext:getListPos()
  return self.listView:getListPos()
end

function chatServerContext:setListPos(pos)
  self.listView.dragList:setListPos(pos)
end

function chatServerContext:clear()
  self.listView:clear()
end

function chatServerContext:touchObjs(event, x, y)
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

function chatServerContext:startRefreshMessage()
  self:refreshChatHead()
end

function chatServerContext:stopRefreshMessage()
  if self.eventSpace then
    CloseScope(self.eventSpace)
  end
end

function chatServerContext:refreshChatHead()
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

function chatServerContext:refreshMessage()
  local function handler()
    xpcall(function()
      if ed.chatNetDataMrg.chatServerData and ed.chatNetDataMrg.chatServerData.msg then
        local chatMessages = ed.chatNetDataMrg.chatServerData.msg
        
        for i = 1, 5 do
          if chatMessages[1] then
            self:addChatItem(chatMessages[1])
            table.remove(chatMessages, 1)
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

function chatServerContext:switchChatServerRoom(channelObj)
  if self.autoText then
    self.autoText.node:removeFromParentAndCleanup(true)
    self.autoText = nil
  end
  if not channelObj then
    local text = "\232\175\183\229\133\136\233\128\137\230\139\169\228\184\128\228\184\170\232\129\138\229\164\169\229\174\164"
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = text,
      color = ccc3(215, 172, 34),
      fontSize = 16,
      maxWidth = 400
    })
    local _, height = autoText:getContentSize()
    autoText.node:setPosition(ccp(160, 240 + height * 0.5))
    self.parentLogic.ui.msg_layer:addChild(autoText.node)
    self.autoText = autoText
  end
end
