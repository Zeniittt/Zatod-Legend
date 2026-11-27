module("astar", package.seeall)
local directions1 = {
  {1, 0},
  {-1, 0},
  {0, 1},
  {0, -1},
  {1, -1},
  {1, 1}
}
local directions0 = {
  {1, 0},
  {-1, 0},
  {-1, 1},
  {-1, -1},
  {0, -1},
  {0, 1}
}

function create_point(x, y)
  return {x = x, y = y}
end

local num_str_cache = {}
local str_num_cache = {}

function cached_point_key(point)
  local cache = num_str_cache[point.x]
  if not cache then
    cache = {}
    num_str_cache[point.x] = cache
  end
  local cache_key = cache[point.y]
  if not cache_key then
    cache_key = point.x .. "," .. point.y
    cache[point.y] = cache_key
    str_num_cache[cache_key] = point
  end
  return cache_key
end

function get_point_from_cache(key)
  if str_num_cache[key] then
    return str_num_cache[key]
  end
  local coords = {
    key:match("(%-?%d+),(%-?%d+)")
  }
  return create_point(tonumber(coords[1]), tonumber(coords[2]))
end

function heuristic(a, b)
  local dx = math.abs(a.x - b.x)
  local dy = math.abs(a.y - b.y)
  return math.max(dx, dy)
end

function get_neighbors(node)
  local neighbors = {}
  local remainder = math.abs(node.y) % 2
  if remainder == 0 then
    for _, dir in ipairs(directions0) do
      table.insert(neighbors, create_point(node.x + dir[1], node.y + dir[2]))
    end
  else
    for _, dir in ipairs(directions1) do
      table.insert(neighbors, create_point(node.x + dir[1], node.y + dir[2]))
    end
  end
  return neighbors
end

function lowest_f_score(open_set, f_score)
  local lowest_f_key, lowest
  for key, _ in pairs(open_set) do
    if lowest == nil then
      lowest = f_score[key]
      lowest_f_key = key
    elseif lowest > f_score[key] then
      lowest = f_score[key]
      lowest_f_key = key
    end
  end
  return lowest_f_key
end

function astar(start, goal, is_passable)
  local start_point_key = cached_point_key(start)
  local open_set = {
    [start_point_key] = true
  }
  local closed_set = {}
  local came_from = {}
  local g_score = {
    [start_point_key] = 0
  }
  local f_score = {
    [start_point_key] = heuristic(start, goal)
  }
  while next(open_set) do
    local lowest_key = lowest_f_score(open_set, f_score)
    local current = get_point_from_cache(lowest_key)
    if current.x == goal.x and current.y == goal.y then
      local path = {}
      while current do
        table.insert(path, 1, current)
        local key = cached_point_key(current)
        current = came_from[key]
      end
      return path
    end
    local current_key = lowest_key
    open_set[current_key] = nil
    closed_set[current_key] = true
    for _, neighbor in ipairs(get_neighbors(current)) do
      local neighbor_key = cached_point_key(neighbor)
      if not closed_set[neighbor_key] and is_passable(neighbor_key) then
        local tentative_g_score = g_score[current_key] + 1
        if not open_set[neighbor_key] or tentative_g_score < g_score[neighbor_key] then
          came_from[neighbor_key] = current
          g_score[neighbor_key] = tentative_g_score
          f_score[neighbor_key] = g_score[neighbor_key] + heuristic(neighbor, goal)
          if not open_set[neighbor_key] then
            open_set[neighbor_key] = true
          end
        end
      end
    end
  end
  return nil
end

function clear_cached_paths()
  cachedPaths = nil
  num_str_cache = {}
  str_num_cache = {}
end

function find_path(start, goal, is_passable)
  local start_key = cached_point_key(start)
  local goal_key = cached_point_key(goal)
  if not cachedPaths then
    cachedPaths = {}
  end
  if not cachedPaths[start_key] then
    cachedPaths[start_key] = {}
  elseif cachedPaths[start_key][goal_key] and not ignore_cache then
    return cachedPaths[start_key][goal_key]
  end
  local path = astar(start, goal, is_passable)
  if not cachedPaths[start_key][goal_key] and not ignore_cache then
    cachedPaths[start_key][goal_key] = path
  end
  return path
end
