module("ed.herorecommend", package.seeall)
promoteMgr = {}
promoteMgr.__index = promoteMgr

function promoteMgr.create(data)
  local object = {}
  setmetatable(object, promoteMgr)
  object:initData(data)
  return object
end

function promoteMgr:initData(data)
  self.data = data
  self.heroid = data._heroid
  self.manito = data._top_user
  self.hero = ed.player.heroes[self.heroid]
  self.upway = self:createUpway()
end

function promoteMgr:createUpway()
  local promoteTable = ed.getDataTable("HeroPromote")
  self.waylenght = 3
  local upway = {}
  for id, data in ipairs(promoteTable) do
    local type = data["Promote Type"]
    if self:canPromote(type) then
      table.insert(upway, id)
      if #upway == self.waylenght then
        break
      end
    end
  end
  return upway
end

function promoteMgr:canPromote(type)
  local typeToFunHash = {
    awake2 = "canSuperWeak",
    awake = "canWeak",
    level = "canLevelupAndRankup",
    skill = "canSkillup",
    enchantment = "canEnhance",
    book = "canBookup",
    runestone = "canRunestoneup",
    concise = "canRinseup",
    school = "canSchoolLevelup",
    pet = "canAdoptPet",
    petskill = "canPetskillUp",
    star = "canHeroStarup",
    petequip = "canFeedPet"
  }
  local funName = typeToFunHash[type]
  local fun = self[funName]
  return fun(self)
end

function promoteMgr:canSuperWeak()
  local equipId = self.hero:getEquipid(1) or 0
  return ed.canOpenSuperAwakeTask(self.heroid, equipId)
end

function promoteMgr:canWeak()
  return not ed.player:isHeroAwake(self.heroid) and ed.awakeLevelOk(self.heroid)
end

function promoteMgr:canLevelupAndRankup()
  local rank = self.hero._rank
  local level = self.hero._level
  return rank < ed.parameter.unit_max_rank or level < ed.parameter.team_level_max
end

function promoteMgr:canSkillup()
  local skills = self:getHeroSkills()
  for _, skill in ipairs(skills) do
    if not self:isSkillLocked(skill) and not self:checkSkillLevelMax(skill.slot) then
      return true
    end
  end
end

function promoteMgr:checkSkillLevelMax(slot)
  local readingHouseBuff = ed.getReadingLevelBuff()
  if self.hero._level < ed.parameter.team_level_max then
    if ed.ui.herodetail.getCacheSkillLevel(self.heroid, slot) >= self.hero._level + readingHouseBuff.skillLevelAdd then
      return true
    end
  elseif ed.ui.herodetail.getCacheSkillLevel(self.heroid, slot) >= ed.parameter.team_level_max + readingHouseBuff.skillLevelAdd then
    return true
  end
  return false
end

function promoteMgr:getHeroSkills()
  local skills = {}
  local skillGroup = ed.getSkillExpBase(self.heroid)
  for i = 1, #skillGroup do
    skills[i] = {
      skillName = skillGroup[i]["Skill Name"],
      rank = skillGroup[i].Unlock,
      slot = skillGroup[i].Slot
    }
  end
  return skills
end

function promoteMgr:isSkillLocked(skill)
  if self.hero._rank < skill.rank then
    return true
  end
  if string.find(skill.skillName, "awake") and not ed.protoAwake(self.hero) then
    return true
  end
  if string.find(skill.skillName, "sawake") and not ed.protoSuperAwake(self.hero) then
    return true
  end
  if string.find(skill.skillName, "warschool") then
    return true
  end
  return false
end

function promoteMgr:skillAwaken(self, skill)
  return not string.find(skill.skillName, "awake") or not not ed.protoAwake(self.hero)
end

function promoteMgr:canEnhance()
  if not ed.playerlimit.getAreaUnlockPrompt("Enhance") then
    return ed.readequip.canHeroItemsEnhance(self.heroid)
  end
end

function promoteMgr:canBookup()
  if not ed.playerlimit.getAreaUnlockPrompt("WarBuilding") then
    local affectBookSkillList = self:getAffectBookSkillList()
    for _, skill in ipairs(affectBookSkillList) do
      local currentLevel = ed.ui.herodetail.book.getBookSkillLevel(skill.bookid, skill.skillid)
      if currentLevel < skill.maxLevel then
        self.promoteBookid = skill.bookid
        return true
      end
    end
  end
end

function promoteMgr:getAffectBookSkillList()
  local dataTable = ed.getDataTable("SchoolSkillGroup")
  local affectBookSkillList = {}
  for bookid, rows in ipairs(dataTable) do
    for skillid, row in ipairs(rows) do
      local ah = row["Affect Hero"]
      for _, heroid in pairs(ah) do
        if heroid == self.hero._tid and ed.ui.warcollege.checkBookShow(bookid) then
          local affectSkill = {
            bookid = bookid,
            skillid = skillid,
            maxLevel = row["Skill Max Level"]
          }
          table.insert(affectBookSkillList, affectSkill)
        end
      end
    end
  end
  return affectBookSkillList
end

function promoteMgr:canRunestoneup()
  local rune = self.hero._hero_rune
  if rune and rune._status == 1 and (not (rune._sun and rune._moon) or not rune._star) then
    return true
  end
end

function promoteMgr:canRinseup()
  local arousal = self.hero._arousal
  if arousal and arousal._status == 1 then
    local dataTable = ed.getDataTable("AwakeNPC")
    local maxLevel = dataTable[ed.player._arousal_level]["Max Limit"]
    if maxLevel > arousal._str or maxLevel > arousal._agi or maxLevel > arousal._int then
      return true
    end
  end
end

function promoteMgr:canSchoolLevelup()
  if not ed.playerlimit.getAreaUnlockPrompt("WarBuilding") then
    local buildings = ed.getDataTable("TeamTerritoryBuildings")
    local maxLevel = buildings[4]["Max Level"]
    if maxLevel > ed.player.war_building.reading_house._level then
      return true
    end
  end
end

function promoteMgr:canAdoptPet()
  return not self.hero._pet and ed.ui.herodetail.checkHeroPetAvailable(self.heroid)
end

function promoteMgr:canPetskillUp()
  if self.hero._pet then
    local maxSkillLevel = self:getPetMaxSkillLevel(self.hero._pet._type_id)
    local petskillLevels = self.hero._pet._skill_levels
    for _, skillLevel in ipairs(petskillLevels) do
      if skillLevel < maxSkillLevel then
        return true
      end
    end
  end
end

function promoteMgr:getPetMaxSkillLevel(petid)
  local petTable = ed.getDataTable("Pet")
  local petData = petTable[petid]
  return petData["Init Level"]
end

function promoteMgr:canHeroStarup()
  return self.hero._stars < ed.parameter.hero_max_star
end

function promoteMgr:canFeedPet()
end

function promoteMgr:getPetUnlockEquipHeart(petid)
  local petTable = ed.getDataTable("Pet")
  local petData = petTable[petid]
  return petData["Hearts Unlock Eqiup6"]
end
