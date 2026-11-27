local base = ed.ui.popwindow
local AutoChessArenaRule = newclass(base.mt)
ed.ui.AutoChessArenaRule = AutoChessArenaRule

function AutoChessArenaRule.create(params)
  local self = base.create("AutoChessArenaRule")
  setmetatable(self, AutoChessArenaRule.mt)
  self.params = params
  self.ui = {}
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ed.uieditor.summonRuleTips)
  self:init()
  self:registerTouchHandler()
  self:show()
  return self
end

function AutoChessArenaRule:init()
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

function AutoChessArenaRule:registerTouchHandler()
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

function AutoChessArenaRule:TouchHandler()
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

function AutoChessArenaRule:movePageNewPos(move)
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

AutoChessArenaRule.strPage = {
  T("<lable color=summonYellow>\232\167\132\229\136\153\232\175\180\230\152\142:</lable><br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>1.\230\163\139\229\173\144\229\136\134\228\184\186\231\153\189\227\128\129\231\187\191\227\128\129\232\147\157\227\128\129\231\180\171\227\128\129\230\169\153\229\147\129\233\152\182\239\188\140\229\136\134\229\136\171\229\148\174\228\187\183<lable color=summonYellow>1\227\128\1292\227\128\1293\227\128\1294\227\128\1295</lable>\233\135\145\229\184\129\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>2.\229\156\168\229\149\134\229\186\151\232\180\173\228\185\176\231\154\132\230\163\139\229\173\144\233\187\152\232\174\164\230\152\1751\230\152\159\239\188\140\229\189\147\232\180\173\228\185\176\228\186\134\228\184\137\228\184\170\239\188\140\228\188\154\232\135\170\229\138\168\229\144\136\230\136\1442\230\152\159\231\154\132\230\163\139\229\173\144\239\188\140\229\144\136\230\136\1443\230\152\159\229\143\170\233\156\128\232\166\1292\228\184\1702\230\152\159\230\163\139\229\173\144\227\128\130\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>3.\230\163\139\229\173\144\233\131\189\230\139\165\230\156\137\231\167\141\230\151\143\229\146\140\232\129\140\228\184\154\230\160\135\231\173\190\239\188\140\229\189\147\228\184\138\233\152\181\230\187\161\232\182\179\228\184\128\229\174\154\230\149\176\233\135\143\230\151\182\239\188\140\229\141\179\229\143\175\232\167\166\229\143\145\232\191\158\233\148\129\230\138\128\232\131\189\227\128\130\228\190\139\239\188\1542\228\184\170\228\186\186\231\177\187\227\128\1293\228\184\170\230\179\149\229\184\136\226\128\166\226\128\166<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>4.\229\135\134\229\164\135\229\155\158\229\144\136\231\187\147\230\157\159\229\144\142\239\188\140\230\136\145\230\150\185\233\156\128\232\166\129\233\152\178\229\174\136\230\157\165\232\135\170\229\133\182\228\187\150\233\152\159\233\149\191\229\164\141\229\136\182\228\186\186\230\136\150\232\128\133\233\135\142\230\128\170\231\154\132\232\191\155\230\148\187\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>5.\230\175\143\229\155\158\229\144\136\229\135\134\229\164\135\233\152\182\230\174\181\229\188\128\229\167\139\230\151\182\239\188\140\233\131\189\228\188\154\229\190\151\229\136\176\228\184\128\229\174\154\229\159\186\231\161\128\233\135\145\229\184\129\227\128\129\229\136\169\230\129\175\231\187\147\231\174\151\227\128\129\232\191\158\232\131\156\230\136\150\232\128\133\232\191\158\232\180\165\229\165\150\229\138\177\233\135\145\229\184\129\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>6.\229\136\169\230\129\175\231\187\147\231\174\151\239\188\154\230\175\14210\228\184\170\233\135\145\229\184\129\229\190\151\229\136\1761\233\135\145\229\184\129\229\136\169\230\129\175\239\188\140\229\141\149\229\155\158\229\144\136\230\156\128\229\164\154\229\190\151\229\136\1765\228\184\170\233\135\145\229\184\129\229\136\169\230\129\175\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>7.\230\143\144\229\141\135\229\149\134\229\186\151\231\173\137\231\186\167\229\143\175\228\187\165\230\143\144\229\141\135\229\149\134\229\186\151\233\135\140\233\171\152\231\173\137\231\186\167\230\163\139\229\173\144\229\136\183\229\135\186\230\166\130\231\142\135\229\146\140\228\184\138\233\152\181\230\149\176\233\135\143\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>8.\232\191\158\232\131\156\233\135\145\229\184\129\230\156\128\229\164\154\232\142\183\229\190\1513\230\158\154\239\188\140\232\191\158\232\180\165\233\135\145\229\184\129\230\156\128\229\164\154\232\142\183\229\190\1515\230\158\154\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>9.\231\165\157\228\189\160\230\163\139\229\188\128\229\190\151\232\131\156\227\128\130<br/>"),
  T("<lable color=summonYellow>\229\164\169\230\162\175\231\155\184\229\133\179\232\167\132\229\136\153</lable><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\191\155\232\161\140\229\164\169\230\162\175\229\140\185\233\133\141\239\188\140\231\187\147\231\174\151\230\151\182\230\160\185\230\141\174\229\144\141\230\172\161\229\143\175\228\187\165\232\142\183\229\190\151\230\136\150\229\135\143\229\176\145\231\167\175\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\163\171\229\133\181\233\152\182\230\174\181\228\184\141\228\188\154\229\135\143\229\176\145\231\167\175\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\136\176\232\190\190\230\150\176\230\174\181\228\189\141\228\185\139\229\144\142\228\184\141\228\188\154\229\134\141\232\183\140\232\144\189\230\151\167\230\174\181\228\189\141\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\174\181\228\189\141\233\161\186\229\186\143\228\184\186\239\188\154\229\163\171\229\133\181--\233\170\145\229\163\171--\229\159\142\229\160\161--\228\184\187\230\149\153--\231\154\135\229\144\142--\229\155\189\231\142\139\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\163\171\229\133\181\226\133\160:0\229\136\134 \229\163\171\229\133\181\226\133\161:3\229\136\134 \229\163\171\229\133\181\226\133\162:6\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\170\145\229\163\171\226\133\160:9\229\136\134 \233\170\145\229\163\171\226\133\161:12\229\136\134 \233\170\145\229\163\171\226\133\162:15\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\159\142\229\160\161\226\133\160:18\229\136\134 \229\159\142\229\160\161\226\133\161:23\229\136\134 \229\159\142\229\160\161\226\133\162:28\229\136\134 \229\159\142\229\160\161\226\133\163:33\229\136\134 \229\159\142\229\160\161\226\133\164:38\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\228\184\187\230\149\153\226\133\160:43\229\136\134 \228\184\187\230\149\153\226\133\161:51\229\136\134 \228\184\187\230\149\153\226\133\162:59\229\136\134 \228\184\187\230\149\153\226\133\163:67\229\136\134 \228\184\187\230\149\153\226\133\164:75\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\231\154\135\229\144\142\226\133\160:83\229\136\134 \231\154\135\229\144\142\226\133\161:99\229\136\134 \231\154\135\229\144\142\226\133\162:115\229\136\134 \231\154\135\229\144\142\226\133\163:131\229\136\134 \231\154\135\229\144\142\226\133\164:147\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\155\189\231\142\139\231\167\175\229\136\134\239\188\154163\229\136\134\227\128\130<br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\191\155\229\133\165\230\154\180\232\181\176\230\163\139\230\142\146\232\161\140\230\166\156\229\144\142\239\188\140\231\172\172\228\184\128\229\144\141\239\188\1542\229\136\134\239\188\140\231\172\172\228\186\140\229\144\141\239\188\1541\229\136\134\239\188\140\231\172\172\228\184\137\229\144\141\239\188\154-1\229\136\134\239\188\140\231\172\172\229\155\155\229\144\141\239\188\154-2\229\136\134\239\188\140\230\160\185\230\141\174\231\167\175\229\136\134\232\191\155\232\161\140\230\142\146\229\144\141\227\128\130<br/>")
}

function AutoChessArenaRule:createPageString()
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
