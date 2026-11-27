local lordUnit = {
  mt = {}
}
lordUnit.mt.__index = lordUnit
setmetatable(lordUnit, ed.Unit.mt)
ed.loarUnit = lordUnit

function lordUnit.mt:__tostring()
  return ed.Unit.mt.__tostring(self)
end

local function Create(proto, camp, config, extraData, warschool, bookReadingLevel, battleBonus)
  local lord_info = ed.getDataTable("MultiArenaLordList")[proto._tid]
  config.hp_mod = lord_info["HP MOD"]
  config.dps_mod = lord_info["DPS MOD"]
  config.what = "lordUnit"
  local unit = ed.UnitCreate(proto, camp, config, extraData, warschool, bookReadingLevel, battleBonus)
  setmetatable(unit, lordUnit.mt)
  unit.mp_mod = lord_info["MP Ratio"]
  unit.heal_ratio = lord_info["Heal Ratio"]
  unit:InitLordUnit()
  return unit
end

lordUnit.Create = Create
ed.lordUnitCreate = Create

function lordUnit:InitLordUnit()
  self.setMP = lordUnit.setMP
  self.direction = self:getInitDir()
end

function lordUnit:setMP(mp)
  local extra = mp - self.mp
  if 0 < extra then
    mp = self.mp + extra * self.mp_mod
  end
  if mp > self.attribs.MP then
    mp = self.attribs.MP
  end
  if mp < 0 then
    mp = 0
  end
  self.mp = mp
end

function lordUnit:addSpecialBuff()
  local bid = 4005
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = self:addBuff(binfo, self)
end
