local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.awakeDungeonLevelScene = class
class.REWARD_STATE_LOCK = "reward_state_lock"
class.REWARD_STATE_ACHIEVE = "reward_state_achieve"
class.REWARD_STATE_COMPLETED = "reward_state_completed"
local res = ed.heroDetailManager.resConfig
ed.UITool.registViewOpenFunc("awakeDungeonLevelScene", function()
  local scene = class.create()
  ed.pushScene(scene)
end)

function class.create()
  local self = base.create("awakeDungeonLevelScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.chapterGroup = self.dungeonMgr:getChapterGroup()
  self.levelGroup = self.dungeonMgr:getLevelGroup()
  self.curSelectLevel = self.dungeonMgr:getParagonLevel()
  self.leftEmptyBtnAmount = 2
  self.rightEmptyBtnAmount = 2
  self.btnWidth = 125
  self.clickHeroTimes = 0
  self.clickSpeedUpInterval = 2
  self.speedLevel = 1
  self.speelMaxLevel = 10
  local randomStateList = {"sleep", "run"}
  self.heroState = randomStateList[math.random(1, #randomStateList)]
  self.conveyerBeltMaxSpeed = 10
  self:initUI()
  self:registerTouchEvents()
  self:registerListenEvents()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonLevelScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  self:setBackground()
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  ed.UITool.createSceneTitle(T("\231\159\174\228\186\186\231\167\145\230\138\128"), self.ui.title_bg, {
    position = ccp(9, 19)
  })
  ed.setLabelStroke(self.ui.label_cur_level, ed.toccc3(15633958), 1.5)
  ed.setLabelStroke(self.ui.label_exp, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_level_not_enough, ed.toccc3(2168853), 1.5)
  ed.setLabelStroke(self.ui.label_get_reward, ed.toccc3(15633958), 1.5)
  ed.setLabelStroke(self.ui.label_achieve, ed.toccc3(3809813), 1)
  self:adaptUI()
  self:initEffect()
  self:initHeroEff()
  self:initAttrDragList()
  self:initLevelBtnLayer()
  self:initLevelBtns()
  self:refreshMyLevel()
  self:refreshUI()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.title_bg, {left = 75, top = 20}, false, true)
end

function class:initEffect()
  local eff_Gear = ed.createFcaActor("eff_UI_Dungeon_gear")
  eff_Gear:setAction("Loop")
  eff_Gear:setLoop(true)
  self:addFca(eff_Gear)
  self.ui.image_bg_1:setVisible(false)
  eff_Gear:setPosition(ccp(375, 365))
  self.ui.bg:addChild(eff_Gear)
  local eff_Gear2 = ed.createFcaActor("eff_UI_Dungeon_gear2")
  eff_Gear2:setAction("Loop")
  eff_Gear2:setLoop(true)
  self:addFca(eff_Gear2)
  eff_Gear2:setPosition(ccp(201, 55))
  self.ui.cur_level_bg:addChild(eff_Gear2)
  self.eff_Gear2 = eff_Gear2
  local eff_Light = ed.createFcaActor("eff_UI_Dungeon_canup")
  self.eff_Light = eff_Light
  eff_Light:setAction("Start")
  eff_Light:setLoop(true)
  self:addFca(eff_Light)
  eff_Light:setPosition(ccp(339, 203))
  self.ui.image_detail_bg:addChild(eff_Light)
  local eff_can = ed.createFcaActor("eff_UI_Dungeon_can")
  eff_can:setAction("Loop")
  eff_can:setLoop(true)
  self:addFca(eff_can)
  eff_can:setPosition(ccp(137, 47))
  self.ui.btn_get_reward:addChild(eff_can)
end

function class:initHeroEff()
  local eff_Hero = ed.createFcaActor("eff_UI_Dungeon_hero")
  eff_Hero:setAction("Loop")
  eff_Hero:setLoop(true)
  self:addFca(eff_Hero)
  eff_Hero:setPosition(ccp(186, 105))
  self.ui.cur_level_bg:addChild(eff_Hero)
  self.eff_Hero = eff_Hero
  self:refreshHeroAction()
end

function class:initAttrDragList()
  self.attrDragList = ed.UITool.createDraglist(self.ui.panel_level_attr)
end

function class:initLevelBtnLayer()
  local container = self.ui.panel_level_item_list
  local containerSize = container:getContentSize()
  container:setClipRect(CCRectMake(0, 0, containerSize.width, containerSize.height))
  local btnLayer = CCLayer:create()
  btnLayer:setContentSize(containerSize)
  container:addChild(btnLayer)
  self.btnLayer = btnLayer
end

function class:initLevelBtns()
  local maxLevel = self.dungeonMgr:getMaxParagonLevel()
  self.btnPosList = {}
  self.btnList = {}
  self.levelBtnList = {}
  local btnWidth = self.btnWidth
  local posX = 0
  local btnIndex = 1
  for index = 1, self.leftEmptyBtnAmount do
    local btn = self:createEmptyLevelBtn()
    local pos = ccp(posX + btnWidth / 2, 63)
    btn:setPosition(pos)
    self.btnPosList[btnIndex] = pos
    self.btnList[btnIndex] = btn
    btnIndex = btnIndex + 1
    posX = posX + btnWidth
    self.btnLayer:addChild(btn)
  end
  for level = 1, maxLevel do
    local btn = self:refreshLevelBtn(level)
    local pos = ccp(posX + btnWidth / 2, 63)
    btn:setPosition(pos)
    self.btnPosList[btnIndex] = pos
    self.btnList[btnIndex] = btn
    btnIndex = btnIndex + 1
    posX = posX + btnWidth
    self.btnLayer:addChild(btn)
  end
  for index = 1, self.rightEmptyBtnAmount do
    local btn = self:createEmptyLevelBtn()
    local pos = ccp(posX + btnWidth / 2, 63)
    btn:setPosition(pos)
    self.btnPosList[btnIndex] = pos
    self.btnList[btnIndex] = btn
    btnIndex = btnIndex + 1
    posX = posX + btnWidth
    self.btnLayer:addChild(btn)
  end
  self.btnLayer:setContentSize(CCSizeMake(posX, self.ui.panel_level_item_list:getContentSize().height))
  self.listMaxPosX = 0
  self.listMinPosX = self.ui.panel_level_item_list:getContentSize().width - self.btnLayer:getContentSize().width
  self.btnLayer:setPositionX(self:getBtnListPosXByLevel(self.curSelectLevel))
end

function class:getBtnListPosXByLevel(level)
  local btnPosX = self.btnPosList[level].x
  return -btnPosX + self.btnWidth / 2
end

function class:fixLevelBtnsPos(direction)
  local btnWidth = self.btnWidth
  local posX = self.btnLayer:getPositionX()
  local targetPosX, targetLevel
  if direction == "left" then
    for index = 1, #self.btnPosList do
      local btnPosX = self.btnPosList[index].x
      if posX > -btnPosX + btnWidth / 2 then
        targetPosX = -btnPosX
        targetLevel = index
        break
      end
    end
  else
    for index = #self.btnPosList, 1, -1 do
      local btnPosX = self.btnPosList[index].x
      if posX < -btnPosX + btnWidth / 2 then
        targetPosX = -btnPosX
        targetLevel = index
        break
      end
    end
  end
  if targetPosX then
    targetPosX = targetPosX + btnWidth / 2
    targetPosX = math.max(self.listMinPosX, targetPosX)
    targetPosX = math.min(self.listMaxPosX, targetPosX)
    local action = CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(targetPosX, 0)))
    local callFunc = CCCallFunc:create(function()
      local oldSelectLevel = self.curSelectLevel
      if targetLevel == oldSelectLevel then
        return
      end
      self.curSelectLevel = targetLevel
      self:refreshLevelBtn(oldSelectLevel, true)
      self:refreshLevelBtn(targetLevel, true)
      self:refreshUI()
    end)
    self.btnLayer:runAction(ed.readaction.create({
      t = "seq",
      action,
      callFunc
    }))
    ed.playEffect(ed.sound.deo.dungeon_gear_switch)
  end
end

function class:onUpdateLevelBtn(event, x, y)
  if event == "began" then
    if not ed.containsPoint(self.ui.panel_level_item_list, x, y) then
      return
    end
    self.isPressInRect = true
    self.beganPosX = x
    self.startPosX = self.btnLayer:getPositionX()
    self.pressInCfg = self:doPressInHandler(event, x, y)
  elseif event == "moved" then
    if not self.isPressInRect then
      return false
    end
    local changePosX = x - self.beganPosX
    local startMove = 14
    if startMove < math.abs(changePosX) then
      self:doCancelClickInHandler()
      if changePosX < 0 then
        local targetPosX = self.startPosX + changePosX + startMove
        targetPosX = math.max(self.listMinPosX, targetPosX)
        self.btnLayer:setPositionX(targetPosX)
      else
        local targetPosX = self.startPosX + changePosX - startMove
        targetPosX = math.min(self.listMaxPosX, targetPosX)
        self.btnLayer:setPositionX(targetPosX)
      end
    end
  elseif event == "ended" then
    if not self.isPressInRect then
      return false
    end
    self.isPressInRect = false
    if x - self.beganPosX > 10 then
      self:fixLevelBtnsPos("right")
    elseif self.beganPosX - x > 10 then
      self:fixLevelBtnsPos("left")
    end
    self:doClickInHandler(x, y)
  end
  return false
end

function class:onLevelBtnMove()
  local containerWidth = self.ui.panel_level_item_list:getContentSize().width
  local halfWidth = containerWidth / 2
  local btnWidth = self.btnWidth
  local listPosX = self.btnLayer:getPositionX()
  if self.listPosX == listPosX then
    return
  end
  self.listPosX = listPosX
  local leftPosX = -listPosX
  local centerPosX = -listPosX + containerWidth / 2
  local rightPosX = -listPosX + containerWidth
  local edgeWidth = 50
  for index, btnPos in ipairs(self.btnPosList or {}) do
    local btn = self.btnList[index]
    local scale = (halfWidth - math.abs(btnPos.x - centerPosX)) / halfWidth * 0.2 + 0.8
    btn:setScale(scale)
    if leftPosX < btnPos.x and rightPosX > btnPos.x then
      btn:setVisible(true)
    else
      btn:setVisible(false)
    end
    if btnPos.x - leftPosX > 0 and edgeWidth > btnPos.x - leftPosX then
      local scaleX = (0.55 * (btnPos.x - leftPosX) + 0.25 * edgeWidth) / edgeWidth
      local opacity = 205 * (btnPos.x - leftPosX) / edgeWidth + 50
      btn:setOpacity(opacity)
      btn:setScaleX(scaleX)
    elseif btnPos.x > rightPosX - edgeWidth and rightPosX > btnPos.x then
      local scaleX = (0.55 * (rightPosX - btnPos.x) + 0.25 * edgeWidth) / edgeWidth
      local opacity = 205 * (rightPosX - btnPos.x) / edgeWidth + 50
      btn:setOpacity(opacity)
      btn:setScaleX(scaleX)
    else
      btn:setOpacity(255)
    end
  end
  self:refreshRedDot()
end

function class:refreshRedDot()
  local listPosX = self.btnLayer:getPositionX()
  local centerLevel = math.floor(-listPosX / self.btnWidth) + 1
  local maxLevel = self.dungeonMgr:getMaxParagonLevel()
  if centerLevel <= 0 then
    self.ui.left_red_dot:setVisible(false)
    return
  elseif centerLevel > maxLevel then
    self.ui.right_red_dot:setVisible(false)
    return
  end
  local isShowLeftRedDot = false
  local isShowRightRedDot = false
  for level = 1, centerLevel - self.leftEmptyBtnAmount - 1 do
    local rewardState = self.dungeonMgr:getLevelRewardState(level)
    if rewardState == ed.awakeDungeonDefine.LEVEL_REWARD_AVAILABLE then
      isShowLeftRedDot = true
      break
    end
  end
  for level = centerLevel + self.rightEmptyBtnAmount + 1, maxLevel do
    local rewardState = self.dungeonMgr:getLevelRewardState(level)
    if rewardState == ed.awakeDungeonDefine.LEVEL_REWARD_AVAILABLE then
      isShowRightRedDot = true
      break
    end
  end
  self.ui.left_red_dot:setVisible(isShowLeftRedDot)
  self.ui.right_red_dot:setVisible(isShowRightRedDot)
end

function class:doPressInHandler(event, x, y)
  for level, cfg in pairs(self.levelBtnList or {}) do
    local btnBg = cfg.btnBg
    if ed.containsPoint(btnBg, x, y) then
      return {btn = btnBg, level = level}
    end
  end
end

function class:doClickInHandler(x, y)
  if self.pressInCfg then
    local level = self.pressInCfg.level
    local btn = self.pressInCfg.btn
    if not ed.containsPoint(btn, x, y) then
      return
    end
    local oldSelectLevel = self.curSelectLevel
    if level == self.curSelectLevel then
      return
    end
    self.curSelectLevel = level
    self:refreshLevelBtn(oldSelectLevel, true)
    self:refreshLevelBtn(level, true)
    local targetPosX = self:getBtnListPosXByLevel(level)
    local move = CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(targetPosX, 0)))
    self.btnLayer:runAction(move)
    ed.playEffect(ed.sound.deo.dungeon_gear_switch)
    self:refreshUI()
  end
end

function class:doCancelClickInHandler()
  self.pressInCfg = nil
end

function class:createEmptyLevelBtn()
  local bgPath = "UI/alpha/1080P/dungeon/level/level_gear_1.png"
  local btnBg = ed.createSprite(bgPath)
  return btnBg
end

function class:refreshLevelBtn(level, isUpdate)
  local rewardState = self.dungeonMgr:getLevelRewardState(level)
  local bgPath, labelColor, labelStroke, maskPath
  if level == self.curSelectLevel then
    bgPath = "UI/alpha/1080P/dungeon/level/level_gear_2.png"
    labelColor = ccc3(250, 126, 46)
    labelStroke = ed.toccc3(15448092)
  elseif rewardState == ed.awakeDungeonDefine.LEVEL_REWARD_COMPLETED then
    bgPath = "UI/alpha/1080P/dungeon/level/level_gear_6.png"
    labelColor = ccc3(255, 239, 207)
  else
    bgPath = "UI/alpha/1080P/dungeon/level/level_gear_1.png"
    labelColor = ccc3(106, 80, 50)
  end
  local btnBg, labelLevel, mask, redDot
  if isUpdate then
    local cfg = self.levelBtnList[level]
    if not cfg then
      return
    end
    btnBg = cfg.btnBg
    labelLevel = cfg.labelLevel
    mask = cfg.mask
    redDot = cfg.redDot
    ed.setTexture(btnBg, bgPath)
  else
    btnBg = ed.createSprite(bgPath)
    labelLevel = ed.createttf(level, 34)
    btnBg:addChild(labelLevel)
    ed.layout.centerInParent(labelLevel)
    redDot = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
    btnBg:addChild(redDot)
    redDot:setPosition(ccp(95, 110))
    mask = ed.createSprite("UI/alpha/1080P/dungeon/level/level_achieve.png")
    btnBg:addChild(mask)
    mask:setPosition(ccp(71, 34))
  end
  mask:setVisible(rewardState == ed.awakeDungeonDefine.LEVEL_REWARD_COMPLETED)
  ed.setLabelString(labelLevel, level)
  ed.setLabelColor(labelLevel, labelColor)
  if labelStroke then
    ed.setLabelStroke(labelLevel, labelStroke, 1)
  else
    ed.setLabelStroke(labelLevel, ccc3(255, 255, 255), 0)
  end
  redDot:setVisible(rewardState == ed.awakeDungeonDefine.LEVEL_REWARD_AVAILABLE)
  self.levelBtnList[level] = {
    level = level,
    btnBg = btnBg,
    labelLevel = labelLevel,
    mask = mask,
    redDot = redDot
  }
  btnBg:setCascadeOpacityEnabled(true)
  return btnBg
end

function class:refreshUI()
  self:refreshLevelAttr()
  self:refreshRewardInfo()
end

function class:refreshLevelAttr()
  self.attrDragList:clearList()
  local containerHeigh = self.ui.panel_level_attr:getContentSize().height
  local titleOffsetX = 220
  local attrOffsetX = 95
  local gapY = 7
  self.containerHeigh = containerHeigh
  self.height = 0
  self.gapY = gapY
  local rewardState = self.dungeonMgr:getLevelRewardState(self.curSelectLevel)
  local attrIsUnlock = rewardState ~= ed.awakeDungeonDefine.LEVEL_REWARD_UNCOMPLETED
  local title1 = self:createAttrTitle(T("\229\156\176\229\186\149\229\142\134\233\153\169\229\177\158\230\128\167\230\143\144\229\141\135"), attrIsUnlock)
  self:attrListAddItem(title1, titleOffsetX)
  local attr = self:createAttr(string.format(T("\230\137\128\230\156\137\232\139\177\233\155\132\231\167\145\230\138\128\231\173\137\231\186\167+1\231\186\167\239\188\136\230\128\187\231\173\137\231\186\167%s\239\188\137"), self.curSelectLevel), attrIsUnlock)
  self:attrListAddItem(attr, attrOffsetX)
  local changeEnergy, maxEnergy = self:getEnergyLevelUp(self.curSelectLevel)
  if changeEnergy and maxEnergy then
    local attr = self:createAttr(string.format(T("\232\131\189\233\135\143\228\184\138\233\153\144\230\143\144\229\141\135%s\231\130\185\239\188\136\232\131\189\233\135\143\228\184\138\233\153\144%s\239\188\137"), changeEnergy, maxEnergy), attrIsUnlock)
    self:attrListAddItem(attr, attrOffsetX)
  end
  local awakeHeroExtAttrList = self:getAwakeHeroExtraAttr(self.curSelectLevel)
  for index, awakeHeroExtAttrCfg in ipairs(awakeHeroExtAttrList) do
    local labelColor, attrColor
    if attrIsUnlock then
      labelColor = "ccc3(255,252,231)"
      attrColor = "ccc3(255,182,56)"
    else
      labelColor = "ccc3(206,190,162)"
      attrColor = "ccc3(212,208,201)"
    end
    local content = string.format("<lable color=%s size=16 strokeColor=ccc3(15,30,17) strokeSize=1>%s</lable>", labelColor, awakeHeroExtAttrCfg.heroName)
    local spaceTab = {
      cn = "",
      tw = "",
      en = " ",
      ko = " ",
      ja = " ",
      es = " "
    }
    for _, attrCfg in ipairs(awakeHeroExtAttrCfg.extAttrList or {}) do
      local attrAutoText = string.format("<lable color=%s size=16 strokeColor=ccc3(15,30,17) strokeSize=1>%s</lable>", labelColor, res.att_cn_name[attrCfg.attrName]) .. string.format("<lable color=%s size=16 strokeColor=ccc3(15,30,17) strokeSize=1>+%s</lable>", attrColor, attrCfg.attrNum)
      content = content .. (spaceTab[EDCurLanguage] or " ") .. attrAutoText
    end
    local attr = self:createAttr(content, attrIsUnlock, true)
    self:attrListAddItem(attr, attrOffsetX)
  end
  if self.height < self.containerHeigh then
    self.attrDragList:setListPos(ccp(0, -(containerHeigh - self.height) / 2))
  end
  self.attrDragList:initListHeight(self.height)
end

function class:attrListAddItem(item, offsetX)
  offsetX = offsetX or 0
  local itemHeight = item:getContentSize().height or 0
  self.attrDragList:addItem(item)
  item:setPosition(ccp(offsetX, self.containerHeigh - self.height))
  self.height = self.height + self.gapY + itemHeight
end

function class:createAttrTitle(text, isAvailable)
  local bgPath, titleColor, titleStroke
  if not isAvailable then
    bgPath = "UI/alpha/1080P/dungeon/level/level_title_bg_1.png"
    titleColor = ccc3(162, 150, 126)
    titleStroke = ed.toccc3(4600341)
  else
    bgPath = "UI/alpha/1080P/dungeon/level/level_title_bg_2.png"
    titleColor = ccc3(250, 217, 160)
    titleStroke = ed.toccc3(6369050)
  end
  local attrTitleBg = ed.createScale9Sprite(bgPath, CCRectMake(45, 1, 5, 22))
  attrTitleBg:setAnchorPoint(ccp(0.5, 1))
  local bg_width = ed.isAreaZh() and 330 or 430
  attrTitleBg:setContentSize(CCSizeMake(bg_width, 34))
  local attrTitle = ed.createttf(text, 20, ed.fontBold)
  attrTitleBg:addChild(attrTitle)
  ed.layout.centerInParent(attrTitle)
  ed.setLabelColor(attrTitle, titleColor)
  ed.setLabelStroke(attrTitle, titleStroke, 1)
  return attrTitleBg
end

function class:createAttr(text, isAvailable, isAutoText)
  local dotPath, attrColor
  if not isAvailable then
    dotPath = "UI/alpha/1080P/dungeon/level/level_point_1.png"
    attrColor = "ccc3(206,190,162)"
  else
    dotPath = "UI/alpha/1080P/dungeon/level/level_point_2.png"
    attrColor = "ccc3(255,252,231)"
  end
  local dot = ed.createSprite(dotPath)
  local context
  if isAutoText then
    context = text
  else
    context = string.format("<lable color=%s size=16 strokeColor=ccc3(15,30,17) strokeSize=1>%s</lable>", attrColor, text)
  end
  local autoText = ed.ui.autoText.new()
  local deltaX = ed.isAreaZh() and 0 or 70
  autoText:initParam({
    context = context,
    maxWidth = 380 + deltaX,
    fontSize = 18
  })
  autoText:limitWidthByScale(340 + deltaX)
  local w, h = autoText:getCurContentSize()
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0.5))
  container:setContentSize(CCSizeMake(w, h))
  container:addChild(autoText.node)
  container:addChild(dot)
  local hei = (h - autoText:getFirstLineHeight()) * 0.5
  autoText.node:setPosition(ccp(-deltaX, hei))
  dot:setPosition(ccp(-deltaX - 15, hei))
  return container
end

function class:getUnlockChapter(level)
  local chapterGroup = self.dungeonMgr:getChapterGroup()
  local unlockChapterList = {}
  for chapterId, chapterCfg in pairs(ed.getDataTable("DungeonChapter")[chapterGroup] or {}) do
    if level == chapterCfg["Unlock Paragon Level"] then
      table.insert(unlockChapterList, {
        chapterId = chapterId,
        chapterName = chapterCfg["Chapter Name"] or ""
      })
    end
  end
  return unlockChapterList
end

function class:getEnergyLevelUp(level)
  local preLevel = level - 1
  if preLevel <= 0 then
    return
  end
  local levelGroup = self.dungeonMgr:getLevelGroup()
  local preMaxVitality = ed.getDataTable("ParagonLevel")[levelGroup][preLevel]["Max Vitality"]
  local maxVitality = ed.getDataTable("ParagonLevel")[levelGroup][level]["Max Vitality"]
  local changeVitality = maxVitality - preMaxVitality
  if 0 < changeVitality then
    return changeVitality, maxVitality
  end
end

function class:getAwakeHeroExtraAttr(level)
  local extAttrInfo = {}
  local levelGroup = self.dungeonMgr:getLevelGroup()
  local extAttrIdList = ed.getDataTable("ParagonLevel")[levelGroup][level].ExtraAttributes
  if extAttrIdList and 0 < #extAttrIdList then
    local extAttrTB = ed.getDataTable("ExtraAttributes")
    for _, extAttrId in ipairs(extAttrIdList) do
      local extAttrCfg = extAttrTB[extAttrId]
      local heroName = ed.getDataTable("Unit")[extAttrCfg.UnitID]["Display Name"]
      local extAttrList = {}
      for attrName, attrNum in pairs(extAttrCfg) do
        if attrName ~= "ID" and attrName ~= "UnitID" and 0 < attrNum then
          table.insert(extAttrList, {attrName = attrName, attrNum = attrNum})
        end
      end
      table.insert(extAttrInfo, {heroName = heroName, extAttrList = extAttrList})
    end
  end
  return extAttrInfo
end

function class:getBossStageUnlock(level)
  local unlockBossStageList = {}
  local dungeonStageTB = ed.getDataTable("DungeonStage")
  local startStageId, endStageId = self.dungeonMgr:getStageIdRange()
  for bossGroup, difficultyCfg in ipairs(ed.getDataTable("DungeonBoss")) do
    for difficulty, bossCfg in ipairs(difficultyCfg) do
      local stageId = bossCfg["Stage ID"]
      if startStageId <= stageId and stageId <= endStageId + 3 then
        local unlockLevel = dungeonStageTB[stageId]["Unlock Paragon Level"]
        if unlockLevel == level then
          table.insert(unlockBossStageList, {
            bossName = bossCfg["Boss Name"],
            difficulty = difficulty
          })
        end
      end
    end
  end
  return unlockBossStageList
end

function class:refreshMyLevel()
  local paragonLevel = self.dungeonMgr:getParagonLevel()
  ed.setLabelString(self.ui.label_cur_level, string.format(T("\231\173\137\231\186\167%s"), paragonLevel))
  local barPercent
  if paragonLevel >= self.dungeonMgr:getMaxParagonLevel() then
    ed.setLabelString(self.ui.label_exp, "MAX")
    barPercent = 1
  else
    local maxExp = self.dungeonMgr:getMaxExp(paragonLevel)
    local curExp = self.dungeonMgr:getParagonExp()
    barPercent = curExp / maxExp
    ed.setLabelString(self.ui.label_exp, string.format("%s/%s", curExp, maxExp))
  end
  local clipSize = self.ui.panel_exp_clip:getContentSize()
  self.ui.panel_exp_clip:setClipRect(CCRectMake(0, 0, clipSize.width * barPercent, clipSize.height))
end

function class:refreshRewardInfo()
  local paragonLevel = self.dungeonMgr:getParagonLevel()
  local levelGroup = self.dungeonMgr:getLevelGroup()
  local paragonLevelCfg = ed.getDataTable("ParagonLevel")[levelGroup][self.curSelectLevel]
  local rewardState = self.dungeonMgr:getLevelRewardState(self.curSelectLevel)
  if self.dungeonMgr:checkParagonLevelInFlag(self.curSelectLevel) then
    rewardState = class.REWARD_STATE_COMPLETED
  elseif paragonLevel >= self.curSelectLevel then
    rewardState = class.REWARD_STATE_ACHIEVE
  else
    rewardState = class.REWARD_STATE_LOCK
  end
  local rewardList = {}
  for index = 1, 20 do
    local rewardType = paragonLevelCfg["Reward Type " .. index]
    local rewardId = paragonLevelCfg["Reward ID " .. index]
    local rewardAmount = paragonLevelCfg["Reward Amount " .. index]
    if not rewardAmount or rewardAmount == 0 then
      break
    end
    table.insert(rewardList, {
      id = rewardId,
      type = rewardType,
      amount = rewardAmount,
      rewardState = rewardState
    })
  end
  self:createRewardItemList(self.ui.reward_item_list, rewardList)
  self.ui.btn_get_reward:setVisible(rewardState == class.REWARD_STATE_ACHIEVE)
  self.ui.btn_achieve:setVisible(rewardState == class.REWARD_STATE_COMPLETED)
  self.ui.label_level_not_enough:setVisible(rewardState == class.REWARD_STATE_LOCK)
  if rewardState == class.REWARD_STATE_ACHIEVE then
    ed.setTexture(self.ui.reward_bg, "UI/alpha/1080P/dungeon/level/level_button_light_1.png")
    self.eff_Light:setVisible(true)
  else
    ed.setTexture(self.ui.reward_bg, "UI/alpha/1080P/dungeon/level/level_button_light_2.png")
    self.eff_Light:setVisible(false)
  end
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
  local posX, gapX = 0, -20
  for _, itemData in ipairs(rewardList) do
    local icon = self:createRewardItem(itemData)
    local scale = 0.8
    icon:setScale(scale)
    local iconSize = icon:getContentSize()
    rewardDragList:addItem(icon)
    icon:setPosition(ccp(iconSize.width / 2 + posX, iconSize.height / 2 * scale))
    posX = posX + iconSize.width + gapX
    table.insert(itemList, {icon = icon, itemData = itemData})
  end
  rewardDragList:initListWidth(posX)
  if posX < container:getContentSize().width then
    rewardDragList:setListPos(ccp((container:getContentSize().width - posX) / 2 - 10, 0))
  end
end

function class:createRewardItem(itemData)
  local icon = ed.createItemIcon({
    id = itemData.id,
    type = itemData.type,
    amount = itemData.amount
  })
  if itemData.rewardState == class.REWARD_STATE_COMPLETED then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    local imageReceived = ed.createSprite("UI/alpha/1080P/package/selected.png")
    icon:addChild(mask, 1)
    icon:addChild(imageReceived, 2)
    imageReceived:setScale(0.7)
    imageReceived:setPosition(ccp(65, 25))
    mask:setPosition(ccp(45, 45))
  end
  return icon
end

function class:resetSpeed()
  self.clickHeroTimes = 0
  self.speedLevel = 1
end

function class:refreshHeroAction(isResetTimer)
  local actionName, nextActionName, conveyerBeltSpeed, bubbleText, bubbleShowDelayTime
  local loop = true
  local notClickDelay = 3
  if self.heroState == "cheer" then
    actionName = "Start_cheer"
    conveyerBeltSpeed = 0
    bubbleText = T("\229\165\189\232\128\182")
  elseif self.heroState == "run" then
    actionName = "Loop" .. self.speedLevel
    conveyerBeltSpeed = self.speedLevel / self.speelMaxLevel * self.conveyerBeltMaxSpeed
    if self.speedLevel > 1 and self.speedLevel <= 6 then
      bubbleText = T("\232\191\152\232\131\189\230\155\180\229\191\171\239\188\129")
    elseif self.speedLevel > 6 and self.speedLevel <= 8 then
      bubbleText = T("\228\184\141\232\161\140\228\186\134\239\188\140\228\184\141\232\161\140\228\186\134")
    elseif self.speedLevel > 8 and self.speedLevel <= 10 then
      bubbleText = T("\229\149\138\229\149\138\229\149\138\229\149\138\229\149\138\239\188\129\239\188\129\239\188\129")
    end
  elseif self.heroState == "rest" then
    if self.speedLevel <= 6 then
      actionName = "Start_rest_a"
      bubbleText = T("\229\145\188......")
    elseif self.speedLevel <= 8 then
      actionName = "Start_rest_b"
      bubbleText = T("\231\180\175\230\173\187\228\186\134\239\188\140\230\173\135\228\188\154\229\132\191......")
    else
      actionName = "Start_rest_c"
      nextActionName = "Loop_rest_c"
      bubbleText = T("zzz......")
      notClickDelay = 10
      bubbleShowDelayTime = 1
    end
    conveyerBeltSpeed = 0
  elseif self.heroState == "sleep" then
    actionName = "Loop_rest_c"
    conveyerBeltSpeed = 0
    bubbleText = T("zzz......")
  else
    actionName = "Loop"
    conveyerBeltSpeed = 1
  end
  if self.actionName ~= actionName then
    self.actionName = actionName
    self.eff_Hero:setAction(actionName)
    if nextActionName then
      self.eff_Hero:setNextAction(nextActionName)
    end
    self.eff_Hero:setLoop(loop)
    self.eff_Gear2:setActionSpeeder(conveyerBeltSpeed)
    if bubbleText then
      if bubbleShowDelayTime then
        self:listenTimer(Timer:Once(bubbleShowDelayTime), function()
          self:showBubble(self.ui.bg, bubbleText)
        end)
      else
        self:showBubble(self.ui.bg, bubbleText)
      end
    end
  end
  if isResetTimer then
    if self.notClickTimer then
      CloseTimer(self.notClickTimer.Name)
    end
    self.notClickTimer = self:listenTimer(Timer:Once(notClickDelay, "notClickTimer"), function()
      if self.heroState == "run" then
        self.heroState = "rest"
        self:refreshHeroAction(true)
        self:resetSpeed()
      elseif self.heroState == "cheer" or self.heroState == "rest" then
        self.heroState = "run"
        self:resetSpeed()
        self:refreshHeroAction()
      end
    end)
  end
end

function class:showBubble(parent, text)
  if self.talkFrame then
    self.talkFrame:removeFromParentAndCleanup(true)
    self.talkFrame = nil
  end
  local param = {
    text = text,
    fontSize = 18,
    fontColor = ed.toccc3(16777215),
    res = "UI/alpha/1080P/dungeon/level/level_talk.png",
    scale9rectMake = CCRectMake(40, 50, 90, 10),
    scale = 1,
    bubbleDelayTime = 2,
    bubbleFadeOutTime = 1,
    labelDelayTime = 2,
    labelFadeOutTime = 1,
    magin = {
      left = 10,
      right = 10,
      top = 10,
      bottom = 15
    },
    fadeOutEndCallBack = function()
      if not tolua.isnull(self.talkFrame) then
        self.talkFrame:removeFromParentAndCleanup(true)
        self.talkFrame = nil
      end
    end
  }
  local frame = ed.createDialogBubble(param)
  self.talkFrame = frame
  parent:addChild(frame, 999)
  frame:setPosition(ccp(298, 498))
end

function class:onClickGetReward()
  self.heroState = "cheer"
  self:resetSpeed()
  self:refreshHeroAction(true)
  ed.AwakeDungeonNetwork.sendLevelRewards(self.curSelectLevel)
  ed.playEffect(ed.sound.deo.dungeon_gear_activate)
end

function class:onClickHero()
  if self.heroState == "sleep" or self.heroState == "rest" or self.heroState == "cheer" then
    self.heroState = "run"
    self:resetSpeed()
  end
  self.clickHeroTimes = self.clickHeroTimes + 1
  self.speedLevel = math.floor(self.clickHeroTimes / self.clickSpeedUpInterval) + 1
  self.speedLevel = math.min(self.speedLevel, self.speelMaxLevel)
  self:refreshHeroAction(true)
end

function class:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_get_reward", function()
    self:onClickGetReward()
  end, {pressScale = 0.98, clickInterval = 0.2})
  self:btRegisterButtonClick({
    button = self.ui.panel_hero,
    key = "panel_hero",
    clickHandler = function(_, x, y)
      self:onClickHero()
    end,
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self:onUpdateLevelBtn(event, x, y)
    end,
    key = "levelBtnList"
  })
end

function class:onPopScene()
  base.onPopScene(self)
  self:removeUpdateHandler("levelBtnDragListMove")
end

function class:registerListenEvents()
  self:listenEvent("awakeDungeonLevelReward", function()
    self:refreshUI()
    local maxLevel = self.dungeonMgr:getMaxParagonLevel()
    for level = 1, maxLevel do
      self:refreshLevelBtn(level, true)
    end
  end)
  self:registerUpdateHandler("levelBtnDragListMove", function()
    self:onLevelBtnMove()
  end)
end
