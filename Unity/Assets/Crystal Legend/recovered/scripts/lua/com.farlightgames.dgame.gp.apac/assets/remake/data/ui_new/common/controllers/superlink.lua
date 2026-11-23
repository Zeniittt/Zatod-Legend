local superLink = {}
superLink.__index = superLink
superLink.label = nil
superLink.content = ""
superLink.type = ""
superLink.extraData = ""
superLink.pressed = false
local ed = ed
ed.linkFlag = 0

function superLink:isContainPoint(x, y)
  if nil == self.label then
    return false
  end
  return ed.containsPoint(self.label, x, y)
end

function superLink:touch(event, x, y)
  if self.label == nil then
    return
  end
  if event == "began" then
    if ed.checkVisible(self.label) and ed.containsPoint(self.label, x, y) then
      self.pressed = true
      return true
    end
  elseif event == "ended" and self.pressed then
    if ed.containsPoint(self.label, x, y) and self.handler then
      xpcall(function()
        self:handler()
      end, EDDebug)
    end
    self.pressed = false
    return true
  end
  return false
end

function superLink:handler()
  if self.extraData == nil then
    return
  end
  if self.extraData.channel == nil or self.extraData.chatId == nil then
    return
  end
  ed.linkFlag = self.flag
  ed.superlink_current_type = self.type
  local msg = ed.upmsg.chat()
  msg._fetch = {}
  msg._fetch._channel = self.extraData.channel
  msg._fetch._chat_id = self.extraData.chatId
  ed.send(msg, "chat")
end

function superLink:setExtraData(extra)
  self.extraData = extra
end

function superLink:setType(type)
  self.type = type
end

function superLink:getLabel()
  return self.label
end

function superLink:getSize()
  if tolua.isnull(self.label) then
    return
  end
  if not self.label.getContentSize then
    return
  end
  return self.label:getContentSize()
end

function superLink:setFlag(flag)
  self.flag = flag
end

local pvpLink = {}
setmetatable(pvpLink, superLink)
pvpLink.__index = pvpLink

function pvpLink:paraseExtra(extraData)
end

function pvpLink:setString(content)
  self.content = content
  if self.label then
    ed.setString(self.label, self.content)
  else
    self.label = ed.createLabelWithFontInfo(self.content, "chat_pvp_link")
  end
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, 10, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end

function pvpLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local topPvpLink = {}
setmetatable(topPvpLink, superLink)
topPvpLink.__index = topPvpLink

function topPvpLink:paraseExtra(extraData)
end

function topPvpLink:setString(content)
  self.content = content
  if self.label then
    ed.setString(self.label, self.content)
  else
    self.label = ed.createLabelWithFontInfo(self.content, "chat_pvp_link")
  end
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, 10, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end

function topPvpLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local realArenaLink = {}
setmetatable(realArenaLink, superLink)
realArenaLink.__index = realArenaLink
realArenaLink.ui_config = {
  bo1 = {
    bgPath = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_invite_bg_1.png",
    title = T("\232\175\184\231\142\139\228\186\137\233\156\184-\228\184\128\229\177\128\232\131\156\232\180\159"),
    titleStroke = ed.toccc3(1781585),
    descColor = ed.toccc3(11325438),
    descStroke = ed.toccc3(1781585)
  },
  bo3 = {
    bgPath = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_invite_bg_2.png",
    title = T("\232\175\184\231\142\139\228\186\137\233\156\184-\228\184\137\229\177\128\228\184\164\232\131\156"),
    titleStroke = ed.toccc3(8264455),
    descColor = ed.toccc3(16695211),
    descStroke = ed.toccc3(8264455)
  }
}

function realArenaLink:paraseExtra(extraData)
end

function realArenaLink:setString(content)
  self.label = CCNode:create()
  local container, ui = ed.editorui(ed.uieditor.kingsChatInvite)
  self.label:addChild(container)
  ed.setLabelFontName(ui.label_title, ed.fontBold)
  local size = ui.image_bg:getContentSize()
  size = CCSizeMake(size.width - 20, size.height - 32)
  container:setContentSize(CCSizeMake(size.width, size.height))
  self.label:setContentSize(CCSizeMake(size.width, size.height))
  self.label:setMessageRect(CCRectMake(0, 0, size.width, size.height))
  ed.layout.centerInParent(container)
  container:setPositionX(size.width / 2)
  container:setPositionY(size.height / 2 + 3)
  local config = realArenaLink.ui_config[self.rule_type]
  if config then
    ed.setTexture(ui.image_bg, config.bgPath)
    ed.setLabelString(ui.label_title, config.title)
    ed.setLabelStroke(ui.label_title, config.titleStroke, 1)
    ed.setLabelColor(ui.label_desc, config.descColor)
    ed.setLabelStroke(ui.label_desc, config.descStroke, 1)
  end
end

function realArenaLink:handler()
  if self.extraData and self.extraData.roleId == ed.getRoleId() then
    ed.showToast(T("\228\184\141\232\131\189\229\138\160\229\133\165\232\135\170\229\183\177\231\154\132\230\136\191\233\151\180"))
    return
  end
  local roomId = tonumber(self.roomId)
  if not roomId then
    ed.showToast(T("\230\136\191\233\151\180\229\143\183\228\184\141\229\173\152\229\156\168"))
    return
  end
  ed.showConfirmDialog({
    text = string.format(T("\230\152\175\229\144\166\229\138\160\229\133\165\232\175\184\231\142\139\228\186\137\233\156\184\239\188\140\230\136\191\233\151\180\229\143\183\239\188\154%s"), self.roomId),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      local currentScene = ed.getCurrentScene()
      if currentScene and currentScene.identity ~= "KingsPvpMainScene" then
        ed.UITool.openView("KingsPvpMainScene")
      end
      local createRoomWindow = ed.getPopWindow("KingsPvpCreateRoomWindow")
      if createRoomWindow then
        createRoomWindow:destroy()
      end
      ed.realarena.network_mgr:RequestEnterHouse(roomId)
    end
  })
end

function realArenaLink:new(rule_type, roomId)
  local object = {}
  setmetatable(object, self)
  object.rule_type = rule_type or ed.KingsPvpDefine.MODE_BO1
  object.roomId = roomId
  return object
end

local realArenaChallengeLink = {}
setmetatable(realArenaChallengeLink, superLink)
realArenaChallengeLink.__index = realArenaChallengeLink

function realArenaChallengeLink:paraseExtra(extraData)
end

function realArenaChallengeLink:setString(content)
  self.content = content
  if not tolua.isnull(self.label) then
    self.label:removeFromParentAndCleanup(true)
  end
  self.label = ed.getRealArenaChallengeNameTag(content)
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, 10, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end

function realArenaChallengeLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local excavateLink = {}
setmetatable(excavateLink, superLink)
excavateLink.__index = excavateLink

function excavateLink:paraseExtra(extraData)
end

function excavateLink:setString(content)
  self.content = content
  if not tolua.isnull(self.label) then
    self.label:removeFromParentAndCleanup(true)
  end
  self.label = ed.getExcavateNameTag(content)
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, size.height, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end

function excavateLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local ancientsLink = {}
setmetatable(ancientsLink, superLink)
ancientsLink.__index = ancientsLink

function ancientsLink:paraseExtra(extraData)
end

function ancientsLink:setString(content)
  content = tonumber(content)
  self.content = content
  if not tolua.isnull(self.label) then
    self.label:removeFromParentAndCleanup(true)
  end
  self.label = ed.getAncientsNameTag(content)
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, size.height, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end

function ancientsLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local redbagLink = {}
setmetatable(redbagLink, superLink)
redbagLink.__index = redbagLink

function redbagLink:paraseExtra(extraData)
end

function redbagLink:setString(content)
  self.content = content
  if self.label then
    ed.setString(self.label, self.content)
  else
    self.label = ed.createRedBagLinkText(content)
  end
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, 10, size.width, size.height * 2)
  self.label:setMessageRect(rect)
end

function redbagLink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local ladderfightlink = {}
setmetatable(ladderfightlink, superLink)
ladderfightlink.__index = ladderfightlink

function ladderfightlink:paraseExtra(extraData)
end

function ladderfightlink:handler()
end

function ladderfightlink:getSize()
  return self.size
end

function ladderfightlink:setString(content)
  self.content = content
  self.label = CCNode:create()
  if not tolua.isnull(self.label) then
    self.label:removeFromParentAndCleanup(true)
  end
  local autoText = ed.ui.autoText.new()
  local param = {
    context = T("<lable color=ccc3(251,224,71) fontSize=f15>[</lable><sprite src=UI/alpha/1080P/sharefight/pvp.png scale=0.7><lable color=ccc3(251,224,71) fontSize=f15>\231\171\158\230\138\128\229\156\186]</lable>"),
    strokeColor = ed.toccc3(5586983),
    strokeSize = 1,
    fontSize = 15
  }
  autoText:initParam(param)
  self.label:addChild(autoText.node)
  local width, height = autoText:getCurContentSize()
  local rect = CCRectMake(0, height, width, height * 2)
  self.size = CCSizeMake(width, height)
  self.label:setMessageRect(rect)
end

function ladderfightlink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local enemyteamlink = {}
setmetatable(enemyteamlink, superLink)
enemyteamlink.__index = enemyteamlink

function enemyteamlink:getSize()
  return self.size
end

function enemyteamlink:paraseExtra(extraData)
end

function enemyteamlink:setString(content)
  self.content = content
  if not tolua.isnull(self.label) then
    self.label:removeFromParentAndCleanup(true)
  end
  self.label, self.size = ed.getEnemyTeamTag(content)
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, 0, size.width, size.height)
  self.label:setMessageRect(rect)
end

function enemyteamlink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local multiplayerlink = {}
setmetatable(multiplayerlink, superLink)
multiplayerlink.__index = multiplayerlink

function multiplayerlink:paraseExtra(extraData)
end

function multiplayerlink:setString(content)
  self.content = content
  if not tolua.isnull(self.label) then
    self.label:removeFromParentAndCleanup(true)
  end
  self.label = ed.getMultiplayerTag(content)
  local size = self.label:getContentSize()
  local rect = CCRectMake(0, 0, size.width, size.height)
  self.label:setMessageRect(rect)
end

function multiplayerlink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local herolink = {}
setmetatable(herolink, superLink)
herolink.__index = herolink

function herolink:paraseExtra(extraData)
end

function herolink:handler()
  print("herolink send msg !!!")
  if self.extraData == nil then
    return
  end
  local extr_data = self.extraData
  if extr_data.channel == nil or extr_data.chatId == nil then
    return
  end
  local idx = self.ct_idx
  ed.linkFlag = self.flag
  ed.superlink_current_type = self.type
  local data = extr_data.acc
  local link = data._chat_hero_link
  local msg = ed.upmsg.chat()
  msg._chat_query_hero = {
    _role_id = link._role_id,
    _hero_id = link._heroids[tonumber(idx)]
  }
  ed.send(msg, "chat")
end

function herolink:getSize()
  return self.size
end

function herolink:setString(content)
  content = ed.FormatHeroLinkName(content)
  self.content = content
  self.label = CCNode:create()
  local ui = {}
  ui[1] = ed.createLabelWithFontInfo("\227\128\144", "chat_pvp_link")
  ui[2] = ed.createSprite("UI/alpha/1080P/chat/chat_emoji_hero.png")
  ui[2]:setScale(0.8)
  ui[3] = ed.createLabelWithFontInfo(self.content, "chat_pvp_link")
  ui[4] = ed.createLabelWithFontInfo("\227\128\145", "chat_pvp_link")
  local size = CCSizeMake(0, 0)
  for k, v in ipairs(ui) do
    self.label:addChild(v)
    local sz = v:getContentSize()
    size.width = size.width + sz.width
    size.height = math.max(sz.height, size.height)
    if 1 < k then
      ed.right2(v, ui[k - 1], 2)
    end
  end
  local rect = CCRectMake(0, 10, size.width, size.height * 2)
  self.size = size
  self.label:setMessageRect(rect)
end

function herolink:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local playerlink = {}
setmetatable(playerlink, superLink)
playerlink.__index = playerlink

function playerlink:paraseExtra(extraData)
  self.extraData = extraData
end

function playerlink:handler()
  print("playerlink send msg !!!", self.ct_idx)
  local roleId = self.ct_idx
  ed.UITool.openView("playerInfoPanel", roleId)
end

function playerlink:getSize()
  return self.size
end

function playerlink:setString(content)
  self.content = content
  local medalId = ed.ui.headlineConfig.headlineRoleMedalId(self.extraData or 0)
  if medalId and 0 < medalId then
    self.label = ed.getMedalPlayerTag(content, medalId)
    local size = self.label:getContentSize()
    local rect = CCRectMake(0, 10, size.width, size.height * 2)
    self.label:setMessageRect(rect)
    self.size = size
  else
    self.label = CCNode:create()
    local contentLabel = EDCurLanguage == "en" and self.content or "\227\128\144" .. self.content .. "\227\128\145"
    local nameLabel = ed.createLabelWithFontInfo(contentLabel, "chat_pvp_link")
    local size = nameLabel:getContentSize()
    self.label:addChild(nameLabel)
    nameLabel:setPositionX(nameLabel:getContentSize().width / 2)
    local rect = CCRectMake(0, 10, size.width, size.height * 2)
    self.size = size
    self.label:setMessageRect(rect)
  end
end

function playerlink:new(extraData)
  local object = {extraData = extraData}
  setmetatable(object, self)
  return object
end

local herolink2 = {}
setmetatable(herolink2, superLink)
herolink2.__index = herolink2

function herolink2:paraseExtra(extraData)
end

function herolink2:handler()
  print("herolink2 send msg !!!")
  if self.extraData == nil then
    return
  end
  local extr_data = self.extraData
  if extr_data.channel == nil or extr_data.chatId == nil then
    return
  end
  local heroId
  if extr_data.acc and extr_data.acc._lantern_msg then
    local leanternMsg = extr_data.acc._lantern_msg
    heroId = leanternMsg._params[1]
  end
  if not heroId then
    return
  end
  local roleId = extr_data.roleId
  local msg = ed.upmsg.chat()
  msg._chat_query_hero = {
    _role_id = roleId,
    _hero_id = tonumber(heroId)
  }
  ed.send(msg, "chat")
end

function herolink2:getSize()
  return self.size
end

function herolink2:setString(content)
  content = ed.FormatHeroLinkName(content)
  self.content = content
  self.label = CCNode:create()
  local ui = {}
  ui[1] = ed.createLabelWithFontInfo("\227\128\144", "chat_pvp_link")
  ui[2] = ed.createSprite("UI/alpha/1080P/chat/chat_emoji_hero.png")
  ui[2]:setScale(0.8)
  ui[3] = ed.createLabelWithFontInfo(self.content, "chat_pvp_link")
  ui[4] = ed.createLabelWithFontInfo("\227\128\145", "chat_pvp_link")
  local size = CCSizeMake(0, 0)
  for k, v in ipairs(ui) do
    self.label:addChild(v)
    local sz = v:getContentSize()
    size.width = size.width + sz.width
    size.height = math.max(sz.height, size.height)
    if 1 < k then
      ed.right2(v, ui[k - 1], 2)
    end
  end
  local rect = CCRectMake(0, 10, size.width, size.height * 2)
  self.size = size
  self.label:setMessageRect(rect)
end

function herolink2:new()
  local object = {}
  setmetatable(object, self)
  return object
end

local function createSuperLink(ttype, content, extraData)
  local link
  if ttype == "pvp" then
    link = pvpLink:new()
  elseif ttype == "top_pvp" then
    link = topPvpLink:new()
  elseif ttype == "real_arena" then
    link = realArenaLink:new(content, extraData)
  elseif ttype == "real_arena_challenge" then
    link = realArenaChallengeLink:new()
  elseif ttype == "wakuang" then
    link = excavateLink:new()
  elseif ttype == "ancients" then
    link = ancientsLink:new()
  elseif ttype == "redBag" then
    link = redbagLink:new()
  elseif ttype == "ladder_fight" then
    link = ladderfightlink:new()
  elseif ttype == "enemy_team" then
    link = enemyteamlink:new()
  elseif ttype == "multiplayer" then
    link = multiplayerlink:new()
  elseif ttype == "herolink" then
    link = herolink:new()
  elseif ttype == "herolink2" then
    link = herolink2:new()
  elseif ttype == "playerlink" then
    link = playerlink:new(extraData)
  end
  if link then
    link:setType(ttype)
    link:setString(content)
    link:setExtraData(extraData)
  end
  return link
end

ed.createSuperLink = createSuperLink
