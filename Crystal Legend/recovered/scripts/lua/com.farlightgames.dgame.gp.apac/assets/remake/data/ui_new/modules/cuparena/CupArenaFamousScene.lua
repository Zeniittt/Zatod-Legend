local base = ed.ui.basescene
local CupArenaFamousScene = newclass(base.mt)
ed.ui.CupArenaFamousScene = CupArenaFamousScene

function CupArenaFamousScene.create(data)
  local self = base.create("CupArenaFamousScene")
  setmetatable(self, CupArenaFamousScene.mt)
  self:initData(data)
  self:initUI()
  self:adaptUI()
  self:registerTouchEvent()
  self:registerListenEvent()
  return self
end

function CupArenaFamousScene:initData(data)
  self.curSeason = data._season
  self.curZoneId = data._zone_id
  self.rankList = data._rank_list or {}
  self.zoneList = data._zone_list or {}
  if nil == self.maxSeason then
    self.maxSeason = self.curSeason
  end
end

function CupArenaFamousScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.CupArenaFamousScene, {
    container = self.mainLayer
  })
  self.container = container
  self.ui = ui
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:setBackground("UI/alpha/1080P/cuparena/knockout/honor/honor_bg_1.png")
  ed.UITool.createSceneTitle(T("\229\144\141\228\186\186\229\160\130"), self.ui.bg_title, {
    position = ccp(20, 18)
  })
  ed.setLabelStroke(self.ui.label_cur_zone, ed.toccc3(10049818), 1)
  self:createEffectFca()
  self:initSeasonInfo()
end

function CupArenaFamousScene:adaptUI()
  local fixX = ed.display.halfFixedWidth * 2
  local fixY = ed.display.halfFixedHeight * 2
  local addHeight = fixY * 0.5
  local addWidth = fixX * 0.5
  ed.layout.layoutWithMagin(self.ui.btn_left, {left = 50}, nil, true)
  ed.layout.layoutWithMagin(self.ui.btn_right, {right = 50}, nil, true)
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 50, top = 18})
end

function CupArenaFamousScene:createEffectFca(...)
  local addHalfHeight = ed.display.halfFixedHeight
  local bgSize = self.ui.bg:getContentSize()
  bgSize.height = bgSize.height + addHalfHeight
  self.ui.bg:setContentSize(bgSize)
  self.ui.bg:setPositionY(self.ui.bg:getPositionY() - addHalfHeight * 0.5)
  self.ui.bg_season_title:setPositionY(self.ui.bg_season_title:getPositionY() + addHalfHeight)
  local panelSize = self.ui.panel_rank:getContentSize()
  panelSize.height = panelSize.height + addHalfHeight
  self.ui.panel_rank:setContentSize(panelSize)
  self.ui.bg_zone_list:setPositionY(self.ui.bg_zone_list:getPositionY() + addHalfHeight)
  self.ui.bg_cur_zone:setPositionY(self.ui.bg_cur_zone:getPositionY() + addHalfHeight)
  local titleWaterFca = ed.createFcaNode("eff_UI_Main_Cuparena_NO1")
  self:addFca(titleWaterFca)
  self.ui.bg_season_title:addChild(titleWaterFca)
  local bgSize = self.ui.bg_season_title:getContentSize()
  titleWaterFca:setPosition(bgSize.width * 0.5, bgSize.height * 0.5 + 30)
  local pigeonFca = ed.createFcaNode("eff_UI_Main_Cuparena_NO2")
  self:addFca(pigeonFca)
  self.ui.bg:addChild(pigeonFca)
  local bgSize = self.ui.bg:getContentSize()
  pigeonFca:setPosition(bgSize.width * 0.5 + 20, 215)
  local leftWaterFca = ed.createFcaNode("eff_UI_Main_Cuparena_NO3")
  self:addFca(leftWaterFca)
  self.ui.bg:addChild(leftWaterFca)
  leftWaterFca:setPosition(145, bgSize.height * 0.5 - 33)
  local rightWaterFca = ed.createFcaNode("eff_UI_Main_Cuparena_NO3")
  self:addFca(rightWaterFca)
  rightWaterFca:setScaleX(-1)
  self.ui.bg:addChild(rightWaterFca)
  rightWaterFca:setPosition(bgSize.width - 146, bgSize.height * 0.5 - 33)
  local cloudFca = ed.createFcaNode("eff_UI_Main_Cuparena_NO4")
  self:addFca(cloudFca)
  self.ui.bg:addChild(cloudFca)
  cloudFca:setPosition(bgSize.width * 0.5, 145)
  local backCloudFca = ed.createFcaNode("eff_UI_Main_Cuparena_NO4_2")
  self:addFca(backCloudFca)
  self.ui.bg:addChild(backCloudFca, -1)
  backCloudFca:setPosition(270, bgSize.height * 0.5 - 100)
  backCloudFca:setScale(self.bg:getScale())
end

function CupArenaFamousScene:registerTouchEvent()
  ed.UITool.registerBtn(self, "btn_left", function()
    self:onLeftEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_right", function()
    self:onRightEvent()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_cur_zone", function()
    self:onZoneListEvent()
  end)
  self:btRegisterOutClick({
    area = self.ui.bg_zone_list,
    clickHandler = function()
      self:hideZoneList()
    end,
    priority = -1
  })
end

function CupArenaFamousScene:registerListenEvent()
  self:listenEvent("EventCupArenaRefreshFamous", function(data)
    self:initData(data)
    self:initSeasonInfo()
  end)
end

function CupArenaFamousScene:initSeasonInfo()
  if nil == self.ui.seasonTitleLabel then
    self.ui.seasonTitleLabel = ed.ui.gradientLabel.create({
      text = T("\231\172\172%d\232\181\155\229\173\163", self.curSeason),
      fontSize = 26,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776423),
      endColor = ed.toccc3(16770935),
      strokeSize = 1,
      strokeColor = ed.toccc3(3745815)
    })
    self.ui.bg_season_title:addChild(self.ui.seasonTitleLabel.node)
    ed.layout.centerInParent(self.ui.seasonTitleLabel.node)
  else
    self.ui.seasonTitleLabel:setString(T("\231\172\172%d\232\181\155\229\173\163", self.curSeason))
  end
  self:hideZoneList()
  self.zoneUIList = nil
  self.ui.label_cur_zone:setString(T("\231\172\172%d\232\181\155\229\140\186", self.curZoneId))
  self:refreshRankList()
end

function CupArenaFamousScene:createRankItem(index, rankData)
  local container, ui = ed.editorui(ed.uieditor.CupArenaFamousRankItem)
  local bgSize = ui.bg:getContentSize()
  container:setContentSize(bgSize)
  local rankTitleLabel
  if 1 == rankData._rank then
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/honor/honor_board_1.png")
    rankTitleLabel = ed.ui.gradientLabel.create({
      text = ed.CupArenaUITool.getRankName(rankData._rank),
      fontSize = 26,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16776535),
      endColor = ed.toccc3(16755465),
      strokeSize = 1,
      strokeColor = ed.toccc3(5519125)
    }).node
  elseif 2 == rankData._rank then
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/honor/honor_board_2.png")
    rankTitleLabel = ed.ui.gradientLabel.create({
      text = ed.CupArenaUITool.getRankName(rankData._rank),
      fontSize = 26,
      fontName = ed.fontBold,
      startColor = ed.toccc3(13300991),
      endColor = ed.toccc3(4564979),
      strokeSize = 1,
      strokeColor = ed.toccc3(2565181)
    }).node
  elseif 3 == rankData._rank or 4 == rankData._rank then
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/honor/honor_board_3.png")
    rankTitleLabel = ed.ui.gradientLabel.create({
      text = ed.CupArenaUITool.getRankName(rankData._rank),
      fontSize = 26,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16771249),
      endColor = ed.toccc3(16022315),
      strokeSize = 1,
      strokeColor = ed.toccc3(4007972)
    }).node
  else
    ed.setTexture(ui.bg, "UI/alpha/1080P/cuparena/knockout/honor/honor_board_4.png")
    rankTitleLabel = ed.createLabelTTF(ed.CupArenaUITool.getRankName(rankData._rank), 26, ed.fontBold)
    ed.setLabelColor(rankTitleLabel, ed.toccc3(16776423))
    ed.setLabelStroke(rankTitleLabel, ed.toccc3(4007972), 1.5)
  end
  ui.bg:addChild(rankTitleLabel)
  rankTitleLabel:setPosition(80, bgSize.height * 0.5)
  local summary = rankData._user_summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    lvoffset = {x = -47, y = -25}
  }
  local head = ed.getWholeHeadIcon(param)
  head:setScale(ui.img_head:getScaleX())
  ed.UITool.replaceUI(ui, "bg", "img_head", head)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    medalScale = 0.18,
    medalRight = false,
    disableOffset = true,
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(ui, "bg", "label_name", name)
  local campTableItem = ed.getDataTable("CupArenaCamp")[rankData._camp_id]
  ed.setTexture(ui.img_camp, campTableItem["Camp Symbol Min"])
  ed.setLabelString(ui.label_server, rankData._server_name)
  return container, ui
end

function CupArenaFamousScene:refreshRankList(...)
  if nil == self.ui.rankTableview then
    local size = self.ui.panel_rank:getContentSize()
    local delegate = {
      numberOfCells = function()
        return #self.rankList
      end,
      cellSizeFromIndex = function(index)
        return CCSizeMake(600, 80)
      end,
      createCell = function(index)
        return self:createRankItem(index, self.rankList[index])
      end,
      doClickIn = function(cell, x, y)
        local ui = cell.data
        if ui and ed.containsPoint(ui.img_head, x, y) then
          ed.UITool.openView("playerInfoPanel", rankData._oppo._summary._role_id)
        end
      end
    }
    local param = {
      delegate = delegate,
      container = self.ui.panel_rank,
      cliprect = CCRectMake(0, 0, size.width, size.height),
      colNum = 1,
      dragMode = 1,
      touchpriority = -300,
      noshade = true,
      padding = {width = 0, height = -5}
    }
    self.ui.rankTableview = Tableview.create(param)
  end
  self.ui.rankTableview:reloadData()
  self:refreshArrowBtns()
end

function CupArenaFamousScene:getZoneItemPos(i)
  local size = self.ui.panel_zone:getContentSize()
  local ox = size.width / 2
  local oy = size.height
  local itemHeight = 30
  local itemSpace = 0
  local dy = oy - (i - 0.5) * itemHeight - (i - 1) * itemSpace
  return ccp(ox, dy)
end

function CupArenaFamousScene:getZoneListHeight(num)
  local itemHeight = 30
  local itemSpace = 0
  return (itemHeight + itemSpace) * num - itemSpace
end

function CupArenaFamousScene:createZoneItem(index, zoneId)
  local ui = {index = index}
  local container = CCLayer:create()
  local selectedBg = ed.createSprite("UI/alpha/1080P/cuparena/knockout/honor/honor_season_bg_2.png")
  container:addChild(selectedBg)
  ui.selectedBg = selectedBg
  local desLabel = ed.createLabelTTF(T("\231\172\172%d\232\181\155\229\140\186", zoneId), 16)
  container:addChild(desLabel)
  ui.desLabel = desLabel
  return container, ui
end

function CupArenaFamousScene:getZonePressInHandler()
  local function handler(x, y)
    for _, itemUI in ipairs(self.zoneUIList or {}) do
      if ed.containsPoint(itemUI.selectedBg, x, y) then
        return itemUI
      end
    end
  end
  
  return handler
end

function CupArenaFamousScene:getZoneClickInHandler()
  local function handler(x, y, itemUI)
    if itemUI and ed.containsPoint(itemUI.selectedBg, x, y) then
      local zoneId = self.zoneList[itemUI.index]
      
      if nil == zoneId then
        return
      end
      ed.CupArenaNetwork:sendTopRankboard(self.curSeason, zoneId)
      self:hideZoneList()
    end
  end
  
  return handler
end

function CupArenaFamousScene:onZoneListEvent()
  if self.ui.bg_zone_list:isVisible() then
    self:hideZoneList()
  else
    self.ui.bg_zone_list:setVisible(true)
    self.ui.btn_zone_list:setFlipY(true)
    self.ui.rankTableview:getDragList():setTouchEnabled(false)
    if nil == self.zoneUIList then
      local zoneNum = #self.zoneList
      local totalHeight = self:getZoneListHeight(zoneNum)
      local zoneBgSize = self.ui.bg_zone_list:getContentSize()
      zoneBgSize.height = ed.clamp(totalHeight + 33, 64, 168)
      self.ui.bg_zone_list:setContentSize(zoneBgSize)
      local zonePanelSize = self.ui.panel_zone:getContentSize()
      zonePanelSize.height = zoneBgSize.height - 33
      self.ui.panel_zone:setContentSize(zonePanelSize)
      self.ui.panel_zone:setPositionY(8)
      if nil == self.ui.zoneDraglist then
        self.ui.zoneDraglist = ed.UITool.createDraglist(self.ui.panel_zone, {
          priority = -300,
          doPressIn = self:getZonePressInHandler(),
          doClickIn = self:getZoneClickInHandler()
        })
        self.zoneUIList = {}
      else
        self.ui.zoneDraglist:clearList()
        self.zoneUIList = {}
      end
      for i, v in ipairs(self.zoneList) do
        local itemContainer, itemUI = self:createZoneItem(i, v)
        self.ui.zoneDraglist:addItem(itemContainer)
        itemContainer:setPosition(self:getZoneItemPos(i))
        table.insert(self.zoneUIList, itemUI)
      end
      self.ui.zoneDraglist:initListHeight(totalHeight)
    end
    self:refreshSelectedZone()
  end
end

function CupArenaFamousScene:refreshSelectedZone()
  for i, v in ipairs(self.zoneUIList) do
    v.selectedBg:setVisible(self.curZoneId == self.zoneList[i])
  end
end

function CupArenaFamousScene:hideZoneList()
  self.ui.bg_zone_list:setVisible(false)
  self.ui.btn_zone_list:setFlipY(false)
  if nil ~= self.ui.rankTableview then
    self.ui.rankTableview:getDragList():setTouchEnabled(true)
  end
end

function CupArenaFamousScene:refreshArrowBtns(...)
  self.ui.btn_left:setVisible(self.curSeason > 1)
  self.ui.btn_right:setVisible(self.curSeason < self.maxSeason)
end

function CupArenaFamousScene:onLeftEvent()
  if self.curSeason <= 1 then
    return
  end
  ed.CupArenaNetwork:sendTopRankboard(self.curSeason - 1, 0)
end

function CupArenaFamousScene:onRightEvent()
  if self.curSeason >= self.maxSeason then
    return
  end
  ed.CupArenaNetwork:sendTopRankboard(self.curSeason + 1, 0)
end
