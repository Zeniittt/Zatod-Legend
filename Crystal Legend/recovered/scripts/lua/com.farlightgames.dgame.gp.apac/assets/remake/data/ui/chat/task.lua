module("ed", package.seeall)
Chatask = {}
Chatask.__index = Chatask
local ChataskScrop = {}

function Chatask.EnterChatask(parent)
  ui.chatask = Chatask.Create(parent)
  ui.chatasknetmgr = ChataskNetMgr.Create()
end

function Chatask.Create(parent)
  local chatask = {}
  setmetatable(chatask, Chatask)
  chatask.parent = parent
  chatask:RegisterEvents()
  return chatask
end

function Chatask:InitData(proto_task)
  self.ui = nil
  self.container = nil
  self.draglist = nil
  self.task_uis = {}
  self.task_containers = {}
  self.reward_ui = {}
  self.list_pos = self.list_pos
  self.energy_limit = self.energy_limit or 0
  self.energy = proto_task._cur_energy or 0
  self.tasks = proto_task._task_items or {}
  self:SortTasks()
end

function Chatask:SortTasks()
  local function comparator(task_a, task_b)
    local a, b = task_a._task_item, task_b._task_item
    
    return b._start_time < a._start_time
  end
  
  table.sort(self.tasks, comparator)
end

function Chatask:InitAppearance()
  self:LoadTaskFrameUI()
  self:InitEnergyValue()
  self:CreateDraglist()
  self:InitListContent()
  if self.list_pos then
    self.draglist:setListPos(self.list_pos)
  end
end

function Chatask:InitEnergyValue()
  if 0 == self.energy_limit then
    local control_tbl = ed.getDataTable("GuildHeroControl")
    self.energy_limit = control_tbl[1]["Max Energy"]
  end
  self.ui.lb_energy:setString(T("%d/%d", self.energy, self.energy_limit))
end

function Chatask:LoadTaskFrameUI()
  local ui_res = ed.uieditor.guildherochattask
  local container, ui = ed.editorui(ui_res)
  self.parent:addChild(container)
  self.ui = ui
  self.container = container
end

function Chatask:CreateDraglist()
  local w, h = self.parent:getContentSize().width, self.parent:getContentSize().height
  local info = {
    cliprect = CCRectMake(0, 1, w, h),
    container = self.container,
    noshade = true,
    priority = -505
  }
  local draglist = ed.draglist.create(info)
  draglist:initListHeight(170 * #self.tasks)
  self.draglist = draglist
end

function Chatask:InitListContent()
  for idx, task in pairs(self.tasks) do
    local container, ui = self:LoadTaskItemUI()
    container:setPosition(ccp(0, 190 - 170 * idx))
    local task_state = self:GetTaskState(idx)
    local summary = self:CreatePlayerSummary2(task._summary, task_state)
    summary:setPosition(ccp(0, 160))
    ui.layer_item:addChild(summary)
    if self.energy < 100 then
      ui.lb_price:setColor(ccc3(255, 0, 0))
    end
    self:InitTimeContent(idx)
    self:InitRewardCotent(idx)
    self:InitProgressCotent(idx)
    self.draglist:addItem(container)
  end
end

function Chatask:LoadTaskItemUI()
  local ui_res = ed.uieditor.guildherochatitem
  local container, ui = ed.editorui(ui_res)
  self.task_uis[#self.task_uis + 1] = ui
  self.task_containers[#self.task_containers + 1] = container
  local draglist = self.draglist
  draglist:setFrameRect(container, container:boundingBox())
  draglist:setParentClipNode(container, draglist.listLayer)
  return container, ui
end

local task_state = {
  unknown = "unknown",
  running = "running",
  finished = "finished",
  invalid = "invalid"
}

function Chatask:GetTaskState(idx)
  local task = self.tasks[idx]
  local task_item = task._task_item
  local server_time = ed.getServerTime()
  if server_time > task_item._end_time then
    local finished = task_item._current_energy == task_item._needed_energy
    if finished then
      return task_state.finished
    else
      return task_state.invalid
    end
  elseif task_item._self_energy > 0 then
    return task_state.running
  else
    return task_state.unknown
  end
end

local state2pic = {
  unknown = "",
  running = "UI/alpha/HVGA/GuildHero/Guildhero_join.png",
  finished = "UI/alpha/HVGA/GuildHero/guildhero_complete.png",
  invalid = "UI/alpha/HVGA/GuildHero/guildhero_invaild.png"
}

function Chatask:CreatePlayerSummary(summary, state)
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.6,
    name = summary._name,
    babelLevel = summary._babel_level,
    vip = summary._vip > 0,
    config = {levelposition = 5, nameposition = 40}
  }
  if summary._medal then
    param.medal = summary._medal
  end
  local player_summary = ed.getWholeHeadIcon(param)
  if state ~= task_state.unknown then
    local tag = CCSprite:create(state2pic[state])
    tag:setPosition(ccp(255, 3))
    player_summary:addChild(tag)
  end
  return player_summary
end

function Chatask:CreatePlayerSummary2(summary, state)
  local sp = CCSprite:create()
  local ui = {}
  ed.editorui(ed.uieditor.chat_content_left, {container = sp, ui = ui})
  self:createHeadIcon(ui, summary, false)
  if state ~= task_state.unknown then
    local tag = CCSprite:create(state2pic[state])
    tag:setScale(0.8)
    tag:setPosition(ccp(255, 23))
    ui.content_bg:addChild(tag)
  end
  return sp
end

function Chatask:createHeadIcon(ui, summary, isSelf)
  local speakerSummary = summary
  local param = {
    id = speakerSummary._avatar
  }
  ui.lable_time:setString(" ")
  local headIcon = ed.getWholeHeadIcon(param)
  headIcon:setScale(0.57)
  headIcon:setPosition(ccp(25, 25))
  ui.hero_icon:addChild(headIcon)
  ui.lable_player_name:setString(speakerSummary._name)
  ui.labl_player_level:setString(speakerSummary._level)
  local levelBgRes
  levelBgRes = ed.getLevelBg(speakerSummary._babel_level, speakerSummary._vip, levelBgRes)
  if levelBgRes then
    ui.labl_player_level:setString(speakerSummary._babel_level)
    ui.img_player_level:setVisible(false)
    ui.img_player_babel:setVisible(true)
  end
  if speakerSummary._medal and speakerSummary._medal.medal_id ~= 0 then
    local medal_id = speakerSummary._medal.medal_id
    local allTitles = ed.getDataTable("Medal")
    local meadl_info = allTitles[medal_id]
    if meadl_info then
      local res = meadl_info.Picture
      local icon = ed.createSprite(res)
      local x, y = ui.lable_player_name:getPosition()
      local width = icon:getContentSize().width * 0.2
      icon:setScale(0.5)
      icon:setPosition(ccp(x + 13, y))
      ui.lable_player_name:setPosition(ccp(x + width + 13, y))
      ui.content_bg:addChild(icon)
    end
  end
end

function Chatask:InitTimeContent(idx)
  local ui = self.task_uis[idx]
  local task = self.tasks[idx]._task_item
  if 1 == task._started then
    if ed.getServerTime() > task._end_time then
      ui.lb_time:setString("")
    else
      ui.lb_time:setString(ed.guildhero.StringRes.Task_Performing)
    end
  elseif 0 == task._started then
    local left = task._end_time - ed.getServerTime()
    if left < 0 then
      ui.lb_time:setString("")
    else
      ui.lb_time:setString(ed.gethmsNString(left) .. T("\229\144\142\229\164\177\230\149\136"))
      self:Tick(idx)
    end
  end
end

function Chatask:Tick(idx)
  local ui = self.task_uis[idx]
  local task = self.tasks[idx]._task_item
  local left = task._end_time - ed.getServerTime()
  ListenTimer(Timer:Always(1, "chatask_" .. task._id), function()
    left = left - 1
    if 0 < left then
      ui.lb_time:setString(ed.gethmsNString(left) .. T("\229\144\142\229\164\177\230\149\136"))
    else
      FireEvent("ChataskTaskRequest")
    end
  end)
end

function Chatask:InitRewardCotent(idx)
  local ui = self.task_uis[idx]
  local rewards = self.tasks[idx]._task_item._rewards
  local uis = {}
  local offset = 10
  local box = ui.lb_reward_res:boundingBox()
  local sx = box.origin.x + box.size.width
  local sy = box.origin.y + box.size.height / 2
  for idx, reward in pairs(rewards) do
    local container, node, label = self:CreateRewardIconWithAmount(reward, 30, 18)
    ui.layer_item:addChild(container)
    container:setPosition(ccp(sx + offset, sy))
    box = container:boundingBox()
    sx = box.origin.x + box.size.width + 10
    sy = box.origin.y + box.size.height / 2
    uis[idx] = {node = node, label = label}
  end
  self.reward_ui[idx] = uis
end

function Chatask:CreateRewardIconWithAmount(reward, icon_side, label_size)
  local type = ed.reward.getRewardType(reward._type)
  local flag = ed.isElementInTable(type, {"Item", "Hero"})
  local node = flag and ed.readequip.createIcon(reward._id, icon_side) or ed.readequip.getResourceIcon(type)
  local label = ed.createNode({
    t = "Label",
    base = {
      text = T("x%s", reward._amount),
      size = label_size
    },
    config = {
      color = ccc3(241, 193, 113)
    },
    layout = {
      anchor = ccp(0, 0.5)
    }
  })
  local container = CCSprite:create()
  container:addChild(node)
  container:addChild(label)
  local box = node:boundingBox()
  local x = box.origin.x + box.size.width
  local y = box.origin.y + box.size.height / 2
  label:setPosition(ccp(x, y))
  return container, node, label
end

function Chatask:InitProgressCotent(idx)
  local ui = self.task_uis[idx]
  local task = self.tasks[idx]._task_item
  local txt = T("%d/%d", task._current_energy, task._needed_energy)
  ui.lb_progress_des:setString(txt)
  if task._current_energy == task._needed_energy then
    ui.layer_progress_container:removeClipRect()
  else
    local ratio = task._current_energy / task._needed_energy
    local rect = CCRectMake(2, 5.9, 224.22 * ratio, 15)
    ui.layer_progress_container:setClipRect(rect)
  end
end

function Chatask:RegisterTouchHandler()
  local touch_info = {
    is_multi = false,
    priority = -505,
    swallow = false
  }
  local touch_layer = self.container
  local touch_monitor = ed.guildhero.NewTouchEventMonitor(touch_info, touch_layer)
  for idx, ui in pairs(self.task_uis) do
    touch_monitor:btRegisterButtonClick({
      button = ui.btn_add_energy,
      press = ui.btn_add_energy_press,
      key = "btn_add_energy" .. idx,
      clickHandler = function()
        self:AddEnergyClick(idx)
      end,
      force = true,
      mcpMode = true,
      clickInterval = 0.5
    })
  end
end

function Chatask:AddEnergyClick(idx)
  local state = self:GetTaskState(idx)
  if state == task_state.finished then
    ed.showToast(T("\232\175\165\228\187\187\229\138\161\229\183\178\231\187\143\229\174\140\230\136\144!"))
    return
  end
  if state == task_state.invalid then
    ed.showToast(T("\232\175\165\228\187\187\229\138\161\229\183\178\231\187\143\229\164\177\230\149\136!"))
    return
  end
  if self.energy < 100 then
    ed.showAlertDialog({
      text = ed.guildhero.StringRes.ALack_Energy
    })
    return
  end
  local x, y = self.draglist:getListPos()
  self.list_pos = ccp(x, y)
  local id = self.tasks[idx]._task_item._id
  FireEvent("ChataskAddEnergyRequest", id)
end

function Chatask:RegisterEvents()
  ListenEvent("ChataskTaskReply", function(proto_task)
    self:RefreshTask(proto_task)
  end, ChataskScrop)
  ListenEvent("ChataskAddEnergyReply", function(proto_add_energy)
    self:DoAddEnergy(proto_add_energy)
  end, ChataskScrop)
end

function Chatask:RefreshTask(proto_task)
  self:Clear()
  self:InitData(proto_task)
  self:InitAppearance()
  self:RegisterTouchHandler()
end

function Chatask:DoAddEnergy(proto_add_energy)
  if "task_success" ~= proto_add_energy._result then
    ed.showToast(ed.guildhero.NetResult[proto_add_energy._result])
  end
  self:RefreshTask(proto_add_energy._task)
end

function Chatask:Clear()
  if self.container then
    self.container:removeFromParentAndCleanup(true)
    self.container = nil
  end
  for _, task in pairs(self.tasks or {}) do
    CloseTimer("chatask_" .. task._task_item._id)
  end
end

function Chatask:Destroy()
  ui.chatask = nil
  CloseScope(ChataskScrop)
end
