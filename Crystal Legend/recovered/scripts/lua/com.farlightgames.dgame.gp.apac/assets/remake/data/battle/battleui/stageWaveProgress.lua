local class = newclass("g")
ed.ui.stageWaveProgress = class

function class.create(param)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(param or {})
  return self
end

function class:init(param)
  self.totalTime = param.totalTime or 0
  self.totalWave = param.totalWave or 0
  self.waveTimeList = param.waveTimeList
  self.currentTime = 0
  self:initView()
end

function class:initView()
  local bg = ed.createSprite("UI/alpha/1080P/dungeon/battle/process_bg.png")
  self.bg = bg
  self.bgSize = bg:getContentSize()
  local bar = ed.createSprite("UI/alpha/1080P/dungeon/battle/process.png")
  self.bar = bar
  local barSize = bar:getContentSize()
  self.barSize = barSize
  local clipLayer = CCLayer:create()
  self.bg:addChild(clipLayer)
  clipLayer:setContentSize(barSize)
  clipLayer:setClipRect(CCRectMake(0, 0, barSize.width, barSize.height))
  clipLayer:setPosition(ccp(3, 7))
  self.clipLayer = clipLayer
  clipLayer:addChild(bar)
  ed.layout.centerInParent(bar)
  local light = ed.createSprite("UI/alpha/1080P/dungeon/battle/process_on.png")
  light:setAnchorPoint(ccp(1, 0.5))
  light:setPosition(ccp(0, barSize.height / 2))
  bar:addChild(light)
  self.light = light
  local tisBg = ed.createSprite("UI/alpha/1080P/dungeon/battle/number_bg.png")
  self.bg:addChild(tisBg)
  tisBg:setPosition(ccp(barSize.width / 2, -25))
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format(T("\230\156\172\229\133\179\228\184\128\229\133\177<lable color=ccc3(255,220,79) fontSize=f23 strokeColor=0xcc330f strokeSize=1> %s </lable>\230\179\162"), self.totalWave),
    fontSize = 15,
    color = ccc3(255, 235, 193),
    strokeColor = ccc3(0, 0, 0),
    strokeSize = 1
  })
  tisBg:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local tipsBgSize = tisBg:getContentSize()
  autoText.node:setPosition(ccp(tipsBgSize.width / 2 - autoTextW / 2, tipsBgSize.height / 2))
  self:initWaveIcon()
  self:updateBar()
  self:updateWaveIcon()
end

function class:initWaveIcon()
  self.waveIconList = {}
  for index = 0, #self.waveTimeList do
    local time = self.waveTimeList[index] or 0
    local waveIcon = ed.createSprite("UI/alpha/1080P/dungeon/battle/icon_off.png")
    self.bg:addChild(waveIcon)
    waveIcon:setPosition(ccp(self.barSize.width * time / self.totalTime, self.bgSize.height / 2))
    waveIcon.time = time
    waveIcon.index = index
    waveIcon.state = "off"
    table.insert(self.waveIconList, waveIcon)
  end
end

function class:update(dt)
  self.currentTime = ed.engine.ticks * ed.tick_interval
  self:updateBar()
  self:updateWaveIcon()
end

function class:updateBar()
  local percent = self.currentTime / self.totalTime
  percent = math.min(1, percent)
  self.light:setPositionX(self.barSize.width * percent)
  self.clipLayer:setClipRect(CCRectMake(0, 0, self.barSize.width * percent, self.barSize.height))
end

function class:updateWaveIcon()
  for index, waveIcon in ipairs(self.waveIconList) do
    if self.currentTime >= waveIcon.time and waveIcon.state == "off" then
      ed.setTexture(waveIcon, "UI/alpha/1080P/dungeon/battle/icon_on.png", true)
      waveIcon.state = "on"
    end
  end
end
