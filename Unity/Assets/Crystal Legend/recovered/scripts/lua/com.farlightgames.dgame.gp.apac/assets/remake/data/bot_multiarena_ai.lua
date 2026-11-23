MultiArenaAi = {}
MultiArenaAi.__index = MultiArenaAi
local touch_point = {
  {110, 300},
  {210, 300},
  {400, 300},
  {550, 300},
  {690, 300},
  {110, 240},
  {210, 240},
  {400, 240},
  {550, 240},
  {690, 240},
  {110, 180},
  {210, 180},
  {400, 180},
  {550, 180},
  {690, 180}
}
local searchWhat = "lordUnit"

function MultiArenaAi:Init(cd)
  self.pre_hero = nil
  self.pre_magic = nil
  self.total_join_count = 0
  self.check_hero_index = 1
  self.check_magic_index = 1
  self.cd = cd
  self.cd_remind = cd
  self.heroHander = nil
  self.magicHander = nil
  self.caster = nil
  self.isHost = nil
  self.teamIndex = nil
end

function MultiArenaAi:ResetCamp(isHost, teamIndex)
  self.isHost = isHost
  self.teamIndex = teamIndex
  self.caster = ed.engine.battle_manager:GetPlayer(isHost, teamIndex)
end

function MultiArenaAi.Create(cd)
  local obj = {}
  setmetatable(obj, MultiArenaAi)
  obj:Init(cd)
  return obj
end

function MultiArenaAi:Update(dt)
  self.cd_remind = self.cd_remind - dt
  if self.cd_remind > 0 then
    return
  end
  if (self.total_join_count + 1) % 4 == 0 then
    self:SearchMagic()
  else
    self:SearchHero()
  end
end

function MultiArenaAi:ResetCounter()
  self.check_hero_index = self.check_hero_index + 1
  if self.check_hero_index > 4 then
    self.check_hero_index = 1
  end
  self.check_magic_index = self.check_magic_index + 1
  if self.check_magic_index > 3 then
    self.check_magic_index = 1
  end
  self.total_join_count = self.total_join_count + 1
  self.cd_remind = self.cd
end

function MultiArenaAi:SearchMagic()
  local index = self.check_magic_index
  if self.check_magic_index == 3 then
    index = math.random(1, 2)
  end
  local magicList = self.caster:GetMagicList()
  local mid = magicList[index]
  if not mid then
    self:ResetCounter()
    return
  end
  if not self.caster:CanAddMagic(mid) then
    return
  end
  table.remove(magicList, index)
  local p = math.random(1, #touch_point)
  local pos = touch_point[p]
  local x, y = pos[1], pos[2]
  pos = ed.toLogicalPosition(ccp(x, y), 0)
  local isHost = self.isHost and 1 or 0
  local teamIndex = self.teamIndex
  local info = {
    id = mid,
    pos = pos,
    isHost = isHost,
    teamIndex = teamIndex
  }
  ed.engine:onJoinMagic(info)
  self:ResetCounter()
end

function MultiArenaAi:SearchHero()
  if not self.caster:CanAdd() then
    return
  end
  local index = self.check_hero_index
  if self.check_hero_index == 4 then
    index = math.random(1, 3)
  end
  local heroList = self.caster:GetHeroList()
  local temp = heroList[index]
  if not temp then
    self:ResetCounter()
    return
  end
  local id = temp._tid
  table.remove(heroList, index)
  local p = math.random(1, #touch_point)
  local pos = touch_point[p]
  local x, y = pos[1], pos[2]
  pos = ed.toLogicalPosition(ccp(x, y), 0)
  local isHost = self.isHost and 1 or 0
  local teamIndex = self.teamIndex
  local info = {
    hid = id,
    pos = pos,
    isHost = isHost,
    teamIndex = teamIndex
  }
  ed.engine:onHeroJoinBattle(info)
  self:ResetCounter()
end
