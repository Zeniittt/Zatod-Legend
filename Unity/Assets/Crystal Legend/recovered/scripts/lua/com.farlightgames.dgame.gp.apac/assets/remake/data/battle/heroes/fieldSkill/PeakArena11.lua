module("ed.battlehero", package.seeall)
local ed = ed
PeakArena11 = {}

function PeakArena11.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 61 or owner.info.ID == 10110 or owner.info.ID == 77 or owner.info.ID == 41 or owner.info.ID == 47 then
    buff.update = override(buff.update, PeakArena11.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena11.buff_update(basefunc, buff, dt)
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

function PeakArena11.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena11.createBuff)
  return skill
end

return PeakArena11.init_fieldSkill
