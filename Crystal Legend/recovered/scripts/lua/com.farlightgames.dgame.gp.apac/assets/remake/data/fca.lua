local ed = ed
local class = {
  mt = {}
}
ed.FcaInfo = class
class.mt.__index = class
local cache = {}
require("proto.anim")
local proto = anim.character

local function FcaInfoGet(name)
  if cache[name] then
    return cache[name]
  end
  local path = "proto/" .. name .. ".cha"
  local data = EDGetFileData(path)
  local pb = proto():Parse(data)
  local self = {
    name = pb.name,
    elements = pb.elements,
    actions = {}
  }
  setmetatable(self, class.mt)
  for i, action in ipairs(pb.actions or {}) do
    local a = {
      name = action.name,
      anchor = action.anchor,
      fps = 25,
      frames = {},
      duration = nil
    }
    self.actions[a.name] = a
    for j, frame in ipairs(action.frames or {}) do
      local f = {
        events = {},
        elements = {}
      }
      a.frames[j] = f
      for k, event in ipairs(frame.events or {}) do
        local e = {
          t = event.type,
          a = event.arg
        }
        f.events[k] = e
      end
      for k, element in ipairs(frame.elements or {}) do
        local m = element.matrix
        local e = {
          n = self.elements[element.element_idx],
          a = element.alpha,
          m = m
        }
        f.elements[element.element_idx] = e
      end
    end
    a.duration = #a.frames / a.fps
  end
  cache[name] = self
  return self
end

class.get = FcaInfoGet
ed.FcaInfoGet = FcaInfoGet
local class = {
  mt = {}
}
ed.FcaActor = class
class.mt.__index = class

local function FcaActorCreate(name)
  local info = ed.FcaInfoGet(name)
  local self = {
    name = name,
    info = info,
    node = CCNode:create(),
    root = CCNode:create(),
    action_name = nil,
    action = nil,
    action_elapsed = 0,
    action_frame_idx = -1,
    components = {}
  }
  setmetatable(self, class.mt)
  for i, v in ipairs(info.elements) do
    self:changeComponent(i, v.name)
  end
  self.node:addChild(self.root)
  return self
end

ed.FcaActorCreate = FcaActorCreate
class.create = FcaActorCreate

local function changeComponent(self, i, file)
  if self.components[i] then
    self.root:removeChild(self.components[i], true)
  end
  local path = "fca/" .. self.name .. "/" .. file .. ".png"
  local sprite = ed.createSprite(path)
  sprite:setAnchorPoint(ccp(0, 0))
  sprite:setZOrder(self.info.elements[i].zOrder)
  self.root:addChild(sprite)
  self.components[i] = sprite
end

class.changeComponent = changeComponent

local function setAction(self, action_name)
  self.action_name = action_name
  self.action = self.info.actions[action_name]
  self.action_elapsed = 0
  self.action_frame_idx = -1
end

class.setAction = setAction
local floor = math.floor
local max = math.max
local setVisible = CCNode.setVisible
local setTransform = CCNode.setTransform
local setOpacity = CCSprite.setOpacity

local function update(self, dt)
  local time = self.action_elapsed + dt
  self.action_elapsed = time
  local action = self.action
  if action then
    local idx = max(1, floor(time * action.fps))
    if idx ~= self.action_frame_idx then
      self.action_frame_idx = idx
      local frame = self.action.frames[idx]
      if frame then
        local list = self.components
        local elem_infos = frame.elements
        for i = 1, #list do
          local elem_info = elem_infos[i]
          local sprite = list[i]
          if elem_info then
            setVisible(sprite, true)
            local h = sprite:getContentSize().height
            local m = elem_info.m
            local a, b, c, d, x, y = m[1], m[2], m[3], m[4], m[5], m[6]
            local t = CCAffineTransformMake(a, -b, -c, d, c * h + x, -d * h - y)
            setTransform(sprite, t)
            setOpacity(sprite, elem_info.a)
          else
            setVisible(sprite, false)
          end
        end
      end
    end
  end
end

class.update = update
