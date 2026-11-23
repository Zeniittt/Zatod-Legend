SequenceClip("group")
local mgr = {}

function OnCreate(data, seq_list)
  data.seqs = {}
  if seq_list ~= nil then
    for k, v in pairs(seq_list) do
      local seq = Sequence.Sequence.Create(k, mgr)
      if type(v[1]) == "table" then
        for _, clip in ipairs(v) do
          seq:AddClip(unpack(clip))
        end
      else
        seq:AddClip(unpack(v))
      end
      data.seqs[k] = seq
    end
  end
end

function OnEnter(data)
  data.lives = {}
  data.remains = {}
  for k, v in pairs(data.seqs) do
    v:Play()
    data.lives[k] = v
  end
end

function OnBlock(data, delta)
  for k, v in pairs(data.remains) do
    local e = v:Update(delta)
    if not e then
      data.remains[k] = nil
    end
  end
  local update = false
  for k, v in pairs(data.lives) do
    local e, block = v:Update(delta)
    if not e then
      data.lives[k] = nil
    elseif not block then
      data.lives[k] = nil
      data.remains[k] = v
    end
    update = update or e and block
  end
  return update
end

function OnUnblock(data, delta)
  local update = false
  for k, v in pairs(data.remains) do
    local e = v:Update(delta)
    if not e then
      data.remains[k] = nil
    end
    update = update or e
  end
  return update
end

function OnLeave(data)
  for k, v in pairs(data.lives) do
    v:Stop()
  end
  for k, v in pairs(data.remains) do
    v:Stop()
  end
  data.lives = nil
  data.remains = nil
end

function OnRemove(data)
  for _, v in pairs(data.seqs) do
    v:Remove()
  end
  data.seqs = nil
end

function Log(data, indent)
  local output = StringBuilder:new():AppendFormat([[

%sgroup:]], indent)
  for _, seq in pairs(data.seqs) do
    output:AppendFormat("%s", seq:Log(indent .. " "))
  end
  return output:ToString()
end
