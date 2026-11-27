richText = {}
richText.__index = richText
richText.rootNode = nil
richText.pos = nil
richText.middle = false
richText.anchor = ccp(0, 0.5)
richText.width = 0
richText.height = 0
richText.currentScene = nil

function richText.new()
  local obj = {}
  setmetatable(obj, richText)
  obj:init()
  return obj
end

function richText:init()
  self.rootNode = CCSprite:create()
  self.rootNode:setCascadeOpacityEnabled(true)
  self.currentScene = ed.getCurrentScene()
  self.ui = {}
  self.link = {}
  self.lines = {}
end

function richText:setVerticalCenter()
  local offset_y = 0
  for k, param in ipairs(self.ui) do
    local anchor = param.node:getAnchorPoint()
    local size = param.node:getContentSize()
    if k == 1 then
      offset_y = self.height / 2 - param.height * (1 - anchor.y)
    end
    local x, y = param.node:getPosition()
    y = y + offset_y
    param.node:setPosition(ccp(x, y))
  end
end

function richText:createNewObject(param, extraData)
  if nil == param then
    return
  end
  local object_type, param1, param2, param3 = unpack(param)
  local newObject
  local width = 0
  local height = 0
  if object_type == "text" then
    newObject, width, height = self:createNewText(param1, param2, param3)
  elseif object_type == "sprite" then
    newObject, width, height = self:createNewSprite(param1, param2)
  elseif object_type == "artnum" then
    newObject, width, height = self:createNewArtNum(param1, param2)
  elseif object_type == "item" then
    newObject, width, height = self:createNewItem(param1, param2, param3)
  elseif object_type == "randsoul" then
    newObject, width, height = self:createNewRandSoul(param1, param2)
  elseif object_type == "link" then
    newObject, width, height = self:createNewLink(param1, param2, param3, extraData)
  elseif object_type == "emoji" then
    newObject, width, height = self:createNewEmoji(param1, param2)
  elseif object_type == "extra" then
    newObject, width, height = self:createNewExtra(param1, param2, extraData, param)
  elseif object_type == "sticker" then
    newObject, width, height = self:createNewSticker(param1, param2)
  else
    return nil, object_type
  end
  if newObject then
    self.rootNode:addChild(newObject)
  end
  return newObject, width, height, object_type
end

function richText:createNewText(fontInfo, text, widthDimen)
  local newObject
  local width = 0
  local height = 0
  if ed.isComplexText(text) then
    newObject = ed.createComplexLabel({text = text}).node
  else
    newObject = ed.createLabelWithFontInfo(text, fontInfo, true)
    newObject:setHorizontalAlignment(kCCTextAlignmentLeft)
  end
  if widthDimen then
    newObject:setDimensions(CCSizeMake(widthDimen, 0))
  end
  height = newObject:getContentSize().height
  if ed.isComplexText(text) then
    width = newObject:getContentSize().width
  else
    width = newObject:getContentSize().width
  end
  return newObject, width, height
end

function richText:createNewSprite(path, scaleSize)
  local newObject
  local width = 0
  local height = 0
  local scale = 1
  newObject = ed.createSprite(path)
  if scaleSize then
    newObject:setScale(scaleSize)
    scale = scaleSize
  end
  width = newObject:getTextureRect().size.width * scale
  height = newObject:getTextureRect().size.height * scale
  return newObject, width, height
end

function richText:createNewArtNum(colorType, number)
  local newObject
  local width = 0
  local height = 0
  newObject = CCNode:create()
  width, height = ed.createNumbers(newObject, number, -2, nil, colorType)
  return newObject, width, height
end

function richText:createNewItem(ItemID, scaleSize, count)
  local newObject
  local width = 0
  local height = 0
  local scale = 1
  if count then
    newObject = ed.readequip.createIconWithAmount(tonumber(ItemID), nil, tonumber(count) or 1)
  else
    newObject = ed.readequip.createIcon(tonumber(ItemID))
  end
  if scaleSize then
    newObject:setScale(scaleSize)
    scale = scaleSize
  end
  width = newObject:getTextureRect().size.width * scale
  height = newObject:getTextureRect().size.height * scale
  return newObject, width, height
end

function richText:createNewRandSoul(count, scaleSize)
  local newObject
  local width = 0
  local height = 0
  local scale = 1
  newObject = ed.readequip.getUnknownIcon(1, tonumber(count))
  if scaleSize then
    newObject:setScale(scaleSize)
    scale = scaleSize
  end
  width = newObject:getTextureRect().size.width * scale
  height = newObject:getTextureRect().size.height * scale
  return newObject, width, height
end

function richText:createNewLink(param1, param2, param3, extraData)
  local newObject
  local width = 0
  local height = 0
  local scale = 1
  local link = ed.createSuperLink(param1, param2, param3)
  table.insert(self.link, link)
  if extraData then
    link.ct_idx = param3
    link:setExtraData(extraData)
  end
  newObject = link:getLabel()
  if ed.isElementInTable(link.type, {"pvp"}) then
    newObject:setHorizontalAlignment(kCCTextAlignmentLeft)
  elseif ed.isElementInTable(link.type, {"excavate"}) then
    newObject:setAnchorPoint(ccp(0, 0.5))
  end
  local size = link:getSize()
  width, height = size.width, size.height
  return newObject, width, height
end

function richText:createNewEmoji(emojiIdx, scaleSize)
  local row = ed.getDataTable("ChatEmoji")[tonumber(emojiIdx)]
  if not row then
    return
  end
  local res = row["Emoji Cha"]
  local newObject
  local scale = tonumber(scaleSize)
  newObject = ed.createSprite(res)
  newObject:setScale(scale)
  local size = newObject:getContentSize()
  return newObject, size.width * scale, size.height * scale
end

function richText:createNewSticker(stickerId, scaleSize)
  local row = ed.getDataTable("Sticker")[tonumber(stickerId)]
  if not row then
    return
  end
  local res = row.Picture
  local newObject
  local scale = tonumber(scaleSize)
  newObject = ed.createSprite(res)
  newObject:setScale(scale)
  local size = newObject:getContentSize()
  return newObject, size.width * scale, size.height * scale
end

function richText:createNewExtra(ttype, key, extraData, param)
  local newObject
  if ttype == "enemy_team" then
    local link = ed.createSuperLink(ttype, key, extraData)
    table.insert(self.link, link)
    newObject = link:getLabel()
    return newObject, 0, 85
  elseif ttype == "chat_tag" then
    local bgPath = param[3]
    local textFontInfo = param[4]
    local text = param[5]
    local label = ed.createLabelWithFontInfo(text, textFontInfo, true)
    local bg = ed.createScale9Sprite(bgPath, CCRectMake(14, 6, 2, 2))
    local bg_size = bg:getContentSize()
    if bg_size.width < label:getContentSize().width then
      bg:setContentSize(CCSizeMake(label:getContentSize().width + 2, bg_size.height))
    end
    bg:addChild(label)
    ed.layout.centerInParent(label)
    local size = bg:getContentSize()
    return bg, size.width, size.height
  end
  return newObject, 0, 85
end

function richText:setString(content, extraData)
  if type(content) ~= "string" then
    print("richText content must be string!!")
  end
  self.width = 0
  self.height = 0
  local linewidth = 0
  if not tolua.isnull(self.rootNode) then
    self.rootNode:removeAllChildrenWithCleanup(true)
  end
  local object_type
  local startPos = ccp(0, 0)
  local changeLine = false
  local tempHeight = 0
  local inner = 0
  local line = {}
  
  local function addLine()
    if 0 < #line then
      table.insert(self.lines, line)
    end
    line = {}
  end
  
  content = ed.formatComplexLabel(content)
  for str in string.gmatch(content, "<.->") do
    str = ed.rebuildComplexLabel(str)
    local tab = self:divisionTextToTable(str)
    local newObject, width, height, object_type = self:createNewObject(tab, extraData)
    if newObject then
      if self.maxWidth and linewidth + width > self.maxWidth then
        changeLine = true
        self.height = self.height + tempHeight
        linewidth = 0
        self.width = self.maxWidth
      end
      if changeLine == true then
        changeLine = false
        startPos.x = 0
        startPos.y = startPos.y - height * (1 - self.anchor.y) - tempHeight * self.anchor.y - inner
        tempHeight = 0
        inner = 0
      end
      newObject:setPosition(startPos)
      newObject:setAnchorPoint(self.anchor)
      local ax = self.anchor.x
      startPos.x = startPos.x + (1 - ax) * width
      if linewidth < startPos.x then
        linewidth = startPos.x
      elseif startPos.x == 0 and 0 < width then
        linewidth = linewidth + width
      end
      if height > tempHeight then
        tempHeight = height
      end
      local param = {
        node = newObject,
        width = width,
        height = height
      }
      self.ui[#self.ui + 1] = param
      table.insert(line, param)
    else
      inner = tonumber(width) or 0
      self.height = self.height + tempHeight + inner
      changeLine = true
      addLine()
    end
  end
  addLine()
  if self.width == 0 then
    self.width = linewidth
  end
  self.height = self.height + tempHeight
  self:refreshPos(startPos.x)
end

function richText:alignToWidest()
  local maxWidth = 0
  local widthT = {}
  for k, v in ipairs(self.lines) do
    local width = 0
    for kk, vv in ipairs(v) do
      width = width + vv.width
    end
    widthT[k] = width
    if maxWidth < width then
      maxWidth = width
    end
  end
  for k, v in ipairs(self.lines) do
    local ox = (maxWidth - widthT[k]) / 2
    for kk, vv in ipairs(v) do
      local node = vv.node
      node:setPositionX(node:getPositionX() + ox)
    end
  end
end

function richText:divisionTextToTable(str)
  local t = {}
  local i = 0
  local temp = string.sub(str, 2, string.len(str) - 1)
  while true do
    local start = string.find(temp, "|", i + 1)
    if start == nil then
      table.insert(t, string.sub(temp, i + 1, string.len(temp)))
      break
    end
    table.insert(t, string.sub(temp, i + 1, start - 1))
    i = start
    if t[1] == "text" and #t == 2 then
      start = string.find(temp, "|", i + 1)
      if start == nil then
        table.insert(t, string.sub(temp, i + 1, string.len(temp)))
        break
      end
      do
        local num = string.sub(temp, start + 1, string.len(temp))
        if tonumber(num) ~= nil then
          table.insert(t, string.sub(temp, i + 1, start - 1))
          table.insert(t, num)
          break
        end
        table.insert(t, string.sub(temp, i + 1, string.len(temp)))
      end
      break
    end
  end
  return t
end

function richText:getControllerSize()
  local minx, miny = 10000, 10000
  local maxx, maxy = -10000, -10000
  local childCount = self.rootNode:getChildrenCount()
  local children = self.rootNode:getChildren()
  if children then
    for i = 0, children:count() - 1 do
      local child = children:objectAtIndex(i)
      if child then
        local rect = ed.getNodeSize(child)
        if rect then
          if minx > rect:getMinX() then
            minx = rect:getMinX()
          end
          if maxx < rect:getMaxX() then
            maxx = rect:getMaxX()
          end
          if miny > rect:getMinY() then
            miny = rect:getMinY()
          end
          if maxy < rect:getMaxY() then
            maxy = rect:getMaxY()
          end
        end
      end
    end
  end
  return minx, maxx, miny, maxy
end

function richText:refreshPos(width)
  if self.middle == false then
    return
  end
  local posx, posy
  if self.pos == nil then
    posx, posy = self.rootNode:getPosition()
    self.pos = ccp(posx, posy)
  else
    posx = self.pos.x
    posy = self.pos.y
  end
  posx = posx - width / 2
  self.rootNode:setPosition(ccp(posx, posy))
end

function richText:setVisible(visible)
  if self.rootNode then
    self.rootNode:setVisible(visible)
  end
end

function richText:setPosition(pos)
  self.pos = pos
  self.rootNode:setPosition(pos)
end

function richText:setAnchor(anchor)
  self.anchor = anchor
end

function richText:setAnchorPoint(anchor)
  self.rootNode:setAnchorPoint(anchor)
end

function richText:setMiddle(middle)
  self.middle = middle
end

function richText:getRootNode()
  return self.rootNode
end

function richText:getLink(index)
  index = index or 1
  return self.link[index]
end

function richText:getLinkAll()
  return self.link
end

function richText:getSize()
  return self.width, self.height
end

function richText:getContentSize()
  return CCSizeMake(self.width, self.height)
end

function richText:getPosition()
  return self.rootNode:getPosition()
end

function richText:setMaxWidth(maxWidth)
  self.maxWidth = maxWidth
end

function ed.setRichTextExtraInfo(key, extraInfo)
  ed.linkExtraInfo = ed.linkExtraInfo or {}
  ed.linkExtraInfo[key] = extraInfo
end

function ed.getRichTextExtraInfo(key)
  return ed.linkExtraInfo[key]
end
