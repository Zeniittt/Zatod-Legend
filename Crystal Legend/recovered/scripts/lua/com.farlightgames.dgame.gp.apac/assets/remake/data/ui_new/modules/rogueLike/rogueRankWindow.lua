local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.rogueRankWindow = class
class.diffCfg = {
  "I",
  "II",
  "III",
  "IV",
  "V"
}
class.rank_path = {
  [1] = "UI/alpha/1080P/toparena/rank/rank_1st.png",
  [2] = "UI/alpha/1080P/toparena/rank/rank_2nd.png",
  [3] = "UI/alpha/1080P/toparena/rank/rank_3rd.png"
}
class.rank_bg_path = {
  [1] = "UI/alpha/1080P/rogue/rank/rank_backboard_1.png",
  [2] = "UI/alpha/1080P/rogue/rank/rank_backboard_2.png",
  [3] = "UI/alpha/1080P/rogue/rank/rank_backboard_3.png"
}
class.rank_bg_path_normal = "UI/alpha/1080P/rogue/rank/rank_backboard_4.png"
class.TAB_FIRST_BLOOD = "rogue_first_kill"
class.TAB_DAMAGE = "rogue_damage"
class.TAB_PEARL = "rogue_pearl"
class.TAB_BLESS = "rogue_bless"
class.TAB_SORT = {
  class.TAB_FIRST_BLOOD,
  class.TAB_DAMAGE,
  class.TAB_PEARL,
  class.TAB_BLESS
}
class.TAB_CONFIG = {
  [class.TAB_FIRST_BLOOD] = {
    text = T("\233\166\150\230\157\128"),
    desc = T("")
  },
  [class.TAB_DAMAGE] = {
    text = T("\230\158\129\233\153\144\232\190\147\229\135\186"),
    desc = T("\228\187\133\232\174\176\229\189\149\233\154\190\229\186\1664\229\143\138\228\187\165\228\184\138")
  },
  [class.TAB_PEARL] = {
    text = T("\229\164\167\229\175\140\231\191\129"),
    desc = T("\230\160\185\230\141\174\229\141\149\229\156\186\231\180\175\231\167\175\232\142\183\229\190\151\231\143\141\231\143\160\232\191\155\232\161\140\230\142\146\229\144\141")
  },
  [class.TAB_BLESS] = {
    text = T("\229\145\189\232\191\144\228\185\139\229\173\144"),
    desc = T("\230\160\185\230\141\174\229\141\149\229\156\186\231\180\175\231\167\175\232\142\183\229\190\151\231\165\157\231\166\143\230\149\176\232\191\155\232\161\140\230\142\146\229\144\141")
  }
}
class.FIRST_BLOOD_BG_1 = "UI/alpha/1080P/rogue/rank/rank_firstblood_1.png"
class.FIRST_BLOOD_BG_2 = "UI/alpha/1080P/rogue/rank/rank_firstblood_2.png"
ed.UITool.registViewOpenFunc("rogueRankWindow", function(param)
  ed.ui.rogueRankWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("rogueRankWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.chapterId = param.chapterId or 1
  self.selectTab = param.selectTab or self.TAB_FIRST_BLOOD
  self.rankData = {}
  self.rankList = {}
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueRankWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initTabBtnList()
  self:initTableView()
  self:createPlayerInfo(self.ui.panel_my_rank_head, ed.player:getUserSummary())
  self:requireRankData(self.selectTab)
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
  self:show()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_empty_tips, ed.toccc3(11638885), 1.5)
  ed.setLabelFontName(self.ui.label_empty_tips, ed.fontBold)
  ed.setLabelStroke(self.ui.label_diff, ed.toccc3(2233605), 1.5)
  ed.setLabelStroke(self.ui.label_crisis_amount, ed.toccc3(16771980), 1)
  ed.setLabelStroke(self.ui.label_damage_tips, ed.toccc3(2233605), 1)
  ed.setLabelStroke(self.ui.label_damage, ed.toccc3(2233605), 1)
  ed.setLabelStroke(self.ui.label_pearl_amount, ed.toccc3(2233605), 1)
  ed.setLabelStroke(self.ui.label_bless_tips, ed.toccc3(1642242), 1)
  ed.setLabelStroke(self.ui.label_bless_amount, ed.toccc3(1642242), 1)
  ed.setLabelStroke(self.ui.label_my_rank, ed.toccc3(0), 1)
  ed.setLabelFontName(self.ui.label_my_rank, ed.fontBold)
  ed.setLabelStroke(self.ui.label_my_rank_tips, ed.toccc3(2565412), 1)
  ed.setLabelDimensions(self.ui.label_bless_tips, CCSizeMake(210, 0))
  local chapterName = ed.getDataTable("RogueBook")[self.chapterId].Name
  local titleLabel = ed.ui.gradientLabel.create({
    text = chapterName,
    fontSize = 22,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16770193),
    strokeSize = 3,
    strokeColor = ed.toccc3(6111238)
  })
  self.ui.image_bg:addChild(titleLabel.node)
  titleLabel.node:setPosition(self.ui.panel_title:getPosition())
  self.ui.titleLabel = titleLabel
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.rankList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(730, 80)
    end,
    createCell = function(index)
      local container
      local itemData = self.rankList[index]
      if self.selectTab == self.TAB_FIRST_BLOOD then
        container = self:createFirstBloodRankItem(itemData)
      elseif self.selectTab == self.TAB_DAMAGE then
        container = self:createDamageRankItem(index, itemData)
      elseif self.selectTab == self.TAB_PEARL then
        container = self:createPearlRankItem(index, itemData)
      elseif self.selectTab == self.TAB_BLESS then
        container = self:createBlessRankItem(index, itemData)
      end
      return container
    end,
    doClickIn = function(cell)
      local data = cell.data
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    padding = {width = 0, height = 3},
    touchpriority = -300,
    noshade = true,
    doMove = self:tableViewDoMove()
  }
  self.tableView = Tableview.create(param)
end

function class:tableViewDoMove()
  local function handler()
    local x, y = self.tableView:getListPos()
    
    local listHeight = self.tableView.dragList.listHeight or 0
    if y > listHeight - 40 and listHeight > self.ui.panel_list:getContentSize().height - 40 then
      self.ui.my_rank_bg:setVisible(false)
    else
      if self.selectTab == self.TAB_FIRST_BLOOD then
        self.ui.my_rank_bg:setVisible(false)
        return
      end
      local myRankData = self.rankData[self.selectTab]._self_rank
      if not myRankData then
        self.ui.my_rank_bg:setVisible(false)
        return
      end
      self.ui.my_rank_bg:setVisible(true)
    end
  end
  
  return handler
end

function class:refreshTableView()
  self.rankList = self:getRankData(self.selectTab)
  self.tableView:reloadData()
end

function class:refreshView()
  self:refreshTableView()
  self:refreshMyRank()
  ed.setLabelString(self.ui.label_desc, self.TAB_CONFIG[self.selectTab].desc or "")
  self.ui.image_empty:setVisible(#self.rankList == 0)
end

function class:initTabBtnList()
  local panelSize = self.ui.panel_tab_btn:getContentSize()
  self.tabBtnList = {}
  local posY, gapY = 0, 10
  for index, tabBtnKey in ipairs(self.TAB_SORT or {}) do
    local btn, btnSize = self:createTabBtn(tabBtnKey)
    self.ui.panel_tab_btn:addChild(btn)
    table.insert(self.tabBtnList, btn)
    btn:setPosition(ccp(panelSize.width / 2, panelSize.height - (posY + btnSize.height / 2)))
    posY = posY + btnSize.height + gapY
  end
  self:refreshTabBtn()
  for index, btn in ipairs(self.tabBtnList) do
    self:btRegisterButtonClick({
      button = btn,
      key = "click_tab_btn" .. index,
      clickHandler = function()
        self:onClickTabBtn(btn.tabBtnKey)
      end,
      clickInterval = 0.5,
      pressScale = 0.95,
      force = true
    })
  end
end

function class:createTabBtn(tabBtnKey)
  local tabBtnCfg = self.TAB_CONFIG[tabBtnKey]
  local container = ed.createSprite()
  local size = CCSizeMake(118.5, 45)
  container:setContentSize(size)
  local normalBtn = ed.createSprite("UI/alpha/1080P/rogue/rank/rank_tab_1.png")
  local normalBtnText = ed.createLabelTTF(tabBtnCfg.text or "", 19)
  normalBtn:addChild(normalBtnText)
  ed.layout.centerInParent(normalBtnText)
  ed.setLabelColor(normalBtnText, ed.toccc3(14073231))
  ed.setLabelStroke(normalBtnText, ed.toccc3(2233605), 1)
  container:addChild(normalBtn)
  ed.layout.centerInParent(normalBtn)
  local selectBtn = ed.createSprite("UI/alpha/1080P/rogue/rank/rank_tab_2.png")
  local selectBtnText = ed.createLabelTTF(tabBtnCfg.text or "", 19)
  selectBtn:addChild(selectBtnText)
  ed.layout.centerInParent(selectBtnText)
  ed.setLabelColor(selectBtnText, ed.toccc3(16776423))
  ed.setLabelStroke(selectBtnText, ed.toccc3(5389588), 1)
  container:addChild(selectBtn)
  ed.layout.centerInParent(selectBtn)
  container.normalBtn = normalBtn
  container.selectBtn = selectBtn
  container.tabBtnKey = tabBtnKey
  container.tabBtnCfg = tabBtnCfg
  return container, size
end

function class:refreshTabBtn()
  for index, tabBtn in ipairs(self.tabBtnList) do
    local tabBtnCfg = tabBtn.tabBtnCfg
    local tabBtnKey = tabBtn.tabBtnKey
    local isSelected = tabBtnKey == self.selectTab
    tabBtn.normalBtn:setVisible(not isSelected)
    tabBtn.selectBtn:setVisible(isSelected)
  end
end

function class:onClickTabBtn(tabBtnKey)
  if tabBtnKey == self.selectTab then
    return
  end
  self.selectTab = tabBtnKey
  self:refreshTabBtn()
  local rankList = self:getRankData(self.selectTab)
  if not rankList or #rankList == 0 then
    self:requireRankData(self.selectTab)
  else
    self:refreshView()
  end
end

function class:createFirstBloodRankItem(data)
  local container, ui = ed.editorui(ed.uieditor.rogueRankFirstBloodItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelStroke(ui.label_diff, ed.toccc3(6094848), 1.5)
  ed.setLabelFontName(ui.label_diff, ed.fontBold)
  ed.setLabelStroke(ui.label_time_tips, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_time, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_crisis_amount, ed.toccc3(16771980), 1)
  ed.setLabelStroke(ui.label_guild_name, ed.toccc3(2233605), 1)
  local time = data._param1
  local difficult = data._param2
  local crisis = data._param3
  self:createPlayerInfo(ui.panel_head, data._user_summary)
  if crisis and 0 < crisis then
    ui.crisis_icon:setVisible(true)
    ui.label_crisis_amount:setVisible(true)
    ed.setLabelString(ui.label_crisis_amount, crisis)
    ed.setTexture(ui.image_bg, self.FIRST_BLOOD_BG_1)
    ed.setTexture(ui.image_time_bg, "UI/alpha/1080P/rogue/rank/rank_firstblood_3.png")
  else
    ui.crisis_icon:setVisible(false)
    ui.label_crisis_amount:setVisible(false)
    ui.label_diff:setPositionX(75)
    ed.setTexture(ui.image_bg, self.FIRST_BLOOD_BG_2)
    ed.setTexture(ui.image_time_bg, "UI/alpha/1080P/rogue/rank/rank_firstblood_4.png")
  end
  ed.setLabelString(ui.label_diff, T("\233\154\190\229\186\166%s", self.diffCfg[difficult]))
  local y, m, d, h, min, s = ed.time2YMDHMS(time)
  ed.setLabelString(ui.label_time, string.format("%d.%d.%d %.2d:%.2d:%.2d", y, m, d, h, min, s))
  return container
end

function class:createDamageRankItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.rogueRankDamageItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelFontName(ui.label_rank, ed.fontBold)
  ed.setLabelStroke(ui.label_rank, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_diff, ed.toccc3(2233605), 1.5)
  ed.setLabelStroke(ui.label_crisis_amount, ed.toccc3(16771980), 1)
  ed.setLabelStroke(ui.label_damage_tips, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_damage, ed.toccc3(2233605), 1)
  local damage = data._param1
  local difficult = data._param2
  local crisis = data._param3
  local heroId = data._param5
  local rank = index
  if rank <= 3 then
    ui.label_rank:setVisible(false)
    ed.setTexture(ui.image_rank, self.rank_path[rank], true)
    ed.setTexture(ui.image_bg, self.rank_bg_path[rank])
  else
    ui.image_rank:setVisible(false)
    ed.setLabelString(ui.label_rank, rank)
    ed.setTexture(ui.image_bg, self.rank_bg_path_normal)
  end
  self:createPlayerInfo(ui.panel_head, data._user_summary)
  ed.setLabelString(ui.label_diff, string.format("\233\154\190\229\186\166%s", self.diffCfg[difficult]))
  ed.setLabelString(ui.label_crisis_amount, crisis)
  ed.setLabelString(ui.label_damage, damage)
  local heroIcon = ed.readhero.createIcon({
    id = heroId or 1
  }).icon
  heroIcon:setScale(0.75)
  ui.panel_hero_icon:addChild(heroIcon)
  ed.layout.centerInParent(heroIcon)
  return container
end

function class:createPearlRankItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.rogueRankPearlItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelFontName(ui.label_rank, ed.fontBold)
  ed.setLabelStroke(ui.label_rank, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_pearl_amount, ed.toccc3(2233605), 1)
  local pearlAmount = data._param1
  local rank = index
  if rank <= 3 then
    ui.label_rank:setVisible(false)
    ed.setTexture(ui.image_rank, self.rank_path[rank], true)
    ed.setTexture(ui.image_bg, self.rank_bg_path[rank])
    ed.setTexture(ui.image_pearl_bg, string.format("UI/alpha/1080P/rogue/rank/rank_pearl_bg_%s.png", rank))
  else
    ui.image_rank:setVisible(false)
    ed.setLabelString(ui.label_rank, rank)
    ed.setTexture(ui.image_bg, self.rank_bg_path_normal)
    ed.setTexture(ui.image_pearl_bg, "UI/alpha/1080P/rogue/rank/rank_pearl_bg_4.png")
  end
  self:createPlayerInfo(ui.panel_head, data._user_summary)
  ed.setLabelString(ui.label_pearl_amount, pearlAmount)
  return container
end

function class:createBlessRankItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.rogueRankBlessItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelFontName(ui.label_rank, ed.fontBold)
  ed.setLabelStroke(ui.label_rank, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_bless_tips, ed.toccc3(1642242), 1)
  ed.setLabelStroke(ui.label_bless_amount, ed.toccc3(1642242), 1)
  local blessAmount = data._param1
  local rank = index
  if rank <= 3 then
    ui.label_rank:setVisible(false)
    ed.setTexture(ui.image_rank, self.rank_path[rank], true)
    ed.setTexture(ui.image_bg, self.rank_bg_path[rank])
  else
    ui.image_rank:setVisible(false)
    ed.setLabelString(ui.label_rank, rank)
    ed.setTexture(ui.image_bg, self.rank_bg_path_normal)
  end
  self:createPlayerInfo(ui.panel_head, data._user_summary)
  ed.setLabelString(ui.label_bless_amount, blessAmount)
  return container
end

function class:createPlayerInfo(panel, userSummary)
  local param = {
    id = userSummary._avatar,
    scale = 0.8
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  panel:addChild(head)
  ed.layout.centerInParent(head)
  local playerName = ed.getPlayerName(userSummary._name, userSummary._medal, {
    medalScale = 0.15,
    anchorPoint = ccp(0, 0.5),
    left = true
  })
  panel:addChild(playerName)
  playerName:setPosition(ccp(87, 55))
  local labelGuildName = ed.createttf(userSummary._guild_name or T("\230\151\160"), 17)
  labelGuildName:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(labelGuildName, ed.toccc3(16700269))
  ed.setLabelStroke(labelGuildName, ed.toccc3(2233605), 1)
  panel:addChild(labelGuildName)
  labelGuildName:setPosition(ccp(87, 28))
end

function class:refreshMyRank()
  if self.selectTab == self.TAB_FIRST_BLOOD then
    self.ui.my_rank_bg:setVisible(false)
    return
  end
  local myRankData = self.rankData[self.selectTab]._self_rank
  if not myRankData then
    self.ui.my_rank_bg:setVisible(false)
    return
  end
  self.ui.my_rank_bg:setVisible(true)
  local myRank = self.rankData[self.selectTab]._self_pos
  self.ui.self_panel_pearl:setVisible(self.selectTab == self.TAB_PEARL)
  self.ui.self_panel_damage:setVisible(self.selectTab == self.TAB_DAMAGE)
  self.ui.self_panel_bless:setVisible(self.selectTab == self.TAB_BLESS)
  ed.setLabelString(self.ui.label_my_rank, myRank or "3000+")
  if self.selectTab == self.TAB_DAMAGE then
    local damage = myRankData._param1
    local difficult = myRankData._param2
    local crisis = myRankData._param3
    local heroId = myRankData._param5
    ed.setLabelString(self.ui.label_damage, damage)
    ed.setLabelString(self.ui.label_diff, string.format("\233\154\190\229\186\166%s", self.diffCfg[difficult] or ""))
    ed.setLabelString(self.ui.label_crisis_amount, crisis or 0)
    local heroIcon = ed.readhero.createIcon({
      id = heroId or 1
    }).icon
    heroIcon:setScale(0.75)
    self.ui.panel_hero_icon:addChild(heroIcon)
    ed.layout.centerInParent(heroIcon)
  elseif self.selectTab == self.TAB_PEARL then
    local pearlAmount = myRankData._param1
    ed.setLabelString(self.ui.label_pearl_amount, pearlAmount)
  elseif self.selectTab == self.TAB_BLESS then
    local blessAmount = myRankData._param1
    ed.setLabelString(self.ui.label_bless_amount, blessAmount)
  end
end

function class:getRankData(key)
  if self.rankData[key] then
    return self.rankData[key]._rank_list or {}
  end
  return {}
end

function class:requireRankData(key)
  ed.rogueLikeNet.sendRankBoard(self.chapterId, key)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("rogueRankBoard", function(_query_rankboard)
    self.rankData[self.selectTab] = _query_rankboard
    self:refreshView()
  end)
end
