local base = ed.ui.popwindow
local versionChangeView = newclass(base.mt)
ed.ui.versionChangeView = versionChangeView

function versionChangeView.create()
  local self = base.create("versionChangeView")
  setmetatable(self, versionChangeView.mt)
  self:initView()
  self:setChangeStateUI()
  self:addEventListen()
  return self
end

function versionChangeView:initView()
  local container, ui = ed.editorui(ed.uieditor.versionchange)
  self.container:addChild(container)
  self.ui = ui
end

function versionChangeView:setChangeStateUI()
  local curDir = ed.storage.getString("game_res_dir")
  print("curDir:", curDir)
  local curMode = curDir == "att/" and "att" or "remake"
  self.curMode = curMode
  local ui = self.ui
  ui.img_selected_left:setVisible(curMode == "remake")
  ui.selected_flag_left:setVisible(curMode == "remake")
  ui.text_tips_left:setVisible(curMode == "remake")
  ui.btn_switch_left:setVisible(curMode ~= "remake")
  ui.img_selected_right:setVisible(curMode == "att")
  ui.selected_flag_right:setVisible(curMode == "att")
  ui.text_tips_right:setVisible(curMode == "att")
  ui.btn_switch_right:setVisible(curMode ~= "att")
  local year = ed.time2YMDHMS()
  local tips = string.format("\230\140\129\231\187\173\230\155\180\230\150\176\233\149\191\232\190\190%d\229\185\180\231\154\132\228\188\160\229\165\135\230\156\141\239\188\140\228\189\191\231\148\168\230\179\176\229\157\166\232\139\177\233\155\132\229\190\129\230\156\141\228\188\160\229\165\135\229\164\167\233\153\134\227\128\130", (year or 2023) - 2013)
  ui.tips_right:setString(tips)
  ed.setLabelDimensions(ui.tips_left, CCSizeMake(282.5, 45))
  ed.setLabelDimensions(ui.tips_right, CCSizeMake(282.5, 45))
  print("version current mode:", curMode)
end

function versionChangeView:addEventListen()
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
      self:onClickChange("remake")
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_switch_right,
    press = self.ui.btn_switch_right_press,
    clickHandler = function()
      self:onClickChange("att")
    end
  })
end

function versionChangeView:onClickChange(keyName)
  if EDFLAGIOS or EDFLAGANDROID then
    local text = T("\229\136\135\230\141\162\232\135\179") .. (self.curMode == "att" and T("\230\128\128\230\151\167\230\156\141\n\233\135\141\229\144\175\229\144\142\231\148\159\230\149\136") or T("\228\188\160\229\165\135\230\156\141\n\233\135\141\229\144\175\229\144\142\231\148\159\230\149\136"))
    local info = {
      text = text,
      leftText = T("\229\143\150\230\182\136"),
      rightHandler = function()
        local curDir = ed.storage.getString("game_res_dir")
        local dir = curDir == "att/" and "remake/" or "att/"
        ed.storage.setValue("game_res_dir", dir)
        EDRestartGame()
      end,
      rightText = T("\231\161\174\229\174\154")
    }
    ed.showConfirmDialog(info)
  else
    ed.showToast(T("\231\137\136\230\156\172\229\136\135\230\141\162\229\143\170\230\148\175\230\140\129\231\167\187\229\138\168\232\174\190\229\164\135\227\128\130"))
  end
end
