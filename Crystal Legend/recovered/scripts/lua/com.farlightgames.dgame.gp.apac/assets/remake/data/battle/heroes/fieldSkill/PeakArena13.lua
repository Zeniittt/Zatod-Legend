module("ed.battlehero", package.seeall)
local ed = ed
PeakArena13 = {}

function PeakArena13.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 72 or owner.info.ID == 91 or owner.info.ID == 75 or owner.info.ID == 64 or owner.info.ID == 57 then
    buff.update = override(buff.update, PeakArena13.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena13.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("HP", 0.15 * owner.attribs.HP / owner.config.hp_mod)
    buff:setAttribute("AP", 0.15 * owner.attribs.AP)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

function PeakArena13.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena13.createBuff)
  return skill
end

return PeakArena13.init_fieldSkill
