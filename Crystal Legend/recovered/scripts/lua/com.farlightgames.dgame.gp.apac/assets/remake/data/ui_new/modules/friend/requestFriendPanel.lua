local requestFriendPanel = {}
ed.ui.requestFriendPanel = requestFriendPanel
requestFriendPanel.isRequestFriend = false

function requestFriendPanel.create(controller, param)
  local self = {}
  setmetatable(self, {__index = requestFriendPanel})
  self:init(controller, param)
  return self
end

function requestFriendPanel:init(controller, param)
  self.controller = controller
  self:initView()
  self:addEventListener()
  self:reqRequestFriendList()
end

function requestFriendPanel:initView()
  local container, ui = ed.editorui(ed.uieditor.requestFriendPanel)
  self.container = container
  self.ui = ui
  self.container:setContentSize(self.ui.bg:getContentSize())
  ed.setLabelStroke(self.ui.title, ed.toccc3(2298891), 1)
  self.playerDragList = ed.UITool.createDraglist(self.ui.playerList, nil, self.controller)
  self.controller.refreshCliprectConfig = {
    draglist = self.playerDragList
  }
end

function requestFriendPanel:refreshDragList()
  self.playerDataList = {}
  for index, chatContactUser in ipairs(ed.chatNetDataMrg.applyFriendList or {}) do
    table.insert(self.playerDataList, {chatContactUser = chatContactUser})
  end
  local posY = 0
  local gapY = 1
  local applyAmount = 0
  self.playerDragList:clearList()
  for index, playerData in ipairs(self.playerDataList) do
    local roleId = playerData.chatContactUser._role_id
    if not ed.friendlist.isInFriendlist(roleId) and ed.applyFriend.IsinApplyFriendList(roleId) then
      applyAmount = applyAmount + 1
      local playerItem = ed.ui.friendItem.create(self.controller, "addFriend", playerData)
      local container = playerItem.container
      local size = container:getContentSize()
      self.playerDragList:addItem(container)
      container:setPositionY(self.ui.playerList:getContentSize().height - posY - size.height)
      posY = posY + gapY + size.height
    end
  end
  self.playerDragList:initListHeight(posY)
  self.ui.noapply_tips:setVisible(applyAmount == 0)
end

function requestFriendPanel:reqRequestFriendList()
  requestFriendPanel.isRequestFriend = true
  ed.chatNetDataMrg:reqChatContact()
end

function requestFriendPanel:addEventListener()
  self.controller:listenEvent("refreshApplyFriend", function()
    self:refreshDragList()
  end)
  self.controller:listenEvent("add_friend_success", function(data)
    self:refreshDragList()
  end)
end
