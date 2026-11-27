local function read_profiler_file(file_path)
  local profiler_data = {}
  
  local file = io.open(file_path, "r")
  if not file then
    print("Unable to open file: " .. file_path)
    return profiler_data
  end
  for line in file:lines() do
    if line:find("#FILE#") or line:find("#IMAGE#") then
      local time, tag, file_name, us = line:match("%[(.-)%], (%#.-%#), (.-), (%d+)")
      if time and tag and file_name and us then
        us = tonumber(us)
        table.insert(profiler_data, {
          tag = tag,
          file_name = file_name,
          us = us
        })
      end
    end
  end
  file:close()
  return profiler_data
end

local function calculate_and_sort(data)
  local result = {
    ["#FILE#"] = {
      total_time = 0,
      items = {}
    },
    ["#IMAGE#"] = {
      total_time = 0,
      items = {}
    }
  }
  for _, entry in ipairs(data) do
    local tag = entry.tag
    local us = entry.us
    result[tag].total_time = result[tag].total_time + us
    table.insert(result[tag].items, {
      file_name = entry.file_name,
      us = us
    })
  end
  for _, category in pairs(result) do
    table.sort(category.items, function(a, b)
      return a.us > b.us
    end)
  end
  return result
end

local function write_sorted_data_to_file(result, output_path)
  local file = io.open(output_path, "w")
  if not file then
    print("Unable to open output file: " .. output_path)
    return
  end
  for tag, data in pairs(result) do
    file:write(tag .. " \230\128\187\232\128\151\230\151\182: " .. data.total_time .. " \206\188s\n")
    for _, item in ipairs(data.items) do
      local percentage = item.us / data.total_time * 100
      file:write(string.format("%s, \232\128\151\230\151\182: %d \206\188s, \229\141\160\230\175\148: %.2f%%\n", item.file_name, item.us, percentage))
    end
    file:write("\n")
  end
  file:close()
end

local input_path = "D:/workspace/dgame/depot/dgame-remake/Client/profiler.txt"
local output_path = "D:/workspace/dgame/depot/dgame-remake/Client/profiler_order.txt"
local profiler_data = read_profiler_file(input_path)
local sorted_data = calculate_and_sort(profiler_data)
write_sorted_data_to_file(sorted_data, output_path)
print("\230\149\176\230\141\174\229\183\178\232\190\147\229\135\186\229\136\176 " .. output_path)
