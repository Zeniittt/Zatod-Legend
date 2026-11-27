local base = ed.ui.popwindow
local GuildSetMercenaryWin = newclass(base.mt)
ed.ui.GuildSetMercenaryWin = GuildSetMercenaryWin

function GuildSetMercenaryWin.create()
  local self = base.create("GuildSetMercenaryWin")
  setmetatable(self, GuildSetMercenaryWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function GuildSetMercenaryWin:initData()
  self.tabIndex = 1
end

function GuildSetMercenaryWin:dispatchHero(heroId)
  for k, v in ipairs(ed.GuildManager.selfMercenary) do
    if v.hero and v.hero._tid == heroId then
      ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\232\162\171\230\180\190\229\135\186"))
      return
    end
  end
  ed.GuildManager.curDispatchId = heroId
  local info = {
    text = T("\230\180\190\229\135\186\232\139\177\233\155\132\232\135\179\229\176\145\233\156\128\232\166\129\229\174\136\232\144\16530\229\136\134\233\146\159\239\188\140\231\161\174\232\174\164\230\180\190\229\135\186\232\139\177\233\155\132\239\188\159"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      ed.GuildNetwork:sendDispatchHero(heroId)
    end
  }
  ed.showConfirmDialog(info)
end

function GuildSetMercenaryWin:registerEvents()
  self:listenEvent("GuildAddMercenarySuccess", function(data)
    table.insert(self.selfMercIds, ed.GuildManager.curDispatchId)
    ed.setString(self.ui.label_num, string.format("%d/%d", ed.GuildManager.curMercenarys, ed.GuildManager.maxMercenarys))
    self:refreshDraglist()
  end)
  self:listenEvent("GuildDelMercenarySuccess", function(data)
    for i = 1, #self.selfMercIds do
      if self.selfMercIds[i] == data._heroid then
        table.remove(self.selfMercIds, i)
      end
    end
    ed.setString(self.ui.label_num, string.format("%d/%d", ed.GuildManager.curMercenarys, ed.GuildManager.maxMercenarys))
    self:refreshDraglist()
  end)
end

function GuildSetMercenaryWin:doClickAdd()
  local composeWin = ed.ui.chooseheroWin.create({
    name = "hero",
    signName = "guild_mercenary",
    noShowList = self.selfMercIds,
    withState = true,
    callback = function(id)
      self:dispatchHero(id)
    end
  }):popWindow()
end

function GuildSetMercenaryWin:doClickReturn(i)
  local mercenary = ed.GuildManager.selfMercenary[i]
  if not mercenary then
    return
  end
  local minTime = ed.getDataTable("GuildHirePrice")[1]["Min Legal Recall Duration"]
  local passTime = ed.getServerTime() - mercenary.time
  if minTime > passTime then
    local h, m = ed.second2hms(minTime - passTime)
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\232\191\152\230\156\137%d\229\136\134\233\146\159\230\137\141\232\131\189\229\189\146\233\152\159", m + 1))
    return
  end
  local info = {
    text = T("\230\152\175\229\144\166\231\161\174\229\174\154\232\139\177\233\155\132\229\189\146\233\152\159\239\188\159"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      local heroId = mercenary.hero._tid
      local msg = ed.upmsg.guild()
      msg._del_hire = {}
      msg._del_hire._heroid = heroId
      ed.send(msg, "guild")
    end
  }
  ed.showConfirmDialog(info)
end

function GuildSetMercenaryWin:getPos(i)
  local ox = -57
  local oy = self.ui.layer_item:getContentSize().height + 66
  local dx, dy = 136, 128
  local row = math.floor((i + 3) / 4)
  local col = (i - 1) % 4 + 1
  return ccp(ox + col * dx, oy - row * dy)
end

function GuildSetMercenaryWin:createItem(i)
  local container, ui = ed.editorui(ed.uieditor.GuildMercenaryItem)
  ed.setLabelShadow(ui.label_return, ed.toccc3(0), ccp(1, 1))
  ed.setLabelStroke(ui.goldnum, ed.toccc3(16776423), 1)
  ed.setLabelStroke(ui.label_time, ed.toccc3(1519903), 1)
  ed.setLabelStroke(ui.Label_12743, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_return, ed.toccc3(594187), 1)
  local mercenary = ed.GuildManager.selfMercenary[i]
  local isVisible = mercenary and true or false
  ui.layer1:setVisible(not isVisible)
  ui.layer2:setVisible(isVisible)
  if mercenary then
    table.insert(self.selfMercIds, mercenary.hero._tid)
    local heroInfo = ed.readhero.createIconByServer(mercenary.hero)
    local icon = heroInfo.icon
    heroInfo:showLegendEquip(not ed.openLegendEquip())
    icon:setScale(0.8)
    ed.UITool.replaceUI(ui, "layer2", "icon", icon)
    ed.setString(ui.goldnum, mercenary.money)
    ed.setString(ui.label_time, ed.time2hm(ed.getServerTime() - mercenary.time))
  end
  ui.desc2:limitWidthByScale(ui.bg:getContentSize().width - (ui.layer1:getPositionX() + ui.desc2:getPositionX()) - 10)
  ui.label_time:setPositionX(ui.time:getPositionX() + ui.time:getContentSize().width - 0.5)
  ui.ImageView_12749:setPositionX(ui.total:getPositionX() + ui.total:getContentSize().width + ui.ImageView_12749:getContentSize().width * 0.5 - 1.5)
  ui.goldnum:setPositionX(ui.ImageView_12749:getPositionX() + ui.ImageView_12749:getContentSize().width * 0.5 - 0.5)
  return container, ui
end

function GuildSetMercenaryWin:createItemGuild(data)
  local container, ui = ed.editorui(ed.uieditor.MercenaryItem)
  ed.setString(ui.name, data.name)
  local heroInfo = ed.readhero.createIconByServer(data.hero)
  local icon = heroInfo.icon
  heroInfo:showLegendEquip(not ed.openLegendEquip())
  local x, y = ui.icon:getPosition()
  icon:setPosition(ccp(x, y))
  ui.icon:setVisible(false)
  ui.bg:addChild(icon)
  return container, ui
end

function GuildSetMercenaryWin:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  self.selfMercIds = {}
  for i = 1, ed.GuildManager.maxMercenarys do
    local container, ui = self:createItem(i)
    ui.data = i
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(ccp(285, 302 - 82 * i))
  end
  self.uiList = uiList
  self.draglist:initListHeight(82 * ed.GuildManager.maxMercenarys)
end

function GuildSetMercenaryWin:refreshDraglistGuild()
  local uiList = {}
  self.draglist:clearList()
  local data = ed.GuildManager.allMercenary
  table.sort(data, function(a, b)
    return a.hero._gs > b.hero._gs
  end)
  for k, v in ipairs(data) do
    local container, ui = self:createItemGuild(v)
    ui.data = v
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(self:getPos(k))
  end
  self.uiList = uiList
  self.draglist:initListHeight(math.floor((#data + 4) / 4) * 128)
end

function GuildSetMercenaryWin:initLabels()
  ed.setLabelShadow(self.ui.title, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_xxx, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelShadow(self.ui.label_num, ccc3(0, 0, 0), ccp(2, 0))
  ed.setLabelStroke(self.ui.label_self_selected, ed.toccc3(16776423), 1)
  ed.setLabelStroke(self.ui.label_guild_selected, ed.toccc3(16776423), 1)
  ed.setLabelStroke(self.ui.label_self, ed.toccc3(3679778), 1)
  ed.setLabelStroke(self.ui.label_guild, ed.toccc3(3679778), 1)
  self.ui.label_xxx:setPositionX(self.ui.ImageView_12727:getPositionX() - self.ui.ImageView_12727:getContentSize().width / 2 - self.ui.label_xxx:getContentSize().width / 2 - 3.5)
  self.ui.label_self_selected:limitWidthByScale(self.ui.btn_self_selected:getContentSize().width * 0.7)
  self.ui.label_self:limitWidthByScale(self.ui.btn_self:getContentSize().width * 0.7)
  self.ui.label_guild_selected:limitWidthByScale(self.ui.btn_guild_selected:getContentSize().width * 0.7)
  self.ui.label_guild:limitWidthByScale(self.ui.btn_guild:getContentSize().width * 0.7)
  local titleBgWidth = self.ui.bg_title:getContentSize().width
  local ruleBtnWidth = self.ui.btn_rule:getContentSize().width
  self.ui.title:limitWidthByScale(titleBgWidth * 0.6)
  local titleWidth = self.ui.title:getContentSize().width
  local bgContentSize = self.ui.bg:getContentSize().width
  self.ui.title:setPositionX((bgContentSize - (titleWidth + ruleBtnWidth + 0.5) + titleWidth) * 0.5)
  self.ui.btn_rule:setPositionX((bgContentSize + (titleWidth + ruleBtnWidth + 0.5) - ruleBtnWidth) * 0.5)
end

function GuildSetMercenaryWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.icon1, x, y) then
        v.icon1:setScale(0.75)
        
        return v
      end
      if ed.containsPoint(v.btn_return, x, y) then
        v.btn_return:setScale(0.95)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildSetMercenaryWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.icon1, x, y) and #self.selfMercIds < 2 then
      self:doClickAdd(v.data)
      self.curIndex = v.data
    end
    if ed.containsPoint(v.btn_return, x, y) then
      self:doClickReturn(v.data)
      self.curIndex = v.data
    end
  end
  
  return handler
end

function GuildSetMercenaryWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.icon1:setScale(0.8)
    v.btn_return:setScale(1)
  end
  
  return handler
end

function GuildSetMercenaryWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildSetMercenaryWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.label_num, string.format("%d/%d", ed.GuildManager.curMercenarys, ed.GuildManager.maxMercenarys))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
  self:refreshDraglist()
end

function GuildSetMercenaryWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.GuildMercenaryRule.create({}):popWindow(999)
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_guild", function()
    if self.tabIndex == 2 then
      return
    end
    self.tabIndex = 2
    ed.setString(self.ui.label_xxx, T("\230\156\172\229\133\172\228\188\154\230\137\128\230\156\137\228\189\163\229\133\181"))
    self.ui.ImageView_12727:setVisible(false)
    self.ui.label_xxx:setPositionX(self.ui.bg:getContentSize().width * 0.5)
    self.ui.btn_self_selected:setVisible(false)
    self.ui.btn_guild_selected:setVisible(true)
    self:refreshDraglistGuild()
  end)
  ed.UITool.registerBtn(self, "btn_self", function()
    if self.tabIndex == 1 then
      return
    end
    ed.setString(self.ui.label_xxx, T("\229\183\178\230\180\190\229\135\186\228\189\163\229\133\181\230\149\176\233\135\143:"))
    self.ui.label_xxx:setPositionX(self.ui.ImageView_12727:getPositionX() - self.ui.ImageView_12727:getContentSize().width / 2 - self.ui.label_xxx:getContentSize().width / 2 - 3.5)
    self.ui.ImageView_12727:setVisible(true)
    ed.setString(self.ui.label_num, string.format("%d/%d", ed.GuildManager.curMercenarys, ed.GuildManager.maxMercenarys))
    self.tabIndex = 1
    self.ui.btn_self_selected:setVisible(true)
    self.ui.btn_guild_selected:setVisible(false)
    self:refreshDraglist()
  end)
end
