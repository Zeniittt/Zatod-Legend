local ed = ed
local class = {
  mt = {}
}
ed.Popup = class
class.mt.__index = class

local function PopupCreate(str, color, actor, crit, style)
  if not ed.run_with_scene then
    return
  end
  if not actor then
    return
  end
  local tick = ed.engine.ticks
  style = style or "damage"
  local speedRete = ed.engine:getSpeedRate()
  local self = {
    position = nil,
    life = 0.6 / speedRete,
    tick = -1
  }
  setmetatable(self, class.mt)
  if color == "green" then
    color = "solo_heal"
  elseif color == "white" then
    color = "solo_holy"
  end
  local scale = 0.4
  local num = tonumber(str)
  if num then
    if 1000 <= num then
      scale = 2
    elseif 500 <= num then
      scale = 1.3
    elseif 100 <= num then
      scale = 0.8
    elseif 50 <= num then
      scale = 0.65
    elseif 10 <= num then
      scale = 0.5
    end
  else
    scale = 0.65
  end
  if crit then
    str = "&" .. str
  end
  local specialTextMap = {
    dodge = {
      text = T("\233\151\170\233\129\191"),
      color = ed.toccc3(5402329)
    },
    inc_attack = {
      text = T("\230\148\187\229\135\187\230\143\144\229\141\135"),
      color = ed.toccc3(14376783)
    },
    silence = {
      text = T("\230\178\137\233\187\152"),
      color = ed.toccc3(5402329)
    }
  }
  if style == "text" then
    local specialConfig = specialTextMap[str]
    if specialConfig then
      self.node = ed.createttf(specialConfig.text, 24)
      ed.setLabelStroke(self.node, ed.toccc3(1842204), 2)
      ed.setLabelFontName(self.node, ed.fontBold)
      self.node:setColor(specialConfig.color)
    else
      self.node = ed.createBathNumOrTextNode(str, nil, nil, color, true)
    end
  elseif style == "solo" then
    self.node = ed.createttf(str, 16)
    ed.setLabelStroke(self.node, ccc3(24, 17, 19), 1)
    ed.setLabelFontName(self.node, ed.fontBold)
    self.node:setColor(color)
  else
    self.node = ed.createBathNumOrTextNode(str, -2, nil, color)
  end
  self.node:setScale(scale)
  local action
  local pos = FlipXPosition(actor.position)
  pos = ed.toViewPosition(pos, 75)
  local offsetMultiplier = math.max(0.2, 3 - scale)
  pos.x = pos.x + (math.random() * 60 - 30) * offsetMultiplier
  pos.y = pos.y + 20
  local h = 80
  h = (1 - math.random() * 0.2) * h
  h = h * math.max(0.5, scale)
  self.node:setPosition(pos)
  local duration = self.life * 0.3
  local camp = actor.model.camp
  action = CCMoveBy:create(duration, ccp(0, h))
  action = CCEaseOut:create(action, 4)
  action = CCSpawn:create(ccArrayMake(action, CCScaleBy:create(duration, 1.5)))
  local duration = self.life * 0.5
  local action2 = CCMoveBy:create(duration, ccp(0, h))
  action2 = CCEaseIn:create(action2, 2)
  action2 = CCSpawn:create(ccArrayMake(action2, CCFadeOut:create(duration), CCScaleBy:create(duration, 1)))
  action = CCSequence:create(ccArrayMake(action, CCDelayTime:create(0.3 * self.life), action2))
  action = CCSequence:create(ccArrayMake(action, CCCallFunc:create(function()
    self.node:removeFromParentAndCleanup(true)
  end)))
  self.node:runAction(action)
  ed.sceneui.damageBath_layer:addChild(self.node)
  return self
end

class.create = PopupCreate
ed.SoloPopupCreate = PopupCreate
