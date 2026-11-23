local AutoChessPlayerItem = {}
AutoChessPlayerItem.__index = AutoChessPlayerItem
ed.ui.AutoChessPlayerItem = AutoChessPlayerItem

function AutoChessPlayerItem:initData(player)
  self.chessPlayer = player
end

function AutoChessPlayerItem.create(player)
  local self = {}
  setmetatable(self, AutoChessPlayerItem)
  self:initData(player)
  self:initUI()
  return self
end

function AutoChessPlayerItem:initUI()
  local container, ui = ed.editorui(ed.uieditor.AutoChessPlayerIcon, {
    container = CCSprite:create()
  })
  self.container = container
  self.ui = ui
  local bgSize = self.ui.bg:getContentSize()
  self.container:setContentSize(bgSize)
  self.container:setAnchorPoint(ccp(1, 0.5))
  self.ui.img_error:setVisible(false)
  self:initLabelStroke()
  self:initHeadIcon()
  self:updateName()
  self:updateIcon()
end

function AutoChessPlayerItem:isMySelf()
  return self.chessPlayer:isMySelf()
end

function AutoChessPlayerItem:getRootNode()
  return self.container
end

function AutoChessPlayerItem:initLabelStroke()
  ed.setLabelStroke(self.ui.label_name, ccc3(20, 8, 8), 1.5)
  ed.setLabelStroke(self.ui.label_blood, ccc3(20, 8, 8), 1)
  ed.setLabelStroke(self.ui.label_level, ccc3(20, 8, 8), 1)
end

function AutoChessPlayerItem:initHeadIcon()
  local userSummary = self.chessPlayer:getUserSummary()
  self.headIcon = ed.getChessTeamHead({
    id = userSummary._avatar,
    scale = 0.75
  })
  ed.UITool.replaceUI(self.ui, "bg", "head", self.headIcon)
end

function AutoChessPlayerItem:updateIcon()
  self:updateBar()
  self:updateBlood()
  self:updateLevel()
end

function AutoChessPlayerItem:updateName()
  local userSummary = self.chessPlayer:getUserSummary()
  ed.setString(self.ui.label_name, userSummary._name)
  if self.chessPlayer:isMySelf() then
    self.ui.label_name:setColor(ed.toccc3(7864155))
  end
end

function AutoChessPlayerItem:updateBlood()
  local blood = self.chessPlayer:getCurHp()
  ed.setString(self.ui.label_blood, blood)
  if blood <= 0 and not tolua.isnull(self.headIcon) then
    ed.setSpriteStone(self.headIcon.headicon)
  end
end

function AutoChessPlayerItem:updateBar()
  local isSelf = self.chessPlayer:isMySelf()
  local bloodBar = self.ui.img_bar_red
  local hideBar = self.ui.img_bar_green
  if isSelf then
    bloodBar = self.ui.img_bar_green
    hideBar = self.ui.img_bar_red
  end
  hideBar:setVisible(false)
  local MAX_BLOOD = self.chessPlayer:getTotalHp()
  local blood = self.chessPlayer:getCurHp()
  local progress = blood / MAX_BLOOD
  bloodBar:setContentSize(CCSizeMake(25 + progress * 119, 12))
end

function AutoChessPlayerItem:updateLevel()
  local needAction = false
  if self.oldLevel and self.oldLevel ~= self.chessPlayer:getLevel() then
    needAction = true
  end
  ed.setString(self.ui.label_level, ed.formatLevel("Lv") .. self.chessPlayer:getLevel())
  self.oldLevel = self.chessPlayer:getLevel()
  if needAction then
    self.ui.label_level:runAction(ed.UITool.getRefreshAction())
  end
end

function AutoChessPlayerItem:showBattleEffect()
  if not self.fightFca then
    self.fightFca = ed.createFcaNode("eff_UI_gvg_fighting")
    self.fightFca:setPosition(ccp(148, 25))
    self.ui.bg:addChild(self.fightFca, 99)
    ed.getCurrentScene():addFca(self.fightFca)
  else
    self.fightFca:setVisible(true)
  end
end

function AutoChessPlayerItem:showExtraEffect()
  self.extraFca = ed.createFcaNode("eff_UI_Chess_wounded")
  self.extraFca:setPosition(ccp(148, 25))
  self.ui.bg:addChild(self.extraFca, 99)
  ed.getCurrentScene():addFca(self.extraFca)
end

function AutoChessPlayerItem:removeExtraEffect()
  if self.extraFca then
    self.extraFca:removeFromParentAndCleanup(true)
    self.extraFca = nil
  end
end

function AutoChessPlayerItem:stopBattleEffect()
  if self.fightFca then
    self.fightFca:setVisible(false)
  end
end

function AutoChessPlayerItem:showHurtEffect(isHurt, diffHp)
  if not isHurt then
    return
  end
  if not tolua.isnull(self.headIcon) then
    self.headIcon:stopAllActions()
    local action1 = CCCallFunc:create(function()
      ed.setSpriteShader(self.headIcon.headicon, "ParasitismShader")
    end)
    local action2 = CCDelayTime:create(1)
    local action3 = CCCallFunc:create(function()
      ed.resetSpriteShader(self.headIcon.headicon)
      FireEvent("EventSortPlayerIcon")
    end)
    local final = CCSequence:create(ccArrayMake(action1, action2, action3))
    self.headIcon:runAction(final)
  end
  ed.ui.AutoChessUITool.addFloatActionTip(self.headIcon, {
    text = "-" .. diffHp,
    size = 20,
    offsetX = 30,
    offsetY = 45,
    duration = 1
  })
  local isSelf = self.chessPlayer:isMySelf()
  local bloodBar = self.ui.img_bar_red
  if isSelf then
    bloodBar = self.ui.img_bar_green
    self:removeExtraEffect()
    self:showExtraEffect()
  end
  bloodBar:stopAllActions()
  local MAX_BLOOD = self.chessPlayer:getTotalHp()
  local scaleX = (bloodBar:getContentSize().width - 25) / 119
  local targetScaleX = self.chessPlayer:getCurHp() / MAX_BLOOD
  local step = (scaleX - targetScaleX) / 4
  local action1 = CCCallFunc:create(function()
    local curScaleX = (bloodBar:getContentSize().width - 25) / 119
    local leftScaleX = curScaleX - step
    if leftScaleX > targetScaleX then
      bloodBar:setContentSize(CCSizeMake(25 + leftScaleX * 119, 12))
    else
      self:updateBar()
      self:updateBlood()
      bloodBar:stopAllActions()
    end
  end)
  local action2 = CCDelayTime:create(0.1)
  local final = CCRepeatForever:create(CCSequence:create(ccArrayMake(action1, action2)))
  bloodBar:runAction(final)
end
