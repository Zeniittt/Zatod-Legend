local Region = {}
ed.Region = Region
Region.__index = Region
local base = ed.Entity
setmetatable(Region, base.mt)

function Region.Create(skill)
  local self = base.create()
  setmetatable(self, Region)
  self.skill = skill
  self.info = skill.info
  self.caster = skill.caster
  self.camp = skill.caster.camp
  self.affect_camp = skill:selectDamageCamp()
  self.timer = skill.info["Script Arg1"]
  self.aoe_shape = skill.info["AOE Shape"]
  self.shape_arg1 = skill.info["Shape Arg1"]
  self.shape_arg2 = skill.info["Shape Arg2"]
  self.position = skill.target.position
  self.uniquenessID = tostring(ed.engine.ticks) .. tostring(skill.caster.position[1]) .. tostring(skill.caster.position[2]) .. tostring(ed.rand())
  local _, height = skill:launchPoint()
  self.height = height
  return self
end

ed.RegionCreate = Region.Create

function Region:update(dt)
  if self.birthtick == ed.engine.ticks then
    return
  end
  base.update(self, dt)
  self.timer = self.timer - dt
  if not self.terminated and self.timer >= 0 then
    local origin = self.position
    for unit in ed.engine:foreachAliveUnit(self.affect_camp) do
      if not unit.buff_effects.invulnerable then
        local p2 = ed.edpSub(unit.position, origin)
        if self.skill.testPointInShape(p2, self.aoe_shape, self.shape_arg1, self.shape_arg2) then
          if not unit.region_list[self.uniquenessID] then
            self:takeRegionEffectOn(unit)
          end
        elseif unit.region_list[self.uniquenessID] then
          self:abolishRegionEffectOn(unit)
        end
      end
    end
  else
    self:terminate()
  end
end

function Region:takeRegionEffectOn(unit)
  if self.skill.what == "magic" then
    return
  end
  unit.region_list[self.uniquenessID] = self
  local buff = self.skill:createBuff(unit)
  
  local function onRemoved(basefunc, buff)
    basefunc(buff)
    unit.region_list[self.uniquenessID] = nil
  end
  
  buff.onRemoved = ed.override(buff.onRemoved, onRemoved)
  unit[self.uniquenessID] = buff
  unit:addBuff(buff)
end

function Region:abolishRegionEffectOn(unit)
  unit:removeBuff(unit[self.uniquenessID])
  unit[self.uniquenessID] = nil
  unit.region_list[self.uniquenessID] = nil
end

function Region:terminate()
  base.terminate(self)
  for unit in ed.engine:foreachAliveUnit(self.affect_camp) do
    if unit.region_list[self.uniquenessID] then
      self:abolishRegionEffectOn(unit)
    end
  end
end

function Region:finish()
  self.timer = -1
end
