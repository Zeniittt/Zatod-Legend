local ed = ed
local class = {
  mt = {}
}
ed.Chain = class
class.mt.__index = class
local base = ed.Entity
setmetatable(class, base.mt)

local function ChainCreate(skill)
  local self = class.newChain(skill)
  self:jump()
  return self
end

class.create = ChainCreate
ed.ChainCreate = ChainCreate

function class.newChain(skill)
  local info = skill.info
  local self = base.create()
  self.skill = skill
  self.source = skill.caster
  self.target = skill.target
  self.jumps_remaining = info["Chain Jumps"]
  self.jump_timer = 0
  self.affect_times = {}
  self.is_chain = true
  setmetatable(self, class.mt)
  return self
end

local function jump(self)
  self.jumps_remaining = self.jumps_remaining - 1
  self.jump_timer = self.jump_timer + self.skill.info["Chain Gap"]
  self.affect_times[self.target] = (self.affect_times[self.target] or 0) + 1
  self.skill:takeEffectOn(self.target)
  if ed.run_with_scene and self.skill.info["Chain Effect"] then
    local effect = ed.ChainEffectCreate(self)
    self.chainEffect = effect
    ed.scene:addEffect(effect)
    effect.node:setScale(1)
  end
end

class.jump = jump

local function update(self, dt)
  local info = self.skill.info
  self.jump_timer = self.jump_timer - dt
  if self.jump_timer <= 0 then
    if 0 < self.jumps_remaining then
      self.source = self.target
      self.target = self:findNextTaeget()
      if self.target then
        self:jump()
        return
      end
    end
    self:terminate()
  end
end

class.update = update
local jump_gap = 6400
local abs = math.abs

local function findNextTaeget(self)
  local min = math.huge
  local ret
  for unit in ed.engine:foreachAliveUnit(self.skill:targetCamp()) do
    if unit == self.source then
    elseif unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= self.skill.caster.camp then
    else
      local times = self.affect_times[unit] or 0
      if 0 < times then
      else
        local distanceSQ = abs(ed.edpDistanceSQ(unit.position, self.source.position) - jump_gap)
        if min < distanceSQ then
        elseif distanceSQ > self.skill.min_range_sq and distanceSQ < self.skill.max_range_sq then
          ret = unit
          min = distanceSQ
        end
      end
    end
  end
  return ret
end

class.findNextTaeget = findNextTaeget
local class = {
  mt = {}
}
ed.ChainEffect = class
class.mt.__index = class
local math = math

local function ChainEffectCreate(model)
  local info = model.skill.info
  local res = info["Chain Effect"]
  
  local function createEffect(res)
    local isSpine = string.match(res, "%.sp$")
    if isSpine then
      local resource = string.gsub(info["Chain Effect"], "%.sp$", "")
      return ed.createEDFcaSpEffect(resource)
    else
      local resource = string.gsub(info["Chain Effect"], "%.cha$", "")
      return ed.createEDFcaEffect(resource)
    end
  end
  
  local self = {
    model = model,
    node = CCLayer:create(),
    content = createEffect(res),
    jumps_remaining = info["Chain Jumps"],
    terminated = false,
    startPos = nil,
    target = model.target
  }
  setmetatable(self, class.mt)
  self.node:addChild(self.content)
  if model.jumps_remaining == info["Chain Jumps"] - 1 then
    local pos, h = model.skill:launchPoint(true)
    pos = FlipXPosition(pos)
    self.startPos = ed.toViewPosition(pos, h)
  else
    local pos = FlipXPosition(model.source.position)
    self.startPos = ed.toViewPosition(pos, 12)
  end
  return self
end

class.create = ChainEffectCreate
ed.ChainEffectCreate = ChainEffectCreate

local function update(self, dt)
  local target = self.target
  local sx, sy = target:getRuntimeScale()
  local endPos
  local pos = FlipXPosition(target.position)
  if target.actor then
    endPos = ed.toViewPosition(pos, target.actor.height + 48 * target:getUnitScale() * sy)
  else
    endPos = ed.toViewPosition(pos, 48 * target:getUnitScale() * sy)
  end
  local startPos = self.startPos
  local x0 = math.min(startPos.x, endPos.x)
  local width = math.abs(startPos.x - endPos.x)
  local y0 = math.min(startPos.y, endPos.y)
  local height = math.abs(startPos.y - endPos.y)
  self.node:setClipRect(CCRectMake(x0, y0 - 20, width, height + 40))
  self.node:setPosition(ed.ccpZero)
  self.content:setPosition(ccpMidpoint(startPos, endPos))
  local deg = -math.deg(math.atan2(endPos.y - startPos.y, endPos.x - startPos.x))
  self.content:setRotation(deg)
  self.content:update(dt)
  self.terminated = self.content:isTerminated()
end

class.update = update

local function isTerminated(self)
  return self.terminated
end

class.isTerminated = isTerminated

local function setActionSpeeder(self, speeder)
  self.content:setActionSpeeder(speeder)
end

class.setActionSpeeder = setActionSpeeder
