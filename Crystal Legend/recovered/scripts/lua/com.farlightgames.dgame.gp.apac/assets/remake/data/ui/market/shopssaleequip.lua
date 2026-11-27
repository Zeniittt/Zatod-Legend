local ShopsSaleEquip = {}
ShopsSaleEquip.__index = ShopsSaleEquip
ed.ui.ShopsSaleEquip = ShopsSaleEquip
local ShopsSaleEquipScope = {}
local shopsMgr = ed.ShopMgr.getInstance()

function ShopsSaleEquip:onDestory(shopId)
  if self.callBack and shopId then
    self.callBack(shopId)
  end
  if self.cutDown then
    self.container:stopAction(self.cutDown)
  end
  CloseScope(ShopsSaleEquipScope)
  self:destroy()
end

function ShopsSaleEquip.create(param)
  local base = ed.ui.popwindow
  setmetatable(ShopsSaleEquip, base.mt)
  local self = base.create("shopssaleequip", {isShade = true})
  setmetatable(self, ShopsSaleEquip)
  self:show({skipAnim = false})
  self:initData(param)
  self:initUI()
  self:registerHandler()
  return self
end

function ShopsSaleEquip:initData(param)
  param = param or {}
  self.callBack = param.callBack
  self.ids = param.ids or {}
  self.ui = {}
  self.container = {}
  local data = shopsMgr:getItemsDataByItemids(self.ids)
  self.listData, self.shopIds = self:delSameItem(data)
end

function ShopsSaleEquip:delSameItem(data)
  local temp = {}
  local newData = {}
  local shopIds = {}
  for _, v in pairs(data or {}) do
    if v.shopId then
      if tonumber(v.shopId) < 10 then
        local key = "0" .. v.shopId .. v.itemId
        temp[key] = true
      else
        local key = v.shopId .. v.itemId
        temp[key] = true
      end
    end
  end
  for k, _ in pairs(temp) do
    local t = {}
    t.shopId = tonumber(string.sub(k, 1, 2))
    t.itemId = tonumber(string.sub(k, 3, string.len(k)))
    if t.shopId ~= 8 then
      table.insert(newData, t)
      table.insert(shopIds, t.shopId)
    end
  end
  return newData, shopIds
end

function ShopsSaleEquip:initUI()
  local container, ui = ed.editorui(ed.uieditor.ShopsSaleEquip)
  self.container = container
  self.ui = ui
  self.mainLayer:addChild(container)
  self.draglist = self:createDraglist()
  self:initListView()
  self:doPlayCutDown()
  ListenEvent("shopsDataHasRefreshed", function()
    self:shopsDataHasExpire()
  end, ShopsSaleEquipScope)
  shopsMgr:reqRefreshMultiShopData(self.shopIds)
end

function ShopsSaleEquip:shopsDataHasExpire()
  local data = shopsMgr:getItemsDataByItemids(self.ids)
  self.listData = self:delSameItem(data)
  if #(self.listData or {}) <= 0 then
    ed.showToast(T("\229\149\134\229\186\151\230\149\176\230\141\174\229\183\178\232\191\135\230\156\159\239\188\140\232\175\183\233\135\141\230\150\176\230\137\147\229\188\128\232\139\177\233\155\132\233\157\162\230\157\191\239\188\129"))
  elseif self.draglist then
    self.draglist:clearList()
    self:initListView()
    self:doPlayCutDown()
  end
end

function ShopsSaleEquip:doPlayCutDown()
  local function callback()
    xpcall(function()
      self:playTimeC()
    end, EDDebug)
  end
  
  if self.cutDown == nil then
    self.cutDown = ed.timeSchedule(self.container, callback, 1)
  end
end

function ShopsSaleEquip:createDraglist()
  local w, h = self.ui.listPanel:getContentSize().width, self.ui.listPanel:getContentSize().height
  local info = {
    container = self.ui.listPanel,
    cliprect = CCRectMake(1, 1, w, h),
    noshade = true,
    zorder = 1
  }
  local draglist = ed.draglist.create(info)
  return draglist
end

function ShopsSaleEquip:initListView()
  self.itemUIs = {}
  self.timeT = {}
  for index, oneContent in pairs(self.listData) do
    self:createOneItemView(index, oneContent)
  end
  self.draglist:initListWidth(142 * #self.listData)
  for idx, oneItemUI in pairs(self.itemUIs) do
    self:btRegisterButtonClick({
      button = oneItemUI.itemPanel,
      press = oneItemUI.itemPanel_press,
      key = "item" .. idx,
      force = true,
      mcpMode = true,
      pressScale = 0.95,
      clickHandler = function()
        self:doClickOneItem(idx)
      end
    })
  end
end

function ShopsSaleEquip:doClickOneItem(idx)
  local time = self.timeT[idx] or 0
  if time <= 0 then
    ed.showToast(T("\229\149\134\229\186\151\231\137\169\229\147\129\229\183\178\229\136\183\230\150\176\239\188\140\232\175\183\233\135\141\230\150\176\230\137\147\229\188\128\232\139\177\233\155\132\231\149\140\233\157\162"))
    return
  end
  local shopId = self.listData[idx].shopId
  ed.pushScene(ed.ui.shop.create(shopId))
end

function ShopsSaleEquip:createOneItemView(index, oneContent)
  if not oneContent and not oneContent.itemId then
    return
  end
  local oneItemNode, oneItemUI = ed.editorui(ed.uieditor.ShopsSaleEquipItem)
  self.itemUIs[index] = oneItemUI
  self.timeT[index] = shopsMgr:getShopCountDown(oneContent.shopId) or 0
  self:updateOneGuildItemUI(oneItemUI, oneContent)
  oneItemNode:setPosition(ccp(-145 + 142 * index, 5))
  self.draglist:addItem(oneItemNode)
end

function ShopsSaleEquip:updateOneGuildItemUI(oneItemUI, oneContent)
  local shopId = oneContent.shopId
  local shopCfg = ed.ui.marketconfig.getShopCfg(shopId)
  if not shopCfg then
    return
  end
  if 1 == oneContent.shopId then
    ed.setTexture(oneItemUI.shopIconBg, "UI/alpha/HVGA/shop_icon_silver_background.png")
    ed.setLabelColor(oneItemUI.nameLabel, ccc3(255, 234, 198))
  end
  ed.setString(oneItemUI.nameLabel, shopCfg.shopName)
  local px, py = oneItemUI.shopIcon:getPosition()
  oneItemUI.shopIcon:setPosition(ccp(px + shopCfg.offx, py + shopCfg.offy))
  oneItemUI.shopIcon:setScale(shopCfg.scale or 1)
  ed.setTexture(oneItemUI.shopIcon, shopCfg.shopHeadRes)
  local equip = ed.readequip.createIcon(oneContent.itemId, 45)
  equip:setPosition(ccp(30, 23))
  oneItemUI.itemBg:addChild(equip)
  oneItemUI.equipIcon:setVisible(false)
  local timeStr = shopsMgr:getShopCountDownDes(shopId)
  ed.setString(oneItemUI.timeLabel, timeStr)
end

function ShopsSaleEquip:playTimeC()
  for idx = 1, #self.itemUIs do
    local oneItemUI = self.itemUIs[idx]
    self.timeT[idx] = self.timeT[idx] - 1
    local time = self.timeT[idx]
    local timeStr = "00:00:00"
    if time and 0 < time then
      timeStr = ed.gethmsNString(time)
    end
    if not tolua.isnull(oneItemUI.timeLabel) then
      ed.setString(oneItemUI.timeLabel, timeStr)
    end
  end
end

function ShopsSaleEquip:registerHandler()
  self:btRegisterHandler({
    handler = self.draglist:getListLayerTouchHandler()
  })
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.closeBtn,
    press = ui.closeBtn_press,
    key = "backmain",
    clickHandler = function()
      self:onDestory()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5,
    priority = -1
  })
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      self:onDestory()
    end,
    priority = -1
  })
end
