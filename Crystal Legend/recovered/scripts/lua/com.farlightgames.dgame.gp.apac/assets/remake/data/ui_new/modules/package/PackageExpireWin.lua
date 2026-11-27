local base = ed.ui.popwindow
local packageExpireWin = newclass(base.mt)
ed.ui.packageExpireWin = packageExpireWin

function packageExpireWin.checkExpireItem()
  local expireItem = ed.player:getItemsExpire()
  local expireTimelyItem = ed.player:getTimelyItemsExpire()
  local allPopItem = {}
  local expireItemPop = {}
  local expireTimelyItemPop = {}
  local unexpiredTimelyItem = {}
  local unexpiredItem = {}
  local expireTimelyItemDetail = {}
  for index, itemData in ipairs(expireItem) do
    table.insert(allPopItem, itemData._id)
    table.insert(expireItemPop, itemData._id)
    table.insert(expireTimelyItemDetail, {
      id = itemData._id,
      amount = ed.player:getEquipAmount(itemData._id)
    })
  end
  for index, itemData in pairs(ed.player._item_expiry or {}) do
    local itemId = itemData._item_id
    local expire_time = itemData._expire_time
    if expire_time < ed.getServerTime() then
      table.insert(allPopItem, itemId)
      table.insert(expireTimelyItemDetail, {
        id = itemId,
        amount = ed.player:getEquipAmount(itemId)
      })
    else
      table.insert(unexpiredItem, itemData)
    end
  end
  ed.player._item_expiry = unexpiredItem
  for index, itemData in ipairs(expireTimelyItem) do
    local expire_time = itemData._expire_time
    if expire_time < ed.getServerTime() then
      local insId = itemData._insid
      local timelyId = itemData._timely_id
      local timelyItem = ed.getDataTable("TimelyItem")[timelyId] or {}
      local itemId = timelyItem["Item ID"]
      table.insert(expireTimelyItemPop, insId)
      table.insert(expireTimelyItemDetail, {
        insid = insId,
        id = itemId,
        amount = ed.player:getNewEquipAmount(itemId, insId)
      })
      table.insert(allPopItem, itemId)
    else
      table.insert(unexpiredTimelyItem, itemData)
    end
  end
  if 0 < #allPopItem then
    packageExpireWin.create(allPopItem):popWindow()
    packageExpireWin.clearExpireItem(expireItemPop, expireTimelyItemPop)
    ListenEvent("resolveExpiredReply", function()
      for k, v in ipairs(expireTimelyItemDetail) do
        ed.player:consumeItemInPackage(v.id, v.amount, v.insid)
      end
      if 0 < #expireTimelyItemDetail then
        FireEvent("PackageRefresh")
      end
      ed.player:setItemsExpire({
        _items = {},
        _timely_items = unexpiredTimelyItem
      })
    end)
  end
end

function packageExpireWin.clearExpireItem(expireItemPop, expireTimelyItemPop)
  local msg = ed.upmsg.resolve_expired_item()
  msg._item_ids = expireItemPop
  msg._timely_item_insids = expireTimelyItemPop
  ed.send(msg, "resolve_expired")
end

function packageExpireWin.create(data)
  local self = base.create("packageExpireWin")
  setmetatable(self, packageExpireWin.mt)
  self:init(data)
  return self
end

function packageExpireWin:init(data)
  self.data = data
  self.tbViewCol = 6
  self:initView()
  self:addEventListener()
end

function packageExpireWin:initView()
  local container, ui = ed.editorui(ed.uieditor.packageExpire)
  self.container:addChild(container)
  self.ui = ui
  self:show()
  self:initTbView()
  self:adaptUI()
end

function packageExpireWin:initTbView()
  local tbViewWidth = math.min(#self.data, self.tbViewCol) * 90
  local row = math.ceil(#self.data / self.tbViewCol)
  local tbViewHeight = math.min(row * 90, 225)
  self.ui.itemTableView:setContentSize(CCSizeMake(tbViewWidth, tbViewHeight))
  local delegate = {
    numberOfCells = function()
      return #self.data
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(90, 90)
    end,
    createCell = function(index)
      return self:createItem(self.data[index])
    end
  }
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, tbViewWidth, tbViewHeight),
    container = self.ui.itemTableView,
    touchpriority = -315,
    zorder = 10,
    dragMode = 1,
    noshade = true,
    colNum = self.tbViewCol
  }
  self.itemTbView = Tableview.create(param)
end

function packageExpireWin:adaptUI()
  local tbViewSize = self.ui.itemTableView:getContentSize()
  self.ui.bg:setContentSize(CCSizeMake(self.ui.bg:getContentSize().width, tbViewSize.height + 90))
  ed.layout.centerInParent(self.ui.itemTableView)
  self.ui.title:setPositionY(self.ui.bg:getContentSize().height - 20)
end

function packageExpireWin:createItem(itemData)
  local itemId = itemData
  local icon = ed.readequip.createIcon(itemId)
  local timeCornerBg = ed.createSprite("UI/alpha/1080P/package/bg_time.png")
  local iconTime = ed.createSprite("UI/alpha/1080P/package/icon_time.png")
  local labelTime = ed.createLabelTTF("0s", 14)
  local expireArtWordBg = ed.createSprite("UI/alpha/1080P/package/new/equip_timeout_bg.png")
  local labelExpire = ed.createttf(T("\229\183\178\232\191\135\230\156\159"), 14)
  labelExpire:setFontName(ed.fontBold)
  ed.setLabelColor(labelExpire, ed.toccc3(15592684))
  ed.setLabelStroke(labelExpire, ed.toccc3(1315602), 1)
  expireArtWordBg:addChild(labelExpire)
  ed.layout.centerInParent(labelExpire)
  ed.setLabelColor(labelTime, ccc3(255, 108, 108))
  ed.setLabelStroke(labelTime, ccc3(85, 26, 12), 2)
  labelTime:setAnchorPoint(ccp(0, 0.5))
  labelTime:setPosition(ccp(18, 9))
  iconTime:setPosition(ccp(9, 8))
  timeCornerBg:setPosition(ccp(20, 75))
  timeCornerBg:setScale(0.8)
  timeCornerBg:addChild(iconTime)
  timeCornerBg:addChild(labelTime)
  icon:addChild(expireArtWordBg)
  ed.layout.centerInParent(expireArtWordBg)
  icon:addChild(timeCornerBg)
  return icon
end

function packageExpireWin:addEventListener()
  self:btRegisterHandler({
    key = "close",
    handler = function(event, x, y)
      if event ~= "ended" then
        return false
      end
      if not ed.containsPoint(self.ui.bg, x, y) then
        self:close()
        return false
      end
      return false
    end
  })
end

function packageExpireWin:close()
  self:destroy()
end
