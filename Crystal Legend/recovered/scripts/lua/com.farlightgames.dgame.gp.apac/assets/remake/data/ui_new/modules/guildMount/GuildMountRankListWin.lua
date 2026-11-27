local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.GuildMountRankListWin = class
local RankType = {
  Zone_Guild = 1,
  Zone_Personal = 2,
  Guild_Total = 3,
  Guild_Today = 4
}
local TAB_DESC = {
  [RankType.Zone_Guild] = T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\229\133\172\228\188\154\229\156\168\232\181\155\229\140\186\229\134\133\230\142\146\229\144\141\229\143\145\230\148\190\229\133\168\229\145\152\229\165\150\229\138\177"),
  [RankType.Zone_Personal] = T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\233\152\159\233\149\191\229\156\168\232\181\155\229\140\186\229\134\133\230\142\146\232\161\140\229\143\145\230\148\190\229\165\150\229\138\177"),
  [RankType.Guild_Total] = T("\230\180\187\229\138\168\230\156\159\233\151\180\229\134\133\239\188\140\230\137\128\230\156\137\229\133\172\228\188\154\230\136\144\229\145\152\231\154\132\230\128\187\231\167\175\229\136\134\230\142\146\232\161\140"),
  [RankType.Guild_Today] = T("\230\140\145\230\136\152\232\174\176\229\189\149\239\188\140\228\188\154\232\174\176\229\189\149\233\152\159\233\149\191\228\187\138\230\151\165\230\175\143\230\172\161\231\187\147\231\174\151\230\137\128\230\137\147boss")
}
local TAB_TO_TITLE_RES = {
  [RankType.Zone_Guild] = T("\229\133\172\228\188\154\230\142\146\232\161\140"),
  [RankType.Zone_Personal] = T("\228\184\170\228\186\186\230\142\146\232\161\140"),
  [RankType.Guild_Total] = T("\230\128\187\231\167\175\229\136\134"),
  [RankType.Guild_Today] = T("\228\187\138\230\151\165\231\167\175\229\136\134")
}
local TREE_BTN_RES = {
  {
    normal = "UI/alpha/1080P/guildmount/rank/tab_unselected.png",
    press = "UI/alpha/1080P/guildmount/rank/tab_selected.png",
    height = 70
  },
  {
    normal = "UI/alpha/1080P/guildmount/rank/littletab_unselected.png",
    press = "UI/alpha/1080P/guildmount/rank/littletab_selected.png",
    height = 40,
    topMargin = 14
  }
}
local RANK_BG = {
  [1] = "UI/alpha/1080P/guildmount/rank/first_floor.png",
  [2] = "UI/alpha/1080P/guildmount/rank/second_floor.png",
  [3] = "UI/alpha/1080P/guildmount/rank/third_floor.png"
}
local RANK_TO_RESOURCES = {
  [1] = "UI/alpha/1080P/toparena/rank/rank_1st.png",
  [2] = "UI/alpha/1080P/toparena/rank/rank_2nd.png",
  [3] = "UI/alpha/1080P/toparena/rank/rank_3rd.png"
}

local function formatScore(num)
  if ed.getCurArea() == "en" then
    if num < 100000 then
      return num
    end
    if num <= 1000000 then
      return string.format("%dK", num / 1000)
    end
    return string.format("%d" .. T("\228\184\135"), num / 1000)
  else
    if num < 100000 then
      return num
    end
    if num <= 1000000 then
      return string.format("%0.1f", num / 10000) .. T("\228\184\135")
    end
    return string.format("%d", num / 10000) .. T("\228\184\135")
  end
end

function class.create(param)
  local self = base.create("GuildMountRankListWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.rankListTab = {}
  self.curRankType = RankType.Zone_Guild
  self.tableView = nil
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self.accordionlist:passTreeIndex(true, 1, 1)
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMountRankListWin)
  self.container:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initTableView()
  if self.titleGradientTxt and not tolua.isnull(self.titleGradientTxt.node) then
    self.titleGradientTxt.node:removeFromParentAndCleanup(true)
    self.titleGradientTxt = nil
  end
  self.titleGradientTxt = ed.ui.gradientLabel.create({
    text = "",
    fontSize = 25,
    startColor = ed.toccc3(16777213),
    endColor = ed.toccc3(16711611),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(12675619)
  })
  self.ui.panel_title:addChild(self.titleGradientTxt.node)
  ed.layout.centerInParent(self.titleGradientTxt.node)
  ed.setLabelStroke(self.ui.label_player_name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(self.ui.label_boss_des, ed.toccc3(2233605), 1)
  ed.setLabelStroke(self.ui.label_guild_name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(self.ui.label_server_name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(self.ui.label_score_des, ed.toccc3(7618585), 1.5)
  ed.setLabelStroke(self.ui.label_boss_tips, ed.toccc3(5586983), 1)
  self.ui.bg_self:setVisible(false)
  self.ui.img_boss_tips:setVisible(false)
  self.accordionlist = ed.accordion.createAccordion(self.ui.layer_btn, {
    priority = -300,
    vertex = {
      winLeft = -75,
      winRight = 0,
      winTop = 10,
      winBottom = 10
    },
    isTrigger = function()
      return not self.isWaitNetworkReply
    end,
    doClickOut = function(isPas, data)
      self:changeTab(isPas, data)
    end,
    doAllClickOut = function(isLeaf, isPas, data)
    end,
    isBoom = true,
    treeBtnRes = TREE_BTN_RES,
    anchor = 0,
    isTakeBack = true
  })
  local treeNodeList = {
    {
      name = T("<lable color=ccc3(144,132,156) fontSize=f18 strokeColor=guildMountRankTab1StrokeColor1 strokeSize=1.5>\232\181\155\229\140\186</lable> "),
      name2 = T("<lable color=ccc3(254,255,205) fontSize=f18 strokeColor=guildMountRankTab1StrokeColor2 strokeSize=1.5>\232\181\155\229\140\186</lable> "),
      nameOffset = ccp(-8, 0),
      limitWidth = 80,
      tree = {
        {
          name = T("<lable color=ccc3(144,132,156) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor1 strokeSize=1>\229\133\172\228\188\154\230\142\146\232\161\140</lable>"),
          name2 = T("<lable color=ccc3(254,255,205) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor2 strokeSize=1>\229\133\172\228\188\154\230\142\146\232\161\140</lable>"),
          data = {
            rankType = RankType.Zone_Guild
          },
          limitWidth = 80
        },
        {
          name = T("<lable color=ccc3(144,132,156) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor1 strokeSize=1>\228\184\170\228\186\186\230\142\146\232\161\140</lable>"),
          name2 = T("<lable color=ccc3(254,255,205) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor2 strokeSize=1>\228\184\170\228\186\186\230\142\146\232\161\140</lable>"),
          data = {
            rankType = RankType.Zone_Personal
          },
          limitWidth = 80
        }
      }
    },
    {
      name = T("<lable color=ccc3(144,132,156) fontSize=f18 strokeColor=guildMountRankTab1StrokeColor1 strokeSize=1>\230\156\172\229\133\172\228\188\154</lable> "),
      name2 = T("<lable color=ccc3(254,255,205) fontSize=f18 strokeColor=guildMountRankTab1StrokeColor2 strokeSize=2>\230\156\172\229\133\172\228\188\154</lable> "),
      nameOffset = ccp(-8, 0),
      limitWidth = 80,
      tree = {
        {
          name = T("<lable color=ccc3(144,132,156) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor1 strokeSize=1>\230\128\187\231\167\175\229\136\134</lable>"),
          name2 = T("<lable color=ccc3(254,255,205) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor2 strokeSize=1>\230\128\187\231\167\175\229\136\134</lable>"),
          data = {
            rankType = RankType.Guild_Total
          },
          limitWidth = 80
        },
        {
          name = T("<lable color=ccc3(144,132,156) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor1 strokeSize=1>\228\187\138\230\151\165\231\167\175\229\136\134</lable>"),
          name2 = T("<lable color=ccc3(254,255,205) fontSize=f17 strokeColor=guildMountRankTab2StrokeColor2 strokeSize=1>\228\187\138\230\151\165\231\167\175\229\136\134</lable>"),
          data = {
            rankType = RankType.Guild_Today
          },
          limitWidth = 80
        }
      }
    }
  }
  self.accordionlist:addAcclist(treeNodeList)
end

function class:adaptUI()
  local scale = ed.display.winSize.width / 1035
  scale = math.min(scale, 1)
  self.changeScale = scale
  self.ui.bg:setScale(scale)
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  local offSizeHeight = size.height * (1 - self.changeScale)
  size.width = size.width * self.changeScale
  size.height = size.height * self.changeScale
  self.srcSize = size
  local delegate = {
    numberOfCells = function()
      return self:getRankDataCount(self.curRankType)
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(694, 81)
    end,
    createCell = function(index)
      local data = self:getRankDataItem(self.curRankType, index)
      local itemContainer, ui = self:createRankItem(index, data)
      return itemContainer, {
        rank = index,
        rankData = data,
        ui = ui
      }
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      if ed.containsPoint(ui.bg, x, y) then
        return cell
      end
    end,
    doClickIn = function(cell, x, y)
      local ui = cell.data.ui
      local rankData = cell.data.rankData
      local rank = cell.data.rank
      if ed.containsPoint(ui.layer_head, x, y) and not ed.newShowMedalPop then
        if self.curRankType == RankType.Zone_Guild then
          if nil ~= rankData._guild_summary then
            ed.ui.guildSummaryWin.create(rank, rankData._guild_summary):popWindow()
          end
        elseif (self.curRankType == RankType.Zone_Personal or self.curRankType == RankType.Guild_Total or self.curRankType == RankType.Guild_Today) and nil ~= rankData._user_summary then
          ed.UITool.openView("playerInfoPanel", rankData._user_summary._role_id)
        end
      end
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    offset = {0, offSizeHeight},
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true,
    padding = {width = 0, height = 2}
  }
  self.tableView = Tableview.create(param)
end

function class:tableViewDoMove()
  local function handler()
    local x, y = self.tableView:getListPos()
    
    local listHeight = self.tableView.dragList.listHeight or 0
    if y > listHeight - 90 and listHeight > self.ui.list_layer:getContentSize().height - 30 then
    else
      self.ui.bg_self:setVisible(true)
    end
  end
  
  return handler
end

function class:createRankItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.GuildMountRankItem)
  container:setContentSize(self.tableView:cellSizeFromIndex(index))
  ed.layout.centerInParent(ui.bg)
  local rank = index
  ed.setLabelStroke(ui.label_player_name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_guild_name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_server_name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_score_des, ed.toccc3(7618585), 1.5)
  local rankBg = RANK_BG[rank] or RANK_BG[3]
  ed.setTexture(ui.bg, rankBg)
  ui.panel_rank:removeAllChildrenWithCleanup(true)
  if RANK_TO_RESOURCES[rank] then
    local imageRanking = ed.createSprite(RANK_TO_RESOURCES[rank])
    ui.panel_rank:addChild(imageRanking)
    ed.layout.centerInParent(imageRanking)
  else
    local text = ed.getNumberNode({
      text = rank or 0,
      folder = "peakarena_rank"
    }).node
    ui.panel_rank:addChild(text)
    ed.layout.centerInParent(text)
  end
  local isPlayerRank = RankType.Zone_Personal == self.curRankType or RankType.Guild_Total == self.curRankType or RankType.Guild_Today == self.curRankType
  local isGuildRank = RankType.Zone_Guild == self.curRankType
  ui.label_player_name:setVisible(isPlayerRank)
  ui.label_guild_name:setVisible(isGuildRank)
  ui.label_server_name:setVisible(RankType.Zone_Guild == self.curRankType or RankType.Zone_Personal == self.curRankType)
  ui.label_boss_des:setVisible(RankType.Guild_Today == self.curRankType)
  ui.list_boss_layer:setVisible(RankType.Guild_Today == self.curRankType)
  ui.layer_head:removeAllChildrenWithCleanup(true)
  if isGuildRank then
    local summary = data._guild_summary
    local avatarData = ed.analyzeAvatar(summary._avatar)
    local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
    guildIcon:setScale(0.76)
    ui.layer_head:addChild(guildIcon)
    ed.layout.centerInParent(guildIcon)
    ed.setLabelString(ui.label_server_name, data._param4 or " ")
    ed.setLabelString(ui.label_guild_name, summary._name)
    ui.panel_score:removeAllChildrenWithCleanup(true)
    local scoreTxt = ed.createLabelTTF(formatScore(data._param1), 23)
    ed.setLabelColor(scoreTxt, ed.toccc3(16700269))
    ed.setLabelStroke(scoreTxt, ed.toccc3(7618585), 1.5)
    ui.panel_score:addChild(scoreTxt)
    ed.layout.centerInParent(scoreTxt)
  elseif isPlayerRank then
    ed.setLabelString(ui.label_server_name, data._param4 or " ")
    local summary = data._user_summary
    local param = {
      id = summary._avatar,
      level = summary._level,
      scale = 0.75,
      lvoffset = {x = -47, y = -25}
    }
    local head = ed.getWholeHeadIcon(param)
    ui.layer_head:addChild(head)
    ed.layout.centerInParent(head)
    if ed.checkVisible(ui.label_server_name) then
      ui.label_player_name:setPositionY(50.5)
    elseif ed.checkVisible(ui.label_boss_des) then
      ui.label_player_name:setPositionY(58.5)
      ed.adaptLabel(ui.label_boss_des, {maxWidth = 60, minScale = 0.7})
      local bossLayerSize = ui.list_boss_layer:getContentSize()
      if nil == ui.bossDraglist then
        local info = {
          cliprect = CCRectMake(0, 0, bossLayerSize.width, bossLayerSize.height),
          container = ui.list_boss_layer,
          doPressIn = function(x, y)
            for k, v in pairs(ui.bossIconList or {}) do
              if ed.containsPoint(v.icon, x, y) then
                self.ui.img_boss_tips:setVisible(true)
                local bossTable = ed.getDataTable("GuildMountBoss")[v.data._boss_id]
                ed.setLabelString(self.ui.label_boss_tips, T("\231\172\172%d\232\189\174 %s", ed.GuildMountManager.getBossRoundById(v.data._boss_id), bossTable["Boss Name"]))
                local strSize = self.ui.label_boss_tips:getContentSize()
                local contentWidth = strSize.width + 30
                local contentHeight = strSize.height + 25
                self.ui.img_boss_tips:setContentSize(CCSizeMake(contentWidth, contentHeight))
                self.ui.label_boss_tips:setPosition(ccp(contentWidth * 0.5, contentHeight * 0.5))
                ed.layout.relateLayout(v.icon, self.ui.img_boss_tips, {
                  bottom = v.icon:getContentSize().height * 0.5
                })
                return v
              end
            end
          end,
          cancelPressIn = function(x, y, btn)
            if btn then
              self.ui.img_boss_tips:setVisible(false)
            end
          end,
          priority = -300
        }
        ui.bossDraglist = ed.draglist.create(info)
      else
        ui.bossDraglist:clearList()
      end
      ui.bossIconList = {}
      local posX = 2
      local tb = ed.getDataTable("GuildMountBoss")
      for k, v in ipairs(data._battle_record or {}) do
        local bossTable = tb[v._boss_id]
        local icon = ed.readhero.createPureIcon({
          id = bossTable["Unit ID"]
        }).icon
        ui.bossDraglist:addItem(icon)
        table.insert(ui.bossIconList, {icon = icon, data = v})
        local scaleVal = 0.5
        icon:setScale(scaleVal)
        local iconWidth = icon:getContentSize().width * scaleVal
        icon:setPosition(ccp(iconWidth / 2 + posX, bossLayerSize.height / 2 + 2))
        local lv = ed.getDataTable("Battle")[bossTable["Stage ID"]][1]["Level 1"]
        local labelTxt = ed.createttf(ed.formatLevel("Lv") .. (lv or 1), 13 / scaleVal)
        labelTxt:setAnchorPoint(ccp(1, 0))
        labelTxt:setPosition(ccp(iconWidth / scaleVal + 8, -5))
        ed.setLabelColor(labelTxt, ed.toccc3(16776423))
        ed.setLabelStroke(labelTxt, ed.toccc3(2233605), 3)
        icon:addChild(labelTxt)
        if v._is_extra == 1 then
          local overtimeTxt = ed.createttf(T("\232\161\165\230\151\182"), 14 / scaleVal)
          overtimeTxt:setAnchorPoint(ccp(0, 1))
          overtimeTxt:setPosition(ccp(-5, iconWidth / scaleVal + 5))
          ed.setLabelColor(overtimeTxt, ed.toccc3(16700269))
          ed.setLabelStroke(overtimeTxt, ed.toccc3(2233605), 3)
          icon:addChild(overtimeTxt)
        end
        posX = posX + iconWidth + 8
      end
      ui.bossDraglist:initListWidth(posX - 8)
    else
      ui.label_player_name:setPositionY(39.5)
    end
    local label_player_name, _, innerText = ed.getPlayerName(summary._name, summary._medal, {left = true})
    if innerText.spriteNode.medalIcon then
      innerText.node:setPositionX(15)
    else
      innerText.node:setPositionX(0)
    end
    ed.UITool.replaceUI(ui, "bg", "label_player_name", label_player_name)
    ui.panel_score:removeAllChildrenWithCleanup(true)
    local scoreTxt = ed.createLabelTTF(formatScore(data._param1), 23)
    ed.setLabelColor(scoreTxt, ed.toccc3(16700269))
    ed.setLabelStroke(scoreTxt, ed.toccc3(7618585), 1.5)
    ui.panel_score:addChild(scoreTxt)
    ed.layout.centerInParent(scoreTxt)
  end
  return container, ui
end

function class:refreshMyRank()
  local myRank, myData = self:getMyRankData(self.curRankType)
  if nil == next(myData) then
    myRank = 0
  end
  self.ui.bg_self:setVisible(true)
  self.ui.panel_myrank:removeAllChildrenWithCleanup(true)
  if RANK_TO_RESOURCES[myRank] then
    local imageRanking = ed.createSprite(RANK_TO_RESOURCES[myRank])
    self.ui.panel_myrank:addChild(imageRanking)
    ed.layout.centerInParent(imageRanking)
  elseif 0 < myRank then
    local text = ed.getNumberNode({
      text = myRank or 0,
      folder = "peakarena_rank"
    }).node
    self.ui.panel_myrank:addChild(text)
    ed.layout.centerInParent(text)
  else
    local text = ed.createLabelTTF(T("\230\156\170\228\184\138\230\166\156"), 26, ed.fontBold)
    ed.setLabelColor(text, ed.toccc3(16771733))
    self.ui.panel_myrank:addChild(text)
    ed.layout.centerInParent(text)
  end
  local isPlayerRank = RankType.Zone_Personal == self.curRankType or RankType.Guild_Total == self.curRankType or RankType.Guild_Today == self.curRankType
  local isGuildRank = RankType.Zone_Guild == self.curRankType
  self.ui.label_player_name:setVisible(isPlayerRank)
  self.ui.label_guild_name:setVisible(isGuildRank)
  self.ui.label_server_name:setVisible(RankType.Zone_Guild == self.curRankType or RankType.Zone_Personal == self.curRankType)
  self.ui.label_boss_des:setVisible(RankType.Guild_Today == self.curRankType)
  self.ui.list_boss_layer:setVisible(RankType.Guild_Today == self.curRankType)
  self.ui.layer_head:removeAllChildrenWithCleanup(true)
  if isGuildRank then
    local summary, serverName, round
    if 0 == myRank then
      summary = self:getMyGuildData(self.curRankType)
      serverName = tostring(game_server_name)
      round = 1
    else
      summary = myData._guild_summary
      serverName = myData._param4 or ""
      round = myData._param1
    end
    local avatarData = ed.analyzeAvatar(summary._avatar)
    local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
    guildIcon:setScale(0.76)
    self.ui.layer_head:addChild(guildIcon)
    ed.layout.centerInParent(guildIcon)
    ed.setLabelString(self.ui.label_server_name, serverName)
    ed.setLabelString(self.ui.label_guild_name, summary._name)
    self.ui.panel_myscore:removeAllChildrenWithCleanup(true)
    local scoreTxt = ed.createLabelTTF(formatScore(myData._param1 or 0), 23)
    ed.setLabelColor(scoreTxt, ed.toccc3(16700269))
    ed.setLabelStroke(scoreTxt, ed.toccc3(7618585), 1.5)
    self.ui.panel_myscore:addChild(scoreTxt)
    ed.layout.centerInParent(scoreTxt)
  elseif isPlayerRank then
    local summary, serverName, score
    if 0 == myRank then
      summary = {
        _avatar = ed.player:getAvatar(),
        _name = ed.player:getName(),
        _medal = ed.player:getMedal().wearInfo,
        _level = ed.player:getLevel()
      }
      serverName = tostring(game_server_name)
      score = 0
    else
      summary = myData._user_summary
      serverName = myData._param4 or ""
      score = myData._param1 or 0
    end
    if ed.checkVisible(self.ui.label_server_name) then
      ed.setLabelString(self.ui.label_server_name, serverName)
      self.ui.label_player_name:setPositionY(56.5)
    elseif ed.checkVisible(self.ui.label_boss_des) then
      ed.adaptLabel(self.ui.label_boss_des, {maxWidth = 60, minScale = 0.7})
      local bossLayerSize = self.ui.list_boss_layer:getContentSize()
      if nil == self.bossDraglist then
        local info = {
          cliprect = CCRectMake(0, 0, bossLayerSize.width, bossLayerSize.height),
          container = self.ui.list_boss_layer,
          doPressIn = function(x, y)
            for k, v in pairs(self.bossIconList or {}) do
              if ed.containsPoint(v.icon, x, y) then
                self.ui.img_boss_tips:setVisible(true)
                local bossTable = ed.getDataTable("GuildMountBoss")[v.data._boss_id]
                ed.setLabelString(self.ui.label_boss_tips, T("\231\172\172%d\232\189\174 %s", ed.GuildMountManager.getBossRoundById(v.data._boss_id), bossTable["Boss Name"]))
                local strSize = self.ui.label_boss_tips:getContentSize()
                local contentWidth = strSize.width + 30
                local contentHeight = strSize.height + 25
                self.ui.img_boss_tips:setContentSize(CCSizeMake(contentWidth, contentHeight))
                self.ui.label_boss_tips:setPosition(ccp(contentWidth * 0.5, contentHeight * 0.5))
                ed.layout.relateLayout(v.icon, self.ui.img_boss_tips, {
                  bottom = v.icon:getContentSize().height * 0.5
                })
                return v
              end
            end
          end,
          cancelPressIn = function(x, y, btn)
            if btn then
              self.ui.img_boss_tips:setVisible(false)
            end
          end,
          priority = -300
        }
        self.bossDraglist = ed.draglist.create(info)
      else
        self.bossDraglist:clearList()
      end
      self.bossIconList = {}
      local posX = 2
      local tb = ed.getDataTable("GuildMountBoss")
      for k, v in ipairs(myData._battle_record or {}) do
        bossTable = tb[v._boss_id]
        local icon = ed.readhero.createPureIcon({
          id = bossTable["Unit ID"]
        }).icon
        self.bossDraglist:addItem(icon)
        table.insert(self.bossIconList, {icon = icon, data = v})
        local scaleVal = 0.5
        icon:setScale(scaleVal)
        local iconWidth = icon:getContentSize().width * scaleVal
        icon:setPosition(ccp(iconWidth / 2 + posX, bossLayerSize.height / 2))
        local lv = ed.getDataTable("Battle")[bossTable["Stage ID"]][1]["Level 1"]
        local labelTxt = ed.createttf(ed.formatLevel("Lv") .. (lv or 1), 13 / scaleVal)
        labelTxt:setAnchorPoint(ccp(1, 0))
        labelTxt:setPosition(ccp(iconWidth / scaleVal + 8, -5))
        ed.setLabelColor(labelTxt, ed.toccc3(16776423))
        ed.setLabelStroke(labelTxt, ed.toccc3(2233605), 3)
        icon:addChild(labelTxt)
        if v._is_extra == 1 then
          local overtimeTxt = ed.createttf(T("\232\161\165\230\151\182"), 14 / scaleVal)
          overtimeTxt:setAnchorPoint(ccp(0, 1))
          overtimeTxt:setPosition(ccp(-5, iconWidth / scaleVal + 5))
          ed.setLabelColor(overtimeTxt, ed.toccc3(16700269))
          ed.setLabelStroke(overtimeTxt, ed.toccc3(2233605), 3)
          icon:addChild(overtimeTxt)
        end
        posX = posX + iconWidth + 8
      end
      self.bossDraglist:initListWidth(posX - 8)
      self.ui.label_player_name:setPositionY(64)
    else
      self.ui.label_player_name:setPositionY(49)
    end
    local param = {
      id = summary._avatar,
      level = summary._level,
      scale = 0.75,
      lvoffset = {x = -47, y = -25}
    }
    local head = ed.getWholeHeadIcon(param)
    self.ui.layer_head:addChild(head)
    ed.layout.centerInParent(head)
    local label_player_name, _, innerText = ed.getPlayerName(summary._name, summary._medal, {left = true})
    if innerText.spriteNode.medalIcon then
      innerText.node:setPositionX(15)
    else
      innerText.node:setPositionX(0)
    end
    ed.UITool.replaceUI(self.ui, "bg_self", "label_player_name", label_player_name)
    self.ui.panel_myscore:removeAllChildrenWithCleanup(true)
    local scoreTxt = ed.createLabelTTF(formatScore(score), 23)
    ed.setLabelColor(scoreTxt, ed.toccc3(16700269))
    ed.setLabelStroke(scoreTxt, ed.toccc3(7618585), 1.5)
    self.ui.panel_myscore:addChild(scoreTxt)
    ed.layout.centerInParent(scoreTxt)
  end
end

function class:setTabButtonSelect(tabName, select)
  if tabName == self.currentTabName then
    return
  end
  local btnSelect = self.ui[tabName .. "_selected"]
  btnSelect:setVisible(select)
  local btn = self.ui[tabName]
  btn:setVisible(not select)
end

function class:changeTab(isPas, data)
  if isPas and not self.isWaitNetworkReply then
    self.curRankType = data.rankType
    local des = TAB_DESC[data.rankType]
    if RankType.Zone_Guild == self.curRankType or RankType.Zone_Personal == self.curRankType then
      des = des .. T("(\229\189\147\229\137\141\239\188\154\231\172\172%d\232\181\155\229\140\186)", ed.GuildMountManager:getZoneId())
    end
    ed.setLabelString(self.ui.label_info, des)
    self.ui.label_info:limitWidthByScale(600)
    if nil ~= self.titleGradientTxt then
      self.titleGradientTxt:setString(TAB_TO_TITLE_RES[self.curRankType])
    end
    if self.rankListTab[self.curRankType] then
      self:refreshUI()
    else
      self:sendReqRankData(self.curRankType)
    end
  end
end

function class:getRankDataCount(rank)
  local data = self.rankListTab[rank]
  if nil == data or nil == data._rank_list then
    return 0
  end
  return #data._rank_list
end

function class:getRankDataItem(rank, index)
  local data = self.rankListTab[rank]
  if nil == data or nil == data._rank_list then
    return {}
  end
  return data._rank_list[index] or {}
end

function class:getMyRankData(rank)
  local data = self.rankListTab[rank]
  if nil == data then
    return 0, {}
  end
  return data._self_pos or 0, data._self_rank or {}
end

function class:getMyGuildData(rank)
  local data = self.rankListTab[rank]
  if nil == data then
    return {}
  end
  return data._self_guild or {}
end

function class:sendReqRankData(rankType)
  self.isWaitNetworkReply = true
  if RankType.Zone_Guild == rankType then
    ed.GuildMountNetwork:sendZoneRank("guild")
  elseif RankType.Zone_Personal == rankType then
    ed.GuildMountNetwork:sendZoneRank("player")
  elseif RankType.Guild_Total == rankType then
    ed.GuildMountNetwork:sendScoreRank()
  elseif RankType.Guild_Today == rankType then
    ed.GuildMountNetwork:sendTodayScoreRank()
  end
end

function class:onReqRankDataComplete(data)
  self.isWaitNetworkReply = false
  self.rankListTab[self.curRankType] = data
  self:refreshUI()
end

function class:refreshUI()
  self.ui.label_nobody:setVisible(0 == self:getRankDataCount(self.curRankType))
  self:refreshMyRank()
  self.tableView:reloadData()
end

function class:registerEvents()
  self:listenEvent("GuildMountMyGuildRank", function(data)
    self:onReqRankDataComplete(ed.copyProto(data))
  end)
  self:listenEvent("GuildMountZoneRank", function(data)
    self:onReqRankDataComplete(ed.copyProto(data))
  end)
  self:listenEvent("GuildMountTodayMyGuildRank", function(data)
    data = ed.copyProto(data)
    table.sort(data._rank_list or {}, function(a, b)
      return a._score > b._score
    end)
    for i, v in ipairs(data._rank_list or {}) do
      v._param1 = v._score
      if v._user_summary._role_id == ed.getRoleId() then
        data._self_rank = v
        data._self_pos = i
      end
    end
    self:onReqRankDataComplete(data)
  end)
end

function class:registerTouchHandlers()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.bg, x, y) and not ed.containsPoint(self.ui.layer_btn, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.bg, x, y) and not ed.containsPoint(self.ui.layer_btn, x, y) and self.clickOutSide then
        self:destroy()
      end
      return false
    end,
    key = "close",
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    pressScale = 0.98,
    key = "btn_close",
    force = true,
    clickInterval = 0.3,
    clickHandler = function()
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.layer_head,
    key = "layer_head",
    force = true,
    clickInterval = 0.3,
    clickHandler = function()
      if not ed.newShowMedalPop then
        if self.curRankType == RankType.Zone_Guild then
          local myRank, myData = self:getMyRankData(self.curRankType)
          ed.ui.guildSummaryWin.create(myRank, self:getMyGuildData(self.curRankType)):popWindow()
        elseif self.curRankType == RankType.Zone_Personal or self.curRankType == RankType.Guild_Total or self.curRankType == RankType.Guild_Today then
          ed.UITool.openView("playerInfoPanel", ed.getRoleId())
        end
      end
    end
  })
end

function class:destroy()
  base.destroy(self, {skipAnim = true})
end

ed.UITool.registViewOpenFunc("GuildMountRankListWin", function(param)
  class.create(param):popWindow()
end)
