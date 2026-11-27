local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.awakeDungeonSpecialStageDetail = class
ed.UITool.registViewOpenFunc("awakeDungeonSpecialStageDetail", function(param)
  local panel = class.create(param)
  panel:popWindow()
end)

function class.create(param)
  local self = base.create("awakeDungeonSpecialStageDetail")
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  self.param = param or {}
  self.stageId = param.stageId
  self.cellX = param.cellX
  self.cellY = param.cellY
  self.stageName = ""
  self.enemyDetailPanel = nil
  self.enemyInfoList = {}
  self.conditionList = {}
  self.stageDesc = ""
  self.rewardItemList = {}
  self.efficiencyList = {}
  self.freeHeroList = nil
  self.dungeonMgr = ed.awakeDungeonMgr.getInstance()
  self.dungeonMgr:requestStageRecord(self.stageId)
  ed.AwakeDungeonNetwork:sendPrepareBattle(self.stageId, self.cellX, self.cellY)
  self:initView()
  self:refreshView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonSpecialStageDetail)
  self.ui = ui
  self.container:addChild(container)
  ed.setLabelStroke(self.ui.stage_name, ed.toccc3(8008718), 1.5)
  self.ui.stage_name:setFontName(ed.fontBold)
  ed.adaptLabel(self.ui.enemy_title, {maxWidth = 100, minScale = 0.7})
  ed.adaptLabel(self.ui.reset_label, {maxWidth = 85, minScale = 0.7})
  ed.adaptLabel(self.ui.efficiency_title, {maxWidth = 85, minScale = 0.7})
  local children = self.ui.panel_content:getChildren()
  local arr = {}
  for i = 0, children:count() - 1 do
    local child = children:objectAtIndex(i)
    table.insert(arr, child)
  end
  self.ui.panel_content:removeAllChildrenWithCleanup(false)
  self.contentDraglist = ed.UITool.createDraglist(self.ui.panel_content, {})
  for i, v in ipairs(arr) do
    self.contentDraglist:addItem(v)
  end
end

function class:refreshView()
  self:refreshBasic()
  self:refreshEnemy()
  self:refreshCondition()
  self:refreshStageRecord()
  self:refreshBuff()
end

function class:refreshBasic()
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local stageName = stageTableItem["Stage Name"]
  local stageDesc = stageTableItem["Buff Description"]
  self.stageName = stageName
  self.stageDesc = stageDesc
  ed.setLabelString(self.ui.stage_name, stageName)
  local titlePosX, titlePosY = self.ui.stage_desc:getPosition()
  local titleSize = self.ui.stage_desc:getContentSize()
  local desLabel = ed.ui.autoText.new()
  desLabel:initParam({
    context = stageDesc,
    fontSize = 15,
    color = ccc3(255, 252, 231),
    lineSpacing = 4,
    maxWidth = 260,
    isTripLastSpacing = true
  })
  self.ui.image_bg:addChild(desLabel.node)
  local desWidth, desHeight = desLabel:getCurContentSize()
  local desPosY = titlePosY + desHeight * 0.5 - desLabel:getFirstLineHeight() * 0.5
  desLabel.node:setPosition(titlePosX + titleSize.width + 2, desPosY)
  self.ui.stage_desc:setPosition(titlePosX, desPosY)
end

function class:getEnemyPressInHandler()
  local function handler(x, y)
    if not ed.containsPoint(self.ui.enemy_panel, x, y) then
      return
    end
    for index, bg in pairs(self.enemyDraglist.listItems or {}) do
      if ed.containsPoint(bg, x, y) then
        local enemyInfo = self.enemyInfoList[index]
        local panel = ed.readequip.getDetailCard(enemyInfo.id, {
          level = enemyInfo.level,
          rank = enemyInfo.rank,
          isBoss = enemyInfo.isBoss,
          isUnit = true
        })
        local x, y = bg:getPosition()
        local size = bg:getContentSize()
        self.ui.image_bg:addChild(panel, 999)
        local toastPos = bg:getParent():convertToWorldSpace(ccp(x, y + size.height))
        toastPos = self.ui.image_bg:convertToNodeSpace(toastPos)
        panel:setPosition(toastPos)
        self.enemyDetailPanel = panel
        return bg
      end
    end
  end
  
  return handler
end

function class:getEnemyCancelPressInHandler()
  local function handler(x, y, bg)
    if self.enemyDetailPanel then
      self.enemyDetailPanel:removeFromParentAndCleanup(true)
      
      self.enemyDetailPanel = nil
    end
  end
  
  return handler
end

function class:refreshEnemy()
  if nil == self.enemyDraglist then
    self.enemyDraglist = ed.UITool.createDraglist(self.ui.enemy_panel, {
      doPressIn = self:getEnemyPressInHandler(),
      cancelPressIn = self:getEnemyCancelPressInHandler()
    })
  else
    self.enemyDraglist:clearList()
  end
  if self.enemyDetailPanel then
    self.enemyDetailPanel:removeFromParentAndCleanup(true)
    self.enemyDetailPanel = nil
  end
  self.enemyInfoList = self:getEnemyInfo(self.stageId)
  local posX = 0
  local spaceX = 10
  local posY = self.ui.enemy_panel:getContentSize().height * 0.5
  for index, enemyInfo in ipairs(self.enemyInfoList) do
    local enemyLevel = enemyInfo.level
    local rank = enemyInfo.rank
    local stars = enemyInfo.stars
    local isBoss = enemyInfo.isBoss
    local unit = ed.readhero.createIcon({
      id = enemyInfo.id,
      rank = rank,
      stars = stars,
      level = enemyLevel
    })
    local bg = unit.icon
    bg:setFlipX(true)
    local length = 65
    if isBoss then
      length = 75
    end
    bg:setPosition(posX + length * 0.5, posY)
    posX = posX + length + spaceX
    self.enemyDraglist:addItem(bg)
    local eScale = length / bg:getContentSize().width
    bg:setScale(eScale - 0.1)
    if isBoss then
      posX = posX + 15
    end
    if isBoss then
      local tag = ed.createSprite("UI/alpha/1080P/campaign/campaign_detail_boss.png")
      tag:setPosition(ccp(60, 65))
      bg:addChild(tag, 10)
    end
  end
  self.enemyDraglist:initListWidth(posX - spaceX + 2)
end

function class:getEnemyInfo(stageId)
  local result = {}
  local bossIndex = 0
  local arr = ed.getDataTable("DungeonBattle")[stageId]
  for _, battleTableItem in ipairs(arr) do
    local bossPos = battleTableItem["Boss Position"]
    for index = 1, 10 do
      local monsterId = battleTableItem[string.format("Monster %d ID", index)]
      if not monsterId or monsterId == 0 then
        break
      end
      local enemyInfo = {
        id = monsterId,
        isBoss = false,
        index = index,
        stars = battleTableItem[string.format("Stars %s", index)],
        level = battleTableItem[string.format("Level %s", index)],
        res = ed.getUnitPortrait(monsterId)
      }
      enemyInfo.rank = ed.heroLevel2Rank(enemyInfo.level)
      table.insert(result, enemyInfo)
      if bossPos == index then
        bossIndex = #result
      end
    end
  end
  if 0 < bossIndex then
    local bossItem = result[bossIndex]
    table.remove(result, bossIndex)
    bossItem.isBoss = true
    table.insert(result, 1, bossItem)
  end
  return result
end

function class:getConditionItemPos(i)
  local ox = 10
  local oy = self.ui.condition_title:getPositionY() - self.ui.condition_title:getContentSize().height * 0.5 - 10
  local itemHeight = 21.5
  local itemSpace = 6
  local dy = oy - i * (itemHeight + itemSpace) + itemSpace
  return ccp(ox, dy)
end

function class:getConditionHeight(num)
  local size = self.ui.panel_content:getContentSize()
  local oy = self.ui.condition_title:getPositionY() - self.ui.condition_title:getContentSize().height * 0.5 - 10
  local topHeight = size.height - oy
  local itemHeight = 21.5
  local itemSpace = 6
  return (itemHeight + itemSpace) * num - itemSpace + topHeight
end

function class:createConditionItem(data)
  local container, ui = CCLayer:create(), {}
  local bgImg = ed.createSprite("UI/alpha/1080P/dungeon/stageinfo/list_bg.png")
  container:addChild(bgImg)
  local posX = 7
  local bgSize = bgImg:getContentSize()
  bgImg:setPosition(bgSize.width * 0.5, bgSize.height * 0.5)
  local iconImg = ed.createSprite("UI/alpha/1080P/dungeon/stageinfo/list_icon.png")
  iconImg:setAnchorPoint(ccp(0, 0.5))
  bgImg:addChild(iconImg)
  iconImg:setPosition(posX, bgSize.height * 0.5)
  posX = posX + iconImg:getContentSize().width + 5
  local desLabel = ed.createttf(data.str, 15)
  bgImg:addChild(desLabel)
  ed.setLabelColor(desLabel, ccc3(255, 252, 231))
  desLabel:setAnchorPoint(ccp(0, 0.5))
  desLabel:setPosition(posX, bgSize.height * 0.5)
  return container, ui
end

function class:refreshCondition()
  self.conditionList = {}
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local conditionTable = ed.getDataTable("BattleSpecialCondition")
  for i, v in ipairs(stageTableItem["Condition Group"]) do
    local conditionTableItem = conditionTable[v]
    if nil ~= conditionTableItem then
      local des = string.gsub(conditionTableItem.Description, "%%(.-)%%", function(content)
        local splitPos = string.find(content, "&")
        if nil == splitPos then
          return "unknown"
        else
          local index = tonumber(string.sub(content, 1, splitPos - 1))
          local type = string.sub(content, splitPos + 1)
          if type == "unit" then
            local id = conditionTableItem["Condition Param"][index]
            return ed.lookupDataTable("Unit", "Display Name", id)
          elseif index then
            return conditionTableItem["Condition Param"][index]
          else
            return "unknown"
          end
        end
      end)
      table.insert(self.conditionList, {str = des})
    end
  end
  table.sort(self.conditionList, function(a, b)
    return #a.str < #b.str
  end)
  for i, v in ipairs(self.conditionList) do
    local container, ui = self:createConditionItem(v)
    self.contentDraglist:addItem(container)
    container:setPosition(self:getConditionItemPos(i))
  end
  self.contentDraglist:initListHeight(self:getConditionHeight(#self.conditionList))
end

function class:onChallengeStage()
  local isOpen, reason = self.dungeonMgr:awakeDungeonIsOpen()
  if not isOpen then
    ed.showToast(reason)
    return
  end
  if nil == self.freeHeroList then
    ed.AwakeDungeonNetwork:sendPrepareBattle(self.stageId, self.cellX, self.cellY)
    return
  end
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local chapterId = stageTableItem["Chapter ID"]
  local battleData = {
    type = "Special",
    titleName = self.stageName,
    conditions = self.conditionList,
    detail = self.stageDesc,
    cellX = self.cellX,
    cellY = self.cellY,
    chapterId = chapterId
  }
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "AwakeStage",
    stage_id = self.stageId,
    heroLimit = {},
    freeHeroList = self.freeHeroList,
    objData = battleData
  }))
  self:destroy({skipAnim = true})
end

function class:onClickFirstDetail()
  local awakeDungeonFirstBloodWin = ed.ui.awakeDungeonFirstBloodWin.create({
    stageId = self.stageId
  })
  awakeDungeonFirstBloodWin:popWindow()
  ed.layout.relateLayout(self.ui.image_first_blood, awakeDungeonFirstBloodWin.ui.image_bg, {bottom = 63})
end

function class:onClickBuffDetail()
  local awakeDungeonStageCfg = ed.getDataTable("DungeonStage")[self.stageId]
  if not awakeDungeonStageCfg then
    return
  end
  local chapterId = awakeDungeonStageCfg["Chapter ID"]
  local awakeDungeonBuffDetailWin = ed.ui.awakeDungeonBuffDetailWin.create({chapterId = chapterId})
  awakeDungeonBuffDetailWin:popWindow()
  ed.layout.relateLayout(self.ui.image_buff_bg, awakeDungeonBuffDetailWin.ui.image_bg, {top = 180})
end

function class:refreshStageRecord()
  local stageRecord = self.dungeonMgr:getStageRecord(self.stageId)
  if not stageRecord then
    self.ui.none_first_blood:setVisible(true)
    self.ui.image_first_blood:setVisible(false)
    return
  end
  self.ui.none_first_blood:setVisible(false)
  self.ui.image_first_blood:setVisible(true)
  local user_summary = stageRecord.userSummary
  local param = {
    id = user_summary._avatar,
    scale = 0.42
  }
  local head = ed.getWholeHeadIcon(param)
  self.ui.panel_head:addChild(head)
  ed.layout.centerInParent(head)
  local name = ed.getPlayerName(user_summary._name, user_summary._medal, {
    anchorPoint = ccp(0, 0.5),
    medalScale = 0.13,
    fontSize = 14
  })
  self.ui.panel_name:removeAllChildrenWithCleanup(true)
  self.ui.panel_name:addChild(name)
  name:setPosition(ccp(2, 12))
  ed.setLabelString(self.ui.label_guild, user_summary._guild_name or "")
end

function class:refreshBuff()
  local buffInfo = self.dungeonMgr:getBuffInfoByStageId(self.stageId)
  if not buffInfo then
    self.ui.image_buff_bg:setVisible(false)
    return
  end
  self.ui.image_buff_bg:setVisible(true)
  ed.setLabelString(self.ui.label_buff, ed.awakeDungeonDefine.getBuffDes(buffInfo.shortDesc))
  ed.adaptLabel(self.ui.label_buff, {maxWidth = 120, minScale = 0.6})
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_close", function()
    self:destroy({skipAnim = true})
  end, {pressScale = 0.95, clickInterval = 0.2})
  self:btRegisterOutClick({
    area = self.ui.image_bg,
    key = "out_click",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "challenge_button", function()
    self:onChallengeStage()
  end, {pressScale = 0.98, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "btn_first_blood_detail", function()
    self:onClickFirstDetail()
  end, {pressScale = 0.98, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "image_buff_bg", function()
    self:onClickBuffDetail()
  end, {pressScale = 0.98, clickInterval = 0.2})
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.UITool.openView("awakeDungeonSpecialStageInfo", {
      stageId = self.stageId
    })
  end, {pressScale = 0.98, clickInterval = 0.2})
end

function class:addEventListener()
  self:listenEvent("awakeDungeonStageRecord", function(stageId)
    if stageId == self.stageId then
      self:refreshStageRecord()
    end
  end)
  self:listenEvent("awakeDungeonPrepareBattle", function(data)
    self.freeHeroList = {}
    if nil ~= data._heroes then
      for i, v in ipairs(data._heroes) do
        table.insert(self.freeHeroList, v)
      end
    end
  end)
end
