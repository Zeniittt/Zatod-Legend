local base = ed.ui.popwindow
local GuildGameplayRanklistWin = newclass(base.mt)
ed.ui.GuildGameplayRanklistWin = GuildGameplayRanklistWin
GuildGameplayRanklistWin.TabType = {None = 0, Dreamland = 1}
local ProtoType = {
  [GuildGameplayRanklistWin.TabType.Dreamland] = "dreamland"
}

function GuildGameplayRanklistWin.create(btnType)
  local self = base.create("GuildGameplayRanklistWin")
  setmetatable(self, GuildGameplayRanklistWin.mt)
  self.curBtnType = GuildGameplayRanklistWin.TabType.None
  self.ranklistData = {}
  self.isReversing = false
  self:initUI()
  self:registerEvents()
  self:registerTouchHandlers()
  self:popWindow()
  self:changeTab(btnType or GuildGameplayRanklistWin.TabType.Dreamland)
  return self
end

function GuildGameplayRanklistWin:RefreshItemInfo(itemUI, info)
  itemUI.data = info
  if info._rank == 1 then
    ed.setTexture(itemUI.rank, "UI/alpha/1080P/rankingscene/ranking_yellow.png", true)
    ed.setTexture(itemUI.rank_num, "UI/alpha/1080P/rankingscene/1st.png", true)
    local size = itemUI.rank:getContentSize()
    itemUI.rank_num:setPosition(ccp(size.width / 2, size.height / 2))
    itemUI.rank:setVisible(true)
    if itemUI.rank_numNodeInfo then
      itemUI.rank_numNodeInfo.node:setVisible(false)
    end
  elseif info._rank == 2 then
    ed.setTexture(itemUI.rank, "UI/alpha/1080P/rankingscene/ranking_blue.png", true)
    ed.setTexture(itemUI.rank_num, "UI/alpha/1080P/rankingscene/2nd.png", true)
    local size = itemUI.rank:getContentSize()
    itemUI.rank_num:setPosition(ccp(size.width / 2, size.height / 2))
    itemUI.rank:setVisible(true)
    if itemUI.rank_numNodeInfo then
      itemUI.rank_numNodeInfo.node:setVisible(false)
    end
  elseif info._rank == 3 then
    ed.setTexture(itemUI.rank, "UI/alpha/1080P/rankingscene/ranking_gold.png", true)
    ed.setTexture(itemUI.rank_num, "UI/alpha/1080P/rankingscene/3rd.png", true)
    local size = itemUI.rank:getContentSize()
    itemUI.rank_num:setPosition(ccp(size.width / 2, size.height / 2))
    itemUI.rank:setVisible(true)
    if itemUI.rank_numNodeInfo then
      itemUI.rank_numNodeInfo.node:setVisible(false)
    end
  else
    itemUI.rank:setVisible(false)
    if itemUI.rank_numNodeInfo then
      itemUI.rank_numNodeInfo.node:setVisible(true)
      ed.refreshNumberNode(itemUI.rank_numNodeInfo, info._rank)
    else
      local numNode = ed.getNumberNode({
        text = info._rank,
        folder = "big_pvp"
      })
      itemUI.rank_numNodeInfo = numNode
      itemUI.rank_numNodeInfo.node:setPosition(itemUI.rank:getPosition())
      itemUI.bg:addChild(itemUI.rank_numNodeInfo.node, itemUI.rank:getZOrder())
    end
  end
  ed.setString(itemUI.label_bar, info._param1)
  ed.setLabelStroke(itemUI.label_bar, ed.toccc3(2565412), 1)
  itemUI.bar:setScaleX(info._param1 / self.maxDamage)
  local userData = info._user_summary
  local node, headIcon = ed.getWholeHeadIcon({
    id = userData._avatar,
    name = userData._name,
    medal = userData._medal,
    level = userData._level,
    config = {
      namefont = "main_icon_name"
    },
    lvoffset = {x = -48, y = -25},
    scale = 0.6
  })
  ed.UITool.replaceUI(itemUI, "bg", "avatar", node)
  itemUI.avatar = node
  itemUI.headIcon = headIcon
end

function GuildGameplayRanklistWin:getPos(i)
  local size = self.ui.layer_item:getContentSize()
  local ox = size.width / 2
  local oy = size.height + 35
  local dy = 72
  return ccp(ox, oy - i * dy)
end

function GuildGameplayRanklistWin:buildDraglist(oldPos)
  local totalNum = #self.ranklistData
  if 0 < totalNum then
    self.maxDamage = self.ranklistData[1]._param1
    for i = 1, totalNum do
      local itemContainer = CCNode:create()
      local itemUI = {}
      itemUI.itemContainer = itemContainer
      local readnode = ed.readnode.create(itemContainer, itemUI)
      readnode:addNode(ed.uieditor.GuildGameplayRanklistItem)
      table.insert(self.uiList, itemUI)
      self.draglist:addItem(itemContainer)
      itemContainer:setPosition(self:getPos(i))
      self:RefreshItemInfo(itemUI, self.ranklistData[i])
    end
    self.draglist:initListHeight(72 * totalNum)
  end
end

function GuildGameplayRanklistWin:onReverseEvent()
  self.isReversing = not self.isReversing
  local totalNum = #self.uiList
  if 0 < totalNum then
    for i = 1, totalNum do
      local dataIndex = self.isReversing and totalNum - i + 1 or i
      self:RefreshItemInfo(self.uiList[i], self.ranklistData[dataIndex])
    end
    self.draglist:reset()
    self.draglist.listLayer:setPositionY(0)
  end
end

function GuildGameplayRanklistWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      local btn = v.headIcon
      
      if ed.containsPoint(btn, x, y) then
        btn:setScale(0.65)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildGameplayRanklistWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local data = v.data
    local summary = data._user_summary
    data = {
      _rank = data._rank,
      _summary = summary,
      _user_id = summary._uid,
      _win_cnt = data._param1,
      _gs = 0
    }
    local panel = ed.ui.userPvpSummaryWin.create(data)
    panel:popWindow()
    panel.ui.settlementLabel:setString(T("\229\189\147\229\137\141\228\188\164\229\174\179\230\142\146\229\144\141\239\188\154"))
    panel.ui.winCountLabel:setString(T("\228\188\164\229\174\179\229\128\188\239\188\154"))
    panel.ui.gsCountBg:setVisible(false)
  end
  
  return handler
end

function GuildGameplayRanklistWin:cancelPressInList()
  local function handler(x, y, v)
    if not v or not v.headIcon then
      return
    end
    v.headIcon:setScale(0.7)
  end
  
  return handler
end

function GuildGameplayRanklistWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.GuildGameplayRanklistWin)
  self.btnConfig = {
    [GuildGameplayRanklistWin.TabType.Dreamland] = {
      normalLabel = self.ui.label_tab0,
      selectedLabel = self.ui.label_tab0_selected,
      normalBtnKey = "tab0",
      selectedBtnKey = "tab0_selected"
    }
  }
  for k, v in pairs(self.btnConfig) do
    ed.setLabelStroke(v.normalLabel, ed.toccc3(1578519), 1)
    ed.setLabelStroke(v.selectedLabel, ed.toccc3(6305310), 1)
    v.normalLabel:limitWidthByScale(95)
    v.selectedLabel:limitWidthByScale(95)
  end
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    priority = -300,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function GuildGameplayRanklistWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  for k, v in pairs(self.btnConfig) do
    ed.UITool.registerBtn(self, v.normalBtnKey, function()
      self:changeTab(k)
    end)
    ed.UITool.registerBtn(self, v.selectedBtnKey, function()
    end)
  end
  ed.UITool.registerBtn(self, "btn_reverse", function()
    self:onReverseEvent()
  end, {pressScale = 0.9})
end

function GuildGameplayRanklistWin:changeTab(btnType)
  if self.curBtnType == btnType then
    return
  end
  self.curBtnType = btnType
  self.isReversing = false
  self.uiList = {}
  self.ranklistData = {}
  self.draglist:clearList()
  for k, v in pairs(self.btnConfig) do
    self.ui[v.normalBtnKey]:setVisible(k ~= self.curBtnType)
    self.ui[v.selectedBtnKey]:setVisible(k == self.curBtnType)
  end
  if nil ~= ProtoType[btnType] then
    ed.GuildNetwork:sendGuildGameplayRank(ProtoType[btnType])
  end
end

function GuildGameplayRanklistWin:registerEvents()
  self:listenEvent("GuildGameplayRank", function(data)
    if data and data._ranklist_item then
      self.ranklistData = {}
      for i, v in ipairs(data._ranklist_item) do
        local rankItem = ed.copyProto(v)
        rankItem._rank = i
        table.insert(self.ranklistData, rankItem)
      end
      self:buildDraglist()
    end
  end)
end

function GuildGameplayRanklistWin:popWindow(zOrder)
  base.popWindow(self, zOrder)
end

function GuildGameplayRanklistWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self, {skipAnim = true})
end
