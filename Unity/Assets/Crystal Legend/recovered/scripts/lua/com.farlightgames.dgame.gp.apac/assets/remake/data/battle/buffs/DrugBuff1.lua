local function DrugBuff1_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  if buff.isTrigged then
    local owner = buff.owner
    local target = owner.basic_skill:selectTarget()
    if target and owner.hp / owner.attribs.HP < 0.5 then
      buff.isTrigged = false
      local drug = ed.getDataTable("SoloCardSkill")[52]["Level Arg 1"][1]
      target:addDrug(drug, {type = 1, id = 52}, owner)
      target:takeDrugDamage()
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_solo_card52.cha", target.position, {
          target.direction,
          1
        }, nil, 1)
      end
    end
  end
end

local function initBuff(buff)
  buff.isTrigged = true
  buff.update = override(buff.update, DrugBuff1_update)
  return buff
end

return initBuff
