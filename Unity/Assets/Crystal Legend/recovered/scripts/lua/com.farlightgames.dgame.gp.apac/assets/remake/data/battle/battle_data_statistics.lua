battledata = {}
battledata.__index = battledata

function battledata:init()
  self.damage = 0
  self.heal = 0
  self.takeHeal = 0
  self.beardmg = 0
  self.killlist = {}
  self.dmg_statistics = {
    AD = 0,
    AP = 0,
    HPR = 0,
    Holy = 0
  }
end

function battledata:new()
  local basedata = {}
  setmetatable(basedata, self)
  basedata:init()
  return basedata
end

function battledata:addDamage(dmg, dmg_type)
  self.damage = self.damage + dmg
  if dmg_type and self.dmg_statistics[dmg_type] then
    self.dmg_statistics[dmg_type] = self.dmg_statistics[dmg_type] + dmg
  end
end

function battledata:getDamage()
  return self.damage
end

function battledata:getDamageByType(dmg_type)
  return self.dmg_statistics[dmg_type]
end

function battledata:getADDamage()
  return self.dmg_statistics.AD
end

function battledata:getAPDamage()
  return self.dmg_statistics.AP
end

function battledata:getHPRDamage()
  return self.dmg_statistics.HPR
end

function battledata:getHolyDamage()
  return self.dmg_statistics.Holy
end

function battledata:addHeal(heal)
  self.heal = self.heal + heal
end

function battledata:getHeal()
  return self.heal + self.takeHeal
end

function battledata:addTakeHeal(heal)
  self.takeHeal = self.takeHeal + heal
end

function battledata:getTakeHeal()
  return self.takeHeal
end

function battledata:addBearDamage(beardmg)
  self.beardmg = self.beardmg + beardmg
end

function battledata:getBearDamage()
  return self.beardmg
end

function battledata:addKilled(tid)
  table.insert(self.killlist, tid)
end

function battledata:getKillNum()
  return #self.killlist
end
