module("ed.battlehero", package.seeall)
local ed = ed
GuildMountMultiUp = {}

function GuildMountMultiUp.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, GuildMountMultiUp.Buff_onDamaged)
  return buff
end

function GuildMountMultiUp.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if source and source.GMmulticount and source.GMmulticount < 60 then
    source.GMmulticount = source.GMmulticount + 1
  elseif source.info.ID == 224 and source.config.summoner and source.config.summoner.GMmulticount and 60 > source.config.summoner.GMmulticount then
    source.config.summoner.GMmulticount = source.config.summoner.GMmulticount + 1
  end
  return dmg
end

function GuildMountMultiUp.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountMultiUp.createBuff)
  return skill
end

return GuildMountMultiUp.init_fieldSkill
