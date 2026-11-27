local base = ed.ui.popwindow
local PeakArenaShopRuleWin = newclass(base.mt)
ed.ui.PeakArenaShopRuleWin = PeakArenaShopRuleWin

function PeakArenaShopRuleWin.create(params)
  local self = base.create("PeakArenaShopRuleWin")
  setmetatable(self, PeakArenaShopRuleWin.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  self:popWindow()
  return self
end

function PeakArenaShopRuleWin:init()
  self.newTouPosX = 0
  self.posIndex = 1
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
  local ox = self.ui.Image_bg:getContentSize().width / 2 - #self.strPage * 10 - 10
  if 1 < #self.strPage then
    for i = 1, #self.strPage do
      local point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_1.png")
      point:setPosition(ox + i * 20, 20)
      self.ui.Image_bg:addChild(point)
      self.pointPos[i] = point
    end
    self.point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_2.png")
    self.point:setPosition(ox + 20, 20)
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

function PeakArenaShopRuleWin:registerTouchHandler()
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

function PeakArenaShopRuleWin:TouchHandler()
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

function PeakArenaShopRuleWin:movePageNewPos(move)
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

PeakArenaShopRuleWin.strPage = {
  T("<lable color=summonYellow>\232\141\163\232\128\128\232\161\165\231\187\153\231\171\153</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\189\191\231\148\168\229\183\133\229\179\176\233\147\182\229\184\129\239\188\140\229\143\175\229\156\168\232\141\163\232\128\128\232\161\165\231\187\153\231\171\153\228\184\173\229\133\145\230\141\162\229\165\150\229\138\177\239\188\136\231\137\185\229\136\171\230\179\168\230\132\143\239\188\154\228\188\145\233\151\178\232\181\155\233\152\182\230\174\181\229\146\140\228\188\145\232\181\155\230\156\159\233\152\182\230\174\181\228\185\159\229\143\175\228\187\165\232\191\155\232\161\140\229\165\150\229\138\177\229\133\145\230\141\162\239\188\137\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\141\163\232\128\128\232\161\165\231\187\153\231\171\153\228\184\173\231\154\132\229\165\150\229\138\177\229\176\134\233\154\143\230\175\143\230\172\161<lable color=summonYellow>\229\183\133\229\179\176\230\150\176\232\181\155\229\173\163\229\188\128\229\144\175\232\128\140\229\136\183\230\150\176\227\128\130</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=summonRed>\230\150\176\232\181\155\229\173\163\229\188\128\229\144\175\230\151\182\239\188\140\228\184\138\232\181\155\229\173\163\229\176\154\230\156\170\231\148\168\229\174\140\231\154\132\229\183\133\229\179\176\233\147\182\229\184\129\229\176\134\232\162\171\230\184\133\233\155\182\239\188\140\232\175\183\229\143\138\230\151\182\229\133\145\230\141\162\229\147\166\239\188\129</lable><br/>")
}

function PeakArenaShopRuleWin:createPageString()
  for k, v in ipairs(self.strPage) do
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = v,
      fontSize = 16,
      lineSpacing = 4,
      maxWidth = self.ui.panel_clipping:getContentSize().width - 46
    })
    self.ui["page_" .. k]:addChild(autoText.node)
    autoText.node:setPosition(20, self.ui.panel_win:getContentSize().height - 8)
  end
end
