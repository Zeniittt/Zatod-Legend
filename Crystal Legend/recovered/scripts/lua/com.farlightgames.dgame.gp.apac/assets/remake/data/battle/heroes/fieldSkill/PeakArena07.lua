module("ed.battlehero", package.seeall)
local ed = ed
PeakArena07 = {}

function PeakArena07.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 1 or owner.info.ID == 2 or owner.info.ID == 14 or owner.info.ID == 28 or owner.info.ID == 10076 then
    buff.update = override(buff.update, PeakArena07.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena07.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("HP", 0.1 * owner.attribs.HP / owner.config.hp_mod)
    buff:setAttribute("AD", 0.1 * owner.attribs.AD)
    buff:setAttribute("AP", 0.1 * owner.attribs.AP)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

function PeakArena07.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena07.createBuff)
  return skill
end

return PeakArena07.init_fieldSkill
