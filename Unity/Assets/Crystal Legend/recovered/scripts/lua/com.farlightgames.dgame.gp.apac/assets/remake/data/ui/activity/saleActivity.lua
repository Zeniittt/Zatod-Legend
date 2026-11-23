local base = ed.ui.popwindow
local class = newclass(base.mt)
class.__index = class
local ed = ed
local pairs = pairs
local scope = {}
local showPanel
ed.ui.saleActivity = class
local aFrame = ed.ui.activityBase

local function outOfTime(b_time, e_time)
  if b_time > ed.getServerTime() or e_time < ed.getServerTime() then
    return true
  end
end

local function resetSaliListUI(replys)
  if replys._result then
    local k = ed.netdata.sale_index
    local self = ed.netdata.sale_self
    if not self then
      return
    end
    local data = self.reward_list[k]
    data._dailyjob._task_target = 1
    for i, data in ipairs(self.reward_list) do
      local ui = self["sale_ui_" .. i]
      self:resetSaleUI(ui, data)
    end
  end
  ed.netdata.sale_self = nil
  ed.netdata.sale_index = nil
  ed.netdata.sale_price = nil
end

local function getSaleReply(replys)
  local self = ed.netdata.sale_self
  CloseScope(scope)
  if not replys._result then
    ed.showToast(T("\232\180\173\228\185\176\231\137\169\229\147\129\229\164\177\232\180\165"))
  else
    if self.buyLayer and not self.buyLayer:checknull() then
      self.buyLayer:destroy()
    end
    ed.player:subrmb(ed.netdata.sale_price)
    local info = replys._activity_reward
    ed.ui.activityContent.doTaskConsume(info)
    resetSaliListUI(replys)
  end
end

local function destroyLayer(self)
  if showPanel and not tolua.isnull(showPanel) then
    showPanel:removeFromParentAndCleanup(true)
    showPanel = nil
  end
end

function class:doPressInRewardList(x, y)
  destroyLayer()
  if not self.draglist or not self.draglist:isVisible() then
    return
  end
  for k, activity_rewards in pairs(self.reward_list) do
    local button = self["sale_ui_" .. k].sale_bg
    if button:isVisible() and ed.containsPoint(button, x, y) then
      local list = self["sale_ui_" .. k]
      local i = ed.containsPoint(list.sale_equip_icon, x, y)
      if i then
        showPanel = ed.readequip.getDetailCard(self.reward_list[k]._rewards[1]._id)
        showPanel:setPosition(ccp(150, 80))
        local node = self["sale_ui_" .. k].sale_bg
        node:addChild(showPanel, 600)
        return k, i
      else
        button:setScale(0.7124999999999999)
        return k
      end
    end
  end
end

function class:doPressInList()
  local function handler(x, y, k, i)
    return self:doPressInRewardList(x, y, k, i)
  end
  
  return handler
end

local function doBuy(self, data, k, job)
  local function handler(addition)
    if ed.ui.marketconfig.checkPackageFull(data.id, data.amount) then
      ed.showToast(T("\230\130\168\231\154\132\232\131\140\229\140\133\230\178\161\230\156\137\232\182\179\229\164\159\231\154\132\231\169\186\233\151\180"))
    elseif ed.player._rmb < data.price then
      ed.showToast(T("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\140\232\175\183\229\133\133\229\128\188\229\144\142\229\134\141\232\180\173\228\185\176"))
    else
      local msg = ed.upmsg.job_rewards()
      msg._job = job
      ed.netreply.saleActivity = true
      ed.netdata.sale_index = k
      ed.netdata.sale_self = self
      ed.netdata.sale_price = data.price
      ListenEvent("saleActivity", getSaleReply, scope)
      ed.send(msg, "job_rewards")
    end
  end
  
  return handler
end

class.doBuy = doBuy

function class:buyBoard(k, activity_rewards)
  local data = {
    id = self.reward_list[k]._rewards[1]._id,
    amount = 1,
    price = self.reward_list[k]._extra_reward_info._price,
    pay = "diamond"
  }
  data.doBuy = self:doBuy(data, k, activity_rewards._dailyjob._id)
  self.buyLayer = ed.ui.equipboard.init("ofbuy", data)
  self.buyLayer:popWindow(600)
end

function class:doClickInRewarList(x, y, k, i)
  destroyLayer()
  if k and not i then
    if not self.draglist or not self.draglist:isVisible() then
      return
    end
    local button = self["sale_ui_" .. k].sale_bg
    button:setScale(0.75)
    if outOfTime(self.b_time, self.e_time) then
      ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\144\175"))
      return
    end
    local activity_rewards = self.reward_list[k]
    if ed.getServerTime() - self.e_time > 86400 then
      ed.showToast(T("\230\130\168\229\183\178\231\187\143\232\191\135\228\186\134\232\180\173\228\185\176\230\151\182\233\151\180"))
      return
    end
    if activity_rewards._dailyjob._task_target ~= 0 then
      ed.showToast(T("\232\180\173\228\185\176\230\172\161\230\149\176\229\183\178\231\187\143\231\148\168\229\174\140"))
      return
    end
    self:buyBoard(k, activity_rewards)
  end
end

function class:doClickInList()
  local function handler(x, y, k, i)
    self:doClickInRewarList(x, y, k, i)
  end
  
  return handler
end

function class:cancelInList(x, y, k)
  destroyLayer()
  if not self.draglist or not self.draglist:isVisible() then
    return
  end
  local button = self["sale_ui_" .. k].sale_bg
  button:setScale(0.75)
end

function class:cancelPressInList()
  local function handler(x, y, k)
    self:cancelInList(x, y, k)
  end
  
  return handler
end

function class:cancelClickInList()
  local function handler(x, y, k)
    self:cancelInList(x, y, k)
  end
  
  return handler
end

function class:resetSaleUI(ui, data)
  local dailyjob = data._dailyjob
  if dailyjob then
    local sale_time = dailyjob._task_target
    if sale_time == 0 then
      ed.setString(ui.sale_time, "0/1")
    elseif sale_time == 1 then
      ed.setString(ui.sale_time, "1/1")
      ui.sale_bg_finish:setVisible(true)
    else
      EDDebug("dailyjob _taskTarget cannot expect")
    end
  end
end

function class:slaeInitData(ui, data)
  local item = data._rewards[1]
  local tid = item._id
  local _type = item._type
  local amount = item._amount
  local price = data._extra_reward_info._price
  local equip
  if _type == "item" then
    equip = ed.lookupDataTable("equip")[tid].Name .. "x" .. amount
  else
  end
  local icon = aFrame.createItemPrizeIcon(_type, tid)
  ui.sale_bg:addChild(icon)
  ui.sale_equip_icon = icon
  icon:setScale(1.1)
  icon:setPosition(ccp(50, 47))
  ed.setString(ui.price, price)
  ed.setString(ui.title, equip)
  self:resetSaleUI(ui, data)
end

function class:createSaleList(layer)
  local layer = layer
  local dt = 77
  local fix = 350
  local height_content = self.ui.str_context:getContentSize().height * self.ui.str_context:getScaleY() + 75
  for k, data in pairs(self.reward_list) do
    local data = self.reward_list[k]
    self["sale" .. k], self["sale_ui_" .. k] = ed.editorui(ed.uieditor.saleActivitySaleList)
    local list, ui = self["sale" .. k], self["sale_ui_" .. k]
    self:slaeInitData(ui, data)
    list:setPosition(ccp(10, fix - k * dt - height_content))
    layer:addChild(list)
  end
  local list_height = dt * #self.reward_list
  self.draglist:initListHeight(list_height + height_content + 10)
end

function class:createActivityContent(layer)
  self.ui = self.ui or {}
  local ui = self.ui
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "str_title_1",
        text = T("\230\180\187\229\138\168\230\151\182\233\151\180\239\188\154"),
        size = 18
      },
      layout = {
        position = ccp(32, 351),
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
        position = ccp(32, 312),
        anchor = ccp(0, 0)
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
        position = ccp(32, 300),
        anchor = ccp(0, 0.5)
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
        position = ccp(32, 285),
        anchor = ccp(0, 1)
      },
      config = {
        color = ccc3(248, 248, 214),
        dimensions = CCSizeMake(390, 0),
        verticalAlignment = kCCVerticalTextAlignmentTop,
        horizontalAlignment = kCCTextAlignmentLeft
      }
    }
  }
  local readNode = ed.readnode.create(layer, self.ui)
  readNode:addNode(ui_info)
  ui.str_times:setString(string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(self.b_time), ed.formatTime(self.e_time)))
  ui.str_context:setString(self.content)
end

function class:initWindow()
  self.container, self.frameUi = ed.editorui(ed.uieditor.saleActivityFrame)
  self.frameUi.a_title:setString((self.info or {})._title or "")
  self.frameUi.a_title:setShadow(ccc3(0, 0, 0), ccp(0, 2))
  local draglistInfo = {
    cliprect = CCRectMake(17, 65, 417, 295),
    rect = CCRectMake(20, 65, 410, 295),
    container = self.frameUi.a_frame,
    priority = -120,
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
  local layer = self.draglist:getList()
  self:createActivityContent(layer)
  self:createSaleList(layer)
  self.container:registerScriptHandler(self:getEventHandler())
end

function class:getEventHandler()
  local function handler(event)
    xpcall(function()
      if event == "exit" then
        CloseScope(scope)
      end
    end, EDDebug)
  end
  
  return handler
end

function class:initData(info)
  local info = info or {}
  self.info = info
  local extra_info = info._extra_info or {}
  self.pro_bar_tag = extra_info._grade
  self.option_list = extra_info._hero_pop or {}
  self.reward_list = info._rewards or {}
  self.b_time = info._start_time
  self.e_time = info._end_time
  self.content = info._desc or ""
  self.sale_time = 1
  self.current_sale_time = 1
end

function class:create(info)
  local obj = {}
  setmetatable(obj, class)
  obj:initData(info)
  obj:initWindow()
  obj.container:setTouchEnabled(true)
  return obj
end
