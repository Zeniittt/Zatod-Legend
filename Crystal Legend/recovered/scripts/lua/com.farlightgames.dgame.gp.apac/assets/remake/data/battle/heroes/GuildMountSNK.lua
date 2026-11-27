module("ed.battlehero", package.seeall)
local ed = ed
GuildMountSNK = {}
GuildMountSNK.Evopasv2buff = 10035303
GuildMountSNK.Evoultbuff = 10035304
GuildMountSNK.Birth = 10035305
GuildMountSNK.fashion_id_1 = 191

function GuildMountSNK.onDying(basefunc, self, killer)
  local skill = self.skills.GuildMountSNK_pasv2
  local unrebirth = ed.engine.guildInstance_mode and self.camp == ed.emCampEnemy
  if skill and self.custom_data ~= 1 and not unrebirth then
    if skill.evo_rank and skill.evo_rank >= 3 then
      self.rebirth_timer_GuildMountSNK = 0
    else
      self.rebirth_timer_GuildMountSNK = 2.5
    end
    self.custom_data = 1
    self.state = ed.emUnitState_Birth
    local buff = skill.info.buff_info
    self:addBuff(buff, self)
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.caster ~= self then
        local buff = tbuff
        buff.timer = -1
      end
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

function GuildMountSNK.hero_reset(basefunc, hero)
  local skillult = hero.skills.GuildMountSNK_ult
  hero.InitAD = hero.attribs.AD
  hero.InitARM = hero.attribs.ARM
  hero.InitMR = hero.attribs.MR
  basefunc(hero)
  hero.custom_data = nil
  hero.is_PowerUP = false
end

function GuildMountSNK.onActionFinished(basefunc, self)
  if not self.rebirth_timer_GuildMountSNK then
    basefunc(self)
  end
end

function GuildMountSNK.update(basefunc, self, dt)
  basefunc(self, dt)
  if not self:isAlive() then
    return
  end
  if self.rebirth_timer_GuildMountSNK then
    self.rebirth_timer_GuildMountSNK = self.rebirth_timer_GuildMountSNK - dt
    if self.rebirth_timer_GuildMountSNK <= 0 then
      self.rebirth_timer_GuildMountSNK = nil
      local skill = self.skills.GuildMountSNK_pasv2
      local hp = (0.1 * self.attribs.HP + skill.info["Basic Num"]) * (self.config.hp_mod or 1)
      if skill.evo_rank and 1 <= skill.evo_rank then
        hp = hp + skill.evo_rank1["Script Arg1"]
      end
      if skill.evo_rank and skill.evo_rank >= 2 then
        hp = hp + skill.evo_rank2["Script Arg1"]
      end
      self:setHP(hp)
      self:summon()
      for i, tbuff in ipairs(self.buff_list) do
        if tbuff.info.ID == 10035302 then
          local buff = tbuff
          buff.timer = -1
          break
        end
      end
      local bid = GuildMountSNK.Birth
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, self, self)
      self:addBuff(buff, self)
      if skill.evo_rank and skill.evo_rank >= 3 then
        local bid = GuildMountSNK.Evopasv2buff
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = ed.BuffCreate(binfo, self, self)
        self:addBuff(buff, self)
      end
    end
  end
  if self.hp <= self.attribs.HP * 0.5 and not self.is_PowerUP then
    for _, buff in ipairs(self.buff_list) do
      if buff.caster and not buff.caster.buff_effects.invulnerable and buff.caster.camp ~= self.camp then
        buff.timer = -1
      end
    end
    local bid1 = GuildMountSNK.Birth
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, self, self)
    self:addBuff(buff1, self)
    self:setAction("Cheer", false, true)
    local bid2 = 10035306
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = ed.BuffCreate(binfo2, self, self)
    if self.level >= 90 then
      buff2:setAttribute("AD", self.InitAD * 0.15)
      buff2:setAttribute("ARM", self.InitARM * 0.15)
      buff2:setAttribute("MR", self.InitMR * 0.15)
    end
    if self.level >= 95 then
      buff2:setAttribute("AD", self.InitAD * 0.2)
      buff2:setAttribute("ARM", self.InitARM * 0.2)
      buff2:setAttribute("MR", self.InitMR * 0.2)
    end
    if self.level >= 100 then
      buff2:setAttribute("AD", self.InitAD * 0.25)
      buff2:setAttribute("ARM", self.InitARM * 0.25)
      buff2:setAttribute("MR", self.InitMR * 0.25)
    end
    if self.level >= 105 then
      buff2:setAttribute("AD", self.InitAD * 0.35)
      buff2:setAttribute("ARM", self.InitARM * 0.35)
      buff2:setAttribute("MR", self.InitMR * 0.35)
    end
    self:addBuff(buff2, self)
    self.is_PowerUP = true
  end
end

function GuildMountSNK.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, ret = basefunc(self, source, target, damage_type)
  local caster = self.caster
  local add_power = (1 - caster.hp / caster.attribs.HP) * self.evo_rank3["Script Arg1"]
  power = power + add_power
  return power, ret
end

function GuildMountSNK.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.onRemoved = override(buff.onRemoved, GuildMountSNK.skillultbuff_onRemoved)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function GuildMountSNK.skillultbuff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  local bid = GuildMountSNK.Evoultbuff
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, owner, caster)
  owner:addBuff(buff, caster)
end

function GuildMountSNK.init_hero(hero)
  hero.reset = override(hero.reset, GuildMountSNK.hero_reset)
  local skillult = hero.skills.GuildMountSNK_ult
  local skillatk2 = hero.skills.GuildMountSNK_atk2
  local skillpasv2 = hero.skills.GuildMountSNK_pasv2
  local skillpasv = hero.aura_skill_list[1]
  if skillult then
    if GuildMountSNK.fashion_id_1 and GuildMountSNK.fashion_id_1 == hero.fashion_id then
      if skillult.evo_rank and 1 <= skillult.evo_rank then
        skillult.info = ed.wraptable(skillult.info, {
          ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"],
          ["Tile Art"] = "eff_tile_GuildMountSNK_ult2_fashion_1.cha"
        })
      else
        skillult.info = ed.wraptable(skillult.info, {
          ["Tile Art"] = "eff_tile_GuildMountSNK_ult2_fashion_1.cha"
        })
      end
    elseif skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    skillult.createBuff = override(skillult.createBuff, GuildMountSNK.skillult_createBuff)
  end
  if skillpasv2 then
    hero.onActionFinished = override(hero.onActionFinished, GuildMountSNK.onActionFinished)
    hero.update = override(hero.update, GuildMountSNK.update)
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
      skillatk2.power = override(skillatk2.power, GuildMountSNK.skillatk2_power)
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

return GuildMountSNK.init_hero
