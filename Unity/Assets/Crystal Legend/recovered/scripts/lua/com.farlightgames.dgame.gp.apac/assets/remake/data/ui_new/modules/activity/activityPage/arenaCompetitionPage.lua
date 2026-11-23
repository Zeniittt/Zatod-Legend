local class = {}
ed.ui.activityArenaCompetitionPage = class
local RankNumRes = {
  [1] = "UI/alpha/1080P/toparena/rank/rank_1st.png",
  [2] = "UI/alpha/1080P/toparena/rank/rank_2nd.png",
  [3] = "UI/alpha/1080P/toparena/rank/rank_3rd.png"
}
local RankBgRes = {
  [0] = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_rank4+.png",
  [1] = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_rank1.png",
  [2] = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_rank2.png",
  [3] = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_rank3.png"
}

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.pageKey = pageKey
  self.taskList = param._tasks
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.activityTime = param._expire_time or 0
  self.actiDataTable = ed.getDataTable("Activity")[self.cfgId]
  self.rankStartTime = nil
  self.rewardEndTime = nil
  self.showEndTime = nil
  self.isVisible = true
  self:initView()
  self:addListenEvent()
  self.objWork:sendArenaCompetitionReq("_open_panel")
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_arena_competition_page)
  self.container = container
  self.ui = ui
  ed.setLabelStroke(self.ui.label_end_time, ed.toccc3(6499103), 1.5)
  ed.setLabelStroke(self.ui.label_frame_name, ed.toccc3(4988435), 1)
  ed.setLabelStroke(self.ui.label_rank_time_des, ed.toccc3(6365966), 1.5)
  ed.setLabelStroke(self.ui.label_start_time_hour, ed.toccc3(6103578), 2.5)
  ed.setLabelStroke(self.ui.label_start_time_min, ed.toccc3(6103578), 2.5)
  ed.setLabelStroke(self.ui.label_start_time_sec, ed.toccc3(6103578), 2.5)
  ed.setLabelStroke(self.ui.label_start_time_mark1, ed.toccc3(6103578), 2.5)
  ed.setLabelStroke(self.ui.label_start_time_mark2, ed.toccc3(6103578), 2.5)
  ed.setLabelStroke(self.ui.label_member, ed.toccc3(2565412), 1)
  self.ui.bg_prepare:setVisible(false)
  self.ui.panel_rank:setVisible(false)
  self.ui.btn_member:setVisible(false)
  self.ui.bg_my_rank:setVisible(false)
  ed.setLabelString(self.ui.label_end_time, "")
  self:adaptUI()
  self:listenTimer(Timer:Always(0.3), function()
    self:refreshCountDownUI(false)
  end)
end

function class:adaptUI()
  self.ui.btn_member:setPositionX(self.ui.btn_member:getPositionX() + ed.display.halfFixedWidth * 0.5)
end

function class:pageUpDate(param)
  self.activityTime = param._expire_time or 0
end

function class:refreshView(reply)
  if reply._prepare_panel then
    self.ui.bg_prepare:setVisible(true)
    self.ui.panel_rank:setVisible(false)
    self.ui.btn_member:setVisible(false)
    self.rankStartTime = reply._prepare_panel._rank_time
    self.rewardEndTime = reply._prepare_panel._tally_time
    self.isTallyEnd = false
    self.guildInfoList = {}
    self:refreshDesInfo()
    self:refreshCountDownUI(true)
  elseif reply._score_rankboard then
    self.ui.bg_prepare:setVisible(false)
    self.ui.panel_rank:setVisible(true)
    self.rankStartTime = nil
    self.rewardEndTime = reply._score_rankboard._tally_time
    self.guildInfoList = reply._score_rankboard._guild_infos or {}
    self.myGuildInfo = reply._score_rankboard._my_guild_info
    self.isTallyEnd = reply._score_rankboard._is_tally_end == 1
    if self.isTallyEnd and ed.getServerTime() > self.rewardEndTime then
      self.rewardEndTime = nil
    end
    self.showEndTime = self.activityTime
    self:refreshRankInfo()
    self:refreshRewardInfo()
    self:refreshCountDownUI(true)
  elseif reply._query_members then
    ed.ui.arenaCompetitionMemberWin.create(reply._query_members):popWindow()
  end
end

function class:createRankItem(rankData)
  local container, ui = ed.editorui(ed.uieditor.activity_arena_competition_rank_item)
  container:setContentSize(ui.bg:getContentSize())
  self:refreshRankItem(ui, rankData, false)
  return container, ui
end

function class:refreshRankItem(ui, rankData, isMe)
  local rank = rankData._rank or 0
  local score = rankData._score or 0
  local summary = rankData._summary
  if not isMe then
    ed.setTexture(ui.bg, RankBgRes[rank] or RankBgRes[0], true)
  end
  if RankNumRes[rank] then
    ui.img_rank:setVisible(true)
    ui.label_rank:setVisible(false)
    ed.setTexture(ui.img_rank, RankNumRes[rank], true)
  else
    ui.img_rank:setVisible(false)
    ui.label_rank:setVisible(true)
    ed.setLabelString(ui.label_rank, 0 == rank and T("\230\156\170\228\184\138\230\166\156") or rank)
    ui.label_rank:limitWidthByScale(120)
    ui.label_rank:setFontSize(0 == rank and 26 or 35)
    ed.setLabelStroke(ui.label_rank, ed.toccc3(5908523), 2)
    ed.setLabelFontName(ui.label_rank, ed.fontBold)
  end
  ed.setLabelStroke(ui.label_guild_name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_score_des, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_chairman_name, ed.toccc3(3547142), 1)
  ed.setLabelString(ui.label_guild_name, summary._name or "")
  ed.setLabelString(ui.label_chairman_name, T("\228\188\154\233\149\191\239\188\154%s", summary._president._name or ""))
  ui.panel_score:removeAllChildrenWithCleanup(true)
  local scoreTxt = ed.getNumberNode({text = score, folder = "peak_score"}).node
  scoreTxt:setScale(0.75)
  ui.panel_score:addChild(scoreTxt)
  ed.layout.centerInParent(scoreTxt)
  local avatarData = ed.analyzeAvatar(summary._avatar)
  local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  guildIcon:setScale(ui.img_guild_frame:getScaleX())
  ed.UITool.replaceUI(ui, isMe and "bg_my_rank" or "bg", "img_guild_frame", guildIcon)
end

function class:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
  if isVisible then
    CloseTimer("arena_competition_refresh_panel")
    self.objWork:sendArenaCompetitionReq("_open_panel")
  end
end

function class:refreshDesInfo()
  if nil == self.ui.ruleDraglist then
    local rulePanelSize = self.ui.panel_rule:getContentSize()
    local autoText = ed.ui.autoText.new()
    local str = T("1\227\128\129\230\180\187\229\138\168\228\184\186\230\156\172\230\156\141\230\180\187\229\138\168\239\188\140\233\152\159\233\149\191\229\156\168\230\175\143\230\151\165\231\171\158\230\138\128\229\156\186\231\187\147\231\174\151\230\151\182\239\188\140\230\160\185\230\141\174<lable color=ccc3(255,230,112)>\228\184\170\228\186\186\230\142\146\229\144\141</lable>\232\142\183\229\190\151\229\175\185\229\186\148\231\154\132\231\167\175\229\136\134\227\128\130<br/>") .. T("2\227\128\129\229\133\172\228\188\154<lable color=ccc3(255,230,112)>\230\137\128\230\156\137\230\136\144\229\145\152</lable>\231\154\132\231\171\158\230\138\128\229\156\186\231\167\175\229\136\134\229\176\134\231\180\175\229\138\160\239\188\140\229\189\162\230\136\144\229\133\172\228\188\154\230\128\187\231\167\175\229\136\134\239\188\140\229\185\182\232\191\155\232\161\140\230\156\172\230\156\141\229\133\172\228\188\154\230\142\146\229\144\141\227\128\130<br/>") .. T("3\227\128\129\230\180\187\229\138\168\230\140\129\231\187\1737\229\164\169\239\188\140\229\176\134\229\156\168<lable color=ccc3(255,230,112)>\231\172\1727\229\164\169\231\171\158\230\138\128\229\156\186\231\187\147\231\174\151\229\144\142</lable>\232\191\155\232\161\140\230\156\172\230\156\141\229\133\172\228\188\154\230\142\146\229\144\141\231\187\147\231\174\151\227\128\130<br/>") .. T("4\227\128\129\230\156\172\230\156\141\230\142\146\229\144\141\231\172\172\228\184\128\231\154\132\229\133\172\228\188\154\239\188\140<lable color=ccc3(255,230,112)>\229\133\172\228\188\154\230\136\144\229\145\152</lable>\229\143\175\232\142\183\229\190\151\229\134\160\229\134\155\229\164\180\229\131\143\230\161\134\229\165\150\229\138\177\239\188\140<lable color=ccc3(255,230,112)>\229\133\172\228\188\154</lable>\229\143\175\232\142\183\229\190\151\229\133\172\228\188\154\229\134\160\229\134\155\229\164\180\229\131\143\230\161\134\229\165\150\229\138\177")
    autoText:initParam({
      context = str,
      fontSize = 14,
      color = ed.toccc3(16776423),
      strokeColor = ed.toccc3(6365978),
      strokeSize = 1,
      lineSpacing = 4,
      maxWidth = rulePanelSize.width - 20,
      isTripLastSpacing = true
    })
    local desWidth, desHeight = autoText:getCurContentSize()
    local desDraglist = ed.UITool.createDraglist(self.ui.panel_rule, {})
    desDraglist:addItem(autoText.node)
    local offsetY = 0
    if desHeight < rulePanelSize.height then
      offsetY = (rulePanelSize.height - desHeight) * 0.5
    end
    offsetY = offsetY + autoText:getFirstLineHeight() * 0.5
    autoText.node:setPosition(ccp(10, rulePanelSize.height - offsetY))
    desDraglist:initListHeight(desHeight)
    self.ui.ruleDraglist = desDraglist
  end
end

function class:refreshRankInfo()
  if nil == self.rankTableview then
    local delegate = {
      numberOfCells = function()
        return #self.guildInfoList
      end,
      cellSizeFromIndex = function(index)
        return CCSizeMake(540, 92)
      end,
      createCell = function(index)
        local rankData = self.guildInfoList[index]
        return self:createRankItem(rankData)
      end,
      doClickIn = function(cell, x, y)
        if not self.isVisible then
          return
        end
        local ui = cell.data
        local icon = ui.img_guild_frame.icon
        if nil ~= icon and ed.containsPoint(icon, x, y) then
          local rankData = self.guildInfoList[cell.idx]
          self:showGuildSummary(rankData._rank, rankData._summary)
        end
      end,
      doPressIn = function(cell, x, y)
        local ui = cell.data
        if ui then
          local icon = ui.img_guild_frame.icon
          if ed.containsPoint(icon, x, y) then
            ui.img_guild_frame:setScale(0.71)
          end
        end
      end,
      cancelPressIn = function(cell, x, y)
        local ui = cell.data
        if ui then
          ui.img_guild_frame:setScale(0.75)
        end
      end
    }
    local size = self.ui.panel_rank:getContentSize()
    local param = {
      delegate = delegate,
      cliprect = CCRectMake(0, 0, size.width, size.height),
      padding = {width = 0, height = -3},
      container = self.ui.panel_rank,
      touchpriority = -300,
      zorder = 10,
      dragMode = 1,
      noshade = true,
      colNum = 1
    }
    self.rankTableview = Tableview.create(param)
  end
  self.rankTableview:reloadData()
  if self.myGuildInfo then
    self.ui.btn_member:setVisible(true)
    if not self.isTallyEnd then
      self.ui.bg_my_rank:setVisible(true)
      self.ui.bg_my_rank:setZOrder(20)
      self:refreshRankItem(self.ui, self.myGuildInfo, true)
      self.rankTableview:getDragList():initListHeight(self.rankTableview:getDragList():getListHeight() + 30)
    else
      self.ui.bg_my_rank:setVisible(false)
    end
  else
    self.ui.bg_my_rank:setVisible(false)
    self.ui.btn_member:setVisible(false)
  end
end

function class:showGuildSummary(rank, summary)
  local guildSummary = {
    _avatar = summary._avatar,
    _name = summary._name,
    _id = summary._name,
    _president = summary._president,
    _member_cnt = summary._member_cnt,
    _slogan = summary._slogan
  }
  ed.ui.guildSummaryWin.create(rank, guildSummary):popWindow()
end

function class:refreshRewardInfo()
  if self.ui.img_head_icon then
    self.ui.img_head_icon:removeFromParentAndCleanup(true)
    self.ui.img_head_icon = nil
  end
  if self.isTallyEnd and #self.guildInfoList > 0 then
    local championData = self.guildInfoList[1]
    local avatarData = ed.analyzeAvatar(championData._summary._avatar)
    local avatarTable = ed.getDataTable("GuildAvatar")
    local avatarId = avatarTable[avatarData.avatar] and avatarData.avatar or 1
    local iconRes = avatarTable[avatarId].Picture
    local headImg = ed.createSprite(iconRes)
    self.ui.img_frame_bg:addChild(headImg, 0)
    headImg:setScale(100 / headImg:getContentSize().width - 0.05)
    local bgSize = self.ui.img_frame_bg:getContentSize()
    headImg:setPosition(bgSize.width * 0.5 - 4, bgSize.height * 0.5 + 5)
    self.ui.img_head_icon = headImg
    self.ui.img_frame_icon:setZOrder(1)
  end
end

function class:refreshCountDownUI(isInit)
  if not self.isVisible then
    return
  end
  if nil ~= self.rankStartTime then
    local diffTime = self.rankStartTime - ed.getServerTime()
    if diffTime <= 0 then
      diffTime = 0
      self.rankStartTime = nil
      self.showEndTime = nil
      CloseTimer("arena_competition_refresh_panel")
      self:listenTimer(Timer:Once(isInit and 3 or 1, "arena_competition_refresh_panel"), function()
        self.objWork:sendArenaCompetitionReq("_open_panel")
      end)
    end
    local h, m, s = ed.second2hms(diffTime)
    ed.setLabelString(self.ui.label_start_time_hour, string.format("%02d", h))
    ed.setLabelString(self.ui.label_start_time_min, string.format("%02d", m))
    ed.setLabelString(self.ui.label_start_time_sec, string.format("%02d", s))
  end
  if nil ~= self.rewardEndTime then
    local diffTime = self.rewardEndTime - ed.getServerTime()
    if diffTime <= 0 then
      diffTime = 0
      self.rewardEndTime = nil
      self.showEndTime = nil
      CloseTimer("arena_competition_refresh_panel")
      self:listenTimer(Timer:Once(isInit and 3 or 1, "arena_competition_refresh_panel"), function()
        self.objWork:sendArenaCompetitionReq("_open_panel")
      end)
    end
    local str = T("\231\187\147\231\174\151\229\128\146\232\174\161\230\151\182\239\188\154%s", ed.time2dhms(diffTime))
    ed.setLabelString(self.ui.label_end_time, str)
    self.ui.label_end_time:limitWidthByScale(180)
  elseif nil ~= self.showEndTime then
    local diffTime = self.showEndTime - ed.getServerTime()
    if diffTime <= 0 then
      diffTime = 0
      self.showEndTime = nil
    end
    local str = T("\229\177\149\231\164\186\229\128\146\232\174\161\230\151\182\239\188\154%s", ed.time2dhms(diffTime))
    ed.setLabelString(self.ui.label_end_time, str)
    self.ui.label_end_time:limitWidthByScale(180)
  end
end

function class:addListenEvent()
  self:listenPageEvent("activity_arena_competition_reply", function(reply)
    self:refreshView(reply)
  end)
  ed.UITool.registerBtn(self, "btn_member", function()
    self.objWork:sendArenaCompetitionReq("_query_members")
  end, {pressScale = 0.9})
end
