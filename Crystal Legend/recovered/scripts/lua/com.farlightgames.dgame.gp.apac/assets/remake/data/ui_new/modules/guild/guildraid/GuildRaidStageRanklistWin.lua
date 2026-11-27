local base = ed.ui.popwindow
local GuildRaidStageRanklistWin = newclass(base.mt)
ed.ui.GuildRaidStageRanklistWin = GuildRaidStageRanklistWin

function GuildRaidStageRanklistWin.create(param)
  local self = base.create("GuildRaidStageRanklistWin")
  setmetatable(self, GuildRaidStageRanklistWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow(500)
  return self
end

function GuildRaidStageRanklistWin:getRaidNameByStageId(stageId)
  local stageName = ed.getDataTable("Stage")[self.stageId]["Stage Name"]
  local chapterId = ed.getDataTable("Stage")[self.stageId]["Chapter ID"]
  local chapterName = ed.getDataTable("Chapter")[chapterId]["Chapter Name"]
  return chapterName
end

function GuildRaidStageRanklistWin:isBossStage(stageId)
  local raidInfo = ed.GuildRaidManager.raidInfo
  for raidId, raid in ipairs(raidInfo) do
    if raid.stages[#raid.stages].stageId == stageId then
      return true
    end
  end
  return false
end

function GuildRaidStageRanklistWin:initData(param)
  self.mgr = ed.GuildManager
  self.raidMgr = ed.GuildRaidManager
  self.data = param
  self.stageId = param._stage_id
end

function GuildRaidStageRanklistWin:initLabels()
end

function GuildRaidStageRanklistWin:createFastPassGuild()
  local container, ui = ed.editorui(ed.uieditor.RaidRankGuildItem)
  ui.title:setString(string.format(T("%s(\229\155\162\233\152\159)"), self:getRaidNameByStageId(self.stageId)))
  if self.data._fast_pass then
    local data = self.data._fast_pass
    ui.name:setString(data._name)
    local hData = ed.analyzeAvatar(data._icon)
    local guildIcon = ed.createGuildAvatar(hData.avatar, hData.avatarFrame)
    ed.UITool.replaceUI(ui, "layer_main", "avatar", guildIcon)
    guildIcon:setScale(0.6)
    local timeStr = ed.getdhmsCString(data._time)
    local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\233\128\154\229\133\179\232\128\151\230\151\182:</lable>") .. "<lable color=ccc3(255,165,49) strokeColor=strokeColor1 strokeSize=1>%s</lable>", timeStr)
    local labelTime = ed.ui.autoText.new()
    labelTime:initParam({context = strs, fontSize = 14})
    local x, y = ui.time:getPosition()
    labelTime.node:setPosition(ccp(x + 40, y))
    ui.layer_main:addChild(labelTime.node)
    local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\229\133\172\228\188\154ID:</lable>") .. "<lable color=ccc3(255,165,49) strokeColor=strokeColor1 strokeSize=1>%s</lable>", data._id)
    local labelGID = ed.ui.autoText.new()
    labelGID:initParam({context = strs, fontSize = 14})
    local x, y = ui.id:getPosition()
    labelGID.node:setPosition(ccp(x, y))
    ui.layer_main:addChild(labelGID.node)
  else
    ui.layer_main:setVisible(false)
    ui.label_none:setVisible(true)
  end
  return container
end

function GuildRaidStageRanklistWin:createStageFirstKill()
  local container, ui = ed.editorui(ed.uieditor.RaidRankFirstItem)
  ui.title:setString(string.format(T("%s(\229\155\162\233\152\159)"), ed.getDataTable("Stage")[self.stageId]["Stage Name"]))
  if self.data._first_pass then
    local summary = self.data._first_pass._summary
    local headIcon = ed.getWholeHeadIcon({
      id = summary._avatar,
      name = summary._name,
      medal = summary._medal,
      config = {
        namefont = "main_icon_name",
        nameBgOffset = -6,
        nameposition = -6
      },
      level = summary._level,
      lvoffset = {x = -48, y = -25},
      scale = 0.7
    })
    ed.UITool.replaceUI(ui, "layer_main", "avatar", headIcon)
    local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\230\157\165\232\135\170\229\133\172\228\188\154:</lable>") .. "<lable color=ccc3(255,165,49) strokeColor=strokeColor1 strokeSize=1>%s</lable>", summary._guild_name)
    local labelGuild = ed.ui.autoText.new()
    labelGuild:initParam({context = strs, fontSize = 14})
    local x, y = ui.id:getPosition()
    labelGuild.node:setPosition(ccp(x, y))
    ui.layer_main:addChild(labelGuild.node)
    local timeStr = ed.getYMDHMSTime(ed.time2Server(self.data._first_pass._pass_time))
    local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\229\135\187\230\157\128\230\151\182\233\151\180:</lable>") .. "<lable color=ccc3(255,165,49) strokeColor=strokeColor1 strokeSize=1>%s</lable>", timeStr .. ed.getUTCLabel())
    local labelFirstTime = ed.ui.autoText.new()
    labelFirstTime:initParam({context = strs, fontSize = 14})
    local x, y = ui.time:getPosition()
    local wid, hei = labelFirstTime:getCurContentSize()
    labelFirstTime.node:setPosition(ccp(x - wid, y))
    ui.layer_main:addChild(labelFirstTime.node)
  else
    ui.label_none:setVisible(true)
    ui.avatar:setVisible(false)
  end
  return container
end

local GuildRaidStageRanklistWin = ed.ui.GuildRaidStageRanklistWin

function GuildRaidStageRanklistWin:createStageMostDpsItem(rank, v)
  local container, ui = ed.editorui(ed.uieditor.RaidRankDamageItem)
  if rank == 1 then
    local rank = ed.createSprite("UI/alpha/1080P/rankingscene/ranking_yellow.png")
    local rank_num = ed.createSprite("UI/alpha/1080P/rankingscene/1st.png")
    local size = rank:getContentSize()
    rank_num:setPosition(ccp(size.width / 2, size.height / 2))
    rank:addChild(rank_num)
    ed.UITool.replaceUI(ui, "bg", "rank", rank)
  elseif rank == 2 then
    local rank = ed.createSprite("UI/alpha/1080P/rankingscene/ranking_blue.png")
    local rank_num = ed.createSprite("UI/alpha/1080P/rankingscene/2nd.png")
    local size = rank:getContentSize()
    rank_num:setPosition(ccp(size.width / 2, size.height / 2))
    rank:addChild(rank_num)
    ed.UITool.replaceUI(ui, "bg", "rank", rank)
  elseif rank == 3 then
    local rank = ed.createSprite("UI/alpha/1080P/rankingscene/ranking_gold.png")
    local rank_num = ed.createSprite("UI/alpha/1080P/rankingscene/3rd.png")
    local size = rank:getContentSize()
    rank_num:setPosition(ccp(size.width / 2, size.height / 2))
    rank:addChild(rank_num)
    ed.UITool.replaceUI(ui, "bg", "rank", rank)
  else
    local rank = ed.getNumberNode({text = rank, folder = "big_pvp"}).node
    ed.UITool.replaceUI(ui, "bg", "rank", rank)
  end
  local summary = v._dps_user
  local headIcon = ed.getWholeHeadIcon({
    id = summary._avatar,
    name = summary._name,
    medal = summary._medal,
    config = {
      namefont = "main_icon_name",
      nameBgOffset = -6,
      nameposition = -6
    },
    level = summary._level,
    lvoffset = {x = -48, y = -25},
    scale = 0.7
  })
  ed.UITool.replaceUI(ui, "bg", "avatar", headIcon)
  local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\230\157\165\232\135\170\229\133\172\228\188\154:</lable>") .. "<lable color=ccc3(255,165,49) strokeColor=strokeColor1 strokeSize=1>%s</lable>", summary._guild_name)
  local labelGuild = ed.ui.autoText.new()
  labelGuild:initParam({context = strs, fontSize = 14})
  local x, y = ui.guild:getPosition()
  labelGuild.node:setPosition(ccp(x, y - 3))
  ui.bg:addChild(labelGuild.node)
  local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\229\141\149\230\172\161\228\188\164\229\174\179:</lable>") .. "<lable color=ccc3(255,165,49) strokeColor=strokeColor1 strokeSize=1>%s</lable>", v._dps)
  local labelDamage = ed.ui.autoText.new()
  labelDamage:initParam({context = strs, fontSize = 14})
  local x, y = ui.damage:getPosition()
  labelDamage.node:setPosition(ccp(x + 35, y))
  ui.bg:addChild(labelDamage.node)
  
  local function sortHeroes(list)
    local function attackRange(hid)
      local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
      
      return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0) or 0
    end
    
    table.sort(list, function(a, b)
      return attackRange(a._tid) < attackRange(b._tid)
    end)
  end
  
  sortHeroes(v._heroes)
  for i = 1, 5 do
    if v._heroes[i] then
      local heroIcon = ed.readhero.createIconByServer(v._heroes[i]).icon
      heroIcon:setScale(0.5)
      ed.UITool.replaceUI(ui, "bg", "hero" .. i, heroIcon)
    else
      ui["hero" .. i]:setVisible(false)
    end
  end
  return container
end

function GuildRaidStageRanklistWin:refreshDraglist()
  self.draglist:clearList()
  local size = self.ui.layer_item:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  if self:isBossStage(self.stageId) then
    local container = self:createFastPassGuild()
    container:setPositionY(oy - 130)
    self.draglist:addItem(container)
    oy = oy - 130
  end
  local container = self:createStageFirstKill()
  container:setPositionY(oy - 130)
  self.draglist:addItem(container)
  oy = oy - 138
  local container, ui = ed.editorui(ed.uieditor.RaidRankTitle)
  ui.title:setString(T("\230\156\172\230\156\141\230\156\128\233\171\152\228\188\164\229\174\179\232\174\176\229\189\149"))
  container:setPosition(ccp(ox, oy - 15))
  self.draglist:addItem(container)
  oy = oy - 30
  if not self.data._dps_rank or #self.data._dps_rank == 0 then
    local label = ed.createLabelTTF(T("\230\154\130\230\151\182\230\178\161\230\156\137\228\188\164\229\174\179\232\174\176\229\189\149"), 15)
    ed.setLabelColor(label, ccc3(207, 170, 95))
    label:setPosition(ccp(ox, oy - 20))
    self.draglist:addItem(label)
    oy = oy - 40
  else
    for rank, v in ipairs(self.data._dps_rank) do
      local container = self:createStageMostDpsItem(rank, v)
      container:setPosition(ccp(ox, oy - 56))
      self.draglist:addItem(container)
      oy = oy - 112
    end
  end
  self.draglist:initListHeight(size.height - oy)
end

function GuildRaidStageRanklistWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.RaidRanklistWin)
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {priority = -331})
  self:refreshDraglist()
end

function GuildRaidStageRanklistWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function GuildRaidStageRanklistWin:popWindow(zOrder)
  base.popWindow(self, zOrder)
end

function GuildRaidStageRanklistWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self, {})
end
