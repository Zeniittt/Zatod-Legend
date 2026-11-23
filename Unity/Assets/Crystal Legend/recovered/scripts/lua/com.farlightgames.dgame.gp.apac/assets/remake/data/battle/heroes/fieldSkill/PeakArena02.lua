module("ed.battlehero", package.seeall)
local ed = ed
PeakArena02 = {}

function PeakArena02.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 12 or owner.info.ID == 11 or owner.info.ID == 75 or owner.info.ID == 72 or owner.info.ID == 62 then
    owner.peakarena02 = true
    buff:setAttribute("PIMU", 40)
  end
  buff.onDamaged = override(buff.onDamaged, PeakArena02.Buff_onDamaged)
  buff.update = override(buff.update, PeakArena02.Buff_update)
  buff.unremoveable = true
  return buff
end

function PeakArena02.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and source.peakarena02 == true and damage_type == "AP" and field == "hp" then
    source:takeHeal(dmg * 0.5, "hp")
  end
  return dmg
end

function PeakArena02.Buff_update(basefunc, buff, dt)
end

function PeakArena02.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena02.createBuff)
  return skill
end

return PeakArena02.init_fieldSkill
