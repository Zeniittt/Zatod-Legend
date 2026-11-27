local base = ed.ui.popwindow
local GuildMercenaryRule = newclass(base.mt)
ed.ui.GuildMercenaryRule = GuildMercenaryRule

function GuildMercenaryRule.create(params)
  local self = base.create("GuildMercenaryRule")
  setmetatable(self, GuildMercenaryRule.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function GuildMercenaryRule:init()
  ed.setLabelDimensions(self.ui.page_1_desc, CCSizeMake(528, 45))
  for i = 1, #self.strPage do
    local page = CCLayer:create()
    page:setPosition(ccp(-580 + 590 * i, 7.5))
    self.ui["page_" .. i] = page
  end
  self:createPageString()
  local clippingNode = CCClippingNode:create()
  clippingNode:setAlphaThreshold(1)
  clippingNode:setCascadeOpacityEnabled(true)
  self.ui.panel_clipping:setOpacity(0)
  self.ui.panel_win:setVisible(false)
  local layer = CCLayerColor:create(ccc4(255, 255, 255, 0))
  clippingNode:setStencil(self.ui.panel_clipping)
  clippingNode:addChild(layer)
  self.container:addChild(clippingNode)
  local posx, posy = self.ui.panel_win:getPosition()
  for i = 1, #self.strPage do
    clippingNode:addChild(self.ui["page_" .. i])
  end
  self.pagePos = {}
  for i = 1, #self.strPage do
    local lox, loy = self.ui["page_" .. i]:getPosition()
    self.ui["page_" .. i]:setPosition(posx + lox, posy + loy)
    self.pagePos[i] = ccp(posx + lox, posy + loy)
  end
  for i = 1, #self.strPage - 1 do
    self.pagePos[1 - i] = ccp(self.pagePos[1].x - 590 * i - 10, self.pagePos[1].y)
  end
  self.ui.panel_win_touch:setTouchEnabled(true)
  self.ui.panel_win_touch:registerScriptTouchHandler(self:TouchHandler(), false, -9999, false)
  self.pointPos = {}
  if 1 < #self.strPage then
    for i = 1, #self.strPage do
      local point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_1.png")
      point:setPosition(272 + i * 20, 15)
      self.ui.Image_bg:addChild(point)
      self.pointPos[i] = point
    end
    self.point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_2.png")
    self.point:setPosition(292, 15)
    self.ui.Image_bg:addChild(self.point)
    self.ui.arrow_right:setVisible(true)
    self.ui.panel_touch:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCDelayTime:create(1),
      CCCallFunc:create(function()
        self.ui.arrow_left:runAction(CCFadeTo:create(0.9, 255 - self.ui.arrow_left:getOpacity()))
        self.ui.arrow_right:runAction(CCFadeTo:create(0.9, 255 - self.ui.arrow_right:getOpacity()))
      end)
    })))))
  else
    self.ui.arrow_left:setVisible(false)
    self.ui.arrow_right:setVisible(false)
  end
end

function GuildMercenaryRule:registerTouchHandler()
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.panel_touch,
    key = "out_click",
    clickHandler = function()
      if self.notClose then
        return
      end
      if self.destroyBack then
        self.destroyBack()
      end
      self:destroy()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.arrow_left,
    key = "arrow_left",
    clickHandler = function()
      self:movePageNewPos(-1)
    end,
    force = true,
    pressScale = 0.9
  })
  self:btRegisterButtonClick({
    button = self.ui.arrow_right,
    key = "arrow_right",
    clickHandler = function()
      self:movePageNewPos(1)
    end,
    force = true,
    pressScale = 0.9
  })
end

GuildMercenaryRule.newTouPosX = 0
GuildMercenaryRule.posIndex = 1

function GuildMercenaryRule:TouchHandler()
  local function handler(event, x, y)
    if event == "began" then
      self.newTouPosX = x
    elseif event == "ended" then
      local newX = self.newTouPosX - x
      self:movePageNewPos(math.abs(newX) > 100 and newX or false)
    elseif event == "moved" then
      local newX = x - self.newTouPosX
      for i = 1, #self.strPage do
        local posX, posY = self.pagePos[self.posIndex + i - 1].x + newX, self.pagePos[self.posIndex + i - 1].y
        self.ui["page_" .. i]:setPosition(posX, posY)
      end
    end
    return true
  end
  
  return handler
end

function GuildMercenaryRule:movePageNewPos(move)
  if move then
    move = move < 0
    self.posIndex = move and self.posIndex + 1 or self.posIndex - 1
  end
  self.posIndex = ed.clamp(self.posIndex, 2 - #self.strPage, 1)
  self.ui.arrow_left:setVisible(self.posIndex ~= 1)
  self.ui.arrow_right:setVisible(self.posIndex ~= 2 - #self.strPage)
  for i = 1, #self.strPage do
    self.ui["page_" .. i]:stopAllActions()
    self.ui["page_" .. i]:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, self.pagePos[self.posIndex + i - 1])))
  end
  self.point:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(self.pointPos[2 - self.posIndex]:getPosition()))))
end

GuildMercenaryRule.strPage = {
  T("1.\228\187\187\228\189\149\232\139\177\233\155\132\233\131\189\229\143\175\228\187\165\230\180\190\229\190\128\228\189\163\229\133\181\232\144\165\229\156\176\239\188\140\228\189\134\228\184\141\230\152\175\230\137\128\230\156\137\232\139\177\233\155\132\233\131\189\228\188\154\232\162\171\233\155\135\228\189\163\227\128\130<br/>") .. T("2.\228\189\163\229\133\181\232\144\165\229\156\176\228\188\154\231\187\153\233\169\187\229\174\136\231\154\132\228\189\163\229\133\181\232\190\155\232\139\166\232\180\185\239\188\140\230\151\182\233\151\180\232\182\138\233\149\191\230\148\182\229\133\165\232\182\138\229\164\154\239\188\140\228\189\163\229\133\181\229\174\158\229\138\155\232\182\138\229\188\186\230\148\182\229\133\165\232\182\138\229\164\154\227\128\130<br/>") .. T("3.\230\180\190\229\135\186\231\154\132\228\189\163\229\133\181\232\135\179\229\176\145\233\156\128\232\166\129\229\156\168\232\144\165\229\156\176\233\152\178\229\174\13630\229\136\134\233\146\159\239\188\140\230\156\159\233\151\180\228\184\141\232\131\189\229\189\146\233\152\159\227\128\130<br/>") .. T("4.\229\133\172\228\188\154\230\136\144\229\145\152\229\143\175\228\187\165\230\148\175\228\187\152\233\135\145\229\184\129\239\188\140\228\187\142\228\189\163\229\133\181\232\144\165\229\156\176\229\128\159\231\148\168\228\189\163\229\133\181\227\128\130<br/>") .. T("5.\230\175\143\229\164\169\229\143\170\232\131\189\228\187\142\229\144\140\228\184\128\230\148\175\230\136\152\233\152\159\233\155\135\228\189\163\228\184\128\228\189\141\228\189\163\229\133\181\227\128\130<br/>") .. T("6.\228\189\163\229\133\181\229\143\175\229\143\130\228\184\142\230\136\152\229\189\185\227\128\129\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129\231\154\132\230\136\152\230\150\151\239\188\140\230\136\152\230\150\151\231\187\147\230\158\156\229\173\152\229\156\168\230\152\159\231\186\167\229\136\164\229\174\154\230\151\182\239\188\140\228\188\154\229\135\143\229\176\1451\233\162\151\230\152\159\227\128\130<br/>") .. T("7.\233\155\135\228\189\163\232\139\177\233\155\132\228\184\142\230\156\172\230\136\152\233\152\159\231\154\132\229\144\140\229\144\141\232\139\177\233\155\132\228\184\141\232\131\189\229\144\140\230\151\182\228\184\138\229\156\186\227\128\130<br/>")
}

function GuildMercenaryRule:createPageString()
  for k, v in ipairs(self.strPage) do
    local autoText = ed.ui.autoText.new()
    local fontSize
    if ed.isElementInTable(EDCurLanguage, {"en", "ko"}) then
      fontSize = 15
    elseif ed.isElementInTable(EDCurLanguage, {"es"}) then
      fontSize = 13
    else
      fontSize = 16
    end
    autoText:initParam({
      context = v,
      fontSize = fontSize,
      lineSpacing = 4,
      maxWidth = self.ui.panel_clipping:getContentSize().width - 46
    })
    self.ui["page_" .. k]:addChild(autoText.node)
    local _, height = autoText:getCurContentSize()
    autoText.node:setPosition(20, self.ui.panel_clipping:getContentSize().height - 30)
  end
end
