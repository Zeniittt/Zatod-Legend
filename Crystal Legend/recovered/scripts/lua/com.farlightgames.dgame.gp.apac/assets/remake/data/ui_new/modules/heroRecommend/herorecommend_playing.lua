module("ed.herorecommend", package.seeall)
playing = {}
playing.__index = playing

function playing.create(data)
  local object = {}
  setmetatable(object, playing)
  object:initData(data)
  object:initAppearence()
  return object
end

function playing:initData(data)
  self.modeid = data.modeid
  self.tableData = ed.getDataTable("RecommendMode")[self.modeid]
  self.heroes = data.heroes
  self:initTop5Hero()
  self.headList = {}
  self.mode = "normal"
end

function playing:initTop5Hero()
  self.top5Hero = {}
  for index, hero in ipairs(self.heroes) do
    if index <= 5 then
      self.top5Hero[index] = hero
    end
  end
end

function playing:initAppearence()
  local container, ui = ed.editorui(ed.uieditor.herorecommend_playing)
  self.mainLayer = container
  self.ui = ui
  local iconres = self.tableData["Mode Icon"]
  local titleres = self.tableData["Mode Title"]
  local iconSprite = ed.createSprite(iconres)
  local titleSprite = ed.createSprite(titleres)
  if self.modeid == 1 then
    iconSprite:setScale(0.5)
  end
  ui.panel_word:addChild(titleSprite)
  ui.panel_icon:addChild(iconSprite)
  self:createHeroList()
  self:initTitle()
end

function playing:createHeroList()
  for index, hero in ipairs(self.top5Hero) do
    local head = manager:createRankHead(hero.heroid, hero.rank)
    self.ui.img_bg:addChild(head.node)
    head.node:setPosition(ccp(35 + index * 68, 48))
    self.headList[index] = head
  end
end

function playing:initTitle()
  if #self.top5Hero == 0 then
    self.ui.lab_title:setVisible(true)
    if self.mode == "haveHero" then
      ed.setString(self.ui.lab_title, T("\230\142\168\232\141\144\232\139\177\233\155\132\230\154\130\230\156\170\232\142\183\229\190\151"))
    elseif self.mode == "notHaveHero" then
      ed.setString(self.ui.lab_title, T("\230\142\168\232\141\144\232\139\177\233\155\132\229\183\178\229\133\168\233\131\168\232\142\183\229\190\151"))
    end
  else
    self.ui.lab_title:setVisible(false)
  end
end

function playing:refresh(heroes, mode)
  self.heroes = heroes
  self.mode = mode
  self:initTop5Hero()
  self:refreshAppearence()
end

function playing:refreshAppearence()
  for _, head in ipairs(self.headList) do
    head.node:removeFromParentAndCleanup(true)
  end
  self.headList = {}
  self:createHeroList()
  self:initTitle()
end
