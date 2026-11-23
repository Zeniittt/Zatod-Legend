local class, base = newwindow()
local ed = ed
ed.ui.onTimeActivity = class
class.__index = class
ed.ui.onTimeData = {}
local namespace = {}
local initDraglistHeight = 360
local getAlwayTimeEvent
local aFrame = ed.ui.activityBase
local ui_baseInfo = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 401.3671875, h = 72.0703125},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/activity/activity_list_bg_1.png",
      name = "reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 535.15625, h = 96.09375},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "reward_bg",
      res = "UI/alpha/HVGA/activity/activity_list_bg_2.png",
      name = "reward_bg_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.8, 48.05)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 535.15625, h = 96.09375},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "reward_bg",
      res = "UI/alpha/HVGA/activity/activity_list_mask_received.png",
      name = "reward_get",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.8, 48.05)
    }
  },
  {
    t = "Label",
    base = {
      parent = "reward_bg",
      name = "str_time_tltie",
      text = T("\229\156\168\231\186\191\230\151\182\233\151\180"),
      size = 19,
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 61)
    },
    config = {
      color = ccc3(37, 21, 20)
    }
  },
  {
    t = "Label",
    base = {
      parent = "reward_bg",
      name = "str_time_lable",
      text = T(""),
      size = 19,
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 34)
    },
    config = {
      color = ccc3(62, 49, 250)
    }
  },
  {
    t = "Label",
    base = {
      parent = "reward_bg",
      name = "str_time_1",
      text = T("\233\162\134\229\165\150\229\128\146\232\174\161\230\151\182\239\188\154"),
      size = 19,
      parent = "reward_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(445, 61)
    },
    config = {
      visible = false,
      color = ccc3(37, 21, 20)
    }
  },
  {
    t = "Label",
    base = {
      parent = "reward_bg",
      name = "start_state",
      text = T("\230\156\170\229\188\128\229\167\139"),
      size = 19,
      parent = "reward_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(440, 50)
    },
    config = {
      visible = false,
      color = ccc3(37, 21, 20)
    }
  },
  {
    t = "Label",
    base = {
      parent = "reward_bg",
      name = "str_time_num",
      text = T(""),
      size = 19,
      parent = "reward_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(440, 34)
    },
    config = {
      visible = false,
      color = ccc3(62, 49, 250)
    }
  },
  {
    t = "Sprite",
    base = {
      parent = "reward_bg",
      name = "sp_canGet",
      res = "UI/alpha/HVGA/task_get_reward_button.png"
    },
    layout = {
      position = ccp(440, 50)
    },
    config = {scale = 1, visible = false}
  },
  {
    t = "Sprite",
    base = {
      parent = "reward_bg",
      name = "sp_complete",
      res = "UI/alpha/HVGA/task_complete_title.png"
    },
    layout = {
      position = ccp(440, 50)
    },
    config = {scale = 1, visible = false}
  }
}

local function setTextContent(ui, Dimensions, HorizontalAlignment, VerticalAlignment)
  ui:setDimensions(Dimensions)
  ui:setHorizontalAlignment(HorizontalAlignment)
  ui:setVerticalAlignment(VerticalAlignment)
end

local function doPressInList(self)
  local function handler(x, y)
    for k, v in pairs(self.jobListData) do
      local sp_button = v.ui.reward_bg
      
      if ed.containsPoint(sp_button, x, y) then
        sp_button:setScale(0.73)
        return v
      end
    end
  end
  
  return handler
end

class.doPressInList = doPressInList

local function doClickInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.ui.reward_bg
    sp_button:setScale(0.75)
    if ed.containsPoint(sp_button, x, y) then
      self:onClikRewardListHandler(v)
    end
  end
  
  return handler
end

class.doClickInList = doClickInList

local function onClikRewardListHandler(self, data)
  local state = data.state
  if state == 1 then
    local msg = ed.upmsg.job_rewards()
    msg._job = data.id
    ed.netreply.tenPumping = "onTime"
    ed.send(msg, "job_rewards")
  elseif state == 2 then
    ed.showToast(T("\229\156\168\231\186\191\230\151\182\233\151\180\228\184\141\232\182\179"))
  elseif state == 3 then
    ed.showToast(T("\229\189\147\229\137\141\229\165\150\229\138\177\229\183\178\233\162\134\229\143\150"))
  elseif state == 4 then
    ed.showToast(T("\232\175\183\229\133\136\233\162\134\229\143\150\228\184\138\228\184\128\228\184\170\229\165\150\229\138\177"))
  else
    if self.OpenState == "no_open" then
      ed.showToast(T("\230\180\187\229\138\168\230\154\130\230\156\170\229\188\128\229\167\139"))
    end
    if self.OpenState == "close" then
      ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
    end
  end
end

class.onClikRewardListHandler = onClikRewardListHandler

local function cancelPressInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.ui.reward_bg
    sp_button:setScale(0.75)
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function cancelClickInList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    local sp_button = v.ui.reward_bg
    sp_button:setScale(0.75)
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList

local function doMainLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function overTime(endtime)
  local currentTime = os.time()
  if endtime > currentTime then
    return true
  end
  if 0 < currentTime - endtime then
    return false
  else
    return true
  end
end

local function createTitleInfo(self)
  local layer = self.draglist:getList()
  local em = {}
  local oh = initDraglistHeight
  if not self.listHeight then
    self.listHeight = 0
  end
  local lh = self.listHeight
  lh = lh + 10
  ui_info = {
    {
      t = "Label",
      base = {
        name = "str_title_1",
        text = T("\230\180\187\229\138\168\230\151\182\233\151\180\239\188\154"),
        size = 18
      },
      layout = {
        position = ccp(30, oh - lh),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ccc3(238, 204, 119)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_times",
        text = T("2015\229\185\1803\230\156\1362\230\151\165-2016\229\185\1808\230\156\1368\230\151\165"),
        size = 16
      },
      layout = {
        position = ccp(30, oh - lh - 30),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ccc3(248, 248, 214),
        verticalAlignment = 0,
        horizontalAlignment = 0
      }
    },
    {
      t = "Label",
      base = {
        name = "str_title_2",
        text = T("\230\180\187\229\138\168\229\134\133\229\174\185\239\188\154"),
        size = 18
      },
      layout = {
        position = ccp(30, oh - lh - 50),
        anchor = ccp(0, 1)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    },
    {
      t = "Label",
      base = {
        name = "str_context",
        text = T("\230\180\187\229\138\168\231\154\132\229\134\133\229\174\185\229\143\130\229\138\160\229\143\175\228\187\165\229\190\151\229\136\176\233\135\145\233\146\177\231\154\132\229\147\159\229\191\171\230\157\165\230\174\139\231\150\190\233\152\191\231\136\184"),
        size = 16
      },
      layout = {
        position = ccp(30, oh - lh - 73),
        anchor = ccp(0, 1)
      },
      config = {
        color = ccc3(248, 248, 214),
        verticalAlignment = 0,
        horizontalAlignment = 0
      }
    },
    {
      t = "Label",
      base = {
        name = "str_title_3",
        text = T("\230\180\187\229\138\168\229\165\150\229\138\177\239\188\154"),
        size = 18
      },
      layout = {
        position = ccp(30, oh - lh - 60),
        anchor = ccp(0, 0.5)
      },
      config = {
        color = ccc3(241, 193, 113)
      }
    }
  }
  readNode = ed.readnode.create(layer, em)
  readNode:addNode(ui_info)
  local info = self.infoData
  local start_time = info._start_time
  local end_time = info._end_time
  local start_y, start_m, start_d, start_h, start_min = ed.time2YMD(start_time)
  local end_y, end_m, end_d, end_h, end_min = ed.time2YMD(end_time)
  local time = string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(start_time), ed.formatTime(end_time))
  self.frameUi.a_title:setString((info or {})._title or "")
  self.frameUi.a_title:setShadow(ccc3(0, 0, 0), ccp(0, 2))
  em.str_times:setString(time or "")
  em.str_context:setString(info._rules or "")
  setTextContent(em.str_context, CCSizeMake(390, 0), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
  local dheight = em.str_context:getContentSize().height
  local lable_context = em.str_context
  local lable_title = em.str_title_3
  lable_title:setPosition(30, lable_context:getPositionY() - dheight - 14)
  self.listHeight = self.listHeight + dheight + 130
  self.draglist:initListHeight(self.listHeight)
end

class.createTitleInfo = createTitleInfo

local function createPrize(listdata)
  local iconlist = {}
  local list = listdata or {}
  local i = 0
  for k, v in ipairs(list) do
    local plistIcon, plistNum = aFrame.createItemPrizeIcon(v._type, v._id, v._amount, 20)
    plistNum:setAnchorPoint(ccp(1, 0))
    plistNum:setPosition(ccp(78, 5))
    ed.setLabelStroke(plistNum, ccc3(0, 0, 0), 3)
    plistIcon:addChild(plistNum)
    plistIcon:setAnchorPoint(ccp(0.5, 0.5))
    plistIcon:setPosition(ccp(45.75, 38.125))
    local icon = CCSprite:create()
    icon:addChild(plistIcon)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setScale(0.85)
    iconlist[k] = icon
    i = k
  end
  return iconlist
end

local function createOnTimeRewardList(self)
  local infoData = self.infoData
  if infoData == nil then
    return
  end
  local rewardList = self.infoData._rewards
  for i, rewardInfo in ipairs(rewardList) do
    local layer = self.draglist:getList()
    local em = {}
    local oh = initDraglistHeight
    if not self.listHeight then
      self.listHeight = 0
    end
    local lh = self.listHeight
    lh = lh + 20
    local reward_info = rewardInfo
    local ui_info = ui_baseInfo
    readNode = ed.readnode.create(layer, em)
    readNode:addNode(ui_info)
    local reward_amount
    local times_num = reward_info._amount
    local h = math.floor(times_num / 3600)
    times_num = times_num - h * 3600
    local m = math.floor(times_num / 60)
    local s = times_num % 60
    if h ~= 0 then
      if m ~= 0 and s == 0 then
        reward_amount = T("%d\229\176\143\230\151\182%d\229\136\134", h, m)
      elseif s ~= 0 then
        reward_amount = T("%d\229\176\143\230\151\182%d\229\136\134%d\231\167\146", h, m, s)
      else
        reward_amount = T("%d\229\176\143\230\151\182", h)
      end
    elseif m ~= 0 then
      if s ~= 0 then
        reward_amount = T("%d\229\136\134%d\231\167\146", m, s)
      else
        reward_amount = T("%d\229\136\134\233\146\159", m)
      end
    else
      reward_amount = T("%d\231\167\146", s)
    end
    ed.setString(em.str_time_lable, reward_amount)
    local bg = em.reward_bg
    local iconList = createPrize(reward_info._rewards)
    local posX = 160
    local posY = 15
    local w = 75
    if iconList then
      for i, icon in ipairs(iconList) do
        bg:addChild(icon, 2)
        icon:setPosition(ccp(posX + w * (i - 1), posY))
      end
    end
    local user_job = reward_info._dailyjob
    local job_id = user_job._id
    local job_last_get_time
    if job_id == nil or ed.ui.onTimeData[job_id] == nil then
      job_last_get_time = user_job._last_rewards_time
    else
      job_last_get_time = ed.ui.onTimeData[job_id].job_last_get_time or user_job._last_rewards_time
    end
    local job_target = user_job._task_target
    local job_state
    local curTime = ed.getServerTime()
    local y, mon, last_d, h, m, s = ed.time2YMDHMS(job_last_get_time)
    local y1, m1, cur_d, c_h, c_m, c_s = ed.time2YMDHMS(curTime)
    if job_target >= reward_info._amount and ed.checkTwoDateod(job_last_get_time) then
      job_state = 1
      self.curJobId = job_id
    elseif not self.curJobId then
      job_state = 2
      self.curJobId = job_id
    else
      job_state = 4
    end
    if not ed.checkTwoDateod(job_last_get_time) then
      job_state = 3
      self.curJobId = nil
    end
    if self.OpenState ~= "open" then
      job_state = 5
      self.curJobId = nil
    end
    local bg = em.reward_bg
    local bg_pess = em.reward_bg_press
    local icon_canGet = em.sp_canGet
    local lable_time = em.str_time_1
    local lable_time_num = em.str_time_num
    local sp_complete = em.sp_complete
    local start_state = em.start_state
    local reward_get = em.reward_get
    bg:setPosition(ccp(225, oh - lh))
    if job_state == 1 then
      bg_pess:setVisible(true)
      icon_canGet:setVisible(true)
      lable_time:setVisible(false)
      lable_time_num:setVisible(false)
      sp_complete:setVisible(false)
      start_state:setVisible(false)
      reward_get:setVisible(false)
    elseif job_state == 2 then
      bg_pess:setVisible(false)
      icon_canGet:setVisible(false)
      lable_time:setVisible(true)
      lable_time_num:setVisible(true)
      start_state:setVisible(false)
      reward_get:setVisible(false)
    elseif job_state == 3 then
      bg_pess:setVisible(false)
      icon_canGet:setVisible(false)
      lable_time:setVisible(false)
      lable_time_num:setVisible(false)
      sp_complete:setVisible(false)
      start_state:setVisible(true)
      ed.setString(start_state, T("\229\183\178\233\162\134\229\143\150"))
      reward_get:setVisible(true)
    else
      bg_pess:setVisible(false)
      icon_canGet:setVisible(false)
      lable_time:setVisible(false)
      lable_time_num:setVisible(false)
      start_state:setVisible(false)
      start_state:setVisible(true)
      if self.OpenState == "no_open" then
        ed.setString(start_state, T("\230\156\170\229\188\128\229\167\139"))
      end
      if self.OpenState == "close" then
        ed.setString(start_state, T("\229\183\178\231\187\147\230\157\159"))
      end
      reward_get:setVisible(false)
    end
    if ed.ui.onTimeData[job_id] then
      ed.ui.onTimeData[job_id].times = ed.ui.onTimeData[job_id].starTime - ed.getServerTime()
      ed.ui.onTimeData[job_id].state = job_state
      ed.ui.onTimeData[job_id].ui = em
    else
      local starTime1 = ed.getServerTime() + reward_info._amount - job_target
      local times1 = reward_info._amount - job_target
      local data = {
        id = job_id,
        state = job_state,
        times = times1,
        amount = reward_info._amount,
        starTime = starTime1
      }
      ed.ui.onTimeData[job_id] = data
      ed.ui.onTimeData[job_id].ui = em
    end
    self.jobListData[i] = ed.ui.onTimeData[job_id]
    self.listHeight = self.listHeight + 80
    self.draglist:initListHeight(self.listHeight)
  end
end

class.createOnTimeRewardList = createOnTimeRewardList

local function init(self)
  local draglistInfo = {
    cliprect = CCRectMake(17, 65, 417, 295),
    rect = CCRectMake(20, 65, 410, 295),
    container = self.frameUi.a_frame,
    priority = -800,
    noshade = true,
    swallow = false,
    bar = {
      bglen = 260,
      bgpos = ccp(15, 218)
    },
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(draglistInfo)
  self:createTitleInfo()
  self:createOnTimeRewardList()
  if getAlwayTimeEvent then
    CloseTimer(getAlwayTimeEvent.Name)
    getAlwayTimeEvent = nil
  end
  if self.OpenState == "open" then
    getAlwayTimeEvent = ListenTimer(Timer:Always(0.3), self:getUpdateTimesHandler())
  end
end

class.init = init

local function getUpdateTimesHandler(self)
  function handler()
    if not self.isRun then
      return
    end
    if self.curJobId then
      for i, data in ipairs(self.jobListData) do
        if data.id == self.curJobId and data.state == 2 then
          data.times = data.starTime - ed.getServerTime()
          local bg_pess = data.ui.reward_bg_press
          local icon_canGet = data.ui.sp_canGet
          local lable_time = data.ui.str_time_1
          local lable_time_num = data.ui.str_time_num
          local start_state = data.ui.start_state
          local reward_get = data.ui.reward_get
          if data.times <= 0 then
            data.state = 1
            bg_pess:setVisible(true)
            icon_canGet:setVisible(true)
            lable_time:setVisible(false)
            lable_time_num:setVisible(false)
            start_state:setVisible(false)
          else
            local times_num = data.times
            local h = math.floor(times_num / 3600)
            times_num = times_num - h * 3600
            local m = math.floor(times_num / 60)
            local s = times_num % 60
            if h ~= 0 then
              lable_time_num:setString(T("%d\229\176\143\230\151\182%d\229\136\134%d\231\167\146", h, m, s))
            elseif m ~= 0 then
              lable_time_num:setString(T("%d\229\136\134%d\231\167\146", m, s))
            else
              lable_time_num:setString(T("%d\231\167\146", s))
            end
          end
        end
      end
    end
  end
  
  return handler
end

class.getUpdateTimesHandler = getUpdateTimesHandler

local function recGetRewardHandler(self, replys)
  local info = replys._activity_reward
  if not replys._result then
    return
  end
  if self.curJobId ~= nil then
    for i, data in ipairs(self.jobListData) do
      if data.id == self.curJobId then
        data.state = 3
        ed.ui.onTimeData[data.id].state = 3
        ed.ui.onTimeData[data.id].job_last_get_time = ed.getServerTime()
        local bg_pess = data.ui.reward_bg_press
        local icon_canGet = data.ui.sp_canGet
        local lable_time = data.ui.str_time_1
        local lable_time_num = data.ui.str_time_num
        local sp_complete = data.ui.sp_complete
        local start_state = data.ui.start_state
        local reward_get = data.ui.reward_get
        bg_pess:setVisible(false)
        icon_canGet:setVisible(false)
        lable_time:setVisible(false)
        lable_time_num:setVisible(false)
        sp_complete:setVisible(false)
        reward_get:setVisible(true)
        start_state:setVisible(true)
        ed.setString(start_state, T("\229\183\178\233\162\134\229\143\150"))
        local nextData = self.jobListData[i + 1]
        if nextData then
          nextData.state = 2
          nextData.starTime = ed.getServerTime() + nextData.amount
          self.curJobId = nextData.id
          bg_pess = nextData.ui.reward_bg_press
          icon_canGet = nextData.ui.sp_canGet
          lable_time = nextData.ui.str_time_1
          lable_time_num = nextData.ui.str_time_num
          sp_complete = nextData.ui.sp_complete
          start_state = nextData.ui.start_state
          reward_get = nextData.ui.reward_get
          bg_pess:setVisible(false)
          icon_canGet:setVisible(false)
          lable_time:setVisible(true)
          lable_time_num:setVisible(true)
          sp_complete:setVisible(false)
          reward_get:setVisible(false)
          start_state:setVisible(false)
          nextData.times = nextData.times + 1
          do
            local m = nextData.times % 60
            local s = nextData.times - m * 60
            lable_time_num:setString(T("%d\229\136\134%d\231\167\146", m, s))
          end
          break
        end
        self.curJobId = nil
        break
      end
    end
  end
end

class.recGetRewardHandler = recGetRewardHandler

local function create(self, info)
  self.container, self.frameUi = ed.editorui(ed.uieditor.ActivityFrame)
  self.container:registerScriptTouchHandler(self:doMainLayerTouch(), false, -500, false)
  self.container:setTouchEnabled(true)
  self.listHeight = 0
  self.buttonData = {}
  self.infoData = info
  self.jobListData = {}
  self.curJobId = nil
  local current_time = ed.getServerTime()
  if current_time <= info._end_time and current_time > info._start_time then
    self.OpenState = "open"
  elseif current_time < info._start_time then
    self.OpenState = "no_open"
  else
    self.OpenState = "close"
  end
  self:init()
  self.frameUi.enter_button:setVisible(false)
  self.frameUi.enter_label:setVisible(false)
  self.isRun = true
  if self.OpenState == "open" then
    ListenEvent("getOnTime", function(replys)
      self:recGetRewardHandler(replys)
      self:doClickPrizeReply(replys)
    end, namespace)
  end
  return self
end

class.create = create

local function checkIsOnTimeRun(self)
  if self.isRun then
    self.isRun = false
    CloseScope(namespace)
    if getAlwayTimeEvent then
      CloseTimer(getAlwayTimeEvent.Name)
      getAlwayTimeEvent = nil
    end
  end
end

class.checkIsOnTimeRun = checkIsOnTimeRun

local function doTaskConsume(info)
  for i = 1, #(info or {}) do
    local v = info[i]
    local id = v._id
    local type = v._type
    local amount = v._amount
    if "rmb" == type then
      ed.player:addrmb(amount)
    elseif "money" == type then
      ed.player:addMoney(amount)
    elseif "item" == type then
      ed.player:addEquip(id, amount)
    elseif "hero" == type then
      ed.player:addHero(id)
    elseif "rand_soul" == type then
      ed.player:addEquip(id, amount)
    end
  end
end

local function doClickPrizeReply(self, replys)
  local info = replys._activity_reward
  if not replys._result then
    ed.showToast(T("\228\187\187\229\138\161\230\143\144\228\186\164\229\164\177\232\180\165"))
  else
    doTaskConsume(info)
    local items = {}
    for i = 1, #(info or {}) do
      local r = info[i]
      local types
      if "money" == r._type then
        types = "Gold"
      elseif "rmb" == r._type then
        types = "Diamond"
      elseif "item" == r._type then
        types = "item"
      elseif "hero" == r._type then
        types = "item"
      elseif "rand_soul" == r._type then
        types = "item"
      end
      local it = {
        type = types,
        id = r._id,
        amount = r._amount
      }
      table.insert(items, it)
    end
    local config = {
      type = "getProp",
      param = {
        title = T("\232\142\183\229\190\151"),
        items = items
      }
    }
    ed.announce(config)
    local msg = ed.upmsg.ask_activity_info()
    ed.send(msg, "ask_activity_info")
  end
end

class.doClickPrizeReply = doClickPrizeReply
