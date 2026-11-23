local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.guildClashMemberActiveWin = class
local GUILD_JOB_TO_CONFIG = {
  chairman = {
    name = T("\228\188\154\233\149\191"),
    labelColor = ed.toccc3(15492947),
    strokeColor = ed.toccc3(4271123)
  },
  elder = {
    name = T("\233\149\191\232\128\129"),
    labelColor = ed.toccc3(13534950),
    strokeColor = ed.toccc3(4271123)
  }
}
class.GUILD_JOB_TO_CONFIG = GUILD_JOB_TO_CONFIG
ed.UITool.registViewOpenFunc("guildClashMemberActiveWin", function()
  ed.GuildClashNetwork:sendQueryGuildLiveness()
  ListenEventOnce("GuildLiveness", function(data)
    ed.ui.guildClashMemberActiveWin.create(data):popWindow()
  end)
end)

function class.create(data)
  local self = base.create("guildClashMemberActiveWin")
  setmetatable(self, class.mt)
  self:init(data)
  return self
end

function class:init(data)
  self.data = data or {}
  self.memberList = self.data._member_liveness or {}
  table.sort(self.memberList, ed.cmpSort({
    {
      getValue = function(memberData)
        local memberSummary = memberData._member_summary
        local guildJob = memberSummary._job
        if guildJob == "chairman" then
          return 0
        elseif guildJob == "elder" then
          return 1
        end
        return 2
      end
    },
    {
      getValue = function(memberData)
        return memberData._guild_liveness or 0
      end,
      reverse = true
    }
  }))
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
  self.refreshCliprectConfig = {
    draglist = self.tableView.dragList
  }
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashMemberActiveWin)
  self.container:addChild(container)
  self.ui = ui
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(4666403), 1)
  self:initTableView()
  self:refreshView()
end

function class:initTableView()
  local size = self.ui.panel_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #self.memberList
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(646.5, 59.5)
    end,
    createCell = function(index)
      local data = self.memberList[index]
      local itemContainer, ui = self:createMemberItem(data)
      return itemContainer, {data = data, ui = ui}
    end,
    doPressIn = function(cell, x, y)
    end,
    doClickIn = function(cell, x, y)
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 1,
    dragMode = 1,
    touchpriority = -300,
    offset = {1, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:createMemberItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildClashMemberActiveItem)
  container:setContentSize(ui.image_bg:getContentSize())
  local memberSummary = data._member_summary
  local userSummary = memberSummary._summary
  local head = ed.getWholeHeadIcon({
    id = userSummary._avatar,
    level = userSummary._level,
    lvoffset = {x = -47, y = -38}
  })
  head:setScale(0.6)
  ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  local guildJob = memberSummary._job
  local jobCfg = class.GUILD_JOB_TO_CONFIG[guildJob]
  if jobCfg then
    ui.label_job:setVisible(true)
    ed.setLabelString(ui.label_job, jobCfg.name)
    ed.setLabelColor(ui.label_job, jobCfg.labelColor)
    ed.setLabelStroke(ui.label_job, jobCfg.strokeColor, 1)
  else
    ui.label_job:setVisible(false)
  end
  local name = ed.getPlayerName(userSummary._name, userSummary._medal, {
    anchorPoint = ccp(0, 0)
  })
  ui.panel_name:addChild(name)
  name:setScale(0.8)
  ed.layout.centerYInParent(name)
  local gs = ed.getNumberNode({
    text = memberSummary._full_gs or 0,
    folder = "hero_gs",
    padding = -1
  })
  ui.panel_gs:addChild(gs.node)
  ed.layout.centerInParent(gs.node)
  ed.setLabelStroke(ui.label_total_active, ed.toccc3(3351054), 1)
  ed.setLabelString(ui.label_total_active, data._guild_liveness)
  ed.setLabelStroke(ui.label_today_active, ed.toccc3(2825483), 1)
  ed.setLabelString(ui.label_today_active, data._today_liveness)
  return container, ui
end

function class:refreshView()
  self.tableView:reloadData()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
end

function class:addEventListener()
end
