local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.getNewHero = class
local resFactor = ed.display.resFactor

local function dookTouch(self)
  local isPress
  local button = self.ui.ok
  local press = self.ui.ok_press
  local socialShare = self.ui.socialShare
  local socialShare_press = self.ui.socialShare_press
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
      if ed.containsPoint(socialShare, x, y) and socialShare:isVisible() then
        isPress = true
        socialShare_press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          self:destroy()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.dookTouch = dookTouch

local function create(param)
  local self = base.create()
  setmetatable(self, class.mt)
  local container = self.container
  local hid = param.id
  self.hid = hid
  fbHid = param.id
  local handler = param.handler
  self:setClickDestroyEnabled(false)
  self:setDestroyHandler(handler)
  local titleres = "UI/alpha/HVGA/get_new_hero_title.png"
  local ui = {}
  self.ui = ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "title",
        res = titleres,
        z = 1
      },
      layout = {
        position = ccp(ed.display.center.x, 370)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/HVGA/lettherebelight.png"
      },
      layout = {
        position = ccp(ed.display.center.x, 250)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = "UI/alpha/1080P/summon/get_new_hero_bar.png"
      },
      layout = {
        position = ccp(ed.display.center.x, 110)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "name",
        res = "UI/HERO-NAME/get_new_hero_name_" .. hid .. ".png"
      },
      layout = {
        position = ccp(ed.display.center.x, 110)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "socialShare",
        res = "UI/alpha/1080P/common/button_com_mini.png",
        capInsets = CCRectMake(10 / resFactor, 10 / resFactor, 28 / resFactor, 29 / resFactor)
      },
      layout = {
        position = ccp(ed.display.center.x, 40)
      },
      config = {
        scaleSize = CCSizeMake(140, 50),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "socialShare_press",
        res = "UI/alpha/HVGA/button_com_mini.png",
        capInsets = CCRectMake(10 / resFactor, 10 / resFactor, 28 / resFactor, 29 / resFactor),
        parent = "socialShare"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(140, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "socialShare_label",
        text = T("\229\136\134\228\186\171\229\136\176\229\190\174\228\191\161"),
        size = 20,
        parent = "socialShare"
      },
      layout = {
        position = ccp(70, 25)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/1080P/common/break_butt_bj.png",
        capInsets = CCRectMake(10 / resFactor, 10 / resFactor, 28 / resFactor, 29 / resFactor)
      },
      layout = {
        position = ccp(ed.display.center.x, 40)
      },
      config = {
        scaleSize = CCSizeMake(140, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/1080P/common/break_butt_bj.png",
        capInsets = CCRectMake(10 / resFactor, 10 / resFactor, 28 / resFactor, 29 / resFactor),
        parent = "ok"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(140, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T("\231\161\174  \229\174\154"),
        size = 20,
        parent = "ok"
      },
      layout = {
        position = ccp(70, 25)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  if EDShareToFriendsPoolQR then
    ui.socialShare:setPosition(ccp(500, 40))
    ui.socialShare:setVisible(true)
    ui.ok:setPosition(ccp(300, 40))
  end
  local rotate = CCRotateBy:create(5, 370)
  ui.light:runAction(CCRepeatForever:create(rotate))
  local actor = ed.readhero.getActor(hid, "Move")
  actor:setPosition(ccp(ed.display.center.x, 160))
  self.container = container
  local ret = ed.getDataTable("Unit")[hid]
  local puppet = ret and ret.Puppet
  local ret2 = puppet and ed.getDataTable("Puppet")[puppet]
  local scale = ret2 and ret2.Scale or 1
  actor:setScale(scale)
  ed.getCurrentScene():addFca(actor)
  container:addChild(actor, 5)
  self.actor = actor
  local sound = ed.getUnitVoiceMove(hid)
  ed.playEffect(sound)
  self:registerTouchHandler(self:dookTouch())
  self:show()
  return self
end

class.create = create
