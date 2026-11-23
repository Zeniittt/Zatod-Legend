local base = ed.ui.popwindow
local class = {}
class.__index = class
setmetatable(class, base.mt)
ed.ui.dragonBoatUseZongziPop = class

function class.create(params)
  local self = base.create("dragonBoatUseZongziPop", {notBlurBg = true, noShade = true})
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initUI()
  self:registerEvents()
  self:registerBtns()
end

function class:initData(params)
  self.controller = params.controller
  self.closeCallBack = params.closeCallBack
  self.curZongziCnt = 1
  self.maxZongziCnt = ed.player:getEquipAmount(ed.dragonBoatMgr.getInstance().zongziItemId)
  self.minZongziCnt = 1
  self.mgr = ed.dragonBoatMgr.getInstance()
  self.itemId = self.mgr.zongziItemId
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.DragonBoatUseZongziPop)
  self.container:addChild(container)
  self.ui = ui
  self:initLabel()
  self:initEditBox()
end

function class:initEditBox()
  local info = {
    config = {
      editSize = self.ui.panel_editbox:getContentSize(),
      maxLength = 20,
      fontColor = ccc3(255, 252, 231),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setPlaceHolder("")
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  self.ui.panel_editbox:addChild(edit_box.edit)
  self.ui.panel_editbox:setClipRect(CCRectMake(0, 0, info.config.editSize.width, info.config.editSize.height))
  edit_box.edit:setVisible(false)
  self.edit_box = edit_box
  self:listenTimer(Timer:Always(0.1), function()
    local str = self.edit_box:getString()
    local amount = tonumber(str)
    if amount and amount ~= self.curZongziCnt then
      self:setUseAmount(amount)
    end
  end)
end

function class:initLabel()
  ed.layout.horizontalSortNode({
    self.ui.title_left,
    self.ui.title,
    self.ui.title_right
  }, {
    10,
    10,
    0
  }, self.ui.bg:getContentSize().width * 0.5)
  ed.setLabelStroke(self.ui.title, ed.toccc3(70403), 1.5)
  ed.setLabelStroke(self.ui.label_num, ed.toccc3(70403), 1.5)
  ed.setLabelStroke(self.ui.label_need, ed.toccc3(70403), 1.5)
  ed.setLabelStroke(self.ui.label_need_num, ed.toccc3(70403), 1.5)
  ed.setLabelStroke(self.ui.label_eat, ed.toccc3(11748623), 1.5)
  ed.setLabelString(self.ui.label_num, self.curZongziCnt)
  ed.setLabelString(self.ui.label_need_num, "x" .. self.curZongziCnt)
end

function class:onClickBtnMax()
  local itemAmount = ed.player:getEquipAmount(self.itemId)
  if itemAmount == 0 then
    ed.showToast(T("%s\230\149\176\233\135\143\228\184\141\232\182\179", ed.getEquipNameWithId(self.itemId)))
    return
  end
  self:setUseAmount(self.maxZongziCnt)
end

function class:onClickBtnMinus(amount)
  local itemAmount = ed.player:getEquipAmount(self.itemId)
  if itemAmount == 0 then
    return
  end
  self:setUseAmount(amount or self.curZongziCnt - 1)
end

function class:onClickBtnAdd(amount)
  local itemAmount = ed.player:getEquipAmount(self.itemId)
  if itemAmount == 0 then
    ed.showToast(T("%s\230\149\176\233\135\143\228\184\141\232\182\179", ed.getEquipNameWithId(self.itemId)))
    return
  end
  self:setUseAmount(amount or self.curZongziCnt + 1)
end

function class:registerEvents()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "adapt_num_max", function()
    self:onClickBtnMax()
  end, {pressScale = 0.9, normalScale = 1})
  self:btRegisterButtonClick({
    button = self.ui.adapt_num_minus,
    key = "adapt_num_minus",
    clickHandler = function()
      self:onClickBtnMinus()
    end,
    pressHandler = function()
      local count = 0
      local acceleration = 10
      local speed = 5
      local maxSpeed = 100
      local threshold = 0.5
      self:registerUpdateHandler("adapt_num_minus", function(dt)
        count = count + dt
        if count > threshold then
          speed = speed + acceleration * (count - threshold)
          speed = math.max(speed, maxSpeed)
          self:onClickBtnMinus(self.curZongziCnt - speed * dt)
        end
      end)
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("adapt_num_minus")
    end,
    force = true,
    pressScale = 0.9
  })
  self:btRegisterButtonClick({
    button = self.ui.adapt_num_plus,
    key = "adapt_num_plus",
    clickHandler = function()
      self:onClickBtnAdd()
    end,
    pressHandler = function()
      local count = 0
      local acceleration = 10
      local speed = 5
      local maxSpeed = 100
      local threshold = 0.5
      self:registerUpdateHandler("adapt_num_plus", function(dt)
        count = count + dt
        if count > threshold then
          speed = speed + acceleration * (count - threshold)
          speed = math.max(speed, maxSpeed)
          self:onClickBtnAdd(self.curZongziCnt + speed * dt)
        end
      end)
    end,
    cancelPressHandler = function()
      self:removeUpdateHandler("adapt_num_plus")
    end,
    force = true,
    pressScale = 0.9
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
  self:listenEvent("dragonBoatUseZongziSuccess", function()
    ed.player:consumeEquip(self.mgr.zongziItemId, self.curZongziCnt)
    self.controller.boatMgr.selfAccelerate = self.curZongziCnt
    self.controller:refreshRewardLabel()
    self.controller:refreshZongziNum()
    self:destroy({
      callback = function()
        if self.closeCallBack then
          self.closeCallBack()
        end
      end
    })
    self.mgr:showNoticeQueue("zongziSuccess", self.curZongziCnt)
  end)
end

function class:registerBtns()
  ed.UITool.registerBtn(self, "btn_eat", function()
    if self.curZongziCnt > self.maxZongziCnt then
      ed.showToast(T("\231\145\158\231\178\189\230\149\176\233\135\143\228\184\141\232\182\179"))
      return
    end
    local frontId = self.mgr.frontInfo and self.mgr.frontInfo._user_summary._role_id or nil
    local behindId = self.mgr.behindInfo and self.mgr.behindInfo._user_summary._role_id or nil
    ed.dragonBoatNet.getInstance():sendUse(self.curZongziCnt, frontId, behindId)
    self.recordNum = self.curZongziCnt
  end, {pressScale = 0.9, normalScale = 1})
end

function class:setUseAmount(amount)
  amount = math.floor(math.min(self.maxZongziCnt, math.max(self.minZongziCnt, amount)))
  self.curZongziCnt = amount
  ed.setLabelString(self.ui.label_num, self.curZongziCnt)
  ed.setLabelString(self.ui.label_need_num, "x" .. self.curZongziCnt)
  self.edit_box:setString(amount)
end
