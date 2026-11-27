local base = ed.ui.popwindow
local SkillTowerAbyssRankWin = newclass(base.mt)
ed.ui.SkillTowerAbyssRankWin = SkillTowerAbyssRankWin

function SkillTowerAbyssRankWin.create(params)
  local self = base.create("SkillTowerAbyssRankWin")
  setmetatable(self, SkillTowerAbyssRankWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:listenEvent("SkillTowerExRanklist", function(data)
    self:handleData(data)
    self:refreshUI()
  end)
  ed.SkillTowerNetwork:sendExTowerRankBoard("local")
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
  self:popWindow()
  self:show()
  return self
end

function SkillTowerAbyssRankWin:handleData(data)
  if data._type == "local" then
    self.rankList = data._rank_list or {}
    self.selfRank = data._self_rank
    self.selfPos = data._self_pos
    self.rewardList = {}
    if ed.SkillTowerManager.curAbyssSeason then
      local abyssRewardTable = ed.getDataTable("FancyAbyssRankReward")[ed.SkillTowerManager.curAbyssSeason]
      for i, v in ipairs(abyssRewardTable or {}) do
        local result = ""
        local items = {}
        local selfPos = self.selfPos or 999999
        if abyssRewardTable[i - 1] and abyssRewardTable[i - 1].Rank < v.Rank - 1 then
          if selfPos > abyssRewardTable[i - 1].Rank and selfPos <= v.Rank then
            self.curRewardIndex = i
          end
          result = string.format(T("%d-%d"), abyssRewardTable[i - 1].Rank + 1, v.Rank)
        else
          if selfPos == v.Rank then
            self.curRewardIndex = i
          end
          result = v.Rank
        end
        for i = 1, 10 do
          if v["Reward Type " .. i] then
            local item = {
              type = v["Reward Type " .. i],
              id = v["Reward ID " .. i],
              amount = v["Reward Amount " .. i]
            }
            table.insert(items, item)
          end
        end
        table.insert(self.rewardList, {rank = result, rewards = items})
      end
      self.rewardList[#self.rewardList].rank = abyssRewardTable[#self.rewardList - 1].Rank .. "+"
    end
  else
    self.serverRankList = data._rank_list or {}
    self.selfServerRank = data._self_rank
    self.selfServerPos = data._self_pos
  end
end

function SkillTowerAbyssRankWin:initData(params)
  self.tabIndex = 1
end

function SkillTowerAbyssRankWin:initTableView()
  local size = self.ui.layer_item:getContentSize()
  self.delegate = {
    numberOfCells = function()
      local data = self.rankList or {}
      if self.tabIndex == 2 then
        data = self.serverRankList or {}
      elseif self.tabIndex == 3 then
        data = self.rewardList or {}
      end
      return #data
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(368, 82)
    end,
    createCell = function(index)
      local data = self.rankList or {}
      if self.tabIndex == 2 then
        data = self.serverRankList or {}
      elseif self.tabIndex == 3 then
        data = self.rewardList or {}
      end
      local v = data[index]
      local container, ui
      if self.tabIndex == 1 then
        container, ui = self:createRankItem(index, v)
      elseif self.tabIndex == 2 then
        container, ui = self:createServerRankItem(index, v)
      else
        container, ui = self:createRewardItem(index, v)
      end
      return container, {
        data = v,
        ui = ui,
        container = container
      }
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.bg, x, y) then
        return ui
      end
    end,
    cancelPressIn = function(cell)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if self.tabIndex ~= 3 then
        if ed.containsPoint(ui.head, x, y) then
          ed.registerNetReply("req_home_page", function(data)
            local panel = ed.ui.PlayerInfoPanel.create(data, false)
            panel:popWindow()
          end)
          ed.PlayerInfoNetwork:requestHomePage(data.data._user_summary._role_id)
        end
      else
        local rewards = data.data.rewards
        for i, reward in ipairs(rewards) do
          if ed.containsPoint(ui["reward" .. i], x, y) then
            ed.ui.packageDetailWin.create(reward):popWindow()
          end
        end
      end
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.layer_item,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {8, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function SkillTowerAbyssRankWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.SkillTowerAbyssRankWin)
  self:initTableView()
  ed.setLabelStroke(ui.rankinfo, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.guildname, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.time1, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.time2, ed.toccc3(2233605), 1)
  ui.title:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.title, ed.toccc3(13398827), 1.5)
  self.ui.label_rank_selected:limitWidthByScale(55)
  self.ui.label_rank:limitWidthByScale(55)
  self.ui.label_all_rank_selected:limitWidthByScale(55)
  self.ui.label_all_rank:limitWidthByScale(55)
  self.ui.label_reward_selected:limitWidthByScale(55)
  self.ui.label_reward:limitWidthByScale(55)
  self.ui.bg_self:setVisible(false)
  self.ui.btn_reward:setVisible(self.rewardList and #self.rewardList > 0)
end

function SkillTowerAbyssRankWin:refreshUI()
  self:refreshDraglist()
  self.ui.btn_reward:setVisible(#self.rewardList > 0)
end

function SkillTowerAbyssRankWin:refreshSelfRank()
  if self.tabIndex == 1 then
    if not self.selfPos then
      self.ui.bg_self:setVisible(false)
      return
    end
    local rank = ed.getNumberNode({
      text = self.selfPos,
      folder = "fancy_abyss"
    }).node
    ed.UITool.replaceUI(self.ui, "bg_rank", "rank", rank)
    local param = {
      id = ed.player:getAvatarId(),
      frameId = ed.player:getAvatarFrame(),
      level = ed.player:getLevel(),
      lvoffset = {x = -47, y = -32}
    }
    local head = ed.getWholeHeadIcon(param)
    ed.UITool.replaceUI(self.ui, "bg_self", "head", head)
    local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
      anchorPoint = self.ui.name:getAnchorPoint()
    })
    ed.UITool.replaceUI(self.ui, "bg_self", "name", name)
    self.ui.server:setVisible(false)
    local guildName = ed.player:getGuildName()
    if guildName and guildName ~= "" then
      ed.setString(self.ui.guildname, guildName)
    end
    ed.setString(self.ui.time2, ed.gethmsNString(self.selfRank._min_time))
  elseif self.tabIndex == 2 then
    if not self.selfServerPos then
      self.ui.bg_self:setVisible(false)
      return
    end
    local rank = ed.getNumberNode({
      text = self.selfServerPos,
      folder = "fancy_abyss"
    }).node
    ed.UITool.replaceUI(self.ui, "bg_rank", "rank", rank)
    local param = {
      id = ed.player:getAvatarId(),
      frameId = ed.player:getAvatarFrame(),
      level = ed.player:getLevel(),
      lvoffset = {x = -47, y = -32}
    }
    local head = ed.getWholeHeadIcon(param)
    ed.UITool.replaceUI(self.ui, "bg_self", "head", head)
    local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
      anchorPoint = self.ui.name:getAnchorPoint()
    })
    ed.UITool.replaceUI(self.ui, "bg_self", "name", name)
    local guildName = ed.player:getGuildName()
    if guildName and guildName ~= "" then
      ed.setString(self.ui.guildname, guildName)
    end
    self.ui.server:setVisible(true)
    ed.setString(self.ui.server, self.selfServerRank._svr_name or T("\230\149\176\230\141\174\228\184\162\229\164\177"))
    ed.setString(self.ui.time2, ed.gethmsNString(self.selfServerRank._min_time))
  end
  self.ui.bg_self:setZOrder(9)
  self.ui.bg_self:setVisible(self.tabIndex ~= 3)
end

function SkillTowerAbyssRankWin:createRankItem(rank, data)
  local container, ui = ed.editorui(ed.uieditor.AbyssRankItem)
  if rank == 1 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_1.png")
  elseif rank == 2 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_2.png")
  elseif rank == 3 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_3.png")
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_4.png")
    local rank = ed.getNumberNode({
      text = rank,
      folder = "fancy_abyss"
    }).node
    ed.UITool.replaceUI(ui, "bg", "rank", rank)
  end
  ed.setLabelStroke(ui.name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.guildname, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.time1, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.time2, ed.toccc3(2233605), 1)
  local summary = data._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.83,
    lvoffset = {x = -47.5, y = -30}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "bg", "head", head)
  ui.head = headIcon
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ui.name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "bg", "name", name)
  if summary._guild_name then
    ed.setString(ui.guildname, summary._guild_name)
  end
  ed.setString(ui.time2, ed.gethmsNString(data._min_time))
  return container, ui
end

function SkillTowerAbyssRankWin:createServerRankItem(rank, data)
  local container, ui = ed.editorui(ed.uieditor.AbyssRankItem)
  if rank == 1 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_1.png")
  elseif rank == 2 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_2.png")
  elseif rank == 3 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_3.png")
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_4.png")
    local rank = ed.getNumberNode({
      text = rank,
      folder = "fancy_abyss"
    }).node
    ed.UITool.replaceUI(ui, "bg", "rank", rank)
  end
  ed.setLabelStroke(ui.name, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.guildname, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.time1, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.time2, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.server, ed.toccc3(2233605), 1)
  ui.server:setVisible(true)
  ed.pt(data)
  ed.setString(ui.server, data._svr_name)
  local summary = data._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.83,
    lvoffset = {x = -47.5, y = -30}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "bg", "head", head)
  ui.head = headIcon
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ui.name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "bg", "name", name)
  if summary._guild_name then
    ed.setString(ui.guildname, summary._guild_name)
  end
  ed.setString(ui.time2, ed.gethmsNString(data._min_time))
  return container, ui
end

function SkillTowerAbyssRankWin:createRewardItem(rank, data)
  local container, ui = ed.editorui(ed.uieditor.AbyssRewardItem)
  if rank == 1 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_1.png")
  elseif rank == 2 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_2.png")
  elseif rank == 3 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_3.png")
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_4.png")
    ui.Label_4679:setVisible(true)
    ed.setString(ui.Label_4679, data.rank)
    ui.Label_4679:setFontName(ed.fontBold)
    local width = ui.Label_4679:getContentSize().width
    if 150 < width then
      ui.Label_4679:setScale(150 / ui.Label_4679:getContentSize().width)
    end
  end
  for k, v in ipairs(data.rewards) do
    local icon = ed.createItemIcon(v)
    icon:setScale(0.8)
    icon:setPosition(ccp(69 * k - 160, 38))
    ui["reward" .. k] = icon
    ui.layer_item:addChild(icon)
  end
  ui.mask:setVisible(rank == self.curRewardIndex)
  return container, ui
end

function SkillTowerAbyssRankWin:refreshDraglist()
  self.tableView:reloadData()
  if self.tabIndex == 1 then
    self.ui.Label_4885:setVisible(#self.rankList == 0)
  elseif self.tabIndex == 2 then
    self.ui.Label_4885:setVisible(#self.serverRankList == 0)
  else
    self.ui.Label_4885:setVisible(false)
  end
  self:refreshSelfRank()
end

function SkillTowerAbyssRankWin:doClickIn()
  local function handler(x, y, v)
    if self.tabIndex ~= 3 then
      if ed.containsPoint(v.head, x, y) then
        ed.registerNetReply("req_home_page", function(data)
          local panel = ed.ui.PlayerInfoPanel.create(data, false)
          
          panel:popWindow()
        end)
        ed.PlayerInfoNetwork:requestHomePage(v.data._user_summary._role_id)
      end
    else
      local rewards = v.data.rewards
      for i, reward in ipairs(rewards) do
        if ed.containsPoint(v["reward" .. i], x, y) then
          ed.ui.packageDetailWin.create(reward):popWindow()
        end
      end
    end
  end
  
  return handler
end

function SkillTowerAbyssRankWin:cancelClickIn()
  local function handler(x, y, id)
  end
  
  return handler
end

function SkillTowerAbyssRankWin:doPressIn()
  local function handler(x, y)
    for k, v in ipairs(self.uiList) do
      if ed.containsPoint(v.bg, x, y) then
        return v
      end
    end
  end
  
  return handler
end

function SkillTowerAbyssRankWin:refreshSomeUI()
  if self.tabIndex == 1 then
    ed.setString(self.ui.title, T("\230\156\172\230\156\141\231\171\158\233\128\159\230\142\146\232\161\140"))
    ed.setString(self.ui.label_info, T("\230\160\185\230\141\174\230\137\128\230\156\137\229\133\179\229\141\161\233\128\154\229\133\179\230\128\187\232\128\151\230\151\182\231\180\175\229\138\160\232\191\155\232\161\140\230\142\146\229\144\141"))
  elseif self.tabIndex == 2 then
    ed.setString(self.ui.title, T("\229\133\168\230\156\141\231\171\158\233\128\159\230\142\146\232\161\140"))
    ed.setString(self.ui.label_info, T("\229\133\168\230\156\141\229\137\141100\229\144\141\228\184\138\230\166\156\239\188\140\228\187\133\228\190\155\229\177\149\231\164\186"))
  elseif self.tabIndex == 3 then
    ed.setString(self.ui.title, T("\231\171\158\233\128\159\229\165\150\229\138\177"))
    ed.setString(self.ui.label_info, T("\230\156\172\230\156\159\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\230\156\172\230\156\141\231\171\158\233\128\159\230\142\146\229\144\141\233\130\174\228\187\182\229\143\145\229\165\150"))
  end
  self.ui.btn_rank_selected:setVisible(self.tabIndex == 1)
  self.ui.btn_server_selected:setVisible(self.tabIndex == 2)
  self.ui.btn_reward_selected:setVisible(self.tabIndex == 3 and self.rewardList and #self.rewardList > 0)
  self.ui.btn_rank:setVisible(self.tabIndex ~= 1)
  self.ui.btn_server:setVisible(self.tabIndex ~= 2)
  self.ui.btn_reward:setVisible(self.tabIndex ~= 3 and self.rewardList and #self.rewardList > 0)
  if self.tabIndex == 1 and self.selfPos then
    self.ui.bg_self:setVisible(true)
  elseif self.tabIndex == 2 and self.selfServerPos then
    self.ui.bg_self:setVisible(true)
  else
    self.ui.bg_self:setVisible(false)
  end
end

function SkillTowerAbyssRankWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "close",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_rank", function()
    self.tabIndex = 1
    self:refreshSomeUI()
    if self.rankList then
      self:refreshDraglist()
    else
      ed.SkillTowerNetwork:sendExTowerRankBoard("local")
    end
  end)
  ed.UITool.registerBtn(self, "btn_server", function()
    self.tabIndex = 2
    self:refreshSomeUI()
    if self.serverRankList then
      self:refreshDraglist()
    else
      ed.SkillTowerNetwork:sendExTowerRankBoard("global")
    end
  end)
  ed.UITool.registerBtn(self, "btn_reward", function()
    self.tabIndex = 3
    self:refreshSomeUI()
    if self.rankList then
      self:refreshDraglist()
    else
      ed.SkillTowerNetwork:sendExTowerRankBoard("local")
    end
  end)
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end)
end
