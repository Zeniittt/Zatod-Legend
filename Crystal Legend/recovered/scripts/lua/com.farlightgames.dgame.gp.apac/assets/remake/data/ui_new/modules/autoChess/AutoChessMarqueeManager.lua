local marqueeScope = {}
local class = {}
class.__index = class

function class.getInstance()
  return class
end

function class:setUIContainer(container)
  self.container = container
end

function class:getUIContainer()
  if self.container then
    return self.container
  else
    self.container = CCLayer:create()
    return self.container
  end
end

function class:initData()
  self.running = false
  self.mainTimerInterval = 0.1
  self.mainTimerName = "MarqueeTimer"
  self.defaultBulletSpeed = -100
  self.defaultBulletSpacing = 150
  local winWidth = ed.winSize[1]
  self.channelsConfig = {
    {
      y = 442,
      lx = 0,
      rx = winWidth
    },
    {
      y = 464,
      lx = 0,
      rx = winWidth
    }
  }
  self.channels = {}
  self.curChannelIndex = 0
end

function class:initComponents()
  for id, config in pairs(self.channelsConfig) do
    local channel = ed.AutoChessMarqueeChannel.create(self:getUIContainer(), config.y, config.lx, config.rx)
    table.insert(self.channels, channel)
  end
end

function class:getDefaultBulletSpeed()
  return self.defaultBulletSpeed
end

function class:getDefaultBulletSpacing()
  return self.defaultBulletSpacing
end

function class:getMainTimerInterval()
  return self.mainTimerInterval
end

function class:setMainTimerInterval(interval)
  self.mainTimerInterval = interval
end

function class:handleNewBulletMessage(data)
  if not self.running then
    return
  end
  local cnt = #self.channels
  if cnt == 0 then
    return
  end
  self.curChannelIndex = self.curChannelIndex % cnt + 1
  local nextChannel = self.channels[self.curChannelIndex]
  nextChannel:pushBullet(ed.AutoChessMarqueeBullet.create(data))
end

function class:registerEvents()
  local function getPlayerNameByKey(playerKey)
    local player = ed.AutoChessModel:getChessPlayerByKey(playerKey)
    
    local userSummary = player:getUserSummary()
    return userSummary._name
  end
  
  ListenEvent("EventChessSelectPowerNotify", function(data)
    local playerKey = data._user_key
    if not data._hero_power then
      return
    end
    local powerId = data._hero_power._id
    local power_name = ed.getDataTable("ChessHeroPower")[powerId]["HeroPower Name"]
    self:handleNewBulletMessage({
      id = 7,
      power_name = power_name,
      player_name = getPlayerNameByKey(playerKey)
    })
  end, marqueeScope)
  ListenEvent("EventChessComposeNotify", function(data)
    local playerKey = data._user_key
    local heroId = data._hid
    local heroData = ed.getDataTable("ChessUnit")[heroId]
    local stars = heroData["Chess Stars"]
    local id
    if stars == 2 then
      id = 1
    elseif stars == 3 then
      id = 2
    end
    self:handleNewBulletMessage({
      id = id,
      player_name = getPlayerNameByKey(playerKey),
      hero_name = heroData["Display Name"]
    })
  end, marqueeScope)
  ListenEvent("ChessEventBattleComboVictory", function(playerKey, combo)
    self:handleNewBulletMessage({
      id = 3,
      player_name = getPlayerNameByKey(playerKey),
      combo = combo
    })
  end, marqueeScope)
  ListenEvent("ChessEventBattleBlockVictory", function(playerKey, oppoPlayerKey, combo)
    self:handleNewBulletMessage({
      id = 4,
      lose_player_name = getPlayerNameByKey(playerKey),
      win_player_name = getPlayerNameByKey(oppoPlayerKey),
      combo = combo
    })
  end, marqueeScope)
  ListenEvent("ChessEventBattleOverForMarquee", function(playerKey, oppoPlayerType, oppoPlayerKey, battleResult)
    local playerName = getPlayerNameByKey(playerKey)
    local oppoPlayerName
    if oppoPlayerType == "monster" then
      oppoPlayerName = T("\230\128\170\231\137\169")
    elseif oppoPlayerType == "player" then
      oppoPlayerName = getPlayerNameByKey(oppoPlayerKey)
    end
    if battleResult == "victory" then
      self:handleNewBulletMessage({
        id = 5,
        lose_player_name = oppoPlayerName,
        win_player_name = playerName
      })
    elseif battleResult == "defeat" then
      self:handleNewBulletMessage({
        id = 6,
        lose_player_name = playerName,
        win_player_name = oppoPlayerName
      })
    end
  end, marqueeScope)
end

function class:start()
  CloseTimer(self.mainTimerName)
  ListenTimer(Timer:Always(self.mainTimerInterval, self.mainTimerName), function()
    for id, channel in pairs(self.channels) do
      channel:letBulletsFly(self.mainTimerInterval)
    end
  end, marqueeScope)
  self:registerEvents()
  self.running = true
end

function class:clearComponents()
  for id, channel in pairs(self.channels) do
    channel:destory()
  end
  self.channels = {}
end

function class:stopAndClear()
  self:stop()
  self:clearComponents()
end

function class:stop()
  CloseScope(marqueeScope)
  self.running = false
end

function class:init(param)
  if param.container then
    self:setUIContainer(param.container)
  end
  self:initData()
  self:initComponents()
end

ed.AutoChessMarqueeManager = class.getInstance()
local Queue = {}
Queue.__index = Queue
ed.AutoChessMarqueeQueue = Queue

function Queue:create()
  local object = {}
  setmetatable(object, Queue)
  object:initData()
  return object
end

function Queue:initData()
  self.q = {}
  self.cnt = 0
end

function Queue:empty()
  return self.cnt == 0
end

function Queue:count()
  return self.cnt
end

function Queue:push(item)
  table.insert(self.q, item)
  self.cnt = self.cnt + 1
end

function Queue:pop()
  if self:empty() then
    return
  end
  local item = table.remove(self.q, 1)
  self.cnt = self.cnt - 1
  return item
end

function Queue:front()
  if self:empty() then
    return
  end
  local item = self.q[1]
  return item
end

function Queue:tail()
  if self:empty() then
    return
  end
  local item = self.q[#self.q]
  return item
end

function Queue:getRawTable()
  return self.q
end

function Queue:removeAt(index)
  self.cnt = self.cnt - 1
  return table.remove(self.q, index)
end

function Queue:clear()
  self.q = {}
  self.cnt = 0
end

local defaultFontSize = 18
local normalColor = "ccc3(255,252,231)"
local strokeColor = "ccc3(20,18,18)"
local strokeSize = 1
local configPattern = "%[(.-)=(.-)%]"
local StyleConfig = {
  starSpriteRes = "<sprite src=UI/alpha/1080P/skilltower/detail_star.png scale=1>",
  playerNameColorRes = "<lable color=ccc3(254,211,109) strokeColor=ccc3(20,18,18) strokeSize=1>%s</lable>",
  normalNameColorRes = "<lable color=ccc3(255,252,231) strokeColor=ccc3(20,18,18) strokeSize=1>%s</lable>",
  numberNameColorRes = "<lable color=ccc3(255,252,231) strokeColor=ccc3(20,18,18) strokeSize=1>%s</lable>",
  equipNameColorRes = "<lable color=ccc3(255,252,231) strokeColor=ccc3(20,18,18) strokeSize=1>%s</lable>"
}

local function GetAutoTextStyleString(configs)
  local list = {}
  
  local function replaceFunction(key, value)
    return string.format(StyleConfig[key], value)
  end
  
  for id, config in pairs(configs) do
    local item = string.gsub(config, configPattern, replaceFunction)
    if item then
      table.insert(list, item)
    end
  end
  local s = table.concat(list, "")
  return s
end

local bulletTextConfig = {
  [1] = {
    config = {
      T("[playerNameColorRes=%s][normalNameColorRes=\229\144\136\230\136\144\228\186\134][starSpriteRes=][starSpriteRes=][equipNameColorRes=%s][normalNameColorRes=!]")
    },
    render = function(content, data)
      local playerName = data.player_name
      local heroName = data.hero_name
      local text = string.format(content, playerName, heroName)
      return text
    end
  },
  [2] = {
    config = {
      T("[playerNameColorRes=%s][normalNameColorRes=\229\144\136\230\136\144\228\186\134][starSpriteRes=][starSpriteRes=][starSpriteRes=][equipNameColorRes=%s][normalNameColorRes=!]")
    },
    render = function(content, data)
      local playerName = data.player_name
      local heroName = data.hero_name
      local text = string.format(content, playerName, heroName)
      return text
    end
  },
  [3] = {
    config = {
      T("[playerNameColorRes=%s][normalNameColorRes=\229\183\178\231\187\143\232\190\190\229\136\176][numberNameColorRes=%s][normalNameColorRes=\232\191\158\232\131\156\239\188\129]")
    },
    render = function(content, data)
      local playerName = data.player_name
      local combo = data.combo
      local text = string.format(content, playerName, combo)
      return text
    end
  },
  [4] = {
    config = {
      T("[playerNameColorRes=%s][normalNameColorRes=\231\187\136\231\187\147\228\186\134][playerNameColorRes=%s][normalNameColorRes=\231\154\132][numberNameColorRes=%s][normalNameColorRes=\232\191\158\232\131\156\239\188\129]")
    },
    render = function(content, data)
      local winPlayerName = data.win_player_name
      local losePlayerName = data.lose_player_name
      local combo = data.combo
      local text = string.format(content, winPlayerName, losePlayerName, combo)
      return text
    end
  },
  [5] = {
    config = {
      T("[playerNameColorRes=%s][normalNameColorRes=\233\152\178\229\174\136\228\189\143\228\186\134][playerNameColorRes=%s]")
    },
    render = function(content, data)
      local winPlayerName = data.win_player_name
      local losePlayerName = data.lose_player_name
      local text = string.format(content, winPlayerName, losePlayerName)
      return text
    end
  },
  [6] = {
    config = {
      T("[playerNameColorRes=%s][normalNameColorRes=\232\162\171][playerNameColorRes=%s][normalNameColorRes=\229\135\187\232\180\165\228\186\134]")
    },
    render = function(content, data)
      local winPlayerName = data.win_player_name
      local losePlayerName = data.lose_player_name
      local text = string.format(content, losePlayerName, winPlayerName)
      return text
    end
  },
  [7] = {
    config = {
      T("[playerNameColorRes=%s][normalNameColorRes=\233\128\137\230\139\169\228\186\134][playerNameColorRes=%s][normalNameColorRes= ]")
    },
    render = function(content, data)
      local playerName = data.player_name
      local powerName = data.power_name
      local text = string.format(content, playerName, powerName)
      return text
    end
  }
}
local BulletNodeManager = {}
BulletNodeManager.__index = BulletNodeManager
ed.AutoChessBulletNodeManager = BulletNodeManager

function BulletNodeManager:getNode(text)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = text,
    color = ccc3(255, 252, 231),
    strokeColor = ccc3(20, 18, 18),
    strokeSize = strokeSize,
    fontSize = defaultFontSize,
    maxWidth = 600
  })
  local w, h = autoText:getCurContentSize()
  return autoText.node, w
end

local Bullet = {}
Bullet.__index = Bullet
ed.AutoChessMarqueeBullet = Bullet

function Bullet.create(data)
  local object = {}
  setmetatable(object, Bullet)
  object:initData(data)
  return object
end

function Bullet:initData(data)
  self.active = false
  self.speed = ed.AutoChessMarqueeManager:getDefaultBulletSpeed()
  local textId = data.id
  local textConfig = bulletTextConfig[textId]
  local content = textConfig.content
  if not content then
    content = GetAutoTextStyleString(textConfig.config)
    textConfig.content = content
  end
  local render = textConfig.render
  local text = render(content, data)
  self.text = text
end

function Bullet:initComponents()
  self.active = true
  self.node, self.rawWidth = BulletNodeManager:getNode(self.text)
end

function Bullet:isActive()
  return self.active and not tolua.isnull(self:getUINode())
end

function Bullet:getUINode()
  return self.node
end

function Bullet:getText()
  return self.text
end

function Bullet:getLX()
  return self:getUINode():getPositionX()
end

function Bullet:getRX()
  return self:getLX() + self:getWidth()
end

function Bullet:getWidth()
  return self.rawWidth
end

function Bullet:getSpeed()
  return self.speed
end

function Bullet:setLX(x)
  self:getUINode():setPositionX(x)
end

function Bullet:setBY(y)
  self:getUINode():setPositionY(y)
end

function Bullet:setSpeed(speed)
  self.speed = speed
end

function Bullet:setVisible(visible)
  self:getUINode():setVisible(visible)
end

function Bullet:move(dx)
  self:setLX(self:getLX() + dx)
end

function Bullet:moveByDuration(dx, duration)
  local moveAction = CCMoveBy:create(duration, ccp(dx, 0))
  self:getUINode():runAction(moveAction)
end

function Bullet:destory()
  if self:isActive() then
    self:getUINode():removeFromParentAndCleanup(true)
  end
  self.active = false
end

local Channel = {}
Channel.__index = Channel
ed.AutoChessMarqueeChannel = Channel

function Channel.create(container, y, lx, rx)
  local object = {}
  setmetatable(object, Channel)
  object:initData(container, y, lx, rx)
  return object
end

function Channel:initData(container, y, lx, rx)
  self.container = container
  self.y = y
  self.lx = lx
  self.rx = rx
  self.activeQueue = Queue.create()
  self.pendingQueue = Queue.create()
  self.moveManually = false
end

function Channel:getActiveCount()
  return self.activeQueue:count()
end

function Channel:getPendingCount()
  return self.pendingQueue:count()
end

function Channel:pushBullet(bullet)
  self.pendingQueue:push(bullet)
end

function Channel:updateBullet(bullet, index)
  if bullet:getRX() < self.lx then
    bullet:destory()
    self.activeQueue:removeAt(index)
  end
end

function Channel:canActiveNext()
  local lastActiveBullet = self.activeQueue:tail()
  if not lastActiveBullet then
    return true
  end
  if not lastActiveBullet:isActive() then
    return false
  end
  local spacingWidth = lastActiveBullet:getRX() - self.rx
  local threshold = -ed.AutoChessMarqueeManager:getDefaultBulletSpacing()
  return spacingWidth < threshold
end

function Channel:activeNext()
  local bullet = self.pendingQueue:pop()
  if bullet then
    bullet:initComponents()
    local randomOffset = math.random(0, 50)
    bullet:setLX(self.rx + randomOffset)
    bullet:setBY(self.y)
    self.activeQueue:push(bullet)
    self.container:addChild(bullet:getUINode())
    if not self.moveManually then
      local dx = self.lx - self.rx - bullet:getWidth() - randomOffset - 100
      local delay = dx / bullet:getSpeed()
      bullet:moveByDuration(dx, delay)
    end
  end
end

function Channel:letBulletsFly(duration)
  local bullets = self.activeQueue:getRawTable()
  for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    if bullet:isActive() then
      if self.moveManually then
        local delay = ed.AutoChessMarqueeManager:getMainTimerInterval()
        local dx = bullet:getSpeed() * delay
        bullet:moveByDuration(dx, delay)
      end
      self:updateBullet(bullet, i)
    end
  end
  if self:canActiveNext() then
    self:activeNext()
  end
end

function Channel:destory()
  local bullets = self.activeQueue:getRawTable()
  for id, bullet in pairs(bullets) do
    bullet:destory()
  end
  self.activeQueue:clear()
  self.pendingQueue:clear()
end
