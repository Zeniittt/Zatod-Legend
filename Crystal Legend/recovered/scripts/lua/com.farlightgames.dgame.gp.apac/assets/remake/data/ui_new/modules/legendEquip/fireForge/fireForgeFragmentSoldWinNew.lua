local base = ed.ui.popwindow
local FragmentSoldoutWin = newclass(base.mt)
ed.ui.FragmentSoldoutWin = FragmentSoldoutWin

function FragmentSoldoutWin.create(param)
  local self = base.create("FragmentSoldoutWin")
  setmetatable(self, FragmentSoldoutWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  return self
end

function FragmentSoldoutWin:initData(param)
  self.soldNum = 1
  self.id = param.id
  self.equipId = param.equipId
  self.destroyCallback = param.callback
  self.totalNum = ed.player:getEquipAmount(self.id)
  self.equipInfo = ed.getDataTable("LegendEquip")[self.equipId]
  self.sellPriceType = self.equipInfo["Sell Type"]
  self.price = self.equipInfo["Sell Amount"]
end

function FragmentSoldoutWin:initLabels()
  ed.setLabelStroke(self.ui.label_name, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_1014, ccc3(221, 191, 158), 1)
  ed.setLabelStroke(self.ui.Label_1016, ccc3(221, 191, 158), 1)
  ed.setLabelStroke(self.ui.Label_1015, ccc3(221, 191, 158), 1)
  ed.setLabelStroke(self.ui.Label_1017, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.Label_1011, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.label_number, ccc3(0, 0, 0), 1)
  local oriWid = self.ui.Label_1017:getContentSize().width
  ed.setLabelString(self.ui.Label_1017, T("\232\142\183\229\190\151\231\165\158\231\129\171\228\189\153\231\131\172\239\188\154"))
  ed.UITool.setPositionBy(self.ui.Label_1017, ccp((self.ui.Label_1017:getContentSize().width - oriWid) * 0.5, 0))
end

function FragmentSoldoutWin:initUI()
  ed.editorui(ed.uieditor.packageSoldWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.ui.label_name:setString(ed.readequip.value(self.id, "Name"))
  self.ui.label_chiyou:setString(self.totalNum)
  self.ui.label_amount:setString("/" .. self.totalNum)
  self.ui.label_sold_money:setString(self.price)
  ed.UITool.replaceUI(self.ui, "top_layer", "icon_item", ed.readequip.createIcon(self.id))
  if self.sellPriceType == "Item" then
    local itemId = self.equipInfo["Sell ID"]
    local res = "UI/alpha/1080P/fireforge/art3.png"
    ed.setTexture(self.ui.icon_money1, res)
    ed.setTexture(self.ui.icon_money2, res)
    ed.right2(self.ui.icon_money1, self.ui.label_sold_money, 1)
    ed.right2(self.ui.icon_money2, self.ui.label_preview_money, 1)
  else
    ed.setTexture(self.ui.icon_money1, "UI/alpha/1080P/main/goldicon_small.png")
    ed.setTexture(self.ui.icon_money2, "UI/alpha/1080P/main/goldicon_small.png")
  end
  local posX = self.ui.label_amount_str:getPositionX()
  if self.totalNum < 10 then
    self.ui.label_amount_str:setPositionX(11.5)
    ed.right2(self.ui.label_chiyou, self.ui.label_amount_str, 1)
  elseif self.totalNum < 100 then
    self.ui.label_amount_str:setPositionX(8.5)
    ed.right2(self.ui.label_chiyou, self.ui.label_amount_str, 1)
  elseif self.totalNum < 1000 then
    self.ui.label_amount_str:setPositionX(5.5)
    ed.right2(self.ui.label_chiyou, self.ui.label_amount_str, 1)
  end
  self:refreshUI()
end

function FragmentSoldoutWin:refreshUI()
  self.ui.label_number:setString(self.soldNum)
  self.ui.label_preview_money:setString(self.price * self.soldNum)
end

function FragmentSoldoutWin:keepeatHandler(up)
  local count = 0
  local delay = 0.5
  local accAcc = 2
  local speed = 10
  local accSpeed = 2
  local times = 0
  
  local function longPressHandler(dt)
    count = count + dt
    if count > delay then
      accSpeed = accSpeed + accAcc * dt
      speed = speed + accSpeed * dt
      times = times + speed * dt
      while 1 < times do
        if up then
          self:onClickAdd()
        else
          self:onClickSub()
        end
        times = times - 1
      end
    end
  end
  
  return longPressHandler
end

function FragmentSoldoutWin:onClickSub()
  if self.soldNum == 1 then
    return
  end
  self.soldNum = self.soldNum - 1
  self:refreshUI()
end

function FragmentSoldoutWin:onClickAdd()
  if self.soldNum == self.totalNum then
    return
  end
  self.soldNum = self.soldNum + 1
  self:refreshUI()
end

function FragmentSoldoutWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_soldout", function()
    local mgr = ed.legendEquipMgr.getInstance()
    mgr.sellFragmentId = self.id
    mgr.sellFragmentAmount = self.soldNum
    ed.legendEquipNet.sendSellFragment({
      {
        _id = self.id,
        _amount = self.soldNum
      }
    })
    self:destroy()
  end, {clickInterval = 0.5, pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_sub", function()
    self:onClickSub()
  end, {
    clickInterval = 0.1,
    pressScale = 0.9,
    pressHandler = function()
      self:registerUpdateHandler("long_click_button_down", self:keepeatHandler())
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("long_click_button_down")
    end
  })
  ed.UITool.registerBtn(self, "btn_add", function()
    if self.soldNum == self.totalNum then
      return
    end
    self.soldNum = self.soldNum + 1
    self:refreshUI()
  end, {
    clickInterval = 0.1,
    pressScale = 0.9,
    pressHandler = function()
      self:registerUpdateHandler("long_click_button_up", self:keepeatHandler(true))
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("long_click_button_up")
    end
  })
  ed.UITool.registerBtn(self, "btn_max", function()
    self.soldNum = self.totalNum
    self:refreshUI()
  end, {clickInterval = 0.1, pressScale = 0.9})
  self:btRegisterOutClick({
    area = self.ui.bg_detail,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
end
