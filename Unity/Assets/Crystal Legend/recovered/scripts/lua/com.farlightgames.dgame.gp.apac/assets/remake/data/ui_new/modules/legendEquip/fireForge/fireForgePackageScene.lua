local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.fireForgePackageScene = class
ed.UITool.registViewOpenFunc("fireForgePackageScene", function()
  local scene = ed.ui.fireForgePackageScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("fireForgePackageScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initData()
  self:initUI()
  self:initTableView()
  self:initDraglist()
  self:showEquipLayer()
  self:registerEvents()
end

function class:initData()
  self.layerIndex = 1
  self.equipIndex = 1
  self.curLayerIndex = nil
  self.curEquipIndex = nil
  self.mgr = ed.legendEquipMgr.getInstance()
  self.detailFragmentId = nil
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_package)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.ui.button_rule:setVisible(false)
  self:initRedDot()
  self:setBackground("UI/alpha/1080P/fireforge/bag/background.jpg")
  self.bg:setAnchorPoint(ccp(0.5, 0))
  ed.layout.centerInScreen(self.bg)
  local bgEffect = ed.createSprite("UI/alpha/1080P/fireforge/bag/background_effect.png")
  bgEffect:setScale(self.bg:getScaleX())
  bgEffect:setAnchorPoint(ccp(0.5, 0))
  bgEffect:setPosition(self.bg:getPosition())
  self.scene:addChild(bgEffect)
  bgEffect:setZOrder(-1)
  self.bg:setZOrder(-2)
  self:setBackButton(function()
    self.redPointMgr:setNodeValue("fire_forge_package_entry_new_equip", 0)
    ed.playEffect(ed.sound.common.back)
  end)
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
  self:adaptUI()
  self:initLabels()
end

function class:initRedDot()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.equipListRedRefer = {}
  local compose_imageRed_1 = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  self.ui.fragment_selected_label:addChild(compose_imageRed_1)
  local labelSize = self.ui.fragment_selected_label:getContentSize()
  compose_imageRed_1:setPosition(ccp(labelSize.width + 8, 18.5))
  local compose_imageRed_2 = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  self.ui.fragment_unselect:addChild(compose_imageRed_2)
  compose_imageRed_2:setPosition(ccp(labelSize.width + 7, 18))
  self.redPointMgr:registerValueChange("fire_forge_package_compose", self, {
    handle = function(value)
      compose_imageRed_1:setVisible(0 < value)
      compose_imageRed_2:setVisible(0 < value)
    end
  })
end

local function debugShowLayer(layer)
  local colorLay = CCLayerColor:create(ccc4(255, 255, 0, 250))
  local posx, posy = layer:getPosition()
  colorLay:setPosition(ccp(posx, posy))
  colorLay:setContentSize(layer:getContentSize())
  layer:getParent():addChild(colorLay)
end

function class:adaptUI()
  local widthWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local halfFixedWidth = (widthWin - 1170) * 0.5
  local halfFixedHeight = ed.display.halfFixedHeight
  local barSize = self.ui.image_tag:getContentSize()
  local newWidth = math.min(814, widthWin - 300)
  halfFixedWidth = (newWidth - barSize.width) * 0.5
  self.ui.image_tag:setContentSize(CCSizeMake(newWidth, barSize.height))
  ed.UITool.setPositionBy(self.ui.image_tag, ccp(0, halfFixedHeight))
  ed.UITool.setPositionBy(self.ui.equip_selected_bg, ccp(halfFixedWidth, 0))
  ed.UITool.setPositionBy(self.ui.fragment_selected_bg, ccp(halfFixedWidth, 0))
  ed.UITool.setPositionBy(self.ui.equip_unselect, ccp(halfFixedWidth, 0))
  ed.UITool.setPositionBy(self.ui.fragment_unselect, ccp(halfFixedWidth, 0))
  ed.UITool.setPositionBy(self.ui.btn_equip, ccp(halfFixedWidth, 0))
  ed.UITool.setPositionBy(self.ui.btn_fragment, ccp(halfFixedWidth, 0))
  barSize = self.ui.fragment_list_bg:getContentSize()
  self.ui.fragment_list_bg:setContentSize(CCSizeMake(barSize.width + halfFixedWidth * 2, barSize.height))
  ed.UITool.setPositionBy(self.ui.fragment_list_bg, ccp(0, halfFixedHeight))
  barSize = self.ui.draglist_fragment:getContentSize()
  self.ui.draglist_fragment:setContentSize(CCSizeMake(barSize.width + halfFixedWidth * 2, barSize.height + halfFixedHeight * 2))
  ed.UITool.setPositionBy(self.ui.draglist_fragment, ccp(-halfFixedWidth, -halfFixedHeight))
  ed.UITool.setPositionBy(self.ui.btn_fusion_all, ccp(0, -halfFixedHeight))
  local deltaX = (self.ui.fragment_detail_bg:getContentSize().width + self.ui.fragment_list_bg:getContentSize().width) * 0.5 + 20
  self.ui.fragment_detail_bg:setPositionX(self.ui.fragment_list_bg:getPositionX() - deltaX)
  barSize = self.ui.fragment_detail_bg:getContentSize()
  self.ui.fragment_detail_bg:setContentSize(CCSizeMake(barSize.width, barSize.height + halfFixedHeight * 2))
  ed.UITool.setPositionBy(self.ui.fragment_icon, ccp(0, halfFixedHeight * 2))
  ed.UITool.setPositionBy(self.ui.fragment_name_bg, ccp(0, halfFixedHeight * 2))
  ed.UITool.setPositionBy(self.ui.fragment_own_label_Copy0, ccp(0, halfFixedHeight * 2))
  ed.UITool.setPositionBy(self.ui.fragment_own_num, ccp(0, halfFixedHeight * 2))
  barSize = self.ui.panel_fragment_info:getContentSize()
  self.ui.panel_fragment_info:setContentSize(CCSizeMake(barSize.width, barSize.height + halfFixedHeight * 2))
  barSize = self.ui.draglist_equip:getContentSize()
  newWidth = math.min(1020, widthWin - 40)
  halfFixedWidth = (newWidth - barSize.width) * 0.5
  self.ui.draglist_equip:setContentSize(CCSizeMake(newWidth, barSize.height + halfFixedHeight * 2))
  ed.UITool.setPositionBy(self.ui.draglist_equip, ccp(-halfFixedWidth, -halfFixedHeight))
  ed.UITool.setPositionBy(self.ui.equip_tag_bar, ccp(0, -halfFixedHeight))
end

local layerNameTbl = {
  [1] = "equip",
  [2] = "fragment"
}
local equipTypeNameTbl = {
  [1] = {
    name = "all",
    showName = T("\229\133\168\233\131\168"),
    checkFunc = function(equipInfo)
      return true
    end
  },
  [2] = {
    name = "attach",
    showName = T("\229\183\178\231\187\145\229\174\154"),
    checkFunc = function(equipInfo)
      return equipInfo._carried_hero_id and equipInfo._carried_hero_id > 0
    end
  },
  [3] = {
    name = "detach",
    showName = T("\230\156\170\231\187\145\229\174\154"),
    checkFunc = function(equipInfo)
      return equipInfo._carried_hero_id == nil or equipInfo._carried_hero_id <= 0
    end
  }
}

function class:initLabels()
  local title_bg, title_text = ed.UITool.createSceneTitle(T("\232\131\140\229\140\133"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  for _, name in ipairs(layerNameTbl) do
    ed.setLabelStroke(self.ui[name .. "_selected_label"], ed.toccc3(4533525), 1)
    ed.setLabelStroke(self.ui[name .. "_unselect"], ed.toccc3(1905428), 1)
  end
  for i = 1, 3 do
    ed.setLabelStroke(self.ui["btn_" .. i .. "_selected_label"], ed.toccc3(6309402), 1)
  end
  ed.setLabelStroke(self.ui.fragment_own_label_Copy0, ed.toccc3(1970963), 1.5)
  ed.setLabelStroke(self.ui.fragment_own_num, ed.toccc3(1970963), 1.5)
  local compose_ten = ed.ui.gradientLabel.create({
    text = T("\228\184\128\233\148\174\229\144\136\230\136\144"),
    fontSize = 22,
    startColor = ed.toccc3(16775087),
    endColor = ed.toccc3(16776946),
    strokeSize = 2,
    strokeColor = ed.toccc3(10572575)
  })
  ed.UITool.replaceUINew(self.ui, "btn_fusion_all_label", compose_ten.node)
end

function class:showLayerTag()
  if self.layerIndex == self.curLayerIndex then
    return
  end
  local curLayer = layerNameTbl[self.layerIndex]
  for index, name in ipairs(layerNameTbl) do
    self.ui[name .. "_selected_bg"]:setVisible(name == curLayer)
    self.ui[name .. "_unselect"]:setVisible(name ~= curLayer)
  end
  self.curLayerIndex = self.layerIndex
  self.equipTblView.dragList:setVisible(self.curLayerIndex == 1)
  self.fragmentTblView.dragList:setVisible(self.curLayerIndex == 2)
end

function class:showEquipTag()
  if self.equipIndex == self.curEquipIndex then
    return
  end
  for i = 1, 3 do
    self.ui["btn_" .. i .. "_selected"]:setVisible(i == self.equipIndex)
    self.ui["btn_" .. i .. "_unselect"]:setVisible(i ~= self.equipIndex)
  end
  self.curEquipIndex = self.equipIndex
  local equipTypeInfo = equipTypeNameTbl[self.curEquipIndex]
  if self.equipListData[equipTypeInfo.name] == nil then
    self.equipListData[equipTypeInfo.name] = {}
    for _, info in ipairs(self.equipListData.all) do
      if equipTypeInfo.checkFunc(info) then
        table.insert(self.equipListData[equipTypeInfo.name], info)
      end
    end
  end
  self.equipTypeData = self.equipListData[equipTypeInfo.name]
  self.equipTypeData.onlyOne = nil
  self.equipTypeData.common = nil
  self.combineEquipData = {}
  for _, val in ipairs(self.equipTypeData) do
    local equipTbl = ed.getDataTable("LegendEquip")[val._type_id]
    local isOnly = equipTbl["Is Only"]
    if isOnly then
      if not self.equipTypeData.onlyOne then
        self.equipTypeData.onlyOne = {
          [1] = {type = "onlyOne"}
        }
      end
      local lastIndex = #self.equipTypeData.onlyOne
      local lastData = self.equipTypeData.onlyOne[lastIndex]
      if lastData.type ~= "equip" or lastData.val and #lastData.val == self.equipColNum then
        table.insert(self.equipTypeData.onlyOne, {
          type = "equip",
          val = {
            [1] = val
          }
        })
      elseif lastData.val then
        table.insert(lastData.val, val)
      end
    else
      if not self.equipTypeData.common then
        self.equipTypeData.common = {
          [1] = {type = "common"}
        }
      end
      local lastIndex = #self.equipTypeData.common
      local lastData = self.equipTypeData.common[lastIndex]
      if lastData.type ~= "equip" or lastData.val and #lastData.val == self.equipColNum then
        table.insert(self.equipTypeData.common, {
          type = "equip",
          val = {
            [1] = val
          }
        })
      elseif lastData.val then
        table.insert(lastData.val, val)
      end
    end
  end
  if self.equipTypeData.onlyOne then
    for _, value in ipairs(self.equipTypeData.onlyOne) do
      table.insert(self.combineEquipData, value)
    end
  end
  if self.equipTypeData.common then
    for _, value in ipairs(self.equipTypeData.common) do
      table.insert(self.combineEquipData, value)
    end
  end
  self.redPointMgr:unregisterAllValueChange(self.equipListRedRefer)
  self.equipTblView:reloadData()
  local hasNoTagEquip = self.curEquipIndex > 1 and #self.combineEquipData == 0
  if #self.equipListData.all > 0 then
    self.ui.panel_fragment_none:setVisible(hasNoTagEquip)
  end
  if hasNoTagEquip then
    ed.setLabelString(self.ui.no_fragment_tip, T("\230\154\130\230\151\160%s\232\163\133\229\164\135", equipTypeNameTbl[self.curEquipIndex].showName))
  end
end

function class:showEquipLayer()
  self.equipTblView.dragList:setVisible(true)
  self.curEquipIndex = nil
  self.layerIndex = 1
  self:showLayerTag()
  self:refreshEquipData()
  self.ui.panel_fragment:setVisible(false)
  self.ui.panel_equip:setVisible(#self.equipListData.all > 0)
  self.ui.panel_fragment_none:setVisible(#self.equipListData.all <= 0)
  if #self.equipListData.all <= 0 then
    ed.setLabelString(self.ui.no_fragment_tip, T("\229\176\154\230\156\170\232\142\183\229\190\151\232\163\133\229\164\135"))
  end
  self.equipIndex = 1
  self:showEquipTag()
end

local function cmpFragment(frag1, frag2)
  local isOnly1 = frag1.isOnly and 0 or 1
  local isOnly2 = frag2.isOnly and 0 or 1
  local canCompose1 = frag1.canCompose and 0 or 1
  local canCompose2 = frag2.canCompose and 0 or 1
  if isOnly1 ~= isOnly2 then
    return isOnly1 < isOnly2
  elseif canCompose1 ~= canCompose2 then
    return canCompose1 < canCompose2
  else
    return frag1.equipId < frag2.equipId
  end
end

function class:refreshFragmentTbl()
  local fragmentTbl = {}
  local tbl = ed.getDataTable("LegendEquip")
  for id, val in pairs(tbl) do
    local fragmentId = val["Fragment Item"]
    local fragmentAmount = ed.player:getEquipAmount(fragmentId)
    if fragmentAmount and 0 < fragmentAmount then
      local isOnly = val["Is Only"]
      local needAmount = val["Fragment Amount"]
      local canCompose = fragmentAmount > needAmount and (not isOnly or #self.mgr:getLegendEquipByTypeId(id) == 0)
      table.insert(fragmentTbl, {
        fragmentId = fragmentId,
        equipId = id,
        fragmentAmount = fragmentAmount,
        isOnly = isOnly,
        needAmount = needAmount,
        canCompose = canCompose
      })
      self.canCompose = self.canCompose or canCompose
    end
  end
  table.sort(fragmentTbl, cmpFragment)
  for ind, val in ipairs(fragmentTbl) do
    val.dataInd = ind
  end
  local lastInd
  for id, val in ipairs(fragmentTbl) do
    if self.detailFragmentId and val.fragmentId == self.detailFragmentId then
      lastInd = id
    end
  end
  if lastInd == nil then
    self.detailFragmentId = fragmentTbl[1] and fragmentTbl[1].fragmentId or nil
  end
  if fragmentTbl and fragmentTbl[1] then
    self.showFragmentId = lastInd and fragmentTbl[lastInd].dataInd or fragmentTbl[1].dataInd
  end
  return fragmentTbl
end

function class:showFragmentLayer()
  self.canCompose = false
  local fragmentTbl = self:refreshFragmentTbl()
  self.ui.btn_fusion_all:setVisible(self.canCompose)
  self.ui.panel_equip:setVisible(false)
  self.ui.panel_fragment:setVisible(0 < #fragmentTbl)
  self.ui.panel_fragment_none:setVisible(#fragmentTbl <= 0)
  self.fragmentData = fragmentTbl
  self.combineFragmentData = {}
  self.interFragmentData = {}
  if #fragmentTbl <= 0 then
    ed.setLabelString(self.ui.no_fragment_tip, T("\229\176\154\230\156\170\232\142\183\229\190\151\231\162\142\231\137\135"))
  else
    for ind, val in ipairs(self.fragmentData) do
      local equipTbl = ed.getDataTable("LegendEquip")[val.equipId]
      local isOnly = equipTbl["Is Only"]
      if isOnly then
        if not self.interFragmentData.onlyOne then
          self.interFragmentData.onlyOne = {
            [1] = {type = "onlyOne"}
          }
        end
        local lastIndex = #self.interFragmentData.onlyOne
        local lastData = self.interFragmentData.onlyOne[lastIndex]
        if lastData.type ~= "fragment" or lastData.val and #lastData.val == self.fragColNum then
          table.insert(self.interFragmentData.onlyOne, {
            type = "fragment",
            val = {
              [1] = val
            }
          })
        elseif lastData.val then
          table.insert(lastData.val, val)
        end
      else
        if not self.interFragmentData.common then
          self.interFragmentData.common = {
            [1] = {type = "common"}
          }
        end
        local lastIndex = #self.interFragmentData.common
        local lastData = self.interFragmentData.common[lastIndex]
        if lastData.type ~= "fragment" or lastData.val and #lastData.val == self.fragColNum then
          table.insert(self.interFragmentData.common, {
            type = "fragment",
            val = {
              [1] = val
            }
          })
        elseif lastData.val then
          table.insert(lastData.val, val)
        end
      end
    end
    if self.interFragmentData.onlyOne then
      for _, value in ipairs(self.interFragmentData.onlyOne) do
        table.insert(self.combineFragmentData, value)
      end
    end
    if self.interFragmentData.common then
      for _, value in ipairs(self.interFragmentData.common) do
        table.insert(self.combineFragmentData, value)
      end
    end
  end
  self.layerIndex = 2
  self:showLayerTag()
  if 0 < #fragmentTbl then
    self.selectCellUI = {}
    self.fragmentTblView:reloadData()
    self.selectCellUI[self.showFragmentId]:setVisible(true)
    self:showFragmentDetail()
  end
end

function class:showFragmentDetail()
  local info = self.fragmentData[self.showFragmentId]
  if info == nil then
    self.ui.fragment_detail_bg:setVisible(false)
    return
  end
  self.fragmentDraglist:clearList()
  self.ui.fragment_detail_bg:setVisible(true)
  local icon = ed.readequip.createIcon(info.fragmentId)
  self.ui.fragment_icon:addChild(icon)
  local isOnly = info.isOnly
  ed.setLabelColor(self.ui.fragment_name_label, isOnly and ed.toccc3(16772234) or ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.fragment_name_label, isOnly and ed.toccc3(4530444) or ed.toccc3(2565412), 1.5)
  ed.setLabelString(self.ui.fragment_name_label, ed.lookupDataTable("equip", "Name", info.fragmentId))
  ed.setLabelString(self.ui.fragment_own_num, info.fragmentAmount)
  if isOnly then
    ed.setTexture(self.ui.fragment_name_bg, "UI/alpha/1080P/fireforge/bag/fragmentinfo_only_title.png", true)
  else
    ed.setTexture(self.ui.fragment_name_bg, "UI/alpha/1080P/fireforge/bag/fragmentinfo_normal_title.png", true)
  end
  ed.layout.centerInParent(self.ui.fragment_name_label)
  local hei = 0
  local desStr = ed.readequip.value(info.fragmentId, "Description")
  local commentStr = ed.readequip.value(info.fragmentId, "Comment")
  local posY = hei
  local size = self.ui.panel_fragment_info:getContentSize()
  if desStr then
    local desLabel = ed.createLabelTTF(desStr, 15)
    desLabel:setAnchorPoint(ccp(0, 0.5))
    desLabel:setColor(ed.toccc3(13871241))
    ed.setLabelStroke(desLabel, ed.toccc3(1970963), 1.5)
    desLabel:setDimensions(CCSizeMake(size.width - 8, 0))
    desLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = desLabel:getContentSize().height
    desLabel:setPosition(ccp(4, size.height - (posY + height / 2)))
    self.fragmentDraglist:addItem(desLabel)
    posY = posY + height + 4
  end
  if commentStr then
    local commentLabel = ed.createLabelTTF(commentStr, 15)
    commentLabel:setColor(ed.toccc3(13871241))
    ed.setLabelStroke(commentLabel, ed.toccc3(1970963), 1.5)
    commentLabel:setDimensions(CCSizeMake(size.width - 8, 0))
    commentLabel:setAnchorPoint(ccp(0, 0.5))
    commentLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
    local height = commentLabel:getContentSize().height
    commentLabel:setPosition(ccp(4, size.height - (posY + height / 2)))
    self.fragmentDraglist:addItem(commentLabel)
    posY = posY + height + 4
  end
  local getWay = ed.packageGetWay(info.fragmentId)
  self.getWayItemList = {}
  if 0 < #getWay then
    posY = posY + 10
    if #getWay == 1 then
      posY = posY + 5
    end
    local equipSourceLabel = ed.createLabelTTF(T("\232\142\183\229\143\150\233\128\148\229\190\132") .. ":", 15)
    local width = equipSourceLabel:getContentSize().width
    local height = equipSourceLabel:getContentSize().height
    equipSourceLabel:setColor(ed.toccc3(13871241))
    ed.setLabelStroke(equipSourceLabel, ed.toccc3(1970963), 1.5)
    equipSourceLabel:setPosition(ccp(8 + width / 2, size.height - (posY + height / 2)))
    self.fragmentDraglist:addItem(equipSourceLabel)
    posY = posY + height + 4
  end
  for index, data in ipairs(getWay or {}) do
    local container, ui = self:createGetWayItem(data)
    local width = container:getContentSize().width
    local height = container:getContentSize().height
    container:setPosition(ccp(size.width / 2, size.height - (posY + height / 2)))
    self.fragmentDraglist:addItem(container)
    posY = posY + height + 5
    table.insert(self.getWayItemList, {
      container = container,
      ui = ui,
      data = data
    })
  end
  self.fragmentDraglist:initListHeight(posY)
  local canCompose = info.canCompose
  self.composeFragmentStatus = "Pass"
  ed.resetSpriteShader(self.ui.btn_fusion)
  local legendEquip = self.mgr:getLegendEquipByTypeId(info.equipId)[1]
  if not (not canCompose and isOnly) or not legendEquip then
    local compose_one = ed.ui.gradientLabel.create({
      text = T("\229\144\136\230\136\144"),
      fontSize = 22,
      startColor = ed.toccc3(16775087),
      endColor = ed.toccc3(16776946),
      strokeSize = 2,
      strokeColor = ed.toccc3(10572575)
    })
    ed.UITool.replaceUINew(self.ui, "btn_fusion_label", compose_one.node)
  elseif 5 > legendEquip._star then
    self.composeFragmentStatus = "Lock"
    local compose_one = ed.ui.gradientLabel.create({
      text = T("\229\144\136\230\136\144"),
      fontSize = 22,
      startColor = ed.toccc3(16775087),
      endColor = ed.toccc3(16776946),
      strokeSize = 2,
      strokeColor = ed.toccc3(10572575)
    })
    ed.UITool.replaceUINew(self.ui, "btn_fusion_label", compose_one.node)
    ed.setSpriteStone(self.ui.btn_fusion)
  else
    self.composeFragmentStatus = "Sale"
    local compose_one = ed.ui.gradientLabel.create({
      text = T("\229\135\186\229\148\174"),
      fontSize = 22,
      startColor = ed.toccc3(16775087),
      endColor = ed.toccc3(16776946),
      strokeSize = 2,
      strokeColor = ed.toccc3(10572575)
    })
    ed.UITool.replaceUINew(self.ui, "btn_fusion_label", compose_one.node)
  end
end

function class:createGetWayItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  ui.arrow = nil
  local bg = ed.createSprite("UI/alpha/1080P/fireforge/bag/get_board.png")
  local txt = ed.createLabelTTF(data.name, 17, ed.font)
  ed.setLabelColor(txt, ed.toccc3(16776423))
  ed.setLabelStroke(txt, ed.toccc3(1970963), 1.5)
  txt:limitWidthByScale(150)
  local size = bg:getContentSize()
  if data.type ~= "fireForgeMainScene" then
    local arrow = ed.createSprite("UI/alpha/1080P/fireforge/bag/get_arrow.png")
    ui.arrow = arrow
    bg:addChild(arrow)
    arrow:setPosition(ccp(size.width - 20, size.height * 0.5))
  end
  txt:setPosition(ccp(txt:getContentSize().width * txt:getScaleX() * 0.5, size.height * 0.5))
  bg:addChild(txt)
  container:addChild(bg)
  container:setContentSize(bg:getContentSize())
  ui.bg = bg
  if data.state == "Locked" then
    bg:setColor(ccc3(100, 100, 100))
    if ui.arrow then
      ui.arrow:setVisible(false)
    end
    local lock_tip = ed.createLabelTTF(T("\230\156\170\229\188\128\230\148\190"), 14)
    ed.setLabelColor(lock_tip, ccc3(180, 180, 180))
    bg:addChild(lock_tip)
    lock_tip:setPosition(ccp(size.width - 25, size.height * 0.5))
    ed.adaptLabel(lock_tip, {
      maxWidth = 45,
      minScale = 0.7,
      maxHeight = 60
    })
  end
  return container, ui
end

local function cmpEquip(equip1, equip2)
  local isOnly1 = ed.lookupDataTable("LegendEquip", "Is Only", equip1._type_id) and 0 or 1
  local isOnly2 = ed.lookupDataTable("LegendEquip", "Is Only", equip2._type_id) and 0 or 1
  local hasOwner1 = equip1._carried_hero_id and 0 < equip1._carried_hero_id and 0 or 1
  local hasOwner2 = equip2._carried_hero_id and 0 < equip2._carried_hero_id and 0 or 1
  if isOnly1 ~= isOnly2 then
    return isOnly1 < isOnly2
  elseif hasOwner1 ~= hasOwner2 then
    return hasOwner1 < hasOwner2
  elseif equip1._star ~= equip2._star then
    return equip1._star > equip2._star
  elseif equip1._rank ~= equip2._rank then
    return equip1._rank > equip2._rank
  else
    return equip1._type_id < equip2._type_id
  end
end

function class:refreshEquipData()
  self.equipListData = {}
  local equipData = self.mgr:getAllLegendEquip()
  self.equipListData.all = {}
  for id, val in pairs(equipData) do
    table.insert(self.equipListData.all, val)
  end
  table.sort(self.equipListData.all, cmpEquip)
end

function class:initTableView()
  self.combineEquipData = {}
  local size = self.ui.draglist_equip:getContentSize()
  local colNum = math.min(math.floor(size.width / 254), 4)
  self.equipColNum = colNum
  local offsetX = (size.width - colNum * 254) * 0.5
  local delegate = {
    numberOfCells = function()
      return #self.combineEquipData
    end,
    cellSizeFromIndex = function(index)
      if self.combineEquipData[index].type == "onlyOne" then
        return CCSizeMake(size.width, 50)
      elseif self.combineEquipData[index].type == "common" then
        return CCSizeMake(size.width, 30)
      end
      return CCSizeMake(size.width, 91)
    end,
    createCell = function(index)
      local function getPos(ind)
        local x = offsetX + (ind - 1) * 254
        
        return ccp(x, 0)
      end
      
      local data = self.combineEquipData[index]
      local node, uis, equipInfos
      if data.type == "equip" then
        node = CCNode:create()
        uis = {}
        equipInfos = {}
        node:setContentSize(CCSizeMake(self.ui.draglist_equip:getContentSize().width, 91))
        for ind, equip in ipairs(data.val) do
          local container, ui = self:createEquipItem(equip)
          container:setContentSize(CCSizeMake(246, 91))
          container:setAnchorPoint(ccp(0, 0))
          node:addChild(container)
          container:setPosition(getPos(ind))
          ui.container = container
          uis[ind] = ui
          equipInfos[ind] = equip
        end
        return node, {
          equipInfos = equipInfos,
          uis = uis,
          index = index,
          isEquip = true
        }
      elseif data.type == "onlyOne" then
        node, uis = self:createOnlyOneSeq(self.ui.draglist_equip:getContentSize().width)
        equipInfos = nil
      elseif data.type == "common" then
        node, uis = self:createCommonSeq(self.ui.draglist_equip:getContentSize().width)
        equipInfos = nil
      end
      return node, {
        equipInfos = equipInfos,
        uis = uis,
        index = index
      }
    end,
    doClickIn = function(cell, x, y)
      if not cell.data.isEquip then
        return
      end
      local param = cell.data
      if not param.uis then
        return
      end
      for ind, ui in ipairs(param.uis) do
        if ed.containsPoint(ui.container, x, y) then
          self.redPointMgr:setNodeValue("new_legend_equip_" .. param.equipInfos[ind]._id, 0)
          ed.UITool.openView("legendEquipWindow", {
            legendEquip = param.equipInfos[ind]
          })
        end
      end
    end,
    doPressIn = function(cell, x, y)
      if cell.data.isEquip then
        return cell
      end
      return nil
    end,
    cancelPressIn = function(cell)
    end
  }
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    container = self.ui.draglist_equip,
    touchpriority = -300,
    zorder = 1,
    dragMode = 1,
    colNum = 1,
    noshade = true,
    padding = {width = 8, height = 4}
  }
  self.equipTblView = Tableview.create(param)
  self.equipTblView.dragList:setVisible(false)
  self.fragmentData = {}
  self.combineFragmentData = {}
  local fragSize = self.ui.draglist_fragment:getContentSize()
  local fragColNum = math.min(math.floor(fragSize.width / 103), 8)
  self.fragColNum = fragColNum
  local fragOffsetX = (fragSize.width - fragColNum * 103) * 0.5
  delegate = {
    numberOfCells = function()
      return #self.combineFragmentData
    end,
    cellSizeFromIndex = function(index)
      if self.combineFragmentData[index].type == "onlyOne" then
        return CCSizeMake(self.ui.draglist_fragment:getContentSize().width, 50)
      elseif self.combineFragmentData[index].type == "common" then
        return CCSizeMake(self.ui.draglist_fragment:getContentSize().width, 30)
      end
      return CCSizeMake(self.ui.draglist_fragment:getContentSize().width, 100)
    end,
    createCell = function(index)
      local function getPos(ind)
        local x = fragOffsetX + (ind - 1) * 103
        
        return ccp(x, 0)
      end
      
      local data = self.combineFragmentData[index]
      ed.pt(self.combineFragmentData)
      local node, uis, fragmentInfos
      if data.type == "fragment" then
        node = CCNode:create()
        uis = {}
        fragmentInfos = {}
        node:setContentSize(CCSizeMake(self.ui.draglist_fragment:getContentSize().width, 100))
        for ind, fragment in ipairs(data.val) do
          local container, ui = self:createFragmentItem(fragment)
          container:setContentSize(CCSizeMake(95, 100))
          container:setAnchorPoint(ccp(0, 0))
          node:addChild(container)
          container:setPosition(getPos(ind))
          ui.container = container
          uis[ind] = ui
          fragmentInfos[ind] = fragment
        end
        return node, {
          fragmentInfos = fragmentInfos,
          uis = uis,
          index = index,
          isFragment = true
        }
      elseif data.type == "onlyOne" then
        node, uis = self:createOnlyOneSeq(self.ui.draglist_fragment:getContentSize().width)
        fragmentInfos = nil
      elseif data.type == "common" then
        node, uis = self:createCommonSeq(self.ui.draglist_fragment:getContentSize().width)
        fragmentInfos = nil
      end
      return node, {
        fragmentInfos = fragmentInfos,
        uis = uis,
        index = index
      }
    end,
    doClickIn = function(cell, x, y)
      if not cell.data.isFragment then
        return
      end
      local param = cell.data
      if not param.uis then
        return
      end
      for ind, ui in ipairs(param.uis) do
        if ed.containsPoint(ui.container, x, y) and self.showFragmentId and self.showFragmentId ~= param.fragmentInfos[ind].dataInd then
          if self.showFragmentId then
            self.selectCellUI[self.showFragmentId]:setVisible(false)
          end
          self.showFragmentId = param.fragmentInfos[ind].dataInd
          self.detailFragmentId = param.fragmentInfos[ind].fragmentId
          self.selectCellUI[self.showFragmentId]:setVisible(true)
          self:showFragmentDetail()
          return
        end
      end
    end,
    doPressIn = function(cell, x, y)
      if cell.data.isFragment then
        return cell
      end
      return nil
    end,
    cancelPressIn = function(cell)
    end
  }
  param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, fragSize.width, fragSize.height),
    container = self.ui.draglist_fragment,
    touchpriority = -300,
    zorder = 1,
    dragMode = 1,
    colNum = 1,
    noshade = true,
    padding = {width = 8, height = 12},
    offset = {fragOffsetX, 0}
  }
  self.fragmentTblView = Tableview.create(param)
  self.fragmentTblView.dragList:setVisible(false)
end

function class:initDraglist()
  self.fragmentDraglist = ed.UITool.createDraglist(self.ui.panel_fragment_info, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    priority = -300
  })
end

function class:doPressInList()
  local function handler(x, y)
    for k, item in pairs(self.getWayItemList or {}) do
      local ui = item.ui
      
      local container = ui.container
      local data = item.data
      if data.state == "Normal" and ed.containsPoint(ui.bg, x, y) then
        container:setScale(0.95)
        return item
      end
    end
  end
  
  return handler
end

function class:doClickInList()
  local function handler(x, y, item)
    if not item then
      return
    end
    local container = item.container
    local data = item.data
    local ui = item.ui
    if ed.containsPoint(ui.bg, x, y) then
      self:clickGetWay(data)
    end
  end
  
  return handler
end

function class:cancelPressInList()
  local function handler(x, y, item)
    if not item then
      return
    end
    local container = item.container
    if container then
      container:setScale(1)
    end
  end
  
  return handler
end

function class:clickGetWay(data)
  if data.type == "stage" then
    ed.ui.stagedetail.create(data.id):popWindow()
    ed.stageSelectParam = nil
  elseif data.type == "summon" then
    ed.summonMgr.noBottomButton = true
    ed.UITool.openView("summonScene")
  elseif data.type == "skillTower" then
    ed.UITool.openView("SkillTowerStageScene", data.id)
  elseif data.type == "shop" then
    ed.UITool.openView("shopMain", {
      page = data.id
    })
  elseif data.type == "heroExercise" then
    ed.exerciseManager:openExerciseMainScene()
  elseif data.type == "task" then
    ed.UITool.openView("taskScene", {})
  elseif data.type == "awakeDungeon" then
    ed.UITool.openView("awakeDungeonScene")
  elseif data.type == "nianMonster" then
    ed.UITool.openView("nianMonsterMainScene")
  elseif data.type == "chat" then
    ed.chatManager:openChatMainWin(ed.chatManager.ChannelEnum.world_channel)
  elseif data.type == "NewYearDaysLogin" then
    local actId
    if ed.activityHints.data:getActivityIsOpenById(85) then
      actId = 85
    elseif ed.activityHints.data:getActivityIsOpenById(94) then
      actId = 94
    end
    ed.UITool.openView("activityScene", {actId = actId})
  elseif data.type == "CDKey" then
    if not ed.getPopWindow("playerInfoWindow") then
      ed.ui.playerInfoWindow.create():popWindow()
    end
  elseif data.type == "growPlan" then
    ed.UITool.openView("activityScene", {openActType = "grow_plan"})
  elseif data.type == "RechargeScene" then
    ed.pushScene(ed.ui.RechargeScene.create({
      page = "Gift",
      giftItemId = self.id
    }))
  elseif data.type == "rogueMainScene" then
    ed.UITool.openView("rogueMainScene")
  elseif data.type == "fireForgeMainScene" then
    ed.showToast(T("\229\156\168\232\191\156\229\143\164\231\134\148\231\130\137\228\184\173\233\148\187\233\128\160\230\156\137\230\166\130\231\142\135\232\142\183\229\190\151"))
  elseif data.type == "latestStageScene" then
    ed.UITool.openView("stageSelect")
  elseif data.type == "skillTowerMainScene" then
    ed.UITool.openView("SkillTowerScene", data.id)
  elseif data.type == "legendEquipShopScene" then
    ed.UITool.openView("legendEquipShopScene")
  elseif data.type == "dayAwardsScene" then
    ed.UITool.openView("dayAwardsScene", {})
  end
end

function class:createEquipItem(equipInfo)
  local container, ui = ed.editorui(ed.uieditor.fire_forge_equip_item)
  local equipTbl = ed.getDataTable("LegendEquip")[equipInfo._type_id]
  local isOnly = equipTbl["Is Only"]
  if not isOnly then
    ed.setLabelColor(ui.name_label, ed.toccc3(16776423))
    ed.setTexture(ui.bg, "UI/alpha/1080P/fireforge/bag/normal_board.png", true)
    ed.setTexture(ui.name_bg, "UI/alpha/1080P/fireforge/bag/normal_name.png", true)
  end
  local strokeColor = isOnly and ed.toccc3(2232069) or ed.toccc3(2565412)
  ed.setLabelStroke(ui.name_label, strokeColor, 1.5)
  ed.setLabelStroke(ui.owner_tip, ed.toccc3(3614499), 1.5)
  ed.setLabelString(ui.name_label, equipTbl["Equip Name"])
  local master = equipInfo._carried_hero_id
  if master ~= nil and 0 < master then
    local boundLab = ed.createLabelTTF(T("\229\183\178\231\187\145\229\174\154"), 15)
    ed.setLabelStroke(boundLab, ed.toccc3(2565412), 1.5)
    ed.UITool.replaceUINew(ui, "owner_tip", boundLab)
    local head = ed.readhero.createIconByHero(ed.player:getHero(master), {length = 38}).icon
    ed.UITool.replaceUINew(ui, "add_tag", head)
  end
  local equipIcon = ed.readequip.createLegendEquipIcon(equipInfo)
  ui.icon:addChild(equipIcon)
  local nextUnequipTime = equipInfo._next_unequip_time
  local serverTime = ed.getServerTime()
  if nextUnequipTime and nextUnequipTime > serverTime then
    local timeBg = ed.legendEquipTool.createUnBindTimeMask(nextUnequipTime)
    equipIcon:addChild(timeBg)
    timeBg:setPosition(ccp(45, 70))
  end
  local image_red = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
  equipIcon:addChild(image_red, 10)
  image_red:setPosition(ccp(15, 80))
  self.redPointMgr:registerValueChange("new_legend_equip_" .. equipInfo._id, self.equipListRedRefer, {
    force = true,
    handle = function(value)
      if not tolua.isnull(image_red) then
        image_red:setVisible(0 < value)
      end
    end
  })
  return container, ui
end

function class:createOnlyOneSeq(width)
  local container = CCNode:create()
  container:setContentSize(CCSizeMake(width, 50))
  local bg = ed.createSprite("UI/alpha/1080P/fireforge/bag/only_title.png")
  local txt = ed.createLabelTTF(T("\229\148\175\228\184\128\232\163\133\229\164\135"), 15)
  ed.setLabelColor(txt, ed.toccc3(16775789))
  ed.setLabelStroke(txt, ed.toccc3(11357460), 1.5)
  container:addChild(bg)
  ed.layout.centerInParent(bg)
  container:addChild(txt)
  ed.layout.centerInParent(txt)
  ed.UITool.setPositionBy(bg, ccp(0, -10))
  ed.UITool.setPositionBy(txt, ccp(0, -9))
  return container, nil
end

function class:createCommonSeq(width)
  local container = CCNode:create()
  container:setContentSize(CCSizeMake(width, 30))
  local bg = ed.createSprite("UI/alpha/1080P/fireforge/bag/normal_title.png")
  local txt = ed.createLabelTTF(T("\230\153\174\233\128\154\232\163\133\229\164\135"), 15)
  ed.setLabelColor(txt, ed.toccc3(15384466))
  ed.setLabelStroke(txt, ed.toccc3(3807759), 1.5)
  container:addChild(bg)
  ed.layout.centerInParent(bg)
  container:addChild(txt)
  ed.layout.centerInParent(txt)
  ed.UITool.setPositionBy(txt, ccp(0, 1))
  return container, nil
end

function class:createFragmentItem(data)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.package_fragment)
  ed.setLabelStroke(ui.label_percent, ed.toccc3(2565412), 1)
  local icon = ed.readequip.createIcon(data.fragmentId)
  icon:setPositionY(13)
  icon:setAnchorPoint(ccp(0, 0))
  container:addChild(icon)
  ui.percent:setPositionX(ui.percent:getPositionX())
  local isOnly = data.isOnly
  local canCompose = data.canCompose
  local selectFrame = ed.createSprite("UI/alpha/1080P/package/fragment_selected.png")
  selectFrame:setAnchorPoint(ccp(0, 0))
  selectFrame:setPosition(ccp(-4.5, -5.5))
  selectFrame:setVisible(false)
  icon:addChild(selectFrame)
  local needAmount = data.needAmount
  ed.setString(ui.label_percent, string.format("%d/%d", data.fragmentAmount, needAmount))
  local scale = math.min(1, data.fragmentAmount / needAmount)
  if scale == 1 and canCompose then
    local iconCanCompose = ed.createSprite("UI/alpha/1080P/package/selected.png")
    iconCanCompose:setPosition(25, 25)
    iconCanCompose:setScale(0.7)
    icon:addChild(iconCanCompose)
  end
  local legendEquip = self.mgr:getLegendEquipByTypeId(data.equipId)[1]
  if isOnly and not canCompose and legendEquip then
    ed.setString(ui.label_percent, data.fragmentAmount)
    ed.setTexture(ui.percent, "UI/alpha/1080P/fireforge/bag/fragmentnum_board1.png")
  else
    ed.setString(ui.label_percent, string.format("%d/%d", data.fragmentAmount, needAmount))
    ui.percent:setScaleX(scale)
  end
  container.bg = icon
  self.selectCellUI[data.dataInd] = selectFrame
  return container, ui
end

function class:registerEvents()
  ed.UITool.registerBtn(self, "btn_equip", function()
    self:showEquipLayer()
  end)
  ed.UITool.registerBtn(self, "btn_fragment", function()
    self:showFragmentLayer()
  end)
  ed.UITool.registerBtn(self, "button_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  for i = 1, 3 do
    self:btRegisterRectClick({
      rect = CCRectMake(0, 0, 125, 35),
      parent = self.ui["btn_" .. i .. "_selected"],
      clickHandler = function()
        self.equipIndex = i
        self:showEquipTag()
      end,
      priority = ed.ui.commonscene.TOUCH_PRIORITY
    })
  end
  ed.UITool.registerBtn(self, "btn_fusion", function()
    if not self.fragmentData or not self.composeFragmentStatus then
      return
    end
    local info = self.fragmentData[self.showFragmentId]
    if self.composeFragmentStatus == "Pass" then
      if info.needAmount > info.fragmentAmount then
        ed.showToast(T("\231\162\142\231\137\135\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\229\144\136\230\136\144\239\188\129"))
        return
      end
      ed.legendEquipNet.sendFragmentCompose({
        {
          _id = info.equipId,
          _amount = 1
        }
      })
    elseif self.composeFragmentStatus == "Lock" then
      ed.showToast(T("\230\175\143\231\167\141\229\148\175\228\184\128\232\163\133\229\164\135\239\188\140\231\142\169\229\174\182\229\143\170\232\131\189\230\139\165\230\156\137\228\184\128\228\187\182\230\149\180\232\163\133\239\188\140\229\137\169\228\189\153\231\162\142\231\137\135\228\187\133\229\143\175\231\148\168\230\157\165\229\141\135\230\152\159"))
    elseif self.composeFragmentStatus == "Sale" then
      local soldWin = ed.ui.FragmentSoldoutWin.create({
        id = info.fragmentId,
        equipId = info.equipId,
        callback = function()
        end
      })
      soldWin:popWindow()
    end
  end, {pressScale = 0.95})
  local fusionSize = self.ui.btn_fusion_all:getContentSize()
  self:btRegisterRectClick({
    rect = CCRectMake(0, 0, fusionSize.width, fusionSize.height),
    parent = self.ui.btn_fusion_all,
    pressHandler = function()
      self.ui.btn_fusion_all:setScale(0.95)
    end,
    cancelPressHandler = function()
      self.ui.btn_fusion_all:setScale(1)
    end,
    clickHandler = function()
      if self.curLayerIndex == 1 or not self.ui.btn_fusion_all:isVisible() then
        return
      end
      self.ui.btn_fusion_all:setScale(1)
      if not self.fragmentData then
        return
      end
      if #self.fragmentData == 0 then
        ed.showToast(T("\230\151\160\229\143\175\229\144\136\230\136\144\231\162\142\231\137\135"))
        return
      end
      local canComposeList = {}
      for _, info in pairs(self.fragmentData) do
        if info.canCompose then
          table.insert(canComposeList, info)
        end
      end
      ed.ui.FireForgeComposeWin.create({canComposeList = canComposeList}):popWindow()
    end,
    priority = ed.ui.commonscene.TOUCH_PRIORITY
  })
  self:listenEvent("ChangeLegendEquip", function()
    if self.curLayerIndex == 1 then
      self.layerIndex = self.curLayerIndex
      self.curLayerIndex = nil
      self:showEquipLayer()
    end
  end)
  self:listenEvent("UpdateFireForgePackage", function()
    if self.curLayerIndex == 2 then
      self.layerIndex = self.curLayerIndex
      self.curLayerIndex = nil
      self:showFragmentLayer()
    end
  end)
end

function class:onPopScene()
  if self.redPointMgr then
    self.redPointMgr:unregisterAllValueChange(self.equipListRedRefer)
  end
  base.onPopScene(self)
end

function class:onEnter()
  base.onEnter(self)
  if self.curLayerIndex == 2 then
    self.layerIndex = self.curLayerIndex
    self.curLayerIndex = nil
    self:showFragmentLayer()
  end
end

local strRule = T("\232\167\132\229\136\153")

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\232\175\180\230\152\142"),
    txt = strRule
  }):popWindow()
end
