local class = {}
class.__index = class
ed.moonFestivalNet = class
local instance
local printData = true

function class.getInstance()
  if nil == instance then
    instance = class.create()
  end
  return instance
end

function class.create()
  local self = setmetatable({}, class)
  self:init()
  return self
end

function class:init()
  self.mgr = ed.moonFestivalMgr.getInstance()
end

function class:notify(data)
  if printData then
    print("-------------dragonBoatNet:notify--------------")
    ed.pt(data)
  end
  self.mgr:handleNotify(data)
end

function class:dispatch(data)
  if printData then
    print("-------------dragonBoatNet:dispatch--------------")
    ed.pt(data)
  end
  if data._open_panel then
    self.mgr:handleOpenPanel(data._open_panel)
  elseif data._start then
    self.mgr:handleStart(data._start)
  elseif data._buy_skin then
    self.mgr:handleUpgradeSkin(data._buy_skin)
  elseif data._use then
    self.mgr:handleUse(data._use, self.useCnt)
  elseif data._race then
    self.mgr:handleRace(data._race)
  elseif data._period_reward then
    self.mgr:handleGetReward(data._period_reward)
  elseif data._give then
    self.mgr:handleGive(data._give)
  elseif data._give_record then
    self.mgr:handleGiveRecord(data._give_record)
  elseif data._query_rankboard then
    self.mgr:handleQueryRank(data._query_rankboard)
  elseif data._give_status then
    self.mgr:handleQueryGiveStatus(data._give_status)
  elseif data._give_record_rank then
    self.mgr:handleQueryGiveRecordRank(data._give_record_rank)
  elseif data._skin_effect then
    self.mgr:handleQuerySkinEffect(data._skin_effect)
  end
end

function class:createReq()
  local req = ed.upmsg.autumn_flower_req()
  return req
end

function class:doReq(req)
  if printData then
    print("-------------dragonBoatNet:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "autumn_flower")
end

function class:sendOpenPanel()
  local req = self:createReq()
  req._open_panel = ed.upmsg.autumn_flower_open_panel()
  self:doReq(req)
end

function class:sendStart()
  local req = self:createReq()
  req._start = ed.upmsg.autumn_flower_start()
  self:doReq(req)
end

function class:sendUpgradeSkin(skin)
  local req = self:createReq()
  req._buy_skin = ed.upmsg.autumn_flower_buy_skin()
  req._buy_skin._skin_id = skin
  self:doReq(req)
end

function class:sendUse(cnt, frontId, behindId)
  local req = self:createReq()
  req._use = ed.upmsg.autumn_flower_use()
  req._use._num = cnt
  req._use._front_role_id = frontId
  req._use._behind_role_id = behindId
  self.useCnt = cnt
  self:doReq(req)
end

function class:sendRace(frontId, behindId)
  local req = self:createReq()
  req._race = ed.upmsg.autumn_flower_race()
  req._race._front_role_id = frontId
  req._race._behind_role_id = behindId
  self:doReq(req)
end

function class:sendGetReward()
  local req = self:createReq()
  req._period_reward = ed.upmsg.autumn_flower_period_reward()
  self:doReq(req)
end

function class:sendGive(userid, cnt)
  local req = self:createReq()
  req._give = ed.upmsg.autumn_flower_give()
  req._give._role_id = userid
  req._give._give_num = cnt
  self.isGiveSelf = userid == ed.getRoleId()
  self.giveSelfCnt = cnt
  self:doReq(req)
end

function class:sendGiveRecord()
  local req = self:createReq()
  req._give_record = ed.upmsg.autumn_flower_give_record()
  self:doReq(req)
end

function class:sendQueryRank()
  local req = self:createReq()
  req._query_rankboard = ed.upmsg.autumn_flower_query_rankboard()
  self:doReq(req)
end

function class:sendQueryGiveStatus(uid)
  local req = self:createReq()
  req._give_status = ed.upmsg.autumn_flower_give_status()
  req._give_status._role_id = uid
  self:doReq(req)
end

function class:sendQueryGiveRecordRank()
  local req = self:createReq()
  req._give_record_rank = ed.upmsg.autumn_flower_give_record_rank()
  self:doReq(req)
end

function class:sendQuerySkinEffect()
  local req = self:createReq()
  req._skin_effect = ed.upmsg.autumn_flower_skin_effect()
  self:doReq(req)
end
