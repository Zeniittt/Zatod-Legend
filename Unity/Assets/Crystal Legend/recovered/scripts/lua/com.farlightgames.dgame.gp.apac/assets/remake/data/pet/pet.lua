local Pet = {}
Pet.__index = Pet
ed.Pet = Pet
local maxEquipSlotNum = 6
local maxHeartNum = 5
if not ed.toccc3 then
  function ed.toccc3(hex)
    return ccc3(hex / 65536, hex / 256 % 256, hex % 256)
  end
end
local PetConfig = {
  [1] = {
    frame = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
    tag = "UI/alpha/1080P/pet/pet_tag_blue.png",
    namePrefix = T("\231\187\191\232\137\178\229\147\129\232\180\168"),
    nameColor = ed.toccc3(16776423),
    nameStrokeStartColor = ed.toccc3(1207709),
    nameStrokeEndColor = ed.toccc3(3487596),
    icon = "UI/alpha/1080P/pet/pet_icon_blue.png",
    count = "UI/alpha/1080P/pet/pet_count_blue.png",
    light = "UI/alpha/1080P/pet/incubate/pet_house_get_blue_effect.png",
    nameBgRes = "UI/alpha/1080P/pet/incubate/pet_house_get_blue_bg.png"
  },
  [2] = {
    frame = "UI/alpha/1080P/common/frame/hero_icon_frame_4.png",
    tag = "UI/alpha/1080P/pet/pet_tag_blue.png",
    namePrefix = T("\232\147\157\232\137\178\229\147\129\232\180\168"),
    nameColor = ed.toccc3(16776423),
    nameStrokeStartColor = ed.toccc3(1207709),
    nameStrokeEndColor = ed.toccc3(3487596),
    icon = "UI/alpha/1080P/pet/pet_icon_blue.png",
    count = "UI/alpha/1080P/pet/pet_count_blue.png",
    light = "UI/alpha/1080P/pet/incubate/pet_house_get_blue_effect.png",
    nameBgRes = "UI/alpha/1080P/pet/incubate/pet_house_get_blue_bg.png"
  },
  [3] = {
    frame = "UI/alpha/1080P/common/frame/hero_icon_frame_7.png",
    tag = "UI/alpha/1080P/pet/pet_tag_purple.png",
    namePrefix = T("\231\180\171\232\137\178\229\147\129\232\180\168"),
    nameColor = ed.toccc3(16776423),
    nameStrokeStartColor = ed.toccc3(10574779),
    nameStrokeEndColor = ed.toccc3(5648240),
    icon = "UI/alpha/1080P/pet/pet_icon_purple.png",
    count = "UI/alpha/1080P/pet/pet_count_purple.png",
    light = "UI/alpha/1080P/pet/incubate/pet_house_get_purple_effect.png",
    nameBgRes = "UI/alpha/1080P/pet/incubate/pet_house_get_purple_bg.png"
  },
  [4] = {
    frame = "UI/alpha/1080P/common/frame/hero_icon_frame_12.png",
    tag = "UI/alpha/1080P/pet/pet_tag_gold.png",
    namePrefix = T("\230\169\153\232\137\178\229\147\129\232\180\168"),
    nameColor = ed.toccc3(16776423),
    nameStrokeStartColor = ed.toccc3(14776832),
    nameStrokeEndColor = ed.toccc3(10960395),
    icon = "UI/alpha/1080P/pet/pet_icon_gold.png",
    count = "UI/alpha/1080P/pet/pet_count_gold.png",
    light = "UI/alpha/1080P/pet/incubate/pet_house_get_gold_effect.png",
    nameBgRes = "UI/alpha/1080P/pet/incubate/pet_house_get_gold_bg.png"
  },
  [5] = {
    frame = "UI/alpha/1080P/common/frame/hero_icon_frame_12.png",
    tag = "UI/alpha/1080P/pet/pet_tag_gold.png",
    namePrefix = T("\231\186\162\232\137\178\229\147\129\232\180\168"),
    nameColor = ed.toccc3(16776423),
    nameStrokeStartColor = ed.toccc3(14776832),
    nameStrokeEndColor = ed.toccc3(10960395),
    icon = "UI/alpha/1080P/pet/pet_icon_gold.png",
    count = "UI/alpha/1080P/pet/pet_count_gold.png",
    light = "UI/alpha/1080P/pet/incubate/pet_house_get_gold_effect.png",
    nameBgRes = "UI/alpha/1080P/pet/incubate/pet_house_get_gold_bg.png"
  }
}
ed.Pet.PetConfig = PetConfig

function Pet.create()
  local pet = {}
  setmetatable(pet, Pet)
  return pet
end

ed.PetCreate = Pet.create

function Pet:setup(data)
  self.data = data
end

function Pet:getData()
  return self.data
end

function Pet:getId()
  return self.data._id
end

function Pet:getTypeId()
  return self.data._type_id
end

function Pet:getName()
  return ed.lookupDataTable("Unit", "Display Name", self:getTypeId())
end

function Pet:getEvolveName()
  local name = self:getName()
  if self.data._evolve and self.data._evolve > 0 then
    name = name .. "+" .. self.data._evolve
  end
  return name
end

function Pet:getEvolve()
  return self.data._evolve
end

function Pet:increaseEvolve()
  self.data._evolve = self.data._evolve + 1
end

function Pet:getIsEvolving()
  return self.data._is_evolving
end

function Pet:setIsEvolving(isEvolveing)
  self.data._is_evolving = isEvolveing
end

function Pet:getLevel()
  return self.data._level
end

function Pet:getTalents()
  return self.data._talents or {}
end

function Pet:getBody()
  local talents = self:getTalents()
  local mul = 1
  for k, v in ipairs(talents) do
    if v == 1 then
      mul = 1.1
    end
  end
  return (self.data._scale or 1000) / 1000 * mul
end

function Pet:increaseHeart()
  self.data._level = self.data._level + 1
end

function Pet:getSkillLevels()
  return self.data._skill_levels
end

function Pet:getSkillLevel(index)
  return self.data._skill_levels[index]
end

function Pet:levelupSkill(index, amount)
  self.data._skill_levels[index] = self.data._skill_levels[index] + amount
end

function Pet:checkSkillLevelMax()
  for i, v in ipairs(self.data._skill_levels) do
    if v < 30 then
      return false
    end
  end
  return true
end

function Pet:getLastRemoveTime()
  return self.data._last_remove_time
end

function Pet:setLastRemoveTime()
  self.data._last_remove_time = ed.getServerTime()
end

function Pet:getCarriedHeroId()
  return self.data._carried_hero_id or 0
end

function Pet:setCarriedHeroId(heroId)
  self.data._carried_hero_id = heroId
end

function Pet.getEquipSlotNum(unitproto)
  local pet = unitproto._pet
  local id = pet._type_id
  local petInfo = ed.getDataTable("Pet")[id]
  local lmt = petInfo["Hearts Unlock Eqiup6"]
  local hms = unitproto._stars >= ed.parameter.hero_max_star
  if lmt ~= 0 and lmt <= pet._level and hms then
    return maxEquipSlotNum
  end
  return math.min(pet._heart, unitproto._stars)
end

function Pet:getColor()
  return ed.lookupDataTable("Pet", "Color", self:getTypeId())
end

function Pet.getColorByType(typeId)
  return ed.lookupDataTable("Pet", "Color", typeId)
end

function Pet.getTagResByTypeId(typeId)
  local color = ed.lookupDataTable("Pet", "Color", typeId)
  return PetConfig[color].tag
end

function Pet.getLightResByTypeId(typeId)
  local color = ed.lookupDataTable("Pet", "Color", typeId)
  return PetConfig[color].light
end

function Pet.getNameBgResByTypeId(typeId)
  local color = ed.lookupDataTable("Pet", "Color", typeId)
  return PetConfig[color].nameBgRes
end

function Pet.getNameColorByTypeId(typeId)
  local color = ed.lookupDataTable("Pet", "Color", typeId)
  return PetConfig[color].nameColor
end

function Pet.getStartColor(typeId)
  local color = ed.lookupDataTable("Pet", "Color", typeId)
  return PetConfig[color].nameStrokeStartColor
end

function Pet.getEndColor(typeId)
  local color = ed.lookupDataTable("Pet", "Color", typeId)
  return PetConfig[color].nameStrokeEndColor
end

function Pet:getIconFrame()
  return PetConfig[self:getColor()].frame
end

function Pet:getNameColor()
  local color = self:getColor()
  return PetConfig[color].nameColor
end

function Pet.getIconFrameByColor(petColor)
  return PetConfig[petColor].frame
end

function Pet:getNamePrefix()
  return PetConfig[self:getColor()].namePrefix
end

function Pet.getMaxEquipSlotNum()
  return maxEquipSlotNum
end

function Pet.sort(pets)
  local result = {}
  for _, pet in pairs(pets) do
    table.insert(result, pet)
  end
  
  local function cmp(pet1, pet2)
    if pet1:getColor() == pet2:getColor() then
      if pet1:getTypeId() == pet2:getTypeId() then
        return pet1:getLevel() > pet2:getLevel()
      else
        return pet1:getTypeId() < pet2:getTypeId()
      end
    else
      return pet1:getColor() > pet2:getColor()
    end
  end
  
  table.sort(result, cmp)
  return result
end

function Pet:getCD()
  local lastRemoveTimeStamp = self:getLastRemoveTime()
  if lastRemoveTimeStamp == 0 then
    return 0
  end
  local delta = ed.getServerTime() - lastRemoveTimeStamp
  local totalCD = ed.lookupDataTable("Pet", "Remove CD", self:getTypeId()) * 3600
  for k, v in ipairs(self:getTalents()) do
    if v == 3 then
      totalCD = 600
    end
  end
  if delta > totalCD then
    return 0
  end
  return totalCD - delta
end

function Pet:getExtraShader()
  for k, v in ipairs(self:getTalents()) do
    if v == 4 then
      return ed.getDataTable("Pet")[self:getTypeId()]["Pet Variation Shader"]
    end
  end
end

function Pet:isVariation()
  for k, v in ipairs(self:getTalents()) do
    if v == 4 then
      return true
    end
  end
  return false
end

function Pet:getCDStr()
  local cd = self:getCD()
  if cd == 0 then
    return ""
  else
    return ed.gethmsNString(cd)
  end
end

function Pet:getSkillUpMaterials(level)
  local skillCostGroup = ed.getDataTable("Pet")[self:getTypeId()]["Skill Cost Group"]
  local tb = ed.getDataTable("PetSkillCost")[skillCostGroup][level]
  return {
    {
      type = "gold",
      amount = tb.Price
    },
    {
      type = "item",
      id = tb["Item ID 1"],
      amount = tb["Item Amount 1"]
    }
  }
end

function Pet:getLevelUpMats(level)
  local type = self:getTypeId()
  local level = level or self:getLevel()
  local enhanceGroup = ed.lookupDataTable("Pet", "Enhance Cost Group", type)
  local foods = ed.getDataTable("PetEnhanceCost")[enhanceGroup][level]
  return {
    {
      type = "gold",
      amount = foods.Price
    },
    {
      type = "item",
      id = foods["Item ID 1"],
      amount = foods["Item Amount 1"]
    }
  }
end

function Pet:getAllSkillUpCost()
  local ret = {}
  local level_list = self:getSkillLevels()
  for i = 1, #level_list do
    local level = level_list[i]
    if 1 < level then
      for j = 1, level - 1 do
        local cost = self:getSkillUpMaterials(j)
        for k = 1, #cost do
          table.insert(ret, cost[k])
        end
      end
    end
  end
  return ret
end

function Pet:getAllLevelUpCost()
  local ret = {}
  local level = self:getLevel()
  if 0 < level then
    for i = 0, level - 1 do
      local cost = self:getLevelUpMats(i)
      for j = 1, #cost do
        table.insert(ret, cost[j])
      end
    end
  end
  return ret
end

function Pet:getPetAttrRadio(key, level)
  local type = self:getTypeId()
  local level = level or self:getLevel()
  local add = 0
  for k, v in ipairs(self:getTalents()) do
    if v == 2 then
      add = 2
    end
  end
  return ed.lookupDataTable("Pet", key .. " Enhance Ratio", type) * level + ed.lookupDataTable("Pet", key .. " Base Ratio", type) + add
end

function Pet:getSlot6Cost()
  return ed.lookupDataTable("Pet", "Slot6 Change Fee", self:getTypeId())
end

function Pet:getHeroPanelBgOffset()
  return ed.lookupDataTable("PetHearts", "Hero Panel Offset", self:getColor())
end

function Pet:getPetPanelMarkOffset()
  return ed.lookupDataTable("PetHearts", "Pet Panel Offset", self:getColor())
end

function Pet:getPetAttrValue(key)
  local heroId = self:getCarriedHeroId()
  if heroId == 0 then
    return 0
  end
  local hero = ed.player:getHero(heroId)
  local info = ed.getDataTable("Unit")[heroId]
  return self:getPetAttrRadio(key) * hero._level * (info["+" .. key .. hero._stars] or 0) / 100
end

function Pet:getSkillsInfo()
  return ed.heroDetailManager.getSkillsInfo(self:getTypeId())
end
