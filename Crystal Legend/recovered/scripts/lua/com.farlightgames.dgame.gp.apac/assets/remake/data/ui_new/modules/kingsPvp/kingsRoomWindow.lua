local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.KingsRoomWindow = class
class.AUDIENCE_MAX_AMOUNT = 6
ed.UITool.registViewOpenFunc("KingsRoomWindow", function(param)
  ed.ui.KingsRoomWindow.create(param):popWindow()
end)

function class.create(param)
  local self = base.create("KingsRoomWindow")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.team = ed.TeamMgr.getInstance():getTeam()
  self.teamId = self.team:getTeamId()
  self:initTeamData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
  self:show()
end

function class:initTeamData()
  self.playerDataBlue = nil
  self.playerDataRed = nil
  self.audienceDataList = {}
  local teamMemberList = self.team:getTeamMembers() or {}
  for index, member in ipairs(teamMemberList) do
    local roomStatus = member._room_status
    if roomStatus == "host" then
      self.playerDataBlue = member
    elseif roomStatus == "guest" then
      self.playerDataRed = member
    else
      table.insert(self.audienceDataList, member)
    end
  end
end

function class:refreshTeamMemberData()
  self.playerDataBlue = nil
  self.playerDataRed = nil
  local oldAudienceDataList = {}
  local newAudienceDataList = {}
  local teamMemberList = self.team:getTeamMembers() or {}
  local deleteAudienceIndex
  for index, member in ipairs(teamMemberList) do
    local isOldAudience = false
    local memberRoomStatus = member._room_status
    for audienceIndex, oldMember in ipairs(self.audienceDataList or {}) do
      if self.team:checkMemberKeyIsEquality(oldMember._user_key, member._user_key) and memberRoomStatus == "audience" then
        isOldAudience = true
        break
      elseif self.team:checkMemberKeyIsEquality(oldMember._user_key, member._user_key) and memberRoomStatus ~= "audience" then
        deleteAudienceIndex = audienceIndex
        break
      end
    end
    if memberRoomStatus == "audience" then
      if isOldAudience then
        table.insert(oldAudienceDataList, member)
      else
        table.insert(newAudienceDataList, member)
      end
    elseif memberRoomStatus == "host" then
      self.playerDataBlue = member
    elseif memberRoomStatus == "guest" then
      self.playerDataRed = member
    end
  end
  table.sort(oldAudienceDataList, ed.cmpSort({
    {
      getValue = function(member)
        for index, oldMember in ipairs(self.audienceDataList or {}) do
          if self.team:checkMemberKeyIsEquality(oldMember._user_key, member._user_key) then
            return index
          end
        end
        return 999
      end
    }
  }))
  if deleteAudienceIndex and deleteAudienceIndex <= #oldAudienceDataList and 0 < #newAudienceDataList then
    local firstNewAudience = table.remove(newAudienceDataList, 1)
    table.insert(oldAudienceDataList, deleteAudienceIndex, firstNewAudience)
  end
  local audienceDataList = {}
  for index, member in ipairs(oldAudienceDataList) do
    table.insert(audienceDataList, member)
  end
  for index, member in ipairs(newAudienceDataList) do
    table.insert(audienceDataList, member)
  end
  self.audienceDataList = audienceDataList
end

function class:initUI()
  local container, ui = ed.editorui(ed.uieditor.kingsRoomWindow)
  self.ui = ui
  self.container:addChild(container)
  self:initLabels()
  self:initTableView()
  self:refreshTeamMember()
  ed.setLabelString(self.ui.label_room_id, self.teamId)
  self.ui.label_room_id:setPositionX(self.ui.label_room_tips:getPositionX() + self.ui.label_room_tips:getContentSize().width)
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4666403), 1)
  ed.setLabelShadow(self.ui.label_copy, ed.toccc3(0), ccp(0, 1))
  ed.setLabelShadow(self.ui.label_start, ed.toccc3(0), ccp(0, 1))
end

function class:refreshTeamMember()
  self:refreshTableView()
  self:refreshPlayerBlue()
  self:refreshPlayerRed()
  self:refreshBtnStart()
end

function class:initTableView()
  local size = self.ui.panel_ob_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return self.AUDIENCE_MAX_AMOUNT
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(330, 85)
    end,
    createCell = function(index)
      local memberData = self.audienceDataList[index]
      local item, ui
      if memberData then
        item, ui = self:createAudienceItem(memberData)
      else
        item, ui = self.createEmptyItem()
      end
      return item, {
        memberData = memberData,
        index = index,
        ui = ui
      }
    end,
    doPressIn = function(cell, x, y)
      local node = cell.node
      local data = cell.data
      local ui = data.ui
      ui.image_bg:setScale(0.95)
    end,
    cancelPressIn = function(cell)
      local node = cell.node
      local data = cell.data
      local ui = data.ui
      ui.image_bg:setScale(1)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      local node = cell.node
      local ui = data.ui
      local index = data.index
      local memberData = data.memberData
      if ed.containsPoint(ui.image_bg, x, y) then
        if memberData then
          if ed.containsPoint(ui.panel_icon, x, y) then
            ed.UITool.openView("playerInfoPanel", memberData._user_summary._role_id)
          else
            self:showMenu(memberData, node, index % 2 == 1 and "left" or "right")
          end
        else
          ed.UITool.openView("kingsPlayerInviteWin", {
            room_id = self.teamId
          })
        end
      end
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_ob_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 2,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:refreshTableView()
  self.tableView:reloadData()
end

function class:showMenu(memberData, referNode, direction)
  if not self.team:isLeader() then
    local memberRoomStatus = memberData._room_status
    if memberRoomStatus == "host" or memberRoomStatus == "guest" then
      ed.showToast(T("\232\175\165\232\186\171\228\187\189\228\184\186\233\128\137\230\137\139"))
    else
      ed.showToast(T("\232\175\165\232\186\171\228\187\189\228\184\186\232\167\130\228\188\151"))
    end
    return
  end
  local menu = ed.ui.KingsRoomMenuWin.create(memberData)
  menu:popWindow()
  ed.layout.relateLayout(referNode, menu.imageBg, {
    left = direction == "left" and 0 or nil,
    right = direction == "right" and referNode:getContentSize().width or nil,
    top = referNode:getContentSize().height
  })
  menu:showOpenAction()
end

function class:refreshPlayerBlue()
  local playerNodeBlue, playerUIBlue
  if self.playerDataBlue then
    playerNodeBlue, playerUIBlue = self:createPlayerItem(self.playerDataBlue)
    self:btRegisterButtonClick({
      button = playerUIBlue.image_bg,
      key = "click_blue",
      clickHandler = function(_, x, y)
        if ed.containsPoint(playerUIBlue.panel_icon, x, y) then
          ed.UITool.openView("playerInfoPanel", self.playerDataBlue._user_summary._role_id)
        else
          self:showMenu(self.playerDataBlue, playerNodeBlue, "left")
        end
      end,
      pressScale = 0.95,
      clickInterval = 0.5,
      force = true
    })
  else
    playerNodeBlue, playerUIBlue = self.createEmptyItem()
    self:btRegisterButtonClick({
      button = playerUIBlue.image_bg,
      key = "click_blue",
      clickHandler = function()
        ed.UITool.openView("kingsPlayerInviteWin", {
          room_id = self.teamId
        })
      end,
      pressScale = 0.95,
      clickInterval = 0.5,
      force = true
    })
  end
  self.playerNodeBlue = playerNodeBlue
  self.ui.panel_player_blue:removeAllChildrenWithCleanup(true)
  self.ui.panel_player_blue:addChild(playerNodeBlue)
  ed.layout.centerInParent(playerNodeBlue)
end

function class:refreshPlayerRed()
  local playerNodeRed, playerUIRed
  if self.playerDataRed then
    playerNodeRed, playerUIRed = self:createPlayerItem(self.playerDataRed)
    self:btRegisterButtonClick({
      button = playerUIRed.image_bg,
      key = "click_red",
      clickHandler = function(_, x, y)
        if ed.containsPoint(playerUIRed.panel_icon, x, y) then
          ed.UITool.openView("playerInfoPanel", self.playerDataRed._user_summary._role_id)
        else
          self:showMenu(self.playerDataRed, playerNodeRed, "right")
        end
      end,
      pressScale = 0.95,
      clickInterval = 0.5,
      force = true
    })
  else
    playerNodeRed, playerUIRed = self:createEmptyItem()
    self:btRegisterButtonClick({
      button = playerUIRed.image_bg,
      key = "click_red",
      clickHandler = function(x, y)
        ed.UITool.openView("kingsPlayerInviteWin", {
          room_id = self.teamId
        })
      end,
      pressScale = 0.95,
      clickInterval = 0.5,
      force = true
    })
  end
  self.playerNodeRed = playerNodeRed
  self.ui.panel_player_red:removeAllChildrenWithCleanup(true)
  self.ui.panel_player_red:addChild(playerNodeRed)
  ed.layout.centerInParent(playerNodeRed)
end

function class:refreshBtnStart()
  local isLeader = self.team:isLeader()
  self.ui.btn_start:setVisible(isLeader)
end

function class:createPlayerItem(memberData)
  local container, ui = ed.editorui(ed.uieditor.kingsRoomPlayerItem)
  container:setContentSize(ui.image_bg:getContentSize())
  ed.layout.centerInParent(ui.image_bg)
  ed.setLabelStroke(ui.label_grade_tips, ed.toccc3(0), 1)
  ed.setLabelStroke(ui.label_grade_name, ed.toccc3(0), 1)
  if memberData._room_status == "host" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/newkingspvp/ob/03_bg.png")
    ed.setTexture(ui.image_grade_bg, "UI/alpha/1080P/newkingspvp/ob/ob_rank_bg_1.png")
  elseif memberData._room_status == "guest" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/newkingspvp/ob/04_bg.png")
    ed.setTexture(ui.image_grade_bg, "UI/alpha/1080P/newkingspvp/ob/ob_rank_bg_2.png")
  elseif memberData._room_status == "audience" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/newkingspvp/ob/05_bg.png")
    ed.setTexture(ui.image_grade_bg, "UI/alpha/1080P/newkingspvp/ob/ob_rank_bg_3.png")
  end
  if self.team:checkMemberIsLeader(memberData) then
    ui.image_owner:setVisible(true)
  else
    ui.image_owner:setVisible(false)
  end
  local userSummary = memberData._user_summary
  local head = ed.getWholeHeadIcon({
    id = userSummary._avatar,
    level = userSummary._level,
    lvoffset = {x = -47, y = -38}
  })
  head:setScale(0.9)
  ui.panel_icon:addChild(head)
  ed.layout.centerInParent(head)
  local nameColor
  if userSummary._role_id == ed.getRoleId() then
    nameColor = "ccc3(112,255,84)"
  else
    nameColor = "ccc3(255,252,231)"
  end
  local name = ed.getPlayerName(userSummary._name, userSummary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = nameColor,
    fontSize = 18
  })
  ui.image_name_bg:addChild(name)
  ed.layout.centerYInParent(name)
  name:setPositionX(38)
  local gradeId = ed.realarena.mgr:GetGradeByScore(memberData._score or 0)
  local kingsGradeCfg = ed.getDataTable("KingsGrade")[gradeId]
  ed.setTexture(ui.image_grade_icon, kingsGradeCfg["Icon Small"], true)
  ed.setLabelString(ui.label_grade_name, kingsGradeCfg.Name)
  return container, ui
end

function class:createAudienceItem(memberData)
  local container = ed.createSprite()
  local _, ui = ed.editorui(ed.uieditor.kingsRoomSpectatorItem, {container = container})
  container:setContentSize(ui.image_bg:getContentSize())
  ed.layout.centerInParent(ui.image_bg)
  ed.setLabelStroke(ui.label_grade_tips, ed.toccc3(0), 1)
  ed.setLabelStroke(ui.label_grade_name, ed.toccc3(0), 1)
  if self.team:checkMemberIsLeader(memberData) then
    ui.image_owner:setVisible(true)
  else
    ui.image_owner:setVisible(false)
  end
  if memberData._room_status == "host" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/newkingspvp/ob/03_bg.png")
    ed.setTexture(ui.image_grade_bg, "UI/alpha/1080P/newkingspvp/ob/ob_rank_bg_1.png")
  elseif memberData._room_status == "guest" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/newkingspvp/ob/04_bg.png")
    ed.setTexture(ui.image_grade_bg, "UI/alpha/1080P/newkingspvp/ob/ob_rank_bg_2.png")
  elseif memberData._room_status == "audience" then
    ed.setTexture(ui.image_bg, "UI/alpha/1080P/newkingspvp/ob/05_bg.png")
    ed.setTexture(ui.image_grade_bg, "UI/alpha/1080P/newkingspvp/ob/ob_rank_bg_3.png")
  end
  local userSummary = memberData._user_summary
  local head = ed.getWholeHeadIcon({
    id = userSummary._avatar,
    level = userSummary._level,
    lvoffset = {x = -47, y = -38}
  })
  head:setScale(0.9)
  ui.panel_icon:addChild(head)
  ed.layout.centerInParent(head)
  local nameColor
  if userSummary._role_id == ed.getRoleId() then
    nameColor = "ccc3(112,255,84)"
  else
    nameColor = "ccc3(255,252,231)"
  end
  local name = ed.getPlayerName(userSummary._name, userSummary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = nameColor,
    fontSize = 18
  })
  ui.image_name_bg:addChild(name)
  ed.layout.centerYInParent(name)
  name:setPositionX(38)
  local gradeId = ed.realarena.mgr:GetGradeByScore(memberData._score or 0)
  local kingsGradeCfg = ed.getDataTable("KingsGrade")[gradeId]
  ed.setTexture(ui.image_grade_icon, kingsGradeCfg["Icon Small"], true)
  ed.setLabelString(ui.label_grade_name, kingsGradeCfg.Name)
  return container, ui
end

function class:createEmptyItem()
  local container = CCSprite:create()
  local _, ui = ed.editorui(ed.uieditor.kingsRoomEmptyItem, {container = container})
  container:setContentSize(ui.image_bg:getContentSize())
  ed.layout.centerInParent(ui.image_bg)
  return container, ui
end

function class:onClickBtnCopy()
  ed.copyString(self.teamId)
end

function class:onClickBtnStart()
  if not self.team:isLeader() then
    ed.showToast(T("\228\189\160\228\184\141\230\152\175\230\136\191\228\184\187"))
    return
  end
  local hostAmount = 0
  local guestAmount = 0
  for index, member in ipairs(self.team:getTeamMembers() or {}) do
    local roomStatus = member._room_status
    if roomStatus == "host" then
      hostAmount = hostAmount + 1
    elseif roomStatus == "guest" then
      guestAmount = guestAmount + 1
    end
  end
  if hostAmount ~= 1 or guestAmount ~= 1 then
    ed.showToast(T("\233\128\137\230\137\139\230\149\176\233\135\143\233\148\153\232\175\175"))
    return
  end
  ed.realarena.network_mgr:RequestTeamStart()
end

function class:onClickBtnClose()
  ed.showConfirmDialog({
    text = T("\229\189\147\229\137\141\230\173\163\229\156\168\231\173\137\229\190\133\231\142\169\229\174\182\239\188\140\230\152\175\229\144\166\231\161\174\229\174\154\233\128\128\229\135\186\239\188\159"),
    leftText = T("\229\143\150\230\182\136"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      ed.TeamNetwork.sendTeamQuit()
      self:destroy()
    end
  })
end

function class:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_copy", function()
    self:onClickBtnCopy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_start", function()
    self:onClickBtnStart()
  end, {normalScale = 0.75, pressScale = 0.7})
  ed.UITool.registerBtn(self, "btn_close", function()
    self:onClickBtnClose()
  end, {normalScale = 0.8, pressScale = 0.75})
end

function class:registerEvents()
  self:listenEvent("TeamMemberChange", function(teamId)
    if self.teamId == teamId then
      self:refreshTeamMemberData()
      self:refreshTeamMember()
    end
  end)
  self:listenEvent("TeamQuit", function(teamId)
    if self.teamId == teamId then
      self:destroy()
    end
  end)
  self:listenEvent("EventTeamNotAlive", function()
    ed.showToast(T("\228\189\160\229\183\178\232\162\171\232\184\162\229\135\186\233\152\159\228\188\141"))
    self:destroy()
  end)
end
