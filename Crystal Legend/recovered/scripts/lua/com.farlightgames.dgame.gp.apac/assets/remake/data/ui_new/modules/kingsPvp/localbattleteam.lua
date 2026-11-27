module("ed.localbattle", package.seeall)
Team = {}
Team.__index = Team

function Team.create(owner_role)
  local team = {}
  team.what = "LocalBattleTeam"
  setmetatable(team, Team)
  team.owner_role = owner_role
  team.hero_list = {}
  return team
end

function Team:destroy()
  self.hero_list = nil
end

function Team:SetHeroes(hero_list)
  self.hero_list = hero_list
end

function Team:GetHeroes()
  return self.hero_list
end

function Team:AddHero(hero)
  local flag_existed = false
  for i, hero_info in ipairs(self.hero_list) do
    if hero_info._tid == hero._tid then
      flag_existed = true
      break
    end
  end
  if not flag_existed then
    table.insert(self.hero_list, hero)
  else
    EDLog("Team:AddHero - Hero is already existed!")
  end
end

function Team:DelHero(hero_id)
  local idx
  for i, hero_info in ipairs(self.hero_list) do
    if hero_info._tid == hero_id then
      idx = i
      break
    end
  end
  if idx then
    table.remove(self.hero_list, idx)
  else
    EDLog("Team:DelHero - Hero is not existed!")
  end
end

function Team:Reset()
  self.hero_list = {}
end
