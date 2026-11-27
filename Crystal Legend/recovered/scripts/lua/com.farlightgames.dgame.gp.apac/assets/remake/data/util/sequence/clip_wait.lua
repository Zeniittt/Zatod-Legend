SequenceClip("wait")

function OnCreate(data, time)
  data.time = time
end

function OnEnter(data)
  data.time_start = ed.getServerMillionTime()
end

function OnBlock(data, delta)
  local delta_time = ed.getServerMillionTime() - data.time_start
  return delta_time < data.time
end

function Log(data)
  return "wait(" .. data.time .. ")"
end
