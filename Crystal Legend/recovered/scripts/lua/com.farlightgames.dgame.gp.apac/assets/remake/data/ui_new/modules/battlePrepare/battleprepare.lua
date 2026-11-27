local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.battleprepare = class
local lsr = ed.ui.battlepreparelsr.create()
local min_crusade_level = 20
local min_crusade_rush_level = 65
local pvp_stage = -1
local battlePrepareScope = {}
local payPanel
local bReqMercenary = false
local currentMercenary
local currentMercenaryIndex = 0
local prepareInfo, prepareTimer
local hero_icon_ori_y = 390
local hero_icon_gap_x = 90
local hero_icon_gap_y = 90
local list_title_offset = 30
local list_item_offset = 30
local hero_icon_wid_num = 6
local karl_hero_tid = 53
local battleing = os.time()

local function unLockBattleing()
  battleing = os.time()
end

class.unLockBattleing = unLockBattleing

local function lockBattleing()
  if os.time() - battleing < 2 then
    return true
  end
  return false
end

class.lockBattleing = lockBattleing
local pms = {
  crusade = "crusade",
  tower = "throne_tower",
  assassinate = "assassinate"
}

local function stageType(self, id)
  if not id then
    return nil
  end
  if self and self.mode == "CampTower" then
    return "CampTower"
  end
  if self and self.mode == "FancyTower" then
    return "FancyTower"
  end
  if self and self.mode == "FancyAbyss" then
    return "FancyAbyss"
  end
  if self and self.mode == "CampBoss" then
    return "CampBoss"
  end
  if self and self.mode == "mythBoss" then
    return "mythBoss"
  end
  if self and self.mode == "GuildMountBoss" then
    return "GuildMountBoss"
  end
  if self and self.mode == "ActivityAdventure" then
    return "ActivityAdventure"
  end
  if self and self.pvpMode then
    if self.pvpMode == "attack" then
      return "pvp"
    elseif self.pvpMode == "share_fight" then
      return "share_fight"
    else
      return
    end
  end
  if self and self.mode == "HadesHeat" then
    return "HadesHeat"
  end
  if self and self.mode == "AwakeStage" then
    if self.objData.type == "Special" then
      return "AwakeStageSpecial"
    else
      return "AwakeStage"
    end
  end
  local st = ed.getDataTable("Stage")
  local type = ed.stageType(id)
  if ed.isElementInTable(type, {
    "normal",
    "elite",
    "challenge"
  }) then
    return "common"
  elseif type == "pvp" then
    return "pvp"
  elseif type == "superawake" then
    return "superawake"
  elseif type == "act" then
    local row = st[id] or {}
    local name = row["Stage Name"]
    local chapterid = row["Chapter ID"]
    local stage_id = row["Stage ID"]
    if name == T("\230\138\152\230\136\159\229\177\177\232\176\183") then
      return "nophysical"
    elseif name == T("\232\175\133\229\146\146\228\185\139\229\159\142") then
      return "nomagical"
    elseif name == T("\229\165\179\230\173\166\231\165\158\231\154\132\229\175\185\229\134\179") then
      return "female"
    elseif name == T("\230\189\174\230\177\144\231\165\158\229\186\153") then
      return "exp"
    elseif name == T("\231\159\174\228\186\186\229\134\155\229\183\165\229\142\130") then
      return "gold"
    elseif name == T("\233\146\155\229\144\136\233\135\145\230\156\186\231\148\178") then
      return "spring1"
    elseif name == T("\229\140\151\229\162\131\229\183\168\233\190\153") then
      return "spring2"
    elseif name == T("\231\150\175\231\139\130\228\185\139\232\161\128") then
      return "spring3"
    elseif name == T("\228\184\141\230\173\187\231\131\136\231\132\176") then
      return "spring4"
    elseif name == T("\229\156\176\231\169\180\233\162\134\228\184\187") then
      return "spring5"
    elseif name == T("\229\189\177\228\185\139\233\173\148\231\142\139") then
      return "spring6"
    elseif name == T("\233\155\183\231\148\181\228\185\139\231\165\158") then
      return "spring7"
    elseif name == T("\230\189\174\230\177\144\231\165\158\230\174\191") then
      return "artifact1"
    elseif name == T("\231\134\148\229\178\169\231\165\158\230\174\191") then
      return "artifact2"
    elseif name == T("\229\164\169\231\169\186\231\165\158\230\174\191") then
      return "artifact3"
    elseif name == T("\229\164\167\229\156\176\231\165\158\230\174\191") then
      return "artifact4"
    elseif chapterid == 108 then
      return "dreamland_" .. stage_id
    end
  end
  return "common"
end

class.stageType = stageType

local function SortHeroesByMaxRange(heroes)
  heroes = heroes or {}
  local temp_tbl = {}
  for i = 1, #heroes do
    temp_tbl[i] = {}
    temp_tbl[i].idx = i
    temp_tbl[i].max_range = ed.readhero.getHeroMaxRange(heroes[i]._tid)
  end
  for i = 1, #temp_tbl - 1 do
    for j = #temp_tbl, i + 1, -1 do
      if temp_tbl[j].max_range <= temp_tbl[j - 1].max_range then
        local temp = temp_tbl[j]
        temp_tbl[j] = temp_tbl[j - 1]
        temp_tbl[j - 1] = temp
      end
    end
  end
  local new_heroes = {}
  for i = 1, #temp_tbl do
    table.insert(new_heroes, heroes[temp_tbl[i].idx])
  end
  return new_heroes
end

ed.SortHeroesByMaxRange = SortHeroesByMaxRange

local function fixTeamData(self, data)
  local fixData = {}
  for i = 1, #(data or {}) do
    local ih = false
    for j = 1, #fixData do
      if data[i] == fixData[j] then
        ih = true
      end
    end
    if not ih then
      table.insert(fixData, data[i])
    end
  end
  return fixData
end

class.fixTeamData = fixTeamData

local function getTeamData(self)
  local id = self.stage
  local key = self:stageType(id)
  local data = {}
  if key then
    data = ed.getTeamData(key)
  end
  data = self:fixTeamData(data)
  return data
end

class.getTeamData = getTeamData

local function setTeamData(self, data)
  local id = self.stage
  local key = self:stageType(id)
  if key then
    data = self:fixTeamData(data)
    ed.setTeamData(key, data)
  end
end

class.setTeamData = setTeamData

local function getCurrentTeam(self)
  local ct = {}
  local ft = {}
  local useMercenary = false
  local mercenaryIndex = 0
  for i = 1, #self.team do
    local tid = self.team[i].heroIcon.info.id
    if ed.readhero.isSpecialFreeHeroID(tid) then
      table.insert(ft, ed.readhero.convertToOriginID(tid))
    else
      table.insert(ct, tid)
    end
    if self.team[i].heroIcon.info.mercenary then
      useMercenary = true
      mercenaryIndex = #ct
    end
  end
  return ct, ft, useMercenary, mercenaryIndex
end

class.getCurrentTeam = getCurrentTeam

local function getTeamMemberPos(self, index)
  index = self.totalSlotNum - index + 1
  local slotImg = self.ui["member_slot_" .. index]
  local posX, posY = slotImg:getPosition()
  return ccp(posX, posY + 8.5)
end

class.getTeamMemberPos = getTeamMemberPos

local function getMercenaryInfo(self)
  local id = 0
  local cost = 0
  local name = ""
  if self.hireMercenary then
    return nil
  end
  local bUseMerncenary = false
  for i = 1, #self.team do
    local mercenary = self.team[i].heroIcon.info.mercenary
    if mercenary then
      cost = cost + mercenary.cost
      name = mercenary.owner
      id = self.team[i].heroIcon.info.id
      bUseMerncenary = true
    end
  end
  return bUseMerncenary and cost, name, id or nil
end

local function playTeamMemberEffect(self, index)
  index = index or 0
  if 1 <= index and index <= self.availableSlotNum then
    index = self.totalSlotNum - index + 1
    self.ui["member_light_" .. index]:stopAllActions()
    local fadein = CCFadeIn:create(0.2)
    local fadeout = CCFadeOut:create(0.2)
    local sequence = CCSequence:createWithTwoActions(fadein, fadeout)
    self.ui["member_light_" .. index]:runAction(sequence)
  else
    for i = 1, self.availableSlotNum do
      self:playTeamMemberEffect(i)
    end
  end
end

class.playTeamMemberEffect = playTeamMemberEffect

local function getTeamHero(self, index)
  if nil == self.team[index] then
    return
  end
  local mercenaryInfo = self.team[index].heroIcon.info.mercenary
  local heroId = self.team[index].heroIcon.info.id
  local hero
  if mercenaryInfo then
    hero = ed.GuildManager:getMercenaryHero(mercenaryInfo.uid, heroId)
  else
    hero = self:getHeroData(heroId)
  end
  return hero
end

local function getAllHeroGsSort(self)
  local allheros = {}
  for i, hero in ipairs(self.listData.all) do
    table.insert(allheros, hero)
  end
  table.sort(allheros, function(a, b)
    return a._gs > b._gs
  end)
  return allheros
end

local function getCrusadeRushTeamMaxGs(self)
  if self.crusadeRushTeamMaxGs then
    return self.crusadeRushTeamMaxGs
  end
  local teamMaxGs = 0
  local allheros = getAllHeroGsSort(self)
  while true do
    local hero = allheros[1]
    if hero and hero:isTitan() then
      table.remove(allheros, 1)
    else
      break
    end
  end
  local total = math.min(self.availableSlotNum, #allheros)
  for i = 1, total do
    teamMaxGs = teamMaxGs + allheros[i]._gs
  end
  self.crusadeRushTeamMaxGs = teamMaxGs
  return teamMaxGs
end

local function getGradeCoeffient(self)
  local crusadeRushParmenter = ed.getDataTable("CrusadeRushParameter")[1]
  local total = 0
  local gradeCoeffient = 0
  for i = 1, #self.team do
    local hero = getTeamHero(self, i)
    if hero then
      local notRecommend = true
      for j, id in ipairs(self.tbc_recommend_heros) do
        if hero._tid == id then
          total = total + hero._gs * crusadeRushParmenter.RecommandedCoeffient
          notRecommend = false
          break
        end
      end
      if notRecommend then
        total = total + hero._gs
      end
    end
  end
  if self.extraMode == "hell" then
    total = total * crusadeRushParmenter.NightmareGlobalRatio
  else
    total = total * crusadeRushParmenter.GlobalRatio
  end
  local teamMaxGs = getCrusadeRushTeamMaxGs(self)
  if 0 == teamMaxGs then
    gradeCoeffient = 0
  else
    gradeCoeffient = total / teamMaxGs
  end
  return gradeCoeffient
end

local function refreshKarlElementByTeam(self)
  if nil ~= self.team then
    for index = 1, #self.team do
      local hero = self.team[index].icon
      if hero then
        hero:showKarlElement(self.showElement)
      end
    end
  end
  if nil ~= self.heroIcon then
    for key, value in pairs(self.heroIcon) do
      if nil ~= value and nil ~= value.icon then
        value:showKarlElement(self.showElement)
      end
    end
  end
  if nil ~= self.mercenaryIconAll then
    for key, value in pairs(self.mercenaryIconAll) do
      if nil ~= value and nil ~= value.icon then
        value:showKarlElement(self.showElement)
      end
    end
  end
end

local function setKarlElementByState(self, state)
  self.showElement = state
end

local function setKarlElementByExistTeam(self, stateAdd, tid)
  if ed.readhero.convertToOriginID(tid) ~= karl_hero_tid then
    return
  end
  setKarlElementByState(self, stateAdd)
end

local function refreshgs(self)
  if self.tbc_rush_mode then
    local grade = "D"
    local gradeCoeffient = getGradeCoeffient(self)
    local crusadeRushParmenter = ed.getDataTable("CrusadeRushParameter")[1]
    local RushRankThreshold = crusadeRushParmenter.RushRankThreshold
    local RushRank = crusadeRushParmenter.RushRank
    for i, val in ipairs(RushRankThreshold) do
      if val <= gradeCoeffient then
        grade = RushRank[i]
      end
    end
    if self.uiMonRig and self.uiMonRig.teamGradeIcons then
      self.uiMonRig.teamGradeIcons[self.currentGrade]:setVisible(false)
      self.currentGrade = "grade" .. grade
      self.uiMonRig.teamGradeIcons[self.currentGrade]:setVisible(true)
    else
      self.currentGrade = "grade" .. grade
    end
  end
  local total = 0
  for i = 1, #self.team do
    local hero = getTeamHero(self, i)
    if hero then
      total = total + hero._gs
    end
  end
  ed.setString(self.ui.gs, total)
end

class.refreshgs = refreshgs

local function refreshAddition(self)
  if not self.activityAdventureId then
    return
  end
  local actAdventureMgr = ed.actiAdventureMgr.getInstance()
  local total = 0
  for i = 1, #self.team do
    local hero = getTeamHero(self, i)
    if hero then
      local heroId = hero._tid
      local addition = actAdventureMgr:getHeroAddition(self.activityAdventureId, heroId)
      total = total + addition / 100
    end
  end
  local tokenImagePath = ed.adventureDefine.getAdventureTokenSmallRes(self.activityAdventureId)
  local context = string.format("<sprite src=%s>", tokenImagePath)
  context = context .. T("<lable fontSize=f15 color=ccc3(255,252,231)>\230\128\187\229\138\160\230\136\144</lable>")
  context = context .. string.format("<lable fontSize=f15 color=ccc3(112,255,84)>%s%%</lable>", total)
  if self.adventureAddtion then
    self.adventureAddtion.node:removeFromParentAndCleanup(true)
  end
  local autoText = ed.ui.autoText.new()
  self.adventureAddtion = autoText
  autoText:initParam({
    context = context,
    strokeColor = ccc3(0, 0, 0),
    strokeSize = 1
  })
  self.totalAddition = total
  self.ui.image_total_add_bg:addChild(autoText.node)
  local autoTextWidth, autoTextHeight = autoText:getCurContentSize()
  autoText.node:setScale(math.min(1, 100 / autoTextWidth))
  ed.layout.centerYInParent(autoText.node)
end

class.refreshAddition = refreshAddition

local function setMemberAmount(self, amount)
  self.memberIndex = amount
end

class.setMemberAmount = setMemberAmount

local function setMemberIndex(self, add)
  if add == 1 or add == "+" then
    add = 1
  end
  if add == -1 or add == "-" then
    add = -1
  end
  local memberIndex = self.memberIndex + add
  self:setMemberAmount(memberIndex)
end

class.setMemberIndex = setMemberIndex

local function getBattleHeros(self, newHeroList)
  if newHeroList then
    for i = 1, #newHeroList do
      ed.player:resetHero(newHeroList[i])
    end
  end
  local hero_list = {}
  for i = 1, #self.team do
    local hero = getTeamHero(self, i)
    if hero then
      table.insert(hero_list, hero)
    end
  end
  return hero_list
end

local function gotoBattle(self, heroTaskHid)
  local function handler(enemyList, isBot, selfList, enemyDyna, guildInstanceData, warschool, bookReadingLevels, energy_bean, pvpActivityId, extraData, crusadeActivityId, background)
    xpcall(function()
      if not self then
        return
      end
      if tolua.isnull(self.mainLayer) then
        return
      end
      local stage_id = self.stage
      if self.pvpMode == "attack" or self.mode == "assassinate" then
        stage_id = pvp_stage
      end
      ed.stopMusic()
      if stage_id and 0 < stage_id then
        local info = {}
        local stageInfo = ed.getDataTable("Stage")
        info.power = stageInfo[stage_id]["Vitality Cost"]
        info.rpower = stageInfo[stage_id]["Vit Return"]
        ed.player:addVitality(-(info.power - info.rpower))
      end
      local hero_list = getBattleHeros(self, selfList)
      local stage = ed.lookupDataTable("Stage", nil, stage_id)
      local battle = ed.lookupDataTable("Battle", nil, stage_id, 1)
      ed.battleshare.clearShareButton()
      if (self.pvpMode == "attack" or self.pvpMode == "share_fight") and enemyList then
        local bonusInfo = {
          selfBonus = extraData.selfBonus,
          oppoBonus = extraData.oppoBonus
        }
        local isShareFight = self.pvpMode == "share_fight"
        hero_list = self:resetHeroList(hero_list)
        enemyList = self:resetHeroList(enemyList, true)
        ed.engine:enterArena(hero_list, enemyList, false, isBot, warschool, bookReadingLevels, self.pvpIsFootHold, pvpActivityId, bonusInfo, isShareFight)
      elseif self.mode == "crusade" then
        local selfCrusade = ed.player:collectCrusadeData(hero_list)
        ed.engine:enterCrusade(hero_list, enemyList, isBot, selfCrusade, enemyDyna, stage_id, self.extraMode, nil, nil, energy_bean, nil, crusadeActivityId)
      elseif self.mode == "guildInstance" then
        battle = ed.lookupDataTable("Battle", nil, stage_id, guildInstanceData.wave)
        ed.engine:enterGuildInstance(stage, hero_list, guildInstanceData)
      elseif self.mode == "arcanaTrial" then
        ed.engine:enterArcanaTrial(stage, hero_list, guildInstanceData, nil, nil, 0, ed.player:getBattleBonus())
      elseif self.mode == "mythPve" then
        local manualBattle = isModuleOpen("ManualAtk") and self.manual_mode == "stage"
        ed.engine:enterStage(stage, hero_list, nil, nil, nil, 0, {
          manualBattle = manualBattle,
          mode = self.mode,
          battleBonus = ed.player:getBattleBonus()
        })
      elseif self.mode == "mythBoss" then
        ed.engine:enterMythBoss(stage, hero_list, nil, nil, 0, ed.player:getBattleBonus())
      else
        local manualBattle = isModuleOpen("ManualAtk") and self.manual_mode == "stage"
        ed.engine:enterStage(stage, hero_list, nil, nil, nil, 0, {
          manualBattle = manualBattle,
          battleBonus = ed.player:getBattleBonus()
        })
      end
      if heroTaskHid ~= nil then
        print("This HeorTask!!! : ", heroTaskHid)
        ed.engine.heroTaskHid = heroTaskHid
      end
      local extraInfo = {}
      if self.mode == "crusade" then
        extraInfo.crusadeInfo = {}
      elseif self.pvpMode then
        extraInfo.pvpInfo = {
          pvpMode = self.pvpMode
        }
      elseif self.mode == "guildInstance" then
        extraInfo.guildInstanceInfo = {}
      elseif self.mode == "arcanaTrial" then
        extraInfo.arcanaTrialInfo = {}
      elseif self.mode == "mythBoss" then
        extraInfo.mythBossInfo = {}
      end
      if (self.pvpMode == "attack" or self.pvpMode == "share_fight") and background then
        local homeGround = background.homeGround or 2
        if homeGround ~= 2 then
          local backgroundId = background.backgroundId or ed.pvpManager.backgroundId
          local summary = self.objData._summary
          extraInfo.oppoSummary = summary
          extraInfo.homeGround = homeGround
          if backgroundId then
            battle = ed.copyTable(battle)
            local res = ed.getDataTable("ArenaBackground")[backgroundId].Picture
            res = string.gsub(res, "UI/alpha/1080P/", "")
            battle["Background Pic"] = res
          end
        end
      end
      ed.scene:reset(stage, battle, extraInfo)
      ed.replaceScene(ed.scene)
      FireEvent("EventBattleStart")
      ed.battleDataCache = {
        gwMode = self.GWMode,
        actType = self.actType,
        heroLimit = self.heroLimit
      }
    end, EDDebug)
  end
  
  return handler
end

class.gotoBattle = gotoBattle

local function doPvp(self)
  local function handler(force)
    lsr:report("clickgo")
    
    local teamData = {}
    for i = 1, #self.team do
      local tid = self.team[i].heroIcon.info.id
      if not ed.readhero.isSpecialFreeHeroID(tid) then
        table.insert(teamData, tid)
      end
    end
    self:setTeamData(teamData)
    local hero_list = {}
    for i = 1, #self.team do
      table.insert(hero_list, self.team[i].heroIcon.info.id)
    end
    ed.netreply.gotoPvpBattleReply = self:gotoBattle()
    local msg = ed.upmsg.ladder()
    msg._start_battle = {}
    msg._start_battle._attack_lineup = hero_list
    msg._start_battle._oppo_user_id = self.pvpEnemyId
    ed.send(msg, "ladder")
  end
  
  return handler
end

local function doAssassinate(self)
  local function handler()
    local selectHeroIds = {}
    
    for i = 1, #self.team do
      table.insert(selectHeroIds, self.team[i].heroIcon.info.id)
    end
    FireEvent("ass_Battle_Select_Heros_Ready", selectHeroIds)
  end
  
  return handler
end

local function doPvpShare(self)
  local function handler(force)
    lsr:report("clickgo")
    
    local teamData = {}
    for i = 1, #self.team do
      local tid = self.team[i].heroIcon.info.id
      if not ed.readhero.isSpecialFreeHeroID(tid) then
        table.insert(teamData, tid)
      end
    end
    self:setTeamData(teamData)
    local hero_list = {}
    for i = 1, #self.team do
      table.insert(hero_list, self.team[i].heroIcon.info.id)
    end
    local oppo_list = {}
    for _, hero in pairs(self.enemyHeros) do
      table.insert(oppo_list, hero._tid)
    end
    ed.netreply.gotoPvpBattleReply = self:gotoBattle()
    local msg = ed.upmsg.ladder()
    msg._start_fight = {}
    msg._start_fight._attack_lineup = hero_list
    msg._start_fight._oppo_lineup = oppo_list
    msg._start_fight._oppo_role_id = self.pvpEnemyId
    ed.send(msg, "ladder")
  end
  
  return handler
end

local function checkStageWithId(row, id)
  if row["Task Progress Type"] == "EquipItem" then
    return not ed.isElementInTable(id, row["Item Stage ID"])
  else
    local pid = row["Task Progress ID"]
    for k, v in pairs(pid) do
      if v ~= 0 and v == id then
        return false
      end
    end
  end
  return true
end

local function checkStage(self, row)
  return checkStageWithId(row, self.stage)
end

class.checkStage = checkStage
ed.checkStage = checkStage

local function isHeroTaskStage(self, id, taskType)
  local id = id or self.stage
  taskType = taskType or "awake"
  local heroTask = ed.player:withHeroTask("working")
  if taskType == "superawake" then
    heroTask = ed.player:withHeroSuperTask("working")
  end
  if heroTask then
    local heroTaskTable = ed.getDataTable("HeroTask")
    local row = heroTaskTable[heroTask._line][heroTask._id]
    local hid = row["Hero ID"]
    local heroName = ed.getDataTable("Unit")[hid]["Display Name"]
    local aloneMessage = row["Task Progress Type"]
    if not checkStageWithId(row, id) then
      return true, hid, aloneMessage
    end
  end
  return false
end

class.isHeroTaskStage = isHeroTaskStage
ed.isHeroTaskStage = isHeroTaskStage

local function checkHeroTask(self, addhid, removehid, message)
  local heroTask = ed.player:withHeroTask("working") or ed.player:withHeroSuperTask("working")
  if heroTask then
    local heroTaskTable = ed.getDataTable("HeroTask")
    local row = heroTaskTable[heroTask._line][heroTask._id]
    local hid = row["Hero ID"]
    local heroName = ed.getDataTable("Unit")[hid]["Display Name"]
    local isArtifact = row["Is Artifact"]
    if self:checkStage(row) then
      return false, false
    end
    local withHero = false
    for i = 1, #self.team do
      if self.team[i].heroIcon.info.id == hid then
        withHero = true
        break
      end
    end
    if row["Task Progress Type"] == "FarmStageWith" or row["Task Progress Type"] == "FarmStageNoDie" or row["Task Progress Type"] == "FarmStageKill" or row["Task Progress Type"] == "FarmStageDamage" then
      if withHero and removehid == hid then
        if message then
          local text = "\229\174\140\230\136\144\232\167\137\233\134\146\228\187\187\229\138\161\229\191\133\233\161\187%s\229\143\130\228\184\142\230\136\152\230\150\151"
          if isArtifact then
            text = "\229\174\140\230\136\144\231\165\158\229\153\168\228\187\187\229\138\161\229\191\133\233\161\187%s\229\143\130\228\184\142\230\136\152\230\150\151"
          end
          ed.showToast(string.format(text, heroName))
        end
        return false, true, isArtifact
      end
    elseif row["Task Progress Type"] == "FarmStageAlone" then
      if withHero and removehid == hid then
        if message then
          local text = T("\229\174\140\230\136\144\232\167\137\233\134\146\228\187\187\229\138\161\229\191\133\233\161\187%s\231\139\172\232\135\170\230\136\152\230\150\151")
          if isArtifact then
            text = "\229\174\140\230\136\144\231\165\158\229\153\168\228\187\187\229\138\161\229\191\133\233\161\187%\231\139\172\232\135\170\230\136\152\230\150\151"
          end
          ed.showToast(string.format(text, heroName))
        end
        return false, true, isArtifact
      else
        if #self.team > 0 and withHero and addhid ~= nil then
          if message then
            local text = T("\229\174\140\230\136\144\232\167\137\233\134\146\228\187\187\229\138\161\229\191\133\233\161\187%s\231\139\172\232\135\170\230\136\152\230\150\151")
            if isArtifact then
              text = T("\229\174\140\230\136\144\231\165\158\229\153\168\228\187\187\229\138\161\229\191\133\233\161\187%s\231\139\172\232\135\170\230\136\152\230\150\151")
            end
            ed.showToast(string.format(text, heroName))
          end
          return false, true, isArtifact
        else
        end
      end
    end
  else
    return false, false
  end
  return false, false
end

class.checkHeroTask = checkHeroTask
ed.testManualAtk = false

local function doGo(self)
  local function handler(force)
    lsr:report("clickgo")
    
    if self.mode ~= "FancyTower" and self.mode ~= "ActivityAdventure" and self.mode ~= "FancyAbyss" and self.mode ~= "HadesHeat" and self.mode ~= "AwakeStage" then
      local ul = ed.getDataTable("Stage")[self.stage]["Unlock Level"]
      if ul > ed.player:getLevel() then
        ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\229\136\176\232\190\190%d\231\186\167\229\143\175\232\191\155\229\133\165\230\173\164\229\133\179\229\141\161", ul))
        return
      end
    end
    if ed.isLegendaryChallenge(self.stage) and #(self.team or {}) > 1 then
      ed.showToast(T("\230\173\164\230\168\161\229\188\143\228\187\133\229\133\129\232\174\184\228\184\138\229\156\186\228\184\128\228\189\141\232\139\177\233\155\132"))
      return
    end
    local hero, freeHero, bUseMercenary, mercenaryIndex = getCurrentTeam(self)
    if ed.testManualAtk and isModuleOpen("ManualAtk") and #hero == 1 then
      self.manual_mode = "stage"
    end
    self.forbidenBack = true
    self:listenTimer(Timer:Once(2), function()
      self.forbidenBack = false
    end)
    local teamData = {}
    for i = 1, #self.team do
      local mercenaryData = self.team[i].heroIcon.info.mercenary
      if mercenaryData == nil then
        local tid = self.team[i].heroIcon.info.id
        if not ed.readhero.isSpecialFreeHeroID(tid) then
          table.insert(teamData, tid)
        end
      end
    end
    self:setTeamData(teamData)
    if self.mode == "dreamland" then
      local mercenary_info = {}
      if bUseMercenary then
        for i, v in ipairs(self.team) do
          if v.heroIcon.info.id == hero[mercenaryIndex] then
            mercenary_info = v.heroIcon.info.mercenary
            break
          end
        end
      end
      ed.dreamland.attack_team = {
        team = hero,
        mercenary_index = mercenaryIndex,
        mercenary_info = mercenary_info
      }
      FireEvent("DreamlandRequestStartBattle", hero)
      return
    end
    if self.mode == "FancyTower" then
      ed.SkillTowerManager.battle_prepare_info = {team = hero}
      ed.SkillTowerManager:requestTowerStartBattle(self.battleFloorInfo, hero)
      return
    end
    if self.mode == "FancyAbyss" then
      ed.SkillTowerManager.battle_prepare_info = {team = hero}
      ed.SkillTowerNetwork:sendExTowerStartBattle(self.battleFloorInfo.floorid, hero)
      return
    end
    if self.mode == "ActivityAdventure" then
      local actId = self.activityAdventureId
      local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
      actiAdventureMgr:setBattlePrepareInfo(actId, self.stage, self.totalAddition or 0, {team = hero})
      return
    end
    if self.mode == "AwakeStage" then
      local mercenaryUID = 0
      if bUseMercenary then
        for i, v in ipairs(self.team) do
          if v.heroIcon.info.id == hero[mercenaryIndex] then
            mercenaryUID = v.heroIcon.info.mercenary.uid
            break
          end
        end
      end
      local dungeonMgr = ed.awakeDungeonMgr:getInstance()
      dungeonMgr:setBattlePrepareInfo({
        stageId = self.stage,
        team = hero,
        mercenaryIndex = mercenaryIndex,
        mercenaryUID = mercenaryUID
      })
      ed.AwakeDungeonNetwork.sendEnterStage(self.stage, self.objData.cellX, self.objData.cellY, hero, freeHero, bUseMercenary)
      return
    end
    if self.mode == "HadesHeat" then
      local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
      local groupId = self.objData.groupId
      local stageId = self.objData.stageId
      local itemId = nianMonsterMgr:getSelectItem()
      local echoId
      if itemId then
        local goodsGroupId = nianMonsterMgr:getGoodsGroupId()
        echoId = nianMonsterMgr:getEchoId(goodsGroupId, itemId)
      end
      ed.hadesHeatMgr:getInstance():setBattlePrepareInfo({
        groupId = self.objData.groupId,
        team = hero,
        stageId = self.objData.stageId,
        chooseHeat = self.objData.chooseHeat,
        itemId = itemId,
        echoId = echoId
      })
      ed.hadesHeatNet.sendEnterStage(groupId, stageId, hero, itemId)
      return
    end
    if self.mode == "GuildMountBoss" then
      local mercenary_info = {}
      if bUseMercenary then
        for i, v in ipairs(self.team) do
          if v.heroIcon.info.id == hero[mercenaryIndex] then
            mercenary_info = v.heroIcon.info.mercenary
            break
          end
        end
      end
      ed.GuildMountManager.battle_prepare_info = {
        team = hero,
        mercenary_index = mercenaryIndex,
        mercenary_info = mercenary_info,
        stage_id = self.stage
      }
      if self.objData.practice then
        ed.GuildMountManager:requestBossPracticeStartBattle()
      elseif self.objData.test then
        ed.GuildMountManager:requestBossStartBattleTest(hero, bUseMercenary)
      else
        ed.GuildMountManager:requestBossStartBattle(hero, bUseMercenary)
      end
      return
    end
    local stageid = self.stage
    local type = ed.stageType(stageid)
    if self.mode == "exerciseStageDetail" then
      ed.netreply.enterStage = self:gotoBattle(hid)
      local msg = ed.upmsg.enter_act_stage()
      msg._stage = stageid
      msg._stage_group = ed.getDataTable("Stage")[stageid]["Stage Group"]
      ed.delaySend(ed.player:tomd5(hero), "important_data_md5", true)
      ed.send(msg, "enter_act_stage")
    elseif ed.isElementInTable(type, {
      "normal",
      "elite",
      "challenge"
    }) or self.mode or self.mode == "mythPve" then
      ed.netreply.enterStage = self:gotoBattle(hid)
      local msg = ed.upmsg.enter_stage()
      msg._stage_id = stageid
      ed.delaySend(ed.player:tomd5(hero), "important_data_md5", true)
      ed.send(msg, "enter_stage")
    elseif type == "act" then
      ed.netreply.enterStage = self:gotoBattle(hid)
      local msg = ed.upmsg.enter_act_stage()
      msg._stage = stageid
      msg._stage_group = ed.getDataTable("Stage")[stageid]["Stage Group"]
      ed.delaySend(ed.player:tomd5(hero), "important_data_md5", true)
      ed.send(msg, "enter_act_stage")
    end
  end
  
  return handler
end

class.doGo = doGo

local function doPresetSave(self, index)
  if #(self.team or {}) == 0 then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\233\162\132\232\174\190\233\152\181\229\174\185\232\139\177\233\155\132"))
    return
  end
  local presetData = {}
  presetData.index = index
  presetData.heroes = {}
  for i = 1, #self.team do
    table.insert(presetData.heroes, self.team[i].heroIcon.info.id)
  end
  local team_confirm = ed.heropreset.team_confirm.create()
  team_confirm:setPresetName(self.presetName)
  team_confirm:ChangeChannel(self.preset_channel)
  if self.presetName == "" then
    team_confirm:ChangeLabel("add")
  else
    team_confirm:ChangeLabel("change")
  end
  ed.getCurrentScene():ccScene():addChild(team_confirm:GetRoot())
  FireEvent("PresetTeamChanged", presetData)
end

class.doPresetSave = doPresetSave

local function doSendTryUseTeam(self)
  local team_heroes = {}
  local team = getCurrentTeam(self)
  if 0 < #team then
    team_heroes = getBattleHeros(self)
  else
    ed.showToast(T("\229\175\185\230\136\152\233\152\181\229\174\185\228\184\141\232\131\189\228\184\186\231\169\186"))
  end
  
  local function isExist(id, t)
    for _, v in pairs(t) do
      if v._tid == id then
        return true
      end
    end
    return false
  end
  
  if not isExist(self.tryUseHeroID, team_heroes) then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\232\175\149\231\148\168\232\139\177\233\155\132"))
    return
  end
  FireEvent("TryUseHeroList", team_heroes, self.stage)
end

class.doSendTryUseTeam = doSendTryUseTeam

local function selectDefendHeros(self)
  local function handler()
    local team = getCurrentTeam(self)
    
    if 0 < #team then
      local msg = ed.upmsg.ladder()
      msg._set_lineup = {}
      msg._set_lineup._lineup = team
      msg._set_lineup._ban_hero = self.ban_hero or 0
      ed.send(msg, "ladder")
      ed.popScene()
    else
      ed.showToast(T("\233\152\178\229\174\136\233\152\181\229\174\185\228\184\141\232\131\189\228\184\186\231\169\186"))
    end
  end
  
  return handler
end

local function sortHeroByMaxRang(heroes)
  for i = 1, #heroes do
    for j = #heroes, i + 1, -1 do
      print("index:", i, j)
      if heroes[j].maxRange > heroes[j - 1].maxRange then
        local temp = heroes[j]
        heroes[j] = heroes[j - 1]
        heroes[j - 1] = temp
      end
    end
  end
  return heroes
end

local function selectLocalBattleHeroes(self)
  local function handler()
    local team = getCurrentTeam(self)
    
    if 0 < #team then
      local team_heroes = getBattleHeros(self)
      team_heroes = sortHeroByMaxRang(team_heroes)
      FireEvent("LocalBattleTeamRefresh", team_heroes)
      ed.popScene()
    else
      ed.showToast(T("\229\175\185\230\136\152\233\152\181\229\174\185\228\184\141\232\131\189\228\184\186\231\169\186"))
    end
  end
  
  return handler
end

local function doCrusade(self)
  local function handler(force)
    local team, freeHero, bUseMercenary, mercenaryIndex = getCurrentTeam(self)
    
    currentMercenaryIndex = mercenaryIndex
    if 0 < #team then
      ed.netreply.gotoCrusadeBattleReply = self:gotoBattle()
      local msg = ed.upmsg.tbc()
      msg._start_bat = {}
      msg._start_bat._heroids = team
      msg._start_bat._use_hire = bUseMercenary == true and 1 or 0
      ed.delaySend(ed.player:tomd5(team), "important_data_md5", true)
      ed.send(msg, "tbc")
      ed.ui.battleprepare.cruadeTeam = team
    end
  end
  
  return handler
end

local function doCrusadeRush(self)
  local function handler(force)
    local team, freeHero, bUseMercenary, mercenaryIndex = getCurrentTeam(self)
    
    currentMercenaryIndex = mercenaryIndex
    if 0 < #team then
      ed.netreply.gotoCrusadeBattleReply = self:gotoBattle()
      local msg = ed.upmsg.tbc()
      msg._tbc_rush = {}
      msg._tbc_rush._heroids = team
      msg._tbc_rush._use_hire = bUseMercenary == true and 1 or 0
      ed.delaySend(ed.player:tomd5(team), "important_data_md5", true)
      ed.send(msg, "tbc")
      ed.popScene()
      ed.ui.battleprepare.cruadeRushTeam = team
      if mercenaryIndex ~= 0 then
        ed.ui.battleprepare.crusadeRushMercenary = true
        local id = ed.ui.battleprepare.cruadeRushTeam[mercenaryIndex]
        local mercenary_info = self.team[mercenaryIndex].heroIcon.info.mercenary
        local hero = ed.GuildManager:getMercenaryHero(mercenary_info.uid, id)
        ed.ui.battleprepare.cruadeRushTeam[mercenaryIndex] = nil
        
        function ed.tbcRushHandler()
          ed.GuildManager:setCrusadeMercenary({
            _role_id = mercenary_info._role_id,
            _uid = mercenary_info.uid,
            _name = "",
            _hero = {
              _base = hero,
              _dyna = {_hp_perc = 0, _mp_perc = 0}
            }
          })
        end
      end
      ed.ui.battleprepare.crusadeRushMercenary = false
    end
  end
  
  return handler
end

local function doGuildInstance(self)
  local function handler(force)
    local ul = ed.getDataTable("Stage")[self.stage]["Unlock Level"]
    
    if ul > ed.player:getLevel() then
      ed.showToast(string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167\229\136\176\232\190\190%d\231\186\167\229\143\175\232\191\155\229\133\165\230\173\164\229\133\179\229\141\161"), ul))
      return
    end
    local h, m = ed.time2HMS()
    if not ed.isAreaOverSea() and tonumber(h) >= 5 and tonumber(h) <= 7 then
      ed.showToast(T("\229\189\147\229\137\141\230\128\170\231\137\169\230\173\163\229\156\168\228\188\145\230\129\175\239\188\140\232\175\183\231\168\141\229\128\153\229\134\141\232\175\149"))
      return
    end
    ed.netreply.enterGuildInstance = self:gotoBattle()
    local hero, freeHero, bUseMercenary, mercenaryIndex = getCurrentTeam(self)
    ed.delaySend(ed.player:tomd5(hero), "important_data_md5", true)
    ed.GuildRaidNetwork:sendStartBattle(self.stage, hero)
    ed.ui.battleprepare.guildInstanceTeam = hero
    ed.ui.battleprepare.guildInstanceTeam[mercenaryIndex] = nil
  end
  
  return handler
end

class.doGuildInstance = doGuildInstance

local function getArcanaTeamDataKey(self)
  return T("arcanaTrial%d", self.arcanaUseHeroID)
end

class.getArcanaTeamDataKey = getArcanaTeamDataKey

local function doArcanaTrial(self)
  local team_heroes = {}
  local team = getCurrentTeam(self)
  if 0 < #team then
    team_heroes = getBattleHeros(self)
  else
    ed.showToast(T("\233\152\181\229\174\185\228\184\141\232\131\189\228\184\186\231\169\186"))
  end
  
  local function isExist(id, t)
    for _, v in pairs(t) do
      if v._tid == id then
        return true
      end
    end
    return false
  end
  
  if not isExist(self.arcanaUseHeroID, team_heroes) then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\232\175\149\231\130\188\232\139\177\233\155\132"))
    return
  end
  local teamData = {}
  for i = 1, #self.team do
    local tid = self.team[i].heroIcon.info.id
    if not ed.readhero.isSpecialFreeHeroID(tid) then
      table.insert(teamData, tid)
    end
  end
  teamData = self:fixTeamData(teamData)
  local key = self:getArcanaTeamDataKey()
  ed.setTeamData(key, teamData)
  ed.netreply.enterArcanaTrial = self:gotoBattle()
  local lineIds = {}
  for i, v in ipairs(team_heroes) do
    table.insert(lineIds, v._tid)
  end
  ed.ArcanaNetwork:sendStartBattle(self.arcanaUseHeroID, lineIds)
end

class.doArcanaTrial = doArcanaTrial

local function doMythBoss(self)
  local team_heroes = {}
  local team = getCurrentTeam(self)
  if 0 < #team then
    team_heroes = getBattleHeros(self)
  else
    ed.showToast(T("\233\152\181\229\174\185\228\184\141\232\131\189\228\184\186\231\169\186"))
    return
  end
  local teamData = {}
  for i = 1, #self.team do
    local tid = self.team[i].heroIcon.info.id
    if not ed.readhero.isSpecialFreeHeroID(tid) then
      table.insert(teamData, tid)
    end
  end
  self:setTeamData(teamData)
  local lineIds = {}
  for i, v in ipairs(team_heroes) do
    table.insert(lineIds, v._tid)
  end
  ed.netreply.mythBossBattleStartedHandler = self:gotoBattle()
  ed.SecretAreaManager:startBossBattle(lineIds)
end

class.doMythBoss = doMythBoss

local function getMaxSelectCount(self)
  local maxCount = self.availableSlotNum
  if ed.isLegendaryChallenge(self.stage) then
    maxCount = 1
  end
  local task, hid, aloneMsg = self:isHeroTaskStage()
  if task and "FarmStageAlone" == aloneMsg then
    maxCount = 1
  end
  return maxCount
end

class.getMaxSelectCount = getMaxSelectCount

local function lackHeroConfirm(self, callback)
  local selectCount = #(self.team or {})
  if 0 == selectCount then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\228\184\138\233\152\181\232\139\177\233\155\132!"))
    return
  end
  local totalCount = ed.player:getHeroAmount()
  if "preset" == self.mode then
    if totalCount < 2 then
      ed.showToast(T("\228\189\160\231\154\132\233\162\132\232\174\190\233\152\159\228\188\141\228\184\141\232\182\1792\228\186\186!"))
    elseif selectCount < 2 then
      ed.showToast(T("\228\189\160\231\154\132\233\162\132\232\174\190\233\152\159\228\188\141\228\184\141\232\182\1792\228\186\186\239\188\140\232\175\183\231\187\167\231\187\173\233\128\137\230\139\169\233\162\132\232\174\190\233\152\181\229\174\185\232\139\177\233\155\132!"))
    else
      callback()
    end
    return
  end
  local newCallBack
  if self.mode == "HadesHeat" and self:canShowFirework() then
    local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
    local itemId = nianMonsterMgr:getSelectItem()
    local uiEditorConfig = nianMonsterMgr:getActivityUIConfig()
    local battlePrepareSceneCfg = uiEditorConfig.battlePrepareSceneCfg
    
    function newCallBack()
      if not itemId then
        local info = {
          text = battlePrepareSceneCfg.fightTips or "",
          rightHandler = callback
        }
        ed.showConfirmDialog(info)
      else
        callback()
      end
    end
  end
  local maxCount = self:getMaxSelectCount()
  if 1 == maxCount then
    if maxCount == selectCount then
      callback()
    else
      ed.showToast(T("\230\173\164\230\168\161\229\188\143\229\143\170\232\131\189\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132\229\135\186\230\136\152!"))
    end
  else
    maxCount = totalCount >= maxCount and maxCount or totalCount
    local info = {
      text = T(""),
      rightHandler = newCallBack and newCallBack or callback
    }
    if selectCount < maxCount then
      if self.pvpMode == "defend" then
        info.text = T("\228\189\160\231\154\132\233\152\178\229\174\136\233\152\159\228\188\141\228\184\141\232\182\179%d\228\186\186,\230\152\175\229\144\166\231\187\167\231\187\173?", maxCount)
        ed.showConfirmDialog(info)
      else
        info.text = T("\228\189\160\231\154\132\229\135\186\230\136\152\233\152\159\228\188\141\228\184\141\232\182\179%d\228\186\186,\230\152\175\229\144\166\231\187\167\231\187\173?", maxCount)
        ed.showConfirmDialog(info)
      end
    elseif newCallBack then
      newCallBack()
    else
      callback()
    end
  end
end

class.lackHeroConfirm = lackHeroConfirm

local function requestBattle(self)
  if lockBattleing() then
    return
  end
  unLockBattleing()
  if self.mode == "TryUseMode" then
    self:doSendTryUseTeam()
    return
  end
  if self.pvpMode == "defend" then
    return selectDefendHeros(self)()
  elseif self.guildClashMode then
    local team = self:getCurrentTeam()
    FireEvent("GuildClashEditTeam", team)
    ed.popScene()
  elseif self.pvpMode == "localbattle" then
    return selectLocalBattleHeroes(self)()
  elseif self.pvpMode == "attack" then
    return doPvp(self)()
  elseif self.pvpMode == "share_fight" then
    return doPvpShare(self)()
  elseif self.mode == "assassinate" then
    return doAssassinate(self)()
  elseif self.mode == "crusade" then
    if self.tbc_rush_mode then
      return doCrusadeRush(self)()
    else
      return doCrusade(self)()
    end
  elseif self.mode == "guildInstance" then
    return doGuildInstance(self)()
  elseif self.mode == "preset" then
    self:doPresetSave(self.presetIndex)
    return
  elseif self.mode == "arcanaTrial" then
    self:doArcanaTrial()
  elseif self.mode == "mythBoss" then
    self:doMythBoss()
  else
    return doGo(self)()
  end
end

local function conformPay()
  if currentMercenary then
    local msg = ed.upmsg.guild()
    msg._hire_hero = {}
    msg._hire_hero._uid = currentMercenary.uid
    msg._hire_hero._heroid = currentMercenary.tid
    if prepareInfo.mode == "crusade" then
      msg._hire_hero._from = "tbc"
    elseif prepareInfo.mode == "tower" then
      msg._hire_hero._from = "tower"
    else
      if prepareInfo.mode == "guildInstance" then
        msg._hire_hero._stage_id = prepareInfo.stage_id
      end
      msg._hire_hero._from = "stage"
      if prepareInfo.mode == "GuildMountBoss" then
        msg._hire_hero._from = "guild_mount"
      end
    end
    ed.send(msg, "guild")
  end
  payPanel:setVisible(false)
end

class.conformPay = conformPay

local function cancelPay()
  payPanel:setVisible(false)
end

class.cancelPay = cancelPay

function class:usePresetTeam(h_list, isRecom)
  local newList = {}
  if self.mode == "GuildClash" then
    for _, v in ipairs(h_list) do
      if self:checkHeroUsed(v) then
        ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\229\156\168\229\133\182\228\187\150\233\152\159\228\188\141"))
      else
        table.insert(newList, v)
      end
    end
    h_list = newList
  end
  if self.mode == "GuildMountBoss" and not self.objData.practice then
    for _, v in ipairs(h_list) do
      if not ed.GuildMountManager:isHeroUsed(v) then
        table.insert(newList, v)
      end
    end
    h_list = newList
  end
  local isBan = false
  for i = 1, #h_list do
    if self:checkHeroIsBan(h_list[i]) then
      isBan = true
      break
    end
  end
  for _, v in ipairs(h_list) do
    local hero = ed.player.heroes[v]
    if self.mode == "crusade" and self.tbc_rush_mode and hero._level < min_crusade_rush_level then
      ed.showToast(T("\228\189\142\228\186\142%d\231\186\167\231\154\132\232\139\177\233\155\132\228\184\141\232\131\189\228\184\138\229\156\186", min_crusade_rush_level))
      return
    end
    if self.mode == "crusade" and hero._level < min_crusade_level then
      ed.showToast(T("\228\189\142\228\186\142%d\231\186\167\231\154\132\232\139\177\233\155\132\228\184\141\232\131\189\228\184\138\229\156\186", min_crusade_level))
      return
    end
  end
  if isBan then
    ed.showToast(T("\233\152\159\228\188\141\228\184\173\230\156\137\232\162\171\231\166\129\231\148\168\231\154\132\232\139\177\233\155\132\239\188\140\228\184\141\229\143\175\228\189\191\231\148\168\232\175\165\233\152\181\229\174\185"))
    return
  end
  if self:checkIsCanHeroTags() then
    local isTag = false
    local tags = self:getStageRequirementTags()
    for i = 1, #h_list do
      if not self:checkStageTagHasHeroTag(h_list[i], tags) then
        isTag = true
        break
      end
    end
    if isTag then
      ed.showToast(T("\233\152\159\228\188\141\228\184\173\230\156\137\232\162\171\231\166\129\231\148\168\231\154\132\232\139\177\233\155\132\239\188\140\228\184\141\229\143\175\228\189\191\231\148\168\232\175\165\233\152\181\229\174\185"))
      return
    end
  end
  local presetids = {}
  for i = 1, #h_list do
    table.insert(presetids, h_list[i])
  end
  local awake_id
  for i = #self.team, 1, -1 do
    local hid = self.team[i].heroIcon.info.id
    local noForce, ret = self:checkHeroTask(nil, hid, false)
    if ret and not ed.isElementInTable(hid, presetids) then
      awake_id = hid
      break
    end
  end
  
  local function doUse()
    for i = #self.team, 1, -1 do
      local mercenaryData = self.team[i].heroIcon.info.mercenary
      local uid = mercenaryData and mercenaryData.uid or nil
      self:destroyTeamMember(self.team[i].heroIcon.info.id, true, uid ~= nil, uid, true)
    end
    for i = 1, #h_list do
      local hero = self:getHeroData(h_list[i])
      if hero then
        local hp_perc = hero:hp_perc(pms[self.mode])
        local is_alive = hp_perc == nil or not (hp_perc <= 0)
        local hero_limit_satisfy = not self.heroLimit or self.heroLimit.type ~= "rank" or not (hero._rank < self.heroLimit.detail)
        if is_alive and hero_limit_satisfy then
          local notaddSound = i ~= 1
          self:addTeamMember(h_list[i], nil, nil, true, notaddSound)
        end
      end
    end
  end
  
  local function doUseRecom()
    local mercenary_keep_id
    for i = #self.team, 1, -1 do
      local isInRecom = false
      local mercenaryData = self.team[i].heroIcon.info.mercenary
      local uid = mercenaryData and mercenaryData.uid or nil
      if uid then
        for j = 1, #h_list do
          if h_list[j] == self.team[i].heroIcon.info.id then
            isInRecom = true
            mercenary_keep_id = h_list[j]
            break
          end
        end
      end
      if not isInRecom then
        self:destroyTeamMember(self.team[i].heroIcon.info.id, true, uid ~= nil, uid, true)
      end
    end
    for i = 1, #h_list do
      local hero = self:getHeroData(h_list[i])
      if hero and h_list[i] ~= mercenary_keep_id then
        local hp_perc = hero:hp_perc(pms[self.mode])
        local is_alive = hp_perc == nil or not (hp_perc <= 0)
        local hero_limit_satisfy = not self.heroLimit or self.heroLimit.type ~= "rank" or not (hero._rank < self.heroLimit.detail)
        if is_alive and hero_limit_satisfy then
          local notaddSound = i ~= 1
          self:addTeamMember(h_list[i], nil, nil, true, notaddSound)
        end
      end
    end
  end
  
  if awake_id then
    local heroName = ed.getDataTable("Unit")[awake_id]["Display Name"]
    local info = {
      text = string.format(T("\230\146\164\231\166\187%s\229\176\134\230\151\160\230\179\149\229\174\140\230\136\144\232\167\137\233\134\146\228\187\187\229\138\161\239\188\140\232\175\183\233\151\174\230\152\175\229\144\166\229\157\154\230\140\129\230\146\164\231\166\187\239\188\159"), heroName),
      leftText = T("\231\161\174\229\174\154"),
      heroStyle = true,
      leftHandler = function()
        if isRecom then
          doUseRecom()
        else
          doUse()
        end
      end,
      rightText = T("\229\143\150\230\182\136"),
      rightHandler = function()
      end
    }
    ed.showConfirmDialog(info)
  elseif isRecom then
    doUseRecom()
  else
    doUse()
  end
end

local function doNow(self, force)
  if not force then
    self:lackHeroConfirm(function()
      doNow(self, true)
    end)
    return
  end
  local cost, name, id = getMercenaryInfo(self)
  if self.mode == "GuildMountBoss" and self.objData.practice and currentMercenary then
    ed.GuildManager:handleHirePracticeHeroReply({
      _uid = currentMercenary.uid,
      _tid = currentMercenary.tid
    })
  elseif cost then
    if cost > ed.player._money then
      ed.showHandyDialog("useMidas")
      return
    end
    ed.ui.heroPayWin.create(cost, name, id, currentMercenary, prepareInfo)
  else
    requestBattle(self)
  end
end

local function getMercenaryIcon(self, tid, uid)
  if tid == nil then
    return
  end
  if self.tag == "wholeteam" or self.tag == "banhero" or self.tag == "recommend" or self.tag == "recom" then
    for i, v in ipairs(self.mercenaryIconAll) do
      local data = self.mercenarylistData.all[i]
      local mercenaryInfo = data:getMercenaryData()
      if data._tid == tid and mercenaryInfo ~= nil and mercenaryInfo._uid == uid then
        return self.mercenaryIconAll[i]
      end
    end
  elseif self.tag == "mercenary" then
    for i, v in ipairs(self.mercenaryIcon) do
      local data = self.mercenarylistData[self.clid[2]][i]
      local mercenaryInfo = data:getMercenaryData()
      if data._tid == tid and mercenaryInfo ~= nil and mercenaryInfo._uid == uid then
        return self.mercenaryIcon[i]
      end
    end
  end
end

local function getHeroIcon(self, tid, bMercenary, uid)
  if bMercenary then
    return getMercenaryIcon(self, tid, uid)
  else
    return self.heroIcon[tid]
  end
end

local function getHeroIconByIndex(self, index)
  local heroInfo = self.team[index].heroIcon
  if heroInfo == nil then
    return
  end
  local mercenaryInfo = heroInfo.info.mercenary
  local uid = mercenaryInfo and mercenaryInfo.uid or nil
  local tid = heroInfo.info.id
  local bmercenary = mercenaryInfo ~= nil
  return getHeroIcon(self, tid, bmercenary, uid)
end

function class:orderTeam(tid, isAdd, mercenary, uid)
  if isAdd == nil then
    return
  end
  if isAdd then
    local heroIcon = getHeroIcon(self, tid, mercenary, uid)
    if heroIcon == nil then
      return
    end
    local maxRange = heroIcon.info.maxRange
    if #self.team == 0 or maxRange > self.team[#self.team].heroIcon.info.maxRange then
      local index = #self.team + 1
      table.insert(self.team, {heroIcon = heroIcon})
      heroIcon.memberid = index
      if mercenary then
        self:refreshMercenaryMemberId(heroIcon)
      end
      self:setMemberIndex(1)
      return index
    end
    if #self.team >= 1 and maxRange <= self.team[1].heroIcon.info.maxRange then
      table.insert(self.team, 1, {heroIcon = heroIcon})
      heroIcon.memberid = 1
      if mercenary then
        self:refreshMercenaryMemberId(heroIcon)
      end
      for j = #self.team, 2, -1 do
        local move = CCMoveTo:create(0.2, self:getTeamMemberPos(j))
        move = CCEaseBackInOut:create(move)
        self.team[j].icon.icon:stopAllActions()
        self.team[j].icon.icon:runAction(move)
        local teamIcon = getHeroIconByIndex(self, j)
        teamIcon.memberid = j
        if mercenary then
          self:refreshMercenaryMemberId(teamIcon)
        end
      end
      self:setMemberIndex(1)
      return 1
    end
    for i = #self.team, 2, -1 do
      if maxRange <= self.team[i].heroIcon.info.maxRange and maxRange >= self.team[i - 1].heroIcon.info.maxRange then
        table.insert(self.team, i, {heroIcon = heroIcon})
        heroIcon.memberid = i
        if mercenary then
          self:refreshMercenaryMemberId(heroIcon)
        end
        for j = #self.team, i + 1, -1 do
          local move = CCMoveTo:create(0.2, self:getTeamMemberPos(j))
          move = CCEaseBackInOut:create(move)
          self.team[j].icon.icon:stopAllActions()
          self.team[j].icon.icon:runAction(move)
          local teamIcon = getHeroIconByIndex(self, j)
          teamIcon.memberid = j
          if mercenary then
            self:refreshMercenaryMemberId(teamIcon)
          end
        end
        self:setMemberIndex(1)
        return i
      end
    end
  else
    local heroIcon = getHeroIcon(self, tid, mercenary, uid)
    local memberid = heroIcon.memberid
    heroIcon.memberid = nil
    if mercenary then
      self:refreshMercenaryMemberId(heroIcon)
    end
    if nil ~= memberid then
      table.remove(self.team, memberid)
      self:setMemberIndex(-1)
      for i = memberid, #self.team do
        local icon = self.team[i].icon.icon
        local move = CCMoveTo:create(0.2, self:getTeamMemberPos(i))
        move = CCEaseBackInOut:create(move)
        icon:stopAllActions()
        icon:runAction(move)
        self.team[i].heroIcon.memberid = i
        if mercenary then
          self:refreshMercenaryMemberId(self.team[i].heroIcon)
        end
      end
    end
  end
end

local function addBanHero(self, tid, mercenary, uid, fadeInAnim, notaddSound)
  local isSelete = false
  for i = 1, #self.team do
    local id = self.team[i].heroIcon.info.id
    if id == tid then
      isSelete = true
      break
    end
  end
  if isSelete then
    ed.showToast(T("\230\173\164\232\139\177\233\155\132\229\183\178\229\156\168\233\152\159\228\188\141\228\184\173\239\188\140\228\184\141\232\131\189\232\174\190\228\184\186\231\166\129\231\148\168"))
    return
  end
  if tid == self.ban_hero then
    self:destroyBanHeroMember(tid, true)
    return
  end
  if tid ~= self.ban_hero and self.ban_hero > 0 then
    self:destroyBanHeroMember(self.ban_hero)
  end
  local heroIcon = getHeroIcon(self, tid, mercenary, uid)
  self.ban_hero = tid or 0
  heroIcon:showBanTag()
  self.ban_hero_icon = heroIcon
  local icon = heroIcon.icon
  icon:setScale(self.iconScale)
  local cur_mode = self.mode
  if self.pvpMode == "defend" then
    cur_mode = "pvp"
  end
  local mealMode = {
    dreamland = "dreamland",
    guildInstance = "guildraid",
    pvp = "pvp"
  }
  local oripos = self.draglist:getItemWorldPos(ccp(icon:getPosition()))
  local orix, oriy = oripos.x, oripos.y
  local nicon
  nicon = ed.readhero.createIconByHero(self:getHeroData(tid), {
    hmMode = pms[self.mode],
    state = "idle",
    mealMode = mealMode[cur_mode],
    showParagonLv = self.mode == "AwakeStage",
    isShowLegendEquip = ed.openLegendEquip() and not self.isIgnoreLengendEquip,
    limitRank = self.limitHeroRank
  })
  nicon.icon:setPosition(ccp(orix, oriy))
  nicon:showKarlElement(self.showElement)
  nicon:showBanTag()
  self.mainLayer:addChild(nicon.icon, 30)
  self:playTeamMemberEffect(1)
  self.banTeam[1].banHero = nicon
  action = CCMoveTo:create(0.2, self.banTeam[1].pos)
  action = CCEaseSineOut:create(action)
  nicon.icon:runAction(action)
end

class.addBanHero = addBanHero

local function destroyBanHeroMember(self, tid, isAnaim)
  if not self.ban_hero_icon then
    return
  end
  local heroIcon = self.ban_hero_icon
  self.ban_hero = 0
  heroIcon:deleteBanTag()
  local licon = heroIcon.icon
  local icon = self.banTeam[1].banHero.icon
  self.banTeam[1].banHero = nil
  if isAnaim then
    local posx, posy = licon:getPosition()
    local epos = licon:getParent():convertToWorldSpace(ccp(posx, posy))
    self.banTeam[1].banHero = nil
    self.isDestroyTeamMember[tid] = true
    local bx, by = icon:getPosition()
    local ex, ey = epos.x, epos.y
    local action = CCMoveTo:create(0.3, ccp((bx + ex) / 2, (by + ey) / 2))
    action = CCEaseSineIn:create(action)
    local fade = CCFadeOut:create(0.3)
    local spawn = CCSpawn:createWithTwoActions(action, fade)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(icon) then
          icon:removeFromParentAndCleanup(true)
          self.isDestroyTeamMember[tid] = nil
        end
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(spawn, func)
    icon:runAction(sequence)
  elseif not tolua.isnull(icon) then
    icon:removeFromParentAndCleanup(true)
    self.isDestroyTeamMember[tid] = nil
  end
end

class.destroyBanHeroMember = destroyBanHeroMember

local function addTeamMember(self, tid, mercenary, uid, fadeInAnim, notaddSound)
  if self.isDestroyTeamMember[tid] then
    return
  end
  if self.tag == "banhero" and self:checkIsBanSeleteMode() then
    self:addBanHero(tid, mercenary, uid, fadeInAnim, notaddSound)
    return
  end
  if self:checkHeroIsBan(tid) then
    ed.showToast(T("\230\173\164\232\139\177\233\155\132\232\162\171\231\166\129\231\148\168"))
    return
  end
  if self:isSeleteEzioInValkrie({_tid = tid}) then
    ed.showToast(T("\230\173\164\232\139\177\233\155\132\232\162\171\231\166\129\231\148\168"))
    return
  end
  if self.mode == "GuildMountBoss" and not self.objData.test then
    local extraTime = ed.GuildMountManager:getExtraTime()
    if extraTime then
      ed.showToast(T("\229\189\147\229\137\141\228\184\186\232\161\165\230\151\182\231\138\182\230\128\129\239\188\140\232\139\177\233\155\132\229\183\178\233\148\129\229\174\154"))
      return
    end
  end
  if self:checkIsCanHeroTags() then
    local tags = self:getStageRequirementTags()
    if not self:checkStageTagHasHeroTag(tid, tags) then
      ed.showToast(T("\230\173\164\232\139\177\233\155\132\232\162\171\231\166\129\231\148\168"))
      return
    end
  end
  if self.memberIndex > self.availableSlotNum then
    lsr:report("clickAddHeroTeamFilled")
    self:playTeamMemberEffect(0)
    return
  end
  local noForce, ret = self:checkHeroTask(tid, nil, true)
  if ret then
  end
  for i = 1, #self.team do
    local id = self.team[i].heroIcon.info.id
    if ed.readhero.convertToOriginID(id) == ed.readhero.convertToOriginID(tid) then
      ed.showToast(T("\229\144\140\229\144\141\232\139\177\233\155\132\228\184\141\232\131\189\229\144\140\230\151\182\228\184\138\229\156\186"))
      return
    end
  end
  local heroIcon = getHeroIcon(self, tid, mercenary, uid)
  if heroIcon == nil then
    return
  end
  local fashion_id
  if mercenary == true then
    for _, proto_hero in ipairs(self.listData.mercenary) do
      if proto_hero._tid == tid and proto_hero._fashion and proto_hero._fashion ~= 0 then
        fashion_id = proto_hero._fashion
      end
    end
    if currentMercenary == nil then
      currentMercenary = {}
      currentMercenary.uid = uid
      currentMercenary.tid = tid
    else
      ed.showToast(T("\228\184\128\229\156\186\230\136\152\230\150\151\229\143\170\232\131\189\233\155\135\228\189\163\228\184\128\228\189\141\232\139\177\233\155\132"))
      return
    end
  else
    local proto_hero = self:getHeroData(tid)
    if proto_hero._fashion and proto_hero._fashion ~= 0 then
      fashion_id = proto_hero._fashion
    end
  end
  if EDEngineVersion() >= 4 then
    ed.asyncload.preloadFcaByUnitID(ed.readhero.convertToOriginID(tid))
  end
  if not notaddSound then
    lsr:report("clickAddHero", {
      hid = ed.readhero.convertToOriginID(tid),
      fashion_id = fashion_id
    })
  end
  local icon = heroIcon.icon
  icon:setScale(self.iconScale)
  local oripos = self.draglist:getItemWorldPos(ccp(icon:getPosition()))
  oripos = self.ui.layTeamitems:convertToNodeSpace(oripos)
  local nicon, maxStar
  if "dreamland" == self.mode and ed.dreamland.mgr:isFairPlay() and ed.isTitanById(ed.readhero.convertToOriginID(tid)) then
    maxStar = ed.dreamland.mgr:getFairPlayMaxStar()
  end
  if mercenary then
    local iconInfo = heroIcon.info
    local crusadeData = iconInfo.summary.crusadeData or {}
    iconInfo.hp = iconInfo.hp == 0 and (crusadeData._hp_perc or 0) or iconInfo.hp
    iconInfo.mp = iconInfo.mp == 0 and (crusadeData._mp_perc or 0) or iconInfo.mp
    local stars = maxStar and math.min(maxStar, iconInfo.stars) or iconInfo.stars
    local legendInfo
    if iconInfo.legendEquip then
      legendInfo = iconInfo.legendEquip
    end
    nicon = ed.readhero.createIcon({
      id = iconInfo.id,
      rank = iconInfo.rank,
      hp = iconInfo.hp,
      mp = iconInfo.mp,
      shard = iconInfo.shard,
      level = iconInfo.level,
      stars = stars,
      maxRange = iconInfo.maxRange,
      fashion_id = iconInfo.fashion_id,
      summary = iconInfo.summary,
      mercenary = {},
      karlElement = ed.readhero.getHeroElement(iconInfo.id),
      legendEquip = legendInfo
    })
  else
    local cur_mode = self.mode
    if self.pvpMode == "defend" then
      cur_mode = "pvp"
    end
    local mealMode = {
      dreamland = "dreamland",
      guildInstance = "guildraid",
      pvp = "pvp"
    }
    local heroInfo = self:getHeroData(tid)
    nicon = ed.readhero.createIconByHero(heroInfo, {
      hmMode = pms[self.mode],
      state = "idle",
      mealMode = mealMode[cur_mode],
      actAdventureId = self.activityAdventureId,
      showParagonLv = self.mode == "AwakeStage",
      isShowPvpActivityMask = self:checkHeroInCondition(heroInfo),
      pvpActivityMask = self.pvpActivityInfo and self.pvpActivityInfo.battlePrepareHeroMask,
      isShowLegendEquip = ed.openLegendEquip() and not self.isIgnoreLengendEquip,
      limitRank = self.limitHeroRank
    })
  end
  setKarlElementByExistTeam(self, true, tid)
  nicon.icon:setPosition(oripos)
  self.ui.layTeamitems:addChild(nicon.icon, 30)
  nicon.icon:setScale(self.iconScale)
  local index = self:orderTeam(tid, true, mercenary, uid)
  self:playTeamMemberEffect(index)
  self.team[index].icon = nicon
  if self.aura_hint then
    self.aura_hint:AddAura(ed.readhero.convertToOriginID(tid), index, false)
    local flag_impact = self.aura_hint:CheckAuraImpactAll(ed.readhero.convertToOriginID(tid))
    if flag_impact then
      ListenTimer(Timer:Once(0.2), function()
        self.aura_hint:Reset()
        self.aura_hint:AddMemberHint(self.team[index])
        self.aura_hint:AddTeamHintByHero(self.team, ed.readhero.convertToOriginID(tid))
        self.aura_hint:Play()
      end, battlePrepareScope)
    end
  end
  local action
  if fadeInAnim or nil ~= self.ui.teamDraglist then
    action = CCFadeIn:create(0.2)
    nicon.icon:setPosition(self:getTeamMemberPos(index))
    nicon.icon:runAction(action)
  else
    action = CCMoveTo:create(0.2, self:getTeamMemberPos(index))
    action = CCEaseSineOut:create(action)
    nicon.icon:runAction(action)
  end
  heroIcon:showSelectTag()
  self:refreshgs()
  self:refreshAddition()
  refreshKarlElementByTeam(self)
  self:refreshLegendEquip()
  self.select_count = self.select_count + 1
  self.uiMonRig:refreshpreseHeros()
  self.uiMonRig:refreshRecomHeroIcon()
end

class.addTeamMember = addTeamMember

local function destroyTeamMember(self, tid, skipAnim, mercenary, uid, ignore)
  if self.mode == "TryUseMode" and tid == self.tryUseHeroID then
    ed.showToast(T("\230\151\160\230\179\149\230\146\164\231\166\187\232\175\165\232\139\177\233\155\132"))
    return
  end
  if self.mode == "arcanaTrial" and tid == self.arcanaUseHeroID then
    ed.showToast(T("\230\151\160\230\179\149\230\146\164\231\166\187\232\175\165\232\139\177\233\155\132"))
    return
  end
  if self.mode == "GuildMountBoss" and not self.objData.test then
    local extraTime = ed.GuildMountManager:getExtraTime()
    if extraTime then
      ed.showToast(T("\229\189\147\229\137\141\228\184\186\232\161\165\230\151\182\231\138\182\230\128\129\239\188\140\232\139\177\233\155\132\229\183\178\233\148\129\229\174\154"))
      return
    end
  end
  if self.tag == "banhero" and self:checkIsBanSeleteMode() then
    self:addBanHero(tid, mercenary, uid)
    return
  end
  if ignore == nil or not ignore then
    local noForce, ret, isArtifact = self:checkHeroTask(nil, tid, false)
    if ret then
      local heroName = ed.getDataTable("Unit")[tid]["Display Name"]
      local text = T("\230\146\164\231\166\187%s\229\176\134\230\151\160\230\179\149\229\174\140\230\136\144\232\167\137\233\134\146\228\187\187\229\138\161\239\188\140\232\175\183\233\151\174\230\152\175\229\144\166\229\157\154\230\140\129\230\146\164\231\166\187\239\188\159")
      local heroStyle = true
      if isArtifact then
        text = T("\230\146\164\231\166\187%s\229\176\134\230\151\160\230\179\149\229\174\140\230\136\144\231\165\158\229\153\168\228\187\187\229\138\161\239\188\140\232\175\183\233\151\174\230\152\175\229\144\166\229\157\154\230\140\129\230\146\164\231\166\187\239\188\159")
        heroStyle = "superherotask"
      end
      local info = {
        text = string.format(text, heroName),
        leftText = T("\231\161\174\229\174\154"),
        heroStyle = heroStyle,
        leftHandler = function()
          self:destroyTeamMember(tid, skipAnim, mercenary, uid, true)
        end,
        rightText = T("\229\143\150\230\182\136"),
        rightHandler = function()
          xpcall(function()
          end, EDDebug)
        end
      }
      ed.showConfirmDialog(info)
      return
    end
  end
  if tid == ed.getChallengeHero(self.stage) then
    ed.showToast("\230\151\160\230\179\149\230\146\164\231\166\187\232\175\165\232\139\177\233\155\132")
    return
  end
  local heroIcon = getHeroIcon(self, tid, mercenary, uid)
  if not heroIcon or not heroIcon.memberid then
    return
  end
  if mercenary == true then
    currentMercenary = nil
  end
  local member = self.team[heroIcon.memberid].icon
  local teamIcon = member.icon
  local licon = heroIcon.icon
  setKarlElementByExistTeam(self, false, tid)
  self.isDestroyTeamMember[tid] = true
  heroIcon:deleteSelectTag()
  self:orderTeam(tid, false, mercenary, uid)
  if self.aura_hint then
    self.aura_hint:RemoveAura(tid)
  end
  if skipAnim or nil ~= self.ui.teamDraglist then
    teamIcon:removeFromParentAndCleanup(true)
    self.isDestroyTeamMember[tid] = nil
  else
    local posx, posy = licon:getPosition()
    local epos = licon:getParent():convertToWorldSpace(ccp(posx, posy))
    epos = teamIcon:getParent():convertToNodeSpace(epos)
    local bx, by = teamIcon:getPosition()
    local action = CCMoveTo:create(0.3, ccp((bx + epos.x) / 2, (by + epos.y) / 2))
    action = CCEaseSineIn:create(action)
    local fade = CCFadeOut:create(0.3)
    local spawn = CCSpawn:createWithTwoActions(action, fade)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(teamIcon) then
          teamIcon:removeFromParentAndCleanup(true)
          self.isDestroyTeamMember[tid] = nil
        end
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(spawn, func)
    teamIcon:runAction(sequence)
  end
  heroIcon.memberid = nil
  self:refreshgs()
  self:refreshAddition()
  refreshKarlElementByTeam(self)
  self:refreshLegendEquip()
  self.select_count = self.select_count - 1
  self.uiMonRig:refreshpreseHeros()
  self.uiMonRig:refreshRecomHeroIcon()
end

class.destroyTeamMember = destroyTeamMember

function class:checkTeamClickValid(teamData)
  if self.mode == "GuildMountBoss" and not self.objData.test then
    local extraTime = ed.GuildMountManager:getExtraTime()
    local lineup = extraTime and extraTime._lineup or {}
    local isLock = ed.isElementInTable(teamData.heroIcon.info.id, lineup)
    if isLock then
      ed.showToast(T("\229\189\147\229\137\141\228\184\186\232\161\165\230\151\182\231\138\182\230\128\129\239\188\140\232\139\177\233\155\132\229\183\178\233\148\129\229\174\154"))
    end
    return not isLock
  end
  return true
end

local function doTeamTouch(self)
  local pressid
  local pressX, pressY = 0, 0
  
  local function handler(event, x, y)
    if event == "began" then
      if self:checkIsBanSeleteMode() and self.tag == "banhero" then
        return
      end
      if nil ~= self.ui.teamDraglist then
        local wRect = self.ui.teamDraglist:getTouchArea()
        if not wRect:containsPoint(ccp(x, y)) then
          return
        end
      end
      pressX, pressY = x, y
      for i = 1, #self.team do
        local icon = self.team[i].icon.icon
        if tolua.isnull(icon) then
          return
        end
        if icon:numberOfRunningActions() > 0 then
          return
        end
        if ed.containsPoint(icon, x, y) then
          if not self:checkTeamClickValid(self.team[i]) then
            return
          end
          pressid = i
          icon:setScale(self.iconScale - 0.05)
        end
      end
    elseif event == "moved" then
      local dx = x - pressX
      local dy = y - pressY
      local dis = math.sqrt(dx * dx + dy * dy)
      if 14 < dis then
        pressid = nil
      end
    elseif event == "ended" then
      local id = pressid
      pressid = nil
      if id then
        local icon = self.team[id].icon.icon
        icon:setScale(self.iconScale)
        if ed.containsPoint(icon, x, y) then
          lsr:report("clickTeamRemoveHero")
          local mercenaryData = self.team[id].heroIcon.info.mercenary
          local uid = mercenaryData and mercenaryData.uid or nil
          self:destroyTeamMember(self.team[id].heroIcon.info.id, false, mercenaryData ~= nil, uid)
        end
      end
    end
  end
  
  return handler
end

class.doTeamTouch = doTeamTouch

local function doTeamHeroTouch(self)
  local passHeroIcon, passHeroData
  
  local function handler(event, x, y)
    if event == "began" then
      if self.pvpMode and self.pvpMode == "attack" then
        for i, v in ipairs(self.teamNewIdenxTabs) do
          for ii, vv in ipairs(v) do
            if not tolua.isnull(vv) and vv:isVisible() and ed.containsPoint(vv, x, y) then
              passHeroIcon = vv
              if self.topHeros then
                passHeroData = ed.copyProto(self.topHeros[ii] or {})
              else
                passHeroData = self.objData.headData[i][ii] or {}
              end
              return
            end
          end
        end
      end
    elseif event == "ended" and self.pvpMode and self.pvpMode == "attack" and passHeroIcon and ed.containsPoint(passHeroIcon, x, y) then
      if self.topHeros then
        ed.ui.checkOthersHeroWindow.create():popWindow()
        ed.PlayerInfoNetwork:requestHeroData(self.objData._summary._role_id, passHeroData._tid)
        return
      end
      local info = {
        _tid = passHeroData.id,
        _rank = passHeroData.rank > 0 and passHeroData.rank or 1,
        _stars = passHeroData.stars,
        _level = passHeroData.level,
        _gs = passHeroData.gs or 0,
        _items = passHeroData.item or {}
      }
      ed.ui.checkOthersHeroWindow.create(info):popWindow()
    end
  end
  
  return handler
end

class.doTeamHeroTouch = doTeamHeroTouch

local function doBanTouch(self)
  local pressid
  
  local function handler(event, x, y)
    if event == "began" then
      if not self:checkIsBanSeleteMode() or not self.tag == "banhero" then
        return
      end
      if self.banTeam[1].banHero then
        local icon = self.banTeam[1].banHero.icon
        if tolua.isnull(icon) then
          return
        end
        if icon:numberOfRunningActions() > 0 then
          return
        end
        if ed.containsPoint(icon, x, y) then
          pressid = 1
          icon:setScale(self.iconScale - 0.05)
        end
      end
    elseif event == "ended" then
      local id = pressid
      pressid = nil
      if id then
        local icon = self.banTeam[1].banHero.icon
        icon:setScale(self.iconScale)
        if ed.containsPoint(icon, x, y) then
          lsr:report("clickTeamRemoveHero")
          self:destroyBanHeroMember(self.banTeam[1].banHero.info.id)
        end
      end
    end
  end
  
  return handler
end

class.doBanTouch = doBanTouch

local function doPressInList(self)
  local function handler(x, y)
    if self.tag == "mercenary" then
      if self.mercenaryIcon == nil then
        return
      end
      for i = 1, #self.mercenaryIcon do
        local icon = self.mercenaryIcon[i].icon
        if not icon then
          return
        end
        if ed.containsPoint(icon, x, y) then
          icon:setScale(self.iconScale - 0.05)
          return i
        end
        local searchIcon = self.mercenaryIcon[i].searchIcon
        if not searchIcon then
          return
        end
        if ed.containsPoint(searchIcon, x, y) then
          searchIcon:setScale(0.9)
          return i
        end
      end
      return
    end
    if self.tag ~= "wholeteam" and self.tag ~= "banhero" and self.tag ~= "recommend" then
      return
    end
    if self.tag == "recommend" then
      local list = self.listData[self:getClid()] or {}
      for i = 1, #list do
        local tid = self.listData[self:getClid()][i]._tid
        if not (self.heroIcon or {})[tid] then
          return
        end
        if ed.containsPoint(self.heroIcon[tid].icon, x, y) then
          self.heroIcon[self.listData[self:getClid()][i]._tid].icon:setScale(self.iconScale - 0.05)
          return i
        end
      end
      return
    end
    local list = self.listData[self:getClid()] or {}
    for i = 1, #list do
      if not (self.heroIcon or {})[self.listData[self:getClid()][i]._tid] then
        return
      end
      if ed.containsPoint(self.heroIcon[self.listData[self:getClid()][i]._tid].icon, x, y) then
        self.heroIcon[self.listData[self:getClid()][i]._tid].icon:setScale(self.iconScale - 0.05)
        return i
      end
    end
    if self.mode == "crusade" and not self.tbc_rush_mode then
      if ed.containsPoint(self.ui.energy_bean_background, x, y) then
        self:showDetailCard(20057, self.ui.relive_item_background)
      elseif ed.containsPoint(self.ui.relive_item_background, x, y) then
        self:showDetailCard(2548, self.ui.relive_item_background)
      end
      return -1
    end
  end
  
  return handler
end

class.doPressInList = doPressInList

local function cancelPressInList(self)
  local function handler(x, y, id)
    self:closeDetailCard()
    
    if id < 0 then
      return
    end
    if self.tag == "mercenary" then
      self.mercenaryIcon[id].icon:setScale(self.iconScale)
      if self.mercenaryIcon[id].searchIcon then
        self.mercenaryIcon[id].searchIcon:setScale(0.8)
      end
    else
      self.heroIcon[self.listData[self:getClid()][id]._tid].icon:setScale(self.iconScale)
    end
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function cancelClickInList(self)
  local function handler(x, y, id)
    self:closeDetailCard()
    
    if id < 0 then
      return
    end
    if self.tag == "mercenary" then
      self.mercenaryIcon[id].icon:setScale(self.iconScale)
      if self.mercenaryIcon[id].searchIcon then
        self.mercenaryIcon[id].searchIcon:setScale(0.8)
      end
    else
      self.heroIcon[self.listData[self:getClid()][id]._tid].icon:setScale(self.iconScale)
    end
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList

function class:checkCondition(hero, clid, tag, id)
  if nil == hero then
    return false
  end
  if tag == "mercenary" then
    local hp_perc = hero:hp_perc(pms[self.mode])
    if nil ~= hp_perc and hp_perc <= 0 then
      if self.mode == "crusade" then
        local num = self:getHeroReliveItemNum()
        if 0 < num then
          local mercenaryInfo = self.mercenarylistData[self:getClid()][id]:getMercenaryData()
          local heroIcon = getHeroIcon(self, hero._tid, true, mercenaryInfo._uid)
          self.reliveHero = hero
          self.reliveHeroIcon = heroIcon
          ed.ui.heroReliveWin.create(hero._tid, heroIcon.info)
        else
          ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\233\152\181\228\186\161,\228\184\141\232\131\189\228\184\138\229\156\186"))
        end
        return false
      else
        ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\233\152\181\228\186\161,\228\184\141\232\131\189\228\184\138\229\156\186"))
        return false
      end
    end
    local mercenaryInfo = self.mercenarylistData[self:getClid()][id]:getMercenaryData()
    if self.mode == "GuildMountBoss" and not self.objData.test and ed.GuildMountManager:isHeroUsed(hero._tid) and not self.objData.practice then
      ed.showToast(T("\230\175\143\229\144\141\232\139\177\233\155\132\239\188\140\230\175\143\230\151\165\229\143\170\229\143\175\229\135\186\230\136\152\228\184\128\230\172\161"))
      return false
    end
    if mercenaryInfo._sort then
      if mercenaryInfo._sort == "bHired" then
        ed.showToast(T("\228\189\160\228\187\138\229\164\169\229\183\178\231\187\143\233\155\135\228\189\163\232\191\135\232\191\153\228\184\170\231\142\169\229\174\182\231\154\132\228\189\163\229\133\181"))
        return false
      end
      if mercenaryInfo._sort == "bLevel" then
        local limitlevel = ed.player:getLevel() + ed.getDataTable("VIP")[ed.player:getvip()]["Hire Hero Level Limit"]
        ed.showToast(T("\228\184\141\232\131\189\233\155\135\228\189\163\231\173\137\231\186\167\232\182\133\232\191\135%d\231\154\132\228\189\163\229\133\181", limitlevel))
        return false
      end
    end
  elseif tag == "recommend" then
    if not ed.player.heroes[hero._tid] then
      ed.showToast(T("\232\191\152\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
      return false
    end
  else
    if self.pvpMode == "defend" or self.pvpMode == "localbattle" then
      return true
    end
    if self.mode == "GuildClash" and self:checkHeroUsed(hero._tid) then
      ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\229\156\168\229\133\182\228\187\150\233\152\159\228\188\141"))
      return false
    end
    local hp_perc = hero:hp_perc(pms[self.mode])
    if nil ~= hp_perc then
      if hp_perc <= 0 then
        if self.mode == "crusade" then
          local num = self:getHeroReliveItemNum()
          if 0 < num then
            self.reliveHero = hero
            self.reliveHeroIcon = self.heroIcon[hero._tid]
            ed.ui.heroReliveWin.create(hero._tid)
          else
            ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\233\152\181\228\186\161,\228\184\141\232\131\189\228\184\138\229\156\186"))
          end
          return false
        else
          ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\233\152\181\228\186\161,\228\184\141\232\131\189\228\184\138\229\156\186"))
          return false
        end
      end
      if self.mode == "crusade" and self.tbc_rush_mode and hero._level < min_crusade_rush_level then
        ed.showToast(T("\228\189\142\228\186\142%d\231\186\167\231\154\132\232\139\177\233\155\132\228\184\141\232\131\189\228\184\138\229\156\186", min_crusade_rush_level))
        return false
      end
      if self.mode == "crusade" and hero._level < min_crusade_level then
        ed.showToast(T("\228\189\142\228\186\142%d\231\186\167\231\154\132\232\139\177\233\155\132\228\184\141\232\131\189\228\184\138\229\156\186", min_crusade_level))
        return false
      end
    end
    if self.mode == "GuildMountBoss" then
      if self.objData.practice then
        return true
      end
      if not self.objData.test and ed.GuildMountManager:isHeroUsed(hero._tid) then
        ed.showToast(T("\230\175\143\229\144\141\232\139\177\233\155\132\239\188\140\230\175\143\230\151\165\229\143\170\229\143\175\229\135\186\230\136\152\228\184\128\230\172\161"))
        return false
      end
    end
  end
  return true
end

local function doClickInList(self)
  local function handler(x, y, id)
    if id < 0 then
      return
    end
    if self.lock then
      return
    end
    local hero
    if self.tag == "mercenary" then
      if ed.containsPoint(self.mercenaryIcon[id].icon, x, y) then
        hero = self.mercenarylistData[self:getClid()][id]
      elseif self.mercenaryIcon[id].searchIcon and ed.containsPoint(self.mercenaryIcon[id].searchIcon, x, y) then
        hero = self.mercenarylistData[self:getClid()][id]
        ed.ui.checkOthersHeroWindow.create():popWindow()
        ed.GuildNetwork:sendQueryDetail(hero.mercenaryData._uid, hero.data._tid)
        return
      else
        return
      end
    elseif self.tag == "recommend" then
      hero = self.listData[self:getClid()][id]
    else
      hero = self.listData[self:getClid()][id]
    end
    if false == self:checkCondition(hero, self:getClid(), self.tag, id) then
      return
    end
    if self.tag == "mercenary" then
      local mercenaryInfo = hero:getMercenaryData()
      local uid = mercenaryInfo and mercenaryInfo._uid or nil
      if not self.mercenaryIcon[id].isSelected then
        self:addTeamMember(hero._tid, true, uid)
      else
        self:destroyTeamMember(hero._tid, false, true, uid)
      end
      return
    end
    if self.tag == "recommend" then
      if not self.heroIcon[hero._tid].isSelected then
        self:addTeamMember(hero._tid)
      else
        lsr:report("clickHeadRemoveHero")
        self:destroyTeamMember(hero._tid)
      end
      return
    end
    if self.isAddHeroTutorial and hero._tid == 4 then
      self.isAddHeroTutorial = nil
    end
    if self.tutorialSelectHeroId then
      if self:getClid() ~= "all" then
        self:doChangeList("all")
      end
      local isCancel = false
      for i = 1, #self.tutorialSelectHeroId do
        if self.tutorialSelectHeroId[i] == id then
          table.remove(self.tutorialSelectHeroId, i)
          isCancel = true
          break
        end
        if i == #self.tutorialSelectHeroId then
          table.insert(self.tutorialSelectHeroId, id)
        end
      end
      if #self.tutorialSelectHeroId == 0 then
        table.insert(self.tutorialSelectHeroId, id)
      end
      if #self.tutorialSelectHeroId == 3 then
        local pos = self.ui.go:getParent():convertToWorldSpace(ccp(self.ui.go:getPosition()))
        local size = self.ui.go:getContentSize()
      elseif not isCancel then
        for i = 1, 3 do
          local isThis = true
          for j = 1, #self.tutorialSelectHeroId do
            if i == self.tutorialSelectHeroId[j] then
              isThis = false
              break
            end
          end
          if self.listData[self:getClid()][i] then
            local ntid = self.listData[self:getClid()][i]._tid
            if isThis and not self.hasSelectHeroAmount[ntid] then
              local size = self.heroIcon[ntid].icon:getContentSize()
              self.hasSelectHeroAmount[ntid] = true
              break
            end
          end
        end
      end
    end
    local islock = false
    if not self.heroIcon[self.listData[self:getClid()][id]._tid].isSelected then
      self:addTeamMember(self.listData[self:getClid()][id]._tid)
    elseif not self:myIsValid(self.listData[self:getClid()][id]._tid) then
    else
      lsr:report("clickHeadRemoveHero")
      self:destroyTeamMember(self.listData[self:getClid()][id]._tid)
    end
  end
  
  return handler
end

class.doClickInList = doClickInList

function class:myIsValid(mid)
  if self.mode == "GuildMountBoss" and not self.objData.test then
    local extraTime = ed.GuildMountManager:getExtraTime()
    local lineup = extraTime and extraTime._lineup or {}
    local isLock = ed.isElementInTable(mid, lineup)
    if isLock then
      ed.showToast(T("\229\189\147\229\137\141\228\184\186\232\161\165\230\151\182\231\138\182\230\128\129\239\188\140\232\139\177\233\155\132\229\183\178\233\148\129\229\174\154"))
    end
    return not isLock
  end
  return true
end

local function checkIsCanHeroTags(self)
  local st = ed.getDataTable("Stage")
  local row = st[self.stage] or {}
  local tags = row.CanHeroTags or {}
  return 0 < #tags
end

class.checkIsCanHeroTags = checkIsCanHeroTags

local function getStageRequirementTags(self)
  local st = ed.getDataTable("Stage")
  local row = st[self.stage] or {}
  return row.CanHeroTags
end

class.getStageRequirementTags = getStageRequirementTags

local function addListTitle(self)
  if self.listTitle then
    self.draglist.listLayer:removeChild(self.listTitle, true)
  end
  if not tolua.isnull(self.listTitleEx) then
    self.listTitleEx:removeFromParentAndCleanup(true)
    self.listTitleEx = nil
  end
  local listTitle, listTitleBg
  local bMercenaryVisible = self:canShowMercenary()
  if self.mode == "crusade" then
    if self.tag == "mercenary" and bMercenaryVisible then
      listTitle = ed.createLabelWithFontInfo(T("\230\175\143\230\172\161\232\191\156\229\190\129\229\143\175\228\187\165\233\128\137\230\139\169\233\155\135\228\189\163\228\184\128\228\189\141\232\139\177\233\155\132"), "title_yellow")
    elseif self.tbc_rush_mode then
      listTitle = ed.createLabelWithFontInfo(T("65\231\186\167\228\187\165\228\184\138\232\139\177\233\155\132\230\137\141\232\131\189\229\143\130\229\138\160\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129\230\137\171\232\141\161"), "title_yellow")
    elseif bMercenaryVisible then
      listTitle = ed.createLabelWithFontInfo(T("\230\175\143\230\172\161\232\191\156\229\190\129\229\143\175\228\187\165\233\128\137\230\139\169\233\155\135\228\189\163\228\184\128\228\189\141\232\139\177\233\155\132"), "title_yellow")
    end
  elseif self.mode == "tower" then
    if self.tag == "mercenary" then
      listTitle = ed.createLabelWithFontInfo(T("\230\175\143\230\172\161\232\191\156\229\190\129\229\143\175\228\187\165\233\128\137\230\139\169\233\155\135\228\189\163\228\184\128\228\189\141\232\139\177\233\155\132"), "title_yellow")
    else
    end
  elseif self.mode == "guildInstance" then
    listTitle = ed.createLabelWithFontInfo(T("\232\175\183\229\156\168%d\231\167\146\229\134\133\229\188\128\229\167\139\230\136\152\230\150\151", self.prepareTime), "title_yellow")
  elseif self.mode == "dreamland" and self.hero_all_list then
    listTitle = ed.createLabelWithFontInfo(T("\230\180\187\229\138\168\230\151\182\233\151\180\229\134\133\228\187\133\232\131\189\228\189\191\231\148\168\229\133\172\230\181\139\229\137\141\232\139\177\233\155\132\228\184\138\229\156\186"), "title_yellow")
  elseif self.heroLimit and self.heroLimit.type == "rank" then
    local rank = self.heroLimit.detail
    local rank_info = ed.ui.herodetail.res.equip_rank_info[rank]
    listTitle = ed.createLabelWithFontInfo(T("\229\143\170\230\156\137%s\229\147\129\233\152\182\229\143\138\228\187\165\228\184\138\231\154\132\232\139\177\233\155\132\229\143\175\228\187\165\232\191\155\229\133\165\232\191\153\228\184\170\229\133\179\229\141\161", rank_info.name), "title_yellow")
  elseif self:checkIsCanHeroTags() then
    listTitle = ed.createLabelWithFontInfo(T("\232\175\165\229\133\179\229\141\161\229\143\170\230\156\137\231\137\185\229\174\154\231\154\132\233\131\168\229\136\134\232\139\177\233\155\132\229\143\175\228\187\165\232\191\155\229\133\165"), "title_yellow")
  elseif self.mode == "arcanaTrial" then
    listTitle = ed.createLabelWithFontInfo(T("\229\143\170\230\156\137\230\179\176\229\157\166\232\139\177\233\155\132\229\143\175\228\187\165\229\143\130\228\184\142\232\175\149\231\130\188"), "title_yellow")
  elseif self.mode == "GuildMountBoss" then
    if self.objData.practice then
      listTitle = ed.createLabelWithFontInfo(T("\230\156\172\230\168\161\229\188\143\230\136\152\230\150\151\231\187\147\230\158\156\228\184\141\231\148\159\230\149\136\239\188\140\228\187\133\228\190\155\231\187\131\228\185\160\228\189\191\231\148\168"), "title_yellow")
    elseif not self.objData.test then
      listTitle = ed.createLabelWithFontInfo(T("\230\175\143\229\144\141\232\139\177\233\155\132\239\188\140\230\175\143\230\151\165\229\143\170\229\143\175\229\135\186\230\136\152\228\184\128\230\172\161"), "title_yellow")
    end
  end
  local thisCon = self.ui.heros_items:getContentSize()
  hero_icon_ori_y = thisCon.height + 181.5 - hero_icon_gap_x / 2
  if listTitle then
    listTitleBg = listTitleBg or ed.createSprite("UI/alpha/1080P/raid/time_bg.png")
    listTitleBg:setPosition(ccp(80, 10))
    listTitle:addChild(listTitleBg, -1)
    listTitleBg:setScaleY(0.8)
    listTitle:setPosition(123 + thisCon.width / 2 - 45, hero_icon_ori_y + 30)
    self.draglist:addItem(listTitle)
    self.listTitle = listTitle
  end
end

local function addItemNum(self)
  if self.mode == "crusade" and not self.tbc_rush_mode then
    if self.itemNumNode then
      self.itemNumNode:removeFromParentAndCleanup(true)
      self.itemNumNode = nil
    end
    if not self.listTitle then
      hero_icon_ori_y = hero_icon_ori_y + 27
    end
    local thisCon = self.ui.heros_items:getContentSize()
    hero_icon_ori_y = hero_icon_ori_y
    local flag_energy_bean_num = self.mode == "crusade" and not self.tbc_rush_mode
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "energy_bean_background",
          res = "UI/alpha/1080P/crusade/kaikouxiao_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(186, hero_icon_ori_y)
        },
        config = {visible = flag_energy_bean_num}
      },
      {
        t = "Sprite",
        base = {
          name = "energy_bean",
          res = "UI/alpha/1080P/crusade/energbean.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(161, hero_icon_ori_y)
        },
        config = {visible = flag_energy_bean_num}
      },
      {
        t = "Label",
        base = {
          name = "energy_bean_num",
          text = "\195\151" .. ed.player:getEnergyBeanNum(),
          size = 21
        },
        layout = {
          position = ccp(201, hero_icon_ori_y)
        },
        config = {
          color = ccc3(220, 220, 220),
          visible = flag_energy_bean_num
        }
      },
      {
        t = "Sprite",
        base = {
          name = "relive_item_background",
          res = "UI/alpha/1080P/crusade/kaikouxiao_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(306, hero_icon_ori_y)
        },
        config = {visible = flag_energy_bean_num}
      },
      {
        t = "Sprite",
        base = {
          name = "relive_item",
          res = "UI/alpha/1080P/crusade/kaikouxiao.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(281, hero_icon_ori_y)
        },
        config = {visible = flag_energy_bean_num}
      },
      {
        t = "Label",
        base = {
          name = "relive_item_num",
          text = "\195\151" .. self:getHeroReliveItemNum(),
          size = 21
        },
        layout = {
          position = ccp(321, hero_icon_ori_y)
        },
        config = {
          color = ccc3(220, 220, 220),
          visible = flag_energy_bean_num
        }
      }
    }
    local node = CCNode:create()
    local readNode = ed.readnode.create(node, self.ui)
    readNode:addNode(ui_info)
    self.draglist:addItem(node)
    self.itemNumNode = node
  end
end

local function sortHeroByLevel(mercenaryHeros)
  local function levelMercenary(hero)
    return hero._level
  end
  
  table.sort(mercenaryHeros, function(a, b)
    return levelMercenary(a) > levelMercenary(b)
  end)
end

local function sortHeroByGS(mercenaryHeros)
  table.sort(mercenaryHeros, function(a, b)
    return a._gs > b._gs
  end)
end

local function sortHeroByAdventureAddition(actId, heros)
  local actiAdventureMgr = ed.actiAdventureMgr.getInstance()
  table.sort(heros, ed.cmpSort({
    {
      getValue = function(hero)
        return actiAdventureMgr:getHeroAddition(actId, hero._tid)
      end,
      reverse = true
    },
    {key = "_level", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_stars", reverse = true},
    {key = "_tid"}
  }))
end

local function sortHeroByPvpActivity(self, heros)
  table.sort(heros, ed.cmpSort({
    {
      getValue = function(hero)
        return ed.readhero.isSpecialFreeHeroID(hero._tid) and 1 or 0
      end,
      reverse = true
    },
    {
      getValue = function(hero)
        local result = self:checkHeroInCondition(hero)
        if type(result) == "boolean" then
          return result and 1 or 0
        elseif type(result) == "number" then
          return result
        end
        return 0
      end,
      reverse = true
    },
    {key = "_level", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_stars", reverse = true},
    {
      getValue = function(hero)
        local aInitStar = ed.getDataTable("Unit")[ed.readhero.convertToOriginID(hero._tid)]["Initial Stars"]
        return aInitStar
      end,
      reverse = true
    },
    {key = "_gs", reverse = true},
    {key = "_tid"}
  }))
end

class.sortHeroByPvpActivity = sortHeroByPvpActivity
local condition = {
  fishman = function(hero)
    return ed.isElementInTable(hero._tid, {14, 10012})
  end
}
class.condition = condition

local function checkHeroInCondition(self, hero)
  local tag = self.pvpActivityInfo and self.pvpActivityInfo.activityTag
  if not tag or not hero then
    return false
  end
  if self.condition[tag] then
    return self.condition[tag](hero)
  end
  return false
end

class.checkHeroInCondition = checkHeroInCondition

local function sortMercenaryHeros(data)
  local list, blist, mlist = {}, {}, {}
  for i, v in ipairs(data) do
    if v.mercenaryData._sort == "cHired" then
      table.insert(blist, v)
    else
      table.insert(mlist, v)
    end
  end
  sortHeroByGS(blist)
  sortHeroByGS(mlist)
  for i, v in ipairs(blist) do
    table.insert(list, v)
  end
  for i, v in ipairs(mlist) do
    table.insert(list, v)
  end
  return list
end

local function adjustGuildheroPos(heros)
  for idx, hero in ipairs(heros) do
    local uid = hero.mercenaryData._uid
    if ed.readhero.isGuildheroMercenary({uid = uid}) then
      table.remove(heros, idx)
      table.insert(heros, 1, hero)
      break
    end
  end
end

local function refreshMercenaryList(self, data)
  if nil == data then
    return
  end
  local filterData = {}
  for i = 1, #data do
    local hero = ed.player:getHero(data[i]._tid)
    if hero == nil or not (hero._level > data[i]._level + 10) then
      table.insert(filterData, data[i])
    end
  end
  local heroes
  if self.heroLimit and self.heroLimit.type == "rank" then
    heroes = ed.readhero.getAllListWithLimit(self.heroLimit, filterData, self.titanLimit)
  else
    heroes = ed.readhero.getAllListWithLimit(self.heroLimit or {}, filterData, self.titanLimit)
  end
  local heros = sortMercenaryHeros(heroes)
  self.listData.mercenary = heros
  local all, front, middle, back = ed.readhero.classify("prepare", "position", {}, heros)
  local a, STR, AGI, INT = ed.readhero.classify("prepare", "type", {}, heros)
  local collect = ed.HeroRecommendManager:filtrCollectHero(all)
  self.mercenarylistData = {
    all = all,
    collect = collect,
    front = front,
    middle = middle,
    back = back,
    str = STR,
    agi = AGI,
    int = INT
  }
  self:registerUpdateHandler("asyncCreateMercenary", self:asyncCreateMercenary())
end

local function refreshMercenaryIcon(self, money)
  if self.mercenaryIcon then
    for i, v in ipairs(self.mercenaryIcon) do
      local mercenaryInfo = v.info.mercenary
      if mercenaryInfo and money > mercenaryInfo.cost and v.costLabel then
        ed.setLabelFontInfo(v.costLabel, "normal_button")
      end
    end
  end
end

local function onMercenaryList(self)
  if self.hireMercenary ~= nil then
    return
  end
  if ed.player:getGuildId() == 0 then
    return
  end
  bReqMercenary = true
  local msg = ed.upmsg.guild()
  msg._query_hires = {}
  if prepareInfo.mode == "crusade" then
    msg._query_hires._from = "tbc"
  elseif "tower" == self.mode then
    msg._query_hires._from = "tower"
  elseif prepareInfo.mode == "GuildMountBoss" then
    msg._query_hires._from = "guild_mount"
  else
    msg._query_hires._from = "stage"
  end
  ed.send(msg, "guild")
end

local function doChangeList(self, key)
  lsr:report("clickChangeList")
  if key == (self:getClid() or "all") then
    return
  end
  self:setClid(key)
  self:refreshListButton(key)
  addListTitle(self)
  addItemNum(self)
  if self.tag == "recommend" then
    self:createList(self.listData[key .. "recommend"] or {})
  else
    self:createList(self.listData[key] or {})
  end
end

class.doChangeList = doChangeList

local function refreshListButton(self, key)
  for k, v in pairs(self.listButton) do
    if k == key then
      self.listButton[k]:setVisible(false)
      self.buttonPress[k]:setVisible(true)
    else
      self.listButton[k]:setVisible(true)
      self.buttonPress[k]:setVisible(false)
    end
  end
end

class.refreshListButton = refreshListButton

local function refreshTagButton(self, clid)
  for k, v in pairs(self.tagButtonSelect) do
    if k == clid then
      self.tagButtonSelect[k]:setVisible(true)
    else
      self.tagButtonSelect[k]:setVisible(false)
    end
  end
end

class.refreshTagButton = refreshTagButton

local function doChangeTag(self, id)
  lsr:report("clickChangeList")
  if id == (self.tag or "wholeteam") then
    return
  end
  self.tag = id
  if self:checkIsBanSeleteMode() then
    if self.tag == "wholeteam" then
      self:nextHeroTeamPage()
    elseif self.tag == "banhero" then
      self:nextBanHeroPage()
    end
  end
  self:refreshTagButton(self.tag)
  self:refreshListButton(self:getClid())
  if id == "mercenary" and bReqMercenary == false then
    onMercenaryList(self)
  end
  if self.tag == "wholeteam" then
    if self:getClid() == "preset" then
      self:refreshPresetList()
    else
      self:createList(self.listData[self:getClid()] or {})
    end
  elseif self.tag == "banhero" then
    self:createList(self.listData[self:getClid()] or {})
  elseif self.tag == "recommend" then
    if self.recommendData then
      self:doChangeList("all")
    else
      self:doChangeList("all")
    end
  elseif self.tag == "firework" then
    self:doChangeList("firework")
  else
    self:createList(self.listData[id] or {})
  end
  self.uiMonRig:showFireworkLayer(self.tag == "firework")
  self.uiMonRig:showPresetLayer(true)
  self.uiMonRig:refreshRecomLayer(self.tag == "recom")
end

class.doChangeTag = doChangeTag

function class:doInitRecommendData()
  local recommend
  if self:stageType(self.stage) == "CampTower" then
    recommend = ed.herorecommend.manager:getStageRecommend(self.stage, "race_tower")
  else
    recommend = ed.herorecommend.manager:getStageRecommend(self.stage)
  end
  if recommend then
    self:initRecommendData(recommend)
    self:createRecommendHeroIcons()
    self:doChangeList("all")
  end
end

function class:createRecommendHeroIcons()
  for _, hero in ipairs(self.recommendHeroes) do
    if not self.heroIcon[hero._tid] then
      self:createRecommendHeroIcon(hero)
    end
  end
end

function class:createRecommendHeroIcon(data)
  local cur_mode = self.mode
  if self.pvpMode == "defend" then
    cur_mode = "pvp"
  end
  local mealMode = {
    dreamland = "dreamland",
    guildInstance = "guildraid",
    pvp = "pvp"
  }
  local hero = ed.readhero.createIconByID(data._tid, {awake = true})
  local heroState = ed.player:isMercenaryHero(data._tid) == true and "mercenary" or nil
  self.heroIcon[data._tid] = hero
  if self:isSeleteEzioInValkrie(data) then
    hero:showBanTag()
  end
  if self:checkIsCanHeroTags() then
    local tags = self:getStageRequirementTags()
    if not self:checkStageTagHasHeroTag(data._tid, tags) then
      hero:showBanTag()
    end
  end
  if not ed.player.heroes[data._tid] then
    hero:addStateInfo("own")
  end
  hero:hide()
  self.listContainer:addChild(hero.icon)
  self.draglist:setFrameRect(hero.icon, hero.icon:getTextureRect())
  self.draglist:setParentClipNode(hero.icon, self.draglist.listLayer)
end

function class:initRecommendData(recommend)
  self.recommendData = recommend
  self.recommendHeroes = self:getRecommendHeroes(recommend)
  local all, front, middle, back = ed.readhero.classify("recommend", "position", {
    limit = self.heroLimit
  }, self.recommendHeroes)
  local collect = ed.HeroRecommendManager:filtrCollectHero(all)
  self.listData.allrecommend = all
  self.listData.collectrecommend = collect
  self.listData.frontrecommend = front
  self.listData.middlerecommend = middle
  self.listData.backrecommend = back
end

function class:getRecommendHeroes(recommend)
  local recommendHeroes = {}
  for _, heroid in ipairs(recommend) do
    local hero = ed.player.heroes[heroid]
    if hero then
      recommendHeroes[#recommendHeroes + 1] = hero
    else
      recommendHeroes[#recommendHeroes + 1] = self:createEmptyHero(heroid)
    end
  end
  return recommendHeroes
end

function class:createEmptyHero(tid)
  if not ed.getDataTable("Unit")[tid] then
    return
  end
  local hero = ed.commonmsg.hero()
  hero._tid = tid
  hero._level = 1
  hero._rank = ed.lookupDataTable("Unit", "Initial Rank", tid)
  hero._exp = 0
  hero._gs = 5
  hero._stars = ed.getDataTable("Unit")[tid]["Initial Stars"]
  hero._skill_levels = {}
  hero._items = {}
  hero._state = "idle"
  for i = 1, 6 do
    local item = ed.commonmsg.hero_equip()
    item._index = i
    item._item_id = 0
    item._exp = 0
    table.insert(hero._items, item)
  end
  hero._skill_levels = ed.getInitSkillLevels(tid)
  local emptyHero = ed.HeroCreate()
  emptyHero:setup(hero)
  return emptyHero
end

local function doChangeTagTouch(self)
  local pressid
  
  local function handler(event, x, y)
    if event == "began" then
      for k, v in pairs(self.tagButton) do
        if not self.tagButtonSelect[k]:isVisible() and self.tagButton[k]:isVisible() and ed.containsPoint(self.tagButton[k], x, y) then
          pressid = k
          self.tagButtonSelect[k]:setVisible(true)
          break
        end
      end
    elseif event == "ended" then
      local id = pressid
      pressid = nil
      if id then
        self.tagButtonSelect[id]:setVisible(false)
        if ed.containsPoint(self.tagButton[id], x, y) then
          self:doChangeTag(id)
        end
      end
    end
  end
  
  return handler
end

class.doChangeTagTouch = doChangeTagTouch

local function doClickBack(self)
  if not self.forbidenBack then
    lsr:report("clickBack")
    ed.popScene()
  end
end

class.doClickBack = doClickBack

local function doBackButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.butt_off
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(0.75)
      end
    elseif event == "ended" and isPress then
      if ed.containsPoint(button, x, y) then
        self:doClickBack()
      end
      button:setScale(0.85)
    end
  end
  
  return handler
end

class.doBackButtonTouch = doBackButtonTouch

local function doGoButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.go
  local point
  
  local function handler(event, x, y)
    if event == "began" then
      if not button:isVisible() then
        return
      end
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(1.05)
      end
    elseif event == "ended" and isPress then
      if ed.containsPoint(button, x, y) then
        if not point then
          doNow(self)
          point = ed.getMillionTime()
        elseif ed.getMillionTime() - point >= 2 then
          doNow(self)
          point = ed.getMillionTime()
        end
      end
      button:setScale(1)
    end
  end
  
  return handler
end

class.doGoButtonTouch = doGoButtonTouch

local function doNextButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.go_next
  local point
  
  local function handler(event, x, y)
    if event == "began" then
      if not button:isVisible() then
        return
      end
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(1.05)
      end
    elseif event == "ended" and isPress then
      if ed.containsPoint(button, x, y) then
        if not point then
          self:doChangeTag("banhero")
          point = ed.getMillionTime()
        elseif ed.getMillionTime() - point >= 0.5 then
          self:doChangeTag("banhero")
          point = ed.getMillionTime()
        end
      end
      button:setScale(1)
    end
  end
  
  return handler
end

class.doNextButtonTouch = doNextButtonTouch

local function nextBanHeroPage(self)
  ed.showToast("\229\136\135\230\141\162\229\136\176\231\166\129\231\148\168\232\139\177\233\155\132")
  local ui = self.ui
  ui.go:setVisible(true)
  ui.conform:setVisible(true)
  ui.go_next:setVisible(false)
  for i = 1, #self.team do
    local nicon = self.team[i].icon
    nicon.icon:setVisible(false)
  end
  for i = 1, #self.banTeam do
    local info = self.banTeam[i]
    if info.banHero then
      info.banHero.icon:setVisible(true)
    elseif info.icon then
      info.icon:setVisible(true)
    end
  end
end

class.nextBanHeroPage = nextBanHeroPage

local function checkIsBanSeleteMode(self)
  return self.pvpMode == "defend" and ed.isOpenBanHeroMode and not self.mode
end

class.checkIsBanSeleteMode = checkIsBanSeleteMode

local function nextHeroTeamPage(self)
  ed.showToast("\229\136\135\230\141\162\229\136\176\233\152\181\229\174\185\233\128\137\230\139\169\232\139\177\233\155\132")
  local ui = self.ui
  ui.go:setVisible(false)
  ui.conform:setVisible(false)
  ui.go_next:setVisible(true)
  for i = 1, #self.team do
    local nicon = self.team[i].icon
    nicon.icon:setVisible(true)
  end
  for i = 1, #self.banTeam do
    local info = self.banTeam[i]
    if info.banHero then
      info.banHero.icon:setVisible(false)
    elseif info.icon then
      info.icon:setVisible(false)
    end
  end
end

class.nextHeroTeamPage = nextHeroTeamPage

function class:doPresetBackButtonTouch()
  local isPress
  local ui = self.ui
  local button = ui.preset_back
  
  local function handler(event, x, y)
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(1.05)
      end
    elseif event == "ended" and isPress then
      button:setScale(1)
      if ed.containsPoint(button, x, y) then
        self.tag = "wholeteam"
        self:refreshTagButton(self.tag)
        self:setClid(self.pre_clid)
        self:refreshListButton(self:getClid())
        self:createList(self.listData[self:getClid()] or {})
        self:setPresetListVisible(false)
      end
    end
  end
  
  return handler
end

local function doPresetButtonTouch(self)
  local isPress
  local ui = self.ui
  local button = ui.preset
  
  local function handler(event, x, y)
    if not self.presetVisible then
      return
    end
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(1.05)
      end
    elseif event == "ended" and isPress then
      button:setScale(1)
      if ed.containsPoint(button, x, y) then
        self.pre_clid = self:getClid()
        self:setClid("preset")
        self:refreshListButton(self:getClid())
        if self:checkIsBanSeleteMode() then
          self:nextHeroTeamPage()
        end
        self:refreshPresetList()
        return true
      end
    end
  end
  
  return handler
end

class.doPresetButtonTouch = doPresetButtonTouch

local function doPresetBgRectTouch(self)
  local isPress
  local rect = CCRectMake(110, 160, 550, 355)
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.isPointInRect(rect, x, y) then
        isPress = true
      end
    elseif event == "ended" and isPress and ed.isPointInRect(rect, x, y) and not tolua.isnull(self.toastbg) then
      self.toastbg:setVisible(false)
    end
  end
  
  return handler
end

class.doPresetBgRectTouch = doPresetBgRectTouch

local function doMainLayerTouch(self)
  local backTouch = self:doBackButtonTouch()
  local goTouch = self:doGoButtonTouch()
  local doNextButtonTouch = self:doNextButtonTouch()
  local changeTagTouch = self:doChangeTagTouch()
  local teamTouch = self:doTeamTouch()
  local doBanTouch = self:doBanTouch()
  local presetTouch = self:doPresetButtonTouch()
  local presetBackTouch = self:doPresetBackButtonTouch()
  local presetbgTouch = self:doPresetBgRectTouch()
  local teamHeroTouch = self:doTeamHeroTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      if not self.hidePromt and event == "began" and ed.containsPoint(self.ui.bg, x, y) then
        local fade = CCFadeOut:create(0.2)
        local func = CCCallFunc:create(function()
          xpcall(function()
            if self and self.ui and not tolua.isnull(self.ui.promtContainer) then
              self.ui.promtContainer:removeFromParentAndCleanup(true)
            end
          end, EDDebug)
        end)
        local sequence = CCSequence:createWithTwoActions(fade, func)
        self.ui.promtContainer:runAction(sequence)
        self.hidePromt = true
      end
      backTouch(event, x, y)
      changeTagTouch(event, x, y)
      if not self.lock then
        goTouch(event, x, y)
        doNextButtonTouch(event, x, y)
        teamTouch(event, x, y)
        doBanTouch(event, x, y)
        if not presetTouch(event, x, y) then
          presetBackTouch(event, x, y)
        end
        presetbgTouch(event, x, y)
        teamHeroTouch(event, x, y)
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function loadMecenaryHero(self, index, step)
  if index < 1 then
    return
  end
  if self.mercenaryIcon == nil then
    self.mercenaryIcon = {}
  end
  if self.mercenaryIconAll == nil then
    self.mercenaryIconAll = {}
  end
  if index > #(self.listData.mercenary or {}) then
    self:removeUpdateHandler("asyncCreateMercenary")
    return
  end
  local data = self.listData.mercenary[index]
  local maxRange = ed.readhero.getHeroMaxRange(data._tid)
  local mercenaryData = data:getMercenaryData()
  local isPrefer = false
  if self.tbc_rush_mode and ed.isElementInTable(data._tid, self.tbc_recommend_heros or {}) then
    isPrefer = true
  end
  local hero = ed.readhero.createIcon({
    id = data._tid,
    rank = data._rank,
    level = data._level,
    stars = data._stars,
    maxRange = maxRange,
    isPrefer = isPrefer,
    hmMode = pms[self.mode],
    hp = data:hp_perc(pms[self.mode]),
    mp = data:mp_perc(pms[self.mode]),
    fashion_id = data._fashion,
    summary = data,
    mercenary = {
      owner = mercenaryData._name,
      cost = mercenaryData._cost,
      uid = mercenaryData._uid,
      sort = mercenaryData._sort,
      hire_times = mercenaryData._hire_times
    },
    shard = data._shard,
    karlElement = ed.readhero.getHeroElement(data._tid),
    legendEquip = data._legend_equip and data._legend_equip._equip
  })
  hero:showKarlElement(self.showElement)
  if self:isSeleteEzioInValkrie(data) then
    hero:showBanTag()
  end
  if self:checkIsCanHeroTags() then
    local tags = self:getStageRequirementTags()
    if not self:checkStageTagHasHeroTag(data._tid, tags) then
      hero:showBanTag()
    end
  end
  if self.mode == "GuildMountBoss" and ed.GuildMountManager:isHeroUsed(data._tid) and self.objData.practice then
    hero:showPracticeUsedTag()
  elseif self:checkHeroUsed(data._tid) then
    hero:showUsedTag()
  end
  self.mercenaryIconAll[index] = hero
  hero:hide()
  self.listContainer:addChild(hero.icon)
  self.draglist:setFrameRect(hero.icon, hero.icon:getTextureRect())
  self.draglist:setParentClipNode(hero.icon, self.draglist.listLayer)
end

class.loadMecenaryHero = loadMecenaryHero

local function checkHeroUsed(self, id)
  if self.mode == "GuildMountBoss" then
    if not self.objData.test then
      return ed.GuildMountManager:isHeroUsed(id)
    end
  elseif self.mode == "GuildClash" then
    return ed.isElementInTable(id, self.cantUseHero or {})
  end
  return false
end

class.checkHeroUsed = checkHeroUsed

local function loadHero(self, index)
  if index < 1 then
    return
  end
  if index > #self.listData.all then
    if bReqMercenary == false then
      loadMecenaryHero(self, 1)
    end
    self:prepareLoadTeam()
    return "loadHeroEnd"
  end
  local isPrefer = false
  local preferRes
  if index <= self.recommend_own_num then
    if self.tbc_rush_mode then
      isPrefer = true
    end
    if self.act_recommend_mode then
      isPrefer = true
      preferRes = "UI/alpha/1080P/battle/battle_recommend.png"
    end
  end
  local data = self.listData.all[index]
  local cur_mode = self.mode
  if self.pvpMode == "defend" then
    cur_mode = "pvp"
  end
  local mealMode = {
    dreamland = "dreamland",
    guildInstance = "guildraid",
    pvp = "pvp"
  }
  local hero = ed.readhero.createIconByHero(data, {
    hmMode = pms[self.mode],
    state = "idle",
    free_flag = data.free,
    isPrefer = isPrefer,
    preferRes = preferRes,
    mealMode = mealMode[cur_mode],
    actAdventureId = self.activityAdventureId,
    showParagonLv = self.mode == "AwakeStage",
    isShowPvpActivityMask = self:checkHeroInCondition(data),
    pvpActivityMask = self.pvpActivityInfo and self.pvpActivityInfo.battlePrepareHeroMask,
    isShowLegendEquip = ed.openLegendEquip() and not self.isIgnoreLengendEquip,
    limitRank = self.limitHeroRank
  })
  hero:showKarlElement(self.showElement)
  local heroState = ed.player:isMercenaryHero(data._tid) == true and "mercenary" or nil
  self.heroIcon[data._tid] = hero
  if self.mode == "crusade" and (data:hp_perc("crusade") or 999) <= 0 then
    self.dieHeroIcon[data._tid] = {hero = data, icon = hero}
  end
  if self.mode == "GuildMountBoss" and ed.GuildMountManager:isHeroUsed(data._tid) and self.objData.practice then
    hero:showPracticeUsedTag()
  elseif self:checkHeroUsed(data._tid) then
    hero:showUsedTag()
  end
  if self:checkHeroIsBan(data._tid) then
    self.ban_hero_icon = hero
    self.ban_hero_icon:showBanTag()
    if self:checkIsBanSeleteMode() then
      local banHero = ed.readhero.createIconByHero(data, {
        hmMode = pms[self.mode],
        state = "idle",
        free_flag = data.free,
        isPrefer = isPrefer,
        addStar = tempStar,
        mealMode = mealMode[cur_mode],
        isShowLegendEquip = ed.openLegendEquip() and not self.isIgnoreLengendEquip,
        limitRank = self.limitHeroRank
      })
      banHero:showBanTag()
      self.mainLayer:addChild(banHero.icon, 30)
      banHero.icon:setPosition(self.banTeam[1].pos)
      banHero.icon:setVisible(false)
      self.banTeam[1].banHero = banHero
    end
  end
  if self:isSeleteEzioInValkrie(data) then
    hero:showBanTag()
  end
  if self:checkIsCanHeroTags() then
    local tags = self:getStageRequirementTags()
    if not self:checkStageTagHasHeroTag(data._tid, tags) then
      hero:showBanTag()
    end
  end
  if self.damageUpHeroesMap[data._tid] then
    hero:showDamageUpItem(self.damageUpHeroesMap[data._tid])
  end
  hero:hide()
  hero:showKarlElement(self.showElement)
  self.listContainer:addChild(hero.icon)
  self.draglist:setFrameRect(hero.icon, hero.icon:getTextureRect())
  self.draglist:setParentClipNode(hero.icon, self.draglist.listLayer)
end

class.loadHero = loadHero

local function isSeleteEzioInValkrie(self, hero)
  if self.isValkrie and (hero._tid == 10015 or hero._tid == 10002 or hero._tid == 10051 or hero._tid == 10047 or hero._tid == 10048 or hero._tid == 10050 or hero._tid == 10053) then
    return true
  end
  if self.isFrozenDragon and (hero._tid == 10051 or hero._tid == 10047) then
    return true
  end
  return false
end

class.isSeleteEzioInValkrie = isSeleteEzioInValkrie

local function prepareLoadHero(self)
  addListTitle(self)
  addItemNum(self)
  self.listContainer = CCSprite:create()
  self.listContainer:setCascadeOpacityEnabled(true)
  self.listContainer:setAnchorPoint(ccp(0, 0))
  self.listContainer:setPosition(ccp(0, 0))
  self.draglist:addItem(self.listContainer)
  self.heroIcon = {}
  self.dieHeroIcon = {}
end

class.prepareLoadHero = prepareLoadHero

local function checkOutMercenary(self, tid, index)
  local hero
  local bMercenary = index == currentMercenaryIndex and self.mode == "crusade"
  if self.mode == "GuildMountBoss" and not self.objData.test then
    local extraTime = ed.GuildMountManager:getExtraTime()
    if extraTime then
      local hiredHeroId = extraTime._hired_heroid
      bMercenary = tid == hiredHeroId
    end
  end
  if bMercenary then
    hero = self.listData.mercenary[1]
  else
    hero = self:getHeroData(tid)
  end
  if nil == hero then
    return
  end
  if not (hero and hero:hp_perc(pms[self.mode])) or not (hero:hp_perc(pms[self.mode]) <= 0) then
    local t = {id = tid, bMercenary = bMercenary}
    return t
  end
end

function class:resortTeam(lastTeam)
  local teamData = {}
  local lastteam = lastTeam or {}
  for i = 1, self.availableSlotNum do
    if lastteam[i] then
      local mermber = checkOutMercenary(self, lastteam[i], i)
      if mermber then
        local hero
        if mermber.bMercenary then
          hero = self.listData.mercenary[1]
        else
          hero = self:getHeroData(mermber.id)
        end
        local hero_limit = self.heroLimit
        if not hero_limit then
          table.insert(teamData, mermber)
        elseif hero_limit.type == "rank" and hero._rank >= hero_limit.detail or hero_limit.type == "heroState" and hero._state == hero_limit.detail then
          table.insert(teamData, mermber)
        elseif not ed.isElementInTable(hero_limit.type, {"rank", "heroState"}) then
          table.insert(teamData, mermber)
        end
      end
    end
  end
  return teamData
end

function class:getLastTeam()
  local teamData = {}
  if self.pvpMode == "defend" then
    teamData = self:resortTeam(self.defandHeros) or {}
  elseif self.mode == "crusade" and not self.tbc_rush_mode then
    teamData = {}
    local lastCrusadeTeam = ed.ui.battleprepare.cruadeTeam or {}
    teamData = self:resortTeam(lastCrusadeTeam) or {}
  elseif self.mode == "guildInstance" then
    teamData = self:resortTeam(ed.ui.battleprepare.guildInstanceTeam) or {}
  elseif self.mode == "preset" then
    teamData = self.presetTeam
  elseif self.mode == "TryUseMode" then
    teamData = {}
    teamData = self:resortTeam({
      self.tryUseHeroID
    })
  elseif self.mode == "arcanaTrial" then
    local key = self:getArcanaTeamDataKey()
    local data = ed.getTeamData(key)
    data = self:fixTeamData(data)
    if not ed.isElementInTable(self.arcanaUseHeroID, data) then
      data[1] = self.arcanaUseHeroID
    end
    teamData = {}
    teamData = self:resortTeam(data)
  elseif self.mode == "mythBoss" then
    local data = self:getTeamData()
    if self:checkIsCanHeroTags() then
      local tags = self:getStageRequirementTags()
      local tagHero = {}
      for i = 1, #data do
        if self:checkStageTagHasHeroTag(data[i], tags) then
          table.insert(tagHero, data[i])
        end
      end
      data = tagHero
    end
    teamData = {}
    teamData = self:resortTeam(data)
  elseif self.mode == "CampBoss" then
    local data = self:getTeamData()
    if self:checkIsCanHeroTags() then
      local tags = self:getStageRequirementTags()
      local tagHero = {}
      for i = 1, #data do
        if self:checkStageTagHasHeroTag(data[i], tags) then
          table.insert(tagHero, data[i])
        end
      end
      data = tagHero
    end
    teamData = {}
    teamData = self:resortTeam(data)
  elseif self.mode == "CampTower" then
    local data = self:getTeamData()
    if self:checkIsCanHeroTags() then
      local tags = self:getStageRequirementTags()
      local tagHero = {}
      for i = 1, #data do
        if self:checkStageTagHasHeroTag(data[i], tags) then
          table.insert(tagHero, data[i])
        end
      end
      data = tagHero
    end
    teamData = {}
    teamData = self:resortTeam(data)
  elseif self.mode == "GuildMountBoss" then
    local data = self:getTeamData()
    if self:checkIsCanHeroTags() then
      local tags = self:getStageRequirementTags()
      local tagHero = {}
      for i = 1, #data do
        if self:checkStageTagHasHeroTag(data[i], tags) then
          table.insert(tagHero, data[i])
        end
      end
      data = tagHero
    end
    if not self.objData.test then
      local extraTime = ed.GuildMountManager:getExtraTime()
      if extraTime and extraTime._lineup then
        data = extraTime._lineup
      end
    end
    teamData = {}
    teamData = self:resortTeam(data)
  elseif self.mode == "GuildClash" then
    teamData = self:resortTeam(self.defandHeros or {})
  else
    local data = self:getTeamData()
    if ed.isOpenBanHeroMode then
      local noBanBero = {}
      for i = 1, #data do
        if self.ban_hero ~= data[i] then
          table.insert(noBanBero, data[i])
        end
      end
      data = noBanBero
    end
    if self:checkIsCanHeroTags() then
      local tags = self:getStageRequirementTags()
      local tagHero = {}
      for i = 1, #data do
        if self:checkStageTagHasHeroTag(data[i], tags) then
          table.insert(tagHero, data[i])
        end
      end
      data = tagHero
    end
    teamData = self:resortTeam(data)
  end
  for i = #teamData, self.availableSlotNum + 1, -1 do
    table.remove(teamData, i)
  end
  return teamData
end

local function refreshKarlElementByState(self)
  local state = false
  local teamData = self:getLastTeam()
  for index = 1, #teamData do
    local hero_id = teamData[index].id
    if self.mode == "GuildMountBoss" then
      if not self.objData.practice then
        if hero_id == karl_hero_tid and not ed.GuildMountManager:isHeroUsed(hero_id) then
          state = true
        end
      elseif hero_id == karl_hero_tid then
        state = true
      end
    elseif hero_id == karl_hero_tid then
      state = true
    end
  end
  setKarlElementByState(self, state)
end

local function loadTeam(self, index, validTeam)
  if index == 1 then
    self:clearTeamData()
  end
  local teamData = self:getLastTeam()
  if index < 1 then
    return
  end
  if index > #teamData then
    if 1 <= #teamData then
      self:setMemberAmount(validTeam)
    end
    self:refreshgs()
    self:refreshAddition()
    return "loadTeamEnd"
  end
  local hero_id = teamData[index].id
  if self.mode == "GuildMountBoss" and ed.GuildMountManager:isHeroUsed(hero_id) and self.objData.practice then
  elseif self:checkHeroUsed(hero_id) then
    return "loadTeamEnd"
  end
  local maxStar
  if "dreamland" == self.mode and ed.dreamland.mgr:isFairPlay() and ed.isTitanById(hero_id) then
    maxStar = ed.dreamland.mgr:getFairPlayMaxStar()
  end
  if teamData[index].bMercenary and self.hireMercenary then
    local mercenaryIcon = self.mercenaryIconAll[1]
    mercenaryIcon.memberid = validTeam
    mercenaryIcon:showSelectTag()
    local hero = self.listData.mercenary[1]
    hero.mercenary = {}
    local maxRange = ed.readhero.getHeroMaxRange(self.hireMercenary._tid)
    local stars = maxStar and math.min(maxStar, hero._stars) or hero._stars
    local icon = ed.readhero.createIcon({
      id = hero._tid,
      rank = hero._rank,
      level = hero._level,
      maxRange = maxRange,
      stars = stars,
      fashion_id = hero._fashion,
      hmMode = pms[self.mode],
      hp = hero:hp_perc("crusade"),
      mp = hero:mp_perc("crusade"),
      state = "idle",
      mercenary = hero.mercenary,
      shard = hero._shard,
      karlElement = ed.readhero.getHeroElement(hero._tid),
      legendEquip = hero:getCurrentEquip()
    })
    icon:showKarlElement(self.showElement)
    icon.icon:setPosition(self:getTeamMemberPos(validTeam))
    icon.icon:setScale(self.iconScale)
    self.ui.layTeamitems:addChild(icon.icon, 30)
    self.team[validTeam] = {icon = icon, heroIcon = mercenaryIcon}
  elseif self.heroIcon[hero_id] then
    local mealMode = {dreamland = "dreamland", guildInstance = "guildraid"}
    self.heroIcon[hero_id].memberid = validTeam
    self.heroIcon[hero_id]:showSelectTag()
    local heroInfo = self:getHeroData(hero_id)
    local tempStar = 0
    if maxStar then
      local afterStars = math.min(heroInfo._stars + (tempStar or 0), maxStar)
      tempStar = afterStars - heroInfo._stars
    end
    local icon = ed.readhero.createIconByHero(heroInfo, {
      hmMode = pms[self.mode],
      state = "idle",
      addStar = tempStar,
      mealMode = mealMode[self.mode],
      actAdventureId = self.activityAdventureId,
      showParagonLv = self.mode == "AwakeStage",
      isShowPvpActivityMask = self:checkHeroInCondition(heroInfo),
      pvpActivityMask = self.pvpActivityInfo and self.pvpActivityInfo.battlePrepareHeroMask,
      isShowLegendEquip = ed.openLegendEquip() and not self.isIgnoreLengendEquip,
      limitRank = self.limitHeroRank
    })
    icon.icon:setPosition(self:getTeamMemberPos(validTeam))
    icon:showKarlElement(self.showElement)
    icon.icon:setScale(self.iconScale)
    self.ui.layTeamitems:addChild(icon.icon, 30)
    self.team[validTeam] = {
      icon = icon,
      heroIcon = self.heroIcon[hero_id]
    }
  end
  if EDEngineVersion() >= 4 then
    ed.asyncload.preloadFcaByUnitID(ed.readhero.convertToOriginID(hero_id))
  end
  return "loadTeam", true
end

class.loadTeam = loadTeam

local function clearTeamData(self)
  for i = 1, self.totalSlotNum do
    local th = (self.team[i] or {}).heroIcon
    if th then
      local mercenary = th.info.mercenary ~= nil
      local uid = mercenary and mercenary._uid or nil
      self:destroyTeamMember(th.info.id, true, mercenary, uid)
    end
  end
end

class.clearTeamData = clearTeamData

local function tryGetHeroTaskTeam(self)
  local heroTask = ed.player:withHeroTask("working")
  heroTask = heroTask or ed.player:withHeroSuperTask("working")
  if heroTask then
    local heroTaskTable = ed.getDataTable("HeroTask")
    local row = heroTaskTable[heroTask._line][heroTask._id]
    local hid = row["Hero ID"]
    if self:checkStage(row) or row["Task Progress Type"] == "EquipItem" then
      return nil
    end
    return {hid}
  end
  return nil
end

class.tryGetHeroTaskTeam = tryGetHeroTaskTeam

function class:tryGetChallengeTeam()
  local heroId = ed.getChallengeHero(self.stage)
  if heroId then
    return {heroId}
  end
  return nil
end

local function checkReplace(ta, tb)
  local replace = false
  local param = {}
  for k, v in pairs(ta) do
    param[v] = true
  end
  for k, v in pairs(tb) do
    if not param[v] then
      replace = true
      return replace
    end
  end
  return replace
end

local function prepareLoadTeam(self)
  local teamData = self:getTeamData()
  local heroTaskTeam = self:tryGetHeroTaskTeam()
  local cgtm = self:tryGetChallengeTeam()
  if cgtm then
    heroTaskTeam = cgtm
  end
  if heroTaskTeam and checkReplace(teamData, heroTaskTeam) then
    teamData = heroTaskTeam
  end
  local teamDataFix = {}
  for i = 1, #teamData do
    if self.heroIcon[teamData[i]] then
      table.insert(teamDataFix, teamData[i])
    end
  end
  self:setTeamData(teamDataFix)
end

class.prepareLoadTeam = prepareLoadTeam

local function setPresetListVisible(self, visible)
  if not tolua.isnull(self.listTitleEx) then
    self.listTitleEx:setVisible(not visible)
  end
  self.draglist.listLayer:setVisible(not visible)
  if visible then
    self.draglist:hideScrollbar()
  else
    self.draglist:showScrollbar()
    if self.presetContainer then
      self.presetContainer:setVisible(visible)
    end
    if not tolua.isnull(self.toastbg) then
      self.toastbg:setVisible(false)
    end
  end
  for k, v in pairs(self.listButton) do
    v:setVisible(not visible)
  end
  for k, v in pairs(self.listLabel) do
    v:setVisible(not visible)
  end
  self.ui.preset_back:setVisible(visible)
  self.ui.layUp_ButOrBg:setVisible(not visible)
  self.ui.preset:setVisible(false)
end

class.setPresetListVisible = setPresetListVisible

local function createList(self, list)
  if not list then
    return
  end
  self.ui.preset:setVisible(false)
  self:setPresetListVisible(false)
  self:refreshList(list)
  if self.tag == "wholeteam" or self.tag == "banhero" or self.tag == "recommend" then
    local itemHeight = hero_icon_gap_y
    local colNum = hero_icon_wid_num
    local height = math.ceil(#list / colNum) * itemHeight + (self.listTitle and list_title_offset or 0) + (self.listTitleEx and list_title_offset or 0) + (self.itemNumNode and list_item_offset or 0)
    if self.mode == "crusade" and not self.tbc_rush_mode then
      height = height + 30
    end
    self.draglist:initListHeight(height)
  end
end

class.createList = createList

local function refreshPresetList(self)
  self:setPresetListVisible(true)
  if self.presetContainer then
    self.presetContainer:setVisible(true)
    return
  end
  if self.toastbg then
    self:noPresetTip()
    return
  end
  self.presetList = ed.readPreset()
  if #self.presetList == 0 then
    self:noPresetTip()
    return
  end
  local posX, posY = self.ui.heros_items:getPosition()
  local con = self.ui.heros_items:getContentSize()
  local channel_rect = CCRectMake(con.width, posY, 100, con.height)
  local team_rect = CCRectMake(posX, posY, con.width, con.height)
  local view = ed.heropreset.main_view.create(channel_rect, team_rect)
  view.team_component:setMode("use")
  local delegate = {
    doUse = function(list)
      self:usePresetTeam(list)
    end
  }
  view.team_component:bindCellDelegate(delegate)
  local channelId = 1
  if self.mode == "crusade" then
    channelId = 3
  elseif self.mode == "dreamland" then
    channelId = 4
  elseif self.mode == "guildInstance" then
    channelId = 5
  end
  view:changeChannel(channelId)
  self.ui.Panel_left:addChild(view:getRoot(), 200)
  self.presetContainer = view
  
  local function handler()
    local param = {}
    for _, hero in ipairs(self.team) do
      local id = hero.heroIcon.info.id
      table.insert(param, id)
    end
    return param
  end
  
  view.team_component:bindGetTeamHandler(handler)
end

class.refreshPresetList = refreshPresetList

function checkHeroIsBan(self, heroId)
  if not ed.isOpenBanHeroMode or not self.ban_hero then
    return false
  end
  return heroId == self.ban_hero
end

class.checkHeroIsBan = checkHeroIsBan

local function noPresetTip(self)
  local bg, board, label = ed.showToast("\231\155\174\229\137\141\230\178\161\230\156\137\233\162\132\232\174\190\233\152\181\229\174\185\239\188\140\232\175\183\229\136\176\232\139\177\233\155\132\233\157\162\230\157\191\232\174\190\231\189\174", {keepOn = true})
  bg:setPosition(ccp(380, 300))
  bg:setVisible(true)
  self.toastbg = bg
end

class.noPresetTip = noPresetTip

local function refreshList(self, list)
  if not list then
    return
  end
  local thisCon = self.ui.heros_items:getContentSize()
  local posX = self.ui.heros_items:getPositionX() + hero_icon_gap_x / 2
  local widthMax = thisCon.width
  hero_icon_wid_num = math.floor(widthMax / hero_icon_gap_x)
  local posXwid = widthMax % hero_icon_gap_x / 2 + posX
  for k, v in pairs(self.heroIcon) do
    v:hide()
  end
  if self.tag == "mercenary" then
    self:resetMercenaryIcon()
    local icons = self.mercenaryIcon or {}
    local colNum = 4
    local fixCol = math.floor((thisCon.width - 575) / 143)
    local fixOffsetX = (thisCon.width - 575) % 143
    colNum = fixCol + colNum
    for i, v in ipairs(icons) do
      if currentMercenary and v.info.id == currentMercenary.tid and v.info.mercenary.uid == currentMercenary.uid then
        v:showSelectTag()
      end
      v:show()
      local offset = (self.listTitle and list_title_offset or 0) + (self.listTitleEx and list_title_offset or 0) + (self.itemNumNode and list_item_offset or 0)
      local ox, oy = 152, 370 + (ed.display.winSize.height - 540)
      local dx, dy = 143 + fixOffsetX / (colNum - 1), 167
      if self.tbc_rush_mode or "tower" == self.mode or "crusade" == self.mode then
        oy = 370 + (ed.display.winSize.height - 540)
      end
      v.icon:setPosition(ccp(ox + dx * ((i - 1) % colNum), oy - offset - dy * math.floor((i - 1) / colNum)))
      v.icon:setScale(self.iconScale)
    end
    local itemHeight = 167
    self.draglist:initListHeight(math.ceil(#icons / colNum) * itemHeight + (self.listTitle and list_title_offset or 0) + (self.listTitleEx and list_title_offset or 0) + (self.itemNumNode and list_item_offset or 0), false)
    self.draglist:reset()
    return
  end
  self:hideMercenaryIcon()
  local hero = self.heroIcon
  hero_icon_ori_y = thisCon.height + 181.5 - hero_icon_gap_x / 2
  for i = 1, #list do
    local id = list[i]._tid
    if hero[id] then
      hero[id]:show()
      local offset = (self.listTitle and list_title_offset or 0) + (self.listTitleEx and list_title_offset or 0) + (self.itemNumNode and list_item_offset or 0)
      hero[id].icon:setPosition(ccp(posXwid + hero_icon_gap_x * ((i - 1) % hero_icon_wid_num), hero_icon_ori_y - offset - hero_icon_gap_y * math.floor((i - 1) / hero_icon_wid_num)))
      hero[id].icon:setScale(self.iconScale)
    end
  end
end

class.refreshList = refreshList

local function resetMercenaryIcon(self)
  if not self.mercenarylistData then
    return
  end
  self:hideMercenaryIcon()
  self.mercenaryIcon = {}
  local listData = self.mercenarylistData[self:getClid()]
  for i = 1, #listData do
    local data = listData[i]
    local merceIconAll = self.mercenaryIconAll or {}
    for j = 1, #merceIconAll do
      local mercenaryInfo = data:getMercenaryData()
      if data._tid == merceIconAll[j].info.id and mercenaryInfo ~= nil and mercenaryInfo._uid == merceIconAll[j].info.mercenary.uid then
        self.mercenaryIcon[i] = merceIconAll[j]
      end
    end
  end
end

class.resetMercenaryIcon = resetMercenaryIcon

local function refreshMercenaryMemberId(self, icon)
  for i = 1, #self.mercenaryIconAll do
    if icon.info.id == self.mercenaryIconAll[i].info.id then
      self.mercenaryIconAll[i].memberid = icon.memberid
    end
  end
end

class.refreshMercenaryMemberId = refreshMercenaryMemberId

local function hideMercenaryIcon(self)
  if self.mercenaryIcon then
    for i, v in ipairs(self.mercenaryIcon) do
      v:hide()
    end
  end
end

class.hideMercenaryIcon = hideMercenaryIcon

local function asyncCreateList(self)
  local index = 1
  local step = "loadHero"
  local validTeam = 1
  local result
  self:prepareLoadHero()
  self:createList(self.listData[self:getClid()])
  local preid = self:getClid()
  refreshKarlElementByState(self)
  
  local function handler(dt)
    xpcall(function()
      if step == "loadHero" then
        for i = index, index + 10 do
          step = self:loadHero(i) or "loadHero"
        end
        index = index + 11
      end
      if step == "loadHeroEnd" then
        index = 1
        step = "loadTeam"
      end
      if step == "loadTeam" then
        for i = 1, self.availableSlotNum + 1 do
          step, result = self:loadTeam(i, validTeam)
          if result == true then
            validTeam = validTeam + 1
          end
        end
      end
      if step == "loadTeamEnd" then
        local team_hero_ids = {}
        for i, team_member in ipairs(self.team) do
          table.insert(team_hero_ids, ed.readhero.convertToOriginID(team_member.heroIcon.info.id))
        end
        if self.aura_hint == nil then
          self.aura_hint = ed.AuraHint.create(team_hero_ids, self.team_awake_flag)
        end
        if self.aura_hint then
          self.aura_hint:Reset()
          self.aura_hint:AddTeamHint(self.team)
          self.aura_hint:Play()
        end
        self:removeUpdateHandler("asyncCreateList")
      end
      if preid ~= self:getClid() then
        self:createList(self.listData[self:getClid()])
      else
        self:refreshList(self.listData[self:getClid()])
      end
      preid = self:getClid()
    end, EDDebug)
  end
  
  return handler
end

class.asyncCreateList = asyncCreateList

local function asyncCreateMercenary(self)
  local mecenaryIndex = 1
  local step = "loadMercenary"
  local preid = self.tag
  if self.tag == "mercenary" then
    self:createList(self.listData.mercenary)
  end
  
  local function handler(dt)
    if step == "loadMercenary" then
      for i = mecenaryIndex, mecenaryIndex + 30 do
        step = self:loadMecenaryHero(i, step) or "loadMercenary"
      end
      mecenaryIndex = mecenaryIndex + 31
    end
    if self.tag == "mercenary" then
      if preid ~= self.tag then
        self:createList(self.listData.mercenary)
      else
        self:refreshList(self.listData.mercenary)
      end
    end
    preid = self.tag
  end
  
  return handler
end

class.asyncCreateMercenary = asyncCreateMercenary

local function createListLayer(self)
  local info
  local posX, posY = self.ui.heros_items:getPosition()
  local con = self.ui.heros_items:getContentSize()
  info = {
    cliprect = CCRectMake(posX, posY, con.width, con.height),
    container = self.ui.Panel_left,
    zorder = 10,
    bar = {
      bglen = con.height,
      bgpos = ccp(posX, posY + con.height / 2)
    },
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    noshade = true
  }
  self.draglist = ed.draglist.create(info)
end

class.createListLayer = createListLayer

local function checkStageTagHasHeroTag(self, hero_id, checkTags)
  local tbl = ed.getDataTable("Unit")
  local tid = hero_id
  local isHas = false
  local tags = tbl[ed.readhero.convertToOriginID(tid)]["Hero Tags"]
  local hero = ed.player.heroes[tid]
  if hero then
    tags = ed.getHeroTags(hero)
  end
  for _, tag1 in ipairs(tags) do
    for _, tag2 in ipairs(checkTags) do
      if tag1 == tag2 then
        isHas = true
        break
      end
    end
  end
  return isHas
end

class.checkStageTagHasHeroTag = checkStageTagHasHeroTag

local function getInformation(self, addition)
  local heroLimit = addition.heroLimit
  local all, front, middle, back, a, STR, AGI, INT
  if self.hero_all_list then
    all, front, middle, back = ed.readhero.classify("real_arena", "position", {limit = heroLimit}, self.hero_all_list)
    a, STR, AGI, INT = ed.readhero.classify("real_arena", "type", {limit = heroLimit}, self.hero_all_list)
  elseif heroLimit and (self.actType or self.mode == "crusade" or self.mode == "arcanaTrial") then
    all, front, middle, back = ed.readhero.classify("exercise", "position", {limit = heroLimit})
    a, STR, AGI, INT = ed.readhero.classify("exercise", "type", {limit = heroLimit})
    local stageRow = ed.getDataTable("Stage")[self.stage]
    if stageRow and stageRow["Stage Group"] == 20005 then
      local unit = ed.getDataTable("Unit")
      
      local function sortHandle(a, b)
        if unit[a._tid].Gender == T("\229\165\179") and unit[b._tid].Gender ~= T("\229\165\179") then
          return true
        elseif unit[a._tid].Gender == T("\229\165\179") and unit[b._tid].Gender == T("\229\165\179") then
          return a._tid < b._tid
        end
        return false
      end
      
      table.sort(all, sortHandle)
      table.sort(front, sortHandle)
      table.sort(middle, sortHandle)
      table.sort(back, sortHandle)
      table.sort(STR, sortHandle)
      table.sort(AGI, sortHandle)
      table.sort(INT, sortHandle)
      self.isValkrie = true
    end
    if stageRow and (stageRow["Stage Group"] == 20007 or stageRow["Stage Group"] == 20007 or stageRow["Stage Group"] == 21007 or stageRow["Stage Group"] == 22007 or stageRow["Stage Group"] == 23007 or stageRow["Stage Group"] == 24007 or stageRow["Stage Group"] == 25007 or stageRow["Stage Group"] == 26007 or stageRow["Stage Group"] == 27007 or stageRow["Stage Group"] == 28007 or stageRow["Stage Group"] == 29007) then
      self.isFrozenDragon = true
    end
  elseif heroLimit and (heroLimit.type == "rank" or heroLimit.type == "HeroIsTitan") then
    all, front, middle, back = ed.readhero.classify("prepare", "position", {limit = heroLimit})
    a, STR, AGI, INT = ed.readhero.classify("prepare", "type", {limit = heroLimit})
  else
    all, front, middle, back = ed.readhero.classify("prepare", "position")
    a, STR, AGI, INT = ed.readhero.classify("prepare", "type")
  end
  if nil ~= self.freeHeroList then
    local tmpArr = {}
    for i, v in ipairs(self.freeHeroList) do
      v._tid = ed.readhero.convertToFreeHeroID(v._tid)
      local hero = ed.HeroCreate()
      hero:setup(v)
      table.insert(tmpArr, hero)
    end
    local allTmp, frontTmp, middleTmp, backTmp = ed.readhero.classify("prepare", "position", nil, tmpArr)
    local aTmp, STRTmp, AGITmp, INTTmp = ed.readhero.classify("prepare", "type", nil, tmpArr)
    for i, v in ipairs(allTmp) do
      table.insert(all, v)
    end
    for i, v in ipairs(frontTmp) do
      table.insert(front, v)
    end
    for i, v in ipairs(middleTmp) do
      table.insert(middle, v)
    end
    for i, v in ipairs(backTmp) do
      table.insert(back, v)
    end
    for i, v in ipairs(aTmp) do
      table.insert(a, v)
    end
    for i, v in ipairs(STRTmp) do
      table.insert(STR, v)
    end
    for i, v in ipairs(AGITmp) do
      table.insert(AGI, v)
    end
    for i, v in ipairs(INTTmp) do
      table.insert(INT, v)
    end
  end
  if self:checkIsCanHeroTags() then
    local tags = self:getStageRequirementTags()
    
    local function tagSortFun(a, b)
      local bool_a = self:checkStageTagHasHeroTag(a._tid, tags)
      local bool_b = self:checkStageTagHasHeroTag(b._tid, tags)
      if bool_a and not bool_b then
        return true
      elseif bool_a == bool_b then
        return a._tid < b._tid
      end
      return false
    end
    
    table.sort(all, tagSortFun)
    table.sort(front, tagSortFun)
    table.sort(middle, tagSortFun)
    table.sort(back, tagSortFun)
    table.sort(STR, tagSortFun)
    table.sort(AGI, tagSortFun)
    table.sort(INT, tagSortFun)
  end
  local first_flag = true
  self.recommend_own_num = 0
  if self.tbc_rush_mode or self.act_recommend_mode then
    self:sortHeroByPvpActivity(all)
    self:sortHeroByPvpActivity(front)
    self:sortHeroByPvpActivity(middle)
    self:sortHeroByPvpActivity(back)
    self:sortHeroByPvpActivity(STR)
    self:sortHeroByPvpActivity(AGI)
    self:sortHeroByPvpActivity(INT)
    
    local function mysort(list, new_list)
      local cache = {}
      local recommend_heros = self.tbc_recommend_heros or {}
      for _, v in pairs(self.act_recommend_heros or {}) do
        table.insert(recommend_heros, v)
      end
      local len = #list
      for index = 1, len do
        if ed.isElementInTable(list[index].data._tid, recommend_heros) then
          new_list[#new_list + 1] = list[index]
          if first_flag then
            self.recommend_own_num = self.recommend_own_num + 1
          end
        else
          cache[#cache + 1] = list[index]
        end
      end
      first_flag = false
      len = #cache
      for index = 1, len do
        new_list[#new_list + 1] = cache[index]
      end
      return new_list
    end
    
    local new_all = {}
    local new_front = {}
    local new_middle = {}
    local new_back = {}
    all = mysort(all, new_all)
    front = mysort(front, new_front)
    middle = mysort(middle, new_middle)
    back = mysort(back, new_back)
    local new_STR = {}
    local new_AGI = {}
    local new_INT = {}
    STR = mysort(STR, new_STR)
    AGI = mysort(AGI, new_AGI)
    INT = mysort(INT, new_INT)
  end
  if self.damageUpHeroesInfo then
    local map = self.damageUpHeroesMap
    
    local function damageUpSort(list)
      local function damageUpSortFunc(e1, e2)
        local v1 = map[e1._tid] or 0
        
        local v2 = map[e2._tid] or 0
        if v1 ~= v2 then
          return v1 > v2
        end
        return true
      end
      
      local len = #list
      for i = 1, len do
        for j = 1, len - i do
          if not damageUpSortFunc(list[j], list[j + 1]) then
            local temp = list[j]
            list[j] = list[j + 1]
            list[j + 1] = temp
          end
        end
      end
    end
    
    damageUpSort(all)
    damageUpSort(front)
    damageUpSort(middle)
    damageUpSort(back)
    damageUpSort(STR)
    damageUpSort(AGI)
    damageUpSort(INT)
  end
  if self.mode == "GuildMountBoss" then
    self:sortHeroByPvpActivity(all)
    self:sortHeroByPvpActivity(front)
    self:sortHeroByPvpActivity(middle)
    self:sortHeroByPvpActivity(back)
  elseif self.mode == "ActivityAdventure" then
    sortHeroByAdventureAddition(self.activityAdventureId, all)
    sortHeroByAdventureAddition(self.activityAdventureId, front)
    sortHeroByAdventureAddition(self.activityAdventureId, middle)
    sortHeroByAdventureAddition(self.activityAdventureId, back)
  elseif self.pvpMode then
    self:sortHeroByPvpActivity(all)
    self:sortHeroByPvpActivity(front)
    self:sortHeroByPvpActivity(middle)
    self:sortHeroByPvpActivity(back)
  elseif not self.tbc_rush_mode and not self.act_recommend_mode then
    self:sortHeroByPvpActivity(all)
    self:sortHeroByPvpActivity(front)
    self:sortHeroByPvpActivity(middle)
    self:sortHeroByPvpActivity(back)
    self:sortHeroByPvpActivity(STR)
    self:sortHeroByPvpActivity(AGI)
    self:sortHeroByPvpActivity(INT)
  end
  local collect = ed.HeroRecommendManager:filtrCollectHero(all)
  self.listData = {
    all = all,
    collect = collect,
    front = front,
    middle = middle,
    back = back,
    str = STR,
    agi = AGI,
    int = INT,
    mercenary = {}
  }
  if self.hireMercenary then
    table.insert(self.listData.mercenary, self.hireMercenary)
    local all, front, middle, back = ed.readhero.classify("prepare", "position", {}, self.listData.mercenary)
    local a, STR, AGI, INT = ed.readhero.classify("prepare", "type", {}, self.listData.mercenary)
    local collect = ed.HeroRecommendManager:filtrCollectHero(all)
    self.mercenarylistData = {
      all = all,
      collect = collect,
      front = front,
      middle = middle,
      back = back,
      str = STR,
      agi = AGI,
      int = INT
    }
  end
  self.clid = {
    "all",
    "all",
    "all",
    "all"
  }
  self.tag = "wholeteam"
  self.team = {}
  self.team_awake_flag = {}
  self.memberIndex = 1
  self.isDestroyTeamMember = {}
end

class.getInformation = getInformation

local function getClid(self)
  if self.tag == "wholeteam" then
    return self.clid[1]
  elseif self.tag == "mercenary" then
    return self.clid[2]
  elseif self.tag == "banhero" then
    return self.clid[3]
  elseif self.tag == "recommend" then
    return self.clid[4] .. "recommend"
  end
end

class.getClid = getClid

local function setClid(self, id)
  if self.tag == "wholeteam" then
    self.clid[1] = id
  elseif self.tag == "mercenary" then
    self.clid[2] = id
  elseif self.tag == "banhero" then
    self.clid[3] = id
  elseif self.tag == "recommend" then
    self.clid[4] = id
  end
end

class.setClid = setClid

function class:getHeroData(hero_id)
  local all = self.listData.all
  for i, hero in ipairs(all) do
    if hero_id == hero._tid then
      return hero
    end
  end
end

function class:recoverHeroData()
  if self.oldHero then
    ed.player.heroes[self.oldHero._tid] = self.oldHero
  elseif self.guardianHeroId then
    ed.player.heroes[self.guardianHeroId] = nil
    self.guardianHeroId = nil
  end
end

function class:isOpenRecommend()
  return false
end

function class:getBanMercenaryModes()
  return {
    "FancyAbyss",
    "FancyTower",
    "assassinate",
    "chaos_tower",
    "arcanaTrial",
    "mythBoss",
    "preset",
    "CampBoss",
    "CampTower",
    "ActivityAdventure",
    "AwakeStage",
    "HadesHeat",
    "GuildClash"
  }
end

function class:canShowMercenary()
  local b = self.pvpMode == nil and ed.player:getGuildId() ~= 0
  if ed.isElementInTable(self.mode, self:getBanMercenaryModes()) then
    b = false
  end
  if self.mode == "tower" and ed.player:getGuildId() ~= 0 then
    b = true
  elseif self.mode == "AwakeStage" and self.objData.type == "Special" then
    b = true
  end
  return b
end

function class:canShowFirework()
  if ed.isElementInTable(self.mode, {"HadesHeat"}) then
    local goodsGroupId = self.objData.goodsGroupId
    if goodsGroupId and 0 < goodsGroupId then
      return true
    end
  end
  return false
end

function class:resetHeroList(heroList, isProto)
  local newHeroList = {}
  for index, hero in ipairs(heroList) do
    local newHero = self:resetHeroData(hero, isProto)
    table.insert(newHeroList, newHero)
  end
  return newHeroList
end

function class:resetHeroData(copyHero, isProto)
  if self.pvpLegendEquipAct then
    local legendEquipId = self.pvpLegendEquipAct.legendEquipId
    if copyHero._legend_equip and copyHero._legend_equip._equip and copyHero._legend_equip._equip._type_id == legendEquipId then
      local hero
      if isProto then
        hero = ed.copyProto(copyHero)
      else
        hero = ed.copyProto(copyHero.data)
      end
      local newHero = ed.HeroCreate()
      newHero:setup(hero)
      newHero._legend_equip = ed.copyProto(copyHero._legend_equip)
      newHero._legend_equip._equip._star = 5
      newHero._legend_equip._equip._rank = 0
      return newHero
    end
  end
  return copyHero
end

local function create(info)
  info = info or {}
  local self = base.create("battlePrepare")
  setmetatable(self, class.mt)
  prepareInfo = info
  bReqMercenary = false
  payPanel = nil
  currentMercenary = nil
  local scene = self.scene
  self.pvpIsFootHold = info.pvpIsFootHold
  self.pvpMode = info.pvpMode
  self.pvpShare = info.pvpShare
  self.defandHeros = info.heros
  self.pvpEnemyId = info.enemyId
  self.stage = info.stage_id
  self.GWMode = info.GWMode
  self.actType = info.actType
  self.heroLimit = info.heroLimit
  self.freeHeroList = info.freeHeroList
  self.presetIndex = info.presetIndex
  self.presetTeam = info.presetTeam
  self.preset_channel = info.preset_channel
  self.presetName = info.presetName
  self.owner = info.owner
  self.enemyHeros = info.enemyHeros
  self.select_count = 0
  self.select_count_limit = math.min(ed.player:getHeroCount(), 5)
  self.hero_all_list = info.hero_all_list
  self.promotelist = info.promotelist
  self.employlist = info.employlist
  self.awakelist = info.awakelist
  self.guildClashMode = info.guildClashMode
  self.tryUseHeroID = info.tryUseHeroID
  self.ban_hero = info.banHero or 0
  self.cantUseHero = info.cantUseHero or {}
  self.titanLimit = info.isTitan or false
  self.trigger1 = info.trigger1
  self.trigger2 = info.trigger2
  self.trigger3 = info.trigger3
  self.tbc_rush_mode = info.tbc_rush_mode
  self.tbc_recommend_heros = info.tbc_recommend_heros
  self.act_recommend_mode = info.act_recommend_mode
  self.act_recommend_heros = info.act_recommend_heros
  self.mode = info.mode
  self.arcanaUseHeroID = info.arcanaUseHeroID
  self.extraMode = info.extraMode
  self.damageUpHeroesInfo = info.damageUpHeroesInfo
  self.damageUpHeroesMap = {}
  for k, v in ipairs(self.damageUpHeroesInfo or {}) do
    self.damageUpHeroesMap[v.heroId] = v.damageRatio
  end
  self.totalSlotNum = nil
  self.availableSlotNum = nil
  self.isIgnoreLengendEquip = false
  self.limitHeroRank = 0
  if self.mode == "AwakeStage" then
    local stageTableItem = ed.getDataTable("DungeonStage")[self.stage]
    self.isIgnoreLengendEquip = stageTableItem["Ignore LegendEquip"]
    self.limitHeroRank = stageTableItem["Rank Limit"] or 0
    if 0 < stageTableItem["Ally Num"] then
      self.totalSlotNum = stageTableItem["Ally Num"]
      self.availableSlotNum = self.totalSlotNum
    else
      local conditionTable = ed.getDataTable("BattleSpecialCondition")
      for i, v in ipairs(stageTableItem["Condition Group"]) do
        local conditionTableItem = conditionTable[v]
        if conditionTableItem["Condition Type"] == "EnterBattleLessThan" then
          self.availableSlotNum = conditionTableItem["Condition Param"][1]
        end
      end
    end
  end
  if nil == self.totalSlotNum then
    self.totalSlotNum = 5
  end
  if nil == self.availableSlotNum then
    self.availableSlotNum = self.totalSlotNum
  end
  self.battleFloorInfo = info.battleFloorInfo
  self.enemyCampId = info.enemyCampId
  self.objData = info.objData or {}
  self.activityAdventureId = info.activityAdventureId or nil
  self.pvpActivityInfo = info.pvpActivityInfo or nil
  self.pvpLegendEquipAct = info.pvpLegendEquipAct or nil
  ed.asyncload.preloadInBattlePrepare(info)
  local bMercenaryVisible = self:canShowMercenary()
  local bFireworkVisible = self:canShowFirework()
  local bPresetVisible = self.pvpMode ~= "localbattle"
  if self.mode == "preset" then
    bMercenaryVisible = false
    bPresetVisible = false
  end
  self.presetVisible = bPresetVisible
  local recommendVisible = self:isOpenRecommend()
  if self.mode == "monsterseal" then
    self.heroLimit = {type = "rank", detail = 12}
  end
  self.hireMercenary = info.hireMercenary
  self:getInformation({
    heroLimit = self.heroLimit
  })
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  scene:addChild(mainLayer)
  self.mainScheduler = self.mainLayer:getScheduler()
  self.ui = {}
  self.listButton = {}
  self.buttonPress = {}
  self.listLabel = {}
  self.tagButton = {}
  self.tagButtonSelect = {}
  self.ui.promtContainer = CCSprite:create()
  self.ui.promtContainer:setCascadeOpacityEnabled(true)
  self.mainLayer:addChild(self.ui.promtContainer, 50)
  if self.mode == "guildInstance" then
    self.prepareTime = info.prepareTime or 60
    prepareTimer = ListenTimer(Timer:Always(1), function()
      self.prepareTime = math.max(0, self.prepareTime - 1)
      self.listTitle:setString(T("\232\175\183\229\156\168%d\231\167\146\229\134\133\229\188\128\229\167\139\230\136\152\230\150\151", self.prepareTime))
      if self.prepareTime <= 0 then
        ed.popScene()
        if prepareTimer then
          CloseTimer(prepareTimer.Name)
          prepareTimer = nil
        end
      end
    end, battlePrepareScope)
  end
  local isSpecialgb = self.pvpMode == "defend" or self.pvpMode == "localbattle" or self.mode == "preset"
  local goButton = isSpecialgb and "UI/alpha/1080P/common/button_a_butt.png" or "UI/alpha/HVGA/prepare_go_battle.png"
  local goPressButton = isSpecialgb and "UI/alpha/HVGA/pvp/pvp_button_confirm_2.png" or "UI/alpha/HVGA/prepare_go_battle_press.png"
  local goDisableButton = "UI/alpha/HVGA/shop_refresh_button_grey.png"
  local textVisible = false
  if isSpecialgb then
    textVisible = true
  end
  local y_start = 415
  local flag_defend = self.pvpMode == "attack" and self.enemyHeros or self.mode == "assassinate" and self.enemyHeros or self.mode == "tower" and self.enemyHeros or self.mode == "chaos_tower" and self.enemyHeros or self.mode == "FancyTower" and self.enemyHeros or self.mode == "FancyAbyss" and self.enemyHeros or "crusade" == self.mode and self.enemyHeros or self.pvpMode == "share_fight" and self.enemyHeros
  local flag_recommend_heros = self.tbc_rush_mode ~= nil and self.tbc_recommend_heros ~= nil
  self.flag_defend = flag_defend or flag_recommend_heros
  local flag_show_ban = self.pvpMode == "attack" and ed.isOpenBanHeroMode and self.ban_hero and 0 < self.ban_hero
  local flag_show_seleteBan = self.pvpMode == "defend" and ed.isOpenBanHeroMode and not self.mode
  if self.tbc_rush_mode then
    self.currentGrade = "gradeD"
  end
  local ui_info = {}
  self.iconScale = 1
  self.uiMonRig = ed.battleprepareUiFun.newWin(self, self.mode or self.pvpMode, self.objData)
  self.tagButton.wholeteam = self.ui.but1_1
  self.ui.label1_1:limitWidthByScale(self.ui.but1_1:getContentSize().width * 0.7)
  self.tagButtonSelect.wholeteam = self.ui.but1_2
  self.ui.label1_2:limitWidthByScale(self.ui.but1_2:getContentSize().width * 0.7)
  self.tagButton.mercenary = self.ui.but2_1
  self.ui.label2_1:limitWidthByScale(self.ui.but2_1:getContentSize().width * 0.7)
  self.tagButtonSelect.mercenary = self.ui.but2_2
  self.ui.label2_2:limitWidthByScale(self.ui.but2_2:getContentSize().width * 0.7)
  self.tagButton.recommend = self.ui.but3_1
  self.ui.label3_1:limitWidthByScale(self.ui.but3_1:getContentSize().width * 0.7)
  self.tagButtonSelect.recommend = self.ui.but3_2
  self.ui.label3_2:limitWidthByScale(self.ui.but3_2:getContentSize().width * 0.7)
  self.tagButton.firework = self.ui.but4_1
  self.ui.label4_1:limitWidthByScale(self.ui.but4_1:getContentSize().width * 0.7)
  self.tagButtonSelect.firework = self.ui.but4_2
  self.ui.label4_2:limitWidthByScale(self.ui.but4_2:getContentSize().width * 0.7)
  for i = 1, self.totalSlotNum do
    local isLock = i > self.availableSlotNum
    self.ui["member_lock_" .. self.totalSlotNum - i + 1]:setVisible(isLock)
  end
  self.tagButton.mercenary:setVisible(bMercenaryVisible)
  self.tagButton.recommend:setVisible(recommendVisible)
  self.tagButton.firework:setVisible(bFireworkVisible)
  self.tagButtonSelect.mercenary:setVisible(false)
  self.tagButtonSelect.recommend:setVisible(false)
  self.tagButtonSelect.firework:setVisible(false)
  self.ui.go:setVisible(not flag_show_seleteBan)
  self.ui.go_next:setVisible(flag_show_seleteBan)
  self.ui.conform:setString(not (not textVisible or flag_show_seleteBan) and T("\231\161\174\229\174\154") or T("\230\136\152\230\150\151"))
  if self.mode == "GuildClash" then
    self.ui.conform:setString(T("\231\161\174\229\174\154"))
  end
  ed.setLabelShadow(self.ui.conform, ed.toccc3(0), ccp(1, 0))
  self.tagButtonPosition = {}
  self.tagButtonSelectPosition = {}
  self.tagButtonPosition[1] = self.tagButton.wholeteam
  self.tagButtonPosition[2] = self.tagButton.mercenary
  self.tagButtonPosition[3] = self.tagButton.recommend
  self.tagButtonPosition[4] = self.tagButton.firework
  self.tagButtonSelectPosition[1] = self.tagButtonSelect.wholeteam
  self.tagButtonSelectPosition[2] = self.tagButtonSelect.mercenary
  self.tagButtonSelectPosition[3] = self.tagButtonSelect.recommend
  self.tagButtonSelectPosition[4] = self.tagButtonSelect.firework
  self.ui.image_total_add_bg:setVisible(self.activityAdventureId ~= nil)
  self:refreshAddition()
  local backgroundPath = "UI/alpha/1080P/bg/dreamland_bj.jpg"
  if self.mode == "GuildMountBoss" then
    backgroundPath = "UI/alpha/1080P/battle_bg/bbg_guildmount.jpg"
  end
  self:setBackground(backgroundPath)
  self:createFrame()
  if resource_config.battleprepare_not_hire_icon then
    self.ui.mercenaryTag:setVisible(false)
  end
  self:createListLayer()
  self:registerUpdateHandler("asyncCreateList", self:asyncCreateList())
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  mainLayer:setTouchEnabled(false)
  self.ui.butt_off:setScale(0.8)
  self:listenTimer(Timer:Once(0.3), function()
    mainLayer:setTouchEnabled(true)
  end)
  if self:checkIsBanSeleteMode() then
    self.banTeam = {
      {
        pos = self:getTeamMemberPos(1)
      },
      {
        pos = self:getTeamMemberPos(2)
      },
      {
        pos = self:getTeamMemberPos(3)
      },
      {
        pos = self:getTeamMemberPos(4)
      },
      {
        pos = self:getTeamMemberPos(5)
      }
    }
    for i = 2, #self.banTeam do
      local info = self.banTeam[i]
      local lock_icon = CCSprite:create("UI/alpha/HVGA/activity/returnplayer_choosehero_locked.jpg")
      lock_icon:setPosition(info.pos)
      lock_icon:setScale(self.iconScale - 0.05)
      lock_icon:setVisible(false)
      self.mainLayer:addChild(lock_icon, 30)
      info.icon = lock_icon
    end
  end
  self:registerOnExitHandler("exit", self:onExitHandler())
  self:registerOnPopSceneHandler("onPop", function()
    CloseScope(battlePrepareScope)
    if prepareTimer then
      CloseTimer(prepareTimer.Name)
      prepareTimer = nil
    end
    battlePrepareScope = {}
    self:recoverHeroData()
  end)
  ListenEvent("HireMercenarySuccess", function()
    requestBattle(self)
  end, battlePrepareScope)
  ListenEvent("MercenaryAlready", function(data)
    refreshMercenaryList(self, data)
  end, battlePrepareScope)
  ListenEvent("refresh_stage_recommend_reply", function()
    self:doInitRecommendData()
  end, battlePrepareScope)
  if self.mode == "crusade" then
    ListenEvent("refreshHeroHpMp", function()
      self:refreshHeroHpMp()
    end, battlePrepareScope)
  end
  local type = 0
  if flag_defend then
    type = 1
  elseif flag_recommend_heros then
    type = 2
  end
  self:initTopHerosIcon(type)
  self:refreshTagButtonPosition()
  if self.pvpMode == "attack" or self.pvpMode == "share_fight" and ed.isOpenBanHeroMode and 0 < self.ban_hero then
    self:initTopBanHerosIcon()
  end
  self:registerOnEnterHandler("enter_battle_prepare", function()
    if self.mode == "AwakeStage" and ed.awakeDungeonMgr.getInstance():getParagonLevel() <= 1 then
      ed.showStory("DungeonGuide")
    end
  end)
  if self.mode == "preset" then
    self.ui.preset:setVisible(false)
    self.ui.preset_back:setVisible(false)
    self.ui.layUp_ButOrBg:setVisible(true)
  end
  if bFireworkVisible then
    self.uiMonRig:addFireworkLayer()
  end
  self:preloadBattleBgMusic()
  self:initLegendEquip()
  self:addBtnClick()
  return self
end

class.create = create

function class:addBtnClick()
  self:btRegisterButtonClick({
    button = self.ui.switch_equip_bg,
    key = "switch_equip_bg",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      ed.off_legendEquipOp = not ed.off_legendEquipOp
      ed.saveLegendEquip()
      self:switchLegendEquipMenu(ed.off_legendEquipOp)
      FireEvent("legendEquip_refresh")
    end
  })
end

function class:preloadBattleBgMusic()
  local music
  if self.mode == "crusade" then
    music = ed.music["chapter-3"]
  else
    local stage_id = self.stage or 1
    if self.pvpMode == "attack" or self.mode == "assassinate" then
      stage_id = pvp_stage
    end
    local stage_info = ed.lookupDataTable("Stage", nil, stage_id)
    local chapter = stage_info and stage_info["Chapter ID"] or 1
    music = ed.music["chapter" .. chapter]
  end
  music = music or "sound_menu/battle_bgm.mp3"
  ed.afterFrames(6, function()
    ed.preLoadMusic(music)
  end)
end

function class:createFrame()
  self:createTabButtonList()
end

function class:createTabButtonList()
  self:createButtonDraglist()
  local keyTxt = {
    {
      "all",
      T("\229\133\168\233\131\168")
    },
    {
      "front",
      T("\229\137\141\230\142\146")
    },
    {
      "middle",
      T("\228\184\173\230\142\146")
    },
    {
      "back",
      T("\229\144\142\230\142\146")
    }
  }
  local resConfig = {}
  if self.mode == "FancyTower" then
    keyTxt = {
      {
        "all",
        T("\229\133\168\233\131\168")
      },
      {
        "str",
        T("\229\138\155\233\135\143")
      },
      {
        "int",
        T("\230\153\186\229\138\155")
      },
      {
        "agi",
        T("\230\149\143\230\141\183")
      }
    }
  end
  for i, v in ipairs(keyTxt) do
    resConfig[i] = {}
    resConfig[i].key = v[1]
    resConfig[i].text = v[2]
    resConfig[i].button = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png"
    resConfig[i].press = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png"
  end
  local posX, posY = self.ui.butts_list:getPosition()
  local con = self.ui.butts_list:getContentSize()
  local posX = posX + 31
  local buttonIndex, widths = 0, 70
  for _, res in pairs(resConfig) do
    local key = res.key
    if self:openMode(key) then
      buttonIndex = buttonIndex + 1
      local button = ed.createSprite(res.button)
      local press = ed.createSprite(res.press)
      local label = ed.createLabelTTF(res.text, 18)
      ed.setLabelFontInfo(label, "dark_white_stroke")
      label:limitWidthByScale(40)
      button:setPosition(ccp(posX + (buttonIndex - 1) * widths + 20, con.height - 5))
      press:setPosition(ccp(posX + (buttonIndex - 1) * widths + 20, con.height - 5))
      label:setPosition(ccp(posX + (buttonIndex - 1) * widths + 20, con.height - 5))
      self.buttonDraglist.listLayer:addChild(button)
      self.buttonDraglist.listLayer:addChild(press)
      self.buttonDraglist.listLayer:addChild(label)
      press:setVisible(false)
      self.listButton[key] = button
      self.buttonPress[key] = press
      self.listLabel[key] = label
    end
  end
  self.buttonDraglist:initListWidth(buttonIndex * widths)
  self:initCurrentTabButton()
end

function class:initCurrentTabButton()
  self.listButton.all:setVisible(false)
  self.buttonPress.all:setVisible(true)
end

function class:openMode(key)
  if key == "collect" then
    return ed.herorecommend.manager:isOpen()
  end
  return true
end

function class:createButtonDraglist()
  local posX, posY = self.ui.butts_list:getPosition()
  local con = self.ui.butts_list:getContentSize()
  local info = {
    cliprect = CCRectMake(posX, posY, con.width, con.height),
    container = self.ui.layUp_ButOrBg,
    zorder = 10,
    noshade = true,
    doPressIn = self:doButtonListPress(),
    cancelPressIn = self:doButtonListCancelPressIn()
  }
  self.buttonDraglist = ed.draglist.create(info)
end

function class:doButtonListPress()
  local function handler(x, y)
    for k, v in pairs(self.listButton) do
      if v:isVisible() and ed.containsPoint(v, x, y) and self.ui.layUp_ButOrBg:isVisible() then
        v:setVisible(false)
        
        self.buttonPress[k]:setVisible(true)
        return k
      end
    end
  end
  
  return handler
end

function class:doButtonListCancelPressIn()
  local function handler(x, y, k)
    xpcall(function()
      local v = self.listButton[k]
      
      if ed.containsPoint(v, x, y) then
        self:doChangeList(k)
      else
        v:setVisible(true)
        self.buttonPress[k]:setVisible(false)
      end
    end, EDDebug)
  end
  
  return handler
end

local function getTopHeros(self, type)
  local topHeros
  if type == 1 then
    topHeros = ed.SortHeroesByMaxRange(self.enemyHeros)
  elseif type == 2 then
    topHeros = self.tbc_recommend_heros
  end
  return topHeros
end

local function initTopHerosIcon(self, type)
  if type == 0 then
    return
  end
  local length = 52
  local dx, dy = 4.3, 3.8
  local topHeros = getTopHeros(self, type)
  if not topHeros then
    return
  end
  self.topHeros = topHeros
  local icons = {}
  local topTeam = {}
  for j, hero in ipairs(topHeros) do
    local hero_icon
    if type == 1 then
      hero_icon = ed.readhero.createIcon({
        id = hero._tid,
        rank = hero._rank,
        level = hero._level,
        stars = hero._stars,
        fashion_id = hero._fashion,
        length = length,
        summary = hero,
        shard = hero._shard,
        legendEquip = hero._legend_equip and hero._legend_equip._equip
      })
    elseif type == 2 then
      hero_icon = ed.readhero.createIcon({id = hero, length = length})
    end
    if not hero_icon then
      break
    end
    local icon_node = hero_icon.icon
    icon_node:setAnchorPoint(ccp(0, 0))
    local x, y = icon_node:getPosition()
    icon_node:setPosition(ccp(x + dx, y + dy))
    icon_node:setScale(0.7)
    icons[j] = icon_node
    topTeam[j] = hero_icon
    self.ui["oppo_member_bg_" .. j]:addChild(icon_node)
  end
  self.teamNewIdenxTabs = {
    [1] = icons
  }
  self.teamHeroTabs = {
    [1] = topTeam
  }
end

class.initTopHerosIcon = initTopHerosIcon

local function getEnemyHeadBattleprepare(self, stage)
  local step = 1
  local ids = {}
  local stageCsvName = "Stage"
  local battleCsvName = "Battle"
  if self.mode == "ActivityAdventure" then
    stageCsvName = "ActivityAdventureStage"
    battleCsvName = "ActivityAdventureBattle"
  elseif self.mode == "FancyAbyss" then
    stageCsvName = "FancyAbyssStage"
    battleCsvName = "FancyAbyssBattle"
  elseif self.mode == "AwakeStage" then
    stageCsvName = "DungeonStage"
    battleCsvName = "DungeonBattle"
  elseif self.mode == "HadesHeat" then
    stageCsvName = "HeatStage"
    battleCsvName = "HeatBattle"
  end
  print("getEnemyHeadBattleprepare", stageCsvName, battleCsvName)
  
  local function retThisTeamTab(unit, ids, step)
    local info = {}
    for i = 1, #ids do
      if ids[i] ~= 0 then
        local id = ids[i]
        local hero = {
          id = id,
          res = ed.getUnitPortrait(ids[i]),
          level = ed.getDataTable(battleCsvName)[stage][step]["Level " .. i],
          stars = ed.getDataTable(battleCsvName)[stage][step]["Stars " .. i],
          rank = ed.getDataTable(battleCsvName)[stage][step]["Rank " .. i],
          index = i
        }
        if ed.isElementInTable(self.mode, {
          "HadesHeat",
          "ActivityAdventure"
        }) then
          local difficultyRatio = self.objData.difficultyRatio or 0
          local minLevel = ed.getDataTable(battleCsvName)[stage][step]["MinLevel " .. i]
          local maxLevel = ed.getDataTable(battleCsvName)[stage][step]["MaxLevel " .. i]
          hero.level = math.floor(difficultyRatio * (maxLevel - minLevel) + minLevel)
        end
        if self.mode == "HadesHeat" then
          local battleCfg = ed.getDataTable(battleCsvName)[stage][step]
          local bossPosition = battleCfg["Boss Position"]
          local bossId = battleCfg[string.format("Monster %s ID", bossPosition)]
          if id == bossId then
            hero.level = hero.level + self:getHadesHeatBossAddLevel()
          end
        end
        local shardLevel = ed.getDataTable(battleCsvName)[stage][step]["Shard Level " .. i]
        local shardId = ed.getDataTable(battleCsvName)[stage][step]["Shard ID " .. i]
        if shardLevel and 0 < shardLevel then
          hero.shard = {_id = shardId, _level = shardLevel}
        end
        table.insert(info, hero)
      end
    end
    return info
  end
  
  local teamTabs = {}
  for s = 1, 5 do
    local brow = ed.getDataTable(battleCsvName)[stage][s]
    if brow then
      teamTabs[s] = {}
      for i = 1, 10 do
        local id = brow[string.format("Monster %d ID", i)]
        if not id or 0 == id then
          break
        end
        teamTabs[s][i] = id
      end
    end
  end
  local unit = ed.getDataTable("Unit")
  local newTeamTabs = {}
  for i = 1, #teamTabs do
    newTeamTabs[i] = retThisTeamTab(unit, teamTabs[i], i)
  end
  if self.mode == "AwakeStage" then
    local stageTableItem = ed.getDataTable("DungeonStage")[stage]
    if stageTableItem["Stage Category"] == "Special" then
      local result = {}
      for _, arr in ipairs(newTeamTabs) do
        ed.readhero.sortIDByRange(arr, function(item)
          return item.id
        end)
        for _, v in ipairs(arr) do
          table.insert(result, v)
        end
      end
      newTeamTabs = {
        [1] = result
      }
    end
  end
  return newTeamTabs
end

class.getEnemyHeadBattleprepare = getEnemyHeadBattleprepare

local function initTopHerosIconTeam(self, type)
  if self.objData then
    self.objData.headData = self:getEnemyHeadBattleprepare(self.stage)
    if self.objData.headData == nil then
      return
    end
    if type == 0 then
      return
    elseif type == "battGuild" then
      local wave = self.objData.wave or 1
      self.objData.headData = {
        self.objData.headData[wave]
      }
    end
    self.teamNewIdenx = self.teamNewIdenx or #self.objData.headData
    self.teamNewIdenxTabs = self.teamNewIdenxTabs or {}
    self.teamHeroTabs = self.teamHeroTabs or {}
    self.objData.heroHp = self.objData.heroHp or {}
    for i, v in ipairs(self.objData.headData) do
      self.teamNewIdenxTabs[i] = {}
      self.teamHeroTabs[i] = {}
      local length = 52
      local dx, dy = 4.3, 3.8
      for j, hero in ipairs(v) do
        if not hero.id then
          break
        end
        local hero_icon
        local enemyLevel = hero.level
        local rank = ed.heroLevel2Rank(enemyLevel)
        if hero.rank and 0 < hero.rank then
          rank = hero.rank
        end
        hero_icon = ed.readhero.createIcon({
          id = hero.id,
          rank = rank,
          stars = hero.stars,
          level = enemyLevel,
          shard = hero.shard
        })
        if not hero_icon then
          break
        end
        local icon_node = hero_icon.icon
        icon_node:setAnchorPoint(ccp(0, 0))
        local x, y = icon_node:getPosition()
        icon_node:setPosition(ccp(x + dx - 1, y + dy - 1))
        icon_node:setScale(0.7)
        local oppoBg = self.ui["oppo_member_bg_" .. j]
        if nil == oppoBg then
          oppoBg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head.png")
          self.ui["oppo_member_bg_" .. j] = oppoBg
          local lastOppoBg1 = self.ui["oppo_member_bg_" .. j - 1]
          local lastOppoBg2 = self.ui["oppo_member_bg_" .. j - 2]
          lastOppoBg1:getParent():addChild(oppoBg)
          oppoBg:setPosition(lastOppoBg1:getPositionX() * 2 - lastOppoBg2:getPositionX(), lastOppoBg1:getPositionY())
        end
        oppoBg:setVisible(true)
        oppoBg:addChild(icon_node)
        icon_node:setVisible(i == self.teamNewIdenx)
        self.teamNewIdenxTabs[i][j] = icon_node
        self.teamHeroTabs[i][j] = hero_icon
        if self.objData.heroHp[hero.id] then
          hero_icon:addMonsterHpInfo(self.objData.heroHp[hero.id])
        end
      end
    end
    if type == "battGuild" then
      local wave = self.objData.wave or 1
      self.ui.enemyTeamTit:setString(string.format(T("\232\191\155\229\186\166:%s/%s"), wave, 3))
      self.ui.battlePrepare_fx_R:setVisible(false)
      self.ui.battlePrepare_fx_R_1:setVisible(false)
    else
      self:refreshTopHerosIconPanel()
    end
  end
  ed.adaptLabel(self.ui.enemyTeamTit, {maxWidth = 65, minScale = 0.6})
  ed.adaptLabel(self.ui.enemyLabel, {maxWidth = 25, minScale = 0.3})
end

class.initTopHerosIconTeam = initTopHerosIconTeam

local function topHerosIconTeamNewIdenx(self, teamNewIdenx)
  local oldArr = self.teamNewIdenxTabs[self.teamNewIdenx]
  if nil ~= oldArr then
    for i, v in ipairs(oldArr) do
      v:setVisible(false)
    end
  end
  self.teamNewIdenx = teamNewIdenx or self.teamNewIdenx or 1
  self.teamNewIdenx = ed.clamp(self.teamNewIdenx, 1, #self.teamNewIdenxTabs)
  local newArr = self.teamNewIdenxTabs[self.teamNewIdenx]
  if nil ~= newArr then
    for i, v in ipairs(newArr) do
      v:setVisible(true)
    end
  end
  if nil ~= newArr then
    local visibleBgNum = math.max(5, #newArr)
    for i = 1, 999 do
      local oppoBg = self.ui["oppo_member_bg_" .. i]
      if nil == oppoBg then
        break
      end
      oppoBg:setVisible(i <= visibleBgNum)
    end
  end
  self:refreshTopHerosIconPanel()
end

class.topHerosIconTeamNewIdenx = topHerosIconTeamNewIdenx

local function refreshTopHerosIconPanel(self)
  if nil == self.oppoDraglist then
    for _, uiArr in ipairs(self.teamNewIdenxTabs) do
      if 5 < #uiArr then
        local containerSize = self.ui.eneTeamItem:getContentSize()
        containerSize.width = containerSize.width - 20
        self.ui.eneTeamItem:setContentSize(containerSize)
        self.ui.battlePrepare_fx_R:setPositionX(containerSize.width + math.abs(self.ui.battlePrepare_fx_L:getPositionX()))
        self.oppoDraglist = ed.UITool.createDraglist(self.ui.eneTeamItem)
        for i = 1, 999 do
          local oppoBg = self.ui["oppo_member_bg_" .. i]
          if nil == oppoBg then
            break
          end
          oppoBg:removeFromParentAndCleanup(false)
          self.oppoDraglist:addItem(oppoBg)
        end
        break
      end
    end
  end
  if nil ~= self.oppoDraglist then
    local uiArr = self.teamNewIdenxTabs[self.teamNewIdenx]
    local firstBg = self.ui.oppo_member_bg_1
    local lastBg = self.ui["oppo_member_bg_" .. #uiArr]
    local bgSize = firstBg:getContentSize()
    local totalWidth = lastBg:getPositionX() - firstBg:getPositionX() + (firstBg:getPositionX() - bgSize.width * 0.5) * 2 + bgSize.width
    self.oppoDraglist:initListWidth(totalWidth)
  end
  if self.mode == "AwakeStage" then
    local stageTableItem = ed.getDataTable("DungeonStage")[self.stage]
    if stageTableItem["Stage Category"] == "Special" then
      self.ui.enemyTeamTit:setString(T("\230\149\140\230\150\185\228\191\161\230\129\175"))
    else
      self.ui.enemyTeamTit:setString(string.format(T("\233\152\181\229\174\185%s/%s"), self.teamNewIdenx, #self.teamNewIdenxTabs))
    end
  else
    self.ui.enemyTeamTit:setString(string.format(T("\233\152\181\229\174\185%s/%s"), self.teamNewIdenx, #self.teamNewIdenxTabs))
  end
  if #self.teamNewIdenxTabs > 1 then
    self.ui.battlePrepare_fx_L_1:setVisible(1 < self.teamNewIdenx)
    self.ui.battlePrepare_fx_R_1:setVisible(self.teamNewIdenx < #self.teamNewIdenxTabs)
    self.ui.battlePrepare_fx_L:setVisible(true)
    self.ui.battlePrepare_fx_R:setVisible(true)
  end
end

class.refreshTopHerosIconPanel = refreshTopHerosIconPanel

local function getHadesHeatBossAddLevel(self)
  local addLevel = 0
  for index, heatData in ipairs(self.objData.chooseHeat or {}) do
    local heatCfg = ed.getDataTable("Heat")[heatData._heat_id]
    if heatCfg.Type == "Level" then
      addLevel = addLevel + heatCfg.ScriptArg1 * heatData._times
    end
  end
  return addLevel
end

class.getHadesHeatBossAddLevel = getHadesHeatBossAddLevel

local function initTopBanHerosIcon(self)
end

class.initTopBanHerosIcon = initTopBanHerosIcon

local function onExitHandler(self)
  local function handler()
    lsr:report("exitScene")
  end
  
  return handler
end

class.onExitHandler = onExitHandler

function class:refreshTagButtonPosition()
  local index = 1
  for k, v in ipairs(self.tagButton) do
    if self.tagButton[k]:isVisible() then
      self.tagButton[k]:setPosition(self.tagButtonPosition[index]:getPosition())
      self.tagButtonSelect[k]:setPosition(self.tagButtonSelectPosition[index]:getPosition())
      index = index + 1
    end
  end
end

function class:getHeroReliveItemNum()
  return ed.player:getEquipAmount(2548)
end

function class:refreshHeroHpMp()
  if self.mode ~= "crusade" then
    return
  end
  local data = {}
  data._hp_perc = 10000
  data._mp_perc = 10000
  self.reliveHero:setCrusade(data)
  self.reliveHeroIcon:refreshHpMpInfo(data._hp_perc, data._mp_perc)
  ed.setString(self.ui.relive_item_num, "\195\151" .. self:getHeroReliveItemNum())
  if self:getHeroReliveItemNum() <= 0 then
    for tid, info in pairs(self.dieHeroIcon) do
      local hero = info.hero
      info.icon:refreshHpMpInfo(hero:hp_perc(pms[self.mode]), hero:mp_perc(pms[self.mode]))
    end
  end
  ed.showToast(T("%s\229\183\178\231\187\143\229\133\131\230\176\148\230\187\161\230\187\161\239\188\140\229\135\134\229\164\135\232\191\142\230\142\165\230\150\176\231\154\132\230\136\152\230\150\151\239\188\129", self.reliveHero:getDisplayName()))
end

function class:showDetailCard(id, node)
  self:closeDetailCard()
  local detailCardPanel = ed.readequip.getDetailCard(id)
  local pos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
  detailCardPanel:setPosition(ccp(pos.x - 25, pos.y - 150))
  detailCardPanel:setAnchorPoint(ccp(0.5, 0))
  self.draglist.listLayer:addChild(detailCardPanel)
  self.detailCardPanel = detailCardPanel
end

function class:closeDetailCard()
  if self.detailCardPanel then
    self.detailCardPanel:removeFromParentAndCleanup(true)
    self.detailCardPanel = nil
  end
end

function class:getListContainerIdex()
  if #self.team >= self.totalSlotNum then
    return
  end
  local list = self.listData[self:getClid()] or {}
  for i = 1, #list do
    local hero = self.listData[self:getClid()][i]
    if self:checkCondition(hero, self:getClid(), self.tag, i) and not self.heroIcon[hero.data._tid].isSelected then
      return self.heroIcon[self.listData[self:getClid()][i]._tid].icon
    end
  end
  return
end

function class:getGuideNode(nodeKey)
  if nodeKey == "select_hero" then
    return self:getListContainerIdex()
  elseif nodeKey == "go" and #self.team == 0 then
    return
  end
  return base.getGuideNode(self, nodeKey)
end

function class:initLegendEquip()
  if not ed.openLegendEquip() or self.isIgnoreLengendEquip then
    self.ui.switch_equip_bg:setVisible(false)
  end
  local constAdaptScale = 1.8
  local currentScale = ed.display.winSize.width / ed.display.winSize.height
  if constAdaptScale >= currentScale then
    self.ui.switch_equip_bg:setScale(0.85)
    self.ui.switch_equip_bg:setPositionX(62)
  else
    self.ui.switch_equip_bg:setPositionX(75)
  end
  self.ui.close_equip_bg:setVisible(not ed.off_legendEquipOp)
  self.ui.label_equip:setVisible(not ed.off_legendEquipOp)
  self.ui.btn_equip:setPositionX(ed.off_legendEquipOp and 17 or 59)
  self.ui.label_equip_enable:setVisible(ed.off_legendEquipOp)
  if not ed.off_legendEquipOp then
    self.ui.label_equip:setPositionX(17)
    self.ui.btn_equip:setPositionX(59)
  end
  ed.setString(self.ui.label_equip_enable, "\228\184\141\229\177\149\231\164\186")
  ed.setLabelColor(self.ui.label_equip_des, ed.toccc3(16771194))
  ed.setLabelStroke(self.ui.label_equip_des, ed.toccc3(1973790), 1.5)
  ed.setLabelColor(self.ui.label_equip, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip, ed.toccc3(65793), 1.5)
  ed.setLabelColor(self.ui.label_equip_enable, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip_enable, ed.toccc3(65793), 1.5)
end

function class:switchLegendEquipMenu(open)
  self.ui.close_equip_bg:setVisible(not open)
  self.ui.label_equip:setVisible(not open)
  self.ui.label_equip_enable:setVisible(open)
  self.ui.btn_equip:setPositionX(open and 17 or 59)
  self:refreshLegendEquip()
end

function class:refreshLegendEquip()
  if nil ~= self.team then
    for index = 1, #self.team do
      local hero = self.team[index].icon
      if hero then
        hero:showLegendEquip(ed.off_legendEquipOp or self.isIgnoreLengendEquip)
      end
    end
  end
  if nil ~= self.heroIcon then
    for key, value in pairs(self.heroIcon) do
      if nil ~= value and nil ~= value.icon then
        value:showLegendEquip(ed.off_legendEquipOp or self.isIgnoreLengendEquip)
      end
    end
  end
  if nil ~= self.mercenaryIconAll then
    for key, value in pairs(self.mercenaryIconAll) do
      if nil ~= value and nil ~= value.icon then
        value:showLegendEquip(ed.off_legendEquipOp or self.isIgnoreLengendEquip)
      end
    end
  end
  if nil ~= self.teamHeroTabs then
    for i, v in ipairs(self.teamHeroTabs) do
      for s, n in ipairs(v) do
        n:showLegendEquip(ed.off_legendEquipOp or self.isIgnoreLengendEquip)
      end
    end
  end
end
