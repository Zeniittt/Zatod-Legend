local function edpAdd(a, b)
  return {
    a[1] + b[1],
    
    a[2] + b[2]
  }
end

ed.edpAdd = edpAdd

local function edpSub(a, b)
  return {
    a[1] - b[1],
    a[2] - b[2]
  }
end

ed.edpSub = edpSub

local function edpMult(a, s)
  return {
    a[1] * s,
    a[2] * s
  }
end

ed.edpMult = edpMult

local function edpLengthSQ(a)
  local x = a[1]
  local y = a[2]
  return x * x + y * y
end

ed.edpLengthSQ = edpLengthSQ

local function edpDistanceSQ(a, b)
  local x = a[1] - b[1]
  local y = a[2] - b[2]
  return x * x + y * y
end

ed.edpDistanceSQ = edpDistanceSQ

local function edpNormalize(a)
  local x = a[1]
  local y = a[2]
  local u = 1 / (x * x + y * y) ^ 0.5
  return {
    x * u,
    y * u
  }
end

ed.edpNormalize = edpNormalize

local function edpCompMult(a, b)
  return {
    a[1] * b[1],
    a[2] * b[2]
  }
end

ed.edpCompMult = edpCompMult

local function edpDot(a, b)
  return a[1] * b[1] + a[2] * b[2]
end

ed.edpDot = edpDot

local function edpCross(a, b)
  return a[1] * b[2] - a[2] * b[1]
end

ed.edpCross = edpCross

local function edpMid(a, b)
  return {
    (a[1] + b[1]) * 0.5,
    (a[2] + b[2]) * 0.5
  }
end

ed.edpMid = edpMid
ed.edpZero = {0, 0}
