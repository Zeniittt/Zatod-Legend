local chooseWukongPage = newclass("g")
ed.ui.activityChooseWukongPage = chooseWukongPage
chooseWukongPage.modId = 54

function chooseWukongPage.create(base, param, pageKey)
  local this = {param = param, pageKey = pageKey}
  setmetatable(chooseWukongPage, {__index = base})
  setmetatable(this, {__index = chooseWukongPage})
  this:initView(param)
  this:setButtonClick()
  return this
end

function chooseWukongPage:initView(param)
  local container, ui = ed.editorui(ed.uieditor.activity_choose_wukong_page)
  self.ui = ui
  self.container = container
  ui.Label_time:setStroke(ed.toccc3(9263891), 1.2)
  local eff_Light = ed.createSpine("effect/eff_Lancer_fashion_2_art/eff_Lancer_fashion_2_art", 0.5)
  eff_Light:setAnimation(0, "Idle2", true)
  eff_Light:setPosition(ccp(250, 140))
  self.ui.ImageView_27:addChild(eff_Light)
  self.ui.Label_time:setString(T("\229\137\169\228\189\153 %s", param.endTimeStr or 0))
  local task = param._tasks
  self:initDragList(self:setTaskState(task))
  self:createHeroFca(self.modId)
  self.objWork:activityPull(param._id)
end

function chooseWukongPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  self:refreshDragList(self:setTaskState(task))
end

function chooseWukongPage:setTaskState(task)
  for i, v in ipairs(task) do
    local taskState = 0
    local isCompleted = v._progress >= v._cond_target
    local isFinished = v._cur_reward_times and v._cur_reward_times >= v._max_reward_times
    if isFinished then
      taskState = 2
    elseif isCompleted then
      taskState = 1
    end
    v.taskState = taskState
  end
  table.sort(task, function(a, b)
    local sortType = {
      [0] = 2,
      [1] = 3,
      [2] = 1
    }
    return sortType[a.taskState] > sortType[b.taskState]
  end)
  return task
end

function chooseWukongPage:setButtonClick()
end

function chooseWukongPage:initDragList(task)
  self.items = {}
  local thisCon = self.ui.Panel_item:getContentSize()
  local info = {
    cliprect = CCRectMake(0, 0, thisCon.width, thisCon.height),
    container = self.ui.Panel_item,
    priority = -300,
    noshade = true,
    zorder = 10
  }
  self.dragList = ed.draglist.create(info)
  for i, v in ipairs(task) do
    local item = self.itemBox.create(self, v, i)
    self.dragList:addItem(item.ui.bg, ccp(thisCon.width / 2, thisCon.height - 100 * i + 50))
    self.items[v._id] = item
  end
  self.dragList:initListHeight(#task * 100)
end

function chooseWukongPage:refreshDragList(task)
  local thisCon = self.ui.Panel_item:getContentSize()
  for i, v in ipairs(task) do
    if self.items[v._id].index ~= i then
      self.items[v._id].ui.bg:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(thisCon.width / 2, thisCon.height - 100 * i + 50))))
    end
    self.items[v._id]:update(v, i)
  end
end

local itemBox = {}

function itemBox.create(mainSelf, param, index)
  local this = setmetatable({
    mainSelf = mainSelf,
    param = param,
    index = index
  }, {__index = itemBox})
  this:initUi(param)
  return this
end

function itemBox:initUi(param)
  self.imgType = {
    [0] = 1,
    [1] = 3,
    [2] = 2
  }
  local bg = ed.createSpriteTools({
    res = string.format("UI/alpha/1080P/activity/wukong/task_%s.png", self.imgType[param.taskState]),
    pos = ccp(0, 0)
  })
  local seal = ed.createSpriteTools({
    res = "UI/alpha/1080P/activity/wukong/seal.png",
    pos = ccp(410, 51),
    parent = bg,
    notShow = param.taskState ~= 2
  })
  ed.createLabelTools({
    txt = T("\229\183\178\229\174\140\230\136\144"),
    size = 16,
    pos = ccp(50, 31),
    color = ccc3(77, 96, 71),
    parent = seal
  })
  local desc = ed.createLabelTools({
    txt = ed.activityTaskTool.getTaskDesc(param),
    size = 18,
    pos = ccp(30, 51),
    color = ccc3(66, 85, 60),
    anchor = ccp(0, 0.5),
    parent = bg
  })
  local target = ed.createLabelTools({
    txt = string.format("%s/%s", param._progress, param._cond_target),
    size = 18,
    pos = ccp(200, 51),
    color = ccc3(66, 85, 60),
    parent = bg
  })
  ed.setLabelDimensions(desc, CCSizeMake(120, 0))
  local button = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/button_com_mini.png",
    pos = ccp(410, 51),
    parent = bg,
    notShow = param.taskState == 2
  })
  button.txt = ed.createLabelTools({
    txt = T("\233\162\134\229\143\150"),
    size = 17,
    pos = ccp(50, 22),
    color = ccc3(253, 245, 169),
    parent = button
  })
  if param.taskState == 0 then
    button.txt:setString(T("\229\137\141\229\190\128"))
  end
  if param.taskState == 2 then
    desc:setColor(ccc3(231, 243, 210))
    target:setColor(ccc3(231, 243, 210))
  end
  local reward = param._rewards[1]
  local item = ed.taskItemModule.new(self, {
    id = reward._id,
    type = reward._type,
    amount = reward._amount
  }, nil, param._id, false, false, true)
  item.icon:setPosition(280, 51)
  bg:addChild(item.icon)
  item.icon:setScale(1)
  item:refresh(param.taskState)
  self.mainSelf:btRegisterButtonClick({
    button = button,
    key = "wukongPage_button_" .. self.index,
    clickInterval = 1,
    clickHandler = function()
      if self.param.taskState == 1 then
        self.mainSelf.objWork:activitySubmit(self.mainSelf.param._id, self.param._id)
      else
        if self.param._cond_type == "add_hero" or self.param._cond_type == "hero_evolve" then
          ed.UITool.openView("summonScene", {page = 1})
        else
          ed.activityTaskTool.taskSkip(self.param._cond_type, self.param._cond_id)
        end
        self.mainSelf.objWork:setEnterHandler(self.mainSelf.param._id)
      end
    end,
    force = true,
    pressScale = 0.95
  })
  self.ui = {
    bg = bg,
    seal = seal,
    desc = desc,
    target = target,
    item = item,
    button = button
  }
end

function itemBox:update(param, index)
  self.param = param
  self.index = index
  ed.setTexture(self.ui.bg, string.format("UI/alpha/1080P/activity/wukong/task_%s.png", self.imgType[param.taskState]))
  self.ui.target:setString(string.format("%s/%s", param._progress, param._cond_target))
  self.ui.seal:setVisible(param.taskState == 2)
  self.ui.button:setVisible(param.taskState ~= 2)
  if param.taskState == 0 then
    self.ui.button.txt:setString(T("\229\137\141\229\190\128"))
  else
    self.ui.button.txt:setString(T("\233\162\134\229\143\150"))
    ed.updateSpriteGray(self.ui.button, false)
    self.ui.button.txt:setColor(ccc3(253, 245, 169))
  end
  if param.taskState == 2 then
    self.ui.desc:setColor(ccc3(231, 243, 210))
    self.ui.target:setColor(ccc3(231, 243, 210))
  else
    self.ui.desc:setColor(ccc3(66, 85, 60))
    self.ui.target:setColor(ccc3(66, 85, 60))
  end
  self.ui.item:refresh(param.taskState)
end

function itemBox:btRegisterButtonClickToListItems(param)
  self.mainSelf:btRegisterButtonClick({
    button = param.button,
    key = "wukongPage_" .. param.index,
    param = param,
    clickInterval = 1,
    clickHandler = function(param, x, y)
      local data = param.data or {}
      ed.UITool.openView("packageDetail", data)
    end,
    force = true,
    pressScale = 0.95,
    normalScale = 1
  })
end

chooseWukongPage.itemBox = itemBox

function chooseWukongPage:createHeroFca(heroid)
  ed.asyncload.unregistLoadingListener()
  ed.asyncload.preloadFcaByUnitID(heroid)
  ed.asyncload.registLoadingListener(function()
    local newScene = ed.getCurrentScene()
    if newScene.identity == "activityScene" then
      local puppet, puppet_id, cha = ed.readhero.getActor(heroid, "Idle", true, false, 542, false)
      puppet:setPosition(50, 10)
      puppet:setScale(0.9)
      self:addFca(puppet)
      self.ui.Panel_mod:addChild(puppet, 99)
      ed.asyncload.unregistLoadingListener()
      self.puppet = puppet
      self.cha = cha
      local actions = {}
      local row = ed.getDataTable("AnimDuration")[self.cha]
      local can_show_action_tbl = {"Move"}
      local skill_items = ed.getDataTable("SkillGroup")[heroid]
      for idx, skill_item in pairs(skill_items or {}) do
        for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
          if string.find(action, "special") == nil then
            can_show_action_tbl[#can_show_action_tbl + 1] = action
          end
        end
      end
      for k, v in pairs(row or {}) do
        if ed.isElementInTable(k, can_show_action_tbl) then
          table.insert(actions, {
            act = k,
            time = v.Duration
          })
        end
      end
      self.actions = actions
      self:btRegisterButtonClick({
        button = self.ui.Panel_mod,
        key = "wukong_hero_puppet",
        force = true,
        mcpMode = true,
        pressScale = 0.96,
        clickHandler = function()
          if self.timeTig then
            return
          end
          local actions = ed.copyProto(self.actions)
          if self.oldIdx then
            table.remove(actions, self.oldIdx)
          end
          self.oldIdx = math.random(1, #actions)
          local action = actions[self.oldIdx].act
          self.puppet:setAction(action)
          self.puppet:setLoop(action == "Move")
          self.timeTig = true
          ed.heroDetailManager.listener.create():report("clickHeroFca", {
            hid = heroid,
            action = action,
            fashionId = 542
          })
          self:listenTimer(Timer:Once(actions[self.oldIdx].time), function()
            self.puppet:setAction("Idle")
            self.puppet:setLoop(true)
            self.timeTig = false
          end)
        end
      })
    end
  end)
end
