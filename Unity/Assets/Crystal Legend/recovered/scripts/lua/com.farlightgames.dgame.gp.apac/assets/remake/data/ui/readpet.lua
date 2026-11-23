local ReadPet = newclass("g")
ed.readpet = ReadPet

function ReadPet.createIcon(info)
  local obj = {}
  setmetatable(obj, ReadPet.mt)
  obj.info = info
  obj.icon = obj:addPictureInfo()
  if obj.icon ~= nil then
    obj:addFrameInfo()
    obj:addLevelInfo(info.level)
    obj:addLengthInfo(info.length)
    obj:addMasterIcon()
  end
  return obj
end

function ReadPet:addMasterIcon()
  local pet = self.info.pet
  if self.info.showMaster and pet:getCarriedHeroId() ~= 0 then
    local master = ed.player.heroes[pet:getCarriedHeroId()] or {}
    local hIcon = ed.readhero.createPureIcon({
      id = pet:getCarriedHeroId(),
      noStar = true,
      rank = master._rank
    }).icon
    hIcon:setScale(0.4)
    hIcon:setPosition(54, 16)
    self.icon:addChild(hIcon, 27)
  end
end

function ReadPet:addShade()
  if self.stateShade then
    return
  end
  local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
  shade:setContentSize(CCSizeMake(77, 77))
  shade:setPosition(ccp(-3, -4))
  self.icon:addChild(shade, 26)
  self.stateShade = shade
end

function ReadPet:removeShade()
  if self.stateShade then
    removeNode(self.stateShade)
    self.stateShade = nil
  end
end

function ReadPet.createChessIcon(info)
  local obj = {}
  setmetatable(obj, ReadPet.mt)
  obj.info = info
  obj.icon = obj:addChessPictureInfo()
  if obj.icon ~= nil then
    obj:addChessFrameInfo()
    obj:addLengthInfo(info.length)
  end
  return obj
end

function ReadPet.createIconByPet(pet, addition)
  local info = {}
  info.id = pet:getId()
  info.type = pet:getTypeId()
  info.pet = pet
  if addition then
    info.length = addition.length
    info.noLevel = addition.noLevel
    info.showMaster = addition.showMaster
    info.showTag = addition.showTag
  end
  return ReadPet.createIcon(info)
end

function ReadPet.createIconById(id, addition)
  local pet = ed.player:getPet(id)
  return ReadPet.createIconByPet(pet, addition)
end

function ReadPet:addPictureInfo()
  local info = self.info
  local type = info.type
  local portrait_res = ed.getUnitPortrait(type)
  local icon = ed.createSprite(portrait_res)
  icon:setCascadeOpacityEnabled(true)
  return icon
end

function ReadPet:addChessPictureInfo()
  local info = self.info
  local type = info.type
  local portrait_res = ed.getChessUnitPortrait(type)
  local icon = ed.createSprite(portrait_res)
  icon:setCascadeOpacityEnabled(true)
  return icon
end

function ReadPet:addFrameInfo()
  local info = self.info
  local icon = self.icon
  local petColor = ed.Pet.getColorByType(info.type)
  local frameRes = ed.Pet.getIconFrameByColor(petColor)
  local frame = ed.createSprite(frameRes)
  local size = icon:getContentSize()
  frame:setScale(size.width * 1.2 / frame:getContentSize().width)
  frame:setPosition(ccp(size.width / 2, size.height / 2 + 0.5))
  icon:addChild(frame)
  self.frame = frame
  if info.showTag then
    local tagRes = ed.Pet.getTagResByTypeId(info.type)
    local tag = ed.createSprite(tagRes)
    tag:setScale(0.8)
    tag:setPosition(ccp(10, size.height - 11))
    icon:addChild(tag, 1)
  end
end

function ReadPet:addChessFrameInfo()
  local info = self.info
  local type = info.type
  local icon = self.icon
  local petColor = ed.getChessUnitSellPrice(type)
  local frameRes = ed.Pet.getIconFrameByColor(petColor)
  local frame = ed.createSprite(frameRes)
  local size = icon:getContentSize()
  frame:setPosition(ccp(size.width / 2, size.height / 2))
  icon:addChild(frame)
  self.frame = frame
end

function ReadPet:addStarsInfo()
  local info = self.info
  local icon = self.icon
  local heartNum = info.heart
  local heroStar = info.heroStar
  local size = icon:getContentSize()
  
  local function getStarPos(i, max)
    local dx = 12
    local x, y = size.width / 2 - 5, 6
    local ci = max / 2
    x = x + dx * (i - ci)
    return ccp(x, y)
  end
  
  local starIconPath = {
    red = "UI/alpha/HVGA/pet/pet_heart_small.png",
    gray = "UI/alpha/HVGA/pet/pet_heart_small_nouse.png"
  }
  self.stars = {}
  for i = heartNum or 0, 1, -1 do
    local path = starIconPath.red
    if i > heroStar then
      path = starIconPath.gray
    end
    local pict = ed.createSprite(path)
    local pos = getStarPos(i, heartNum)
    pict:setPosition(pos)
    icon:addChild(pict, 5)
    self.stars[i] = pict
  end
end

function ReadPet:addLevelInfo(level)
  local icon = self.icon
  local info = self.info
  if info.noLevel then
    return
  end
  if not icon or not info.pet and not level then
    return
  end
  level = level or info.pet:getLevel()
  local levelBg = ed.createSprite("UI/alpha/1080P/common/heropackage_level_bg.png")
  levelBg:setAnchorPoint(ccp(0, 0))
  levelBg:setPosition(ccp(0, 10))
  icon:addChild(levelBg, 20)
  self.levelBg = levelBg
  local levelLabel = ed.createttf(level or 1, 14)
  levelLabel:setAnchorPoint(ccp(0.5, 0.5))
  levelLabel:setPosition(ccp(8, 16.5))
  icon:addChild(levelLabel, 25)
  self.levelLabel = levelLabel
end

function ReadPet:addLengthInfo(length)
  local icon = self.icon
  if not icon or not length then
    return
  end
  local size = icon:getContentSize()
  icon:setScale(length / size.width)
end

function ReadPet.getActor(petType, isVariation)
  local unit_row = ed.getDataTable("Unit")[petType]
  local cha_name = unit_row.Puppet
  local puppet_id = unit_row.Puppet
  local variationChaName = ed.lookupDataTable("Pet", "Pet Variation Puppet", petType)
  if isVariation and variationChaName then
    cha_name = variationChaName
    puppet_id = variationChaName
  end
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local actor = ed.createFcaActor(info.Resource, 1.5)
  local usePlists = info.Plist
  local elements = info.Element
  if usePlists and elements then
    local SourcePositions = info["Source Position"]
    local PositionTypes = info["Position Type"]
    local EmissionRates = info["Emission Rate"]
    local enumPositionTypes = {
      Free = kCCPositionTypeFree,
      Relative = kCCPositionTypeRelative,
      Grouped = kCCPositionTypeGrouped
    }
    for i = 1, #usePlists do
      local particle = CCParticleSystemQuad:create("UI/particle/" .. usePlists[i] .. ".plist")
      local t = CCAffineTransformMake(1, 0, 0, 1, 0, 0)
      local element = elements[i]
      actor:addNodeToComponent(particle, element, 1, t, true, true)
      if #SourcePositions ~= 0 and #PositionTypes ~= 0 and #EmissionRates ~= 0 then
        local px, py = tonumber(SourcePositions[i * 2 - 1]), tonumber(SourcePositions[i * 2])
        particle:setSourcePosition(ccp(px, py))
        particle:setPositionType(enumPositionTypes[PositionTypes[i]])
        local emissionRate = tonumber(EmissionRates[i])
        particle:setEmissionRate(emissionRate)
      end
    end
  end
  actor:setAction(action_name or "Idle")
  if action_loop == nil then
    action_loop = true
  end
  actor:setLoop(action_loop)
  return actor, cha_name
end

function ReadPet.createSkillIcon(petTypeId, slot)
  local sgt = ed.getDataTable("SkillGroup")[petTypeId]
  local res = sgt[slot].Icon
  local fres = "UI/alpha/HVGA/equip_frame_white.png"
  local icon = ed.createSprite(res)
  local bg = ed.createSprite(fres)
  bg:setPosition(ccp(30, 29))
  icon:addChild(bg)
  icon:setCascadeOpacityEnabled(true)
  return icon, bg
end

function ReadPet.sortPetIdByColor(petIdList)
  local petTB = ed.getDataTable("Pet")
  table.sort(petIdList, ed.cmpSort({
    {
      getValue = function(petId)
        local petCfg = petTB[petId]
        return petCfg.Color or 0
      end,
      reverse = true
    },
    {
      getValue = function(petId)
        return petId
      end
    }
  }))
end
