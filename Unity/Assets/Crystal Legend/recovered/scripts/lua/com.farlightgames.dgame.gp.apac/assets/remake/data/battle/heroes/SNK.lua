module("ed.battlehero", package.seeall)
local ed = ed
SNK = {}
SNK.Evopasv2buff = 10001903
SNK.Evoultbuff = 10001904
SNK.Birth = 10001905
SNK.fashion_id_1 = 191

function SNK.onDying(basefunc, self, killer)
  local skill = self.skills.SNK_pasv2
  local unrebirth = ed.engine.guildInstance_mode and self.camp == ed.emCampEnemy
  if skill and self.custom_data ~= 1 and not unrebirth then
    if skill.evo_rank and skill.evo_rank >= 3 then
      self.rebirth_timer_SNK = 0
    else
      self.rebirth_timer_SNK = 2.5
    end
    self.unitonDying = true
    self.custom_data = 1
    self.state = ed.emUnitState_Birth
    local buff = skill.info.buff_info
    self:addBuff(buff, self)
    local list = self.buff_list
    local debuff_list = {}
    for i = 1, #list do
      local buff = list[i]
      if buff and buff.caster ~= self then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      debuff_list[i].timer = -1
    end
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 1
    self.mp = 0
    self:setAction("Death", false, true)
  else
    basefunc(self, killer)
  end
end

function SNK.hero_reset(basefunc, hero)
  local skillult = hero.skills.SNK_ult
  basefunc(hero)
  hero.custom_data = nil
end

function SNK.onActionFinished(basefunc, self)
  if not self.rebirth_timer_SNK then
    basefunc(self)
  end
end

function SNK.update(basefunc, self, dt)
  basefunc(self, dt)
  if not self:isAlive() then
    return
  end
  if self.rebirth_timer_SNK then
    self.rebirth_timer_SNK = self.rebirth_timer_SNK - dt
    if self.rebirth_timer_SNK <= 0 then
      self.rebirth_timer_SNK = nil
      local skill = self.skills.SNK_pasv2
      local hp = (0.1 * self.attribs.HP + skill.info["Basic Num"]) * (self.config.hp_mod or 1)
      if skill.evo_rank and 1 <= skill.evo_rank then
        hp = hp + skill.evo_rank1["Script Arg1"]
      end
      if skill.evo_rank and skill.evo_rank >= 2 then
        hp = hp + skill.evo_rank2["Script Arg1"]
      end
      self:setHP(hp)
      self:summon()
      self.unitonDying = false
      for i, tbuff in ipairs(self.buff_list) do
        if tbuff.info.ID == 10001902 then
          local buff = tbuff
          buff.timer = -1
          break
        end
      end
      local bid = SNK.Birth
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, self, self)
      self:addBuff(buff, self)
      if skill.evo_rank and skill.evo_rank >= 3 then
        local bid = SNK.Evopasv2buff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, self, self)
        self:addBuff(buff, self)
      end
    end
  end
end

function SNK.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, ret = basefunc(self, source, target, damage_type)
  local caster = self.caster
  local add_power = (caster.attribs.HP - caster.hp) * self.evo_rank3["Script Arg1"]
  if caster.config.is_monster then
    add_power = math.min(5000, add_power)
  end
  power = power + add_power
  return power, ret
end

function SNK.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.onRemoved = override(buff.onRemoved, SNK.skillultbuff_onRemoved)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function SNK.skillultbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  local bid = SNK.Evoultbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, caster)
  owner:addBuff(buff, caster)
end

function SNK.init_hero(hero)
  hero.reset = override(hero.reset, SNK.hero_reset)
  local skillult = hero.skills.SNK_ult
  local skillatk2 = hero.skills.SNK_atk2
  local skillpasv2 = hero.skills.SNK_pasv2
  local skillpasv = hero.aura_skill_list[1]
  if skillult then
    if SNK.fashion_id_1 and SNK.fashion_id_1 == hero.fashion_id then
      if skillult.evo_rank and 1 <= skillult.evo_rank then
        skillult.info = ed.wraptable(skillult.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"],
          ["Tile Art"] = "eff_tile_SNK_ult2_fashion_1.cha"
        })
      else
        skillult.info = ed.wraptable(skillult.info, {
          ["Tile Art"] = "eff_tile_SNK_ult2_fashion_1.cha"
        })
      end
    elseif skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    skillult.createBuff = override(skillult.createBuff, SNK.skillult_createBuff)
  end
  if skillpasv2 then
    hero.onDying = override(hero.onDying, SNK.onDying)
    hero.onActionFinished = override(hero.onActionFinished, SNK.onActionFinished)
    hero.update = override(hero.update, SNK.update)
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
      skillatk2.info["Do Crit"] = "YES"
      skillatk2.power = override(skillatk2.power, SNK.skillatk2_power)
    end
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    local num = skillpasv["Basic Num"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
  end
  return hero
end

return SNK.init_hero
