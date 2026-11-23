local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipUnbindConfirm = class
ed.UITool.registViewOpenFunc("legendEquipUnbindConfirm", function(param)
  local window = ed.ui.legendEquipUnbindConfirm.create(param)
  window:show()
  window:popWindow()
end)

function class.create(param)
  local self = base.create("legendEquipUnbindConfirm")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.legendEquip = param.legendEquip
  self.confirmCallBack = param.confirmCallBack
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_unbind_confirm)
  self.container:addChild(container)
  self.ui = ui
  local heroId = self.legendEquip._carried_hero_id
  local typeId = self.legendEquip._type_id
  local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
  local equipName = legendEquipCfg["Equip Name"]
  local heroName = ed.getDataTable("Unit")[heroId]["Display Name"]
  ed.setLabelString(self.ui.label_tips_1, string.format(T("\230\152\175\229\144\166\232\167\163\233\153\164%s\228\184\142%s\231\154\132\231\187\145\229\174\154\239\188\159"), heroName, equipName))
  ed.setLabelString(self.ui.label_tips_2, string.format(T("\232\167\163\231\187\145\229\144\142\239\188\140%s\229\176\134\232\191\155\229\133\165%s\229\164\169\231\154\132\232\167\163\231\187\145\229\134\183\229\141\180\230\156\159\239\188\140\230\156\159\233\151\180\230\151\160\230\179\149\229\134\141\230\172\161\232\167\163\231\187\145"), equipName, ed.legendEquipDefine.Unbind_CD))
  ed.setLabelDimensions(self.ui.label_tips_2, CCSizeMake(280, 0))
  self.ui.label_tips_2:setHorizontalAlignment(kCCTextAlignmentCenter)
end

function class:onClickBtnConfirm()
  if self.confirmCallBack then
    self.confirmCallBack()
  end
  self:destroy()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
end
