local class = newclass("g")
ed.ui.activityKingsPvpShow = class

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.endTime = param._end_time
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.pageKey = pageKey
  self.isVisible = true
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_kings_pvp_show_page)
  self.container = container
  self.ui = ui
  self:initLabels()
  self:adaptUI()
end

function class:initLabels()
end

function class:adaptUI()
  local winSize = ed.display.winSize
  local detail3Width = self.ui.image_detail3:getContentSize().width
  local detail3PosX = ed.getWorldPos(self.ui.image_detail3).x
  local offsetX = detail3PosX + detail3Width / 2 - winSize.width
  if 0 < offsetX then
    self.ui.image_detail1:setPositionX(self.ui.image_detail1:getPositionX() - offsetX)
    self.ui.image_detail2:setPositionX(self.ui.image_detail2:getPositionX() - offsetX)
    self.ui.image_detail3:setPositionX(self.ui.image_detail3:getPositionX() - offsetX)
    self.ui.image_icon:setPositionX(self.ui.image_icon:getPositionX() - offsetX)
  end
end

function class:onClickBtnGo()
  ed.UITool.openView("KingsPvpMainScene")
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_go", function()
    self:onClickBtnGo()
  end, {pressScale = 0.95})
end

function class:addEventListener()
end
