local class, base = newwindow()
local ed = ed
ed.ui.animeActivity = class
class.__index = class
local initDraglistHeight = 360
ed.ui.animeActivity.show = true
ed.ui.animeActivity.layout = "top"
ed.ui.animeActivity.deadline_desc = "\231\172\172\228\186\140\233\155\134\231\129\171\231\131\173\228\184\138\230\152\160\239\188\129"

local function setTextContent(ui, Dimensions, HorizontalAlignment, VerticalAlignment)
  ui:setDimensions(Dimensions)
  ui:setHorizontalAlignment(HorizontalAlignment)
  ui:setVerticalAlignment(VerticalAlignment)
end

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local function doPressInList(self)
  local function handler(x, y)
    for k, v in pairs(self.buttonData) do
      local sp_button = v.sp_button
      
      if ed.containsPoint(sp_button, x, y) then
        sp_button:setScale(0.9)
        return v
      end
    end
  end
  
  return handler
end

class.doPressInList = doPressInList

local function doClickInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.sp_button
    sp_button:setScale(1)
    if ed.containsPoint(sp_button, x, y) then
      local url = v.url
      print("\230\137\147\229\188\128\228\186\134\230\181\143\232\167\136\229\153\168:" .. url)
      ed.openURL(url)
    end
  end
  
  return handler
end

class.doClickInList = doClickInList

local function cancelPressInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.sp_button
    sp_button:setScale(1)
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function cancelClickInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.sp_button
    sp_button:setScale(1)
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList

local function doMainLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function initTitle(self)
  local layer = self.draglist:getList()
  local em = {}
  local oh = initDraglistHeight
  if not self.listHeight then
    self.listHeight = 0
  end
  local lh = self.listHeight
  lh = lh + 20
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "title_bg",
        res = "UI/alpha/HVGA/banner_herocartoon.jpg"
      },
      layout = {
        position = ccp(225, oh - lh - 60)
      },
      config = {scale = 1}
    }
  }
  readNode = ed.readnode.create(layer, em)
  readNode:addNode(ui_info)
  self.listHeight = self.listHeight + 150
  self.draglist:initListHeight(self.listHeight)
end

class.initTitle = initTitle

local function createEndInfo(self)
  local layer = self.draglist:getList()
  local em = {}
  local oh = initDraglistHeight
  if not self.listHeight then
    self.listHeight = 0
  end
  local lh = self.listHeight
  lh = lh + 20
  ui_info = {
    {
      t = "Label",
      base = {
        name = "str_title",
        text = T("\228\184\139\233\155\134\230\155\180\231\178\190\229\189\169\239\188\140\230\149\172\232\175\183\230\156\159\229\190\133!"),
        size = 18
      },
      layout = {
        position = ccp(225, oh - lh)
      },
      config = {
        color = ccc3(241, 240, 113)
      }
    }
  }
  readNode = ed.readnode.create(layer, em)
  readNode:addNode(ui_info)
  self.listHeight = self.listHeight + 60
  self.draglist:initListHeight(self.listHeight)
end

class.createEndInfo = createEndInfo

local function createOldAnime(self, table_date)
  local layer = self.draglist:getList()
  local em = {}
  local oh = initDraglistHeight
  if not self.listHeight then
    self.listHeight = 0
  end
  local lh = self.listHeight
  lh = lh + 40
  ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "sp_bg",
        res = "UI/alpha/HVGA/pvp/pvp_replay_name_bg.png",
        capInsets = CCRectMake(0, 0, 211, 1)
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(40, oh - lh + 35)
      },
      config = {
        scaleSize = CCSizeMake(550, 250)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_num",
        text = T("\231\172\172     \233\155\134"),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, oh - lh)
      },
      config = {
        color = ccc3(248, 248, 214)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "btn_play",
        res = "UI/alpha/HVGA/play_btn_1.png"
      },
      layout = {
        position = ccp(390, oh - lh - 55)
      },
      config = {scale = 1}
    },
    {
      t = "Label",
      base = {
        name = "str_play",
        text = T("\231\130\185\229\135\187\232\167\130\231\156\139"),
        size = 16
      },
      layout = {
        position = ccp(390, oh - lh - 90)
      },
      config = {
        color = ccc3(248, 248, 214)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_title",
        text = table_date.ShowTitle,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(125, oh - lh)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        },
        color = ccc3(248, 248, 214)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_context",
        text = T("\229\137\167\230\131\133\231\174\128\228\187\139"),
        size = 18
      },
      layout = {
        position = ccp(30, oh - lh - 35),
        anchor = ccp(0, 1)
      },
      config = {
        color = ccc3(248, 248, 214),
        verticalAlignment = 0,
        horizontalAlignment = 0
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sp_line",
        res = "UI/alpha/HVGA/awake/separate_line.png"
      },
      layout = {
        position = ccp(40, oh - lh - 90),
        anchor = ccp(0, 0.5)
      },
      config = {scale = 1}
    }
  }
  readNode = ed.readnode.create(layer, em)
  readNode:addNode(ui_info)
  ed.setString(em.str_title, table_date.ShowTitle)
  ed.setString(em.str_context, table_date.ShowDetail)
  setTextContent(em.str_context, CCSizeMake(290, 0), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
  local dheight = em.str_context:getContentSize().height
  local sp_line = em.sp_line
  local lable_context = em.str_context
  local number_node = ed.getNumberNode({
    text = table_date.ShowNum,
    folder = "white",
    padding = -2
  }).node
  number_node:setAnchorPoint(ccp(0.5, 0))
  number_node:setCascadeOpacityEnabled(true)
  number_node:setScale(1)
  em.str_num:addChild(number_node)
  number_node:setPosition(ccp(45, 0))
  local v_data = {
    url = table_date.ShowUrl,
    sp_button = em.btn_play
  }
  table.insert(self.buttonData, v_data)
  sp_line:setPosition(35, lable_context:getPositionY() - dheight - 20)
  sp_line:setOpacity(122)
  em.sp_bg:setContentSize(CCSizeMake(550, dheight + 89))
  self.listHeight = self.listHeight + dheight + 100
  self.draglist:initListHeight(self.listHeight)
end

class.createOldAnime = createOldAnime

local function createNewAnime(self, table_date)
  local layer = self.draglist:getList()
  local em = {}
  local oh = initDraglistHeight
  if not self.listHeight then
    self.listHeight = 0
  end
  local lh = self.listHeight
  lh = lh + 30
  local str_msg = T("  \229\138\168\231\148\187\227\128\138\232\139\177\233\155\132\229\136\171\233\151\185\227\128\139\231\148\177\229\133\139\233\135\140\228\184\157\229\138\168\231\148\187\229\155\162\233\152\159\229\136\182\228\189\156\229\135\186\229\147\129\239\188\140\232\174\178\232\191\176\231\154\132\230\152\175\229\191\171\233\128\146\229\145\152\232\176\173\229\176\143\229\159\186\229\155\160\228\184\186\228\184\128\230\172\161\230\132\143\229\164\150\239\188\140\231\169\191\232\182\138\229\136\176\228\186\134\232\139\177\233\155\132\228\184\150\231\149\140\228\184\173\239\188\140\230\156\186\231\188\152\229\183\167\229\144\136\230\136\144\228\184\186\228\186\134\230\173\163\228\185\137\233\152\181\229\174\185\233\162\134\232\162\150\233\178\129\230\156\172\232\136\185\233\149\191\231\154\132\233\147\184\233\173\130\229\184\136\239\188\140\229\188\128\229\167\139\228\186\134\228\184\128\230\174\181\231\166\187\229\165\135\230\144\158\231\172\145\231\154\132\229\134\146\233\153\169\230\151\133\231\168\139\227\128\130")
  ui_info = {
    {
      t = "Label",
      base = {
        name = "str_title_2",
        text = T("\230\156\128\230\150\176\229\137\167\233\155\134\239\188\154"),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, oh - lh + 20)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "sp_bg",
        res = "UI/alpha/HVGA/pvp/pvp_replay_name_bg.png",
        capInsets = CCRectMake(0, 0, 211, 1)
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(40, oh - lh + 7)
      },
      config = {
        scaleSize = CCSizeMake(550, 250)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_num",
        text = T("\231\172\172     \233\155\134"),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, oh - lh - 20)
      },
      config = {
        color = ccc3(248, 248, 214)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "btn_play",
        res = "UI/alpha/HVGA/play_btn_1.png"
      },
      layout = {
        position = ccp(390, oh - lh - 79)
      },
      config = {scale = 1}
    },
    {
      t = "Label",
      base = {
        name = "str_play",
        text = T("\231\130\185\229\135\187\232\167\130\231\156\139"),
        size = 16
      },
      layout = {
        position = ccp(390, oh - lh - 119)
      },
      config = {
        color = ccc3(248, 248, 214)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_title",
        text = table_date.ShowTitle,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(125, oh - lh - 20)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        },
        color = ccc3(248, 248, 214)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_context",
        text = T("\229\137\167\230\131\133\231\174\128\228\187\139"),
        size = 18
      },
      layout = {
        position = ccp(30, oh - lh - 40),
        anchor = ccp(0, 1)
      },
      config = {
        color = ccc3(248, 248, 214),
        verticalAlignment = 0,
        horizontalAlignment = 0
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sp_line_1",
        res = "UI/alpha/HVGA/awake/separate_line.png"
      },
      layout = {
        position = ccp(60, oh - lh - 110),
        anchor = ccp(0, 0.5)
      },
      config = {scale = 1}
    },
    {
      t = "Label",
      base = {
        name = "str_title_3",
        text = T("\229\138\168\231\148\187\231\174\128\228\187\139\239\188\154"),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, oh - lh - 135),
        anchor = ccp(0, 1)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_title_4",
        text = str_msg,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, oh - lh - 150),
        anchor = ccp(0, 1)
      },
      config = {
        color = ccc3(248, 248, 214),
        verticalAlignment = 0,
        horizontalAlignment = 0
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sp_line_2",
        res = "UI/alpha/HVGA/awake/separate_line.png"
      },
      layout = {
        position = ccp(60, oh - lh - 110),
        anchor = ccp(0, 0.5)
      },
      config = {scale = 1}
    }
  }
  readNode = ed.readnode.create(layer, em)
  readNode:addNode(ui_info)
  ed.setString(em.str_title, table_date.ShowTitle)
  ed.setString(em.str_context, table_date.ShowDetail)
  setTextContent(em.str_context, CCSizeMake(290, 0), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
  setTextContent(em.str_title_4, CCSizeMake(400, 0), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
  local dheight = em.str_context:getContentSize().height
  local dheight_1 = em.str_title_4:getContentSize().height
  local sp_line = em.sp_line_1
  local lable_context = em.str_context
  local number_node = ed.getNumberNode({
    text = table_date.ShowNum,
    folder = "white"
  }).node
  number_node:setAnchorPoint(ccp(0.5, 0))
  number_node:setCascadeOpacityEnabled(true)
  number_node:setScale(1)
  em.str_num:addChild(number_node)
  number_node:setPosition(ccp(45, 0))
  local v_data = {
    url = table_date.ShowUrl,
    sp_button = em.btn_play
  }
  table.insert(self.buttonData, v_data)
  em.str_title_3:setPosition(30, lable_context:getPositionY() - dheight - 40)
  em.str_title_4:setPosition(30, lable_context:getPositionY() - dheight - 70)
  sp_line:setPosition(35, lable_context:getPositionY() - dheight - 20)
  sp_line:setOpacity(122)
  sp_line = em.sp_line_2
  sp_line:setPosition(35, lable_context:getPositionY() - dheight - dheight_1 - 80)
  sp_line:setOpacity(122)
  em.sp_bg:setContentSize(CCSizeMake(550, dheight + 70))
  self.listHeight = self.listHeight + dheight + 30 + dheight_1 + 130
  self.draglist:initListHeight(self.listHeight)
end

class.createNewAnime = createNewAnime

local function getAnimeTableData(self)
  local animeTable = {}
  local data_table = self.info._extra_info._cartoon
  if data_table then
    for k, v_data in pairs(data_table) do
      if v_data then
        local d_table = {
          ShowUrl = v_data._url,
          ShowNum = v_data._id,
          ShowTitle = T(v_data._title),
          ShowDetail = T(v_data._desc)
        }
        table.insert(animeTable, d_table)
      end
    end
  end
  table.sort(animeTable, function(a, b)
    return tonumber(a.ShowNum) < tonumber(b.ShowNum)
  end)
  return animeTable
end

class.getAnimeTableData = getAnimeTableData

local function createAnimeInfo(self)
  self:initTitle()
  local animeTable = self:getAnimeTableData()
  if not animeTable then
    return
  end
  local newIndex = 1
  newIndex = #animeTable
  self:createNewAnime(animeTable[newIndex])
  for i, v in ipairs(animeTable) do
    if i ~= newIndex then
      self:createOldAnime(animeTable[i])
    end
  end
  self:createEndInfo()
end

class.createAnimeInfo = createAnimeInfo

local function init(self)
  local draglistInfo = {
    cliprect = CCRectMake(17, 65, 417, 295),
    rect = CCRectMake(20, 65, 410, 295),
    container = self.frameUi.a_frame,
    priority = -800,
    noshade = true,
    swallow = false,
    bar = {
      bglen = 260,
      bgpos = ccp(15, 218)
    },
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(draglistInfo)
  self:createAnimeInfo()
end

class.init = init

local function create(self, info)
  self.container, self.frameUi = ed.editorui(ed.uieditor.ActivityFrame)
  self.container:registerScriptTouchHandler(self:doMainLayerTouch(), false, -500, false)
  self.container:setTouchEnabled(true)
  self.listHeight = 0
  self.buttonData = {}
  self.info = info
  self:init()
  self.frameUi.enter_button:setVisible(false)
  self.frameUi.enter_label:setVisible(false)
  ed.setString(self.frameUi.a_title, T("\227\128\138\232\139\177\233\155\132\229\136\171\233\151\185\227\128\139\229\188\128\230\146\173\229\149\166\239\188\129"))
  self.frameUi.a_title:setShadow(ccc3(0, 0, 0), ccp(0, 2))
  return self
end

class.create = create
