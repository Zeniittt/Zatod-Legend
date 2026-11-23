local base = ed.ui.popwindow
local GuildRuleWin = newclass(base.mt)
ed.ui.GuildRuleWin = GuildRuleWin

function GuildRuleWin.create(params)
  local self = base.create("GuildRuleWin")
  setmetatable(self, GuildRuleWin.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function GuildRuleWin:init()
  ed.setLabelDimensions(self.ui.page_1_desc, CCSizeMake(528, 45))
  for i = 1, #self.strPage do
    local page = CCLayer:create()
    page:setPosition(ccp(-580 + 590 * i, 0))
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

function GuildRuleWin:registerTouchHandler()
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

GuildRuleWin.newTouPosX = 0
GuildRuleWin.posIndex = 1

function GuildRuleWin:TouchHandler()
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

function GuildRuleWin:movePageNewPos(move)
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

GuildRuleWin.strPage = {
  T("1.\229\143\175\228\187\165\233\154\143\230\151\182\228\184\142\229\133\172\228\188\154\230\136\144\229\145\152\232\129\138\229\164\169\227\128\130<br/>") .. T("2.\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\239\188\140\229\143\175\228\187\165\229\175\185\230\175\148\232\135\170\229\183\177\230\136\152\229\138\155\233\171\152\230\136\150\232\128\133\229\133\172\228\188\154\229\137\1414\230\128\187\230\136\152\229\138\155\231\154\132\231\142\169\229\174\182\228\189\191\231\148\168\226\128\156\232\134\156\230\139\156\226\128\157\229\138\159\232\131\189\239\188\140\229\190\151\229\136\176\228\189\147\229\138\155\229\165\150\229\138\177\239\188\140\232\162\171\232\134\156\230\139\156\231\154\132\228\186\186\229\190\151\229\136\176\233\135\145\229\184\129\227\128\130<br/>") .. T("3.\229\143\175\228\187\165\230\138\138\232\139\177\233\155\132\230\180\190\229\190\128\228\189\163\229\133\181\232\144\165\229\156\176\239\188\140\229\143\175\232\142\183\229\190\151\228\189\163\233\135\145\229\165\150\229\138\177\227\128\130\229\166\130\230\158\156\232\162\171\229\133\182\228\187\150\231\142\169\229\174\182\233\155\135\228\189\163\228\186\134\239\188\140\228\188\154\230\156\137\230\155\180\229\164\154\231\154\132\228\189\163\233\135\145\227\128\130<br/>") .. T("4.\229\133\172\228\188\154\228\188\154\233\149\191\232\191\158\231\187\1733\229\164\169\228\184\141\229\156\168\231\186\191\239\188\140\229\136\153\231\148\177\230\156\128\229\133\136\231\153\187\229\189\149\233\149\191\232\128\129\230\155\191\228\187\187\228\188\154\233\149\191\239\188\140\232\139\165\230\178\161\230\156\137\233\149\191\232\128\129\229\136\1535\229\164\169\229\144\142\231\148\177\230\180\187\232\183\131\229\186\166\230\156\128\233\171\152\231\154\132\230\136\144\229\145\152\231\187\167\228\187\187\227\128\130<br/>") .. T("5.\230\151\160\230\179\149\229\156\168\233\128\128\229\135\186\229\133\172\228\188\154\229\144\1421\229\176\143\230\151\182\229\134\133\229\138\160\229\133\165\228\187\187\228\189\149\229\133\172\228\188\154\239\188\140\230\151\160\230\179\149\229\156\168\233\128\128\229\135\186\229\133\172\228\188\154\229\144\14248\229\176\143\230\151\182\229\134\133\229\155\158\229\136\176\229\142\159\229\133\172\228\188\154\239\188\140\229\185\182\228\184\148\230\175\143\229\145\168\229\143\170\232\131\189\229\138\160\229\133\1654\230\172\161\229\133\172\228\188\154\227\128\130<br/>")
}

function GuildRuleWin:createPageString()
  for k, v in ipairs(self.strPage) do
    local autoText = ed.ui.autoText.new()
    local fontSize = ed.isAreaZh() and 16 or 13
    autoText:initParam({
      context = v,
      fontSize = fontSize,
      lineSpacing = 4,
      maxWidth = self.ui.panel_clipping:getContentSize().width - 46
    })
    self.ui["page_" .. k]:addChild(autoText.node)
    autoText.node:setPosition(20, self.ui.panel_win:getContentSize().height - 30)
  end
end
