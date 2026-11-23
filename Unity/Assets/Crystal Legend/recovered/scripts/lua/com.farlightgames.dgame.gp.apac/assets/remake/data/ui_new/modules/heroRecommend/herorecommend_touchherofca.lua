module("ed.herorecommend", package.seeall)
touchherofca = {}
touchherofca.__index = touchherofca

function touchherofca.create(data)
  local object = {}
  setmetatable(object, touchherofca)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function touchherofca:initData(data)
  self.heroid = data.heroid
  self.window = data.window
  self.touchNode = data.window.touch_node
end

function touchherofca:initAppearence()
  local heroData = ed.player.heroes[self.heroid]
  local awake = heroData and heroData._arousal and heroData._arousal._status == 1
  local fca = manager:createFcaActor(self.heroid, awake)
  self.window.ui.panel_fca_point:addChild(fca)
  self.touchNode:addFca(fca)
  self.fca = fca
  self.action_pre = "Idle"
end

function touchherofca:registerTouchHandler()
  self.touchNode:btRegisterRectClick({
    rect = CCRectMake(20, 60, 160, 195),
    parent = self.window.ui.panel_herofca,
    key = "hero_fca_touch",
    clickHandler = function()
      self:ChangeFcaAction()
    end,
    force = true
  })
end

function touchherofca:ChangeFcaAction(name)
  local action, duration = self:changeAction(name)
  self.touchNode:registerUpdateHandler("CheckFcaHandler", self:CheckFcaHandler(action, duration))
end

function touchherofca:CheckFcaHandler(action, duration)
  local count = 0
  
  local function handler(dt)
    count = count + dt
    if action ~= "Move" and count > duration then
      self:playIdle()
      self.touchNode:removeUpdateHandler("CheckFcaHandler")
    end
  end
  
  return handler
end

function touchherofca:playIdle()
  if not tolua.isnull(self.fca) then
    self.fca:setAction("Idle")
    self.fca:setLoop(true)
  end
end

function touchherofca:changeAction()
  local unit_row = ed.getDataTable("Unit")[self.heroid]
  local cha = unit_row.Puppet
  local row = ed.getDataTable("AnimDuration")[cha]
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.heroid]
  local can_show_action_tbl = {"Move"}
  for idx, skill_item in pairs(skill_items or {}) do
    local hero = ed.player.heroes[self.heroid]
    if hero and hero._arousal and 1 == hero._arousal._status then
      for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
        if string.find(action, "special") == nil then
          can_show_action_tbl[#can_show_action_tbl + 1] = action
        end
      end
    elseif not skill_item.Awake then
      for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
        if string.find(action, "special") == nil then
          can_show_action_tbl[#can_show_action_tbl + 1] = action
        end
      end
    end
  end
  for k, v in pairs(row or {}) do
    if ed.isElementInTable(k, can_show_action_tbl) and k ~= self.action_pre then
      table.insert(actions, k)
      table.insert(dur, v.Duration)
    end
  end
  local index = math.random(1, #actions)
  local action = actions[index]
  self.action_pre = action
  local duration = dur[index]
  self.fca:setAction(action)
  self.fca:setLoop(action == "Move")
  return action, duration
end
