local base = ed.ui.popwindow
local class = newclass("g")
ed.ui.crossFriendDetailWin = class

function class.create(param, referNode)
  local self = {}
  setmetatable(self, class.mt)
  self:init(param, referNode)
  return self
end

function class:init(param, referNode)
  param = param or {}
  self.svrId = param.svrId or 0
  self.svrName = param.svrName or ""
  self:initView()
  self.size = self.imageBg:getContentSize()
  if referNode then
    ed.layout.relateLayout(referNode, self.imageBg, {
      bottom = self.size.height
    })
  else
    ed.layout.centerInScreen(self.imageBg)
  end
  self:show()
end

function class:initView()
  local frame = ed.getSpriteFrame("UI/alpha/1080P/common/com_new_3.png")
  local imageBg = CCScale9Sprite:createWithSpriteFrame(frame)
  self.imageBg = imageBg
  local autoText = ed.ui.autoText.new()
  local desc = T("<lable color=ccc3(254,251,232)>\232\175\165\231\142\169\229\174\182\230\157\165\232\135\170</lable><lable color=ccc3(255,165,49)> %s\230\156\141 %s</lable>", self.svrId, self.svrName)
  autoText:initParam({context = desc, fontSize = 18})
  imageBg:addChild(autoText.node)
  local width, height = autoText:getCurContentSize()
  local margin = {
    left = 8,
    top = 5,
    right = 8,
    bottom = 5
  }
  autoText.node:setPosition(ccp(margin.left, margin.bottom + height / 2))
  imageBg:setContentSize(CCSizeMake(width + margin.left + margin.right, height + margin.top + margin.bottom))
  local curScene = ed.getCurrentScene()
  curScene.scene:addChild(imageBg, 999)
end

function class:show()
  self.imageBg:setScale(0)
  local showAction = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
  self.imageBg:runAction(showAction)
end

function class:destroy(param)
  self.imageBg:removeFromParentAndCleanup(true)
  self.imageBg = nil
end
