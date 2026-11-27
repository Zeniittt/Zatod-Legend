local base = ed.ui.popwindow
local peakArenaGradeChangeWin = newclass(base.mt)
ed.ui.peakArenaGradeChangeWin = peakArenaGradeChangeWin

function peakArenaGradeChangeWin:initData(params)
  self.mgr = ed.PeakArenaManager
  self.mode = params.mode
  self.destroyCallback = params.callback
end

local fca_config = {
  "Node_xianfeng",
  "Node_weishi",
  "Node_zhongjun",
  "Node_tongshuai",
  "Node_dashi",
  "Node_chuanqi",
  "Node_buxiu"
}

function peakArenaGradeChangeWin:initUI()
  ed.editorui(ed.uieditor.TopArenaGradeChangeWin, {
    container = self.container,
    ui = self.ui
  })
  local fca
  if self.mode == "success" then
    fca = ed.createFcaNode("eff_UI_Main_PeakArena_congraduation")
    local score_label = ed.createLabelTTF(T("\231\167\175\229\136\134"), 18, ed.fontBold)
    ed.setLabelColor(score_label, ed.toccc3(16773542))
    ed.setLabelStroke(score_label, ed.toccc3(12542248), 1)
    local node2 = CCSprite:create()
    node2:addChild(score_label)
    fca:addNodeToComponent(node2, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    local win_title = ed.createSprite("UI/alpha/1080P/toparena/toparena_promotion_result2.png")
    local node = CCSprite:create()
    node:addChild(win_title)
    fca:addNodeToComponent(node, "Node", -1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    local tip_title = ed.createLabelTTF(T("\231\142\176\229\156\168\232\181\183\229\143\175\230\140\145\230\136\152\229\133\168\230\156\141\233\171\152\230\137\139"), 24, ed.fontBold)
    ed.setLabelColor(tip_title, ed.toccc3(16775034))
    ed.setLabelStroke(tip_title, ed.toccc3(12608015), 1.5)
    local node3 = CCSprite:create()
    node3:addChild(tip_title)
    fca:addNodeToComponent(node3, "Node3", -1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    local preScore = ed.getNumberNodeEx({
      text = self.mgr.beforeScore or 5000,
      folder = "peak_score"
    }).node
    preScore:setPosition(ccp(380, 185))
    self.ui.bg:addChild(preScore, 1)
    local curScore = ed.getNumberNodeEx({
      text = self.mgr.score,
      folder = "peak_score"
    }).node
    curScore:setCascadeOpacityEnabled(true)
    curScore:setScale(5)
    curScore:setOpacity(0)
    curScore:setPosition(ccp(540, 185))
    local delay = CCDelayTime:create(1.5)
    local fadeIn = CCSpawn:createWithTwoActions(CCFadeIn:create(0.2), CCScaleTo:create(0.2, 1))
    curScore:runAction(CCSequence:createWithTwoActions(delay, fadeIn))
    self.ui.bg:addChild(curScore, 1)
  elseif self.mode == "fail" then
    fca = ed.createFcaNode("eff_UI_Main_PeakArena_lose")
    local lose_title = ed.createSprite("UI/alpha/1080P/toparena/toparena_promotion_result1.png")
    local title_node = CCSprite:create()
    title_node:addChild(lose_title)
    fca:addNodeToComponent(title_node, "Node", -1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    local score_label = ed.createLabelTTF(T("\231\167\175\229\136\134"), 16, ed.fontBold)
    ed.setLabelColor(score_label, ed.toccc3(14540253))
    ed.setLabelStroke(score_label, ed.toccc3(4277080), 1)
    local score_node = CCSprite:create()
    score_node:addChild(score_label)
    fca:addNodeToComponent(score_node, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    local preScore = ed.getNumberNodeEx({
      text = self.mgr.beforeScore or 5000,
      folder = "peak_score_down"
    }).node
    preScore:setPosition(ccp(410, 195))
    self.ui.bg:addChild(preScore, 1)
    local curScore = ed.getNumberNodeEx({
      text = self.mgr.score,
      folder = "peak_score_down"
    }).node
    curScore:setCascadeOpacityEnabled(true)
    curScore:setScale(1)
    curScore:setOpacity(0)
    curScore:setPosition(ccp(580, 195))
    local delay = CCDelayTime:create(0.95)
    local fadeIn = CCSpawn:createWithTwoActions(CCFadeIn:create(0.6), CCScaleTo:create(0.6, 1))
    curScore:runAction(CCSequence:createWithTwoActions(delay, fadeIn))
    self.ui.bg:addChild(curScore, 1)
  elseif self.mode == "up" then
    fca = ed.createFcaNode("eff_UI_Main_PeakArena_level")
    local rank_tip = ed.createSprite("UI/alpha/1080P/toparena/rank/toparena_rank_rankup.png")
    local rank_node = CCSprite:create()
    rank_node:addChild(rank_tip)
    fca:addNodeToComponent(rank_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    if self.mgr.grade == 2 then
      fca:setStartAction("Start_up")
      fca:setLoopAction("Loop_up")
    else
      fca:setStartAction("Start_up" .. self.mgr.grade - 1)
      fca:setLoopAction("Loop_up" .. self.mgr.grade - 1)
    end
  elseif self.mode == "down" then
    fca = ed.createFcaNode("eff_UI_Main_PeakArena_level")
    local rank_tip = ed.createSprite("UI/alpha/1080P/toparena/rank/toparena_rank_demoted.png")
    local rank_node = CCSprite:create()
    rank_node:addChild(rank_tip)
    fca:addNodeToComponent(rank_node, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    if self.mgr.grade == 1 then
      fca:setStartAction("Start_down")
      fca:setLoopAction("Loop_down")
    else
      fca:setStartAction("Start_down" .. self.mgr.grade)
      fca:setLoopAction("Loop_down" .. self.mgr.grade)
    end
  end
  if fca and (self.mode == "down" or self.mode == "up") then
    local curGrade = self.mgr.grade
    local lastGrade = self.mgr.grade + (self.mode == "down" and 1 or -1)
    local curTitle = ed.createSprite("UI/alpha/1080P/toparena/rank/toparena_rankname_" .. curGrade .. ".png")
    local curNode = CCSprite:create()
    curNode:addChild(curTitle)
    fca:addNodeToComponent(curNode, fca_config[curGrade] or "", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    local lastTitle = ed.createSprite("UI/alpha/1080P/toparena/rank/toparena_rankname_" .. lastGrade .. ".png")
    local lastNode = CCSprite:create()
    lastNode:addChild(lastTitle)
    fca:addNodeToComponent(lastNode, fca_config[lastGrade] or "", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    if self.mode == "down" then
      curNode:setCascadeOpacityEnabled(true)
      lastNode:setCascadeOpacityEnabled(true)
      curNode:setOpacity(0)
      lastNode:setOpacity(255)
      curNode:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.25), CCFadeIn:create(0.75)))
      lastNode:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.25), CCFadeOut:create(0.75)))
    end
    self.mainLayer:addChild(curNode)
    self.mainLayer:addChild(lastNode)
  end
  if fca then
    self.ui.bg:addChild(fca)
    ed.layout.centerInScreen(fca)
    ed.UITool.setPositionBy(fca, ccp(0, 50))
    self:addFca(fca)
    fca:update(0)
  end
end

function peakArenaGradeChangeWin:registerTouchHandlers()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if self.canClick then
        self:destroy()
      end
    end,
    key = "windestroy"
  })
end

function peakArenaGradeChangeWin.create(params)
  local self = base.create("peakArenaGradeChangeWin", {notBlurBg = true})
  setmetatable(self, peakArenaGradeChangeWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self.canClick = false
  self:listenTimer(Timer:Once(0.3), function()
    self.canClick = true
  end)
  self:popWindow()
  return self
end
