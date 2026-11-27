module("ed.battleprepare", package.seeall)
Channel = {}
Channel.__index = Channel
allChannel = "all"
collectChannel = "collect"
frontChannel = "front"
middleChannel = "middle"
backChannel = "back"
presetTeam = "presetTeam"
local pressid

function Channel:create(uiview, param)
  local obj = {}
  setmetatable(obj, self)
  obj:init(uiview, param)
  return obj
end

function Channel:release()
  self.layer:removeFromParentAndCleanup(true)
  self.layer = nil
  self.heropool = nil
  self.ui = {}
  self.listButton = {}
  self.buttonPress = {}
  self.listLabel = {}
end

function Channel:init(uiview, param)
  local param = param or {}
  self.layer = CCLayer:create()
  self.ui = {}
  self.clid = allChannel
  self.curTab = "team"
  self.tabButtons = {
    "team",
    "recommend",
    "mercenary"
  }
  self.listButton = {}
  self.buttonPress = {}
  self.listLabel = {}
  self.uiview = uiview
  self.heropool = uiview.pool
  local readNode = ed.readnode.create(self.layer, self.ui)
  readNode:addNode(self:getUiInfo())
  self:createTabButtonList()
  if param.presetHide then
    self.ui.preset:setVisible(false)
    self.ui.preset_back:setVisible(false)
  end
  self:changeChannel(allChannel)
  self:initTabUI()
  self:registerTouchEvent()
end

function Channel:initTabUI()
  self:setRecommendVisible(false)
  self:setMercenaryVisible(false)
end

function Channel:setTagVisible(visible)
  self.ui.team:setVisible(visible)
  self.ui.team_press:setVisible(visible)
  self.ui.team_icon:setVisible(visible)
  self.ui.team_label:setVisible(visible)
end

function Channel:setRecommendVisible(visible)
  self.ui.recommend:setVisible(visible)
  self.ui.recommend_press:setVisible(false)
  self.ui.recommend_icon:setVisible(visible)
  self.ui.recommend_label:setVisible(visible)
end

function Channel:setMercenaryVisible(visible)
  self.ui.mercenary:setVisible(visible)
  self.ui.mercenary_press:setVisible(false)
  self.ui.mercenary_icon:setVisible(visible)
  self.ui.mercenary_label:setVisible(visible)
end

function Channel:getCurrentChannel()
  return self.clid
end

function Channel:setVisible(visible)
  self.layer:setVisible(visible)
end

function Channel:isVisible()
  return self.layer:isVisible()
end

function Channel:refreshChannel(channel)
  if self.clid == channel then
    return
  end
  for k, v in pairs(self.listButton) do
    if k == channel then
      self.listButton[k]:setVisible(false)
      self.buttonPress[k]:setVisible(true)
    else
      self.listButton[k]:setVisible(true)
      self.buttonPress[k]:setVisible(false)
    end
  end
  self.clid = channel
end

function Channel:changeChannel(channel)
  if self.curChannel == channel then
    return
  end
  self.curChannel = channel
  self:refreshChannel(channel)
  SendEvent("changeChannel", channel)
end

function Channel:getView()
  return self.layer
end

function Channel:registerTouchEvent()
  WaitEvent("mainTouch", function(event, x, y)
    if event == "began" then
      if self.ui.preset:isVisible() and ed.containsPoint(self.ui.preset, x, y) then
        self.ui.preset_press:setVisible(true)
        pressid = "preset"
        return
      end
      if self.ui.preset_back:isVisible() and ed.containsPoint(self.ui.preset_back, x, y) then
        self.ui.preset_back_press:setVisible(true)
        pressid = "preset_back"
        return
      end
      for _, tab in ipairs(self.tabButtons) do
        if self.ui[tab]:isVisible() and ed.containsPoint(self.ui[tab], x, y) then
          self.ui[tab .. "_press"]:setVisible(true)
          pressid = tab
          return
        end
      end
    elseif event == "ended" and pressid then
      if pressid == "preset" then
        self.ui.preset_press:setVisible(false)
      else
        self.ui[pressid .. "_press"]:setVisible(true)
      end
      if pressid == "preset_back" then
        self.ui.preset_back_press:setVisible(false)
      end
      self:changeTab(pressid)
      for k, v in pairs(self.listButton) do
        v:setVisible(pressid ~= "preset")
      end
      if pressid == "preset" then
        for k, v in pairs(self.buttonPress) do
          v:setVisible(false)
        end
      else
        for k, v in pairs(self.buttonPress) do
          v:setVisible(k == self.curChannel)
        end
      end
      for k, v in pairs(self.listLabel) do
        v:setVisible(pressid ~= "preset")
      end
      self.ui.preset:setVisible(pressid ~= "preset")
      self.ui.preset_back:setVisible(pressid == "preset")
      pressid = nil
    end
  end)
end

function Channel:changeTab(tab)
  if self.curTab == tab then
    return
  end
  self.curTab = tab
  self:refreshTabUI()
  if tab == "preset_back" then
    SendEvent("changeTab", "team")
  else
    SendEvent("changeTab", tab)
  end
end

function Channel:refreshTabUI()
  for _, button in ipairs(self.tabButtons) do
    if self.curTab == button then
      self.ui[button .. "_press"]:setVisible(true)
    else
      self.ui[button .. "_press"]:setVisible(false)
    end
  end
end

function Channel:createTabButtonList()
  self:createButtonDraglist()
  local resConfig = {
    {
      key = "all",
      button = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      press = "UI/alpha/HVGA/common/common_btn_hold_s.png",
      text = "\229\133\168\233\131\168"
    },
    {
      key = "collect",
      button = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      press = "UI/alpha/HVGA/common/common_btn_hold_s.png",
      text = "\230\148\182\232\151\143"
    },
    {
      key = "front",
      button = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      press = "UI/alpha/HVGA/common/common_btn_hold_s.png",
      text = "\229\137\141\230\142\146"
    },
    {
      key = "middle",
      button = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      press = "UI/alpha/HVGA/common/common_btn_hold_s.png",
      text = "\228\184\173\230\142\146"
    },
    {
      key = "back",
      button = "UI/alpha/HVGA/common/common_btn_hold_d.png",
      press = "UI/alpha/HVGA/common/common_btn_hold_s.png",
      text = "\229\144\142\230\142\146"
    }
  }
  local buttonIndex = 0
  for _, res in pairs(resConfig) do
    local key = res.key
    if self:openMode(key) then
      buttonIndex = buttonIndex + 1
      local button = ed.createSprite(res.button)
      local press = ed.createSprite(res.press)
      local label = ed.createLabelTTF(res.text, 18)
      ed.setLabelFontInfo(label, "dark_white_stroke")
      button:setPosition(ccp(693, 468 - buttonIndex * 45))
      press:setPosition(ccp(693, 468 - buttonIndex * 45))
      label:setPosition(ccp(693, 470 - buttonIndex * 45))
      self.buttonDraglist.listLayer:addChild(button)
      self.buttonDraglist.listLayer:addChild(press)
      self.buttonDraglist.listLayer:addChild(label)
      press:setVisible(false)
      self.listButton[key] = button
      self.buttonPress[key] = press
      self.listLabel[key] = label
    end
  end
  self.buttonDraglist:initListHeight(buttonIndex * 45)
  self:initCurrentTabButton()
end

function Channel:initCurrentTabButton()
  self.listButton.all:setVisible(false)
  self.buttonPress.all:setVisible(true)
end

function Channel:openMode(key)
  if key == "collect" then
    return ed.herorecommend.manager:isOpen()
  end
  return true
end

function Channel:createButtonDraglist()
  local info = {
    cliprect = CCRectMake(635, 185, 120, 265),
    container = self.layer,
    zorder = 10,
    noshade = true,
    doPressIn = self:doButtonListPress(),
    cancelPressIn = self:doButtonListCancelPressIn()
  }
  self.buttonDraglist = ed.draglist.create(info)
end

function Channel:doButtonListPress()
  local function handler(x, y)
    for k, v in pairs(self.listButton) do
      if v:isVisible() and ed.containsPoint(v, x, y) then
        v:setVisible(false)
        
        self.buttonPress[k]:setVisible(true)
        return k
      end
    end
  end
  
  return handler
end

function Channel:doButtonListCancelPressIn()
  local function handler(x, y, k)
    xpcall(function()
      local v = self.listButton[k]
      
      if ed.containsPoint(v, x, y) then
        self:changeChannel(k)
      else
        v:setVisible(true)
        self.buttonPress[k]:setVisible(false)
      end
    end, EDDebug)
  end
  
  return handler
end

function Channel:getUiInfo()
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "team",
        res = "UI/alpha/HVGA/hero_class_bg_2.png"
      },
      layout = {
        position = ccp(74, 365)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "team_press",
        res = "UI/alpha/HVGA/hero_class_bg_1.png",
        z = 6
      },
      layout = {
        position = ccp(74, 365)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "team_icon",
        text = T("\230\136\152\233\152\159"),
        size = 20,
        z = 10
      },
      layout = {
        position = ccp(77, 353)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "team_label",
        res = "UI/alpha/HVGA/corps_1.png",
        z = 20
      },
      layout = {
        position = ccp(77, 378)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "recommend",
        res = "UI/alpha/HVGA/hero_class_bg_2.png"
      },
      layout = {
        position = ccp(74, 285)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "recommend_press",
        res = "UI/alpha/HVGA/hero_class_bg_1.png",
        z = 6
      },
      layout = {
        position = ccp(74, 285)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "recommend_icon",
        text = T("\230\142\168\232\141\144"),
        size = 20,
        z = 10
      },
      layout = {
        position = ccp(77, 273)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "recommend_label",
        res = "UI/alpha/HVGA/hero_recommend/hero_recommend_icon_fire.png",
        z = 20
      },
      layout = {
        position = ccp(77, 298)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "mercenary",
        res = "UI/alpha/HVGA/hero_class_bg_2.png"
      },
      layout = {
        position = ccp(74, 205)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "mercenary_press",
        res = "UI/alpha/HVGA/hero_class_bg_1.png",
        z = 6
      },
      layout = {
        position = ccp(74, 205)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "mercenary_icon",
        text = T("\228\189\163\229\133\181"),
        size = 20,
        z = 10
      },
      layout = {
        position = ccp(77, 193)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "mercenary_label",
        res = "UI/alpha/HVGA/heroselect_tag_hire.png",
        z = 20
      },
      layout = {
        position = ccp(77, 218)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "preset",
        res = "UI/alpha/HVGA/herodetail-detail-n.png",
        z = 11,
        capInsets = CCRectMake(40, 25, 100, 25)
      },
      layout = {
        position = ccp(694, 175)
      },
      config = {
        scaleSize = CCSizeMake(120, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "preset_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
        capInsets = CCRectMake(40, 25, 100, 25),
        parent = "preset"
      },
      layout = {
        position = ccp(0, 0),
        anchor = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(120, 50),
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "preset_icon",
        res = "UI/alpha/HVGA/pre_set.png",
        parent = "preset"
      },
      layout = {
        position = ccp(25, 25)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "preset_label",
        text = T("\233\162\132\232\174\190"),
        size = 24,
        parent = "preset"
      },
      layout = {
        position = ccp(70, 25)
      },
      config = {
        ccc3(255, 255, 255),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "preset_back",
        res = "UI/alpha/HVGA/herodetail-detail-n.png",
        z = 11,
        capInsets = CCRectMake(40, 25, 100, 25)
      },
      layout = {
        position = ccp(694, 175)
      },
      config = {
        scaleSize = CCSizeMake(120, 50),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "preset_back_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
        capInsets = CCRectMake(40, 25, 100, 25),
        parent = "preset_back"
      },
      layout = {
        position = ccp(0, 0),
        anchor = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(120, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "preset_back_label",
        text = T("\232\191\148\229\155\158"),
        size = 24,
        parent = "preset_back"
      },
      layout = {
        position = ccp(60, 25)
      },
      config = {
        ccc3(255, 255, 255),
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    }
  }
  return ui_info
end
