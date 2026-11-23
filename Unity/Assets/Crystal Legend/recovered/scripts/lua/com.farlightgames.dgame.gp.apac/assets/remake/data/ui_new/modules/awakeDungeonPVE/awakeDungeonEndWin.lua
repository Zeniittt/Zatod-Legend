local base = ed.ui.popwindow
local awakeDungeonEndWin = newclass(base.mt)
ed.ui.awakeDungeonEndWin = awakeDungeonEndWin

function awakeDungeonEndWin.create(params)
  local self = base.create("awakeDungeonEndWin")
  setmetatable(self, awakeDungeonEndWin.mt)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function awakeDungeonEndWin:initData(params)
  self.mgr = ed.awakeDungeonMgr.getInstance()
  self.stageId = params.stageId
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local difficulty = stageTableItem["Boss Difficulty"]
  local baseProgressVal = (difficulty - 1) * ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS
  self.oldProgress = math.floor(ed.clamp((params.oldProgress or 0) - baseProgressVal, 0, ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS) / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100)
  self.bestProgress = math.floor(ed.clamp((params.maxProgress or 0) - baseProgressVal, 0, ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS) / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100)
  self.curStageProgress = math.floor(ed.clamp((params.curProgress or 0) - baseProgressVal, 0, ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS) / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100)
  local bossGroup = stageTableItem["Boss Group"]
  local bossTableItem = ed.getDataTable("DungeonBoss")[bossGroup][difficulty]
  local nextRewardTableItem = self.mgr:getNextBossRewardItem(stageTableItem["Boss Reward ID"], params.maxProgress or 0)
  if nil ~= nextRewardTableItem then
    self.nextRewardProgress = math.floor(ed.clamp(nextRewardTableItem["Reward HP"] - baseProgressVal, 0, ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS) / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100)
  else
    self.nextRewardProgress = nil
  end
  self.progressReward = params.progressReward
  self.rewards = params.rewards or {}
end

function awakeDungeonEndWin:initLabels()
  ed.setLabelShadow(self.ui.label_back, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.label_reward, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.curtime1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.curtime2, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.historytime1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.historytime2, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.nextreward1, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.nextreward2, ccc3(0, 0, 0), 1)
  self.ui.curtime2:setFontName(ed.fontBold)
  self.ui.historytime2:setFontName(ed.fontBold)
  self.ui.nextreward2:setFontName(ed.fontBold)
  ed.setLabelShadow(self.ui.best_in_self, ccc3(0, 0, 0), ccp(0, 1))
  ed.setLabelStroke(self.ui.best_in_self, ed.toccc3(1727272), 1)
end

function awakeDungeonEndWin:initUI()
  ed.editorui(ed.uieditor.awakeStageBattleEndWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_reward, {
    doClickIn = self:doClickInLoot(),
    cancelClickIn = self:cancelClickInLoot(),
    doPressIn = self:doPressInLoot()
  })
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local difficulty = stageTableItem["Boss Difficulty"]
  local bossGroup = stageTableItem["Boss Group"]
  ed.setString(self.ui.curtime2, self.curStageProgress .. "%")
  local bossTableItem = ed.getDataTable("DungeonBoss")[bossGroup][difficulty]
  if self.nextRewardProgress == nil then
    if self.curStageProgress > self.oldProgress then
      self.ui.best_in_self:setVisible(true)
      local bossName = bossTableItem["Boss Name"]
      local tipLabel = ed.createttf(string.format(T("\229\183\178\232\142\183\229\143\150%s(%s)\231\154\132\229\133\168\233\131\168\232\191\155\229\186\166\229\165\150\229\138\177\239\188\129"), bossName, ed.awakeDungeonDefine.DIFFICULTY_TO_TEXT[difficulty]), 18)
      tipLabel:setPosition(ccp(480, 200))
      tipLabel:setColor(ed.toccc3(16776423))
      ed.setLabelStroke(tipLabel, ed.toccc3(1578259), 1)
      self.ui.bg:addChild(tipLabel)
    else
      self.ui.curtime1:setPositionY(267)
      self.ui.curtime2:setPositionY(267)
    end
  elseif self.curStageProgress >= self.bestProgress then
    self.ui.best_in_self:setVisible(true)
    self.ui.nextreward1:setVisible(true)
    self.ui.nextreward2:setVisible(true)
    ed.setString(self.ui.nextreward2, self.nextRewardProgress .. "%")
    self.ui.nextreward1:setPosition(ccp(self.ui.historytime1:getPosition()))
    self.ui.nextreward2:setPosition(ccp(self.ui.historytime2:getPosition()))
  else
    self.ui.nextreward1:setVisible(true)
    self.ui.nextreward2:setVisible(true)
    ed.setString(self.ui.nextreward2, self.nextRewardProgress .. "%")
    self.ui.historytime1:setVisible(true)
    self.ui.historytime2:setVisible(true)
    ed.setString(self.ui.historytime2, self.bestProgress .. "%")
  end
  self:refreshDraglist()
  self:playLightAnim()
end

function awakeDungeonEndWin:playLightAnim()
  local node = ed.createFcaNode("eff_UI_pvp_light")
  self:addFca(node)
  local x, y = self.ui.light:getPosition()
  node:setPosition(ccp(x, y - 55))
  self.ui.light:setVisible(false)
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pve_victory_wings")
  self:addFca(node)
  node:setPosition(ccp(x, y + 13))
  self.ui.bg:addChild(node)
  local node = ed.createFcaNode("eff_UI_pvp_newrecord_particles")
  self:addFca(node)
  node:setPosition(ccp(x, y + 13))
  self.ui.bg:addChild(node)
end

function awakeDungeonEndWin:refreshDraglist()
  self.draglist:clearList()
  self.lootui = {}
  local width = 0
  for i, v in ipairs(self.progressReward or {}) do
    local icon = ed.createItemIcon({
      type = v._type,
      id = v._id,
      amount = v._amount
    })
    icon:setAnchorPoint(ccp(0, 0))
    icon:setScale(0.88)
    icon:setPosition(ccp(width, 0))
    local process = ed.createScale9Sprite("UI/alpha/1080P/dungeon/dungeon_reward_first.png", CCRectMake(25.5, 15, 25.5, 15))
    local labelProcess = ed.createttf(T("\232\191\155\229\186\166\229\165\150\229\138\177"), 16)
    ed.setLabelColor(labelProcess, ed.toccc3(16776919))
    process:addChild(labelProcess)
    labelProcess:limitWidthByScale(72)
    local labelSize = labelProcess:getContentSize()
    process:setContentSize(CCSizeMake(labelSize.width * labelProcess:getScaleX() + 35, 46))
    ed.layout.centerInParent(labelProcess)
    icon:addChild(process)
    process:setPosition(ccp(46, 80))
    self.draglist:addItem(icon)
    table.insert(self.lootui, {
      icon = icon,
      id = v._id,
      type = v._type
    })
    width = width + ed.layout.getScaleSize(icon).width
  end
  for i, v in ipairs(self.rewards or {}) do
    local icon = ed.createItemIcon({
      type = v._type,
      id = v._id,
      amount = v._amount
    })
    icon:setAnchorPoint(ccp(0, 0))
    icon:setScale(0.88)
    icon:setPosition(ccp(width, 0))
    self.draglist:addItem(icon)
    table.insert(self.lootui, {
      icon = icon,
      id = v._id,
      type = v._type
    })
    width = width + ed.layout.getScaleSize(icon).width
  end
  self.ui.label_reward:setVisible(0 < width)
  self.draglist:initListWidth(width)
end

function awakeDungeonEndWin:doClickInLoot()
  local function handler(x, y, id)
    ed.ui.packageDetailWin.create(self.lootui[id]):popWindow()
  end
  
  return handler
end

function awakeDungeonEndWin:cancelClickInLoot()
  local function handler(x, y, id)
  end
  
  return handler
end

function awakeDungeonEndWin:doPressInLoot()
  local function handler(x, y)
    for i = 1, #self.lootui do
      local loot = self.lootui[i]
      
      if ed.containsPoint(loot.icon, x, y) then
        return i
      end
    end
  end
  
  return handler
end

function awakeDungeonEndWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
    ed.popScene()
    FireEvent("SkillTowerStageEndReply", {
      nextFloor = #self.rewards > 0
    })
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_data", function()
    ed.ui.BattleStaticsWin.create(ed.engine.unit_list, "awakeStage", true)
  end, {pressScale = 0.9})
end
