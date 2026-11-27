local PetModel = {}
PetModel.__index = PetModel
EGG_HATCH_STATUS = {
  EMPTY = 1,
  INPROGRESS = 2,
  FINISHED = 3
}

function PetModel.create()
  local model = {}
  setmetatable(model, PetModel)
  return model
end

function PetModel:initOpenPanelData(data)
  self:initHatchEggData(data)
  self.canOpenDecomp = data._is_decompose_open or false
end

function PetModel:getCanOpenDecomp()
  return self.canOpenDecomp
end

function PetModel:initHatchEggData(data)
  self.hatchEggData = {}
  if data._hatching_egg then
    for i, hatchingEggInfo in ipairs(data._hatching_egg) do
      local index = hatchingEggInfo._index
      self.hatchEggData[index] = {
        index = index,
        startTime = hatchingEggInfo._start_time,
        endTime = hatchingEggInfo._end_time,
        eggId = hatchingEggInfo._egg_id
      }
    end
  end
end

function PetModel:getHatchEggData()
  return self.hatchEggData
end

function PetModel:refreshHatchEggData(data)
  if data._index then
    self.hatchEggData[data._index] = {
      index = data._index,
      startTime = data._start_time,
      eggId = data._egg_id,
      endTime = data._end_time
    }
  end
end

function PetModel:finishHatchEgg(info)
  local index = info.index
  local type = info.type
  if self.hatchEggData[index] == nil then
    EDLog("ERROR: index %d hatchEggData is nil", index)
    return
  end
  if type == "diamond" then
    local perMinCost = self:getPetEggList()[self:getEggId(index)]["Diamond Per Min"]
    local data = self.hatchEggData[index]
    data.endTime = data.endTime - info.consume_items._amount / perMinCost * 60
  elseif type == "item" then
    local perAccTime = ed.getDataTable("PetHatchAccelerate")[info.consume_items._id]["Accelerate Min"] * 60
    local data = self.hatchEggData[index]
    data.endTime = data.endTime - info.consume_items._amount * perAccTime
  end
end

function PetModel:setHatchEggDataNull(index)
  self.hatchEggData[index] = nil
end

function PetModel:getEggId(index)
  if self.hatchEggData[index] then
    return self.hatchEggData[index].eggId
  end
  return nil
end

function PetModel:getTimeStr(index)
  if self.hatchEggData[index] == nil then
    return ""
  end
  local str = ed.gethmsNString(self:getTimeLeft(index))
  return str
end

function PetModel:getTimeLeft(index)
  if self.hatchEggData[index] == nil then
    return 0
  end
  local leftTime = self.hatchEggData[index].endTime - ed.getServerTime()
  if leftTime < 0 then
    leftTime = 0
  end
  return leftTime
end

function PetModel:getEggHatchTotalTime(eggId)
  local totalTime = ed.lookupDataTable("PetEgg", "Hatch Time", eggId)
  return totalTime * 3600
end

function PetModel:getAccelerateHatchCost(index)
  local leftTime = self:getTimeLeft(index)
  local eggId = self.hatchEggData[index].eggId
  local perMinCost = self:getPetEggList()[eggId]["Diamond Per Min"]
  return perMinCost * math.ceil(leftTime / 60)
end

function PetModel:isEggFinished(index)
  if self.hatchEggData[index] == nil then
    return false
  else
    return self:getTimeLeft(index) <= 0
  end
end

function PetModel:isEggCanOpen()
  for index, _ in pairs(self.hatchEggData) do
    if self:isEggFinished(index) then
      return true
    end
  end
  return false
end

function PetModel:isEggInHatching(index)
  if self.hatchEggData[index] == nil then
    return false
  else
    return self:getTimeLeft(index) > 0
  end
end

function PetModel:checkEggStatus()
  local petEggList = self:getPetEggList()
  for id in pairs(petEggList) do
    local amount = ed.player.equip_qunty[id] or 0
    if 0 < amount then
      return true
    end
  end
  return false
end

function PetModel:getPetEggList()
  if self.petEggList == nil then
    self.petEggList = {}
    self.petEggTbl = ed.getDataTable("PetEgg")
    if self.petEggTbl then
      for id, tblData in pairs(self.petEggTbl) do
        if id ~= "name" and self.petEggList[id] == nil then
          self.petEggList[id] = tblData
        end
      end
    end
  end
  return self.petEggList
end

function PetModel:getEggName(index)
  local eggId = self.hatchEggData[index].eggId
  local eggName = ed.readequip.value(eggId, "Name")
  return eggName
end

function PetModel:getEggFca(index)
  local eggId = self:getEggId(index)
  if eggId then
    return ed.lookupDataTable("PetEgg", "Egg Model", eggId)
  else
    return nil
  end
end

function PetModel:getEggFcaDuration(index)
  local eggId = self:getEggId(index)
  if eggId then
    return ed.lookupDataTable("PetEgg", "Hatch Anim Time", eggId)
  else
    return nil
  end
end

function PetModel:getComposeCD(eggId)
  local toCD = 0
  if self.composeData[eggId] then
    toCD = self.composeData[eggId]
  end
  local now = ed.getServerTime()
  local cd = toCD - now
  return cd
end

function PetModel:setComposeCD(eggId, cd)
  local now = ed.getServerTime()
  self.composeData[eggId] = cd + now
end

ed.PetModel = PetModel.create()
