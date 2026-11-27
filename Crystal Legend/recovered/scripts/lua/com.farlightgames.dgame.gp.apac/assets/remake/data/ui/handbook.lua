local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.handbook = class
local lsr = ed.ui.handbooklsr.create()
local tagTextIndex = {
  ALL = 1,
  STR = 2,
  AGI = 3,
  INT = 4,
  HP = 5,
  AD = 6,
  AP = 7,
  ARM = 8,
  CRIT = 9,
  HPS = 10,
  MPS = 11,
  HEAL = 12
}
local tagText = {
  T("\229\133\168\233\131\168"),
  T("\229\138\155\233\135\143"),
  T("\230\149\143\230\141\183"),
  T("\230\153\186\229\138\155"),
  T("\231\148\159\229\145\189"),
  T("\231\137\169\230\148\187"),
  T("\230\179\149\228\188\164"),
  T("\230\138\164\231\148\178"),
  T("\230\154\180\229\135\187"),
  T("\229\155\158\232\161\128"),
  T("\229\155\158\232\147\157"),
  T("\230\178\187\231\150\151"),
  title1 = T("\229\133\168  \233\131\168"),
  title2 = T("\229\138\155  \233\135\143"),
  title3 = T("\230\149\143  \230\141\183"),
  title4 = T("\230\153\186  \229\138\155"),
  title5 = T("\230\156\128\229\164\167\231\148\159\229\145\189\229\128\188"),
  title6 = T("\231\137\169\231\144\134\230\148\187\229\135\187\229\138\155"),
  title7 = T("\233\173\148\230\179\149\229\188\186\229\186\166"),
  title8 = T("\231\137\169\231\144\134\230\138\164\231\148\178"),
  title9 = T("\231\137\169\231\144\134\230\154\180\229\135\187 \233\173\148\230\179\149\230\154\180\229\135\187"),
  title10 = T("\230\175\143\229\156\186\230\136\152\230\150\151\229\144\142\230\129\162\229\164\141\231\148\159\229\145\189"),
  title11 = T("\230\175\143\229\156\186\230\136\152\230\150\151\229\144\142\232\161\165\229\133\133\232\131\189\233\135\143"),
  title12 = T("\230\178\187\231\150\151\230\138\128\232\131\189\230\149\136\230\158\156\230\143\144\233\171\152"),
  list1 = "ALL",
  list2 = "STR",
  list3 = "AGI",
  list4 = "INT",
  list5 = "HP",
  list6 = "AD",
  list7 = "AP",
  list8 = "ARM",
  list9 = "CRIT",
  list10 = "HPS",
  list11 = "MPS",
  list12 = "HEAL"
}

local function doSelectTag(self, id)
  local function setTagSelect(id, isSelect)
    ed.playEffect(ed.sound.deo.common_click_feedback)
    
    local ui = self.ui
    local tag = ui["tag_" .. id]
    local tagSelect = ui["tag_select_" .. id]
    local tagLabel = ui["tag_label_" .. id]
    tag:setVisible(not isSelect)
    tagSelect:setVisible(isSelect)
    tagLabel:setPosition(self:getTagLabelPos(id))
    tagLabel:setZOrder(isSelect and 9 or 4)
    ed.setLabelColor(tagLabel, isSelect and ccc3(255, 0, 0) or ccc3(255, 255, 255))
  end
  
  self.currentTagid = self.currentTagid or 1
  id = id or 1
  local ui = self.ui
  local pid = self.currentTagid
  self.currentTagid = id
  if pid == id and (self.pageid or 1) == 1 then
  else
    lsr:report("handbooklsr")
  end
  setTagSelect(pid, false)
  setTagSelect(id, true)
  self:createPage(tagText["list" .. id], 1)
end

class.doSelectTag = doSelectTag

local function doSelectElement(self, id)
  lsr:report("clickElement")
  self.craftLayer = ed.ui.equipcraft.create({context = "handbook", eid = id})
  self.mainLayer:addChild(self.craftLayer.mainLayer, 100)
end

class.doSelectElement = doSelectElement

local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.back,
    press = ui.back_press,
    key = "back_button",
    clickHandler = function()
      lsr:report("clickBack")
      ed.popScene()
    end,
    clickInterval = 0.5,
    force = true
  })
  for i = 1, 12 do
    local tag = ui["tag_" .. i]
    local tagSelect = ui["tag_select_" .. i]
    local tagLabel = ui["tag_label_" .. i]
    
    local function setTagState(isPress)
      tagSelect:setVisible(isPress)
      tag:setVisible(not isPress)
      tagLabel:setPosition(self:getTagLabelPos(i, isPress))
      tagLabel:setZOrder(isPress and 9 or 4)
      ed.setLabelColor(tagLabel, isPress and ccc3(255, 0, 0) or ccc3(255, 255, 255))
    end
    
    self:btRegisterRectClick({
      rect = ed.getNodeSize(tag),
      key = "tag_" .. i,
      pressHandler = function()
        setTagState(true)
      end,
      cancelPressHandler = function()
        setTagState(false)
      end,
      clickHandler = function()
        self:doSelectTag(i)
      end,
      force = true
    })
  end
  local cpPressX, cpPressY, cpPressTime
  self:btRegisterHandler({
    key = "turn_page_touch",
    handler = function(event, x, y)
      if event == "began" then
        if ed.containsPoint(ui.book_page, x, y) then
          cpPressX, cpPressY = x, y
          cpPressTime = ed.getMillionTime()
        end
      elseif event == "ended" then
        if not cpPressTime then
          return
        end
        local time = ed.getMillionTime()
        local gap = time - cpPressTime
        if math.abs(x - cpPressX) > math.abs(y - cpPressY) then
          if 125 < x - cpPressX and gap < 1 then
            self:setPage("-1")
          elseif x - cpPressX < -125 and gap < 1 then
            self:setPage("+1")
          end
        end
        cpPressX, cpPressY, cpPressTime = nil, nil, nil
      end
    end,
    priority = -10
  })
  self:btRegisterButtonClick({
    button = ui.left_arrow,
    key = "left_arrow",
    pressScale = 0.95,
    clickInterval = 0.5,
    clickHandler = function()
      lsr:report("clickArrow")
      self:setPage("-1")
    end
  })
  self:btRegisterButtonClick({
    button = ui.right_arrow,
    key = "right_arrow",
    pressScale = 0.95,
    clickInterval = 0.5,
    clickHandler = function()
      lsr:report("clickArrow")
      self:setPage("+1")
    end
  })
  local clickElement
  self:btRegisterHandler({
    key = "equip_touch",
    handler = function(event, x, y)
      if event == "began" then
        for i = 1, #self.equipElements do
          local element = self.equipElements[i]
          if ed.containsPoint(element.icon, x, y) then
            clickElement = element
            element.icon:setScale(0.95)
            break
          end
        end
      elseif event == "ended" then
        if not clickElement then
          return
        end
        if tolua.isnull(clickElement.icon) then
          return
        end
        local element = clickElement
        element.icon:setScale(1)
        if ed.containsPoint(element.icon, x, y) then
          if element.isOpen then
            self:doSelectElement(element.id)
          else
            ed.showToast(T("\229\176\154\230\156\170\232\167\163\233\148\129\239\188\140\229\138\170\229\138\155\229\141\135\231\186\167\229\144\167"))
          end
        end
        clickEquipIndex = nil
      end
    end,
    clickInterval = 0.3,
    priority = -5
  })
end

class.registerTouchHandler = registerTouchHandler

local function getTagLabelPos(self, index, isLabelSelected)
  if resource_config.handbook_page_smaller then
    if 6 < index then
      return ccpAdd(self:getTagPosition(3, index, isLabelSelected), ccp(-50, 0))
    else
      return ccpAdd(self:getTagPosition(3, index, isLabelSelected), ccp(40, 0))
    end
  else
    return self:getTagPosition(3, index, isLabelSelected)
  end
end

class.getTagLabelPos = getTagLabelPos

local function getTagPosition(self, type, index, isLabelSelected)
  type = type or 1
  index = index or 1
  local osx = 30
  local x, y = 0, 0
  if index <= 6 then
    if type == 1 then
      x = 93 - 2 * (index - 1)
    elseif type == 2 then
      x = 83
    elseif type == 3 then
      if isLabelSelected == nil then
        if index == (self.currentTagid or 1) then
          x = 83 - osx - 24
        else
          x = 93 - osx - 2 * (index - 1) - 24
        end
      elseif isLabelSelected then
        x = 83 - osx - 24
      else
        x = 93 - osx - 2 * (index - 1) - 24
      end
    end
    y = 375 - 60 * (index - 1)
    if type == 3 then
      y = y + 3
    end
  else
    if type == 1 then
      x = 710 + 2 * (index - 7)
    elseif type == 2 then
      x = 720
    elseif type == 3 then
      if isLabelSelected == nil then
        if index == (self.currentTagid or 1) then
          x = 720 + osx + 24
        else
          x = 710 + osx + 2 * (index - 7) + 24
        end
      elseif isLabelSelected then
        x = 720 + osx + 24
      else
        x = 710 + osx + 2 * (index - 7) + 24
      end
    end
    y = 375 - 60 * (index - 7)
    if type == 3 then
      y = y + 3
    end
  end
  return ccp(x, y)
end

class.getTagPosition = getTagPosition

local function createTagButton(self)
  local ui_info = {}
  for i = 1, 12 do
    local b = {
      t = "Sprite",
      base = {
        name = "tag_" .. i,
        res = 6 < i and "UI/alpha/HVGA/handbook_right.png" or "UI/alpha/HVGA/handbook_left.png",
        z = 4
      },
      layout = {
        position = self:getTagPosition(1, i)
      },
      config = {
        visible = i ~= 1
      }
    }
    local pb = {
      t = "Sprite",
      base = {
        name = "tag_select_" .. i,
        res = 6 < i and "UI/alpha/HVGA/handbook_right_select.png" or "UI/alpha/HVGA/handbook_left_select.png",
        z = 9
      },
      layout = {
        position = self:getTagPosition(2, i)
      },
      config = {
        visible = i == 1
      }
    }
    local bt = {
      t = "Label",
      base = {
        name = "tag_label_" .. i,
        text = tagText[i],
        size = 18,
        z = i == 1 and 9 or 4
      },
      layout = {
        anchor = resource_config.handbook_page_smaller and ccp(0.5, 0.5) or 6 < i and ccp(1, 0.5) or ccp(0, 0.5),
        position = self:getTagLabelPos(i)
      },
      config = {
        dimensions = CCSizeMake(75, 0),
        color = i == 1 and ccc3(255, 0, 0) or ccc3(255, 255, 255),
        shadow = i ~= 1 and {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        } or nil
      }
    }
    table.insert(ui_info, b)
    table.insert(ui_info, pb)
    table.insert(ui_info, bt)
  end
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
end

class.createTagButton = createTagButton

local function getIconPosition(self, id)
  if not id or id < 1 or 12 < id then
    return ccp(0, 0)
  end
  local leftFirstX, leftFirstY = 196, 356
  local rightFirstX, rightFirstY = 476, 356
  local gapX, gapY = 130, 115
  if id <= 6 then
    return ccp(leftFirstX + gapX * ((id - 1) % 2), leftFirstY - gapY * math.floor((id - 1) / 2))
  else
    return ccp(rightFirstX + gapX * ((id - 7) % 2), leftFirstY - gapY * math.floor((id - 7) / 2))
  end
end

class.getIconPosition = getIconPosition

local function createIcon(self, info)
  local bg = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/handbook_equip_bg.png"
    },
    config = {isCascadeOpacity = true}
  })
  local name = info.name
  local isOpen
  if ed.player:getLevel() >= info.lr then
    local icon = ed.createNode({
      t = "CCNode",
      base = {
        node = ed.readequip.createIcon(info.id)
      },
      layout = {
        position = resource_config.handbook_page_smaller and ccp(50, 50) or ccp(57, 64)
      }
    }, bg)
    isOpen = true
  else
    local iconBg = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/handbook_icon_bg.png"
      },
      layout = {
        position = ccp(57, 64)
      },
      config = {isCascadeOpacity = true}
    }, bg)
    local icon = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/1080P/common/handbook_icon_lock.png"
      },
      layout = {
        position = ccp(33, 33)
      }
    }, iconBg)
    name = T("lv.%d \229\188\128\229\144\175", info.lr)
  end
  if not resource_config.handbook_page_smaller then
    local label = ed.createNode({
      t = "Label",
      base = {text = name, size = 18},
      layout = {
        position = ccp(57, 17)
      },
      config = {
        color = ccc3(182, 65, 21)
      }
    }, bg)
  end
  return bg, isOpen
end

class.createIcon = createIcon

local function createList(self, listName, page)
  local eAmount = #self.list[listName]
  local pAmount = math.ceil(eAmount / 12)
  local equipElements = {}
  for i = 12 * (page - 1) + 1, eAmount < 12 * page and eAmount or 12 * page do
    local info = self.list[listName][i]
    local icon, isOpen = self:createIcon(info)
    icon:setPosition(self:getIconPosition(i - 12 * (page - 1)))
    self.pageLayer:addChild(icon)
    table.insert(equipElements, {
      icon = icon,
      id = info.id,
      name = info.name,
      isOpen = isOpen
    })
  end
  self.equipElements = equipElements
end

class.createList = createList

local function doTransform(outNode, inNode, gap)
  gap = gap or 0.2
  inNode:setOpacity(0)
  if not tolua.isnull(outNode) then
    outNode:runAction(ed.readaction.create({
      t = "seq",
      CCFadeOut:create(gap),
      CCCallFunc:create(function()
        xpcall(function()
          outNode:removeFromParentAndCleanup(true)
          inNode:runAction(CCFadeIn:create(gap))
        end, EDDebug)
      end)
    }))
  else
    inNode:runAction(CCFadeIn:create(gap))
  end
end

class.doTransform = doTransform

local function setPageTitle(self, listName, page)
  if (self.currentListName or "") ~= listName then
    local pageTitle = ed.createNode({
      t = "Label",
      base = {
        text = tagText["title" .. tagTextIndex[listName]],
        size = 18
      },
      layout = {
        position = ccp(400, 433)
      },
      config = {
        color = ccc3(255, 0, 0),
        opacity = 0
      }
    }, self.container, 20)
    local element = self.ui.pageTitle
    self.ui.pageTitle = pageTitle
    class.doTransform(element, pageTitle)
  end
  if (self.currentListName or "") ~= listName or (self.pageid or 0) ~= page then
    self.pageAmount = math.max(math.ceil(#self.list[listName] / 12) or 1, 1)
    local text = resource_config.chinese_character_forbid and "%d / %d" or "\194\183 %d / %d \194\183"
    local pageNumber = ed.createNode({
      t = "Label",
      base = {
        text = string.format(text, page, self.pageAmount),
        size = 18
      },
      layout = {
        position = resource_config.handbook_page_smaller and ccp(620, 55) or ccp(640, 55)
      },
      config = {
        color = ccc3(174, 133, 76),
        opacity = 0
      }
    }, self.container, 20)
    local element = self.ui.pageNumber
    self.ui.pageNumber = pageNumber
    class.doTransform(element, pageNumber)
  end
end

class.setPageTitle = setPageTitle

local function setPage(self, page)
  if page == "+1" then
    page = self.pageid + 1
  end
  if page == "-1" then
    page = self.pageid - 1
  end
  local prePage = self.pageid
  self:createPage(self.currentListName, page)
  local text = resource_config.chinese_character_forbid and "%d / %d" or "\194\183 %d / %d \194\183"
  ed.setString(self.ui.pageNumber, string.format(text, self.pageid, self.pageAmount))
  if prePage == self.pageid then
    lsr:report("tuenPageFailed")
  else
    lsr:report("turnPage")
  end
end

class.setPage = setPage

local function createPage(self, listName, page)
  listName = listName or self.currentListName or "ALL"
  page = page or 1
  local eAmount = #self.list[listName]
  local pAmount = math.ceil(eAmount / 12)
  if page > pAmount then
    page = pAmount
  end
  if page < 1 then
    page = 1
  end
  self:setPageTitle(listName, page)
  if (self.currentListName or "") ~= listName or self.pageid ~= page then
    self.currentListName = listName
    self.pageid = page
    local element = self.pageLayer
    local pageLayer = ed.createNode({
      t = "Sprite",
      config = {isCascadeOpacity = true}
    }, self.container, 20)
    self.pageLayer = pageLayer
    self:createList(listName, page)
    class.doTransform(element, pageLayer, 0.05)
  end
end

class.createPage = createPage

local function create()
  ed.playEffect(ed.sound.deo.common_click_feedback)
  local self = base.create("handbook")
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  local container = CCLayer:create()
  self.mainLayer:addChild(container)
  self.container = container
  local ui = self.ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/1080P/common/bg.jpg"
      },
      layout = {
        position = ccp(400, 240)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "book_bg",
        res = "UI/alpha/1080P/common/handbook_bg.jpg"
      },
      layout = {
        position = ccp(400, 240)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "book_page_shade",
        res = "UI/alpha/1080P/common/handbook_bg_2.jpg",
        z = 5
      },
      layout = {
        position = ccp(400, 240)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "book_page",
        res = "UI/alpha/1080P/common/handbook_bg_1.jpg",
        z = 10
      },
      layout = {
        position = ccp(400, 240)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/1080P/common/backbtn.pngnnn"
      },
      layout = {
        position = ccp(70, 440)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/1080P/common/backbtn-disabled.png"
      },
      layout = {
        position = ccp(70, 440)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "left_arrow",
        res = "UI/alpha/1080P/common/handbook_left_arrow.jpg",
        z = 20
      },
      layout = {
        position = ccp(295, 50)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "right_arrow",
        res = "UI/alpha/1080P/common/handbook_right_arrow.jpg",
        z = 20
      },
      layout = {
        position = ccp(515, 50)
      }
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  self:createTagButton()
  self.list = ed.readequip.classifyEquip()
  self:createPage("ALL", 1)
  self:registerTouchHandler()
  ed.tutorial.tell("aboutHandbook", self.mainLayer)
  ed.endTeach("aboutHandbook")
  return self
end

class.create = create
