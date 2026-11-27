local class = newclass("g")
ed.ui.activityHeroRecyclePage = class
if ed.isAreaOverSea() then
  class.CHECK_TO_DESC = {
    _ladder_lineup = T("\233\135\141\231\148\159\229\144\142\232\135\170\229\138\168\228\187\142\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136\233\152\181\229\174\185\230\146\164\228\184\139(\229\166\130\230\156\137)"),
    _guild_hire = T("\228\187\142\229\133\172\228\188\154\228\189\163\229\133\181\232\144\165\229\156\176\230\146\164\228\184\139"),
    _peak_arena_lineup = T("\228\187\142\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136\233\152\181\229\174\185\230\146\164\228\184\139"),
    _guild_clash_lineup = T("\233\135\141\231\148\159\229\144\142\232\135\170\229\138\168\228\187\142\229\133\172\228\188\154\230\136\152\233\152\159\229\136\151\230\146\164\228\184\139(\229\166\130\230\156\137)")
  }
else
  class.CHECK_TO_DESC = {
    _ladder_lineup = T("\233\135\141\231\148\159\229\144\142\232\135\170\229\138\168\228\187\142\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136\233\152\181\229\174\185\230\146\164\228\184\139(\229\166\130\230\156\137)"),
    _guild_hire = T("\228\187\142\229\133\172\228\188\154\228\189\163\229\133\181\232\144\165\229\156\176\230\146\164\228\184\139"),
    _peak_arena_lineup = T("\228\187\142\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136\233\152\181\229\174\185\230\146\164\228\184\139"),
    _guild_clash_lineup = T("\233\135\141\231\148\159\229\144\142\232\135\170\229\138\168\228\187\142\229\133\172\228\188\154\230\136\152\233\152\159\229\136\151\230\146\164\228\184\139(\229\166\130\230\156\137)"),
    _cup_arena_lineup = T("\228\187\142\229\165\179\231\165\158\228\185\139\230\136\152\233\152\181\229\174\185\230\146\164\228\184\139"),
    _legend_equip = T("\232\167\163\233\153\164\231\187\145\229\174\154\231\154\132\228\188\160\229\165\135\232\163\133\229\164\135")
  }
end
class.CHECK_SKIP_HANDLE = {
  _ladder_lineup = function()
    ed.activityTaskTool.openPvp()
  end,
  _guild_hire = function()
    ed.activityTaskTool.enterGuildMercenary()
  end,
  _peak_arena_lineup = function()
    ed.activityTaskTool.openPeakArenaScene()
  end,
  _guild_clash_lineup = function()
    ed.activityTaskTool.openGuildClashScene()
  end,
  _cup_arena_lineup = function()
    ed.CupArenaNetwork:sendOpenPanel(true)
  end,
  _legend_equip = function(hero)
    ed.UITool.openView("legendEquipWindow", {
      legendEquip = hero._legend_equip._equip
    })
  end
}

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.endTime = param._end_time
  self.activityId = param._id
  self.cfgId = param._cfg_id
  local taskList = param._tasks or {}
  self.taskData = taskList[1]
  self.checkList = nil
  self.rewardList = nil
  self.curStep = 1
  self.totalStep = 3
  self.pageKey = pageKey
  self.isVisible = true
  self.heroRecycleMgr = ed.HeroRecycleMgr.getInstance()
  self.heroRecycleMgr:setOpenViewTag(self.activityId, true)
  self.heroLevelLimit = ed.getDataTable("Activity")[self.cfgId]["Extra AN"][1]
  self:initLocalData()
  self:initTaskData()
  self:initView()
  self:addTouchEvent()
  self:addEventListener()
end

function class:initLocalData()
  self.selectHeroId = nil
  if self.taskData._extend and self.taskData._extend._recycle_hero_id then
    self.selectHeroId = self.taskData._extend._recycle_hero_id
  else
    local heroId = ed.storage.getInt(ed.getRoleKey("HeroRecycleHeroId_" .. self.activityId))
    if heroId and 0 < heroId then
      self.selectHeroId = heroId
    end
  end
end

function class:saveLocalHeroId()
  ed.storage.setValue(ed.getRoleKey("HeroRecycleHeroId_" .. self.activityId), self.selectHeroId)
end

function class:initTaskData()
  local isCompleted = self.taskData._progress >= self.taskData._cond_target
  self.isCompleted = isCompleted
end

function class:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
end

function class:onSceneEnter()
  self:recycleCheck()
end

function class:recycleCheck()
  if self.selectHeroId and not self.isCompleted and self.curStep == 2 then
    ed.HeroRecycleNet.sendRecycleCheck(self.selectHeroId)
  end
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_hero_recycle_page)
  self.container = container
  self.ui = ui
  self:initLabels()
  self:adaptUI()
  self:initCheckDragList()
  self:initItemTableView()
  self:startCountDown()
  self:refreshView()
end

function class:refreshView()
  self:refreshBtnStep()
  self:refreshHeroPuppet()
  self:refreshPanelShow()
end

function class:initLabels()
  ed.setLabelFontName(self.ui.label_step1, ed.fontBold)
  ed.setLabelFontName(self.ui.label_step2, ed.fontBold)
  ed.setLabelFontName(self.ui.label_step3, ed.fontBold)
  ed.setLabelStroke(self.ui.label_recycle_times, ed.toccc3(14174494), 1)
  ed.setLabelStroke(self.ui.label_next1, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_next2, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_next3, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_previous2, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_previous3, ed.toccc3(10641433), 1)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(13582341), 1)
  ed.setLabelStroke(self.ui.label_finish, ed.toccc3(10174221), 1)
end

function class:adaptUI()
  ed.layout.horizontalSortNode({
    self.ui.Label_7622,
    self.ui.label_recycle_times,
    self.ui.Label_7624
  }, {
    0,
    0,
    0
  }, self.ui.image_step1_tips:getContentSize().width / 2)
end

function class:startCountDown()
  self:refreshCountDown()
  self:listenTimer(Timer:Always(1), function()
    self:refreshCountDown()
  end)
end

function class:refreshCountDown()
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182", day, hour))
  end
end

function class:initCheckDragList()
  self.checkDragList = ed.UITool.createDraglist(self.ui.panel_condition_list, {
    doPressIn = function(x, y)
      if not self.isVisible or not self.ui.panel_step2:isVisible() then
        return
      end
      for index, cfg in ipairs(self.checkUIList or {}) do
        local ui = cfg.ui
        if ed.containsPoint(ui.image_bg, x, y) then
          return cfg
        end
      end
    end,
    doClickIn = function(x, y, cfg)
      local checkKey = cfg.checkKey
      local checkResult = cfg.checkResult
      if checkResult == "manual" then
        local handle = self.CHECK_SKIP_HANDLE[checkKey]
        if handle then
          local selectHero = ed.player:getHero(self.selectHeroId)
          handle(selectHero)
        end
      end
    end,
    priority = -300
  })
end

function class:initItemTableView()
  local size = self.ui.panel_item_list:getContentSize()
  self.delegate = {
    numberOfCells = function()
      return #(self.rewardList or {})
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(70, 70)
    end,
    createCell = function(index)
      local reward = self.rewardList[index]
      local icon = ed.createItemIcon({
        id = reward._id,
        type = reward._type,
        amount = reward._amount
      })
      icon:setScale(0.8)
      return icon, {reward = reward}
    end,
    doClickIn = function(cell, x, y)
      if not self.isVisible or not self.ui.panel_step3:isVisible() then
        return
      end
      local data = cell.data
      local reward = data.reward
      ed.ui.packageDetailWin.create({
        id = reward._id,
        type = reward._type
      }):popWindow()
    end
  }
  local param = {
    delegate = self.delegate,
    container = self.ui.panel_item_list,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    colNum = 6,
    dragMode = 1,
    touchpriority = -300,
    offset = {0, 0},
    noshade = true
  }
  self.tableView = Tableview.create(param)
end

function class:refreshPanelShow()
  if self.isCompleted then
    for step = 1, self.totalStep do
      self.ui["panel_step" .. step]:setVisible(false)
    end
    self.ui.panel_finish:setVisible(true)
    if self.puppet then
      self.puppet:setPosition(self.ui.panel_hero_pos_finish:getPosition())
    end
  else
    self.ui.panel_finish:setVisible(false)
    for step = 1, self.totalStep do
      local panel = self.ui["panel_step" .. step]
      panel:setVisible(self.curStep == step)
    end
    if self.puppet then
      self.puppet:setPosition(self.ui["panel_hero_pos" .. self.curStep]:getPosition())
    end
    self:refreshPanelStep1()
    self:refreshPanelStep2()
    self:refreshPanelStep3()
  end
end

function class:refreshPanelStep1()
  if self.selectHeroId then
    self.ui.image_hero_select_bg:setVisible(false)
    self.ui.btn_hero_select:setVisible(false)
    self.ui.btn_change:setVisible(true)
  else
    self.ui.image_hero_select_bg:setVisible(true)
    self.ui.btn_hero_select:setVisible(true)
    self.ui.btn_change:setVisible(false)
  end
end

function class:refreshPanelStep2()
  self.checkDragList:clearList()
  self.checkUIList = {}
  local panelSize = self.ui.panel_condition_list:getContentSize()
  local totalHeight = 0
  local allCheckSuccess = true
  for index, check in ipairs(self.checkList or {}) do
    local checkKey = check.checkKey
    if self.CHECK_TO_DESC[checkKey] then
      local checkResult = check.checkResult
      local container, ui = ed.editorui(ed.uieditor.hero_recycle_condition_item)
      container:setContentSize(ui.image_bg:getContentSize())
      table.insert(self.checkUIList, {
        ui = ui,
        checkKey = checkKey,
        checkResult = checkResult
      })
      local itemSize = container:getContentSize()
      self.checkDragList:addItem(container)
      local desc = self.CHECK_TO_DESC[checkKey] or ""
      ed.setLabelString(ui.label_desc, desc)
      if checkResult == "ok" or checkResult == "auto" then
        ed.setTexture(ui.image_bg, "UI/alpha/1080P/activity/hero_recycle/hero_recycle_list_text_bg_1.png")
        ed.setTexture(ui.image_icon, "UI/alpha/1080P/activity/hero_recycle/hero_recycle_flame_1.png")
        ed.setLabelColor(ui.label_desc, ccc3(241, 121, 74))
        ui.image_done:setVisible(true)
        ui.image_arrow:setVisible(false)
      else
        allCheckSuccess = false
        ed.setTexture(ui.image_bg, "UI/alpha/1080P/activity/hero_recycle/hero_recycle_list_text_bg_2.png")
        ed.setTexture(ui.image_icon, "UI/alpha/1080P/activity/hero_recycle/hero_recycle_flame_2.png")
        ed.setLabelColor(ui.label_desc, ccc3(255, 229, 120))
        ui.image_done:setVisible(false)
        ui.image_arrow:setVisible(true)
      end
      container:setPosition(ccp(itemSize.width / 2, panelSize.height - totalHeight - itemSize.height / 2))
      totalHeight = totalHeight + container:getContentSize().height
    end
  end
  self.checkDragList:initListHeight(totalHeight)
  self.allCheckSuccess = allCheckSuccess
end

function class:refreshPanelStep3()
  self.tableView:reloadData()
end

function class:refreshBtnStep()
  for step = 1, self.totalStep do
    if self.isCompleted then
      self.ui[string.format("btn_step%s", step)]:setVisible(false)
    else
      local label_step = self.ui[string.format("label_step%s", step)]
      local label_desc = self.ui[string.format("label_step%s_desc", step)]
      local btn_select = self.ui[string.format("btn_step%s_select", step)]
      if step == self.curStep then
        btn_select:setVisible(true)
        ed.setLabelColor(label_step, ed.toccc3(16711657))
        ed.setLabelStroke(label_step, ed.toccc3(14648064), 1)
        ed.setLabelColor(label_desc, ccc3(253, 255, 217))
        ed.setLabelStroke(label_desc, ed.toccc3(14122496), 1)
      else
        btn_select:setVisible(false)
        ed.setLabelColor(label_step, ccc3(251, 246, 202))
        ed.setLabelStroke(label_step, ed.toccc3(11161345), 1)
        ed.setLabelColor(label_desc, ccc3(251, 246, 202))
        ed.setLabelStroke(label_desc, ed.toccc3(11161345), 1)
      end
    end
  end
end

function class:refreshHeroPuppet()
  if self.puppet then
    self.puppet:removeFromParentAndCleanup(true)
  end
  if not self.selectHeroId then
    return
  end
  local puppet, cha = ed.readhero.getActor(self.selectHeroId, "Idle", true)
  local row = ed.getDataTable("Puppet")[cha]
  local scale = row.Scale
  puppet:setScale(scale)
  self.ui.image_bg:addChild(puppet, 100)
  self.puppet = puppet
  self:addFca(puppet)
  puppet:setPosition(self.ui.panel_hero_pos1:getPosition())
end

function class:openHeroSelectWindow()
  local heroList = {}
  for heroId, hero in pairs(ed.player:getAllHero() or {}) do
    if hero._level >= self.heroLevelLimit then
      table.insert(heroList, hero)
    end
  end
  if #heroList <= 0 then
    ed.showToast(T("\232\191\152\230\178\161\230\156\137\229\143\175\233\135\141\231\148\159\231\154\132\232\139\177\233\155\132"))
    return
  end
  table.sort(heroList, ed.cmpSort({
    {
      getValue = function(hero)
        return hero._rank or 0
      end,
      reverse = true
    },
    {
      getValue = function(hero)
        return hero._level or 0
      end,
      reverse = true
    },
    {
      getValue = function(hero)
        return hero._tid or 0
      end
    }
  }))
  ed.UITool.openView("heroRecycleSelectWindow", {
    heroList = heroList,
    selectHeroId = self.selectHeroId,
    selectHeroCallBack = function(heroId)
      self:onSelectHero(heroId)
    end
  })
end

function class:onSelectHero(heroId)
  if self.selectHeroId == heroId then
    return
  end
  self.selectHeroId = heroId
  self:saveLocalHeroId()
  self:refreshHeroPuppet()
  self:refreshPanelStep1()
end

function class:onClickBtnNext1()
  if not self.selectHeroId then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132"))
    return
  end
  if self.selectHeroId and not self.isCompleted then
    ed.HeroRecycleNet.sendRecycleCheck(self.selectHeroId)
  end
  self.curStep = self.curStep + 1
  self:refreshBtnStep()
end

function class:onClickBtnNext2()
  if not self.allCheckSuccess then
    ed.showToast(T("\232\175\183\229\174\140\230\136\144\233\135\141\231\148\159\229\137\141\230\137\128\230\156\137\228\186\139\233\161\185"))
    return
  end
  if self.selectHeroId then
    ed.HeroRecycleNet.sendRecyclePreview(self.selectHeroId)
  end
  self.curStep = self.curStep + 1
  self:refreshBtnStep()
end

function class:onClickBtnNext3()
  ed.UITool.openView("heroRecycleConfirmWindow", {
    selectHeroId = self.selectHeroId,
    confirmCallBack = function()
      ed.ActivityNetwork.activityHeroRecycle(self.activityId, self.taskData._id, self.selectHeroId)
      self.objWork:activityPull(self.activityId)
    end
  })
end

function class:onClickBtnPrevious()
  if self.curStep <= 1 then
    return
  end
  self.curStep = self.curStep - 1
  self:refreshBtnStep()
  self:refreshPanelShow()
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_next1", function()
    self:onClickBtnNext1()
  end, {pressScale = 0.65, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_next2", function()
    self:onClickBtnNext2()
  end, {pressScale = 0.65, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_next3", function()
    self:onClickBtnNext3()
  end, {pressScale = 0.65, normalScale = 0.7})
  for step = 1, self.totalStep do
    ed.UITool.registerBtn(self, "btn_previous" .. step, function()
      self:onClickBtnPrevious()
    end, {pressScale = 0.65, normalScale = 0.7})
  end
  ed.UITool.registerBtn(self, "btn_hero_select", function()
    self:openHeroSelectWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_change", function()
    self:openHeroSelectWindow()
  end, {pressScale = 0.95})
end

function class:onHeroRecycleCheck(_check)
  self.checkList = {}
  for checkKey, checkResult in pairs(ed.copyProto(_check._check_list or {})) do
    table.insert(self.checkList, {checkKey = checkKey, checkResult = checkResult})
  end
  table.sort(self.checkList, ed.cmpSort({
    {
      getValue = function(t)
        if t.checkResult == "manual" then
          return 0
        end
        return 1
      end
    }
  }))
  self:refreshPanelStep2()
end

function class:onHeroRecyclePreview(_preview)
  self.rewardList = _preview._rewards or {}
  local newRewardList = {}
  for index, reward in ipairs(self.rewardList) do
    if reward._amount and reward._amount > 0 then
      table.insert(newRewardList, reward)
    end
  end
  self.rewardList = newRewardList
  local equipTB = ed.getDataTable("equip")
  table.sort(self.rewardList, ed.cmpSort({
    {
      getValue = function(reward)
        if reward._type == "gold" then
          return 0
        end
        return 999
      end
    },
    {
      getValue = function(reward)
        if reward._id then
          local category = equipTB[reward._id].Category
          if category == T("\230\182\136\232\128\151\229\147\129") then
            return 1
          elseif category == T("\233\155\182\228\187\182") or category == T("\229\144\136\230\136\144\229\147\129") then
            return 2
          end
        end
        return 999
      end
    },
    {
      getValue = function(reward)
        if reward._id then
          local category = equipTB[reward._id].Category
          if category == T("\230\182\136\232\128\151\229\147\129") then
            return reward._id
          elseif category == T("\233\155\182\228\187\182") or category == T("\229\144\136\230\136\144\229\147\129") then
            return -equipTB[reward._id].Quality
          end
        end
        return 999
      end
    },
    {
      getValue = function(reward)
        if reward._id then
          return reward._id
        end
        return 999
      end
    }
  }))
  self:refreshPanelStep3()
end

function class:onUnequipLegendEquip()
  self:recycleCheck()
end

function class:addEventListener()
  self:listenEvent("HeroRecycleCheck", function(_check)
    self:onHeroRecycleCheck(_check)
    self:refreshPanelShow()
  end)
  self:listenEvent("HeroRecyclePreview", function(_preview)
    self:onHeroRecyclePreview(_preview)
    self:refreshPanelShow()
  end)
  self:listenEvent("HeroRecycleTask", function(_task)
    self.taskData = _task
    self:initTaskData()
    self:refreshView()
  end)
  self:listenEvent("UnequipLegendEquip", function()
    self:onUnequipLegendEquip()
  end)
end
