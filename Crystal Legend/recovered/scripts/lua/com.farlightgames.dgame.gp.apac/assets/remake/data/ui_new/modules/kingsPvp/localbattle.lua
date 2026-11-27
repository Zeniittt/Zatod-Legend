module("ed.localbattle", package.seeall)
role_opposite = {host = "slave", slave = "host"}
battle_state = {
  "prepare",
  "hero_select",
  "to_be_confirmed",
  "confirmed",
  "exit"
}
Battle = {}
Battle.__index = Battle

function Battle.create(role, rule, opponent)
  local battle = {}
  battle.what = "LocalBattle"
  setmetatable(battle, Battle)
  battle.role = role
  battle.rule = rule
  battle.opponent = opponent
  battle:InitTeams()
  battle.round = 1
  battle.next_round = battle.round
  battle.round_win_times = 0
  if rule == "bo3" then
    battle.final_win_times = 2
  elseif rule == "bo1" then
    battle.final_win_times = 1
  end
  battle.state = "prepare"
  battle.heroes_forbidden = {}
  return battle
end

function Battle:destroy()
  self.teams = nil
  self.heroes_forbidden = nil
end

function Battle:InitTeams()
  self.teams = {}
  self.teams[self.role] = Team.create(self.role)
  self.teams[role_opposite[self.role]] = Team.create(role_opposite[self.role])
end

function Battle:SetState(state)
  self.state = state
end

function Battle:SetRound(round)
  self.round = round
end

function Battle:GetRound()
  return self.round
end

function Battle:SetNextRound(round)
  self.next_round = round
end

function Battle:GetNextRound()
  return self.next_round
end

function Battle:RoundReset()
  self.round = self.next_round or 0
  if self.round > 0 then
    local my_last_team = self.teams[self.role]:GetHeroes()
    for _, hero in ipairs(my_last_team) do
      table.insert(self.heroes_forbidden, hero._tid)
    end
  end
  for k, team in pairs(self.teams) do
    team:Reset()
  end
end

function Battle:IsHeroForbidden(hero_id)
  if ed.isElementInTable(hero_id, self.heroes_forbidden) then
    return true
  else
    return false
  end
end

function Battle:SetWinTimes(times)
  self.round_win_times = times
end

function Battle:GetWinTimes()
  return self.round_win_times
end

function Battle:IsWin()
  return self.round_win_times >= self.final_win_times
end
