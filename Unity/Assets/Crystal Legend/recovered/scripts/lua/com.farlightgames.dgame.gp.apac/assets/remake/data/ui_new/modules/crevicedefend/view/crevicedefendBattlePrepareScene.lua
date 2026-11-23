local base = ed.ui.basescene
local CreviceDefendBattlePrepareScene = newclass(base.mt)
ed.ui.CreviceDefendBattlePrepareScene = CreviceDefendBattlePrepareScene
local lsr = ed.ui.battlepreparepeakarenalsr.create()
local member_count_max = 5
local TeamUIConfig = {
  [1] = {
    normalPath = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
    pressPath = "UI/alpha/1080P/cuparena/cuparena_prepare_team_1.png",
    teamColor = ed.toccc3(16775585),
    teamStrokeColor = ed.toccc3(11954462)
  },
  [2] = {
    normalPath = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
    pressPath = "UI/alpha/1080P/cuparena/cuparena_prepare_team_2.png",
    teamColor = ed.toccc3(12910590),
    teamStrokeColor = ed.toccc3(2455953)
  },
  [3] = {
    normalPath = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
    pressPath = "UI/alpha/1080P/cuparena/cuparena_prepare_team_3.png",
    teamColor = ed.toccc3(16770763),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [4] = {
    normalPath = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
    pressPath = "UI/alpha/1080P/cuparena/cuparena_prepare_team_4.png",
    teamColor = ed.toccc3(16771503),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [5] = {
    normalPath = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
    pressPath = "UI/alpha/1080P/cuparena/cuparena_prepare_team_5.png",
    teamColor = ed.toccc3(13625343),
    teamStrokeColor = ed.toccc3(2379449)
  },
  [6] = {
    normalPath = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
    pressPath = "UI/alpha/1080P/cuparena/cuparena_prepare_team_6.png",
    teamColor = ed.toccc3(16776423),
    teamStrokeColor = ed.toccc3(7221115)
  },
  [7] = {
    normalPath = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
    pressPath = "UI/alpha/1080P/cuparena/cuparena_prepare_team_7.png",
    teamColor = ed.toccc3(16514997),
    teamStrokeColor = ed.toccc3(8621085)
  }
}
local EnemyUIConfig = {
  [1] = {
    teamNameColor = ed.toccc3(16303420),
    teamNameStrokeColor = ed.toccc3(3809809),
    wordStartColor = ed.toccc3(16769141),
    wordEndColor = ed.toccc3(15646787),
    wordStrokeColor = ed.toccc3(7748629)
  },
  [2] = {
    teamNameColor = ed.toccc3(3981816),
    teamNameStrokeColor = ed.toccc3(2763346),
    wordStartColor = ed.toccc3(10352383),
    wordEndColor = ed.toccc3(4166609),
    wordStrokeColor = ed.toccc3(2763346)
  },
  [3] = {
    teamNameColor = ed.toccc3(14832953),
    teamNameStrokeColor = ed.toccc3(4133651),
    wordStartColor = ed.toccc3(16684368),
    wordEndColor = ed.toccc3(14436147),
    wordStrokeColor = ed.toccc3(4593174)
  },
  [4] = {
    teamNameColor = ed.toccc3(13990714),
    teamNameStrokeColor = ed.toccc3(4925455),
    wordStartColor = ed.toccc3(16031815),
    wordEndColor = ed.toccc3(12149291),
    wordStrokeColor = ed.toccc3(4925455)
  },
  [5] = {
    teamNameColor = ed.toccc3(7964902),
    teamNameStrokeColor = ed.toccc3(2106188),
    wordStartColor = ed.toccc3(9214968),
    wordEndColor = ed.toccc3(4016820),
    wordStrokeColor = ed.toccc3(2106188)
  },
  [6] = {
    teamNameColor = ed.toccc3(13465827),
    teamNameStrokeColor = ed.toccc3(3151938),
    wordStartColor = ed.toccc3(15106815),
    wordEndColor = ed.toccc3(8471204),
    wordStrokeColor = ed.toccc3(3151938)
  },
  [7] = {
    teamNameColor = ed.toccc3(15393119),
    teamNameStrokeColor = ed.toccc3(4341520),
    wordStartColor = ed.toccc3(14800725),
    wordEndColor = ed.toccc3(10721059),
    wordStrokeColor = ed.toccc3(4341520)
  }
}

function CreviceDefendBattlePrepareScene.create(data)
  local self = base.create("CreviceDefendBattlePrepareScene")
  setmetatable(self, CreviceDefendBattlePrepareScene.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  return self
end

function CreviceDefendBattlePrepareScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.crevicedefendBattlePrepareScene, {
    container = self.mainLayer
  })
  self.container = container
  self.ui = ui
  self.myTeamLightArr = {
    self.ui.img_my_team_light_1,
    self.ui.img_my_team_light_2,
    self.ui.img_my_team_light_3,
    self.ui.img_my_team_light_4,
    self.ui.img_my_team_light_5
  }
  self.ui.layEmeHeros:setVisible(true)
  local heroPanelSize = self.ui.panel_hero:getContentSize()
  heroPanelSize.height = heroPanelSize.height + (0 or 70)
  self.ui.panel_hero:setContentSize(heroPanelSize)
  self:adaptUI()
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:setBackground("UI/alpha/1080P/crevicedefend/bg.jpg")
  self:initLabels()
  self:initViewModule()
  self:addPresetLayer()
  self:initLegendEquip()
end

function CreviceDefendBattlePrepareScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_enemy_left", function()
    self:onClickEnemyLeftEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_enemy_right", function()
    self:onClickEnemyRightEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_delete", function()
    self:onClickDeleteTeamEvent()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_next", function()
    self:onClickNextTeamEvent()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_go", function()
    self:onClickGoEvent()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_recommend", function()
    self:clickRecommendView()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "bg_select", function()
    local isSkipBattle = not ed.CreviceDefendBattleManager:getSkipBattle()
    ed.CreviceDefendBattleManager:setSkipBattle(isSkipBattle)
    self.ui.img_select:setVisible(isSkipBattle)
  end)
  ed.UITool.registerBtn(self, "label_select_des", function()
    local isSkipBattle = not ed.CreviceDefendBattleManager:getSkipBattle()
    ed.CreviceDefendBattleManager:setSkipBattle(isSkipBattle)
    self.ui.img_select:setVisible(isSkipBattle)
  end)
end

function CreviceDefendBattlePrepareScene:registerEvents()
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
  self:listenEvent("CreviceDefendReCommendLineup", function(data)
    self.selfTeamIDs = {}
    for _, ids in ipairs(data) do
      local new = {}
      for _, id in ipairs(ids) do
        local hero = ed.player:getHero(id)
        if hero then
          table.insert(new, id)
        end
      end
      table.insert(self.selfTeamIDs, new)
    end
    self:refreshKarlElementByState()
    self.heroList:refreshHeroList()
    self.teamIdxList:refresh(self.teamIndex)
    self:refreshMyTeamUI(true)
  end)
end

function CreviceDefendBattlePrepareScene:initLabels()
  if self.uiConfig then
    ed.setLabelString(self.ui.label_defend_title, self.uiConfig.defendTitleStr)
    ed.setLabelString(self.ui.label_defend_des, self.uiConfig.defendDesStr)
  end
  self.ui.label_preset:setStroke(ccc3(39, 37, 36), 1.5)
  ed.setLabelShadow(self.ui.label_go, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_delete, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_next, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelDimensions(self.ui.label_defend_des, CCSizeMake(165, 0))
  self.ui.label_defend_title:setString(T("\232\163\130\233\154\153\230\136\141\229\141\171"))
  ed.setLabelColor(self.ui.label_defend_title, ccc3(255, 252, 231))
  ed.setLabelShadow(self.ui.label_defend_title, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelColor(self.ui.label_recommend, ed.toccc3(16708009))
  ed.setLabelShadow(self.ui.label_recommend, ed.toccc3(5126949), ccp(0, 2))
  local autoText = ed.ui.autoText.new()
  local desc = string.format(T("<lable color=ccc3(223,220,102)>\229\137\169\228\189\153\229\133\141\232\180\185\230\172\161\230\149\176: </lable>") .. T("<lable color=ccc3(253,163,82) fontSize=f15>%s</lable><lable color=ccc3(255,239,195)></lable>"), self.challengeCount)
  autoText:initParam({context = desc, fontSize = 14})
  local curWidth = autoText:getCurContentSize()
  ed.UITool.replaceUI(self.ui, "panel_attack", "label_select_des_count", autoText.node)
  autoText.node:setPositionX(autoText.node:getPositionX() - curWidth / 2)
  autoText.node:setPositionY(autoText.node:getPositionY() - 2)
end

function CreviceDefendBattlePrepareScene:adaptUI()
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local lrWne = 0.25
  newWid = newWid - ed.display.getNotchHeight()
  self.mainLayer:setPosition(self.mainLayer:getPositionX() + ed.display.getNotchHeight() - newWid / 2, self.mainLayer:getPositionY() - newHei / 2)
  local frameui = self.ui
  local leftMoPosX = (1 - lrWne) * newWid
  local thisCon = frameui.lay9BJ:getContentSize()
  frameui.lay9BJ:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, heightWin - 4))
  thisCon = frameui.layBgs:getContentSize()
  frameui.layBgs:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, heightWin - 5))
  local posXloc = leftMoPosX / 2
  local posYloc = newHei / 2
  frameui.starImg_1:setPosition(frameui.starImg_1:getPositionX() + posXloc, frameui.starImg_1:getPositionY() + newHei)
  frameui.starImg_2:setPositionX(frameui.starImg_2:getPositionX() + posXloc)
  frameui.starImg_3:setPositionY(frameui.starImg_3:getPositionY() + posYloc)
  frameui.starImg_4:setPosition(frameui.starImg_4:getPositionX() + leftMoPosX, frameui.starImg_4:getPositionY() + posYloc)
  local newPosY = frameui.layEmeHeros:getPositionY()
  frameui.layEmeHeros:setPositionY(newPosY + newHei)
  thisCon = frameui.layEmeHeros:getContentSize()
  frameui.layEmeHeros:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  local newPosX = frameui.panel_enemy:getPositionX()
  newPosX = newPosX + leftMoPosX * 0.5
  newPosX = newPosX < 174 and 174 or newPosX
  frameui.panel_enemy:setPositionX(newPosX)
  thisCon = frameui.panel_team:getContentSize()
  frameui.panel_team:setContentSize(CCSizeMake(thisCon.width, thisCon.height + newHei))
  frameui.panel_team:setClipRect(CCRectMake(0, 0, frameui.panel_team:getContentSize().width - 20, frameui.panel_team:getContentSize().height))
  newPosY = frameui.panel_team:getPositionY()
  frameui.panel_team:setPositionY(newPosY)
  thisCon = frameui.panel_hero:getContentSize()
  frameui.panel_hero:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height + newHei))
  newPosY = frameui.panel_attack:getPositionY()
  frameui.panel_attack:setPositionY(newPosY - newHei * 0.5)
  thisCon = frameui.isbg:getContentSize()
  frameui.isbg:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  frameui.panel_classify:setPositionX(frameui.panel_classify:getPositionX() + posXloc)
  frameui.lin_L:setPositionX(frameui.lin_L:getPositionX() + posXloc)
  frameui.lin_R:setPositionX(frameui.lin_R:getPositionX() + posXloc)
  frameui.btn_preset:setPositionX(frameui.btn_preset:getPositionX() + leftMoPosX)
  frameui.btn_preset_back:setPositionX(frameui.btn_preset_back:getPositionX() + leftMoPosX)
  thisCon = frameui.myTeam9Img_4:getContentSize()
  frameui.myTeam9Img_4:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  frameui.myTeam9Img_4:setPositionX(frameui.myTeam9Img_4:getPositionX() + leftMoPosX / 2)
  frameui.panel_my_team:setPositionX(frameui.panel_my_team:getPositionX() + leftMoPosX / 2)
  local thisCon9L = frameui.myTeam9Img_2:getContentSize()
  local thisCon9R = frameui.myTeam9Img_3:getContentSize()
  local thisCon9LrWne = thisCon9L.width / thisCon9R.width
  frameui.myTeam9Img_2:setContentSize(CCSizeMake(thisCon9L.width + (1 - thisCon9LrWne) * leftMoPosX, thisCon9L.height))
  frameui.myTeam9Img_3:setContentSize(CCSizeMake(thisCon9R.width + thisCon9LrWne * leftMoPosX, thisCon9R.height))
  frameui.myTeam9Img_3:setPositionX(frameui.myTeam9Img_3:getPositionX() + leftMoPosX)
  newPosX = frameui.panel_right:getPositionX()
  frameui.panel_right:setPositionX(newPosX + (1 - lrWne) * newWid)
  local rightMoPosX = lrWne * newWid
  thisCon = frameui.bg_rig:getContentSize()
  frameui.bg_rig:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, heightWin - 7.5))
  newPosX, newPosY = frameui.bg_rig2:getPosition()
  local rightMoPosXLocal = rightMoPosX / 2
  frameui.bg_rig2:setPosition(newPosX + rightMoPosXLocal, newPosY + newHei)
  frameui.panel_pages:setPositionX(frameui.panel_pages:getPositionX() + rightMoPosXLocal)
  frameui.label_defend_title:setPositionY(frameui.label_defend_title:getPositionY() + newHei)
  frameui.label_select_des:setPositionY(frameui.label_select_des:getPositionY() + newHei * 0.5)
  frameui.image_skip_bg:setPositionY(frameui.label_select_des:getPositionY() + newHei * 0.5)
end

function CreviceDefendBattlePrepareScene:initData(data)
  self.teamIndex = 1
  self.teamCount = 5
  self.requireNumPerTeam = 5
  self.oppoTeams = data.oppoTeams
  self.stageMap = data.stageIdMap
  self.challengeCount = data.challengeCount
  self.selfTeamIDs = self:getTeamData(data.stageIdMap)
  self.myTeamUIArr = {}
  self.localFcaCache = {}
end

function CreviceDefendBattlePrepareScene:getTeamData(stageIdMap)
  local teamData = {}
  for index = 1, self.teamCount do
    local stageID = stageIdMap[index]
    local key = "creviceDefendStage" .. stageID
    local data = ed.getTeamData(key)
    data = self:fixTeamData(data)
    teamData[index] = data
  end
  for i = 1, self.teamCount do
    if nil == teamData[i] then
      teamData[i] = {}
    end
  end
  return teamData
end

function CreviceDefendBattlePrepareScene:fixTeamData(heroIdList)
  local newHeroIdList = {}
  for index, heroId in ipairs(heroIdList) do
    local hero = ed.player:getHero(heroId)
    if hero then
      table.insert(newHeroIdList, heroId)
    end
  end
  return newHeroIdList
end

function CreviceDefendBattlePrepareScene:setTeamData()
  for index = 1, self.teamCount do
    local stageID = self.stageMap[index]
    local key = "creviceDefendStage" .. stageID
    local data = self.selfTeamIDs[index]
    data = self:fixTeamData(data)
    ed.setTeamData(key, data)
  end
end

function CreviceDefendBattlePrepareScene:initLegendEquip()
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

function CreviceDefendBattlePrepareScene:switchLegendEquipMenu(open)
  self.ui.close_equip_bg:setVisible(not open)
  self.ui.label_equip:setVisible(not open)
  self.ui.label_equip_enable:setVisible(open)
  self.ui.btn_equip:setPositionX(open and 17 or 59)
  self:refreshLegendEquip()
end

function CreviceDefendBattlePrepareScene:refreshLegendEquip()
  self.heroList:refreshHeroUI()
  self:refreshMyTeamUI(false)
  self:refreshEnemyTeamUI(false)
  self:refreshPresetLayer()
end

function CreviceDefendBattlePrepareScene:initViewModule()
  self.classifyIndex = 1
  self.classifyType = "all"
  self.teamIndex = 1
  self.classifyList = ed.BattlePrepareUITool.ClassifyListUI.create(self, {
    curIndex = self.classifyIndex,
    classifyArr = {
      {
        "all",
        T("\229\133\168\233\131\168")
      },
      {
        "front",
        T("\229\137\141\230\142\146")
      },
      {
        "middle",
        T("\228\184\173\230\142\146")
      },
      {
        "back",
        T("\229\144\142\230\142\146")
      }
    },
    callback = function(index, type)
      self.classifyIndex = index
      self.classifyType = type
      self.heroList:refreshHeroList()
    end
  })
  self.teamIdxList = ed.BattlePrepareUITool.TeamIdxListUI.create(self, {
    curIndex = self.teamIndex,
    teamCount = self.teamCount,
    createCallback = function(index)
      local uiConfig = TeamUIConfig[index]
      local container = CCSprite:create()
      local ui = {}
      local button = ed.createSprite(uiConfig.normalPath)
      local btnSize = button:getContentSize()
      local teamStr = T("%s\233\152\159", index)
      local normalLabel = ed.createLabelTTF(teamStr, 18)
      ed.setLabelColor(normalLabel, ed.toccc3(16708578))
      button:addChild(normalLabel)
      normalLabel:setPosition(ccp(45.75, 45.5))
      ed.setLabelFontName(normalLabel, ed.fontBold)
      local press = ed.createSprite(uiConfig.pressPath)
      local pressLabel = ed.createLabelTTF(teamStr, 18)
      press:addChild(pressLabel)
      pressLabel:setPosition(ccp(45.75, 45.5))
      ed.setLabelColor(pressLabel, uiConfig.teamColor)
      ed.setLabelStroke(pressLabel, uiConfig.teamStrokeColor, 1)
      ed.setLabelFontName(pressLabel, ed.fontBold)
      container:setContentSize(btnSize)
      container:addChild(button)
      button:setPosition(ccp(btnSize.width * 0.5, btnSize.height * 0.5))
      container:addChild(press)
      press:setPosition(ccp(btnSize.width * 0.5, btnSize.height * 0.5))
      ed.adaptLabel(normalLabel, {maxWidth = 50, minScale = 0.6})
      ed.adaptLabel(pressLabel, {maxWidth = 50, minScale = 0.6})
      ui.container = container
      ui.button = button
      ui.press = press
      return container, ui
    end,
    clickCallback = function(index)
      self.teamIndex = index
      self:refreshMyTeamUI(true)
      self:refreshKarlElementByState()
      self.heroList:refreshHeroUI()
      self:refreshEnemyTeamUI(false)
      self:refreshBtnVisible()
      self:refreshRightUI()
    end
  })
  self.heroList = ed.BattlePrepareUITool.HeroListUI.create(self, {
    heroArr = self:getAllHero(),
    filterCallback = function(heroData)
      return self.classifyType == "all" or self.classifyType == heroData.category
    end,
    refreshCallback = function(heroUI)
      local teamIdx = self:getTeamIdxByID(heroUI.info.id)
      if teamIdx and teamIdx == self.teamIndex then
        if not heroUI.isSelected then
          heroUI:showSelectTag()
        end
      elseif heroUI.isSelected then
        heroUI:deleteSelectTag()
      end
      if teamIdx then
        if nil == heroUI.teamIndex or teamIdx ~= heroUI.teamIndex then
          heroUI:addLegendArenaTeamInfo({team_index = teamIdx})
          heroUI.teamIndex = teamIdx
        end
        if not heroUI.stateShade then
          heroUI:addShade()
        end
      else
        heroUI.teamIndex = nil
        heroUI:RemoveTeamInfo()
        if heroUI.stateShade then
          heroUI:removeShade()
        end
      end
      heroUI:showLegendEquip(ed.off_legendEquipOp)
      heroUI:showKarlElement(self.showElement)
    end,
    clickCallback = function(heroUI)
      self:onPoolHeroHeadEvent(heroUI)
    end
  })
  self:refreshMyTeamUI(true)
  self:refreshEnemyTeamUI(true)
  self:refreshRightUI()
  self:refreshBtnVisible()
end

function CreviceDefendBattlePrepareScene:getTeamIdxByID(id)
  for teamIndex, idArr in ipairs(self.selfTeamIDs) do
    if ed.isElementInTable(id, idArr) then
      return teamIndex
    end
  end
  return nil
end

function CreviceDefendBattlePrepareScene:sortHeroByPvpActivity(heros)
  table.sort(heros, ed.cmpSort({
    {
      getValue = function(hero)
        return ed.readhero.isSpecialFreeHeroID(hero._tid) and 1 or 0
      end,
      reverse = true
    },
    {
      getValue = function(hero)
        return 0
      end,
      reverse = true
    },
    {key = "_level", reverse = true},
    {key = "_rank", reverse = true},
    {key = "_stars", reverse = true},
    {
      getValue = function(hero)
        local aInitStar = ed.getDataTable("Unit")[ed.readhero.convertToOriginID(hero._tid)]["Initial Stars"]
        return aInitStar
      end,
      reverse = true
    },
    {key = "_gs", reverse = true},
    {key = "_tid"}
  }))
end

function CreviceDefendBattlePrepareScene:getAllHero()
  local serverTime = ed.getServerTime()
  local UnitTable = ed.getDataTable("Unit")
  local heroes = {}
  for _, hero in pairs(ed.player:getAllHero() or {}) do
    local data = hero.data
    if data and data._tid and ed.readhero.isHeroOpen(data._tid, serverTime) then
      local heroInfo = ed.copyProto(data)
      heroInfo._gs = heroInfo._gs or 5
      local unitTableItem = UnitTable[data._tid]
      local pos = unitTableItem["Position Type"]
      local isTitan = unitTableItem.IsTitan
      if pos == T("\229\137\141\230\142\146") then
        heroInfo.category = "front"
      elseif pos == T("\228\184\173\230\142\146") then
        heroInfo.category = "middle"
      elseif pos == T("\229\144\142\230\142\146") then
        heroInfo.category = "back"
      end
      if isTitan then
        heroInfo.isTitan = true
      end
      table.insert(heroes, heroInfo)
    end
  end
  local first_flag = true
  self:sortHeroByPvpActivity(heroes)
  
  local function mysort(list, new_list)
    local cache = {}
    local recommend_heros = self.tbc_recommend_heros or {}
    for _, v in pairs(self.act_recommend_heros or {}) do
      table.insert(recommend_heros, v)
    end
    local len = #list
    for index = 1, len do
      if ed.isElementInTable(list[index]._tid, recommend_heros) then
        new_list[#new_list + 1] = list[index]
        if first_flag then
          self.recommend_own_num = self.recommend_own_num + 1
        end
      else
        cache[#cache + 1] = list[index]
      end
    end
    first_flag = false
    len = #cache
    for index = 1, len do
      new_list[#new_list + 1] = cache[index]
    end
    return new_list
  end
  
  local new_all = {}
  heroes = mysort(heroes, new_all)
  return heroes
end

function CreviceDefendBattlePrepareScene:addHeroToMyTeam(teamIndex, id)
  local idArr = self.selfTeamIDs[teamIndex] or {}
  table.insert(idArr, id)
  ed.readhero.sortIDByRange(idArr)
end

function CreviceDefendBattlePrepareScene:playMyTeamShine(fadeTime)
  for i, v in ipairs(self.myTeamLightArr) do
    v:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(fadeTime), CCFadeOut:create(fadeTime)))
  end
end

function CreviceDefendBattlePrepareScene:refreshRightUI()
  local bossID = self.oppoTeams[self.teamIndex][3]
  if nil == self.localFcaCache[bossID] then
    local puppet, _ = ed.readhero.getActor(bossID, "Idle", true, false)
    local bossConfig = ed.getDataTable("CreviceDefendBoss")[self.stageMap[self.teamIndex]]
    local bossSize = bossConfig.UISize
    puppet:setScale(bossSize)
    puppet:setPositionX(30)
    self.ui.panel_fca:addChild(puppet, 99)
    self.localFcaCache[bossID] = puppet
  else
    self.localFcaCache[bossID]:setVisible(true)
  end
  if self.localFcaCache[self.oldBossID] then
    self.localFcaCache[self.oldBossID]:setVisible(false)
  end
  self.oldBossID = bossID
  self.ui.img_select:setVisible(ed.CreviceDefendBattleManager:getSkipBattle())
  self.ui.label_stage_content:setString(T("\230\183\177\230\184\138\229\164\167\229\134\155\231\154\132\230\130\178\233\184\163\229\183\178\229\147\141\229\189\187\229\140\151\229\162\131--\229\164\167\230\137\185\229\176\184\233\172\188\230\182\140\229\144\145\228\184\180\229\134\172\229\159\142!\229\135\155\229\134\172\229\176\134\232\135\179!\229\191\171\233\155\134\231\187\147\230\137\128\230\156\137\232\139\177\233\155\132\228\185\139\232\161\128\229\174\136\229\141\171\232\190\185\229\162\131"))
  ed.adaptLabel(self.ui.label_stage_content, {maxWidth = 165, minScale = 1})
  ed.setLabelColor(self.ui.label_stage_content, ccc3(255, 252, 231))
  ed.setLabelShadow(self.ui.label_stage_content, ccc3(0, 0, 0), ccp(0, 2))
end

function CreviceDefendBattlePrepareScene:refreshMyTeamUI(isInit)
  local idArr = self.selfTeamIDs[self.teamIndex]
  local oldTeamUITab = {}
  for i, v in ipairs(self.myTeamUIArr) do
    oldTeamUITab[v.info.id] = {index = i, ui = v}
  end
  self.myTeamUIArr = {}
  self:refreshKarlElementByState()
  local totalGs = 0
  for i, id in ipairs(idArr or {}) do
    local heroUI
    local oldTeamData = oldTeamUITab[id]
    if nil ~= oldTeamData then
      oldTeamUITab[id] = nil
      heroUI = oldTeamData.ui
      if i ~= oldTeamData.index then
        local x, y = self.myTeamLightArr[i]:getPosition()
        heroUI.icon:setOpacity(255)
        heroUI.icon:stopAllActions()
        heroUI.icon:runAction(CCEaseBackInOut:create(CCMoveTo:create(0.2, ccpAdd(ccp(x, y), ccp(0, 10)))))
      end
    else
      heroUI = ed.readhero.createIconByID(id, {
        state = "idle",
        isShowLegendEquip = ed.openLegendEquip()
      })
      self.ui.panel_my_team:addChild(heroUI.icon)
      local x, y = self.myTeamLightArr[i]:getPosition()
      if isInit then
        heroUI.icon:setPosition(ccpAdd(ccp(x, y), ccp(0, 10)))
        heroUI.icon:runAction(CCFadeIn:create(0.4))
      else
        heroUI.icon:setPosition(heroUI.icon:getParent():convertToNodeSpace((self.heroList:getHeroIconPos(id))))
        heroUI.icon:runAction(CCSpawn:create(ccArrayMake(CCFadeIn:create(0.2), CCMoveTo:create(0.2, ccpAdd(ccp(x, y), ccp(0, 10))))))
      end
      self.myTeamLightArr[i]:stopAllActions()
      self.myTeamLightArr[i]:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.2), CCFadeOut:create(0.2)))
    end
    heroUI:showLegendEquip(ed.off_legendEquipOp)
    heroUI:showKarlElement(self.showElement)
    table.insert(self.myTeamUIArr, heroUI)
    local hero = ed.player:getHero(id)
    if hero then
      totalGs = totalGs + hero._gs
    end
  end
  for k, v in pairs(oldTeamUITab) do
    local heroUI = v.ui
    heroUI.icon:stopAllActions()
    heroUI:showKarlElement(self.showElement)
    local targetPos = heroUI.icon:getParent():convertToNodeSpace((self.heroList:getHeroIconPos(heroUI.info.id)))
    if isInit then
      heroUI.icon:removeFromParentAndCleanup(true)
    else
      heroUI.icon:runAction(CCSpawn:create(ccArrayMake(CCSequence:createWithTwoActions(CCFadeOut:create(0.2), CCCallFunc:create(function()
        heroUI.icon:removeFromParentAndCleanup(true)
      end)), CCMoveTo:create(0.35, targetPos))))
    end
  end
  self:listenTimer(Timer:Once(0.01), function()
    self:refreshTeamTouchEvent()
  end)
  ed.setString(self.ui.label_my_gs, totalGs)
  self:refreshpreseHeros()
end

function CreviceDefendBattlePrepareScene:refreshEnemyTeamUI(isInit)
  local enemyPanelSize = self.ui.panel_enemy:getContentSize()
  if nil == self.enemyLayerArr then
    local clipLayer = CCLayer:create()
    self.ui.panel_enemy:addChild(clipLayer)
    clipLayer:setClipRect(CCRectMake(0, 0, enemyPanelSize.width, enemyPanelSize.height))
    self.enemyLayerArr = {}
    for teamIndex, teamData in ipairs(self.oppoTeams) do
      local teamLayer = CCLayer:create()
      clipLayer:addChild(teamLayer)
      local sortArr = {}
      for index, heroId in ipairs(teamData) do
        local heroBg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head.png")
        teamLayer:addChild(heroBg)
        if heroId and heroId ~= 0 then
          local stage = self.stageMap[self.teamIndex]
          local config = ed.getDataTable("CreviceDefendBattle")[stage]
          local level = 1
          local rank = 1
          local star = 1
          if index ~= 3 then
            level = config[1].MonsterLevel
          else
            level = config[1].BossLevel
          end
          star = config[1]["Stars " .. index]
          rank = math.floor((level + 9) / 10)
          local hero = ed.readhero.createIcon({
            id = heroId,
            rank = rank,
            stars = star,
            level = level
          })
          hero.icon:setPosition(28, 28)
          hero.icon:setScale(0.7)
          heroBg:addChild(hero.icon)
          hero:showLegendEquip(ed.off_legendEquipOp)
        else
          local hideImg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head2.png")
          heroBg:addChild(hideImg)
          ed.layout.centerInParent(hideImg)
        end
        table.insert(sortArr, heroBg)
      end
      for sortIndex, heroBg in ipairs(sortArr) do
        heroBg:setPosition(ccp(3 + (sortIndex - 0.5) * 68, enemyPanelSize.height * 0.5))
      end
      table.insert(self.enemyLayerArr, teamLayer)
    end
  end
  for i, teamLayer in ipairs(self.enemyLayerArr) do
    local posX = (i - self.teamIndex) * enemyPanelSize.width
    teamLayer:stopAllActions()
    if isInit then
      teamLayer:setPosition(ccp(posX, 0))
    else
      teamLayer:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.2, ccp(posX, 0))))
    end
  end
  self.ui.btn_enemy_left:setVisible(self.teamIndex > 1)
  self.ui.btn_enemy_right:setVisible(self.teamIndex < self.teamCount)
  local uiConfig = EnemyUIConfig[self.teamIndex]
  ed.setLabelStroke(self.ui.label_enemy_team, uiConfig.teamNameStrokeColor, 1)
  ed.setLabelColor(self.ui.label_enemy_team, uiConfig.teamNameColor)
  local wordParams = {
    text = T("\230\149\140"),
    fontSize = 18,
    fontName = ed.fontBold,
    startColor = uiConfig.wordStartColor,
    endColor = uiConfig.wordEndColor,
    strokeColor = uiConfig.wordStrokeColor,
    strokeSize = 1
  }
  if nil == self.ui.label_enemy_word then
    self.ui.label_enemy_word = ed.ui.gradientLabel.create(wordParams)
    local enemyTeamBgSize = self.ui.bg_enemy_team:getContentSize()
    self.ui.bg_enemy_team:addChild(self.ui.label_enemy_word.node)
    self.ui.label_enemy_word.node:setPosition(19, enemyTeamBgSize.height * 0.5)
  else
    self.ui.label_enemy_word:refresh(wordParams)
  end
  self.ui.label_enemy_team:setString(string.format(T("\233\152\181\229\174\185%s/%s"), self.teamIndex, self.teamCount))
end

local karlHeroId = 53

function CreviceDefendBattlePrepareScene:refreshKarlElementByState()
  local state = false
  local idArr = self.selfTeamIDs[self.teamIndex]
  for i, id in ipairs(idArr or {}) do
    if id == karlHeroId then
      state = true
      break
    end
  end
  self:setKarlElementByState(state)
end

function CreviceDefendBattlePrepareScene:setKarlElementByState(state)
  self.showElement = state
end

function CreviceDefendBattlePrepareScene:setKarlElementByExistTeam(stateAdd, tid)
  if tid ~= karlHeroId then
    return
  end
  self:setKarlElementByState(stateAdd)
end

function CreviceDefendBattlePrepareScene:removeHeroFromMyTeam(teamIndex, id)
  local idArr = self.selfTeamIDs[teamIndex] or {}
  for i, v in ipairs(idArr) do
    if id == v then
      table.remove(idArr, i)
      break
    end
  end
end

function CreviceDefendBattlePrepareScene:onTeamHeroHeadEvent(heroUI)
  self:removeHeroFromMyTeam(self.teamIndex, heroUI.info.id)
  self:refreshMyTeamUI(false)
  self:refreshKarlElementByState()
  self.heroList:refreshHeroUI()
end

function CreviceDefendBattlePrepareScene:refreshBtnVisible(...)
  self.ui.btn_next:setVisible(self.teamCount ~= self.teamIndex)
  self.ui.btn_go:setVisible(self.teamCount == self.teamIndex)
end

function CreviceDefendBattlePrepareScene:onClickNextTeamEvent()
  local idArr = self.selfTeamIDs[self.teamIndex]
  
  local function callback()
    self.teamIndex = ed.clamp(self.teamIndex + 1, 1, self.teamCount)
    self.teamIdxList:refresh(self.teamIndex)
    self.heroList:refreshHeroUI()
    self:refreshMyTeamUI(true)
    self:refreshEnemyTeamUI(false)
    self:refreshBtnVisible()
    self:refreshRightUI()
  end
  
  if not idArr or #idArr < self.requireNumPerTeam then
    local tipStr, info
    if 1 == self.requireNumPerTeam then
      tipStr = T("\230\130\168\231\154\132%s\233\152\159\230\178\161\230\156\137\233\128\137\230\139\169\232\139\177\233\155\132\239\188\140\232\175\183\232\135\179\229\176\145\233\128\137\230\139\169\228\184\128\228\184\170\229\135\186\230\136\152\232\139\177\233\155\132", self.teamIndex)
      info = {
        autoText = tipStr,
        rightHandler = function()
        end
      }
      ed.showConfirmDialog(info)
      return
    else
      tipStr = T("\230\130\168\231\154\132%s\233\152\159\230\178\161\230\156\137\228\184\138\230\187\161%s\229\144\141\232\139\177\233\155\132, \230\152\175\229\144\166\231\187\167\231\187\173", self.teamIndex, self.requireNumPerTeam)
      info = {autoText = tipStr, rightHandler = callback}
      ed.showConfirmDialog(info)
    end
  else
    callback()
  end
end

function CreviceDefendBattlePrepareScene:onClickGoEvent()
  for teamIndex = 1, self.teamCount do
    local idArr = self.selfTeamIDs[teamIndex]
    if not idArr or #idArr < self.requireNumPerTeam then
      local tipStr
      if 1 == self.requireNumPerTeam then
        tipStr = T("\230\130\168\231\154\132%s\233\152\159\230\178\161\230\156\137\233\128\137\230\139\169\232\139\177\233\155\132\239\188\140\232\175\183\232\135\179\229\176\145\233\128\137\230\139\169\228\184\128\228\184\170\229\135\186\230\136\152\232\139\177\233\155\132", teamIndex)
      else
        tipStr = T("\230\130\168\231\154\132%s\233\152\159\230\178\161\230\156\137\228\184\138\230\187\161%s\229\144\141\232\139\177\233\155\132", teamIndex, self.requireNumPerTeam)
      end
      ed.showConfirmDialog({
        text = tipStr,
        rightText = T("\231\161\174\229\174\154"),
        skipDestroyAnim = true
      })
      return
    end
  end
  local data = {
    attackTeams = self.selfTeamIDs
  }
  self:setTeamData()
  ed.popScene()
  FireEvent("CREVICE_BATTLE_PREPARE_DONE", data)
end

function CreviceDefendBattlePrepareScene:onClickEnemyLeftEvent()
  if self.teamIndex <= 1 then
    return
  end
  self.teamIndex = self.teamIndex - 1
  self.teamIdxList:refresh(self.teamIndex)
  self:refreshMyTeamUI(true)
  self:refreshKarlElementByState()
  self.heroList:refreshHeroUI()
  self:refreshEnemyTeamUI(false)
  self:refreshBtnVisible()
  self:refreshRightUI()
end

function CreviceDefendBattlePrepareScene:onClickEnemyRightEvent()
  if self.teamIndex >= self.teamCount then
    return
  end
  self.teamIndex = self.teamIndex + 1
  self.teamIdxList:refresh(self.teamIndex)
  self:refreshMyTeamUI(true)
  self:refreshKarlElementByState()
  self.heroList:refreshHeroUI()
  self:refreshEnemyTeamUI(false)
  self:refreshBtnVisible()
  self:refreshRightUI()
end

function CreviceDefendBattlePrepareScene:onClickDeleteTeamEvent()
  ed.showConfirmDialog({
    text = T("\230\152\175\229\144\166\230\184\133\231\169\186\230\137\128\230\156\137\233\152\159\231\154\132\232\139\177\233\155\132"),
    rightText = T("\231\161\174\229\174\154"),
    skipDestroyAnim = true,
    rightHandler = function()
      self:clearAllMyTeam()
      self:refreshpreseHeros()
    end
  })
end

function CreviceDefendBattlePrepareScene:clearAllMyTeam()
  for i, v in ipairs(self.selfTeamIDs) do
    self.selfTeamIDs[i] = {}
  end
  for k, heroUI in pairs(self.myTeamUIArr) do
    heroUI.icon:stopAllActions()
    heroUI.icon:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.1), CCCallFunc:create(function()
      heroUI.icon:removeFromParentAndCleanup(true)
    end)))
  end
  self.myTeamUIArr = {}
  self:refreshKarlElementByState()
  self.heroList:refreshHeroUI()
  self:listenTimer(Timer:Once(0.01), function()
    self:refreshTeamTouchEvent()
  end)
  self:playMyTeamShine(0.1)
end

function CreviceDefendBattlePrepareScene:onPoolHeroHeadEvent(heroUI)
  if heroUI.isSelected then
    heroUI:deleteSelectTag()
    self:removeHeroFromMyTeam(self.teamIndex, heroUI.info.id)
    heroUI.teamIndex = nil
    heroUI:RemoveTeamInfo()
    self:refreshMyTeamUI()
    return
  end
  if #self.selfTeamIDs[self.teamIndex] >= member_count_max then
    lsr:report("clickAddHeroTeamFilled")
    ed.playEffect(ed.sound.deo.common_popup_small)
    ed.showToast(T("\229\143\170\232\131\189\233\128\137\230\139\1695\228\184\170\232\139\177\233\155\132"))
    self:playMyTeamShine(0.2)
    return
  end
  if heroUI.teamIndex and heroUI.teamIndex ~= self.teamIndex then
    local function callback()
      heroUI:RemoveTeamInfo()
      
      heroUI:deleteSelectTag()
      self:removeHeroFromMyTeam(heroUI.teamIndex, heroUI.info.id)
      heroUI.teamIndex = self.teamIndex
      heroUI:showSelectTag()
      heroUI:addLegendArenaTeamInfo({
        team_index = self.teamIndex
      })
      self:addHeroToMyTeam(self.teamIndex, heroUI.info.id)
      self:refreshMyTeamUI()
    end
    
    ed.showConfirmDialog({
      text = T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\229\156\168\229\133\182\228\187\150\233\152\159\228\188\141\228\184\173\239\188\140\230\152\175\229\144\166\231\167\187\229\138\168\229\136\176\232\191\153\230\148\175\233\152\159\228\188\141\239\188\159"),
      rightHandler = callback
    })
    return
  end
  lsr:report("clickHeadRemoveHero")
  heroUI.teamIndex = self.teamIndex
  heroUI:showSelectTag()
  heroUI:addLegendArenaTeamInfo({
    team_index = self.teamIndex
  })
  self:addHeroToMyTeam(self.teamIndex, heroUI.info.id)
  self:refreshKarlElementByState()
  self:refreshMyTeamUI()
  self.heroList:refreshHeroUI()
end

function CreviceDefendBattlePrepareScene:refreshTeamTouchEvent()
  for i = 1, member_count_max do
    local touchKey = "clickMyTeamIcon" .. i
    self:btRemoveMainTouchHandler({key = touchKey})
    local heroUI = self.myTeamUIArr[i]
    if nil ~= heroUI then
      self:btRegisterButtonClick({
        button = heroUI.icon,
        key = touchKey,
        param = {index = i},
        clickHandler = function(param)
          self:onTeamHeroHeadEvent(self.myTeamUIArr[param.index])
        end,
        force = true,
        pressScale = 0.95,
        clickInterval = 0.3,
        normalScale = 1
      })
    end
  end
end

function CreviceDefendBattlePrepareScene:clickRecommendView()
  ed.CreviceDefendNetWork:sendOpenRecommendView()
end

function CreviceDefendBattlePrepareScene:addPresetLayer(id)
  local thisCon = self.ui.isbg:getContentSize()
  local btn = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_enter_button.png", CCRectMake(15, 15, 5, 5))
  btn:setContentSize(CCSizeMake(106, 35))
  btn:setPosition(ccp(thisCon.width - 60, thisCon.height / 2 + 20))
  self.ui.layUp_ButOrBg:addChild(btn)
  self.btnShowPresetLay = btn
  local icon = ed.createSprite("UI/alpha/1080P/battle/preset/preset_enter_icon.png")
  icon:setPosition(ccp(18, 18))
  btn:addChild(icon)
  local label = ed.createttf(T("\233\162\132\232\174\190\233\152\181\229\174\185"), 16)
  label:setPosition(ccp(66, 17))
  label:setColor(ccc3(ed.colorToStr("#fef1a9")))
  btn:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self:btRegisterButtonClick({
    button = btn,
    key = "btnPreset",
    clickHandler = function()
      if self.isTouch then
        return
      end
      self:showPresetLayer(self)
    end,
    pressScale = 0.95,
    force = true
  })
  local addHeight = 0
  if self.curMode == "defend" then
    addHeight = 70
  end
  local layBgsSize = self.ui.layBgs:getContentSize()
  local presetBg = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_bg.png", CCRectMake(45, 70, 7, 16))
  presetBg:setContentSize(CCSizeMake(layBgsSize.width - 12, 350 + ed.display.halfFixedHeight * 2 + addHeight))
  presetBg:setPosition(ccp(layBgsSize.width / 2, layBgsSize.height / 2 + 30 + addHeight / 2))
  self.ui.layBgs:addChild(presetBg)
  self.touch = true
  local posX, posY = self.ui.panel_hero:getPosition()
  local con = self.ui.panel_hero:getContentSize()
  local info = {
    cliprect = CCRectMake(posX, posY, con.width, con.height),
    container = self.ui.panel_left,
    zorder = 20,
    bar = {
      bglen = con.height,
      bgpos = ccp(posX, posY + con.height / 2)
    },
    doPressIn = function(_, y)
      return y
    end,
    cancelPressIn = function(_, y, oldy)
      self.touch = math.abs(oldy - y) < 20
    end,
    noshade = true
  }
  self.presetDraglist = ed.draglist.create(info)
  label = ed.createttf("", 15)
  label:setAnchorPoint(ccp(0.5, 0.5))
  label:setPosition(ccp(45, 30))
  label:setColor(ccc3(ed.colorToStr("#FFFFE5")))
  presetBg:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self.teamNumlabel = label
  local btn = ed.createSprite("UI/alpha/1080P/common/button_mini_red.png")
  btn:setPosition(ccp(thisCon.width - 60, thisCon.height / 2 + 20))
  self.ui.layUp_ButOrBg:addChild(btn)
  btn:setVisible(false)
  self.btnExitPresetLay = btn
  local label = ed.createttf(T("\233\128\128\229\135\186\233\162\132\232\174\190"), 16)
  label:setPosition(ccp(52, 21))
  label:setColor(ccc3(ed.colorToStr("#FFFFE5")))
  btn:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self:btRegisterButtonClick({
    button = btn,
    key = "btnPresetExit",
    clickHandler = function()
      if self.isTouch then
        return
      end
      self:showPresetLayer(self)
    end,
    pressScale = 0.95,
    force = true
  })
  presetBg:setVisible(false)
  self.presetDraglist:setVisible(false)
  self.presetBg = presetBg
  self.groupId = 1
  self:refreshPresetLayer()
  local posX, posY = self.ui.panel_classify:getPosition()
  local con = self.ui.panel_classify:getContentSize()
  local info = {
    cliprect = CCRectMake(posX, posY, con.width, con.height),
    container = self.ui.layUp_ButOrBg,
    zorder = 10,
    noshade = true
  }
  self.buttonDraglist = ed.draglist.create(info)
  self.buttonPress = {}
  local resConfig = {}
  for i = 1, 4 do
    resConfig[i] = {}
    resConfig[i].textImg = string.format("UI/alpha/1080P/battle/preset/preset_num_%d.png", i)
    resConfig[i].button = "UI/alpha/1080P/battle/preset/preset_choose2_button.png"
    resConfig[i].press = "UI/alpha/1080P/battle/preset/preset_choose_button.png"
  end
  local posX = posX + 31
  local buttonIndex, widths = 0, 70
  for i, res in ipairs(resConfig) do
    buttonIndex = buttonIndex + 1
    local button = ed.createSprite(res.button)
    local press = ed.createSprite(res.press)
    local textImg = ed.createSprite(res.textImg)
    button:setPosition(ccp(posX + (buttonIndex - 1) * widths + 20, con.height - 5))
    press:setPosition(ccp(posX + (buttonIndex - 1) * widths + 20, con.height - 5))
    textImg:setPosition(ccp(posX + (buttonIndex - 1) * widths + 21, con.height - 5))
    button:setScale(0.9)
    press:setScale(0.9)
    self.buttonDraglist.listLayer:addChild(button)
    self.buttonDraglist.listLayer:addChild(press)
    self.buttonDraglist.listLayer:addChild(textImg)
    press:setVisible(self.groupId == i)
    self.buttonPress[i] = press
    self:btRegisterButtonClick({
      button = button,
      key = "listButton" .. i,
      clickHandler = function()
        if self.isTouch then
          return
        end
        if self.groupId ~= i then
          self.refreshIdx = nil
          self.buttonPress[self.groupId]:setVisible(false)
          self.groupId = i
          self:refreshPresetLayer()
          self.buttonPress[self.groupId]:setVisible(true)
          self:refreshKarlElementByState()
          self.heroList:refreshHeroUI()
        end
      end,
      pressScale = 0.85,
      normalScale = 0.9,
      force = true
    })
  end
  self.buttonDraglist:initListWidth(buttonIndex * widths)
  self.buttonDraglist:setVisible(false)
  self:listenEvent("scene_preset_reply", function(info)
    self.refreshIdx = nil
    local indexId, groupId = ed.presetData.analyzePreseIds(info.refreshIdx)
    if self.groupId ~= groupId then
      self.buttonPress[self.groupId]:setVisible(false)
      self.groupId = groupId
      self.buttonPress[self.groupId]:setVisible(true)
    end
    self.refreshIdx = indexId
    self:refreshPresetLayer()
    self:refreshKarlElementByState()
    self.heroList:refreshHeroUI()
  end)
end

function CreviceDefendBattlePrepareScene:refreshPresetLayer()
  local con = self.ui.panel_hero:getContentSize()
  local layBgsSize = self.ui.layBgs:getContentSize()
  self.teamNumlabel:setVisible(false)
  self.teamNumlabel:setString(ed.presetData.teamNum .. "/" .. ed.presetData.preseMaxTeam)
  self.presetDraglist:clearList()
  for i, v in ipairs(self.btnToucRemovehKey or {}) do
    self:btRemoveMainTouchHandler({key = v})
  end
  self.btnToucRemovehKey = {}
  self.heroPresetIcons = {}
  local showPosy, itemhand
  local posY, height, sizeH = con.height + 130, 10, 90
  for i, v in ipairs(ed.presetData.getPreseInfo(self.groupId)) do
    local itemBg = ed.createScale9Sprite("UI/alpha/1080P/skilltower/bg_had_get.png", CCRectMake(45, 70, 7, 16))
    itemBg:setContentSize(CCSizeMake(layBgsSize.width - 30, sizeH - 3))
    self.presetDraglist:addItem(itemBg, ccp(layBgsSize.width / 2 + 66, posY))
    local leftImg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_number_bg.png")
    leftImg:setPosition(layBgsSize.width / 9 - 5, sizeH / 2)
    itemBg:addChild(leftImg, 99)
    local label = ed.createttf(v.name or "", 15)
    label:setAnchorPoint(ccp(0.5, 0.5))
    label:setPosition(ccp(65.5, 35))
    label:setColor(ccc3(ed.colorToStr("#FFFFE5")))
    leftImg:addChild(label)
    ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
    local posx = layBgsSize.width / 8 + 12
    local width = 60 + (layBgsSize.width / 11 - 60)
    width = ed.clamp(width, 60, 100)
    local heros = v.heros or {}
    for s = 1, 5 do
      if heros[s] then
        local hero = ed.readhero.createIconByID(heros[s], {
          state = "idle",
          isShowLegendEquip = ed.openLegendEquip()
        })
        hero:showLegendEquip(ed.off_legendEquipOp)
        hero.icon:setPosition(posx + (6 - s) * width, sizeH / 2)
        itemBg:addChild(hero.icon)
        hero.icon:setScale(0.75)
        table.insert(self.heroPresetIcons, {
          id = heros[s],
          hero = hero
        })
      else
        local heroBg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head.png")
        heroBg:setPosition(posx + (6 - s) * width, sizeH / 2 - 0.5)
        itemBg:addChild(heroBg)
        heroBg:setScale(1.05)
      end
    end
    local settingImg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_round_button.png")
    settingImg:setPosition(layBgsSize.width * 0.74, sizeH / 2)
    itemBg:addChild(settingImg)
    local btnImgTop = ed.createSprite("UI/alpha/1080P/setting/setting_edit_icon.png")
    btnImgTop:setPosition(21, 22)
    settingImg:addChild(btnImgTop)
    btnImgTop:setScale(0.76)
    self:btRegisterButtonClick({
      button = settingImg,
      key = "settingImg" .. i,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if self.isTouch then
          return
        end
        if self.touch then
          if not ed.containsPoint(self.ui.panel_hero, x, y) then
            return
          end
          ed.UITool.openView("presetScene", {
            groupId = self.groupId,
            teamIdx = v.indexId,
            notAdd = true
          })
        end
      end,
      pressScale = 0.95,
      force = true
    })
    table.insert(self.btnToucRemovehKey, "settingImg" .. i)
    local passImg = ed.createScale9Sprite("UI/alpha/1080P/common/button_com_mini.png", CCRectMake(10, 10, 81.5, 20))
    passImg:setContentSize(CCSizeMake(90, 44))
    passImg:setPosition(layBgsSize.width * 0.86, sizeH / 2)
    itemBg:addChild(passImg)
    local label = ed.createttf("\228\189\191\231\148\168", 16)
    label:setPosition(ccp(45, 22))
    label:setColor(ccc3(ed.colorToStr("#FCF1A6")))
    passImg:addChild(label)
    ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
    self:btRegisterButtonClick({
      button = passImg,
      key = "passImg" .. i,
      clickInterval = 0.2,
      clickHandler = function(param, x, y)
        if self.isTouch then
          return
        end
        if not self.touch then
          return
        end
        if not ed.containsPoint(self.ui.panel_hero, x, y) then
          return
        end
        self.isTouch = true
        self.selfTeamIDs[self.teamIndex] = self:excludeHeros(ed.copyTable(v.heros or {}))
        self:refreshKarlElementByState()
        self.heroList:refreshHeroList()
        self.teamIdxList:refresh(self.teamIndex)
        self:refreshMyTeamUI()
        self:listenTimer(Timer:Once(0.2), function()
          self.isTouch = false
        end)
      end,
      pressScale = 0.95,
      force = true
    })
    table.insert(self.btnToucRemovehKey, "passImg" .. i)
    posY = posY - sizeH
    height = height + sizeH
    if self.refreshIdx == v.indexId then
      showPosy = height
      itemhand = itemBg
    end
  end
  local addTeamImgBg = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_addteam_bg.png", CCRectMake(45, 40, 5, 25))
  addTeamImgBg:setContentSize(CCSizeMake(layBgsSize.width - 20, sizeH + 4))
  addTeamImgBg:setPosition(layBgsSize.width / 2 + 68, posY)
  self.presetDraglist.listLayer:addChild(addTeamImgBg)
  height = height + sizeH
  local addImg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_add.png")
  addImg:setPosition(layBgsSize.width * 0.3, sizeH / 2)
  addTeamImgBg:addChild(addImg)
  addImg:setScale(1.24)
  local label = ed.createttf(T("\231\130\185\229\135\187\229\162\158\229\138\160\230\150\176\233\162\132\232\174\190\233\152\181\229\174\185"), 24)
  label:setPosition(ccp(layBgsSize.width * 0.51, sizeH / 2))
  label:setColor(ccc3(ed.colorToStr("#FFFCE7")))
  addTeamImgBg:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#674907")), 1)
  ed.layout.horizontalSortNode({addImg, label}, {-10, 0}, layBgsSize.width * 0.5)
  self:btRegisterButtonClick({
    button = addTeamImgBg,
    key = "addTeamImgBg",
    clickInterval = 1,
    extraCheckHandler = function(x, y)
      return ed.containsPoint(self.ui.panel_hero, x, y)
    end,
    clickHandler = function(param, x, y)
      if self.isTouch then
        return
      end
      if not self.touch then
        return
      end
      if not ed.presetData.canAdd() then
        ed.showToast("\233\152\181\229\174\185\230\149\176\233\135\143\229\183\178\232\190\190\228\184\138\233\153\144\239\188\129")
        return
      end
      local teamIdx = ed.presetData.getPreseTeamNewIndexId(self.groupId)
      if teamIdx then
        ed.UITool.openView("presetScene", {
          groupId = self.groupId,
          teamIdx = teamIdx,
          notAdd = false
        })
      else
        error("\230\151\160\230\179\149\229\162\158\229\138\160\233\152\181\229\174\185")
      end
    end,
    pressScale = 0.98,
    force = true
  })
  table.insert(self.btnToucRemovehKey, "addTeamImgBg")
  self.presetDraglist:initListHeight(height)
  if showPosy then
    showPosy = showPosy - (con.height + 130) / 2
    showPosy = ed.clamp(showPosy, 0, height - con.height)
    showPosy = showPosy < 0 and 0 or showPosy
    self.presetDraglist.listLayer:setPositionY(showPosy)
    local move1 = CCEaseBackOut:create(CCMoveBy:create(0.1, ccp(-5, 0)))
    local move2 = CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(8, 0)))
    local move3 = CCEaseBackOut:create(CCMoveBy:create(0.1, ccp(-3, 0)))
    local sequence = CCSequence:create(ccArrayMake(move1, move2, move3))
    itemhand:runAction(sequence)
  end
  self:refreshpreseHeros()
end

function CreviceDefendBattlePrepareScene:excludeHeros(heros)
  local goStageId = {}
  for i, v in ipairs(self.selfTeamIDs) do
    for ii, vv in ipairs(v) do
      goStageId[vv] = i
    end
  end
  local newHeros = {}
  for i, v in ipairs(heros) do
    if not goStageId[v] or goStageId[v] == self.teamIndex then
      table.insert(newHeros, v)
    end
  end
  return newHeros
end

function CreviceDefendBattlePrepareScene:refreshpreseHeros()
  if not self.presetBg or not self.presetBg:isVisible() then
    return
  end
  local goStageId = {}
  for i, v in ipairs(self.selfTeamIDs) do
    for ii, vv in ipairs(v) do
      goStageId[vv] = i
    end
  end
  for i, v in ipairs(self.heroPresetIcons) do
    if goStageId[v.id] then
      v.hero:showSelectTag()
      v.hero:addLegendArenaTeamInfo({
        team_index = goStageId[v.id]
      })
      local posx, posy = v.hero.team_info_node:getPosition()
      v.hero.team_info_node:setPosition(posx - 10, posy - 7)
    else
      v.hero:deleteSelectTag()
      v.hero:RemoveTeamInfo()
    end
  end
end

function CreviceDefendBattlePrepareScene:showPresetLayer()
  local isShow = self.presetBg:isVisible()
  self.presetBg:setVisible(not isShow)
  self.ui.panel_classify:setVisible(isShow)
  self.heroList.draglist:setVisible(isShow)
  self.ui.isbg:setVisible(isShow)
  self.btnShowPresetLay:setVisible(isShow)
  self.btnExitPresetLay:setVisible(not isShow)
  self.presetDraglist:setVisible(not isShow)
  self.buttonDraglist:setVisible(not isShow)
  if not isShow then
    self:refreshpreseHeros()
  end
end
