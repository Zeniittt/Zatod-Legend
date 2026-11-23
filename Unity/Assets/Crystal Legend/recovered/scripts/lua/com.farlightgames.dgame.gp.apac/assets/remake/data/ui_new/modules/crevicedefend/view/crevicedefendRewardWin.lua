local base = ed.ui.popwindow
local CreviceDefendRewardWin = newclass(base.mt)
ed.ui.CreviceDefendRewardWin = CreviceDefendRewardWin
local RANK_RANGE_TO_RES = {
  [1] = {
    rankImage = "UI/alpha/1080P/toparena/rank/rank_1st.png",
    zoneBg = "UI/alpha/1080P/toparena/reward/zone_1.png",
    bg = "UI/alpha/1080P/crevicedefend/rewardlist1.png"
  },
  [2] = {
    rankImage = "UI/alpha/1080P/toparena/rank/rank_2nd.png",
    zoneBg = "UI/alpha/1080P/toparena/reward/zone_2.png",
    bg = "UI/alpha/1080P/crevicedefend/rewardlist2.png"
  },
  [3] = {
    rankImage = "UI/alpha/1080P/toparena/rank/rank_3rd.png",
    zoneBg = "UI/alpha/1080P/toparena/reward/zone_3.png",
    bg = "UI/alpha/1080P/crevicedefend/rewardlist3.png"
  },
  [4] = {
    bg = "UI/alpha/1080P/crevicedefend/rewardlistnormal.png"
  }
}
CreviceDefendRewardWin.RANK_RANGE_TO_RES = RANK_RANGE_TO_RES

function CreviceDefendRewardWin.create(data)
  local self = base.create("CreviceDefendRewardWin")
  setmetatable(self, CreviceDefendRewardWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:adaptUI()
  self:popWindow()
  return self
end

function CreviceDefendRewardWin:adaptUI()
  local localDesignScale = 2.1666666666666665
  local localFixedWidth = ed.display.designSize.height * localDesignScale - ed.display.designSize.width
  local adaptRatio = math.min(ed.display.halfFixedWidth * 2 / localFixedWidth, 1)
end

function CreviceDefendRewardWin:initData()
  self:initConfig()
end

function CreviceDefendRewardWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function CreviceDefendRewardWin:registerEvents()
end

function CreviceDefendRewardWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRewardWin)
  self.ui = ui
  self.container:addChild(container)
  local title_node = ed.ui.gradientLabel.create({
    text = T("\231\187\147\231\174\151\229\165\150\229\138\177"),
    fontSize = 25,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16767652),
    endColor = ed.toccc3(16751190),
    strokeSize = 1,
    strokeColor = ed.toccc3(1901829)
  })
  self.ui.layer_title:addChild(title_node.node)
  ed.setLabelColor(self.ui.label_zone_des, ccc3(255, 188, 116))
  local zoneId = ed.CreviceDefendManager:getZoneId()
  ed.setString(self.ui.label_zone_des, string.format(T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142, \230\160\185\230\141\174\233\152\159\233\149\191\229\156\168\232\181\155\229\140\186\229\134\133\231\154\132\230\142\146\232\161\140\229\143\145\230\148\190\229\165\150\229\138\177 (\229\189\147\229\137\141\239\188\154\231\172\172%s\232\181\155\229\140\186)"), zoneId))
  self:createRewardList()
end

function CreviceDefendRewardWin:initConfig()
  self.rewardArr = {}
  self.creviceDefendRewardConfig = ed.getDataTable("CreviceDefendReward")
  for i, v in pairs(self.creviceDefendRewardConfig) do
    self.rewardArr[v.ID] = v
  end
  for i, v in ipairs(self.rewardArr) do
    local target_rank = v.Rank
    if target_rank <= 3 then
      v.startRank = target_rank
      v.endRank = target_rank
    else
      v.startRank = self.rewardArr[i - 1].endRank + 1
      v.endRank = target_rank
    end
  end
  self:initRewardList(self.rewardArr)
end

function CreviceDefendRewardWin:initRewardList(rewardArr)
  for id, rewardConfig in ipairs(rewardArr or {}) do
    local finalReward = {}
    local config = self.creviceDefendRewardConfig[id]
    for index = 1, 4 do
      local rewardId = config["Reward ID" .. index]
      local rewardType = config["Reward Type" .. index]
      local rewardAmount = config["Reward Amount" .. index]
      if 0 ~= rewardId and 0 <= rewardAmount then
        table.insert(finalReward, {
          type = rewardType,
          id = rewardId,
          amount = rewardAmount
        })
      end
    end
    rewardArr[rewardConfig.ID].finalReward = finalReward
  end
end

function CreviceDefendRewardWin:createRewardList()
  local size = self.ui.panel_record:getContentSize()
  local delegate = {
    numberOfCells = function()
      return #self.rewardArr
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(680, 90)
    end,
    createCell = function(index)
      return self:createRewardItem(index, self.rewardArr[index])
    end,
    syncCell = function(cell, index)
      local container, ui = self:createRewardItem(index, self.rewardArr[index])
      return container
    end
  }
  local param = {
    delegate = delegate,
    container = self.ui.panel_record,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    offset = {340, 45},
    touchpriority = -300,
    noshade = true
  }
  self.recordTableview = Tableview.create(param)
  self.recordTableview:reloadData()
end

function CreviceDefendRewardWin:createRewardItem(index, rewardData)
  local container, ui = ed.editorui(ed.uieditor.crevicedefendRewardItem)
  container:setContentSize(ui.bg:getContentSize())
  ui.idx = index
  ui.label_damage:setFontName(ed.fontBold)
  ed.setLabelColor(ui.label_damage, ed.toccc3(16760426))
  local rankValue = rewardData.Rank
  local uiConfig = RANK_RANGE_TO_RES[rankValue]
  if rankValue <= 3 then
    ed.setTexture(ui.image_rank, uiConfig.rankImage, true)
    ed.setTexture(ui.Image_zone, uiConfig.zoneBg, true)
    ed.setTexture(ui.bg, uiConfig.bg)
    ui.label_rank:setVisible(false)
    ui.image_rank:setVisible(true)
    ui.Image_zone:setVisible(true)
  else
    ui.label_rank:setVisible(true)
    ui.image_rank:setVisible(false)
    ui.Image_zone:setVisible(false)
    ed.setTexture(ui.bg, RANK_RANGE_TO_RES[4].bg)
  end
  local myRank = ed.CreviceDefendManager:getSeasonRank()
  local startRank = rewardData.startRank
  local endRank = rewardData.endRank
  ed.setString(ui.label_rank, string.format(T("\232\181\155\229\140\186 %s-%s"), startRank, endRank))
  if myRank <= 3 then
    ui.bg_select:setVisible(myRank == endRank)
    ui.image_rewardme:setVisible(myRank == endRank)
  else
    ui.bg_select:setVisible(myRank >= startRank and myRank <= endRank)
    ui.image_rewardme:setVisible(myRank >= startRank and myRank <= endRank)
  end
  ed.setLabelColor(ui.label_rank, ed.toccc3(16760426))
  self:createRewardItemList(ui.root_icon_new, rewardData.finalReward)
  return container, ui
end

function CreviceDefendRewardWin:createRewardItemList(container, rewardList)
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
  local posX, gapX = 0, -20
  for _, itemData in ipairs(rewardList) do
    local icon = self:createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount,
      rewardState = itemData.rewardState
    })
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX, iconSize.height / 2 - 10))
    icon:setScale(0.75)
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
end

function CreviceDefendRewardWin:createItemIcon(itemData)
  local id = itemData.id
  local itemType = itemData.type
  local amount = itemData.amount
  local rewardState = itemData.rewardState
  local icon = ed.createItemIcon({
    id = id,
    type = itemType,
    amount = amount
  })
  return icon
end
