local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.ontimeupgrade = class
local ed = ed
local herodetail = ed.ui.herodetail
local eventScope = {}
local lastClickItemTime = 0

local function oneTimeUpgradeReply(data)
  local result = data._result == "success"
  CloseScope(eventScope)
  if result then
    if not ed.netdata.upgrade_consume then
      return
    end
    for k, item in pairs(ed.netdata.upgrade_consume.list or {}) do
      ed.player:addEquip(item.eid, -item.amount)
    end
    local consume = ed.netdata.upgrade_consume.exp
    if consume and 0 < consume then
      ed.player:addMoney(-consume)
    end
    ed.netreply.upgradehandler()
  else
    local eid = data._equip_id
    if eid then
      local ename = ed.getEquipColumn(eid, "Name")
      ed.showToast(T("%s\228\184\141\232\182\179", ename))
    end
  end
end

local function destroyCallback()
  ed.netreply.upgradehandler = nil
  CloseScope(eventScope)
end

local function doClickOk(self)
  if self.type == "lack" then
    return
  end
  if not self.clickOk then
    self.clickOk = true
    ListenEvent("heroupgradereplay", oneTimeUpgradeReply, eventScope)
    ed.netdata.upgrade_consume = {
      list = self.upgrade_item_list,
      exp = self.upgrade_exp
    }
    
    function ed.netreply.upgradehandler()
      self:destroy({callback = destroyCallback})
    end
    
    self.confirm_handler()
  end
end

class.doClickOk = doClickOk

local function registerTouchHandler(self, touchNode)
  local ui = self.ui
  touchNode:btRegisterButtonClick({
    button = ui.confirm_button,
    press = ui.confirm_button_press,
    clickHandler = function()
      self:doClickOk()
    end
  })
  touchNode:btRegisterButtonClick({
    button = ui.cancel_button,
    press = ui.cancel_button_press,
    clickHandler = function()
      self:destroy({callback = destroyCallback})
    end
  })
  touchNode:btRegisterButtonClick({
    button = ui.confirm_button_forbidden,
    press = ui.confirm_button_forbidden_press,
    clickHandler = function()
      self:destroy({callback = destroyCallback})
    end
  })
end

class.registerTouchHandler = registerTouchHandler

local function sortTable(a, b)
  local exp_a = ed.lookupDataTable("equip", "Exp", a.eid)
  local exp_b = ed.lookupDataTable("equip", "Exp", b.eid)
  if exp_a > exp_b then
    return true
  end
end

local function sortItemList(type, list)
  if not list then
    return
  end
  local temp = {}
  for k, item in pairs(list) do
    local config = {eid = k, amount = item}
    table.insert(temp, config)
  end
  if type == "lack" then
    table.sort(temp, function(a, b)
      return a.eid > b.eid
    end)
  else
    table.sort(temp, function(a, b)
      return sortTable(a, b)
    end)
  end
  return temp
end

local function createWindow(self)
  self.frame, self.ui = ed.editorui(ed.uieditor.oneTimeUpgrade)
  self.container:addChild(self.frame)
  local touchNode = ed.ui.basetouchnode.btCreate()
  self.frame:setTouchEnabled(true)
  self.frame:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -298, true)
  self.touchNode = touchNode
end

class.createWindow = createWindow

function class:initEnoughUI()
  if not self.hid then
    return
  end
  local ui = self.ui or {}
  local hero_name = ed.getDataTable("Unit")[self.hid]["Display Name"]
  ed.setString(ui.confirm_des_text, string.format(T("\230\152\175\229\144\166\231\161\174\229\174\154\232\166\129\232\191\155\233\152\182%s?"), hero_name))
  ui.top_text:setString(T("\232\191\155\233\152\182\233\156\128\232\166\129\230\182\136\232\128\151\228\187\165\228\184\139\232\181\132\230\186\144\239\188\154"))
  ui.top_text:setPositionY(355.7)
  ui.description_text:setDimensions(CCSizeMake(280, 0))
  ui.description_text:setString(T("\232\191\155\233\152\182\229\144\142\232\163\133\229\164\135\233\153\132\233\173\148\230\149\136\230\158\156\229\176\134\230\182\136\229\164\177\239\188\140\229\185\182\232\191\148\232\191\152\228\184\128\233\131\168\229\136\134\233\153\132\233\173\148\230\157\144\230\150\153."))
  ui.cancel_button:setVisible(true)
  ui.cancel_text:setVisible(true)
  ui.confirm_text:setVisible(true)
  ui.confirm_text_forbidden:setVisible(false)
  ui.confirm_button:setVisible(true)
  ui.confirm_button_forbidden:setVisible(false)
end

function class:initLackUI()
  if not self.hid then
    return
  end
  local ui = self.ui or {}
  ui.top_text:setString(T("\228\189\160\232\191\152\233\156\128\232\166\129\228\187\165\228\184\139\232\181\132\230\186\144\230\137\141\232\131\189\232\191\155\233\152\182\239\188\154"))
  ui.top_text:setPositionY(345.7)
  ui.description_text:setVisible(false)
  ui.confirm_des_text:setVisible(false)
  ui.confirm_button:setVisible(false)
  ui.confirm_button_press:setVisible(false)
  ui.confirm_button_forbidden:setVisible(true)
  ui.confirm_text:setVisible(false)
  ui.confirm_text_forbidden:setVisible(true)
  ui.cancel_button:setVisible(false)
  ui.cancel_text:setVisible(false)
end

function class:checkItemNotEnough()
  for k, item in pairs(self.upgrade_item_list) do
    local eid = item.eid
    if eid == self.historyItem then
      return true
    end
  end
  return false
end

local function initUI(self)
  if self.type == "enough" then
    self:initEnoughUI()
    self:closeCraftLayer()
  elseif self.type == "lack" then
    self:initLackUI()
    if self:checkItemNotEnough() then
      return
    end
    self:closeCraftLayer()
  end
end

class.initUI = initUI

function class:convertFragment(eid, amount)
  self.fragmentData = self.fragmentData or ed.getDataTable("fragment")
  for itemid, row in pairs(self.fragmentData) do
    if row["Fragment ID"] == eid then
      local num = math.ceil(amount / row["Fragment Count"])
      return itemid, num
    end
  end
end

function class:filterItem(itemList)
  local temp = {}
  for eid, amount in pairs(itemList) do
    local Category = ed.getEquipColumn(eid, "Category")
    if "\231\162\142\231\137\135" == Category then
      local id, num = self:convertFragment(eid, amount)
      if id then
        temp[id] = num
      end
    else
      temp[eid] = amount
    end
  end
  return temp
end

local function initData(self)
  self.upgrade_item_list = {}
  local equip_requirement_level = 0
  self.consume_exp = 0
  local hero = ed.player:getHero(self.hid)
  local canUpgrade, oneTimeUpgrade, consume = ed.readhero.checkOneTimeUpgradeCondition({
    hid = self.hid,
    hero = hero
  })
  if canUpgrade then
    self.type = "enough"
  else
    self.type = "lack"
  end
  local itemList = consume.consume
  if self.type == "lack" then
    itemList = self:filterItem(consume.lackequips)
  end
  self.upgrade_item_list = sortItemList(self.type, itemList)
  self.upgrade_exp = consume.exp
  self.clickOk = false
end

class.initData = initData

function class:doPressInList()
  local function handler(x, y)
    if self.type == "enough" then
      return
    end
    if ed.getServerTime() - lastClickItemTime < 0.3 then
      return
    end
    lastClickItemTime = ed.getServerTime()
    for k, item in pairs(self.itemListData) do
      if k > #self.upgrade_item_list then
        return
      end
      if ed.containsPoint(item.icon, x, y) then
        return k
      end
    end
    return
  end
  
  return handler
end

function class:mainLayerRunAction(pos)
  local bg = self.ui.frame_bg
  local ml = CCMoveTo:create(0.2, pos)
  ml = CCEaseElasticOut:create(ml, 5)
  bg:runAction(ml)
end

function class:closeCarftLayer()
  self:mainLayerRunAction(ccp(400, 249))
  local cLayer = self.craftLayer
  if not cLayer.mainLayer then
    return
  end
  self.craftLayer.mainLayer:removeFromParentAndCleanup(true)
  self.craftLayer.mainLayer = nil
  self.craftLayer = {}
end

function class:createCraftLayer(eid)
  local param = {
    context = "handbook",
    eid = eid,
    openCraftPanel = true,
    notOpenLeftPanel = true,
    notShow = true,
    notSwallowsTouch = true,
    notOutLayerTouch = true,
    destroyCallback = function()
      self:closeCarftLayer()
    end
  }
  self.craftLayer = ed.ui.equipcraft.create(param)
  local cLayer = self.craftLayer
  self.container:addChild(cLayer.mainLayer, -2)
  return self.craftLayer
end

function class:craftLayerRunAction(pos, func)
  local cLayer = self.craftLayer
  local mr = CCMoveTo:create(0.2, pos)
  mr = CCEaseElasticOut:create(mr, 5)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if func then
        func()
      end
    end, EDDebug)
  end)
  cLayer.craftWindow.mainLayer:runAction(CCSequence:createWithTwoActions(mr, func))
end

function class:openCraftLayer(eid)
  local bg = self.ui.frame_bg
  local craftpos = ccp(580, 249)
  if self.craftLayer.mainLayer then
    self.craftLayer.mainLayer:removeFromParentAndCleanup(true)
    local cLayer = self:createCraftLayer(eid)
    cLayer.craftWindow.mainLayer:setPosition(craftpos)
  else
    self:mainLayerRunAction(ccp(250, 249))
    self:createCraftLayer(eid)
    
    local function func()
      local cLayer = self.craftLayer
      cLayer.craftWindow.mainLayer:setZOrder(2)
    end
    
    self:craftLayerRunAction(craftpos, func)
  end
end

function class:closeCraftLayer()
  self:closeCarftLayer()
end

function class:doClickInList()
  local function handler(x, y, i)
    ed.endTeach("UPGradeLack")
    
    local eid = self.itemListData[i].eid
    if self.historyItem == eid and self.craftLayer.mainLayer then
      self:closeCraftLayer()
    else
      self:openCraftLayer(eid)
    end
    self.historyItem = eid
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler()
  end
  
  return handler
end

function class:cancelClickInList()
  local function handler()
  end
  
  return handler
end

function class:clearDragList()
  if self.item_listview then
    self.item_listview.mainLayer:removeFromParentAndCleanup(true)
    self.item_listview = nil
  end
end

function class:createDragList()
  self:clearDragList()
  local container = self.ui.list_bg
  local dragType = self.dragType
  local draglistInfo = {
    cliprect = dragType.cliprect,
    rect = dragType.rect,
    container = container,
    priority = -299,
    noshade = false,
    upshade = "UI/alpha/HVGA/activity/recharge_list_mask_bottom.png",
    downshade = "UI/alpha/HVGA/activity/recharge_list_mask_bottom.png",
    swallow = false,
    bar = {
      bglen = dragType.bglen,
      bgpos = dragType.bgpos
    },
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.item_listview = ed.draglist.create(draglistInfo)
  self.itemListData = {}
end

function class:setDragListType()
  local dragType = {}
  if self.type == "lack" then
    dragType.cliprect = CCRectMake(10, 1, 318, 234)
    dragType.rect = CCRectMake(10, 2, 318, 234)
    dragType.bglen = 180
    dragType.bgpos = ccp(3, 118)
  else
    dragType.cliprect = CCRectMake(10, 1, 318, 195)
    dragType.rect = CCRectMake(10, 2, 318, 195)
    dragType.bglen = 120
    dragType.bgpos = ccp(3, 100)
  end
  self.dragType = dragType
end

function class:refreshDragList(count)
  local dt = 80
  local ox, oy = 55, 175
  if self.type == "lack" then
    oy = 200
  end
  local dx, dy = 85, 75
  local colum = 4
  local height = dt * math.ceil(count / colum)
  for k = 1, count do
    local item = self.itemListData[k].icon
    local x = (k - 1) % colum * dx + ox
    local y = oy - (math.ceil(k / colum) - 1) * dy
    item:setPosition(ccp(x, y))
  end
  self.item_listview:initListHeight(height)
end

local function createItemList(self)
  local index = 0
  for k, item in pairs(self.upgrade_item_list or {}) do
    local bg, equip
    local x, y = 15, -20
    local wh = 55
    bg, equip = ed.readequip.createIcon(item.eid, wh)
    local label = ed.createLabelWithFontInfo("x" .. item.amount, "small_normal_button")
    label:setPosition(ccp(x, y))
    label:setAnchorPoint(ccp(0.5, 0.5))
    local icon = CCSprite:create()
    bg:setPosition(ccp(15, 15))
    icon:addChild(bg)
    icon:addChild(label)
    icon:setContentSize(CCSizeMake(wh, wh))
    self.item_listview:addItem(icon)
    index = index + 1
    self.itemListData[index] = {
      icon = icon,
      eid = item.eid
    }
  end
  if self.type == "enough" and self.upgrade_exp and 0 < self.upgrade_exp then
    local bg, equip
    bg = CCSprite:create("UI/alpha/1080P/common/goldicon_small.png")
    local label = ed.createLabelWithFontInfo("x" .. self.upgrade_exp, "small_normal_button")
    label:setPosition(ccp(7, -30))
    label:setAnchorPoint(ccp(0.5, 0.5))
    local icon = CCSprite:create()
    bg:setPosition(ccp(7, 8))
    icon:addChild(bg)
    icon:addChild(label)
    icon:setContentSize(bg:getContentSize())
    self.item_listview:addItem(icon)
    index = index + 1
    self.itemListData[index] = {icon = icon}
  end
  self:refreshDragList(index)
end

class.createItemList = createItemList

function class:teach()
  if not (self.itemListData and self.itemListData[1]) or not self.item_listview then
    return
  end
  if self.type == "lack" and not tolua.isnull(self.itemListData[1].icon) and not tolua.isnull(self.item_listview.listLayer) then
    ed.teach("UPGradeLack", ccp(45, 185), 10, self.itemListData[1].icon, self.item_listview.listLayer)
  end
end

function class:refreshListBg()
  if self.type == "enough" then
    local container = self.ui.list_bg
    local dt = 40
    local size = container:getContentSize()
    local posY = container:getPositionY() + dt
    container:setContentSize(CCSizeMake(size.width, size.height - dt))
    container:setPositionY(posY)
  end
end

function class:onEnter()
  destroyCallback()
  self.itemListData = {}
  self:initData()
  self:initUI()
  self:refreshListBg()
  self:setDragListType()
  self:createDragList()
  self:createItemList()
  self:registerTouchHandler(self.touchNode)
  self:teach()
end

local function create(param)
  param = param or {}
  local self = base.create("onetimeupgrade")
  setmetatable(self, class.mt)
  self.hid = param.hid
  self.confirm_handler = param.handler or function()
  end
  self:createWindow()
  self.craftLayer = {}
  self:registerOnEnterHandler("fastUpgradeEnter", function()
    self:onEnter()
  end)
  self:show()
  return self
end

class.create = create

local function pop(param, z)
  local window = create(param)
  if window then
    window:popWindow(z or 501)
  end
end

class.pop = pop
