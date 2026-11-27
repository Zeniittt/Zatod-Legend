local PeakArenaRedDotTree = {EXTERN = "EXTERN"}
PeakArenaRedDotTree.__index = PeakArenaRedDotTree
ed.PeakArenaRedDotTreeKeys = {
  Season = "Season",
  MedalRewardNotify = "MedalRewardNotify",
  MedalTab = "MedalTab",
  Reward = "ButtonReward",
  ArenaBuilding = "ArenaBuilding",
  Counting = "Counting",
  Attack = "Attack",
  BanHero = "BanHero"
}

function PeakArenaRedDotTree.create()
  local self = {}
  setmetatable(self, PeakArenaRedDotTree)
  self:init()
  return self
end

function PeakArenaRedDotTree:init()
  local keys = ed.PeakArenaRedDotTreeKeys
  self.data = {
    [keys.ArenaBuilding] = {
      [keys.Season] = false,
      [keys.MedalRewardNotify] = false,
      [keys.Attack] = false,
      [keys.Counting] = false,
      [keys.Reward] = {
        [keys.MedalTab] = function()
          return false
        end
      },
      [keys.BanHero] = false
    }
  }
  self:checkNodesValid(self.data)
end

function PeakArenaRedDotTree:reset()
  self:init()
end

function PeakArenaRedDotTree:getMedalRewardValue()
  return ed.PeakArenaManager:canTakeMedalReward()
end

function PeakArenaRedDotTree:isValueType(data)
  return type(data) == "boolean" or type(data) == "function"
end

function PeakArenaRedDotTree:getValue(key, data, ...)
  if type(data) == "boolean" then
    return data
  elseif type(data) == "function" then
    local ret = data(key, ...)
    if ret then
      return true
    else
      return false
    end
  end
end

function PeakArenaRedDotTree:getFlag(key, ...)
  local nodes = self.data
  local data = self:getNodeByKey(key, nodes)
  if data == nil then
    print("cannot find the key: " .. key)
    return
  end
  local args = {}
  for i, v in ipairs({
    ...
  }) do
    table.insert(args, v)
  end
  if self:isValueType(data) then
    return self:getValue(key, data, unpack(args))
  end
  
  local function calNodesFlag(_nodes)
    local ret = false
    for k, v in pairs(_nodes) do
      local val
      if self:isValueType(v) then
        val = self:getValue(key, v, unpack(args))
      else
        val = calNodesFlag(v)
      end
      ret = ret or val
    end
    return ret
  end
  
  return calNodesFlag(data)
end

function PeakArenaRedDotTree:update(key, value, nodes)
  if not self:isValueType(value) then
    print(string.format("value: %s is invalid", value))
    return
  end
  nodes = nodes or self.data
  local bChanged = false
  for k, v in pairs(nodes) do
    if k == key and self:isValueType(v) then
      bChanged = bChanged or v ~= value
      nodes[k] = value
    end
    if type(v) == "table" then
      local bC = self:update(key, value, v)
      bChanged = bChanged or bC
    end
  end
  if nodes == self.data and bChanged then
    FireEvent("PeakArenaRedDotChanged")
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.PeakArena)
  end
  return bChanged
end

function PeakArenaRedDotTree:checkNodesValid(nodes)
  self:checkValuesType(nodes)
  self:checkRepeatOrAmbiguity(nodes)
  self:checkExternAndUnfold(nodes)
  self:checkCircularReference(nodes)
end

function PeakArenaRedDotTree:checkValuesType(nodes)
  for k, v in pairs(nodes) do
    if v == self.EXTERN or self:isValueType(v) then
    elseif type(v) == "table" then
      self:checkValuesType(v)
    else
      error("unknown value type of key: " .. k)
    end
  end
end

function PeakArenaRedDotTree:checkRepeatOrAmbiguity(nodes, map)
  map = map or {}
  for k, v in pairs(nodes) do
    if v ~= self.EXTERN then
      if map[k] ~= nil then
        if v ~= map[k] then
          error(string.format("the value of key: %s is ambiguous", k))
        end
      else
        map[k] = v
      end
      if type(v) == "table" then
        self:checkRepeatOrAmbiguity(v, map)
      end
    end
  end
end

function PeakArenaRedDotTree:checkExternAndUnfold(nodes, root)
  root = root or nodes
  for k, v in pairs(nodes) do
    if v == self.EXTERN then
      local ret = self:getNodeByKey(k, root)
      if ret == nil then
        error("cannot find the real node of extern: " .. k)
      end
      nodes[k] = ret
    elseif type(v) == "table" then
      self:checkExternAndUnfold(v, root)
    end
  end
end

function PeakArenaRedDotTree:checkCircularReference(nodes, map, nodesKey)
  local function newMap(mp)
    local ret = {}
    
    for k, v in pairs(mp or {}) do
      ret[k] = v
    end
    return ret
  end
  
  for k, v in pairs(nodes) do
    if map and map[v] then
      error(string.format("CircularReference of %s and %s", nodesKey, k))
    end
    if type(v) == "table" then
      local newMp = newMap(map)
      newMp[v] = k
      self:checkCircularReference(v, newMp, k)
    end
  end
end

function PeakArenaRedDotTree:getNodeByKey(key, nodes)
  nodes = nodes or self.data
  for k, v in pairs(nodes) do
    if v ~= self.EXTERN then
      if k == key then
        return v
      elseif type(v) == "table" then
        local ret = self:getNodeByKey(key, v)
        if ret ~= nil then
          return ret
        end
      end
    end
  end
end

ed.PeakArenaRedDotTree = PeakArenaRedDotTree.create()
