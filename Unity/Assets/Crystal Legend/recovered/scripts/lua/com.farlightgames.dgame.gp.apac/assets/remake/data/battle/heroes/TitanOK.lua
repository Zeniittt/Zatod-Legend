module("ed.battlehero", package.seeall)
local ed = ed
TitanOK = {}
TitanOK.TitanOK_atk3_ratio = 0.4

function TitanOK.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.TitanOK_atkMiss_count = 0
  hero:setPosition({
    400 - 200 * hero:getInitDir(),
    0
  })
  hero.direction = hero:getInitDir()
end

function TitanOK.skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.TitanOK_hasArcana > 1 and caster.TitanOK_atkMiss_count >= 3 then
    skill.info["Ignore Target Type"] = "summon"
    skill.info["No Dodge"] = true
  end
end

function TitanOK.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanOK_atk4
  local skillRemnant = caster.skills.TitanOK_Remnant1
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  skill.info["No Dodge"] = false
  skill.info["Ignore Target Type"] = nil
  if not ret and skillatk4 then
    local binfo = skillatk4:createBuff(caster)
    if skillRemnant and binfo.info.ARM and binfo.info.MR then
      local ARM = binfo.info.ARM
      local MR = binfo.info.MR
      binfo.info.ARM = ARM * 1.25
      binfo.info.MR = MR * 1.25
      local buff = caster:addBuff(binfo, caster)
    else
      local buff = caster:addBuff(binfo, caster)
    end
  end
  if not ret and caster.TitanOK_atkMiss_count and caster.TitanOK_atkMiss_count <= 2 then
    caster.TitanOK_atkMiss_count = caster.TitanOK_atkMiss_count + 1
  elseif ret and caster.TitanOK_atkMiss_count then
    caster.TitanOK_atkMiss_count = 0
  end
  return ret, dmg, Crit, lfs_amount
end

function TitanOK.skillatk_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  power = power * (1 + caster.TitanOK_atkMiss_count * 1.5)
  return power
end

function TitanOK.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.shield = buff.shield + caster.attribs.HP * TitanOK.TitanOK_atk3_ratio
  local orig_shield = buff.shield
  buff.orig_shield = orig_shield
  if caster.TitanOK_hasArcana > 3 then
    buff.onRemoved = override(buff.onRemoved, TitanOK.skillatk3_buff_onRemoved)
  end
  return buff
end

function TitanOK.skillatk3_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  local mp
  if buff.shield <= 0 then
    mp = 300
  else
    mp = 300 * (buff.orig_shield - buff.shield) / buff.orig_shield
  end
  owner:takeHeal(mp, "mp", caster)
end

function TitanOK.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  basefunc(skill, target, source, shift)
  local caster = skill.caster
  if caster.TitanOK_hasArcana > 2 and target and target:isAlive() then
    local bid = 1708
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
  end
end

function TitanOK.skillult_canCastWithTarget(basefunc, skill, target)
  local result, reason = basefunc(skill, target)
  local caster = skill.caster
  if result and (caster.mp <= 500 or caster.TitanOK_ult_region or caster.current_skill == caster.skills.TitanOK_ult) then
    result = false
  end
  return result, reason
end

function TitanOK.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillults = caster.skills.TitanOK_ults
  skillults.target = caster
  local region = skillults:createRegion()
  caster.TitanOK_ult_region = region
  ed.engine:addRegion(region)
end

function TitanOK.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanOK.skillult_buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanOK.skillult_buff_onRemoved)
  return buff
end

function TitanOK.skillult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  if caster.mp <= 50 then
    buff.timer = 0
  end
end

function TitanOK.skillult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster.TitanOK_ult_region then
    caster.TitanOK_ult_region:terminate()
    caster.TitanOK_ult_region = nil
  end
end

function TitanOK.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 1709
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanOK.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 1709 then
      tbuff.timer = 0
    end
  end
end

function TitanOK.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, TitanOK.skillults_buff_onDamaged)
  return buff
end

function TitanOK.skillults_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  if not transferred then
    local caster = buff.caster
    local skillult = caster.skills.TitanOK_ult
    local reduce_ratio = skillult.info["Script Arg2"] / 100
    local remain_lost = lost * (1 - reduce_ratio)
    caster:takeDamage(remain_lost * 0.5, "Holy", "hp", source, 1, 0, true)
    return remain_lost * 0.5
  end
  return lost
end

function TitanOK.init_hero(hero)
  local skillult = hero.skills.TitanOK_ult
  local skillults = hero.skills.TitanOK_ults
  local skillatk = hero.skills.TitanOK_atk
  local skillatk2 = hero.skills.TitanOK_atk2
  local skillatk3 = hero.skills.TitanOK_atk3
  local skillatk4 = hero.skills.TitanOK_atk4
  hero.TitanOK_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk and skillatk4 then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanOK.skillatk_takeEffectOn)
    skillatk.power = override(skillatk.power, TitanOK.skillatk_power)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanOK.skillatk3_createBuff)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanOK.skillatk3_takeEffectOn)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanOK.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanOK.skillult_canCastWithTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanOK.skillult_onAttackFrame)
    skillult.start = override(skillult.start, TitanOK.skillult_start)
    skillult.finish = override(skillult.finish, TitanOK.skillult_finish)
    if skillults then
      skillults.createBuff = override(skillults.createBuff, TitanOK.skillults_createBuff)
    end
  end
  hero.reset = override(hero.reset, TitanOK.hero_reset)
  return hero
end

return TitanOK.init_hero
