local class = newclass("g")
ed.ui.gradientLabel = class

function class.create(param)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(param)
  return self
end

function class:init(param)
  self:refresh(param)
end

function class:refresh(param)
  param = param or {}
  self.param = param
  self.text = param.text or ""
  self.fontName = param.fontName or ed.font
  self.fontSize = param.fontSize or 18
  self.dimensions = param.dimensions or CCSizeMake(0, 0)
  self.hAlignment = param.hAlignment or kCCTextAlignmentCenter
  self.vAlignment = param.vAlignment or kCCVerticalTextAlignmentBottom
  self.strokeLabelColor = param.strokeLabelColor
  self.strokeColor = param.strokeColor
  self.strokeSize = param.strokeSize
  self.strokeOffset = param.strokeOffset or ccp(0, 0)
  self.shadowColor = param.shadowColor
  self.shadowOffset = param.shadowOffset
  self.labelColor = param.labelColor
  self.startColor = param.startColor
  self.endColor = param.endColor
  self.startAnchorPoint = param.startAnchorPoint or ccp(0.5, 0)
  self.endAnchorPoint = param.endAnchorPoint or ccp(0.5, 1)
  self.strokeStartColor = param.strokeStartColor
  self.strokeEndColor = param.strokeEndColor
  self.strokeStartAnchorPoint = param.strokeStartAnchorPoint or ccp(0.5, 0)
  self.strokeEndAnchorPoint = param.strokeEndAnchorPoint or ccp(0.5, 1)
  self.shadowStartColor = param.shadowStartColor
  self.shadowEndColor = param.shadowEndColor
  self.shadowStartAnchorPoint = param.shadowStartAnchorPoint or ccp(0.5, 0)
  self.shadowEndAnchorPoint = param.shadowEndAnchorPoint or ccp(0.5, 1)
  self:initLabels()
  self:initShader()
end

function class:createLabelComponent()
  return CCLabelTTF:create(self.text, self.fontName, self.fontSize, self.dimensions, self.hAlignment, self.vAlignment)
end

function class:updateLabelComponent(label)
  label:setString(self.text)
end

function class:initLabels()
  if nil == self.node then
    local baseNode = CCSprite:create()
    baseNode:setCascadeOpacityEnabled(true)
    baseNode:setAnchorPoint(ccp(0.5, 0.5))
    self.node = baseNode
  end
  if nil == self.labelMain then
    self.labelMain = self:createLabelComponent()
    self.node:addChild(self.labelMain, 3)
  else
    self:updateLabelComponent(self.labelMain)
  end
  self.size = self.labelMain:getContentSize()
  self.node:setContentSize(self.size)
  self.labelMain:setPosition(ccp(self.size.width / 2, self.size.height / 2))
  if self.strokeSize then
    if nil == self.labelStroke then
      self.labelStroke = self:createLabelComponent()
      self.node:addChild(self.labelStroke, 2)
    else
      self.labelStroke:setVisible(true)
      self:updateLabelComponent(self.labelStroke)
    end
    if self.strokeLabelColor then
      self.labelStroke:setColor(self.strokeLabelColor)
    end
    self.labelStroke:setStroke(self.strokeColor or ccc3(255, 255, 255), self.strokeSize or 1)
    self.labelStroke:setPosition(ccp(self.size.width / 2 + self.strokeOffset.x, self.size.height / 2 + self.strokeOffset.y))
  elseif nil ~= self.labelStroke then
    self.labelStroke:setVisible(false)
  end
  if self.shadowOffset then
    if nil == self.labelShadow then
      self.labelShadow = self:createLabelComponent()
      self.node:addChild(self.labelShadow, 1)
    else
      self.labelShadow:setVisible(true)
      self:updateLabelComponent(self.labelShadow)
    end
    self.labelShadow:setColor(self.shadowColor)
    self.labelShadow:setStroke(self.shadowColor, self.strokeSize or 1)
    self.labelShadow:setPosition(ccp(self.size.width / 2 + self.shadowOffset.x, self.size.height / 2 + self.shadowOffset.y))
  elseif nil ~= self.labelShadow then
    self.labelShadow:setVisible(false)
  end
end

function class:initShader()
  if self.labelMain and self.startColor and self.endColor then
    EDLoadShader("ColorGradientShader")
    ed.useShader(self.labelMain, "ColorGradientShader")
    local shader = self.labelMain:getShaderProgram()
    local startColorLocation = shader:getUniformLocationForName("startColor")
    shader:setUniformLocationWith4f(startColorLocation, self.startColor.r, self.startColor.g, self.startColor.b, 0)
    local endColorLocation = shader:getUniformLocationForName("endColor")
    shader:setUniformLocationWith4f(endColorLocation, self.endColor.r, self.endColor.g, self.endColor.b, 0)
    local startPosLocation = shader:getUniformLocationForName("startPos")
    shader:setUniformLocationWith2f(startPosLocation, self.startAnchorPoint.x, self.startAnchorPoint.y)
    local endPosLocation = shader:getUniformLocationForName("endPos")
    shader:setUniformLocationWith2f(endPosLocation, self.endAnchorPoint.x, self.endAnchorPoint.y)
  end
  if self.strokeStartColor and self.strokeEndColor then
    EDLoadShader("ColorGradientShader")
    ed.useShader(self.labelStroke, "ColorGradientShader")
    local shader = self.labelStroke:getShaderProgram()
    local startColorLocation = shader:getUniformLocationForName("startColor")
    shader:setUniformLocationWith4f(startColorLocation, self.strokeStartColor.r, self.strokeStartColor.g, self.strokeStartColor.b, 0)
    local endColorLocation = shader:getUniformLocationForName("endColor")
    shader:setUniformLocationWith4f(endColorLocation, self.strokeEndColor.r, self.strokeEndColor.g, self.strokeEndColor.b, 0)
    local startPosLocation = shader:getUniformLocationForName("startPos")
    shader:setUniformLocationWith2f(startPosLocation, self.strokeStartAnchorPoint.x, self.strokeStartAnchorPoint.y)
    local endPosLocation = shader:getUniformLocationForName("endPos")
    shader:setUniformLocationWith2f(endPosLocation, self.strokeEndAnchorPoint.x, self.strokeEndAnchorPoint.y)
  elseif self.strokeColor then
    ed.setLabelStroke(self.labelStroke, self.strokeColor, self.strokeSize or 1)
  end
end

function class:setString(text)
  self.text = text
  local size = CCSizeMake(0, 0)
  if self.labelMain then
    self.labelMain:setString(self.text)
    size = self.labelMain:getContentSize()
    self.node:setContentSize(size)
    self.labelMain:setPosition(ccp(size.width / 2, size.height / 2))
  end
  if self.labelStroke then
    self.labelStroke:setString(self.text)
    self.labelStroke:setPosition(ccp(size.width / 2, size.height / 2))
  end
  if self.labelShadow then
    self.labelShadow:setString(self.text)
    self.labelShadow:setPosition(ccp(size.width / 2 + self.shadowOffset.x, size.height / 2 + self.shadowOffset.y))
  end
end

function class:getContentSize()
  return self.node:getContentSize()
end

function class:setPosition(position)
  self.node:setPosition(position)
end
