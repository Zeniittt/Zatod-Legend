module("ed.battlehero", package.seeall)
local ed = ed
NightmareGuild = {}
NightmareGuild.Monster_dmgBuff = 4516
NightmareGuild.Monster_dmgdownBuff = 4517

function NightmareGuild.skill_update(basefunc, skill, dt_action, dt_cd)
  print("NightmareGuild.skill_update_1")
  basefunc(skill, dt_action, dt_cd)
  local field = skill.caster
  local battledata_damageBid = NightmareGuild.Monster_dmgBuff
  local binfo = ed.lookupDataTable("Buff", nil, battledata_damageBid)
  field.StarTime = field.StarTime + dt_action
  if not skill.Monster_dmgBuff then
    for unit in ed.engine:foreachAliveUnit(field.camp) do
      local buff = ed.BuffCreate(binfo, unit, field)
      buff.onDamaged = override(buff.onDamaged, NightmareGuild.Monster_dmgBuff_onDamaged)
      buff:setAttribute("CON", 100)
      buff:setAttribute("TEN ", 100)
      buff:setAttribute("CRITRES ", 10000)
      buff:setAttribute("MCRITRES ", 10000)
      buff:setAttribute("CSDR ", 100)
      buff:setAttribute("MCSDR ", 100)
      unit:addBuff(buff, field)
    end
    skill.Monster_dmgBuff = true
  end
  local battle_dmgdownBid = NightmareGuild.Monster_dmgdownBuff
  local binfo = ed.lookupDataTable("Buff", nil, battle_dmgdownBid)
  if field.StarTime and field.StarTime >= 10 then
    for unit in ed.engine:foreachAliveUnit(-field.camp) do
      local buff = ed.BuffCreate(binfo, unit, field)
      unit:addBuff(buff, field)
    end
    field.StarTime = 0
  end
end

function NightmareGuild.Monster_dmgBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  if dmg and source and dmg > owner.attribs.HP * 0.2 then
    local bid = 4007
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, source, owner)
    source:hurt()
    source:addBuff(buff, owner)
  end
  return dmg
end

function NightmareGuild.init_fieldSkill(skill)
  print("1")
  local caster = skill.caster
  caster.StarTime = 0
  skill.Monster_dmgBuff = false
  skill.Monster_dmgdownBuff = false
  skill.update = override(skill.update, NightmareGuild.skill_update)
  return skill
end

return NightmareGuild.init_fieldSkill
