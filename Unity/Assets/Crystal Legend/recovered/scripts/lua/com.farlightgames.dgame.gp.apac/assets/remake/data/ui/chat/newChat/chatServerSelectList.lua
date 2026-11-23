local base = ed.ui.popwindow
local chatServerSelectList = newclass(base.mt)
chatServerSelectList.__index = chatServerSelectList
ed.ui.chatServerSelectList = chatServerSelectList

function chatServerSelectList:onDestory()
  self:destroy({skipAnim = true})
end

function chatServerSelectList.create(parmas)
  local self = base.create("chatServerSelectList")
  setmetatable(self, chatServerSelectList.mt)
  self.server_type = {
    [1] = "ios",
    [2] = "ios_pb",
    [3] = "android",
    [4] = "qihoo360",
    [5] = "longtu"
  }
  self.callback = parmas.callback
  self:initUI()
  self:registerBtnHandler()
  self:popWindow()
  self:show({skipAnim = true})
  return self
end

function chatServerSelectList:initUI()
  local layer, ui = ed.editorui(ed.uieditor.server_select_list)
  self.winUi = ui
  self.winUi.bg:setPosition(ccp(190, 360))
  self.container:addChild(layer)
end

function chatServerSelectList:registerBtnHandler()
  local ui = self.winUi
  for i, v in ipairs(self.server_type) do
    local btn_str = "btn_" .. v
    local index = i
    self:btRegisterButtonClick({
      button = ui[btn_str],
      pressScale = 0.95,
      key = btn_str,
      clickHandler = function()
        self.callback(v)
        self:onDestory()
      end,
      force = true
    })
  end
  self:btRegisterClick({
    key = "click_layer",
    clickHandler = function(param, x, y)
      if not ed.containsPoint(self.winUi.bg, x, y) then
        self:onDestory()
      end
    end
  })
end
