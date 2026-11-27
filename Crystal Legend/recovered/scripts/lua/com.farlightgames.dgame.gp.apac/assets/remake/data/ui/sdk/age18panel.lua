Age18Panel = {}
Age18Panel.__index = Age18Panel
local base = ed.ui.popwindow
setmetatable(Age18Panel, base.mt)

function Age18Panel.create()
  local panel = base.create("Age18Panel")
  setmetatable(panel, Age18Panel)
  panel:initData()
  panel:initAppearance()
  panel:registerTouchHandler()
  return panel
end

function Age18Panel:destroy()
  ed.playEffect(ed.sound.deo.common_close_popup_window)
  if self.mainLayer then
    self.mainLayer:setTouchEnabled(false)
    self.mainLayer:removeFromParentAndCleanup(true)
    self.mainLayer = nil
  end
end

function Age18Panel:initData()
  local data = ed.player:getAntiAddictionData()
  self.onlineSec = data._online_sec or 0
  self.incomeRate = data._income_rate or 0
end

function Age18Panel:initAppearance()
  local mainLayer = self.mainLayer
  local container, ui = ed.editorui(ed.uieditor.age18_panel)
  self.container = container
  self.ui = ui
  mainLayer:addChild(container)
  local str = T("\230\173\163\229\184\184")
  if self.incomeRate == 50 then
    str = T("50%\230\148\182\231\155\138")
  elseif self.incomeRate == 0 then
    str = T("\233\155\182\230\148\182\231\155\138")
  end
  ui.label_desc:setDimensions(CCSizeMake(400, 0))
  ed.setString(ui.label_debuf, str)
  ed.setString(ui.label_time, ed.time2dhm(self.onlineSec))
  local hours2
  local tips = {
    T("\229\189\147\229\137\141\228\184\186\229\129\165\229\186\183\230\184\184\230\136\143\230\151\182\233\151\180\227\128\130"),
    T("\230\130\168\231\180\175\232\174\161\229\156\168\231\186\191\230\151\182\233\151\180\229\183\178\230\187\1611\229\176\143\230\151\182\227\128\130"),
    T("\230\130\168\231\180\175\232\174\161\229\156\168\231\186\191\230\151\182\233\151\180\229\183\178\230\187\1613\229\176\143\230\151\182\239\188\140\232\175\183\230\130\168\228\184\139\231\186\191\228\188\145\230\129\175\239\188\140\229\129\154\233\128\130\229\189\147\232\186\171\228\189\147\230\180\187\229\138\168\227\128\130"),
    T("\230\130\168\229\183\178\231\187\143\232\191\155\229\133\165\231\150\178\229\138\179\230\184\184\230\136\143\230\151\182\233\151\180\239\188\140\230\130\168\231\154\132\230\184\184\230\136\143\230\148\182\231\155\138\229\176\134\233\153\141\228\184\186\230\173\163\229\184\184\229\128\188\231\154\13250%\239\188\140\228\184\186\228\186\134\230\130\168\231\154\132\229\129\165\229\186\183\239\188\140\232\175\183\229\176\189\229\191\171\228\184\139\231\186\191\228\188\145\230\129\175\239\188\140\229\129\154\233\128\130\229\189\147\232\186\171\228\189\147\230\180\187\229\138\168\239\188\140\229\144\136\231\144\134\229\174\137\230\142\146\229\173\166\228\185\160\231\148\159\230\180\187\227\128\130"),
    T("\230\130\168\229\183\178\231\187\143\232\191\155\229\133\165\231\150\178\229\138\179\230\184\184\230\136\143\230\151\182\233\151\180\239\188\140\230\130\168\231\154\132\230\184\184\230\136\143\230\148\182\231\155\138\229\176\134\233\153\141\228\184\186\230\173\163\229\184\184\229\128\188\231\154\13250%\239\188\140\228\184\186\228\186\134\230\130\168\231\154\132\229\129\165\229\186\183\239\188\140\232\175\183\229\176\189\229\191\171\228\184\139\231\186\191\228\188\145\230\129\175\239\188\140\229\129\154\233\128\130\229\189\147\232\186\171\228\189\147\230\180\187\229\138\168\239\188\140\229\144\136\231\144\134\229\174\137\230\142\146\229\173\166\228\185\160\231\148\159\230\180\187\227\128\130"),
    T("\230\130\168\229\183\178\232\191\155\229\133\165\228\184\141\229\129\165\229\186\183\230\184\184\230\136\143\230\151\182\233\151\180\239\188\140\228\184\186\228\186\134\230\130\168\231\154\132\229\129\165\229\186\183\239\188\140\232\175\183\230\130\168\231\171\139\229\141\179\228\184\139\231\186\191\228\188\145\230\129\175\227\128\130\229\166\130\228\184\141\228\184\139\231\186\191\239\188\140\230\130\168\231\154\132\232\186\171\228\189\147\229\176\134\229\143\151\229\136\176\230\141\159\229\174\179\239\188\140\230\130\168\231\154\132\230\148\182\231\155\138\229\183\178\233\153\141\228\184\186\233\155\182\239\188\140\231\155\180\229\136\176\230\130\168\231\154\132\231\180\175\232\174\161\228\184\139\231\186\191\230\151\182\233\151\180\230\187\1615\229\176\143\230\151\182\229\144\142\239\188\140\230\137\141\232\131\189\230\129\162\229\164\141\230\173\163\229\184\184\227\128\130")
  }
  local strTip
  if self.onlineSec < 3600 then
    strTip = tips[1]
  elseif self.onlineSec < 10800 then
    strTip = tips[2]
  elseif self.onlineSec < 14400 then
    strTip = tips[3]
  elseif self.onlineSec < 16200 then
    strTip = tips[4]
  elseif self.onlineSec < 18000 then
    strTip = tips[5]
  else
    strTip = tips[6]
  end
  ed.setString(ui.label_desc, strTip)
end

function Age18Panel:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.ui.btn_close,
    press = self.ui.btn_close_press,
    key = "btn_close",
    clickHandler = function()
      self:destroy()
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_go,
    press = self.ui.btn_go_press,
    key = "btn_go",
    clickHandler = function()
      self:destroy()
      ed.showConfirmDialog({
        text = T("\233\135\141\229\144\175\230\184\184\230\136\143\232\191\155\232\161\140\232\186\171\228\187\189\233\170\140\232\175\129\239\188\159"),
        rightText = T("\231\161\174\229\174\154"),
        rightHandler = function()
          if EDFLAGANDROID then
            EDRestartGame()
          else
            EDExit()
          end
        end
      })
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_ok,
    press = self.ui.btn_ok_press,
    key = "btn_ok",
    clickHandler = function()
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
