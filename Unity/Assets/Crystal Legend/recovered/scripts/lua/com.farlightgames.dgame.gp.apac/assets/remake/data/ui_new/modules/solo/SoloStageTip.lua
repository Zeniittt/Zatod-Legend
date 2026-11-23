local base = ed.ui.popwindow
local SoloStageTip = newclass(base.mt)
ed.ui.SoloStageTip = SoloStageTip

function SoloStageTip:initLabels()
  ed.setLabelStroke(self.ui.label_wait_title, ed.toccc3(1315346), 1)
  ed.setLabelFontName(self.ui.label_timer, ed.fontBold)
  ed.setLabelStroke(self.ui.label_timer, ed.toccc3(1312776), 1)
  ed.setLabelFontName(self.ui.label_stage, ed.fontBold)
  ed.setLabelStroke(self.ui.label_stage, ed.toccc3(1312776), 1)
  self.ui.Label_5395:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_5395, ed.toccc3(16776423), 1)
  ed.setLabelStroke(self.ui.label_total_gold, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.label_gain_gold, ed.toccc3(1312776), 1)
  ed.setLabelStroke(self.ui.label_failed_gold, ed.toccc3(1312776), 1)
  self.ui.Label_5392:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_5392, ed.toccc3(16776423), 2)
  self.ui.Label_5393:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.Label_5393, ed.toccc3(16776423), 2)
  self.ui.Label_5394:setFontName(ed.fontBold)
end

function SoloStageTip:initTimeBar()
  local progressTime = CCProgressTimer:create(self.ui.time_bar)
  progressTime:setType(kCCProgressTimerTypeBar)
  progressTime:setMidpoint(ccp(0, 0.5))
  progressTime:setBarChangeRate(ccp(1, 0))
  self.ui.bg_time_bar:addChild(progressTime)
  self.ui.time_bar:setVisible(false)
  ed.layout.centerInParent(progressTime)
  self.timeBar = progressTime
end

function SoloStageTip:initUI()
  ed.editorui(ed.uieditor.SoloStageTip, {
    container = self.container,
    ui = self.ui
  })
  self.ui.bg:setVisible(false)
  self:initLabels()
  self:initTimeBar()
  ed.layout.layoutWithMagin(self.ui.img_prepare_bg, {top = 0}, false, true)
end

function SoloStageTip:resetStageTip(param)
  self.ui.img_round_start_bg:setVisible(false)
  self.ui.img_battle_victory_bg:setVisible(false)
  self.ui.img_battle_lose_bg:setVisible(false)
  self.ui.img_wait_info_bg:setVisible(false)
  self.ui.img_battle_addspeed:setVisible(false)
  self.ui.img_battle_start_bg:setVisible(false)
  self.ui.img_prepare_bg:setPositionX(-325)
  self.ui.bg:setVisible(true)
end

function SoloStageTip:clearTimer()
  self.ui.bg_time_bar:setVisible(true)
  self.ui.label_timer:stopAllActions()
  self.ui.label_timer:setScale(1)
  ed.setLabelColor(self.ui.label_timer, ccc3(253, 253, 253))
  if self.tipTimer then
    CloseTimer(self.tipTimer.Name)
    self.tipTimer = nil
  end
end

function SoloStageTip:playAlertAction()
  ed.playEffect(ed.sound.autochess.countdown)
  self.ui.label_timer:stopAllActions()
  ed.setLabelColor(self.ui.label_timer, ccc3(254, 0, 93))
  local scaleTo1 = CCEaseBackOut:create(CCScaleTo:create(0.5, 1.5))
  local scaleTo2 = CCEaseBackOut:create(CCScaleTo:create(0.3, 1))
  local seq = CCSequence:create(ccArrayMake(scaleTo1, scaleTo2))
  self.ui.label_timer:runAction(seq)
  if self.countEffect then
    self.countEffect:removeFromParentAndCleanup(true)
  end
  self.countEffect = ed.createFcaNode("eff_UI_chess_countdown")
  self.ui.label_timer:addChild(self.countEffect)
  ed.layout.centerInParent(self.countEffect)
  self:addFca(self.countEffect)
end

function SoloStageTip:startTimer()
  self:clearTimer()
  local stage = ed.SoloManager:getStage()
  if stage == ed.SoloManager.GAMESTAGE.START then
    self.ui.bg_time_bar:setVisible(false)
  elseif stage == ed.SoloManager.GAMESTAGE.PREPARE then
    local endTime = ed.SoloModel:getPrepareEndTime()
    local leftTime = endTime - ed.getServerTime()
    self.timeBar:setPercentage(100)
    ed.setString(self.ui.label_timer, leftTime)
    self.timeBar:runAction(CCProgressFromTo:create(leftTime, 100, 0))
    self.tipTimer = self:listenTimer(Timer:Always(1), function()
      local leftSec = math.max(endTime - ed.getServerTime(), 0)
      ed.setString(self.ui.label_timer, leftSec)
      if leftSec <= 5 then
        self:playAlertAction()
      end
    end)
  elseif stage == ed.SoloManager.GAMESTAGE.LOCK then
    self.ui.bg_time_bar:setVisible(false)
    self.usedTime = 0
    ed.setString(self.ui.label_timer, self.usedTime)
    self.tipTimer = self:listenTimer(Timer:Always(1), function()
      self.usedTime = self.usedTime + 1
      ed.setString(self.ui.label_timer, self.usedTime)
    end)
  elseif stage == ed.SoloManager.GAMESTAGE.BATTLE then
    self.usedTime = 60
    ed.setString(self.ui.label_timer, self.usedTime)
    self.tipTimer = self:listenTimer(Timer:Always(0.5), function()
      local time = math.floor(60 - ed.engine.ticks * ed.tick_interval)
      self.timeBar:runAction(CCProgressFromTo:create(0.5, self.usedTime / 60 * 100, time / 60 * 100))
      self.usedTime = math.max(time, 0)
      ed.setString(self.ui.label_timer, self.usedTime)
    end)
  elseif stage == ed.SoloManager.GAMESTAGE.OVER then
    local endTime = ed.SoloModel:getOverEndTime()
    local leftTime = endTime - ed.getServerTime()
    ed.setString(self.ui.label_timer, leftTime)
    self.timeBar:runAction(CCProgressFromTo:create(leftTime, 100, 0))
    self.tipTimer = self:listenTimer(Timer:Always(1), function()
      local leftSec = math.max(endTime - ed.getServerTime(), 0)
      ed.setString(self.ui.label_timer, leftSec)
    end)
  elseif stage == ed.SoloManager.GAMESTAGE.CHOOSE then
    local endTime = ed.SoloModel.waitChooseTime
    local leftTime = endTime - ed.getServerTime()
    ed.setString(self.ui.label_timer, leftTime)
    self.timeBar:runAction(CCProgressFromTo:create(leftTime, 100, 0))
    self.tipTimer = self:listenTimer(Timer:Always(1), function()
      local leftSec = math.max(endTime - ed.getServerTime(), 0)
      ed.setString(self.ui.label_timer, leftSec)
      if leftSec <= 5 then
        self:playAlertAction()
      end
    end)
  elseif stage == ed.SoloManager.GAMESTAGE.WAIT then
    local endTime = ed.SoloModel:getWaitEndTime()
    local leftTime = endTime - ed.getServerTime()
    ed.setString(self.ui.label_timer, leftTime)
    self.timeBar:runAction(CCProgressFromTo:create(leftTime, 100, 0))
    self.tipTimer = self:listenTimer(Timer:Always(1), function()
      local leftSec = math.max(endTime - ed.getServerTime(), 0)
      ed.setString(self.ui.label_timer, leftSec)
      ed.setString(self.ui.label_timer, leftSec)
      if leftSec <= 5 then
        self:playAlertAction()
      end
    end)
  end
end

function SoloStageTip:onRoundStart()
  self.ui.img_round_start_bg:setVisible(true)
  local gainGold = ed.SoloModel:getGainGold()
  ed.setString(self.ui.label_total_gold, gainGold.gainBase)
  ed.setString(self.ui.label_gain_gold, gainGold.gainInst)
  local dvGold = math.max(gainGold.comboV, gainGold.comboD)
  ed.setString(self.ui.label_failed_gold, dvGold)
  if gainGold.comboV > gainGold.comboD then
    ed.setLabelString(self.ui.label_failed, T("\232\191\158\232\131\156\239\188\154"))
  else
    ed.setLabelString(self.ui.label_failed, T("\232\191\158\232\180\165\239\188\154"))
  end
  self.ui.label_failed_gold:setVisible(0 < dvGold)
  self.ui.label_failed:setVisible(0 < dvGold)
  self.ui.ImageView_12175:setVisible(0 < dvGold)
  local action = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
  local delay = CCDelayTime:create(2)
  local action2 = CCEaseBackOut:create(CCScaleTo:create(0.2, 0))
  local final = CCCallFunc:create(function()
    self.ui.img_round_start_bg:setVisible(false)
  end)
  local sequence = CCSequence:create(ccArrayMake(action, delay, action2, final))
  self.ui.img_round_start_bg:setScale(0)
  self.ui.img_round_start_bg:runAction(sequence)
end

function SoloStageTip:onRoundBattle()
  local round = ed.SoloModel:getBattleRound()
  ed.setString(self.ui.label_stage, T("\231\172\172%d\229\155\158\229\144\136", round))
  self.ui.img_battle_start_bg:setVisible(true)
  self.ui.img_battle_start_bg:setScale(0)
  local final = CCCallFunc:create(function()
    self.ui.img_battle_start_bg:setVisible(false)
  end)
  self.ui.img_battle_start_bg:runAction(CCSequence:create(ccArrayMake(CCScaleTo:create(0.3, 1), CCDelayTime:create(2), final)))
end

function SoloStageTip:onRoundWait()
  local action = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
  local delay = CCDelayTime:create(2)
  self.ui.img_wait_info_bg:setVisible(true)
  local final = CCCallFunc:create(function()
    self.ui.img_wait_info_bg:setVisible(false)
  end)
  local sequence = CCSequence:create(ccArrayMake(action, delay, final))
  self.ui.img_wait_info_bg:setScale(0)
  self.ui.img_wait_info_bg:runAction(sequence)
end

function SoloStageTip:onRoundResult()
  local result = ed.SoloModel:getBattleResult()
  if result ~= "defeat" and result ~= "victory" then
    return
  end
  ed.playEffect(ed.sound.autochess.winlose)
  local panel = self.ui.img_battle_victory_bg
  if result == "defeat" then
    panel = self.ui.img_battle_lose_bg
  end
  panel:setVisible(true)
  local action = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
  local delay = CCDelayTime:create(2)
  local final = CCCallFunc:create(function()
    panel:setVisible(false)
    self:onRoundStageTip("waitting")
  end)
  local sequence = CCSequence:create(ccArrayMake(action, delay, final))
  panel:setScale(0)
  panel:runAction(sequence)
end

function SoloStageTip:showAddSpeed()
  self.ui.img_battle_addspeed:setVisible(true)
end

function SoloStageTip:onRoundStageTip(stage)
  self:resetStageTip()
  if stage == "start" then
    self:onRoundStart()
  elseif stage == "prepare" then
    local round = ed.SoloModel:getBattleRound()
    ed.setString(self.ui.label_stage, T("\231\172\172%d\229\155\158\229\144\136", round))
  elseif stage == "lock" then
    ed.setString(self.ui.label_stage, T("\233\148\129\229\174\154\233\152\182\230\174\181"))
  elseif stage == "battle" then
    self:onRoundBattle()
  elseif stage == "waitting" then
    self:onRoundWait()
  elseif stage == "result" then
    self:onRoundResult()
  elseif stage == "over" then
    ed.setString(self.ui.label_stage, T("\229\155\158\229\144\136\231\187\147\231\174\151"))
  elseif stage == "wait" then
    ed.setString(self.ui.label_stage, T("\229\174\157\231\137\169\233\128\137\230\139\169"))
  elseif stage == "choose" then
    ed.setString(self.ui.label_stage, T("\232\139\177\233\155\132\233\128\137\230\139\169"))
  end
end

function SoloStageTip.create()
  local self = base.create("SoloStageTip", {
    notBlurBg = true,
    noShade = true,
    priority = -1,
    swallow = false
  })
  setmetatable(self, SoloStageTip.mt)
  self:initUI()
  self:listenEvent("SoloBattleAddSpeed", function()
    self:showAddSpeed()
  end)
  self:listenEvent("SoloBattleTimeOut", function()
    ed.showToast(T("\230\136\152\230\150\151\232\182\133\230\151\182\239\188\140\230\160\185\230\141\174\232\161\128\233\135\143\229\137\169\228\189\153\231\153\190\229\136\134\230\175\148\229\136\164\230\150\173\232\131\156\232\180\159"))
  end)
  return self
end
