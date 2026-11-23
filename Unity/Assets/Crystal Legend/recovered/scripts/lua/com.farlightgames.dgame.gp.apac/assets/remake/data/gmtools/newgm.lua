local base = ed.ui.gm
local class = newclass(base.mt)
ed.ui.newgm = class
local commandType = ed.gmtools.commandType
local gm_command = ed.gmtools.gm_command
local command_config = ed.gmtools.command_config
local t_number = {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  "C",
  0,
  "/"
}
local scaleX = ed.display.designSize.width / 800
local scaleY = ed.display.designSize.height / 480
local map = {
  all = "\229\133\168\233\131\168",
  wings = "\230\136\152\233\152\159",
  resources = "\232\181\132\230\186\144",
  hero = "\232\139\177\233\155\132",
  level = "\229\133\179\229\141\161",
  play = "\231\142\169\230\179\149",
  guild = "\229\183\165\228\188\154"
}

function class:getButtonConfigByLabel(label)
  for k, v in ipairs(command_config) do
    if label == v.label then
      return v
    end
  end
  return nil
end

function class:syncHero(IDorName)
  local msg = ed.upmsg.gm_cmd()
  msg._set_hero_info = {}
  local hero_list = {}
  for id, hero in pairs(ed.player.heroes) do
    local name = ed.lookupDataTable("Unit", "Unit Name", hero._tid)
    if name == IDorName or hero._tid == IDorName then
      local h = ed.commonmsg.hero()
      h._tid = hero._tid
      h._level = hero._level
      h._stars = hero._stars
      h._rank = hero._rank
      h._exp = hero._exp
      h._state = "idle"
      h._gs = 0
      h._items = hero._items
      h._skill_levels = hero._skill_levels
      table.insert(hero_list, h)
    end
  end
  for k = 1, math.floor(#hero_list / 2) do
    local hero = hero_list[k]
    table.insert(msg._set_hero_info, hero)
  end
  
  function ed.gmNetReplyHander()
    ed.gmNetReplyHander = nil
    msg._set_hero_info = {}
    for k = math.floor(#hero_list / 2) + 1, #hero_list do
      local hero = hero_list[k]
      table.insert(msg._set_hero_info, hero)
    end
    ed.send(msg, "gm_cmd")
  end
  
  ed.send(msg, "gm_cmd")
end

local function getPos(i)
  local ox = 250
  local oy = 305
  local dx = 150
  local dy = 50
  local row = i % 6
  local col = math.floor(i / 6)
  return ccp(ox + col * dx, oy - dy * row)
end

function class:createListLayer()
  local classifyInfo = {
    cliprect = CCRectMake(170, 340, 800 * scaleX, 60),
    noshade = true,
    container = self.mainLayer,
    zorder = 10
  }
  self.classifyDraglist = ed.draglist.create(classifyInfo)
  self.classifyDraglist:initListWidth((30 + 110 * #commandType) * scaleX)
  local commandInfo = {
    cliprect = CCRectMake(170, 30, 650 * scaleX, 300),
    noshade = true,
    container = self.mainLayer,
    zorder = 10
  }
  self.draglist = ed.draglist.create(commandInfo)
  self.draglist:initListWidth(650 * scaleX)
end

function class:refreshCommand(type)
  self.curType = type
  local i = 0
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  if type == "all" then
    for k, v in ipairs(command_config) do
      v.pos = getPos(i)
      v.size = CCSizeMake(150, 50)
      self:createButton(v, "command")
      i = i + 1
    end
  else
    for k, v in pairs(gm_command) do
      if k == type then
        for id, value in ipairs(v) do
          local tmp = command_config[value]
          tmp.pos = getPos(i)
          tmp.size = CCSizeMake(150, 50)
          self:createButton(tmp, "command")
          i = i + 1
        end
      end
    end
  end
  self.draglist:initListWidth(math.floor((i + 5) / 6) * 150 + 30)
  local preType = map[ed.gmtools.preType]
  ed.setLabelColor(self.buttonLabel[preType], ccc3(255, 213, 16))
  ed.gmtools.preType = type
  ed.setLabelColor(self.buttonLabel[map[type]], ccc3(255, 255, 255))
end

function class:searchByName(classify, name)
  local i = 0
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  if classify == "all" then
    for k, v in ipairs(command_config) do
      if v.name and string.find(v.name, name) then
        v.pos = getPos(i)
        v.size = CCSizeMake(150, 50)
        i = i + 1
        self:createButton(v, "command")
      end
    end
  else
    for k, v in pairs(gm_command) do
      if k == classify then
        for id, value in ipairs(v) do
          local tmp = command_config[value]
          if tmp.name and string.find(tmp.name, name) then
            tmp.pos = getPos(i)
            v.size = CCSizeMake(150, 50)
            i = i + 1
            self:createButton(tmp, "command")
          end
        end
      end
    end
  end
  ed.gmtools.preSearch = name
  self.draglist:initListWidth(math.floor((i + 5) / 6) * 150 + 30)
end

function class:createClassify()
  local ox = 230
  local dx = 110
  if not commandType then
    return
  end
  for k, v in ipairs(commandType) do
    v.pos = ccp(ox, 365)
    v.size = CCSizeMake(110, 50)
    self:createButton(v, "type")
    ox = ox + dx
  end
  local preType = ed.gmtools.preType or "all"
  self:refreshCommand(preType)
  local preSearch = ed.gmtools.preSearch or ""
  self:searchByName(preType, preSearch)
end

function class:createInputBg()
  local InputBg = ed.createScale9Sprite("UI/alpha/1080P/common/break_butt_bj.png")
  local pos = ccp(95, 180)
  local size = CCSizeMake(180, 300)
  InputBg:setContentSize(size)
  InputBg:setPosition(pos)
  self.mainLayer:addChild(InputBg)
  self.InputBg = InputBg
  self.InputBg:setVisible(false)
end

function class:createNumberInput()
  self:createInputBg()
  local button = ed.createScale9Sprite("UI/alpha/1080P/common/buttion_big.png")
  local size = CCSizeMake(80 * scaleX, 50)
  local edit = CCEditBox:create(size, button, nil, nil, true)
  edit:setPlaceHolder("\232\175\183\232\190\147\229\133\165\239\188\154")
  edit:setFontColor(ccc3(128, 230, 15))
  edit:setFont(ed.font, 16)
  edit:setPosition(ccp(15, 290))
  edit:setAnchorPoint(ccp(0, 0.5))
  self.mainLayer:addChild(edit)
  self.number = edit
  local inputCommit = {
    label = "<-",
    pos = ccp(145, 290),
    size = CCSizeMake(50, 50),
    color = ccc3(128, 230, 15),
    handler = function(self)
      print("click inputcommit")
      local num = tonumber(self.number:getText()) or 0
      if num == 0 then
        self.number:setText("")
      else
        self.number:setText(math.floor(num / 10))
      end
    end
  }
  local k, btn = self:createButton(inputCommit)
  self.numBtns = self.numBtns or {}
  self.numBtns[k] = btn
end

function class:createButton(info, layer)
  local id = info.id
  local label = info.label
  local pos = info.pos
  local handler = info.handler
  local size = info.size
  local inWidth = info.inWidth or 120
  local color = info.color or ccc3(255, 213, 16)
  local icon = info.icon or 0
  if not self.button then
    self.button = {}
    self.buttonPress = {}
    self.buttonLabel = {}
    self.buttonHandler = {}
  end
  local button = ed.createScale9Sprite("UI/alpha/1080P/common/break_butt_bj.png")
  local buttonPress = ed.createScale9Sprite("UI/alpha/1080P/common/break_butt_bj.png")
  buttonPress:setVisible(false)
  local buttonLabel = ed.createttf(label or "", 20)
  ed.setLabelColor(buttonLabel, color)
  local labelSize = buttonLabel:getContentSize()
  button:setContentSize(size)
  buttonPress:setContentSize(size)
  if inWidth < labelSize.width then
    buttonLabel:setScale(inWidth / labelSize.width)
  end
  buttonPress:setPosition(ccp(size.width / 2, size.height / 2))
  buttonLabel:setPosition(ccp(size.width / 2, size.height / 2))
  button:addChild(buttonPress)
  button:addChild(buttonLabel)
  button:setPosition(pos)
  if layer == "type" then
    self.classifyDraglist.listLayer:addChild(button)
  elseif layer == "command" then
    self.draglist.listLayer:addChild(button)
  else
    self.mainLayer:addChild(button)
  end
  local key = id or label
  self.button[key] = button
  self.buttonPress[key] = buttonPress
  self.buttonLabel[key] = buttonLabel
  self.buttonHandler[key] = handler
  return key, button
end

function class:createNumber()
  self.numBtns = self.numBtns or {}
  
  local function getNumberPos(i)
    local ox, oy = 43, 240
    local dx, dy = 50, 50
    return ccp(ox + dx * ((i - 1) % 3), oy - dy * math.floor((i - 1) / 3))
  end
  
  for i = 1, #t_number do
    local b = {
      label = t_number[i],
      pos = getNumberPos(i),
      size = CCSizeMake(50, 50),
      inWidth = 30,
      color = ccc3(128, 230, 15),
      handler = function(self)
        local n = t_number[i]
        local nt = type(n)
        if nt == "string" and n == "C" then
          self.number:setText("")
        else
          local text = self.number:getText()
          if #text < 12 then
            self.number:setText(text .. n)
          end
        end
      end
    }
    local k, btn = self:createButton(b)
    self.numBtns[k] = btn
  end
end

function class:createSearchLayer()
  local button = ed.createScale9Sprite("UI/alpha/1080P/common/btn_bg.png")
  local size = CCSizeMake(120 * scaleX, 40)
  local command_edit = CCEditBox:create(size, button, nil, nil, true)
  command_edit:setPlaceHolder("\232\175\183\232\190\147\229\133\165:")
  command_edit:setFontColor(ccc3(128, 230, 15))
  command_edit:setFont(ed.font, 16)
  command_edit:setPosition(ccp(630 * scaleX, 430))
  command_edit:setAnchorPoint(ccp(0.5, 0.5))
  command_edit:setScaleX(1)
  self.mainLayer:addChild(command_edit)
  self:registerUpdateHandler("search_command", function()
    self.preSearchKey = self.preSearchKey or ""
    local key = self.command_edit:getText()
    if key ~= self.preSearchKey and key ~= "\232\175\183\232\190\147\229\133\165:" then
      if key == "" then
        self.preSearchKey = key
      else
        self.preSearchKey = key
        self:searchByName("all", key)
      end
    end
  end)
  local commandCommit = {
    label = "X",
    pos = ccp(713 * scaleX, 430),
    size = CCSizeMake(50, 50),
    inWidth = 30,
    color = ccc3(128, 230, 15),
    handler = function(self)
      self.command_edit:setText("\232\175\183\232\190\147\229\133\165:")
      self:refreshCommand(self.curType)
    end
  }
  self:createButton(commandCommit)
  self.command_edit = command_edit
end

function class:initUI()
  local mainLayer = self.mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  self.ui = {}
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "title",
        text = "\229\138\159\232\131\189\230\144\156\231\180\162",
        size = 20
      },
      layout = {
        position = ccp(510 * scaleX, 430)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/1080P/common/break_butt.png"
      },
      layout = {
        position = ccp(70, 430)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/1080P/common/break_butt.png"
      },
      layout = {
        position = ccp(70, 430)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  self:createListLayer()
  self:createClassify()
  self:createNumberInput()
  self:createNumber()
  self:createSearchLayer()
end

function class:create()
  local self = base.new("newgm")
  setmetatable(self, class.mt)
  self:initUI()
  return self
end
