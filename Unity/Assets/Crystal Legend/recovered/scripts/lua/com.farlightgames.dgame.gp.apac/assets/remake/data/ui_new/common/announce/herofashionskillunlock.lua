local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.announce.base
setmetatable(class, base.mt)
ed.ui.announce.hero_fashion_skill_unlock = class
local resFactor = ed.display.resFactor

local function getHero(self)
  return ed.player.heroes[self.hid]
end

class.getHero = getHero

local function getSkillInfo(self, skill_row_data)
  local skill_frame = {
    "UI/alpha/HVGA/equip_frame_white.png",
    "UI/alpha/HVGA/equip_frame_green.png",
    "UI/alpha/HVGA/equip_frame_blue.png",
    "UI/alpha/HVGA/equip_frame_purple.png",
    "UI/alpha/HVGA/equip_frame_orange.png",
    "UI/alpha/HVGA/equip_frame_red.png"
  }
  return {
    frame = skill_frame[6],
    name = skill_row_data["Skill Name"],
    iconres = skill_row_data["Skill Icon Name"],
    desc = skill_row_data["Skill Description"],
    richdesc = skill_row_data["Skill Richtext Description"]
  }
end

class.getSkillInfo = getSkillInfo

local function getInformation(self, hero)
  local rank = hero._rank
  local unit = ed.UnitCreate(hero)
  local gs = hero._gs
  local hp = math.floor(unit.attribs.HP)
  return rank, unit, gs, hp
end

class.getInformation = getInformation

local function create(param)
  local self = base.create("hero_fashion_skill_unlock")
  setmetatable(self, class.mt)
  local container = self.container
  local handler = param.handler
  self:setClickDestroyEnabled(false)
  self:setDestroyHandler(handler)
  local hid = param.id
  local fashion_id = param.fashion_id
  self.hid = hid
  self.fashion_id = fashion_id
  local proto_hero_before = param.preHero
  local hero = self:getHero()
  local rank, unit, gs, hp = self:getInformation(hero)
  local pre_icon = ed.readhero.createIcon({
    id = hid,
    rank = rank,
    forceNormal = true
  }).icon
  local icon = ed.readhero.createIcon({
    id = hid,
    rank = rank,
    fashion_id = fashion_id
  }).icon
  local skill_row_data = ed.getDataTable("Fashion")[self.fashion_id]
  local ui = {}
  self.ui = ui
  ui.pre_icon = pre_icon
  ui.icon = icon
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/main_vit_tips.png", CCRectMake(10 / resFactor, 10 / resFactor, 58 / resFactor, 26 / resFactor))
  container:addChild(bg)
  self.ui.bg = bg
  local huContainer = CCSprite:create()
  self.huContainer = huContainer
  huContainer:setAnchorPoint(ccp(0, 0))
  huContainer:setPosition(ccp(0, 0))
  bg:addChild(huContainer, 5)
  local readnode = ed.readnode.create(huContainer, self.ui)
  local ui_info
  local width = 450
  local height = 0
  if skill_row_data then
    local info = self:getSkillInfo(skill_row_data)
    local len = ed.stringutil.len(info.desc)
    if 42 < len then
      info.desc = ed.stringutil.sub(info.desc, 1, 39) .. "..."
    end
    local sw = 330
    local odx = (width - sw - 100) / 2
    local ui_info = {
      {
        t = "Sprite",
        base = {
          name = "skill_icon",
          res = info.iconres
        },
        layout = {
          position = ccp(odx + 65, 67)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "skill_frame",
          res = info.frame
        },
        layout = {
          position = ccp(odx + 65, 65)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "skill_name",
          text = T("\230\150\176\230\138\128\232\131\189:") .. info.name,
          size = 20
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(odx + 115, 95)
        },
        config = {
          color = ccc3(250, 205, 16)
        }
      },
      {
        t = "Label",
        base = {
          name = "skill_desc",
          text = info.desc,
          size = 18
        },
        layout = {
          anchor = ccp(0, 1),
          position = ccp(odx + 115, 75)
        },
        config = {
          dimension = CCSizeMake(sw, 0),
          horizontalAlignment = kCCTextAlignmentLeft,
          verticalAlignment = kCCVerticalTextAlignmentTop
        }
      }
    }
    readnode:addNode(ui_info)
    if info.richdesc ~= "" and info.richdesc then
      local label = richText:new()
      label:setString(info.richdesc)
      label:setPosition(ccp(odx + 115, 65))
      huContainer:addChild(label.rootNode)
    end
    height = height + 130
  end
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/pvp/pvp_tip_delimiter.png"
      },
      layout = {
        position = ccp(width / 2, height)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  height = height + 70
  local ui_info = {
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
  pre_icon:setPosition(ccp(width / 3, height))
  icon:setPosition(ccp(width / 3 * 2, height))
  local iconArrow = ed.createSprite("UI/alpha/HVGA/player_levelup_arrow.png")
  iconArrow:setPosition(ccp(width / 2, height))
  ui.icon_arrow = iconArrow
  huContainer:addChild(pre_icon)
  huContainer:addChild(iconArrow)
  huContainer:addChild(icon)
  height = height + 100
  local light = ed.createSprite("UI/alpha/HVGA/lettherebelight.png")
  light:setPosition(ccp(width / 2, height))
  ui.light = light
  bg:addChild(light)
  light:setVisible(false)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
  local title = ed.createSprite("UI/alpha/HVGA/skin/skin_unlock_title_big.png")
  title:setPosition(ccp(width / 2, height))
  ui.title = title
  bg:addChild(title)
  title:setVisible(false)
  bg:setContentSize(CCSizeMake(width, height))
  bg:setPosition(ccp(ed.display.center.x, 240))
  self.ui.close:setPosition(ccp(width - 10, height - 20))
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
