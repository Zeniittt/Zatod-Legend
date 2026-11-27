local ipv6Manager = {}
ipv6Manager.__index = ipv6Manager
ed.ipv6Manager = ipv6Manager
ipv6Manager.open = socket.openIpv6 and true or false

function ipv6Manager.create()
  local self = {}
  setmetatable(self, ipv6Manager)
  return self
end

function ipv6Manager:openIpv6()
  socket.openIpv6(true)
end
