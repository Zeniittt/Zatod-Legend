module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossDP = {}
AwakeBossDP.interval = 0.375

function AwakeBossDP.ult_buff_update(basefunc, self, dt)
  local buff = self
  local owner = buff.owner
  local skillult = buff.owner.skills.AwakeBossDP_ult
  buff.second_timer = buff.second_timer - dt
  if buff.second_timer > 1.5 and buff then
    local timer = buff.attack_timer - dt
    while timer <= 0 do
      timer = timer + AwakeBossDP.interval
      local skill = buff.caster.skills.AwakeBossDP_ult
      local originfo = skill.info
      local origtarget = skill.target
      skill.info = ed.wraptable(originfo, {
        ["Buff ID"] = 0,
        ["Damage Type"] = "AP",
        ["Target Camp"] = -1,
        ["Affected Camp"] = -1,
        ["Target Type"] = "random"
      })
      local target = skill:selectTarget()
      if target then
        local succ, dmg = skill:takeEffectOn(target, skill.caster)
        buff.total_times = buff.total_times + 1
        if dmg then
          local coefficient = 1
          buff.total_dmg = buff.total_dmg + dmg
          owner.buff_total_dmg = buff.total_dmg
          local MP_damage = 10
          if owner.level >= 100 then
            MP_damage = 4.5
          end
          if owner.level >= 105 then
            MP_damage = 9.5
          end
          if owner.level >= 110 then
            MP_damage = 13.75
          end
          if owner.level >= 115 then
            MP_damage = 18.5
          end
          target:takeDamage(MP_damage, "Holy", "mp", owner)
          owner:takeHeal(dmg * 0.3, "hp", owner)
        end
      end
      skill.info = originfo
      skill.target = origtarget
    end
    buff.attack_timer = timer
  end
  if buff.second_timer == 1 and ed.run_with_scene then
    ed.scene:removeEffect(buff.origin_effect, -1)
  end
  basefunc(buff, dt)
end

function AwakeBossDP.ult_buff_onRemoved(basefunc, buff)
  local skillult = buff.owner.skills.AwakeBossDP_ult
  local hprpro = 0.65
  buff.owner:takeHeal(buff.total_dmg * hprpro, "hp", buff.owner)
  if buff.second_timer > 0 and ed.run_with_scene then
    ed.scene:removeEffect(buff.origin_effect, -1)
  end
  buff.second_timer = 10
  basefunc(buff)
end

function AwakeBossDP.skillult_takeEffectOn(basefunc, self, target, source, shift)
  if target == self.caster and not self.caster.AwakeBossDP_ult_buff then
    local buff = self.caster:addBuff(self:createBuff(self.caster))
    if buff then
      self.caster.AwakeBossDP_ult_buff = buff
    end
  else
    return basefunc(self, target, source, shift)
  end
end

function AwakeBossDP.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = AwakeBossDP.interval
  buff.total_dmg = 0
  buff.total_times = 0
  buff.second_timer = 10
  if ed.run_with_scene then
    local effect_name = "eff_buff_DP_ult.cha"
    if not effect_name then
      return
    end
    local effect_z = -1
    buff.origin_effect = ed.scene:playEffectOnScene(effect_name, buff.owner.position, {
      buff.owner.direction,
      1
    }, nil, effect_z)
  end
  buff.update = override(buff.update, AwakeBossDP.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, AwakeBossDP.ult_buff_onRemoved)
  return buff
end

function AwakeBossDP.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("MR", -skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function AwakeBossDP.init_hero(hero)
  local skillult = hero.skills.AwakeBossDP_ult
  local skillatk2 = hero.skills.AwakeBossDP_atk2
  local skillatk3 = hero.skills.AwakeBossDP_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    skillult.createBuff = override(skillult.createBuff, AwakeBossDP.skillult_createBuff)
    skillult.takeEffectOn = override(skillult.takeEffectOn, AwakeBossDP.skillult_takeEffectOn)
  end
  if skillatk2 then
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossDP.skillatk3_createBuff)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return AwakeBossDP.init_hero
