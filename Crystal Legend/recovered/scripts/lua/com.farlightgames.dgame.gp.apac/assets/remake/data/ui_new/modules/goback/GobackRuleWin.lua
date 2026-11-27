local base = ed.ui.popwindow
local GobackRuleWin = newclass(base.mt)
ed.ui.GobackRuleWin = GobackRuleWin

function GobackRuleWin.create(params)
  local self = base.create("GobackRuleWin")
  setmetatable(self, GobackRuleWin.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function GobackRuleWin:init()
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

function GobackRuleWin:registerTouchHandler()
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

function GobackRuleWin:TouchHandler()
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

function GobackRuleWin:movePageNewPos(move)
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

GobackRuleWin.strPage = {
  T("<lable color=summonYellow>\228\184\131\230\151\165\231\164\188\233\129\135</lable><br/>") .. T("\230\180\187\229\138\168\230\156\159\233\151\180\239\188\140\231\180\175\232\174\161\231\153\187\229\189\149\232\190\190\229\136\176\228\184\128\229\174\154\229\164\169\230\149\176\239\188\140\229\141\179\229\143\175\233\162\134\229\143\150\229\175\185\229\186\148\229\165\150\229\138\177\227\128\130<br/>") .. T("\230\175\143\229\164\16905\239\188\15400\229\144\142\231\153\187\233\153\134\230\184\184\230\136\143\229\176\134\232\162\171\232\174\176\229\133\165\231\180\175\232\174\161\231\153\187\229\189\149\229\164\169\230\149\176\227\128\130<br/><br/>") .. T("<lable color=summonYellow>\229\155\158\229\189\146\229\138\169\229\138\155</lable><br/>") .. T("\230\180\187\229\138\168\230\156\159\233\151\180\239\188\140\230\175\143\229\174\140\230\136\1441\228\184\170\230\151\165\229\184\184\228\187\187\229\138\161\229\143\175\232\142\183\229\190\1511\228\184\170\226\128\156\229\155\158\229\189\146\231\167\175\229\136\134\226\128\157\239\188\140\230\139\165\230\156\137\226\128\156\229\155\158\229\189\146\231\167\175\229\136\134\226\128\157\232\190\190\229\136\176\228\184\128\229\174\154\230\149\176\233\135\143\229\143\175\233\162\134\229\143\150\229\175\185\229\186\148\229\155\158\229\189\146\229\138\169\229\138\155\229\165\150\227\128\130<br/><br/>") .. T("<lable color=summonYellow>\229\155\158\229\189\146\231\137\185\230\157\131</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\155\158\229\189\146\231\154\132\233\152\159\233\149\191\229\164\167\229\164\167\229\143\175\232\142\183\229\190\151\228\187\165\228\184\1393\233\161\185\231\137\185\230\157\131<br/>") .. T("  1.\230\180\187\229\138\168\229\188\128\229\144\175\231\172\1721-5\229\164\169\239\188\154\230\175\143\230\151\165\229\137\1414\230\172\161\228\189\191\231\148\168\233\146\187\231\159\179\232\180\173\228\185\176\228\189\147\229\138\155\230\151\182\239\188\140\230\182\136\232\128\151\233\146\187\231\159\179\230\149\176\233\135\143\229\135\143\229\141\138\227\128\130<br/>") .. T("  2.\230\180\187\229\138\168\229\188\128\229\144\175\231\172\1721-3\229\164\169\239\188\154\230\140\145\230\136\152\230\136\150\230\137\171\232\141\161\231\178\190\232\139\177\233\154\190\229\186\166\231\154\132\230\136\152\229\189\185\229\133\179\229\141\161\239\188\140\232\163\133\229\164\135\229\146\140\231\129\181\233\173\130\231\159\179\230\142\137\232\144\189\231\191\187\229\128\141\227\128\130<br/>") .. T("  3.\230\180\187\229\138\168\229\188\128\229\144\175\231\172\1721-3\229\164\169\239\188\154\229\188\128\229\144\175\232\191\156\229\190\129\229\174\157\231\174\177\239\188\140\232\142\183\229\143\150\232\191\156\229\190\129\229\184\129\239\188\136\231\186\162\233\190\153\233\128\134\233\179\158\239\188\137\229\165\150\229\138\177\231\191\187\229\128\141\227\128\130<br/>"),
  T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\176\143\229\134\176\229\134\176\230\143\144\231\164\186<br/>") .. T("  1.\229\166\130\233\129\135\229\175\185\229\186\148\231\154\132\230\151\165\229\184\184\229\143\140\229\128\141\230\180\187\229\138\168\229\136\153\230\149\136\230\158\156\229\143\160\229\138\160\239\188\140\229\141\179\229\143\152\228\184\186\229\142\159\230\157\165\231\154\1323\229\128\141\227\128\130<br/>") .. T("  2.\229\155\158\229\189\146\231\137\185\230\157\131\230\175\143\230\151\16505\239\188\15400\229\136\183\230\150\176\239\188\140\229\133\183\228\189\147\229\137\169\228\189\153\230\151\182\233\151\180\229\143\175\230\159\165\231\156\139\231\137\185\230\157\131\233\161\181\233\157\162\227\128\130<br/><br/>") .. T("<lable color=summonYellow>\231\137\185\230\131\160\232\161\165\231\187\153</lable><br/>") .. T("\230\180\187\229\138\168\230\156\159\233\151\180\239\188\140\233\152\159\233\149\191\229\164\167\229\164\167\229\143\175\230\182\136\232\128\151\233\146\187\231\159\179\232\180\173\228\185\176\228\184\141\229\144\140\230\161\163\228\189\141\231\154\132\232\161\165\231\187\153\229\140\133\239\188\140\230\175\143\228\184\170\232\161\165\231\187\153\229\140\133\233\153\144\232\180\173\228\185\1761\230\172\161\227\128\130<br/>")
}

function GobackRuleWin:createPageString()
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
