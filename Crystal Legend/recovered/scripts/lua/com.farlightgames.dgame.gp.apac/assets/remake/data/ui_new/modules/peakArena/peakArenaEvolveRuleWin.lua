local base = ed.ui.popwindow
local peakArenaEvolveRuleWin = newclass(base.mt)
ed.ui.peakArenaEvolveRuleWin = peakArenaEvolveRuleWin

function peakArenaEvolveRuleWin:initData(params)
  self.rules = {
    T("1.\229\174\140\230\136\144\230\153\139\231\186\167\232\181\155\229\137\141\239\188\140\230\130\168\231\154\132\231\167\175\229\136\134\229\176\134\232\162\171\229\134\187\231\187\147\239\188\140\228\184\141\228\188\154\229\155\160\228\184\186\233\152\178\229\174\136\229\164\177\232\180\165\232\128\140\233\153\141\228\189\142\227\128\130"),
    T("2.\230\153\139\231\186\167\232\181\155\233\156\128\229\174\140\230\136\144\228\184\137\229\144\141\229\175\185\230\137\139\231\154\132\230\140\145\230\136\152\239\188\140\232\142\183\232\131\156\229\133\182\228\184\173\228\184\164\229\156\186\229\141\179\229\143\175\230\153\139\231\186\167\227\128\130"),
    T("3.\230\153\139\231\186\167\232\181\155\229\176\134\228\184\186\230\130\168\229\140\185\233\133\141\230\130\168\230\137\128\229\156\168\232\181\155\229\140\186\229\134\133\229\174\158\229\138\155\231\155\184\232\191\145\231\154\132\229\175\185\230\137\139\239\188\140\229\175\185\230\137\139\228\184\141\229\143\175\229\136\183\230\150\176\239\188\140\230\140\145\230\136\152\228\184\141\230\182\136\232\128\151\230\140\145\230\136\152\230\172\161\230\149\176\239\188\140\228\185\159\228\184\141\232\142\183\229\190\151\229\183\133\229\179\176\229\139\139\231\171\160\227\128\130"),
    T("4.\230\153\139\231\186\167\229\144\142\239\188\140\230\130\168\229\176\134\230\148\128\229\141\135\232\135\179\228\188\160\229\165\135\230\174\181\228\189\141\239\188\140\228\184\142\229\133\168\230\156\141\231\142\169\229\174\182\228\184\128\232\181\183\231\171\158\232\181\155\232\167\146\233\128\144\227\128\130"),
    T("5.\230\153\139\231\186\167\230\136\144\229\138\159\239\188\140\230\130\168\231\154\132\231\167\175\229\136\134\229\176\134\228\184\138\229\141\135\232\135\1795600\229\136\134\239\188\140\230\153\139\231\186\167\229\164\177\232\180\165\239\188\140\230\130\168\231\154\132\231\167\175\229\136\134\229\176\134\229\155\158\232\144\189\232\135\1795400\229\136\134\227\128\130"),
    T("6.\232\139\165\230\156\170\229\156\16824\229\176\143\230\151\182\229\134\133\229\174\140\230\136\144\230\153\139\231\186\167\232\181\155\239\188\140\232\167\134\228\184\186\230\153\139\231\186\167\229\164\177\232\180\165\227\128\130")
  }
  self.sendMessage = params.time and params.time > 0
  self.destroyCallback = params.callback
end

function peakArenaEvolveRuleWin:initUI()
  ed.editorui(ed.uieditor.TopArenaGradeUpRuleWin, {
    container = self.container,
    ui = self.ui
  })
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item)
  local size = self.ui.layer_item:getContentSize()
  local oriY = size.height - 20
  for k, v in ipairs(self.rules) do
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = v,
      fontSize = 18,
      maxWidth = size.width,
      color = ccc3(255, 252, 231),
      strokeColor = ccc3(27, 25, 24),
      strokeSize = 1
    })
    local curWidth, curHeight = autoText:getCurContentSize()
    autoText.node:setPosition(ccp(0, oriY))
    self.draglist:addItem(autoText.node)
    oriY = oriY - curHeight
  end
  self.draglist:initListHeight(size.height - oriY)
  ed.setLabelShadow(self.ui.Label_896, ed.toccc3(0), ccp(1, 1))
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(11888683), 1)
end

function peakArenaEvolveRuleWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_ok", function()
    if self.canClick then
      if self.sendMessage then
        ed.PeakArenaNetwork:sendCheckEvolve()
      end
      self:destroy()
    end
  end, {pressScale = 0.95})
end

function peakArenaEvolveRuleWin:refreshCloseBtnHandler(time)
  local count = time
  
  local function handler(dt)
    count = count - dt
    if count < 0 then
      self.canClick = true
      ed.setString(self.ui.Label_896, T("\231\161\174\229\174\154"))
      self:removeUpdateHandler("refreshCloseBtn")
    else
      ed.setString(self.ui.Label_896, string.format(T("\231\161\174\229\174\154(%ds)"), math.ceil(count)))
    end
  end
  
  return handler
end

function peakArenaEvolveRuleWin.create(params)
  local self = base.create("peakArenaEvolveRuleWin")
  setmetatable(self, peakArenaEvolveRuleWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self.canClick = true
  if self.sendMessage then
    self.canClick = false
    self:registerUpdateHandler("refreshCloseBtn", self:refreshCloseBtnHandler(params.time))
  end
  self:show()
  self:popWindow()
  return self
end
