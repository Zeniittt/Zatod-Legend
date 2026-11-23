local base = ed.ui.popwindow
local PeakArenaChallengeResultWin = newclass(base.mt)
ed.ui.PeakArenaChallengeResultWin = PeakArenaChallengeResultWin
local TOTAL_SCORE_TO_PATH = {
  [0] = "UI/alpha/1080P/battle/battle_stage_0.png",
  [1] = "UI/alpha/1080P/battle/battle_stage_1.png",
  [2] = "UI/alpha/1080P/battle/battle_stage_2.png",
  [3] = "UI/alpha/1080P/battle/battle_stage_3.png",
  [4] = "UI/alpha/1080P/battle/battle_stage_4.png",
  [5] = "UI/alpha/1080P/battle/battle_stage_5.png"
}
PeakArenaChallengeResultWin.TOTAL_SCORE_TO_PATH = TOTAL_SCORE_TO_PATH
ed.UITool.registViewOpenFunc("PeakArenaChallengeResultWin", function(params)
  PeakArenaChallengeResultWin.create(params):popWindow()
end)

function PeakArenaChallengeResultWin.create(params)
  local self = base.create("PeakArenaChallengeResultWin")
  setmetatable(self, PeakArenaChallengeResultWin.mt)
  self:init(params)
  return self
end

function PeakArenaChallengeResultWin:init(params)
  local data = params.data or {}
  self.data = ed.copyProto(data)
  self.result = nil
  self.closeCallback = params.closeCallback
  self.recordsList = self.data._battle_replay._records
  self.myUserSummary = self.recordsList[1]._self_user
  self.oppoUserSummary = self.recordsList[1]._oppo_user
  self.isAttacker = ed.getRoleId() == self.myUserSummary._role_id
  self.baseCoin = ed.getDataTable("PeakArenaConfig")["Base Coin"].Value[1]
  self.coin = self.data._coins
  self.isEvolving = params.isEvolving or false
  self.isReplay = params.isReplay or false
  self.isLoseProtect = params.isLoseProtect or false
  self:initUI()
  self:refreshUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:show()
end

function PeakArenaChallengeResultWin:initUI()
  local container, ui = ed.editorui(ed.uieditor.PeakArenaChallengeResultWin)
  self.ui = ui
  self.container:addChild(container)
  self:initLabels()
  local scaleAction1 = CCFadeTo:create(1.5, 100)
  local scaleAction2 = CCFadeTo:create(1.5, 255)
  local lsequence = CCSequence:createWithTwoActions(scaleAction1, scaleAction2)
  self.ui.label_close_tips:runAction(CCRepeatForever:create(lsequence))
  self.ui.image_protect_right:setVisible(self.isLoseProtect)
  if self.coin then
    local bgSize = self.ui.image_bg:getContentSize()
    self.ui.image_bg:setContentSize(CCSizeMake(bgSize.width, bgSize.height + 30))
    local icon = ed.createSprite("UI/alpha/1080P/icon/peakshop.png")
    self.coinIcon = icon
    icon:setScale(1)
    self.ui.image_bg:addChild(icon)
    icon:setPosition(ccp(485, 37))
    local amount
    local coinDiff = self.coin - self.baseCoin
    if coinDiff <= 0 then
      amount = ed.createttf(string.format("%s", self.baseCoin), 23)
    else
      amount = ed.createttf(string.format("%s+%s", self.baseCoin, coinDiff), 23)
    end
    self.coinAmountLabel = amount
    ed.setLabelColor(amount, ccc3(255, 245, 176))
    ed.setLabelStroke(amount, ed.toccc3(9719835), 1)
    self.ui.image_bg:addChild(amount)
    amount:setPosition(ccp(525, 37))
    self.ui.label_close_tips:setVisible(false)
    ed.layout.horizontalSortNode({icon, amount}, {2}, self.ui.image_bg:getContentSize().width * 0.5)
    icon:setVisible(false)
    amount:setVisible(false)
  end
  local size = self.ui.panel_battle_info:getContentSize()
  self.ui.panel_battle_info:setClipRect(CCRectMake(0, 0, size.width, size.height))
  local container = self.ui.panel_battle_info
  local posy, old = 0, 0
  container:registerScriptTouchHandler(function(event, x, y)
    if self.teamCount <= 3 then
      return
    end
    local posh = (self.teamCount - 3) * 70
    if event == "began" then
      posy = y
      old = self.ui.item_layer:getPositionY()
      self.ui.item_layer:stopAllActions()
      return ed.containsPoint(self.ui.panel_battle_info, x, y)
    elseif event == "moved" then
      self.ui.item_layer:setPositionY(old - (posy - y))
    elseif event == "ended" then
      local new = self.ui.item_layer:getPositionY()
      if new < 0 then
        self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
      elseif posh < new then
        self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, posh))))
      elseif math.abs(old - new) > 5 then
        self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, 0 < posy - y and -30 or 30))))
      end
      self.notPass = math.abs(posy - y) > 5
    end
  end, false, -300, false)
  container:setTouchEnabled(true)
end

function PeakArenaChallengeResultWin:initLabels()
  ed.setLabelStroke(self.ui.label_protect_right, ed.toccc3(3080450), 1)
  ed.setLabelFontName(self.ui.label_score_1, ed.fontBold)
  ed.setLabelStroke(self.ui.label_score_1, ed.toccc3(3290478), 1)
  ed.setLabelFontName(self.ui.label_score_2, ed.fontBold)
  ed.setLabelStroke(self.ui.label_score_2, ed.toccc3(7808293), 1)
  local c = ed.toccc3(7759020)
  ed.setLabelFontName(self.ui.label_result_fail_1, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_fail_2, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_fail_3, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_fail_4, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_fail_5, ed.fontBold)
  ed.setLabelStroke(self.ui.label_result_fail_1, c, 1)
  ed.setLabelStroke(self.ui.label_result_fail_2, c, 1)
  ed.setLabelStroke(self.ui.label_result_fail_3, c, 1)
  ed.setLabelStroke(self.ui.label_result_fail_4, c, 1)
  ed.setLabelStroke(self.ui.label_result_fail_5, c, 1)
  c = ed.toccc3(13130498)
  ed.setLabelFontName(self.ui.label_result_win_1, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_win_2, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_win_3, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_win_4, ed.fontBold)
  ed.setLabelFontName(self.ui.label_result_win_5, ed.fontBold)
  ed.setLabelStroke(self.ui.label_result_win_1, c, 1)
  ed.setLabelStroke(self.ui.label_result_win_2, c, 1)
  ed.setLabelStroke(self.ui.label_result_win_3, c, 1)
  ed.setLabelStroke(self.ui.label_result_win_4, c, 1)
  ed.setLabelStroke(self.ui.label_result_win_5, c, 1)
  self.ui.label_result_fail_1:limitWidthByScale(40)
  self.ui.label_result_fail_2:limitWidthByScale(40)
  self.ui.label_result_fail_3:limitWidthByScale(40)
  self.ui.label_result_fail_4:limitWidthByScale(40)
  self.ui.label_result_fail_5:limitWidthByScale(40)
  self.ui.label_result_win_1:limitWidthByScale(40)
  self.ui.label_result_win_2:limitWidthByScale(40)
  self.ui.label_result_win_3:limitWidthByScale(40)
  self.ui.label_result_win_4:limitWidthByScale(40)
  self.ui.label_result_win_5:limitWidthByScale(40)
  local teamAutoText1 = ed.ui.autoText.new()
  teamAutoText1:initParam({
    fontSize = 16,
    context = T("<lable fontSize=f16>%d</lable><lable fontSize=f13>\233\152\159</lable>", 1),
    color = ed.toccc3(16775585),
    strokeColor = ed.toccc3(13398038),
    strokeSize = 1,
    fontName = ed.fontBold
  })
  self.ui.image_team_1:addChild(teamAutoText1.node)
  local curWidth, _ = teamAutoText1:getCurContentSize()
  local curScale = math.min(1, 35 / curWidth)
  teamAutoText1.node:setPosition(ccp(33 - curWidth * curScale * 0.5, 30))
  teamAutoText1.node:setScale(curScale)
  local teamAutoText2 = ed.ui.autoText.new()
  teamAutoText2:initParam({
    fontSize = 16,
    context = T("<lable fontSize=f16>%d</lable><lable fontSize=f13>\233\152\159</lable>", 2),
    color = ed.toccc3(11270134),
    strokeColor = ed.toccc3(3890862),
    strokeSize = 1,
    fontName = ed.fontBold
  })
  self.ui.image_team_2:addChild(teamAutoText2.node)
  local curWidth, _ = teamAutoText2:getCurContentSize()
  local curScale = math.min(1, 35 / curWidth)
  teamAutoText2.node:setPosition(ccp(33 - curWidth * curScale * 0.5, 30))
  teamAutoText2.node:setScale(curScale)
  local teamAutoText3 = ed.ui.autoText.new()
  teamAutoText3:initParam({
    fontSize = 16,
    context = T("<lable fontSize=f16>%d</lable><lable fontSize=f13>\233\152\159</lable>", 3),
    color = ed.toccc3(16766650),
    strokeColor = ed.toccc3(12074795),
    strokeSize = 1,
    fontName = ed.fontBold
  })
  self.ui.image_team_3:addChild(teamAutoText3.node)
  local curWidth, _ = teamAutoText3:getCurContentSize()
  local curScale = math.min(1, 35 / curWidth)
  teamAutoText3.node:setPosition(ccp(33 - curWidth * curScale * 0.5, 30))
  teamAutoText3.node:setScale(curScale)
  local teamAutoText4 = ed.ui.autoText.new()
  teamAutoText4:initParam({
    fontSize = 16,
    context = T("<lable fontSize=f16>%d</lable><lable fontSize=f13>\233\152\159</lable>", 4),
    color = ed.toccc3(15381503),
    strokeColor = ed.toccc3(6098306),
    strokeSize = 1,
    fontName = ed.fontBold
  })
  self.ui.image_team_4:addChild(teamAutoText4.node)
  local curWidth, _ = teamAutoText4:getCurContentSize()
  local curScale = math.min(1, 35 / curWidth)
  teamAutoText4.node:setPosition(ccp(33 - curWidth * curScale * 0.5, 30))
  teamAutoText4.node:setScale(curScale)
  local teamAutoText5 = ed.ui.autoText.new()
  teamAutoText5:initParam({
    fontSize = 16,
    context = T("<lable fontSize=f16>%d</lable><lable fontSize=f13>\233\152\159</lable>", 5),
    color = ed.toccc3(10221792),
    strokeColor = ed.toccc3(1921631),
    strokeSize = 1,
    fontName = ed.fontBold
  })
  self.ui.image_team_5:addChild(teamAutoText5.node)
  local curWidth, _ = teamAutoText5:getCurContentSize()
  local curScale = math.min(1, 35 / curWidth)
  teamAutoText5.node:setPosition(ccp(33 - curWidth * curScale * 0.5, 30))
  teamAutoText5.node:setScale(curScale)
end

function PeakArenaChallengeResultWin:refreshUI()
  self:refreshBattleReplay()
  self:addWinLoseAnim()
  self:refreshLeftPlayerInfo()
  self:refreshRightPlayerInfo()
  self:showMedalRewardAnim()
end

function PeakArenaChallengeResultWin:refreshLeftPlayerInfo()
  local scoreChange
  if self.data._self_score_change then
    scoreChange = self.data._self_score_change
  elseif self.data._self_new_score and self.data._self_before_score then
    scoreChange = self.data._self_new_score - self.data._self_before_score
  end
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
    if self.isEvolving then
      ed.setLabelColor(self.ui.label_change_left, ccc3(230, 237, 246))
      ed.setLabelStroke(self.ui.label_change_left, ed.toccc3(3166351), 1)
      ed.setLabelString(self.ui.label_change_left, T("\229\134\187\231\187\147\228\184\173"))
    else
      ed.setLabelColor(self.ui.label_change_left, ccc3(180, 254, 139))
      ed.setLabelStroke(self.ui.label_change_left, ed.toccc3(3080450), 1)
      ed.setLabelString(self.ui.label_change_left, T("\228\191\157\230\138\164\228\184\173"))
    end
    self.ui.label_change_left:setPositionX(self.ui.label_change_left:getPositionX() + 20)
    self.ui.image_up_left:setVisible(false)
    self.ui.image_down_left:setVisible(false)
  end
  local scoreNodeLeft = ed.getNumberNode({
    text = self.data._self_new_score or 0,
    folder = "peak_score"
  }).node
  self.ui.panel_score_left:addChild(scoreNodeLeft)
  scoreNodeLeft:setScale(0.8)
  scoreNodeLeft:setPositionX(self.ui.panel_score_left:getContentSize().width - scoreNodeLeft:getContentSize().width * 0.8 / 2)
  ed.layout.centerYInParent(scoreNodeLeft)
  local name = ed.getPlayerName(self.myUserSummary._name, self.myUserSummary._medal, {left = true})
  ed.UITool.replaceUI(self.ui, "image_summary_bg", "label_name_left", name)
  local myHead = ed.getWholeHeadIcon({
    id = self.myUserSummary._avatar,
    level = self.myUserSummary._level,
    scale = 0.68,
    lvoffset = {x = -47, y = -25}
  })
  self.ui.panel_head_left:addChild(myHead)
  ed.layout.centerInParent(myHead)
end

function PeakArenaChallengeResultWin:refreshRightPlayerInfo()
  if self.data._oppo_score_change and self.data._oppo_score_change < 0 then
    ed.setLabelColor(self.ui.label_change_right, ed.toccc3(16755586))
    ed.setLabelStroke(self.ui.label_change_right, ed.toccc3(3080450), 1)
    ed.setLabelString(self.ui.label_change_right, self.data._oppo_score_change)
    self.ui.image_up_right:setVisible(false)
    self.ui.image_down_right:setVisible(true)
  elseif self.data._oppo_score_change and self.data._oppo_score_change > 0 then
    ed.setLabelColor(self.ui.label_change_right, ed.toccc3(5170756))
    ed.setLabelStroke(self.ui.label_change_right, ed.toccc3(0), 1)
    ed.setLabelString(self.ui.label_change_right, self.data._oppo_score_change)
    self.ui.image_up_right:setVisible(true)
    self.ui.image_down_right:setVisible(false)
  else
    if self.isEvolving then
      ed.setLabelColor(self.ui.label_change_right, ccc3(230, 237, 246))
      ed.setLabelStroke(self.ui.label_change_right, ed.toccc3(3166351), 1)
      ed.setLabelString(self.ui.label_change_right, T("\229\134\187\231\187\147\228\184\173"))
    else
      ed.setLabelColor(self.ui.label_change_right, ccc3(180, 254, 139))
      ed.setLabelStroke(self.ui.label_change_right, ed.toccc3(3080450), 1)
      ed.setLabelString(self.ui.label_change_right, T("\228\191\157\230\138\164\228\184\173"))
    end
    self.ui.label_change_right:setPositionX(self.ui.label_change_right:getPositionX() - 20)
    self.ui.image_up_right:setVisible(false)
    self.ui.image_down_right:setVisible(false)
  end
  local scoreNodeRight = ed.getNumberNode({
    text = self.data._oppo_new_score or self.data._oppo_score or 0,
    folder = "peak_score"
  }).node
  self.ui.panel_score_right:addChild(scoreNodeRight)
  scoreNodeRight:setScale(0.8)
  scoreNodeRight:setPositionX(scoreNodeRight:getContentSize().width * 0.8 / 2)
  ed.layout.centerYInParent(scoreNodeRight)
  local name = ed.getPlayerName(ed.transBotName(self.oppoUserSummary._name), self.oppoUserSummary._medal, {right = true})
  ed.UITool.replaceUI(self.ui, "image_summary_bg", "label_name_right", name)
  local oppoHead = ed.getWholeHeadIcon({
    id = self.oppoUserSummary._avatar,
    level = self.oppoUserSummary._level,
    scale = 0.68,
    lvoffset = {x = -47, y = -25}
  })
  self.ui.panel_head_right:addChild(oppoHead)
  ed.layout.centerInParent(oppoHead)
end

function PeakArenaChallengeResultWin:refreshBattleReplay()
  local winCount = 0
  local defeatCount = 0
  local teamCount = 0
  for index = 1, 5 do
    local recordData = self.recordsList[index]
    local teamBg = string.format("image_team_bg%s", index)
    if recordData then
      self.ui[teamBg]:setVisible(true)
      local result = recordData._result
      local isVictory = result == "victory"
      if isVictory then
        winCount = winCount + 1
      else
        defeatCount = defeatCount + 1
      end
      if self.isAttacker then
        self.ui[string.format("image_result_win_%s", index)]:setVisible(isVictory)
        self.ui[string.format("image_result_fail_%s", index)]:setVisible(not isVictory)
      else
        self.ui[string.format("image_result_win_%s", index)]:setVisible(not isVictory)
        self.ui[string.format("image_result_fail_%s", index)]:setVisible(isVictory)
      end
      self:createHeroList(self.ui[string.format("panel_hero_left_%s", index)], recordData._self_heroes._heroes, "right_align")
      self:createHeroList(self.ui[string.format("panel_hero_right_%s", index)], recordData._oppo_heroes._heroes, "left_align")
      teamCount = teamCount + 1
    else
      self.ui[teamBg]:setVisible(false)
    end
  end
  if self.isAttacker and winCount > defeatCount or not self.isAttacker and winCount < defeatCount then
    self.result = "victory"
  else
    self.result = "defeat"
  end
  ed.setTexture(self.ui.image_total_score_left, TOTAL_SCORE_TO_PATH[winCount])
  ed.setTexture(self.ui.image_total_score_right, TOTAL_SCORE_TO_PATH[defeatCount])
  self.teamCount = teamCount
end

function PeakArenaChallengeResultWin:createHeroList(container, heroList, align)
  if not container then
    return
  end
  local isReverse = align == "right_align"
  heroList = ed.PeakArenaPvpBattlePrepareData.sortHeroesByAttackRange(heroList or {}, isReverse)
  container:removeAllChildrenWithCleanup(true)
  local containerSize = container:getContentSize()
  for index, hero in ipairs(heroList or {}) do
    local heroInfo = ed.readhero.createIconByServer(hero)
    local heroIcon = heroInfo.icon
    heroInfo:showLegendEquip(ed.off_legendEquipOp)
    heroIcon:setScale(0.6)
    container:addChild(heroIcon)
    local iconSize = heroIcon:getContentSize()
    local width = iconSize.width * 0.6 + 10
    if align == "right_align" then
      heroIcon:setPositionX(containerSize.width - width * #heroList + width * (index - 1) + width / 2)
    else
      heroIcon:setPositionX((index - 1) * width + width / 2)
    end
    ed.layout.centerYInParent(heroIcon)
  end
end

function PeakArenaChallengeResultWin:addWinLoseAnim()
  if self.result == "victory" then
    self:addWinAnim()
  else
    self:addLoseAnim()
  end
end

function PeakArenaChallengeResultWin:addWinAnim()
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

function PeakArenaChallengeResultWin:addLoseAnim()
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

function PeakArenaChallengeResultWin:showMedalRewardAnim()
  if self.coin then
    local delayAction1 = CCDelayTime:create(0.5)
    local delayCallAction1 = CCCallFunc:create(function()
      xpcall(function()
        self.coinIcon:setScale(2)
        self.coinIcon:setVisible(true)
      end, EDDebug)
    end)
    local scaleAction1 = CCScaleTo:create(0.1, 1)
    self.coinIcon:runAction(ed.readaction.create({
      t = "seq",
      delayAction1,
      delayCallAction1,
      scaleAction1
    }))
    local delayAction2 = CCDelayTime:create(0.5)
    local delayCallAction2 = CCCallFunc:create(function()
      xpcall(function()
        self.coinAmountLabel:setScale(2)
        self.coinAmountLabel:setVisible(true)
      end, EDDebug)
    end)
    local scaleAction2 = CCScaleTo:create(0.1, 1)
    self.coinAmountLabel:runAction(ed.readaction.create({
      t = "seq",
      delayAction2,
      delayCallAction2,
      scaleAction2
    }))
  end
end

function PeakArenaChallengeResultWin:registerTouchHandlers()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.image_bg, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and self.clickOutSide then
        self:destroy({
          callback = self.closeCallback
        })
      end
      return false
    end,
    key = "close"
  })
  for index = 1, 5 do
    ed.UITool.registerBtn(self, string.format("btn_detail_%s", index), function()
      self:onClickDetailBtn(index)
    end, {
      pressScale = 0.65,
      normalScale = 0.7,
      clickInterval = 0.3
    })
    ed.UITool.registerBtn(self, string.format("btn_record_%s", index), function()
      self:onClickReplayBtn(index)
    end, {
      pressScale = 0.65,
      normalScale = 0.7,
      clickInterval = 0.3
    })
  end
end

function PeakArenaChallengeResultWin:onClickDetailBtn(index)
  local recordData = self.recordsList[index]
  if not recordData then
    return
  end
  ed.PeakArenaNetwork:sendQuerySummary(recordData._checkid, recordData._round)
end

function PeakArenaChallengeResultWin:onClickReplayBtn(index)
  local record = self.recordsList[index]
  if record then
    self:enterReplay(record)
  else
    ed.showToast(T("\230\154\130\230\151\160\229\189\149\229\131\143"))
  end
end

function PeakArenaChallengeResultWin:enterReplay(record)
  ed.PeakArenaManager.enterReplay(record)
end

function PeakArenaChallengeResultWin:registerEvents()
end
