local base = ed.ui.popwindow
local legendEquipTip = newclass(base.mt)
ed.ui.legendEquipTip = legendEquipTip
ed.UITool.registViewOpenFunc("legendEquipTip", function(param)
  local window = ed.ui.legendEquipTip.create(param)
  window:popWindow()
end)

function legendEquipTip.create(param)
  local self = base.create("legendEquipTip", {notBlurBg = true})
  setmetatable(self, legendEquipTip.mt)
  param = param or {}
  self.typeId = param.typeId
  self.legendEquip = param.legendEquip
  if self.typeId and not self.legendEquip then
    local legendEquipCfg = ed.getDataTable("LegendEquip")[self.typeId]
    self.legendEquip = {
      _type_id = self.typeId,
      _star = legendEquipCfg["Basic Star"],
      _rank = legendEquipCfg["Basic Rank"]
    }
  end
  self:initView()
  self:registerTouchHandler()
  self.refreshCliprectConfig = {
    draglist = self.attrDragList
  }
  self:show()
  return self
end

function legendEquipTip:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_others_hero_window)
  self.ui = ui
  self.container:addChild(container)
  self:initLabels()
  self:initDragList()
  self:refreshEquipInfo()
end

function legendEquipTip:initLabels()
  local equipName = ed.ui.gradientLabel.create({
    fontSize = 19,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16776069),
    strokeSize = 1,
    strokeColor = ed.toccc3(2565412)
  })
  self.equipName = equipName
  self.ui.panel_equip_name:addChild(equipName.node)
  local onlyTag = ed.ui.gradientLabel.create({
    text = "\229\148\175\228\184\128\232\163\133\229\164\135",
    fontSize = 13,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16776069)
  })
  self.ui.image_only_tag:addChild(onlyTag.node)
  ed.layout.centerInParent(onlyTag.node)
  ed.setLabelStroke(self.ui.label_title, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_filter, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.label_skill_name, ed.toccc3(2565412), 1)
  ed.setLabelShadow(self.ui.label_bind, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_rune_name_1, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_rune_name_2, ed.toccc3(2565412), 1)
end

function legendEquipTip:initDragList()
  self.attrDragList = ed.UITool.createDraglist(self.ui.panel_attr_list)
  self.skillDescDragList = ed.UITool.createDraglist(self.ui.panel_skill_desc)
end

function legendEquipTip:refreshEquipInfo()
  if self.legendEquip then
    self.skillUnlockInfo = ed.legendEquipTool.getLegendEquipUnlockInfo(self.legendEquip)
  end
  self:refreshEquipDetail()
  self:refreshAttr()
  self:refreshSkillDetail()
  self:refreshRuneDetail()
end

function legendEquipTip:refreshEquipDetail()
  local selectEquip = self.legendEquip
  if not selectEquip then
    return
  end
  local typeId = selectEquip._type_id
  local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
  ed.createSpriteTools({
    res = legendEquipCfg.Painting,
    pos = ccp(65, 390),
    parent = self.ui.image_bg_1,
    scale = 0.55
  })
  local isOnly = legendEquipCfg["Is Only"]
  if isOnly then
    self.ui.image_only_tag:setVisible(true)
    self.ui.panel_star:setPositionY(358.5)
  else
    self.ui.image_only_tag:setVisible(false)
    self.ui.panel_star:setPositionY(385)
  end
  self.equipName:setString(legendEquipCfg["Equip Name"])
  local nameSize = self.equipName:getContentSize()
  self.equipName:setPosition(ccp(nameSize.width / 2, self.ui.panel_equip_name:getContentSize().height / 2))
  self.ui.panel_star:removeAllChildrenWithCleanup(true)
  local star = selectEquip._star
  local posX = 0
  for index = 1, star do
    local imageStar = ed.createSprite("UI/alpha/1080P/legendequip/star_unlock.png")
    local size = imageStar:getContentSize()
    local scale = 0.7
    imageStar:setScale(scale)
    self.ui.panel_star:addChild(imageStar)
    imageStar:setPosition(ccp(posX + size.width / 2 * scale, 13))
    posX = posX + size.width * scale
  end
end

function legendEquipTip:refreshAttr()
  local panelSize = self.ui.panel_attr_list:getContentSize()
  self.attrDragList:clearList()
  local selectEquip = self.legendEquip
  if not selectEquip then
    return
  end
  local typeId = selectEquip._type_id
  local star = selectEquip._star
  local rank = selectEquip._rank
  local totalHeight = 0
  local gapY = 0
  for index = 1, 50 do
    local enhanceCfg = ed.getDataTable("LegendEquipEnhance")[typeId][star][rank]
    local attrName = enhanceCfg["Attr Type " .. index]
    if not attrName then
      break
    end
    local attrValue = enhanceCfg["Attr Value " .. index]
    local attrItem, itemSize = self:createAttrItem(index, attrName, attrValue)
    self.attrDragList:addItem(attrItem)
    attrItem:setPosition(ccp(panelSize.width / 2, panelSize.height - totalHeight - itemSize.height / 2))
    totalHeight = totalHeight + itemSize.height + gapY
  end
  self.attrDragList:initListHeight(totalHeight)
end

function legendEquipTip:createAttrItem(index, attrName, attrValue)
  local bgPath
  if index % 2 == 1 then
    bgPath = "UI/alpha/1080P/hero/equip/equip_prop_bg_1.png"
  else
    bgPath = "UI/alpha/1080P/hero/equip/equip_prop_bg_2.png"
  end
  local container = ed.createScale9Sprite(bgPath, CCRectMake(18, 9, 4, 9))
  local size = CCSizeMake(262.5, 27)
  container:setContentSize(size)
  local labelName = ed.createLabelTTF(ed.ui.baseres.att_cn_name[attrName] or "", 16)
  ed.setLabelColor(labelName, ed.toccc3(16776423))
  ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
  labelName:setAnchorPoint(ccp(0, 0.5))
  container:addChild(labelName)
  labelName:setPosition(ccp(25, size.height / 2))
  local attrNum = attrValue
  if ed.ui.baseres.att_suffix[attrName] then
    attrNum = attrNum .. ed.ui.baseres.att_suffix[attrName]
  end
  local labelAttr = ed.createLabelTTF(attrNum, 16)
  ed.setLabelColor(labelAttr, ed.toccc3(16776423))
  ed.setLabelStroke(labelAttr, ed.toccc3(2565412), 1)
  labelAttr:setAnchorPoint(ccp(1, 0.5))
  container:addChild(labelAttr)
  labelAttr:setPosition(ccp(size.width - 10, size.height / 2))
  return container, size
end

function legendEquipTip:refreshSkillDetail()
  if not self.legendEquip then
    return
  end
  local skillId = self.skillUnlockInfo.skill_id
  local skillIsUnlock = self.skillUnlockInfo.skill_is_unlock
  local skillCfg = ed.getDataTable("LegendEquipSkill")[skillId]
  local clipNode, icon = ed.createClippingNodeEx(skillCfg.Icon, "UI/alpha/1080P/legendequip/skill_mask.png", nil, CCSizeMake(0, 0))
  self.ui.image_skill_frame:addChild(clipNode, -1)
  clipNode:setPosition(ccp(35, 35))
  ed.updateSpriteStone(icon, not skillIsUnlock)
  ed.setLabelString(self.ui.label_skill_name, skillCfg["Display Name"])
  ed.setLabelColor(self.ui.label_skill_name, skillIsUnlock and ccc3(255, 252, 231) or ed.toccc3(10459799))
  local autoText = ed.legendEquipTool.getLegendEquipSkillDesc(skillId, {
    maxWidth = self.ui.panel_skill_desc:getContentSize().width,
    fontSize = 15,
    color = skillIsUnlock and ccc3(255, 252, 231) or ed.toccc3(10459799),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1
  })
  local w, h = autoText:getCurContentSize()
  self.skillDescDragList:clearList()
  self.skillDescDragList:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, self.ui.panel_skill_desc:getContentSize().height - 8))
  self.skillDescDragList:initListHeight(h)
end

function legendEquipTip:refreshRuneDetail()
  if not self.legendEquip then
    return
  end
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_cfg = ed.getDataTable("LegendEquipSkill")[rune_1_id]
  ed.setLabelString(self.ui.label_rune_name_1, rune_1_cfg["Display Name"])
  ed.setTexture(self.ui.image_rune_icon_1, rune_1_cfg.Icon, true)
  if rune_1_is_unlock then
    ed.updateSpriteStone(self.ui.image_rune_icon_1, false)
    ed.setLabelColor(self.ui.label_rune_name_1, ed.toccc3(16776423))
  else
    ed.updateSpriteStone(self.ui.image_rune_icon_1, true)
    ed.setLabelColor(self.ui.label_rune_name_1, ed.toccc3(10459799))
  end
  local rune_2_id = self.skillUnlockInfo.rune_2_id
  local rune_2_is_unlock = self.skillUnlockInfo.rune_2_is_unlock
  local rune_2_cfg = ed.getDataTable("LegendEquipSkill")[rune_2_id]
  ed.setLabelString(self.ui.label_rune_name_2, rune_2_cfg["Display Name"])
  ed.setTexture(self.ui.image_rune_icon_2, rune_2_cfg.Icon, true)
  if rune_2_is_unlock then
    ed.updateSpriteStone(self.ui.image_rune_icon_2, false)
    ed.setLabelColor(self.ui.label_rune_name_2, ed.toccc3(16776423))
  else
    ed.updateSpriteStone(self.ui.image_rune_icon_2, true)
    ed.setLabelColor(self.ui.label_rune_name_2, ed.toccc3(10459799))
  end
end

function legendEquipTip:onClickRune1()
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_unlock_star = self.skillUnlockInfo.rune_1_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_1_id, rune_1_is_unlock, rune_1_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_bg_1:getContentSize()
  local bgSize = window.bg:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_bg_1, window.bg, {
    left = -bgSize.width / 2,
    top = bgSize.height + parentSize.height / 2
  })
end

function legendEquipTip:onClickRune2()
  local rune_2_is_unlock = self.skillUnlockInfo.rune_2_is_unlock
  local rune_2_id = self.skillUnlockInfo.rune_2_id
  local rune_2_unlock_star = self.skillUnlockInfo.rune_2_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_2_id, rune_2_is_unlock, rune_2_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_bg_2:getContentSize()
  local bgSize = window.bg:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_bg_2, window.bg, {
    left = -bgSize.width / 2,
    top = bgSize.height + parentSize.height / 2
  })
end

function legendEquipTip:onClickOnlyTag()
  ed.legendEquipTool.showLegendEquipOnlyTips(self.ui.image_only_tag)
end

function legendEquipTip:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.ui.image_bg_1,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  ed.UITool.registerBtn(self, "image_rune_bg_1", function()
    self:onClickRune1()
  end)
  ed.UITool.registerBtn(self, "image_rune_bg_2", function()
    self:onClickRune2()
  end)
  ed.UITool.registerBtn(self, "image_only_tag", function()
    self:onClickOnlyTag()
  end, {pressScale = 0.95})
end
