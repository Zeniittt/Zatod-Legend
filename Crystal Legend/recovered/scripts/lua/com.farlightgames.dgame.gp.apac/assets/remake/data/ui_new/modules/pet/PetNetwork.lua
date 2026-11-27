local PetNetwork = {}
PetNetwork.__index = PetNetwork
local printData = true
local instance

function PetNetwork.getInstance()
  if not instance then
    instance = PetNetwork.create()
  end
  return instance
end

function PetNetwork.create()
  local net = {}
  setmetatable(net, PetNetwork)
  return net
end

function PetNetwork:dispatch(replyInfo)
  if printData then
    print("----------------PetNetwork:dispatch-------------------")
    ed.pt(replyInfo)
  end
  if replyInfo._open_panel then
    ed.PetManager:handleOpenPanel(replyInfo._open_panel)
  elseif replyInfo._hatch_egg then
    ed.PetManager:handleHatchEgg(replyInfo._hatch_egg)
  elseif replyInfo._accelerate_hatch then
    ed.PetManager:handleAccHatchEgg(replyInfo._accelerate_hatch)
  elseif replyInfo._open_egg then
    ed.PetManager:handleOpenEgg(replyInfo._open_egg)
  elseif replyInfo._equip_pet then
    ed.PetManager:handleEquipPet(replyInfo._equip_pet)
  elseif replyInfo._unequip_pet then
    ed.PetManager:handleUnEquipPet(replyInfo._unequip_pet)
  elseif replyInfo._levelup then
    ed.PetManager:handleLevelUp(replyInfo._levelup)
  elseif replyInfo._levelup_skill then
    ed.PetManager:handleLevelupSkill(replyInfo._levelup_skill)
  elseif replyInfo._decompose then
    ed.PetManager:handleDecomposePet(replyInfo._decompose)
  end
end

function PetNetwork:doReq(msg)
  if printData then
    print("----------------PetNetwork:doReq-------------------")
    ed.pt(msg)
  end
  ed.send(msg, "pet")
end

function PetNetwork:openPanel()
  local msg = ed.upmsg.pet_req()
  msg._open_panel = ed.upmsg.pet_open_panel()
  self:doReq(msg)
end

function PetNetwork:startHatchEgg(index, eggId)
  local msg = ed.upmsg.pet_req()
  msg._hatch_egg = ed.upmsg.pet_hatch_egg()
  msg._hatch_egg._index = index
  msg._hatch_egg._egg_id = eggId
  self:doReq(msg)
end

function PetNetwork:accelerateHatch(index, type, consume_items)
  self.accelerateHatchInfo = {
    index = index,
    type = type,
    consume_items = consume_items and consume_items[1] or {}
  }
  local msg = ed.upmsg.pet_req()
  msg._accelerate_hatch = ed.upmsg.pet_accelerate_hatch()
  msg._accelerate_hatch._index = index
  msg._accelerate_hatch._type = type
  if type == "item" then
    msg._accelerate_hatch._consume_items = consume_items
  end
  self:doReq(msg)
end

function PetNetwork:openEgg(index)
  print("=====================================================requst open egg ", index)
  local msg = ed.upmsg.pet_req()
  msg._open_egg = ed.upmsg.pet_open_egg()
  msg._open_egg._index = index
  self:doReq(msg)
end

function PetNetwork:equipPet(heroId, petId)
  local msg = ed.upmsg.pet_req()
  msg._equip_pet = ed.upmsg.pet_equip_pet()
  msg._equip_pet._hero_id = heroId
  msg._equip_pet._pet_id = petId
  self:doReq(msg)
end

function PetNetwork:unequipPet(heroId, useItem)
  local msg = ed.upmsg.pet_req()
  msg._unequip_pet = ed.upmsg.pet_unequip_pet()
  msg._unequip_pet._hero_id = heroId
  msg._unequip_pet._is_use_item = useItem and 1 or 0
  self:doReq(msg)
end

function PetNetwork:levelupPetSkill(petId, skillPair)
  local msg = ed.upmsg.pet_req()
  msg._levelup_skill = ed.upmsg.pet_levelup_skill()
  msg._levelup_skill._pet_id = petId
  msg._levelup_skill._skill_pair = skillPair
  self:doReq(msg)
end

function PetNetwork:levelupPet(petId, addLevel)
  local msg = ed.upmsg.pet_req()
  msg._levelup = ed.upmsg.pet_levelup()
  msg._levelup._pet_id = petId
  msg._levelup._add_level = addLevel
  self:doReq(msg)
end

function PetNetwork:sendDecomposePets(petids)
  self.decompPetIds = petids
  local msg = ed.upmsg.pet_req()
  msg._decompose = ed.upmsg.pet_decompose()
  msg._decompose._pet_ids = petids
  self:doReq(msg)
end

ed.PetNetwork = PetNetwork.getInstance()
