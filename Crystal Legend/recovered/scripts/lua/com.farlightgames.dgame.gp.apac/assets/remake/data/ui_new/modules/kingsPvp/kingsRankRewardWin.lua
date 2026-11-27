local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.kingsRankRewardWin = class
ed.UITool.registViewOpenFunc("kingsRankRewardWin", function(param)
  ed.ui.kingsRankRewardWin.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("kingsRankRewardWin")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.seasonInfo = ed.realarena.mgr:GetSeasonInfo()
  self.seasonId = self.seasonInfo._index
  self:initUI()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:show()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.kingsRankRewardWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  self:initDragList()
  self:refreshUI()
end

function class:refreshUI()
  self:refreshDragList()
end

function class:initLabels()
  local title = ed.ui.gradientLabel.create({
    text = string.format("S%s\230\174\181\228\189\141\229\165\150\229\138\177", self.seasonId),
    fontSize = 25,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16711611),
    strokeColor = ed.toccc3(14910002),
    strokeSize = 1
  })
  local titleSize = title.node:getContentSize()
  self.ui.image_title_bg:setContentSize(CCSizeMake(titleSize.width + 30, 53))
  self.ui.image_title_bg:addChild(title.node)
  ed.layout.centerInParent(title.node)
end

function class:initDragList()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = function(x, y)
      for index, item in ipairs(self.rankUIList) do
        if ed.containsPoint(item.ui.btn_get, x, y) then
          item.ui.btn_get:setScale(0.95)
          return item
        end
      end
    end,
    cancelPressIn = function(x, y, item)
      if not tolua.isnull(item.ui.btn_get) then
        item.ui.btn_get:setScale(1)
      end
    end,
    doClickIn = function(x, y, item)
      local rankRewardCfg = item.rankRewardCfg
      local taskState = item.taskState
      if taskState == "complete" then
        ed.realarena.network_mgr:RequestGradeReward(rankRewardCfg["Reward Grade"])
      elseif taskState == "uncomplete" then
        ed.showToast(T("\229\165\150\229\138\177\230\156\170\232\190\190\230\136\144"))
      elseif taskState == "finish" then
        ed.showToast(T("\229\165\150\229\138\177\229\183\178\233\162\134\229\143\150"))
      end
    end
  })
end

function class:refreshDragList()
  local rankRewardCfgList = {}
  for _, rankRewardCfg in pairs(ed.getDataTable("KingsGradeReward")[self.seasonId]) do
    table.insert(rankRewardCfgList, rankRewardCfg)
  end
  table.sort(rankRewardCfgList, ed.cmpSort({
    {
      key = "Reward Grade",
      reverse = true
    }
  }))
  local panelSize = self.ui.panel_list:getContentSize()
  self.dragList:clearList()
  self.rankUIList = {}
  local totalHeight = 0
  local targetIndex
  for index, rankRewardCfg in ipairs(rankRewardCfgList) do
    local container, ui, taskState = self:createRankRewardItem(rankRewardCfg)
    if taskState == "complete" then
      targetIndex = index
    end
    table.insert(self.rankUIList, {
      ui = ui,
      rankRewardCfg = rankRewardCfg,
      taskState = taskState
    })
    local size = container:getContentSize()
    self.dragList:addItem(container)
    container:setPosition(ccp(panelSize.width / 2, panelSize.height - totalHeight - size.height / 2))
    totalHeight = totalHeight + size.height + 3
  end
  self.dragList:initListHeight(totalHeight)
  if targetIndex then
    local listHeight = self.dragList:getListHeight()
    local listY = math.min(listHeight - panelSize.height, (targetIndex - 1) * 83)
    self.dragList:setListPos(ccp(0, listY))
  end
end

function class:createRankRewardItem(rankRewardCfg)
  local container, ui = ed.editorui(ed.uieditor.kingsRankRewardItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.setLabelFontName(ui.label_rank_name, ed.fontBold)
  ed.setLabelStroke(ui.label_rank_name, ed.toccc3(6636583), 1.5)
  ed.setLabelStroke(ui.label_finish, ed.toccc3(2037784), 1)
  ed.setLabelShadow(ui.label_get, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(ui.label_uncomplete, ccc3(0, 0, 0), ccp(0, 2))
  local requireGradeId = rankRewardCfg["Reward Grade"]
  local kingsGradeCfg = ed.getDataTable("KingsGrade")[requireGradeId]
  local myMaxScore = ed.realarena.mgr:GetMaxScore()
  local myMaxGrade = ed.realarena.mgr:GetGradeByScore(myMaxScore)
  local gradeRewardFlag = ed.realarena.mgr:gerGradeRewardFlag({gradeId = requireGradeId})
  local taskState
  if gradeRewardFlag then
    taskState = "finish"
  elseif requireGradeId <= myMaxGrade then
    taskState = "complete"
  else
    taskState = "uncomplete"
  end
  ui.image_finish:setVisible(taskState == "finish")
  ui.btn_get:setVisible(taskState == "complete")
  ui.btn_uncomplete:setVisible(taskState == "uncomplete")
  ed.setTexture(ui.image_rank_icon, ed.realarena.mgr:getGradeIconPath({gradeId = requireGradeId}), true)
  ui.image_rank_icon:setScale(0.34)
  ed.setLabelString(ui.label_rank_name, kingsGradeCfg.Name)
  local rewardList = {}
  local rewardDragList = ed.UITool.createDraglist(ui.panel_list, {
    doPressIn = function(x, y)
      for k, v in pairs(rewardList or {}) do
        if ed.containsPoint(v.icon, x, y) then
          return v
        end
      end
    end,
    doClickIn = function(x, y, config)
      local reward = config.reward
      ed.ui.packageDetailWin.create({
        id = reward._id,
        count = reward._amount,
        type = reward._type
      }):popWindow()
    end,
    priority = -300
  })
  local posX = 0
  for index = 1, 20 do
    local rewardAmount = rankRewardCfg[string.format("Reward Amount %s", index)]
    local rewardId = rankRewardCfg[string.format("Reward ID %s", index)]
    local rewardType = rankRewardCfg[string.format("Reward Type %s", index)]
    if not rewardAmount or rewardAmount == 0 then
      break
    end
    local icon = self:createRewardIcon({
      rewardState = taskState,
      rewardId = rewardId,
      rewardType = rewardType,
      rewardAmount = rewardAmount
    })
    icon:setScale(0.8)
    rewardDragList:addItem(icon)
    table.insert(rewardList, {
      icon = icon,
      reward = {
        _id = rewardId,
        _type = rewardType,
        _amount = rewardAmount
      }
    })
    local iconWidth = icon:getContentSize().width * 0.8
    icon:setPosition(ccp(iconWidth / 2 + posX, iconWidth / 2 - 5))
    posX = posX + iconWidth - 5
  end
  return container, ui, taskState
end

function class:createRewardIcon(rewardCfg)
  local rewardId = rewardCfg.rewardId
  local rewardType = rewardCfg.rewardType
  local amount = rewardCfg.rewardAmount
  local rewardState = rewardCfg.rewardState
  local icon = ed.createItemIcon({
    id = rewardId,
    type = rewardType,
    amount = amount
  })
  if rewardState == "finish" then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setPosition(ccp(45, 40))
    mask:setPosition(ccp(45, 45))
  elseif rewardState == "complete" then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    icon:addChild(eff)
    eff:setPosition(46, 45)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  end
  return icon
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end)
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function class:addEventListener()
  self:listenEvent("RealPvpGradeReward", function()
    self:refreshUI()
  end)
end
