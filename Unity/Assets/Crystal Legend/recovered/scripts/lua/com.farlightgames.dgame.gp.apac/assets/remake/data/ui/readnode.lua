local class = newclass()
ed.readnode = class

local function DGLen(len)
  return len / ed.display.scaleFactor
end

ed.DGLen = DGLen

local function DGRectMake(x, y, w, h)
  local s = 1 / ed.display.scaleFactor
  return CCRectMake(x * s, y * s, w * s, h * s)
end

ed.DGRectMake = DGRectMake

local function DGSizeMake(w, h)
  local s = 1 / ed.display.scaleFactor
  return CCSizeMake(w * s, h * s)
end

ed.DGSizeMake = DGSizeMake

local function DGccp(x, y)
  local s = 1 / ed.display.scaleFactor
  local pos = ccp(x, y)
  return ccpMult(pos, s)
end

ed.DGccp = DGccp

local function create(root, array)
  local self = {}
  setmetatable(self, class.mt)
  if root then
    self:initRoot(root)
  end
  if array then
    self:initArray(array)
  end
  return self
end

class.create = create

function class.createWithLayer(layer)
  local self = {}
  setmetatable(self, class.mt)
  if layer.mainLayer then
    self:initRoot(layer.mainLayer)
  end
  if layer.uiControllers then
    self:initArray(layer.uiControllers)
  end
  self.panelLayer = layer
  return self
end

function class:setListItemPanel(panel)
  self.listItemPanel = panel
end

local function init(self, root, array)
  self.root = root
  self.array = array
end

class.init = init

local function initRoot(self, root)
  self.root = root
end

class.initRoot = initRoot

local function initArray(self, array)
  self.array = array
end

class.initArray = initArray

local function getNode(self, name)
  local ui = self.array
  if type(name) == "string" then
    return ui[name]
  elseif type(name) == "table" then
    for i, v in ipairs(name) do
      if i == #name then
        return ui[v]
      else
        ui = ui[v]
      end
    end
  end
end

class.getNode = getNode

local function set(self, node, info)
  if not node then
    print("node can not be nil![readnode.lua-set] : " .. (info.base.name or ""))
    EDDebug()
    return
  end
  local base = info.base
  self:setConfig(node, info)
  if not base.feral then
    self:setBase(node, info)
  else
    if base.feralArray then
      base.feralArray[base.name] = node
    end
    if ed.isElementInTable(base.extraType, {"horizontal", "vertical"}) then
      self:setBaseArrange(node, info)
    end
  end
  if base.isGetFeral then
    self.feralNode = node
  end
  self:setLayout(node, info)
end

class.set = set

local function setBaseArrange(self, node, info)
  local base = info.base
  local n = {
    node = node,
    offset = base.offset
  }
  if base.array then
    table.insert(base.array, n)
  else
    table.insert(self.array, n)
  end
end

class.setBaseArrange = setBaseArrange

local function setConfig(self, node, info)
  local config = info.config
  local ttype = info.t
  if not config then
    return
  end
  if config.isCascadeOpacity then
    node:setCascadeOpacityEnabled(true)
  end
  if config.opacity and node.setOpacity then
    node:setOpacity(config.opacity)
  end
  if config.visible ~= nil then
    if config.visible then
      node:setVisible(true)
    else
      node:setVisible(false)
    end
  end
  if config.flip then
    if config.flip == "x" then
      node:setFlipX(true)
    elseif config.flip == "y" then
      node:setFlipY(true)
    elseif config.flip == "xy" then
      node:setFlipX(true)
      node:setFlipY(true)
    end
  end
  if config.scale then
    local os = node:getScale()
    node:setScale(config.scale * os)
  end
  if config.scalexy then
    local osx, osy = node:getScaleX(), node:getScaleY()
    node:setScaleX((config.scalexy.x or 1) * osx)
    node:setScaleY((config.scalexy.y or 1) * osy)
  end
  if config.dimension then
    node:setDimensions(config.dimension)
  end
  if config.dimensions then
    node:setDimensions(config.dimensions)
  end
  if config.color then
    node:setColor(config.color)
  end
  if config.horizontalAlignment then
    node:setHorizontalAlignment(config.horizontalAlignment)
  end
  if config.verticalAlignment then
    node:setVerticalAlignment(config.verticalAlignment)
  end
  if config.scaleSize then
    node:setContentSize(config.scaleSize)
  end
  if config.clipAble then
    local _sc = config.scaleSize
    node:setClipRect(CCRectMake(0, 0, _sc.width, _sc.height))
  end
  if config.messageRect then
    node:setMessageRect(config.messageRect)
  end
  if config.rotation then
    node:setRotation(config.rotation)
  end
  if config.textureRect then
    node:setTextureRect(config.textureRect)
  end
  if config.shadow then
    node:setShadow(config.shadow.color, config.shadow.offset)
  end
  if config.stroke then
    ed.setLabelStroke(node, config.stroke.color, config.stroke.size)
  end
  if ttype ~= "Label" then
    if config.fix_size then
      node:setScaleX(config.fix_size.width / node:getContentSize().width)
      node:setScaleY(config.fix_size.height / node:getContentSize().height)
    end
    if config.fix_height then
      local ss = config.fix_height / node:getContentSize().height
      node:setScale(ss)
    end
    if config.fix_width then
      local ss = config.fix_width / node:getContentSize().width
      node:setScale(ss)
    end
    if config.fix_wh then
      local wh = config.fix_wh
      if wh.w then
        local sw = wh.w / node:getContentSize().width
        node:setScaleX(sw)
      end
      if wh.h then
        local sh = wh.h / node:getContentSize().height
        node:setScaleY(sh)
      end
    end
  else
    if config.limitX then
      node:limitWidth(config.limitX)
    end
    if config.limitXByScale then
      node:limitWidthByScale(config.limitXByScale)
    end
    if config.limitWidthBySize then
      node:limitWidthBySize(config.limitWidthBySize)
    end
  end
  if config.fix_scale then
    local scale = config.fix_scale
    if scale.x then
      node:setScaleX(scale.x)
    end
    if scale.y then
      node:setScaleY(scale.y)
    end
  end
end

class.setConfig = setConfig

local function setLayout(self, node, info)
  local layout = info.layout
  if not layout then
    return
  end
  if layout.anchor then
    node:setAnchorPoint(layout.anchor)
  end
  if layout.position then
    node:setPosition(layout.position)
  end
  if layout.rect then
    node:setTextureRect(layout.rect)
  end
  if layout.mediate then
    local offset = layout.offset or ccp(0, 0)
    local parent = node:getParent()
    local size = parent:getContentSize()
    node:setPosition(ccpAdd(ccp(size.width / 2, size.height / 2), offset))
  end
  if layout.left2 then
    local info = layout.left2
    local array = info.array or self.array
    local refer = array[info.name]
    local offset = info.offset or 0
    ed.left2(node, refer, offset)
  end
  if layout.right2 then
    local info = layout.right2
    local array = info.array or self.array
    local refer = array[info.name]
    local offset = info.offset or 0
    ed.right2(node, refer, offset)
  end
  if layout.below2 then
    local info = layout.below2
    local array = info.array or self.array
    local refer = array[info.name]
    local offset = info.offset or 0
    ed.below2(node, refer, offset)
  end
end

class.setLayout = setLayout

local function setBase(self, node, info)
  local base = info.base
  if not base then
    return
  end
  if base.parent then
    if base.parentArray then
      local parent = base.parentArray[base.parent]
      if not tolua.isnull(parent) then
        parent:addChild(node, base.z or 0)
      end
    elseif self.array then
      local parent = self.array[base.parent]
      if parent and not tolua.isnull(parent) then
        parent:addChild(node, base.z or 0)
      end
    end
  else
    self.root:addChild(node, base.z or 0)
  end
  if base.name then
    if base.array then
      base.array[base.name] = node
    else
      if self.array then
        self.array[base.name] = node
      else
      end
    end
    if EDFLAGWIN32 and node.setLuaName then
      node:setLuaName(base.name)
    end
  end
end

class.setBase = setBase

local function addCCNode(self, info)
  local base = info.base
  local node = base.node
  self:set(node, info)
end

class.addCCNode = addCCNode

local function addNodeObj(self, info)
  local base = info.base or {}
  local node = CCNode:create()
  self:set(node, info)
end

class.addNodeObj = addNodeObj

local function addSprite(self, info)
  local base = info.base or {}
  local node
  if not base.res or type(base.res) ~= "string" or base.res == "" then
    node = CCSprite:create()
  else
    node = ed.createSprite(base.res)
  end
  self:set(node, info)
end

class.addSprite = addSprite

local function addFloatPanel(self, node, z)
  local container = CCSprite:create()
  child = node.child or {}
  for k, v in pairs(child) do
  end
end

class.addFloatPanel = addFloatPanel

local function addScale9Sprite(self, info)
  local base = info.base
  local node
  if not base.res then
    node = CCScale9Sprite:create()
  elseif type(base.res) == "string" then
    local sf = ed.getSpriteFrame(base.res)
    node = CCScale9Sprite:createWithSpriteFrame(sf, base.capInsets)
  end
  self:set(node, info)
end

class.addScale9Sprite = addScale9Sprite

local function addComplexLabel(self, info)
  local base = info.base
  local config = info.config or {}
  local font, size
  if not ed.isComplexText(base.text) then
    return
  end
  if not base.font then
    font = ed.font
  else
    font = base.font
  end
  if not base.size then
    size = 30
  else
    size = base.size
  end
  local node = ed.createComplexLabel({
    text = base.text,
    font = base.font,
    size = base.size,
    color = config.color,
    shadow = config.shadow or {},
    stroke = config.stroke or {}
  }).node
  info.config = nil
  self:set(node, info)
end

class.addComplexLabel = addComplexLabel

local function addLabel(self, info)
  local base = info.base
  local font, size
  if not base.font then
    font = ed.font
  else
    font = base.font
  end
  if not base.size then
    size = 30
  else
    size = base.size
  end
  if not base.text then
    return
  end
  local node
  if ed.isComplexText(base.text) then
    local config = {
      color = info.config.color,
      shadow = info.config.shadow,
      stroke = info.config.stroke
    }
    info.config = config
    self:addComplexLabel(info)
    return
  elseif info.base.fontinfo then
    node = ed.createLabelWithFontInfo("", info.base.fontinfo)
  else
    node = CCLabelTTF:create("", font, size)
  end
  self:set(node, info)
  ed.setString(node, base.text)
end

class.addLabel = addLabel

local function addRichText(self, info)
  local text = richText:new()
  local rootNode = text:getRootNode()
  local base = info.base
  if base.parent then
    if base.parentArray then
      base.parentArray[base.parent]:addChild(rootNode, base.z or 0)
    elseif self.array and self.array[base.parent] then
      self.array[base.parent]:addChild(rootNode, base.z or 0)
    end
  else
    self.root:addChild(rootNode, base.z or 0)
  end
  if info.base.name and self.array then
    self.array[info.base.name] = text
  end
  self:setLayout(text:getRootNode(), info)
  if info.base.middle == true then
    text:setMiddle(true)
  end
  if info.layout and info.layout.anchor then
    text:setAnchor(info.layout.anchor)
  end
  if info.base.text ~= nil and info.base.text ~= "" then
    text:setString(info.base.text)
  end
end

class.addRichText = addRichText

local function addNewRichText(self, info)
  local text = newRichText:new()
  local rootNode = text:getRootNode()
  local base = info.base
  if base.parent then
    if base.parentArray then
      base.parentArray[base.parent]:addChild(rootNode, base.z or 0)
    elseif self.array and self.array[base.parent] then
      self.array[base.parent]:addChild(rootNode, base.z or 0)
    end
  else
    self.root:addChild(rootNode, base.z or 0)
  end
  if info.base.name and self.array then
    self.array[info.base.name] = text
  end
  self:setLayout(text:getRootNode(), info)
  if info.base.middle == true then
    text:setMiddle(true)
  end
  if info.layout and info.layout.anchor then
    text:setAnchor(info.layout.anchor)
  end
  if info.base.text ~= nil and info.base.text ~= "" then
    text:setString(info.base.text)
  end
end

class.addNewRichText = addNewRichText

local function addButton(self, info)
  local base = info.base
  local normalres, pressres, disabledres = base.normal, base.press, base.disabled
  pressres = pressres or normalres
  disabledres = disabledres or normalres
  local sf, normal, press, disabled
  local sf = ed.getSpriteFrame(normalres)
  normal = CCSprite:createWithSpriteFrame(sf)
  sf = ed.getSpriteFrame(pressres)
  press = CCSprite:createWithSpriteFrame(sf)
  sf = ed.getSpriteFrame(disabledres)
  disabled = CCSprite:createWithSpriteFrame(sf)
  local item = CCMenuItemSprite:create(normal, press, disabled)
  if base.name then
    if base.array then
      base.array[base.name .. "_item"] = item
    else
      if self.array then
        self.array[base.name .. "_item"] = item
      else
      end
    end
  end
  self:setConfig(item, info)
  if info.layout.anchor then
    item:setAnchorPoint(info.layout.anchor)
  end
  local node = CCMenu:createWithItem(item)
  self:setBase(node, info)
  self:setLayout(node, info)
end

class.addButton = addButton

local function addColorLayer(self, info)
  local base = info.base
  local node = CCLayerColor:create(base.color)
  self:set(node, info)
end

class.addColorLayer = addColorLayer

local function addLayer(self, info)
  local node = CCLayer:create()
  self:set(node, info)
end

class.addLayer = addLayer

function class:addClippingNode(info)
  if nil == info then
    return
  end
  local base = info.base
  if nil == base then
    return
  end
  local clippNode = ed.createClippingNodeOnly(base.stencil, base.alphaThreshold)
  if nil == clippNode then
    return
  end
  local stencil = clippNode:getStencil()
  if stencil and base.scalexy then
    stencil:setScaleX(base.scalexy.x)
    stencil:setScaleY(base.scalexy.y)
  end
  if stencil and info.layout and info.layout.anchor then
    stencil:setAnchorPoint(info.layout.anchor)
  end
  self:set(clippNode, info)
end

function class:addSpriteButton(info)
  local button = spriteButton:new(info)
  local base = info.base
  if self.panelLayer then
    self.panelLayer:addButton(button, base)
  elseif self.listItemPanel then
    self.listItemPanel:addButton(button, base)
  end
end

function class:addCheckButton(info)
  local button = checkButton:new(info)
  local base = info.base
  if self.panelLayer then
    self.panelLayer:addButton(button, base)
  end
end

function class:addScale9CheckButton(info)
  local button = Scale9CheckButton:new(info)
  local base = info.base
  if self.panelLayer then
    self.panelLayer:addButton(button, base)
  end
end

function class:addScale9Button(info)
  local button = Scale9Button:new(info)
  local base = info.base
  if self.panelLayer then
    self.panelLayer:addButton(button, base)
  elseif self.listItemPanel then
    self.listItemPanel:addButton(button, base)
  end
  return button
end

function class:addListView(info)
  if self.panelLayer then
    local parent = self.panelLayer.mainLayer
    local base = info.base
    if base.parent and self.panelLayer.uiControllers[base.parent] then
      parent = self.panelLayer.uiControllers[base.parent]
    end
    local list = listView:new(info, parent)
    self.panelLayer:addListView(list, info.base)
  end
end

function class:addEditTTF(info)
  local edit = editTTF:new(info)
  local base = info.base
  if base.parent then
    if self.array and self.array[base.parent] then
      self.array[base.parent]:addChild(edit.edit, base.z or 0)
    end
  else
    self.root:addChild(edit.edit, base.z or 0)
  end
  if self.panelLayer then
    self.panelLayer:addEditTTF(edit, info.base)
  end
end

function class:addEditBox(info)
  local edit = editBox:new(info)
  local base = info.base
  self.root:addChild(edit.edit, base.z or 0)
  if self.panelLayer then
    self.panelLayer:addEditBox(edit, info.base)
  end
end

function class:addFcaEffect(info)
  local scene = ed.getCurrentScene()
  local scale
  if info.config then
    scale = info.config.scale
  end
  local node = ed.createFcaNode(info.base.res)
  if info.base.action then
    node:setStartAction(info.base.action)
  end
  if self.panelLayer then
    self.panelLayer.panelData.scene:addFca(node)
  end
  self:set(node, info)
end

function class:addFacActor(info)
  local actor = ed.createFcaActor(info.base.res, 1)
  self:set(actor, info)
  if self.panelLayer then
    self.panelLayer.panelData.scene:addFca(actor)
  end
end

local function safeSetBaseOriName(array, item_info, name)
  local function getName(name)
    if array[name] then
      local prefix, index = string.match(name, "(.*)_(%d)")
      
      if index then
        return getName(name .. "_" .. index + 1)
      else
        return getName(name .. "_1")
      end
    else
      return name
    end
  end
  
  item_info.base = item_info.base or {}
  item_info.base.oriName = getName(name)
end

class.safeSetBaseOriName = safeSetBaseOriName

local function addHorizontalNode(self, info)
  if #(info.ui or {}) < 1 then
    return
  end
  local base = info.base or {}
  local ui_info = info.ui
  local array
  if base.feral then
    array = base.nodeArray
  else
    array = base.nodeArray or self.array
  end
  local nodes = {}
  local readnode = ed.readnode.create(nil, nodes)
  for i = 1, #ui_info do
    local nu = ui_info[i]
    nu.base.oriName = nu.base.name or i
    nu.base.name = i
    nu.base.feral = true
    nu.base.extraType = "horizontal"
    if not base.useParentOffset then
      if not nu.base.offset and base.offset then
        nu.base.useParentOffset = true
      end
      nu.base.offset = nu.base.offset or base.offset
      if nu.base.mine_offset then
        nu.base.offset = nu.base.mine_offset
        nu.base.useParentOffset = true
      end
    end
  end
  readnode:addNode(ui_info)
  local anchor
  if info.layout and info.layout.arrangeAnchor then
    anchor = info.layout.arrangeAnchor
  end
  for name, config in ipairs(ui_info) do
    local offsety = config.base.offsety
    if offsety then
      if type(nodes[name]) == "table" then
        nodes[name].offsety = offsety
      else
        nodes[name] = {
          node = nodes[name],
          offsety = offsety
        }
      end
    end
  end
  local node = ed.horizontalArrange(nodes, {anchor = anchor})
  if base.contentSize then
    local pn = CCSprite:create()
    pn:setContentSize(base.contentSize)
    node:setPosition(ed.getCenterPos(pn))
    pn:addChild(node)
    node = pn
  end
  if base.contentWidth then
    local pn = CCSprite:create()
    local size = node:getContentSize()
    pn:setContentSize(CCSizeMake(base.contentWidth, size.height))
    node:setPosition(ed.getCenterPos(pn))
    pn:addChild(node)
    node = pn
  end
  self:set(node, info)
  for i = 1, #ui_info do
    if array then
      array[ui_info[i].base.oriName] = type(nodes[i]) == "table" and nodes[i].node or nodes[i]
    end
  end
end

class.addHorizontalNode = addHorizontalNode

local function addVerticalNode(self, info)
  if #(info.ui or {}) < 1 then
    return
  end
  local base = info.base or {}
  local ui_info = info.ui
  local array
  if base.feral then
    array = base.nodeArray
  else
    array = base.nodeArray or self.array
  end
  local nodes = {}
  local readnode = ed.readnode.create(nil, nodes)
  for i = 1, #ui_info do
    local nu = ui_info[i]
    nu.base = nu.base or {}
    nu.base.oriName = nu.base.name or i
    nu.base.name = i
    nu.base.feral = true
    nu.base.extraType = "vertical"
    if not base.useParentOffset then
      if not nu.base.offset and base.offset then
        nu.base.useParentOffset = true
      end
      nu.base.offset = nu.base.offset or base.offset
      if nu.base.mine_offset then
        nu.base.offset = nu.base.mine_offset
        nu.base.useParentOffset = true
      end
    end
  end
  readnode:addNode(ui_info)
  local node = ed.verticalArrange(nodes)
  self:set(node, info)
  for i = 1, #ui_info do
    if array then
      array[ui_info[i].base.oriName] = type(nodes[i]) == "table" and nodes[i].node or nodes[i]
    end
  end
end

class.addVerticalNode = addVerticalNode

local function addChaosNode(self, info)
  local base = info.base
  local width = base.width or 999999
  local array = base.nodeArray or {}
  local padding = base.offset
  local ui_info = info.ui
  for li, lv in ipairs(ui_info) do
    for i, v in ipairs(lv) do
      if v.t ~= "Label" then
        local node = class.getFeralNode(v)
        ui_info[li][i] = {
          t = "CCNode",
          base = {
            name = v.base.name,
            node = node,
            offset = v.base.offset
          }
        }
      end
    end
  end
  local index = 1
  while index <= #ui_info do
    local line = ui_info[index]
    
    local function splitLine(ii)
      if 1 < ii then
        local newLine = {}
        for i = ii, #line do
          table.insert(newLine, line[i])
          line[i] = nil
        end
        table.insert(ui_info, index + 1, newLine)
      end
    end
    
    local w = 0
    local it = 1
    while it <= #line do
      local info = line[it]
      if info.t == "CCNode" then
        local node = info.base.node
        local nw = node:getContentSize().width * node:getScaleX()
        if width < w + nw then
          if w == 0 then
            splitLine(it + 1)
            break
          end
          splitLine(it)
          break
        else
          w = w + nw + (info.base.offset or 0)
          if width < w then
            splitLine(it)
            break
          end
        end
      elseif info.t == "Label" then
        local text = info.base.text
        text = tostring(text)
        local size = info.base.size
        local len = ed.stringutil.len(text)
        if width < w + ed.stringutil.getTextureLen(text, size) then
          local iit = ed.stringutil.getSplitPoint(text, size, width - w)
          if iit == 0 then
            if w == 0 then
              splitLine(it + 1)
              break
            end
            splitLine(it)
            break
          else
            local new_info = ed.copyTable(info)
            local text_1, text_2 = ed.stringutil.splitString(text, iit)
            info.base.text = text_1
            new_info.base.text = text_2
            info.base.baseName = info.base.baseName or info.base.name
            info.base.nameIndex = info.base.nameIndex or 1
            info.base.baseName = info.base.baseName or info.base.nameIndex
            new_info.base.baseName = info.base.baseName
            new_info.base.nameIndex = info.base.nameIndex + 1
            new_info.base.name = new_info.base.baseName .. "_" .. new_info.base.nameIndex
            if text_2 then
              table.insert(line, it + 1, new_info)
            end
            splitLine(it + 1)
            break
          end
        else
          w = w + size * len + (info.base.offset or 0)
        end
      end
      it = it + 1
    end
    index = index + 1
  end
  local vui = {}
  for i, v in ipairs(ui_info) do
    local hui = v
    local param = {
      t = "HorizontalNode",
      base = {
        name = "line_" .. i,
        nodeArray = array,
        offset = hui.offset,
        contentSize = hui.contentSize
      },
      layout = {},
      config = {},
      ui = hui
    }
    table.insert(vui, param)
  end
  local param = {
    t = "VerticalNode",
    base = {
      name = "node",
      nodeArray = array,
      offset = padding
    },
    layout = info.layout,
    config = info.config,
    ui = vui
  }
  local node = class.getFeralNode(param)
  self:set(node, info)
end

class.addChaosNode = addChaosNode

local function addDGButton(self, info)
  local ui_info = {}
  local base = info.base
  local layout = info.layout
  local config = info.config
  local labelConfig = config.labelConfig
  local pressConfig = config.pressConfig
  pressConfig = pressConfig or {}
  pressConfig.visible = pressConfig.visible or false
  pressConfig.scaleSize = pressConfig.scaleSize or config.scaleSize
  local ct = base.capInsets and "Scale9Sprite" or "Sprite"
  local cb = {
    name = base.name,
    res = base.normal,
    capInsets = base.capInsets,
    parent = base.parent,
    z = base.z
  }
  local cl = {
    anchor = layout.anchor,
    position = layout.position
  }
  local cc = config
  table.insert(ui_info, {
    t = ct,
    base = cb,
    layout = cl,
    config = cc
  })
  cb = {
    name = base.name .. "_press",
    res = base.press,
    capInsets = base.capInsets,
    parent = base.name
  }
  cl = {
    anchor = ccp(0, 0),
    position = ccp(0, 0)
  }
  cc = pressConfig
  pressConfig.flip = config.flip
  local node = ed.createSprite(base.press)
  table.insert(ui_info, {
    t = ct,
    base = cb,
    layout = cl,
    config = cc
  })
  if base.text then
    ct = "Label"
    cb = {
      name = base.name .. "_label",
      text = base.text,
      size = base.size,
      parent = base.name
    }
    local size = node:getContentSize()
    cl = {
      mediate = true,
      offset = layout.offset
    }
    cc = labelConfig
    table.insert(ui_info, {
      t = ct,
      base = cb,
      layout = cl,
      config = cc
    })
  end
  self:addNode(ui_info)
end

class.addDGButton = addDGButton

local function addSetPosInst(self, info)
  local name = info.name
  local parent = info.parent
  local parentMode = info.parentMode or "xy"
  local rx, ry = info.x, info.y
  if string.match(parentMode, "x") then
    rx = self:getNode(parent):getContentSize().width / 2
  end
  if string.match(parentMode, "y") then
    ry = self:getNode(parent):getContentSize().height / 2
  end
  if type(name) == "table" then
    for i, v in ipairs(name) do
      local node = self:getNode(v)
      local x, y = node:getPosition()
      node:setPosition(ccp(rx or x, ry or y))
    end
  elseif type(name) == "string" then
    local x, y = node:getPosition()
    node:setPosition(ccp(rx or x, ry or y))
  end
end

class.addSetPosInst = addSetPosInst

local function addFixScale2SameInst(self, info)
  local list = info.list
  local mode = info.mode or "min"
  local scale
  for i, v in ipairs(list) do
    local node = self:getNode(v)
    if not tolua.isnull(node) then
      local s = node:getScale()
      scale = scale or s
      if mode == "min" then
        scale = math.min(s, scale)
      end
      if mode == "max" then
        scale = math.max(s, scale)
      end
    end
  end
  for i, v in ipairs(list) do
    local node = self:getNode(v)
    if scale then
      node:setScale(scale)
    end
  end
end

class.addFixScale2SameInst = addFixScale2SameInst

local function addFixScaleInst(self, info)
  local ui = self.array
  local node = ui[info.name]
  local refer = ui[info.refer]
  local size = info.size
  if refer then
    size = refer:getContentSize()
  end
  if not size then
    return
  end
  local offset = info.offsetSize or CCSizeMake(0, 0)
  local mode = info.mode or "wh"
  local w = size.width + offset.width
  local h = size.height + offset.height
  if mode == "wh" then
    ed.fixNodeSize(node, CCSizeMake(w, h))
  elseif mode == "w" then
    ed.setNodeMaxWidth(node, w)
  elseif mode == "h" then
    ed.setNodeMaxHeight(node, h)
  end
end

class.addFixScaleInst = addFixScaleInst

local function addFixs9sInst(self, info)
  local ui = self.array
  local s9s = ui[info.name]
  local refer = self:getNode(info.refer)
  local w, h = 0, 0
  if not tolua.isnull(refer) then
    local size = refer:getContentSize()
    w, h = size.width, size.height
    size = s9s:getContentSize()
    w = math.max(size.width, w)
    h = math.max(size.height, h)
  end
  local offset = info.offsetSize
  if offset then
    w = w + offset.width
    h = h + offset.height
  end
  s9s:setContentSize(CCSizeMake(w, h))
end

class.addFixs9sInst = addFixs9sInst

local function addFixs9bInst(self, info)
  if info.button and info.label then
    local ui = self.array
    info.button = ui[info.button]
    info.press = ui[info.press]
    info.label = ui[info.label]
    ed.fixs9sButtonSize(info)
  else
    local ui = self.array
    local s9b = ui[info.name]
    if s9b then
      local button = s9b.sprite
      local label = s9b.label
      info.button = button
      info.label = label
      local res = ed.fixs9sButtonSize(info) or {}
      s9b.dataInfo.config.scaleSize = res.scaleSize or s9b.dataInfo.config.scaleSize
      s9b.dataInfo.layout.position = res.position or s9b.dataInfo.layout.position
    end
  end
end

class.addFixs9bInst = addFixs9bInst

local function addFixs9bListInst(self, info)
  local list = info.list
  local size = info.size
  local offset = info.offset or 10
  local mode = info.mode or "w"
  local array = self.array
  local nodeList = {}
  for i, v in ipairs(list) do
    table.insert(nodeList, array[v].label)
  end
  local w, h = ed.getMaxNodewh(nodeList)
  local bw, bh = size.width, size.height
  if string.match(mode, "w") then
    w = math.max(bw, w + offset * 2)
  else
    w = math.max(bw, w)
  end
  if string.match(mode, "h") then
    h = math.max(bh, h + offset * 2)
  else
    h = math.max(bh, h)
  end
  for i, v in ipairs(list) do
    array[v].sprite:setContentSize(CCSizeMake(w, h))
    array[v].label:setPosition(ed.getCenterPos(array[v].sprite))
    array[v].dataInfo.config.scaleSize = CCSizeMake(w, h)
  end
end

class.addFixs9bListInst = addFixs9bListInst

local function addNode(self, node, z)
  z = z or 0
  for k, v in pairs(node) do
    if type(v) == "table" then
      local zOrder
      if v.base then
        zOrder = v.base.z or z
      end
      if not ed.readnode["add" .. v.t] then
        print("the method add" .. v.t .. " is not existed![readNode.lua-addNode]")
      else
        ed.readnode["add" .. v.t](self, v)
      end
    end
  end
end

class.addNode = addNode

local function getFeralNode(param)
  param.base = param.base or {}
  param.base.isGetFeral = true
  param.base.feral = true
  if not ed.readnode["add" .. param.t] then
    print("the method add" .. param.t .. " is not existed![readNode.lua-addNode]")
  else
    local self = ed.readnode.create()
    ed.readnode["add" .. param.t](self, param)
    return self.feralNode
  end
end

class.getFeralNode = getFeralNode

local function editorui(config, addition)
  addition = addition or {}
  local isShade = addition.isShade
  local container = addition.container or isShade and CCLayerColor:create(ccc4(0, 0, 0, 150)) or CCLayer:create()
  local ui = addition.ui or {}
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(config)
  return container, ui
end

ed.editorui = editorui

local function addNode(self, node, z)
  z = z or 0
  if not self.cn then
    self.cn = {}
  end
  for k, v in pairs(node) do
    local zorder = z
    if v.z then
      zorder = v.z
    end
    ed["read" .. v.t](self, v, zorder)
  end
end

ed.addNode = addNode

local function createHotNode(x, y, heroId)
  local hotBg, fireBg, hotNum
  hotBg = ed.createScale9Sprite("UI/alpha/HVGA/hero_recommend/hero_hot_bg.png")
  hotBg:setContentSize(CCSizeMake(60, 27))
  hotBg:setOpacity(110)
  fireBg = ed.createSprite("UI/alpha/HVGA/hero_recommend/hero_recommend_icon_fire2.png")
  fireBg:setPosition(-13, 0)
  heroHot = ed.hothero.manager:getHeroHot(heroId)
  hotNum = ed.createLabelWithFontInfo(tostring(heroHot), "herorecommend_orange")
  hotNum:setPosition(13, 0)
  hotNum:setScale(0.8)
  node = CCNode:create()
  node:addChild(hotBg)
  node:addChild(hotNum)
  node:addChild(fireBg)
  node:setPosition(x, y)
  return node
end

ed.createHotNode = createHotNode
