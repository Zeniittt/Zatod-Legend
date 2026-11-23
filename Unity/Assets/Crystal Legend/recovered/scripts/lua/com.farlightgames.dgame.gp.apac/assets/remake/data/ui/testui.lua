module("ed", package.seeall)
PopwindowUi = {}
PopwindowUi.__index = PopwindowUi
local base = ed.ui.popwindow
setmetatable(PopwindowUi, base.mt)
local testui_window

function PopwindowUi.openui(target, param)
  local window = base.create(target or "popwindowui", param)
  setmetatable(window, PopwindowUi)
  window.what = target
  window.param = param
  window:initPanel(target)
  param = param or {}
  local z = param.zOlder or 300
  window:popWindow(z)
  if param == nil or not param.noShow then
    window:show()
  end
  testui_window = window
  return window
end

ed.openui = PopwindowUi.openui

function PopwindowUi:initPanel(target)
  local file = ed.uieditor[target]
  if not file then
    EDLog("xxxxxxx ed.openui() File Not Exist: " .. target)
    return
  end
  local container, ui = ed.editorui(ed.uieditor[target])
  self.container = container
  self.ui = ui
  self.mainLayer:addChild(container)
  self.fca = {}
  self:registerTouchHandler()
end

function PopwindowUi.createui(target, param)
  local window = {}
  setmetatable(window, PopwindowUi)
  window.what = target
  window.param = param
  window.mainLayer = param.mainLayer
  window.touch_node = param.touch_node
  local container, ui = ed.editorui(ed.uieditor[target])
  window.container = container
  window.ui = ui
  window.mainLayer:addChild(container, param.zOrder or 0)
  return window
end

ed.createui = PopwindowUi.createui

function PopwindowUi:registerTouchHandler()
  if self.param and self.param.forbidTouch then
    return
  end
  local priority = -130
  if self.param and self.param.priority then
    priority = self.param.priority
  end
  if self.param and self.param.touchPriority then
    priority = self.param.touchPriority
  end
  local touch_node = ed.ui.basetouchnode.btCreate()
  self.container:setTouchEnabled(true)
  self.container:registerScriptTouchHandler(touch_node:btGetMainTouchHandler(), false, priority, true)
  self.touch_node = touch_node
end

function PopwindowUi:registerOutofRectTouchHandler(rect, callback)
  if self.param and self.param.forbidTouch then
    return
  end
  local touch_node = self.touch_node
  local rc = self.mainLayer:getContentSize()
  touch_node:btRegisterRectClick({
    rect = ed.DGRectMake(0, 0, rc.width * 2, rc.height * 2),
    parent = self.mainLayer,
    clickHandler = function(x, y)
      if not rect:containsPoint(ccp(x, y)) then
        if callback then
          callback(x, y)
        else
          self:close()
        end
      end
    end,
    force = true
  })
end

function PopwindowUi:registerInRectTouchHandler(rect, callback)
  if self.param and self.param.forbidTouch then
    return
  end
  local touch_node = self.touch_node
  local rc = self.mainLayer:getContentSize()
  touch_node:btRegisterRectClick({
    rect = ed.DGRectMake(0, 0, rc.width * 2, rc.height * 2),
    parent = self.mainLayer,
    clickHandler = function(x, y)
      if rect:containsPoint(ccp(x, y)) then
        if callback then
          callback(x, y)
        else
          self:close()
        end
      end
    end,
    force = true
  })
end

local soundEfffect = ed.sound.deo.common_click_feedback

function PopwindowUi:registerBtn(name, callback, params)
  local ui = self.ui
  local touch_node = self.touch_node
  if not self.ui[name] then
    EDLog("xxxxxxx PopwindowUi:registerBtn UI Not Exist: " .. name)
    return
  end
  params = params or {}
  local clickInterval = params and params.clickInterval
  touch_node:btRegisterButtonClick({
    button = ui[name],
    press = ui[name .. "_press"],
    key = name,
    clickHandler = function()
      if callback then
        ed.playEffect(soundEfffect)
        callback()
      else
        self:close()
      end
    end,
    force = true,
    mcpMode = true,
    clickInterval = clickInterval,
    priority = params.priority or 0
  })
end

function PopwindowUi:registerScaleBtn(name, scale, callback, params)
  local ui = self.ui
  local touch_node = self.touch_node
  if not ui[name] then
    EDLog("xxxxxxx PopwindowUi:registerScaleBtn UI Not Exist: " .. name)
    return
  end
  params = params or {}
  local clickInterval = params and params.clickInterval
  local oriScale = ui[name]:getScale()
  touch_node:btRegisterButtonClick({
    button = ui[name],
    pressScale = oriScale * scale,
    normalScale = oriScale,
    key = name,
    clickHandler = function()
      if callback then
        ed.playEffect(soundEfffect)
        callback()
      else
        self:close()
      end
    end,
    force = true,
    mcpMode = true,
    clickInterval = clickInterval
  })
end

function PopwindowUi:registerCustomTouchBtn(param)
  local touch_node = self.touch_node
  touch_node:btRegisterButtonClick(param)
end

function PopwindowUi:setBtnLabel(name, text, fontParam)
  self:registerLabel(name .. "_label", text, fontParam)
end

function PopwindowUi:registerLabel(name, text, fontParam)
  local label = self.ui[name]
  if not label then
    EDLog("xxxxxxx PopwindowUi:registerLabel UI Not Exist: " .. name)
    return
  end
  ed.setString(label, text)
  if not fontParam then
    return
  end
  if fontParam.font then
    ed.setLabelFontInfo(label, fontParam.font)
  elseif fontParam.color then
    ed.setLabelColor(label, fontParam.color)
  end
  if fontParam.dimensions then
    label:setDimensions(fontParam.dimensions)
  end
end

function PopwindowUi:registerImage(name, path, param)
  local image = self.ui[name]
  if not image then
    EDLog("xxxxxxx PopwindowUi:registerImage UI Not Exist: " .. name)
    return
  end
  ed.setTexture(image, path)
  if not param then
    return
  end
  if param.scale then
    image:setScale(param.scale)
  end
end

function PopwindowUi:replaceImage(name, path, param)
  local image = self.ui[name]
  if not image then
    EDLog("xxxxxxx PopwindowUi:registerImage UI Not Exist: " .. name)
    return
  end
  local x, y = image:getPosition()
  local anchor = image:getAnchorPoint()
  local parent = image:getParent()
  local scaleX = image:getScaleX()
  local scaleY = image:getScaleY()
  local zOlder = image:getZOrder()
  image:removeFromParentAndCleanup(true)
  image = ed.createSprite(path)
  if not image then
    EDLog("xxxxxxx PopwindowUi:replaceImage NewUI Not Exist: " .. path)
    return
  end
  self.ui[name] = image
  if parent then
    parent:addChild(image)
  end
  image:setPosition(ccp(x, y))
  image:setAnchorPoint(anchor)
  image:setScaleX(scaleX)
  image:setScaleY(scaleY)
  image:setZOrder(zOlder)
  if not param then
    return
  end
  if param.scale then
    image:setScale(param.scale)
  end
  if param.scaleX then
    image:setScaleX(param.scaleX)
  end
  if param.scaleY then
    image:setScaleY(param.scaleY)
  end
end

function PopwindowUi:useEquipImage(name, equipId)
  local image = self.ui[name]
  if not image then
    EDLog("xxxxxxx PopwindowUi:useEquipImage UI Not Exist: " .. name)
    return
  end
  local bg, icon = ed.readequip.createIcon(equipId)
  image:removeAllChildrenWithCleanup(true)
  image:addChild(bg)
  bg:setAnchorPoint(ccp(0.1, 0.1))
end

function PopwindowUi:registerDraglist(name, param)
  local item = self.ui[name]
  if not item then
    EDLog("xxxxxxx PopwindowUi:registerDraglist UI Not Exist: " .. name)
    return
  end
  self.draglist = self.draglist or {}
  local list = self.draglist
  if list.node then
    EDLog("xxxxxxx PopwindowUi:registerDraglist list is Exist: " .. name)
    return
  end
  param = param or {}
  local offsetX = param.offsetX or 0
  local offsetY = param.offsetY or 0
  local size = item:getContentSize()
  local x, y = item:getPosition()
  local info = param
  info.container = param.container or self.container
  info.cliprect = CCRectMake(x + offsetX, y + offsetY, size.width, size.height)
  info.position = ccp(x, y)
  info.priority = info.priority or -250
  if info.usebar then
    info.bar = {
      bglen = size.height * 0.9,
      bgpos = ccp(x + offsetX - 2, y + size.height / 2)
    }
  end
  local node = ed.draglist.create(info)
  list.node = node
  list.itemHeight = param.itemHeight or 0
  list.itemWidth = 0
  list.winHeight = size.height
  list.winWidth = size.width
  self.draglist_info = info
end

function PopwindowUi:addDraglistItem(node, param)
  local list = self.draglist
  if not list then
    EDLog("xxxxxxx PopwindowUi:addDraglistItem list Not Exist!")
    return
  end
  local info = self.draglist_info
  local perNum = info.perNum or 1
  local tailLenght = info.tailLenght or 0
  param = param or {}
  local offsetX = param.offsetX or 0
  local offsetY = param.offsetY or 10
  local bFeral = param.bFeral or false
  node:setAnchorPoint(ccp(0, 0))
  node:setClipItemAnchorPt(ccp(0, 0))
  list.node:setFrameRect(node, node:boundingBox())
  list.node:setParentClipNode(node, list.node.listLayer)
  local itemCount = list.node:getItemCount()
  local size = param.size or node:getContentSize()
  if not info.dragX then
    if itemCount % perNum == 0 and not bFeral then
      list.itemHeight = list.itemHeight + size.height + offsetY
    end
    list.node:addItem(node, ccp(offsetX, list.winHeight - list.itemHeight), bFeral)
    list.node:initListHeight(list.itemHeight + tailLenght)
  else
    list.node:addItem(node, ccp(list.itemWidth, offsetY), bFeral)
    if itemCount % perNum == 0 and not bFeral then
      list.itemWidth = list.itemWidth + size.width + offsetX
    end
    list.node:initListWidth(list.itemWidth + tailLenght)
  end
end

function PopwindowUi:addDraglistItemOfArray(array)
  local list = self.draglist
  if not list then
    EDLog("xxxxxxx PopwindowUi:addDraglistItemOfArray list Not Exist!")
    return
  end
  local info = self.draglist_info
  local perNum = info.perNum or 1
  local tailLenght = info.tailLenght or 0
  for _, data in ipairs(array) do
    local param = data.param or {}
    local node = data.node
    local offsetX = param.offsetX or 10
    local offsetY = param.offsetY or 10
    local bFeral = param.bFeral or false
    local posX = offsetX
    local posY = offsetY
    node:setAnchorPoint(ccp(0, 0))
    node:setClipItemAnchorPt(ccp(0, 0))
    list.node:setFrameRect(node, node:boundingBox())
    list.node:setParentClipNode(node, list.node.listLayer)
    local itemCount = list.node:getItemCount()
    local size = param.size or node:getContentSize()
    if not info.dragX then
      if itemCount % perNum == 0 and not bFeral then
        list.itemHeight = list.itemHeight + size.height + offsetY
      end
      posY = list.winHeight - list.itemHeight
    else
      posX = list.itemWidth
      if itemCount % perNum == 0 and not bFeral then
        list.itemWidth = list.itemWidth + size.width + offsetX
      end
    end
    list.node:addItem(node, ccp(posX, posY), bFeral)
  end
  if not info.dragX then
    list.node:initListHeight(list.itemHeight + tailLenght)
  else
    list.node:initListWidth(list.itemWidth + tailLenght)
  end
end

function PopwindowUi:getDragList()
  return self.draglist
end

function PopwindowUi:getDragListInfo()
  return self.draglist_info
end

function PopwindowUi:setDragListVisible(bShow)
  if self.draglist then
    self.draglist.node:setVisible(bShow)
  end
end

function PopwindowUi:moveDragListToBottom(oriPos)
  if self.draglist then
    self.draglist.node:move2Bottom(oriPos)
  end
end

function PopwindowUi:clearDragList()
  if self.draglist then
    self.draglist.node:clearList()
    self.draglist.itemHeight = 0
    self.draglist.itemWidth = 0
  end
end

function PopwindowUi:getDragListClipRect()
  if self.draglist_info then
    return self.draglist_info.cliprect
  end
end

function PopwindowUi:registerEditBox(name, params)
  local item = self.ui[name]
  if not item then
    EDLog("xxxxxxx PopwindowUi:registerEditBox UI Not Exist: " .. name)
    return
  end
  self.editbox = self.editbox or {}
  local editbox = self.editbox
  if editbox.edit then
    EDLog("xxxxxxx PopwindowUi:registerEditBox editbox is Exist: " .. name)
    return
  end
  local x, y = item:getPosition()
  params = params or {}
  params.editSize = params.editSize or item:getContentSize()
  params.maxLength = params.maxLength or 24
  params.fontColor = params.fontColor or ccc3(0, 0, 0)
  params.fontSize = params.fontSize or 20
  params.position = params.position or ccp(x + params.editSize.width / 2, y + params.editSize.height / 2)
  local edit = editBox:new({config = params})
  local zOlder = params.zOlder or 10
  self.container:addChild(edit.edit, zOlder)
  local holder = params.holder or ""
  edit:setPlaceHolder(holder)
  self.editbox = edit
  self.editbox_info = params
  self.touch_node:btRegisterHandler({
    handler = function(event, x, y)
      self.editbox:touch(event, x, y)
    end,
    key = "editbox_" .. name
  })
end

function PopwindowUi:getEditBox()
  return self.editbox
end

function PopwindowUi:getEditBoxInfo()
  return self.editbox_info
end

function PopwindowUi:setEditBoxVisible(bShow)
  self.editbox:setVisible(bShow)
end

local function getFcaActor(res, scale)
  local node = ed.ui.herodetail.herofca.create(res)
  node:setScale(scale)
  return node
end

local function getFcaUI(res, scale)
  local node = createFcaActor(res, scale)
  return node
end

local function getFcaNode(res, scale)
  local node = createFcaNode(res)
  node:setScale(scale)
  return node
end

local function getFcaLocalScale(hid)
  if not hid then
    return
  end
  local pupIdx = ed.getUnitPuppet(hid)
  if not pupIdx then
    return
  end
  local puppet = ed.getDataTable("Puppet")[pupIdx]
  if not puppet then
    return
  end
  return puppet.Scale
end

local function getFcaAction(ttype, res, scale)
  if ttype == "actor" then
    local lScale = getFcaLocalScale(res._tid) or 1
    return getFcaActor(res, scale * lScale)
  elseif ttype == "ui" then
    return getFcaUI(res, scale)
  elseif ttype == "node" then
    return getFcaNode(res, scale)
  end
end

function PopwindowUi:registerFca(name, params)
  local ttype = params.ttype
  local parent = params.parent
  local res = params.res
  local pos = params.pos
  local loop = params.loop
  local scale = params.scale or 1
  local action = params.action
  if not ttype then
    EDLog("xxxxxxx PopwindowUi:registerFca Type is nil: " .. name)
    return
  end
  local actor = getFcaAction(ttype, res, scale)
  if not actor then
    EDLog("xxxxxxx PopwindowUi:registerFca No actor: " .. name)
    return
  end
  if self.fca[name] then
    self:unregisterFca(name)
  end
  if action then
    actor:setAction(action)
  end
  if loop then
    actor:setLoop(loop)
  end
  if pos then
    actor:setPosition(pos)
  end
  self:addFca(actor)
  parent:addChild(actor)
  self.fca[name] = actor
  return actor
end

function PopwindowUi:unregisterFca(name)
  if self.fca[name] then
    local actor = self.fca[name]
    self:removeFca(actor)
    actor:removeFromParentAndCleanup(true)
    self.fca[name] = nil
  else
    EDLog("xxxxxxx PopwindowUi:unregisterFca UI Not Exist: " .. name)
  end
end

function PopwindowUi:getFca(name)
  return self.fca[name]
end

function PopwindowUi:setPosition(x, y)
  if self.mainLayer then
    self.mainLayer:setPosition(ccp(x, y))
  end
end

function PopwindowUi:getPosition()
  if self.mainLayer then
    return self.mainLayer:getPosition()
  end
end

function PopwindowUi:setCompomentPos(name, pos)
  local compo = self.ui[name]
  if not compo then
    EDLog("xxxxxxx PopwindowUi:setCompomentPos UI Not Exist: " .. name)
    return
  end
  compo:setPosition(pos)
end

function PopwindowUi:getCompomentPos(name)
  local compo = self.ui[name]
  if not compo then
    EDLog("xxxxxxx PopwindowUi:getCompomentPos UI Not Exist: " .. name)
    return
  end
  return compo:getPosition()
end

function PopwindowUi:setCompomentSize(name, size)
  local compo = self.ui[name]
  if not compo then
    EDLog("xxxxxxx PopwindowUi:setCompomentSize UI Not Exist: " .. name)
    return
  end
  compo:setContentSize(size)
end

function PopwindowUi:getCompomentSize(name)
  local compo = self.ui[name]
  if not compo then
    EDLog("xxxxxxx PopwindowUi:getCompomentSize UI Not Exist: " .. name)
    return
  end
  return compo:getContentSize()
end

function PopwindowUi:setVisible(name, value)
  local isHave = false
  local compo = self.ui[name]
  if compo then
    compo:setVisible(value)
    return
  end
  local fca = self.fca[name]
  if fca then
    fca:setVisible(value)
    return
  end
  EDLog("xxxxxxx PopwindowUi:setVisible UI Not Exist: " .. name)
end

function PopwindowUi:setOpacity(name, value)
  local compo = self.ui[name]
  if not compo then
    EDLog("xxxxxxx PopwindowUi:setOpacity UI Not Exist: " .. name)
    return
  end
  compo:setOpacity(value)
end

function PopwindowUi:setAnchorPoint(x, y)
  if self.mainLayer then
    self.mainLayer:setAnchorPoint(ccp(x, y))
  end
end

function PopwindowUi:getCompoment(name)
  local compo = self.ui[name]
  if not compo then
    EDLog("xxxxxxx PopwindowUi:getCompoment UI Not Exist: " .. name)
    return
  end
  return compo
end

function PopwindowUi:close(bSkilAnim)
  self:destroy({
    skipAnim = bSkilAnim or false
  })
end

function ed.replaceImage(oldnode, newnode)
  if oldnode == newnode then
    EDLog("xxxxxxx ed.replaceImage: oldnode == newnode!")
    return
  end
  local x, y = oldnode:getPosition()
  local anchor = oldnode:getAnchorPoint()
  local parent = oldnode:getParent()
  oldnode:removeFromParentAndCleanup(true)
  if parent then
    parent:addChild(newnode)
  end
  newnode:setPosition(ccp(x, y))
  newnode:setAnchorPoint(anchor)
  return newnode
end

function PopwindowUi.closeui()
  if testui_window then
    testui_window:close()
    testui_window = nil
  end
end

ed.closeui = PopwindowUi.closeui

function ed.tt()
  ed.offlinequest.OfflineQuestRule.create()
end

function PopwindowUi:createVoicetalk(mode, priority)
  local param = {
    touchNode = self.touch_node,
    uimode = mode or 1,
    priority = priority or -300
  }
  self.voicetalk = ed.voicetalk.getInstance()
  local container = self.voicetalk:createVoiceTalkUI(param)
  self.mainLayer:addChild(container)
end

function PopwindowUi:openVoicetalk(partner)
  if self.voicetalk then
    self.voicetalk:openVoicetalk(partner)
  end
end

function PopwindowUi:closeVoicetalk()
  if self.voicetalk then
    self.voicetalk:closeVoicetalk()
  end
end

function PopwindowUi:setVoicetalkUIPosition(position)
  if self.voicetalk and self.voicetalk.mainLayer then
    local voicetalkMainLayer = self.voicetalk.mainLayer
    voicetalkMainLayer:setPosition(position)
  end
end
