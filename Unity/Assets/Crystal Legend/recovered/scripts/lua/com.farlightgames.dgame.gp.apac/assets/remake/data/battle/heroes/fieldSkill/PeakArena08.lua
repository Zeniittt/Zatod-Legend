module("ed.battlehero", package.seeall)
local ed = ed
PeakArena08 = {}

function PeakArena08.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 13 or owner.info.ID == 23 or owner.info.ID == 47 or owner.info.ID == 52 or owner.info.ID == 10110 then
    buff.update = override(buff.update, PeakArena08.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena08.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("STR", 0.15 * owner.attribs.STR)
    buff:setAttribute("AGI", 0.15 * owner.attribs.AGI)
    buff:setAttribute("INT", 0.15 * owner.attribs.INT)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

function PeakArena08.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena08.createBuff)
  return skill
end

return PeakArena08.init_fieldSkill
