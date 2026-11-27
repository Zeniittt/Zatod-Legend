module("ed.battlehero", package.seeall)
local ed = ed
PeakArena10 = {}

function PeakArena10.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 72 or owner.info.ID == 99 or owner.info.ID == 62 or owner.info.ID == 75 or owner.info.ID == 26 then
    buff.update = override(buff.update, PeakArena10.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena10.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("HP", 0.15 * owner.attribs.HP / owner.config.hp_mod)
    buff:setAttribute("PIMU", 15)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

function PeakArena10.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena10.createBuff)
  return skill
end

return PeakArena10.init_fieldSkill
