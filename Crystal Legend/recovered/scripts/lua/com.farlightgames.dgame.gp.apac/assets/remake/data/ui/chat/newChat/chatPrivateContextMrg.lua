local chatPrivateContextMrg = {}
ed.ui.chatPrivateContextMrg = chatPrivateContextMrg
chatPrivateContextMrg.__index = chatPrivateContextMrg

function chatPrivateContextMrg.new(params)
  local self = {}
  setmetatable(self, chatPrivateContextMrg)
  self.params = params
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.eventSpace = {}
  self.selectContextView = nil
  self.chatContextViewList = {}
  self.curChannel = "personal_channel"
  self:init()
  return self
end

function chatPrivateContextMrg:init()
  self.ui.lable_msg_tip:setVisible(false)
end

function chatPrivateContextMrg:setHide(bool)
  if self.selectContextView then
    self.selectContextView:setHide(bool)
    self.ui.lable_msg_tip:setVisible(false)
  else
    self.ui.lable_msg_tip:setVisible(not bool)
  end
  if bool then
    self:stopRefreshMessage()
  else
    self:startRefreshMessage()
  end
end

function chatPrivateContextMrg:startRefreshMessage()
  ListenTimer(Timer:Always(0.02), self:refreshMessage(), self.eventSpace)
end

function chatPrivateContextMrg:stopRefreshMessage()
  if self.eventSpace then
    CloseScope(self.eventSpace)
  end
end

function chatPrivateContextMrg:touch(event, x, y)
  if not self.selectContextView then
    return
  end
  xpcall(function()
    self.selectContextView:touch(event, x, y)
  end, EDDebug)
end

function chatPrivateContextMrg:refreshMessage()
  local function handler()
    xpcall(function()
      if not ed.curPrivateTarget then
        return
      end
      local key = ed.chatUtil:getUserKey(ed.curPrivateTarget.roleId)
      local chatMessages = ed.chatNetDataMrg.chatMessages.personal_channel[key] or {}
      for i = 1, 5 do
        if chatMessages[1] then
          self:addChatItem(chatMessages[1])
          table.remove(chatMessages, 1)
        end
      end
    end, EDDebug)
  end
  
  return handler
end

function chatPrivateContextMrg:addChatItem(data)
  if self.selectContextView then
    self.selectContextView:addChatItem(data)
  end
end

function chatPrivateContextMrg:addNewFriendTip(data)
  local roleId = data.roleId
  local key = ed.chatUtil:getUserKey(roleId)
  if not self.chatContextViewList[key] then
    self.chatContextViewList[key] = ed.ui.chatContext.new({
      parentLogic = self.parentLogic
    })
    self.chatContextViewList[key]:setChannel("personal_channel")
    self.chatContextViewList[key]:setHide(true, true)
  end
  local contextView = self.chatContextViewList[key]
  contextView:addNewFriendItem()
end

function chatPrivateContextMrg:setCurSelectTarget()
  if not ed.curPrivateTarget then
    self:reset()
    return
  end
  local key = ed.chatUtil:getUserKey(ed.curPrivateTarget.roleId)
  if not self.chatContextViewList[key] then
    self.chatContextViewList[key] = ed.ui.chatContext.new({
      parentLogic = self.parentLogic
    })
    self.chatContextViewList[key]:setChannel("personal_channel")
  end
  if self.selectContextView then
    self.selectContextView:setHide(true, true)
    self.selectContextView = nil
  end
  self.selectContextView = self.chatContextViewList[key]
  self.selectContextView:setHide(false, true)
  self.ui.lable_msg_tip:setVisible(false)
  ed.chatNetDataMrg:anonRefresh()
end

function chatPrivateContextMrg:reset()
  self.ui.lable_msg_tip:setVisible(true)
  if self.selectContextView then
    self.selectContextView:setHide(true, true)
    self.selectContextView = nil
  end
end

function chatPrivateContextMrg:delContact(data)
  for _, v in ipairs(data) do
    local key = ed.chatUtil:getUserKey(v.roleId)
    if self.chatContextViewList[key] then
      local view = self.chatContextViewList[key]
      if self.selectContextView == view then
        self.selectContextView = nil
      end
      view:onDestory()
      self.chatContextViewList[key] = nil
    end
  end
  if not self.selectContextView then
    self.ui.lable_msg_tip:setVisible(true)
    return true
  end
  return false
end
