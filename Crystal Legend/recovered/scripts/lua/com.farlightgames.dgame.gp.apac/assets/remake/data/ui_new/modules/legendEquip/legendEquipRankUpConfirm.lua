local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipRankUpConfirm = class
ed.UITool.registViewOpenFunc("legendEquipRankUpConfirm", function(param)
  local window = ed.ui.legendEquipRankUpConfirm.create(param)
  window:show()
  window:popWindow()
end)

function class.create(param)
  local self = base.create("legendEquipRankUpConfirm")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.legendEquip = param.legendEquip
  self.confirmCallBack = param.confirmCallBack
  self.typeId = self.legendEquip._type_id
  self.star = self.legendEquip._star
  self.rank = self.legendEquip._rank
  self.resConfig = ed.heroDetailManager.resConfig
  self.legendEquipCfg = ed.getDataTable("LegendEquip")[self.typeId]
  self.legendEquipEnhanceCfg = ed.getDataTable("LegendEquipEnhance")[self.typeId]
  self:initView()
  self:addTouchEvent()
  self.refreshCliprectConfig = {
    draglist = self.attrDragList
  }
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_rank_up_confirm)
  self.container:addChild(container)
  self.ui = ui
  self:refreshCostItem()
  self:refreshAttrList()
end

function class:refreshCostItem()
  local enhanceCfg = self.legendEquipEnhanceCfg[self.star][self.rank]
  local costItemList = {}
  local costPrice = enhanceCfg["Cost Price"]
  if 0 < costPrice then
    table.insert(costItemList, {type = "Gold", amount = costPrice})
  end
  for index = 1, 10 do
    local costItemId = enhanceCfg[string.format("Cost Item ID %s", index)]
    if not costItemId or costItemId == 0 then
      break
    end
    local costItemAmount = enhanceCfg[string.format("Cost Item Amount %s", index)]
    table.insert(costItemList, {id = costItemId, amount = costItemAmount})
  end
  local costEquipAmount = enhanceCfg["Cost Equip Amount"]
  if 0 < costEquipAmount then
    table.insert(costItemList, {
      type = "legend_equip",
      id = self.typeId,
      amount = costEquipAmount
    })
  end
  local bgSize = self.ui.image_consume_bg:getContentSize()
  local itemList = {}
  local totalWidth = 0
  for index, itemCfg in ipairs(costItemList) do
    local itemIcon = ed.createItemIcon({
      id = itemCfg.id,
      type = itemCfg.type,
      amount = itemCfg.amount
    })
    self.ui.image_consume_bg:addChild(itemIcon)
    table.insert(itemList, itemIcon)
    itemIcon:setPositionY(bgSize.height / 2)
    totalWidth = totalWidth + itemIcon:getContentSize().width * itemIcon:getScale()
    self:btRegisterButtonClick({
      button = itemIcon,
      key = "click_cost_item" .. index,
      clickHandler = function()
        ed.UITool.openView("packageDetail", {
          id = itemCfg.id,
          type = itemCfg.type
        })
      end,
      force = true,
      mcpMode = true
    })
  end
  ed.layout.horizontalSortNode(itemList, nil, bgSize.width / 2)
end

function class:refreshAttrList()
  local attrChange, newSkill = ed.legendEquipTool.getLegendEquipAttrChange(self.legendEquip)
  self.attrDragList = ed.UITool.createDraglist(self.ui.panel_attr)
  local panelSize = self.ui.panel_attr:getContentSize()
  local totalHeight = 0
  for index, attrChangeCfg in ipairs(attrChange) do
    local attrName = attrChangeCfg.attrName
    local oldValue = attrChangeCfg.oldValue
    local newValue = attrChangeCfg.newValue
    local attrItem, size = self:createAttrChangeItem(index, attrName, oldValue, newValue)
    self.attrDragList:addItem(attrItem)
    attrItem:setPosition(ccp(panelSize.width / 2, panelSize.height - totalHeight - size.height / 2))
    totalHeight = totalHeight + size.height
  end
  self.attrDragList:initListHeight(totalHeight)
end

function class:createAttrChangeItem(index, attrName, oldValue, newValue)
  local bgPath
  if index % 2 == 1 then
    bgPath = "UI/alpha/1080P/hero/hero_upgrade_bg_3.png"
  else
    bgPath = "UI/alpha/1080P/hero/hero_upgrade_bg_4.png"
  end
  local container = ed.createScale9Sprite(bgPath, CCRectMake(25, 0, 2.5, 0.5))
  local size = CCSizeMake(540, 35)
  container:setContentSize(size)
  local labelName = ed.createLabelTTF(self.resConfig.att_cn_name[attrName], 16)
  ed.setLabelColor(labelName, ed.toccc3(16771782))
  ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
  labelName:setAnchorPoint(ccp(0, 0.5))
  labelName:setPosition(ccp(30, size.height / 2))
  container:addChild(labelName)
  if ed.ui.baseres.att_suffix[attrName] then
    oldValue = oldValue .. ed.ui.baseres.att_suffix[attrName]
  end
  local labelOldValue = ed.createLabelTTF(oldValue, 16)
  ed.setLabelColor(labelOldValue, ed.toccc3(16771782))
  ed.setLabelStroke(labelOldValue, ed.toccc3(2565412), 1)
  labelOldValue:setAnchorPoint(ccp(0, 0.5))
  labelOldValue:setPosition(ccp(200, size.height / 2))
  container:addChild(labelOldValue)
  local imageArrow = ed.createSprite("UI/alpha/1080P/hero/hero_upgrade_arrow.png")
  container:addChild(imageArrow)
  imageArrow:setScale(0.5)
  imageArrow:setPosition(ccp(310, size.height / 2))
  if ed.ui.baseres.att_suffix[attrName] then
    newValue = newValue .. ed.ui.baseres.att_suffix[attrName]
  end
  local labelNewValue = ed.createLabelTTF(newValue, 16)
  ed.setLabelColor(labelNewValue, ccc3(112, 255, 84))
  ed.setLabelStroke(labelNewValue, ed.toccc3(2565412), 1)
  labelNewValue:setAnchorPoint(ccp(0, 0.5))
  labelNewValue:setPosition(ccp(400, size.height / 2))
  container:addChild(labelNewValue)
  return container, size
end

function class:onClickBtnConfirm()
  if self.confirmCallBack then
    self.confirmCallBack()
  end
  self:destroy()
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "click_out",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "btn_cancel", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_confirm", function()
    self:onClickBtnConfirm()
  end, {pressScale = 0.95})
end

function class:addEventListener()
end
