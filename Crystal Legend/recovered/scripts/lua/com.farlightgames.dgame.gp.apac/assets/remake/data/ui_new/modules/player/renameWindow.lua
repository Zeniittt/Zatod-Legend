local base = ed.ui.popwindow
local renameWindow = newclass(base.mt)
ed.ui.renameWindow = renameWindow

function renameWindow.create(params)
  local self = base.create("renameWindow")
  setmetatable(self, renameWindow.mt)
  self:initParams(params)
  self:init()
  return self
end

function renameWindow:initParams(params)
  params = params or {}
  params.title = params.title or T("\230\155\180\230\148\185\230\136\152\233\152\159\229\144\141\231\167\176")
  params.costNum = params.costNum or ed.player:getSetNameTime() == 0 and 0 or ed.player:getSetNameCost()
  params.costType = params.costType or "diamond"
  params.confirm = params.confirm or function(name)
    ed.netdata.setname = {
      name = name,
      cost = self.params.costNum,
      costType = self.params.costType
    }
    ed.netreply.setname = self:doSetNameReply()
    local msg = ed.upmsg.set_name()
    msg._name = name
    msg._type = self.params.costNum == 0 and 0 or 1
    ed.send(msg, "set_name")
  end
  params.isNotRandom = params.isNotRandom or false
  self.cancleCallback = params.cancleCallback
  self.params = params
end

function renameWindow:init()
  self:initView()
  self:addEventListener()
end

function renameWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.playerRename)
  self.ui = ui
  self.container:addChild(container)
  local info = {
    config = {
      editSize = ui.panel_input:getContentSize(),
      maxLength = 20,
      fontColor = ccc3(255, 252, 231),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T("\232\175\183\232\190\147\229\133\165"))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  ui.panel_input:addChild(edit_box.edit)
  ui.panel_input:setClipRect(CCRectMake(0, 0, info.config.editSize.width, info.config.editSize.height))
  self.editbox = edit_box
  self.ui.lb_title:setString(self.params.title)
  ed.left2(self.ui.ImageView_100_Copy0, self.ui.lb_title, 10)
  ed.right2(self.ui.ImageView_100, self.ui.lb_title, 10)
  local cfg = ed.ui.configs.resBar.getResBarConfig(self.params.costType)
  if cfg and cfg.smallIcon then
    local smallIconPath
    if type(cfg.smallIcon) == "function" then
      smallIconPath = cfg.smallIcon()
    else
      smallIconPath = cfg.smallIcon
    end
    ed.setTexture(self.ui.cost, smallIconPath)
  end
  if 0 >= self.params.costNum then
    self.ui.cost_num:setString(T("\229\133\141\232\180\185"))
  else
    self.ui.cost_num:setString(self.params.costNum)
  end
  ed.right2(self.ui.cost_num, self.ui.cost, 2)
  if self.params.isNotRandom then
    self.ui.btn_rand:setVisible(false)
  else
    local seed = ed.getMillionTime()
    math.randomseed(seed)
    math.random()
    math.random()
    math.random()
    edit_box:setString(self:getRandName())
  end
  ed.setLabelShadow(self.ui.btn_cancel_label, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.btn_confirm_label, ed.toccc3(0), ccp(1, 0))
  self:show()
end

function renameWindow:getRandName()
  local name = ""
  local ka = {}
  local ac = ed.getDataTable("affixcount")
  for i = 1, 3 do
    ka[i] = {
      key = ac[i].Name,
      amount = ac[i].Count
    }
  end
  local at = ed.getDataTable("affix")
  local pn = at[math.random(1, ka[1].amount)][ka[1].key] or ""
  local mn = at[math.random(1, ka[2].amount)][ka[2].key] or ""
  local sn = at[math.random(1, ka[3].amount)][ka[3].key] or ""
  name = pn .. mn .. sn
  return name
end

function renameWindow:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.btn_confirm,
    press = self.ui.btn_confirm_press,
    key = "btn_confirm",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.9,
    clickHandler = function()
      local cfg = ed.ui.configs.resBar.getResBarConfig(self.params.costType)
      if cfg.initValue(self.params.costType) < self.params.costNum then
        local name = ed.ui.configs.resType.getResName(self.params.costType)
        ed.showToast(T("%s\228\184\141\232\182\179\239\188\140\230\151\160\230\179\149\230\148\185\229\144\141\239\188\129", name or T("\233\129\147\229\133\183")))
        return
      end
      local name = ed.trim(self.editbox:getString())
      LvDun.nameCheck(name, function(result)
        if result then
          self.params.confirm(name)
        else
          ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
        end
      end)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_cancel,
    press = self.ui.btn_cancel_press,
    key = "btn_cancel",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.9,
    clickHandler = function()
      self:pop(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_rand,
    key = "btn_rand",
    clickInterval = 0.3,
    force = true,
    pressScale = 0.9,
    clickHandler = function()
      self.editbox:setString(self:getRandName())
    end
  })
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.editbox:touch(event, x, y)
      if event ~= "ended" then
        return false
      elseif not ed.containsPoint(self.ui.bg, x, y) then
        self:pop(true)
        return
      end
    end,
    key = "renameWindow",
    priority = -100
  })
end

function renameWindow:doSetNameReply()
  local function handler(result)
    if result == "success" then
      self:pop()
    elseif result == "exists" then
      ed.showToast(T("\229\144\141\229\173\151\229\183\178\232\162\171\229\141\160\231\148\168"))
    elseif result == "dirty_word" then
      ed.showToast(T("\230\173\164\229\144\141\229\173\151\230\151\160\230\179\149\228\189\191\231\148\168\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
    else
      ed.showToast(T("\230\149\176\230\141\174\233\148\153\232\175\175"))
    end
  end
  
  return handler
end

function renameWindow:pop(cancle)
  if cancle and self.cancleCallback then
    self.cancleCallback()
  end
  self:destroy()
end

ListenEvent("mainSceneEnter", function()
  if ed.player:getSetNameTime() == 0 and ed.guide.data:isCompleted(7) and not ed.guide.data:isCompleted(12) then
    renameWindow.create():popWindow()
  end
end)
