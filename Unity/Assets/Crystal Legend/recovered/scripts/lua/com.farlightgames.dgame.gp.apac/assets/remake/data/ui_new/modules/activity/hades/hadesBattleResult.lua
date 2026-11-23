local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.hadesBattleResult = class
local GROUP_ID_TO_CONFIG = {
  Hell = {
    winTitle = T("\232\190\190\230\136\144\229\165\145\231\186\166\230\157\161\228\187\182"),
    loseTitle = T("\231\173\190\232\174\162\229\165\145\231\186\166\228\184\128\232\167\136"),
    emptyLabel = T("\229\176\154\230\156\170\231\173\190\232\174\162\229\165\145\231\186\166\230\157\161\228\187\182"),
    loseTipsLabel = T("\230\136\152\230\150\151\229\164\177\232\180\165\239\188\140\230\130\168\229\143\175\230\160\185\230\141\174\232\135\170\232\186\171\229\174\158\229\138\155\231\129\181\230\180\187\233\133\141\231\189\174\229\165\145\231\186\166"),
    winTitleHeat = "UI/alpha/1080P/hades/hades_result_win_head.png",
    loseTitleHeat = "UI/alpha/1080P/hades/hades_result_lose_head.png",
    iconPath = "UI/alpha/1080P/hades/hades_hot.png",
    iconScale = 0.7
  },
  Nian = {
    winTitle = T("\232\190\190\230\136\144\229\172\137\230\136\143\230\157\161\228\187\182"),
    loseTitle = T("\231\173\190\232\174\162\230\157\161\228\187\182\228\184\128\232\167\136"),
    emptyLabel = T("\229\176\154\230\156\170\231\173\190\232\174\162\229\172\137\230\136\143\230\157\161\228\187\182"),
    loseTipsLabel = T("\230\136\152\230\150\151\229\164\177\232\180\165\239\188\140\230\130\168\229\143\175\230\160\185\230\141\174\232\135\170\232\186\171\229\174\158\229\138\155\231\129\181\230\180\187\233\133\141\231\189\174\230\157\161\228\187\182"),
    winTitleHeat = "UI/alpha/1080P/nianmonster/nian_result_win_head.png",
    loseTitleHeat = "UI/alpha/1080P/nianmonster/nian_result_lose_head.png",
    iconPath = "UI/alpha/1080P/nianmonster/nian_main_boss_heat.png",
    iconScale = 0.5,
    offset = {0, 5}
  }
}
ed.UITool.registViewOpenFunc("hadesBattleResult", function(param)
  class.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("hadesBattleResult")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.param = param
  self.isVictory = param.isVictory
  self.chooseHeat = param.chooseHeat or {}
  self.isBreakRecord = param.isBreakRecord
  self.maxHeat = param.maxHeat
  self.curBattleTime = param.curBattleTime or 0
  self.curHeat = param.curHeat or 0
  self.groupId = param.groupId or 1
  local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
  self.uiEditorConfig = nianMonsterMgr:getActivityUIConfig()
  self.uiType = self.uiEditorConfig.type or "Hell"
  self.config = GROUP_ID_TO_CONFIG[self.uiType]
  self.iconPath = self.config.iconPath or "UI/alpha/1080P/hades/hades_hot.png"
  self:initUI()
  self:refreshUI()
  self:registerTouchHandlers()
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.hades_battle_result)
  self.ui = ui
  self.container:addChild(container)
  if self.isVictory then
    ed.playEffect(ed.sound.deo.battle_win)
    ed.setTexture(self.ui.image_title_heat, self.config.winTitleHeat)
  else
    ed.playEffect(ed.sound.deo.battle_lose)
    ed.setTexture(self.ui.image_title_heat, self.config.loseTitleHeat)
  end
  ed.setTexture(self.ui.image_heat_icon, self.iconPath, true)
  ed.setLabelString(self.ui.label_empty_tips, self.config.emptyLabel or "")
  ed.setLabelString(self.ui.label_fail_tips, self.config.loseTipsLabel or "")
  ed.setLabelStroke(self.ui.label_record_breaking, ed.toccc3(1727272), 1)
  ed.setLabelFontName(self.ui.label_record_breaking, ed.fontBold)
  self:initLabel()
  self:initEffect()
  self:initDragList()
end

function class:initLabel()
  ed.setLabelStroke(self.ui.label_1, ed.toccc3(2565412), 1)
  self.ui.label_1:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_2, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_total_heat, ed.toccc3(14116371), 1)
  self.ui.label_total_heat:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_battle_time, ed.toccc3(10824491), 1)
  ed.setLabelStroke(self.ui.label_fail_tips, ed.toccc3(4350896), 1)
  self.ui.label_fail_tips:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_empty_tips, ed.toccc3(2565412), 1)
  self.ui.label_victory_result:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_victory_result, ed.toccc3(14374951), 1.5)
  self.ui.label_fail_result:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_fail_result, ed.toccc3(4350896), 1.5)
end

function class:initEffect()
  local effPath = self.isVictory and "eff_UI_Main_Hades_victory" or "eff_UI_Main_Hades_fail"
  local resultEffect = ed.createFcaActor(effPath)
  resultEffect:setAction("Start")
  resultEffect:setNextAction("Loop")
  resultEffect:setLoop(true)
  resultEffect:setScaleY(0.7)
  self:addFca(resultEffect)
  resultEffect:setPosition(ccp(0, 0))
  self.ui.image_result_title:addChild(resultEffect, 1)
  resultEffect:setPosition(ccp(390, 95))
  local scaleAction1 = CCScaleTo:create(0.1, 0.95)
  local scaleAction2 = CCScaleTo:create(0.1, 1, 0.95)
  local scaleAction3 = CCScaleTo:create(0.1, 1, 1)
  local action = CCSequence:create(ccArrayMake(scaleAction1, scaleAction2, scaleAction3))
  if self.isVictory then
    self.ui.image_victory:setScale(10)
    self.ui.image_victory:runAction(action)
  else
    self.ui.image_fail:setScale(10)
    self.ui.image_fail:runAction(action)
  end
end

function class:initDragList()
  local size = self.ui.list_layer:getContentSize()
  self.dragList = ed.UITool.createDraglist(self.ui.list_layer, {
    bar = {
      bglen = size.height,
      bgpos = ccp(size.width - 1, size.height / 2),
      barres = "UI/alpha/1080P/hades/hades_result_slide.png",
      bgres = "UI/alpha/1080P/hades/hades_result_slide_bg.png",
      alwaysShow = false
    }
  })
end

function class:refreshUI()
  ed.setLabelString(self.ui.label_total_heat, self.curHeat)
  local h = self.curBattleTime / 3600
  local m = self.curBattleTime / 60 % 60
  local s = self.curBattleTime % 60
  ed.setLabelString(self.ui.label_battle_time, string.format(T("\230\156\172\230\172\161\233\128\154\229\133\179\232\128\151\230\151\182  %.2d:%.2d:%.2d"), h, m, s))
  self.ui.label_record_breaking:setVisible(self.isBreakRecord and self.isBreakRecord > 0)
  self.ui.image_victory:setVisible(self.isVictory)
  self.ui.image_fail:setVisible(not self.isVictory)
  if self.isVictory then
    ed.setTexture(self.ui.image_result_title, "UI/alpha/1080P/hades/hades_result_victory.png")
    self.ui.image_victory_tips:setVisible(true)
    self.ui.image_fail_tips:setVisible(false)
    ed.setLabelString(self.ui.label_1, self.config.winTitle)
  else
    ed.setTexture(self.ui.image_result_title, "UI/alpha/1080P/hades/hades_result_lose.png")
    self.ui.image_victory_tips:setVisible(false)
    self.ui.image_fail_tips:setVisible(true)
    ed.setLabelString(self.ui.label_1, self.config.loseTitle)
  end
  self:refreshDragList()
end

function class:refreshDragList()
  self.dragList:clearList()
  local showChooseHeat = {}
  if self.isVictory then
    showChooseHeat = self.chooseHeat
  else
    local activeHeatIdList = ed.getDataTable("HeatGroup")[self.groupId]["Heat Active"] or {}
    for _, heatData in ipairs(self.chooseHeat) do
      if ed.isElementInTable(heatData._heat_id, activeHeatIdList) and heatData._times > 0 then
        table.insert(showChooseHeat, heatData)
      end
    end
  end
  self.ui.label_empty_tips:setVisible(#showChooseHeat <= 0)
  local posY, gapY = 0, 5
  local layerSize = self.ui.list_layer:getContentSize()
  for index, heatData in ipairs(showChooseHeat or {}) do
    local option = self:createHeatItem(heatData._heat_id, heatData._times)
    local itemSize = option:getContentSize()
    self.dragList:addItem(option)
    option:setPosition(ccp(27, layerSize.height - (posY + gapY) - 13))
    option:setPositionX(option:getPositionX() + 400)
    option:setCascadeOpacityEnabled(true)
    option:setOpacity(0)
    local delay = CCDelayTime:create(0.1 * index)
    local fadeIn = CCFadeIn:create(0.1 + index * 0.1)
    local move = CCMoveBy:create(0.05 + index * 0.05, ccp(-400, 0))
    local spawn = CCSpawn:create(ccArrayMake(fadeIn, move))
    option:runAction(CCSequence:create(ccArrayMake(delay, spawn)))
    posY = posY + itemSize.height + gapY
  end
  self.dragList:initListHeight(posY)
  local movingDistance = posY - layerSize.height
  if 0 < movingDistance then
    local time = movingDistance / 60
    local delayAction = CCDelayTime:create(0.5)
    local actionMove = CCMoveBy:create(time, ccp(0, movingDistance))
    self.dragList.listLayer:runAction(CCSequence:create(ccArrayMake(delayAction, actionMove)))
  end
end

function class:createHeatItem(heatId, level)
  local container = ed.createSprite()
  container:setAnchorPoint(ccp(0, 0))
  local autoText = ed.ui.autoText.new()
  local heatCfg = ed.getDataTable("Heat")[heatId]
  local frontDesc = heatCfg.FrontDescription
  local desc = frontDesc
  desc = string.gsub(desc, "#p#", "%%")
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(2565412),
    strokeSize = 1,
    maxWidth = 450,
    fontSize = 18
  })
  local imageHot = ed.createSprite(self.iconPath)
  local iconScale = self.config.iconScale
  local offset = self.config.offset or {0, 0}
  imageHot:setScale(iconScale)
  container:addChild(imageHot)
  imageHot:setPosition(ccp(0 + offset[1], -2 + offset[2]))
  container:addChild(autoText.node)
  autoText.node:setPosition(ccp(60, 0))
  local heatValue = ed.getDataTable("Heat")[heatId].HeatValue1 * level
  local labelHeat = ed.createLabelTTF(heatValue, 18)
  ed.setLabelColor(labelHeat, ed.toccc3(16734039))
  ed.setLabelStroke(labelHeat, ed.toccc3(4268829), 1)
  labelHeat:setAnchorPoint(ccp(0.5, 0.5))
  container:addChild(labelHeat)
  labelHeat:setPosition(ccp(37, 0))
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local height = math.max(autoTextH, 25)
  container:setContentSize(CCSizeMake(autoTextW, height))
  return container
end

function class:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "common", true)
  end, {pressScale = 0.9})
end
