local base = ed.ui.popwindow
local petRuleTips = newclass(base.mt)
ed.ui.petRuleTips = petRuleTips
petRuleTips.newTouPosX = 0
petRuleTips.posIndex = 1

function petRuleTips.create(params)
  local self = base.create("petRuleTips")
  setmetatable(self, petRuleTips.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function petRuleTips:init()
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

function petRuleTips:registerTouchHandler()
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

function petRuleTips:TouchHandler()
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

function petRuleTips:movePageNewPos(move)
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

petRuleTips.strPage = {
  T("<lable color=summonYellow>\228\191\161\228\189\191\231\154\132\229\173\181\229\140\150</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\142\183\229\190\151\228\191\161\228\189\191\232\155\139\229\144\142\239\188\140\229\143\175\228\187\165\229\156\168\228\191\161\228\189\191\229\177\139\233\135\140\232\191\155\232\161\140\229\173\181\229\140\150\239\188\140\231\130\185\229\135\187\229\173\181\229\140\150\229\174\140\230\136\144\231\154\132\228\191\161\228\189\191\232\155\139\239\188\140\229\143\175\228\187\165\232\142\183\229\190\151\228\191\161\228\189\191\227\128\130<br/>") .. T("<lable color=summonYellow>\228\191\161\228\189\191\231\154\132\233\162\134\229\133\187</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\139\177\233\155\132\231\173\137\231\186\167\232\190\190\229\136\17680\231\186\167\239\188\140\228\184\148\229\147\129\233\152\182\232\190\190\229\136\176\231\180\171+2\229\144\142\239\188\140\229\143\175\228\187\165\233\162\134\229\133\187\228\187\187\230\132\143\228\191\161\228\189\191\228\191\161\228\189\191\229\143\175\228\187\165\231\166\187\229\188\128\228\184\187\228\186\186\239\188\140\228\189\134\230\152\175\228\188\154\230\156\137\229\134\183\229\141\180\230\151\182\233\151\180\227\128\130\229\156\168\229\134\183\229\141\180\230\151\182\233\151\180\229\134\133\239\188\140\228\191\161\228\189\191\230\151\160\230\179\149\231\166\187\229\188\128\228\184\139\228\184\128\228\184\170\228\184\187\228\186\186\227\128\130<br/>") .. T("<lable color=summonYellow>\228\191\161\228\189\191\231\154\132\228\189\156\231\148\168</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\191\161\228\189\191\229\143\175\228\187\165\228\184\186\228\184\187\228\186\186\230\143\144\228\190\155\229\138\155\233\135\143\227\128\129\230\149\143\230\141\183\227\128\129\230\153\186\229\138\155\231\154\132\229\138\160\230\136\144\239\188\140\228\191\161\228\189\191\230\139\165\230\156\137\230\138\128\232\131\189\239\188\140\229\143\175\228\187\165\229\156\168\230\136\152\230\150\151\228\184\173\231\187\153\228\186\136\228\184\187\228\186\186\229\184\174\229\138\169\227\128\130\229\147\129\232\180\168\232\182\138\233\171\152\231\154\132\228\191\161\228\189\191\239\188\140\230\138\128\232\131\189\230\149\136\230\158\156\232\182\138\229\188\186<br/>") .. T("<lable color=summonYellow>\228\191\161\228\189\191\231\154\132\229\133\187\230\136\144</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\150\130\229\133\187\228\191\161\228\189\191\229\143\175\228\187\165\232\174\169\228\191\161\228\189\191\231\187\153\232\139\177\233\155\132\230\143\144\228\190\155\231\154\132\229\138\160\230\136\144\230\155\180\229\164\154\239\188\140\232\174\173\231\187\131\228\191\161\228\189\191\229\143\175\228\187\165\228\189\191\228\191\161\228\189\191\230\138\128\232\131\189\231\154\132\230\149\136\230\158\156\229\143\152\229\188\186<br/>"),
  T("<lable color=summonYellow>\228\191\161\228\189\191\231\154\132\230\148\190\231\148\159</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\178\161\230\156\137\228\184\187\228\186\186\231\154\132\232\147\157\232\137\178\229\146\140\231\180\171\232\137\178\228\191\161\228\189\191\229\143\175\228\187\165\232\162\171\230\148\190\231\148\159\239\188\140\229\166\130\230\158\156\228\191\161\228\189\191\228\185\139\229\137\141\232\162\171\229\150\130\229\133\187\230\136\150\232\174\173\231\187\131\232\191\135\239\188\140\233\130\163\228\185\136\229\156\168\230\148\190\231\148\159\230\151\182\228\188\154\232\191\148\232\191\152\228\185\139\229\137\141\230\182\136\232\128\151\231\154\132\230\157\144\230\150\153\239\188\140\232\191\148\232\191\152\230\175\148\228\190\139\228\184\18675%\239\188\140\230\148\190\231\148\159\229\144\142\228\188\154\232\142\183\229\190\151\231\136\177\229\191\131\231\130\185\230\149\176\239\188\140\229\143\175\231\148\168\228\186\142\229\156\168\228\191\161\228\189\191\229\149\134\229\186\151\228\184\173\232\191\155\232\161\140\229\133\145\230\141\162\229\165\150\229\138\177<br/>")
}

function petRuleTips:createPageString()
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
