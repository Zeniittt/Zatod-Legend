local base = ed.ui.popwindow
local PetLevelUpTip = newclass(base.mt)
ed.ui.PetLevelUpTip = PetLevelUpTip

function PetLevelUpTip.create(param)
  local self = base.create("PetLevelUpTip")
  setmetatable(self, PetLevelUpTip.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function PetLevelUpTip:initData(param)
  self.pet = ed.player:getPet(param._id)
end

function PetLevelUpTip:initLabels()
  ed.setLabelStroke(self.ui.label_pre_level, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_pre_str, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_pre_int, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_pre_agi, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.Label_7184_Copy3, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_level, ed.toccc3(1519903), 1)
  ed.setLabelStroke(self.ui.label_str, ed.toccc3(1519903), 1)
  ed.setLabelStroke(self.ui.label_int, ed.toccc3(1519903), 1)
  ed.setLabelStroke(self.ui.label_agi, ed.toccc3(1519903), 1)
  ed.setLabelStroke(self.ui.label_ex_attr, ed.toccc3(1519903), 1)
  ed.setLabelStroke(self.ui.label_pre_str_Copy0, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_pre_int_Copy0, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_pre_agi_Copy0, ed.toccc3(2693915), 1)
end

function PetLevelUpTip:initUI()
  local typeId = self.pet:getTypeId()
  ed.editorui(ed.uieditor.PetLevelUpTip, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\231\173\137\231\186\167\230\143\144\229\141\135"),
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16774881),
    endColor = ed.toccc3(16775585),
    strokeSize = 2,
    strokeStartColor = ed.toccc3(12017696),
    strokeEndColor = ed.toccc3(12017696)
  })
  ed.UITool.replaceUINew(self.ui, "title", titleLabel.node)
  titleLabel.node:setOpacity(0)
  self:listenTimer(Timer:Once(0.4), function()
    titleLabel.node:runAction(CCFadeIn:create(0.5))
  end)
  local level = self.pet:getLevel()
  local preLevel = level - 1
  ed.setString(self.ui.label_pre_level, string.format(T("\231\173\137\231\186\167 %d"), preLevel))
  ed.setString(self.ui.label_level, level)
  ed.setString(self.ui.label_pre_str, string.format(T("%.1f%%"), self.pet:getPetAttrRadio("STR", preLevel)))
  ed.setString(self.ui.label_pre_int, string.format(T("%.1f%%"), self.pet:getPetAttrRadio("INT", preLevel)))
  ed.setString(self.ui.label_pre_agi, string.format(T("%.1f%%"), self.pet:getPetAttrRadio("AGI", preLevel)))
  ed.setString(self.ui.label_str, string.format(T("%.1f%%"), self.pet:getPetAttrRadio("STR", level)))
  ed.setString(self.ui.label_int, string.format(T("%.1f%%"), self.pet:getPetAttrRadio("INT", level)))
  ed.setString(self.ui.label_agi, string.format(T("%.1f%%"), self.pet:getPetAttrRadio("AGI", level)))
  local dt = ed.getDataTable("Pet")[self.pet:getTypeId()]
  local showExAttr = false
  local resConfig = ed.heroDetailManager.resConfig
  if dt then
    for i = 1, 3 do
      if level == dt["Extra Attr " .. i .. " Unlock Level"] then
        showExAttr = true
        local exAttrType = dt["Extra Attr " .. i .. " Type"]
        local exAttrStr = string.format("%s+%d%s", resConfig.att_cn_name[exAttrType], dt["Extra Attr " .. i .. " Value"], resConfig.att_suffix[exAttrType] or "")
        ed.setString(self.ui.label_ex_attr, exAttrStr)
      end
    end
  end
  self.ui.ImageView_7176:setVisible(showExAttr)
  if not showExAttr then
    self.ui.bg:setContentSize(CCSizeMake(776, 195))
  end
  local fca = ed.createFcaNode("eff_UI_pet_levelup")
  self:addFca(fca)
  ed.UITool.replaceUINew(self.ui, "ImageView_7174", fca)
end

function PetLevelUpTip:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end
