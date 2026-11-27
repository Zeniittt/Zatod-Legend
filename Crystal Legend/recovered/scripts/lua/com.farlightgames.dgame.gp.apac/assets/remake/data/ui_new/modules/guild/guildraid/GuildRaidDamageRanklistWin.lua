local base = ed.ui.popwindow
local GuildRaidDamageRanklistWin = newclass(base.mt)
ed.ui.GuildRaidDamageRanklistWin = GuildRaidDamageRanklistWin

function GuildRaidDamageRanklistWin.create(data)
  local self = base.create("GuildRaidDamageRanklistWin")
  setmetatable(self, GuildRaidDamageRanklistWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildRaidDamageRanklistWin:initData(data)
  self.ranklistData = data._damages
end

function GuildRaidDamageRanklistWin:initLabels()
end

function GuildRaidDamageRanklistWin:createItem(rank, info)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.RaidDamageRanklistItem)
  if rank == 1 then
    ed.setTexture(ui.rank, "UI/alpha/1080P/rankingscene/ranking_yellow.png")
    ed.setTexture(ui.rank_num, "UI/alpha/1080P/rankingscene/1st.png")
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
  ed.setString(ui.label_bar, info._damage)
  ed.setLabelStroke(ui.label_bar, ed.toccc3(2565412), 1)
  ui.bar:setScaleX(info._damage / self.maxDamage)
  local userData = info._user_summary
  local node, headIcon = ed.getWholeHeadIcon({
    id = userData._avatar,
    name = userData._name,
    medal = userData._medal,
    level = userData._level,
    lvoffset = {x = 0, y = 0},
    config = {
      namefont = "main_icon_name"
    },
    scale = 0.7
  })
  ed.UITool.replaceUI(ui, "bg", "avatar", node)
  ui.avatar = headIcon
  return container, ui
end

function GuildRaidDamageRanklistWin:getPos(i)
  local size = self.ui.layer_item:getContentSize()
  local ox = size.width / 2
  local oy = size.height + 35
  local dy = 72
  return ccp(ox, oy - i * dy)
end

function GuildRaidDamageRanklistWin:refreshDraglist(oldPos)
  local oldY = self.draglist.listLayer:getPositionY()
  self.uiList = {}
  self.draglist:clearList()
  local listData = self.ranklistData
  self.maxDamage = listData[1]._damage
  for k, v in ipairs(listData) do
    local container, ui = self:createItem(k, v)
    ui.data = v
    table.insert(self.uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(self:getPos(k))
  end
  self.draglist:initListHeight(72 * #listData)
  if oldPos then
    self.draglist.listLayer:setPositionY(oldY)
  end
end

function GuildRaidDamageRanklistWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      local btn = v.avatar
      
      if ed.containsPoint(btn, x, y) then
        btn:setScale(0.65)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildRaidDamageRanklistWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local data = v.data[".data"]
    local summary = data._user_summary
    data = {
      _rank = data._rank,
      _summary = summary,
      _user_id = summary._uid,
      _win_cnt = data._damage,
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

function GuildRaidDamageRanklistWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.avatar:setScale(0.7)
  end
  
  return handler
end

function GuildRaidDamageRanklistWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.RaidDamageRanklistWin)
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    priority = -101,
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
end

function GuildRaidDamageRanklistWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function GuildRaidDamageRanklistWin:popWindow(zOrder)
  base.popWindow(self, zOrder)
end

function GuildRaidDamageRanklistWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self, {skipAnim = true})
end
