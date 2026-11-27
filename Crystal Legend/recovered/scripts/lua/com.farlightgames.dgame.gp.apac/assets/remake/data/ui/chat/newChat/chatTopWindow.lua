local chatTopWindow = {}
chatTopWindow.__index = chatTopWindow
ed.ui.chatTopWindow = chatTopWindow

function chatTopWindow:noticePrivateHandler(data)
  if data._channel == "personal_channel" and not ed.isOpenChat then
    local topWindowLayer, self_ui, y = self:openTopWindow(data._channel, data._contents)
    local height = self_ui.tpBg:getContentSize().height
    self:startMoveAction(height, self_ui.tpBg, topWindowLayer)
  end
end

function chatTopWindow:getCurrentScene()
  return CCDirector:sharedDirector():getRunningScene()
end

function chatTopWindow:openTopWindow(channel, content)
  local scene = ed.getCurrentScene()
  local currentScene = self:getCurrentScene()
  if scene and scene.identity == "battle" then
    currentScene = ed.sceneui.ui_layer
  end
  local topWindowLayer = CCLayer:create()
  local x, y = currentScene:getContentSize().width / 2, currentScene:getContentSize().height
  local self_ui = {}
  if channel == "personal_channel" then
    if tolua.isnull(self_ui.tpBg) then
      local container, ui = ed.editorui(ed.uieditor.chatTopWin)
      container:setContentSize(ui.tpBg:getContentSize())
      self_ui = ui
      topWindowLayer:addChild(container)
      container:setPosition(ccp(x, y))
      currentScene:addChild(topWindowLayer, 2000)
      local clipSize = self_ui.clipLayer:getContentSize()
      self_ui.clipLayer:setClipRect(CCRectMake(0, 0, clipSize.width, clipSize.height))
      ed.adaptLabel(ui.Label_168, {maxWidth = 80, minScale = 0.7})
    end
    local str = content._content or ""
    if string.find(str, "<link|real_arena") then
      local ruleType, roomId = string.match(str, "<link|real_arena|(%w+)|(%d*)>")
      str = string.gsub(str, "<link|real_arena|([^>]+)>", string.format(T("<text|chat_content|\232\175\184\231\142\139\228\186\137\233\156\184\239\188\154\233\130\128\232\175\183\229\138\160\229\133\165\230\136\191\233\151\180\239\188\154%s>"), roomId))
    end
    if string.find(str, "<sticker|") then
      local stickerId, scale = string.match(str, "<sticker|(%d*)|(%d*)>")
      local row = ed.getDataTable("Sticker")[tonumber(stickerId)]
      if row then
        str = string.gsub(str, "<sticker|([^>]+)>", string.format("<text|chat_content|%s>", T("\227\128\144\232\161\168\230\131\133\229\140\133\239\188\154%s\227\128\145", row.Tag)))
      end
    end
    str = string.gsub(str, "<text|chat_content|", "<text|chat_private_top_content|")
    local name = string.format("<text|chat_private_top_name|%s>", content._speaker_summary._name or "")
    str = name .. T("<text|chat_private_top_content| \229\175\185\228\189\160\232\175\180\239\188\154>") .. str
    local richTextContent = richText:new()
    richTextContent:setString(str)
    self_ui.clipLayer:addChild(richTextContent.rootNode)
    ed.layout.centerYInParent(richTextContent.rootNode)
  end
  return topWindowLayer, self_ui, y
end

function chatTopWindow:startMoveAction(height, layer, topWindowLayer)
  local topToBottomAction = CCMoveBy:create(1, ccp(0, -height))
  local delayAction = CCDelayTime:create(2)
  local bottomToTopAction = CCMoveBy:create(1, ccp(0, height))
  local endCallBack = CCCallFunc:create(function()
    if not tolua.isnull(topWindowLayer) then
      topWindowLayer:removeFromParentAndCleanup(true)
      topWindowLayer = nil
    end
  end)
  layer:runAction(CCSequence:create(ccArrayMake(topToBottomAction, delayAction, bottomToTopAction, endCallBack)))
end
