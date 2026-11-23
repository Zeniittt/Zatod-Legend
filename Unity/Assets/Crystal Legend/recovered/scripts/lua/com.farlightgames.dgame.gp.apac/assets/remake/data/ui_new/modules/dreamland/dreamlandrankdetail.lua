local DreamlandRankDetail = {}
DreamlandRankDetail.__index = DreamlandRankDetail
ed.ui.DreamlandRankDetail = DreamlandRankDetail
local DreamlandRankDetail_Scope = {}

function DreamlandRankDetail:onDestroy()
  CloseScope(DreamlandRankDetail_Scope)
  self.window:destroy({skipAnim = true})
end

function DreamlandRankDetail.Create(param)
  local obj = {}
  setmetatable(obj, DreamlandRankDetail)
  obj:initWindow(param)
  return obj
end

function DreamlandRankDetail:initWindow(param)
  self.data = param
  local window = ed.openui("dreamlandrankdetail", {priority = -130})
  self.window = window
  self.ui = window.ui
  self:InitUI()
  self:RegisterTouchEvents()
end

function DreamlandRankDetail:InitUI()
  local data = self.data
  local bg = self.ui.player_bg
  local summary = data._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    name = summary._name,
    vip = summary._vip > 0,
    babelLevel = summary._babel_level,
    medal = summary._medal
  }
  local head = ed.getWholeHeadIcon(param)
  bg:addChild(head)
  head:setScale(0.9)
  head:setPosition(ccp(85, 190))
  ed.setString(self.ui.damage, tostring(data._param1))
end

function DreamlandRankDetail:RegisterTouchEvents()
  local window = self.window
  window:registerBtn("close_btn", function()
    self:onDestroy()
  end)
  window:registerBtn("chat_btn", function()
    self:onClickChat()
  end)
end

function DreamlandRankDetail:onClickChat()
  local selectMemberObj = {}
  selectMemberObj.uid = 217
  selectMemberObj.summary = self.data._user_summary
  ed.chatNetDataMrg:reqChatContact(function()
    ed.ui.chatMain.getInstace():OnPrivateTab(selectMemberObj)
  end)
end
