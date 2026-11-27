local base = ed.ui.commonscene
local awakeDungeonGridMapScene = newclass(base.mt)
ed.ui.awakeDungeonGridMapScene = awakeDungeonGridMapScene

function awakeDungeonGridMapScene.create(chapterId)
  local self = base.create("awakeDungeonGridMapScene", {noBottomButton = true})
  setmetatable(self, awakeDungeonGridMapScene.mt)
  self:initData(chapterId)
  self:initUI()
  return self
end

local maxRaw = 10000

function awakeDungeonGridMapScene:two2One(v)
  return v.x * maxRaw + v.y
end

function awakeDungeonGridMapScene:one2Two(x)
  local r = math.floor(x / 10000)
  local c = x % 10000
  if x % 10000 > 5000 then
    r = r + 1
    c = c - 10000
  end
  return r, c
end

function awakeDungeonGridMapScene:edpNormalize(a)
  if a[1] == 0 and a[2] == 0 then
    return {1, 0}
  end
  local x = a[1]
  local y = a[2]
  local u = 1 / (x * x + y * y) ^ 0.5
  return {
    x * u,
    y * u
  }
end

function awakeDungeonGridMapScene:getBuildTouchHandler()
  local function handler(event, x, y)
    local _, result = xpcall(function()
      return self:doLayerTouchEvent(event, x, y)
    end, EDDebug)
    return result
  end
  
  return handler
end

function awakeDungeonGridMapScene:setActorMove(diff)
  if diff[2] > 0 then
    if not self.isActorRunning or not self.isActorTurnUp and diff[2] > 0.001 then
      self.isActorRunning = true
      self.isActorTurnUp = true
      self.actor:setAnimation(0, "Move2", true)
      self.actor:update(0)
    end
  elseif not self.isActorRunning or self.isActorTurnUp and diff[2] < -0.001 then
    self.isActorRunning = true
    self.isActorTurnUp = false
    self.actor:setAnimation(0, "Move", true)
    self.actor:update(0)
  end
  if 0 > diff[1] then
    self.actor:setScaleX(1)
  else
    self.actor:setScaleX(-1)
  end
end

function awakeDungeonGridMapScene:setActorIdle()
  if self.isActorRunning then
    self.isActorRunning = false
    if self.isActorTurnUp then
      self.actor:setAnimation(0, "Idle2", true)
    else
      self.actor:setAnimation(0, "Idle", true)
    end
  end
end

function awakeDungeonGridMapScene:update(dt)
  base.update(self, dt)
  if self.movePath then
    local curIndex = self.movePath.index
    local cellArr = self.movePath.cellArr
    if curIndex > #cellArr then
      self:setActorIdle()
      local lastCell = cellArr[#cellArr]
      local dungeonMgr = ed.awakeDungeonMgr.getInstance()
      dungeonMgr:setCurPlayerCellXY(lastCell[1], lastCell[2], true)
      self:toUnlockAroundTile(lastCell[1], lastCell[2])
      if self.movePath.targetCellX ~= lastCell[1] or self.movePath.targetCellY ~= lastCell[2] then
        local ax, _ = self:indexToWorldPos(self.movePath.targetCellX, self.movePath.targetCellY)
        local bx, _ = self.actor:getPosition()
        if ax < bx then
          self.actor:setScaleX(1)
        else
          self.actor:setScaleX(-1)
        end
      end
      self:onTriggerCell(self.movePath.targetCellX, self.movePath.targetCellY)
      self.movePath = nil
    else
      local curCell = cellArr[curIndex]
      local ax, ay = self:indexToWorldPos(curCell[1], curCell[2])
      local bx, by = self.actor:getPosition()
      local diff = {
        ax - bx,
        ay - by
      }
      local lengthSQ = ed.edpLengthSQ(diff)
      local moveDistance = self.moveVelocity * dt
      if lengthSQ < moveDistance * moveDistance then
        self:checkCompleteCellGuideLight(curCell[1], curCell[2])
        curIndex = curIndex + 1
        local extraLength = moveDistance - math.sqrt(lengthSQ)
        if curIndex <= #cellArr then
          local ax2, ay2 = self:indexToWorldPos(cellArr[curIndex][1], cellArr[curIndex][2])
          diff = {
            ax2 - ax,
            ay2 - ay
          }
          self:setActorMove(diff)
          local dir = self:edpNormalize(diff)
          self.actor:setPosition(ccp(bx + dir[1] * extraLength, by + dir[2] * extraLength))
        else
          self.actor:setPosition(ccp(ax, ay))
        end
        self:onActorPositionChanged()
        self.movePath.index = curIndex
      else
        self:setActorMove(diff)
        local dir = self:edpNormalize(diff)
        self.actor:setPosition(ccp(bx + dir[1] * moveDistance, by + dir[2] * moveDistance))
        self:onActorPositionChanged()
      end
    end
  else
    self:setActorIdle()
  end
  self:onMapScrollUpdate(dt)
  self:checkAllReachable()
  self.prevMapLayerPosition.x, self.prevMapLayerPosition.y = self.mapLayer:getPosition()
end

function awakeDungeonGridMapScene:worldToCellIndex(x, y)
  local col = math.ceil(y / self.MapGridSizeY - 0.5)
  local row
  if col % 2 == 0 then
    row = math.ceil(x / self.MapGridSizeX)
  else
    row = math.ceil(x / self.MapGridSizeX - 0.5)
  end
  local distance = math.huge
  local resultX, resultY = row, col
  for i = -1, 1 do
    for j = -1, 1 do
      local posX, posY = self:indexToWorldPos(row + i, col + j)
      local distanceSq = (posX - x) * (posX - x) + (posY - y) * (posY - y)
      if distance > distanceSq then
        distance = distanceSq
        resultX = row + i
        resultY = col + j
      end
    end
  end
  return resultX, resultY
end

function awakeDungeonGridMapScene:indexToWorldPos(x, y)
  local offsetX = 0
  if y % 2 == 0 then
    offsetX = self.MapGridSizeX / 2
  end
  local posX = x * self.MapGridSizeX - offsetX
  local posY = y * self.MapGridSizeY
  return posX, posY
end

local tile_style_Texture_Path = "UI/alpha/1080P/dungeon/stage/tilemap/tilemap.png"
local tile_style_Plist_Path = "UI/alpha/1080P/dungeon/stage/tilemap/tilemap.plist"

local function loadTileTexture()
  local texture = CCTextureCache:sharedTextureCache():textureForKey(tile_style_Texture_Path)
  if not texture then
    texture = CCTextureCache:sharedTextureCache():addImage(tile_style_Texture_Path)
    texture:retain()
  end
  return texture
end

ed.loadTileTexture = loadTileTexture

function awakeDungeonGridMapScene:createTileSprite(frameName, node)
  local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
  if not frame then
    local texture = ed.loadTileTexture()
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(tile_style_Plist_Path, texture)
    frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
  end
  if frame then
    if nil == node then
      node = CCSprite:createWithSpriteFrame(frame)
    else
      node:setDisplayFrame(frame)
    end
  else
    print("can not find", frameName)
  end
  return node
end

function awakeDungeonGridMapScene:initData(chapterId)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.chapterId = chapterId
  self.chapterGroupId = dungeonMgr:getChapterGroup()
end

function awakeDungeonGridMapScene:initUI()
  self.OriginImgSizeX = 102
  self.OriginImgSizeY = 138
  self.MapGridSizeX = 102
  self.MapGridSizeY = 68
  self.moveVelocity = 100
  self.touchSensitivity = 8
  self.isTouching = false
  self.isTouchDraging = false
  self.startTouchPosX, self.startTouchPosY = 0, 0
  self.touchMapLayerPosX, self.touchMapLayerPosY = 0, 0
  self.inertiaVelocity = ccp(0, 0)
  self.prevMapLayerPosition = ccp(0, 0)
  self.reqChapterId = nil
  self.touchSweepPanelPosX = 0
  self.touchSweepPanelPosY = 0
  self.moveSweepPanelMaxY = 0
  self.moveSweepPanelMinY = 0
  self.isShowFirstSummary = ed.awakeDungeonMgr.getInstance():getShowFirstSummary()
  self.touchDisableTab = {}
  self.mapLayer = CCLayer:create()
  self.mainLayer:addChild(self.mapLayer)
  self.mapLayer:setTouchEnabled(true)
  self.mapLayer:registerScriptTouchHandler(self:getBuildTouchHandler(), false, -300, false)
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonGridMapScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:registEvents()
  self:registerTouchEvents()
  self:adaptUI()
  self:createGridMap()
  self:createPlayer()
  self:initParagonExp()
  self:startCountDown()
  self:createTitleName()
  self:initSweepInfo()
  self:refreshBuff()
  self:refreshProgress()
  self:initRedDot()
  self:refreshDungeonLevel()
  self:refreshFirstSummaryVisible(true)
  ed.layout.horizontalSortNode({
    self.ui.title_bg,
    self.ui.image_buff_bg,
    self.ui.image_switch_bg
  }, {
    2,
    2,
    0
  }, self.ui.title_bg:getPositionX() - self.ui.title_bg:getContentSize().width * 0.5, 0)
  self.isFirstEnter = true
  self.prevMapLayerPosition.x, self.prevMapLayerPosition.y = self.mapLayer:getPosition()
  self:rebuildSwallowTouchRect()
end

function awakeDungeonGridMapScene:onPopScene()
  ed.redPointMgr.getInstance():unregisterValueChange("awake_dungeon_reward_entry", self)
  base.onPopScene(self)
end

function awakeDungeonGridMapScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.title_bg, {left = 33, top = 14}, false, true)
  ed.layout.layoutWithMagin(self.ui.image_level_bg, {left = 20, bottom = -5})
  ed.layout.layoutWithMagin(self.ui.image_left_time_bg, {bottom = 24})
  ed.layout.layoutWithMagin(self.ui.panel_sweep, {right = 20})
  self.ui.image_buff_bg:setPositionY(self.ui.title_bg:getPositionY())
  self.ui.image_switch_bg:setPositionY(self.ui.title_bg:getPositionY() + 1.5)
  self.ui.Label_432:limitSizeByScale(45, 30)
  local winSize = ed.display.winSize
  self.moveSweepPanelMaxY = winSize.height - self.ui.panel_sweep:getContentSize().height - 40 - ed.display.halfFixedHeight
  self.moveSweepPanelMinY = 0 - ed.display.halfFixedHeight
end

function awakeDungeonGridMapScene:rebuildSwallowTouchRect(...)
  self.swallowTouchRectArr = {}
  table.insert(self.swallowTouchRectArr, {
    isEnable = true,
    type = "title_bg",
    rect = ed.getNodeSize(self.ui.title_bg)
  })
  table.insert(self.swallowTouchRectArr, {
    isEnable = true,
    type = "image_level_bg",
    rect = ed.getNodeSize(self.ui.image_level_bg)
  })
  table.insert(self.swallowTouchRectArr, {
    isEnable = true,
    type = "image_left_time_bg",
    rect = ed.getNodeSize(self.ui.image_left_time_bg)
  })
  table.insert(self.swallowTouchRectArr, {
    isEnable = true,
    type = "resource_box",
    rect = ed.getNodeSize(self.resourceBox.container)
  })
  table.insert(self.swallowTouchRectArr, {
    isEnable = self.ui.image_buff_bg:isVisible(),
    type = "image_buff_bg",
    rect = ed.getNodeSize(self.ui.image_buff_bg)
  })
  table.insert(self.swallowTouchRectArr, {
    isEnable = true,
    type = "image_switch_bg",
    rect = ed.getNodeSize(self.ui.image_switch_bg)
  })
  table.insert(self.swallowTouchRectArr, {
    isEnable = self.ui.img_sweep_closed:isVisible(),
    type = "img_sweep_closed",
    rect = ed.getNodeSize(self.ui.img_sweep_closed)
  })
  table.insert(self.swallowTouchRectArr, {
    isEnable = self.ui.img_sweep_opened:isVisible(),
    type = "img_sweep_opened",
    rect = ed.getNodeSize(self.ui.img_sweep_opened)
  })
end

function awakeDungeonGridMapScene:createTitleName(...)
  local chapterTableItem = ed.getDataTable("DungeonChapter")[self.chapterGroupId][self.chapterId]
  if nil == self.titleLabel then
    self.titleLabel = ed.ui.gradientLabel.create({
      text = chapterTableItem["Chapter Name"],
      fontSize = 29,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16777215),
      endColor = ed.toccc3(16711602)
    })
    self.ui.title_bg:addChild(self.titleLabel.node)
  else
    self.titleLabel:setString(chapterTableItem["Chapter Name"])
  end
  local titleBgSize = self.ui.title_bg:getContentSize()
  self.titleLabel.node:setPosition(titleBgSize.width * 0.5 - 15, titleBgSize.height * 0.5)
  self.titleLabel.node:setScale(math.min(130 / self.titleLabel.node:getContentSize().width, 1))
end

function awakeDungeonGridMapScene:refreshFirstSummaryVisible(isInit)
  ed.setTexture(self.ui.image_switch_bg, self.isShowFirstSummary and "UI/alpha/1080P/dungeon/stage/switch_open_bg.png" or "UI/alpha/1080P/dungeon/stage/switch_close_bg.png")
  self.ui.label_switch_closed:setVisible(not self.isShowFirstSummary)
  self.ui.label_switch_opened:setVisible(self.isShowFirstSummary)
  self.ui.image_switch_icon:stopAllActions()
  local targetPos = self.isShowFirstSummary and ccp(65.5, 15) or ccp(15, 15)
  if not isInit then
    self.ui.image_switch_icon:runAction(CCMoveTo:create(0.15, targetPos))
    for _, yTab in pairs(self.firstSummaryTab) do
      for _, v in pairs(yTab) do
        if v.model then
          v.model.bg:setVisible(self.isShowFirstSummary)
        end
      end
    end
  else
    self.ui.image_switch_icon:setPosition(targetPos)
  end
end

function awakeDungeonGridMapScene:registerTouchEvents()
  self:btRegisterButtonClick({
    button = self.ui.image_level_bg,
    pressScale = 0.98,
    key = "click_dungeon_level",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.dungeon_iron)
      self:onClickDungeonLevel()
    end,
    force = true,
    clickInterval = 0.2,
    priority = -999
  })
  ed.UITool.registerBtn(self, "image_buff_bg", function()
    self:onClickBuffEvent()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "image_switch_bg", function()
    self.isShowFirstSummary = not self.isShowFirstSummary
    ed.awakeDungeonMgr.getInstance():setShowFirstSummary(self.isShowFirstSummary)
    self:refreshFirstSummaryVisible()
  end, {pressScale = 0.98})
  self:btRegisterClick({
    key = "img_sweep_closed",
    checkClickHandler = function(x, y)
      if ed.containsPoint(self.ui.img_sweep_closed, x, y) then
        return true
      end
      return false
    end,
    pressHandler = function(param, x, y)
      self.touchSweepPanelPosX, self.touchSweepPanelPosY = self.ui.panel_sweep:getPosition()
    end,
    moveHandler = function(param, x, y)
      local newPosX = self.touchSweepPanelPosX
      local newPosY = self.touchSweepPanelPosY + y - param.moveParam.pressY
      self.ui.panel_sweep:setPosition(newPosX, ed.clamp(newPosY, self.moveSweepPanelMinY, self.moveSweepPanelMaxY))
      if nil ~= self.swallowTouchRectArr then
        for i, v in ipairs(self.swallowTouchRectArr) do
          if v.type == "img_sweep_closed" then
            v.rect = ed.getNodeSize(self.ui.img_sweep_closed)
          elseif v.type == "img_sweep_opened" then
            v.rect = ed.getNodeSize(self.ui.img_sweep_opened)
          end
        end
      end
    end,
    clickHandler = function(param, x, y)
      self:setSweepState(true)
    end,
    mcpMode = true,
    mcp_dis = 30,
    pressScale = 0.98
  })
  ed.UITool.registerBtn(self, "img_sweep_opened_title", function()
    self:setSweepState(false)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_sweep_1", function()
    self:onSweepEvent(1)
  end, {pressScale = 0.8, normalScale = 0.85})
  ed.UITool.registerBtn(self, "btn_sweep_2", function()
    if nil == self.maxSweepTimes then
      self:refreshSweepTimes()
      return
    end
    self:onSweepEvent(self.maxSweepTimes)
  end, {pressScale = 0.8, normalScale = 0.85})
end

function awakeDungeonGridMapScene:registEvents(...)
  self:registerOnEnterHandler("onEnter", function()
    if self.isFirstEnter then
      self.isFirstEnter = false
      return
    end
    self:checkLevelChanged()
    self:refreshSweepNum()
    self:dealStageChanged()
    self:refreshProgress()
  end)
  self:listenEvent("awakeDungeonBattleCanceled", function()
    self:checkLevelChanged()
  end)
  self:listenEvent("awakeDungeonSweepComplete", function()
    self:checkLevelChanged()
  end)
  self:listenEvent("dungeonBlockChanged", function()
    self:dealStageChanged()
    self:refreshProgress()
  end)
  self:listenEvent("dungeonVitalityChanged", function()
    self.resourceBox:updateAllResourceValue()
    self:refreshSweepTimes()
  end)
  self:listenEvent("awakeDungeonEnterChapter", function()
    if self.reqChapterId then
      self:switchChapter(self.reqChapterId)
      self.reqChapterId = nil
    end
  end)
  self:listenEvent("awakeDungeonStageRecord", function(stageId)
    if nil == self.reqFirstSummaryCellX then
      return
    end
    self.reqFirstSummaryCellX = nil
    self.reqFirstSummaryCellY = nil
    local awakeDungeonFirstBloodWin = ed.ui.awakeDungeonFirstBloodWin.create({stageId = stageId})
    awakeDungeonFirstBloodWin:popWindow()
    awakeDungeonFirstBloodWin.ui.image_bg:setPosition(ed.display.designSize.width * 0.5, ed.display.designSize.height * 0.5)
  end)
  self:listenEvent("awakeDungeonCoorNotExist", function(...)
    local scene = ed.getCurrentScene()
    if scene and scene.identity == "awakeDungeonGridMapScene" then
      ed.showAlertDialog({
        text = T("\231\189\145\231\187\156\229\188\130\229\184\184\239\188\140\232\175\183\233\135\141\230\150\176\232\191\155\229\133\165\229\133\179\229\141\161"),
        handler = function()
          ed.popScene()
        end
      })
    end
  end)
end

function awakeDungeonGridMapScene:switchChapter(chapterId)
  self:initData(chapterId)
  self.isTouching = false
  self.isTouchDraging = false
  self.startTouchPosX, self.startTouchPosY = 0, 0
  self.touchMapLayerPosX, self.touchMapLayerPosY = 0, 0
  self.inertiaVelocity.x, self.inertiaVelocity.y = 0, 0
  self.prevMapLayerPosition.x, self.prevMapLayerPosition.y = 0, 0
  self.mapLayer:removeAllChildrenWithCleanup(true)
  self:createGridMap()
  self:createPlayer()
  self:createTitleName()
  self:setSweepState(false)
  self:refreshBuff()
  self:refreshProgress()
  ed.layout.horizontalSortNode({
    self.ui.title_bg,
    self.ui.image_buff_bg,
    self.ui.image_switch_bg
  }, {
    2,
    2,
    0
  }, self.ui.title_bg:getPositionX() - self.ui.title_bg:getContentSize().width * 0.5, 0)
  self:rebuildSwallowTouchRect()
  self.prevMapLayerPosition.x, self.prevMapLayerPosition.y = self.mapLayer:getPosition()
end

function awakeDungeonGridMapScene:setSweepState(isOpen)
  self.ui.img_sweep_closed:setVisible(not isOpen)
  self.ui.img_sweep_opened:setVisible(isOpen)
  if nil ~= self.swallowTouchRectArr then
    for i, v in ipairs(self.swallowTouchRectArr) do
      if v.type == "img_sweep_closed" then
        v.isEnable = self.ui.img_sweep_closed:isVisible()
      elseif v.type == "img_sweep_opened" then
        v.isEnable = self.ui.img_sweep_opened:isVisible()
      end
    end
  end
end

function awakeDungeonGridMapScene:initSweepInfo()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local data = {
    type = "item",
    id = dungeonMgr:getDropsId(),
    amount = 10
  }
  local rewardIcon = ed.createItemIcon(data)
  self.ui.img_sweep_opened:addChild(rewardIcon)
  rewardIcon:setScale(0.6)
  local bgSize = self.ui.img_sweep_opened:getContentSize()
  rewardIcon:setPosition(bgSize.width * 0.5, bgSize.height * 0.5 + 10)
  self:btRemoveMainTouchHandler({
    key = "sweep_reward_icon"
  })
  self:btRegisterButtonClick({
    button = rewardIcon,
    key = "sweep_reward_icon",
    clickHandler = function()
      ed.UITool.openView("packageDetail", data)
    end,
    force = true,
    mcpMode = true,
    pressScale = 0.56,
    normalScale = 0.6
  })
  self.sweepRewardIcon = rewardIcon
  local cost = ed.getDataTable("DungeonConfig").SweepVitalityCost.Value[1]
  ed.setLabelString(self.ui.label_sweep_cost_1, cost)
  ed.setLabelString(self.ui.label_sweep_cost_2, cost * 10)
  self:setSweepState(false)
  self:refreshSweepTimes()
  self:refreshSweepNum()
end

function awakeDungeonGridMapScene:refreshSweepTimes()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local vitality = dungeonMgr:getCurVitality()
  local cost = ed.getDataTable("DungeonConfig").SweepVitalityCost.Value[1]
  self.maxSweepTimes = math.min(10, math.floor(vitality / cost))
  if 0 == self.maxSweepTimes then
    self.maxSweepTimes = 10
  end
  ed.setLabelString(self.ui.label_sweep_cost_2, self.maxSweepTimes * cost)
  ed.setLabelString(self.ui.label_sweep_2, T("\230\137\171\232\141\161%d\230\172\161", self.maxSweepTimes))
  ed.setLabelString(self.ui.label_sweep_1, T("\230\137\171\232\141\161%d\230\172\161", 1))
end

function awakeDungeonGridMapScene:refreshSweepNum(...)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.ui.panel_sweep:setVisible(dungeonMgr:getSweepRewardNum() > 0)
  if not tolua.isnull(self.sweepRewardIcon) and self.sweepRewardIcon.amountLabel then
    ed.setLabelString(self.sweepRewardIcon.amountLabel, dungeonMgr:getSweepRewardNum())
  end
end

function awakeDungeonGridMapScene:onSweepEvent(times)
  local cost = ed.getDataTable("DungeonConfig").SweepVitalityCost.Value[1]
  local totalCost = cost * times
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local vitality = dungeonMgr:getCurVitality()
  if totalCost > vitality then
    ed.UITool.openView("awakeDungeonBuyEnergy")
    return
  end
  ed.AwakeDungeonNetwork.sendSweep(times)
end

function awakeDungeonGridMapScene:onClickBuffEvent()
  local win = ed.ui.awakeDungeonBuffDetailWin.create({
    chapterId = self.chapterId
  })
  win:popWindow()
  ed.layout.relateLayout(self.ui.image_buff_bg, win.ui.image_bg, {bottom = 30})
end

function awakeDungeonGridMapScene:refreshBuff()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local buffInfo, nextBuffInfo = dungeonMgr:getBuffInfoByChapterId(self.chapterId)
  if not buffInfo then
    self.ui.image_buff_bg:setVisible(false)
    return
  end
  self.ui.image_buff_bg:setVisible(true)
  local buffEndTime = buffInfo.buffEndTime
  local leftTime = buffEndTime - ed.getServerTime()
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  ed.setLabelString(self.ui.label_buff_time, string.format(T("\229\137\169\228\189\153%s\229\164\169%s\229\176\143\230\151\182"), day, hour))
  ed.setLabelDimensions(self.ui.label_buff_desc2, CCSizeMake(390, 0))
  ed.setLabelString(self.ui.label_buff, ed.awakeDungeonDefine.getBuffDes(buffInfo.shortDesc))
  ed.adaptLabel(self.ui.label_buff, {maxWidth = 80, minScale = 0.7})
end

function awakeDungeonGridMapScene:refreshProgress()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local progressVal = dungeonMgr:getChapterProgress(self.chapterId)
  ed.setLabelString(self.ui.label_chapter_progress, string.format("%d%%", progressVal))
end

function awakeDungeonGridMapScene:initRedDot()
  ed.redPointMgr.getInstance():registerValueChange("awake_dungeon_reward_entry", self, {
    handle = function(value)
      self.ui.reward_entry_reddot:setVisible(0 < value)
    end
  })
end

function awakeDungeonGridMapScene:refreshDungeonLevel()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local paragonLevel = dungeonMgr:getParagonLevel()
  local curExp = dungeonMgr:getParagonExp()
  ed.setLabelString(self.ui.label_level, string.format(T("%s\231\186\167"), paragonLevel))
  ed.adaptLabel(self.ui.label_level, {maxWidth = 48, minScale = 0.7})
  local barPercent
  if paragonLevel >= dungeonMgr:getMaxParagonLevel() then
    ed.setLabelString(self.ui.label_exp_percent, "MAX")
    barPercent = 1
  else
    local curLevelMaxExp = dungeonMgr:getMaxExp(paragonLevel)
    local curExp = dungeonMgr:getParagonExp()
    barPercent = curExp / curLevelMaxExp
    ed.setLabelString(self.ui.label_exp_percent, string.format("%s%%", math.floor(curExp / curLevelMaxExp * 100)))
  end
  local clipSize = self.ui.panel_clip:getContentSize()
  self.ui.panel_clip:setClipRect(CCRectMake(0, 0, clipSize.width * barPercent, clipSize.height))
end

function awakeDungeonGridMapScene:checkLevelChanged()
  self:refreshDungeonLevel()
  if ed.getCurrentScene() == self then
    local dungeonMgr = ed.awakeDungeonMgr.getInstance()
    self.paragonExpWrap:updateNewExpAndLevel(dungeonMgr:checkExpAndLevelChanged())
  end
end

function awakeDungeonGridMapScene:initParagonExp(...)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.paragonExpWrap = ed.ui.awakeDungeonParagonExpWrap.create({
    ui = {
      exp_change_bg = self.ui.exp_change_bg,
      label_change_level = self.ui.label_change_level,
      label_exp = self.ui.label_exp,
      label_get_exp = self.ui.label_get_exp,
      image_circle_bar = self.ui.image_circle_bar,
      label_exp_change_title = self.ui.label_exp_change_title
    }
  })
end

function awakeDungeonGridMapScene:startCountDown()
  self:refreshLeftTime()
  local label_wid = self.ui.label_left_time:getContentSize().width
  local bg_size = self.ui.image_left_time_bg:getContentSize()
  if label_wid + 73 > bg_size.width then
    self.ui.image_left_time_bg:setContentSize(CCSizeMake(label_wid + 75, bg_size.height))
  end
  self:listenTimer(Timer:Always(1), function()
    self:refreshLeftTime()
  end)
end

function awakeDungeonGridMapScene:refreshLeftTime()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local startTime, endTime = dungeonMgr:getTimeInfo()
  local leftTime = endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134 \230\180\187\229\138\168\231\187\147\230\157\159", hour, min))
  else
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182 \230\180\187\229\138\168\231\187\147\230\157\159", day, hour))
  end
end

function awakeDungeonGridMapScene:createVitalityPrompt()
  local promptText = self:getVitalityPromptText()
  if not promptText then
    return
  end
  local promptCard, label = self:createPromptCard(promptText)
  self.scene:addChild(promptCard, 60)
  self:registerUpdateHandler("VitalityPrompt", self:refreshVitalityPromptHandler())
  self.promptCard = promptCard
  self.vitPromptLabel = label
end

function awakeDungeonGridMapScene:createPromptCard(text)
  self:destroyPromptCard()
  local container = CCSprite:create()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png", CCRectMake(8, 8, 37, 37))
  bg:setAnchorPoint(ccp(1, 1))
  bg:setPosition(ccp(ed.display.winSize.width - 30, ed.display.winSize.height - 40))
  container:addChild(bg)
  local label = ed.createttf(text, 14)
  label:setHorizontalAlignment(kCCTextAlignmentLeft)
  label:setColor(ccc3(255, 252, 231))
  ed.setLabelStroke(label, ccc3(85, 64, 39), 1)
  bg:addChild(label)
  local size = label:getContentSize()
  bg:setContentSize(CCSizeMake(size.width + 20, size.height + 20))
  label:setPosition(ed.getCenterPos(bg))
  return container, label
end

function awakeDungeonGridMapScene:getVitalityPromptText()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local vitalityUpdateTime = dungeonMgr:getVitalityUpdateTime()
  local current = dungeonMgr:getCurVitality()
  local upperLimit = dungeonMgr:getMaxVitality()
  local gap = 360
  local itemName = ed.getDataTable("Token").DungeonEnergy["Token Name"]
  if current >= upperLimit then
    return string.format(T("%s\229\183\178\229\155\158\230\187\161"), itemName)
  end
  local nextTime = vitalityUpdateTime + gap
  local recoverLeftTime = nextTime - ed.getServerTime()
  if recoverLeftTime <= 0 then
    ed.AwakeDungeonNetwork.sendOpenPanel()
    return
  end
  local recoverAllLeftTime = recoverLeftTime + (upperLimit - current - 1) * gap
  local nextTimeStr = ed.gethmsNString(recoverLeftTime or 0)
  local maxTimeStr = ed.gethmsNString(recoverAllLeftTime or 0)
  local prompt = string.format(string.format(T("\228\184\139\231\130\185%s\230\129\162\229\164\141\239\188\154%s"), itemName, nextTimeStr))
  prompt = prompt .. string.format(string.format(T("\n\230\129\162\229\164\141\229\133\168\233\131\168%s\239\188\154%s"), itemName, maxTimeStr))
  prompt = prompt .. string.format(string.format(T("\n\230\129\162\229\164\141\230\151\182\233\151\180\233\151\180\233\154\148\239\188\154%s\229\136\134\233\146\159"), gap / 60))
  return prompt
end

function awakeDungeonGridMapScene:refreshVitalityPromptHandler()
  local count = 0
  
  local function handler(dt)
    if tolua.isnull(self.promptCard) or tolua.isnull(self.vitPromptLabel) then
      self:removeUpdateHandler("VitalityPrompt")
      return
    end
    count = count + dt
    if 1 < count then
      local prompt = self:getVitalityPromptText()
      ed.setString(self.vitPromptLabel, prompt)
      count = count - 1
    end
  end
  
  return handler
end

function awakeDungeonGridMapScene:destroyPromptCard()
  if not tolua.isnull(self.promptCard) then
    self.promptCard:removeFromParentAndCleanup(true)
    self.promptCard = nil
  end
end

function awakeDungeonGridMapScene:onClickDungeonLevel()
  ed.UITool.openView("awakeDungeonLevelScene")
end

function awakeDungeonGridMapScene:updateArrowInfo(...)
  local winSize = ed.display.winSize
  local visibleRect = CCRectMake(-ed.display.halfFixedWidth, -ed.display.halfFixedHeight, winSize.width, winSize.height)
  local minX, minY, maxX, maxY = visibleRect:getMinX(), visibleRect:getMinY(), visibleRect:getMaxX(), visibleRect:getMaxY()
  local centerX, centerY = (minX + maxX) * 0.5, (minY + maxY) * 0.5
  if nil ~= self.actor then
    local curPosX, curPosY = self.actor:getPosition()
    local curConvertPos = self.mapLayer:convertToWorldSpace(ccp(curPosX, curPosY))
    curConvertPos = self.ui.img_player_arrow:getParent():convertToNodeSpace(curConvertPos)
    if visibleRect:containsPoint(curConvertPos) then
      self.ui.img_player_arrow:setVisible(false)
    else
      self.ui.img_player_arrow:setVisible(true)
      local arrowSize = self.ui.img_player_arrow:getContentSize()
      local val = math.max(arrowSize.width, arrowSize.height) * 0.5
      local x = ed.clamp(curConvertPos.x, minX + val, maxX - val)
      local y = ed.clamp(curConvertPos.y, minY + val, maxY - val)
      self.ui.img_player_arrow:setPosition(x, y)
      local angle = math.deg(math.atan2(curConvertPos.y - centerY, curConvertPos.x - centerX))
      if angle < 0 then
        angle = angle + 360
      end
      local rot = 0
      if 45 < angle and angle <= 135 then
        rot = 0
      elseif 135 < angle and angle <= 225 then
        rot = -90
      elseif 225 < angle and angle < 315 then
        rot = 180
      else
        rot = 90
      end
      self.ui.img_player_arrow:setRotation(rot)
      self.ui.icon_player:setRotation(-rot)
    end
  else
    self.ui.img_player_arrow:setVisible(false)
  end
  local tileArr = self:getBuildingTileArrByType(ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_END)
  if nil ~= tileArr and not tileArr[1].isComplete then
    local curPosX, curPosY = self:indexToWorldPos(tileArr[1].config.x, tileArr[1].config.y)
    local curConvertPos = self.mapLayer:convertToWorldSpace(ccp(curPosX, curPosY))
    curConvertPos = self.ui.img_end_arrow:getParent():convertToNodeSpace(curConvertPos)
    if visibleRect:containsPoint(curConvertPos) then
      self.ui.img_end_arrow:setVisible(false)
    else
      self.ui.img_end_arrow:setVisible(true)
      local arrowSize = self.ui.img_end_arrow:getContentSize()
      local val = math.max(arrowSize.width, arrowSize.height) * 0.5
      local x = ed.clamp(curConvertPos.x, minX + val, maxX - val)
      local y = ed.clamp(curConvertPos.y, minY + val, maxY - val)
      self.ui.img_end_arrow:setPosition(x, y)
      local angle = math.deg(math.atan2(curConvertPos.y - centerY, curConvertPos.x - centerX))
      if angle < 0 then
        angle = angle + 360
      end
      local rot = 0
      if 45 < angle and angle <= 135 then
        rot = 0
      elseif 135 < angle and angle <= 225 then
        rot = -90
      elseif 225 < angle and angle < 315 then
        rot = 180
      else
        rot = 90
      end
      self.ui.img_end_arrow:setRotation(rot)
      self.ui.icon_end:setRotation(-rot)
    end
  else
    self.ui.img_end_arrow:setVisible(false)
  end
end

function awakeDungeonGridMapScene:onMapPositionChanged()
  self:updateArrowInfo()
end

function awakeDungeonGridMapScene:onActorPositionChanged()
  self:updateArrowInfo()
end

function awakeDungeonGridMapScene:createGridMap(...)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local chapterTableItem = ed.getDataTable("DungeonChapter")[self.chapterGroupId][self.chapterId]
  local checkArr = chapterTableItem["Highlight Block"]
  self.cellGuideLightArr = {}
  for i = 1, 999 do
    if i >= #checkArr then
      break
    end
    local x, y = checkArr[i * 2 - 1], checkArr[i * 2]
    if not dungeonMgr:isCellGuideComplete(self.chapterId, x, y) then
      table.insert(self.cellGuideLightArr, {
        cellX = x,
        cellY = y,
        lightModel = nil
      })
    end
  end
  self:setBackground(string.format("UI/alpha/1080P/dungeon/stage/chapter%d_bg.png", self.chapterId))
  local groundData, buildingData, colliderData = dungeonMgr:getMapConfig(chapterTableItem.Map)
  self.mapCornerLocalPos = {
    minX = 99999,
    minY = 99999,
    maxX = -99999,
    maxY = -99999
  }
  self.mapLayerLimitPos = {
    minX = 0,
    minY = 0,
    maxX = 0,
    maxY = 0
  }
  self.groundTileTab = {}
  self.colliderTileTab = {}
  self.buildingTileTab = {}
  self.classifyBuildingTileTab = {}
  self.firstSummaryTab = {}
  for k, v in ipairs(colliderData.tiles or {}) do
    self.colliderTileTab[v.x] = self.colliderTileTab[v.x] or {}
    self.colliderTileTab[v.x][v.y] = true
  end
  self.mapBatchNode = CCSpriteBatchNode:createWithTexture(ed.loadTileTexture())
  self.mapLayer:addChild(self.mapBatchNode)
  self.buildingLayer = CCLayer:create()
  self.mapLayer:addChild(self.buildingLayer)
  local groundTiles = groundData.tiles
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  for k, v in ipairs(groundTiles) do
    local tile = {config = v}
    local sprite = self:createTileSprite(string.format("%s.png", v.tileName))
    local pivotX, pivotY = 0.5, 0.65
    sprite:setAnchorPoint(ccp(pivotX, pivotY))
    local x, y = self:indexToWorldPos(v.x, v.y)
    sprite:setPosition(ccp(x, y))
    self.mapBatchNode:addChild(sprite)
    sprite:setZOrder(self:getZOrder(v.x, v.y, ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_GROUND))
    tile.model = sprite
    local stageProgress = dungeonMgr:getCurStageProgress(v.x, v.y)
    if ed.awakeDungeonDefine.UNLOCK_PROGRESS == stageProgress then
      local mashPath = "block_mask_lock.png"
      if v.tileName == "block_treasure" then
        mashPath = "block_treasure_close.png"
      end
      local mask = self:createTileSprite(mashPath)
      mask:setAnchorPoint(ccp(pivotX, pivotY))
      mask:setPosition(ccp(x, y))
      self.mapBatchNode:addChild(mask)
      mask:setZOrder(self:getZOrder(v.x, v.y, ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_MASK))
      tile.mask = {model = mask, isMask = true}
    else
      tile.mask = {model = nil, isMask = false}
    end
    tile.bottom = {model = nil}
    self.mapCornerLocalPos.minX = math.min(self.mapCornerLocalPos.minX, x - self.OriginImgSizeX * pivotX)
    self.mapCornerLocalPos.minY = math.min(self.mapCornerLocalPos.minY, y - self.OriginImgSizeY * pivotY)
    self.mapCornerLocalPos.maxX = math.max(self.mapCornerLocalPos.maxX, x + self.OriginImgSizeX * (1 - pivotX))
    self.mapCornerLocalPos.maxY = math.max(self.mapCornerLocalPos.maxY, y + self.OriginImgSizeY * (1 - pivotY))
    local yTab = self.groundTileTab[v.x]
    if not yTab then
      yTab = {}
      self.groundTileTab[v.x] = yTab
    end
    yTab[v.y] = tile
  end
  for k, v in ipairs(buildingData.tiles) do
    if v.type ~= ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_START then
      local tile = {config = v}
      local stageProgress = dungeonMgr:getCurStageProgress(v.x, v.y)
      tile.isComplete = ed.awakeDungeonDefine.MAX_PROGRESS == stageProgress and not ed.awakeDungeonDefine.isShowIfComplete(v.type)
      if not self:isGroundTileMask(v.x, v.y) then
        if not tile.isComplete then
          tile.model = self:createBuildingModel(v)
          self:setReachableDirty(v.x, v.y)
        else
          local firstSummary = dungeonMgr:getCurStageFirstRecord(v.x, v.y)
          if nil ~= firstSummary then
            local summaryModel = self:createFirstSummary(v.x, v.y, firstSummary._user_summary)
            self:setFirstSummary(v.x, v.y, {
              model = summaryModel,
              stageId = firstSummary._stage_id
            })
          end
        end
      end
      self:setBuildingTile(v.x, v.y, tile)
    end
  end
  self:rebuildMapLayerLimitPos()
end

function awakeDungeonGridMapScene:getZOrder(x, y, type)
  return -y * 100 + ed.awakeDungeonDefine.GRIDMAP_ZORDER[type]
end

function awakeDungeonGridMapScene:createBuildingModel(v)
  local model
  local spinePath = ed.awakeDungeonDefine.GRIDMAP_BUILDING_SPINE[v.tileName]
  if nil ~= spinePath then
    model = ed.ui.awakeDungeonSpineModelItem.create(spinePath)
  else
    model = ed.ui.awakeDungeonSpriteModelItem.create(v.tileName)
  end
  local x, y = self:indexToWorldPos(v.x, v.y)
  model:addTo(self.buildingLayer, ccp(x, y), self:getZOrder(v.x, v.y, v.type))
  local groundTile = self:getGroundTile(v.x, v.y)
  if nil ~= groundTile and nil == groundTile.bottom.model and v.tileName == "special_level_icon" then
    local bottomRes = ed.awakeDungeonDefine.GRIDMAP_BUILDING_BOTTOM[groundTile.config.tileName]
    if nil ~= bottomRes then
      local bottomModel = self:createTileSprite(string.format("%s.png", bottomRes))
      self.mapBatchNode:addChild(bottomModel)
      local pivotX, pivotY = 0.5, 0.65
      bottomModel:setAnchorPoint(ccp(pivotX, pivotY))
      bottomModel:setZOrder(self:getZOrder(v.x, v.y, ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_BOTTOM))
      bottomModel:setPosition(x, y)
      groundTile.bottom.model = bottomModel
    end
  end
  return model
end

function awakeDungeonGridMapScene:createFirstSummary(cellX, cellY, v)
  local bg = ed.createSprite("UI/alpha/1080P/dungeon/stage/flag.png")
  self.buildingLayer:addChild(bg, ed.awakeDungeonDefine.GRIDMAP_ZORDER[ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_FLAG])
  local x, y = self:indexToWorldPos(cellX, cellY)
  bg:setPosition(x, y - 0)
  local bgSize = bg:getContentSize()
  local param = {
    id = v._avatar,
    scale = 0.42
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  bg:addChild(head)
  head:setPosition(bgSize.width * 0.5 + 2, bgSize.height * 0.5 + 3)
  local name = ed.getPlayerName(v._name, v._medal, {
    root = CCSprite:create(),
    anchorPoint = ccp(0.5, 0.5),
    medalScale = 0.13,
    disableOffset = true,
    fontSize = 14,
    labelStroke = "ccc3(50,19,21)"
  })
  bg:addChild(name)
  name:setPosition(bgSize.width * 0.5, 8)
  return {
    bg = bg,
    headIcon = headIcon,
    name = name
  }
end

function awakeDungeonGridMapScene:createPlayer()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local posX, posY = self:indexToWorldPos(dungeonMgr:getCurPlayerCellXY())
  self.actor = ed.createSpine("effect/eff_UI_Dungeon_tank/eff_UI_Dungeon_tank", 0.4)
  self.actor:setAnimation(0, "Idle", true)
  self.actor:setPosition(posX, posY)
  self.buildingLayer:addChild(self.actor, ed.awakeDungeonDefine.GRIDMAP_ZORDER[ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_ACTOR])
  self.isActorRunning = false
  self.isActorTurnUp = false
  self:makePositionCenter(posX, posY)
  self:toUnlockAroundTile(dungeonMgr:getCurPlayerCellXY())
end

function awakeDungeonGridMapScene:makeCellCenter(cellX, cellY)
  local x, y = self:indexToWorldPos(cellX, cellY)
  self:makePositionCenter(x, y)
end

function awakeDungeonGridMapScene:makePositionCenter(x, y)
  local winSize = ed.display.winSize
  local mapPosX, mapPosY = self.mapLayer:getPosition()
  local pos = self.mapLayer:convertToWorldSpace(ccp(x, y))
  pos = self.mapLayer:getParent():convertToNodeSpace(pos)
  pos.x = -pos.x + mapPosX + winSize.width * 0.5
  pos.y = -pos.y + mapPosY + winSize.height * 0.5
  self:setMapPosition(pos.x, pos.y)
end

function awakeDungeonGridMapScene:rebuildMapLayerLimitPos()
  local winSize = ed.display.winSize
  local mapPosX, mapPosY = self.mapLayer:getPosition()
  local maxMapLayerPos = self.mapLayer:convertToWorldSpace(ccp(self.mapCornerLocalPos.minX, self.mapCornerLocalPos.minY))
  maxMapLayerPos = self.mapLayer:getParent():convertToNodeSpace(maxMapLayerPos)
  local minMapLayerPos = self.mapLayer:convertToWorldSpace(ccp(self.mapCornerLocalPos.maxX, self.mapCornerLocalPos.maxY))
  minMapLayerPos = self.mapLayer:getParent():convertToNodeSpace(minMapLayerPos)
  local centerMapLayerPos = ccp((minMapLayerPos.x + maxMapLayerPos.x) * 0.5, (minMapLayerPos.y + maxMapLayerPos.y) * 0.5)
  centerMapLayerPos.x = -centerMapLayerPos.x + mapPosX + winSize.width * 0.5
  centerMapLayerPos.y = -centerMapLayerPos.y + mapPosY + winSize.height * 0.5
  maxMapLayerPos.x = -maxMapLayerPos.x + mapPosX + self.MapGridSizeX
  maxMapLayerPos.y = -maxMapLayerPos.y + mapPosY + self.MapGridSizeY
  minMapLayerPos.x = -minMapLayerPos.x + mapPosX - self.MapGridSizeX + winSize.width
  minMapLayerPos.y = -minMapLayerPos.y + mapPosY - self.MapGridSizeY + winSize.height
  self.mapLayerLimitPos.maxX = math.max(maxMapLayerPos.x, centerMapLayerPos.x) - ed.display.halfFixedWidth
  self.mapLayerLimitPos.maxY = math.max(maxMapLayerPos.y, centerMapLayerPos.y) - ed.display.halfFixedHeight
  self.mapLayerLimitPos.minX = math.min(minMapLayerPos.x, centerMapLayerPos.x) - ed.display.halfFixedWidth
  self.mapLayerLimitPos.minY = math.min(minMapLayerPos.y, centerMapLayerPos.y) - ed.display.halfFixedHeight
end

function awakeDungeonGridMapScene:setMapPosition(x, y)
  self.mapLayer:setPosition(ed.clamp(x, self.mapLayerLimitPos.minX, self.mapLayerLimitPos.maxX), ed.clamp(y, self.mapLayerLimitPos.minY, self.mapLayerLimitPos.maxY))
  self:onMapPositionChanged()
end

function awakeDungeonGridMapScene:getGroundTile(cellX, cellY)
  local xTab = self.groundTileTab[cellX]
  if nil ~= xTab then
    return xTab[cellY]
  else
    return nil
  end
end

function awakeDungeonGridMapScene:getBuildingTile(cellX, cellY)
  local xTab = self.buildingTileTab[cellX]
  if nil ~= xTab then
    return xTab[cellY]
  else
    return nil
  end
end

function awakeDungeonGridMapScene:setBuildingTile(cellX, cellY, tile)
  local yTab = self.buildingTileTab[cellX]
  if nil == yTab then
    yTab = {}
    self.buildingTileTab[cellX] = yTab
  end
  yTab[cellY] = tile
  local arr = self.classifyBuildingTileTab[tile.config.type]
  if nil == arr then
    arr = {}
    self.classifyBuildingTileTab[tile.config.type] = arr
  end
  table.insert(arr, tile)
end

function awakeDungeonGridMapScene:getBuildingTileArrByType(type)
  return self.classifyBuildingTileTab[type]
end

function awakeDungeonGridMapScene:setFirstSummary(cellX, cellY, summary)
  local yTab = self.firstSummaryTab[cellX]
  if nil == yTab then
    yTab = {}
    self.firstSummaryTab[cellX] = yTab
  end
  yTab[cellY] = summary
  if summary.model then
    summary.model.bg:setVisible(self.isShowFirstSummary)
  end
end

function awakeDungeonGridMapScene:isGroundTileMask(cellX, cellY)
  local tile = self:getGroundTile(cellX, cellY)
  if nil == tile then
    return true
  end
  if tile.mask.isMask then
    return true
  else
    return false
  end
end

function awakeDungeonGridMapScene:toUnlockOneTile(cellX, cellY)
  local groundTile = self:getGroundTile(cellX, cellY)
  if nil ~= groundTile and groundTile.mask.isMask then
    groundTile.mask.model:stopAllActions()
    groundTile.mask.model:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(5 * ed.awakeDungeonDefine.ACTION_TIME_UNIT), CCFadeOut:create(9 * ed.awakeDungeonDefine.ACTION_TIME_UNIT)))
    groundTile.mask.isMask = false
    local buildingTile = self:getBuildingTile(cellX, cellY)
    if buildingTile and nil == buildingTile.model then
      buildingTile.model = self:createBuildingModel(buildingTile.config)
      buildingTile.model:playShowAction()
    end
    if nil ~= groundTile.bottom.model then
      groundTile.bottom.model:stopAllActions()
      groundTile.bottom.model:setOpacity(0)
      groundTile.bottom.model:runAction(CCFadeIn:create(8 * ed.awakeDungeonDefine.ACTION_TIME_UNIT))
    end
  end
end

function awakeDungeonGridMapScene:toUnlockAroundTile(cellX, cellY)
  self:toUnlockOneTile(cellX, cellY)
  local neighborOffsetArr = ed.awakeDungeonDefine.HEXAGON_AROUND_OFFSET[2]
  local arr = neighborOffsetArr[cellY % 2 + 1]
  for k, v in ipairs(arr) do
    local x = cellX + v[1]
    local y = cellY + v[2]
    self:toUnlockOneTile(x, y)
  end
  self:setAllBuildingReachableDirty()
  self:checkCellPlayGuideLight()
end

function awakeDungeonGridMapScene:setAllBuildingReachableDirty()
  for cellX, yTab in pairs(self.buildingTileTab) do
    for cellY, buildingTile in pairs(yTab) do
      if not buildingTile.isComplete and not self:isGroundTileMask(cellX, cellY) then
        self:setReachableDirty(cellX, cellY)
      end
    end
  end
end

function awakeDungeonGridMapScene:checkCellPlayGuideLight()
  local needNum = #self.cellGuideLightArr
  if needNum <= 0 then
    return
  end
  local curPosX, curPosY = self.actor:getPosition()
  local startCellX, startCellY = self:worldToCellIndex(curPosX, curPosY)
  for i, v in ipairs(self.cellGuideLightArr) do
    if nil == v.lightModel and not self:isGroundTileMask(v.cellX, v.cellY) then
      local cellArr = self:findPathByCell({x = startCellX, y = startCellY}, {
        x = v.cellX,
        y = v.cellY
      })
      if nil ~= cellArr then
        v.lightModel = ed.createSprite("UI/alpha/1080P/dungeon/stage/block_highlight.png")
        self.buildingLayer:addChild(v.lightModel)
        v.lightModel:setZOrder(self:getZOrder(v.cellX, v.cellY, ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_BOTTOM))
        local x, y = self:indexToWorldPos(v.cellX, v.cellY)
        v.lightModel:setPosition(x, y)
        local action = CCSequence:createWithTwoActions(CCFadeIn:create(0.5), CCFadeOut:create(0.5))
        action = CCRepeatForever:create(action)
        v.lightModel:runAction(action)
      end
    end
  end
end

function awakeDungeonGridMapScene:checkCompleteCellGuideLight(x, y)
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  for i = #self.cellGuideLightArr, 1, -1 do
    local v = self.cellGuideLightArr[i]
    if nil ~= v.lightModel and v.cellX == x and v.cellY == y then
      v.lightModel:removeFromParentAndCleanup(true)
      table.remove(self.cellGuideLightArr, i)
      dungeonMgr:setCellGuideComplete(self.chapterId, v.cellX, v.cellY)
    end
  end
end

function awakeDungeonGridMapScene:setReachableDirty(cellX, cellY)
  if nil == self.reachableDirtyArr then
    self.reachableDirtyArr = {}
  end
  for i, v in ipairs(self.reachableDirtyArr) do
    if v[1] == cellX and v[2] == cellY then
      return
    end
  end
  table.insert(self.reachableDirtyArr, {cellX, cellY})
end

function awakeDungeonGridMapScene:checkAllReachable()
  if nil == self.reachableDirtyArr then
    return
  end
  for i, v in ipairs(self.reachableDirtyArr) do
    self:checkBuildingReachable(v[1], v[2])
  end
  self.reachableDirtyArr = nil
end

function awakeDungeonGridMapScene:checkBuildingReachable(cellX, cellY)
  local buildingTile = self:getBuildingTile(cellX, cellY)
  if nil == buildingTile then
    return
  end
  if nil ~= buildingTile.arrowModel or self:isGroundTileMask(cellX, cellY) or buildingTile.isComplete then
    return
  end
  if ed.awakeDungeonDefine.isShowIfComplete(buildingTile.config.type) then
    return
  end
  local curPosX, curPosY = self.actor:getPosition()
  local startCellX, startCellY = self:worldToCellIndex(curPosX, curPosY)
  local cellArr = self:findPathByCell({x = startCellX, y = startCellY}, {x = cellX, y = cellY})
  if nil == cellArr then
    return
  end
  buildingTile.arrowModel = ed.createSprite("UI/alpha/1080P/dungeon/stage/can_arrive.png")
  self.buildingLayer:addChild(buildingTile.arrowModel)
  buildingTile.arrowModel:setZOrder(self:getZOrder(cellX, cellY, ed.awakeDungeonDefine.GRIDMAP_RES_TYPE_ARROW))
  local x, y = self:indexToWorldPos(cellX, cellY)
  buildingTile.arrowModel:setPosition(x, y + 60)
  local action = CCSequence:createWithTwoActions(CCMoveBy:create(0.65, ccp(0, 15)), CCMoveBy:create(0.65, ccp(0, -15)))
  action = CCRepeatForever:create(action)
  buildingTile.arrowModel:runAction(action)
end

function awakeDungeonGridMapScene:dealStageChanged()
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local arr = dungeonMgr:popCurStageChanged()
  if nil == arr then
    return
  end
  for i, v in ipairs(arr) do
    local buildingTile = self:getBuildingTile(v[1], v[2])
    local groundTile = self:getGroundTile(v[1], v[2])
    local progressVal = dungeonMgr:getCurStageProgress(v[1], v[2])
    if nil ~= buildingTile and nil ~= groundTile and ed.awakeDungeonDefine.UNLOCK_PROGRESS ~= progressVal then
      if progressVal == ed.awakeDungeonDefine.MAX_PROGRESS then
        if not ed.awakeDungeonDefine.isShowIfComplete(buildingTile.config.type) then
          buildingTile.isComplete = true
          local buildingModel = buildingTile.model
          if nil ~= buildingModel then
            buildingTile.model = nil
            buildingModel:playDeathAction()
          end
          local arrowModel = buildingTile.arrowModel
          if nil ~= arrowModel then
            buildingTile.arrowModel = nil
            arrowModel:stopAllActions()
            arrowModel:removeFromParentAndCleanup(true)
          end
          if nil ~= groundTile.bottom.model then
            groundTile.bottom.model:stopAllActions()
            groundTile.bottom.model:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(18 * ed.awakeDungeonDefine.ACTION_TIME_UNIT), CCFadeOut:create(8 * ed.awakeDungeonDefine.ACTION_TIME_UNIT)))
          end
          local firstSummary = dungeonMgr:getCurStageFirstRecord(v[1], v[2])
          if nil ~= firstSummary then
            local summaryModel = self:createFirstSummary(v[1], v[2], firstSummary._user_summary)
            summaryModel.bg:runAction(CCFadeIn:create(2))
            self:setFirstSummary(v[1], v[2], {
              model = summaryModel,
              stageId = firstSummary._stage_id
            })
          end
        end
      else
        if nil == buildingTile.model then
          buildingTile.model = self:createBuildingModel(buildingTile.config)
          buildingTile.model:playShowAction()
        end
        if nil ~= groundTile.bottom.model then
          groundTile.bottom.model:stopAllActions()
          groundTile.bottom.model:setOpacity(0)
          groundTile.bottom.model:runAction(CCFadeIn:create(8 * ed.awakeDungeonDefine.ACTION_TIME_UNIT))
        end
      end
    end
  end
  self:setAllBuildingReachableDirty()
  self:checkCellPlayGuideLight()
end

function awakeDungeonGridMapScene:getHeuristic(posA, posB)
  local dx = math.abs(posA.x - posB.x)
  local dy = math.abs(posA.y - posB.y)
  return math.max(dx, dy)
end

function awakeDungeonGridMapScene:getShortestPos(search)
  local shortest = search[1]
  local removeIndex = 1
  for k, v in ipairs(search) do
    if v[2] < shortest[2] then
      shortest = v
      removeIndex = k
    end
  end
  table.remove(search, removeIndex)
  return shortest[1]
end

function awakeDungeonGridMapScene:getWalkableNeighbors(pos, filterTab)
  local neighbors = {}
  local neighborOffsetArr = ed.awakeDungeonDefine.HEXAGON_AROUND_OFFSET[1]
  local arr = neighborOffsetArr[pos.y % 2 + 1]
  for k, v in ipairs(arr) do
    local r = pos.x + v[1]
    local c = pos.y + v[2]
    local groundTile = self:getGroundTile(r, c)
    if nil == groundTile or groundTile.mask.isMask then
    else
      if c ~= filterTab[r] then
        local buildingTile = self:getBuildingTile(r, c)
        if nil ~= buildingTile and not buildingTile.isComplete then
      end
      else
        table.insert(neighbors, {x = r, y = c})
      end
    end
  end
  return neighbors
end

function awakeDungeonGridMapScene:findPath(startPos, endCell)
  local startCellX, startCellY = self:worldToCellIndex(startPos.x, startPos.y)
  local startCell = {x = startCellX, y = startCellY}
  local cellArr = self:findPathByCell(startCell, endCell)
  if nil ~= cellArr then
    local cellNum = #cellArr
    if 0 == cellNum then
    elseif 1 == cellNum then
      local firstCell = cellArr[1]
      local firstPosX, firstPosY = self:indexToWorldPos(firstCell[1], firstCell[2])
      local firstDiff = {
        firstPosX - startPos.x,
        firstPosY - startPos.y
      }
      if ed.edpLengthSQ(firstDiff) < 36 then
        table.remove(cellArr, 1)
      end
    else
      local firstCell = cellArr[1]
      local nextCell = cellArr[2]
      local firstPosX, firstPosY = self:indexToWorldPos(firstCell[1], firstCell[2])
      local nextPosX, nextPosY = self:indexToWorldPos(nextCell[1], nextCell[2])
      local firstDiff = {
        firstPosX - startPos.x,
        firstPosY - startPos.y
      }
      if ed.edpLengthSQ(firstDiff) > 36 then
        local firstDir = self:edpNormalize(firstDiff)
        local secondDir = self:edpNormalize({
          nextPosX - firstPosX,
          nextPosY - firstPosY
        })
        if ed.edpDot(firstDir, secondDir) < -0.98 then
          table.remove(cellArr, 1)
        end
      end
    end
  end
  return cellArr
end

function awakeDungeonGridMapScene:findPathByCell(startCell, endCell)
  local search = {}
  local cost = {}
  local hadSearch = {}
  local pathSave = {}
  local filterTab = {}
  filterTab[endCell.x] = endCell.y
  table.insert(search, {
    startCell,
    self:getHeuristic(startCell, endCell)
  })
  cost[self:two2One(startCell)] = 0
  if not hadSearch[startCell.x] then
    hadSearch[startCell.x] = {}
  end
  hadSearch[startCell.x][startCell.y] = true
  pathSave[self:two2One(startCell)] = self:two2One(startCell)
  while 0 < #search do
    local current = self:getShortestPos(search)
    if current.x == endCell.x and current.y == endCell.y then
      break
    end
    local neighbors = self:getWalkableNeighbors(current, filterTab)
    for k, v in ipairs(neighbors) do
      if not hadSearch[v.x] then
        hadSearch[v.x] = {}
      end
      if not hadSearch[v.x][v.y] then
        cost[self:two2One(v)] = cost[self:two2One(current)] + 1
        table.insert(search, {
          v,
          cost[self:two2One(v)] + self:getHeuristic(v, endCell)
        })
        pathSave[self:two2One(v)] = self:two2One(current)
        hadSearch[v.x][v.y] = true
      end
    end
  end
  if pathSave[self:two2One(endCell)] then
    local current = self:two2One(endCell)
    local results = {
      {
        endCell.x,
        endCell.y
      }
    }
    while current ~= self:two2One(startCell) do
      local next = pathSave[current]
      local r, c = self:one2Two(next)
      table.insert(results, 1, {r, c})
      current = next
    end
    return results
  else
    return nil
  end
end

function awakeDungeonGridMapScene:setMovePath(targetCellX, targetCellY, cellArr)
  self.movePath = {
    cellArr = cellArr,
    targetCellX = targetCellX,
    targetCellY = targetCellY,
    index = 1
  }
end

function awakeDungeonGridMapScene:toChangeScale(val)
  local winSize = ed.display.winSize
  local scalePos = ccp(winSize.width * 0.5, winSize.height * 0.5)
  local pivotPos = self.mapLayer:convertToNodeSpace(scalePos)
  local oldPos = self.mapLayer:getParent():convertToNodeSpace(scalePos)
  local curScale = self.mapLayer:getScale()
  self.mapLayer:setScale(curScale + val)
  local newPos = self.mapLayer:convertToWorldSpace(pivotPos)
  newPos = self.mapLayer:getParent():convertToNodeSpace(newPos)
  local x, y = self.mapLayer:getPosition()
  x = x - (newPos.x - oldPos.x)
  y = y - (newPos.y - oldPos.y)
  self:rebuildMapLayerLimitPos()
  self:setMapPosition(x, y)
end

function awakeDungeonGridMapScene:doFirstSummaryTouch(x, y)
  if self.isShowFirstSummary then
    for cellX, yTab in pairs(self.firstSummaryTab) do
      for cellY, v in pairs(yTab) do
        if v.model and ed.containsPoint(v.model.headIcon, x, y) then
          local dungeonMgr = ed.awakeDungeonMgr.getInstance()
          dungeonMgr:requestStageRecord(v.stageId)
          self.reqFirstSummaryCellX = cellX
          self.reqFirstSummaryCellY = cellY
          return true
        end
      end
    end
  end
  return false
end

function awakeDungeonGridMapScene:addTouchDisableMask(flag)
  if nil == self.touchDisableTab then
    self.touchDisableTab = {}
  end
  self.touchDisableTab[flag] = true
end

function awakeDungeonGridMapScene:removeTouchDisableMask(flag)
  if nil == self.touchDisableTab then
    return
  end
  self.touchDisableTab[flag] = nil
end

function awakeDungeonGridMapScene:isTouchDisableMask()
  for k, v in pairs(self.touchDisableTab) do
    return true
  end
  return false
end

function awakeDungeonGridMapScene:clearTouchEvent()
  self.isTouching = false
  self.isTouchDraging = false
end

function awakeDungeonGridMapScene:doLayerTouchEvent(event, x, y)
  if event == "began" then
    if self:isTouchDisableMask() then
      return false
    end
    local testPoint = ccp(x, y)
    for k, v in ipairs(self.swallowTouchRectArr) do
      if v.isEnable and v.rect:containsPoint(testPoint) then
        return false
      end
    end
    self.isTouching = true
    self.isTouchDraging = false
    self.startTouchPosX, self.startTouchPosY = x, y
    self.touchMapLayerPosX, self.touchMapLayerPosY = self.mapLayer:getPosition()
    self.inertiaVelocity.x, self.inertiaVelocity.y = 0, 0
    return true
  elseif event == "moved" then
    if not self.isTouching then
      return
    end
    if not self.isTouchDraging and math.abs(x - self.startTouchPosX) < self.touchSensitivity and math.abs(y - self.startTouchPosY) < self.touchSensitivity then
      return true
    end
    local curPosX, curPosY = self.mapLayer:getPosition()
    local newPosX = self.touchMapLayerPosX + x - self.startTouchPosX
    local newPosY = self.touchMapLayerPosY + y - self.startTouchPosY
    local offsetX, offsetY = self:calculateScrollOffset(newPosX - curPosX, newPosY - curPosY)
    newPosX = newPosX + offsetX
    newPosY = newPosY + offsetY
    self.mapLayer:setPosition(newPosX, newPosY)
    self:onMapPositionChanged()
    self.isTouchDraging = true
  elseif event == "ended" then
    if self.isTouching and not self.isTouchDraging then
      if self:doFirstSummaryTouch(x, y) then
        return true
      end
      local localPos = self.mapLayer:convertToNodeSpace(ccp(x, y))
      local clickFca = ed.createFcaNode("eff_UI_Main_Click")
      clickFca:setPosition(localPos)
      self.mapLayer:addChild(clickFca)
      self:addFcaOnce(clickFca)
      local targetCellX, targetCellY = self:worldToCellIndex(localPos.x, localPos.y)
      local groundTile = self:getGroundTile(targetCellX, targetCellY)
      if nil == groundTile then
        return true
      end
      local touchAction = CCSequence:createWithTwoActions(CCMoveBy:create(0.05, ccp(0, -5)), CCMoveBy:create(0.05, ccp(0, 5)))
      groundTile.model:runAction(touchAction)
      if nil ~= groundTile.mask.model then
        groundTile.mask.model:runAction(tolua.cast(touchAction:copy():autorelease(), "CCAction"))
      end
      if nil ~= groundTile.bottom.model then
        groundTile.bottom.model:runAction(tolua.cast(touchAction:copy():autorelease(), "CCAction"))
      end
      local buildingTile = self:getBuildingTile(targetCellX, targetCellY)
      if nil ~= buildingTile and not buildingTile.isComplete and buildingTile.model then
        buildingTile.model:playAction(tolua.cast(touchAction:copy():autorelease(), "CCAction"))
      end
      local curPosX, curPosY = self.actor:getPosition()
      local cellArr = self:findPath({x = curPosX, y = curPosY}, {x = targetCellX, y = targetCellY})
      if nil == cellArr then
        ed.showToast(T("\230\151\160\230\179\149\229\136\176\232\190\190"))
      else
        if nil ~= buildingTile and not buildingTile.isComplete and not ed.awakeDungeonDefine.isArriveToTrigger(buildingTile.config.type) then
          table.remove(cellArr, #cellArr)
        end
        if 0 == #cellArr then
          table.insert(cellArr, {
            self:worldToCellIndex(curPosX, curPosY)
          })
          if nil ~= buildingTile and ed.awakeDungeonDefine.isArriveToTrigger(buildingTile.config.type) then
            local dungeonMgr = ed.awakeDungeonMgr.getInstance()
            dungeonMgr:setCurPlayerCellXY(0, 0, false)
          end
        end
        self:setMovePath(targetCellX, targetCellY, cellArr)
      end
      return true
    end
    self.isTouching = false
    self.isTouchDraging = false
  end
  return false
end

function awakeDungeonGridMapScene:onTriggerCell(cellX, cellY)
  local buildingTile = self:getBuildingTile(cellX, cellY)
  if nil == buildingTile or buildingTile.isComplete then
    return
  end
  if nil ~= buildingTile.model then
    buildingTile.model:playTriggerAction()
  end
  if buildingTile.config.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_MONSTER then
    local stageTableItem = ed.getDataTable("DungeonStage")[buildingTile.config.id]
    if nil == stageTableItem then
      ed.showToast("DungeonStage \230\137\190\228\184\141\229\136\176\230\149\176\230\141\174" .. buildingTile.config.id)
      return
    end
    self:clearTouchEvent()
    local stageCategory = stageTableItem["Stage Category"]
    if stageCategory == "Boss" then
      ed.UITool.openView("awakeDungeonBossStageDetail", {
        stageId = buildingTile.config.id,
        cellX = cellX,
        cellY = cellY
      })
    elseif stageCategory == "Special" then
      ed.UITool.openView("awakeDungeonSpecialStageDetail", {
        stageId = buildingTile.config.id,
        cellX = cellX,
        cellY = cellY
      })
    else
      ed.UITool.openView("awakeDungeonStageDetail", {
        stageId = buildingTile.config.id,
        cellX = cellX,
        cellY = cellY
      })
    end
  elseif buildingTile.config.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_REWARD then
    local rewardTableItem = ed.getDataTable("DungeonTreasureReward")[buildingTile.config.id]
    if nil == rewardTableItem then
      ed.showToast("DungeonTreasureReward \230\137\190\228\184\141\229\136\176\230\149\176\230\141\174" .. buildingTile.config.id)
      return
    end
    self:clearTouchEvent()
    ed.AwakeDungeonNetwork.sendBlockRewards(cellX, cellY)
  elseif buildingTile.config.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_END then
    self:clearTouchEvent()
    local dungeonMgr = ed.awakeDungeonMgr.getInstance()
    dungeonMgr:addChapterStageProgress(self.chapterId, cellX, cellY)
    dungeonMgr:setCurStageProgress(cellX, cellY, ed.awakeDungeonDefine.MAX_PROGRESS)
    dungeonMgr:addCurStageChanged(cellX, cellY)
    FireEvent("dungeonBlockChanged")
    local nextTableItem
    local chapterTableItemArr = ed.getDataTable("DungeonChapter")[dungeonMgr:getChapterGroup()]
    for i, v in ipairs(chapterTableItemArr) do
      if v["Chapter ID"] == self.chapterId then
        nextTableItem = chapterTableItemArr[i + 1]
        break
      end
    end
    if nil ~= nextTableItem then
      dungeonMgr:setChapterUnlock(nextTableItem["Chapter ID"])
      ed.showConfirmDialog({
        text = T("\230\152\175\229\144\166\231\161\174\232\174\164\232\191\155\229\133\165\228\184\139\228\184\128\231\171\160\232\138\130\239\188\159"),
        rightText = T("\231\161\174\229\174\154"),
        rightHandler = function()
          self.reqChapterId = nextTableItem["Chapter ID"]
          ed.AwakeDungeonNetwork.sendEnterChapter(self.reqChapterId)
        end
      })
    end
  elseif buildingTile.config.type == ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_PORTAL then
    self:clearTouchEvent()
    local dungeonMgr = ed.awakeDungeonMgr.getInstance()
    dungeonMgr:setCurStageProgress(cellX, cellY, ed.awakeDungeonDefine.MAX_PROGRESS)
    dungeonMgr:addCurStageChanged(cellX, cellY)
    FireEvent("dungeonBlockChanged")
    local arr = self:getBuildingTileArrByType(ed.awakeDungeonDefine.GRIDMAP_BUILDING_TYPE_PORTAL)
    if nil ~= arr then
      for _, tile in ipairs(arr) do
        if tile.config.id == buildingTile.config.id and (tile.config.x ~= cellX or tile.config.y ~= cellY) then
          self.movePath = nil
          self:addTouchDisableMask("portal")
          self:listenTimer(Timer:Once(0.3), function()
            self:removeTouchDisableMask("portal")
            local dungeonMgr = ed.awakeDungeonMgr.getInstance()
            dungeonMgr:setCurPlayerCellXY(tile.config.x, tile.config.y, false)
            local posX, posY = self:indexToWorldPos(tile.config.x, tile.config.y)
            self.actor:setPosition(posX, posY)
            self:makePositionCenter(posX, posY)
            self:toUnlockAroundTile(tile.config.x, tile.config.y)
          end)
          return
        end
      end
    end
    ed.showToast("\233\133\141\231\189\174\229\188\130\229\184\184\239\188\140\230\178\161\230\156\137\230\137\190\229\136\176\229\175\185\229\186\148\231\154\132\228\188\160\233\128\129\233\151\168")
  end
end

function awakeDungeonGridMapScene:calcuInertiaEffect(axis, dt, offset, curVal)
  local val = curVal
  local velocity = self.inertiaVelocity[axis]
  if 0 ~= offset then
    local smoothTime = 0.1
    val, velocity = ed.smoothDamp(curVal, curVal + offset, velocity, smoothTime, nil, dt)
    if math.abs(velocity) < 1 then
      velocity = 0
    end
    self.inertiaVelocity[axis] = velocity
  else
    local decelerationRate = 0.135
    velocity = velocity * math.pow(decelerationRate, dt)
    if math.abs(velocity) < 1 then
      velocity = 0
    end
    val = val + velocity * dt
    self.inertiaVelocity[axis] = velocity
  end
  return val
end

function awakeDungeonGridMapScene:calculateScrollRubber(overStretching, viewSize)
  return (1 - 1 / (math.abs(overStretching) * 0.55 / viewSize + 1)) * viewSize * (0 <= overStretching and 1 or -1)
end

function awakeDungeonGridMapScene:calculateScrollOffset(deltaX, deltaY)
  local offsetX, offsetY = 0, 0
  local curX, curY = self.mapLayer:getPosition()
  local minOffsetX = self.mapLayerLimitPos.minX - (curX + deltaX)
  local maxOffsetX = self.mapLayerLimitPos.maxX - (curX + deltaX)
  if 0.01 < minOffsetX then
    offsetX = minOffsetX
  elseif maxOffsetX < -0.01 then
    offsetX = maxOffsetX
  end
  local minOffsetY = self.mapLayerLimitPos.minY - (curY + deltaY)
  local maxOffsetY = self.mapLayerLimitPos.maxY - (curY + deltaY)
  if 0.01 < minOffsetY then
    offsetY = minOffsetY
  elseif maxOffsetY < -0.01 then
    offsetY = maxOffsetY
  end
  return offsetX, offsetY
end

function awakeDungeonGridMapScene:onMapScrollUpdate(dt)
  local curPosX, curPosY = self.mapLayer:getPosition()
  if not self.isTouching then
    local offsetX, offsetY = self:calculateScrollOffset(0, 0)
    if 0 ~= offsetX or 0 ~= offsetY or 0 ~= self.inertiaVelocity.x or 0 ~= self.inertiaVelocity.y then
      local x = self:calcuInertiaEffect("x", dt, offsetX, curPosX)
      local y = self:calcuInertiaEffect("y", dt, offsetY, curPosY)
      self.mapLayer:setPosition(x, y)
      self:onMapPositionChanged()
    end
  end
  if self.isTouchDraging then
    local newVelocityX = (curPosX - self.prevMapLayerPosition.x) / dt
    local newVelocityY = (curPosY - self.prevMapLayerPosition.y) / dt
    local t = math.min(dt * 10, 1)
    self.inertiaVelocity.x = self.inertiaVelocity.x + (newVelocityX - self.inertiaVelocity.x) * t
    self.inertiaVelocity.y = self.inertiaVelocity.y + (newVelocityY - self.inertiaVelocity.y) * t
  end
end
