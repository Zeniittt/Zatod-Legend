local base = ed.ui.popwindow
local CreviceDefendBattleWin = newclass(base.mt)
ed.ui.CreviceDefendBattleWin = CreviceDefendBattleWin

function CreviceDefendBattleWin.create(data)
  local self = base.create("CreviceDefendBattleWin")
  setmetatable(self, CreviceDefendBattleWin.mt)
  ed.asyncload.preloadFcaByName("eff_UI_CreviceDefend_loading")
  self:initData(data)
  self:initAppearance()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function CreviceDefendBattleWin:initData(data)
  self.selfSummary = data.selfSummary
  self.oppoSummary = data.oppoSummary
  self.selfCamp = data.selfCamp
  self.oppoCamp = data.oppoCamp
  self.isReceiveReply = false
  self.isPreLoadDoneReply = false
  self.isHandleChallengeReply = false
  self.isHandleSkipChallengeReply = false
  self.isHandleSkipChallengeData = false
  self.OppoStartEffectState = false
end

function CreviceDefendBattleWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_close", function()
    ed.stopEffect(ed.audioParam.effects.battleResult)
    self:destroy()
  end, {pressScale = 0.95})
end

function CreviceDefendBattleWin:registerEvents()
  self:listenEvent("EventCreviceDefendStageForceEnd", function()
    self:handleCreviceDefendChallengeResult()
  end)
  self:listenEvent("EventCreviceDefendPlayNextBattle", function(challengeData)
    if nil == challengeData then
      self:destroy({skipAnim = true})
    end
  end)
  self:listenEvent("EventCreviceDefendChallengeResult", function()
    self:handleCreviceDefendChallengeResult()
  end)
  self:listenEvent("EventCreviceDefendJumpBattle", function()
    self.isReceiveReply = true
  end)
  self:listenEvent("EventCreviceDefendHandleChallenge", function()
    self.isHandleChallengeReply = true
  end)
  self:listenEvent("EventCreviceDefendPreLoadDone", function()
    self.isPreLoadDoneReply = true
  end)
  self:listenEvent("EventCreviceDefendHandleSkipChallenge", function(msg)
    self.isHandleSkipChallengeReply = true
    self.isHandleSkipChallengeData = msg
  end)
end

function CreviceDefendBattleWin:initAppearance()
  ed.editorui(ed.uieditor.crevicedefendBattleWin, {
    container = self.container,
    ui = self.ui
  })
  self:playStartEffect()
  self:listenTimer(Timer:Once(10), function()
    if not self.isReceiveReply then
      ed.showToast(T("\231\189\145\231\187\156\232\191\158\230\142\165\229\188\130\229\184\184"))
      self.ui.btn_close:setVisible(true)
    end
  end)
end

function CreviceDefendBattleWin:playStartEffect()
  local movePx = 600
  self.ui.bg_left:setPositionX(self.ui.bg_left:getPositionX() - movePx)
  self.ui.bg_right:setPositionX(self.ui.bg_right:getPositionX() + movePx)
  self.ui.bg_left:runAction(CCEaseExponentialIn:create(CCMoveBy:create(0.24, ccp(movePx, 0))))
  self.ui.bg_right:runAction(CCEaseExponentialIn:create(CCMoveBy:create(0.24, ccp(-movePx, 0))))
  self.battleFca = ed.createFcaNode("eff_UI_CreviceDefend_loading")
  self:addFca(self.battleFca)
  self.ui.image_bg:addChild(self.battleFca, 9)
  self.battleFca:setAction("Start")
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(4.208333333333333), CCCallFunc:create(function()
    self:playStartEffectDone(1)
  end), CCDelayTime:create(0.8333333333333334), CCCallFunc:create(function()
    self.battleFca:setAction("Start2")
  end), CCDelayTime:create(1.7916666666666667), CCCallFunc:create(function()
    self:playStartEffectDone(2)
  end), CCDelayTime:create(1.125), CCCallFunc:create(function()
    self.battleFca:setAction("Start3")
  end), CCDelayTime:create(0.9583333333333334), CCCallFunc:create(function()
    self:playStartEffectDone(3)
  end))))
end

function CreviceDefendBattleWin:playStartEffectDone(state)
  if self.isPreLoadDoneReply and self.isHandleChallengeReply then
    self.battleFcaBoom = ed.createFcaNode("eff_UI_CreviceDefend_loading_boom")
    self:addFcaOnce(self.battleFcaBoom)
    self.ui.image_bg:addChild(self.battleFcaBoom, 9)
    self.battleFcaBoom:setAction("Start")
    self:listenTimer(Timer:Once(0.875), function()
      self.ui.image_bg:stopAllActions()
      self.OppoStartEffectState = false
      FireEvent("EventCreviceDefendAnimationDone")
    end)
    return true
  end
  if self.isHandleSkipChallengeReply then
    self.battleFcaBoom = ed.createFcaNode("eff_UI_CreviceDefend_loading_boom")
    self:addFcaOnce(self.battleFcaBoom)
    self.ui.image_bg:addChild(self.battleFcaBoom, 9)
    self.battleFcaBoom:setAction("Start")
    self:listenTimer(Timer:Once(0.875), function()
      self.ui.image_bg:stopAllActions()
      self.OppoStartEffectState = false
      FireEvent("EventCreviceDefendChallengeResult", self.isHandleSkipChallengeData)
    end)
  end
  if state == 3 then
    self.OppoStartEffectState = true
    self:addLoopAnimation()
  end
  return false
end

function CreviceDefendBattleWin:addLoopAnimation()
  self.ui.image_bg:stopAllActions()
  self.ui.image_bg:runAction(CCSequence:create(ccArrayMake(CCCallFunc:create(function()
    self.battleFca:setAction("Start2")
  end), CCDelayTime:create(1.7916666666666667), CCCallFunc:create(function()
    self:playStartEffectDone(2)
  end), CCDelayTime:create(1.125), CCCallFunc:create(function()
    self.battleFca:setAction("Start3")
  end), CCDelayTime:create(0.9583333333333334), CCCallFunc:create(function()
    self:playStartEffectDone(3)
  end))))
end

function CreviceDefendBattleWin:handleCreviceDefendChallengeResult()
  self:destroy({skipAnim = true})
  ed.ui.CreviceDefendBattleResultWin.create(ed.CreviceDefendBattleManager:getChallengeData())
end
