local base = ed.ui.commonscene
local SkillTowerStageScene = newclass(base.mt)
ed.ui.SkillTowerStageScene = SkillTowerStageScene
local res = ed.ui.uires
SkillTowerStageScene.TOWER_ID_TO_NAME = {
  [1] = T("\229\138\155\228\185\139\229\185\187\229\162\131"),
  [2] = T("\230\149\143\228\185\139\229\185\187\229\162\131"),
  [3] = T("\230\153\186\228\185\139\229\185\187\229\162\131"),
  [4] = T("\229\185\187\229\162\131\230\183\177\229\164\132")
}
ed.UITool.registViewOpenFunc("SkillTowerStageScene", function(id)
  if ed.SkillTowerManager.hadDataFromServer then
    local openData = ed.SkillTowerManager.towerData[id]
    ed.pushScene(ed.ui.SkillTowerStageScene.create(openData))
  else
    ed.SkillTowerNetwork:sendTowerOpenPanel()
    ListenEventOnce("SkillTowerOpenPanel", function()
      local openData = ed.SkillTowerManager.towerData[id]
      ed.pushScene(ed.ui.SkillTowerStageScene.create(openData))
    end)
  end
end)

function SkillTowerStageScene:initData(params)
  self.towerId = params.id
  self.towerData = params
  if params.curfloor == #self.towerData.stages then
    self.curfloor = params.curfloor
  else
    self.curfloor = params.curfloor + 1
  end
  self.mgr = ed.SkillTowerManager
  self.maxStars = 0
  self.nextTime = 0
  self.nextTimeStr = "00:00:00"
  self.maxTime = 0
  self.maxTimeStr = "00:00:00"
end

function SkillTowerStageScene:doClickBack()
  ed.asyncload.unregistLoadingListener()
end

local function getVitalityPromptText(self)
  if self.mgr.power >= self.mgr.maxPower then
    self.nextTime = 0
    self.maxTime = 0
    local prompt = string.format(T("\230\137\128\230\156\137\229\185\187\231\148\159\231\131\155\229\183\178\230\129\162\229\164\141\230\187\161!"))
    local alignment = "left"
    return prompt, alignment
  else
    self.nextTime = self.mgr.lastPowerTime + 1200 - ed.getServerTime()
    self.maxTime = (self.mgr.maxPower - self.mgr.power - 1) * 1200 + self.nextTime
    self.nextTimeStr = ed.gethmsNString(self.nextTime or 0)
    self.maxTimeStr = ed.gethmsNString(self.maxTime or 0)
    local prompt = string.format(T("\228\184\139\230\148\175\229\185\187\231\148\159\231\131\155\230\129\162\229\164\141\230\151\182\233\151\180\239\188\154%s\n\229\133\168\233\131\168\229\185\187\231\148\159\231\131\155\230\129\162\229\164\141\230\151\182\233\151\180\239\188\154%s"), self.nextTimeStr, self.maxTimeStr)
    local alignment = "left"
    return prompt, alignment
  end
end

SkillTowerStageScene.getVitalityPromptText = getVitalityPromptText

function SkillTowerStageScene:destroyPromptCard()
  if not tolua.isnull(self.ppContainer) then
    self.ppContainer:removeFromParentAndCleanup(true)
    self.ppContainer = nil
  end
end

function SkillTowerStageScene:refreshCandlePromptHandler()
  local count = 0
  
  local function handler(dt)
    if tolua.isnull(self.ppContainer) or tolua.isnull(self.vitPromptLabel) then
      self:removeUpdateHandler("refreshCandlePrompt")
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

function SkillTowerStageScene:createPromptCard(text)
  self:destroyPromptCard()
  local container = CCSprite:create()
  self.ppContainer = container
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png", CCRectMake(8, 8, 37, 37))
  bg:setAnchorPoint(ccp(1, 1))
  bg:setPosition(ccp(ed.display.winSize.width - 30, ed.display.winSize.height - 60))
  container:addChild(bg)
  local label = ed.createttf(text, 14)
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(label, ccc3(85, 64, 39), 1)
  bg:addChild(label)
  local size = label:getContentSize()
  bg:setContentSize(CCSizeMake(size.width + 20, size.height + 20))
  label:setPosition(ed.getCenterPos(bg))
  self.scene:addChild(container, 60)
  return label
end

local function createVitalityPrompt(self)
  local prompt, alignment = self:getVitalityPromptText()
  local label = self:createPromptCard(prompt, alignment)
  self:registerUpdateHandler("refreshCandlePrompt", self:refreshCandlePromptHandler())
  self.vitPromptLabel = label
end

SkillTowerStageScene.createVitalityPrompt = createVitalityPrompt

function SkillTowerStageScene:createTowerItem(data, floor)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if data.state == "open" then
    readnode:addNode(ed.uieditor.SkillTowerCurStage)
    ed.setLabelStroke(ui.label_title, ccc3(235, 216, 164), 2)
    self:createFloorItemFightingFca(ui.bg)
  elseif data.state == "unopen" then
    readnode:addNode(ed.uieditor.SkillTowerLockStage)
    ed.setLabelStroke(ui.label_title, ccc3(46, 46, 46), 2)
  else
    readnode:addNode(ed.uieditor.SkillTowerPassedStage)
    ed.setLabelStroke(ui.label_title, ccc3(235, 216, 164), 2)
  end
  for i = 1, 3 do
    if i <= data.stars then
      local starIcon = ed.createSprite("UI/alpha/1080P/skilltower/detail_star.png")
      starIcon:setScale(0.6)
      starIcon:setPosition(ed.getCenterPos(ui["icon_star" .. i]))
      ui["icon_star" .. i]:addChild(starIcon)
    end
  end
  ui.label_title:setFontName(ed.fontBold)
  ed.setString(ui.label_title, string.format(T("\231\172\172%d\229\177\130"), floor))
  return container, ui
end

function SkillTowerStageScene:getMonstersData(stageId)
  local row = ed.getDataTable("FancyTowerBattle")[stageId][1]
  local data = {}
  local bossIndex = row["Boss Position"]
  for i = 1, 5 do
    local id = row[string.format("Monster %d ID", i)]
    local stars = row[string.format("Stars %d", i)]
    local level = row[string.format("Level %d", i)]
    if id and id ~= 0 then
      if bossIndex and i == row["Boss Position"] then
        table.insert(data, {
          stageId = stageId,
          index = i,
          id = id,
          level = level,
          stars = stars,
          Boss = true
        })
      else
        table.insert(data, {
          stageId = stageId,
          index = i,
          level = level,
          stars = stars,
          id = id
        })
      end
    end
  end
  return data
end

function SkillTowerStageScene:createUnitActor(unitInfo)
  local stageData = self.towerData.stages[self.curfloor]
  if stageData.state == "unopen" then
    local res = "UI/alpha/1080P/common/mystery_man.png"
    local unknownUnitIcon = ed.createSprite(res)
    unknownUnitIcon:setScale(1.8)
    unknownUnitIcon:setPositionY(270)
    return unknownUnitIcon
  else
    local actor = ed.readhero.getActor(unitInfo.id)
    if not unitInfo.Boss then
      actor:setScale(0.7)
    else
      actor:setScale(0.9)
    end
    actor:update(0)
    actor:setAction("Idie")
    self:addFca(actor)
    if not stageData.state == "unopen" then
      self:addFca(actor)
    end
    actor:setPositionY(180)
    return actor
  end
end

local monsterDetailCardPanel

function SkillTowerStageScene:destroyMonsterDetailCard()
  if not tolua.isnull(monsterDetailCardPanel) then
    monsterDetailCardPanel:removeFromParentAndCleanup(true)
    monsterDetailCardPanel = nil
  end
end

function SkillTowerStageScene:createMonsterDetailCard(data)
  local id = data.id
  local idx = data.index
  local stageId = data.stageId
  local battle = ed.getDataTable("FancyTowerBattle")[stageId][1]
  local bosPos = battle["Boss Position"]
  local info = {
    index = idx,
    id = id,
    level = battle["Level " .. idx],
    stars = battle["Stars " .. idx],
    rank = battle["Rank " .. idx],
    isBoss = bosPos == idx
  }
  local panel = ed.readequip.getDetailCard(info.id, {
    level = info.level,
    rank = info.rank,
    isBoss = info.isBoss,
    isUnit = true
  })
  return panel
end

function SkillTowerStageScene:addMonsterDetailCard(data, x)
  self:destroyMonsterDetailCard()
  local panel = self:createMonsterDetailCard(data)
  local size = panel:getContentSize()
  local winWidth = ed.display.winSize.width
  x = x - 238
  if winWidth < x + size.width / 2 + 235 then
    x = winWidth - size.width / 2 - 280
  end
  panel:setPosition(ccp(x, 300))
  self.ui.frame_main:addChild(panel, 10)
  monsterDetailCardPanel = panel
end

function SkillTowerStageScene:removeDetailCard()
  if self.detailCard then
    self.ui.frame_main:removeChild(self.detailCard, true)
    self.detailCard = nil
  end
end

function SkillTowerStageScene:createDetailCard(node, id)
  self:removeDetailCard()
  local w_pos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
  local l_pos = self.mainLayer:convertToNodeSpace(w_pos)
  l_pos.y = l_pos.y + 80
  local detailCard = ed.readequip.getDetailCard(id)
  if detailCard then
    self.detailCard = detailCard
    self.detailCard:setPosition(ccp(540 + self.fixWidth, 220))
    self.ui.frame_main:addChild(self.detailCard, 1000)
  end
end

function SkillTowerStageScene:addMonsterActors()
  local stageData = self.towerData.stages[self.curfloor]
  local monstersData = self:getMonstersData(stageData.stageid)
  local iconTab = {}
  for i, v in ipairs(monstersData) do
    iconTab[i] = {}
    iconTab[i]._tid = v.id
    iconTab[i]._level = v.level
    iconTab[i]._stars = v.stars
    iconTab[i]._rank = ed.heroLevel2Rank(v.level)
  end
  self.enemyHeros = iconTab
  local gapX = 120
  local centerX = self.ui.layer_enemy:getContentSize().width / 2
  local ox = centerX + (math.max(5 - #monstersData, 0) / 2 - 2) * gapX
  local posX = {
    ox,
    ox + gapX,
    ox + 3 * gapX,
    ox + 4 * gapX,
    ox + 2 * gapX
  }
  local centerX = ox + 2 * gapX
  for i = 1, 5 do
    self:btRemoveMainTouchHandler({
      key = "clickMonsterActor" .. i
    })
  end
  self.ui.layer_enemy:setVisible(true)
  self.ui.layer_enemy:removeAllChildrenWithCleanup(true)
  local p = 1
  for i = 1, #monstersData do
    if stageData.state ~= "unopen" then
      ed.asyncload.preloadFcaByUnitID(monstersData[i].id)
    else
      local data = monstersData[i]
      local actor = self:createUnitActor(data)
      if data.Boss then
        actor:setPositionX(centerX)
      else
        actor:setPositionX(posX[p])
        p = p + 1
      end
      self.ui.layer_enemy:addChild(actor)
    end
  end
  ed.asyncload.registLoadingListener(function()
    ed.asyncload.unregistLoadingListener()
    for i = 1, #monstersData do
      local data = monstersData[i]
      local actor = self:createUnitActor(data)
      if data.Boss then
        actor:setPositionX(centerX)
      else
        actor:setPositionX(posX[p] or 0)
        p = p + 1
      end
      self.ui.layer_enemy:addChild(actor)
      local x, y = actor:getPosition()
      local worldPos = ed.getWorldPos(actor)
      self:btRegisterCircleClick({
        key = "clickMonsterActor" .. i,
        center = ccp(x, y + 30),
        radius = 50,
        parent = self.ui.layer_enemy,
        pressHandler = function()
          if stageData.state == "unopen" then
            return
          end
          self:addMonsterDetailCard(data, worldPos.x)
        end,
        cancelPressHandler = function()
          self:destroyMonsterDetailCard()
        end,
        force = true
      })
    end
  end)
end

function SkillTowerStageScene:refreshRedLight()
  self.ui.icon_redLight:setVisible(self.mgr.redLight)
end

function SkillTowerStageScene:refreshStagePanel()
  local stageData = self.towerData.stages[self.curfloor]
  local tb = ed.getDataTable("FancyTowerStarTrigger")
  local isLock = stageData.unlockLevel > ed.player:getLevel() or stageData.state == "unopen"
  self.ui.bg_stage_lock:setVisible(isLock)
  self.ui.layer_battle:setVisible(not isLock)
  self:addMonsterActors()
  if isLock then
    if stageData.state == "unopen" then
      ed.setString(self.ui.label_unlock_contition, T("\230\154\130\230\156\170\229\188\128\230\148\190"))
    else
      ed.setString(self.ui.label_unlock_contition, string.format(T("\230\136\152\233\152\159\232\190\190\229\136\176\231\173\137\231\186\167%d\231\186\167\229\144\142\229\188\128\230\148\190\230\140\145\230\136\152"), stageData.unlockLevel))
    end
    return
  end
  self.battleData = self.battleData or {}
  self.battleData.taskStr = {}
  ed.setString(self.ui.label_cost, T("\230\140\145\230\136\152\230\182\136\232\128\151") .. stageData.candle)
  local conditionStr1 = tb[stageData.trigger1].Describe
  if stageData.triggerParam1 then
    conditionStr1 = string.format(conditionStr1, stageData.triggerParam1)
  end
  ed.setString(self.ui.label_task1, conditionStr1)
  self.battleData.taskStr[1] = conditionStr1
  local conditionStr2 = tb[stageData.trigger2].Describe
  if stageData.triggerParam2 then
    conditionStr2 = string.format(conditionStr2, stageData.triggerParam2)
  end
  ed.setString(self.ui.label_task2, conditionStr2)
  self.battleData.taskStr[2] = conditionStr2
  local conditionStr3 = tb[stageData.trigger3].Describe
  if stageData.triggerParam3 then
    conditionStr3 = string.format(conditionStr3, stageData.triggerParam3)
  end
  ed.setString(self.ui.label_task3, conditionStr3)
  self.battleData.taskStr[3] = conditionStr3
  ed.setString(self.ui.label_floor, string.format(T("\231\172\172%d\229\177\130"), stageData.floorid))
  self.battleData.candle = stageData.candle
  self.battleData.floorid = stageData.floorid
  self.battleData.towerId = self.towerId
  self.battleData.items = {}
  local i = 7 - #stageData.firstRewards - #stageData.rewards
  self.ui.layer_reward:removeAllChildrenWithCleanup(true)
  for k, v in ipairs(stageData.firstRewards or {}) do
    table.insert(self.battleData.items, {
      id = v.id,
      type = v.type,
      amount = v.amount or v.count,
      isOne = true
    })
    local icon = ed.createItemIcon(v)
    icon:setScale(0.5)
    icon:setPosition(ccp(i * 45 - 87, 20))
    local firstIcon = ed.createSprite("UI/alpha/1080P/skilltower/icon_first.png")
    firstIcon:setPosition(ccp(i * 45 - 87, 38))
    firstIcon:setZOrder(1)
    local labelFirst = ed.createttf(T("\233\166\150\230\172\161"), 11)
    ed.setLabelColor(labelFirst, ed.toccc3(16776919))
    firstIcon:addChild(labelFirst)
    ed.layout.centerInParent(labelFirst)
    self.ui.layer_reward:addChild(firstIcon)
    self.ui.layer_reward:addChild(icon)
    self:btRegisterButtonClick({
      button = icon,
      key = "Icon" .. i,
      pressHandler = function()
      end,
      clickHandler = function()
        if v.id and v.id ~= 0 then
          self:createDetailCard(icon, v.id)
        elseif ed.resToIconId[string.lower(v.type)] then
          self:createDetailCard(icon, ed.resToIconId[string.lower(v.type)])
        end
      end,
      cancelPressHandler = function()
        self:removeDetailCard()
      end,
      force = true
    })
    i = i + 1
    if stageData.state == "passed" then
      icon:setVisible(false)
      firstIcon:setVisible(false)
    end
  end
  for k, v in ipairs(stageData.rewards or {}) do
    table.insert(self.battleData.items, v)
    local icon = ed.createItemIcon(v)
    icon:setScale(0.5)
    icon:setPosition(i * 45 - 87, 20)
    self.ui.layer_reward:addChild(icon)
    self:btRegisterButtonClick({
      button = icon,
      key = "Icon" .. i,
      pressHandler = function()
        if v.id and v.id ~= 0 then
          self:createDetailCard(icon, v.id)
        elseif ed.resToIconId[string.lower(v.type)] then
          self:createDetailCard(icon, ed.resToIconId[string.lower(v.type)])
        end
      end,
      cancelPressHandler = function()
        self:removeDetailCard()
      end,
      force = true
    })
    i = i + 1
  end
  if stageData.state ~= "passed" then
    self.ui.btn_rush:setVisible(false)
  else
    self.ui.btn_rush:setVisible(true)
  end
  self:refreshRedLight()
end

function SkillTowerStageScene:refreshDraglist()
  local uiList = {}
  local px = ed.display.winSize.height / 2 - 269.5
  
  local function getPos(i)
    return ccp(146 - self.fixWidth / 2, 30 + self.ui.layer_tower:getContentSize().height / 2 - 100 * i + 101 - px)
  end
  
  self.stageData = self.towerData.stages
  self.ui.layer_tower:removeAllChildrenWithCleanup(true)
  for k, v in ipairs(self.stageData) do
    local container, ui = self:createTowerItem(v, k)
    ui.data = v
    table.insert(uiList, ui)
    self.ui.layer_tower:addChild(container)
    container:setPosition(getPos(#self.stageData - k + 1))
  end
  self.uiList = uiList
  self.ui.layer_tower:setPositionY(#self.towerData.stages * 100 - 60 - self.curfloor * 100)
end

function SkillTowerStageScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_btn_power, {right = 44, top = 25})
  ed.layout.layoutWithMagin(self.ui.btn_reward, {right = 169, top = 20})
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  local size = self.ui.frame_main:getContentSize()
  local fixWidth = ed.display.winSize.width * size.width / 960 - size.width
  local fixHeight = ed.display.winSize.height * size.height / 540 - size.height
  self.fixWidth = fixWidth
  self.fixHeight = fixHeight
  self.ui.frame_main:setContentSize(CCSizeMake(size.width + fixWidth, size.height + self.fixHeight))
  self.ui.bg_stage_lock:setContentSize(CCSizeMake(size.width + fixWidth, size.height + self.fixHeight))
  self.ui.bg_stage_lock:setPositionX(self.ui.bg_stage_lock:getPositionX() + fixWidth / 2)
  self.ui.bg_stage_lock:setPositionY(self.ui.bg_stage_lock:getPositionY() + fixHeight / 2)
  self.ui.layer_title:setPositionX(self.ui.layer_title:getPositionX() + fixWidth / 2)
  self.ui.layer_enemy:setPositionX(self.ui.layer_enemy:getPositionX() + fixWidth / 2)
  self.ui.label_unlock_contition:setPositionX(self.ui.label_unlock_contition:getPositionX() + fixWidth / 2)
  self.ui.Label_4672:setPositionX(self.ui.Label_4672:getPositionX() + fixWidth / 2)
  self.ui.layer_right:setPositionX(self.ui.layer_right:getPositionX() + fixWidth)
  self.ui.layer_title:setPositionY(self.ui.layer_title:getPositionY() + fixHeight)
  self.ui.layer_enemy:setPositionY(self.ui.layer_enemy:getPositionY() + fixHeight / 2)
  self.ui.label_unlock_contition:setPositionY(self.ui.label_unlock_contition:getPositionY() + fixHeight / 2)
  self.ui.Label_4672:setPositionY(self.ui.Label_4672:getPositionY() + fixHeight / 2)
  self.ui.icon_arrow:setPositionY(self.ui.icon_arrow:getPositionY() + fixHeight / 2)
  self.ui.layer_main:setZOrder(1)
end

function SkillTowerStageScene:createMainFca()
  local mainFca
  if self.towerId == 1 then
    ed.setTexture(self.ui.bg_stage, "UI/alpha/1080P/battle_bg/bbg_FancyTower_STR.jpg")
    mainFca = ed.createFcaNode("eff_UI_fancytower_particle_str")
  elseif self.towerId == 2 then
    ed.setTexture(self.ui.bg_stage, "UI/alpha/1080P/battle_bg/bbg_FancyTower_AGI.jpg")
    mainFca = ed.createFcaNode("eff_UI_fancytower_particle_agi")
  elseif self.towerId == 3 then
    ed.setTexture(self.ui.bg_stage, "UI/alpha/1080P/battle_bg/bbg_FancyTower_INT.jpg")
    mainFca = ed.createFcaNode("eff_UI_fancytower_particle_int")
  end
  mainFca:setPosition(ccp(ed.display.center.x, ed.display.center.y))
  self:addFca(mainFca)
  self.mainLayer:addChild(mainFca, 10)
end

function SkillTowerStageScene:initUI()
  self.ui = {}
  local readnode = ed.readnode.create(self.mainLayer, self.ui)
  readnode:addNode(ed.uieditor.SkillTowerStageWin)
  self:adaptUI()
  self.ui.title:setVisible(false)
  local titleName = self.TOWER_ID_TO_NAME[self.towerId] or T("\229\185\187\229\162\131\228\185\139\229\161\148")
  local _, titleTxt = ed.UITool.createSceneTitle(titleName, self.ui.bg_title, {
    position = ccp(21, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  self:setBackground(string.format("UI/alpha/1080P/skilltower/bg1080_tower%d.jpg", self.towerId))
  self:setBackButton(function()
    self:doClickBack()
  end)
  ed.setTexture(self.ui.bg_stage_lock, string.format("UI/alpha/1080P/skilltower/bg_unstage_tower%d.png", self.towerId))
  ed.setLabelStroke(self.ui.label_floor, ccc3(235, 216, 164), 2)
  ed.setLabelStroke(self.ui.Label_4587, ccc3(81, 41, 27), 1)
  self.ui.Label_4587:limitWidthByScale(70)
  ed.setLabelStroke(self.ui.label_power, ccc3(81, 41, 27), 1)
  ed.setLabelShadow(self.ui.label_shop, ccc3(0, 0, 0), ccp(1, 0))
  self.ui.label_shop:limitWidthByScale(80)
  ed.setString(self.ui.label_power, string.format("%d/%d", self.mgr.power, self.mgr.maxPower))
  local clipLayer = CCLayer:create()
  clipLayer:setClipRect(CCRectMake(10 - self.fixWidth / 2, 33 - ed.display.halfFixedHeight, 240, self.ui.frame_main:getContentSize().height - 35))
  self.mainLayer:addChild(clipLayer)
  local layer_tower = CCLayer:create()
  self.ui.layer_tower = layer_tower
  clipLayer:addChild(self.ui.layer_tower)
  local labelReward = ed.createttf(T("\233\128\154\229\133\179\229\165\150\229\138\177"), 16)
  labelReward:setColor(ccc3(255, 234, 198))
  ed.setLabelStroke(labelReward, ed.toccc3(2565412), 1)
  labelReward:setAnchorPoint(ccp(1, 0.5))
  labelReward:setPosition(318, -79)
  self.ui.layer_right:addChild(labelReward)
  self.ui.label_floor:setFontName(ed.fontBold)
  self.ui.bg_stage:setScaleX((self.ui.frame_main:getContentSize().width - 47) / self.ui.bg_stage:getContentSize().width)
  self.ui.bg_stage:setScaleY((self.ui.frame_main:getContentSize().height - 47) / self.ui.bg_stage:getContentSize().height)
  self:refreshStagePanel()
  self:refreshDraglist()
  self:createMainFca()
end

function SkillTowerStageScene:setSlipPosDirectly(dy, exceptLadder)
  local function setNodePos(node)
    local y = node:getPositionY()
    
    node:setPositionY(y + dy)
  end
  
  setNodePos(self.ui.layer_tower)
end

function SkillTowerStageScene:getMoveDuration(fDist)
  fDist = math.abs(fDist)
  local floorHei = 100
  local r = 1 * fDist / floorHei
  return r
end

function SkillTowerStageScene:getMoveAction(fDist, needRefresh)
  local duration = self:getMoveDuration(fDist) * 0.5
  local action = CCMoveBy:create(duration, ccp(0, fDist))
  action = CCEaseExponentialOut:create(action)
  local func = CCCallFunc:create(function()
    self.ui.layer_tower:setTouchEnabled(true)
    if needRefresh then
      self:refreshStagePanel()
    end
  end)
  local seq = ed.readaction.create({
    t = "seq",
    action,
    func
  })
  return seq
end

function SkillTowerStageScene:runSlipActions(createActionDelegate)
  self.ui.layer_tower:runAction(createActionDelegate())
end

function SkillTowerStageScene:stopToNearestFloor(y, needRefresh)
  self:runSlipActions(function()
    return self:getMoveAction(y, needRefresh)
  end)
end

local preX, preY, dx, dy, startY

function SkillTowerStageScene:onSwicthFloorHandler(event, x, y)
  if event == "began" then
    preX = nil
    preY = nil
    dx = nil
    dy = nil
  elseif event == "ended" then
    local dy = self.ui.layer_tower:getPositionY() - 40
    local floor = math.floor((#self.towerData.stages * 100 - 0.1 - dy) / 100)
    local y = dy % 100
    if 50 < y then
      y = 100 - y
      floor = floor - 1
    else
      y = -y
    end
    local needRefresh = true
    if floor == self.curfloor then
      needRefresh = false
    end
    if floor < 1 then
      floor = 1
      y = y - 100
    end
    if floor > #self.towerData.stages then
      floor = #self.towerData.stages
      y = 100 - y
    end
    self.curfloor = floor
    self:stopToNearestFloor(y, needRefresh)
  end
  if x < ed.getWorldPos(self.ui.light).x - 100 or x > ed.getWorldPos(self.ui.light).x + 100 then
    return
  end
  if y < 80 or y > ed.display.winSize.height - 80 then
    return
  end
  
  local function initPrePos(xx, yy)
    if not preX then
      preX = xx
    end
    if not preY then
      preY = yy
    end
  end
  
  if event == "began" then
    startY = y
    initPrePos(x, y)
  elseif event == "moved" then
    initPrePos(x, y)
    dx = x - preX
    dy = y - preY
    if self.ui.layer_tower:getPositionY() < -60 then
      ed.showToast(T("\229\183\178\229\136\176\230\156\128\233\161\182\229\177\130"))
      return
    elseif self.ui.layer_tower:getPositionY() > -160 + #self.stageData * 100 then
      ed.showToast(T("\229\183\178\229\136\176\230\156\128\229\186\149\229\177\130"))
      return
    else
      self:setSlipPosDirectly(dy)
    end
    preX = x
    preY = y
  elseif event == "ended" then
    local dist = y - (startY or 0)
    local frame = self.ui.light
    local pos = ed.getWorldPos(frame)
    local floorHei = 100
    local actionCnt = self.ui.layer_tower:numberOfRunningActions()
    if math.abs(dist) < 5 and actionCnt == 1 then
      local ddy = y - pos.y
      local ff = 0 <= ddy and -1 or 1
      local absddy = math.abs(ddy)
      local count = math.ceil((absddy - floorHei / 2) / floorHei)
      local tmpFloor = self.curfloor + count * ff * -1
      if tmpFloor < 1 then
        count = tmpFloor + count - 1
        tmpFloor = 1
      elseif tmpFloor > #self.towerData.stages then
        count = #self.towerData.stages - tmpFloor + count
        tmpFloor = #self.towerData.stages
      end
      local isNeedRefresh = self.curfloor ~= tmpFloor
      self.curfloor = tmpFloor
      self:stopToNearestFloor(count * ff * 100, isNeedRefresh)
    end
  end
end

function SkillTowerStageScene:showRuleInfo()
  ed.ui.SkillTowerRuleWin.create({}):popWindow()
end

function SkillTowerStageScene:createFloorItemFightingFca(parent)
  local fca = ed.createFcaActor("eff_UI_Stargate_Battle")
  self:addFca(fca)
  fca:setLoop(true)
  fca:setAction("Loop")
  fca:setPosition(ed.getCenterPos(parent))
  parent:addChild(fca, 1)
end

function SkillTowerStageScene:goBattle()
  local stageData = self.towerData.stages[self.curfloor]
  if self.mgr.power < stageData.candle then
    ed.showToast(T("\229\185\187\231\148\159\231\131\155\228\184\141\232\182\179\239\188\129"))
    return
  end
  local battleFloorInfo = {
    towerId = self.towerId,
    floorId = stageData.floorid,
    stageId = stageData.stageid,
    trigger1 = {
      stageData.trigger1,
      stageData.triggerParam1
    },
    trigger2 = {
      stageData.trigger2,
      stageData.triggerParam2
    },
    trigger3 = {
      stageData.trigger3,
      stageData.triggerParam3
    }
  }
  self.mgr.BattleData = {
    candleNum = stageData.candle,
    mode = "FancyTower",
    stage_id = stageData.stageid,
    battleFloorInfo = battleFloorInfo,
    enemyHeros = self.enemyHeros,
    objData = self.battleData
  }
  ed.pushScene(ed.ui.battleprepare.create(self.mgr.BattleData))
end

function SkillTowerStageScene:refreshCandleNum()
  local numAction = ed.UITool.getRefreshAction()
  self.ui.label_power:runAction(numAction)
  ed.setString(self.ui.label_power, string.format("%d/%d", self.mgr.power, self.mgr.maxPower))
end

function SkillTowerStageScene:registerTouchEvents()
  local getResType = ed.ui.configs.resType.getResType
  self:btRegisterHandler({
    handler = function(event, x, y)
      self:onSwicthFloorHandler(event, x, y)
    end,
    key = "switchFloor"
  })
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:showRuleInfo()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.ui.SkillTowerRewardWin.create({
      callback = function()
        self:refreshRedLight()
      end
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_rush", function()
    local stageData = self.towerData.stages[self.curfloor]
    if stageData.candle > self.mgr.power then
      ed.showToast(T("\229\185\187\231\148\159\231\131\155\228\184\141\232\182\179\239\188\129"))
    elseif stageData.state ~= "passed" then
      ed.showToast(T("\229\189\147\229\137\141\229\177\130\230\156\170\233\128\154\229\133\179\239\188\140\228\184\141\232\131\189\230\137\171\232\141\161\239\188\129"))
    else
      ed.SkillTowerNetwork:sendTowerSweep(self.towerId, self.curfloor)
    end
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_start", function()
    self:goBattle()
  end, {pressScale = 0.9})
  self:btRegisterButtonClick({
    button = self.ui.bg_btn_power,
    key = "bg_btn_power",
    pressHandler = function()
      self:createVitalityPrompt()
    end,
    cancelPressHandler = function()
      self:destroyPromptCard(self)
    end,
    force = true,
    mcpMode = true
  })
  ed.UITool.registerBtn(self, "icon_add_power", function()
    ed.ui.buyResourceBox.create({
      buyLimitNum = self.mgr.buyTimes,
      defaultBuyNum = 1,
      goodsResType = getResType("item"),
      goodsId = 20018,
      costResType = getResType("diamond"),
      price = self.mgr.price,
      ownedAmount = self.mgr.power,
      buyAction = function(num)
        if 0 < num then
          ed.SkillTowerNetwork:sendTowerCandleBuy(num)
        end
      end
    }):popWindow()
  end, {pressScale = 0.9})
  self:listenEvent("SkillTowerCandleBuyReply", function()
    self:refreshCandleNum()
  end)
  self:listenEvent("FancyTowerCandleChange", function()
    self:refreshCandleNum()
  end)
  self:listenEvent("SkillTowerStageEndReply", function(param)
    self:refreshDraglist()
    if param.nextFloor and self.curfloor ~= #self.towerData.stages then
      self:stopToNearestFloor(-100, true)
      self.curfloor = self.towerData.curfloor + 1
    end
    self:refreshCandleNum()
  end)
  self:listenEvent("SkillTowerSweepReply", function()
    self:refreshCandleNum()
  end)
end

function SkillTowerStageScene.create(params)
  local self = base.create("SkillTowerStageScene", {noBottomButton = true})
  setmetatable(self, SkillTowerStageScene.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchEvents()
  self:registerOnPopSceneHandler("SkillSceneOnPop", function()
    self:doClickBack()
  end)
  return self
end
