local base = ed.ui.popwindow
local rulePop = newclass(base.mt)
ed.ui.commonRulePop = rulePop

function rulePop.create(param)
  if type(param.txt) == "string" then
    param.txt = {
      param.txt
    }
  end
  return setmetatable(base.create("commonRulePop"), rulePop.mt):initUI():initLayer(param):registerTouchHandler()
end

function rulePop:initUI()
  self.poplay, self.ui = ed.editorui(ed.uieditor.summonRulePop)
  self.container:addChild(self.poplay)
  self.poplay:setPosition(ed.display.winSize.width / 2 - 480, ed.display.winSize.height / 2 - 270)
  self.container:setPosition(0, 0)
  self.ui.arrow_left:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(-10, 0)), CCMoveBy:create(0.7, ccp(10, 0)))))
  self.ui.arrow_right:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCMoveBy:create(0.7, ccp(10, 0)), CCMoveBy:create(0.7, ccp(-10, 0)))))
  self:show()
  self:listenTimer(Timer:Once(1), function()
    self:removeUpdateHandler("rulePopUpdate")
  end)
  return self
end

function rulePop:addUpdateScale()
  self:registerUpdateHandler("rulePopUpdate", function(dt)
    local s = self.container:getScale()
    self.clipLayer:setClipRect(CCRectMake(5 * s, 30 * s, 588 * s, 271 * s))
  end)
end

function rulePop:initLayer(param)
  self.param = setmetatable(param, {
    __index = {
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = {""},
      index = 1
    }
  })
  self.ui.label_title:setString(param.title)
  ed.left2(self.ui.ImageView_692, self.ui.label_title, 5)
  ed.right2(self.ui.ImageView_692_Copy0, self.ui.label_title, 5)
  self.clipLayer = CCLayer:create()
  self.ui.Image_bg:addChild(self.clipLayer)
  self.clipLayer:setClipRect(CCRectMake(5, 30, 588, 271))
  self.listPage = {}
  self.listPage[self.param.index] = self.page.new(self, {
    pos = ccp(0, 0),
    txt = self.param.txt[self.param.index]
  })
  self.ui.arrow_left:setVisible(self.param.index > 1)
  self.ui.arrow_right:setVisible(self.param.index < #self.param.txt)
  local width = 30
  local posx = 280 - width * #self.param.txt / 2 + 5
  self.point = {}
  for i = 1, #self.param.txt do
    local point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_1.png")
    point:setPosition(posx + i * width, 21)
    self.ui.Image_bg:addChild(point)
    self.point[i] = point
  end
  self.pointMove = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_2.png")
  self.pointMove:setPosition(self.point[self.param.index]:getPosition())
  self.ui.Image_bg:addChild(self.pointMove)
  return self
end

function rulePop:listMove(up)
  local index = ed.clamp(self.param.index + up, 1, #self.param.txt)
  if index ~= self.param.index then
    if not self.listPage[index] then
      self.listPage[index] = self.page.new(self, {
        pos = ccp(600 * up, 0),
        txt = self.param.txt[index]
      })
    end
    self.listPage[index].layer:stopAllActions()
    self.listPage[self.param.index].layer:stopAllActions()
    self.listPage[index].layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
    self.listPage[self.param.index].layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(up * -1 * 600, 0))))
    self.ui.arrow_left:setVisible(1 < index)
    self.ui.arrow_right:setVisible(index < #self.param.txt)
    self.param.index = index
    self.pointMove:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(self.point[self.param.index]:getPositionX(), 21))))
    return true
  end
end

function rulePop:touchMove(toPosx)
  local posx = self.listPage[self.param.index].layer:getPositionX()
  self.layPosx = self.layPosx or posx
  local hysteresis = ed.clamp(30 - math.abs(self.layPosx - posx), 5, 30) / 30
  local newToPosx = posx - toPosx * hysteresis
  self.listPage[self.param.index].layer:setPositionX(newToPosx)
  local movex = self.layPosx - newToPosx
  if math.abs(movex) > 70 and self:listMove(0 < movex and 1 or -1) then
    self.layPosx = nil
    self.touchLayer:setTouchEnabled(false)
    self.touchLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2), CCCallFunc:create(function()
      self.touchLayer:setTouchEnabled(true)
    end))))
  end
end

function rulePop:touchMoveOver()
  local posx = self.listPage[self.param.index].layer:getPositionX()
  local movex = self.layPosx - posx
  if math.abs(movex) > 30 and self:listMove(0 < movex and 1 or -1) then
  else
    self.listPage[self.param.index].layer:stopAllActions()
    self.listPage[self.param.index].layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
  end
  self.layPosx = nil
end

function rulePop:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.panel_touch,
    key = "out_click",
    clickHandler = function()
      self:addUpdateScale()
      self:destroy({
        callback = function()
          self:removeUpdateHandler("rulePopUpdate")
        end
      })
    end
  })
  ed.UITool.registerBtn(self, "arrow_left", function()
    self:listMove(-1)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "arrow_right", function()
    self:listMove(1)
  end, {pressScale = 0.95})
  local container = CCLayer:create()
  container:registerScriptTouchHandler(function(event, x, y)
    if event == "began" then
      self.pos = {x, y}
      self.Anyway = ""
      return ed.containsPoint(self.ui.Image_bg, x, y)
    elseif event == "moved" then
      local toPosx = self.pos[1] - x
      local toPosy = self.pos[2] - y
      if self.Anyway == "x" or math.abs(toPosx) > 10 then
        self.Anyway = "x"
        self:touchMove(toPosx)
        self.pos = {x, y}
      elseif self.Anyway == "y" or math.abs(toPosy) > 5 then
        self.Anyway = "y"
        self.listPage[self.param.index]:setTouchMove(toPosy)
        self.pos = {x, y}
      end
    elseif event == "ended" then
      if self.Anyway == "x" then
        self:touchMoveOver()
      elseif self.Anyway == "y" then
        self.listPage[self.param.index]:overTouchMove()
      end
    end
  end, false, -300, false)
  container:setContentSize(CCSizeMake(600, 350))
  self.ui.Image_bg:addChild(container)
  self.touchLayer = container
  self.touchLayer:setTouchEnabled(true)
  self:addUpdateScale()
  return self
end

local page = {}
rulePop.page = page

function page.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = page}):create(param)
end

function page:create(param)
  self.layer = CCLayer:create()
  self.layer:setPosition(param.pos)
  self.popSelf.clipLayer:addChild(self.layer)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = param.txt or "not txt",
    fontSize = 16,
    lineSpacing = 4,
    maxWidth = 554
  })
  self.layer:addChild(autoText.node)
  local _, height = autoText:getCurContentSize()
  self.height = height + 20
  autoText.node:setPosition(25, 281)
  self.autoText = autoText.node
  return self
end

function page:refresh(param)
end

function page:setTouchMove(toPosy)
  local posy = self.autoText:getPositionY()
  local newToPosy = posy - toPosy
  if newToPosy > self.height then
    local tomax = 50 - (newToPosy - self.height)
    tomax = ed.clamp(tomax, 5, 50) / 50
    newToPosy = posy - toPosy * tomax
  elseif newToPosy < 281 then
    local tomax = 50 - (281 - newToPosy)
    tomax = ed.clamp(tomax, 5, 50) / 50
    newToPosy = posy - toPosy * tomax
  end
  self.movePosTab = self.movePosTab or {}
  table.insert(self.movePosTab, 1, posy)
  self.autoText:setPositionY(newToPosy)
  self.oldPosy = self.oldPosy or posy
  self.startTime = ed.getMillionTime()
end

function page:overTouchMove()
  self.autoText:stopAllActions()
  local posy = self.autoText:getPositionY()
  local movetime = ed.getMillionTime() - self.startTime
  if posy < 281 or 281 > self.height then
    posy = 281
    movetime = 0.5
  elseif posy > self.height then
    posy = self.height
    movetime = 0.5
  elseif 0.01 <= movetime then
    movetime = 0.1
  else
    local moveposy = self.oldPosy - posy
    movetime = math.abs(((self.movePosTab[5] or self.movePosTab[1]) - posy) * 0.1)
    posy = ed.clamp(posy + (0 < moveposy and -150 * movetime or 150 * movetime), 281, self.height)
  end
  local move = CCMoveTo:create(movetime, ccp(25, posy))
  self.autoText:runAction(CCEaseExponentialOut:create(move))
  self.oldPosy = nil
  self.startTime = nil
  self.movePosTab = {}
end
