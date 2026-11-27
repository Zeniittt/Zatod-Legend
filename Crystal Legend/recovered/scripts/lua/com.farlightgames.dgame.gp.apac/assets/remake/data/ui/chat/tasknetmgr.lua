module("ed", package.seeall)
ChataskNetMgr = {}
ChataskNetMgr.__index = ChataskNetMgr
local ChataskNetMgrScrop = {}

function ChataskNetMgr.Create()
  local net_mgr = {}
  setmetatable(net_mgr, ChataskNetMgr)
  net_mgr:RegisterEvents()
  return net_mgr
end

function ChataskNetMgr:RegisterEvents()
  ListenEvent("ChataskDispatch", function(msg)
    self:Dispatch(msg)
  end, ChataskNetMgrScrop)
  ListenEvent("ChataskTaskRequest", function()
    self:SendTaskRequest()
  end, ChataskNetMgrScrop)
  ListenEvent("ChataskAddEnergyRequest", function(id)
    self:SendAddEnergyRequest(id)
  end, ChataskNetMgrScrop)
end

function ChataskNetMgr:Dispatch(msg)
  if msg._task then
    FireEvent("ChataskTaskReply", msg._task)
  elseif msg._add_energy then
    FireEvent("ChataskAddEnergyReply", msg._add_energy)
  end
end

function ChataskNetMgr:SendTaskRequest()
  local msg = ed.upmsg.guild_hero_task_in_chat()
  msg._task = ed.upmsg.guild_hero_chat_task()
  ed.send(msg, "guild_hero_task_in_chat")
end

function ChataskNetMgr:SendAddEnergyRequest(id)
  local msg = ed.upmsg.guild_hero_task_in_chat()
  msg._add_energy = ed.upmsg.guild_hero_chat_task_add_energy()
  msg._add_energy._id = id
  ed.send(msg, "guild_hero_task_in_chat")
end

function ChataskNetMgr:Destroy()
  ui.chatasknetmgr = nil
  CloseScope(ChataskNetMgrScrop)
end
