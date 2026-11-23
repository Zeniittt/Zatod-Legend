module("genericNetwork", package.seeall)
connectionManager = {}
connectionManager.connections = {}

function connectionManager:init()
  self.connections = {}
  for mode, _ in pairs(csprotoConfig) do
    self.connections[mode] = socketConnection:new(mode)
  end
end

function connectionManager:update(dt)
  for _, connection in pairs(self.connections) do
    connection:update(dt)
  end
end

function connectionManager:getConnection(mode)
  return self.connections[mode]
end
