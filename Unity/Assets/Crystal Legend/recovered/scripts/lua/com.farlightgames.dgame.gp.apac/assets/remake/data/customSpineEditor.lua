local base = ed.ui.basescene
local customSpineEditor = newclass(base.mt)
ed.ui.customSpineEditor = customSpineEditor

function customSpineEditor.create()
  local self = base.create("customSpineEditor")
  setmetatable(self, customSpineEditor.mt)
  self:initSpineEditor()
  self:registerTouchHandler()
  self:adaptUI()
  return self
end

function customSpineEditor:adaptUI()
  self.adaptScale = ed.display.winSize.width / 1170
  self.ui.bg:setScale(self.adaptScale)
end

function customSpineEditor:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if ed.containsPoint(v.ui.bg, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function customSpineEditor:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if self.curUIItem then
      self.curUIItem.ui.selected:setVisible(false)
    end
    self.curUIItem = v
    self.curUIItem.ui.selected:setVisible(true)
    self:playSpine(v.data)
  end
  
  return handler
end

function customSpineEditor:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function customSpineEditor:playSpine(data)
  if self.spine and data.Cha == self.curCha then
    if self.curAction == data.Action then
      return
    else
      self.spine:setAction(data.Action)
      self.curAction = data.Action
      self:createPoints()
    end
  else
    if self.spine then
      self.spine:removeFromParentAndCleanup(true)
    end
    local sp_actor = EDFcaSpActor:create(data.Cha, 1)
    print("skin count", sp_actor:getSkinCount())
    sp_actor:setSkin("normal")
    sp_actor:setLoop(true)
    sp_actor:setPosition(self.initPos)
    sp_actor:setAction(data.Action)
    self.mainLayer:addChild(sp_actor)
    self:addFca(sp_actor)
    self.curCha = data.Cha
    self.spine = sp_actor
    self.curAction = data.Action
    self:createPoints()
  end
end

function customSpineEditor:createPoints()
  self.pointLayer:removeAllChildrenWithCleanup(true)
  local cnt = 1
  if self.atkFrameSpList then
    for k, events in ipairs(self.atkFrameSpList) do
      if events.Cha == self.curCha and events.Action == self.curAction then
        local uiItem = CCLayerColor:create(ccc4(250, 0, 0, 50))
        uiItem:changeWidthAndHeight(20, 20)
        uiItem:setPosition(ccpAdd(self.initPos, ccp(events.X, events.Y)))
        self.pointLayer:addChild(uiItem)
        local label = ed.createLabelTTF(tostring(cnt), 14)
        label:setColor(ccc3(0, 0, 0))
        label:setPosition(ccp(10, 10))
        uiItem:addChild(label)
        cnt = cnt + 1
      end
    end
  end
  self.pointLabel:setString(tostring(cnt - 1))
end

function customSpineEditor:initSpineEditor()
  self.container, self.ui = ed.editorui(ed.uieditor.SpineEditorScene)
  self.mainLayer:addChild(self.container)
  local pos = ccpAdd(ed.display.center, ccp(-20, -80))
  self.initPos = pos
  self.pointLayer = CCLayer:create()
  self.mainLayer:addChild(self.pointLayer, 500)
  self.pointLabel = ed.createLabelTTF("0", 30)
  self.pointLabel:setPosition(ccp(ed.display.winSize.width - 50, ed.display.winSize.height - 150))
  self.mainLayer:addChild(self.pointLabel, 500)
  self.uiList = {}
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList()
  })
end

function customSpineEditor:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.SpineEditorAnimItem)
  ui.name:setScale(0.8)
  ui.name:setString(data.Cha .. "  " .. data.Action)
  return container, ui
end

function customSpineEditor:refreshDraglist()
  self.draglist:clearList()
  self.uiList = {}
  local contentSize = self.ui.layer_item:getContentSize()
  local dy = 29
  local ox, oy = contentSize.width / 2, contentSize.height + dy / 2
  
  local function getPos(k)
    return ccp(ox, oy - dy * k)
  end
  
  local listData = self.durationSpList or {}
  for k, v in ipairs(listData) do
    local container, ui = self:createItem(v)
    container:setPosition(getPos(k))
    self.draglist:addItem(container)
    table.insert(self.uiList, {
      data = v,
      ui = ui,
      container = container
    })
  end
  self.draglist:initListHeight(dy * #listData)
end

function customSpineEditor:registerTouchHandler()
  self:listenEvent("SpineExportCsvSuccess", function(data)
    self.durationSpList = data.durationSpList
    self.atkFrameSpList = data.atkFrameSpList
    self:refreshDraglist()
  end)
  ed.UITool.registerBtn(self, "export", function()
    print("export start")
    package.loaded.export_spine = nil
    require("export_spine")
    ed.export_spine()
    print("export finish")
  end)
  ed.UITool.registerBtn(self, "default", function()
    self:addEffect()
  end)
  ed.UITool.registerBtn(self, "jx", function()
    self.spine:setSkin("normal_awake")
  end)
  ed.UITool.registerBtn(self, "pt", function()
    self.spine:setSkin("normal")
  end)
end

function customSpineEditor:addEffect()
  self.spine:addEffect("eff_point_Coco_ult.sp", 1)
end

ed.pushScene(ed.ui.customSpineEditor.create())
