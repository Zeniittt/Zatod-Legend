local base = ed.ui.popwindow
local exercisePreviewWin = newclass(base.mt)
ed.ui.exercisePreviewWin = exercisePreviewWin

function exercisePreviewWin.create()
  local self = base.create("exercisePreviewWin")
  setmetatable(self, exercisePreviewWin.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function exercisePreviewWin:initData()
  self:initRewardTable()
  self.rewardlist = {}
  self.rewardicon = {}
  self.eventScope = {}
end

function exercisePreviewWin:initRewardTable()
  self.rewardTable = {
    {
      name = "Monday",
      rewards = {}
    },
    {
      name = "Tuesday",
      rewards = {}
    },
    {
      name = "Wednesday",
      rewards = {}
    },
    {
      name = "Thursday",
      rewards = {}
    },
    {
      name = "Friday",
      rewards = {}
    },
    {
      name = "Saturday",
      rewards = {}
    },
    {
      name = "Sunday",
      rewards = {}
    }
  }
  local actStageGroup = ed.getDataTable("ActStageGroup")
  for group, row in pairs(actStageGroup) do
    if ed.getDataTable("Stage")[group] then
      local ul = ed.getDataTable("Stage")[group]["Unlock Level"] or 0
      if ul <= ed.player:getLevel() then
        local reward = row["Stage Group"]
        local groupName = row["Group Name"]
        for _, day in ipairs(self.rewardTable) do
          if row[day.name] and reward then
            self.stageName = self.stageName or {}
            self.stageName[reward] = groupName
            self:rewardTableInsert(day.rewards, reward)
          end
        end
      end
    end
  end
  for i, v in ipairs(self.rewardTable) do
    table.sort(v.rewards, function(a, b)
      return a < b
    end)
  end
end

function exercisePreviewWin:rewardTableInsert(rt, rewardid)
  for _, id in ipairs(rt) do
    if id == rewardid then
      return
    end
  end
  table.insert(rt, rewardid)
end

function exercisePreviewWin:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.exercisePreviewWin)
  self.mainLayer:addChild(self.container)
  self.ui.bg:setPosition(ed.display.center)
  self.ui.Panel_12909:setScale(0.7)
  self:initLabel()
  self:initWeekday()
  self:initRewardList()
end

function exercisePreviewWin:initLabel()
  ed.setLabelStroke(self.ui.title_label, ccc3(ed.colorToStr("#321e14")), 1)
end

function exercisePreviewWin:initWeekday()
  local weekday_idx = ed.getWeekdayIndex()
  local weekname = self.rewardTable[weekday_idx].name
  local posx = self.ui[weekname]:getPositionX()
  self.ui.select:setPositionX(posx)
  ed.setLabelColor(self.ui[weekname .. "_label"], ccc3(ed.colorToStr("#fff3a3")))
end

function exercisePreviewWin:doClickInReward()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function exercisePreviewWin:cancelClickInReward()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function exercisePreviewWin:doPressInReward()
  local function handler(x, y)
    for i = 1, #self.rewardicon do
      local reward = self.rewardicon[i]
      
      local info = reward.info
      if ed.containsPoint(reward.icon, x, y) then
        local panel = ed.readequip.getDetailCard(info.id, {
          level = info.level,
          rank = info.rank,
          isBoss = info.isBoss,
          isUnit = true,
          campLevel = info.campLevel
        })
        panel:setPosition(reward.icon:getParent():convertToWorldSpace(ccp(reward.icon:getPosition())))
        self.mainLayer:addChild(panel, 50)
        self.namePanel = panel
        return i
      end
    end
  end
  
  return handler
end

function exercisePreviewWin:cancelPressInReward()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function exercisePreviewWin:initRewardList()
  for i, day in ipairs(self.rewardTable) do
    local layersize = self.ui[day.name .. "_layer"]:getContentSize()
    local info = {
      cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
      noshade = true,
      container = self.ui[day.name .. "_layer"],
      priority = -300,
      doClickIn = self:doClickInReward(),
      cancelClickIn = self:cancelClickInReward(),
      doPressIn = self:doPressInReward(),
      cancelPressIn = self:cancelPressInReward()
    }
    self.rewardlist[i] = ed.draglist.create(info)
  end
  self:addReward()
end

function exercisePreviewWin:addReward()
  local function funcs(enemyInfos)
    local tab = {}
    
    for i, v in ipairs(enemyInfos) do
      for s, d in ipairs(v) do
        for b, o in ipairs(v) do
          if o.isboss and o.isboss == b then
            table.insert(tab, o)
          end
        end
      end
    end
    return tab
  end
  
  local idex = 1
  for i, day in ipairs(self.rewardTable) do
    self.rewardlist[i].listLayer:removeAllChildrenWithCleanup(true)
    local cliprectsize = self.rewardlist[i].cliprect.size
    local listheight = 0
    idex = 1
    for _, id in ipairs(day.rewards) do
      local enemyInfos = self.getEnemyHeadBattleprepare(id)
      enemyInfos = funcs(enemyInfos)
      for b, n in ipairs(enemyInfos or {}) do
        if n.isboss and n.isboss == b then
          local unit = ed.readhero.createIcon(n)
          local icon = unit.icon
          icon:setScale(0.6)
          local iconsize = ed.layout.getScaleSize(icon)
          iconsize.height = iconsize.height + 34
          icon:setAnchorPoint(ccp(0, 0))
          icon:setPosition(ccp((cliprectsize.width - iconsize.width) / 2, cliprectsize.height - iconsize.height - listheight + 28))
          if idex % 2 == 0 then
            local bg = ed.createScale9Sprite("UI/alpha/1080P/pool/pool_preview_items.png")
            bg:setContentSize(CCSizeMake(iconsize.width + 100, iconsize.height))
            local bgsize = ed.layout.getScaleSize(bg)
            bg:setPosition(ccp(cliprectsize.width / 2, cliprectsize.height - bgsize.height - listheight + 40))
            self.rewardlist[i].listLayer:addChild(bg)
          end
          self.rewardlist[i]:addItem(icon)
          listheight = listheight + iconsize.height
          local textLabel = ed.createttf(self.stageName[id] or "nil", 22)
          textLabel:limitWidthByScale(155)
          textLabel:setAnchorPoint(ccp(0.5, 0))
          textLabel:setPosition(ccp(iconsize.width * 0.5 + 15, -35))
          ed.setLabelColor(textLabel, ccc3(ed.colorToStr("#fffce7")))
          ed.setLabelStroke(textLabel, ccc3(ed.colorToStr("#322919")), 1.5)
          icon:addChild(textLabel)
          table.insert(self.rewardicon, {
            icon = icon,
            id = id,
            info = n
          })
          idex = idex + 1
        end
      end
    end
    self.rewardlist[i]:initListHeight(listheight)
  end
end

function exercisePreviewWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "close_btn", function()
    CloseScope(self.eventScope)
    self:destroy()
  end, {pressScale = 0.9})
end

function exercisePreviewWin.getEnemyHeadBattleprepare(stage)
  local step = 1
  local ids = {}
  
  local function retThisTeamTab(unit, ids, step)
    local info = {}
    for i = 1, #ids do
      if ids[i] ~= 0 then
        local id = ids[i]
        local sawk = ed.canSuperAwake(id) and ed.getDataTable("Battle")[stage][step]["SuperAwake" .. i]
        local campLevel = ed.getDataTable("Battle")[stage][step]["Camp Level"]
        local isboss = ed.getDataTable("Battle")[stage][step]["Boss Position"]
        local heroName = ed.getDataTable("Unit")[id]["Display Name"] or "\232\139\177\233\155\132\229\144\141\231\167\176\228\184\131\228\184\170\229\173\151"
        info[i] = {
          id = id,
          res = ed.getUnitPortrait(ids[i]),
          rank = 1,
          awake = ed.getDataTable("Battle")[stage][step]["Awake" .. i],
          superAwake = sawk,
          index = i,
          campLevel = campLevel ~= 0 and campLevel or nil,
          isboss = isboss,
          heroName = heroName
        }
      end
    end
    return info
  end
  
  local teamTabs = {}
  for s = 1, 5 do
    local brow = ed.getDataTable("Battle")[stage][s]
    if brow then
      teamTabs[s] = {}
      for i = 1, 5 do
        local brow = brow[string.format("Monster %d ID", i)]
        teamTabs[s][i] = brow or {}
      end
    end
  end
  local unit = ed.getDataTable("Unit")
  local newTeamTabs = {}
  for i = 1, #teamTabs do
    newTeamTabs[i] = retThisTeamTab(unit, teamTabs[i], i)
  end
  return newTeamTabs
end
