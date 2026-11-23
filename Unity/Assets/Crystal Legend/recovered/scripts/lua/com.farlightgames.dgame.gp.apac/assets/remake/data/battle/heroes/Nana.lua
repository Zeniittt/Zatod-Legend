module("ed.battlehero", package.seeall)
local ed = ed
Nana = {}

function Nana.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 3 then
    local originfo = skill.info
    local plusratio = 1
    local damagetype = "AD"
    if skill.evo_rank and 1 <= skill.evo_rank then
      plusratio = skill.evo_rank1["Script Arg1"]
    end
    if skill.evo_rank and skill.evo_rank >= 2 then
      plusratio = skill.evo_rank2["Script Arg1"]
    end
    if skill.evo_rank and 3 <= skill.evo_rank then
      plusratio = skill.evo_rank3["Script Arg1"]
    end
    skill.info = ed.wraptable(originfo, {
      ["Plus Ratio"] = plusratio,
      ["No Dodge"] = true,
      ["Damage Type"] = damagetype
    })
    basefunc(skill)
    skill.info = originfo
    local target = skill.target
    if target and not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
      local buffID = 10009501
      local binfo = ed.lookupDataTable("Buff", nil, buffID)
      local buff = ed.BuffCreate(binfo, target, caster)
      target:addBuff(buff, caster)
      target:hurt()
    end
    skill.attack_counter = skill.attack_counter + 1
  else
    basefunc(skill)
  end
end

function Nana.skillblink_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local hero = skill.caster
  local target = skill.target
  local blink_distance = 42
  if attack_counter == 0 then
    if target then
      local direction = 0 < target.position[1] - hero.position[1] and -1 or 1
      hero.direction = direction
      local position1 = target.position[1] - direction * blink_distance
      if target.buff_effects.stable or 799 < position1 or position1 < 1 then
        position1 = position1 + 2 * direction * blink_distance
        hero.direction = -direction
      end
      hero.position = {
        position1,
        target.position[2]
      }
    end
    skill.attack_counter = skill.attack_counter + 1
    local bid = 10009503
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    hero:addBuff(binfo, hero)
  else
    basefunc(skill)
  end
end

function Nana.skillpasv_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local skillpasv = caster.skills.Nana_pasv
  if skillpasv then
    local HPpercent = target.hp / target.attribs.HP
    local MinPower = skillpasv.info["Basic Num"]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 1 then
      MinPower = MinPower + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      MinPower = MinPower + skillpasv.evo_rank2["Script Arg1"]
    end
    local MaxPower = skillpasv.info["Script Arg2"]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      MaxPower = MaxPower + skillpasv.evo_rank3["Script Arg1"]
    end
    local Power = MaxPower * HPpercent
    if MinPower > Power then
      Power = MinPower
    end
    local originfo = skill.info
    local BasicNum = skill.info["Basic Num"]
    skill.info = ed.wraptable(originfo, {
      ["Basic Num"] = BasicNum + Power
    })
    basefunc(skill, target)
    skill.info = originfo
  elseif not skillpasv then
    basefunc(skill, target)
  end
end

function Nana.skill_selectTarget(basefunc, self, default)
  local selector = self:target_selector()
  if selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      if unit.config.is_summoned then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          if max < v then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
    return self.target
  end
end

function Nana.skillult_takeEffectOn(basefunc, skill, target)
  local hero = skill.caster
  local target = skill.target
  local skillpasv = hero.skills.Nana_pasv
  local originfo = skill.info
  local BasicNum = skill.info["Basic Num"]
  local OverAGI = hero.attribs.AGI - target.attribs.AGI
  if OverAGI <= 0 then
    OverAGI = 0
  end
  local extra_damage = OverAGI * skill.info["Script Arg2"]
  if skillpasv then
    local HPpercent = target.hp / target.attribs.HP
    local MinPower = skillpasv.info["Basic Num"]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 1 then
      MinPower = MinPower + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      MinPower = MinPower + skillpasv.evo_rank2["Script Arg1"]
    end
    local MaxPower = skillpasv.info["Script Arg2"]
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      MaxPower = MaxPower + skillpasv.evo_rank3["Script Arg1"]
    end
    local Power = MaxPower * HPpercent
    if MinPower > Power then
      Power = MinPower
    end
    skill.info = ed.wraptable(originfo, {
      ["Basic Num"] = BasicNum + extra_damage + Power
    })
  elseif not skillpasv then
    skill.info = ed.wraptable(originfo, {
      ["Basic Num"] = BasicNum + extra_damage
    })
  end
  basefunc(skill, target)
  skill.info = originfo
end

function Nana.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local ARM = buff.info.ARM
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("ARM", ARM - skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function Nana.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 10009504
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  owner:addBuff(binfo, owner)
end

function Nana.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 10009504 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function Nana.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  local bid = 10009504
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  owner:addBuff(binfo, owner)
end

function Nana.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 10009504 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function Nana.init_hero(hero)
  local skillult = hero.skills.Nana_ult
  local skillatk = hero.skills.Nana_atk
  local skillatk2 = hero.skills.Nana_atk2
  local skillatk3 = hero.skills.Nana_atk3
  if skillult then
    if skillult.evo_rank and skillult.evo_rank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
    skillult.start = override(skillult.start, Nana.skillult_start)
    skillult.finish = override(skillult.finish, Nana.skillult_finish)
    skillult.selectTarget = override(skillult.selectTarget, Nana.skill_selectTarget)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Nana.skillblink_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, Nana.skillult_takeEffectOn)
  end
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, Nana.skillpasv_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Nana.skillatk2_onAttackFrame)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Nana.skillpasv_takeEffectOn)
  end
  if skillatk3 then
    if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    skillatk3.start = override(skillatk3.start, Nana.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, Nana.skillatk3_finish)
    skillatk3.selectTarget = override(skillatk3.selectTarget, Nana.skill_selectTarget)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Nana.skillblink_onAttackFrame)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, Nana.skillpasv_takeEffectOn)
    skillatk3.createBuff = override(skillatk3.createBuff, Nana.skillatk3_createBuff)
  end
  return hero
end

return Nana.init_hero
