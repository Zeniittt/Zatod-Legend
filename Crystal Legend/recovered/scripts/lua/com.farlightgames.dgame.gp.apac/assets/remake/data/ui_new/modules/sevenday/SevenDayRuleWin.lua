local base = ed.ui.popwindow
local SevenDayRuleWin = newclass(base.mt)
ed.ui.SevenDayRuleWin = SevenDayRuleWin

function SevenDayRuleWin.create(params)
  local self = base.create("SevenDayRuleWin")
  setmetatable(self, SevenDayRuleWin.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function SevenDayRuleWin:init()
  self.newTouPosX = 0
  self.posIndex = 1
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

function SevenDayRuleWin:registerTouchHandler()
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

function SevenDayRuleWin:TouchHandler()
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

function SevenDayRuleWin:movePageNewPos(move)
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

SevenDayRuleWin.strPage = {
  T("\226\128\156\232\191\142\230\142\165\230\140\145\230\136\152\239\188\140\231\187\143\229\142\134\232\175\149\231\130\188\239\188\140\232\156\149\229\143\152\229\188\186\229\164\167\239\188\140\232\142\183\229\190\151\232\131\156\229\136\169\239\188\140\229\177\158\228\186\142\228\189\160\231\154\132\229\134\155\229\155\162\230\140\135\230\140\165\239\188\129\226\128\157<br/>") .. T("                                 \226\128\148\226\128\148\226\128\148\226\128\148 \227\128\144\232\136\185\233\149\191\231\154\132\228\185\166\230\161\140\229\136\187\229\173\151\227\128\145<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\180\187\229\138\168\230\140\129\231\187\173\230\151\182\233\151\180\228\184\18630\229\164\169\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\136\144\233\149\191\228\187\187\229\138\161\228\184\186\231\180\175\232\174\161\228\187\187\229\138\161\239\188\14030\229\164\169\229\134\133\232\190\190\230\136\144\233\131\189\229\143\175\228\187\165\233\162\134\229\143\150\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\153\144\230\151\182\228\187\187\229\138\161\229\143\170\232\131\189\229\156\168\232\167\163\233\148\129\229\189\147\229\164\169\233\153\144\230\151\182\229\174\140\230\136\144\233\162\134\229\143\150\229\165\150\229\138\177\239\188\140\233\128\190\230\151\182\229\176\134\228\188\154\232\191\135\230\156\159\229\164\177\230\149\136\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\229\164\169\228\188\154\232\167\163\233\148\129\230\150\176\228\187\187\229\138\161\239\188\140\229\174\140\230\136\144\228\187\187\229\138\161\229\176\134\232\142\183\229\190\151\229\165\150\229\138\177\229\143\138\231\167\175\229\136\134\231\130\185\230\149\176\239\188\140\231\180\175\232\174\161\231\167\175\229\136\134\231\130\185\230\156\128\231\187\136\229\143\175\228\187\165\233\162\134\229\143\150\229\134\155\229\155\162\230\140\135\230\140\165\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\156\128\232\166\129\230\179\168\230\132\143\231\154\132\230\152\175\239\188\140\230\180\187\229\138\16830\229\164\169\229\144\142\232\191\135\230\156\159\239\188\140\229\165\150\229\138\177\230\178\161\230\156\137\233\162\134\229\143\150\231\154\132\232\175\157\229\176\177\228\188\154\230\182\136\229\164\177\229\147\166\227\128\130<br/>")
}

function SevenDayRuleWin:createPageString()
  for k, v in ipairs(self.strPage) do
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = v,
      fontSize = 16,
      lineSpacing = 4,
      maxWidth = self.ui.panel_clipping:getContentSize().width - 46
    })
    self.ui["page_" .. k]:addChild(autoText.node)
    local _, height = autoText:getCurContentSize()
    autoText.node:setPosition(20, self.ui.panel_clipping:getContentSize().height - height / 2 + 50)
  end
end
