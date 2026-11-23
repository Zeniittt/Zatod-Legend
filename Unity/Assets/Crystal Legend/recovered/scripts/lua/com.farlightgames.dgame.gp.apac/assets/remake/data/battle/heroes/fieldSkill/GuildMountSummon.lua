module("ed.battlehero", package.seeall)
local ed = ed
GuildMountSummon = {}

function GuildMountSummon.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, GuildMountSummon.Buff_onDamaged)
  return buff
end

function GuildMountSummon.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if source and source.config.is_summoned and source.info.ID ~= 224 and source.info.ID ~= 210 and field == "hp" then
    dmg = dmg * 3
  end
  return dmg
end

function GuildMountSummon.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountSummon.createBuff)
  return skill
end

return GuildMountSummon.init_fieldSkill
