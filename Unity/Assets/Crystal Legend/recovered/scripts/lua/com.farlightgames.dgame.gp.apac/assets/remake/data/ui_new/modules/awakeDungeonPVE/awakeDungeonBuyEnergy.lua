local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.awakeDungeonBuyEnergy = class
ed.UITool.registViewOpenFunc("awakeDungeonBuyEnergy", function(param)
  class.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("BuyPeakArenaTicketBox")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.uiList = {}
  self:initBuyTimesInfo()
  self:initView()
  self:addEventListener()
  self:registerTouchHandlers()
end

function class:initBuyTimesInfo()
  local buyTimesInfo = {}
  local vitalityBuyTimes = ed.getDataTable("DungeonConfig").VitalityBuyTimes.Value
  local vitalityBuyPrice = ed.getDataTable("DungeonConfig").VitalityBuyPrice.Value
  local totalBuyTimes = 0
  for index, times in ipairs(vitalityBuyTimes) do
    totalBuyTimes = totalBuyTimes + times
  end
  for times = 1, totalBuyTimes do
    local price = 0
    local totalBuyTimes = 0
    for index = 1, #vitalityBuyTimes do
      local canBuyTimes = vitalityBuyTimes[index]
      totalBuyTimes = totalBuyTimes + canBuyTimes
      if times <= totalBuyTimes then
        price = vitalityBuyPrice[index]
        break
      end
    end
    buyTimesInfo[times] = {
      price = price,
      totalPrice = (buyTimesInfo[times - 1] and buyTimesInfo[times - 1].totalPrice or 0) + price
    }
  end
  self.buyTimesInfo = buyTimesInfo
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.buyVitalityWin)
  self.container:addChild(container)
  self.ui = ui
  ed.setString(self.ui.label_title, T("\232\180\173\228\185\176\232\131\189\233\135\143"))
  ed.setLabelStroke(self.ui.label_title, ccc3(39, 37, 36), 1)
  self:initDragList()
  self:refreshView()
  self:show()
end

function class:refreshView()
  self:refreshDraglist()
end

function class:initDragList()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler()
  })
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
end

function class:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if ed.containsPoint(item.bg, x, y) then
        if item.btn_buy and ed.containsPoint(item.btn_buy, x, y) then
          item.btn_buy:setScale(0.9)
        end
        if item.btn_use and ed.containsPoint(item.btn_use, x, y) then
          item.btn_use:setScale(0.9)
        end
        return item
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, item)
    if item.btn_buy and ed.containsPoint(item.btn_buy, x, y) then
      local buyTimes = self.dungeonMgr:getVitalityBuyTimes()
      
      local totalBuyTimes = #self.buyTimesInfo
      local price = self.buyTimesInfo[buyTimes + 1] and self.buyTimesInfo[buyTimes + 1].price or self.buyTimesInfo[#self.buyTimesInfo].price
      if buyTimes >= totalBuyTimes then
        ed.showToast(T("\228\187\138\230\151\165\232\180\173\228\185\176\230\172\161\230\149\176\229\183\178\231\148\168\229\174\140!"))
        return
      end
      ed.showConfirmDialog({
        text = string.format(T("\232\138\177\232\180\185%d\233\146\187\231\159\179\232\180\173\228\185\17660\231\130\185\232\131\189\233\135\143\239\188\140\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159(\228\187\138\230\151\165\229\183\178\232\180\173\228\185\176%d\230\172\161)"), price, buyTimes),
        rightHandler = function()
          local diamondAmount = ed.player:getDiamondAmount()
          if diamondAmount >= price then
            ed.AwakeDungeonNetwork.sendBuyVitality(1)
            ed.player:subrmb(price)
          else
            ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179"))
          end
        end
      })
    end
  end
  
  return handler
end

function class:getCancelPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if item.btn_buy then
        item.btn_buy:setScale(1)
      end
      if item.btn_use then
        item.btn_use:setScale(1)
      end
    end
  end
  
  return handler
end

function class:refreshDraglist()
  local dy, py = 84, 2
  local ox = self.ui.layer_item:getContentSize().width / 2
  local oy = self.ui.layer_item:getContentSize().height + dy / 2 + py
  
  local function getPos(i)
    return ccp(ox, oy - (dy + py) * i)
  end
  
  self.draglist:clearList()
  self.uiList = {}
  local container, ui = self:createBuyEnergyItem()
  container:setPosition(getPos(1))
  self.draglist:addItem(container)
  table.insert(self.uiList, ui)
  self.draglist:initListHeight(dy + py)
end

function class:createBuyEnergyItem()
  local container, ui = ed.editorui(ed.uieditor.buyVitalityItem1)
  local tokenType = "DungeonEnergy"
  local tokenCfg = ed.getDataTable("Token")[tokenType]
  local iconPath = tokenCfg.Icon
  local desc = tokenCfg["Describe 1"]
  local name = tokenCfg["Token Name"]
  local buyTimes = self.dungeonMgr:getVitalityBuyTimes()
  local totalBuyTimes = #self.buyTimesInfo
  local price = self.buyTimesInfo[buyTimes + 1] and self.buyTimesInfo[buyTimes + 1].price or self.buyTimesInfo[#self.buyTimesInfo].price
  ed.setTexture(ui.ImageView_13691, "UI/alpha/1080P/icon/dungeon_energy_icon.jpg")
  ed.setLabelStroke(ui.title, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.num, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(ui.desc, ccc3(57, 36, 21), 1)
  ed.setLabelShadow(ui.label_buy, ccc3(0, 0, 0), ccp(1, 1))
  ed.setString(ui.desc, desc)
  ed.setString(ui.num, price)
  ed.setString(ui.label_times, string.format(T("\228\187\138\230\151\165\233\153\144\232\180\173 %d/%d\230\172\161"), buyTimes, totalBuyTimes))
  ed.setString(ui.title, name)
  ed.adaptLabel(ui.desc, {maxWidth = 300, minScale = 0.7})
  return container, ui
end

function class:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:close()
  end, {pressScale = 0.75, normalScale = 0.8})
end

function class:addEventListener()
  self:listenEvent("dungeonVitalityChanged", function()
    self:refreshView()
  end)
end

function class:close()
  self:destroy({skipAnim = true})
end
