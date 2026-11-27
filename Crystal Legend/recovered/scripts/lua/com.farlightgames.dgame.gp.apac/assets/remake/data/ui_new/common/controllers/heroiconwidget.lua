HeroIconWidget = {}
HeroIconWidget.__index = HeroIconWidget

function HeroIconWidget.Create(config)
  local obj = {}
  setmetatable(obj, HeroIconWidget)
  obj:Init(config)
  return obj
end

function HeroIconWidget:Init(config)
  self:InitData(config)
  self:InitUI()
end

function HeroIconWidget:InitData(config)
  self.list_data = config.listData
  local colunNum = config.colunNum
  self.what = config.what
  self.pressInIconHandler = config.pressInIconHandler
  self.clickInIconHandler = config.clickInIconHandler
  self.updateHandler = config.updateHandler
  self.icon_gap_x = -100
  self.icon_ori_x = 690 + (5 - colunNum) * self.icon_gap_x
  self.icon_ori_y = 75
  self.icon_gap_y = 100
  self.colunNum = colunNum
  self.rect = CCRectMake(180, 18, 130 * colunNum, 120)
  self.reverse = config.reverse
  self.pos = ccp(0, 0)
end

function HeroIconWidget:InitUI()
  local ui_res = HeroIconWidget.Res
  local container, ui = ed.editorui(ui_res)
  self.container, self.ui = container, ui
  self.ui.package_bg:setContentSize(CCSizeMake(120 * self.colunNum, 101.56))
  self:InitDragList()
end

local function createHeroIcon(hero)
  local param = {
    id = hero._tid,
    rank = hero._rank,
    stars = hero._stars,
    level = hero._level,
    forbidden = true,
    summary = hero
  }
  local portrait = ed.readhero.createIcon(param)
  return portrait
end

local function createMagicIcon(item)
  local magic_id = item
  local param = {
    id = magic_id,
    length = 80,
    forbidden = true
  }
  return ed.createMagicIcon(param)
end

function HeroIconWidget:InitDragList()
  local function doPressIn(listdata)
    local function handler(x, y)
      return self:pressInIconList(listdata, x, y)
    end
    
    return handler
  end
  
  local function doClickInList(listdata)
    local function handler(x, y, k)
      self:clickInIconList(listdata, x, y, k)
    end
    
    return handler
  end
  
  local param = {
    listData = self.list_data,
    createIconHandler = function(data)
      return HeroIconWidget.CreatIcon(self, data)
    end,
    container = self.container,
    cliprect = self.rect,
    doPressIn = doPressIn,
    doClickInList = doClickInList,
    icon_ori_x = self.icon_ori_x,
    icon_gap_x = self.icon_gap_x,
    icon_ori_y = self.icon_ori_y,
    icon_gap_y = self.icon_ori_y,
    colunNum = self.colunNum,
    touchpriority = -130
  }
  ed.fastCreateDragList(self, param)
end

function HeroIconWidget:ContansPoint(x, y)
  local rect = CCRectMake(0, 0, 0, 0)
  local rt = self.rect
  rect.origin.x = rt.origin.x + self.pos.x
  rect.origin.y = rt.origin.y + self.pos.y
  rect.size = rt.size
  return rect:containsPoint(ccp(x, y))
end

function HeroIconWidget:RemoveItemWithId(id, equal)
  local list = self.itemIconList
  for k, item in pairs(list) do
    local data = item.data
    if equal(data, id) then
      return self:RemoveItem(k)
    end
  end
  return false
end

function HeroIconWidget:RemoveItem(index)
  local iconList = self.itemIconList
  if index < 1 or index > #iconList then
    print("index is not right !!! ")
    return false
  end
  local item = iconList[index]
  item.icon:removeFromParentAndCleanup(true)
  table.remove(iconList, index)
  self:SortIconList()
  return true
end

function HeroIconWidget:CreatIcon(data)
  local icon, portrait
  if self.what == "magic_system" then
    portrait = createMagicIcon(data)
    icon = portrait.icon
  else
    portrait = createHeroIcon(data)
    icon = portrait.icon
  end
  return icon, portrait
end

function HeroIconWidget:SortIconList()
  local iconList = self.itemIconList
  local draglist = self.dragList
  for k, item in ipairs(iconList) do
    local or_x = self.icon_ori_x
    local gap_x = self.icon_gap_x
    local cun = self.colunNum
    if self.reverse then
      gap_x = -gap_x
      or_x = or_x - (cun - 1) * gap_x
    end
    local icon = item.icon
    local x = or_x + gap_x * ((k - 1) % cun)
    local y = self.icon_ori_y - self.icon_gap_y * math.floor((k - 1) / cun)
    icon:setPosition(ccp(x, y))
  end
  draglist:initListHeight(math.ceil(#iconList / self.colunNum) * self.icon_gap_y)
end

function HeroIconWidget:AddItem(data)
  local iconList = self.itemIconList
  local draglist = self.dragList
  local icon, portrait = HeroIconWidget.CreatIcon(self, data)
  draglist:addItem(icon)
  local temp = {
    icon = icon,
    data = data,
    portrait = portrait
  }
  table.insert(iconList, temp)
  self:SortIconList()
end

function HeroIconWidget:GetIconList()
  return self.itemIconList
end

function HeroIconWidget:pressInIconList(listData, x, y)
  for k, item in pairs(listData) do
    if ed.containsPoint(item.icon, x, y) then
      if self.pressInIconHandler then
        if self.pressInIconHandler(item, x, y, k, self) then
          return k
        end
      else
        return k
      end
    end
  end
end

function HeroIconWidget:clickInIconList(listdata, x, y, k)
  local item = listdata[k]
  if self.clickInIconHandler then
    self.clickInIconHandler(item, x, y, self)
  end
end

function HeroIconWidget:setPosition(pos)
  self.container:setPosition(pos)
  self.pos = pos
end

function HeroIconWidget:Update(dt)
  if self.updateHandler then
    self:updateHandler(dt)
  end
end

HeroIconWidget.Res = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(529.69, 101.56)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 30, 121, 98),
      res = "UI/alpha/HVGA/multiarena/multiarena_panel_bg.png",
      name = "package_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(230, 20)
    }
  }
}
