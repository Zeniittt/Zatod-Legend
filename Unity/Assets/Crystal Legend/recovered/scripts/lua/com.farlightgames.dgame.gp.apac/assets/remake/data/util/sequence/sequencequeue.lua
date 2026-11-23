module("Sequence", package.seeall)
SequenceQueue = {}
SequenceQueue.__index = SequenceQueue

function SequenceQueue.Create(name, mgr)
  local queue = {}
  setmetatable(queue, SequenceQueue)
  queue.seq = Sequence.Create(name, mgr):Once()
  queue.group = {}
  queue.groups = {
    queue.group
  }
  return queue
end

function SequenceQueue:Remove()
  self:Reset()
end

function SequenceQueue:Reset()
  self.group = {}
  self.groups = {
    self.group
  }
  return self
end

function SequenceQueue:Push(group)
  self.group = group or {}
  table.insert(self.groups, self.group)
  return self
end

function SequenceQueue:Pop()
  local group = self.groups[#self.groups]
  self.groups[#self.groups] = nil
  self.group = self.groups[#self.groups]
  return group
end

function SequenceQueue:Add(key, clip)
  local group = self.group
  local seq = group[key] or {}
  if type(clip[1]) == "table" then
    for _, v in ipairs(clip) do
      table.insert(seq, v)
    end
  else
    table.insert(seq, clip)
  end
  group[key] = seq
  return self
end

function SequenceQueue:Set(key, clip)
  self.group[key] = clip
  return self
end

function SequenceQueue:Kick(callback, ...)
  for _, v in ipairs(self.groups) do
    self.seq:AddClip("group", v)
  end
  self:Reset()
  self.seq:Play(callback, ...)
  return self
end
