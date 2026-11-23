local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.fireForgeHandbookScene = class
class.scope = {}
ed.UITool.registViewOpenFunc("fireForgeHandbookScene", function()
  ed.legendEquipNet.sendHandBook()
  CloseScope(class.scope)
  ListenEventOnce("FireForgeHandBook", function()
    local scene = ed.ui.fireForgeHandbookScene.create()
    ed.pushScene(scene)
  end, class.scope)
end)

function class.create()
  local self = base.create("fireForgeHandbookScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.tableViewList = {}
  self.selectTypeId = 0
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initData()
  self:initView()
  self:addTouchEvent()
end

function class:initData()
  local onlyEquipList = {}
  local normalEquipList = {}
  self.collectOnlyAmount = 0
  self.collectNormalAmount = 0
  for typeId, legendEquipCfg in ipairs(ed.getDataTable("LegendEquip")) do
    local isCollect = self.mgr:getHandBookByTypeId(typeId)
    if legendEquipCfg["Is Only"] then
      table.insert(onlyEquipList, legendEquipCfg)
      if isCollect then
        self.collectOnlyAmount = self.collectOnlyAmount + 1
      end
    else
      table.insert(normalEquipList, legendEquipCfg)
      if isCollect then
        self.collectNormalAmount = self.collectNormalAmount + 1
      end
    end
  end
  self.onlyEquipList = onlyEquipList
  self.normalEquipList = normalEquipList
  self.selectTypeId = self.onlyEquipList[1]["Equip ID"]
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_handbook_scene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.ui.btn_rule:setVisible(false)
  self:setBackButton()
  self:adaptUI()
  self:initLabels()
  self:initDragList()
  self:initTableView()
  self:refreshTableView()
  self:refreshEquipDetail()
end

function class:initLabels()
  ed.UITool.createSceneTitle(T("\229\155\190\233\137\180"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.setLabelStroke(self.ui.label_attr_title, ed.toccc3(3478291), 1)
  ed.setLabelStroke(self.ui.label_skill_title, ed.toccc3(3478291), 1)
  ed.setLabelStroke(self.ui.label_not_have, ed.toccc3(2565412), 1)
end

function class:adaptUI()
  local diffWidth = ed.display.winSize.width - 960
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
  local oldDetailBgPosX = self.ui.image_detail_bg:getPositionX()
  ed.layout.layoutWithMagin(self.ui.image_detail_bg, {left = -120}, false, true)
  local newDetailBgPosX = self.ui.image_detail_bg:getPositionX()
  local offsetDetailBgPosX = newDetailBgPosX - oldDetailBgPosX
  self.ui.panel_list:setPositionX(self.ui.panel_list:getPositionX() + offsetDetailBgPosX)
  local oldPanelListSize = self.ui.panel_list:getContentSize()
  self.ui.panel_list:setContentSize(CCSizeMake(oldPanelListSize.width + diffWidth, oldPanelListSize.height))
end

function class:initDragList()
  self.attrDragList = ed.UITool.createDraglist(self.ui.panel_attr_list, {priority = -300})
  self.skillDescDragList = ed.UITool.createDraglist(self.ui.panel_skill_desc, {priority = -300})
end

function class:initTableView()
  local panelSize = self.ui.panel_list:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.tableViewList
    end,
    cellSizeFromIndex = function(index)
      local data = self.tableViewList[index]
      local type = data.type
      if type == "onlyTitle" then
        return CCSizeMake(panelSize.width, 60)
      elseif type == "normalTitle" then
        return CCSizeMake(panelSize.width, 30)
      end
      return CCSizeMake(panelSize.width, 91)
    end,
    createCell = function(index)
      local data = self.tableViewList[index]
      local type = data.type
      local node
      if type == "equip" then
        node = ed.createSprite()
        node:setContentSize(CCSizeMake(panelSize.width, 91))
        local itemSize = CCSizeMake(100, 100)
        local col = math.floor(panelSize.width / itemSize.width)
        local paddingWidth = (panelSize.width - col * itemSize.width) / (col - 1)
        local itemList = {}
        for dataIndex, legendEquipCfg in ipairs(data) do
          local item = self:createEquipItem(legendEquipCfg)
          node:addChild(item)
          table.insert(itemList, item)
          item:setPosition(ccp(itemSize.width * dataIndex - itemSize.width / 2 + (dataIndex - 1) * paddingWidth, 45.5))
        end
        return node, {
          type = type,
          data = data,
          itemList = itemList
        }
      else
        node = self:createTitle(type)
        return node, {type = type, data = data}
      end
    end,
    doClickIn = function(cell, x, y)
      local node = cell.node
      local data = cell.data
      local type = data.type
      if type == "equip" then
        local itemList = data.itemList
        for index, item in ipairs(itemList) do
          if ed.containsPoint(item, x, y) then
            self.selectTypeId = item.legendEquipCfg["Equip ID"]
            self:refreshTableView()
            self:refreshEquipDetail()
            return
          end
        end
      end
    end,
    doPressIn = function(cell, x, y)
    end,
    cancelPressIn = function(cell)
    end
  }
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, panelSize.width, panelSize.height),
    container = self.ui.panel_list,
    touchpriority = -300,
    zorder = 1,
    dragMode = 1,
    colNum = 1,
    noshade = true,
    padding = {width = 8, height = 8}
  }
  self.tableView = Tableview.create(param)
end

function class:createEquipItem(legendEquipCfg)
  local bg = ed.createSprite()
  local typeId = legendEquipCfg["Equip ID"]
  local isHave = self.mgr:getHandBookByTypeId(typeId)
  local equipIcon = ed.readequip.createBasicLegendEquipIcon(typeId)
  equipIcon.star:setVisible(false)
  bg:addChild(equipIcon, 1)
  bg:setContentSize(equipIcon:getContentSize())
  ed.layout.centerInParent(equipIcon)
  local selectFrame = ed.createSprite("UI/alpha/1080P/package/icon_selected.png")
  bg:addChild(selectFrame, 2)
  selectFrame:setPosition(ccp(45.5, 44.5))
  selectFrame:setVisible(self.selectTypeId == typeId)
  local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
  bg:addChild(mask, 4)
  ed.layout.centerInParent(mask)
  mask:setVisible(not isHave)
  local labelNotHave = ed.createLabelTTF(T("\230\156\170\230\139\165\230\156\137"), 14)
  bg:addChild(labelNotHave, 3)
  labelNotHave:setPosition(ccp(45, 20))
  ed.setLabelColor(labelNotHave, ed.toccc3(16776423))
  ed.setLabelStroke(labelNotHave, ed.toccc3(0), 1)
  labelNotHave:setVisible(not isHave)
  bg.equipIcon = equipIcon
  bg.selectFrame = selectFrame
  bg.legendEquipCfg = legendEquipCfg
  return bg
end

function class:createTitle(type)
  local panelSize = self.ui.panel_list:getContentSize()
  local size = CCSizeMake(panelSize.width, 50)
  local bg = ed.createSprite()
  bg:setContentSize(size)
  local container, ui = ed.editorui(ed.uieditor.fire_forge_handbook_title)
  container:setContentSize(size)
  bg:addChild(container)
  container:setPosition(ccp(size.width / 2, size.height / 2))
  if type == "onlyTitle" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/fireforge/bag/only_title.png", true)
    ed.setLabelString(ui.label_title, T("\229\148\175\228\184\128\232\163\133\229\164\135"))
    ed.setLabelColor(ui.label_title, ed.toccc3(16775789))
    ed.setLabelStroke(ui.label_title, ed.toccc3(11357460), 1)
    ed.setLabelString(ui.label_collect, string.format(T("\229\183\178\230\148\182\233\155\134(%s/%s)"), self.collectOnlyAmount, #self.onlyEquipList))
  else
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/fireforge/bag/normal_title.png", true)
    ed.setLabelString(ui.label_title, T("\230\153\174\233\128\154\232\163\133\229\164\135"))
    ed.setLabelColor(ui.label_title, ed.toccc3(15384466))
    ed.setLabelStroke(ui.label_title, ed.toccc3(3807759), 1)
    ui.label_tips:setVisible(false)
    ed.setLabelString(ui.label_collect, string.format(T("\229\183\178\230\148\182\233\155\134(%s/%s)"), self.collectNormalAmount, #self.normalEquipList))
  end
  ui.label_collect:setPositionX((1035 - size.width) / 2)
  return bg, ui
end

function class:refreshTableView()
  local panelSize = self.ui.panel_list:getContentSize()
  local itemSize = CCSizeMake(100, 100)
  self.tableViewList = {}
  self.col = math.floor(panelSize.width / itemSize.width)
  table.insert(self.tableViewList, {type = "onlyTitle"})
  for index, legendEquipCfg in ipairs(self.onlyEquipList) do
    if index % self.col == 1 then
      table.insert(self.tableViewList, {type = "equip"})
    end
    local equipList = self.tableViewList[#self.tableViewList]
    table.insert(equipList, legendEquipCfg)
  end
  table.insert(self.tableViewList, {
    type = "normalTitle"
  })
  for index, legendEquipCfg in ipairs(self.normalEquipList) do
    if index % self.col == 1 then
      table.insert(self.tableViewList, {type = "equip"})
    end
    local equipList = self.tableViewList[#self.tableViewList]
    table.insert(equipList, legendEquipCfg)
  end
  local listPosX, listPosY = self.tableView:getListPos()
  self.tableView:reloadData()
  if 0 < listPosY then
    self.tableView:setListPos(ccp(listPosX, listPosY))
  end
end

function class:refreshEquipDetail()
  local legendEquipCfg = ed.getDataTable("LegendEquip")[self.selectTypeId]
  self.legendEquip = {
    _type_id = legendEquipCfg["Equip ID"],
    _star = legendEquipCfg["Basic Star"],
    _rank = legendEquipCfg["Basic Rank"]
  }
  local skillUnlockInfo = ed.legendEquipTool.getLegendEquipUnlockInfo(self.legendEquip)
  self.skillUnlockInfo = skillUnlockInfo
  local isOnly = legendEquipCfg["Is Only"]
  if isOnly then
    ed.setLabelColor(self.ui.label_name, ed.toccc3(16775789))
    ed.setLabelStroke(self.ui.label_name, ed.toccc3(2232069), 1)
    ed.setTexture(self.ui.image_name_bg, "UI/alpha/1080P/fireforge/book/title_only1.png")
    ed.setTexture(self.ui.image_attr_title, "UI/alpha/1080P/fireforge/book/title_only2.png")
    ed.setTexture(self.ui.image_skill_title, "UI/alpha/1080P/fireforge/book/title_only2.png")
    self.ui.image_detail_bg:setOpacity(255)
  else
    ed.setLabelColor(self.ui.label_name, ed.toccc3(16776423))
    ed.setLabelStroke(self.ui.label_name, ed.toccc3(2565412), 1)
    ed.setTexture(self.ui.image_name_bg, "UI/alpha/1080P/fireforge/book/title_normal1.png")
    ed.setTexture(self.ui.image_attr_title, "UI/alpha/1080P/fireforge/book/title_normal2.png")
    ed.setTexture(self.ui.image_skill_title, "UI/alpha/1080P/fireforge/book/title_normal2.png")
    self.ui.image_detail_bg:setOpacity(178.5)
  end
  ed.setLabelString(self.ui.label_name, legendEquipCfg["Equip Name"])
  local isHave = self.mgr:getHandBookByTypeId(self.selectTypeId)
  if isHave then
    self.ui.label_not_have:setVisible(false)
  else
    self.ui.label_not_have:setVisible(true)
    self.ui.label_not_have:setPositionX(self.ui.label_name:getPositionX() + self.ui.label_name:getContentSize().width / 2 + 3)
  end
  self:refreshEquipIcon()
  self:refreshStarPanel()
  self:refreshAttr()
  self:refreshSkill()
  self:refreshRune()
end

function class:refreshEquipIcon()
  local legendEquipCfg = ed.getDataTable("LegendEquip")[self.selectTypeId]
  ed.setTexture(self.ui.image_icon, legendEquipCfg.Painting)
end

function class:refreshStarPanel()
  local panelSize = self.ui.panel_star:getContentSize()
  local curStar = self.legendEquip._star
  local curRank = self.legendEquip._rank
  local nodeList = {}
  self.ui.panel_star:removeAllChildrenWithCleanup(true)
  local node = self:createStar(curStar)
  self.starNode = node
  self.ui.panel_star:addChild(node)
  node:setPositionY(self.ui.panel_star:getContentSize().height / 2)
  table.insert(nodeList, node)
  ed.layout.horizontalSortNode(nodeList, nil, panelSize.width / 2)
end

function class:createStar(curStar)
  local totalWidth = 0
  local node = CCSprite:create()
  for index = 1, curStar do
    local imageStar = ed.createSprite("UI/alpha/1080P/legendequip/star_unlock.png")
    local size = imageStar:getContentSize()
    node:addChild(imageStar)
    imageStar:setPositionX(totalWidth + size.width / 2)
    totalWidth = totalWidth + size.width
    node["star_" .. index] = imageStar
  end
  node:setContentSize(CCSizeMake(totalWidth, 0))
  return node
end

function class:refreshAttr()
  local panelSize = self.ui.panel_attr_list:getContentSize()
  self.attrDragList:clearList()
  local typeId = self.legendEquip._type_id
  local star = self.legendEquip._star
  local rank = self.legendEquip._rank
  local legendEquipEnhanceCfg = ed.getDataTable("LegendEquipEnhance")[typeId]
  local enhanceCfg = legendEquipEnhanceCfg[star][rank]
  local totalHeight = 0
  local gapY = -5.5
  for index = 1, 50 do
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
    bgPath = "UI/alpha/1080P/legendequip/attribute1.png"
  else
    bgPath = "UI/alpha/1080P/legendequip/attribute2.png"
  end
  local container = ed.createScale9Sprite(bgPath, CCRectMake(30, 8, 8, 8))
  local size = CCSizeMake(self.ui.panel_attr_list:getContentSize().width, 27)
  container:setContentSize(size)
  local labelName = ed.createLabelTTF(ed.ui.baseres.att_cn_name[attrName] or "", 16)
  ed.setLabelColor(labelName, ed.toccc3(16771782))
  ed.setLabelStroke(labelName, ed.toccc3(2565412), 1)
  labelName:setAnchorPoint(ccp(0, 0.5))
  container:addChild(labelName)
  labelName:setPosition(ccp(30, size.height / 2))
  local attrNum = attrValue
  if ed.ui.baseres.att_suffix[attrName] then
    attrNum = attrNum .. ed.ui.baseres.att_suffix[attrName]
  end
  local labelAttr = ed.createLabelTTF(attrNum, 16)
  ed.setLabelColor(labelAttr, ed.toccc3(16771782))
  ed.setLabelStroke(labelAttr, ed.toccc3(2565412), 1)
  labelAttr:setAnchorPoint(ccp(1, 0.5))
  container:addChild(labelAttr)
  labelAttr:setPosition(ccp(size.width - 20, size.height / 2))
  return container, size
end

function class:refreshSkill()
  local skill_unlock_star = self.skillUnlockInfo.skill_unlock_star
  local skill_id = self.skillUnlockInfo.skill_id
  local skillCfg = ed.getDataTable("LegendEquipSkill")[skill_id]
  ed.setLabelString(self.ui.label_skill_name, skillCfg["Display Name"])
  local clipNode, icon = ed.createClippingNodeEx(skillCfg.Icon, "UI/alpha/1080P/legendequip/skill_mask.png", nil, CCSizeMake(0, 0))
  self.ui.image_skill_frame:addChild(clipNode, -1)
  ed.layout.centerInParent(clipNode)
  ed.setLabelColor(self.ui.label_skill_name, ed.toccc3(16771782))
  self.ui.image_skill_lock:setVisible(false)
  local autoText = ed.legendEquipTool.getLegendEquipSkillDesc(skill_id, {
    maxWidth = self.ui.panel_skill_desc:getContentSize().width,
    fontSize = 15,
    color = ed.toccc3(16771782),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1
  })
  local w, h = autoText:getCurContentSize()
  self.skillDescDragList:clearList()
  self.skillDescDragList:addItem(autoText.node)
  autoText.node:setPosition(ccp(0, self.ui.panel_skill_desc:getContentSize().height - 8))
  self.skillDescDragList:initListHeight(h)
end

function class:refreshRune()
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_unlock_star = self.skillUnlockInfo.rune_1_unlock_star
  local runeCfg_1 = ed.getDataTable("LegendEquipSkill")[rune_1_id]
  ed.setLabelString(self.ui.label_rune_name_1, string.format(T("\231\172\166\230\150\135-%s"), runeCfg_1["Display Name"]))
  ed.setTexture(self.ui.rune_icon_1, runeCfg_1.Icon, true)
  ed.setLabelColor(self.ui.label_rune_name_1, ed.toccc3(16771782))
  ed.setLabelColor(self.ui.label_rune_lock_1, ed.toccc3(7405396))
  local rune_2_is_unlock = self.skillUnlockInfo.rune_2_is_unlock
  local rune_2_id = self.skillUnlockInfo.rune_2_id
  local rune_2_unlock_star = self.skillUnlockInfo.rune_2_unlock_star
  local runeCfg_2 = ed.getDataTable("LegendEquipSkill")[rune_2_id]
  ed.setLabelString(self.ui.label_rune_name_2, string.format(T("\231\172\166\230\150\135-%s"), runeCfg_2["Display Name"]))
  ed.setTexture(self.ui.rune_icon_2, runeCfg_2.Icon, true)
  ed.setLabelColor(self.ui.label_rune_name_2, ed.toccc3(16771782))
  ed.setLabelColor(self.ui.label_rune_lock_2, ed.toccc3(7405396))
end

function class:onClickBtnRule()
end

function class:onClickRune1()
  local rune_1_is_unlock = self.skillUnlockInfo.rune_1_is_unlock
  local rune_1_id = self.skillUnlockInfo.rune_1_id
  local rune_1_unlock_star = self.skillUnlockInfo.rune_1_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_1_id, rune_1_is_unlock, rune_1_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_1:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_1, window.bg, {
    top = parentSize.height / 2 + window.bg:getContentSize().height
  })
end

function class:onClickRune2()
  local rune_2_is_unlock = self.skillUnlockInfo.rune_2_is_unlock
  local rune_2_id = self.skillUnlockInfo.rune_2_id
  local rune_2_unlock_star = self.skillUnlockInfo.rune_2_unlock_star
  local window = ed.ui.legendEquipRuneDetailWindow.create(rune_2_id, rune_2_is_unlock, rune_2_unlock_star)
  window:popWindow()
  local parentSize = self.ui.image_rune_2:getContentSize()
  ed.layout.relateLayout(self.ui.image_rune_2, window.bg, {
    top = parentSize.height / 2 + window.bg:getContentSize().height
  })
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_rune_1", function()
    self:onClickRune1()
  end)
  ed.UITool.registerBtn(self, "image_rune_2", function()
    self:onClickRune2()
  end)
end
