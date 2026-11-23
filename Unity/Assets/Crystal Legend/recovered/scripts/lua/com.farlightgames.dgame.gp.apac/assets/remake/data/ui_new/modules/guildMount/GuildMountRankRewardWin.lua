local base = ed.ui.popwindow
local GuildMountRankRewardWin = {}
GuildMountRankRewardWin.__index = GuildMountRankRewardWin
setmetatable(GuildMountRankRewardWin, base.mt)
ed.ui.GuildMountRankRewardWin = GuildMountRankRewardWin
local GuildMountRankRewardWinScope = {}
local MAX_RANK = 999999

function GuildMountRankRewardWin.useCache()
  return true
end

function GuildMountRankRewardWin.isDebug()
  return true
end

function GuildMountRankRewardWin.create(params)
  local self = base.create("GuildMountRankRewardWin")
  setmetatable(self, GuildMountRankRewardWin)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:registerOnEnterHandler("OnEnter", function()
    self:refreshUI()
  end)
  self:registerOnExitHandler("OnExit", function()
  end)
  self:popWindow(500)
  self:changeTab("all_guilds")
  return self
end

function GuildMountRankRewardWin:initData(params)
  params = params or {}
  self.tabKeys = {"all_guilds", "my_guild"}
  self.currentTabKey = nil
  self.cacheData = {}
end

function GuildMountRankRewardWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMountRankRewardWin)
  self.ui = ui
  self.mainLayer:addChild(container)
  ed.setLabelStroke(self.ui.label_guild_name, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_guild_score, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_guild_rank, ccc3(0, 0, 0), 1)
  self.rewardIcons = {}
  self.ranklistItems = {}
  self:initMyGuildDescDraglist()
  self:refreshMyGuildInfo()
  self:initRankDraglist()
end

function GuildMountRankRewardWin:registerTouchHandlers()
  self:registerBtn("button_close", function()
    self:onClickClose()
  end)
  for _, v in ipairs(self.tabKeys) do
    self:registerBtn("button_" .. v, function()
      self:onClickTabButton(v)
    end)
  end
  self:btRegisterHandler({
    handler = function(event, x, y)
      self:clickRewardIconsHandler(event, x, y)
    end,
    key = "clickRewards",
    force = true
  })
  self:registerBtn("img_rank_rewards_detail", function()
    self:onClickRankRewardsDetail()
  end)
end

function GuildMountRankRewardWin:closeEvents()
  CloseScope(GuildMountRankRewardWinScope)
end

function GuildMountRankRewardWin:registerEvents()
  self:closeEvents()
  ListenEvent("GuildMountErrorCode", function(errorCode)
    self:onErrorCode(errorCode)
  end, GuildMountRankRewardWinScope)
  ListenEvent("GuildMountMyGuildRank", function(data)
    self:refreshByQueryResult("MyGuildTab", data)
  end, GuildMountRankRewardWinScope)
  ListenEvent("GuildMountAllGuildsRank", function(data)
    self:refreshByQueryResult("AllGuildsTab", data)
  end, GuildMountRankRewardWinScope)
end

function GuildMountRankRewardWin:popWindow(zOrder)
  self.parentScene = ed.getCurrentScene()
  base.popWindow(self, zOrder)
  self:registerParentScenePopHandler()
end

function GuildMountRankRewardWin:getParentScene()
  return self.parentScene
end

function GuildMountRankRewardWin:registerParentScenePopHandler()
  local parentScene = self:getParentScene()
  if not parentScene or not parentScene.registerOnPopSceneHandler then
    return
  end
  parentScene:registerOnPopSceneHandler("onPopGuildMountRankRewardWin", function()
    self:onParentScenePop()
  end)
end

function GuildMountRankRewardWin:onParentScenePop()
  if self.isDestroyed then
    return
  end
  self:destroy()
end

function GuildMountRankRewardWin:destroy()
  base.destroy(self)
  self:closeEvents()
  ed.GuildMountManager:setRankRewardWin(nil)
end

function GuildMountRankRewardWin:getMyGuildId()
  return ed.player:getGuildId()
end

function GuildMountRankRewardWin:getMyGuildName()
  return ed.player:getGuildName()
end

function GuildMountRankRewardWin:getRewardsByGuildRank(rank)
  if not rank then
    return {}
  end
  local tb = ed.getDataTable("GuildMountSeasonReward")
  local rankArr = {}
  for k, v in pairs(tb) do
    if type(k) == "number" then
      table.insert(rankArr, v.Rank)
    end
  end
  table.sort(rankArr, function(e1, e2)
    return e1 < e2
  end)
  local rewardRank = MAX_RANK
  for k, v in ipairs(rankArr) do
    if rank <= v then
      rewardRank = v
      break
    end
  end
  local row = tb[rewardRank]
  local rewards = {}
  for i = 1, 5 do
    local typ = row["Reward Type" .. i]
    local id = row["Reward ID" .. i]
    local amount = row["Reward Amount" .. i]
    if typ then
      table.insert(rewards, {
        type = typ,
        id = id,
        amount = amount
      })
    end
  end
  return rewards
end

function GuildMountRankRewardWin:createGuildIcon(iconId, iconFrameId)
  local node = CCSprite:create()
  local guildIcon = ed.createGuildAvatar(iconId, iconFrameId)
  guildIcon:setPosition(ccp(-36, -37))
  node:addChild(guildIcon)
  return node
end

function GuildMountRankRewardWin:refreshMyGuildIcon(iconId, frameId)
  iconId = iconId or 1
  frameId = frameId or 1
  local egNode = self.ui.img_guild_icon
  egNode:setVisible(false)
  if not tolua.isnull(self.myGuildIcon) then
    self.myGuildIcon:removeFromParentAndCleanup(true)
    self.myGuildIcon = nil
  end
  local guildIcon = self:createGuildIcon(iconId, frameId)
  guildIcon:setPosition(egNode:getPosition())
  egNode:getParent():addChild(guildIcon)
  self.myGuildIcon = guildIcon
end

function GuildMountRankRewardWin:initMyGuildDescDraglist()
  self.guildDescDraglist = ed.CampUITool.createDraglist(self.ui.panel_guild_desc, {priority = -301})
end

function GuildMountRankRewardWin:refreshMyGuildDesc(desc)
  desc = desc or ""
  self.guildDescDraglist:clearList()
  local paddingX = 5
  local paddingY = 5
  local labelWid = self.guildDescDraglist.width - 2 * paddingX
  local label = ed.createLabelTTF(desc, 14)
  label:setAnchorPoint(ccp(0, 1))
  label:setDimensions(CCSizeMake(labelWid, 0))
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setColor(ccc3(246, 229, 199))
  local labelHei = label:getContentSize().height + 2 * paddingY
  label:setPosition(ccp(paddingX, self.guildDescDraglist.height - paddingY))
  self.guildDescDraglist:addItem(label)
  self.guildDescDraglist:initListHeight(labelHei)
end

function GuildMountRankRewardWin:refreshMyGuildName(name)
  ed.setString(self.ui.label_guild_name, name)
end

function GuildMountRankRewardWin:refreshMyGuildRank(rank)
  local rankStr = rank and T("\230\142\146\229\144\141:%d", rank) or T("\230\142\146\229\144\141:-")
  ed.setString(self.ui.label_guild_rank, rankStr)
  self:refreshRewards(rank)
end

function GuildMountRankRewardWin:refreshMyGuildScore(score)
  local scoreStr = score and T("\231\167\175\229\136\134:%d", score) or T("\231\167\175\229\136\134:-")
  ed.setString(self.ui.label_guild_score, scoreStr)
end

function GuildMountRankRewardWin:refreshMyGuildInfo(info)
  info = info or {}
  self.guildRank = info.guildRank or self.guildRank
  self.guildScore = info.guildScore or self.guildScore
  self:refreshMyGuildIcon(info.guildIconId, info.guildIconFrameId)
  self:refreshMyGuildName(info.guildName)
  self:refreshMyGuildScore(info.guildScore)
  self:refreshMyGuildRank(info.guildRank)
  self:refreshMyGuildDesc(info.guildDesc)
end

function GuildMountRankRewardWin:refreshUI()
end

function GuildMountRankRewardWin:refreshRewards(guildRank)
  local parent = self.ui.panel_rewards
  local pSize = parent:getContentSize()
  local container = CCSprite:create()
  local icons = {}
  local rewards = self:getRewardsByGuildRank(guildRank)
  local iconHei = 44
  local widAcc = 0
  local gapX = 8
  for k, v in ipairs(rewards) do
    local icon = ed.CampUITool.createItemIcon(v, iconHei)
    container:addChild(icon)
    local wid = icon:getContentSize().width
    widAcc = widAcc + wid
    table.insert(icons, {icon = icon, data = v})
  end
  widAcc = widAcc + gapX * math.max(#rewards - 1, 0)
  local ox = -widAcc / 2
  for k, item in ipairs(icons) do
    local icon = item.icon
    local wid = icon:getContentSize().width
    icon:setPositionX(ox + wid / 2)
    ox = ox + wid + gapX
  end
  container:setScale((pSize.width - 10) / widAcc)
  parent:addChild(container)
  container:setPosition(ed.getCenterPos(parent))
  self.rewardIcons = icons
end

local rewardDetailPanel

function GuildMountRankRewardWin:destroyRewardDetailPanel()
  if not tolua.isnull(rewardDetailPanel) then
    rewardDetailPanel:removeFromParentAndCleanup(true)
    rewardDetailPanel = nil
  end
end

function GuildMountRankRewardWin:clickRewardIconsHandler(event, x, y)
  if event == "began" then
    for k, v in ipairs(self.rewardIcons) do
      local data = v.data
      local icon = v.icon
      if ed.containsPoint(icon, x, y) then
        rewardDetailPanel = ed.CampUITool.createFlyLayer(data)
        local iconPos = ed.getWorldPos(icon)
        rewardDetailPanel:setPosition(ccpAdd(iconPos, ccp(0, 40)))
        ed.CampUITool.addFlyLayer(self.mainLayer, rewardDetailPanel, ccpAdd(iconPos, ccp(0, 80)))
        return
      end
    end
  elseif event == "ended" then
    self:destroyRewardDetailPanel()
  end
end

function GuildMountRankRewardWin:initRankDraglist()
  local size = self.ui.panel_guild_list:getContentSize()
  local height = size.height
  self.rankDraglist = ed.CampUITool.createDraglist(self.ui.panel_guild_list, {
    doPressIn = self:getRanklistPressInHandler(),
    cancelPressIn = self:getRanklistCancelPressInHandler(),
    doClickIn = self:getRanklistClickInHandler(),
    bar = {
      bglen = height - 20,
      bgpos = ccp(5, height / 2)
    },
    priority = -301
  })
end

function GuildMountRankRewardWin:getRanklistPressInHandler()
  local function hanlder(x, y)
    for k, v in ipairs(self.ranklistItems or {}) do
      if ed.containsPoint(v.ui.bg, x, y) then
        return k
      end
    end
  end
  
  return hanlder
end

function GuildMountRankRewardWin:getRanklistCancelPressInHandler()
  local function hanlder(x, y, k)
    local data = self.ranklistItems[k]
  end
  
  return hanlder
end

function GuildMountRankRewardWin:getRanklistClickInHandler()
  local function hanlder(x, y, k)
    local data = self.ranklistItems[k]
    
    self:callTabControllerFunc("onClickedItem", data, x, y)
  end
  
  return hanlder
end

function GuildMountRankRewardWin:formatGuildSummary(summary)
  local avatarInfo = ed.analyzeAvatar(summary._avatar)
  local r = {
    guildIconId = avatarInfo.avatar,
    guildIconFrameId = avatarInfo.avatarFrame,
    guildName = summary._name,
    guildMemberCount = summary._member_cnt,
    guildDesc = summary._slogan
  }
  return r
end

function GuildMountRankRewardWin:formatGuildRankItem(raw)
  local r = self:formatGuildSummary(raw._guild_summary)
  r.guildScore = raw._score
  r.rawGuildSummary = raw._guild_summary
  r.guildPlat = raw._plat
  r.guildServerId = raw._show_server_id
  return r
end

function GuildMountRankRewardWin:formatUserSummary(summary)
  local r = {
    userAvatar = summary._avatar,
    isVIP = summary._vip > 0,
    userName = summary._name
  }
  return r
end

function GuildMountRankRewardWin:formatUserRankItem(raw)
  local r = self:formatUserSummary(raw._user_summary)
  r.userScore = raw._score
  local _score_rate = raw._score_rate or {}
  local bossData = {}
  local bossIds = ed.GuildMountManager:getBossIds()
  for i = 1, 5 do
    local bossId = bossIds[i]
    local row = ed.getDataTable("GuildMountBoss")[bossId]
    local unitId = row["Unit ID"]
    local scoreRate = _score_rate[i]
    table.insert(bossData, {
      index = i,
      unitId = unitId,
      scoreRate = scoreRate
    })
  end
  r.bossData = bossData
  return r
end

function GuildMountRankRewardWin:onErrorCode(errorCode)
  self.rankDraglist:clearList()
end

function GuildMountRankRewardWin:isSameGuild(rawData1, rawData2)
  if not rawData1 or not rawData2 then
    return false
  end
  if rawData1._plat ~= rawData2._plat then
    return false
  end
  if rawData1._guild_summary._id ~= rawData2._guild_summary._id then
    return false
  end
  return true
end

function GuildMountRankRewardWin:isMe(rawData)
  if not rawData then
    return false
  end
  local myUserId = ed.getUserid()
  return rawData._user_summary._uid == myUserId
end

function GuildMountRankRewardWin:refreshByQueryResult(key, rawData)
  if key == "MyGuildTab" then
    local rankList = {}
    for k, v in ipairs(rawData._rank_list or {}) do
      local item = self:formatUserRankItem(v)
      item.userRank = k
      item.isMe = self:isMe(v)
      table.insert(rankList, item)
    end
    self:refreshRankList(key, rankList)
  elseif key == "AllGuildsTab" then
    local myGuildInfo = self:formatGuildSummary(rawData._self_guild)
    myGuildInfo.guildRank = rawData._self_pos
    myGuildInfo.guildScore = rawData._self_rank and rawData._self_rank._score or nil
    self:refreshMyGuildInfo(myGuildInfo)
    local rankList = {}
    for k, v in ipairs(rawData._rank_list or {}) do
      local item = self:formatGuildRankItem(v)
      item.guildRank = k
      item.guildServer = v._plat
      item.isMyGuild = self:isSameGuild(rawData._self_rank, v)
      table.insert(rankList, item)
    end
    self:refreshRankList(key, rankList)
  end
end

function GuildMountRankRewardWin:refreshRankList(key, data)
  self.cacheData[key] = data
  local tabKey = self:callTabControllerFunc("getKey")
  if key ~= tabKey then
    return
  end
  self.rankDraglist:clearList()
  local ranklistItems = {}
  local paddingX = 6
  local paddingY = 5
  local ox = paddingX
  local oy = self.rankDraglist.height - paddingY
  local gapY = 5
  local totalHei = 0
  for k, v in ipairs(data) do
    local item, ui, size = self:callTabControllerFunc("createListItem", v)
    item:setPosition(ccp(ox + size.width / 2, oy - size.height / 2))
    self.rankDraglist:addItem(item)
    table.insert(ranklistItems, {
      data = v,
      node = item,
      ui = ui
    })
    oy = oy - size.height - gapY
    totalHei = totalHei + size.height
  end
  self.ranklistItems = ranklistItems
  totalHei = totalHei + 2 * paddingY + math.max(#data - 1, 0) * gapY
  self.rankDraglist:initListHeight(totalHei)
end

function GuildMountRankRewardWin:registerBtn(key, func, pressScale)
  ed.CampUITool.registerBtn(self, key, func, pressScale)
end

function GuildMountRankRewardWin:changeTab(key)
  for k, v in ipairs(self.tabKeys) do
    local isCur = key == v
    local button = self.ui[string.format("button_%s", v)]
    local buttonPress = self.ui[string.format("button_%s_press", v)]
    local buttonLabel = self.ui[string.format("button_%s_label", v)]
    local normalRes = isCur and "UI/alpha/HVGA/guildmount/top_button_current.png" or "UI/alpha/HVGA/guildmount/top_button.png"
    local pressRes = isCur and "UI/alpha/HVGA/guildmount/top_button_current_press.png" or "UI/alpha/HVGA/guildmount/top_button_press.png"
    local labelColor = isCur and ccc3(251, 206, 16) or ccc3(255, 255, 255)
    ed.setTexture(button, normalRes)
    ed.setTexture(buttonPress, pressRes)
    buttonLabel:setColor(labelColor)
  end
  if key == self.currentTabKey then
    return
  end
  self.currentTabKey = key
  self.currentTabController = self["tab_" .. key].create({parentWin = self})
  self:callTabControllerFunc("sendDataQuery")
end

function GuildMountRankRewardWin:callTabControllerFunc(funcName, ...)
  if self.currentTabController and self.currentTabController[funcName] then
    return self.currentTabController[funcName](self.currentTabController, ...)
  end
end

function GuildMountRankRewardWin:onClickClose()
  self:destroy()
end

function GuildMountRankRewardWin:onClickTabButton(key)
  self:changeTab(key)
end

function GuildMountRankRewardWin:onClickRankRewardsDetail()
  ed.ui.GuildMountRewardDetailWin.create({
    rank = self.guildRank,
    score = self.guildScore
  })
end

local Tab = {}
Tab.__index = Tab

function Tab.create(params)
  local self = {}
  setmetatable(self, Tab)
  self:init(params)
  return self
end

function Tab:init(params)
  params = params or {}
  self.parentWin = params.parentWin
end

function Tab:getKey()
  return "Tab"
end

function Tab:sendDataQuery()
end

function Tab:createListItem(data)
  return CCNode:create(), {}, CCSizeMake(0, 0)
end

function Tab:createRankNode(rank)
  local bg = ed.createSprite("UI/alpha/HVGA/guildmount/rank_bg.png")
  if rank <= 3 then
    local rankIconRes = string.format("UI/alpha/HVGA/guildmount/rank_%d.png", rank)
    local rankIcon = ed.createSprite(rankIconRes)
    rankIcon:setScale(0.95)
    rankIcon:setPosition(ed.getCenterPos(bg))
    bg:addChild(rankIcon)
  else
    local label = ed.createLabelTTF(T("\231\172\172%d\229\144\141", rank), 11)
    label:setColor(ccc3(255, 253, 215))
    label:setStroke(ccc3(138, 89, 83), 2)
    label:setPosition(ed.getCenterPos(bg))
    bg:addChild(label)
  end
  return bg
end

function Tab:createGuildIcon(iconId, iconFrameId)
  return self.parentWin:createGuildIcon(iconId, iconFrameId)
end

function Tab:onClickedItem(data, x, y)
end

local function newTabClass(key)
  local class = {}
  class.__index = class
  setmetatable(class, Tab)
  GuildMountRankRewardWin["tab_" .. key] = class
  return class
end

local AllGuildsTab = newTabClass("all_guilds")

function AllGuildsTab.create(params)
  local self = {}
  setmetatable(self, AllGuildsTab)
  self:init(params)
  return self
end

function AllGuildsTab:getKey()
  return "AllGuildsTab"
end

function AllGuildsTab:getDebugData()
  local data = {}
  for i = 1, 10 do
    local item = {
      guildRank = i,
      guildIconId = i,
      guildIconFrameId = math.random(1, 7),
      guildName = "GUILD" .. i,
      guildMemberCount = math.random(1, 30),
      guildDamage = 1000000 * i
    }
    table.insert(data, item)
  end
  return data
end

function AllGuildsTab:sendDataQuery()
  if self.parentWin.useCache() and self.parentWin.cacheData[self:getKey()] then
    self.parentWin:refreshRankList(self:getKey(), self.parentWin.cacheData[self:getKey()])
    return
  end
  ed.GuildMountNetwork:sendGuildRank()
end

function AllGuildsTab:createListItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildMountAllGuildsRankItem)
  ui.bg:setPosition(ccp(0, 0))
  local size = ui.bg:getContentSize()
  ui.img_current:setVisible(data.isMyGuild)
  local rankEg = ui.label_rank
  rankEg:setVisible(false)
  local rankNode = self:createRankNode(data.guildRank)
  rankNode:setPosition(rankEg:getPosition())
  rankEg:getParent():addChild(rankNode)
  local avatarEg = ui.img_guild_icon
  avatarEg:setVisible(false)
  local guildIcon = self:createGuildIcon(data.guildIconId, data.guildIconFrameId)
  guildIcon:setScale(0.68)
  guildIcon:setPosition(avatarEg:getPosition())
  avatarEg:getParent():addChild(guildIcon)
  ed.setLabelShadow(ui.label_name, ccc3(0, 0, 0), ccp(0, 2))
  ed.setString(ui.label_name, data.guildName)
  ed.setString(ui.label_member_amount, T("\239\188\136%d\228\186\186\239\188\137", data.guildMemberCount))
  ed.right2(ui.label_member_amount, ui.label_name)
  ed.setString(ui.label_damage_desc, T("\229\189\147\229\137\141\231\167\175\229\136\134\239\188\154%d", data.guildScore))
  return container, ui, size
end

function AllGuildsTab:onClickedItem(data, x, y)
  local rank = data.data.guildRank
  local summary = data.data.rawGuildSummary
  local server = T("%s-%s\229\140\186", data.data.guildPlat, data.data.guildServerId)
  local win = ed.ui.GuildMountGuildSummary.create(rank, summary, server)
  self.parentWin.mainLayer:addChild(win.mainLayer, 100)
end

local MyGuildTab = newTabClass("my_guild")

function MyGuildTab.create(params)
  local self = {}
  setmetatable(self, MyGuildTab)
  self:init(params)
  return self
end

function MyGuildTab:getKey()
  return "MyGuildTab"
end

function MyGuildTab:getDebugData()
  local data = {}
  for i = 1, 10 do
    local item = {
      userRank = i,
      userIconId = i,
      isVIP = math.random(1, 3) == 3,
      userName = "USER" .. i,
      medalId = i,
      medalGetTime = ed.getServerTime() - 3600,
      userDamage = 1312313 * i,
      bossDamageRanks = {
        {
          bossData = {
            unitId = 101 + math.random(1, 11)
          },
          rank = math.random(1, 10)
        },
        {
          bossData = {
            unitId = 101 + math.random(1, 11)
          },
          rank = math.random(1, 10)
        },
        {
          bossData = {
            unitId = 101 + math.random(1, 11)
          },
          rank = math.random(1, 10)
        },
        {
          bossData = {
            unitId = 101 + math.random(1, 11)
          },
          rank = math.random(1, 10)
        },
        {
          bossData = {
            unitId = 101 + math.random(1, 11)
          },
          rank = math.random(1, 10)
        }
      }
    }
    table.insert(data, item)
  end
  return data
end

function MyGuildTab:sendDataQuery()
  if self.parentWin.useCache() and self.parentWin.cacheData[self:getKey()] then
    self.parentWin:refreshRankList(self:getKey(), self.parentWin.cacheData[self:getKey()])
    return
  end
  ed.GuildMountNetwork:sendScoreRank()
end

function MyGuildTab:createBossIcon(data)
  local icon = ed.CampUITool.createHeroIcon(data.unitId)
  return icon
end

function MyGuildTab:createListItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildMountMyGuildRankItem)
  ui.bg:setPosition(ccp(0, 0))
  local size = ui.bg:getContentSize()
  ui.img_current:setVisible(data.isMe)
  local rankEg = ui.label_rank
  rankEg:setVisible(false)
  local rankNode = self:createRankNode(data.userRank)
  rankNode:setPosition(rankEg:getPosition())
  rankEg:getParent():addChild(rankNode)
  local avatarEg = ui.img_user_icon
  avatarEg:setVisible(false)
  local userIcon = ed.getTeamHead({
    id = data.userAvatar,
    vip = data.isVIP
  })
  userIcon:setScale(0.8)
  userIcon:setPosition(avatarEg:getPosition())
  avatarEg:getParent():addChild(userIcon)
  ed.setString(ui.label_user_name, data.userName)
  ed.setString(ui.label_damage_desc, T("\230\128\187\231\167\175\229\136\134\239\188\154%d", data.userScore))
  local bossIconEg = ui.img_boss_icon_eg
  local bossDamageRankEg = ui.label_rank_for_boss_eg
  bossIconEg:setVisible(false)
  bossDamageRankEg:setVisible(false)
  local iconX, iconY = bossIconEg:getPosition()
  local labelX, labelY = bossDamageRankEg:getPosition()
  local iconWid = 36
  local iconGapX = 25
  for k, v in ipairs(data.bossData or {}) do
    local bossIcon = self:createBossIcon(v)
    bossIcon:setPosition(ccp(iconX, iconY))
    bossIconEg:getParent():addChild(bossIcon)
    bossIcon:setScale(iconWid / bossIcon:getContentSize().width)
    iconX = iconX + iconWid + iconGapX
    local bossDamageRankLabel = ed.createLabelTTF(T("%d%%", v.scoreRate), bossDamageRankEg:getFontSize())
    bossDamageRankLabel:setColor(ccc3(65, 56, 49))
    bossDamageRankLabel:setPosition(ccp(labelX, labelY))
    bossDamageRankEg:getParent():addChild(bossDamageRankLabel)
    labelX = labelX + iconWid + iconGapX
  end
  return container, ui, size
end

function MyGuildTab:onClickedItem(data, x, y)
  print("MyGuildTab", data, x, y)
end

local guildsummary = {}
guildsummary.__index = guildsummary
ed.ui.GuildMountGuildSummary = guildsummary
local base1 = ed.ui.popwindow
setmetatable(guildsummary, base.mt)

function guildsummary.create(index, data, server)
  local self = base1.create("GuildMountGuildSummary")
  setmetatable(self, guildsummary)
  local container = self.container
  local ui = self.ui
  ui.frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/main_vit_tips.png",
      capInsets = ed.DGRectMake(20, 20, 55, 25)
    },
    layout = {
      position = ccp(400, 240)
    },
    config = {
      scaleSize = ed.DGSizeMake(400, 287)
    }
  }, container)
  ui.content = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0),
      position = ed.DGccp(0, -22)
    },
    config = {isCascadeOpacity = true}
  }, ui.frame)
  local offDGY = 45
  ui.head = ed.createNode({
    t = "CCNode",
    base = {
      node = ed.readequip.createIcon(nil, 60, 1, {
        fres = ed.getDataTable("GuildAvatar")[ed.analyzeAvatar(data._avatar).avatar].Picture,
        bgres = ed.getDataTable("GuildAvatarFrame")[ed.analyzeAvatar(data._avatar).avatarFrame == 0 and 1 or ed.analyzeAvatar(data._avatar).avatarFrame].Picture,
        scale = 1.2,
        bgscale = 0.75
      })
    },
    layout = {
      position = ed.DGccp(70, 255 + offDGY)
    }
  }, ui.content)
  ui.name = ed.createNode({
    t = "Label",
    base = {
      text = data._name,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(130, 270 + offDGY)
    }
  }, ui.content)
  ui.id = ed.createNode({
    t = "Label",
    base = {
      text = T("ID:%d", data._id),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(130, 240 + offDGY)
    }
  }, ui.content)
  ui.serverTitle = ed.createNode({
    t = "Label",
    base = {
      text = T("\230\156\141\229\138\161\229\153\168\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 195 + offDGY)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.server = ed.createNode({
    t = "Label",
    base = {
      text = tostring(server),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.serverTitle, 10)
    }
  }, ui.content)
  if index ~= nil then
    ui.rankTitle = ed.createNode({
      t = "Label",
      base = {
        text = T("\230\142\146\229\144\141\239\188\154"),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.DGccp(40, 195)
      },
      config = {
        color = ccc3(255, 246, 141)
      }
    }, ui.content)
    ui.rank = ed.createNode({
      t = "Label",
      base = {
        text = tostring(index),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ed.getRightSidePos(ui.rankTitle, 10)
      }
    }, ui.content)
  end
  ui.managerTitle = ed.createNode({
    t = "Label",
    base = {
      text = T("\228\188\154\233\149\191\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 150)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.managerName = ed.createNode({
    t = "Label",
    base = {
      text = data._president._name,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.managerTitle, 10)
    }
  }, ui.content)
  ui.memberTitle = ed.createNode({
    t = "Label",
    base = {
      text = T("\230\136\144\229\145\152\228\186\186\230\149\176\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 105)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.memberAmount = ed.createNode({
    t = "Label",
    base = {
      text = data._member_cnt,
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.getRightSidePos(ui.memberTitle, 10)
    }
  }, ui.content)
  ui.sloganTitle = ed.createNode({
    t = "Label",
    base = {
      text = T("\229\133\172\228\188\154\229\174\163\232\168\128\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ed.DGccp(40, 60)
    },
    config = {
      color = ccc3(255, 246, 141)
    }
  }, ui.content)
  ui.slogan = ed.createNode({
    t = "Label",
    base = {
      text = data._slogan == "" and T("\230\151\160") or data._slogan,
      size = 18
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccpAdd(ed.getRightSidePos(ui.sloganTitle), ccp(9, 10))
    },
    config = {
      horizontalAlignment = kCCTextAlignmentLeft,
      verticalAlignment = kCCVerticalTextAlignmentTop,
      dimensions = ed.DGSizeMake(200, 0)
    }
  }, ui.content)
  local height = (ui.slogan:getContentSize().height - 18) * 1.28
  ui.frame:setContentSize(ed.DGSizeMake(400, 330 + height))
  ui.content:setPosition(ed.DGccp(0, -22 + height))
  self:registerTouchHandler()
  self:show()
  return self
end

function guildsummary:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.frame,
    key = "out_click",
    force = true,
    clickInterval = 0.2,
    clickHandler = function()
      self:destroy()
    end
  })
end
