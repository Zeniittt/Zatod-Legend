local class, base = newwindow()
local ed = ed
ed.ui.loginActivity = class
class.__index = class
local initDraglistHeight = 360
local namespace = {}
local showPanel
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
      z = 0
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
      text = T("\231\172\1721\229\164\169"),
      size = 19,
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 66)
    },
    config = {
      color = ccc3(67, 59, 56)
    }
  },
  {
    t = "Label",
    base = {
      parent = "reward_bg",
      name = "str_time_lable",
      text = T("\229\165\150\229\138\177"),
      size = 19,
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 33)
    },
    config = {
      color = ccc3(67, 59, 56)
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
      position = ccp(460, 74)
    },
    config = {
      visible = false,
      color = ccc3(37, 21, 20)
    }
  },
  {
    t = "Sprite",
    base = {
      parent = "reward_bg",
      name = "sp_canGet",
      res = "UI/alpha/HVGA/task_get_reward_button.png",
      z = 3
    },
    layout = {
      position = ccp(460, 50)
    },
    config = {scale = 1, visible = false}
  },
  {
    t = "Sprite",
    base = {
      parent = "reward_bg",
      name = "sp_complete",
      res = "UI/alpha/HVGA/task_complete_title.png",
      z = 3
    },
    layout = {
      position = ccp(460, 50)
    },
    config = {scale = 1, visible = false}
  }
}

local function create(self, info)
  self.container, self.frameUi = ed.editorui(ed.uieditor.ActivityFrame)
  self.container:registerScriptTouchHandler(self:doMainLayerTouch(), false, -500, false)
  self.container:setTouchEnabled(true)
  self.listHeight = 0
  self.buttonData = {}
  self.infoData = info
  self.jobListData = {}
  self.curJobId = nil
  self.lastGetTime = nil
  self.enterTime = ed.getServerTime()
  self:init()
  self.frameUi.enter_button:setVisible(false)
  self.frameUi.enter_label:setVisible(false)
  self.isRun = true
  return self
end

class.create = create

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
  self:createLoginRewardList()
end

class.init = init

local function setPostion(icon, i)
  local anchor = icon:getAnchorPoint()
  local size = icon:getContentSize()
  local scaleX = icon:getScaleX()
  local scaleY = icon:getScaleY()
  local w = size.width * scaleX
  local h = size.height * scaleY
  local pos = icon:getParent():convertToWorldSpace(ccp(icon:getPosition()))
  local posX = pos.x
  local posY = pos.y
  local x = posX - 40
  if i == 1 then
    x = x + 20
  end
  local y = 80 + (0.5 - anchor.y) * h
  return x, y
end

local function createFlyLayer(self, config)
  showPanel = aFrame.createFlyLayer(config)
  return showPanel
end

class.createFlyLayer = createFlyLayer

local function destroyLayer(self)
  if showPanel then
    showPanel:removeFromParentAndCleanup(true)
    showPanel = nil
    return true
  end
end

class.destroyLayer = destroyLayer

local function doPressInList(self)
  local function handler(x, y)
    for k, v in pairs(self.jobListData) do
      if v.data.state ~= "canget" then
        local icons = v.data.icons
        
        for idx, icon_info in ipairs(icons) do
          if ed.containsPoint(icon_info.icon, x, y) then
            local config = {
              parent = icon_info.icon,
              index = k,
              type = icon_info.type,
              id = icon_info.id
            }
            self:createFlyLayer(config)
            return k, idx
          end
        end
      end
      local sp_button = v.ui.reward_bg
      if ed.containsPoint(sp_button, x, y) then
        sp_button:setScale(0.73)
        return v, "reward"
      end
    end
  end
  
  return handler
end

class.doPressInList = doPressInList

local function doClickInList(self)
  local function handler(x, y, v, param)
    if not v then
      return
    end
    if param == "reward" then
      local sp_button = v.ui.reward_bg
      sp_button:setScale(0.75)
      if ed.containsPoint(sp_button, x, y) then
        self:onClikRewardListHandler(v.data)
      end
    elseif type(param) == "number" then
    end
  end
  
  return handler
end

class.doClickInList = doClickInList

local function onClikRewardListHandler(self, data)
  local state = data.state
  if state == "canget" then
    if not ed.netreply.loginActivity then
      ed.netreply.loginActivity = true
      ListenEvent("loginActivity", function(reply)
        self:recGetRewardHandler(reply)
        self:doClickPrizeReply(reply)
      end, namespace)
      local msg = ed.upmsg.job_rewards()
      msg._job = data.id
      ed.send(msg, "job_rewards")
      self.curJobId = data.id
    end
  elseif state == "already" then
    ed.showToast(T("\229\189\147\229\137\141\229\165\150\229\138\177\229\183\178\233\162\134\229\143\150"))
  elseif state == "cannot" then
    ed.showToast(T("\229\189\147\229\137\141\229\165\150\229\138\177\228\184\141\229\143\175\233\162\134\229\143\150"))
  end
end

class.onClikRewardListHandler = onClikRewardListHandler

local function cancelPressInList(self)
  local function handler(x, y, v, param)
    if not v then
      return
    end
    if param == "reward" then
      local sp_button = v.ui.reward_bg
      sp_button:setScale(0.75)
    elseif type(param) == "number" then
      self:destroyLayer()
    end
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function cancelClickInList(self)
  local function handler(x, y, v, param)
    if not v then
      return
    end
    if param == "reward" then
      local sp_button = v.ui.reward_bg
      sp_button:setScale(0.75)
    elseif type(param) == "number" then
      self:destroyLayer()
    end
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

local function setTextContent(ui, Dimensions, HorizontalAlignment, VerticalAlignment)
  ui:setDimensions(Dimensions)
  ui:setHorizontalAlignment(HorizontalAlignment)
  ui:setVerticalAlignment(VerticalAlignment)
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
  local ui_info = {
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
  local readNode = ed.readnode.create(layer, em)
  readNode:addNode(ui_info)
  local info = self.infoData
  local start_time = info._start_time
  local end_time = info._end_time
  local start_y, start_m, start_d, start_h, start_min = ed.time2YMD(start_time)
  local end_y, end_m, end_d, end_h, end_min = ed.time2YMD(end_time)
  local time = string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(start_time), ed.formatTime(end_time))
  self.frameUi.a_title:setString((info or {})._title or "")
  self.frameUi.a_title:setShadow(ccc3(0, 0, 0), ccp(0, 2))
  if info._extra_info._is_open_svr == 1 then
    em.str_title_1:setVisible(false)
    em.str_times:setVisible(false)
    local x, y = em.str_title_2:getPosition()
    em.str_title_2:setPosition(ccp(x, y + 50))
    x, y = em.str_context:getPosition()
    em.str_context:setPosition(ccp(x, y + 50))
    x, y = em.str_title_3:getPosition()
    em.str_title_3:setPosition(ccp(x, y + 50))
  end
  em.str_times:setString(time or "")
  em.str_context:setString(info._rules or "")
  setTextContent(em.str_context, CCSizeMake(390, 0), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
  local dheight = em.str_context:getContentSize().height
  local lable_context = em.str_context
  local lable_title = em.str_title_3
  lable_title:setPosition(30, lable_context:getPositionY() - dheight - 14)
  self.listHeight = self.listHeight + dheight + 130
  if info._extra_info._is_open_svr == 1 then
    self.draglist:initListHeight(self.listHeight - 50)
  else
    self.draglist:initListHeight(self.listHeight)
  end
end

class.createTitleInfo = createTitleInfo

local function createPrize(listdata)
  local iconlist = {}
  local list = listdata or {}
  local i = 0
  for k, v in ipairs(list) do
    local plistIcon, plistNum = aFrame.createItemPrizeIcon(v._type, v._id, v._amount, 30)
    plistNum:setAnchorPoint(ccp(0, 0))
    plistNum:setPosition(ccp(35, 7))
    ed.setLabelStroke(plistNum, ccc3(138, 56, 1), 3)
    plistIcon:addChild(plistNum)
    plistIcon:setAnchorPoint(ccp(0, 0))
    plistIcon:setScale(0.7)
    iconlist[k] = {
      icon = plistIcon,
      id = v._id,
      type = v._type
    }
    i = k
  end
  return iconlist
end

local function checkCanGet(self, activity_start_time, last_reward_time)
  if activity_start_time < self.enterTime and last_reward_time == 0 then
    if not self.lastGetTime then
      return true
    end
    return ed.checkTwoDateod(self.lastGetTime)
  end
end

class.checkCanGet = checkCanGet

local function createLoginRewardList(self)
  local infoData = self.infoData
  if infoData == nil then
    return
  end
  local rewardList = self.infoData._rewards
  if rewardList == nil then
    return
  end
  for i, rewardInfo in ipairs(rewardList) do
    local layer = self.draglist:getList()
    local em = {}
    local oh = initDraglistHeight
    if self.infoData._extra_info._is_open_svr == 1 then
      oh = oh + 50
    end
    if not self.listHeight then
      self.listHeight = 0
    end
    local lh = self.listHeight
    lh = lh + 20
    local readNode = ed.readnode.create(layer, em)
    readNode:addNode(ui_baseInfo)
    local bg = em.reward_bg
    em.str_time_tltie:setString(string.format(T("\231\172\172%d\229\164\169"), i))
    local iconList = createPrize(rewardInfo._rewards)
    local posX = 81
    local posY = 5
    local w = 60
    if iconList then
      for i, icon_info in ipairs(iconList) do
        bg:addChild(icon_info.icon, 2)
        icon_info.icon:setPosition(ccp(posX + w * (i - 1), posY))
      end
    end
    local job_state
    local job_id = rewardInfo._dailyjob._id
    if rewardInfo._dailyjob._task_target >= rewardInfo._amount then
      if rewardInfo._dailyjob._last_rewards_time ~= 0 then
        job_state = "already"
      else
        job_state = "canget"
      end
    else
      job_state = "cannot"
    end
    local bg = em.reward_bg
    local bg_pess = em.reward_bg_press
    local icon_canGet = em.sp_canGet
    local sp_complete = em.sp_complete
    local start_state = em.start_state
    local reward_get = em.reward_get
    bg:setPosition(ccp(225, oh - lh))
    if job_state == "canget" then
      bg_pess:setVisible(true)
      icon_canGet:setVisible(true)
      sp_complete:setVisible(false)
      start_state:setVisible(false)
      reward_get:setVisible(false)
    elseif job_state == "already" then
      bg_pess:setVisible(false)
      icon_canGet:setVisible(false)
      sp_complete:setVisible(false)
      start_state:setVisible(true)
      ed.setString(start_state, T("\229\183\178\233\162\134\229\143\150"))
      reward_get:setVisible(true)
    elseif job_state == "cannot" then
      bg_pess:setVisible(false)
      icon_canGet:setVisible(false)
      start_state:setVisible(false)
      reward_get:setVisible(false)
    end
    self.jobListData[i] = {
      ui = em,
      data = {
        id = job_id,
        state = job_state,
        amount = rewardInfo._amount,
        icons = iconList
      }
    }
    self.listHeight = self.listHeight + 80
    if self.infoData._extra_info._is_open_svr == 1 then
      self.draglist:initListHeight(self.listHeight - 50)
    else
      self.draglist:initListHeight(self.listHeight)
    end
  end
end

class.createLoginRewardList = createLoginRewardList

local function recGetRewardHandler(self, reply)
  if not reply._result then
    return
  end
  if self.curJobId ~= nil then
    for i, listData in ipairs(self.jobListData) do
      local data = listData.data
      local ui = listData.ui
      if data.id == self.curJobId then
        data.state = "already"
        local rewardList = self.infoData._rewards
        for i, rewardInfo in ipairs(rewardList) do
          local dailyJob = rewardInfo._dailyjob
          if self.curJobId == dailyJob._id then
            dailyJob._last_rewards_time = ed.getServerTime()
            self.curJobId = nil
            break
          end
        end
        local bg_pess = ui.reward_bg_press
        local icon_canGet = ui.sp_canGet
        local sp_complete = ui.sp_complete
        local start_state = ui.start_state
        local reward_get = ui.reward_get
        bg_pess:setVisible(false)
        icon_canGet:setVisible(false)
        sp_complete:setVisible(false)
        reward_get:setVisible(true)
        start_state:setVisible(true)
        ed.setString(start_state, T("\229\183\178\233\162\134\229\143\150"))
        break
      end
    end
  end
end

class.recGetRewardHandler = recGetRewardHandler

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

local function doClickPrizeReply(self, reply)
  CloseScope(namespace)
  local info = reply._activity_reward
  if not reply._result then
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
      elseif "medal" == r._type then
        types = "medal"
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
