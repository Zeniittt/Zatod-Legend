local ed = ed
local effectHue = {}

local function xRotateMat(matrix3, rs, rc)
  matrix3[1] = 1
  matrix3[2] = 0
  matrix3[3] = 0
  matrix3[4] = 0
  matrix3[5] = rc
  matrix3[6] = rs
  matrix3[7] = 0
  matrix3[8] = -rs
  matrix3[9] = rc
end

local function yRotateMat(matrix3, rs, rc)
  matrix3[1] = rc
  matrix3[2] = 0
  matrix3[3] = -rs
  matrix3[4] = 0
  matrix3[5] = 1
  matrix3[6] = 0
  matrix3[7] = rs
  matrix3[8] = 0
  matrix3[9] = rc
end

local function zRotateMat(matrix3, rs, rc)
  matrix3[1] = rc
  matrix3[2] = rs
  matrix3[3] = 0
  matrix3[4] = -rs
  matrix3[5] = rc
  matrix3[6] = 0
  matrix3[7] = 0
  matrix3[8] = 0
  matrix3[9] = 1
end

local function matrixMult(matrixa, matrixb, matrixc)
  local tempMatrix = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  for y = 1, 3 do
    for x = 1, 3 do
      tempMatrix[(y - 1) * 3 + x] = matrixb[(y - 1) * 3 + 1] * matrixa[x] + matrixb[(y - 1) * 3 + 2] * matrixa[3 + x] + matrixb[(y - 1) * 3 + 3] * matrixa[6 + x]
    end
  end
  for y = 1, 9 do
    matrixc[y] = tempMatrix[y]
  end
end

local function hueMatrix(mat, angle)
  local sqrt = math.sqrt
  local sqrt2 = sqrt(2)
  local sqrt3 = sqrt(3)
  local rot = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  local xrs, xrc = 1 / sqrt2, 1 / sqrt2
  xRotateMat(mat, xrs, xrc)
  local yrs, yrc = -1 / sqrt3, sqrt2 / sqrt3
  yRotateMat(rot, yrs, yrc)
  matrixMult(rot, mat, mat)
  local zrs = math.sin(angle)
  local zrc = math.cos(angle)
  zRotateMat(rot, zrs, zrc)
  matrixMult(rot, mat, mat)
  yRotateMat(rot, -yrs, yrc)
  matrixMult(rot, mat, mat)
  xRotateMat(rot, -xrs, xrc)
  matrixMult(rot, mat, mat)
end

local function calculateMatrix(hue)
  assert(hue and tonumber(hue) <= 1 and tonumber(hue) >= 0, "the params hue must be a number in 0 - 1")
  local mat = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  hueMatrix(mat, hue * 2 * math.pi)
  return mat
end

function effectHue.create(sprite, hue)
  local shader = CCShaderCache:sharedShaderCache():programForKey("HueShader")
  assert(shader, "please first load HueShader")
  local mat = calculateMatrix(hue)
  sprite:setShaderProgram(shader)
  sprite:getShaderProgram():use()
  local location = sprite:getShaderProgram():getUniformLocationForName("u_hue")
  sprite:getShaderProgram():setUniformsForBuiltins()
  sprite:getShaderProgram():setUniformLocationWithMatrix3fv(location, mat, 1)
end

ed.setSpriteHue = effectHue.create
return effectHue
