local base = ed.ui.popwindow
local summonTimelyRule = newclass(base.mt)
ed.ui.summonTimelyRule = summonTimelyRule

function summonTimelyRule.create(params)
  local self = base.create("summonTimelyRule")
  setmetatable(self, summonTimelyRule.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function summonTimelyRule:init()
  ed.setLabelDimensions(self.ui.page_1_desc, CCSizeMake(528, 45))
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
  clippingNode:addChild(self.ui.page_2)
  self.pagePos = {}
  local lox, loy = self.ui.page_1:getPosition()
  self.ui.page_1:setPosition(posx + lox, posy + loy)
  self.pagePos[0] = ccp(posx + lox - 600, posy + loy)
  self.pagePos[1] = ccp(posx + lox, posy + loy)
  self.ui.page_2:setPosition(posx + lox, posy + loy)
  self.pagePos[2] = ccp(posx + lox, posy + loy)
  self.ui.panel_win_touch:setTouchEnabled(true)
  self.ui.panel_win_touch:registerScriptTouchHandler(self:TouchHandler(), false, -9999, false)
  self.pointPos = {}
  for i = 1, 1 do
    local point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_1.png")
    point:setPosition(272 + i * 20, 15)
    self.ui.Image_bg:addChild(point)
    self.pointPos[i] = point
  end
  self.point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_2.png")
  self.point:setPosition(292, 15)
  self.ui.Image_bg:addChild(self.point)
  self.ui.arrow_right:setVisible(false)
end

function summonTimelyRule:registerTouchHandler()
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

summonTimelyRule.newTouPosX = 0
summonTimelyRule.posIndex = 1

function summonTimelyRule:TouchHandler()
  local function handler(event, x, y)
    if event == "began" then
      self.newTouPosX = x
    elseif event == "ended" then
      local newX = self.newTouPosX - x
      self:movePageNewPos(math.abs(newX) > 100 and newX or false)
    elseif event == "moved" then
      local newX = x - self.newTouPosX
      local posX, posY = self.pagePos[self.posIndex].x + newX, self.pagePos[self.posIndex].y
      self.ui.page_1:setPosition(posX, posY)
      posX, posY = self.pagePos[self.posIndex + 1].x + newX, self.pagePos[self.posIndex + 1].y
      self.ui.page_2:setPosition(posX, posY)
    end
    return true
  end
  
  return handler
end

function summonTimelyRule:movePageNewPos(move)
  if move then
    move = move < 0
    self.posIndex = move and self.posIndex + 1 or self.posIndex - 1
  end
  self.posIndex = ed.clamp(self.posIndex, 0, 1)
  self.ui.arrow_left:setVisible(false)
  self.ui.arrow_right:setVisible(false)
  self.ui.page_1:stopAllActions()
  self.ui.page_2:stopAllActions()
  self.ui.page_1:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, self.pagePos[self.posIndex])))
  self.ui.page_2:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, self.pagePos[self.posIndex + 1])))
end

summonTimelyRule.strPage2 = T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\153\144\230\151\182\229\143\172\229\148\164\228\184\141\229\174\154\230\156\159\229\188\128\229\144\175\239\188\140\229\143\175\228\189\191\231\148\168<lable color=summonRed>\230\151\182\233\151\180\230\178\153\230\188\143</lable>\229\156\168\229\133\182\228\184\173\229\143\172\229\148\164<lable color=summonYellow>\229\189\147\230\156\159\230\150\176\232\139\177\233\155\132</lable>\227\128\130\233\153\144\230\151\182\229\143\172\229\148\164\228\184\173\231\154\132\229\133\182\228\189\153\229\134\133\229\174\185\229\146\140\230\166\130\231\142\135\229\157\135\228\184\142\232\139\177\233\155\132\229\143\172\229\148\164\228\191\157\230\140\129\228\184\128\232\135\180\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\233\153\144\230\151\182\229\143\172\229\148\164\228\184\173\239\188\140\230\175\143\232\191\155\232\161\140<lable color=summonRed>80\230\172\161</lable>\229\143\172\229\148\164\239\188\140\229\176\134\232\135\179\229\176\145\232\142\183\229\190\151\228\184\128\229\144\141<lable color=summonYellow>\229\136\157\229\167\1393\230\152\159\232\139\177\233\155\132</lable>\239\188\140\228\184\148\230\156\137<lable color=summonRed>50%</lable>\231\154\132\230\166\130\231\142\135\228\184\186<lable color=summonRed>\229\189\147\230\156\159\230\150\176\232\139\177\233\155\132</lable>\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\165\229\156\168\232\142\183\229\143\150\229\136\157\229\167\1393\230\152\159\232\139\177\233\155\132\230\151\182\228\184\141\228\184\186\229\189\147\230\156\159\230\150\176\232\139\177\233\155\132\239\188\140\229\136\153<lable color=summonYellow>\228\184\139\228\184\128\230\172\161\232\142\183\229\143\150\229\136\157\229\167\1393\230\152\159\232\139\177\233\155\132\230\151\182\229\191\133\228\184\186\229\189\147\230\156\159\230\150\176\232\139\177\233\155\132</lable>\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\230\175\143\228\184\128\230\156\159\233\153\144\230\151\182\229\143\172\229\148\164\228\184\173\239\188\140<lable color=summonRed>\233\166\150\230\172\161\231\180\175\231\167\175\229\143\172\229\148\164\230\187\16180\230\172\161</lable>\230\151\182\239\188\140\229\143\175\228\187\165<lable color=summonRed>\233\162\157\229\164\150\232\142\183\229\190\151</lable>1\229\188\160\229\189\147\230\156\159\232\139\177\233\155\132\230\149\180\229\141\161\239\188\140\232\139\165\229\156\168\230\173\164\229\137\141\229\183\178\231\187\143\232\142\183\229\190\151\232\175\165\232\139\177\233\155\132\239\188\140\229\136\153\229\176\134\232\189\172\230\141\162\228\184\186\232\175\165\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179*80\239\188\140\233\162\157\229\164\150\229\165\150\229\138\177\231\154\132\231\180\175\232\174\161\232\191\155\229\186\166\229\176\134\233\154\143\233\153\144\230\151\182\229\143\172\229\148\164\230\155\180\232\191\173\232\128\140\230\184\133\231\169\186\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\153\144\230\151\182\229\143\172\229\148\164\231\187\147\230\157\159\229\144\142\239\188\140\229\189\147\230\156\159\232\139\177\233\155\132\229\176\134\229\156\168<lable color=summonRed>\228\184\139\228\184\128\231\137\136\230\156\172</lable>\228\184\173\229\138\160\229\133\165\232\139\177\233\155\132\229\143\172\229\148\164\229\146\140\229\145\189\229\174\154\229\143\172\229\148\164\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\228\187\187\230\132\143\233\153\144\230\151\182\229\143\172\229\148\164\229\141\161\230\177\160\228\184\173\239\188\140\230\156\170\229\143\172\229\148\164\229\135\186<lable color=summonYellow>\229\136\157\229\167\139\228\184\137\230\152\159\232\139\177\233\155\132</lable>\229\146\140\230\156\170\229\143\172\229\148\164\229\135\186<lable color=summonYellow>\229\189\147\230\156\159\229\136\157\229\167\139\228\184\137\230\152\159\232\139\177\233\155\132</lable>\231\154\132\230\172\161\230\149\176\229\176\134<lable color=summonRed>\228\184\128\231\155\180\231\180\175\232\174\161</lable>\239\188\140\228\184\141\228\188\154\233\154\143\233\153\144\230\151\182\229\143\172\229\148\164\229\141\161\230\177\160\231\154\132\230\155\180\230\141\162\232\128\140\230\184\133\231\169\186\227\128\130<br/>")
summonTimelyRule.strPage1 = {
  {
    "Hero1",
    "1\230\152\159\232\139\177\233\155\132",
    "19.98%"
  },
  {
    "Hero2",
    "2\230\152\159\232\139\177\233\155\132",
    "4.39%"
  },
  {
    "Hero3",
    "3\230\152\159\232\139\177\233\155\132",
    "1.71%\239\188\136\229\144\171\228\191\157\229\186\149\239\188\137"
  },
  {
    "SoulStone1",
    "1\230\152\159\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179",
    "56.44%"
  },
  {
    "SoulStone2",
    "2\230\152\159\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179",
    "14.98%"
  },
  {
    "SoulStone3",
    "3\230\152\159\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179",
    "2.50%"
  }
}

function summonTimelyRule:createPageString()
  local autoText = ed.ui.autoText.new()
  local fontSize = ed.isAreaZh() and 16 or 12
  autoText:initParam({
    context = self.strPage2,
    fontSize = fontSize,
    lineSpacing = 4,
    maxWidth = self.ui.panel_clipping:getContentSize().width - 46
  })
  self.ui.page_2:addChild(autoText.node)
  local _, height = autoText:getCurContentSize()
  autoText.node:setPosition(20, self.ui.panel_clipping:getContentSize().height - 20)
  local newGroup = {}
  local str
  for i, v in ipairs(self.strPage1) do
    str = ed.createttf(v[2], 16)
    str:setPosition(ccp(50, 237 - i * 36.5))
    str:setColor(i == 3 and ccc3(223, 170, 69) or ccc3(255, 252, 231))
    str:setAnchorPoint(ccp(0, 0.5))
    self.ui.Image_tab_bj:addChild(str)
    str:setShadow(ccc3(0, 0, 0), ccp(0, 2))
    str = ed.createttf(newGroup[v[1]] and newGroup[v[1]] .. "%" or v[3], 16)
    str:setPosition(ccp(340, 237 - i * 36.5))
    str:setColor(i == 3 and ccc3(223, 170, 69) or ccc3(255, 252, 231))
    self.ui.Image_tab_bj:addChild(str)
    str:setShadow(ccc3(0, 0, 0), ccp(0, 3))
  end
end
