local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.guildClashResultWin = class
ed.UITool.registViewOpenFunc("guildClashResultWin", function()
  ed.GuildClashNetwork:sendQueryHistory()
  ListenEventOnce("GuildClashHistory", function(data)
    ed.ui.guildClashResultWin.create(data):popWindow()
  end)
end)

function class.create(data)
  local self = base.create("guildClashResultWin")
  setmetatable(self, class.mt)
  self:init(data)
  return self
end

function class:init(data)
  self.data = data or {}
  self.battleHistory = self.data._battle_history or {}
  self:initView()
  self:addTouchEvent()
  self.refreshCliprectConfig = {
    draglist = self.dragList
  }
  self:refreshView()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashResultWin)
  self.container:addChild(container)
  self.ui = ui
  self.ui.label_result:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_result, ed.toccc3(8272405), 1)
  ed.setLabelStroke(self.ui.label_result_tips, ed.toccc3(4666403), 1)
  self:initDragList()
end

function class:initDragList()
  self.panelListSize = self.ui.panel_list:getContentSize()
  self.dragList = ed.UITool.createDraglist(self.ui.panel_list)
end

function class:refreshView()
  self.dragList:clearList()
  local winAmount, loseAmount = 0, 0
  local posY = 0
  for index, historyData in ipairs(self.battleHistory) do
    local container, ui = self:createResultItem(historyData)
    self.dragList:addItem(container)
    local itemSize = container:getContentSize()
    container:setPosition(ccp(0, self.panelListSize.height - posY - itemSize.height / 2))
    posY = posY + container:getContentSize().height
    if historyData._is_win == 1 then
      winAmount = winAmount + 1
    else
      loseAmount = loseAmount + 1
    end
  end
  self.dragList:initListHeight(posY)
  ed.setLabelString(self.ui.label_result, T("%s\232\131\156%s\232\180\159", winAmount, loseAmount))
  ed.right2(self.ui.label_result, self.ui.label_result_tips, 10)
end

function class:createResultItem(historyData)
  local container, ui = ed.editorui(ed.uieditor.GuildClashResultItem)
  container:setContentSize(ui.image_bg_win:getContentSize())
  ui.label_guild_name:setFontName(ed.fontBold)
  ed.setLabelString(ui.label_turn, T("\231\172\172%s\232\189\174", historyData._round_id))
  if historyData._is_win == 1 then
    ui.image_bg_win:setVisible(true)
    ui.image_bg_lose:setVisible(false)
    ui.image_result_win:setVisible(true)
    ui.image_result_lose:setVisible(false)
  else
    ui.image_bg_win:setVisible(false)
    ui.image_bg_lose:setVisible(true)
    ui.image_result_win:setVisible(false)
    ui.image_result_lose:setVisible(true)
  end
  local guildSummary = historyData._oppo_guild or {}
  local avatarData = ed.analyzeAvatar(guildSummary._avatar or 1)
  local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  ui.panel_guild_icon:addChild(guildIcon)
  ed.layout.centerInParent(guildIcon)
  ed.setLabelString(ui.label_guild_name, guildSummary._name or T("\232\189\174\231\169\186"))
  return container, ui
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy()
  end)
end
