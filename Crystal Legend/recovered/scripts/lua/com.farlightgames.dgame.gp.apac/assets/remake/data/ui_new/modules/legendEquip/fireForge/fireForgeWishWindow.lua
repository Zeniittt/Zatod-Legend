local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fireForgeWishWindow = class
class.tips = T("\233\148\187\233\128\160\229\135\186\230\149\180\232\163\133\230\151\182\239\188\140\229\191\133\229\174\154\228\184\186\230\137\128\233\128\137\232\163\133\229\164\135\227\128\130<lable color=ccc3(255,114,44)>\229\148\175\228\184\128\232\163\133\229\164\135</lable>\230\175\143\229\145\168\231\148\159\230\149\136<lable color=ccc3(255,114,44)>1</lable>\230\172\161\239\188\140<lable color=ccc3(255,114,44)>\230\153\174\233\128\154\232\163\133\229\164\135</lable>\230\175\143\229\145\168\231\148\159\230\149\136<lable color=ccc3(255,114,44)>3</lable>\230\172\161\239\188\136\229\143\175\233\135\141\229\164\141\239\188\137")
ed.UITool.registViewOpenFunc("fireForgeWishWindow", function(param)
  local window = ed.ui.fireForgeWishWindow.create(param)
  window:popWindow()
  window:show()
end)

function class.create(param)
  local self = base.create("fireForgeWishWindow")
  setmetatable(self, class.mt)
  self:init(param or {})
  return self
end

function class:init(param)
  self.closeCallback = param.closeCallback
  self.selectOnlyEquipId = 0
  self.selectOnlyEquipIsSuccess = nil
  self.selectNormalEquipInfo = {}
  self.equipItemList = {}
  self.mgr = ed.legendEquipMgr.getInstance()
  self:initData()
  self:initView()
  self:refreshUI()
  self:addTouchEvent()
  self:addEventListen()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
end

function class:initData()
  if self.mgr:checkNewLegendEquip("FireForgeWishWindow") then
    self.newLegendEquipTypeList = self.mgr:getNewLegendEquipTypeList()
    self.mgr:saveNewLegendEquipTypeList("FireForgeWishWindow")
  else
    self.newLegendEquipTypeList = {}
  end
  local onlyWishList = self.mgr:getWishByType("only")
  if onlyWishList then
    local wishInfo = onlyWishList[1]
    local equipId = wishInfo._equip_id
    local isSuccess = wishInfo._is_success == 1
    self.selectOnlyEquipId = equipId
    self.selectOnlyEquipIsSuccess = isSuccess
  end
  local normalWishList = self.mgr:getWishByType("normal")
  for _, normalWishInfo in ipairs(normalWishList or {}) do
    local index = normalWishInfo._index
    local equipId = normalWishInfo._equip_id
    local isSuccess = normalWishInfo._is_success == 1
    self.selectNormalEquipInfo[index] = {
      index = index,
      equipId = equipId or 0,
      isSuccess = isSuccess
    }
  end
end

function class:show()
  local bgSize = self.ui.image_bg:getContentSize()
  local endPosX, endPosY = self.ui.image_bg:getPosition()
  local startPosY = ed.display.winSize.height + bgSize.height
  self.ui.image_bg:setPositionY(startPosY)
  local move1 = CCEaseBackOut:create(CCMoveBy:create(0.4, ccp(0, endPosY - startPosY)))
  self.ui.image_bg:runAction(move1)
end

function class:showDestroyAnim()
  if self.closeCallback then
    self.closeCallback()
  end
  local bgSize = self.ui.image_bg:getContentSize()
  local move = CCEaseBackIn:create(CCMoveBy:create(0.4, ccp(0, ed.display.winSize.height + bgSize.height)))
  local call = CCCallFunc:create(function()
    self:destroy({skipAnim = true})
  end)
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(move, call)))
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.fire_forge_wish_window)
  self.container:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initLabels()
  self:initDragList()
  self:refreshDragList()
  local panelSize = self.ui.panel_tips:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = self.tips,
    maxWidth = panelSize.width,
    fontSize = 15,
    color = ed.toccc3(13410648),
    strokeColor = ed.toccc3(2298379),
    strokeSize = 1
  })
  self.ui.panel_tips:addChild(autoText.node)
  autoText.node:setPosition(ccp(0, panelSize.height / 2))
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_save, ed.toccc3(10572575), 1)
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(9056284), 1)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  ed.setLabelStroke(self.ui.label_select_title, ed.toccc3(9056284), 1)
  ed.setLabelFontName(self.ui.label_select_title, ed.fontBold)
  ed.setLabelStroke(self.ui.label_wishlist_only_title, ed.toccc3(3415315), 1)
  ed.setLabelStroke(self.ui.label_wishlist_normal_title, ed.toccc3(2298379), 1)
end

function class:adaptUI()
  self.ui.image_chain_left:setZOrder(-1)
  self.ui.image_chain_right:setZOrder(-1)
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    priority = -300,
    doPressIn = function(x, y)
      for index, item in ipairs(self.equipItemList) do
        if ed.containsPoint(item, x, y) then
          item:setScale(0.75)
          return item
        end
      end
    end,
    doClickIn = function(x, y, item)
      self:onClickEquipItem(x, y, item)
    end,
    cancelPressIn = function(x, y, item)
      item:setScale(0.8)
    end
  })
end

function class:refreshUI()
  self:refreshWishList()
  self:refreshDragList()
end

function class:refreshWishList()
  do
    local equipId = self.selectOnlyEquipId
    local isSuccess = self.selectOnlyEquipIsSuccess
    if self.selectOnlyEquipIcon then
      self.selectOnlyEquipIcon:removeFromParentAndCleanup(true)
      self.selectOnlyEquipIcon = nil
    end
    if equipId and 0 < equipId then
      local icon = self:createWishEquipIcon(equipId, isSuccess)
      self.ui.image_wish_only_equip:addChild(icon)
      icon:setPosition(ccp(45, 45))
      self.selectOnlyEquipIcon = icon
    end
  end
  for _, normalEquipInfo in pairs(self.selectNormalEquipInfo or {}) do
    local index = normalEquipInfo.index
    local equipId = normalEquipInfo.equipId
    local isSuccess = normalEquipInfo.isSuccess
    local targetNode = self.ui["image_wish_normal_equip_" .. index]
    local icon = self["selectNormalEquipIcon" .. index]
    if icon then
      icon:removeFromParentAndCleanup(true)
      icon = nil
    end
    if equipId and 0 < equipId then
      icon = self:createWishEquipIcon(equipId, isSuccess)
      targetNode:addChild(icon)
      icon:setPosition(ccp(45, 45))
    end
    self["selectNormalEquipIcon" .. index] = icon
  end
end

function class:createWishEquipIcon(equipId, isSuccess)
  local icon = ed.readequip.createBasicLegendEquipIcon(equipId)
  if isSuccess then
    ed.legendEquipTool.createSuccessMask(icon)
  end
  local btn_reduce = ed.createSprite("UI/alpha/1080P/soulexchange/soulexchange_minus.png")
  icon:addChild(btn_reduce)
  btn_reduce:setPosition(ccp(71, 73))
  return icon
end

function class:onClickEquipItem(x, y, item)
  local legendEquipCfg = item.legendEquipCfg
  local equipId = legendEquipCfg["Equip ID"]
  local isOnly = legendEquipCfg["Is Only"]
  if isOnly then
    if self.selectOnlyEquipId == equipId or self.selectOnlyEquipIsSuccess then
      return
    end
    self.selectOnlyEquipId = equipId
  else
    for index, normalEquipInfo in pairs(self.selectNormalEquipInfo) do
      local isSuccess = normalEquipInfo.isSuccess
      if not isSuccess and normalEquipInfo.equipId == 0 then
        normalEquipInfo.equipId = equipId
        break
      end
    end
  end
  self:refreshUI()
end

function class:refreshDragList()
  self.onlyEquipList = {}
  self.normalEquipList = {}
  for id, legendEquipCfg in pairs(ed.getDataTable("LegendEquip")) do
    if legendEquipCfg["Is Only"] then
      table.insert(self.onlyEquipList, legendEquipCfg)
    else
      table.insert(self.normalEquipList, legendEquipCfg)
    end
  end
  table.sort(self.onlyEquipList, function(a, b)
    return a["Equip ID"] < b["Equip ID"]
  end)
  table.sort(self.normalEquipList, function(a, b)
    return a["Equip ID"] < b["Equip ID"]
  end)
  local oldPosX, oldPosY = self.dragList:getListPos()
  self.dragList:clearList()
  self.equipItemList = {}
  local panelSize = self.ui.panel_list:getContentSize()
  local totalHeight = 0
  local onlyEquipPanel, onlyEquipPanelSize = self:createOnlyEquipPanel()
  onlyEquipPanel:setPosition(ccp(panelSize.width / 2, panelSize.height - totalHeight))
  totalHeight = totalHeight + onlyEquipPanelSize.height
  self.dragList:addItem(onlyEquipPanel)
  local normalEquipPanel, normalEquipPanelSize = self:createNormalEquipPanel()
  normalEquipPanel:setPosition(ccp(panelSize.width / 2, panelSize.height - totalHeight))
  totalHeight = totalHeight + normalEquipPanelSize.height
  self.dragList:addItem(normalEquipPanel)
  self.dragList:initListHeight(onlyEquipPanelSize.height + normalEquipPanelSize.height)
  if 0 < oldPosY then
    self.dragList:setListPos(ccp(oldPosX, oldPosY))
  end
end

function class:createOnlyEquipPanel()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/fireforge/wishlist/choose.png", CCRectMake(148, 50, 148, 160))
  bg:setAnchorPoint(ccp(0.5, 1))
  local colLimit = 6
  local itemSize = CCSizeMake(72, 72)
  local panelSize = CCSizeMake(444.5, 50 + math.ceil(#self.onlyEquipList / colLimit) * itemSize.height)
  bg:setContentSize(panelSize)
  local labelTitle = ed.createLabelTTF(T("\229\148\175\228\184\128\232\163\133\229\164\135"), 16)
  ed.setLabelColor(labelTitle, ccc3(228, 127, 37))
  ed.setLabelStroke(labelTitle, ed.toccc3(3415315), 1)
  bg:addChild(labelTitle)
  labelTitle:setPosition(ccp(225, panelSize.height - 13))
  local offsetX, offsetY = 10, panelSize.height - 70
  local posX, posY = 0, 0
  for index, legendEquipCfg in ipairs(self.onlyEquipList) do
    local item = self:createEquipItem(legendEquipCfg)
    table.insert(self.equipItemList, item)
    bg:addChild(item)
    item:setPosition(ccp(offsetX + posX + itemSize.width / 2, offsetY + posY))
    posX = posX + itemSize.width - 2
    if index % colLimit == 0 then
      posY = posY - itemSize.height
      posX = 0
    end
  end
  return bg, panelSize
end

function class:createNormalEquipPanel()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/fireforge/wishlist/choose.png", CCRectMake(148, 50, 148, 150))
  bg:setAnchorPoint(ccp(0.5, 1))
  local colLimit = 6
  local itemSize = CCSizeMake(72, 72)
  local panelSize = CCSizeMake(444.5, 50 + math.ceil(#self.normalEquipList / colLimit) * itemSize.height)
  bg:setContentSize(panelSize)
  local labelTitle = ed.createLabelTTF(T("\230\153\174\233\128\154\232\163\133\229\164\135"), 16)
  ed.setLabelColor(labelTitle, ccc3(204, 162, 88))
  ed.setLabelStroke(labelTitle, ed.toccc3(2298379), 1)
  bg:addChild(labelTitle)
  labelTitle:setPosition(ccp(225, panelSize.height - 13))
  local offsetX, offsetY = 10, panelSize.height - 70
  local posX, posY = 0, 0
  for index, legendEquipCfg in ipairs(self.normalEquipList) do
    local item = self:createEquipItem(legendEquipCfg)
    table.insert(self.equipItemList, item)
    bg:addChild(item)
    item:setPosition(ccp(offsetX + posX + itemSize.width / 2, offsetY + posY))
    posX = posX + itemSize.width - 2
    if index % colLimit == 0 then
      posY = posY - itemSize.height
      posX = 0
    end
  end
  return bg, panelSize
end

function class:createEquipItem(legendEquipCfg)
  local equipId = legendEquipCfg["Equip ID"]
  local isOnly = legendEquipCfg["Is Only"]
  local isSelect = false
  local amount = 0
  if isOnly then
    isSelect = equipId == self.selectOnlyEquipId
  else
    for index, normalEquipInfo in pairs(self.selectNormalEquipInfo) do
      if equipId == normalEquipInfo.equipId then
        amount = amount + 1
      end
    end
    isSelect = 0 < amount
  end
  local icon, _, labelAmount = ed.readequip.createBasicLegendEquipIcon(equipId, 2)
  ed.setLabelString(labelAmount, 0 < amount and "x" .. amount or "")
  icon:setScale(0.8)
  local isNew = ed.isElementInTable(equipId, self.newLegendEquipTypeList)
  if isNew then
    local imageNew = ed.createSprite("UI/alpha/1080P/summon/hero_new_tag.png")
    icon:addChild(imageNew)
    imageNew:setPosition(ccp(20, 80))
  end
  icon.legendEquipCfg = legendEquipCfg
  return icon
end

function class:onClickOnlyEquip()
  if self.selectOnlyEquipIsSuccess then
    ed.showToast(T("\230\156\172\229\145\168\229\183\178\231\148\159\230\149\136"))
    return
  end
  self.selectOnlyEquipId = 0
  self:refreshUI()
end

function class:onClickNormalEquip(index)
  local normalEquipInfo = self.selectNormalEquipInfo[index]
  if normalEquipInfo.isSuccess then
    ed.showToast(T("\230\156\172\229\145\168\229\183\178\231\148\159\230\149\136"))
    return
  end
  normalEquipInfo.equipId = 0
  self:refreshUI()
end

function class:onClickBtnSave()
  if not self.selectOnlyEquipIsSuccess and self.selectOnlyEquipId then
    ed.legendEquipNet.sendSetWish("only", {
      {
        _index = 1,
        _equip_id = self.selectOnlyEquipId
      }
    })
  end
  local wishList = {}
  for index, normalEquipInfo in pairs(self.selectNormalEquipInfo) do
    local isSuccess = normalEquipInfo.isSuccess
    local equipId = normalEquipInfo.equipId
    if not normalEquipInfo.isSuccess then
      table.insert(wishList, {_index = index, _equip_id = equipId})
    end
  end
  if #wishList then
    ed.legendEquipNet.sendSetWish("normal", wishList)
  end
  self:showDestroyAnim()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "image_wish_only_equip", function()
    self:onClickOnlyEquip()
  end, {normalScale = 0.8, pressScale = 0.75})
  for index = 1, ed.legendEquipDefine.Wish_Normal_Equip_Amount do
    ed.UITool.registerBtn(self, "image_wish_normal_equip_" .. index, function()
      self:onClickNormalEquip(index)
    end, {normalScale = 0.8, pressScale = 0.75})
  end
  ed.UITool.registerBtn(self, "btn_close", function()
    self:showDestroyAnim()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_save", function()
    self:onClickBtnSave()
  end, {pressScale = 0.95})
end

function class:addEventListen()
end
