local mainButton = newclass()
ed.ui.mainButton = mainButton

function mainButton.create(controller, config)
  local self = {}
  setmetatable(self, mainButton.mt)
  self.config = config
  self.controller = controller
  self:init()
  return self
end

function mainButton:init()
  local cfg = self.config
  if cfg.createUIFunc then
    local container, ui = cfg.createUIFunc(self)
    self.size = ui.root:getContentSize()
    self.node = container
    self.redTag = ui.red_img
    self.timeTxt = ui.time_txt
    self.redNumTxt = ui.red_num_txt
  else
    local bg = ed.createSprite(cfg.bgRes)
    bg:setCascadeOpacityEnabled(true)
    local size = bg:getContentSize()
    local icon
    if type(cfg.icon) == "function" then
      icon = ed.createSprite(cfg.icon())
    else
      icon = ed.createSprite(cfg.icon)
    end
    icon:setPosition(size.width / 2, size.height / 2 + 5)
    bg:addChild(icon)
    local text
    if not ed.stringIsNilOrEmpty(cfg.nameRes) then
      text = ed.createttf(cfg.nameRes, 18)
      ed.setLabelColor(text, ed.toccc3(15785405))
      ed.setLabelStroke(text, ed.toccc3(3483679), 1.5)
    elseif cfg.name then
      local name = type(cfg.name) == "function" and cfg.name() or cfg.name
      text = ed.createLabelTTF(name, 15)
      if ed.isAreaZh() then
        if cfg.nameWidth then
          local nameWidth = type(cfg.nameWidth) == "function" and cfg.nameWidth() or cfg.nameWidth
          ed.setLabelDimensions(text, CCSizeMake(nameWidth, 0))
        else
          ed.setLabelDimensions(text, CCSizeMake(30, 0))
        end
      else
        ed.adaptLabel(text, {
          maxWidth = 50,
          maxHeight = 50,
          minScale = 0.7
        })
      end
      text:setStroke(ccc3(75, 57, 46), 1)
      text:setColor(ccc3(255, 252, 231))
    else
      icon:setPosition(size.width / 2, size.height / 2)
    end
    if text then
      text:setPosition(size.width / 2, 5)
      bg:addChild(text)
    end
    local timeTxt
    if cfg.timeStrFunc then
      local time = cfg.timeStrFunc()
      timeTxt = ed.createLabelTTF(time, 15)
      timeTxt:setStroke(ed.toccc3(2565412), 1)
      timeTxt:setColor(ed.toccc3(16776423))
      local posY = 5
      if text then
        posY = posY - text:getContentSize().height * 0.5 - timeTxt:getContentSize().height * 0.5
      end
      timeTxt:setPosition(size.width / 2, posY)
      bg:addChild(timeTxt)
    end
    local redTag = ed.createSprite(cfg.redTagRes)
    redTag:setVisible(false)
    redTag:setPosition(size.width - 5, size.height - 5)
    bg:addChild(redTag)
    self.node = bg
    self.size = size
    self.redTag = redTag
    self.timeTxt = timeTxt
  end
  self:updatePerHalfSecond()
  self.controller:btRegisterButtonClick({
    button = self.node,
    key = "mainButton" .. self.config.type,
    force = true,
    clickHandler = function()
      if self.controller.autoCloseMenu then
        self.controller:switchMenu(false, false)
      end
      if self.controller.identity == cfg.openViewIdentity then
        return
      end
      if cfg.onClick then
        cfg.onClick(cfg)
      else
        ed.UITool.openView(cfg.openViewIdentity)
      end
    end,
    pressScale = 1.2,
    priority = cfg.priority or ed.ui.commonscene.TOUCH_PRIORITY
  })
  self.prePos = ccp(0, 0)
  self.redTagLighting = false
  self:updateRedTag()
end

function mainButton:getSize()
  return self.size
end

function mainButton:setPosition(x, y)
  self.node:setPosition(x, y)
end

function mainButton:getPosition()
  return self.node:getPosition()
end

function mainButton:setVisible(visible)
  self.node:setVisible(visible)
end

function mainButton:addTo(parent, release)
  parent:addChild(self.node)
  if release then
    self.node:release()
  end
end

function mainButton:remove(retain)
  if retain then
    self.node:retain()
  end
  self.node:removeFromParentAndCleanup(true)
end

function mainButton:updatePerHalfSecond()
  if self.config.timeStrFunc and self.timeTxt then
    ed.setLabelString(self.timeTxt, self.config:timeStrFunc())
  end
end

function mainButton:updateRedTag()
  if tolua.isnull(self.redTag) then
    return
  end
  if self.config.getRedPointStatus then
    local tag
    self.redTagLighting, tag = self.config.getRedPointStatus()
    if self.config.bgTag and tag and type(tag) == "number" then
      local res = tag == 1 and self.config.redTagRes or self.config.bgTag
      ed.initSpriteWithFrame(self.redTag, res)
      self.redTag:setVisible(0 < tag)
    elseif self.redTagLighting then
      self.redTag:setVisible(true)
    else
      self.redTag:setVisible(false)
    end
  end
  if self.config.getRedPointNum then
    local num = self.config.getRedPointNum()
    if 0 < num then
      if nil == self.redNumTxt then
        self.redNumTxt = ed.createLabelTTF(num, 12)
        self.redTag:addChild(self.redNumTxt)
        local tagSize = self.redTag:getContentSize()
        self.redNumTxt:setPosition(tagSize.width / 2, tagSize.height / 2)
      else
        ed.setLabelString(self.redNumTxt, num)
      end
      self.redTag:setVisible(true)
    else
      self.redTag:setVisible(false)
    end
  end
end

function mainButton:getRedTagStatus()
  return self.redTagLighting
end

function mainButton:getNode()
  return self.node
end

function mainButton:setPrePos(x, y)
  self.prePos.x = x
  self.prePos.y = y
end

function mainButton:getPrePos(x, y)
  return self.prePos
end
