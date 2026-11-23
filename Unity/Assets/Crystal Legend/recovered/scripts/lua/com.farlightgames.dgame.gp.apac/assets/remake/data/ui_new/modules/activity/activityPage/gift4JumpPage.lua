local gift4JumpPage = newclass("g")
ed.ui.activityGift4JumpPage = gift4JumpPage

function gift4JumpPage.create(base, param, pageKey)
  local this = {}
  setmetatable(gift4JumpPage, {__index = base})
  setmetatable(this, {__index = gift4JumpPage})
  local container, ui = ed.editorui(ed.uieditor.activity_gift4jump_page)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:initView(param)
  this:setButtonClick()
  return this
end

function gift4JumpPage:initView(param)
  local task = param._tasks
  ed.setLabelStroke(self.ui.Label_btn, ccc3(139, 83, 0), 1)
  local addWid = ed.display.halfFixedWidth * 0.7
  self.ui.goto_btn:setPositionX(self.ui.goto_btn:getPositionX() + addWid / 2)
  local thisCon = self.ui.str_bg:getContentSize()
  self.ui.str_bg:setContentSize(CCSizeMake(thisCon.width + addWid, thisCon.height))
  thisCon = self.ui.panel_txt:getContentSize()
  self.ui.panel_txt:setContentSize(CCSizeMake(thisCon.width + addWid, thisCon.height))
  local cfgId = param._cfg_id
  local activityConfig = ed.getDataTable("Activity")[cfgId]
  local extraStr = activityConfig["Extra Str"] or {}
  extraStr = extraStr[1] or ""
  thisCon = self.ui.panel_txt:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.panel_txt,
    priority = -300,
    noshade = true,
    zorder = 10
  }
  self.textDragList = ed.draglist.create(info)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = extraStr,
    fontSize = 13,
    lineSpacing = 1,
    maxWidth = thisCon.width - 4,
    color = ed.toccc3(16776423),
    strokeColor = ccc3(139, 83, 0),
    strokeSize = 1.1
  })
  local _, sizeH = autoText:getContentSize()
  autoText.node:setPosition(ccp(0, thisCon.height - 12))
  self.textDragList:clearList()
  self.textDragList:addItem(autoText.node)
  self.textDragList:initListHeight(sizeH)
end

function gift4JumpPage:pageUpDate(param)
  self.param = param
end

function gift4JumpPage:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.goto_btn,
    key = "goto",
    force = true,
    mcpMode = true,
    pressScale = 0.94,
    clickHandler = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("MallGift")
      if ds then
        ed.showToast(ds)
        return
      else
        ed.pushScene(ed.ui.RechargeScene.create({page = "ActiveGift"}))
      end
    end
  })
end
