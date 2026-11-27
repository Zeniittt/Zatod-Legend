local SoloRankManager = {}
SoloRankManager.__index = SoloRankManager

function SoloRankManager.getInstance()
  if not SoloRankManager.instance then
    SoloRankManager.instance = SoloRankManager.create()
  end
  return SoloRankManager.instance
end

function SoloRankManager.create()
  local self = {unlimitedSeasonId = 1001}
  setmetatable(self, SoloRankManager)
  self:initData()
  self:registerEvents()
  return self
end

function SoloRankManager:isOpen()
  return true
end

function SoloRankManager:isDebug()
  return false
end

function SoloRankManager:initData()
  self.config = {
    LabelRewardTitleColor = ccc3(232, 194, 119),
    LabelRewardCommonColor = ccc3(244, 235, 206)
  }
  self.rankDataReadyFlag = false
  self.rankScore = 0
  self.weeklyRewardOpened = 0
  self.weeklyRewardProgress = 0
  self.weeklyRewardTarget = 0
  self.gradeRewardOpenedList = {}
  self.scoreDiff = 0
  self.oldRankScore = nil
end

function SoloRankManager:registerEvents()
  ListenEvent("AutoChessTookWeeklyRewards", function(rewards)
    ed.player:addRewards(rewards)
    self:onWeeklyRewardOpened(rewards)
  end)
  ListenEvent("SoloTookGradeRewards", function(gradeId, rewards)
    ed.player:addRewards(rewards)
    self:onGradeRewardOpened(gradeId, rewards)
    FireEvent("AutoChessRankGradeListRefresh", gradeId, rewards)
  end)
end

function SoloRankManager:onWeeklyRewardOpened(rewards)
  self.weeklyRewardOpened = 1
end

function SoloRankManager:onGradeRewardOpened(gradeId, rewards)
  table.insert(self.gradeRewardOpenedList, gradeId)
end

function SoloRankManager:getConfig(key)
  return self.config[key]
end

function SoloRankManager:isRankDataReady()
  return self.rankDataReadyFlag
end

function SoloRankManager:isAtResting()
  local currentSeasonInfo = self:getCurrentSeasonInfo()
  if not currentSeasonInfo then
    return true
  elseif currentSeasonInfo.id == self.unlimitedSeasonId then
    return true
  end
  return false
end

function SoloRankManager:handleOpenPanel(data)
  self.rankScore = data._score
  self.weeklyRewardOpened = data._weekly_reward_flag or 0
  self.weeklyRewardProgress = data._weekly_task_progress or 0
  self.weeklyRewardTarget = data._weekly_task_target or 0
  self.gradeRewardOpenedList = data._grade_reward_flags or {}
  self.rankDataReadyFlag = true
  FireEvent("RankDataReady")
end

function SoloRankManager:hasScoreDiff()
  print("hasScoreDiff", self.scoreDiff)
  return self.scoreDiff ~= 0
end

function SoloRankManager:setScoreDiff(scoreDiff)
  if self:isDebug() then
    print("--setScoreDiff", scoreDiff)
  end
  self.scoreDiff = scoreDiff
end

function SoloRankManager:getScoreDiff()
  local scoreDiff = self.scoreDiff
  if self:isDebug() then
    print("--getScoreDiff", scoreDiff)
  end
  self.scoreDiff = 0
  return scoreDiff
end

function SoloRankManager:getMyRankGradeStars()
  return self:getRankGradeStarsByScore(self:getMyRankScore())
end

function SoloRankManager:setMyRankScore(score, delay)
  self.oldRankScore = self.rankScore
  self.rankScore = score
  FireEvent("MyRankScoreChanged", delay)
end

function SoloRankManager:getMyRankScore()
  if self:isDebug() then
    print("--getMyRankScore--", self.rankScore)
  end
  return self.rankScore
end

function SoloRankManager:getMyOldRankScore()
  return self.oldRankScore ~= nil and self.oldRankScore or self.rankScore
end

function SoloRankManager:getRewardItemName(id, type)
  if type == "Item" then
    local t = ed.getDataTable("equip")
    return t[id].Name
  end
  if type == "Diamond" then
    return T("\233\146\187\231\159\179")
  end
  return T("\230\156\170\231\159\165\231\137\169\229\147\129")
end

function SoloRankManager:getTimeInfo(str)
  local y, m, d, h, mi, s = string.match(str, "(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")
  return {
    year = tonumber(y),
    month = tonumber(m),
    day = tonumber(d),
    hour = tonumber(h),
    minute = tonumber(mi),
    second = tonumber(s)
  }
end

function SoloRankManager:getTimeWei(timeInfo)
  return self:getTimestamp(timeInfo)
end

function SoloRankManager:getTimestamp(t)
  local ts = os.time({
    year = t.year,
    month = t.month,
    day = t.day,
    hour = t.hour,
    min = t.minute,
    sec = t.second
  })
  return ts
end

function SoloRankManager:getTimestampByStr(str)
  local timeInfo = self:getTimeInfo(str)
  local timestamp = self:getTimeWei(timeInfo)
  return timestamp
end

function SoloRankManager:readRewards(v, pre)
  pre = pre or ""
  local list = {}
  for i = 1, 5 do
    local id = v[pre .. "Reward ID" .. i]
    local type = v[pre .. "Reward Type" .. i]
    local amount = v[pre .. "Reward Amount" .. i]
    if type then
      local name = self:getRewardItemName(id, type)
      table.insert(list, {
        id = id,
        type = type,
        amount = amount,
        name = name
      })
    end
  end
  return list
end

function SoloRankManager:getCurrentSeasonInfo()
  local infoList = {}
  local t = ed.getDataTable("ChessSeason")
  for id, v in pairs(t) do
    if type(v) == "table" then
      local startTime = ed.getTimeByYMDHMS(v["Start Time"])
      local endTime = ed.getTimeByYMDHMS(v["End Time"])
      local id = v["Season ID"]
      local info = {
        id = id,
        name = v["Season Name"],
        startTime = v["Start Time"],
        endTime = v["End Time"],
        rewardGrade = v["Season Reward Grade"],
        rewards = self:readRewards(v, "Season "),
        startTimeWei = startTime,
        endTimeWei = endTime or ed.getFitServerTime()
      }
      if startTime <= ed.getFitServerTime() and endTime >= ed.getFitServerTime() then
        return info
      end
      infoList[id] = info
    end
  end
  return infoList[self.unlimitedSeasonId]
end

function SoloRankManager:getRemainingTimeToCurrentSeasonEnd()
  local info = self:getCurrentSeasonInfo()
  local endTimeTimestamp = info.endTimeWei
  local nowTimestamp = ed.getFitServerTime()
  local diff = math.max(endTimeTimestamp - nowTimestamp, 0)
  local secondsOfADay = 86400
  if diff > secondsOfADay then
    local days = math.floor(diff / secondsOfADay)
    return string.format(T(" %d \229\164\169"), days)
  else
    local hours = math.ceil(diff / 3600)
    return string.format(T(" %d \229\176\143\230\151\182"), hours)
  end
end

function SoloRankManager:getWeeklyRewards()
  local list = {}
  local t = ed.getDataTable("ChessWeeklyReward")
  for time, v in pairs(t) do
    if type(v) == "table" then
      local timeInfo = self:getTimeInfo(time)
      local timeWei = self:getTimeWei(timeInfo)
      table.insert(list, {
        timeWei = timeWei,
        rewards = self:readRewards(v)
      })
    end
  end
  table.sort(list, function(e1, e2)
    return e1.timeWei < e2.timeWei
  end)
  local now = ed.getYMDHMS()
  local nowWei = self:getTimeWei(now)
  for i = #list, 1, -1 do
    local item = list[i]
    if nowWei > item.timeWei then
      return item.rewards
    end
  end
  return nil
end

function SoloRankManager:getSeasonRewardTargetGradeName()
  local seasonInfo = self:getCurrentSeasonInfo()
  local rewardGrade = seasonInfo.rewardGrade
  local gradeInfo = self:getRankGradeInfoByGradeId(rewardGrade)
  return gradeInfo and gradeInfo.name
end

function SoloRankManager:getRankGradeInfoList()
  local list = {}
  local t = ed.getDataTable("ChessGrade")
  for grade, v in pairs(t) do
    if type(v) == "table" then
      local item = {
        id = v["Player Grade"],
        name = v["Grade Name"],
        minScore = v["Current Grade Score"],
        maxScore = v["Current Grade Score"] + v["Score to Next"] - 1,
        gradeIcon = v["Grade Icon"] or "UI/alpha/1080P/chess/season/1.png",
        levelIcon = v["Level Icon"],
        iconRes = v["Grade Icon"] or "UI/alpha/1080P/chess/season/1.png",
        smallIconRes = v["Grade Icon Small"] or "UI/alpha/1080P/chess/season/1_1.png",
        canLoseScore = v["Can Lose Score"]
      }
      item.level = self:getRankGradeLevel(item)
      table.insert(list, item)
    end
  end
  table.sort(list, function(e1, e2)
    return e1.id < e2.id
  end)
  for i = 1, #list do
    local it = list[i]
    it.index = i
    it.isMaxGrade = i == #list
    it.stars = it.isMaxGrade and 0 or it.maxScore - it.minScore + 1
  end
  return list
end

function SoloRankManager:hasGradeRewardsNotBeTaken()
  local myId = self:getMyRankGradeInfo().id
  local list = self:getRankGradeInfoList()
  for k, v in ipairs(list) do
    local gradeId = v.id
    if myId >= gradeId and not self:isGradeRewardOpened(gradeId) then
      return true
    end
  end
  return false
end

function SoloRankManager:getGradeChestFcaResByGradeId(gradeId)
  local function getResSuf(gradeId)
    if gradeId <= 12 then
      local e = gradeId % 3
      
      if e == 1 then
        return "gold"
      else
        return "silver"
      end
    elseif gradeId == 13 or gradeId == 14 then
      return "gold"
    end
  end
  
  local suf = getResSuf(gradeId)
  return string.format("eff_UI_box_%s", suf), string.format("UI/alpha/HVGA/crusade/crusade_box_%s_closed.png", suf)
end

function SoloRankManager:getRankGradeRewardsOfCurrrentSeason(gradeId)
  local seasonInfo = self:getCurrentSeasonInfo()
  return self:getRankGradeRewards(seasonInfo.id, gradeId)
end

function SoloRankManager:getRankGradeRewards(seasonId, gradeId)
  local t = ed.getDataTable("ChessGradeReward")
  local v = t[seasonId][gradeId]
  local rewards = self:readRewards(v)
  local isChest = v["Is Chest"]
  return rewards, isChest
end

function SoloRankManager:getRankGradeLevel(item)
  local id = item.id
  if id <= 12 then
    return (id - 1) % 3 + 1
  else
    return 1
  end
end

function SoloRankManager:getRankGradeInfoByGradeId(gradeId)
  local list = self:getRankGradeInfoList()
  for k, v in pairs(list) do
    if v.id == gradeId then
      return v
    end
  end
  return nil
end

function SoloRankManager:getRankGradeInfoByScore(score)
  local list = self:getRankGradeInfoList()
  for i = #list, 1, -1 do
    local v = list[i]
    if score >= v.minScore then
      return v
    end
  end
  return nil
end

function SoloRankManager:getRankGradeStarsByScore(score)
  local info = self:getRankGradeInfoByScore(score)
  if info.isMaxGrade then
    return 0
  end
  if score > info.maxScore then
    return info.maxScore - info.minScore + 1
  end
  local stars = score - info.minScore + 1
  return stars
end

function SoloRankManager:getNewRankScore(score, scoreDiff)
  local info = self:getRankGradeInfoByScore(score)
  if scoreDiff < 0 then
    if not info.canLoseScore then
      scoreDiff = 0
    end
    local r = score + scoreDiff
    return r >= info.minScore and r or info.minScore
  end
  local index = info.index
  local list = self:getRankGradeInfoList()
  local gradeChange = false
  while true do
    if info.isMaxGrade then
      return score + scoreDiff
    end
    if score + scoreDiff <= info.maxScore then
      return score + scoreDiff
    end
    local d = info.maxScore - score + 1
    scoreDiff = scoreDiff - d
    index = index + 1
    info = list[index]
    score = info.minScore
    gradeChange = true
  end
end

function SoloRankManager:isGradeRewardOpened(gradeId)
  return ed.isElementInTable(gradeId, self.gradeRewardOpenedList)
end

function SoloRankManager:isWeeklyRewardOpened()
  local isOpened = self.weeklyRewardOpened == 1
  return isOpened
end

function SoloRankManager:canOpenWeeklyReward()
  local progress = self:getWeeklyRewardProgress()
  local target = self:getWeeklyRewardTarget()
  if target == 0 then
    return false
  end
  return progress >= target
end

function SoloRankManager:getWeeklyRewardProgress()
  local progress = self.weeklyRewardProgress
  return progress
end

function SoloRankManager:increaseWeeklyRewardProgress()
  if self.weeklyRewardProgress >= self.weeklyRewardTarget then
    return
  end
  self.weeklyRewardProgress = self.weeklyRewardProgress + 1
end

function SoloRankManager:getRewardOpenedGradeIdList()
  local list = self.gradeRewardOpenedList
  return list
end

function SoloRankManager:getWeeklyRewardTarget()
  local target = self.weeklyRewardTarget
  return target
end

function SoloRankManager:getMyRankGradeInfo()
  local score = self:getMyRankScore()
  local info = self:getRankGradeInfoByScore(score)
  return info
end

function SoloRankManager:getMyRankGradeName()
  local info = self:getMyRankGradeInfo()
  return info.name
end

function SoloRankManager:getDayOfWeek(timestamp)
  local ws = os.date("%w", timestamp)
  local w = tonumber(ws)
  if w == 0 then
    w = 7
  end
  return w
end

function SoloRankManager:needShowGradePanelAtSeasonStart()
  local info = self:getCurrentSeasonInfo() or {}
  local unlimitedId = self.unlimitedSeasonId
  local seasonId = info.id or unlimitedId
  if seasonId == unlimitedId then
    return false
  end
  local key = string.format("chess_season_%d_%d", ed.getUserid(), seasonId)
  local defaultValue = "chess_season"
  local config = ed.ui.readconfig
  local value = config.get(key)
  config.set(key, defaultValue)
  if self:isDebug() then
    print("key", key, "value", value, "defaultValue", defaultValue)
  end
  return value ~= defaultValue
end

function SoloRankManager:getWeeklyRewardCDSeconds()
  local function getSecondsFromWeekstart(dayOfWeek, hour, minute, second)
    local ss = dayOfWeek - 1
    
    ss = ss * 24 + hour
    ss = ss * 60 + minute
    ss = ss * 60 + second
    return ss
  end
  
  local updateDayOfWeek = 1
  local updateHour = 5
  local cdSeconds = 604800
  local nowTimestamp = ed.getFitServerTime()
  local t = ed.getYMDHMS(nowTimestamp)
  local nowDayOfWeek = self:getDayOfWeek(nowTimestamp)
  local nowSecondsFromWS = getSecondsFromWeekstart(nowDayOfWeek, t.hour, t.minute, t.second)
  local updateSecondsFromWS = getSecondsFromWeekstart(updateDayOfWeek, updateHour, 0, 0)
  local diff = updateSecondsFromWS - nowSecondsFromWS
  if diff < 0 then
    diff = diff + cdSeconds
  end
  return diff
end

function SoloRankManager:getGradeIconNode(info, config)
  local container, ui = ed.editorui(ed.uieditor.AutoChessRankGradeIcon)
  ed.setTexture(ui.icon, info.iconRes)
  ed.setString(ui.label, info.name)
  return container, ui
end

function SoloRankManager:getRewardsFlyPanel(rewards, title)
  local config = {
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(200, 100)
      },
      t = "Scale9Sprite",
      base = {
        name = "bg",
        z = 0,
        res = "UI/alpha/1080P/common/mail_bj9_1.png",
        capInsets = CCRectMake(10, 10, 14, 201)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(0, 0)
      }
    },
    {
      config = {
        rotation = 0,
        scalexy = {y = 1, x = 1},
        horizontalAlignment = 0,
        flip = "",
        color = ccc3(255, 255, 255),
        opacity = 255,
        verticalAlignment = 0,
        visible = false
      },
      t = "Label",
      base = {
        name = "labelTitle",
        z = 0,
        text = T("\232\135\179\229\174\157\231\173\137\231\186\167\232\190\190\229\136\1761\233\152\182\232\167\163\233\148\129"),
        size = 16
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      }
    }
  }
  local container = CCNode:create()
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(config)
  local padding = 10
  local iconWid = 24
  local sepX = 4
  local sepY = 4
  local oy = padding
  
  local function getIcon(reward)
    local type = reward.type
    if type == "Item" then
      return ed.readequip.createIcon(reward.id, iconWid)
    elseif type == "Diamond" then
      local sprite = ed.createSprite("UI/alpha/1080P/icon/diamond.png")
      local size = sprite:getContentSize()
      sprite:setScale(iconWid / size.width)
      return sprite
    end
  end
  
  local function getText(reward)
    return string.format("%s X%d", reward.name, reward.amount)
  end
  
  local right = 0
  for i = #rewards, 1, -1 do
    local ox = padding
    local reward = rewards[i]
    local icon = getIcon(reward)
    icon:setPosition(ccp(ox + iconWid / 2, oy + iconWid / 2))
    ox = ox + iconWid + sepX
    container:addChild(icon)
    local label = ed.createLabelTTF(getText(reward), 16)
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(ox, oy + iconWid / 2))
    container:addChild(label)
    local size = label:getContentSize()
    right = math.max(right, ox + size.width)
    oy = oy + iconWid + sepY
  end
  if title then
    local ox = padding
    local label = ui.labelTitle
    ed.setString(label, title)
    label:setDimensions(CCSizeMake(right - padding, 0))
    label:setPosition(ccp(ox, oy))
    label:setVisible(true)
    local size = label:getContentSize()
    oy = oy + size.height + sepY
  end
  right = right + padding
  local top = oy - sepY + padding
  ui.bg:setPosition(ccp(right / 2, top / 2))
  ui.bg:setContentSize(CCSizeMake(right, top))
  ui.width = right
  ui.height = top
  return container, ui
end

function SoloRankManager:getPosAtCircle(cx, cy, r, rotation)
  local rad = math.rad(rotation)
  local dx = math.sin(rad) * r
  local dy = math.cos(rad) * r
  local pos = ccp(cx + dx, cy + dy)
  return pos
end

function SoloRankManager:getRotation(count, i)
  local oddrs = {
    -48,
    -24,
    0,
    24,
    48,
    72
  }
  local evenrs = {
    -60,
    -36,
    -12,
    12,
    36,
    60
  }
  local rs = count % 2 == 0 and evenrs or oddrs
  local ois = {
    3,
    3,
    2,
    2,
    1,
    1
  }
  local oi = ois[count]
  local rotation = rs[oi + i - 1]
  return rotation
end

ed.SoloRankManager = SoloRankManager.getInstance()
