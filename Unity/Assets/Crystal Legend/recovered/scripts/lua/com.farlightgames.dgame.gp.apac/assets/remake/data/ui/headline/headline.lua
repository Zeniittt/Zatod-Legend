local headline = {}
ed.ui.headline = headline
headline.__index = headline
local instance
local headLineScope = {}
local noShow_secen_identity = {
  "debuglogin",
  "serverlogin",
  "logo"
}

function headline.getInstance()
  if not instance then
    instance = {}
    setmetatable(instance, headline)
    instance:init()
  end
  return instance
end

function headline:init()
  self.hideDelay = nil
  self.isNoMsg = true
  local container, ui = ed.editorui(ed.uieditor.headline)
  self.mainLayer = container
  self.ui = ui
  self.headLayer = self.ui.headLayer
  self.bg = {}
  self.ui.bgServer:setScale(1.2)
  self.ui.bgGuild:setScale(1.2)
  self.bg[1] = self.ui.bgServer
  self.bg[2] = self.ui.bgGuild
  self.mainLayer:retain()
  self.mainLayer:setVisible(false)
  self.mainLayer:setPositionX(self.mainLayer:getPositionX() + ed.display.halfFixedWidth)
  self.animText = nil
  self.msgList = {}
  self.tbl = ed.getDataTable("Headlinelist")
  ListenEvent("lantern_event", function(data)
    if data then
      self.isHasNew = true
      self:addMsgToList(data)
    end
  end)
end

function headline:addToSecen(scene)
  self.scene = scene
  self.identity = self.scene.identity
  print("--------identity->>>", self.identity)
  self.scene.scene:addChild(self.mainLayer, 50000)
  self.isNoMsg = false
  self:removeExpiredItem()
  self.mainLayer:setVisible(false)
  self:playMsg()
end

function headline:removeFormSecen()
  CloseScope(headLineScope)
  if self.animText then
    self.animText:removeFromParentAndCleanup(true)
    self.animText = nil
  end
  self.mainLayer:setVisible(false)
  if self.mainLayer:getParent() then
    self.mainLayer:getParent():removeChild(self.mainLayer, true)
  end
  self.scene = nil
end

function headline:removeExpiredItem()
  local list = {}
  for i, v in ipairs(self.msgList) do
    local tbl_data = self.tbl[v.id]
    local life = tbl_data.LifeTime
    if life >= ed.getServerTime() - v.time and not v.isUse then
      table.insert(list, v)
    end
  end
  self.msgList = list
end

function headline:addMsgToList(data)
  local msg = data._msg
  for _, v in ipairs(msg) do
    local info = {}
    info.isUse = false
    info.id = v._msg_id
    info.time = v._time
    info.params = v._params
    info.user_a = {
      g_id = v._user_a._guild_id,
      g_name = v._user_a._guild_name,
      u_name = v._user_a._user_name,
      _medal = v._user_a._medal
    }
    self:checkIsAntiguilds(info.user_a)
    local tbl_data = self.tbl[info.id]
    if tbl_data then
      local display = tbl_data.Display
      info.display = display
      if v._user_a._user_id == ed.getUserid() then
        table.insert(self.msgList, 1, info)
      else
        table.insert(self.msgList, info)
      end
    end
  end
  if self.isNoMsg and self.scene then
    self:playMsg()
  end
end

function headline:checkIsAntiguilds(user)
  user.isAnti = false
  if not user.g_id or user.g_id <= 0 or not self.anti_guilds then
    return
  end
  for i, v in ipairs(self.anti_guilds) do
    if v == user.g_id then
      user.isAnti = true
      break
    end
  end
end

function headline:playMsg()
  local msg_data = self:getMsgFromList()
  if not msg_data then
    self.isNoMsg = true
    self.hideDelay = self.hideDelay or 2
    if self.mainLayer:isVisible() then
      self.mainLayer:setVisible(false)
    end
    return
  end
  if msg_data.display ~= "chat" then
    self.isNoMsg = false
    self.hideDelay = nil
    if self.animText then
      self.animText:removeFromParentAndCleanup(true)
      self.animText = nil
    end
    if not self.mainLayer:isVisible() then
      self.mainLayer:setVisible(true)
    end
    self.animText = self:creteAnimText(msg_data)
    if self.animText then
      self:startAmin()
    else
      print("self.animText----create error!!")
      EDDebug()
    end
  else
    self.isNoMsg = true
    self.hideDelay = self.hideDelay or 2
    if self.mainLayer:isVisible() then
      self.mainLayer:setVisible(false)
    end
  end
end

function headline:startAmin()
  if not self.animText then
    print("self.animText----create error!!")
    EDDebug()
  end
  local delayTime = ed.ui.headlineConfig.defaultDelayTime or 5
  local array = CCArray:create()
  local delay = CCDelayTime:create(delayTime)
  local remove = CCCallFunc:create(function()
    xpcall(function()
      self.animText:removeFromParentAndCleanup(true)
      self.animText = nil
      self:playMsg()
    end, EDDebug)
  end)
  array:addObject(delay)
  array:addObject(remove)
  local sequence = CCSequence:create(array)
  self.animText:runAction(sequence)
end

function headline:creteAnimText(data)
  local msg_id = data.id
  local msgInfo = ed.ui.headlineConfig.msglist[msg_id]
  local text, autoText, bgType
  if msgInfo then
    local context = msgInfo.context
    text, bgType = msgInfo.handler(data, context)
  else
    print("msgInfo====nil", msg_id)
    EDDebug()
  end
  if text then
    local containerSize = self.headLayer:getContentSize()
    autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = text,
      color = ccc3(255, 252, 231),
      maxWidth = containerSize.width,
      maxHeight = containerSize.height,
      fontSize = 18,
      strokeColor = ccc3(32, 17, 14),
      strokeSize = 1
    })
    local width, height = autoText:getCurContentSize()
    autoText.node:setPosition(ccp((780 - width) * 0.5, 15))
    self.headLayer:addChild(autoText.node, 30)
    ed.layout.centerYInParent(autoText.node)
  end
  bgType = bgType or 1
  self:setBG(bgType)
  return autoText.node
end

function headline:setBG(bgType)
  self.bg[1]:setVisible(bgType == 1)
  self.bg[2]:setVisible(bgType == 2)
end

function headline:getMsgFromList()
  local curTimes = ed.getServerTime()
  local info
  for i, v in ipairs(self.msgList) do
    if self:checkIsCanPlay(v) then
      info = v
      info.isUse = true
      break
    end
  end
  return info
end

function headline:checkIsCanPlay(info)
  local info = info
  if self.tbl then
    local tbl_data = self.tbl[info.id]
    local secenlist = tbl_data.Place
    local life = tbl_data.LifeTime
    for _, v in ipairs(secenlist) do
      if (v == "all" or v == self.identity) and self.identity ~= "battlePrepare" and life >= ed.getServerTime() - info.time and not info.isUse then
        return true
      end
    end
  end
  return false
end

function headline:tip(index)
  local params = {
    [1] = {
      "\229\147\136\229\147\136",
      "\230\173\166\232\128\133\228\185\139\231\165\158"
    },
    [2] = {"12"},
    [3] = {"12003"},
    [4] = {"12003"},
    [5] = {"12003"},
    [6] = {"12003"},
    [7] = {""},
    [8] = {"12"},
    [9] = {},
    [10] = {"3000", "100"},
    [11] = {"18"},
    [12] = {"10"},
    [13] = {"1"},
    [14] = {"3"},
    [15] = {"6"}
  }
  local info = {}
  info.isUse = false
  info.id = index
  info.time = ed.getServerTime()
  info.params = params[index]
  info.user_a = {
    g_id = 0,
    g_name = T("KK\229\133\172\228\188\154"),
    u_name = T("KK\231\168\141\231\173\137"),
    _medal = {
      _medal_id = 1,
      _get_time = ed.getServerTime()
    }
  }
  info.display = "headline"
  self:checkIsAntiguilds(info.user_a)
  table.insert(self.msgList, info)
  if self.isNoMsg then
    self:playMsg()
  end
end

function tip(index)
  print("tip***************>", index)
  ed.ui.headline:getInstance():tip(index)
end
