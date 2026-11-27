local base = ed.ui.commonscene
local MapMainScene = newclass(base.mt)
ed.ui.MapMainScene = MapMainScene

function MapMainScene.create()
  local self = base.create("MapMainScene", {noBottomButton = true})
  setmetatable(self, MapMainScene.mt)
  self:initUI()
  return self
end

local search = {}
local cost = {}
local startPos = {x = 1, y = 1}
local endPos
local hadSearch = {}
local pathSave = {}
local maxRaw = 10000

function MapMainScene:getHeuristic(posA, posB)
  local dx = math.abs(posA.x - posB.x)
  local dy = math.abs(posA.y - posB.y)
  return math.max(dx, dy)
end

local function getShortestPos()
  local shortest = search[1]
  local removeIndex = 1
  for k, v in ipairs(search) do
    if v[2] < shortest[2] then
      shortest = v
      removeIndex = k
    end
  end
  table.remove(search, removeIndex)
  return shortest[1]
end

function MapMainScene:getNeighbors(pos)
  local neighbors = {}
  local neighborOffset = {
    {
      {0, 1},
      {0, -1},
      {1, 0},
      {-1, 0},
      {-1, 1},
      {-1, -1}
    },
    {
      {0, 1},
      {0, -1},
      {1, 0},
      {-1, 0},
      {1, 1},
      {1, -1}
    }
  }
  local arr = neighborOffset[pos.y % 2 + 1]
  for k, v in ipairs(arr) do
    local r = pos.x + v[1]
    local c = pos.y + v[2]
    if self.map[r] and self.map[r][c] and (self.collider[r] == nil or self.collider[r][c] == nil) then
      table.insert(neighbors, {x = r, y = c})
    end
  end
  return neighbors
end

local function two2One(v)
  return v.x * maxRaw + v.y
end

local function one2Two(x)
  local r = math.floor(x / 10000)
  local c = x % 10000
  if x % 10000 > 5000 then
    r = r + 1
    c = c - 10000
  end
  return r, c
end

function MapMainScene:setTask(task)
  self.roadIndex = 1
  self.task = task
  self.actor:setAction("Move")
end

function MapMainScene:showPath()
  local current = two2One(endPos)
  local results = {
    {
      endPos.x,
      endPos.y
    }
  }
  while current ~= two2One(startPos) do
    local next = pathSave[current]
    local r, c = one2Two(next)
    table.insert(results, 1, {r, c})
    current = next
  end
  self:setTask(results)
end

function MapMainScene:findPath()
  search = {}
  cost = {}
  hadSearch = {}
  pathSave = {}
  table.insert(search, {
    startPos,
    self:getHeuristic(startPos, endPos)
  })
  cost[two2One(startPos)] = 0
  if not hadSearch[startPos.x] then
    hadSearch[startPos.x] = {}
  end
  hadSearch[startPos.x][startPos.y] = true
  pathSave[two2One(startPos)] = two2One(startPos)
  while 0 < #search do
    local current = getShortestPos()
    if current.x == endPos.x and current.y == endPos.y then
      break
    end
    local neighbors = self:getNeighbors(current)
    for k, v in ipairs(neighbors) do
      if not hadSearch[v.x] then
        hadSearch[v.x] = {}
      end
      if not hadSearch[v.x][v.y] then
        cost[two2One(v)] = cost[two2One(current)] + 1
        table.insert(search, {
          v,
          cost[two2One(v)] + self:getHeuristic(v, endPos)
        })
        pathSave[two2One(v)] = two2One(current)
        hadSearch[v.x][v.y] = true
      end
    end
  end
  if pathSave[two2One(endPos)] then
    self:showPath()
  else
    ed.showToast(T("\228\184\141\232\131\189\229\136\176\232\190\190"))
  end
  startPos = nil
  endPos = nil
end

local startPosX, startPosY = 0, 0
local layerPosX, layerPosY = 0, 0
local isDrag = false

function MapMainScene:dobuildLayerTouch()
  local function handler(event, x, y)
    if event == "began" then
      isDrag = false
      
      startPosX = x
      startPosY = y
      layerPosX = self.buildLayer:getPositionX()
      layerPosY = self.buildLayer:getPositionY()
    elseif event == "moved" then
      local ax = x - startPosX
      local ay = y - startPosY
      if math.abs(ax) > 15 or math.abs(ay) > 15 then
        self.buildLayer:setPosition(ccp(layerPosX + ax, layerPosY + ay))
        isDrag = true
      end
    elseif event == "ended" then
      if ed.containsPoint(self.spriteSub, x, y) then
        local scale = self.buildLayer:getScale()
        self.buildLayer:setScale(scale - 0.03)
      end
      if ed.containsPoint(self.spriteAdd, x, y) then
        local scale = self.buildLayer:getScale()
        self.buildLayer:setScale(scale + 0.03)
        return true
      end
      startPosX = 0
      startPosY = 0
      if not isDrag then
        local mx = (x - self.buildLayer:getPositionX() - 80) / self.buildLayer:getScale()
        local my = (y - self.buildLayer:getPositionY()) / self.buildLayer:getScale()
        local row, col = self:worldToCellIndex(mx, my)
        if self.task then
          return
        end
        if self.buildings[row] and self.buildings[row][col] then
          ed.showToast(string.format("type:monster  monsterLevel:%d", self.buildings[row][col].monsterLevel))
          return true
        end
        ed.showToast(string.format("\231\130\185\229\135\187cell %d,%d", row, col))
        print(x, y, mx, my, row, col)
        if not startPos then
          self.actor:setPosition(ccp(self:indexToWorldPos(row, col)))
          startPos = {x = row, y = col}
          if self.reseltLayer then
            self.reseltLayer:removeAllChildrenWithCleanup(true)
          end
          return true
        end
        if not endPos then
          endPos = {x = row, y = col}
          xpcall(function()
            self:findPath()
          end, EDDebug)
          return true
        end
      end
    end
    return true
  end
  
  return handler
end

function MapMainScene:worldToCellPos(x, y)
  local row, col = self:worldToCellIndex(x, y)
  local x = (row - 0.5) * self.mapGridSize
  local y = (col - 0.5) * self.mapGridSize
  return x, y
end

local function twoPointDistanceSQ(p0x, p0y, p1x, p1y)
  local x = p0x - p1x
  local y = p0y - p1y
  local distanceSQ = x * x + y * y
  return distanceSQ
end

local function edpNormalize(a)
  if a[1] == 0 and a[2] == 0 then
    return {1, 0}
  end
  local x = a[1]
  local y = a[2]
  local u = 1 / (x * x + y * y) ^ 0.5
  return {
    x * u,
    y * u
  }
end

local velocity = 100

function MapMainScene:update(dt)
  base.update(self, dt)
  if self.task then
    if self.roadIndex > #self.task then
      startPos = {
        x = self.task[#self.task][1],
        y = self.task[#self.task][2]
      }
      self.actor:setAction("Idle")
      self.task = nil
    else
      local nextPoint = self.task[self.roadIndex]
      local ax, ay = self:indexToWorldPos(nextPoint[1], nextPoint[2])
      local bx, by = self.actor:getPosition()
      local dir = edpNormalize({
        ax - bx,
        ay - by
      })
      self.velocity = {
        dir[1] * velocity,
        dir[2] * velocity
      }
      if self.velocity[1] < 0 then
        self.actor:setScaleX(-1)
      else
        self.actor:setScaleX(1)
      end
      if twoPointDistanceSQ(ax, ay, bx, by) < 36 then
        self.actor:setPosition(ccp(ax, ay))
        self.roadIndex = self.roadIndex + 1
      else
        self.actor:setPosition(ccp(bx + self.velocity[1] * dt, by + self.velocity[2] * dt))
      end
    end
  end
end

function MapMainScene:worldToCellIndex(x, y)
  local col = math.ceil(y / self.mapGridSizeY - 0.5)
  local row
  if col % 2 == 0 then
    row = math.ceil(x / self.mapGridSizeX)
  else
    row = math.ceil(x / self.mapGridSizeX - 0.5)
  end
  local distance = math.huge
  local resultX, resultY = row, col
  for i = -1, 1 do
    for j = -1, 1 do
      local posX, posY = self:indexToWorldPos(row + i, col + j)
      local distanceSq = (posX - x) * (posX - x) + (posY - y) * (posY - y)
      if distance > distanceSq then
        distance = distanceSq
        resultX = row + i
        resultY = col + j
      end
    end
  end
  return resultX, resultY
end

function MapMainScene:indexToWorldPos(x, y)
  local offsetX = 0
  if y % 2 == 0 then
    offsetX = self.mapGridSizeX / 2
  end
  local posX = x * self.mapGridSizeX - offsetX
  local posY = y * self.mapGridSizeY
  return posX, posY
end

local tile_style_Texture_Path = "UI/tilemap/tile.png"
local tile_style_Plist_Path = "UI/tilemap/tile.plist"

local function loadTileTexture()
  local texture = CCTextureCache:sharedTextureCache():textureForKey(tile_style_Texture_Path)
  if not texture then
    texture = CCTextureCache:sharedTextureCache():addImage(tile_style_Texture_Path)
    texture:retain()
  end
  return texture
end

ed.loadTileTexture = loadTileTexture

local function creatTileSprite(frameName, node)
  local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
  if not frame then
    local texture = ed.loadTileTexture()
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(tile_style_Plist_Path, texture)
    frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
  end
  if frame then
    if nil == node then
      node = CCSprite:createWithSpriteFrame(frame)
    else
      node:setDisplayFrame(frame)
    end
  end
  return node
end

ed.creatTileSprite = creatTileSprite

function MapMainScene:initUI()
  local container, ui = ed.editorui({})
  self.mainLayer:addChild(container)
  self.ui = ui
  local mapRow, mapCol = 9, 40
  self.mapGridSizeX = 102
  self.mapGridSizeY = 68
  self.buildLayer = CCLayer:create()
  self.mapPos = {
    ed.display.winSize.width / 2,
    ed.display.winSize.height / 2
  }
  self.buildLayer:setPosition(ccp(self.mapPos[1], self.mapPos[2]))
  self.mainLayer:addChild(self.buildLayer)
  self.buildLayer:setTouchEnabled(true)
  self.buildLayer:registerScriptTouchHandler(self:dobuildLayerTouch(), false, -299, true)
  self.buildLayer:setAnchorPoint(ccp(0, 0))
  self.map = {}
  self.collider = {}
  self.reseltLayer = CCLayer:create()
  self.buildLayer:addChild(self.reseltLayer, 3)
  local spriteAdd = ed.createSprite("UI/alpha/1080P/common/arrow/pageup_arrow.png")
  self.spriteAdd = spriteAdd
  self.mainLayer:addChild(spriteAdd, 1)
  ed.layout.layoutWithMagin(spriteAdd, {right = 50, top = 50})
  local spriteSub = ed.createSprite("UI/alpha/1080P/common/arrow/pageup_arrow.png")
  spriteSub:setScaleX(-1)
  self.spriteSub = spriteSub
  self.mainLayer:addChild(spriteSub, 1)
  ed.layout.layoutWithMagin(spriteSub, {right = 100, top = 50})
  local config = require("ui_new.map.GroundData")
  self.tile = config.tiles or {}
  local buildConfig = require("ui_new.map.BuildData")
  self.buildTiles = buildConfig.tiles or {}
  self.buildings = {}
  local colliderConfig = require("ui_new.map.ColliderData")
  for k, v in ipairs(colliderConfig.tiles or {}) do
    self.collider[v.x] = self.collider[v.x] or {}
    self.collider[v.x][v.y] = true
  end
  table.sort(self.tile, function(a, b)
    if a.y == b.y then
      return a.x > b.x
    else
      return a.y > b.y
    end
  end)
  local bathnode = CCSpriteBatchNode:createWithTexture(ed.loadTileTexture())
  for k, v in ipairs(self.tile) do
    if not self.map[v.x] then
      self.map[v.x] = {}
    end
    local sprite = ed.creatTileSprite(string.format("%s.png", v.tileName))
    sprite:setAnchorPoint(ccp(0.5, 0.635))
    self.map[v.x][v.y] = {data = v, ui = sprite}
    local x, y = self:indexToWorldPos(v.x, v.y)
    sprite:setPosition(ccp(x, y))
    bathnode:addChild(sprite)
    local indexLabel = ed.createttf(string.format("(%d,%d)", v.x, v.y), 16)
    indexLabel:setPosition(ccp(x, y))
    self.buildLayer:addChild(indexLabel, 2)
  end
  for k, v in ipairs(self.buildTiles) do
    self.buildings[v.x] = self.buildings[v.x] or {}
    local sprite = ed.creatTileSprite(string.format("%s.png", v.tileName))
    sprite:setScale(2)
    local x, y = self:indexToWorldPos(v.x, v.y)
    self.buildings[v.x][v.y] = v
    sprite:setPosition(ccp(x, y + self.mapGridSizeY / 4))
    bathnode:addChild(sprite)
  end
  for k, v in ipairs(colliderConfig.tiles or {}) do
    local sprite = ed.creatTileSprite(string.format("%s.png", v.tileName))
    sprite:setScale(2)
    local x, y = self:indexToWorldPos(v.x, v.y)
    sprite:setPosition(ccp(x, y + self.mapGridSizeY / 4))
    bathnode:addChild(sprite, 1)
  end
  self.buildLayer:addChild(bathnode)
  self.actor = ed.readhero.getActorNew(1)
  self.actor:setPosition(ccp(self:indexToWorldPos(startPos.x, startPos.y)))
  self:addFca(self.actor)
  self.buildLayer:addChild(self.actor, 2)
  self.walkIndex = 1
  self.posMap = {
    two2One({x = -7, y = 5})
  }
  self:setPosIndex()
  ed.ui.logo.loadShaders()
  self:registerOnEnterHandler("onEnter", function()
  end)
end

function MapMainScene:setPosIndex()
  local hadSearchList = {}
  hadSearchList[self.posMap[1]] = true
  while true do
    local r, c = one2Two(self.posMap[#self.posMap])
    local neighbors = self:getNeighbors({x = r, y = c})
    local hadNext = false
    for k, v in ipairs(neighbors) do
      local index = two2One(v)
      if not hadSearchList[index] then
        hadSearchList[index] = true
        table.insert(self.posMap, index)
        hadNext = true
        break
      end
    end
    if not hadNext then
      break
    end
  end
  for k, v in ipairs(self.posMap) do
    print(one2Two(v))
  end
end

function MapMainScene:walk(i)
  self.walkIndex = (self.walkIndex + i - 1) % #self.posMap + 1
  local row, col = one2Two(self.posMap[self.walkIndex])
  endPos = {x = row, y = col}
  xpcall(function()
    self:findPath()
  end, EDDebug)
end
