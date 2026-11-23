local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.GuildMountRewardWin = class
local TAB_GUILD_REWARD = "btn_tab1"
local TAB_PERSONAL_REWARD = "btn_tab2"
class.TAB_GUILD_REWARD = TAB_GUILD_REWARD
class.TAB_PERSONAL_REWARD = TAB_PERSONAL_REWARD
local TAB_DESC = {
  [TAB_GUILD_REWARD] = T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\229\133\172\228\188\154\229\156\168\232\181\155\229\140\186\229\134\133\230\142\146\229\144\141\229\143\145\230\148\190\229\133\168\229\145\152\229\165\150\229\138\177"),
  [TAB_PERSONAL_REWARD] = T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\233\152\159\233\149\191\229\156\168\232\181\155\229\140\186\229\134\133\230\142\146\232\161\140\229\143\145\230\148\190\229\165\150\229\138\177")
}
local TAB_TO_TITLE_RES = {
  [TAB_GUILD_REWARD] = T("\229\133\172\228\188\154\229\165\150\229\138\177"),
  [TAB_PERSONAL_REWARD] = T("\228\184\170\228\186\186\229\165\150\229\138\177")
}

function class.create(param)
  local self = base.create("GuildMountRewardWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.tabNames = {TAB_GUILD_REWARD, TAB_PERSONAL_REWARD}
  self.currentTabName = nil
  self.tableView = nil
  self.initialTabIndex = param.tabIndex or 1
  if self.initialTabIndex > #self.tabNames then
    self.initialTabIndex = 1
  end
  self:initRewardData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:changeTab(self.tabNames[self.initialTabIndex])
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMountRewardWin)
  self.container:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initRewardView()
  for index, tabName in ipairs(self.tabNames or {}) do
    ed.setLabelStroke(self.ui[string.format("label_tab%s", index)], ed.toccc3(2235192), 1.5)
    ed.setLabelStroke(self.ui[string.format("label_tab%s_selected", index)], ed.toccc3(1644065), 1.5)
    self.ui[string.format("label_tab%s", index)]:limitWidthByScale(80)
    self.ui[string.format("label_tab%s_selected", index)]:limitWidthByScale(80)
  end
  if self.titleGradientTxt and not tolua.isnull(self.titleGradientTxt.node) then
    self.titleGradientTxt.node:removeFromParentAndCleanup(true)
    self.titleGradientTxt = nil
  end
  self.titleGradientTxt = ed.ui.gradientLabel.create({
    text = T("\229\133\172\228\188\154\229\165\150\229\138\177"),
    fontSize = 25,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777213),
    endColor = ed.toccc3(16711611),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(12675619)
  })
  self.ui.panel_title:addChild(self.titleGradientTxt.node)
  ed.layout.centerInParent(self.titleGradientTxt.node)
end

function class:adaptUI()
  local scale = ed.display.winSize.width / 1035
  scale = math.min(scale, 1)
  self.changeScale = scale
  self.ui.bg:setScale(scale)
end

function class:getRewardDataCount(tabName)
  if tabName == TAB_GUILD_REWARD then
    return #self.guildRewardList
  elseif tabName == TAB_PERSONAL_REWARD then
    return #self.personalRewardList
  else
    return 0
  end
end

function class:getRewardData(index, tabName)
  local list
  if tabName == TAB_GUILD_REWARD then
    list = self.guildRewardList
  elseif tabName == TAB_PERSONAL_REWARD then
    list = self.personalRewardList
  else
    list = {}
  end
  if index > #list then
    return list[1]
  else
    return list[index]
  end
end

function class:initRewardData()
  self.guildRewardList = {}
  self.personalRewardList = {}
  local guildRewardTab = ed.getDataTable("GuildMountSeasonReward")
  for _, data in ipairs(guildRewardTab) do
    local rewards = {
      {
        type = "guildmountpoint",
        amount = data["Coin Amount"]
      }
    }
    if data["OnlyShow Reward ID 1"] and data["OnlyShow Reward ID 1"] > 0 then
      table.insert(rewards, {
        type = "guildAvataFrame",
        id = data["OnlyShow Reward ID 1"],
        amount = 1
      })
    end
    table.insert(self.guildRewardList, {
      rank = data.Rank,
      rewards = rewards
    })
  end
  local personalRewardTab = ed.getDataTable("GuildMountPersonalReward")
  for _, data in ipairs(personalRewardTab) do
    local rewards = {
      {
        type = "guildmountpoint",
        amount = data["Coin Amount"]
      }
    }
    for i = 1, 5 do
      local type = data[T("Reward Type%s", i)]
      if type then
        table.insert(rewards, {
          type = type,
          id = data[T("Reward ID%s", i)],
          amount = data[T("Reward Amount%s", i)]
        })
      end
    end
    table.insert(self.personalRewardList, {
      rank = data.Rank,
      rewards = rewards
    })
  end
end

function class:initRewardView()
  local size = self.ui.list_layer:getContentSize()
  local delegate = {
    numberOfCells = function()
      return self:getRewardDataCount(self.currentTabName)
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(694, 81)
    end,
    createCell = function(index)
      local itemContainer, ui = self:createRewardItem(index, self.currentTabName)
      return itemContainer
    end,
    doClickIn = function(cell, x, y)
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true,
    padding = {width = 0, height = 2}
  }
  self.tableView = Tableview.create(param)
  if self.changeScale then
    self.tableView.dragList:refreshClipRect(self.changeScale)
  end
end

function class:createRewardItem(index, type)
  local data = self:getRewardData(index, type)
  local container, ui = ed.editorui(ed.uieditor.GuildMountRewardItem)
  container:setContentSize(self.tableView:cellSizeFromIndex(index))
  ed.layout.centerInParent(ui.bg)
  ui.panel_rank:removeAllChildrenWithCleanup(true)
  local startRankIndex
  if 1 == index then
    startRankIndex = 1
  else
    local lastData = self:getRewardData(index - 1, type)
    startRankIndex = lastData.rank + 1
  end
  local endRankIndex = data.rank
  local rankStr
  if startRankIndex == endRankIndex then
    rankStr = startRankIndex
  elseif index == self:getRewardDataCount(type) then
    rankStr = startRankIndex - 1 .. "+"
  else
    rankStr = startRankIndex .. "-" .. endRankIndex
  end
  if index < 4 then
    local startGradientColor, endGradientColor, strokeColor, shadowColor, suffixStr
    if 1 == index then
      startGradientColor = ed.toccc3(16775903)
      endGradientColor = ed.toccc3(16378216)
      strokeColor = ed.toccc3(13986871)
      shadowColor = ed.toccc3(4464392)
      suffixStr = "st"
    elseif 2 == index then
      startGradientColor = ed.toccc3(8972287)
      endGradientColor = ed.toccc3(15728127)
      strokeColor = ed.toccc3(5612769)
      shadowColor = ed.toccc3(925514)
      suffixStr = "nd"
    elseif 3 == index then
      startGradientColor = ed.toccc3(16774632)
      endGradientColor = ed.toccc3(16757898)
      strokeColor = ed.toccc3(14052957)
      shadowColor = ed.toccc3(13)
      suffixStr = "rd"
    end
    if EDCurLanguage == "es" then
      suffixStr = nil
    end
    local shadowParams = {
      {
        text = T("\232\181\155\229\140\186"),
        fontSize = 21,
        fontName = ed.fontBold,
        startColor = shadowColor,
        endColor = shadowColor,
        strokeSize = 4,
        strokeColor = shadowColor
      },
      {
        text = rankStr,
        fontSize = 36.5,
        fontName = ed.fontBold,
        startColor = shadowColor,
        endColor = shadowColor,
        strokeSize = 4,
        strokeColor = shadowColor
      }
    }
    local gradientParams = {
      {
        text = T("\232\181\155\229\140\186"),
        fontSize = 21,
        fontName = ed.fontBold,
        startColor = startGradientColor,
        endColor = endGradientColor,
        strokeSize = 3,
        strokeColor = strokeColor,
        posOffset = ccp(0, 0)
      },
      {
        text = rankStr,
        fontSize = 36.5,
        fontName = ed.fontBold,
        startColor = startGradientColor,
        endColor = endGradientColor,
        strokeSize = 3,
        strokeColor = strokeColor,
        posOffset = ccp(5, -4.5)
      }
    }
    if nil ~= suffixStr and startRankIndex == endRankIndex then
      table.insert(shadowParams, {
        text = suffixStr,
        fontSize = 25,
        fontName = ed.fontBold,
        startColor = shadowColor,
        endColor = shadowColor,
        strokeSize = 4,
        strokeColor = shadowColor
      })
      table.insert(gradientParams, {
        text = suffixStr,
        fontSize = 25,
        fontName = ed.fontBold,
        startColor = startGradientColor,
        endColor = endGradientColor,
        strokeSize = 3,
        strokeColor = strokeColor,
        posOffset = ccp(0, 0)
      })
    end
    if nil == ui.shadowTxtArr then
      ui.shadowTxtArr = {}
      ui.gradientTxtArr = {}
    end
    for i = 1, #ui.shadowTxtArr do
      ui.shadowTxtArr[i]:setVisible(false)
      ui.gradientTxtArr[i]:setVisible(false)
    end
    for i = 1, #shadowParams do
      local shadowTxt
      if i <= #ui.shadowTxtArr then
        shadowTxt = ui.shadowTxtArr[i]
        shadowTxt:setVisible(true)
      else
        shadowTxt = ed.ui.gradientLabel.create(shadowParams[i])
        shadowTxt.node:setAnchorPoint(ccp(0, 0.5))
        ui.panel_rank:addChild(shadowTxt.node)
        table.insert(ui.shadowTxtArr, shadowTxt)
      end
      local gradientTxt
      if i <= #ui.gradientTxtArr then
        gradientTxt = ui.gradientTxtArr[i]
        gradientTxt:setVisible(true)
      else
        gradientTxt = ed.ui.gradientLabel.create(gradientParams[i])
        gradientTxt.node:setAnchorPoint(ccp(0, 0.5))
        ui.panel_rank:addChild(gradientTxt.node)
        table.insert(ui.gradientTxtArr, gradientTxt)
      end
      if 1 == i then
        ed.layout.layoutWithParentMagin(gradientTxt.node, {left = 0})
        ed.layout.centerYInParent(gradientTxt.node)
      else
        local lastNode = ui.gradientTxtArr[i - 1].node
        gradientTxt.node:setPosition(ccp(lastNode:getPositionX() + lastNode:getContentSize().width + gradientParams[i].posOffset.x, lastNode:getPositionY()))
      end
      shadowTxt.node:setPosition(ccp(gradientTxt.node:getPositionX(), gradientTxt.node:getPositionY() - 3))
    end
    ui.label_zone_des:setVisible(false)
    ui.label_rank_normal:setVisible(false)
  else
    ui.label_zone_des:setVisible(true)
    ui.label_rank_normal:setVisible(true)
    ui.label_zone_des:setFontName(ed.fontBold)
    ui.label_rank_normal:setFontName(ed.fontBold)
    ed.setLabelStroke(ui.label_zone_des, ccc3(84, 59, 43), 1.5)
    ed.setLabelStroke(ui.label_rank_normal, ccc3(84, 59, 43), 1.5)
    ui.label_rank_normal:setPosition(ccp(ui.label_zone_des:getPositionX() + ui.label_zone_des:getContentSize().width, ui.label_zone_des:getPositionY()))
    ed.setLabelString(ui.label_rank_normal, rankStr)
    if nil ~= ui.shadowTxtArr then
      for i = 1, #ui.shadowTxtArr do
        ui.shadowTxtArr[i]:setVisible(false)
        ui.gradientTxtArr[i]:setVisible(false)
      end
    end
  end
  if 1 == index then
    ed.setTexture(ui.bg, "UI/alpha/1080P/guildmount/rank/first_floor.png", true)
  elseif 2 == index then
    ed.setTexture(ui.bg, "UI/alpha/1080P/guildmount/rank/second_floor.png", true)
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/guildmount/rank/third_floor.png", true)
  end
  local myRank = type == TAB_GUILD_REWARD and ed.GuildMountManager:getGuildRank() or ed.GuildMountManager:getPlayerRank()
  ui.image_my_rank:setVisible(startRankIndex <= myRank and endRankIndex >= myRank)
  self:createRewardItemList(ui.reward_panel, data.rewards)
  return container, ui
end

function class:createRewardItemList(container, rewardList)
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
      if not ed.containsPoint(self.ui.list_layer, x, y) then
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
  local posY = container:getContentSize().height / 2
  for _, itemData in ipairs(rewardList) do
    local icon = self:createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount,
      rewardState = itemData.rewardState
    })
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX, posY))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX - gapX)
end

function class:createItemIcon(itemData)
  local id = itemData.id
  local itemType = itemData.type
  local amount = itemData.amount
  local icon = ed.createItemIcon({
    id = id,
    type = itemType,
    amount = amount
  })
  return icon
end

function class:setTabButtonSelect(tabName, select)
  if tabName == self.currentTabName then
    return
  end
  local btnSelect = self.ui[tabName .. "_selected"]
  btnSelect:setVisible(select)
  local btn = self.ui[tabName]
  btn:setVisible(not select)
end

function class:changeTab(tabName)
  if tabName == self.currentTabName then
    return
  end
  self.currentTabName = nil
  for k, v in ipairs(self.tabNames) do
    local isSelected = tabName == v
    self:setTabButtonSelect(v, isSelected)
  end
  self.currentTabName = tabName
  self:refreshUI()
end

function class:refreshUI()
  local des = TAB_DESC[self.currentTabName]
  des = des .. T("(\229\189\147\229\137\141\239\188\154\231\172\172%d\232\181\155\229\140\186)", ed.GuildMountManager:getZoneId())
  ed.setLabelString(self.ui.label_info, des)
  self.ui.label_info:limitWidthByScale(600)
  if nil ~= self.titleGradientTxt then
    self.titleGradientTxt:setString(TAB_TO_TITLE_RES[self.currentTabName])
  end
  self.tableView:reloadData()
  self:refreshTableViewPosition()
end

function class:refreshTableViewPosition()
  local scrollToIndex
  if self.currentTabName == TAB_GUILD_REWARD then
    local myRank = ed.GuildMountManager:getGuildRank()
    for index, data in ipairs(self.guildRewardList or {}) do
      local rank = data.rank
      if myRank <= rank then
        scrollToIndex = index
        break
      end
    end
  elseif self.currentTabName == TAB_PERSONAL_REWARD then
    local myRank = ed.GuildMountManager:getPlayerRank()
    for index, data in ipairs(self.personalRewardList or {}) do
      local rank = data.rank
      if myRank <= rank then
        scrollToIndex = index
        break
      end
    end
  end
  if scrollToIndex then
    self.tableView:makeItemHorizontalCenterByIndex(scrollToIndex)
  end
end

function class:registerEvents()
end

function class:registerTouchHandlers()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.bg, x, y) and not ed.containsPoint(self.ui.layer_btn, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.bg, x, y) and not ed.containsPoint(self.ui.layer_btn, x, y) and self.clickOutSide then
        self:destroy()
      end
      return false
    end,
    key = "close",
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    key = "btn_close",
    pressScale = 0.98,
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      self:destroy()
    end
  })
  for k, tabName in ipairs(self.tabNames) do
    self:btRegisterButtonClick({
      button = self.ui[tabName],
      key = tabName,
      pressScale = 0.98,
      clickInterval = 0.3,
      force = true,
      clickHandler = function()
        self:changeTab(tabName)
      end
    })
  end
end

function class:destroy()
  base.destroy(self, {skipAnim = true})
end

ed.UITool.registViewOpenFunc("GuildMountRewardWin", function(param)
  class.create(param):popWindow()
end)
