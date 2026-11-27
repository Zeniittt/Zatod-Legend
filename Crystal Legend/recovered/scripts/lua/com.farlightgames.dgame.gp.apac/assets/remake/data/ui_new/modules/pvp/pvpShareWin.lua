local base = ed.ui.popwindow
local class = newclass(base.mt)
class.__index = class
ed.ui.pvpShareWin = class
local TYPE_FRIEND = "friend"
local TYPE_GUILD = "guild"
ed.UITool.registViewOpenFunc("pvpShareWin", function(param)
  local type = param.type or TYPE_FRIEND
  if type == TYPE_FRIEND then
    function ed.netreply.getAllFriendsHandler(data)
      if not data or #data < 1 then
        ed.showToast(T("\230\154\130\230\151\160\229\165\189\229\143\139"))
        
        return
      end
      local info = {}
      for i, v in ipairs(data) do
        if v._user_summary._role_id ~= ed.getRoleId() then
          table.insert(info, {
            userSummary = v._user_summary,
            isOnline = v._is_online,
            svrId = v._svr_id,
            serverName = v._server_name
          })
        end
      end
      if #info < 1 then
        ed.showToast(T("\230\154\130\230\151\160\229\144\140\230\156\141\229\165\189\229\143\139"))
        return
      end
      class.create({playerInfoList = info, type = "friend"}):popWindow()
    end
    
    ed.chatNetDataMrg:sendGetAllFriends()
  elseif type == TYPE_GUILD then
    if ed.player:getGuildId() == 0 then
      ed.showToast(T("\232\175\183\229\133\136\229\138\160\229\133\165\228\184\128\228\184\170\229\133\172\228\188\154"))
      return
    end
    local msg = ed.upmsg.query_guild_members()
    ed.send(msg, "query_guild_members")
    ListenEventOnce("pvpGuildMembers", function(data)
      if data._members then
        local info = {}
        for i, v in ipairs(data._members) do
          if v._user_summary._role_id ~= ed.getRoleId() then
            table.insert(info, {
              userSummary = v._user_summary,
              isOnline = v._is_online
            })
          end
        end
        if #info < 1 then
          ed.showToast(T("\229\133\172\228\188\154\230\154\130\230\151\160\229\133\182\228\187\150\230\136\144\229\145\152"))
          return
        end
        class.create({playerInfoList = info, type = "guild"}):popWindow()
      end
    end)
  end
end)

function class.create(param)
  local self = base.create("pvpShareWin")
  setmetatable(self, class.mt)
  param = param or {}
  self.param = param
  self.type = param.type
  self.playerInfoList = param.playerInfoList
  self.destroyCallback = param.destroyCallback
  self.isSelectAll = false
  self.selectRoleIdList = {}
  self:initUI()
  self:addEventListener()
  self:refreshUI()
  self:show({skipAnim = false})
  return self
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.shareSelectWin)
  self.ui = ui
  self.container:addChild(container)
  if self.type == TYPE_FRIEND then
    self.ui.select_all_item:setVisible(false)
    local oldSize = self.ui.panel_list:getContentSize()
    self.ui.panel_list:setContentSize(CCSizeMake(oldSize.width, oldSize.height + self.ui.select_all_item:getContentSize().height))
  else
    self.ui.select_all_item:setVisible(true)
  end
  self:initTableView()
  local title = ""
  local type = ""
  if self.type == TYPE_FRIEND then
    title = T("\230\156\172\230\156\141\229\165\189\229\143\139\229\136\135\231\163\139")
    type = T("\229\133\168\233\128\137\229\165\189\229\143\139")
  elseif self.type == TYPE_GUILD then
    title = T("\229\133\172\228\188\154\230\136\144\229\145\152\229\136\135\231\163\139")
    type = T("\229\133\168\233\128\137\229\133\172\228\188\154\230\136\144\229\145\152")
  end
  self.ui.label_title:setString(title)
  ed.setLabelString(ui.label_type, type)
  ed.setLabelColor(ui.label_type, ed.toccc3(16776423))
  ed.setLabelStroke(ui.label_type, ed.toccc3(5586979), 1)
  ed.left2(ui.image_title_left, ui.label_title, 5)
  ed.right2(ui.image_title_right, ui.label_title, 5)
  ed.right2(ui.label_select_count, ui.label_1, 2)
end

function class:initTableView()
  local delegate = {
    numberOfCells = function()
      return #self.playerInfoList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(456, 66)
    end,
    createCell = function(index)
      local playerInfo = self.playerInfoList[index]
      local node, ui = self:createSelectPlayerItem(playerInfo)
      return node, {playerInfo = playerInfo, ui = ui}
    end,
    doClickIn = function(cell, x, y)
      local param = cell.data
      local ui = param.ui
      local roldId = param.playerInfo.userSummary._role_id
      if ed.isElementInTable(roldId, self.selectRoleIdList) then
        ed.removeElementFromTable(self.selectRoleIdList, roldId)
      else
        table.insert(self.selectRoleIdList, roldId)
      end
      self:refreshUI()
    end,
    doPressIn = function(cell, x, y)
      local param = cell.data
      local ui = param.ui
      local playerInfo = param.playerInfo
    end,
    cancelPressIn = function(cell)
      if self.serverInfoPanel then
        self.serverInfoPanel:destroy()
        self.serverInfoPanel = nil
      end
    end
  }
  local size = self.ui.panel_list:getContentSize()
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    container = self.ui.panel_list,
    touchpriority = -300,
    zorder = 1,
    dragMode = 1,
    noshade = true,
    padding = {width = 0, height = 3}
  }
  self.tbView = Tableview.create(param)
end

function class:refreshUI()
  ed.setLabelString(self.ui.label_select_count, string.format("%s/%s", #self.selectRoleIdList, #self.playerInfoList))
  local posX, posY = self.tbView:getListPos()
  self.tbView:reloadData()
  self.tbView:setListPos(ccp(posX, posY))
  self.isSelectAll = #self.selectRoleIdList == #self.playerInfoList
  self.ui.image_select_all:setVisible(self.isSelectAll)
end

function class:clickSelectAll()
  self.isSelectAll = not self.isSelectAll
  if self.isSelectAll then
    self.selectRoleIdList = {}
    for index, playerInfo in ipairs(self.playerInfoList or {}) do
      local roleId = playerInfo.userSummary._role_id
      table.insert(self.selectRoleIdList, roleId)
    end
  else
    self.selectRoleIdList = {}
  end
  self:refreshUI()
end

function class:createSelectPlayerItem(playerInfo)
  local container, ui = ed.editorui(ed.uieditor.shareSelectPlayer)
  container:setContentSize(ui.image_bg:getContentSize())
  local userSummary = playerInfo.userSummary
  local isOnline = playerInfo.isOnline
  local svrId = playerInfo.svrId
  local headParam = {
    id = userSummary._avatar,
    scale = 0.6
  }
  local head = ed.getWholeHeadIcon(headParam)
  ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  ed.setLabelString(ui.label_level, userSummary._level)
  ed.setLabelColor(ui.label_level, ed.toccc3(16506996))
  ed.setLabelStroke(ui.label_level, ccc3(43, 28, 8), 1)
  ed.setLabelString(ui.label_name, userSummary._name)
  ed.setLabelColor(ui.label_name, ccc3(255, 252, 231))
  ed.setLabelStroke(ui.label_name, ed.toccc3(5586983), 1)
  if isOnline == 1 then
    ed.setLabelString(ui.label_state, T("\229\156\168\231\186\191"))
    ed.setLabelColor(ui.label_state, ed.toccc3(8972620))
  else
    ed.setLabelString(ui.label_state, T("\231\166\187\231\186\191"))
    ed.setLabelColor(ui.label_state, ed.toccc3(7423835))
  end
  if svrId and svrId ~= tonumber(game_server_id) then
    ui.label_svr_name:setVisible(true)
    ed.setLabelString(ui.label_svr_name, playerInfo.serverName or "")
    ed.setLabelStroke(ui.label_svr_name, ed.toccc3(2565412), 1)
  else
    ui.label_svr_name:setVisible(false)
  end
  local isSelected = ed.isElementInTable(userSummary._role_id, self.selectRoleIdList)
  ui.image_select:setVisible(isSelected)
  return container, ui
end

function class:beginShareBattle()
  if #self.selectRoleIdList <= 0 then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\231\142\169\229\174\182"))
    return
  end
  ed.pvpManager:setLeftShareTimes(ed.pvpManager.leftShareCount - 1)
  local curDefGs = ed.pvpManager.gs
  local accessory = ed.upmsg.chat_acc()
  accessory._type = "ladder_fight"
  ed.pvpNetwork:sendLadderFight(T("<text|chat_content|\233\130\128\232\175\183\229\136\135\231\163\139\239\188\154><link|ladder_fight|><text|chat_content|\230\136\152\229\138\155:%d>", curDefGs), 2, accessory, "personal_channel", self.selectRoleIdList)
  ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
  self:destroy()
end

function class:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_comfirm,
    press = self.ui.btn_comfirm_press,
    pressScale = 1.15,
    normalScale = 1.2,
    key = "btn_comfirm",
    clickHandler = function()
      self:beginShareBattle()
    end,
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterButtonClick({
    button = self.ui.select_all_item,
    press = self.ui.select_all_item_press,
    key = "btn_select_all",
    clickHandler = function()
      self:clickSelectAll()
    end,
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    press = self.ui.btn_close_press,
    pressScale = 0.75,
    normalScale = 0.8,
    key = "btn_close",
    clickHandler = function()
      self:destroy()
    end,
    force = true,
    clickInterval = 0.3
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.image_bg, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) and self.clickOutSide then
        self:destroy()
      end
      return false
    end,
    key = "close"
  })
end

function class:destroy()
  if self.destroyCallback then
    self.destroyCallback()
  end
  base.destroy(self, {skipAnim = false})
end
