local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.KingsBattleResultWindow = class
local TOTAL_SCORE_TO_PATH = {
  [0] = "UI/alpha/1080P/battle/battle_stage_0.png",
  [1] = "UI/alpha/1080P/battle/battle_stage_1.png",
  [2] = "UI/alpha/1080P/battle/battle_stage_2.png",
  [3] = "UI/alpha/1080P/battle/battle_stage_3.png"
}
class.TOTAL_SCORE_TO_PATH = TOTAL_SCORE_TO_PATH
class.OB_WINNER_FLAG_BLUE = "UI/alpha/1080P/newkingspvp/ob/blue.png"
class.OB_WINNER_FLAG_RED = "UI/alpha/1080P/newkingspvp/ob/red.png"
ed.UITool.registViewOpenFunc("KingsBattleResultWindow", function(param)
  local window = ed.ui.KingsBattleResultWindow.create(param)
  window:popWindow()
end)

function class.create(param)
  local self = base.create("KingsBattleResultWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.is_host = param.is_host
  self.isObMode = param.isObMode
  self.hostUserSummary = param.hostUserSummary
  self.guestUserSummary = param.guestUserSummary
  self.roundBattleData = param.roundBattleData
  self.realArenaData = param.realArenaData
  self.autoContinueTime = 10
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.kingsBattleResultWindow)
  self.container:addChild(container)
  self.ui = ui
  self.ui.panel_score_blue:setVisible(false)
  self.ui.panel_score_red:setVisible(false)
  ed.setLabelString(self.ui.label_close_tips, string.format(T("%s\231\167\146\229\144\142\232\135\170\229\138\168\231\187\167\231\187\173"), self.autoContinueTime))
  self:initLabels()
  self:initPlayerInfo()
  self:initBattleRecord()
  self:refreshScoreChange()
  self:initTimer()
end

function class:initLabels()
end

function class:initTimer()
  self.isReportRoundReset = false
  self.ui.label_close_tips:setVisible(true)
  local count = self.autoContinueTime
  self:listenTimer(Timer:Times(1, count), function()
    self.autoContinueTime = self.autoContinueTime - 1
    if self.autoContinueTime <= 0 then
      self:onClickBtnContinue()
    end
    ed.setLabelString(self.ui.label_close_tips, string.format(T("%s\231\167\146\229\144\142\232\135\170\229\138\168\231\187\167\231\187\173"), self.autoContinueTime))
  end)
end

function class:addLoseAnim()
  ed.playEffect(ed.sound.deo.battle_lose)
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

function class:addWinAnim(lastRoundIsWin)
  ed.playEffect(ed.sound.deo.battle_win)
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
  if self.isObMode then
    local flagLeft = ed.createSprite(lastRoundIsWin and self.OB_WINNER_FLAG_BLUE or self.OB_WINNER_FLAG_RED)
    local flagRight = ed.createSprite(lastRoundIsWin and self.OB_WINNER_FLAG_BLUE or self.OB_WINNER_FLAG_RED)
    flagLeft:setPosition(ccp(155, 73))
    flagRight:setPosition(ccp(375, 73))
    flagRight:setScaleX(-1)
    image_bg:addChild(flagLeft)
    image_bg:addChild(flagRight)
  end
end

function class:initPlayerInfo()
  if self.hostUserSummary then
    local paramBlue = {
      id = self.hostUserSummary._avatar or 1
    }
    local headBlue = ed.getWholeHeadIcon(paramBlue)
    headBlue:setScale(0.75)
    self.ui.panel_head_blue:addChild(headBlue)
    ed.layout.centerInParent(headBlue)
    local blueName, blueNameWidth = ed.getPlayerName(self.hostUserSummary._name, self.hostUserSummary._medal, {
      anchorPoint = ccp(0, 0.5)
    })
    self.ui.panel_name_blue:addChild(blueName)
    blueName:setPosition(ccp(10, self.ui.panel_name_blue:getContentSize().height / 2))
  end
  if self.guestUserSummary then
    local paramRed = {
      id = self.guestUserSummary._avatar or 1
    }
    local headRed = ed.getWholeHeadIcon(paramRed)
    headRed:setScale(0.75)
    self.ui.panel_head_red:addChild(headRed)
    ed.layout.centerInParent(headRed)
    local redName, redNameWidth = ed.getPlayerName(self.guestUserSummary._name, self.guestUserSummary._medal, {
      anchorPoint = ccp(1, 0.5),
      medalRight = true
    })
    self.ui.panel_name_red:addChild(redName)
    redName:setPosition(ccp(self.ui.panel_name_red:getContentSize().width - 10, self.ui.panel_name_red:getContentSize().height / 2))
  end
end

function class:initBattleRecord()
  local panelSize = self.ui.panel_battle_info:getContentSize()
  local hostScore = 0
  local guestScore = 0
  local lastRoundIsWin = false
  local posY = 0
  for roundId, data in ipairs(self.roundBattleData or {}) do
    local victory = data.victory
    lastRoundIsWin = victory
    local item, ui = self:createRecordItem(roundId, data)
    self.ui.panel_battle_info:addChild(item)
    local itemSize = item:getContentSize()
    item:setPosition(ccp(panelSize.width / 2, panelSize.height - posY - itemSize.height / 2))
    posY = posY + itemSize.height + 5
    if self.is_host and victory or not self.is_host and not victory then
      hostScore = hostScore + 1
    else
      guestScore = guestScore + 1
    end
  end
  ed.setTexture(self.ui.image_score_blue, self.TOTAL_SCORE_TO_PATH[hostScore])
  ed.setTexture(self.ui.image_score_red, self.TOTAL_SCORE_TO_PATH[guestScore])
  if lastRoundIsWin or self.isObMode then
    self:addWinAnim(lastRoundIsWin)
    ed.playEffect(ed.sound.deo.battle_win)
    if self.is_host then
      ed.playEffect(ed.sound.deo.kings_pvp_blue_win)
    else
      ed.playEffect(ed.sound.deo.kings_pvp_red_win)
    end
  else
    self:addLoseAnim()
    ed.playEffect(ed.sound.deo.battle_lose)
  end
end

function class:createRecordItem(round, data)
  local container, ui = ed.editorui(ed.uieditor.kingsBattleResultItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ui.btn_record:setVisible(false)
  local victory = data.victory
  local hostHero = data.hostHero or {}
  local guestHero = data.guestHero or {}
  local heroData = data.heroData
  if victory then
    ui.image_result_win:setVisible(true)
    ui.image_result_fail:setVisible(false)
  else
    ui.image_result_win:setVisible(false)
    ui.image_result_fail:setVisible(true)
  end
  ed.setLabelString(ui.label_round, string.format(T("\231\172\172%s\232\189\174"), round))
  ed.setLabelStroke(ui.label_round, ed.toccc3(3080450), 1)
  ed.setLabelFontName(ui.label_round, ed.fontBold)
  for index = #hostHero, 1, -1 do
    local hero = hostHero[index]
    local icon = ed.readhero.createIconByServer(hero).icon
    icon:setScale(0.7)
    ui.panel_hero_blue:addChild(icon)
    local panelSize = ui.panel_hero_blue:getContentSize()
    local posX = panelSize.width - (index - 1) * 56 - 28
    icon:setPosition(ccp(posX, panelSize.height / 2))
  end
  for index, hero in ipairs(guestHero) do
    local icon = ed.readhero.createIconByServer(hero).icon
    icon:setScale(0.7)
    ui.panel_hero_red:addChild(icon)
    local posX = (index - 1) * 56 + 28
    icon:setPosition(ccp(posX, ui.panel_hero_red:getContentSize().height / 2))
  end
  self:btRegisterButtonClick({
    button = ui.btn_detail,
    key = "btn_detail" .. round,
    clickHandler = function()
      self:onClickBtnDetail(heroData)
    end,
    clickInterval = 0.5,
    pressScale = 0.65,
    normalScale = 0.7,
    force = true
  })
  self:btRegisterButtonClick({
    button = ui.btn_record,
    key = "btn_record" .. round,
    clickHandler = function()
      self:onClickBtnRecord()
    end,
    clickInterval = 0.5,
    pressScale = 0.65,
    normalScale = 0.7,
    force = true
  })
  return container, ui
end

function class:refreshScoreChange()
  local scoreInfo = ed.realarena.mgr:GetBattleScoreInfo()
  if not scoreInfo then
    return
  end
  local blueScoreChange, redScoreChange = 0, 0
  local blueScore, redScore = 0, 0
  if self.is_host then
    blueScoreChange = scoreInfo.selfScoreAfter - scoreInfo.selfScoreBefore
    redScoreChange = scoreInfo.oppoScoreAfter - scoreInfo.oppoScoreBefore
    blueScore = scoreInfo.selfScoreAfter
    redScore = scoreInfo.oppoScoreAfter
  else
    redScoreChange = scoreInfo.selfScoreAfter - scoreInfo.selfScoreBefore
    blueScoreChange = scoreInfo.oppoScoreAfter - scoreInfo.oppoScoreBefore
    blueScore = scoreInfo.oppoScoreAfter
    redScore = scoreInfo.selfScoreAfter
  end
  self.ui.panel_score_blue:setVisible(true)
  self.ui.panel_score_red:setVisible(true)
  ed.setLabelString(self.ui.label_change_blue, blueScoreChange)
  if 0 < blueScoreChange then
    ed.setLabelColor(self.ui.label_change_blue, ed.toccc3(5170756))
    ed.setLabelStroke(self.ui.label_change_blue, ed.toccc3(0), 1)
  elseif blueScoreChange < 0 then
    ed.setLabelColor(self.ui.label_change_blue, ed.toccc3(16755586))
    ed.setLabelStroke(self.ui.label_change_blue, ed.toccc3(3080450), 1)
  else
    ed.setLabelColor(self.ui.label_change_blue, ccc3(254, 235, 154))
  end
  self.ui.image_up_blue:setVisible(0 < blueScoreChange)
  self.ui.image_down_blue:setVisible(blueScoreChange < 0)
  local scoreNodeBlue = ed.getNumberNode({text = blueScore, folder = "peak_score"}).node
  self.ui.panel_score_blue:addChild(scoreNodeBlue)
  scoreNodeBlue:setScale(0.8)
  scoreNodeBlue:setPositionX(self.ui.panel_score_blue:getContentSize().width - scoreNodeBlue:getContentSize().width * 0.8 / 2)
  ed.layout.centerYInParent(scoreNodeBlue)
  local scoreNodeRed = ed.getNumberNode({text = redScore, folder = "peak_score"}).node
  self.ui.panel_score_red:addChild(scoreNodeRed)
  scoreNodeRed:setScale(0.8)
  scoreNodeRed:setPositionX(scoreNodeRed:getContentSize().width * 0.8 / 2)
  ed.layout.centerYInParent(scoreNodeRed)
  if 0 < redScoreChange then
    ed.setLabelColor(self.ui.label_change_red, ed.toccc3(5170756))
    ed.setLabelStroke(self.ui.label_change_red, ed.toccc3(0), 1)
  elseif redScoreChange < 0 then
    ed.setLabelColor(self.ui.label_change_red, ed.toccc3(16755586))
    ed.setLabelStroke(self.ui.label_change_red, ed.toccc3(3080450), 1)
  else
    ed.setLabelColor(self.ui.label_change_red, ccc3(254, 235, 154))
  end
  ed.setLabelString(self.ui.label_change_red, redScoreChange)
  self.ui.image_up_red:setVisible(0 < redScoreChange)
  self.ui.image_down_red:setVisible(redScoreChange < 0)
  ed.realarena.mgr:ResetBattleScoreInfo()
end

function class:onClickBtnDetail(heroData)
  ed.ui.BattleStaticsWin.create({_hero_data = heroData}, "common")
end

function class:onClickBtnRecord()
end

function class:onClickBtnContinue()
  if not self.isReportRoundReset then
    FireEvent("ReportRoundReset")
    if self.realArenaData and self.realArenaData.next_round ~= 0 then
      self.isReportRoundReset = true
      ed.updateSpriteGray(self.ui.btn_continue, true)
      if self.isObMode then
        ed.showToast(T("\231\173\137\229\190\133\233\128\137\230\137\139\231\161\174\232\174\164"))
      else
        ed.showToast(T("\231\173\137\229\190\133\229\175\185\230\137\139\231\161\174\232\174\164"))
      end
    elseif ed.getCurrentScene() and ed.getCurrentScene().identity == "battle" then
      ed.popScene()
    else
      self:destroy({skipAnim = true})
    end
  end
end

function class:addEventListen()
  self:listenEvent("RealPVPOpponentLost", function()
    ed.showToast(T("\229\175\185\230\137\139\229\183\178\231\187\143\230\150\173\229\188\128\232\191\158\230\142\165\239\188\140\228\189\160\232\142\183\229\190\151\228\186\134\232\131\156\229\136\169\239\188\129"))
    self:listenTimer(Timer:Once(2), function()
      ed.popScene()
    end)
  end)
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_continue", function()
    self:onClickBtnContinue()
  end, {pressScale = 0.95})
end
