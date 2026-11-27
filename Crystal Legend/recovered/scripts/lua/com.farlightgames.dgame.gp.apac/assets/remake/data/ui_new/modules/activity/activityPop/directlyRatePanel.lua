local base = ed.ui.popwindow
local directlyRatePanel = newclass(base.mt)
ed.ui.directlyRatePanel = directlyRatePanel

function directlyRatePanel.create()
  local self = base.create("directlyRatePanel")
  setmetatable(self, directlyRatePanel.mt)
  self:initView()
  self:setTextColor()
  self:addEventListen()
  return self
end

function directlyRatePanel:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_directly_rate)
  self.container:addChild(container)
  self.ui = ui
end

function directlyRatePanel:setTextColor()
  local ui = self.ui
  self.ui.text_tips:setFontName(ed.font)
  self.ui.text_left:setFontName(ed.font)
  self.ui.text_right:setFontName(ed.font)
  ed.setLabelStroke(self.ui.text_tips, ed.toccc3(1124877), 1)
  ed.setLabelStroke(self.ui.text_left, ed.toccc3(4348443), 1)
  ed.setLabelStroke(self.ui.text_right, ed.toccc3(7155218), 1)
  self.ui.label_title:setFontName(ed.fontBold)
  self.ui.label_title:limitWidthByScale(250)
  ed.setLabelDimensions(ui.text_tips, CCSizeMake(432.5, 50))
end

function directlyRatePanel:addEventListen()
  self:btRegisterButtonClick({
    button = self.ui.closeBtn,
    press = self.ui.closeBtn_press,
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_switch_left,
    press = self.ui.btn_switch_left_press,
    clickHandler = function()
      self:onClickChange("recommend")
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_switch_right,
    press = self.ui.btn_switch_right_press,
    clickHandler = function()
      self:onClickChange("directlyRate")
    end
  })
end

function directlyRatePanel:onClickChange(keyName)
  if keyName == "recommend" then
    local url = "https://q.lilithgame.com/deliver?sid=64902acaa3e04b00484d90ce"
    if ed.isAreaOverSea() then
      url = "https://q.farlightgames.com/temporary/z9xrk8qh57?value_url_key=" .. ed.toLLHLan()
    end
    ed.openURL(url)
  end
  if keyName == "directlyRate" then
    if EDFLAGIOS then
      ed.openAppStore()
    end
    if EDFLAGANDROID then
      local url = "https://www.taptap.cn/app/16734"
      if ed.isAreaOverSea() then
        url = "https://play.google.com/store/apps/details?id=com.farlightgames.dgame.gp.apac"
      end
      ed.openURL(url)
    end
  end
end

function ed.checkShowDirectlyRate(taskInfo)
  ed.isOpenDirectlyRate = false
  if not taskInfo then
    return
  end
  if taskInfo._act_id == 199917 then
    ed.isOpenDirectlyRate = true
  end
end

function ed.showDirectlyRate()
  if not EDFLAGIOS and not EDFLAGANDROID then
    return
  end
  if ed.isOpenDirectlyRate then
    ed.ui.directlyRatePanel.create():popWindow()
  end
end
