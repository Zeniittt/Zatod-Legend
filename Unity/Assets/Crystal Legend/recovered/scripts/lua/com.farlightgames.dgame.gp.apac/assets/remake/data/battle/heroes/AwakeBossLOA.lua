module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossLOA = {}
AwakeBossLOA.skillFashionId = 421
AwakeBossLOA.skillFashionIdCM = 121

function AwakeBossLOA.skillult_takeEffectOn(basefunc, skill, target, source)
  local originfo = skill.info
  local caster = skill.caster
  local emratio = 3
  if target.camp ~= skill.caster.camp then
    skill.info = ed.wraptable(originfo, {
      ["Damage Type"] = "AP",
      ["Basic Num"] = originfo["Basic Num"] * emratio,
      ["Plus Ratio"] = originfo["Plus Ratio"] * emratio
    })
  end
  basefunc(skill, target, source)
  skill.info = originfo
end

function AwakeBossLOA.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, AwakeBossLOA.atk2buff_onDamaged)
  buff.onRemoved = override(buff.onRemoved, AwakeBossLOA.atk2buff_onRemoved)
  return buff
end

function AwakeBossLOA.atk2buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local caster = buff.owner
  local remaindamage = basefunc(buff, damage, damage_type, source, skill)
  local power = damage - remaindamage
  if 0 < power then
    caster:takeHeal(power, "hp")
    if caster.actor then
      caster.actor:addEffect("eff_impact_heal.cha", 0)
    end
  end
  return remaindamage
end

function AwakeBossLOA.atk2buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  owner.AwakeBossLOA_atk2_buff = nil
end

function AwakeBossLOA.update(basefunc, hero, dt)
  basefunc(hero, dt)
  hero.AwakeBossLOA_atk2_buff = nil
  for i, tbuff in ipairs(hero.buff_list) do
    if tbuff.info.ID == 10036001 then
      hero.AwakeBossLOA_atk2_buff = tbuff
    end
  end
  if not hero.buff_effects.noHPR and hero.AwakeBossLOA_atk2_buff then
    local hp_regen = hero.attribs.HPR
    if hp_regen < 0 then
      local dotres
      if hero.attribs.DOTRES then
        dotres = hero.attribs.DOTRES
      else
        dotres = 0
      end
      local atk2hprheal = -hp_regen * (1 - math.min(dotres / 100, 0.99)) * dt
      if hero.AwakeBossLOA_atk2_buff.shield and atk2hprheal <= hero.AwakeBossLOA_atk2_buff.shield then
        if not hero.buff_effects.unheal then
          hero:setHP(hero.hp + atk2hprheal * 2 + atk2hprheal * math.max((hero.attribs.HealRatio or 0) / 100, -1))
          if hero.AwakeBossLOA_atk2_buff.shield then
            hero.AwakeBossLOA_atk2_buff.shield = hero.AwakeBossLOA_atk2_buff.shield - atk2hprheal
          end
          if 0 >= hero.AwakeBossLOA_atk2_buff.shield then
            hero.AwakeBossLOA_atk2_buff.timer = -1
          end
        end
      elseif hero.AwakeBossLOA_atk2_buff.shield and atk2hprheal > hero.AwakeBossLOA_atk2_buff.shield then
        atk2hprheal = hero.AwakeBossLOA_atk2_buff.shield
        if not hero.buff_effects.unheal then
          hero:setHP(hero.hp + atk2hprheal * 2 + atk2hprheal * math.max((hero.attribs.HealRatio or 0) / 100, -1))
          if hero.AwakeBossLOA_atk2_buff.shield then
            hero.AwakeBossLOA_atk2_buff.shield = hero.AwakeBossLOA_atk2_buff.shield - atk2hprheal
          end
          if 0 >= hero.AwakeBossLOA_atk2_buff.shield then
            hero.AwakeBossLOA_atk2_buff.timer = -1
          end
        end
      end
    end
  end
end

function AwakeBossLOA.reset(basefunc, unit)
  basefunc(unit)
  unit.AwakeBossLOA_atk2_buff = nil
end

function AwakeBossLOA.skillatk3_buffonDamaged(basefunc, buff, damage, damage_type, source)
  local skill = buff.caster.skills.AwakeBossLOA_atk3
  local originfo = skill.info
  local caster = buff.caster
  local owner = buff.owner
  skill.info = ed.wraptable(originfo, {
    ["Affected Camp"] = -1,
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = 200,
    ["Damage Type"] = "AP",
    ["Buff ID"] = 0,
    ["Point Effect"] = "eff_point_DR_atk3.cha",
    ["Impact Effect"] = "eff_impact_LOA_atk2.cha"
  })
  skill:takeEffectAt(owner.position, caster)
  skill.info = originfo
  return basefunc(buff, damage, damage_type, source)
end

function AwakeBossLOA.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  local owner = buff.owner
  local fashionId = caster.fashion_id
  local skillLV = caster.skills.AwakeBossLOA_atk3.level
  local shield = buff.shield
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.shield = buff.shield + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.shield = buff.shield + skill.evo_rank2["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    local list = owner.buff_list
    local debuff_list = {}
    local my_camp = owner.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      owner:removeBuff(debuff_list[i])
    end
  end
  buff.onDamaged = override(buff.onDamaged, AwakeBossLOA.skillatk3_buffonDamaged)
  return buff
end

function AwakeBossLOA.init_hero(hero)
  local skillult = hero.skills.AwakeBossLOA_ult
  local skillatk2 = hero.skills.AwakeBossLOA_atk2
  local skillatk3 = hero.skills.AwakeBossLOA_atk3
  local skillaura = hero.aura_skill_list[1]
  hero.update = override(hero.update, AwakeBossLOA.update)
  hero.reset = override(hero.reset, AwakeBossLOA.reset)
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossLOA.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, AwakeBossLOA.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossLOA.skillatk3_createBuff)
  end
  return hero
end

return AwakeBossLOA.init_hero
