module("ed.battlehero", package.seeall)
local ed = ed
GuildMountMultiUp2 = {}

function GuildMountMultiUp2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountMultiUp2.Buff_update)
  owner.GMmulticount = 0
  owner.GMLastmulticount = 0
  buff.unremoveable = true
  return buff
end

function GuildMountMultiUp2.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  if owner.GMmulticount > owner.GMLastmulticount then
    local ad = owner.GMmulticount * 20
    local ap = owner.GMmulticount * 35
    buff:setAttribute("AD", ad)
    buff:setAttribute("AP", ap)
    owner:rebuild()
    if owner.GMmulticount == 60 and owner.actor then
      owner.actor:addEffect("eff_buff_fancybuff3_shield.cha", 1)
    end
    owner.GMLastmulticount = owner.GMmulticount
  end
end

function GuildMountMultiUp2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountMultiUp2.createBuff)
  return skill
end

return GuildMountMultiUp2.init_fieldSkill
