local base = ed.ui.popwindow
local fastsell = newclass(base.mt)
ed.UITool.registViewOpenFunc("fastsell", function()
  local list = fastsell.getGarbageData()
  if list and 0 < #list then
    setmetatable(base.create("fastsellPop"), fastsell.mt):create(list):popWindow()
  end
end)

function fastsell:create(list)
  self:initUI()
  self:initDragList(list)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function fastsell:initUI()
  self.fastsellPop, self.ui = ed.editorui(ed.uieditor.fastsellPop)
  self.container:addChild(self.fastsellPop)
  self.fastsellPop:setPosition(ed.display.winSize.width / 2 - 300, ed.display.winSize.height / 2 - 225)
  self.container:setPosition(0, 0)
  self.ui.line_l:setScaleX(-0.7)
  self.ui.line_l:setScaleY(0.6)
  self.ui.line_r:setScaleX(0.7)
  self.ui.line_r:setScaleY(0.6)
end

function fastsell:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.ImageView_1106,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_yes,
    key = "btn_yes",
    clickHandler = function()
      local items = {}
      for i = 1, #self.garbageData do
        local em = self.garbageData[i]
        table.insert(items, {
          _id = em.id,
          _amount = em.amount
        })
      end
      ed.registerNetReply("sell_item", function()
        self:destroy({skipAnim = false})
      end, {
        items = items,
        income_list = self.income_list
      })
      local msg = ed.upmsg.sell_item()
      msg._items = items
      ed.send(msg, "sell_item")
    end,
    pressScale = 0.9,
    normalScale = 1
  })
  self:listenEvent("ResourceNumChange", function(resType, id)
    if resType == "item" then
      self:refreshDragList()
    end
  end)
end

function fastsell:initDragList(list)
  local thisCon = self.ui.txt_pos:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.txt_pos,
    noshade = true,
    zorder = 10,
    priority = -300,
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 30
    end
  }
  self.dragList = ed.draglist.create(info)
  self:refreshDragList(list)
end

function fastsell:refreshDragList(list)
  for i, v in ipairs(self.touchKey or {}) do
    self:btRemoveMainTouchHandler({key = v})
  end
  self.touchKey = {}
  self.garbageData = list or self.getGarbageData()
  local itemSize = 160
  local posx, posy, Height = 0, self.ui.txt_pos:getContentSize().height, 0
  self.dragList:clearList()
  for i, v in ipairs(self.garbageData) do
    local icon = ed.createItemIcon({
      id = v.id,
      amount = v.amount
    }, {
      size = 20,
      color = ccc3(255, 252, 232),
      pos = ccp(45, -14)
    }, 1)
    self.dragList:addItem(icon, ccp(posx + itemSize / 2 + 33, posy - itemSize / 2 + 30))
    if i % 3 == 0 then
      posx, posy = 0, posy - (itemSize - 60)
    else
      posx = posx + itemSize
    end
    if i % 3 == 1 then
      Height = Height + (itemSize - 60)
    end
    icon:setScale(0.8)
    self:btRegisterButtonClick({
      button = icon,
      key = "icon_" .. i,
      param = v,
      clickHandler = function(v, x, y)
        if not ed.containsPoint(self.ui.txt_pos, x, y) then
          return
        end
        if self.touch then
          ed.ui.packageDetailWin.create({
            id = v.id,
            amount = v.amount,
            type = "item"
          }):popWindow()
        end
      end,
      pressScale = 0.77,
      normalScale = 0.8
    })
    table.insert(self.touchKey, "icon_" .. i)
  end
  self.dragList:initListHeight(Height + 10)
  self.income_list = self:getIncome()
  self.ui.label_count:setString(self.income_list.Gold or 0)
end

function fastsell.getGarbageData()
  local list = {}
  local consume_type = "\229\158\131\229\156\190"
  local data = ed.getDataTable("equip")
  for k, v in pairs(data) do
    local id = k
    if ed.player.equip_qunty[id] and ed.player.equip_qunty[id] > 0 then
      local gt = v["Consume Type"]
      local name = v.Name
      local resType = v["Contain Type1"]
      local amount = ed.player.equip_qunty[id] or 0
      local price, sell_type = v["Sell Price"], v["Sell Price Type"]
      if gt == consume_type and 0 < amount and resType ~= "Sun" and resType ~= "Moon" and resType ~= "Star" then
        table.insert(list, {
          id = id,
          name = name,
          price = price,
          amount = amount,
          sell_type = sell_type
        })
      end
    end
  end
  return list
end

function fastsell:getIncome()
  local income_list = {}
  local list = self.garbageData
  for i = 1, #list do
    local e = list[i]
    local type = e.sell_type
    income_list[type] = (income_list[type] or 0) + e.price * e.amount
    if type ~= "Gold" then
      ed.showToast((type or "nil") .. " \230\156\170\233\128\130\233\133\141\230\152\190\231\164\186\239\188\129")
    end
  end
  return income_list
end
