newRichText = {}
newRichText.__index = newRichText
newRichText.rootNode = nil
newRichText.pos = nil
newRichText.middle = false
newRichText.anchor = ccp(0, 0.5)
newRichText.width = 0
newRichText.height = 0
newRichText.currentScene = nil

function newRichText.new()
  local obj = {}
  setmetatable(obj, newRichText)
  obj:init()
  return obj
end

function newRichText:init()
  self.rootNode = CCSprite:create()
  self.currentScene = ed.getCurrentScene()
  self.ui = {}
  self.link = {}
  self.lines = {}
end

function newRichText:setVerticalCenter()
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

function newRichText:setHorizontalCenter()
  local offset_x = self.width * 0.5
  for k, param in ipairs(self.ui) do
    local x, y = param.node:getPosition()
    x = x - offset_x
    param.node:setPosition(ccp(x, y))
  end
end

function newRichText:createNewObject(param, extraData)
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
  elseif object_type == "sticker" then
    newObject, width, height = self:createNewSticker(param1, param2)
  elseif object_type == "extra" then
    newObject, width, height = self:createNewExtra(param1, param2, extraData, param)
  else
    return nil, object_type
  end
  if newObject then
    self.rootNode:addChild(newObject)
  end
  return newObject, width, height, object_type
end

function newRichText:createNewText(fontInfo, text, widthDimen)
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

function newRichText:createNewSprite(path, scaleSize)
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

function newRichText:createNewArtNum(colorType, number)
  local newObject
  local width = 0
  local height = 0
  newObject = CCNode:create()
  width, height = ed.createNumbers(newObject, number, -2, nil, colorType)
  return newObject, width, height
end

function newRichText:createNewItem(ItemID, scaleSize, count)
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

function newRichText:createNewRandSoul(count, scaleSize)
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

function newRichText:createNewLink(param1, param2, param3, extraData)
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

function newRichText:createNewEmoji(emojiIdx, scaleSize)
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

function newRichText:createNewSticker(stickerId, scaleSize)
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

function newRichText:createNewExtra(ttype, key, extraData, param)
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

function newRichText:setString(content, extraData)
  if type(content) ~= "string" then
    print("newRichText content must be string!!")
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
  
  local function calculateLine(newObject, width, height, object_type)
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
      if startPos.x > linewidth then
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
  
  content = ed.formatComplexLabel(content)
  for str in string.gmatch(content, "<.->") do
    local tab = self:divisionTextToTable(str)
    local object_type, fontInfo, text, widthDimen = unpack(tab)
    if object_type == "text" and self.maxWidth then
      local result = self:cutString(text, self.maxWidth, self.maxWidth - linewidth, fontInfo)
      for i, str in ipairs(result) do
        local tab = {
          "text",
          fontInfo,
          str,
          widthDimen
        }
        local newObject, width, height, object_type = self:createNewObject(tab, extraData)
        calculateLine(newObject, width, height, object_type)
      end
    else
      local newObject, width, height, object_type = self:createNewObject(tab, extraData)
      calculateLine(newObject, width, height, object_type)
    end
  end
  addLine()
  if self.width == 0 then
    self.width = linewidth
  end
  self.height = self.height + tempHeight
  self:refreshPos(startPos.x)
end

function newRichText:cutString(str, maxWidth, leftWidth, fontInfo)
  local calcuStrWidth = ed.ui.autoTextConfig.getStrWidth
  local resultStringList = {}
  local startIndex = 1
  local endIndex = utf8.len(str)
  local leftWidth = leftWidth
  local font_info = EDTables.fontconfigs[fontInfo]
  local fontName = ed.font
  local fontSize = font_info.size or 15
  local cutString = utf8.sub(str, startIndex, endIndex)
  local newObject = ed.createLabelWithFontInfo(cutString, fontInfo, true)
  local objectSize = newObject:getContentSize()
  local ttfWidth = objectSize.width
  if leftWidth < ttfWidth then
    local totalWid = 0
    local index = 0
    local utfIndex = 0
    local wordBegin = 1
    local checkWord = false
    for k = 1, utf8.len(cutString) do
      index = index + 1
      utfIndex = utfIndex + 1
      if index > #cutString then
        break
      end
      local c = string.byte(cutString, index)
      if not c then
        break
      end
      if 0 <= c and c < 127 then
        local checkChar = string.byte(cutString, index)
        local str = string.char(checkChar)
        local size = calcuStrWidth(str, fontSize, fontName)
        totalWid = totalWid + size.width
        if self:checkIsAlphabet(c) then
          checkWord = true
        else
          if checkWord and self:checkEndCode(c) then
            wordBegin = utfIndex + 1
          else
            wordBegin = utfIndex
          end
          checkWord = false
        end
      elseif 192 <= c and c <= 223 then
        checkWord = false
        wordBegin = utfIndex
        local c1 = string.byte(cutString, index)
        local c2 = string.byte(cutString, index + 1)
        local size = calcuStrWidth(string.char(c1, c2), fontSize, fontName)
        totalWid = totalWid + size.width
        index = index + 1
      elseif 224 <= c and c <= 239 then
        checkWord = false
        wordBegin = utfIndex
        local c1 = string.byte(cutString, index)
        local c2 = string.byte(cutString, index + 1)
        local c3 = string.byte(cutString, index + 2)
        local size = calcuStrWidth(string.char(c1, c2, c3), fontSize, fontName)
        totalWid = totalWid + size.width
        index = index + 2
      elseif 240 <= c and c <= 247 then
        checkWord = false
        wordBegin = utfIndex
        local c1 = string.byte(cutString, index)
        local c2 = string.byte(cutString, index + 1)
        local c3 = string.byte(cutString, index + 2)
        local c4 = string.byte(cutString, index + 3)
        local size = calcuStrWidth(string.char(c1, c2, c3, c4), fontSize, fontName)
        totalWid = totalWid + size.width
        index = index + 3
      elseif 248 <= c and c <= 251 then
        checkWord = false
        wordBegin = utfIndex
        local c1 = string.byte(cutString, index)
        local c2 = string.byte(cutString, index + 1)
        local c3 = string.byte(cutString, index + 2)
        local c4 = string.byte(cutString, index + 3)
        local c5 = string.byte(cutString, index + 4)
        local size = calcuStrWidth(string.char(c1, c2, c3, c4, c5), fontSize, fontName)
        totalWid = totalWid + size.width
        index = index + 4
      end
      if leftWidth < totalWid or index == #cutString then
        if wordBegin == 1 and leftWidth == maxWidth then
          endIndex = utfIndex - 1
          break
        end
        endIndex = wordBegin - 1
        break
      end
    end
  end
  local leftString = utf8.sub(str, startIndex, endIndex)
  table.insert(resultStringList, leftString)
  if endIndex < utf8.len(str) then
    local rightString = utf8.sub(str, endIndex + 1, utf8.len(str))
    if rightString and rightString ~= "" then
      local rightStringList = self:cutString(rightString, maxWidth, maxWidth, fontInfo)
      for index, str in ipairs(rightStringList) do
        table.insert(resultStringList, str)
      end
    end
  end
  return resultStringList
end

function newRichText:alignToWidest()
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

function newRichText:divisionTextToTable(str)
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

function newRichText:getControllerSize()
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

function newRichText:refreshPos(width)
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

function newRichText:setVisible(visible)
  if self.rootNode then
    self.rootNode:setVisible(visible)
  end
end

function newRichText:setPosition(pos)
  self.pos = pos
  self.rootNode:setPosition(pos)
end

function newRichText:setAnchor(anchor)
  self.anchor = anchor
end

function newRichText:setAnchorPoint(anchor)
  self.rootNode:setAnchorPoint(anchor)
end

function newRichText:setMiddle(middle)
  self.middle = middle
end

function newRichText:getRootNode()
  return self.rootNode
end

function newRichText:getLink(index)
  index = index or 1
  return self.link[index]
end

function newRichText:getLinkAll()
  return self.link
end

function newRichText:getSize()
  return self.width, self.height
end

function newRichText:getContentSize()
  return CCSizeMake(self.width, self.height)
end

function newRichText:getPosition()
  return self.rootNode:getPosition()
end

function newRichText:setMaxWidth(maxWidth)
  self.maxWidth = maxWidth
end

function newRichText:checkIsAlphabet(c)
  if 65 <= c and c <= 90 or 97 <= c and c <= 122 then
    return true
  elseif 48 <= c and c <= 57 then
    return true
  elseif ed.isElementInTable(c, {
    39,
    46,
    41,
    37,
    34
  }) then
    return true
  end
  return false
end

function newRichText:checkEndCode(c)
  if ed.isElementInTable(c, {
    93,
    125,
    63,
    33,
    44
  }) then
    return true
  end
  return false
end

function ed.setRichTextExtraInfo(key, extraInfo)
  ed.linkExtraInfo = ed.linkExtraInfo or {}
  ed.linkExtraInfo[key] = extraInfo
end

function ed.getRichTextExtraInfo(key)
  return ed.linkExtraInfo[key]
end
