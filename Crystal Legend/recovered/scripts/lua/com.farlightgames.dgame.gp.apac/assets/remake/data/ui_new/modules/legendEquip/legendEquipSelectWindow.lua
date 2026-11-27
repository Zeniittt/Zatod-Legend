local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipSelectWindow = class
class.BTN_LIST = {
  "all",
  "only",
  "not_only"
}
class.BTN_CONFIG = {
  all = {
    text = T("\229\133\168\233\131\168"),
    filter = function(legendEquip)
      return true
    end
  },
  only = {
    text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
    filter = function(legendEquip)
      local isOnly = ed.getDataTable("LegendEquip")[legendEquip._type_id]["Is Only"]
      return isOnly
    end
  },
  not_only = {
    text = T("\230\153\174\233\128\154\232\163\133\229\164\135"),
    filter = function(legendEquip)
      local isOnly = ed.getDataTable("LegendEquip")[legendEquip._type_id]["Is Only"]
      return not isOnly
    end
  }
}
ed.UITool.registViewOpenFunc("legendEquipSelectWindow", function(param)
  local window = ed.ui.legendEquipSelectWindow.create(param)
  window:show()
  window:popWindow()
end)

function class.create(param)
  local self = base.create("legendEquipSelectWindow")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.heroId = param.heroId
  self.equipList = {}
  self.selectFilterType = "all"
  self.selectEquipId = nil
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initData()
  self:initView()
  self:addTouchEvent()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initData()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.legend_equip_select_window)
  self.container:addChild(container)
  self.ui = ui
  self:initData()
  self:initLabels()
  self:initDragList()
  self:refreshTableView()
  self:refreshBtnFilter()
  self:refreshEquipInfo()
  self:refreshBtnBind()
end

function class:initData()
end

function class:initLabels()
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
  ed.setLabelStroke(self.ui.label_skill_lock, ed.toccc3(2565412), 1)
end

function class:initDragList()
  self.attrDragList = ed.UITool.createDraglist(self.ui.panel_attr_list)
  self.skillDescDragList = ed.UITool.createDraglist(self.ui.panel_skill_desc)
  local size = self.ui.panel_equip_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.equipList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(90, 90)
    end,
    createCell = function(index)
      local equip = self.equipList[index]
      local icon = self:createEquipIcon(equip)
      return icon, {equip = equip}
    end,
    doPressIn = function(cell, x, y)
      local node = cell.node
      node.equipIcon:setScale(0.95)
    end,
    cancelPressIn = function(cell)
      local node = cell.node
      node.equipIcon:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local node = cell.node
      self:onClickEquipIcon(data.equip)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_equip_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 5,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:refreshEquipInfo()
  if self.selectEquipId then
    local legendEquip = self.mgr:getLegendEquip(self.selectEquipId)
    self.skillUnlockInfo = ed.legendEquipTool.getLegendEquipUnlockInfo(legendEquip)
  end
  self:refreshEquipDetail()
  self:refreshAttr()
  self:refreshSkillDetail()
  self:refreshRuneDetail()
  self:refreshBindTime()
end

function class:refreshEquipDetail()
  local selectEquip = self.mgr:getLegendEquip(self.selectEquipId)
  if not selectEquip then
    return
  end
  local typeId = selectEquip._type_id
  local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
  ed.setTexture(self.ui.image_equip_icon, legendEquipCfg.Painting)
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

function class:refreshAttr()
  local panelSize = self.ui.panel_attr_list:getContentSize()
  local selectEquip = self.mgr:getLegendEquip(self.selectEquipId)
  if not selectEquip then
    return
  end
  self.attrDragList:clearList()
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

function class:createAttrItem(index, attrName, attrValue)
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

function class:refreshSkillDetail()
  if not self.selectEquipId then
    return
  end
  local skillId = self.skillUnlockInfo.skill_id
  local skillIsUnlock = self.skillUnlockInfo.skill_is_unlock
  local legendEquipSkillCfg = ed.getDataTable("LegendEquipSkill")[skillId]
  self.ui.label_skill_lock:setVisible(not skillIsUnlock)
  local clipNode, icon = ed.createClippingNodeEx(legendEquipSkillCfg.Icon, "UI/alpha/1080P/legendequip/skill_mask.png", nil, CCSizeMake(0, 0))
  self.ui.image_skill_frame:addChild(clipNode, -1)
  clipNode:setPosition(ccp(35, 35))
  ed.updateSpriteStone(icon, not skillIsUnlock)
  ed.setLabelString(self.ui.label_skill_name, legendEquipSkillCfg["Display Name"])
  ed.setLabelColor(self.ui.label_skill_name, skillIsUnlock and ccc3(255, 252, 231) or ed.toccc3(10459799))
  ed.right2(self.ui.label_skill_lock, self.ui.label_skill_name, 10)
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

function class:refreshRuneDetail()
  if not self.selectEquipId then
    return
  end
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_cfg = ed.getDataTable("LegendEquipSkill")[rune_1_id]
  ed.setLabelString(self.ui.label_rune_name_1, rune_1_cfg["Display Name"])
  ed.setTexture(self.ui.image_rune_icon_1, rune_1_cfg.Icon)
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
  ed.setTexture(self.ui.image_rune_icon_2, rune_2_cfg.Icon)
  if rune_2_is_unlock then
    ed.updateSpriteStone(self.ui.image_rune_icon_2, false)
    ed.setLabelColor(self.ui.label_rune_name_2, ed.toccc3(16776423))
  else
    ed.updateSpriteStone(self.ui.image_rune_icon_2, true)
    ed.setLabelColor(self.ui.label_rune_name_2, ed.toccc3(10459799))
  end
end

function class:refreshBtnFilter()
  local cfg = self.BTN_CONFIG[self.selectFilterType]
  ed.setLabelString(self.ui.label_filter, cfg.text)
end

function class:refreshBtnBind()
  if self.selectEquipId then
    local selectEquip = self.mgr:getLegendEquip(self.selectEquipId)
    if selectEquip._carried_hero_id > 0 then
      ed.setTexture(self.ui.btn_bind, "UI/alpha/1080P/common/button_mini_grey.png")
      ed.setLabelColor(self.ui.label_bind, ccc3(255, 252, 231))
    else
      ed.setTexture(self.ui.btn_bind, "UI/alpha/1080P/common/button_com_mini.png")
      ed.setLabelColor(self.ui.label_bind, ccc3(255, 241, 169))
    end
  end
end

function class:refreshBindTime()
  if self.selectEquipId then
    local selectEquip = self.mgr:getLegendEquip(self.selectEquipId)
    local nextUnequipTime = selectEquip._next_unequip_time
    local serverTime = ed.getServerTime()
    if nextUnequipTime and nextUnequipTime > serverTime then
      local leftTime = nextUnequipTime - serverTime
      self.ui.image_bind_time_bg:setVisible(true)
      local day = math.floor(leftTime / 86400)
      local hour = math.floor(leftTime % 86400 / 3600)
      local min = math.floor(leftTime % 3600 / 60)
      if 0 < day then
        ed.setLabelString(self.ui.label_bind_time, string.format("%s\229\164\169%s\230\151\182", day, hour))
      else
        ed.setLabelString(self.ui.label_bind_time, string.format("%s\230\151\182%s\229\136\134", hour, min))
      end
    else
      self.ui.image_bind_time_bg:setVisible(false)
    end
  end
end

function class:refreshTableView()
  self.selectEquipId = nil
  self.equipList = {}
  for id, legendEquip in pairs(self.mgr:getAllLegendEquip()) do
    local filterHandler = class.BTN_CONFIG[self.selectFilterType].filter
    if filterHandler(legendEquip) then
      table.insert(self.equipList, legendEquip)
    end
  end
  table.sort(self.equipList, ed.cmpSort({
    {
      getValue = function(legendEquip)
        return legendEquip._carried_hero_id > 0 and 1 or 0
      end
    },
    {
      getValue = function(legendEquip)
        local typeId = legendEquip._type_id
        return ed.getDataTable("LegendEquip")[typeId]["Is Only"] and 0 or 1
      end
    },
    {key = "_type_id"},
    {key = "_star", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_id", reverse = true}
  }))
  ed.setLabelString(self.ui.label_title, string.format(T("\229\164\135\233\128\137\232\163\133\229\164\135\239\188\136%s\228\187\182\239\188\137"), #self.equipList))
  if #self.equipList > 0 then
    self.selectEquipId = self.equipList[1]._id
  end
  self.tableView:reloadData()
end

function class:createEquipIcon(equip)
  local id = equip._id
  local carriedHeroId = equip._carried_hero_id
  local container = ed.createSprite()
  container:setContentSize(CCSizeMake(90, 90))
  local equipIcon = ed.readequip.createLegendEquipIcon(equip)
  container:addChild(equipIcon)
  equipIcon:setPosition(ccp(45, 45))
  local cover = ed.createSprite("UI/alpha/1080P/legendequip/item_legendequip_cover.png")
  cover:setOpacity(76.5)
  cover:setPosition(ccp(45, 45))
  equipIcon:addChild(cover)
  cover:setVisible(id == self.selectEquipId)
  local mark = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
  equipIcon:addChild(mark)
  mark:setPosition(ccp(45, 45))
  mark:setVisible(id == self.selectEquipId)
  local nextUnequipTime = equip._next_unequip_time
  local serverTime = ed.getServerTime()
  if nextUnequipTime and nextUnequipTime > serverTime then
    local timeBg = ed.legendEquipTool.createUnBindTimeMask(nextUnequipTime)
    equipIcon:addChild(timeBg)
    timeBg:setPosition(ccp(45, 70))
  end
  if carriedHeroId and 0 < carriedHeroId then
    local heroIconFrame = ed.createSprite("UI/alpha/1080P/legendequip/hero_head.png")
    equipIcon:addChild(heroIconFrame)
    heroIconFrame:setPosition(ccp(15, 75))
    local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/legendequip/hero_cover.png")
    heroIconFrame:addChild(clippingNode)
    ed.layout.centerInParent(clippingNode)
    local portrait_res = ed.getUnitPortrait(carriedHeroId)
    local heroIcon = ed.createSprite(portrait_res)
    clippingNode:addChild(heroIcon)
    heroIcon:setScale(0.3)
    ed.layout.centerInParent(heroIcon)
    cover:setVisible(true)
  end
  container.selectMask = mark
  container.equipIcon = equipIcon
  return container
end

function class:onClickEquipIcon(equip)
  if self.selectEquipId == equip._id then
    return
  end
  self.selectEquipId = equip._id
  self.tableView:staticSync()
  self:refreshEquipInfo()
  self:refreshBtnBind()
end

function class:onClickBtnFilter()
  local filterPanel = class.filter_panel.create({
    selectFilterType = self.selectFilterType,
    onSelect = function(key)
      if self.selectFilterType == key then
        return
      end
      self.selectFilterType = key
      self:refreshTableView()
      self:refreshBtnFilter()
      self:refreshEquipInfo()
      self:refreshBtnBind()
    end
  })
  filterPanel:popWindow()
  ed.layout.relateLayout(self.ui.btn_filter, filterPanel.bg, {
    bottom = filterPanel.bg:getContentSize().height / 2 + 15
  })
end

function class:onClickBtnBind()
  if self.selectEquipId and self.heroId then
    local selectEquip = self.mgr:getLegendEquip(self.selectEquipId)
    if selectEquip._carried_hero_id > 0 then
      ed.showToast(T("\232\175\165\232\163\133\229\164\135\229\183\178\232\162\171\229\133\182\228\187\150\232\139\177\233\155\132\231\187\145\229\174\154"))
    elseif selectEquip._next_unequip_time and selectEquip._next_unequip_time > ed.getServerTime() then
      ed.UITool.openView("legendEquipBindConfirmWindow", {
        legendEquip = selectEquip,
        confirmCallBack = function()
          ed.legendEquipNet.sendEquip(self.heroId, self.selectEquipId)
          self:destroy()
        end
      })
    else
      ed.legendEquipNet.sendEquip(self.heroId, self.selectEquipId)
      self:destroy()
    end
  else
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\228\184\128\228\187\182\232\163\133\229\164\135"))
  end
end

function class:onClickRune1()
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_unlock_star = self.skillUnlockInfo.rune_1_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_1_id, rune_1_is_unlock, rune_1_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_bg_1:getContentSize()
  local winBgSize = window.bg:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_bg_1, window.bg, {
    top = winBgSize.height + parentSize.height / 2 + 5
  })
end

function class:onClickRune2()
  local rune_2_id = self.skillUnlockInfo.rune_2_id
  local rune_2_is_unlock = self.skillUnlockInfo.rune_2_is_unlock
  local rune_2_unlock_star = self.skillUnlockInfo.rune_2_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_2_id, rune_2_is_unlock, rune_2_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_bg_2:getContentSize()
  local winBgSize = window.bg:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_bg_2, window.bg, {
    top = winBgSize.height + parentSize.height / 2 + 5
  })
end

function class:onClickOnlyTag()
  ed.legendEquipTool.showLegendEquipOnlyTips(self.ui.image_only_tag)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_filter", function()
    self:onClickBtnFilter()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_bind", function()
    self:onClickBtnBind()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_rune_bg_1", function()
    self:onClickRune1()
  end)
  ed.UITool.registerBtn(self, "image_rune_bg_2", function()
    self:onClickRune2()
  end)
  ed.UITool.registerBtn(self, "image_only_tag", function()
    self:onClickOnlyTag()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.click_area,
    clickHandler = function()
      self:destroy()
    end,
    key = "click_out"
  })
end

local filter_panel = newclass(base.mt)
class.filter_panel = filter_panel

function filter_panel.create(param)
  local self = base.create("legendEquipFilter", {noShade = true})
  setmetatable(self, filter_panel.mt)
  self:init(param or {})
  return self
end

function filter_panel:init(param)
  self.selectFilterType = param.selectFilterType or "all"
  self.onSelect = param.onSelect
  self:initView()
  self:addTouchEvent()
end

function filter_panel:initView()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  local bgSize = CCSizeMake(180, 31 * #class.BTN_LIST)
  bg:setContentSize(bgSize)
  self.container:addChild(bg)
  self.bg = bg
  local totalHeight = 1
  self.optionList = {}
  for index, key in ipairs(class.BTN_LIST) do
    local option = self:createFilterOption(key)
    local optionSize = option:getContentSize()
    bg:addChild(option)
    option:setPosition(ccp(90, bgSize.height - totalHeight - optionSize.height / 2))
    totalHeight = totalHeight + optionSize.height
    table.insert(self.optionList, option)
    self:btRegisterButtonClick({
      button = option,
      key = "option" .. key,
      clickHandler = function()
        if self.onSelect then
          self.onSelect(key)
        end
        self:destroy({skipAnim = true})
      end,
      force = true
    })
  end
end

function filter_panel:createFilterOption(key)
  local cfg = class.BTN_CONFIG[key]
  local contentSize = CCSizeMake(176, 30)
  local node = CCNode:create()
  node:setContentSize(contentSize)
  node:setAnchorPoint(ccp(0.5, 0.5))
  local selectBg = ed.createScale9Sprite("installer/login/button_choose.png", CCRectMake(30, 0, 28, 0))
  node:addChild(selectBg)
  selectBg:setContentSize(CCSizeMake(contentSize.width, selectBg:getContentSize().height))
  selectBg:setPosition(ccp(contentSize.width * 0.5, contentSize.height * 0.5))
  local desText = ed.createttf(cfg.text, 15)
  node:addChild(desText)
  desText:setPosition(ccp(contentSize.width * 0.5, contentSize.height * 0.5))
  ed.setLabelColor(desText, ed.toccc3(16776423))
  ed.setLabelStroke(desText, ed.toccc3(2693915), 1)
  desText:limitWidthByScale(150)
  selectBg:setVisible(self.selectFilterType == key)
  node.selectBg = selectBg
  node.desText = desText
  node.key = key
  return node
end

function filter_panel:addTouchEvent()
  self:btRegisterOutClick({
    area = self.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end
