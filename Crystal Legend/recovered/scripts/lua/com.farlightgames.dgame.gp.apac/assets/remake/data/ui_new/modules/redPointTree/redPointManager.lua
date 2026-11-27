local class = {}
local redPointMgrInstance
local redPointNode = {}
ed.redPointMgr = class
local isDebug = false
class.isDebug = isDebug

function class.getInstance()
  if not redPointMgrInstance then
    redPointMgrInstance = class.create()
  end
  return redPointMgrInstance
end

function class.create()
  local self = {}
  setmetatable(self, {__index = class})
  self:init()
  return self
end

function class:init()
  self.nodeTree = {}
  self.haveCycle = false
  self.referToKeyList = {}
  self:initConfig()
  self:checkCycle()
end

function class:printNodeValue(key, parentName)
  local node = self:getNode(key)
  if node then
    local name = parentName and parentName .. "-->" .. key or key
    print(name .. ":" .. node:getValue())
    for childKey, _ in pairs(node:getChildren()) do
      self:printNodeValue(childKey, name)
    end
  end
end

function class:initConfig()
  local redPointTreeTB = ed.getDataTable("RedPointTree")
  for key, config in pairs(redPointTreeTB or {}) do
    local node = self:getNode(key)
    node = node or self:createNode(key)
    local childKeyList = config["child key"]
    for _, childKey in ipairs(childKeyList or {}) do
      local childNode = self:getNode(childKey)
      childNode = childNode or self:createNode(childKey)
      childNode:addParent(key)
      node:addChild(childKey)
    end
  end
end

function class:checkCycle()
  if not class.isDebug then
    return
  end
  local haveCycle = false
  
  local function check(curNode, checkList)
    if not curNode then
      return false
    end
    for i, key in ipairs(checkList) do
      if curNode:getKey() == key then
        if class.isDebug then
          print("=====================redPointTreeCycle=====================")
          print("\231\186\162\231\130\185\230\160\145\229\173\152\229\156\168\231\142\175\239\188\140\232\175\183\230\163\128\230\159\165\233\133\141\231\189\174\232\161\168\239\188\154")
          ed.pt(checkList)
          print("\229\173\152\229\156\168\231\142\175\231\154\132\232\138\130\231\130\185", key)
          print("=====================redPointTreeCycle=====================")
        end
        return true
      end
    end
    table.insert(checkList, curNode:getKey())
    for childKey, _ in pairs(curNode:getChildren()) do
      if check(self:getNode(childKey), checkList) then
        return true
      end
    end
    table.remove(checkList, #checkList)
    return false
  end
  
  for k, node in pairs(self.nodeTree) do
    local checkList = {}
    if check(node, checkList) then
      haveCycle = true
      break
    end
  end
  if class.isDebug then
    print("haveCycle:", haveCycle)
  end
  self.haveCycle = haveCycle
  return haveCycle
end

function class:createNode(key)
  local node = self:getNode(key)
  if not node then
    node = redPointNode.create(key)
    self.nodeTree[key] = node
  end
  return node
end

function class:getNode(key)
  return self.nodeTree[key] or nil
end

function class:setNodeValue(key, value, force)
  if self.haveCycle then
    print("set Value fail, haveCycle!!!")
    return
  end
  if type(value) == "boolean" then
    value = value and 1 or 0
  end
  local node = self:getNode(key)
  if node then
    node:setValue(value, force)
    node:visit()
  end
end

function class:clearNode(key)
  self:setNodeValue(key, 0)
end

function class:getNodeValue(key)
  local node = self:getNode(key)
  if node then
    return node:getValue()
  end
  return 0
end

function class:deleteNode(key)
  local node = self:getNode(key)
  if not node then
    return
  end
  self:setNodeValue(key, 0)
  for parentKey, _ in pairs(node:getParents()) do
    local parentNode = self:getNode(parentKey)
    if parentNode then
      parentNode:deleteChild(key)
    end
  end
  for childKey, _ in pairs(node:getChildren()) do
    local childNode = self:getNode(childKey)
    if childNode then
      childNode:deleteParent(key)
      local haveParent = false
      for _, _ in pairs(childNode:getParents()) do
        haveParent = true
        break
      end
      if not haveParent then
        self:deleteNode(childKey)
      end
    end
  end
  self.nodeTree[key] = nil
end

function class:addNode(key, parents, value)
  local node = self:getNode(key)
  if node then
    return
  end
  node = self:createNode(key)
  for index, parentKey in ipairs(parents or {}) do
    local parentNode = self:getNode(parentKey)
    if parentNode then
      parentNode:addChild(key)
      node:addParent(parentKey)
    end
  end
  if self:checkCycle() then
    print("haveCycle!!!")
    return
  end
  if value then
    node:setValue(value)
  end
  return node
end

function class:registerValueChange(key, refer, param)
  local node = self:getNode(key)
  if node then
    node:registerValueChange(refer, param)
  end
  if not self.referToKeyList[refer] then
    self.referToKeyList[refer] = {}
  end
  self.referToKeyList[refer][key] = 1
end

function class:unregisterValueChange(key, refer)
  local node = self:getNode(key)
  if node then
    node:unregisterValueChange(refer)
  end
  if self.referToKeyList[refer] then
    self.referToKeyList[refer][key] = nil
    local haveItem = false
    for _, _ in pairs(self.referToKeyList[refer]) do
      haveItem = true
      break
    end
    if not haveItem then
      self.referToKeyList[refer] = nil
    end
  end
end

function class:unregisterAllValueChange(refer)
  local keyList = self.referToKeyList[refer]
  if keyList then
    for key, value in pairs(keyList) do
      local node = self:getNode(key)
      if node then
        node:unregisterValueChange(refer)
      end
    end
  end
  self.referToKeyList[refer] = nil
end

function redPointNode.create(key)
  local self = {}
  setmetatable(self, {
    __index = redPointNode,
    __tostring = function()
      return self.key .. ":" .. self.value
    end
  })
  self:init(key)
  return self
end

function redPointNode:init(key)
  self.key = key
  self.value = 0
  self.parents = {}
  self.children = {}
  self.valueChangeHandleList = {}
  self.priorityList = {}
  self.isInProcessing = false
  self.isDirty = false
end

function redPointNode:registerValueChange(refer, param)
  param = param or {}
  local priority = param.priority or 1
  local force = param.force or false
  local handle = param.handle
  local notImmediately = param.notImmediately
  self:addPriority(priority)
  if not self.valueChangeHandleList[priority] then
    self.valueChangeHandleList[priority] = {}
  end
  local handleList = self.valueChangeHandleList[priority]
  if force or not handleList[refer] then
    handleList[refer] = handle
  end
  if not notImmediately then
    handle(self.value)
  end
end

function redPointNode:unregisterValueChange(refer)
  for priority, handleList in pairs(self.valueChangeHandleList) do
    handleList[refer] = nil
  end
end

function redPointNode:addPriority(needPriority)
  if #self.priorityList <= 0 then
    table.insert(self.priorityList, needPriority)
    return
  end
  local insertIndex
  for index, priority in ipairs(self.priorityList) do
    if needPriority == priority then
      return
    elseif needPriority < priority then
      insertIndex = index
      break
    end
  end
  if insertIndex then
    table.insert(self.priorityList, insertIndex, needPriority)
  else
    table.insert(self.priorityList, needPriority)
  end
end

function redPointNode:checkHandle()
  for index, priority in ipairs(self.priorityList) do
    local handleList = self.valueChangeHandleList[priority]
    for refer, handle in pairs(handleList or {}) do
      handle(self.value)
    end
  end
end

function redPointNode:getParents()
  return self.parents
end

function redPointNode:getChildren()
  return self.children
end

function redPointNode:setValue(value, force)
  if self.isInProcessing then
    if class.isDebug then
      print(self.key, "isInProcessing")
    end
    return
  end
  value = value or 0
  if self.value == value and not force then
    return
  end
  self.value = value
  self.isDirty = true
  if class.isDebug then
    print("red Point Update:", self.key, self.value)
  end
  self.isInProcessing = true
  if value == 0 then
    self:clearChildrenValue()
  end
  self:notifyParents()
  self.isInProcessing = false
end

function redPointNode:visit()
  if self.isDirty then
    self.isDirty = false
    if class.isDebug then
      print("red Point Visit:", self.key, self.value)
    end
    self:checkHandle()
    for childKey, _ in pairs(self.children) do
      local childNode = class.getInstance():getNode(childKey)
      if childNode then
        childNode:visit()
      end
    end
    for parentKey, _ in pairs(self.parents) do
      local parentNode = class.getInstance():getNode(parentKey)
      if parentNode then
        parentNode:visit()
      end
    end
  end
end

function redPointNode:getKey()
  return self.key
end

function redPointNode:getValue()
  return self.value
end

function redPointNode:addParent(key)
  if self.parents[key] then
    if class.isDebug then
      print("parent is exist " .. key)
    end
    return
  end
  self.parents[key] = 1
end

function redPointNode:deleteParent(key)
  self.parents[key] = nil
end

function redPointNode:addChild(key)
  if self.children[key] then
    if class.isDebug then
      print("child is exist " .. key)
    end
    return
  end
  self.children[key] = 1
end

function redPointNode:deleteChild(key)
  self.children[key] = nil
end

function redPointNode:notifyParents()
  for parentKey, _ in pairs(self.parents or {}) do
    local parentNode = class.getInstance():getNode(parentKey)
    if parentNode then
      parentNode:beNotifiedByChild(self.key)
    end
  end
end

function redPointNode:clearChildrenValue()
  for childKey, _ in pairs(self.children or {}) do
    local childNode = class.getInstance():getNode(childKey)
    if childNode then
      childNode:beClearedByParent(self.key)
    end
  end
end

function redPointNode:beClearedByParent(parentKey)
  if self.parents[parentKey] then
    self:setValue(0)
  end
end

function redPointNode:beNotifiedByChild(childKey)
  local totleValue = 0
  for childKey, _ in pairs(self.children or {}) do
    local childNode = class.getInstance():getNode(childKey)
    if childNode then
      totleValue = totleValue + childNode:getValue()
    end
  end
  self:setValue(totleValue)
end
