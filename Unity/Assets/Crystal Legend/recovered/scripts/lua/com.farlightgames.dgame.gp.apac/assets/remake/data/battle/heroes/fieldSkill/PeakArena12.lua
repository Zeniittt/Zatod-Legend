module("ed.battlehero", package.seeall)
local ed = ed
PeakArena12 = {}

function PeakArena12.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 25 or owner.info.ID == 58 or owner.info.ID == 67 or owner.info.ID == 10022 or owner.info.ID == 34 then
    buff.update = override(buff.update, PeakArena12.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena12.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("MPR", 20)
    owner:rebuild()
  end
  basefunc(buff, dt)
end

function PeakArena12.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena12.createBuff)
  return skill
end

return PeakArena12.init_fieldSkill
