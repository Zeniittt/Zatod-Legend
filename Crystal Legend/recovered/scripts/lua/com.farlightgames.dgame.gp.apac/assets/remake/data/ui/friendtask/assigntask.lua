local scope = {}
local assigntask = {
  mt = {}
}
assigntask.mt.__index = assigntask
ed.ui.assigntask = assigntask
assigntask.is_open = 0

function assigntask:Create()
  local msg = ed.upmsg.ubackv3()
  msg._open_panel = ed.upmsg.ubackv3_open_panel()
  ed.send(msg, "ubackv3")
  local obj = {}
  setmetatable(obj, assigntask.mt)
  ListenEvent("assign_task", function(msg)
    obj:dispatch(msg)
  end, scope)
end

function assigntask:Pop(data)
  self:InitData(data)
  self:InitWindow()
  self:RegisterTimer()
  self:RegisterBtns()
end

function assigntask:InitData(data)
  self.data = data
  self.end_time = data._end_time
  self.backed_list, self.wait_list = self:SplitPlayers(self.data._targets)
  self.ui = {}
end

function assigntask:SplitPlayers(list)
  local back_list, wait_list = {}, {}
  for _, target in ipairs(list or {}) do
    if target._has_backed == 1 then
      table.insert(back_list, target)
    else
      table.insert(wait_list, target)
    end
  end
  return back_list, wait_list
end

function assigntask:InitWindow()
  self:CreateWindow()
  self:CreateBackPlayerList()
  self:InitDetails()
  self:InitPersonalTask()
  self:InitGlobalTask()
end

function assigntask:RegisterTimer()
  local dt = 1
  ListenTimer(Timer:Always(dt, "activitytimer"), function()
    self.end_time = self.end_time - dt
    self:RefreshTime()
    if self.end_time <= 0 then
    end
  end, scope)
end

function assigntask:CreateWindow()
  self.window = ed.openui("assigntask")
  self.window:getCompoment("content_layer"):setVisible(false)
  self.window:getCompoment("frame_layer"):setVisible(true)
end

function assigntask:CreateBackPlayerList()
  assert(self.window, "self.window can not be nil !!! ")
  local wdo = self.window
  local param = {
    listData = self.backed_list,
    createIconHandler = function(data)
      local node = CCNode:create()
      local param = {
        id = data._user_summary._avatar,
        vip = data._user_summary._vip > 0
      }
      local head = ed.getHeroIconByID(param)
      head:setScale(0.7)
      node:addChild(head)
      local font = "guild_join_list_guildname"
      local name = ed.createLabelWithFontInfo(data._user_summary._name, font)
      name:setAnchorPoint(ccp(0, 0.5))
      name:setPosition(ccp(25, 0))
      name:setScale(0.8)
      node:addChild(name)
      return node
    end,
    container = wdo:getCompoment("list_layer"),
    cliprect = CCRectMake(0, 0, 148, 281),
    icon_ori_x = 30,
    icon_gap_x = 0,
    icon_ori_y = 255,
    icon_gap_y = 60,
    colunNum = 1,
    touchpriority = -130
  }
  ed.fastCreateDragList(self, param)
end

function assigntask:InitDetails()
  assert(self.window, "self.window can not be nil !!! ")
  local wdo = self.window
  local label = wdo:getCompoment("notes")
  ed.setString(label, "\229\143\172\229\155\158\231\142\169\229\174\182\230\149\176\233\135\143\229\143\170\229\156\168\230\156\172\233\161\181\233\157\162\231\148\159\230\149\136\239\188\140\228\184\141\231\174\151\229\133\165\233\130\128\232\175\183\230\156\137\231\164\188\231\173\137\230\180\187\229\138\168")
  local lb = wdo:getCompoment("back_count")
  ed.setString(lb, T("%s\228\186\186", #self.backed_list))
  ed.right2(lb, wdo:getCompoment("back_label"), 2)
  local lb = wdo:getCompoment("wait_back_button_label")
  ed.setString(lb, T("\229\190\133\229\143\172\229\155\158\231\142\169\229\174\182(%s\228\186\186)", #self.wait_list))
  self:RefreshTime()
end

function assigntask:RefreshTime()
  assert(self.window, "self.window can not be nil !!! ")
  local wdo = self.window
  local timer = wdo:getCompoment("timer")
  local tim = wdo:getCompoment("time_label")
  local tm = self.end_time
  if tm <= 0 then
    ed.setString(timer, T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"))
  else
    ed.setString(timer, ed.getdhmsCString(tm, true))
  end
  ed.right2(timer, tim, 2)
end

local function IsEnd()
  return false
end

local function GetRequementCnt(channel, id)
  local task = ed.getDataTable("DailyLoginReturning3rdReward")[channel][id]
  return task["Max Requirement"]
end

function assigntask:ConverData(data, channel)
  assert(data, "personal data can not be nil")
  local id = data._task_id
  local max_rqt = GetRequementCnt(channel, id)
  local pre_max_rqt = 1 < id and GetRequementCnt(channel, id - 1) or 0
  local rwd_cnt = data._task_id - data._reward_flag - 1
  if max_rqt <= data._process then
    rwd_cnt = rwd_cnt + 1
  end
  return {
    pro = math.max(data._process, 0),
    max = max_rqt,
    pre_max = pre_max_rqt,
    rwd_cnt = math.max(rwd_cnt, 0),
    is_end = data._task_id == data._reward_flag
  }
end

function assigntask:InitPersonalTask()
  local data = self:ConverData(self.data._personal, 1)
  self:InitCommonConfig("personal", data)
end

function assigntask:InitGlobalTask()
  local data = self:ConverData(self.data._global, 2)
  self:InitCommonConfig("global", data)
end

function assigntask:InitCommonConfig(channel, data)
  assert(self.window, "self.window can not be nil !!! ")
  self.ui[channel] = self:CreateSyncCompoment(channel, data)
  self:RefreshUI(channel, data)
end

function assigntask:CreateSyncCompoment(channel, data)
  assert(self.window, "self.window can not be nil !!! ")
  local wdo = self.window
  local lb = wdo:getCompoment(T("%s_ct_pro", channel))
  local ld = wdo:getCompoment(T("%s_ct_lb", channel))
  ed.setString(lb, T("%s\228\186\186", data.pro))
  ed.right2(lb, ld, 2)
  local lb = wdo:getCompoment(T("%s_tg_pro", channel))
  local ld = wdo:getCompoment(T("%s_tg_lb", channel))
  ed.setString(lb, T("%s\228\186\186", data.max))
  ed.right2(lb, ld, 2)
  local ct = wdo:getCompoment(T("%s_content_bg", channel))
  local boxres = "eff_UI_box_gold"
  local box = ed.createFcaNode(boxres)
  box:setScale(0.8)
  box:setAction("Close")
  box:setPosition(ccp(360, 70))
  ed.getCurrentScene():addFca(box)
  ct:addChild(box)
  local pro = data.pro - data.pre_max
  local tg = data.max - data.pre_max
  local pr_bar = self:AddProgressBar(pro, tg)
  ct:addChild(pr_bar.node)
  return {box_fca = box, pro_bar = pr_bar}
end

function assigntask:RefreshUI(channel, data)
  assert(self.window, "self.window can not be nil !!! ")
  local ui = self.ui[channel]
  local wdo = self.window
  local cnt = data.rwd_cnt
  local is_end = data.is_end
  local ct = wdo:getCompoment(T("%s_count", channel))
  local offset = wdo:getCompoment(T("%s_label", channel))
  ed.setString(ct, cnt)
  ed.right2(ct, offset, 2)
  if 0 < cnt then
    ui.box_fca:setAction("Shake")
  else
    ui.box_fca:setAction("Close")
  end
  local lab = wdo:getCompoment(T("%s_time_over", channel))
  lab:setVisible(is_end)
  local bc = wdo:getCompoment(T("%s_box_close", channel))
  local bt = wdo:getCompoment(T("%s_request_button", channel))
  local ctp = wdo:getCompoment(T("%s_ct_pro", channel))
  local ctt = wdo:getCompoment(T("%s_ct_lb", channel))
  local tgp = wdo:getCompoment(T("%s_tg_pro", channel))
  local tgt = wdo:getCompoment(T("%s_tg_lb", channel))
  ctp:setVisible(not is_end)
  ctt:setVisible(not is_end)
  tgp:setVisible(not is_end)
  tgt:setVisible(not is_end)
  ui.pro_bar:setVisible(not is_end)
  ui.box_fca:setVisible(not is_end)
  bc:setVisible(not is_end)
  offset:setVisible(not is_end)
  ct:setVisible(not is_end)
  bt:setVisible(not is_end)
end

function assigntask:RegisterBtns()
  local window = self.window
  window:registerBtn("close_button", self:onExit())
  window:registerBtn("wait_back_button", self:OpenList())
  window:registerBtn("rule_button", self:OpenRule())
  window:registerBtn("personal_request_button", self:RequestReward("personal"))
  window:registerBtn("global_request_button", self:RequestReward("global"))
  window:registerCustomTouchBtn({
    button = window:getCompoment("personal_box_close"),
    pressCale = 0.99,
    key = "personalboxtouch",
    pressHandler = function()
      self:doPressBox("personal")
    end,
    cancelPressHandler = function()
      self:doCancelPressBox()
    end,
    clickHandler = function()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  window:registerCustomTouchBtn({
    button = window:getCompoment("global_box_close"),
    pressCale = 0.99,
    key = "globalboxtouch",
    pressHandler = function()
      self:doPressBox("global")
    end,
    cancelPressHandler = function()
      self:doCancelPressBox()
    end,
    clickHandler = function()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
end

function assigntask:doPressBox(channel)
  local window = self.window
  self:doCancelPressBox()
  local chain, id, contaner
  if channel == "global" then
    chain = 2
    id = self.data._global._task_id
    contaner = window:getCompoment("global_box_close")
  else
    chain = 1
    id = self.data._personal._task_id
    contaner = window:getCompoment("personal_box_close")
  end
  local row = ed.getDataTable("DailyLoginReturning3rdReward")[chain][id]
  local idx, auto_str = 1, ""
  while true do
    local r_type = row[T("Reward%s Type", idx)]
    if r_type then
      local r_id = row[T("Reward%s ID", idx)]
      local r_amt = row[T("Reward%s Amount", idx)]
      if auto_str ~= "" then
        auto_str = auto_str .. "<br/>"
      end
      if r_type == "Item" then
        auto_str = auto_str .. self:getBoxRewardTypeStr(r_type, r_amt, r_id)
      else
        auto_str = auto_str .. self:getBoxRewardTypeStr(r_type, r_amt)
      end
    else
      break
    end
    idx = idx + 1
  end
  local ui = ed.createBoxTips(ed.getCurrentScene().scene, auto_str)
  local pos = ed.getWorldPos(contaner, ccp(10, 70))
  ui.tip_msg:setPosition(pos)
  self.boxTip = ui.tip_msg
end

function assigntask:getBoxRewardTypeStr(itemType, num, id)
  repeat
    if itemType == "Gold" then
      return string.format("<sprite src=UI/alpha/HVGA/task_gold_icon_2.png scale=0.7>x%d", num)
    elseif itemType == "EXPAndCrusadePoint" then
      if ed.player:getLevel() >= self.MaxLevel then
        return string.format("<sprite src=UI/alpha/HVGA/money_dragonscale_small.png scale=0.7>x%d", num)
      else
        return string.format("<sprite src=UI/alpha/HVGA/task_exp_icon.png scale=0.35>x%d", num)
      end
    elseif itemType == "Item" then
      return string.format("<sprite id=%d scale=0.35>x%d", id, num)
    else
      if itemType ~= "RandomEquip" then
      end
      do return string.format("<sprite src=UI/alpha/1080P/common/handbook_icon_lock.png scale=0.35>x%d", num) end
      do break end -- pseudo-goto
      if itemType == "GuildPointVIP6" then
        local num = 0
        if ed.player:getvip() < 6 then
          num = 240
        else
          num = 360
        end
        return string.format("<sprite src=UI/alpha/HVGA/money_guildtoken_small.png scale=0.7>x%d", num)
      elseif itemType == "Energy" then
        return string.format("<sprite src=UI/alpha/HVGA/GuildHero/guildhero_energy.png scale=0.7>x%d", num)
      elseif itemType == "GuildHeroExpLevel" then
        local value = 0
        if ed.player:getLevel() >= 91 then
          value = 30
        elseif ed.player:getLevel() >= 81 then
          value = 20
        elseif ed.player:getLevel() >= 61 then
          value = 10
        elseif ed.player:getLevel() >= 41 then
          value = 5
        end
        return string.format("<sprite src=UI/alpha/HVGA/GuildHero/guildhero_exp.png scale=0.7>x%d", value)
      end
    end
  until true
end

function assigntask:doCancelPressBox()
  if self.boxTip then
    self.boxTip:removeFromParentAndCleanup(true)
    self.boxTip = nil
  end
end

function assigntask:RequestReward(channel)
  local function handler()
    local data
    
    if channel == "global" then
      data = self:ConverData(self.data._global, 2)
    else
      data = self:ConverData(self.data._personal, 1)
    end
    if data.rwd_cnt <= 0 then
      ed.showToast("\230\154\130\230\151\160\229\143\175\233\162\134\229\165\150\229\138\177")
      return
    end
    local msg = ed.upmsg.ubackv3()
    msg._reward = ed.upmsg.ubackv3_reward()
    if channel == "global" then
      msg._reward._idx = self.data._global._reward_flag + 1
    else
      msg._reward._idx = self.data._personal._reward_flag + 1
    end
    msg._reward._is_global = channel == "global" and 1 or 0
    ed.send(msg, "ubackv3")
  end
  
  return handler
end

function assigntask:onExit()
  local function handler()
    print("assign task close !!! ")
    
    self.window:close()
    CloseScope(scope)
  end
  
  return handler
end

function assigntask:OpenList()
  local function handler()
    print("open list !!!")
    
    self:OpenFList()
  end
  
  return handler
end

function assigntask:OpenRule()
  local function handler()
    print("open rule !!!")
    
    self:OpenRules()
  end
  
  return handler
end

function assigntask:RequestRewardReply(data)
  local result = data._result
  if result == "success" then
    local rewards = {}
    local prizeType = {
      money = "Gold",
      rmb = "Diamond",
      item = "item",
      hero = "item",
      rand_soul = "item",
      crusadepoint = "CrusadePoint",
      wood = "Wood",
      crystal = "Crystal",
      iron = "Iron"
    }
    for k, reward in pairs(data._rewards or {}) do
      local temp = {
        type = prizeType[reward._type],
        id = reward._id,
        amount = reward._amount
      }
      table.insert(rewards, temp)
    end
    local info = {
      name = "\229\143\172\229\155\158\228\187\187\229\138\161",
      reward = rewards
    }
    
    local function callback()
      if data._is_global == 1 then
        self.data._global._reward_flag = data._idx
        local data = self:ConverData(self.data._global, 2)
        self:RefreshUI("global", data)
      else
        self.data._personal._reward_flag = data._idx
        local data = self:ConverData(self.data._personal, 1)
        self:RefreshUI("personal", data)
      end
    end
    
    ed.ui.task:announceTask(info, callback, {
      title = "\233\162\134\229\143\150\229\165\150\229\138\177"
    })
    ed.ui.activityContent.doTaskConsume(data._rewards)
  else
    ed.showToast("\233\162\134\229\143\150\229\165\150\229\138\177\229\164\177\232\180\165")
  end
end

function assigntask:AddProgressBar(progress, maxValue)
  local config = {
    base = {
      currentProgress = progress,
      maxProgress = maxValue,
      bg = {
        res = "UI/alpha/HVGA/activity/act_list_heroawake_progress_bg.png",
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(0, 0)
        }
      },
      progress = {
        res = "UI/alpha/HVGA/activity/act_list_heroawake_progress.png",
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(2, 0)
        }
      },
      light = {
        res = "UI/alpha/HVGA/activity/act_list_heroawake_high_light.png",
        layout = {
          anchor = ccp(0.8, 0.5),
          position = ccp(0, 0)
        }
      },
      tags = {
        res = "UI/alpha/HVGA/activity/act_list_heroawake_progress_slash.png",
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(0, 0)
        },
        config = {
          splits = {
            {
              text = maxValue / 5,
              layout = {
                anchor = ccp(0.5, 0.5),
                position = ccp(80, -15)
              }
            },
            {
              text = maxValue / 5 * 2,
              layout = {
                anchor = ccp(0.5, 0.5),
                position = ccp(160, -15)
              }
            },
            {
              text = maxValue / 5 * 3,
              layout = {
                anchor = ccp(0.5, 0.5),
                position = ccp(240, -15)
              }
            },
            {
              text = maxValue / 5 * 4,
              layout = {
                anchor = ccp(0.5, 0.5),
                position = ccp(320, -15)
              }
            }
          }
        }
      }
    }
  }
  local pro_bar = ProgressBar:new(config)
  local list = pro_bar:getTags()
  for k, node in ipairs(list) do
    node:setVisible(false)
  end
  pro_bar:setPosition(ccp(3, 65))
  pro_bar:setScaleX(0.8)
  return pro_bar
end

function assigntask:dispatch(msg)
  if msg._open_panel then
    self:Pop(msg._open_panel)
  elseif msg._reward then
    self:RequestRewardReply(msg._reward)
  end
end

local rulePanel

function assigntask:closeRuleInfo()
  rulePanel:getRoot():removeFromParentAndCleanup(true)
  rulePanel = nil
end

local function getRewardResult(data)
  if nil == data then
    return
  end
  local result = T("<text|normalButton|\231\172\172%d\233\152\182\230\174\181: >", data["Reward ID"], data["Max Requirement"])
  local idx = 1
  while true do
    local key = T("Reward%s Type", idx)
    local id = T("Reward%s ID", idx)
    local amt = T("Reward%s Amount", idx)
    if data[key] then
      if "Diamond" == data[key] then
        result = result .. string.format("<sprite|UI/alpha/1080P/common/rmbicon.png|0.5><text|pressButton| %d >", data[amt])
      elseif "Gold" == data[key] then
        result = result .. string.format("<sprite|UI/alpha/1080P/common/goldicon.png|0.5><text|pressButton| %d >", data[amt])
      elseif "ArenaPoint" == data[key] then
        result = result .. string.format("<sprite|UI/alpha/HVGA/money_arenatoken_small.png><text|pressButton| \195\151%d >", data[amt])
      elseif "Item" == data[key] then
        result = result .. string.format("<item|%d|0.5><text|pressButton| \195\151%d >", data[id], data[amt])
      end
      idx = idx + 1
    else
      break
    end
  end
  return result
end

local function appendReward(list, channel)
  local task = ed.getDataTable("DailyLoginReturning3rdReward")
  local tb = task[channel]
  local idx = 1
  while true do
    local row = tb[idx]
    if row then
      local text = getRewardResult(row)
      list:addItem({text})
      idx = idx + 1
    else
      break
    end
  end
end

function assigntask:OpenRules()
  rulePanel = panelMeta:new2(self, assigntask.ruleUI)
  local list = rulePanel.ruleLayer.listview
  list:clear()
  list:addItem({
    "<text|normalButton| >"
  })
  list:addItem({
    T("<text|normalButton|\229\143\172\229\155\158\232\167\132\229\136\153|540>")
  })
  list:addItem({
    T("<text|normalButton|       |482>")
  })
  list:addItem({
    T("<text|normalButton|1\227\128\129\230\180\187\229\138\168\229\188\128\229\167\139\229\144\142\239\188\140\231\179\187\231\187\159\229\176\134\228\188\154\228\184\186\231\142\169\229\174\182\230\142\168\232\141\144\228\184\128\230\137\185\230\156\128\233\171\15220\228\186\186\231\154\132\229\143\172\229\155\158\229\136\151\232\161\168\227\128\130|540>")
  })
  list:addItem({
    T("<text|normalButton|2\227\128\129\229\143\172\229\155\158\229\136\151\232\161\168\228\184\173\231\154\132\231\142\169\229\174\182\239\188\140\229\143\170\232\166\129\229\156\168\230\180\187\229\138\168\230\156\159\233\151\180\228\184\138\231\186\191\228\184\128\230\172\161\239\188\140\229\141\179\231\174\151\230\136\144\229\138\159\229\143\172\229\155\158\227\128\130\231\142\169\229\174\182\231\154\132\229\141\149\228\186\186\229\143\172\229\155\158\232\191\155\229\186\166+1\227\128\130|540>")
  })
  list:addItem({
    T("<text|normalButton|3\227\128\129\230\156\141\229\138\161\229\153\168\229\134\133\230\175\143\228\184\170\231\142\169\229\174\182\232\162\171\230\136\144\229\138\159\229\143\172\229\155\158\239\188\140\230\156\172\230\156\141\232\191\155\229\186\166+1\227\128\130|540>")
  })
  list:addItem({
    T("<text|normalButton|4\227\128\129\229\143\172\229\155\158\232\191\155\229\186\166\232\190\190\229\136\176\228\184\128\230\161\163\229\144\142\229\143\175\228\187\165\233\162\134\229\143\150\229\175\185\229\186\148\231\154\132\229\165\150\229\147\129\239\188\140\230\178\161\230\156\137\233\162\134\229\143\150\231\154\132\229\165\150\229\147\129\229\176\134\232\162\171\228\191\157\229\173\152\229\156\168\229\143\175\233\162\134\229\174\157\231\174\177\229\134\133\227\128\130\230\180\187\229\138\168\230\156\159\229\134\133\233\154\143\230\151\182\229\143\175\228\187\165\233\162\134\229\143\150\227\128\130|540>")
  })
  list:addItem({
    T("<text|normalButton|\229\141\149\228\186\186\229\143\172\229\155\158\229\165\150\229\138\177:|540>")
  })
  list:addItem({
    "<text|normalButton| >"
  })
  appendReward(list, 1)
  list:addItem({
    "<text|normalButton| >"
  })
  list:addItem({
    T("<text|normalButton|\230\156\172\230\156\141\229\143\172\229\155\158\229\165\150\229\138\177:|540>")
  })
  list:addItem({
    "<text|normalButton| >"
  })
  appendReward(list, 2)
  self.window.mainLayer:addChild(rulePanel:getRootLayer(), 600)
end

function assigntask:OpenFList()
  if #(self.wait_list or {}) <= 0 then
    ed.showToast("\228\189\160\231\154\132\229\165\189\229\143\139\229\183\178\229\133\168\233\131\168\229\143\172\229\155\158\227\128\130")
    return
  end
  rulePanel = panelMeta:new2(self, assigntask.ruleUI)
  ed.setString(rulePanel.ruleLayer.title, "\229\190\133\229\143\172\229\155\158\231\142\169\229\174\182")
  local list = rulePanel.ruleLayer.listview
  list:clear()
  table.sort(self.wait_list, function(a, b)
    return a._friend_point > b._friend_point
  end)
  for _, v in ipairs(self.wait_list) do
    list:changeItemConfig(1)
    local param = {
      scale = 0.8,
      id = v._user_summary._avatar,
      vip = 0 < v._user_summary._vip,
      level = v._user_summary._level,
      name = v._user_summary._name
    }
    local pt = T("\229\143\139\230\131\133\231\130\185\239\188\154%s", v._friend_point)
    list:addItem({param, pt})
  end
  self.window.mainLayer:addChild(rulePanel:getRootLayer(), 600)
end

assigntask.ruleUI = {
  {
    layerName = "ruleLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -200,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "ruleInfo",
          res = "UI/alpha/1080P/common/main_vit_tips.png",
          capInsets = CCRectMake(15, 20, 45, 15)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 240)
        },
        config = {
          scaleSize = CCSizeMake(590, 360)
        }
      },
      {
        t = "Label",
        base = {
          name = "title",
          text = T("\231\142\169\229\174\182\229\143\172\229\155\158"),
          size = 22,
          parent = "ruleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(295, 330)
        },
        config = {
          color = ccc3(251, 206, 16)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "heroInfo",
          parent = "ruleInfo",
          res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(295, 330)
        },
        config = {
          scalexy = {x = 1.5, y = 1.1}
        }
      },
      {
        t = "SpriteButton",
        base = {
          name = "closeRuleInfo",
          sound = "sound_menu/common_close_popup_window.mp3",
          res = {
            normal = "UI/alpha/1080P/common/common_tips_button_close_1.png"
          },
          parent = "ruleInfo",
          handleName = "closeRuleInfo"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(574, 340)
        }
      },
      {
        t = "ListView",
        base = {
          name = "listview",
          heightInner = 5,
          cliprect = CCRectMake(120, 90, 560, 270),
          priority = -500
        },
        itemConfig = {
          {
            t = "RichText",
            base = {name = "name", text = ""},
            layout = {
              anchor = ccp(0, 0.5),
              position = ccp(20, 10)
            },
            listData = true
          }
        },
        itemConfig1 = {
          {
            t = "Scale9Sprite",
            base = {
              name = "bg",
              res = "UI/alpha/HVGA/pvp/pvp_rank_bg_low.png",
              capInsets = CCRectMake(15, 20, 45, 15)
            },
            layout = {
              anchor = ccp(0, 1),
              position = ccp(-1, 0)
            },
            config = {
              scaleSize = CCSizeMake(555, 60)
            }
          },
          {
            t = "Sprite",
            base = {name = "icon"},
            layout = {
              anchor = ccp(0, 1),
              position = ccp(32, -30)
            },
            specialType = "heroIcon",
            listData = true
          },
          {
            t = "Label",
            base = {
              name = "worshipLabel",
              text = T("\229\143\139\230\131\133\231\130\185\239\188\15410"),
              fontinfo = "offlinequest_red"
            },
            layout = {
              anchor = ccp(0.5, 0.5),
              position = ccp(490, -27)
            },
            listData = true
          }
        }
      }
    }
  }
}
ListenEvent("ubackv3", function(data)
  assigntask.is_open = data
end)
