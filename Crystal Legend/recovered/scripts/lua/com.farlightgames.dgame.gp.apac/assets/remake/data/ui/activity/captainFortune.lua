local base = ed.ui.basenode
local CaptainFortune = newclass(base.mt)
ed.ui.captainFortune = CaptainFortune
local activity_banner = {
  [1] = {
    des = T("\229\133\172\230\181\139\229\133\173\229\145\168\229\185\180\239\188\140\232\136\185\233\149\191\229\134\141\230\172\161\232\128\131\233\170\140\232\131\189\229\164\159\233\128\154\229\133\179\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129\231\154\132\233\152\159\233\149\191\229\164\167\229\164\167\239\188\140\232\175\129\230\152\142\229\174\158\229\138\155\231\154\132\228\186\186\229\176\134\228\188\154\229\190\151\229\136\176\228\184\128\228\186\155\231\129\181\233\173\130\231\159\179\227\128\130"),
    title = T("\230\153\174\233\128\154/\229\153\169\230\162\166\232\191\156\229\190\129\233\128\154\229\133\179\n1\230\172\161")
  },
  [2] = {
    des = T("\230\143\143\232\191\176\239\188\154\229\143\170\230\156\137\231\171\158\230\138\128\229\156\186\228\184\128\231\153\190\229\144\141\228\185\139\229\134\133\231\154\132\231\142\169\229\174\182\230\137\141\230\156\137\232\181\132\230\160\188\229\190\151\229\136\176\229\133\172\230\181\139\229\133\173\229\145\168\229\185\180\231\154\132\229\164\180\229\131\143\230\161\134\227\128\130"),
    title = T("\231\171\158\230\138\128\229\156\186100\229\144\141\229\134\133\n1\230\172\161")
  },
  [3] = {
    des = T("\229\143\170\230\156\137\232\191\155\229\133\165\230\176\184\231\148\159\230\162\166\229\162\13150\229\144\141\231\154\132\231\142\169\229\174\182\239\188\140\230\137\141\229\143\175\228\187\165\229\190\151\229\136\176\229\133\172\230\181\139\229\133\173\229\145\168\229\185\180\231\154\132\229\164\180\229\131\143\227\128\130"),
    title = T("\230\162\166\229\162\131\229\141\149\228\186\186/\229\144\136\228\189\156\230\156\172\229\140\186\n50\229\144\141\229\134\1331\230\172\161")
  }
}
local scope = {}

function CaptainFortune:getProcessingTask(datas)
  local info, index
  for i, v in ipairs(datas) do
    info = v
    index = i
    if info._dailyjob._last_rewards_time < 1 then
      break
    end
  end
  return info, index
end

function CaptainFortune.create(info)
  local self = base.create("CaptainFortune")
  setmetatable(self, CaptainFortune.mt)
  self.info = info
  self:initData()
  self:createFrame()
  self:resetFrame()
  self:createDraglist()
  self:createContent()
  self:createRwardUI()
  return self
end

function CaptainFortune:createFrame()
  self.container, self.fui = ed.editorui(ed.uieditor.CaptainFortuneActivity)
  self.container:registerScriptTouchHandler(self:btGetMainTouchHandler(), false, -100, false)
  self.container:setTouchEnabled(true)
end

function CaptainFortune:initData()
  self.cur_job, self.cur_index = self:getProcessingTask(self.info._rewards)
  local info = self.info
  local rules = activity_banner[self.cur_index].des or T("\229\145\168\229\185\180\230\180\187\229\138\168")
  local param = {
    title = info._title,
    sTime = info._start_time,
    eTime = info._end_time,
    tContent = rules
  }
  self.data = param
  self.sTime = param.sTime
  self.eTime = param.eTime
  self.banner = param.banner
  self.tContent = param.tContent
  self.title = param.title
end

function CaptainFortune:resetFrame()
  ed.setString(self.fui.a_title, self.title)
end

function CaptainFortune:createDraglist()
  local layer = self.fui.bg_list
  local w, h = layer:getContentSize().width, layer:getContentSize().height
  local draglistInfo = {
    cliprect = CCRectMake(1, 1, w, h),
    container = layer,
    priority = -900,
    noshade = true,
    swallow = false,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(draglistInfo)
end

function CaptainFortune:getClipRect()
  local layer = self.fui.bg_list
  local w, h = layer:getContentSize().width, layer:getContentSize().height
  return CCRectMake(1, 1, w, h)
end

function CaptainFortune:createContent()
  self.leftContainer, self.ui = ed.editorui(ed.uieditor.CaptainFortuneItem)
  self.leftContainer:setPosition(ccp(0, -180))
  self.draglist:addItem(self.leftContainer)
  self.draglist:initListHeight(450)
  self:createTime()
  self:createTContent()
  self:refreshRewardPosition()
end

function CaptainFortune:createTime()
  local time = string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(self.sTime), ed.formatTime(self.eTime))
  ed.setString(self.ui.time, time)
end

function CaptainFortune:createTContent()
  local ui = self.ui.content
  ed.setString(ui, self.tContent)
  ui:setDimensions(CCSizeMake(400, 0))
  ui:setHorizontalAlignment(kCCTextAlignmentLeft)
  ui:setVerticalAlignment(kCCVerticalTextAlignmentTop)
  self.ui.captainFortune2019:setVisible(false)
  self.ui.captainFortune2019:setVisible(false)
  self.ui.captainFortune2019:setVisible(false)
  if self.cur_index == 1 then
    self.ui.captainFortune2019:setVisible(true)
  elseif self.cur_index == 2 then
    self.ui.captainFortune2019:setVisible(true)
  elseif self.cur_index == 3 then
    self.ui.captainFortune2019:setVisible(true)
  end
end

function CaptainFortune:refreshRewardPosition()
  local pos_y = self.ui.content:getPositionY() + self.ui.content:getContentSize().height
end

function CaptainFortune:doPressInList()
  local function handler(x, y)
    local isClick = false
    
    if ed.containsPoint(self.ui.reward_btn, x, y) then
      self.ui.reward_btn:setScale(0.98)
      isClick = true
    end
    return isClick
  end
  
  return handler
end

function CaptainFortune:doClickInList()
  local function handler(x, y, k, i)
    if ed.containsPoint(self.ui.reward_btn, x, y) then
      self.ui.reward_btn:setScale(1)
      
      self:onClickRewardBtn()
    end
  end
  
  return handler
end

function CaptainFortune:cancelPressInList()
  local function handler(x, y, k, i)
    self.ui.reward_btn:setScale(1)
  end
  
  return handler
end

function CaptainFortune:cancelClickInList()
  local function handler(x, y, k, i)
    self.ui.reward_btn:setScale(1)
  end
  
  return handler
end

function CaptainFortune:onClickRewardBtn()
  local dailyjob = self.cur_job._dailyjob
  local last_rewards_time = self.cur_job._dailyjob._last_rewards_time
  local task_target = self.cur_job._dailyjob._task_target
  local id = self.cur_job._dailyjob._id
  local task_amount = self.cur_job._amount
  if 0 < last_rewards_time and task_target >= task_amount then
    ed.showToast(T("\229\165\150\229\138\177\229\183\178\233\162\134\229\143\150"))
    return
  end
  if last_rewards_time < 1 and task_target < task_amount then
    ed.showToast(T("\230\157\161\228\187\182\230\156\170\232\190\190\230\136\144\239\188\140\228\184\141\232\131\189\233\162\134\229\143\150"))
    return
  end
  ListenEvent("requestRewardReply", self:requesetRewardReply(), scope)
  local msg = ed.upmsg.job_rewards()
  msg._job = id
  ed.send(msg, "job_rewards")
end

function CaptainFortune:requesetRewardReply()
  local function handler(replys)
    CloseScope(scope)
    
    if not replys._result then
      ed.showToast(T("\228\187\187\229\138\161\230\143\144\228\186\164\229\164\177\232\180\165"))
      return
    end
    if callback then
      callback(replys)
    end
    self.cur_job._dailyjob._last_rewards_time = ed.getServerTime()
    local info = replys._activity_reward
    self:doTaskConsume(info)
    self:showReward(info)
    self:refreshActiviyList()
    self:refresTask()
  end
  
  return handler
end

function CaptainFortune:refreshActiviyList()
  local msg = ed.upmsg.ask_activity_info()
  ed.send(msg, "ask_activity_info")
end

function CaptainFortune:doTaskConsume(info)
  ed.ui.activityBase:doTaskConsume(info)
end

function CaptainFortune:showReward(info)
  ed.ui.activityBase:showReward(info)
end

function CaptainFortune:createRwardUI()
  if self.rewardNode then
    self.rewardNode:removeFromParentAndCleanup(true)
    self.rewardNode = nil
  end
  local rewadData = self.cur_job._rewards
  local rewadConfig = {}
  for i, v in ipairs(rewadData) do
    local data = {
      type = v._type,
      scale = 0.6,
      amount = v._amount,
      id = v._id
    }
    table.insert(rewadConfig, data)
  end
  local node, iconData = ed.ui.activityBase.createRewardsIcon(rewadConfig)
  node:setPosition(ccp(90, 45))
  self.ui.reward_btn:addChild(node)
  self.iconData = iconData
  self.rewardNode = node
  local last_rewards_time = self.cur_job._dailyjob._last_rewards_time
  local task_target = self.cur_job._dailyjob._task_target
  local id = self.cur_job._dailyjob._id
  local task_amount = self.cur_job._amount
  self.ui.reward_can_bg:setVisible(false)
  self.ui.can_reward_pic:setVisible(false)
  self.ui.has_reward_pic:setVisible(false)
  if 0 < last_rewards_time and task_target >= task_amount then
    self.ui.has_reward_pic:setVisible(true)
    self.ui.lable_progress:setString(T("(\229\183\178\233\162\134\229\143\150)"))
  end
  if last_rewards_time <= 0 and task_target >= task_amount then
    self.ui.reward_can_bg:setVisible(true)
    self.ui.can_reward_pic:setVisible(true)
    self.ui.lable_progress:setString(T("\229\143\175\233\162\134\229\143\150", task_amount, task_amount))
  end
  if last_rewards_time <= 0 and task_target < task_amount then
    self.ui.lable_progress:setString(T("\230\156\170\229\174\140\230\136\144", task_target, task_amount))
  end
  self.ui.lable_des:setString(activity_banner[self.cur_index].title)
end

function CaptainFortune:refresTask()
  self:initData()
  self:createTime()
  self:createTContent()
  self:refreshRewardPosition()
  self:createRwardUI()
  self.draglist:reset()
end
