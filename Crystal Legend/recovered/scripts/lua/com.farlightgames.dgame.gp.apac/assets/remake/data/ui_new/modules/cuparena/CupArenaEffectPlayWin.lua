local base = ed.ui.popwindow
local CupArenaEffectPlayWin = newclass(base.mt)
ed.ui.CupArenaEffectPlayWin = CupArenaEffectPlayWin

function CupArenaEffectPlayWin:initData(data)
  self.data = data.data
  self.type = data.type
  self.destroyCallback = data.callback
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

function CupArenaEffectPlayWin:initUI()
  ed.editorui(ed.uieditor.CupArenaEffectPlayWin, {
    container = self.container,
    ui = self.ui
  })
  if "grade" == self.type then
    self:playGradeChange()
  elseif "qualify" == self.type then
    self:playQualify()
  end
end

function CupArenaEffectPlayWin:playQualify()
  local fca
  if self.data.isQualify then
    fca = ed.createFcaNode("eff_UI_Main_Cuparena_rise_congraduation")
    local tipImg = ed.createSprite("UI/alpha/1080P/cuparena/cuparena_raise.png")
    local rootNode = CCSprite:create()
    rootNode:addChild(tipImg)
    fca:addNodeToComponent(rootNode, "Node", -1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  else
    fca = ed.createFcaNode("eff_UI_Main_Cuparena_lose")
    local tipImg = ed.createSprite("UI/alpha/1080P/cuparena/cuparena_out.png")
    local rootNode = CCSprite:create()
    rootNode:addChild(tipImg)
    fca:addNodeToComponent(rootNode, "Node", -1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
  end
  if fca then
    self.ui.bg:addChild(fca)
    ed.layout.centerInScreen(fca)
    ed.UITool.setPositionBy(fca, ccp(0, 50))
    self:addFca(fca)
    fca:update(0)
  end
end

function CupArenaEffectPlayWin:playGradeChange()
  local oldGrade = self.data.oldGrade
  local newGrade = self.data.newGrade
  local fca
  if oldGrade < newGrade then
    fca = ed.createFcaNode("eff_UI_Main_Cuparena_level")
    local rank_tip = ed.createSprite("UI/alpha/1080P/cuparena/cuparena_rank_up.png")
    local rank_node = CCSprite:create()
    rank_node:addChild(rank_tip)
    fca:addNodeToComponent(rank_node, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    if newGrade == 2 then
      fca:setStartAction("Start_up")
      fca:setLoopAction("Loop_up")
    else
      fca:setStartAction("Start_up" .. oldGrade)
      fca:setLoopAction("Loop_up" .. oldGrade)
    end
  elseif oldGrade > newGrade then
    fca = ed.createFcaNode("eff_UI_Main_Cuparena_level")
    local rank_tip = ed.createSprite("UI/alpha/1080P/cuparena/cuparena_rank_down.png")
    local rank_node = CCSprite:create()
    rank_node:addChild(rank_tip)
    fca:addNodeToComponent(rank_node, "Node2", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    if newGrade == 1 then
      fca:setStartAction("Start_down")
      fca:setLoopAction("Loop_down")
    else
      fca:setStartAction("Start_down" .. newGrade)
      fca:setLoopAction("Loop_down" .. newGrade)
    end
  end
  if fca then
    local newGradeInfo = ed.CupArenaManager:getGradeInfoByGradeId(newGrade)
    local curTitle = ed.createSprite(newGradeInfo.nameIconRes)
    local curNode = CCSprite:create()
    curNode:addChild(curTitle)
    fca:addNodeToComponent(curNode, fca_config[newGrade] or "", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    local oldGradeInfo = ed.CupArenaManager:getGradeInfoByGradeId(oldGrade)
    local lastTitle = ed.createSprite(oldGradeInfo.nameIconRes)
    local lastNode = CCSprite:create()
    lastNode:addChild(lastTitle)
    fca:addNodeToComponent(lastNode, fca_config[oldGrade] or "", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    if oldGrade > newGrade then
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

function CupArenaEffectPlayWin:registerTouchHandlers()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if self.canClick then
        self:destroy()
      end
    end,
    key = "windestroy"
  })
end

function CupArenaEffectPlayWin.create(data)
  local self = base.create("CupArenaEffectPlayWin", {notBlurBg = true})
  setmetatable(self, CupArenaEffectPlayWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandlers()
  self.canClick = false
  self:listenTimer(Timer:Once(0.3), function()
    self.canClick = true
  end)
  self:popWindow()
  return self
end
