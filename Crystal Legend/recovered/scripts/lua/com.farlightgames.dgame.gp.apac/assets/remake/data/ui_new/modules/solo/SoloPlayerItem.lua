local SoloPlayerItem = {}
SoloPlayerItem.__index = SoloPlayerItem
ed.ui.SoloPlayerItem = SoloPlayerItem

function SoloPlayerItem:initData(player)
  self.soloPlayer = player
end

function SoloPlayerItem.create(player)
  local self = {}
  setmetatable(self, SoloPlayerItem)
  self:initData(player)
  self:initUI()
  return self
end

function SoloPlayerItem:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.SoloPlayerItem, {
    container = CCSprite:create()
  })
  self.container:setContentSize(self.ui.bg:getContentSize())
  self:initLabels()
  if self.soloPlayer:isMySelf() then
    ed.setTexture(self.ui.bar, "UI/alpha/1080P/chesscard/new_hp_3.png")
    self.ui.name:setColor(ed.toccc3(7864155))
    self.ui.ImageView_12505:setVisible(true)
  end
  self:updateIcon()
  self:updateHp()
  self:updateDamage()
  self:updateSpriteStone()
end

function SoloPlayerItem:isMySelf()
  return self.soloPlayer:isMySelf()
end

function SoloPlayerItem:getRootNode()
  return self.container
end

function SoloPlayerItem:initLabels()
  ed.setLabelFontName(self.ui.damage, ed.fontBold)
  ed.setLabelStroke(self.ui.damage, ed.toccc3(1908775), 1.5)
  ed.setLabelStroke(self.ui.label_hp, ed.toccc3(1908775), 1.5)
  ed.setLabelFontName(self.ui.Label_885, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_885, ed.toccc3(10822400), 1.5)
  local advance_lab = ed.ui.gradientLabel.create({
    text = T("\230\137\147\233\149\156\229\131\143\228\184\173..."),
    fontSize = 13,
    startColor = ed.toccc3(16775584),
    endColor = ed.toccc3(16760660),
    strokeColor = ed.toccc3(10692114),
    strokeSize = 1,
    fontName = ed.fontBold
  })
  ed.UITool.replaceUINew(self.ui, "Label_3323", advance_lab.node)
  self.ui.Label_3323:setVisible(false)
end

function SoloPlayerItem:updateIcon()
  local heroId = self.soloPlayer._hero_id
  if heroId then
    local icon = ed.createSprite(ed.getSoloUnitPortrait(heroId))
    icon:setScale(0.8)
    local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/player_bg1.png")
    clipNode:setScale(0.9)
    clipNode:addChild(icon)
    self.heroIcon = icon
    self.ui.icon:addChild(clipNode)
    ed.layout.centerInParent(clipNode)
  end
end

function SoloPlayerItem:updateDamage()
  self.ui.damage:setString(self.soloPlayer:getDamage())
end

function SoloPlayerItem:updateSpriteStone()
  local blood = self.soloPlayer:getCurHp()
  if blood <= 0 and not tolua.isnull(self.heroIcon) then
    ed.setSpriteStone(self.heroIcon)
  end
end

function SoloPlayerItem:isAlive()
  return self.soloPlayer:getCurHp() > 0
end

function SoloPlayerItem:updateHp()
  local totalHp = self.soloPlayer:getTotalHp()
  local blood = self.soloPlayer:getCurHp()
  local progress = math.clamp(blood / totalHp, 0, 1)
  self.ui.bar:setScaleX(progress)
  ed.setString(self.ui.label_hp, string.format("%d", blood))
end

function SoloPlayerItem:showBattleEffect()
  if not self.fightFca then
    self.fightFca = ed.createFcaNode("eff_UI_gvg_fighting")
    self.fightFca:setScale(1.2)
    self.fightFca:setPosition(ccp(26, 25))
    self.ui.bg:addChild(self.fightFca, 1)
    ed.getCurrentScene():addFca(self.fightFca)
  else
    self.fightFca:setVisible(true)
  end
end

function SoloPlayerItem:showMirror()
  self.ui.Label_3323:setVisible(true)
end

function SoloPlayerItem:stopBattleEffect()
  if self.fightFca then
    self.fightFca:setVisible(false)
  end
  self.ui.Label_3323:setVisible(false)
end

function SoloPlayerItem:stopResultShow()
  self.ui.ImageView_883:setVisible(false)
end

function SoloPlayerItem:addFloatActionTip(text)
  self.ui.ImageView_884:setVisible(true)
  self.ui.ImageView_884:setScale(1)
  self.ui.Label_885:setString(text)
  local ScaleTo = CCScaleTo:create(0.2, 1.2)
  local delayTime = CCDelayTime:create(2.6)
  local scaleto2 = CCScaleTo:create(0.2, 0)
  local seqAction = CCSequence:create(ccArrayMake(ScaleTo, delayTime, scaleto2))
  self.ui.ImageView_884:runAction(seqAction)
end

function SoloPlayerItem:showHurtEffect(isHurt, diffHp, result)
  self.ui.ImageView_883:setVisible(true)
  if result == "victory" then
    ed.setTexture(self.ui.ImageView_883, "UI/alpha/1080P/chesscard/battle/win.png")
  elseif result == "defeat" then
    ed.setTexture(self.ui.ImageView_883, "UI/alpha/1080P/chesscard/battle/lose.png")
  end
  if not isHurt then
    return
  end
  if not tolua.isnull(self.heroIcon) then
    self.heroIcon:stopAllActions()
    local action1 = CCCallFunc:create(function()
      ed.setSpriteShader(self.heroIcon, "ParasitismShader")
    end)
    local action2 = CCDelayTime:create(1)
    local action3 = CCCallFunc:create(function()
      ed.resetSpriteShader(self.heroIcon)
    end)
    local final = CCSequence:create(ccArrayMake(action1, action2, action3))
    self.heroIcon:runAction(final)
  end
  self:addFloatActionTip("-" .. diffHp)
  self:updateHp()
  self:updateSpriteStone()
end
