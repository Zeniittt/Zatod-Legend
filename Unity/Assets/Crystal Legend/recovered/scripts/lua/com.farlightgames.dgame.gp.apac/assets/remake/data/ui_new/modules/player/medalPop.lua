local base = ed.ui.popwindow
local showMedalPop = newclass(base.mt)
ed.UITool.registViewOpenFunc("showMedalPop", function(param)
  if ed.newShowMedalPop then
    ed.newShowMedalPop:destroy({skipAnim = false})
    ed.newShowMedalPop = nil
    return
  end
  ed.newShowMedalPop = setmetatable(base.create("showMedalPop", {
    noShade = not param.shade,
    notBlurBg = true
  }), showMedalPop.mt):create(param)
  ed.newShowMedalPop:popWindow(999)
end)

function showMedalPop:create(param)
  self:showDictInfo(param.data, param.x, param.y)
  self:registerTouchHandler()
  self:show({skipAnim = false})
  return self
end

function showMedalPop:showDictInfo(data, x, y)
  local autoText = ed.ui.autoText:new()
  autoText:initParam({
    context = data["Unlock Description"] or "",
    fontSize = 16,
    maxWidth = 300,
    color = ccc3(253, 234, 197)
  })
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 10, 200))
  local width, height = autoText:getCurContentSize()
  bg:setContentSize(CCSizeMake(width + 40, height + 46))
  autoText.node:setPosition(ccp(20, height))
  bg:addChild(autoText.node)
  local label = ed.createttf(data.Name or "", 16)
  label:setPosition(ccp(20, height + 27))
  label:setAnchorPoint(ccp(0, 0.5))
  label:setColor(ccc3(255, 255, 240))
  bg:addChild(label)
  height = height + 20
  local line = ed.createScale9Sprite("UI/alpha/1080P/sweep/sweep_line.png", CCRectMake(20, 1, 150, 1))
  line:setContentSize(CCSizeMake(width - 4, 1))
  line:setPosition(width / 2 + 20, height - 5)
  bg:addChild(line)
  local pos1, pos2 = self:locationAdaptation(x, y, width, height)
  bg:setPosition(pos2[1], pos2[2])
  self.actionLayer:setPosition(pos1[1], pos1[2])
  self.uiBg = bg
  self.actionLayer:addChild(bg)
end

function showMedalPop:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.uiBg,
    key = "out_click",
    clickHandler = function()
      if ed.newShowMedalPop then
        ed.newShowMedalPop:destroy({skipAnim = false})
        ed.newShowMedalPop = nil
      end
    end,
    priority = -999,
    force = true,
    clickInterval = 0.5
  })
end

function showMedalPop:locationAdaptation(x, y, width, height)
  local pyX, pyY
  if x > ed.display.winSize.width / 2 then
    pyX = (width / 2 + 20) * -1
  else
    pyX = width / 2 + 20
  end
  if y < ed.display.winSize.height / 2 then
    pyY = height / 2 + 30
  else
    pyY = (height / 2 + 30) * -1
  end
  return {
    x - ed.display.winSize.width / 2,
    y - ed.display.winSize.height / 2
  }, {
    ed.display.winSize.width / 2 + pyX,
    ed.display.winSize.height / 2 + pyY
  }
end

local function csLocalfunc(res, pos, scale, parent)
  local sprite = ed.createSprite(res)
  sprite:setPosition(pos)
  sprite:setScale(scale or 1)
  if parent then
    parent:addChild(sprite)
  end
  return sprite
end

local getMedalPop = newclass(base.mt)
ed.UITool.registViewOpenFunc("getMedalPop", function(param)
  setmetatable(base.create("getMedalPop"), getMedalPop.mt):create(param):popWindow()
end)

function getMedalPop:create(param)
  local uiBg = csLocalfunc("UI/alpha/1080P/medal/medal_get_bg.png", ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2), 1, self.container)
  local medalCfg
  for _, v in pairs(ed.getDataTable("Medal")) do
    if param and param.id == v.MedalID then
      medalCfg = v
      break
    end
  end
  local size = uiBg:getContentSize()
  local posx, posy = size.width / 2, size.height / 2
  if medalCfg then
    local title = csLocalfunc("UI/alpha/1080P/medal/medal_get_text.png", ccp(posx, posy + 140), 1, uiBg)
    local icon = csLocalfunc(medalCfg.Picture, ccp(posx, posy), 0.01, uiBg)
    if medalCfg.LifeTimeDay and medalCfg.LifeTimeDay > 0 then
      local tag = csLocalfunc("UI/alpha/1080P/medal/medal_time_limit.png", ccp(posx + 60, posy + 60), 1, uiBg)
    end
    local nameBg = csLocalfunc("UI/alpha/1080P/medal/medal_get_name.png", ccp(posx, posy - 140), 1, uiBg)
    local label = ed.createttf(medalCfg.Name or "nil", 20)
    label:setPosition(ccp(104, 13.5))
    label:setColor(ccc3(251, 217, 73))
    label:setStroke(ccc3(0, 0, 0), 0.7)
    label:setFontName(ed.fontBold)
    nameBg:addChild(label)
    self:registerTouchHandler(nameBg)
    icon:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCEaseBackOut:create(CCScaleTo:create(0.3, 1))))
  end
  self.container:setPosition(0, 0)
  self:show({skipAnim = false})
  return self
end

function getMedalPop:registerTouchHandler(area)
  self:btRegisterOutClick({
    area = area,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
end
