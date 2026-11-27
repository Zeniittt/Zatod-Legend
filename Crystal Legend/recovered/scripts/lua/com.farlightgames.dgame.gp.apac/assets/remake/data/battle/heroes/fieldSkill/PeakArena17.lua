module("ed.battlehero", package.seeall)
local ed = ed
PeakArena17 = {}

function PeakArena17.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 84 or owner.info.ID == 58 or owner.info.ID == 47 or owner.info.ID == 41 or owner.info.ID == 35 then
    buff.update = override(buff.update, PeakArena17.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena17.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("MPR", 20)
    owner:rebuild()
  end
  basefunc(buff, dt)
end

function PeakArena17.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena17.createBuff)
  return skill
end

return PeakArena17.init_fieldSkill
