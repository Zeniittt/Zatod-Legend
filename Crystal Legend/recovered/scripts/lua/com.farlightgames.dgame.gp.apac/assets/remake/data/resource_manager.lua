local scaleFactor = 1.5625
ed.cha_scale = 0.157 / scaleFactor
ed.cha_ui_scale = 0.78 / scaleFactor
if EDSetFcaScaleFactor then
  EDSetFcaScaleFactor(ed.cha_scale)
end

local function createTexture(resource)
  return CCTextureCache:sharedTextureCache():addImage(resource), true
end

local function getSpriteFrame(resource, isUI)
  if not resource then
    return nil
  end
  local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resource)
  if not frame then
    local texture, doCache = createTexture(resource)
    if not texture then
      return nil
    end
    local rect = CCRect(0, 0, texture:getContentSize().width, texture:getContentSize().height)
    frame = CCSpriteFrame:createWithTexture(texture, rect)
    if doCache then
      CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFrame(frame, resource)
    else
      CCTextureCache:sharedTextureCache():removeTextureForKey(resource)
    end
  end
  return frame
end

ed.getSpriteFrame = getSpriteFrame

local function getSpriteOriginalScale(resource)
  local config = ed.lookupDataTable("TextureConfig", resource)
  if not config then
    return 1
  end
  if EDFLAGWIN32 and not config.Prescaled then
    return 1
  end
  if config.ContentScale == 0 then
    return 1
  end
  return config.ContentScale
end

ed.getSpriteOriginalScale = getSpriteOriginalScale
local num_style_Texture_Path = "UI/alpha/1080P/digits/new_numStyle_Texture.png"
local num_style_Plist_Path = "UI/alpha/1080P/digits/new_numStyle_Texture.plist"

local function loadNumTexture()
  local texture = CCTextureCache:sharedTextureCache():textureForKey(num_style_Texture_Path)
  if not texture then
    texture = CCTextureCache:sharedTextureCache():addImage(num_style_Texture_Path)
    texture:retain()
  end
  return texture
end

ed.loadNumTexture = loadNumTexture

local function creatNumSprite(frameName, node)
  local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
  if not frame then
    local texture = ed.loadNumTexture()
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(num_style_Plist_Path, texture)
    frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
  end
  if frame then
    if nil == node then
      node = CCSprite:createWithSpriteFrame(frame)
    else
      node:setDisplayFrame(frame)
    end
  end
  return node
end

ed.creatNumSprite = creatNumSprite

local function loadAwakeTexture()
  local awake_point_Texture_Path = "UI/alpha/HVGA/awake/awake_point.png"
  local awake_point_Plist_Path = "UI/alpha/HVGA/awake/awake_point.plist"
  local texture = CCTextureCache:sharedTextureCache():textureForKey(awake_point_Texture_Path)
  if not texture then
    texture = CCTextureCache:sharedTextureCache():addImage(awake_point_Texture_Path)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(awake_point_Plist_Path, texture)
  end
  return texture
end

ed.loadAwakeTexture = loadAwakeTexture

local function creatAwakeSprite(frameKey)
  local frameName = "awake_" .. frameKey .. "_point.png"
  local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
  if not frame then
    EDDebug("Need ed.loadAwakeTexture() first!")
  end
  local node
  if frame then
    node = CCSprite:createWithSpriteFrame(frame)
  end
  return node
end

ed.creatAwakeSprite = creatAwakeSprite

local function createSprite(resource)
  if resource == "" or resource == nil then
    return CCSprite:create()
  end
  local frame = ed.getSpriteFrame(resource)
  if frame then
    local spr = CCSprite:createWithSpriteFrame(frame)
    local scale = getSpriteOriginalScale(resource)
    spr:setScale(scale)
    return spr
  else
    EDLog(T("failed to creating sprite from %s ", resource or "nil"))
    if EDFLAGWIN32 then
    end
    return CCSprite:create()
  end
end

ed.createSprite = createSprite

local function initSpriteWithFrame(sprite, resource)
  local frame = ed.getSpriteFrame(resource)
  if frame then
    sprite:initWithSpriteFrame(frame)
  end
end

ed.initSpriteWithFrame = initSpriteWithFrame

local function createScale9Sprite(res, capInsets, rotated)
  local frame = ed.getSpriteFrame(res)
  if rotated then
    frame:setRotated(true)
  end
  if not capInsets then
    local size = frame:getRect().size
    capInsets = CCRectMake(size.width / 3, size.height / 3, size.width / 3, size.height / 3)
  end
  local sprite = CCScale9Sprite:createWithSpriteFrame(frame, capInsets)
  return sprite
end

ed.createScale9Sprite = createScale9Sprite

local function createMultiSprite(resource)
  local frame = ed.getSpriteFrame(resource)
  if frame then
    return CCMultiSprite:createWithSpriteFrame(frame)
  else
    EDLog("Failed to creating sprite from " .. (resource or "nil"))
    return CCMultiSprite:create()
  end
end

ed.createMultiSprite = createMultiSprite

function ed.isResExists(path)
  local fullPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
  return path ~= fullPath
end

function ed.getFcaCompleteName(resource, isEffect)
  resource = ed.trim(resource)
  local isUI = string.match(resource, "^eff_UI")
  if isUI or isEffect then
    resource = "effect/" .. resource
  end
  return resource
end

function ed.isFcaExists(resource, isEffect)
  if EDFLAGWIN32 then
    local completeName = ed.getFcaCompleteName(resource, isEffect)
    local path = string.format("proto/%s.cha", completeName)
    local fullPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
    return path ~= fullPath
  end
  return false
end

function ed.assertFcaExists(resource, isEffect)
  if EDFLAGWIN32 and not ed.isFcaExists(resource, isEffect) then
    error("Fca Resource Does Not Exist: " .. resource)
  end
end

function ed.isSpineExists(resource, isEffect)
  if EDFLAGWIN32 then
    local path
    if isEffect then
      path = string.format("spine/effect/%s/%s.json", resource, resource)
    else
      path = string.format("spine/%s/%s.json", resource, resource)
    end
    local fullPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
    return path ~= fullPath
  end
  return false
end

function ed.assertSpineExists(resource, isEffect)
  if EDFLAGWIN32 and not ed.isSpineExists(resource, isEffect) then
    error("Spine Resource Does Not Exist: " .. resource)
  end
end

function ed.shouldReplaceEmptyFca()
  return true, ed.getFcaCompleteName("eff_buff_OK_ult")
end

function ed.createEDFcaEffect(resource)
  ed.assertFcaExists(resource, true)
  local node
  local bReplace, replaceFcaRes = ed.shouldReplaceEmptyFca()
  if not ed.isFcaExists(resource, true) and bReplace then
    local success = pcall(function()
      node = EDFcaEffect:create(resource)
    end)
    if not (success and node) or EDFLAGWIN32 then
      EDLog("Failed To Create Fca Node Using: " .. resource)
      node = EDFcaEffect:create(replaceFcaRes)
    end
  else
    node = EDFcaEffect:create(resource)
  end
  return node
end

function ed.createEDFcaSpEffect(resource)
  ed.assertSpineExists(resource, true)
  local replaceSpineRes = "eff_buff_Coco_ult"
  local node
  if not ed.isSpineExists(resource, true) then
    local success = pcall(function()
      node = EDFcaSpEffect:create(resource, 1)
    end)
    if not (success and node) or EDFLAGWIN32 then
      EDLog("Failed To Create Spine Node Using: " .. resource)
      node = EDFcaSpEffect:create(replaceFcaRes, 1)
    end
  else
    node = EDFcaSpEffect:create(resource, 1)
  end
  return node
end

function ed.createEDFcaActor(resource, scale)
  ed.assertFcaExists(resource)
  scale = scale or 1
  local actor
  local bReplace, replaceFcaRes = ed.shouldReplaceEmptyFca()
  if not ed.isFcaExists(resource) and bReplace then
    local success = pcall(function()
      actor = EDFcaActor:create(resource, scale)
    end)
    if not (success and actor) or EDFLAGWIN32 then
      EDLog("Failed To Create Fca Actor Using: " .. resource)
      actor = EDFcaActor:create(replaceFcaRes, scale)
    end
  else
    actor = EDFcaActor:create(resource, scale)
  end
  return actor
end

local function createFcaNode(resource)
  local isUI = string.match(resource, "^eff_UI")
  local isSpine = string.match(resource, "%.sp$")
  if isSpine then
    local resource = string.gsub(resource, "%.sp$", "")
    local node = ed.createEDFcaSpEffect(resource)
    return node
  else
    if isUI then
      local isSkin = string.match(resource, "^eff_UI_skin")
      if isSkin then
        EDSetFcaScaleFactor(ed.cha_ui_scale / 2)
      else
        EDSetFcaScaleFactor(ed.cha_ui_scale)
      end
    else
      EDSetFcaScaleFactor(ed.cha_scale)
    end
    local node = ed.createEDFcaEffect(resource)
    EDSetFcaScaleFactor(ed.cha_scale)
    return node
  end
end

ed.createFcaNode = createFcaNode

local function createFcaActor(resource, scale)
  local isSpine = string.match(resource, "%.sp$")
  if isSpine then
    local spineName = string.gsub(resource, "%.sp$", "")
    local actor = EDFcaSpActor:create(spineName, scale)
    actor:setSkin("normal")
    return actor
  else
    local isUI = string.match(resource, "^eff_UI")
    if isUI then
      local isSkin = string.match(resource, "^eff_UI_skin")
      resource = "effect/" .. resource
      if isSkin then
        EDSetFcaScaleFactor(ed.cha_ui_scale / 2)
      else
        EDSetFcaScaleFactor(ed.cha_ui_scale)
      end
    else
      EDSetFcaScaleFactor(ed.cha_scale)
    end
    local actor = ed.createEDFcaActor(resource, scale)
    EDSetFcaScaleFactor(ed.cha_scale)
    return actor
  end
end

ed.createFcaActor = createFcaActor
local black_list_cache = {}

local function IsResourceMd5BlackListEmpty()
  local black_list = ed.ResourceMd5BlackList or {}
  if next(black_list) == nil then
    return true
  else
    return false
  end
end

_G.IsResourceMd5BlackListEmpty = IsResourceMd5BlackListEmpty

local function IsResourceMd5InBlackList(md5)
  local md5_value = string.gsub(md5, ".", function(c)
    return string.format("%02x", string.byte(c))
  end)
  local black_list = ed.ResourceMd5BlackList or {}
  if black_list[md5_value] then
    return true
  else
    return false
  end
end

_G.IsResourceMd5InBlackList = IsResourceMd5InBlackList

local function IsResourceNameBlackListEmpty()
  local black_list = ed.ResourceNameBlackList or {}
  if next(black_list) == nil then
    return true
  else
    return false
  end
end

_G.IsResourceNameBlackListEmpty = IsResourceNameBlackListEmpty

local function IsResourceNameInBlackList(name)
  local black_list = ed.ResourceNameBlackList or {}
  if black_list[name] then
    return true
  else
    return false
  end
end

_G.IsResourceNameInBlackList = IsResourceNameInBlackList

local function createClippingNodeOnly(stencil, alphaThreshold, anchorPoint)
  if nil == stencil then
    return
  end
  local cn = CCClippingNode:create()
  local stencil = ed.createSprite(stencil)
  if anchorPoint then
    stencil:setAnchorPoint(anchorPoint)
  end
  cn:setStencil(stencil)
  cn:setAlphaThreshold(alphaThreshold or 0.5)
  cn:setCascadeOpacityEnabled(true)
  return cn
end

ed.createClippingNodeOnly = createClippingNodeOnly

local function createRenderFcaBlendNode(fca_res, scale)
  local headmask = ed.createSprite("UI/alpha/1080P/common/main_head_mask.png")
  local wt = 70
  local size = headmask:getContentSize()
  headmask:setScale(wt / size.width)
  size = headmask:getContentSize()
  headmask:setPosition(ccp(wt / 2, wt / 2))
  local fca = ed.createFcaActor(fca_res)
  fca:setScale(scale)
  fca:setLoop(true)
  fca:setAction("Loop")
  fca:setPosition(ccp(wt / 2, wt / 2))
  fca:update(0)
  local headrt = CCRenderTexture:create(wt, wt)
  headrt:beginWithClear(0, 0, 0, 0)
  local blendFunc1 = ccBlendFunc()
  blendFunc1.src = GL_ONE
  blendFunc1.dst = GL_ZERO
  headmask:setBlendFunc(blendFunc1)
  headmask:visit()
  if fca.changeFcaBlendfunc then
    local blendFunc1 = ccBlendFunc()
    blendFunc1.src = GL_DST_ALPHA
    blendFunc1.dst = GL_ONE_MINUS_SRC_ALPHA
    fca:changeFcaBlendfunc(blendFunc1)
  end
  fca:visit()
  headrt:endToLua()
  local rendered_sprite = CCSprite:createWithTexture(headrt:getSprite():getTexture())
  rendered_sprite:setAnchorPoint(ccp(0.5, 0.5))
  rendered_sprite:setContentSize(CCSizeMake(60, 60))
  rendered_sprite:setFlipY(true)
  return rendered_sprite
end

ed.createRenderFcaBlendNode = createRenderFcaBlendNode

local function createRenderTexBlendNode(head_res, setSize)
  local res = head_res or "UI/alpha/1080P/common/main_head_mask.png"
  local sprite = ed.createSprite(res)
  local size = sprite:getContentSize()
  local headmask = ed.createSprite("UI/alpha/1080P/common/main_head_mask.png")
  local ow, oh = -3, -3
  local headrt = CCRenderTexture:create(size.width, size.height)
  headrt:beginWithClear(0, 0, 0, 0)
  local blendFunc1 = ccBlendFunc()
  blendFunc1.src = GL_ONE
  blendFunc1.dst = GL_ZERO
  headmask:setBlendFunc(blendFunc1)
  headmask:setPosition(ccp(size.width * 0.5 + 2, size.height * 0.5))
  local stencil = headmask
  local ss = stencil:getContentSize()
  stencil:setScaleX((size.width + ow) / ss.width)
  stencil:setScaleY((size.height + oh) / ss.height)
  headmask:visit()
  sprite:setPosition(ccp(size.width * 0.5, size.height * 0.5))
  blendFunc1.src = GL_DST_ALPHA
  blendFunc1.dst = GL_ZERO
  sprite:setBlendFunc(blendFunc1)
  sprite:visit()
  headrt:endToLua()
  local rendered_sprite = CCSprite:createWithTexture(headrt:getSprite():getTexture())
  rendered_sprite:setAnchorPoint(ccp(0.5, 0.5))
  rendered_sprite:setContentSize(size)
  rendered_sprite:setFlipY(true)
  return rendered_sprite
end

ed.createRenderTexBlendNode = createRenderTexBlendNode

local function createClippingNodeEx(res, stencil, alphaThreshold, setSize, param)
  local ClippingNode = createClippingNodeOnly(stencil, alphaThreshold)
  if nil == ClippingNode then
    return
  end
  local res = res or "UI/alpha/1080P/common/main_head_mask.png"
  local sprite
  if param then
    sprite = createRenderTexBlendNode(res, setSize)
  else
    sprite = ed.createSprite(res)
  end
  sprite:setAnchorPoint(ccp(0.5, 0.5))
  local size = sprite:getContentSize()
  local ow, oh = 0, 0
  if setSize then
    ow = setSize.width
    oh = setSize.height
  end
  local stencil = ClippingNode:getStencil()
  local ss = stencil:getContentSize()
  stencil:setScaleX((size.width + ow) / ss.width)
  stencil:setScaleY((size.height + oh) / ss.height)
  ClippingNode:addChild(sprite)
  return ClippingNode, sprite
end

ed.createClippingNodeEx = createClippingNodeEx

local function createClippingNode(res, stencil, alphaThreshold, setSize)
  return createClippingNodeEx(res, stencil, alphaThreshold, setSize)
end

ed.createClippingNode = createClippingNode

local function createLabelTTF(text, size, font, skipFormat)
  if not skipFormat then
    text = ed.formatText(text)
  end
  text = text or ""
  assert(text, "the text of the label must not be nil. @ resource_manager")
  local label
  if not font then
    label = CCLabelTTF:create(text, ed.font, size)
  else
    label = CCLabelTTF:create(text, font, size)
  end
  return label
end

ed.createLabelTTF = createLabelTTF

local function setLabelFontInfo(label, info)
  if nil == label or tolua.isnull(label) then
    return
  end
  if nil == info then
    return
  end
  local fontInfo = EDTables.fontconfigs[info]
  if fontInfo == nil then
    print("fontInfo:" .. info .. "no found!!")
    return
  end
  if fontInfo.color then
    label:setColor(fontInfo.color)
  else
    label:setColor(ccc3(255, 255, 255))
  end
  if fontInfo.strokeColor then
    ed.setLabelStroke(label, fontInfo.strokeColor, fontInfo.strokeSize)
  else
    ed.disableLabelStroke(label)
  end
  if fontInfo.shadowColor then
    ed.setLabelShadow(label, fontInfo.shadowColor, fontInfo.shadowOffset)
  else
    ed.disableLabelShadow(label)
  end
end

ed.setLabelFontInfo = setLabelFontInfo

local function createLabelWithFontInfo(text, info, skipFormat)
  if nil == info then
    return
  end
  local fontInfo = EDTables.fontconfigs[info]
  if fontInfo == nil then
    print("fontInfo:" .. info .. "no found!!")
    return
  end
  local label = ed.createLabelTTF("", fontInfo.size)
  setLabelFontInfo(label, info)
  ed.setLabelString(label, text, skipFormat)
  return label
end

ed.createLabelWithFontInfo = createLabelWithFontInfo

local function setLabelString(label, text, skipFormat)
  if tolua.isnull(label) then
    return
  end
  if not text then
    return
  end
  if not skipFormat then
    text = ed.formatText(text)
  end
  label:setString(text)
end

ed.setLabelString = setLabelString

local function createComplexLabel(param)
  return ed.widget.complexlabel.create(param)
end

ed.createComplexLabel = createComplexLabel

local function createttf(text, size, font, anchor)
  if ed.isComplexText(text) then
    return ed.createComplexLabel({
      text = text,
      size = size,
      font = font,
      anchor = anchor
    }).node, "isComplexText"
  else
    return ed.createLabelTTF(text, size, font, true)
  end
end

ed.createttf = createttf

local function replaceNode(pre, cur, prarm)
  local anchor = pre:getAnchorPoint()
  local pos = ccp(pre:getPosition())
  local z = pre:getZOrder()
  local parent = pre:getParent()
  if not tolua.isnull(parent) then
    cur:setAnchorPoint(anchor)
    cur:setPosition(pos)
    parent:addChild(cur, z)
    pre:removeFromParentAndCleanup(true)
    if prarm then
      prarm.ui[prarm.key] = cur
    end
  end
end

ed.replaceNode = replaceNode

function ed.setString(label, text)
  if not label then
    return
  end
  if not text then
    return
  end
  if not label.setString then
    return
  end
  if type(label) == "userdata" then
    ed.setLabelString(label, text, true)
  elseif type(label) == "table" then
    label:setString(text)
  end
end

function ed.setTextureV2(sprite, path, ignoreContentSize)
  if not sprite then
    return
  end
  if tolua.isnull(sprite) then
    return
  end
  if not path then
    return
  end
  if not sprite.setTexture then
    return
  end
  if not ed.isResExists(path) and EDFLAGWIN32 then
    error("Texture Resource Does Not Exist: " .. path)
  end
  local texture = createTexture(path)
  if texture then
    local textureSize = texture:getContentSize()
    sprite:setTexture(texture)
    if ignoreContentSize then
      sprite:setContentSize(textureSize)
      sprite:setTextureRect(CCRectMake(0, 0, textureSize.width, textureSize.height))
    end
  end
end

function ed.setTexture(sprite, path, ignoreContentSize)
  if not sprite then
    return
  end
  if tolua.isnull(sprite) then
    return
  end
  if not path then
    return
  end
  if not sprite.setTexture then
    return
  end
  if not ed.isResExists(path) and EDFLAGWIN32 then
    error("Texture Resource Does Not Exist: " .. path)
  end
  local texture = createTexture(path)
  if texture then
    local textureSize = texture:getContentSize()
    sprite:setTexture(texture)
    sprite:setContentSize(textureSize)
    if ignoreContentSize then
      sprite:setTextureRect(CCRectMake(0, 0, textureSize.width, textureSize.height))
    end
  end
end

function ed.setScale9SpriteTexture(sprite, path)
  if not sprite then
    return
  end
  if tolua.isnull(sprite) then
    return
  end
  if not path then
    return
  end
  if not sprite.setSpriteFrame then
    return
  end
  if not ed.isResExists(path) and EDFLAGWIN32 then
    error("[setScale9SpriteTexture]Texture Resource Does Not Exist: " .. path)
  end
  local sf = ed.getSpriteFrame(path)
  if sf then
    local size = sprite:getContentSize()
    local scale = sprite:getScale()
    sprite:setSpriteFrame(sf)
    sprite:setContentSize(size)
    sprite:setScale(scale)
  end
end

local function setLabelShadow(label, color, offset)
  if tolua.isnull(label) then
    return
  end
  if label.setShadow then
    label:setShadow(color, offset)
  end
end

ed.setLabelShadow = setLabelShadow

local function disableLabelShadow(label)
  if tolua.isnull(label) then
    return
  end
  label:disableShadow()
end

ed.disableLabelShadow = disableLabelShadow

local function setLabelStroke(label, color, size)
  if tolua.isnull(label) then
    return
  end
  if label.setStroke then
    label:setStroke(color, size)
  end
end

ed.setLabelStroke = setLabelStroke

local function disableLabelStroke(label)
  if tolua.isnull(label) then
    return
  end
  label:disableStroke()
end

ed.disableLabelStroke = disableLabelStroke

local function setLabelColor(label, color)
  if tolua.isnull(label) then
    return
  end
  label:setColor(color)
end

ed.setLabelColor = setLabelColor

local function setLabelDimensions(label, dimensions)
  if tolua.isnull(label) then
    return
  end
  label:setDimensions(dimensions)
end

ed.setLabelDimensions = setLabelDimensions

local function setLabelFontName(label, fontName)
  if tolua.isnull(label) then
    return
  end
  label:setFontName(fontName)
end

ed.setLabelFontName = setLabelFontName

local function adaptLabel(label, param)
  if tolua.isnull(label) then
    return
  end
  local labelSize = label:getContentSize()
  local maxWidth = param.maxWidth or labelSize.width
  local maxHeight = param.maxHeight or labelSize.height
  local minScale = param.minScale or 1
  local singleLine = param.singleLine or false
  local forceWidth = param.forceWidth or false
  if maxWidth < labelSize.width then
    if minScale > maxWidth / labelSize.width then
      if forceWidth then
        label:setScale(minScale)
        if not singleLine then
          ed.setLabelDimensions(label, CCSizeMake(maxWidth, 0))
        end
      else
        if not singleLine then
          ed.setLabelDimensions(label, CCSizeMake(maxWidth / minScale, 0))
        end
        label:setScale(minScale)
      end
    else
      label:setScale(maxWidth / labelSize.width)
    end
  end
end

ed.adaptLabel = adaptLabel

local function setLabelAutoWidth(txt, width)
  local txt, width, ret, str, wid = txt or "", width or 100, {}, "", 0
  local f = "[%z\001-\127\194-\244][\128-\191]*"
  for v in txt:gfind(f) do
    table.insert(ret, {
      c = v,
      isChinese = #v ~= 1
    })
  end
  for i, v in ipairs(ret) do
    if v.isChinese then
      wid = wid + 14
    else
      wid = wid + 7
    end
    str = str .. v.c
    if width <= wid then
      str = str .. "\n"
      wid = 0
    end
  end
  return str
end

ed.setLabelAutoWidth = setLabelAutoWidth

local function createFrameAnim(list, delay)
  delay = delay or 0.041666666666666664
  local spr
  local array = CCArray:createWithCapacity(#list)
  for i, v in ipairs(list) do
    spr = spr or createSprite(v)
    local frame = ed.getSpriteFrame(v)
    array:addObject(frame)
  end
  local animation = CCAnimation:createWithSpriteFrames(array, delay)
  local anim = CCAnimate:create(animation)
  return spr, anim
end

ed.createFrameAnim = createFrameAnim

function createAnimateWithFrameNames(name_list, delay)
  if not name_list then
    return nil
  end
  delay = delay or 0.08333333333333333
  local array = CCArray:create()
  for i = 1, #name_list do
    local frame = ed.getSpriteFrame(name_list[i])
    array:addObject(frame)
  end
  local animation = CCAnimation:createWithSpriteFrames(array, delay)
  return CCAnimate:create(animation)
end

ed.createAnimateWithFrameNames = createAnimateWithFrameNames

local function updateSpriteGray(sprite, isGray)
  if isGray then
    ed.setSpriteGray(sprite)
  else
    ed.resetSpriteShader(sprite)
  end
end

ed.updateSpriteGray = updateSpriteGray

local function setSpriteGray(sprite)
  local shader = CCShaderCache:sharedShaderCache():programForKey("GrayScalingShader")
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
end

ed.setSpriteGray = setSpriteGray

local function setSpriteShader(sprite, name)
  local shader = CCShaderCache:sharedShaderCache():programForKey(name)
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
end

ed.setSpriteShader = setSpriteShader

local function updateSpriteStone(sprite, isGray)
  if isGray then
    ed.setSpriteStone(sprite)
  else
    ed.resetSpriteShader(sprite)
  end
end

ed.updateSpriteStone = updateSpriteStone

local function setSpriteStone(sprite)
  local shader = CCShaderCache:sharedShaderCache():programForKey("StoneShader")
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
end

ed.setSpriteStone = setSpriteStone

local function resetSpriteShader(sprite)
  local s = CCSprite:create()
  sprite:setShaderProgram(s:getShaderProgram())
  sprite:getShaderProgram():use()
end

ed.resetSpriteShader = resetSpriteShader

local function setScreenBlur(sprite, radius)
  local shader = CCShaderCache:sharedShaderCache():programForKey("ScreenBlur")
  if not shader then
    return
  end
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
  local size = sprite:getTexture():getContentSizeInPixels()
  local width = size.width
  local height = size.height
  local location = sprite:getShaderProgram():getUniformLocationForName("blurSize")
  sprite:getShaderProgram():setUniformsForBuiltins()
  sprite:getShaderProgram():setUniformLocationWith2f(location, radius, radius)
  local location = sprite:getShaderProgram():getUniformLocationForName("uCanvasSize")
  sprite:getShaderProgram():setUniformsForBuiltins()
  sprite:getShaderProgram():setUniformLocationWith2f(location, width, height)
end

ed.setScreenBlur = setScreenBlur

local function setHorizontalBlur(sprite, radius, cellNum)
  local shader = CCShaderCache:sharedShaderCache():programForKey("HorizontalBlur")
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
  local size = sprite:getTexture():getContentSizeInPixels()
  local width = size.width
  local height = size.height
  local location = sprite:getShaderProgram():getUniformLocationForName("blurCoeff")
  sprite:getShaderProgram():setUniformsForBuiltins()
  sprite:getShaderProgram():setUniformLocationWith2f(location, radius, cellNum)
end

ed.setHorizontalBlur = setHorizontalBlur

local function setSpriteBlur(sprite, radius)
  local shader = CCShaderCache:sharedShaderCache():programForKey("Blur")
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
  local size = sprite:getTexture():getContentSizeInPixels()
  local width = size.width
  local height = size.height
  local location = sprite:getShaderProgram():getUniformLocationForName("blurSize")
  sprite:getShaderProgram():setUniformsForBuiltins()
  sprite:getShaderProgram():setUniformLocationWith2f(location, radius, radius)
end

ed.setSpriteBlur = setSpriteBlur

local function setSpriteHSV(sprite, h, s, v)
  local shader = CCShaderCache:sharedShaderCache():programForKey("HSVtoRGBShader")
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
  local location = sprite:getShaderProgram():getUniformLocationForName("HSV")
  sprite:getShaderProgram():setUniformsForBuiltins()
  sprite:getShaderProgram():setUniformLocationWith4f(location, h, s, v, 0)
end

ed.setSpriteHSV = setSpriteHSV

local function useShadowShader(node)
  local shaderName = "ShadowShader"
  local shader = CCShaderCache:sharedShaderCache():programForKey(shaderName)
  if node.useShader then
    node:useShader(shaderName)
  else
    node:setShaderProgram(shader)
    node:getShaderProgram():use()
  end
end

ed.useShadowShader = useShadowShader

local function useHSVShaderV2(node, h, s, v)
  ed.useShader(node, "HSVtoRGBShaderV2")
  local shader = CCShaderCache:sharedShaderCache():programForKey("HSVtoRGBShaderV2")
  local location = shader:getUniformLocationForName("HSV")
  shader:setUniformsForBuiltins()
  shader:setUniformLocationWith4f(location, h, s, v, 1)
end

ed.useHSVShaderV2 = useHSVShaderV2

local function useShader(node, shaderName)
  local shaderName = shaderName
  local shader = CCShaderCache:sharedShaderCache():programForKey(shaderName)
  if node.useShader then
    node:useShader(shaderName)
  else
    node:setShaderProgram(shader)
    node:getShaderProgram():use()
  end
end

ed.useShader = useShader

local function horizontalArrange(nodes, param)
  param = param or {}
  local mode = param.type or "center"
  local fix_height = param.fix_height
  local fix_width = param.fix_width
  local fix_size
  if fix_height or fix_width then
    fix_size = CCSizeMake(fix_width or 0, fix_height or 0)
  end
  local maxHeight = 0
  for _, node in ipairs(nodes) do
    if type(node) == "table" then
      node = node.node
    else
    end
    maxHeight = math.max(maxHeight, node:getContentSize().height * node:getScaleY())
  end
  local height = param.height or maxHeight
  local ns = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local addWidth = 0
  for i = 1, #(nodes or {}) do
    local node = nodes[i]
    local offset, offsety = 0, 0
    if type(node) == "table" then
      offset = node.offset
      offsety = node.offsety
      node = node.node
    end
    node:setAnchorPoint(ccp(0, 0.5))
    if param.anchor then
      node:setAnchorPoint(param.anchor)
    end
    ed.fixNodeSize(node, fix_size)
    if i == 1 then
      node:setPosition(ccp(0, height / 2))
      if param.anchor then
        node:setAnchorPoint(param.anchor)
        node:setPosition(ccp(0, height))
      end
    else
      local pn
      if type(nodes[i - 1]) == "table" then
        pn = nodes[i - 1].node
      else
        pn = nodes[i - 1]
      end
      ed.right2(node, pn, offset, {offsety = offsety})
      addWidth = addWidth + (offset or 0)
    end
    table.insert(ns, node)
    container:addChild(node)
  end
  local width = ed.sumNodeSize(ns) + addWidth
  container:setContentSize(CCSizeMake(width, height))
  return container
end

ed.horizontalArrange = horizontalArrange

local function verticalArrange(nodes, param)
  param = param or {}
  local fix_height = param.fix_height
  local fix_width = param.fix_width
  local fix_size
  if fix_height or fix_width then
    fix_size = CCSizeMake(fix_width or 0, fix_height or 0)
  end
  local n1
  if type(nodes[1]) == "table" then
    n1 = nodes[1].node
  else
    n1 = nodes[1]
  end
  local ns = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local addHeight = 0
  local maxWidth = 0
  for i = 1, #(nodes or {}) do
    local node = nodes[i]
    local offset = 0
    if type(node) == "table" then
      offset = node.offset
      node = node.node
    end
    node:setAnchorPoint(ccp(0, 1))
    ed.fixNodeSize(node, fix_size)
    local nodeSize = node:getContentSize()
    local w = nodeSize.width
    maxWidth = math.max(w, maxWidth)
    if i == 1 then
      node:setPosition(ccp(0, 0))
    else
      local pn
      if type(nodes[i - 1]) == "table" then
        pn = nodes[i - 1].node
      else
        pn = nodes[i - 1]
      end
      ed.below2(node, pn, offset)
      addHeight = addHeight + (offset or 0)
    end
    table.insert(ns, node)
    container:addChild(node)
  end
  local tw, height = ed.sumNodeSize(ns)
  height = height + addHeight
  local vNode = CCSprite:create()
  vNode:setContentSize(CCSizeMake(maxWidth, height))
  container:setAnchorPoint(ccp(0, 0))
  container:setPosition(ccp(0, height))
  vNode:addChild(container)
  vNode:setCascadeOpacityEnabled(true)
  return vNode
end

ed.verticalArrange = verticalArrange

local function getHeadFrame(param)
  param = param or {}
  local id = param.id
  local hide_icon_when_dyna = param.hide_icon_when_dyna
  local res, row, is_dync, frame_fca, frame_spine, fca_scale
  local sp_delay = param.sp_delay ~= false
  if id then
    row = ed.getDataTable("AvatarFrame")[id] or ed.getDataTable("AvatarFrame")[1]
    res = row.Picture
    is_dync = row["Is Dynamic"]
    frame_fca = row["Dynamic Model"]
    frame_spine = row["Spine Dynamic Model"]
    fca_scale = row.Scale
  elseif param.res then
    res = param.res
    is_dync = param.is_dyna
    frame_fca = param.frame_fca
    frame_spine = param.frame_spine
    fca_scale = param.frame_scale
  else
    row = ed.player:getHeadIconF()
    res = row.Picture
    is_dync = row["Is Dynamic"]
    frame_fca = row["Dynamic Model"]
    frame_spine = row["Spine Dynamic Model"]
    fca_scale = row.Scale
    sp_delay = false
  end
  if not res or not ed.getSpriteFrame(res) then
    res = ed.getDataTable("AvatarFrame")[1].Picture
  end
  local length = param.length or 70
  local frame, frameicon, framefca
  frame = CCSprite:create()
  frameicon = ed.createSprite(res)
  frame:addChild(frameicon)
  if is_dync and (frame_fca or frame_spine) then
    if hide_icon_when_dyna then
      frameicon:setVisible(false)
    end
    if frame_spine then
      framefca = ed.delayCreateAvatarSpine(frame, frame_spine, fca_scale, sp_delay)
    else
      framefca = ed.createAvatarFca(frame_fca, fca_scale, frame)
    end
  end
  return frame, frameicon, framefca
end

ed.getHeadFrame = getHeadFrame

local function getHeadIcon(param)
  param = param or {}
  local id = param.id
  local res, row, is_dync, avtr_fca, avtr_spine, fca_scale
  local sp_delay = true
  if id then
    local id = ed.analyzeAvatar(param.id).avatar
    row = ed.getDataTable("Avatar")[id] or ed.getDataTable("Avatar")[1]
    res = row.Picture or ed.getDataTable("Avatar")[1].Avatar
    is_dync = row["Is Dynamic"]
    avtr_fca = row["Dynamic Model"]
    avtr_spine = row["Spine Dynamic Model"]
    fca_scale = row.Scale
  elseif param.res then
    res = param.res
    is_dync = param.is_dyna
    avtr_fca = param.avt_fca
    avtr_spine = param.avt_spine
    fca_scale = param.avt_scale
  else
    row = ed.player:getHeadIcon()
    res = row.Picture
    is_dync = row["Is Dynamic"]
    avtr_fca = row["Dynamic Model"]
    avtr_spine = row["Spine Dynamic Model"]
    fca_scale = row.Scale
    sp_delay = false
  end
  res = res or ed.getDataTable("Avatar")[1].Picture
  if not EDGetFileData(res) then
    res = ed.getDataTable("Avatar")[1].Picture
  end
  local length = param.length or 70
  local head, headicon, headfca
  if param.rendertex then
    head, headicon = ed.createClippingNodeEx(res, "UI/alpha/1080P/common/main_head_mask.png", nil, CCSizeMake(0, 0), param)
  else
    head, headicon = ed.createClippingNode(res, "UI/alpha/1080P/common/main_head_mask.png", nil, CCSizeMake(0, 0))
  end
  local size = headicon:getContentSize()
  local len = size.width
  head:setScale(length / size.width)
  if is_dync and (avtr_fca or avtr_spine) then
    if param.rendertex then
      if avtr_spine then
      else
        local fca_render = ed.createRenderFcaBlendNode(avtr_fca, fca_scale)
        head:addChild(fca_render)
      end
    elseif avtr_spine then
      headfca = ed.delayCreateAvatarSpine(head, avtr_spine, fca_scale, sp_delay)
    else
      headfca = ed.createAvatarFca(avtr_fca, fca_scale, head)
    end
  end
  return head, headicon, headfca
end

ed.getHeadIcon = getHeadIcon

function ed.delayCreateAvatarSpine(head, avtr_spine, scale, sp_delay)
  local spine = avtr_spine
  local head = head
  
  local function createAvatarSpine()
    local headfca = ed.createSpineEffect(spine, scale)
    headfca:setAnimation(0, "Idle", true)
    head:addChild(headfca)
    headfca:setPosition(0, 0)
    return headfca
  end
  
  if sp_delay then
    EnqueueDelayProcess(function()
      if tolua.isnull(head) then
        return
      end
      createAvatarSpine()
    end)
  else
    return createAvatarSpine()
  end
end

function ed.createAvatarFca(avtr_fca, scale, prt)
  local headfca = ed.createFcaActor(avtr_fca)
  
  local function func()
    if tolua.isnull(headfca) then
      return
    end
    local scene = ed.getCurrentScene()
    headfca:setLoop(true)
    headfca:setAction("Loop")
    headfca:update(0)
    headfca:setScale(scale)
    scene:addFca(headfca)
  end
  
  func()
  if prt then
    prt:addChild(headfca)
    headfca:setPosition(ed.getCenterPos(prt))
  end
  ListenTimer(Timer:Once(0.1), function()
    func()
  end)
  return headfca
end

local function getTeamHead(param)
  param = param or {}
  local state = param.type
  local vip = param.vip
  local length = param.length
  local id = param.id and ed.analyzeAvatar(param.id).avatarFrame
  local setStone = param.setStone
  param.length = nil
  local head, headicon = ed.getHeadIcon(param)
  if tolua.isnull(headicon) then
    return
  end
  local container = CCSprite:create()
  local size = headicon:getContentSize()
  container:setContentSize(size)
  local center = ed.getCenterPos(container)
  head:setPosition(center)
  container:addChild(head)
  if param.isFaceLeft then
    head:setScaleX(-1)
  end
  local frameres = vip and "UI/alpha/1080P/mainhead/main_head_frame_gold.png" or "UI/alpha/1080P/mainhead/main_head_frame_silver.png"
  if state then
    frameres = state == "vip" and "UI/alpha/1080P/mainhead/main_head_frame_gold.png" or "UI/alpha/1080P/mainhead/main_head_frame_silver.png"
  end
  local frameData = {res = frameres}
  if id and id ~= 0 then
    local row = ed.getDataTable("AvatarFrame")[id] or ed.getDataTable("AvatarFrame")[1]
    frameData = {
      res = row.Picture,
      is_dyna = row["Is Dynamic"],
      frame_fca = row["Dynamic Model"],
      frame_spine = row["Spine Dynamic Model"],
      frame_scale = row.Scale,
      hide_icon_when_dyna = true
    }
  end
  local frame, frameicon, framefca = ed.getHeadFrame(frameData)
  frame:setPosition(ccpAdd(center, ccp(0, 1)))
  container:addChild(frame)
  if param.level and 0 < param.level then
    local levelIcon = ed.getLevelIcon(param)
    if levelIcon then
      levelIcon:setAnchorPoint(ccp(0.5, 0.5))
      levelIcon:setPosition(ccp(60, 12))
      container:addChild(levelIcon)
    end
  end
  if setStone then
    ed.setSpriteStone(headicon)
    ed.setSpriteStone(frame)
  end
  if length then
    container:setScale(length / size.width)
  end
  return container
end

ed.getTeamHead = getTeamHead

local function getLevelIcon(param)
  param = param or {}
  if not param.level then
    return
  end
  local level = param.level
  local state = param.type or "common"
  local vip = param.vip
  local frameres = "UI/alpha/1080P/ranking/lv_bg.png"
  local frame = ed.createSprite(frameres)
  local container = CCSprite:create()
  local center = ed.getCenterPos(container)
  frame:setPosition(center)
  container:addChild(frame)
  container:setScale(param.levelScale or 1)
  local levelLabel = ed.createLabelTTF(level, 16)
  center.y = center.y + 1
  ed.setLabelStroke(levelLabel, ccc3(43, 28, 8), 1)
  local lvColor = ccc3(251, 224, 116)
  levelLabel:setPosition(center)
  container:addChild(levelLabel)
  ed.setLabelColor(levelLabel, lvColor)
  return container, levelLabel
end

ed.getLevelIcon = getLevelIcon

local function getPlayoffHeadFrame(param)
  local iswin = param.iswin
  local champion = param.champion
  local fres = iswin and "UI/alpha/1080P/kings_pvp/playoff_avatarframe.png" or "UI/alpha/1080P/kings_pvp/playoff_avatarframe_disabled.png"
  local cres = "UI/alpha/1080P/kings_pvp/playoff_player_frame_champion.png"
  return fres, cres
end

local function getHeroIconByID(param)
  param = param or {}
  local hid = param.hid
  local avatar = ed.analyzeAvatar(param.id or 0)
  local id = avatar.avatar or 1
  local fid = param.frameId or avatar.avatarFrame
  local unknow = param.unknow
  local vip = param.vip
  local length = param.length
  local relation = param.relation
  local rendertex = param.rendertex
  local head = CCSprite:create()
  head:setContentSize(CCSizeMake(80, 80))
  local res, avt_fca, avt_spine, avt_scale, is_dyna, not_fca
  if hid then
    local ut = ed.getDataTable("Unit")
    local row = ut[hid]
    if not row then
      return
    end
    res = ed.getPortraitSwitchRowName({_tid = hid})
    not_fca = true
  elseif unknow then
    res = "UI/alpha/1080P/common/handbook_icon_lock.png"
  else
    local at = ed.getDataTable("Avatar")
    local row = at[id]
    row = row or at[1]
    res = row.Picture
    avt_fca = row["Dynamic Model"]
    avt_spine = row["Spine Dynamic Model"]
    avt_scale = row.Scale
    is_dyna = row["Is Dynamic"]
  end
  if not ed.getSpriteFrame(res) then
    res = "UI/DOTA-HERO/Coco.jpg"
  end
  local temp = {
    res = param.res or res,
    avt_fca = avt_fca,
    avt_spine = avt_spine,
    avt_scale = avt_scale,
    is_dyna = is_dyna,
    length = length,
    not_fca = not_fca,
    rendertex = rendertex
  }
  local icon, _, headfca = ed.getHeadIcon(temp)
  icon:setPosition(ccp(40, 40))
  head:addChild(icon)
  local frame, frameicon, framefca = ed.getHeadFrame({id = fid, hide_icon_when_dyna = true})
  frame:setPosition(ccp(40, 40))
  head:addChild(frame)
  return head, frame, headfca
end

ed.getHeroIconByID = getHeroIconByID

local function getPosition(icon)
  return icon:getPosition()
end

local function getContentSize(icon)
  return icon:getContentSize()
end

local function createNameAndBg(param, size, parent)
  local nameBgOffset = 4
  nameBgOffset = param.config and param.config.nameBgOffset or nameBgOffset
  local nameBg
  if not param.no_name_bg then
    local offsetY = param.nameBgOffsetY or 0
    nameBg = ed.createSprite("UI/alpha/1080P/raid/name_bg_2.png")
    nameBg:setAnchorPoint(ccp(0, 0.5))
    nameBg:setPosition(ccp(nameBgOffset + size.width / 2, offsetY))
  end
  local paration = 28
  local font = "battleprepare_title"
  if param.config then
    paration = param.config.nameposition or paration
    font = param.config.namefont or font
  end
  local offsetY = param.nameOffsetY or 0
  local name = ed.createLabelWithFontInfo(param.name, font)
  name:setAnchorPoint(ccp(0, 0.5))
  name:setPosition(ccp(paration + size.width / 2, 0))
  if param.rechargeNum then
    if nameBg then
      nameBg:setPosition(ccp(nameBgOffset + size.width / 2, 13))
    end
    name:setPosition(ccp(paration + size.width / 2, 13))
  end
  if nameBg then
    parent:addChild(nameBg)
  end
  local key = 0
  local getTime = 0
  if param.medal ~= nil then
    local medal = ed.getPlayerName("", param.medal, {
      anchorPoint = ccp(0, 0.5)
    })
    name:addChild(medal)
    medal:setPosition(ccp(-21, 10))
    local scale = name:getContentSize().height / 20
    medal:setScale(scale)
    name:setPositionX(name:getPositionX() + 28)
  else
    name:setPositionX(name:getPositionX() + 5)
  end
  parent:addChild(name)
end

local function createVipInfo(param, vipbg, levelIcon)
  local paration = 8
  local font = "guild_join_list_guildname"
  local vipicon = ed.createSprite("UI/alpha/HVGA/recharge_vip_icon.png")
  local sizebg = getContentSize(vipbg)
  vipicon:setAnchorPoint(ccp(0.5, 0.5))
  vipicon:setPosition(ccp(paration + sizebg.width / 3, sizebg.height / 2))
  vipbg:addChild(vipicon)
  local sizeicon = getContentSize(vipicon)
  local vipnum = ed.createLabelWithFontInfo(param.vipNum, font)
  vipnum:setAnchorPoint(ccp(0, 0.5))
  vipnum:setPosition(ccp(sizeicon.width, sizeicon.height / 2))
  paration = param.config and param.config.vipposition or paration
  vipbg:setAnchorPoint(ccp(0.5, 0.5))
  vipbg:setPosition(ccp(paration + size.width / 2, size.height / 4))
  vipicon:addChild(vipnum)
  levelIcon:setPosition(ccp(paration + size.width / 2, -(size.height / 4)))
end

local function createRechargeInfo(param, size, parent)
  local label = richText:new()
  local str = param.rechargeNum
  label:setString(string.format(str, param.rechargeNum))
  label:setPosition(ccp(8 + size.width + 150, -14))
  parent:addChild(label.rootNode)
end

local function createServerInfo(param, size, parent)
  local label = ed.createLabelWithFontInfo(param.serverName, "normalButton")
  label:setAnchorPoint(ccp(0, 0.5))
  label:setPosition(ccp(size.width / 2, -30))
  parent:addChild(label)
end

local function getMedalRes(medal)
  local medalId = medal._medal_id
  for _, v in pairs(ed.getDataTable("Medal")) do
    if medalId == v.MedalID then
      return v.Picture or "UI/alpha/1080P/icon/diamond.png"
    end
  end
  return ""
end

ed.getMedalRes = getMedalRes

local function getMedalID(medal)
  return medal._medal_id
end

local function clickMedalHandler(index, x, y)
  local data
  for _, v in pairs(ed.getDataTable("Medal")) do
    if tonumber(index) == v.MedalID then
      data = v
      break
    end
  end
  if not data then
    return
  end
  ed.UITool.openView("showMedalPop", {
    data = data,
    x = x,
    y = y
  })
end

local function getPlayerName(name, medal, param)
  param = param or {}
  local node = param.root or CCNode:create()
  local autoText = ed.ui.autoText.new()
  local context = ""
  if medal and medal._medal_id then
    local madalScale = param.medalScale or 0.22
    local medalStr = string.format("<sprite src=%s clickhandler=medalInfo data=%d scale=%s name=medalIcon>", getMedalRes(medal), getMedalID(medal), madalScale)
    context = context .. medalStr
  end
  if name then
    local labelColor = param.labelColor or "ccc3(255,252,231)"
    local labelStroke = param.labelStroke or "ccc3(0,0,0)"
    local strokeSize = param.strokeSize or 1
    local nameStr = ""
    if labelStroke == "nil" then
      nameStr = string.format("<lable color=%s>%s</lable>", labelColor, name)
    else
      nameStr = string.format("<lable color=%s strokeColor=%s strokeSize=%s>%s</lable>", labelColor, labelStroke, strokeSize, name)
    end
    if param.medalRight then
      context = nameStr .. context
    else
      context = context .. nameStr
    end
  end
  if param and param.addText then
    context = context .. param.addText
  end
  autoText.sizeScale = 0.32
  if not param.notClick then
    function autoText:registerLinkBtnHandler()
      for i, info in ipairs(self.linkNodeTable) do
        local node = info.linkNode
        
        local clickhandlerKey = info.clickhandler
        local data = info.data
        self.touchMonitor:btRegisterButtonClick({
          button = node,
          key = "linkBtnlick" .. i,
          pressHandler = function(transParam, x, y)
            local handler = self.registerHandler[clickhandlerKey]
            if handler then
              handler(data, x, y)
            end
          end,
          liftHandler = function(event, x, y)
            if ed.newShowMedalPop then
              ed.newShowMedalPop:destroy({skipAnim = false})
              ed.newShowMedalPop = nil
            end
          end,
          clickHandler = function(event, x, y)
            if ed.newShowMedalPop then
              ed.newShowMedalPop:destroy({skipAnim = false})
              ed.newShowMedalPop = nil
            end
          end,
          force = true,
          clickInterval = 0.5
        })
      end
    end
  end
  autoText:initParam({
    context = context,
    priority = -300,
    fontSize = param.fontSize,
    fontName = param.fontName or ed.font
  })
  if not param.notClick then
    autoText:addRegisterHandler("medalInfo", function(index, x, y)
      clickMedalHandler(index, x, y)
    end)
  end
  local width, height = autoText:getCurContentSize()
  if param.anchorPoint then
    if param.disableOffset then
      autoText.node:setPositionX(-param.anchorPoint.x * width)
    elseif param.anchorPoint.x == 0.5 and autoText.spriteNode.medalIcon then
      autoText.spriteNode.medalIcon:setPositionX(width / 2 + 8 - 80)
      autoText.node:setPositionX(-param.anchorPoint.x * width - 8)
    elseif autoText.spriteNode.medalIcon then
      local posx = autoText.spriteNode.medalIcon:getPositionX()
      if param.anchorPoint.x == 0 then
        autoText.spriteNode.medalIcon:setPositionX(posx - 8)
        autoText.node:setPositionX(-param.anchorPoint.x * width + 8)
      elseif param.anchorPoint.x == 1 then
        if param.medalRight then
          autoText.spriteNode.medalIcon:setPositionX(posx + 7)
          autoText.node:setPositionX(-param.anchorPoint.x * width - 13)
        else
          autoText.spriteNode.medalIcon:setPositionX(posx - 8)
          autoText.node:setPositionX(-param.anchorPoint.x * width - 5)
        end
      end
    else
      autoText.node:setPositionX(-param.anchorPoint.x * width)
    end
  elseif param.left then
    if autoText.spriteNode.medalIcon then
      local posx = autoText.spriteNode.medalIcon:getPositionX()
      autoText.spriteNode.medalIcon:setPositionX(posx - 10)
    end
  elseif param.right then
    if autoText.spriteNode.medalIcon then
      autoText.node:setPositionX(-width - 20)
      local posx = autoText.spriteNode.medalIcon:getPositionX()
      autoText.spriteNode.medalIcon:setPositionX(width + 20)
    else
      autoText.node:setPositionX(-width)
    end
  else
    autoText.node:setPositionX(-width / 2)
  end
  node:addChild(autoText.node)
  return node, width, autoText
end

ed.getPlayerName = getPlayerName

local function getWholeHeadIcon(param)
  local node = CCSprite:create()
  local vipbg
  local headIcon, _, headfca = getHeroIconByID(param)
  if param.scale then
    headIcon:setScale(param.scale)
  end
  if param.offset then
    headIcon:setPosition(param.offset.x, param.offset.y)
  end
  node:addChild(headIcon)
  local size = getContentSize(headIcon)
  if param.name then
    createNameAndBg(param, size, node)
  end
  local levelIcon = getLevelIcon(param)
  if levelIcon then
    local offx, offy = 0, 0
    if param.lvoffset then
      offx, offy = param.lvoffset.x, param.lvoffset.y
    end
    local paration = 8
    paration = param.config and param.config.levelposition or paration
    levelIcon:setAnchorPoint(ccp(0.5, 0.5))
    levelIcon:setPosition(ccp(paration + size.width / 2 + offx, 0 + offy))
    if param.rechargeNum then
      levelIcon:setPosition(ccp(paration + size.width / 2 + offx, 12 + offy))
    end
    node:addChild(levelIcon)
  end
  if param.rechargeNum then
    createRechargeInfo(param, size, node)
  end
  if param.serverName then
    createServerInfo(param, size, node)
  end
  return node, headIcon, headfca
end

ed.getWholeHeadIcon = getWholeHeadIcon

function ed.getMultiplayerHeadIcon(param)
  local node = CCNode:create()
  if not param.noBg then
    local bg = ed.createSprite("UI/alpha/HVGA/multiplayer_battle/bg1.png")
    bg:setPosition(ccp(0, 30))
    node:addChild(bg)
  end
  local headIcon = getHeroIconByID(param)
  headIcon:setAnchorPoint(ccp(0.5, 0.5))
  headIcon:setPosition(ccp(0, 54))
  node:addChild(headIcon)
  local nameBg = ed.createSprite("UI/alpha/1080P/battleresult/name_bg.png")
  nameBg:setAnchorPoint(ccp(0.5, 0.5))
  nameBg:setPosition(ccp(0, -5))
  nameBg:setScale(1.2)
  nameBg:setScaleX(1.5)
  node:addChild(nameBg)
  local name = ed.createLabelWithFontInfo(param.name, "multiplayer_playername")
  name:setAnchorPoint(ccp(0.5, 0.5))
  name:setPosition(ccp(0, -5))
  node:addChild(name)
  if param.chessscore then
    local rank = ed.AutoChessRankManager:getRankGradeInfoByScore(param.chessscore or 0)
    local gst = ed.createLabelWithFontInfo(rank.name or "", "multiplayer_playergst")
    gst:setAnchorPoint(ccp(0.5, 0.5))
    gst:setPosition(ccp(0, -38))
    node:addChild(gst)
  end
  local levelIcon = getLevelIcon(param)
  levelIcon:setAnchorPoint(ccp(0.5, 0.5))
  levelIcon:setPosition(ccp(-25, 35))
  node:addChild(levelIcon)
  return node
end

function ed.getCustomHeadIcon(param)
  local node = CCNode:create()
  param = param or {}
  local headScale = param.headScale or 1
  local headPos = param.headPos or ccp(0, 0)
  local namePos = param.namePos or ccp(0, 0)
  local levelPos = param.levelPos or ccp(0, 0)
  local showNameBg = param.showNameBg or false
  local headIcon = getHeroIconByID(param)
  headIcon:setAnchorPoint(ccp(0.5, 0.5))
  headIcon:setPosition(headPos)
  headIcon:setScale(headScale)
  node:addChild(headIcon)
  if showNameBg then
    local nameBg = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_name_bg.png")
    nameBg:setAnchorPoint(ccp(0, 0.5))
    nameBg:setPosition(ccp(namePos.x - 10, namePos.y))
    node:addChild(nameBg)
  end
  local name = ed.createLabelWithFontInfo(param.name, "multiplayer_playername")
  name:setAnchorPoint(ccp(0, 0.5))
  name:setPosition(namePos)
  node:addChild(name)
  local levelIcon = getLevelIcon(param)
  levelIcon:setAnchorPoint(ccp(0.5, 0.5))
  levelIcon:setPosition(levelPos)
  node:addChild(levelIcon)
  return node, name, levelIcon
end

local function getWholeHeadIconVertical(param)
  local node = CCNode:create()
  local headIcon = getHeroIconByID(param)
  if param.scale then
    headIcon:setScale(param.scale)
  end
  node:addChild(headIcon)
  local x, y = getPosition(headIcon)
  local size = getContentSize(headIcon)
  if param.name then
    local paration = 28
    local font = "guild_join_list_guildname"
    if param.config then
      paration = param.config.nameposition or paration
      font = param.config.namefont or font
    end
    local nameBg = ed.createSprite("UI/alpha/HVGA/pvp/pvp_replay_name_bg.png")
    nameBg:setAnchorPoint(ccp(0.5, 0.5))
    nameBg:setPosition(ccp(x, y - size.height / 2 - paration))
    if param.name_scaleX then
      nameBg:setScaleX(param.name_scaleX)
    end
    if param.name_scale then
      nameBg:setScale(param.name_scale)
    end
    node:addChild(nameBg)
    local name = ed.createLabelWithFontInfo(param.name, font)
    name:setAnchorPoint(ccp(0.5, 0.5))
    name:setPosition(ccp(x, y - size.height / 2 - paration))
    node:addChild(name)
    local len = string.len(param.name)
    local nameOffX = 3
    if len == 18 then
      nameOffX = 9
    elseif len == 21 then
      nameOffX = 15
    end
    local key = 0
    local getTime = 0
    if param.medal ~= nil then
      key = param.medal.medal_id or 0
      getTime = param.medal.get_time or 0
    end
    local cfg = {
      titleId = key,
      getTime = getTime,
      offX = -45,
      offY = -14,
      scale = 0.5,
      nameOffX = nameOffX
    }
  end
  local levelIcon = getLevelIcon(param)
  if levelIcon then
    local paration = 12
    paration = param.config and param.config.levelposition or paration
    levelIcon:setAnchorPoint(ccp(0.5, 0.5))
    levelIcon:setPosition(ccp(x - size.width / 2 + paration, y - size.height / 2 + paration))
    node:addChild(levelIcon)
  end
  return node
end

ed.getWholeHeadIconVertical = getWholeHeadIconVertical

local function scaleNodeBySideLen(node, len, mode)
  mode = mode or "h"
  local size = node:getContentSize()
  local w = size.width
  local h = size.height
  if mode == "w" then
    node:setScale(len / w)
  elseif mode == "h" then
    node:setScale(len / h)
  end
end

ed.scaleNodeBySideLen = scaleNodeBySideLen

local function setNodeMaxWidth(node, mw)
  if tolua.isnull(node) then
    return
  end
  local w = node:getContentSize().width
  if mw < w then
    ed.scaleNodeBySideLen(node, mw, "w")
  end
end

ed.setNodeMaxWidth = setNodeMaxWidth

local function setNodeMaxHeight(node, mh)
  if tolua.isnull(node) then
    return
  end
  local h = node:getContentSize().height
  if mh < h then
    ed.scaleNodeBySideLen(node, mh, "h")
  end
end

ed.setNodeMaxHeight = setNodeMaxHeight

local function fixNodeSize(node, size)
  if not size then
    return
  end
  local ns = node:getContentSize()
  local nw, nh = ns.width, ns.height
  local w, h = size.width, size.height
  if 0 < w then
    node:setScaleX(w / nw)
  end
  if 0 < h then
    node:setScaleY(h / nh)
  end
end

ed.fixNodeSize = fixNodeSize

local function sumNodeSize(nodes)
  local w, h = 0, 0
  for k, v in pairs(nodes) do
    local size = v:getContentSize()
    local sx = v:getScaleX()
    local sy = v:getScaleY()
    w = w + size.width * sx
    h = h + size.height * sy
  end
  return w, h
end

ed.sumNodeSize = sumNodeSize

local function getWorldPos(node, offset)
  if tolua.isnull(node) then
    print("invalid node in getWorldPos")
    return
  end
  local parent = node:getParent()
  local pos = ccp(node:getPosition())
  local wPos = parent:convertToWorldSpace(pos)
  return ccpAdd(wPos, offset or ccp(0, 0))
end

ed.getWorldPos = getWorldPos

local function getCenterPos(node, offset)
  if tolua.isnull(node) then
    print("getCenterPos : invalid node")
    return
  end
  local size = node:getContentSize()
  local w, h = size.width, size.height
  w = w * node:getScaleX()
  h = h * node:getScaleY()
  return ccpAdd(ccp(w / 2, h / 2), offset or ccp(0, 0))
end

ed.getCenterPos = getCenterPos

local function left2Point(node, pos, offset)
  if tolua.isnull(node) then
    print("left2Point : invalid node")
    return
  end
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local size = node:getContentSize()
  local sx = node:getScaleX()
  node:setPosition(ccpAdd(pos, ccp(-size.width * sx * (1 - anchor.x) - offset, 0)))
end

ed.left2Point = left2Point

local function left2(node, refer, offset)
  if tolua.isnull(node) then
    print("left2 : invalid node")
    return
  end
  local pos = ed.getLeftSidePos(refer, offset)
  ed.left2Point(node, pos)
end

ed.left2 = left2

local function getLeftSidePos(node, offset)
  if tolua.isnull(node) then
    print("getLeftSidePos : invalid node")
    return
  end
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local x, y = node:getPosition()
  local size = node:getContentSize()
  local sx = node:getScaleX()
  x = x - anchor.x * size.width * sx - offset
  return ccp(x, y)
end

ed.getLeftSidePos = getLeftSidePos

local function right2Point(node, pos, offset)
  if tolua.isnull(node) then
    print("right2Point : invalid node")
    return
  end
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local size = node:getContentSize()
  local sx = node:getScaleX()
  node:setPosition(ccpAdd(pos, ccp(size.width * sx * anchor.x + offset, 0)))
end

ed.right2Point = right2Point

local function right2(node, refer, offset, params)
  if tolua.isnull(node) then
    print("right2 : invalid node")
    return
  end
  local pos = ed.getRightSidePos(refer, offset, params)
  ed.right2Point(node, pos)
end

ed.right2 = right2

local function getRightSidePos(node, offset, params)
  if tolua.isnull(node) then
    print("getRightSidePos : invalid node")
    return
  end
  params = params or {}
  local offsety = params.offsety or 0
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local x, y = node:getPosition()
  local size = node:getContentSize()
  local sx = node:getScaleX()
  x = x + (1 - anchor.x) * size.width * sx + offset
  y = y + offsety
  return ccp(x, y)
end

ed.getRightSidePos = getRightSidePos

local function below2Point(node, pos, offset)
  if tolua.isnull(node) then
    print("below2Point : invalid node")
    return
  end
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local size = node:getContentSize()
  local sy = node:getScaleY()
  node:setPosition(ccpAdd(pos, ccp(0, -size.height * sy * (1 - anchor.y) - offset)))
end

ed.below2Point = below2Point

local function below2(node, refer, offset)
  if tolua.isnull(node) then
    print("below2 : invalid node")
    return
  end
  local pos = ed.getBottomPos(refer, offset)
  ed.below2Point(node, pos)
end

ed.below2 = below2

local function getBottomPos(node, offset)
  if tolua.isnull(node) then
    print("getBottomPos : invalid node")
    return
  end
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local x, y = node:getPosition()
  local size = node:getContentSize()
  local sy = node:getScaleY()
  y = y - anchor.y * size.height * sy - offset
  return ccp(x, y)
end

ed.getBottomPos = getBottomPos

local function above2Point(node, pos, offset)
  if tolua.isnull(node) then
    print("above2Point : invalid node")
    return
  end
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local size = node:getContentSize()
  local sy = node:getScaleY()
  node:setPosition(ccpAdd(pos, ccp(0, size.height * sy * anchor.y + offset)))
end

ed.above2Point = above2Point

local function above2(node, refer, offset)
  if tolua.isnull(node) then
    print("above2 : invalid node")
    return
  end
  local pos = ed.getTopSidePos(refer, offset)
  ed.above2Point(node, pos)
end

ed.above2 = above2

local function getTopSidePos(node, offset)
  if tolua.isnull(node) then
    print("getTopSidePos : invalid node")
    return
  end
  offset = offset or 0
  local anchor = node:getAnchorPoint()
  local x, y = node:getPosition()
  local size = node:getContentSize()
  local sy = node:getScaleY()
  y = y + (1 - anchor.y) * size.height * sy + offset
  return ccp(x, y)
end

ed.getTopSidePos = getTopSidePos

local function setNodeAnchor(node, anchor)
  if tolua.isnull(node) then
    print("setNodeAnchor : invalid node")
    return
  end
  local a = node:getAnchorPoint()
  local ax, ay = a.x, a.y
  local x, y = node:getPosition()
  local size = node:getContentSize()
  local sx, sy = node:getScaleX(), node:getScaleY()
  local w, h = size.width, size.height
  local cax, cay = anchor.x, anchor.y
  local cx, cy = x, y
  cx = cx - w * (ax - cax) * sx
  cy = cy - h * (ay - cay) * sy
  node:setAnchorPoint(anchor)
  node:setPosition(ccp(cx, cy))
end

ed.setNodeAnchor = setNodeAnchor
local tag_res = {
  Diamond = "UI/alpha/HVGA/chat/chat_icon_treasure_diamond.png",
  Gold = "UI/alpha/HVGA/chat/chat_icon_treasure_gold.png",
  Wood = "UI/alpha/HVGA/chat/chat_icon_treasure_wood.png",
  Iron = "UI/alpha/HVGA/chat/chat_icon_treasure_iron.png",
  Item = "UI/alpha/HVGA/chat/chat_icon_treasure_exp.png"
}

local function getAncientsNameTag(invitation_count)
  invitation_count = invitation_count or 0
  local tag_res = "UI/alpha/HVGA/chat/chat_icon_treasure_monument.png"
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "tag"},
      layout = {
        anchor = ccp(0, 0),
        layout = ccp(0, 0)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "1",
            text = T("\227\128\144"),
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        },
        {
          t = "Sprite",
          base = {name = "2", res = tag_res}
        },
        {
          t = "Label",
          base = {
            name = "3",
            text = T("\231\165\158\231\167\152\233\129\151\232\191\185\227\128\145"),
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        },
        {
          t = "Label",
          base = {
            name = "4",
            text = T("(\229\143\139\230\131\133\231\130\185\239\188\154%d)", invitation_count),
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  local size = ui.tag:getContentSize()
  size.height = size.height - 6
  container:setContentSize(size)
  return container
end

ed.getAncientsNameTag = getAncientsNameTag

local function getRealArenaChallengeNameTag(pvp_rule)
  pvp_rule = pvp_rule or "bo3"
  local tag_res = "UI/alpha/HVGA/chat/chat_icon_treasure_kings.png"
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "tag"},
      layout = {
        anchor = ccp(0, 0),
        layout = ccp(0, 0)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "1",
            text = T("\227\128\144"),
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        },
        {
          t = "Sprite",
          base = {name = "2", res = tag_res}
        },
        {
          t = "Label",
          base = {
            name = "3",
            text = T("%s\230\168\161\229\188\143\227\128\145", ed.realarena.pvp_rule_string[pvp_rule]),
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  local size = ui.tag:getContentSize()
  size.height = size.height - 6
  container:setContentSize(size)
  return container
end

ed.getRealArenaChallengeNameTag = getRealArenaChallengeNameTag

local function createRedBagLinkText(content)
  local tag_res = "UI/alpha/HVGA/chat/chat_icon_treasure_gift.png"
  local str = string.match(content, "\227\128\144(.+)")
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "tag"},
      layout = {
        anchor = ccp(0, 0),
        layout = ccp(0, 0)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "1",
            text = "\227\128\144",
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        },
        {
          t = "Sprite",
          base = {name = "2", res = tag_res}
        },
        {
          t = "Label",
          base = {
            name = "3",
            text = str,
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  container:setContentSize(ui.tag:getContentSize())
  return container
end

ed.createRedBagLinkText = createRedBagLinkText

local function getLadderFightNameTag()
  local tag_res = "UI/alpha/HVGA/chat/chat_icon_treasure_kings.png"
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "tag"},
      layout = {
        anchor = ccp(0, 0),
        layout = ccp(0, 0)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "1",
            text = T("\227\128\144"),
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        },
        {
          t = "Sprite",
          base = {name = "2", res = tag_res}
        },
        {
          t = "Label",
          base = {
            name = "3",
            text = T("\231\171\158\230\138\128\229\156\186\227\128\145"),
            size = 20
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  local size = ui.tag:getContentSize()
  size.height = size.height - 6
  container:setContentSize(size)
  return container
end

ed.getLadderFightNameTag = getLadderFightNameTag

local function getEnemyTeamTag(key)
  local info = ed.getRichTextExtraInfo(key)
  if not info then
    return
  end
  local size = CCSizeMake(280, 90)
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setContentSize(size)
  local offX = 30
  local offY = 0
  local summerys = ed.SortHeroesByMaxRange(info._ladder_fight._heroes or {})
  for idx, summery in ipairs(summerys) do
    local hero = ed.HeroCreate()
    hero:setup(summery)
    local icon = ed.readhero.createIconByHero(hero, {state = "idle"})
    icon.icon:setPosition(ccp(offX + (idx - 1) * 55, offY))
    icon.icon:setScale(0.6)
    container:addChild(icon.icon)
  end
  return container, size
end

ed.getEnemyTeamTag = getEnemyTeamTag

function ed.getMultiplayerTag(content)
  local tag_res = "UI/alpha/1080P/chat/emoji/emoji_shout.png"
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "tag"},
      layout = {
        anchor = ccp(0, 0),
        layout = ccp(0, 0)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "1",
            text = T("\227\128\144"),
            size = 15
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        },
        {
          t = "Sprite",
          base = {name = "2", res = tag_res},
          config = {
            fix_scale = {y = 0.32, x = 0.32}
          }
        },
        {
          t = "Label",
          base = {
            name = "3",
            text = T(content .. "\227\128\145"),
            size = 15
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  local size = ui.tag:getContentSize()
  container:setContentSize(size)
  return container
end

function ed.getMedalPlayerTag(content, medalId)
  local tag_res = ""
  if medalId and medalId ~= 0 then
    tag_res = ed.getMedalRes({_medal_id = medalId})
  end
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  local ui = {}
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "HorizontalNode",
      base = {name = "tag"},
      layout = {
        anchor = ccp(0, 0),
        layout = ccp(0, 0)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "1",
            text = T("\227\128\144"),
            size = 15
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        },
        {
          t = "Sprite",
          base = {
            name = "2",
            res = tag_res,
            offset = -5
          },
          config = {
            fix_scale = {y = 0.17, x = 0.17}
          }
        },
        {
          t = "Label",
          base = {
            name = "3",
            text = T(content .. "\227\128\145"),
            size = 15,
            offset = -3
          },
          config = {
            color = ccc3(255, 255, 102)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  local size = ui.tag:getContentSize()
  size.height = size.height
  container:setContentSize(size)
  return container
end

local function createNode(param, parent, z)
  local node = ed.readnode.getFeralNode(param)
  if not tolua.isnull(parent) then
    parent:addChild(node, z or 0)
  end
  return node
end

ed.createNode = createNode

local function getCCNode(node)
  if type(node) == "userdata" then
    return node
  elseif type(node) == "table" and not tolua.isnull(node.node) then
    return node.node
  end
  return nil
end

ed.getCCNode = getCCNode

local function addChild(parent, child, z)
  if tolua.isnull(parent) then
    return
  end
  child = ed.getCCNode(child)
  if tolua.isnull(child) then
    return
  end
  z = z or 0
  parent:addChild(child, z)
end

ed.addChild = addChild

local function setPosition(node, pos)
  local node = ed.getCCNode(node)
  if tolua.isnull(node) then
    return
  end
  if not pos then
    return
  end
  node:setPosition(pos)
end

ed.setPosition = setPosition

local function setAnchor(node, anchor)
  local node = ed.getCCNode(node)
  if tolua.isnull(node) then
    return
  end
  if not anchor then
    return
  end
  node:setAnchorPoint(anchor)
end

ed.setAnchor = setAnchor

local function setZOrder(node, z)
  local node = ed.getCCNode(node)
  if tolua.isnull(node) then
    return
  end
  if not z then
    return
  end
  node:setZOrder(z)
end

ed.setZOrder = setZOrder

local function getMaxNodewh(list)
  local w, h = 0, 0
  for i, v in pairs(list) do
    local size = v:getContentSize()
    local vw, vh = size.width, size.height
    w = math.max(w, vw)
    h = math.max(h, vh)
  end
  return w, h
end

ed.getMaxNodewh = getMaxNodewh

local function fixs9sButtonSize(param)
  if tolua.isnull(param.button) then
    return
  end
  if tolua.isnull(param.label) then
    return
  end
  local mode = param.mode or "fit2Label"
  local anchor = param.anchor or "center"
  local offset = param.offset or 10
  local bSize = param.button:getContentSize()
  local lSize = param.label:getContentSize()
  local res = {}
  if lSize.width + offset * 2 > bSize.width then
    if mode == "fit2Label" then
      param.button:setContentSize(CCSizeMake(lSize.width + offset * 2, bSize.height))
      if param.press then
        param.press:setContentSize(CCSizeMake(lSize.width + offset * 2, bSize.height))
      end
      param.label:setPosition(ed.getCenterPos(param.button))
      res.scaleSize = CCSizeMake(lSize.width + offset * 2, bSize.height)
    end
    if anchor == "left" then
      local x, y = param.button:getPosition()
      res.position = ccp(x + (lSize.width + offset * 2 - bSize.width) / 2, y)
      param.button:setPosition(res.position)
    elseif anchor == "right" then
      local x, y = param.button:getPosition()
      res.position = ccp(x - (lSize.width + offset * 2 - bSize.width) / 2, y)
      param.button:setPosition(res.position)
    end
  end
  return res
end

ed.fixs9sButtonSize = fixs9sButtonSize

local function checkInstallerPackage()
  if EDLanguageArea == "native" then
    return false
  end
  local currentVersion = CCUserDefault:sharedUserDefault():getStringForKey("current-version")
  if original_version then
    local orgi = original_version .. ".zip"
    return orgi == currentVersion
  end
  return false
end

local function createMainFrameHead(param)
  if checkInstallerPackage() then
    local node = CCSprite:create()
    return node, {}
  end
  local param = param or {}
  local avatar = param.avatar or 0
  local vip = param.vip
  local playerName = param.name
  local playerLevel = param.level
  local isBabel, levelPy = false, 5
  playerLevel, isBabel = ed.player:getNewLevel(param.babelLevel, playerLevel)
  local lvColor = ccc3(241, 235, 206)
  if isBabel then
    lvColor = ccc3(251, 206, 16)
    levelPy = 8
  end
  local node = CCSprite:create()
  local head, headicon = getHeroIconByID(param)
  local id = ed.analyzeAvatar(avatar).avatarFrame
  if (id or 0) == 0 then
    id = 1
  end
  local name_bg = {
    "UI/alpha/HVGA/main_head_name_bg_silver.png",
    "UI/alpha/HVGA/main_head_name_bg_gold.png"
  }
  local head_bg = {
    "UI/alpha/HVGA/main_head_bg_silver.png",
    "UI/alpha/HVGA/main_head_bg_gold.png"
  }
  local levelBg = head_bg[1]
  if 0 < vip then
    levelBg = head_bg[2]
  end
  levelBg = ed.getLevelBg(param.babelLevel, vip, levelBg)
  local ui = {}
  local readNode = ed.readnode.create(node, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "head_bg",
        res = levelBg,
        z = 0
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(20, -11)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "vip_bg",
        res = "UI/alpha/HVGA/recharge_vip_bg.png"
      },
      layout = {
        position = ccp(65, 38)
      },
      config = {
        visible = 0 < vip
      }
    },
    {
      t = "Sprite",
      base = {
        name = "vip_icon",
        res = "UI/alpha/HVGA/recharge_vip_icon.png",
        z = 10
      },
      layout = {
        position = ccp(55, 38)
      },
      config = {
        visible = 0 < vip
      }
    },
    {
      t = "Label",
      base = {
        name = "vip",
        text = vip,
        size = 16,
        parent = "vip_icon",
        z = 10
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, 9)
      },
      config = {
        visible = 0 < vip,
        color = ccc3(241, 235, 206),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = 0 < vip and name_bg[2] or name_bg[1],
        z = 3
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(32, -30)
      },
      config = {
        visible = playerName ~= ""
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = playerName,
        size = 16,
        parent = "name_bg"
      },
      layout = {mediate = true},
      config = {
        color = ccc3(241, 235, 206),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Label",
      base = {
        name = "level",
        text = playerLevel,
        size = 16,
        z = 8
      },
      layout = {
        position = ccp(55, levelPy)
      },
      config = {
        color = ccc3(241, 235, 206)
      }
    }
  }
  readNode:addNode(ui_info)
  if head then
    head:setPosition(ccp(10, 20))
    node:addChild(head)
    ui.head = head
  end
  return node, ui
end

ed.createMainFrameHead = createMainFrameHead

function ed.createIconList(config, text)
  local config = config or {}
  local str = string.format("<text|op_act_red| %s>", text)
  local types = {
    money = "UI/alpha/HVGA/task_gold_icon_2.png",
    rmb = "UI/alpha/HVGA/task_rmb_icon_2.png",
    crystal = "UI/alpha/HVGA/warschool/resource_crystal.png",
    iron = "UI/alpha/HVGA/warschool/resource_iron.png",
    wood = "UI/alpha/HVGA/warschool/resource_wood.png",
    crusadepoint = "UI/alpha/HVGA/money_dragonscale_small.png",
    energybean = "UI/alpha/HVGA/dreamland/money_dreampoint2_small.png"
  }
  for k, item in pairs(config) do
    local type = item.type
    local scale = item.scale or 1
    local amount = item.amount
    local id = item.id
    if type == "rand_soul" then
      str = str .. string.format("<randsoul|25|%s><text|op_act_red|X%s >", scale, amount)
    elseif type == "item" then
      str = str .. string.format("<item|%s|%s><text|op_act_red|X%s >", id, scale, amount)
    else
      local color = "op_act_red"
      if type == "crusadepoint" or type == "energybean" then
        color = "op_act_white"
      end
      str = str .. string.format("<sprite|%s|%s><text|%s|X%s >", types[type], scale, color, amount)
    end
  end
  local node = CCNode:create()
  local richtext = richText:new()
  richtext:setString(str)
  node:addChild(richtext.rootNode)
  return node
end

function ed.createGuildAvatar(avatar, avatarFrame)
  if not avatar and not avatarFrame then
    return
  end
  local node = CCSprite:create()
  local res, fres = "", ""
  local datas = ed.getDataTable("GuildAvatarFrame")
  local avatarFrameId = datas[avatarFrame] and avatarFrame or 1
  fres = datas[avatarFrameId].Picture
  local frame = ed.createSprite(fres)
  local datas = ed.getDataTable("GuildAvatar")
  local avatarId = datas[avatar] and avatar or 1
  res = datas[avatarId].Picture
  local icon = ed.createSprite(res)
  icon:setScale(70 / icon:getContentSize().width - 0.05)
  local clippingNode = createClippingNodeOnly("UI/alpha/1080P/common/main_head_mask.png", nil)
  clippingNode:addChild(icon)
  node:addChild(clippingNode)
  node:addChild(frame)
  node.icon = icon
  return node
end

function ed.playFadeInRotateByAnim(node, cfg)
  local config = {}
  if cfg ~= nil then
    config = cfg
  end
  if node then
    node:setOpacity(0)
    local fadeValue = config.fadeValue or 0.2
    local duration = config.duration or 5
    local angle = config.angle or 360
    local fade = CCFadeIn:create(fadeValue)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(node) then
          local rotate = CCRotateBy:create(duration, angle)
          rotate = CCRepeatForever:create(rotate)
          node:runAction(rotate)
        end
      end, EDDebug)
    end)
    node:runAction(ed.readaction.create({
      t = "seq",
      fade,
      func
    }))
  end
end

function ed:fastCreateDragList(param)
  self.itemIconList = {}
  local listData = param.listData
  local createIconHandler = param.createIconHandler
  local container = param.container
  local cliprect = param.cliprect
  local doPressIn = param.doPressIn
  local doClickInList = param.doClickInList
  local cancelClickIn = param.cancelClickIn
  local cancelPressIn = param.cancelPressIn
  local icon_ori_x = param.icon_ori_x
  local icon_gap_x = param.icon_gap_x
  local icon_ori_y = param.icon_ori_y
  local icon_gap_y = param.icon_gap_y
  local colunNum = param.colunNum
  local zorder = param.zorder or 0
  local isDragX = param.dragx
  local noshade = param.noshade
  local upShade = param.upShade
  local downShade = param.downShade
  
  local function efun()
  end
  
  local info = {
    cliprect = cliprect,
    container = container,
    zorder = zorder,
    doPressIn = doPressIn and doPressIn(self.itemIconList) or efun,
    doClickIn = doClickInList and doClickInList(self.itemIconList) or efun,
    cancelClickIn = cancelClickIn and cancelClickIn(self.itemIconList) or efun,
    cancelPressIn = cancelPressIn and cancelPressIn(self.itemIconList) or efun,
    priority = param.touchpriority,
    noshade = noshade,
    upShade = upShade,
    downShade = downShade
  }
  self.dragList = ed.draglist.create(info)
  for k, data in ipairs(listData) do
    local item, portrait = createIconHandler(data, k)
    if item then
      self.dragList:addItem(item)
      local temp = {
        icon = item,
        data = data,
        portrait = portrait
      }
      table.insert(self.itemIconList, temp)
    end
  end
  for k, item in ipairs(self.itemIconList) do
    local icon = item.icon
    local x = icon_ori_x + icon_gap_x * ((k - 1) % colunNum)
    local y = icon_ori_y - icon_gap_y * math.floor((k - 1) / colunNum)
    icon:setPosition(ccp(x, y))
  end
  if isDragX then
    self.dragList:initListWidth(#self.itemIconList * icon_gap_x)
  else
    self.dragList:initListHeight(math.ceil(#self.itemIconList / colunNum) * icon_gap_y)
  end
  return self.dragList
end

function ed.getPlayerSummary()
  local summary = {}
  summary._avatar = ed.player:getAvatar()
  summary._name = ed.player:getName()
  summary._level = ed.player:getLevel()
  return summary
end

local function getChessTeamHead(param)
  param = param or {}
  local state = param.type
  local scale = param.scale
  local id = param.id and ed.analyzeAvatar(param.id).avatarFrame
  local head, headicon = ed.getHeadIcon(param)
  if tolua.isnull(headicon) then
    return CCSprite:create()
  end
  local container = CCSprite:create()
  local size = headicon:getContentSize()
  container:setContentSize(size)
  local center = ed.getCenterPos(container)
  local frameres = "UI/alpha/1080P/mainhead/main_head_frame_silver.png"
  if id and id ~= 0 then
    local row = ed.getDataTable("AvatarFrame")[id]
    if not row then
      return CCSprite:create()
    end
    frameres = row.Picture
  end
  local frame = ed.createSprite(frameres)
  head:setPosition(center)
  container:addChild(head)
  container.head = head
  container.headicon = headicon
  frame:setPosition(ccpAdd(center, ccp(0, 1)))
  container:addChild(frame)
  if scale then
    container:setScale(scale)
  end
  return container
end

ed.getChessTeamHead = getChessTeamHead

function ed.replaceLabel(orgLabel, nedLabel, param)
  local label = orgLabel
  if not label then
    EDLog("replaceLabel's orgLabel is not existed")
    return
  end
  local x, y = label:getPosition()
  local anchor = label:getAnchorPoint()
  local parent = label:getParent()
  label:removeFromParentAndCleanup(true)
  parent:addChild(nedLabel)
  local offx, offy = 0, 0
  if param then
    offx, offy = param.offx or 0, param.offy or 0
  end
  nedLabel:setPosition(ccp(x + offx, y + offy))
  nedLabel:setAnchorPoint(anchor)
end

function ed.discoverNode(orgLabel, nedLabel, param)
  local label = orgLabel
  if not label then
    EDLog("replaceLabel's orgLabel is not existed")
    return
  end
  local x, y = label:getPosition()
  local anchor = label:getAnchorPoint()
  local parent = label:getParent()
  label:setVisible(false)
  parent:addChild(nedLabel, 5)
  local offx, offy = param.offx or 0, param.offy or 0
  nedLabel:setPosition(ccp(x + offx, y + offy))
  nedLabel:setAnchorPoint(anchor)
end

function ed.offsetNode(node, offx, offy)
  if not node then
    EDLog("node is not existed")
    return
  end
  offx = offx or 0
  offy = offy or 0
  local px, py = node:getPosition()
  node:setPosition(px + offx, py + offy)
end

local function limitWidth(self, width, horizontalAlignment, verticalAlignment)
  local ha = horizontalAlignment or kCCTextAlignmentLeft
  local va = verticalAlignment or kCCVerticalTextAlignmentCenter
  if width < self:getContentSize().width then
    self:setHorizontalAlignment(ha)
    self:setVerticalAlignment(va)
    self:setDimensions(CCSizeMake(width, 0))
  end
end

rawset(CCLabelTTF or {}, "limitWidth", limitWidth)

local function limitWidthByScale(self, width)
  if width <= 0 then
    width = 1
  end
  local reScale = width / self:getContentSize().width
  if 1 < reScale then
    reScale = 1
    self:setScale(1)
  else
    self:setScale(reScale)
  end
end

rawset(CCLabelTTF or {}, "limitWidthByScale", limitWidthByScale)

local function limitWidthBySize(self, width)
  if width <= 0 then
    width = 1
  end
  local reScale = width / self:getContentSize().width
  if 1 < reScale then
    reScale = 1
  else
    self:setFontSize(reScale * self:getFontSize())
  end
end

rawset(CCLabelTTF or {}, "limitWidthBySize", limitWidthBySize)

local function limitSizeByScale(self, limitWidth, limitHeight, threshold)
  local dimensionSize = CCSizeMake(limitWidth, 0)
  ed.setLabelDimensions(self, dimensionSize)
  local textSize = self:getContentSize()
  if limitWidth > textSize.width then
    self:setScale(1)
    return
  end
  if nil == limitHeight or limitHeight <= 0 or limitHeight > textSize.height then
    self:setScale(1)
    return
  end
  local low = 0
  local high = 1
  local cur = math.sqrt(limitHeight / textSize.height)
  threshold = threshold or 0.01
  repeat
    dimensionSize.width = limitWidth / cur
    ed.setLabelDimensions(self, dimensionSize)
    textSize = self:getContentSize()
    if limitHeight < textSize.height * cur then
      high = cur
    else
      low = cur
    end
    if high > low + threshold or high ~= low and cur == high then
      cur = low + (high - low) * 0.5
    elseif high ~= low and high <= low + threshold then
      high = low
      cur = high
    else
      self:setScale(cur)
      break
    end
  until false
end

rawset(CCLabelTTF or {}, "limitSizeByScale", limitSizeByScale)

local function complexLabelLimitWidthBySize(label, width)
  if width <= 0 then
    width = 1
  end
  local totalWidth = 0
  local childCount = label:getChildrenCount()
  local children = label:getChildren()
  if children then
    for i = 0, children:count() - 1 do
      local child = children:objectAtIndex(i)
      if tolua.type(child) == "CCLabelTTF" then
        totalWidth = totalWidth + child:getContentSize().width
      elseif tolua.type(child) == "CCSprite" then
        totalWidth = totalWidth + child:getContentSize().width
      else
        EDDebug(tolua.type(child) .. " not solved!")
      end
      i = i + 1
    end
  end
  local reScale = width / totalWidth
  if 1 < reScale then
    reScale = 1
  elseif children then
    for i = 0, children:count() - 1 do
      local child = children:objectAtIndex(i)
      local childPre
      if 0 < i then
        childPre = children:objectAtIndex(i - 1)
      end
      if tolua.type(child) == "CCLabelTTF" then
        child:setFontSize(reScale * child:getFontSize())
      elseif tolua.type(child) == "CCSprite" then
        child:setScale(reScale)
      else
        EDDebug(tolua.type(child) .. " not solved!")
      end
      if childPre then
        child:setPositionX(childPre:getPositionX() + childPre:getContentSize().width + 3)
      end
      i = i + 1
    end
  end
end

ed.ui.complexLabelLimitWidthBySize = complexLabelLimitWidthBySize

local function getBoxRewardTypeStr(itemType, num, id)
  repeat
    if itemType == "Gold" then
      return string.format("<sprite src=UI/alpha/HVGA/task_gold_icon_2.png scale=0.7>x%d", num)
    elseif itemType == "Item" then
      local itemName = ed.getDataTable("equip")[id].Name
      return string.format("<sprite id=%d scale=0.35>%sx%d", id, itemName, num)
    else
      if itemType ~= "RandomEquip" then
      end
      do return string.format("<sprite src=UI/alpha/1080P/common/handbook_icon_lock.png scale=0.35>x%d", num) end
      do break end -- pseudo-goto
      if itemType == "Energy" then
        return string.format("<sprite src=UI/alpha/HVGA/GuildHero/guildhero_energy.png scale=0.7>x%d", num)
      elseif itemType == "GuildHeroExpLevel" then
        local value = 0
        if ed.player:getLevel() >= 91 then
          value = 30
        elseif ed.player:getLevel() >= 81 then
          value = 20
        elseif ed.player:getLevel() >= 61 then
          value = 10
        elseif ed.player:getLevel() >= 41 then
          value = 5
        end
        return string.format("<sprite src=UI/alpha/HVGA/GuildHero/guildhero_exp.png scale=0.7>x%d", value)
      end
    end
  until true
end

ed.getBoxRewardTypeStr = getBoxRewardTypeStr

function ed.createBoxTips(contanier, richText)
  local ui_info = {
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(211.72, 73.44)
      },
      t = "Scale9Sprite",
      base = {
        name = "tip_msg",
        z = 300,
        res = "UI/alpha/1080P/common/main_vit_tips.png",
        capInsets = CCRectMake(10.94, 9.38, 21.09, 14.06)
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(568.75, -32.03)
      }
    }
  }
  local ui = {}
  local readNode = ed.readnode.create(contanier, ui)
  readNode:addNode(ui_info)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({context = richText})
  local _, height = autoText:getCurContentSize()
  local size = CCSizeMake(0, 0)
  size.width, height = autoText:getCurContentSize()
  size.width = size.width + 15
  size.height = height + 20
  ui.tip_msg:setContentSize(size)
  ui.tip_msg:addChild(autoText.node, 10)
  autoText.node:setPosition(5, size.height - 23)
  return ui
end

function ed.updateButtonGray(ui, btn_name, flag)
  local imgNormal = ui[btn_name]
  local imgPress = ui[btn_name .. "_press"]
  local label = ui[btn_name .. "_label"]
  if not tolua.isnull(imgNormal) then
    ed.updateSpriteStone(imgNormal, flag)
  end
  if not tolua.isnull(imgPress) then
    ed.updateSpriteStone(imgPress, flag)
  end
  if flag then
    label:setColor(ccc3(200, 200, 200))
  end
end

function ed.playBlinkAction(node, interval)
  if tolua.isnull(node) then
    return
  end
  interval = interval or 0.2
  node:stopAllActions()
  local blink1 = CCFadeOut:create(interval)
  local blink2 = CCFadeIn:create(interval)
  local seqAction = CCSequence:create(ccArrayMake(blink1, blink2))
  node:runAction(CCRepeatForever:create(seqAction))
end

function ed.playBlinkActionV2(node, interval, opacity)
  if tolua.isnull(node) then
    return
  end
  interval = interval or 0.2
  node:stopAllActions()
  local blink1 = CCFadeTo:create(interval, 0)
  local blink2 = CCFadeTo:create(interval, opacity or 255)
  local seqAction = CCSequence:create(ccArrayMake(blink1, blink2))
  node:runAction(CCRepeatForever:create(seqAction))
end

function ed.playBlinkActionV3(node, interval, opacity)
  if tolua.isnull(node) then
    return
  end
  interval = interval or 0.2
  node:stopAllActions()
  local blink1 = CCFadeTo:create(interval, opacity or 0)
  local blink2 = CCFadeTo:create(interval, 255)
  local seqAction = CCSequence:create(ccArrayMake(blink1, blink2))
  node:runAction(CCRepeatForever:create(seqAction))
end

function ed.createScale9Button(params)
  local res = params.res
  local pressRes = params.pressRes
  local capInsets = params.capInsets
  local frame = ed.getSpriteFrame(res)
  local button = CCScale9Sprite:createWithSpriteFrame(frame, capInsets)
  local framePress = ed.getSpriteFrame(pressRes)
  local buttonPress = CCScale9Sprite:createWithSpriteFrame(framePress, capInsets)
  buttonPress:setVisible(false)
  if params.size then
    button:setContentSize(params.size)
    buttonPress:setContentSize(params.size)
  end
  buttonPress:setPosition(ed.getCenterPos(button))
  button:addChild(buttonPress)
  return button, buttonPress
end

function ed.isSupportSpine()
  return EDSpine ~= nil
end

function ed.createSpineEffect(name, scale, func)
  return ed.createSpine(string.format("effect/%s/%s", name, name), scale, func)
end

function ed.createSpine(name, scale, func)
  scale = scale or 1
  local json = string.format("spine/%s.json", name)
  local altas = string.format("spine/%s.atlas", name)
  local spine = EDSpine:createWithFile(json, altas, scale)
  spine:registerScriptHandler(function(status)
    if status == "enter" then
    elseif status == "enterTransitionFinish" then
    elseif status == "exitTransitionStart" then
    elseif status == "exit" then
      spine:unregisterScriptSpineHandler()
    elseif status == "cleanup" then
    end
  end)
  spine:registerScriptSpineHandler(function(evt, spine)
    if func then
      func(evt, spine)
    end
  end)
  return spine
end

local function testSpine(spineName, actionName)
  local spine = ed.createSpine(string.format("effect/%s/%s", spineName, spineName))
  spine:setAnimation(0, actionName or "Idle", true)
  ed.getCurrentScene().mainLayer:addChild(spine)
  ed.layout.centerInScreen(spine)
end

ed.testSpine = testSpine

function ed.createChessPowerIcon(key)
  local powerInfo = ed.getDataTable("ChessHeroPower")[key]
  local icon = ed.createClippingNodeEx(powerInfo.Icon, "UI/alpha/1080P/chess/heropower/heropower_bg.png", nil, CCSizeMake(0, 0), {})
  local frame = ed.createSprite("UI/alpha/1080P/chess/heropower/frame_1.png")
  icon:setScale(0.85)
  frame:addChild(icon, -1)
  ed.layout.centerInParent(icon)
  return frame
end

function ed.setCascadeOpacityEnabled(node, enable, recursive)
  local childNum = nil == node.getChildrenCount and 0 or node:getChildrenCount()
  if 0 < childNum then
    local children = node:getChildren()
    if nil == children then
      return
    end
    if node.setCascadeOpacityEnabled then
      node:setCascadeOpacityEnabled(enable)
    end
    if recursive then
      for i = 1, childNum do
        local child = children:objectAtIndex(i - 1)
        ed.setCascadeOpacityEnabled(child, enable, recursive)
      end
    end
  end
end

function ed.setAllSpriteStone(node, enable, recursive)
  if node.setTexture then
    ed.updateSpriteStone(node, enable)
  end
  local childNum = nil == node.getChildrenCount and 0 or node:getChildrenCount()
  if 0 < childNum then
    local children = node:getChildren()
    if nil == children then
      return
    end
    if recursive then
      for i = 1, childNum do
        local child = children:objectAtIndex(i - 1)
        ed.setAllSpriteStone(child, enable, recursive)
      end
    end
  end
end

function ed.setAllSpriteColor(node, color)
  if node.setColor then
    node:setColor(color)
  end
  local childNum = nil == node.getChildrenCount and 0 or node:getChildrenCount()
  if 0 < childNum then
    local children = node:getChildren()
    if nil == children then
      return
    end
    for i = 1, childNum do
      local child = children:objectAtIndex(i - 1)
      ed.setAllSpriteColor(child, color)
    end
  end
end

local function vec3Normalize(v)
  local l = math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  local scalar = 1 / l
  return {
    x = v.x * scalar,
    y = v.y * scalar,
    z = v.z * scalar
  }
end

local function vec3Cross(v1, v2)
  return {
    x = v1.y * v2.z - v1.z * v2.y,
    y = v1.z * v2.x - v1.x * v2.z,
    z = v1.x * v2.y - v1.y * v2.x
  }
end

local function matrixMultiply(m1, m2)
  local out = {}
  out[1] = m1[1] * m2[1] + m1[5] * m2[2] + m1[9] * m2[3] + m1[13] * m2[4]
  out[2] = m1[2] * m2[1] + m1[6] * m2[2] + m1[10] * m2[3] + m1[14] * m2[4]
  out[3] = m1[3] * m2[1] + m1[7] * m2[2] + m1[11] * m2[3] + m1[15] * m2[4]
  out[4] = m1[4] * m2[1] + m1[8] * m2[2] + m1[12] * m2[3] + m1[16] * m2[4]
  out[5] = m1[1] * m2[5] + m1[5] * m2[6] + m1[9] * m2[7] + m1[13] * m2[8]
  out[6] = m1[2] * m2[5] + m1[6] * m2[6] + m1[10] * m2[7] + m1[14] * m2[8]
  out[7] = m1[3] * m2[5] + m1[7] * m2[6] + m1[11] * m2[7] + m1[15] * m2[8]
  out[8] = m1[4] * m2[5] + m1[8] * m2[6] + m1[12] * m2[7] + m1[16] * m2[8]
  out[9] = m1[1] * m2[9] + m1[5] * m2[10] + m1[9] * m2[11] + m1[13] * m2[12]
  out[10] = m1[2] * m2[9] + m1[6] * m2[10] + m1[10] * m2[11] + m1[14] * m2[12]
  out[11] = m1[3] * m2[9] + m1[7] * m2[10] + m1[11] * m2[11] + m1[15] * m2[12]
  out[12] = m1[4] * m2[9] + m1[8] * m2[10] + m1[12] * m2[11] + m1[16] * m2[12]
  out[13] = m1[1] * m2[13] + m1[5] * m2[14] + m1[9] * m2[15] + m1[13] * m2[16]
  out[14] = m1[2] * m2[13] + m1[6] * m2[14] + m1[10] * m2[15] + m1[14] * m2[16]
  out[15] = m1[3] * m2[13] + m1[7] * m2[14] + m1[11] * m2[15] + m1[15] * m2[16]
  out[16] = m1[4] * m2[13] + m1[8] * m2[14] + m1[12] * m2[15] + m1[16] * m2[16]
  return out
end

local function matrixMultiplyPos(m, v)
  local x = v.x
  local y = v.y
  local z = v.z
  local w = 1
  local result = {}
  result[1] = m[1] * x + m[5] * y + m[9] * z + m[13] * w
  result[2] = m[2] * x + m[6] * y + m[10] * z + m[14] * w
  result[3] = m[3] * x + m[7] * y + m[11] * z + m[15] * w
  result[4] = m[4] * x + m[8] * y + m[12] * z + m[16] * w
  return {
    x = result[1],
    y = result[2],
    z = result[3]
  }
end

local function convertToViewSpace(pos)
  local director = CCDirector:sharedDirector()
  local winSize = director:getWinSize()
  local eye = {
    x = winSize.width * 0.5,
    y = winSize.height * 0.5,
    z = director:getZEye()
  }
  local center = {
    x = winSize.width * 0.5,
    y = winSize.height * 0.5,
    z = 0
  }
  local up = {
    x = 0,
    y = 1,
    z = 0
  }
  local mat = {
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1
  }
  local f = {
    x = center.x - eye.x,
    y = center.y - eye.y,
    z = center.z - eye.z
  }
  f = vec3Normalize(f)
  local s = vec3Cross(f, vec3Normalize(up))
  s = vec3Normalize(s)
  local u = vec3Cross(s, f)
  s = vec3Normalize(s)
  mat[1] = s.x
  mat[5] = s.y
  mat[9] = s.z
  mat[2] = u.x
  mat[6] = u.y
  mat[10] = u.z
  mat[3] = -f.x
  mat[7] = -f.y
  mat[11] = -f.z
  local translate = {
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    -eye.x,
    -eye.y,
    -eye.z,
    1
  }
  mat = matrixMultiply(mat, translate)
  return matrixMultiplyPos(mat, pos)
end

function ed.setBorderSoftness(node, rect, softnessX, softnessY)
  if nil == rect then
    local min = node:convertToWorldSpace(ccp(0, 0))
    local size = node:getContentSize()
    local max = node:convertToWorldSpace(ccp(size.width, size.height))
    rect = CCRectMake(min.x, min.y, max.x - min.x, max.y - min.y)
  end
  ed.setBorderSoftnessShaderProgram(node:getShaderProgram(), rect, softnessX, softnessY, true)
end

function ed.setBorderSoftnessShaderProgram(shaderProgram, rect, softnessX, softnessY, isModifyRGB)
  local min = ccp(rect:getMinX(), rect:getMinY())
  local max = ccp(rect:getMaxX(), rect:getMaxY())
  min = convertToViewSpace({
    x = min.x,
    y = min.y,
    z = 0
  })
  max = convertToViewSpace({
    x = max.x,
    y = max.y,
    z = 0
  })
  shaderProgram:setUniformsForBuiltins()
  local clipRectLocation = shaderProgram:getUniformLocationForName("clipRect")
  shaderProgram:setUniformLocationWith4f(clipRectLocation, min.x, min.y, max.x, max.y)
  local softnessLocation = shaderProgram:getUniformLocationForName("softness")
  shaderProgram:setUniformLocationWith2f(softnessLocation, softnessX, softnessY)
  local modifyRGBLocation = shaderProgram:getUniformLocationForName("modifyRGB")
  shaderProgram:setUniformLocationWith2f(modifyRGBLocation, isModifyRGB and 1 or 0, 0)
  local director = CCDirector:sharedDirector()
  local winSize = director:getWinSize()
  local screenSizeLocation = shaderProgram:getUniformLocationForName("screenSize")
  shaderProgram:setUniformLocationWith2f(screenSizeLocation, winSize.width, winSize.height)
end

function ed.setAllBorderSoftness(node, rect, softnessX, softnessY)
  EDLoadShader("SpriteSoftness")
  local shader = CCShaderCache:sharedShaderCache():programForKey("SpriteSoftness")
  node:setShaderProgram(shader)
  node:getShaderProgram():use()
  ed.setBorderSoftnessShaderProgram(shader, rect, softnessX, softnessY, true)
  local childNum = node:getChildrenCount()
  if 0 < childNum then
    local children = node:getChildren()
    for i = 1, childNum do
      node = tolua.cast(children:objectAtIndex(i - 1), "CCNode")
      ed.setAllBorderSoftness(node, rect, softnessX, softnessY)
    end
  end
end
