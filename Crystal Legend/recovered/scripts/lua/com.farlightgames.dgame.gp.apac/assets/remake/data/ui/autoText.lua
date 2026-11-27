local autoText = {}
autoText.__index = autoText
ed.ui.autoText = autoText
local calcuStrWidth = ed.ui.autoTextConfig.getStrWidth
local Color_Style = ed.ui.autoTextConfig.Color_Style
local fontSize_Style = ed.ui.autoTextConfig.fontSize_Style

function autoText.new()
  local self = {}
  setmetatable(self, autoText)
  self:init()
  return self
end

function autoText:init()
  self.node = CCSprite:create()
  self.node:setCascadeOpacityEnabled(true)
  self.node:setAnchorPoint(ccp(0, 0))
  self.defaultColor = ccc3(255, 255, 255)
  self.rowData = {}
  self.str = ""
  self.lineSpacing = 5
  self.fontSize = 18
  self.maxWidth = 400
  self.maxHeight = -1
  self.sizeScale = 1
  self.serchKey = "<sprite.->"
  self.align = "LEFT"
  self.spriteNode = {}
  self.spriteIDNode = {}
  self.labelNode = {}
  self.linkNodeTable = {}
  self.registerHandler = {}
end

function autoText:addRegisterHandler(keyName, handler)
  if not keyName or not handler then
    return
  end
  self.registerHandler[keyName] = handler
end

function autoText:FormatContent(content, newScale)
  local is_emoji = string.find(content, "<emoji|.+>")
  if is_emoji then
    local tb = richText:divisionTextToTable(content)
    local _, idx, scale = unpack(tb)
    if not idx then
      return content
    end
    idx = tonumber(idx)
    scale = tonumber(scale) or 1
    scale = math.min(scale, 1)
    scale = newScale or scale
    local row = ed.getDataTable("ChatEmoji")[idx]
    if not row then
      return content
    end
    local res = row["Emoji Cha"]
    content = T("<sprite src=%s name=\"emoji\" scale=%s >", res, scale or 1)
  end
  return content
end

function autoText:initParam(param)
  local content = param.context or ""
  content = self:FormatContent(content)
  self.param = param
  self.defaultColor = param.color or self.defaultColor
  self.str = content
  self.str = string.gsub(self.str, [=[
[
	]]=], "")
  self.lineSpacing = param.lineSpacing or 5
  self.maxWidth = param.maxWidth or 400
  self.maxHeight = param.maxHeight or -1
  self.sizeScale = param.sizeScale or 1
  self.fontSize = param.fontSize or 18
  self.align = param.align or "LEFT"
  self.callHandler = param.callHandler or nil
  if type(param.strokeColor) == "string" then
    param.strokeColor = Color_Style[param.strokeColor]
  end
  self.strokeColor = param.strokeColor or ccc3(255, 255, 255)
  self.strokeSize = param.strokeSize or 0
  self.shadowColor = param.shadowColor
  self.shadowOffset = param.shadowOffset
  self.isTripLastSpacing = param.isTripLastSpacing
  self.fontName = param.fontName
  self:drawTextNode()
  local isClickHandler = string.match(self.str, "clickhandler=(%w+)")
  if isClickHandler then
    if param.useSceneTouch then
      self:registerTouchInCurScene()
    elseif param.touchLayer then
      self.touchMonitor = param.touchLayer
      self:registerLinkBtnHandler()
    else
      self:registerTouchLayer(param.priority or -114)
      self:registerLinkBtnHandler()
    end
  end
end

local function NewTouchEventMonitor(touch_info, touch_layer)
  local touch_monitor = ed.ui.basetouchnode.btCreate()
  touch_layer:registerScriptTouchHandler(touch_monitor:btGetMainTouchHandler(), touch_info.is_multi, touch_info.priority, touch_info.swallow)
  touch_layer:setTouchEnabled(true)
  return touch_monitor
end

function autoText:registerTouchLayer(priority)
  self.touchLayer = CCLayer:create()
  self.node:addChild(self.touchLayer)
  local touchInfo = {
    is_multi = false,
    priority = priority,
    swallow = false
  }
  local touchMonitor = NewTouchEventMonitor(touchInfo, self.touchLayer)
  self.touchMonitor = touchMonitor
end

function autoText:registerTouchInCurScene()
  local curScene = ed.getCurrentScene()
  for i, info in ipairs(self.linkNodeTable) do
    local node = info.linkNode
    local clickhandlerKey = info.clickhandler
    local data = info.data
    curScene:btRegisterButtonClick({
      button = node,
      key = "linkBtnlick" .. i,
      clickHandler = function(event, x, y)
        local handler = self.registerHandler[clickhandlerKey]
        if handler then
          handler(data, x, y)
        end
      end,
      force = true,
      clickInterval = 0.5
    })
  end
end

function autoText:registerLinkBtnHandler()
  for i, info in ipairs(self.linkNodeTable) do
    local node = info.linkNode
    local clickhandlerKey = info.clickhandler
    local data = info.data
    self.touchMonitor:btRegisterButtonClick({
      button = node,
      key = "linkBtnlick" .. i,
      clickHandler = function(event, x, y)
        local handler = self.registerHandler[clickhandlerKey]
        if handler then
          handler(data, x, y)
        end
      end,
      force = true,
      clickInterval = 0.5
    })
  end
end

function autoText:setString(str, color)
  self.str = str
  self.defaultColor = color or self.defaultColor
end

function autoText:setSerchKey(serchKey)
  self.serchKey = serchKey or self.serchKey
end

function autoText:getLabelByName(name)
  return self.labelNode[name]
end

function autoText:drawTextNode()
  if self.node then
    self.node:removeAllChildrenWithCleanup(true)
    self.spriteNode = {}
    self.spriteIDNode = {}
    self.labelNode = {}
  end
  local textData = self:filter_spec_chars(self.str)
  local rowData = self:createRowData(textData)
  self:createNode(rowData)
  return self.node
end

function autoText:createNode(rowData)
  self.curHeight = 0
  self.curWidth = 0
  self.lineNum = 0
  self.ui = {}
  local firstLineHeight = 0
  local lastHeight = 0
  self.total_height = 0
  self.firstLineHeight = 0
  for i, row_data in ipairs(rowData) do
    local node = CCSprite:create()
    node:setCascadeOpacityEnabled(true)
    local cur_pos = 0
    local height = 0
    local curRowHeight = 0
    for i, data in ipairs(row_data) do
      local str = ""
      if data.type == "text" then
        local lable_node = ed.createNode({
          t = "Label",
          base = {
            text = data.context,
            size = self.fontSize
          },
          layout = {
            position = ccp(cur_pos, 0),
            anchor = ccp(0, 0.5)
          },
          config = {
            color = self.defaultColor
          }
        }, node)
        lable_node:setScale(self.sizeScale)
        if self.strokeColor then
          ed.setLabelStroke(lable_node, self.strokeColor, self.strokeSize)
        end
        if self.shadowColor then
          ed.setLabelShadow(lable_node, self.shadowColor, self.shadowOffset or ccp(1, 1))
        end
        if self.fontName then
          ed.setLabelFontName(lable_node, self.fontName)
        end
        local nWidth = lable_node:getContentSize().width * self.sizeScale
        local nHeight = lable_node:getContentSize().height * self.sizeScale
        cur_pos = cur_pos + nWidth
        height = math.max(height, nHeight * 0.5)
        curRowHeight = math.max(nHeight, curRowHeight)
      elseif data.type == "lable" then
        local param = data.param
        if param.startColor then
          local gradientLabel = ed.ui.gradientLabel.create({
            text = data.context,
            fontSize = param.fontSize,
            fontName = param.fontName,
            startColor = param.startColor,
            endColor = param.endColor,
            strokeSize = param.strokeSize,
            strokeColor = param.strokeColor
          })
          local lable_node = gradientLabel.node
          node:addChild(lable_node)
          lable_node:setScale(self.sizeScale)
          local nWidth = lable_node:getContentSize().width * self.sizeScale
          local nHeight = lable_node:getContentSize().height * self.sizeScale
          lable_node:setPosition(ccp(cur_pos + nWidth * 0.5, 0))
          local nodePosX = cur_pos
          cur_pos = cur_pos + nWidth
          height = math.max(height, nHeight * 0.5)
          curRowHeight = math.max(nHeight, curRowHeight)
          if data.clickhandler then
            self.linkNodeTable[#self.linkNodeTable + 1] = {
              linkNode = lable_node,
              clickhandler = data.clickhandler,
              data = data.data
            }
            local line = CCSprite:create("UI/alpha/1080P/common/link_line.png")
            line:setAnchorPoint(ccp(0, 0.5))
            line:setPosition(ccp(nodePosX, -0.5 * nHeight))
            line:setColor(param.color)
            line:setScaleX(nWidth / line:getContentSize().width)
            line:setScaleY(0.4)
            node:addChild(line, 20)
          end
          if param.labelName then
            self.labelNode[param.labelName] = gradientLabel
          end
        else
          local ui_info = {
            t = "Label",
            base = {
              text = data.context,
              size = param.fontSize
            },
            layout = {
              position = ccp(cur_pos, 0),
              anchor = ccp(0, 0.5)
            },
            config = {
              color = param.color
            }
          }
          if param.strokeColor then
            local stroke = {}
            stroke.color = param.strokeColor
            stroke.size = param.strokeSize
            ui_info.config.stroke = stroke
          end
          local lable_node = ed.createNode(ui_info, node)
          lable_node:setScale(self.sizeScale)
          if param.fontName then
            lable_node:setFontName(param.fontName)
          end
          if self.shadowColor then
            local shadowColor = self.shadowColor
            local shadowOffset = self.shadowOffset or ccp(1, 1)
            ed.setLabelShadow(lable_node, shadowColor, shadowOffset)
          end
          local nWidth = lable_node:getContentSize().width * self.sizeScale
          local nHeight = lable_node:getContentSize().height * self.sizeScale
          local nodePosX = cur_pos
          cur_pos = cur_pos + nWidth
          height = math.max(height, nHeight * 0.5)
          curRowHeight = math.max(nHeight, curRowHeight)
          if data.clickhandler then
            self.linkNodeTable[#self.linkNodeTable + 1] = {
              linkNode = lable_node,
              clickhandler = data.clickhandler,
              data = data.data
            }
            local line = CCSprite:create("UI/alpha/1080P/common/link_line.png")
            line:setAnchorPoint(ccp(0, 0.5))
            line:setPosition(ccp(nodePosX, -0.5 * lable_node:getContentSize().height))
            line:setColor(param.color)
            line:setScaleX(lable_node:getContentSize().width / line:getContentSize().width)
            line:setScaleY(0.4)
            node:addChild(line, 20)
          end
          if param.labelName then
            self.labelNode[param.labelName] = lable_node
          end
        end
      elseif data.type == "sprite" then
        local nWidth = data.size.width * self.sizeScale
        local nHeight = data.size.height * self.sizeScale
        local sp = data.node
        sp:setScale(sp:getScale() * self.sizeScale)
        sp:setPosition(ccp(cur_pos + nWidth * 0.5, 0))
        node:addChild(sp)
        cur_pos = cur_pos + nWidth
        height = math.max(height, nHeight * 0.5)
        curRowHeight = math.max(nHeight, curRowHeight)
        if data.clickhandler then
          self.linkNodeTable[#self.linkNodeTable + 1] = {
            linkNode = sp,
            clickhandler = data.clickhandler,
            data = data.data
          }
        end
      end
    end
    local posX, posY
    if i == 1 then
      posX = 0
      posY = 0
      lastHeight = height
      self.firstLineHeight = curRowHeight
    else
      lastHeight = lastHeight + height + self.lineSpacing * self.sizeScale
      posX = 0
      posY = -lastHeight
      lastHeight = lastHeight + height
    end
    if self.align == "LEFT" then
      posX = 0
    elseif self.align == "CENTER" then
      posX = (self.maxWidth - cur_pos) * 0.5
    elseif self.align == "RIGHT" then
      posX = self.maxWidth - cur_pos
    end
    node:setPosition(ccp(posX, posY))
    local param = {node = node, height = curRowHeight}
    self.ui[#self.ui + 1] = param
    self.curHeight = self.curHeight + curRowHeight + self.lineSpacing * self.sizeScale
    self.curWidth = math.max(self.curWidth, cur_pos)
    self.lineNum = self.lineNum + 1
    self.node:addChild(node)
    self.total_height = self.total_height + curRowHeight
  end
  if self.isTripLastSpacing then
    self.curHeight = self.curHeight - self.lineSpacing * self.sizeScale
  end
end

function autoText:setVerticalCenter()
  local offset_y = 0
  for k, param in ipairs(self.ui) do
    local anchor = param.node:getAnchorPoint()
    local size = param.node:getContentSize()
    if k == 1 then
      offset_y = self.total_height / 2 - param.height * (1 - anchor.y)
    end
    local x, y = param.node:getPosition()
    y = y + offset_y
    param.node:setPosition(ccp(x, y))
  end
end

function autoText:getContentSize()
  return self.maxWidth, self.curHeight
end

function autoText:getLineNum()
  return self.lineNum
end

function autoText:getFirstLineHeight()
  return self.firstLineHeight
end

function autoText:getCurContentSize()
  if self.align == "LEFT" then
    return self.curWidth, self.curHeight
  else
    return self.maxWidth, self.curHeight
  end
end

function autoText:createRowData(textData)
  local textData = textData
  local recordSpecialTab = {}
  local low, high
  repeat
    local curRow = 1
    local curRowElementNum = 0
    local curWidth = 0
    local curHeight = 0
    local textHeight = 0
    local rowData = {
      [1] = {}
    }
    for i, v in ipairs(textData) do
      local data
      if v.type == "text" then
        data = ed.copyTable(v)
      elseif v.type == "lable" then
        data = ed.copyTable(v)
      elseif v.type == "sprite" then
        if nil ~= recordSpecialTab[i] then
          data = recordSpecialTab[i]
        else
          data = self:createSpecialData(v)
          recordSpecialTab[i] = data
        end
      elseif v.type == "<br/>" then
        data = ed.copyTable(v)
      end
      if data ~= nil then
        local changeLine = false
        if data.type == "<br/>" or curWidth + data.size.width * self.sizeScale > self.maxWidth then
          curRow = curRow + 1
          curWidth = 0
          curRowElementNum = 0
          textHeight = textHeight + curHeight + self.lineSpacing * self.sizeScale
          curHeight = 0
          changeLine = true
        end
        rowData[curRow] = rowData[curRow] or {}
        if changeLine == false or data.context and data.context ~= " " then
          if curRowElementNum ~= 0 and rowData[curRow][curRowElementNum].type == "text" and data.type == "text" then
            rowData[curRow][curRowElementNum].context = string.format("%s%s", rowData[curRow][curRowElementNum].context, data.context)
          elseif curRowElementNum ~= 0 and rowData[curRow][curRowElementNum].type == "lable" and data.type == "lable" and rowData[curRow][curRowElementNum].param.lableType == data.param.lableType then
            rowData[curRow][curRowElementNum].context = string.format("%s%s", rowData[curRow][curRowElementNum].context, data.context)
          elseif data and data.type == "lable" or data.type == "sprite" or data.type == "text" then
            table.insert(rowData[curRow], data)
            curRowElementNum = curRowElementNum + 1
            curHeight = math.max(curHeight, data.size.height * self.sizeScale)
          end
          curWidth = curWidth + data.size.width * self.sizeScale
        end
      end
    end
    if 0 < curHeight then
      textHeight = textHeight + curHeight
    end
    if 0 >= self.maxHeight or nil == low and textHeight <= self.maxHeight then
      return rowData
    elseif low == nil then
      low = 0
      high = self.sizeScale
      self.sizeScale = math.sqrt(self.maxHeight / textHeight) * high
    else
      if textHeight > self.maxHeight then
        high = self.sizeScale
      else
        low = self.sizeScale
      end
      local threshold = 1.0E-4
      if high > low + threshold or high ~= low and self.sizeScale == high then
        self.sizeScale = low + (high - low) * 0.5
      elseif high ~= low and high < low + threshold then
        high = low
        self.sizeScale = high
      else
        return rowData
      end
    end
  until false
end

function autoText:createSpecialData(info)
  local icon
  local context = info.context
  local id = string.match(context, "id=(%w+)")
  local res = string.match(context, "src=([^%s>]+)")
  local folder = string.match(context, "folder=([^%s>]+)")
  local folderText = string.match(context, "folderText=([^%s>]+)")
  local scale = string.match(context, "scale=([%d.]+)") or 1
  local name = string.match(context, "name=(%w+)") or nil
  local isCall = string.match(context, "isCall=(%w+)")
  local param = string.match(context, "data=(%w+)")
  local clickhandler = string.match(context, "clickhandler=(%w+)")
  scale = tonumber(scale) or 1
  id = tonumber(id)
  local data = {}
  data.size = {}
  local icon1, key1
  if isCall and self.callHandler then
    icon, key1 = self.callHandler(param)
    name = key1 or name
  elseif id then
    icon = ed.readequip.createIcon(id)
  elseif res then
    icon = ed.createSprite(res)
  elseif folder and folderText then
    icon = ed.getNumberNode({text = folderText, folder = folder}).node
  end
  if icon then
    data.type = "sprite"
    data.node = icon
    icon:setScale(scale)
    local size = icon:getContentSize()
    icon:setAnchorPoint(ccp(0.5, 0.5))
    data.size.width = size.width * icon:getScale() + 5
    data.size.height = size.height * icon:getScale()
    data.clickhandler = clickhandler
    data.data = param
    if id then
      table.insert(self.spriteIDNode, {
        id = id,
        icon = icon,
        key = name
      })
    end
  else
    data.size.width = 0
    data.size.height = 0
    EDLog("Error:: autoText create icon  fail")
  end
  if name and icon then
    self.spriteNode[name] = icon
  elseif icon then
    table.insert(self.spriteNode, icon)
  end
  return data
end

function autoText:defaultResolve(s)
  local str = s
  local key = self.serchKey
  local keyData = {}
  if not key or key == "" then
    return keyData
  end
  local lastStrNum = 0
  while true do
    local s_index, e_index = string.find(str, key)
    if s_index and 0 <= s_index then
      local data = {}
      data.s = s_index + lastStrNum
      data.e = e_index + lastStrNum
      data.context = string.sub(str, s_index, e_index)
      table.insert(keyData, data)
      str = string.sub(str, e_index + 1, #str)
      lastStrNum = lastStrNum + e_index
    else
      break
    end
  end
  return keyData
end

function autoText:getTextStyleData(str)
  self.lableType = self.lableType or 0
  self.lableType = self.lableType + 1
  local fontSize = string.match(str, "fontSize=(%w+)")
  local strokeColor = string.match(str, "strokeColor=(%w+)")
  local strokeSize = string.match(str, "strokeSize=(%d+)")
  local clickhandler = string.match(str, "clickhandler=(%w+)")
  local fontName = string.match(str, "fontName=(%w+)")
  local data = string.match(str, "data=(%w+)")
  local labelName = string.match(str, "name=(%w+)")
  local wholeFlag = string.match(str, "whole=(%w+)")
  local startColor = string.match(str, "startColor=(%w+)")
  local endColor = string.match(str, "endColor=(%w+)")
  local s = string.match(str, "<lable.->(.-)</lable>")
  local param = {}
  if string.find(str, "color=ccc3") then
    local r, g, b = string.match(str, "color=ccc3%((%d+),(%d+),(%d+)%)")
    param.color = ccc3(r, g, b)
  else
    local colorstr = string.match(str, "color=(%w+)")
    param.color = Color_Style[colorstr]
  end
  if nil == param.color then
    param.color = self.defaultColor
  end
  if fontSize then
    param.fontSize = fontSize_Style[fontSize]
  end
  if nil == param.fontSize then
    param.fontSize = self.fontSize
  end
  if startColor and string.find(startColor, "0x") then
    param.startColor = ed.toccc3(tonumber(startColor, 16))
  end
  if endColor and string.find(endColor, "0x") then
    param.endColor = ed.toccc3(tonumber(endColor, 16))
  end
  param.lableType = self.lableType
  if strokeSize then
    param.strokeSize = strokeSize
    if string.find(strokeColor, "0x") then
      param.strokeColor = ed.toccc3(tonumber(strokeColor, 16))
    else
      param.strokeColor = Color_Style[strokeColor] or ccc3(0, 0, 0)
    end
  end
  if nil == param.strokeColor then
    param.strokeColor = self.strokeColor
  end
  if nil == param.strokeSize then
    param.strokeSize = self.strokeSize
  end
  if fontName then
    param.fontName = ed[fontName]
  end
  if nil == param.fontName then
    param.fontName = self.fontName
  end
  if labelName then
    param.labelName = labelName
  end
  local textData = {}
  if wholeFlag and wholeFlag == "true" then
    local totalWidth = 0
    local totalHeight = 0
    for k = 1, #s do
      local size = calcuStrWidth(s[k], param.fontSize, param.fontName)
      totalWidth = totalWidth + size.width
      totalHeight = math.max(totalHeight, size.height)
    end
    textData[1] = {
      context = s,
      type = "lable",
      size = {width = totalWidth, height = totalHeight},
      param = param,
      clickhandler = clickhandler,
      data = data
    }
  else
    local n = 1
    local index = 0
    local key_index = 1
    for k = 1, #s do
      index = index + 1
      if index > #s then
        break
      end
      local c = string.byte(s, index)
      if not c then
        break
      end
      if 0 <= c and c < 127 then
        local context = ""
        local width, height = 0, 0
        textData[n] = {}
        textData[n].type = "lable"
        textData[n].clickhandler = clickhandler
        textData[n].data = data
        textData[n].size = {}
        textData[n].param = param
        local j = index
        local checkWord = false
        while true do
          local checkChar = string.byte(s, j)
          if not checkChar then
            break
          end
          local str = string.char(checkChar)
          local strSize = calcuStrWidth(str, param.fontSize, param.fontName)
          if self:checkIsAlphabet(checkChar) then
            checkWord = true
            index = j
            context = context .. str
            width = width + strSize.width
            height = math.max(height, strSize.height)
            j = j + 1
          else
            if checkWord then
              if self:checkEndCode(checkChar) then
                index = j
                context = context .. str
                width = width + strSize.width
                height = math.max(height, strSize.height)
                j = j + 1
              end
              break
            end
            context = context .. str
            width = strSize.width
            height = math.max(height, strSize.height)
            break
          end
        end
        textData[n].context = context
        textData[n].size.width = width
        textData[n].size.height = height
        n = n + 1
      elseif 192 <= c and c <= 223 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1)
        local a = ""
        textData[n] = {}
        textData[n].context = string.char(c1, c2)
        textData[n].type = "lable"
        textData[n].size = {}
        textData[n].param = param
        local size = calcuStrWidth(textData[n].context, param.fontSize, param.fontName)
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        textData[n].clickhandler = clickhandler
        textData[n].data = data
        index = index + 1
        n = n + 1
      elseif 224 <= c and c <= 239 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1)
        local c3 = string.byte(s, index + 2)
        textData[n] = {}
        textData[n].context = string.char(c1, c2, c3)
        textData[n].type = "lable"
        textData[n].size = {}
        textData[n].param = param
        local size = calcuStrWidth(textData[n].context, param.fontSize, param.fontName)
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        textData[n].clickhandler = clickhandler
        textData[n].data = data
        index = index + 2
        n = n + 1
      elseif 240 <= c and c <= 247 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1) or 1
        local c3 = string.byte(s, index + 2) or 1
        local c4 = string.byte(s, index + 3) or 1
        textData[n] = {}
        textData[n].context = string.char(c1, c2, c3, c4)
        textData[n].type = "lable"
        textData[n].size = {}
        local size = calcuStrWidth(textData[n].context, param.fontSize, param.fontName)
        textData[n].param = param
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        textData[n].clickhandler = clickhandler
        textData[n].data = data
        index = index + 3
        n = n + 1
      elseif 248 <= c and c <= 251 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1)
        local c3 = string.byte(s, index + 2)
        local c4 = string.byte(s, index + 3)
        local c5 = string.byte(s, index + 4)
        textData[n] = {}
        textData[n].context = string.char(c1, c2, c3, c4, c5)
        textData[n].type = "lable"
        textData[n].size = {}
        local size = calcuStrWidth(textData[n].context, param.fontSize, param.fontName)
        textData[n].param = param
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        textData[n].clickhandler = clickhandler
        textData[n].data = data
        index = index + 4
        n = n + 1
      end
    end
  end
  return textData
end

function autoText:defaultLableStyle(s)
  local str = s
  local key = "<lable .->.-</lable>"
  local keyData = {}
  local lastStrNum = 0
  while true do
    local s_index, e_index = string.find(str, key)
    if s_index and 0 <= s_index then
      local data = {}
      data.s = s_index + lastStrNum
      data.e = e_index + lastStrNum
      data.datas = self:getTextStyleData(string.sub(str, s_index, e_index))
      table.insert(keyData, data)
      str = string.sub(str, e_index + 1, #str)
      lastStrNum = lastStrNum + e_index
    else
      break
    end
  end
  return keyData
end

function autoText:getSpecialTag(s)
  local str = s
  local key = "<br/>"
  local keyData = {}
  local lastStrNum = 0
  while true do
    local s_index, e_index = string.find(str, key)
    if s_index and 0 <= s_index then
      local data = {}
      data.s = s_index + lastStrNum
      data.e = e_index + lastStrNum
      data.type = "<br/>"
      table.insert(keyData, data)
      str = string.sub(str, e_index + 1, #str)
      lastStrNum = lastStrNum + e_index
    else
      break
    end
  end
  return keyData
end

function autoText:filter_spec_chars(s)
  local textData = {}
  local n = 1
  local index = 0
  local key_index = 1
  local lable_index = 1
  local specialTag_index = 1
  local keyDatas = self:defaultResolve(s)
  local lableDatas = self:defaultLableStyle(s)
  local specialTag = self:getSpecialTag(s)
  for k = 1, #s do
    index = index + 1
    if index > #s then
      break
    end
    local key_data = keyDatas[key_index]
    local isSpecial = false
    if key_data and key_data.s == index then
      isSpecial = true
      textData[n] = {}
      textData[n].context = key_data.context
      textData[n].type = "sprite"
      textData[n].size = {}
      n = n + 1
      key_index = key_index + 1
      index = key_data.e
    end
    local lable_data = lableDatas[lable_index]
    if lable_data and lable_data.s == index then
      isSpecial = true
      for i = 1, #lable_data.datas do
        table.insert(textData, lable_data.datas[i])
      end
      n = n + #lable_data.datas
      lable_index = lable_index + 1
      index = lable_data.e
    end
    local specialTag_data = specialTag[specialTag_index]
    if specialTag_data and specialTag_data.s == index then
      isSpecial = true
      textData[n] = {}
      textData[n].type = specialTag_data.type
      textData[n].size = {width = 0, height = 0}
      n = n + 1
      specialTag_index = specialTag_index + 1
      index = specialTag_data.e
    end
    if not isSpecial then
      local c = string.byte(s, index)
      if not c then
        break
      end
      if 0 <= c and c < 127 then
        local context = ""
        local width, height = 0, 0
        textData[n] = {}
        textData[n].type = "text"
        textData[n].size = {}
        local j = index
        local checkWord = false
        while true do
          local checkChar = string.byte(s, j)
          if not checkChar then
            break
          end
          local str = string.char(checkChar)
          local size = calcuStrWidth(str, self.fontSize, self.fontName)
          if self:checkIsAlphabet(checkChar) then
            checkWord = true
            index = j
            context = context .. str
            width = width + size.width
            height = math.max(height, size.height)
            j = j + 1
          else
            if checkWord then
              if self:checkEndCode(checkChar) then
                index = j
                context = context .. str
                width = width + size.width
                height = math.max(height, size.height)
                j = j + 1
              end
              break
            end
            context = context .. str
            width = size.width
            height = math.max(height, size.height)
            break
          end
        end
        textData[n].context = context
        textData[n].size.width = width
        textData[n].size.height = height
        n = n + 1
      elseif 192 <= c and c <= 223 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1)
        textData[n] = {}
        textData[n].context = string.char(c1, c2)
        textData[n].type = "text"
        textData[n].size = {}
        local size = calcuStrWidth(textData[n].context, self.fontSize, self.fontName)
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        index = index + 1
        n = n + 1
      elseif 224 <= c and c <= 239 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1)
        local c3 = string.byte(s, index + 2)
        textData[n] = {}
        textData[n].context = string.char(c1, c2, c3)
        textData[n].type = "text"
        textData[n].size = {}
        local size = calcuStrWidth(textData[n].context, self.fontSize, self.fontName)
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        index = index + 2
        n = n + 1
      elseif 240 <= c and c <= 247 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1)
        local c3 = string.byte(s, index + 2)
        local c4 = string.byte(s, index + 3)
        textData[n] = {}
        textData[n].context = string.char(c1, c2, c3, c4)
        textData[n].type = "text"
        textData[n].size = {}
        local size = calcuStrWidth(textData[n].context, self.fontSize, self.fontName)
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        index = index + 3
        n = n + 1
      elseif 248 <= c and c <= 251 then
        local c1 = string.byte(s, index)
        local c2 = string.byte(s, index + 1)
        local c3 = string.byte(s, index + 2)
        local c4 = string.byte(s, index + 3)
        local c5 = string.byte(s, index + 4)
        textData[n] = {}
        textData[n].context = string.char(c1, c2, c3, c4, c5)
        textData[n].type = "text"
        textData[n].size = {}
        local size = calcuStrWidth(textData[n].context, self.fontSize, self.fontName)
        textData[n].size.width = size.width
        textData[n].size.height = size.height
        index = index + 4
        n = n + 1
      end
    end
  end
  return textData
end

function autoText:checkIsAlphabet(c)
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

function autoText:checkEndCode(c)
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

function autoText:limitWidthByScale(width)
  if nil == width or type(width) ~= "number" or width <= 0 then
    return
  end
  if width < self.curWidth then
    self.node:setScale(width / self.curWidth)
  end
end
