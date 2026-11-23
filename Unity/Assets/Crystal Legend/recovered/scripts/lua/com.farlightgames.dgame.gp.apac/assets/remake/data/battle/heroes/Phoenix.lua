module("ed.battlehero", package.seeall)
local ed = ed
Phoenix = {}
Phoenix.fashion_2 = 522

function Phoenix.skillpasv_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skill = owner.skills.Phoenix_pasv
  local rebornhp = skill.info["Script Arg2"]
  if skill.evo_rank and skill.evo_rank >= 1 then
    rebornhp = rebornhp + skill.evo_rank1["Script Arg1"]
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    rebornhp = rebornhp + skill.evo_rank2["Script Arg1"]
  end
  if owner:isAlive() then
    owner:setHP(rebornhp * (owner.config.hp_mod or 1))
  end
  owner.unitonDying = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 10006509 then
      local buff = tbuff
      buff.timer = 0
      for n, nbuff in ipairs(owner.buff_list) do
        if nbuff.info.ID == 10006503 then
          nbuff.timer = 0
          for o, obuff in ipairs(buff.owner.buff_list) do
            if obuff.info.ID == 10006508 then
              obuff.timer = 0
              break
            end
          end
          break
        end
      end
      break
    end
  end
  owner.isDandan_Phoenix = false
  return basefunc(buff)
end

function Phoenix.skillpasv_buff5OnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk3 = owner.skills.Phoenix_atk3
  if skillatk3 and not owner.isDandan_Phoenix then
    owner:castSkill(skillatk3, skillatk3.target)
  end
  return basefunc(buff)
end

function Phoenix.onDying(basefunc, self, killer)
  if not self:isAlive() then
    return
  end
  local CannotBecomeDanDan = false
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 1099 or tbuff.info.ID == 4125 then
      CannotBecomeDanDan = true
    end
  end
  if CannotBecomeDanDan then
    self.custom_data = 3
    basefunc(self, killer)
  end
  local skill = self.skills.Phoenix_pasv
  if not self.isDandan_Phoenix and self.custom_data <= 2 then
    self.isDandan_Phoenix = true
    self.custom_data = self.custom_data + 1
    local bidinv = 10005209
    local binfoinv = ed.lookupDataTable("Buff", nil, bidinv)
    local buffinv = self:addBuff(binfoinv, self)
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
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.info.ID == 10005205 then
        local buff = tbuff
        buff.timer = -1
      end
    end
    self.unitonDying = true
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    local danhp = 6
    if skill.evo_rank and 3 <= skill.evo_rank then
      danhp = 7
    end
    local shard = self.proto._shard
    if shard and shard._id == 1000521 and self.shardSkillRank and 1 <= self.shardSkillRank then
      danhp = danhp + self.shardSkill[1]["Script Arg1"]
    end
    self.hp = danhp - self.custom_data
    self.mp = 0
    local bid = 10005206
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = self:addBuff(binfo, self)
    if buff then
      buff.onRemoved = override(buff.onRemoved, Phoenix.skillpasv_buffOnRemoved)
    end
    local bid2 = 10005203
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = self:addBuff(binfo2, self)
    local bid3 = 10005207
    local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
    local buff3 = self:addBuff(binfo3, self)
    local bid4 = 10006509
    local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
    local buff4 = self:addBuff(binfo4, self)
    local bid5 = 10005208
    local binfo5 = ed.lookupDataTable("Buff", nil, bid5)
    local buff5 = self:addBuff(binfo5, self)
    if buff5 then
      buff5.onRemoved = override(buff5.onRemoved, Phoenix.skillpasv_buff5OnRemoved)
    end
    self.state = ed.emUnitState_Birth
    local skillpasv = self.skills.Phoenix_pasv
    if skillpasv then
      self:castSkill(skillpasv, skillpasv.target)
    end
  else
    basefunc(self, killer)
  end
end

function Phoenix.skillpasv_getLostHPAfterImmunity(basefunc, self, damage, immunity, damage_type)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 10005206 then
      if damage_type == "AP" then
        return 0
      else
        return 1
      end
    end
  end
  return basefunc(self, damage, immunity)
end

function Phoenix.skillatk2_buffOnRemoved(basefunc, buff)
  local skillatk = buff.caster.skills.Phoenix_atk
  if skillatk then
    local originfo = skillatk.info
    skillatk.info = ed.wraptable(originfo, {
      ["Tile Art"] = "eff_tile_Lina_atk.cha",
      ["AOE Origin"] = false,
      ["AOE Shape"] = "circle",
      ["Shape Arg1"] = "0",
      ["Point Effect"] = false,
      ["Damage Type"] = "AD",
      ["Plus Attr"] = "AD",
      ["Plus Ratio"] = "1"
    })
  end
  local caster = buff.owner
  caster.atk2Buff_Phoenix = false
  return basefunc(buff)
end

function Phoenix.skillatk2_createBuff(basefunc, skill, target)
  local caster = skill.caster
  local buff = basefunc(skill, target)
  local ap = buff.info.AP
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("AP", ap + skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("AP", ap + skill.evo_rank1["Script Arg1"] + skill.evo_rank2["Script Arg1"])
  end
  buff.onRemoved = override(buff.onRemoved, Phoenix.skillatk2_buffOnRemoved)
  local skillatk = buff.caster.basic_skill
  if skillatk then
    local originfo = skillatk.info
    if skill.evo_rank and skill.evo_rank >= 3 then
      skillatk.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Phoenix_atk2.cha",
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = "100",
        ["Point Effect"] = "eff_point_burst.cha",
        ["Damage Type"] = "AP",
        ["Plus Attr"] = "AP",
        ["Plus Ratio"] = "1"
      })
    else
      skillatk.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_Phoenix_atk2.cha",
        ["AOE Origin"] = "target",
        ["AOE Shape"] = "circle",
        ["Shape Arg1"] = "100",
        ["Point Effect"] = "eff_point_burst.cha",
        ["Damage Type"] = "AP",
        ["Plus Attr"] = "AP",
        ["Plus Ratio"] = "0.6"
      })
    end
  end
  local fashionId = caster.fashion_id
  if fashionId and fashionId == Phoenix.fashion_2 then
    buff:setAttribute("Effect", "eff_buff_Phoenix_atk2_fashion_2.cha")
  end
  caster.atk2Buff_Phoenix = true
  return buff
end

function Phoenix.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 10005205
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  local stype = buff.info.HPR
  stype = -caster.attribs.HP * 0.15
  buff:setAttribute("HPR", stype)
  caster:addBuff(buff, caster)
end

function Phoenix.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
  end
  if owner.hp == 1 then
    local buff
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 10002202 then
        buff = tbuff
      end
    end
    if buff then
      local stype = buff.info.HPR
      local absorption = stype
      if absorption < buff.shield then
        buff.shield = buff.shield - absorption
        return
      else
        absorption = buff.shield
        buff.shield = 0
        buff.owner:removeBuff(buff)
        if not owner.isDandan then
          owner:onDying(owner)
        end
      end
    end
    if not owner.isDandan then
      owner:onDying(owner)
    end
  end
end

function Phoenix.skillult_finish(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 10005205 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function Phoenix.skillult_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  if caster == target then
    return false
  end
  if caster.camp == target.camp then
    skill.info["Damage Type"] = "Heal"
    skill.info["Impact Effect"] = "eff_impact_heal.cha"
  else
    skill.info["Damage Type"] = "AP"
    skill.info["Impact Effect"] = "eff_impact_burst.cha"
  end
  basefunc(skill, target)
end

function Phoenix.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local bid = 10005202
  local binfo3 = ed.lookupDataTable("Buff", nil, bid)
  local buff3 = owner:addBuff(binfo3, owner)
end

function Phoenix.skillatk3_canCastWithTarget(basefunc, skill, target)
  if not basefunc(skill, target) then
    return false
  end
  local caster = skill.caster
  if caster.atk2Buff_Phoenix then
    return false, "atk2Buff"
  end
  return true
end

function Phoenix.reset(basefunc, unit)
  basefunc(unit)
  unit.custom_data = 0
  local shard = unit.proto._shard
  if shard and shard._id == 1000521 and unit.shardSkillRank and unit.shardSkillRank >= 3 then
    local bid = 10005211
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff.attack_timer = 1
    buff.update = override(buff.update, Phoenix.shardbuff_update)
    buff.APMax = unit.shardSkill[3]["Script Arg2"] * unit.attribs.AP
    buff.lastPerc = 0
    unit:addBuff(buff, unit)
  end
end

function Phoenix.shardbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    local unit = buff.owner
    local perc = 1 - unit.hp / unit.attribs.HP
    perc = math.floor(perc * 100) * 0.01
    if perc ~= buff.lastPerc then
      buff.lastPerc = perc
      local AP = buff.APMax * perc
      buff:setAttribute("AP", AP)
      unit:rebuild()
    end
  end
  buff.attack_timer = timer
end

function Phoenix.skillatk_takeEffectOn(basefunc, skill, target, source)
  local ishit, damage = basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  local skillatk2buff = false
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 10005201 then
      local buff = tbuff
      skillatk2buff = true
    end
  end
  if ishit and shard and shard._id == 1000521 and skillatk2buff and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    local bid = 10005210
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    buff:setAttribute("HAST", caster.shardSkill[2]["Script Arg1"])
    buff:setAttribute("MSPD", caster.shardSkill[2]["Script Arg1"])
    target:addBuff(buff, caster)
  end
  return ishit, damage
end

function Phoenix.init_hero(hero)
  local skillult = hero.skills.Phoenix_ult
  local skillatk = hero.skills.Phoenix_atk
  local skillpasv = hero.skills.Phoenix_pasv
  local skillatk3 = hero.skills.Phoenix_atk3
  local skillatk2 = hero.skills.Phoenix_atk2
  hero.reset = override(hero.reset, Phoenix.reset)
  local shard = hero.proto._shard
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
    skillult.onAttackFrame = override(skillult.onAttackFrame, Phoenix.skillult_onAttackFrame)
    skillult.start = override(skillult.start, Phoenix.skillult_start)
    skillult.finish = override(skillult.finish, Phoenix.skillult_finish)
    if shard and shard._id == 1000521 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Affected Camp"] = 0
      })
      skillult.takeEffectOn = override(skillult.takeEffectOn, Phoenix.skillult_takeEffectOn)
    end
  end
  if skillpasv then
    if shard and shard._id == 1000521 and hero.shardSkillRank and 1 <= hero.shardSkillRank then
      skillpasv.info = ed.wraptable(skillpasv.info, {
        ["Shape Arg1"] = 350
      })
    end
    hero.onDying = override(hero.onDying, Phoenix.onDying)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, Phoenix.skillpasv_getLostHPAfterImmunity)
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
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Phoenix.skillatk3_onAttackFrame)
  end
  if skillatk2 then
    hero:preloadEffect("eff_point_burst.cha")
    hero:preloadEffect("eff_tile_Phoenix_atk2.cha")
    skillatk2.createBuff = override(skillatk2.createBuff, Phoenix.skillatk2_createBuff)
  end
  return hero
end

return Phoenix.init_hero
