local function roguebuff7403_controlcdupdate(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.roguebuff7403_controlcd then
    buff.rogue7403attack_timer = buff.rogue7403attack_timer - dt
  end
  if buff.rogue7403attack_timer <= 0 then
    owner.roguebuff7403_controlcd = true
    buff.rogue7403attack_timer = 1
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.rogue7403attack_timer = 1
  owner.roguebuff7403_controlcd = false
  buff.update = override(buff.update, roguebuff7403_controlcdupdate)
  return buff
end

return initBuff
