module("ed.battlehero", package.seeall)
local ed = ed
TH = {}
TH.threshold = 0.15

function TH.update(basefunc, self, dt)
  basefunc(self, dt)
  local cur_hp = self.hp
  local last_hp = self.last_hp
  if cur_hp >= last_hp then
    self.last_hp = cur_hp
    return
  end
  local hp_max = self.attribs.HP
  if last_hp - cur_hp >= hp_max * self.threshold then
    if not self.buff_effects.doom then
      local list = self.buff_list
      local debuff_list = {}
      local my_camp = self.camp
      for i = 1, #list do
        local buff = list[i]
        if buff and (not buff.caster or buff.caster.camp ~= my_camp) and buff.info.Dispel == "YES" then
          debuff_list[#debuff_list + 1] = buff
        end
      end
      for i = 1, #debuff_list do
        self:removeBuff(debuff_list[i])
      end
      if not self.buff_effects.stunbyself then
        self:skill_waterEffect()
      end
    end
    self.last_hp = cur_hp
  end
end

function TH:skill_waterEffect()
  if ed.run_with_scene then
    local effect_name = "eff_point_TH_awake.cha"
    if effect_name then
      local effect_z = 1
      local pos = self.position
      ed.scene:playEffectOnScene(effect_name, {
        pos[1],
        pos[2] - 1
      }, {
        self.direction,
        1
      }, nil, effect_z)
    end
  end
end

function TH.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function TH.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function TH.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function TH.init_hero(hero)
  local skillult = hero.skills.TH_ult
  local skillatk2 = hero.skills.TH_atk2
  local skillatk3 = hero.skills.TH_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TH.skillult_createBuff)
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
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, TH.skillatk2_createBuff)
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
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TH.skillatk3_createBuff)
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
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
      hero.last_hp = hero.hp
      hero.update = override(hero.update, TH.update)
      hero.skill_waterEffect = TH.skill_waterEffect
      hero.threshold = TH.threshold
    end
    hero:rebuild()
  end
  return hero
end

return TH.init_hero
