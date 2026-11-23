local CupArenaOperateMenu = newclass()
ed.ui.CupArenaOperateMenu = CupArenaOperateMenu

function CupArenaOperateMenu.create(parent, rect)
  local self = {}
  setmetatable(self, CupArenaOperateMenu.mt)
  self:initUI(parent, rect)
  return self
end

function CupArenaOperateMenu:initUI(parent, rect)
  local container, ui = ed.editorui(ed.uieditor.CupArenaOperateItem)
  container:setContentSize(ui.bg:getContentSize())
  parent:addChild(container)
  self.ui = ui
  self.container = container
  self.parent = parent
  self.safeRect = rect
end

function CupArenaOperateMenu:show(headPos, headSize, operateData)
  self.operateData = operateData
  self.container:setVisible(true)
  headPos = self.parent:convertToNodeSpace(headPos)
  local containerSize = self.container:getContentSize()
  local topY = headPos.y + headSize.height * 0.5 + containerSize.height
  local btnPosY = containerSize.height
  local spaceY = 1
  local showPos = ccp(headPos.x - 0.27 * containerSize.width, 0)
  if topY > self.safeRect:getMaxY() then
    self.ui.bg:setScaleY(-1)
    btnPosY = btnPosY - 22.5
    showPos.y = headPos.y - headSize.height * 0.5 - containerSize.height
  else
    self.ui.bg:setScaleY(1)
    btnPosY = btnPosY - 7.5
    showPos.y = headPos.y + headSize.height * 0.5
  end
  local sortArr = {
    self.ui.btn_detail,
    self.ui.btn_battle_info
  }
  for i, v in ipairs(sortArr) do
    local vSize = v:getContentSize()
    v:setPosition(containerSize.width * 0.5, btnPosY - vSize.height * 0.5)
    btnPosY = btnPosY - vSize.height - spaceY
  end
  self.container:setPosition(showPos)
  self.ui.bg:setPosition(containerSize.width * 0.5, containerSize.height * 0.5)
end

function CupArenaOperateMenu:hide()
  self.container:setVisible(false)
end

function CupArenaOperateMenu:registerEvents(delegate)
end

function CupArenaOperateMenu:registerTouchEvent(delegate)
  delegate:btRegisterOutClick({
    area = self.ui.bg,
    key = "operate_menu_out_click",
    pressHandler = function()
      self:hide()
    end,
    force = true
  })
  delegate:btRegisterButtonClick({
    button = self.ui.btn_detail,
    key = "btn_detail",
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      self:onDetailEvent()
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1,
    pressScale = 0.95
  })
  delegate:btRegisterButtonClick({
    button = self.ui.btn_battle_info,
    key = "btn_battle_info",
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      self:onBattleInfoEvent()
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.3,
    priority = -1,
    pressScale = 0.95
  })
end

function CupArenaOperateMenu:onDetailEvent(...)
  if nil == self.operateData then
    return
  end
  ed.CupArenaNetwork:sendViewUser(self.operateData.roleId)
end

function CupArenaOperateMenu:onBattleInfoEvent(...)
  if nil == self.operateData then
    return
  end
  ed.CupArenaNetwork:sendGetReply(nil, self.operateData.matchId)
end

function CupArenaOperateMenu:containsPoint(x, y)
  return self.container:isVisible() and ed.containsPoint(self.ui.bg, x, y)
end
