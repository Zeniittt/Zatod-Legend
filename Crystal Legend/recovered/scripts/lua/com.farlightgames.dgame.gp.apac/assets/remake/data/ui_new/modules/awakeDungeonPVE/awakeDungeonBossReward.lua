local base = ed.ui.popwindow
local awakeDungeonBossReward = newclass(base.mt)
ed.ui.awakeDungeonBossReward = awakeDungeonBossReward

function awakeDungeonBossReward:initData(param)
  self.stageId = param.stageId
  self.cellX = param.cellX
  self.cellY = param.cellY
  local stageTableItem = ed.getDataTable("DungeonStage")[self.stageId]
  local difficulty = stageTableItem["Boss Difficulty"]
  local rewardId = stageTableItem["Boss Reward ID"]
  local baseProgressVal = (difficulty - 1) * ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS
  self.curPerc = math.max(0, ed.awakeDungeonMgr.getInstance():getCurStageProgress(self.cellX, self.cellY) - baseProgressVal)
  local rewardTableItem = ed.getDataTable("DungeonBossReward")[rewardId]
  self.rewardList = {}
  for k, v in pairs(rewardTableItem) do
    local rewards = {}
    for i = 1, 6 do
      if v["Reward Amount " .. i] and 0 < v["Reward Amount " .. i] then
        table.insert(rewards, {
          id = v["Reward ID " .. i],
          type = v["Reward Type " .. i],
          amount = v["Reward Amount " .. i]
        })
      end
    end
    table.insert(self.rewardList, {
      perc = k - baseProgressVal,
      rewards = rewards
    })
  end
  table.sort(self.rewardList, function(a, b)
    return a.perc < b.perc
  end)
end

function awakeDungeonBossReward:initLabels()
  self.ui.title:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.title, ed.toccc3(8008718), 1)
  self.ui.title:limitWidthByScale(150)
  self.ui.sub_title:limitWidthByScale(290)
  ed.setLabelStroke(self.ui.tip, ed.toccc3(1578259), 1)
  self.ui.percent:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.percent, ed.toccc3(1578259), 1)
  ed.right2(self.ui.percent, self.ui.tip, 3)
end

function awakeDungeonBossReward:doPressInList()
  local function handler(x, y)
    self.draglist.canDragY = false
    
    return true
  end
  
  return handler
end

function awakeDungeonBossReward:cancelPressInList()
  local function handler(x, y)
    self.draglist.canDragY = true
  end
  
  return handler
end

function awakeDungeonBossReward:createItem(data)
  local container, ui = ed.editorui(ed.uieditor.awakeDungeonBossRewardItem)
  ui.prec:setFontName(ed.fontBold)
  ed.setString(ui.prec, math.floor(data.perc / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100) .. "%")
  local draglist = ed.UITool.createDraglist(ui.layer_item, {})
  for k, v in ipairs(data.rewards or {}) do
    local icon = ed.createItemIcon(v)
    icon:setScale(0.6)
    icon:setPosition(ccp(k * 50 - 25, 24))
    self:btRegisterButtonClick({
      button = icon,
      key = string.format("icon_%d_%d", data.perc, k),
      clickHandler = function()
        ed.ui.packageDetailWin.create(v):popWindow()
      end,
      force = true,
      mcpMode = true
    })
    draglist:addItem(icon)
  end
  draglist:initListWidth(#data.rewards * 50)
  if self.curPerc >= data.perc then
    ed.setTexture(ui.bg, "UI/alpha/1080P/dungeon/boss/boss_reward_achieve_1.png")
    ed.setTexture(ui.bg_prec, "UI/alpha/1080P/dungeon/boss/boss_reward_achieve_2.png")
    ed.setLabelStroke(ui.prec, ed.toccc3(6566930), 1)
    ed.setLabelColor(ui.prec, ed.toccc3(16771779), 1)
  else
    ed.setLabelStroke(ui.prec, ed.toccc3(6566930), 1)
    local label = ed.createttf(T("\230\156\170\232\190\190\230\136\144"), 18)
    label:setColor(ed.toccc3(16773489))
    label:setFontName(ed.fontBold)
    ed.setLabelStroke(label, ed.toccc3(6566930), 1)
    ed.UITool.replaceUI(ui, "bg", "state", label)
  end
  return container, ui
end

function awakeDungeonBossReward:refreshDraglist()
  local size = self.ui.layer_item:getContentSize()
  
  local function getPos(i)
    local py = 63
    return ccp(size.width / 2, size.height - py * (i - 0.5))
  end
  
  for k, v in ipairs(self.rewardList) do
    local container, ui = self:createItem(v)
    container:setPosition(getPos(k))
    self.draglist:addItem(container)
  end
  self.draglist:initListHeight(#self.rewardList * 63)
end

function awakeDungeonBossReward:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "out_click",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
end

function awakeDungeonBossReward:registerEvents()
end

function awakeDungeonBossReward:initUI()
  ed.editorui(ed.uieditor.awakeDungeonBossReward, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.setString(self.ui.percent, math.floor(self.curPerc / ed.awakeDungeonDefine.BOSS_DIFFICUTLTY_PROGRESS * 100) .. "%")
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {})
  self:refreshDraglist()
end

function awakeDungeonBossReward.create(param)
  local self = base.create("awakeDungeonBossReward")
  setmetatable(self, awakeDungeonBossReward.mt)
  self:initData(param)
  self:initUI()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end
