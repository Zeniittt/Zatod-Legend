local base = ed.ui.popwindow
local awakeDungeonLevelUp = newclass(base.mt)
ed.ui.awakeDungeonLevelUp = awakeDungeonLevelUp
local res = ed.heroDetailManager.resConfig
ed.UITool.registViewOpenFunc("awakeDungeonLevelUp", function(param)
  awakeDungeonLevelUp.create(param):popWindow()
end)

function awakeDungeonLevelUp:initData(param)
  param = param or {}
  self.oldLevel = param.oldLevel or 0
  self.newLevel = param.newLevel or 0
end

function awakeDungeonLevelUp:initLabels()
end

function awakeDungeonLevelUp:createMainAction()
  self.ui.bg:setAnchorPoint(ccp(0.5, 1))
  self.ui.bg:setOpacity(0)
  local fca = ed.createFcaNode("eff_UI_Dungeon_Wings")
  self.container:addChild(fca)
  ed.layout.centerInScreen(fca)
  self:addFca(fca)
  local delay = CCDelayTime:create(1)
  local fadeIn = CCFadeIn:create(0.2)
  local moveBy1 = CCEaseExponentialInOut:create(CCMoveBy:create(0.18, ccp(0, -50)))
  local moveBy2 = CCEaseExponentialIn:create(CCMoveBy:create(0.02, ccp(0, 5)))
  local moveBy = CCSequence:createWithTwoActions(moveBy1, moveBy2)
  local action = CCSequence:createWithTwoActions(delay, CCSpawn:create(ccArrayMake(fadeIn, moveBy)))
  fca:runAction(CCSequence:createWithTwoActions(delay, CCMoveBy:create(0.02, ccp(0, 30))))
  self.ui.bg:runAction(action)
  local levelUpImg = ed.createSprite("UI/alpha/1080P/dungeon/dungeon_level_up.png")
  local nodeImg = CCSprite:create()
  nodeImg:addChild(levelUpImg)
  fca:addNodeToComponent(nodeImg, "Node", 0, CCAffineTransformMake(1, 0, 0, 1, 0, 0), true, true)
end

function awakeDungeonLevelUp:refreshDraglist()
  local size = self.ui.layer_item:getContentSize()
  
  local function getPos(i)
    return ccp(size.width / 2, size.height - 36 * i + 16)
  end
  
  local index = 1
  local ui = self:createAttrTitle(self.oldLevel, self.newLevel)
  self:addAttrItem(ui, getPos(index))
  index = index + 1
  local content = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(41,27,27) strokeSize=1>\230\137\128\230\156\137\232\139\177\233\155\132\231\167\145\230\138\128\231\173\137\231\186\167</lable>") .. T("<lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>+1\231\186\167</lable>")
  local attr = self:createAttr(content)
  self:addAttrItem(attr, getPos(index))
  local changeEnergy, maxEnergy = self:getEnergyLevelUp(self.newLevel)
  if changeEnergy and maxEnergy then
    index = index + 1
    local content = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(41,27,27) strokeSize=1>\232\131\189\233\135\143\228\184\138\233\153\144\230\143\144\229\141\135%s\231\130\185\239\188\136\232\131\189\233\135\143\228\184\138\233\153\144%s\239\188\137</lable>", changeEnergy, maxEnergy)
    local attr = self:createAttr(content)
    self:addAttrItem(attr, getPos(index))
  end
  local awakeHeroExtAttrList = self:getAwakeHeroExtraAttr(self.newLevel)
  for _, awakeHeroExtAttrCfg in ipairs(awakeHeroExtAttrList) do
    index = index + 1
    local content = string.format("<lable color=ccc3(255,252,231) size=16 strokeColor=ccc3(15,30,17) strokeSize=1>%s</lable>", awakeHeroExtAttrCfg.heroName)
    for _, attrCfg in ipairs(awakeHeroExtAttrCfg.extAttrList or {}) do
      local attrAutoText = string.format("<lable color=ccc3(255,252,231) size=16 strokeColor=ccc3(15,30,17) strokeSize=1>%s</lable>", res.att_cn_name[attrCfg.attrName]) .. string.format("<lable color=ccc3(255,182,56) size=16 strokeColor=ccc3(15,30,17) strokeSize=1>+%s </lable>", attrCfg.attrNum)
      content = content .. attrAutoText
    end
    local attr = self:createAttr(content)
    self:addAttrItem(attr, getPos(index))
  end
  local height = 36 * index
  self.draglist:initListHeight(36 * index)
  local bgSize = self.ui.bg:getContentSize()
  if height < size.height then
    self.ui.layer_item:setPositionY(self.ui.layer_item:getPositionY() - (size.height - height))
    self.ui.bg:setContentSize(CCSizeMake(bgSize.width, bgSize.height - (size.height - height)))
  end
end

function awakeDungeonLevelUp:addAttrItem(attrItem, pos)
  attrItem:setOpacity(0)
  attrItem:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.4), CCFadeIn:create(0.2)))
  self.draglist:addItem(attrItem)
  attrItem:setPosition(pos)
end

function awakeDungeonLevelUp:initUI()
  ed.editorui(ed.uieditor.awakeDungeonLevelUp, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {})
  self:refreshDraglist()
  self:createMainAction()
end

function awakeDungeonLevelUp:createAttrTitle(oldLevel, newLevel)
  local bg = ed.createSprite("UI/alpha/1080P/dungeon/dungeon_frame_1.png")
  local title = ed.ui.autoText.new()
  local content = "<lable color=ccc3(250,217,160) strokeColor=ccc3(97,47,26) strokeSize=1>" .. T("\231\167\145\230\138\128\231\173\137\231\186\167 %s\231\186\167", oldLevel) .. "</lable><sprite src=UI/alpha/1080P/hero/hero_upgrade_arrow.png scale=0.4><lable color=ccc3(112,255,84) strokeColor=ccc3(23,49,31) strokeSize=1>" .. T("%s\231\186\167", newLevel) .. "</lable>"
  title:initParam({context = content})
  bg:addChild(title.node)
  ed.layout.centerYInParent(title.node)
  title.node:setCascadeOpacityEnabled(true)
  local w, h = title:getCurContentSize()
  title.node:setPositionX(bg:getContentSize().width / 2 - w / 2)
  bg:setCascadeOpacityEnabled(true)
  return bg
end

function awakeDungeonLevelUp:createAttr(autoTextLabel)
  local bg = ed.createSprite("UI/alpha/1080P/dungeon/dungeon_frame_2.png")
  local dot = ed.createSprite("UI/alpha/1080P/dungeon/dungeon_main_point.png")
  local attr = ed.ui.autoText.new()
  attr:initParam({context = autoTextLabel})
  bg:addChild(dot)
  dot:setPosition(ccp(18, 18))
  bg:addChild(attr.node)
  attr.node:setCascadeOpacityEnabled(true)
  ed.layout.centerYInParent(attr.node)
  attr.node:setPositionX(30)
  bg:setCascadeOpacityEnabled(true)
  return bg
end

function awakeDungeonLevelUp:getUnlockChapter(level)
  local chapterGroup = ed.awakeDungeonMgr:getInstance():getChapterGroup()
  local unlockChapterList = {}
  for chapterId, chapterCfg in pairs(ed.getDataTable("DungeonChapter")[chapterGroup] or {}) do
    if level == chapterCfg["Unlock Paragon Level"] then
      table.insert(unlockChapterList, {
        chapterId = chapterId,
        chapterName = chapterCfg["Chapter Name"] or ""
      })
    end
  end
  return unlockChapterList
end

function awakeDungeonLevelUp:getEnergyLevelUp(level)
  local preLevel = level - 1
  if preLevel <= 0 then
    return
  end
  local levelGroup = ed.awakeDungeonMgr.getInstance():getLevelGroup()
  local preMaxVitality = ed.getDataTable("ParagonLevel")[levelGroup][preLevel]["Max Vitality"]
  local maxVitality = ed.getDataTable("ParagonLevel")[levelGroup][level]["Max Vitality"]
  local changeVitality = maxVitality - preMaxVitality
  if 0 < changeVitality then
    return changeVitality, maxVitality
  end
end

function awakeDungeonLevelUp:getBossStageUnlock(level)
  local unlockBossStageList = {}
  local dungeonStageTB = ed.getDataTable("DungeonStage")
  local startStageId, endStageId = ed.awakeDungeonMgr:getInstance():getStageIdRange()
  for bossGroup, difficultyCfg in ipairs(ed.getDataTable("DungeonBoss")) do
    for difficulty, bossCfg in ipairs(difficultyCfg) do
      local stageId = bossCfg["Stage ID"]
      if startStageId <= stageId and stageId <= endStageId + 3 then
        local unlockLevel = dungeonStageTB[stageId]["Unlock Paragon Level"]
        if unlockLevel == level then
          table.insert(unlockBossStageList, {
            bossName = bossCfg["Boss Name"],
            difficulty = difficulty
          })
        end
      end
    end
  end
  return unlockBossStageList
end

function awakeDungeonLevelUp:getAwakeHeroExtraAttr(level)
  local extAttrInfo = {}
  local levelGroup = ed.awakeDungeonMgr.getInstance():getLevelGroup()
  local extAttrIdList = ed.getDataTable("ParagonLevel")[levelGroup][level].ExtraAttributes
  if extAttrIdList and 0 < #extAttrIdList then
    local extAttrTB = ed.getDataTable("ExtraAttributes")
    for _, extAttrId in ipairs(extAttrIdList) do
      local extAttrCfg = extAttrTB[extAttrId]
      local heroName = ed.getDataTable("Unit")[extAttrCfg.UnitID]["Display Name"]
      local extAttrList = {}
      for attrName, attrNum in pairs(extAttrCfg) do
        if attrName ~= "ID" and attrName ~= "UnitID" and 0 < attrNum then
          table.insert(extAttrList, {attrName = attrName, attrNum = attrNum})
        end
      end
      table.insert(extAttrInfo, {heroName = heroName, extAttrList = extAttrList})
    end
  end
  return extAttrInfo
end

function awakeDungeonLevelUp:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function awakeDungeonLevelUp:registerEvents()
end

function awakeDungeonLevelUp.create(param)
  local self = base.create("awakeDungeonLevelUp")
  setmetatable(self, awakeDungeonLevelUp.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  ed.playEffect(ed.sound.deo.dungeon_level_up)
  return self
end
