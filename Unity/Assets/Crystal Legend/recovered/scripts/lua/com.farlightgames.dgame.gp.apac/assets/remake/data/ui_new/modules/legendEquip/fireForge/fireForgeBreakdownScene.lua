local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.fireForgeBreakdownScene = class
class.fast_select_option_cfg = {
  abandon = {
    text = T("\229\133\168\233\128\137\229\183\178\229\188\131\231\189\174"),
    handler = function(legendEquip)
      return legendEquip._is_discard == 1
    end
  },
  smaller_than_5_star = {
    text = T("\228\186\148\230\152\159\228\187\165\228\184\139"),
    handler = function(legendEquip)
      return legendEquip._star < 5
    end
  },
  smaller_than_4_star = {
    text = T("\229\155\155\230\152\159\228\187\165\228\184\139"),
    handler = function(legendEquip)
      return legendEquip._star < 4
    end
  },
  smaller_than_3_star = {
    text = T("\228\184\137\230\152\159\228\187\165\228\184\139"),
    handler = function(legendEquip)
      return legendEquip._star < 3
    end
  },
  smaller_than_2_star = {
    text = T("\228\186\140\230\152\159\228\187\165\228\184\139"),
    handler = function(legendEquip)
      return legendEquip._star < 2
    end
  }
}
class.fast_option_list = {
  "abandon",
  "smaller_than_5_star",
  "smaller_than_4_star",
  "smaller_than_3_star",
  "smaller_than_2_star"
}
ed.UITool.registViewOpenFunc("fireForgeBreakdownScene", function()
  local scene = ed.ui.fireForgeBreakdownScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("fireForgeBreakdownScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.legendEquipList = {}
  self.selectFilterTypeId = 0
  self.selectFastKey = nil
  self.isReverse = false
  self.isShowFilterPanel = false
  self.isShowFastSelectPanel = false
  self.selectEquipList = {}
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:initListenEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_breakdown_scene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  self:adaptUI()
  self:initLabels()
  self:initTableView()
  self:initDragList()
  self:refreshView()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
  local label_breakdown = ed.ui.gradientLabel.create({
    text = T("\229\136\134\232\167\163"),
    fontSize = 22,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(10572575)
  })
  self.ui.btn_breakdown:addChild(label_breakdown.node)
  ed.layout.centerInParent(label_breakdown.node)
end

function class:initLabels()
  ed.UITool.createSceneTitle(T("\229\136\134\232\167\163"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.setLabelStroke(self.ui.label_reward_tips, ed.toccc3(986381), 1)
  ed.setLabelStroke(self.ui.label_filter, ed.toccc3(2693915), 1)
  ed.setLabelStroke(self.ui.label_fast_select, ed.toccc3(2693915), 1)
  ed.setLabelFontName(self.ui.label_empty_tips, ed.fontBold)
  ed.setLabelStroke(self.ui.label_empty_tips, ed.toccc3(3347476), 1.5)
end

function class:initDragList()
  self.rewardDragList = ed.UITool.createDraglist(self.ui.panel_reward_list, {
    doPressIn = function(x, y)
      for index, item in ipairs(self.rewardItemList or {}) do
        if ed.containsPoint(item.icon, x, y) then
          item.icon:setScale(0.75)
          return item
        end
      end
    end,
    doClickIn = function(x, y, item)
      ed.UITool.openView("packageDetail", {
        id = item.id,
        type = "item"
      })
    end,
    cancelPressIn = function(x, y, item)
      item.icon:setScale(0.8)
    end
  })
  self.filterDragList = ed.UITool.createDraglist(self.ui.panel_filter_option, {
    swallow = true,
    doPressIn = function(x, y)
      for index, filterOption in ipairs(self.filterOptionList or {}) do
        if ed.containsPoint(filterOption, x, y) then
          return filterOption
        end
      end
    end,
    doClickIn = function(x, y, filterOption)
      self:onClickFilterOption(filterOption)
    end
  })
  self.fastSelectDragList = ed.UITool.createDraglist(self.ui.panel_fast_select_option, {
    swallow = true,
    doPressIn = function(x, y)
      for index, fastOption in ipairs(self.fastSelectOptionList) do
        if ed.containsPoint(fastOption, x, y) then
          return fastOption
        end
      end
    end,
    doClickIn = function(x, y, fastOption)
      self:onClickFastOption(fastOption)
    end
  })
end

function class:onClickFilterOption(filterOption)
  local typeId = filterOption.typeId
  local amount = filterOption.amount
  if typeId == self.selectFilterTypeId then
    self.selectFilterTypeId = 0
  else
    self.selectFilterTypeId = typeId
  end
  self.isShowFilterPanel = false
  self:refreshFilterPanel()
  self:refreshTableView()
  self:refreshRewardDragList()
end

function class:onClickFastOption(fastOption)
  local fastKey = fastOption.fastKey
  if fastKey == self.selectFastKey then
    self.selectFastKey = nil
  else
    self.selectFastKey = fastKey
  end
  self.isShowFastSelectPanel = false
  self:refreshFastSelectPanel()
  self:refreshTableView()
  self:refreshRewardDragList()
end

function class:getIconSize()
  return CCSizeMake(108, 105)
end

function class:initTableView()
  local size = self.ui.panel_equip_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.legendEquipList
    end,
    cellSizeFromIndex = function(index)
      return self:getIconSize()
    end,
    createCell = function(index)
      local legendEquip = self.legendEquipList[index]
      local icon = self:createLegendEquipIcon(legendEquip)
      return icon, {legendEquip = legendEquip}
    end,
    doPressIn = function(cell, x, y)
      local node = cell.node
      if ed.containsPoint(node.icon, x, y) then
        node.icon:setScale(0.95)
      end
    end,
    cancelPressIn = function(cell)
      local node = cell.node
      node.btn_reduce:setScale(1)
      node.icon:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local node = cell.node
      local legendEquip = data.legendEquip
      if ed.containsPoint(node.icon, x, y) then
        if self.selectEquipList[legendEquip._id] then
          self.selectEquipList[legendEquip._id] = nil
        else
          self.selectEquipList[legendEquip._id] = legendEquip
        end
      end
      if self.selectEquipList[legendEquip._id] then
        node.btn_reduce:setVisible(true)
      else
        node.btn_reduce:setVisible(false)
      end
      self:refreshRewardDragList()
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_equip_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 8,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:createLegendEquipIcon(legendEquip)
  local bg = ed.createSprite()
  bg:setContentSize(self:getIconSize())
  local icon = ed.readequip.createLegendEquipIcon(legendEquip)
  bg:addChild(icon)
  ed.layout.centerInParent(icon)
  local btn_reduce = ed.createSprite("UI/alpha/1080P/soulexchange/soulexchange_minus.png")
  icon:addChild(btn_reduce)
  btn_reduce:setPosition(ccp(71, 73))
  local btn_abandon = ed.createSprite("UI/alpha/1080P/fireforge/break/abandon.png")
  icon:addChild(btn_abandon)
  btn_abandon:setPosition(ccp(70, 21))
  btn_abandon:setVisible(legendEquip._is_discard == 1)
  if self.selectEquipList[legendEquip._id] then
    btn_reduce:setVisible(true)
  else
    btn_reduce:setVisible(false)
  end
  bg.icon = icon
  bg.btn_reduce = btn_reduce
  bg.btn_abandon = btn_abandon
  return bg
end

function class:refreshView()
  self:refreshBtnSort()
  self:refreshFilterPanel()
  self:refreshFastSelectPanel()
  self:refreshTableView()
  self:refreshRewardDragList()
end

function class:refreshTableView()
  self.selectEquipList = {}
  self.legendEquipList = {}
  for id, legendEquip in pairs(self.mgr:getAllLegendEquip()) do
    local isSuccess = true
    if legendEquip._carried_hero_id and legendEquip._carried_hero_id > 0 then
      isSuccess = false
    else
      local typeId = legendEquip._type_id
      local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
      if legendEquipCfg["Is Only"] then
        isSuccess = false
      else
        if self.selectFilterTypeId ~= 0 and self.selectFilterTypeId ~= typeId then
          isSuccess = false
        else
        end
      end
    end
    if isSuccess then
      table.insert(self.legendEquipList, legendEquip)
      if self.selectFastKey then
        local handler = self.fast_select_option_cfg[self.selectFastKey].handler
        if handler(legendEquip) then
          self.selectEquipList[legendEquip._id] = legendEquip
        end
      end
    end
  end
  table.sort(self.legendEquipList, ed.cmpSort({
    {
      getValue = function(legendEquip)
        return 0
      end
    },
    {
      key = "_star",
      reverse = not self.isReverse
    },
    {
      key = "_rank",
      reverse = not self.isReverse
    },
    {
      key = "_id",
      reverse = self.isReverse
    }
  }))
  self.ui.image_empty_tips:setVisible(#self.legendEquipList == 0)
  self.tableView:reloadData()
end

function class:refreshRewardDragList()
  self.rewardItemList = {}
  self.rewardDragList:clearList()
  local panelSize = self.ui.panel_reward_list:getContentSize()
  local legendEquipTB = ed.getDataTable("LegendEquip")
  local rewards = {}
  for id, legendEquip in pairs(self.selectEquipList) do
    local typeId = legendEquip._type_id
    local legendEquipCfg = legendEquipTB[typeId]
    local fragmentItemId = legendEquipCfg["Fragment Item"]
    local amount = legendEquipCfg["Fragment Amount"]
    if not rewards[fragmentItemId] then
      rewards[fragmentItemId] = {id = fragmentItemId, amount = amount}
    else
      rewards[fragmentItemId].amount = rewards[fragmentItemId].amount + amount
    end
  end
  local totalWidth = 0
  for rewardId, reward in pairs(rewards) do
    local icon = ed.createItemIcon({
      id = reward.id,
      type = "item",
      amount = reward.amount
    })
    icon:setScale(0.8)
    local size = icon:getContentSize()
    self.rewardDragList:addItem(icon)
    icon:setPosition(ccp(totalWidth + size.width / 2 * 0.8, panelSize.height / 2))
    totalWidth = totalWidth + size.width * 0.8
    table.insert(self.rewardItemList, {
      icon = icon,
      id = reward.id
    })
  end
  self.rewardDragList:initListWidth(totalWidth)
end

function class:refreshFilterPanel()
  self.filterOptionList = {}
  if self.isShowFilterPanel then
    self.ui.image_filter_bg:setVisible(true)
    self.ui.image_filter_arrow:setRotation(180)
  else
    self.ui.image_filter_bg:setVisible(false)
    self.ui.image_filter_arrow:setRotation(0)
    return
  end
  self.filterDragList:clearList()
  local panelSize = self.ui.panel_filter_option:getContentSize()
  local filterList = {0}
  for typeId, legendEquipCfg in ipairs(ed.getDataTable("LegendEquip")) do
    if not legendEquipCfg["Is Only"] then
      table.insert(filterList, typeId)
    end
  end
  local totalHeight = 0
  local targetIndex
  for index, typeId in ipairs(filterList) do
    local option, size = self:createFilterItem(typeId)
    if typeId == self.selectFilterTypeId then
      targetIndex = index
    end
    self.filterDragList:addItem(option)
    option:setPosition(ccp(panelSize.width / 2, panelSize.height - size.height / 2 - totalHeight))
    totalHeight = totalHeight + size.height + 2
    table.insert(self.filterOptionList, option)
  end
  self.filterDragList:initListHeight(totalHeight)
  if targetIndex and totalHeight > panelSize.height then
    local listHeight = self.filterDragList:getListHeight()
    local listY = math.min(listHeight - panelSize.height, (targetIndex - 1) * 37.5)
    self.filterDragList:setListPos(ccp(0, listY))
  end
end

function class:createFilterItem(typeId)
  local bg = ed.createSprite()
  local image_select = ed.createSprite("UI/alpha/1080P/fireforge/break/typechoose_select.png")
  bg:setContentSize(image_select:getContentSize())
  bg:addChild(image_select)
  ed.layout.centerInParent(image_select)
  local name, amount
  if typeId == 0 then
    name = T("\229\133\168\233\131\168")
    amount = self.mgr:getLegendEquipAmount()
  else
    local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
    name = legendEquipCfg["Equip Name"]
    amount = #self.mgr:getLegendEquipByTypeId(typeId)
  end
  if self.selectFilterTypeId ~= typeId then
    image_select:setVisible(false)
  end
  local label_name = ed.createLabelTTF(name, 16)
  label_name:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(label_name, 0 < amount and ed.toccc3(16771782) or ed.toccc3(11776947))
  ed.setLabelStroke(label_name, ed.toccc3(986381), 1)
  bg:addChild(label_name)
  label_name:setPosition(ccp(20, 19))
  local label_amount = ed.createLabelTTF(amount, 16)
  label_amount:setAnchorPoint(ccp(1, 0.5))
  ed.setLabelColor(label_amount, 0 < amount and ed.toccc3(16771782) or ed.toccc3(11776947))
  ed.setLabelStroke(label_amount, ed.toccc3(986381), 1)
  bg:addChild(label_amount)
  label_amount:setPosition(ccp(160, 19))
  bg.typeId = typeId
  bg.amount = amount
  bg.label_name = label_name
  bg.label_amount = label_amount
  bg.image_select = image_select
  return bg, bg:getContentSize()
end

function class:refreshFastSelectPanel()
  if self.selectFastKey then
    ed.setLabelString(self.ui.label_fast_select, self.fast_select_option_cfg[self.selectFastKey].text)
    ed.setLabelColor(self.ui.label_fast_select, ed.toccc3(16744799))
    ed.setLabelStroke(self.ui.label_fast_select, ed.toccc3(6756633), 1)
  else
    ed.setLabelString(self.ui.label_fast_select, T("\229\191\171\233\128\159\233\128\137\230\139\169"))
    ed.setLabelColor(self.ui.label_fast_select, ed.toccc3(16771782))
    ed.setLabelStroke(self.ui.label_fast_select, ed.toccc3(2693915), 1)
  end
  self.fastSelectOptionList = {}
  if self.isShowFastSelectPanel then
    self.ui.image_fast_select_bg:setVisible(true)
  else
    self.ui.image_fast_select_bg:setVisible(false)
    return
  end
  self.fastSelectDragList:clearList()
  local panelSize = self.ui.panel_fast_select_option:getContentSize()
  local totalHeight = 0
  for index, fastKey in ipairs(self.fast_option_list) do
    local option, size = self:createFastSelectItem(fastKey)
    self.fastSelectDragList:addItem(option)
    option:setPosition(ccp(panelSize.width / 2, panelSize.height - size.height / 2 - totalHeight))
    totalHeight = totalHeight + size.height + 2
    table.insert(self.fastSelectOptionList, option)
  end
  self.fastSelectDragList:initListHeight(totalHeight)
end

function class:createFastSelectItem(fastKey)
  local bg = ed.createSprite()
  local image_select = ed.createSprite("UI/alpha/1080P/fireforge/break/typechoose_select.png")
  bg:setContentSize(image_select:getContentSize())
  bg:addChild(image_select)
  ed.layout.centerInParent(image_select)
  local optionCfg = self.fast_select_option_cfg[fastKey]
  local name = optionCfg.text
  local label_name = ed.createLabelTTF(name, 16)
  label_name:setAnchorPoint(ccp(0, 0.5))
  ed.setLabelColor(label_name, ed.toccc3(11776947))
  ed.setLabelStroke(label_name, ed.toccc3(986381), 1)
  bg:addChild(label_name)
  label_name:setPosition(ccp(20, 19))
  local check_box = ed.createSprite("UI/alpha/1080P/fireforge/break/starchoose_basic.png")
  bg:addChild(check_box)
  check_box:setPosition(ccp(145, 19))
  local image_mark = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
  check_box:addChild(image_mark)
  image_mark:setScale(0.65)
  image_mark:setPosition(ccp(18, 18))
  image_mark:setVisible(fastKey == self.selectFastKey)
  image_select:setVisible(fastKey == self.selectFastKey)
  bg.fastKey = fastKey
  return bg, bg:getContentSize()
end

function class:refreshBtnSort()
  if self.isReverse then
    ed.setTexture(self.ui.image_sort_arrow, "UI/alpha/1080P/fireforge/break/function_order1.png")
  else
    ed.setTexture(self.ui.image_sort_arrow, "UI/alpha/1080P/fireforge/break/funticon_order2.png")
  end
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\232\175\180\230\152\142"),
    txt = "\230\143\143\232\191\176"
  }):popWindow()
end

function class:onClickBtnSort()
  self.isReverse = not self.isReverse
  self:refreshBtnSort()
  self:refreshTableView()
end

function class:onClickBtnFilter()
  self.isShowFilterPanel = not self.isShowFilterPanel
  self:refreshFilterPanel()
end

function class:onClickBtnFastSelect()
  self.isShowFastSelectPanel = not self.isShowFastSelectPanel
  self:refreshFastSelectPanel()
end

function class:onClickBtnBreakdown()
  local equipIdList = {}
  local haveHighQuality = false
  for id, legendEquip in pairs(self.selectEquipList) do
    if legendEquip._star >= 4 then
      haveHighQuality = true
    end
    table.insert(equipIdList, id)
  end
  if #equipIdList == 0 then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\232\166\129\229\136\134\232\167\163\231\154\132\228\188\160\229\165\135\232\163\133\229\164\135"))
    return
  end
  if haveHighQuality then
    ed.UITool.openView("fireForeConfirmWindow", {
      desc = T("\233\128\137\228\184\173\232\163\133\229\164\135\229\144\171\230\156\137<lable color=ccc3(227,84,84)>4\230\152\159</lable>\228\187\165\228\184\138\232\163\133\229\164\135\239\188\140\230\152\175\229\144\166\229\136\134\232\167\163\239\188\159"),
      rightHandler = function()
        ed.legendEquipNet.sendEquipRecycle(equipIdList)
      end
    })
  else
    ed.legendEquipNet.sendEquipRecycle(equipIdList)
  end
end

function class:onClickBtnClearFastSelect()
  self.selectFastKey = nil
  self.isShowFastSelectPanel = false
  self:refreshFastSelectPanel()
  self:refreshTableView()
  self:refreshRewardDragList()
end

function class:getPressHandler()
  local function handler(param, x, y)
    if not ed.containsPoint(self.ui.image_filter_bg, x, y) and self.isShowFilterPanel then
      self.isShowFilterPanel = false
      
      self:refreshFilterPanel()
    end
    if not ed.containsPoint(self.ui.image_fast_select_bg, x, y) and self.isShowFastSelectPanel then
      self.isShowFastSelectPanel = false
      self:refreshFastSelectPanel()
    end
  end
  
  return handler
end

function class:addTouchEvent()
  self:btRegisterClick({
    key = "panel_touch_area",
    pressHandler = self:getPressHandler(),
    force = true
  })
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_sort", function()
    self:onClickBtnSort()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_filter", function()
    self:onClickBtnFilter()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_fast_select", function()
    self:onClickBtnFastSelect()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_breakdown", function()
    self:onClickBtnBreakdown()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_clear_fast_select", function()
    self:onClickBtnClearFastSelect()
  end, {pressScale = 0.95})
end

function class:initListenEvent()
  self:listenEvent("ChangeLegendEquip", function()
    self.selectEquipList = {}
    self:refreshView()
  end)
end
