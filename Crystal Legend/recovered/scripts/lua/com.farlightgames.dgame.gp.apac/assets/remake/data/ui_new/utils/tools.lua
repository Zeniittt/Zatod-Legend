local function setCommaForNumber(number)
  local str = tostring(number)
  
  local str2 = ""
  local sub = string.sub
  local i = 0
  for n = #str, 1, -1 do
    i = i + 1
    str2 = sub(str, n, n) .. str2
    if i == 3 then
      i = 0
      str2 = "," .. str2
    end
  end
  if sub(str2, 1, 1) == "," then
    str2 = sub(str2, 2, #str2)
  end
  return str2
end

ed.setCommaForNumber = setCommaForNumber

local function colorToStr(str)
  local len = string.len(str)
  if len ~= 7 then
    return 255, 255, 255
  end
  if string.sub(str, 1, 1) ~= "#" then
    return 255, 255, 255
  end
  local color = {
    r = tonumber(string.sub(str, 2, 3), 16),
    g = tonumber(string.sub(str, 4, 5), 16),
    b = tonumber(string.sub(str, 6, 7), 16)
  }
  return color.r, color.g, color.b
end

ed.colorToStr = colorToStr
