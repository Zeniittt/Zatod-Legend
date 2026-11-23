module("ed.battlehero", package.seeall)
local ed = ed
ArcanaTrial = {}
ArcanaTrial.MonitorBuff = 4257
ArcanaTrial.ragelosthp = 100000
ArcanaTrial.stage2hp = 50000000
ArcanaTrial.stage2ragelosthp = 400000

function ArcanaTrial.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local field = skill.caster
  if skill and not skill.Boss_hasBuff then
    local bid = ArcanaTrial.MonitorBuff
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    for unit in ed.engine:foreachAliveUnit(field.camp) do
      if unit.config.is_boss and not unit.config.is_summoned then
        local buff = ed.BuffCreate(binfo, unit, field)
        buff:setAttribute("LFSRatio", -9999)
        buff.update = override(buff.update, ArcanaTrial.MonitorBuff_update)
        unit:addBuff(buff, field)
        field.Start_Time = 0
        skill.Boss_hasBuff = true
      end
    end
  end
end

function ArcanaTrial.MonitorBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  caster.Start_Time = 0
  caster.Start_Time = caster.Start_Time and caster.Start_Time + dt or dt
  if caster.Start_Time > 0 and owner.camp == caster.camp then
    if not owner.lastRageHp then
      owner.lastRageHp = owner.hp
    end
    while owner.lastRageHp - owner.hp >= ArcanaTrial.ragelosthp do
      local binfo
      local bid = 219
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      owner:addBuff(binfo, owner)
      owner.lastRageHp = owner.lastRageHp - ArcanaTrial.ragelosthp
    end
  end
end

function ArcanaTrial.init_fieldSkill(skill)
  skill.Boss_hasBuff = false
  skill.update = override(skill.update, ArcanaTrial.skill_update)
  return skill
end

return ArcanaTrial.init_fieldSkill
