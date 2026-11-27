module("ed.activity", package.seeall)
NetworkMgr = {}
NetworkMgr.__index = NetworkMgr
local ActivityNetworkScope = {}

function NetworkMgr.openPanle()
  local netwrokMgr = NetworkMgr.create()
  local msg = ed.upmsg.ask_activity_info()
  ed.send(msg, "ask_activity_info")
end

function NetworkMgr.create()
  local networkMgr = {}
  setmetatable(networkMgr, NetworkMgr)
  networkMgr:registeEvents()
  return networkMgr
end

function NetworkMgr:destroy()
  CloseScope(ActivityNetworkScope)
end

function NetworkMgr:registeEvents()
  CloseScope(ActivityNetworkScope)
  ListenEvent("activityRsp", function(msg)
    if ed.ActivityNewManager.isUseNewModule() then
      return
    end
    if not self.activityScene then
      self.activityScene = ed.ui.ActivityScene.create(msg)
    else
      self.activityScene:refresh(msg)
    end
  end, ActivityNetworkScope)
  ListenEvent("requestUnReadList", function(id)
    self:requestUnReadList(id)
  end, ActivityNetworkScope)
  ListenEvent("closeActivity", function()
    self:destroy()
  end, ActivityNetworkScope)
end

function NetworkMgr:requestUnReadList(id)
  local msg = ed.upmsg.query_activity()
  msg._activity_id = id
  ed.send(msg, "query_activity")
end
