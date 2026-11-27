local base = ed.ui.popwindow
local commonDelayRewardPop = newclass(base.mt)
ed.UITool.registViewOpenFunc("commonDelayRewardPop", function(param)
  commonDelayRewardPop.create(param or {}):popWindow()
end)

function commonDelayRewardPop.create(param)
  return setmetatable(base.create("commonDelayRewardPop"), commonDelayRewardPop.mt):init(param or {})
end

function commonDelayRewardPop:init(param)
  self.param = param
  self.time = self.param.time or 10
  self:editorui()
  self:initView()
  self:addEventListen()
  self:show({skipAnim = false})
  return self
end

function commonDelayRewardPop:editorui()
  local ui = {}
  local width, height = 360, 200
  ui.bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/com_new_3.png",
    pos = ccp(ed.display.winSize.width / 2 - ed.display.halfFixedWidth, ed.display.winSize.height / 2 - ed.display.halfFixedHeight),
    parent = self.container,
    scale = 1,
    rectMake = CCRectMake(8, 8, 37, 37),
    sizeMake = CCSizeMake(width, height)
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
    pos = ccp(width / 2 - 70, height - 20),
    parent = ui.bg,
    scale = 0.8
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
    pos = ccp(width / 2 + 70, height - 20),
    parent = ui.bg,
    scale = 0.8
  })
  ed.createLabelTools({
    txt = T("\230\143\144\231\164\186"),
    size = 16,
    pos = ccp(width / 2, height - 20),
    color = ccc3(245, 221, 183),
    parent = ui.bg
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
    pos = ccp(width / 2, 60),
    parent = ui.bg,
    scale = 1
  })
  ui.close = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    pos = ccp(width / 2 - 100, 30),
    parent = ui.bg,
    scale = 0.85
  })
  ed.createLabelTools({
    txt = T("\230\136\145\229\134\141\230\131\179\230\131\179"),
    size = 16,
    pos = ccp(52, 22),
    color = ccc3(252, 241, 165),
    shadow = {
      ccc3(0, 0, 0),
      ccp(0, 2)
    },
    parent = ui.close
  })
  ui.right = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    pos = ccp(width / 2 + 100, 30),
    parent = ui.bg,
    scale = 0.85,
    notShow = true
  })
  ed.createLabelTools({
    txt = T("\231\161\174\229\174\154"),
    size = 16,
    pos = ccp(52, 22),
    color = ccc3(252, 241, 165),
    shadow = {
      ccc3(0, 0, 0),
      ccp(0, 2)
    },
    parent = ui.right
  })
  ui.delay = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    pos = ccp(width / 2 + 100, 30),
    parent = ui.bg,
    scale = 0.85
  })
  ed.setSpriteShader(ui.delay, "GrayScalingShader_2")
  local timeStr = ed.createLabelTools({
    txt = T("\231\161\174\229\174\154(%ds)", self.time),
    size = 16,
    pos = ccp(52, 22),
    color = ccc3(214, 214, 214),
    shadow = {
      ccc3(0, 0, 0),
      ccp(0, 2)
    },
    parent = ui.delay
  })
  self:listenTimer(Timer:Always(1), function()
    self.time = self.time - 1
    if self.time == 0 then
      ui.delay:setVisible(false)
      ui.right:setVisible(true)
    elseif self.time >= 0 then
      timeStr:setString(T("\231\161\174\229\174\154(%ds)", self.time))
    end
  end)
  self.ui = ui
end

function commonDelayRewardPop:initView()
  local extraStr = self.param.autoStr or "autoStr is nil"
  local thisCon = self.ui.bg:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = extraStr,
    fontSize = 16,
    lineSpacing = 4,
    maxWidth = thisCon.width - 90,
    color = ccc3(255, 252, 231)
  })
  autoText.node:setPosition(ccp(50, thisCon.height - 60))
  self.ui.bg:addChild(autoText.node)
end

function commonDelayRewardPop:addEventListen()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = false})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.close,
    key = "close",
    clickInterval = 1,
    clickHandler = function()
      self:destroy({skipAnim = false})
    end,
    force = true,
    pressScale = 0.8,
    normalScale = 0.85
  })
  self:btRegisterButtonClick({
    button = self.ui.right,
    key = "right",
    clickInterval = 1,
    clickHandler = function()
      if self.param.clickHandler then
        self.param.clickHandler()
      else
        ed.showToast(T("not clickHandler"))
      end
      self:destroy({skipAnim = false})
    end,
    force = true,
    pressScale = 0.8,
    normalScale = 0.85
  })
end
