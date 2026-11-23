local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.PeakArenaRewardWin = class
local TAB_UPGRADE_REWARD = "btn_tab1"
local TAB_WEEKLY_REWARD = "btn_tab2"
local TAB_MEDAL_REWARD = "btn_tab3"
local TAB_FINAL_RANK_REWARD = "btn_tab4"
local TAB_FINAL_GRADE_REWARD = "btn_tab5"
class.TAB_UPGRADE_REWARD = TAB_UPGRADE_REWARD
class.TAB_WEEKLY_REWARD = TAB_WEEKLY_REWARD
class.TAB_MEDAL_REWARD = TAB_MEDAL_REWARD
class.TAB_FINAL_RANK_REWARD = TAB_FINAL_RANK_REWARD
class.TAB_FINAL_GRADE_REWARD = TAB_FINAL_GRADE_REWARD
local TAB_DESC = {
  [TAB_UPGRADE_REWARD] = T("\233\166\150\230\172\161\230\174\181\228\189\141\230\153\139\229\141\135\230\151\182\239\188\140\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190\229\165\150\229\138\177"),
  [TAB_WEEKLY_REWARD] = T("\230\175\143\229\145\168\229\133\173\231\187\147\231\174\151\229\144\142\239\188\140\230\160\185\230\141\174\232\181\155\229\140\186\230\142\146\229\144\141\229\143\145\230\148\190\229\165\150\229\138\177"),
  [TAB_MEDAL_REWARD] = T("\231\180\175\231\167\175\232\142\183\229\190\151\229\139\139\231\171\160\232\190\190\229\136\176\229\175\185\229\186\148\230\149\176\233\135\143\233\162\134\229\143\150\229\165\150\229\138\177"),
  [TAB_FINAL_RANK_REWARD] = T("\232\181\155\229\173\163\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\230\156\128\231\187\136\232\181\155\229\140\186\230\142\146\229\144\141\229\143\145\230\148\190\229\165\150\229\138\177"),
  [TAB_FINAL_GRADE_REWARD] = T("\232\181\155\229\173\163\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\230\156\128\231\187\136\230\174\181\228\189\141\229\143\145\230\148\190\229\165\150\229\138\177")
}
class.TAB_DESC = TAB_DESC
local TAB_TO_TITLE_RES = {
  [TAB_UPGRADE_REWARD] = T("\230\153\139\229\141\135\229\165\150\229\138\177"),
  [TAB_WEEKLY_REWARD] = T("\229\145\168\229\165\150\229\138\177"),
  [TAB_MEDAL_REWARD] = T("\229\139\139\231\171\160\229\165\150\229\138\177"),
  [TAB_FINAL_RANK_REWARD] = T("\230\142\146\229\144\141\229\165\150\229\138\177"),
  [TAB_FINAL_GRADE_REWARD] = T("\230\174\181\228\189\141\229\165\150\229\138\177")
}
class.TAB_TO_TITLE_RES = TAB_TO_TITLE_RES
local WEEKLY_RANK_RANGE_TO_RES = {
  {
    1,
    1,
    "UI/alpha/1080P/toparena/rank/rank_1st.png",
    "UI/alpha/1080P/toparena/reward/zone_1.png",
    "UI/alpha/1080P/toparena/rank/rank_bg_1.png"
  },
  {
    2,
    2,
    "UI/alpha/1080P/toparena/rank/rank_2nd.png",
    "UI/alpha/1080P/toparena/reward/zone_2.png",
    "UI/alpha/1080P/toparena/rank/rank_bg_2.png"
  },
  {
    3,
    3,
    "UI/alpha/1080P/toparena/rank/rank_3rd.png",
    "UI/alpha/1080P/toparena/reward/zone_3.png",
    "UI/alpha/1080P/toparena/rank/rank_bg_3.png"
  }
}
local RANK_DEFAULT_BG = "UI/alpha/1080P/toparena/rank/rank_bg_normal.png"
class.WEEKLY_RANK_RANGE_TO_RES = WEEKLY_RANK_RANGE_TO_RES
class.RANK_DEFAULT_BG = RANK_DEFAULT_BG
class.REWARD_STATE_UNCOMPLETED = "reward_state_uncompleted"
class.REWARD_STATE_AVAILABLE = "reward_state_available"
class.REWARD_STATE_COMPLETED = "reward_state_completed"
local MEDAL_RES_PATH = "UI/alpha/1080P/icon/money_top_pvp_big.png"
class.MEDAL_RES_PATH = MEDAL_RES_PATH
ed.UITool.registViewOpenFunc("PeakArenaRewardWin", function(param)
  class.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("PeakArenaRewardWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:isDebug()
  return false
end

function class:init(param)
  param = param or {}
  self.tabNames = {
    TAB_UPGRADE_REWARD,
    TAB_WEEKLY_REWARD,
    TAB_FINAL_GRADE_REWARD,
    TAB_FINAL_RANK_REWARD
  }
  self.currentTabName = nil
  self.initialTabIndex = param.tabIndex or 1
  self.manager = ed.topArenaManager
  self.delegate = nil
  self.tableView = nil
  self.mgr = ed.PeakArenaManager
  self.season = self.mgr:getSeason()
  local peakArenaSeasonTB = ed.getDataTable("PeakArenaSeason")[self.season]
  self.gradeRewardGroupID = peakArenaSeasonTB["Grade Reward Group ID"]
  self.medalRewardGroupID = peakArenaSeasonTB["Medal Reward Group ID"]
  self.finalRankGroupID = peakArenaSeasonTB["Final Rank Group ID"]
  self.finalGradeGroupID = peakArenaSeasonTB["Final Grade Group ID"]
  self.weeklyRewardGroupID = peakArenaSeasonTB["Weekly Reward Group ID"]
  self.peakArenaGradeRewardTB = ed.getDataTable("PeakArenaGradeReward")
  self.peakArenaFinalGradeTB = ed.getDataTable("PeakArenaFinalGrade")
  self.peakArenaFinalRankTB = ed.getDataTable("PeakArenaFinalRank")
  self.peakArenaMedalRewardTB = ed.getDataTable("PeakArenaMedalReward")
  self.peakArenaWeeklyRewardTB = ed.getDataTable("PeakArenaWeeklyReward")
  self:initGradeReward()
  self:initWeeklyReward()
  self:initFinalGradeReward()
  self:initFinalRankReward()
  self:initMedalReward()
  self:initUI()
  self:refreshRedDot()
  self:registerTouchHandlers()
  self:registerEvents()
  self:changeTab(self.tabNames[self.initialTabIndex] or self.tabNames[1])
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRewardWin)
  self.container:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initTableView()
  for index, tabName in ipairs(self.tabNames or {}) do
    local key = string.gsub(tabName, "btn", "label")
    local normalLabel = self.ui[key]
    local selectedLabel = self.ui[key .. "_selected"]
    ed.setLabelStroke(normalLabel, ed.toccc3(4012341), 1)
    ed.setLabelStroke(selectedLabel, ed.toccc3(16775141), 1)
    normalLabel:limitWidthByScale(80)
    selectedLabel:limitWidthByScale(80)
  end
  ed.setLabelStroke(self.ui.label_info, ed.toccc3(5061672), 1)
  self.ui.label_info:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
end

function class:adaptUI()
  local scale = ed.display.winSize.width / 1035
  scale = math.min(scale, 1)
  self.changeScale = scale
  self.ui.bg:setScale(scale)
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  self.listLayerSize = size
  self.delegate = {
    numberOfCells = function()
      local rewardDataList = self:getRewardData(self.currentTabName) or {}
      return #rewardDataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(729, 80)
    end,
    createCell = function(index)
      local rewardDataList = self:getRewardData(self.currentTabName)
      local data = rewardDataList[index]
      local itemContainer, ui = self:createRewardItem(index, self.currentTabName, data)
      return itemContainer, {rewardData = data, ui = ui}
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      local rewardData = data.rewardData
      if self.currentTabName == TAB_MEDAL_REWARD then
        local index = rewardData.index
        if index and ed.containsPoint(ui.btn_get_reward, x, y) and ui.btn_get_reward:isVisible() then
          ed.PeakArenaNetwork:sendMedalReward(index)
        end
      end
    end
  }
  local param = {
    delegate = self.delegate,
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

function class:createRewardItem(index, type, data)
  local container, ui
  if type == TAB_UPGRADE_REWARD then
    container, ui = self:createUpgradeRewardItem(index, type, data)
  elseif type == TAB_WEEKLY_REWARD then
    container, ui = self:createWeeklyRewardItem(index, type, data)
  elseif type == TAB_MEDAL_REWARD then
    container, ui = self:createMedalRewardItem(index, type, data)
  elseif type == TAB_FINAL_RANK_REWARD then
    container, ui = self:createFinalRankRewardItem(index, type, data)
  elseif type == TAB_FINAL_GRADE_REWARD then
    container, ui = self:createFinalGradeRewardItem(index, type, data)
  end
  return container, ui
end

function class:createUpgradeRewardItem(index, type, data)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRewardItem)
  ui.image_upgrade_bg:setVisible(type == TAB_UPGRADE_REWARD)
  container:setContentSize(CCSizeMake(728, 80))
  local maxGradeFlag = self.mgr:getMaxGradeRewardFlag()
  if maxGradeFlag and maxGradeFlag == data.grade then
    ui.image_upgrade_highlight:setVisible(true)
  else
    ui.image_upgrade_highlight:setVisible(false)
  end
  local upgradeRewardState = self:getUpgradeRewardState(data.grade)
  if upgradeRewardState == class.REWARD_STATE_COMPLETED then
    ui.image_upgrade_achieve:setVisible(true)
    ed.setTexture(ui.image_upgrade_bg, "UI/alpha/1080P/toparena/reward/reward_bg2.png")
  else
    ui.image_upgrade_achieve:setVisible(false)
    ed.setTexture(ui.image_upgrade_bg, "UI/alpha/1080P/toparena/reward/reward_bg1.png")
  end
  ed.setTexture(ui.image_upgrade_title, self.mgr:getGradeTextRes(data.grade), true)
  ed.setTexture(ui.image_upgrade_icon, self.mgr:getGradeIconRes(data.grade), true)
  ed.setLabelStroke(ui.label_upgrade_text, ed.toccc3(3087902), 1)
  local startScore, endScore = self.mgr:getGradeScoreRange(data.grade)
  local text = endScore and string.format("%s-%s", startScore, endScore) or string.format("%s+", startScore - 1)
  local scoreRank = ed.getNumberNode({
    text = text,
    folder = "peak_score",
    scale = 0.8
  }).node
  ui.label_upgrade_text:addChild(scoreRank)
  scoreRank:setPosition(ccp(scoreRank:getContentSize().width / 2 + ui.label_upgrade_text:getContentSize().width, 7))
  if ed.isAreaZh() then
    self:createRewardItemList(ui.upgrade_reward_list, data.gradeReward)
  else
    self:createRewardItemList(ui.upgrade_reward_list, data.gradeReward)
    ui.image_upgrade_title:setPositionX(ui.image_upgrade_title:getPositionX() + 15)
    ui.image_upgrade_title:setScale(0.7)
    ui.label_upgrade_text:setPositionX(ui.label_upgrade_text:getPositionX() + 15)
    scoreRank:setPositionX(scoreRank:getPositionX() - 5)
  end
  return container, ui
end

function class:createWeeklyRewardItem(index, type, data)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRewardItem)
  ui.image_weekly_bg:setVisible(type == TAB_WEEKLY_REWARD)
  container:setContentSize(CCSizeMake(728, 80))
  ed.setLabelStroke(ui.label_my_weekly, ed.toccc3(15497535), 1)
  ui.label_my_weekly:setFontName(ed.fontBold)
  local rank = data.rank
  local myRank = self.mgr.zoneRank
  local startRank = 0
  if self.weeklyRewardList[index - 1] then
    startRank = self.weeklyRewardList[index - 1].rank
  end
  local rankingNode, itemBgPath = self:getWeeklyRewardRes(rank, startRank)
  ui.panel_weekly_ranking:addChild(rankingNode)
  ed.layout.layoutWithParentMagin(rankingNode, {left = 0})
  ed.layout.centerYInParent(rankingNode)
  ed.setTexture(ui.image_weekly_bg, itemBgPath)
  ui.image_weekly_myrank:setVisible(myRank > startRank and rank >= myRank)
  self:createRewardItemList(ui.weekly_reward_list, data.weeklyReward)
  return container, ui
end

function class:createMedalRewardItem(index, type, data)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRewardItem)
  ui.image_medal_bg:setVisible(type == TAB_MEDAL_REWARD)
  container:setContentSize(CCSizeMake(728, 80))
  if data.isHighlight then
    ed.setTexture(ui.image_medal_bg, "UI/alpha/1080P/toparena/reward/reward_bg3.png")
  end
  local medalRewardState = self:getMedalRewardState(data.index)
  ui.btn_get_reward:setVisible(medalRewardState == class.REWARD_STATE_AVAILABLE)
  ui.btn_uncomplete:setVisible(medalRewardState == class.REWARD_STATE_UNCOMPLETED)
  ui.btn_complete:setVisible(medalRewardState == class.REWARD_STATE_COMPLETED)
  local text = ed.getNumberNode({
    text = data.requireMedalAmount or 0,
    folder = "peakarena_rank",
    scale = 0.73
  }).node
  ui.panel_medal_desc:addChild(text)
  ed.layout.centerYInParent(text)
  ed.setLabelStroke(ui.label_medal_text, ed.toccc3(6046751), 1.5)
  ui.label_medal_text:setFontName(ed.fontBold)
  text:setPosition(ccp(ui.label_medal_text:getContentSize().width + text:getContentSize().width / 2 + 15, 16))
  ed.setTexture(ui.image_metal_token, MEDAL_RES_PATH, true)
  ed.layout.centerYInParent(ui.image_metal_token)
  ui.image_metal_token:setPositionX(text:getPositionX() + text:getContentSize().width / 2 + ui.image_metal_token:getContentSize().width / 2 + 8)
  ui.image_medal_mask:setVisible(medalRewardState == class.REWARD_STATE_COMPLETED)
  self:createRewardItemList(ui.medal_reward_list, data.medalRankReward)
  return container, ui
end

function class:createFinalRankRewardItem(index, type, data)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRewardItem)
  container:setContentSize(CCSizeMake(728, 80))
  ui.image_rank_bg:setVisible(type == TAB_FINAL_RANK_REWARD)
  local rank = data.rank
  local myRank = self.mgr.zoneRank
  local startRank = 0
  if self.finalRankRewardList[index - 1] then
    startRank = self.finalRankRewardList[index - 1].rank
  end
  local rankingNode, itemBgPath = self:getWeeklyRewardRes(rank, startRank)
  ui.panel_rank_ranking:addChild(rankingNode)
  ed.layout.layoutWithParentMagin(rankingNode, {left = 0})
  ed.layout.centerYInParent(rankingNode)
  ed.setTexture(ui.image_rank_bg, itemBgPath)
  ui.image_rank_myrank:setVisible(myRank > startRank and rank >= myRank)
  ed.setLabelStroke(ui.label_my_rank, ed.toccc3(15497535), 1)
  ui.label_my_rank:setFontName(ed.fontBold)
  self:createRewardItemList(ui.rank_reward_list, data.finalRankReward)
  return container, ui
end

function class:createFinalGradeRewardItem(index, type, data)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRewardItem)
  container:setContentSize(CCSizeMake(728, 80))
  ui.image_grade_bg:setVisible(type == TAB_FINAL_GRADE_REWARD)
  ui.image_grade_mygrade:setVisible(self.mgr:getGrade() == data.grade)
  ed.setLabelStroke(ui.label_my_grade, ed.toccc3(15497535), 1)
  ui.label_my_grade:setFontName(ed.fontBold)
  ui.label_my_grade:limitWidthByScale(130)
  ed.setTexture(ui.image_grade_title, self.mgr:getGradeTextRes(data.grade))
  ed.setTexture(ui.image_grade_icon, self.mgr:getGradeIconRes(data.grade))
  self:createRewardItemList(ui.grade_reward_list, data.finalGradeReward)
  if not ed.isAreaZh() then
    ui.image_grade_title:setPositionX(ui.image_grade_title:getPositionX() + 50)
  end
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
  for _, itemData in ipairs(rewardList) do
    local icon = self:createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount,
      rewardState = itemData.rewardState
    })
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX, iconSize.height / 2 - 5))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
end

function class:createItemIcon(itemData)
  local id = itemData.id
  local itemType = itemData.type
  local amount = itemData.amount
  local rewardState = itemData.rewardState
  local icon = ed.createItemIcon({
    id = id,
    type = itemType,
    amount = amount
  })
  if rewardState == class.REWARD_STATE_COMPLETED then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif rewardState == class.REWARD_STATE_AVAILABLE then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  end
  return icon
end

function class:getMedalRewardState(index)
  local medalRewardFlags = self.mgr:getMedalRewardFlags()
  local medalAmount = self.mgr:getMedal()
  local medalRewardData = self.peakArenaMedalRewardTB[self.medalRewardGroupID][index] or {}
  local requireMedalAmount = medalRewardData["Require Medal Amount"] or 0
  if ed.isElementInTable(index, medalRewardFlags) then
    return class.REWARD_STATE_COMPLETED
  elseif medalAmount >= requireMedalAmount then
    return class.REWARD_STATE_AVAILABLE
  else
    return class.REWARD_STATE_UNCOMPLETED
  end
end

function class:getUpgradeRewardState(grade)
  local upgradeRewardFlags = self.mgr:getGradeRewardFlags()
  if ed.isElementInTable(grade, upgradeRewardFlags) then
    return class.REWARD_STATE_COMPLETED
  else
    return class.REWARD_STATE_UNCOMPLETED
  end
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
  if self:isDebug() then
    print("ChangeToTab", tabName)
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
  local desc = TAB_DESC[self.currentTabName]
  ed.setLabelString(self.ui.label_info, desc)
  self.ui.label_info:limitSizeByScale(280, 25)
  ed.setLabelString(self.ui.label_title, TAB_TO_TITLE_RES[self.currentTabName])
  self.ui.label_title:limitWidthByScale(160)
  local oldSize = self.ui.bg_title_light:getContentSize()
  self.ui.bg_title_light:setContentSize(CCSizeMake(self.ui.label_title:getContentSize().width * self.ui.label_title:getScale() + 40, oldSize.height))
  self.ui.image_token_num_bg:setVisible(self.currentTabName == TAB_MEDAL_REWARD)
  ed.setLabelString(self.ui.label_token_num, string.format(T("\229\183\178\231\180\175\231\167\175:%s"), self.mgr:getMedal()))
  ed.setLabelStroke(self.ui.label_token_num, ed.toccc3(4730894), 1)
  ed.setTexture(self.ui.image_token, MEDAL_RES_PATH, true)
  local medalIconScale = 1.2
  self.ui.image_token:setScale(medalIconScale)
  local tokenBgWidth = self.ui.image_token_num_bg:getContentSize().width
  local totalWidth = self.ui.image_token:getContentSize().width + self.ui.label_token_num:getContentSize().width
  self.ui.label_token_num:setPositionX((tokenBgWidth - totalWidth) / 2 + self.ui.label_token_num:getContentSize().width / 2)
  self.ui.image_token:setPositionX(tokenBgWidth - (tokenBgWidth - totalWidth) / 2 - self.ui.image_token:getContentSize().width / 2 + 8)
  self.tableView:reloadData()
  self:refreshTableViewPosition()
end

function class:refreshTableViewPosition()
  local scrollToIndex, rewardCount
  if self.currentTabName == TAB_UPGRADE_REWARD then
    local maxGradeFlag = self.mgr:getMaxGradeRewardFlag()
    rewardCount = #(self.gradeRewardList or {})
    if maxGradeFlag then
      for index, upgradeReward in ipairs(self.gradeRewardList or {}) do
        if upgradeReward.grade == maxGradeFlag then
          scrollToIndex = index
          break
        end
      end
    end
  elseif self.currentTabName == TAB_WEEKLY_REWARD then
    rewardCount = #(self.weeklyRewardList or {})
    local myRank = self.mgr.zoneRank
    for index, weeklyReward in ipairs(self.weeklyRewardList or {}) do
      local rank = weeklyReward.rank
      if myRank <= rank then
        scrollToIndex = index
        break
      end
    end
  elseif self.currentTabName == TAB_MEDAL_REWARD then
    local firstAvailableReward, firstUncompletedReward
    rewardCount = #(self.medalRewardList or {})
    for index, medalReward in ipairs(self.medalRewardList or {}) do
      if medalReward.rewardState == class.REWARD_STATE_AVAILABLE then
        firstAvailableReward = firstAvailableReward or index
      elseif medalReward.rewardState == class.REWARD_STATE_UNCOMPLETED and not firstUncompletedReward then
        firstUncompletedReward = index
      end
    end
    if firstAvailableReward or firstUncompletedReward then
      scrollToIndex = firstAvailableReward or firstUncompletedReward
    end
  elseif self.currentTabName == TAB_FINAL_RANK_REWARD then
    rewardCount = #(self.finalRankRewardList or {})
    local myRank = self.mgr.zoneRank
    for index, finalRankReward in ipairs(self.finalRankRewardList or {}) do
      local rank = finalRankReward.rank
      if myRank <= rank then
        scrollToIndex = index
        break
      end
    end
  elseif self.currentTabName == TAB_FINAL_GRADE_REWARD then
    rewardCount = #(self.finalGradeRewardList or {})
    for index, finalGradeReward in ipairs(self.finalGradeRewardList or {}) do
      if finalGradeReward.grade == self.mgr:getGrade() then
        scrollToIndex = index
        break
      end
    end
  end
  if scrollToIndex and rewardCount then
    local listPosY = 82 * (scrollToIndex - 1)
    local totalHeight = 80 * rewardCount
    listPosY = math.min(listPosY + self.listLayerSize.height - 130, totalHeight + 13)
    listPosY = math.max(listPosY, self.listLayerSize.height)
    self.tableView:setListPos(ccp(0, listPosY))
  end
end

function class:initGradeReward()
  self.gradeRewardList = {}
  for grade, rewardInfo in ipairs(self.peakArenaGradeRewardTB[self.gradeRewardGroupID] or {}) do
    local gradeReward = {}
    local upgradeRewardState = self:getUpgradeRewardState(grade)
    for index = 1, 20 do
      local gradeRewardType = rewardInfo["Grade Reward Type " .. index]
      local gradeRewardId = rewardInfo["Grade Reward ID " .. index]
      local gradeRewardAmount = rewardInfo["Grade Reward Amount " .. index]
      if gradeRewardAmount and gradeRewardAmount ~= 0 then
        table.insert(gradeReward, {
          type = gradeRewardType,
          id = gradeRewardId,
          amount = gradeRewardAmount,
          rewardState = upgradeRewardState
        })
      end
    end
    if rewardInfo["Medal Reward"] and 0 < rewardInfo["Medal Reward"] then
      table.insert(gradeReward, {
        type = "peakmedal",
        amount = rewardInfo["Medal Reward"],
        rewardState = upgradeRewardState
      })
    end
    if rewardInfo["Coin Reward"] and 0 < rewardInfo["Coin Reward"] then
      table.insert(gradeReward, {
        type = "peakarenapoint",
        amount = rewardInfo["Coin Reward"],
        rewardState = upgradeRewardState
      })
    end
    table.insert(self.gradeRewardList, {grade = grade, gradeReward = gradeReward})
  end
  table.sort(self.gradeRewardList, ed.cmpSort({
    {key = "grade", reverse = true}
  }))
end

function class:initWeeklyReward()
  self.weeklyRewardList = {}
  for rank, rewardInfo in pairs(self.peakArenaWeeklyRewardTB[self.weeklyRewardGroupID] or {}) do
    local weeklyReward = {}
    for index = 1, 20 do
      local rewardType = rewardInfo["Reward Type " .. index]
      local rewardId = rewardInfo["Reward ID " .. index]
      local rewardAmount = rewardInfo["Reward Amount " .. index]
      if not rewardAmount or rewardAmount == 0 then
        break
      end
      table.insert(weeklyReward, {
        type = rewardType,
        id = rewardId,
        amount = rewardAmount
      })
    end
    if rewardInfo["Medal Reward"] and 0 < rewardInfo["Medal Reward"] then
      table.insert(weeklyReward, {
        type = "peakmedal",
        amount = rewardInfo["Medal Reward"]
      })
    end
    if rewardInfo["Coin Reward"] and 0 < rewardInfo["Coin Reward"] then
      table.insert(weeklyReward, {
        type = "peakarenapoint",
        amount = rewardInfo["Coin Reward"]
      })
    end
    table.insert(self.weeklyRewardList, {rank = rank, weeklyReward = weeklyReward})
  end
  table.sort(self.weeklyRewardList, ed.cmpSort({
    {key = "rank"}
  }))
end

function class:initFinalGradeReward()
  self.finalGradeRewardList = {}
  for grade, rewardInfo in ipairs(self.peakArenaFinalGradeTB[self.finalGradeGroupID] or {}) do
    local finalGradeReward = {}
    for index = 1, 20 do
      local rewardType = rewardInfo["Reward Type " .. index]
      local rewardId = rewardInfo["Reward ID " .. index]
      local rewardAmount = rewardInfo["Reward Amount " .. index]
      if not rewardAmount or rewardAmount == 0 then
        break
      end
      table.insert(finalGradeReward, {
        type = rewardType,
        id = rewardId,
        amount = rewardAmount
      })
    end
    if rewardInfo["Medal Reward"] and 0 < rewardInfo["Medal Reward"] then
      table.insert(finalGradeReward, {
        type = "peakmedal",
        amount = rewardInfo["Medal Reward"]
      })
    end
    if rewardInfo["Coin Reward"] and 0 < rewardInfo["Coin Reward"] then
      table.insert(finalGradeReward, {
        type = "peakarenapoint",
        amount = rewardInfo["Coin Reward"]
      })
    end
    table.insert(self.finalGradeRewardList, {grade = grade, finalGradeReward = finalGradeReward})
  end
  table.sort(self.finalGradeRewardList, ed.cmpSort({
    {key = "grade", reverse = true}
  }))
end

function class:initFinalRankReward()
  self.finalRankRewardList = {}
  for rank, rewardInfo in pairs(self.peakArenaFinalRankTB[self.finalRankGroupID] or {}) do
    local finalRankReward = {}
    for index = 1, 20 do
      local rewardType = rewardInfo["Reward Type " .. index]
      local rewardId = rewardInfo["Reward ID " .. index]
      local rewardAmount = rewardInfo["Reward Amount " .. index]
      if not rewardAmount or rewardAmount == 0 then
        break
      end
      table.insert(finalRankReward, {
        type = rewardType,
        id = rewardId,
        amount = rewardAmount
      })
    end
    if rewardInfo["Medal Reward"] and 0 < rewardInfo["Medal Reward"] then
      table.insert(finalRankReward, {
        type = "peakmedal",
        amount = rewardInfo["Medal Reward"]
      })
    end
    if rewardInfo["Coin Reward"] and 0 < rewardInfo["Coin Reward"] then
      table.insert(finalRankReward, {
        type = "peakarenapoint",
        amount = rewardInfo["Coin Reward"]
      })
    end
    table.insert(self.finalRankRewardList, {rank = rank, finalRankReward = finalRankReward})
  end
  table.sort(self.finalRankRewardList, ed.cmpSort({
    {key = "rank"}
  }))
end

function class:initMedalReward()
  self.medalRewardList = {}
  for index, rewardInfo in ipairs(self.peakArenaMedalRewardTB[self.medalRewardGroupID] or {}) do
    local medalRankReward = {}
    local medalRewardState = self:getMedalRewardState(index)
    for index = 1, 20 do
      local rewardType = rewardInfo["Reward Type " .. index]
      local rewardId = rewardInfo["Reward ID " .. index]
      local rewardAmount = rewardInfo["Reward Amount " .. index]
      if not rewardAmount or rewardAmount == 0 then
        break
      end
      table.insert(medalRankReward, {
        type = rewardType,
        id = rewardId,
        amount = rewardAmount,
        rewardState = medalRewardState
      })
    end
    if rewardInfo["Medal Reward"] and 0 < rewardInfo["Medal Reward"] then
      table.insert(medalRankReward, {
        type = "peakmedal",
        amount = rewardInfo["Medal Reward"]
      })
    end
    if rewardInfo["Coin Reward"] and 0 < rewardInfo["Coin Reward"] then
      table.insert(medalRankReward, {
        type = "peakarenapoint",
        amount = rewardInfo["Coin Reward"]
      })
    end
    table.insert(self.medalRewardList, {
      index = index,
      isHighlight = rewardInfo.Highlight == 1,
      rewardState = medalRewardState,
      requireMedalAmount = rewardInfo["Require Medal Amount"],
      medalRankReward = medalRankReward
    })
  end
end

function class:getRewardData(tabName)
  if tabName == TAB_UPGRADE_REWARD then
    return self.gradeRewardList
  elseif tabName == TAB_WEEKLY_REWARD then
    return self.weeklyRewardList
  elseif tabName == TAB_MEDAL_REWARD then
    return self.medalRewardList
  elseif tabName == TAB_FINAL_RANK_REWARD then
    return self.finalRankRewardList
  elseif tabName == TAB_FINAL_GRADE_REWARD then
    return self.finalGradeRewardList
  else
    return {}
  end
end

function class:getWeeklyRewardRes(rank, startRank)
  local rankingNode, bgPath
  for _, info in ipairs(class.WEEKLY_RANK_RANGE_TO_RES) do
    local startRank = info[1]
    local endRank = info[2]
    local rankingPath = info[3]
    local zonePath = info[4]
    local rankBgPath = info[5]
    if rank >= startRank and rank <= endRank then
      rankingNode = ed.createSprite(zonePath)
      local node = ed.createSprite(rankingPath)
      rankingNode:addChild(node)
      node:setPositionX(rankingNode:getContentSize().width + node:getContentSize().width / 2 + 5)
      node:setPositionY(node:getContentSize().height / 2)
      bgPath = rankBgPath
      break
    end
  end
  if not rankingNode then
    local startRank = startRank and startRank + 1 or 1
    local endRank = rank
    local autoText = ed.ui.autoText.new()
    local rankText
    if 3000 < startRank then
      rankText = "3000+"
    else
      rankText = string.format("%s-%s", startRank, endRank)
    end
    autoText:initParam({
      context = string.format("<lable color=ccc3(255,234,149) fontName=fontBold fontSize=f26 strokeColor=ccc3(84,59,43) strokeSize=1.5>%s</lable>" .. "<lable color=ccc3(255,234,149) fontSize=f26 strokeColor=ccc3(84,59,43) strokeSize=1.5>%s</lable>", T("\232\181\155\229\140\186"), rankText)
    })
    rankingNode = autoText.node
    bgPath = RANK_DEFAULT_BG
  end
  return rankingNode, bgPath
end

function class:refreshRedDot()
  local key = ed.PeakArenaRedDotTreeKeys.MedalTab
  local flag = ed.PeakArenaRedDotTree:getFlag(key)
  self.ui.btn_tab3_reddot:setVisible(flag)
end

function class:registerEvents()
  self:listenEvent("EventPeakArenaMedalReward", function()
    self:initMedalReward()
    self:refreshUI()
  end)
  self:listenEvent("PeakArenaRedDotChanged", function()
    self:refreshRedDot()
  end)
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
