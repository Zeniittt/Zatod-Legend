module("ed.battleprepare", package.seeall)
TeamChannel = {}
TeamChannel.__index = TeamChannel

function TeamChannel:create(uiview, param)
  local obj = {}
  setmetatable(obj, self)
  obj:init(uiview, param)
  return obj
end

function TeamChannel:init(uiview, param)
  local param = param or {}
  self.ui = {}
  self.layer = CCLayer:create()
  self.current_team = 1
  local readNode = ed.readnode.create(self.layer, self.ui)
  readNode:addNode(self:getUiInfo())
  local select = self.ui[T("team_select_%s", self.current_team)]
  select:setVisible(true)
  WaitEvent("mainTouch", function(event, x, y)
    self:touch(event, x, y)
  end)
  WaitEvent("selectHero", function(num, team_index)
    self:selectHero(num, team_index)
  end)
end

function TeamChannel:getView()
  return self.layer
end

function TeamChannel:setVisible(visible)
  self.layer:setVisible(visible)
end

function TeamChannel:isVisible()
  return self.layer:isVisible()
end

function TeamChannel:setNextTeamVisible(visible)
  self.ui.next:setVisible(visible)
  self.ui.label_next:setVisible(visible)
end

function TeamChannel:selectHero(num, team_index)
  local team_index = team_index or self.current_team
  local index = T("team_label_info_%s", team_index)
  local label = self.ui[index]
  ed.setString(label, T("%s/%s", num, 5))
end

function TeamChannel:getCurrentTeam()
  return self.current_team
end

function TeamChannel:touch(event, x, y)
  if event == "began" then
    for k = 1, 3 do
      local buttom = self.ui[T("team_bg_%s", k)]
      local press = self.ui[T("team_bg_press_%s", k)]
      if ed.containsPoint(buttom, x, y) then
        press:setVisible(true)
      end
    end
    if ed.containsPoint(self.ui.next, x, y) then
      self.ui.next_press:setVisible(true)
    end
  elseif event == "ended" then
    self.ui.next_press:setVisible(false)
    if ed.containsPoint(self.ui.next, x, y) and self.ui.next:isVisible() then
      self.current_team = self.current_team + 1
      SendEvent("changeSelectTeam", self.current_team)
    end
    for k = 1, 3 do
      local buttom = self.ui[T("team_bg_%s", k)]
      local press = self.ui[T("team_bg_press_%s", k)]
      local select = self.ui[T("team_select_%s", k)]
      press:setVisible(false)
      select:setVisible(false)
      if ed.containsPoint(buttom, x, y) then
        self.current_team = k
        SendEvent("changeSelectTeam", k)
      end
    end
    local select = self.ui[T("team_select_%s", self.current_team)]
    select:setVisible(true)
  end
end

local team_label_fontinfo_tbl = {
  "team_index_1",
  "team_index_2",
  "team_index_3",
  "team_unselected"
}

function TeamChannel:getUiInfo()
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "next",
        res = "UI/alpha/1080P/common/button_a_butt.png"
      },
      layout = {
        position = ccp(710, 62)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "next_press",
        res = "UI/alpha/HVGA/pvp/pvp_button_confirm_2.png",
        parent = "next"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "label_next",
        text = T("\228\184\139\228\184\128\233\152\159"),
        size = 18
      },
      layout = {
        position = ccp(710, 62)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_1",
        res = "UI/alpha/HVGA/top_pvp/team_select_bg.png"
      },
      layout = {
        position = ccp(65, 348)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_press_1",
        res = "UI/alpha/HVGA/top_pvp/team_select _bg2.png",
        parent = "team_bg_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "team_select_1",
        res = "UI/alpha/HVGA/top_pvp/team_1_select.png",
        parent = "team_bg_1"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "team_label_1",
        text = T("1\233\152\159"),
        fontinfo = team_label_fontinfo_tbl[4]
      },
      layout = {
        position = ccp(65, 359)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "team_label_info_1",
        text = T("(0/5)"),
        fontinfo = team_label_fontinfo_tbl[4]
      },
      layout = {
        position = ccp(65, 340)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "arrow1_2",
        res = "UI/alpha/HVGA/fragment_compose_arrow.png",
        z = 5
      },
      layout = {
        position = ccp(65, 306)
      },
      config = {
        scalexy = {x = 0.9, y = 0.9},
        rotation = 90
      }
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_2",
        res = "UI/alpha/HVGA/top_pvp/team_select_bg.png"
      },
      layout = {
        position = ccp(65, 264)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_press_2",
        res = "UI/alpha/HVGA/top_pvp/team_select _bg2.png",
        parent = "team_bg_2"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "team_select_2",
        res = "UI/alpha/HVGA/top_pvp/team_2_select.png",
        parent = "team_bg_2"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "team_label_2",
        text = T("2\233\152\159"),
        fontinfo = team_label_fontinfo_tbl[4]
      },
      layout = {
        position = ccp(65, 275)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "team_label_info_2",
        text = T("(0/5)"),
        fontinfo = team_label_fontinfo_tbl[4]
      },
      layout = {
        position = ccp(65, 256)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "arrow2_3",
        res = "UI/alpha/HVGA/fragment_compose_arrow.png",
        z = 5
      },
      layout = {
        position = ccp(65, 222)
      },
      config = {
        scalexy = {x = 0.9, y = 0.9},
        rotation = 90
      }
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_3",
        res = "UI/alpha/HVGA/top_pvp/team_select_bg.png"
      },
      layout = {
        position = ccp(65, 180)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "team_bg_press_3",
        res = "UI/alpha/HVGA/top_pvp/team_select_bg2.png",
        parent = "team_bg_3"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "team_select_3",
        res = "UI/alpha/HVGA/top_pvp/team_3_select.png",
        parent = "team_bg_3"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "team_label_3",
        text = T("3\233\152\159"),
        fontinfo = team_label_fontinfo_tbl[4]
      },
      layout = {
        position = ccp(65, 191)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "team_label_info_3",
        text = T("(0/5)"),
        fontinfo = team_label_fontinfo_tbl[4]
      },
      layout = {
        position = ccp(65, 172)
      },
      config = {}
    }
  }
  return ui_info
end
