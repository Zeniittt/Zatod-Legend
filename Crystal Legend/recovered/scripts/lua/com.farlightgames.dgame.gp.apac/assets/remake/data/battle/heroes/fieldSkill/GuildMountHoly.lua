module("ed.battlehero", package.seeall)
local ed = ed
GuildMountHoly = {}

function GuildMountHoly.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountHoly.Buff_update)
  buff.onDamaged = override(buff.onDamaged, GuildMountHoly.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function GuildMountHoly.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if damage_type == "Holy" and field == "hp" and source and source.camp == -buff.owner.camp then
    dmg = dmg * 3
  end
  return dmg
end

function GuildMountHoly.Buff_update(basefunc, buff, dt)
end

function GuildMountHoly.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountHoly.createBuff)
  return skill
end

return GuildMountHoly.init_fieldSkill
