local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.SoloRoomSwitch = class

function class:initLabels()
  ed.setLabelStroke(self.ui.lab_title_slr, ed.toccc3(6373674), 1.5)
  ed.setLabelStroke(self.ui.lab_title_1, ed.toccc3(5389071), 1)
  ed.setLabelStroke(self.ui.lab_title_2, ed.toccc3(5389071), 1)
  ed.setLabelStroke(self.ui.lab_title_3, ed.toccc3(5389071), 1)
end

function class:initUI()
  ed.editorui(ed.uieditor.SoloRoomSwitchWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
end

function class:onClickCreate()
  if self.isMatching then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  self.warnWindow = ed.ui.SkillMultiPlayerWarn.create({createroom = true, mode = "chess"})
  self.warnWindow:popWindow()
  self.warnWindow:show({
    endCall = function()
      ed.SoloNetwork:sendTeamCreate("solo_casual")
    end
  })
end

function class:onClickJoin()
  if self.isMatching then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  self.warnWindow = ed.ui.SkillMultiPlayerWarn.create({joinroom = true, mode = "chess"})
  self.warnWindow:popWindow()
  self.warnWindow:show({
    clickCall = function(roomid)
      ed.SoloNetwork:sendTeamQuery(roomid)
    end
  })
end

function class:onClickMatch()
  if self.isMatching then
    ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
    return
  end
  local version = ed.storage.getString("current-version")
  ed.SoloNetwork:sendChessMatchStart(version, "casual")
end

function class:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_createroom", function()
    ed.ui.SoloCreateRoomSwitchWin.create():popWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_joinroom", function()
    self:onClickJoin()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_close_slr", function()
    if self.isMatching then
      ed.showToast(T("\230\173\163\229\156\168\229\140\185\233\133\141\228\184\173"))
      return
    end
    self:destroy()
  end, {pressScale = 0.75, normalScale = 0.8})
end

function class:closeWarn()
  if self.warnWindow then
    self.warnWindow:destroy(true)
    self.warnWindow = nil
  end
end

function class:onTeamJoinFinish()
  self:closeWarn()
  self:destroy({skipAnim = true})
end

function class:onEventChessMatchStop()
  self.isMatching = false
  self.ui.btn_close_slr:setVisible(true)
end

function class:backWarn()
  if self.warnWindow then
    local ttype = self.warnWindow.warnType
    if ttype == "joinroom" then
      if not tolua.isnull(self.warnWindow) then
        self.warnWindow:showJoinWarn(false)
      end
    else
      self:closeWarn()
    end
  end
end

function class:onEventChessMatchStart()
  self.isMatching = true
  self.ui.btn_close_slr:setVisible(false)
end

function class:registerEvents()
  self:listenEvent("SoloTeamJoin", function()
    self:onTeamJoinFinish()
  end)
  self:listenEvent("SoloMatchCancel", function()
    self:closeWarn()
    self:onEventChessMatchStop()
  end)
  self:listenEvent("EventChessTeamErrorCode", function()
    self:backWarn()
  end)
  self:listenEvent("SoloMatchStart", function()
    self:onEventChessMatchStart()
  end)
  self:listenEvent("SkillMatchTimoutNotify", function()
    self:onEventChessMatchStop()
  end)
  self:listenEvent("SkillJoinTimoutNotify", function()
    self:onEventChessMatchStop()
  end)
end

function class.create()
  local self = base.create("SoloRoomSwitch", {notBlurBg = true})
  setmetatable(self, class.mt)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  return self
end
