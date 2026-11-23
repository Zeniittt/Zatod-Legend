local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.playerLevelup = class
local resFactor = ed.display.resFactor

local function getUnlockDesc(self)
  local info = self.info
  local desc = {}
  table.insert(desc, {
    title = T("\230\136\152\233\152\159\231\173\137\231\186\167\239\188\154"),
    desc = {
      now = self.level,
      pre = self.preLevel
    },
    type = "sl"
  })
  local pldt = ed.getDataTable("PlayerLevelDisplay")
  local index = 1
  while pldt[index] do
    local row = pldt[index]
    local key = row.Name
    local ds = row.Display
    local ds2 = row.Display2
    local vl = info[key]
    local tp = type(vl)
    if tp == "table" then
      table.insert(desc, {
        title = ds,
        desc = {
          pre = vl.pre,
          now = vl.now
        },
        type = "sl"
      })
    elseif tp == "number" then
      table.insert(desc, {
        title = ds,
        desc = string.format(ds2, vl),
        type = "sn"
      })
    elseif tp == "boolean" then
      table.insert(desc, {
        title = ds,
        desc = ds2,
        type = "s"
      })
    end
    index = index + 1
  end
  self.desc = desc
end

class.getUnlockDesc = getUnlockDesc

local function getInformation(self, pl)
  local info = {}
  local l = self.level
  local pl = self.preLevel
  local plt = ed.getDataTable("PlayerLevel")
  local row = plt[l]
  local preRow = plt[pl]
  local heroLevel = row["Max Hero Level"]
  local preHeroLevel = preRow["Max Hero Level"]
  if heroLevel > preHeroLevel then
    info["Max Hero Level"] = {now = heroLevel, pre = preHeroLevel}
  end
  local maxVit = row["Max Vitality"]
  local preMaxVit = preRow["Max Vitality"]
  if maxVit > preMaxVit then
    info["Max Vitality"] = {now = maxVit, pre = preMaxVit}
  end
  info["Exp Reward"] = 0
  local vit = ed.player:getVitality()
  local pvit = vit
  for i = pl, l - 1 do
    pvit = pvit - plt[i]["Vitality Reward"]
  end
  info["Vitality Reward"] = {now = vit, pre = pvit}
  local unlock = row.Unlock
  for k, v in pairs(unlock or {}) do
    if type(v) == "string" then
      if v == "Chapter" then
        info[v] = row.Chapter[1]
      else
        info[v] = true
      end
    end
  end
  self.info = info
end

class.getInformation = getInformation

local function create(param)
  local nowLevel = param.level or ed.player:getLevel()
  if param.preLevel and nowLevel <= param.preLevel then
    return
  end
  local self = base.create("playerLevelup")
  setmetatable(self, class.mt)
  self.level = nowLevel
  self.preLevel = param.preLevel or ed.player:getLevel() - 1
  local container = self.container
  self:getInformation()
  self:getUnlockDesc()
  local ui = {}
  self.ui = ui
  local width = 420
  local listContainer = CCSprite:create()
  local readnode = ed.readnode.create(listContainer, ui)
  local height = 0
  local desc = self.desc
  for i = 1, #desc do
    local ds = desc[i]
    if i % 2 == 1 then
      local ui_info = {
        {
          t = "Sprite",
          base = {
            name = "board_" .. i,
            res = "UI/alpha/HVGA/announce_text_bg_blue.png"
          },
          layout = {
            position = ccp(width / 2, height - 20)
          },
          config = {
            fix_size = CCSizeMake(420, 40)
          }
        }
      }
      readnode:addNode(ui_info)
    end
    local tp = ds.type
    if tp == "sl" then
      local ui_info = {
        {
          t = "Label",
          base = {
            name = "title_" .. i,
            text = ds.title,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(width / 2 - 120, height - 20)
          },
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "pre_" .. i,
            text = ds.desc.pre,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        },
        {
          t = "Sprite",
          base = {
            name = "arrow" .. i,
            res = "UI/alpha/HVGA/player_levelup_arrow.png"
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {}
        },
        {
          t = "Label",
          base = {
            name = "now_" .. i,
            text = ds.desc.now,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
      readnode:addNode(ui_info)
      ui["pre_" .. i]:setPosition(ed.getRightSidePos(ui["title_" .. i], 10))
      ui["arrow" .. i]:setPosition(ed.getRightSidePos(ui["pre_" .. i], 10))
      ui["now_" .. i]:setPosition(ed.getRightSidePos(ui["arrow" .. i], 10))
    else
      local ui_info = {
        {
          t = "Label",
          base = {
            name = "title_" .. i,
            text = ds.title,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(width / 2 - 120, height - 20)
          },
          config = {
            color = ccc3(241, 193, 113)
          }
        },
        {
          t = "Label",
          base = {
            name = "desc_" .. i,
            text = ds.desc,
            size = 18
          },
          layout = {
            anchor = ccp(0, 0.5),
            position = ccp(0, 0)
          },
          config = {
            color = ccc3(255, 234, 198)
          }
        }
      }
      readnode:addNode(ui_info)
      ui["desc_" .. i]:setPosition(ed.getRightSidePos(ui["title_" .. i]))
    end
    height = height - 40
  end
  local height = -height + 20
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/main_vit_tips.png", CCRectMake(10 / resFactor, 10 / resFactor, 58 / resFactor, 26 / resFactor))
  container:addChild(bg)
  self.ui.bg = bg
  bg:setPosition(ccp(ed.display.center.x, 240))
  self:setClickDestroyEnabled(false)
  readnode = ed.readnode.create(bg, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/1080P/common/herodetail-detail-close.png"
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
        res = "UI/alpha/1080P/common/herodetail-detail-close-p.png",
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
  listContainer:setAnchorPoint(ccp(0, 0))
  listContainer:setPosition(ccp(0, height))
  bg:addChild(listContainer, 5)
  height = height + 50
  bg:setContentSize(CCSizeMake(width, height))
  ui.close:setPosition(ccp(width, height - 25))
  local light = ed.createSprite("UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(ccp(width / 2, height))
  ui.light = light
  bg:addChild(light)
  light:setVisible(false)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
  local title = ed.createSprite("UI/alpha/HVGA/player_levelup_title.png")
  title:setPosition(ccp(width / 2, height))
  ui.title = title
  bg:addChild(title)
  title:setVisible(false)
  self:registerTouchHandler(self:doCloseTouch())
  self:show(self:titleAnimHandler())
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
