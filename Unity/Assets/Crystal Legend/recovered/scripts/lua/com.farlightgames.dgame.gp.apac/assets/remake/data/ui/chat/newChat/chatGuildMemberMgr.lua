local chatGuildMemberMgr = {}
ed.ui.chatGuildMemberMgr = chatGuildMemberMgr
chatGuildMemberMgr.__index = chatGuildMemberMgr
local chatGuildMgrSpace = {}

function chatGuildMemberMgr.create(params)
  local self = {}
  setmetatable(self, chatGuildMemberMgr)
  self.parentLogic = params.parentLogic
  self.ui = self.parentLogic.ui
  self.isTouch = false
  self.params = params
  self:init()
  return self
end

function chatGuildMemberMgr:init()
  self:createListView()
end

function chatGuildMemberMgr:setHide(bool)
  self.ui.guild_bg:setVisible(not bool)
  self.isTouch = not bool
end

function chatGuildMemberMgr:createListView()
  local w, h = self.ui.guild_list_layer:getContentSize().width, self.ui.guild_list_layer:getContentSize().height
  self.listView = ed.ui.chatListView.new()
  self.listView:setPanelLayer(self.ui.guild_list_layer)
  self.listView:initParem({
    base = {
      colNum = 1,
      itemWidthInner = 3,
      layoutMode = "up",
      maxItem = 53,
      heightInner = 3,
      initHeight = 0,
      initWidth = 0,
      container = self.ui.guild_list_layer,
      cliprect = CCRectMake(1, 1, w, h),
      noshade = true,
      zorder = 1,
      selfDealMessage = true
    }
  })
end

function chatGuildMemberMgr:refreshGuildData()
  local num = ed.chatNetDataMrg.contactData.guild.num
  local data = ed.chatNetDataMrg.contactData.guild.data
  self.listView:clear()
  for k, info in pairs(data) do
    self:addContact(info)
  end
  self:refreshGuildOnlineState()
  self:refreshGuildOnlineLable()
end

function chatGuildMemberMgr:refreshGuildOnlineState()
  local function fun(a, b)
    local a_data = a.extraData
    
    local b_data = b.extraData
    if a_data.isOnline < b_data.isOnline then
      return true
    end
    return false
  end
  
  self.listView:sortFormFun(fun)
end

function chatGuildMemberMgr:refreshGuildOnlineLable()
  local total_num = #self.listView:getALLListData()
  local online_num = 0
  local objs = self.listView:getALLListData() or {}
  for _, itemData in ipairs(objs) do
    if itemData.extraData.isOnline == 1 then
      online_num = online_num + 1
    end
  end
  self.ui.lable_guild_num:setString(T("%d/%d", online_num, total_num))
end

function chatGuildMemberMgr:addContact(data)
  local objs = self.listView:getALLListData() or {}
  local item, info
  for _, itemData in ipairs(objs) do
    if itemData.extraData.uid == data.uid and itemData.extraData.sid == data.sid then
      item = itemData
      info = data
      break
    end
  end
  if item then
    local ui = item.controllers
    ui.lable_name:setString(info.summary._name)
    if item.extraData.isOnline ~= info.isOnline then
      item.extraData.isOnline = info.isOnline
      self:setHeadOnlineState(ui, item.extraData.isOnline)
    end
  else
    self:createItemUI(data)
  end
end

function chatGuildMemberMgr:createItemUI(data)
  local sp = CCSprite:create()
  local ui = {}
  ed.editorui(ed.uieditor.chatPlayerHeadItem, {container = sp, ui = ui})
  ui.redPoint:setVisible(false)
  local extraData = data
  local width, height = ui.head_bg:getContentSize().width, ui.head_bg:getContentSize().height
  local params = {width = width, height = height}
  self:createHeadIcon(ui, data)
  self.listView:addItem(sp, extraData, params, ui)
end

function chatGuildMemberMgr:createHeadIcon(ui, data)
  local speakerSummary = data.summary
  local param = {
    id = speakerSummary._avatar
  }
  local headIconNode, headIcon = ed.getWholeHeadIcon(param)
  headIconNode:setScale(0.5)
  headIconNode:setPosition(ccp(22, 23.5))
  ui.head_bg:addChild(headIconNode, 10)
  ui.lable_name:setString(speakerSummary._name)
  ui.headIconNode = headIconNode
  ui.headIcon = headIcon
  self:setHeadOnlineState(ui, data.isOnline)
end

function chatGuildMemberMgr:setHeadOnlineState(ui, onlineState)
  local headIcon = ui.headIcon
  if not headIcon then
    return
  end
  if onlineState == 1 then
    ed.chatUtil:resetAllNodeStone(headIcon)
  else
    ed.chatUtil:setAllNodeStone(headIcon)
  end
end

function chatGuildMemberMgr:touch(event, x, y)
  if not self.ui.guild_bg:isVisible() then
    return
  end
  if not ed.containsPoint(self.ui.guild_list_layer, x, y) and (event == "began" or event == "moved") then
    return
  end
  xpcall(function()
    self.listView:touch(event, x, y)
    self:touchObjs(event, x, y)
  end, EDDebug)
end

function chatGuildMemberMgr:touchObjs(event, x, y)
  if event == "began" then
    self.touchPos = ccp(x, y)
  elseif event == "ended" and self.touchPos then
    local dis = math.abs(self.touchPos.y - y)
    if 10 < dis then
      return
    end
  end
  local objs = self.listView:getALLListData() or {}
  for _, itemData in ipairs(objs) do
    local ui = itemData.controllers
    local headIcon = itemData.controllers.head_bg
    if event == "began" then
      if ed.containsPoint(headIcon, x, y) then
        self.touchItemData = itemData
        return
      end
    elseif event == "ended" and self.touchItemData then
      local headIcon = self.touchItemData.controllers.head_bg
      if ed.containsPoint(headIcon, x, y) then
        self:selectContactObj(self.touchItemData)
        self.touchItemData = nil
      end
    end
  end
  if event == "ended" then
    self.touchItemData = nil
  end
end

function chatGuildMemberMgr:selectContactObj(itemData)
  local data = itemData.extraData
  if ed.getRoleId() ~= data.roleId then
    ed.PlayerInfoNetwork:requestHomePage(data.roleId)
  else
    ed.PlayerInfoNetwork:openPanel()
  end
end
