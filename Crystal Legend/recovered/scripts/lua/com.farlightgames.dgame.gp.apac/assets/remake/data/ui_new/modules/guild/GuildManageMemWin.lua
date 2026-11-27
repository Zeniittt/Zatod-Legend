local base = ed.ui.popwindow
local GuildManageMemWin = newclass(base.mt)
ed.ui.GuildManageMemWin = GuildManageMemWin

function GuildManageMemWin.create()
  local self = base.create("GuildManageMemWin")
  setmetatable(self, GuildManageMemWin.mt)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  return self
end

function GuildManageMemWin:initLabels()
  ed.setLabelShadow(self.ui.label_find, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_exit, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_recruit, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_rank, ed.toccc3(0), ccp(1, 0))
end

function GuildManageMemWin:initUI()
  ed.editorui(ed.uieditor.GuildManageMemWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  local isRecruitVisible = ed.GuildManager.guildRecruitNotify >= 1
  self.ui.btn_recruit:setVisible(isRecruitVisible)
  if isRecruitVisible then
    self.ui.btn_rank:setPositionX(self.ui.btn_exit:getPositionX())
  else
    self.ui.btn_rank:setPositionX(self.ui.btn_find:getPositionX())
  end
  local limitWidth = 80
  local maxWidth = 0
  local btnLabelList = {
    self.ui.label_find,
    self.ui.label_recruit,
    self.ui.label_exit,
    self.ui.label_rank
  }
  for i, v in ipairs(btnLabelList) do
    maxWidth = math.max(maxWidth, v:getContentSize().width)
  end
  if limitWidth < maxWidth then
    local scale = limitWidth / maxWidth
    for i, v in ipairs(btnLabelList) do
      v:setScale(scale)
    end
  end
end

function GuildManageMemWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_find", function()
    ed.GuildNetwork:sendQueryGuildList()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_exit", function()
    ed.GuildManager:onClickQuit()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_recruit", function()
    ed.GuildManager.openGuildRecruit = true
    ed.GuildNetwork:sendQueryGuildList()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rank", function()
    ed.ui.GuildGameplayRanklistWin.create(ed.ui.GuildGameplayRanklistWin.TabType.Dreamland)
  end, {pressScale = 0.95})
end
