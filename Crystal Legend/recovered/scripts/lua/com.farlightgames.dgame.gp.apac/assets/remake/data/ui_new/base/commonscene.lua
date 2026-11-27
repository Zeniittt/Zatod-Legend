local base = ed.ui.basescene
local commonscene = newclass(base.mt)
ed.ui.commonscene = commonscene
local mainButtonCfg = ed.ui.configs.mainButton
local ButtonType = mainButtonCfg.ButtonType
local TOUCH_PRIORITY = -18
commonscene.TOUCH_PRIORITY = TOUCH_PRIORITY

function commonscene.create(id, params)
  params = params or {}
  local self = base.create(id)
  setmetatable(self, commonscene.mt)
  self:init(params)
  return self
end

function commonscene:init(params)
  local container, ui = ed.editorui(ed.uieditor.commonScene)
  local shieldLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  shieldLayer:setPosition(-ed.display.halfFixedWidth, -ed.display.halfFixedHeight)
  container:addChild(shieldLayer, -1)
  ui.shieldLayer = shieldLayer
  self.baseui = ui
  self.mainLayer:addChild(container, 999)
  self:initResourceBox()
  self:initRightTopButtons()
  self.autoCloseMenu = params.autoCloseMenu == nil and true or params.autoCloseMenu
  if not params or params and not params.noBottomButton then
    self:initRightBottomButtons()
  else
    shieldLayer:setVisible(false)
  end
  self:initLeftDownButtons()
  self:listenEvents()
  self:openTouchSwallow()
  self:listenTimer(Timer:Always(0.2), function(...)
    self:updatePerHalfSecond()
  end)
end

local res = ed.ui.uires

function commonscene:getVitalityPromptText()
  ed.player:refreshVitality()
  local gap = res.sync_vitality_gap
  local lt = math.max(ed.playerlimit.maxVitality() - ed.player:getVitality() - 1, 0)
  local vnu = ed.player:getVitalityNextUpdate()
  local nextText = ed.gethmsNString(vnu)
  local totalText = ed.gethmsNString(gap * lt + vnu)
  local gapText = res.vit_gap .. T("\229\136\134\233\146\159")
  local prompt = T("\229\189\147\229\137\141\230\151\182\233\151\180: ") .. ed.serverTime2HMS() .. ed.getUTCLabel() .. "\n"
  prompt = prompt .. T("\229\183\178\228\185\176\228\189\147\229\138\155\230\172\161\230\149\176: %d/%d", ed.player:getVitalityBuyTimes(), ed.getDataTable("VIP")[ed.player:getvip()]["Buy Vit Max"])
  prompt = prompt .. "\n"
  local alignment = "left"
  if ed.playerlimit.maxVitality() <= ed.player:getVitality() then
    prompt = prompt .. T("\228\189\147\229\138\155\229\183\178\229\155\158\230\187\161")
  else
    prompt = prompt .. T("\228\184\139\231\130\185\228\189\147\229\138\155\230\129\162\229\164\141\239\188\154") .. nextText
    prompt = prompt .. "\n"
    prompt = prompt .. T("\230\129\162\229\164\141\229\133\168\233\131\168\228\189\147\229\138\155\239\188\154") .. totalText
    prompt = prompt .. "\n"
    prompt = prompt .. T("\230\129\162\229\164\141\230\151\182\233\151\180\233\151\180\233\154\148\239\188\154") .. gapText
  end
  if ed.player:getConsumeVitality() then
    prompt = prompt .. "\n"
    prompt = prompt .. T("\229\183\178\230\182\136\232\128\151\228\189\147\229\138\155\230\149\176\239\188\154") .. ed.player:getConsumeVitality()
  end
  if ed.player:getvip() >= 15 then
    prompt = prompt .. "\n"
    prompt = prompt .. T("\232\135\170\229\138\168\232\161\165\233\162\134\228\184\138\233\153\144\228\184\186500\231\130\185")
  end
  return prompt, alignment
end

function commonscene:destroyPromptCard()
  if not tolua.isnull(self.ppContainer) then
    self.ppContainer:removeFromParentAndCleanup(true)
    self.ppContainer = nil
  end
end

function commonscene:refreshVitalityPromptHandler()
  local count = 0
  
  local function handler(dt)
    if tolua.isnull(self.ppContainer) or tolua.isnull(self.vitPromptLabel) then
      self:removeUpdateHandler("refreshVitalityPrompt")
      return
    end
    count = count + dt
    if 1 < count then
      local prompt = self:getVitalityPromptText()
      ed.setString(self.vitPromptLabel, prompt)
      count = count - 1
    end
  end
  
  return handler
end

function commonscene:createPromptCard(text, alignment, bgsize)
  self:destroyPromptCard()
  local container = CCSprite:create()
  self.ppContainer = container
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 20, 160))
  bg:setAnchorPoint(ccp(0.5, 0.5))
  container:addChild(bg)
  local label = ed.createttf(text, 16)
  ed.setLabelColor(label, ed.toccc3(16776423))
  if alignment == "center" then
  else
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
  end
  bg:addChild(label)
  local size = label:getContentSize()
  if bgsize then
    bg:setContentSize(bgsize)
  else
    bg:setContentSize(CCSizeMake(size.width + 30, size.height + 28))
  end
  size = bg:getContentSize()
  label:setPosition(ccp(size.width / 2, size.height / 2 + 3))
  self.mainLayer:addChild(container, 999)
  ed.layout.layoutWithMagin(bg, {right = 30, top = 50})
  return label
end

function commonscene:createVitalityPrompt()
  local prompt, alignment = self:getVitalityPromptText()
  local label = self:createPromptCard(prompt, alignment)
  self:registerUpdateHandler("refreshVitalityPrompt", self:refreshVitalityPromptHandler())
  self.vitPromptLabel = label
end

function commonscene:initResourceBox()
  self.resourceBox = ed.ui.resourceBox.create(self)
  self.resourceBox:addTo(self.baseui.right_top_panel)
end

function commonscene:initRightTopButtons()
  if self.rightTopButtonLayout then
    self.rightTopButtonLayout:removeFromParentAndCleanup(true)
  end
  self.rightTopButtons = {}
  self.rightTopButtonLayout = CCLayer:create()
  self.baseui.right_top_panel:addChild(self.rightTopButtonLayout)
  self.rightTopButtonLayout:setContentSize(CCSizeMake(0, 0))
  local cfg = mainButtonCfg.getDefaultRightTopConfig(self.identity)
  for line, list in ipairs(cfg) do
    for index, v in ipairs(list) do
      self:addRightTopButton(v)
    end
  end
  self:layoutRightTopButton()
end

function commonscene:addRightTopButton(buttonType)
  local cfg = mainButtonCfg.getButtonConfig(buttonType)
  if not cfg then
    return false
  end
  if cfg.isOpen and not cfg.isOpen() then
    return false
  end
  local button = ed.ui.mainButton.create(self, cfg)
  table.insert(self.rightTopButtons, button)
  return true
end

function commonscene:layoutRightTopButton()
  local len = #self.rightTopButtons
  if len == 0 then
    return
  end
  self:removeAllButtonsFromParent(self.rightTopButtons)
  self:addAllButtonsToParent(self.rightTopButtons, self.rightTopButtonLayout)
  local cfg = mainButtonCfg.getDefaultRightTopConfig(self.identity)
  local lineTab = {}
  for i, v in ipairs(self.rightTopButtons) do
    for line, list in ipairs(cfg) do
      lineTab[line] = lineTab[line] or {}
      if ed.isElementInTable(v.config.type, list) then
        table.insert(lineTab[line], v)
        break
      end
    end
  end
  
  local function sortFunc(a, b)
    return a.config.sort < b.config.sort
  end
  
  for i, v in ipairs(lineTab) do
    table.sort(v, sortFunc)
  end
  local posY = 0
  for line, list in ipairs(lineTab) do
    local posX = 0
    local maxHeight = 0
    for i, v in ipairs(list) do
      maxHeight = math.max(maxHeight, v:getSize().height)
    end
    for i = #list, 1, -1 do
      local v = list[i]
      local size = v:getSize()
      v:setPosition(posX - size.width * 0.5, posY - maxHeight * 0.5)
      posX = posX - (size.width + 15)
    end
    posY = posY - (maxHeight + 15)
  end
  ed.layout.layoutWithMagin(self.rightTopButtonLayout, {right = 0, top = 50})
end

function commonscene:initLeftDownButtons()
  self.leftDownButtons = {}
  self.leftUpButtonLayout = CCLayer:create()
  self.baseui.left_bottom_panel:addChild(self.leftUpButtonLayout)
  local list = mainButtonCfg.getDefaultLeftDownBottomConfig(self.identity)
  for i, v in ipairs(list) do
    self:addLeftDownButton(v)
  end
  self:layoutLeftDownButton()
end

function commonscene:addLeftDownButton(buttonType)
  local cfg = mainButtonCfg.getLeftDownBottomButtonConfig(buttonType)
  if not cfg then
    return false
  end
  local button = ed.ui.mainButton.create(self, cfg)
  button.redTag:setPositionY(button.redTag:getPositionY() - 5)
  table.insert(self.leftDownButtons, button)
  return true
end

function commonscene:layoutLeftDownButton()
  local len = #self.leftDownButtons
  if len == 0 then
    return
  end
  table.sort(self.leftDownButtons, function(a, b)
    return a.config.sort < b.config.sort
  end)
  self:removeAllButtonsFromParent(self.leftDownButtons)
  self:addAllButtonsToParent(self.leftDownButtons, self.leftUpButtonLayout)
  local size = self.leftDownButtons[1]:getSize(0)
  local space = 15
  local totalWidth = len * (size.width + space)
  ed.layout.layoutChildrenWithSize(self.leftUpButtonLayout, CCSizeMake(totalWidth, size.height), ed.layoutType.Grid, {
    gridSize = CCSizeMake(size.width + space, size.height)
  })
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  self.leftUpButtonLayout:setPosition(23 - newWid + ed.display.getNotchHeight(), 78 - newHei)
end

function commonscene:initRightBottomButtons()
  self.rightBottomButtonOpened = true
  local root = self.baseui.right_bottom_panel
  root:removeAllChildrenWithCleanup(true)
  self.rightBottomButtons = {}
  self.righBottomButtonBg = ed.createScale9Sprite("UI/alpha/1080P/main/main_shortcut_board.png", CCRectMake(10, 10, 12, 12.5))
  self.righBottomButtonBg:setAnchorPoint(ccp(1, 0))
  root:addChild(self.righBottomButtonBg)
  self.righBottomMenu = ed.createSprite("UI/alpha/1080P/main/main_bj_button.png")
  local menuArrow = ed.createSprite("UI/alpha/1080P/main/main_img_button.png")
  menuArrow:setPosition(23, 32)
  self.menuArrow = menuArrow
  self.righBottomMenu:addChild(menuArrow)
  root:addChild(self.righBottomMenu, 1)
  local redTag = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  redTag:setVisible(false)
  root:addChild(redTag, 1)
  self.menuRedTag = redTag
  self:btRegisterButtonClick({
    button = self.righBottomMenu,
    key = "righBottomMenu",
    force = true,
    clickHandler = function()
      self:switchMenu(not self.rightBottomButtonOpened, true)
    end,
    pressScale = 0.95,
    priority = ed.ui.commonscene.TOUCH_PRIORITY
  })
  ed.layout.layoutWithMagin(self.righBottomMenu, {right = 0, bottom = 0})
  local x, y = self.righBottomMenu:getPosition()
  redTag:setPosition(x + 15, y + 25)
  self.righBottomButtonLayout = CCLayer:create()
  root:addChild(self.righBottomButtonLayout)
  local list = {
    ButtonType.TASK,
    ButtonType.BAG,
    ButtonType.HERO,
    ButtonType.FIRE_FORGE
  }
  self.rightBottomList = list
  self.rightBottomShowList = {}
  for i, v in ipairs(list) do
    local isShow = self:addRightBottomButton(v)
    if isShow then
      table.insert(self.rightBottomShowList, v)
    end
  end
  self:layoutRightBottomButton()
  for i, btn in ipairs(self.rightBottomButtons) do
    btn:setPrePos(btn:getPosition())
  end
  local menuSize = self.righBottomMenu:getContentSize()
  self.menuWidth = menuSize.width
  self.menuPos = self.righBottomButtonLayout:convertToNodeSpace(self.righBottomMenu:convertToWorldSpace(ccp(menuSize.width / 2 - 30, menuSize.height / 2)))
  self.buttonsBGSize = self.righBottomButtonBg:getContentSize()
  if self.autoCloseMenu then
    self:switchMenu(not self.rightBottomButtonOpened, false)
  end
end

function commonscene:getRightBottomButtonShow(buttonType)
  local cfg = mainButtonCfg.getButtonConfig(buttonType)
  if not cfg then
    return false
  end
  local isOpen = cfg.isOpen
  if isOpen ~= nil then
    if type(isOpen) == "function" then
      isOpen = isOpen()
    end
    if not isOpen then
      return false
    end
  end
  return true
end

function commonscene:addRightBottomButton(buttonType)
  local isOpen = self:getRightBottomButtonShow(buttonType)
  if not isOpen then
    return false
  end
  local cfg = mainButtonCfg.getButtonConfig(buttonType)
  local button = ed.ui.mainButton.create(self, cfg)
  table.insert(self.rightBottomButtons, button)
  return true
end

function commonscene:layoutRightBottomButton()
  local len = #self.rightBottomButtons
  if len == 0 then
    return
  end
  table.sort(self.rightBottomButtons, function(a, b)
    return a.config.sort < b.config.sort
  end)
  self:removeAllButtonsFromParent(self.rightBottomButtons)
  self:addAllButtonsToParent(self.rightBottomButtons, self.righBottomButtonLayout)
  local gridSize = self.rightBottomButtons[1]:getSize()
  gridSize.width = gridSize.width + 20
  gridSize.height = gridSize.height + 8
  local contentSize = CCSizeMake(len * gridSize.width, gridSize.height)
  ed.layout.layoutChildrenWithSize(self.righBottomButtonLayout, contentSize, ed.layoutType.Grid, {gridSize = gridSize})
  ed.layout.layoutWithMagin(self.righBottomButtonLayout, {right = 70, bottom = 0})
  contentSize.width = contentSize.width + 50
  local menuSize = self.righBottomMenu:getContentSize()
  contentSize.height = menuSize.height
  self.righBottomButtonBg:setContentSize(contentSize)
  local x, y = self.righBottomButtonLayout:getPosition()
  self.righBottomButtonBg:setPosition(x - 10 + contentSize.width, y)
end

function commonscene:updateMenuRedTag()
  local status = false
  if not self.rightBottomButtonOpened then
    for i, btn in ipairs(self.rightBottomButtons) do
      status = status or btn:getRedTagStatus()
    end
  end
  self.menuRedTag:setVisible(status)
end

function commonscene:checkRightBottomRefresh()
  local list = self.rightBottomList or {}
  local needRefresh = false
  for i, v in ipairs(list) do
    local isShow = self:getRightBottomButtonShow(v)
    if isShow and ed.isElementInTable(v, self.rightBottomShowList or {}) then
      needRefresh = true
      break
    end
  end
  if needRefresh then
    self:initRightBottomButtons()
  end
end

function commonscene:listenEvents()
  local scope = {}
  ListenEvent("ResourceNumChange", function(resType, id)
    self.resourceBox:updateResourceValue(resType, id)
  end, scope)
  ListenEvent("MainRedTagChange", function(buttonType)
    local btn = self:getButtonByType(buttonType)
    if btn then
      btn:updateRedTag()
      self:updateMenuRedTag()
    end
  end, scope)
  ListenEvent("MainRightTopActiveChange", function()
    self:initRightTopButtons()
  end, scope)
  ListenEvent("PlayerLevelUp", function()
    self:checkRightBottomRefresh()
  end, scope)
  self:registerOnEnterHandler("commonsceneOnEnter", function()
    self.resourceBox:updateAllResourceValue()
  end)
  self:registerOnPopSceneHandler("commonsceneOnPop", function()
    CloseScope(scope)
  end)
  self:btRegisterHandler({
    handler = function(event, x, y)
      local ret = self.touchSwallow and self.rightBottomButtonOpened
      if event == "ended" and ret and self.autoCloseMenu then
        self:switchMenu(not self.rightBottomButtonOpened, true)
      end
      return ret
    end,
    key = "commonsceneTouch_" .. self.identity,
    priority = ed.ui.commonscene.TOUCH_PRIORITY + 1
  })
end

function commonscene:openTouchSwallow()
  self.touchSwallow = true
  self:setMenuLayerOpacity(150)
end

function commonscene:closeTouchSwallow()
  self.touchSwallow = false
  self:setMenuLayerOpacity(0)
end

function commonscene:switchMenu(open, animate)
  self.rightBottomButtonOpened = open
  self.menuArrow:setRotation(open and 0 or 180)
  if open then
    ed.playEffect(ed.sound.common.popShortcut)
  else
    ed.playEffect(ed.sound.common.pushShortcut)
  end
  if animate then
    self:playMenuExtendAnimation()
  else
    if open then
      self:layoutRightBottomButton()
    else
      for i, btn in ipairs(self.rightBottomButtons) do
        btn:setPosition(self.menuPos.x, self.menuPos.y)
        btn:setVisible(false)
      end
      local contentSize = self.righBottomButtonBg:getContentSize()
      contentSize.width = self.menuWidth - 10
      self.righBottomButtonBg:setContentSize(contentSize)
    end
    FireEvent(ed.guide.eventNames.GUIDE_NODE_CHANGE, self.righBottomMenu)
  end
  self.baseui.shieldLayer:setVisible(open)
end

function commonscene:playMenuExtendAnimation()
  local open = self.rightBottomButtonOpened
  local opacitys = {255, 0}
  if open then
    opacitys[1], opacitys[2] = opacitys[2], opacitys[1]
  end
  local count = 1
  for i, btn in ipairs(self.rightBottomButtons) do
    local node = btn:getNode()
    node:setVisible(true)
    node:setOpacity(opacitys[1])
    node:stopAllActions()
    local move
    if open then
      move = CCEaseBackOut:create(CCMoveTo:create(0.2, btn:getPrePos()))
    else
      move = CCMoveTo:create(0.2, self.menuPos)
    end
    local spawn = CCSpawn:createWithTwoActions(move, CCFadeTo:create(0.2, opacitys[2]))
    node:runAction(CCSequence:create(ccArrayMake(spawn, CCCallFunc:create(function()
      node:setVisible(open)
      count = count + 1
      if count == #self.rightBottomButtons then
        self:removeUpdateHandler("playMenuExtendAnimation")
        if open then
          self.righBottomButtonBg:setContentSize(self.buttonsBGSize)
        else
          local contentSize = self.righBottomButtonBg:getContentSize()
          contentSize.width = self.menuWidth - 10
          self.righBottomButtonBg:setContentSize(contentSize)
        end
        self:updateMenuRedTag()
        FireEvent(ed.guide.eventNames.GUIDE_NODE_CHANGE, self.righBottomMenu)
      end
    end))))
  end
  local ox = self.rightBottomButtons[1]:getPosition()
  self:registerUpdateHandler("playMenuExtendAnimation", function()
    local x = self.rightBottomButtons[1]:getPosition()
    local speed = x - ox
    ox = x
    local contentSize = self.righBottomButtonBg:getContentSize()
    contentSize.width = math.max(contentSize.width - speed, self.menuWidth)
    self.righBottomButtonBg:setContentSize(contentSize)
  end)
end

function commonscene:addAllButtonsToParent(buttons, parent)
  for i, btn in ipairs(buttons) do
    btn:addTo(parent, true)
  end
end

function commonscene:removeAllButtonsFromParent(buttons)
  for i, btn in ipairs(buttons) do
    btn:remove(true)
  end
end

function commonscene:getButtonByType(buttonType)
  if not self.rightTopButtons or not self.rightBottomButtons then
    return
  end
  for i, btn in ipairs(self.rightTopButtons) do
    if buttonType == btn.config.type then
      return btn
    end
  end
  for i, btn in ipairs(self.rightBottomButtons) do
    if buttonType == btn.config.type then
      return btn
    end
  end
  for i, btn in ipairs(self.leftDownButtons) do
    if buttonType == btn.config.type then
      return btn
    end
  end
  return nil
end

function commonscene:setMenuLayerOpacity(o)
  self.baseui.shieldLayer:setOpacity(o)
end

function commonscene:updatePerHalfSecond()
  if nil ~= self.rightTopButtons then
    for i, v in ipairs(self.rightTopButtons) do
      if nil ~= v.updatePerHalfSecond then
        v:updatePerHalfSecond()
      end
    end
  end
end

function commonscene:getGuideNode(nodeKey)
  local btn = self:getButtonByType(ButtonType[nodeKey])
  if btn then
    return btn.node
  end
  return base.getGuideNode(self, nodeKey)
end

function commonscene:getGuideRelatedNode(nodeKey)
  return self:getButtonByType(ButtonType[nodeKey]) and self.righBottomMenu or nil
end
