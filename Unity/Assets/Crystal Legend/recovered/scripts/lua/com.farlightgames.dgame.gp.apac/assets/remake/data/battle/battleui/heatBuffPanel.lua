local class = {}
ed.ui.HeatbuffPanel = class

function class.create(param)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(param)
  return self
end

function class:init(param)
  self.activeHeat = param.activeHeat or {}
  self.column = param.column or 10
  self.tipsPanel = nil
  self:initView()
end

function class:initView()
  self.node = CCLayer:create()
  self.node:ignoreAnchorPointForPosition(false)
  self.node:setAnchorPoint(ccp(0.5, 1))
  self.buffIcon = {}
  self:createAllBuffIcon()
  self.node:setTouchEnabled(true)
  self.node:registerScriptTouchHandler(self:doMainLayerTouch(), false, -300, false)
end

function class:createAllBuffIcon()
  local size = CCSizeMake(28, 28)
  local containerSize = CCSizeMake(size.width * self.column, size.height * math.ceil(#self.activeHeat / self.column))
  self.node:setContentSize(containerSize)
  local amount = 0
  for index, heatData in ipairs(self.activeHeat) do
    local icon = self:createBuffIcon(heatData)
    icon.heatData = heatData
    icon:setScale(0.6)
    self.node:addChild(icon)
    local x = containerSize.width - amount % self.column * size.width - size.width / 2
    local y = containerSize.height + math.floor(amount / self.column) * -size.height - size.height / 2
    icon:setPosition(ccp(x, y))
    self.buffIcon[heatData._heat_id] = icon
    amount = amount + 1
  end
end

function class:createBuffIcon(heatData)
  local heatCfg = ed.getDataTable("Heat")[heatData._heat_id]
  local iconPath = heatCfg.Icon
  local icon = CCSprite:create(iconPath)
  return icon
end

function class:doMainLayerTouch()
  local function handler(event, x, y)
    xpcall(function()
      self:iconTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

function class:iconTouch(event, x, y)
  if event == "began" then
    for _, icon in pairs(self.buffIcon) do
      if ed.containsPoint(icon, x, y) then
        local heatData = icon.heatData
        self.optionDetail = self:showOptionDetail(icon, heatData)
      end
    end
  elseif event == "ended" and self.optionDetail then
    self.optionDetail:removeFromParentAndCleanup(true)
    self.optionDetail = nil
  end
end

function class:showOptionDetail(parent, heatData)
  local heatId = heatData._heat_id
  local level = heatData._times
  local heatCfg = ed.getDataTable("Heat")[heatId]
  if not heatCfg then
    return
  end
  local iconPath = heatCfg.Icon
  local heatName = heatCfg.HeatName
  local frontDesc = heatCfg.FrontDescription
  local heatValue = heatCfg.HeatValue1
  local scriptArg = heatCfg.ScriptArg1
  local parameter = heatCfg.Parameter
  local optionDetail = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png")
  parent:getParent():addChild(optionDetail, 999)
  optionDetail:setAnchorPoint(ccp(0.5, 1))
  local icon = ed.createSprite(iconPath)
  icon:setScale(0.6)
  optionDetail:addChild(icon)
  local nameLabel = ed.createLabelTTF(heatName, 20)
  ed.setLabelColor(nameLabel, ed.toccc3(16776423))
  ed.setLabelStroke(nameLabel, ed.toccc3(2565412), 1)
  optionDetail:addChild(nameLabel)
  local line = ed.createSprite("UI/alpha/1080P/hades/hades_boss_line.png")
  optionDetail:addChild(line)
  local desc
  if level then
    desc = frontDesc .. "\239\188\154" .. string.format("<lable color=ccc3(232,177,82) strokeColor=ccc3(39,37,36), strokeSize=1>%s</lable>", scriptArg * level .. (parameter or ""))
  else
    desc = frontDesc
  end
  if scriptArg then
    desc = string.gsub(desc, "%%ScriptArg&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", scriptArg))
  end
  desc = string.gsub(desc, "%%HeatValue&1%%", string.format("<lable color=ccc3(255,87,87) strokeColor=ccc3(65,35,29), strokeSize=1>%s</lable>", heatValue))
  desc = string.gsub(desc, "#p#", "%%")
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = desc,
    color = ed.toccc3(16113079),
    strokeColor = ed.toccc3(1774610),
    strokeSize = 1,
    maxWidth = 300,
    fontSize = 16
  })
  optionDetail:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  local bgWidth = 330
  local bgHeight = nameLabel:getContentSize().height + autoTextH + 35
  optionDetail:setContentSize(CCSizeMake(bgWidth, bgHeight))
  ed.layout.layoutWithParentMagin(icon, {left = 8, top = 7})
  ed.layout.layoutWithParentMagin(nameLabel, {left = 40, top = 15})
  ed.layout.layoutWithParentMagin(line, {left = 24, top = 45})
  ed.layout.layoutWithParentMagin(autoText.node, {left = 15, top = 60})
  local parentSize = parent:getContentSize()
  ed.layout.relateLayout(parent, optionDetail, {
    bottom = parentSize.height / 2
  })
  return optionDetail
end
