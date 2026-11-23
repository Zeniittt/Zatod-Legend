local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.addequip = class
local draglist_rect = CCRectMake(200, 35, 600, 330)

local function createNumberButtons(self)
  local numbers = {
    1,
    2,
    4,
    8,
    16,
    99,
    999
  }
  for index, number in ipairs(numbers) do
    local ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = "number_button_" .. index,
          res = "UI/alpha/1080P/common/elitetoggle-ns.png",
          capInsets = ed.DGRectMake(14, 14, 50, 10)
        },
        layout = {
          position = ccp(230 + 80 * (index - 1), 444)
        },
        config = {
          scaleSize = ed.DGSizeMake(100, 67)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "number_button_selected_" .. index,
          res = "UI/alpha/1080P/common/elitetoggle-s.png",
          capInsets = ed.DGRectMake(14, 14, 50, 10),
          parent = "number_button_" .. index
        },
        layout = {mediate = true},
        config = {
          visible = index == 1,
          scaleSize = ed.DGSizeMake(100, 67)
        }
      },
      {
        t = "Label",
        base = {
          name = "number_button_label_" .. index,
          text = tostring(numbers[index]),
          parent = "number_button_" .. index,
          size = 20
        },
        layout = {mediate = true}
      }
    }
    local readNode = ed.readnode.create(self.mainLayer, self.ui)
    readNode:addNode(ui_info)
    self:btRegisterButtonClick({
      button = self.ui["number_button_" .. index],
      selected = self.ui["number_button_selected_" .. index],
      key = "number" .. index,
      radioGroupName = "number",
      clickHandler = function()
        self.addNumber = numbers[index]
      end
    })
  end
end

class.createNumberButtons = createNumberButtons

local function createCategoryButtons(self)
  local texts = {
    T("\229\133\168\233\131\168"),
    T("\233\155\182\228\187\182"),
    T("\229\144\136\230\136\144\229\147\129"),
    T("\230\182\136\232\128\151\229\147\129"),
    T("\229\141\183\232\189\180"),
    T("\228\185\166\230\156\172"),
    T("\231\162\142\231\137\135")
  }
  for index, text in pairs(texts) do
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "category_button_" .. index,
          res = "UI/alpha/1080P/common/elitetoggle-ns.png"
        },
        layout = {
          position = ccp(80, 390 - 55 * (index - 1))
        }
      },
      {
        t = "Sprite",
        base = {
          name = "category_selected_" .. index,
          res = "UI/alpha/1080P/common/elitetoggle-s.png",
          parent = "category_button_" .. index
        },
        layout = {mediate = true},
        config = {visible = false}
      },
      {
        t = "Label",
        base = {
          name = "category_label_" .. index,
          text = text,
          size = 20,
          parent = "category_button_" .. index
        },
        layout = {mediate = true}
      }
    }
    local readNode = ed.readnode.create(self.filterDraglist.listLayer, self.ui)
    readNode:addNode(ui_info)
    self:btRegisterButtonClick({
      button = self.ui["category_button_" .. index],
      selected = self.ui["category_selected_" .. index],
      key = "category_button_" .. index,
      radioGroupName = "category_button",
      clickHandler = function()
        self:listCreate(self.list[text])
      end
    })
  end
  self.filterDraglist:initListHeight(55 * #texts)
  local default_category = 2
  self.ui["category_selected_" .. default_category]:setVisible(true)
  self:listCreate(self.list[texts[default_category]])
end

class.createCategoryButtons = createCategoryButtons

local function registerTouchHandler(self)
  self:btRegisterButtonClick({
    button = self.ui.back,
    press = self.ui.back_press,
    key = "back_button",
    clickHandler = function()
      ed.popScene()
    end
  })
end

class.registerTouchHandler = registerTouchHandler

local function getList(self)
  self.list = {}
  local data = ed.getDataTable("equip")
  for k, v in pairs(data) do
    if type(k) == "number" then
      local id = k
      local hasIcon = string.find(ed.readequip.value(id, "Icon") or "", "UI/", 0)
      if hasIcon then
        local name = ed.readequip.value(id, "Name")
        local category = ed.readequip.value(id, "Category")
        self.list[T("\229\133\168\233\131\168")] = self.list[T("\229\133\168\233\131\168")] or {}
        table.insert(self.list[T("\229\133\168\233\131\168")], {
          id = id,
          name = name,
          category = category
        })
        self.list[category] = self.list[category] or {}
        table.insert(self.list[category], {
          id = id,
          name = name,
          category = category
        })
      end
    end
  end
end

class.getList = getList

local function listCreate(self, list, key, tempList)
  self.draglist:clearList()
  local model = self.model
  self.currentList = list
  self.equips = {}
  list = tempList or list
  if not key and self.preSearchKey ~= "" then
    key = self.preSearchKey
  end
  for index, equip in pairs(list) do
    local id = equip.id
    local name = equip.name
    local category = equip.category
    if not key or key and string.match(name, key) then
      local container = CCSprite:create()
      container:setContentSize(CCSizeMake(200, 60))
      local icon = ed.readequip.createIcon(id, 50)
      icon:setPosition(ccp(30, 30))
      container:addChild(icon)
      local label = ed.createNode({
        t = "Label",
        base = {text = name, size = 20},
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(60, 30)
        }
      }, container)
      table.insert(self.equips, {
        id = id,
        name = name,
        icon = container
      })
      self:btRegisterButtonClick({
        button = container,
        pressScale = 0.95,
        key = "equip_icon_" .. id,
        clickHandler = function()
          ed.player:gmAddEquip(id, self.addNumber)
          local text = "\232\142\183\229\190\151" .. self.addNumber .. T("\228\184\170") .. name
          ed.showToast(text, ccp(440, 440))
        end,
        force = true,
        mcpMode = true,
        cliprect = draglist_rect
      })
    end
  end
  local amount = 0
  for index, equip in pairs(self.equips) do
    if equip.icon then
      equip.icon:setPosition(ccp(340 + 240 * ((index - 1) % 2), 335 - 65 * math.floor((index - 1) / 2)))
      self.draglist:addItem(equip.icon)
      amount = amount + 1
    end
  end
  self.draglist:initListHeight(65 * math.ceil(amount / 2) + 5)
end

class.listCreate = listCreate

local function createListLayer(self)
  local info = {
    cliprect = draglist_rect,
    container = self.mainLayer,
    noshade = true,
    zorder = 10,
    bar = {
      bglen = 330,
      bgpos = ccp(210, 205)
    }
  }
  self.draglist = ed.draglist.create(info)
  local info = {
    cliprect = CCRectMake(0, 35, 200, 382),
    container = self.mainLayer,
    noshade = true,
    zorder = 10
  }
  self.filterDraglist = ed.draglist.create(info)
end

class.createListLayer = createListLayer

local function createSearchLayer(self)
  self.ui.edit_frame = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/common/activate_input.png",
      capInsets = CCRectMake(8, 5, 6, 11)
    },
    layout = {
      position = ccp(460, 384)
    },
    config = {
      scaleSize = CCSizeMake(200, 40)
    }
  }, self.mainLayer)
  local info = {
    config = {
      editSize = self.ui.edit_frame:getContentSize(),
      maxLength = 60,
      fontColor = ccc3(0, 0, 0),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  edit_box.edit:setPosition(ccp(360, 364))
  self.mainLayer:addChild(edit_box.edit)
  self.edit_box = edit_box
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box:touch(event, x, y)
    end,
    key = "edit_box"
  })
  self:registerUpdateHandler("search_equip", function()
    self.preSearchKey = self.preSearchKey or ""
    local key = self.edit_box:getString()
    if key ~= self.preSearchKey then
      if key == "" then
        self.preSearchKey = key
        self:listCreate(self.currentList)
      else
        self.preSearchKey = key
        self:listCreate(self.currentList, key, self.list[T("\229\133\168\233\131\168")])
      end
    end
  end)
end

class.createSearchLayer = createSearchLayer

local function create()
  local self = base.create("gm_addequip")
  setmetatable(self, class.mt)
  self:getList()
  self.addNumber = 1
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/1080P/common/backbtn.png"
      },
      layout = {
        position = ccp(30, 444)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/1080P/common/backbtn-disabled.png",
        parent = "back"
      },
      layout = {mediate = true},
      config = {visible = false}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/1080P/common/equip_detail_bg.png",
        capInsets = CCRectMake(10, 10, 210, 180)
      },
      layout = {
        position = ccp(472, 220)
      },
      config = {
        scaleSize = CCSizeMake(600, 400)
      }
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  self:createListLayer()
  self:createNumberButtons()
  self:createCategoryButtons()
  self:createSearchLayer()
  self:registerTouchHandler()
  return self
end

class.create = create
