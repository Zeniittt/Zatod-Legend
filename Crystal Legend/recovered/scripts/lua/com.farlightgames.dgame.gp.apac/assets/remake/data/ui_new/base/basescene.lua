local base = ed.ui.basenode
local basescene = newclass(base.mt)
ed.ui.basescene = basescene
setimplements(basescene, ed.guide.interface)
local mesh_switch = false
local scene_touch_priority = {
  gm_addequip = -129,
  debuglogin = -129,
  newbie = -129,
  guildhero = -129,
  ranklist_mainscene = -129,
  heroDetailScene = -129,
  MapMainScene = -300
}

function basescene:checkRunning()
  local scene = self:ccScene()
  if not tolua.isnull(scene) and CCDirector:sharedDirector():getRunningScene() == scene then
    return true
  end
  return false
end

function basescene:doMeshLayerTouch()
  local px, py
  
  local function handler(event, x, y)
    if event == "began" then
      px, py = x, y
    end
    if not (event == "ended" and px) or py then
    end
    return true
  end
  
  return handler
end

function basescene:baseHandler()
  local function handler(event)
    xpcall(function()
      if event == "enter" then
        self:onEnter()
      elseif event == "exit" then
        self:onExit()
      elseif event == "enterTransitionFinish" then
        self:onEnterTransitionFinish()
      elseif event == "exitTransitionStart" then
        self:onExitTransitionStart()
      end
    end, EDDebug)
  end
  
  return handler
end

function basescene:onEnterTransitionFinish()
end

function basescene:onExitTransitionStart()
end

function basescene:registerOnEnterHandler(key, handler)
  self.onEnterHandlerList = self.onEnterHandlerList or {}
  if self.onEnterHandlerList[key] then
    EDLog("Scene's onEnterHandlerList already has [" .. key .. "] handler!!!")
  end
  self.onEnterHandlerList[key] = handler
end

function basescene:removeOnEnterHandler(key)
  self.onEnterHandlerList = self.onEnterHandlerList or {}
  self.onEnterHandlerList[key] = nil
end

function basescene:clearOnEnterHandler()
  self.onEnterHandlerList = nil
end

function basescene:onEnter()
  FireEvent(ed.guide.eventNames.OPEN_VIEW, self)
  xpcall(function()
    for k, v in pairs(self.onEnterHandlerList or {}) do
      v()
    end
  end, EDDebug)
  ed.ui.headline.getInstance():addToSecen(self)
  ed.ui.chatEntrance.getInstance():addToScene(self)
  ed.audioParam.musicVolume = ed.musicVolume[self.identity] or 1
  if ed.music[self.identity] then
    ed.playMusic(ed.music[self.identity])
  else
    ed.resetMusicVolume()
  end
end

function basescene:registerOnExitHandler(key, handler)
  self.onExitHandlerList = self.onExitHandlerList or {}
  if self.onExitHandlerList[key] then
    EDLog("Scene's onExitHandlerList already has [" .. key .. "] handler!!!")
  end
  self.onExitHandlerList[key] = handler
end

function basescene:removeOnExitHandler(key)
  self.onExitHandlerList = self.onExitHandlerList or {}
  self.onExitHandlerList[key] = nil
end

function basescene:clearOnExitHandler()
  self.onExitHandlerList = nil
end

function basescene:registerOnPopSceneHandler(key, handler)
  self.onPopSceneHandlerList = self.onPopSceneHandlerList or {}
  self.onPopSceneHandlerList[key] = handler
end

function basescene:clearOnPopSceneHandler()
  self.onExitHandlerList = nil
end

function basescene:onPopScene()
  CloseScope(self.senceEventScope)
  self.senceEventScope = nil
  xpcall(function()
    for k, v in pairs(self.onPopSceneHandlerList or {}) do
      v()
    end
  end, EDDebug)
  if self.redPointMgr then
    self.redPointMgr:unregisterAllValueChange(self)
  end
  self:destroyAllWindows()
end

function basescene:onExit()
  FireEvent(ed.guide.eventNames.CLOSE_VIEW, self)
  xpcall(function()
    for k, v in pairs(self.onExitHandlerList or {}) do
      v()
    end
  end, EDDebug)
  ed.ui.headline.getInstance():removeFormSecen()
  ed.ui.chatEntrance.getInstance():removeFormScene()
end

local globalFcaList = {}
basescene.globalFcaList = globalFcaList
ed.globalFcaList = globalFcaList

function basescene.getTopNode()
  if not basescene.topNode then
    basescene.topNode = CCNode:create()
    CCDirector:sharedDirector():setNotificationNode(basescene.topNode)
  end
  return basescene.topNode
end

function basescene.getGuideRoot()
  if not basescene.guideRoot then
    basescene.guideRoot = CCNode:create()
    basescene.getTopNode():addChild(basescene.guideRoot, 100)
  end
  return basescene.guideRoot
end

function basescene.create(identity, addition)
  local self = base.create("scene")
  setmetatable(self, basescene.mt)
  self.fcaList = {}
  self.windowsStack = {}
  self.identity = identity
  self.addition = addition or {}
  local scene = CCScene:create()
  self.scene = scene
  self:setBackground()
  local baseLayer = CCLayer:create()
  self.baseLayer = baseLayer
  scene:addChild(baseLayer)
  baseLayer:registerScriptHandler(self:baseHandler())
  self.ui = {}
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  scene:addChild(mainLayer)
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, scene_touch_priority[identity] or 0, false)
  mainLayer:setPosition(ed.display.halfFixedWidth, ed.display.halfFixedHeight)
  if mesh_switch then
    local meshLayer = CCLayer:create()
    self.meshLayer = meshLayer
    meshLayer:setTouchEnabled(true)
    meshLayer:registerScriptTouchHandler(self:doMeshLayerTouch(), false, -129, false)
    scene:addChild(meshLayer)
  end
  if SHOW_MEMORY_STATE then
    local memory_label = ed.createNode({
      t = "Label",
      base = {
        text = "Memory Used : ",
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(20, 450)
      }
    }, self.mainLayer, 300)
    self.ui.memory_label = memory_label
    local count = 1
    self:registerUpdateHandler("update_memory_state", function(dt)
      count = count + dt
      if 1 < count then
        if not self.ui.memory_label then
          return
        end
        local usePercent, totalPhys, availPhys = EDGetMemoryState()
        local dp = ori_avail_phys - availPhys
        ed.setString(memory_label, "Memory Used : " .. dp .. " , Lua Memory Used : " .. string.format("%d", collectgarbage("count") / 1024))
        count = count - 1
      end
    end)
  end
  self.senceEventScope = {}
  return self
end

function basescene:listenEvent(eventName, fun)
  return ListenEvent(eventName, fun, self.senceEventScope)
end

function basescene:listenTimer(timer, fun)
  return ListenTimer(timer, fun, self.senceEventScope)
end

function basescene:setBackground(res)
  if not self.bg then
    local bg = ed.createSprite(res or "UI/alpha/1080P/bg/dreamland_bj.png")
    self.bg = bg
    self.scene:addChild(bg)
  elseif res then
    ed.initSpriteWithFrame(self.bg, res)
  else
    self.bg:setVisible(false)
  end
  if self.bg:isVisible() then
    ed.layout.lazyAdaptBG(self.bg)
  end
end

function basescene:setBackButton(callback)
  local ui = {}
  local readnode = ed.readnode.create(self.mainLayer, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      config = {
        scalexy = {x = 0.8, y = 0.8}
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back_arrow",
        res = "UI/alpha/1080P/common/break_butt.png",
        parent = "back"
      },
      layout = {
        position = ccp(25, 27)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  ed.layout.layoutWithMagin(ui.back, {left = 0, top = 0})
  ui.back:setZOrder(999)
  self:btRegisterRectClick({
    rect = CCRectMake(0, -20, 60, 60),
    parent = ui.back,
    pressHandler = function()
      if not tolua.isnull(ui.back) then
        ui.back:setScale(0.75)
      end
    end,
    cancelPressHandler = function()
      if not tolua.isnull(ui.back) then
        ui.back:setScale(0.8)
      end
    end,
    clickHandler = function()
      if callback then
        callback()
      end
      ed.popScene()
    end,
    force = true,
    priority = -16
  })
  self.back_button = ui.back
end

function basescene:ccScene()
  return self.scene
end

function basescene:update(dt)
  self:doRegisterUpdateHandler()
  self:doRemoveUpdateHandler()
  for k, v in pairs(self.updateHandlerList or {}) do
    xpcall(function()
      v(dt)
    end, EDDebug)
  end
  self:updateFca(dt)
end

function basescene:doRegisterUpdateHandler()
  if not self.register_uh_list then
    return
  end
  self.updateHandlerList = self.updateHandlerList or {}
  for _, register_handler in ipairs(self.register_uh_list) do
    self.updateHandlerList[register_handler.k] = register_handler.v
  end
  self.register_uh_list = nil
end

function basescene:registerUpdateHandler(key, handler)
  self.register_uh_list = self.register_uh_list or {}
  table.insert(self.register_uh_list, {k = key, v = handler})
end

function basescene:doRemoveUpdateHandler()
  if not self.remove_uh_list then
    return
  end
  self.updateHandlerList = self.updateHandlerList or {}
  for _, handler in ipairs(self.remove_uh_list) do
    self.updateHandlerList[handler] = nil
  end
  self.remove_uh_list = nil
end

function basescene:removeUpdateHandler(key)
  self.remove_uh_list = self.remove_uh_list or {}
  table.insert(self.remove_uh_list, key)
end

function basescene:clearUpdateHandler()
  self.updateHandlerList = nil
end

function basescene:refresh()
  for k, v in pairs(self.refreshHandlerList or {}) do
    xpcall(function()
      v()
    end, EDDebug)
  end
end

function basescene:registerRefreshHandler(key, handler)
  self.refreshHandlerList = self.refreshHandlerList or {}
  self.refreshHandlerList[key] = handler
end

function basescene:removeRegisterHandler(key)
  (self.registerHandlerList or {})[key] = nil
end

function basescene:clearRegisterHandler()
  self.registerHandlerList = nil
end

function basescene:updateFcaByList(dt, list)
  for i = #list, 1, -1 do
    if list[i].toRemove then
      table.remove(list, i)
    end
  end
  for i, v in ipairs(list) do
    if tolua.isnull(v.node) then
      v.toRemove = true
      v.node = nil
    else
      if not v.isPause and not v.beCulled then
        v.node:update(dt)
      end
      if v.once and v.node.isTerminated and v.node:isTerminated() then
        v.node:removeFromParentAndCleanup(true)
        v.node = nil
        v.toRemove = true
      end
    end
    if v.pauseDelayTime then
      v.pauseDelayTime = v.pauseDelayTime - dt
      if v.pauseDelayTime < 0 then
        v.pauseDelayTime = nil
        v.isPause = true
      end
    end
  end
end

function basescene:updateFca(dt)
  self:updateFcaByList(dt, self.fcaList)
  self:updateFcaByList(dt, globalFcaList)
end

function basescene:addFcaCache(node, duration)
  self.fcaCacheIndex = self.fcaCacheIndex or 0
  local key = self.fcaCacheIndex + 1
  key = "fca" .. key
  local count = 0
  
  local function handler(dt)
    count = count + dt
    if count > duration then
      if not tolua.isnull(node) then
        node:removeFromParentAndCleanup(true)
      end
      self:removeUpdateHandler(key)
    end
  end
  
  self:registerUpdateHandler(key, handler)
end

function basescene:addFca(fca, duration, isGobal)
  if isGobal then
    table.insert(globalFcaList, {node = fca})
  else
    table.insert(self.fcaList, {node = fca})
  end
  if duration then
    self:addFcaCache(fca.node, duration)
  end
end

function basescene:addFcaOnce(fca, isGobal)
  if isGobal then
    table.insert(globalFcaList, {node = fca, once = true})
  else
    table.insert(self.fcaList, {node = fca, once = true})
  end
end

function basescene:removeFca(fca)
  for i = #self.fcaList, 1, -1 do
    if self.fcaList[i].node == fca then
      table.remove(self.fcaList, i)
      return
    end
  end
  for i = #globalFcaList, 1, -1 do
    if globalFcaList[i].node == fca then
      table.remove(globalFcaList, i)
      return
    end
  end
end

function basescene:pauseFca(fca)
  for i, v in ipairs(self.fcaList) do
    if v.node == fca then
      v.isPause = true
      return
    end
  end
  for i, v in ipairs(globalFcaList) do
    if v.node == fca then
      v.isPause = true
      return
    end
  end
end

function basescene:resumeFca(fca)
  for i, v in ipairs(self.fcaList) do
    if v.node == fca then
      v.isPause = false
      return
    end
  end
  for i, v in ipairs(globalFcaList) do
    if v.node == fca then
      v.isPause = false
      return
    end
  end
end

function basescene:setFcaRadius(fca, radius)
  for i, v in ipairs(self.fcaList) do
    if v.node == fca then
      v.radius = radius
      return
    end
  end
  for i, v in ipairs(globalFcaList) do
    if v.node == fca then
      v.radius = radius
      return
    end
  end
end

function basescene:setFcaRect(fca, rect)
  for i, v in ipairs(self.fcaList) do
    if v.node == fca then
      v.rect = rect
      return
    end
  end
  for i, v in ipairs(globalFcaList) do
    if v.node == fca then
      v.rect = rect
      return
    end
  end
end

function basescene:setFcaPositionOffset(fca, offset)
  for i, v in ipairs(self.fcaList) do
    if v.node == fca then
      v.positionOffset = offset
      return
    end
  end
  for i, v in ipairs(globalFcaList) do
    if v.node == fca then
      v.positionOffset = offset
      return
    end
  end
end

function basescene:delayPauseFca(fca, delay)
  for i, v in ipairs(self.fcaList) do
    if v.node == fca then
      v.pauseDelayTime = delay or 0.1
      return
    end
  end
  for i, v in ipairs(globalFcaList) do
    if v.node == fca then
      v.pauseDelayTime = delay or 0.1
      return
    end
  end
end

function basescene:clearFca()
  self.fcaList = {}
end

function basescene:createVoicetalk(mode, priority)
  local param = {
    touchNode = self,
    uimode = mode or 1,
    priority = priority or -300
  }
  self.voicetalk = ed.voicetalk.getInstance()
  local container = self.voicetalk:createVoiceTalkUI(param)
  self.mainLayer:addChild(container)
end

function basescene:openVoicetalk(partner)
  if self.voicetalk then
    self.voicetalk:openVoicetalk(partner)
  end
end

function basescene:closeVoicetalk()
  if self.voicetalk then
    self.voicetalk:closeVoicetalk()
  end
end

function basescene:setVoicetalkUIPosition(position)
  if self.voicetalk and self.voicetalk.mainLayer then
    local voicetalkMainLayer = self.voicetalk.mainLayer
    voicetalkMainLayer:setPosition(position)
  end
end

local sceneInterface = {}

function sceneInterface:popWindow(window, z)
  self.windowsStack = self.windowsStack or {}
  table.insert(self.windowsStack, window)
  window.m_parentScene = self
  self.scene:addChild(window.mainLayer, z or 300)
end

function sceneInterface:destroyWindow(window)
  self.windowsStack = self.windowsStack or {}
  for i = #self.windowsStack, 1, -1 do
    if window == self.windowsStack[i] then
      table.remove(self.windowsStack, i)
      window:onWinDestroy()
      if self.scene then
        self.scene:removeChild(window.mainLayer, true)
      end
      break
    end
  end
  local count = #self.windowsStack
  FireEvent(ed.guide.eventNames.OPEN_VIEW, count == 0 and self or self.windowsStack[count])
end

function sceneInterface:destroyAllWindows()
  self.windowsStack = self.windowsStack or {}
  for i, window in ipairs(self.windowsStack) do
    window:onWinDestroy()
    self.scene:removeChild(window.mainLayer, true)
  end
  self.windowsStack = {}
end

ed.ui.sceneInterface = {interface = sceneInterface}
setimplements(basescene, ed.ui.sceneInterface)
