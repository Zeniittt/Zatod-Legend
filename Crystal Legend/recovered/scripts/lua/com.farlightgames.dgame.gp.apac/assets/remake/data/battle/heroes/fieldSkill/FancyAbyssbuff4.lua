module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff4 = {}

function FancyAbyssbuff4.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.effectFirtTime = true
  if ed.run_with_scene and owner.actor then
    buff.effect = owner.actor:addEffect("eff_buff_fancybuff4_shield1.cha", 1)
  end
  buff.update = override(buff.update, FancyAbyssbuff4.Buff_update)
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff4.Buff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, FancyAbyssbuff4.Buff_OnRemoved)
  return buff
end

function FancyAbyssbuff4.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  local owner = buff.owner
  if source and (damage_type == "Holy" and field == "hp" or damage_type == "AD" or damage_type == "AP") then
    if owner.level < 80 then
      dmg = dmg * 0.65
    else
      dmg = dmg * 0.5
    end
  end
  return dmg
end

function FancyAbyssbuff4.Buff_update(basefunc, buff, dt)
  buff.count = (buff.count or 0) + 1
  local owner = buff.owner
  local caster = buff.caster
  if buff.count == 8 then
    if 0 > owner.attribs.HPR then
      buff.removecount = (buff.removecount or 0) + 1
    end
    buff.count = 0
  end
  if buff.removecount == 6 and buff.effectFirtTime and ed.run_with_scene and owner.actor then
    owner.actor.puppet:removeEffectWithID(buff.effect)
    buff.effect = owner.actor:addEffect("eff_buff_fancybuff4_shield2.cha", 1)
    buff.effectFirtTime = false
  end
  if buff.removecount == 10 then
    if ed.run_with_scene and owner.actor then
      owner.actor.puppet:removeEffectWithID(buff.effect)
    end
    owner:removeBuff(buff)
  end
end

function FancyAbyssbuff4.Buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  if ed.run_with_scene and owner.actor then
    owner.actor.puppet:removeEffectWithID(buff.effect)
  end
end

function FancyAbyssbuff4.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff4.createBuff)
  return skill
end

return FancyAbyssbuff4.init_fieldSkill
