ed.ui.selectwindow = {}
local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.selectwindow.base = class
local lsr = ed.ui.heroselectlsr.create()

local function createListLayer(self)
  local clipRect, bgPos
  if self.hasClassifyPart then
    clipRect = CCRectMake(89, 60, 492, 365)
    bgPos = ccp(85, 240)
  else
    clipRect = CCRectMake(154, 60, 492, 365)
    bgPos = ccp(150, 240)
  end
  local info = {
    cliprect = clipRect,
    container = self.container,
    priority = self.mainTouchPriority - 5,
    bar = {bglen = 320, bgpos = bgPos}
  }
  self.draglist = ed.draglist.create(info)
end

class.createListLayer = createListLayer

local function createExplain(self)
  local param = self.param
  local explain = param.explain
  if not explain then
    return
  end
  self.ui.explain = ed.createNode({
    t = "Label",
    base = {text = explain, size = 20},
    layout = {
      anchor = ccp(0, 1),
      position = ccp(self.left_top_x, self.left_top_y)
    },
    config = {
      dimensions = CCSizeMake(480, 0),
      horizontalAlignment = kCCTextAlignmentLeft,
      color = ccc3(255, 218, 128)
    }
  }, self.draglist.listLayer)
end

class.createExplain = createExplain

local function createSelectLayer(self, sContainer, selectUI)
  if sContainer == nil then
    return
  end
  self.container:addChild(sContainer)
  local titleMgr = ed.TitleMgr.getInstance()
  local selectBtnCfg = titleMgr:getSelectBtnCfg() or {}
  for _, oneCfg in pairs(selectBtnCfg) do
    if oneCfg.name ~= "headBtn" then
      self:btRegisterButtonClick({
        button = selectUI[oneCfg.name],
        key = oneCfg.name,
        pressHandler = oneCfg.press,
        cancelPressHandler = oneCfg.cancle,
        clickHandler = function()
          self:destroy({skipAnim = true})
          FireEvent(oneCfg.eventName)
        end,
        force = true,
        mcpMode = true
      })
    end
  end
  self:btRegisterButtonClick({
    button = selectUI.bgS,
    press = selectUI.bgS_press,
    key = "spanBtn",
    force = true,
    mcpMode = true,
    clickHandler = function()
      self:destroy({skipAnim = true})
      FireEvent("openSpanServerSet")
    end
  })
end

class.createSelectLayer = createSelectLayer

local function create(param)
  param = param or {}
  local self = base.create("heroselect", {
    priority = param.priority
  })
  setmetatable(self, class.mt)
  self.hasClassifyPart = param.hasClassifyPart or false
  local bgpos
  if self.hasClassifyPart then
    self.left_top_x = 95
    bgpos = ccp(335, 240)
  else
    self.left_top_x = 160
    bgpos = ccp(400, 240)
  end
  self.left_top_y = 410
  self.explain_offset_y = 15
  self.param = param
  self.name = param.identity
  self.ui = {}
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/1080P/common/main_vit_tips.png",
        capInsets = CCRectMake(5, 5, 29, 13)
      },
      layout = {position = bgpos},
      config = {
        scaleSize = CCSizeMake(530, 375)
      }
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:createListLayer()
  self:createExplain()
  local area = self.ui.frame
  if "avatar" == param.name then
    local sContainer = param.sContainer
    local selectUI = param.selectUI
    self:createSelectLayer(sContainer, selectUI)
    area = {
      self.ui.frame,
      selectUI.bg,
      selectUI.bgS
    }
    local px, py = self.container:getPosition()
    self.container:setPosition(ccp(px - 45, py))
    px, py = selectUI.bg:getPosition()
    selectUI.bg:setPosition(ccp(px + 5, py))
    px, py = selectUI.bgS:getPosition()
    selectUI.bgS:setPosition(ccp(px + 5, py))
  end
  self:show({skipAnim = true})
  if not self.hasClassifyPart then
    self:btRegisterOutClick({
      area = area,
      key = "out_frame",
      clickHandler = function()
        self:destroy({skipAnim = true})
      end
    })
  end
  return self
end

class.create = create

function ed.ui.selectwindow.create(param)
  local param = param or {}
  local name = param.name
  if name then
    return ed.ui.selectwindow["of" .. name].create(param)
  end
  return nil
end

function ed.ui.selectwindow.pop(param, z)
  local window = ed.ui.selectwindow.create(param)
  window:popWindow(z)
  return window
end
