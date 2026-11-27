local base = ed.ui.popwindow
local pvpRuleTips = newclass(base.mt)
ed.ui.pvpRuleTips = pvpRuleTips
pvpRuleTips.newTouPosX = 0
pvpRuleTips.posIndex = 1

function pvpRuleTips.create(params)
  local self = base.create("pvpRuleTips")
  setmetatable(self, pvpRuleTips.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function pvpRuleTips:init()
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

function pvpRuleTips:registerTouchHandler()
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

function pvpRuleTips:TouchHandler()
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

function pvpRuleTips:movePageNewPos(move)
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

if ed.isAreaOverSea() then
  pvpRuleTips.strPage = {
    T("<lable color=summonYellow>\230\140\145\230\136\152\232\167\132\229\136\153</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\229\164\16915:00(UTC)\231\154\132\230\142\146\229\144\141\232\142\183\229\190\151\231\187\147\231\174\151\229\165\150\229\138\177\239\188\140\233\128\154\232\191\135\233\130\174\231\174\177\229\143\145\230\148\190\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\231\171\158\230\138\128\229\156\186\230\136\152\230\150\151\228\184\173,\230\137\128\230\156\137\232\139\177\233\155\132\232\161\128\233\135\143\229\143\138\230\138\164\231\155\190\230\149\136\230\158\156\231\187\143\232\191\135\231\155\184\229\144\140\229\185\133\229\186\166\228\184\138\232\176\131\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\165\230\136\152\230\150\151\232\131\156\229\136\169,\228\184\148\233\152\178\229\174\136\230\150\185\231\154\132\230\142\146\229\144\141\233\171\152\228\186\142\232\191\155\230\148\187\230\150\185,\229\136\153\229\176\134\229\143\140\230\150\185\231\154\132\230\142\146\229\144\141\229\175\185\232\176\131\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\165\230\136\152\230\150\151\232\182\133\230\151\182\229\136\153\231\174\151\228\189\156\232\191\155\230\148\187\230\150\185\229\164\177\232\180\165\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\173\163\229\156\168\232\191\155\232\161\140\230\136\152\230\150\151\231\154\132\230\149\140\228\186\186\230\151\160\230\179\149\232\162\171\233\128\137\228\189\156\229\175\185\230\137\139\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\229\164\169\230\175\143\228\184\170\231\142\169\229\174\182\229\143\175\228\187\165\229\133\141\232\180\185\229\143\145\232\181\183\230\136\152\230\150\1515\230\172\161,\230\175\143\229\164\169\229\135\140\230\153\1685\231\130\185\230\149\180\233\135\141\231\189\174\230\172\161\230\149\176\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\184\170\228\186\186\230\139\165\230\156\137\231\154\132\231\171\158\230\138\128\229\156\186\229\184\129\228\184\138\233\153\144\228\184\18610\228\184\135\239\188\140\232\175\183\229\176\189\229\191\171\229\133\145\230\141\162\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\189\147\231\142\169\229\174\182\230\136\144\229\138\159\229\141\135\232\135\179\232\135\170\229\183\177\231\154\132\229\142\134\229\143\178\230\156\128\233\171\152\230\142\146\229\144\141\230\151\182\239\188\140\233\128\154\232\191\135\233\130\174\231\174\177\229\143\145\230\148\190\228\184\128\230\172\161\230\128\167\229\165\150\229\138\177\227\128\130<br/>")
  }
else
  pvpRuleTips.strPage = {
    T("<lable color=summonYellow>\230\140\145\230\136\152\232\167\132\229\136\153</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\229\164\169\230\153\154\228\184\1389\231\130\185\230\149\180\231\154\132\230\142\146\229\144\141\232\142\183\229\190\151\231\187\147\231\174\151\229\165\150\229\138\177\239\188\140\233\128\154\232\191\135\233\130\174\231\174\177\229\143\145\230\148\190\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\231\171\158\230\138\128\229\156\186\230\136\152\230\150\151\228\184\173,\230\137\128\230\156\137\232\139\177\233\155\132\232\161\128\233\135\143\229\143\138\230\138\164\231\155\190\230\149\136\230\158\156\231\187\143\232\191\135\231\155\184\229\144\140\229\185\133\229\186\166\228\184\138\232\176\131\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\165\230\136\152\230\150\151\232\131\156\229\136\169,\228\184\148\233\152\178\229\174\136\230\150\185\231\154\132\230\142\146\229\144\141\233\171\152\228\186\142\232\191\155\230\148\187\230\150\185,\229\136\153\229\176\134\229\143\140\230\150\185\231\154\132\230\142\146\229\144\141\229\175\185\232\176\131\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\165\230\136\152\230\150\151\232\182\133\230\151\182\229\136\153\231\174\151\228\189\156\232\191\155\230\148\187\230\150\185\229\164\177\232\180\165\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\173\163\229\156\168\232\191\155\232\161\140\230\136\152\230\150\151\231\154\132\230\149\140\228\186\186\230\151\160\230\179\149\232\162\171\233\128\137\228\189\156\229\175\185\230\137\139\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\175\143\229\164\169\230\175\143\228\184\170\231\142\169\229\174\182\229\143\175\228\187\165\229\133\141\232\180\185\229\143\145\232\181\183\230\136\152\230\150\1515\230\172\161,\230\175\143\229\164\169\229\135\140\230\153\1685\231\130\185\230\149\180\233\135\141\231\189\174\230\172\161\230\149\176\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\184\170\228\186\186\230\139\165\230\156\137\231\154\132\231\171\158\230\138\128\229\156\186\229\184\129\228\184\138\233\153\144\228\184\18610\228\184\135\239\188\140\232\175\183\229\176\189\229\191\171\229\133\145\230\141\162\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\189\147\231\142\169\229\174\182\230\136\144\229\138\159\229\141\135\232\135\179\232\135\170\229\183\177\231\154\132\229\142\134\229\143\178\230\156\128\233\171\152\230\142\146\229\144\141\230\151\182\239\188\140\233\128\154\232\191\135\233\130\174\231\174\177\229\143\145\230\148\190\228\184\128\230\172\161\230\128\167\229\165\150\229\138\177\227\128\130<br/>")
  }
end

function pvpRuleTips:createPageString()
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
