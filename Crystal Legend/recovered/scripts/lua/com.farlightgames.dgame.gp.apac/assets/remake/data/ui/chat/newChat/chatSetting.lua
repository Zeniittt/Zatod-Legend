local base = ed.ui.popwindow
local chatSetting = newclass(base.mt)
chatSetting.__index = chatSetting
ed.ui.chatSetting = chatSetting

function chatSetting:onDestory()
  if self.callback then
    self.callback()
  end
  self:destroy({skipAnim = true})
end

function chatSetting.create()
  local self = base.create("chatSetting", {noShade = true})
  setmetatable(self, chatSetting.mt)
  self:initUI()
  self:registerBtnHandler()
  self:popWindow()
  self:show({skipAnim = true})
  return self
end

function chatSetting:initUI()
  local layer, ui = ed.editorui(ed.uieditor.setting)
  ui.black_bg:setPosition(ccp(25, 70))
  self.winUi = ui
  self.container:addChild(layer)
  self.btnList = {
    ui.node_custom_photo,
    ui.node_black,
    ui.node_chatSet
  }
  self.btnBg = {
    ui.image_photo_bg,
    ui.image_black_bg,
    ui.image_chatSet_bg
  }
  self.btnIcon = {
    ui.icon_photo_pressed,
    ui.icon_black_pressed,
    ui.icon_chatSet_pressed
  }
  for i, btn in pairs(self.btnList) do
    self.btnBg[i]:setVisible(false)
    self.btnIcon[i]:setVisible(false)
  end
end

function chatSetting:registerBtnHandler()
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        for i, btn in ipairs(self.btnList) do
          if ed.containsPoint(btn, x, y) then
            self.btnBg[i]:setVisible(true)
            self.btnIcon[i]:setVisible(true)
            self.idx = i
            break
          end
        end
      elseif event == "ended" then
        if self.idx then
          if self.idx == 1 then
            local enable = ed.player:getCustomPhotoSwitch()
            if not enable then
              ed.showToast(T("\229\138\159\232\131\189\229\189\147\229\137\141\230\156\170\229\188\128\229\144\175"))
              return
            end
            local valid = ed.player:hasValidMonthCard()
            if not valid then
              ed.showToast(T("\230\139\165\230\156\137\230\156\136\229\141\161\229\143\175\228\187\165\228\189\191\231\148\168\230\173\164\229\138\159\232\131\189"))
              return
            end
            local panel = CustomPhotoPanel.create()
            panel:popWindow()
            self:onDestory()
          elseif self.idx == 2 then
            ed.blacklist.getBlacklist()
            self:onDestory()
          elseif self.idx == 3 then
            ed.ui.chatSetInfoWin.create()
            self:onDestory()
          end
        end
        self.idx = nil
      end
    end,
    key = "chat_setting_touch"
  })
  self:btRegisterClick({
    key = "click_layer",
    clickHandler = function(param, x, y)
      if not ed.containsPoint(self.winUi.black_bg, x, y) then
        self:onDestory()
      end
    end
  })
end
