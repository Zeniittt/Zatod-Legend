local HeroRecommendNetwork = {}
HeroRecommendNetwork.__index = HeroRecommendNetwork
local instance
local printNetData = false

function HeroRecommendNetwork.getInstance()
  if not instance then
    instance = HeroRecommendNetwork.create()
  end
  return instance
end

function HeroRecommendNetwork.create()
  local self = {}
  setmetatable(self, HeroRecommendNetwork)
  return self
end

function HeroRecommendNetwork:sendOpenPanel()
  local msg = ed.upmsg.herohot()
  msg._open_panel = ed.upmsg.hh_open_panel()
  self:doSend(msg)
end

function HeroRecommendNetwork:sendViewHotHero(heroid)
  local msg = ed.upmsg.herohot()
  msg._hot_hero = ed.upmsg.hh_hot_hero()
  msg._hot_hero._heroid = heroid
  self:doSend(msg)
end

function HeroRecommendNetwork:sendViewTopHero(heroid)
  local msg = ed.upmsg.herohot()
  msg._top_hero = ed.upmsg.hh_top_hero()
  msg._top_hero._heroid = heroid
  self:doSend(msg)
end

function HeroRecommendNetwork:sendAddFavorite(heroids)
  local msg = ed.upmsg.herohot()
  msg._fav_add = ed.upmsg.hh_fav_add()
  msg._fav_add._heroids = heroids
  self:doSend(msg)
end

function HeroRecommendNetwork:sendDelFavorite(heroids)
  local msg = ed.upmsg.herohot()
  msg._fav_del = ed.upmsg.hh_fav_add()
  msg._fav_del._heroids = heroids
  self:doSend(msg)
end

function HeroRecommendNetwork:sendQueryExceed(heroid)
  local msg = ed.upmsg.herohot()
  msg._query_exceed = ed.upmsg.hh_query_exceed()
  msg._query_exceed._heroid = heroid
  self:doSend(msg)
end

function HeroRecommendNetwork:sendStageRecommend(stageid, gameplay)
  local msg = ed.upmsg.herohot()
  msg._stage_recommend = ed.upmsg.hh_stage_recommend()
  msg._stage_recommend._stageid = stageid
  msg._stage_recommend._gameplay = gameplay or "stage"
  self:doSend(msg)
end

function HeroRecommendNetwork:sendTeamRecommend(gamePlay)
  local msg = ed.upmsg.herohot()
  msg._team_recommend = ed.upmsg.hh_team_recommend()
  msg._team_recommend._gameplay = gamePlay
  ed.printTable(msg)
  self:doSend(msg)
end

function HeroRecommendNetwork:sendHotRecommend(stageid, gameplay)
  local msg = ed.upmsg.herohot()
  msg._hot_recommend = ed.upmsg.hh_hot_recommend()
  msg._hot_recommend._stageid = stageid
  msg._hot_recommend._gameplay = gameplay
  self:doSend(msg)
end

function HeroRecommendNetwork:sendLineupRecommend(stageid, gameplay)
  local msg = ed.upmsg.herohot()
  msg._lineup_recommend = ed.upmsg.hh_lineup_recommend()
  msg._lineup_recommend._gameplay = gameplay or "stage"
  msg._lineup_recommend._stageid = stageid or 1
  self:doSend(msg)
end

function HeroRecommendNetwork:doSend(msg)
  ed.send(msg, "herohot")
end

function HeroRecommendNetwork:dispatch(msg)
  local event, info
  if msg._open_panel then
    event = "hh_open_panel_reply"
    info = msg._open_panel
    local handler = ed.netreply.herorecommend
    if handler then
      handler(info)
      ed.netreply.herorecommend = nil
      return
    end
  elseif msg._hot_hero then
    event = "hh_hot_hero_reply"
    info = msg._hot_hero
  elseif msg._top_hero then
    event = "hh_top_hero_reply"
    info = msg._top_hero
  elseif msg._fav_add then
    event = "hh_fav_add_reply"
    info = msg._fav_add
  elseif msg._fav_del then
    event = "hh_fav_del_reply"
    info = msg._fav_del
  elseif msg._query_exceed then
    event = "hh_query_exceed_reply"
    info = msg._query_exceed
  elseif msg._stage_recommend then
    event = "hh_stage_recommend_reply"
    info = msg._stage_recommend
  elseif msg._team_recommend then
    event = "hh_team_recommend_reply"
    info = msg._team_recommend
  elseif msg._latest_recommend then
    event = "hh_latest_lineup_recommend_reply"
    info = msg._latest_recommend
  elseif msg._hot_recommend then
    event = "hh_common_lineup_recommend_reply"
    info = msg._hot_recommend
  elseif msg._lineup_recommend then
    event = "hh_lineup_recommend_reply"
    info = msg._lineup_recommend
  end
  if event and info then
    FireEvent(event, info)
  end
end

ed.HeroRecommendNetwork = HeroRecommendNetwork.getInstance()
return HeroRecommendNetwork
