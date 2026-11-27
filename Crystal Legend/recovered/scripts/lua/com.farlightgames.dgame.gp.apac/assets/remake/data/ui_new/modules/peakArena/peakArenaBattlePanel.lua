local base = ed.ui.popwindow
local PeakArenaBattlePanel = newclass(base.mt)
ed.ui.PeakArenaBattlePanel = PeakArenaBattlePanel

function PeakArenaBattlePanel.create(data)
  local self = base.create("PeakArenaBattlePanel")
  setmetatable(self, PeakArenaBattlePanel.mt)
  ed.asyncload.preloadFcaByName("eff_UI_PeakArena_loading")
  self:initData(data)
  self:initAppearance()
  self:registerEvent()
  self:registerTouchHandler()
  return self
end

function PeakArenaBattlePanel:initData(data)
  self.selfSummary = data.selfSummary
  self.oppoSummary = data.oppoSummary
  self.grade = data.grade
  self.OppoStartEffectState = "nil"
end

function PeakArenaBattlePanel:initAppearance()
  ed.editorui(ed.uieditor.PeakArenaBattlePanel, {
    container = self.container,
    ui = self.ui
  })
  self:initHeadUI()
  self:initHeroContainer()
  self:playSelfStartEffect()
end

function PeakArenaBattlePanel:initHeadUI()
  local selfSummary = self.selfSummary
  local name = ed.getPlayerName(selfSummary._name, selfSummary._medal, {
    anchorPoint = ccp(1, 0.5),
    medalRight = true
  })
  ed.UITool.replaceUI(self.ui, "node_self_head", "label_name1", name)
  local param = {
    id = selfSummary._avatar,
    level = selfSummary._level,
    lvoffset = {x = -47, y = -38}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  head:setPosition(ccp(321, 16))
  self.ui.node_self_head:addChild(head)
  local oppoSummary = self.oppoSummary
  local name = ed.getPlayerName(ed.transBotName(oppoSummary._name), oppoSummary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "node_oppo_head", "label_name2", name)
  local param = {
    id = oppoSummary._avatar,
    level = oppoSummary._level,
    lvoffset = {x = -47, y = -38}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  head:setPosition(ccp(-13, 16))
  self.ui.node_oppo_head:addChild(head)
  if self.grade >= ed.PeakArenaManager.reserve.grade and not ed.isAreaOverSea() then
    self.ui.bg_result_5:setVisible(true)
    self.ui.label_round4:setVisible(true)
    self.ui.label_round5:setVisible(true)
    self.ui.bg_result:setPositionX(405.5)
  end
  self.ui.Label_2923:limitWidthByScale(90)
end

function PeakArenaBattlePanel:playSelfStartEffect()
  local movePx = 600
  self.ui.bg_left:setPositionX(self.ui.bg_left:getPositionX() - movePx)
  self.ui.bg_right:setPositionX(self.ui.bg_right:getPositionX() + movePx)
  self.ui.bg_left:runAction(CCEaseExponentialIn:create(CCMoveBy:create(0.24, ccp(movePx, 0))))
  self.ui.bg_right:runAction(CCEaseExponentialIn:create(CCMoveBy:create(0.24, ccp(-movePx, 0))))
  local battleFca = ed.createFcaNode("eff_UI_PeakArena_loading")
  self:addFcaOnce(battleFca)
  self.ui.image_bg:addChild(battleFca, 9)
  battleFca:setAction("Start")
  self:listenTimer(Timer:Once(5), function()
    if not self.getData then
      ed.showToast(T("\231\189\145\231\187\156\232\191\158\230\142\165\229\188\130\229\184\184"))
      self.ui.btn_close:setVisible(true)
    end
  end)
end

function PeakArenaBattlePanel:initHeroContainer()
  self.selfHeroContainer = CCSprite:create()
  self.selfHeroContainer:setCascadeOpacityEnabled(true)
  self.ui.node_self_hero:addChild(self.selfHeroContainer)
  self.selfHeroContainerPos = ccp(self.selfHeroContainer:getPosition())
  self.selfHeroContainer:setVisible(false)
  self.oppoHeroContainer = CCSprite:create()
  self.oppoHeroContainer:setCascadeOpacityEnabled(true)
  self.ui.node_oppo_hero:addChild(self.oppoHeroContainer)
  self.oppoHeroContainerPos = ccp(self.oppoHeroContainer:getPosition())
  self.oppoHeroContainer:setVisible(false)
end

function PeakArenaBattlePanel:setNextRoundHeroIcons(info)
  self.selfHeroContainer:removeAllChildrenWithCleanup(true)
  self.oppoHeroContainer:removeAllChildrenWithCleanup(true)
  local selfTeam = info.self_team
  local oppoTeam = info.oppo_team
  for i, hero in pairs(selfTeam._heroes or {}) do
    local hinfo = ed.readhero.createIconByServer(hero)
    hinfo.icon:setPosition(ccp((5 - i) * 85 + 55, 35))
    self.selfHeroContainer:addChild(hinfo.icon)
    hinfo:showLegendEquip(ed.off_legendEquipOp)
  end
  for i, hero in pairs(oppoTeam._heroes or {}) do
    local hinfo = ed.readhero.createIconByServer(hero)
    hinfo.icon:setPosition(ccp((i - 1) * 85 + 66, 35))
    self.oppoHeroContainer:addChild(hinfo.icon)
    hinfo:showLegendEquip(ed.off_legendEquipOp)
  end
end

function PeakArenaBattlePanel:playRoundBattle()
  self.mainLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(4.3), CCCallFunc:create(function()
    self.ui.node_oppo_head:setVisible(true)
    self.ui.node_self_head:setVisible(true)
    self.selfHeroContainer:setVisible(true)
    self.oppoHeroContainer:setVisible(true)
    self.ui.bg_result:setVisible(true)
    self.selfActionArray = CCArray:create()
    self.oppoActionArray = CCArray:create()
    for roundId = 1, #self.roundInfo do
      self.roundId = roundId
      self:playStartBattleEffect()
      self:playRoundWinLoseEffect()
      if roundId ~= #self.roundInfo then
        self:playNextTeamEnterEffect()
      end
    end
    self.ui.btn_jump:setVisible(true)
    local sequence = CCSequence:create(self.selfActionArray)
    self.selfHeroContainer:runAction(sequence)
    local sequence = CCSequence:create(self.oppoActionArray)
    self.oppoHeroContainer:runAction(sequence)
  end))))
end

function PeakArenaBattlePanel:playStartBattleEffect()
  local roundInfo = self.roundInfo[self.roundId]
  local nextInfo = self.roundInfo[self.roundId + 1]
  local leftMove1 = CCMoveBy:create(0.2, ccp(100, 0))
  leftMove1 = CCEaseSineIn:create(leftMove1)
  local leftMove2 = CCMoveBy:create(0.3, ccp(-100, 0))
  leftMove2 = CCEaseSineOut:create(leftMove2)
  local func = CCCallFunc:create(function()
    xpcall(function()
      ed.playEffect(ed.sound.deo.stargate_crash)
      local effectImpact = ed.createFcaNode("eff_UI_Stargate_Impact")
      effectImpact:setScale(1.8)
      effectImpact:setPositionY(-70)
      self.ui.image_bg:addChild(effectImpact, 999)
      self:addFcaOnce(effectImpact)
    end, EDDebug)
  end)
  local array = self.selfActionArray
  array:addObject(leftMove1)
  array:addObject(func)
  array:addObject(leftMove2)
  local rightMove1 = CCMoveBy:create(0.2, ccp(-100, 0))
  rightMove1 = CCEaseSineIn:create(rightMove1)
  local rightMove2 = CCMoveBy:create(0.3, ccp(100, 0))
  rightMove2 = CCEaseSineOut:create(rightMove2)
  local array = self.oppoActionArray
  array:addObject(rightMove1)
  array:addObject(rightMove2)
end

function PeakArenaBattlePanel:playRoundLoseEffect(roundInfo, side, isTimeOut)
  local isSelf = side == "self"
  local isLastRound = roundInfo.roundId >= #self.roundInfo
  local container = isSelf and self.selfHeroContainer or self.oppoHeroContainer
  local array = isSelf and self.selfActionArray or self.oppoActionArray
  local other = isSelf and self.oppoActionArray or self.selfActionArray
  local teamUI = self.ui["result" .. roundInfo.roundId]
  local teamMove = isSelf and 28.125 or -28.125
  local func = CCCallFunc:create(function()
    xpcall(function()
      teamUI:setVisible(true)
      teamUI:setZOrder(2)
      teamUI:setScale(5)
      teamUI:setOpacity(0)
      local delay = CCDelayTime:create(0.38)
      local action1 = CCSpawn:create(ccArrayMake(CCFadeIn:create(0.1), CCScaleTo:create(0.1, 0.8)))
      local action2 = CCScaleTo:create(0.02, 1)
      local func = CCCallFunc:create(function()
        self.ui["label_round" .. roundInfo.roundId]:setVisible(false)
      end)
      local seq = CCSequence:create(ccArrayMake(delay, action1, action2, func))
      teamUI:runAction(seq)
    end, EDDebug)
  end)
  local fadeout = CCFadeOut:create(0.5)
  local move = CCMoveBy:create(0.5, ccp(0, isTimeOut and -100 or 0))
  local spawn = CCSpawn:createWithTwoActions(fadeout, move)
  local func1 = CCCallFunc:create(function()
    xpcall(function()
      container:setVisible(false)
      if isLastRound then
        self:playBattleResultEffect()
      end
    end, EDDebug)
  end)
  array:addObject(func)
  array:addObject(spawn)
  array:addObject(func1)
end

function PeakArenaBattlePanel:playRoundWinLoseEffect()
  local roundInfo = self.roundInfo[self.roundId]
  local roundResult = roundInfo.round_result
  local teamUI = self.ui["result" .. roundInfo.roundId]
  teamUI:setCascadeOpacityEnabled(true)
  local labelResult = self.ui["label_result" .. roundInfo.roundId]
  if roundResult == "timeout" then
    ed.setTexture(teamUI, "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png")
    ed.setString(labelResult, T("\232\180\165"))
    ed.setLabelColor(labelResult, ed.toccc3(13949157))
    ed.setLabelStroke(labelResult, ed.toccc3(7759020), 1)
    labelResult:limitWidthByScale(30)
    self:playRoundLoseEffect(roundInfo, "self", true)
    self:playRoundLoseEffect(roundInfo, "oppo", true)
  elseif roundResult == "victory" then
    ed.setTexture(teamUI, "UI/alpha/1080P/toparena/battleshow/battleshow_result_win.png")
    ed.setString(labelResult, T("\232\131\156"))
    ed.setLabelColor(labelResult, ed.toccc3(16774524))
    ed.setLabelStroke(labelResult, ed.toccc3(13130498), 1)
    labelResult:limitWidthByScale(30)
    self:playRoundLoseEffect(roundInfo, "self", false)
    self:playRoundLoseEffect(roundInfo, "oppo", true)
  else
    ed.setTexture(teamUI, "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png")
    ed.setString(labelResult, T("\232\180\165"))
    ed.setLabelColor(labelResult, ed.toccc3(13949157))
    ed.setLabelStroke(labelResult, ed.toccc3(7759020), 1)
    labelResult:limitWidthByScale(30)
    self:playRoundLoseEffect(roundInfo, "self", true)
    self:playRoundLoseEffect(roundInfo, "oppo", false)
  end
end

function PeakArenaBattlePanel:playTeamEnterEffect(roundInfo, side, isTimeOut)
  print("playTeamEnterEffect", side, isTimeOut)
  local isSelf = side == "self"
  local container = isSelf and self.selfHeroContainer or self.oppoHeroContainer
  local array = isSelf and self.selfActionArray or self.oppoActionArray
  local other = isSelf and self.oppoActionArray or self.selfActionArray
  local pos = isSelf and self.selfHeroContainerPos or self.oppoHeroContainerPos
  local delta = isSelf and -400 or 400
  local func = CCCallFunc:create(function()
    xpcall(function()
      container:setPosition(ccp(pos.x + delta, pos.y))
      container:setVisible(true)
      self:setNextRoundHeroIcons(roundInfo)
    end, EDDebug)
  end)
  local move = CCMoveBy:create(0.5, ccp(-delta, 0))
  array:addObject(func)
  array:addObject(move)
  if not isTimeOut then
    local otherDelay = CCDelayTime:create(0.5)
    other:addObject(otherDelay)
  end
end

function PeakArenaBattlePanel:playNextTeamEnterEffect()
  local roundInfo = self.roundInfo[self.roundId]
  local nextRoundInfo = self.roundInfo[self.roundId + 1]
  local roundResult = roundInfo.round_result
  self:playTeamEnterEffect(nextRoundInfo, "self", true)
  self:playTeamEnterEffect(nextRoundInfo, "oppo", true)
end

function PeakArenaBattlePanel:playBattleResultEffect()
  function self.destroyCallback()
    ed.UITool.openView("PeakArenaChallengeResultWin", {
      data = self.challengeResultData,
      
      isEvolving = self.isEvolveBattle,
      isLoseProtect = ed.copyProto(self.challengeResultData)._is_lose_protect == 1,
      closeCallback = function()
        self:onChallengeResultWinClose()
      end
    })
    ed.PeakArenaManager:peakArenaAchFcaGroup()
  end
  
  self:destroy()
end

function PeakArenaBattlePanel:onChallengeResultWinClose()
  local scene = ed.PeakArenaManager.pvpScene
  if scene and scene.onBattleEnd then
    scene:onBattleEnd()
  end
end

function PeakArenaBattlePanel:registerEvent()
  self:listenEvent("PeakArenaChallengeResult", function(data)
    self.isEvolveBattle = false
    self:onPeakArenaChallengeReply(data)
  end)
  self:listenEvent("PeakArenaEvolveChallengeResult", function(data)
    self.isEvolveBattle = true
    self:onPeakArenaChallengeReply(data)
  end)
end

function PeakArenaBattlePanel:onPeakArenaChallengeReply(data)
  self.getData = true
  self:initBattleData(data)
  if ed.PeakArenaNetwork.skipBattle == false then
    local records = data._battle_replay._records
    for k, record in ipairs(records) do
      for k, v in ipairs(record._self_heroes._heroes) do
        ed.asyncload.preloadFcaByUnitID(v._tid)
      end
      for k, v in ipairs(record._oppo_heroes._heroes) do
        ed.asyncload.preloadFcaByUnitID(v._tid)
      end
    end
    self:listenTimer(Timer:Once(3.9), function()
      self:destroy({skipAnim = true})
      FireEvent("PeakArenaPlayNextBattle")
    end)
  else
    self:setNextRoundHeroIcons(self.roundInfo[1])
    self:playRoundBattle()
  end
end

function PeakArenaBattlePanel:initBattleData(data)
  self.roundId = 1
  if not data._battle_replay then
    ed.showToast(T("\230\149\176\230\141\174\233\148\153\232\175\175"))
    self:destroy()
    return
  end
  local records = data._battle_replay._records
  self.roundInfo = {}
  for i, record in pairs(records) do
    local round = record._round
    local info = {
      roundId = round,
      round_result = record._result,
      self_team = record._self_heroes,
      oppo_team = record._oppo_heroes
    }
    self.roundInfo[round] = info
  end
  self.challengeResultData = data
end

function PeakArenaBattlePanel:registerTouchHandler()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_jump", function()
    ed.playEffect(ed.sound.deo.common_click_feedback)
    self:playBattleResultEffect()
  end, {pressScale = 0.95})
end
