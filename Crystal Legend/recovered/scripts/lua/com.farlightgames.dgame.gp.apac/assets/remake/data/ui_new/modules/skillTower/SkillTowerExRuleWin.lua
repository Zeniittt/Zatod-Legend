local base = ed.ui.popwindow
local SkillTowerExRuleWin = newclass(base.mt)
ed.ui.SkillTowerExRuleWin = SkillTowerExRuleWin

function SkillTowerExRuleWin.create(params)
  local self = base.create("SkillTowerExRuleWin")
  setmetatable(self, SkillTowerExRuleWin.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function SkillTowerExRuleWin:init()
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

function SkillTowerExRuleWin:registerTouchHandler()
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

function SkillTowerExRuleWin:TouchHandler()
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

function SkillTowerExRuleWin:movePageNewPos(move)
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

SkillTowerExRuleWin.strPage = {
  T("\230\175\148\229\143\164\232\128\129\230\155\180\229\143\164\232\128\129\231\154\132\232\167\166\231\162\176\231\160\180\229\188\128\229\177\143\233\154\156\239\188\140\231\142\176\229\156\168\230\136\145\228\187\172\232\131\189\229\164\159\232\184\143\232\182\179\229\185\187\229\162\131\231\154\132\230\155\180\230\183\177\229\177\130\239\188\140\228\189\134\230\136\145\228\187\172\229\191\133\233\161\187\233\154\143\230\151\182\228\191\157\230\140\129\232\173\166\230\131\149\239\188\140\229\176\143\229\191\131\228\184\141\232\166\129\232\191\183\229\164\177\229\133\182\233\151\180\227\128\130<br/>") .. T("                                             \226\128\148\226\128\148\226\128\148\226\128\148 \227\128\144\232\136\185\233\149\191\231\154\132\230\151\165\232\174\176\227\128\145<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17660\231\186\167\229\144\142\239\188\140\229\143\175\228\187\165\229\143\130\228\184\142\229\185\187\229\162\131\230\183\177\229\164\132\231\154\132\230\140\145\230\136\152\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\140\145\230\136\152\229\185\187\229\162\131\230\183\177\229\164\132\239\188\140\230\151\160\233\156\128\230\182\136\232\128\151\229\185\187\231\148\159\231\131\155\239\188\140\233\166\150\230\172\161\233\128\154\229\133\179\230\175\143\228\184\128\229\177\130\230\151\182\239\188\140\229\176\134\232\142\183\229\190\151\233\166\150\233\128\154\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\185\187\229\162\131\230\183\177\229\164\132\231\154\132\229\133\179\229\141\161\229\143\175\228\187\165\233\135\141\229\164\141\232\191\155\232\161\140\230\140\145\230\136\152\239\188\140\233\135\141\229\164\141\230\140\145\230\136\152\228\184\141\228\188\154\232\142\183\229\190\151\229\165\150\229\138\177\239\188\140\230\175\143\230\172\161\230\140\145\230\136\152\230\151\182\239\188\140\229\176\134\232\174\176\229\189\149\229\189\147\229\177\130\230\156\128\231\159\173\231\154\132\233\128\154\229\133\179\230\151\182\233\151\180\227\128\130\230\175\143\229\164\169\229\143\175\232\135\179\229\164\154\232\191\155\232\161\14050\230\172\161\229\185\187\229\162\131\230\183\177\229\164\132\231\154\132\230\140\145\230\136\152\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\128\154\229\133\179\230\137\128\230\156\137\229\177\130\230\149\176\229\144\142\239\188\140\229\176\134\229\175\185\230\175\143\229\177\130\230\156\128\231\159\173\233\128\154\229\133\179\230\151\182\233\151\180\232\191\155\232\161\140\231\180\175\229\138\160\239\188\140\229\190\151\229\135\186\230\128\187\232\128\151\230\151\182\239\188\140\229\185\182\228\187\165\230\128\187\232\128\151\230\151\182\232\191\155\232\161\140\231\171\158\233\128\159\230\142\146\229\144\141\227\128\130\232\128\151\230\151\182\231\155\184\229\144\140\230\151\182\230\142\146\229\144\141\233\129\181\229\190\170\229\133\136\230\157\165\229\144\142\229\136\176\229\142\159\229\136\153\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\189\147\230\156\159\229\185\187\229\162\131\230\183\177\229\164\132\231\187\147\231\174\151\230\151\182\239\188\140\229\176\134\230\160\185\230\141\174\230\156\172\230\156\141\231\171\158\233\128\159\230\142\146\229\144\141\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\185\187\229\162\131\230\183\177\229\164\132\230\175\143\233\154\148\228\184\128\230\174\181\230\151\182\233\151\180\228\188\154\232\191\155\232\161\140\233\135\141\231\187\132\239\188\140\233\135\141\231\187\132\229\144\142\239\188\140\229\133\179\229\141\161\229\176\134\230\155\180\230\150\176\239\188\140\229\165\150\229\138\177\228\185\159\229\176\134\233\135\141\231\189\174\227\128\130<br/>")
}

function SkillTowerExRuleWin:createPageString()
  for k, v in ipairs(self.strPage) do
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = v,
      fontSize = 16,
      lineSpacing = 4,
      maxWidth = self.ui.panel_clipping:getContentSize().width - 46,
      maxHeight = self.ui.panel_clipping:getContentSize().height
    })
    self.ui["page_" .. k]:addChild(autoText.node)
    autoText.node:setPosition(20, self.ui.panel_clipping:getContentSize().height - autoText:getFirstLineHeight())
  end
end
