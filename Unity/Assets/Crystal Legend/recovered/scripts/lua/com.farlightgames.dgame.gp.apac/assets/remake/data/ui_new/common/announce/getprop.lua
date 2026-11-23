local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.getProp = class
class.EXTRA_TAG_CONFIG = {
  extraSoul = {
    res = "UI/alpha/1080P/soulexchange/soulexchange_reward_double.png",
    text = T("\231\129\181\233\173\130\229\136\134\232\163\130"),
    pos = ccp(75, 78)
  }
}
local resFactor = ed.display.resFactor

function class:createListLayer()
  local posX, posY = 260, 170
  local thisCon = self.ui.lay_post:getContentSize()
  local posX, posY = self.ui.lay_post:getPosition()
  local info = {
    cliprect = CCRectMake(posX - 20, posY, thisCon.width + 40, thisCon.height),
    rect = CCRectMake(posX, posY - 5, thisCon.width, thisCon.height + 10),
    container = self.container,
    upShade = "UI/alpha/1080P/mail/mail_gefitem_mask.png",
    downShade = "UI/alpha/1080P/mail/mail_gefitem_mask.png",
    capInsets = CCRectMake(10, 10, 1, 1),
    contentSize = CCSizeMake(50, 10),
    zorder = 998,
    doPressIn = self:doPressIn(),
    cancelPressIn = self:cancelPressInBreak(),
    doClickIn = self:cancelPressInBreak(),
    cancelClickIn = self:cancelPressInBreak()
  }
  self.draglist = ed.draglist.create(info)
  self.draglist.downShade:setScaleY(1)
  self.draglist.upShade:setOpacity(0)
  return self.draglist:getListLayerTouchHandler()
end

function class:createContent()
  local dalign = self.alignment
  local items = self.items
  if 0 < #items then
    local thisCon = self.ui.lay_post:getContentSize()
    local posX, posY = self.ui.lay_post:getPosition()
    local han = 0
    local widhtItem = 150
    local itemPosX, itemPosY = posX + widhtItem / 2, posY + thisCon.height - (widhtItem - 30) / 2
    local itemNum = 5
    if itemNum >= #items then
      local addPosx = (itemNum - #items) * (widhtItem / 2)
      itemPosX = itemPosX + addPosx
      itemPosY = itemPosY + 15
    elseif #items <= itemNum * 2 then
      itemPosY = itemPosY - 15
    else
      han = 10
    end
    local preLabelHeight = 0
    local itemAttach = {}
    for i, v in ipairs(items) do
      local icon, label = ed.createItemIcon(v, true)
      if icon then
        icon:setScale(1)
        icon:setPosition(ccp(itemPosX, itemPosY))
        if i % itemNum == 0 then
          itemPosY = itemPosY - (widhtItem - 30)
          itemPosX = posX + widhtItem / 2
        elseif i % itemNum == 1 then
          han = han + (widhtItem - 30)
          itemPosX = itemPosX + widhtItem
          preLabelHeight = 40
        else
          itemPosX = itemPosX + widhtItem
        end
        self.draglist:addItem(icon)
        table.insert(itemAttach, {
          icon = icon,
          id = v.id,
          type = v.type
        })
        if label then
          label:setPosition(ccp(45, -12))
          label:setColor(ccc3(ed.colorToStr("#fffce7")))
          label:setShadow(ccc3(0, 0, 0), ccp(1, 1))
          ed.adaptLabel(label, {
            maxWidth = icon:getContentSize().width * 1.4,
            minScale = 0.9
          })
          local labelHeight = label:getContentSize().height * label:getScaleY()
          if preLabelHeight < labelHeight then
            han = han + (labelHeight - preLabelHeight) * 0.5
            preLabelHeight = labelHeight
          end
        end
        local cornerTag = v.cornerTag
        local cornerTagCfg = class.EXTRA_TAG_CONFIG[cornerTag]
        if cornerTagCfg then
          local cornerSprite = ed.createSprite(cornerTagCfg.res)
          cornerSprite:setPosition(cornerTagCfg.pos)
          icon:addChild(cornerSprite)
          local text = ed.createttf(cornerTagCfg.text, 15)
          ed.setLabelColor(text, ed.toccc3(16707969))
          ed.setLabelStroke(text, ed.toccc3(8601857), 1.5)
          cornerSprite:addChild(text)
          ed.layout.centerInParent(text)
        end
        icon:setCascadeOpacityEnabled(true)
        icon:setOpacity(0)
        icon:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1 * i), CCFadeIn:create(0.15)))
      end
    end
    self.itemAttach = itemAttach
    self.draglist:initListHeight(han)
  end
end

function class:destroy()
  base.destroy(self)
  if self.closedHandler then
    self.closedHandler()
  end
end

function class:addClickOutHandler()
  local touchLayer, touchNode = ed.UITool.createTouchLayer(-999)
  touchNode:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  self.container:addChild(touchLayer)
end

local function create(param)
  param = param or {}
  local withNoShade = param.withNoShade
  local self = base.create("getProp", withNoShade)
  setmetatable(self, class.mt)
  local container = self.container
  local identity = param.identity
  self.identity = identity
  local titleText = param.title or T("\230\129\173\229\150\156\230\130\168\232\142\183\229\190\151\228\187\165\228\184\139\229\165\150\229\138\177\239\188\154")
  self.buttonText = param.buttonText
  local titleNode = param.titleNode
  local items = param.items or {}
  self.items = items
  self.extraData = param.extra or {}
  self.isRewardDouble = param.rainbow == 1 and true or false
  self.forbidPopHero = param.forbidPopHero
  local alignment = param.alignment or "center"
  self.alignment = alignment
  local lsr
  if identity == "task" then
    lsr = ed.ui.tasklsr.create()
  end
  self.lsr = lsr
  if param.beforeCreateBgHandler then
    param.beforeCreateBgHandler(self)
  end
  local ui = {}
  self.ui = ui
  local bg = CCSprite:create()
  bg:setAnchorPoint(ccp(1, 1))
  container:addChild(bg, 5)
  ui.bgContainer = bg
  local readnode = ed.readnode.create(bg, ui)
  local readNodes = ed.readnode.create(container, ui)
  readNodes:addNode(#self.items > 5 and ed.uieditor.gaveItemBig or ed.uieditor.gaveItemWin)
  local dragHandler = self:createListLayer()
  self:registerTouchHandler(self.draglist:getListLayerTouchHandler())
  self:createContent()
  local rheight, lheight, bheight = 0, 0, 157
  ui.bg = ui.lay_post
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  self.container:setPosition(ccp(newWid, newHei))
  self.ui.Label_111:setString(titleText)
  self:setClickDestroyEnabled(false)
  param.closeWhenClickOut = true
  param.closedHandler = param.closedHandler or function()
  end
  if param.closeWhenClickOut then
    self:addClickOutHandler()
    self.closedHandler = param.closedHandler
  end
  
  function self.preShowHandler()
    self:beginRefreshCliprect()
  end
  
  function self.preDestroyHandler()
    self:beginRefreshCliprect()
  end
  
  self:setDestroyHandler(function()
    if self.fca then
      ed.getCurrentScene():removeFca(self.fca)
      self.fca = nil
    end
    self:stopRefreshCliprect()
    
    local function doPopHero(index)
      local callback
      if index == #self.heroLoots then
        function callback()
          if param.callback then
            param.callback()
          end
        end
      else
        function callback()
          doPopHero(index + 1)
        end
      end
      local hl = self.heroLoots[index]
      local id = hl.id
      local amount = hl.amount
      ed.ui.SummonRewardCardWindow.create({
        rewards = {
          {
            id = id,
            amount = 1,
            type = "hero"
          }
        },
        noRewards = true
      }):popWindow()
    end
    
    if #(self.heroLoots or {}) > 0 and not self.forbidPopHero then
      doPopHero(1)
    elseif param.callback then
      param.callback()
    end
  end)
  self:show(function()
    self:stopRefreshCliprect()
  end)
  local fcaConfig = param.fcaConfig
  if fcaConfig then
    local fcaRes = fcaConfig.res
    local fcaScale = fcaConfig.scale
    local zorder = fcaConfig.zorder or 0
    local action = fcaConfig.action
    local position = fcaConfig.pos
    local isLoop = fcaConfig.loop or false
    self.fca = ed.createFcaActor(fcaRes, fcaScale)
    self.fca:setAction(action)
    self.fca:setLoop(isLoop)
    if position then
      self.fca:setPosition(position)
    end
    ed.getCurrentScene():addFca(self.fca)
    ui.bg:addChild(self.fca, zorder)
  end
  return self
end

class.create = create

local function doPressIn(self)
  local function handler(x, y)
    local ia = self.itemAttach or {}
    
    for i = 1, #ia do
      local a = ia[i]
      if a and a.icon then
        local icon = a.icon
        if icon and icon.getScale then
          self.oriItemScale = self.oriItemScale or icon:getScale()
          local id = a.id
          local kind = a.kind
          local type = a.type
          if type == "hero" then
            return
          end
          if ed.containsPoint(icon, x, y) then
            icon:setScale(self.oriItemScale * 0.95)
            self.scaledIcon = icon
            ed.ui.packageDetailWin.create({id = id, type = type}):popWindow()
            return {
              index = i,
              id = id,
              kind = kind
            }
          end
        end
      end
    end
  end
  
  return handler
end

class.doPressIn = doPressIn

local function cancelPressInBreak(self)
  local function handler(x, y, args)
    if not tolua.isnull(self.scaledIcon) then
      self.scaledIcon:setScale(self.oriItemScale)
      
      self.scaledIcon = nil
    end
  end
  
  return handler
end

class.cancelPressInBreak = cancelPressInBreak
