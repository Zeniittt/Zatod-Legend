local base = ed.ui.popwindow
local summonRuleTips = newclass(base.mt)
ed.ui.summonRuleTips = summonRuleTips

function summonRuleTips.create(params)
  local self = base.create("summonRuleTips")
  setmetatable(self, summonRuleTips.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function summonRuleTips:init()
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
  clippingNode:addChild(self.ui.page_1)
  clippingNode:addChild(self.ui.page_2)
  self.pagePos = {}
  local lox, loy = self.ui.page_1:getPosition()
  self.ui.page_1:setPosition(posx + lox, posy + loy)
  self.pagePos[0] = ccp(posx + lox - 600, posy + loy)
  self.pagePos[1] = ccp(posx + lox, posy + loy)
  local lox, loy = self.ui.page_2:getPosition()
  self.ui.page_2:setPosition(posx + lox, posy + loy)
  self.pagePos[2] = ccp(posx + lox, posy + loy)
  self.ui.panel_win_touch:setTouchEnabled(true)
  self.ui.panel_win_touch:registerScriptTouchHandler(self:TouchHandler(), false, -9999, false)
  self.pointPos = {}
  for i = 1, 2 do
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
end

function summonRuleTips:registerTouchHandler()
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

summonRuleTips.newTouPosX = 0
summonRuleTips.posIndex = 1

function summonRuleTips:TouchHandler()
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

function summonRuleTips:movePageNewPos(move)
  if move then
    move = move < 0
    self.posIndex = move and self.posIndex + 1 or self.posIndex - 1
  end
  self.posIndex = ed.clamp(self.posIndex, 0, 1)
  self.ui.arrow_left:setVisible(self.posIndex == 0)
  self.ui.arrow_right:setVisible(self.posIndex == 1)
  self.ui.page_1:stopAllActions()
  self.ui.page_2:stopAllActions()
  self.ui.page_1:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, self.pagePos[self.posIndex])))
  self.ui.page_2:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, self.pagePos[self.posIndex + 1])))
  self.point:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(self.pointPos[3 - (self.posIndex + 1)]:getPosition()))))
end

summonRuleTips.strPage2 = T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=summonRed>\230\175\14380\230\172\161</lable>\229\143\172\229\148\164\239\188\140\231\142\169\229\174\182\229\191\133\229\174\154\232\142\183\229\190\151<lable color=summonYellow>3\230\152\159\232\139\177\233\155\132</lable>\239\188\140\229\143\172\229\148\164\229\136\1763\230\152\159\232\139\177\233\155\132\230\151\182\239\188\140\228\191\157\229\186\149\230\172\161\230\149\176\229\176\134\233\135\141\231\189\174\232\135\179<lable color=summonRed>80\230\172\161</lable>\227\128\130<lable color=summonRed>\230\175\14310\230\172\161</lable>\229\143\172\229\148\164\229\191\133\229\190\151\232\139\177\233\155\132\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\142\169\229\174\182<lable color=summonRed>\229\137\14110\230\172\161</lable>\229\143\172\229\148\164\228\184\173\239\188\140\229\191\133\229\190\151<lable color=summonYellow>\231\148\181\233\173\130\227\128\129\230\156\175\229\163\171\227\128\129\233\163\142\232\161\140\227\128\129\230\139\141\230\139\141\231\134\138</lable>\229\155\155\229\144\1413\230\152\159\232\139\177\233\155\132\228\185\139\228\184\128\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\165\231\142\169\229\174\182\229\156\168\229\143\172\229\148\164\228\184\173\232\142\183\229\190\151\229\183\178\230\139\165\230\156\137\231\154\132\232\139\177\233\155\132\239\188\140\229\176\134\232\135\170\229\138\168\232\189\172\229\140\150\228\184\186\229\144\140\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179\231\148\168\228\187\165\232\139\177\233\155\132\229\141\135\230\152\159\239\188\140\233\135\141\229\164\141\231\154\1323\230\152\159\232\139\177\233\155\132\232\189\172\229\140\150\228\184\18680\228\184\170\229\175\185\229\186\148\231\129\181\233\173\130\231\159\179\239\188\1402\230\152\159\232\139\177\233\155\132\232\189\172\229\140\150\228\184\18630\228\184\170\229\175\185\229\186\148\231\129\181\233\173\130\231\159\179\239\188\1401\230\152\159\232\139\177\233\155\132\232\189\172\229\140\150\228\184\18610\228\184\170\229\175\185\229\186\148\231\129\181\233\173\130\231\159\179\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\142\169\229\174\182\229\143\172\229\148\164<lable color=summonRed>\230\187\16150\230\172\161</lable>\229\144\142\239\188\140\229\143\175\228\187\165\229\188\128\229\144\175\232\174\184\230\132\191\229\141\149\227\128\130\229\156\168\232\174\184\230\132\191\229\141\149\228\184\173\239\188\140\231\142\169\229\174\182\233\128\137\230\139\169\232\135\170\229\183\177\229\191\131\228\187\170\231\154\132\228\184\137\230\152\159\232\139\177\233\155\132\229\144\142\239\188\140\230\137\128\233\128\137\230\139\169\231\154\132\229\191\131\228\187\170\232\139\177\233\155\132\229\156\168\229\143\172\229\148\164\229\136\176<lable color=summonYellow>3\230\152\159\232\139\177\233\155\132</lable>\230\151\182\229\135\186\231\142\176\230\166\130\231\142\135\230\143\144\229\141\135<lable color=summonRed>35%</lable>\239\188\136\232\139\165\233\128\137\230\139\1692\228\184\170\229\136\153\229\144\132\229\141\1603\230\152\159\232\139\177\233\155\132\230\166\130\231\142\135\231\154\13235%\239\188\140\229\133\17770%\239\188\137\239\188\140\229\143\172\229\148\1643\230\152\159\232\139\177\233\155\132\231\154\132\230\128\187\230\166\130\231\142\135\228\184\141\229\143\152\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=summonRed>\230\175\143\229\145\168</lable>\233\166\150\230\172\161\229\143\172\229\148\164\229\135\186\232\174\184\230\132\191\229\141\149\228\184\173\231\154\1323\230\152\159\232\139\177\233\155\132\229\144\142\239\188\140\229\175\185\229\186\148\232\139\177\233\155\132\231\154\132\230\166\130\231\142\135\230\143\144\229\141\135\230\149\136\230\158\156\229\164\177\230\149\136\239\188\140<lable color=summonRed>\228\184\139\229\145\168\228\184\1285\231\130\185</lable>\229\136\183\230\150\176\227\128\130<br/>")
summonRuleTips.strPage1 = {
  {
    "Hero1",
    T("1\230\152\159\232\139\177\233\155\132"),
    "19.98%"
  },
  {
    "Hero2",
    T("2\230\152\159\232\139\177\233\155\132"),
    "4.39%"
  },
  {
    "Hero3",
    T("3\230\152\159\232\139\177\233\155\132"),
    T("1.71%\239\188\136\229\144\171\228\191\157\229\186\149\239\188\137")
  },
  {
    "SoulStone1",
    T("1\230\152\159\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179"),
    "56.44%"
  },
  {
    "SoulStone2",
    T("2\230\152\159\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179"),
    "14.98%"
  },
  {
    "SoulStone3",
    T("3\230\152\159\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179"),
    "2.50%"
  }
}

function summonRuleTips:createPageString()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = self.strPage2,
    fontSize = 16,
    lineSpacing = 4,
    maxWidth = self.ui.panel_clipping:getContentSize().width - 46
  })
  local atDraglist = ed.UITool.createDraglist(self.ui.page_2, {})
  atDraglist:addItem(autoText.node)
  local _, height = autoText:getCurContentSize()
  autoText.node:setPosition(20, self.ui.page_2:getContentSize().height - 10)
  atDraglist:initListHeight(height + 10)
  local newGroup = {}
  local str
  for i, v in ipairs(self.strPage1) do
    str = ed.createttf(v[2], 16)
    str:setPosition(ccp(100, 237 - i * 36.5))
    str:setColor(i == 3 and ccc3(223, 170, 69) or ccc3(255, 252, 231))
    str:setAnchorPoint(ccp(0.5, 0.5))
    str:limitWidthByScale(190)
    self.ui.Image_tab_bj:addChild(str)
    str:setShadow(ccc3(0, 0, 0), ccp(0, 2))
    str = ed.createttf(newGroup[v[1]] and newGroup[v[1]] .. "%" or ed.formatFloat(v[3]), 16)
    str:setPosition(ccp(340, 237 - i * 36.5))
    str:setColor(i == 3 and ccc3(223, 170, 69) or ccc3(255, 252, 231))
    self.ui.Image_tab_bj:addChild(str)
    str:setShadow(ccc3(0, 0, 0), ccp(0, 3))
  end
end
