local class = ed.Unit
local attrib_names = {
  "STR",
  "INT",
  "AGI",
  "HP",
  "MP",
  "AD",
  "AP",
  "ARM",
  "MR",
  "CRIT",
  "MCRIT",
  "HPS",
  "MPS",
  "HIT",
  "DODG",
  "ARMP",
  "MRI",
  "LFS",
  "CDR",
  "HEAL",
  "HPR",
  "MPR",
  "HAST",
  "MSPD",
  "PDM",
  "TDM",
  "PIMU",
  "MIMU",
  "SKL",
  "SILR",
  "TEN",
  "CSD",
  "MCSD",
  "CSDR",
  "MCSDR",
  "ALLIMU",
  "HealRatio",
  "LFSRatio",
  "INTR",
  "KMPR",
  "POAD",
  "POAP",
  "POARM",
  "POMR",
  "DotDRatio",
  "MOBRatio",
  "MPRatio",
  "MPGainRatio",
  "KnockRES",
  "MDODG",
  "CON",
  "CRITRES",
  "MCRITRES",
  "RESHURT",
  "DOTRES",
  "ADDP",
  "APDP",
  "EHIT",
  "EMISS",
  "ShieldIncrease",
  "ShieldWeak",
  "LevelPIMU",
  "LevelMIMU",
  "UltRatio",
  "Interrupt HP Ratio"
}
ed.attrib_names = attrib_names
local monster_attribs = {
  "HP",
  "AD",
  "AP",
  "ARM",
  "MR",
  "CRIT",
  "MCRIT"
}
local shardAttribs = {
  "STR",
  "INT",
  "AGI",
  "HP",
  "MP",
  "AD",
  "AP",
  "ARM",
  "MR",
  "CRIT",
  "MCRIT",
  "HPS",
  "MPS",
  "HIT",
  "DODG",
  "ARMP",
  "MRI",
  "LFS",
  "HEAL",
  "HealRatio",
  "DOTRES"
}
local attrib_trans = {
  STR = {HP = 18, ARM = 0.15},
  INT = {AP = 2.4, MR = 0.1},
  AGI = {
    AD = 0.4,
    CRIT = 0.4,
    ARM = 0.08
  }
}
local attrib_gs = {
  STR = 0,
  INT = 0,
  AGI = 0,
  HP = 4,
  MP = 0,
  AD = 60,
  AP = 30,
  ARM = 200,
  MR = 200,
  CRIT = 125,
  MCRIT = 125,
  HPS = 6,
  MPS = 15,
  DODG = 100,
  HIT = 200,
  ARMP = 400,
  MRI = 400,
  LFS = 60,
  CDR = 125,
  HEAL = 300,
  SKL = 2000,
  SILR = 150,
  TEN = 0,
  CSD = 0,
  MCSD = 0,
  CSDR = 0,
  MCSDR = 0,
  ALLIMU = 0,
  INTR = 0,
  KMPR = 0,
  POAD = 0,
  POAP = 0,
  POARM = 0,
  POMR = 0,
  MDODG = 200,
  CON = 0,
  CRITRES = 0,
  MCRITRES = 0,
  RESHURT = 0,
  DOTRES = 200
}

function class:rebuild(mode)
  if mode == "rebuild" then
    self.fixed_attribs = {}
    self.fixed_orig_attribs = {}
    self:baseAttribs()
    self:equipAttribs()
    self:legendEquipAttribs()
    self:astrolabeAttribs()
    self:initShardAttribs()
    self:initAwakeStageBonus()
    self:initRogueWaveBonus()
    self:initRogueTreeBonus()
    self:initGrowthRatioAttribs()
  end
  self.attribs = ed.copyTable(self.fixed_attribs or {})
  if not ed.engine.running then
    self.orig_attribs = ed.copyTable(self.fixed_orig_attribs or {})
  end
  self:passiveAttribs()
  self:auraAttribs()
  self:buffAttribs()
  self:rogueBlessAttribs()
  self:checkMainAttribs()
  self:attackAttribs()
  self:gsAttribs()
  self:convertAttribs()
end

function class:initMealsAttribs(mealParam)
  if not mealParam then
    return
  end
  local mode = mealParam.mode
  local time = mealParam.time
  local attribs = self.fixed_attribs
  local cookTbl = ed.getDataTable("Cook")
  local meals = self.proto._hero_meal or {}
  local meal_id = meals._meal_id
  local incVal, row, attrType, modeStage
  local times = time or 0
  if meal_id and meal_id ~= 0 then
    row = cookTbl[meal_id]
    modeStage = row["Effect Stage"]
    if modeStage ~= mode then
      return
    end
    row = cookTbl[meal_id]
    attrType = row["Attribute Type"]
    incVal = meals._attr
    if times < meals._expire_time then
      local log = T("cook attr %s:%s\n", attrType, incVal)
      btlog(log)
      attribs[attrType] = attribs[attrType] + incVal
    end
  end
end

function class:baseAttribs()
  local attribs = self.fixed_attribs
  local orig = self.fixed_orig_attribs
  local info = self.info
  local level = self.level
  local rankInfo = info.rankInfo
  local nextInfo = info.nextRankInfo
  local ratio = self.rank_ratio
  local stars = self.stars
  local estimate_rank = self.config.estimate_rank
  local growthRatio = self.growthRatio
  for _, name in ipairs(attrib_names) do
    local growth = info["+" .. name .. stars] or 0
    local value = (info[name] or 0) + growth * level
    local field = name
    if estimate_rank then
      field = "E." .. name
    end
    local rankValue = rankInfo and rankInfo[field] or 0
    local nextValue = nextInfo and nextInfo[field] or rankValue
    value = value + rankValue * (1 - ratio) + nextValue * ratio
    attribs[name] = value
    orig[name] = value
  end
  attribs.PDM = 1
  attribs.TDM = 1
  attribs.MPGainRatio = 0
  attribs.KnockRES = 1
  attribs.UltRatio = 0
  orig.PDM = 1
  orig.TDM = 1
  orig.MPGainRatio = 0
  orig.KnockRES = 1
  attribs["+STR%"] = (attribs["+STR%"] or 0) + (rankInfo and rankInfo["+STR%"] or 0)
  attribs["+INT%"] = (attribs["+INT%"] or 0) + (rankInfo and rankInfo["+INT%"] or 0)
  attribs["+AGI%"] = (attribs["+AGI%"] or 0) + (rankInfo and rankInfo["+AGI%"] or 0)
  attribs["Interrupt HP Ratio"] = attribs["Interrupt HP Ratio"] ~= 0 and attribs["Interrupt HP Ratio"] or 8
  if 1 < stars and info["Unit Type"] == "Monster" then
    for _, v in ipairs(monster_attribs) do
      local value = attribs[v]
      value = value * (0.875 + 0.125 * stars)
      attribs[v] = value
      orig[v] = value
    end
  end
end

function class:equipAttribs()
  local attribs = self.fixed_attribs
  local equips = self.equips
  for i = 1, #equips do
    local info = equips[i]
    local lv = info.level
    local titanEquipLv = info.titanEquipLevel
    for _, name in ipairs(attrib_names) do
      local titanValue = 0
      if titanEquipLv then
        titanValue = ed.lookupDataTable("TitanEquipLevel", "+" .. name, info.Item_ID, titanEquipLv) or 0
      end
      local value = (info[name] or 0) + (info["+" .. name] or 0) * lv + titanValue
      attribs[name] = attribs[name] + value
    end
    attribs["+STR%"] = (attribs["+STR%"] or 0) + (info["+STR%"] or 0)
    attribs["+INT%"] = (attribs["+INT%"] or 0) + (info["+INT%"] or 0)
    attribs["+AGI%"] = (attribs["+AGI%"] or 0) + (info["+AGI%"] or 0)
  end
end

function class:legendEquipAttribs()
  if nil == self.legendEquip then
    return
  end
  local heroLegendEquip = self.proto._legend_equip
  if not heroLegendEquip then
    return
  end
  local legendEquip = heroLegendEquip._equip
  if not legendEquip then
    return
  end
  local typeId = legendEquip._type_id
  local star = legendEquip._star
  local rank = legendEquip._rank
  local legendEquipEnhanceCfg = ed.getDataTable("LegendEquipEnhance")[typeId][star][rank]
  local attribs = self.fixed_attribs
  for index = 1, 20 do
    local attrName = legendEquipEnhanceCfg["Attr Type " .. index]
    if not attrName then
      break
    end
    local attrValue = legendEquipEnhanceCfg["Attr Value " .. index]
    attribs[attrName] = (attribs[attrName] or 0) + attrValue
  end
  for skillIndex = 1, 10 do
    local skillId = legendEquipEnhanceCfg[string.format("Skill ID %s", skillIndex)]
    if not skillId or skillId == 0 then
      break
    end
    local skillInfo = ed.getDataTable("LegendEquipSkill")[skillId]
    for index = 1, 20 do
      local attrName = skillInfo["Attr Type " .. index]
      if not attrName then
        break
      end
      local attrValue = skillInfo["Attr Value " .. index]
      attribs[attrName] = (attribs[attrName] or 0) + attrValue
    end
  end
end

function class:runeAttribs()
  local attribs = self.fixed_attribs
  local runeTbl = ed.getDataTable("Rune")
  local heroRune = self.proto._hero_rune or {}
  local sun_id = heroRune._sun
  local moon_id = heroRune._moon
  local star_id = heroRune._star
  local incVal, row, attrType
  if sun_id and sun_id ~= 0 then
    row = runeTbl[sun_id]
    attrType = row.Attr
    incVal = row["Attr Value"]
    attribs[attrType] = attribs[attrType] + incVal
  end
  if moon_id and moon_id ~= 0 then
    row = runeTbl[moon_id]
    attrType = row.Attr
    incVal = row["Attr Value"]
    attribs[attrType] = attribs[attrType] + incVal
  end
  if star_id and star_id ~= 0 then
    row = runeTbl[star_id]
    attrType = row.Attr
    incVal = row["Attr Value"]
    attribs[attrType] = attribs[attrType] + incVal
  end
end

function class:passiveAttribs()
  local attribs = self.attribs
  for _, skill_info in ipairs(self.passive_skill_list) do
    local aname = skill_info["Passive Attr"]
    local num = skill_info["Basic Num"]
    attribs[aname] = attribs[aname] + num
  end
end

function class:auraAttribs()
  local attribs = self.attribs
  if ed.engine.enabled then
    for unit in ed.engine:foreachAliveUnit(self.camp) do
      for _, skill_info in ipairs(unit.aura_skill_list) do
        if ed.Skill.checAurakHeroTag(skill_info, self) and ed.Skill.checkAuraValid(skill_info, unit, self) then
          local aname = skill_info["Passive Attr"]
          local num = skill_info["Basic Num"]
          attribs[aname] = attribs[aname] + num
        end
      end
    end
    local camp = self.camp == ed.emCampPlayer and ed.emCampEnemy or ed.emCampPlayer
    for unit in ed.engine:foreachAliveUnit(camp) do
      for _, skill_info in ipairs(unit.effect_enemy_aura_skill_list) do
        if ed.Skill.checAurakHeroTag(skill_info, self) then
          local aname = skill_info["Passive Attr"]
          local num = skill_info["Basic Num"]
          attribs[aname] = attribs[aname] + num
        end
      end
    end
  end
end

function class:buffAttribs()
  for _, buff in ipairs(self.buff_list) do
    buff:apply()
  end
end

function class:rogueBlessAttribs()
  for _, rogueBless in ipairs(self.rogueBlessList or {}) do
    rogueBless:apply(self)
  end
end

function class:bookAttribs()
  local attribs = self.fixed_attribs
  local info = self.info
  local stars = self.stars
  local level = self.level
  local ratio = self.readingMainAttRatio
  if ratio and ratio.STR then
    attribs.STR = attribs.STR + level * ratio.STR * (info["+STR" .. stars] or 0)
    attribs.AGI = attribs.AGI + level * ratio.AGI * (info["+AGI" .. stars] or 0)
    attribs.INT = attribs.INT + level * ratio.INT * (info["+INT" .. stars] or 0)
  end
end

function class:petAttribs()
  local ratio = self.petExtraAttRatio
  if not ratio then
    return
  end
  local pet = self.proto._pet
  local attribs = self.fixed_attribs
  local info = self.info
  local stars = self.stars
  local level = self.level
  local petSTR = level * ratio.STR * (info["+STR" .. stars] or 0)
  local petINT = level * ratio.INT * (info["+INT" .. stars] or 0)
  local petAGI = level * ratio.AGI * (info["+AGI" .. stars] or 0)
  if ratio and ratio.STR then
    attribs.STR = attribs.STR + petSTR
    attribs.AGI = attribs.AGI + petAGI
    attribs.INT = attribs.INT + petINT
  end
  local dt = ed.getDataTable("Pet")[pet._type_id]
  if dt then
    for i = 1, 3 do
      if pet._level >= dt["Extra Attr " .. i .. " Unlock Level"] then
        attribs[dt["Extra Attr " .. i .. " Type"]] = attribs[dt["Extra Attr " .. i .. " Type"]] + dt["Extra Attr " .. i .. " Value"]
      end
    end
  end
end

function class:astrolabeAttribs()
  local attribs = self.fixed_attribs
  local astrolabe = self.proto._astrolabe
  if not astrolabe then
    return
  end
  if astrolabe._is_unlock == 0 then
    return
  end
  local info = self.info
  local level = astrolabe._level
  local groupId = ed.getDataTable("Astrolabe")[self.tid]["Level Group"]
  local astrolabeSTR = ed.getDataTable("AstrolabeLevelAttr")[groupId][level].STR
  local astrolabeAGI = ed.getDataTable("AstrolabeLevelAttr")[groupId][level].AGI
  local astrolabeINT = ed.getDataTable("AstrolabeLevelAttr")[groupId][level].INT
  attribs.STR = attribs.STR + astrolabeSTR
  attribs.AGI = attribs.AGI + astrolabeAGI
  attribs.INT = attribs.INT + astrolabeINT
  local randomGroupId = ed.getDataTable("Astrolabe")[self.tid]["Random Attr Group"]
  local randomAttTb = ed.getDataTable("AstrolabeRandomAttr")[randomGroupId]
  local percent = randomAttTb["Value Is Pct"] and 0.01 or 1
  for ii, word in ipairs(astrolabe._stars or {}) do
    local attrName = randomAttTb[word._id]["Attr Type"]
    attribs[attrName] = (attribs[attrName] or 0) + word._value * percent
  end
end

function class:warschoolAttribs()
  local attribs = self.fixed_attribs
  local orig = self.fixed_orig_attribs
  if not self.warattribs then
    EDDebug()
  end
  for k, v in pairs(self.warattribs) do
    attribs[k] = (attribs[k] or 0) + v
    orig[k] = (orig[k] or 0) + v
  end
end

function class:getShardAttribsByLevel(level)
  local shard = self.proto._shard
  if not shard then
    return
  end
  local tb = ed.getDataTable("ShardAttribs")[shard._id]
  if not tb then
    return
  end
  local attrs = {}
  for k, attrName in ipairs(shardAttribs) do
    if 0 < tb[level][attrName] then
      attrs[attrName] = tb[level][attrName]
    end
  end
  return attrs
end

function class:initShardAttribs()
  local attribs = self.fixed_attribs
  local shard = self.proto._shard
  if shard and shard._id then
    for level = 1, shard._level do
      local attrs = self:getShardAttribsByLevel(level)
      for attrName, attr in pairs(attrs) do
        attribs[attrName] = (attribs[attrName] or 0) + attr
      end
    end
    local shardSkillTb = ed.getDataTable("ShardSkill")[shard._id]
    self.shardSkill = {}
    self.shardSkillRank = 0
    for k, v in ipairs(shardSkillTb or {}) do
      table.insert(self.shardSkill, ed.copyTable(v))
      if shard._level >= v["Unlock Level"] then
        self.shardSkillRank = k
      end
    end
  end
end

function class:initGrowthRatioAttribs()
  local level = self.level
  local info = self.info
  local stars = self.stars
  local attribs = self.fixed_attribs
  for _, attrName in ipairs(attrib_names) do
    local growthRatio = attribs["+" .. attrName .. "%"] or 0
    local growth = info["+" .. attrName .. stars] or 0
    attribs[attrName] = (attribs[attrName] or 0) + growth * (growthRatio / 100) * level
  end
end

function class:checkMainAttribs()
  local info = self.info
  local attribs = self.attribs
  local orig = self.orig_attribs
  if info["Main Attrib"] then
    local main = info["Main Attrib"]
    attribs.AD = attribs.AD + attribs[main]
    if not ed.engine.running then
      orig.AD = orig.AD + orig[main]
    end
  end
end

function class:awakeAttribs()
  local attribs = self.fixed_attribs
  local aa = ed.getDataTable("AwakeAttribute")
  if ed.protoAwake(self.proto) and aa[self.proto._tid] then
    local arousal = self.proto._arousal
    local haa = aa[self.proto._tid]
    arousal._str = arousal._str or 0
    arousal._int = arousal._int or 0
    arousal._agi = arousal._agi or 0
    local herodetail = {
      STR = arousal._str,
      INT = arousal._int,
      AGI = arousal._agi
    }
    attribs.STR = attribs.STR + arousal._str
    attribs.INT = attribs.INT + arousal._int
    attribs.AGI = attribs.AGI + arousal._agi
    for i = 1, 3 do
      if herodetail[haa[string.format("Attribute%d Limit Type", i)]] >= haa[string.format("Attribute%d Limit Value", i)] then
        local type = haa[string.format("Attribute%d Type", i)]
        local incVal = haa[string.format("Attribute%d Amount", i)]
        attribs[type] = attribs[type] + incVal
      end
    end
  end
end

function class:initArcanaAttribs()
  local attribs = self.fixed_attribs
  if ed.protoHasArcana(self.proto) then
    local arcanaLevel = ed.getProtoArcanaLevel(self.proto)
    local arcanaMeta = ed.getDataTable("Arcana")[self.proto._tid][arcanaLevel]
    
    local function hasAttrib(name)
      if not arcanaMeta[name] or arcanaMeta[name] == 0 then
        return false
      end
      return true
    end
    
    for i, name in ipairs(attrib_names) do
      if hasAttrib(name) then
        attribs[name] = attribs[name] + arcanaMeta[name]
      end
    end
  end
end

function class:initCampAttribs()
  local attribs = self.fixed_attribs
  local union = self:getUnitUnion()
  if self.campLv and self.campLv > 0 and union and union ~= "" then
    local campId = class.UnionNo[union]
    for lv = 1, self.campLv do
      local campTblRow = ed.getDataTable("CampCrystal")[campId][lv]
      for i, name in ipairs(attrib_names) do
        if campTblRow[name] and 0 < campTblRow[name] then
          attribs[name] = attribs[name] + campTblRow[name]
        end
      end
    end
  end
end

function class:initMagicStoneAttribs()
  if not self.magicStonePlan then
    return
  end
  local attribs = self.fixed_attribs
  local bonus = self.magicStonePlan:getAttribBonus()
  for name, value in pairs(bonus) do
    attribs[name] = attribs[name] + value
  end
end

function class:initBondAttribs()
  if not self.proto._bond then
    return
  end
  local attribs = self.fixed_attribs
  for _, bondId in pairs(self.proto._bond._bond_ids or {}) do
    local bond = ed.getDataTable("HeroBond")[bondId]
    for name, value in pairs(attribs) do
      attribs[name] = value + (bond[name] or 0)
    end
  end
end

function class:attackAttribs()
  local attribs = self.attribs
  if attribs.POAD then
    attribs.AD = attribs.AD * (1 + attribs.POAD)
  end
  if attribs.POAP then
    attribs.AP = attribs.AP * (1 + attribs.POAP)
  end
  if attribs.POARM then
    attribs.ARM = attribs.ARM * (1 + attribs.POARM)
  end
  if attribs.POMR then
    attribs.MR = attribs.MR * (1 + attribs.POMR)
  end
end

function class:gsAttribs()
  local attribs = self.attribs
  local gs = 0
  for attrib, value in pairs(attrib_gs) do
    gs = gs + attribs[attrib] * value
  end
  self.gs = gs / 100
end

function class:convertAttribs()
  local attribs = self.attribs
  local orig = self.orig_attribs
  for attr1, group in pairs(attrib_trans) do
    local value1 = attribs[attr1]
    local value2 = orig[attr1]
    for attr2, ratio in pairs(group) do
      attribs[attr2] = attribs[attr2] + value1 * ratio
      if not ed.engine.running then
        orig[attr2] = orig[attr2] + value2 * ratio
      end
    end
  end
  attribs.HP = attribs.HP * self.config.hp_mod
  attribs.PDM = self.config.dps_mod
  attribs.ARM = attribs.ARM * self.config.arm_mod
  attribs.MR = attribs.MR * self.config.mr_mod
  local imu_mod = self.config.imu_mod or 1
  if attribs.ALLIMU < 100 and attribs.ALLIMU >= 0 then
    attribs.ALLIMU = 100 - (100 - attribs.ALLIMU) / imu_mod
  end
  if self.hp > attribs.HP then
    self.hp = attribs.HP
  end
  if self.mp > attribs.MP then
    self.mp = attribs.MP
  end
end

function class:judgeCurrentSkill(buff)
  local buff_effects = self.buff_effects
  local skill = self.current_skill
  local disarm = false
  local silence = false
  local silencebyself = false
  local doom = false
  if buff then
    for i, effect in ipairs(buff.info["Control Effects"]) do
      if effect == "disarm" then
        disarm = true
      end
      if effect ~= "silence" then
      end
      silence = true
      silencebyself = true
      if effect == "doom" then
        doom = true
      end
      if effect == "frozen" or effect == "stun" or effect == "imprisonment" or effect == "imprisonmentbyself" or effect == "fear" or effect == "icefrozen" or effect == "stunbyself" then
        disarm = true
        silence = true
        silencebyself = true
      end
    end
  end
  if skill and (skill.info["Damage Type"] == "AD" and buff_effects.disarm and disarm or skill.info["Damage Type"] ~= "AD" and (buff_effects.silence or buff_effects.silencebyself) and silence or skill ~= self.basic_skill and buff_effects.doom and doom) then
    skill:interrupt()
  end
  if buff_effects.enchanted or buff_effects.derangedOwner or buff_effects.enchantedbyself then
    self.foecamp = self.camp
  else
    self.foecamp = self.controlledTarget and -self.controlledTarget.camp or -self.camp
  end
end
