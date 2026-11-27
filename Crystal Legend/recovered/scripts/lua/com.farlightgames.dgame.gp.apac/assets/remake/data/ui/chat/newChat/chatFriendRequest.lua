local base = ed.ui.popwindow
local chatFriendRequest = newclass(base.mt)
chatFriendRequest.__index = chatFriendRequest
ed.ui.chatFriendRequest = chatFriendRequest
local chatFriendRequestSpace = {}

function chatFriendRequest:onDestory()
  if self.callback then
    self.callback()
  end
  CloseScope(chatFriendRequestSpace)
  self:destroy({skipAnim = false})
end

function chatFriendRequest.create()
  local self = base.create("chatFriendRequest")
  setmetatable(self, chatFriendRequest.mt)
  self.server_type = {
    [1] = {key = "ios"},
    [2] = {key = "ios_pb"},
    [3] = {key = "android"},
    [4] = {key = "qihoo360"},
    [5] = {key = "longtu"}
  }
  self:initUI()
  self:registerBtnHandler()
  self:popWindow()
  self:show({skipAnim = false})
  return self
end

function chatFriendRequest:initUI()
  local layer, ui = ed.editorui(ed.uieditor.FriendRequest)
  self.key = "ios"
  self.winUi = ui
  self.container:addChild(layer)
  self:createlayerList()
  self:creatrEditBox()
  self:refreshServerBtnState()
  ListenEvent("SearchFriendsEvent", function(data)
    self:searchFriendsHandler(data)
  end, chatFriendRequestSpace)
end

function chatFriendRequest:refreshServerBtnState()
  local ui = self.winUi
  for i, v in ipairs(self.server_type) do
    local btn_str = "btn_" .. v.key
    local button = ui[btn_str]
    if v.key == self.key then
      button:setVisible(true)
    else
      button:setVisible(false)
    end
  end
end

function chatFriendRequest:createlayerList()
  local w, h = self.winUi.layer_list:getContentSize().width, self.winUi.layer_list:getContentSize().height
  local info = {
    container = self.winUi.layer_list,
    cliprect = CCRectMake(1, 1, w, h),
    noshade = false,
    zorder = 1
  }
  local draglist = ed.draglist.create(info)
  self.draglist_info = info
  self.draglist = draglist
end

function chatFriendRequest:creatrEditBox()
  local info = {
    config = {
      editSize = self.winUi.img_input_bg_1:getContentSize(),
      maxLength = resource_config.chat_text_len or 55,
      fontColor = ccc3(0, 0, 0),
      fontSize = 16,
      position = ccp(10, 0)
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T("\232\175\183\232\190\147\229\133\165\231\142\169\229\174\182ID\230\149\176\229\173\151"))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  self.winUi.img_input_bg_1:addChild(edit_box.edit)
  self.edit_box_uid = edit_box
  info = {
    config = {
      editSize = self.winUi.img_input_bg:getContentSize(),
      maxLength = resource_config.chat_text_len or 55,
      fontColor = ccc3(0, 0, 0),
      fontSize = 16,
      position = ccp(10, 0)
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T("\232\175\183\232\190\147\229\133\165\229\164\167\229\140\186ID\230\149\176\229\173\151"))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(0, 0))
  self.winUi.img_input_bg:addChild(edit_box.edit)
  self.edit_box_sid = edit_box
end

function chatFriendRequest:registerBtnHandler()
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
    button = ui.btn_search,
    press = ui.btn_search_press,
    key = "btn_search",
    clickHandler = function()
      self:onClickSearch()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = ui.btn_server,
    press = ui.btn_server_press,
    key = "btn_server",
    clickHandler = function()
      self:onClickSwitchServer()
    end,
    force = true
  })
  self:btRegisterHandler({
    handler = self:gettouchHandler()
  })
  for i, v in ipairs(self.server_type) do
    local btn_str = "btn_" .. v.key
    self:btRegisterButtonClick({
      button = ui[btn_str],
      press = ui[btn_str .. "_press"],
      key = btn_str,
      clickHandler = function()
        self:onClickSwitchServer()
      end,
      force = true
    })
  end
end

function chatFriendRequest:gettouchHandler()
  local listHandler = self.draglist:getListLayerTouchHandler()
  
  function handler(event, x, y)
    listHandler(event, x, y)
    self.edit_box_uid:touch(event, x, y)
    self.edit_box_sid:touch(event, x, y)
  end
  
  return handler
end

function chatFriendRequest:onClickSearch()
  local friendID = self.edit_box_uid:getString()
  if friendID == nil or friendID == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\231\142\169\229\174\182ID"))
    return
  end
  friendID = tonumber(friendID)
  if friendID == nil or friendID == 0 then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\231\142\169\229\174\182ID"))
    return
  end
  local sid = self.edit_box_sid:getString()
  if sid == nil or sid == "" then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\231\142\169\229\174\182\229\164\167\229\140\186"))
    return
  end
  sid = tonumber(sid)
  if sid == nil or sid == 0 then
    ed.showToast(T("\232\175\183\232\190\147\229\133\165\230\173\163\231\161\174\231\154\132\231\142\169\229\174\182\229\164\167\229\140\186"))
    return
  end
  ed.chatNetDataMrg:sendSearchFriends(self.key, sid, friendID)
end

function chatFriendRequest:searchFriendsHandler(data)
  if not data then
    self.winUi.label_none_result:setVisible(true)
    self.winUi.label_result:setVisible(false)
    return
  end
  self.winUi.label_none_result:setVisible(false)
  self.winUi.label_result:setVisible(true)
  local friendData = {}
  friendData.roleId = data._role_id
  friendData.summary = data._user_summary
  self:createFriendItem({friendData})
end

function chatFriendRequest:onClickSwitchServer()
  ed.ui.chatServerSelectList.create({
    callback = function(key)
      self:refreshServerInfo(key)
    end
  })
end

function chatFriendRequest:createFriendItem(datas)
  datas = datas or {}
  self.friendlistData = {}
  local height = self.winUi.layer_list:getContentSize().height
  local curHeight = 10
  for i, data in ipairs(datas) do
    local ui = {}
    local sp = CCSprite:create()
    ed.editorui(ed.uieditor.findFriendItem, {container = sp, ui = ui})
    local itemheight = ui.img_friend_bg:getContentSize().height
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
    ui.img_friend_bg:addChild(head)
    curHeight = curHeight + itemheight + 4
    self:registerFriendBtnHandler(ui, data, i)
    self.draglist:addItem(sp)
    local info = {
      itemNode = sp,
      ui = ui,
      extraData = data
    }
    table.insert(self.friendlistData, info)
  end
  self.draglist:initListHeight(curHeight)
end

function chatFriendRequest:registerFriendBtnHandler(ui1, data1, index)
  local ui = ui1
  local data = data1
  self:btRegisterButtonClick({
    button = ui.btn_invite,
    press = ui.btn_invite_press,
    key = "btn_invite" .. index,
    clickHandler = function()
      ui.btn_invite:setVisible(false)
      ui.btn_invite_already:setVisible(true)
      ed.ui.chat.sendAddFriendLink(data.roleId)
    end,
    force = true
  })
end

function chatFriendRequest:refreshServerInfo(key)
  self.key = key
  self:refreshServerBtnState()
end
