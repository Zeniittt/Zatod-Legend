local SummonNetwork = {}
SummonNetwork.__index = SummonNetwork

function SummonNetwork.getInstance()
  if not SummonNetwork.instance then
    SummonNetwork.instance = SummonNetwork.create()
  end
  return SummonNetwork.instance
end

function SummonNetwork.create()
  local self = {}
  setmetatable(self, SummonNetwork)
  self:init()
  return self
end

function SummonNetwork:init()
end

function SummonNetwork:send(msg_name, body)
  local req = ed.upmsg.summon_circle_req()
  msg_name = "_" .. msg_name
  local msg = ed.upmsg["summon_circle" .. msg_name]()
  req[msg_name] = msg
  if body then
    for k, v in pairs(body) do
      msg[k] = v
    end
  end
  ed.send(req, "summon_circle")
end

local event_names = {}
SummonNetwork.EVENT_NAMES = event_names

function SummonNetwork:dispatch(msg)
  if msg._open_panel then
    ed.summonMgr:handleMsg(msg._open_panel, "open_panel")
  elseif msg._summon then
    ed.summonMgr:handleMsg(msg._summon, "summon")
    ed.player:increaseDailyjobCount({
      type = "TavernGroupUse",
      add = 1
    })
  elseif msg._switch_wish then
    ed.summonMgr:handleMsg(msg._switch_wish, "switch_wish")
  elseif msg._buy_ticket then
    ed.summonMgr:handleMsg(msg._buy_ticket, "buy_ticket")
  elseif msg._query_records then
    ed.summonMgr:handleMsg(msg._query_records, "query_records")
  elseif msg._take_rewards then
    ed.summonMgr:handleMsg(msg._take_rewards, "take_rewards")
  elseif msg._error_code then
    ed.summonMgr:handleMsg(msg._error_code, "error_code")
  end
end

ed.summonNet = SummonNetwork.getInstance()
