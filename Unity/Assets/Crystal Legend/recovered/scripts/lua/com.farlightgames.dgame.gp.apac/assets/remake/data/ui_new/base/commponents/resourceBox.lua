local resourceBox = newclass()
ed.ui.resourceBox = resourceBox

function resourceBox.create(controller)
  local self = {}
  setmetatable(self, resourceBox.mt)
  self.controller = controller
  self:init()
  return self
end

function resourceBox:init()
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  self.container = container
  self.ui = {}
  local configs = ed.ui.configs.resBar.getSceneBarsConfig(self.controller.identity)
  if not configs then
    return
  end
  self.bars = {}
  for i, v in ipairs(configs) do
    local config = ed.ui.configs.resBar.getResBarConfig(v)
    if type(config.itemId) == "function" then
      config.itemId = config.itemId()
    end
    self.bars[config.itemId or v] = self:createBar(v, config)
  end
  local size = CCSizeMake(#configs * 175, 28)
  container:setContentSize(size)
  ed.layout.layoutChildrenWithSize(container, size, ed.layoutType.Grid, {
    gridSize = CCSizeMake(175, 28)
  })
end

function resourceBox:createBar(name, config)
  local readNode = ed.readnode.create(self.container, self.ui)
  local doAccess = config.doAccess
  local showDetail = config.showDetail
  local getRedPointStatus = config.getRedPointStatus
  local parent = name .. "_bg"
  local smallIcon
  if type(config.smallIcon) == "function" then
    smallIcon = config.smallIcon()
  else
    smallIcon = config.smallIcon
  end
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = parent,
        res = config.bgRes or "UI/alpha/1080P/main/main_status_number_bg.png",
        capInsets = CCRectMake(5, 5, 2.5, 7.5)
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(170, 28)
      }
    },
    {
      t = "Sprite",
      base = {
        name = name .. "_icon",
        res = smallIcon or config.icon,
        parent = parent
      },
      layout = {
        position = ccp(155, 14)
      },
      config = {
        scale = config.scale or 1
      }
    },
    {
      t = "Sprite",
      base = {
        name = name .. "_add_icon",
        res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
        parent = parent,
        visible = doAccess ~= nil
      },
      layout = {
        position = ccp(14, 14)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = name .. "_text_value",
        z = 0,
        parent = parent,
        text = ed.formatNumWithComma(config.initValue(name)),
        size = 16
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(140, 14)
      },
      config = {}
    }
  }
  readNode:addNode(ui_info)
  local value = self.ui[name .. "_text_value"]
  value:setStroke(ccc3(0, 0, 0), 1.5)
  value:setColor(ccc3(255, 252, 231))
  local addbtn = readNode.array[name .. "_add_icon"]
  if name == "vitality" or name == "adventureVitality" or name == "awakestagevitality" then
    self.controller:btRegisterButtonClick({
      button = readNode.array[name .. "_bg"],
      pressHandler = function()
        self.controller:createVitalityPrompt()
      end,
      liftHandler = function()
        self.controller:destroyPromptCard()
      end,
      priority = ed.ui.commonscene.TOUCH_PRIORITY + 1
    })
  end
  local redLight
  if type(doAccess) == "function" then
    self.controller:btRegisterRectClick({
      rect = CCRectMake(0, 0, 100, 28),
      parent = addbtn,
      pressHandler = function()
        if not tolua.isnull(addbtn) then
          addbtn:setScale(1.1)
        end
      end,
      cancelPressHandler = function()
        if not tolua.isnull(addbtn) then
          addbtn:setScale(1)
        end
      end,
      clickHandler = function()
        if self.parent:isVisible() then
          doAccess()
        end
      end,
      priority = ed.ui.commonscene.TOUCH_PRIORITY
    })
    if type(getRedPointStatus) == "function" then
      redLight = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
      redLight:setPosition(ccp(20, 20))
      redLight:setVisible(getRedPointStatus())
      addbtn:addChild(redLight)
    end
  else
    addbtn:setVisible(false)
  end
  if showDetail and type(showDetail) == "function" then
    local icon = readNode.array[name .. "_icon"]
    self.controller:btRegisterRectClick({
      rect = CCRectMake(0, 0, 30, 30),
      parent = icon,
      pressHandler = function()
        if not tolua.isnull(icon) then
          icon:setScale(1.1)
        end
      end,
      cancelPressHandler = function()
        if not tolua.isnull(icon) then
          icon:setScale(1)
        end
      end,
      clickHandler = function()
        if self.parent:isVisible() then
          showDetail()
        end
      end,
      priority = ed.ui.commonscene.TOUCH_PRIORITY
    })
  end
  return {
    label = value,
    config = config,
    redLight = redLight
  }
end

function resourceBox:addTo(parent)
  self.parent = parent
  parent:addChild(self.container)
  ed.layout.layoutWithMagin(self.container, {right = 0, top = 0})
end

function resourceBox:updateAllResourceValue()
  for resType, v in pairs(self.bars or {}) do
    self:updateResourceValue(resType)
  end
end

function resourceBox:updateResourceValue(resType, id)
  if not self.bars then
    return
  end
  local key = id or resType
  local bar = self.bars[key]
  if not bar then
    return
  end
  if bar.redLight then
    local getRedPointStatus = bar.config.getRedPointStatus
    if getRedPointStatus then
      bar.redLight:setVisible(getRedPointStatus())
    end
  end
  local upperLimit = bar.config.upperLimit and bar.config.upperLimit(key) or nil
  if upperLimit then
    bar.label:setString(ed.formatNumWithComma(bar.config.initValue(key)) .. "/" .. upperLimit)
  else
    bar.label:setString(ed.formatNumWithComma(bar.config.initValue(key)))
  end
end
