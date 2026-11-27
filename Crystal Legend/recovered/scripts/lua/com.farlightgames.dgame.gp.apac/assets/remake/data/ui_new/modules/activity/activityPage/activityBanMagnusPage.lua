local class = {}
ed.ui.activityBanMagnusPage = class

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.serverCanGetReward = false
  self.banItemId = 20704
  self:initView()
  self:registerEvents()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activityBanMagnusPage)
  self.container = container
  self.ui = ui
  local spark = ed.createFcaNode("eff_UI_fancytower_particle_str")
  ed.layout.centerInScreen(spark)
  self.ui.bg:addChild(spark)
  self:addFca(spark)
  self:initLabel()
  self:initRewards()
  self:refreshTask()
  self:initHero()
  self:adaptUI()
  self.objWork:activityPull(self.activityId)
end

function class:initLabel()
  ed.setLabelFontName(self.ui.got_reward_label, ed.fontBold)
  ed.setLabelFontName(self.ui.total_cnt_label, ed.fontBold)
  ed.setLabelFontName(self.ui.server_target_label, ed.fontBold)
  ed.setLabelStroke(self.ui.server_target_label, ed.toccc3(8600851), 1)
  ed.setLabelStroke(self.ui.ban_one_label, ed.toccc3(10737913), 2)
  ed.setLabelStroke(self.ui.ban_ten_label, ed.toccc3(16772258), 2)
  local gra_ban_one = ed.ui.gradientLabel.create({
    text = "BAN",
    startColor = ed.toccc3(2049900),
    endColor = ed.toccc3(2384282),
    fontSize = 21,
    fontName = ed.fontBold,
    strokeColor = ed.toccc3(10737913),
    strokeSize = 2
  })
  self.ui.ban_one_pos:addChild(gra_ban_one.node)
  local gra_ban_ten = ed.ui.gradientLabel.create({
    text = "BAN",
    startColor = ed.toccc3(6371599),
    endColor = ed.toccc3(11160340),
    fontSize = 21,
    fontName = ed.fontBold,
    strokeColor = ed.toccc3(16772258),
    strokeSize = 2
  })
  self.ui.ban_ten_pos:addChild(gra_ban_ten.node)
  local gra_total_ban = ed.ui.gradientLabel.create({
    text = T("\231\180\175\232\174\161"),
    startColor = ed.toccc3(16709544),
    endColor = ed.toccc3(16770405),
    fontSize = 16,
    fontName = ed.fontBold,
    strokeColor = ed.toccc3(4069131),
    strokeSize = 1.5
  })
  self.ui.role_progress_icon:addChild(gra_total_ban.node)
  local iconSize = self.ui.role_progress_icon:getContentSize()
  gra_total_ban.node:setPosition(ccp(iconSize.width * 0.5, 7))
  local server_progress_tip = ed.ui.autoText.new()
  server_progress_tip:initParam({
    context = T("<lable color=ccc3(250,243,113)>\229\133\168\230\156\141</lable>BAN\231\140\155\231\138\184\232\167\163\233\148\129\233\153\144\229\174\154\229\164\150\232\167\130\239\188\140\229\183\178BAN%s\230\172\161\227\128\130", "<sprite name=progressBg src=UI/alpha/1080P/activity/ban_magnus/ban_magnus_server_progress_text_bg.png>"),
    color = ed.toccc3(16577493),
    fontSize = 15,
    maxWidth = 410,
    align = "CENTER"
  })
  self.ui.server_progress_tips:addChild(server_progress_tip.node)
  server_progress_tip.node:setPosition(ccp(-205, 0))
  self.server_progress_tip = server_progress_tip
  self.server_progress_label_node = nil
  self.server_progress_bg_node = server_progress_tip.spriteNode.progressBg
  if self.server_progress_bg_node then
    self.server_progress_label_node = ed.createLabelTTF("12345678", 15)
    ed.setLabelColor(self.server_progress_label_node, ed.toccc3(16446321))
    self.server_progress_bg_node:addChild(self.server_progress_label_node)
    ed.layout.centerInParent(self.server_progress_label_node)
  end
  local barSize = self.ui.role_progress_bar:getContentSize()
  self.ui.role_progress_bar:setContentSize(CCSizeMake(550, barSize.height))
end

function class.getFrameId(RewardId)
  for id, v in pairs(ed.getDataTable("AvatarFrame")) do
    if v["Requirement ID"] == RewardId then
      return id
    end
  end
end

function class.getAvatarId(RewardId)
  for id, v in pairs(ed.getDataTable("Avatar")) do
    if v["Requirement ID"] == RewardId then
      return id
    end
  end
end

function class.createAvatarIcon(avatarId)
  local avatars = ed.getDataTable("Avatar")
  local data
  for id, avatar in pairs(avatars) do
    if type(id) == "number" and id == avatarId then
      data = {
        key = id,
        res = avatar.Picture,
        desc = avatar.Description,
        name = avatar.Name,
        rank = avatar["Display Rank"],
        fca = avatar["Dynamic Model"],
        spine = avatar["Spine Dynamic Model"],
        scale = avatar.Scale > 0 and avatar.Scale or 1,
        type = avatar.Type
      }
      if avatar["Requirement Type"] == "HaveItem" and avatar["Requirement ID"] ~= 0 then
        local equipTableItem = ed.getDataTable("equip")[avatar["Requirement ID"]]
        if nil ~= equipTableItem then
          data.rank = equipTableItem.Quality
        end
      end
    end
  end
  local res = ed.getFashionFrameResByQuality(data.rank or 1, "avatarFrame")
  local frame = ed.createSprite(res)
  local size = frame:getContentSize()
  local x, y = size.width / 2, size.height / 2
  local icon
  if data.spine then
    local clipLayer = CCLayer:create()
    clipLayer:setClipRect(CCRectMake(10, 10, size.width - 20, size.height - 20))
    icon = ed.createSpineEffect(data.spine)
    icon:setAnimation(0, "Idle", true)
    clipLayer:addChild(icon)
    icon:setPosition(x, y)
    frame:addChild(clipLayer, -1)
    icon:setScale(data.scale or 1)
  elseif data.fca then
    local clipLayer = CCLayer:create()
    clipLayer:setClipRect(CCRectMake(10, 10, size.width - 20, size.height - 20))
    icon = ed.createFcaNode(data.fca)
    self:addFca(icon)
    clipLayer:addChild(icon)
    icon:setPosition(x, y)
    frame:addChild(clipLayer, -1)
    icon:setScale(data.scale or 1)
  elseif data.res then
    icon = ed.createSprite(data.res)
    frame:addChild(icon, -1)
    icon:setPosition(x, y)
  end
  return frame
end

function class:checkServerProgressComplete()
  for _, task in ipairs(self.tasks or {}) do
    if task._cond_type == "global_assist_progress" then
      return task._progress >= task._cond_target
    end
  end
  return false
end

function class:initRewards()
  local tasks = self:getActivityTask()
  if not tasks then
    return
  end
  self.tasks = tasks
  self.role_tasks = {}
  for _, task in ipairs(tasks) do
    if task._cond_type == "assist_progress" then
      self.role_progress = task._progress
      table.insert(self.role_tasks, self.roleRewardItem.create(self, {task = task}))
    elseif task._cond_type == "global_assist_progress" then
      for i = 1, 2 do
        local reward = task._rewards[i]
        local frameId = self.getFrameId(reward._id)
        local avatarId = self.getAvatarId(reward._id)
        local icon
        if frameId then
          icon = ed.createSprite("UI/alpha/1080P/activity/ban_magnus/ban_magnus_reward_avatar_frame_bg.png")
          local itemNode, itemIcon = ed.getHeadFrame({id = frameId, hide_icon_when_dyna = true})
          icon.frameIcon = itemIcon
          icon:addChild(itemNode)
          ed.layout.centerInParent(itemNode)
        elseif avatarId then
          icon = self.createAvatarIcon(avatarId)
        else
          icon = ed.createItemIcon({
            id = reward._id,
            type = reward._type,
            amount = reward._amount
          })
        end
        self.ui["reward_bg" .. i]:addChild(icon)
        ed.layout.centerInParent(icon)
        self.ui["reward_bg" .. i .. "_icon"] = icon
        self:btRegisterButtonClick({
          button = self.ui["reward_bg" .. i],
          key = "get_server_reward" .. i,
          clickHandler = function(_, x, y)
            self:getServerReward(task, reward)
          end,
          clickInterval = 1
        })
      end
    end
  end
  local taskNum = #self.role_tasks
  self.totalLen = 550
  self.firstLen = 100
  self.seqLen = (self.totalLen - self.firstLen) / (taskNum - 1)
  local posX, posY = self.firstLen, 3.5
  for i = 1, taskNum do
    self.ui.role_progress_bg:addChild(self.role_tasks[i].container)
    self.role_tasks[i].container:setPosition(ccp(posX, posY))
    posX = posX + self.seqLen
  end
  local progress_spine = ed.createSpine("effect/eff_UI_Ban_Magnus_Progress/eff_UI_Ban_Magnus_Progress", 0.4)
  progress_spine:setVisible(false)
  self.ui.server_progress_bar:addChild(progress_spine)
  self.spine = progress_spine
end

function class:getServerReward(task, reward)
  if self.canGetServerReward then
    self.objWork:activitySubmit(self.activityId, task._id)
    self.objWork:activityPull(self.activityId)
  else
    ed.ui.packageDetailWin.create({
      id = reward._id,
      type = reward._type
    }):popWindow()
  end
end

function class:refreshTask()
  ed.setLabelString(self.ui.item_cnt_label, ed.player:getEquipAmount(self.banItemId))
  for _, task in ipairs(self.tasks) do
    if task._cond_type == "assist_progress" then
      self.role_progress = task._progress
      for i, taskItem in ipairs(self.role_tasks) do
        if taskItem.task._id == task._id then
          taskItem:refreshUI(task)
        end
      end
    elseif task._cond_type == "global_assist_progress" then
      ed.setLabelString(self.ui.server_target_label, ed.formatNumber(task._cond_target))
      if self.server_progress_label_node then
        ed.setLabelString(self.server_progress_label_node, task._progress)
      end
      local wid = 10 + 284 * math.min(task._progress / task._cond_target, 1)
      local barSize = self.ui.server_progress_bar:getContentSize()
      self.ui.server_progress_bar:setContentSize(CCSizeMake(wid, barSize.height))
      if self.showBANProgressSpine and 21 < wid and wid < 294 then
        self.showBANProgressSpine = nil
        self.spine:setPosition(ccp(wid - 10, 4.5))
        self.spine:setVisible(true)
        self.spine:setAnimation(0, "Idle", false)
      end
      local gotTarget = task._cond_target <= task._progress
      local gotReward = task._cur_reward_times >= task._max_reward_times
      self.canGetServerReward = not gotReward and gotTarget
      self.ui.got_reward_bg:setVisible(gotReward)
      self.serverCanGetReward = gotTarget and not gotReward
      for i = 1, 2 do
        local reward = task._rewards[i]
        local frameId = self.getFrameId(reward._id)
        local avatarId = self.getAvatarId(reward._id)
        local icon = self.ui["reward_bg" .. i .. "_icon"]
        if not icon.maskNode then
          icon.maskNode = CCNode:create()
          icon:addChild(icon.maskNode)
          ed.layout.centerInParent(icon.maskNode)
        end
        icon.maskNode:removeAllChildrenWithCleanup(true)
        if gotReward then
          if frameId then
            icon:setColor(ccc3(127, 127, 127))
            icon.frameIcon:setColor(ccc3(127, 127, 127))
          else
            local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
            icon.maskNode:addChild(mask)
          end
          local iconSize = icon:getContentSize()
          local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
          icon.maskNode:addChild(tick)
        elseif gotTarget then
          local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
          icon.maskNode:addChild(eff)
          ed.layout.centerInParent(eff)
          eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
        else
          local light = ed.createFcaNode("eff_UI_legendequip_Get_light2_1")
          light:setActionSpeeder(1 + 0.1 * (i - 1))
          light:setScale(0.9)
          self:addFca(light)
          icon.maskNode:addChild(light)
        end
      end
    end
  end
  local maxTarget = 0
  local taskNum = #self.role_tasks
  local lastTarget = 0
  local len = 14
  for i = 1, taskNum do
    local target = self.role_tasks[i].task._cond_target
    maxTarget = math.max(maxTarget, target)
    local seq = i == 1 and self.firstLen - 14 or self.seqLen
    local ratio = (math.min(self.role_progress, target) - lastTarget) / (target - lastTarget)
    len = len + ratio * seq
    if target > self.role_progress then
      break
    end
    lastTarget = target
  end
  ed.setLabelString(self.ui.total_cnt_label, math.min(self.role_progress, maxTarget))
  local barSize = self.ui.role_progress_bar:getContentSize()
  self.ui.role_progress_bar:setContentSize(CCSizeMake(len, barSize.height))
end

function class:adaptUI()
  ed.UITool.setPositionBy(self.ui.magnus_bg, ccp(-ed.display.halfFixedWidth * 0.4, 0))
  ed.UITool.setPositionBy(self.ui.role_progress_layer, ccp(-ed.display.halfFixedWidth * 0.6, 0))
  ed.layout.layoutWithMagin(self.ui.item_bg, {
    top = 15 + ed.display.halfFixedHeight,
    right = 200 + ed.display.halfFixedWidth
  })
end

function class:setVisibleCallBack(visible)
  if visible then
    self.objWork:activityPull(self.activityId)
    local initAction = self:checkServerProgressComplete() and "Death" or "Cheer"
    self:changeAction(initAction)
  else
    CloseScope(self.heroFcaScope)
  end
end

function class:registerEvents()
  self:refreshLeftTime()
  self:listenTimer(Timer:Always(1), function()
    self:refreshLeftTime()
  end)
  self:registerBtnClick("btn_ban_one", function()
    if ed.player:getEquipAmount(self.banItemId) < 1 then
      ed.showToast(T("\233\129\147\229\133\183\228\184\141\232\182\179\239\188\140\229\143\175\229\137\141\229\190\128\230\136\152\229\189\185\230\140\145\230\136\152/\230\137\171\232\141\161\229\133\179\229\141\161\232\142\183\229\190\151\227\128\130"))
      return
    end
    self.costItemNum = 1
    ed.ActivityNetwork.sendBanMagnusBoostReq(self.activityId, 1)
    self:changeAction("BAN_1")
  end)
  self:registerBtnClick("btn_ban_ten", function()
    if ed.player:getEquipAmount(self.banItemId) < 10 then
      ed.showToast(T("\233\129\147\229\133\183\228\184\141\232\182\179\239\188\140\229\143\175\229\137\141\229\190\128\230\136\152\229\189\185\230\140\145\230\136\152/\230\137\171\232\141\161\229\133\179\229\141\161\232\142\183\229\190\151\227\128\130"))
      return
    end
    self.costItemNum = 10
    ed.ActivityNetwork.sendBanMagnusBoostReq(self.activityId, 10)
    self:changeAction("BAN_2")
  end)
  self:registerBtnClick("item_icon", function()
    ed.ui.packageDetailWin.create({
      id = self.banItemId
    }):popWindow()
  end)
  self:listenEvent("scope_activity_reply", function(info)
    if info._assist then
      self:handleBanMagnusBoost(info._assist)
    end
  end)
end

function class:handleBanMagnusBoost(data)
  if data._act_id then
    ed.player:consumeEquip(self.banItemId, self.costItemNum)
    self.showBANProgressSpine = true
    self.objWork:activityPull(self.activityId)
  end
end

function class:getActivityTask()
  local activityList = ed.activityHints.data:getActivityInfoByType("all_server_assist")
  if not activityList then
    return nil
  end
  for _, activityData in ipairs(activityList or {}) do
    local startTime = activityData._start_time
    local endTime = activityData._end_time
    local serverTime = ed.getServerTime()
    if startTime <= serverTime and endTime >= serverTime then
      self.activityData = activityData
      self.tasks = activityData._tasks
      self.endTime = activityData._end_time
      self.activityId = activityData._id
      self.banItemId = ed.getDataTable("Activity")[activityData._cfg_id]["Extra AN"][1]
      return activityData._tasks
    end
  end
  return nil
end

function class:pageUpDate(param)
  self.activityData = param
  self.tasks = param._tasks or {}
  self.endTime = param._end_time
  self.activityId = param._id
  if self:checkServerProgressComplete() and self.action_pre and self.action_pre == "Idle" then
    self:changeAction("Death")
  end
  self:refreshTask()
end

function class:refreshLeftTime()
  if not self.endTime then
    return
  end
  ed.setLabelString(self.ui.left_time_label, T("\229\137\169\228\189\153%s", ed.time2dhmsV2(self.endTime - ed.getServerTime())))
  self.ui.left_time_label:limitWidthByScale(90)
end

function class:initHero()
  self.heroFcaScope = {}
  local heroId = 10058
  self.heroId = heroId
  ed.asyncload.preloadFcaByUnitID(heroId)
  ed.asyncload.registLoadingListener(function()
    local puppet, cha = ed.readhero.getActor(heroId, "Idle", true, false)
    puppet:setPosition(ccp(0, 0))
    self.ui.magnus_pos:addChild(puppet)
    self:addFca(puppet)
    puppet:update(0)
    self.puppet = puppet
    self.cha = cha
    local initAction = self:checkServerProgressComplete() and "Death" or "Cheer"
    self:changeAction(initAction)
    local config = {
      button = self.ui.magnus_panel,
      key = "magnus_changeAction",
      clickHandler = function(_, x, y)
        self:changeAction()
      end,
      clickInterval = 1
    }
    self:btRegisterButtonClick(config)
  end)
end

function class:changeAction(name)
  if not self.puppet or not self.cha then
    return
  end
  if not name and self.isPlayingBAN then
    return
  end
  local isBAN = name and string.find(name, "BAN") ~= nil
  local row = ed.getDataTable("AnimDuration")[self.cha]
  local puppet, cha = self.puppet, self.cha
  local actions = {}
  local dur = {}
  local skill_items = ed.getDataTable("SkillGroup")[self.heroId]
  local can_show_action_tbl = {"Move"}
  for idx, skill_item in pairs(skill_items or {}) do
    for jdx, action in pairs(ed.getDataTable("Skill")[skill_item["Skill Group ID"]][0]["Action(s)"]) do
      if string.find(action, "special") == nil then
        can_show_action_tbl[#can_show_action_tbl + 1] = action
      end
    end
  end
  for k, v in pairs(row or {}) do
    if name then
      if k == name then
        table.insert(actions, k)
        table.insert(dur, v.Duration)
      end
    elseif ed.isElementInTable(k, can_show_action_tbl) and k ~= self.action_pre then
      table.insert(actions, k)
      table.insert(dur, v.Duration)
    end
  end
  local index
  if name then
    index = 1
  else
    index = math.random(1, #actions)
  end
  local action = actions[index]
  self.action_pre = action
  self.duration = dur[index]
  self.puppet:setAction(action)
  CloseScope(self.heroFcaScope)
  if isBAN then
    self.isPlayingBAN = true
  end
  local loopAction = self:checkServerProgressComplete() and "Death_2" or "Move"
  if action ~= loopAction then
    ListenTimer(Timer:Always(0), self:checkHeroFcaHandler(self.duration, action), self.heroFcaScope)
  end
  self.puppet:setLoop(action == loopAction)
  return action, self.duration
end

function class:checkHeroFcaHandler(duration, action)
  local time = 0
  local nextAction = self:checkServerProgressComplete() and (action ~= "Death" and "Death" or "Death_2") or "Idle"
  
  local function handler(dt)
    time = time + dt
    if time > duration then
      self.isPlayingBAN = false
      CloseScope(self.heroFcaScope)
      self:changeAction(nextAction)
    end
  end
  
  return handler
end

function class:registerBtnClick(key, func)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    pressScale = 0.95,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func()
    end,
    clickInterval = 0.2,
    priority = 10
  }
  self:btRegisterButtonClick(config)
end

local itemClass = {}
class.roleRewardItem = itemClass

function itemClass.create(mainSelf, param)
  local self = {}
  setmetatable(self, {__index = itemClass})
  self.mainSelf = mainSelf
  self:init(param)
  return self
end

function itemClass:init(param)
  self.param = param
  self.task = param.task
  self.reached = self.task._progress >= self.task._cond_target
  self.complete = self.task._cur_reward_times >= self.task._max_reward_times
  self:initUI()
end

function itemClass:initUI()
  local container = CCNode:create()
  local ui = {}
  self.container = container
  self.ui = ui
  local progress_node = ed.createSprite("UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_point_1.png")
  container:addChild(progress_node)
  ui.progress_node = progress_node
  local reward = self.task._rewards[1]
  local itemIcon = ed.createItemIcon({
    id = reward._id,
    type = reward._type,
    amount = reward._amount
  })
  itemIcon:setPosition(ccp(0, 35))
  container:addChild(itemIcon)
  ui.itemIcon = itemIcon
  local iconNode = CCNode:create()
  ui.itemIcon:addChild(iconNode)
  ed.layout.centerInParent(iconNode)
  ui.iconNode = iconNode
  local target_tab = ed.createSprite("UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_text_bg_1.png")
  local target_num = ed.createLabelTTF(self.task._cond_target, 16)
  ed.setLabelColor(target_num, ed.toccc3(16710116))
  target_tab:addChild(target_num)
  ed.layout.centerInParent(target_num)
  target_tab:setPosition(ccp(0, -15))
  container:addChild(target_tab)
  ui.target_tab = target_tab
  ui.target_num = target_num
  self:refreshUI()
  local normalScale = ui.itemIcon:getScale()
  local config = {
    button = ui.itemIcon,
    key = "itemIcon" .. self.task._id,
    pressScale = 0.95 * normalScale,
    normalScale = normalScale,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      self:clickIcon()
    end,
    clickInterval = 0.2,
    priority = 10
  }
  self.mainSelf:btRegisterButtonClick(config)
end

function itemClass:clickIcon()
  if not self.complete and self.reached then
    self.mainSelf.objWork:activitySubmit(self.mainSelf.activityId, self.task._id)
    self.mainSelf.objWork:activityPull(self.mainSelf.activityId)
  else
    local reward = self.task._rewards[1]
    ed.ui.packageDetailWin.create({
      id = reward._id,
      type = reward._type
    }):popWindow()
  end
end

function itemClass:refreshUI(task)
  self.task = task or self.task
  self.reached = self.task._progress >= self.task._cond_target
  self.complete = self.task._cur_reward_times >= self.task._max_reward_times
  self.ui.iconNode:removeAllChildrenWithCleanup(true)
  if self.complete then
    local mask = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_mask.png")
    mask:setPosition(16, 16)
    self.ui.iconNode:addChild(mask)
    local tick = ed.createSprite("UI/alpha/1080P/package/selected.png")
    self.ui.iconNode:addChild(tick)
    tick:setPosition(ccp(16, 16))
    ed.setLabelColor(self.ui.target_num, ed.toccc3(13086583))
    ed.setTexture(self.ui.target_tab, "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_text_bg_1.png")
    ed.setTexture(self.ui.progress_node, "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_point_3.png")
  elseif self.reached then
    local eff = ed.createSprite("UI/alpha/1080P/taskModel/player_award_list_item_eff.png")
    self.ui.iconNode:addChild(eff)
    eff:setPosition(16, 16)
    eff:runAction(CCRepeatForever:create(CCRotateBy:create(0.7, 360)))
    ed.setTexture(self.ui.target_tab, "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_text_bg_2.png")
    ed.setLabelColor(self.ui.target_num, ed.toccc3(16705904))
    ed.setTexture(self.ui.progress_node, "UI/alpha/1080P/activity/ban_magnus/ban_magnus_role_progress_point_2.png")
  end
end
