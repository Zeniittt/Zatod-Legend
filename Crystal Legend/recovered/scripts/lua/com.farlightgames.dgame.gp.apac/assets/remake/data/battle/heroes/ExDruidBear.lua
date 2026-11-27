module("ed.battlehero", package.seeall)
local ed = ed
ExDruidBear = {}
ExDruidBear.TitanDruid_fashion_ID = 100761

function ExDruidBear.Bear_setHP(basefunc, unit, hp, reason)
  local localDruid = unit.config.summoner
  local skillatk2 = localDruid.skills.TitanDruid_atk2
  if hp < 0 then
    hp = 1
    unit:setAction("Death2", true, true)
    local binfo = ed.lookupDataTable("Buff", nil, 11007615)
    local buff = ed.BuffCreate(binfo, unit, unit)
    if skillatk2 and skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      buff:setAttribute("HPR.a", 0.1)
    end
    unit:addBuff(buff, unit)
    if buff then
      buff.timer = 999
      buff.update = override(buff.update, ExDruidBear.DyingBuff_update)
      buff.onRemoved = override(buff.onRemoved, ExDruidBear.DyingBuff_onRemoved)
    end
    for i, ubuff in ipairs(unit.buff_list) do
      if 0 > ubuff.info.HPR then
        ubuff.timer = 0
      end
    end
    unit.ExDruidBear_Dying = true
  end
  basefunc(unit, hp, reason)
end

function ExDruidBear.DyingBuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.hp == buff.owner.attribs.HP then
    buff.timer = 0
  end
end

function ExDruidBear.DyingBuff_onRemoved(basefunc, buff)
  buff.owner.ExDruidBear_Dying = false
  buff.owner:setAction("Idle", true, true)
  basefunc(buff)
end

function ExDruidBear.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  local caster = skill.caster
  local localDruid = caster.config.summoner
  local skillatk3 = localDruid.skills.TitanDruid_atk3
  if skillatk3 and skillatk3.evo_rank and skillatk3.evo_rank > 3 then
    buff:setAttribute("AD", -skillatk3.evo_rank3["Script Arg1"])
    buff:setAttribute("AP", -skillatk3.evo_rank3["Script Arg1"])
  end
  return buff
end

function ExDruidBear.skilltransform_takeEffectAt(basefunc, skill, location, source)
  basefunc(skill, location, source)
  local caster = skill.caster
  if ExDruidBear.TitanDruid_fashion_ID and ExDruidBear.TitanDruid_fashion_ID == caster.father.fashion_id then
    skill.caster:enterActionStageFromOneStage(skill.caster.ExDruidBear_rank + 5, 337)
  else
    skill.caster:enterActionStageFromOneStage(skill.caster.ExDruidBear_rank, 337)
  end
end

function ExDruidBear.init_hero(hero)
  local skillatk = hero.skills.ExDruidBear_atk
  local skillatk3 = hero.skills.ExDruidBear_atk3
  local skilltransform = hero.skills.ExDruidBear_transform
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, ExDruidBear.skillatk3_createBuff)
  end
  if skilltransform then
    skilltransform.takeEffectAt = override(skilltransform.takeEffectAt, ExDruidBear.skilltransform_takeEffectAt)
  end
  hero.setHP = override(hero.setHP, ExDruidBear.Bear_setHP)
  return hero
end

return ExDruidBear.init_hero
