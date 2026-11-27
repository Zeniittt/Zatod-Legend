local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.legendEquipOnlyTips = class

function class.create()
  local self = base.create("legendEquipOnlyTips", {noShade = true})
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self:initView()
  self:addTouchEvent()
end

function class:initView()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  self.container:addChild(bg)
  bg:setPosition(ccp(480, 270))
  self.bg = bg
  local labelTips = ed.createLabelTTF(T("\230\175\143\231\167\141\229\148\175\228\184\128\232\163\133\229\164\135\239\188\140\231\142\169\229\174\182\229\143\170\232\131\189\230\139\165\230\156\137\228\184\128\228\187\182\230\149\180\232\163\133\239\188\140\228\185\139\229\144\142\229\143\170\232\131\189\232\142\183\229\190\151\232\175\165\232\163\133\229\164\135\231\154\132\231\162\142\231\137\135"), 16)
  ed.setLabelColor(labelTips, ed.toccc3(16776423))
  ed.setLabelStroke(labelTips, ed.toccc3(0), 1)
  local labelSize = labelTips:getContentSize()
  bg:addChild(labelTips)
  bg:setContentSize(CCSizeMake(labelSize.width + 18, labelSize.height + 18))
  ed.layout.centerInParent(labelTips)
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
