module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff17_2 = {}

function FancyAbyssbuff17_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, FancyAbyssbuff17_2.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff17_2.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  if owner.attribs.HPR < 0 then
    if ed.run_with_scene and owner.actor and buff.effect == nil then
      buff.effect = owner.actor:addEffect("eff_buff_rogue6201.cha", 1)
    end
  elseif ed.run_with_scene and owner.actor and buff.effect then
    owner.actor.puppet:removeEffectWithID(buff.effect)
    buff.effect = nil
  end
end

function FancyAbyssbuff17_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff17_2.createBuff)
  return skill
end

return FancyAbyssbuff17_2.init_fieldSkill
