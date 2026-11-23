local base = ed.ui.popwindow
local SkillTowerRuleWin = newclass(base.mt)
ed.ui.SkillTowerRuleWin = SkillTowerRuleWin

function SkillTowerRuleWin.create(params)
  local self = base.create("SkillTowerRuleWin")
  setmetatable(self, SkillTowerRuleWin.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function SkillTowerRuleWin:init()
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

function SkillTowerRuleWin:registerTouchHandler()
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

function SkillTowerRuleWin:TouchHandler()
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

function SkillTowerRuleWin:movePageNewPos(move)
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

SkillTowerRuleWin.strPage = {
  T("\226\128\156\230\152\168\229\164\156\230\136\145\231\130\185\231\135\131\233\166\153\231\131\155\229\133\165\230\162\166\239\188\140\233\128\160\232\174\191\231\186\160\231\188\160\231\148\159\233\149\191\231\154\132\229\185\187\229\162\131\228\185\139\229\161\148\239\188\140\230\140\145\230\136\152\233\130\163\228\186\155\230\178\137\230\183\128\229\156\168\229\142\134\229\143\178\228\184\173\231\154\132\232\139\177\233\155\132\229\189\177\229\131\143\239\188\140\230\136\145\231\148\154\232\135\179\233\129\135\229\136\176\228\186\134\230\136\145\232\135\170\229\183\177\239\188\129\229\147\136\229\147\136\239\188\140\231\156\159\230\152\175\230\156\137\232\182\163\239\188\129\232\128\140\229\189\147\230\136\145\233\134\146\230\157\165\239\188\140\228\186\164\230\136\152\232\174\176\229\191\134\229\183\178\232\158\141\229\133\165\228\189\147\232\130\164\239\188\140\230\136\145\232\131\189\230\132\159\232\167\137\229\136\176\232\135\170\229\183\177\229\143\152\229\190\151\230\155\180\229\188\186\239\188\129\226\128\157<br/>") .. T("                                             \226\128\148\226\128\148\226\128\148\226\128\148 \227\128\144\232\136\185\233\149\191\231\154\132\230\151\165\232\174\176\227\128\145<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\185\187\229\162\131\229\141\131\229\167\191\231\153\190\230\128\129\239\188\140\231\142\169\229\174\182\229\143\175\228\187\165\233\128\137\230\139\169\233\128\130\229\174\156\231\154\132\229\185\187\229\162\131\232\191\155\232\161\140\230\140\145\230\136\152\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\184\186\228\186\134\228\184\141\232\191\183\229\164\177\230\150\185\229\144\145\239\188\140\230\175\143\230\172\161\229\156\168\229\185\187\229\162\131\228\184\173\229\137\141\232\191\155\239\188\140\233\131\189\233\156\128\232\166\129\230\182\136\232\128\151<lable color=summonYellow>\229\185\187\231\148\159\231\131\155</lable>\227\128\130\229\185\187\229\162\131\232\182\138\230\183\177\239\188\140\230\182\136\232\128\151\231\154\132\229\185\187\231\148\159\231\131\155\230\149\176\233\135\143\232\182\138\229\164\154\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168\232\167\132\229\174\154\230\151\182\233\151\180\229\134\133\230\136\152\232\131\156\230\137\128\230\156\137\232\139\177\233\155\132\229\189\177\229\131\143\229\141\179\229\143\175\232\191\155\229\133\165\228\184\139\228\184\128\229\177\130\229\185\187\229\162\131\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\166\150\230\172\161\233\128\154\229\133\179\230\175\143\229\177\130\229\185\187\229\162\131\230\151\182\239\188\140\229\143\175\228\187\165\232\142\183\229\190\151\233\166\150\233\128\154\229\165\150\229\138\177\239\188\140\229\144\142\231\187\173\233\135\141\229\164\141\230\140\145\230\136\152\230\136\150\230\137\171\232\141\161\229\185\187\229\162\131\230\151\182\239\188\140\229\143\170\232\142\183\229\190\151\230\153\174\233\128\154\229\165\150\229\138\177\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\156\168<lable color=summonYellow>\229\138\155\227\128\129\230\149\143\227\128\129\230\153\186\228\184\137\231\167\141\229\185\187\229\162\131</lable>\228\184\173\239\188\140\230\175\143\228\184\128\229\177\130\229\185\187\229\162\131\233\131\189\230\139\165\230\156\137<lable color=summonYellow>3\228\184\170\232\175\149\231\130\188\230\157\161\228\187\182</lable>\239\188\140\229\156\168\229\141\149\230\172\161\230\140\145\230\136\152\228\184\173\230\175\143\232\190\190\230\136\1441\228\184\170\230\157\161\228\187\182\229\143\175\228\187\165\232\142\183\229\190\1511\233\162\151\230\152\159\230\152\159\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=summonYellow>\230\148\182\233\155\134\230\152\159\230\152\159</lable>\232\190\190\229\136\176\228\184\128\229\174\154\230\149\176\233\135\143\239\188\140\229\143\175\228\187\165<lable color=summonYellow>\230\141\162\229\143\150\233\155\134\230\152\159\229\165\150\229\138\177</lable>\227\128\130<br/>")
}

function SkillTowerRuleWin:createPageString()
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
    local _, height = autoText:getCurContentSize()
    autoText.node:setPosition(20, self.ui.panel_clipping:getContentSize().height - autoText:getFirstLineHeight())
  end
end
