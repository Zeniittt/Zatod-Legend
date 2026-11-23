local base = ed.ui.popwindow
local NoticeWindow = newclass(base.mt)
ed.ui.NoticeWindow = NoticeWindow
local maintenanceTime = "15:00-18:00"
local maintenanceText = T("\230\156\141\229\138\161\229\153\168\230\173\163\229\156\168\231\187\180\230\138\164\228\184\173\227\128\130\231\187\180\230\138\164\230\151\182\233\151\180\228\184\186%s\239\188\140\229\175\185\230\130\168\229\184\166\230\157\165\231\154\132\228\184\141\228\190\191\230\149\172\232\175\183\232\176\133\232\167\163\227\128\130", maintenanceTime)
local maintenanceButtonText = T("\233\128\128\229\135\186")
print("maintenanceText", maintenanceText)
print("maintenanceButtonText", maintenanceButtonText)

function NoticeWindow.create(param)
  param = param or {}
  local self = base.create("NoticeWindow", {
    priority = param.new_priority
  })
  setmetatable(self, NoticeWindow.mt)
  self.param = param
  local container
  container, self.ui = ed.editorui(ed.uieditor.noticeWindow)
  self.container:addChild(container)
  self:initWindow()
  self:registerTouchHandler()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:show()
  return self
end

function NoticeWindow:registerTouchHandler()
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.btn_ok,
    press = ui.btn_ok_press,
    key = "btn_ok",
    clickHandler = function()
      self:destroy({
        callback = function()
          self.param.destroyCallback()
        end
      })
    end
  })
end

function NoticeWindow:initWindow()
  local ui = self.ui
  local param = self.param
  ed.setString(ui.button_label, param.buttonText or T("\230\156\149\231\159\165\233\129\147\228\186\134"))
  ed.setLabelShadow(ui.button_label, ed.toccc3(0), ccp(1, 1))
  local title_label = ed.ui.gradientLabel.create({
    text = T("\229\133\172\229\145\138"),
    fontSize = 23,
    fontName = ed.font,
    startColor = ed.toccc3(14810623),
    endColor = ed.toccc3(9497851),
    strokeSize = 1.5,
    strokeColor = ed.toccc3(3367864)
  })
  ui.title_label:addChild(title_label.node)
  ed.left2(ui.ImageView_635_Copy0, title_label.node, 10)
  ed.right2(ui.ImageView_635, title_label.node, 10)
  local size = ui.panel:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, size.width, size.height),
    rect = CCRectMake(0, 0, size.width, size.height),
    noShade = true,
    container = ui.panel,
    priority = self.mainTouchPriority - 5,
    zorder = 10,
    bar = {
      bglen = size.height,
      bgpos = ccp(-15, 140)
    }
  }
  local draglist = ed.draglist.create(info)
  self.draglist = draglist
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = param.content .. (ed.debug_mode and ed.backdoor_string or ""),
    color = ccc3(255, 234, 198),
    fontSize = 18,
    maxWidth = size.width
  })
  autoText.node:setPosition(ccp(0, size.height - 9))
  draglist.listLayer:addChild(autoText.node)
  local w, h = autoText:getCurContentSize()
  draglist:initListHeight(h)
end

local paramCache

function NoticeWindow.pop(param)
  param = param or paramCache
  if not param then
    ed.showToast(T("\230\178\161\230\156\137\229\133\172\229\145\138\229\134\133\229\174\185\239\188\129"))
    return
  end
  paramCache = param
  local content = param.content or ""
  if type(content) == "string" then
    param.content = content
  elseif type(content) == "table" then
    param.content = content[EDCurLanguage] or ""
  else
    param.content = ""
  end
  param.destroyCallback = param.destroyCallback or function()
    print("NoticeWindow destroyed!")
  end
  local window = ed.ui.NoticeWindow.create(param)
  window:popWindow(1000)
end

ed.popScrollDialog = NoticeWindow.pop
