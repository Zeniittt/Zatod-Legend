local accordion = {}
setmetatable(accordion, {__index = _G})
ed.accordion = accordion

function accordion.createAccordion(container, params)
  local self = {}
  setmetatable(self, {__index = accordion})
  local size = container:getContentSize()
  self.listSize = size
  params = params or {}
  setmetatable(params, {
    __index = {
      cliprect = CCRectMake(0, 0, size.width, size.height),
      vertex = {
        winLeft = 0,
        winRight = 0,
        winTop = 0,
        winBottom = 0
      },
      isBoom = false,
      isTakeBack = false,
      isTrigger = function()
        return true
      end
    },
    __newindex = function(table, key, value)
    end
  })
  self.createDraglist(self, container, params)
  self.params = params
  self.accIsTrigger = params.isTrigger
  self.accDoClickIn = params.doClickOut
  self.accAllClickOut = params.doAllClickOut
  self.treeBtnResNew = params.treeBtnRes
  self.anchor = params.anchor
  self.isTakeBack = params.isTakeBack
  return self
end

local speed = 0.5
local treeBtnRes = {
  {
    normal = "UI/alpha/1080P/common/button_com_big.png",
    press = "UI/alpha/1080P/common/button_red.png",
    height = 50
  },
  {
    normal = "UI/alpha/1080P/rankingscene/ranking_unselected.png",
    press = "UI/alpha/1080P/rankingscene/ranking_selected.png",
    height = 42
  },
  {
    normal = "UI/alpha/1080P/rankingscene/ranking_unselected_1.png",
    press = "UI/alpha/1080P/rankingscene/ranking_selected_1.png",
    height = 35
  }
}
local treeBtnResNew

function accordion:createAddAcclist(items)
  self:addAcclist(items)
end

function accordion:passTreeIndex(...)
  local boom = select(1, ...)
  if boom and type(boom) ~= "number" then
    self:openTreeIndexInBoom(select(2, ...))
  elseif select("#", ...) > 0 then
    self:openTreeIndex(...)
  end
end

function accordion:getIndexAccDragNode(level, index)
  if level then
    return self.accDragNode[level] and (self.accDragNode[level][index] or {}) or {}
  else
    return self.accDragNode[level] or {}
  end
end

function accordion:createDraglist(container, params)
  local size = container:getContentSize()
  self.listSize = size
  local info = {
    container = container,
    priority = params.priority,
    cliprect = params.cliprect,
    zorder = params.zorder or 1,
    noshade = true,
    doPressIn = self:doPressIn(),
    doClickIn = self:clickInFun(true),
    cancelPressIn = self:clickInFun(),
    cancelClickIn = self:clickInFun()
  }
  self.draglist = ed.draglist.create(info)
end

local function addAccTreeButt(index, anchor, v)
  treeBtnResNew = treeBtnResNew or treeBtnRes
  index = index > #treeBtnResNew and #treeBtnResNew or index
  local nolRes = treeBtnResNew[index].normal or ""
  local layer = CCLayer:create()
  local normal = ed.createSprite(nolRes)
  local press = ed.createSprite(treeBtnResNew[index].press)
  normal:addChild(press, 7)
  if nolRes == "" then
    local size = press:getContentSize()
    normal:setContentSize(size)
  end
  local size = normal:getContentSize()
  anchor = anchor or 0.5
  press:setPosition(size.width * anchor, size.height / 2)
  press:setVisible(false)
  normal:setAnchorPoint(ccp(anchor, 0.5))
  press:setAnchorPoint(ccp(anchor, 0.5))
  local label = ed.ui.autoText.new()
  label:initParam({
    context = v.name2 or v.name
  })
  local width, height = label:getCurContentSize()
  if v.limitWidth then
    local limitScale = math.min(1, v.limitWidth / width)
    label.node:setScale(limitScale)
    width = width * limitScale
  end
  local nameOffset = v.nameOffset or ed.ccpZero
  label.node:setPosition((size.width - width) / 2 + nameOffset.x, size.height / 2 + nameOffset.y)
  press:addChild(label.node)
  label = ed.ui.autoText.new()
  label:initParam({
    context = v.name
  })
  local width, height = label:getCurContentSize()
  if v.limitWidth then
    local limitScale = math.min(1, v.limitWidth / width)
    label.node:setScale(limitScale)
    width = width * limitScale
  end
  label.node:setPosition((size.width - width) / 2 + nameOffset.x, size.height / 2 + nameOffset.y)
  normal:addChild(label.node, 6)
  layer:addChild(normal)
  local layerChildren = CCLayer:create()
  layer:addChild(layerChildren, -1)
  return layer, normal, press, label, layerChildren, size
end

function accordion:addAcclist(items)
  if self.draglist and items then
    self.nodeKey = {}
    self.draglist:clearList()
    self.accDragNode = {}
    local vertex, index, height = self.params.vertex, 1
    treeBtnResNew = self.treeBtnResNew or treeBtnRes
    
    local function func(node, tree, isTop)
      local idx = index
      self.accDragNode[idx] = self.accDragNode[idx] or {}
      for i, v in ipairs(tree) do
        local layer, buttNode, press, label, layerChildren, size = addAccTreeButt(idx, self.anchor, v)
        layer:setVisible(isTop)
        if v.tree and #v.tree > 0 then
          index = index + 1
          func(layerChildren, v.tree)
          index = idx
        end
        if isTop then
          height = height or size.height
          node:addItem(layer, ccp(self.listSize.width / 2 + (vertex.winLeft or 0) - (vertex.winRight or 0), self.listSize.height - i * height + height / 2 - (vertex.winTop or 0)))
        else
          node:addChild(layer, -1 * index)
        end
        layer.indexLa = idx
        layer.layerChildren = layerChildren
        layer.press = press
        layer.nodeData = v.data
        layer.notLeafNode = v.tree and #v.tree > 0
        table.insert(self.accDragNode[idx], {
          layer = layer,
          layerChildren = layerChildren,
          node = buttNode,
          press = press,
          label = label,
          data = v.data,
          isTop = isTop,
          index = idx,
          notLeafNode = v.tree and #v.tree > 0
        })
      end
    end
    
    func(self.draglist, items, true)
    self.draglist:initListHeight(height * #items + (vertex.winTop or 0) + (vertex.winBottom or 0))
  end
end

function accordion:doPressIn()
  return function(x, y)
    if self.notTouch then
      return
    end
    
    local function func(x, y)
      local items = self.accDragNode or {}
      for i, v in ipairs(items) do
        for key, btn in ipairs(v) do
          if btn.layer:isVisible() and ed.containsPoint(btn.node, x, y) then
            btn.node:setScale(0.9)
            return btn, i
          end
        end
      end
    end
    
    self.notTouch = true
    ListenTimer(Timer:Once(0.1), function()
      self.notTouch = false
    end)
    return func(x, y)
  end
end

function accordion:clickInFun(right)
  return function(x, y, btn, index)
    if btn then
      btn.node:setScale(1)
    end
    if right and self.accIsTrigger() and btn.press then
      local pas = btn.press:isVisible()
      if pas and self.isTakeBack then
        return
      end
      btn.press:setVisible(not pas)
      if self.newBtn and self.newBtn ~= btn and self.newBtn.index > btn.index then
        local pass = self.newBtn.layer
        pass.press:setVisible(false)
        while btn.index ~= pass.indexLa do
          pass = pass:getParent()
          if pass then
            if pass.press then
              pass.press:setVisible(false)
            else
              pass = pass:getParent()
              if pass and pass.press then
                pass.press:setVisible(false)
              else
                break
              end
            end
          elseif true then
            break
          else
            break
          end
        end
      elseif self.newBtn and self.newBtn ~= btn and self.newBtn.index == btn.index then
        self.newBtn.press:setVisible(false)
      end
      self.newBtn = btn
      if self.accAllClickOut then
        self.accAllClickOut(not btn.notLeafNode, btn.press:isVisible(), btn.data or {data = "nil"})
      end
      if btn.notLeafNode then
        if btn.press:isVisible() and self.params.isBoom then
          local selectedIdx = ed.copyTable(btn.data and (btn.data.selectedIdx or {0}) or {0})
          
          local function func(node)
            local Children = node.layerChildren:getChildren()
            local num, lay = Children and Children:count() or 0
            if 0 < num then
              lay = Children:objectAtIndex(selectedIdx[1] or 0)
              lay.press:setVisible(true)
              if selectedIdx[1] then
                table.remove(selectedIdx, 1)
              end
              return func(lay)
            else
              return node
            end
          end
          
          btn = func(btn)
          self.newBtn = {
            layer = btn,
            index = btn.indexLa,
            press = btn.press
          }
          if self.accDoClickIn then
            self.accDoClickIn(btn.press:isVisible(), btn.data or btn.nodeData or {data = "nil"})
          end
        end
      elseif self.accDoClickIn then
        self.accDoClickIn(btn.press:isVisible(), btn.data or {data = "nil"})
      end
      self:passIndexButt(btn)
    end
  end
end

function accordion:passIndexButt(btn)
  local function moveToTime(distance)
    distance = math.abs(distance)
    
    local tm, de = 10, 0.1
    return distance / tm * de
  end
  
  local list = self.draglist:getList()
  local listPosx, listPosy = list:getPosition()
  local listHeight = self.draglist.listHeight
  treeBtnResNew = self.treeBtnResNew or treeBtnRes
  
  local function funcAction(layer, boom)
    local posh = 0
    local Children = layer.layerChildren:getChildren()
    if Children then
      local num = Children:count()
      local height = 0
      for i = 0, num - 1 do
        local v = Children:objectAtIndex(i)
        local index = v.indexLa
        index = index > #treeBtnResNew and #treeBtnResNew or index
        local btnHeight = treeBtnResNew[index].height
        local posY = boom and btnHeight * -1 - posh or 0
        if treeBtnResNew[index].topMargin and v.indexLa <= #treeBtnResNew then
          posY = posY - treeBtnResNew[index].topMargin
        end
        if v:getPositionY() ~= posY or v:isVisible() ~= boom then
          local action1 = CCEaseExponentialOut:create(CCMoveTo:create(speed, ccp(v:getPositionX(), posY)))
          local action2 = CCCallFunc:create(function()
            v:setVisible(boom)
          end)
          if boom then
            local newAction2 = action2
            action2 = action1
            action1 = newAction2
          end
          v:stopAllActions()
          v:runAction(CCSequence:create(ccArrayMake({action1, action2})))
        end
        if v.layerChildren then
          posh = posh + funcAction(v, v.press:isVisible())
        end
        if boom then
          posh = posh + btnHeight
          height = height + btnHeight
        end
      end
    end
    return posh
  end
  
  local posY
  local allHeight = 0
  local items = self.accDragNode or {}
  for key, btn in ipairs(items[1] or {}) do
    local btnHeight = treeBtnResNew[1].height
    posY = posY or btn.layer:getPositionY()
    btn.layer:stopAllActions()
    btn.layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(speed, ccp(btn.layer:getPositionX(), posY))))
    local height = funcAction(btn.layer, btn.press:isVisible())
    posY = posY - height - btnHeight
    allHeight = allHeight + height + btnHeight
  end
  self.draglist:initListHeight(allHeight + 30, true)
  if listPosx and listPosy and listHeight then
    if listHeight <= self.draglist.listHeight then
      self.draglist:setListPos(ccp(listPosx, listPosy))
    else
      if self.draglist.listHeight <= self.draglist.height then
        return
      elseif listPosy > self.draglist.listHeight - self.draglist.height then
        listPosy = self.draglist.listHeight - self.draglist.height
      end
      self.draglist:setListPos(ccp(listPosx, listPosy))
    end
  end
end

function accordion:openTreeIndexInBoom(...)
  local treeIdx = {
    ...
  }
  if type(treeIdx) ~= "table" then
    return
  end
  local items = self.accDragNode or {}
  local i, v, btn = 1, 0
  while i < 999 do
    v = treeIdx[i] or 1
    local lay
    if i == 1 then
      lay = items[1] and items[1][v] and items[1][v].layer or nil
    elseif btn then
      local Children = btn.layerChildren:getChildren()
      if Children and 0 < v then
        lay = Children:objectAtIndex(v - 1)
      else
        break
      end
    end
    if lay then
      btn = lay
      lay.press:setVisible(true)
    else
      break
    end
    i = i + 1
  end
  if btn then
    self.newBtn = {
      layer = btn,
      index = btn.indexLa,
      press = btn.press
    }
    self:passIndexButt(btn)
    if self.accDoClickIn then
      self.accDoClickIn(btn.press:isVisible(), btn.data or btn.nodeData or {data = "nil"})
    end
  end
end

function accordion:openTreeIndex(...)
  local treeIdx = {
    ...
  }
  if type(treeIdx) ~= "table" then
    return
  end
  local btn
  local items = self.accDragNode or {}
  for i, v in ipairs(treeIdx) do
    local lay
    if i == 1 then
      lay = items[1] and items[1][v] and items[1][v].layer or nil
    elseif btn then
      local Children = btn.layerChildren:getChildren()
      if Children and 0 < v then
        lay = Children:objectAtIndex(v - 1)
      else
        break
      end
    end
    if lay then
      btn = lay
      lay.press:setVisible(true)
    else
      break
    end
  end
  if btn then
    self.newBtn = {
      layer = btn,
      index = btn.indexLa,
      press = btn.press
    }
    self:passIndexButt(btn)
    if not btn.notLeafNode and self.accDoClickIn then
      self.accDoClickIn(btn.press:isVisible(), btn.data or {data = "nil"})
    end
  end
end
