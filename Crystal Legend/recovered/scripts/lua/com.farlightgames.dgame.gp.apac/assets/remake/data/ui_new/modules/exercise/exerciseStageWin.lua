local base = ed.ui.popwindow
local exerciseStageWin = newclass(base.mt)
ed.ui.exerciseStageWin = exerciseStageWin

function exerciseStageWin.create(delegate, group)
  local self = base.create("exerciseStageWin")
  setmetatable(self, exerciseStageWin.mt)
  self:initData(delegate, group)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  self:show()
  return self
end

function exerciseStageWin:initData(delegate, group)
  self.delegate = delegate
  self.group = group
  self.actStageGroup = ed.lookupDataTable("ActStageGroup", nil, group)
  self.degreecell = {}
  self.degreeindex = 1
  self.rewardicon = {}
  self.eventScope = {}
  self.stars = 0
end

function exerciseStageWin:initUI()
  self.container, self.ui = ed.editorui(ed.uieditor.exerciseStageWin)
  self.mainLayer:addChild(self.container)
  self.ui.bg:setPosition(ed.display.center)
  self:initLabel()
  self:initRewardList()
  self:initEnemyList()
  self:initDegreeList()
  self:selectDegree(self.degreeindex)
  self:limitDraglistPos()
end

function exerciseStageWin:initLabel()
  ed.setLabelStroke(self.ui.degree_label, ccc3(ed.colorToStr("#874B15")), 1)
  self.ui.boss:setFontName(ed.fontBold)
  ed.setLabelColor(self.ui.boss, ccc3(ed.colorToStr("#ffc231")))
  ed.setLabelStroke(self.ui.boss, ccc3(ed.colorToStr("#000000")), 1)
  ed.setLabelStroke(self.ui.skill1, ccc3(ed.colorToStr("#150D08")), 1)
  ed.setLabelStroke(self.ui.skill2, ccc3(ed.colorToStr("#150D08")), 1)
  ed.setLabelShadow(self.ui.enemy_label, ccc3(ed.colorToStr("#1F170B")), ccp(0, 2))
  ed.setLabelShadow(self.ui.reward_label, ccc3(ed.colorToStr("#1F170B")), ccp(0, 2))
  ed.setLabelShadow(self.ui.sweep_label, ccc3(ed.colorToStr("#1F170B")), ccp(0, 2))
  ed.setLabelShadow(self.ui.sweep_num, ccc3(ed.colorToStr("#1F170B")), ccp(0, 2))
  ed.setLabelStroke(self.ui.sweep_ten, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.sweep_ten, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.sweep, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.sweep, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelStroke(self.ui.battle_label, ccc3(ed.colorToStr("#90550f")), 1)
  ed.setLabelShadow(self.ui.battle_label, ccc3(0, 0, 0), ccp(0, 2))
  self.ui.sweep_num:setPositionX(self.ui.sweep_label:getPositionX() + self.ui.sweep_label:getContentSize().width)
  self.ui.sweep_image:setPositionX(self.ui.sweep_num:getPositionX() + self.ui.sweep_num:getContentSize().width)
  self.ui.battle_label:limitWidthByScale(self.ui.battle_btn:getContentSize().width * 0.8)
end

function exerciseStageWin:initDegreeList()
  local layersize = self.ui.stageListLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = self.ui.stageListLayer,
    priority = -300
  }
  self.degreedraglist = ed.draglist.create(info)
  self:addDegreeCell()
end

function exerciseStageWin:addDegreeCell(stayPos)
  local oldPosX, oldPosY
  if stayPos then
    oldPosX, oldPosY = self.degreedraglist:getListPos()
  end
  self.degreedraglist.listLayer:removeAllChildrenWithCleanup(true)
  self.degreecell = {}
  self.degreeindex = 1
  local degrees = self.actStageGroup.Stages
  local stageTable = ed.getDataTable("Stage")
  local height = self.ui.stageListLayer:getContentSize().height
  local listheight = 0
  local unlock = false
  for i, degree in ipairs(degrees) do
    local degreeNode, degreeUI = ed.editorui(ed.uieditor.exerciseDegreeCell)
    degreeNode:setPosition(ccp(0, height - listheight))
    local stagerow = stageTable[degree]
    unlock = self:checkDegreeUnlock(i)
    ed.setLabelShadow(degreeUI.degree_label, ccc3(0, 0, 0), ccp(0, 2))
    if unlock then
      ed.setTexture(degreeUI.degree_btn, "UI/alpha/1080P/pool/pool_stag_open_unchoose.png")
      ed.setTexture(degreeUI.degree_btn_press, "UI/alpha/1080P/pool/pool_stag_open_choose.png")
      ed.setTexture(degreeUI.degree_image, T("UI/alpha/1080P/pool/difficulty/diff_open_%s.png", stagerow.Difficulty))
      ed.setLabelColor(degreeUI.degree_label, ccc3(ed.colorToStr("#FFFCE7")))
      degreeUI.degree_label:setString(T("\233\154\190\229\186\166%s", i))
      self.degreeindex = i
    else
      ed.setTexture(degreeUI.degree_btn, "UI/alpha/1080P/pool/pool_stag_unopen.png")
      ed.setTexture(degreeUI.degree_btn_press, "UI/alpha/1080P/pool/pool_stag_unopen.png")
      ed.setTexture(degreeUI.degree_image, T("UI/alpha/1080P/pool/difficulty/diff_lock_%s.png", stagerow.Difficulty))
      ed.setLabelColor(degreeUI.degree_label, ccc3(ed.colorToStr("#BDB5AE")))
      degreeUI.degree_label:setString(T("\230\156\170\229\188\128\229\144\175"))
      degreeUI.degree_label:setPositionX(degreeUI.degree_label:getPositionX() + 6)
    end
    degreeUI.selected:setVisible(false)
    self.degreedraglist:addItem(degreeNode)
    listheight = listheight + degreeUI.degree_btn:getContentSize().height - 20 / ed.display.scaleFactor
    self:btRegisterButtonClick({
      button = degreeUI.degree_btn,
      press = degreeUI.degree_btn_press,
      key = "degree_btn" .. i,
      clickHandler = function()
        self:selectDegree(i)
      end,
      force = true,
      priority = i,
      clickInterval = 0.5
    })
    table.insert(self.degreecell, {
      ui = degreeUI,
      unlock = unlock,
      selected = false,
      degree = degree,
      stagerow = stagerow,
      battlerow = ed.lookupDataTable("Battle", nil, degree, stagerow.Waves)
    })
  end
  self.degreedraglist:initListHeight(listheight)
  if stayPos then
    self.degreedraglist:setListPos(ccp(oldPosX, oldPosY))
  else
    self:limitDraglistPos()
  end
end

function exerciseStageWin:checkDegreeUnlock(index)
  local degrees = self.actStageGroup.Stages
  local lastdegree = degrees[index - 1]
  if lastdegree and ed.player:getStageStar(lastdegree) == 0 then
    return false
  end
  return true
end

function exerciseStageWin:selectDegree(index)
  if self.degreecell[index].unlock then
    self.curDegree = index
    for i = 1, #self.degreecell do
      local cell = self.degreecell[i]
      local ui = cell.ui
      cell.selected = i == index
      ui.selected:setVisible(cell.selected)
      ui.degree_btn_press:setVisible(cell.selected)
      if cell.selected then
        ed.setLabelColor(ui.degree_label, ccc3(ed.colorToStr("#FED36D")))
        self:initDegreeInfomation(index)
      elseif cell.unlock then
        ed.setLabelColor(ui.degree_label, ccc3(ed.colorToStr("#FFFCE7")))
      end
    end
  else
    ed.showToast(T("\233\128\154\229\133\179\229\137\141\228\184\128\233\154\190\229\186\166\229\144\142\232\167\163\233\148\129"))
  end
end

function exerciseStageWin:limitDraglistPos()
  if self.degreedraglist then
    local height = self.ui.stageListLayer:getContentSize().height
    self.degreedraglist:setListPos(ccp(0, (62 - 20 / ed.display.scaleFactor) * self.degreeindex - height + 10 / ed.display.scaleFactor), true)
  end
end

function exerciseStageWin:doClickInReward()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function exerciseStageWin:cancelClickInReward()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function exerciseStageWin:doPressInReward()
  local function handler(x, y)
    for i = 1, #self.rewardicon do
      local reward = self.rewardicon[i]
      
      if ed.containsPoint(reward.icon, x, y) then
        local panel = ed.readequip.getDetailCard(reward.id)
        panel:setPosition(reward.icon:getParent():convertToWorldSpace(ccp(reward.icon:getPosition())))
        self.mainLayer:addChild(panel, 50)
        self.namePanel = panel
        return i
      end
    end
  end
  
  return handler
end

function exerciseStageWin:cancelPressInReward()
  local function handler(x, y, id)
    if self.namePanel then
      self.namePanel:removeFromParentAndCleanup(true)
      
      self.namePanel = nil
    end
  end
  
  return handler
end

function exerciseStageWin:initRewardList()
  local layersize = self.ui.rewardLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = self.ui.rewardLayer,
    priority = -300,
    doClickIn = self:doClickInReward(),
    cancelClickIn = self:cancelClickInReward(),
    doPressIn = self:doPressInReward(),
    cancelPressIn = self:cancelPressInReward()
  }
  self.rewardlist = ed.draglist.create(info)
end

function exerciseStageWin:addReward()
  self.rewardlist.listLayer:removeAllChildrenWithCleanup(true)
  self.rewardicon = {}
  local listwidth = 0
  for i = 1, 7 do
    local id = self.cell.stagerow["UI reward" .. i]
    if id and 0 < id then
      local icon = ed.readequip.createIcon(id, self.rewardlist.cliprect.size.height)
      icon:setAnchorPoint(ccp(0, 0))
      icon:setPosition(ccp(listwidth, 0))
      self.rewardlist:addItem(icon)
      listwidth = listwidth + ed.layout.getScaleSize(icon).width
      table.insert(self.rewardicon, {icon = icon, id = id})
    end
  end
  self.rewardlist:initListWidth(listwidth)
end

function exerciseStageWin:createAutoText(param)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = param.context,
    color = ccc3(ed.colorToStr("#FFFCE7")),
    maxWidth = param.maxWidth,
    maxHeight = param.maxHeight,
    fontSize = param.fontSize or 14,
    lineSpacing = param.lineSpacing or 5
  })
  return autoText
end

function exerciseStageWin:initDegreeInfomation(index)
  self.index = index
  self.cell = self.degreecell[self.index]
  if self.ui.stage_title == nil then
    local groupName = ed.createttf(self.actStageGroup["Group Name"], 17)
    groupName:setAnchorPoint(ccp(0, 0.5))
    groupName:setPosition(ccp(394 / ed.display.scaleFactor, 776 / ed.display.scaleFactor))
    ed.setLabelColor(groupName, ed.toccc3(16771198))
    ed.setLabelStroke(groupName, ed.toccc3(11818272), 1)
    self.ui.stage_title = groupName
    self.ui.bg:addChild(groupName)
  end
  self.ui.degree_label:setString(T(" \194\183 \233\154\190\229\186\166%s", self.cell.stagerow.Difficulty))
  self.ui.degree_label:setPositionX(self.ui.stage_title:getPositionX() + self.ui.stage_title:getContentSize().width)
  self.stars = ed.player:getStageStar(self.cell.degree)
  local starPosX = self.ui.stage_title:getPositionX() + math.max(176, self.ui.degree_label:getPositionX() + self.ui.degree_label:getContentSize().width - self.ui.stage_title:getPositionX()) + 16
  for i = 1, 3 do
    local res = i > self.stars and "UI/alpha/1080P/campaign/main/campaign_stage_star_2.png" or "UI/alpha/1080P/campaign/main/campaign_stage_star_1.png"
    local starImg = self.ui["star_" .. i]
    ed.setTexture(starImg, res)
    local starWidth = starImg:getContentSize().width
    starImg:setPositionX(starPosX + starWidth * 0.5)
    starPosX = starPosX + starWidth - 8
  end
  if self.ui.bossLayer:getChildrenCount() == 0 then
    self.delegate:createCellAnimation(self.ui.bossLayer, self.group, self.group)
    self:btRegisterCircleClick({
      key = "clickBoss" .. self.group,
      center = ccp(80, 80),
      radius = 80,
      parent = self.ui.bossLayer,
      pressHandler = function()
        local info = self.bossInfo
        if not info then
          return
        end
        local panel = ed.readequip.getDetailCard(info.id, {
          level = info.level,
          rank = info.rank,
          isBoss = info.isBoss,
          isUnit = true,
          campLevel = info.campLevel
        })
        local pos = self.ui.bossLayer:getParent():convertToWorldSpace(ccp(self.ui.bossLayer:getPosition()))
        pos.x = pos.x + panel:getContentSize().width / 2 - 60
        pos.y = pos.y + panel:getContentSize().height / 2 + 60
        panel:setPosition(pos)
        self.mainLayer:addChild(panel, 50)
        self.enemyPanel = panel
      end,
      cancelPressHandler = function()
        if self.enemyPanel then
          self.enemyPanel:removeFromParentAndCleanup(true)
          self.enemyPanel = nil
        end
      end,
      force = true
    })
  end
  self:initDegreeAutoText()
  self:addEnemy()
  self:addReward()
  self:resetSweepLabel()
end

function exerciseStageWin:initDegreeAutoText()
  local autoText
  if self.ui.title_auto then
    self.ui.title_auto:setString(T("<lable color=ccc3(255,252,231) strokeColor=ccc3(21,13,8) strokeSize=1>%s</lable>", self.cell.stagerow.description or ""))
  else
    autoText = self:createAutoText({
      context = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(21,13,8) strokeSize=1>%s</lable>", self.cell.stagerow.description or ""),
      maxWidth = 1050 / ed.display.scaleFactor,
      lineSpacing = 0
    })
    local width, height = autoText:getCurContentSize()
    autoText:setVerticalCenter()
    autoText.node:setPosition(ccp(395 / ed.display.scaleFactor, 715 / ed.display.scaleFactor))
    self.ui.title_auto = autoText
    self.ui.bg:addChild(autoText.node)
  end
  self.ui.skill1:setString(T(self.actStageGroup["Boss Skill 1 Name"] or ""))
  if self.ui.desc1_auto then
    self.ui.desc1_auto:setString(T("<lable color=ccc3(255,252,231) strokeColor=ccc3(21,13,8) strokeSize=1>%s</lable>", self.actStageGroup["Boss Skill 1 Description"] or ""))
    if self.draglist_1 then
      local _, h = self.ui.desc1_auto:getCurContentSize()
      self.draglist_1:initListHeight(h)
    end
  else
    local draglist_1 = ed.UITool.createDraglist(self.ui.skill_desc_1, {})
    autoText = self:createAutoText({
      context = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(21,13,8) strokeSize=1>%s</lable>", self.actStageGroup["Boss Skill 1 Description"] or ""),
      maxWidth = self.ui.skill_desc_1:getContentSize().width - 4,
      fontSize = 15,
      lineSpacing = 0
    })
    autoText.node:setPosition(ccp(0, self.ui.skill_desc_1:getContentSize().height - autoText:getFirstLineHeight() * 0.5))
    draglist_1:addItem(autoText.node)
    local _, h = autoText:getCurContentSize()
    draglist_1:initListHeight(h + 3)
    self.draglist_1 = draglist_1
    self.ui.desc1_auto = autoText
  end
  self.ui.skill2:setString(T(self.actStageGroup["Boss Skill 2 Name"] or ""))
  if self.ui.desc2_auto then
    self.ui.desc2_auto:setString(T("<lable color=ccc3(255,252,231) strokeColor=ccc3(21,13,8) strokeSize=1>%s</lable>", self.actStageGroup["Boss Skill 2 Description"] or ""))
    if self.draglist_2 then
      local _, h = self.ui.desc2_auto:getCurContentSize()
      self.draglist_2:initListHeight(h)
    end
  else
    local draglist_2 = ed.UITool.createDraglist(self.ui.skill_desc_2, {})
    autoText = self:createAutoText({
      context = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(21,13,8) strokeSize=1>%s</lable>", self.actStageGroup["Boss Skill 2 Description"] or ""),
      maxWidth = self.ui.skill_desc_1:getContentSize().width - 4,
      fontSize = 15,
      lineSpacing = 0
    })
    autoText.node:setPosition(ccp(0, self.ui.skill_desc_2:getContentSize().height - autoText:getFirstLineHeight() * 0.5))
    draglist_2:addItem(autoText.node)
    local _, h = autoText:getCurContentSize()
    draglist_2:initListHeight(h + 3)
    self.draglist_2 = draglist_2
    self.ui.desc2_auto = autoText
  end
end

function exerciseStageWin:resetSweepLabel()
  ed.setString(self.ui.sweep_num, ed.player:getSweepTimes())
  local size = self.ui.sweep_num:getContentSize()
  local x = self.ui.sweep_num:getPositionX() + 3
  self.ui.sweep_image:setPositionX(x + size.width)
end

function exerciseStageWin:getEnemyInformation()
  local battlerow = self.cell.battlerow
  local enemyid = {}
  for i = 1, 5 do
    local id = string.format("Monster %d ID", i)
    local enemy = battlerow[id]
    if enemy then
      enemyid[i] = enemy
    end
  end
  local unit = ed.getDataTable("Unit")
  local info = {}
  for i = 1, #enemyid do
    if enemyid[i] ~= 0 then
      local id = enemyid[i]
      info[i] = {
        id = id,
        res = ed.getUnitPortrait(enemyid[i]),
        level = self.cell.stagerow["Monster Level"],
        stars = battlerow["Stars " .. i],
        rank = battlerow["Rank " .. i],
        index = i
      }
      local rank = ed.heroLevel2Rank(info[i].level)
      if not info[i].rank or not (0 < info[i].rank) then
        info[i].rank = rank
      end
    end
  end
  self.enemyInfo = info
  self:findBoss(self.cell.battlerow)
end

function exerciseStageWin:findBoss(battlerow)
  local bossPos = battlerow["Boss Position"] or 0
  if self.enemyInfo[bossPos] then
    local boss = self.enemyInfo[bossPos]
    self.bossInfo = boss
    table.remove(self.enemyInfo, bossPos)
  end
end

function exerciseStageWin:doClickInEnemy()
  local function handler(x, y, id)
    if self.enemyPanel then
      self.enemyPanel:removeFromParentAndCleanup(true)
      
      self.enemyPanel = nil
    end
  end
  
  return handler
end

function exerciseStageWin:cancelClickInEnemy()
  local function handler(x, y, id)
    if self.enemyPanel then
      self.enemyPanel:removeFromParentAndCleanup(true)
      
      self.enemyPanel = nil
    end
  end
  
  return handler
end

function exerciseStageWin:doPressInEnemy()
  local function handler(x, y)
    for i = 1, #self.enemyicon do
      local enemy = self.enemyicon[i]
      
      if ed.containsPoint(enemy.icon, x, y) then
        local info = enemy.info
        local panel = ed.readequip.getDetailCard(info.id, {
          level = info.level,
          rank = info.rank,
          isBoss = info.isBoss,
          isUnit = true,
          campLevel = info.campLevel
        })
        local pos = enemy.icon:getParent():convertToWorldSpace(ccp(enemy.icon:getPosition()))
        pos.y = pos.y + panel:getContentSize().height / 2
        panel:setPosition(pos)
        self.mainLayer:addChild(panel, 50)
        self.enemyPanel = panel
        return i
      end
    end
  end
  
  return handler
end

function exerciseStageWin:cancelPressInEnemy()
  local function handler(x, y, id)
    if self.enemyPanel then
      self.enemyPanel:removeFromParentAndCleanup(true)
      
      self.enemyPanel = nil
    end
  end
  
  return handler
end

function exerciseStageWin:initEnemyList()
  local layersize = self.ui.enemyLayer:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, layersize.width, layersize.height),
    noshade = true,
    container = self.ui.enemyLayer,
    priority = -300,
    doClickIn = self:doClickInEnemy(),
    cancelClickIn = self:cancelClickInEnemy(),
    doPressIn = self:doPressInEnemy(),
    cancelPressIn = self:cancelPressInEnemy()
  }
  self.enemylist = ed.draglist.create(info)
end

function exerciseStageWin:addEnemy()
  self.enemylist.listLayer:removeAllChildrenWithCleanup(true)
  self.enemyicon = {}
  self:getEnemyInformation()
  self.ui.enemy_label:setVisible(#self.enemyInfo > 0)
  local listwidth = 0
  for i, info in ipairs(self.enemyInfo) do
    info.length = 90 / ed.display.scaleFactor
    local unit = ed.readhero.createIcon(info)
    local size = ed.layout.getScaleSize(unit.icon)
    local gap = 1 < i and 5 or 0
    unit.icon:setPosition(ccp(5 + listwidth + size.width / 2 + gap, size.height / 2 + 5))
    self.enemylist:addItem(unit.icon)
    listwidth = unit.icon:getPositionX() + size.width / 2
    table.insert(self.enemyicon, {
      icon = unit.icon,
      info = info
    })
  end
  self.enemylist:initListWidth(listwidth + 10)
end

function exerciseStageWin:doClickSweep(times)
  if self.stars < 3 then
    ed.showToast(T("\233\128\154\229\133\179\229\185\182\232\190\190\230\136\144\228\184\137\230\152\159\229\144\142\232\167\163\233\148\129\230\137\171\232\141\161"))
    return
  end
  if self.sendSweepTime then
    local time = ed.getSystemTime()
    if time - self.sendSweepTime < 1.5 then
      return
    end
  end
  if times > ed.player:getSweepTimes() then
    self:doPaySweepConfirm(times)
    return
  end
  self:doSendSweep("free", times)()
  self.sendSweepTime = ed.getSystemTime()
end

function exerciseStageWin:doPaySweepConfirm(times)
  local price = self:getSweepPrice(times)
  ed.showConfirmDialog({
    text = T("\230\137\171\232\141\161\229\136\184\228\184\141\232\182\179\239\188\140\232\191\155\232\161\140\230\137\171\232\141\161\233\156\128\232\166\129\232\138\177\232\180\185 %d \233\146\187\231\159\179.\n\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159", price),
    rightHandler = self:doSendSweep("pay", times)
  })
end

function exerciseStageWin:getSweepPrice(times)
  local price = ed.parameter.pay_sweep_unit_price
  price = price * times
  return price
end

function exerciseStageWin:doSendSweep(type, times)
  local function handler()
    if times < 1 then
      return
    end
    self:doSweep(type, times)
  end
  
  return handler
end

function exerciseStageWin:doSweep(type, times)
  self.playerLevelPreSweep = ed.player:getLevel()
  ed.netdata.sweep = {
    type = type,
    times = times,
    power = self.cell.stagerow["Vitality Cost"],
    cost = type == "pay" and self:getSweepPrice(times) or 0,
    stage = self.cell.degree
  }
  ed.netreply.sweep = self:doSendSweepReply()
  self.stageId = self.cell.degree
  self.times = times
  local msg = ed.upmsg.sweep_stage()
  msg._type = type == "free" and "sweep_with_ticket" or "sweep_with_rmb"
  msg._stageid = self.cell.degree
  msg._times = times
  ed.send(msg, "sweep_stage")
  
  function ed.netreply.sweepReply()
    local time = ed.exerciseNetWork:getQueryActStageReply()._user_left_time
    time = time - times < 0 and 0 or time - times
    ed.exerciseNetWork:getQueryActStageReply()._user_left_time = time
    FireEvent("refreshExercise", true)
    ed.record:refreshCommonRecord("FarmActStage", times)
  end
  
  local sg = self.cell.stagerow["Stage Group"]
  ed.player:addActTimes(sg, times)
end

function exerciseStageWin:doSendSweepReply()
  local function handler(info)
    self:resetSweepLabel()
    
    local lootList = self:readSweepReply(info)
    local sweepWindow = ed.ui.repeatRewardWindow.create(lootList, {
      stageId = self.stageId,
      times = self.times
    })
    sweepWindow:popWindow()
  end
  
  return handler
end

function exerciseStageWin:readSweepReply(info)
  local list = {}
  local wave = info._loot
  for k, v in pairs(wave) do
    local exp = v._exp
    local money = v._money
    local ll = {
      exp = exp,
      money = money,
      loots = {}
    }
    for ck, cv in pairs(v._items or {}) do
      local id, amount = ed.analyzeItem2(cv)
      table.insert(ll.loots, {id = id, amount = amount})
    end
    table.insert(list, ll)
  end
  local el = {
    loots = {}
  }
  for k, v in pairs(info._items or {}) do
    local id, amount = ed.analyzeItem2(v)
    table.insert(el.loots, {id = id, amount = amount})
  end
  table.insert(list, el)
  return list
end

function exerciseStageWin:doClickGo()
  local act_recommend_heros = {}
  local act_recommend_mode = false
  local ids = self.actStageGroup["Recommended Hero List"]
  if ids and 0 < #ids then
    act_recommend_mode = true
    act_recommend_heros = ids
  end
  local rewards = {}
  for i = 1, 7 do
    local tn = "UI reward" .. i
    local reward = self.cell.stagerow[tn]
    if reward and 0 < reward and ed.readequip:isEquipOpen(reward) then
      table.insert(rewards, {
        id = reward,
        cnt = ed.readequip:quality(reward)
      })
    end
  end
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "exerciseStageDetail",
    stage_id = self.cell.degree,
    GWMode = false,
    heroLimit = {},
    actType = "equip",
    act_recommend_heros = act_recommend_heros,
    act_recommend_mode = act_recommend_mode,
    isTitan = false,
    objData = {
      titleName = self.cell.stagerow["Stage Name"],
      detail = self.cell.stagerow.description,
      countLimit = {
        countLimit = ed.getDataTable("ActStageGroup")[self.group].DailyLimit,
        count = ed.exerciseNetWork:getQueryActStageReply()._user_left_time
      },
      monMod = {},
      items = rewards
    }
  }))
end

function exerciseStageWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "close_btn", function()
    CloseScope(self.eventScope)
    self:destroy()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "sweep_btn", function()
    if ed.exerciseNetWork:getQueryActStageReply()._user_left_time == 0 then
      ed.showToast(T("\230\156\172\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\229\183\178\232\128\151\229\176\189"))
      return
    end
    self:doClickSweep(1)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "sweep_ten_btn", function()
    if ed.exerciseNetWork:getQueryActStageReply()._user_left_time == 0 then
      ed.showToast(T("\230\156\172\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\229\183\178\232\128\151\229\176\189"))
      return
    end
    self:doClickSweep(ed.exerciseNetWork:getQueryActStageReply()._user_left_time)
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "battle_btn", function()
    if ed.exerciseNetWork:getQueryActStageReply()._user_left_time == 0 then
      ed.showToast(T("\230\156\172\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\229\183\178\232\128\151\229\176\189"))
      return
    end
    self:doClickGo()
  end, {pressScale = 0.9})
end

function exerciseStageWin:refreshUI(stayPos)
  self:addDegreeCell(stayPos)
  self:selectDegree(stayPos and self.curDegree or self.degreeindex)
end

function exerciseStageWin:registerEvents()
  self:listenEvent("refreshExercise", function(isSweep)
    self:refreshUI(isSweep)
  end)
end
