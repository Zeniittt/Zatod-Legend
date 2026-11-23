local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.AwakeDungeonScene = class
local LineEffectMovePath = {
  [1] = {
    ccp(-147, 144),
    ccp(-147, -90.5),
    ccp(-75, -144),
    ccp(17.5, -144),
    ccp(150, -120)
  },
  [2] = {
    ccp(188, 104),
    ccp(60, 104),
    ccp(-177.5, -102.5)
  },
  [3] = {
    ccp(-164, 9.5),
    ccp(51.5, 9.5),
    ccp(94, -8),
    ccp(159.5, -8.5)
  },
  [4] = {
    ccp(200.5, -86),
    ccp(100, 15),
    ccp(0, 89.5),
    ccp(-197.5, 90.5)
  },
  [5] = {
    ccp(-154.5, -0.5),
    ccp(154.5, -0.5)
  }
}
ed.UITool.registViewOpenFunc("awakeDungeonScene", function()
  local isOpen, reason = ed.awakeDungeonMgr.getInstance():awakeDungeonIsOpen()
  if not isOpen then
    ed.redPointMgr.getInstance():setNodeValue("awake_dungeon_entry", 0)
    if reason then
      ed.showToast(reason)
    end
    return
  end
  ed.AwakeDungeonNetwork.sendOpenPanel()
  ListenEventOnce("awakeDungeonOpenPanel", function()
    local scene = ed.getCurrentScene()
    if scene and scene.identity == "awakeDungeonScene" then
      return
    end
    ed.pushScene(class.create())
  end)
end)

function class.create()
  local self = base.create("awakeDungeonScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.chapterGroup = self.dungeonMgr:getChapterGroup()
  self.levelGroup = self.dungeonMgr:getLevelGroup()
  self.chapterTableItemList = ed.getDataTable("DungeonChapter")[self.chapterGroup] or {}
  self.touchSweepPanelPosX = 0
  self.touchSweepPanelPosY = 0
  self.moveSweepPanelMaxY = 0
  self.moveSweepPanelMinY = 0
  local startTime, endTime = self.dungeonMgr:getTimeInfo()
  self.endTime = endTime or 0
  self.curParagonLevel = 1
  self:initUI()
  self:registerTouchEvents()
  self:registerListenEvents()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  self:setBackground()
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(7549727), 1)
  ed.setLabelStroke(self.ui.label_level, ed.toccc3(9122065), 1)
  ed.setLabelStroke(self.ui.label_exp_percent, ed.toccc3(3284243), 1)
  ed.setLabelStroke(self.ui.label_change_level, ed.toccc3(15504427), 1)
  ed.setLabelStroke(self.ui.label_exp, ed.toccc3(9194282), 1)
  ed.setLabelStroke(self.ui.label_get_exp, ed.toccc3(9719078), 1)
  ed.setLabelStroke(self.ui.label_exp_change_title, ed.toccc3(10049592), 1)
  self.ui.label_exp_change_title:setFontName(ed.fontBold)
  self.chapterLightEffectUITab = {}
  self.chapterImgUIArr = {}
  self.chapterNameLabelUIArr = {}
  self.chapterProgressBgUIArr = {}
  self.chapterInfoBgUIArr = {}
  self.chapterProgressLabelUIArr = {}
  self.chapterLockImgUIArr = {}
  self.chapterLineImgUIArr = {}
  self.chapterRedImgUIArr = {}
  for i = 1, 5 do
    table.insert(self.chapterImgUIArr, self.ui["img_chapter_" .. i])
    table.insert(self.chapterInfoBgUIArr, self.ui["bg_chapter_info_" .. i])
    table.insert(self.chapterNameLabelUIArr, self.ui["label_chapter_name_" .. i])
    table.insert(self.chapterProgressBgUIArr, self.ui["bg_progress_" .. i])
    table.insert(self.chapterProgressLabelUIArr, self.ui["label_progress_" .. i])
    table.insert(self.chapterLockImgUIArr, self.ui["img_chapter_lock_" .. i])
    table.insert(self.chapterLineImgUIArr, self.ui["img_line_" .. i])
    table.insert(self.chapterRedImgUIArr, self.ui["img_red_" .. i])
  end
  local titleLabel = ed.ui.gradientLabel.create({
    text = T("\229\156\176\229\186\149\229\142\134\233\153\169"),
    fontSize = 29,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16777215),
    endColor = ed.toccc3(16711602)
  })
  self.ui.title_bg:addChild(titleLabel.node)
  local titleBgSize = self.ui.title_bg:getContentSize()
  titleLabel.node:setPosition(titleBgSize.width * 0.5, titleBgSize.height * 0.5)
  titleLabel.node:setScale(math.min(160 / titleLabel.node:getContentSize().width, 1))
  self.paragonExpWrap = ed.ui.awakeDungeonParagonExpWrap.create({
    ui = {
      exp_change_bg = self.ui.exp_change_bg,
      label_change_level = self.ui.label_change_level,
      label_exp = self.ui.label_exp,
      label_get_exp = self.ui.label_get_exp,
      image_circle_bar = self.ui.image_circle_bar,
      label_exp_change_title = self.ui.label_exp_change_title
    }
  })
  local particle = CCParticleSystemQuad:create("UI/particle/didifenwen.plist")
  self.ui.map:addChild(particle)
  local mapSize = self.ui.map:getContentSize()
  particle:setPosition(ccp(mapSize.width * 0.5, mapSize.height * 0.5))
  self.firstEnterScene = true
  self:adaptUI()
  self:startCountDown()
  self:initRedDot()
  self:refreshUI()
  self:initSweepInfo()
end

function class:initRedDot()
  ed.redPointMgr.getInstance():registerValueChange("awake_dungeon_reward_entry", self, {
    handle = function(value)
      self.ui.reward_entry_reddot:setVisible(0 < value)
    end
  })
end

function class:refreshUI()
  self:refreshMap()
  self:refreshDungeonLevel()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.title_bg, {left = 29, top = 10}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_level_bg, {left = 20, bottom = -5})
  ed.layout.layoutWithMagin(self.ui.panel_sweep, {right = 20})
  local winSize = ed.display.winSize
  self.moveSweepPanelMaxY = winSize.height - self.ui.panel_sweep:getContentSize().height - 40 - ed.display.halfFixedHeight
  self.moveSweepPanelMinY = 0 - ed.display.halfFixedHeight
end

function class:refreshChapterItem(index)
  local chapterTableItem = self.chapterTableItemList[index]
  local chapterId = chapterTableItem["Chapter ID"]
  local progressVal = self.dungeonMgr:getChapterProgress(chapterId)
  local isFinish = 100 <= progressVal
  local isCurrent = self.dungeonMgr:getCurrentChapterId() == chapterId
  local isUnlock = self.dungeonMgr:isChapterUnlock(chapterId)
  local chaterImg = self.chapterImgUIArr[index]
  local infoBg = self.chapterInfoBgUIArr[index]
  local nameLabel = self.chapterNameLabelUIArr[index]
  local progressBg = self.chapterProgressBgUIArr[index]
  local progressLabel = self.chapterProgressLabelUIArr[index]
  local lockImg = self.chapterLockImgUIArr[index]
  local lineImg = self.chapterLineImgUIArr[index]
  local redImg = self.chapterRedImgUIArr[index]
  chaterImg:setOpacity(isUnlock and 255 or 1)
  if isFinish then
    ed.setTexture(infoBg, "UI/alpha/1080P/dungeon/chapter/chapter_title_finished.png", true)
    ed.setLabelColor(nameLabel, ed.toccc3(16775666))
    ed.setLabelStroke(nameLabel, ed.toccc3(13659146), 1.5)
  elseif isUnlock then
    ed.setTexture(infoBg, "UI/alpha/1080P/dungeon/chapter/chapter_title_playing.png", true)
    ed.setLabelColor(nameLabel, ed.toccc3(16775109))
    ed.setLabelStroke(nameLabel, ed.toccc3(10637312), 1.5)
  else
    ed.setTexture(infoBg, "UI/alpha/1080P/dungeon/chapter/chapter_title_locked.png", true)
    ed.setLabelColor(nameLabel, ccc3(255, 252, 231))
    ed.setLabelStroke(nameLabel, ed.toccc3(7096338), 1.5)
  end
  ed.setLabelString(nameLabel, T("\231\172\172%s\231\171\160 %s", ed.numberToChinese(chapterId), chapterTableItem["Chapter Name"]))
  nameLabel:limitWidthByScale(115)
  ed.setTexture(progressBg, isFinish and "UI/alpha/1080P/dungeon/chapter/wheel_moving.png" or "UI/alpha/1080P/dungeon/chapter/wheel_doing.png", true)
  redImg:setVisible(isFinish and not self.dungeonMgr:isChapterRewardComplete(chapterId))
  if isFinish then
    ed.setLabelColor(progressLabel, ccc3(254, 234, 101))
    ed.setLabelStroke(progressLabel, ed.toccc3(8473600), 1)
  else
    ed.setLabelColor(progressLabel, ccc3(255, 120, 0))
    progressLabel:disableStroke()
  end
  if isCurrent then
    self:playLightEffect(index, isCurrent, progressVal)
  else
    self:stopLightEffect(index)
  end
  if not isFinish and isUnlock then
    progressBg:runAction(CCRepeatForever:create(CCRotateBy:create(15, 360)))
  else
    progressBg:stopAllActions()
  end
  ed.setLabelString(progressLabel, string.format("%d%%", progressVal))
  lockImg:setVisible(not isUnlock)
  progressLabel:setVisible(isUnlock)
  lineImg:setVisible(isUnlock)
end

function class:setSweepState(isOpen)
  self.ui.img_sweep_closed:setVisible(not isOpen)
  self.ui.img_sweep_opened:setVisible(isOpen)
end

function class:initSweepInfo()
  self.ui.panel_sweep:setVisible(false)
end

function class:refreshSweepNum(...)
end

function class:onSweepEvent(times)
  local cost = ed.getDataTable("DungeonConfig").SweepVitalityCost.Value[1]
  local totalCost = cost * times
  local vitality = self.dungeonMgr:getCurVitality()
  if totalCost > vitality then
    ed.showToast(string.format(T("\232\131\189\233\135\143\228\184\141\232\182\179")))
    return
  end
  ed.AwakeDungeonNetwork.sendSweep(times)
end

function class:refreshMap()
  for i, v in ipairs(self.chapterTableItemList) do
    self:refreshChapterItem(i)
  end
end

function class:refreshDungeonLevel()
  local paragonLevel = self.dungeonMgr:getParagonLevel()
  local curExp = self.dungeonMgr:getParagonExp()
  ed.setLabelString(self.ui.label_level, string.format(T("%s\231\186\167"), paragonLevel))
  ed.adaptLabel(self.ui.label_level, {maxWidth = 48, minScale = 0.7})
  local barPercent
  if paragonLevel >= self.dungeonMgr:getMaxParagonLevel() then
    ed.setLabelString(self.ui.label_exp_percent, "MAX")
    barPercent = 1
  else
    local curLevelMaxExp = self.dungeonMgr:getMaxExp(paragonLevel)
    local curExp = self.dungeonMgr:getParagonExp()
    barPercent = curExp / curLevelMaxExp
    ed.setLabelString(self.ui.label_exp_percent, string.format("%s%%", math.floor(curExp / curLevelMaxExp * 100)))
  end
  local clipSize = self.ui.panel_clip:getContentSize()
  self.ui.panel_clip:setClipRect(CCRectMake(0, 0, clipSize.width * barPercent, clipSize.height))
end

function class:checkLevelChanged()
  self:refreshDungeonLevel()
  if ed.getCurrentScene() == self then
    local dungeonMgr = ed.awakeDungeonMgr.getInstance()
    self.paragonExpWrap:updateNewExpAndLevel(self.dungeonMgr:checkExpAndLevelChanged())
  end
end

function class:startCountDown()
  self:refreshLeftTime()
  local label_wid = self.ui.label_left_time:getContentSize().width
  local bg_size = self.ui.image_left_time_bg:getContentSize()
  if label_wid + 73 > bg_size.width then
    self.ui.image_left_time_bg:setContentSize(CCSizeMake(label_wid + 75, bg_size.height))
  end
  self:listenTimer(Timer:Always(1), function()
    self:refreshLeftTime()
  end)
end

function class:refreshLeftTime()
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134 \230\180\187\229\138\168\231\187\147\230\157\159", hour, min))
  else
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182 \230\180\187\229\138\168\231\187\147\230\157\159", day, hour))
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

function class:getVitalityPromptText()
  local vitalityUpdateTime = self.dungeonMgr:getVitalityUpdateTime()
  local current = self.dungeonMgr:getCurVitality()
  local upperLimit = self.dungeonMgr:getMaxVitality()
  local gap = 360
  local itemName = ed.getDataTable("Token").DungeonEnergy["Token Name"]
  if current >= upperLimit then
    return string.format(T("%s\229\183\178\229\155\158\230\187\161"), itemName)
  end
  local nextTime = vitalityUpdateTime + gap
  local recoverLeftTime = nextTime - ed.getServerTime()
  if recoverLeftTime <= 0 then
    ed.AwakeDungeonNetwork.sendOpenPanel()
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

function class:destroyPromptCard()
  if not tolua.isnull(self.promptCard) then
    self.promptCard:removeFromParentAndCleanup(true)
    self.promptCard = nil
  end
end

function class:getLightImgRotation(tagetPos, startPos)
  local angle = math.deg(math.atan2(tagetPos.y - startPos.y, tagetPos.x - startPos.x))
  if angle < 0 then
    angle = angle + 360
  end
  angle = -angle - 90
  return angle
end

function class:playLightEffect(index)
  self.chapterLineImgUIArr[index]:setOpacity(180)
  local effectInfo = self.chapterLightEffectUITab[index]
  if nil == effectInfo then
    local clippingNode = CCClippingNode:create()
    local stencil = ed.createSprite(string.format("UI/alpha/1080P/dungeon/chapter/line%d.png", index))
    clippingNode:setStencil(stencil)
    clippingNode:setAlphaThreshold(0.5)
    clippingNode:setCascadeOpacityEnabled(true)
    self.ui.panel_light:addChild(clippingNode)
    clippingNode:setPosition(self.chapterLineImgUIArr[index]:getPosition())
    local lightImg = ed.createSprite("UI/alpha/1080P/dungeon/chapter/line_light.png")
    clippingNode:addChild(lightImg)
    effectInfo = {}
    effectInfo.clippingNode = clippingNode
    effectInfo.lightImg = lightImg
    self.chapterLightEffectUITab[index] = effectInfo
  else
    effectInfo.clippingNode:setVisible(true)
  end
  effectInfo.lightImg:stopAllActions()
  local pointArr = LineEffectMovePath[index]
  effectInfo.lightImg:setPosition(pointArr[1])
  local angle = self:getLightImgRotation(pointArr[2], pointArr[1])
  effectInfo.lightImg:setRotation(angle)
  local speed = 450
  local moveArr = {}
  for i, v in ipairs(pointArr) do
    if i ~= 1 then
      local lastPoint = pointArr[i - 1]
      local diffX = v.x - lastPoint.x
      local diffY = v.y - lastPoint.y
      local t = math.sqrt(diffX * diffX + diffY * diffY) / speed
      local moveAction = CCMoveTo:create(t, v)
      local rotAction = CCRotateTo:create(0.001, self:getLightImgRotation(v, lastPoint))
      table.insert(moveArr, rotAction)
      table.insert(moveArr, moveAction)
    end
  end
  table.insert(moveArr, CCCallFunc:create(function()
    effectInfo.lightImg:setPosition(pointArr[1])
    effectInfo.lightImg:setRotation(angle)
  end))
  local sequence = CCSequence:create(ccArrayMake(unpack(moveArr)))
  effectInfo.lightImg:runAction(CCRepeatForever:create(sequence))
end

function class:stopLightEffect(index)
  self.chapterLineImgUIArr[index]:setOpacity(255)
  local effectInfo = self.chapterLightEffectUITab[index]
  if nil == effectInfo then
    return
  end
  effectInfo.clippingNode:setVisible(false)
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
    txt = ed.awakeDungeonDefine.RULES_TEXT
  }):popWindow()
end

function class:onClickDungeonLevel()
  ed.UITool.openView("awakeDungeonLevelScene")
end

function class:onClickChapter(index)
  local chapterTableItem = self.chapterTableItemList[index]
  local chapterId = chapterTableItem["Chapter ID"]
  ed.UITool.openView("awakeDungeonChapterInfo", {chapterId = chapterId})
end

function class:onPopScene()
  ed.redPointMgr.getInstance():unregisterValueChange("awake_dungeon_reward_entry", self)
  base.onPopScene(self)
end

function class:onReplyOpenPanel()
  self:refreshUI()
end

function class:registerTouchEvents()
  self:btRegisterButtonClick({
    button = self.ui.image_level_bg,
    pressScale = 0.98,
    key = "click_dungeon_level",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.dungeon_iron)
      self:onClickDungeonLevel()
    end,
    force = true,
    clickInterval = 0.2,
    priority = -999
  })
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.98, priority = -999})
  self:btRegisterClick({
    key = "img_sweep_closed",
    checkClickHandler = function(x, y)
      if ed.containsPoint(self.ui.img_sweep_closed, x, y) then
        return true
      end
      return false
    end,
    pressHandler = function(param, x, y)
      self.touchSweepPanelPosX, self.touchSweepPanelPosY = self.ui.panel_sweep:getPosition()
    end,
    moveHandler = function(param, x, y)
      local newPosX = self.touchSweepPanelPosX
      local newPosY = self.touchSweepPanelPosY + y - param.moveParam.pressY
      self.ui.panel_sweep:setPosition(newPosX, ed.clamp(newPosY, self.moveSweepPanelMinY, self.moveSweepPanelMaxY))
    end,
    clickHandler = function(param, x, y)
      self:setSweepState(true)
    end,
    mcpMode = true,
    mcp_dis = 30,
    pressScale = 0.98
  })
  ed.UITool.registerBtn(self, "img_sweep_opened_title", function()
    self:setSweepState(false)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_sweep_1", function()
    self:onSweepEvent(1)
  end, {pressScale = 0.8, normalScale = 0.85})
  ed.UITool.registerBtn(self, "btn_sweep_2", function()
    self:onSweepEvent(10)
  end, {pressScale = 0.8, normalScale = 0.85})
  for i = 1, 5 do
    local touchPanel = self.ui["btn_chapter_" .. i]
    local progressBg = self.ui["bg_progress_" .. i]
    ed.UITool.registerBtn(self, "bg_reward_box_" .. i, function()
      self:onClickReward(i)
    end, {pressScale = 0.98, normalScale = 1})
    ed.UITool.registerBtn(self, "img_chapter_" .. i, function()
      self:onClickChapter(i)
    end, {
      radius = 3000,
      pressScale = 0.98,
      extraCheckHandler = function(x, y)
        return ed.containsPoint(touchPanel, x, y) or ed.containsPoint(progressBg, x, y)
      end
    })
  end
end

function class:registerListenEvents()
  self:registerOnEnterHandler("onEnter", function()
    if self.firstEnterScene then
      self.firstEnterScene = false
      return
    end
    self:checkLevelChanged()
    self.resourceBox:updateAllResourceValue()
    self:refreshSweepNum()
    self:refreshMap()
  end)
  self:listenEvent("awakeDungeonSweepComplete", function()
    self:checkLevelChanged()
  end)
  self:listenEvent("dungeonVitalityChanged", function()
    self.resourceBox:updateAllResourceValue()
  end)
  self:listenEvent("awakeDungeonChapterRewardComplete", function(chapterId)
    for i, v in ipairs(self.chapterTableItemList) do
      if v["Chapter ID"] == chapterId then
        local redImg = self.chapterRedImgUIArr[i]
        local progressVal = self.dungeonMgr:getChapterProgress(chapterId)
        redImg:setVisible(100 <= progressVal and not self.dungeonMgr:isChapterRewardComplete(chapterId))
        break
      end
    end
  end)
end
