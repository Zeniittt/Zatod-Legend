local format = string.format
local sub = string.sub
local gsub = string.gsub

local function createBathNumOrTextNode(str, padding, rightAlignment, colorStr, isText)
  local texture = ed.loadNumTexture()
  local node = ed.creatNumSprite("bare.png")
  if isText then
    local frameName = "battletext_" .. str .. "_" .. colorStr .. ".png"
    node = ed.creatNumSprite(frameName)
    return node
  end
  colorStr = colorStr or "white"
  padding = padding or -2
  local length = 0
  local height = 0
  for index = 1, #str do
    local i = index
    if rightAlignment then
      i = #str - i + 1
    end
    local c = sub(str, i, i)
    if c == ":" then
      c = "colon"
    end
    if c == "," then
      c = "comma"
    end
    if c == "/" then
      c = "slash"
    end
    if c == "&" then
      c = "crit"
    end
    local frameName = colorStr .. "_" .. c .. ".png"
    local spr = ed.creatNumSprite(frameName)
    if nil == spr then
      print(" path is null !!!!!!!!!!!!!!", frameName)
      frameName = colorStr .. "_1" .. ".png"
      spr = ed.creatNumSprite(frameName)
    end
    local w = spr:getContentSize().width + padding
    height = spr:getContentSize().height
    local relativeX = length + w * 0.5
    if rightAlignment then
      relativeX = -relativeX
    end
    spr:setPosition(ccp(relativeX, 0))
    length = length + w
    node:addChild(spr)
  end
  node:setContentSize(CCSizeMake(length, 20))
  node:setCascadeOpacityEnabled(true)
  return node
end

ed.createBathNumOrTextNode = createBathNumOrTextNode
