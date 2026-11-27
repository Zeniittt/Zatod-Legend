local data = {}

function data:init()
  ListenEvent("refreshFinishedTask", function()
    local msgCache = {}
    local finished = ed.player:getFinishedTask()
    for k, v in pairs(finished) do
      local heroTask = ed.getDataTable("HeroTask")[v._task_line]
      if ed.roleTaskData.canTriggerTask(v._task_line, v._task_id + 1, heroTask and true or false) then
        local t = {
          id = v._task_id + 1,
          chain = v._task_line,
          isFinished = false,
          count = 0
        }
        table.insert(msgCache, t)
      end
    end
    if 0 < #msgCache then
      ed.roleTaskData:doTriggerTask(msgCache)
    end
  end)
  ListenEvent("mainSceneEnter", function()
    if not self.isInitTask then
      FireEvent("refreshFinishedTask")
      self.isInitTask = true
    end
  end)
end

function data:refreshData(data)
  return "netreplyRewards"
end

local taskList = {}
ed.roleTaskData = taskList

function taskList:refreshTaskList()
  local chainList = {}
  local finished = ed.player:getFinishedTask()
  for k, v in pairs(finished) do
    table.insert(chainList, v._task_line)
  end
  local list, msgTask = self:classifyTask(chainList)
  self:doTriggerTask(msgTask)
  return list, msgTask
end

function taskList:classifyTask(exception)
  local taskList = {}
  local msgList = {}
  exception = exception or {}
  local taskTable = ed.getDataTable("Task")
  for k, v in pairs(taskTable) do
    if k ~= "name" and not ed.isElementInTable(k, exception) then
      local t = self:getCurrentTaskInChain(k, false)
      if t then
        if t.noTrigger then
          table.insert(msgList, t)
        else
          table.insert(taskList, t)
        end
      end
    end
  end
  return taskList, msgList
end

function taskList:getCurrentTaskInChain(chain, hero)
  local tasks = ed.player:getTaskList()
  for k, v in pairs(tasks) do
    if v._line == chain then
      local isFinished = ed.isElementInTable(v._status, {"finished", 0})
      if not isFinished then
        if self.canTriggerTask(chain, v._id, hero) then
          return {
            id = v._id,
            chain = v._line,
            isFinished = isFinished,
            count = v._task_target
          }
        else
          return nil
        end
      elseif self.canTriggerTask(chain, v._id + 1, hero) then
        return {
          id = v._id + 1,
          chain = v._line,
          isFinished = false,
          count = 0,
          noTrigger = true
        }
      else
        return nil
      end
    end
  end
  if self.canTriggerTask(chain, 1, hero) and not hero then
    return {
      id = 1,
      chain = chain,
      isFinished = false,
      count = 0,
      noTrigger = true
    }
  else
    return nil
  end
end

function taskList.canTriggerTask(chain, task, hero)
  if hero then
    local herotask = ed.getDataTable("HeroTask")[chain][task]
    if herotask then
      return true
    else
      return false
    end
  else
    local task = ed.getDataTable("Task")[chain][task]
    if not task then
      return nil
    end
    local triggers = task["Trigger ID"]
    if type(triggers) == "table" then
      for k, v in pairs(triggers) do
        if type(v) == "number" and 0 < v then
          local isTrigger
          if task["Task Progress Type"] == "ShardEvolve" then
            isTrigger = ed.checkTriggers(v, {
              heroId = task["Task Progress ID"]
            })
          else
            isTrigger = ed.checkTriggers(v)
          end
          if not isTrigger then
            return false
          end
        end
      end
    end
  end
  return true
end

function taskList:doSendTrigger(msgList)
  if 0 < #msgList then
    ed.netdata.triggerTask = msgList
    ed.netreply.triggerTask = self:triggerTaskReply(msgList)
    local msg = ed.upmsg.trigger_task()
    local line_task = {}
    msg._line_task_id = line_task
    local ts = {}
    for i = 1, #msgList do
      table.insert(line_task, {
        _task_id = msgList[i].id,
        _line_id = msgList[i].chain
      })
    end
    msg._line_task_id = line_task
    ed.send(msg, "trigger_task")
  end
end

function taskList:doTriggerTask(msgList)
  self:doSendTrigger(msgList)
end

function taskList:initTaskListData(data, type)
  local tt = ed.getDataTable("Task")
  local tth = ed.getDataTable("HeroTask")
  local row
  local notInitType = {
    "invite",
    "recall",
    "Mentorship"
  }
  if ed.player:isHeroTask(data.chain) then
    row = tth[data.chain][data.id]
  elseif tt[data.chain][data.id] and tt[data.chain][data.id]["Task Type"] and ed.isElementInTable(tt[data.chain][data.id]["Task Type"], notInitType) and not type then
    return
  else
    row = tt[data.chain][data.id]
  end
  local t = {
    kind = "task",
    chain = data.chain,
    id = data.id,
    isFinished = data.isFinished,
    hid = row["Hero ID"],
    isConsume = row["Task Need Consume"],
    consumeType = row["Task Consume Type"],
    consumeID = row["Task Consume ID"],
    consumeAmount = row["Task Consume Amount"],
    consumeName = self.getItemName(row["Task Consume Type"], row["Task Consume ID"]),
    name = row["Task Name"],
    detail = row["Task Detail"],
    target = row["Task Target"],
    progress = self.getProgress(data),
    type = row["Task Progress Type"],
    goal = row["Task Goal"],
    isArtifact = row["Is Artifact"],
    oIcon = row["Show Reward Icon Only"],
    reward = {}
  }
  for i = 1, 6 do
    local type = row[string.format("Task Reward %d Type", i)]
    if type then
      t.reward[i] = {
        type = type,
        id = row[string.format("Task Reward %d ID", i)],
        amount = row[string.format("Task Reward %d Amount", i)],
        name = self.getItemName(type, row[string.format("Task Reward %d ID", i)])
      }
    end
  end
  t.isCompleted = (t.progress or 0) >= t.target
  self.jumpHeroTaskSecondStep(t)
  return t
end

function taskList.getItemName(type, id)
  if type == "Coin" then
    return T("\233\135\145\229\184\129")
  elseif type == "Diamond" then
    return T("\233\146\187\231\159\179")
  elseif type == "HonourPoint" then
    return T("\229\183\133\229\179\176\231\161\172\229\184\129")
  elseif type == "DreamPoint" then
    return T("\230\162\166\228\185\139\230\150\176\229\143\182")
  elseif type == "Vitality" then
    return T("\228\189\147\229\138\155")
  elseif type == "Item" then
    local it = ed.getDataTable("equip")
    local name = it[id]
    local name = name and name.Name or ""
    return name or ""
  elseif type == "GuildCoin" then
    return T("\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129")
  elseif type == "MonthlyCardPeriod" then
    return T("\230\156\136\229\141\161\231\164\188\229\140\133\239\188\13630\229\164\169\239\188\137")
  end
end

function taskList.getProgress(data)
  local chain = data.chain
  if not chain then
    return
  end
  local id = data.id
  if not id then
    return
  end
  local count = data.count or 0
  local row
  if ed.player:isHeroTask(chain) then
    row = ed.getDataTable("HeroTask")[chain][id]
  else
    row = ed.getDataTable("Task")[chain][id]
  end
  local type = row["Task Progress Type"]
  local pid = row["Task Progress ID"]
  local target = row["Task Target"]
  return taskList.getCount({
    chain = chain,
    id = id,
    pid = pid,
    type = type,
    count = count,
    target = target
  }) or count
end

function taskList.jumpHeroTaskSecondStep(task)
  if ed.player:canJumpHeroTaskSecondStep(task.chain, task.id) then
    for _, v in pairs(ed.player:getTaskList()) do
      if v._line == task.chain and v._status == "suspend" then
        return
      end
    end
    task.isCompleted = true
    task.progress = task.target
  end
end

function taskList:createSwitchHeroTask(task)
  if not task or not task.chain then
    return task
  end
  if not self.heroTaskNode or not self.heroTaskNode[task.chain] then
    return task
  end
  if task.id == self.heroTaskNode[task.chain].taskId then
    return task
  end
  local line = task.chain
  local id = self.heroTaskNode[task.chain].taskId
  local heroTask = ed.getDataTable("HeroTask")[line][id]
  local newTask = {
    chain = line,
    id = id,
    goal = heroTask["Task Goal"],
    target = heroTask["Task Target"],
    progress = 0,
    name = heroTask["Task Name"],
    detail = heroTask["Task Detail"],
    type = heroTask["Task Progress Type"],
    isArtifact = heroTask["Is Artifact"],
    kind = task.kind,
    isCompleted = task.isCompleted,
    isConsume = task.isConsume,
    consumID = task.consumID,
    consumeID = task.consumeID,
    reward = {}
  }
  if id > task.id then
    newTask.progress = 0
  elseif id < task.id then
    newTask.progress = newTask.target
  end
  return newTask
end

function taskList:triggerTaskReply(data)
  local function handler(result)
    local tl = ed.player:getTaskList()
    
    local finished = ed.player:getFinishedTask()
    for i = 1, #data do
      if result[i] and result[i]._result == "success" and ed.getDataTable("Task")[data[i].chain] and ed.getDataTable("Task")[data[i].chain][data[i].id] then
        for k, v in pairs(tl) do
          if v._line == data[i].chain then
            table.remove(tl, k)
            break
          end
        end
        for k, v in pairs(finished) do
          if v._task_line == data[i].chain then
            table.remove(finished, k)
            break
          end
        end
        ed.player:addTask(data[i].chain, data[i].id, result[i]._target, result[i]._item_stage)
        if not ed.player:isHeroTask(data[i].chain) then
          local row = ed.getDataTable("Task")[data[i].chain][data[i].id]
          local type = row["Task Progress Type"]
          if type == "KillMonster" then
            local pid = row["Task Progress ID"]
            for k, v in pairs(pid) do
              if v ~= 0 then
                ed.record:reset("login", "killMonster", v)
              end
            end
          elseif type == "FarmStage" then
            local pid = row["Task Progress ID"]
            for k, v in pairs(pid) do
              if v ~= 0 then
                ed.record:reset("login", "farmStage", v)
              end
            end
          end
        end
        ed.roleTaskData.failTask = ed.roleTaskData.failTask or {}
        ed.roleTaskData.failTask[data[i].chain] = ed.roleTaskData.failTask[data[i].chain] or {}
        ed.roleTaskData.failTask[data[i].chain][data[i].id] = true
      elseif result[i] and result[i]._result == "success" then
        ed.showConfirmDialog({
          text = T("error : id = %s  , chain = %s", data[i].id, data[i].chain)
        })
        ed.pt(data[i])
      else
        ed.roleTaskData.failTask = ed.roleTaskData.failTask or {}
        ed.roleTaskData.failTask[data[i].chain] = ed.roleTaskData.failTask[data[i].chain] or {}
        ed.roleTaskData.failTask[data[i].chain][data[i].id] = false
      end
    end
    FireEvent("triggerTaskReply", data)
  end
  
  return handler
end

local function swapTask(task, j)
  local temp = task[j]
  task[j] = task[j - 1]
  task[j - 1] = temp
end

function taskList:sortTask(task)
  for i = 1, #task do
    for j = i, 2, -1 do
      if task[j].info.isCompleted and not task[j - 1].info.isCompleted then
        swapTask(task, j)
      elseif task[j].info.isCompleted == task[j - 1].info.isCompleted then
        if task[j].info.chain < task[j - 1].info.chain then
          swapTask(task, j)
        elseif task[j].info.chain == task[j - 1].info.chain and task[j].info.id < task[j - 1].info.id then
          swapTask(task, j)
        end
      end
    end
  end
  return task
end

function taskList:stickSpecificTypeTask(task)
  local tl = ed.player:getTaskList()
  for i = 1, #task do
    if task[i] and task[i].info and ed.player:isHeroTask(task[i].info.chain) then
      for k, v in pairs(tl) do
        if task[i].info.chain == v._line and task[i].info.id == v._id and (tl[k]._status == "working" or tl[k]._status == "finished") then
          local typeTask = task[i]
          typeTask.info.status = tl[k]._status
          table.insert(typeTask, task[i])
          table.remove(task, i)
          table.insert(task, #task + 1, typeTask)
          return task
        end
      end
    end
  end
  return task
end

function taskList:createTaskList(taskInfo)
  taskInfo = taskInfo or {}
  if taskInfo.isFinished then
    return
  end
  local board = {info = taskInfo}
  local heroTask = ed.player:isHeroTask(taskInfo.chain)
  board.isHeroTask = heroTask
  return board
end

function taskList:orderList(tasks)
  local task = tasks or self.tasks
  self.tasks = task
  local heroTask = {}
  local heroSuperTask = {}
  local normalTask = {}
  for i = 1, #task do
    if task[i] and task[i].info and task[i].isHeroTask and not task[i].info.isArtifact then
      table.insert(heroTask, task[i])
    elseif task[i] and task[i].info and task[i].isHeroTask and task[i].info.isArtifact then
      table.insert(heroSuperTask, task[i])
    else
      table.insert(normalTask, task[i])
    end
  end
  task = normalTask
  task = self:sortTask(task)
  heroTask = self:sortTask(heroTask)
  heroSuperTask = self:sortTask(heroSuperTask)
  heroTask = self:stickSpecificTypeTask(heroTask)
  heroSuperTask = self:stickSpecificTypeTask(heroSuperTask)
  local task_working, super_task_working
  local t = heroTask[#heroTask]
  if t and t.info.status then
    task_working = t
    table.remove(heroTask, #heroTask)
  end
  local t = heroSuperTask[#heroSuperTask]
  if t and t.info.status then
    super_task_working = t
    table.remove(heroSuperTask, #heroSuperTask)
  end
  for k, v in ipairs(heroSuperTask) do
    table.insert(task, 1, v)
  end
  for k, v in ipairs(heroTask) do
    table.insert(task, 1, v)
  end
  if not super_task_working and not task_working then
    return task
  end
  if super_task_working and task_working then
    print(super_task_working.info.status, task_working.info.status)
    if super_task_working.info.status == "finished" and task_working.info.status ~= "finished" then
      table.insert(task, 1, task_working)
      table.insert(task, 1, super_task_working)
    else
      table.insert(task, 1, super_task_working)
      table.insert(task, 1, task_working)
    end
    return task
  end
  if super_task_working then
    table.insert(task, 1, super_task_working)
  end
  if task_working then
    table.insert(task, 1, task_working)
  end
  return task
end

function taskList.getCount(info)
  local chain = info.chain
  local id = info.id
  local pid = info.pid
  local type = info.type
  local target = info.target
  local count = info.count or 0
  local lastTime = info.lastTime
  local limit = info.limit or "login"
  if type == "CompleteStage" then
    for k, v in pairs(pid) do
      if v ~= 0 and 0 < ed.player:getStageStar(v) then
        return target
      end
    end
  elseif type == "FullStarPassStage" then
    for k, v in pairs(pid) do
      if v ~= 0 and ed.player:getStageStar(v) >= 3 then
        return target
      end
    end
  elseif type == "KillMonster" then
    return ed.player:getTaskCount(chain, id)
  elseif type == "ItemQuantity" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        return ed.player.equip_qunty[v] or 0
      end
    end
  elseif type == "PlayerLevel" then
    return ed.player:getLevel() or 0
  elseif type == "QuestBoardLevel" then
    return ed.player:getQuestBuildingLevel() or 0
  elseif type == "Mentorship" then
    return ed.player:getLevel() or 0
  elseif type == "HeroLevel" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        return (ed.player.heroes[v] or {})._level or 0
      end
    end
  elseif type == "HeroRank" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        return (ed.player.heroes[v] or {})._rank or 0
      end
    end
  elseif type == "MultiHeroRank" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        local index = 0
        for id, hero in pairs(ed.player.heroes) do
          if v <= hero._rank then
            index = index + 1
          end
        end
        return index
      end
    end
  elseif type == "MultiHeroLevel" then
    for k, v in pairs(pid) do
      if v ~= 0 then
        local index = 0
        for id, hero in pairs(ed.player.heroes) do
          if v < hero._level then
            index = index + 1
          end
        end
        return index
      end
    end
  elseif type == "FarmStage" then
    return ed.player:getTaskCount(chain, id)
  elseif type == "HaveGuild" then
    return 0 == ed.player:getGuildId() and 0 or 1
  elseif type == "EquipItem" or type == "FarmStageWith" or type == "FarmStageNoDie" or type == "FarmStageAlone" or type == "FarmStageDamage" or type == "FarmStageKill" then
    return ed.player:getTaskCount(chain, id)
  elseif type == "BookComplete" then
    return ed.player:getFullBookCount()
  elseif type == "SkillComplete" then
    return ed.player:getSkillLearnCnt()
  elseif type == "InviteHeroNum" then
    return ed.ui.inviteFriends:getInvitePlayerHeroNum(pid)
  elseif type == "InvitePlayer" then
    return ed.ui.inviteFriends:getInvitePlayerNum()
  elseif type == "InviteLevel" then
    return ed.ui.inviteFriends:getInvitePlayerLevel(pid)
  elseif type == "InviteVip" then
    return ed.ui.inviteFriends:getInvitePlayerVip(pid)
  elseif type == "TitanStar7" then
    local count = 0
    local tbl = ed.getDataTable("TitanToHeros")
    for id, info in pairs(tbl) do
      if id ~= "name" and tonumber(id) and 0 ~= info.MatrixHeroID1 then
        local unitInfo = ed.getDataTable("Unit")[id]
        local hero = ed.player:getHero(id)
        if hero and hero._stars >= 7 and unitInfo["Hero Pay Type"] == "Free" then
          count = count + 1
        end
      end
    end
    return count
  elseif type == "Titan98Star8" then
    local count = 0
    local tbl = ed.getDataTable("TitanToHeros")
    for id, info in pairs(tbl) do
      if id ~= "name" and tonumber(id) then
        local unitInfo = ed.getDataTable("Unit")[id]
        local hero = ed.player:getHero(id)
        if hero and hero._stars >= 8 and unitInfo["Hero Pay Type"] == "98" then
          count = count + 1
        end
      end
    end
    return count
  elseif type == "BookReadingLevel" then
    local readingLevel = 0
    return readingLevel
  elseif type == "SkillEvolve" then
    local function initSkill(hero)
      local hid = hero._tid
      
      local skill = {}
      local allSkillInfo = ed.getDataTable("Skill")
      local skills = ed.getSkillExpBase(hid)
      for i = 1, #skills do
        skill[i] = {
          rank = skills[i].Unlock,
          olderSlot = skills[i].Slot,
          groupID = skills[i]["Skill Group ID"]
        }
      end
      table.sort(skill, function(a, b)
        return a.olderSlot < b.olderSlot
      end)
      return skill
    end
    
    for k, v in pairs(pid) do
      if v ~= 0 then
        local index = 0
        for id, hero in pairs(ed.player.heroes) do
          local skill = initSkill(hero)
          for s = 1, 4 do
            if hero._rank >= skill[s].rank then
              local info = ed.getDataTable("SkillEvo")[skill[s].groupID]
              if info and hero._skill_levels[s] >= ((info[v] or {})["EvoSkill UnlockLevel"] or 999) then
                index = index + 1
              end
            else
              break
            end
          end
        end
        return index
      end
    end
    return 0
  elseif type == "ShardEvolve" then
    local hero = ed.player:getHero(pid[1])
    if not hero then
      return 0
    end
    local info = hero.data or {}
    if hero and hero.data and hero.data._shard then
      return hero.data._shard._level
    end
    return 0
  elseif type == "AstrolabeIsOn" then
    if ed.heroDetailManager.astrolabes[pid[1]] and ed.heroDetailManager.astrolabes[pid[1]]._unlock and ed.heroDetailManager.astrolabes[pid[1]]._unlock == 1 then
      return 1
    end
    return 0
  else
    return ed.player:getTaskCount(chain, id)
  end
  return count
end

function data.getProgressRole(data)
  local chain = data.chain
  if not chain then
    return
  end
  local id = data.id
  local count = data.count or 0
  local row
  if ed.player:isHeroTask(chain) then
    row = ed.getDataTable("HeroTask")[chain][id]
  else
    local tasks = ed.getDataTable("Task")
    tasks = tasks[chain] or {}
    tasks = tasks[id] or 0
    row = tasks
  end
  if type(row) ~= "table" then
    return false
  end
  local type = row["Task Progress Type"]
  local pid = row["Task Progress ID"]
  local target = row["Task Target"]
  return taskList.getCount({
    chain = chain,
    id = id,
    pid = pid,
    type = type,
    count = count,
    target = target
  }) or count
end

function data:isTaskCompleted(task)
  local t = {
    chain = task._line,
    id = task._id,
    count = task._task_target,
    status = task._status
  }
  local progress = self.getProgressRole(t)
  if progress then
    local target
    if ed.player:isHeroTask(task._line) then
      target = ed.getDataTable("HeroTask")[task._line][task._id]["Task Target"]
    else
      target = ed.getDataTable("Task")[task._line][task._id]["Task Target"]
    end
    return progress >= target and ed.isElementInTable(t.status, {"working", 1})
  else
    return false
  end
end

function data:setRed()
  self.reds = 1
end

function data:getred()
  local tasks = ed.player:getTaskList()
  local num = 0
  for k, v in pairs(tasks) do
    if v._line and self:isTaskCompleted(v) then
      num = num + 1
    end
  end
  self.reds = num
  return self.reds or 0
end

local function create()
  local object = {}
  setmetatable(object, {__index = data})
  object:init()
  return object
end

return create()
