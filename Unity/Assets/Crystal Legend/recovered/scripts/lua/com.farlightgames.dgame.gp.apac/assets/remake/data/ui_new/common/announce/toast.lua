local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.toast = class
local resFactor = ed.display.resFactor

local function waitRemove(record, container)
  local container = container
  local record = record
  local bg = ed.toast.toast
  
  local function remove(dt)
    xpcall(function()
      if CCDirector:sharedDirector():getRunningScene() ~= container then
        if not tolua.isnull(bg) then
          bg:removeFromParentAndCleanup(true)
        end
        ed.toast.toast = nil
        record.scheduler:unscheduleScriptEntry(record.id)
      end
      if tolua.isnull(bg) then
        record.scheduler:unscheduleScriptEntry(record.id)
      else
        if bg:getOpacity() == 0 then
          bg:removeFromParentAndCleanup(true)
          record.scheduler:unscheduleScriptEntry(record.id)
        else
        end
      end
    end, EDDebug)
  end
  
  return remove
end

class.waitRemove = waitRemove

local function createToast(text, param)
  local bg = CCSprite:create()
  bg:setCascadeOpacityEnabled(true)
  local board = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png", CCRectMake(8, 8, 37, 37))
  board:setAnchorPoint(ccp(0.5, 0.5))
  bg:addChild(board)
  local labelMaxWidth = ed.display.winSize.width - 50
  if param and param.maxWidth then
    labelMaxWidth = param.maxWidth
  end
  local label
  local labelSize = {width = 0, height = 0}
  if param and param.isAutoText then
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = text,
      color = ed.toccc3(16776423),
      maxWidth = labelMaxWidth,
      fontSize = 18
    })
    local width, height = autoText:getCurContentSize()
    autoText.node:setPosition(ccp(0 - width / 2, 12))
    label = autoText.node
    labelSize.width = width
    labelSize.height = height
  else
    label = ed.createttf(text, 18)
    label:setAnchorPoint(ccp(0.5, 0.5))
    label:setColor(ed.toccc3(16776423))
    ed.adaptLabel(label, {maxWidth = labelMaxWidth})
    labelSize = label:getContentSize()
  end
  bg:addChild(label)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  board:setContentSize(CCSizeMake(labelSize.width + 40, labelSize.height + 20))
  return bg, board, label
end

class.createToast = createToast

local function showToast(text, param)
  param = param or {}
  if not CCDirector:sharedDirector():getRunningScene() then
    return
  end
  if not tolua.isnull(ed.toast.toast) then
    ed.toast.toast:removeFromParentAndCleanup(true)
  end
  local bg, board, label = createToast(text, param)
  bg:setPosition(ed.display.center)
  ed.toast.toast = bg
  local container = ed.getCurrentScene().scene
  container:addChild(bg, 5000000)
  ed.playEffect(ed.sound.deo.common_alert)
  local record = {}
  record.scheduler = container:getScheduler()
  record.id = record.scheduler:scheduleScriptFunc(waitRemove(record, container), 0, false)
  if not param.keepOn then
    local delay = CCDelayTime:create(param.constant or 1)
    local fadeout = CCFadeOut:create(param.outtime or 1)
    local sequence = CCSequence:createWithTwoActions(delay, fadeout)
    bg:runAction(sequence)
  end
  return bg, board, label
end

ed.registerOverloadFunc(class, "showToast", {
  types = {
    "string",
    {"table", "nil"}
  },
  func = showToast
})

local function showToastWithPos(text, pos, param)
  pos = pos or ed.display.center
  local bg, board, label = showToast(text, param)
  bg:setPosition(pos)
  return bg, board, label
end

ed.registerOverloadFunc(class, "showToast", {
  types = {
    "string",
    {"userdata", "nil"},
    {"table", "nil"}
  },
  func = showToastWithPos
}, 1)
ed.setOverloadFunc(class, "showToast")
ed.showToast = class.showToast

local function showToastForever(text, pos)
  return ed.showToast(text, pos, {keepOn = true})
end

ed.showToastForever = showToastForever

local function showNetToast(text)
  if not ed.debug_mode then
    return
  end
  return ed.showToast(text)
end

ed.showNetToast = showNetToast

local function clearTaskParam(index)
  local param = ed.toast.taskParam[index]
  if param and not tolua.isnull(param.bg) then
    param.bg:removeFromParentAndCleanup(true)
    param.bg = nil
  end
end

local function waitTaskRemove(param)
  local container = param.container
  local record = param.record
  local bg = param.bg
  local index = param.index
  
  local function remove(dt)
    xpcall(function()
      if CCDirector:sharedDirector():getRunningScene() ~= container then
        clearTaskParam(index)
        record.scheduler:unscheduleScriptEntry(record.id)
      end
      if tolua.isnull(bg) then
        record.scheduler:unscheduleScriptEntry(record.id)
      elseif bg:getOpacity() == 0 then
        clearTaskParam(index)
        record.scheduler:unscheduleScriptEntry(record.id)
      end
    end, EDDebug)
  end
  
  return remove
end

class.waitTaskRemove = waitTaskRemove

local function createTaskToast(text)
  local bg = CCSprite:create()
  bg:setCascadeOpacityEnabled(true)
  local board = ed.createScale9Sprite("UI/alpha/HVGA/kings_pvp/quest_shade.png", CCRectMake(20, 20, 200, 20))
  board:setAnchorPoint(ccp(0.5, 0.5))
  bg:addChild(board)
  local label = ed.createttf(text, 20)
  label:setAnchorPoint(ccp(0.5, 0.5))
  bg:addChild(label)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  local labelSize = label:getContentSize()
  board:setContentSize(CCSizeMake(500, labelSize.height + 20))
  return bg, board, label
end

class.createTaskToast = createTaskToast

local function createTaskParam(bg, index)
  local param = {}
  param.index = index
  param.bg = bg
  param.bg:setPosition(ccp(400, 400 - 45 * index))
  param.container = CCDirector:sharedDirector():getRunningScene()
  param.container:addChild(bg, 70)
  param.record = {}
  param.record.scheduler = param.container:getScheduler()
  param.record.id = param.record.scheduler:scheduleScriptFunc(waitTaskRemove(param), 0, false)
  return param
end

local function runFadeAction(bg)
  local fadeIn = CCFadeIn:create(0.5)
  local delta = CCDelayTime:create(2)
  local fadeOut = CCFadeOut:create(0.5)
  local sequence = ed.readaction.create({
    t = "seq",
    fadeIn,
    delta,
    fadeOut
  })
  bg:runAction(sequence)
end

local maxShowIndex = 3

local function calcShowIndex()
  if not ed.toast.taskParam then
    ed.toast.taskParam = {}
    return 1
  end
  local index = 1
  for i = 1, maxShowIndex do
    if not ed.toast.taskParam[i] or not ed.toast.taskParam[i].bg then
      index = i
      break
    end
  end
  return index
end

local function showTaskToast(text)
  if not CCDirector:sharedDirector():getRunningScene() then
    return
  end
  local index = calcShowIndex()
  clearTaskParam(index)
  ed.playEffect(ed.sound.deo.common_alert)
  local bg, board, label = createTaskToast(text)
  local param = createTaskParam(bg, index)
  runFadeAction(bg)
  ed.toast.taskParam[index] = param
  return bg, board, label
end

class.showTaskToast = showTaskToast
ed.showTaskToast = class.showTaskToast
local colSpaceHeight = 30
local colSpaceWidth = 20

local function adjustTextEmojiWindow(window, richRect, isTop, isLeft)
  local posX = richRect.x or 0
  local posY = richRect.y or 0
  local width = richRect.width or 0
  local height = richRect.height or 0
  local bgSize = window:getCompomentSize("image_bg")
  local bgX, bgY = window:getCompomentPos("image_bg")
  local offX = (bgSize.width - width) / 2
  local offY = (bgSize.height - height) / 2
  
  local function offFuncX(isTrue, orginV, offV)
    if isTrue then
      return orginV + offV / 2
    else
      return orginV - offV / 2
    end
  end
  
  bgX = offFuncX(isLeft, bgX, offX)
  
  local function offFuncY(isTrue, orginV, offV)
    if isTrue then
      return orginV - offV
    else
      return orginV + offV
    end
  end
  
  local bgSizeH, layerPosY
  if 30 < height then
    bgSizeH = bgSize.height
    layerPosY = bgY - height / 2
  else
    bgY = offFuncY(isTop, bgY, offY - colSpaceHeight / 2)
    bgSizeH = height + colSpaceHeight
    layerPosY = bgY - height / 2 - colSpaceHeight / 2
  end
  window.mainLayer:setPosition(ccp(posX, posY))
  window:setCompomentPos("image_bg", ccp(bgX, bgY))
  window:setCompomentSize("image_bg", CCSizeMake(width + colSpaceWidth, bgSizeH))
  window:setCompomentPos("layer_text", ccp(bgX - width / 2 - colSpaceWidth / 2, layerPosY))
end

local function showTextEmojiDialog(emojiNode, richRect, isTop, isLeft)
  if richRect == nil or richRect.x == nil then
    EDLog("error: must set dialog rect info !")
    return
  end
  richRect.y = richRect.y - 5
  local window = ed.openui("talkdialog", {
    forbidTouch = true,
    noShade = true,
    noShow = true
  })
  window.ui.layer_text:addChild(emojiNode)
  window:setVisible("image_left_bottom", not isTop and isLeft)
  window:setVisible("image_right_bottom", not isTop and not isLeft)
  window:setVisible("image_left_top", isTop and isLeft)
  window:setVisible("image_right_top", isTop and not isLeft)
  adjustTextEmojiWindow(window, richRect, isTop, isLeft)
  local posX = richRect.x
  local posY = richRect.y
  local delta = CCDelayTime:create(2.5)
  local m = CCMoveTo:create(0.2, ccp(posX - 340, posY - 95))
  local s = CCScaleTo:create(0.2, 0.1)
  s = CCSpawn:createWithTwoActions(m, s)
  local f = CCCallFunc:create(function()
    xpcall(function()
      window:close()
    end, EDDebug)
  end)
  local f1 = CCCallFunc:create(function()
    xpcall(function()
      window.mainLayer:setVisible(false)
    end, EDDebug)
  end)
  local sequence = CCSequence:create(ccArrayMake(delta, s, f1, CCDelayTime:create(0.05), f))
  window.mainLayer:runAction(sequence)
end

class.showTextEmojiDialog = showTextEmojiDialog
ed.showTextEmojiDialog = class.showTextEmojiDialog
local timeAch
local fcaGroup = {}

function class.showAchFcaGroup(cupType, text)
  if not text then
    return
  end
  table.insert(fcaGroup, {text = text, cupType = cupType})
  if timeAch then
    return
  end
  local index = 1
  fcaGroup[index].fca = class.showAchFce(fcaGroup[index])
  timeAch = ListenTimer(Timer:Always(3), function()
    if fcaGroup[index].fca and not tolua.isnull(fcaGroup[index].fca) then
      fcaGroup[index].fca:removeFromParentAndCleanup(true)
    end
    index = index + 1
    if fcaGroup[index] then
      fcaGroup[index].fca = class.showAchFce(fcaGroup[index])
    elseif timeAch then
      CloseTimer(timeAch.Name)
      timeAch = nil
      fcaGroup = {}
    end
  end)
end

ed.showAchFcaGroup = class.showAchFcaGroup
local oldFca

function ed.removeShowAchFceIng()
  if timeAch then
    oldFca:removeFromParentAndCleanup(true)
  end
end

local function showAchFce(achCfg)
  local scene = ed.getCurrentScene()
  if scene and (scene.addFcaOnce or scene.addFca) then
    local text = achCfg.text
    local cupType = achCfg.cupType
    local achViewCfg = ed.cupTypeToAchView[cupType]
    local effectName = achViewCfg and achViewCfg.achBannerEffect or "eff_UI_achievement_banner"
    local Fca = ed.createFcaNode(effectName)
    Fca:setAction("Start")
    local bookSpr = CCSprite:create()
    local label = ed.createttf(text or "nil", 15)
    label:setPosition(-5, 2)
    label:setColor(ccc3(255, 255, 238))
    label:setStroke(ccc3(39, 37, 36), 1)
    ed.adaptLabel(label, {maxWidth = 190, minScale = 0.7})
    bookSpr:addChild(label)
    Fca:addNodeToComponent(bookSpr, "Text", 1, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
    Fca:setPosition(ed.display.winSize.width / 2 - 30, ed.display.winSize.height - 30)
    if scene.getTopNode then
      local container = scene:getTopNode()
      container:addChild(Fca)
    else
      scene:ccScene():addChild(Fca, 999)
    end
    if scene.addFcaOnce then
      scene:addFcaOnce(Fca, true)
    else
      print("addFcaOnce is nil")
      scene:addFca(Fca, nil, true)
    end
    oldFca = Fca
    return Fca
  else
    error("scene addFca is nil")
  end
end

class.showAchFce = showAchFce
ed.showAchFce = class.showAchFce
