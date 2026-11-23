module("Sequence", package.seeall)
Sequence = {}
Sequence.__index = Sequence
ID = ID or 0

function GenerateID()
  ID = ID + 1
  return ID
end

function Sequence.Create(name, mgr, level)
  local seq = {}
  setmetatable(seq, Sequence)
  if name == nil or name == "" then
    name = GenerateID()
  end
  seq.name = name
  seq.mgr = mgr or SequenceMgr.Current()
  seq.level = level or 1
  seq.keys = {}
  seq.clips = {}
  seq.index = 0
  seq.remains = {}
  seq.update = false
  seq.once = false
  return seq
end

function Sequence:Remove()
  self:Reset()
end

function Sequence.Get(name)
  return SequenceMgr.Current():GetSequence(name)
end

function Sequence:AddKey(key, value)
  self.keys[key] = value
  return self
end

function Sequence:AddKeys(tbl)
  local keys = self.keys
  for k, v in pairs(tbl) do
    keys[k] = v
  end
  return self
end

function Sequence:AddClip(t, ...)
  if type(t) == "table" then
    if t.symbol == "Sequence.Clip" then
      table.insert(self.clips, t)
    else
      table.insert(self.clips, Clip.Create(unpack(t)))
    end
  else
    table.insert(self.clips, Clip.Create(t, ...))
  end
  local clip = self.clips[#self.clips]
  clip.keys = self.keys
  if self.update and self.index == #self.clips then
    self.clips[#self.clips]:Enter()
  end
  return self
end

function Sequence:AddClips(t)
  if type(t) == "table" and type(t[1]) == "table" then
    for _, v in ipairs(t) do
      self:AddClip(v)
    end
  else
    self:AddClip(t)
  end
  return self
end

function Sequence:Once(sw)
  self.once = sw or true
  return self
end

function Sequence:Play(callback, ...)
  if self.mgr ~= nil then
    if self.mgr.AddSequence ~= nil then
      self.mgr:AddSequence(self.name, self)
    end
  else
    SequenceMgr.Current():AddSequence(self.name, self)
  end
  if callback ~= nil then
    local args = {
      ...
    }
    if 0 < #args then
      function self.callback()
        callback(unpack(args))
      end
    else
      self.callback = callback
    end
  end
  if not self.update then
    self.index = 0
    self.update = true
    if 0 < #self.clips then
      self.index = 1
      self.clips[1]:Enter()
      self:Update(0)
    else
      self:Stop()
    end
  end
  return self
end

function Sequence:Stop()
  if self.mgr ~= nil then
    if self.mgr.DelSequence ~= nil then
      self.mgr:DelSequence(self.name, self)
    end
  else
    SequenceMgr.Current():DelSequence(self.name)
  end
  if self.update then
    self.index = 0
    self.update = false
    local callback = self.callback
    if self.once then
      self:Reset()
    end
    if callback ~= nil then
      EnqueueDelayProcess(callback)
      self.callback = nil
    end
  end
  return self
end

function Sequence:Pause()
  self.update = false
  return self
end

function Sequence:Resume()
  setmetatable(self, Sequence)
  self.update = true
  return self
end

function Sequence:IsPlaying()
  return self.update
end

function Sequence:Reset()
  if self.index > 0 then
    local remains = self.remains
    for k, v in pairs(remains) do
      v:Leave()
    end
    local clip = self.clips[self.index]
    if clip ~= nil then
      clip:Leave()
    end
  end
  for _, v in ipairs(self.clips) do
    v:Remove()
  end
  self.clips = {}
  self.index = 0
  self.remains = {}
  self.update = false
  self.callback = nil
  return self
end

function Sequence:Update(delta)
  if not self.update then
    return false
  end
  local remains = self.remains
  for k, v in pairs(remains) do
    local _, unblock = v:Update(delta)
    if not unblock then
      v:Leave()
      remains[k] = nil
    end
  end
  local clip = self.clips[self.index]
  while clip ~= nil do
    local block, unblock = clip:Update(delta)
    if block then
      break
    end
    if unblock then
      self.remains[self.index] = clip
    else
      clip:Leave()
    end
    self.index = self.index + 1
    clip = self.clips[self.index]
    if clip ~= nil then
      clip:Enter(self.keys)
    elseif self.callback then
      EnqueueDelayProcess(self.callback)
      self.callback = nil
    end
    delta = 0
  end
  if clip == nil and next(remains) == nil then
    self:Stop()
    return false
  end
  return true, clip ~= nil
end
