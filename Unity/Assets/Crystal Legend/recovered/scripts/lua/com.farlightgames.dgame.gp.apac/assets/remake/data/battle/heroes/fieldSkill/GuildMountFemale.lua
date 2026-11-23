module("ed.battlehero", package.seeall)
local ed = ed
GuildMountFemale = {}

function GuildMountFemale.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountFemale.Buff_update)
  buff.onDamaged = override(buff.onDamaged, GuildMountFemale.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function GuildMountFemale.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if source then
    local summoner = source.config.summoner
    if (source.info.Gender and source.info.Gender == T("\229\165\179") or summoner and summoner.info.Gender and summoner.info.Gender == T("\229\165\179")) and field == "hp" then
      dmg = dmg * 1.2
    elseif field == "hp" then
      dmg = dmg * 0.8
    end
  end
  return dmg
end

function GuildMountFemale.Buff_update(basefunc, buff, dt)
end

function GuildMountFemale.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountFemale.createBuff)
  return skill
end

return GuildMountFemale.init_fieldSkill
