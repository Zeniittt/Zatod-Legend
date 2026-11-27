module("ed.battlehero", package.seeall)
local ed = ed
GuildMountControl = {}

function GuildMountControl.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  owner.GuildMountControl = true
  buff.update = override(buff.update, GuildMountControl.Buff_update)
  buff.onDamaged = override(buff.onDamaged, GuildMountControl.Buff_onDamaged)
  caster.GMCdifficult = ed.getDataTable("GuildMountBoss")[ed.engine.guildMountBossId].Difficult
  buff.unremoveable = true
  return buff
end

function GuildMountControl.controleffect(buff)
  local negative_effects = {
    stun = true,
    frozen = true,
    icefrozen = true,
    immoblilize = true,
    silence = true,
    disarm = true,
    doom = true,
    imprisonment = true,
    enchanted = true,
    fear = true,
    taunt = true,
    detaunt = true,
    polymorph = true
  }
  local isRet = false
  local info = buff.info
  for i, effect in ipairs(info["Control Effects"]) do
    if negative_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

function GuildMountControl.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if owner.GuildMountControled == true then
    dmg = dmg * 1.07
  end
  return dmg
end

function GuildMountControl.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  owner.GuildMountControled = false
  for i, tbuff in ipairs(owner.buff_list) do
    if GuildMountControl.controleffect(tbuff) then
      owner.GuildMountControled = true
      break
    end
  end
end

function GuildMountControl.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountControl.createBuff)
  return skill
end

return GuildMountControl.init_fieldSkill
