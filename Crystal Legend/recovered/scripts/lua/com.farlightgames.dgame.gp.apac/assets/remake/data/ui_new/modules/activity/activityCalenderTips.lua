local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.activityCalenderTips = class
ed.UITool.registViewOpenFunc("activityCalenderTips", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("activityCalenderTips")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param
  self.title = param.title
  self.startTime = param.startTime
  self.endTime = param.endTime
  self.rules = param.rules
  self:initView()
  self:adaptView()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_calender_tips)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelString(self.ui.label_title, self.title or "")
  local titleSize = self.ui.label_title:getContentSize()
  local imageSize = self.ui.image_left:getContentSize()
  self.ui.image_left:setPositionX(self.ui.label_title:getPositionX() - titleSize.width / 2 - imageSize.width / 2 - 20)
  self.ui.image_right:setPositionX(self.ui.label_title:getPositionX() + titleSize.width / 2 + imageSize.width / 2 + 20)
  local startYear, startMonth, startDay, startHour, startMinutes, startSecond = ed.time2YMDHMS(self.startTime)
  local endYear, endMonth, endDay, endHour, endMinutes, endSecond = ed.time2YMDHMS(self.endTime)
  local timeStr = string.format(T("%.2d\230\156\136%.2d\230\151\165 %.2d:%.2d - %.2d\230\156\136%.2d\230\151\165 %.2d:%.2d") .. ed.getUTCLabel(), startMonth, startDay, startHour, startMinutes, endMonth, endDay, endHour, endMinutes)
  ed.setLabelString(self.ui.label_time, timeStr)
  self.autoText = ed.ui.autoText.new()
  self.autoText:initParam({
    context = self.rules,
    fontSize = 16,
    lineSpacing = 4,
    maxWidth = self.ui.layer_text:getContentSize().width
  })
  self.ui.layer_text:addChild(self.autoText.node)
  self.autoText.node:setPosition(0, self.ui.layer_text:getContentSize().height - 8)
  self:show()
end

function class:adaptView()
  local width, height = self.autoText:getCurContentSize()
  local offsetH = math.max(height - self.ui.layer_text:getContentSize().height, 0)
  local bgSize = self.ui.image_bg:getContentSize()
  self.ui.image_bg:setContentSize(CCSizeMake(bgSize.width, bgSize.height + offsetH))
  self.ui.label_title:setPositionY(self.ui.label_title:getPositionY() + offsetH)
  self.ui.image_left:setPositionY(self.ui.image_left:getPositionY() + offsetH)
  self.ui.image_right:setPositionY(self.ui.image_right:getPositionY() + offsetH)
  self.ui.label_time:setPositionY(self.ui.label_time:getPositionY() + offsetH)
  self.ui.layer_text:setPositionY(self.ui.layer_text:getPositionY() + offsetH)
end

function class:addEventListener()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "ended" and not ed.containsPoint(self.ui.image_bg, x, y) then
        self:close()
        return false
      end
      return false
    end,
    key = "close",
    priority = -100
  })
end

function class:close()
  self:destroy()
end
