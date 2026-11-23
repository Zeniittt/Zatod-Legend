local loginPage = {}
ed.ui.activityloginPage = loginPage
loginPage.uiCfg = {
  qixi = {
    resTag = "qixi",
    deleUiName = {
      "cat_img",
      "ImageView_375"
    },
    addUiCfg = {},
    init = function(self)
      self.ui.ImageView_383:setPositionX(self.ui.ImageView_383:getPositionX() + 40)
      self.ui.ImageView_384:setPosition(ccpAdd(ccp(self.ui.ImageView_384:getPosition()), ccp(-160, -4)))
      self.ui.label_time:setPosition(ccpAdd(ccp(self.ui.label_time:getPosition()), ccp(-160, -4)))
    end,
    refresh = function(self)
    end
  },
  midautumn = {
    resTag = "midautumn",
    deleUiName = {
      "cat_img",
      "ImageView_375"
    },
    addUiCfg = {},
    init = function(self)
      self.ui.ImageView_383:setPositionX(self.ui.ImageView_383:getPositionX() + 40)
      self.ui.ImageView_384:setPosition(ccpAdd(ccp(self.ui.ImageView_384:getPosition()), ccp(-160, -4)))
      self.ui.label_time:setPosition(ccpAdd(ccp(self.ui.label_time:getPosition()), ccp(-160, -4)))
    end,
    refresh = function(self)
    end
  },
  anniversary = {
    resTag = "anniversary",
    deleUiName = {
      "cat_img",
      "ImageView_375"
    },
    dayCard = {
      colorUp = ccc3(ed.colorToStr("#d15967")),
      colorIng = ccc3(ed.colorToStr("#fffce7")),
      colorUpStroke = ccc3(ed.colorToStr("#fff3fd")),
      colorIngStroke = ccc3(ed.colorToStr("#883731"))
    },
    addUiCfg = {},
    init = function(self)
      self.ui.ImageView_383:setPositionX(self.ui.ImageView_383:getPositionX() + 10)
      self.ui.ImageView_384:setPosition(ccpAdd(ccp(self.ui.ImageView_384:getPosition()), ccp(-145, -2)))
      self.ui.label_time:setPosition(ccpAdd(ccp(self.ui.label_time:getPosition()), ccp(-145, -2)))
      self.ui.label_time:setColor(ccc3(ed.colorToStr("#fffaef")))
      ed.setLabelStroke(self.ui.label_time, ed.toccc3(5314584), 1)
      local colorCfg = self.categoryUiCfg.dayCard or {}
      self.ui.login_item_7_Label:setColor(colorCfg.colorUp)
      ed.setLabelStroke(self.ui.login_item_7_Label, colorCfg.colorUpStroke, 1)
      self.ui.login_item_7_pass_Label:setColor(colorCfg.colorIng)
      ed.setLabelStroke(self.ui.login_item_7_pass_Label, colorCfg.colorIngStroke, 1)
    end,
    refresh = function(self)
    end
  },
  springfestival = {
    resTag = "springfestival",
    deleUiName = {
      "cat_img",
      "ImageView_375"
    },
    dayCard = {
      colorUp = ccc3(ed.colorToStr("#d15967")),
      colorIng = ccc3(ed.colorToStr("#fffce7")),
      colorUpStroke = ccc3(ed.colorToStr("#fff3fd")),
      colorIngStroke = ccc3(ed.colorToStr("#883731"))
    },
    addUiCfg = {},
    init = function(self)
      self.ui.panel_item:setPositionX(self.ui.panel_item:getPositionX() - 5)
      self.ui.ImageView_383:setPosition(ccpAdd(ccp(self.ui.ImageView_383:getPosition()), ccp(25, -15)))
      self.ui.ImageView_384:setPosition(ccpAdd(ccp(self.ui.ImageView_384:getPosition()), ccp(-153, -4)))
      self.ui.label_time:setPosition(ccpAdd(ccp(self.ui.label_time:getPosition()), ccp(-155, -4)))
      self.ui.label_time:setColor(ccc3(ed.colorToStr("#ffcb93")))
      ed.setLabelStroke(self.ui.label_time, ed.toccc3(3541514), 1)
      self.ui.login_item_7:setPositionX(self.ui.login_item_7:getPositionX() - 1)
      local colorCfg = self.categoryUiCfg.dayCard or {}
      self.ui.login_item_7_Label:setColor(colorCfg.colorUp)
      ed.setLabelStroke(self.ui.login_item_7_Label, colorCfg.colorUpStroke, 1)
      self.ui.login_item_7_pass_Label:setColor(colorCfg.colorIng)
      ed.setLabelStroke(self.ui.login_item_7_pass_Label, colorCfg.colorIngStroke, 1)
    end,
    refresh = function(self)
    end
  },
  mayday = {
    resTag = "mayday",
    deleUiName = {
      "cat_img",
      "ImageView_375"
    },
    dayCard = {
      colorUp = ccc3(201, 110, 37),
      colorIng = ccc3(255, 208, 148),
      colorUpStroke = ccc3(ed.colorToStr("#fffce7")),
      colorIngStroke = ccc3(ed.colorToStr("#6c4441"))
    },
    addUiCfg = {},
    init = function(self)
      self.ui.ImageView_383:setOpacity(0)
      self.ui.ImageView_383:setCascadeOpacityEnabled(false)
      self.ui.ImageView_383:setPosition(ccpAdd(ccp(self.ui.ImageView_383:getPosition()), ccp(-30, 0)))
      self.ui.ImageView_384:setPosition(ccpAdd(ccp(self.ui.ImageView_384:getPosition()), ccp(-153, -4)))
      self.ui.label_time:setPosition(ccpAdd(ccp(self.ui.label_time:getPosition()), ccp(-155, -4)))
      self.ui.label_time:setColor(ccc3(255, 252, 231))
      ed.setLabelStroke(self.ui.label_time, ed.toccc3(2844450), 1)
      self.ui.panel_item:setPositionX(self.ui.panel_item:getPositionX() - 50)
      self.ui.login_item_7:setPositionX(self.ui.login_item_7:getPositionX() - 50)
      local colorCfg = self.categoryUiCfg.dayCard or {}
      self.ui.login_item_7_Label:setColor(colorCfg.colorIng)
      ed.setLabelStroke(self.ui.login_item_7_Label, colorCfg.colorIngStroke, 1)
      self.ui.login_item_7_pass_Label:setColor(colorCfg.colorUp)
      ed.setLabelStroke(self.ui.login_item_7_pass_Label, colorCfg.colorUpStroke, 1)
    end,
    refresh = function(self)
    end
  },
  mergeserver = {
    resTag = "mergeserver",
    deleUiName = {
      "ImageView_375"
    },
    addUiCfg = {},
    init = function(self)
    end,
    refresh = function(self)
    end
  },
  newyear = {
    resTag = "newyear",
    deleUiName = {
      "ImageView_375",
      "login_item_7",
      "login_item_7_pass"
    },
    addUiCfg = {},
    init = function(self)
    end,
    refresh = function(self)
    end,
    param = {bigItem = true}
  },
  easter = {
    resTag = "easter",
    deleUiName = {
      "ImageView_375",
      "login_item_7",
      "login_item_7_pass"
    },
    addUiCfg = {},
    dayCard = {
      colorUp = ed.toccc3(15065855),
      colorIng = ed.toccc3(15065855),
      colorUpStroke = ccc3(ed.colorToStr("#5b4599")),
      colorIngStroke = ccc3(ed.colorToStr("#f3feff"))
    },
    init = function(self)
      self.ui.ImageView_383:setOpacity(0)
      self.ui.ImageView_383:setCascadeOpacityEnabled(false)
      self.ui.label_time:setColor(ccc3(255, 252, 231))
      ed.setLabelStroke(self.ui.label_time, ed.toccc3(2844450), 1)
      ed.setTexture(self.items[3].bg, "UI/alpha/1080P/activity/login_gift_easter/login_gift_item_big_bg1.png")
      self.items[3].bglabel:setColor(ed.toccc3(7685552))
      ed.setLabelStroke(self.items[3].bglabel, ed.toccc3(15990527), 1)
    end,
    refresh = function(self)
    end,
    param = {bigItem = true}
  }
}

function loginPage.create(base, param, pageKey)
  local this = {}
  setmetatable(loginPage, {__index = base})
  setmetatable(this, {__index = loginPage})
  local uiConfig = ed.uieditor.activity_login
  if param._extend and param._extend._tag and this.uiCfg[param._extend._tag] then
    local categoryUiCfg = this.uiCfg[param._extend._tag]
    local deleIdx = {}
    uiConfig = ed.copyProto(uiConfig)
    for i, v in ipairs(uiConfig) do
      if ed.isElementInTable(v.base.name, categoryUiCfg.deleUiName) then
        table.insert(deleIdx, i)
      elseif v.t == "Sprite" or v.t == "Scale9Sprite" then
        v.base.res = string.gsub(v.base.res, "/login_gift/", "/login_gift_" .. param._extend._tag .. "/")
      end
    end
    for i, v in ipairs(deleIdx) do
      table.remove(uiConfig, v - (i - 1))
    end
    for i, v in ipairs(categoryUiCfg.addUiCfg) do
      table.insert(uiConfig, v)
    end
    this.resTag = param._extend._tag
    if categoryUiCfg.param then
      this.cfgParam = {}
      for k, v in pairs(categoryUiCfg.param) do
        this.cfgParam[k] = v
      end
    end
    this.categoryUiCfg = categoryUiCfg
  end
  local container, ui = ed.editorui(uiConfig)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:initItems(param)
  if this.categoryUiCfg then
    this.categoryUiCfg.init(this)
  end
  return this
end

local loginBox = {}

function loginPage:initItems(param)
  self.ui.label_time:setString(T("\229\137\169\228\189\153 %s", self.param.endTimeStr or 0))
  if self.param and self.param.openType then
    self.ui.ImageView_383:setVisible(self.param.openType ~= "Open Svr")
  end
  
  local function ClickFunc(item)
    return function()
      if item.isCompleted then
        self.objWork:activitySubmit(param._id, item.param._id)
      else
        ed.UITool.openView("packageDetail", {
          id = item.items.id,
          count = item.items.count,
          type = item.items.type
        })
      end
    end
  end
  
  local task = param._tasks
  local posx, posy = 60, 193
  if self.cfgParam and self.cfgParam.bigItem then
    posx, posy = 70, 134
  end
  self.items = {}
  for i = 1, 7 do
    local tsk = task[i]
    if tsk then
      local ui
      if i == 7 then
        ui = {
          layer = self.ui.login_item_7,
          passBg = self.ui.login_item_7_pass
        }
      end
      local item = loginBox.create(ui, tsk, self)
      if not ui then
        item.layer:setPosition(posx, posy)
        self.ui.panel_item:addChild(item.layer)
      end
      if self.cfgParam and self.cfgParam.bigItem then
        posx = 70 + i * 155
      elseif i % 3 == 0 then
        posx, posy = 60, 65
      else
        posx = posx + 105
      end
      self:btRegisterButtonClick({
        button = item.itemIcon,
        key = "itemIcon" .. i,
        force = true,
        mcpMode = true,
        pressScale = 0.96,
        clickHandler = ClickFunc(item)
      })
      self.items[i] = item
    end
  end
end

function loginPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  for i, v in ipairs(self.items or {}) do
    local tsk = task[i] or {}
    v:update(tsk)
  end
end

function loginBox.create(layerBase, param, mainSelf)
  local this = {}
  setmetatable(this, {__index = loginBox})
  this.layerBase = layerBase
  this.param = param
  this.mainSelf = mainSelf
  this:initUi(param)
  return this
end

function loginBox:initUi(param)
  local items = {}
  for i, v in ipairs(param._rewards) do
    local data = v
    data._type = data._type == "free_monthcard" and "FreeMonthCard" or data._type
    table.insert(items, {
      id = data._id or 0,
      count = data._amount or 1,
      type = data._type or "item"
    })
  end
  self.items = items[1]
  local icon = ed.createItemIcon(items[1])
  icon:setScale(1)
  self.itemIcon = icon
  if self.layerBase then
    self.layer = self.layerBase.layer
    self.passBg = self.layerBase.passBg
    icon:setPosition(80, 130)
  else
    local colorCfg = self.mainSelf.categoryUiCfg and (self.mainSelf.categoryUiCfg.dayCard or {}) or {}
    local res = self.mainSelf.resTag and "_" .. self.mainSelf.resTag or ""
    local layer = CCLayer:create()
    local img = "/login_gift_item_bg.png"
    if self.mainSelf.cfgParam and self.mainSelf.cfgParam.bigItem then
      img = "/login_gift_item_big_bg.png"
    end
    local bg = ed.createSprite("UI/alpha/1080P/activity/login_gift" .. res .. img)
    layer:addChild(bg)
    local label = ed.createttf(T("\231\172\172%s\229\164\169", param._cond_target), 18)
    label:setPosition(0, -45)
    if self.mainSelf.cfgParam and self.mainSelf.cfgParam.bigItem then
      label:setPosition(0, -87)
    end
    label:setColor(colorCfg.colorUp or ccc3(ed.colorToStr("#4566B0")))
    layer:addChild(label)
    if colorCfg.colorUpStroke then
      ed.setLabelStroke(label, colorCfg.colorUpStroke, 1)
    end
    self.bglabel = label
    img = "/login_gift_item_pass.png"
    if self.mainSelf.cfgParam and self.mainSelf.cfgParam.bigItem then
      img = "/login_gift_item_big_pass.png"
    end
    local passBg = ed.createSprite("UI/alpha/1080P/activity/login_gift" .. res .. img)
    layer:addChild(passBg)
    passBg:setVisible(false)
    label = ed.createttf(T("\231\172\172%s\229\164\169", param._cond_target), 18)
    label:setPosition(48, 19)
    if self.mainSelf.cfgParam and self.mainSelf.cfgParam.bigItem then
      label:setPosition(74.25, 24)
    end
    label:setColor(colorCfg.colorIng or ccc3(ed.colorToStr("#D9D7EA")))
    passBg:addChild(label)
    if colorCfg.colorIngStroke then
      ed.setLabelStroke(label, colorCfg.colorIngStroke, 1)
    end
    self.bg = bg
    self.layer = layer
    self.passBg = passBg
    icon:setPositionY(7)
  end
  self.layer:addChild(icon, 99)
  local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
  eff:setPosition(46, 45)
  icon:addChild(eff, 9)
  self.itemEff = eff
  local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
  tick:setPosition(30, 25)
  tick:setVisible(false)
  icon:addChild(tick)
  self.tick = tick
  self:update(param)
end

function loginBox:update(param)
  self.param = param
  self.isCompleted = nil
  local isCompleted = param._progress >= param._cond_target
  local isFinished = param._cur_reward_times and param._cur_reward_times >= param._max_reward_times
  if isFinished then
    self.tick:setVisible(true)
    self.passBg:setVisible(true)
  elseif isCompleted then
    self.isCompleted = true
  end
  self.itemEff:setVisible(self.isCompleted)
  if self.isCompleted then
    self.itemEff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  else
    self.itemEff:stopAllActions()
  end
end
