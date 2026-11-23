module("ed.battlehero", package.seeall)
local ed = ed
PeakArena15 = {}

function PeakArena15.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 65 or owner.info.ID == 41 or owner.info.ID == 10014 or owner.info.ID == 26 or owner.info.ID == 1 then
    buff.update = override(buff.update, PeakArena15.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena15.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("HP", 0.15 * owner.attribs.HP / owner.config.hp_mod)
    buff:setAttribute("MPRatio", 15)
    buff:setAttribute("MPGainRatio", 15)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

function PeakArena15.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena15.createBuff)
  return skill
end

return PeakArena15.init_fieldSkill
