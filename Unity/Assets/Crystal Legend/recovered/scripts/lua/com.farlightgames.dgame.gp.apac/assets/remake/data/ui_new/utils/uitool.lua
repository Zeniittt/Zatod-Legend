local UITool = {}
ed.UITool = UITool

function UITool.createDraglist(container, params, controller)
  params = params or {}
  local size = container:getContentSize()
  local width = params.width or size.width
  local height = params.height or size.height
  local info = {
    cliprect = CCRectMake(0, 0, width, height),
    container = container,
    noshade = true,
    zorder = 10,
    priority = -301
  }
  for k, v in pairs(params) do
    info[k] = v
  end
  local draglist = ed.draglist.create(info)
  if controller and info.message == false then
    controller:btRegisterHandler({
      handler = draglist:doMainLayerTouch(),
      key = tostring(container),
      priority = info.priority
    })
  end
  return draglist
end

function UITool.createTableView(params, controller)
  params = params or {}
  local tblView = Tableview.create(params)
  if controller and params.message == false then
    controller:btRegisterHandler({
      handler = tblView.dragList:doMainLayerTouch(),
      key = tostring(params.container),
      priority = params.priority
    })
  end
  return tblView
end

function UITool:registerBtn(key, func, params)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function UITool.showRewardsFromServer(rewards, title, closedHandler, beforeCreateBgHandler)
  local r = {}
  for _, reward in ipairs(rewards) do
    table.insert(r, {
      type = reward._type,
      id = reward._id,
      amount = reward._amount
    })
  end
  ed.announce({
    type = "getProp",
    param = {
      title = title or T("\228\189\160\232\142\183\229\190\151\228\186\134\228\187\165\228\184\139\229\165\150\229\138\177"),
      items = r,
      closeWhenClickOut = true,
      closedHandler = closedHandler,
      beforeCreateBgHandler = beforeCreateBgHandler
    }
  })
end

function UITool.createTouchLayer(touchPriority)
  touchPriority = touchPriority or -99
  local layer = CCLayer:create()
  layer:setTouchEnabled(true)
  local touchNode = ed.ui.basetouchnode.btCreate()
  local touchHandler = touchNode:btGetMainTouchHandler()
  layer:registerScriptTouchHandler(touchHandler, false, touchPriority, false)
  return layer, touchNode
end

function UITool.getBreathAction(time)
  local fo = CCFadeOut:create(time)
  local fi = CCFadeIn:create(time)
  return CCRepeatForever:create(CCSequence:createWithTwoActions(fo, fi))
end

function UITool.getBreathActionByOpacity(time, oriOpacity, dstOpacity)
  local fo = CCFadeTo:create(time, dstOpacity)
  local fi = CCFadeTo:create(time, oriOpacity)
  return CCRepeatForever:create(CCSequence:createWithTwoActions(fo, fi))
end

function UITool.getBreathScaleAction(time)
  local fo = CCScaleTo:create(time, 0.98)
  local fi = CCScaleTo:create(time, 1)
  return CCRepeatForever:create(CCSequence:createWithTwoActions(fo, fi))
end

function UITool.getRefreshAction()
  local larger = CCScaleTo:create(0.2, 1.5)
  local reverse = CCScaleTo:create(0.2, 1)
  return CCSequence:createWithTwoActions(larger, reverse)
end

local openCallbacks = {}
ed.openCallbacks = openCallbacks

function UITool.registViewOpenFunc(identity, openFunc)
  if openCallbacks[identity] then
    return
  end
  openCallbacks[identity] = openFunc
end

function UITool.openView(identity, params)
  if not openCallbacks[identity] then
    print(identity .. " not regist in openCallbacks!")
    return
  end
  return openCallbacks[identity](params)
end

local openViewQueue = {}

function UITool.setOpenViewQueue(identityTable)
  openViewQueue = identityTable
end

function UITool.getSeqOfActions(actions)
  return CCSequence:create(ccArrayMake(unpack(actions)))
end

function UITool.replaceUI(ui, parent, to, from)
  local x, y = ui[to]:getPosition()
  local z = ui[to]:getZOrder()
  ui[to]:removeFromParentAndCleanup(true)
  from:setPosition(ccp(x, y))
  ui[parent]:addChild(from, z)
  ui[to] = from
end

function UITool.replaceUINew(ui, to, from)
  local parent = ui[to]:getParent()
  local x, y = ui[to]:getPosition()
  local zOrder = ui[to]:getZOrder()
  ui[to]:removeFromParentAndCleanup(true)
  from:setPosition(ccp(x, y))
  from:setZOrder(zOrder)
  parent:addChild(from)
  ui[to] = from
end

function UITool.setPositionBy(node, pos)
  if not node then
    return
  end
  node:setPosition(ccpAdd(ccp(node:getPosition()), pos))
end

function UITool.setContentSizeBy(node, width, height, updatePos)
  if not node then
    return
  end
  local size = node:getContentSize()
  size.width = size.width + width
  size.height = size.height + height
  node:setContentSize(size)
  if updatePos then
    local anchor = node:getAnchorPoint()
    ed.UITool.setPositionBy(node, ccp(anchor.x * width, anchor.y * height))
  end
end

function UITool.checkStrVaildity(str, length, errorInfo)
  local name = string.gsub(str, "[\r\n]", "")
  local _, count = string.gsub(name, "[^\128-\193]", "")
  if length < count then
    ed.showToast(errorInfo)
    return false
  end
  if ed.dirtyword_check(name) then
    ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
    return false
  end
  return true
end

function UITool.createProcessBar(res, parentUI, ccRect)
  local size = parentUI:getContentSize()
  local clippingNode = ed.createClippingNodeOnly(res, 0.5)
  clippingNode:setPosition(ccp(0.5, size.height / 2))
  local stencil = clippingNode:getStencil()
  stencil:setAnchorPoint(ccp(0, 0.5))
  local barScale = size.width / stencil:getContentSize().width
  stencil:setScaleX(barScale)
  local sprite = ed.createSprite()
  local bar = ed.createScale9Sprite(res, ccRect)
  bar:setContentSize(size)
  bar:setAnchorPoint(ccp(0, 0.5))
  sprite:addChild(bar)
  clippingNode:addChild(sprite)
  parentUI:addChild(clippingNode)
  return sprite
end

function UITool.createItemMask(ui)
  local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
  mask:setPosition(ccp(45, 45))
  local selectIcon = ed.createSprite("UI/alpha/1080P/common/tick.png")
  selectIcon:setScale(1.6)
  selectIcon:setPosition(ccp(45, 45))
  mask:addChild(selectIcon)
  mask:setZOrder(1)
  ui:addChild(mask)
  return mask
end

function UITool.createHeroMask(ui)
  local mask = CCLayerColor:create(ccc4(0, 0, 0, 150))
  mask:setPosition(ccp(-3, -3))
  mask:setContentSize(CCSizeMake(76, 75))
  local selectIcon = ed.createSprite("UI/alpha/1080P/common/tick.png")
  selectIcon:setScale(1.6)
  selectIcon:setPosition(ccp(33, 33))
  mask:addChild(selectIcon)
  mask:setZOrder(1)
  ui:addChild(mask)
  return mask
end

function UITool.createEditBox(parent, config, dealMessage)
  local size = parent:getContentSize()
  local layer = CCLayer:create()
  layer:setContentSize(size)
  layer:setClipRect(CCRectMake(0, 0, size.width - 15, size.height))
  parent:addChild(layer)
  local info = {
    config = {
      editSize = size,
      maxLength = 30,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18
    },
    bDealMessage = dealMessage
  }
  for k, v in pairs(config or {}) do
    info.config[k] = v
  end
  local editBox = editBox:new(info)
  editBox:setEnabled(true)
  editBox.edit:setAnchorPoint(ccp(0, 0))
  editBox.edit:setPosition(ccp(8, 0))
  layer:addChild(editBox.edit)
  local placeHolder = config.placeHolder or T("\232\175\183\232\190\147\229\133\165:")
  editBox:setPlaceHolder(placeHolder)
  return editBox
end

function UITool.createSceneTitle(title, parent, param)
  param = param or {}
  local position = param.position or ccp(0, 0)
  local z = param.z or 0
  local anchor = param.anchor or ccp(0, 0.5)
  local maxWidth = param.maxWidth or 9999
  local text = ed.createttf(title, 29)
  text:setColor(ed.toccc3(16711642))
  text:setStroke(ed.toccc3(13794820), 1)
  text:setFontName(ed.fontBold)
  text:limitWidthByScale(maxWidth)
  local textSize = text:getContentSize()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/title_light.png", CCRectMake(16.5, 18, 16.5, 18))
  bg:setContentSize(CCSizeMake(textSize.width * text:getScale() + 30, 53))
  bg:addChild(text)
  bg:setAnchorPoint(anchor)
  ed.layout.centerInParent(text)
  bg:setPosition(position)
  bg:setZOrder(z)
  if parent then
    parent:addChild(bg)
  end
  return bg, text
end

function ReloadModule(name)
  if EDFLAGWIN32 then
    package.loaded[name] = nil
    print("ReloadModule: ", name)
    require(name)
  end
end

function UITool.ReloadUIFile()
  ed.popScene()
  ed.pushScene(ed.ui.AutoChessTestUI.create())
end
