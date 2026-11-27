local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueCharmBagScene = class
local CardWidth = 106
local CardHeight = 141.5
local CardSpaceX = 16.5
local CardSpaceY = 13
local CardPaddingX = 50
local CardPaddingY = 5
local threshold = 1.0E-4
local SelectedWidth = 96.5
local SelectedSpaceX = 0
ed.UITool.registViewOpenFunc("rogueCharmBagScene", function(param)
  local scene = ed.ui.rogueCharmBagScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueCharmBagScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.cardColumnNum = 0
  self.bookId = param.bookId or 1
  local bookTableItem = ed.getDataTable("RogueBook")[self.bookId]
  self.chapterId = bookTableItem["Chapter Group"]
  self.curSelectedIndex = -1
  self.maxWeightVal = 5
  self.curWeightVal = 0
  self.isOverweightEffectPlaying = false
  self.isShowActionPlaying = false
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.ui.img_charm_info:setVisible(false)
  self.ui.img_light_bg:setVisible(false)
  ed.rogueLikeNet.sendQueryCharm(self.chapterId)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCharmBagScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  local _, titleTxt = ed.UITool.createSceneTitle(T("\230\138\164\231\172\166\231\154\174\232\162\139"), self.ui.img_title_bg, {
    position = ccp(13, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self.ui.img_weight_bar:setVisible(false)
  self.ui.img_overweight_light:setVisible(false)
  self.ui.img_overweight_tip_bg:setVisible(false)
  self.ui.img_empty_arrow:setOpacity(76.5)
  self.selectedCharmHeartImgArr = {}
  self.selectedCharmHeartSpaceArr = {}
  for i = 1, 999 do
    local img = self.ui["img_charm_heart_" .. i]
    if nil == img then
      break
    end
    table.insert(self.selectedCharmHeartImgArr, img)
    table.insert(self.selectedCharmHeartSpaceArr, 5)
  end
  self:initLabels()
  self:adaptUI()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onRuleEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_equip", function()
    self:onClickBtnEquip()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("rogueQueryCharm", function(data)
    self:parseCharmData(data)
    self.ui.img_charm_info:setVisible(true)
    self.ui.img_light_bg:setVisible(true)
    self:refreshCharmList()
    self:refreshBagList(false)
    self:refreshCharmInfo()
    self:refreshBtnEquip()
    self:playShowAction()
  end)
end

function class:initLabels()
  ed.setLabelString(self.ui.label_empty_des, T("\232\175\183\228\187\142\228\184\139\230\150\185\233\128\137\230\139\169\230\138\164\231\172\166\229\161\171\229\133\165\231\154\174\232\162\139\n\230\130\168\229\143\175\228\187\165\229\141\135\231\186\167\230\132\159\230\130\159\231\172\148\232\174\176\228\187\165\230\143\144\229\141\135\232\180\159\233\135\141\228\184\138\233\153\144"))
  ed.setLabelStroke(self.ui.label_empty_des, ed.toccc3(8456926), 1)
  ed.setLabelFontName(self.ui.label_charm_max, ed.fontBold)
  ed.setLabelStroke(self.ui.label_charm_max, ed.toccc3(6817970), 1)
  ed.setLabelFontName(self.ui.label_charm_name, ed.fontBold)
  ed.setLabelStroke(self.ui.label_charm_name, ed.toccc3(4267185), 1)
  ed.setLabelStroke(self.ui.label_charm_weight, ed.toccc3(263719), 1)
  ed.setLabelDimensions(self.ui.label_charm_unlock, CCSizeMake(200, 0))
  ed.setLabelStroke(self.ui.label_equip, ed.toccc3(3013), 1)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.img_title_bg, {left = 80, top = 21}, false, true)
  self.cardColumnNum = 6
  local charmInfoBgPosX = self.ui.img_charm_info:getPositionX()
  local charmInfoBgWidth = self.ui.img_charm_info:getContentSize().width
  local leftAlphaWidth, rightAlphaWidth = 100, 60
  local charmListPosX = self.ui.panel_charm_list:getPositionX()
  local charmListSize = self.ui.panel_charm_list:getContentSize()
  local realWidth = ed.display.fixDesignSize.width
  local contentWidth = charmInfoBgPosX + charmInfoBgWidth * 0.5 - rightAlphaWidth - charmListPosX
  if contentWidth > realWidth - 60 then
    contentWidth = contentWidth - CardWidth - CardSpaceX
    self.cardColumnNum = 5
  end
  charmListSize.width = CardWidth * self.cardColumnNum + CardSpaceX * (self.cardColumnNum - 1) + CardPaddingX * 2
  self.ui.panel_charm_list:setContentSize(charmListSize)
  local posX = (self.ui.image_bg:getContentSize().width - contentWidth) * 0.5
  self.ui.panel_charm_list:setPositionX(posX - CardPaddingX)
  self.ui.img_light_bg:setPositionX(posX - 12 + self.ui.img_light_bg:getContentSize().width * 0.5)
  self.ui.img_charm_info:setPositionX(posX + contentWidth + rightAlphaWidth - charmInfoBgWidth * 0.5)
  local emptyPosX = charmListSize.width * 0.5 + 12 - CardPaddingX
  self.ui.img_empty_arrow:setPositionX(emptyPosX)
  self.ui.label_empty_des:setPositionX(emptyPosX)
  local selectedListSize = self.ui.panel_selected_list:getContentSize()
  selectedListSize.width = self.ui.img_charm_info:getPositionX() - charmInfoBgWidth * 0.5 + leftAlphaWidth - (posX - 12) - self.ui.panel_selected_list:getPositionX() - 40
  self.ui.panel_selected_list:setContentSize(selectedListSize)
end

function class:parseCharmData(data)
  self.maxWeightVal = data._weight or 5
  local tmpTab = {}
  for i, v in ipairs(data._charm_list or {}) do
    tmpTab[v._charm_id] = v
  end
  self.charmDataList = {}
  local bookTableItem = ed.getDataTable("RogueBook")[self.bookId]
  local charmList = bookTableItem["Charm List"] or {}
  for i, v in ipairs(charmList) do
    local data = {_charm_id = v}
    if nil ~= tmpTab[v] then
      data._exp = tmpTab[v]._exp
      data._progress = tmpTab[v]._progress or 0
    else
      data._exp = nil
      data._progress = 0
    end
    table.insert(self.charmDataList, data)
  end
  local charmTable = ed.getDataTable("RogueCharm")
  local lastIdList = self.rogueLikeMgr:getCharmIdListFromBag(self.bookId)
  local availableIdList = {}
  local weightVal = 0
  for i, v in ipairs(lastIdList) do
    if not self:checkIsUnlock(tmpTab[v]) then
      print("========================", v, "\232\191\152\230\156\170\232\167\163\233\148\129========================")
    else
      local charmTableItem = charmTable[v]
      weightVal = weightVal + charmTableItem.Weight
      if weightVal > self.maxWeightVal then
        weightVal = weightVal - charmTableItem.Weight
        print("========================", v, "\232\182\133\233\135\141\228\186\134========================")
      else
        table.insert(availableIdList, v)
      end
    end
  end
  self.selectedIdList = availableIdList
  table.sort(self.charmDataList, function(a, b)
    local unlockFlagA = self:checkIsUnlock(a) and 0 or 1
    local unlockFlagB = self:checkIsUnlock(b) and 0 or 1
    return unlockFlagA < unlockFlagB or unlockFlagA == unlockFlagB and a._charm_id < b._charm_id
  end)
end

function class:checkIsUnlock(charmData)
  if nil == charmData then
    return false
  end
  return nil ~= charmData._exp
end

function class:getPressInHandler()
  local function handler(x, y)
    for k, v in ipairs(self.charmUIArr) do
      if not tolua.isnull(v.bg) and ed.containsPoint(v.bg, x, y) then
        v.bg:setScale(0.95)
        
        return v, k
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, ui, index)
    if self.isOverweightEffectPlaying or self.isShowActionPlaying then
      return
    end
    if self.curSelectedIndex == index then
      return
    end
    self.curSelectedIndex = index
    self:refreshCharmInfo()
    self:refreshBtnEquip()
  end
  
  return handler
end

function class:getCancelPressInHandler()
  local function handler(x, y, ui)
    if ui and not tolua.isnull(ui.bg) then
      ui.bg:setScale(1)
    end
  end
  
  return handler
end

function class:getCharmListItemPos(i)
  local size = self.ui.panel_charm_list:getContentSize()
  local ox = (size.width - ((CardWidth + CardSpaceX) * self.cardColumnNum - CardSpaceX)) * 0.5
  local oy = size.height
  local columnIndex = (i - 1) % self.cardColumnNum + 1
  local rowIndex = math.ceil(i / self.cardColumnNum - threshold)
  local dx = ox + (columnIndex - 0.5) * CardWidth + (columnIndex - 1) * CardSpaceX
  local dy = oy - (rowIndex - 0.5) * CardHeight - (rowIndex - 1) * CardSpaceY - CardPaddingY
  return ccp(dx, dy)
end

function class:getCharmListHeight(num)
  local rowNum = math.ceil(num / self.cardColumnNum - threshold)
  return (CardHeight + CardSpaceY) * rowNum - CardSpaceY + CardPaddingY
end

function class:createCharmItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.rogueCharmBagCardItem)
  ed.setLabelStroke(ui.label_lock, ed.toccc3(4853792), 1)
  ed.setLabelStroke(ui.label_weight, ed.toccc3(263719), 1)
  ui.label_weight:setVisible(false)
  ui.heartImgArr = {}
  ui.heartSpaceArr = {}
  for i = 1, 999 do
    local img = ui["img_heart_" .. i]
    if nil == img then
      break
    end
    table.insert(ui.heartImgArr, img)
    table.insert(ui.heartSpaceArr, 5)
  end
  self:refreshCharmItem(ui, data)
  ed.setCascadeOpacityEnabled(ui.bg, true, true)
  return container, ui
end

function class:refreshCharmItem(ui, data)
  local isUnlock = self:checkIsUnlock(data)
  if ui.img_mask:isVisible() == isUnlock then
    ui.img_mask:setVisible(not isUnlock)
    ed.setTexture(ui.bg, isUnlock and "UI/alpha/1080P/rogue/charm/charm_normal_bg.png" or "UI/alpha/1080P/rogue/charm/charm_lock_bg.png")
    ui.label_weight:setVisible(isUnlock)
  end
  local charmTableItem = ed.getDataTable("RogueCharm")[data._charm_id]
  ed.setTexture(ui.img_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  if isUnlock then
    ed.setLabelString(ui.label_weight, charmTableItem.Weight)
    local starNum = self.rogueLikeMgr:getCharmStarNum(data._exp, charmTableItem)
    for i, v in ipairs(ui.heartImgArr) do
      v:setVisible(i <= starNum)
    end
    ed.layout.horizontalSortNode(ui.heartImgArr, ui.heartSpaceArr, ui.bg:getContentSize().width * 0.5)
  else
    for i, v in ipairs(ui.heartImgArr) do
      v:setVisible(false)
    end
  end
end

function class:refreshCharmList()
  if nil == self.charmDraglist then
    local contentSize = self.ui.panel_charm_list:getContentSize()
    self.charmDraglist = ed.UITool.createDraglist(self.ui.panel_charm_list, {
      priority = -300,
      doPressIn = self:getPressInHandler(),
      doClickIn = self:getClickInHandler(),
      cancelPressIn = self:getCancelPressInHandler(),
      bar = {
        bglen = contentSize.height - 100,
        bgpos = ccp(contentSize.width + 20 - CardPaddingX, contentSize.height / 2 + 50),
        barres = "UI/alpha/1080P/rogue/charm/charm_slide_1.png",
        bgres = "UI/alpha/1080P/rogue/charm/charm_slide_2.png"
      }
    })
  else
    self.charmDraglist:clearList()
  end
  self.charmUIArr = {}
  for k, v in pairs(self.charmDataList) do
    local itemContainer, itemUI = self:createCharmItem(k, v)
    self.charmDraglist:addItem(itemContainer)
    itemContainer:setPosition(self:getCharmListItemPos(k))
    table.insert(self.charmUIArr, itemUI)
  end
  self.charmDraglist:initListHeight(self:getCharmListHeight(#self.charmUIArr))
  self:refreshCharmListSelectedState()
end

function class:refreshCharmListSelectedState()
  local tmpTab = {}
  for i, v in ipairs(self.selectedIdList) do
    tmpTab[v] = true
  end
  local t = 0
  for i, v in ipairs(self.charmUIArr) do
    if nil ~= v.fca_selected and v.fca_selected:isVisible() then
      t = v.fca_selected:getActionElapsed()
    end
  end
  for i, v in ipairs(self.charmDataList) do
    local ui = self.charmUIArr[i]
    if tmpTab[v._charm_id] then
      if nil == ui.fca_selected then
        ui.fca_selected = ed.createFcaNode("eff_UI_rogue_selected")
        self:addFca(ui.fca_selected)
        ui.bg:addChild(ui.fca_selected)
        ed.layout.centerInParent(ui.fca_selected)
      end
      ui.fca_selected:setVisible(true)
      if 0 < t then
        ui.fca_selected:setActionElapsed(t)
      end
    elseif nil ~= ui.fca_selected then
      ui.fca_selected:setVisible(false)
    end
  end
end

function class:createSelectedItem(index, charmId)
  local container, ui = ed.editorui(ed.uieditor.rogueCharmBagSelectedItem, {
    container = CCSprite:create()
  })
  ui.container = container
  ed.setCascadeOpacityEnabled(container, true, true)
  self:refreshSelectedItem(ui, charmId)
  return container, ui
end

function class:refreshSelectedItem(ui, charmId)
  ui.bg:setVisible(true)
  local charmTableItem = ed.getDataTable("RogueCharm")[charmId]
  ed.setTexture(ui.img_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  ui.data = {}
  ui.data.charmId = charmId
  ui.data.weight = charmTableItem.Weight
end

function class:getSelectedListItemPos(index)
  local size = self.ui.panel_selected_list:getContentSize()
  local ox = 0
  local oy = size.height * 0.5
  local dx = ox + (index - 0.5) * SelectedWidth + (index - 1) * SelectedSpaceX
  return ccp(dx, oy)
end

function class:getSelectedListWidth(num)
  return (SelectedWidth + SelectedSpaceX) * num - SelectedSpaceX
end

function class:getPressSelectedInHandler()
  local function handler(x, y)
    for k, v in ipairs(self.selectedUIArr) do
      if not tolua.isnull(v.container) and ed.containsPoint(v.bg, x, y) then
        v.bg:setScale(0.95)
        
        return v, k
      end
    end
  end
  
  return handler
end

function class:getClickSelectedInHandler()
  local function handler(x, y, ui, index)
    if self.isOverweightEffectPlaying or self.isShowActionPlaying then
      return
    end
    table.remove(self.selectedIdList, index)
    self.rogueLikeMgr:saveCharmIdListToBag(self.bookId, self.selectedIdList)
    self:refreshBagList(true)
    self:refreshCharmListSelectedState()
    self:refreshBtnEquip()
  end
  
  return handler
end

function class:getCancelPressSelectedInHandler()
  local function handler(x, y, ui)
    if ui and not tolua.isnull(ui.bg) then
      ui.bg:setScale(1)
    end
  end
  
  return handler
end

function class:refreshBagList(isAction)
  local isEmpty = 0 == #self.selectedIdList
  self.ui.img_empty_arrow:setVisible(isEmpty)
  self.ui.label_empty_des:setVisible(isEmpty)
  if nil == self.selectedDraglist then
    local contentSize = self.ui.panel_selected_list:getContentSize()
    self.selectedDraglist = ed.UITool.createDraglist(self.ui.panel_selected_list, {
      priority = -300,
      doPressIn = self:getPressSelectedInHandler(),
      doClickIn = self:getClickSelectedInHandler(),
      cancelPressIn = self:getCancelPressSelectedInHandler()
    })
    self.selectedUIArr = {}
    self.selectedUICache = {}
  end
  self.curWeightVal = 0
  local oldUIArr = self.selectedUIArr
  self.selectedUIArr = {}
  local isExistAdd = false
  for selectedKey, selectedId in pairs(self.selectedIdList) do
    local itemUI
    for i = 1, #oldUIArr do
      if oldUIArr[i].data.charmId == selectedId then
        itemUI = oldUIArr[i]
        table.remove(oldUIArr, i)
        break
      end
    end
    local itemPos = self:getSelectedListItemPos(selectedKey)
    if nil == itemUI then
      isExistAdd = true
      if 0 == #self.selectedUICache then
        local container, ui = self:createSelectedItem(selectedKey, selectedId)
        self.selectedDraglist:addItem(container)
        itemUI = ui
      else
        itemUI = self.selectedUICache[1]
        table.remove(self.selectedUICache, 1)
        self:refreshSelectedItem(itemUI, selectedId)
        itemUI.container:stopAllActions()
        itemUI.container:setVisible(true)
      end
      if isAction then
        local fromPos = itemUI.container:getParent():convertToNodeSpace(self:getCharmCardPos(selectedId))
        local direction = {}
        direction[1] = itemPos.x - fromPos.x
        direction[2] = itemPos.y - fromPos.y
        direction = ed.edpNormalize(direction)
        itemUI.container:setPosition(itemPos.x - direction[1] * 40, itemPos.y - direction[2] * 40)
        local moveAction = CCSpawn:create(ccArrayMake(CCMoveTo:create(0.1, itemPos), CCFadeIn:create(0.1)))
        itemUI.container:runAction(moveAction)
      else
        itemUI.container:setPosition(itemPos)
      end
    else
      itemUI.container:stopAllActions()
      if isAction then
        itemUI.container:runAction(CCMoveTo:create(0.1, itemPos))
      else
        itemUI.container:setPosition(itemPos)
      end
    end
    table.insert(self.selectedUIArr, itemUI)
    self.curWeightVal = self.curWeightVal + itemUI.data.weight
  end
  for i, ui in ipairs(oldUIArr) do
    ui.container:stopAllActions()
    if isAction then
      local toPos = ui.container:getParent():convertToNodeSpace(self:getCharmCardPos(ui.data.charmId))
      local itemPos = ccp(ui.container:getPosition())
      local direction = {}
      direction[1] = itemPos.x - toPos.x
      direction[2] = itemPos.y - toPos.y
      direction = ed.edpNormalize(direction)
      local moveAction = CCMoveTo:create(0.1, ccp(itemPos.x - direction[1] * 40, itemPos.y - direction[2] * 40))
      moveAction = CCSpawn:create(ccArrayMake(moveAction, CCFadeOut:create(0.1)))
      moveAction = CCSequence:createWithTwoActions(moveAction, self:createHideAction(ui.container))
      ui.container:runAction(moveAction)
    else
      ui.container:setVisible(false)
    end
    table.insert(self.selectedUICache, ui)
  end
  local oldDragPos = ccp(self.selectedDraglist:getListPos())
  self.selectedDraglist:initListWidth(self:getSelectedListWidth(#self.selectedIdList))
  if isExistAdd then
    self.selectedDraglist:makePosRightMost()
  elseif oldDragPos then
    oldDragPos.x = math.max(oldDragPos.x, self.selectedDraglist.width - self.selectedDraglist.listWidth)
    oldDragPos.x = math.min(oldDragPos.x, 0)
    self.selectedDraglist:setListPos(oldDragPos)
  end
  self:refreshWeightView()
end

function class:createHideAction(node)
  return CCCallFunc:create(function()
    node:setVisible(false)
  end)
end

function class:refreshWeightView(...)
  if nil == self.weightProgressBar then
    self.weightProgressBar = CCProgressTimer:create(self.ui.img_weight_bar)
    self.weightProgressBar:setType(kCCProgressTimerTypeRadial)
    self.weightProgressBar:setReverseProgress(true)
    local bgSize = self.ui.img_bag_bg:getContentSize()
    self.ui.img_bag_bg:addChild(self.weightProgressBar)
    self.weightProgressBar:setPosition(bgSize.width * 0.5, bgSize.height * 0.5)
    self.weightProgressBar:setPercentage(self.curWeightVal / self.maxWeightVal * 100)
  else
    self.weightProgressBar:stopAllActions()
    self.weightProgressBar:runAction(CCProgressFromTo:create(0.2, self.weightProgressBar:getPercentage(), self.curWeightVal / self.maxWeightVal * 100))
  end
  if nil == self.bagWeightDesLabel then
    self.bagWeightDesLabel = ed.ui.autoText.new()
    self.ui.img_bag_bg:addChild(self.bagWeightDesLabel.node)
  end
  local weightStr = T("<lable color=ccc3(255,231,170) fontSize=f12 strokeSize=1 strokeColor=0x040627 name=desLabel>\232\180\159\233\135\141</lable><lable color=ccc3(255,252,231) fontSize=f15 strokeSize=1 strokeColor=0x3f2389 name=curLabel>%d/</lable><lable color=ccc3(255,231,170) fontSize=f15 strokeSize=1 strokeColor=0x040627 name=maxLabel>%d</lable>", self.curWeightVal, self.maxWeightVal)
  local weightBgSize = self.ui.img_bag_bg:getContentSize()
  self.bagWeightDesLabel:initParam({
    context = weightStr,
    maxWidth = weightBgSize.width
  })
  local desWidth, desHeight = self.bagWeightDesLabel:getCurContentSize()
  self.bagWeightDesLabel.node:setPosition(ccp((weightBgSize.width - desWidth) * 0.5, (weightBgSize.height + desHeight - self.bagWeightDesLabel:getFirstLineHeight()) * 0.5 - 25))
end

function class:refreshCharmInfo()
  if #self.charmDataList <= 0 then
    return
  end
  if 0 > self.curSelectedIndex then
    if 0 == #self.selectedIdList then
      self.curSelectedIndex = 1
    else
      local selectedId = self.selectedIdList[#self.selectedIdList]
      for i, v in ipairs(self.charmDataList) do
        if v._charm_id == selectedId then
          self.curSelectedIndex = i
          break
        end
      end
    end
  end
  local charmData = self.charmDataList[self.curSelectedIndex]
  local charmTableItem = ed.getDataTable("RogueCharm")[charmData._charm_id]
  local isUnlock = self:checkIsUnlock(charmData)
  ed.setLabelString(self.ui.label_charm_name, charmTableItem["Charm Name"])
  ed.setLabelString(self.ui.label_charm_weight, T("\233\135\141\233\135\143\239\188\154%s", isUnlock and charmTableItem.Weight or "?"))
  ed.setTexture(self.ui.img_charm_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  self.ui.img_charm_max:setVisible(isUnlock)
  self.ui.panel_charm_level_require:setVisible(isUnlock)
  self.ui.label_charm_unlock:setVisible(not isUnlock)
  local starNum = 1
  if isUnlock then
    starNum, _, nextRequire = self.rogueLikeMgr:getCharmStarNum(charmData._exp, charmTableItem)
    local isMaxLevel = starNum == #self.selectedCharmHeartImgArr
    self.ui.img_charm_max:setVisible(isMaxLevel)
    self.ui.panel_charm_level_require:setVisible(not isMaxLevel)
    if not isMaxLevel then
      if nil == self.levelRequireLabel then
        self.levelRequireLabel = ed.ui.autoText.new()
        self.ui.panel_charm_level_require:addChild(self.levelRequireLabel.node)
      end
      local lqDes = T("\229\134\141\233\128\154\232\191\135<lable color=ccc3(255,165,49) strokeColor=0x1e1d1a strokeSize=1>%s</lable>\228\184\170\230\136\191\233\151\180\229\141\135\231\186\167", nextRequire - charmData._exp)
      local lqBgSize = self.ui.panel_charm_level_require:getContentSize()
      self.levelRequireLabel:initParam({
        context = lqDes,
        fontSize = 22,
        color = ccc3(204, 206, 255),
        strokeColor = ed.toccc3(263719),
        strokeSize = 1,
        lineSpacing = 4,
        maxWidth = lqBgSize.width
      })
      local desWidth, desHeight = self.levelRequireLabel:getCurContentSize()
      self.levelRequireLabel.node:setPosition(ccp((lqBgSize.width - desWidth) * 0.5, (lqBgSize.height + desHeight - self.levelRequireLabel:getFirstLineHeight()) * 0.5))
    end
  else
    local unlockDes = charmTableItem["Unlock Des"]
    if string.find(unlockDes, "%%s") then
      unlockDes = string.format(unlockDes, charmTableItem["Unlock Target"] - charmData._progress)
    end
    ed.setLabelString(self.ui.label_charm_unlock, unlockDes)
  end
  for i, v in ipairs(self.selectedCharmHeartImgArr) do
    v:setVisible(starNum >= i)
  end
  ed.layout.horizontalSortNode(self.selectedCharmHeartImgArr, self.selectedCharmHeartSpaceArr, self.ui.img_charm_icon:getPositionX())
  if nil == self.charmDesLabel then
    self.charmDesLabel = ed.ui.autoText.new()
    if nil == self.charmDesDraglist then
      self.charmDesDraglist = ed.UITool.createDraglist(self.ui.panel_charm_des, {})
    end
    self.charmDesDraglist:addItem(self.charmDesLabel.node)
  end
  local charmDesStr = charmTableItem["Description " .. starNum] or ""
  local desBgSize = self.ui.panel_charm_des:getContentSize()
  self.charmDesLabel:initParam({
    context = charmDesStr,
    fontSize = 18,
    color = ccc3(249, 249, 235),
    maxWidth = desBgSize.width
  })
  local desWidth, desHeight = self.charmDesLabel:getCurContentSize()
  self.charmDesLabel.node:setPosition(ccp((desBgSize.width - desWidth) * 0.5, desBgSize.height - self.charmDesLabel:getFirstLineHeight() * 0.5))
  self.charmDesDraglist:initListHeight(desHeight)
end

function class:refreshBtnEquip()
  if self.curSelectedIndex < 0 then
    self.ui.btn_equip:setVisible(false)
    return
  end
  local charmData = self.charmDataList[self.curSelectedIndex]
  local isUnlock = self:checkIsUnlock(charmData)
  if isUnlock then
    self.ui.btn_equip:setVisible(true)
    local existIndex = -1
    for i, v in ipairs(self.selectedIdList) do
      if v == charmData._charm_id then
        existIndex = i
        break
      end
    end
    if 0 < existIndex then
      ed.setLabelString(self.ui.label_equip, T("\229\141\184\232\189\189"))
    else
      ed.setLabelString(self.ui.label_equip, T("\232\163\133\229\161\171"))
    end
  else
    self.ui.btn_equip:setVisible(false)
  end
end

function class:playOverweightEffect()
  self.isOverweightEffectPlaying = true
  ed.setTexture(self.ui.img_bag_bg, "UI/alpha/1080P/rogue/charm/charm_overweight_dec.png")
  ed.setTexture(self.ui.img_bag_icon, "UI/alpha/1080P/rogue/charm/charm_overweight_pocket.png")
  self.ui.img_overweight_light:setVisible(true)
  local lightAction = CCSpawn:create(ccArrayMake(CCScaleTo:create(0.8, 1.4), CCFadeTo:create(0.8, 0)))
  lightAction = CCSequence:create(ccArrayMake(CCCallFunc:create(function()
    self.ui.img_overweight_light:setScale(1)
    self.ui.img_overweight_light:setOpacity(255)
  end), lightAction, CCDelayTime:create(0.62)))
  self.ui.img_overweight_light:runAction(lightAction)
  local selectedContentSize = self.ui.panel_selected_list:getContentSize()
  local posY = selectedContentSize.height * 0.5
  for i, v in ipairs(self.selectedUIArr) do
    ed.setTexture(v.bg, "UI/alpha/1080P/rogue/charm/charm_frame_overweight.png")
    v.bg:stopAllActions()
    v.bg:runAction(self:createShakeAction(0, 0))
  end
  local weightDesLabel = self.bagWeightDesLabel:getLabelByName("desLabel")
  if nil ~= weightDesLabel then
    ed.setLabelColor(weightDesLabel, ccc3(255, 132, 132))
    ed.setLabelStroke(weightDesLabel, ed.toccc3(3735561), 1)
  end
  local curWeightLabel = self.bagWeightDesLabel:getLabelByName("curLabel")
  if nil ~= curWeightLabel then
    ed.setLabelColor(curWeightLabel, ccc3(255, 132, 132))
    ed.setLabelStroke(curWeightLabel, ed.toccc3(3735561), 1)
  end
  local maxWeightLabel = self.bagWeightDesLabel:getLabelByName("maxLabel")
  if nil ~= maxWeightLabel then
    ed.setLabelColor(maxWeightLabel, ccc3(255, 132, 132))
    ed.setLabelStroke(maxWeightLabel, ed.toccc3(3735561), 1)
  end
  self.ui.img_overweight_tip_bg:setVisible(true)
  if nil == self.overweightTipLabel then
    local tipBgSize = self.ui.img_overweight_tip_bg:getContentSize()
    self.overweightTipLabel = ed.ui.gradientLabel.create({
      text = T("\232\182\133\233\135\141\239\188\129"),
      fontSize = 26,
      fontName = ed.fontBold,
      startColor = ed.toccc3(15881062),
      endColor = ed.toccc3(16749222),
      strokeSize = 1,
      strokeColor = ed.toccc3(5901859)
    })
    self.ui.img_overweight_tip_bg:addChild(self.overweightTipLabel.node)
    self.overweightTipLabel.node:setPosition(ccp(tipBgSize.width * 0.5, tipBgSize.height * 0.5))
    self.ui.img_overweight_tip_bg:setScaleX(1.2)
    self.overweightTipLabel.node:setScaleX(0.8333333333333334)
  end
  ed.setCascadeOpacityEnabled(self.ui.img_overweight_tip_bg, true)
  self.ui.img_overweight_tip_bg:setOpacity(255)
  self.ui.img_overweight_tip_bg:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(0.75), CCFadeIn:create(0.375))))
  self:listenTimer(Timer:Once(1.5), function()
    self:onOverweightEffectComplete()
  end)
end

function class:getCharmCardPos(id)
  for i, v in pairs(self.charmDataList) do
    if v._charm_id == id then
      local cardUI = self.charmUIArr[i]
      return cardUI.bg:getParent():convertToWorldSpace(ccp(cardUI.bg:getPosition()))
    end
  end
  return ccp(0, 0)
end

function class:onOverweightEffectComplete()
  self.isOverweightEffectPlaying = false
  ed.setTexture(self.ui.img_bag_bg, "UI/alpha/1080P/rogue/charm/charm_normal_dec.png")
  ed.setTexture(self.ui.img_bag_icon, "UI/alpha/1080P/rogue/charm/charm_normal_pocket.png")
  self.ui.img_overweight_light:stopAllActions()
  self.ui.img_overweight_light:setVisible(false)
  self.ui.img_overweight_tip_bg:stopAllActions()
  self.ui.img_overweight_tip_bg:setVisible(false)
  for i, v in ipairs(self.selectedUIArr) do
    ed.setTexture(v.bg, "UI/alpha/1080P/rogue/charm/charm_frame_normal.png")
    v.bg:stopAllActions()
    v.bg:setPosition(0, 0)
  end
  local weightDesLabel = self.bagWeightDesLabel:getLabelByName("desLabel")
  if nil ~= weightDesLabel then
    ed.setLabelColor(weightDesLabel, ccc3(255, 231, 170))
    ed.setLabelStroke(weightDesLabel, ed.toccc3(263719), 1)
  end
  local curWeightLabel = self.bagWeightDesLabel:getLabelByName("curLabel")
  if nil ~= curWeightLabel then
    ed.setLabelColor(curWeightLabel, ccc3(255, 252, 231))
    ed.setLabelStroke(curWeightLabel, ed.toccc3(4137865), 1)
  end
  local maxWeightLabel = self.bagWeightDesLabel:getLabelByName("maxLabel")
  if nil ~= maxWeightLabel then
    ed.setLabelColor(maxWeightLabel, ccc3(255, 231, 170))
    ed.setLabelStroke(maxWeightLabel, ed.toccc3(263719), 1)
  end
  if 0 < #self.selectedIdList then
    table.remove(self.selectedIdList, #self.selectedIdList)
    self.rogueLikeMgr:saveCharmIdListToBag(self.bookId, self.selectedIdList)
    self:refreshBagList(true)
    self:refreshCharmListSelectedState()
    self:refreshBtnEquip()
  end
end

local ShakeConfigArr = {
  {x = -2, y = 2.7},
  {x = 2.7, y = -2.2},
  {x = -3.1, y = -2.1},
  {x = 2.5, y = 2.7},
  {x = -0.8, y = -2.5},
  {x = 1.3, y = 2.8}
}

function class:createShakeAction(posX, posY)
  local actionArr = {}
  local num = #ShakeConfigArr
  local startIndex = math.random(1, num)
  for i = 1, num do
    local cfg = ShakeConfigArr[(startIndex + i - 1) % num + 1]
    table.insert(actionArr, CCMoveTo:create(0.04, ccp(posX + cfg.x * 0.7, posY + cfg.y * 0.7)))
  end
  return CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack(actionArr))))
end

function class:playArrowAction()
  local opacity = self.ui.img_empty_arrow:getOpacity()
  local action1 = CCFadeTo:create(0.6, 255)
  action1 = CCSpawn:create(ccArrayMake(action1, CCMoveBy:create(0.6, ccp(0, 5))))
  local action2 = CCFadeTo:create(1.2, opacity)
  action2 = CCSpawn:create(ccArrayMake(action2, CCMoveBy:create(1.2, ccp(0, -5))))
  local seqAction = CCSequence:create(ccArrayMake(action1, action2))
  self.ui.img_empty_arrow:runAction(CCRepeatForever:create(seqAction))
end

function class:playShowAction()
  self.isShowActionPlaying = true
  local percent = self.weightProgressBar:getPercentage()
  self.weightProgressBar:runAction(CCProgressFromTo:create(0.25, percent - 0.1, percent))
  ed.setCascadeOpacityEnabled(self.ui.img_light_bg, true, true)
  self.ui.img_light_bg:setOpacity(0)
  self.ui.img_light_bg:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.25), CCCallFunc:create(function()
    self:playArrowAction()
    self.isShowActionPlaying = false
  end)))
  for k, itemUI in ipairs(self.charmUIArr) do
    local rowIndex = math.ceil(k / self.cardColumnNum - threshold)
    itemUI.bg:setOpacity(0)
    local bgPosX, bgPosY = itemUI.bg:getPosition()
    itemUI.bg:setPositionY(bgPosY - 12)
    local showAction = CCMoveTo:create(0.2, ccp(bgPosX, bgPosY))
    showAction = CCSpawn:create(ccArrayMake(showAction, CCFadeIn:create(0.2)))
    showAction = CCSequence:createWithTwoActions(CCDelayTime:create(0.1 * rowIndex), showAction)
    itemUI.bg:runAction(showAction)
  end
  for k, itemUI in ipairs(self.selectedUIArr) do
    itemUI.container:runAction(CCFadeIn:create(0.25))
  end
  ed.setCascadeOpacityEnabled(self.ui.img_charm_info, true, true)
  self.charmDesLabel.node:setCascadeOpacityEnabled(true)
  self.ui.img_charm_info:setOpacity(0)
  self.charmDesLabel.node:setOpacity(0)
  local infoPosX, infoPosY = self.ui.img_charm_info:getPosition()
  self.ui.img_charm_info:setPositionX(infoPosX + 12)
  local showAction = CCMoveTo:create(0.2, ccp(infoPosX, infoPosY))
  showAction = CCSpawn:create(ccArrayMake(showAction, CCFadeIn:create(0.2), CCCallFunc:create(function()
    self.charmDesLabel.node:runAction(CCFadeIn:create(0.2))
  end)))
  showAction = CCSequence:createWithTwoActions(CCDelayTime:create(0.3), showAction)
  self.ui.img_charm_info:runAction(showAction)
end

function class:onRuleEvent()
  local ruleTxt = T("\230\138\164\231\172\166\231\154\174\232\162\139<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\163\133\233\133\141\230\138\164\231\172\166\229\143\175\228\187\165\229\184\174\229\138\169\233\152\159\233\149\191\230\155\180\229\165\189\229\156\176\232\191\155\232\161\140\230\149\133\228\186\139\229\134\146\233\153\169\239\188\140\233\152\159\233\149\191\229\143\175\228\187\165\229\188\128\229\167\139\229\134\146\233\153\169\229\137\141\229\134\179\229\174\154\230\156\172\229\177\128\232\166\129\228\189\169\230\136\180\231\154\132\230\138\164\231\172\166\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\184\141\229\144\140\231\154\132\230\138\164\231\172\166\233\135\141\233\135\143\228\184\141\229\144\140\239\188\140\233\152\159\233\149\191\229\143\175\229\156\168\230\138\164\231\172\166\231\154\174\232\162\139\232\180\159\233\135\141\232\140\131\229\155\180\229\134\133\233\154\143\229\191\131\232\163\133\233\133\141\230\138\164\231\172\166\239\188\140<lable color=summonYellow>\230\143\144\229\141\135\230\132\159\230\130\159\231\172\148\232\174\176\229\143\175\230\143\144\233\171\152\230\138\164\231\172\166\231\154\174\232\162\139\231\154\132\232\180\159\233\135\141\228\184\138\233\153\144\227\128\130</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\138\164\231\172\166\229\133\183\230\156\137\231\136\177\229\191\131\229\128\188\239\188\140\229\189\147\233\152\159\233\149\191\228\189\169\230\136\180\229\133\182\229\156\168\230\149\133\228\186\139\228\184\173\231\187\143\232\191\135\232\182\179\229\164\159\229\164\154\231\154\132\230\136\191\233\151\180\229\144\142\239\188\140\230\138\164\231\172\166\231\154\132\231\136\177\229\191\131\231\173\137\231\186\167\229\176\177\228\188\154\228\184\138\229\141\135\239\188\140\230\138\164\231\172\166\231\154\132\229\138\155\233\135\143\228\185\159\229\176\134\233\154\143\228\185\139\230\143\144\229\141\135\227\128\130\230\179\168\230\132\143\239\188\154<lable color=summonRed>\230\138\164\231\172\166\229\143\170\229\156\168\231\187\147\230\157\159\230\184\184\231\142\169\229\144\142\229\141\135\231\186\167\239\188\140\229\156\168\229\183\178\231\187\143\229\188\128\229\144\175\231\154\132\229\177\128\229\134\133\230\149\136\230\158\156\228\184\141\228\188\154\230\148\185\229\143\152\227\128\130</lable><br/><br/>")
  ed.ui.commonRulePop.create({
    title = T("\230\138\164\231\172\166\232\167\132\229\136\153"),
    txt = ruleTxt
  }):popWindow()
end

function class:onClickBtnEquip()
  if self.isOverweightEffectPlaying or self.isShowActionPlaying then
    return
  end
  if self.curSelectedIndex < 0 then
    return
  end
  local charmData = self.charmDataList[self.curSelectedIndex]
  if charmData then
    local existIndex = -1
    for i, v in ipairs(self.selectedIdList) do
      if v == charmData._charm_id then
        existIndex = i
        break
      end
    end
    if 0 < existIndex then
      table.remove(self.selectedIdList, existIndex)
    else
      table.insert(self.selectedIdList, charmData._charm_id)
    end
    self.rogueLikeMgr:saveCharmIdListToBag(self.bookId, self.selectedIdList)
    self:refreshBagList(true)
    self:refreshCharmListSelectedState()
    self:refreshBtnEquip()
    if self.curWeightVal > self.maxWeightVal then
      self:playOverweightEffect()
    end
  end
end
