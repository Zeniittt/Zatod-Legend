local function Crit31buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  
  local caster = buff.caster
  if owner and caster and bCrit then
    damage = damage + caster.DMG_HP_Ratio * owner.hp
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
end

local function CritBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if not owner.CritBuff3 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      owner.CritBuff3_rank = buff.rank
      local DMG_HP_Ratio = ed.getDataTable("SoloCardSkill")[18]["Level Arg 1"]
      owner.DMG_HP_Ratio = DMG_HP_Ratio[buff.rank] / 100
      owner.CritBuff3 = true
      local Crit31bid = 90000024
      local binfo = ed.lookupDataTable("Buff", nil, Crit31bid)
      local Crit31buff = ed.BuffCreate(binfo, target, owner)
      Crit31buff.onDamaged = override(Crit31buff.onDamaged, Crit31buff_onDamaged)
      target:addBuff(Crit31buff)
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.CritBuff3 = false
  end
  buff.update = override(buff.update, CritBuff3_update)
  return buff
end

return initBuff
