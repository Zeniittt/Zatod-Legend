local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipBindConfirmWindow = class
ed.UITool.registViewOpenFunc("legendEquipBindConfirmWindow", function(param)
  local window = ed.ui.legendEquipBindConfirmWindow.create(param)
  window:popWindow()
end)

function class.create(param)
  local self = base.create("legendEquipBindConfirmWindow", {noShade = true})
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.confirmCallBack = param.confirmCallBack
  self.legendEquip = param.legendEquip
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_bind_confirm_window)
  self.container:addChild(container)
  self.ui = ui
  local legendEquipCfg = ed.getDataTable("LegendEquip")[self.legendEquip._type_id]
  local nextUnequipTime = self.legendEquip._next_unequip_time
  local serverTime = ed.getServerTime()
  local leftTime = nextUnequipTime - serverTime
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local text
  if 0 < day then
    text = string.format("%s\229\164\169%s\230\151\182", day, hour)
  else
    text = string.format("%s\230\151\182%s\229\136\134", hour, min)
  end
  local panelSize = self.ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format("%s\229\156\168<lable color=ccc3(255,92,92)>%s</lable>\229\134\133\230\151\160\230\179\149\232\167\163\231\187\145\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\231\187\145\229\174\154\239\188\159", legendEquipCfg["Equip Name"], text),
    fontSize = 18,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(1510926),
    strokeSize = 1,
    maxWidth = panelSize.width
  })
  self.ui.panel_desc:addChild(autoText.node)
  autoText.node:setPosition(ccp(0, panelSize.height - 9))
end

function class:onClickBtnConfirm()
  if self.confirmCallBack then
    self.confirmCallBack()
  end
  self:destroy({skipAnim = true})
end

function class:onClickBtnCancel()
  self:destroy()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:onClickBtnCancel()
  end, {pressScale = 0.95})
end
