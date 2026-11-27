module("ed.herorecommend", package.seeall)
hotlist = {}
hotlist.__index = hotlist
local base = ed.ui.popwindow
setmetatable(hotlist, base.mt)

function hotlist.create(data)
  local object = base.create("hotlist")
  setmetatable(object, hotlist)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function hotlist:initData(data)
  self.modeTable = ed.getDataTable("RecommendMode")
  self.modeid = data.modeid
  self.heroes = data.heroes
  self.headList = {}
end

function hotlist:initAppearence()
  self.window = ed.createui("herorecommend_hotlist", {
    mainLayer = self.mainLayer,
    touch_node = self
  })
  self:createTitle()
  self:createDraglist()
  self:createHeroHeadList()
end

function hotlist:createTitle()
  local data = self.modeTable[self.modeid]
  if data then
    local title = data["Mode Display Des"] .. T("\231\131\173\233\151\168\232\139\177\233\155\132")
    ed.setString(self.window.ui.lab_title, title)
  end
end

function hotlist:createHeroHeadList()
  for index, hero in ipairs(self.heroes) do
    local head = manager:createRankHead(hero.heroid, hero.rank)
    self.headList[index] = head
    self.draglist.listLayer:addChild(head.node)
    local posx = 65 + (index - 1) % 7 * 75
    local posy = 240 - math.floor((index - 1) / 7) * 80
    head.node:setPosition(ccp(posx, posy))
  end
  self.draglist:initListHeight(math.ceil(#self.heroes / 7) * 80 + 5)
end

function hotlist:registerTouchHandler()
  self.window:registerBtn("btn_close", function()
    self:destroy()
  end)
end

function hotlist:createDraglist()
  local info = {
    cliprect = CCRectMake(30, 10, 525, 275),
    container = self.window.ui.img_bg,
    zorder = 10,
    priority = -110,
    bar = {
      bglen = 260,
      bgpos = ccp(25, 155)
    },
    doClickIn = self:doClickIn(),
    doPressIn = self:doPressIn()
  }
  self.draglist = ed.draglist.create(info)
end

function hotlist:doClickIn()
  local function handler(x, y, index)
    local head = self.headList[index]
    
    if ed.containsPoint(head.headicon, x, y) then
      local hero = self.heroes[index]
      self:openHotHero(hero.heroid)
    end
  end
  
  return handler
end

function hotlist:doPressIn()
  local function handler(x, y)
    for index, head in ipairs(self.headList) do
      if ed.containsPoint(head.headicon, x, y) then
        return index
      end
    end
  end
  
  return handler
end

function hotlist:openHotHero(heroid)
  network:sendViewHotHero(heroid)
end
