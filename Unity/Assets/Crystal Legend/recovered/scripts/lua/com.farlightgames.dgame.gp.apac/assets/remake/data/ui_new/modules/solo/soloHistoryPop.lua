local base = ed.ui.popwindow
local soloHistoryPop = newclass(base.mt)
ed.ui.soloHistoryPop = soloHistoryPop

function soloHistoryPop.create(data)
  local self = base.create("soloHistoryPop", {notBlurBg = true})
  setmetatable(self, soloHistoryPop.mt)
  self.data = data
  self:initUI()
  self.dataList = self.data or {}
  self:createTableview()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "solo_history_pop_destroy",
    clickHandler = function()
      self:destroy()
    end
  })
  ed.UITool.registerBtn(self, "btn_close_slr", function()
    self:destroy()
  end, {pressScale = 0.95, normalScale = 1})
  self:popWindow()
  self:show()
  return self
end

function soloHistoryPop:initUI()
  ed.editorui(ed.uieditor.soloHistoryPop, {
    container = self.container,
    ui = self.ui
  })
end

function soloHistoryPop:createRankItem(idx, data)
  local settle = data._settle
  local ui = {}
  local container = ed.createCCLayer({
    pos = ccp(0, 0),
    sizeMake = CCSizeMake(700, 86.5)
  })
  ui.bg = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/history/bar.png",
    pos = ccp(350, 43.25),
    parent = container
  })
  ui.rankBg = ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/chesscard/history/%s.png", settle._rank > 3 and "lose" or "win"),
    pos = ccp(56, 43.25),
    parent = ui.bg
  })
  ui.rank = ed.ui.gradientLabel.create({
    text = T("\231\172\172%d\229\144\141", settle._rank),
    fontSize = 20,
    fontName = ed.fontBold,
    startColor = ed.toccc3(settle._rank < 4 and 16445614 or 13822974),
    endColor = ed.toccc3(settle._rank < 4 and 16438887 or 11719917),
    strokeSize = 3,
    strokeColor = ed.toccc3(settle._rank < 4 and 9123841 or 3162707)
  })
  ui.rank.node:setPosition(ccp(45, 39))
  ui.rankBg:addChild(ui.rank.node)
  local summary = settle._user_summary._user_summary
  local heroIcon = ed.readhero.createSoloUnitIcon({
    id = settle._user_summary._hero_id
  }).icon
  heroIcon:setScale(0.75)
  heroIcon:setPosition(139, 43.25)
  ui.bg:addChild(heroIcon)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = "ccc3(255,252,231)",
    fontSize = 15,
    disableOffset = true,
    medalScale = 0.18
  })
  name:setPosition(ccp(171, 63.25))
  ui.bg:addChild(name)
  ed.createLabelTools({
    txt = T("lv.%d", settle._user_summary._level),
    size = 15,
    pos = ccp(171, 43.25),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = ui.bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#2c1e06")),
      1.3
    }
  })
  ed.createLabelTools({
    txt = T("\231\167\175\229\136\134:%d", data._new_score),
    size = 15,
    pos = ccp(171, 23.25),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = ui.bg,
    anchor = ccp(0, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#2c1e06")),
      1.3
    }
  })
  if data._old_score < data._new_score then
    local addx = 10
    for i = 1, 9 do
      if addx > data._new_score then
        addx = i * 6.7
        break
      end
      addx = addx * 10
    end
    ed.createLabelTools({
      txt = T("(+%d)", data._new_score - data._old_score),
      size = 15,
      pos = ccp(212 + addx, 23.25),
      color = ccc3(ed.colorToStr("#6cf550")),
      parent = ui.bg,
      anchor = ccp(0, 0.5),
      stroke = {
        ccc3(ed.colorToStr("#2c1e06")),
        1.3
      }
    })
  end
  if settle._factions and settle._factions[1] then
    table.sort(settle._factions, function(a, b)
      if a._level == b._level then
        return a._exp > b._exp
      else
        return a._level > b._level
      end
    end)
    local factionId = settle._factions[1]._faction
    local exp = settle._factions[1]._exp
    local level = settle._factions[1]._level
    local factionIconRes = ed.getDataTable("SoloCardTag")[factionId]["Tag Icon"]
    ed.createSpriteTools({
      res = factionIconRes,
      pos = ccp(330, 53.25),
      parent = ui.bg,
      scale = 0.6
    })
    ed.createLabelTools({
      txt = ed.getDataTable("SoloCardTag")[factionId].Name,
      size = 15,
      pos = ccp(330, 23.25),
      color = ccc3(ed.colorToStr("#fffce7")),
      parent = ui.bg,
      anchor = ccp(0.5, 0.5),
      stroke = {
        ccc3(ed.colorToStr("#2c1e06")),
        1.3
      }
    })
  end
  for i, power in ipairs(settle._powers or {}) do
    ed.createSpriteTools({
      res = "UI/alpha/1080P/chesscard/treasure_1.png",
      pos = ccp(350 + i * 60, 43.25),
      parent = ui.bg,
      scale = 1.05
    })
    local powerId = power._id
    local effect1 = power._effects[1]
    local clipNode = ed.createClippingNodeOnly("UI/alpha/1080P/chesscard/treasure_2.png")
    local powerIcon = ed.createSprite(ed.getDataTable("SoloPower")[powerId].Icon)
    clipNode:addChild(powerIcon)
    clipNode:setPosition(ccp(350 + i * 60, 43.25))
    ui.bg:addChild(clipNode)
  end
  ed.createLabelTools({
    txt = T("%s\229\137\141", ed.time2dhm(ed.getServerTime() - data._record_time)),
    size = 14,
    pos = ccp(635, 67.25),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = ui.bg,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#2c1e06")),
      1.3
    }
  })
  ui.button = ed.createSpriteTools({
    res = "UI/alpha/1080P/chesscard/match/match_button_1.png",
    pos = ccp(635, 33.25),
    parent = ui.bg,
    scale = 0.8
  })
  ed.createLabelTools({
    txt = T("\232\175\166\230\131\133"),
    size = 22,
    pos = ccp(64, 29),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = ui.button,
    anchor = ccp(0.5, 0.5),
    stroke = {
      ccc3(ed.colorToStr("#8a5b19")),
      2
    },
    font = ed.fontBold
  })
  return container, {
    data = {
      _user = summary,
      record_id = data._record_id
    },
    ui = ui
  }
end

function soloHistoryPop:createTableview()
  self.delegate = {
    numberOfCells = function()
      return #self.dataList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(700, 89)
    end,
    createCell = function(index)
      local data = self.dataList[index]
      return self:createRankItem(index, data)
    end,
    doPressIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if ed.containsPoint(ui.bg, x, y) then
        if ed.containsPoint(ui.button, x, y) then
          ui.button:setScale(0.75)
        end
        return cell
      end
    end,
    cancelPressIn = function(cell)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      ui.button:setScale(0.8)
    end,
    doClickIn = function(cell, x, y)
      local data = cell.data
      if not data then
        return
      end
      local ui = data.ui
      if not ed.containsPoint(ui.button, x, y) then
        return
      end
      ed.SoloNetwork:sendSoloRecordDetail(data.data.record_id)
    end
  }
  local size = self.ui.Panel_525:getContentSize()
  local param = {
    delegate = self.delegate,
    container = self.ui.Panel_525,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {2.3, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end
