local function AttackBuff6_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  
  local ownerskill = owner.basic_skill
  local target = ownerskill:selectTarget()
  if target and skill == target.basic_skill then
    local AttackBuff6_values = ed.getDataTable("SoloCardSkill")[6]["Level Arg 1"]
    if ed.rand() <= AttackBuff6_values[buff.rank] / 100 then
      if ed.run_with_scene then
        ed.PopupCreate(T("\232\144\189\231\169\186"), ccc3(255, 244, 117), owner.actor, nil, "solo")
      end
      damage = 0
    end
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, AttackBuff6_onDamaged)
  return buff
end

return initBuff
