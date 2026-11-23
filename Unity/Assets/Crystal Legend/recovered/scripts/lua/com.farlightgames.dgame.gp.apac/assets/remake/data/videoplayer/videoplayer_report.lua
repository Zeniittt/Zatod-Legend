VideoPlayerReport = {}
VideoPlayerReport.__index = VideoPlayerReport
local base = ed.ui.popwindow
setmetatable(VideoPlayerReport, base.mt)

function VideoPlayerReport.create(data)
  local panel = base.create("VideoPlayerReport")
  setmetatable(panel, VideoPlayerReport)
  panel:initData(data)
  panel:initAppearance()
  panel:registerTouchHandler()
  return panel
end

function VideoPlayerReport:destroy()
  ed.playEffect(ed.sound.deo.common_close_popup_window)
  if self.mainLayer then
    self.mainLayer:setTouchEnabled(false)
    self.mainLayer:removeFromParentAndCleanup(true)
    self.mainLayer = nil
  end
end

function VideoPlayerReport:initData(data)
  local info = data.info
  self.info = info
  self.uid = info._user_key._uid
  self.sid = info._user_key._svr_id
  self.barrage = info._content
  self.summary = ed.videoplayer.manager:getUserSummary(self.sid, self.uid)
end

function VideoPlayerReport:initAppearance()
  local mainLayer = self.mainLayer
  local container, ui = ed.editorui(ed.uieditor.videoplayer_report)
  self.container = container
  self.ui = ui
  mainLayer:addChild(container)
  local summary = self.summary
  if summary then
    local name = summary._name == "NickName" and "" or summary._name
    local param = {
      id = summary._avatar,
      level = summary._level,
      name = name,
      vip = summary._vip > 0,
      scale = 0.6
    }
    if summary._medal then
      param.medal = summary._medal
    end
    if summary._babel_level then
      param.babelLevel = summary._babel_level
    end
    local playerHead = ed.getWholeHeadIcon(param)
    self.ui.node_head:addChild(playerHead)
  end
end

function VideoPlayerReport:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.btn_report,
    press = self.ui.btn_report_press,
    key = "btn_report",
    clickHandler = function()
      ed.UploadImageNetwork:muteUser(self.sid, self.uid, self.barrage)
      self.info._is_mute = 1
      ed.showToast(T("\229\177\143\232\148\189\230\136\144\229\138\159\239\188\129"))
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "btn_destroy",
    clickHandler = function()
      self:destroy()
    end,
    priority = 1
  })
end
