local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.guildClashPreviewScene = class
ed.UITool.registViewOpenFunc("guildClashPreviewScene", function(param)
  local scene = ed.ui.guildClashPreviewScene.create(param)
  ed.pushScene(scene)
end)

function class.create(param)
  local self = base.create("guildClashPreviewScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.data = param.data or {}
  self:initView()
  self:adaptUI()
  self:refreshView()
  self:addTouchEvent()
  self:addEventListen()
  self:startCountDown()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashPreviewScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  local _, titleTxt = ed.UITool.createSceneTitle(T("\229\133\172\228\188\154\230\136\152"), self.ui.scene_title_bg, {
    position = ccp(13, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_exchange, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_gameplay, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(14375701), 1)
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.scene_title_bg, {left = 60, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_reward, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_exchange, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_gameplay, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
end

function class:startCountDown()
  self:refreshLeftTime()
  self.countDownTimer = self:listenTimer(Timer:Always(1, "countDownTimer"), function()
    self:refreshLeftTime()
  end)
end

function class:refreshView()
end

function class:refreshLeftTime()
  local endTime = self.data._state_end_time or 0
  local leftTime = endTime - ed.getServerTime()
  if leftTime < 0 and self.countDownTimer then
    CloseTimer(self.countDownTimer.Name)
    self.countDownTimer = nil
    ed.GuildClashNetwork:sendOpenPanel()
    return
  end
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local sec = math.floor(leftTime % 60)
  if day <= 0 and hour <= 0 then
    self.ui.label_left_time:setString(T(string.format(T("%s\229\136\134%s\231\167\146\229\144\142\229\188\128\230\148\190"), min, sec)))
  else
    self.ui.label_left_time:setString(T(string.format(T("%s\229\164\169%s\230\151\182\229\144\142\229\188\128\230\148\190"), day, hour)))
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = ed.GuildClashDefine.RULES_TITLE,
      txt = ed.GuildClashDefine.RULES_TEXT
    }):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.UITool.openView("guildClashRewardWin")
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_exchange", function()
    ed.GuildClashNetwork:sendQueryGoods()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_gameplay", function()
    ed.UITool.openView("guildClashGameGuideWin")
  end, {pressScale = 0.95, normalScale = 1})
end

function class:addEventListen()
end
