local base = ed.ui.popwindow
local delChatMemberWin = newclass(base.mt)
ed.ui.delChatMemberWin = delChatMemberWin

function delChatMemberWin.create()
  local self = base.create("delChatMemberWin")
  setmetatable(self, delChatMemberWin.mt)
  self:initData()
  self:initView()
  self:addEventListener()
  return self
end

function delChatMemberWin:onDestory()
  CloseScope(self.eventScope)
  self:destroy()
end

function delChatMemberWin:initData()
  self.eventScope = {}
  self.selectnum = 0
  self.delListHeight = 0
  self.delListCell = {}
end

function delChatMemberWin:initView()
  local container, ui = ed.editorui(ed.uieditor.delChatMemberWin)
  self.ui = ui
  self.container:addChild(container)
  self:initLabel()
  self:createDeleteList()
  self:updateDeleteList()
  self:showSelectedNum()
end

function delChatMemberWin:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.close_btn,
    key = "close_btn",
    clickHandler = function()
      self:onDestory()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.all_select_btn,
    key = "all_select_btn",
    clickHandler = function()
      local visible = self.ui.selected:isVisible()
      self:selectAll(not visible)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.clear_btn,
    key = "clear_btn",
    clickHandler = function()
      self:onClickDelHandler()
      self:onDestory()
    end
  })
end

function delChatMemberWin:initLabel()
  self.ui.all_select_label:setStroke(ccc3(50, 37, 22), 2)
  ed.left2(self.ui.select_label, self.ui.select_num, 2)
end

function delChatMemberWin:createDeleteList()
  local w, h = self.ui.del_list:getContentSize().width, self.ui.del_list:getContentSize().height
  local info = {
    cliprect = CCRectMake(0, 0, w, h),
    container = self.ui.del_list,
    priority = -300,
    noshade = true,
    doPressIn = function(x, y)
      for i, cell in ipairs(self.delListCell) do
        local select_btn = cell.ui.select_btn
        if ed.containsPoint(select_btn, x, y) then
          return i
        end
      end
      return nil
    end,
    doClickIn = function(x, y, i)
      local cell = self.delListCell[i]
      if ed.containsPoint(cell.ui.select_btn, x, y) then
        local visible = cell.ui.selected:isVisible()
        cell.ui.selected:setVisible(not visible)
        self.selectnum = self.selectnum + (visible and -1 or 1)
        self:showSelectedNum()
        self:showAllSelected()
      end
    end
  }
  self.delList = ed.draglist.create(info)
end

function delChatMemberWin:clearDeleteList()
  self.delListHeight = 0
  self.delListCell = {}
  self.delList:clearList()
end

function delChatMemberWin:blackListAddCell(key, member)
  local container = CCNode:create()
  local ui = {}
  ed.editorui(ed.uieditor.delChatMemberCell, {container = container, ui = ui})
  ui.name:setStroke(ccc3(85, 64, 39), 2)
  ui.name:setString(member.data.summary._name)
  ui.level:setString(member.data.summary._level)
  table.insert(self.delListCell, {
    key = key,
    data = member.data,
    ui = ui
  })
  local height = ui.bg:getContentSize().height + 10
  self.delList:addItem(container, ccp(0, self.ui.del_list:getContentSize().height - self.delListHeight))
  return height
end

function delChatMemberWin:updateDeleteList()
  local datas = ed.chatNetWork.contactData
  for k, v in pairs(datas) do
    self.delListHeight = self.delListHeight + self:blackListAddCell(k, v)
  end
  self.delList:initListHeight(self.delListHeight)
end

function delChatMemberWin:showSelectedNum()
  self.ui.select_num:setString(self.selectnum .. "/" .. #self.delListCell)
  ed.left2(self.ui.select_label, self.ui.select_num, 2)
end

function delChatMemberWin:showAllSelected()
  self.ui.selected:setVisible(self.selectnum == #self.delListCell)
end

function delChatMemberWin:selectAll(isall)
  for _, cell in ipairs(self.delListCell) do
    cell.ui.selected:setVisible(isall)
  end
  self.selectnum = isall and #self.delListCell or 0
  self:showSelectedNum()
  self:showAllSelected()
end

function delChatMemberWin:onClickDelHandler()
  if self.selectnum <= 0 then
    ed.showToast(T("\230\156\170\233\128\137\230\139\169\232\166\129\229\136\160\233\153\164\231\154\132\230\156\128\232\191\145\229\175\185\232\175\157"))
    return
  end
  local del_msg = {}
  for i, cell in ipairs(self.delListCell) do
    if cell.ui.selected:isVisible() then
      table.insert(del_msg, cell.data.roleId)
    end
  end
  ed.chatNetWork:setDelMemberMsg(del_msg)
  ed.chatNetWork:sendChat("chat_delete_recent", "_chat_delete_recent", {
    _role_ids = ed.chatNetWork:getDelMemberMsg()
  })
end
