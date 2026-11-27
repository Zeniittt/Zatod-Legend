module("ed", package.seeall)
GPShareTaskPanel = {}
GPShareTaskPanel.__index = GPShareTaskPanel
local shareScope = {}

function GPShareTaskPanel.Create(members, callback, type)
  local obj = {}
  setmetatable(obj, GPShareTaskPanel)
  obj:initWindow(members, callback, type)
  return obj
end

function GPShareTaskPanel:initWindow(members, callback, type)
  local window = ed.openui("sharetaskpanel")
  self.window = window
  self.callback = callback
  self.members = members or {}
  self:sortMembers()
  self.task_ui = {}
  self.task_check = {}
  self:initBtnTouch()
  self:initDragList()
  self:initDragListTouch()
  if type == "friend" then
    local lable = self.window:getCompoment("lb_choose_name")
    if lable then
      lable:setString("\230\183\187\229\138\160\230\156\172\230\156\141\229\165\189\229\143\139")
    end
  end
end

function GPShareTaskPanel:initBtnTouch()
  local window = self.window
  window:registerBtn("btn_ok", self:onClickOk())
  window:registerBtn("btn_cancel", self:onClickCancel())
  window:setVisible("btn_ok", false)
end

function GPShareTaskPanel:initDragList()
  local window = self.window
  window:registerDraglist("layer_draglist", {noshade = true, usebar = true})
  self.task_ui[0] = window.ui
  for idx, member in pairs(self.members) do
    self:addItemDragList(idx, member)
  end
  self:setAllChecked(false)
end

function GPShareTaskPanel:addItemDragList(idx, member)
  local window = self.window
  local container, ui = ed.editorui(ed.uieditor.sharetaskitem)
  self.task_ui[idx] = ui
  window:addDraglistItem(container, {
    offsetY = 2,
    size = ui.choose_item_bg:getContentSize()
  })
  self:initListItem(idx, member)
end

local online = {
  [0] = T("\231\166\187\231\186\191"),
  [1] = T("\229\156\168\231\186\191")
}
local colour = {
  [0] = ccc3(67, 59, 56),
  [1] = ccc3(70, 114, 0)
}

function GPShareTaskPanel:initListItem(idx, member)
  local ui = self.task_ui[idx]
  local player_summary = self:createPlayerSummary(member._user_summary)
  player_summary:setPosition(ccp(38, 26))
  ui.layer_summary:addChild(player_summary)
  ui.lb_state_des:setString(online[member._is_online])
  ui.lb_state_des:setColor(colour[member._is_online])
end

function GPShareTaskPanel:initDragListTouch()
  local window = self.window
  local info = window.draglist_info
  for idx, ui in pairs(self.task_ui) do
    window:registerCustomTouchBtn({
      button = ui.img_choose_bg,
      pressScale = 0.9,
      key = "check_" .. idx,
      cliprect = idx ~= 0 and info.cliprect,
      clickHandler = function()
        self:onClickChecked(idx)
      end,
      force = true
    })
  end
end

function GPShareTaskPanel:createPlayerSummary(summary)
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.7,
    name = summary._name,
    babelLevel = summary._babel_level,
    vip = summary._vip > 0,
    config = {levelposition = 12, nameposition = 40}
  }
  if summary._medal then
    param.medal = summary._medal
  end
  local player_summary = ed.getWholeHeadIcon(param)
  return player_summary
end

function GPShareTaskPanel:onClickChecked(idx)
  local bCheck = self.task_check[idx]
  if idx == 0 then
    self:setAllChecked(not bCheck)
  else
    self:setChecked(idx, not bCheck)
    local result = self:isAllChecked()
    self:setChecked(0, result)
  end
  local result = self:isAllNotChecked()
  self.window:setVisible("btn_ok", not result)
end

function GPShareTaskPanel:setChecked(idx, bChecked)
  local ui = self.task_ui[idx]
  if not ui then
    return
  end
  ui.img_choose_check:setVisible(bChecked)
  self.task_check[idx] = bChecked
end

function GPShareTaskPanel:setAllChecked(bChecked)
  for idx, _ in pairs(self.task_ui) do
    self:setChecked(idx, bChecked)
  end
end

function GPShareTaskPanel:isAllChecked()
  local result = true
  for idx, bChecked in pairs(self.task_check) do
    if idx ~= 0 and not bChecked then
      return false
    end
  end
  return result
end

function GPShareTaskPanel:isAllNotChecked()
  local result = true
  for idx, bChecked in pairs(self.task_check) do
    if idx ~= 0 and bChecked then
      return false
    end
  end
  return result
end

function GPShareTaskPanel:getAllCheckedId()
  local list = {}
  for idx, bChecked in pairs(self.task_check) do
    if idx ~= 0 and bChecked then
      table.insert(list, self.members[idx]._uid)
    end
  end
  return list
end

function GPShareTaskPanel:sortMembers()
  local function compaux_normal(summary_a, summary_b)
    local a, b = summary_a, summary_b
    
    if a._is_online == 1 and b._is_online == 0 then
      return true
    elseif a._is_online == 0 and b._is_online == 1 then
      return false
    end
    return a._user_summary._level > b._user_summary._level
  end
  
  local summary = {}
  local u_id = ed.getUserid()
  for _, r_summary in pairs(self.members) do
    if u_id ~= r_summary._uid then
      summary[#summary + 1] = r_summary
    end
  end
  self.members = summary
  table.sort(summary, compaux_normal)
end

function GPShareTaskPanel:onClickOk()
  local function handler()
    if self.callback then
      local list = self:getAllCheckedId()
      
      self.callback(list)
    end
    self:destroy()
  end
  
  return handler
end

function GPShareTaskPanel:onClickCancel()
  local function handler()
    self:destroy()
  end
  
  return handler
end

function GPShareTaskPanel:destroy()
  self.window:close()
  CloseScope(shareScope)
end
