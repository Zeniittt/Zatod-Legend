local chatFriendMgr = {}
ed.ui.chatFriendMgr = chatFriendMgr
chatFriendMgr.__index = chatFriendMgr
local chatFriendMgrSpace = {}

function chatFriendMgr.create(params)
  local self = {}
  setmetatable(self, chatFriendMgr)
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.isTouch = false
  self.params = params
  self:init()
  self.mode = {"recent", "friend"}
  self.curMode = nil
  self:switchChannleMode("recent")
  return self
end

function chatFriendMgr:init()
  self.chatContactList = ed.ui.chatContactList:create(self.params, self)
  self.chatFriendList = ed.ui.chatFriendList:create(self.params)
  self.ui.friend_layer:setVisible(false)
end

function chatFriendMgr:refreshContactState()
  self.chatContactList:refreshContactState()
end

function chatFriendMgr:setHide(bool)
  self.ui.friend_bg:setVisible(not bool)
  if not bool then
    self.chatContactList:checkIsHasItem()
    self.chatFriendList:checkIsHasItem()
  end
  self.isTouch = not bool
end

function chatFriendMgr:delFriend(param)
  ed.friendlist.deleteFriendlist(param.roleId)
  self.chatFriendList:delFriend(param)
end

function chatFriendMgr:delContact(data)
  self.chatContactList:delContact(data)
end

function chatFriendMgr:refreshRedPoint()
  local num = 0
  for k, v in pairs(ed.chatNetDataMrg.personalNotify) do
    num = num + v
  end
  if 0 < num then
    self.ui.redPoint:setVisible(true)
    self.ui.msg_num:setString(tostring(num))
  else
    self.ui.redPoint:setVisible(false)
  end
end

function chatFriendMgr:touch(event, x, y)
  if not self.isTouch then
    return
  end
  self:touchFriendBtn(event, x, y)
  self:touchRecentBtn(event, x, y)
  if self.chatContactList then
    self.chatContactList:touch(event, x, y)
  end
  if self.chatFriendList then
    self.chatFriendList:touch(event, x, y)
  end
end

function chatFriendMgr:touchFriendBtn(event, x, y)
  if event == "began" then
    if ed.containsPoint(self.ui.btn_friendList, x, y) and not ed.chatUtil:isHide(self.ui.btn_friendList) then
      self.isFriendPress = true
      self.ui.btn_friendList_select:setVisible(true)
    end
  elseif event == "ended" then
    if self.isFriendPress and ed.containsPoint(self.ui.btn_friendList, x, y) and not ed.chatUtil:isHide(self.ui.btn_friendList) then
      self.isFriendPress = false
      self:switchChannleMode(self.mode[2])
    end
    if self.curMode ~= self.mode[2] then
      self.ui.btn_friendList_select:setVisible(false)
    end
  end
end

function chatFriendMgr:touchRecentBtn(event, x, y)
  if event == "began" then
    if ed.containsPoint(self.ui.btn_mostRecentContact, x, y) and not ed.chatUtil:isHide(self.ui.btn_mostRecentContact) then
      self.ismostRecentContactPress = true
      self.ui.btn_mostRecentContact_select:setVisible(true)
    end
  elseif event == "ended" then
    if self.ismostRecentContactPress and ed.containsPoint(self.ui.btn_mostRecentContact, x, y) and not ed.chatUtil:isHide(self.ui.btn_mostRecentContact) then
      self:switchChannleMode(self.mode[1])
      self.ismostRecentContactPress = false
    end
    if self.curMode ~= self.mode[1] then
      self.ui.btn_mostRecentContact_select:setVisible(false)
    end
  end
end

function chatFriendMgr:switchChannleMode(modeKey)
  if modeKey == self.mode[2] then
    self.ui.btn_mostRecentContact_select:setVisible(false)
    self.ui.btn_friendList_select:setVisible(true)
  elseif modeKey == self.mode[1] then
    self.ui.btn_mostRecentContact_select:setVisible(true)
    self.ui.btn_friendList_select:setVisible(false)
  end
  if self.curMode == modeKey then
    return
  end
  self.curMode = modeKey
  if self.curMode == "friend" then
    self.ui.mostRecentContact_layer:setVisible(false)
    self.ui.friend_layer:setVisible(true)
  else
    self.ui.mostRecentContact_layer:setVisible(true)
    self.ui.friend_layer:setVisible(false)
    self:refreshRedPoint()
    self.chatFriendList:reset()
  end
end

function chatFriendMgr:initContactItem()
  if self.chatContactList then
    self.chatContactList:initContactItem()
  end
end

function chatFriendMgr:reset()
  ed.curPrivateTarget = nil
  if self.chatContactList then
    self.chatContactList:reset()
  end
end

function chatFriendMgr:addContact(data)
  if self.chatContactList then
    self.chatContactList:addContact(data)
  end
end

function chatFriendMgr:chooseObjFromContact(roleId)
  if self.chatContactList then
    self.chatContactList:chooseObjFromContact(roleId)
  end
end

function chatFriendMgr:addNewFriend(data)
  self.chatFriendList:addContact(data)
  self.chatFriendList:refreshFriendsOnlineState()
end

function chatFriendMgr:refreshFriendData()
  self.chatContactList:refreshContactData()
  self.chatFriendList:refreshContactData()
end

local chatFriendList = {}
ed.ui.chatFriendList = chatFriendList
chatFriendList.__index = chatFriendList

function chatFriendList:create(params)
  local self = {}
  setmetatable(self, chatFriendList)
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.version = -1
  self:init()
  return self
end

function chatFriendList:init()
  self:createListView()
end

function chatFriendList:createListView()
  local w, h = self.ui.friend_list_layer:getContentSize().width, self.ui.friend_list_layer:getContentSize().height
  self.listView = ed.ui.chatListView.new()
  self.listView:setPanelLayer(self.ui.friend_list_layer)
  self.listView:initParem({
    base = {
      colNum = 1,
      itemWidthInner = 3,
      layoutMode = "up",
      maxItem = 53,
      heightInner = 3,
      initHeight = 0,
      initWidth = 0,
      container = self.ui.friend_list_layer,
      cliprect = CCRectMake(1, 1, w, h),
      noshade = true,
      zorder = 1,
      selfDealMessage = true
    }
  })
end

function chatFriendList:initContactItem()
  self.listView:clear()
  local num = ed.chatNetDataMrg.contactData.friend.num
  if num <= 0 then
    self.ui.lable_tip_3:setVisible(true)
    return
  else
    self.ui.lable_tip_3:setVisible(false)
  end
  local data = ed.chatNetDataMrg.contactData.friend.data
  for k, info in pairs(data) do
    self:createItemUI(info)
  end
end

function chatFriendList:createItemUI(data)
  local sp = CCSprite:create()
  local ui = {}
  ed.editorui(ed.uieditor.chatPlayerHeadItem, {container = sp, ui = ui})
  local extraData = data
  local width, height = ui.head_bg:getContentSize().width, ui.head_bg:getContentSize().height
  local params = {width = width, height = height}
  self:createHeadIcon(ui, data)
  ui.redPoint:setVisible(false)
  self.listView:addItem(sp, extraData, params, ui)
  if self.curSeleteItem and self.curSeleteItem.extraData.sid == extraData.sid and extraData.uid == self.curSeleteItem.extraData.uid then
    self.curSeleteItem.controllers = ui
    self.curSeleteItem.controllers.select_bg:setVisible(true)
  end
  self.ui.lable_tip_3:setVisible(false)
end

function chatFriendList:createHeadIcon(ui, data)
  local speakerSummary = data.summary
  local param = {
    id = speakerSummary._avatar
  }
  ui.headIcon = ed.getWholeHeadIcon(param)
  ui.headIcon:setScale(0.5)
  ui.headIcon:setPosition(ccp(22, 23.5))
  ui.head_bg:addChild(ui.headIcon, 10)
  ui.lable_name:setString(speakerSummary._name)
  self:setHeadOnlineState(ui, data.isOnline)
end

function chatFriendList:setHeadOnlineState(ui, onlineState)
  local headIcon = ui.headIcon
  if tonumber(onlineState) >= 1 then
    ed.chatUtil:resetAllNodeStone(headIcon)
  else
    ed.chatUtil:setAllNodeStone(headIcon)
  end
end

function chatFriendList:touch(event, x, y)
  if not self.ui.friend_layer:isVisible() then
    return
  end
  self:touchAddFriend(event, x, y)
  if not ed.containsPoint(self.ui.friend_list_layer, x, y) and (event == "began" or event == "moved") then
    return
  end
  xpcall(function()
    self.listView:touch(event, x, y)
    self:touchObjs(event, x, y)
  end, EDDebug)
end

function chatFriendList:touchAddFriend(event, x, y)
  local btn = self.ui.btn_addFriend
  if event == "began" then
    if ed.containsPoint(btn, x, y) then
      isPress = true
      btn:setScale(0.95)
      result = true
    end
  elseif event == "ended" then
    if isPress and ed.containsPoint(btn, x, y) then
      self:openAddFriendWin()
    end
    isPress = false
    btn:setScale(1)
  end
end

function chatFriendList:openAddFriendWin()
  ed.ui.chatFriendRequest.create()
end

function chatFriendList:touchObjs(event, x, y)
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
    local ui = itemData.controllers
    local headIcon = itemData.controllers.head_bg
    if event == "began" then
      if ed.containsPoint(headIcon, x, y) then
        self.touchItemData = {data = itemData}
        if ed.containsPoint(self.touchItemData.data.controllers.head_click, x, y) then
          self.touchItemData.isCliclHead = true
        end
        return
      end
    elseif event == "ended" and self.touchItemData then
      local headIcon = self.touchItemData.data.controllers.head_bg
      if ed.containsPoint(headIcon, x, y) then
        if self.touchItemData.isCliclHead and ed.containsPoint(self.touchItemData.data.controllers.head_click, x, y) then
          local data = self.touchItemData.data.extraData
          ed.PlayerInfoNetwork:requestHomePageSpecial(data.roleId)
        else
          self:selectContactObj(self.touchItemData.data)
        end
      end
      self.touchItemData = nil
    end
  end
  if event == "ended" then
    self.touchItemData = nil
  end
end

function chatFriendList:selectContactObj(itemData)
  if self.curSeleteItem and self.curSeleteItem.controllers and not tolua.isnull(self.curSeleteItem.controllers.select_bg) then
    self.curSeleteItem.controllers.select_bg:setVisible(false)
  end
  self.curSeleteItem = itemData
  self.curSeleteItem.controllers.select_bg:setVisible(true)
  self.curSeleteItem.controllers.redPoint:setVisible(false)
  itemData.extraData.friendFlag = 1
  FireEvent("chat_private_target", itemData.extraData)
end

function chatFriendList:refreshContactData()
  local num = ed.chatNetDataMrg.contactData.friend.num
  if num <= 0 then
    self.ui.lable_tip_3:setVisible(true)
    return
  else
    self.ui.lable_tip_3:setVisible(false)
  end
  local data = ed.chatNetDataMrg.contactData.friend.data
  self:clearAllFriendItem()
  for k, info in pairs(data) do
    self:addContact(info)
  end
  self:refreshFriendsOnlineState()
end

function chatFriendList:refreshFriendsOnlineState()
  local function fun(a, b)
    local a_data = a.extraData
    
    local b_data = b.extraData
    if a_data.isOnline < b_data.isOnline then
      return true
    end
    return false
  end
  
  self.listView:sortFormFun(fun)
  self:refreshOnlineLable()
end

function chatFriendList:delFriend(data)
  local objs = self.listView:getALLListData() or {}
  local index
  for i, itemData in ipairs(objs) do
    if itemData.extraData.roleId == data.roleId then
      index = i
      if itemData == self.curSeleteItem then
        self.curSeleteItem = nil
      end
      break
    end
  end
  if index then
    self.listView:removeItem(index)
  end
  local key = ed.chatUtil:getUserKey(data.roleId)
  if ed.chatNetDataMrg.contactData.friend.data[key] then
    ed.chatNetDataMrg.contactData.friend.data[key] = nil
    ed.chatNetDataMrg.contactData.friend.num = ed.chatNetDataMrg.contactData.friend.num - 1
  end
  self:refreshOnlineLable()
end

function chatFriendList:clearAllFriendItem()
  self.listView:clear()
end

function chatFriendList:addContact(data)
  local objs = self.listView:getALLListData() or {}
  local item, info
  for _, itemData in ipairs(objs) do
    if itemData.extraData.uid == data.uid and itemData.extraData.sid == data.sid then
      item = itemData
      info = data
      break
    end
  end
  if item then
    local ui = item.controllers
    ui.lable_name:setString(data.summary._name)
    if item.extraData.isOnline ~= data.isOnline then
      item.extraData.isOnline = data.isOnline
      ui.headIcon:removeFromParentAndCleanup(true)
      self:createHeadIcon(ui, item.extraData)
    end
  else
    self:createItemUI(data)
  end
  self:refreshOnlineLable()
end

function chatFriendList:reset()
  if self.curSeleteItem then
    if not tolua.isnull(self.curSeleteItem.controllers.select_bg) then
      self.curSeleteItem.controllers.select_bg:setVisible(false)
    end
    self.curSeleteItem = nil
  end
end

function chatFriendList:checkIsHasItem()
  if #self.listView:getALLListData() > 0 then
    self.ui.lable_tip_3:setVisible(false)
  else
    self.ui.lable_tip_3:setVisible(true)
  end
end

function chatFriendList:refreshOnlineLable()
  local total_num = #self.listView:getALLListData()
  local online_num = 0
  local objs = self.listView:getALLListData() or {}
  for _, itemData in ipairs(objs) do
    if itemData.extraData.isOnline == 1 then
      online_num = online_num + 1
    end
  end
  self.ui.lable_friend_num:setString(T("%d/%d", online_num, total_num))
end

local chatContactList = {}
ed.ui.chatContactList = chatContactList
chatContactList.__index = chatContactList

function chatContactList:create(params, friendMrg)
  local self = {}
  setmetatable(self, chatContactList)
  self.parentLogic = params.parentLogic
  self.friendMrg = friendMrg
  self.ui = self.parentLogic.ui
  self.fristOpen = true
  self:init()
  return self
end

function chatContactList:init()
  self:createListView()
end

function chatContactList:createListView()
  local w, h = self.ui.mostRecentContact_list_layer:getContentSize().width, self.ui.mostRecentContact_list_layer:getContentSize().height
  self.listView = ed.ui.chatListView.new()
  self.listView:setPanelLayer(self.ui.mostRecentContact_list_layer)
  self.listView:initParem({
    base = {
      colNum = 1,
      itemWidthInner = 3,
      layoutMode = "up",
      maxItem = 50,
      heightInner = 3,
      initHeight = 0,
      initWidth = 0,
      container = self.ui.mostRecentContact_list_layer,
      cliprect = CCRectMake(1, 1, w, h),
      noshade = true,
      zorder = 1,
      selfDealMessage = true
    }
  })
end

function chatContactList:initContactItem()
  self.curSeleteItem = nil
  ed.curPrivateTarget = nil
  self.listView:clear()
  local num = ed.chatNetDataMrg.contactData.contact.num
  if num <= 0 then
    self.ui.lable_tip_2:setVisible(true)
    return
  else
    self.ui.lable_tip_2:setVisible(false)
  end
  local data = ed.chatNetDataMrg.contactData.contact.data
  for k, info in pairs(data) do
    self:createItemUI(info)
  end
end

function chatContactList:removeInvalidItem()
  local del_items = {}
  local objs = self.listView:getALLListData() or {}
  for _, itemData in ipairs(objs) do
    local key = ed.chatUtil:getUserKey(itemData.extraData.roleId)
    if not ed.chatNetDataMrg.contactData.contact.data[key] then
      table.insert(del_items, itemData.extraData)
    end
  end
  return del_items
end

function chatContactList:refreshContactData()
  local num = ed.chatNetDataMrg.contactData.contact.num
  local childnum = #self.listView:getALLListData()
  if num <= 0 and childnum <= 0 then
    self.ui.lable_tip_2:setVisible(true)
    return
  else
    self.ui.lable_tip_2:setVisible(false)
  end
  if num <= 0 then
    return
  end
  local data = ed.chatNetDataMrg.contactData.contact.data
  for k, info in pairs(data) do
    self:addContact(info, true)
  end
  if self.fristOpen then
    self.fristOpen = false
    
    local function fun(a, b)
      local a_data = a.extraData
      local b_data = b.extraData
      local a_key = ed.chatUtil:getUserKey(a_data.roleId)
      local b_key = ed.chatUtil:getUserKey(b_data.roleId)
      local a_newMsg_num = ed.chatNetDataMrg.personalNotify[a_key] or 0
      local b_newMsg_num = ed.chatNetDataMrg.personalNotify[b_key] or 0
      local a_times = a_data.last_time or 0
      local b_times = b_data.last_time or 0
      if a_newMsg_num < b_newMsg_num then
        return true
      elseif a_newMsg_num == b_newMsg_num and a_times < b_times then
        return true
      end
      return false
    end
    
    self.listView:sortFormFun(fun)
  end
  local del_items = self:removeInvalidItem()
  if ed.chatNetDataMrg.isContactHasUpdate then
    if del_items and 0 < #del_items then
      FireEvent("update_contact_event", del_items)
    end
    ed.chatNetDataMrg.isContactHasUpdate = false
  end
end

function chatContactList:refreshContactState()
  local function fun(a, b)
    local a_data = a.extraData
    
    local b_data = b.extraData
    local a_key = ed.chatUtil:getUserKey(a_data.roleId)
    local b_key = ed.chatUtil:getUserKey(b_data.roleId)
    local a_newMsg_num = ed.chatNetDataMrg.personalNotify[a_key] or 0
    local b_newMsg_num = ed.chatNetDataMrg.personalNotify[b_key] or 0
    local a_times = a_data.last_time or 0
    local b_times = b_data.last_time or 0
    if a_newMsg_num < b_newMsg_num then
      return true
    end
    return false
  end
  
  self.listView:sortFormFun(fun)
end

function chatContactList:createItemUI(data)
  local sp = CCSprite:create()
  local ui = {}
  ed.editorui(ed.uieditor.chatPlayerHeadItem, {container = sp, ui = ui})
  local extraData = data
  local width, height = ui.head_bg:getContentSize().width, ui.head_bg:getContentSize().height
  local params = {width = width, height = height}
  self:createHeadIcon(ui, data)
  self.listView:addItem(sp, extraData, params, ui)
  self.ui.lable_tip_2:setVisible(false)
end

function chatContactList:createHeadIcon(ui, data)
  local speakerSummary = data.summary
  local param = {
    id = speakerSummary._avatar
  }
  local headIcon = ed.getWholeHeadIcon(param)
  headIcon:setScale(0.5)
  headIcon:setPosition(ccp(22, 23.5))
  ui.headIcon = headIcon
  ui.head_bg:addChild(headIcon, 10)
  ui.lable_name:setString(speakerSummary._name)
  self:checkRedPoint(ui, data)
end

function chatContactList:setHeadOnlineState(ui, onlineState)
  local headIcon = ui.headIcon
  if onlineState == 1 then
    ed.chatUtil:resetAllNodeStone(headIcon)
  else
    ed.chatUtil:setAllNodeStone(headIcon)
  end
end

function chatContactList:checkRedPoint(ui, data)
  local key = ed.chatUtil:getUserKey(data.roleId)
  if ed.chatNetDataMrg.personalNotify[key] and ed.chatNetDataMrg.personalNotify[key] > 0 then
    local num = ed.chatNetDataMrg.personalNotify[key]
    ui.redPoint:setVisible(true)
    ui.msg_num:setString(tostring(num))
  else
    ui.redPoint:setVisible(false)
  end
end

function chatContactList:addContact(data, isNoStickTop)
  local objs = self.listView:getALLListData() or {}
  local item, info
  for _, itemData in ipairs(objs) do
    if itemData.extraData.uid == data.uid and itemData.extraData.sid == data.sid then
      itemData.extraData = data
      item = itemData
      info = data
      break
    end
  end
  if self.friendMrg.curMode == "friend" then
    self.friendMrg:refreshRedPoint()
  end
  if item then
    local ui = item.controllers
    ui.lable_name:setString(info.summary._name)
    if not ed.curPrivateTarget or item.extraData.roleId ~= ed.curPrivateTarget.roleId then
      self:checkRedPoint(ui, item.extraData)
    else
      local key = ed.chatUtil:getUserKey(ed.curPrivateTarget.roleId)
      ed.chatNetDataMrg.personalNotify[key] = 0
    end
    if not isNoStickTop then
      self.listView:stickTopItem(item)
    end
  else
    self:createItemUI(data)
  end
  if self.friendMrg.curMode == "recent" then
    self.friendMrg:refreshRedPoint()
  end
end

function chatContactList:touch(event, x, y)
  if not self.ui.mostRecentContact_layer:isVisible() then
    return
  end
  self:touchDelMsg(event, x, y)
  if not ed.containsPoint(self.ui.mostRecentContact_list_layer, x, y) and (event == "began" or event == "moved") then
    return
  end
  xpcall(function()
    self.listView:touch(event, x, y)
    self:touchObjs(event, x, y)
  end, EDDebug)
end

function chatContactList:touchDelMsg(event, x, y)
  local btn = self.ui.btn_del_msg
  if event == "began" then
    if ed.containsPoint(btn, x, y) then
      isPress = true
      btn:setScale(0.95)
      result = true
    end
  elseif event == "ended" then
    if isPress and ed.containsPoint(btn, x, y) then
      self:openDelContactWin()
    end
    isPress = false
    btn:setScale(1)
  end
end

function chatContactList:openDelContactWin()
  local datas = self.listView:getALLListData()
  local params = {}
  for k, item in pairs(datas) do
    local data = item.extraData
    table.insert(params, 1, data)
  end
  if #params <= 0 then
    ed.showToast(T("\230\178\161\230\156\137\229\143\175\229\136\160\233\153\164\231\154\132\229\175\185\232\175\157"))
    return
  end
  ed.ui.delContactMsg.create(params)
end

function chatContactList:touchObjs(event, x, y)
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
    local ui = itemData.controllers
    local headIcon = itemData.controllers.head_bg
    if event == "began" then
      if ed.containsPoint(headIcon, x, y) then
        self.touchItemData = {data = itemData}
        if ed.containsPoint(self.touchItemData.data.controllers.head_click, x, y) then
          self.touchItemData.isCliclHead = true
        end
        return
      end
    elseif event == "ended" and self.touchItemData then
      local headIcon = self.touchItemData.data.controllers.head_bg
      if ed.containsPoint(headIcon, x, y) then
        if self.touchItemData.isCliclHead and ed.containsPoint(self.touchItemData.data.controllers.head_click, x, y) then
          local data = self.touchItemData.data.extraData
          ed.PlayerInfoNetwork:requestHomePage(data.roleId)
        else
          self:selectContactObj(self.touchItemData.data)
        end
      end
      self.touchItemData = nil
    end
  end
  if event == "ended" then
    self.touchItemData = nil
  end
end

function chatContactList:selectContactObj(itemData)
  if self.curSeleteItem and not tolua.isnull(self.curSeleteItem.controllers.select_bg) then
    self.curSeleteItem.controllers.select_bg:setVisible(false)
  end
  self.curSeleteItem = itemData
  self.curSeleteItem.controllers.select_bg:setVisible(true)
  self.curSeleteItem.controllers.redPoint:setVisible(false)
  ed.curPrivateTarget = self.curSeleteItem.extraData
  local key = ed.chatUtil:getUserKey(ed.curPrivateTarget.roleId)
  ed.chatNetDataMrg.personalNotify[key] = 0
  self.friendMrg:refreshRedPoint()
  self.parentLogic:selectParivteObj()
end

function chatContactList:reset()
  if self.curSeleteItem then
    local bg = self.curSeleteItem.controllers.select_bg
    if bg and not tolua.isnull(bg) then
      bg:setVisible(false)
    end
  end
  self.curSeleteItem = nil
end

function chatContactList:checkIsHasItem()
  if #self.listView:getALLListData() > 0 then
    self.ui.lable_tip_2:setVisible(false)
  else
    self.ui.lable_tip_2:setVisible(true)
  end
end

function chatContactList:chooseObjFromContact(roleId)
  local objs = self.listView:getALLListData() or {}
  for _, itemData in ipairs(objs) do
    if itemData.extraData.roleId == roleId then
      self:selectContactObj(itemData)
      local itemNode = itemData.itemNode
      self:showItemInVertical(itemNode, itemData.params.height)
      return
    end
  end
end

function chatContactList:showItemInVertical(itemNode, height)
  local _, posY = itemNode:getPosition()
  self.listView.dragList:showItemInVertical(itemNode, height)
  self.listView.dragList:listEaseBackOut(0, 0)
end

function chatContactList:delContact(data)
  for _, v in ipairs(data) do
    local index
    local objs = self.listView:getALLListData()
    for i, obj in ipairs(objs) do
      if obj.extraData.uid == v.uid and obj.extraData.sid == v.sid then
        index = i
        if self.curSeleteItem and self.curSeleteItem.extraData.roleId == v.roleId then
          self.curSeleteItem = nil
          ed.curPrivateTarget = nil
        end
        local key = ed.chatUtil:getUserKey(v.roleId)
        if ed.chatNetDataMrg.contactData.contact.data[key] then
          ed.chatNetDataMrg.contactData.contact.num = ed.chatNetDataMrg.contactData.contact.num - 1
          ed.chatNetDataMrg.contactData.contact.data[key] = nil
        end
        break
      end
    end
    if index then
      self.listView:removeItem(index, true)
    end
  end
  local childnum = #self.listView:getALLListData()
  if childnum <= 0 then
    self.ui.lable_tip_2:setVisible(true)
    return
  else
    self.ui.lable_tip_2:setVisible(false)
  end
end

function pu()
  print(string.format("uid:%s sid:%s", ed.getUserid(), game_server_id))
end

function af(uid, sid)
  ed.ui.chat.sendAddFriendLink(tonumber(uid), tonumber(sid))
end
