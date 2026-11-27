local base = ed.ui.popwindow
local CupArenaChallengeResultWin = newclass(base.mt)
ed.ui.CupArenaChallengeResultWin = CupArenaChallengeResultWin
local TOTAL_SCORE_TO_PATH = {
  [0] = "UI/alpha/1080P/battle/battle_stage_0.png",
  [1] = "UI/alpha/1080P/battle/battle_stage_1.png",
  [2] = "UI/alpha/1080P/battle/battle_stage_2.png",
  [3] = "UI/alpha/1080P/battle/battle_stage_3.png",
  [4] = "UI/alpha/1080P/battle/battle_stage_4.png",
  [5] = "UI/alpha/1080P/battle/battle_stage_5.png",
  [6] = "UI/alpha/1080P/battle/battle_stage_6.png",
  [7] = "UI/alpha/1080P/battle/battle_stage_7.png"
}
local TeamUIConfig = {
  [1] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_1.png",
    gsBgPath = "UI/alpha/1080P/cuparena/cuparena_defense_gs_1.png",
    teamColor = ed.toccc3(16775585),
    teamStrokeColor = ed.toccc3(11954462)
  },
  [2] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_2.png",
    gsBgPath = "UI/alpha/1080P/cuparena/cuparena_defense_gs_2.png",
    teamColor = ed.toccc3(12910590),
    teamStrokeColor = ed.toccc3(2455953)
  },
  [3] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_3.png",
    gsBgPath = "UI/alpha/1080P/cuparena/cuparena_defense_gs_3.png",
    teamColor = ed.toccc3(16770763),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [4] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_4.png",
    gsBgPath = "UI/alpha/1080P/cuparena/cuparena_defense_gs_4.png",
    teamColor = ed.toccc3(16771503),
    teamStrokeColor = ed.toccc3(10240554)
  },
  [5] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_5.png",
    gsBgPath = "UI/alpha/1080P/cuparena/cuparena_defense_gs_5.png",
    teamColor = ed.toccc3(13625343),
    teamStrokeColor = ed.toccc3(2379449)
  },
  [6] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_6.png",
    gsBgPath = "UI/alpha/1080P/cuparena/cuparena_defense_gs_6.png",
    teamColor = ed.toccc3(16776423),
    teamStrokeColor = ed.toccc3(7221115)
  },
  [7] = {
    bgPath = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_7.png",
    gsBgPath = "UI/alpha/1080P/cuparena/cuparena_defense_gs_7.png",
    teamColor = ed.toccc3(16514997),
    teamStrokeColor = ed.toccc3(8621085)
  }
}

function CupArenaChallengeResultWin.create(params)
  local self = base.create("CupArenaChallengeResultWin")
  setmetatable(self, CupArenaChallengeResultWin.mt)
  self:init(params)
  self:show()
  self:popWindow()
  return self
end

function CupArenaChallengeResultWin:init(params)
  self.isReplay = params.isReplay or false
  self.battleReplay = params.battleReplay or {}
  self.medalChange = params.medalChange
  self.medalExtra = params.medalExtra or 0
  self.selfOldScore = params.selfOldScore
  self.selfNewScore = params.selfNewScore
  self.oppoOldScore = params.oppoOldScore
  self.oppoNewScore = params.oppoNewScore
  self.isAudition = params.isAudition
  self:initUI()
  self:refreshUI()
  self:registerTouchHandlers()
  self:registerEvents()
end

function CupArenaChallengeResultWin:initUI()
  ed.editorui(ed.uieditor.CupArenaChallengeResultWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  if self.medalChange then
    local bgSize = self.ui.image_bg:getContentSize()
    self.ui.image_bg:setContentSize(CCSizeMake(bgSize.width, bgSize.height + 50))
    if self.medalChange > 0 then
      local str
      if 0 < self.medalExtra then
        str = self.medalChange - self.medalExtra .. "+" .. self.medalExtra
      else
        str = "+" .. self.medalChange
      end
      ed.setLabelString(self.ui.label_medal, str)
    else
      ed.setLabelString(self.ui.label_medal, self.medalChange)
    end
    self.ui.bg_line:setVisible(true)
  else
    self.ui.bg_line:setVisible(true)
  end
  self.ui.label_medal:setVisible(false)
  self.ui.img_medal:setVisible(false)
end

function CupArenaChallengeResultWin:initLabels()
  ed.setLabelFontName(self.ui.label_score_1, ed.fontBold)
  ed.setLabelStroke(self.ui.label_score_1, ed.toccc3(1711439), 1)
  ed.setLabelFontName(self.ui.label_score_2, ed.fontBold)
  ed.setLabelStroke(self.ui.label_score_2, ed.toccc3(4525325), 1)
end

function CupArenaChallengeResultWin:refreshUI()
  self:refreshBattleReplay()
  self:refreshLeftPlayerInfo()
  self:refreshRightPlayerInfo()
  if self.medalChange then
    self:showMedalRewardAnim()
  end
end

function CupArenaChallengeResultWin:createTeamItem(index, teamData)
  local container, ui = ed.editorui(ed.uieditor.CupArenaChallengeResultItem)
  container:setContentSize(ui.bg:getContentSize())
  ui.index = index
  ed.setLabelFontName(ui.label_result_fail, ed.fontBold)
  ed.setLabelStroke(ui.label_result_fail, ed.toccc3(7759020), 1)
  ui.label_result_fail:limitWidthByScale(40)
  ed.setLabelFontName(ui.label_result_win, ed.fontBold)
  ed.setLabelStroke(ui.label_result_win, ed.toccc3(13130498), 1)
  ui.label_result_win:limitWidthByScale(40)
  local uiConfig = TeamUIConfig[index]
  ed.setScale9SpriteTexture(ui.bg_img, uiConfig.bgPath)
  ui.bg_img:setContentSize(CCSizeMake(1110, 76))
  ui.bg_img:setScale(0.8)
  local teamAutoText = ed.ui.autoText.new()
  teamAutoText:initParam({
    fontSize = 16,
    context = T("<lable fontSize=f16>%d</lable><lable fontSize=f13>\233\152\159</lable>", index),
    color = uiConfig.teamColor,
    strokeColor = uiConfig.teamStrokeColor,
    strokeSize = 1,
    fontName = ed.fontBold
  })
  ui.bg:addChild(teamAutoText.node)
  local curWidth, _ = teamAutoText:getCurContentSize()
  local curScale = math.min(1, 35 / curWidth)
  teamAutoText.node:setPosition(ccp(33 - curWidth * curScale * 0.5, 30))
  teamAutoText.node:setScale(curScale)
  local isWin
  if ed.getRoleId() == teamData._self_user._role_id then
    isWin = teamData._result == "victory"
  elseif ed.getRoleId() == teamData._oppo_user._role_id then
    isWin = teamData._result == "defeat"
  else
    isWin = teamData._result == "victory"
  end
  ui.image_result_win:setVisible(isWin)
  ui.image_result_fail:setVisible(not isWin)
  self:createHeroList(ui.panel_hero_left, teamData._self_heroes, "right")
  self:createHeroList(ui.panel_hero_right, teamData._oppo_heroes, "left")
  return container, ui
end

function CupArenaChallengeResultWin:createHeroList(container, heroData, align)
  ed.readhero.sortIDByRange(heroData._heroes or {}, function(tab)
    return tab._tid
  end)
  container:removeAllChildrenWithCleanup(true)
  local containerSize = container:getContentSize()
  for i, v in ipairs(heroData._heroes or {}) do
    local heroInfo = ed.readhero.createIconByServer(v, {state = "idle"})
    local icon = heroInfo.icon
    heroInfo:showLegendEquip(not ed.openLegendEquip())
    container:addChild(icon)
    icon:setScale(0.6)
    if align == "left" then
      icon:setPosition(ccp((i - 0.5) * 50, containerSize.height * 0.5))
    elseif align == "right" then
      icon:setPosition(ccp(containerSize.width - (i - 0.5) * 50, containerSize.height * 0.5))
    end
  end
end

function CupArenaChallengeResultWin:refreshLeftPlayerInfo()
  if nil == self.selfNewScore or nil == self.selfOldScore then
    self.ui.label_score_1:setVisible(false)
    self.ui.panel_score_left:setVisible(false)
    self.ui.bg_score:setVisible(false)
    self.ui.label_change_left:setVisible(false)
    self.ui.image_up_left:setVisible(false)
    self.ui.image_down_left:setVisible(false)
  else
    self.ui.label_score_1:setVisible(true)
    self.ui.panel_score_left:setVisible(true)
    self.ui.bg_score:setVisible(true)
    local scoreChange = self.selfNewScore - self.selfOldScore
    if scoreChange and scoreChange < 0 then
      ed.setLabelColor(self.ui.label_change_left, ed.toccc3(16755586))
      ed.setLabelStroke(self.ui.label_change_left, ed.toccc3(3080450), 1)
      ed.setLabelString(self.ui.label_change_left, scoreChange)
      self.ui.image_up_left:setVisible(false)
      self.ui.image_down_left:setVisible(true)
    elseif scoreChange and 0 < scoreChange then
      ed.setLabelColor(self.ui.label_change_left, ed.toccc3(5170756))
      ed.setLabelStroke(self.ui.label_change_left, ed.toccc3(0), 1)
      ed.setLabelString(self.ui.label_change_left, scoreChange)
      self.ui.image_up_left:setVisible(true)
      self.ui.image_down_left:setVisible(false)
    else
      ed.setLabelColor(self.ui.label_change_left, ccc3(180, 254, 139))
      ed.setLabelStroke(self.ui.label_change_left, ed.toccc3(3080450), 1)
      ed.setLabelString(self.ui.label_change_left, T("\228\191\157\230\138\164\228\184\173"))
      self.ui.image_up_left:setVisible(false)
      self.ui.image_down_left:setVisible(false)
    end
    local scoreNodeLeft = ed.getNumberNode({
      text = self.selfNewScore or 0,
      folder = "peak_score"
    }).node
    self.ui.panel_score_left:addChild(scoreNodeLeft)
    local scorePanelSize = self.ui.panel_score_left:getContentSize()
    scoreNodeLeft:setScale(0.8)
    scoreNodeLeft:setPositionY(scorePanelSize.height * 0.5)
    ed.layout.horizontalSortNode({
      self.ui.label_change_left,
      self.ui.image_up_left,
      self.ui.image_down_left,
      scoreNodeLeft
    }, {
      0,
      5,
      5,
      0
    }, scorePanelSize.width, 1)
  end
  local recordsList = self.battleReplay._records
  local attackerSummary = recordsList[1]._self_user
  local name = ed.getPlayerName(attackerSummary._name, attackerSummary._medal, {
    medalRight = false,
    disableOffset = true,
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "image_summary_bg", "label_name_left", name)
  local myHead = ed.getWholeHeadIcon({
    id = attackerSummary._avatar,
    level = attackerSummary._level,
    scale = 0.68,
    lvoffset = {x = -47, y = -25}
  })
  self.ui.panel_head_left:addChild(myHead)
  ed.layout.centerInParent(myHead)
end

function CupArenaChallengeResultWin:refreshRightPlayerInfo()
  if nil == self.selfNewScore or nil == self.selfOldScore then
    self.ui.label_score_2:setVisible(false)
    self.ui.panel_score_right:setVisible(false)
    self.ui.bg_score:setVisible(false)
    self.ui.label_change_right:setVisible(false)
    self.ui.image_up_right:setVisible(false)
    self.ui.image_down_right:setVisible(false)
  else
    self.ui.label_score_2:setVisible(true)
    self.ui.panel_score_right:setVisible(true)
    self.ui.bg_score:setVisible(true)
    local scoreChange = self.oppoNewScore - self.oppoOldScore
    if scoreChange and scoreChange < 0 then
      ed.setLabelColor(self.ui.label_change_right, ed.toccc3(16755586))
      ed.setLabelStroke(self.ui.label_change_right, ed.toccc3(3080450), 1)
      ed.setLabelString(self.ui.label_change_right, scoreChange)
      self.ui.image_up_right:setVisible(false)
      self.ui.image_down_right:setVisible(true)
    elseif scoreChange and 0 < scoreChange then
      ed.setLabelColor(self.ui.label_change_right, ed.toccc3(5170756))
      ed.setLabelStroke(self.ui.label_change_right, ed.toccc3(0), 1)
      ed.setLabelString(self.ui.label_change_right, scoreChange)
      self.ui.image_up_right:setVisible(true)
      self.ui.image_down_right:setVisible(false)
    else
      ed.setLabelColor(self.ui.label_change_right, ccc3(180, 254, 139))
      ed.setLabelStroke(self.ui.label_change_right, ed.toccc3(3080450), 1)
      ed.setLabelString(self.ui.label_change_right, T("\228\191\157\230\138\164\228\184\173"))
      self.ui.image_up_right:setVisible(false)
      self.ui.image_down_right:setVisible(false)
    end
    local scoreNodeRight = ed.getNumberNode({
      text = self.oppoNewScore or 0,
      folder = "peak_score"
    }).node
    self.ui.panel_score_right:addChild(scoreNodeRight)
    local scorePanelSize = self.ui.panel_score_right:getContentSize()
    scoreNodeRight:setScale(0.8)
    scoreNodeRight:setPositionY(scorePanelSize.height * 0.5)
    ed.layout.horizontalSortNode({
      scoreNodeRight,
      self.ui.image_up_right,
      self.ui.image_down_right,
      self.ui.label_change_right
    }, {
      5,
      0,
      0,
      0
    }, 0, 0)
  end
  local recordsList = self.battleReplay._records
  local oppoSummary = recordsList[1]._oppo_user
  local name = ed.getPlayerName(oppoSummary._name, oppoSummary._medal, {
    medalRight = true,
    disableOffset = true,
    anchorPoint = ccp(1, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "image_summary_bg", "label_name_right", name)
  local oppoHead = ed.getWholeHeadIcon({
    id = oppoSummary._avatar,
    level = oppoSummary._level,
    scale = 0.68,
    lvoffset = {x = -47, y = -25}
  })
  self.ui.panel_head_right:addChild(oppoHead)
  ed.layout.centerInParent(oppoHead)
end

function CupArenaChallengeResultWin:getPos(i)
  local size = self.ui.panel_record:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 62
  local itemSpace = 2
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaChallengeResultWin:getHeight(num)
  local itemHeight = 62
  local itemSpace = 2
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaChallengeResultWin:getCancelPressInHandler()
  local function handler(x, y, ui)
    if ui then
      ui.btn_detail:setScale(0.7)
      
      ui.btn_record:setScale(0.7)
    end
  end
  
  return handler
end

function CupArenaChallengeResultWin:getPressInHandler()
  local function handler(x, y)
    for i, ui in ipairs(self.recordUIArr) do
      if ed.containsPoint(ui.btn_detail, x, y) then
        ui.btn_detail:setScale(0.65)
        
        return ui
      elseif ed.containsPoint(ui.btn_record, x, y) then
        ui.btn_record:setScale(0.65)
        return ui
      end
    end
  end
  
  return handler
end

function CupArenaChallengeResultWin:getClickInHandler()
  local function handler(x, y, ui)
    if ui then
      if ed.containsPoint(ui.btn_detail, x, y) then
        self:onDetailEvent(ui.index)
      elseif ed.containsPoint(ui.btn_record, x, y) then
        self:onRecordEvent(ui.index)
      end
    end
  end
  
  return handler
end

function CupArenaChallengeResultWin:refreshBattleReplay()
  local winCount = 0
  local defeatCount = 0
  local recordList = self.battleReplay._records
  if nil == self.ui.recordDraglist then
    self.ui.recordDraglist = ed.UITool.createDraglist(self.ui.panel_record, {
      priority = -300,
      doPressIn = self:getPressInHandler(),
      doClickIn = self:getClickInHandler(),
      cancelPressIn = self:getCancelPressInHandler()
    })
    self.refreshCliprectConfig = {
      draglist = self.ui.recordDraglist
    }
  else
    self.ui.recordDraglist:clearList()
  end
  self.recordUIArr = {}
  local recordNum = 0
  for i, v in ipairs(recordList) do
    local itemContainer, itemUI = self:createTeamItem(i, v)
    self.ui.recordDraglist:addItem(itemContainer)
    itemContainer:setPosition(self:getPos(i))
    recordNum = recordNum + 1
    table.insert(self.recordUIArr, itemUI)
    local result = v._result
    if result == "victory" then
      winCount = winCount + 1
    else
      defeatCount = defeatCount + 1
    end
  end
  self.ui.recordDraglist:initListHeight(self:getHeight(#recordList))
  ed.setTexture(self.ui.image_total_score_left, TOTAL_SCORE_TO_PATH[winCount])
  ed.setTexture(self.ui.image_total_score_right, TOTAL_SCORE_TO_PATH[defeatCount])
  local isWin
  if ed.getRoleId() == recordList[1]._self_user._role_id then
    isWin = winCount > defeatCount
  elseif ed.getRoleId() == recordList[1]._oppo_user._role_id then
    isWin = winCount < defeatCount
  else
    isWin = winCount > defeatCount
  end
  if isWin then
    self:addWinAnim()
  else
    self:addLoseAnim()
  end
end

function CupArenaChallengeResultWin:addWinLoseAnim()
end

function CupArenaChallengeResultWin:addWinAnim()
  if not self.isReplay then
    ed.playEffect(ed.sound.deo.battle_win)
  end
  local light = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(light)
  self.ui.panel_win_anim:addChild(light)
  local image_bg = ed.createSprite("UI/alpha/1080P/battleresult/new_resource/victory_bg.png")
  local image_win_text = ed.createSprite("UI/alpha/1080P/battleresult/new_resource/victory.png")
  image_bg:addChild(image_win_text)
  image_win_text:setPosition(ccp(264, 60))
  self.ui.panel_win_anim:addChild(image_bg, 1)
  local victoryWings = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(victoryWings)
  victoryWings:setPosition(ccp(0, 57))
  self.ui.panel_win_anim:addChild(victoryWings)
  local particles = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(particles)
  particles:setPosition(ccp(0, 57))
  self.ui.panel_win_anim:addChild(particles)
end

function CupArenaChallengeResultWin:addLoseAnim()
  if not self.isReplay then
    ed.playEffect(ed.sound.deo.battle_lose)
  end
  local failWings = ed.createFcaNode("eff_UI_pve_fail_wings")
  self:addFca(failWings)
  self.ui.panel_fail_anim:addChild(failWings)
  failWings:setPosition(ccp(0, 13))
  local image_bg = ed.createSprite("UI/alpha/1080P/battleresult/new_resource/fail_bg.png")
  self.ui.panel_fail_anim:addChild(image_bg)
  local failText
  if ed.isAreaZhCn() then
    failText = ed.createFcaNode("eff_UI_battleresult_fail")
    self:addFca(failText)
  else
    failText = ed.createSprite("UI/alpha/1080P/battleresult/battleresult_fail.png")
  end
  self.ui.panel_fail_anim:addChild(failText)
end

function CupArenaChallengeResultWin:showMedalRewardAnim()
  local delayAction1 = CCDelayTime:create(0.5)
  local delayCallAction1 = CCCallFunc:create(function()
    xpcall(function()
      self.ui.img_medal:setScale(2)
      self.ui.img_medal:setVisible(true)
    end, EDDebug)
  end)
  local scaleAction1 = CCScaleTo:create(0.1, 1)
  self.ui.img_medal:runAction(ed.readaction.create({
    t = "seq",
    delayAction1,
    delayCallAction1,
    scaleAction1
  }))
  local delayAction2 = CCDelayTime:create(0.5)
  local delayCallAction2 = CCCallFunc:create(function()
    xpcall(function()
      self.ui.label_medal:setScale(2)
      self.ui.label_medal:setVisible(true)
    end, EDDebug)
  end)
  local scaleAction2 = CCScaleTo:create(0.1, 1)
  self.ui.label_medal:runAction(ed.readaction.create({
    t = "seq",
    delayAction2,
    delayCallAction2,
    scaleAction2
  }))
end

function CupArenaChallengeResultWin:registerTouchHandlers()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if self.isDestroyed then
        return
      end
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.image_bg, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and self.clickOutSide then
        if not self.isReplay then
          local winCount = 0
          local defeatCount = 0
          local recordList = self.battleReplay._records
          for i, v in ipairs(recordList) do
            if v._result == "victory" then
              winCount = winCount + 1
            else
              defeatCount = defeatCount + 1
            end
          end
          FireEvent("EventCupArenaChallengeComplete", {
            targetRoleId = recordList[1]._oppo_user._role_id,
            isWin = winCount > defeatCount,
            targetScore = self.oppoNewScore
          })
          self:destroy({skipAnim = true})
        else
          self:destroy()
        end
      end
      return false
    end,
    key = "close"
  })
end

function CupArenaChallengeResultWin:onDetailEvent(index)
  local recordData = self.battleReplay._records[index]
  if not recordData then
    return
  end
  ed.CupArenaNetwork:sendQuerySummary(recordData._checkid, recordData._round, recordData._match_id)
end

function CupArenaChallengeResultWin:onRecordEvent(index)
  local recordData = self.battleReplay._records[index]
  if not recordData then
    ed.showToast(T("\230\154\130\230\151\160\229\189\149\229\131\143"))
    return
  end
  ed.CupArenaManager:enterReplay(recordData, recordData._round, false, self.isAudition)
end

function CupArenaChallengeResultWin:registerEvents()
end
