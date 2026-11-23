local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.adventureStageDetail = class
ed.UITool.registViewOpenFunc("adventureStageDetail", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("adventureStageDetail")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.actId = param.actId
  self.stageId = param.stageId
  self.actAdventureCfg = ed.getDataTable("ActivityAdventure")[self.actId]
  self.actAdventureBattleTB = ed.getDataTable("ActivityAdventureBattle")
  self.actAdventureStageTB = ed.getDataTable("ActivityAdventureStage")
  self.enemyInfoList = {}
  self.enemyDetailPanel = nil
  self.adventureMgr = ed.actiAdventureMgr.getInstance()
  self.rewardItemList = {}
  self.stageName = ""
  self.stageDesc = ""
  self.vitalityIconPath = ""
  self:initView()
  self:refreshView()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_adventure_stage_detail)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelColor(self.ui.stage_name, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.stage_name, ed.toccc3(3553610), 1.5)
  ed.setLabelColor(self.ui.history_title, ed.toccc3(16776423))
  ed.setLabelShadow(self.ui.history_title, ed.toccc3(0), ccp(0, 1.5))
  ed.setLabelColor(self.ui.sweep_title, ed.toccc3(16776423))
  ed.setLabelShadow(self.ui.sweep_title, ed.toccc3(0), ccp(0, 1.5))
  ed.setLabelColor(self.ui.history_number, ed.toccc3(16753969))
  ed.setLabelShadow(self.ui.history_number, ed.toccc3(0), ccp(0, 1.5))
  ed.setLabelColor(self.ui.sweep_reward_number, ed.toccc3(16753969))
  ed.setLabelShadow(self.ui.sweep_reward_number, ed.toccc3(0), ccp(0, 1.5))
  self.ui.image_line_right:setScaleX(-1)
  self.ui.reset_label:limitWidthByScale(70)
  ed.setLabelDimensions(self.ui.stage_desc, CCSizeMake(670, 0))
  ed.setLabelDimensions(self.ui.award_title, CCSizeMake(82, 0))
  ed.layout.layoutWithMagin(self.ui.image_left_arrow, {left = 78})
  ed.layout.layoutWithMagin(self.ui.image_right_arrow, {right = 78})
  local leftPosX, leftPosY = self.ui.image_left_arrow:getPosition()
  local lmove = CCMoveTo:create(1, ccp(leftPosX - 10, leftPosY))
  local lreverse = CCMoveTo:create(1, ccp(leftPosX, leftPosY))
  local lsequence = CCSequence:createWithTwoActions(lmove, lreverse)
  self.ui.image_left_arrow:runAction(CCRepeatForever:create(lsequence))
  local rightPosX, rightPosY = self.ui.image_right_arrow:getPosition()
  local rmove = CCMoveTo:create(1, ccp(rightPosX + 10, rightPosY))
  local rreverse = CCMoveTo:create(1, ccp(rightPosX, rightPosY))
  local rsequence = CCSequence:createWithTwoActions(rmove, rreverse)
  self.ui.image_right_arrow:runAction(CCRepeatForever:create(rsequence))
end

function class:refreshView()
  self.stageState = self.adventureMgr:getStageState(self.actId, self.stageId)
  local adventureStageCfg = self.actAdventureStageTB[self.stageId]
  local stageName = adventureStageCfg["Stage Name"]
  local stageDesc = adventureStageCfg.description
  local cost = adventureStageCfg["Vitality Cost"]
  local vitalityIconPath = self.actAdventureCfg["Vitality Icon"]
  self.stageName = stageName
  self.stageDesc = stageDesc
  self.vitalityIconPath = vitalityIconPath
  ed.setLabelString(self.ui.stage_name, stageName)
  ed.setLabelString(self.ui.stage_desc, stageDesc)
  ed.setLabelString(self.ui.power_number, cost)
  local titlePath = self.actAdventureCfg["Adventure Stage Title"]
  ed.setTexture(self.ui.title, titlePath)
  ed.setTexture(self.ui.power_icon, vitalityIconPath, true)
  ed.layout.horizontalSortNode({
    self.ui.power_title,
    self.ui.power_number,
    self.ui.power_icon
  }, {
    18,
    10,
    0
  }, self.ui.power_title:getPositionX(), 0)
  self:refreshEnemy()
  self:refreshReward()
  local stageInfo = self.adventureMgr:getStageInfoById(self.actId, self.stageId)
  local maxAddition = stageInfo and stageInfo._max_addition or 0
  ed.setLabelString(self.ui.history_number, string.format("%s%%", maxAddition / 100))
  ed.right2(self.ui.history_number, self.ui.history_title, 0)
  local baseTokenReward = adventureStageCfg["Token Amount"]
  local totalTokenAmount = math.floor(baseTokenReward * (1 + maxAddition / 10000) * 100) / 100
  ed.setLabelString(self.ui.sweep_reward_number, math.ceil(totalTokenAmount))
  ed.right2(self.ui.sweep_reward_number, self.ui.sweep_title, 0)
  local tokenIconPath = self.actAdventureCfg["Token Icon"]
  ed.setTexture(self.ui.sweep_reward_icon, tokenIconPath, true)
  local rewardPosX, rewardPosY = self.ui.sweep_reward_number:getPosition()
  local rewardSize = self.ui.sweep_reward_number:getContentSize()
  self.ui.sweep_reward_icon:setPosition(ccp(rewardPosX + rewardSize.width + self.ui.sweep_reward_icon:getContentSize().width * 0.7, rewardPosY))
  self:refreshBtn()
  local showLeftArrow = self:checkSwitchStage(-1)
  local showRightArrow = self:checkSwitchStage(1)
  self.ui.image_left_arrow:setVisible(showLeftArrow)
  self.ui.image_right_arrow:setVisible(showRightArrow)
  self:refreshSweepLimit()
end

function class:refreshSweepLimit()
  self.sweepLimit = 10
  local power = tonumber(self.ui.power_number:getString())
  local vitality = self.adventureMgr:getAdventureVitality(self.actId)
  if power <= vitality then
    self.sweepLimit = math.max(math.min(self.sweepLimit, math.floor(vitality / power)), 1)
  end
  self.ui.sweep_some_label:setString(T("\230\137\171\232\141\161%s\230\172\161", self.sweepLimit))
end

function class:refreshBtn()
  local stageState = self.adventureMgr:getStageState(self.actId, self.stageId)
  local sweepVisible
  if stageState == ed.adventureDefine.STAGE_STATE_PASSED then
    sweepVisible = true
  else
    sweepVisible = false
  end
  self.ui.sweep_one_button:setVisible(sweepVisible)
  self.ui.sweep_some_button:setVisible(sweepVisible)
  self.ui.history_title:setVisible(sweepVisible)
  self.ui.history_number:setVisible(sweepVisible)
  self.ui.sweep_title:setVisible(sweepVisible)
  self.ui.sweep_reward_icon:setVisible(sweepVisible)
  self.ui.sweep_reward_number:setVisible(sweepVisible)
  local challengeBtnRes, labelColor
  if stageState == ed.adventureDefine.STAGE_STATE_PASSED or stageState == ed.adventureDefine.STAGE_STATE_CURRENT then
    challengeBtnRes = "UI/alpha/1080P/common/buttion_big.png"
    labelColor = 16642206
    ed.updateSpriteGray(self.ui.go_button_img, false)
  else
    challengeBtnRes = "UI/alpha/1080P/common/button_big_grey.png"
    labelColor = 15790320
    ed.updateSpriteGray(self.ui.go_button_img, true)
  end
  ed.setLabelColor(self.ui.reset_label, ed.toccc3(labelColor))
  ed.initSpriteWithFrame(self.ui.challenge_button, challengeBtnRes)
end

function class:refreshEnemy()
  local ox, oy = 140, 7
  self.ui.enemy_title:removeAllChildrenWithCleanup(true)
  if self.enemyDetailPanel then
    self.enemyDetailPanel:removeFromParentAndCleanup(true)
    self.enemyDetailPanel = nil
  end
  local enemtInfoList = self:getEnemyInfo(self.stageId)
  table.sort(enemtInfoList, ed.cmpSort({
    {
      getValue = function(o)
        return o.isBoss and 1 or 0
      end
    },
    {key = "index"}
  }))
  for index, enemyInfo in ipairs(enemtInfoList) do
    if enemyInfo then
      local enemyLevel = enemyInfo.level
      local rank = ed.heroLevel2Rank(enemyLevel)
      if enemyInfo.rank and enemyInfo.rank > 0 then
        rank = enemyInfo.rank
      end
      local stars = enemyInfo.stars
      local shard = enemyInfo.shard
      local heroTs = {
        id = enemyInfo.id,
        rank = rank,
        stars = stars,
        shard = shard
      }
      local unit = ed.readhero.createIcon(heroTs)
      local bg = unit.icon
      bg:setFlipX(true)
      local pos
      local length = 65
      if enemyInfo.isBoss == true then
        pos = ccp(ox + 77 * (index - 1) + 5, oy)
        length = 75
      else
        pos = ccp(ox + 77 * (index - 1), oy)
      end
      bg:setPosition(pos)
      self.ui.enemy_title:addChild(bg)
      local eScale = length / bg:getContentSize().width
      bg:setScale(eScale - 0.1)
      if enemyInfo.isBoss == true then
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
            level = enemyInfo.level,
            rank = enemyInfo.rank,
            isBoss = enemyInfo.isBoss,
            isUnit = true
          }, nil, enemyInfo.shard)
          local x, y = bg:getPosition()
          local size = bg:getContentSize()
          panel:setPosition(ccp(x, y + size.height - 60))
          self.ui.enemy_title:addChild(panel, 10)
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
end

function class:getEnemyInfo(stageId)
  local enemyInfoList = {}
  local battleCfg = self.actAdventureBattleTB[stageId]
  local step = 3
  local brow = battleCfg[step]
  local bossPos = brow["Boss Position"]
  local k = self.adventureMgr:getDifficultyRatio(self.actId)
  for index = 1, 5 do
    local monsterId = brow[string.format("Monster %d ID", index)]
    if not monsterId or monsterId == 0 then
      break
    end
    local isBoss = bossPos == index
    local minLevel = brow[string.format("MinLevel %s", index)]
    local maxLevel = brow[string.format("MaxLevel %s", index)]
    local shardId = brow[string.format("Shard ID %s", index)]
    local shardLevel = brow[string.format("Shard Level %s", index)]
    local shard
    if 0 < shardId then
      shard = {_id = shardId, _level = shardLevel}
    end
    local level = math.floor(k * (maxLevel - minLevel) + minLevel)
    local enemyInfo = {
      id = monsterId,
      isBoss = isBoss,
      index = index,
      stars = brow[string.format("Stars %s", index)],
      level = level,
      res = ed.getUnitPortrait(monsterId),
      shard = shard
    }
    table.insert(enemyInfoList, enemyInfo)
  end
  return enemyInfoList
end

function class:refreshReward()
  local adventureStageCfg = self.actAdventureStageTB[self.stageId]
  self.rewardItemList = {}
  if self.stageState ~= ed.adventureDefine.STAGE_STATE_PASSED then
    for index = 1, 10 do
      local fdRewardType = adventureStageCfg[string.format("FD Reward Type %s", index)]
      if not fdRewardType then
        break
      end
      local fdRewardId = adventureStageCfg[string.format("FD Reward ID %s", index)]
      local fdRewardAmount = adventureStageCfg[string.format("FD Reward Amount %s", index)]
      table.insert(self.rewardItemList, {
        id = fdRewardId,
        type = fdRewardType,
        amount = fdRewardAmount,
        isOne = true
      })
    end
  end
  table.insert(self.rewardItemList, {
    type = "adventurePoint",
    amount = adventureStageCfg["Token Amount"],
    isOne = false
  })
  local ox = 65
  self.ui.award_title:removeAllChildrenWithCleanup(true)
  for index, itemData in ipairs(self.rewardItemList) do
    local scale = 0.85
    local icon = ed.createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount
    })
    self.ui.award_title:addChild(icon)
    icon:setScale(scale)
    local iconSize = icon:getContentSize()
    ed.layout.centerYInParent(icon)
    icon:setPositionX(index * iconSize.width * scale + ox)
    if itemData.isOne then
      local firstTag = ed.createSprite("UI/alpha/1080P/skilltower/icon_first.png")
      icon:addChild(firstTag)
      firstTag:setPosition(ccp(15, iconSize.height * scale + 5))
      firstTag:setZOrder(1)
      local labelFirst = ed.createttf(T("\233\166\150\230\172\161"), 11)
      ed.setLabelColor(labelFirst, ed.toccc3(16776919))
      firstTag:addChild(labelFirst)
      labelFirst:setPosition(ccp(24, 16.5))
    end
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
  local adventureStageCfg = ed.getDataTable("ActivityAdventureStage")[self.stageId]
  local cost = adventureStageCfg["Vitality Cost"]
  local totalCost = cost * times
  local vitality = self.adventureMgr:getAdventureVitality(self.actId)
  local vitalityId = ed.adventureDefine.getAdventureVitalityId(self.actId)
  local itemName = ed.getDataTable("equip")[vitalityId].Name
  if totalCost > vitality then
    ed.showToast(string.format(T("%s\228\184\141\232\182\179"), itemName))
    return false
  end
  return true
end

function class:challengeStage()
  local adventureStageCfg = ed.getDataTable("ActivityAdventureStage")[self.stageId]
  if self.stageState == ed.adventureDefine.STAGE_STATE_LOCKED then
    ed.showToast(T("\229\133\179\229\141\161\230\156\170\232\167\163\233\148\129"))
    return false
  elseif self.stageState == ed.adventureDefine.STAGE_STATE_TIME_LOCKED then
    local openTime = self.adventureMgr:getStageOpenTime(self.actId, self.stageId)
    local year, month, day, hour, minute, second = ed.time2YMDHMS(openTime)
    ed.showToast(string.format(T("%d\230\156\136%d\230\151\165%d\230\151\182\229\188\128\229\144\175"), month, day, hour))
    return false
  elseif self.stageState == ed.adventureDefine.STAGE_STATE_ENDING then
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
    return false
  end
  if not self:checkStage(1) then
    return
  end
  local cost = adventureStageCfg["Vitality Cost"]
  local battleData = {
    items = self.rewardItemList,
    titleName = self.stageName,
    detail = self.stageDesc,
    cost = cost,
    costRes = self.vitalityIconPath,
    difficultyRatio = self.adventureMgr:getDifficultyRatio(self.actId)
  }
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "ActivityAdventure",
    activityAdventureId = self.actId,
    stage_id = self.stageId,
    heroLimit = {},
    objData = battleData
  }))
  self:destroy({skipAnim = true})
end

function class:sweepStage(sweepTimes)
  if self.stageState ~= ed.adventureDefine.STAGE_STATE_PASSED then
    ed.showToast(T("\229\133\179\229\141\161\230\156\170\233\128\154\229\133\179"))
    return false
  end
  if not self:checkStage(sweepTimes) then
    return
  end
  ed.actiAdventureNet.sweep(self.actId, self.stageId, sweepTimes)
  ed.actiAdventureNet.openPanel()
end

function class:checkSwitchStage(step)
  local newStageId = self.stageId + step
  if not self.actAdventureStageTB[newStageId] then
    return false
  end
  return true
end

function class:switchStage(step)
  if not self:checkSwitchStage(step) then
    ed.showToast(T("\229\133\179\229\141\161\230\156\170\232\167\163\233\148\129"))
    return
  end
  local newStageId = self.stageId + step
  self.stageId = newStageId
  self:refreshView()
end

function class:addEventListener()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event ~= "ended" then
        return false
      end
      if ed.containsPoint(self.ui.image_left_arrow, x, y) then
        return false
      end
      if ed.containsPoint(self.ui.image_right_arrow, x, y) then
        return false
      end
      if not ed.containsPoint(self.ui.image_bg, x, y) then
        self:close()
        return false
      end
      return false
    end,
    key = "close"
  })
  self:btRegisterButtonClick({
    button = self.ui.sweep_one_button,
    press = self.ui.sweep_one_button_press,
    pressScale = 0.98,
    clickInterval = 0.2,
    clickHandler = function(event, x, y)
      self:sweepStage(1)
    end,
    key = "sweep_one"
  })
  self:btRegisterButtonClick({
    button = self.ui.sweep_some_button,
    press = self.ui.sweep_some_button_press,
    pressScale = 0.98,
    clickInterval = 0.2,
    clickHandler = function(event, x, y)
      self:sweepStage(self.sweepLimit)
    end,
    key = "sweep_ten"
  })
  self:btRegisterButtonClick({
    button = self.ui.challenge_button,
    press = self.ui.challenge_button_press,
    pressScale = 0.98,
    clickInterval = 0.2,
    clickHandler = function(event, x, y)
      self:challengeStage()
    end,
    key = "challenge"
  })
  self:btRegisterButtonClick({
    button = self.ui.image_left_arrow,
    press = self.ui.image_left_arrow_press,
    pressScale = 1.58,
    normalScale = 1.6,
    clickInterval = 0.2,
    clickHandler = function(event, x, y)
      self:switchStage(-1)
    end,
    key = "left_arrow"
  })
  self:btRegisterButtonClick({
    button = self.ui.image_right_arrow,
    press = self.ui.image_right_arrow_press,
    pressScale = 1.58,
    normalScale = 1.6,
    clickInterval = 0.2,
    clickHandler = function(event, x, y)
      self:switchStage(1)
    end,
    key = "right_arrow"
  })
  self:listenEvent("ResourceNumChange", function(resType, id)
    if resType == "adventurePoint" or resType == "adventureVitality" then
      self:refreshSweepLimit()
    end
  end)
  self:listenEvent("refreshAdventureInfo", function(actId)
    if actId == self.actId then
      self:refreshSweepLimit()
    end
  end)
end

function class:close()
  self:destroy()
end
