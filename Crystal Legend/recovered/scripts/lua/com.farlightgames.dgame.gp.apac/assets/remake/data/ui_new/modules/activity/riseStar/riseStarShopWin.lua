local base = ed.ui.popwindow
local riseStarShopWin = newclass(base.mt)
ed.ui.riseStarShopWin = riseStarShopWin
ed.UITool.registViewOpenFunc("OpenRiseStarShopWin", function(data)
  ed.ui.riseStarShopWin.create(data)
end)

function riseStarShopWin.create(data)
  local self = base.create("riseStarShopWin")
  setmetatable(self, riseStarShopWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function riseStarShopWin:initData(data)
  self:updateGoodsData()
end

function riseStarShopWin:updateGoodsData()
  self.shopData = ed.copyProto(ed.riseStarMgr:getShopData())
  for i, v in pairs(self.shopData) do
    if v then
      local str = ed.getDataTable("SimpleAssistGoods")[v._group][v._group_index]["Extra Str"]
      v.cheap = str and 0 < #str
    end
  end
end

function riseStarShopWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.riseStarShopWin)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelColor(self.ui.label_num, ed.toccc3(15920383))
  self:updateGoodPoint()
  self:createShopList()
end

function riseStarShopWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function riseStarShopWin:registerEvents()
  self:listenEvent("EventUpdateGoodsByStore", function()
    self:updateGoodPoint()
    self:updateGoodsData()
    self.recordTableview:reloadData()
  end)
end

function riseStarShopWin:updateGoodPoint()
  local itemPoint = ed.riseStarMgr:getItemPoint()
  ed.setString(self.ui.label_num, itemPoint)
end

function riseStarShopWin:createShopList()
  local size = self.ui.panel_record:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.shopData
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(145, 175)
    end,
    createCell = function(index)
      local itemContainer, ui = self:createShopItem(index, self.shopData[index])
      return itemContainer, {
        rewardData = self.shopData[index],
        ui = ui
      }
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.mask, x, y) then
        return
      end
      if ed.containsPoint(ui.bg, x, y) then
        ui.bg:setScale(0.95)
        return cell
      end
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ui.mask:isVisible() then
        return ed.showToast(T("\229\183\178\229\148\174\231\189\132"))
      end
      if not ed.containsPoint(ui.bg, x, y) then
        return
      end
      local itemData = data.rewardData._rewards[1]
      local buyResourceBox = ed.ui.buyResourceBox.create({
        buyLimitNum = data.rewardData._max_buy_times - data.rewardData._buy_times,
        defaultBuyNum = 1,
        goodsResType = "rise_star",
        goodsId = itemData._id,
        costResType = "riseStarPoint",
        showNumber = data.rewardData._rewards[1]._amount,
        price = data.rewardData._price_value,
        buyAction = function(num)
          ed.riseStarNet:sendBuyGoods(data.rewardData._group, data.rewardData._group_index, num, data.rewardData._price_value)
        end,
        callback = function(num)
        end,
        item = data
      })
      buyResourceBox:setSurplusAmount(data.rewardData._max_buy_times - data.rewardData._buy_times)
      buyResourceBox:popWindow()
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      ui.bg:setScale(1)
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_record,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 4,
    dragMode = 1,
    offset = {70, 90},
    touchpriority = -300,
    noshade = true
  }
  self.recordTableview = Tableview.create(param)
  self.recordTableview:reloadData()
end

function riseStarShopWin:createShopItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.riseStar_Shop_Item)
  container:setContentSize(ui.bg:getContentSize())
  local itemData = data._rewards[1]
  local icon = ed.createItemIcon({
    id = itemData._id,
    type = itemData._type,
    amount = itemData._amount
  })
  icon:setPosition(68.75, 103)
  icon:setScale(0.95)
  ui.bg:addChild(icon)
  local red = ed.createSpriteTools({
    res = "UI/alpha/1080P/pirateshop/redpoint.png",
    pos = ccp(120, 162),
    parent = ui.bg,
    notShow = true
  })
  local name = ed.readequip.value(itemData._id, "Name")
  local nameTxt = ed.createLabelTools({
    txt = name,
    size = 15,
    pos = ccp(68.75, 55),
    color = ed.toccc3(16772265),
    parent = ui.bg,
    stroke = {
      ed.toccc3(4994341),
      2
    }
  })
  nameTxt:limitWidthBySize(140)
  local mask = ed.createSpriteTools({
    res = "UI/alpha/1080P/risestar/shop_itemBg1.png",
    parent = ui.bg,
    pos = ccp(68.5, 83),
    notShow = data._max_buy_times ~= data._buy_times
  })
  local soldout_img = ed.createSpriteTools({
    res = "UI/alpha/1080P/newshop/over_tf.png",
    parent = mask,
    pos = ccp(68.75, 93.5)
  })
  local soldout_label = ed.createLabelTools({
    txt = T("\229\148\174\231\189\132"),
    size = 20,
    font = ed.fontBold,
    color = ccc3(255, 94, 94),
    stroke = {
      ed.toccc3(2826261),
      1.5
    },
    parent = soldout_img
  })
  soldout_label:limitWidthByScale(56)
  ed.layout.centerInParent(soldout_label)
  ui.mask = mask
  ui.red = red
  ed.setLabelString(ui.label_num, data._price_value)
  ed.setLabelString(ui.label_num_over, string.format(T("\229\137\169\228\189\153\230\172\161\230\149\176\239\188\154%s"), data._max_buy_times - data._buy_times))
  ed.setLabelColor(ui.label_num, ed.toccc3(16775407))
  ed.setLabelStroke(ui.label_num, ed.toccc3(460551), 1)
  ed.setLabelColor(ui.label_num_over, ed.toccc3(2234948))
  ui.image_cheap:setVisible(data.cheap)
  ed.setLabelString(ui.label_cheap, T("\231\137\185\230\131\160"))
  ed.setLabelColor(ui.label_cheap, ed.toccc3(14901535))
  ed.setLabelStroke(ui.label_cheap, ed.toccc3(16777215), 1.5)
  return container, ui
end

function riseStarShopWin:refreshShopItem()
  self.recordTableview:reloadData()
end
