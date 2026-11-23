module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff11 = {}

function FancyAbyssbuff11.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.update = override(buff.update, FancyAbyssbuff11.Buff_update)
  buff.ticks = 0
  buff.unremoveable = true
  buff.owner.healcd = 0
  return buff
end

function FancyAbyssbuff11.Buff_update(basefunc, buff, dt)
  buff.ticks = buff.ticks + 1
  local owner = buff.owner
  owner.healcd = owner.healcd - 1
  if owner.healaction then
    owner.healaction = owner.healaction - 1
  end
  local caster = buff.caster
  if buff.ticks == 40 then
    owner:takeHeal(owner.attribs.HP * 0.2 / owner.attribs.PDM, "hp", owner)
    buff.ticks = 0
  end
  if owner.healcd <= 0 and owner.hp < 0.1 * owner.attribs.HP then
    owner.healaction = 1
    owner.healcd = 240
  end
  if owner.healaction == 0 then
    owner:takeHeal(owner.attribs.HP * 0.5 / owner.attribs.PDM, "hp", owner)
  end
end

function FancyAbyssbuff11.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff11.createBuff)
  return skill
end

return FancyAbyssbuff11.init_fieldSkill
