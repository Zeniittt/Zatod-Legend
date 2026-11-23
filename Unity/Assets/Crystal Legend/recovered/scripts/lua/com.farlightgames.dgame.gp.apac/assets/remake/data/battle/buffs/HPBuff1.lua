local function onWillDie(buff, hp)
  local owner = buff.owner
  
  owner:takeHeal(owner.attribs.HP * ed.getDataTable("SoloCardSkill")[22]["Level Arg 1"][1] / 100, "hp", owner, nil, {type = 1, id = 22})
  owner.drugValue = 0
  owner.frozenValue = 0
  buff.timer = -1
  local list = owner.buff_list
  local debuff_list = {}
  local my_camp = owner.camp
  for i = 1, #list do
    local buffs = list[i]
    if buffs and buffs.caster and buffs.caster.camp ~= my_camp and buffs.info.Dispel == "YES" then
      debuff_list[#debuff_list + 1] = buffs
    end
  end
  for i = 1, #debuff_list do
    owner:removeBuff(debuff_list[i])
  end
  if ed.run_with_scene then
    local effect_name_1 = "eff_point_solo_card22_1.cha"
    ed.scene:playEffectOnScene(effect_name_1, owner.position, {
      owner.direction * 1.4,
      1.4
    }, nil, 1)
    local effect_name_2 = "eff_point_solo_card22_2.cha"
    ed.scene:playEffectOnScene(effect_name_2, owner.position, {
      owner.direction * 1.4,
      1.4
    }, nil, -1)
  end
  return owner.hp
end

local function initBuff(buff)
  function buff.onWillDie(hp)
    return onWillDie(buff, hp)
  end
  
  return buff
end

return initBuff
