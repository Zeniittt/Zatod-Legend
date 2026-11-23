local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueCollectScriptScene = class
class.TAB_DESTINY = "Destiny"
class.TAB_CRISIS = "Crisis"
class.TAB_ENDING = "Ending"
class.TAB_CHOOSE = "Choose"
class.TAB_SORT = {
  class.TAB_DESTINY,
  class.TAB_CRISIS,
  class.TAB_ENDING,
  class.TAB_CHOOSE
}
class.TAB_CONFIG = {
  [class.TAB_DESTINY] = {
    text = T("\230\188\148\231\187\142\229\145\189\232\191\144"),
    selectPath = "collect_script_destiny_light.png",
    normalPath = "collect_script_destiny_dark.png"
  },
  [class.TAB_CRISIS] = {
    text = T("\230\188\148\231\187\142\229\141\177\230\156\186"),
    selectPath = "collect_script_crisis_light.png",
    normalPath = "collect_script_crisis_dark.png"
  },
  [class.TAB_ENDING] = {
    text = T("\230\188\148\231\187\142\231\187\147\229\177\128"),
    selectPath = "collect_script_final_light.png",
    normalPath = "collect_script_final_dark.png"
  },
  [class.TAB_CHOOSE] = {
    text = T("\230\188\148\231\187\142\230\138\137\230\139\169"),
    selectPath = "collect_script_choose_light.png",
    normalPath = "collect_script_choose_dark.png"
  }
}
ed.UITool.registViewOpenFunc("rogueCollectScriptScene", function(param)
  local scene = ed.ui.rogueCollectScriptScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueCollectScriptScene")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.selectTab = param.selectTab or self.TAB_DESTINY
  self.scriptList = {}
  self:initScriptData()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueCollectScriptScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  local _, titleTxt = ed.UITool.createSceneTitle(T("\230\188\148\231\187\142\230\179\149"), self.ui.image_title_bg, {
    position = ccp(9, 19)
  })
  ed.layout.relateLayout(titleTxt, self.ui.label_total_progress_tips, {
    right = titleTxt:getContentSize().width * 0.5 + 10
  })
  ed.layout.relateLayout(self.ui.label_total_progress_tips, self.ui.label_total_progress, {
    right = self.ui.label_total_progress_tips:getContentSize().width * 0.5 + 7 - self.ui.label_total_progress:getContentSize().width
  })
  self:setBackButton()
  self:initLabels()
  self:adaptUI()
  self:initTabBtnList()
  self:initTableView()
  self:refreshView()
end

function class:initScriptData()
  self.completeAmount = 0
  self.totalAmount = 0
  self.scriptData = {}
  self.redPointState = {}
  for id, rogueScriptCfg in pairs(ed.getDataTable("RogueScript")) do
    local rewardState
    local scriptData = self.rogueLikeMgr:getScriptRewardData(id)
    local type = rogueScriptCfg.Type
    local openTime = ed.dateStringToTime(rogueScriptCfg["Open Time"])
    if openTime <= ed.getFitServerTime() then
      self.totalAmount = self.totalAmount + 1
      if scriptData._reward_time then
        rewardState = "complete"
        self.completeAmount = self.completeAmount + 1
      elseif scriptData._complete_time then
        rewardState = "available"
        self.redPointState[type] = true
      else
        rewardState = "uncomplete"
      end
      if not self.scriptData[type] then
        self.scriptData[type] = {}
      end
      table.insert(self.scriptData[type], {
        id = id,
        rewardState = rewardState,
        progress = scriptData._progress or 0,
        target = rogueScriptCfg.Target
      })
    end
  end
end

function class:initLabels()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.image_title_bg, {left = 80, top = 20}, false, true)
end

function class:refreshRedPoint()
  for index, tabBtn in ipairs(self.tabBtnList) do
    local tabBtnKey = tabBtn.tabBtnKey
    local isShowRedPoint = self.redPointState[tabBtnKey] and true or false
    tabBtn.redPoint:setVisible(isShowRedPoint)
  end
end

function class:refreshView()
  self:refreshTableView()
  self:refreshProgress()
  self:refreshRedPoint()
end

function class:initTableView()
  local panelSize = self.ui.panel_task_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.scriptList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(677, 95.5)
    end,
    createCell = function(index)
      local rogueScriptData = self.scriptList[index]
      local itemContainer, ui = self:createListItem(rogueScriptData)
      return itemContainer, {rogueScriptData = rogueScriptData, ui = ui}
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      local rogueScriptData = data.rogueScriptData
      if ed.containsPoint(ui.btn_get_reward, x, y) and ui.btn_get_reward:isVisible() then
        self:onClickBtnGetScriptReward(rogueScriptData.id)
      end
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      if ed.containsPoint(ui.btn_get_reward, x, y) then
        ui.btn_get_reward:setScale(0.95)
      end
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      local ui = data.ui
      ui.btn_get_reward:setScale(1)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_task_list,
    cliprect = CCRectMake(0, 0, panelSize.width, panelSize.height),
    colNum = 1,
    dragMode = 1,
    padding = {width = 0, height = 3},
    touchpriority = -300,
    noshade = true,
    bar = {
      bglen = panelSize.height,
      bgpos = ccp(panelSize.width, panelSize.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    }
  }
  self.tableView = Tableview.create(param)
  local shade = ed.createScale9Sprite("UI/alpha/1080P/rogue/collect/collect_destiny_tag_shade.png")
  shade:setContentSize(CCSizeMake(panelSize.width, 45))
  local clipLayer = self.tableView.dragList.clipLayer
  clipLayer:addChild(shade, 1)
  shade:setPosition(ccp(panelSize.width / 2, -5))
end

function class:createListItem(rogueScriptData)
  local container, ui = ed.editorui(ed.uieditor.rogueCollectScriptTaskItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelStroke(ui.label_done, ed.toccc3(2037784), 1)
  ed.setLabelStroke(ui.label_get_reward, ed.toccc3(4334200), 1)
  ed.setLabelStroke(ui.label_doing, ed.toccc3(8469165), 1)
  local id = rogueScriptData.id
  local rewardState = rogueScriptData.rewardState
  local rogueScriptCfg = ed.getDataTable("RogueScript")[id]
  ui.image_done:setVisible(rewardState == "complete")
  ui.btn_get_reward:setVisible(rewardState == "available")
  ui.label_doing:setVisible(rewardState == "uncomplete")
  if rewardState == "complete" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/rogue/collect/collect_script_list_doing.png")
  elseif rewardState == "available" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/rogue/collect/collect_script_list_reward.png")
  elseif rewardState == "uncomplete" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/rogue/collect/collect_script_list_done.png")
    ed.setLabelString(ui.label_progress, string.format("%s/%s", rogueScriptData.progress, rogueScriptData.target))
  end
  local desc = rogueScriptCfg.Description
  local panelDescSize = ui.panel_desc:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ccc3(255, 255, 255),
    maxWidth = panelDescSize.width,
    fontSize = 20,
    strokeColor = ed.toccc3(1973530),
    strokeSize = 1
  })
  ui.panel_desc:addChild(autoText.node)
  local _, autoTextH = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(0, panelDescSize.height / 2 + autoTextH / 2 - 10))
  local rewardDataList = {}
  for index = 1, 10 do
    local type = rogueScriptCfg[string.format("Reward Type %s", index)]
    local amount = rogueScriptCfg[string.format("Reward Amount %s", index)]
    local rewardId = rogueScriptCfg[string.format("Reward ID %s", index)]
    if not amount or amount == 0 then
      break
    end
    table.insert(rewardDataList, {
      id = rewardId,
      type = type,
      amount = amount
    })
  end
  self:createRewardItemList(ui.panel_reward_list, rewardDataList, rewardState)
  return container, ui
end

function class:createRewardItemList(container, rewardDataList, rewardState)
  local itemList = {}
  local rewardDragList = ed.UITool.createDraglist(container, {
    doPressIn = function(x, y)
      self.startClickX = x
      self.startClickY = y
      for k, v in pairs(itemList) do
        if ed.containsPoint(v.icon, x, y) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, v)
      if self.startClickX and self.startClickY and (math.abs(x - self.startClickX) > 10 or math.abs(y - self.startClickY) > 10) then
        return
      end
      local itemData = v.itemData
      if not ed.containsPoint(container, x, y) then
        return
      end
      ed.ui.packageDetailWin.create({
        id = itemData.id,
        count = itemData.amount,
        type = itemData.type
      }):popWindow()
    end,
    priority = -300
  })
  local posX, gapX = 0, -30
  for _, itemData in ipairs(rewardDataList or {}) do
    local icon = ed.createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount
    })
    if rewardState == "complete" then
      local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
      local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
      icon:addChild(mask, 1)
      icon:addChild(imageReceived, 2)
      imageReceived:setPosition(ccp(45, 40))
      mask:setPosition(ccp(45, 45))
    elseif rewardState == "available" then
      local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
      icon:addChild(eff)
      eff:setPosition(46, 45)
      eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    end
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX, container:getContentSize().height / 2))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
  return rewardDragList
end

function class:refreshTableView()
  self.scriptList = self.scriptData[self.selectTab] or {}
  table.sort(self.scriptList, ed.cmpSort({
    {
      getValue = function(t)
        if t.rewardState == "available" then
          return 0
        elseif t.rewardState == "uncomplete" then
          return 1
        end
        return 99
      end
    }
  }))
  self.tableView:reloadData()
end

function class:refreshProgress()
  ed.setLabelString(self.ui.label_total_progress, string.format("%s/%s", self.completeAmount, self.totalAmount))
end

function class:initTabBtnList()
  local panelSize = self.ui.panel_tab_btn:getContentSize()
  self.tabBtnList = {}
  local posY, gapY = 0, 10
  for index, tabBtnKey in ipairs(self.TAB_SORT or {}) do
    local btn, btnSize = self:createTabBtn(tabBtnKey)
    self.ui.panel_tab_btn:addChild(btn)
    table.insert(self.tabBtnList, btn)
    btn:setPosition(ccp(panelSize.width / 2, panelSize.height - (posY + btnSize.height / 2)))
    posY = posY + btnSize.height + gapY
  end
  self:refreshTabBtn()
  for index, btn in ipairs(self.tabBtnList) do
    self:btRegisterButtonClick({
      button = btn,
      key = "click_tab_btn" .. index,
      clickHandler = function()
        self:onClickTabBtn(btn.tabBtnKey)
      end,
      clickInterval = 0.5,
      pressScale = 0.95,
      force = true
    })
  end
end

function class:createTabBtn(tabBtnKey)
  local tabBtnCfg = self.TAB_CONFIG[tabBtnKey]
  local container = ed.createSprite()
  local size = CCSizeMake(248, 72)
  container:setContentSize(size)
  local normalBtn = ed.createSprite("UI/alpha/1080P/rogue/collect/" .. tabBtnCfg.normalPath)
  local normalBtnText = ed.ui.gradientLabel.create({
    text = tabBtnCfg.text or "",
    fontSize = 24,
    fontName = ed.fontBold,
    startColor = ed.toccc3(14665957),
    endColor = ed.toccc3(16445183),
    strokeSize = 1,
    strokeColor = ed.toccc3(6366318)
  })
  normalBtn:addChild(normalBtnText.node)
  normalBtnText.node:setPositionX(normalBtnText:getContentSize().width / 2 + 14)
  ed.layout.centerYInParent(normalBtnText.node)
  container:addChild(normalBtn)
  normalBtn:setPosition(ccp(size.width / 2, size.height / 2))
  local selectBtn = ed.createSprite("UI/alpha/1080P/rogue/collect/" .. tabBtnCfg.selectPath)
  local selectBtnText = ed.createLabelTTF(tabBtnCfg.text or "", 24)
  selectBtnText:setAnchorPoint(ccp(0, 0.5))
  selectBtnText:setFontName(ed.fontBold)
  ed.setLabelColor(selectBtnText, ccc3(255, 247, 255))
  ed.setLabelStroke(selectBtnText, ed.toccc3(15432959), 1)
  selectBtn:addChild(selectBtnText)
  selectBtnText:setPositionX(14)
  ed.layout.centerYInParent(selectBtnText)
  container:addChild(selectBtn)
  selectBtn:setPosition(ccp(size.width / 2, size.height / 2))
  local redPoint = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  container:addChild(redPoint, 2)
  redPoint:setPosition(ccp(205, 60))
  container.normalBtn = normalBtn
  container.selectBtn = selectBtn
  container.tabBtnKey = tabBtnKey
  container.tabBtnCfg = tabBtnCfg
  container.redPoint = redPoint
  return container, size
end

function class:refreshTabBtn()
  for index, tabBtn in ipairs(self.tabBtnList) do
    local tabBtnCfg = tabBtn.tabBtnCfg
    local tabBtnKey = tabBtn.tabBtnKey
    local isSelected = tabBtnKey == self.selectTab
    tabBtn.normalBtn:setVisible(not isSelected)
    tabBtn.selectBtn:setVisible(isSelected)
  end
end

function class:onClickBtnGetScriptReward(scriptId)
  ed.rogueLikeNet.sendScriptReward(scriptId)
end

function class:onClickTabBtn(tabBtnKey)
  if tabBtnKey == self.selectTab then
    return
  end
  self.selectTab = tabBtnKey
  self:refreshTabBtn()
  self:refreshTableView()
end

function class:addTouchEvent()
end

function class:addEventListener()
  self:listenEvent("rogueScriptReward", function()
    self:initScriptData()
    self:refreshView()
  end)
end
