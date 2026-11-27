local base = ed.ui.popwindow
local GuildClashChairSetTeam = newclass(base.mt)
ed.ui.GuildClashChairSetTeam = GuildClashChairSetTeam
local lineName = {
  "top",
  "mid",
  "bottom"
}

function GuildClashChairSetTeam.create()
  local self = base.create("GuildClashChairSetTeam")
  setmetatable(self, GuildClashChairSetTeam.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function GuildClashChairSetTeam:initData()
  self.mgr = ed.GuildClashManager
  self.draglists = {}
  self.opList = {}
  self.listData = {}
  ed.GuildClashNetwork:sendGuildTeam()
end

function GuildClashChairSetTeam:initLabels()
  ed.setLabelStroke(self.ui.name_top, ed.toccc3(3416597), 1)
  ed.setLabelStroke(self.ui.name_mid, ed.toccc3(3416597), 1)
  ed.setLabelStroke(self.ui.name_bottom, ed.toccc3(3416597), 1)
  ed.setLabelStroke(self.ui.team_num_top, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.team_num_mid, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.team_num_bottom, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_none_bottom, ed.toccc3(2103826), 1)
  ed.setLabelStroke(self.ui.label_none_mid, ed.toccc3(2103826), 1)
  ed.setLabelStroke(self.ui.label_none_top, ed.toccc3(2103826), 1)
  self.ui.name_top:limitWidthByScale(80)
  self.ui.name_mid:limitWidthByScale(80)
  self.ui.name_bottom:limitWidthByScale(80)
  self.ui.team_num_top:limitWidthByScale(60)
  self.ui.team_num_mid:limitWidthByScale(60)
  self.ui.team_num_bottom:limitWidthByScale(60)
  self.ui.label_op:limitWidthByScale(110)
end

function GuildClashChairSetTeam:refreshUI()
  self:refreshTeams({
    1,
    2,
    3
  })
  if not tolua.isnull(self.tipNode) then
    self.tipNode:removeFromParentAndCleanup(true)
  end
  local isChairMan = ed.player:getGuildJob() == "chairman" or ed.player:getGuildJob() == "elder"
  local contextStr = T("\233\152\159\228\188\141\229\183\178\233\148\129\229\174\154")
  if isChairMan then
    if self.mgr.stateType ~= "HeadModifyDefender" then
      if ed.isElementInTable(self.mgr.stateType, {
        "MarchBegin",
        "CountClashResult"
      }) then
        contextStr = T("\233\152\159\228\188\141\229\183\178\233\148\129\229\174\154")
      else
        contextStr = string.format(T("<lable color=ccc3(245,236,183)>%s</lable>\229\144\142\229\143\175\232\176\131\230\149\180\230\175\143\228\184\170\233\152\159\228\188\141\230\137\128\229\177\158\229\136\134\232\183\175"), self.mgr:getTimeToChairSetting())
      end
      local autoText = ed.ui.autoText.new()
      autoText:initParam({
        context = contextStr,
        color = ed.toccc3(10720396),
        strokeColor = ed.toccc3(2103826),
        strokeSize = 1,
        fontSize = 22,
        maxWidth = 460
      })
      self.tipNode = autoText.node
      self.ui.ImageView_1482:addChild(autoText.node)
      local curWidth = autoText:getCurContentSize()
      autoText.node:setPosition(ccp(460 - curWidth / 2, 40))
    elseif self.mgr.operateUser then
      local summary = self.mgr.operateUser
      self.ui.layer_tip:setVisible(true)
      self.otherOperaTime = self.mgr.operateTime - ed.getServerTime() + 1800
      local node, headIcon = ed.getWholeHeadIcon({
        id = summary._avatar,
        level = summary._level,
        scale = 0.8,
        lvoffset = {x = -47, y = -30}
      })
      self.ui.headIcon = headIcon
      ed.UITool.replaceUINew(self.ui, "opHead", node)
      ed.UITool.registerBtn(self, "headIcon", function()
        ed.UITool.openView("playerInfoPanel", summary._role_id)
      end)
      ed.setString(self.ui.label_tip, ed.time2dhms(self.otherOperaTime))
      ed.setLabelStroke(self.ui.opName, ed.toccc3(1315346), 1)
      ed.setString(self.ui.opName, string.format(T("%s \232\176\131\230\149\180\228\184\173"), self.mgr.operateUser._name))
      self:listenTimer(Timer:Always(1, "UpdateOtherOperaTime"), function()
        self.otherOperaTime = self.otherOperaTime - 1
        ed.setString(self.ui.label_tip, T("\229\137\169\228\189\153") .. ed.time2dhms(self.otherOperaTime))
        if self.otherOperaTime < 0 then
          CloseTimer("UpdateOtherOperaTime")
          ed.GuildClashNetwork:sendGuildTeam()
          self.ui.layer_tip:setVisible(false)
        end
      end)
    elseif self.isOpera then
    else
      self.ui.btn_op:setVisible(true)
      self.ui.layer_tip:setVisible(false)
    end
  else
    if self.mgr.stateType ~= "HeadModifyDefender" then
      if ed.isElementInTable(self.mgr.stateType, {
        "MarchBegin",
        "CountClashResult"
      }) then
        contextStr = T("\233\152\159\228\188\141\229\183\178\233\148\129\229\174\154")
      else
        contextStr = string.format(T("<lable color=ccc3(245,236,183)>%s</lable>\229\144\142,\228\188\154\233\149\191\229\146\140\233\149\191\232\128\129\229\143\175\232\176\131\230\149\180\233\152\159\228\188\141\228\191\161\230\129\175"), self.mgr:getTimeToChairSetting())
      end
    else
      contextStr = string.format(T("\228\188\154\233\149\191\229\146\140\233\149\191\232\128\129\232\176\131\230\149\180\230\156\159 \229\137\169\228\189\153<lable color=ccc3(245,236,183)>%s</lable>"), self.mgr:getTimeToNextState())
    end
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = contextStr,
      color = ed.toccc3(10720396),
      strokeColor = ed.toccc3(2103826),
      strokeSize = 1,
      fontSize = 22,
      maxWidth = 1000
    })
    self.tipNode = autoText.node
    self.ui.ImageView_1482:addChild(autoText.node)
    local curWidth = autoText:getCurContentSize()
    autoText.node:setPosition(ccp(460 - curWidth / 2, 40))
  end
end

function GuildClashChairSetTeam:getCancelPressInHandler()
  local function handler(x, y)
  end
  
  return handler
end

function GuildClashChairSetTeam:getPressInHandler(line)
  local function handler(x, y)
    for k, item in pairs(self.uiList[line]) do
      if not self.curOpLineId then
        return
      end
      if ed.containsPoint(item.ui.bg, x, y) then
        return item
      end
    end
  end
  
  return handler
end

function GuildClashChairSetTeam:doOppo(data, ui, isReturn)
  local index = ui.index
  local srcLine = isReturn and self.curOpLineId or data._line_id
  local destLine = isReturn and data._line_id or self.curOpLineId
  if not (srcLine and destLine) or srcLine == destLine then
    return
  end
  local op = {
    teamId = data._id,
    userId = data._user_id,
    lineId = destLine
  }
  table.insert(self.opList, op)
  table.remove(self.listData[srcLine], index)
  table.insert(self.listData[destLine], 1, data)
  local srcDragList = self.draglists[srcLine]
  local srcListX, srcListY = srcDragList:getListPos()
  srcDragList:reloadData()
  local listHeight = #self.listData[srcLine] * 79.5
  srcListY = math.min(srcListY, listHeight)
  srcListY = math.max(srcListY, self.ui["layer_item_" .. lineName[srcLine]]:getContentSize().height)
  srcDragList:setListPos(ccp(srcListX, srcListY))
  self.draglists[destLine]:reloadData()
  for i = 1, 3 do
    ed.setString(self.ui["team_num_" .. lineName[i]], string.format(T("%s\233\152\159"), #self.listData[i]))
    self.ui["label_none_" .. lineName[i]]:setVisible(#self.listData[i] == 0)
  end
end

function GuildClashChairSetTeam:updateTotalTeam()
  for i = 1, 3 do
    ed.setString(self.ui["team_num_" .. lineName[i]], string.format("%s\233\152\159", #self.listData[i]))
    self.ui["label_none_" .. lineName[i]]:setVisible(#self.listData[i] == 0)
  end
end

function GuildClashChairSetTeam:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildClashChairTeamItem)
  container:setContentSize(CCSizeMake(280, 79.5))
  local summary = self.mgr:getUserSummary(data._user_id, self.mgr.campId)
  local head = ed.getWholeHeadIcon({
    id = summary._avatar,
    name = summary._name,
    medal = summary._medal,
    scale = 0.35,
    no_name_bg = true,
    level = summary._level,
    lvoffset = {x = -15, y = -1},
    config = {
      namefont = "chat_content",
      nameposition = 8
    }
  })
  ed.UITool.replaceUI(ui, "bg", "avatar", head)
  local gs = 0
  for i = 1, 5 do
    if data._heroes[i] then
      local heroSummary = data._heroes[i]._hero_summary
      local icon = ed.readhero.createIconByServer(heroSummary).icon
      icon:setScale(0.5)
      ed.UITool.replaceUI(ui, "bg", "icon" .. i, icon)
      gs = gs + heroSummary._gs
    else
      ui["icon" .. i]:setVisible(false)
    end
  end
  ui.breath:runAction(ed.UITool.getBreathAction(0.6))
  ed.setString(ui.gs_label, gs)
  return container, ui
end

function GuildClashChairSetTeam:refreshTeams(lineIds)
  lineIds = lineIds or {
    1,
    2,
    3
  }
  self.uiList = {}
  for k, v in ipairs(lineIds) do
    self:updateTotalTeam()
    self.draglists[v]:reloadData()
  end
end

function GuildClashChairSetTeam:initUI()
  ed.editorui(ed.uieditor.GuildClashChairSetTeam, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:initTableView()
end

function GuildClashChairSetTeam:initTableView()
  for line = 1, 3 do
    local delegate = {
      numberOfCells = function()
        local listData = self.listData[line] or {}
        return #listData
      end,
      cellSizeFromIndex = function(index)
        return CCSizeMake(280, 79.5)
      end,
      createCell = function(index)
        local listData = self.listData[line] or {}
        local data = listData[index] or {}
        local container, ui = self:createItem(data)
        ui.index = index
        return container, {data = data, ui = ui}
      end,
      doPressIn = function(cell, x, y)
      end,
      cancelPressIn = function(cell)
      end,
      doClickIn = function(cell, x, y)
        local ui = cell.data.ui
        local data = cell.data.data
        if line == self.curOpLineId then
          if ed.containsPoint(ui.bg, x, y) then
            self:doOppo(data, ui, true)
          end
        elseif ed.containsPoint(ui.bg, x, y) then
          self:doOppo(data, ui)
        end
        self:setTeamsOppoState()
      end
    }
    local containerLayer = self.ui["layer_item_" .. lineName[line]]
    local containerSize = containerLayer:getContentSize()
    local param = {
      delegate = delegate,
      container = containerLayer,
      cliprect = CCRectMake(0, 0, containerSize.width, containerSize.height),
      colNum = 1,
      dragMode = 1,
      touchpriority = -300,
      offset = {8, 0},
      noshade = true,
      doMove = function()
        self:setTeamsOppoState()
      end
    }
    local tableView = Tableview.create(param)
    self.draglists[line] = tableView
  end
end

function GuildClashChairSetTeam:registerEvents()
  self:listenEvent("GuildClashStartChairOperate", function()
    self.isOpera = true
    self.ui.btn_op:setVisible(false)
    self.ui.layer_btn:setVisible(true)
    self.operaTime = 1800
    ed.setString(self.ui.label_optime2, ed.time2dhms(self.operaTime))
    ed.showToast(T("\232\191\155\229\133\165\232\176\131\230\149\180\230\168\161\229\188\143"))
    self:listenTimer(Timer:Always(1, "UpdateOperaTime"), function()
      self.operaTime = self.operaTime - 1
      ed.setString(self.ui.label_optime2, ed.time2dhms(self.operaTime))
      if self.operaTime < 0 then
        CloseTimer("UpdateOperaTime")
        self:destroy()
      end
    end)
  end)
  self:listenEvent("GuildClashChairSwitchLine", function()
    ed.GuildClashNetwork:sendGuildTeam()
  end)
  self:listenEvent("GuildClashChairSetting", function()
    self.listData = self.mgr.linesTeamList or {}
    self.curOpLineId = nil
    self.opList = {}
    self:refreshUI()
  end)
  self:listenEvent("GuildClashDataRefresh", function()
    ed.showToast(T("\230\175\148\232\181\155\231\138\182\230\128\129\230\155\180\230\150\176"))
    self.listData = self.mgr.linesTeamList or {}
    self.curOpLineId = nil
    self.opList = {}
    self.uiList = {}
    self:refreshUI()
  end)
end

function GuildClashChairSetTeam:unSelectedBtn()
  for i = 1, 3 do
    self.ui["btn_add_" .. lineName[i] .. "_selected"]:setVisible(false)
    self.ui["btn_add_" .. lineName[i]]:setVisible(true)
    ed.setString(self.ui["label_add_" .. lineName[i]], T("\231\167\187\229\133\165\233\152\159\228\188\141"))
  end
  self:setSwapLineBtnVis(true)
  self:setTeamsOppoState(false)
end

function GuildClashChairSetTeam:setSwapLineBtnVis(flag)
  self.ui.btn_top_2:setVisible(flag)
  self.ui.btn_mid_1:setVisible(flag)
  self.ui.btn_mid_2:setVisible(flag)
  self.ui.btn_bottom_1:setVisible(flag)
end

function GuildClashChairSetTeam:selectedBtn(lineId)
  for i = 1, 3 do
    self.ui["btn_add_" .. lineName[i] .. "_selected"]:setVisible(i == lineId)
    self.ui["btn_add_" .. lineName[i]]:setVisible(i == lineId)
    ed.setString(self.ui["label_add_" .. lineName[i]], T("\233\128\128\229\135\186\231\167\187\229\133\165"))
    self.ui["label_add_" .. lineName[i]]:limitWidthByScale(100)
  end
  self:setSwapLineBtnVis(false)
end

function GuildClashChairSetTeam:switchLine(from, to)
  self.from = from
  self.to = to
  ed.GuildClashNetwork:sendChairSwithcLine(from, to)
end

function GuildClashChairSetTeam:destroy()
  if self.isOpera then
    ed.GuildClashNetwork:endChairOperate()
  end
  if #self.opList > 0 then
    ed.showConfirmDialog({
      text = T("\230\156\137\230\147\141\228\189\156\230\156\170\228\191\157\229\173\152\239\188\140\230\152\175\229\144\166\228\191\157\229\173\152\239\188\159"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.GuildClashNetwork:sendChairChangeLine(self.opList)
        base.destroy(self)
      end,
      leftHandler = function()
        base.destroy(self)
      end
    })
  else
    base.destroy(self)
  end
end

function GuildClashChairSetTeam:setTeamsOppoState(flag)
  if flag ~= nil then
    self.teamsOppsState = flag
  else
    flag = self.teamsOppsState
  end
  for lineId = 1, 3 do
    local tableView = self.draglists[lineId]
    local cellUsed = tableView:getUsedCell()
    if flag then
      for k, cell in ipairs(cellUsed or {}) do
        local node = cell.node
        local ui = cell.data.ui
        local data = cell.data.data
        if not tolua.isnull(ui.mask) then
          ui.mask:setVisible(data._line_id == self.curOpLineId)
          ui.breath:setVisible(data._line_id ~= self.curOpLineId)
          ui.btn_return:setVisible(data._line_id ~= lineId)
        end
      end
    else
      for k, cell in ipairs(cellUsed or {}) do
        local node = cell.node
        local ui = cell.data.ui
        local data = cell.data.data
        if not tolua.isnull(ui.mask) then
          ui.mask:setVisible(false)
          ui.breath:setVisible(false)
          ui.btn_return:setVisible(false)
        end
      end
    end
  end
end

function GuildClashChairSetTeam:onClickAddTeamBtn(lineId)
  if self.curOpLineId and self.curOpLineId == lineId then
    if self.curOpLineId == lineId then
      if #self.opList > 0 then
        ed.GuildClashNetwork:sendChairChangeLine(self.opList)
      end
      self.curOpLineId = nil
      self.opList = {}
      self:unSelectedBtn()
    else
      return
    end
  else
    self.curOpLineId = lineId
    self:selectedBtn(self.curOpLineId)
    self:setTeamsOppoState(true)
  end
end

function GuildClashChairSetTeam:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.66, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_top_2", function()
    self:switchLine(1, 2)
  end)
  ed.UITool.registerBtn(self, "btn_op", function()
    ed.GuildClashNetwork:startChairOperate()
  end)
  ed.UITool.registerBtn(self, "btn_mid_1", function()
    self:switchLine(1, 2)
  end)
  ed.UITool.registerBtn(self, "btn_mid_2", function()
    self:switchLine(2, 3)
  end)
  ed.UITool.registerBtn(self, "btn_bottom_1", function()
    self:switchLine(2, 3)
  end)
  for lineId = 1, 3 do
    ed.UITool.registerBtn(self, "btn_add_" .. lineName[lineId], function()
      self:onClickAddTeamBtn(lineId)
    end)
  end
end
