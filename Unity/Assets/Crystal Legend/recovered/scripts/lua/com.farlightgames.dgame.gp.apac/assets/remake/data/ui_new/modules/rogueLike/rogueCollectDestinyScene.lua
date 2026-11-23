local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueCollectDestinyScene = class
class.rarity_to_list_item_cfg = {
  [1] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_bless_1.png",
    star = "UI/alpha/1080P/rogue/collect/collect_star_1.png",
    type_color = ccc3(203, 211, 255),
    type_stroke_color = ed.toccc3(3224418),
    name_color = ccc3(255, 251, 236),
    name_stroke_color = ed.toccc3(3224418)
  },
  [2] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_bless_bg2.png",
    star = "UI/alpha/1080P/rogue/collect/collect_star_2.png",
    type_color = ccc3(243, 195, 255),
    type_stroke_color = ed.toccc3(5521032),
    name_color = ccc3(255, 251, 236),
    name_stroke_color = ed.toccc3(5521032)
  },
  [3] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_bless_bg3.png",
    star = "UI/alpha/1080P/rogue/collect/collect_star_3.png",
    type_color = ccc3(255, 237, 170),
    type_stroke_color = ed.toccc3(5521032),
    name_color = ccc3(255, 251, 236),
    name_stroke_color = ed.toccc3(10052441)
  },
  [4] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_bless_destiny_bg.png",
    star = "UI/alpha/1080P/rogue/collect/collect_star_4.png",
    type_color = ccc3(253, 253, 245),
    type_stroke_color = ed.toccc3(8868297),
    name_color = ccc3(255, 251, 236),
    name_stroke_color = ed.toccc3(5318533)
  }
}
class.rarity_to_card_detail_cfg = {
  [1] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_bless_detail_bg1.png",
    name_bg = "UI/alpha/1080P/rogue/bless/bless_name_bg1.png"
  },
  [2] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_bless_detail_bg2.png",
    name_bg = "UI/alpha/1080P/rogue/bless/bless_name_bg2.png"
  },
  [3] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_bless_detail_bg3.png",
    name_bg = "UI/alpha/1080P/rogue/bless/bless_name_bg3.png"
  },
  [4] = {
    card_bg = "UI/alpha/1080P/rogue/collect/collect_echo_detail_bg.png",
    name_bg = "UI/alpha/1080P/rogue/collect/collect_bless_name_destiny.png"
  }
}
ed.UITool.registViewOpenFunc("rogueCollectDestinyScene", function()
  local scene = ed.ui.rogueCollectDestinyScene.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("rogueCollectDestinyScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.dataList = {}
  self.rogueDestinyTB = ed.getDataTable("RogueDestiny")
  self.rogueBlessTB = ed.getDataTable("RogueBless")
  self.selectDestinyTab = 1
  self.selectDestinyId = nil
  self.selectBlessId = nil
  self.collectAmount = {}
  self.totalAmount = 0
  self.totalViewAmount = 0
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self:registerRedDot()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCollectDestinyScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  self:initLabels()
  ed.UITool.createSceneTitle(T("\229\145\189\232\191\144"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  self:adaptUI()
  self:initTabBtn()
  self:initTableView()
  self:refreshTableView()
  self:refreshAmount()
  self:refreshDestinyCollect()
end

function class:registerRedDot()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("rogue_collection_weekly_reward_entry", self, {
    handle = function(value)
      self.ui.image_reward_entry_red:setVisible(0 < value)
    end
  })
end

function class:onPopScene()
  self.redPointMgr:unregisterAllValueChange(self)
  base.onPopScene(self)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_name, ed.toccc3(2171169), 1)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 21}, false, true)
  local diffWidth = ed.display.winSize.width - 960
  local diffHeight = ed.display.winSize.height - 540
  self.ui.image_design:setPositionX(self.ui.image_design:getPositionX() - diffWidth / 2)
  self.ui.image_detail_bg:setPositionX(self.ui.image_detail_bg:getPositionX() - diffWidth / 2)
  self.ui.panel_list:setPositionX(self.ui.panel_list:getPositionX() - diffWidth / 2)
  local oldPanelList = self.ui.panel_list:getContentSize()
  self.ui.panel_list:setContentSize(CCSizeMake(oldPanelList.width + diffWidth, oldPanelList.height))
  self.ui.label_bless_progress:setPositionX(self.ui.label_bless_progress:getPositionX() + diffWidth / 2)
  self.ui.label_bless_progress_tips:setPositionX(self.ui.label_bless_progress_tips:getPositionX() + diffWidth / 2)
end

function class:showListItemAction()
  for index, cell in ipairs(self.tableView:getUsedCell() or {}) do
    local node = cell.node
    local ui = cell.data.ui or {}
    ui.image_bg:setCascadeOpacityEnabled(true)
    node:setCascadeOpacityEnabled(true)
    node:setOpacity(0)
    local time = 0.3
    local delayTime = 0.02 * (index - 1)
    local delay = CCDelayTime:create(delayTime)
    local fadeAction = CCFadeIn:create(time)
    node:runAction(CCSequence:create(ccArrayMake(delay, fadeAction)))
  end
end

function class:initTabBtn()
  self.tabBtnList = {}
  self.tabBtnDragList = ed.UITool.createDraglist(self.ui.panel_tab_btn)
  for destinyId, destinyCfg in ipairs(self.rogueDestinyTB or {}) do
    local btn = self:createTabBtn(destinyId)
    table.insert(self.tabBtnList, {destinyId = destinyId, btn = btn})
  end
  local panelSize = self.ui.panel_tab_btn:getContentSize()
  local width, gapX = 24, 14
  for index, tabBtnCfg in ipairs(self.tabBtnList) do
    local btn = tabBtnCfg.btn
    local btnSize = btn:getContentSize()
    self.tabBtnDragList:addItem(btn)
    btn:setPosition(ccp(width, panelSize.height / 2))
    width = width + gapX + btnSize.width
  end
  self.tabBtnDragList:initListWidth(width)
  self:refreshTabBtn()
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
  local amount = ed.createttf("0", 14)
  amount:setAnchorPoint(ccp(1, 0.5))
  ed.setLabelColor(amount, ccc3(255, 255, 255))
  ed.setLabelStroke(amount, ed.toccc3(4141899), 1)
  container:addChild(amount)
  amount:setPosition(ccp(45, 9))
  container.choose = choose
  container.unChoose = unChoose
  container.amount = amount
  container.icon = icon
  return container
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.dataList
    end,
    cellSizeFromIndex = function(index)
      return self:getListItemSize()
    end,
    createCell = function(index)
      local data = self.dataList[index]
      local itemContainer, ui = self:createListItem(index, data)
      return itemContainer, {data = data, ui = ui}
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data.data
      local ui = cell.data.ui
      ui.image_bg:setScale(0.95)
    end,
    cancelPressIn = function(cell)
      local data = cell.data.data
      local ui = cell.data.ui
      ui.image_bg:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data.data
      local ui = cell.data.ui
      local destinyId = data.destinyId
      local blessId = data.blessId
      if destinyId and self.selectDestinyId ~= destinyId or blessId and self.selectBlessId ~= blessId then
        self.selectDestinyId = destinyId
        self.selectBlessId = blessId
        self:refreshCardDetail()
        for _, item in ipairs(self.tableView:getUsedCell() or {}) do
          item.data.ui.image_select:setVisible(false)
        end
        ui.image_select:setVisible(true)
      end
    end
  }
  local itemSize = self:getListItemSize()
  local col = math.floor(size.width / itemSize.width)
  local offsetX = size.width - col * itemSize.width
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = col,
    dragMode = 1,
    touchpriority = -300,
    offset = {3, 0},
    noshade = true,
    padding = {width = 2, height = 2},
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width + 3 - offsetX / 2, size.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    }
  }
  self.ui.panel_list:setPositionX(self.ui.panel_list:getPositionX() + offsetX / 2)
  self.ui.image_detail_bg:setPositionX(self.ui.image_detail_bg:getPositionX() + offsetX / 2)
  self.ui.image_design:setPositionX(self.ui.image_design:getPositionX() + offsetX / 2)
  self.tableView = Tableview.create(param)
end

function class:getListItemSize()
  return CCSizeMake(145.5, 181.5)
end

function class:createListItem(index, data)
  local destinyId = data.destinyId
  local blessId = data.blessId
  local container = CCSprite:create()
  local _, ui = ed.editorui(ed.uieditor.rogueCollectDestinyItem, {container = container})
  if destinyId and self.selectDestinyId == destinyId or blessId and self.selectBlessId == blessId then
    ui.image_select:setVisible(true)
  else
    ui.image_select:setVisible(false)
  end
  local unlock = false
  if destinyId then
    unlock = self.rogueLikeMgr:getRevelationViewFlag(destinyId)
  elseif blessId then
    unlock = self.rogueLikeMgr:getBlessViewFlag(blessId)
  end
  container:setContentSize(self:getListItemSize())
  local rarity, icon, iconShadow
  if blessId then
    local rogueBlessCfg = self.rogueBlessTB[blessId]
    icon = ed.rogueLikeTool.createBlessIcon(blessId)
    icon:setScale(0.65)
    iconShadow = ed.rogueLikeTool.createBlessIcon(blessId)
    iconShadow:setScaleX(0.65)
    iconShadow:setScaleY(-0.65)
    iconShadow:setOpacity(26)
    rarity = rogueBlessCfg.Rarity or 1
    local typeName = ed.rogueDefine.BLESS_TYPE_TO_NAME[rogueBlessCfg["Bless Type"]] or T("\231\165\157\231\166\143")
    ed.setString(ui.label_type, typeName)
    ed.setString(ui.label_name, unlock and rogueBlessCfg["Bless Name"] or T("\239\188\159\239\188\159\239\188\159"))
    ui.image_star_left:setPositionX(ui.label_type:getPositionX() - ui.label_type:getContentSize().width / 2 - 9)
    ui.image_star_right:setPositionX(ui.label_type:getPositionX() + ui.label_type:getContentSize().width / 2 + 9)
  else
    local destinyCfg = self.rogueDestinyTB[destinyId]
    icon = ed.rogueLikeTool.createRevelationSimpleIcon(destinyId)
    icon:setScale(0.65)
    iconShadow = ed.rogueLikeTool.createRevelationSimpleIcon(destinyId)
    iconShadow:setScaleX(0.65)
    iconShadow:setScaleY(-0.65)
    iconShadow:setOpacity(26)
    rarity = 4
    ed.setString(ui.label_type, T("\229\144\175\231\164\186"))
    ed.setString(ui.label_name, unlock and destinyCfg["Revelation Name"] or T("\239\188\159\239\188\159\239\188\159"))
  end
  ui.image_lock_mask:setVisible(not unlock)
  local panelIconSize = ui.panel_icon:getContentSize()
  local panelIconX, panelIconY = ui.panel_icon:getPosition()
  ui.image_bg:addChild(icon, ui.panel_icon:getZOrder())
  icon:setPosition(ccp(panelIconX + panelIconSize.width / 2, panelIconY + panelIconSize.height / 2))
  ui.image_bg:addChild(iconShadow, ui.panel_icon:getZOrder())
  iconShadow:setPosition(ccp(panelIconX + panelIconSize.width / 2, panelIconY - 5))
  local rarity_ui_cfg = self.rarity_to_list_item_cfg[rarity]
  ed.setTexture(ui.image_star_left, rarity_ui_cfg.star)
  ed.setTexture(ui.image_star_right, rarity_ui_cfg.star)
  ed.setTexture(ui.image_bg, rarity_ui_cfg.card_bg)
  ed.setLabelColor(ui.label_type, rarity_ui_cfg.type_color)
  ed.setLabelStroke(ui.label_type, rarity_ui_cfg.type_stroke_color, 1)
  ed.setLabelColor(ui.label_name, rarity_ui_cfg.name_color)
  ed.setLabelStroke(ui.label_name, rarity_ui_cfg.name_stroke_color, 1)
  return container, ui
end

function class:refreshTabBtn()
  for index, tabBtnCfg in ipairs(self.tabBtnList) do
    local btn = tabBtnCfg.btn
    local destinyId = tabBtnCfg.destinyId
    local isSelected = destinyId == self.selectDestinyTab
    btn.choose:setVisible(isSelected)
    btn.unChoose:setVisible(not isSelected)
  end
end

function class:refreshTableView()
  local showDestinyList = {}
  for destinyId, destinyCfg in ipairs(self.rogueDestinyTB or {}) do
    if self.selectDestinyTab == 0 or self.selectDestinyTab == destinyId then
      table.insert(showDestinyList, destinyId)
    end
  end
  self.dataList = {}
  self.selectDestinyId = 0 < #showDestinyList and showDestinyList[1]
  self.selectBlessId = nil
  for _, destinyId in ipairs(showDestinyList) do
    table.insert(self.dataList, {destinyId = destinyId})
    local blessList = self.rogueDestinyTB[destinyId].DestinyBless or {}
    local revelationBlessList = self.rogueDestinyTB[destinyId].RevelationBless or {}
    blessList = ed.copyTable(blessList)
    revelationBlessList = ed.copyTable(revelationBlessList)
    ed.insert2Table(blessList, revelationBlessList)
    table.sort(blessList, ed.cmpSort({
      {
        getValue = function(blessId)
          return self.rogueBlessTB[blessId].Rarity
        end,
        reverse = true
      },
      {
        getValue = function(blessId)
          return self.rogueLikeMgr:getBlessViewFlag(blessId) and 0 or 1
        end
      },
      {
        getValue = function(blessId)
          local type = self.rogueBlessTB[blessId]["Bless Type"]
          local t = {RevelationBless = 1, DuoBless = 2}
          return t[type] or 99
        end
      }
    }))
    for _, blessId in ipairs(blessList) do
      table.insert(self.dataList, {blessId = blessId})
    end
  end
  self.tableView:reloadData()
  self:refreshCardDetail()
end

function class:refreshCardDetail()
  local icon, rarity, name, desc, tableCfg, unlock
  if self.selectBlessId then
    tableCfg = self.rogueBlessTB[self.selectBlessId]
    name = tableCfg["Bless Name"]
    rarity = tableCfg.Rarity or 1
    local type = tableCfg["Bless Type"]
    icon = ed.rogueLikeTool.createBlessIcon(self.selectBlessId)
    unlock = self.rogueLikeMgr:getBlessViewFlag(self.selectBlessId)
    if unlock then
      desc = tableCfg.Description
    elseif type == "RevelationBless" then
      desc = T("\229\156\168\228\184\128\229\177\128\230\149\133\228\186\139\228\184\173\230\191\128\230\180\187\230\156\172\229\145\189\232\191\144\231\154\132\229\144\175\231\164\186\239\188\140\229\185\182\232\142\183\229\143\1506/9/12\228\184\170\230\156\172\229\145\189\232\191\144\231\154\132\231\165\157\231\166\143\230\151\182\229\143\175\233\128\137\230\139\169\230\183\177\229\186\166\229\144\175\231\164\186\227\128\130")
    else
      desc = T("\231\187\167\231\187\173\230\184\184\231\142\169\229\185\187\228\185\166\229\165\135\232\176\173\231\154\132\230\149\133\228\186\139\228\187\165\229\143\145\231\142\176\230\156\172\231\165\157\231\166\143")
    end
  else
    tableCfg = self.rogueDestinyTB[self.selectDestinyId]
    name = tableCfg["Revelation Name"]
    rarity = 4
    icon = ed.rogueLikeTool.createRevelationSimpleIcon(self.selectDestinyId)
    unlock = self.rogueLikeMgr:getRevelationViewFlag(self.selectDestinyId)
    desc = unlock and tableCfg["Revelation Description"] or T("\229\156\168\228\184\128\229\177\128\230\149\133\228\186\139\228\184\173\233\128\137\230\139\169\230\156\172\229\145\189\232\191\144\231\154\132\229\161\148\231\189\151\239\188\140\229\185\182\232\142\183\229\143\1503\228\184\170\230\156\172\229\145\189\232\191\144\231\154\132\231\165\157\231\166\143\228\187\165\230\191\128\230\180\187\229\144\175\231\164\186\227\128\130")
  end
  local rarity_ui_cfg = self.rarity_to_card_detail_cfg[rarity]
  ed.setTexture(self.ui.image_detail_bg, rarity_ui_cfg.card_bg)
  ed.setTexture(self.ui.image_name_bg, rarity_ui_cfg.name_bg)
  ed.setString(self.ui.label_name, unlock and name or T("\239\188\159\239\188\159\239\188\159"))
  ed.setLabelStroke(self.ui.label_name, ed.toccc3(2171169), 1)
  self.ui.panel_icon:removeAllChildrenWithCleanup(true)
  self.ui.panel_icon:addChild(icon)
  icon:setScale(0.8)
  ed.layout.centerInParent(icon)
  self.ui.panel_desc:removeAllChildrenWithCleanup(true)
  local panelSize = self.ui.panel_desc:getContentSize()
  local descAutoText = ed.rogueLikeTool.parseAutoTextDesc(desc, tableCfg, {
    fontSize = 15,
    labelColor = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    maxWidth = panelSize.width
  })
  self.ui.panel_desc:addChild(descAutoText.node)
  descAutoText.node:setPosition(ccp(0, panelSize.height - 7.5))
end

function class:refreshDestinyCollect()
  if self.selectDestinyTab == 0 then
    self.ui.label_bless_progress_tips:setVisible(false)
    self.ui.label_bless_progress:setVisible(false)
  else
    self.ui.label_bless_progress_tips:setVisible(true)
    self.ui.label_bless_progress:setVisible(true)
    local amountCfg = self.collectAmount[self.selectDestinyTab]
    local viewAmount = 0
    local totalAmount = 0
    if amountCfg then
      viewAmount = amountCfg.viewAmount
      totalAmount = amountCfg.totalAmount
    end
    ed.setLabelString(self.ui.label_bless_progress, string.format("%s/%s", viewAmount, totalAmount))
    ed.setLabelString(self.ui.label_bless_progress_tips, string.format(T("%s\231\154\132\231\165\157\231\166\143"), self.rogueDestinyTB[self.selectDestinyTab]["Display Name"]))
    self.ui.label_bless_progress_tips:setPositionX(self.ui.label_bless_progress:getPositionX() - self.ui.label_bless_progress:getContentSize().width - 5)
  end
  self:showListItemAction()
end

function class:refreshAmount()
  self.collectAmount = {}
  self.totalViewAmount = 0
  self.totalAmount = 0
  for destinyId, destinyCfg in ipairs(self.rogueDestinyTB) do
    local amount = 0
    if self.rogueLikeMgr:getRevelationViewFlag(destinyId) then
      amount = amount + 1
    end
    local blessList = destinyCfg.DestinyBless or {}
    for _, blessId in ipairs(blessList) do
      if self.rogueLikeMgr:getBlessViewFlag(blessId) then
        amount = amount + 1
      end
    end
    local revelationBlessList = destinyCfg.RevelationBless or {}
    for _, blessId in ipairs(revelationBlessList) do
      if self.rogueLikeMgr:getBlessViewFlag(blessId) then
        amount = amount + 1
      end
    end
    self.collectAmount[destinyId] = {
      viewAmount = amount,
      totalAmount = #blessList + #revelationBlessList + 1
    }
    self.totalViewAmount = self.totalViewAmount + amount
    self.totalAmount = self.totalAmount + #blessList + #revelationBlessList + 1
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
  ed.setLabelString(self.ui.label_total_progress, string.format("%s/%s", self.totalViewAmount, self.totalAmount))
end

function class:onClickTabBtn(tabBtnCfg)
  if tabBtnCfg.destinyId == self.selectDestinyTab then
    return
  end
  self.selectDestinyTab = tabBtnCfg.destinyId
  self:refreshTabBtn()
  self:refreshTableView()
  self:refreshDestinyCollect()
end

function class:onClickBtnReward()
  ed.UITool.openView("rogueCollectRewardWindow")
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_reward", function()
    self:onClickBtnReward()
  end, {pressScale = 0.95})
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
end
