local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.HeroFashion = class
local timerTbl = {}
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
          for i = 1, #timerTbl do
            CloseTimer(timerTbl[i].Name)
          end
          self:destroy()
        end
        if ed.containsPoint(socialShare, x, y) and socialShare_press:isVisible() then
          self:setShareCapture(self)
          socialShare_press:setVisible(false)
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.dookTouch = dookTouch

local function setShareCapture(self)
  local param = {
    Res = "UI/alpha/1080P/common/fashion.png",
    ui = self.ui,
    container = self.container,
    actor = self.actor
  }
  self:ShareToSocialWithQRAndHeadAsync(param)
end

class.setShareCapture = setShareCapture

local function create(param)
  local self = base.create()
  setmetatable(self, class.mt)
  local container = self.container
  local hid = param.id
  local handler = param.handler
  local fashion_id = param.fashion_id
  self:setClickDestroyEnabled(false)
  self:setDestroyHandler(handler)
  local titleres = "UI/alpha/1080P/skin/skin_slogan_bg.png"
  local fashionName = ed.getDataTable("Fashion")[fashion_id].Name
  local ui = {}
  self.ui = ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg_title",
        res = titleres,
        z = 1
      },
      layout = {
        position = ccp(ed.display.center.x, ed.display.winSize.height - 100)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        z = 2,
        name = "title",
        res = "UI/alpha/1080P/skin/skin_get_slogan.png"
      },
      layout = {
        position = ccp(ed.display.center.x, ed.display.winSize.height - 100)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/1080P/skin/skin_get_light.png"
      },
      layout = {
        position = ccp(ed.display.center.x, ed.display.winSize.height / 2)
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
        position = ccp(ed.display.center.x, 125)
      },
      config = {scale = 1.3}
    },
    {
      t = "Label",
      base = {
        name = "label_fashion_name",
        text = fashionName,
        size = 32
      },
      layout = {
        position = ccp(ed.display.center.x, 130)
      },
      config = {
        color = ccc3(218, 90, 36)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "socialShare",
        res = "UI/alpha/1080P/common/button_com_mini.png",
        capInsets = CCRectMake(10 / resFactor, 10 / resFactor, 28 / resFactor, 29 / resFactor)
      },
      layout = {
        position = ccp(ed.display.center.x, 60)
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
        res = "UI/alpha/1080P/common/button_com_mini.png",
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
        position = ccp(ed.display.center.x, 60)
      },
      config = {
        scaleSize = CCSizeMake(100, 50)
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
        scaleSize = CCSizeMake(100, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T("\231\161\174\229\174\154"),
        size = 20,
        parent = "ok"
      },
      layout = {
        position = ccp(50, 25)
      },
      config = {}
    }
  }
  self.ui_info = ui_info
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  container:setPosition(0, 0)
  local rotate = CCRotateBy:create(5, 370)
  ui.light:runAction(CCRepeatForever:create(rotate))
  ed.setLabelStroke(ui.label_fashion_name, ed.toccc3(16775110), 1)
  ui.label_fashion_name:setFontName(ed.fontBold)
  local puppet_id = ed.lookupDataTable("Fashion", "Puppet", fashion_id)
  local info = ed.lookupDataTable("Puppet", nil, puppet_id)
  local comps = info["Change Components"]
  local actor2, cha2
  local actor, cha = ed.readhero.getActor(hid, "Move", true, false)
  actor:setPosition(ccp(ed.display.center.x, ed.display.winSize.height / 2 - 50))
  ed.getCurrentScene():addFca(actor)
  container:addChild(actor, 5)
  local actor2, cha2 = ed.readhero.getActor(hid, "Move", true, false, fashion_id)
  actor2:setPosition(ccp(ed.display.center.x, ed.display.winSize.height / 2 - 50))
  ed.getCurrentScene():addFca(actor2)
  container:addChild(actor2, 5)
  actor2:setVisible(false)
  local sound = ed.lookupDataTable("Fashion", "Voice Ready", fashion_id)
  ed.playEffect(sound)
  self.ui.ok:setVisible(false)
  self.mainLayer:setTouchEnabled(false)
  if EDShareToFriendsPoolQR then
    self.ui.socialShare:setVisible(false)
    self.ui.ok:setPosition(ccp(300, 60))
    self.ui.socialShare:setPosition(ccp(500, 60))
  end
  timerTbl[1] = ListenTimer(Timer:Once(1), function()
    actor:setAction("Idle")
    actor:setLoop(false)
    local rootPos = ccp(ed.display.center.x, ed.display.center.y - 60)
    ListenTimer(Timer:Once(1.3), function()
      local sprBehind = ed.createFcaNode("eff_UI_hero_awake")
      sprBehind:setPosition(rootPos)
      ed.getCurrentScene():addFca(sprBehind)
      self.container:addChild(sprBehind)
    end)
    local sprFront = ed.createFcaNode("eff_UI_hero_awake2")
    sprFront:setPosition(rootPos)
    ed.getCurrentScene():addFcaOnce(sprFront)
    self.container:addChild(sprFront, 115)
    timerTbl[2] = ListenTimer(Timer:Once(0.5), function()
      actor2:setVisible(true)
      actor2:setAction("Cheer")
      actor:setVisible(false)
    end)
    timerTbl[3] = ListenTimer(Timer:Once(self.getDuration(actor, cha, "Idle")), function()
      local changeFcaName = "Rage"
      if comps and 0 < #comps then
        changeFcaName = "Cheer"
        actor:setAction(changeFcaName)
        actor:setLoop(true)
      else
        changeFcaName = "Idle"
      end
      timerTbl[4] = ListenTimer(Timer:Once(self.getDuration(actor, cha, changeFcaName)), function()
        self.actor = actor
        self.ui.ok:setVisible(true)
        self.mainLayer:setTouchEnabled(true)
        if EDShareToFriendsPoolQR then
          self.ui.socialShare:setVisible(true)
          self.ui.socialShare:setPosition(ccp(500, 60))
          self.ui.ok:setPosition(ccp(300, 60))
        end
      end)
    end)
  end)
  self:registerTouchHandler(self:dookTouch())
  self:show()
  return self
end

class.create = create

local function getDuration(actor, cha, name)
  local row = ed.getDataTable("AnimDuration")[cha]
  local dur = 1
  for k, v in pairs(row or {}) do
    if name and k == name then
      return v.Duration
    end
  end
  for k, v in pairs(row or {}) do
    if k == "Cheer" then
      return v.Duration
    end
  end
  return dur
end

class.getDuration = getDuration
