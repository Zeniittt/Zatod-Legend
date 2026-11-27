local base = ed.ui.commonscene
local SkillTowerExStageScene = newclass(base.mt)
ed.ui.SkillTowerExStageScene = SkillTowerExStageScene

function SkillTowerExStageScene:getNumOfWaves(stageId)
  local num = 0
  local battleData = ed.getDataTable("FancyAbyssBattle")[stageId]
  for k, v in pairs(battleData or {}) do
    num = num + 1
  end
  return num
end

function SkillTowerExStageScene:initData(params)
  self.towerData = ed.SkillTowerManager.exTowerData
  self.curfloor = math.min(#self.towerData.stages, self.towerData.passedFloors + 1)
  local curStageData = self.towerData.stages[self.curfloor]
  self.curMaxWave = self:getNumOfWaves(curStageData.stageid)
  self.curWave = self.curMaxWave
end

function SkillTowerExStageScene:createTowerItem(data, floor)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  if data.state == "open" then
    readnode:addNode(ed.uieditor.SkillTowerExCurStage)
    ui.label_title:setColor(ed.toccc3(16772471))
    ed.setLabelStroke(ui.label_title, ed.toccc3(10045214), 1)
    ed.setLabelStroke(ui.label_buff, ed.toccc3(4271144), 1)
    ed.setLabelStroke(ui.label_rank, ed.toccc3(4271144), 1)
    self:createFloorItemFightingFca(ui.bg)
  elseif data.state == "unopen" then
    readnode:addNode(ed.uieditor.SkillTowerExCurStage)
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_floor_unlock.png")
    local lock = ed.createSprite("UI/alpha/1080P/skilltower/icon_lock.png")
    lock:setPosition(ed.getCenterPos(ui.bg))
    ui.bg:addChild(lock)
    ed.setLabelStroke(ui.label_title, ccc3(46, 46, 46), 1)
  else
    readnode:addNode(ed.uieditor.SkillTowerExCurStage)
    ed.setTexture(ui.bg, "UI/alpha/1080P/skilltower/abyss/abyss_floor_finish.png")
    local pass = ed.createSprite("UI/alpha/1080P/skilltower/abyss/abyss_passed_bg.png")
    pass:setPosition(ed.getCenterPos(ui.bg))
    local passLabel = ed.createttf(T("\229\183\178\230\140\145\230\136\152"), 18)
    passLabel:setColor(ed.toccc3(7405396))
    ed.setLabelStroke(passLabel, ed.toccc3(1519903), 1)
    passLabel:setPosition(ed.getCenterPos(pass))
    pass:addChild(passLabel)
    ui.bg:addChild(pass)
    ed.setLabelStroke(ui.label_title, ccc3(46, 46, 46), 1)
  end
  ui.label_title:setFontName(ed.fontBold)
  ed.setString(ui.label_title, string.format(T("\231\172\172%d\229\177\130"), floor))
  return container, ui
end

function SkillTowerExStageScene:getMonstersData(stageId, waveId)
  local row = ed.getDataTable("FancyAbyssBattle")[stageId][waveId]
  local data = {}
  local bossIndex = row["Boss Position"]
  for i = 1, 5 do
    local id = row[string.format("Monster %d ID", i)]
    local stars = row[string.format("Stars %d", i)]
    local level = row[string.format("Level %d", i)]
    local shardId = row[string.format("Shard ID %d", i)]
    local shardLevel = row[string.format("Shard Level %d", i)]
    if id and id ~= 0 then
      local item = {
        stageId = stageId,
        index = i,
        id = id,
        level = level,
        stars = stars,
        shardId = shardId,
        shardLevel = shardLevel
      }
      if bossIndex and i == row["Boss Position"] then
        item.Boss = true
      end
      table.insert(data, item)
    end
  end
  return data
end

function SkillTowerExStageScene:createUnitActor(unitInfo)
  local specialActorScaleConfig = ed.getDataTable("BossScale")
  local stageData = self.towerData.stages[self.curfloor]
  print("stageData.state", stageData.state)
  if stageData.state == "unopen" then
    local unknownUnitIcon = ed.createSprite("UI/alpha/1080P/common/mystery_man.png")
    unknownUnitIcon:setScale(1.8)
    unknownUnitIcon:setPositionY(270)
    return unknownUnitIcon
  else
    local actor = ed.readhero.getActor(unitInfo.id)
    local bossScale = 0.9
    if specialActorScaleConfig[unitInfo.id] then
      bossScale = specialActorScaleConfig[unitInfo.id].displayscale
    end
    actor:setScale(unitInfo.Boss and bossScale or 0.7)
    actor:setPositionY(180)
    actor:update(0)
    actor:setAction("Idie")
    self:addFca(actor)
    return actor
  end
end

local monsterDetailCardPanel

function SkillTowerExStageScene:destroyMonsterDetailCard()
  if not tolua.isnull(monsterDetailCardPanel) then
    monsterDetailCardPanel:removeFromParentAndCleanup(true)
    monsterDetailCardPanel = nil
  end
end

function SkillTowerExStageScene:createMonsterDetailCard(data)
  local id = data.id
  local idx = data.index
  local stageId = data.stageId
  local battle = ed.getDataTable("FancyAbyssBattle")[stageId][self.curWave]
  local bosPos = battle["Boss Position"]
  local panel, icon = ed.readequip.getDetailCard(id, {
    level = battle["Level " .. idx],
    rank = battle["Rank " .. idx],
    isBoss = bosPos == idx,
    isUnit = true
  })
  if data.shardLevel and data.shardLevel > 0 then
    local size = icon:getContentSize()
    local shardLogo = ed.createSprite("UI/alpha/1080P/shard/shard_logo.png")
    shardLogo:setPosition(size.width / 2, size.height - 8.5)
    icon:addChild(shardLogo, 2)
  end
  return panel
end

function SkillTowerExStageScene:addMonsterDetailCard(data, x)
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

function SkillTowerExStageScene:addMonsterActors()
  local stageData = self.towerData.stages[self.curfloor]
  local monstersData = self:getMonstersData(stageData.stageid, self.curWave)
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
  local ox = centerX - (#monstersData - 1) * gapX / 2
  
  local function getPosList()
    if #monstersData == 1 then
      return {ox}, ox
    elseif #monstersData == 2 then
      return {
        ox,
        ox + gapX
      }, ox + gapX
    elseif #monstersData == 3 then
      return {
        ox,
        ox + 2 * gapX,
        ox + gapX
      }, ox + gapX
    elseif #monstersData == 4 then
      return {
        ox,
        ox + gapX,
        ox + 3 * gapX,
        ox + 2 * gapX
      }, ox + 2 * gapX
    elseif #monstersData == 5 then
      return {
        ox,
        ox + gapX,
        ox + 3 * gapX,
        ox + 4 * gapX,
        ox + 2 * gapX
      }, ox + 2 * gapX
    end
  end
  
  local posX, centerX = getPosList()
  for i = 1, 5 do
    self:btRemoveMainTouchHandler({
      key = "clickMonsterActor" .. i
    })
  end
  self.ui.layer_enemy:setVisible(true)
  self.ui.layer_enemy:removeAllChildrenWithCleanup(true)
  local p = 1
  for i = 1, #monstersData do
    local data = monstersData[i]
    local actor = self:createUnitActor(data)
    if data.Boss then
      actor:setPositionX(centerX)
    else
      actor:setPositionX(posX[p])
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
end

function SkillTowerExStageScene:refreshStagePanel(waveId)
  local stageData = self.towerData.stages[self.curfloor]
  local isLock = stageData.state == "unopen"
  self.ui.bg_stage_lock:setVisible(isLock)
  self.ui.layer_battle:setVisible(not isLock)
  self.curMaxWave = self:getNumOfWaves(stageData.stageid)
  if waveId then
    self.curWave = waveId
  else
    self.curWave = self.curMaxWave
  end
  self:addMonsterActors()
  if isLock then
    if stageData.state == "unopen" then
      ed.setString(self.ui.label_unlock_contition, T("\230\154\130\230\156\170\229\188\128\230\148\190"))
    else
      ed.setString(self.ui.label_unlock_contition, string.format(T("\230\136\152\233\152\159\232\190\190\229\136\176\231\173\137\231\186\167%d\231\186\167\229\144\142\229\188\128\230\148\190\230\140\145\230\136\152"), stageData.unlockLevel))
    end
    return
  end
  ed.setString(self.ui.label_floor, string.format(T("\231\172\172%d\229\177\130"), stageData.floorid))
  ed.setString(self.ui.label_wave, string.format(T("\231\172\172%d/%d\230\179\162"), self.curWave, self.curMaxWave))
  if stageData.passTime then
    ed.setString(self.ui.label_passtime2, ed.gethmsNString(stageData.passTime))
    self.ui.label_reward:setVisible(false)
    self.ui.layer_reward:setVisible(false)
    self.ui.label_passtime1:setVisible(true)
    self.ui.label_passtime2:setVisible(true)
  else
    self.ui.label_passtime1:setVisible(false)
    self.ui.label_passtime2:setVisible(false)
    self.ui.label_reward:setVisible(true)
    self.ui.layer_reward:setVisible(true)
    local i = 7 - #stageData.firstRewards
    self.ui.layer_reward:removeAllChildrenWithCleanup(true)
    for k, v in ipairs(stageData.firstRewards or {}) do
      local icon = ed.createItemIcon(v)
      icon:setScale(0.5)
      icon:setPosition(i * 45 - 87, 20)
      self.ui.layer_reward:addChild(icon)
      self:btRegisterButtonClick({
        button = icon,
        key = "Icon" .. i,
        clickHandler = function()
          ed.ui.packageDetailWin.create(v):popWindow()
        end,
        force = true
      })
      i = i + 1
    end
  end
  if stageData.serverPassInfo then
    self.ui.bg_playerinfo:setVisible(true)
    local summary = stageData.serverPassInfo._user_summary
    local param = {
      id = summary._avatar,
      level = summary._level,
      no_name_bg = true,
      scale = 0.7,
      lvoffset = {x = -48, y = -25}
    }
    local head, headIcon = ed.getWholeHeadIcon(param)
    ed.UITool.replaceUI(self.ui, "bg_playerinfo", "head", head)
    self.ui.headIcon = headIcon
    local name = ed.getPlayerName(summary._name, summary._medal, {
      anchorPoint = self.ui.label_name:getAnchorPoint()
    })
    ed.UITool.replaceUI(self.ui, "bg_playerinfo", "label_name", name)
    if summary._guild_name then
      self.ui.label_guild:setVisible(true)
      ed.setString(self.ui.label_guild, summary._guild_name)
    else
      self.ui.label_guild:setVisible(false)
    end
    ed.setString(self.ui.Label_3716, string.format(T("\230\156\172\230\156\141\230\156\128\229\191\171\232\174\176\229\189\149 %s"), ed.gethmsNString(stageData.serverPassInfo._min_time)))
    self:btRemoveMainTouchHandler({key = "clickHead"})
    self:btRegisterButtonClick({
      button = self.ui.headIcon,
      key = "clickHead",
      clickHandler = function()
        local stageData = self.towerData.stages[self.curfloor]
        if stageData.serverPassInfo then
          local summary = stageData.serverPassInfo._user_summary
          if summary then
            ed.registerNetReply("req_home_page", function(data)
              local panel = ed.ui.PlayerInfoPanel.create(data, false)
              panel:popWindow()
            end)
            ed.PlayerInfoNetwork:requestHomePage(summary._role_id)
          end
        end
      end
    })
  else
    self.ui.bg_playerinfo:setVisible(false)
  end
  self.ui.arrow_left:setVisible(not isLock and self.curWave > 1)
  self.ui.arrow_right:setVisible(not isLock and self.curWave < self.curMaxWave)
  if self.towerData.selfAbyssTime then
    ed.setString(self.ui.label_time, string.format(T("\230\128\187\232\128\151\230\151\182: %s"), ed.gethmsNString(self.towerData.selfAbyssTime)))
  end
end

function SkillTowerExStageScene:refreshDraglist()
  local uiList = {}
  local oy = self.ui.frame_main:getContentSize().height / 2 + 67.5
  
  local function getPos(i)
    return ccp(-88.5, oy - 100 * (i - 1))
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

function SkillTowerExStageScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_rank, {right = 174, top = 22})
  ed.layout.layoutWithMagin(self.ui.bg_time, {right = 294, top = 24})
  ed.layout.layoutWithMagin(self.ui.btn_buff, {right = 44, top = 22})
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  ed.layout.layoutWithMagin(self.ui.bg_endtime, {bottom = 10, left = 35})
  local size = self.ui.frame_main:getContentSize()
  local fixWidth = ed.display.winSize.width * size.width / 960 - size.width
  local fixHeight = ed.display.winSize.height * size.height / 540 - size.height
  self.fixWidth = fixWidth
  self.fixHeight = fixHeight
  self.ui.frame_main:setContentSize(CCSizeMake(size.width + fixWidth, size.height + self.fixHeight))
  self.ui.bg_stage_lock:setContentSize(CCSizeMake(size.width + fixWidth, size.height + self.fixHeight))
  self.ui.bg_stage_lock:setPositionX(self.ui.bg_stage_lock:getPositionX() + fixWidth / 2)
  self.ui.bg_stage_lock:setPositionY(self.ui.bg_stage_lock:getPositionY() + fixHeight / 2)
  self.ui.bg_floor:setPositionX(self.ui.bg_floor:getPositionX() + fixWidth / 2)
  self.ui.layer_enemy:setPositionX(self.ui.layer_enemy:getPositionX() + fixWidth / 2)
  self.ui.label_unlock_contition:setPositionX(self.ui.label_unlock_contition:getPositionX() + fixWidth / 2)
  self.ui.Label_4672:setPositionX(self.ui.Label_4672:getPositionX() + fixWidth / 2)
  self.ui.layer_right:setPositionX(self.ui.layer_right:getPositionX() + fixWidth)
  self.ui.bg_floor:setPositionY(self.ui.bg_floor:getPositionY() + fixHeight)
  self.ui.layer_enemy:setPositionY(self.ui.layer_enemy:getPositionY() + fixHeight / 2)
  self.ui.label_unlock_contition:setPositionY(self.ui.label_unlock_contition:getPositionY() + fixHeight / 2)
  self.ui.Label_4672:setPositionY(self.ui.Label_4672:getPositionY() + fixHeight / 2)
  self.ui.light_frame:setPositionY(self.ui.light_frame:getPositionY() + fixHeight / 2)
  self.ui.layer_main:setZOrder(1)
  self.ui.bg_stage:setZOrder(-1)
  ed.layout.centerInParent(self.ui.bg_stage)
  ed.layout.layoutWithParentMagin(self.ui.arrow_right, {right = -20})
  ed.layout.layoutWithMagin(self.ui.frame_main, {bottom = 20})
  self.ui.label_rank:limitWidthByScale(70)
  self.ui.label_buff:limitWidthByScale(70)
  self.ui.label_time:limitWidthByScale(160)
end

function SkillTowerExStageScene:createMainFca()
  local mainFca = ed.createFcaNode("eff_UI_fancytower_particle_int")
  ed.setTexture(self.ui.bg_stage, "UI/alpha/1080P/battle_bg/bbg_island_mirage.jpg")
  mainFca:setPosition(ccp(ed.display.center.x, ed.display.center.y))
  self:addFca(mainFca)
  self.mainLayer:addChild(mainFca, 10)
end

function SkillTowerExStageScene:initUI()
  self.ui = {}
  local readnode = ed.readnode.create(self.mainLayer, self.ui)
  readnode:addNode(ed.uieditor.SkillTowerExStageWin)
  self:adaptUI()
  self:setBackground("UI/alpha/1080P/skilltower/abyss/abyss_bg.jpg")
  self:setBackButton(function()
    ed.asyncload.unregistLoadingListener()
  end)
  self.ui.title:setVisible(false)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\229\185\187\229\162\131\230\183\177\229\164\132"), self.ui.bg_title, {
    position = ccp(20, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  ed.setTexture(self.ui.title, "UI/alpha/1080P/skilltower/title_tower4.png")
  ed.setTexture(self.ui.bg_stage_lock, "UI/alpha/1080P/skilltower/bg_unstage_tower3.png")
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(10045214), 1)
  ed.setLabelStroke(self.ui.Label_4587, ccc3(81, 41, 27), 1)
  ed.setLabelShadow(self.ui.label_start, ccc3(0, 0, 0), ccp(1, 0))
  self.ui.label_start:limitWidthByScale(80)
  ed.setLabelStroke(self.ui.label_wave, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_passtime1, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_passtime2, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.Label_3716, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_time, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_guild, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_record, ed.toccc3(594187), 1)
  ed.setLabelDimensions(self.ui.label_record, CCSizeMake(70, 0))
  if self.towerData.selfAbyssTime then
    ed.setString(self.ui.label_time, string.format(T("\230\128\187\232\128\151\230\151\182: %s"), ed.gethmsNString(self.towerData.selfAbyssTime)))
  end
  ed.layout.horizontalSortNode({
    self.ui.icon_time,
    self.ui.label_time
  }, {-1.5, 0}, self.ui.bg_time:getContentSize().width * 0.5)
  local clipLayer = CCLayer:create()
  clipLayer:setClipRect(CCRectMake(-205, 20, 240, self.ui.frame_main:getContentSize().height - 35))
  self.ui.frame_main:addChild(clipLayer)
  local layer_tower = CCLayer:create()
  self.ui.layer_tower = layer_tower
  clipLayer:addChild(self.ui.layer_tower)
  ed.setString(self.ui.Label_5125, ed.time2dhmsV2(self.towerData.endTime - ed.getServerTime()))
  self.ui.label_floor:setFontName(ed.fontBold)
  if self.towerData.buffId then
    self.ui.btn_buff:setVisible(true)
  end
  self.ui.bg_stage:setScaleX((self.ui.frame_main:getContentSize().width - 47) / self.ui.bg_stage:getContentSize().width)
  self.ui.bg_stage:setScaleY((self.ui.frame_main:getContentSize().height - 47) / self.ui.bg_stage:getContentSize().height)
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 255), CCFadeTo:create(1.5, 0))))
  self:refreshStagePanel()
  self:refreshDraglist()
  self:createMainFca()
end

function SkillTowerExStageScene:setSlipPosDirectly(dy, exceptLadder)
  local function setNodePos(node)
    local y = node:getPositionY()
    
    node:setPositionY(y + dy)
  end
  
  setNodePos(self.ui.layer_tower)
end

function SkillTowerExStageScene:getMoveDuration(fDist)
  fDist = math.abs(fDist)
  local floorHei = 100
  local r = 1 * fDist / floorHei
  return r
end

function SkillTowerExStageScene:getMoveAction(fDist, needRefresh)
  local duration = self:getMoveDuration(fDist) * 0.5
  local action = CCMoveBy:create(duration, ccp(0, fDist))
  action = CCEaseExponentialOut:create(action)
  local func = CCCallFunc:create(function()
    self.ui.layer_tower:setTouchEnabled(true)
    if needRefresh then
      self.curWave = 1
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

function SkillTowerExStageScene:runSlipActions(createActionDelegate)
  self.ui.layer_tower:runAction(createActionDelegate())
end

function SkillTowerExStageScene:stopToNearestFloor(y, needRefresh)
  self:runSlipActions(function()
    return self:getMoveAction(y, needRefresh)
  end)
end

local preX, preY, dx, dy, startY

function SkillTowerExStageScene:onSwicthFloorHandler(event, x, y)
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
  if x < ed.getWorldPos(self.ui.light_frame).x - 100 or x > ed.getWorldPos(self.ui.light_frame).x + 100 then
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
    local frame = self.ui.light_frame
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

function SkillTowerExStageScene:showRuleInfo()
  ed.ui.SkillTowerExRuleWin.create({}):popWindow()
end

function SkillTowerExStageScene:createFloorItemFightingFca(parent)
  local fca = ed.createFcaActor("eff_UI_Stargate_Battle")
  fca:setLoop(true)
  fca:setAction("Loop")
  fca:setPosition(ed.getCenterPos(parent))
  parent:addChild(fca, 1)
  self:addFca(fca)
end

function SkillTowerExStageScene:goBattle()
  local stageData = self.towerData.stages[self.curfloor]
  local battleData = {
    mode = "FancyAbyss",
    stage_id = stageData.stageid,
    battleFloorInfo = stageData,
    objData = stageData
  }
  ed.SkillTowerManager.battleFloorInfo = stageData
  ed.pushScene(ed.ui.battleprepare.create(battleData))
end

function SkillTowerExStageScene:registerTouchEvents()
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
  ed.UITool.registerBtn(self, "btn_start", function()
    self:goBattle()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_rank", function()
    ed.ui.SkillTowerAbyssRankWin.create()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_record", function()
    ed.ui.SkillTowerAbyssRecordWin.create({
      floor = self.curfloor
    })
  end, {pressScale = 0.81, normalScale = 0.9})
  ed.UITool.registerBtn(self, "btn_buff", function()
    local buffId = ed.SkillTowerManager.exTowerData.buffId
    if buffId and 0 < buffId then
      ed.ui.SkillTowerBuffDetailWin.create()
    else
      ed.showToast(T("\230\156\172\230\156\159\231\171\158\233\128\159\230\151\160BUFF\229\138\160\230\136\144"))
    end
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "arrow_left", function()
    self.curWave = self.curWave - 1
    self:refreshStagePanel(self.curWave)
  end)
  ed.UITool.registerBtn(self, "arrow_right", function()
    self.curWave = self.curWave + 1
    self:refreshStagePanel(self.curWave)
  end)
  self:listenEvent("SkillTowerStageEndReply", function(param)
    self:refreshDraglist()
    if param.nextFloor and self.curfloor ~= #self.towerData.stages then
      self:stopToNearestFloor(-100, true)
      self.curfloor = self.towerData.passedFloors + 1
    else
      self:refreshStagePanel()
    end
  end)
end

function SkillTowerExStageScene.create()
  local self = base.create("SkillTowerExStageScene", {noBottomButton = true})
  setmetatable(self, SkillTowerExStageScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchEvents()
  self:registerOnPopSceneHandler("SkillSceneOnPop", function()
    ed.asyncload.unregistLoadingListener()
  end)
  return self
end
