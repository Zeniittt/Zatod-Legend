module("ed.DelayProcessQueue", package.seeall)
local FuncList = {}

function Error(errorTitle, errorMsg)
  EDLog(errorTitle .. "\239\188\154" .. errorMsg)
end

function Enqueue(func, ...)
  local arg = {
    ...
  }
  local funcListItem = {Func = func, Arg = arg}
  table.insert(FuncList, funcListItem)
end

function Exe()
  for i, funcListItem in ipairs(FuncList) do
    local func = funcListItem.Func
    local arg = funcListItem.Arg
    if func == nil or type(func) ~= "function" then
      EDLog("DelayProcessQueue - illegal func type!")
      break
    end
    local status, errorMsg = pcall(func, unpack(arg))
    if not status then
      local errorTitle = "DelayProcessQueue [" .. tostring(func) .. "] \232\176\131\231\148\168\229\164\177\232\180\165"
      Error(errorTitle, errorMsg)
    end
    FuncList[i] = nil
  end
end

_G.EnqueueDelayProcess = Enqueue
_G.ExcuteDelayProcessQueue = Exe
