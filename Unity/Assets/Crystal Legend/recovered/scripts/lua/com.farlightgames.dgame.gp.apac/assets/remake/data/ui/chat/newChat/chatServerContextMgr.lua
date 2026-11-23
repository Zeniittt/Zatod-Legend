local chatServerContextMrg = {}
ed.ui.chatServerContextMrg = chatServerContextMrg
chatServerContextMrg.__index = chatServerContextMrg

function chatServerContextMrg.new(params)
  local self = {}
  setmetatable(self, chatServerContextMrg)
  self.params = params
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.eventSpace = {}
  self.selectContextView = nil
  self.chatContextViewList = {}
  self:init()
  return self
end

function chatServerContextMrg:init()
end

function chatServerContextMrg:setHide(bool)
  if self.selectContextView then
    self.selectContextView:setHide(bool)
    if self.autoText then
      self.autoText.node:setVisible(false)
    end
  elseif self.autoText then
    self.autoText.node:setVisible(not bool)
  end
  if bool then
    self:stopRefreshMessage()
  else
    self:startRefreshMessage()
  end
end

function chatServerContextMrg:startRefreshMessage()
  ListenTimer(Timer:Always(0.02), self:refreshMessage(), self.eventSpace)
end

function chatServerContextMrg:stopRefreshMessage()
  if self.eventSpace then
    CloseScope(self.eventSpace)
  end
end

function chatServerContextMrg:touch(event, x, y)
  if not self.selectContextView then
    return
  end
  xpcall(function()
    self.selectContextView:touch(event, x, y)
  end, EDDebug)
end

function chatServerContextMrg:refreshMessage()
  local function handler()
    xpcall(function()
      if not ed.curChatServerTarget then
        return
      end
      local chatMessages = ed.chatNetDataMrg.chatServerData[ed.curChatServerTarget.id] or {}
      if not chatMessages.msg or #chatMessages.msg < 1 then
        return
      end
      for i = 1, 5 do
        if chatMessages.msg[1] then
          self:addChatItem(chatMessages.msg[1])
          table.remove(chatMessages.msg, 1)
        end
      end
    end, EDDebug)
  end
  
  return handler
end

function chatServerContextMrg:addChatItem(data)
  if self.selectContextView then
    self.selectContextView:addChatItem(data)
  end
end

function chatServerContextMrg:setCurSelectTarget()
  if not ed.curChatServerTarget then
    self:reset()
    return
  end
  local key = ed.curChatServerTarget.id
  if not self.chatContextViewList[key] then
    self.chatContextViewList[key] = ed.ui.chatServerContext.new({
      parentLogic = self.parentLogic
    })
  end
  if self.selectContextView then
    self.selectContextView:setHide(true, true)
    self.selectContextView = nil
  end
  self.selectContextView = self.chatContextViewList[key]
  self.selectContextView:setHide(false, true)
  if self.autoText then
    self.autoText.node:setVisible(false)
  end
end

function chatServerContextMrg:reset()
  if not self.autoText then
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
