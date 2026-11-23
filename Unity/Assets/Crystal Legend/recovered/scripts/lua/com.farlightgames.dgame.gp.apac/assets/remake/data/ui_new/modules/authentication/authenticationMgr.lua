local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = setmetatable({}, class)
  self:init()
  return self
end

function class:init()
end

function class:handleOpenPanel(msg)
  self.isAuthorized = msg._reward_flag and msg._reward_flag == 1
  if self.isAuthorized then
    ed.ui.authenticationConfirmPop.create({
      status = "authentication",
      serverInfo = msg._selected_server,
      playerId = msg._target_user_id,
      playerName = msg._nickname
    }):popWindow()
    return
  end
  self.lastServer = msg._selected_server
  self.lastId = msg._target_user_id
  self.lastZone = msg._selected_zone
  self.nextSendCodeTime = msg._next_code_time or 0
  ed.ui.authenticationMainPop.create():popWindow()
end

ed.authenticationMgr = class.getInstance()
