local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueBlessScene = class
class.rarity_to_list_item_bg = {
  [1] = "UI/alpha/1080P/rogue/bless/bless_bag_rank1.png",
  [2] = "UI/alpha/1080P/rogue/bless/bless_bag_rank2.png",
  [3] = "UI/alpha/1080P/rogue/bless/bless_bag_rank3.png",
  [4] = "UI/alpha/1080P/rogue/bless/bless_bag_rank4.png"
}
class.destiny_lock_bg = "UI/alpha/1080P/rogue/bless/bless_bag_rank4_unlock.png", ed.UITool.registViewOpenFunc("rogueBlessScene", function()
  local scene = ed.ui.rogueBlessScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("rogueBlessScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.rogueDestinyTB = ed.getDataTable("RogueDestiny")
  self.rogueBlessTB = ed.getDataTable("RogueBless")
  self.tabBtnList = {}
  self.selectDestiny = 0
  self.itemList = {}
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.isShowDetail = false
  self:setBackButton()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBlessScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  ed.UITool.createSceneTitle(T("\230\159\165\231\156\139\231\165\157\231\166\143"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  self.ui.btn_rule:setVisible(false)
  self.ui.image_bg:setOpacity(0)
  self:setBackground("UI/alpha/1080P/rogue/bless/bless_shop_bg.jpg")
  self:initLabels()
  self:adaptUI()
  self:initTabBtn()
  self:initTableView()
  self:refreshTabBtn()
  self:refreshTableView()
  self:refreshTabAmount()
  self:refreshPearlAmount()
  self:refreshBtnDetail()
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_tips, ed.toccc3(3085579), 1.5)
  ed.setLabelStroke(self.ui.label_empty_tips, ed.toccc3(3414094), 1.5)
  ed.setLabelFontName(self.ui.label_empty_tips, ed.fontBold)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_amount_bg, {right = 10, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_detail, {right = 200})
  ed.layout.layoutWithMagin(self.ui.label_detail_tips, {right = 130})
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.itemList
    end,
    cellSizeFromIndex = function(index)
      local itemCfg = self.itemList[index]
      if itemCfg.isDestinyTitle or itemCfg.isBlessTitle then
        return CCSizeMake(size.width, 25)
      end
      return CCSizeMake(size.width, 94)
    end,
    createCell = function(index)
      local itemCfg = self.itemList[index]
      local destinyId = itemCfg.destinyId
      local node, ui, isListItem
      if itemCfg.isDestinyTitle then
        node = self:createListTitle(destinyId)
      elseif itemCfg.isBlessTitle then
        node = self:createListTitle(destinyId, true)
      elseif itemCfg.blessId then
        node, ui = self:createListItem(destinyId, itemCfg.blessId, itemCfg.blessLevel)
        isListItem = true
      else
        node, ui = self:createListItem(destinyId)
        isListItem = true
      end
      return node, {ui = ui, isListItem = isListItem}
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data or not data.ui then
        return
      end
      local ui = data.ui
      local descDragList = ui.descDragList
      local descCanDragY = descDragList.canDragY
      if ed.containsPoint(ui.panel_desc_touch_area, x, y) and descCanDragY then
        self.tableView.dragList.canDragY = false
      end
      if ed.containsPoint(ui.panel_desc, x, y) and not ed.containsPoint(ui.panel_desc_touch_area, x, y) then
        descDragList.canDragY = false
      end
    end,
    cancelPressIn = function(cell, x, y)
      local data = cell.data
      if not data or not data.ui then
        return
      end
      local ui = data.ui
      local tableViewCanDragY = false
      if self.tableView.dragList.listHeight > self.ui.panel_list:getContentSize().height then
        tableViewCanDragY = true
      end
      self.tableView.dragList.canDragY = tableViewCanDragY
      local descDragList = ui.descDragList
      local descCanDragY = false
      if descDragList.listHeight > ui.panel_desc:getContentSize().height then
        descCanDragY = true
      end
      descDragList.canDragY = descCanDragY
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {2, 0},
    padding = {width = 0, height = 8},
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width + 3, size.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    },
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:initTabBtn()
  self.tabBtnList = {}
  self.ui.panel_btn_list:removeAllChildrenWithCleanup(true)
  local btnAll = self:createTabBtn()
  table.insert(self.tabBtnList, {destinyId = 0, btn = btnAll})
  for destinyId, destinyCfg in ipairs(self.rogueDestinyTB or {}) do
    local btn = self:createTabBtn(destinyId)
    table.insert(self.tabBtnList, {destinyId = destinyId, btn = btn})
  end
  local gapX = 14
  local panelSize = self.ui.panel_btn_list:getContentSize()
  for index, tabBtnCfg in ipairs(self.tabBtnList) do
    local btn = tabBtnCfg.btn
    local btnSize = btn:getContentSize()
    self.ui.panel_btn_list:addChild(btn)
    local totalWidth = #self.tabBtnList * btnSize.width + (#self.tabBtnList - 1) * gapX
    local posX = (panelSize.width - totalWidth) / 2 + (index - 1) * (btnSize.width + gapX) + btnSize.width / 2
    btn:setPosition(ccp(posX, panelSize.height / 2))
  end
end

function class:showListItemAction()
  local offsetY = -10
  for index, cell in ipairs(self.tableView:getUsedCell() or {}) do
    local node = cell.node
    local ui = cell.data.ui or {}
    local isListItem = cell.data.isListItem
    node:setPositionY(node:getPositionY() + offsetY)
    node:setCascadeOpacityEnabled(true)
    node:setOpacity(0)
    local time = 0.1
    local delayTime = 0.05 * (index - 1)
    local delay = CCDelayTime:create(delayTime)
    local moveAction = CCMoveBy:create(time, ccp(0, -offsetY))
    local fadeAction = CCFadeIn:create(time)
    node:runAction(CCSequence:create(ccArrayMake(delay, CCSpawn:create(ccArrayMake(moveAction, fadeAction)))))
    if isListItem then
      if ui.unlockAutoText then
        ui.unlockAutoText:setOpacity(0)
        ui.unlockAutoText:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime), CCFadeIn:create(time))))
      end
      if ui.descAutoText then
        ui.descAutoText:setOpacity(0)
        ui.descAutoText:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime), CCFadeIn:create(time))))
      end
      if ui.icon then
        ui.icon:setOpacity(0)
        ui.icon:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime), CCFadeIn:create(time))))
      end
    end
  end
end

function class:createTabBtn(destinyId)
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(48, 48))
  local choose = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_tab_choose.png")
  choose:setVisible(false)
  local unChoose = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_tab_unchoose.png")
  container:addChild(choose)
  ed.layout.centerInParent(choose)
  container:addChild(unChoose)
  ed.layout.centerInParent(unChoose)
  local icon
  if not destinyId then
    icon = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_tab_all.png")
  else
    local iconName = self.rogueDestinyTB[destinyId].Icon or "bless_the_devil"
    icon = ed.createSprite(string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", iconName))
    icon:setColor(ed.toccc3(10854317))
    icon:setScale(0.25)
  end
  container:addChild(icon, 1)
  ed.layout.centerInParent(icon)
  local posX, posY = icon:getPosition()
  icon:setPosition(ccpAdd(ccp(posX, posY), ccp(0, 1)))
  local amount = ed.createttf("0", 14)
  amount:setAnchorPoint(ccp(1, 0.5))
  ed.setLabelColor(amount, ccc3(255, 255, 255))
  ed.setLabelStroke(amount, ed.toccc3(4141899), 1)
  container:addChild(amount)
  amount:setPosition(ccp(45, 9))
  if destinyId == self.rogueLikeMgr:getDestinyId() then
    local labelBg = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_choose_info.png")
    local labelCur = ed.createttf(T("\229\189\147\229\137\141\229\145\189\232\191\144"), 12)
    ed.setLabelColor(labelCur, ed.toccc3(15649925))
    labelBg:addChild(labelCur)
    ed.layout.centerInParent(labelCur)
    container:addChild(labelBg, 1)
    labelBg:setPosition(ccp(24, 55))
    local curDestinyLight = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_tab_light1.png")
    local curDestinySelect = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_tab_light2.png")
    container:addChild(curDestinyLight)
    container:addChild(curDestinySelect)
    curDestinyLight:setVisible(false)
    curDestinySelect:setVisible(false)
    ed.layout.centerInParent(curDestinyLight)
    ed.layout.centerInParent(curDestinySelect)
    container.curDestinyLight = curDestinyLight
    container.curDestinySelect = curDestinySelect
  end
  container.choose = choose
  container.unChoose = unChoose
  container.amount = amount
  container.icon = icon
  return container
end

function class:createListItem(destinyId, blessId, blessLevel)
  local width = self.ui.panel_list:getContentSize().width
  local container = ed.createSprite()
  container:setCascadeOpacityEnabled(true)
  local _, ui = ed.editorui(ed.uieditor.rogueBlessSceneItem, {container = container})
  ed.setLabelStroke(ui.label_reinforce, ed.toccc3(1973530), 1)
  local icon, name, bgPath, desc, tableCfg, unlockDesc, labelColor
  if blessId then
    local rogueBlessCfg = self.rogueBlessTB[blessId]
    local canReinforced = rogueBlessCfg["Can Be Reinforced"]
    local isReinforce = blessLevel and 1 < blessLevel
    name = rogueBlessCfg["Bless Name"]
    icon = ed.rogueLikeTool.createBlessIcon(blessId)
    local rarity = rogueBlessCfg.Rarity or 1
    if canReinforced and isReinforce then
      desc = self.isShowDetail and rogueBlessCfg["Reinforced Full Description"] or rogueBlessCfg["Reinforced Description"]
    else
      desc = self.isShowDetail and rogueBlessCfg["Full Description"] or rogueBlessCfg.Description
    end
    tableCfg = rogueBlessCfg
    ui.image_lock_tag:setVisible(false)
    ui.label_reinforce:setVisible(isReinforce)
    if not isReinforce then
      bgPath = string.format("UI/alpha/1080P/rogue/bless/bless_bag_rank%s.png", rarity)
    else
      bgPath = string.format("UI/alpha/1080P/rogue/bless/bless_bag_reinforce_rank%s.png", rarity)
    end
  else
    local destinyCfg = self.rogueDestinyTB[destinyId]
    local unlock = self.rogueLikeMgr:getRevelationEnable(destinyId)
    local iconPath = destinyCfg.Icon or "bless_the_devil"
    icon = ed.createSprite(string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", iconPath))
    name = destinyCfg["Revelation Name"]
    bgPath = unlock and self.rarity_to_list_item_bg[4] or self.destiny_lock_bg
    desc = self.isShowDetail and destinyCfg["Revelation Full Description"] or destinyCfg["Revelation Description"]
    tableCfg = destinyCfg
    ui.image_lock_tag:setVisible(not unlock)
    if not unlock then
      labelColor = ccc3(171, 171, 171)
      unlockDesc = string.format(T("\231\180\175\231\167\175\232\142\183\229\190\151<lable color=ccc3(255,165,49)>3</lable>\228\184\170%s\231\154\132\231\165\157\231\166\143\229\144\142\230\191\128\230\180\187\229\144\175\231\164\186\230\138\128\232\131\189"), destinyCfg["Display Name"])
    end
  end
  local diffWidth = width - ui.image_bg:getContentSize().width
  local panelDescSize = ui.panel_desc:getContentSize()
  ui.panel_desc:setContentSize(CCSizeMake(panelDescSize.width + diffWidth - 5, panelDescSize.height))
  local panelDescTouchSize = ui.panel_desc_touch_area:getContentSize()
  ui.panel_desc_touch_area:setContentSize(CCSizeMake(panelDescTouchSize.width + diffWidth - 5, panelDescTouchSize.height))
  ui.label_reinforce:setPositionX(ui.label_reinforce:getPositionX() + diffWidth)
  ui.image_bg:setSpriteFrame(ed.getSpriteFrame(bgPath))
  ui.image_bg:setContentSize(CCSizeMake(width - 5, 94))
  container:setContentSize(ui.image_bg:getContentSize())
  icon:setScale(0.45)
  ui.panel_icon:addChild(icon)
  ui.icon = icon
  ed.layout.centerInParent(icon)
  ed.setLabelString(ui.label_name, name)
  ed.setLabelStroke(ui.label_name, ed.toccc3(1973530), 1)
  ed.setLabelStroke(ui.label_reinforce, ed.toccc3(1973530), 1)
  local panelSize = ui.panel_desc:getContentSize()
  if unlockDesc then
    local unlockAutoText = ed.ui.autoText.new()
    unlockAutoText:initParam({
      context = unlockDesc,
      fontSize = 16,
      color = ccc3(225, 225, 225),
      strokeColor = ed.toccc3(1973530),
      strokeSize = 1,
      maxWidth = panelSize.width - 100
    })
    ui.image_bg:addChild(unlockAutoText.node)
    ui.unlockAutoText = unlockAutoText.node
    unlockAutoText.node:setPosition(ccp(ui.label_name:getPositionX() + ui.label_name:getContentSize().width + 5, ui.label_name:getPositionY()))
  end
  local descDragList = ed.UITool.createDraglist(ui.panel_desc)
  local descAutoText = ed.rogueLikeTool.parseAutoTextDesc(desc or "", tableCfg, {
    color = labelColor or ccc3(255, 252, 231),
    strokeColor = ed.toccc3(1973530),
    strokeSize = 1,
    fontSize = 16,
    maxWidth = panelSize.width
  })
  descDragList:addItem(descAutoText.node)
  descAutoText.node:setPosition(ccp(1, panelSize.height - 15))
  ui.descAutoText = descAutoText.node
  ui.descDragList = descDragList
  local descW, descH = descAutoText:getCurContentSize()
  descDragList:initListHeight(descH)
  if descH > panelSize.height then
    descAutoText.node:setPositionX(0)
    descAutoText.node:setPositionY(panelSize.height - 8)
  else
    descAutoText.node:setPositionX(0)
    descAutoText.node:setPositionY((panelSize.height + descH) / 2 - 8)
  end
  return container, ui
end

function class:createListTitle(destinyId, isBlessTitle)
  local width = self.ui.panel_list:getContentSize().width
  local container = ed.createSprite()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/rogue/bless/bless_bag_title_bg.png")
  container:addChild(bg)
  bg:setAnchorPoint(ccp(0, 0))
  bg:setContentSize(CCSizeMake(width, 25))
  container:setContentSize(CCSizeMake(width, 25))
  local dec, name
  if isBlessTitle then
    local text = string.format(T("\227\128\144%s\227\128\145\231\154\132\231\165\157\231\166\143"), self.rogueDestinyTB[destinyId]["Display Name"])
    name = ed.createttf(text, 18)
    ed.setLabelColor(name, ccc3(248, 245, 231))
    dec = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_type_dec2.png")
  else
    local text = string.format(T("\227\128\144%s\227\128\145\231\154\132\229\144\175\231\164\186"), self.rogueDestinyTB[destinyId]["Display Name"])
    name = ed.createttf(text, 18)
    ed.setLabelColor(name, ccc3(234, 208, 133))
    ed.setLabelStroke(name, ed.toccc3(1973530), 1)
    dec = ed.createSprite("UI/alpha/1080P/rogue/bless/bless_bag_type_dec1.png")
  end
  dec:setPosition(ccp(25, 12.5))
  container:addChild(dec)
  name:setAnchorPoint(ccp(0, 0.5))
  name:setPosition(ccp(30, 12.5))
  container:addChild(name)
  return container
end

function class:refreshView()
  self:refreshTableView()
end

function class:refreshTableView(isHoldPos)
  local curChapter = self.rogueLikeMgr:getCurChapter() or {}
  local showDestinyList = {}
  for destinyId, destinyCfg in ipairs(self.rogueDestinyTB or {}) do
    if self.selectDestiny == 0 or self.selectDestiny == destinyId then
      table.insert(showDestinyList, destinyId)
    end
  end
  table.sort(showDestinyList, ed.cmpSort({
    {
      getValue = function(destinyId)
        return destinyId == curChapter._destiny and 0 or 1
      end
    }
  }))
  self.itemList = {}
  for _, destinyId in ipairs(showDestinyList) do
    if curChapter._destiny == destinyId then
      table.insert(self.itemList, {destinyId = destinyId, isDestinyTitle = true})
      table.insert(self.itemList, {destinyId = destinyId})
    end
    local revelationBless = self.rogueDestinyTB[destinyId].RevelationBless or {}
    for index, rogueBless in ipairs(curChapter._bless_list or {}) do
      if ed.isElementInTable(rogueBless._bless, revelationBless) then
        table.insert(self.itemList, {
          destinyId = destinyId,
          blessId = rogueBless._bless,
          blessLevel = rogueBless._level
        })
      end
    end
    local blessList = self.rogueDestinyTB[destinyId].DestinyBless or {}
    local addBlessList = {}
    for index, rogueBless in ipairs(curChapter._bless_list or {}) do
      if ed.isElementInTable(rogueBless._bless, blessList) then
        table.insert(addBlessList, rogueBless)
      end
    end
    table.sort(addBlessList, ed.cmpSort({
      {
        getValue = function(rogueBless)
          local blessId = rogueBless._bless
          return self.rogueBlessTB[blessId].Rarity or 0
        end,
        reverse = true
      },
      {
        getValue = function(rogueBless)
          local blessId = rogueBless._bless
          return blessId
        end
      }
    }))
    if 0 < #addBlessList then
      table.insert(self.itemList, {destinyId = destinyId, isBlessTitle = true})
      for _, rogueBless in ipairs(addBlessList) do
        table.insert(self.itemList, {
          destinyId = destinyId,
          blessId = rogueBless._bless,
          blessLevel = rogueBless._level
        })
      end
    end
  end
  self.ui.image_empty_tips:setVisible(#self.itemList == 0)
  if isHoldPos then
    local listX, listY = self.tableView:getListPos()
    self.tableView:reloadData()
    self.tableView:setListPos(ccp(listX, listY))
  else
    self.tableView:reloadData()
    self:showListItemAction()
  end
end

function class:refreshTabBtn()
  for index, tabBtnCfg in ipairs(self.tabBtnList) do
    local btn = tabBtnCfg.btn
    local destinyId = tabBtnCfg.destinyId
    local isSelected = destinyId == self.selectDestiny
    btn.choose:setVisible(isSelected)
    btn.unChoose:setVisible(not isSelected)
    if btn.curDestinySelect then
      btn.curDestinySelect:setVisible(isSelected)
    end
    if btn.curDestinyLight then
      btn.curDestinyLight:setVisible(not isSelected)
    end
  end
end

function class:refreshTabAmount()
  self.collectAmount = {}
  self.totalViewAmount = 0
  local curChapter = self.rogueLikeMgr:getCurChapter() or {}
  for destinyId, destinyCfg in ipairs(self.rogueDestinyTB) do
    local amount = 0
    local blessList = destinyCfg.DestinyBless or {}
    local revelationBless = self.rogueDestinyTB[destinyId].RevelationBless or {}
    for index, rogueBless in ipairs(curChapter._bless_list or {}) do
      if ed.isElementInTable(rogueBless._bless, blessList) then
        amount = amount + 1
      end
    end
    self.collectAmount[destinyId] = {viewAmount = amount}
    self.totalViewAmount = self.totalViewAmount + amount
  end
  for index, tabBtnCfg in ipairs(self.tabBtnList) do
    local btn = tabBtnCfg.btn
    local destinyId = tabBtnCfg.destinyId
    if destinyId == 0 then
      ed.setLabelString(btn.amount, self.totalViewAmount)
    else
      local amount = self.collectAmount[destinyId] and self.collectAmount[destinyId].viewAmount or 0
      ed.setLabelString(btn.amount, amount)
    end
  end
end

function class:refreshPearlAmount()
  ed.setLabelString(self.ui.label_amount, self.rogueLikeMgr:getPearl())
end

function class:refreshBtnDetail()
  local btnBgPath, switchPath
  if self.isShowDetail then
    btnBgPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_on.png"
    switchPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_button2.png"
  else
    btnBgPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_close.png"
    switchPath = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_button1.png"
  end
  ed.setTexture(self.ui.btn_detail, btnBgPath)
  ed.setTexture(self.ui.image_detail_switch, switchPath)
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
    txt = ed.rogueDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickTabBtn(tabBtnCfg)
  if tabBtnCfg.destinyId == self.selectDestiny then
    return
  end
  self.selectDestiny = tabBtnCfg.destinyId
  self:refreshTabBtn()
  self:refreshTableView()
end

function class:onClickPearl()
  ed.ui.packageDetailWin.create({type = "pearl"}):popWindow()
end

function class:onClickBtnDetail()
  self.isShowDetail = not self.isShowDetail
  local pos
  if self.isShowDetail then
    pos = ccp(40, 10)
  else
    pos = ccp(10, 10)
  end
  local moveAction = CCMoveTo:create(0.3, pos)
  local callFunc = CCCallFunc:create(function()
    self:refreshBtnDetail()
    self:refreshTableView(true)
  end)
  local action = CCSequence:create(ccArrayMake(moveAction, callFunc))
  self.ui.image_detail_switch:runAction(action)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "image_amount_bg", function()
    self:onClickPearl()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_detail", function()
    self:onClickBtnDetail()
  end, {pressScale = 0.95, normalScale = 1})
  for index, tabBtnCfg in ipairs(self.tabBtnList) do
    self:btRegisterButtonClick({
      button = tabBtnCfg.btn,
      key = tabBtnCfg.destinyId,
      force = true,
      pressScale = 0.95,
      clickHandler = function()
        self:onClickTabBtn(tabBtnCfg)
      end
    })
  end
end

function class:addEventListener()
  self:listenEvent("rogueUpdatePearlAmount", function()
    self:refreshPearlAmount()
  end)
end
