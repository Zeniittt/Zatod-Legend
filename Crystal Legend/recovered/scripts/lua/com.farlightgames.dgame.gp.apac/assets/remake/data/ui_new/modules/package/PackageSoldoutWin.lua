local base = ed.ui.popwindow
local PackagSoldoutWin = newclass(base.mt)
ed.ui.PackagSoldoutWin = PackagSoldoutWin

function PackagSoldoutWin.create(param)
  local self = base.create("PackagSoldoutWin")
  setmetatable(self, PackagSoldoutWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  return self
end

function PackagSoldoutWin:initData(param)
  self.soldNum = 1
  self.id = param.id
  self.destroyCallback = param.callback
  self.totalNum = ed.player:getEquipAmount(self.id)
  self.sellPriceType = ed.getDataTable("equip")[self.id]["Sell Price Type"]
  self.price = ed.getDataTable("equip")[self.id]["Sell Price"]
end

function PackagSoldoutWin:initLabels()
  ed.setLabelStroke(self.ui.label_name, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.Label_1014, ccc3(221, 191, 158), 1)
  ed.setLabelStroke(self.ui.Label_1016, ccc3(221, 191, 158), 1)
  ed.setLabelStroke(self.ui.Label_1015, ccc3(221, 191, 158), 1)
  ed.setLabelStroke(self.ui.Label_1017, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.Label_1011, ccc3(255, 252, 231), 2)
  ed.setLabelStroke(self.ui.label_number, ccc3(0, 0, 0), 1)
end

function PackagSoldoutWin:initUI()
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
  if self.sellPriceType == "Gold" then
    ed.setTexture(self.ui.icon_money1, "UI/alpha/1080P/main/goldicon_small.png")
    ed.setTexture(self.ui.icon_money2, "UI/alpha/1080P/main/goldicon_small.png")
  else
    ed.setTexture(self.ui.icon_money1, "UI/alpha/1080P/main/rmbicon.png")
    ed.setTexture(self.ui.icon_money2, "UI/alpha/1080P/main/rmbicon.png")
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

function PackagSoldoutWin:refreshUI()
  self.ui.label_number:setString(self.soldNum)
  self.ui.label_preview_money:setString(self.price * self.soldNum)
end

function PackagSoldoutWin:keepeatHandler(up)
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

function PackagSoldoutWin:onClickSub()
  if self.soldNum == 1 then
    return
  end
  self.soldNum = self.soldNum - 1
  self:refreshUI()
end

function PackagSoldoutWin:onClickAdd()
  if self.soldNum == self.totalNum then
    return
  end
  self.soldNum = self.soldNum + 1
  self:refreshUI()
end

function PackagSoldoutWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_soldout", function()
    ed.registerNetReply("sell_item", function(result, amount)
      if result then
        ed.showToast(T("\229\135\186\229\148\174\230\136\144\229\138\159"))
        self:destroy()
      end
    end, {
      items = {
        {
          _id = self.id,
          _amount = self.soldNum
        }
      },
      income_list = {
        [self.sellPriceType] = self.price * self.soldNum
      }
    })
    local msg = ed.upmsg.sell_item()
    msg._items = {
      ed.packItem(self.id, self.soldNum)
    }
    ed.send(msg, "sell_item")
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
