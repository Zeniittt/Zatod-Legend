local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.speedHelperWindow = class
class.TEXT = T("1.\231\153\189\232\153\142\229\176\143\229\138\169\230\137\139\229\138\160\233\128\159\230\149\136\230\158\156\228\184\186\230\184\184\230\136\143\229\134\133\229\133\168\229\177\128\229\138\160\233\128\159\227\128\130\232\175\183\230\179\168\230\132\143\239\188\140\228\189\156\231\148\168\232\140\131\229\155\180\228\184\141\229\140\133\230\139\172\239\188\154\230\154\180\232\181\176\230\163\139\229\146\140\232\175\184\231\142\139\228\186\137\233\156\184\227\128\130<br/><br/>") .. T("2.\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17620\231\186\167\229\143\175\232\167\163\233\148\1292\229\128\141\233\128\159\239\188\14050\231\186\167\232\167\163\233\148\1293\229\128\141\233\128\159\239\188\14080\231\186\167\232\167\163\233\148\1290.5\229\128\141\233\128\159\227\128\130<br/><br/>") .. T("3.\228\184\186\228\191\157\233\154\156\232\180\166\229\143\183\229\174\137\229\133\168\229\146\140\230\184\184\230\136\143\231\168\179\229\174\154\239\188\140\231\153\189\232\153\142\229\176\143\229\138\169\230\137\139\230\151\160\230\179\149\228\184\142\228\187\187\228\189\149\231\172\172\228\184\137\230\150\185\229\138\160\233\128\159\232\189\175\228\187\182\229\133\188\229\174\185\227\128\130<br/><br/>")
local speed_list = {
  0.5,
  1,
  2,
  3
}
ed.speed_list = speed_list
local speed_config = {
  [0.5] = {
    speed = 0.5,
    realSpeed = 0.5,
    playerLevelKey = "SpeedHelper*0.5"
  },
  [1] = {speed = 1, realSpeed = 1},
  [2] = {
    speed = 2,
    realSpeed = 2,
    playerLevelKey = "SpeedHelper*2"
  },
  [3] = {
    speed = 3,
    realSpeed = 3,
    playerLevelKey = "SpeedHelper*3"
  }
}
ed.speed_config = speed_config
ed.UITool.registViewOpenFunc("speedHelperWindow", function()
  local window = ed.ui.speedHelperWindow.create()
  window:popWindow()
  window:show()
end)

function class.create()
  local self = base.create("speedHelperWindow")
  setmetatable(self, class.mt)
  self:init()
  return self
end

function class:init()
  self.mgr = ed.speedHelperMgr.getInstance()
  self.speed = self.mgr:getSpeed()
  self.isShowFloating = self.mgr:getIsShowFloating()
  self.index = 1
  self.isChange = false
  for index, speed in pairs(ed.speed_list) do
    if self.speed == speed then
      self.index = index
      break
    end
  end
  self.isPause = self.mgr:getIsPause()
  if not self.isShowFloating then
    self.isShowFloating = not self.isShowFloating
    self.mgr:setShowFloating(self.isShowFloating)
  end
  self:initView()
  self:refreshUI()
  self:addTouchEvent()
  self:registerBtnBar()
  self:addEventListener()
  ed.storage.setValue("HelperRedPoint", true)
  ed.redPointMgr.getInstance():setNodeValue("player_info_speed_helper_entry", 0)
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.speedHelperWindow)
  self.container:addChild(container)
  self.ui = ui
  self:initLabels()
  ed.right2(self.ui.label_check_box_tips, self.ui.btn_check_box, 10)
end

local function createGradientLabel(param)
  local text, fontName, startColor, endColor, fontSize, strokeColor, strokeSize, downStrokeColor, downStrokeSize = param.text or "", param.fontName or ed.font, param.startColor or ed.toccc3(6909604), param.endColor or ed.toccc3(10075095), param.fontSize or 16, param.strokeColor or ed.toccc3(16775922), param.strokeSize or 2.5, param.downStrokeColor or ed.toccc3(5591682), param.downStrokeSize or 4
  local ui = CCLayer:create()
  local ui_up = ed.ui.gradientLabel.create({
    text = text,
    fontSize = fontSize,
    fontName = fontName,
    startColor = startColor,
    endColor = endColor,
    strokeColor = strokeColor,
    strokeSize = strokeSize
  })
  local ui_down = ed.createLabelTTF(text, fontSize, fontName)
  ed.setLabelStroke(ui_down, downStrokeColor, downStrokeSize)
  ui:addChild(ui_down)
  ui:addChild(ui_up.node)
  return ui, {
    size = ui_down:getContentSize(),
    up = ui_up,
    down = ui_down
  }
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_check_box_tips, ed.toccc3(2300706), 1.5)
  local title_left, title_left_param = createGradientLabel({
    text = T("\231\153\189\232\153\142\229\176\143\229\138\169\230\137\139"),
    fontSize = 40,
    fontName = ed.fontBold,
    startColor = ed.toccc3(6909604),
    endColor = ed.toccc3(10075095),
    strokeColor = ed.toccc3(16775922),
    strokeSize = 2.5,
    downStrokeColor = ed.toccc3(5591682),
    downStrokeSize = 4
  })
  self.ui.title_pos:addChild(title_left)
  local title_right, title_right_param = createGradientLabel({
    text = T("(\230\181\139\232\175\149\231\137\136)"),
    fontSize = 23,
    fontName = ed.fontBold,
    startColor = ed.toccc3(6909604),
    endColor = ed.toccc3(10075095),
    strokeColor = ed.toccc3(16775922),
    strokeSize = 2.5,
    downStrokeColor = ed.toccc3(5591682),
    downStrokeSize = 4
  })
  self.ui.title_pos:addChild(title_right)
  local totalWid = title_left_param.size.width + title_right_param.size.width + 2
  if totalWid < 340 then
    title_left:setPositionX(-0.5 * totalWid + 0.5 * title_left_param.size.width)
    title_right:setPositionX(0.5 * totalWid - 0.5 * title_right_param.size.width)
    ed.UITool.setPositionBy(title_right, ccp(0, -0.5 * (title_left_param.size.height - title_right_param.size.height)))
  else
    local scale = 400 / totalWid
    local heiScale = math.min(25 / title_right_param.size.height, 1)
    title_left:setPositionY(15)
    title_right:setPositionY(-20)
    title_right_param.up.node:setScale(math.max(math.min(scale, heiScale), 0.6))
    title_right_param.down:setScale(math.max(math.min(scale, heiScale), 0.6))
    title_left_param.up.node:setScale(scale)
    title_left_param.down:setScale(scale)
  end
  local speedInfo, speedInfoUIParam = createGradientLabel({
    text = T("x%s\229\128\141", 1),
    fontSize = 35,
    fontName = ed.fontBold,
    startColor = ed.toccc3(7305684),
    endColor = ed.toccc3(9138684),
    strokeColor = ed.toccc3(16775922),
    strokeSize = 2.5,
    downStrokeColor = ed.toccc3(5591682),
    downStrokeSize = 4
  })
  ed.UITool.replaceUINew(self.ui, "speed_rate_pos", speedInfo)
  self.speedInfoUIParam = speedInfoUIParam
  local widLimit = EDCurLanguage == "ko" and 230 or 270
  self.ui.label_tips:limitWidthByScale(widLimit)
end

function class:refreshUI()
  self:refreshBar()
  self:refreshBtnPause()
  local speed = ed.speed_list[self.index] or ed.speed_list[1]
  local speedCfg = ed.speed_config[speed]
  local str = T("x%s\229\128\141", speed)
  self.speedInfoUIParam.down:setString(str)
  self.speedInfoUIParam.up:setString(str)
  self.ui.image_check:setVisible(not self.isShowFloating)
  if self.mgr:checkSpeedIsUnlock(3) then
    ed.setLabelString(self.ui.label_tips, T("\231\153\189\232\153\142\229\183\178\229\135\134\229\164\135\229\176\177\231\187\170\239\188\140\231\173\137\229\190\133\233\152\159\233\149\191\230\140\135\228\187\164\227\128\130"))
  else
    ed.setLabelString(self.ui.label_tips, T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17650\231\186\167\239\188\140\229\188\128\229\144\175x3\229\128\141\229\138\160\233\128\159\228\184\138\233\153\144"))
  end
end

function class:refreshBar()
  local percent = (self.index - 1) / (#ed.speed_list - 1)
  local panelBarClipSize = self.ui.panel_bar_clip:getContentSize()
  self.ui.panel_bar_clip:setClipRect(CCRectMake(0, 0, panelBarClipSize.width * percent, panelBarClipSize.height))
  local btnBarPosX = panelBarClipSize.width * percent
  btnBarPosX = math.min(btnBarPosX, panelBarClipSize.width - 17)
  btnBarPosX = math.max(btnBarPosX, 17)
  self.ui.btn_bar:setPositionX(btnBarPosX)
end

function class:refreshBtnPause()
  if self.isPause then
    ed.setTexture(self.ui.btn_pause, "UI/alpha/1080P/helper/helper_continue.png")
    ed.setLabelString(self.ui.label_pause, T("\231\187\167\231\187\173"))
  else
    ed.setTexture(self.ui.btn_pause, "UI/alpha/1080P/helper/helper_pause.png")
    ed.setLabelString(self.ui.label_pause, T("\230\154\130\229\129\156"))
  end
end

function class:onClickBtnPause()
  self.isChange = true
  self.isPause = not self.isPause
  self:refreshUI()
  self.mgr:setPause(self.isPause)
end

function class:onClickBtnDown()
  if self.index <= 1 then
    return
  end
  local index = self.index - 1
  local speed = ed.speed_list[index] or 1
  if not self.mgr:checkSpeedIsUnlock(speed) then
    ed.showToast(string.format(T("%s\229\128\141\233\128\159\230\156\170\232\167\163\233\148\129"), speed))
    return
  end
  self.isChange = true
  self.index = index
  self:refreshUI()
  self.mgr:setSpeed(speed)
end

function class:onClickBtnUp()
  if self.index >= #ed.speed_list then
    return
  end
  local index = self.index + 1
  local speed = ed.speed_list[index] or 1
  if not self.mgr:checkSpeedIsUnlock(speed) then
    ed.showToast(string.format("%s\229\128\141\233\128\159\230\156\170\232\167\163\233\148\129", speed))
    return
  end
  self.isChange = true
  self.index = index
  self:refreshUI()
  self.mgr:setSpeed(speed)
end

function class:onClickCheckBox()
  self.isShowFloating = not self.isShowFloating
  self:refreshUI()
  self.mgr:setShowFloating(self.isShowFloating)
end

function class:onClickBtnRule()
  ed.ui.commonRulePop.create({
    title = T("\232\175\180\230\152\142"),
    txt = self.TEXT
  }):popWindow()
end

function class:onWinDestroy()
  if self.isChange then
    self.mgr:reportServer()
  end
  base.onWinDestroy(self)
end

function class:registerBtnBar()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        if ed.containsPoint(self.ui.btn_bar, x, y) then
          self.clickBtnBar = true
          self.startX = x
          self.startPosX = self.ui.btn_bar:getPositionX()
          self.targetIndex = nil
        end
      elseif event == "moved" then
        if self.clickBtnBar then
          local panelBarClipSize = self.ui.panel_bar_clip:getContentSize()
          local btnBarPosX = self.startPosX + x - self.startX
          local minDistance, targetIndex
          for index = 1, #ed.speed_list do
            local indexPosX = (index - 1) * self.ui.panel_bar_clip:getContentSize().width / (#ed.speed_list - 1)
            local distance = math.abs(btnBarPosX - indexPosX)
            if not minDistance or minDistance > distance then
              minDistance = distance
              targetIndex = index
            end
          end
          if targetIndex then
            self.targetIndex = targetIndex
            local percent = (targetIndex - 1) / (#ed.speed_list - 1)
            self.ui.panel_bar_clip:setClipRect(CCRectMake(0, 0, panelBarClipSize.width * percent, panelBarClipSize.height))
            btnBarPosX = panelBarClipSize.width * percent
            btnBarPosX = math.min(btnBarPosX, panelBarClipSize.width - 17)
            btnBarPosX = math.max(btnBarPosX, 17)
            self.ui.btn_bar:setPositionX(btnBarPosX)
          end
        end
      elseif event == "ended" then
        if self.clickBtnBar and self.targetIndex then
          local speed = ed.speed_list[self.targetIndex] or 1
          if not self.mgr:checkSpeedIsUnlock(speed) then
            ed.showToast(string.format("%s\229\128\141\233\128\159\230\156\170\232\167\163\233\148\129", speed))
            self:refreshBar()
            return
          end
          self.index = self.targetIndex
          self:refreshUI()
          self.mgr:setSpeed(speed)
        end
        self.clickBtnBar = false
        self.startX = nil
        self.targetIndex = nil
      end
    end,
    key = "btn_bar"
  })
end

function class:onClickClose()
  if ed.getCurrentScene().identity == "battle" then
    self:destroy({skipAnim = true})
  else
    self:destroy()
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_pause", function()
    self:onClickBtnPause()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_down", function()
    self:onClickBtnDown()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_up", function()
    self:onClickBtnUp()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_check_box", function()
    self:onClickCheckBox()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:onClickBtnRule()
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "clickOut",
    clickHandler = function()
      self:onClickClose()
    end,
    force = true
  })
end

function class:addEventListener()
end
