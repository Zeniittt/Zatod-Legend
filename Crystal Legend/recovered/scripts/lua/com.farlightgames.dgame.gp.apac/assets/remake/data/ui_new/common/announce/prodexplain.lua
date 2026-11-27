local announce = ed.ui.announce
local base = announce.base
local class = newclass(base.mt)
announce.prodExplain = class

local function initTouchHandler(self)
  local ui = self.ui
  self.touchNode:btRegisterButtonClick({
    buttons = {
      ui.ok_button,
      ui.ok_button_disabled
    },
    presses = {
      ui.ok_button_press,
      nil
    },
    keys = {
      "ok_button",
      "ok_button_disabled"
    },
    clickHandler = function()
      if self.draglist.hasDrag2End or not self.draglist.canDragY then
        self:destroy()
        if self.param.callback then
          self.param.callback()
        end
      else
        ed.showToast(T("\232\171\139\232\128\144\229\191\131\231\156\139\229\174\140\230\179\168\230\132\143\228\186\139\233\160\133"))
      end
    end
  })
end

class.initTouchHandler = initTouchHandler

local function initListLayer(self)
  local param = {
    cliprect = ed.DGRectMake(282, 130, 455, 373),
    container = self.container,
    zorder = 20,
    noshade = true,
    bar = {
      bglen = ed.DGLen(312),
      bgpos = ed.DGccp(275, 328)
    }
  }
  local draglist = ed.draglist.create(param)
  self.draglist = draglist
  self.touchNode:btRegisterHandler({
    handler = draglist:getListLayerTouchHandler(),
    key = "draglist_touchs"
  })
end

class.initListLayer = initListLayer

local function initContent(self)
  local height = 0
  local ui = self.ui
  local container = self.draglist.listLayer
  
  local function add(node, offset, px)
    node:setPosition(ccp(px or 400, ed.DGLen(485) - height - offset))
    node:setAnchorPoint(ccp(node:getAnchorPoint().x, 1))
    height = height + node:getContentSize().height + (offset or 0)
  end
  
  local function addTitle(title)
    local node = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = "UI/alpha/HVGA/detail_title_bg.png",
        capInsets = ed.DGRectMake(125, 0, 415, 15)
      }
    }, container)
    local n1 = ed.createNode({
      t = "Label",
      base = {text = title, size = 20},
      config = {
        color = ccc3(255, 216, 17)
      }
    }, node)
    node:setContentSize(CCSizeMake(math.max(ed.DGLen(233), n1:getContentSize().width + 135), ed.DGLen(15)))
    n1:setPosition(ed.getCenterPos(node, ccp(5, 0)))
    add(node, 10)
  end
  
  local function addList(list)
    for i, v in ipairs(list) do
      local node = ed.createNode({
        t = "Label",
        base = {text = v, size = 20},
        layout = {
          anchor = ccp(0.5, 1)
        }
      }, container)
      add(node, i == 1 and 10 or 5)
    end
  end
  
  local mode = self.param.mode
  if mode == "gold" then
    local node = ed.createNode({
      t = "Label",
      base = {
        text = "\230\143\144\231\164\186\239\188\154\228\187\165\228\184\139\233\150\139\229\149\159\229\175\182\231\174\177\229\138\159\232\131\189\229\176\135\230\156\137\230\169\159\231\142\135\233\150\139\229\149\159\229\136\176\228\184\128\232\136\172\229\131\185\229\128\188\228\185\139\233\129\147\229\133\183\239\188\140\232\171\139\231\162\186\232\170\141\231\137\169\229\147\129\229\133\167\229\174\185\229\190\140\239\188\140\229\134\141\233\128\178\232\161\140\233\150\139\229\149\159\229\175\182\231\174\177\227\128\130",
        size = 20
      },
      layout = {
        anchor = ccp(0, 1)
      },
      config = {
        dimensions = ed.DGSizeMake(435, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        color = ccc3(247, 196, 115)
      }
    }, container)
    add(node, 0, ed.DGLen(295))
    local node = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
      },
      config = {scale = 0.8}
    }, container)
    add(node, 10)
    addTitle("\232\139\177\233\155\132\233\161\158")
    addList({
      "\233\157\136\233\173\130\231\159\179\231\162\142\231\137\135\239\188\154\233\171\152",
      "\232\139\177\233\155\132\229\141\161\231\137\140\239\188\154\228\184\128\232\136\172"
    })
    addTitle("\231\182\147\233\169\151\233\161\158")
    addList({
      "\231\182\147\233\169\151\232\151\165\230\176\180\239\188\154\233\171\152",
      "\231\182\147\233\169\151\232\151\165\232\134\143\239\188\154\228\184\173",
      "\231\182\147\233\169\151\228\185\179\233\133\170\239\188\154\228\189\142"
    })
    addTitle("\233\135\145\233\140\162\233\161\158")
    addList({
      "\232\151\141\232\137\178\231\137\169\229\147\129\239\188\154\233\171\152",
      "\231\180\171\232\137\178\231\137\169\229\147\129\239\188\154\228\189\142"
    })
    addTitle("\232\163\157\229\130\153\233\161\158")
    addList({
      "\232\151\141\232\137\178\232\163\157\229\130\153\239\188\154\233\171\152",
      "\231\180\171\232\137\178\232\163\157\229\130\153\239\188\154\228\189\142"
    })
    self.draglist:initListHeight(height + 30)
  elseif mode == "magic" then
    local node = ed.createNode({
      t = "Label",
      base = {
        text = "\230\143\144\231\164\186\239\188\154\230\175\143\228\189\191\231\148\168\228\184\128\230\172\161\229\176\135\229\143\175\231\141\178\229\190\151\229\164\154\231\168\174\231\137\169\229\147\129\239\188\140\230\165\181\229\176\145\230\169\159\231\142\135\230\156\131\229\135\186\231\143\190\228\189\142\230\150\188\228\184\128\232\136\172\229\131\185\229\128\188\231\137\169\229\147\129\239\188\140\232\171\139\231\162\186\232\170\141\229\190\140\229\134\141\233\128\178\232\161\140\230\138\189\229\143\150\239\188\155\230\138\189\229\143\150\230\169\159\231\142\135\229\166\130\228\184\139\227\128\130",
        size = 20
      },
      layout = {
        anchor = ccp(0, 1)
      },
      config = {
        dimensions = ed.DGSizeMake(435, 0),
        horizontalAlignment = kCCTextAlignmentLeft,
        color = ccc3(247, 196, 115)
      }
    }, container)
    add(node, 0, ed.DGLen(295))
    local node = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
      },
      config = {scale = 0.8}
    }, container)
    add(node, 10)
    addTitle("\232\139\177\233\155\132/\233\157\136\233\173\130\231\159\179\233\161\158\239\188\154")
    addList({
      "\230\156\172\230\151\165\232\139\177\233\155\132\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\233\171\152",
      "\230\156\172\229\145\168\232\139\177\233\155\132\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\228\189\142"
    })
    addTitle("\231\182\147\233\169\151\233\129\147\229\133\183/\233\153\132\233\173\148\233\129\147\229\133\183\239\188\154")
    addList({
      "\231\182\147\233\169\151\232\151\165\232\134\143\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\233\171\152",
      "\231\182\147\233\169\151\229\165\182\233\133\170\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\233\171\152",
      "\232\153\155\231\169\186\229\161\181\229\159\131\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\228\184\128\232\136\172",
      "\229\190\174\229\133\137\231\178\137\229\161\181\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\228\184\128\232\136\172",
      "\229\142\159\229\138\155\231\178\190\232\143\175\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\228\189\142"
    })
    addTitle("\233\135\145\229\185\163\233\161\158\239\188\154")
    addList({
      "\231\167\152\233\138\128\233\189\146\232\188\170\231\181\132\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\233\171\152",
      "\233\187\131\233\135\145\233\155\187\232\131\189\230\160\184\229\191\131\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\233\171\152",
      "\230\169\159\229\139\149\232\187\138\231\137\140\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\228\184\128\232\136\172",
      "\230\136\191\231\148\162\232\173\137\229\135\186\231\143\190\230\169\159\231\142\135\239\188\154\228\189\142"
    })
    self.draglist:initListHeight(height + 30)
  end
end

class.initContent = initContent

local function initWindow(self)
  self:initListLayer()
  self:initContent()
end

class.initWindow = initWindow

local function create(param)
  param = param or {}
  local self = base.create("prodExplain")
  setmetatable(self, class.mt)
  param.mode = param.mode or "gold"
  self.param = param
  local container = self.container
  local ui = {}
  self.ui = ui
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ed.uieditor.prodexplain)
  local touchNode = ed.ui.basetouchnode.btCreate()
  self.touchNode = touchNode
  self:initWindow()
  self.hasCliprect = true
  self.notClickDestroy = true
  self:initTouchHandler()
  self:registerTouchHandler(touchNode:btGetMainTouchHandler(), "main_handler")
  ed.getCurrentScene():registerUpdateHandler("update_ok_button", function()
    if self.draglist.hasDrag2End or not self.draglist.canDragY then
      self.ui.ok_button:setVisible(true)
      self.ui.ok_button_disabled:setVisible(false)
      ed.getCurrentScene():removeUpdateHandler("update_ok_button")
    end
  end)
  self:show()
  return self
end

class.create = create
