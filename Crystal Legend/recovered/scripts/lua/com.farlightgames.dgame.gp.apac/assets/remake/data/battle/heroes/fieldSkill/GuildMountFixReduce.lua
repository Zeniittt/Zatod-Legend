module("ed.battlehero", package.seeall)
local ed = ed
GuildMountFixReduce = {}

function GuildMountFixReduce.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountFixReduce.Buff_update)
  buff.onDamaged = override(buff.onDamaged, GuildMountFixReduce.Buff_onDamaged)
  buff.unremoveable = true
  local difficult = ed.getDataTable("GuildMountBoss")[ed.engine.guildMountBossId].Difficult
  if difficult < 4 then
    owner.reducenum = 1300 + difficult * 400
  end
  if 4 <= difficult then
    owner.reducenum = 2500 + (difficult - 3) * 200
  end
  return buff
end

function GuildMountFixReduce.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and dmg and 0 < dmg and field == "hp" then
    dmg = dmg * 1.3
    dmg = math.max(1, dmg - owner.reducenum)
  end
  return dmg
end

function GuildMountFixReduce.Buff_update(basefunc, buff, dt)
end

function GuildMountFixReduce.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountFixReduce.createBuff)
  return skill
end

return GuildMountFixReduce.init_fieldSkill
