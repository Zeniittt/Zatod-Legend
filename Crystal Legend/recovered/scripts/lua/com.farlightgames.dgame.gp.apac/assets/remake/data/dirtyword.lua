local ed = ed
local dict

local function make_dict()
end

local function check(array, i)
  local node = dict
  local j = i - 1
  while true do
    if not node or node.ending then
      break
    end
    j = j + 1
    local c = array[j]
    node = node[c]
  end
  if node and node.ending then
    return table.concat(array, "", i, j)
  end
end

local function dirtyword_check(text)
  return nil
end

ed.dirtyword_check = dirtyword_check
