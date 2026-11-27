local base = ed.ui.popwindow
local chatSetInfoWin = newclass(base.mt)
chatSetInfoWin.__index = chatSetInfoWin
ed.ui.chatSetInfoWin = chatSetInfoWin
base.config.chatSetInfoWin = {touch_priority = -510}

function chatSetInfoWin:onDestory()
  if self.callback then
    self.callback()
  end
  self:destroy()
end

function chatSetInfoWin.create()
  local self = base.create("chatSetInfoWin", {noShade = true})
  setmetatable(self, chatSetInfoWin.mt)
  self:initUI()
  self:registerBtnHandler()
  self:popWindow()
  self:show()
  return self
end

function chatSetInfoWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.chatSetInfoWin)
  self.winUi = ui
  self.container:addChild(layer)
  print("ed.player.gender--->>", ed.player.gender)
  if ed.player.gender then
    self.selectValue = ed.player.gender
  else
    self.selectValue = "unknow"
  end
  self:resfresh()
end

function chatSetInfoWin:registerBtnHandler()
  self:btRegisterButtonClick({
    button = self.winUi.btn_close,
    press = self.winUi.btn_close_press,
    key = "close_button",
    clickHandler = function()
      self:onDestory()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.winUi.btn_male,
    press = self.winUi.btn_male_press,
    key = "btn_male",
    clickHandler = function()
      self:onClickSet("male")
    end,
    pressHandler = function()
      self:resfresh()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.winUi.btn_female,
    press = self.winUi.btn_female_press,
    key = "btn_female",
    pressHandler = function()
      self:resfresh()
    end,
    clickHandler = function()
      self:onClickSet("female")
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.winUi.btn_unknow,
    press = self.winUi.btn_unknow_press,
    key = "btn_unknow",
    pressHandler = function()
      self:resfresh()
    end,
    clickHandler = function()
      self:onClickSet("unknow")
    end,
    force = true
  })
end

function chatSetInfoWin:onClickSet(value)
  local isChange = true
  if self.selectValue == value then
    isChange = false
  end
  if isChange then
    self.selectValue = value
    
    function ed.chatNetDataMrg.callFun()
      ed.player.gender = self.selectValue
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"))
    end
    
    ed.chatNetDataMrg:sendSetSex(self.selectValue)
  end
  self:resfresh()
end

function chatSetInfoWin:resfresh()
  self.winUi.btn_female_press:setVisible(false)
  self.winUi.btn_unknow_press:setVisible(false)
  self.winUi.btn_male_press:setVisible(false)
  if self.selectValue == "male" then
    self.winUi.btn_male_press:setVisible(true)
  elseif self.selectValue == "female" then
    self.winUi.btn_female_press:setVisible(true)
  elseif self.selectValue == "unknow" then
    self.winUi.btn_unknow_press:setVisible(true)
  end
end
