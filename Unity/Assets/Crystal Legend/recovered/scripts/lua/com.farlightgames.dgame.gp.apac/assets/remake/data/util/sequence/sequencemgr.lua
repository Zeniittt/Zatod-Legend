module("Sequence", package.seeall)
local timetick = 0
local timetick_half = 0.008
local timetick_two = 0.032

local function timer_play(mgr)
  local function onTimer(delta)
    mgr:Update(delta)
  end
  
  CloseEvent("SequenceTimer_" .. tostring(mgr))
  ListenTimer(Timer:Always(timetick, "SequenceTimer_" .. tostring(mgr)), onTimer)
end

local function timer_stop(mgr)
  CloseEvent("SequenceTimer_" .. tostring(mgr))
end

SequenceMgr = {}
SequenceMgr.__index = SequenceMgr

function SequenceMgr.Current()
  return SequenceMgr.current
end

function SequenceMgr.SetCurrent(mgr)
  if SequenceMgr.current ~= nil then
    SequenceMgr.current:Pause()
  end
  SequenceMgr.current = mgr
  mgr:Resume()
end

function SequenceMgr.Create()
  local mgr = {}
  setmetatable(mgr, SequenceMgr)
  mgr.seqs = {}
  mgr.pend = {}
  return mgr
end

function SequenceMgr:Remove()
  self:Reset()
end

function SequenceMgr:Reset()
  for _, v in pairs(self.seqs) do
    v:Remove()
  end
  self.seqs = {}
  self.pend = {}
end

function SequenceMgr:Pause()
  timer_stop(self)
end

function SequenceMgr:Resume()
  setmetatable(self, SequenceMgr)
  if next(self.seqs) ~= nil then
    timer_play(self)
  end
end

function SequenceMgr:Update(delta)
  self.lock = true
  for _, v in pairs(self.seqs) do
    v:Update(delta)
  end
  self.lock = false
  for _, v in ipairs(self.pend) do
    if v[1] == "add" then
      self.seqs[v[2]] = v[3]
    elseif v[1] == "del" then
      self.seqs[v[2]] = nil
    end
  end
  self.pend = {}
end

function SequenceMgr:AddSequence(name, seq)
  if next(self.seqs) == nil then
    timer_play(self)
  end
  if not self.lock then
    self.seqs[name] = seq
  else
    table.insert(self.pend, {
      "add",
      name,
      seq
    })
  end
end

function SequenceMgr:DelSequence(name)
  if not self.lock then
    self.seqs[name] = nil
  else
    table.insert(self.pend, {"del", name})
  end
  if next(self.seqs) == nil then
    timer_stop(self)
  end
end

function SequenceMgr:GetSequence(name)
  return self.seqs[name]
end

function SequenceMgr:PauseByLevel(level)
  for _, v in pairs(self.seqs) do
    if level >= v.level then
      v:Pause()
    end
  end
end

function SequenceMgr:ResumeByLevel(level)
  for _, v in pairs(self.seqs) do
    if level >= v.level then
      v:Resume()
    end
  end
end
