local class = newclass("g")
ed.rogueBlessBase = class

function class.blessCreate(blessId, level, rogueRevelation)
  local self = {
    blessId = blessId,
    rogueRevelation = rogueRevelation,
    isReinforced = level and 1 < level and true or false
  }
  setmetatable(self, {__index = class})
  self.info = self:getBlessInfo(self.blessId)
  return self
end

function class:init()
  if self.info["Bless Mod"] then
    local init_func = require("battle/rogueDestiny/rogueBless/" .. self.info["Bless Mod"])
    self = init_func(self)
  end
  self:addBuff()
  self:addAttr()
end

function class:reset()
end

function class:clear()
end

function class:getBlessInfo(blessId)
  local info = ed.getDataTable("RogueBless")[blessId]
  info = setmetatable({}, {__index = info})
  return info
end

function class:addBuff()
  local buffId = self.info["Mark Buff"]
  local buffTarget = self.info["Buff Target"]
  if not buffId or buffId == 0 or not buffTarget then
    return
  end
  local targetCamp
  if buffTarget == "SELF" then
    targetCamp = ed.emCampPlayer
  elseif buffTarget == "ENEMY" then
    targetCamp = ed.emCampEnemy
  end
  for unit in ed.engine:foreachAliveUnit(targetCamp) do
    if not unit.config.is_summoned then
      local buffInfo = ed.getDataTable("Buff")[buffId]
      local buff = ed.BuffCreate(buffInfo, unit, unit)
      unit:addBuff(buff, unit)
    end
  end
end

function class:addAttr()
  local attrTarget = self.info.AttribTarget
  if not attrTarget then
    return
  end
  local targetCamp
  if attrTarget == "SELF" then
    targetCamp = ed.emCampPlayer
  elseif attrTarget == "ENEMY" then
    targetCamp = ed.emCampEnemy
  end
  local filterKey = self.info.AttribTargetType
  local unitList = ed.engine:filterAliveUnit(targetCamp, {filterKey}, {
    "IS_SUMMONED"
  })
  for _, unit in ipairs(unitList or {}) do
    unit:addRogueBless(self)
    unit:rebuild()
  end
end

function class:apply(unit)
  local attribs = unit.attribs
  local isReinforced = self.isReinforced
  local attr1 = self.info.Attrib1
  local attr2 = self.info.Attrib2
  local arg1 = self.info["Script Arg1"] or 0
  local arg2 = self.info["Script Arg2"] or 0
  local arg5 = self.info["Script Arg5"] or 0
  local arg6 = self.info["Script Arg6"] or 0
  if attr1 then
    attribs[attr1] = (attribs[attr1] or 0) + (isReinforced and arg5 or arg1)
  end
  if attr2 then
    attribs[attr2] = (attribs[attr2] or 0) + (isReinforced and arg6 or arg2)
  end
end
