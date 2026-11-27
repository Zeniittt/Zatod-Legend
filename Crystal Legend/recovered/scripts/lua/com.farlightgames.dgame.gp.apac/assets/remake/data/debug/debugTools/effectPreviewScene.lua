require("lfs")
local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.effectPreviewScene = class
ed.UITool.registViewOpenFunc("effectPreviewScene", function()
  local scene = ed.ui.effectPreviewScene.create()
  ed.pushScene(scene)
end)

local function getFileName(path)
  path = path or ""
  local filename = string.match(path, "[^/\\]+$")
  filename = string.match(filename, "(.+)%..+$") or filename
  return filename
end

local function readU8(data, index)
  return string.byte(data, index), index + 1
end

local function readU16(data, index)
  local b0, b1 = string.byte(data, index, index + 1)
  return b0 + b1 * 256, index + 2
end

local function readU32(data, index)
  local b0, b1, b2, b3 = string.byte(data, index, index + 3)
  return b0 + b1 * 256 + b2 * 65536 + b3 * 16777216, index + 4
end

local function readI32(data, index)
  local val, newIndex = readU32(data, index)
  if 2147483648 <= val then
    val = val - 4294967296
  end
  return val, newIndex
end

local function readFloat(data, index)
end

local function readT(data, index, typ)
  if typ == "uint8" then
    return readU8(data, index)
  elseif typ == "uint16" then
    return readU16(data, index)
  elseif typ == "uint32" then
    return readU32(data, index)
  elseif typ == "int32" then
    return readI32(data, index)
  else
    error("Unsupported type: " .. typ)
  end
end

local function readString(data, index)
  local len, newIndex = readU32(data, index)
  index = newIndex
  local str = string.sub(data, index, index + len - 1)
  index = index + len
  return str, index
end

function class.create()
  local self = base.create("effectPreviewScene")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.root = "proto"
  self.currentDir = nil
  self.pause = false
  self.fcaNodeList = {}
  self.speedList = {
    0.5,
    1,
    2,
    3,
    5
  }
  self.speedIndex = 2
  self.speed = self.speedList[self.speedIndex]
  self.scaleList = {
    -1,
    0.5,
    0.7,
    1,
    1.2,
    1.5,
    2,
    3
  }
  self.scaleIndex = 2
  self.scale = self.scaleList[self.scaleIndex]
  self.page = 1
  ed.ui.server_ping:showPing(false)
  ed.ui.server_ping:showBattleFPS(false)
  CCDirector:sharedDirector():setDisplayStats(false)
  self:visitDir()
  self:initView()
  self:addTouchEvent()
  self:initTableView()
  self:refreshTableView()
end

function class:onPopScene()
  CCDirector:sharedDirector():setDisplayStats(true)
  ed.ui.server_ping:showPing(true)
  ed.ui.server_ping:showBattleFPS(true)
  base.onPopScene(self)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.effectPreviewScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  local layerColor = CCLayerColor:create(ccc4(0, 0, 0, 100))
  ui.panel_list:addChild(layerColor)
  layerColor:setContentSize(ui.panel_list:getContentSize())
  self:setBackButton()
  self:initEditBox()
  self.ui.panel_show:setTouchEnabled(true)
  self.ui.panel_show:registerScriptTouchHandler(self:doShowLayerTouch(), false, -300, true)
end

function class:initEditBox()
  local size = self.ui.image_search_bg:getContentSize()
  local info = {
    config = {
      editSize = CCSizeMake(0, 0),
      maxLength = 100,
      fontColor = ccc3(255, 252, 231),
      fontSize = 18
    }
  }
  local edit_box = editBox:new(info)
  self.ui.image_search_bg:addChild(edit_box.edit)
  edit_box:setPlaceHolder("\230\168\161\231\179\138\230\144\156\231\180\162")
  edit_box.edit:setPosition(10, size.height / 2)
  self.ui.edit_box = edit_box
end

function class:updateFca(dt, force)
  if self.pause and not force then
    dt = 0
  else
    dt = dt * self.speed
  end
  base.updateFca(self, dt)
end

function class:visitDir()
  self.allDirData = {}
  
  local function createDirTable(name)
    return {
      parentDirName = nil,
      dirName = name,
      fileList = {}
    }
  end
  
  local function analyzePath(path)
    path = string.gsub(path, "\\", "/")
    local attr = lfs.attributes(path)
    if attr then
      if attr.mode == "directory" then
        local dirTable = createDirTable(path)
        local dirList = {}
        for file in lfs.dir(path) do
          if file ~= "." and file ~= ".." then
            local filePath = path .. "/" .. file
            local result = analyzePath(filePath)
            if type(result) == "table" then
              result.parentDirName = path
              table.insert(dirList, filePath)
            elseif type(result) == "string" then
              table.insert(dirTable.fileList, filePath)
            end
          end
        end
        for _, dirPath in ipairs(dirList) do
          table.insert(dirTable.fileList, 1, dirPath)
        end
        self.allDirData[path] = dirTable
        return dirTable
      elseif string.match(path, "%.cha$") then
        return path
      end
    end
  end
  
  analyzePath(self.root)
  self.currentDir = self.allDirData[self.root]
end

function class:readCha(path)
  local data = EDGetFileData(path)
  local p = data
  local index = 1
  local name, index = readString(p, index)
  local elements_count, index = readT(p, index, "uint32")
  local elements = {}
  for i = 0, elements_count - 1 do
    local ele_name, ele_file, ele_index
    ele_name, index = readString(p, index)
    ele_file, index = readString(p, index)
    ele_index, index = readT(p, index, "uint32")
    table.insert(elements, {
      name = ele_name,
      file = ele_file,
      index = ele_index
    })
  end
  local actions_count
  actions_count, index = readT(p, index, "uint32")
  local actions = {}
  for i = 0, actions_count - 1 do
    local action_name, action_fps
    action_name, index = readString(p, index)
    action_fps, index = readT(p, index, "uint32")
    local frames_count
    frames_count, index = readT(p, index, "uint32")
    table.insert(actions, {
      action_name = action_name,
      action_fps = 24,
      frames_count = frames_count
    })
    for j = 0, frames_count - 1 do
      local frames = {}
      local events_count
      events_count, index = readT(p, index, "uint32")
      for k = 0, events_count - 1 do
        local filename
        index = index + 4
        filename, index = readString(p, index)
        index = index + 4
        index = index + 4
        index = index + 24
        index = index + 4
      end
      local elements_count
      elements_count, index = readT(p, index, "uint32")
      index = index + elements_count * 27
    end
  end
  return actions
end

function class:refreshPath()
  ed.setLabelString(self.ui.label_path, "path:" .. self.currentDir.dirName)
end

function class:refreshBtnAction(actionName)
  self.ui.label_action:setString(actionName)
end

function class:initTableView()
  self.delegate = {
    numberOfCells = function()
      return #(self.showDataList or {})
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(225, 18)
    end,
    createCell = function(index)
      local data = self.showDataList[index]
      local item, ui, isDir
      if string.match(data, "%.cha$") then
        item, ui = self:createFileItem(data)
      else
        item, ui = self:createDirItem(data)
        isDir = true
      end
      return item, {
        data = data,
        ui = ui,
        isDir = isDir
      }
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      return cell
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      local ui = data.ui
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local ui = data.ui
      local isDir = data.isDir
      if isDir then
        self.currentDir = self.allDirData[data.data]
        self:refreshTableView()
      else
        self:onClickFcaFile(data.data)
      end
    end
  }
  local size = self.ui.panel_list:getContentSize()
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:refreshTableView()
  self:refreshPath()
  local dirData = self.currentDir
  self.showDataList = dirData.fileList or {}
  local searchStr = self.ui.edit_box:getString()
  if searchStr and searchStr ~= "" then
    local searchResultList = {}
    for index, path in ipairs(self.showDataList) do
      if string.match(path, searchStr) then
        table.insert(searchResultList, path)
      end
    end
    self.showDataList = searchResultList
  end
  self.tableView:reloadData()
end

function class:createDirItem(fileName)
  local bg = ed.createSprite()
  bg:setContentSize(CCSizeMake(225, 18))
  local label = ed.createLabelTTF(fileName, 18)
  ed.setLabelColor(label, ccc3(126, 252, 95))
  bg:addChild(label)
  ed.layout.centerInParent(label)
  bg.type = "dir"
  bg.fileName = fileName
  return bg
end

function class:createFileItem(filePath)
  local fileName = getFileName(filePath)
  local bg = ed.createSprite()
  bg:setContentSize(CCSizeMake(225, 18))
  local label = ed.createLabelTTF(fileName or "", 18)
  ed.setLabelColor(label, ccc3(255, 252, 231))
  label:setAnchorPoint(ccp(0, 0.5))
  label:setPosition(30, 9)
  bg:addChild(label)
  bg.type = "file"
  bg.fileName = fileName
  bg.filePath = filePath
  return bg
end

function class:onClickFcaFile(fcaPath)
  local node = self:createFca(fcaPath)
  if not node then
    return
  end
  self.ui.panel_show:addChild(node)
  self:addFca(node.fca)
  self.fcaNodeList[node] = node
  node:setPosition(ccp(300, 300))
end

function class:onDeleteFcaNode(node)
  self:removeFca(node.fca)
  node:removeFromParentAndCleanup(true)
  self.fcaNodeList[node] = nil
  if self.selectNode == node then
    self.selectNode = nil
  end
end

function class:removeAllFcaNode()
  for _, node in pairs(self.fcaNodeList) do
    self:onDeleteFcaNode(node)
  end
end

function class:createFca(fcaPath)
  local fcaFullPath = fcaPath
  local bg = ed.createSprite()
  local size = CCSizeMake(100, 100)
  bg:setContentSize(size)
  local layerColor = CCLayerColor:create(ccc4(50, 50, 50, 50))
  bg:addChild(layerColor)
  layerColor:setContentSize(size)
  fcaPath = string.gsub(fcaPath, "^proto/", "")
  fcaPath = string.gsub(fcaPath, "%.cha$", "")
  local fca = ed.createFcaActor(fcaPath)
  local actionName
  if string.match(fcaPath, "^effect") then
    actionName = "Loop"
  else
    actionName = "Idle"
    if not ed.getDataTable("Puppet")[fcaPath .. ".cha"] then
      ed.showToast("Puppet\232\161\168\228\184\173\230\178\161\230\156\137:" .. fcaPath)
      return
    end
  end
  if not fca then
    print("create fca error" .. fcaFullPath)
    ed.showToast("fca\229\136\155\229\187\186\229\188\130\229\184\184:" .. fcaFullPath)
    return
  end
  fca:setAction(actionName)
  fca:setLoop(true)
  bg:addChild(fca)
  fca:setPositionX(size.width / 2)
  local labelPath = ed.createLabelTTF(fcaPath, 15)
  labelPath:setColor(ccc3(255, 252, 231))
  bg:addChild(labelPath)
  labelPath:setPosition(size.width / 2, -10)
  local imageSelect = ed.createSprite("UI/alpha/1080P/helper/helper_check.png")
  imageSelect:setPosition(0, size.height)
  bg:addChild(imageSelect)
  imageSelect:setVisible(false)
  bg.fca = fca
  bg.fcaPath = fcaPath
  bg.fcaFullPath = fcaFullPath
  bg.actionName = actionName
  bg.imageSelect = imageSelect
  return bg
end

function class:setSelectNode(node)
  if self.selectNode then
    self.selectNode.imageSelect:setVisible(false)
  end
  self.selectNode = node
  self.selectNode.imageSelect:setVisible(true)
  self:refreshBtnAction(node.actionName)
  self:showActionList()
end

function class:refreshPage()
  local size = self.ui.panel_show:getContentSize()
  self:removeAllFcaNode()
  local col = 5
  local startIndex = (self.page - 1) * 15 + 1
  local endIndex = math.min(startIndex + 14, #self.showDataList)
  local offset = 50
  local posX, posY = offset, 50
  local amount = 0
  print("111111111", startIndex, endIndex)
  for index = startIndex, endIndex do
    local filePath = self.showDataList[index]
    if string.match(filePath, "%.cha$") then
      local node = self:createFca(filePath)
      if node then
        self:addFca(node.fca)
        self.ui.panel_show:addChild(node)
        self.fcaNodeList[node] = node
        node:setPosition(posX, size.height - posY)
        posX = posX + 120
        amount = amount + 1
        if amount % col == 0 then
          posX = offset
          posY = posY + 120
        end
      end
    end
  end
end

function class:showActionList()
  if not self.selectNode then
    ed.showToast("\229\133\136\233\128\137\230\139\169\228\184\128\228\184\170\229\138\168\231\148\187")
    return
  end
  local actionInfoList = self.selectNode.actionInfoList
  if not actionInfoList then
    local fcaFullPath = self.selectNode.fcaFullPath
    actionInfoList = self:readCha(fcaFullPath)
    self.selectNode.actionInfoList = actionInfoList
  end
  if self.actionListBg then
    self.actionListBg:removeFromParentAndCleanup(true)
  end
  local actionListBg = CCLayerColor:create(ccc4(100, 100, 100, 100))
  self.actionListBg = actionListBg
  local size = CCSizeMake(110, #(actionInfoList or {}) * 16)
  actionListBg:setContentSize(size)
  for index, actionInfo in ipairs(actionInfoList or {}) do
    local labelAction = ed.createLabelTTF(string.format("%s  \229\133\177%s\229\184\167", actionInfo.action_name, actionInfo.frames_count), 14)
    labelAction:setAnchorPoint(ccp(0, 0.5))
    labelAction:setColor(ccc3(255, 252, 231))
    labelAction:setPosition(5, 16 * index - 7)
    actionListBg:addChild(labelAction)
    self:btRegisterButtonClick({
      button = labelAction,
      key = actionInfo.action_name,
      clickHandler = function()
        if not self.selectNode then
          return
        end
        self:refreshBtnAction(actionInfo.action_name)
        self.selectNode.actionName = actionInfo.action_name
        self.selectNode.fca:setAction(actionInfo.action_name)
      end,
      force = true,
      pressScale = 0.95
    })
  end
  self.ui.btn_action:addChild(actionListBg)
  actionListBg:setPosition(0, -size.height)
end

function class:doShowLayerTouch()
  local function handle(event, x, y)
    if event == "began" then
      for _, node in pairs(self.fcaNodeList) do
        if ed.containsPoint(node, x, y) then
          self.pressNode = node
          
          self.pressX, self.pressY = x, y
          self.pressStartX, self.pressStartY = node:getPosition()
          return true
        end
      end
    elseif event == "moved" then
      if self.pressNode then
        self.pressNode:setPosition(self.pressStartX + x - self.pressX, self.pressStartY + y - self.pressY)
      end
    elseif event == "ended" then
      if not self.pressNode then
        return
      end
      if ed.containsPoint(self.ui.delete_area, x, y) then
        self:onDeleteFcaNode(self.pressNode)
      end
      if ed.containsPoint(self.pressNode, x, y) and math.abs(x - self.pressX) < 20 and math.abs(y - self.pressY) < 20 then
        self:setSelectNode(self.pressNode)
      end
      self.pressNode = nil
      self.pressX, self.pressY = nil, nil
      self.pressStartX, self.pressStartY = nil, nil
    end
  end
  
  return handle
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "image_search_bg", function()
    self.ui.edit_box.edit:openKeyBoard()
  end, {pressScale = 0.95, priority = -301})
  ed.UITool.registerBtn(self, "btn_search", function()
    self:refreshTableView()
  end, {pressScale = 0.75, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_up", function()
    if not self.currentDir.parentDirName then
      return
    end
    self.currentDir = self.allDirData[self.currentDir.parentDirName]
    self:refreshTableView()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_pause", function()
    self.pause = not self.pause
    ed.setLabelString(self.ui.label_pause, self.pause and T("\231\187\167\231\187\173") or T("\230\154\130\229\129\156"))
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_speed", function()
    self.speedIndex = self.speedIndex % #self.speedList + 1
    self.speed = self.speedList[self.speedIndex]
    ed.setLabelString(self.ui.label_speed, string.format("x%s\229\128\141\233\128\159", self.speed))
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_scale", function()
    self.scaleIndex = self.scaleIndex % #self.scaleList + 1
    self.scale = self.scaleList[self.scaleIndex]
    ed.setLabelString(self.ui.label_scale, string.format("x%s\231\188\169\230\148\190", self.scale))
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_next_frame", function()
    if not self.pause then
      ed.showToast(T("\229\133\136\230\154\130\229\129\156"))
      return
    end
    self:updateFca(0.041666666666666664, true)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_reset", function()
    ed.showToast("\230\156\170\229\174\158\231\142\176")
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_review", function()
    self:refreshPage()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_pre_page", function()
    local page = math.max(self.page - 1, 1)
    if page ~= self.page then
      self.page = page
      self:refreshPage()
    end
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_next_page", function()
    local page = math.min(self.page + 1, math.ceil(#self.showDataList / 15))
    if page ~= self.page then
      self.page = page
      self:refreshPage()
    end
  end, {pressScale = 0.95})
end
