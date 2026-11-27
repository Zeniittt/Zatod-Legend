local base = ed.ui.popwindow
local herohot = newclass(base.mt)
ed.ui.commonHerohot = herohot
ed.UITool.registViewOpenFunc("herohotPop", function()
  herohot.create():popWindow()
end)
local heroMode = {}

function herohot.create()
  return setmetatable(base.create("commonHerohot"), herohot.mt):init()
end

function herohot:init()
  self:initui()
  self:dragList()
  self:setBtnTouch()
  self:refresh(ed.player._herohot or {})
  self:listenTimer(Timer:Once(0.5), function()
    local msg = ed.upmsg.herohot()
    msg._open_panel = ed.upmsg.hh_open_panel()
    ed.send(msg, "herohot")
  end)
  self:listenEvent("hh_open_panel_reply", function(params)
    ed.player._herohot = params._heros or {}
    self:refresh(params._heros or {})
  end)
  self:show({skipAnim = true})
  return self
end

function herohot:refresh(params)
  self.params = params
  self:listRefresh()
end

function herohot:listRefresh()
  local unit = self:getInitUnitSort(ed.getDataTable("Unit"), self.params)
  self.unit = unit
  local itemHeight, widMax = self.itemCon - 10, math.floor(self.dragListCon.width / self.itemCon)
  local addWid = (self.dragListCon.width - widMax * self.itemCon) / 2
  
  local function getIndexToPos(index)
    if index < 0 then
      if index == -3 then
        return ccp(self.dragListCon.width / 2 - ed.display.halfFixedWidth - 4, self.dragListCon.height - itemHeight / 2 - ed.display.halfFixedHeight - 50)
      elseif index == -2 then
        return ccp(self.dragListCon.width / 3 - 70 - ed.display.halfFixedWidth, self.dragListCon.height - itemHeight / 2 - ed.display.halfFixedHeight - 50)
      else
        return ccp(self.dragListCon.width / 3 * 2 + 70 - ed.display.halfFixedWidth - 3, self.dragListCon.height - itemHeight / 2 - ed.display.halfFixedHeight - 50)
      end
    else
      return ccp(index % widMax * self.itemCon - ed.display.halfFixedWidth + addWid + self.itemCon / 2, self.dragListCon.height - math.floor(index / widMax) * itemHeight - itemHeight / 2 - 220 - ed.display.halfFixedHeight)
    end
  end
  
  if self.items and #self.items > 0 then
    self.heros = {}
    local index = 1
    for i, v in ipairs(unit) do
      self.items[v.tid].heroNode:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, getIndexToPos(index - 4))))
      if self.items[v.tid].param.index ~= index then
        self.items[v.tid]:refreshParam(setmetatable({index = i}, {__index = v}))
      end
      index = index + 1
      table.insert(self.heros, setmetatable({
        index = i,
        _tid = v.tid,
        _level = 80
      }, {__index = v}))
    end
  else
    self.items = {}
    self.heros = {}
    for i, v in ipairs(unit) do
      self.createSprite("UI/alpha/1080P/herohot/herohot_bg_" .. ed.clamp(i, 1, 4) .. ".png", ccpAdd(getIndexToPos(i - 4), ccp(i == 2 and -3 or 0, i == 1 and 12 or i == 2 and -1 or i == 3 and -5 or -18)), 1, self.draglist.listLayer, -1)
      local item = heroMode.new(self, setmetatable({index = i}, {__index = v}))
      self.draglist:addItem(item.heroNode, getIndexToPos(i - 4))
      self.items[v.tid] = item
      table.insert(self.heros, setmetatable({
        index = i,
        _tid = v.tid,
        _level = 80
      }, {__index = v}))
    end
    self.draglist:initListHeight(math.ceil((#self.draglist.listItems - 3) / widMax) * itemHeight + 240)
  end
  self:listVisRefresh()
end

function herohot:listVisRefresh()
  local isShow = self.ui.selected:isVisible()
  if self.items and #self.items > 0 then
    for i, v in ipairs(self.unit or {}) do
      self.items[v.tid]:refresh(isShow)
    end
  end
end

function herohot:initui()
  local ui = {}
  
  local function createSprite(res, pos, scale, parent, z)
    local sprite = ed.createSprite(res)
    sprite:setPosition(pos)
    sprite:setScale(scale or 1)
    parent:addChild(sprite, z or 99)
    return sprite
  end
  
  ui.titleNameBj = createSprite("UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png", ccp(0, 0), 1, self.container)
  ed.layout.layoutWithMagin(ui.titleNameBj, {left = 20, top = 18})
  ed.UITool.createSceneTitle(T("\232\139\177\233\155\132\230\131\133\230\138\165"), ui.titleNameBj, {
    position = ccp(56, 20)
  })
  ui.close = createSprite("UI/alpha/1080P/common/break_butt_bj.png", ccp(130, 20), 0.8, self.container)
  ed.layout.layoutWithMagin(ui.close, {left = 0, top = 0})
  createSprite("UI/alpha/1080P/common/break_butt.png", ccp(25, 27), 1, ui.close)
  ui.clickBtnLay = CCNode:create()
  ui.clickBtnLay:setContentSize(CCSizeMake(100, 50))
  ui.clickBtnLay:setAnchorPoint(ccp(0.5, 0.5))
  self.container:addChild(ui.clickBtnLay, 99)
  ed.layout.layoutWithMagin(ui.clickBtnLay, {
    right = 0,
    top = ed.display.winSize.height / 4
  })
  ui.clickBtnLay:setVisible(false)
  ui.selected = createSprite("UI/alpha/1080P/package/selected.png", ccp(7, 25), 0.65, ui.clickBtnLay)
  ui.selected:setVisible(true)
  self.createSprite = createSprite
  self.ui = ui
end

function herohot:dragList()
  local thisCon = {
    width = ed.display.winSize.width - 240,
    height = ed.display.winSize.height
  }
  local info = {
    cliprect = CCRectMake(120 - ed.display.halfFixedWidth, 0 - ed.display.halfFixedHeight, thisCon.width, thisCon.height),
    position = ccp(120, 0),
    doPressIn = function(x, y)
      return y
    end,
    cancelPressIn = function(x, y, oldy)
      self.touch = math.abs(oldy - y) < 50
    end,
    container = self.container,
    noshade = true,
    zorder = 10,
    priority = -300,
    bar = {
      barres = "UI/alpha/1080P/herohot/herohot_slider.png",
      bglen = thisCon.height - 30,
      bgpos = ccp(120 - ed.display.halfFixedWidth + thisCon.width + 70, thisCon.height / 2 - ed.display.halfFixedHeight),
      barthick = 7,
      alwaysShow = true
    }
  }
  self.draglist = ed.draglist.create(info)
  self.dragListCon = thisCon
  self.itemCon = 175
  self.draglist.scrollbar[1].barBg:setVisible(false)
  local background = ed.createScale9Sprite("UI/alpha/1080P/herohot/herohot_line.png", CCRectMake(1, 25, 1, 4))
  background:setContentSize(CCSizeMake(6, thisCon.height - 30))
  background:setPosition(120 - ed.display.halfFixedWidth + thisCon.width + 70, thisCon.height / 2 - ed.display.halfFixedHeight)
  self.draglist.layer:addChild(background, -1)
end

function herohot:setBtnTouch()
  local function closeFun()
    self:destroy({skipAnim = true})
  end
  
  local ui = self.ui
  self:btRegisterOutClick({
    area = ui.panel_touch,
    key = "out_click",
    clickHandler = function()
      closeFun()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.close,
    key = "btn_close",
    clickHandler = function()
      closeFun()
    end,
    force = true,
    pressScale = 0.75,
    normalScale = 0.8
  })
  self:btRegisterButtonClick({
    button = self.ui.clickBtnLay,
    key = "clickBtnLay",
    clickHandler = function()
      self.ui.selected:setVisible(not self.ui.selected:isVisible())
      self:listVisRefresh()
    end,
    force = true,
    pressScale = 0.95,
    normalScale = 1
  })
  
  function self:heroModeButtonClick(btn, param)
    self:btRegisterButtonClick({
      button = btn,
      key = "hero_mode_" .. (param.tid or 1),
      param = param or {},
      clickHandler = function(param)
        if self.touch then
          ed.UITool.openView("heroShowPop", {
            heros = self.heros,
            index = param.index
          })
        end
      end,
      force = true,
      pressScale = btn:getScale() - 0.1,
      normalScale = btn:getScale(),
      clickInterval = 0.3
    })
  end
end

local getWid = {num = 0, wid = 10}

function getWid.funs(num)
  if num then
    getWid.num = num
    getWid.wid = 10
  end
  if getWid.num > getWid.wid then
    getWid.wid = getWid.wid * 10
    return getWid.funs()
  else
    return math.log10(getWid.wid)
  end
end

function heroMode.new(popSelf, param)
  return setmetatable({popSelf = popSelf, param = param}, {__index = heroMode}):create()
end

function heroMode:create()
  self.heroNode = CCNode:create()
  self.heroNode:setContentSize(CCSizeMake(80, 140))
  self.heroNode:setAnchorPoint(ccp(0.5, 0.5))
  local ui = {}
  local layer = CCSprite:create()
  self.heroNode:addChild(layer)
  layer:setCascadeOpacityEnabled(true)
  ui.layer = layer
  local createSprite = self.popSelf.createSprite
  self.param.isHave = ed.player.heroes[self.param.tid] ~= nil
  local label = ed.createttf(self.param.hotNum, 18)
  label:setPosition(ccp(40, -12))
  label:setColor(ccc3(ed.colorToStr("#240e02")))
  layer:addChild(label, 111)
  self.hotNumlabel = label
  local wid = 44 + getWid.funs(self.param.hotNum) * 18 / 3
  ui.fire_icon = createSprite("UI/alpha/1080P/herohot/herohot_fire_icon.png", ccp(wid, -12), 1, layer)
  self.rankLabel = ed.getNumberNode({
    text = self.param.index,
    folder = "herohot_num",
    padding = -1
  })
  local label = self.rankLabel.node
  label:setPosition(-17, 2)
  self.heroNode:addChild(label)
  if self.param.index < 4 then
    label:setPosition(self.param.index == 1 and -28 or self.param.index == 3 and -26 or -24, 0)
  end
  local head = ed.readhero.createIcon({
    id = self.param.tid,
    rank = 1,
    state = "idle",
    level = 80,
    stars = 5,
    isNoLevelStar = true
  })
  local headIcon = head.icon
  headIcon:setPosition(self.param.index == 1 and 43 or 40, self.param.index == 1 and 80 or 74)
  self.heroNode:addChild(headIcon, 111)
  self.head = head
  local label = ed.createttf(self.param.name, 15)
  label:setPosition(ccp(40, 8))
  label:setColor(ccc3(ed.colorToStr("#fffce7")))
  layer:addChild(label, 111)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#1d1d1d")), 1)
  ed.adaptLabel(label, {maxWidth = 85, minScale = 0.5})
  self.popSelf.heroModeButtonClick(self.popSelf, head.icon, self.param)
  self.ui = ui
  return self
end

function heroMode:refresh(isShow)
  if not self.param.isHave then
    if not self.head.stateShade then
      self.head:addShade()
    end
    self.head.stateShade:setVisible(isShow)
  end
end

function heroMode:refreshParam(param)
  self.param = param
  self.param.isHave = ed.player.heroes[self.param.tid] ~= nil
  ed.refreshNumberNode(self.rankLabel, self.param.index)
  self.rankLabel.node:setPosition(-17, 2)
  if self.param.index < 4 then
    self.rankLabel.node:setPosition(self.param.index == 1 and -28 or -24, 0)
  end
  self.hotNumlabel:setString(self.param.hotNum)
  local wid = 44 + getWid.funs(self.param.hotNum) * 18 / 3
  self.ui.fire_icon:setPosition(wid, -12)
  self.popSelf:btRemoveMainTouchHandler({
    key = "hero_mode_" .. (param.tid or 1)
  })
  self.popSelf.heroModeButtonClick(self.popSelf, self.head.icon, self.param)
end

function herohot:getInitUnitSort(Unit, param)
  local serverTime = ed.getServerTime()
  local idKey = {}
  for i, v in ipairs(param) do
    idKey[v._heroid] = v
  end
  local herosHot, heros = {}, {}
  for k, v in pairs(Unit) do
    if ed.readhero.isHeroOpen(v.ID, serverTime) then
      table.insert(herosHot, {
        tid = v.ID,
        hotNum = idKey[v.ID] and (idKey[v.ID]._hot or 500) or 500,
        name = v["Display Name"]
      })
    end
  end
  table.sort(herosHot, function(a, b)
    return a.hotNum > b.hotNum
  end)
  return herosHot
end
