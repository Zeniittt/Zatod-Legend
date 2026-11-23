local base = ed.ui.commonscene
local mainScene = newclass(base.mt)
ed.ui.mainScene = mainScene
local mapCfg = ed.ui.configs.mainSceneMap
local layerOrders = mapCfg.layerDefine
local mapLayersCfg = mapCfg.mapLayersConfigs
local mapSlidingRange = {
  minX = mapCfg.limitX.min,
  maxX = mapCfg.limitX.max,
  minY = 0,
  maxY = 0
}

function mainScene.create(params)
  ed.reportHUE({
    action_type = "create_main_scene"
  })
  params = params or {}
  params.autoCloseMenu = false
  local self = base.create("mainScene", params)
  setmetatable(self, mainScene.mt)
  self:init(params)
  self.create_main_scene = true
  return self
end

function mainScene:init(params)
  self.from5v5 = params.ps == "5v5"
  self.dragNumber = 0
  self.mainCount = 0
  self.startCountTime = false
  self.dragEnabled = true
  self.newSeasonList = ed.newSeasonOrActOpen or {}
  ed.chatNetWork:initChatTimeInfo()
  self:initSceneMap()
  self:initUI()
  self:registEvents()
end

function mainScene:setDragEnabled(enable)
  self.dragEnabled = enable
end

function mainScene:initSceneMap()
  self.mapLayer = CCLayerColor:create(ccc4(0, 0, 0, 255))
  self.baseLayer:addChild(self.mapLayer)
  self.tbConfig = self:getCurResConfig() or {}
  self.tbBuildingConfig = self:getCurBulidingConfig() or {}
  self.mapLayers = {}
  self.commponents = {}
  self:createMapLayers()
  self:createMapBuildings()
  self:createSceneEffects()
  self.movingClouds = {
    self:getCommponent(layerOrders.Bottom, "left_cloud1_1"),
    self:getCommponent(layerOrders.Bottom, "left_cloud1_2"),
    self:getCommponent(layerOrders.Bottom, "left_cloud1_3"),
    self:getCommponent(layerOrders.Bottom, "right_cloud1_1"),
    self:getCommponent(layerOrders.Bottom, "right_cloud1_2"),
    self:getCommponent(layerOrders.Bottom, "right_cloud1_3"),
    self:getCommponent(layerOrders.Bottom, "left_cloud2_1"),
    self:getCommponent(layerOrders.Bottom, "left_cloud2_2"),
    self:getCommponent(layerOrders.Bottom, "left_cloud2_3"),
    self:getCommponent(layerOrders.Bottom, "right_cloud2_1"),
    self:getCommponent(layerOrders.Bottom, "right_cloud2_2"),
    self:getCommponent(layerOrders.Bottom, "right_cloud2_3"),
    self:getCommponent(layerOrders.Middle, "left_cloud3_1"),
    self:getCommponent(layerOrders.Middle, "left_cloud3_2"),
    self:getCommponent(layerOrders.Middle, "left_cloud3_3"),
    self:getCommponent(layerOrders.Middle, "right_cloud3_1"),
    self:getCommponent(layerOrders.Middle, "right_cloud3_2"),
    self:getCommponent(layerOrders.Middle, "right_cloud3_3")
  }
  self:playCloundsAnimation()
  if self:checkShowFirework() then
    self:createFireworkEffect()
  end
end

function mainScene:playSpine()
  local spine = EDSpine:createWithFile("spine/chuanzhang.json", "spine/chuanzhang.atlas", 0.3)
  spine:setAnimation(0, "Idle", true)
  spine:setPosition(ccp(200, 100))
  self.mapLayer:addChild(spine, 1000)
end

function mainScene:checkShowFirework()
  local MainSceneEffectCfg = ed.getDataTable("MainSceneEffect") or {}
  local cfgList = {}
  for startTime, config in pairs(MainSceneEffectCfg) do
    table.insert(cfgList, config)
  end
  table.sort(cfgList, ed.cmpSort({
    {
      getValue = function(o)
        return ed.getTimeByYMDHMS(o["Start Time"])
      end,
      reverse = true
    }
  }))
  local showFirework = false
  for index, config in ipairs(cfgList) do
    if ed.getTimeByYMDHMS(config["Start Time"]) < ed.getSystemTime() then
      if config.Fireworks then
        showFirework = true
      end
      break
    end
  end
  return showFirework
end

function mainScene:createFireworkEffect()
  local FireShaderList = {
    "FcaHSVBlue",
    "FcaHSVGreen",
    "FcaHSVOrange",
    "FcaHSVPink",
    "FcaHSVPurple"
  }
  for index, firework in ipairs(self.fireworkEffectList or {}) do
    firework:removeFromParentAndCleanup(true)
  end
  self.fireworkEffectList = {}
  self.totalFirework = 0
  for groupIndex, config in ipairs(mapCfg.fireworkEffectConfig) do
    local posGroup = config.posGroup or {}
    local res = config.res
    local layer = self:getMapLayer(config.layer)
    local zOrder = config.zOrder
    local posIndex = math.random(#posGroup)
    local pos = posGroup[posIndex]
    local fireworkAmount = math.random(1, 2)
    local delayTime = math.random(0, 2)
    local scale = math.random(config.scaleRange[1] * 100, config.scaleRange[2] * 100) / 100
    for index = 1, fireworkAmount do
      self.totalFirework = self.totalFirework + 1
      scale = index == 1 and scale or scale - 0.1
      delayTime = index == 1 and delayTime or delayTime + 0.1
      local shader = FireShaderList[math.random(#FireShaderList)]
      local firework = self:createFirework(res, layer, pos, scale, zOrder, delayTime, shader)
      table.insert(self.fireworkEffectList, firework)
    end
  end
end

function mainScene:fireworkEnd()
  self.totalFirework = self.totalFirework - 1
  if self.totalFirework <= 0 then
    self:listenTimer(Timer:Once(1.7), function()
      self:createFireworkEffect()
    end)
  end
end

function mainScene:createFirework(res, parent, pos, scale, zOrder, delayTime, shader)
  delayTime = delayTime or 0
  scale = scale or 0.35
  local firework = ed.createFcaActor(res)
  parent:addChild(firework, zOrder or 999)
  firework:setScale(scale)
  firework:setPosition(pos)
  firework:setVisible(false)
  self:addFca(firework)
  ed.useShader(firework, shader)
  local delay = CCDelayTime:create(delayTime)
  local callFunc = CCCallFunc:create(function()
    local index = math.random(1, 5)
    ed.playEffect(ed.sound.deo["firework_" .. index])
    firework:setVisible(true)
    firework:setAction("Start")
    firework:setLoop(false)
    self:fireworkEnd()
  end)
  local action = CCSequence:create(ccArrayMake(delay, callFunc))
  firework:runAction(action)
  return firework
end

function mainScene:getCurResConfig()
  local mainMapConfigTb = ed.getDataTable("MainScene") or {}
  local configs = {}
  for startTime, config in pairs(mainMapConfigTb) do
    table.insert(configs, config)
  end
  table.sort(configs, function(a, b)
    local startA = ed.getTimeByYMDHMS(a["Start Time"])
    local startB = ed.getTimeByYMDHMS(b["Start Time"])
    return startA > startB
  end)
  for k, v in ipairs(configs) do
    if ed.getTimeByYMDHMS(v["Start Time"]) < ed.getSystemTime() then
      return v
    end
  end
  return {}
end

function mainScene:getCurBulidingConfig()
  local mainMapConfigTb = ed.getDataTable("MainSceneBuilding") or {}
  local configs = {}
  for startTime, config in pairs(mainMapConfigTb) do
    table.insert(configs, config)
  end
  table.sort(configs, function(a, b)
    local startA = ed.getTimeByYMDHMS(a["Start Time"])
    local startB = ed.getTimeByYMDHMS(b["Start Time"])
    return startA > startB
  end)
  for k, v in ipairs(configs) do
    if ed.getTimeByYMDHMS(v["Start Time"]) < ed.getSystemTime() then
      return v
    end
  end
  return {}
end

function mainScene:createMapLayers()
  for _, order in pairs(layerOrders) do
    local config = mapLayersCfg[order]
    if not config then
      return
    end
    local layer = CCLayer:create()
    self.mapLayer:addChild(layer, order)
    if self.mapLayers[order] then
      warn("layer " .. order .. "duplicate in mapLayers!")
    end
    self.mapLayers[order] = layer
    local map = {}
    local commponents = config.commponents
    for i, commponent in ipairs(commponents) do
      local sp = ed.createSprite(self.tbConfig[commponent.name] or commponent.res)
      if commponent.anchor then
        sp:setAnchorPoint(commponent.anchor)
      end
      sp:setScale(commponent.scale or 1)
      sp:setPosition(commponent.pos)
      layer:addChild(sp, commponent.order or 0)
      map[commponent.name] = {node = sp, config = commponent}
    end
    self.commponents[order] = map
  end
  local topLayer = self:getMapLayer(layerOrders.Top)
  self:refreshMapPos(mapCfg.defaultOffsetX, 0)
end

function mainScene:getMapLayer(order)
  return self.mapLayers[order], mapLayersCfg[order]
end

function mainScene:getCommponent(layerOrder, name)
  local comps = self.commponents[layerOrder]
  if not comps then
    return
  end
  return comps[name]
end

function mainScene:playCloundsAnimation()
  local speed = 5
  for i, cloud in ipairs(self.movingClouds) do
    local node = cloud.node
    local config = cloud.config
    local distance = config.dest.x - config.pos.x
    local moveTo = CCEaseSineInOut:create(CCMoveTo:create(distance / speed, config.dest))
    local callback = CCCallFunc:create(function()
      node:setPosition(config.pos)
      node:setOpacity(0)
    end)
    local array = ccArrayMake(moveTo, callback, CCFadeIn:create(0.1))
    node:runAction(CCRepeatForever:create(CCSequence:create(array)))
  end
end

function mainScene:createMapBuildings()
  self.buildings = {}
  local buildingsConfigs = mapCfg.buildingsConfigs
  local BuilddingType = mapCfg.builddingType
  for buildType, cfg in pairs(buildingsConfigs) do
    local buildName = BuilddingType[buildType]
    if self.tbBuildingConfig[buildName] then
      cfg.res = self.tbBuildingConfig[buildName]
    end
    local buildding = self:createBuilding(buildType, cfg)
    self:updateBuildingStatus(buildding)
    self.buildings[buildType] = buildding
  end
end

function mainScene:createNewSeasonUI(buildType, cfg)
  local bgDialog
  bgDialog = ed.createSprite("UI/alpha/1080P/toparena/toparena_open_guide.png")
  local bubblePos = cfg.bubblePos or {x = 0, y = 0}
  bgDialog:setPosition(cfg.pos.x + (bubblePos.x or 100), cfg.pos.y + (bubblePos.y or 150))
  local dialog = ed.createttf(self.newSeasonList[buildType], 17)
  ed.setLabelDimensions(dialog, CCSizeMake(110, 0))
  ed.setLabelColor(dialog, ed.toccc3(16776423))
  ed.setLabelStroke(dialog, ed.toccc3(4273968), 1)
  local scale = 42 / dialog:getContentSize().height
  dialog:setScale(math.min(scale, 1))
  bgDialog:addChild(dialog)
  dialog:setPosition(ccp(63, 48))
  self:getMapLayer(cfg.layer):addChild(bgDialog, (cfg.order or 0) + 3)
  bgDialog:setCascadeOpacityEnabled(true)
  local fi = CCFadeIn:create(0.8)
  local delay = CCDelayTime:create(2)
  local fo = CCFadeOut:create(0.4)
  local action = CCRepeatForever:create(CCSequence:create(ccArrayMake(fi, delay, fo)))
  bgDialog:runAction(action)
  self.ui["bgDialog_" .. buildType] = bgDialog
end

function mainScene:updateBuildingActivityTips(buildding)
  local cfg = buildding.cfg
  local builddingType = buildding.builddingType
  local bubbleShow = cfg.getBubbleShow and cfg.getBubbleShow()
  local bgDialog = self.ui["bgDialog_" .. builddingType]
  if bubbleShow then
    if not bgDialog then
      local bubbleText = cfg.getBubbleText() or ""
      self.newSeasonList[builddingType] = bubbleText
      self:createNewSeasonUI(builddingType, cfg)
    end
  elseif bgDialog and not tolua.isnull(bgDialog) then
    bgDialog:removeFromParentAndCleanup(true)
    self.ui["bgDialog_" .. builddingType] = nil
  end
  local extraShow = cfg.getExtraMaskShow and cfg.getExtraMaskShow()
  local mask = self.ui["extraMask_" .. builddingType]
  if extraShow then
    local maskPath = cfg.getExtraMaskPath()
    if not mask and maskPath then
      local mask = ed.createSprite(maskPath)
      local extraMaskPos = cfg.extraMaskPos or ccp(0, 0)
      mask:setPosition(ccp(cfg.pos.x + extraMaskPos.x, cfg.pos.y + extraMaskPos.y))
      self.ui["extraMask_" .. builddingType] = mask
      self:getMapLayer(cfg.layer):addChild(mask, 999)
    end
  elseif mask and not tolua.isnull(mask) then
    mask:removeFromParentAndCleanup(true)
    self.ui["extraMask_" .. builddingType] = nil
  end
end

function mainScene:createBuilding(buildType, cfg)
  local fca = cfg.spine and self:createSpineAnim(cfg) or self:createFca(cfg)
  local parent = self:getMapLayer(cfg.layer)
  local order = cfg.order or 0
  parent:addChild(fca, order)
  local scale = cfg.scale or 1
  local lightSize = CCSizeMake(cfg.lightSize.width * scale, cfg.lightSize.height * scale)
  self:setFcaRect(fca, lightSize)
  self:setFcaPositionOffset(fca, cfg.touchCenter)
  if mapCfg.drawTouchCircle then
    local drawNode = CCDrawNode:create()
    drawNode:drawCircle(ccpAdd(cfg.pos, cfg.touchCenter), cfg.touchRadius * scale, ccc4f(0, 0.1, 0.6, 0.5), 0.5, false)
    parent:addChild(drawNode, order + 10)
  end
  local level = ed.player:getLevel()
  local isOpen = ed.playerlimit:moduleIsOpened(mapCfg.builddingType[buildType])
  local visibleLevel = cfg.visibleLevel
  local titleVisibleLevel = cfg.titleVisibleLevel
  fca:setVisible(isOpen or level >= visibleLevel)
  
  local function createTitle(mode, visible)
    local bg, text
    if mode == "normal" then
      bg = ed.createScale9Sprite("UI/alpha/1080P/main/buildname/main_button_unavailable.png")
      text = ed.createttf(cfg.titleRes, 17)
      local wid = math.max(text:getContentSize().width + 20, 110)
      bg:setContentSize(CCSizeMake(wid, 35))
      ed.setLabelColor(text, ed.toccc3(16771457))
      ed.setLabelStroke(text, ed.toccc3(3352867), 1)
      bg:addChild(text)
    elseif mode == "press" then
      bg = ed.createScale9Sprite("UI/alpha/1080P/main/buildname/main_button_press.png")
      text = ed.createttf(cfg.titleRes, 17)
      local wid = math.max(text:getContentSize().width + 20, 110)
      bg:setContentSize(CCSizeMake(wid, 35))
      ed.setLabelColor(text, ed.toccc3(16771457))
      ed.setLabelStroke(text, ed.toccc3(3352867), 1)
      bg:addChild(text)
    else
      bg = ed.createScale9Sprite("UI/alpha/1080P/main/buildname/main_button_unavailable.png")
      text = ed.createttf(cfg.titleNotOpenRes, 17)
      local wid = math.max(text:getContentSize().width + 20, 110)
      bg:setContentSize(CCSizeMake(wid, 35))
      ed.setLabelColor(text, ed.toccc3(14409173))
      ed.setLabelStroke(text, ed.toccc3(3352867), 1)
      bg:addChild(text)
    end
    ed.layout.centerInParent(text)
    bg:setPosition(cfg.titlePos)
    bg:setVisible(visible)
    parent:addChild(bg, order + 1)
    return bg
  end
  
  local title = createTitle("normal", isOpen)
  local titlePress = createTitle("press", false)
  local titleNotOpen = createTitle("unopen", not isOpen and level >= titleVisibleLevel)
  local redPoint = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  local size = title:getContentSize()
  redPoint:setPosition(cfg.titlePos.x + size.width / 2 - 5, cfg.titlePos.y + size.height / 2 - 5)
  redPoint:setVisible(true)
  parent:addChild(redPoint, order + 2)
  if self.newSeasonList[buildType] then
    self:createNewSeasonUI(buildType, cfg)
  end
  local clickHandler = {
    key = "buildding" .. buildType,
    checkClickHandler = function(x, y)
      if not fca:isVisible() then
        return false
      end
      if title:isVisible() and ed.containsPoint(title, x, y) then
        return true
      end
      return ed.isPointInCircle(ccpAdd(cfg.pos, cfg.touchCenter), cfg.touchRadius * scale, x, y, parent)
    end,
    pressHandler = function(param, x, y)
      self.startX = x
      if not title:isVisible() then
        return
      end
      titlePress:setVisible(true)
    end,
    cancelPressHandler = function(x, y)
      if not title:isVisible() or not titlePress:isVisible() then
        return
      end
      titlePress:setVisible(false)
      ed.guide.manager:setCheckResult(false)
    end,
    clickHandler = function()
      ed.guide.manager:setCheckResult(true)
      local mod = mapCfg.builddingType[buildType]
      if self.newSeasonList[buildType] then
        self.newSeasonList[buildType] = nil
        if not tolua.isnull(self.ui["bgDialog_" .. buildType]) then
          self.ui["bgDialog_" .. buildType]:removeFromParentAndCleanup(true)
        end
      end
      local isOpen = true
      if cfg.onClick and type(cfg.onClick) == "function" then
        cfg.onClick(cfg)
      end
      if cfg.checkIsOpenBeforeLevel and type(cfg.checkIsOpenBeforeLevel) == "function" then
        isOpen = cfg.checkIsOpenBeforeLevel()
        if not isOpen then
          return
        end
      end
      isOpen = ed.playerlimit:moduleIsOpened(mod)
      if not isOpen then
        ed.showToast(string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167\229\188\128\230\148\190\239\188\129"), ed.playerlimit:getModuleUnlockLevel(mod)))
        return
      end
      ed.UITool.openView(cfg.openViewIdentity)
    end,
    mcpMode = true,
    mcp_dis = 14,
    priority = cfg.priority or 100,
    force = true,
    clickInterval = 0.2
  }
  self:btRegisterClick(clickHandler)
  return {
    builddingType = buildType,
    cfg = cfg,
    fca = fca,
    titles = {
      title,
      titlePress,
      titleNotOpen
    },
    redPoint = redPoint,
    clickHandler = clickHandler
  }
end

function mainScene:getBuilding(buildType)
  return self.buildings[buildType]
end

function mainScene:updateBuildingStatus(buildding)
  local level = ed.player:getLevel()
  local isOpen = ed.playerlimit:moduleIsOpened(mapCfg.builddingType[buildding.builddingType])
  local visibleLevel = buildding.cfg.visibleLevel
  local titleVisibleLevel = buildding.cfg.titleVisibleLevel
  buildding.fca:setVisible(isOpen or level >= visibleLevel)
  buildding.titles[1]:setVisible(isOpen)
  buildding.titles[3]:setVisible(not isOpen and level >= titleVisibleLevel)
  local status = isOpen and buildding.cfg.getRedPointStatus()
  buildding.redPoint:setVisible(status)
  if buildding.builddingType == mapCfg.builddingType.Mailbox then
    buildding.fca:setAction(status and "Full" or "Empty")
  end
end

function mainScene:createSceneEffects()
  self.sceneEffects = {}
  for i, cfg in ipairs(mapCfg.sceneEffectsConfigs) do
    local fca = self:createFca(cfg)
    local parent = self:getMapLayer(cfg.layer)
    parent:addChild(fca, cfg.order or 0)
    table.insert(self.sceneEffects, fca)
  end
end

function mainScene:createFca(cfg)
  local node
  if string.find(cfg.res, "eff_UI_") then
    node = ed.createFcaNode(cfg.res)
  else
    node = ed.readhero.getActor(cfg.res, "Idle", true)
  end
  node:setPosition(cfg.pos)
  local action = cfg.default_action
  if action then
    node:setAction(action)
  end
  local scale = cfg.scale or 1
  node:setScale(scale)
  self:addFca(node)
  if cfg.lightSize then
    local newSize = CCSizeMake(cfg.lightSize.width * scale, cfg.lightSize.height * scale)
    self:setFcaRect(node, newSize)
  end
  return node
end

function mainScene:createSpineAnim(cfg)
  local scale = cfg.scale or 1
  local node = ed.createSpine(string.format("effect/%s/%s", cfg.res, cfg.res))
  node:setAnimation(0, "Idle", true)
  node:setPosition(cfg.pos)
  local action = cfg.default_action
  if action then
    node:setAnimation(0, action, true)
  end
  node:setScale(scale)
  if cfg.lightSize then
    local newSize = CCSizeMake(cfg.lightSize.width * scale, cfg.lightSize.height * scale)
    self:setFcaRect(node, newSize)
  end
  return node
end

function mainScene:createNewActTip()
  local lh, rh = ed.display.winSize.height / 2, ed.display.winSize.height / 2
  local li, ri = 0, 0
  for k, v in pairs(self.newSeasonList) do
    local inScreen, arrow = self:isInScreen(k)
    if arrow == "Left" then
      local arrow = ed.createSprite("UI/alpha/1080P/toparena/toparena_open_arrow.png")
      arrow:setPosition(ccp(120 - ed.display.halfFixedWidth, lh + 30 * li))
      self.ui["arrow" .. k] = arrow
      self.uiLayer:addChild(arrow, 999)
      local dialog = ed.createttf(v, 18)
      ed.setLabelColor(dialog, ed.toccc3(16776423))
      ed.setLabelStroke(dialog, ed.toccc3(4273968), 1)
      arrow:addChild(dialog)
      dialog:setPosition(ccp(100, 39))
      dialog:setScale(math.min(1, 150 / dialog:getContentSize().width))
      local mr = CCMoveBy:create(0.6, ccp(-20, 0))
      local ml = CCMoveBy:create(0.6, ccp(20, 0))
      local action = CCRepeatForever:create(CCSequence:createWithTwoActions(mr, ml))
      arrow:runAction(action)
      li = li + 1
    elseif arrow == "Right" then
      local arrow = ed.createSprite("UI/alpha/1080P/toparena/toparena_open_arrow.png")
      arrow:setRotation(180)
      arrow:setPosition(ccp(ed.display.winSize.width + ed.display.halfFixedWidth - 120, rh + 30 * ri))
      self.ui["arrow" .. k] = arrow
      self.uiLayer:addChild(arrow, 999)
      local dialog = ed.createttf(v, 18)
      ed.setLabelColor(dialog, ed.toccc3(16776423))
      ed.setLabelStroke(dialog, ed.toccc3(4273968), 1)
      dialog:setRotation(180)
      arrow:addChild(dialog)
      dialog:setPosition(ccp(100, 39))
      dialog:setScale(math.min(1, 150 / dialog:getContentSize().width))
      local mr = CCMoveBy:create(0.6, ccp(20, 0))
      local ml = CCMoveBy:create(0.6, ccp(-20, 0))
      local action = CCRepeatForever:create(CCSequence:createWithTwoActions(mr, ml))
      arrow:runAction(action)
      ri = ri + 1
    end
  end
end

function mainScene:initUI()
  local container = ed.editorui(ed.uieditor.mainScene, {
    ui = self.ui
  })
  self.mainLayer:addChild(container, 100)
  self.uiLayer = container
  self:setBackground()
  self:initHeadView()
  self:refreshSummonHeroDisplay()
  self:closeTouchSwallow()
  self:createNewActTip()
end

function mainScene:initHeadView()
  local ui = self.ui
  ui.playLv:setStroke(ccc3(249, 225, 109), 0.5)
  ui.playLv_blak:setStroke(ccc3(43, 28, 11), 0.7)
  ui.playHead:setVisible(false)
  ui.playHeadTop:setVisible(false)
  ed.layout.layoutWithMagin(ui.head_root, {top = 0, left = 0})
  self:refreshName()
  self:refreshLevel()
  self:refreshHead()
  self:refreshBuff()
end

function mainScene:refreshName()
  local name = ed.getPlayerName(ed.player:getName(), ed.player:getMedal().wearInfo, {
    anchorPoint = ccp(0.5, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "head_root", "playerName", name)
end

function mainScene:refreshLevel()
  local level = ed.player:getLevel()
  local playerExp = ed.player:getExp()
  local playerExpMax = ed.player:getMaxExp()
  local per = ed.clamp(playerExp / playerExpMax, 0, 1)
  self.ui.playLv:setString(ed.formatLevel("Lv") .. (level or "0"))
  self.ui.playLv_blak:setString("")
  ed.setLabelStroke(self.ui.playLv, ccc3(ed.colorToStr("#2b1c0b")), 1)
  self.ui.exp_progress_bar:setTextureRect(CCRectMake(0, 0, per * 105, 9))
end

function mainScene:refreshHead()
  local ui = self.ui
  if ui.head then
    ui.head:removeFromParentAndCleanup(true)
    ui.head = nil
  end
  if ui.frame then
    ui.frame:removeFromParentAndCleanup(true)
    ui.frame = nil
  end
  local head, headicon, headfca = ed.getHeadIcon()
  head:setPosition(ui.playHead:getPosition())
  ui.head_root:addChild(head, 2)
  ui.head = head
  ui.headIcon = headicon
  ui.headfca = headfca
  local frame, frameicon, framefca = ed.getHeadFrame()
  frame:setPosition(ui.playHeadTop:getPosition())
  ui.head_root:addChild(frame, 3)
  if framefca then
    ListenTimer(Timer:Once(0.5), function()
      if tolua.isnull(frameicon) then
        return
      end
      frameicon:setVisible(false)
    end)
  end
  ui.frame = frame
  self:btRemoveMainTouchHandler({
    key = "head_button"
  })
  self:btRegisterButtonClick({
    button = ui.headIcon,
    pressScale = 0.99,
    normalScale = 1.05,
    key = "head_button",
    force = true,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.ui.playerInfoWindow.create():popWindow()
    end,
    priority = -18
  })
  local redPoint = ed.ui.serviceSettingWin.createPSPRedPoint(self, frame)
  redPoint:setPosition(75, 75)
end

function mainScene:refreshBuff()
  local buffMgr = ed.activityBuffMgr.getInstance()
  local param = {
    buffIdList = buffMgr:getbuffByType({"all"}),
    extraTypeList = "all",
    column = 5
  }
  if not self.buffTipsPanel then
    self.buffTipsPanel = ed.buffTipsPanel.create(param)
    self.ui.head_root:addChild(self.buffTipsPanel.container)
    self.buffTipsPanel.container:setPosition(ccp(75, 0))
  else
    self.buffTipsPanel:refreshPanel(param)
  end
end

function mainScene:refreshSummonHeroDisplay()
  local heroPosList = {
    ccp(1410, 100),
    ccp(1690, 90)
  }
  local summonHeroConfig = ed.activityHints.data:getTimelySummonShow()
  if not self.puppetTable then
    self.puppetTable = {}
  end
  self.heroClickTimes = {}
  local displayHeroIdList = {}
  local parent = self:getMapLayer(4)
  local heroAmount = 0
  for index, config in ipairs(summonHeroConfig) do
    local clickTimes = config.clickTimes
    local heroIdList = config.heroIdList
    local talkMsgList = config.talkMsgList
    local actiId = config.actiId
    local taskData = config.taskData
    local taskState = ed.activityTaskTool.getTaskState(taskData)
    for _, heroId in ipairs(heroIdList or {}) do
      displayHeroIdList[heroId] = 1
      if self.puppetTable[heroId] then
        self.puppetTable[heroId].taskState = taskState
        break
      end
      local puppet = ed.readhero.getActor(heroId, "Idle")
      puppet:setScale(0.5)
      puppet:setAction("Idle")
      puppet.taskState = taskState
      self:addFca(puppet)
      parent:addChild(puppet, 30)
      self.puppetTable[heroId] = puppet
      heroAmount = heroAmount + 1
      local pos = heroAmount <= #heroPosList and heroPosList[heroAmount] or heroPosList[1]
      puppet:setPosition(pos)
      self:btRegisterCircleClick({
        center = ccp(0, 40),
        radius = 80,
        parent = puppet,
        key = heroId,
        force = true,
        mcpMode = true,
        clickHandler = function()
          local heroClickTimes = self.heroClickTimes[heroId] or 0
          heroClickTimes = heroClickTimes + 1
          if puppet.taskState == "TODO" or puppet.taskState == "IS_COMPLETED" then
            if heroClickTimes >= clickTimes then
              heroClickTimes = 0
              ed.activityHints.taskSubmitReplyActiId = actiId
              ed.activityHints.network:activitySubmit(actiId, taskData._id)
            end
          else
            local myHero = ed.player:getHero(heroId)
            if not myHero then
              ed.activityTaskTool.openSummonScene(3)
            else
              ed.ui.heroDetailScene.showHeroDetailSceneByHeroId(heroId)
            end
          end
          self.heroClickTimes[heroId] = heroClickTimes
          local k = math.random(1, #talkMsgList)
          self:showHeroTalk(puppet, talkMsgList[k])
        end
      })
    end
  end
  local clearIdList = {}
  for heroId, puppet in pairs(self.puppetTable) do
    if not displayHeroIdList[heroId] then
      table.insert(clearIdList, heroId)
    end
  end
  for index, heroId in ipairs(clearIdList) do
    local puppet = self.puppetTable[heroId]
    if puppet and not tolua.isnull(puppet) then
      puppet:removeFromParentAndCleanup(true)
    end
    self.puppetTable[heroId] = nil
  end
end

function mainScene:showHeroTalk(parent, str)
  if self.talkFrame and not tolua.isnull(self.talkFrame) then
    self.talkFrame:removeFromParentAndCleanup(true)
    self.talkFrame = nil
  end
  if not tolua.isnull(self.talkFrame) then
    self.talkFrame:removeFromParentAndCleanup(true)
  end
  local param = {
    text = str,
    fontSize = 15,
    fontColor = ed.toccc3(16776423),
    scale9Res = "UI/alpha/1080P/common/dialog_timely_summon_show.png",
    scale9rectMake = CCRectMake(20, 30, 60, 2),
    scale = 2,
    bubbleDelayTime = 2,
    bubbleFadeOutTime = 1,
    labelDelayTime = 3,
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
      end
    end
  }
  local frame = ed.createDialogBubble(param)
  self.talkFrame = frame
  parent:addChild(frame)
  frame:setPosition(ccp(45, 73))
end

function mainScene:refreshActivityTip()
end

function mainScene:registEvents()
  self:btRegisterHandler({
    handler = self:doDragMapTouch(),
    key = "dragMap"
  })
  self:registerOnEnterHandler("onMainSceneEnter", function()
    self:onMainSceneEnter()
  end)
  self:registerOnExitHandler("onMainSceneExit", function()
    self:onMainSceneExit()
  end)
  self:registerUpdateHandler("onMainSceneUpdate", function(dt)
    self:onMainSceneUpdate(dt)
  end)
  local eventsScope = {}
  self:registerOnPopSceneHandler("onMainScenePop", function()
    self:onMainScenePop()
    CloseScope(eventsScope)
    if self.buffTipsPanel then
      self.buffTipsPanel:CloseScope()
    end
    eventsScope = nil
  end)
  ListenEvent("StoryEnd", function(name)
    self:onStoryEnd(name)
  end, eventsScope)
  ListenEvent("setAvatarFrame", function(result)
    if not result then
      return
    end
    self:refreshHead()
  end, eventsScope)
  ListenEvent("PlayerExpChanged", function()
    self:refreshLevel()
  end, eventsScope)
  ListenEvent("PlayerLevelUp", function()
    for buildType, buildding in pairs(self.buildings) do
      self:updateBuildingStatus(buildding)
    end
    self:initRightTopButtons()
  end, eventsScope)
  ListenEvent("RefreshRightTopButtons", function()
    self:initRightTopButtons()
  end, eventsScope)
  ListenEvent("SetNameSuccess", function()
    self:refreshName()
  end, eventsScope)
  ListenEvent("medal_reply", function()
    self:refreshName()
  end, eventsScope)
  ListenEvent("activityCrossDays", function()
    self:refreshName()
  end, eventsScope)
  ListenEvent("MainBuildRedTagChange", function(buildType)
    local building = self.buildings[buildType]
    if building then
      self:updateBuildingStatus(building)
    end
  end, eventsScope)
  ListenEvent("ActivityUpdateSuccess", function()
    self:refreshSummonHeroDisplay()
  end, eventsScope)
  ListenEvent("MainActivityTips", function()
    for buildType, buildding in pairs(self.buildings) do
      self:updateBuildingActivityTips(buildding)
    end
  end, eventsScope)
  if not resource_config.LongConnection_close then
    ListenTimer(Timer:Once(2), function()
      ed.socket_long_connection.register()
    end)
  end
end

function mainScene:isInScreen(bulidIdx)
  local bulidPos = mapCfg.buildingsConfigs[bulidIdx].pos
  local winWidth = ed.display.winSize.width
  local x, y = self:getMapLayer(layerOrders.Top):getPosition()
  local screenMinX = math.abs(x)
  local screenMaxX = math.abs(x) + winWidth
  if screenMinX > bulidPos.x then
    return false, "Left"
  elseif screenMaxX < bulidPos.x then
    return false, "Right"
  else
    return true
  end
end

function mainScene:doDragMapTouch()
  local preMode, dragMode, mapOriX, mapOriY, touchStartX, speed, count, validCount, dt, prex, prey
  local topLayer = self:getMapLayer(layerOrders.Top)
  
  local function handler(event, x, y)
    if not self.dragEnabled then
      return
    end
    if event == "began" then
      self:stopScrollMap()
      self.dragNumber = self.dragNumber + 1
      mapOriX, mapOriY = topLayer:getPosition()
      self.startCountTime = true
      count = 0
      validCount = 0
      speed = 0
      self.mainCount = 0
      preMode = false
      dragMode = false
      prex, prey = x, y
      touchStartX = x
    elseif event == "moved" then
      dt = self.mainCount - count
      if dt == 0 then
        return
      end
      count = self.mainCount
      preMode = dragMode
      dragMode = dragMode or math.abs(touchStartX - x) > mapCfg.dragModeJudgeDistance
      if dragMode then
        if preMode then
          local mdx, mdy = x - prex, y - prey
          local tx, ty = topLayer:getPosition()
          self:refreshMapPos(tx + mdx, ty + mdy)
          local s = mdx / dt
          if speed / s <= 0 then
            speed = s
          else
            speed = (s + speed) / 2
          end
        else
          validCount = self.mainCount
        end
      end
      prex, prey = x, y
    elseif event == "ended" then
      dt = self.mainCount - validCount
      if dt < 0.5 then
        local tx = topLayer:getPositionX()
        local duration = 0.6
        local dx = tx + speed * duration / 2
        self:horizontalScroll(dx, {gap = duration})
      end
      self.startCountTime = false
      if ed.gm_mod and mapOriX >= mapSlidingRange.maxX and dragMode and 100 < x - touchStartX then
        ed.gggggm()
      end
    else
      self.startCountTime = false
    end
  end
  
  return handler
end

function mainScene:refreshLayerPos(ox, oy, layerOrder)
  local layer, config = self:getMapLayer(layerOrder)
  local rate = 1 - config.damping
  local x, y = rate * ox, rate * oy
  if layerOrders.Top == layerOrder then
    local minX, maxX = mapSlidingRange.minX, mapSlidingRange.maxX
    local minY, maxY = mapSlidingRange.minY, mapSlidingRange.maxY
    x = ed.clamp(x, minX, maxX)
    y = ed.clamp(y, minY, maxY)
  end
  local px, py = layer:getPosition()
  if px ~= x or py ~= y then
    layer:setPosition(x, y)
    return x, y, true
  end
  return x, y, false
end

function mainScene:checkArrowState(x, y)
  for k, v in pairs(self.newSeasonList) do
    if self:isInScreen(k) and self.ui["arrow" .. k] then
      self.ui["arrow" .. k]:setVisible(false)
    end
  end
end

function mainScene:refreshMapPos(x, y)
  local x, y, ret = self:refreshLayerPos(x, y, layerOrders.Top)
  if not ret then
    return
  end
  for _, order in pairs(layerOrders) do
    if order ~= layerOrders.Top then
      self:refreshLayerPos(x, y, order)
    end
  end
end

function mainScene:horizontalScroll(endX, addition)
  if endX == mapSlidingRange.minX or endX == mapSlidingRange.maxX then
    return
  end
  endX = ed.clamp(endX, mapSlidingRange.minX, mapSlidingRange.maxX)
  local gap = addition.gap
  for _, order in pairs(layerOrders) do
    local layer, config = self:getMapLayer(order)
    layer:stopAllActions()
    local y = layer:getPositionY()
    local offsetX = endX * (1 - config.damping)
    local moveTo = CCMoveTo:create(gap, ccp(offsetX, y))
    layer:runAction(CCEaseSineOut:create(moveTo))
  end
  ListenTimer(Timer:Once(2), function()
    self.dragNumber = self.dragNumber - 1
    if self.dragNumber == 0 then
      self.pauseMode_tick_interval = self.normal_tick
    end
  end)
end

function mainScene:stopScrollMap()
  for k, layer in pairs(self.mapLayers) do
    layer:stopAllActions()
  end
end

function mainScene:onMainSceneEnter()
  if self.create_main_scene then
    ed.reportHUE({
      action_type = "enter_main_scene"
    })
    self.create_main_scene = nil
  end
  ed.enableFcaAutoRelease(true)
  FireEvent("mainSceneEnter")
  ed.openMemeryGC = true
  if not self.from5v5 and not ed.guide.data:isCompleted(6) and ed.checkStoryEnded("OpeningMain") then
    FireEvent(ed.guide.eventNames.AFTER_DR)
  end
  ed.preloadInMainScene()
  if EDFLAGWIN32 then
    require("gmtools/server_ping")
    local isShow = CCDirector:sharedDirector():isDisplayStats()
    ed.ui.server_ping:showBattleFPS(isShow)
  end
end

function mainScene:onMainSceneExit()
end

function mainScene:onMainScenePop()
end

function mainScene:onMainSceneUpdate(dt)
  if self.startCountTime then
    self.mainCount = self.mainCount + dt
  end
  self:checkArrowState()
  ed.player:refreshVitality()
end

function mainScene:showCard()
  ed.UITool.openView("SummonRewardCardWindow", {
    rewards = {
      {
        id = 2,
        amount = 1,
        type = "hero"
      }
    },
    noRewards = true,
    closeCallback = function()
      FireEvent(ed.guide.eventNames.AFTER_DR)
    end
  })
end

function mainScene:onStoryEnd(name)
  if name == "OpeningMain" and not ed.guide.data:isCompleted(6) then
    self:showCard()
  end
end

function mainScene:getGuideNode(nodeKey)
  local building = self:getBuilding(mapCfg.builddingType[nodeKey])
  if building then
    local cfg = building.cfg
    local scale = building.cfg.scale or 1
    return building.fca, ed.guide.helper.createCircleTouchArea(cfg.touchCenter, cfg.touchRadius * scale)
  end
  return base.getGuideNode(self, nodeKey)
end
