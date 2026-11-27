local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
ed.ui.announce.heroEvolve = class
setmetatable(class, base.mt)
local resFactor = ed.display.resFactor

local function createGrowth(self)
  local container = self.heContainer
  local ui = self.ui
  local growth = self.growth
  local preGrowth = self.preGrowth
  local withshareBtn = self.withshare
  local startPosY = 120
  if withshareBtn then
    startPosY = 160
  end
  local keys = {
    {
      key = "STR",
      name = T("\229\138\155\233\135\143")
    },
    {
      key = "INT",
      name = T("\230\153\186\229\138\155")
    },
    {
      key = "AGI",
      name = T("\230\149\143\230\141\183")
    }
  }
  local readnode = ed.readnode.create(container, ui)
  for i = 1, 3 do
    local key = keys[i].key
    local name = keys[i].name
    if i % 2 == 1 then
      local ui_info = {
        {
          t = "Sprite",
          base = {
            name = key .. "_board",
            res = "UI/alpha/HVGA/announce_text_bg_purple.png"
          },
          layout = {
            position = ccp(200, startPosY - 40 * (i - 1))
          },
          config = {
            fix_size = CCSizeMake(400, 40)
          }
        }
      }
      readnode:addNode(ui_info)
    end
    local ofx = 10
    local ui_info = {
      {
        t = "Label",
        base = {
          name = key .. "_title",
          text = name .. T("\230\136\144\233\149\191:"),
          size = 20
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(130 + ofx, startPosY - 40 * (i - 1))
        },
        config = {
          color = ccc3(241, 193, 113)
        }
      },
      {
        t = "Label",
        base = {
          name = "pre_" .. key,
          text = preGrowth[key],
          size = 18
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(165 + ofx, startPosY - 40 * (i - 1))
        },
        config = {
          color = ccc3(255, 234, 198)
        }
      },
      {
        t = "Sprite",
        base = {
          name = key .. "_arrow",
          res = "UI/alpha/HVGA/player_levelup_arrow.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(210 + ofx, startPosY - 40 * (i - 1))
        }
      },
      {
        t = "Label",
        base = {
          name = key,
          text = growth[key],
          size = 18
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(255 + ofx, startPosY - 40 * (i - 1))
        },
        config = {
          color = ccc3(255, 234, 198)
        }
      },
      {
        t = "Label",
        base = {
          name = key .. "_add",
          text = string.format("(" .. name .. "+%.01f)", self.att[key].all - self.preAtt[key].all),
          size = 16
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(285 + ofx, startPosY - 40 * (i - 1))
        },
        config = {
          color = ccc3(0, 255, 0)
        }
      }
    }
    readnode:addNode(ui_info)
  end
  if withshareBtn then
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "share",
          res = "UI/alpha/1080P/common/tavern_button_normal_1.png"
        },
        layout = {
          position = ccp(320, 20)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "share_press",
          res = "UI/alpha/1080P/common/tavern_button_normal_2.png",
          parent = "share"
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
          name = "socialShare_label",
          text = T("\229\136\134\228\186\171\229\136\176\229\190\174\228\191\161"),
          size = 20,
          parent = "share"
        },
        layout = {
          position = ccp(70, 25)
        },
        config = {
          color = ccc3(251, 206, 16)
        }
      }
    }
    readnode:addNode(ui_info)
  end
end

class.createGrowth = createGrowth

local function doShareTouch(self)
  local isPress
  local button = self.ui.share
  local press = self.ui.share_press
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) and EDShareToFriendsPool then
          local title = string.format(T("\230\136\145\229\156\168\227\128\138\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\227\128\139\233\135\140\229\176\134%s\229\141\135\229\136\176\228\186\148\230\152\159\228\186\134!Rua!"), ed.lookupDataTable("Unit", "Display Name", self.hid or 1))
          EDShareToFriendsPool(title, title, "")
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doShareTouch = doShareTouch

local function create(param)
  local self = base.create()
  setmetatable(self, class.mt)
  local hid = param.id
  self.hid = hid
  local preAtt = param.preAtt
  local growth = ed.readhero.getGrowth(hid)
  local preGrowth = ed.readhero.getGrowth(hid, -1)
  self.growth = growth
  self.preGrowth = preGrowth
  self.preAtt = preAtt
  self.att = ed.readhero.getHeroAtt(self.hid)
  if EDShareToFriendsPool then
    local hero = ed.player.heroes[self.hid]
    local star = hero._stars or 0
    self.withshare = star == 5
  else
    self.withshare = nil
  end
  self.isTitan = ed.Hero.isTitanById(self.hid)
  local bgheight = 290
  local headheightDelata = 0
  if self.withshare then
    bgheight = 340
    headheightDelata = 40
  end
  local container = self.container
  self:setClickDestroyEnabled(true)
  local ui = {}
  self.ui = ui
  local container = self.container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.evolveAnnounce)
  local preIcon = ed.readhero.createIconByID(hid, {addStar = -1, state = "idle"}).icon
  local icon = ed.readhero.createIconByID(hid, {state = "idle"}).icon
  local x, y = ui.icon1:getPosition()
  ui.icon1:setVisible(false)
  preIcon:setPosition(ccp(x, y))
  x, y = ui.icon2:getPosition()
  ui.icon2:setVisible(false)
  icon:setPosition(ccp(x, y))
  ui.bg_heroicon:addChild(preIcon)
  ui.bg_heroicon:addChild(icon)
  local x, y = ui.light:getPosition()
  local light1 = ed.createFcaNode("eff_UI_pvp_newrecord_light")
  light1:setPosition(ccp(x, y))
  ui.bg:addChild(light1)
  ed.getCurrentScene():addFca(light1)
  ed.useShader(light1, "HSVtoRGBShader")
  local shader = CCShaderCache:sharedShaderCache():programForKey("HSVtoRGBShader")
  local location = shader:getUniformLocationForName("HSV")
  shader:setUniformsForBuiltins()
  shader:setUniformLocationWith4f(location, 235, 0.02, 0, 1)
  local light2 = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  light2:setPosition(ccp(x, y))
  ui.bg:addChild(light2, 3)
  ed.getCurrentScene():addFca(light2)
  local stars = ed.player.heroes[hid]._stars
  local fixPosX = (5 - stars) * 15
  for i = 1, stars do
    ui["star" .. i]:setPositionX(ui["star" .. i]:getPositionX() + fixPosX)
  end
  for i = stars + 1, 5 do
    ui["star" .. i]:setVisible(false)
  end
  self:show()
  return self
end

class.create = create

local function titleAnimHandler(self)
  local function handler()
    local ui = self.ui
    
    local title = ui.title
    title:setVisible(true)
    title:setScale(2.2)
    title:runAction(CCEaseBackOut:create(CCScaleTo:create(0.2, 1.5)))
  end
  
  return handler
end

class.titleAnimHandler = titleAnimHandler
