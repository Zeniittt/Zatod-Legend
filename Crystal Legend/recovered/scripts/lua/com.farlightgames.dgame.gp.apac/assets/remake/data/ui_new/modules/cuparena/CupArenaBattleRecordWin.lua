local base = ed.ui.popwindow
local CupArenaBattleRecordWin = newclass(base.mt)
ed.ui.CupArenaBattleRecordWin = CupArenaBattleRecordWin
local ViewType = {Audition = 1, Knockout = 2}
local ViewTitleStr = {
  [ViewType.Audition] = T("\230\181\183\233\128\137\232\174\176\229\189\149"),
  [ViewType.Knockout] = T("\229\183\133\229\179\176\232\174\176\229\189\149")
}

function CupArenaBattleRecordWin.create(data)
  local self = base.create("CupArenaBattleRecordWin")
  setmetatable(self, CupArenaBattleRecordWin.mt)
  self:initData(data)
  self:initUI()
  self:registerTouchHandler()
  self:registerListenEvent()
  self:onRecordReply(data)
  self.ui.btn_knockout:setVisible(data.isKnockout)
  self:popWindow()
  return self
end

function CupArenaBattleRecordWin:initData(data)
  self.recordTab = {}
end

function CupArenaBattleRecordWin:initUI()
  ed.editorui(ed.uieditor.CupArenaBattleRecordWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelStroke(self.ui.label_audition, ed.toccc3(4666913), 1)
  ed.setLabelStroke(self.ui.label_audition_selected, ed.toccc3(4666913), 1)
  ed.setLabelStroke(self.ui.label_knockout, ed.toccc3(4666913), 1)
  ed.setLabelStroke(self.ui.label_knockout_selected, ed.toccc3(4666913), 1)
end

function CupArenaBattleRecordWin:refreshViewUI()
  self.ui.panel_audition:setVisible(ViewType.Audition == self.curViewType)
  self.ui.panel_knockout:setVisible(ViewType.Knockout == self.curViewType)
  self.ui.btn_audition_selected:setVisible(ViewType.Audition == self.curViewType)
  self.ui.btn_knockout_selected:setVisible(ViewType.Knockout == self.curViewType)
  if nil == self.ui.titleLabel then
    local titleLabel = ed.ui.gradientLabel.create({
      text = ViewTitleStr[self.curViewType],
      fontSize = 24,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16777215),
      endColor = ed.toccc3(16770963),
      strokeSize = 1,
      strokeColor = ed.toccc3(9523712)
    })
    self.ui.bg:addChild(titleLabel.node)
    self.ui.titleLabel = titleLabel
    local bgSize = self.ui.bg:getContentSize()
    titleLabel.node:setPosition(ccp(bgSize.width * 0.5, bgSize.height - 30))
  else
    self.ui.titleLabel:setString(ViewTitleStr[self.curViewType])
  end
end

function CupArenaBattleRecordWin:getAuditionItemPos(i)
  local size = self.ui.panel_audition:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 76
  local itemSpace = 4
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaBattleRecordWin:getAuditionListHeight(num)
  local itemHeight = 76
  local itemSpace = 4
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaBattleRecordWin:createAuditionItem(index, recordData)
  local container, ui = ed.editorui(ed.uieditor.CupArenaBattleRecordAuditionItem)
  container:setContentSize(ui.panel_container:getContentSize())
  ui.panel_container:setPosition(ed.ccpZero)
  ui.label_score_des:setFontName(ed.fontBold)
  ed.setLabelShadow(ui.Label_261, ccc3(0, 0, 0), ccp(1, 1))
  ui.bg_defend:setVisible(recordData._active ~= 1)
  ui.label_defend:setFontName(ed.fontBold)
  local isWin = recordData._bt_result == "victory"
  if isWin then
    ed.setTexture(ui.img_result, "UI/alpha/1080P/toparena/toparena_record_win.png")
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/cuparena_record_winner_bg.png")
    ed.setTexture(ui.bg_score, "UI/alpha/1080P/toparena/toparena_score_icon.png")
    ed.setTexture(ui.bg_name, "UI/alpha/1080P/cuparena/cuparena_record_winner_name.png")
    ed.setTexture(ui.bg_line_1, "UI/alpha/1080P/cuparena/cuparena_record_winner_line.png")
    ed.setTexture(ui.bg_line_2, "UI/alpha/1080P/cuparena/cuparena_record_winner_line.png")
    ed.setLabelColor(ui.label_score_des, ed.toccc3(16773542))
    ed.setLabelStroke(ui.label_score_des, ed.toccc3(12542248), 1)
  else
    ed.setTexture(ui.img_result, "UI/alpha/1080P/toparena/toparena_record_lose.png")
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/cuparena_record_loser_bg.png")
    ed.setTexture(ui.bg_score, "UI/alpha/1080P/toparena/toparena_score_icon2.png")
    ed.setTexture(ui.bg_name, "UI/alpha/1080P/cuparena/cuparena_record_loser_name.png")
    ed.setTexture(ui.bg_line_1, "UI/alpha/1080P/cuparena/cuparena_record_loser_line.png")
    ed.setTexture(ui.bg_line_2, "UI/alpha/1080P/cuparena/cuparena_record_loser_line.png")
    ed.setLabelColor(ui.label_score_des, ed.toccc3(13754623))
    ed.setLabelStroke(ui.label_score_des, ed.toccc3(5131389), 1)
  end
  local campTableItem = ed.getDataTable("CupArenaCamp")[recordData._oppo._camp_id]
  ed.setTexture(ui.img_camp, campTableItem["Camp Symbol Min"])
  local summary = recordData._oppo._summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.75,
    lvoffset = {x = -47, y = -25}
  }
  local head = ed.getWholeHeadIcon(param)
  ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  ui.head = head
  local name = ed.getPlayerName(summary._name, summary._medal, {
    medalScale = 0.18,
    medalRight = false,
    disableOffset = true,
    anchorPoint = ccp(0, 0.5)
  })
  name:setScale(0.9)
  ed.UITool.replaceUI(ui, "bg_name", "label_name", name)
  ed.setLabelString(ui.label_server, recordData._oppo._server_name)
  ed.setLabelString(ui.label_date, os.date("%Y-%m-%d", ed.time2China(recordData._bt_time)))
  ed.setLabelString(ui.label_time, os.date("%H:%M", ed.time2China(recordData._bt_time)))
  local curScore = recordData._self_new_score or 0
  local scoreChange = curScore - recordData._self_old_score or 0
  local scoreNode = ed.getNumberNode({text = curScore, folder = "peak_score"}).node
  ui.panel_score:addChild(scoreNode)
  scoreNode:setScale(0.9)
  scoreNode:setPosition(ccp(scoreNode:getContentSize().width / 2 - 5, 20))
  if 0 < scoreChange then
    ed.setLabelColor(ui.label_score_change, ccc3(119, 255, 91))
    ed.setLabelStroke(ui.label_score_change, ed.toccc3(0), 1)
    ed.setLabelString(ui.label_score_change, scoreChange)
    ed.setTexture(ui.image_arrow, "UI/alpha/1080P/pvp/arrow_up.png")
  elseif scoreChange < 0 then
    ed.setLabelColor(ui.label_score_change, ccc3(255, 97, 66))
    ed.setLabelStroke(ui.label_score_change, ed.toccc3(0), 1)
    ed.setLabelString(ui.label_score_change, math.abs(scoreChange))
    ed.setTexture(ui.image_arrow, "UI/alpha/1080P/pvp/arrow_down.png")
  else
    ui.image_arrow:setVisible(false)
    ed.setLabelColor(ui.label_score_change, ccc3(180, 254, 139))
    ed.setLabelStroke(ui.label_score_change, ed.toccc3(3080450), 1)
    ed.setLabelString(ui.label_score_change, T("\228\191\157\230\138\164\228\184\173"))
  end
  ed.right2(ui.image_arrow, scoreNode, 5)
  ed.right2(ui.label_score_change, ui.image_arrow, 0)
  return container, ui
end

function CupArenaBattleRecordWin:refreshAuditionListUI()
  if nil == self.ui.auditionTableview then
    local size = self.ui.panel_audition:getContentSize()
    local delegate = {
      numberOfCells = function()
        return #self.recordTab[ViewType.Audition]
      end,
      cellSizeFromIndex = function(index)
        return CCSizeMake(768, 85)
      end,
      createCell = function(index)
        local recordDatas = self.recordTab[ViewType.Audition]
        return self:createAuditionItem(index, recordDatas[index])
      end,
      doPressIn = function(cell, x, y)
        local ui = cell.data
        if ui and ed.containsPoint(ui.btn_detail, x, y) then
          ui.btn_detail:setScale(0.95)
        end
      end,
      doClickIn = function(cell, x, y)
        local ui = cell.data
        if ui and self.curViewType == ViewType.Audition then
          local recordData = self.recordTab[ViewType.Audition][cell.idx]
          if ed.containsPoint(ui.btn_detail, x, y) then
            local scoreData = {}
            if 1 == recordData._active then
              scoreData._self_old_score = recordData._self_old_score
              scoreData._self_new_score = recordData._self_new_score
              scoreData._oppo_old_score = recordData._oppo_old_score
              scoreData._oppo_new_score = recordData._oppo_new_score
            else
              scoreData._self_old_score = recordData._oppo_old_score
              scoreData._self_new_score = recordData._oppo_new_score
              scoreData._oppo_old_score = recordData._self_old_score
              scoreData._oppo_new_score = recordData._self_new_score
            end
            ed.CupArenaNetwork:sendGetReply(recordData._replay_id, nil, scoreData)
          elseif ed.containsPoint(ui.panel_head, x, y) then
          end
        end
      end,
      cancelPressIn = function(cell, x, y)
        local ui = cell.data
        if ui then
          ui.btn_detail:setScale(1)
        end
      end
    }
    local param = {
      delegate = delegate,
      container = self.ui.panel_audition,
      cliprect = CCRectMake(0, 0, size.width, size.height),
      colNum = 1,
      dragMode = 1,
      touchpriority = -300,
      noshade = true
    }
    self.ui.auditionTableview = Tableview.create(param)
  end
  self.ui.auditionTableview:reloadData()
  local recordNum = #self.recordTab[ViewType.Audition]
  self.ui.img_empty:setVisible(0 == recordNum)
  ed.setLabelString(self.ui.label_empty, T("\230\154\130\230\151\160\230\140\145\230\136\152\232\174\176\229\189\149"))
  self.refreshCliprectConfig = {
    draglist = self.ui.auditionTableview:getDragList()
  }
end

function CupArenaBattleRecordWin:getKnockoutItemPos(i)
  local size = self.ui.panel_audition:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 76
  local itemSpace = 4
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaBattleRecordWin:getKnockoutListHeight(num)
  local itemHeight = 76
  local itemSpace = 4
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaBattleRecordWin:createKnockoutItem(index, recordData)
  local container, ui = ed.editorui(ed.uieditor.CupArenaBattleRecordKnockoutItem)
  container:setContentSize(ui.panel_container:getContentSize())
  ui.panel_container:setPosition(ed.ccpZero)
  ed.setLabelShadow(ui.Label_261, ccc3(0, 0, 0), ccp(1, 1))
  ed.setLabelStroke(ui.label_match_des, ed.toccc3(3942424), 1)
  ed.setLabelStroke(ui.label_group, ed.toccc3(3942424), 1)
  local isWin = recordData._is_win == 1
  if isWin then
    ed.setTexture(ui.img_result, "UI/alpha/1080P/toparena/toparena_record_win.png")
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/cuparena_record_winner_bg.png")
    ed.setTexture(ui.bg_name, "UI/alpha/1080P/cuparena/cuparena_record_winner_name.png")
    ed.setTexture(ui.bg_match_des, "UI/alpha/1080P/cuparena/cuparena_record_winner_race.png")
    ed.setTexture(ui.bg_line_1, "UI/alpha/1080P/cuparena/cuparena_record_winner_line.png")
    ed.setTexture(ui.bg_line_2, "UI/alpha/1080P/cuparena/cuparena_record_winner_line.png")
  else
    ed.setTexture(ui.img_result, "UI/alpha/1080P/toparena/toparena_record_lose.png")
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/cuparena_record_loser_bg.png")
    ed.setTexture(ui.bg_name, "UI/alpha/1080P/cuparena/cuparena_record_loser_name.png")
    ed.setTexture(ui.bg_match_des, "UI/alpha/1080P/cuparena/cuparena_record_loser_race.png")
    ed.setTexture(ui.bg_line_1, "UI/alpha/1080P/cuparena/cuparena_record_loser_line.png")
    ed.setTexture(ui.bg_line_2, "UI/alpha/1080P/cuparena/cuparena_record_loser_line.png")
  end
  local matchTableItem = ed.getDataTable("CupArenaMatch")[recordData._match_id]
  ed.setString(ui.label_match_des, ed.CupArenaUITool.getMatchName(matchTableItem["Match Location"]))
  if 0 == matchTableItem["Group ID"] then
    ed.setString(ui.label_group, "")
    ui.bg_match_des:setPositionY(40.5)
  else
    local groupTableItem = ed.getDataTable("CupArenaGroup")[matchTableItem["Group ID"]]
    ed.setString(ui.label_group, groupTableItem["Group Name"])
    ui.bg_match_des:setPositionY(51.5)
  end
  local campTableItem = ed.getDataTable("CupArenaCamp")[recordData._oppo._camp_id]
  ed.setTexture(ui.img_camp, campTableItem["Camp Symbol Min"])
  local summary = recordData._oppo._summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.75,
    lvoffset = {x = -47, y = -25}
  }
  local head = ed.getWholeHeadIcon(param)
  ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    medalScale = 0.18,
    medalRight = false,
    disableOffset = true,
    anchorPoint = ccp(0, 0.5)
  })
  name:setScale(0.9)
  ed.UITool.replaceUI(ui, "bg_name", "label_name", name)
  ed.setLabelString(ui.label_server, recordData._oppo._server_name)
  ed.setLabelString(ui.label_date, os.date("%Y-%m-%d", ed.time2China(recordData._start_time)))
  ed.setLabelString(ui.label_time, os.date("%H:%M", ed.time2China(recordData._start_time)))
  return container, ui
end

function CupArenaBattleRecordWin:refreshKnockoutListUI()
  if nil == self.ui.knockoutTableview then
    local size = self.ui.panel_knockout:getContentSize()
    local delegate = {
      numberOfCells = function()
        return #self.recordTab[ViewType.Knockout]
      end,
      cellSizeFromIndex = function(index)
        return CCSizeMake(768, 85)
      end,
      createCell = function(index)
        local recordDatas = self.recordTab[ViewType.Knockout]
        return self:createKnockoutItem(index, recordDatas[index])
      end,
      doPressIn = function(cell, x, y)
        local ui = cell.data
        if ui and ed.containsPoint(ui.btn_detail, x, y) then
          ui.btn_detail:setScale(0.95)
        end
      end,
      doClickIn = function(cell, x, y)
        local ui = cell.data
        if ui and self.curViewType == ViewType.Knockout then
          local recordData = self.recordTab[ViewType.Knockout][cell.idx]
          if ed.containsPoint(ui.btn_detail, x, y) then
            ed.CupArenaNetwork:sendGetReply(nil, recordData._match_id)
          elseif ed.containsPoint(ui.panel_head, x, y) then
          end
        end
      end,
      cancelPressIn = function(cell, x, y)
        local ui = cell.data
        if ui then
          ui.btn_detail:setScale(1)
        end
      end
    }
    local param = {
      delegate = delegate,
      container = self.ui.panel_knockout,
      cliprect = CCRectMake(0, 0, size.width, size.height),
      colNum = 1,
      dragMode = 1,
      touchpriority = -300,
      noshade = true
    }
    self.ui.knockoutTableview = Tableview.create(param)
  end
  self.ui.knockoutTableview:reloadData()
  local recordNum = #self.recordTab[ViewType.Knockout]
  self.ui.img_empty:setVisible(0 == recordNum)
  ed.setLabelString(self.ui.label_empty, T("\230\154\130\230\151\160\230\175\148\232\181\155\232\174\176\229\189\149"))
  self.refreshCliprectConfig = {
    draglist = self.ui.knockoutTableview:getDragList()
  }
end

function CupArenaBattleRecordWin:registerTouchHandler()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_audition", function()
    self:onAuditionEvent()
  end)
  ed.UITool.registerBtn(self, "btn_knockout", function()
    self:onKnockoutEvent()
  end)
end

function CupArenaBattleRecordWin:registerListenEvent()
  self:listenEvent("EventCupArenaBattleRecord", function(data)
    self:onRecordReply(data)
  end)
end

function CupArenaBattleRecordWin:onAuditionEvent()
  if self.curViewType == ViewType.Audition then
    return
  end
  if nil == self.recordTab[ViewType.Audition] then
    ed.CupArenaNetwork:sendGetBattleRecord(false, false)
  else
    self.curViewType = ViewType.Audition
    self:refreshViewUI()
    self:refreshAuditionListUI()
  end
end

function CupArenaBattleRecordWin:onKnockoutEvent()
  if self.curViewType == ViewType.Knockout then
    return
  end
  if nil == self.recordTab[ViewType.Knockout] then
    ed.CupArenaNetwork:sendGetBattleRecord(true, false)
  else
    self.curViewType = ViewType.Knockout
    self:refreshViewUI()
    self:refreshKnockoutListUI()
  end
end

function CupArenaBattleRecordWin:onRecordReply(data)
  self.curViewType = data.isKnockout and ViewType.Knockout or ViewType.Audition
  self.recordTab[self.curViewType] = data.records or {}
  self:refreshViewUI()
  if ViewType.Audition == self.curViewType then
    self:refreshAuditionListUI()
  elseif ViewType.Knockout == self.curViewType then
    self:refreshKnockoutListUI()
  end
end
