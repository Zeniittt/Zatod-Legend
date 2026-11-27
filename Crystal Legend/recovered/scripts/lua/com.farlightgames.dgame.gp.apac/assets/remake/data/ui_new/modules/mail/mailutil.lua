local class = newclass({__index = _G})
ed.mailutil = class
setfenv(1, class)
local widgets = {
  "v_number",
  "v_string",
  "v_icon",
  "v_self_hero_avatar",
  "v_button_excavate_history",
  "v_time"
}
local keyString = {"br"}
local labelTypeConfig = {
  hl = {
    color = "hightlight",
    size = "f18",
    endstr = "/hl"
  },
  title = {
    color = "mailTitle",
    size = "f16",
    endstr = "/title"
  },
  link = {
    color = "mailLinkColor",
    size = "f18",
    endstr = "/link"
  }
}

local function checkIsAlphabet(c)
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

local function checkEndCode(c)
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

local function wrapWord(str, j)
  local checkWord = false
  local uchar = ""
  repeat
    local checkChar = string.byte(str, j)
    if not checkChar then
      break
    end
    if checkIsAlphabet(checkChar) then
      checkWord = checkWord or true
      uchar = uchar .. string.char(checkChar)
      j = j + 1
    else
      if checkWord then
        if checkEndCode(checkChar) then
          uchar = uchar .. string.char(checkChar)
          break
        end
        j = j - 1
        break
      end
      uchar = string.char(checkChar)
      break
    end
  until false
  return uchar, j
end

local function getStrWidth(str, fontSize, fontName)
  if nil == fontSize then
    fontSize = 18
  end
  if nil == fontName then
    fontName = ed.font
  end
  local totWid = 0
  for i, c, b in utf8.chars(str) do
    totWid = totWid + ed.ui.autoTextConfig.getStrWidth(c, fontSize, fontName).width
  end
  return totWid
end

local function preProcessText(content, maxWidth, params)
  maxWidth = maxWidth * 18
  
  local function getParamValue(index)
    for i, v in ipairs(params or {}) do
      if v._idx == index then
        return v._value
      end
    end
    return ""
  end
  
  local tmpStr = content .. "#br#"
  local resultStr = ""
  local list = {}
  while string.find(tmpStr, "#br#") do
    local i = string.find(tmpStr, "#br#")
    local str1 = string.sub(tmpStr, 1, i - 1)
    tmpStr = string.sub(tmpStr, i + 4)
    table.insert(list, str1)
  end
  for k, str in ipairs(list) do
    local width = 0
    while string.find(str, "[%z\001-\127\194-\244][\128-\191]*") do
      local i, j = string.find(str, "[%z\001-\127\194-\244][\128-\191]*")
      local uchar = string.sub(str, i, j)
      if string.sub(uchar, 1, 1) == "#" then
        local pos1, pos2 = string.find(str, "#%d+#[%l_]+#")
        if pos1 == i then
          local tmpStr = string.sub(str, pos1, pos2)
          local index = tonumber(string.match(tmpStr, "%d+"))
          local paramType = string.match(tmpStr, "[%l_]+")
          local w = 1
          if paramType == "v_number" or paramType == "v_string" then
            w = getStrWidth(getParamValue(index))
          elseif paramType == "v_icon" then
            w = 5
          elseif paramType == "v_time" then
            local timeStr = ed.getYMDHMSTime(getParamValue(index), "mail")
            w = getStrWidth(timeStr)
          elseif paramType == "v_button_excavate_history" then
            w = 10
          elseif paramType == "v_self_hero_avatar" then
            w = 6
          end
          if maxWidth < width + w then
            resultStr = resultStr .. "#br#"
            width = 0
          end
          width = width + w
          resultStr = resultStr .. string.sub(str, pos1, pos2)
          str = string.sub(str, pos2 + 1)
        else
          if 1 == #uchar then
            uchar, j = wrapWord(str, j)
          end
          local w = getStrWidth(uchar)
          if maxWidth <= width + w and uchar == " " then
            str = string.sub(str, j + 1)
          else
            if maxWidth <= width + w then
              width = 0
              resultStr = resultStr .. "#br#"
            end
            width = width + w
            resultStr = resultStr .. uchar
            str = string.sub(str, j + 1)
          end
        end
      else
        if 1 == #uchar then
          uchar, j = wrapWord(str, j)
        end
        local w = getStrWidth(uchar)
        if maxWidth <= width + w and uchar == " " then
          str = string.sub(str, j + 1)
        else
          if maxWidth <= width + w then
            width = 0
            resultStr = resultStr .. "#br#"
          end
          width = width + w
          resultStr = resultStr .. uchar
          str = string.sub(str, j + 1)
        end
      end
    end
    resultStr = resultStr .. "#br#"
  end
  return resultStr
end

function initNumber(param)
  if not param then
    return
  end
  local v = param._value or ""
  local node = ed.createttf(v, 16)
  ed.setLabelColor(node, ccc3(146, 91, 51))
  return node
end

function initString(param)
  if not param then
    return
  end
  local t = param._type
  local v = param._value or ""
  if t == "hero_name" then
    v = tonumber(v)
    v = ed.getDataTable("Unit")[v]["Display Name"]
  elseif t == "mine_id" then
    v = tonumber(v)
    v = (ed.getDataTable("ExcavateTreasure")[v] or {})["Display Name"] or ""
  elseif t == "todo_task" then
    v = tonumber(v)
    v = (ed.getDataTable("Todolist")[v] or {})["Task Name"] or ""
  elseif t == "guild_avatar" then
    v = tonumber(v)
    v = (ed.getDataTable("GuildAvatarFrame")[v] or {}).Name or ""
  elseif t == "scientific_counting" then
    local length = string.len(v)
    if 9 <= length then
      v = string.sub(v, 1, -9) .. T("\228\186\191") .. string.sub(v, -8, -5) .. T("\228\184\135")
    end
  end
  v = T(v)
  local node = ed.createttf(v, 16)
  ed.setLabelColor(node, ccc3(146, 91, 51))
  local width = math.min(250, node:getContentSize().width)
  node:setDimensions(CCSizeMake(width, 0))
  node:setHorizontalAlignment(kCCTextAlignmentLeft)
  node:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
  return node
end

function initTime(param)
  if not param then
    return
  end
  local v = param._value and ed.getYMDHMSTime(param._value, "mail") or ""
  local node = ed.createttf(v, 16)
  ed.setLabelColor(node, ccc3(146, 91, 51))
  return node
end

function initIcon(param)
  if not param then
    return
  end
  local v = param._value or ""
  local t = param._type
  if t == "money" then
    local res = {
      gold = "UI/alpha/1080P/common/goldicon_small.png",
      diamond = "UI/alpha/1080P/common/shop_token_icon.png",
      arenapoint = "UI/alpha/HVGA/money_dragonscale_big.png",
      crusadepoint = "UI/alpha/HVGA/money_arenatoken_big.png",
      guildpoint = "UI/alpha/HVGA/money_guildtoken_big.png",
      honourpoint = "UI/alpha/HVGA/money_top_pvp_big.png",
      gvgpoint = "UI/alpha/HVGA/money_gvg_big.png",
      dreampoint = "UI/alpha/HVGA/money_dreampoint_big.png",
      gcwpoint = "UI/alpha/HVGA/money_gcw_big.png"
    }
    local icon = ed.createSprite(res[v])
    icon:setScale(30 / icon:getContentSize().width)
    return icon
  elseif t == "item" then
    local id = tonumber(v)
    local icon = ed.readequip.createIcon(id)
    icon:setScale(30 / icon:getContentSize().width)
    return icon
  elseif t == "mine" then
    local id = tonumber(v)
    local et = ed.getDataTable("ExcavateTreasure")[id]["Produce Type"]
    local res = {
      Gold = "UI/alpha/HVGA/chat/chat_icon_treasure_gold.png",
      Diamond = "UI/alpha/HVGA/chat/chat_icon_treasure_diamond.png",
      Item = "UI/alpha/HVGA/chat/chat_icon_treasure_exp.png"
    }
    local icon = ed.creayeSprite(res[et])
    icon:setScale(30 / icon:getContentSize().width)
    return icon
  elseif t == "self_hero" then
    local id = tonumber(v)
    local icon = ed.readhero.createIconByID(id, {state = "idle"}).icon
    icon:setScale(50 / icon:getContentSize().width)
    return icon
  end
end

function initAvatar(param)
  if not param then
    return
  end
  local id = param._value or 1
  local icon = ed.getHeroIconByID({
    id = tonumber(id),
    vip = ed.player:getvip() > 0
  })
  return icon
end

function initExcavHistoryButton(param)
  if not param then
    return
  end
  local id = param._value
  local ui = {}
  local readnode = ed.readnode.create(nil, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "button",
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = ed.DGRectMake(20, 20, 24, 24),
        feral = true,
        feralArray = ui
      },
      layout = {},
      config = {
        scaleSize = ed.DGSizeMake(150, 68)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "press",
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = ed.DGRectMake(20, 20, 24, 24),
        parent = "button"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = ed.DGSizeMake(150, 68),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "label",
        text = T("\230\159\165\231\156\139\232\175\166\230\131\133"),
        size = 20,
        parent = "button"
      },
      layout = {
        position = ed.DGccp(75, 34)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    }
  }
  readnode:addNode(ui_info)
  local isPress, px, py
  
  local function callback(event, x, y)
    if event == "began" then
      px, py = x, y
      if ed.containsPoint(ui.button, x, y) then
        ui.press:setVisible(true)
        isPress = true
      end
    elseif event == "moved" then
      if not px or not py then
        return
      end
      local dx = px - x
      local dy = py - y
      if 25 < dx * dx + dy * dy then
        isPress = nil
        ui.press:setVisible(false)
      end
    elseif event == "ended" then
      if isPress then
        ui.press:setVisible(false)
        if ed.containsPoint(ui.button, x, y) then
          ed.ui.excavatehistory.pop({priority = -200})
        end
      end
      isPress = nil
    end
  end
  
  return ui.button, callback
end

initHandler = {
  v_number = initNumber,
  v_string = initString,
  v_time = initTime,
  v_icon = initIcon,
  v_self_hero_avatar = initAvatar,
  v_button_excavate_history = initExcavHistoryButton
}

function getWidget(config, params)
  local function getParam(index)
    for i, v in ipairs(params) do
      if v._idx == index then
        return v
      end
    end
  end
  
  local t = config.key
  local index = tonumber(config.index)
  local param = getParam(index)
  return initHandler[t](param)
end

function getBody(text, params, maxWid)
  local touchHandlers = {}
  text = preProcessText(text, maxWid or 30, params)
  local itemList = split(text)
  local vui = {}
  for i, v in ipairs(itemList) do
    local hui = {}
    for li, lv in ipairs(v) do
      if lv.t == "Label" then
        table.insert(hui, {
          t = "Label",
          base = {
            text = lv.text,
            size = 18
          },
          layout = {},
          config = {
            color = ccc3(ed.colorToStr("#fffce7"))
          }
        })
      elseif lv.t == "widget" then
        local button, callback = getWidget(lv, params)
        if not tolua.isnull(button) then
          if ed.isElementInTable(lv.key, {
            "v_button_excavate_history"
          }) and callback then
            table.insert(touchHandlers, callback)
          end
          table.insert(hui, {
            t = "CCNode",
            base = {node = button},
            layout = {}
          })
        end
      end
    end
    if resource_config.format_mail_set_dimensions then
      table.insert(vui, hui)
    else
      local conf = {
        t = "HorizontalNode",
        base = {name = "line"},
        layout = {},
        ui = hui
      }
      table.insert(vui, conf)
    end
  end
  local conf
  if resource_config.format_mail_set_dimensions then
    conf = {
      t = "ChaosNode",
      base = {
        name = "body",
        offset = 5,
        width = 260
      },
      layout = {},
      ui = vui
    }
  else
    conf = {
      t = "VerticalNode",
      base = {name = "body", offset = 5},
      layout = {},
      ui = vui
    }
  end
  local body = ed.readnode.getFeralNode(conf)
  return body, touchHandlers
end

function split(text)
  local list = {}
  for s in string.gmatch(text, "[^#]*") do
    if s ~= "" then
      table.insert(list, s)
    end
  end
  local itemList = {}
  local index = 1
  for i, v in ipairs(list) do
    if v == "br" and itemList[1] then
      index = index + 1
    end
    itemList[index] = itemList[index] or {}
    if ed.isElementInTable(v, widgets) then
      table.insert(itemList[index], {
        t = "widget",
        index = list[i - 1],
        key = v
      })
    elseif not ed.isElementInTable(list[i + 1] or "", widgets) and not ed.isElementInTable(v, keyString) then
      table.insert(itemList[index], {t = "Label", text = v})
    end
  end
  return itemList
end

function create(mid, params, maxWid)
  local row = ed.getDataTable("Maillist")[mid]
  local body, touchHandlers = getBody(row.Content, params, maxWid)
  return body, touchHandlers
end

function splitLabel(text)
  local list = {}
  text = string.gsub(text, "\n", "<br/>")
  for str in string.gmatch(text, "[^<>]*") do
    if str ~= "" then
      table.insert(list, str)
    end
  end
  local labels = {}
  local index = 1
  local urlIndex = 1
  while true do
    local str = list[index]
    if not str then
      break
    end
    local labelConfig = {}
    if labelTypeConfig[str] then
      local config = labelTypeConfig[str]
      local endstr = config.endstr
      if endstr ~= list[index + 2] then
        EDDebug("email label type" .. str .. "can,t success match endstr" .. endstr)
      end
      if str == "link" then
        local str = list[index + 1]
        local content, url = string.match(str, "([^|]+)|([^|]+)")
        labelConfig = {
          type = "Link",
          text = content,
          url = url,
          urlInd = urlIndex,
          color = config.color,
          size = config.size,
          strokeSize = 1.5
        }
        urlIndex = urlIndex + 1
      else
        labelConfig = {
          type = "Label",
          text = list[index + 1],
          color = config.color,
          size = config.size
        }
      end
      index = index + 3
    elseif str == "br/" then
      labelConfig = {type = "br"}
      index = index + 1
    else
      labelConfig = {
        type = "Label",
        text = str,
        color = "mailContent",
        size = "f18"
      }
      index = index + 1
    end
    table.insert(labels, labelConfig)
  end
  return labels
end

function getMailText(mid, params)
  local row = ed.getDataTable("Maillist")[mid]
  if not row then
    print("mid is nil === ", mid)
    return
  end
  local from = row.Sender
  local name = row.Title
  return name, from
end
