local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.rogueBattlePrepare = class
local lsr = ed.ui.battlepreparelsr.create()
class.MODE_PREPARE = "prepare"
class.MODE_FIGHT = "fight"
class.MODE_ADD_HERO = "add_hero"
ed.UITool.registViewOpenFunc("rogueBattlePrepare", function(param)
  local scene = ed.ui.rogueBattlePrepare.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("rogueBattlePrepare")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.mode = param.mode or self.MODE_PREPARE
  self.chapterId = param.chapterId
  self.difficulty = param.difficulty
  self.destinyId = param.destinyId
  self.stageId = param.stageId
  self.crisisGroupId = param.crisisGroupId
  self.crisisDiff = param.crisisDiff
  self.rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  self.curChapter = self.rogueLikeMgr:getCurChapter()
  self.rogueChapterTB = ed.getDataTable("RogueChapter")
  self.myHeroList = {}
  self.averageGs = 0
  self.recommendGs = 0
  self.techGs = 0
  if self.mode == self.MODE_PREPARE then
    self.selectLimitAmount = self.rogueChapterTB[self.chapterId][self.difficulty]["Initial Hero Amount"]
  elseif self.mode == self.MODE_ADD_HERO then
    self.selectLimitAmount = param.selectHeroAmount or 0
  else
    self.selectLimitAmount = 5
  end
  if self.curChapter._chapter_id == self.chapterId then
    self.crisisGroupId = self.rogueChapterTB[self.chapterId][self.curChapter._difficulty]["Crisis Group"]
    self.crisisDiff = self.curChapter._crisis
  end
  self.selectHeroList = {}
  self.selectFilterType = "all"
  self.filterBtnTypeList = {
    "all",
    "front",
    "middle",
    "back"
  }
  self.teamHeroIcon = {}
  self.enemyWave = 1
  self.charmSelectedIdList = {}
  self.charmAvailableList = {}
  self.curCharmWeightVal = 0
  self.maxCharmWeightVal = 0
  self:initData()
  self:initView()
  self:addEventListener()
  self:addTouchEvent()
end

function class:fixTeamData(heroIdList)
  local newHeroIdList = {}
  for index, heroId in ipairs(heroIdList) do
    local hero = ed.player:getHero(heroId)
    if hero then
      if self.mode == self.MODE_PREPARE then
        table.insert(newHeroIdList, heroId)
      elseif self.curChapter then
        local rogueHeroInfo = self.curChapter._heroes
        for _, heroInfo in ipairs(rogueHeroInfo or {}) do
          if heroInfo._hp_perc > 0 and heroId == heroInfo._heroid then
            table.insert(newHeroIdList, heroId)
          end
        end
      else
        table.insert(newHeroIdList, heroId)
      end
    end
  end
  return newHeroIdList
end

function class:getKey()
  local key
  if self.mode == self.MODE_PREPARE then
    key = "roguePrepare" .. self.chapterId
  elseif self.mode == self.MODE_FIGHT then
    key = "rogueFight" .. self.chapterId
  end
  return key
end

function class:getTeamData()
  local key = self:getKey()
  if not key then
    return
  end
  local data = ed.getTeamData(key)
  data = self:fixTeamData(data)
  for index, heroId in ipairs(data) do
    local hero = ed.player:getHero(heroId)
    self.selectHeroList[heroId] = hero
    if EDEngineVersion() >= 4 then
      ed.asyncload.preloadFcaByUnitID(heroId)
    end
  end
end

function class:setTeamData()
  local heroIdList = {}
  for heroId, hero in pairs(self.selectHeroList) do
    table.insert(heroIdList, heroId)
  end
  local key = self:getKey()
  if not key then
    return
  end
  heroIdList = self:fixTeamData(heroIdList)
  ed.setTeamData(key, heroIdList)
end

function class:initData()
  if self.mode == self.MODE_PREPARE then
    self.all, self.front, self.middle, self.back = ed.readhero.classify("real_arena", "position")
  elseif self.mode == self.MODE_FIGHT then
    local all = {}
    local curChapter = self.rogueLikeMgr:getCurChapter()
    for _, rogueHeroInfo in ipairs(curChapter._heroes or {}) do
      local heroId = rogueHeroInfo._heroid
      table.insert(all, ed.player:getHero(heroId))
    end
    self.all, self.front, self.middle, self.back = ed.readhero.classifyByPos(all)
  elseif self.mode == self.MODE_ADD_HERO then
    local all, front, middle, back = ed.readhero.classify("real_arena", "position")
    self.all = self:filterCurChapterHero(all)
    self.front = self:filterCurChapterHero(front)
    self.middle = self:filterCurChapterHero(middle)
    self.back = self:filterCurChapterHero(back)
  end
  self:sortHero(self.all)
  self:sortHero(self.front)
  self:sortHero(self.middle)
  self:sortHero(self.back)
  self.myHeroList = self.all
  self:getTeamData()
  self:refreshKarlElementByTeam()
end

function class:sortHero(heros)
  table.sort(heros, ed.cmpSort({
    {key = "_level", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_stars", reverse = true},
    {key = "_tid"}
  }))
end

function class:filterCurChapterHero(heroList)
  local newList = {}
  for index, hero in ipairs(heroList or {}) do
    local curHero = self.rogueLikeMgr:getRogueHeroInfo(hero._tid)
    if not curHero then
      table.insert(newList, hero)
    end
  end
  return newList
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.rogueBattlePrepare)
  self.mainLayer:addChild(container)
  self.ui = ui
  self.ui.team_right_arrow:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
  self.ui.team_left_arrow:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
  self.ui.revelation_light:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1, 100), CCFadeTo:create(1, 255))))
  self:setBackButton()
  self:adaptUI()
  self:initEffect()
  self:initLabels()
  self:initEnemyHero()
  self:initHeroTableView()
  self:initTeamHeroDragList()
  self:orderTeam()
  self:refreshFilterBtn()
  self:refreshStageInfo()
  self:refreshSelectAmount()
  self:refreshViewVisible()
  self:initLegendEquip()
  if self.ui.btn_charm:isVisible() then
    ed.rogueLikeNet.sendQueryCharm(self.chapterId)
  end
  ed.rogueGuide.getInstance():registerGuide("rogueBattlePrepareFull", self.ui.revelation_bg)
  ed.rogueGuide.getInstance():registerGuide("rogueBattlePrepare", self.ui.revelation_bg)
end

function class:adaptUI()
  local diffWidth = ed.display.winSize.width - 960
  local diffHeight = ed.display.winSize.height - 540
  local oldLeftBgSize = self.ui.image_left_bg:getContentSize()
  local newLeftBgSize = CCSizeMake(oldLeftBgSize.width + diffWidth * 0.8, oldLeftBgSize.height + diffHeight * 0.8)
  self.ui.image_left_bg:setContentSize(newLeftBgSize)
  self.ui.image_frame:setContentSize(newLeftBgSize)
  local oldBgRightSize = self.ui.image_bg_right:getContentSize()
  local newBgRightSize = CCSizeMake(oldBgRightSize.width, newLeftBgSize.height)
  self.ui.image_bg_right:setContentSize(newBgRightSize)
  self.ui.bgRig2:setPositionY(self.ui.bgRig2:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.line:setPositionY(self.ui.line:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.label_stage_name:setPositionY(self.ui.label_stage_name:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.line2:setPositionY(self.ui.line2:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.label_stage_diff:setPositionY(self.ui.label_stage_diff:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.panel_desc:setPositionY(self.ui.panel_desc:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.revelation_bg:setPositionY(self.ui.revelation_bg:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.revelation_name_bg:setPositionY(self.ui.revelation_name_bg:getPositionY() + newBgRightSize.height - oldBgRightSize.height)
  self.ui.label_suggest_tips:limitWidthByScale(150)
  self.ui.label_average_tips:limitWidthByScale(150)
  ed.layout.centerInParent(self.ui.image_frame)
  ed.layout.relateLayout(self.ui.image_left_bg, self.ui.image_bg_right, {
    right = newLeftBgSize.width / 2
  })
  ed.layout.relateLayout(self.ui.image_left_bg, self.ui.panel_left_btn, {
    left = newLeftBgSize.width / 2 + 70,
    top = -340
  })
  ed.layout.relateLayout(self.ui.image_left_bg, self.ui.image_enemy_heros_bg, {
    top = newLeftBgSize.height / 2 - 140,
    left = self.ui.image_enemy_heros_bg:getContentSize().width / 2
  })
  ed.layout.relateLayout(self.ui.image_left_bg, self.ui.image_title_bg, {
    top = newLeftBgSize.height / 2 - self.ui.image_title_bg:getContentSize().height - 5
  })
  self.ui.image_enemy_heros_bg:setPositionX(self.ui.image_enemy_heros_bg:getPositionX() - (newLeftBgSize.width - oldLeftBgSize.width) / 2)
  self.ui.image_enemy_heros_bg:setContentSize(CCSizeMake(newLeftBgSize.width - 10, 70))
  ed.layout.centerXInParent(self.ui.eneTeamItem)
  ed.layout.centerXInParent(self.ui.image_title_bg)
  local charmBagPanelSize = self.ui.panel_charm_bag:getContentSize()
  local oldCharmBagPanelWidth = charmBagPanelSize.width
  charmBagPanelSize.width = newLeftBgSize.width - 10
  self.ui.panel_charm_bag:setContentSize(charmBagPanelSize)
  ed.layout.relateLayout(self.ui.image_left_bg, self.ui.panel_charm_bag, {
    top = newLeftBgSize.height / 2 - charmBagPanelSize.height - charmBagPanelSize.height,
    left = charmBagPanelSize.width * 0.5
  })
  local charmBagImgSize = self.ui.image_charm_bag:getContentSize()
  charmBagImgSize.width = charmBagPanelSize.width
  self.ui.image_charm_bag:setContentSize(charmBagImgSize)
  ed.layout.centerXInParent(self.ui.image_charm_bag)
  local charmSelectedPanelSize = self.ui.panel_charm_selected:getContentSize()
  charmSelectedPanelSize.width = charmSelectedPanelSize.width + (charmBagPanelSize.width - oldCharmBagPanelWidth)
  self.ui.panel_charm_selected:setContentSize(charmSelectedPanelSize)
  self.ui.label_charm_bag_tip:setPositionX(self.ui.label_charm_bag_tip:getPositionX() + (charmBagPanelSize.width - oldCharmBagPanelWidth) * 0.5)
  local charmPanelSize = self.ui.panel_charm_list:getContentSize()
  charmPanelSize.width = newLeftBgSize.width - 10
  charmPanelSize.height = charmPanelSize.height + (newLeftBgSize.height - oldLeftBgSize.height)
  self.ui.panel_charm_list:setContentSize(charmPanelSize)
  ed.layout.centerXInParent(self.ui.panel_charm_list)
  local oldBtnFilterSize = self.ui.image_btn_filter_bg:getContentSize()
  local newBtnFilterSize = CCSizeMake(newLeftBgSize.width - 10, oldBtnFilterSize.height)
  self.ui.image_btn_filter_bg:setContentSize(newBtnFilterSize)
  self.ui.butts_list:setPositionX(self.ui.butts_list:getPositionX() + (newBtnFilterSize.width - oldBtnFilterSize.width) / 2)
  self.ui.lin_L:setPositionX(self.ui.lin_L:getPositionX() + (newBtnFilterSize.width - oldBtnFilterSize.width) / 2)
  self.ui.lin_R:setPositionX(self.ui.lin_R:getPositionX() + (newBtnFilterSize.width - oldBtnFilterSize.width) / 2)
  self.ui.layer_my_teams:setContentSize(CCSizeMake(newLeftBgSize.width, 140))
  self.ui.myTeam9Img_2:setContentSize(CCSizeMake(newLeftBgSize.width / 2, 15.5))
  self.ui.myTeam9Img_3:setContentSize(CCSizeMake(newLeftBgSize.width / 2, 40))
  self.ui.myTeam9Img_3:setPositionX(newLeftBgSize.width - 10)
  self.ui.myTeam9Img_4:setContentSize(CCSizeMake(newLeftBgSize.width, 61))
  ed.layout.centerXInParent(self.ui.myTeam9Img_4)
  local oldPanelHeroSize = self.ui.panel_heros_items:getContentSize()
  local panelHeroWidth = newLeftBgSize.width - 23
  local panelHeroHeight = oldPanelHeroSize.height + (newLeftBgSize.height - oldLeftBgSize.height)
  if self.mode == self.MODE_PREPARE or self.mode == self.MODE_ADD_HERO then
    panelHeroHeight = panelHeroHeight + 35
  end
  self.ui.panel_heros_items:setContentSize(CCSizeMake(panelHeroWidth, panelHeroHeight))
  self.ui.panel_my_hero_list:setContentSize(CCSizeMake(newLeftBgSize.width - 23, 99.5))
  self.ui.team_right_arrow:setPositionX(self.ui.team_right_arrow:getPositionX() + (newLeftBgSize.width - oldLeftBgSize.width))
  if self.mode == self.MODE_PREPARE then
    self.ui.image_enemy_heros_bg:setVisible(false)
    self.ui.image_title_bg:setVisible(true)
    local bookTableItem = ed.getDataTable("RogueBook")[self.chapterId]
    if nil ~= next(bookTableItem["Charm List"] or {}) then
      self.ui.btn_charm:setVisible(true)
    else
      self.ui.btn_charm:setVisible(false)
    end
    ed.setLabelString(self.ui.label_title_tips, string.format(T("\232\175\183\233\128\137\230\139\169\232\135\179\229\164\154%s\229\144\141\232\139\177\233\155\132\229\135\186\229\190\129"), self.selectLimitAmount))
  elseif self.mode == self.MODE_FIGHT then
    self.ui.image_enemy_heros_bg:setVisible(true)
    self.ui.image_title_bg:setVisible(false)
    self.ui.btn_charm:setVisible(false)
  elseif self.mode == self.MODE_ADD_HERO then
    self.ui.image_enemy_heros_bg:setVisible(false)
    self.ui.image_title_bg:setVisible(true)
    self.ui.btn_charm:setVisible(false)
    ed.setLabelString(self.ui.label_title_tips, string.format(T("\232\175\183\233\128\137\230\139\169%s\229\144\141\232\139\177\233\155\132\229\138\160\229\133\165\233\152\159\228\188\141"), self.selectLimitAmount))
  end
  ed.layout.horizontalSortNode({
    self.ui.label_title_tips,
    self.ui.label_select_amount
  }, {0}, self.ui.image_title_bg:getContentSize().width * 0.5)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title_tips, ed.toccc3(3085579), 1.5)
  ed.setLabelStroke(self.ui.label_select_amount, ed.toccc3(3085579), 1.5)
  ed.setLabelStroke(self.ui.label_revelation_name, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_suggest_tips, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_average_tips, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_suggest_gs, ed.toccc3(7813139), 1)
  ed.setLabelStroke(self.ui.label_stage_diff, ed.toccc3(5780500), 1)
  ed.setLabelStroke(self.ui.label_all, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_front, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_middle, ed.toccc3(0), 1)
  ed.setLabelStroke(self.ui.label_back, ed.toccc3(0), 1)
  ed.setLabelFontName(self.ui.label_charm_bag_tip, ed.fontBold)
end

function class:initEffect()
end

function class:initEnemyHero()
  if not self.stageId then
    return
  end
  local curChapter = self.rogueLikeMgr:getCurChapter()
  local chapterId = curChapter._chapter_id
  if not chapterId then
    return
  end
  local chapterDiff = curChapter._difficulty
  local rogueWave = curChapter._cur_wave
  local stageInfo = ed.lookupDataTable("RogueStage", nil, self.stageId)
  local rogueChapterId = stageInfo["RogueChapter ID"]
  if rogueChapterId == 999 then
    rogueChapterId = chapterId
  end
  local rogueDiffCfg = ed.getDataTable("RogueDiff")[rogueChapterId]
  local stageType = stageInfo["Stage Type"]
  local levelBonus
  if stageType == "NormalBattle" then
    levelBonus = rogueDiffCfg["Normal Level"] + rogueDiffCfg["Normal Diff Step"] * (chapterDiff - 1)
  elseif stageType == "EliteBattle" then
    levelBonus = rogueDiffCfg["Elite Level"] + rogueDiffCfg["Elite Diff Step"] * (chapterDiff - 1)
  elseif stageType == "ExEliteBattle" then
    levelBonus = rogueDiffCfg["ExElite Level"] + rogueDiffCfg["ExElite Diff Step"] * (chapterDiff - 1)
  elseif stageType == "BossBattle" then
    levelBonus = rogueDiffCfg["Boss Level"] + rogueDiffCfg["Boss Diff Step"] * (chapterDiff - 1)
  end
  self.rogueLevelBonusCfg = ed.getDataTable("RogueLevelBonus")[levelBonus] or {}
  self.rogueWaveBonusCfg = ed.getDataTable("RogueWaveBonus")[rogueWave] or {}
  local rogueStageCfg = ed.getDataTable("RogueStage")[self.stageId]
  local waves = rogueStageCfg.Waves
  local waveHeroList = {}
  for wave = 1, waves do
    local rogueBattleCfg = ed.getDataTable("RogueBattle")[self.stageId][wave]
    local enemyHeroList = {}
    for index = 1, 5 do
      local monsterId = rogueBattleCfg[string.format("Monster %s ID", index)]
      if monsterId and 0 < monsterId then
        local stars = self.rogueLevelBonusCfg.Stars
        local level = self.rogueLevelBonusCfg.Level + self.rogueWaveBonusCfg.Level
        local rank = ed.heroLevel2Rank(level)
        local shardId = rogueBattleCfg["Shard ID" .. index]
        local shardLevel = rogueBattleCfg["Shard Level" .. index]
        local shard
        if 0 < shardId then
          shard = {_id = shardId, _level = shardLevel}
        end
        table.insert(enemyHeroList, {
          _tid = monsterId,
          _level = level,
          _rank = rank,
          _stars = stars,
          _shard = shard
        })
      end
    end
    ed.SortHeroesByMaxRange(enemyHeroList)
    table.insert(waveHeroList, enemyHeroList)
  end
  self.waveHeroList = waveHeroList
  self:refreshEnemyHero()
end

function class:refreshEnemyHero()
  local heroList = self.waveHeroList[self.enemyWave]
  for index = 1, 5 do
    self.ui["oppo_member_bg_" .. index]:removeAllChildrenWithCleanup(true)
    local hero = heroList[index]
    if hero then
      local hero_icon = ed.readhero.createIcon({
        id = hero._tid,
        level = hero._level,
        rank = hero._rank,
        stars = hero._stars,
        shard = hero._shard,
        isShowLegendEquip = ed.openLegendEquip()
      })
      self.ui["oppo_member_bg_" .. index]:removeAllChildrenWithCleanup(true)
      self.ui["oppo_member_bg_" .. index]:addChild(hero_icon.icon)
      hero_icon.icon:setScale(0.7)
      ed.layout.centerInParent(hero_icon.icon)
    end
  end
  self.ui.battlePrepare_fx_L_1:setVisible(self.enemyWave > 1)
  self.ui.battlePrepare_fx_R_1:setVisible(self.enemyWave < #self.waveHeroList)
  ed.setLabelString(self.ui.enemyTeamTit, string.format(T("\233\152\181\229\174\185%s/%s"), self.enemyWave, #self.waveHeroList))
end

function class:getHeroIconSize()
  return CCSizeMake(90, 90)
end

function class:initHeroTableView()
  local panelSize = self.ui.panel_heros_items:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.myHeroList
    end,
    cellSizeFromIndex = function(index)
      return self:getHeroIconSize()
    end,
    createCell = function(index)
      local hero = self.myHeroList[index]
      local node, heroIcon = self:createHeroItem(hero)
      return node, {heroIcon = heroIcon, hero = hero}
    end,
    syncCell = function(cell, index)
      local hero = self.myHeroList[index]
      local node, heroIcon = self:createHeroItem(hero)
      return node, {heroIcon = heroIcon, hero = hero}
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      local heroIcon = data.heroIcon
      heroIcon.icon:setScale(0.95)
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      local heroIcon = data.heroIcon
      heroIcon.icon:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local heroIcon = data.heroIcon
      local hero = data.hero
      if self.selectHeroList[hero._tid] then
        local result = self:deleteTeamHero(hero)
        if result then
          heroIcon:deleteSelectTag()
          self:refreshSelectAmount()
        end
      else
        local result = self:addTeamHero(hero)
        if result then
          heroIcon:showSelectTag()
          self:refreshSelectAmount()
        end
      end
      self:refreshTableViewKarlElement()
    end
  }
  local iconSize = self:getHeroIconSize()
  local colNum = math.floor(panelSize.width / iconSize.width)
  local offsetX = panelSize.width - colNum * iconSize.width
  self.ui.panel_heros_items:setPositionX(self.ui.panel_heros_items:getPositionX() + offsetX / 2)
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_heros_items,
    cliprect = CCRectMake(0, 0, panelSize.width, panelSize.height),
    colNum = colNum,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true,
    bar = {
      bglen = panelSize.height,
      bgpos = ccp(-offsetX / 2, panelSize.height / 2)
    }
  }
  self.heroTableView = Tableview.create(param)
  self:refreshTableView()
end

function class:refreshTableViewKarlElement()
  local usedCells = self.heroTableView:getUsedCell()
  if 0 < #usedCells then
    for i, v in ipairs(usedCells) do
      if nil ~= v and nil ~= v.data.heroIcon then
        v.data.heroIcon:showKarlElement(self.showElement)
      end
    end
  end
end

function class:initLegendEquip()
  if not ed.openLegendEquip() then
    self.ui.switch_equip_bg:setVisible(false)
  end
  local constAdaptScale = 1.8
  local currentScale = ed.display.winSize.width / ed.display.winSize.height
  if constAdaptScale >= currentScale then
    self.ui.switch_equip_bg:setScale(0.85)
    self.ui.switch_equip_bg:setPositionX(62)
  else
    self.ui.switch_equip_bg:setPositionX(75)
  end
  self.ui.close_equip_bg:setVisible(not ed.off_legendEquipOp)
  self.ui.label_equip:setVisible(not ed.off_legendEquipOp)
  self.ui.btn_equip:setPositionX(ed.off_legendEquipOp and 17 or 59)
  self.ui.label_equip_enable:setVisible(ed.off_legendEquipOp)
  if not ed.off_legendEquipOp then
    self.ui.label_equip:setPositionX(17)
    self.ui.btn_equip:setPositionX(59)
  end
  ed.setString(self.ui.label_equip_enable, "\228\184\141\229\177\149\231\164\186")
  ed.setLabelColor(self.ui.label_equip_des, ed.toccc3(16771194))
  ed.setLabelStroke(self.ui.label_equip_des, ed.toccc3(1973790), 1.5)
  ed.setLabelColor(self.ui.label_equip, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip, ed.toccc3(65793), 1.5)
  ed.setLabelColor(self.ui.label_equip_enable, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip_enable, ed.toccc3(65793), 1.5)
end

function class:switchLegendEquipMenu(open)
  self.ui.close_equip_bg:setVisible(not open)
  self.ui.label_equip:setVisible(not open)
  self.ui.label_equip_enable:setVisible(open)
  self.ui.btn_equip:setPositionX(open and 17 or 59)
  self:refreshLegendEquip()
end

function class:refreshLegendEquip()
  local usedCells = self.heroTableView:getUsedCell()
  if 0 < #usedCells then
    for i, v in ipairs(usedCells) do
      if nil ~= v and nil ~= v.data.heroIcon then
        v.data.heroIcon:showLegendEquip(ed.off_legendEquipOp)
      end
    end
  end
end

function class:createHeroItem(hero)
  local heroIcon = self:createHeroIcon(hero)
  if self.selectHeroList[hero._tid] then
    heroIcon:showSelectTag()
  else
    heroIcon:deleteSelectTag()
  end
  local bg = CCSprite:create()
  bg:setContentSize(self:getHeroIconSize())
  bg:addChild(heroIcon.icon)
  heroIcon.icon:setPosition(ccp(45, 45))
  heroIcon:showKarlElement(self.showElement)
  return bg, heroIcon
end

function class:deleteTeamHero(hero)
  self.selectHeroList[hero._tid] = nil
  self:orderTeam()
  return true
end

function class:addTeamHero(hero)
  local amount = 0
  for _, _ in pairs(self.selectHeroList) do
    amount = amount + 1
  end
  if amount >= self.selectLimitAmount then
    self:playTeamMemberEffect(1)
    return false
  end
  if self.mode == self.MODE_FIGHT then
    local rogueHeroInfo = self.curChapter._heroes
    for _, heroInfo in ipairs(rogueHeroInfo or {}) do
      if 0 >= heroInfo._hp_perc and hero._tid == heroInfo._heroid then
        return
      end
    end
  end
  self.selectHeroList[hero._tid] = hero
  lsr:report("clickAddHero", {
    hid = hero._tid,
    fashion_id = hero._fashion
  })
  if EDEngineVersion() >= 4 then
    ed.asyncload.preloadFcaByUnitID(hero._tid)
  end
  self:orderTeam()
  return true
end

function class:initTeamHeroDragList()
  local panelSize = self.ui.panel_my_hero_list:getContentSize()
  self.teamDragList = ed.UITool.createDraglist(self.ui.panel_my_hero_list, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    doScroll = function()
      self:refreshArrow()
    end
  })
  local totalWidth, gapX = 15, 12
  self.heroSlotPanelList = {}
  for index = 1, self.selectLimitAmount do
    local teamPanel = self:createTeamItem(index)
    local size = teamPanel:getContentSize()
    self.teamDragList:addItem(teamPanel)
    local pos = ccp(totalWidth + size.width / 2, size.height / 2)
    teamPanel:setPosition(pos)
    self.heroSlotPanelList[index] = teamPanel
    totalWidth = totalWidth + size.width + gapX
  end
  self.teamDragList:initListWidth(totalWidth)
  if totalWidth < panelSize.width then
    self.ui.panel_my_hero_list:setPositionX(self.ui.panel_my_hero_list:getPositionX() + (panelSize.width - totalWidth) / 2)
    self.ui.team_left_arrow:setVisible(false)
    self.ui.team_right_arrow:setVisible(false)
  else
    self.ui.team_left_arrow:setVisible(true)
    self.ui.team_right_arrow:setVisible(true)
    self:refreshArrow()
  end
end

function class:refreshArrow()
  local panelSize = self.ui.panel_my_hero_list:getContentSize()
  local listX, listY = self.teamDragList:getListPos()
  local listWidth = self.teamDragList.listWidth
  if -20 < listX then
    self.ui.team_left_arrow:setVisible(false)
  else
    self.ui.team_left_arrow:setVisible(true)
  end
  if listX < panelSize.width - listWidth + 20 then
    self.ui.team_right_arrow:setVisible(false)
  else
    self.ui.team_right_arrow:setVisible(true)
  end
end

function class:getPressInHandler()
  local function handler(x, y)
    for index, heroIcon in ipairs(self.teamHeroIcon) do
      if ed.containsPoint(heroIcon, x, y) then
        heroIcon:setScale(0.95)
        
        return heroIcon
      end
    end
  end
  
  return handler
end

function class:getClickInHandler()
  local function handler(x, y, heroIcon)
    local hero = heroIcon.hero
    
    local result = self:deleteTeamHero(hero)
    if result then
      self:refreshTableView(true)
      self:refreshSelectAmount()
    end
  end
  
  return handler
end

function class:getCancelPressInHandler()
  local function handler(x, y, heroIcon)
    heroIcon:setScale(1)
  end
  
  return handler
end

function class:createTeamItem(index)
  local bg = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_battle_hero_hc.png")
  local light = ed.createSprite("UI/alpha/1080P/battle/herobucket-halo.png")
  bg:addChild(light)
  light:setScale(1.5)
  light:setOpacity(255)
  light:setPosition(ccp(48, 50))
  self.ui["team_light_" .. index] = light
  return bg
end

function class:refreshFilterBtn()
  for _, btnType in ipairs(self.filterBtnTypeList) do
    local btnSelect = self.ui[string.format("btn_%s_select", btnType)]
    if btnSelect then
      btnSelect:setVisible(btnType == self.selectFilterType)
    end
  end
end

function class:playTeamMemberEffect(index)
  index = index or 0
  local light = self.ui["team_light_" .. index]
  if light then
  end
end

function class:refreshStageInfo()
  local destinyCfg = ed.getDataTable("RogueDestiny")[self.destinyId]
  local iconPath = string.format("UI/alpha/1080P/rogue/bless/%s_simple.png", destinyCfg.Icon)
  ed.setTexture(self.ui.revelation_icon, iconPath)
  local clipSize = self.ui.revelation_bar_clip:getContentSize()
  local energy = self.rogueLikeMgr:getDestinyEnergy()
  local revelationEnable, amount = self.rogueLikeMgr:getRevelationEnable(self.destinyId)
  if revelationEnable then
    self.ui.revelation_bar_clip:setVisible(true)
    self.ui.revelation_lock_mask:setVisible(false)
    self.ui.revelation_icon:setOpacity(255)
    local percent = energy / 100
    local bgSize = self.ui.revelation_bg:getContentSize()
    self.ui.revelation_bar_clip:setClipRect(CCRectMake(0, 0, clipSize.width, clipSize.height * percent))
    local eff_charging = ed.createFcaNode("eff_UI_rogue_echo_charging")
    if 0 < percent then
      local clippingNode = ed.createClippingNodeOnly("UI/alpha/1080P/rogue/instance/instance_battle_echo_shade2.png")
      clippingNode:addChild(eff_charging)
      self.ui.revelation_bg:addChild(clippingNode, 1)
      clippingNode:setPosition(ccp(bgSize.width / 2 - 1, bgSize.height / 2))
      self:addFca(eff_charging)
      eff_charging:setAction("Loop")
      eff_charging:setLoop(true)
      eff_charging:setPositionY(-67.5 + 135 * percent)
    end
    if 1 <= percent then
      local eff_ready = ed.createFcaNode("eff_UI_rogue_echo_ready")
      eff_ready:setAction("Loop")
      eff_ready:setLoop(true)
      self:addFca(eff_ready)
      self.ui.revelation_bg:addChild(eff_ready, 1)
      eff_ready:setPosition(ccp(bgSize.width / 2 - 1.5, bgSize.height / 2))
    end
  else
    self.ui.revelation_bar_clip:setVisible(false)
    self.ui.revelation_lock_mask:setVisible(true)
    self.ui.revelation_icon:setOpacity(102)
    local bgSize = self.ui.revelation_name_bg:getContentSize()
    local lockTipsAutoText = ed.ui.autoText.new()
    lockTipsAutoText:initParam({
      context = string.format(T("\232\142\183\229\190\151<lable color=ccc3(255,209,130)>%s/3</lable>\228\184\170%s\231\154\132\231\165\157\231\166\143\230\157\165\230\191\128\230\180\187\229\144\175\231\164\186"), amount, destinyCfg["Display Name"]),
      color = ed.toccc3(16776423),
      strokeColor = ed.toccc3(2565412),
      strokeSize = 1,
      fontSize = 15,
      lineSpacing = 0,
      maxWidth = bgSize.width,
      maxHeight = 30
    })
    self.ui.revelation_name_bg:addChild(lockTipsAutoText.node)
    local tipWidth, tipHeight = lockTipsAutoText:getCurContentSize()
    lockTipsAutoText.node:setPosition(ccp((bgSize.width - tipWidth) * 0.5, -30 + tipHeight * 0.5 + lockTipsAutoText:getFirstLineHeight() * 0.5))
  end
  ed.setLabelString(self.ui.label_revelation_name, destinyCfg["Revelation Name"])
  local chapterCfg = self.rogueChapterTB[self.chapterId][self.difficulty]
  ed.setLabelString(self.ui.label_stage_name, chapterCfg.Name)
  local nameSize = self.ui.label_stage_name:getContentSize()
  local romanNum = ed.rogueLikeTool.createRomanNum(self.difficulty)
  self.ui.label_stage_diff:removeAllChildrenWithCleanup(true)
  self.ui.label_stage_diff:addChild(romanNum)
  local labelSize = self.ui.label_stage_diff:getContentSize()
  romanNum:setPosition(ccp(labelSize.width + romanNum:getContentSize().width / 2 + 3, labelSize.height / 2))
  self.ui.label_stage_name:setPositionX(self.ui.image_bg_right:getContentSize().width / 2 - (labelSize.width + romanNum:getContentSize().width) / 2 - 10)
  self.ui.line2:setPositionX(self.ui.label_stage_name:getPositionX() + nameSize.width / 2 + 5)
  self.ui.label_stage_diff:setPositionX(self.ui.line2:getPositionX() + labelSize.width / 2 + 5)
  local panelSize = self.ui.panel_desc:getContentSize()
  local descDragList = ed.UITool.createDraglist(self.ui.panel_desc, {
    bar = {
      bglen = panelSize.height,
      bgpos = ccp(panelSize.width + 3, panelSize.height / 2),
      bgres = "UI/alpha/1080P/rogue/bless/bless_bag_slide_bg.png",
      barres = "UI/alpha/1080P/rogue/bless/bless_bag_slide.png"
    }
  })
  local autoText = ed.ui.autoText.new()
  local context = ""
  if self.chapterId then
    context = chapterCfg["Buff Des"]
  end
  autoText:initParam({
    context = context,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(1588768),
    strokeSize = 1,
    fontSize = 15,
    maxWidth = panelSize.width
  })
  autoText.node:setPosition(ccp(0, panelSize.height - 7.5))
  descDragList:addItem(autoText.node)
  local textW, textH = autoText:getCurContentSize()
  descDragList:initListHeight(textH)
end

function class:getHeroIconById(heroId)
  for index, heroIcon in ipairs(self.teamHeroIcon) do
    if heroIcon.heroId == heroId then
      return heroIcon
    end
  end
end

function class:getHeroIconByIndex(index)
  return self.teamHeroIcon[index]
end

function class:createHeroIcon(hero)
  local heroIcon = ed.readhero.createIconByHero(hero, {
    isShowLegendEquip = ed.openLegendEquip()
  })
  if self.mode == self.MODE_FIGHT then
    for _, rogueHeroInfo in ipairs(self.curChapter._heroes or {}) do
      if hero._tid == rogueHeroInfo._heroid then
        heroIcon:addHpMpInfo(rogueHeroInfo._hp_perc, rogueHeroInfo._mp_perc)
        break
      end
    end
  end
  return heroIcon
end

function class:orderTeam()
  self.teamHeroIcon = {}
  for heroId, hero in pairs(self.selectHeroList) do
    local heroIcon = self:createHeroIcon(hero)
    local icon = heroIcon.icon
    table.insert(self.teamHeroIcon, icon)
    local maxRange = ed.readhero.getHeroMaxRange(heroId)
    icon.maxRange = maxRange
    icon.heroId = heroId
    icon.hero = hero
    icon.owner = heroIcon
  end
  table.sort(self.teamHeroIcon, ed.cmpSort({
    {key = "maxRange", reverse = true}
  }))
  if self.mode ~= self.MODE_FIGHT then
    for index = 1, self.selectLimitAmount do
      local panel = self.heroSlotPanelList[index]
      panel:removeAllChildrenWithCleanup(true)
      local icon = self.teamHeroIcon[index]
      if icon then
        panel:addChild(icon)
        panel.heroIcon = icon
        icon:setPosition(ccp(47.5, 57.5))
      end
    end
  else
    local iconIndex = #self.teamHeroIcon
    for index = self.selectLimitAmount, 1, -1 do
      local panel = self.heroSlotPanelList[index]
      panel:removeAllChildrenWithCleanup(true)
      local icon = self.teamHeroIcon[iconIndex]
      iconIndex = iconIndex - 1
      if icon then
        panel:addChild(icon)
        panel.heroIcon = icon
        icon:setPosition(ccp(47.5, 57.5))
      end
    end
  end
  self:refreshGs()
  self:refreshKarlElementByTeam()
  self:refreshKarlElement()
end

function class:refreshGs()
  local total = 0
  local heroAmount = 0
  for heroId, hero in pairs(self.selectHeroList) do
    total = total + hero._gs
    heroAmount = heroAmount + 1
  end
  ed.setLabelString(self.ui.gs, total)
  if self.mode == self.MODE_FIGHT then
    self.ui.suggest_bg:setVisible(false)
  else
    self.ui.suggest_bg:setVisible(true)
  end
  local averageGs = heroAmount == 0 and 0 or math.floor(total / heroAmount)
  local techGs = math.floor(self.rogueLikeMgr:getTechGs(self.chapterId))
  local chapterCfg = self.rogueChapterTB[self.chapterId][self.difficulty]
  local recommendGs = chapterCfg["Recommend GS"] or 0
  if self.crisisGroupId and 0 < self.crisisGroupId and self.crisisDiff and 0 < self.crisisDiff then
    recommendGs = ed.getDataTable("RogueCrisis")[self.crisisGroupId][self.crisisDiff]["Recommend GS"]
  end
  if 0 < techGs then
    ed.setLabelString(self.ui.label_average_gs, string.format("%d+%d", averageGs, techGs))
  else
    ed.setLabelString(self.ui.label_average_gs, averageGs)
  end
  ed.setLabelString(self.ui.label_suggest_gs, recommendGs)
  if recommendGs == averageGs + techGs then
    ed.setLabelColor(self.ui.label_average_gs, ed.toccc3(16772733))
    ed.setLabelStroke(self.ui.label_average_gs, ed.toccc3(7813139), 1)
  else
    ed.setLabelColor(self.ui.label_average_gs, recommendGs < averageGs + techGs and ed.toccc3(7405396) or ed.toccc3(16739436))
    ed.setLabelStroke(self.ui.label_average_gs, recommendGs < averageGs + techGs and ed.toccc3(1068292) or ed.toccc3(7813139), 1)
  end
  self.averageGs = averageGs
  self.recommendGs = recommendGs
  self.techGs = techGs
end

local karl_hero_tid = 53

function class:refreshKarlElementByTeam()
  local showState = false
  for heroId, hero in pairs(self.selectHeroList) do
    if hero._tid == karl_hero_tid then
      showState = true
    end
  end
  self.showElement = showState
end

function class:refreshKarlElement()
  for index, heroIcon in ipairs(self.teamHeroIcon) do
    if nil ~= heroIcon then
      heroIcon.owner:showKarlElement(self.showElement)
    end
  end
end

function class:refreshTableView(notResetPos)
  if notResetPos then
    local listX, listY = self.heroTableView:getListPos()
    self.heroTableView:reloadData()
    self.heroTableView:setListPos(ccp(listX, listY))
  else
    self.heroTableView:reloadData()
  end
end

function class:refreshSelectAmount()
  if self.mode == self.MODE_PREPARE then
    local selectAmount = 0
    for heroId, hero in pairs(self.selectHeroList) do
      selectAmount = selectAmount + 1
    end
    self.ui.label_select_amount:setVisible(true)
    ed.setLabelString(self.ui.label_select_amount, string.format(T("\239\188\136%s/%s\239\188\137"), selectAmount, self.selectLimitAmount))
  else
    self.ui.label_select_amount:setVisible(false)
  end
end

function class:onClickBtnFilter(type)
  if self.selectFilterType == type then
    return
  end
  self.selectFilterType = type
  self:refreshFilterBtn()
  self.myHeroList = self[type] or {}
  self:refreshTableView()
end

function class:onClickBtnFight()
  if self.isOverweightEffectPlaying then
    return
  end
  local heroIdList = {}
  local charmIdList = self.charmSelectedIdList
  for heroId, hero in pairs(self.selectHeroList) do
    table.insert(heroIdList, hero._tid)
  end
  local amount = #heroIdList
  
  local function callBack()
    self:onFightConfirmCallBack(heroIdList, charmIdList)
  end
  
  if self.averageGs + self.techGs < self.recommendGs and self.mode == self.MODE_PREPARE then
    local oldCallBack = callBack
    
    function callBack()
      local info = {
        text = T("\229\189\147\229\137\141\232\139\177\233\155\132\229\174\158\229\138\155\228\184\141\232\182\179\239\188\140\230\184\184\231\142\169\229\176\134\233\157\162\228\184\180\230\140\145\230\136\152\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"),
        rightHandler = oldCallBack
      }
      ed.showConfirmDialog(info)
    end
  end
  if self.ui.btn_charm:isVisible() and 0 == #self.charmSelectedIdList then
    local oldCallBack = callBack
    
    function callBack()
      local info = {
        text = T("\230\130\168\230\178\161\230\156\137\233\128\137\230\139\169\230\138\164\231\172\166\239\188\140\233\128\137\230\139\169\230\138\164\231\172\166\229\143\175\229\184\174\229\138\169\229\134\146\233\153\169\239\188\129"),
        rightText = T("\231\155\180\230\142\165\229\188\128\229\167\139"),
        rightHandler = oldCallBack,
        leftText = T("\229\142\187\233\128\137\230\139\169"),
        leftHandler = function()
          self:onClickBtnCharm()
        end
      }
      ed.showConfirmDialog(info)
    end
  end
  if amount <= 0 then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\232\139\177\233\155\132\229\135\186\230\136\152"))
    return
  elseif amount < self.selectLimitAmount then
    local autoText
    if self.mode == self.MODE_PREPARE then
      autoText = T("\228\189\160\231\154\132\229\135\186\230\136\152\233\152\159\228\188\141\228\184\141\232\182\179%d\228\186\186,\230\152\175\229\144\166\231\187\167\231\187\173?<br/><lable color=ccc3(184,71,63)>\230\184\184\231\142\169\230\149\133\228\186\139\230\151\182\239\188\140\229\143\170\232\131\189\228\187\142\229\135\186\229\190\129\232\139\177\233\155\132\228\184\173\233\128\137\230\139\169</lable>", self.selectLimitAmount)
    else
      autoText = T("\228\189\160\231\154\132\229\135\186\230\136\152\233\152\159\228\188\141\228\184\141\232\182\179%d\228\186\186,\230\152\175\229\144\166\231\187\167\231\187\173?", self.selectLimitAmount)
    end
    local info = {autoText = autoText, rightHandler = callBack}
    ed.showConfirmDialog(info)
  else
    callBack()
  end
end

function class:onFightConfirmCallBack(heroIdList, charmIdList)
  if self.mode == self.MODE_PREPARE then
    ed.rogueLikeNet.sendEnterChapter(self.chapterId, self.difficulty, self.crisisDiff, heroIdList, self.destinyId, charmIdList)
  elseif self.mode == self.MODE_FIGHT then
    local canBattle = self.rogueLikeMgr:getCanBattle()
    if not canBattle then
      ed.showToast(T("\233\135\141\232\175\149\230\172\161\230\149\176\228\184\141\232\182\179"))
      return
    end
    self.rogueLikeMgr:setBattleInfo({
      heroIdList = heroIdList,
      stageId = self.stageId
    })
    ed.rogueLikeNet.sendStartBattle(heroIdList)
  elseif self.mode == self.MODE_ADD_HERO then
    self.rogueLikeMgr:sendRogueChooseReward(heroIdList)
  end
  self:setTeamData()
end

function class:onClickBtnGo()
end

function class:onClickRevelation()
  local win = ed.ui.rogueRevelationDetailWindow.create({
    destinyId = self.destinyId
  })
  win:popWindow()
  ed.layout.relateLayout(self.ui.revelation_lock_mask, win.ui.image_bg, {
    left = self.ui.revelation_lock_mask:getContentSize().width / 2,
    top = win.ui.image_bg:getContentSize().height / 2
  })
  ed.rogueGuide.getInstance():endGuide("rogueBattlePrepareFull")
  ed.rogueGuide.getInstance():endGuide("rogueBattlePrepare")
end

function class:onClickBtnEnemy(change)
  self.enemyWave = self.enemyWave + change
  self.enemyWave = math.max(1, self.enemyWave)
  self.enemyWave = math.min(#self.waveHeroList, self.enemyWave)
  self:refreshEnemyHero()
end

function class:onClickBtnTeam(...)
  self.ui.btn_team_select:setVisible(true)
  self.ui.btn_charm_select:setVisible(false)
  self:refreshViewVisible()
end

function class:onClickBtnCharm(...)
  self.ui.btn_team_select:setVisible(false)
  self.ui.btn_charm_select:setVisible(true)
  self:refreshViewVisible()
  self:initCharmTableView()
end

function class:refreshViewVisible()
  local isTeam = self.ui.btn_team_select:isVisible()
  self.ui.image_btn_filter_bg:setVisible(isTeam)
  self.ui.panel_heros_items:setVisible(isTeam)
  self.ui.image_title_bg:setVisible(isTeam and (self.mode == self.MODE_PREPARE or self.mode == self.MODE_ADD_HERO))
  if nil ~= self.heroTableView then
    self.heroTableView:getDragList():setTouchEnabled(isTeam)
  end
  local isCharm = self.ui.btn_charm_select:isVisible()
  self.ui.panel_charm_bag:setVisible(isCharm)
  self.ui.panel_charm_list:setVisible(isCharm)
  if nil ~= self.charmTableView then
    self.charmTableView:getDragList():setTouchEnabled(isCharm)
  end
end

function class:addTouchEvent()
  for _, btnType in ipairs(self.filterBtnTypeList) do
    local btn = self.ui["btn_" .. btnType]
    local btnSelect = self.ui[string.format("btn_%s_select", btnType)]
    self:btRegisterButtonClick({
      button = btn,
      pressScale = 0.95,
      key = "btn_filter_" .. btnType,
      force = true,
      clickHandler = function()
        self:onClickBtnFilter(btnType)
      end,
      pressHandler = function()
        btnSelect:setVisible(true)
      end,
      cancelPressHandler = function()
        btnSelect:setVisible(false)
      end
    })
  end
  ed.UITool.registerBtn(self, "btn_fight", function()
    self:onClickBtnFight()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_go", function()
    self:onClickBtnGo()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "revelation_bg", function()
    self:onClickRevelation()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "battlePrepare_fx_L_1", function()
    self:onClickBtnEnemy(-1)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "battlePrepare_fx_R_1", function()
    self:onClickBtnEnemy(1)
  end, {pressScale = 0.95})
  self:btRegisterButtonClick({
    button = self.ui.btn_team,
    key = "btn_team",
    force = true,
    clickInterval = 0.3,
    priority = -1,
    pressHandler = function()
      local vis = self.ui.btn_team_select:isVisible()
      if vis then
        return
      end
      self.ui.btn_team_select:setVisible(true)
    end,
    cancelPressHandler = function(param, x, y)
      if ed.containsPoint(self.ui.btn_team_select, x, y) then
        self:onClickBtnTeam()
      else
        self.ui.btn_team_select:setVisible(false)
      end
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_charm,
    key = "btn_charm",
    force = true,
    clickInterval = 0.3,
    priority = -1,
    pressHandler = function()
      local vis = self.ui.btn_charm_select:isVisible()
      if vis then
        return
      end
      self.ui.btn_charm_select:setVisible(true)
    end,
    cancelPressHandler = function(param, x, y)
      if ed.containsPoint(self.ui.btn_charm_select, x, y) then
        self:onClickBtnCharm()
      else
        self.ui.btn_charm_select:setVisible(false)
      end
    end
  })
end

function class:addEventListener()
  self:listenEvent("rogueEnterChapter", function()
    ed.popScene()
  end)
  self:listenEvent("rogueChooseReward", function()
    ed.popScene()
  end)
  self:listenEvent("rogueQueryCharm", function(data)
    self:parseCharmData(data)
    if self.mode == self.MODE_PREPARE then
      self:initCharmTableView()
      self:refreshCharmBag(false)
    end
  end)
  self:registerOnEnterHandler("onEnter", function()
    local energy = self.rogueLikeMgr:getDestinyEnergy()
    if 100 <= energy then
      ed.rogueGuide.getInstance():startGuide("rogueBattlePrepareFull")
    else
      ed.rogueGuide.getInstance():startGuide("rogueBattlePrepare")
    end
  end)
  self:btRegisterButtonClick({
    button = self.ui.switch_equip_bg,
    key = "switch_equip_bg",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      ed.off_legendEquipOp = not ed.off_legendEquipOp
      ed.saveLegendEquip()
      self:switchLegendEquipMenu(ed.off_legendEquipOp)
    end
  })
end

function class:parseCharmData(data)
  self.maxCharmWeightVal = data._weight or 5
  self.charmAvailableList = ed.copyProto(data._charm_list or {})
  local tmpTab = {}
  for i = #self.charmAvailableList, 1, -1 do
    local v = self.charmAvailableList[i]
    if nil ~= v._exp then
      tmpTab[v._charm_id] = v
    else
      table.remove(self.charmAvailableList, i)
    end
  end
  local charmTable = ed.getDataTable("RogueCharm")
  local lastIdList = self.rogueLikeMgr:getCharmIdListFromBag(self.chapterId)
  local idList = {}
  local weightVal = 0
  for i, v in ipairs(lastIdList) do
    if nil == tmpTab[v] then
      print("========================", v, "\232\191\152\230\156\170\232\167\163\233\148\129========================")
    else
      local charmTableItem = charmTable[v]
      weightVal = weightVal + charmTableItem.Weight
      if weightVal > self.maxCharmWeightVal then
        weightVal = weightVal - charmTableItem.Weight
        print("========================", v, "\232\182\133\233\135\141\228\186\134========================")
      else
        table.insert(idList, v)
      end
    end
  end
  self.charmSelectedIdList = idList
  table.sort(self.charmAvailableList, function(a, b)
    return a._charm_id < b._charm_id
  end)
end

function class:getCharmItemSize()
  local panelSize = self.ui.panel_charm_list:getContentSize()
  return CCSizeMake(panelSize.width - 20, 110)
end

function class:createCharmItem(charmData)
  local panelSize = self.ui.panel_charm_list:getContentSize()
  local container, ui = ed.editorui(ed.uieditor.rogueBattlePrepareCharmItem)
  container:setContentSize(ui.bg:getContentSize())
  ed.setLabelStroke(ui.label_name, ed.toccc3(4267185), 1)
  ed.setLabelStroke(ui.label_weight, ed.toccc3(263719), 1)
  ui.heartImgArr = {}
  ui.heartSpaceArr = {}
  for i = 1, 999 do
    local img = ui["img_charm_heart_" .. i]
    if nil == img then
      break
    end
    table.insert(ui.heartImgArr, img)
    table.insert(ui.heartSpaceArr, 5)
  end
  local bgSize = ui.bg:getContentSize()
  bgSize.width = panelSize.width - 25
  ui.bg:setContentSize(bgSize)
  ui.bg:setPositionX(panelSize.width * 0.5)
  local selectedImgSize = ui.img_selected:getContentSize()
  selectedImgSize.width = bgSize.width + 20
  ui.img_selected:setContentSize(selectedImgSize)
  ui.img_selected:setPositionX(bgSize.width * 0.5)
  local desPanelSize = ui.panel_des:getContentSize()
  desPanelSize.width = bgSize.width - 168
  ui.panel_des:setContentSize(desPanelSize)
  if nil == ui.charmDesLabel then
    ui.charmDesLabel = ed.ui.autoText.new()
    ui.panel_des:addChild(ui.charmDesLabel.node)
  end
  self:refreshCharmItem(ui, charmData)
  return container, ui
end

function class:refreshCharmItem(ui, charmData)
  local charmTableItem = ed.getDataTable("RogueCharm")[charmData._charm_id]
  ed.setTexture(ui.img_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  ed.setLabelString(ui.label_name, charmTableItem["Charm Name"])
  ed.setLabelString(ui.label_weight, T("\233\135\141\233\135\143\239\188\154%s", charmTableItem.Weight))
  local starNum = self.rogueLikeMgr:getCharmStarNum(charmData._exp, charmTableItem)
  for i, v in ipairs(ui.heartImgArr) do
    v:setVisible(i <= starNum)
  end
  ed.layout.horizontalSortNode(ui.heartImgArr, ui.heartSpaceArr, ui.img_icon:getPositionX())
  local isSelected = false
  for i, v in ipairs(self.charmSelectedIdList) do
    if v == charmData._charm_id then
      isSelected = true
    end
  end
  ui.img_selected:setVisible(isSelected)
  local charmDesStr = charmTableItem["Description " .. starNum] or ""
  local desBgSize = ui.panel_des:getContentSize()
  ui.charmDesLabel:initParam({
    context = charmDesStr,
    fontSize = 15,
    color = ccc3(249, 249, 235),
    strokeColor = ed.toccc3(1973530),
    strokeSize = 1,
    maxWidth = desBgSize.width,
    isTripLastSpacing = true
  })
  local desWidth, desHeight = ui.charmDesLabel:getCurContentSize()
  local desPosY
  if desHeight > desBgSize.height then
    desPosY = (desBgSize.height + desHeight - ui.charmDesLabel:getFirstLineHeight()) * 0.5
  else
    desPosY = desBgSize.height - ui.charmDesLabel:getFirstLineHeight() * 0.5
  end
  ui.charmDesLabel.node:setPosition(ccp(0, desPosY))
end

function class:refreshCharmItemSelectedState(id)
  if nil ~= self.charmTableView then
    local isVisible = false
    for i, v in ipairs(self.charmSelectedIdList) do
      if v == id then
        isVisible = true
        break
      end
    end
    for index, cell in ipairs(self.charmTableView:getUsedCell() or {}) do
      local data = cell.data
      if data then
        local charmUI = data.ui
        local charmData = data.data
        if charmData._charm_id == id then
          charmUI.img_selected:setVisible(isVisible)
        end
      end
    end
  end
end

function class:initCharmTableView(...)
  if nil == self.charmTableView then
    local panelSize = self.ui.panel_charm_list:getContentSize()
    local delegate = {
      numberOfCells = function()
        return #self.charmAvailableList
      end,
      cellSizeFromIndex = function(index)
        return self:getCharmItemSize()
      end,
      createCell = function(index)
        local data = self.charmAvailableList[index]
        local container, ui = self:createCharmItem(data)
        return container, {ui = ui, data = data}
      end,
      syncCell = function(cell, index)
        local data = self.charmAvailableList[index]
        local container, ui = self:createCharmItem(data)
        return container, {ui = ui, data = data}
      end,
      doClickIn = function(cell, x, y)
        if self.isOverweightEffectPlaying then
          return
        end
        if not self.ui.panel_charm_list:isVisible() then
          return
        end
        local data = cell.data
        if nil == data then
          return
        end
        local ui = data.ui
        local charmData = data.data
        local existIndex = -1
        for i, v in ipairs(self.charmSelectedIdList) do
          if v == charmData._charm_id then
            existIndex = i
            break
          end
        end
        if 0 < existIndex then
          table.remove(self.charmSelectedIdList, existIndex)
          ui.img_selected:setVisible(false)
        else
          table.insert(self.charmSelectedIdList, charmData._charm_id)
          ui.img_selected:setVisible(true)
        end
        self.rogueLikeMgr:saveCharmIdListToBag(self.chapterId, self.charmSelectedIdList)
        self:refreshCharmBag(true)
        if self.curCharmWeightVal > self.maxCharmWeightVal then
          self:playCharmOverweightEffect()
        end
      end
    }
    local param = {
      delegate = delegate,
      container = self.ui.panel_charm_list,
      cliprect = CCRectMake(0, 0, panelSize.width, panelSize.height),
      colNum = 1,
      dragMode = 1,
      touchpriority = -300,
      padding = {width = 0, height = 0},
      offset = {0, 0},
      noshade = true
    }
    self.charmTableView = Tableview.create(param)
    self:refreshCharmTableView()
  end
end

function class:refreshCharmTableView(notResetPos)
  if notResetPos then
    local listX, listY = self.charmTableView:getListPos()
    self.charmTableView:reloadData()
    self.charmTableView:setListPos(ccp(listX, listY))
  else
    self.charmTableView:reloadData()
  end
end

function class:createSelectedCharmItem(index, charmId)
  local container, ui = ed.editorui(ed.uieditor.rogueCharmBagSelectedItem, {
    container = CCSprite:create()
  })
  ui.container = container
  ed.setCascadeOpacityEnabled(container, true, true)
  ed.setTexture(ui.bg, "UI/alpha/1080P/rogue/charm/charm_frame_normal_bg.png", true)
  ed.layout.centerInParent(ui.img_icon)
  self:refreshSelectedCharmItem(ui, charmId)
  return container, ui
end

function class:refreshSelectedCharmItem(ui, charmId)
  ui.bg:setVisible(true)
  local charmTableItem = ed.getDataTable("RogueCharm")[charmId]
  ed.setTexture(ui.img_icon, string.format("UI/alpha/1080P/rogue/charm/icon/%s", charmTableItem["Charm icon"]))
  ui.data = {}
  ui.data.charmId = charmId
  ui.data.weight = charmTableItem.Weight
end

function class:getSelectedCharmListItemPos(index)
  local selectedWidth = 92
  local size = self.ui.panel_charm_selected:getContentSize()
  local ox = 0
  local oy = size.height * 0.5
  local dx = ox + (index - 0.5) * selectedWidth
  return ccp(dx, oy)
end

function class:getSelectedCharmListWidth(num)
  local selectedWidth = 92
  return selectedWidth * num
end

function class:getPressSelectedInHandler()
  local function handler(x, y)
    for k, v in ipairs(self.selectedCharmUIArr) do
      if not tolua.isnull(v.container) and ed.containsPoint(v.bg, x, y) then
        v.bg:setScale(0.95)
        
        return v, k
      end
    end
  end
  
  return handler
end

function class:getClickSelectedInHandler()
  local function handler(x, y, ui, index)
    if self.isOverweightEffectPlaying then
      return
    end
    local id = self.charmSelectedIdList[index]
    if nil == id then
      return
    end
    table.remove(self.charmSelectedIdList, index)
    self.rogueLikeMgr:saveCharmIdListToBag(self.chapterId, self.charmSelectedIdList)
    self:refreshCharmItemSelectedState(id)
    self:refreshCharmBag(true)
  end
  
  return handler
end

function class:getCancelPressSelectedInHandler()
  local function handler(x, y, ui)
    if ui and not tolua.isnull(ui.bg) then
      ui.bg:setScale(1)
    end
  end
  
  return handler
end

function class:refreshCharmBag(isAction)
  self.ui.label_charm_bag_tip:setVisible(0 == #self.charmSelectedIdList)
  if nil == self.selectedCharmDraglist then
    local contentSize = self.ui.panel_charm_selected:getContentSize()
    self.selectedCharmDraglist = ed.UITool.createDraglist(self.ui.panel_charm_selected, {
      priority = -300,
      doPressIn = self:getPressSelectedInHandler(),
      doClickIn = self:getClickSelectedInHandler(),
      cancelPressIn = self:getCancelPressSelectedInHandler()
    })
    self.selectedCharmUIArr = {}
    self.selectedCharmUICache = {}
  end
  self.curCharmWeightVal = 0
  local oldUIArr = self.selectedCharmUIArr
  self.selectedCharmUIArr = {}
  local isExistAdd = false
  for selectedKey, selectedId in pairs(self.charmSelectedIdList) do
    local itemUI
    for i = 1, #oldUIArr do
      if oldUIArr[i].data.charmId == selectedId then
        itemUI = oldUIArr[i]
        table.remove(oldUIArr, i)
        break
      end
    end
    local itemPos = self:getSelectedCharmListItemPos(selectedKey)
    if nil == itemUI then
      isExistAdd = true
      if 0 == #self.selectedCharmUICache then
        local container, ui = self:createSelectedCharmItem(selectedKey, selectedId)
        self.selectedCharmDraglist:addItem(container)
        itemUI = ui
      else
        itemUI = self.selectedCharmUICache[1]
        table.remove(self.selectedCharmUICache, 1)
        self:refreshSelectedCharmItem(itemUI, selectedId)
        itemUI.container:stopAllActions()
        itemUI.container:setVisible(true)
      end
      if isAction then
        local fromPos = itemUI.container:getParent():convertToNodeSpace(self:getCharmCardPos(selectedId))
        local direction = {}
        direction[1] = itemPos.x - fromPos.x
        direction[2] = itemPos.y - fromPos.y
        direction = ed.edpNormalize(direction)
        itemUI.container:setPosition(itemPos.x - direction[1] * 40, itemPos.y - direction[2] * 40)
        local moveAction = CCSpawn:create(ccArrayMake(CCMoveTo:create(0.1, itemPos), CCFadeIn:create(0.1)))
        itemUI.container:runAction(moveAction)
      else
        itemUI.container:setPosition(itemPos)
      end
    else
      itemUI.container:stopAllActions()
      if isAction then
        itemUI.container:runAction(CCMoveTo:create(0.1, itemPos))
      else
        itemUI.container:setPosition(itemPos)
      end
    end
    table.insert(self.selectedCharmUIArr, itemUI)
    self.curCharmWeightVal = self.curCharmWeightVal + itemUI.data.weight
  end
  for i, ui in ipairs(oldUIArr) do
    ui.container:stopAllActions()
    if isAction then
      local toPos = ui.container:getParent():convertToNodeSpace(self:getCharmCardPos(ui.data.charmId))
      local itemPos = ccp(ui.container:getPosition())
      local direction = {}
      direction[1] = itemPos.x - toPos.x
      direction[2] = itemPos.y - toPos.y
      direction = ed.edpNormalize(direction)
      local moveAction = CCMoveTo:create(0.1, ccp(itemPos.x - direction[1] * 40, itemPos.y - direction[2] * 40))
      moveAction = CCSpawn:create(ccArrayMake(moveAction, CCFadeOut:create(0.1)))
      moveAction = CCSequence:createWithTwoActions(moveAction, ed.ui.rogueCharmBagScene.createHideAction(self, ui.container))
      ui.container:runAction(moveAction)
    else
      ui.container:setVisible(false)
    end
    table.insert(self.selectedCharmUICache, ui)
  end
  self.selectedCharmDraglist:initListWidth(self:getSelectedCharmListWidth(#self.charmSelectedIdList))
  if isExistAdd then
    self.selectedCharmDraglist:makePosRightMost()
  elseif oldDragPos then
    oldDragPos.x = math.max(oldDragPos.x, self.selectedCharmDraglist.width - self.selectedCharmDraglist.listWidth)
    oldDragPos.x = math.min(oldDragPos.x, 0)
    self.selectedCharmDraglist:setListPos(oldDragPos)
  end
  self:refreshWeightView()
end

function class:getCharmCardPos(id)
  local usedCell = self.charmTableView:getUsedCell()
  if 0 < #usedCell then
    local ui = usedCell[1].data.ui
    local charmData = usedCell[1].data.data
    local pos = ui.img_icon:getParent():convertToWorldSpace(ccp(ui.img_icon:getPosition()))
    local posIndex, targetIndex
    for i, v in ipairs(self.charmAvailableList) do
      if v._charm_id == id then
        targetIndex = i
      end
      if v._charm_id == charmData._charm_id then
        posIndex = i
      end
    end
    local itemHeight = self:getCharmItemSize().height
    pos.y = pos.y - itemHeight * (targetIndex - posIndex)
    return pos
  end
  return ccp(0, 0)
end

function class:refreshWeightView(...)
  if nil == self.bagWeightDesLabel then
    self.bagWeightDesLabel = ed.ui.autoText.new()
    self.ui.panel_charm_weight:addChild(self.bagWeightDesLabel.node)
  end
  local weightStr = T("<lable color=ccc3(255,231,170) name=desLabel>\232\180\159\233\135\141</lable><lable color=ccc3(255,252,231) name=curLabel>%d/</lable><lable color=ccc3(255,231,170) name=maxLabel>%d</lable>", self.curCharmWeightVal, self.maxCharmWeightVal)
  local weightPanelSize = self.ui.panel_charm_weight:getContentSize()
  self.bagWeightDesLabel:initParam({
    context = weightStr,
    maxWidth = weightPanelSize.width,
    fontSize = 15,
    strokeColor = ed.toccc3(263719),
    strokeSize = 1
  })
  local desWidth, desHeight = self.bagWeightDesLabel:getCurContentSize()
  self.bagWeightDesLabel.node:setPosition(ccp((weightPanelSize.width - desWidth) * 0.5, (weightPanelSize.height + desHeight - self.bagWeightDesLabel:getFirstLineHeight()) * 0.5 - 1))
end

function class:playCharmOverweightEffect()
  self.isOverweightEffectPlaying = true
  local selectedContentSize = self.ui.panel_charm_selected:getContentSize()
  local posY = selectedContentSize.height * 0.5
  for i, v in ipairs(self.selectedCharmUIArr) do
    ed.setTexture(v.bg, "UI/alpha/1080P/rogue/charm/charm_frame_overweight_bg.png")
    v.bg:stopAllActions()
    v.bg:runAction(ed.ui.rogueCharmBagScene.createShakeAction(self, 0, 0))
  end
  ed.setScale9SpriteTexture(self.ui.image_charm_bag, "UI/alpha/1080P/rogue/charm/charm_battle_overweight_bg.png")
  local weightDesLabel = self.bagWeightDesLabel:getLabelByName("desLabel")
  if nil ~= weightDesLabel then
    ed.setLabelColor(weightDesLabel, ccc3(255, 132, 132))
    ed.setLabelStroke(weightDesLabel, ed.toccc3(3735561), 1)
  end
  local curWeightLabel = self.bagWeightDesLabel:getLabelByName("curLabel")
  if nil ~= curWeightLabel then
    ed.setLabelColor(curWeightLabel, ccc3(255, 132, 132))
    ed.setLabelStroke(curWeightLabel, ed.toccc3(3735561), 1)
  end
  local maxWeightLabel = self.bagWeightDesLabel:getLabelByName("maxLabel")
  if nil ~= maxWeightLabel then
    ed.setLabelColor(maxWeightLabel, ccc3(255, 132, 132))
    ed.setLabelStroke(maxWeightLabel, ed.toccc3(3735561), 1)
  end
  self:listenTimer(Timer:Once(1.5), function()
    self:onCharmOverweightEffectComplete()
  end)
end

function class:onCharmOverweightEffectComplete()
  self.isOverweightEffectPlaying = false
  for i, v in ipairs(self.selectedCharmUIArr) do
    ed.setTexture(v.bg, "UI/alpha/1080P/rogue/charm/charm_frame_normal_bg.png")
    v.bg:stopAllActions()
    v.bg:setPosition(0, 0)
  end
  ed.setScale9SpriteTexture(self.ui.image_charm_bag, "UI/alpha/1080P/rogue/charm/charm_battle_weight_bg.png")
  local weightDesLabel = self.bagWeightDesLabel:getLabelByName("desLabel")
  if nil ~= weightDesLabel then
    ed.setLabelColor(weightDesLabel, ccc3(255, 231, 170))
    ed.setLabelStroke(weightDesLabel, ed.toccc3(263719), 1)
  end
  local curWeightLabel = self.bagWeightDesLabel:getLabelByName("curLabel")
  if nil ~= curWeightLabel then
    ed.setLabelColor(curWeightLabel, ccc3(255, 252, 231))
    ed.setLabelStroke(curWeightLabel, ed.toccc3(263719), 1)
  end
  local maxWeightLabel = self.bagWeightDesLabel:getLabelByName("maxLabel")
  if nil ~= maxWeightLabel then
    ed.setLabelColor(maxWeightLabel, ccc3(255, 231, 170))
    ed.setLabelStroke(maxWeightLabel, ed.toccc3(263719), 1)
  end
  if 0 < #self.charmSelectedIdList then
    local id = self.charmSelectedIdList[#self.charmSelectedIdList]
    table.remove(self.charmSelectedIdList, #self.charmSelectedIdList)
    self.rogueLikeMgr:saveCharmIdListToBag(self.chapterId, self.charmSelectedIdList)
    self:refreshCharmItemSelectedState(id)
    self:refreshCharmBag(true)
  end
end
