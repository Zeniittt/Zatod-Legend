local base = ed.ui.popwindow
local CrusadeRuleWin = newclass(base.mt)
ed.ui.CrusadeRuleWin = CrusadeRuleWin

function CrusadeRuleWin.create(params)
  local self = base.create("CrusadeRuleWin")
  setmetatable(self, CrusadeRuleWin.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function CrusadeRuleWin:init()
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

function CrusadeRuleWin:registerTouchHandler()
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

CrusadeRuleWin.newTouPosX = 0
CrusadeRuleWin.posIndex = 1

function CrusadeRuleWin:TouchHandler()
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

function CrusadeRuleWin:movePageNewPos(move)
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

CrusadeRuleWin.strPage = {
  T("  \231\134\148 \231\159\179 \231\129\171 \229\177\177 \231\130\184 \232\163\130<br/>") .. T("  \233\190\153 \230\151\143 \229\174\157 \232\151\143 \230\152\190 \228\184\150<br/>") .. T("  \232\191\189 \230\162\166 \228\186\186\239\188\140\229\189\147 \229\191\131 \228\189\160 \231\154\132 \232\180\170 \229\169\170<br/>") .. T("  \229\155\160 \228\184\186 \230\175\148 \233\190\153 \231\137\153 \230\155\180 \229\141\177 \233\153\169 \231\154\132<br/>") .. T("  \230\152\175 \228\184\142 \228\189\160 \229\144\140 \232\161\140 \231\154\132 \229\175\187 \229\174\157 \228\186\186<br/>") .. T("<lable color=summonYellow>  \231\142\169\230\179\149\232\167\132\229\136\153</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>20\231\186\167\228\187\165\228\184\138\231\154\132\232\139\177\233\155\132\230\137\141\229\143\175\228\187\165\229\143\130\229\138\160\232\191\156\229\190\129\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\232\191\156\229\190\129\232\191\135\231\168\139\228\184\173\239\188\140\230\149\140\230\136\145\229\143\140\230\150\185\231\154\132\231\148\159\229\145\189\229\128\188\229\146\140\232\131\189\233\135\143\229\128\188\228\184\141\228\188\154\233\135\141\231\189\174\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\183\178\233\152\181\228\186\161\231\154\132\232\139\177\233\155\132\228\184\141\228\188\154\229\164\141\230\180\187\239\188\140\233\153\164\233\157\158\228\189\191\231\148\168\229\188\128\229\143\163\231\172\145\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\166\130\230\158\156\229\135\186\231\142\176\230\136\152\230\150\151\232\182\133\230\151\182\239\188\140\229\136\153\231\174\151\228\189\156\229\143\140\230\150\185\230\137\128\230\156\137\232\139\177\233\155\132\229\144\140\229\189\146\228\186\142\229\176\189\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\142\169\229\174\182\230\175\143\229\164\169\229\143\175\229\143\130\228\184\142\228\184\128\230\172\161\232\191\156\229\190\129\239\188\140\231\172\172\228\186\140\229\164\169\229\135\140\230\153\1685\231\130\185\229\144\142\233\135\141\231\189\174\230\140\145\230\136\152\230\172\161\230\149\176\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\142\169\229\174\182\230\175\143\230\136\152\232\131\156\228\184\128\230\179\162\230\149\140\228\186\186\239\188\140\233\131\189\229\143\175\228\187\165\229\188\128\229\144\175\229\174\157\231\174\177\232\142\183\229\190\151\229\164\167\233\135\143\229\165\150\229\138\177\239\188\140\229\165\150\229\138\177\229\140\133\230\139\172\233\135\145\229\184\129\239\188\140\233\129\147\229\133\183\239\188\140\231\129\181\233\173\130\231\159\179\239\188\140\228\185\159\230\156\137\230\156\186\231\142\135\231\155\180\230\142\165\232\142\183\229\190\151\232\139\177\233\155\132\227\128\130<br/>"),
  T("<lable color=summonYellow>   \229\133\136\233\129\163\233\152\159\232\167\132\229\136\153</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>65\231\186\167\228\187\165\228\184\138\231\154\132\232\139\177\233\155\132\230\137\141\229\143\175\228\187\165\229\143\130\229\138\160\229\133\136\233\129\163\233\152\159\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\143\175\228\187\165\230\180\190\233\129\163\228\189\163\229\133\181\229\143\130\228\184\142\229\133\136\233\129\163\233\152\159\239\188\140\228\189\134\228\188\154\229\141\160\231\148\168\230\156\172\230\172\161\232\191\156\229\190\129\233\155\135\228\189\163\229\144\141\233\162\157\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\160\185\230\141\174\229\133\136\233\129\163\233\152\159\228\184\173\232\139\177\233\155\132\231\154\132\230\136\152\229\138\155\229\175\185\233\152\159\228\188\141\232\191\155\232\161\140\232\175\132\231\186\167\239\188\140\232\175\132\231\186\167\232\182\138\233\171\152\239\188\140\233\128\154\232\191\135\229\133\179\229\141\161\232\182\138\229\164\154\239\188\140\230\142\168\232\141\144\232\139\177\233\155\132\229\156\168\232\174\161\231\174\151\230\136\152\229\138\155\230\151\182\228\188\154\232\142\183\229\190\151\229\138\160\230\136\144\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\133\136\233\129\163\233\152\159\233\152\159\229\145\152\231\154\132\232\139\177\229\139\135\232\161\168\231\142\176\232\191\152\228\188\154\229\175\185\228\184\139\228\184\128\229\133\179\231\154\132\230\149\140\228\186\186\233\128\160\230\136\144\228\184\128\229\174\154\228\188\164\229\174\179\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\133\136\233\129\163\233\152\159\228\184\173\232\139\177\233\155\132\229\156\168\231\187\147\230\157\159\229\144\142\229\133\168\233\131\168\233\152\181\228\186\161\239\188\140\231\142\169\229\174\182\229\143\175\228\187\165\228\189\191\231\148\168\230\156\170\233\152\181\228\186\161\232\139\177\233\155\132\231\187\167\231\187\173\232\191\155\232\161\140\232\191\156\229\190\129\227\128\130<br/>")
}

function CrusadeRuleWin:createPageString()
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
