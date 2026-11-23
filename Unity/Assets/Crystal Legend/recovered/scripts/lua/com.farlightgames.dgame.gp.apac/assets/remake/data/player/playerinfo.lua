module("ed", package.seeall)
local ed = ed

function Player:addTask(chain, id, target, itemStage)
  local ts = self._tasks
  for k, v in pairs(self._tasks or {}) do
    if v._line == chain then
      table.remove(self._tasks, k)
    end
  end
  local task = ed.downmsg.usertask()
  task._line = chain
  task._id = id
  task._status = "working"
  if target then
    task._task_target = target
  else
    task._task_target = 0
  end
  task._item_stage = itemStage
  if not self._tasks then
    self._tasks = {}
  end
  table.insert(self._tasks, task)
end

function Player:delTask(taskLine, taskID)
  if self._tasks == nil then
    return
  end
  for k, task in pairs(self._tasks) do
    if task._line == taskLine and task._id == taskID then
      table.remove(self._tasks, k)
    end
  end
end

function Player:getTaskList()
  return self._tasks or {}
end

function Player:getFinishedTask()
  return self._task_finished or {}
end

function Player:getTaskCount(line, id)
  for _, v in pairs(self._tasks or {}) do
    if v._line == line and v._id == id then
      return v._task_target
    end
  end
  return 0
end

function Player:isHeroTask(chain)
  if chain and ed.getDataTable("HeroTask")[chain] then
    return true
  else
    return false
  end
end

function Player:isHeroHaveSuperAwakeTask(heroId)
  local taskTable = ed.getDataTable("HeroTask")
  for chainId, task in pairs(taskTable) do
    if chainId ~= "name" and task[1]["Is Artifact"] and task[1]["Hero ID"] == heroId then
      return true
    end
  end
  return false
end

function Player:isHeroTaskChainFinished(task)
  if not task then
    return false
  end
  if not self:isHeroTask(task._line) then
    return false
  end
  local heroTaskTable = ed.getDataTable("HeroTask")
  if task._status == "finished" and heroTaskTable[task._line][task._id + 1] == nil then
    return true
  end
  return false
end

function Player:getHeroTask(status, hid)
  local tl = self._tasks
  if not tl then
    return
  end
  local heroTaskTable = ed.getDataTable("HeroTask")
  local heroidRestrict
  if not hid then
    heroidRestrict = true
  end
  local heroTaskTemp = {}
  for k, v in pairs(tl) do
    if not ed.getDataTable("Task")[v._line] or ed.getDataTable("Task")[v._line] and ed.getDataTable("Task")[v._line][1]["Task Type"] ~= "invite" then
      if hid ~= nil and self:isHeroTask(v._line) then
        heroidRestrict = hid == heroTaskTable[v._line][v._id]["Hero ID"]
      end
      if self:isHeroTask(v._line) and heroidRestrict then
        if status == nil then
          if not self:isHeroTaskChainFinished(v) then
            table.insert(heroTaskTemp, tl[k])
          end
        elseif v._status == status then
          table.insert(heroTaskTemp, tl[k])
        end
      end
    end
  end
  if next(heroTaskTable) == nil then
    return nil
  end
  return heroTaskTemp
end

function Player:withHeroTask(status, hid)
  local task = self:getHeroTask(status, hid)
  if task == nil then
    return nil
  end
  local heroTaskTable = ed.getDataTable("HeroTask")
  for k, v in ipairs(task) do
    if heroTaskTable[v._line][1]["Is Artifact"] == false then
      return v
    end
  end
  return nil
end

function Player:withHeroSuperTask(status, hid)
  local task = self:getHeroTask(status, hid)
  if task == nil then
    return nil
  end
  local heroTaskTable = ed.getDataTable("HeroTask")
  for k, v in ipairs(task) do
    if heroTaskTable[v._line][1]["Is Artifact"] == true then
      return v
    end
  end
  return nil
end

function Player:insertHeroTaskSweepStage(stageid)
  local heroTask = self:withHeroTask("working")
  if not heroTask then
    return
  end
  heroTask._sweepStages = heroTask._sweepStages or {}
  for k, sid in pairs(heroTask._sweepStages) do
    if sid == stageid then
      return
    end
  end
  table.insert(heroTask._sweepStages, stageid)
end

function Player:insertSuperHeroTaskSweepStage(stageid)
  local heroTask = self:withHeroSuperTask("working")
  if not heroTask then
    return
  end
  heroTask._sweepStages = heroTask._sweepStages or {}
  for k, sid in pairs(heroTask._sweepStages) do
    if sid == stageid then
      return
    end
  end
  table.insert(heroTask._sweepStages, stageid)
end

function Player.heroTaskEquipItemBringed(hid)
  local herotask = ed.player:withHeroTask("working", hid)
  local herosupertask = ed.player:withHeroSuperTask("working", hid)
  herotask = herotask or herosupertask
  if herotask then
    local heroTaskTable = ed.getDataTable("HeroTask")
    local eid = heroTaskTable[herotask._line][herotask._id]
    if herotask._id == 1 and eid["Item ID"] > 0 then
      return eid["Item ID"]
    else
      return nil
    end
  else
    return nil
  end
end

function Player:isHeroAwakeEquipId(heroId, equipId)
  return ed.getHeroTaskCsvEquipid(heroId) == equipId
end

function Player:isHeroSuperAwakeEquipId(heroId, equipId)
  return ed.getDataTable("HeroTask"):getHeroSuperTaskCsvEquipid(heroId) == equipId
end

function ed.heroTaskResultCheck(chain, id)
  local limitHero = false
  local row
  local ht = ed.getDataTable("HeroTask")
  row = ht[chain][id]
  local heroid = row["Hero ID"]
  local team = ed.engine:getSelfHeroIdList()
  if "FarmStageWith" == row["Task Progress Type"] then
    limitHero = ed.isElementInTable(heroid, team)
  elseif "FarmStageAlone" == row["Task Progress Type"] then
    limitHero = ed.isElementInTable(heroid, team) and #team == 1
  elseif "FarmStageNoDie" == row["Task Progress Type"] then
    limitHero = ed.isElementInTable(heroid, team) and ed.engine.death_count == 0
  elseif "FarmStageDamage" == row["Task Progress Type"] then
    limitHero = ed.isElementInTable(heroid, team) and ed.engine:getSpecificHeroDamage() >= row.Limit
  elseif "FarmStageKill" == row["Task Progress Type"] then
    local monsterIdentify = "Monster " .. tostring(row["Monster ID"]) .. " ID"
    local stageInfo = ed.engine.stage_info
    local targetKilled = false
    if stageInfo then
      local stageId = (stageInfo or {})["Stage ID"]
      if stageId and ed.getDataTable("Battle")[stageId][3] then
        local monsterId = ed.getDataTable("Battle")[stageId][3][monsterIdentify]
        local killlist = ed.engine:getScecificHeroKillList()
        for i = 1, #killlist do
          if killlist[i] == monsterId then
            targetKilled = true
            break
          end
        end
      else
      end
    end
    limitHero = ed.isElementInTable(heroid, team) and targetKilled
  else
    limitHero = true
  end
  return limitHero
end

function Player:increaseTaskCount(config)
  local kid = config.id
  local tp = config.type
  local add = config.add or 1
  local limitHero = false
  local tt = ed.getDataTable("Task")
  local ht = ed.getDataTable("HeroTask")
  for k, v in pairs(self._tasks or {}) do
    if v._status == "working" then
      local chain = v._line
      local id = v._id
      local row
      if ed.player:isHeroTask(chain) then
        row = ht[chain][id]
        limitHero = ed.heroTaskResultCheck(chain, id)
      elseif tt[chain] then
        row = tt[chain][id]
        limitHero = true
      end
      if ed.netreply.sweep and ed.player:isHeroTask(chain) then
        limitHero = false
        if ed.ui.stagedetail.isSweepMode() then
          limitHero = true
        end
      end
      if row then
        local pt = row["Task Progress Type"]
        local tid = row["Task Progress ID"]
        local target = row["Task Target"]
        if pt == tp and limitHero then
          for i = 1, #tid do
            if tid[i] == kid then
              local count = v._task_target
              count = count + add
              count = math.min(count, target)
              self._tasks[k]._task_target = count
              return true
            end
          end
        end
      end
    end
  end
  return false
end

function Player:refreshTaskPress(type, count)
  local tt = ed.getDataTable("Task")
  for k, v in pairs(self._tasks or {}) do
    if v._status == "working" and tt[v._line] then
      local chain = v._line
      local id = v._id
      local row = tt[chain][id]
      if row and row["Task Progress Type"] == type then
        self._tasks[k]._task_target = count
      end
    end
  end
end

function Player:queryTaskPressWithType(type)
  local tt = ed.getDataTable("Task")
  for k, v in pairs(self._tasks or {}) do
    if v._status == "working" and tt[v._line] then
      local chain = v._line
      local id = v._id
      local row = tt[chain][id]
      if row and row["Task Progress Type"] == type then
        return self._tasks[k]._task_target
      end
    end
  end
end

function Player:canJumpHeroTaskSecondStep(chain, id)
  if not self:isHeroTask(chain) then
    return
  end
  if id ~= 2 then
    return
  end
end

function Player:hasValidMonthCard()
  for i, v in pairs(self._monthcards or {}) do
    if self:isMonthCardValid(v._type) then
      return true
    end
  end
  return false
end

function Player:getMonthCardData(type)
  for k, v in pairs(self._monthcards or {}) do
    if v._type == type then
      return v
    end
  end
end

function Player:isMonthCardValid(type)
  local data = self:getMonthCardData(type)
  if not data then
    return false
  end
  if data._type == "free" then
    return true
  end
  local nt = ed.getServerTime()
  local mct = data._expire_time
  if mct == 0 then
    return false
  end
  if nt < mct then
    return true
  end
  return false
end

function Player:getMonthCardRecargeId(id)
  for k, v in pairs(ed.getDataTable("Recharge")) do
    if v["Item ID"] == id then
      return k
    end
  end
  return -1
end

function Player:getFreeMonthCardState()
  if self:isMonthCardValid("free") then
    if self:hasDrawMonthCardToday("free") then
      return "DRAWED"
    else
      return "DRAW"
    end
  else
    return "LOCKED"
  end
end

function Player:getPayMonthCardState()
  if self:isMonthCardValid("payed") then
    if self:hasDrawMonthCardToday("payed") then
      if self:canMonthCardRenew("payed") then
        return "RENEW"
      else
        return "DRAWED"
      end
    else
      return "DRAW"
    end
  else
    return "BUY"
  end
end

function Player:getMonthCardLeftTimes(type)
  if not self:isMonthCardValid(type) then
    return 0
  end
  local cardInfo = self:getMonthCardData(type)
  if cardInfo._expire_time == 0 then
    return cardInfo._left_days
  else
    local time = cardInfo._expire_time - ed.getServerTime()
    return math.floor(time / 86400)
  end
end

function Player:canMonthCardRenew(type)
  local leftTimes = self:getMonthCardLeftTimes(type)
  if not self:isMonthCardValid(type) then
    return true
  end
  if 30 < leftTimes then
    return false
  end
  return true
end

function Player:refreshMonthCardData(data)
  self._monthcards = self._monthcards or {}
  for k, v in pairs(self._monthcards) do
    if v._type == data._type then
      self._monthcards[k] = data
      FireEvent("playerMonthCardUpdate")
      return
    end
  end
  table.insert(self._monthcards, data)
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.RECHARGE)
  FireEvent("playerMonthCardUpdate")
end

function Player:hasDrawMonthCardToday(type)
  local data = self:getMonthCardData(type)
  local y, m, d = ed.time2YMDHMS(data._last_reward_time + ed.getTimeDiff2Server() - 18000)
  local ty, tm, td = ed.time2YMDHMS(ed.getFitServerTime() - 18000)
  if y == ty and m == tm and d == td then
    return true
  end
  return false
end

function Player:isNewDay()
  local timeStamp = ed.storage.getInt(ed.getRoleKey("LastLoginTimeStamp")) or 0
  local y, m, d = ed.time2YMDHMS(timeStamp + ed.getTimeDiff2Server() - 18000)
  local ty, tm, td = ed.time2YMDHMS(ed.getFitServerTime() - 18000)
  if y == ty and m == tm and d == td then
    return false
  end
  return true
end

local box_color_table = {
  bronze = "green",
  silver = "blue",
  gold = "purple",
  magic = "magicsoul",
  skin = "skin",
  newmagic = "newsoul"
}

function Player:refreshFirstTavern(type, times)
  local record = self._tavern_record
  local bt = box_color_table
  for k, v in pairs(record) do
    if v._box_type == type or v._box_type == bt[type] then
      local fd = v._has_first_draw
      local of = ed.bits(fd, 16, 16)
      local tf = ed.bits(fd, 0, 16)
      if times == "one" then
        of = 1
      elseif times == "ten" then
        tf = 1
      end
      record[k]._has_first_draw = ed.makebits(16, of, 16, tf)
      break
    end
  end
end

function Player:useFreeTavern(type)
  local record = self._tavern_record
  local bt = box_color_table
  for k, v in pairs(record) do
    if v._box_type == type or v._box_type == bt[type] then
      record[k]._left_cnt = math.max(self:getTavernLeftTimes(type) - 1, 0)
      record[k]._last_get_time = ed.getServerTime()
    end
  end
end

function Player:getTavernRecord(box)
  local record = self._tavern_record
  local bt = box_color_table
  for k, v in pairs(record) do
    if v._box_type == box or v._box_type == bt[box] then
      return v
    end
  end
  local isIllegal
  for k, v in pairs(box_color_table) do
    if k == box then
      isIllegal = true
      break
    end
  end
  if isIllegal then
    if "newmagic" == box or "newsoul" == box then
      local r = ed.downmsg.tavern_record()
      r._box_type = "newsoul"
      r._left_cnt = 1
      r._last_get_time = 0
      r._has_first_draw = ed.makebits(16, 0, 16, 0)
      table.insert(record, r)
      return r
    end
    local r = ed.downmsg.tavern_record()
    r._box_type = "magicsoul"
    r._left_cnt = 0
    r._last_get_time = 0
    r._has_first_draw = ed.makebits(16, 0, 16, 0)
    table.insert(record, r)
    return r
  end
end

function Player:getTavernLeftTimes(type)
  local tl = {
    bronze = 5,
    silver = 1,
    gold = 1,
    magic = 0,
    newmagic = 1
  }
  local record = self:getTavernRecord(type)
  local lt = record._last_get_time
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    return tl[type]
  else
    return record._left_cnt
  end
end

function Player:getDailyLoginData()
  return self._daily_login or false
end

function Player:getLoginFrequency()
  local dl = self._daily_login
  return dl._frequent or 0
end

function Player:getLoginRewardStatus()
  local dl = self._daily_login
end

function Player:recievedDailyLoginReward(day)
  local tag = false
  for k, v in pairs(self._daily_login._logined_days) do
    tag = v == day
    if tag then
      break
    end
  end
  if tag then
    self._daily_login._reward_status = "yes"
  else
    local tag
    for k, v in pairs(self._daily_login._logined_days) do
      tag = v == day
      if tag then
        break
      end
    end
    if not tag then
      table.insert(self._daily_login._logined_days, day)
    end
    self._daily_login._frequent = #self._daily_login._logined_days
  end
  self._daily_login._make_up_days = self._daily_login._make_up_days or {}
  for k, v in pairs(self._daily_login._make_up_days) do
    if v == day then
      table.remove(self._daily_login._make_up_days, k)
      break
    end
  end
end

function Player:recievedDailyLoginRewardOld(day)
  local tag
  for k, v in pairs(self._daily_login._logined_days) do
    tag = v == day
    if tag then
      break
    end
  end
  if not tag then
    table.insert(self._daily_login._logined_days, day)
  end
  self._daily_login._last_login_time = ed.getServerTime()
  self._daily_login._frequent = #self._daily_login._logined_days
  self._daily_login._make_up_days = self._daily_login._make_up_days or {}
  for k, v in pairs(self._daily_login._make_up_days) do
    if v == day then
      table.remove(self._daily_login._make_up_days, k)
      break
    end
  end
end

function Player:getLoginIsToDay()
  local tabs = self._daily_login
  local rewardsStatus = {
    [1] = "yes",
    [0] = "no"
  }
  tabs._reward_status = rewardsStatus[tabs._reward_status] or tabs._reward_status
  if not tabs._last_login_time or 1 > tabs._last_login_time then
    tabs._reward_status = "no"
    return tabs._reward_status, true
  end
  local time = ed.getFitServerTime()
  local dateNew = ed.getYMDHMS(time - 18000)
  for k, v in pairs(dateNew) do
    dateNew[k] = tonumber(v)
  end
  local date = ed.getYMDHMS(ed.time2Server(tabs._last_login_time) - 18000)
  for k, v in pairs(date) do
    date[k] = tonumber(v)
  end
  if dateNew.month ~= date.month then
    tabs._logined_days = {}
    tabs._frequent = 0
    tabs._make_up_days = {}
    tabs._reward_status = "no"
    return tabs._reward_status, true
  elseif dateNew.day ~= date.day then
    local days = dateNew.day - date.day
    tabs._make_up_days = tabs._make_up_days or {}
    for i = 1, days - 1 do
      table.insert(tabs._make_up_days, date.day + i)
    end
    tabs._reward_status = "no"
    return tabs._reward_status, true
  end
  return tabs._reward_status, true
end

function Player:getLoginRedPoint()
  local rewardStatus = self:getLoginIsToDay()
  return rewardStatus == "no"
end

function Player:resetDailyjobTime(id)
  self._dailyjobs = self._dailyjobs or {}
  for k, v in pairs(self._dailyjobs) do
    if v._id == id then
      self._dailyjobs[k]._last_rewards_time = ed.getServerTime()
      self._dailyjobs[k]._task_target = 0
    end
  end
end

local dailyjob_login_time

function Player:odRefreshDailyjob()
  dailyjob_login_time = dailyjob_login_time or self._last_login
  local tdt = ed.getDataTable("Todolist")
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(dailyjob_login_time, nt) then
    dailyjob_login_time = nt
    for k, v in pairs(self._dailyjobs or {}) do
      local id = v._id
      local row = tdt[id]
      if row then
        local ttp = row["Task Progress Type"]
        local ttt = row["Task Target"]
        if ttp == "Login" then
          self._dailyjobs[k]._task_target = ttt
        else
          self._dailyjobs[k]._task_target = 0
        end
      end
    end
  end
end

function Player:getDailyjobCount(id)
  self:odRefreshDailyjob()
  local dayData = ed.taskData:getPageDataObj("day")
  for k, v in pairs(self._dailyjobs or {}) do
    if v._id == id then
      local row = ed.getDataTable("Todolist")[id]
      if row then
        local tp = row["Task Progress Type"]
        local ttt = row["Task Target"]
        local nt = ed.getServerTime()
        if tp == "Login" then
          if ed.checkTwoDateod(v._last_rewards_time, nt) then
            if dayData:checkDailyjobTrigger(id) then
              self._dailyjobs[k]._task_target = ttt
            else
              self._dailyjobs[k]._task_target = 0
            end
          end
        elseif tp == "MonthlyCardPeriod" or tp == "SuperMonthlyCardPeriod" then
          if ed.checkTwoDateod(v._last_rewards_time, nt) and 0 ~= self:isMonthCardValid(row["Task Progress ID"]) then
            if self:isMonthCardValid(row["Task Progress ID"]) then
              self._dailyjobs[k]._task_target = ttt
            end
          else
            return 0
          end
        end
        if ed.player:getMonthCardLeftTimes(row["Task Progress ID"]) == 31 and ed.player:hasDrawMonthCardToday(ed.parameter.person_month_card) then
          return 0
        end
        if tp == "SkillUpgradeSuccess" then
          if not self.canShowHeros then
            self.canShowHeros = {}
            for _, vv in pairs(ed.getDataTable("Unit")) do
              if ed.readhero.isHeroOpen(vv.ID, ed.getServerTime()) then
                table.insert(self.canShowHeros, vv.ID)
              end
            end
          end
          for _, vv in ipairs(self.canShowHeros) do
            if not ed.player.heroes[vv] then
              return v._task_target or 0
            end
          end
          for _, vv in pairs(ed.player.heroes) do
            local vvv = ed.copyProto(vv)
            if vvv.data._skill_levels then
              for ii = 1, 4 do
                if vvv.data._skill_levels[ii] and vvv.data._skill_levels[ii] < 80 then
                  return v._task_target or 0
                end
              end
            end
          end
          return 1
        end
      end
      return v._task_target or 0
    end
  end
  return 0
end

function Player:checkDailyjobCount()
  self:odRefreshDailyjob()
  local dayData = ed.taskData:getPageDataObj("day")
  local redNum = 0
  for k, v in pairs(self._dailyjobs or {}) do
    local id = v._id
    local row = ed.getDataTable("Todolist")[id]
    if row then
      local ttt = row["Task Target"]
      local type = row["Mission Type"]
      local lrt
      local nt = ed.getServerTime()
      if ed.checkTwoDateod(v._last_rewards_time, nt) then
        lrt = true
      end
      if ttt <= self:getDailyjobCount(id) and dayData:checkDailyjobTrigger(id) and lrt and type ~= "WeeklyMission" then
        redNum = redNum + 1
      end
    end
  end
  return 0 < redNum, redNum
end

function Player:increaseDailyjobCount(config)
  self:odRefreshDailyjob()
  local tp = config.type
  local add = config.add or 1
  local pid = config.pid
  local tdt = ed.getDataTable("Todolist")
  local dayData = ed.taskData:getPageDataObj("day")
  for k, v in pairs(self._dailyjobs or {}) do
    if dayData and dayData:checkDailyjobTrigger(v._id) then
      local row = tdt[v._id]
      local ttp = row["Task Progress Type"]
      local progressid = row["Task Progress ID"]
      local target = row["Task Target"]
      if ttp == tp and (pid or progressid) == progressid then
        local count = self._dailyjobs[k]._task_target
        count = count + add
        self._dailyjobs[k]._task_target = math.min(count, target)
      end
    end
  end
  local lsr = ed.ui.baselsr.create("base")
  lsr:report("increaseDailyjobCount")
  dayData:refreshData({_increaseDailyjobCount = true})
end

function Player:getDailyjobData(id)
  for k, v in pairs(self._dailyjobs) do
    if v._id == id then
      return v
    end
  end
  return nil
end

function ed.stageType(id)
  local type
  xpcall(function()
    if 0 < id and id < 10000 then
      type = "normal"
    elseif 10000 < id and id < 10999 then
      type = "elite"
    elseif 11000 < id and id < 19999 then
      type = "challenge"
    elseif 20000 < id and id < 30000 and (not (20300 <= id) or not (id < 20400)) then
      type = "act"
    elseif id == -1 then
      type = "pvp"
    elseif 40000 < id and id < 50000 then
      type = "raid"
    end
  end, EDDebug)
  return type
end

function ed.elite2NormalStage(id)
  local type = ed.stageType(id)
  if type == "elite" then
    return id - 10000
  elseif type == "normal" then
    return id
  else
    return id
  end
end

function Player:loadStageStars(data)
  local function orderList(l)
    for i = 1, #l do
      for j = i, 2, -1 do
        if l[j] < l[j - 1] then
          local t = l[j]
          
          l[j] = l[j - 1]
          l[j - 1] = t
        end
      end
    end
  end
  
  local function initStageStars(tb, data)
    for i = 1, #tb do
      local id = tb[i]
      local index = math.floor((i - 1) / 16) + 1
      local n = (i - 1) % 16
      self.stage_stars[id] = ed.bits(data[index] or 0, n * 2, 2)
    end
  end
  
  local function initStageStarsWithId(aid, act)
    for i = 1, #aid do
      local id = aid[i]
      for k, v in pairs(act) do
        if id == v._stage_id then
          self.stage_stars[v._stage_id] = v._stars
        end
      end
    end
  end
  
  local normal = data._normal_stage_stars or {}
  local elite = data._elite_stage_stars or {}
  local challenge = {}
  local act = data._act_stage_stars or {}
  for k, v in pairs(act) do
    self.stage_stars[v._stage_id] = v._stars
  end
  local nid, eid, aid, cid = {}, {}, {}, {}
  local st = ed.getDataTable("Stage")
  for k, v in pairs(st) do
    if type(k) == "number" then
      local type = ed.stageType(k)
      if type == "normal" then
        table.insert(nid, k)
      elseif type == "elite" then
        table.insert(eid, k)
      elseif type == "act" then
        table.insert(aid, k)
      elseif type == "challenge" then
        table.insert(cid, k)
      end
    end
  end
  orderList(nid)
  orderList(eid)
  orderList(aid)
  orderList(cid)
  initStageStars(nid, normal)
  initStageStars(eid, elite)
  initStageStarsWithId(aid, act)
  initStageStarsWithId(cid, challenge)
end

function Player:getStageStar(stage)
  if not stage then
    return 0
  end
  return self.stage_stars[stage] or 0
end

function Player:getStageProgress()
  local progress = 0
  for k, v in pairs(self.stage_stars) do
    local type = ed.stageType(k)
    if type == "normal" and 0 < v and k > progress and k <= 1000 then
      progress = k
    end
  end
  return self.stage_stars[progress + 1] and progress + 1 or progress
end

function Player:getEliteStageProgress()
  local progress = 0
  local st = ed.getDataTable("Stage")
  for k, v in pairs(self.stage_stars) do
    local type = ed.stageType(k)
    if type == "elite" and 0 < v and k > progress then
      local sg = st[k]["Stage Group"]
      local selectReward = st[k]["Select Reward"] or {}
      if 0 < self.stage_stars[sg] and #selectReward == 0 then
        progress = k
      end
    end
  end
  progress = self.stage_stars[progress + 1] and progress + 1 or progress
  return math.max(progress, 1)
end

function Player:getChallengeProgress()
  local progress = 0
  local st = ed.getDataTable("Stage")
  for k, v in pairs(self.stage_stars) do
    local type = ed.stageType(k)
    if type == "challenge" and 0 < v and k > progress then
      local sg = st[k]["Stage Group"]
      if 0 < self.stage_stars[sg] then
        progress = k
      end
    end
  end
  progress = self.stage_stars[progress + 1] and progress + 1 or progress
  return math.max(progress, 1)
end

function Player:setStageStars(stage, stars)
  if stars == nil then
    return
  end
  local type = ed.stageType(stage)
  if not ed.isElementInTable(type, {
    "normal",
    "elite",
    "act",
    "challenge"
  }) then
    return
  end
  local old = self:getStageStar(stage) or 0
  self.stage_star_record = self.stage_star_record or {}
  self.stage_star_record[stage] = old
  if stars <= old then
    return
  end
  self.stage_stars[stage] = stars
  self._userstage._normal_stage_stars = self._userstage._normal_stage_stars or {}
  local record = self._userstage._normal_stage_stars
  if type == "elite" then
    stage = ed.elite2NormalStage(stage)
    record = self._userstage._elite_stage_stars or {}
  elseif type == "challenge" then
    record = {}
  end
  if type == "challenge" then
    for k, v in pairs(record) do
      if v._stage_id == stage then
        v._stars = stars
      end
    end
  else
    local intpos = math.floor((stage - 1) / 16) + 1
    local bitpos = (stage - 1) % 16
    local num = record[intpos] or 0
    local mask = ed.makebits(2, 3, bitpos * 2, 0)
    mask = bit.bnot(mask)
    num = bit.band(num, mask)
    local mask = ed.makebits(2, stars, bitpos * 2, 0)
    num = bit.bor(num, mask)
    record[intpos] = num
  end
end

function Player:getChapterStarIds()
  local data = self._userstage._chapter_star_ids or {}
  return data
end

function Player:setChapterStarIds(idx)
  self._userstage._chapter_star_ids = self._userstage._chapter_star_ids or {}
  if not ed.isElementInTable(idx, self._userstage._chapter_star_ids) then
    table.insert(self._userstage._chapter_star_ids, idx)
  end
end

function Player:getStageLimitAt(idx)
  local row = self._userstage._elite_daily_record[idx]
  return {
    _id = ed.bits(row, 10, 10),
    _count = ed.bits(row, 5, 5),
    _reset = ed.bits(row, 0, 5)
  }
end

function Player:setStageLimitAt(id)
  local idx = self.stage_limit_back_key[id]
  local count = self.stage_limit[id]
  local reset = self.stage_reset_times[id] or 0
  if idx then
    self._userstage._elite_daily_record[idx] = ed.makebits(10, id, 5, count, 5, reset)
  else
    table.insert(self._userstage._elite_daily_record, ed.makebits(10, id, 5, count, 5, reset))
    self.stage_limit_back_key[id] = #self._userstage._elite_daily_record
  end
end

function Player:getStageLimit(id)
  self.stage_limit = self.stage_limit or {}
  id = ed.elite2NormalStage(id)
  if id then
    return self.stage_limit[id] or 0
  else
    return 0
  end
end

function Player:checkStageLimitResetTimesMax(id)
  local vip = self:getvip()
  local vt = ed.getDataTable("VIP")
  local row = vt[vip]
  if not row then
    return true
  end
  local times = row["Elite Reset"]
  local nt = self:getStageLimitResetTimes(id)
  if times <= nt then
    return true
  end
  return false
end

function Player:getStageLimitResetTimes(id)
  id = ed.elite2NormalStage(id)
  return self.stage_reset_times[id] or 0
end

function Player:getResetEliteCost(id)
  if resource_config.elite_stage_reset_cost then
    return resource_config.elite_stage_reset_cost
  end
  id = ed.elite2NormalStage(id)
  local times = self:getStageLimitResetTimes(id)
  local gpt = ed.getDataTable("GradientPrice")
  local row = gpt[times + 1]
  if not row then
    return
  else
    return row["Elite Reset"]
  end
end

function Player:addStageLimit(id, amount)
  self.stage_limit = self.stage_limit or {}
  amount = amount or 1
  self.stage_limit[id] = (self.stage_limit[id] or 0) + amount
  self:setStageLimitAt(ed.elite2NormalStage(id))
end

function Player:refreshStageEliteLimit(stage)
  self.stage_limit = self.stage_limit or {}
  local stage = ed.elite2NormalStage(stage)
  self.stage_limit[stage] = 0
  self.stage_reset_times[stage] = (self.stage_reset_times[stage] or 0) + 1
  self:setStageLimitAt(stage)
end

function Player:resetEliteLimit()
  for k, v in pairs(self.stage_limit) do
    self.stage_limit[k] = 0
    self.stage_reset_times[k] = 0
    self:setStageLimitAt(k)
  end
end

function Player:getEliteResetTime()
  return self._userstage._elite_reset_time
end

function Player:getStageSelectReward()
  return self._userstage._stage_select_reward
end

function Player:refreshEliteResetTime()
  self._userstage._elite_reset_time = ed.getServerTime()
end

function Player:refreshStageSelectReward(stage_id, reward_id)
  self._userstage._stage_select_reward = self._userstage._stage_select_reward or {}
  for _, v in ipairs(self._userstage._stage_select_reward) do
    if v._stage_id == stage_id then
      v._reward_id = reward_id
      return
    end
  end
  table.insert(self._userstage._stage_select_reward, {_stage_id = stage_id, _reward_id = reward_id})
end

function Player:resetEliteRequest_type0()
  if self.justReqReset then
    EDLog("justReqReset reset_elite")
    return
  end
  local msg = ed.upmsg.reset_elite()
  msg._type = 0
  ed.send(msg, "reset_elite")
  self.justReqReset = true
  ListenTimer(Timer:Once(1), function()
    self.justReqReset = nil
  end)
end

function Player:resetEliteRequest_Reply()
  self.justReqReset = nil
end

function Player:getStageLoots()
  local list = {}
  for _, lootint in ipairs(self.loots) do
    local _, __, ___, item_id = ed.splitbits(lootint, EDTables.globalConfig.waveIDBitNum, 3, 1, EDTables.globalConfig.itemIDBitNum)
    table.insert(list, {
      type = itemType(item_id),
      id = item_id
    })
  end
  for _, loot in ipairs(self.hpLoots) do
    for i, v in ipairs(loot._loots) do
      if v.geted then
        for _, item in ipairs(v._items) do
          table.insert(list, {
            type = ed.itemType(item),
            id = item
          })
        end
      end
    end
  end
  return list
end

function Player:getStageLootOfMonster(wave_idx, monster_idx, dir_flag)
  local list = {}
  for _, lootint in ipairs(self.loots) do
    local wave, monster, dflag, item_id = ed.splitbits(lootint, EDTables.globalConfig.waveIDBitNum, 3, 1, EDTables.globalConfig.itemIDBitNum)
    local dircheck = false
    if dflag == 0 and "left" == dir_flag then
      dircheck = true
    end
    if dflag == 1 and "right" == dir_flag then
      dircheck = true
    end
    if wave_idx == wave and monster_idx == monster and dircheck then
      table.insert(list, {
        type = ed.itemType(item_id),
        id = item_id
      })
    end
  end
  return list
end

function Player:getHpLootOfMonster(wave_idx, monster_idx, dir_flag, hpPercent, oldPercent)
  local list = {}
  for _, loot in ipairs(self.hpLoots) do
    local wave, monster, dflag, item_id = ed.splitbits(loot._monster_info, EDTables.globalConfig.waveIDBitNum, 3, 1, EDTables.globalConfig.itemIDBitNum)
    local dircheck = false
    if dflag == 0 and "left" == dir_flag then
      dircheck = true
    end
    if dflag == 1 and "right" == dir_flag then
      dircheck = true
    end
    if wave_idx == wave and monster_idx == monster and dircheck then
      if not loot._loots then
        break
      end
      for i, v in ipairs(loot._loots) do
        if oldPercent * 10 < v._per and hpPercent * 10 > v._per and not v.geted and v._items then
          v.geted = true
          for _, item in ipairs(v._items) do
            table.insert(list, {
              type = ed.itemType(item),
              id = item
            })
          end
        end
      end
    end
  end
  return list
end

function Player:takeStageExp(stage)
  local reward = ed.lookupDataTable("Stage", nil, stage)
  self:addExp(reward["Exp Reward"], "battle")
end

function Player:takeStageFailExp(stage)
  local reward = ed.lookupDataTable("Stage", nil, stage)
  if reward then
    self:addExp(reward["Fail Exp Reward"], "battle")
  end
end

function Player:takePVPReward(hero_list)
  local heroexp = math.floor(ed.getDataTable("PlayerLevel")[self:getLevel()]["Arena Hero Exp"] / #hero_list)
  for i = 1, #hero_list do
    local hero = hero_list[i]
    if hero:getMercenaryData() == nil then
      hero:addExp(heroexp)
    end
  end
end

function Player:takeStageReward(stage, stars, hero_list, loots, config)
  config = config or {}
  local stageCsvName = config.stageCsvName or "Stage"
  local reward = ed.lookupDataTable(stageCsvName, nil, stage)
  self:addMoney(reward["Money Reward"])
  local exp = reward["Exp Reward"]
  local result = 1
  self:addExp(exp * result, "battle")
  local heroexp = math.floor(reward["Heroexp Reward"] / #hero_list)
  for i = 1, #hero_list do
    local hero = hero_list[i]
    if hero:getMercenaryData() == nil then
      hero:addExp(heroexp)
    end
  end
  if loots then
    for _, item in ipairs(loots) do
      local item_id = item.id
      local item_type = item.type
      local amount = item.amount
      if item_type == "hero" then
        self:addHero(item_id)
      elseif item_type == "equip" then
        self:addEquip(item_id, amount)
      end
    end
  end
  if stage == 1001 then
    return
  end
  self:setStageStars(stage, stars)
end

function Player:getSweepTimes()
  local eid = ed.parameter.sweep_coin_id
  return self.equip_qunty[eid] or 0
end

function Player:useSweepTimes(times)
  local eid = ed.parameter.sweep_coin_id
  self:consumeEquip(eid, times)
end

function Player:addShadowRunes(vit, timeAdd)
  vit = vit or 1
  local param = ed.parameter
  local vitality = self._shadow_runes
  self:refreshShadowRunesTime()
  if timeAdd then
    if vitality._current < ed.playerlimit.maxShadowRunes() then
      vitality._current = vitality._current + vit
    end
  else
    vitality._current = vitality._current + vit
  end
  if vitality._current < 0 then
    print("shadow runes less than zero . it's a bug!")
    vitality._current = 0
  end
  self:refreshShadowRunesTime(timeAdd)
end

function Player:getShadowRunes()
  local vitality = self._shadow_runes
  return vitality._current
end

function Player:checkShadowRunesLimit()
  local vitality = self._shadow_runes
  local param = ed.parameter
  local vit = vitality._current
  if vit >= ed.playerlimit.maxShadowRunes() then
    return true
  end
  return false
end

function Player:refreshShadowRunesTime(timeAdd)
  local vitality = self._shadow_runes
  if timeAdd then
    local param = ed.parameter
    local gap = self:getShadowRunesGap()
    local lt = vitality._lastchange
    vitality._lastchange = lt + gap
  end
  if self:checkShadowRunesLimit() then
    vitality._lastchange = ed.getServerTime()
  end
end

function Player:getShadowRunesBuyTimes()
  self:resetShadowRunesBuyTimes()
  local vitality = self._shadow_runes
  return vitality._todaybuy
end

function Player:getBuyShadowRunesCost()
  local t = self:getShadowRunesBuyTimes()
  local gpt = ed.getDataTable("GradientPrice")
  return gpt[t + 1]["Excavate Vitality"]
end

function Player:canBuyShadowRunes()
  local t = self:getShadowRunesBuyTimes()
  local tlimit = ed.playerlimit.maxBuyShadowRunesTimes()
  if t >= tlimit then
    return false
  end
  return true
end

function Player:resetShadowRunesBuyTimes()
  local vitality = self._shadow_runes
  local lt = vitality._lastbuy
  local nt = ed.getServerTime()
  if ed.checkTwoDateod(lt, nt) then
    vitality._todaybuy = 0
  end
end

function Player:refreshShadowRunes()
end

function Player:getShadowRunesNextUpdate()
  local param = ed.parameter
  local gap = self:getShadowRunesGap()
  local vitality = self._shadow_runes
  local ltime = vitality._lastchange
  local stime = ed.getServerTime()
  local dt = gap - (stime - ltime)
  return dt
end

local runesGap

function Player.getShadowRunesGap()
  if not runesGap then
    local t = ed.getDataTable("ExcavateServerData")
    runesGap = t[1]["Excavate Vitality Recover Interval"]
  end
  return runesGap
end

function Player:getBread()
  if not self.bread then
    self.bread = 0
  end
  return self.bread
end

function Player:setBread(num)
  self.bread = num
  self.bread = math.max(self.bread, 0)
end

function Player:addBread(num)
  self.bread = self.bread + num
  self.bread = math.max(self.bread, 0)
end

function Player:setLastBreadChange(time)
  self.lastBreadChange = time
end

function Player:getLastBreadChange()
  if not self.lastBreadChange then
    self.lastBreadChange = ed.getServerTime()
  end
  return self.lastBreadChange
end

function Player:getNextBreadChange()
  local gap = ed.lookupDataTable("OfflineQuestConfig", "Bread Recovery Duration", 1)
  local nowTime = ed.getServerTime()
  local delta = (nowTime - self.lastBreadChange) % gap
  return gap - delta
end

function Player:updateBread()
  local gap = ed.lookupDataTable("OfflineQuestConfig", "Bread Recovery Duration", 1)
  local lastTime = ed.getServerTime() - self.lastBreadChange
  local addBread = math.floor(lastTime / gap) or 0
  self.lastBreadChange = self.lastBreadChange + addBread * gap
  if 0 < addBread and self:getBread() < ed.playerlimit.maxBreads() then
    self:addBread(addBread)
  end
end

function Player:initOfflineQuestData(msg)
  ed.offlinequest.offline_mgr:initHeroes(msg)
end

function Player:syncRechargeLimit(data)
  self._recharge_limits = data
end

function Player:setRechargeSum(rmb)
  local previp = self:getvip()
  self._vip_exp = rmb
  local vip = self:getvip()
  if previp < vip then
    local lsr = ed.ui.baselsr.create("base")
    lsr:report("vipLevelup", {previp = previp})
  end
end

function Player:getRechargeLimit(id)
  local rl = self._recharge_limits or {}
  for i = 1, #rl do
    local rid, times = ed.analyzeItem2(rl[i])
    if rid == id then
      return times
    end
  end
  return 0
end

function Player:refreshRechargeLimit(id)
  local rt = ed.getDataTable(resource_config.rechargecsv or "Recharge")
  local row = rt[id]
  if not row then
    return
  end
  local limit = row.Limit or 0
  if limit <= 0 then
    return
  end
  local rl = self._recharge_limits or {}
  for i = 1, #rl do
    local r = rl[i]
    local rid, times = ed.analyzeItem2(r)
    if rid == id then
      times = times + 1
      local nr = ed.packItem(id, times)
      rl[i] = nr
      return
    end
  end
  self._recharge_limits = self._recharge_limits or {}
  local nr = ed.packItem(id, 1)
  table.insert(self._recharge_limits, nr)
end

function Player:checkRechargeItemValid(id)
  local rt = ed.getDataTable(resource_config.rechargecsv or "Recharge")
  local row = rt[id]
  if not row then
    return
  end
  if ed.isElementInTable(big_area, row["Hide Region"]) then
    return false
  end
  local limit = row.Limit
  local count = self:getRechargeLimit(id)
  if 0 < limit and limit <= count then
    return false
  end
  local preid = row["Replace ID"] or 0
  if preid == 0 then
    return true
  end
  local preLimit = rt[preid].Limit
  local preCount = self:getRechargeLimit(preid)
  if preLimit <= preCount then
    return true
  end
  return false
end

function Player:setEnergyBeanNum(num)
  if not num then
    return
  end
  self.energy_bean = num
end

function Player:getEnergyBeanNum()
  return self.energy_bean or 0
end

function Player:initModuleSwitch()
  local switch = self.global_config._module_switch or {}
  local openLevel = switch._open_level
  if openLevel then
    ed.parameter.team_level_max = openLevel
  end
  local openChapter = switch._open_chapter
  if openChapter then
    ed.parameter.max_stage_chapter = openChapter
  end
  local openRank = switch._open_rank
  if openRank then
    ed.parameter.unit_max_rank = openRank
    ed.parameter.display_equipale_hero_rank = openRank
  end
  local banModule = switch._ban_module or {}
  for i, v in ipairs(banModule) do
    local mst = ed.getDataTable("ModuleSwitcher")
    local key = mst[v]["Module Type"]
    ed.playerlimit.closeModule(key)
  end
end

function Player:setNewMailAmount(amount)
  local num = self.newMailAmount
  self.newMailAmount = amount
  if num ~= amount then
    ed.ui.baselsr.create():report("receiveMail")
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Mailbox)
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.MAIL)
  end
end

function Player:checkNewMail()
  return 0 < (self.newMailAmount or 0)
end

function Player:resetNewMail()
  self:setNewMailAmount(0)
  self:setExpireMailAmount(0)
end

function Player:checkSyncMailData()
  local data = self:getMailData()
  local hasNew = self:checkNewMail()
  if not data or hasNew then
    return true
  end
  return false
end

function Player:getMailData()
  return self.mail_list
end

function Player:getMailAmount()
  local amount = 0
  local data = self.mail_list or {}
  for i = 1, #data do
    local status = data[i]._status
    if status == "unread" or status == 0 then
      amount = amount + 1
    end
  end
  return amount
end

function Player:checkSpecialMail(data)
  for index, mail in ipairs(data) do
    local items = mail._items
    for i, value in ipairs(items or {}) do
      local item = items[i]
      local id, amount = ed.analyzeItem2(value)
      if ed.isElementInTable(id, ed.ui.mailbox.specialEquipTable) then
        return true
      end
    end
  end
  return false
end

function Player:refreshMailData(data)
  self.mail_list = data or {}
  self:resetNewMail()
end

function Player:deleMail(id)
  local data = self.mail_list or {}
  for i, v in ipairs(data) do
    if v._id == id then
      table.remove(data, i)
    end
  end
end

function Player:readMail(ids, reply)
  local isId = true
  local data = self.mail_list or {}
  if not ids or not data then
    return
  end
  reply = reply or {}
  for i, v in ipairs(data) do
    for k, s in pairs(ids) do
      if v._id == s then
        v._status = "read"
        if v._items or v._mail_acc then
          table.remove(data, i)
        end
        isId = false
        break
      end
    end
  end
  if isId then
    return
  end
  local money = reply._money or 0
  local diamond = reply._diamonds or 0
  local pay_diamond = reply._pay_diamond or 0
  ed.player:addrmb(diamond)
  ed.player:addPayrmb(pay_diamond)
  ed.player:addMoney(money)
  for k, v in ipairs(reply._points or {}) do
    ed.player:addPoint(v._type, v._value)
  end
  if reply._monthcard then
    self:refreshMonthCardData(reply._monthcard)
  end
  for ii, iv in ipairs(reply._items or {}) do
    if iv ~= 0 then
      local id, amount = ed.analyzeItem2(iv)
      local itemType = ed.itemType(id)
      if itemType == "hero" then
        self:addHero(id)
      elseif itemType == "equip" then
        self:addEquip(id, amount)
      end
    end
  end
  for i, mv in ipairs(reply._mail_acc or {}) do
    if mv._type == "hero" then
      self:addHero(mv._id)
    end
  end
end

function Player:checkunreadMail()
  if self:checkNewMail() then
    return true
  end
end

function Player:setExpireMailAmount(amount)
  self.expireMailAmount = amount
  local ButtonType = ed.ui.configs.mainButton.ButtonType
  FireEvent("MainRedTagChange", ButtonType.MAIL)
end

function Player:getMailDayTag()
  if self.expireMailAmount and self.expireMailAmount > 0 then
    return true
  end
  local nTime = ed.getServerTime()
  for i, v in ipairs(self.mail_list or {}) do
    if v._status and v._status == "unread" or v._status == 0 then
      local time = (v._expire_time or 0) - nTime
      if time < 259200 then
        return true
      end
    end
  end
  return false
end

function Player:getMailDayRedOrTag()
  local tag = self:getMailDayTag() and 2 or self:checkunreadMail() and 1 or 0
  return 0 < tag, tag
end

function Player:resetActRecord()
  local data = self._userstage._act_daily_record
  for i = 1, #(data or {}) do
    local r = data[i]
    local lt = r._last_change
    local nt = ed.getServerTime()
    if ed.checkTwoDateod(lt, nt) then
      r._frequency = 0
    end
  end
end

function Player:getActRecord(id)
  self:resetActRecord()
  local data = self._userstage._act_daily_record
  for i = 1, #(data or {}) do
    local r = data[i]
    if r._id == id then
      return r
    end
  end
  return nil
end

function Player:getActcd(id)
  local record = self:getActRecord(id) or {}
  return record._last_change or 0
end

function Player:getActTimes(id)
  self:resetActRecord()
  local record = self:getActRecord(id) or {}
  return record._frequency or 0
end

function Player:addActTimes(id, times)
  self._userstage._act_daily_record = self._userstage._act_daily_record or {}
  local at = self:getActTimes(id)
  times = times or 1
  at = at + times
  local record = self:getActRecord(id)
  if record then
    record._frequency = at
    record._last_change = ed.getServerTime()
  else
    local r = ed.downmsg.act_daily_record()
    r._id = id
    r._frequency = at
    r._last_change = ed.getServerTime()
    table.insert(self._userstage._act_daily_record, r)
  end
end

function Player:resetActTimes()
  self.act_times = {}
  self._userstage._act_enter_frequency = {}
end

function Player:getActResetTime()
  local data = self._userstage
  return data._act_reset_time
end

function Player:refreshActResetTime()
  local data = self._userstage
  data._act_reset_time = ed.getServerTime()
end

function Player:getTutorialRecord(key)
  return (self._tutorial or {})[key]
end

function Player:setTutorialRecord(key, value)
  self:initTutorial()
  self._tutorial[key] = value
end

function Player:increaseTutorial(key)
  self:initTutorial()
  self._tutorial[key] = (self._tutorial[key] or 0) + 1
end

function Player:initTutorialRecord(key, value)
  self._tutorial = self._tutorial or {}
  self._tutorial[key] = self._tutorial[key] or value
end

function Player:initTutorial()
  self._tutorial = self._tutorial or {}
  local res = ed.tutorialres.t_key
  for k, v in pairs(res) do
    self:initTutorialRecord(v.id, 0)
  end
end

function Player:getChatFreeTime()
  local chat = ed.player._chat
  if chat == nil then
    return 0
  end
  local last = chat._last_reset_world_chat_time
  local time = ed.getServerTime()
  if ed.checkTwoDateod(last, time) then
    chat._last_reset_world_chat_time = ed.getServerTime()
  end
  return chat._world_chat_times or 0
end

function Player:setChatFreeTime(time)
  local chat = ed.player._chat
  if chat == nil then
    return
  end
  chat._world_chat_times = time
end

function Player:subChatFreeTime()
  local chat = ed.player._chat
  if chat == nil then
    return
  end
  chat._world_chat_times = math.max(0, chat._world_chat_times - 1)
end

function Player:getMidasMaxTimes()
  return 300
end

function Player:getMidasTimes()
  local data = ed.player._usermidas
  local last = data._last_change
  local time = ed.getServerTime()
  if ed.checkTwoDateod(last, time) then
    self:resetMidasTimes()
  end
  return data._today_times or 0
end

function Player:useMidasTimes(times)
  local data = ed.player._usermidas
  data._last_change = ed.getServerTime()
  data._today_times = data._today_times + (times or 1)
end

function Player:resetMidasTimes()
  local data = ed.player._usermidas
  data._last_change = ed.getServerTime()
  data._today_times = 0
end

function ed.itemType(id)
  if not id then
    return
  end
  if type(id) == "string" then
    return id
  end
  local itemtype
  if 300000 < id then
    itemtype = "magicstone"
  elseif id < 100000 and 20000 <= id then
    itemtype = "equip"
  elseif id < 100 or 10000 <= id then
    itemtype = "hero"
  elseif id < 10000 then
    itemtype = "equip"
  else
    EDDebug("Invalid item ID: " .. id)
  end
  return itemtype
end

function ed.isMagicStone(id, ttype)
  ttype = string.lower(ttype or "")
  if ttype == "magicstone" then
    return true
  end
  local itemType = ed.itemType(id)
  return itemType == "magicstone"
end

function Player:getEquipAmount(id)
  return self.equip_qunty[id] or 0
end

function Player:getPlayerEquipsWithType(type)
  local data = {}
  for k, v in pairs(ed.readequip.getEquipWithType(type)) do
    if self:getEquipAmount(k) > 0 then
      table.insert(data, v)
    end
  end
  table.sort(data, function(a, b)
    return a[type] < b[type]
  end)
  return data
end

function Player:getPlayerExpEquips()
  return self:getPlayerEquipsWithType("Exp")
end

function Player:getPlayerVitalityEquips()
  return self:getPlayerEquipsWithType("Vitality")
end

function Player:getLessVitalityEquips()
  local data = self:getPlayerVitalityEquips(self) or {}
  if 0 < #data then
    return data[1]
  end
end

function Player:getItemAt(idx)
  local row = self._items[idx]
  return row
end

function Player:setTimelyItemAt(insid)
end

function Player:setItemAt(id)
  local key
  for k, v in pairs(self._items) do
    if self:getItemAt(k)._id == id then
      key = k
      break
    end
  end
  local amount = self.equip_qunty[id] or 0
  if key then
    if amount == 0 then
      table.remove(self._items, key)
    else
      self._items[key] = {_id = id, _amount = amount}
    end
  end
end

local function showMaxAmountNotice(self, tid, amount)
  local curAmount = ed.player:getEquipAmount(tid)
  local name = ed.lookupDataTable("equip", "Name", tid)
  local maxAmount = ed.lookupDataTable("equip", "Max Amount", tid)
  if not maxAmount then
    return
  end
  if 1 < maxAmount and maxAmount <= curAmount + amount then
    if not self.noticeCnt then
      self.noticeCnt = 0
    end
    self.noticeCnt = self.noticeCnt + 1
    local noticeStr = name .. T(" \229\183\178\232\182\133\229\135\186\232\131\140\229\140\133\228\184\138\233\153\144")
    ListenTimer(Timer:Once(self.noticeCnt * 0.8), function()
      ed.showToast(noticeStr)
    end)
    ListenTimer(Timer:Once(5), function()
      self.noticeCnt = 0
    end)
  end
end

function Player:addEquip(tid, amount, insid, time, param)
  if amount and amount < 0 then
    self:consumeEquip(tid, math.abs(amount), insid)
    return
  end
  self.newAddEquipList = self.newAddEquipList or {}
  amount = amount or 1
  if 0 < amount then
    showMaxAmountNotice(self, tid, amount)
    local isremove = false
    local index = 0
    for i, v in ipairs(self.newAddEquipList) do
      if v == tid then
        isremove = true
        index = i
      end
    end
    if isremove then
      table.remove(self.newAddEquipList, index)
    end
    table.insert(self.newAddEquipList, 1, tid)
  end
  self:addItem(self.equip_qunty, self._items, tid, amount)
  if ed.getDataTable("equip")[tid] and not ed.getDataTable("equip")[tid].Invisible then
    self:addItemInPackage(tid, amount, insid, time)
  end
  if ed.readequip.value(tid, "Category") == T("\231\129\181\233\173\130\231\159\179") then
    FireEvent("RefreshHeroRed", tid)
  elseif ed.heroDetailManager:getShardUnlockItems()[tid] then
    FireEvent("RefreshHeroRed", tid)
  end
  if ed.readequip.value(tid, "Consume Type") == "\231\154\174\232\130\164" and (not param or not param.noFashionPop) then
    local fashinId = ed.readequip.value(tid, "Fashion ID")
    if fashinId and fashinId ~= 0 then
      local heroId = ed.getDataTable("Fashion")[fashinId]["Hero ID"]
      ed.announce({
        type = "popHeroFashion",
        param = {
          id = heroId,
          fashion_id = fashinId,
          hero_before_fashion = ed.player:getHero(heroId),
          priority = -205,
          callback = nil
        }
      })
    end
  end
  FireEvent("ResourceNumChange", "item", tid)
end

function Player:addItem(t, array, id, amount)
  local maxAmount = self:getItemMaxAmount(id)
  t[id] = math.min(maxAmount, (t[id] or 0) + amount)
  for i, v in ipairs(array) do
    if id == v._id then
      v._amount = t[id]
      return
    end
  end
  table.insert(array, 1, {_id = id, _amount = amount})
end

function Player:gmAddEquip(tidOrName, amount)
  local id = ed.lookupDataTable("equip", "Item_ID", tidOrName)
  local ret = self:addEquip(id, amount)
  local msg = ed.upmsg.gm_cmd()
  msg._set_items = {
    {_amount = amount, _id = id}
  }
  ed.send(msg, "gm_cmd")
end

function Player:consumeEquip(id, amount, insid)
  amount = amount or 1
  if insid then
    self:consumeItemInPackage(id, amount, insid)
  else
    if not ed.player.equip_qunty[id] then
      return
    end
    if amount <= (ed.player.equip_qunty[id] or 0) then
      ed.player.equip_qunty[id] = ed.player.equip_qunty[id] - amount
    else
      print("Not Enough equip to consume! Input:", id, amount, insid)
    end
    if ed.readequip.value(id, "Category") == T("\231\129\181\233\173\130\231\159\179") then
      FireEvent("RefreshHeroRed", id)
    elseif ed.heroDetailManager:getShardUnlockItems()[id] then
      FireEvent("RefreshHeroRed", id)
    end
    self:consumeItemInPackage(id, amount)
    self:setItemAt(id)
  end
  FireEvent("ResourceNumChange", "item", id)
end

function Player:setEquipAmount(id, amount, insid)
  if not self.equip_qunty[id] then
    return
  end
  amount = math.max(amount, 0)
  self.equip_qunty[id] = amount
  self:setItemAt(id)
end

function Player:refreshEquipOrder(id, isAdd)
  if isAdd then
    local isExist = false
    for i = 1, #self.equip_order do
      if self.equip_order[i] == id then
        isExist = true
        break
      end
    end
    if not isExist then
      table.insert(self.equip_order, 1, id)
    end
  elseif self.equip_qunty[id] == 0 or not self.equip_qunty[id] then
    local lave_equip = {}
    for i = 1, #self.equip_order do
      if self.equip_order[i] ~= id then
        table.insert(lave_equip, self.equip_order[i])
      end
    end
    self.equip_order = lave_equip
  end
end

function Player:setItemsExpire(expiredItemHistory)
  if expiredItemHistory then
    self.expireItemList = expiredItemHistory._items or {}
    self.expireTimelyItemList = expiredItemHistory._timely_items or {}
  end
end

function Player:getItemsExpire()
  return self.expireItemList or {}
end

function Player:getTimelyItemsExpire()
  return self.expireTimelyItemList or {}
end

function Player:getExpireTimeHash()
  return self.expire_time_hash or {}
end

function Player:getItemMaxAmount(id, type)
  if type then
    return self:getPointMaxAmount(type)
  end
  local row = ed.getDataTable("equip")[id]
  if not row then
    return 1
  end
  return row["Max Amount"]
end

function Player:hasMaxAmount(id)
  return self:getItemMaxAmount(id) <= self:getEquipAmount(id)
end

function Player:getPointMaxAmount(name)
  if not self.POINTS_MAX_AMOUNT then
    self.POINTS_MAX_AMOUNT = {}
    local pointTb = ed.getDataTable("Token")
    for k, v in pairs(pointTb) do
      self.POINTS_MAX_AMOUNT[string.lower(k)] = v["Max Amount"]
    end
  end
  return self.POINTS_MAX_AMOUNT[string.lower(name)] or math.huge
end

function Player:checkItemVisible(itemId)
  local hadCount = self:getEquipAmount(itemId)
  local row = ed.getDataTable("equip")[itemId]
  if not row then
    return
  end
  local maxCount = self:getItemMaxAmount(itemId)
  local maxCountInvisible = row["Max Amount Invisible"]
  return not maxCountInvisible or not (hadCount >= maxCount)
end

function Player:initNativeTimeDiff(serverTime)
  serverTime = serverTime or 0
  local time = ed.getSystemTime()
  self.time_diff = serverTime - time
  if serverTime == 0 then
    self.time_diff = 0
  end
end

function Player:setEnableStages(data)
  self.enableStages = data._opened_act_stage
  self.enableStagesLeftTimes = data._user_left_time
  self.reqEnableStagesTime = ed.getServerTime()
end

function Player:needReqEnableStages()
  if self.reqEnableStagesTime then
    return ed.checkTwoDateod(self.reqEnableStagesTime, ed.getServerTime())
  else
    return true
  end
end

function Player:getEnableStages()
  return self.enableStages, self.enableStagesLeftTimes
end

function Player:isStageEnable(stage)
  return ed.isElementInTable(stage, self.enableStages)
end

function Player:setItems(items)
  self._items = items
  self.equip_order = {}
  self.equip_qunty = {}
  if self._items then
    for k, v in pairs(self._items) do
      local item = self:getItemAt(k)
      table.insert(self.equip_order, item._id)
      self.equip_qunty[item._id] = item._amount
    end
  end
end

function Player:unLockPet()
  local trgid = 2001
  local isCom = ed.taskData:checkTriggers(trgid)
  return isCom
end

function Player:addRewards(rewards, closeCallback)
  for i = 1, #rewards do
    local reward = rewards[i]
    local type = string.lower(reward._type)
    if type == "money" or type == "gold" then
      ed.player:addMoney(reward._amount)
    elseif type == "diamond" or type == "rmb" then
      ed.player:addrmb(reward._amount)
    elseif type == "pay_diamond" then
      ed.player:addPayrmb(reward._amount)
    elseif type == "hero" then
      ed.player:addHero(reward._id)
      ed.ui.SummonRewardCardWindow.create({
        rewards = {
          {
            id = reward._id,
            amount = 1,
            type = "hero"
          }
        },
        noRewards = true,
        closeCallback = closeCallback
      }):popWindow()
    elseif type == "vitality" then
      ed.player:addVitality(reward._amount)
    elseif type == "item" then
      ed.player:addEquip(reward._id, reward._amount)
    elseif type == "playerexp" then
      local preLevel = ed.player:getLevel()
      ed.player:addExp(reward._amount, "task")
    elseif type == "crusadepoint" then
      ed.player:addCrusadeMoney(reward._amount)
    elseif type == "arenapoint" then
      ed.player:addPvpMoney(reward._amount)
    elseif type == "guildpoint" then
      ed.player:addGuildMoney(reward._amount)
    elseif type == "honourpoint" then
      ed.player:addTopPvpMoney(reward._amount)
    elseif type == "gvgpoint" then
      ed.player:addPoint("gvgpoint", reward._amount or 0)
    elseif type == "dreampoint" then
      ed.player:addPoint("dreampoint", reward._amount or 0)
    elseif type == "gcwpoint" then
      ed.player:addPoint("gcwpoint", reward._amount or 0)
    elseif type == "wood" then
      ed.player:addPoint("wood", reward._amount or 0)
    elseif type == "iron" then
      ed.player:addPoint("iron", reward._amount or 0)
    elseif type == "crystal" then
      ed.player:addPoint("crystal", reward._amount or 0)
    elseif type == "legend_point" then
      ed.player:addLegendPoint(reward._amount)
    elseif type == "star_point" then
      ed.player:addStarPoint(reward._amount)
    elseif type == "magicstone" then
      self:addMagicStone(reward._id, reward._amount)
    elseif type == "raid_point" then
      ed.player:addPoint("raid_point", reward._amount or 0)
    elseif type == "legend_equip" then
    end
  end
end

function Player:addMagicStone(id, amount)
  print(string.format("Player Add MagicStone, Id: %d, Amount: %d", id, amount))
end

function Player:canGetNextSnowManReward(canGet)
  if nil ~= canGet then
    self.nextSnowManReward = canGet
  end
  local can = self.nextSnowManReward
  if nil == can then
    can = true
  end
  return can
end

function Player:updateCampLevel(campId, level)
  if self._camps then
    local isFound = false
    for i, v in ipairs(self._camps) do
      if v._id == campId then
        v._level = level
        isFound = true
        break
      end
    end
    if not isFound then
      table.insert(self._camps, {_id = campId, _level = level})
    end
  end
end

function Player:getBattleBonus()
  return nil
end

function Player:getMagicStonePlans()
  return self._magicstone_plans or {}
end

function Player:setMagicStonePlans(plans)
  self._magicstone_plans = plans
end

function Player:setDailyVitality(tab)
  tab = tab[".data"] or tab
  self._daily_vitality = self._daily_vitality or {}
  self._daily_vitality._lunch_received = tab._lunch_received or 0
  self._daily_vitality._dinner_received = tab._dinner_received or 0
  self._daily_vitality._next_refresh_time = tab._next_refresh_time or self._daily_vitality._next_refresh_time
end

function Player:getDailyVitality()
  self._daily_vitality = self._daily_vitality or {}
  self._daily_vitality = self._daily_vitality[".data"] or self._daily_vitality
  local time = ed.getServerTime()
  if time >= self._daily_vitality._next_refresh_time then
    local day = time - self._daily_vitality._next_refresh_time
    day = math.ceil(day / 86400)
    self:setDailyVitality({
      _lunch_received = 0,
      _dinner_received = 0,
      _next_refresh_time = self._daily_vitality._next_refresh_time + 86400 * day
    })
  end
  return {
    lunchReceived = self._daily_vitality._lunch_received or 0,
    dinnerReceived = self._daily_vitality._dinner_received or 0,
    nextRefreshTime = self._daily_vitality._next_refresh_time or 0
  }
end

function Player:getDailyVitalityRed()
  local tabs = self:getDailyVitality() or {}
  local table = ed.getDataTable("Vitality") or {}
  local time = ed.getFitServerTime()
  local state = ed.player:getPayMonthCardState() or "LOCKED"
  local cardState = state ~= "CanGet" and state ~= "LOCKED"
  local endDiamond = ed.getTimeByTodayHMSWithServer("05:00:00")
  if time > endDiamond then
    endDiamond = endDiamond + 86400
  end
  
  local function func(data)
    local startTime = ed.getTimeByTodayHMSWithServer(data["Start Time"])
    local overTime = ed.getTimeByTodayHMSWithServer(data["Over Time"])
    return startTime <= time and overTime >= time or cardState and endDiamond >= time and overTime <= time
  end
  
  local lunchFree, dinnerFree = false, false
  if tabs.lunchReceived == 0 and table.Lunch then
    lunchFree = func(table.Lunch)
  end
  if tabs.dinnerReceived == 0 and table.Dinner then
    dinnerFree = func(table.Dinner)
  end
  return {lunchFree = lunchFree, dinnerFree = dinnerFree}
end
