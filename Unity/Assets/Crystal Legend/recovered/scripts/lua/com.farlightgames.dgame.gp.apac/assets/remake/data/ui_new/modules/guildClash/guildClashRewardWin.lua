local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.guildClashRewardWin = class
local TAB_SETTLE_REWARD = "settleReward"
local TAB_SETTLE_REWARD_KING = "settleReward_King"
local TAB_SETTLE_REWARD_GOLD = "settleReward_Gold"
local TAB_SETTLE_REWARD_SILVER = "settleReward_Silver"
local TAB_TURN_REWARD = "turnReward"
local TAB_TURN_REWARD_KING = "turnReward_King"
local TAB_TURN_REWARD_GOLD = "turnReward_Gold"
local TAB_TURN_REWARD_SILVER = "turnReward_Silver"
local GRADE_ID_TO_NAME = {
  [1] = T("\230\151\160\229\174\154\231\186\167"),
  [2] = T("\231\153\189\233\147\182\230\136\152\229\140\186"),
  [3] = T("\233\187\132\233\135\145\230\136\152\229\140\186"),
  [4] = T("\231\142\139\232\128\133\230\136\152\229\140\186")
}
class.GRADE_ID_TO_NAME = GRADE_ID_TO_NAME
local GRADE_ID_TO_INDEX = {
  [1] = 0,
  [2] = 2,
  [3] = 1,
  [4] = 0
}
class.GRADE_ID_TO_INDEX = GRADE_ID_TO_INDEX
local treeList = {
  {
    name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\231\187\147\231\174\151\229\165\150\229\138\177</lable> "),
    name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\231\187\147\231\174\151\229\165\150\229\138\177</lable> "),
    limitWidth = 90,
    data = {mainTab = TAB_SETTLE_REWARD},
    tree = {
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\142\139\232\128\133\230\136\152\229\140\186</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\142\139\232\128\133\230\136\152\229\140\186</lable>"),
        data = {mainTab = TAB_SETTLE_REWARD, tab = TAB_SETTLE_REWARD_KING},
        limitWidth = 90
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\233\187\132\233\135\145\230\136\152\229\140\186</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\233\187\132\233\135\145\230\136\152\229\140\186</lable>"),
        data = {mainTab = TAB_SETTLE_REWARD, tab = TAB_SETTLE_REWARD_GOLD},
        limitWidth = 90
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\153\189\233\147\182\230\136\152\229\140\186</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\153\189\233\147\182\230\136\152\229\140\186</lable>"),
        data = {mainTab = TAB_SETTLE_REWARD, tab = TAB_SETTLE_REWARD_SILVER},
        limitWidth = 90
      }
    }
  },
  {
    name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\230\175\143\232\189\174\229\165\150\229\138\177</lable> "),
    name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\230\175\143\232\189\174\229\165\150\229\138\177</lable> "),
    data = {mainTab = TAB_TURN_REWARD},
    limitWidth = 90,
    tree = {
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\142\139\232\128\133\230\136\152\229\140\186</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\142\139\232\128\133\230\136\152\229\140\186</lable>"),
        data = {mainTab = TAB_TURN_REWARD, tab = TAB_TURN_REWARD_KING},
        limitWidth = 90
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\233\187\132\233\135\145\230\136\152\229\140\186</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\233\187\132\233\135\145\230\136\152\229\140\186</lable>"),
        data = {mainTab = TAB_TURN_REWARD, tab = TAB_TURN_REWARD_GOLD},
        limitWidth = 90
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\153\189\233\147\182\230\136\152\229\140\186</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\153\189\233\147\182\230\136\152\229\140\186</lable>"),
        data = {mainTab = TAB_TURN_REWARD, tab = TAB_TURN_REWARD_SILVER},
        limitWidth = 90
      }
    }
  }
}
class.treeList = treeList
local treeBtnRes = {
  {
    normal = "UI/alpha/1080P/rankingscene/tab1.png",
    press = "UI/alpha/1080P/rankingscene/tab4.png",
    height = 46
  },
  {
    normal = "",
    press = "UI/alpha/1080P/rankingscene/tab2.png",
    height = 38
  },
  {
    normal = "",
    press = "UI/alpha/1080P/rankingscene/tab3.png",
    height = 33
  }
}
class.treeBtnRes = treeBtnRes
ed.UITool.registViewOpenFunc("guildClashRewardWin", function(param)
  local win = class.create(param)
  win:popWindow()
end)

function class.create(param)
  local self = base.create("guildClashRewardWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.tabName = {
    TAB_SETTLE_REWARD_KING,
    TAB_SETTLE_REWARD_GOLD,
    TAB_SETTLE_REWARD_SILVER,
    TAB_TURN_REWARD_KING,
    TAB_TURN_REWARD_GOLD,
    TAB_TURN_REWARD_SILVER
  }
  self.curMainTab = TAB_SETTLE_REWARD
  self.currentTab = param.tabName or TAB_SETTLE_REWARD_KING
  self:initPerRewardData()
  self:initFinalRewardData()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initPerRewardData()
  local guildClashPerRewardTB = ed.getDataTable("GuildClashPerReward")
  self.perReward = {}
  for index = 1, 20 do
    local guildClashPerRewardCfg = guildClashPerRewardTB[index]
    if not guildClashPerRewardCfg then
      break
    end
    local gradeId = guildClashPerRewardCfg["Grade ID"]
    if not self.perReward[gradeId] then
      self.perReward[gradeId] = {}
    end
    local winRewardList = {}
    local loseRewardList = {}
    for rewardIndex = 1, 20 do
      local winRewardAmount = guildClashPerRewardCfg["Win Reward Amount " .. rewardIndex]
      local loseRewardAmount = guildClashPerRewardCfg["Lose Reward Amount " .. rewardIndex]
      if winRewardAmount and winRewardAmount ~= 0 then
        table.insert(winRewardList, {
          type = guildClashPerRewardCfg["Win Reward Type " .. rewardIndex],
          id = guildClashPerRewardCfg["Win Reward ID " .. rewardIndex],
          amount = winRewardAmount
        })
      end
      if loseRewardAmount and loseRewardAmount ~= 0 then
        table.insert(loseRewardList, {
          type = guildClashPerRewardCfg["Lose Reward Type " .. rewardIndex],
          id = guildClashPerRewardCfg["Lose Reward ID " .. rewardIndex],
          amount = loseRewardAmount
        })
      end
    end
    table.insert(self.perReward[gradeId], {
      gradeId = gradeId,
      rewardType = "win",
      reward = winRewardList
    })
    table.insert(self.perReward[gradeId], {
      gradeId = gradeId,
      rewardType = "lose",
      reward = loseRewardList
    })
  end
end

function class:initFinalRewardData()
  self.finalReward = {}
  local guildClashFinalRewardTB = ed.getDataTable("GuildClashFinalReward")
  for index = 1, 999 do
    local guildClashFinalRewardCfg = guildClashFinalRewardTB[index]
    if not guildClashFinalRewardCfg then
      break
    end
    local gradeId = guildClashFinalRewardCfg["Grade ID"]
    local winTimes = guildClashFinalRewardCfg["Win Times"]
    local battleTimes = guildClashFinalRewardCfg["Battle Times"]
    if battleTimes == 4 then
      local rewardList = {}
      for rewardIndex = 1, 20 do
        local amount = guildClashFinalRewardCfg["Reward Amount " .. rewardIndex]
        if not amount or amount == 0 then
          break
        end
        table.insert(rewardList, {
          type = guildClashFinalRewardCfg["Reward Type " .. rewardIndex],
          id = guildClashFinalRewardCfg["Reward ID " .. rewardIndex],
          amount = amount
        })
      end
      if guildClashFinalRewardCfg["OnlyShow Reward ID 1"] and 0 < guildClashFinalRewardCfg["OnlyShow Reward ID 1"] then
        table.insert(rewardList, {
          type = "guildAvataFrame",
          id = guildClashFinalRewardCfg["OnlyShow Reward ID 1"],
          amount = 1
        })
      end
      if not self.finalReward[gradeId] then
        self.finalReward[gradeId] = {}
      end
      table.insert(self.finalReward[gradeId], {
        gradeId = gradeId,
        winTimes = winTimes,
        reward = rewardList
      })
    end
  end
  for gradeId, list in pairs(self.finalReward) do
    table.sort(list, ed.cmpSort({
      {key = "winTimes", reverse = true}
    }))
  end
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashAwardWin)
  self.container:addChild(container)
  self.ui = ui
  local title_label = ed.createLabelTTF(T("\231\187\147\231\174\151\229\165\150\229\138\177"), 26, ed.fontBold)
  ed.setLabelColor(title_label, ed.toccc3(16711628))
  ui.image_title:setContentSize(CCSizeMake(title_label:getContentSize().width + 5, ui.image_title:getContentSize().height))
  self.title_label = title_label
  ui.image_title:addChild(title_label)
  ed.layout.centerInParent(title_label)
  self:initTableView()
  local rateInfo = ed.GuildClashManager:getRateInfo()
  local gradeId = rateInfo._grade or 0
  treeList[1].data.selectedIdx = {
    GRADE_ID_TO_INDEX[gradeId] or 0
  }
  treeList[2].data.selectedIdx = {
    GRADE_ID_TO_INDEX[gradeId] or 0
  }
  self.accordionList = self:initTabList()
  self.accordionList:passTreeIndex(true, 1, GRADE_ID_TO_INDEX[gradeId] and GRADE_ID_TO_INDEX[gradeId] + 1 or 1)
end

function class:adaptUI()
  local scale = ed.display.winSize.width / 1035
  scale = math.min(scale, 1)
  self.changeScale = scale
  self.ui.bg:setScale(scale)
end

function class:initTableView()
  local size = self.ui.panel_reward_list:getContentSize()
  self.listLayerSize = size
  self.delegate = {
    numberOfCells = function()
      local rewardDataList = self:getRewardData(self.currentTab) or {}
      return #rewardDataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(729, 80)
    end,
    createCell = function(index)
      local rewardDataList = self:getRewardData(self.currentTab)
      local data = rewardDataList[index]
      local itemContainer, ui = self:createRewardItem(index, self.currentTab, data)
      return itemContainer, {rewardData = data, ui = ui}
    end,
    doClickIn = function(cell, x, y)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_reward_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    noshade = true,
    offset = {7, 0},
    padding = {width = 0, height = 2}
  }
  self.tableView = Tableview.create(param)
  if self.changeScale then
    self.tableView.dragList:refreshClipRect(self.changeScale)
  end
end

function class:initTabList(data)
  data = treeList
  local accordion = ed.accordion.createAccordion(self.ui.panel_tab_list, {
    vertex = {
      winLeft = -70,
      winRight = 0,
      winTop = 10,
      winBottom = 10
    },
    doClickOut = function(isPas, itemData)
      self:onClickTab(itemData)
    end,
    doAllClickOut = function(isLeaf, isPas, itemData)
    end,
    isBoom = true,
    treeBtnRes = treeBtnRes,
    anchor = 0,
    isTakeBack = true,
    priority = -514
  })
  accordion:addAcclist(data)
  local gradeId = ed.GuildClashManager:getRateInfo()._grade
  if gradeId and 1 < gradeId then
    for _, index in ipairs({
      5 - gradeId,
      8 - gradeId
    }) do
      local node = accordion:getIndexAccDragNode(2, index)
      if node and node.node then
        local btn_width = node.node:getContentSize().width
        local label_width = ed.createLabelTTF(T("\231\142\139\232\128\133\230\136\152\229\140\186"), 16):getContentSize().width
        local comWidth = btn_width + label_width
        local labelCurrent = ed.createttf(T("(\229\189\147\229\137\141)"), 16)
        ed.setLabelColor(labelCurrent, ccc3(196, 196, 196))
        labelCurrent:setAnchorPoint(ccp(0, 0.5))
        node.node:addChild(labelCurrent, 1)
        labelCurrent:setPosition(ccp(comWidth * 0.5 - 5, 15))
        local labelCurPress = ed.createttf(T("(\229\189\147\229\137\141)"), 16)
        ed.setLabelColor(labelCurPress, ccc3(255, 245, 235))
        labelCurPress:setAnchorPoint(ccp(0, 0.5))
        node.press:addChild(labelCurPress, 1)
        labelCurPress:setPosition(ccp(comWidth * 0.5 - 5, 15))
      end
    end
  end
  return accordion
end

function class:getRewardData(tabName)
  if tabName == TAB_SETTLE_REWARD_KING then
    return self.finalReward[4]
  elseif tabName == TAB_SETTLE_REWARD_GOLD then
    return self.finalReward[3]
  elseif tabName == TAB_SETTLE_REWARD_SILVER then
    return self.finalReward[2]
  elseif tabName == TAB_TURN_REWARD_KING then
    return self.perReward[4]
  elseif tabName == TAB_TURN_REWARD_GOLD then
    return self.perReward[3]
  elseif tabName == TAB_TURN_REWARD_SILVER then
    return self.perReward[2]
  else
    return {}
  end
end

function class:refreshView()
  local titleString, desc
  if self.curMainTab == TAB_SETTLE_REWARD then
    titleString = T("\231\187\147\231\174\151\229\165\150\229\138\177")
    desc = T("\230\137\128\230\156\137\230\175\148\232\181\155\231\187\147\230\157\159\229\144\142\239\188\140\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190")
  else
    titleString = T("\230\175\143\232\189\174\229\165\150\229\138\177")
    desc = T("\230\175\143\232\189\174\230\175\148\232\181\155\231\187\147\230\157\159\229\144\142\239\188\140\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190")
  end
  ed.setLabelString(self.title_label, titleString)
  self.ui.image_title:setContentSize(CCSizeMake(self.title_label:getContentSize().width + 5, self.ui.image_title:getContentSize().height))
  ed.layout.centerInParent(self.title_label)
  self.ui.panel_desc:removeAllChildrenWithCleanup(true)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ccc3(67, 59, 56),
    fontSize = 15,
    maxWidth = 712
  })
  self.ui.panel_desc:addChild(autoText.node)
  ed.layout.centerYInParent(autoText.node)
  local width, height = autoText:getCurContentSize()
  autoText.node:setPositionX((self.ui.panel_desc:getContentSize().width - width) / 2)
  self:refreshTableView()
end

function class:refreshTableView()
  self.tableView:reloadData()
end

function class:createRewardItem(index, currentTab, data)
  local container, ui = ed.editorui(ed.uieditor.GuildClashAwardItem)
  container:setContentSize(CCSizeMake(728, 80))
  local desc
  if ed.isElementInTable(currentTab, {
    TAB_SETTLE_REWARD_KING,
    TAB_SETTLE_REWARD_GOLD,
    TAB_SETTLE_REWARD_SILVER
  }) then
    local winTimes = data.winTimes
    local gradeId = data.gradeId
    desc = T("<lable fontName=fontBold>%s</lable>") .. "<sprite folder=peak_rank folderText=%s>" .. T("<lable fontName=fontBold>\232\131\156\229\165\150\229\138\177</lable>")
    desc = string.format(desc, self.GRADE_ID_TO_NAME[gradeId], winTimes)
  else
    local isWin = data.rewardType == "win"
    local gradeId = data.gradeId
    if isWin then
      desc = T("<lable fontName=fontBold>%s \230\175\143\232\189\174</lable><lable color=ccc3(255,227,130)>\232\142\183\232\131\156</lable>")
    else
      desc = T("<lable fontName=fontBold>%s \230\175\143\232\189\174</lable><lable color=ccc3(255,227,130)>\232\180\159</lable>")
    end
    desc = string.format(desc, self.GRADE_ID_TO_NAME[gradeId])
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ccc3(255, 252, 243),
    strokeColor = ed.toccc3(8473618),
    strokeSize = 1,
    fontSize = 22
  })
  ui.panel_desc:addChild(autoText.node)
  autoText:limitWidthByScale(270)
  ed.layout.centerYInParent(autoText.node)
  self:createRewardItemList(ui.panel_item_list, data.reward)
  return container, ui
end

function class:createRewardItemList(container, rewardDataList)
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
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX, iconSize.height / 2 - 12))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
  return rewardDragList
end

function class:onClickTab(itemData)
  local mainTab = itemData.mainTab
  local tab = itemData.tab
  self.curMainTab = mainTab
  self.currentTab = tab
  self:refreshView()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end)
end

function class:addEventListener()
end
