local addFriendPanel = {}
ed.ui.addFriendPanel = addFriendPanel
local reqRecommendCD = 5

function addFriendPanel.create(controller, param)
  local self = {}
  setmetatable(self, {__index = addFriendPanel})
  self:init(controller, param)
  return self
end

function addFriendPanel:init(controller, param)
  self.controller = controller
  self.tick = reqRecommendCD
  self.reqRecommendEnable = true
  self:initView()
  self:addEventListener()
  self:reqRecommendFriend()
end

function addFriendPanel:initView()
  local container, ui = ed.editorui(ed.uieditor.addFriendPanel)
  self.container = container
  self.ui = ui
  self.container:setContentSize(self.ui.bg:getContentSize())
  ed.setLabelStroke(self.ui.label_recommend, ed.toccc3(10432259), 1)
  local editBoxInfo = {
    config = {
      editSize = self.ui.findInput:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(255, 218, 150),
      fontSize = 16
    }
  }
  self.editBox = editBox:new(editBoxInfo)
  self.editBox:setPlaceHolder(T("\232\175\183\232\190\147\229\133\165\232\167\146\232\137\178\231\160\129\230\159\165\230\137\190\231\142\169\229\174\182"))
  self.editBox.edit:setFontColor(ed.toccc3(16767638))
  self.editBox.edit:setFont(ed.font, 16)
  self.ui.findInput:addChild(self.editBox.edit)
  ed.layout.centerInParent(self.editBox.edit)
  self.playerDragList = ed.UITool.createDraglist(self.ui.playerList, nil, self.controller)
  self.controller.refreshCliprectConfig = {
    draglist = self.playerDragList
  }
end

function addFriendPanel:refreshDragList()
  local posY = 0
  local gapY = 1
  self.playerDragList:clearList()
  for index, playerData in ipairs(self.playerDataList) do
    local playerItem = ed.ui.friendItem.create(self.controller, "applyFriend", playerData)
    local container = playerItem.container
    local size = container:getContentSize()
    self.playerDragList:addItem(container)
    container:setPositionY(self.ui.playerList:getContentSize().height - posY - size.height)
    posY = posY + gapY + size.height
  end
  self.playerDragList:initListHeight(posY)
end

function addFriendPanel:startCountDown()
  self.reqRecommendEnable = false
  self.ui.btnChangeEnable:setVisible(false)
  self.ui.btnChangeDisable:setVisible(true)
  self.ui.changeLabel:setString(T("\230\141\162\228\184\128\230\137\185%ss", self.tick))
  self.controller:listenTimer(Timer:Times(1, reqRecommendCD), function()
    self:refreshCountDown()
  end)
  self.ui.changeLabel:limitWidthByScale(60)
end

function addFriendPanel:refreshCountDown()
  self.tick = self.tick - 1
  if self.tick <= 0 then
    self.tick = reqRecommendCD
    self.reqRecommendEnable = true
    self.ui.btnChangeEnable:setVisible(true)
    self.ui.btnChangeDisable:setVisible(false)
    self.ui.changeLabel:setString(T("\230\141\162\228\184\128\230\137\185"))
  else
    self.ui.changeLabel:setString(T("\230\141\162\228\184\128\230\137\185%ss", self.tick))
  end
end

function addFriendPanel:searchFriendsHandler(chatContactUser)
  if not chatContactUser then
    ed.showToast(T("\230\156\170\230\137\190\229\136\176\231\148\168\230\136\183"))
    return
  end
  self.playerDataList = {}
  table.insert(self.playerDataList, {chatContactUser = chatContactUser})
  self:refreshDragList()
end

function addFriendPanel:recommendFriend()
  local playerDataList = {}
  local recommendFriendList = ed.chatNetDataMrg.recommendFriendList
  for index, chatContactUser in ipairs(recommendFriendList or {}) do
    local playerData = {}
    playerData.chatContactUser = chatContactUser
    table.insert(playerDataList, playerData)
  end
  self.playerDataList = playerDataList
  self:refreshDragList()
end

function addFriendPanel:reqRecommendFriend()
  self:startCountDown()
  local msg = ed.upmsg.chat()
  msg._recommend_friends = {}
  ed.send(msg, "chat")
end

function addFriendPanel:addEventListener()
  self.controller:btRegisterHandler({
    handler = function(event, x, y)
      if ed.containsPoint(self.editBox.edit, x, y) then
        self.editBox:touch(event, x, y)
      end
    end,
    key = "editBox"
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.btnFind,
    press = self.ui.btnFind_press,
    pressScale = 0.95,
    key = "btnFind",
    force = true,
    mcpMode = true,
    priority = -300,
    clickHandler = function()
      local roleId = self.editBox:getString()
      if not tonumber(roleId) then
        ed.showToast(T("\232\175\183\232\190\147\229\133\165\231\142\169\229\174\182\232\167\146\232\137\178\231\160\129"))
        return
      end
      if ed.friendlist.isInFriendlist(roleId) then
        ed.showToast(T("\229\175\185\230\150\185\229\183\178\231\187\143\230\152\175\228\189\160\231\154\132\229\165\189\229\143\139"))
        return
      end
      if roleId and roleId ~= "" then
        ed.chatNetDataMrg:sendSearchFriends(roleId)
      else
        ed.showToast(T("\232\175\183\232\190\147\229\133\165\231\142\169\229\174\182\232\167\146\232\137\178\231\160\129"))
      end
    end
  })
  self.controller:btRegisterButtonClick({
    button = self.ui.btnChangeBg,
    press = self.ui.btnChangeBg_press,
    pressScale = 0.95,
    priority = -999,
    key = "btnChangeBg",
    force = true,
    mcpMode = true,
    interval = 0.3,
    clickHandler = function()
      if self.reqRecommendEnable then
        self:reqRecommendFriend()
      end
    end
  })
  self.controller:listenEvent("SearchFriendsEvent", function(data)
    self:searchFriendsHandler(data)
  end)
  self.controller:listenEvent("refreshRecommendFriend", function()
    self:recommendFriend()
  end)
end
