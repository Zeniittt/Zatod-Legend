local base = ed.ui.popwindow
local arenaCompetitionMemberWin = newclass(base.mt)
ed.ui.arenaCompetitionMemberWin = arenaCompetitionMemberWin
local MemberJobSortFlag = {
  chairman = 1,
  elder = 2,
  member = 3
}

function arenaCompetitionMemberWin.create(data)
  local self = base.create("arenaCompetitionMemberWin")
  setmetatable(self, arenaCompetitionMemberWin.mt)
  self:initAppearence()
  self:registerTouchHandler()
  self:refreshMemberList(data)
  return self
end

function arenaCompetitionMemberWin:initAppearence()
  ed.editorui(ed.uieditor.activity_arena_competition_member_win, {
    container = self.container,
    ui = self.ui
  })
end

function arenaCompetitionMemberWin:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.memberUIList or {}) do
      if ed.containsPoint(v.headIcon, x, y) then
        v.headIcon:setScale(0.42)
        
        return v
      end
    end
    return nil
  end
  
  return handler
end

function arenaCompetitionMemberWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.headIcon, x, y) and nil ~= v.data then
      ed.UITool.openView("playerInfoPanel", v.data._summary._role_id)
    end
  end
  
  return handler
end

function arenaCompetitionMemberWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.headIcon:setScale(0.45)
  end
  
  return handler
end

function arenaCompetitionMemberWin:createTitleItem()
  local container, ui = ed.editorui(ed.uieditor.activity_arena_competition_member_title)
  ed.setLabelStroke(ui.label_member_des, ed.toccc3(1577484), 1)
  ed.setLabelStroke(ui.label_old_score_des, ed.toccc3(1577484), 1)
  ed.setLabelStroke(ui.label_change_score_des, ed.toccc3(1577484), 1)
  return container, ui
end

function arenaCompetitionMemberWin:createMemberItem(data)
  local container, ui = ed.editorui(ed.uieditor.activity_arena_competition_member_item)
  ed.setLabelStroke(ui.label_change_score_val, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_total_score_val, ed.toccc3(2233605), 1)
  ed.setLabelStroke(ui.label_player_name, ed.toccc3(2233605), 1)
  local isMe = data._summary._role_id == ed.getRoleId()
  local nameColor = isMe and ed.toccc3(8319313) or ed.toccc3(16776423)
  ed.setLabelColor(ui.label_player_name, nameColor)
  ed.setLabelColor(ui.label_change_score_val, nameColor)
  ed.setLabelColor(ui.label_total_score_val, nameColor)
  ed.setLabelString(ui.label_change_score_val, data._change_score)
  ed.setLabelString(ui.label_total_score_val, data._score)
  local summary = data._summary
  ed.setLabelString(ui.label_player_name, summary._name)
  local head, headIcon = ed.getWholeHeadIcon({
    id = summary._avatar,
    scale = 0.45
  })
  ui.headIcon = headIcon
  ed.UITool.replaceUI(ui, "bg", "head_icon", head)
  if data._job == "member" then
    ed.setString(ui.label_job, "")
    ui.label_player_name:setPositionY((ui.label_player_name:getPositionY() + ui.label_job:getPositionY()) * 0.5)
  elseif data._job == "chairman" then
    ed.setString(ui.label_job, T("\228\188\154\233\149\191"))
    ed.setLabelColor(ui.label_job, ed.toccc3(16766846))
    ed.setLabelStroke(ui.label_job, ed.toccc3(2299397), 1)
  elseif data._job == "elder" then
    ed.setString(ui.label_job, T("\233\149\191\232\128\129"))
    ed.setLabelColor(ui.label_job, ed.toccc3(13534950))
    ed.setLabelStroke(ui.label_job, ed.toccc3(3476530), 1)
  end
  ui.data = data
  return container, ui
end

function arenaCompetitionMemberWin:refreshMemberList(data)
  self.memberUIList = {}
  local panelSize = self.ui.panel_list:getContentSize()
  local draglist = ed.UITool.createDraglist(self.ui.panel_list, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -300,
    bar = {
      bglen = panelSize.height,
      bgpos = ccp(panelSize.width + 5, panelSize.height / 2),
      barres = "UI/alpha/1080P/hades/hades_main_slide.png",
      bgres = "UI/alpha/1080P/hades/hades_main_slide_bg.png",
      alwaysShow = true
    }
  })
  local totalHeight = 10
  local titleContainer, titleUI = self:createTitleItem()
  draglist:addItem(titleContainer)
  local itemHeight = titleUI.bg:getContentSize().height
  titleContainer:setPosition(panelSize.width * 0.5, panelSize.height - totalHeight - itemHeight * 0.5)
  totalHeight = totalHeight + itemHeight
  local infos = data._user_infos or {}
  if 1 < #infos then
    table.sort(infos, function(a, b)
      local aFlag = MemberJobSortFlag[a._job or "member"] or 4
      local bFlag = MemberJobSortFlag[b._job or "member"] or 4
      return a._score > b._score or a._score == b._score and aFlag < bFlag
    end)
  end
  for i, v in ipairs(infos) do
    local memberContainer, memberUI = self:createMemberItem(v)
    draglist:addItem(memberContainer)
    itemHeight = memberUI.bg:getContentSize().height
    memberContainer:setPosition(panelSize.width * 0.5, panelSize.height - totalHeight - itemHeight * 0.5)
    totalHeight = totalHeight + itemHeight
    table.insert(self.memberUIList, memberUI)
  end
  totalHeight = totalHeight + 10
  draglist:initListHeight(totalHeight)
  self.refreshCliprectConfig = {draglist = draglist}
end

function arenaCompetitionMemberWin:registerTouchHandler()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end
