local chatUtil = {}
chatUtil.__index = chatUtil
ed.chatUtil = chatUtil

function chatUtil:formatContent(str)
  local data = str
  if string.find(data, "<link|wakuang|") then
    local str2 = string.match(data, "<link|wakuang|(%d+),>")
    str2 = ed.getDataTable("ExcavateTreasure")[tonumber(str2)]["Display Name"]
    return string.format("\233\130\128\232\175\183\233\152\178\229\174\136\239\188\154\227\128\144%s\227\128\145", str2)
  elseif string.find(data, "<link|ancients|") then
    local count = string.match(data, "<link|ancients|(%d+)>")
    return string.format("\233\130\128\232\175\183\230\142\162\231\180\162\239\188\154\227\128\144\231\165\158\231\167\152\233\129\151\232\191\185\227\128\145(\229\143\139\230\131\133\231\130\185\239\188\154%d)", count)
  elseif string.find(data, "<link|real_arena_challenge|") then
    local pvp_rule = string.match(data, "<link|real_arena_challenge|([^>]+)>")
    local text = string.match(data, "<text|dark_white|([^|]+)|400>") or ""
    return string.format("\233\130\128\232\175\183\229\136\135\231\163\139\239\188\154\227\128\144%s\230\168\161\229\188\143\227\128\145 %s", ed.realarena.pvp_rule_string[pvp_rule], text)
  elseif string.find(data, "<link|multiplayer|") then
    local str2 = string.match(data, "<link|multiplayer|([^>]+)>")
    local str1 = string.match(data, "<text|dark_white|([^>]+)>")
    return string.format("%s\227\128\144%s\227\128\145", str1, str2)
  elseif string.find(data, "<link|pvp|") then
    local str2 = string.match(data, "<link|pvp|([^>]+)>")
    return string.format("\227\128\144%s\227\128\145", str2)
  elseif string.find(data, "<link|real_arena") then
    local str2 = string.match(data, "<link|real_arena|([^>]+)>")
    return string.format("%s", str2)
  elseif string.find(data, "<link|herolink") then
    local str2 = string.match(data, "<link|herolink|([^>]+)|%d+>")
    str2 = ed.FormatHeroLinkName(str2)
    return string.format("%s", str2)
  end
  return str
end

function chatUtil:isHide(pnode)
  local node = pnode
  if not node then
    return false
  end
  if node:isVisible() == false then
    return true
  end
  while node:getParent() do
    if node:getParent():isVisible() == false then
      return true
    end
    node = node:getParent()
  end
  return false
end

function chatUtil:getUserKey(roleId)
  return roleId
end

function chatUtil:getRightBubble(res)
  local ui_info = {
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(80, 61)
      },
      t = "Scale9Sprite",
      base = {
        capInsets = CCRectMake(27.34, 14.84, 11.72, 9.38),
        res = res or "UI/alpha/HVGA/chat/Chat_SelfBubble.png",
        name = "ui_bubble",
        z = 0
      },
      layout = {
        anchor = ccp(1, 1),
        position = ccp(0, 0)
      }
    }
  }
  return ui_info
end

function chatUtil:getLeftBubble(res)
  local ui_info = {
    {
      config = {
        rotation = 0,
        flip = "",
        opacity = 255,
        visible = true,
        scaleSize = CCSizeMake(80, 61)
      },
      t = "Scale9Sprite",
      base = {
        capInsets = CCRectMake(27.34, 14.84, 8.59, 7.81),
        res = res or "UI/alpha/HVGA/chat/Chat_Bubble.png",
        name = "ui_bubble",
        z = 0
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(0, 0)
      }
    }
  }
  return ui_info
end

function chatUtil:setAllNodeStone(node)
  if not node or not node.getChildren then
    return
  end
  local array = node:getChildren()
  if array then
    for i = 0, array:count() - 1 do
      local c = array:objectAtIndex(i)
      if c.getTexture and c:getTexture() then
        ed.setSpriteStone(c)
      else
        self:setAllNodeStone(c)
      end
    end
  end
end

function chatUtil:resetAllNodeStone(node)
  if not node or not node.getChildren then
    return
  end
  local array = node:getChildren()
  if array then
    for i = 0, array:count() - 1 do
      local c = array:objectAtIndex(i)
      if c.getTexture and c:getTexture() then
        ed.resetSpriteShader(c)
      else
        self:resetAllNodeStone(c)
      end
    end
  end
end
