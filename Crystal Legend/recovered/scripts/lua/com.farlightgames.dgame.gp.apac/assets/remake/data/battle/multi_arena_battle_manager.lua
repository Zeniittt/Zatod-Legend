local mManager = {}
mManager.__index = mManager
MultiArenaBattleManager = mManager

function mManager.Create(config)
  local obj = {}
  setmetatable(obj, mManager)
  obj:Init(config)
  return obj
end

function mManager:Init(config)
  self.hostTeam = MultiArenaBattleTeam.Create("host", config.host)
  self.guestTeam = MultiArenaBattleTeam.Create("guest", config.guest)
end

function mManager:GetCampTeam(isHost)
  if isHost then
    return self.hostTeam
  else
    return self.guestTeam
  end
end

function mManager:AddUnit(unit, isHost, teamIndex)
  local team = self:GetCampTeam(isHost)
  team:AddUnit(unit, teamIndex)
end

function mManager:GetMagicJoinBattle()
end

function mManager:GetTeamLord()
  return self.hostTeam.lord, self.guestTeam.lord
end

function mManager:GetTeamLordWSChools(isHost)
  local team = self:GetCampTeam(isHost)
  return team:GetLordWSChools()
end

function mManager:GetMembersState()
  local ha, hd = self.hostTeam:GetMembersState()
  local ga, gd = self.guestTeam:GetMembersState()
  return ha, hd, ga, gd
end

function mManager:Update(dt)
  self.hostTeam:Update(dt)
  self.guestTeam:Update(dt)
end

function mManager:GetPlayer(isHost, index)
  local team = self:GetCampTeam(isHost)
  return team:GetPlayer(index)
end

function mManager:GetDefaultPlayer()
  local isHost = battle_tick.getHost()
  local index = battle_tick.getTeamIndex()
  return self:GetPlayer(isHost, index)
end

local mTeam = {}
mTeam.__index = mTeam
MultiArenaBattleTeam = mTeam

function mTeam.Create(camp, config)
  local obj = {}
  setmetatable(obj, mTeam)
  obj.camp = camp
  obj:Init(config)
  return obj
end

function mTeam:Init(config)
  self.playerList = {}
  self.lord = config.lord
  self.lord_index = config.lord_index
  self:CreatePlayers(config.member_list)
end

function mTeam:CreatePlayers(listData)
  for k, member in ipairs(listData) do
    local config = {
      data = member,
      camp = self.camp,
      index = member.index
    }
    local p = MultiArenaBattlePlayer.Create(config)
    self.playerList[member.index] = p
  end
end

function mTeam:GetLord()
  return self.lord
end

function mTeam:GetPlayer(index)
  return self.playerList[index]
end

function mTeam:GetLordWSChools()
  local index = self.lord_index
  local p = self.playerList[index]
  if not p then
    EDDebug(index .. " can not find in team !!!")
    return
  end
  return p:GetWSChools()
end

function mTeam:AddUnit(unit, teamIndex)
  local p = self.playerList[teamIndex]
  if not p then
    EDDebug(teamIndex .. " can not find in team !!!")
    return
  end
  p:AddUnit(unit)
end

function mTeam:GetMembersState()
  local ta, td = 0, 0
  for k, p in pairs(self.playerList) do
    local a, d = p:GetMembersState()
    ta = ta + a
    td = td + d
  end
  return ta, td
end

function mTeam:Update(dt)
  for k, p in pairs(self.playerList) do
    p:Update(dt)
  end
end

local mPlayer = {}
mPlayer.__index = mPlayer
MultiArenaBattlePlayer = mPlayer

function mPlayer.Create(config)
  local obj = {}
  setmetatable(obj, mPlayer)
  obj:Init(config)
  return obj
end

local function getRCspeed(num)
  num = math.max(num, 1)
  return ed.multiArena.GetRecoverySpeed(num)
end

function mPlayer:Init(config)
  local data = config.data
  local camp = config.camp
  local index = config.index
  self.alive_count = 0
  self.dead_count = 0
  self.currentEnergy = ed.multiArena.InitEnergy
  self.maxEnergy = ed.multiArena.MaxEnergy
  local rcs = math.max(self.alive_count, 1)
  self.energyIncrement = 0
  self.maxHeroNum = ed.multiArena.MaxHeroNum
  self.data = data
  self.warschool_books = data.warschool_books
  self.bookreading_level = data.bookreading_level
  self.battleBonus = data.battleBonus
  self.camp = camp
  self.index = index
  self.heroes = self:ToHash(data.heroes)
  self.magics = data.magics
  self.join_unit_list = {}
  self.use_magic_list = {}
  self.hid_used_list = {}
  self.hid_used_num = 0
  self:CreateMagicCaster()
end

function mPlayer:CreateMagicCaster()
  local hpMod = 2
  local dpsMod = 1
  local skillLevel = {
    100,
    100,
    100,
    100,
    100
  }
  local proto = {
    _tid = 1,
    _level = 100,
    _stars = 5,
    _skill_levels = skillLevel,
    _rank = 16,
    _arousal = {
      _status = 1,
      _str = 200,
      _int = 200,
      _agi = 200
    }
  }
  local config = {
    hp_mod = hpMod,
    dps_mod = 3,
    size_mod = 1.6
  }
  local caster = ed.UnitCreate(proto, ed.emCampPlayer, config)
  for k, param in pairs(caster) do
    if type(param) == "function" then
      caster[k] = function()
      end
    end
  end
  
  function caster.display()
    return "magic "
  end
  
  caster.what = "magicSystem"
  self.magicCaster = caster
end

function mPlayer:GetMagicCaster()
  return self.magicCaster
end

function mPlayer:CanAdd()
  local cr = self.currentEnergy
  local jb = self:GetJoinBattleEnergy()
  if cr < jb then
    return false, "lackenergy"
  end
  local ac = self.alive_count
  local mc = self.maxHeroNum
  if ac >= mc then
    return false, "heromax"
  end
  return true
end

function mPlayer:CanAddMagic(mid)
  local limitEnergy = ed.multiArena.Magic.GetMagicCostEnergy(mid)
  return limitEnergy <= self.currentEnergy
end

function mPlayer:AddUnit(unit)
  if not unit then
    EDDebug("unit can not be nil ")
    return
  end
  table.insert(self.join_unit_list, unit)
  self.currentEnergy = self.currentEnergy - self:GetJoinBattleEnergy()
  self:LockHeroUsed(unit.tid)
end

function mPlayer:AddMagic(mid)
  local limitEnergy = ed.multiArena.Magic.GetMagicCostEnergy(mid)
  self.currentEnergy = self.currentEnergy - limitEnergy
  table.insert(self.use_magic_list, mid)
end

function mPlayer:ToHash(heroes)
  local temp = {}
  for k, hero in ipairs(heroes) do
    local param = {hero = hero}
    temp[hero._tid] = param
  end
  return temp
end

function mPlayer:ResetHeroList()
  print("reset hero list !!! ")
  self.hid_used_list = {}
  self.hid_used_num = 0
end

function mPlayer:LockHeroUsed(hid)
  self.hid_used_list[hid] = true
  self.hid_used_num = self.hid_used_num + 1
end

function mPlayer:GetJoinBattleEnergy()
  local num = math.max(self.alive_count, 1)
  num = math.min(num, self.maxHeroNum)
  return ed.multiArena.GetJoinBattleEnergy(num)
end

function mPlayer:GetHeroJoinBattle(hid)
  local h = self.heroes[hid]
  if not h then
    return
  end
  return h.hero, self.warschool_books, self.bookreading_level, self.battleBonus
end

function mPlayer:GetWSChools()
  return self.warschool_books, self.bookreading_level, self.battleBonus
end

function mPlayer:GetCurrentEnergy()
  return self.currentEnergy
end

function mPlayer:GetHeroList()
  return self.data.heroes
end

function mPlayer:GetMagicList()
  return self.magics or {}
end

function mPlayer:GetMembersState()
  return self.alive_count, self.dead_count
end

function mPlayer:Update(dt)
  local alive_count, dead_count = 0, 0
  for k, unit in ipairs(self.join_unit_list) do
    if unit:isAlive() then
      alive_count = alive_count + 1
    else
      dead_count = dead_count + 1
    end
  end
  self.alive_count = alive_count
  self.dead_count = dead_count
  self.energyIncrement = getRCspeed(alive_count)
  self.currentEnergy = self.currentEnergy + self.energyIncrement
  self.currentEnergy = math.min(self.currentEnergy, self.maxEnergy)
end
