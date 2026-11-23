local class, base = newwindow()
local ed = ed
ed.ui.activityContent = class
eg = class
local ipairs = ipairs
local initDraglistHeight = 300
local showPanel, currentIndex
local activityType = ""
TenPumpingScope = {}
local activityBase = ed.ui.activityBase

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

class.getRunScene = getRunScene
local activityTypePanel = {
  arena_foothold = "NoButtonActivityList_big",
  dreamland_draw = "NoButtonActivityList",
  compose = "ComposeActivityList",
  red_envelope = "ActivityRedBagList"
}
local activityTypePanelDt = {
  ActivityRedBagList = 113,
  NoButtonActivityList = 40,
  NoButtonActivityList_big = 80
}
local activityTagsContent = {
  arena_foothold = "\229\141\160\233\162\134\230\141\174\231\130\185\230\149\176\233\135\143\229\143\138\229\165\150\229\138\177\229\136\134\233\133\141\229\166\130\228\184\139\239\188\154",
  dreamland_draw = "\228\188\164\229\174\179\232\190\147\229\135\186\229\143\138\229\143\175\232\142\183\229\190\151\231\129\181\233\173\130\231\159\179\229\136\134\233\133\141\229\166\130\228\184\139\239\188\154"
}

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

function class.doTaskConsume(info)
  ed.ui.activityBase:doTaskConsume(info)
end

local function createFlyLayer(config)
  local config = config or {}
  local parent = config.parent
  local index = config.index
  local type = config.type
  local id = config.id
  if showPanel then
    showPanel:removeFromParentAndCleanup(true)
    showPanel = nil
  end
  if nil == showPanel then
    if "rmb" == type then
      showPanel = ed.readequip.getDetailCard("Diamond")
    elseif "money" == type then
      showPanel = ed.readequip.getDetailCard("Gold")
    elseif "rand_soul" == type then
      showPanel = ed.readequip.getDetailCard("rand_soul")
    elseif "medal" == type then
      local info = {}
      info.medal = ed.lookupDataTable("Medal", "Name", tonumber(id))
      info.ps = ed.lookupDataTable("Medal", "Description", tonumber(id))
      showPanel = ed.readequip.getDetailCard("Medal", info)
    else
      showPanel = ed.readequip.getDetailCard(id)
    end
    local x, y = setPostion(parent, index)
    local pos = ccp(x, y)
    showPanel:setAnchorPoint(ccp(0.5, 0))
    showPanel:setPosition(pos)
  end
  parent:addChild(showPanel, 600)
  return showPanel
end

class.createFlyLayer = createFlyLayer

local function createComposeFlyLayer(config)
  createFlyLayer(config)
  showPanel:setPosition(ccp(20, 30))
end

class.createComposeFlyLayer = createComposeFlyLayer

local function suspensionLayer(self, k, i)
  local parent = self["rewardsui" .. k]["reward_" .. i]
  local info = self.info._rewards[k]
  local pinfo = info._rewards[i]
  if not pinfo then
    return
  end
  local config = {
    parent = self["rewardsui" .. k].reward_bg,
    index = i,
    type = pinfo._type,
    id = pinfo._id
  }
  createFlyLayer(config)
end

class.suspensionLayer = suspensionLayer

local function destroyLayer(self)
  if showPanel then
    showPanel:removeFromParentAndCleanup(true)
    showPanel = nil
    return true
  end
end

class.destroyLayer = destroyLayer

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

local function doClickPrizeReply(replys)
  local callback = ed.netreply.handler
  local rfunction = ed.ui.activityBase:requesetRewardReply(callback)
  rfunction(replys)
  ed.netreply.handler = nil
end

class.doClickPrizeReply = doClickPrizeReply

local function extraReplyHandler(self, k)
  local function handler()
    local type = self.info._type
    
    if type == "compose" then
      local data = self.info._rewards[k]
      local composeInfo = data._extra_reward_info._compose_info or {}
      local itemId = composeInfo._item_id
      ed.player:addEquip(itemId, -1)
      data._dailyjob._last_rewards_time = 1
      local ui = self["rewardsui" .. k]
      self:resetComposeRewardsList(ui, data)
    else
      local data = self.info._rewards[k]
      data._dailyjob._last_rewards_time = ed.getServerTime()
      local ui = self["rewardsui" .. k]
      self:resetNormalUI(ui, data)
    end
  end
  
  return handler
end

local function finishCompose(id, data)
  return ed.player:getEquipAmount(id) >= (data._amount or 0) and data._dailyjob._task_target >= data._amount
end

class.finishCompose = finishCompose

local function getPrize(self, k)
  local data = self.info._rewards[k]
  currentIndex = k
  if not self.state.begain then
    ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\167\139"))
    return
  end
  if self.state.overGetTime then
    ed.showToast(T("\230\130\168\229\183\178\231\187\143\232\191\135\228\186\134\233\162\134\229\165\150\230\151\182\233\151\180"))
    return
  end
  if data._dailyjob._last_rewards_time ~= 0 then
    ed.showToast(T("\230\130\168\229\183\178\231\187\143\233\162\134\232\191\135\229\165\150\228\186\134"))
    return
  end
  if "compose" == self.info._type then
    local composeInfo = data._extra_reward_info._compose_info or {}
    local itemId = composeInfo._item_id
    if not self.finishCompose(itemId, data) then
      return
    end
  elseif data._dailyjob._task_target < (data._amount or 0) then
    return
  end
  ed.netreply.handler = extraReplyHandler(self, k)
  local msg = ed.upmsg.job_rewards()
  msg._job = data._dailyjob._id
  ed.netreply.tenPumping = "1"
  ed.send(msg, "job_rewards")
end

class.getPrize = getPrize

local function composeReply(self, data, k)
  local function handler()
    data._dailyjob._task_target = 1
    
    local ui = self["rewardsui" .. k]
    self:resetComposeRewardsList(ui, data)
    local msg = ed.upmsg.ask_activity_info()
    ed.send(msg, "ask_activity_info")
    CloseScope(TenPumpingScope)
  end
  
  return handler
end

function class:openCreaftPanel(eid)
  if self.state.ends then
    ed.showToast("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159")
    return
  end
  local config = {
    context = "handbook",
    drop = "specialdrop",
    eid = eid,
    openCraftPanel = true,
    notOpenLeftPanel = true
  }
  local craftLayer = ed.ui.equipcraft.create(config)
  getRunScene():addChild(craftLayer.mainLayer, 600)
end

function class:composeGetPrize(k)
  local data = self.info._rewards[k]
  local composeInfo = data._extra_reward_info._compose_info or {}
  local itemId = composeInfo._item_id
  if data._dailyjob._last_rewards_time == 0 and not self.finishCompose(itemId, data) then
    local eid = data._extra_reward_info._compose_info._item_id
    self:openCreaftPanel(eid)
    ListenEvent("composeActivity", composeReply(self, data, k), TenPumpingScope)
  else
    self:getPrize(k)
  end
end

local function clickRewardIcon(list, x, y)
  for i = 1, 4 do
    if ed.containsPoint(list["reward_" .. i], x, y) and list["reward_" .. i]:isVisible() then
      return i
    end
  end
end

function class:doClickInNormalList(x, y, k, i)
  destroyLayer()
  if k and not i then
    self["rewardsui" .. k].reward_bg:setScale(0.75)
    self:getPrize(k)
  end
end

function class:doClickInComposeList(x, y, k, i)
  destroyLayer()
  if k and not i then
    local ui = self["rewardsui" .. k]
    ui.reward_bg:setScale(0.75)
    local rewards = ui.rewards_data
    for k, item in pairs(rewards) do
      if ed.containsPoint(item.icon, x, y) then
        return
      end
    end
    self:composeGetPrize(k)
  end
end

function class:enterRecharge()
  ed.ui.ActivityScene.exit()
  local currentScene = getRunScene()
  local rechargeMgr = ed.RechargeNewMgr.getInstance()
  if true == rechargeMgr:isUseNewRechargeMedule() then
    ed.pushScene(ed.ui.recharge.create({page = "Diamonds"}))
  else
    local rechargeLayer = ed.ui.recharge.create()
    currentScene:addChild(rechargeLayer.mainLayer, 200)
  end
end

function class:enterGamble()
  ed.ui.ActivityScene.exit()
  
  function ed.netdata.gambleOpenPanel(data)
    local panel = GambleMainPanel.create()
    panel:popWindow()
  end
  
  ed.GambleNetwork:openPanelRequest()
end

function class:enterMultiarena()
  ed.ui.ActivityScene.exit()
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("MultiArena")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.CrArenaNetwork:sendOpenPanel()
end

function class:enterKingspvp()
  ed.ui.ActivityScene.exit()
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("RealArena")
  if ds then
    ed.showToast(ds)
    return
  end
  if ed.realarena.network_mgr then
    ed.realarena.network_mgr:UnregisterEvents()
  else
    ed.realarena.network_mgr = ed.realarena.NetworkMgr.Create()
  end
  if ed.realarena.mgr then
    ed.realarena.mgr:UnregisterEvents()
  else
    ed.realarena.mgr = ed.realarena.RealArenaMgr.Create()
  end
  ed.realarena.network_mgr:RegisterEvents()
  ed.realarena.mgr:RegisterEvents()
  ed.realarena.network_mgr:RequestOpenPanel()
end

function class:enterRedBagRecord(id)
  ed.ui.redBag.requestRedBagInfo(id, 1)
end

function class:sendRedBag(redBagId)
  ed.ui.redBag:create(redBagId)
end

function class:enterDreamland()
  local lsr = ed.ui.mainlsr.create()
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("Dreamland")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.dreamland.network_mgr:RequestOpenPanel()
end

function class:enterRealArena()
  ed.ui.main:enterRealArena()
end

function class:enterPve()
  ed.pushScene(ed.ui.stageselect.create())
end

function class.enterIncubu()
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("Nightmare")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.incubus.NetWork:openPanel()
end

function class:enterMultiArena()
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("MultiArena")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.CrArenaNetwork:sendOpenPanel()
end

function class:openUrl()
  local url = self.info._url
  if url then
    ed.openURL(url)
  else
    ed.showToast("url \228\184\186\231\169\186")
  end
end

function class:enterEzioToy()
  function ed.netreply.ezioToy(data)
    if data._have_all_ubi_heroes == 0 then
      ed.showToast(T("\230\139\165\230\156\1373\228\184\170\232\130\178\231\162\167\232\139\177\233\155\132\231\154\132\231\142\169\229\174\182\233\154\143\230\156\186\232\181\160\233\128\129\228\184\164\228\184\170\230\137\139\229\138\158\228\184\173\231\154\132\228\184\128\228\184\170"))
      
      return
    elseif data._receiver_info == nil and data._toy_amount_left == 0 then
      ed.showToast(T("\230\156\172\230\156\159\229\165\150\229\138\177\229\183\178\231\187\143\232\162\171\233\162\134\229\143\150\229\174\140\230\175\149\239\188\140\230\149\172\232\175\183\230\156\159\229\190\133\228\184\139\230\172\161\230\180\187\229\138\168\227\128\130"))
      return
    end
    ed.ui.ActivityScene.exit()
    local win = EzioToyActivity.create(data._receiver_info)
    win:popWindow()
  end
  
  ed.EzioToyNetwork:openPanel()
end

function class:enterSuperExchange()
  ed.ui.ActivityScene.exit()
  local panel = ActivityNewYear.create(self.info)
  panel:popWindow()
end

function class.enterFortuneWheel()
  ed.ui.ActivityScene.exit()
  ed.ui.fortunewheelNetwork.openPanel()
end

function class:enterDreamlandTitanwar()
  local pl = ed.playerlimit
  local cpl = pl.getAreaUnlockPrompt
  local ds = cpl("Dreamland")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.dreamland.network_mgr:RequestOpenPanel()
end

function class:doClickInRedBagList(x, y, k, i)
  local ui = self["rewardsui" .. k]
  local data = self.info._rewards[k]
  if ui.join_act_unclick:isVisible() and ed.containsPoint(ui.join_act_unclick, x, y) then
    ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\144\175"))
    return
  end
  if ui.join_act:isVisible() and ed.containsPoint(ui.join_act_press, x, y) then
    ui.join_act:setVisible(true)
    ui.join_act_press:setVisible(false)
    self:enterRecharge()
  end
  if ui.record:isVisible() and ed.containsPoint(ui.record_press, x, y) then
    ui.record:setVisible(true)
    ui.record_press:setVisible(false)
    self:enterRedBagRecord(self.info._rewards[k]._extra_reward_info._red_envelope._red_id)
  end
  if ui.send:isVisible() and ed.containsPoint(ui.send_press, x, y) then
    ui.send:setVisible(true)
    ui.send_press:setVisible(false)
    self:sendRedBag(self.info._rewards[k]._extra_reward_info._red_envelope._red_id)
  end
end

local function doClickInList(self)
  local function handler(x, y, k, i)
    local panelType = self:getActivityTypePanel()
    
    if "ActivityRedBagList" == panelType then
      return self:doClickInRedBagList(x, y, k, i)
    elseif "ComposeActivityList" == panelType then
      return self:doClickInComposeList(x, y, k, i)
    elseif "NoButtonActivityList" == panelType or "NoButtonActivityList_big" == panelType then
    else
      return self:doClickInNormalList(x, y, k, i)
    end
  end
  
  return handler
end

class.doClickInList = doClickInList

function class:doPressInNormalList(x, y)
  destroyLayer()
  for k = 1, self.rewardsNum do
    if ed.containsPoint(self["rewardsui" .. k].reward_bg, x, y) and self["rewardsui" .. k].reward_bg:isVisible() then
      local list = self["rewardsui" .. k]
      local i = clickRewardIcon(list, x, y)
      if i then
        self:suspensionLayer(k, i)
        return k, i
      else
        self["rewardsui" .. k].reward_bg:setScale(0.73)
        return k
      end
    end
  end
end

function class:doPressInComposeList(x, y)
  destroyLayer()
  for k = 1, self.rewardsNum do
    local ui = self["rewardsui" .. k]
    local rewards = ui.rewards_data
    for i, item in pairs(rewards) do
      if ed.containsPoint(item.icon, x, y) then
        local data = item.data
        local config = {
          parent = item.icon,
          index = i,
          type = data.type,
          id = data.id
        }
        self.createComposeFlyLayer(config)
        return k
      end
    end
    if ed.containsPoint(ui.reward_bg, x, y) and ui.reward_bg:isVisible() then
      ui.reward_bg:setScale(0.73)
      return k
    end
  end
end

function class:doPressInRedBagList(x, y)
  for k = 1, self.rewardsNum do
    local ui = self["rewardsui" .. k]
    if ui.join_act_unclick:isVisible() and ed.containsPoint(ui.join_act_unclick, x, y) then
      return k
    end
    if ui.join_act:isVisible() and ed.containsPoint(ui.join_act, x, y) then
      ui.join_act:setVisible(false)
      ui.join_act_press:setVisible(true)
      return k
    end
    if ui.record:isVisible() and ed.containsPoint(ui.record, x, y) then
      ui.record:setVisible(false)
      ui.record_press:setVisible(true)
      return k
    end
    if ui.send:isVisible() and ed.containsPoint(ui.send, x, y) then
      ui.send:setVisible(false)
      ui.send_press:setVisible(true)
      return k
    end
  end
end

local function doPressInList(self)
  local function handler(x, y)
    local panelType = self:getActivityTypePanel()
    
    if "ActivityRedBagList" == panelType then
      return self:doPressInRedBagList(x, y)
    elseif "ComposeActivityList" == panelType then
      return self:doPressInComposeList(x, y)
    elseif "NoButtonActivityList" == panelType or "NoButtonActivityList_big" == panelType then
    else
      return self:doPressInNormalList(x, y)
    end
  end
  
  return handler
end

class.doPressInList = doPressInList

function class:recoveryRedBagButton(k, x, y)
  local ui = self["rewardsui" .. k]
  if ui.join_act_press:isVisible() then
    ui.join_act:setVisible(true)
    ui.join_act_press:setVisible(false)
  end
  if ui.record_press:isVisible() then
    ui.record:setVisible(true)
    ui.record_press:setVisible(false)
  end
  if ui.send_press:isVisible() then
    ui.send:setVisible(true)
    ui.send_press:setVisible(false)
  end
end

function class:cancelPressInRedBagList(x, y, k, i)
  self:recoveryRedBagButton(k, x, y)
end

function class:cancelPressInNormalList(x, y, k, i)
  destroyLayer()
  self["rewardsui" .. k].reward_bg:setScale(0.75)
end

function class:cancelPressInComposeList(x, y, k, i)
  destroyLayer()
  self["rewardsui" .. k].reward_bg:setScale(0.75)
end

local function cancelPressInList(self)
  local function handler(x, y, k, i)
    local panelType = self:getActivityTypePanel()
    
    if "ActivityRedBagList" == panelType then
      return self:cancelPressInRedBagList(x, y, k, i)
    elseif "ComposeActivityList" == panelType then
      return self:cancelPressInComposeList(x, y, k, i)
    elseif "NoButtonActivityList" == panelType or "NoButtonActivityList_big" == panelType then
    else
      return self:cancelPressInNormalList(x, y, k, i)
    end
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

function class:cancelClickInRedBagList(x, y, k, i)
  self:recoveryRedBagButton(k, x, y)
end

function class:cancelClickInNormalList(x, y, k, i)
  destroyLayer()
  self["rewardsui" .. k].reward_bg:setScale(0.75)
end

function class:cancelClickInComposeList(x, y, k, i)
  destroyLayer()
  self["rewardsui" .. k].reward_bg:setScale(0.75)
end

local function cancelClickInList(self)
  local function handler(x, y, k, i)
    local panelType = self:getActivityTypePanel()
    
    if "ActivityRedBagList" == panelType then
      return self:cancelClickInRedBagList(x, y, k, i)
    elseif "ComposeActivityList" == panelType then
      return self:cancelClickInComposeList(x, y, k, i)
    elseif "NoButtonActivityList" == panelType or "NoButtonActivityList_big" == panelType then
    else
      return self:cancelClickInNormalList(x, y, k, i)
    end
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList
class.enterButtonTable = {
  rmb_recharge = {
    text = T("\231\171\139\229\141\179\229\133\133\229\128\188"),
    handler = function()
      class:enterRecharge()
    end
  },
  real_arena = {
    text = T("\231\171\139\229\141\179\229\143\130\229\138\160"),
    handler = function()
      class:enterRealArena()
    end
  },
  dreamland_draw = {
    text = T("\231\171\139\229\141\179\229\143\130\229\138\160"),
    handler = function()
      class:enterDreamland()
    end
  },
  first_recharge = {
    text = T("\231\171\139\229\141\179\229\133\133\229\128\188"),
    handler = function()
      class:enterRecharge()
    end
  },
  reach_level = {
    text = T("\229\137\141\229\190\128"),
    handler = function()
      class:enterPve()
    end
  },
  nightmare_special = {
    text = T("\231\171\139\229\141\179\229\143\130\229\138\160"),
    handler = function()
      class:enterIncubu()
    end
  },
  rt2v2_rewards = {
    text = T("\231\171\139\229\141\179\229\143\130\229\138\160"),
    handler = function()
      class:enterMultiArena()
    end
  },
  dreamland = {
    text = T("\229\137\141\229\190\128"),
    handler = function()
      class:openUrl()
    end
  },
  global_quiz = {
    text = T("\229\137\141\229\190\128"),
    handler = function()
      class:enterGamble()
    end
  },
  kingspvp = {
    text = T("\231\171\139\229\141\179\229\137\141\229\190\128"),
    handler = function()
      class:enterKingspvp()
    end
  },
  multiarena = {
    text = T("\231\171\139\229\141\179\229\137\141\229\190\128"),
    handler = function()
      class:enterMultiarena()
    end
  },
  dreamland_rank = {
    text = T("\231\171\139\229\141\179\229\137\141\229\190\128"),
    handler = function()
      class:enterDreamland()
    end
  },
  ezio_toy = {
    text = T("\233\162\134\229\143\150\230\137\139\229\138\158"),
    handler = function()
      class:enterEzioToy()
    end
  },
  super_exchange = {
    text = T("\231\171\139\229\141\179\229\137\141\229\190\128"),
    handler = function()
      class:enterSuperExchange()
    end
  },
  fortune_wheel = {
    text = T("\231\171\139\229\141\179\229\137\141\229\190\128"),
    handler = function()
      class.enterFortuneWheel()
    end
  },
  dreamland_titanwar = {
    text = T("\231\171\139\229\141\179\229\137\141\229\190\128"),
    handler = function()
      class.enterDreamlandTitanwar()
    end
  }
}

function class:showEnter_button()
  local buttonType = class.enterButtonTable
  local ezioToy = ed.storage.getBool("EzioToyKey")
  if ezioToy then
    buttonType.ezio_toy.text = T("\228\191\174\230\148\185\229\156\176\229\157\128")
  end
  local type = self.info._type
  if buttonType[type] and self.state.begain and not self.state.ends then
    if type == "dreamland" and not self.info._url then
      return false
    end
    if buttonType[type].text then
      self.frameUi.enter_label:setString(buttonType[type].text)
    end
    return true, buttonType[type].handler
  end
  return false
end

local function touch(self, event, x, y)
  if tolua.isnull(self.container) then
    return
  end
  if event == "began" then
    if ed.containsPoint(self.frameUi.enter_button, x, y) and self.frameUi.enter_button:isVisible() then
      self.frameUi.enter_button:setVisible(false)
      self.frameUi.enter_button_press:setVisible(true)
      return
    end
  elseif event == "moved" then
  elseif event == "ended" then
    local showEnter_button, handler = self:showEnter_button()
    if showEnter_button then
      self.frameUi.enter_button:setVisible(true)
      self.frameUi.enter_button_press:setVisible(false)
    end
    if ed.containsPoint(self.frameUi.enter_button, x, y) and self.frameUi.enter_button:isVisible() and handler then
      handler()
    end
  end
end

class.touch = touch

local function doMainLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      self:touch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function setTextContent(ui)
  ui:setDimensions(CCSizeMake(390, 0))
  ui:setHorizontalAlignment(kCCTextAlignmentLeft)
  ui:setVerticalAlignment(kCCVerticalTextAlignmentTop)
end

local function createPrize(listdata)
  local iconlist = {}
  local list = listdata or {}
  local i = 0
  for k, v in ipairs(list) do
    local icon = CCSprite:create()
    local plistIcon1, plistIcon, plistName, plistNum
    if v._type == "item" then
      plistIcon = ed.readequip.createIcon(v._id)
    elseif v._type == "hero" then
      plistIcon = ed.readequip.createIcon(v._id)
    elseif v._type == "rmb" then
      plistIcon = CCSprite:create("UI/alpha/1080P/icon/diamond_icon.png")
    elseif v._type == "money" then
      plistIcon = CCSprite:create("UI/alpha/1080P/icon/gold_icon.png")
    elseif v._type == "rand_soul" then
      plistIcon1, fragmentIcon = ed.readequip.getUnknownHeroStone()
      plistIcon1:setAnchorPoint(ccp(0, 0))
      plistIcon1:setPosition(ccp(0, 0))
      plistIcon = ed.createScale9Sprite("UI/alpha/HVGA/fragment_frame_blue.png")
      plistIcon:setAnchorPoint(ccp(0, 0))
      plistIcon:setPosition(ccp(0, 0))
      plistIcon:addChild(plistIcon1)
    elseif v._type == "medal" then
      local path = ed.lookupDataTable("Medal", "Picture", tonumber(v._id))
      plistIcon = ed.createSprite(path)
      plistIcon:setScale(0.8)
    end
    plistIcon:setAnchorPoint(ccp(0.5, 0.5))
    plistIcon:setPosition(ccp(45.75, 38.125))
    plistNum = string.format("x%s", v._amount)
    plistNum = ed.createLabelTTF(plistNum, 20)
    plistNum:setAnchorPoint(ccp(1, 0))
    plistNum:setPosition(ccp(80, 5))
    ed.setLabelStroke(plistNum, ccc3(0, 0, 0), 3)
    plistIcon:addChild(plistNum)
    icon:addChild(plistIcon)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setScale(1.1764705882352942)
    iconlist[k] = {
      icon = icon,
      plistIcon = plistIcon,
      plistNum = plistNum,
      amount = v._amount
    }
    i = k
  end
  return iconlist
end

local function createComposePrize(data)
  local data = data or {}
  local config = {}
  for k, reward in pairs(data) do
    local type = reward._type
    local amount = reward._amount
    local id = reward._id
    local scale = 0.45
    ed.isElementInTable(use_type, {
      T("Open Chest Combination ID"),
      "MonthCard"
    })
    if ed.isElementInTable(type, {
      "rmb",
      "money",
      "iron",
      "wood"
    }) then
      scale = 1
    elseif type == "crystal" then
      scale = 0.8
    end
    amount = 10000 <= amount and string.format("%sW", math.ceil(amount / 10000)) or amount
    local tmp = {
      type = type,
      id = id,
      scale = scale,
      amount = amount
    }
    table.insert(config, tmp)
  end
  local node, data = activityBase.createRewardsIcon(config, "\229\165\150\229\138\177:")
  return node, data
end

local function initLeftContainer(self, info)
  local start_time = info._start_time
  local end_time = info._end_time
  local time = string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(start_time), ed.formatTime(end_time))
  self.ui.time:setString(time)
  self.frameUi.a_title:setString((self.info or {})._title or "")
  self.frameUi.a_title:setShadow(ccc3(0, 0, 0), ccp(0, 2))
  self.ui.content:setString(info._rules or "")
  if not info._desc or info._desc and info._desc == "" then
    self.ui.a_description:setVisible(false)
  end
  self.ui.description:setString(info._desc or "")
end

class.initLeftContainer = initLeftContainer

local function setTitle(ui, title, title_1, title_2)
  ui.title:setString(title)
  ui.title_1:setString(title_1)
  ui.title_1:setPosition(ui.title:getPositionX() + ui.title:getContentSize().width / 2 + ui.title_1:getContentSize().width / 2 + 3, ui.title_1:getPositionY())
  ui.title_2:setString(title_2)
  ui.title_2:setPosition(ui.title_1:getPositionX() + ui.title_1:getContentSize().width / 2 + ui.title_2:getContentSize().width / 2 + 3, ui.title_2:getPositionY())
end

function class:initNormalRewardsList(ui, data)
  local ttype = self.info._type
  local prizeIcon = createPrize(data._rewards)
  for k, v in pairs(prizeIcon) do
    if ui["reward_" .. k] then
      ui["reward_" .. k]:addChild(v.icon)
    end
  end
  if #prizeIcon < 4 then
    for i = #prizeIcon + 1, 4 do
      ui["reward_" .. i]:setVisible(false)
    end
  end
  if "rmb_recharge" == ttype or "first_recharge" == ttype then
    setTitle(ui, "\229\133\133\229\128\188", tostring(data._amount), "\229\133\131")
  elseif "diamond_consume" == ttype or "black_market_consume" == ttype then
    setTitle(ui, "\230\182\136\232\180\185", tostring(data._amount), "\233\146\187")
  elseif "dreamland_draw" == ttype then
    setTitle(ui, "\232\190\190\229\136\176", tostring(data._amount), "\228\188\164\229\174\179")
  elseif "reach_level" == ttype then
    setTitle(ui, "\232\190\190\229\136\176", tostring(data._amount), "\231\186\167")
  elseif "nightmare_special" == ttype then
    setTitle(ui, "\233\128\154\232\191\135", tostring(data._amount), "\230\179\162")
  elseif "rt2v2_rewards" == ttype then
    setTitle(ui, "   \231\187\132\233\152\159\232\131\156\229\136\169", tostring(data._amount), "\230\172\161")
    local isInterDay = ed.checkTwoDateod(data._dailyjob._last_rewards_time)
    if isInterDay then
      data._dailyjob._last_rewards_time = 0
    end
  elseif "apprentice_login" == ttype then
    setTitle(ui, "   \229\190\146\229\188\159\231\173\190\229\136\176", tostring(data._amount), "\229\164\169")
  elseif "local_book_rank" == ttype or "global_book_rank" == ttype then
    local id = ((data._rewards or {})[1] or {})._id
    local name = ""
    if id then
      name = ed.lookupDataTable("Medal", "Name", tonumber(id))
    end
    setTitle(ui, name, "", "")
    ui.title:setAnchorPoint(ccp(0.2, 0.5))
  elseif "chess_game_play" == ttype then
    setTitle(ui, "\229\174\140\230\136\144", tostring(data._amount), "\230\172\161")
    for i = 1, 4 do
      if ui["reward_" .. i] then
        ui["reward_" .. i]:setPositionX(ui["reward_" .. i]:getPositionX())
      end
    end
  elseif "share_replay" == ttype or "hire_hero" == ttype then
    setTitle(ui, "", "", "")
    for i = 1, 4 do
      ui["reward_" .. i]:setPositionX(ui["reward_" .. i]:getPositionX() - 100)
    end
  end
  if data._dailyjob._last_rewards_time ~= 0 then
    ui.progress:setString(T("\229\183\178\233\162\134\229\165\150"))
    ui.reward_bg_finish:setVisible(true)
  elseif data._amount and (data._dailyjob._task_target or 0) >= data._amount and self.state.begain then
    ui.reward_bg_press:setVisible(true)
    ui.getReward:setVisible(true)
    ui.progress:setVisible(false)
  else
    ui.progress:setString(T("(%s/%s)", data._dailyjob._task_target or 0, data._amount or 0))
  end
  if not class.isShowRewards(self) then
    ui.reward_bg:setVisible(false)
  end
end

function class:resetComposeRewardsList(ui, data)
  local composeInfo = data._extra_reward_info._compose_info or {}
  local itemId = composeInfo._item_id
  local itemName = ed.getDataTable("equip"):getEquipNameWithId(itemId)
  ui.title_2:setString(itemName)
  local pro = string.format("(%s/%s)", ed.player:getEquipAmount(itemId), data._amount or 0)
  ui.title_progress:setString(pro)
  ed.right2(ui.title_progress, ui.title_2, 5)
  if data._dailyjob._last_rewards_time ~= 0 then
    ui.reward_bg_finish:setVisible(true)
    ui.acFinish:setVisible(true)
    ui.getReward:setVisible(false)
    ui.reward_bg_press:setVisible(false)
    ui.redtag:setVisible(false)
    ui.title_progress:setVisible(false)
  elseif self.state.begain then
    if data._amount and self.finishCompose(itemId, data) then
      ui.reward_bg_press:setVisible(true)
      ui.getReward:setVisible(true)
    elseif ed.isEquipCraftable(itemId) and not self.state.ends then
      ui.redtag:setVisible(true)
    end
  end
end

function class:resetNormalUI(ui, data)
  if data._dailyjob._last_rewards_time ~= 0 then
    ui.progress:setString(T("\229\183\178\233\162\134\229\165\150"))
    ui.reward_bg_finish:setVisible(true)
    ui.reward_bg_press:setVisible(false)
    ui.getReward:setVisible(false)
    ui.progress:setVisible(true)
  end
end

function class:createHeroIcon(id)
  local hero = ed.createSprite(string.format("UI/portrait/dialogue_portrait_%s.png", id))
  local height = hero:getContentSize().height
  hero:setScale(90 / height)
  hero:setPosition(ccp(5, 5))
  return hero
end

function class:createItemIcon(id)
  local equip = ed.readequip.createIcon(id, 80)
  equip:setPosition(ccp(5, 5))
  return equip
end

function class:initComposeRewardsList(ui, data)
  local composeInfo = data._extra_reward_info._compose_info or {}
  local id = composeInfo._hero_id
  local type = ed.itemType(id)
  if type == "hero" then
    ui.icon:addChild(self:createHeroIcon(id))
  elseif type == "equip" then
    ui.icon:addChild(self:createItemIcon(id))
  end
  local label, rewards = createComposePrize(data._rewards)
  ui.rewards_data = rewards
  label:setPosition(ccp(90, 30))
  ui.reward_bg:addChild(label, 0)
  self:resetComposeRewardsList(ui, data)
end

local function initRewardsList(self, ui, data, panelType)
  if "ComposeActivityList" == panelType then
    self:initComposeRewardsList(ui, data)
  elseif "NoButtonActivityList" == panelType then
    self:initNoButtonRewardsList(ui, data)
  elseif "NoButtonActivityList_big" == panelType then
    self:initNoButtonRewardsListBig(ui, data)
  else
    self:initNormalRewardsList(ui, data)
  end
end

class.initRewardsList = initRewardsList

local function initUI(self)
  if self:showEnter_button() then
    if not self.state.begain then
      self.frameUi.enter_button:setVisible(false)
      self.frameUi.enter_label:setVisible(false)
    end
  else
    self.frameUi.enter_button:setVisible(false)
    self.frameUi.enter_label:setVisible(false)
  end
  setTextContent(self.ui.content)
  setTextContent(self.ui.description)
  local height = self.ui.content:getContentSize().height * self.ui.content:getScaleY() - 35
  local dheight = self.ui.description:getContentSize().height
  if self.rewardsNum == 0 or not class.isShowRewards(self) then
    self.ui.a_description:setPosition(self.ui.a_description:getPositionX(), self.ui.a_description:getPositionY() + 100 - height)
    self.ui.description:setPosition(self.ui.description:getPositionX(), self.ui.description:getPositionY() + 100 - height)
    height = height - 65
  else
    self.ui.a_rewards:setPosition(self.ui.a_rewards:getPositionX(), self.ui.a_rewards:getPositionY() - height)
    if self:needShowTags() then
      self.ui.tags:setPosition(self.ui.tags:getPositionX(), self.ui.tags:getPositionY() - height)
      height = height - 15
    end
    self.ui.rewards_layer:setPosition(self.ui.rewards_layer:getPositionX(), self.ui.rewards_layer:getPositionY() - height)
    self.ui.a_description:setPosition(self.ui.a_description:getPositionX(), self.ui.a_description:getPositionY() - height - 30 - self.dt * (self.rewardsNum - 1))
    self.ui.description:setPosition(self.ui.description:getPositionX(), self.ui.description:getPositionY() - height - 30 - self.dt * (self.rewardsNum - 1))
  end
  height = initDraglistHeight + height + dheight + self.dt * (self.rewardsNum - 1) + self.bannerHeight
  if self.info._extra_info._is_open_svr == 1 then
    self.draglist:initListHeight(height - 50)
  else
    self.draglist:initListHeight(height)
  end
end

class.initUI = initUI

function class:isShowRewards()
  if self.info._type == "vitality_rewards" or self.info._type == "purple_combo_v2" or self.info._type == "super_exchange" then
    return false
  end
  return true
end

function class:initRewardList(panelType)
  local uiname = ed.uieditor[panelType]
  if not uiname then
    return
  end
  for k, v in ipairs(self.info._rewards or {}) do
    local list, ui = ed.editorui(uiname)
    list:setPosition(list:getPositionX(), -(k - 1) * self.dt)
    self.ui.rewards_layer:addChild(list)
    self:initRewardsList(ui, v or {}, panelType)
    self["rewardsList" .. k], self["rewardsui" .. k] = list, ui
  end
end

function class:resetPanelInfo(panelType)
  self:initRewardList(panelType)
end

function class:resetRedBagButton(ui, data)
  local extra_reward_info = data._extra_reward_info or {}
  if extra_reward_info._red_envelope._recharge_flag ~= 0 then
    ui.record:setVisible(true)
    ui.record_label:setVisible(true)
    if extra_reward_info._red_envelope._red_draw == extra_reward_info._red_envelope._red_total then
      ui.record:setPosition(ui.join_act:getPositionX(), ui.join_act:getPositionY())
      ui.record_label:setPosition(ui.join_label:getPositionX(), ui.join_label:getPositionY())
      ui.record_press:setPosition(ui.join_act:getPositionX(), ui.join_act:getPositionY())
    else
      ui.send:setVisible(true)
      ui.send_label:setVisible(true)
    end
    ui.join_act:setVisible(false)
    ui.join_label:setVisible(false)
  end
  if not self.state.begain then
    ui.join_act:setVisible(false)
    ui.join_act_unclick:setVisible(true)
  end
end

function class:createLightRedBag(ui, data, list)
  local light = ed.createSprite("UI/alpha/HVGA/tavern_get_item_bg_light_orange.png")
  light:setPosition(ccp(40, 55))
  light:setScale(0.8)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
  local bag = ed.createSprite("UI/alpha/HVGA/activity/active_red_package.png")
  bag:setPosition(ccp(40, 55))
  ui.reward_bg:addChild(light)
  ui.reward_bg:addChild(bag)
end

function class:initRedBagListDescription(ui, data, list)
  local str = ""
  local lable = richText:new()
  local extra_reward_info = data._extra_reward_info or {}
  if extra_reward_info._red_envelope._recharge_flag == 0 then
    str = T("<text|normal_button|\229\141\149\231\172\148\229\133\133\229\128\188><text|red_bag_act_red|%s><text|normal_button|\229\133\131\233\162\157\229\164\150\232\181\160\233\128\129%s\228\184\170\231\186\162\229\140\133\230\128\187\229\133\177><text|red_bag_act_red|%s><sprite|UI/alpha/1080P/common/rmbicon.png|0.6>", data._amount, extra_reward_info._red_envelope._red_total, extra_reward_info._red_envelope._red_amount)
    lable:setString(str)
    lable:setPosition(ccp(45, 80))
  else
    str = T("<text|red_bag_act_red|%s><sprite|UI/alpha/1080P/common/rmbicon.png|0.6><text|normal_button|\229\183\178\233\154\143\230\156\186\229\136\134\229\133\165><text|red_bag_act_red|%s><text|normal_button|\228\184\170\231\186\162\229\140\133>", extra_reward_info._red_envelope._red_amount, extra_reward_info._red_envelope._red_total)
    if extra_reward_info._red_envelope._red_draw == extra_reward_info._red_envelope._red_amount then
      str = str .. "\239\188\136\229\133\168\233\131\168\233\162\134\229\174\140\239\188\137"
    else
      str = str .. T("<text|normal_button|\239\188\136%s\228\186\186\233\162\134\229\143\150\239\188\137>", extra_reward_info._red_envelope._red_draw)
    end
    lable:setString(str)
    lable:setPosition(ccp(75, 80))
    self:createLightRedBag(ui, data, list)
  end
  ui.reward_bg:addChild(lable.rootNode)
end

function class:initRedBagList(ui, data, list)
  self:initRedBagListDescription(ui, data, list)
  self:resetRedBagButton(ui, data)
end

function class:resetRedBagInfo()
  for k, v in pairs(self.info._rewards or {}) do
    self["rewardsList" .. k], self["rewardsui" .. k] = ed.editorui(ed.uieditor.ActivityRedBagList)
    local list, ui = self["rewardsList" .. k], self["rewardsui" .. k]
    list:setPosition(list:getPositionX(), -(k - 1) * self.dt - 30)
    self.ui.rewards_layer:addChild(list)
    self:initRedBagList(ui, v or {}, list)
  end
end

local function resetInfo(self)
  self.dt = self:getActivityTypePanelDt()
  initLeftContainer(self, self.info)
  self:resetInfoPosition()
  self:resetInfoVisible()
  local panelType = self:getActivityTypePanel()
  if "ActivityRedBagList" == panelType then
    self:resetRedBagInfo()
  else
    self:resetPanelInfo(panelType)
  end
  self:initUI()
end

class.resetInfo = resetInfo

function class:resetInfoPosition()
  local notShowTime = self.info._extra_info._is_open_svr == 1
  if notShowTime then
    self.ui.a_time:setVisible(false)
    self.ui.time:setVisible(false)
    self.ui.a_description:setVisible(false)
    self.ui.description:setVisible(false)
    local x, y = self.ui.a_content:getPosition()
    self.ui.a_content:setPosition(ccp(x, y + 50))
    x, y = self.ui.content:getPosition()
    self.ui.content:setPosition(ccp(x, y + 50))
    x, y = self.ui.a_description:getPosition()
    self.ui.a_description:setPosition(ccp(x, y + 50))
    x, y = self.ui.description:getPosition()
    self.ui.description:setPosition(ccp(x, y + 50))
    x, y = self.ui.a_rewards:getPosition()
    self.ui.a_rewards:setPosition(ccp(x, y + 50))
    if self:needShowTags() then
      x, y = self.ui.tags:getPosition()
      self.ui.tags:setPosition(ccp(x, y + 50))
    end
    x, y = self.ui.rewards_layer:getPosition()
    self.ui.rewards_layer:setPosition(ccp(x, y + 50))
  end
end

function class:resetInfoVisible()
  self.ui.tags:setVisible(self:needShowTags())
  self.rewardsNum = #(self.info._rewards or {})
  if self.info._type == "super_exchange" then
    self.rewardsNum = 0
  end
  if self.rewardsNum == 0 or not class.isShowRewards(self) then
    self.ui.a_rewards:setVisible(false)
    self.ui.tags:setVisible(false)
    self.ui.rewards_layer:setVisible(false)
  end
end

local function initActivityState(self)
  self.state = {
    begain = false,
    ends = false,
    overGetTime = false
  }
  local currentTime = ed.getServerTime()
  if currentTime > self.info._start_time then
    self.state.begain = true
  end
  if currentTime > self.info._end_time then
    self.state.ends = true
  end
  if currentTime - self.info._end_time > 86400 then
    self.state.overGetTime = true
  end
end

class.initActivityState = initActivityState

local function init(self, info)
  activityType = ""
  self.info = info or self.info
  activityType = self.info._type
  local defaultY = -95
  if self:hasBanner() then
    defaultY = defaultY - self.bannerHeight - 16
  end
  self.leftContainer, self.ui = ed.editorui(ed.uieditor.Activity)
  self.draglist:addItem(self.leftContainer, ccp(4, defaultY))
  self:initActivityState()
  self:resetInfo()
end

class.init = init

function class:createDraglist()
  local banner = 0
  local touchPriority = -150
  if self.info._type == "red_envelope" then
    touchPriority = -900
  end
  local draglistInfo = {
    cliprect = CCRectMake(17, 65, 417, 295),
    rect = CCRectMake(20, 65, 410, 295),
    container = self.frameUi.a_frame,
    priority = touchPriority,
    noshade = true,
    swallow = false,
    bar = {
      bglen = 200,
      bgpos = ccp(15, 200)
    },
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(draglistInfo)
  self.draglist:initListHeight(initDraglistHeight)
end

function class:getActivityTypePanel()
  local ttype = self.info._type or ""
  return activityTypePanel[ttype] or "ActivityList"
end

function class:getActivityTypePanelDt()
  local panel = self:getActivityTypePanel()
  return activityTypePanelDt[panel] or 75
end

function class:initNoButtonRewardsList(ui, data)
  local ttype = self.info._type
  local prizeIcon = createPrize(data._rewards)
  for k, v in pairs(prizeIcon) do
    if ui["reward_" .. k] then
      v.plistIcon:setPosition(ccp(0, 0))
      v.plistIcon:setScale(0.5)
      v.plistNum:setVisible(false)
      ui["reward_" .. k]:addChild(v.icon)
      ed.setString(ui["title_" .. k], tostring(data._amount))
      ed.setString(ui.progress, "X" .. (v.amount or 0))
    end
  end
end

local iconList = {
  money = "UI/alpha/1080P/common/goldicon_small.png",
  crystal = "UI/alpha/HVGA/warschool/resource_crystal.png",
  item = "UI/alpha/HVGA/awake/awake_coupon.png"
}

function class:initNoButtonRewardsListBig(ui, data)
  local ttype = self.info._type
  if ttype == "arena_foothold" then
    self:initArenaFootHold(ui, data)
  end
end

local maxReward = 5

function class:initArenaFootHold(ui, data)
  for k = 1, maxReward do
    ui["reward_" .. k]:setVisible(false)
    ui["reward_label_" .. k]:setVisible(false)
  end
  local idx = 1
  for k, reward in ipairs(data._rewards) do
    local iconPath = iconList[reward._type]
    if reward._type == "guild_liveness" then
      ui.reward_4:setVisible(true)
      ui.reward_label_4:setVisible(true)
      ed.setString(ui.reward_label_4, reward._amount)
    elseif reward._type == "unlock_guild_avatar_frame" then
      ui.reward_5:setVisible(true)
      ui.reward_label_5:setVisible(true)
    elseif iconPath then
      local icon = CCSprite:create(iconPath)
      ui["reward_" .. idx]:setVisible(true)
      ui["reward_label_" .. idx]:setVisible(true)
      ed.setTexture(ui["reward_" .. idx], iconPath)
      ed.setString(ui["reward_label_" .. idx], reward._amount)
      idx = idx + 1
    end
  end
  ed.setString(ui.title, T("\229\141\160\233\162\134\230\141\174\231\130\185\230\149\176\228\184\186%d: ", data._amount))
  ed.setString(self.ui.tags, activityTagsContent[self.info._type] or "")
end

function class:needShowTags()
  local content = activityTagsContent[self.info._type]
  return content ~= nil
end

local function create(self, info)
  self.info = info
  self.container, self.frameUi = ed.editorui(ed.uieditor.ActivityFrame)
  self.container:registerScriptTouchHandler(self:doMainLayerTouch(), false, -100, false)
  self.container:setTouchEnabled(true)
  self:createDraglist()
  self:createBanner()
  init(self, info)
  return self
end

class.create = create

function class:hasBanner()
  return self.info._banner and self.info._banner ~= 0 and self.info._type ~= "super_exchange"
end

function class:createBanner()
  self.bannerHeight = 0
  if not self:hasBanner() then
    return
  end
  local banner = self.info._banner
  local res = ed.getDataTable("ActListBanner")[banner].Picture
  local banner = ed.createSprite(res)
  self.bannerHeight = banner:getContentSize().height
  banner:setAnchorPoint(ccp(0, 1))
  banner:setPosition(ccp(20, 360))
  self.bannerNode = banner
  self.draglist:addItem(banner)
end

local function dispatch(reply)
  if "1" == ed.netreply.tenPumping then
    FireEvent("getPrize", reply)
    ed.netreply.tenPumping = nil
  elseif "onTime" == ed.netreply.tenPumping then
    FireEvent("getOnTime", reply)
    ed.netreply.tenPumping = nil
  end
  if ed.netreply.awakeActivity then
    FireEvent("awakeActivity", reply)
    ed.netreply.awakeActivity = nil
  end
  if ed.netreply.saleActivity then
    FireEvent("saleActivity", reply)
    ed.netreply.saleActivity = nil
  end
  if ed.netreply.loginActivity then
    FireEvent("loginActivity", reply)
    ed.netreply.loginActivity = nil
  end
  FireEvent("requestRewardReply", reply)
end

ListenEvent("getPrize", doClickPrizeReply)
ListenEvent("job_rewards_reply", dispatch)
