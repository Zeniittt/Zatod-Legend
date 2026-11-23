local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.awakeDungeonStageDetail = class
ed.UITool.registViewOpenFunc("awakeDungeonStageDetail", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("awakeDungeonStageDetail")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.stageId = param.stageId
  self.cellX = param.cellX
  self.cellY = param.cellY
  self.stageName = ""
  self.stageDesc = ""
  self.stageCost = 0
  self.vitalityIconPath = ""
  self.enemyDetailPanel = nil
  self.enemyInfoList = {}
  self.rewardItemList = {}
  self.efficiencyList = {}
  self.freeHeroList = nil
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.dungeonMgr:requestStageRecord(self.stageId)
  ed.AwakeDungeonNetwork:sendPrepareBattle(self.stageId, self.cellX, self.cellY)
  self:initView()
  self:refreshView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonStageDetail)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelStroke(self.ui.stage_name, ed.toccc3(8008718), 1.5)
  self.ui.stage_name:setFontName(ed.fontBold)
  self.ui.power_title:setHorizontalAlignment(kCCTextAlignmentRight)
  ed.adaptLabel(self.ui.power_title, {maxWidth = 100, minScale = 0.7})
  ed.adaptLabel(self.ui.reward_title, {maxWidth = 100, minScale = 0.7})
  ed.adaptLabel(self.ui.reset_label, {maxWidth = 85, minScale = 0.7})
  ed.adaptLabel(self.ui.efficiency_title, {maxWidth = 106, minScale = 0.7})
end

function class:refreshView()
  self:refreshBasic()
  self:refreshEnemy()
  self:refreshReward()
  self:refreshStageRecord()
  self:refreshBuff()
  self:refreshEfficiency()
end

function class:refreshBasic()
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local stageName = stageTableItem["Stage Name"]
  local stageDesc = stageTableItem.Description
  local cost = stageTableItem["Dungeon Vitality Cost"]
  self.stageName = stageName
  self.stageDesc = stageDesc
  self.stageCost = cost
  ed.setLabelString(self.ui.stage_name, stageName)
  self.ui.stage_desc:setDimensions(CCSizeMake(680, 60))
  ed.setLabelString(self.ui.stage_desc, stageDesc)
  ed.setLabelString(self.ui.power_number, cost)
  local powerPosX, powerPosY = self.ui.power_number:getPosition()
  local powerSize = self.ui.power_number:getContentSize()
  ed.setTexture(self.ui.power_icon, ed.awakeDungeonDefine.VITALITY_PATH, true)
  self.ui.power_icon:setPosition(ccp(powerPosX + powerSize.width + self.ui.power_icon:getContentSize().width, powerPosY))
end

function class:refreshEnemy()
  for i, v in ipairs(self.enemyInfoList) do
    self:btRemoveMainTouchHandler({
      key = "enemy" .. i
    })
  end
  self.ui.enemy_panel:removeAllChildrenWithCleanup(true)
  self.enemyDetailPanel = nil
  self.enemyInfoList = self:getEnemyInfo(self.stageId)
  table.sort(self.enemyInfoList, ed.cmpSort({
    {
      getValue = function(t)
        return t.isBoss and 1 or 0
      end
    },
    {key = "index"}
  }))
  local posX = 0
  local spaceX = 10
  local posY = self.ui.enemy_panel:getContentSize().height * 0.5
  for index, enemyInfo in ipairs(self.enemyInfoList) do
    local enemyLevel = enemyInfo.level
    local rank = ed.heroLevel2Rank(enemyLevel)
    if enemyInfo.rank and 0 < enemyInfo.rank then
      rank = enemyInfo.rank
    end
    local stars = enemyInfo.stars
    local isBoss = enemyInfo.isBoss
    local unit = ed.readhero.createIcon({
      id = enemyInfo.id,
      rank = rank,
      stars = stars,
      level = enemyLevel
    })
    local bg = unit.icon
    bg:setFlipX(true)
    local length = 65
    if isBoss then
      length = 75
    end
    bg:setPosition(posX + length * 0.5, posY)
    posX = posX + length + spaceX
    self.ui.enemy_panel:addChild(bg)
    local eScale = length / bg:getContentSize().width
    bg:setScale(eScale - 0.1)
    if isBoss then
      local tag = ed.createSprite("UI/alpha/1080P/campaign/campaign_detail_boss.png")
      tag:setPosition(ccp(60, 65))
      bg:addChild(tag, 10)
    end
    self:btRegisterButtonClick({
      button = bg,
      key = "enemy" .. index,
      force = true,
      pressHandler = function()
        local panel = ed.readequip.getDetailCard(enemyInfo.id, {
          level = enemyLevel,
          rank = rank,
          isBoss = isBoss,
          isUnit = true
        })
        local x, y = bg:getPosition()
        local size = bg:getContentSize()
        panel:setPosition(ccp(x, size.height))
        self.ui.enemy_panel:addChild(panel, 999)
        self.enemyDetailPanel = panel
      end,
      cancelPressHandler = function()
        if self.enemyDetailPanel then
          self.enemyDetailPanel:removeFromParentAndCleanup(true)
          self.enemyDetailPanel = nil
        end
      end
    })
  end
end

function class:getEnemyInfo(stageId)
  local enemyInfoList = {}
  local battleTableItem = ed.getDataTable("DungeonBattle")[stageId]
  local step = 3
  local brow = battleTableItem[step]
  if not brow then
    return enemyInfoList
  end
  local bossPos = brow["Boss Position"]
  for index = 1, 5 do
    local monsterId = brow[string.format("Monster %d ID", index)]
    if not monsterId or monsterId == 0 then
      break
    end
    local isBoss = bossPos == index
    local enemyInfo = {
      id = monsterId,
      isBoss = isBoss,
      index = index,
      stars = brow[string.format("Stars %s", index)],
      level = brow[string.format("Level %s", index)],
      res = ed.getUnitPortrait(monsterId)
    }
    table.insert(enemyInfoList, enemyInfo)
  end
  return enemyInfoList
end

function class:refreshReward()
  for i, v in ipairs(self.rewardItemList) do
    self:btRemoveMainTouchHandler({
      key = "reward" .. i
    })
  end
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  self.rewardItemList = {}
  for index = 1, 10 do
    local fdRewardType = stageTableItem[string.format("FD Reward Type %s", index)]
    local fdRewardId = stageTableItem[string.format("FD Reward ID %s", index)]
    local fdRewardAmount = stageTableItem[string.format("FD Reward Amount %s", index)]
    if not fdRewardAmount or fdRewardAmount == 0 then
      break
    end
    table.insert(self.rewardItemList, {
      id = fdRewardId,
      type = fdRewardType,
      amount = fdRewardAmount
    })
  end
  local posX = -5
  local spaceX = 2
  local posY = self.ui.reward_panel:getContentSize().height * 0.5
  self.ui.reward_panel:removeAllChildrenWithCleanup(true)
  for index, itemData in ipairs(self.rewardItemList) do
    local scale = 0.82
    local icon = ed.createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount
    })
    self.ui.reward_panel:addChild(icon)
    icon:setScale(scale)
    local iconSize = icon:getContentSize()
    icon:setPosition(posX + iconSize.width * scale * 0.5, posY)
    posX = posX + iconSize.width * scale + spaceX
    self:btRegisterButtonClick({
      button = icon,
      key = "reward" .. index,
      force = true,
      clickHandler = function()
        ed.ui.packageDetailWin.create(itemData):popWindow()
      end
    })
  end
end

function class:checkStage(times)
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local totalCost = self.stageCost * times
  local vitality = self.dungeonMgr:getCurVitality()
  if totalCost > vitality then
    ed.showToast(string.format(T("\232\131\189\233\135\143\228\184\141\232\182\179")))
    return false
  end
  return true
end

function class:onChallengeStage()
  local isOpen, reason = self.dungeonMgr:awakeDungeonIsOpen()
  if not isOpen then
    ed.showToast(reason)
    return
  end
  if not self:checkStage(1) then
    return
  end
  if nil == self.freeHeroList then
    ed.AwakeDungeonNetwork:sendPrepareBattle(self.stageId, self.cellX, self.cellY)
    return
  end
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local chapterId = stageTableItem["Chapter ID"]
  local battleData = {
    type = "Normal",
    items = self.rewardItemList,
    efficiencys = self.efficiencyList,
    titleName = self.stageName,
    detail = self.stageDesc,
    cost = self.stageCost,
    costRes = self.vitalityIconPath,
    shortDesc = self.shortDesc,
    cellX = self.cellX,
    cellY = self.cellY,
    chapterId = chapterId
  }
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "AwakeStage",
    stage_id = self.stageId,
    heroLimit = {},
    freeHeroList = self.freeHeroList,
    objData = battleData
  }))
  self:destroy({skipAnim = true})
end

function class:onClickFirstDetail()
  local awakeDungeonFirstBloodWin = ed.ui.awakeDungeonFirstBloodWin.create({
    stageId = self.stageId
  })
  awakeDungeonFirstBloodWin:popWindow()
  ed.layout.relateLayout(self.ui.image_first_blood, awakeDungeonFirstBloodWin.ui.image_bg, {bottom = 63})
end

function class:onClickBuffDetail()
  local awakeDungeonStageCfg = ed.getDataTable("DungeonStage")[self.stageId]
  if not awakeDungeonStageCfg then
    return
  end
  local chapterId = awakeDungeonStageCfg["Chapter ID"]
  local awakeDungeonBuffDetailWin = ed.ui.awakeDungeonBuffDetailWin.create({chapterId = chapterId})
  awakeDungeonBuffDetailWin:popWindow()
  ed.layout.relateLayout(self.ui.image_buff_bg, awakeDungeonBuffDetailWin.ui.image_bg, {top = 180})
end

function class:refreshStageRecord()
  local stageRecord = self.dungeonMgr:getStageRecord(self.stageId)
  if not stageRecord then
    self.ui.none_first_blood:setVisible(true)
    self.ui.image_first_blood:setVisible(false)
    return
  end
  self.ui.none_first_blood:setVisible(false)
  self.ui.image_first_blood:setVisible(true)
  local user_summary = stageRecord.userSummary
  local param = {
    id = user_summary._avatar,
    scale = 0.42
  }
  local head = ed.getWholeHeadIcon(param)
  self.ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(user_summary._name, user_summary._medal, {
    anchorPoint = ccp(0, 0.5),
    medalScale = 0.13,
    fontSize = 14
  })
  self.ui.panel_name:removeAllChildrenWithCleanup(true)
  self.ui.panel_name:addChild(name)
  name:setPosition(ccp(2, 12))
  ed.setLabelString(self.ui.label_guild, user_summary._guild_name or "")
end

function class:refreshBuff()
  local buffInfo = self.dungeonMgr:getBuffInfoByStageId(self.stageId)
  if not buffInfo then
    self.ui.image_buff_bg:setVisible(false)
    return
  end
  self.ui.image_buff_bg:setVisible(true)
  ed.setLabelString(self.ui.label_buff, ed.awakeDungeonDefine.getBuffDes(buffInfo.shortDesc))
  ed.adaptLabel(self.ui.label_buff, {maxWidth = 120, minScale = 0.6})
end

function class:refreshEfficiency()
  for i, v in ipairs(self.efficiencyList) do
    self:btRemoveMainTouchHandler({
      key = "efficiency" .. i
    })
  end
  self.efficiencyList = {}
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  table.insert(self.efficiencyList, {
    type = "item",
    id = self.dungeonMgr:getDropsId(),
    add = stageTableItem["Sweep Efficient Add"]
  })
  local posX = -5
  local spaceX = 2
  local scale = 0.82
  local posY = self.ui.efficiency_panel:getContentSize().height * 0.5
  for i, v in ipairs(self.efficiencyList) do
    local rewardIcon = ed.createItemIcon({
      type = v.type,
      id = v.id
    })
    self.ui.efficiency_panel:addChild(rewardIcon)
    rewardIcon:setScale(scale)
    local iconSize = rewardIcon:getContentSize()
    rewardIcon:setPosition(posX + iconSize.width * scale * 0.5, posY)
    posX = posX + iconSize.width * scale
    local addLabel = ed.createttf(T("+%d/\230\172\161", v.add), 15)
    self.ui.efficiency_panel:addChild(addLabel)
    addLabel:setAnchorPoint(ccp(0, 0))
    addLabel:setColor(ccc3(107, 255, 49))
    ed.setLabelStroke(addLabel, ed.toccc3(0), 1)
    addLabel:setPosition(posX, posY - 30)
    posX = posX + addLabel:getContentSize().width
    posX = posX + spaceX
    self:btRegisterButtonClick({
      button = rewardIcon,
      key = "efficiency" .. i,
      force = true,
      clickHandler = function()
        ed.ui.packageDetailWin.create(v):popWindow()
      end
    })
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy({skipAnim = true})
  end, {pressScale = 0.95, clickInterval = 0.2})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "challenge_button", function()
    self:onChallengeStage()
  end, {pressScale = 0.98, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "btn_first_blood_detail", function()
    self:onClickFirstDetail()
  end, {pressScale = 0.98, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "image_buff_bg", function()
    self:onClickBuffDetail()
  end, {pressScale = 0.98, clickInterval = 0.2})
end

function class:addEventListener()
  self:listenEvent("awakeDungeonStageRecord", function(stageId)
    if stageId == self.stageId then
      self:refreshStageRecord()
    end
  end)
  self:listenEvent("awakeDungeonPrepareBattle", function(data)
    self.freeHeroList = {}
    if nil ~= data._heroes then
      for i, v in ipairs(data._heroes) do
        table.insert(self.freeHeroList, v)
      end
    end
  end)
end
