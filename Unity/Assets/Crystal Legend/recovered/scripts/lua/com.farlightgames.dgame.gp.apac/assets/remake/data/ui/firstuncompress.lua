local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.firstuncompress = class

local function create()
  local self = base.create("firstuncompress")
  setmetatable(self, class.mt)
  local scene = self.scene
  local mainLayer = self.mainLayer
  local ui = self.ui
  local container = CCLayer:create()
  self.mainLayer:addChild(container)
  self.container = container
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "installer/splash.jpg"
      },
      layout = {
        position = ccp(400, 240)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "bar_bg",
        res = "installer/loading_bar_bg.png"
      },
      layout = {
        position = ccp(400, 60)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "bar",
        res = "installer/loading_bar.png",
        parent = "bar_bg"
      },
      layout = {
        anchor = ccp(0, 0)
      }
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  ui.bar:setTextureRect(CCRectMake(0, 0, 0, 25))
  local lightContainer = CCLayer:create()
  ui.lightContainer = lightContainer
  lightContainer:setClipRect(CCRectMake(15, -240, 400, 480))
  ui.bar_bg:addChild(lightContainer)
  ui.bar_light = ed.createNode({
    t = "Sprite",
    base = {
      res = "installer/loading_bar_light.png"
    },
    layout = {
      anchor = ccp(0.9, 0)
    }
  }, lightContainer)
  local descContainer = ed.createNode({t = "Sprite"}, self.container)
  ui.descContainer = descContainer
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "desc_bg",
        res = "installer/loading_label_bg.png"
      },
      layout = {
        position = ccp(400, 105)
      }
    },
    {
      t = "Label",
      base = {
        name = "desc_label",
        text = T("\229\136\157\230\172\161\232\191\155\229\133\165\230\184\184\230\136\143\239\188\140\230\173\163\229\156\168\232\167\163\229\142\139\232\181\132\230\186\144\229\140\133\226\128\166\226\128\166"),
        size = 20
      },
      layout = {
        position = ccp(410, 105)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "desc_flower",
        res = "installer/load_flower.png"
      }
    }
  }
  local readNode = ed.readnode.create(descContainer, ui)
  readNode:addNode(ui_info)
  ui.desc_flower:setPosition(ed.getLeftSidePos(ui.desc_label, 20))
  ui.desc_flower:runAction(CCRepeatForever:create(CCRotateBy:create(2, 360)))
  ed.fixNodeSize(ui.desc_bg, CCSizeMake(ui.desc_label:getContentSize().width + ui.desc_flower:getContentSize().width, 0))
  self:registerUpdateHandler("uncompress", self:doUncompress(1))
  ed.doneFirstUncompress()
  return self
end

class.create = create

local function refreshBar(self, percent)
  local ui = self.ui
  local width, height = 318, 25
  if 1 < percent then
    percent = 1
  end
  local width = width * percent
  ui.bar:setTextureRect(CCRectMake(0, 0, width, height))
  ui.bar_light:setPosition(ccp(math.min(width, 298.91999999999996), 0))
end

class.refreshBar = refreshBar

local function doUncompress(self, index)
  local pathList = {
    "/Android/obb/",
    string.format("/Android/obb/%s/", EDGetPackageName())
  }
  local isReset = index == #pathList
  local path = pathList[index]
  local sPath = EDGetExternalStoragePath()
  local vc = EDGetVersionCode()
  local packageName = EDGetPackageName()
  local fileName = string.format("main.%s.%s.obb", vc, packageName)
  local zipfilepath = sPath .. path .. fileName
  LoadResources:init()
  LoadResources:uncompress(zipfilepath, isReset)
  
  local function handler(dt)
    if LoadResources:isEnd() then
      if index < #pathList then
        self:registerUpdateHandler("uncompress", self:doUncompress(index + 1))
      end
      return
    end
    local progress = math.max((LoadResources:getProgress() - 0.8) * 5, 0)
    self:refreshBar(progress)
  end
  
  return handler
end

class.doUncompress = doUncompress
