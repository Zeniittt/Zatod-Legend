local base = ed.ui.popwindow
local commonBattleWin = {}
commonBattleWin.__index = commonBattleWin
setmetatable(commonBattleWin, base.mt)
ed.ui.commonBattleWin = commonBattleWin
local commonBattleWinScope = {}
local lsr = ed.ui.stagedonelsr.create()

function commonBattleWin.create(param)
  local self = base.create("commonBattleWin")
  setmetatable(self, commonBattleWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:prepareEnterAnim()
  self:playEnterAnim()
  self:popWindow()
  self:show()
  return self
end

function commonBattleWin:initData(param)
  self.param = param
  self.lootui = {}
  self.loot_x = 0
  self.heroui = {}
  self.hero_x = 0
end

function commonBattleWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.commonBattleWin)
  self:initLabel()
  self:initTeamExp()
  self:initHeroList()
  self:initLootList()
  self:initTimer()
end

function commonBattleWin:initLabel()
  ed.setLabelStroke(self.ui.sweep_label, ccc3(ed.colorToStr("#32200b")), 2)
  ed.setLabelStroke(self.ui.loot_label, ccc3(ed.colorToStr("#000000")), 2)
  ed.setLabelStroke(self.ui.team_level, ccc3(ed.colorToStr("#392415")), 2)
  ed.setLabelStroke(self.ui.exp_label, ccc3(ed.colorToStr("#17311f")), 2)
  self.ui.label_back:setString(T("\231\187\167\231\187\173"))
  ed.setLabelStroke(self.ui.label_back, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_share, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.label_share, ccc3(0, 0, 0), ccp(0, 2))
end

function commonBattleWin:initTeamExp()
  local playerInfo = self.param.playerInfo
  local percent = ed.player:checkLevelMax(playerInfo.level) and 1 or playerInfo.exp / playerInfo.maxExp
  ed.setString(self.ui.team_level, T("\230\136\152\233\152\159\231\173\137\231\186\167    Lv.%s", tostring(playerInfo.level)))
  self.ui.team_exp_bar:setScaleX(percent)
  self.ui.exp_label:setString(T("+%s", playerInfo.addExp))
end

function commonBattleWin:initHeroList()
  local layersize = self.ui.heroLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = self.ui.heroLayer,
    zorder = 10,
    priority = -300
  }
  self.herodraglist = ed.draglist.create(info)
  self:addHeroIcons()
end

function commonBattleWin:addHeroIcons()
  local heroes = self.param.heroes
  local hcount = math.min(#heroes, 5)
  for i = 1, hcount do
    self:createHeroIcon(heroes[i])
  end
end

function commonBattleWin:createHeroIcon(hero)
  local mercenary = hero.bMercenary == true and {} or nil
  local heroIcon = ed.readhero.createIcon({
    id = hero.id,
    rank = hero.rank,
    level = hero.level,
    stars = hero._stars,
    hp = hero.hp,
    mp = hero.mp,
    mercenary = mercenary,
    fashion_id = hero.hero_proto and hero.hero_proto._fashion,
    summary = hero.hero_proto,
    showParagonLv = self.param.isAwakeStageMode,
    shard = hero.hero_proto._shard
  })
  local barBg = ed.createScale9Sprite("UI/alpha/1080P/battleresult/heroexp_bg.png", CCRectMake(3, 5, 2, 1))
  barBg:setAnchorPoint(ccp(0, 0.5))
  local bar = ed.createSprite("UI/alpha/1080P/battleresult/expbar.png")
  bar:setAnchorPoint(ccp(0, 0.5))
  barBg:setContentSize(CCSizeMake(bar:getContentSize().width, barBg:getContentSize().height))
  barBg:setPosition(ccp((heroIcon.icon:getContentSize().width - bar:getContentSize().width) / 2, -barBg:getContentSize().height / 2 - 15 / ed.display.scaleFactor))
  heroIcon.icon:addChild(barBg)
  bar:setPosition(ccp(barBg:getPosition()))
  heroIcon.icon:addChild(bar)
  local exp = ed.createttf("EXP+" .. (hero.addHeroExp or 0), 15)
  exp:setColor(ccc3(ed.colorToStr("#fffce7")))
  exp:setPosition(ccp(heroIcon.icon:getContentSize().width / 2, -30))
  heroIcon.icon:addChild(exp)
  local bgwidth = ed.layout.getScaleSize(heroIcon.bg).width
  heroIcon.icon:setPosition(ccp(self.hero_x + bgwidth / 2, 150 / ed.display.scaleFactor))
  self.hero_x = self.hero_x + bgwidth
  self.herodraglist.listLayer:addChild(heroIcon.icon)
  self.herodraglist:initListWidth(self.hero_x)
  table.insert(self.heroui, {
    icon = heroIcon,
    barBg = barBg,
    bar = bar
  })
end

function commonBattleWin:doClickInLoot()
  local function handler(x, y, i)
    lsr:report("clickLoot")
    
    local loot = self.lootui[i]
    if not loot then
      return
    end
    local panel = ed.readequip.getDetailCard(loot.id)
    local iconsize = loot.icon:getContentSize()
    local iconpos = loot.icon:getParent():convertToWorldSpace(ccp(loot.icon:getPosition()))
    local pos = ccpAdd(iconpos, ccp(iconsize.width / 2, iconsize.height / 2))
    panel:setPosition(pos)
    self.mainLayer:addChild(panel, 50)
    self.namePanel = panel
  end
  
  return handler
end

function commonBattleWin:cancelClickInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function commonBattleWin:doPressInLoot()
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      
      if ed.containsPoint(loot.icon, x, y) then
        return i
      end
    end
  end
  
  return handler
end

function commonBattleWin:cancelPressInLoot()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function commonBattleWin:initLootList()
  local layersize = self.ui.lootLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height + 20),
    noshade = true,
    container = self.ui.lootLayer,
    zorder = 10,
    priority = -300,
    doClickIn = self:doClickInLoot(),
    cancelClickIn = self:cancelClickInLoot(),
    doPressIn = self:doPressInLoot(),
    cancelPressIn = self:cancelPressInLoot()
  }
  self.lootdraglist = ed.draglist.create(info)
  self:addLootIcons()
end

function commonBattleWin:addLootIcons()
  local loots = self.param.lootList
  local fdRewards = self.param.fdRewards or {}
  local rewards = self.param.rewards
  if self.param.gold and self.param.gold > 0 then
    self:createLootIcon("Gold", {
      type = "Gold",
      amount = self.param.gold
    })
  end
  for k, v in pairs(loots or {}) do
    self:createLootIcon(k, v)
  end
  for index, rewardData in ipairs(fdRewards or {}) do
    self:createLootIconWithReward(rewardData, "first")
  end
  for index, rewardData in ipairs(rewards or {}) do
    self:createLootIconWithReward(rewardData)
  end
  self.ui.loot_label:setVisible(0 < #self.lootui)
end

function commonBattleWin:createLootIcon(key, value)
  local icon = ed.createItemIcon({
    id = key,
    amount = value.amount,
    type = value.type
  })
  local tag = ed.createSprite("UI/alpha/1080P/common/can_deal_tag.png")
  tag:setScale(1.5)
  local size = icon:getContentSize()
  tag:setPosition(ccp(size.width - 12, size.width - 14))
  icon:addChild(tag)
  icon:setAnchorPoint(ccp(0, 0))
  icon:setScale(0.88)
  icon:setPosition(ccp(self.loot_x, 0))
  self.loot_x = self.loot_x + ed.layout.getScaleSize(icon).width
  self.lootdraglist.listLayer:addChild(icon)
  self.lootdraglist:initListWidth(self.loot_x)
  local name
  if value.type == "equip" then
    name = ed.getDataTable("equip")[key].Name
  elseif value.type == "hero" then
    name = ed.getDataTable("Unit")[key]["Display Name"]
  elseif value.type == "Gold" then
    name = "Gold"
  end
  table.insert(self.lootui, {
    icon = icon,
    name = name,
    id = key
  })
end

function commonBattleWin:createLootIconWithReward(rewardData, cornerType)
  local id = rewardData._id
  local type = rewardData._type
  local amount = rewardData._amount
  local icon = ed.createItemIcon({
    id = id,
    type = type,
    amount = amount
  })
  icon:setAnchorPoint(ccp(0, 0))
  icon:setScale(0.88)
  icon:setPosition(ccp(self.loot_x, 0))
  local addition = self:getItemAddition({id = id, type = type})
  if addition then
    local labelBg = ed.createSprite("UI/alpha/1080P/activityadventure/adventure_battle_result.png")
    local label = ed.createttf(string.format("+%s%%", addition), 15)
    ed.setLabelColor(label, ed.toccc3(7405396))
    ed.setLabelStroke(label, ed.toccc3(1519903), 1)
    labelBg:addChild(label)
    ed.layout.centerInParent(label)
    icon:addChild(labelBg)
    labelBg:setPositionX(icon:getContentSize().width / 2)
    labelBg:setPositionY(icon:getContentSize().height)
  end
  if cornerType == "first" then
    local firstTag = ed.createSprite("UI/alpha/1080P/skilltower/icon_first.png")
    icon:addChild(firstTag)
    firstTag:setScale(1.6)
    firstTag:setPosition(ccp(44, icon:getContentSize().height * 0.88 + 3))
    firstTag:setZOrder(1)
    local labelFirst = ed.createttf(T("\233\166\150\230\172\161"), 11)
    ed.setLabelColor(labelFirst, ed.toccc3(16776919))
    firstTag:addChild(labelFirst)
    labelFirst:setPosition(ccp(24, 16.5))
  end
  self.loot_x = self.loot_x + ed.layout.getScaleSize(icon).width
  self.lootdraglist.listLayer:addChild(icon)
  self.lootdraglist:initListWidth(self.loot_x)
  table.insert(self.lootui, {
    icon = icon,
    id = id or type
  })
end

function commonBattleWin:getItemAddition(rewardData)
  local itemAdditionList = self.param.itemAdditionList
  if not itemAdditionList then
    return nil
  end
  for _, itemAddition in ipairs(itemAdditionList) do
    local id = itemAddition.id
    local type = itemAddition.type
    local addition = itemAddition.addition
    if rewardData.id and id == rewardData.id or rewardData.type and type == rewardData.type then
      return addition
    end
  end
  return nil
end

local loot_show_gap = 0.2
local hero_show_gap = 0.1
local hero_show_delay = 1

function commonBattleWin:prepareEnterAnim()
  self.ui.star_1:setScale(0)
  self.ui.star_2:setScale(0)
  self.ui.star_3:setScale(0)
  self.ui.data:setOpacity(0)
  self.ui.btn_data:setOpacity(0)
  self.ui.sweep_label:setVisible(false)
  for i = 1, #self.heroui do
    local ui = self.heroui[i]
    local hero = self.param.heroes[i]
    ui.icon.icon:setOpacity(0)
    if hero.exp and hero.maxExp then
      ui.bar:setScaleX(hero.exp / hero.maxExp)
    end
  end
  for i = 1, #self.lootui do
    local icon = self.lootui[i].icon
    icon:setScale(0)
  end
  self.ui.replay:setOpacity(0)
  self.ui.btn_replay:setOpacity(0)
  self.ui.label_back:setOpacity(0)
  self.ui.btn_back:setOpacity(0)
  self.ui.label_share:setOpacity(0)
  self.ui.btn_share:setOpacity(0)
end

function commonBattleWin:playEnterAnim()
  local stageId = self.param.stage_id
  local stageCsvName = self.param.stageCsvName or "Stage"
  local stageInfo = ed.getDataTable(stageCsvName)
  local iskey = stageInfo[stageId]["Key Stage"]
  lsr:report("createScene")
  self:playLightAnim()
  if iskey then
    self.ui.title:setVisible(false)
  else
    self.ui.title:setVisible(true)
    self.ui.light:setVisible(false)
  end
  self:playInfoBgAnim()
  if ed.ui.stageselectres.getIsLootStages(self.param.stage_id) then
    self.ui.img_victory:setVisible(true)
  elseif iskey then
    if self.param.isAwakeStageMode then
      self.ui.img_victory:setVisible(true)
    else
      self:playStarAnim()
    end
  else
    self.ui.img_victory:setVisible(true)
  end
  self:playLevelAnim()
  self:playHeroAnim()
end

function commonBattleWin:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y))
  self.ui.light:setVisible(false)
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 44))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 44))
  self.ui.bg:addChild(node)
end

function commonBattleWin:playInfoBgAnim()
  self.ui.btn_data:runAction(CCFadeIn:create(0.2))
  self.ui.data:runAction(CCFadeIn:create(0.2))
end

function commonBattleWin:playSweepNtfAnim()
  local stageId = self.param.stage_id
  if not ed.isElementInTable(ed.stageType(stageId), {
    "act",
    "elite",
    "normal",
    "challenge"
  }) then
    return
  end
  local record = ed.player.stage_star_record or {}
  local st = ed.getDataTable(ed.ui.stageaccount.stageCsvName)
  local row = st[stageId] or {}
  local stageName = row["Stage Name"]
  if self.param.stars == 3 and (record[stageId] or 0) < self.param.stars and ed.isElementInTable(ed.stageType(stageId), {"elite", "normal"}) then
    self.ui.sweep_label:setVisible(true)
  end
end

function commonBattleWin:playStarAnim()
  if self.param.isTbcMode then
    return
  end
  lsr:report("starAnimEnd")
  if nil == self.param.stars then
    return
  end
  local node = ed.createFcaNode("eff_UI_pve_victory_star_" .. ed.clamp(self.param.stars, 1, 3))
  self.ui.layer_star:setVisible(true)
  self:addFca(node)
  if self.param.stars == 1 then
    node:setPosition(self.ui.ImageView_1063:getPosition())
  elseif self.param.stars == 2 then
    node:setPosition(ccp(-34, 20))
  else
    node:setPosition(self.ui.ImageView_1064:getPosition())
  end
  self.ui.layer_star:addChild(node, 99)
end

function commonBattleWin:playLevelAnim()
  local playerInfo = self.param.playerInfo
  local isMax = ed.player:checkLevelMax(playerInfo.level)
  local oriPercent = ed.player:checkLevelMax(playerInfo.oriLevel) and 1 or playerInfo.oriExp / playerInfo.oriMaxExp
  local percent = ed.player:checkLevelMax(playerInfo.level) and 1 or playerInfo.exp / playerInfo.maxExp
  self.ui.team_exp_bar:setScaleX(oriPercent)
  local array = CCArray:create()
  for i = 1, playerInfo.level - playerInfo.oriLevel do
    local a = CCScaleTo:create(0.5, 1, 1)
    local f = CCCallFunc:create(function()
      if not tolua.isnull(self.ui.team_exp_bar) then
        self.ui.team_exp_bar:setScaleX(0)
      end
    end)
    array:addObject(a)
    array:addObject(f)
  end
  local a = CCScaleTo:create(0.5, percent, 1)
  array:addObject(a)
  local sequence = CCSequence:create(array)
  self.ui.team_exp_bar:runAction(sequence)
end

function commonBattleWin:playLevelupEffect(icon, id)
  if not self.levelupEffect then
    self.levelupEffect = {}
  end
  if self.levelupEffect[id] then
    self.levelupEffect[id] = nil
  end
  local node = ed.createFcaNode("eff_UI_levelup")
  local img_levelUp
  if ed.isAreaZhCn() then
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr.png")
  else
    img_levelUp = ed.createSprite("UI/alpha/1080P/common/drtrtr-global.png")
    img_levelUp:setScale(0.9)
  end
  local img_node = CCSprite:create()
  img_node:addChild(img_levelUp)
  node:addNodeToComponent(img_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  self:addFca(node)
  node:setPosition(ccp(36.5, 32.5))
  icon:addChild(node, 5)
  self.levelupEffect[id] = node
end

function commonBattleWin:playHeroBarAnim()
  local dt = hero_show_delay + 0.05 * math.max(#self.heroui - 1, 0)
  for i = 1, #self.heroui do
    local ui = self.heroui[i]
    local hero = self.param.heroes[i]
    local array = CCArray:create()
    local delay = CCDelayTime:create(dt)
    array:addObject(delay)
    for j = 1, hero.tLevel - hero.level do
      local a = CCScaleTo:create(0.5, 1, 1)
      dt = dt + 0.5
      local f = CCCallFunc:create(function()
        if not tolua.isnull(ui.bar) then
          lsr:report("heroLevelup")
          ui.bar:setScaleX(0)
          ui.icon:refreshLevel(hero.level + j)
          self:playLevelupEffect(ui.icon.icon, i)
        end
      end)
      array:addObject(a)
      array:addObject(f)
    end
    local a = CCScaleTo:create(0.2, hero.tExp / hero.tMaxExp, 1)
    dt = dt + 0.2
    local f = CCCallFunc:create(function()
      if not tolua.isnull(ui.bar) and hero.isMaxLevel then
        ui.bar:removeFromParentAndCleanup(true)
        local barBgSize = ui.barBg:getContentSize()
        local bar = ed.createSprite("UI/alpha/1080P/battleresult/expbar.png")
        bar:setAnchorPoint(ccp(0, 0.5))
        bar:setPosition(ccp(0, barBgSize.height / 2))
        ui.barBg:addChild(bar)
        local tag = ed.createttf(T("\231\187\143\233\170\140\229\183\178\230\187\161"), 15)
        tag:setColor(ccc3(ed.colorToStr("#fffce7")))
        tag:setPosition(ccp(barBgSize.width / 2, barBgSize.height / 2))
        tag:limitWidthByScale(barBgSize.width - 5)
        ui.barBg:addChild(tag, 2)
      end
    end)
    array:addObject(a)
    array:addObject(f)
    local sequence = CCSequence:create(array)
    ui.bar:runAction(sequence)
  end
end

function commonBattleWin:playHeroAnim()
  if #self.heroui == 0 then
    self:playLootAnim()
  else
    for i = 1, #self.heroui do
      local ui = self.heroui[i]
      if i ~= #self.heroui then
        local delay = CCDelayTime:create(hero_show_delay + hero_show_gap * (i - 1))
        local fade = CCFadeIn:create(0.2)
        local sequence = CCSequence:createWithTwoActions(delay, fade)
        ui.icon.icon:runAction(sequence)
      else
        local array = CCArray:create()
        local delay = CCDelayTime:create(hero_show_delay + hero_show_gap * (i - 1))
        local fade = CCFadeIn:create(0.2)
        local func = CCCallFunc:create(function()
          self:playLootAnim()
        end)
        array:addObject(delay)
        array:addObject(fade)
        array:addObject(func)
        local sequence = CCSequence:create(array)
        ui.icon.icon:runAction(sequence)
      end
    end
  end
  self:playHeroBarAnim()
end

function commonBattleWin:playButtonAnim()
  local replay = self.ui.replay
  local btn_replay = self.ui.btn_replay
  local label_back = self.ui.label_back
  local btn_back = self.ui.btn_back
  local label_share = self.ui.label_share
  local btn_share = self.ui.btn_share
  if btn_replay:numberOfRunningActions() > 0 or replay:numberOfRunningActions() > 0 or btn_back:numberOfRunningActions() > 0 or label_back:numberOfRunningActions() > 0 or btn_share:numberOfRunningActions() > 0 or label_share:numberOfRunningActions() > 0 then
    return
  end
  local action = CCFadeIn:create(0.2)
  local stage = self.param.stage_id
  local s = ed.elite2NormalStage(stage)
  local count = (ed.player.stage_limit or {})[s] or 0
  btn_back:runAction(tolua.cast(action:copy():autorelease(), "CCAction"))
  label_back:runAction(tolua.cast(action:copy():autorelease(), "CCAction"))
  if ed.battleshare.showShare() then
    btn_share:runAction(tolua.cast(action:copy():autorelease(), "CCAction"))
    label_share:runAction(tolua.cast(action:copy():autorelease(), "CCAction"))
  end
  if ed.stageType(stage) == "act" then
    ed.record:refreshCommonRecord("FarmActStage", 1)
  end
end

function commonBattleWin:playLootAnim()
  local dt = 0
  if #(self.lootui or {}) == 0 then
    self:playButtonAnim()
  end
  for i = 1, #self.lootui do
    local icon = self.lootui[i].icon
    local array = CCArray:create()
    local delay = CCDelayTime:create(dt + loot_show_gap * (i - 1))
    local func
    if i == #self.lootui then
      func = CCCallFunc:create(function()
        self:playButtonAnim()
        if self.param.playerInfo.oriLevel < self.param.playerInfo.level then
          ed.funOpenMgr.getInstance():openLevelUpWindow(self.param.playerInfo.level)
        else
          FireEvent(ed.guide.eventNames.BATTLE_RESULT)
        end
      end)
    else
      func = CCCallFunc:create(function()
      end)
    end
    local action = CCScaleTo:create(0.2, 0.88)
    action = CCEaseElasticOut:create(action)
    array:addObject(delay)
    array:addObject(func)
    array:addObject(action)
    local sequence = CCSequence:create(array)
    icon:runAction(sequence)
  end
end

function commonBattleWin:doClickReplay()
end

function commonBattleWin:initTimer()
  if self.param.mode == "real_arena" then
    self.isReportRoundReset = false
    self:listenTimer(Timer:Once(10, "countDown"), function()
      self.isReportRoundReset = true
      FireEvent("ReportRoundReset")
    end)
  end
end

function commonBattleWin:onClickBtnBack()
  if self.param.mode == "real_arena" then
    if self.isReportRoundReset then
      base.destroy(self)
      ed.popScene()
    else
      self.isReportRoundReset = true
      FireEvent("ReportRoundReset")
      local real_arena_data = self.param.real_arena_data
      if real_arena_data and real_arena_data.next_round ~= 0 then
        ed.showToast(T("\231\173\137\229\190\133\229\175\185\230\137\139\231\161\174\232\174\164"))
      end
    end
  else
    base.destroy(self)
    ed.popScene()
    FireEvent("closeCommonBattleWin")
    ListenTimer(Timer:Once(0.5), function()
      FireEvent("WinBackToSelect", self.param.stage_id)
    end)
  end
end

function commonBattleWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:onClickBtnBack()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    lsr:report("showBattleCount")
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "common", true)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_replay", function()
    self:doClickReplay()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_share", function()
    lsr:report("clickMenu")
    ed.battleshare.create()
  end, {pressScale = 0.9})
end
