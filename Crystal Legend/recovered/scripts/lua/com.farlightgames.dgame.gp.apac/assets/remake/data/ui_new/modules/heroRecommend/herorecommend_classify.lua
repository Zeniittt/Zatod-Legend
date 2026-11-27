module("ed.herorecommend", package.seeall)
classify = {}
classify.__index = classify

function classify.create(data)
  local object = {}
  setmetatable(object, classify)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function classify:initData(data)
  self.data = data
  self.window = data.window
  self.mgr = data.mgr
  self.classifyInfoList = self.mgr.classifyInfoList
  self.playingList = {}
  self.ownFlag = false
  self.notOwnFlag = false
end

function classify:initAppearence()
  local container, ui = ed.editorui(ed.uieditor.herorecommend_classify)
  self.window.mainLayer:addChild(container)
  self.mainLayer = container
  self.ui = ui
  self:createDraglist()
  self:createPlayingList()
  self:initFilterFlag()
end

function classify:createPlayingList()
  for i, info in ipairs(self.classifyInfoList) do
    local playing = playing.create(info)
    playing.mainLayer:setPosition(ccp(255, 330 - i * 95))
    self.draglist.listLayer:addChild(playing.mainLayer)
    self.playingList[i] = playing
  end
  self.draglist:initListHeight(#self.classifyInfoList * 95 + 10)
end

function classify:initFilterFlag()
  if self.ownFlag then
    self.ui.img_own_flag:setVisible(true)
  else
    self.ui.img_own_flag:setVisible(false)
  end
  if self.notOwnFlag then
    self.ui.img_notown_flag:setVisible(true)
  else
    self.ui.img_notown_flag:setVisible(false)
  end
end

function classify:registerTouchHandler()
  local ui = self.ui
  self.window.touch_node:btRegisterButtonClick({
    button = ui.img_own_bg,
    press = ui.img_own_bg_press,
    key = "img_own_bg_click",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:filtrHaveHero()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  self.window.touch_node:btRegisterButtonClick({
    button = ui.img_notown,
    press = ui.img_notown_press,
    key = "img_notown_click",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:filtrDonthaveHero()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
end

function classify:filtrHaveHero()
  if self.ownFlag then
    self.ownFlag = false
  else
    self.ownFlag = true
  end
  self.notOwnFlag = false
  self:initFilterFlag()
  self:refreshPlayingList()
end

function classify:filtrDonthaveHero()
  if self.notOwnFlag then
    self.notOwnFlag = false
  else
    self.notOwnFlag = true
  end
  self.ownFlag = false
  self:initFilterFlag()
  self:refreshPlayingList()
end

function classify:refreshPlayingList()
  local infoList = self.mgr.classifyInfoList
  for i, info in ipairs(infoList) do
    local heroes = self:getFiltrHeroids(info.heroes)
    local playing = self.playingList[i]
    local mode = self.ownFlag and "haveHero" or "notHaveHero"
    playing:refresh(heroes, mode)
  end
end

function classify:getFiltrHeroids(heroes)
  if self.ownFlag then
    return self.mgr:filtrHaveHero(heroes)
  elseif self.notOwnFlag then
    return self.mgr:filtrDonthaveHero(heroes)
  else
    return heroes
  end
end

function classify:createDraglist()
  local info = {
    cliprect = CCRectMake(10, 0, 490, 290),
    container = self.ui.panel_recommend_bg,
    zorder = 10,
    bar = {
      bglen = 270,
      bgpos = ccp(1, 150)
    },
    doClickIn = self:getClickInHandler(),
    doPressIn = self:getPressInHandler()
  }
  self.draglist = ed.draglist.create(info)
end

function classify:getClickInHandler()
  local function handler(x, y, index, param)
    local playing = self.playingList[index]
    
    if param.key == "playing" then
      if ed.containsPoint(playing.ui.btn_more, x, y) then
        self:openHotList(index)
      end
      playing.ui.btn_more_press:setVisible(false)
    elseif param.key == "head" then
      local head = playing.headList[param.headIndex]
      if ed.containsPoint(head.headicon, x, y) then
        local hero = playing.heroes[param.headIndex]
        self:openHotHero(hero.heroid)
      end
    end
  end
  
  return handler
end

function classify:getPressInHandler()
  local function handler(x, y)
    for index, playing in ipairs(self.playingList) do
      if ed.containsPoint(playing.ui.btn_more, x, y) then
        playing.ui.btn_more_press:setVisible(true)
        
        local param = {key = "playing"}
        return index, param
      end
      for i, head in ipairs(playing.headList) do
        if ed.containsPoint(head.headicon, x, y) then
          local param = {key = "head", headIndex = i}
          return index, param
        end
      end
    end
  end
  
  return handler
end

function classify:openHotList(index)
  local info = self.mgr.classifyInfoList[index]
  local heroes = self:getFiltrHeroids(info.heroes)
  if #heroes == 0 then
    local toast = self.ownFlag and T("\230\142\168\232\141\144\232\139\177\233\155\132\230\154\130\230\156\170\232\142\183\229\190\151") or T("\230\142\168\232\141\144\232\139\177\233\155\132\229\183\178\229\133\168\233\131\168\232\142\183\229\190\151")
    ed.showToast(toast)
    return
  end
  local hotlist = hotlist.create({
    heroes = heroes,
    modeid = info.modeid
  })
  hotlist:popWindow(manager.baseZorde)
end

function classify:openHotHero(heroid)
  network:sendViewHotHero(heroid)
end
