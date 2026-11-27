local progress = {}
progress.__index = progress
progress.visible = true
progress.scale = 1
progress.currentProgress = 1
progress.maxProgress = 100

function progress:initBaseInfo(data)
  self.visible = true
  self.dataInfo = data
end

function progress:getNode()
  return self.node
end

function progress:isVisible()
  return self.visible
end

function progress:setVisible(visible)
  self.visible = visible
  self.node:setVisible(visible)
end

function progress:getMaxProgress()
  return self.maxProgress
end

function progress:setMaxProgress(pro)
  self.maxProgress = pro
end

function progress:setProgress(progress)
  self.currentProgress = progress
  self.progress:setScaleX(progress / self.maxProgress)
end

function progress:isContainPoint(x, y)
  if nil == self.bg then
    return false
  end
  local inside = ed.containsPoint(self.bg, x, y)
  return inside
end

function progress:getContentSize()
  if nil == self.bg then
    print("progress self.bg is nil")
    return false
  end
  return self.bg:getContentSize()
end

function progress:setPosition(pos)
  if self.node and pos then
    self.node:setPosition(pos)
  end
end

function progress:setScaleX(scale)
  assert(scale, "scale can not be nil ")
  assert(self.node, "self.node can not be nil ")
  self.node:setScaleX(scale)
end

function progress:getPosition()
  if self.node then
    return self.node:getPosition()
  else
    print("progress self.node is nil")
  end
end

function progress:addChild(node, z)
  if node == nil then
    return
  end
  local z = z or 0
  if self.node then
    self.node:addChild(node, z)
  end
end

ProgressBar = {}
setmetatable(ProgressBar, progress)
ProgressBar.__index = ProgressBar
ProgressBar.node = nil

function ProgressBar:initNode(node, data)
  if not node then
    return
  end
  local frame = ed.getSpriteFrame(data.res)
  if frame then
    node:initWithSpriteFrame(frame)
  end
  ed.readnode.setLayout(nil, node, data)
  self:addChild(node)
end

function ProgressBar:getTags()
  return self.splitTags, self.tags
end

function ProgressBar:initTags(data)
  if not data.config then
    return
  end
  if not data.config.splits then
    return
  end
  local list = data.config.splits
  local split_text = {}
  local tags = {}
  for k, tag in pairs(list) do
    tag.text = tonumber(tag.text)
    table.insert(tags, tag.text)
    if tag.text >= 10000 then
      tag.text = string.format("%s\228\184\135", tag.text / 10000)
    end
    split_text[k] = ed.createLabelWithFontInfo(tag.text, "normalButton")
    ed.readnode.setLayout(nil, split_text[k], tag)
    self:addChild(split_text[k])
  end
  table.sort(tags, function(a, b)
    return a < b
  end)
  self.tags = tags
  self.splitTags = split_text
end

function ProgressBar:initData(data)
  self.isScale = data.isScale
  local contentSize = self.progress:getContentSize()
  self.defaultSize = contentSize
  local maxProgress = data.maxProgress or contentSize.width
  self:setMaxProgress(maxProgress)
  self.currentProgress = data.currentProgress or 0
  self:setProgress(self.currentProgress)
end

function ProgressBar:setProgress(progress)
  local x = self.lightOrigPositionX or 0
  self.currentProgress = progress
  local cp = self.currentProgress
  local scale = self.currentProgress / self.maxProgress
  local tagsUi, tags = self:getTags()
  if tagsUi then
    for k = 1, #tags - 1 do
      if cp <= tags[k] then
        scale = cp / tags[k] / #tags
        break
      end
      if cp > tags[k] and cp < tags[k + 1] then
        scale = (k + (cp - tags[k]) / (tags[k + 1] - tags[k])) / #tags
        break
      end
      scale = 1
    end
  end
  if self.isScale then
    self.progress:setScaleX(scale)
    x = x + self.progress:getContentSize().width * scale
  else
    local proContentSize = self.defaultSize
    local rect = self.progress:boundingBox()
    rect.origin.x = 0
    rect.origin.y = 0
    rect.size.width = scale * proContentSize.width
    rect.size.height = proContentSize.height
    self.progress:setTextureRect(rect)
    x = x + rect.size.width
  end
  if self.light then
    local y = self.light:getPositionY()
    self.light:setPosition(ccp(x, y))
    if x < self.light:getContentSize().width / 3 then
      self.light:setVisible(false)
    else
      self.light:setVisible(true)
    end
  end
end

function ProgressBar:init(data)
  self.node = CCSprite:create()
  if self.dataInfo ~= nil then
    local base = self.dataInfo.base
    if base ~= nil then
      if base.bg then
        self.bg = CCSprite:create()
        self:initNode(self.bg, base.bg)
      end
      if base.progress then
        self.progress = CCSprite:create()
        self:initNode(self.progress, base.progress)
      end
      if base.light then
        self.light = CCSprite:create()
        self:initNode(self.light, base.light)
        self.lightOrigPositionX = self.light:getPositionX()
      end
      if base.tags then
        self.tags = CCSprite:create()
        self:initNode(self.tags, base.tags)
        self:initTags(base.tags)
      end
      ed.readnode.setLayout(nil, self.node, base)
      self:initData(base)
    end
  end
end

function ProgressBar:Remove()
  assert(self.node, "self.node can not be nil")
  self.node:removeFromParentAndCleanup(true)
end

function ProgressBar:new(data)
  local object = {}
  setmetatable(object, self)
  object:initBaseInfo(data)
  object:init(data)
  return object
end
