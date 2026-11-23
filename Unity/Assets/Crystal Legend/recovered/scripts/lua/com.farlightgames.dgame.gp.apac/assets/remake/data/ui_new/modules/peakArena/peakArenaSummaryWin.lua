local base = ed.ui.popwindow
local PeakArenaSummaryWin = newclass(base.mt)
ed.ui.PeakArenaSummaryWin = PeakArenaSummaryWin

function PeakArenaSummaryWin:initData()
  self.mgr = ed.PeakArenaManager
  ed.storage.setValue(ed.getRoleKey("peakarenaSummary" .. self.mgr.season), true)
end

function PeakArenaSummaryWin:initUI(param)
  ed.editorui(ed.uieditor.PeakArenaSummaryWin, {
    container = self.container,
    ui = self.ui
  })
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(16747300), 1)
  ed.setLabelShadow(self.ui.label_title, ed.toccc3(9715743), ccp(0, 2))
  ed.setLabelFontName(self.ui.label_title, ed.fontBold)
  self:refreshSummaryPanel()
  self.closeTime = param and (param.closeTime or 0) or 0
  if 0 >= self.closeTime then
    self.ui.Label_close:setString(T("\231\161\174\229\174\154"))
  else
    self.ui.Label_close:setString(T("\231\161\174\229\174\154(%ss)", self.closeTime))
  end
  self.ui.label_title:limitWidthByScale(216)
  self.timeAch = self:listenTimer(Timer:Always(1), function()
    self.closeTime = self.closeTime - 1
    if self.closeTime <= 0 then
      self.ui.Label_close:setString(T("\231\161\174\229\174\154"))
      CloseTimer(self.timeAch.Name)
    else
      self.ui.Label_close:setString(T("\231\161\174\229\174\154(%ss)", self.closeTime))
    end
  end)
end

function PeakArenaSummaryWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg_history,
    key = "out_click",
    clickHandler = function()
      if self.closeTime <= 0 then
        self:destroy()
      end
    end,
    force = true
  })
  self:btRegisterButtonClick({
    button = self.ui.ImageView_close,
    key = "ImageView_close",
    clickHandler = function()
      if self.closeTime <= 0 then
        self:destroy()
      end
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
end

function PeakArenaSummaryWin:registerEvents()
end

function PeakArenaSummaryWin:refreshSummaryPanel()
  local ori_size = self.ui.Panel_2809:getContentSize()
  self.ui.Panel_2809:setContentSize(CCSizeMake(ori_size.width, ori_size.height - 50))
  ed.UITool.setPositionBy(self.ui.Panel_2809, ccp(0, 50))
  local data = self.mgr:getSummary()
  local seasonIcon = ed.getNumberNode({
    text = self.mgr:getSeasonName(self.mgr:getSeason()),
    folder = "season"
  }).node
  seasonIcon:setPosition(ccp(350, 426))
  self.ui.bg_history:addChild(seasonIcon)
  ed.setLabelStroke(self.ui.Label_2811, ed.toccc3(12477222), 1)
  ed.setString(self.ui.Label_2811, string.format(T("%s\232\181\155\229\173\163\229\183\178\231\187\147\230\157\159"), self.mgr:getSeasonName(self.mgr:getSeason())))
  local info = {
    totalChallengeTime = data._total_challenge_count,
    winRate = math.floor(data._challenge_victory_count * 100 / data._total_challenge_count),
    overPercent = data._challenge_victory_over,
    defendTimes = data._total_defend_count,
    defendSuccessRate = data._total_defend_count == 0 and 100 or math.floor(data._defend_victory_count * 100 / data._total_defend_count or 1),
    defendOverPercent = data._defend_victory_over,
    gradeRes = self.mgr:getGradeIconRes(data._top_grade),
    gradeNameRes = self.mgr:getGradeTextRes(data._top_grade),
    medal = data._top_medal or 0,
    rank = data._medal_rank or T("\230\156\170\228\184\138\230\166\156")
  }
  local summaryInfo = {
    string.format(T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\130\168\229\156\168\230\156\172\232\181\155\229\173\163\228\184\173\239\188\140\230\128\187\229\133\177\230\140\145\230\136\152\228\186\134<lable color=peakSummary>%d</lable>\230\172\161\239\188\140\232\131\156\231\142\135\228\184\186<lable color=peakSummary>%d%%</lable>\239\188\140\232\182\133\232\191\135\228\186\134<lable color=peakSummary>%d%%</lable>\231\154\132\231\142\169\229\174\182!"), info.totalChallengeTime, info.winRate, info.overPercent),
    string.format(T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\143\151\229\136\176\228\186\134<lable color=peakSummary>%d</lable>\230\172\161\230\148\187\229\135\187\239\188\140\233\152\178\229\174\136\232\131\156\231\142\135\228\184\186<lable color=peakSummary>%d%%</lable>,\229\143\170\230\156\137<lable color=peakSummary>%d%%</lable>\231\154\132\231\142\169\229\174\182\232\131\189\228\184\142\230\130\168\229\140\185\230\149\140!"), info.defendTimes, info.defendSuccessRate, info.defendOverPercent)
  }
  if data._challenges then
    local timeStr = os.date("%Y/%m/%d", data._challenges[1]._bt_time)
    local oppoName = data._challenges[1]._oppo._summary._name
    local str = string.format(T("<sprite src=UI/alpha/1080P/common/rivet_big.png><lable color=peakSummary>%s</lable>\230\130\168\233\129\173\233\129\135\228\186\134\230\156\172\232\181\155\229\173\163\230\156\128\233\154\190\231\188\160\231\154\132\231\142\169\229\174\182<lable color=peakSummary>%s</lable>\239\188\140\233\130\163\228\184\128\229\174\154\230\152\175\228\184\128\229\156\186\230\131\138\229\191\131\229\138\168\233\173\132\231\154\132\229\175\185\229\134\179\229\144\167"), timeStr, oppoName)
    table.insert(summaryInfo, str)
  end
  if data._hero_used then
    local heroIcon = ed.getUnitPortrait(data._hero_used[1])
    local times = data._hero_used[2]
    local str = string.format(T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\232\181\155\229\173\163\228\184\173\239\188\140\228\189\191\231\148\168\230\172\161\230\149\176\230\156\128\229\164\154\231\154\132\232\139\177\233\155\132\230\152\175<sprite src=%s scale=0.4>\230\128\187\229\133\177\228\184\138\233\152\181<lable color=peakSummary>%s</lable>\230\172\161\239\188\140\228\184\141\232\166\129\229\191\152\232\174\176\231\187\153\229\138\179\230\168\161\229\143\145\228\184\128\230\156\181\229\176\143\231\186\162\232\138\177\227\128\130"), heroIcon, times)
    table.insert(summaryInfo, str)
  end
  local fixGradeGroup = ed.getDataTable("PeakArenaSeason")[self.mgr:getSeason()]["Fix Grade Group"]
  local gradeCNName
  if 0 < fixGradeGroup then
    gradeCNName = ed.getDataTable("PeakArenaGradeinfo")[fixGradeGroup][data._top_grade]["Grade Name"]
  else
    gradeCNName = ed.getDataTable("PeakArenaGrade")[data._top_grade]["Grade Name"]
  end
  local str = string.format(T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\156\128\233\171\152\232\190\190\229\136\176\230\174\181\228\189\141<sprite src=%s scale=0.25><lable color=peakSummary>%s</lable>\239\188\140\230\142\146\229\144\141<lable color=peakSummary>%s</lable>\239\188\140\230\156\155\230\130\168\229\156\168\228\184\139\228\184\170\232\181\155\229\173\163\228\185\159\229\134\141\230\142\165\229\134\141\229\142\137!"), info.gradeRes, gradeCNName, info.rank)
  table.insert(summaryInfo, str)
  local draglist = ed.UITool.createDraglist(self.ui.Panel_2809, {})
  local size = self.ui.Panel_2809:getContentSize()
  local curHeight = 20
  for k, v in ipairs(summaryInfo) do
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = v,
      color = ccc3(255, 252, 231),
      fontSize = 18,
      maxWidth = size.width - 10,
      strokeColor = ed.toccc3(2565413),
      strokeSize = 1
    })
    autoText.node:setPosition(ccp(0, size.height - curHeight))
    draglist:addItem(autoText.node)
    local width, height = autoText:getCurContentSize()
    curHeight = curHeight + height + 10
  end
  draglist:initListHeight(curHeight - 20)
end

function PeakArenaSummaryWin.create(param)
  local self = base.create("PeakArenaSummaryWin")
  setmetatable(self, PeakArenaSummaryWin.mt)
  self:initData()
  self:initUI(param)
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end
