local friendPanel = {}
ed.ui.friendPanel = friendPanel
local SELECT_TYPE_FRIEND = "friendChat"
local SELECT_TYPE_BLACKLIST = "blacklist"
local tabConfig = {
  {
    text = T("\229\165\189\229\143\139"),
    key = SELECT_TYPE_FRIEND,
    uiName = "btnFriendBg",
    uiSelect = "btnFriendSelect",
    uiLabel = "btnFriendLabel"
  },
  {
    text = T("\233\187\145\229\144\141\229\141\149"),
    key = SELECT_TYPE_BLACKLIST,
    uiName = "btnBlacklistBg",
    uiSelect = "btnBlacklistSelect",
    uiLabel = "btnBlacklistLabel"
  }
}

function friendPanel.create(controller, param)
  local self = {}
  setmetatable(self, {__index = friendPanel})
  param = param or {}
  self:init(controller, param)
  return self
end

function friendPanel:init(controller, param)
  self.controller = controller
  self.selectType = param.selectType or SELECT_TYPE_FRIEND
  self.friendsData = nil
  self.blacklistData = nil
  self:initView()
  self:addEventListener()
  self:getAllFriends()
  self:getAllBlacklist()
end

function friendPanel:initView()
  local container, ui = ed.editorui(ed.uieditor.friendPanel)
  self.container = container
  self.ui = ui
  self.container:setContentSize(self.ui.bg:getContentSize())
  ed.setLabelStroke(self.ui.btnFriendLabel, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.btnBlacklistLabel, ccc3(0, 0, 0), 1)
  self.ui.btnFriendLabel:limitWidthByScale(100)
  self.ui.btnBlacklistLabel:limitWidthByScale(100)
  self:setBtnSelect(self.selectType)
end

function friendPanel:refreshDragList()
  self.playerDataList = {}
  if self.selectType == SELECT_TYPE_FRIEND then
    self.playerDataList = self.friendsData or {}
  else
    for index, chatBlackUser in ipairs(ed.chatNetWork.blacklistuser or {}) do
      local chatContactUser = {
        _role_id = chatBlackUser._role_id,
        _user_summary = chatBlackUser._user_summary,
        _svr_id = chatBlackUser._svr_id
      }
      table.insert(self.playerDataList, {chatContactUser = chatContactUser})
    end
  end
  local delegate = {
    numberOfCells = function()
      return #self.playerDataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(552, 82.5)
    end,
    createCell = function(index)
      local playerData = self.playerDataList[index]
      local node = ed.ui.friendItem.create(self.controller, self.selectType, playerData)
      return node.container, {
        playerData = playerData,
        ui = node.ui
      }
    end
  }
  local size = self.ui.playerList:getContentSize()
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    container = self.ui.playerList,
    touchpriority = -300,
    zorder = 10,
    dragMode = 1,
    noshade = true,
    colNum = 1
  }
  if self.playerTBView then
    self.playerTBView:reloadData()
  else
    self.playerTBView = Tableview.create(param)
  end
  self.controller.refreshCliprectConfig = {
    draglist = self.playerTBView.dragList
  }
  if self.selectType == SELECT_TYPE_FRIEND and #self.playerDataList <= 0 then
    self.ui.nofriend_tips:setVisible(true)
  else
    self.ui.nofriend_tips:setVisible(false)
  end
end

function friendPanel:refreshFriendAmount()
  ed.setString(self.ui.friendAmount, string.format("%d/%d", #self.friendsData, ed.friendlist.MAX_FRIEND_AMOUNT))
end

function friendPanel:setBtnSelect(selectType)
  self.selectType = selectType
  for index, config in ipairs(tabConfig) do
    self.ui[config.uiSelect]:setVisible(config.key == selectType)
  end
  self.ui.friendAmountLabel:setVisible(self.selectType == SELECT_TYPE_FRIEND)
  self.ui.friendAmount:setVisible(self.selectType == SELECT_TYPE_FRIEND)
  self:refreshDragList()
end

function friendPanel:getAllFriends()
  function ed.netreply.getAllFriendsHandler(friendsData)
    friendsData = friendsData or {}
    
    table.sort(friendsData, function(a, b)
      if a._is_online > b._is_online then
        return true
      end
      return false
    end)
    self.friendsData = {}
    local friendRoleIdList = {}
    for index, chatContactUser in ipairs(friendsData) do
      table.insert(friendRoleIdList, {
        _role_id = chatContactUser._role_id
      })
      table.insert(self.friendsData, {chatContactUser = chatContactUser})
    end
    ed.friendlist.setFriendlistData(friendRoleIdList)
    self:refreshFriendAmount()
    if self.selectType == SELECT_TYPE_FRIEND then
      self:refreshDragList()
    end
  end
  
  ed.chatNetDataMrg:sendGetAllFriends()
end

function friendPanel:getAllBlacklist()
  ed.blacklist.getBlacklist()
end

function friendPanel:addEventListener()
  self.controller:btRegisterButtonClick({
    button = self.ui.btnFriendBg,
    press = self.ui.btnFriendBgPress,
    pressScale = 0.95,
    key = "friend",
    priority = -110,
    clickHandler = function()
      self:setBtnSelect(SELECT_TYPE_FRIEND)
    end
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.btnBlacklistBg,
    press = self.ui.btnBlacklistBgPress,
    pressScale = 0.95,
    key = "blacklist",
    clickHandler = function()
      self:setBtnSelect(SELECT_TYPE_BLACKLIST)
    end
  })
  self.controller:listenEvent("CHAT_INIT_BLACKLIST", function()
    if self.selectType == SELECT_TYPE_BLACKLIST then
      self:refreshDragList()
    end
  end)
  self.controller:listenEvent("CHAT_ADD_BLACKLIST", function()
    self:getAllBlacklist()
  end)
  self.controller:listenEvent("CHAT_DEL_BLACKLIST", function(index)
    ed.showToast(T("\230\136\144\229\138\159\229\176\134\232\175\165\231\142\169\229\174\182\228\187\142\233\187\145\229\144\141\229\141\149\228\184\173\231\167\187\233\153\164"))
    self:refreshDragList()
  end)
  self.controller:listenEvent("addFriend", function(roleId)
    self:getAllFriends()
  end)
  self.controller:listenEvent("deleteFriend", function(roleId)
    self:getAllFriends()
  end)
end
