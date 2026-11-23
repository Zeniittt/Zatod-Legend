local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipRuneDetailWindow = class

function class.create(skillId, isUnlock, unlockStar)
  local self = base.create("legendEquipRuneDetailWindow", {noShade = true})
  setmetatable(self, class.mt)
  self:init(skillId, isUnlock, unlockStar)
  return self
end

function class:init(skillId, isUnlock, unlockStar)
  self.skillId = skillId
  self.isUnlock = isUnlock
  self.unlockStar = unlockStar
  self.runeCfg = ed.getDataTable("LegendEquipSkill")[skillId]
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  self.bg = bg
  self.container:addChild(bg, 999)
  bg:setPosition(ccp(480, 270))
  bg:setAnchorPoint(ccp(0.5, 1))
  local icon = ed.createSprite(self.runeCfg.Icon)
  bg:addChild(icon)
  if not self.isUnlock then
    ed.updateSpriteStone(icon, true)
  end
  local name = string.format(T("\231\172\166\230\150\135-%s"), self.runeCfg["Display Name"])
  local nameLabel = ed.createLabelTTF(name, 20)
  ed.setLabelColor(nameLabel, self.isUnlock and ed.toccc3(16776423) or ed.toccc3(10851710))
  ed.setLabelStroke(nameLabel, ed.toccc3(2565412), 1)
  bg:addChild(nameLabel)
  local starLabel
  if not self.isUnlock then
    starLabel = ed.createLabelTTF(string.format(T("%s\230\152\159\232\167\163\233\148\129"), self.unlockStar or 4), 14)
    ed.setLabelColor(starLabel, ed.toccc3(16739438))
    ed.setLabelStroke(starLabel, ed.toccc3(2565412), 1)
  else
    starLabel = ed.createLabelTTF(T("\229\183\178\232\167\163\233\148\129"), 14)
    ed.setLabelColor(starLabel, ed.toccc3(16771782))
    ed.setLabelColor(starLabel, ed.toccc3(7405396))
  end
  bg:addChild(starLabel)
  local line = ed.createSprite("UI/alpha/1080P/hades/hades_boss_line.png")
  bg:addChild(line)
  local autoText = ed.legendEquipTool.getLegendEquipSkillDesc(self.skillId, {
    color = self.isUnlock and ed.toccc3(16776423) or ed.toccc3(10851710),
    strokeColor = ed.toccc3(1774610),
    strokeSize = 1,
    maxWidth = 300,
    fontSize = 16
  })
  bg:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local bgWidth = 330
  local bgHeight = nameLabel:getContentSize().height + autoTextH + 35
  bg:setContentSize(CCSizeMake(bgWidth, bgHeight))
  ed.layout.layoutWithParentMagin(icon, {left = 8, top = 10})
  ed.layout.layoutWithParentMagin(nameLabel, {left = 40, top = 15})
  ed.layout.layoutWithParentMagin(line, {left = 24, top = 45})
  ed.layout.layoutWithParentMagin(autoText.node, {left = 15, top = 60})
  ed.layout.layoutWithParentMagin(starLabel, {right = 8, top = 15})
end

function class:addTouchEvent()
  self:btRegisterOutClick({
    area = self.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
end
