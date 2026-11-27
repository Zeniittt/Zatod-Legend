local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.hadesHeatScene = class
ed.UITool.registViewOpenFunc("hadesHeatScene", function(param)
  local groupId = param.groupId or 1
  local openLevel = ed.getDataTable("HeatGroup")[groupId]["Open Level"]
  if openLevel > ed.player:getLevel() then
    ed.showToast(string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%s\231\186\167\232\167\163\233\148\129"), openLevel))
    return
  end
  ed.hadesHeatNet.sendOpenPanel(groupId)
  ListenEventOnce("hadesHeatOpenPanel", function()
    param = param or {}
    local scene = class.create(param)
    ed.pushScene(scene)
  end)
end)

function class.create(param)
  local self = base.create("hadesHeatScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.groupId = param.groupId or 1
  self.hadesHeatMgr = ed.hadesHeatMgr.getInstance()
  self.heatGroupTB = ed.getDataTable("HeatGroup")
  self.heatTB = ed.getDataTable("Heat")
  self.stageId = self.heatGroupTB[self.groupId]["Heat Stage"]
  self.uiList = {}
  self.heatSelect = {}
  self.challengeEndTime = self.hadesHeatMgr:getHeatNotify(self.groupId)._challenge_end_time or 0
  local localHeat = self:getLocalStorageHeat(self.groupId)
  local activeHeatIdList = self.heatGroupTB[self.groupId]["Heat Active"] or {}
  for heatId, level in pairs(localHeat) do
    if ed.isElementInTable(heatId, activeHeatIdList) and 0 < level then
      table.insert(self.heatSelect, {_heat_id = heatId, _times = level})
    end
  end
  self.bossHeroId = nil
  self.bossLevel = nil
  self.totalHeat = nil
  self.firstEnterScene = true
  self:initView()
  self:registerRedDot()
  self:refreshView()
  self:registerTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.hades_main_scene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackground()
  self:setBackButton(function()
    self:saveLocalStorageHeat(self.groupId, self.heatSelect)
  end)
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(11942683), 1.5)
  self.ui.label_title:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_total_heat, ed.toccc3(14116371), 1)
  self.ui.label_total_heat:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_hero_name, ed.toccc3(5914403), 1)
  self.ui.label_hero_name:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_option_title, ed.toccc3(8528917), 1)
  self.ui.label_option_title:setFontName(ed.fontBold)
  ed.setLabelShadow(self.ui.label_challenge, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_clear, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_history_heat, ed.toccc3(9581073), 1)
  ed.setLabelStroke(self.ui.label_heat_reward, ed.toccc3(12283392), 1)
  ed.setLabelStroke(self.ui.label_heat_rank, ed.toccc3(12283392), 1)
  local challengeBtnRes, labelColor
  if ed.getServerTime() >= self.challengeEndTime then
    challengeBtnRes = "UI/alpha/1080P/common/button_big_grey.png"
    labelColor = 15790320
    ed.updateSpriteGray(self.ui.image_challenge, true)
  else
    challengeBtnRes = "UI/alpha/1080P/common/buttion_big.png"
    labelColor = 16642206
    ed.updateSpriteGray(self.ui.image_challenge, false)
  end
  ed.setLabelColor(self.ui.label_challenge, ed.toccc3(labelColor))
  ed.initSpriteWithFrame(self.ui.btn_challenge, challengeBtnRes)
  self:adaptUI()
  self:initEffect()
  self:initDragList()
  self:initHeroInfo()
end

function class:registerRedDot()
  ed.redPointMgr.getInstance():registerValueChange("hades_heat_reward_entry", self, {
    handle = function(value)
      self.ui.image_reward_reddot:setVisible(0 < value)
    end
  })
end

function class:initEffect()
  local bubble = ed.createFcaActor("eff_UI_Main_Hades_bubble")
  bubble:setAction("Loop")
  bubble:setLoop(true)
  self:addFca(bubble)
  bubble:setPosition(ccp(785, 550))
  self.ui.image_bg:addChild(bubble)
  bubble:setZOrder(1)
  local fire = ed.createFcaActor("eff_UI_Main_Hades_fire")
  fire:setAction("Loop")
  fire:setLoop(true)
  self:addFca(fire)
  fire:setPosition(ccp(280, 350))
  self.ui.image_bg:addChild(fire)
  local fire2 = ed.createFcaActor("eff_UI_Main_Hades_fire2")
  fire2:setAction("Loop")
  fire2:setLoop(true)
  self:addFca(fire2)
  fire2:setPosition(ccp(700, 80))
  self.ui.image_bg:addChild(fire2)
  local magma = ed.createFcaActor("eff_UI_Main_Hades_magma")
  magma:setAction("Loop")
  magma:setLoop(true)
  self:addFca(magma)
  magma:setPosition(ccp(552, 360))
  self.ui.image_bg:addChild(magma)
end

function class:initDragList()
  local size = self.ui.layer_item:getContentSize()
  self.dragList = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:getPressInHandler(),
    cancelPressIn = self:getCancelPressIn(),
    doClickIn = self:getClickInHandler(),
    priority = -300,
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width - 1, size.height / 2),
      barres = "UI/alpha/1080P/hades/hades_main_slide.png",
      bgres = "UI/alpha/1080P/hades/hades_main_slide_bg.png",
      alwaysShow = true
    }
  })
  self:refreshDragList()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_heat_rank, {
    left = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_heat_reward, {
    left = 30 + ed.display.getNotchHeight()
  }, false, true)
end

function class:initHeroInfo()
  local waveId = 1
  local heatBattleCfg = ed.getDataTable("HeatBattle")[self.stageId][waveId]
  local bossPosition = heatBattleCfg["Boss Position"]
  local bossHeroId = heatBattleCfg[string.format("Monster %s ID", bossPosition)]
  if not bossHeroId then
    return
  end
  self.bossHeroId = bossHeroId
  self.bossLevel = heatBattleCfg[string.format("Level %s", bossPosition)]
  local puppet, cha = ed.readhero.getActor(bossHeroId, "Idle", true, false)
  puppet:setScale(1.35)
  self:addFca(puppet)
  puppet:update(0)
  self.ui.layer_hero:addChild(puppet)
  ed.layout.centerXInParent(puppet)
  local bossName = ed.getDataTable("HeatBoss")[self.stageId]["Boss Name"]
  self.bossName = bossName
  ed.setLabelString(self.ui.label_hero_name, bossName)
end

function class:refreshView()
  self:refreshTotalHeat()
  self:refreshHistoryHeat()
end

function class:refreshDragList()
  self.dragList:clearList()
  self.uiList = {}
  local layerHeight = self.ui.layer_item:getContentSize().height
  local height = 0
  local offX = 3
  local allHeat = {}
  for _, heatId in ipairs(self.heatGroupTB[self.groupId]["Heat Active"] or {}) do
    table.insert(allHeat, heatId)
  end
  for _, heatId in ipairs(self.heatGroupTB[self.groupId]["Heat Passive"] or {}) do
    table.insert(allHeat, heatId)
  end
  for index, heatId in ipairs(allHeat) do
    local container, ui = self:createOptionItem(index, heatId)
    local size = container:getContentSize()
    self.dragList:addItem(container)
    container:setPosition(ccp(size.width / 2 + offX, layerHeight - height - size.height / 2))
    height = height + container:getContentSize().height
    table.insert(self.uiList, {ui = ui, heatId = heatId})
  end
  self.dragList:initListHeight(height)
end

function class:createOptionItem(index, heatId)
  local container, ui = ed.editorui(ed.uieditor.hades_option)
  container:setContentSize(ui.image_bg:getContentSize())
  local cfg = self.heatTB[heatId]
  local type = cfg.Type
  local heatValue = cfg.HeatValue1
  local maxLevel = cfg.MaxLevel
  local level = self:getHeatLevel(heatId)
  if 0 < level then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/hades/hades_boss_heat_active2.png")
  else
    ed.setTexture(ui.image_bg, cfg.Bg)
  end
  if level <= 0 then
    ed.setTexture(ui.btn_minus, "UI/alpha/1080P/hades/hades_boss_heat_min.png")
  else
    ed.setTexture(ui.btn_minus, "UI/alpha/1080P/hades/hades_boss_heat_down.png")
  end
  if maxLevel <= level then
    ed.setTexture(ui.btn_add, "UI/alpha/1080P/hades/hades_boss_heat_max.png")
  else
    ed.setTexture(ui.btn_add, "UI/alpha/1080P/hades/hades_boss_heat_up.png")
  end
  ed.setTexture(ui.image_buff_icon, cfg.Icon)
  ed.setLabelStroke(ui.label_option_name, ed.toccc3(5119761), 1)
  ed.setLabelString(ui.label_option_name, cfg.HeatName)
  if ed.isElementInTable(type, {
    "CurrentHero",
    "Survivor"
  }) then
    ui.panel_num:setVisible(false)
    ui.label_desc:setVisible(true)
    ed.setLabelStroke(ui.label_desc, ed.toccc3(2499623), 1)
    ed.setLabelString(ui.label_desc, cfg.FrontDescription)
    ed.setLabelStroke(ui.label_heat_num, ed.toccc3(4134672), 1)
    ed.setLabelString(ui.label_heat_num, maxLevel * heatValue)
  else
    ui.panel_num:setVisible(true)
    ui.label_desc:setVisible(false)
    ed.setLabelStroke(ui.label_num, ed.toccc3(2565412), 1)
    local parameter = string.gsub(cfg.Parameter or "", "#p#", "%%")
    ed.setLabelString(ui.label_num, string.format("%s%s", level * cfg.ScriptArg1, parameter))
    ed.setLabelStroke(ui.label_heat_num, ed.toccc3(4134672), 1)
    ed.setLabelString(ui.label_heat_num, math.max(level * heatValue, heatValue))
  end
  return container, ui
end

function class:refreshOptionItem(ui, heatId)
  local cfg = self.heatTB[heatId]
  local type = cfg.Type
  local heatValue = cfg.HeatValue1
  local maxLevel = cfg.MaxLevel
  local level = self:getHeatLevel(heatId)
  if 0 < level then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/hades/hades_boss_heat_active2.png")
  else
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/hades/hades_boss_heat_active1.png")
  end
  if level <= 0 then
    ed.setTexture(ui.btn_minus, "UI/alpha/1080P/hades/hades_boss_heat_min.png")
  else
    ed.setTexture(ui.btn_minus, "UI/alpha/1080P/hades/hades_boss_heat_down.png")
  end
  if maxLevel <= level then
    ed.setTexture(ui.btn_add, "UI/alpha/1080P/hades/hades_boss_heat_max.png")
  else
    ed.setTexture(ui.btn_add, "UI/alpha/1080P/hades/hades_boss_heat_up.png")
  end
  ed.setLabelString(ui.label_heat_num, math.max(level * heatValue, heatValue))
  local parameter = string.gsub(cfg.Parameter or "", "#p#", "%%")
  ed.setLabelString(ui.label_num, string.format("%s%s", level * cfg.ScriptArg1, parameter))
end

function class:getHeatLevel(heatId)
  for index, chooseHeat in ipairs(self.heatSelect) do
    if chooseHeat._heat_id == heatId then
      return chooseHeat._times
    end
  end
  return 0
end

function class:setHeatLevel(heatId, level)
  for index, chooseHeat in ipairs(self.heatSelect) do
    if chooseHeat._heat_id == heatId then
      chooseHeat._times = level
      return
    end
  end
  table.insert(self.heatSelect, {_heat_id = heatId, _times = level})
end

function class:refreshTotalHeat()
  local totalHeat = 0
  for index, chooseHeat in ipairs(self.heatSelect) do
    local heatId = chooseHeat._heat_id
    local times = chooseHeat._times
    totalHeat = totalHeat + self.heatTB[heatId].HeatValue1 * times
  end
  self.totalHeat = totalHeat
  ed.setLabelString(self.ui.label_total_heat, totalHeat)
end

function class:refreshHistoryHeat()
  local heat = self.hadesHeatMgr:getMaxHeat(self.groupId)
  ed.setLabelString(self.ui.label_history_heat, string.format(T("\229\142\134\229\143\178\230\156\128\233\171\152%s"), heat))
end

function class:showOptionDetail(parent, heatId)
  if self.optionDetail then
    self.optionDetail:removeFromParentAndCleanup(true)
  end
  local heatCfg = self.heatTB[heatId]
  if not heatCfg then
    return
  end
  local heatName = heatCfg.HeatName
  local iconPath = heatCfg.Icon
  local optionDetail = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  self.mainLayer:addChild(optionDetail, 999)
  optionDetail:setAnchorPoint(ccp(0.5, 1))
  local icon = ed.createSprite(iconPath)
  icon:setScale(0.6)
  optionDetail:addChild(icon)
  local nameLabel = ed.createLabelTTF(heatName, 20)
  ed.setLabelColor(nameLabel, ed.toccc3(16776423))
  ed.setLabelStroke(nameLabel, ed.toccc3(2565412), 1)
  optionDetail:addChild(nameLabel)
  local line = ed.createSprite("UI/alpha/1080P/hades/hades_boss_line.png")
  optionDetail:addChild(line)
  local desc = heatCfg.FrontDescription .. (heatCfg.BackDescription or "")
  local scriptArg = heatCfg.ScriptArg1
  local heatValue = heatCfg.HeatValue1
  if scriptArg then
    desc = string.gsub(desc, "%%ScriptArg&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", scriptArg))
  end
  desc = string.gsub(desc, "%%HeatValue&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", heatValue))
  desc = string.gsub(desc, "#p#", "%%")
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16113079),
    strokeColor = ed.toccc3(1774610),
    strokeSize = 1,
    maxWidth = 300,
    fontSize = 16
  })
  optionDetail:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local bgWidth = 330
  local bgHeight = nameLabel:getContentSize().height + autoTextH + 35
  optionDetail:setContentSize(CCSizeMake(bgWidth, bgHeight))
  ed.layout.layoutWithParentMagin(icon, {left = 8, top = 7})
  ed.layout.layoutWithParentMagin(nameLabel, {left = 40, top = 15})
  ed.layout.layoutWithParentMagin(line, {left = 24, top = 45})
  ed.layout.layoutWithParentMagin(autoText.node, {left = 15, top = 60})
  local parentSize = parent:getContentSize()
  ed.layout.relateLayout(parent, optionDetail, {
    left = parentSize.width / 2,
    top = parentSize.height / 2
  })
  self.optionDetail = optionDetail
end

function class:getPressInHandler()
  local function handler(x, y)
    for _, cfg in ipairs(self.uiList or {}) do
      local ui = cfg.ui
      
      local heatId = cfg.heatId
      if ui.panel_num:isVisible() and ed.containsPoint(ui.btn_minus, x, y) then
        ui.btn_minus:setScale(0.95)
        return cfg
      elseif ui.panel_num:isVisible() and ed.containsPoint(ui.btn_add, x, y) then
        ui.btn_add:setScale(0.95)
        return cfg
      end
      if ed.containsPoint(ui.layer_click_tips, x, y) then
        return cfg
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, cfg)
    if cfg then
      local ui = cfg.ui
      
      local heatId = cfg.heatId
      if ed.containsPoint(ui.btn_minus, x, y) then
        local newLevel = self:getHeatLevel(heatId) - 1
        if newLevel < 0 then
          ed.showToast(T("\229\183\178\232\190\190\229\136\176\230\156\128\229\176\143"))
          return
        end
        self:showParticle(self.ui.image_total_hot_highlight, ui.image_hot_highlight)
        local level = math.max(newLevel, 0)
        self:setHeatLevel(heatId, level)
        self:refreshOptionItem(ui, heatId)
        self:refreshView()
      elseif ed.containsPoint(ui.btn_add, x, y) then
        local maxLevel = self.heatTB[heatId].MaxLevel
        local newLevel = self:getHeatLevel(heatId) + 1
        if maxLevel < newLevel then
          ed.showToast(T("\229\183\178\232\190\190\229\136\176\230\156\128\229\164\167"))
          return
        end
        self:showParticle(ui.image_hot_highlight, self.ui.image_total_hot_highlight)
        local level = math.min(newLevel, maxLevel)
        self:setHeatLevel(heatId, level)
        self:refreshOptionItem(ui, heatId)
        self:refreshView()
      end
      self:showOptionDetail(ui.image_bg, heatId)
    end
  end
  
  return handler
end

function class:getCancelPressIn()
  local function handler(x, y, cfg)
    local ui = cfg and cfg.ui
    
    if ui then
      ui.btn_minus:setScale(1)
      ui.btn_add:setScale(1)
    end
  end
  
  return handler
end

function class:onClickChallenge()
  self.dragList.listLayer:stopAllActions()
  if ed.getServerTime() >= self.challengeEndTime then
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
    return
  end
  local activeBuff = {}
  for index, heatData in ipairs(self.heatSelect) do
    if heatData._times > 0 then
      table.insert(activeBuff, heatData)
    end
  end
  self:saveLocalStorageHeat(self.groupId, activeBuff)
  local battleData = {
    groupId = self.groupId,
    stageId = self.stageId,
    bossId = self.bossHeroId,
    chooseHeat = activeBuff,
    passiveHeat = self.heatGroupTB[self.groupId]["Heat Passive"] or {},
    totalHeat = self.totalHeat,
    bossName = self.bossName,
    bossDesc = ed.getDataTable("HeatBoss")[self.stageId]["Boss Description"]
  }
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "HadesHeat",
    stage_id = self.stageId,
    heroLimit = {},
    objData = battleData
  }))
end

function class:onClickClear()
  ed.showConfirmDialog({
    text = T("\230\152\175\229\144\166\230\184\133\233\153\164\231\142\176\230\156\137\229\165\145\231\186\166\239\188\159"),
    rightText = T("\231\161\174\229\174\154"),
    skipDestroyAnim = true,
    rightHandler = function()
      self.heatSelect = {}
      self:saveLocalStorageHeat(self.groupId, {})
      self:refreshDragList()
      self:refreshView()
    end
  })
end

function class:getLocalStorageHeat(groupId)
  local key = ed.getRoleKey("LOCAL_HEAT_SELECT_" .. groupId)
  local str = ed.storage.getString(key)
  local heatList = {}
  if not str or str == "" then
    return heatList
  end
  for heatId, level in string.gmatch(str, "{(%d+)=(%d+)}") do
    heatList[tonumber(heatId)] = tonumber(level)
  end
  return heatList
end

function class:saveLocalStorageHeat(groupId, heatList)
  local key = ed.getRoleKey("LOCAL_HEAT_SELECT_" .. groupId)
  local str = ""
  for index, heatData in ipairs(heatList or {}) do
    local heatId = heatData._heat_id
    local level = heatData._times
    str = str .. string.format("{%d=%d}", heatId, level)
  end
  ed.storage.setValue(key, str)
end

function class:showParticle(startNode, endNode)
  if not startNode or not endNode then
    return
  end
  startNode:setOpacity(255)
  startNode:runAction(CCFadeOut:create(0.2))
  local startPos = startNode:getParent():convertToWorldSpace(ccp(startNode:getPosition()))
  local endPos = endNode:getParent():convertToWorldSpace(ccp(endNode:getPosition()))
  local particle = CCParticleSystemQuad:create("UI/particle/fire_hades_heat.plist")
  self.mainLayer:getParent():addChild(particle, 999)
  particle:setPosition(startPos)
  local distance = math.sqrt((startPos.x - endPos.x) ^ 2 + (startPos.y - endPos.y) ^ 2)
  local speed = 700
  local time = distance / speed
  local actionMoveTo = CCEaseExponentialOut:create(CCMoveTo:create(time, endPos))
  local delay = CCDelayTime:create(0.5)
  local callFunc = CCCallFunc:create(function()
    particle:removeFromParentAndCleanup(true)
  end)
  particle:runAction(ed.readaction.create({
    t = "seq",
    actionMoveTo,
    delay,
    callFunc
  }))
end

function class:registerTouchEvent()
  ed.UITool.registerBtn(self, "btn_challenge", function()
    self:onClickChallenge()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_clear", function()
    self:onClickClear()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_detail", function()
    ed.UITool.openView("hadesBossDetail", {
      stageId = self.stageId,
      bossId = self.bossHeroId,
      bossLevel = self.bossLevel
    })
  end, {normalScale = 0.9, pressScale = 0.85})
  self:btRegisterOutClick({
    area = self.ui.layer_item,
    clickHandler = function()
      if self.optionDetail then
        self.optionDetail:removeFromParentAndCleanup(true)
        self.optionDetail = nil
      end
    end,
    priority = -1
  })
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = ed.hadesDefine.RULES_TITLE,
      txt = ed.hadesDefine.RULES_TEXT
    }):popWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_heat_rank", function()
    ed.UITool.openView("hadesHeatRank", {
      groupId = self.groupId
    })
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_heat_reward", function()
    ed.redPointMgr.getInstance():setNodeValue("hades_heat_new_task", 0)
    ed.UITool.openView("hadesRewardWin", {
      groupId = self.groupId
    })
  end, {pressScale = 0.95})
end

function class:addEventListener()
  self:registerOnEnterHandler("onEnter", function()
    if self.firstEnterScene then
      self.firstEnterScene = false
      return
    end
    ed.hadesHeatNet.sendOpenPanel(self.groupId)
  end)
  self:listenEvent("hadesHeatOpenPanel", function(groupId)
    if groupId == self.groupId then
      self:refreshView()
    end
  end)
end

function class:onPopScene()
  local redPointMgr = ed.redPointMgr.getInstance()
  redPointMgr:unregisterValueChange("hades_heat_reward_entry", self)
  base.onPopScene(self)
end
