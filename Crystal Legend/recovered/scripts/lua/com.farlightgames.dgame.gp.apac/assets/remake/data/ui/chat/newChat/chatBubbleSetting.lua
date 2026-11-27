local base = ed.ui.popwindow
local chatBubbleSetting = newclass(base.mt)
chatBubbleSetting.__index = chatBubbleSetting
ed.ui.chatBubbleSetting = chatBubbleSetting

function chatBubbleSetting:onDestory()
  if self.callback then
    self.callback()
  end
  self:destroy({skipAnim = false})
end

function chatBubbleSetting.create()
  local self = base.create("chatBubbleSetting")
  setmetatable(self, chatSetting.mt)
  self:initUI()
  self:registerBtnHandler()
  self:popWindow()
  self:show({skipAnim = false})
  return self
end

function chatBubbleSetting:initUI()
  local layer, ui = ed.editorui(ed.uieditor.chatBubbleSetting)
  self.winUi = ui
  self.container:addChild(layer)
  self:createlayerList()
  self:createBubbleItem()
end

function chatBubbleSetting:createlayerList()
  local w, h = self.winUi.item_list:getContentSize().width, self.winUi.item_list:getContentSize().height
  local info = {
    container = self.winUi.item_list,
    cliprect = CCRectMake(1, 1, w, h),
    noshade = false,
    zorder = 1
  }
  local draglist = ed.draglist.create(info)
  self.draglist_info = info
  self.draglist = draglist
end

function chatBubbleSetting:createBubbleItem()
  local tbl = ed.getDataTable("ChatBubble")
  local info = {}
  for k, v in pairs(table_name) do
    if k ~= "name" then
      table.insert(info, v)
    end
  end
  for i, data in ipairs(info) do
    local res = data["UI Right"]
    local name = data.Name
    local type = data["Requirement Type"]
    local item_id = data["Requirement ID"]
  end
end
