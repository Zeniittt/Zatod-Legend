module("ed.battlehero", package.seeall)
local ed = ed
GuildMountAtk = {}

function GuildMountAtk.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountAtk.Buff_update)
  buff.onDamaged = override(buff.onDamaged, GuildMountAtk.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function GuildMountAtk.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if source then
    local skillHuskar = source.skills.Huskar_atk2
    local skillMed = source.skills.Med_atk2
    local skillTroll = source.skills.Troll_atk3
    local skillLYC = source.skills.LYC_atk2b
    local skillPA = source.skills.PA_atk
    local skillViper = source.skills.Viper_atk2
    local skillNS = source.skills.NS_atkb
    local skillDK = source.skills.DK_atkb
    local shard = source.proto._shard
    if shard and shard._id == 1000371 and source.shardSkillRank and source.shardSkillRank >= 3 then
      source.vipershard3 = true
    end
    if skill and (skill.info.Slot == 5 or skill == skillHuskar or skill == skillMed or skill == skillTroll or skill == skillLYC or skill == skillPA or skill == skillViper and source.vipershard3 or skill == skillDK or skill == skillNS) then
      dmg = dmg * 1.6
    end
  end
  return dmg
end

function GuildMountAtk.Buff_update(basefunc, buff, dt)
end

function GuildMountAtk.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountAtk.createBuff)
  return skill
end

return GuildMountAtk.init_fieldSkill
