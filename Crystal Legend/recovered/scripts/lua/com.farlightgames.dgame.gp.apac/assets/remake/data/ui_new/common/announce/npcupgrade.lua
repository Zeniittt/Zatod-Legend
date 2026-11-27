local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.npcUpgrade = class
local resFactor = ed.display.resFactor

local function create(param)
  local self = base.create("npcUpgrade")
  setmetatable(self, class.mt)
  local container = self.container
  local handler = param.handler
  self:setClickDestroyEnabled(false)
  self:setDestroyHandler(handler)
  local level = param.level
  local ui = {}
  self.ui = ui
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/main_vit_tips.png", CCRectMake(10 / resFactor, 10 / resFactor, 58 / resFactor, 26 / resFactor))
  container:addChild(bg)
  self.ui.bg = bg
  local huContainer = CCSprite:create()
  self.huContainer = huContainer
  huContainer:setAnchorPoint(ccp(0, 0))
  huContainer:setPosition(ccp(0, 0))
  bg:addChild(huContainer, 5)
  local readnode = ed.readnode.create(huContainer, self.ui)
  local width = 450
  local height = 0
  local npcRow = ed.getDataTable("AwakeNPC")[level]
  height = height + 100
  local gs_ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "hp_board",
        res = "UI/alpha/HVGA/announce_text_bg_blue.png"
      },
      layout = {
        position = ccp(width / 2, height + 25)
      },
      config = {
        fix_size = CCSizeMake(width, 40)
      }
    },
    {
      t = "HorizontalNode",
      base = {name = "gs", nodeArray = gs_ui},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(145, height + 25)
      },
      config = {},
      ui = {
        {
          t = "Label",
          base = {
            name = "title",
            text = T("\231\173\137\231\186\167\239\188\154"),
            size = 20
          },
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "pre_gs",
            text = tostring(level - 1),
            size = 18
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        },
        {
          t = "Sprite",
          base = {
            name = "gs_arrow",
            res = "UI/alpha/HVGA/player_levelup_arrow.png",
            offset = 10
          }
        },
        {
          t = "Label",
          base = {
            name = "gs",
            text = tostring(level),
            size = 18,
            offset = 10
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
    }
  }
  readnode:addNode(ui_info)
  height = height - 45
  ui_info = {
    {
      t = "Label",
      base = {
        name = "npcdialog",
        text = npcRow.Dialogue,
        size = 20
      },
      layout = {
        position = ccp(width / 2, height + 25)
      },
      config = {
        color = ccc3(42, 177, 255)
      }
    }
  }
  readnode:addNode(ui_info)
  height = height - 25
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/1080P/common/common_tips_button_close_1.png"
      },
      layout = {
        position = ccp(0, 0)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/1080P/common/common_tips_button_close_2.png",
        parent = "close"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  readnode:addNode(ui_info)
  height = height + 110 + 40
  local light = ed.createSprite("UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(ccp(width / 2, height))
  light:setColor(ccc3(42, 177, 255))
  light:setScale(1.1)
  ui.light = light
  bg:addChild(light)
  light:setVisible(false)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
  local title = ed.createSprite("UI/alpha/HVGA/awake/herodetail_popup_npc_title.png")
  title:setPosition(ccp(width / 2, height))
  ui.title = title
  bg:addChild(title)
  title:setVisible(false)
  bg:setContentSize(CCSizeMake(width, height))
  bg:setPosition(ccp(ed.display.center.x, 240))
  self.ui.close:setPosition(ccp(width - 10, height - 20))
  self:registerTouchHandler(self:doCloseTouch())
  self:show(self:titleAnimHandler())
  FireEvent("refreshDiscount")
  return self
end

class.create = create

local function titleAnimHandler(self)
  local function handler()
    local ui = self.ui
    
    local title = ui.title
    title:setVisible(true)
    title:setScale(1.5)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackOut:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        ui.light:setVisible(true)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    title:runAction(s)
  end
  
  return handler
end

class.titleAnimHandler = titleAnimHandler
