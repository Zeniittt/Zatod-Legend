module("ed.battlehero", package.seeall)
local ed = ed
DruidBear = {}
DruidBear.TitanDruid_fashion_ID = 100761
DruidBear.atk3enemy = 11007616

function DruidBear.Bear_setHP(basefunc, unit, hp, reason)
  local localDruid = unit.config.summoner
  local skillatk2 = localDruid.skills.TitanDruid_atk2
  if hp <= 0 then
    hp = 1
    unit:setAction("Idle", true, true)
    local binfo = ed.lookupDataTable("Buff", nil, 11007615)
    local buff = ed.BuffCreate(binfo, unit, unit)
    if skillatk2 and skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      buff:setAttribute("HPR.a", 0.1)
    end
    unit:addBuff(buff, unit)
    if buff then
      buff.timer = 999
      buff.update = override(buff.update, DruidBear.DyingBuff_update)
      buff.onRemoved = override(buff.onRemoved, DruidBear.DyingBuff_onRemoved)
    end
    for i, ubuff in ipairs(unit.buff_list) do
      if 0 > ubuff.info.HPR then
        ubuff.timer = 0
      end
    end
    unit.walk_v = {0, 0}
    unit.DruidBear_Dying = true
  end
  basefunc(unit, hp, reason)
end

function DruidBear.DyingBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.hp == buff.owner.attribs.HP then
    buff.timer = 0
  end
end

function DruidBear.DyingBuff_onRemoved(basefunc, buff)
  buff.owner.DruidBear_Dying = false
  buff.owner.unitonDying = false
  buff.owner:setAction("Idle", true, true)
  basefunc(buff)
end

function DruidBear.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  local caster = skill.caster
  local localDruid = caster.config.summoner
  local skillatk3 = localDruid.skills.TitanDruid_atk3
  if skillatk3 and skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
    local bid1 = DruidBear.atk3enemy
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, target, caster)
    buff1:setAttribute("AD", -skillatk3.evo_rank3["Script Arg1"])
    buff1:setAttribute("AP", -skillatk3.evo_rank3["Script Arg1"])
    target:addBuff(buff1, caster)
  end
  return buff
end

function DruidBear.skilltransform_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  if DruidBear.TitanDruid_fashion_ID and DruidBear.TitanDruid_fashion_ID == caster.father.fashion_id then
    skill.caster:enterActionStageFromOneStage(skill.caster.DruidBear_rank + 5, 266)
  else
    skill.caster:enterActionStageFromOneStage(skill.caster.DruidBear_rank, 266)
  end
end

function DruidBear.init_hero(hero)
  local skillatk = hero.skills.DruidBear_atk
  local skillatk3 = hero.skills.DruidBear_atk3
  local skilltransform = hero.skills.DruidBear_transform
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, DruidBear.skillatk3_createBuff)
  end
  if skilltransform then
    skilltransform.takeEffectAt = override(skilltransform.takeEffectAt, DruidBear.skilltransform_takeEffectAt)
  end
  hero.setHP = override(hero.setHP, DruidBear.Bear_setHP)
  return hero
end

return DruidBear.init_hero
