EngineRectCut = {}
local rct = EngineRectCut
local list_len = 0
local use_cnt = 0
local cell_list = {}

function rct.reset()
  list_len = 0
  use_cnt = 0
  cell_list = {}
end

function rct.add(x, y, w)
  x = x or -99999
  y = y or -99999
  local param = {
    x,
    y,
    w
  }
  if list_len == use_cnt then
    list_len = list_len + 1
    use_cnt = use_cnt + 1
    cell_list[list_len] = param
    return list_len
  elseif list_len > use_cnt then
    for k, v in pairs(cell_list) do
      if not v then
        cell_list[k] = param
        use_cnt = use_cnt + 1
        return k
      end
    end
  else
    EDDebug("%s list_len ,%s use_cnt ", list_len, use_cnt)
  end
end

function rct.remove(idx)
  cell_list[idx] = nil
  use_cnt = use_cnt - 1
end

function rct.clear()
  rct.reset()
end

function rct.isEmpty()
  return use_cnt == 0
end

function rct.getList()
  return cell_list
end

function rct.checkSameArea(owner, target)
  if owner:canFly() then
    return true
  end
  if rct.isEmpty() then
    return true
  end
  if not target then
    return true
  end
  local opos = owner.position
  local tpos = target.position
  local isSame = true
  for _, rect in pairs(cell_list) do
    local ox = math.abs(opos[1] - rect[1])
    local tx = math.abs(tpos[1] - rect[1])
    local sx = math.abs(opos[1] - tpos[1]) < math.max(ox, tx)
    local oy = math.abs(opos[2] - rect[2])
    local ty = math.abs(tpos[2] - rect[2])
    local sy = math.abs(opos[2] - tpos[2]) < math.max(oy, ty)
    isSame = isSame and sx and sy
  end
  return isSame
end
