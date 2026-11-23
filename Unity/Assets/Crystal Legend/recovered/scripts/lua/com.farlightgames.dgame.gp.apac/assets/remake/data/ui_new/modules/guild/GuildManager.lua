local GuildManager = {}
GuildManager.__index = GuildManager
local instance
GuildManager.guildJoinType = {
  T("\231\171\139\229\141\179\229\138\160\229\133\165"),
  T("\231\148\179\232\175\183\229\138\160\229\133\165"),
  T("\231\166\129\230\173\162\229\138\160\229\133\165"),
  T("\232\129\148\231\179\187\228\188\154\233\149\191")
}
GuildManager.joinGuildFial = {
  join_guild_cd = T("\230\151\160\230\179\149\229\156\168\233\128\128\229\135\186\229\133\172\228\188\154\229\144\1421\229\176\143\230\151\182\229\134\133\229\138\160\229\133\165\228\187\187\228\189\149\229\133\172\228\188\154\239\188\140\229\134\141\232\191\135%s\229\136\134\233\146\159\229\144\142\229\141\179\229\143\175\228\187\165\229\138\160\229\133\165\230\173\164\229\133\172\228\188\154"),
  join_same_guild_cd = T("\230\151\160\230\179\149\229\156\168\233\128\128\229\135\186\229\133\172\228\188\154\229\144\14248\229\176\143\230\151\182\229\134\133\229\155\158\229\136\176\229\142\159\229\133\172\228\188\154\239\188\140\229\134\141\232\191\135%s\229\144\142\229\141\179\229\143\175\228\187\165\229\138\160\229\133\165\230\173\164\229\133\172\228\188\154"),
  join_guild_week_cd = T("\230\175\143\229\145\168\229\143\170\232\131\189\229\138\160\229\133\1654\230\172\161\229\133\172\228\188\154\239\188\136\229\145\168\228\184\128\230\151\169\228\184\1385\231\130\185\233\135\141\231\189\174\239\188\137\239\188\140\229\134\141\232\191\135%s\229\144\142\229\141\179\229\143\175\228\187\165\229\138\160\229\133\165\230\173\164\229\133\172\228\188\154")
}
GuildManager.guildType = {
  no_verify = T("\230\137\128\230\156\137\228\186\186\233\131\189\229\143\175\228\187\165\229\138\160\229\133\165"),
  verify = T("\233\156\128\232\166\129\233\170\140\232\175\129\230\137\141\229\143\175\229\138\160\229\133\165"),
  closed = T("\228\184\141\232\131\189\229\138\160\229\133\165")
}
GuildManager.MecrenaryType = {
  cHired = "cHired",
  bHired = "bHired",
  bLevel = "bLevel"
}
GuildManager.guildRecruitNotify = 0

function GuildManager.getInstance()
  if not instance then
    instance = GuildManager.create()
  end
  return instance
end

function GuildManager.create()
  local self = {}
  setmetatable(self, GuildManager)
  self:initData()
  return self
end

function GuildManager.isDebug()
  return false
end

function GuildManager:initData()
  self.maxMember = 50
  self.selfJob = "member"
  self.selfJob = ed.player:getGuildJob() or "member"
  self.createGuildCost = 500
  self.avatar = 1
  self.frame = 1
  self.name = ""
  self.curWorshipTime = 0
  self.allMercenary = {}
  self.selfMercenary = {}
  self.mercenaryHeros = {}
  self.maxMercenarys = 2
  self.curMercenarys = 0
  self.unlockIconAvatars = {1}
  self.unlockIconFrames = {1}
  self.passedInstanceIds = {}
  self.openInstanceInfo = {}
  self.worshipGold = 0
end

function GuildManager:handleSearchGuildToJoinReply(data)
  self.createGuildCost = data._create_cost
  self.guilds = {}
  for k, v in ipairs(data._guilds or {}) do
    local item = {
      id = v._id,
      name = v._name,
      avatar = v._avatar,
      slogan = v._slogan,
      joinType = v._join_type,
      joinLimit = v._join_limit,
      memberCnt = v._member_cnt,
      president = v._president,
      liveness = v._liveness or 0,
      recruitItem = v._recruit_item
    }
    if v._recruit_item and v._recruit_item._recruit_declare then
      item.slogan = v._recruit_item._recruit_declare
    end
    table.insert(self.guilds, item)
  end
  if data._is_in_guild ~= 1 then
    ed.player:setGuildId(0)
  end
  ed.pushScene(ed.ui.GuildJoinScene.create(data))
end

function GuildManager:initGuildData(guildInfo)
  ed.player.currentVitality = guildInfo._liveness
  ed.player:setGuildId(guildInfo._summary._id)
  ed.player:setGuildName(guildInfo._summary._name)
  self.lastSetNameTime = 0
  self.summary = guildInfo._summary
  self.guildId = self.summary._id
  self.name = self.summary._name
  local avatarData = ed.analyzeAvatar(self.summary._avatar)
  self.avatar = avatarData.avatar
  self.frame = avatarData.avatarFrame
  self.slogan = self.summary._slogan
  self.joinType = self.summary._join_type
  self.joinLimit = self.summary._join_limit
  self.memberCnt = self.summary._member_cnt
  self.president = self.summary._president
  self.liveness = self.summary._liveness or 0
  local recruitItems = self.summary._recruit_item or {}
  self.recruitDetail = recruitItems._recruit_declare
  self.members = guildInfo._members
  self.appliers = guildInfo._appliers
  self.selfVitality = guildInfo._self_liveness
  self.vitality = guildInfo._liveness
  self.active = 0
  for i = 1, #self.members do
    local member = self.members[i]
    if member._summary._uid == ed.getUserid() then
      self.selfActive = member._active
      ed.player:setGuildJob(member._job)
      self.selfGs = member._full_gs
    end
  end
  self:sortGuildMember()
end

function GuildManager:sortGuildMember()
  local jobPriority = {
    chairman = 3,
    elder = 2,
    member = 1
  }
  table.sort(self.members, function(a, b)
    if a._job == b._job then
      if a._is_online == b._is_online then
        return a._full_gs > b._full_gs
      else
        return a._is_online > b._is_online
      end
    else
      return jobPriority[a._job] > jobPriority[b._job]
    end
  end)
end

function GuildManager:onClickQuit()
  local txt = T("\233\128\128\229\135\186\229\133\172\228\188\154\229\144\1421\229\176\143\230\151\182\229\134\133\230\151\160\230\179\149\229\138\160\229\133\165\228\187\187\228\189\149\229\133\172\228\188\154\239\188\14048\229\176\143\230\151\182\229\134\133\230\151\160\230\179\149\229\155\158\229\136\176\229\142\159\229\133\172\228\188\154\239\188\140\229\144\140\230\151\182\228\184\128\229\145\168\229\134\133\229\143\170\232\131\189\229\138\160\229\133\1654\230\172\161\229\133\172\228\188\154\239\188\140\230\152\175\229\144\166\233\128\128\229\135\186\239\188\159")
  local guildleftdays = ed.player:getMonthCardLeftTimes(ed.parameter.guild_month_card)
  if 0 < guildleftdays then
    txt = T("\229\166\130\230\158\156\233\128\128\229\135\186\229\133\172\228\188\154\229\176\134\228\184\141\232\131\189\231\187\167\231\187\173\228\189\191\231\148\168\229\137\169\228\189\153\231\154\132%d\229\164\169\229\133\172\228\188\154\230\156\136\229\141\161\227\128\130", guildleftdays) .. txt
  end
  
  local function secondConfirm()
    local info = {
      text = T("\230\152\175\229\144\166\231\161\174\232\174\164\233\128\128\229\135\186\229\133\172\228\188\154\239\188\159"),
      rightHandler = function()
        ed.GuildNetwork:sendQuitGuild()
        ed.popScene()
      end,
      rightText = T("\231\161\174\229\174\154")
    }
    ed.showConfirmDialog(info)
  end
  
  local info = {
    text = txt,
    rightHandler = function()
      secondConfirm()
    end
  }
  ed.showConfirmDialog(info)
end

function GuildManager:handleJoinGuildReply(data)
  if nil == data then
    return
  end
  if data._result == "join_enter" then
    ed.showToast(T("\230\136\144\229\138\159\229\138\160\229\133\165\229\133\172\228\188\154"))
    local guildInfo = data._guild_info
    self:initGuildData(guildInfo)
    local guildMainScene = ed.ui.GuildMainScene.create()
    ed.replaceScene(guildMainScene)
  elseif data._result == "join_wait" then
    ed.showToast(T("\231\148\179\232\175\183\230\136\144\229\138\159,\231\173\137\229\190\133\230\137\185\229\135\134"))
  elseif data._result == "join_fail" and data._cd_time then
    local str = ed.gethmsCString(data._cd_time)
    ed.showToast(T(self.joinGuildFial[data._fail_reason], str))
  end
end

function GuildManager:handleSetJobReply(data)
  if data._result == "success" then
    if self.jobChange == "chairman" then
      for i, v in ipairs(self.members) do
        if v._uid == ed.getUserid() then
          v._job = "member"
          ed.player:setGuildJob("member")
          ed.popScene()
          break
        end
      end
    else
      for i, v in ipairs(self.members) do
        if v._uid == self.selectMemberId then
          v._job = self.jobChange
          break
        end
      end
      self:sortGuildMember()
      ed.showToast(T("\230\147\141\228\189\156\230\136\144\229\138\159"))
      FireEvent("GuildMemberRefresh")
    end
  end
end

function GuildManager:handleKickMemberReply(data)
  if data._result == "success" then
    for i, v in ipairs(self.members) do
      if v._uid == ed.GuildNetwork.kickId then
        table.remove(self.members, i)
        ed.GuildNetwork.kickId = nil
        break
      end
    end
    self:sortGuildMember()
    ed.showToast(T("\230\147\141\228\189\156\230\136\144\229\138\159"))
    FireEvent("GuildMemberRefresh")
  end
end

function GuildManager:addMemberCardInfo(uid)
  for _, v in ipairs(self.members) do
    if v._uid == uid then
      v._guild_monthcard = ed.downmsg.monthcard()
      v._guild_monthcard._id = ed.parameter.guild_month_card
      v._guild_monthcard._expire_time = ed.getServerTime() + 2592000
      return
    end
  end
end

function GuildManager:handleGuildCreateReply(data)
  if data._result == "success" then
    ed.player:subrmb(self.createGuildCost)
    ed.showToast(T("\229\136\155\229\187\186\229\133\172\228\188\154\230\136\144\229\138\159"))
    local guildInfo = data._guild_info
    self:initGuildData(guildInfo)
    self.unlockIconAvatars = data._avatars
    self.unlockIconFrames = data._frames
    local guildMainScene = ed.ui.GuildMainScene.create()
    ed.replaceScene(guildMainScene)
  end
end

function GuildManager:handleGuildSearchReply(data)
  FireEvent("GuildRefreshSearch", data)
end

function GuildManager:handleGuildQueryReply(data)
  self.unlockIconAvatars = data._avatars
  self.unlockIconFrames = data._frames
  local guildInfo = data._info
  self:initGuildData(guildInfo)
  local worshipData = data._worship
  self.curWorshipTime = worshipData._use_times
  local gold = 0
  if worshipData._rewards then
    for i, v in ipairs(worshipData._rewards) do
      if v._type == "gold" then
        gold = v._param1 + gold
      end
    end
  end
  self.lastSetNameTime = data._last_set_name_time
  self.worshipGold = gold
  local guildMainScene = ed.ui.GuildMainScene.create({
    toChairman = data._to_chairman
  })
  ed.pushScene(guildMainScene)
end

function GuildManager:handleGuildDismissReply(data)
  if data._result == "success" then
    ed.player:setGuild(nil)
    ed.player:cancelAllMercenary()
    ed.popScene()
    ed.showToast(T("\230\136\144\229\138\159\232\167\163\230\149\163\229\133\172\228\188\154"))
    ed.GuildRaidManager:initData()
    ed.GuildManager:initData()
  end
end

function GuildManager:handleGuildSettingReply(data)
  if data._result == "success" then
    ed.showToast(T("\228\191\174\230\148\185\232\174\190\231\189\174\230\136\144\229\138\159"))
    if self.settingData then
      local settingData = self.settingData
      self.avatar = settingData.avatar or self.avatar
      self.frame = settingData.frame or self.frame
      self.name = settingData.name or self.name
      self.type = settingData.type or self.type
      self.slogan = settingData.slogan or self.slogan
      self.joinLimit = settingData.joinLimit or self.joinLimit
      self.settingData = nil
    end
    if data._diamond_cost then
      ed.player:subrmb(data._diamond_cost)
    end
    FireEvent("GuildSettingRefresh")
  end
end

function GuildManager:handleJoinConfirmReply(data)
  if data._result == "fail" then
    ed.showToast(T("error"))
    return
  end
  local newMan = data._new_man
  if newMan then
    table.insert(self.members, newMan)
    self:sortGuildMember()
    FireEvent("GuildMemberRefresh")
    FireEvent("GuildJoinConfirmReply", true)
  else
    FireEvent("GuildJoinConfirmReply", false)
  end
end

function GuildManager:handleWorshipReply(data)
  if data._result == "success" then
    self.curWorshipTime = self.curWorshipTime + 1
    FireEvent("GuildWorshipSuccess")
  end
end

function GuildManager:handleWorshipWithdrawReply(data)
  if data._rewards == nil then
    return
  end
  local items = {}
  for i, v in ipairs(data._rewards) do
    if v._type == "gold" then
      ed.player:addMoney(v._amount)
      table.insert(items, {
        type = "Gold",
        amount = v._amount,
        title = T("\232\142\183\229\190\151\233\135\145\229\184\129:")
      })
    elseif v._type == "diamond" then
      ed.player:addrmb(v._amount)
      table.insert(items, {
        type = "Diamond",
        amount = v._amount,
        title = T("\232\142\183\229\190\151\233\146\187\231\159\179:")
      })
    end
  end
  ed.announce({
    type = "getProp",
    param = {
      title = T("\232\134\156\230\139\156\229\165\150\229\138\177"),
      items = items
    }
  })
  self.worshipGold = 0
end

function GuildManager:handleQueryHiresReply(data)
  local mercenaryHeros = {}
  for _, v in ipairs(data._users or {}) do
    if v and v._heroes then
      local bHired = false
      local hireState = self.MecrenaryType.cHired
      if data._hire_uids and ed.isElementInTable(v._uid, data._hire_uids) then
        hireState = self.MecrenaryType.bHired
      end
      if v._uid == ed.getUserid() then
        bHired = true
      end
      if bHired == false and v._heroes then
        for _, heroInfo in ipairs(v._heroes) do
          local type = hireState
          local hero = ed.HeroCreate()
          hero:setup(heroInfo._hero)
          local mercenaryInfo = self:generateMercenaryInfo(v._user_summary._role_id, v._uid, v._user_summary._name, heroInfo._cost, hireState)
          hero:setMercenaryData(mercenaryInfo)
          if data._from == "tbc" then
            local crusadeData = self:generateDynaData()
            hero:setCrusade(crusadeData)
          end
          table.insert(mercenaryHeros, hero)
        end
      end
    end
  end
  FireEvent("MercenaryAlready", mercenaryHeros)
  self.mercenaryHeros = mercenaryHeros
  self.curMercenarys = 0
  self.allMercenary = {}
  self.selfMercenary = {}
  for k, v in ipairs(data._users or {}) do
    for index, hero in ipairs(v._heroes) do
      local item = {
        hero = hero._hero,
        time = hero._hire_ts,
        cost = hero._cost,
        money = hero._income,
        name = v._user_summary._name
      }
      if v._uid == ed.getUserid() then
        table.insert(self.selfMercenary, item)
        table.insert(self.allMercenary, item)
        self.curMercenarys = self.curMercenarys + 1
      else
        table.insert(self.allMercenary, item)
      end
    end
  end
  FireEvent("GuildMercenaryReply", data)
end

function GuildManager:handleHireHeroReply(data)
  if data._result ~= "success" then
    if data._result == "stage_invalid" then
      ed.showToast(T("\229\189\147\229\137\141\229\133\179\229\141\161\228\184\141\229\143\175\232\191\155\229\133\165"))
    else
      ed.showToast(T("\233\155\135\228\189\163\232\139\177\233\155\132\229\164\177\232\180\165"))
    end
    return
  end
  if nil == self.mercenaryHeros then
    return
  end
  for _, v in ipairs(self.mercenaryHeros) do
    local mercenaryInfo = v:getMercenaryData()
    if mercenaryInfo and mercenaryInfo._uid == data._uid and v._tid == data._hero._tid then
      v:setup(data._hero)
      ed.player:addMoney(-mercenaryInfo._cost)
      FireEvent("HireMercenarySuccess")
      if data._from == "tbc" then
        local crusadeData = self:generateDynaData()
        v:setCrusade(crusadeData)
        mercenaryInfo._cost = 0
        self.crusadeMercenary = v
      elseif data._from == "excav" then
        local excavateData = self:generateDynaData()
        v:setExcavate(excavateData)
        mercenaryInfo._cost = 0
        self.excavateMercenary = v
      elseif data._from == "tower" then
        local towerData = self:generateDynaData()
        v:setThroneTower(towerData)
        mercenaryInfo._cost = 0
        self.towerMercenary = v
      elseif data._from == "multi_stage" then
        local multistageData = self:generateDynaData()
        v:setMultistage(multistageData)
        mercenaryInfo._cost = 0
        self.multistageMercenary = v
      end
      return
    end
  end
end

function GuildManager:handleHirePracticeHeroReply(data)
  if nil == self.mercenaryHeros then
    return
  end
  if not self.practiceHeroReply then
    self.PracticeMercenaryIndex = nil
    self.practiceHeroReply = ListenEvent("req_hero_info", function(replyInfo)
      if self.PracticeMercenaryIndex then
        self.mercenaryHeros[self.PracticeMercenaryIndex].data = replyInfo
        FireEvent("HireMercenarySuccess")
        self.PracticeMercenaryIndex = nil
      end
    end)
  end
  for i, v in ipairs(self.mercenaryHeros) do
    local mercenaryInfo = v:getMercenaryData()
    if mercenaryInfo and mercenaryInfo._uid == data._uid and v._tid == data._tid then
      ed.PlayerInfoNetwork:requestHeroData(mercenaryInfo._roleid, v._tid)
      self.PracticeMercenaryIndex = i
      return
    end
  end
end

function GuildManager:handleAddMercenaryReply(data)
  if data._result == "success" then
    self.curMercenarys = self.curMercenarys + 1
    local item = {
      hero = ed.player:getHero(self.curDispatchId),
      money = data._income,
      time = ed.getServerTime(),
      cost = 0,
      name = ed.player:getName()
    }
    table.insert(self.allMercenary, item)
    table.insert(self.selfMercenary, item)
    FireEvent("GuildAddMercenarySuccess", data)
    ed.record:refreshCommonRecord("SendMercenary", 1)
    self.curDispatchId = nil
  end
end

function GuildManager:handleDelMercenaryReply(data)
  if data._result == "success" then
    self.curMercenarys = self.curMercenarys - 1
    for i = 1, #self.selfMercenary do
      local mercenary = self.selfMercenary[i]
      if mercenary.hero._tid == data._heroid then
        table.remove(self.selfMercenary, i)
        break
      end
    end
    for i = 1, #self.allMercenary do
      local mercenary = self.allMercenary[i]
      if mercenary.hero._tid == data._heroid and mercenary.name == ed.player:getName() then
        table.remove(self.allMercenary, i)
        break
      end
    end
    local goldChange = data._hire_reward + data._stay_reward
    ed.player:addMoney(goldChange)
    ed.player:cancelMercenary(data._heroid)
    local rewards = {}
    table.insert(rewards, {type = "Gold", amount = goldChange})
    ed.announce({
      type = "getProp",
      param = {
        title = T("\228\189\160\232\142\183\229\190\151\228\186\134\228\187\165\228\184\139\229\165\150\229\138\177"),
        items = rewards,
        callback = function()
        end
      }
    })
    FireEvent("GuildDelMercenarySuccess", data)
  end
end

function GuildManager:generateMercenaryInfo(roleid, uid, name, cost, sort)
  local mercenaryInfo = {}
  mercenaryInfo._roleid = roleid
  mercenaryInfo._uid = uid
  mercenaryInfo._name = name
  mercenaryInfo._cost = cost
  mercenaryInfo._sort = sort
  return mercenaryInfo
end

function GuildManager:generateDynaData()
  local data = {}
  data._hp_perc = 10000
  data._mp_perc = 0
  return data
end

function GuildManager:setMercenary(data, mode)
  local hero
  if nil == data then
    hero = nil
    return
  end
  if hero == nil then
    hero = ed.HeroCreate()
  end
  local heroInfo = data._hero
  hero:setup(heroInfo._base)
  local mercenaryInfo = self:generateMercenaryInfo(data._role_id, data._uid, data._name, 0)
  hero:setMercenaryData(mercenaryInfo)
  if mode == "crusade" then
    hero:setCrusade(heroInfo._dyna)
  elseif mode == "excavate" then
    hero:setExcavate(heroInfo._dyna)
  elseif mode == "tower" then
    hero:setThroneTower(heroInfo._dyna)
  end
  local bFound = false
  for k, v in ipairs(self.mercenaryHeros) do
    local mercenaryInfo = v:getMercenaryData()
    if mercenaryInfo and mercenaryInfo._uid == data._uid and v._tid == heroInfo._base._tid then
      self.mercenaryHeros[k] = hero
      bFound = true
      break
    end
  end
  if bFound == false then
    table.insert(self.mercenaryHeros, hero)
  end
  return hero
end

function GuildManager:setCrusadeMercenary(data)
  local hero = self:setMercenary(data, "crusade")
  self.crusadeMercenary = hero
end

function GuildManager:setGuildMountMercenary(data)
  local hero = self:setMercenary(data, "guild_mount")
  self.guildMountMercenary = hero
end

function GuildManager:getMercenaryHero(uid, tid)
  if uid == nil or tid == nil then
    return nil
  end
  for _, v in ipairs(self.mercenaryHeros) do
    local mercenaryInfo = v:getMercenaryData()
    if mercenaryInfo and mercenaryInfo._uid == uid and v._tid == tid then
      return v
    end
  end
  return nil
end

function GuildManager:setMultistageMercenaryDyna(dyna)
  if self.multistageMercenary then
    self.multistageMercenary:setMultistage(dyna)
    return self.multistageMercenary
  end
end

function GuildManager:getInstanceInfo(chapter)
  for i, v in pairs(self.openInstanceInfo) do
    local raidTable = ed.getDataTable("Raid")
    if raidTable[i] and raidTable[i]["Chapter ID"] == chapter then
      return v, i
    end
  end
end

function GuildManager:addInstanceInfo(raidId, stageId, progress, leftTime, wholeProgress, startTime, contribution, hintInfo, iconRes)
  local info = {}
  info.stageId = stageId
  info.progress = progress
  info.leftTime = leftTime
  info.RaidProgress = wholeProgress
  info.startTime = startTime
  info.contribution = contribution
  info.hintInfo = hintInfo
  info.iconRes = iconRes
  self.openInstanceInfo[raidId] = info
end

function GuildManager:onInstanceQuery(data)
  for _, value in ipairs(data._pass_raid_list or {}) do
    self.passedInstanceIds[value] = true
  end
  self.openInstanceInfo = {}
  for k, v in ipairs(data._summary or {}) do
    local raidItem = {
      stageProgress = v._stage_progress,
      leftTime = v._left_time,
      raidId = v._id,
      progress = v._progress,
      startTime = v._start_time,
      contribution = v._contribution,
      stageId = v._stage_id
    }
    table.insert(self.openInstanceInfo, raidItem)
  end
  table.sort(self.openInstanceInfo, function(a, b)
    return a._id < b._id
  end)
end

function GuildManager:handleInstanceQueryReply(data)
  self:onInstanceQuery(data)
  ed.ui.GuildSelectRaidWin.create()
end

function GuildManager:handleInstanceOpenReply(data)
  if data._result == "success" then
    local costVitality = ed.getDataTable("Raid")[data._raid_id]["Guild Active Cost"]
    ed.player.currentVitality = ed.player.currentVitality - costVitality
    local hintInfo = T("<text|normal_black|\229\156\168><text|normal_red|6\229\164\16923\229\176\143\230\151\182><text|normal_black|\229\134\133\233\128\154\229\133\179\229\143\175\232\142\183\233\162\157\229\164\150\229\165\150\229\138\177>")
    local iconRes = ed.getDataTable("Raid")[data._raid_id].icon
    local stageId = ed.getDataTable("Raid")[data._raid_id]["Begin Stage ID"]
    self:addInstanceInfo(data._raid_id, stageId, 0, data._left_time, 0, ed.getServerTime(), 10000, hintInfo, iconRes)
  end
end

function GuildManager:handleGameplayRankReply(data)
  FireEvent("GuildGameplayRank", data)
end

function GuildManager:GuildRecruitOpenPanelReply(data)
  local teams = {}
  for i, v in ipairs(data._members or {}) do
    table.insert(teams, {
      user_summary = v._user_summary,
      is_online = v._is_online,
      liveness = v._liveness
    })
  end
  self.guildRecruit = {
    has_entry = data._has_entry == 1,
    has_sub = data._has_sub == 1,
    sub_expire_time = data._sub_expire_time,
    guild_liveness = data._guild_liveness,
    total_member = data._total_member,
    version = data._version,
    members = teams
  }
  self.starts = {
    [1] = data._version
  }
  FireEvent("GuildRecruitReply", "OpenPanel")
end

function GuildManager:GuildRecruitEntryReply(data)
  if data._result == "success" then
    self.guildRecruit.has_entry = true
    FireEvent("GuildRecruitReply", "Entry")
  end
end

function GuildManager:GuildRecruitQuitReply(data)
  if data._result == "success" then
    self.guildRecruit.has_entry = false
    FireEvent("GuildRecruitReply", "Quit")
  end
end

function GuildManager:GuildRecruitSubReply(data)
  if data._result == "success" then
    self.guildRecruit.has_sub = true
    FireEvent("GuildRecruitReply", "Sub")
  end
end

function GuildManager:GuildRecruitVersionIsPullAgain(start)
  if self.starts[start] then
    return self.starts[start] ~= self.guildRecruit.version
  end
  return true
end

function GuildManager:GuildRecruitQueryReply(data)
  local isSelf = #self.guildRecruit.members % 60 == 1
  local start = (data._start - 1) * 60 + (isSelf and 1 or 0)
  for _, v in ipairs(data._members or {}) do
    self.guildRecruit.members[start + 1] = {
      user_summary = v._user_summary,
      is_online = v._is_online,
      liveness = v._liveness
    }
    start = start + 1
  end
  self.starts[start] = data._version
  self.guildRecruit.version = data._version
  self.guildRecruit.total_member = data._total_member
end

function GuildManager:joinNotify(notify)
  if notify == 0 then
    self.guildJoinNotify = nil
  else
    self.guildJoinNotify = true
  end
end

function GuildManager:notify(notify)
  self.guildRecruitNotify = notify
end

function GuildManager:getShowRecruitRed()
  local entryUidKey = ed.getRoleKey("entryRedGuildRecruit")
  local subUidKey = ed.getRoleKey("subRedGuildRecruit")
  local data = self.guildRecruit
  local showReds = {}
  if ed.player:getGuildJob() and ed.player:getGuildJob() ~= "member" then
    if not ed.storage.getBool(subUidKey) then
      showReds.guideSubRed = true
    end
    if data and not data.has_sub and data.guild_liveness >= 80000 then
      showReds.subRed = true
    end
  end
  if data and not ed.storage.getBool(entryUidKey) and not data.has_entry then
    showReds.entryRed = true
  end
  return showReds
end

ed.UITool.registViewOpenFunc("guildScene", function()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Guild")
  if ds then
    ed.showToast(ds)
    return
  end
  local msg = ed.upmsg.guild()
  msg._open_pannel = {}
  ed.send(msg, "guild")
end)
ed.GuildManager = GuildManager.getInstance()
return GuildManager
