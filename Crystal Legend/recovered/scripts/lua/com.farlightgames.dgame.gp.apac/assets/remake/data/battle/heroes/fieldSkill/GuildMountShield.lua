module("ed.battlehero", package.seeall)
local ed = ed
GuildMountShield = {}

function GuildMountShield.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountShield.Buff_update)
  owner.GMShield = 0
  owner.GMLastShield = 0
  buff.unremoveable = true
  return buff
end

function GuildMountShield.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  if owner.GMShield > owner.GMLastShield then
    local addp = owner.GMShield / 1000
    local apdp = owner.GMShield / 1000
    buff:setAttribute("ADDP", addp)
    buff:setAttribute("APDP", apdp)
    owner:rebuild()
    if owner.GMShield == 40000 and owner.actor then
      owner.actor:addEffect("eff_buff_fancybuff3_shield.cha", 1)
    end
    owner.GMLastShield = owner.GMShield
  end
end

function GuildMountShield.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountShield.createBuff)
  return skill
end

return GuildMountShield.init_fieldSkill
