local class = newclass()
ed.scrollview = class

local function create(param)
  local self = {}
  setmetatable(self, class.mt)
  param = param or {}
  self.widthOffset = param.widthOffset or 0
  self.heightOffset = param.heightOffset or 0
  self.cliprect = param.cliprect
  self.noshade = param.noshade
  self.shaderect = param.shaderect
  self.container = param.container
  self.zorder = param.zorder
  self.priority = param.priority
  self.direction = param.direction or "v"
  self.barThick = param.barThick
  self.barPosition = param.barPosition
  self.barLenOffset = param.barLenOffset or 0
  self.barPosOffset = param.barPosOffset or ccp(0, 0)
  self.useBar = param.useBar
  self.initHandler = param.initHandler
  self.pageSize = param.pageSize or CCSizeMake(1, 1)
  self.rowCount = self.pageSize.width
  self.rowCount = math.max(self.rowCount, 1)
  self.columnCount = self.pageSize.height
  self.columnCount = math.max(self.columnCount, 1)
  self.pageCount = self.rowCount * self.columnCount
  self.pageSequence = param.pageSequence
  self.oriPosition = param.oriPosition or ccp(0, 0)
  self.itemSize = param.itemSize or CCSizeMake(0, 0)
  self.ox, self.oy = self.oriPosition.x, self.oriPosition.y
  self.dx, self.dy = self.itemSize.width, self.itemSize.height
  self.doPressIn = param.doPressIn
  self.cancelPressIn = param.cancelPressIn
  self.doClickIn = param.doClickIn
  self.cancelClickIn = param.cancelClickIn
  self.xMax, self.yMax = 0, 0
  self.items = {}
  local info = {}
  info.cliprect = self.cliprect
  info.rect = self.shaderect
  info.noshade = self.noshade
  info.zorder = self.zorder
  info.container = self.container
  info.priority = self.priority
  if self.useBar then
    info.bar = self:initBar()
    info.bar.barthick = barThick
  end
  info.doPressIn = self.doPressIn
  info.cancelPressIn = self.cancelPressIn
  info.doClickIn = self.doClickIn
  info.cancelClickIn = self.cancelClickIn
  self.draglist = ed.draglist.create(info)
  self.autoClip = param.autoClip
  return self
end

class.create = create

local function initBar(self)
  local origin = self.cliprect.origin
  local size = self.cliprect.size
  local x, y = origin.x, origin.y
  local w, h = size.width, size.height
  local len, pos
  if self.direction == "v" then
    len = h - 10 + self.barLenOffset
    if self.barPosition == "left" then
      pos = ccpAdd(self.barPosOffset, ccp(x, y + h / 2))
    else
      pos = ccpAdd(self.barPosOffset, ccp(x + w, y + h / 2))
    end
  else
    len = w - 10 + self.barLenOffset
    if self.barPosition == "top" then
      pos = ccpAdd(self.barPosOffset, ccp(x + w / 2, y + h))
    else
      pos = ccpAdd(self.barPosOffset, ccp(x + w / 2, y))
    end
  end
  return {bglen = len, bgpos = pos}
end

class.initBar = initBar

local function getItemXY(self, index)
  local xc = self.rowCount
  local yc = self.columnCount
  local tc = self.pageCount
  local seq
  local x, y = 1, 1
  if self.direction == "v" then
    seq = self.pageSequence or "hv"
    if seq == "hv" then
      x = (index - 1) % xc
      x = math.max(x, 0)
      y = math.floor((index - 1) / xc)
      y = math.max(y, 0)
    else
      x = math.floor((index - 1) % tc / yc)
      x = math.max(x, 0)
      y = math.floor((index - 1) / tc) * yc + math.ceil(math.max((index - 1) % tc, 0) % yc)
    end
  else
    seq = self.pageSequence or "vh"
    if seq == "vh" then
      x = math.floor((index - 1) / yc)
      x = math.max(x, 0)
      y = (index - 1) % yc
      y = math.max(y, 0)
    else
      x = math.floor((index - 1) / tc) * xc + math.ceil(math.max((index - 1) % tc, 0) % xc)
      y = math.floor((index - 1) % tc / xc)
      y = math.max(y, 0)
    end
  end
  self.xMax = math.max(x, self.xMax)
  self.yMax = math.max(y, self.yMax)
  return x, y
end

class.getItemXY = getItemXY

local function setOriPosition(self, pos)
  self.oriPosition = pos
  x, y = pos.x, pos.y
end

class.setOriPosition = setOriPosition

local function getItemPos(self, index)
  local x, y = self:getItemXY(index)
  local px = self.ox + self.dx * x
  local py = self.oy - self.dy * y
  return ccp(px, py)
end

class.getItemPos = getItemPos

local function addItem(self, node, pos)
  self.draglist:addItem(node, pos)
end

class.addItem = addItem

local function push(self, param)
  param = param or {}
  local index = param.index or #self.items + 1
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0, 0))
  local pos = self:getItemPos(index)
  self.draglist:addItem(container, pos)
  param.container = container
  param.dglist = self.draglist
  local item = {
    container = container,
    ui = self.initHandler(param),
    param = param,
    index = index
  }
  table.insert(self.items, item)
  self:refreshSize()
  if self.autoClip then
    self.draglist:setFrameRect(container, CCRectMake(0, 0, self.dx, self.dy))
    self.draglist:setParentClipNode(container, self.draglist.listLayer)
  end
end

class.push = push

local function addMulti(self, params)
  params = params or {}
  for i = 1, #params do
    self:add(params[i], true)
  end
  self:refresh()
end

class.addMulti = addMulti

local function add(self, param, noRefresh)
  param = param or {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0, 0))
  self.draglist:addItem(container, ccp(0, 0))
  param.container = container
  local item = {
    container = container,
    ui = self.initHandler(param),
    param = param
  }
  table.insert(self.items, item)
  if not noRefresh then
    self:refresh()
  end
end

class.add = add

local function remove(self, index, noRefreshOrder)
  for i = 1, #self.items do
    if self.items[i].index == index then
      self.items[i].container:removeFromParentAndCleanup(true)
      table.remove(self.items, i)
      break
    end
  end
  if #self.items > 0 then
    self.yMax = #self.items - 1
  else
    self.yMax = 0
  end
  self:refresh(noRefreshOrder)
end

class.remove = remove

local function refresh(self, noRefreshOrder)
  if not noRefreshOrder then
    self:order()
  end
  for i = 1, #self.items do
    local container = self.items[i].container
    local pos = self:getItemPos(i)
    container:setPosition(pos)
  end
  self:refreshSize()
end

class.refresh = refresh

local function refreshSize(self)
  if self.direction == "v" then
    self.draglist:initListHeight(self.dy * (self.yMax + 1) + self.heightOffset, false)
  elseif self.direction == "h" then
    self.draglist:initListWidth(self.dx * (self.xMax + 1) + self.widthOffset, false)
  end
end

class.refreshSize = refreshSize

local function order(self)
  for i = 1, #self.items do
    for j = i, 2, -1 do
      if (self.items[j].param.index or 0) < (self.items[i].param.index or 0) then
        local temp = self.items[i]
        self.items[i] = self.items[j]
        self.items[j] = temp
      end
    end
  end
end

class.order = order

local function move2head(self, duration, callback)
  if self.draglist.isPressing then
    self.draglist.listLayer:stopAllActions()
    if callback then
      callback()
    end
    return
  end
  self.draglist.listLayer:stopAllActions()
  local pos = ccp(0, 0)
  local m = CCMoveTo:create(duration, pos)
  m = CCEaseBackOut:create(m)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if callback then
        callback()
      end
    end, EDDebug)
  end)
  self.draglist.listLayer:runAction(ed.readaction.create({
    t = "seq",
    m,
    f
  }))
end

class.move2head = move2head

local function move2end(self, duration, callback)
  if self.draglist.isPressing then
    self.draglist.listLayer:stopAllActions()
    if callback then
      callback()
    end
    return
  end
  local ch = self.cliprect.size.height
  local lh = self.dy * (self.yMax + 1) + self.heightOffset
  if ch < lh then
    self.draglist.listLayer:stopAllActions()
    local pos = ccp(0, lh - ch)
    local m = CCMoveTo:create(duration, pos)
    m = CCEaseBackOut:create(m)
    local f = CCCallFunc:create(function()
      xpcall(function()
        if callback then
          callback()
        end
      end, EDDebug)
    end)
    self.draglist.listLayer:runAction(ed.readaction.create({
      t = "seq",
      m,
      f
    }))
  elseif callback then
    callback()
  end
end

class.move2end = move2end

local function destroy(self)
  local layer = self.draglist.mainLayer
  if not tolua.isnull(layer) then
    layer:removeFromParentAndCleanup(true)
  end
end

class.destroy = destroy

local function doMoveLayer(self, endPos, callback)
  local m = CCMoveTo:create(0.2, endPos)
  m = CCEaseSineOut:create(m)
  local f = CCCallFunc:create(function()
    xpcall(function()
      if callback then
        callback()
      end
    end, EDDebug)
  end)
  self.draglist.listLayer:runAction(ed.readaction.create({
    t = "seq",
    m,
    f
  }))
end

class.doMoveLayer = doMoveLayer

local function setTouchEnabled(self, enabled)
  self.draglist:setTouchEnabled(enabled)
end

class.setTouchEnabled = setTouchEnabled

local function checkTouchInList(self, x, y)
  return self.draglist:checkTouchInList(x, y)
end

class.checkTouchInList = checkTouchInList

local function getDragMode(self)
  return self.draglist:getDragMode()
end

class.getDragMode = getDragMode
