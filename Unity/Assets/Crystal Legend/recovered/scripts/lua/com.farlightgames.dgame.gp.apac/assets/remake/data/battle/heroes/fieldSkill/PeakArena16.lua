module("ed.battlehero", package.seeall)
local ed = ed
PeakArena16 = {}

function PeakArena16.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info.ID == 6 or owner.info.ID == 20 or owner.info.ID == 99 or owner.info.ID == 64 or owner.info.ID == 18 then
    buff.update = override(buff.update, PeakArena16.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena16.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("HP", 0.15 * owner.attribs.HP / owner.config.hp_mod)
    buff:setAttribute("AP", 0.15 * owner.attribs.AP)
    owner:rebuild()
    owner:setHP(owner.attribs.HP)
  end
end

function PeakArena16.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena16.createBuff)
  return skill
end

return PeakArena16.init_fieldSkill
