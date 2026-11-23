HeroWaitWidget = {}
HeroWaitWidget.__index = HeroWaitWidget

function HeroWaitWidget.Create(config)
  local obj = {}
  setmetatable(obj, HeroWaitWidget)
  obj:Init(config)
  return obj
end

function HeroWaitWidget:Reset(listData)
  self.current_wait_index = 1
  self.list_data = listData
end

function HeroWaitWidget:Init(config)
  self:InitData(config)
  self:InitUI()
  self:CreateNextWait()
end

function HeroWaitWidget:InitData(config)
  self.list_data = config.listData
  self.current_wait_icon = nil
  self.current_wait_index = 0
  self.what = config.what
end

local function createHeroIcon(hero)
  local param = {
    length = 55,
    id = hero._tid,
    rank = hero._rank,
    stars = hero._stars,
    level = hero._level,
    fashion_id = hero._fashion,
    forbidden = false
  }
  local portrait = ed.readhero.createIcon(param)
  return portrait.icon
end

local function createMagicIcon(item)
  local magic_id = item
  local param = {
    id = magic_id,
    length = 60,
    forbidden = false
  }
  return ed.createMagicIcon(param).icon
end

function HeroWaitWidget:InitUI()
  local ui_res = HeroWaitWidget.Res
  local container, ui = ed.editorui(ui_res)
  self.container, self.ui = container, ui
end

function HeroWaitWidget:CreateNextWait()
  local index = self.current_wait_index + 1
  if index > #self.list_data then
    self.current_wait_index = index
    print("wait index is largest list num !!! ")
    return
  end
  local item = self.list_data[index]
  local icon
  if self.what == "magic_wait_system" then
    icon = createMagicIcon(item)
  else
    icon = createHeroIcon(item)
  end
  local x, y = 38, 63
  icon:setPosition(ccp(x, y))
  local parent = self.ui.img_ready_battle_hero_bg
  parent:addChild(icon)
  self.current_wait_icon = icon
  self.current_wait_index = index
end

function HeroWaitWidget:IsEnd()
  return self.current_wait_index > #self.list_data
end

function HeroWaitWidget:ClearCurrentWait()
  if self.current_wait_icon then
    self.current_wait_icon:removeFromParentAndCleanup(true)
    self.current_wait_icon = nil
  end
end

function HeroWaitWidget:NextReady()
  self:ClearCurrentWait()
  self:CreateNextWait()
end

function HeroWaitWidget:SetVisible(visible)
  if self.current_wait_icon then
    self.current_wait_icon:setVisible(visible)
  end
end

function HeroWaitWidget:SetRootVisible(visible)
  self.container:setVisible(visible)
end

function HeroWaitWidget:setPosition(pos)
  self.container:setPosition(pos)
  self.pos = pos
end

function HeroWaitWidget:GetCurrentWaitHero()
  local index = self.current_wait_index
  if index > #self.list_data or index <= 0 then
    print("index is error ::  " .. index)
    return nil
  end
  return self.list_data[index]
end

HeroWaitWidget.Res = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.03125, h = 21.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/multiarena/multiarena_hero_next_1.png",
      name = "img_wait_battle",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 110.16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 20, 130, 118),
      res = "UI/alpha/HVGA/multiarena/multiarena_panel_bg.png",
      name = "img_ready_battle_hero_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.13, 52)
    }
  }
}
