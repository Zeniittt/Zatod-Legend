local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.adventureStageScene = class
local IMAGE_PATH_1 = "UI/alpha/1080P/activityadventure/adventure_stage_wayloop_1.png"
local IMAGE_PATH_2 = "UI/alpha/1080P/activityadventure/adventure_stage_wayloop_2.png"
local IMAGE_PATH_3 = "UI/alpha/1080P/activityadventure/adventure_stage_wayloop_3.png"
local MAP_LEFT_OFFSET = 135
local MAP_RIGHT_OFFSET = 187.5
local STAGE_INDEX_TO_POS = {
  ccp(-87, 310),
  ccp(-39, 90),
  ccp(138, 230)
}
ed.UITool.registViewOpenFunc("adventureStageScene", function(param)
  local actId = param.actId
  if not actId then
    return
  end
  local actAdventureMgr = ed.actiAdventureMgr.getInstance()
  local isOpen, reason = actAdventureMgr:checkAdventurenOpen(actId)
  if not isOpen then
    ed.showToast(reason)
    return
  end
  class.requireAdventureData()
  ListenEventOnce("refreshAdventureInfo", function(refreshActId)
    if refreshActId == actId then
      local scene = class.create(param)
      ed.pushScene(scene)
    end
  end)
end)

function class.requireAdventureData()
  ed.actiAdventureNet.openPanel()
end

function class.create(param)
  local self = base.create("adventureStageScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.actId = param.actId
  self.adventureMgr = ed.actiAdventureMgr.getInstance()
  self.actAdventureTbCfg = ed.getDataTable("ActivityAdventure")[self.actId]
  self.actAdventureStageTb = ed.getDataTable("ActivityAdventureStage")
  self.dragPressX = 0
  self.layerOriPos = 0
  self.stageGroup = self.actAdventureTbCfg["Stage Group"]
  self.stageIconList = {}
  self.challengeLevel = self.adventureMgr:getChallengeLevel(self.actId)
  self:initView()
  self.adventureMgr:setLastOpenTime()
  self.firstEnterScene = true
  self:addUIEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_adventure_scene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.ui.btn_heat_entry:setVisible(false)
  ed.setLabelStroke(self.ui.label_heat_name, ed.toccc3(5906712), 1)
  local bgPath = self.actAdventureTbCfg["Adventure Bg"]
  self:setBackground(bgPath)
  self:setBackButton()
  self:adaptUI()
  self:initRedPoint()
  self:createStage()
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(12283392), 1)
  ed.setLabelStroke(self.ui.label_addition, ed.toccc3(12283392), 1)
  local adaptScale = 110 / math.max(self.ui.label_reward:getContentSize().width, self.ui.label_addition:getContentSize().width)
  adaptScale = math.min(1, adaptScale)
  self.ui.label_reward:setScale(adaptScale)
  self.ui.label_addition:setScale(adaptScale)
  local startTime, endTime = self.adventureMgr:getAdventureTime(self.actId)
  if endTime < ed.getServerTime() then
    self.ui.left_time:setString(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
  else
    local y, m, d, h, mi, s = ed.time2YMDHMS(endTime)
    self.ui.left_time:setString(string.format(T("%d/%d/%.2d %.2d:%.2d\231\187\147\230\157\159"), y, m, d, h, mi))
  end
  local leftTimeBgPath = self.actAdventureTbCfg["TimeLine Icon"][1]
  local leftTimeIconPath = self.actAdventureTbCfg["TimeLine Icon"][2]
  ed.setTexture(self.ui.left_time_bg, leftTimeBgPath, true)
  ed.setTexture(self.ui.image_time, leftTimeIconPath)
  local bgSize = self.ui.left_time_bg:getContentSize()
  ed.layout.centerXInParent(self.ui.left_time)
  self.ui.left_time:setPositionY(bgSize.height / 2 - 3)
  self.ui.image_time:setPositionX(self.ui.left_time:getPositionX() - self.ui.image_time:getContentSize().width / 2 - 5)
  self.ui.image_time:setPositionY(self.ui.left_time:getPositionY())
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_reward, {right = 30, bottom = 8}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_addition, {right = 140, bottom = 8}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_heat_entry, {left = 20, bottom = 8}, false, true)
  ed.layout.layoutWithMagin(self.ui.left_time_bg, {bottom = 16}, false, true)
  local dragContainerSize = self.ui.drag_container:getContentSize()
  self.ui.drag_container:setContentSize(CCSizeMake(ed.display.winSize.width, dragContainerSize.height))
  self.ui.drag_container:setPositionX(self.ui.drag_container:getPositionX() - ed.display.halfFixedWidth)
  self.dragList = ed.UITool.createDraglist(self.ui.drag_container, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelClickIn = self:getCancelClickInHandler(),
    priority = 0
  })
end

function class:initRedPoint()
  local redPointMgr = ed.redPointMgr.getInstance()
  redPointMgr:registerValueChange("adventure_reward_entry", self, {
    handle = function(value)
      self.ui.image_red_point:setVisible(0 < value)
    end
  })
  redPointMgr:registerValueChange("hades_heat_entry", self, {
    handle = function(value)
      self.ui.image_heat_enter_reddot:setVisible(0 < value)
    end
  })
end

function class:getPressInHandler()
  local function handler(x, y)
    for stageId, item in pairs(self.stageIconList or {}) do
      if ed.containsPoint(item.ui.stage_bg, x, y) then
        item.ui.stage_bg:setScale(0.98)
        
        return item
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, item)
    local stageId = item.stageId
    
    ed.UITool.openView("adventureStageDetail", {
      actId = self.actId,
      stageId = stageId
    })
  end
  
  return handler
end

function class:getCancelClickInHandler()
  local function handler(x, y, item)
    item.ui.stage_bg:setScale(1)
  end
  
  return handler
end

function class:refreshView()
  local titlePath = self.actAdventureTbCfg["Adventure Title"]
  ed.setTexture(self.ui.image_title, titlePath, true)
  ed.layout.relateLayout(self.back_button, self.ui.image_title, {
    right = self.back_button:getContentSize().width * 0.5 - 25
  }, false)
  self.ui.image_title:setPositionY(self.ui.image_title:getPositionY() + 3)
  ed.layout.layoutWithParentMagin(self.ui.btn_tips, {right = 10}, false)
  ed.layout.centerYInParent(self.ui.btn_tips)
  for stageId = self.stageGroup + 1, self.stageGroup + 100 do
    local stageCfgData = self.actAdventureStageTb[stageId]
    if not stageCfgData then
      break
    end
    local newStageState = self.adventureMgr:getStageState(self.actId, stageId)
    local oldStageInfo = self.stageIconList[stageId]
    if oldStageInfo and oldStageInfo.stageState ~= newStageState then
      oldStageInfo.stageState = newStageState
      self:refreshStageDetailIcon(stageCfgData, newStageState, oldStageInfo)
    end
  end
end

function class:createStage()
  local stageIndex = 1
  local wayloopPosX = 0
  self.stageIconList = {}
  for stageId = self.stageGroup + 1, self.stageGroup + 100 do
    local stageCfgData = self.actAdventureStageTb[stageId]
    if not stageCfgData then
      break
    end
    local stageState = self.adventureMgr:getStageState(self.actId, stageId)
    local imagePath, loopPosY
    if stageIndex == 1 then
    elseif (stageIndex - 1) % #STAGE_INDEX_TO_POS + 1 == 1 then
      imagePath = IMAGE_PATH_3
      loopPosY = 340
    elseif (stageIndex - 1) % #STAGE_INDEX_TO_POS + 1 == 2 then
      imagePath = IMAGE_PATH_1
      loopPosY = 260
    elseif (stageIndex - 1) % #STAGE_INDEX_TO_POS + 1 == 3 then
      imagePath = IMAGE_PATH_2
      loopPosY = 210
    end
    if imagePath then
      local wayloop = ed.createSprite(imagePath)
      local wayloopSize = wayloop:getContentSize()
      self.dragList:addItem(wayloop)
      wayloop:setZOrder(0)
      wayloop:setPositionX(wayloopPosX + wayloopSize.width / 2 + MAP_LEFT_OFFSET)
      wayloop:setPositionY(loopPosY)
      wayloopPosX = wayloopPosX + wayloopSize.width
    end
    local stageIcon, ui = self:refreshStageDetailIcon(stageCfgData, stageState)
    self.stageIconList[stageId] = {
      container = stageIcon,
      ui = ui,
      stageState = stageState,
      stageId = stageId
    }
    local pos = STAGE_INDEX_TO_POS[(stageIndex - 1) % #STAGE_INDEX_TO_POS + 1]
    local multX = math.floor((stageIndex - 1) / #STAGE_INDEX_TO_POS)
    stageIndex = stageIndex + 1
    self.dragList:addItem(stageIcon)
    stageIcon:setZOrder(1)
    stageIcon:setPositionX(pos.x + multX * 435 + MAP_LEFT_OFFSET)
    stageIcon:setPositionY(pos.y)
  end
  self.dragList:initListWidth(wayloopPosX + MAP_LEFT_OFFSET + MAP_RIGHT_OFFSET)
end

function class:refreshStageDetailIcon(stageCfgData, stageState, oldStageIcon)
  local container, ui
  if oldStageIcon then
    container = oldStageIcon.container
    ui = oldStageIcon.ui
  else
    container, ui = ed.editorui(ed.uieditor.activity_adventure_stage)
  end
  ed.setLabelString(ui.stage_name, stageCfgData["Stage Name"])
  ed.setLabelStroke(ui.stage_name, ed.toccc3(3024675), 1)
  local maxLevel = stageCfgData["Max Recommend Level"]
  local minLevel = stageCfgData["Min Recommend Level"]
  local k = self.adventureMgr:getDifficultyRatio(self.actId)
  local recommendLevel = math.floor(k * (maxLevel - minLevel) + minLevel)
  ed.setLabelString(ui.recommend_level, string.format(T("\230\142\168\232\141\144\231\173\137\231\186\167 %s"), recommendLevel))
  ed.setLabelStroke(ui.recommend_level, ed.toccc3(3744789), 1)
  ui.recommend_level:limitWidthByScale(125)
  local stagePicture = stageCfgData["Stage Picture"]
  local stageIconPath = string.format("UI/alpha/1080P/campaign/key_stages/%s.png", stagePicture)
  local stageCurrentPath = string.format("UI/alpha/1080P/campaign/key_stages/%s-current.png", stagePicture)
  local stageLockPath = string.format("UI/alpha/1080P/campaign/key_stages/%s-locked.png", stagePicture)
  local stagePassedPath = string.format("UI/alpha/1080P/campaign/key_stages/%s-passed.png", stagePicture)
  local oldHeight = ui.image_stage_icon:getContentSize().height
  ed.setTexture(ui.image_stage_icon, stageIconPath)
  local newHeight = ui.image_stage_icon:getContentSize().height
  ed.setTexture(ui.image_stage_current, stageCurrentPath)
  ed.setTexture(ui.image_stage_locked, stageLockPath)
  ed.setTexture(ui.image_stage_passed, stagePassedPath)
  ui.image_stage_current:setPositionY(ui.image_stage_current:getPositionY() + (newHeight - oldHeight) / 2)
  ui.image_stage_locked:setPositionY(ui.image_stage_locked:getPositionY() + (newHeight - oldHeight) / 2)
  ui.image_stage_icon:setPositionY(ui.image_stage_icon:getPositionY() + (newHeight - oldHeight) / 2)
  ui.image_stage_passed:setPositionY(ui.image_stage_passed:getPositionY() + (newHeight - oldHeight) / 2)
  local countDownBgPath = self.actAdventureTbCfg["Countdown Icon"]
  ed.setTexture(ui.image_countdown_locked, countDownBgPath)
  local mask
  if stageState == ed.adventureDefine.STAGE_STATE_CURRENT then
    ui.image_stage_icon:setVisible(true)
    ui.image_stage_current:setVisible(true)
    ui.image_stage_locked:setVisible(false)
    ui.image_stage_passed:setVisible(false)
    ui.stage_name_bg:setVisible(false)
    ui.stage_name_selected_bg:setVisible(true)
    ui.image_lock:setVisible(false)
    ui.image_current_tag:setVisible(true)
    ui.image_countdown_locked:setVisible(false)
    local posX, posY = ui.image_current_tag:getPosition()
    ui.image_current_tag:stopAllActions()
    local move = CCMoveTo:create(0.5, ccp(posX, posY + 10))
    local back = CCMoveTo:create(0.5, ccp(posX, posY))
    local sequence = CCSequence:createWithTwoActions(move, back)
    ui.image_current_tag:runAction(CCRepeatForever:create(sequence))
    mask = ui.image_stage_current
  elseif stageState == ed.adventureDefine.STAGE_STATE_PASSED then
    ui.image_stage_icon:setVisible(true)
    ui.image_stage_current:setVisible(false)
    ui.image_stage_locked:setVisible(false)
    ui.image_stage_passed:setVisible(true)
    ui.stage_name_bg:setVisible(true)
    ui.stage_name_selected_bg:setVisible(false)
    ui.image_lock:setVisible(false)
    mask = ui.image_stage_passed
    ui.image_current_tag:setVisible(false)
    ui.image_countdown_locked:setVisible(false)
  elseif stageState == ed.adventureDefine.STAGE_STATE_TIME_LOCKED then
    ui.image_stage_icon:setVisible(false)
    ui.image_stage_current:setVisible(false)
    ui.image_stage_locked:setVisible(true)
    ui.image_stage_passed:setVisible(false)
    ui.stage_name_bg:setVisible(true)
    ui.stage_name_selected_bg:setVisible(false)
    ui.image_lock:setVisible(true)
    ui.image_current_tag:setVisible(false)
    ui.image_countdown_locked:setVisible(true)
    local openTime = self.adventureMgr:getStageOpenTime(self.actId, stageCfgData["Stage ID"])
    local year, month, day, hour, minutes, second = ed.time2YMDHMS(openTime)
    ed.setLabelString(ui.label_countdown_locked, string.format(T("%d\230\156\136%d\230\151\165%d\230\151\182\229\188\128\229\144\175"), month, day, hour))
    ed.setLabelStroke(ui.label_countdown_locked, ed.toccc3(1397897), 1)
    ui.label_countdown_locked:limitWidthByScale(120)
  else
    ui.image_stage_icon:setVisible(false)
    ui.image_stage_current:setVisible(false)
    ui.image_stage_locked:setVisible(true)
    ui.image_stage_passed:setVisible(false)
    ui.stage_name_bg:setVisible(true)
    ui.stage_name_selected_bg:setVisible(false)
    ui.image_lock:setVisible(true)
    ui.image_current_tag:setVisible(false)
    ui.image_countdown_locked:setVisible(false)
  end
  if mask then
    mask:stopAllActions()
    local action = CCFadeTo:create(1, 0)
    local reverse = CCFadeTo:create(1, 255)
    local sequence = CCSequence:createWithTwoActions(action, reverse)
    mask:runAction(CCRepeatForever:create(sequence))
  end
  return container, ui
end

function class:createPromptCard(text)
  self:destroyPromptCard()
  local container = CCSprite:create()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png", CCRectMake(8, 8, 37, 37))
  bg:setAnchorPoint(ccp(1, 1))
  bg:setPosition(ccp(ed.display.winSize.width - 30, ed.display.winSize.height - 40))
  container:addChild(bg)
  local label = ed.createttf(text, 14)
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(label, ccc3(85, 64, 39), 1)
  bg:addChild(label)
  local size = label:getContentSize()
  bg:setContentSize(CCSizeMake(size.width + 20, size.height + 20))
  label:setPosition(ed.getCenterPos(bg))
  return container, label
end

function class:destroyPromptCard()
  if not tolua.isnull(self.promptCard) then
    self.promptCard:removeFromParentAndCleanup(true)
    self.promptCard = nil
  end
end

function class:createVitalityPrompt()
  local promptText = self:getVitalityPromptText()
  if not promptText then
    return
  end
  local promptCard, label = self:createPromptCard(promptText)
  self.scene:addChild(promptCard, 60)
  self:registerUpdateHandler("VitalityPrompt", self:refreshVitalityPromptHandler())
  self.promptCard = promptCard
  self.vitPromptLabel = label
end

function class:getVitalityPromptText()
  local vitalityUpdateTime = self.adventureMgr:getVitalityUpdateTime(self.actId)
  local current = self.adventureMgr:getAdventureVitality(self.actId)
  local upperLimit = ed.adventureDefine.VITALITY_UPPER_LIMIT
  local gap = ed.adventureDefine.VITALITY_RECOVER_GAP
  local vitalityId = ed.adventureDefine.getAdventureVitalityId(self.actId)
  local itemName = ed.getDataTable("equip")[vitalityId].Name
  if current >= upperLimit then
    return string.format(T("%s\229\183\178\229\155\158\230\187\161"), itemName)
  end
  local nextTime = vitalityUpdateTime + gap
  local recoverLeftTime = nextTime - ed.getServerTime()
  if recoverLeftTime <= 0 then
    class.requireAdventureData()
    return
  end
  local recoverAllLeftTime = recoverLeftTime + (upperLimit - current - 1) * gap
  local nextTimeStr = ed.gethmsNString(recoverLeftTime or 0)
  local maxTimeStr = ed.gethmsNString(recoverAllLeftTime or 0)
  local prompt = string.format(string.format(T("\228\184\139\231\130\185%s\230\129\162\229\164\141\239\188\154%s"), itemName, nextTimeStr))
  prompt = prompt .. string.format(string.format(T("\n\230\129\162\229\164\141\229\133\168\233\131\168%s\239\188\154%s"), itemName, maxTimeStr))
  prompt = prompt .. string.format(string.format(T("\n\230\129\162\229\164\141\230\151\182\233\151\180\233\151\180\233\154\148\239\188\154%s\229\136\134\233\146\159"), gap / 60))
  return prompt
end

function class:refreshVitalityPromptHandler()
  local count = 0
  
  local function handler(dt)
    if tolua.isnull(self.promptCard) or tolua.isnull(self.vitPromptLabel) then
      self:removeUpdateHandler("VitalityPrompt")
      return
    end
    count = count + dt
    if 1 < count then
      local prompt = self:getVitalityPromptText()
      ed.setString(self.vitPromptLabel, prompt)
      count = count - 1
    end
  end
  
  return handler
end

function class:onPopScene()
  local redPointMgr = ed.redPointMgr.getInstance()
  redPointMgr:unregisterValueChange("adventure_reward_entry", self)
  redPointMgr:unregisterValueChange("hades_heat_entry", self)
  base.onPopScene(self)
end

function class:addUIEvent()
  ed.UITool.registerBtn(self, "btn_addition", function()
    ed.UITool.openView("adventureAdditionPanel", {
      actId = self.actId
    })
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.UITool.openView("adventureRewardPanel", {
      actId = self.actId
    })
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_tips", function()
    local title = ed.adventureDefine.getAdventureTitle(self.actId)
    local rules = ed.adventureDefine.getAdventureRules(self.actId)
    ed.ui.commonRulePop.create({title = title, txt = rules}):popWindow()
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:listenEvent("refreshAdventureInfo", function(actId)
    if actId == self.actId then
      self.resourceBox:updateAllResourceValue()
      self:refreshView()
    end
  end)
  self:registerOnEnterHandler("onEnter", function()
    if self.firstEnterScene then
      self.firstEnterScene = false
      return
    end
    class.requireAdventureData()
  end)
end
