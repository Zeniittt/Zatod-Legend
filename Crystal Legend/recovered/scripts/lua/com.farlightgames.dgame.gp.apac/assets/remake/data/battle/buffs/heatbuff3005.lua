local function heatbuff3005onDamaged(basefunc, buff, damage, damage_type)
  local info = buff.info
  
  local owner = buff.owner
  local buffid = info.ID
  local level = buffid - 20030050
  if damage <= 0 then
    return 0
  else
    local stype = buff.info["Shield Type"]
    local block = 500 * level
    local temp = block - damage
    if temp < 0 then
      return -temp
    end
    if owner.actor then
      local color = owner.camp == ed.emCampPlayer and "blue" or "red"
      local str = {
        AD = "physical_immune",
        AP = "magic_immune",
        all = "immune"
      }
      ed.PopupCreate(str[stype] or "immune", color, owner.actor, nil, "text")
    end
    return 0
  end
  return damage
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, heatbuff3005onDamaged)
  return buff
end

return initBuff
