local heroPage = {}
ed.ui.activityHeroPage = heroPage

function heroPage.create(base, param, pageKey)
  local this = {}
  setmetatable(heroPage, {__index = base})
  setmetatable(this, {__index = heroPage})
  local uiConfig = ed.uieditor.activity_hero_page
  if param._extend and param._extend._tag == "v2" then
    uiConfig = ed.copyProto(uiConfig)
    for i, v in ipairs(uiConfig) do
      if v.t == "Sprite" or v.t == "Scale9Sprite" then
        v.base.res = string.gsub(v.base.res, "/hero_gift/", "/hero_gift_v2/")
      end
    end
  end
  local container, ui = ed.editorui(uiConfig)
  this.ui = ui
  this.param = param
  this.pageKey = pageKey or ""
  this.container = container
  this:setButtonClick()
  local task = param._tasks
  task = task[1] or {}
  this:initUI(task)
  this:initLabel(task)
  return this
end

function heroPage:pageUpDate(param)
  self.param = param
  local task = param._tasks
  task = task[1] or {}
  self:initLabel(task)
end

function heroPage:initLabel(task)
  local stageTable = ed.getDataTable("Stage")
  local row = stageTable[task._cond_id]
  local Chapter = row["Chapter ID"]
  local stages = ed.player:getStageProgress()
  local row = stageTable[stages] or {}
  local Chapter2 = row["Chapter ID"] or 0
  task._progress = stages - 1
  Chapter2 = Chapter2 - 1
  self.ui.Label_114:setString(T("\229\133\141\232\180\185\233\162\134\229\143\150 %s", self.param.endTimeStr or 0))
  self.isCompleted = nil
  self.ui.Label_118:setString(T("\233\128\154\229\133\179\230\136\152\229\189\185\231\172\172%s\231\171\160\229\144\142\229\143\175\229\133\141\232\180\185\233\162\134\229\143\150", Chapter))
  ed.adaptLabel(self.ui.Label_118, {maxWidth = 210, minScale = 0.8})
  self.ui.Label_118_Copy0:setString(T("\229\183\178\233\128\154\229\133\179\239\188\154\231\172\172%s\231\171\160", Chapter2))
  local str = "\230\156\170\232\190\190\230\136\144"
  local isCompleted = task._progress >= task._cond_id
  local isFinished = task._cur_reward_times and task._cur_reward_times >= task._max_reward_times
  if isFinished then
    str = "\229\183\178\233\162\134\229\143\150"
  elseif isCompleted then
    str = "\229\143\175\233\162\134\229\143\150"
    self.isCompleted = true
  end
  self.itemEff:setVisible(self.isCompleted)
  if self.isCompleted then
    self.itemEff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
  else
    self.itemEff:stopAllActions()
  end
  self.ui.Label_120:setString(T(str))
  self.ui.Label_120:setFontName(ed.fontBold)
  if isCompleted or isFinished then
    ed.setLabelColor(self.ui.Label_120, ed.toccc3(7405396))
    ed.setLabelStroke(self.ui.Label_120, ed.toccc3(1519903), 1)
  else
    ed.setLabelColor(self.ui.Label_120, ed.toccc3(16774029))
    ed.setLabelStroke(self.ui.Label_120, ed.toccc3(12148761), 1)
  end
  self.tick:setVisible(isFinished)
  self.ui.btn_goto_stage:setVisible(not isCompleted and not isCompleted)
  self.ui.Label_118_Copy0:setVisible(not isCompleted and not isCompleted)
end

function heroPage:initUI(task)
  self:createHeroFca()
  if self.param and self.param.openType then
    self.ui.ImageView_112:setVisible(self.param.openType ~= "Open Svr")
  end
  if task._rewards then
    local items = {}
    for i, v in ipairs(task._rewards) do
      table.insert(items, {
        id = v._id,
        count = v.count or 1,
        type = v._type or "item"
      })
    end
    self.heroid = items[1].id
    local icon = ed.createItemIcon(items[1])
    icon:setPosition(48, 47)
    icon:setScale(1)
    self.ui.Panel_116:addChild(icon)
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    eff:setPosition(48, 47)
    self.ui.Panel_116:addChild(eff, 9)
    self.itemEff = eff
    local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
    tick:setPosition(30, 25)
    tick:setVisible(false)
    icon:addChild(tick)
    self.tick = tick
    self:btRegisterButtonClick({
      button = icon,
      key = "hero_icon",
      force = true,
      mcpMode = true,
      pressScale = 0.96,
      clickHandler = function()
        if self.isCompleted then
          self.objWork:activitySubmit(self.param._id, task._id)
        elseif items[1].type == "item" then
          ed.ui.packageDetailWin.create({
            id = items[1].id,
            type = "item"
          }):popWindow()
        end
      end
    })
  end
  self.ui.ImageView_113:setPositionX(self.ui.ImageView_113:getPositionX() - ed.display.halfFixedWidth / 2)
end

function heroPage:createHeroFca()
  ed.asyncload.unregistLoadingListener()
  ed.asyncload.preloadFcaByUnitID(self.heroid or 61)
  ed.asyncload.registLoadingListener(function()
    local newScene = ed.getCurrentScene()
    if newScene.identity == "activityScene" then
      local puppet, cha = ed.readhero.getActor(self.heroid, "Idle", true, false, nil, false)
      local row = ed.getDataTable("Puppet")[cha]
      local scale = row.Scale
      local wscale = row["Window Scale"]
      if wscale ~= 0 then
        scale = scale * wscale
      end
      puppet:setScale(scale)
      puppet:setPosition(35, 10)
      self.ui.Panel_hero:addChild(puppet, 10)
      self:addFca(puppet)
      ed.asyncload.unregistLoadingListener()
      self.puppet = puppet
      self.cha = cha
      local actions = {}
      local row = ed.getDataTable("AnimDuration")[self.cha]
      local can_show_action_tbl = {"Move"}
      local skill_items = ed.getDataTable("SkillGroup")[self.heroid]
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
        button = self.ui.Panel_hero,
        key = "Panel_hero",
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

local actionTab = {
  "ult",
  "atk",
  "atk3",
  "atk2"
}
local action = "Idle"

function heroPage:setPuppetAction()
  if self.timeTig then
    return
  end
  self.timeTig = true
  local tab = {}
  for i, v in ipairs(actionTab) do
    if action ~= v then
      table.insert(tab, v)
    end
  end
  action = tab[math.random(1, #tab)]
  self.puppet:setAction(action)
  self.puppet:setLoop(action == "Move")
  self:listenTimer(Timer:Once(1), function()
    action = "Idle"
    self.puppet:setAction(action)
    self.puppet:setLoop(true)
    self.timeTig = false
  end)
end

function heroPage:setButtonClick()
  self:btRegisterButtonClick({
    button = self.ui.btn_goto_stage,
    key = "go_stage",
    force = true,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8,
    clickHandler = function()
      ed.pushScene(ed.ui.stageselect.create())
      self.objWork:setEnterHandler(self.param._id)
    end
  })
end
