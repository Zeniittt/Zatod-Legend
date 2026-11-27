local chatMedal = {}
chatMedal.__index = chatMedal
ed.chatMedal = chatMedal
local instance

function chatMedal.getInstance()
  if not instance then
    instance = chatMedal.create()
  end
  return instance
end

function chatMedal.create()
  local self = {}
  setmetatable(self, chatMedal)
  self.medalList = {}
  return self
end

function chatMedal:addMedal(info)
  local id = info.id
  local title = ed.TitleMgr.getInstance():getOneTitleById(id)
  info.title = title
  self.medalList[#self.medalList + 1] = info
end

function chatMedal:checkInvalidObj()
  local list = {}
  for _, v in ipairs(self.medalList) do
    if v.icon and not tolua.isnull(v.icon) then
      list[#list + 1] = v
    end
  end
  self.medalList = list
end

function chatMedal:isHide(pnode)
  local node = pnode
  if not node or tolua.isnull(pnode) then
    return false
  end
  if node:isVisible() == false then
    return true
  end
  while node:getParent() do
    if node:getParent():isVisible() == false then
      return true
    end
    node = node:getParent()
  end
  return false
end

function chatMedal:touch(event, x, y)
  if event == "began" then
    for i = 1, #self.medalList do
      local info = self.medalList[i]
      if ed.containsPoint(info.icon, x, y) then
        local title = info.title
        ed.TitleMgr.getInstance():createTitlePromptCard(x, y, title)
      end
    end
    px = x
    py = y
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), ccp(px or 0, py or 0))
    if 20 < dis then
      ed.TitleMgr.getInstance():destroyTitlePromptCard()
    end
  elseif event == "ended" then
    ed.TitleMgr.getInstance():destroyTitlePromptCard()
    isPress = false
    index = nil
    px = nil
    py = nil
  end
end
