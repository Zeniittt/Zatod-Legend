local KingsPvpChatSelectionWrap = newclass()
ed.ui.KingsPvpChatSelectionWrap = KingsPvpChatSelectionWrap
local ChatContentType = {None = 0, Sticker = 1}
local SendChatCD = 5

function KingsPvpChatSelectionWrap.create(params)
  local self = {}
  setmetatable(self, KingsPvpChatSelectionWrap.mt)
  self:init(params)
  return self
end

function KingsPvpChatSelectionWrap:init(params)
  self.uiDelegate = params.ui
  self.doSendFunc = params.sendFunc
  self.onFocusFunc = params.focusFunc
  self.chatContentSelectionType = nil
  self.lastSendChatTime = 0
  self.stickerInfoList = ed.chatManager:getStickerInfoList()
  self.stickerTableview = nil
  self.eventScope = {}
  self.uiDelegate.image_chat_sticker_bg:setVisible(false)
  self.uiDelegate.image_chat_sticker_bg:registerScriptHandler(function(event)
    xpcall(function()
      if event == "exit" then
        CloseScope(self.eventScope)
      end
    end, EDDebug)
  end)
  self:bindTouchEvent(params.touchListener)
  self:setChatContentSelection(ChatContentType.None)
end

function KingsPvpChatSelectionWrap:bindTouchEvent(listener)
  listener:btRegisterButtonClick({
    button = self.uiDelegate.btn_chat_sticker,
    key = "btn_chat_sticker",
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      self:setChatContentSelection(ChatContentType.Sticker)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1,
    pressScale = 0.75
  })
  listener:btRegisterOutClick({
    area = self.uiDelegate.image_chat_sticker_bg,
    key = "out_sticker_bg",
    clickHandler = function()
      if self.chatContentSelectionType == ChatContentType.Sticker then
        self:setChatContentSelection(ChatContentType.None)
      end
    end,
    clickInterval = 0.5
  })
end

function KingsPvpChatSelectionWrap:setChatContentSelection(type)
  if self.chatContentSelectionType == type then
    return
  end
  self.chatContentSelectionType = type
  CloseTimer("update_chat_content_size")
  CloseTimer("update_chat_content_alpha")
  if ChatContentType.Sticker == self.chatContentSelectionType then
    self.uiDelegate.btn_chat_sticker:setVisible(false)
    self.uiDelegate.image_chat_sticker_selected:setVisible(true)
    self.uiDelegate.image_chat_sticker_bg:setVisible(true)
    self.uiDelegate.image_chat_sticker_selected:setScale(0.75)
    self.uiDelegate.image_chat_sticker_selected:stopAllActions()
    self.uiDelegate.image_chat_sticker_selected:runAction(CCEaseOut:create(CCScaleTo:create(0.16667, 1), 2))
    self:showStickerList()
  else
    self.uiDelegate.btn_chat_sticker:setVisible(true)
    self.uiDelegate.btn_chat_sticker:setScale(1)
    self.uiDelegate.image_chat_sticker_selected:setVisible(false)
    if self.uiDelegate.image_chat_sticker_bg:isVisible() then
      self:hideStickerList()
    end
  end
  if nil ~= self.onFocusFunc then
    self.onFocusFunc(ChatContentType.None ~= self.chatContentSelectionType)
  end
end

function KingsPvpChatSelectionWrap:hideStickerList()
  local function alphaFunc()
    if self.stickerTableview then
      local usedCells = self.stickerTableview:getUsedCell()
      
      if 0 < #usedCells then
        local opacity = self.uiDelegate.image_chat_sticker_bg:getOpacity()
        for i, v in ipairs(usedCells) do
          if opacity < v.node:getOpacity() then
            v.node:setOpacity(opacity)
          end
        end
      end
    end
  end
  
  self.uiDelegate.image_chat_sticker_bg:stopAllActions()
  self.uiDelegate.image_chat_sticker_bg:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.125), CCCallFunc:create(function()
    CloseTimer("update_chat_content_alpha")
    self.uiDelegate.image_chat_sticker_bg:setVisible(false)
  end)))
  ListenTimer(Timer:Always(0.01, "update_chat_content_alpha"), alphaFunc, self.eventScope)
  alphaFunc()
end

function KingsPvpChatSelectionWrap:showStickerList()
  if nil == self.stickerTableview then
    local delegate = {}
    
    function delegate.numberOfCells()
      return #self.stickerInfoList
    end
    
    function delegate.cellSizeFromIndex(idx)
      return CCSizeMake(58, 58)
    end
    
    function delegate.createCell(idx)
      return self:createStickerItem(idx)
    end
    
    function delegate.doClickIn(cell)
      if self.uiDelegate.image_chat_sticker_bg:isVisible() then
        local idx = cell.idx
        self:onStickerItemEvent(idx)
      end
    end
    
    local contentSize = self.uiDelegate.panel_sticker:getContentSize()
    local param = {
      delegate = delegate,
      container = self.uiDelegate.panel_sticker,
      cliprect = CCRectMake(0, 0, contentSize.width, contentSize.height),
      dragMode = 1,
      colNum = 3,
      touchpriority = -300
    }
    self.stickerTableview = Tableview.create(param)
    self.stickerTableview:reloadData()
  else
    self.stickerTableview:reloadData()
  end
  if nil == self.chatContentDelegateNode then
    self.chatContentDelegateNode = CCNode:create()
    self.uiDelegate.image_chat_selection_bg:addChild(self.chatContentDelegateNode)
  end
  self.chatContentDelegateNode:stopAllActions()
  self.chatContentDelegateNode:setScale(0.4)
  local bigScaleAction = CCScaleTo:create(0.125, 1.03)
  local normalScaleAction = CCEaseOut:create(CCScaleTo:create(0.25, 1), 2)
  local contentEndFunc = CCCallFunc:create(function(...)
    CloseTimer("update_chat_content_size")
  end)
  self.chatContentDelegateNode:runAction(CCSequence:create(ccArrayMake(bigScaleAction, normalScaleAction, contentEndFunc)))
  self.uiDelegate.image_chat_sticker_bg:stopAllActions()
  self.uiDelegate.image_chat_sticker_bg:setOpacity(0)
  self.uiDelegate.image_chat_sticker_bg:runAction(CCFadeIn:create(0.125))
  local usedCells = self.stickerTableview:getUsedCell()
  if 0 < #usedCells then
    local node = usedCells[1].node
    node:stopAllActions()
    node:setOpacity(0)
    node:setCascadeOpacityEnabled(true)
    local delayAction = CCDelayTime:create(0.124)
    local showAction = CCFadeTo:create(0.01, 102)
    local fadeAction = CCFadeTo:create(0.25, 255)
    node:runAction(CCSequence:create(ccArrayMake(delayAction, showAction, fadeAction)))
  end
  ListenTimer(Timer:Always(0.01, "update_chat_content_size"), function()
    self:updateChatContentSize()
  end, self.eventScope)
  self:updateChatContentSize()
end

function KingsPvpChatSelectionWrap:updateChatContentSize()
  if nil == self.chatContentDelegateNode or tolua.isnull(self.chatContentDelegateNode) then
    return
  end
  local bgOriginHeight = 220
  local panelOriginHeight = 203
  local heightScale = self.chatContentDelegateNode:getScale()
  local bgSize = self.uiDelegate.image_chat_sticker_bg:getContentSize()
  bgSize.height = bgOriginHeight * heightScale
  self.uiDelegate.image_chat_sticker_bg:setContentSize(bgSize)
  local panelSize = self.uiDelegate.panel_sticker:getContentSize()
  panelSize.height = panelOriginHeight * heightScale
  self.stickerTableview:getDragList():setClipRect(CCRectMake(0, 0, panelSize.width, panelSize.height))
  local listHeight = self.stickerTableview:getDragList():getListHeight()
  self.stickerTableview:getDragList():getList():setPositionY(panelOriginHeight + (panelSize.height - panelOriginHeight))
  local usedCells = self.stickerTableview:getUsedCell()
  if 0 < #usedCells then
    local opacity = usedCells[1].node:getOpacity()
    for i, v in ipairs(usedCells) do
      v.node:setOpacity(opacity)
    end
  end
end

function KingsPvpChatSelectionWrap:onStickerItemEvent(index)
  if index < 1 or index > #self.stickerInfoList then
    return
  end
  local now = ed.getServerTime()
  local cd = SendChatCD - (now - self.lastSendChatTime)
  if 0 <= cd then
    ed.showToast(T("\229\143\145\232\168\128\233\162\145\231\142\135\232\191\135\233\171\152\239\188\140\232\175\183%d\231\167\146\229\144\142\229\134\141\232\175\149\227\128\130", cd + 1))
    return
  end
  self.lastSendChatTime = now
  local stickerData = self.stickerInfoList[index]
  local content = string.format("<sticker|%s|0.8>", stickerData.id)
  self:setChatContentSelection(ChatContentType.None)
  if nil ~= self.doSendFunc then
    self.doSendFunc(content)
  end
end

function KingsPvpChatSelectionWrap:createStickerItem(index)
  if index < 1 or index > #self.stickerInfoList then
    return
  end
  local stickerData = self.stickerInfoList[index]
  local stickerSprite = ed.createSprite(stickerData.res)
  stickerSprite:setScale(0.75)
  return stickerSprite
end

function KingsPvpChatSelectionWrap.createChatContent(parent, worldPos, content, isFlip, scale)
  if nil == scale then
    scale = 1
  end
  local rootNode = CCSprite:create()
  parent:addChild(rootNode)
  local chatBg = ed.createScale9Sprite("UI/alpha/1080P/newkingspvp/chat/chat_bg.png", CCRectMake(45, 0, 5, 1))
  rootNode:addChild(chatBg)
  local chatPos = parent:convertToNodeSpace(worldPos)
  chatBg:setScaleX(isFlip and -1 or 1)
  chatBg:setAnchorPoint(ccp(0, 0.5))
  chatBg:setPosition(ccp(0, 0))
  local bgSize = chatBg:getContentSize()
  local text = newRichText:new()
  text:setMaxWidth(400 / ed.display.scaleFactor)
  text:setString(content, nil)
  text:setHorizontalCenter()
  text:setVerticalCenter()
  local textRootNode = text:getRootNode()
  rootNode:addChild(textRootNode)
  local width, height = text:getSize()
  bgSize.width = math.max(104, width + 15)
  chatBg:setContentSize(bgSize)
  text:setPosition(ccp((bgSize.width * 0.5 + 3) * (isFlip and -1 or 1), 3))
  ed.setCascadeOpacityEnabled(rootNode, true, true)
  rootNode:setPosition(ccp(chatPos.x + 10, chatPos.y + 6))
  rootNode:setRotation(15 * (isFlip and 1 or -1))
  rootNode:setScale(0.8 * scale)
  local rootMoveAction1 = CCEaseOut:create(CCMoveTo:create(0.125, ccp(chatPos.x - 1.5, chatPos.y + 1)), 2)
  local rootMoveAction2 = CCEaseOut:create(CCMoveTo:create(0.29, chatPos), 2)
  local rootRotateAction1 = CCEaseOut:create(CCRotateTo:create(0.29, -2 * (isFlip and 1 or -1)), 3)
  local rootRotateAction2 = CCEaseOut:create(CCRotateTo:create(0.125, 0), 3)
  local rootScaleAction = CCEaseOut:create(CCScaleTo:create(0.125, 1 * scale), 3)
  local rootShowAction1 = CCSpawn:create(ccArrayMake(rootMoveAction1, rootRotateAction1, rootScaleAction))
  local rootShowAction2 = CCSpawn:create(ccArrayMake(rootMoveAction2, rootRotateAction2))
  local rootCloseDelayAction = CCDelayTime:create(4.5)
  local rootFadeAction = CCEaseOut:create(CCFadeOut:create(0.3333), 3)
  local rootCloseFunc = CCCallFunc:create(function()
    rootNode:removeFromParentAndCleanup(true)
  end)
  rootNode:runAction(CCSequence:create(ccArrayMake(rootShowAction1, rootShowAction2, rootCloseDelayAction, rootFadeAction, rootCloseFunc)))
  textRootNode:setScale(0)
  local txtShowDelayAction = CCDelayTime:create(0.0833)
  local txtShowFunc = CCCallFunc:create(function(...)
    textRootNode:setScale(0.44)
  end)
  local txtScaleAction1 = CCScaleTo:create(0.125, 1.25)
  local txtScaleAction2 = CCEaseOut:create(CCScaleTo:create(0.29, 1), 3)
  local txtAction = CCSequence:create(ccArrayMake(txtShowDelayAction, txtShowFunc, txtScaleAction1, txtScaleAction2))
  textRootNode:runAction(txtAction)
end
