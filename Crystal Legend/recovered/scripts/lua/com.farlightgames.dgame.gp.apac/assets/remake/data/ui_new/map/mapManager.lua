local CellNode = newclass()

function CellNode.create()
  local self = {
    typeIndex = 1,
    tiles = {
      {1, 1}
    },
    isRotate = false,
    uuid = 1
  }
  setmetatable(self, CellNode.mt)
  return self
end

local class = {}
class.__index = class
local instance

function class.getInstance()
  if not instance then
    instance = class.create()
  end
  return instance
end

function class:init()
  self.cellData = {}
  self.buildingMap = {}
end

function class:initMap()
  local row, col = 100, 100
  for i = 1, row do
    self.cellData[i] = {}
    for j = 1, row do
      self.cellData[i][j] = nil
    end
  end
end

function class:getBuildingByIndex(i)
end

function class:getBuildingByUUID(uuid)
end

function class:setMapFlag(uuid, positon)
end

function class:addBuilding(uuid, positon)
end

function class:checkBuilding(typeIndex, positon)
end

function class:removeBuilding(uuid, positon)
end

function class:moveBuilding(uuid, rawPositon, position)
end

function class:initFromServer(netData)
  self.netData = netData
  for k, buildProto in ipairs(netData or {}) do
    local buildingModel = self:getBuildingByIndex(buildProto._type_index)
    buildingModel.uuid = buildProto._uuid
    self.buildingMap[buildProto._uuid] = buildingModel
    self:addBuilding(buildProto._uuid, buildProto._position)
  end
end

function class.create()
  local self = {}
  setmetatable(self, class)
  self:init()
  return self
end

ed.MapManager = class.getInstance()
return class
