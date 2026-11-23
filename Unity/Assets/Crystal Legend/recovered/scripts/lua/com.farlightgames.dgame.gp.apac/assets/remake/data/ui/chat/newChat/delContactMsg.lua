local base = ed.ui.popwindow
local delContactMsg = newclass(base.mt)
delContactMsg.__index = delContactMsg
ed.ui.delContactMsg = delContactMsg

function delContactMsg:onDestory()
  if self.callback then
    self.callback()
  end
  self:destroy({skipAnim = true})
end

function delContactMsg.create(contactData)
  local self = base.create("delContactMsg")
  setmetatable(self, delContactMsg.mt)
  self.datas = contactData
  self.isAllSelect = false
  self.curSeleteNum = 0
  self.maxSeleteNum = #contactData
  self:initUI()
  self:registerBtnHandler()
  self:popWindow()
  self:show({skipAnim = true})
  return self
end

function delContactMsg:initUI()
  local layer, ui = ed.editorui(ed.uieditor.delMsgLayer)
  self.winUi = ui
  self.container:addChild(layer)
  self:createlayerList()
  self:createItem()
  self:refreshLable()
end

function delContactMsg:createlayerList()
  local w, h = self.winUi.item_list:getContentSize().width, self.winUi.item_list:getContentSize().height
  local info = {
    container = self.winUi.item_list,
    cliprect = CCRectMake(1, 1, w, h),
    noshade = true,
    zorder = 1
  }
  local draglist = ed.draglist.create(info)
  self.draglist_info = info
  self.draglist = draglist
end

function delContactMsg:createItem()
  self.listData = {}
  local height = self.winUi.item_list:getContentSize().height
  local curHeight = 10
  for i, data in ipairs(self.datas) do
    local ui = {}
    local sp = CCSprite:create()
    ed.editorui(ed.uieditor.delMsgItem, {container = sp, ui = ui})
    local itemheight = ui.bg:getContentSize().height
    sp:setPosition(ccp(3, height - curHeight))
    local targetSummary = data.summary
    local param = {
      id = targetSummary._avatar,
      level = targetSummary._level,
      name = targetSummary._name,
      vip = targetSummary._vip > 0,
      scale = 0.8,
      babelLevel = targetSummary._babel_level
    }
    if targetSummary._medal then
      param.medal = targetSummary._medal
    end
    local head = ed.getWholeHeadIcon(param)
    head:setScale(0.85)
    head:setPosition(ccp(30, 38))
    ui.bg:addChild(head)
    local flagIcon
    if ed.friendlist.isInFriendlist(data.roleId) then
      flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Friend.png")
    elseif ed.chatNetDataMrg:isInGuildData(data.roleId) then
      flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Guild.png")
    else
      flagIcon = ed.createSprite("UI/alpha/HVGA/chat/Chat_Player_Stranger.png")
    end
    if flagIcon then
      flagIcon:setPosition(ccp(1, -24))
      flagIcon:setScale(1.2)
      head:addChild(flagIcon)
    end
    ui.btn_check_img:setVisible(false)
    curHeight = curHeight + itemheight + 4
    self.draglist:addItem(sp)
    local info = {
      itemNode = sp,
      ui = ui,
      data = data,
      isSelete = false
    }
    self:registerFriendBtnHandler(ui, info, i)
    table.insert(self.listData, info)
  end
  self.draglist:initListHeight(curHeight)
end

function delContactMsg:registerFriendBtnHandler(ui1, data1, index)
  local ui = ui1
  local data = data1
  self:btRegisterButtonClick({
    button = ui.btn_check,
    pressScale = 0.95,
    key = "btn_check" .. index,
    clickHandler = function()
      self:changMemberSeleteState(data)
    end,
    force = true
  })
end

function delContactMsg:changMemberSeleteState(info, bool)
  local ui = info.ui
  local data = info.data
  local isSelete = info.isSelete
  if isSelete then
    info.isSelete = false
    self.curSeleteNum = self.curSeleteNum - 1
    ui.btn_check_img:setVisible(false)
  else
    info.isSelete = true
    self.curSeleteNum = self.curSeleteNum + 1
    ui.btn_check_img:setVisible(true)
  end
  if not bool then
    self:checkAllMemberSeleteState()
  end
  self:refreshLable()
end

function delContactMsg:checkAllMemberSeleteState()
  if self.curSeleteNum < self.maxSeleteNum then
    self.isSeleteAll = false
    self.winUi.sp_select_icon:setVisible(false)
  else
    self.isSeleteAll = true
    self.winUi.sp_select_icon:setVisible(true)
  end
end

function delContactMsg:registerBtnHandler()
  local ui = self.winUi
  self:btRegisterButtonClick({
    button = ui.btn_close,
    press = ui.btn_close_press,
    key = "close_button",
    clickHandler = function()
      self:onDestory()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = ui.sp_select_bg,
    key = "sp_select_bg",
    clickHandler = function()
      self:onClickAllSelectHandler()
    end,
    force = true,
    clickInterval = 0.6
  })
  self:btRegisterButtonClick({
    button = ui.btn_del,
    press = ui.btn_del_press,
    key = "btn_del",
    clickHandler = function()
      self:onClickDelHandler()
      self:onDestory()
    end,
    force = true,
    clickInterval = 0.6
  })
  self:btRegisterHandler({
    handler = self.draglist:getListLayerTouchHandler()
  })
end

function delContactMsg:onClickAllSelectHandler()
  if self.isSeleteAll then
    self.isSeleteAll = false
    self.winUi.sp_select_icon:setVisible(false)
    self.curSeleteNum = 0
  else
    self.isSeleteAll = true
    self.winUi.sp_select_icon:setVisible(true)
    self.curSeleteNum = self.maxSeleteNum
  end
  local data = self.listData or {}
  for i, v in ipairs(self.listData) do
    v.isSelete = self.isSeleteAll
    v.ui.btn_check_img:setVisible(self.isSeleteAll)
  end
  self:refreshLable()
end

function delContactMsg:onClickDelHandler()
  if self.curSeleteNum <= 0 then
    ed.showToast(T("\230\156\170\233\128\137\230\139\169\232\166\129\229\136\160\233\153\164\231\154\132\230\156\128\232\191\145\229\175\185\232\175\157"))
    return
  end
  local del_data = {}
  local del_msg = {}
  for i, v in ipairs(self.listData) do
    if v.isSelete then
      local data = {}
      local msg = {}
      data.roleId = v.data.roleId
      msg._role_id = v.data.roleId
      table.insert(del_data, data)
      table.insert(del_msg, msg)
    end
  end
  
  function ed.netreply.delContactHandler(data)
    for _, data in ipairs(del_data) do
      local key = ed.chatUtil:getUserKey(data.roleId)
      ed.chatNetWork.chatMessages.personal_channel[key] = nil
      ed.chatNetWork.contactData[key] = nil
    end
    FireEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MEMBER_LIST_REFRESH)
    FireEvent(ed.chatNetWork.EVENT_NAMES.CHAT_MSG_LIST_REFRESH)
    FireEvent(ed.chatNetWork.EVENT_NAMES.NOTICE_CHAT_REDPOINT)
  end
  
  ed.chatNetWork:sendChat("chat_delete_recent", "_chat_delete_recent", {_keys = del_msg})
end

function delContactMsg:refreshLable()
  self.winUi.lable_select_num:setString(string.format("%d/%d", self.curSeleteNum, self.maxSeleteNum))
end
