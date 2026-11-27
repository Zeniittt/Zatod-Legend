local base = ed.ui.popwindow
local friendMainWin = newclass(base.mt)
ed.ui.friendMainWin = friendMainWin
local SUB_PANEL_ENUM = {
  SUB_PANEL_FRIEND = "friend",
  SUB_PANEL_ADD = "addFriend",
  SUB_PANEL_REQUEST = "requestFriend"
}
friendMainWin.SUB_PANEL_ENUM = SUB_PANEL_ENUM
local tabConfig = {
  {
    text = T("\229\165\189\229\143\139"),
    key = SUB_PANEL_ENUM.SUB_PANEL_FRIEND,
    uiName = "btnBg1",
    uiSelect = "btnSelect1",
    uiLabel = "btnLabel1"
  },
  {
    text = T("\230\183\187\229\138\160"),
    key = SUB_PANEL_ENUM.SUB_PANEL_ADD,
    uiName = "btnBg2",
    uiSelect = "btnSelect2",
    uiLabel = "btnLabel2"
  },
  {
    text = T("\231\148\179\232\175\183"),
    key = SUB_PANEL_ENUM.SUB_PANEL_REQUEST,
    uiName = "btnBg3",
    uiSelect = "btnSelect3",
    uiLabel = "btnLabel3"
  }
}

function friendMainWin.getFriendMainPanel()
  return ed.getPopWindow("friendMainWin")
end

function friendMainWin.getSubPanelShow(tabKey)
  local mainPanel = ed.getPopWindow("friendMainWin")
  if mainPanel then
    local subPanel = mainPanel.subPanelTable[tabKey]
    if subPanel then
      return subPanel:isVisible()
    end
  end
  return false
end

function friendMainWin.create(param)
  local self = base.create("friendMainWin")
  setmetatable(self, friendMainWin.mt)
  param = param or {}
  self:init(param)
  return self
end

function friendMainWin:init(param)
  self.selectTabKey = param.selectTabKey or SUB_PANEL_ENUM.SUB_PANEL_FRIEND
  self.subPanelTable = {}
  self.friendsData = {}
  self.param = param
  self:initView()
  self:addEventListener()
  self:setBtnSelect(self.selectTabKey)
  self:show()
end

function friendMainWin:initView()
  local container, ui = ed.editorui(ed.uieditor.friendMain)
  self.ui = ui
  self.container:addChild(container)
  self:initTab()
  self:refreshRedPoint()
end

function friendMainWin:initTab()
  for index, config in ipairs(tabConfig) do
    local btn = self.ui[config.uiName]
    ed.setLabelStroke(self.ui[config.uiLabel], ccc3(0, 0, 0), 1)
    ed.setString(self.ui[config.uiLabel], config.text)
    self:btRegisterButtonClick({
      button = self.ui[config.uiName],
      key = config.key,
      clickHandler = function()
        self:setBtnSelect(config.key)
        self:openSubPanel(config.key)
      end
    })
  end
end

function friendMainWin:setBtnSelect(key)
  self.selectTabKey = key
  for index, config in ipairs(tabConfig) do
    local btnSelect = self.ui[config.uiSelect]
    if config.key == key then
      btnSelect:setVisible(true)
    else
      btnSelect:setVisible(false)
    end
  end
  self:openSubPanel(key)
end

function friendMainWin:openSubPanel(key)
  local needCreate = true
  for subPanelKey, subPanel in pairs(self.subPanelTable) do
    if subPanel then
      if key == subPanelKey then
        needCreate = false
        subPanel:setVisible(true)
      else
        subPanel:setVisible(false)
      end
    end
  end
  if needCreate then
    local subPanel = self:createSubPanel(key)
    if subPanel then
      self.subPanelTable[key] = subPanel
    end
  end
end

function friendMainWin:createSubPanel(key)
  local subPanel
  if key == SUB_PANEL_ENUM.SUB_PANEL_FRIEND then
    subPanel = ed.ui.friendPanel.create(self, self.param.subParam)
  elseif key == SUB_PANEL_ENUM.SUB_PANEL_ADD then
    subPanel = ed.ui.addFriendPanel.create(self, self.param.subParam)
  elseif key == SUB_PANEL_ENUM.SUB_PANEL_REQUEST then
    subPanel = ed.ui.requestFriendPanel.create(self, self.param.subParam)
  end
  if subPanel then
    self.ui.subPanelBase:addChild(subPanel.container)
    ed.layout.centerInParent(subPanel.container)
    return subPanel.container
  end
end

function friendMainWin:refreshRedPoint()
  local redPointVisible = ed.applyFriend.getApplyFriendCount() > 0
  self.ui.red_point3:setVisible(redPointVisible)
end

function friendMainWin:addEventListener()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        self.clickOutSide = false
        if not ed.containsPoint(self.ui.friendPanelBg, x, y) and not ed.containsPoint(self.ui.btnPanelBg, x, y) then
          self.clickOutSide = true
        end
      elseif event == "ended" and not ed.containsPoint(self.ui.friendPanelBg, x, y) and not ed.containsPoint(self.ui.btnPanelBg, x, y) and self.clickOutSide then
        self:close()
      end
      return false
    end,
    key = "close",
    priority = -100
  })
  self:listenEvent("refreshApplyFriend", function()
    self:refreshRedPoint()
  end)
end

function friendMainWin:close()
  self:destroy()
end
