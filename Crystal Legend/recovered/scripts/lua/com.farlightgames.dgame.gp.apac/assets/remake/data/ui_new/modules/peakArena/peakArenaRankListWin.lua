local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.PeakArenaRankListWin = class
local RANK_BG = {
  [1] = "UI/alpha/1080P/toparena/rank/rank_bg_1.png",
  [2] = "UI/alpha/1080P/toparena/rank/rank_bg_2.png",
  [3] = "UI/alpha/1080P/toparena/rank/rank_bg_3.png"
}
local DEFAULT_RANK_BG = "UI/alpha/1080P/toparena/rank/rank_bg_normal.png"
class.RANK_BG = RANK_BG
class.DEFAULT_RANK_BG = DEFAULT_RANK_BG
local RANK_TO_RESOURCES = {
  [1] = "UI/alpha/1080P/toparena/rank/rank_1st.png",
  [2] = "UI/alpha/1080P/toparena/rank/rank_2nd.png",
  [3] = "UI/alpha/1080P/toparena/rank/rank_3rd.png"
}
class.RANK_TO_RESOURCES = RANK_TO_RESOURCES
local TAB_DESC = {
  btn_all_server = T("\228\188\160\229\165\135\230\174\181\228\189\141\228\187\165\228\184\138\239\188\140\229\185\182\228\189\141\229\136\151\229\133\168\230\156\141\229\137\1413000\230\151\182\228\184\138\230\166\156"),
  btn_area = T("\232\181\155\229\140\186\230\142\146\229\144\141\229\137\1413000\230\151\182\228\184\138\230\166\156\239\188\136\229\189\147\229\137\141\232\181\155\229\140\186%s\239\188\137"),
  btn_cur_server = T("\230\156\172\230\156\141\230\142\146\229\144\141\229\137\1413000\230\151\182\228\184\138\230\166\156"),
  btn_end_all_server = T("\231\187\147\231\174\151\230\151\182\228\188\160\229\165\135\230\174\181\228\189\141\228\187\165\228\184\138\239\188\140\229\185\182\228\189\141\229\136\151\229\133\168\230\156\141\229\137\1413000\230\151\182\228\184\138\230\166\156"),
  btn_end_area = T("\231\187\147\231\174\151\230\151\182\232\181\155\229\140\186\230\142\146\229\144\141\229\137\1413000\230\151\182\228\184\138\230\166\156\239\188\136\229\189\147\229\137\141\232\181\155\229\140\186%s\239\188\137")
}
class.TAB_DESC = TAB_DESC
ed.UITool.registViewOpenFunc("PeakArenaRankListWin", function(param)
  class.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("peakArenaRankListWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:isDebug()
  return true
end

function class:init(param)
  param = param or {}
  self.mgr = ed.PeakArenaManager
  if self.mgr:isPlayoff() or self.mgr:isOffSeason() then
    self.tabNames = {
      "btn_all_server",
      "btn_area",
      "btn_cur_server",
      "btn_end_all_server",
      "btn_end_area"
    }
  else
    self.tabNames = {
      "btn_all_server",
      "btn_area",
      "btn_cur_server"
    }
  end
  self.tabNameToStep = {
    btn_all_server = "global",
    btn_area = "zone",
    btn_cur_server = "server",
    btn_end_all_server = "top",
    btn_end_area = "final_zone"
  }
  self.currentTabName = nil
  self.initialTabIndex = param.tabIndex or 2
  self.rankListData = {}
  self.myRankData = {}
  self.myRankPos = nil
  self.delegate = nil
  self.tableView = nil
  self.mgr = ed.PeakArenaManager
  self.holdNetworkReply = false
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:changeTab(self.tabNames[self.initialTabIndex])
end

function class:initExRewardInfo()
  local state = ed.PeakArenaManager:getState()
  if state and state == "playoffs" and self.currentTabName ~= "btn_end_all_server" then
    ed.setLabelStroke(self.ui.Label_4606, ed.toccc3(2434082), 1)
    ed.setString(self.ui.Label_4606, T("\229\189\147\229\137\141\229\164\132\228\186\142\228\188\145\233\151\178\232\181\155"))
    self.ui.bg_icon:setVisible(false)
  else
    ed.setLabelStroke(self.ui.Label_4606, ed.toccc3(2434082), 1)
    local rewardInfo = ed.getDataTable("PeakArenaSeason")[self.mgr:getSeason()]["Extra Reward"]
    ed.setString(self.ui.Label_4606, T("\229\133\168\230\156\141\229\137\141%d\229\144\141\233\162\157\229\164\150\232\142\183\229\190\151\229\164\180\229\131\143\230\161\134", rewardInfo[1]))
    self.ui.bg_icon:setVisible(true)
    if not self.rewarIcon then
      local icon = ed.readequip.createIcon(rewardInfo[2])
      icon:setScale(0.4)
      icon:setPosition(ccp(38, 37))
      self.ui.bg_icon:addChild(icon)
      self.rewarIcon = icon
      self:btRegisterButtonClick({
        button = icon,
        pressScale = 0.38,
        normalScale = 0.4,
        key = "extraReward",
        clickHandler = function()
          ed.ui.packageDetailWin.create({
            id = rewardInfo[2]
          }):popWindow()
        end,
        force = true
      })
    end
  end
  ed.layout.horizontalSortNode({
    self.ui.Label_4606,
    self.ui.bg_icon
  }, {-10, 0}, self.ui.bg_extra_reward:getContentSize().width * 0.5)
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRankListWin)
  self.container:addChild(container)
  self.ui = ui
  self:adaptUI()
  self:initTableView()
  self:initExRewardInfo()
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  local oldSize = self.ui.bg_title_light:getContentSize()
  self.ui.bg_title_light:setContentSize(CCSizeMake(self.ui.label_title:getContentSize().width + 40, oldSize.height))
  for _, label_name in ipairs({
    "label_all_server",
    "label_area",
    "label_cur_server",
    "label_end_all_server",
    "label_end_area"
  }) do
    local normalLabel = self.ui[label_name]
    local selectedLabel = self.ui[label_name .. "_selected"]
    ed.setLabelColor(normalLabel, ed.toccc3(16774635))
    ed.setLabelStroke(normalLabel, ed.toccc3(4012341), 1)
    ed.setLabelColor(selectedLabel, ed.toccc3(5385768))
    ed.setLabelStroke(selectedLabel, ed.toccc3(16775141), 1)
    normalLabel:limitWidthByScale(78)
    selectedLabel:limitWidthByScale(78)
  end
end

function class:adaptUI()
  local scale = ed.display.winSize.width / 1035
  scale = math.min(scale, 1)
  self.changeScale = scale
  self.ui.bg:setScale(scale)
end

function class:initTableView()
  local size = self.ui.list_layer:getContentSize()
  local offSizeHeight = size.height * (1 - self.changeScale)
  size.width = size.width * self.changeScale
  size.height = size.height * self.changeScale
  self.srcSize = size
  self.delegate = {
    numberOfCells = function()
      local step = self.tabNameToStep[self.currentTabName]
      return #(self.rankListData[step] or {})
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(728, 80)
    end,
    createCell = function(index)
      local step = self.tabNameToStep[self.currentTabName]
      local thisRankData = self.rankListData[step] or {}
      local data = thisRankData[index]
      local itemContainer, ui = self:createRankItem(index, data)
      return itemContainer, {rankData = data, ui = ui}
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      if ed.containsPoint(ui.bg, x, y) then
        return cell
      end
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      local rankData = data.rankData
      if ed.containsPoint(ui.layer_head, x, y) and not ed.newShowMedalPop then
        ed.UITool.openView("playerInfoPanel", rankData._user_summary._role_id)
      end
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.list_layer,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    offset = {0, offSizeHeight},
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true,
    padding = {width = 0, height = 2},
    doMove = self:tableViewDoMove()
  }
  self.tableView = Tableview.create(param)
end

function class:tableViewDoMove()
  local function handler()
    local x, y = self.tableView:getListPos()
    
    local listHeight = self.tableView.dragList.listHeight or 0
    if y > listHeight - 40 and listHeight > self.ui.list_layer:getContentSize().height - 40 then
      self.ui.bg_self:setVisible(false)
    else
      local step = self.tabNameToStep[self.currentTabName]
      local myRankData = self.myRankData[step]
      if not myRankData then
        self.ui.bg_self:setVisible(false)
        return
      end
      local rank = myRankData._rank
      if not rank then
        self.ui.bg_self:setVisible(false)
        return
      else
        self.ui.bg_self:setVisible(true)
      end
    end
  end
  
  return handler
end

function class:createRankItem(index, data)
  local container, ui = ed.editorui(ed.uieditor.PeakArenaRankItem)
  container:setContentSize(CCSizeMake(728, 80))
  local summary = data._user_summary
  local score = data._score or 0
  local rank = data._rank
  ed.setLabelStroke(ui.label_1, ed.toccc3(3087902), 1)
  local rankBg = RANK_BG[rank] or DEFAULT_RANK_BG
  ed.setTexture(ui.bg, rankBg)
  if RANK_TO_RESOURCES[rank] then
    local imageRanking = ed.createSprite(RANK_TO_RESOURCES[rank])
    ui.panel_rank:addChild(imageRanking)
    ed.layout.centerInParent(imageRanking)
  else
    local text = ed.getNumberNode({
      text = rank or 0,
      folder = "peakarena_rank"
    }).node
    ui.panel_rank:addChild(text)
    ed.layout.centerInParent(text)
  end
  local param = {
    id = summary._avatar,
    scale = 0.75
  }
  local head = ed.getWholeHeadIcon(param)
  ui.layer_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(summary._name, summary._medal, {left = true})
  ed.UITool.replaceUI(ui, "bg", "name", name)
  if self.currentTabName == "btn_cur_server" then
    ed.setLabelString(ui.label_server_name, summary._guild_name or " ")
  else
    ed.setLabelString(ui.label_server_name, data._svr_name or " ")
  end
  ed.setLabelColor(ui.label_server_name, ed.toccc3(16700269))
  ed.setLabelStroke(ui.label_server_name, ed.toccc3(2233605), 1)
  ui.panel_score:setPositionX(ui.label_1:getPositionX() + ui.label_1:getContentSize().width * 0.5 + 2)
  local text = ed.getNumberNode({
    text = score or 0,
    folder = "peak_score",
    scale = 0.8
  }).node
  ui.panel_score:addChild(text)
  text:setPosition(ccp(34, 22))
  local gradeTextPath = self.mgr:getGradeTextRes(data._grade)
  ed.setTexture(ui.image_grade_name, gradeTextPath)
  return container, ui
end

function class:refreshMyRank()
  local step = self.tabNameToStep[self.currentTabName]
  local myRankData = self.myRankData[step]
  if not myRankData then
    self.ui.bg_self:setVisible(false)
    return
  end
  local summary = myRankData._user_summary
  local rank = myRankData._rank
  if not rank then
    self.ui.bg_self:setVisible(false)
    return
  else
    self.ui.bg_self:setVisible(true)
  end
  local param = {
    id = summary._avatar,
    scale = 0.75
  }
  local head = ed.getWholeHeadIcon(param)
  self.ui.layer_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(summary._name, summary._medal, {left = true})
  ed.UITool.replaceUI(self.ui, "bg_self", "name", name)
  if self.currentTabName == "btn_cur_server" then
    ed.setLabelString(self.ui.label_server_name, summary._guild_name or " ")
  else
    ed.setLabelString(self.ui.label_server_name, myRankData._svr_name or " ")
  end
  ed.setLabelColor(self.ui.label_server_name, ed.toccc3(16700269))
  ed.setLabelStroke(self.ui.label_server_name, ed.toccc3(2233605), 1)
  self.ui.panel_myscore:removeAllChildrenWithCleanup(true)
  ed.setLabelStroke(self.ui.label_1, ed.toccc3(3087902), 1)
  local text = ed.getNumberNode({
    text = myRankData._score or 0,
    folder = "peak_score",
    scale = 0.8
  }).node
  self.ui.panel_myscore:addChild(text)
  text:setPosition(ccp(45, 18))
  local gradeTextPath = self.mgr:getGradeTextRes(myRankData._grade)
  ed.setTexture(self.ui.image_grade_name, gradeTextPath)
  if rank then
    self.ui.panel_myrank:setVisible(true)
    self.ui.panel_myrank:removeAllChildrenWithCleanup(true)
    if RANK_TO_RESOURCES[rank] then
      local imageRanking = ed.createSprite(RANK_TO_RESOURCES[rank])
      self.ui.panel_myrank:addChild(imageRanking)
      ed.layout.centerInParent(imageRanking)
    else
      if 3000 < rank then
        rank = "3000+"
      end
      local text = ed.getNumberNode({
        text = rank or 0,
        folder = "peakarena_rank"
      }).node
      self.ui.panel_myrank:addChild(text)
      ed.layout.centerInParent(text)
    end
  else
    self.ui.panel_myrank:setVisible(false)
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
  if self.holdNetworkReply then
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
  local size = self.srcSize
  local showTitle = {
    "btn_all_server",
    "btn_end_all_server"
  }
  local state = ed.PeakArenaManager:getState()
  if state and state == "playoffs" then
    table.insert(showTitle, "btn_area")
    table.insert(showTitle, "btn_cur_server")
  end
  if ed.isElementInTable(tabName, showTitle) then
    self.tableView.dragList:initClipRect(CCRectMake(0, 0, size.width, size.height - 34))
    self.ui.bg_extra_reward:setVisible(true)
  else
    self.tableView.dragList:initClipRect(CCRectMake(0, 0, size.width, size.height))
    self.ui.bg_extra_reward:setVisible(false)
  end
  local step = self.tabNameToStep[tabName]
  if step and self.rankListData[step] then
    self:refreshUI()
  else
    self:reqTabData(step)
    self.holdNetworkReply = true
  end
end

function class:reqTabData(step)
  ed.PeakArenaNetwork:sendBottomRankboard(step)
end

function class:refreshUI()
  local step = self.tabNameToStep[self.currentTabName]
  if #(self.rankListData[step] or {}) <= 0 then
    self.ui.label_nobody:setVisible(true)
  else
    self.ui.label_nobody:setVisible(false)
  end
  if self.currentTabName == "btn_area" or self.currentTabName == "btn_end_area" then
    ed.setLabelString(self.ui.label_info, string.format(TAB_DESC[self.currentTabName], self.mgr:getZone()))
  else
    ed.setLabelString(self.ui.label_info, TAB_DESC[self.currentTabName] or "")
  end
  ed.setLabelStroke(self.ui.label_info, ed.toccc3(5061672), 1)
  self.ui.label_info:limitSizeByScale(280, 25)
  self:refreshMyRank()
  self.tableView:reloadData()
  self:initExRewardInfo()
end

function class:registerEvents()
  self:listenEvent("EventPeakArenaScoreRankBoard", function(data)
    self.holdNetworkReply = false
    local step = self.tabNameToStep[self.currentTabName]
    self.rankListData[step] = data._rank_list
    self.myRankData[step] = data._self_rank
    self.myRankPos = data._self_pos
    self:refreshUI()
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
    pressScale = 0.98,
    key = "btn_close",
    force = true,
    clickInterval = 0.3,
    clickHandler = function()
      self:destroy()
    end
  })
  for k, tabName in ipairs(self.tabNames) do
    self:btRegisterButtonClick({
      button = self.ui[tabName],
      key = tabName,
      pressScale = 0.95,
      clickInterval = 0.3,
      force = true,
      clickHandler = function()
        self:changeTab(tabName)
      end
    })
  end
  self:btRegisterButtonClick({
    button = self.ui.layer_head,
    key = "layer_head",
    force = true,
    clickInterval = 0.3,
    clickHandler = function()
      if not ed.newShowMedalPop then
        ed.UITool.openView("playerInfoPanel", ed.getRoleId())
      end
    end
  })
end

function class:destroy()
  base.destroy(self, {skipAnim = true})
end
