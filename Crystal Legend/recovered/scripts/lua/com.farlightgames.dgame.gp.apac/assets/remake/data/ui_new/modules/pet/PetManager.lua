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
  local object = {}
  setmetatable(object, class)
  object:initData()
  return object
end

function class:initData()
  self.nameColors = {
    ccc3(119, 255, 92),
    ccc3(22, 252, 254),
    ccc3(234, 92, 255),
    ccc3(254, 151, 69),
    ccc3(255, 34, 34)
  }
  self.markColors = {
    ccc3(205, 255, 210),
    ccc3(205, 254, 255),
    ccc3(255, 197, 247),
    ccc3(255, 248, 164),
    ccc3(255, 248, 164)
  }
  self.markStrokeColors = {
    ccc3(40, 80, 0),
    ccc3(23, 32, 146),
    ccc3(115, 0, 125),
    ccc3(146, 23, 23),
    ccc3(146, 23, 23)
  }
  self.specialMarkRes = {
    "UI/alpha/HVGA/pet/pet_color_portrait_badge_1_1.png",
    "UI/alpha/HVGA/pet/pet_color_portrait_badge_2_1.png",
    "UI/alpha/HVGA/pet/pet_color_portrait_badge_3_1.png",
    "UI/alpha/HVGA/pet/pet_color_portrait_badge_4_1.png",
    "UI/alpha/HVGA/pet/pet_color_portrait_badge_5_1.png"
  }
  self.petHeartsTable = ed.getDataTable("PetHearts")
  self.petTable = ed.getDataTable("Pet")
  self.redFlag = false
end

function class:setRedFlag(flag)
  self.redFlag = flag or false
  FireEvent("MainBuildRedTagChange", ed.ui.configs.mainSceneMap.builddingType.Pet)
end

function class:getRedFlag()
  return self.redFlag
end

function class:getCanEvolvePetsNum()
  local petsNum = 0
  local pets = ed.player:getPets()
  if pets then
    for _, pet in pairs(pets) do
      if not self:petIsMaxEvolve(pet) then
        petsNum = petsNum + 1
      end
    end
  end
  return petsNum
end

function class:petIsMaxEvolve(pet)
  local evolve = pet:getEvolve()
  local typeid = pet:getTypeId()
  local maxEvolve = class:getMaxEvolve(typeid)
  return evolve >= maxEvolve
end

function class:getNameColor(typeid)
  local color = self.petTable[typeid].Color
  return self.nameColors[color]
end

function class:getPetEvolveTime(typeid, evolve)
  local color = self.petTable[typeid].Color
  local petHeartsRow = self.petHeartsTable[color]
  local key = "Upgrade Time " .. evolve
  return petHeartsRow[key] * 60
end

function class:getPetMarkRes(typeid)
  local color = self.petTable[typeid].Color
  return ed.Pet.getTagResByTypeId(typeid)
end

function class:getSTRAddtion(typeid, evolve)
  local row = self.petTable[typeid]
  local STRAddtion = 0
  for i = 1, evolve do
    STRAddtion = STRAddtion + row["UP STR" .. i .. " Ratio"]
  end
  return STRAddtion
end

function class:getAGIAddtion(typeid, evolve)
  local row = self.petTable[typeid]
  local AGIAddtion = 0
  for i = 1, evolve do
    AGIAddtion = AGIAddtion + row["UP AGI" .. i .. " Ratio"]
  end
  return AGIAddtion
end

function class:getINTAddtion(typeid, evolve)
  local row = self.petTable[typeid]
  local INTAddtion = 0
  for i = 1, evolve do
    INTAddtion = INTAddtion + row["UP INT" .. i .. " Ratio"]
  end
  return INTAddtion
end

function class:getMaxEvolve(typeid)
  local maxEvolve = 0
  local row = self.petTable[typeid]
  for i = 1, 5 do
    if 0 < row["UP STR" .. i .. " Ratio"] then
      maxEvolve = maxEvolve + 1
    end
  end
  return maxEvolve
end

function class:getMarkColor(typeid)
  local color = self.petTable[typeid].Color
  return self.markColors[color]
end

function class:getMarkStrokeColor(typeid)
  local color = self.petTable[typeid].Color
  return self.markStrokeColors[color]
end

function class:createPetMark(typeid)
  local markRes = self:getPetMarkRes(typeid)
  if markRes then
    local imagePetMark = ed.createSprite(markRes)
    return imagePetMark
  end
end

function class:createPetMarkLabel(typeid, evolve)
  local fontInfo = {
    size = 17,
    color = self:getMarkColor(typeid),
    strokeColor = self:getMarkStrokeColor(typeid),
    strokeSize = 1.5
  }
  local evolveLabel = ed.createLabelTTF(tostring(evolve), fontInfo.size)
  ed.setLabelColor(evolveLabel, fontInfo.color)
  ed.setLabelStroke(evolveLabel, fontInfo.strokeColor, fontInfo.strokeSize)
  local labelPos = ccp(11.5, 14)
  local color = self.petTable[typeid].Color
  if color == 5 then
    labelPos.x = 17
  end
  evolveLabel:setAnchorPoint(ccp(0.5, 0.5))
  evolveLabel:setPosition(labelPos)
  return evolveLabel
end

function class:handleOpenPanel(msg)
  ed.PetModel:initOpenPanelData(msg)
  if self.mainScene then
    FireEvent("refreshPetEggTime")
  else
    self.mainScene = ed.ui.PetMainScene.create({
      eggs = ed.PetModel:getHatchEggData()
    })
    ed.pushScene(self.mainScene)
  end
end

function class:handleHatchEgg(data)
  if data._result == "success" and data._hatching_egg then
    ed.player:consumeEquip(data._hatching_egg._egg_id, 1)
    ed.PetModel:refreshHatchEggData(data._hatching_egg)
    FireEvent("refreshPetEggRoom", data._hatching_egg._index)
    FireEvent("PetStartHatchSuccess")
  else
    EDLog("ERROR: start hatch egg failed!!!")
  end
end

function class:handleAccHatchEgg(data)
  local cur_diamond = data._cur_diamond or 0
  local result = data._result
  if result == "success" then
    local hatchInfo = ed.PetNetwork.accelerateHatchInfo
    local type = hatchInfo.type
    if type == "diamond" then
      hatchInfo.consume_items._amount = ed.player:getDiamondAmount() - cur_diamond
      ed.player:setrmb(cur_diamond)
    elseif type == "item" then
      ed.player:consumeEquip(hatchInfo.consume_items._id, hatchInfo.consume_items._amount)
    end
    ed.PetModel:finishHatchEgg(hatchInfo)
    FireEvent("successAccelarateEgg")
    FireEvent("refreshPetEggRoom")
  else
    EDLog("ERROR: acceleate hatch failed!!!")
  end
end

function class:handleOpenEgg(data)
  local index = data._index
  local petInfo = data._pet
  if petInfo then
    ed.player:addPet(petInfo)
    FireEvent("onGetNewPet", {
      id = petInfo._id,
      index = index,
      color = ed.Pet.getColorByType(petInfo._type_id) - 1,
      isBest = data._is_record == 1
    })
  else
    EDLog("ERROR: open egg failed!!!")
  end
end

function class:handleEquipPet(data)
  if data._result == "success" then
    ed.player:getPet(data._pet._id):setup(data._pet)
    local hero = ed.player:getHero(data._hero_id)
    hero:equipPet(data._pet)
    local preGs = hero._gs
    if data._hero_gs then
      hero:resetgs(data._hero_gs)
    end
    FireEvent("PetEquipSuccess")
    FireEvent("HeroGsUpdate", preGs)
  end
end

function class:handleUnEquipPet(data)
  if data._result == "success" then
    if self.bUseItemForUnequip then
      ed.player:consumeEquip(self.bUseItemForUnequip, 1)
      self.bUseItemForUnequip = nil
    end
    ed.player:getPet(data._pet._id):setup(data._pet)
    local hero = ed.player:getHero(data._hero_id)
    hero:unequipPet()
    if data._hero_gs then
      hero:resetgs(data._hero_gs)
    end
    FireEvent("PetUnEquipSuccess")
  end
end

function class:handleLevelUp(data)
  if data._result == "success" then
    ed.player:getPet(data._pet._id):setup(data._pet)
    if data._hero_id then
      local hero = ed.player:getHero(data._hero_id)
      hero:rsyncPetData(data._pet)
      hero:resetgs(data._hero_gs)
    end
    FireEvent("petLevelupSuccess", data._pet)
  end
end

function class:handleLevelupSkill(data)
  if data._result == "success" then
    ed.player:getPet(data._pet._id):setup(data._pet)
    if data._hero_id then
      local hero = ed.player:getHero(data._hero_id)
      hero:rsyncPetData(data._pet)
      hero:resetgs(data._hero_gs)
    end
    FireEvent("petSkillLevelupSuccess")
  end
end

function class:handleDecomposePet(data)
  local reward = data._rewards or {}
  for i, v in ipairs(reward) do
    print("add ", v._type, " amount: ", v._amount)
    if v._type == "gold" then
      ed.player:addMoney(v._amount)
    elseif v._type == "blue_pet_point" then
      ed.player:addPoint(v._type, v._amount)
    elseif v._type == "purple_pet_point" then
      ed.player:addPoint(v._type, v._amount)
    elseif v._type == "item" then
      ed.player:addEquip(v._id, v._amount)
    end
  end
  local pets = ed.PetNetwork.decompPetIds
  for _, id in ipairs(pets) do
    ed.player:deletePet(id)
  end
  FireEvent("successDecomposePets", reward)
end

ed.PetManager = class.getInstance()
return class
