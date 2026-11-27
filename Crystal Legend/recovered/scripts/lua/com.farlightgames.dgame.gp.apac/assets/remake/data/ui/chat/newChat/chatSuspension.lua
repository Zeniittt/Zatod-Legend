local chatSuspension = {}
chatSuspension.__index = chatSuspension
ed.ui.chatSuspension = chatSuspension
local _instance

function chatSuspension.getInstance()
  if not _instance then
    _instance = ed.ui.chatSuspension.create()
  end
  return _instance
end

function chatSuspension.create()
  local self = {}
  setmetatable(self, chatSuspension)
  return self
end

function chatSuspension:init(ui)
  self.ui = ui
end

function chatSuspension:setEnabled(bool)
  if self._enabled == bool then
    return
  end
  self._enabled = bool
  if self.ui then
    self.ui.img_suspension_box:setVisible(self._enabled)
  end
  if not self._enabled then
    self._msg_num = 0
    self:resfreshShowText()
  end
end

function chatSuspension:setObserved(chatContext)
  self._chatContext = chatContext
  self:setEnabled(false)
end

function chatSuspension:getObserved()
  return self._chatContext
end

function chatSuspension:touchEvent(event, x, y)
  if not self._enabled then
    return
  end
  if event == "began" then
    if ed.containsPoint(self.ui.img_suspension_box, x, y) then
      self.ui.img_suspension_box:setScale(0.98)
      self.isPress = true
    end
  elseif event == "ended" then
    if self.isPress and ed.containsPoint(self.ui.img_suspension_box, x, y) then
      self:goMsgFront()
      self:setEnabled(false)
    end
    self.ui.img_suspension_box:setScale(1)
    self.isPress = false
  end
  return true
end

function chatSuspension:resfreshShowText()
  if self.ui then
    self._msg_num = self._msg_num or 0
    self.ui.label_cur_msg_count:setString(tostring(self._msg_num))
  end
end

function chatSuspension:addNewMsg()
  if self.isNotRangeDistance then
    self._msg_num = self._msg_num + 1
    self:resfreshShowText()
    self:setEnabled(true)
  end
end

function chatSuspension:checkRangeDistance()
  if self._chatContext then
    local x, y = self._chatContext:getListPos()
    if 100 < y then
      self.isNotRangeDistance = true
    else
      self.isNotRangeDistance = false
      self:setEnabled(false)
    end
  end
end

function chatSuspension:goMsgFront()
  if self._chatContext then
    self._chatContext:setListPos(ccp(0, 0))
  end
end
