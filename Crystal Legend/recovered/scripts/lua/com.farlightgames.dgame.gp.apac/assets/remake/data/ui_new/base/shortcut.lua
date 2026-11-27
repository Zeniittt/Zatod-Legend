local class = newclass()
ed.ui.shortcut = class
local res = ed.ui.uires
local sc_touch_priority = -16
local button_ori_pos = ccp(res.shortcut_pos_x, res.shortcut_pos_y)

local function getButtonPos(index)
  return ccp(res.shortcutBoardButtonPosX[index], res.shortcut_pos_y)
end

local button_info = {
  {
    key = "task",
    identity = "a window",
    normal = "UI/alpha/1080P/main/main_task_button.png",
    name = "UI/alpha/1080P/main/main_task_button_name.png",
    buttonPos = getButtonPos(1),
    tagPos = ccp(50, 50)
  },
  {
    key = "package",
    normal = "UI/alpha/1080P/main/main_package_button.png",
    name = "UI/alpha/1080P/main/main_package_button_name.png",
    buttonPos = getButtonPos(2),
    tagPos = ccp(50, 50)
  },
  {
    key = "heroPackage",
    normal = "UI/alpha/1080P/main/main_hero_button.png",
    name = "UI/alpha/1080P/main/main_hero_button_name.png",
    buttonPos = getButtonPos(3),
    tagPos = ccp(50, 50)
  },
  {
    key = "fragment",
    normal = "UI/alpha/1080P/main/main_fragment_button.png",
    name = "UI/alpha/1080P/main/main_fragment_button_name.png",
    buttonPos = getButtonPos(4),
    tagPos = ccp(50, 50)
  }
}

local function getTouchNode(self)
  if not self.scTouchNode then
    local touchNode = ed.ui.basetouchnode.btCreate()
    self.scTouchNode = touchNode
  end
  return self.scTouchNode
end

local function getuiList(self)
  self.sc_ui = self.sc_ui or {}
  return self.sc_ui
end

local function getContainer(self)
  if tolua.isnull(self.frameworkLayer) then
    self.frameworkLayer = CCLayer:create()
    self.mainLayer:addChild(self.frameworkLayer, 100)
  end
  return self.frameworkLayer
end

local function getInfoContainer(self)
  local container = getContainer(self)
  if tolua.isnull(self.infoLayer) then
    local infoLayer = CCSprite:create()
    infoLayer:setCascadeOpacityEnabled(true)
    container:addChild(infoLayer, 100)
    self.infoLayer = infoLayer
  end
  return self.infoLayer
end

local function getSCContainer(self)
  local container = tolua.isnull(self.scContainer) and CCSprite:create()
end

local function destroyShadeLayer(self)
  if not tolua.isnull(self.scShadeLayer) then
    self.scShadeLayer:removeFromParentAndCleanup(true)
  end
end

class.destroyShortcutLayer = destroyShortcutLayer

local function createShadeLayer(self)
  destroyShadeLayer(self)
  local layer
  if self.identity == "main" then
    layer = CCLayer:create()
  else
    layer = CCLayerColor:create(ccc4(0, 0, 0, 150))
    local handler = self:doShortcut()
    local touchNode = getTouchNode(self)
    touchNode:btRegisterOutClick({
      rectArea = res.shortcut_board_rect,
      key = "out_board",
      clickHandler = function()
        if self.isShortcutOpen then
          handler()
        end
      end,
      priority = sc_touch_priority,
      force = true
    })
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -10, true)
  end
  self.infoLayer:addChild(layer, 50)
  layer:setTouchEnabled(true)
  self.scShadeLayer = layer
end

local function refreshTags(self)
  local ui = getuiList(self)
  local info = button_info
  local isShowTag = false
  for i = 1, #info do
    local element = info[i]
    local key = element.key
    local handler = self:getCheckSCTagHandler(key)
    local isShow = handler()
    isShowTag = isShowTag or isShow
    if not tolua.isnull(ui[key .. "_tag"]) then
      ui[key .. "_tag"]:setVisible(isShow)
    end
  end
  local tag = ui.tag
  if not tolua.isnull(tag) then
    if self.isShortcutOpen then
      tag:setVisible(false)
    else
      tag:setVisible(isShowTag)
    end
  end
end

local function registerButtonTouchHandler(self)
  local ui = getuiList(self)
  local info = button_info
  for i = 1, #info do
    local element = info[i]
    local key = element.key
    if self.identity ~= key then
      local info = {
        button = ui[key],
        key = key,
        clickHandler = function()
          local handler = self:getSCButtonTouchHandler(key)
          handler()
        end,
        priority = sc_touch_priority - i,
        clickInterval = 1,
        pressScale = 1.2
      }
      self:btRegisterButtonClick(info)
      getTouchNode(self):btRegisterButtonClick(info)
    end
  end
end

local function getButtons(self)
  local ui = getuiList(self)
  local buttons = {}
  for i = 1, #button_info do
    table.insert(buttons, ui[button_info[i].key])
  end
  return buttons
end

local function createExpireTimeIcon(time, id, insid)
  local expireTime, expireTimeBg
  if not id then
    expireTime = time or 0
  else
    expireTime = time or ed.player:getExpireTimeByInsid(id, insid)
  end
  expireTimeBg = ed.createSprite("UI/alpha/1080P/package/bg_time.png")
  expireTimeBg:setPosition(ccp(45, 48))
  local iconTime = ed.createSprite("UI/alpha/1080P/package/icon_time.png")
  iconTime:setPosition(ccp(9, 8))
  expireTimeBg:addChild(iconTime)
  local labelTime = ed.createLabelTTF(ed.time2dhmOnly(expireTime), 14)
  if expireTime - ed.getServerTime() < 3600 then
    ed.setLabelColor(labelTime, ccc3(255, 108, 108))
    ed.setLabelStroke(labelTime, ccc3(85, 26, 12), 2)
  else
    ed.setLabelColor(labelTime, ccc3(119, 255, 84))
    ed.setLabelStroke(labelTime, ccc3(23, 49, 31), 2)
  end
  labelTime:setAnchorPoint(ccp(0, 0.5))
  labelTime:setPosition(ccp(18, 9))
  expireTimeBg:addChild(labelTime)
  expireTimeBg:setScale(0.7)
  return expireTimeBg, labelTime
end

local function createButtons(self)
  local ui = getuiList(self)
  local container = self.shortcutLayer
  local isOpen = self.isShortcutOpen
  local info = button_info
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {}
  for i = 1, #info do
    local element = info[i]
    local key = element.key
    local identity = element.identity or key
    local normal = element.normal
    local name = element.name
    local press = element.press
    local tag = "UI/alpha/HVGA/main_deal_tag.png"
    local bpos = element.buttonPos
    local tPos = element.tagPos
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = key,
        res = "UI/alpha/1080P/main/main_butt_bg.png"
      },
      layout = {
        position = isOpen and bpos or button_ori_pos
      },
      config = {isCascadeOpacity = true}
    })
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = "kays",
        res = normal,
        z = 10,
        parent = key
      },
      layout = {
        position = ccp(31, 34.5)
      },
      config = {isCascadeOpacity = true}
    })
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = key .. "_name",
        res = name,
        z = 11,
        parent = key
      },
      layout = {
        position = ccp(31, 7)
      }
    })
    table.insert(ui_info, {
      t = "Sprite",
      base = {
        name = key .. "_tag",
        res = tag,
        parent = key,
        z = 12
      },
      layout = {position = tPos}
    })
  end
  readnode:addNode(ui_info)
  local tb = ed.player.packageGoods.package.all or {}
  local time = 999999999
  local serverTime = ed.getServerTime()
  for k, item in ipairs(tb) do
    if item.expireTime then
      time = math.min(time, item.expireTime - serverTime)
    end
  end
  local expireIcon, expireTimeLabel = createExpireTimeIcon(time)
  expireIcon:setZOrder(13)
  ui.package:addChild(expireIcon)
  ui.package.expireIcon = expireIcon
  ui.package.expireTimeLabel = expireTimeLabel
  if time < 259200 then
    ui.package.expireIcon:setVisible(true)
  else
    ui.package.expireIcon:setVisible(false)
  end
  registerButtonTouchHandler(self)
  if not isOpen then
    for i = 1, #info do
      ui[info[i].key]:setOpacity(0)
    end
  else
    createShadeLayer(self)
  end
  container:registerScriptHandler(function(event)
    if event == "enter" then
      local ui = getuiList(self)
      local info = button_info
      if not self.isShortcutOpen then
        for i = 1, #info do
          ui[info[i].key]:setOpacity(0)
        end
      end
    end
  end)
  refreshTags(self)
end

local function createBoard(self)
  local ui = getuiList(self)
  self.shortcutButton = nil
  self.isShortcutOpen = nil
  self.isShortcutOpen = self.identity == "main"
  if self:checkFirstInMain() then
    self.isShortcutOpen = false
  end
  local shortcutContainer = CCSprite:create()
  self.infoLayer:addChild(shortcutContainer, 60)
  self.shortcutLayer = shortcutContainer
  local readNode = ed.readnode.create(shortcutContainer, ui)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "shortcut_board",
        res = "UI/alpha/1080P/main/main_shortcut_board.png",
        capInsets = CCRectMake(10, 10, 12, 12.5)
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = res.shortcut_board_pos
      },
      config = {
        scaleSize = self.isShortcutOpen and CCSizeMake(res.shortcut_board_width_max, res.shortcut_board_height) or CCSizeMake(res.shortcut_board_width_min, res.shortcut_board_height)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "down",
        res = "UI/alpha/1080P/main/main_bj_button.png",
        z = 10
      },
      layout = {
        position = ccp(res.shortcut_pos_x - 5, res.shortcut_pos_y)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        parent = "down",
        name = "downTp",
        res = "UI/alpha/1080P/main/main_img_button.png"
      },
      layout = {
        position = ccp(20.5, 31)
      },
      config = {flip = "x"}
    },
    {
      t = "Sprite",
      base = {
        name = "up",
        res = "UI/alpha/1080P/main/main_bj_button.png",
        z = 10
      },
      layout = {
        position = ccp(res.shortcut_pos_x - 5, res.shortcut_pos_y)
      },
      config = {
        visible = self.isShortcutOpen
      }
    },
    {
      t = "Sprite",
      base = {
        parent = "up",
        name = "upTp",
        res = "UI/alpha/1080P/main/main_img_button.png"
      },
      layout = {
        position = ccp(23, 31)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "tag",
        res = "UI/alpha/HVGA/main_deal_tag.png",
        z = 10
      },
      layout = {
        position = ccp(res.shortcut_pos_x + 15, res.shortcut_pos_y + 24)
      },
      config = {visible = false}
    }
  }
  readNode:addNode(ui_info)
  local info = {
    button = ui.down,
    pressScale = 0.95,
    clickHandler = self:doShortcut(),
    priority = sc_touch_priority
  }
  self:btRegisterButtonClick(info)
  getTouchNode(self):btRegisterButtonClick(info)
end

local function hideSwitch(self)
  self.shortcutLayer:setVisible(false)
end

local function showSwitch(self)
  self.shortcutLayer:setVisible(true)
end

class.interface = {
  scGetuiList = getuiList,
  scGetContainer = getContainer,
  scGetInfoContainer = getInfoContainer,
  scRefreshTags = refreshTags,
  scCreateBoard = createBoard,
  scCreateButtons = createButtons,
  scGetButtons = getButtons,
  scCreateShadeLayer = createShadeLayer,
  scDestroyShadeLayer = destroyShadeLayer,
  scHideSwitch = hideSwitch,
  scShowSwitch = showSwitch
}
