local base = ed.ui.basescene
local stageMap = newclass(base.mt)
ed.ui.stageBigMap = stageMap
local res = ed.ui.stageselectres

function stageMap.create(param)
  local self = base.create("stageBigMap")
  setmetatable(self, stageMap.mt)
  param = param or {}
  self.param = param
  self.stageSelf = param.stageselectSelf
  local stageStarData = param.config
  self.StageStarData = {
    normal = stageStarData.normal,
    hard = stageStarData.elite
  }
  self.StageMax = {
    normal = param.normalmax,
    hard = param.elitemax
  }
  self:createMap()
  self:createTitBar()
  self:upDataMapNpc(self.stageSelf.mode == "elite" and "hard" or "normal", self.stageSelf:getChapter())
  self:setBackground()
  self:setBackButton()
  self:btRegisterHandler({
    handler = self:getMainTouchHandler(),
    key = "stage_map_main"
  })
  return self
end

function stageMap:createMap()
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local mainLayer = self.mainLayer
  local clipLayer = CCLayer:create()
  self.clipLayer = clipLayer
  mainLayer:addChild(clipLayer)
  clipLayer:setPosition(-newWid, -newHei)
  local mapBg = ed.createSprite("UI/alpha/1080P/bg/worldmap_normal.jpg")
  mapBg:setAnchorPoint(ccp(0, 0))
  local size = mapBg:getContentSize()
  local mapBg1 = ed.createSprite("UI/alpha/1080P/bg/worldmap_normal_1.jpg")
  mapBg1:setAnchorPoint(ccp(0, 0))
  self.maxTouchX = widhtWin - size.width - mapBg1:getContentSize().width
  mapBg:setPositionY((size.height - heightWin) / 2 * -1)
  clipLayer:addChild(mapBg)
  mapBg:addChild(mapBg1)
  mapBg1:setPosition(ccp(size.width, 0))
  local node = CCNode:create()
  mapBg:addChild(node, 111)
  self.bigMap = mapBg
  self.bigMapNode = node
  local mapBg = ed.createSprite("UI/alpha/1080P/bg/worldmap_hard.jpg")
  mapBg:setAnchorPoint(ccp(0, 0))
  local mapBg1 = ed.createSprite("UI/alpha/1080P/bg/worldmap_hard_1.jpg")
  mapBg1:setAnchorPoint(ccp(0, 0))
  mapBg:addChild(mapBg1)
  mapBg1:setPosition(ccp(mapBg:getContentSize().width, 0))
  self.bigMap:addChild(mapBg)
  self.bigNormalMap = mapBg
end

function stageMap:createTitBar()
  local heightWin = ed.display.winSize.height
  local ui = {}
  local readNode = ed.readnode.create(self.clipLayer, ui)
  readNode:addNode(res.bigMapTit_ui_info)
  ui.panel_title:setPosition(80, heightWin - 55)
  local title_bg, title = ed.UITool.createSceneTitle(T("\228\188\160\229\165\135\229\164\167\233\153\134"), ui.panel_title, {
    position = ccp(2, 18)
  })
  ed.adaptLabel(title, {maxWidth = 120, minScale = 0.5})
  title_bg:setContentSize(CCSizeMake(title:getContentSize().width * title:getScale() + 30, 53))
  ed.layout.centerInParent(title)
  if ed.playerlimit.checkAreaUnlock("Elite") then
    self.uiTit = ui
    self:btRegisterButtonClick({
      button = ui.img_normal_1,
      key = "img_normal",
      clickHandler = function()
        self:upDataMapNpc("normal")
      end,
      pressScale = 0.96,
      force = true,
      mcpMode = true
    })
    self:btRegisterButtonClick({
      button = ui.img_hard_1,
      key = "img_hard",
      clickHandler = function()
        self:upDataMapNpc("hard")
      end,
      pressScale = 0.96,
      force = true,
      mcpMode = true
    })
  else
    ui.img_normal_1:setVisible(false)
    ui.img_hard_1:setVisible(false)
  end
end

stageMap.mapNamePos = {
  {
    pos = ccp(63, 200.3),
    namePos = ccp(0, -20)
  },
  {
    pos = ccp(196.19, 351.13),
    namePos = ccp(-15, -15)
  },
  {
    pos = ccp(331, 221.57),
    z = 99,
    namePos = ccp(0, -15)
  },
  {
    pos = ccp(444.52, 375.98),
    namePos = ccp(0, -5)
  },
  {
    pos = ccp(538.59, 185.18),
    z = 99,
    namePos = ccp(0, -15)
  },
  {
    pos = ccp(723.24, 335.17),
    namePos = ccp(0, -10)
  },
  {
    pos = ccp(849.23, 205.62),
    z = 99,
    namePos = ccp(0, 0)
  },
  {
    pos = ccp(1005.45, 381.3),
    namePos = ccp(0, -15)
  },
  {
    pos = ccp(1119.89, 194.98),
    namePos = ccp(-25, -5)
  },
  {
    pos = ccp(1257.4, 250),
    z = 98,
    namePos = ccp(0, 0)
  },
  {
    pos = ccp(1353.3, 402.6),
    namePos = ccp(-10, 0)
  },
  {
    pos = ccp(1446.7, 158.6),
    z = 99,
    namePos = ccp(0, 0)
  },
  {
    pos = ccp(1578, 281),
    namePos = ccp(-20, 10)
  },
  {
    pos = ccp(1787, 141),
    namePos = ccp(-20, 10)
  },
  {
    pos = ccp(1925, 302),
    namePos = ccp(-10, 10)
  },
  {
    pos = ccp(1997, 358),
    namePos = ccp(-20, 40)
  }
}

function stageMap:upDataMapNpc(type, showChapter)
  self.newType = type or "normal"
  if self.uiTit then
    self.uiTit.img_normal_2:setVisible(self.newType == "normal")
    self.uiTit.img_hard_2:setVisible(self.newType == "hard")
  end
  self.bigNormalMap:setVisible(self.newType == "hard")
  
  local function newStarNum(chapter, newType)
    local info = res.map["chapter" .. chapter]
    local sn = 0
    for i = 1, #info.stage do
      local t = info.stage[i]
      if t.eid then
        local id = newType == "hard" and t.eid or t.id
        sn = sn + ed.player:getStageStar(id)
      end
    end
    return sn
  end
  
  if not self.starMaxTab then
    self.starMaxTab = {
      normal = {},
      hard = {}
    }
    for dex = 1, #self.mapNamePos do
      local starMax = 0
      for i, v in ipairs(self.StageStarData.normal) do
        starMax = dex == v.chapterId and starMax < v.StarNum and v.StarNum or starMax
      end
      local starNew = newStarNum(dex, "normal")
      self.starMaxTab.normal[dex] = {new = starNew, max = starMax}
      starMax = 0
      for i, v in ipairs(self.StageStarData.hard) do
        starMax = dex == v.chapterId and starMax < v.StarNum and v.StarNum or starMax
      end
      local starNew = newStarNum(dex, "hard")
      self.starMaxTab.hard[dex] = {new = starNew, max = starMax}
    end
  end
  local imgRes = self.newType == "hard" and "worldmap_map_hard_" or "worldmap_map_norlmal_"
  local imgPssRes = self.newType == "hard" and "worldmap_map_hard_choose_" or "worldmap_map_norlmal_choose_"
  self.mapNameUi = self.mapNameUi or {}
  local ui = {}
  local lastStar
  for i, v in ipairs(self.mapNamePos) do
    ui = {}
    if self.mapNameUi[i] then
      ui = self.mapNameUi[i]
      ed.initSpriteWithFrame(ui.panel_name.mapImg, "UI/alpha/1080P/campaign/worldmap/" .. imgRes .. i .. ".png")
      ed.initSpriteWithFrame(ui.panel_name.passImg, "UI/alpha/1080P/campaign/worldmap/" .. imgPssRes .. i .. ".png")
      local normalPar = 0 < self.starMaxTab.normal[i].max and self.starMaxTab.normal[i].new / self.starMaxTab.normal[i].max or 0
      local hardPar = 0 < self.starMaxTab.hard[i].max and self.starMaxTab.hard[i].new / self.starMaxTab.hard[i].max or 0
      normalPar = 1 < normalPar and 100 or math.floor(normalPar * 100)
      if 100 <= normalPar then
        ui.label_1:setColor(ccc3(ed.colorToStr("#70ff54")))
        ui.label_1:setStroke(ccc3(ed.colorToStr("#091f05")), 1)
      elseif i > self.StageMax.normal then
        ui.label_1:setString(T("\230\156\170\232\167\163\233\148\129"))
        ui.label_1:setColor(ccc3(ed.colorToStr("#dcdbdb")))
        ui.label_1:setStroke(ccc3(ed.colorToStr("#2b2622")), 1)
      end
      hardPar = 1 < hardPar and 100 or math.floor(hardPar * 100)
      if 100 <= hardPar then
        ui.label_2:setColor(ccc3(ed.colorToStr("#70ff54")))
        ui.label_2:setStroke(ccc3(ed.colorToStr("#091f05")), 1)
      elseif i > self.StageMax.hard then
        ui.label_2:setString(T("\230\156\170\232\167\163\233\148\129"))
        ui.label_2:setColor(ccc3(ed.colorToStr("#dcdbdb")))
        ui.label_2:setStroke(ccc3(ed.colorToStr("#2b2622")), 1)
      end
    else
      local mapImg = ed.createSprite("UI/alpha/1080P/campaign/worldmap/" .. imgRes .. i .. ".png")
      mapImg:setPosition(v.pos.x + 80, v.pos.y + 85)
      self.bigMap:addChild(mapImg, v.z or 1)
      local posx, posy = v.pos.x, v.pos.y
      if i == 10 then
        posy = posy + 13
      elseif i == 11 then
        posx = posx - 10
      end
      local passImg = ed.createSprite("UI/alpha/1080P/campaign/worldmap/" .. imgPssRes .. i .. ".png")
      passImg:setPosition(posx + 80, posy + 85)
      self.bigMap:addChild(passImg, (v.z or 1) + 1)
      local readNode = ed.readnode.create(self.bigMapNode, ui)
      readNode:addNode(res.bigMapName_ui_info)
      ui.panel_name:setPosition(ccpAdd(ccp(posx, posy), v.namePos))
      if self.uiTit then
        self.uiTit.img_normal_2:setVisible(self.newType == "normal")
        self.uiTit.img_hard_2:setVisible(self.newType == "hard")
      end
      ui.panel_name.passImg = passImg
      ui.panel_name.mapImg = mapImg
      ui.index = i
      self.mapNameUi[i] = ui
      local normalPar = 0 < self.starMaxTab.normal[i].max and self.starMaxTab.normal[i].new / self.starMaxTab.normal[i].max or 0
      local hardPar = 0 < self.starMaxTab.hard[i].max and self.starMaxTab.hard[i].new / self.starMaxTab.hard[i].max or 0
      normalPar = 1 < normalPar and 100 or math.floor(normalPar * 100)
      ui.label_1:setString(normalPar .. "%")
      if 100 <= normalPar then
        ui.label_1:setColor(ccc3(ed.colorToStr("#70ff54")))
        ui.label_1:setStroke(ccc3(ed.colorToStr("#091f05")), 1)
      elseif i > self.StageMax.normal then
        ui.label_1:setString(T("\230\156\170\232\167\163\233\148\129"))
        ui.label_1:setColor(ccc3(ed.colorToStr("#dcdbdb")))
        ui.label_1:setStroke(ccc3(ed.colorToStr("#2b2622")), 1)
      end
      local res = i <= self.StageMax.normal and "worldmap_star_normal" or "worldmap_chapter_lock"
      ed.initSpriteWithFrame(ui.img_star_1, "UI/alpha/1080P/campaign/worldmap/" .. res .. ".png")
      hardPar = 1 < hardPar and 100 or math.floor(hardPar * 100)
      ui.label_2:setString(hardPar .. "%")
      if 100 <= hardPar then
        ui.label_2:setColor(ccc3(ed.colorToStr("#70ff54")))
        ui.label_2:setStroke(ccc3(ed.colorToStr("#091f05")), 1)
      elseif i > self.StageMax.hard then
        ui.label_2:setString(T("\230\156\170\232\167\163\233\148\129"))
        ui.label_2:setColor(ccc3(ed.colorToStr("#dcdbdb")))
        ui.label_2:setStroke(ccc3(ed.colorToStr("#2b2622")), 1)
      end
      local res = i <= self.StageMax.hard and "worldmap_star_hard" or "worldmap_chapter_lock"
      ed.initSpriteWithFrame(ui.img_star_2, "UI/alpha/1080P/campaign/worldmap/" .. res .. ".png")
    end
    ui.panel_name.passImg:setOpacity(i == (showChapter or self.StageMax[self.newType]) and 225 or 0)
    self.showChapter = showChapter or self.StageMax[self.newType]
    ed.initSpriteWithFrame(ui.ImageView_997, "UI/alpha/1080P/campaign/worldmap/worldmap_chapter_" .. self.newType .. "_bg.png")
    local chapterName = ed.getDataTable("Chapter")[i]["Chapter Name"]
    ed.setLabelString(ui.label_name, i .. ". " .. chapterName)
    ed.adaptLabel(ui.label_name, {
      maxWidth = 110,
      singleLine = true,
      minScale = 0.75
    })
    if self.newType == "normal" then
      ed.setLabelColor(ui.label_name, ed.toccc3(16775353))
      ed.setLabelStroke(ui.label_name, ed.toccc3(4533012), 1)
    else
      ed.setLabelColor(ui.label_name, ed.toccc3(16776657))
      ed.setLabelStroke(ui.label_name, ed.toccc3(11950857), 1)
    end
    ui.label_name:setFontName(ed.fontBold)
    local isGrey = i <= self.StageMax[self.newType] and ccc3(255, 255, 255) or ccc3(100, 100, 100)
    ui.panel_name.mapImg:setColor(isGrey)
    ui.panel_name.passImg:setColor(isGrey)
    ui.panel_name:setVisible(i <= self.StageMax[self.newType])
  end
  self:setNewShowChapterPos(showChapter or self.StageMax[self.newType])
end

function stageMap:setNewShowChapterPos(showChapter)
  self.bigMap:stopAllActions()
  local newShow = self.mapNamePos[showChapter or 1]
  if not newShow then
    return
  end
  newShow = newShow.pos and newShow.pos.x or 0
  newShow = newShow * (self.bigMap:getScale() + 0.09)
  local widhtWin = ed.display.winSize.width
  local moveX = -newShow + widhtWin / 2
  moveX = ed.clamp(moveX, self.maxTouchX, 0)
  local mr = CCMoveTo:create(1.2, ccp(moveX, self.bigMap:getPositionY()))
  self.bigMap:runAction(CCEaseExponentialOut:create(mr))
end

stageMap.newTouchX = 0

function stageMap:getMainTouchHandler()
  local function playActions(newUpMap)
    newUpMap.passImg:stopAllActions()
    
    newUpMap.passImg:setOpacity(255)
    newUpMap.passImg:runAction(CCSpawn:create(ccArrayMake(unpack({
      CCFadeTo:create(0.3, 0)
    }))))
  end
  
  local mx = 0
  local touchPos, touchMovePos
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        self.newUpMap = nil
        for i, v in ipairs(self.mapNameUi) do
          if ed.containsPoint(v.panel_name, x, y) and v.index <= self.StageMax[self.newType] then
            self.newUpMap = v.panel_name
            self.newUpMap.idex = v.index
            self.newUpMap.passImg:setOpacity(225)
            touchPos = {x, y}
            break
          end
        end
        self.newTouchX = x - self.bigMap:getPositionX()
        self.bigMap:stopAllActions()
        mx = x
      elseif event == "moved" then
        mx = touchMovePos and touchMovePos[1] or mx
        touchMovePos = {x, y}
        if self.newUpMap and math.abs(touchPos[1] - touchMovePos[1]) + math.abs(touchPos[2] - touchMovePos[2]) > 50 then
          self.newUpMap.passImg:setOpacity(self.newUpMap.idex == self.showChapter and 225 or 0)
          self.newUpMap = nil
        end
        self.bigMap:setPositionX(ed.clamp(x - self.newTouchX, self.maxTouchX, 0))
      elseif event == "ended" then
        if self.newUpMap then
          playActions(self.newUpMap)
          if self.newUpMap.idex > self.StageMax[self.newType] then
            ed.showToast(T("\229\189\147\229\137\141\231\171\160\232\138\130\230\156\170\229\188\128\230\148\190"))
          elseif ed.playerlimit.chapterUnlockLevel(self.newUpMap.idex) > ed.player:getLevel() then
            local ul = ed.playerlimit.chapterUnlockLevel(self.newUpMap.idex)
            ed.showToast(T("\229\137\141\229\190\128\230\173\164\229\140\186\229\159\159\233\156\128\232\166\129:\n\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167", ul))
          else
            self.stageSelf:doChangeMode(self.newType == "hard" and "elite" or "normal")
            self.stageSelf:newChangeChapter(self.newUpMap.idex)
            self.stageSelf:showYunMoveWin()
            ed.popScene()
          end
          self.newUpMap = nil
        end
        local moveX, time = self.bigMap:getPositionX(), 0.1
        if mx > x then
          time = mx - x
          moveX = moveX - time * 15
        elseif mx < x then
          time = x - mx
          moveX = moveX + time * 15
        end
        if time < 10 then
          time = 20
        end
        local move = CCMoveTo:create(time / 20, ccp(ed.clamp(moveX, self.maxTouchX, 0), self.bigMap:getPositionY()))
        self.bigMap:runAction(CCEaseExponentialOut:create(move))
      end
    end, EDDebug)
    return true
  end
  
  return handler
end
