local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.AwakeDungeonBossStageDetail = class
class.TITLE_LABEL_STROKE = {
  [1] = ed.toccc3(4545048),
  [2] = ed.toccc3(1918065),
  [3] = ed.toccc3(4923726),
  [4] = ed.toccc3(6954535)
}
ed.UITool.registViewOpenFunc("awakeDungeonBossStageDetail", function(param)
  param = param or {}
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("awakeDungeonBossStageDetail")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.cellX = param.cellX
  self.cellY = param.cellY
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.curProgressVal = self.dungeonMgr:getCurStageProgress(self.cellX, self.cellY)
  local stageTableItem = ed.getDataTable("DungeonStage")[param.stageId]
  local bossGroup = stageTableItem["Boss Group"] or 0
  if 0 == bossGroup then
    ed.showToast("DungeonStage Boss Group \230\149\176\230\141\174\230\156\170\233\133\141\231\189\174" .. buildingTile.config.id)
  end
  self.curIndex = 0
  self.bossTableItemArr = {}
  local bossTableItemGroup = ed.getDataTable("DungeonBoss")[bossGroup]
  for i, v in ipairs(bossTableItemGroup) do
    if self.curProgressVal >= v["Boss Difficulty"] * ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS then
      self.curIndex = i + 1
    end
    table.insert(self.bossTableItemArr, v)
  end
  self.curIndex = ed.clamp(self.curIndex, 1, #self.bossTableItemArr)
  local maxTableItem = self.bossTableItemArr[self.curIndex]
  self.unlockDifficulty = maxTableItem["Boss Difficulty"]
  self.dungeonMgr:requestStageRecord(maxTableItem["Stage ID"])
  self.bossHeroId = nil
  self:initView()
  self:refreshView()
  self:checkShowWarningEff()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonBossStageDetail)
  self.ui = ui
  self.container:addChild(container)
  self:initDifficultyBtn()
  ed.setLabelStroke(self.ui.label_boss_name, ed.toccc3(5914403), 1)
  self.ui.label_boss_name:setFontName(ed.fontBold)
  self.ui.label_boss_level:setFontName(ed.fontBold)
  self.ui.label_title:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_boss_history, ed.toccc3(1578259), 1)
  self.ui.label_boss_history:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_next_reward, ed.toccc3(1578259), 1)
  self.ui.label_next_reward:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.single_reward_text, ed.toccc3(1578259), 1)
  ed.setLabelStroke(self.ui.boss_history_text, ed.toccc3(1578259), 1)
  ed.setLabelStroke(self.ui.label_cost, ed.toccc3(1578259), 1)
  ed.setLabelStroke(self.ui.label_warning_tips, ed.toccc3(3807003), 1)
  ed.setLabelShadow(self.ui.label_challenge, ed.toccc3(0), ccp(0, 1))
  ed.setLabelStroke(self.ui.label_select_1, ed.toccc3(3905607), 1)
  ed.setLabelStroke(self.ui.label_select_2, ed.toccc3(1031656), 1)
  ed.setLabelStroke(self.ui.label_select_3, ed.toccc3(14369252), 1)
  ed.setLabelStroke(self.ui.label_select_4, ed.toccc3(15483436), 1)
  ed.setLabelFontName(self.ui.label_select_1, ed.fontBold)
  ed.setLabelFontName(self.ui.label_select_2, ed.fontBold)
  ed.setLabelFontName(self.ui.label_select_3, ed.fontBold)
  ed.setLabelFontName(self.ui.label_select_4, ed.fontBold)
  if EDCurLanguage == "en" then
    self.ui.label_select_1:setFontSize(16.25)
    self.ui.label_difficulty_1:setFontSize(16.25)
    self.ui.label_select_2:setFontSize(20)
    self.ui.label_difficulty_2:setFontSize(20)
    self.ui.label_select_3:setFontSize(13)
    self.ui.label_difficulty_3:setFontSize(13)
    self.ui.label_select_4:setFontSize(17)
    self.ui.label_difficulty_4:setFontSize(17)
  else
    self.ui.label_select_1:setFontSize(21.25)
    self.ui.label_difficulty_1:setFontSize(21.25)
    self.ui.label_select_2:setFontSize(20)
    self.ui.label_difficulty_2:setFontSize(20)
    self.ui.label_select_3:setFontSize(21)
    self.ui.label_difficulty_3:setFontSize(21)
    self.ui.label_select_4:setFontSize(21)
    self.ui.label_difficulty_4:setFontSize(21)
  end
  ed.adaptLabel(self.ui.label_warning_tips, {maxWidth = 200, minScale = 0.8})
  ed.adaptLabel(self.ui.boss_history_text, {maxWidth = 170, minScale = 0.7})
  ed.adaptLabel(self.ui.newx_reward_text, {maxWidth = 170, minScale = 0.7})
  ed.right2(self.ui.label_boss_history, self.ui.boss_history_text, 2)
  ed.right2(self.ui.label_next_reward, self.ui.newx_reward_text, 2)
  ed.adaptLabel(self.ui.label_next_reward, {maxWidth = 80, minScale = 0.7})
  local ox = self.ui.btn_reward_detail:getPositionX()
  ed.right2(self.ui.btn_reward_detail, self.ui.label_next_reward, 1)
  self.ui.btn_reward_detail:setPositionX(math.max(ox, self.ui.btn_reward_detail:getPositionX()))
end

function class:initUnlockFca(i)
  local label_config = {
    [1] = {
      color = ed.toccc3(16776423),
      fontSize = 21.25,
      en_fontSize = 16.25,
      strokeColor = ed.toccc3(3905607),
      strokeSize = 1,
      fontName = ed.fontBold,
      text = T("\230\153\174\233\128\154"),
      suffix = ""
    },
    [2] = {
      color = ed.toccc3(16776423),
      fontSize = 20,
      en_fontSize = 20,
      strokeColor = ed.toccc3(1031656),
      strokeSize = 1,
      fontName = ed.fontBold,
      text = T("\229\155\176\233\154\190"),
      suffix = "_2"
    },
    [3] = {
      color = ed.toccc3(16776423),
      fontSize = 21,
      en_fontSize = 13,
      strokeColor = ed.toccc3(14369252),
      strokeSize = 1,
      fontName = ed.fontBold,
      text = T("\230\162\166\233\173\135"),
      suffix = "_3"
    },
    [4] = {
      color = ed.toccc3(16776423),
      fontSize = 21,
      en_fontSize = 17,
      strokeColor = ed.toccc3(15483436),
      strokeSize = 1,
      fontName = ed.fontBold,
      text = T("\233\133\183\229\136\145"),
      suffix = "_4"
    }
  }
  local config = label_config[i]
  local fontSize = EDCurLanguage == "en" and config.en_fontSize or config.fontSize
  local label = ed.createLabelTTF(config.text, fontSize, config.fontName)
  ed.setLabelColor(label, config.color)
  ed.setLabelStroke(label, config.strokeColor, config.strokeSize)
  label:setPosition(ccp(0.8, 1.8))
  local label_node = CCSprite:create()
  label_node:addChild(label)
  self.unlockFca:addNodeToComponent(label_node, "Node" .. config.suffix, 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  label_node:setCascadeOpacityEnabled(true)
  label_node:setOpacity(0)
  self.ui["FCA_Label_" .. i] = label_node
end

function class:initDifficultyBtn()
  local btnConfig = {
    [1] = {scale = 0.8, rotation = 10},
    [2] = {scale = 0.9, rotation = 180},
    [3] = {scale = 1, rotation = 22},
    [4] = {scale = 1, rotation = 22}
  }
  for index = 1, 4 do
    local bossTableItem = self.bossTableItemArr[index]
    local difficulty = bossTableItem["Boss Difficulty"]
    local stageId = bossTableItem["Stage ID"]
    local isLock = difficulty > self.unlockDifficulty
    local color = isLock and ccc3(102, 102, 102) or ccc3(255, 255, 255)
    local btnScale = btnConfig[index].scale
    local rotation = btnConfig[index].rotation
    self.ui["label_difficulty_" .. index]:setFontName(ed.fontBold)
    self.ui["image_unselect_" .. index]:setVisible(false)
    local button2 = ed.createFcaActor("eff_UI_Dungeon_button2", 1)
    self:addFca(button2)
    self.ui["btn_effect_button2_" .. index] = button2
    button2:setAction("Loop")
    self.ui["btn_difficulty_" .. index]:addChild(button2)
    button2:setRotation(rotation)
    button2:setColor(color)
    ed.layout.centerInParent(button2)
    local button1 = ed.createFcaActor("eff_UI_Dungeon_button", 1)
    self:addFca(button1)
    self.ui["btn_effect_button_" .. index] = button1
    button1:setAction("Loop")
    self.ui["btn_difficulty_" .. index]:addChild(button1)
    button1:setColor(color)
    ed.layout.centerInParent(button1)
    local btnUnlock = ed.createFcaActor("eff_UI_Dungeon_button_Unlock", 1)
    self.unlockFca = btnUnlock
    self:initUnlockFca(index)
    self:addFca(btnUnlock)
    self.ui["btn_effect_Unlock_" .. index] = btnUnlock
    if isLock then
      btnUnlock:setAction("Start")
      btnUnlock:setLoop(true)
    else
      local key = ed.getRoleKey(string.format("dungeon_stage_unlock_%s", stageId))
      if not ed.storage.getBool(key) then
        self:playUnlockAction(index)
        ed.storage.setValue(key, true)
      else
        btnUnlock:setVisible(false)
      end
    end
    self.ui["btn_difficulty_" .. index]:addChild(btnUnlock, 999)
    if index == 1 or index == 2 then
      btnUnlock:setPosition(ccp(32, 36))
    else
      btnUnlock:setPosition(ccp(37, 41))
    end
    self.ui["btn_difficulty_" .. index]:setScale(btnScale)
  end
end

function class:playUnlockAction(index)
  local difficultyLabel = self.ui["label_difficulty_" .. index]
  local selectLabel = self.ui["label_select_" .. index]
  local btnUnlock = self.ui["btn_effect_Unlock_" .. index]
  local fcaLabel = self.ui["FCA_Label_" .. index]
  btnUnlock:setVisible(true)
  difficultyLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3333333333333333), CCFadeOut:create(0.4166666666666667)))
  selectLabel:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3333333333333333), CCFadeOut:create(0.4166666666666667)))
  fcaLabel:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.75), CCFadeIn:create(0.5), CCCallFunc:create(function()
    difficultyLabel:setOpacity(255)
    selectLabel:setOpacity(255)
    btnUnlock:setVisible(false)
  end))))
  btnUnlock:setAction("Start_" .. index)
end

function class:stopUnlockAction(index)
  local btnUnlock = self.ui["btn_effect_Unlock_" .. index]
  if nil == btnUnlock then
    return
  end
  local difficultyLabel = self.ui["label_difficulty_" .. index]
  local selectLabel = self.ui["label_select_" .. index]
  local fcaLabel = self.ui["FCA_Label_" .. index]
  difficultyLabel:stopAllActions()
  selectLabel:stopAllActions()
  fcaLabel:stopAllActions()
  btnUnlock:setVisible(false)
  difficultyLabel:setOpacity(255)
  selectLabel:setOpacity(255)
end

function class:refreshView()
  self:refreshDifficultyBtn()
  self:refreshBoss()
  self:refreshStageInfo()
  self:refreshChallengeInfo()
  self:refreshStageRecord()
  self:refreshBuff()
end

function class:refreshDifficultyBtn()
  for index, tableItem in ipairs(self.bossTableItemArr) do
    local difficulty = tableItem["Boss Difficulty"]
    local stageId = tableItem["Stage ID"]
    local isSelect = self.curIndex == index
    local isLock = difficulty > self.unlockDifficulty
    self.ui["image_unselect_" .. index]:setVisible(not isSelect)
    self.ui["image_select_" .. index]:setVisible(isSelect)
    local btnUnlock = self.ui["btn_effect_Unlock_" .. index]
    local key = ed.getRoleKey(string.format("dungeon_stage_unlock_%s", stageId))
    if not isLock then
      self.ui["btn_effect_button_" .. index]:setColor(ccc3(255, 255, 255))
      self.ui["btn_effect_button2_" .. index]:setColor(ccc3(255, 255, 255))
      if not ed.storage.getBool(key) then
        self:playUnlockAction(index)
        ed.storage.setValue(key, true)
      else
        btnUnlock:setVisible(false)
      end
    end
  end
end

function class:refreshBoss()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local difficulty = bossTableItem["Boss Difficulty"]
  local stageId = bossTableItem["Stage ID"]
  local bossSize = bossTableItem["Boss Size"]
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  local bossName = bossTableItem["Boss Name"]
  ed.setLabelString(self.ui.label_boss_name, bossName)
  ed.adaptLabel(self.ui.label_boss_name, {maxWidth = 120, minScale = 0.6})
  local bossLevel = stageTableItem["Monster Level"]
  ed.setLabelString(self.ui.label_boss_level, string.format("Lv.%s", bossLevel))
  self.bossHeroLevel = bossLevel
  ed.setTexture(self.ui.title_bg, string.format("UI/alpha/1080P/dungeon/boss/boss_title_rank_%s.png", difficulty))
  local battleTableItem = ed.getDataTable("DungeonBattle")[stageId][1]
  local bossPosition = battleTableItem["Boss Position"]
  local bossHeroId = battleTableItem[string.format("Monster %s ID", bossPosition)]
  if self.bossHeroId ~= bossHeroId then
    self.bossHeroId = bossHeroId
    self.ui.panel_boss:removeAllChildrenWithCleanup(true)
    local puppet, cha = ed.readhero.getActor(bossHeroId, "Idle", true, false)
    if bossSize and bossSize ~= 0 then
      puppet:setScale(bossSize / 100)
    else
      puppet:setScale(1.35)
    end
    self:addFca(puppet)
    puppet:update(0)
    self.ui.panel_boss:addChild(puppet)
  end
end

function class:getNextRewardItem(rewardId, progressVal)
  local rewardTableItemGroup = ed.getDataTable("DungeonBossReward")[rewardId]
  local nextRewardTableItemArr = {}
  for hp, v in pairs(rewardTableItemGroup) do
    if progressVal < hp then
      table.insert(nextRewardTableItemArr, v)
    end
  end
  if 0 < #nextRewardTableItemArr then
    table.sort(nextRewardTableItemArr, function(a, b)
      return a["Reward HP"] < b["Reward HP"]
    end)
    return nextRewardTableItemArr[1]
  else
    return nil
  end
end

function class:refreshStageInfo()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local difficulty = bossTableItem["Boss Difficulty"]
  local stageId = bossTableItem["Stage ID"]
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  local titleText = string.format("%s %s", bossTableItem["Boss Name"], ed.awakeDungeonDefine.DIFFICULTY_TO_TEXT[difficulty])
  ed.setLabelString(self.ui.label_title, titleText)
  ed.setLabelStroke(self.ui.label_title, class.TITLE_LABEL_STROKE[difficulty], 1)
  ed.adaptLabel(self.ui.label_title, {maxWidth = 200, minScale = 0.8})
  self.ui.label_title:setHorizontalAlignment(kCCTextAlignmentCenter)
  local baseProgressVal = (difficulty - 1) * ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS
  local stageProgress = ed.clamp(self.curProgressVal - baseProgressVal, 0, ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS)
  ed.setLabelString(self.ui.label_boss_history, string.format("%s%%", math.floor(stageProgress / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100)))
  local rewardTableItemGroup = ed.getDataTable("DungeonBossReward")[stageTableItem["Boss Reward ID"]]
  local nextRewardTableItem = self.dungeonMgr:getNextBossRewardItem(stageTableItem["Boss Reward ID"], self.curProgressVal)
  local nextRewardList = {}
  if nil ~= nextRewardTableItem then
    self.ui.next_reward_bg:setVisible(true)
    self.ui.panel_next_reward:setVisible(true)
    self.ui.single_reward_bg:setPositionY(212)
    self.ui.panel_single_reward:setPositionY(138)
    ed.setLabelString(self.ui.label_next_reward, string.format("%s%%", math.floor((nextRewardTableItem["Reward HP"] - baseProgressVal) / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100)))
    for index = 1, 20 do
      local rewardType = nextRewardTableItem["Reward Type " .. index]
      local rewardId = nextRewardTableItem["Reward ID " .. index]
      local rewardAmount = nextRewardTableItem["Reward Amount " .. index]
      if not rewardAmount or rewardAmount == 0 then
        break
      end
      table.insert(nextRewardList, {
        id = rewardId,
        type = rewardType,
        amount = rewardAmount
      })
    end
  else
    ed.setLabelString(self.ui.label_next_reward, T("\229\183\178\229\133\168\233\131\168\229\174\140\230\136\144"))
    self.ui.panel_next_reward:setVisible(false)
    self.ui.single_reward_bg:setPositionY(258)
    self.ui.panel_single_reward:setPositionY(183)
  end
  self:createRewardItemList(self.ui.panel_next_reward, nextRewardList)
  self.rewardList = {next = nextRewardList}
  local battleRewardList = {}
  for index = 1, 20 do
    local rewardType = stageTableItem["FD Reward Type " .. index]
    local rewardId = stageTableItem["FD Reward ID " .. index]
    local rewardAmount = stageTableItem["FD Reward Amount " .. index]
    if not rewardAmount or rewardAmount == 0 then
      break
    end
    table.insert(battleRewardList, {
      id = rewardId,
      type = rewardType,
      amount = rewardAmount,
      isFirst = true
    })
  end
  self.rewardList.once = battleRewardList
  table.insert(battleRewardList, {
    id = self.dungeonMgr:getDropsId(),
    type = "item",
    amount = self.dungeonMgr:getSweepRewardNum()
  })
  self:createRewardItemList(self.ui.panel_single_reward, battleRewardList)
end

function class:refreshChallengeInfo()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local difficulty = bossTableItem["Boss Difficulty"]
  self.ui.image_warning_bg:setVisible(difficulty == 4)
  local stageId = bossTableItem["Stage ID"]
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  local cost = stageTableItem["Dungeon Vitality Cost"]
  if cost and 0 < cost then
    ed.setLabelString(self.ui.label_cost, string.format(T("%s"), cost))
    ed.setTexture(self.ui.image_cost_token, ed.awakeDungeonDefine.VITALITY_PATH, true)
  else
    self.ui.label_cost:setVisible(false)
    self.ui.image_cost_token:setVisible(false)
  end
  if difficulty <= self.unlockDifficulty then
    challengeBtnRes = "UI/alpha/1080P/common/buttion_big.png"
    labelColor = 16642206
    ed.updateSpriteGray(self.ui.image_challenge, false)
  else
    challengeBtnRes = "UI/alpha/1080P/common/button_big_grey.png"
    labelColor = 15790320
    ed.updateSpriteGray(self.ui.image_challenge, true)
  end
  ed.setLabelColor(self.ui.label_challenge, ed.toccc3(labelColor))
  ed.setTexture(self.ui.btn_challenge, challengeBtnRes)
end

function class:refreshStageRecord()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  local stageRecord = self.dungeonMgr:getStageRecord(stageId)
  if not stageRecord then
    self.ui.none_first_blood:setVisible(true)
    self.ui.image_first_blood:setVisible(false)
    return
  end
  self.ui.none_first_blood:setVisible(false)
  self.ui.image_first_blood:setVisible(true)
  self.ui.image_warning_bg:setVisible(false)
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
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  local buffInfo = self.dungeonMgr:getBuffInfoByStageId(stageId)
  if not buffInfo then
    self.ui.image_buff_bg:setVisible(false)
    self.ui.image_cost_token:setPositionX(591.25)
    self.ui.label_cost:setPositionX(564.75)
    return
  end
  self.ui.image_buff_bg:setVisible(true)
  self.ui.image_cost_token:setPositionX(546.25)
  self.ui.label_cost:setPositionX(519.75)
  ed.setLabelString(self.ui.label_buff, ed.awakeDungeonDefine.getBuffDes(buffInfo.shortDesc))
end

function class:createRewardItemList(container, rewardList)
  local itemList = {}
  container:removeAllChildrenWithCleanup(true)
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
  for _, itemData in ipairs(rewardList) do
    local icon = ed.createItemIcon({
      id = itemData.id,
      type = itemData.type,
      amount = itemData.amount
    })
    icon:setScale(0.67)
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    if itemData.isOne then
      local firstTag = ed.createSprite("UI/alpha/1080P/skilltower/icon_first.png")
      icon:addChild(firstTag)
      firstTag:setPosition(ccp(15, iconSize.height + 5))
      firstTag:setZOrder(1)
      local labelFirst = ed.createttf(T("\233\166\150\230\172\161"), 11)
      ed.setLabelColor(labelFirst, ed.toccc3(16776919))
      firstTag:addChild(labelFirst)
      labelFirst:setPosition(ccp(24, 16.5))
    end
    icon:setPosition(ccp(iconSize.width / 2 * 0.67 + posX, iconSize.height / 2 * 0.67))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
end

function class:checkStage(times)
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  local cost = stageTableItem["Dungeon Vitality Cost"]
  local totalCost = cost * times
  local vitality = self.dungeonMgr:getCurVitality()
  if totalCost > vitality then
    ed.showToast(string.format(T("\232\131\189\233\135\143\228\184\141\232\182\179")))
    return false
  end
  return true
end

function class:challengeStage()
  local isOpen, reason = self.dungeonMgr:awakeDungeonIsOpen()
  if not isOpen then
    ed.showToast(reason)
    return
  end
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local difficulty = bossTableItem["Boss Difficulty"]
  local stageId = bossTableItem["Stage ID"]
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  local chapterId = stageTableItem["Chapter ID"]
  if difficulty > self.unlockDifficulty then
    ed.showToast(T("\233\156\128\229\133\136\229\174\140\230\136\144\228\184\138\228\184\128\233\154\190\229\186\166\231\154\132\230\140\145\230\136\152"))
    return
  end
  if not self:checkStage(1) then
    return
  end
  local buffInfo = self.dungeonMgr:getBuffInfoByStageId(stageId)
  local battleData = {
    items = self.rewardList,
    titleName = self.ui.label_title:getString(),
    maxProgress = self.ui.label_boss_history:getString(),
    nextProgress = self.ui.label_next_reward:getString(),
    cost = self.ui.label_cost:getString(),
    bossHeroId = self.bossHeroId,
    isBoss = true,
    shortDesc = nil ~= buffInfo and buffInfo.shortDesc or nil,
    cellX = self.cellX,
    cellY = self.cellY,
    chapterId = chapterId
  }
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "AwakeStage",
    stage_id = stageId,
    heroLimit = {},
    objData = battleData
  }))
end

function class:showWarningTipsEff()
  repeat
    do
      local warning = ed.createFcaActor("eff_UI_Dungeon_warning")
      local label_warning = ed.createLabelTTF(T("\233\133\183\229\136\145\231\163\148\231\189\154"), 25, ed.fontBold)
      ed.setLabelStroke(label_warning, ed.toccc3(4657168), 1)
      ed.setLabelColor(label_warning, ed.toccc3(16769752))
      local label_warning1 = CCSprite:create()
      label_warning1:addChild(label_warning)
      warning:addNodeToComponent(label_warning1, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      local fo = CCFadeOut:create(0.6666666666666666)
      local fi = CCFadeIn:create(0.3333333333333333)
      local anim = CCFadeOut:create(0.875)
      label_warning:runAction(CCSequence:create(ccArrayMake(fo, fi, fo, fi, anim)))
      local label_warning_text = ed.ui.autoText.new()
      label_warning_text:initParam({
        color = ed.toccc3(16776423),
        context = T("\230\156\172\229\133\179\229\141\161<lable color=ccc3(255,212,102)>\233\154\190\229\186\166\232\190\131\233\171\152</lable>\239\188\140\232\175\183\233\152\159\233\149\191\230\160\185\230\141\174\232\135\170\232\186\171\230\131\133\229\134\181<lable color=cc3(255,212,102)>\232\176\168\230\133\142\230\140\145\230\136\152</lable>\239\188\129"),
        fontSize = 16
      })
      local wid, hei = label_warning_text:getCurContentSize()
      label_warning_text.node:setPosition(ccp(-wid * 0.5, hei * 0.5))
      local label_warning_text1 = CCSprite:create()
      label_warning_text1:addChild(label_warning_text.node)
      warning:addNodeToComponent(label_warning_text1, "Node1", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
      local war_anim1 = CCDelayTime:create(2)
      local war_anim2 = CCFadeOut:create(0.875)
      label_warning_text.node:runAction(CCSequence:createWithTwoActions(war_anim1, war_anim2))
      self:addFca(warning)
      self.ui.bg:addChild(warning, 999)
      ed.layout.centerXInParent(warning)
      warning:setPositionY(290)
      warning:setAction("Start")
      self.eff_warningTips = warning
    end
    do break end -- pseudo-goto
    self.eff_warningTips:setAction("Start")
  until true
  self.eff_warningTips:stopAllActions()
  self.isLockTouch = true
  local delay = CCDelayTime:create(3.5)
  local callFunc = CCCallFunc:create(function()
    self.isLockTouch = false
    local key = ed.getRoleKey(string.format("dungeon_stage_unlock_torture"))
    if not ed.storage.getBool(key) then
      ed.storage.setValue(key, true)
      ed.showStory("DungeonTorture")
    end
  end)
  self.eff_warningTips:runAction(ed.readaction.create({
    t = "seq",
    delay,
    callFunc
  }))
end

function class:checkShowWarningEff()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  local difficulty = bossTableItem["Boss Difficulty"]
  if difficulty == 4 then
    local key = ed.getRoleKey(string.format("dungeon_boss_stage_warning_%s", stageId))
    local haveShowed = ed.storage.getBool(key)
    if difficulty <= self.unlockDifficulty and not haveShowed then
      self:showWarningTipsEff()
      ed.storage.setValue(key, true)
    end
  end
end

function class:onClickDifficultyBtn(index)
  if self.curIndex == index then
    return
  end
  self.curIndex = index
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  self.dungeonMgr:requestStageRecord(stageId)
  self:checkShowWarningEff()
  self:refreshView()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:close()
  end, {pressScale = 0.95, clickInterval = 0.2})
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event ~= "ended" then
        return true
      end
      if not ed.containsPoint(self.ui.bg, x, y) then
        self:close()
        return true
      end
      return true
    end,
    key = "close"
  })
  ed.UITool.registerBtn(self, "btn_challenge", function()
    if self.isLockTouch then
      return
    end
    self:challengeStage()
  end, {pressScale = 0.95, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "btn_boss_detail", function()
    if self.isLockTouch then
      return
    end
    self:onClickBossDetail()
  end, {
    pressScale = 0.95,
    normalScale = 0.9,
    clickInterval = 0.2
  })
  ed.UITool.registerBtn(self, "btn_reward_detail", function()
    if self.isLockTouch then
      return
    end
    self:onClickBossRewards()
  end, {
    pressScale = 0.95,
    normalScale = 0.9,
    clickInterval = 0.2
  })
  ed.UITool.registerBtn(self, "btn_first_blood_detail", function()
    self:onClickFirstDetail()
  end, {pressScale = 0.98, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "image_buff_bg", function()
    self:onClickBuffDetail()
  end, {
    normalScale = 0.8,
    pressScale = 0.76,
    clickInterval = 0.2
  })
  for index = 1, 4 do
    ed.UITool.registerBtn(self, "btn_difficulty_" .. index, function()
    end, {
      clickInterval = 0.2,
      clickHandler = function()
        if self.isLockTouch then
          return
        end
        self:onClickDifficultyBtn(index)
      end,
      pressHandler = function()
        if self.isLockTouch then
          return
        end
        ed.playEffect(ed.sound.deo.dungeon_gear_switch)
        local effect_button1 = self.ui["btn_effect_button_" .. index]
        local effect_button2 = self.ui["btn_effect_button2_" .. index]
        effect_button1:stopAllActions()
        effect_button2:stopAllActions()
        effect_button1:setAction("Start")
        effect_button2:setAction("Start")
      end,
      cancelPressHandler = function()
        local effect_button1 = self.ui["btn_effect_button_" .. index]
        local effect_button2 = self.ui["btn_effect_button2_" .. index]
        effect_button1:stopAllActions()
        effect_button2:stopAllActions()
      end
    })
  end
end

function class:onClickBossRewards()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  ed.ui.awakeDungeonBossReward.create({
    stageId = stageId,
    cellX = self.cellX,
    cellY = self.cellY
  })
end

function class:onClickBossDetail()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  ed.ui.awakeDungeonBossDetail.create({
    groupId = stageTableItem["Boss Group"],
    bossLevel = stageTableItem["Monster Level"],
    difficulty = bossTableItem["Boss Difficulty"],
    stageId = stageId,
    bossId = self.bossHeroId
  })
end

function class:onClickFirstDetail()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  local awakeDungeonFirstBloodWin = ed.ui.awakeDungeonFirstBloodWin.create({stageId = stageId})
  awakeDungeonFirstBloodWin:popWindow()
  ed.layout.relateLayout(self.ui.image_first_blood, awakeDungeonFirstBloodWin.ui.image_bg, {bottom = 60})
end

function class:onClickBuffDetail()
  local bossTableItem = self.bossTableItemArr[self.curIndex]
  local stageId = bossTableItem["Stage ID"]
  local stageTableItem = ed.getDataTable("DungeonStage")[stageId]
  local awakeDungeonBuffDetailWin = ed.ui.awakeDungeonBuffDetailWin.create({
    chapterId = stageTableItem["Chapter ID"]
  })
  awakeDungeonBuffDetailWin:popWindow()
  ed.layout.relateLayout(self.ui.image_buff_bg, awakeDungeonBuffDetailWin.ui.image_bg, {top = 180})
end

function class:addEventListener()
  self:registerOnEnterHandler("onEnter", function()
    local newProgressVal = self.dungeonMgr:getCurStageProgress(self.cellX, self.cellY)
    if newProgressVal == ed.awakeDungeonDefine.MAX_PROGRESS then
      self:listenTimer(Timer:Once(0.01), function()
        self:destroy({skipAnim = true})
      end)
      return
    end
    if self.curProgressVal ~= newProgressVal then
      self.curProgressVal = newProgressVal
      self:stopUnlockAction(self.curIndex)
      local newIndex = 0
      for i, v in ipairs(self.bossTableItemArr) do
        if self.curProgressVal >= v["Boss Difficulty"] * ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS then
          newIndex = i + 1
        end
      end
      newIndex = ed.clamp(newIndex, 1, #self.bossTableItemArr)
      if newIndex ~= self.curIndex then
        local maxTableItem = self.bossTableItemArr[newIndex]
        self.unlockDifficulty = maxTableItem["Boss Difficulty"]
        self:onClickDifficultyBtn(newIndex)
      else
        self:refreshView()
      end
    end
  end)
  self:listenEvent("awakeDungeonStageRecord", function(recvStageId)
    local bossTableItem = self.bossTableItemArr[self.curIndex]
    local stageId = bossTableItem["Stage ID"]
    if stageId == recvStageId then
      self:refreshStageRecord()
    end
  end)
end

function class:close()
  if self.isLockTouch then
    return
  end
  self:destroy({skipAnim = true})
end
