local rebateActivities = {}
local rebatepanel
local rolepanelLogic = {}
local rolepanel
ed.ui.rebateActivities = rebateActivities
local ipairs = ipairs
local activitieData, title, pTime, roles, hasDone, desc, rewards
local params = {}
local getIndex, getInfo, endTime, showPanel

local function release()
  title = nil
  pTime = nil
  roles = nil
  hasDone = nil
  desc = nil
  rewards = nil
  getIndex = nil
  getInfo = nil
  endTime = nil
end

local function initPrizeData(data)
  local tt = data or {}
  local row = tt._rewards
  local t = {
    id = tt._id,
    type = tt._type,
    startTime = tt._start_time,
    endTime = tt._end_time,
    title = tt._title,
    desc = tt._desc,
    rules = tt._rules
  }
  t.rewards = tt._rewards
  return t
end

local function createPrize(listdata)
  local iconlist = {}
  local list = listdata or {}
  local i = 0
  for k, v in ipairs(list) do
    local icon = CCSprite:create()
    local plistIcon, plistName, plistNum, plistIcon2
    if v._type == "item" then
      plistIcon = ed.readequip.createIcon(v._id)
      plistName = ed.getDataTable("equip")[v._id].Name
    elseif v._type == "hero" then
      plistIcon = ed.readequip.createIcon(v._id)
      plistName = ed.getDataTable("Unit")[v._id]["Display Name"]
    elseif v._type == "rmb" then
      plistIcon = CCSprite:create("UI/alpha/1080P/icon/diamond_icon.png")
      plistName = T("\233\146\187\231\159\179")
    elseif v._type == "money" then
      plistIcon = CCSprite:create("UI/alpha/1080P/icon/gold_icon.png")
      plistName = T("\233\135\145\229\184\129")
    elseif v._type == "rand_soul" then
      plistIcon1, fragmentIcon = ed.readequip.getUnknownHeroStone()
      plistIcon1:setAnchorPoint(ccp(0, 0))
      plistIcon1:setPosition(ccp(0, 0))
      plistIcon = ed.createScale9Sprite("UI/alpha/HVGA/fragment_frame_blue.png")
      plistIcon:setAnchorPoint(ccp(0, 0))
      plistIcon:setPosition(ccp(0, 0))
      plistIcon:addChild(plistIcon1)
      plistName = T("\233\154\143\230\156\186\231\129\181\233\173\130\231\159\179")
    end
    plistIcon:setAnchorPoint(ccp(0.5, 1))
    plistIcon:setScale(0.8)
    plistIcon:setPosition(ccp(40, 80))
    plistNum = string.format("x%s", v._amount)
    plistNum = ed.createLabelTTF(plistNum, 20)
    plistNum:setAnchorPoint(ccp(1, 0))
    plistNum:setPosition(ccp(80, 5))
    ed.setLabelStroke(plistNum, ccc3(0, 0, 0), 3)
    plistIcon:addChild(plistNum)
    if ed.isComplexText(plistName) then
      plistName = ed.createComplexLabel({
        text = plistName,
        size = 18,
        shadow = {
          color = ccc3(131, 45, 0)
        }
      }).node
    else
      plistName = ed.createLabelWithFontInfo(plistName, "op_act_item_name")
    end
    plistName:setAnchorPoint(ccp(0.5, 1))
    plistName:setPosition(ccp(40, 17))
    icon:addChild(plistIcon)
    icon:addChild(plistName)
    iconlist[k] = icon
    i = k
  end
  while i < 3 do
    local icon = CCSprite:create()
    iconlist["i+1"] = icon
    i = i + 1
  end
  i = nil
  return iconlist
end

local function createTitleLabel(text1, amount, text2, info1, info2)
  local icon1, icon2, icon3
  icon1 = ed.createLabelWithFontInfo(text1, info1)
  icon1:setAnchorPoint(ccp(1, 0))
  icon2 = ed.createLabelWithFontInfo(amount, info2)
  icon2:setAnchorPoint(ccp(1, 0))
  if ed.createLabelWithFontInfo(text2, info1) then
    icon3 = ed.createLabelWithFontInfo(text2, info1)
  else
    icon3 = ed.createSprite(text2)
  end
  icon3:setAnchorPoint(ccp(1, 1))
  icon3:addChild(icon2)
  icon2:addChild(icon1)
  return icon3
end

local function createTitleSprite(text1, amount, text2, info1, info2)
  local icon1, icon2, icon3
  icon1 = ed.createLabelWithFontInfo(text1, info1)
  icon1:setAnchorPoint(ccp(1, 0))
  icon2 = ed.createLabelWithFontInfo(amount, info2)
  icon2:setAnchorPoint(ccp(1, 0))
  icon2:setPosition(ccp(0, 5))
  icon3 = ed.createSprite(text2)
  icon3:setAnchorPoint(ccp(1, 1))
  icon3:addChild(icon2)
  icon2:addChild(icon1)
  return icon3
end

local function createPrizeIndex(info)
  local amount = info._amount
  local prizeTarget = info._dailyjob._task_target
  local rewards = info._rewards
  local isAllow = (amount or 1) <= (prizeTarget or 0)
  local bgRes, getRes, getConditions, bgResMark
  if "rmb_recharge" == activitieData._type then
    getConditions = createTitleLabel(T("\231\180\175\232\174\161\229\133\133\229\128\188"), info._amount, T("\229\133\131"), "op_act_grey", "op_act_dark_blue")
  elseif "diamond_consume" == activitieData._type then
    getConditions = createTitleLabel(T("\231\180\175\232\174\161\230\182\136\232\180\185"), info._amount, T("\233\146\187"), "op_act_grey", "op_act_dark_blue")
  else
    return
  end
  if isAllow then
    bgRes = "UI/alpha/HVGA/activity/activity_list_bg_2.png"
    getRes = ed.createSprite("UI/alpha/HVGA/task_get_reward_button.png")
    getRes:setPosition(ccp(50, 18))
  else
    bgRes = "UI/alpha/HVGA/activity/activity_list_bg_1.png"
  end
  local prizeIcon = createPrize(rewards)
  rebatepanel.prizeListView:setAutoClipItemsEnabled(false)
  local itemData
  if 0 == info._dailyjob._last_rewards_time then
    itemData = rebatepanel.prizeListView:addItem({
      bgRes,
      getConditions,
      prizeIcon[1],
      prizeIcon[2],
      prizeIcon[3],
      bgResMark,
      getRes
    }, {data = info, isAllow = isAllow})
  else
    bgRes = "UI/alpha/HVGA/activity/activity_list_bg_1.png"
    bgResMark = "UI/alpha/HVGA/activity/activity_list_mask_received.png"
    getRes = ed.createSprite("UI/alpha/HVGA/dailylogin/dailylogin_checked_green.png")
    getRes:setPosition(ccp(45, 35))
    itemData = rebatepanel.prizeListView:addItem({
      bgRes,
      getConditions,
      prizeIcon[1],
      prizeIcon[2],
      prizeIcon[3],
      bgResMark,
      getRes
    }, {data = info, isAllow = isAllow})
  end
  for i = 1, 3 do
    if prizeIcon[i] == nil and itemData.controllers["icon" .. i] then
      itemData.controllers["icon" .. i]:setVisible(false)
    end
  end
end

local function createPrizeList(list)
  list = list or {}
  for k, v in ipairs(list) do
    createPrizeIndex(v)
  end
end

local function createWindow()
  ed.setLabelString(rebatepanel.title, title)
  ed.setLabelString(rebatepanel.ptime, pTime)
  ed.setLabelString(rebatepanel.pdesc, desc)
  local hasDone1
  if not hasDone then
    hasDone = 0
  end
  if "rmb_recharge" == activitieData._type then
    hasDone1 = createTitleLabel(T("\229\183\178\231\180\175\232\174\161\229\133\133\229\128\188"), hasDone, T("\229\133\131"), "op_act_white", "op_act_light_blue")
  else
    hasDone1 = createTitleSprite(T("\229\183\178\231\180\175\232\174\161\230\182\136\232\180\185"), hasDone, "UI/alpha/HVGA/task_rmb_icon_2.png", "op_act_white", "op_act_light_blue")
    rebatepanel.goto:setVisible(false)
  end
  rebatepanel.hasdone:addChild(hasDone1)
end

local function init(list)
  local prize = initPrizeData(list)
  title = prize.title
  pTime = string.format("%s-%s" .. ed.getUTCLabel(), ed.formatTime(prize.startTime), ed.formatTime(prize.endTime))
  desc = prize.desc
  roles = prize.rules
  endTime = prize.endTime
  hasDone = prize.rewards[1]._dailyjob._task_target
  if string.len(desc) > 130 then
    desc = string.sub(desc, 1, 184)
  end
  rewards = prize.rewards
  createPrizeList(rewards)
  createWindow()
end

function rebateActivities.showRoles()
  if nil == rolepanel then
    rolepanel = panelMeta:new2(rolepanelLogic, EDTables.rebateActivitiesConfig.rolUIRes)
  end
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene then
    currentScene:addChild(rolepanel:getRootLayer(), 700)
  end
  if roles then
    rolepanel.roleListView:addItem({roles}, {})
  end
end

local function doTaskConsume(info, index)
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
    end
  end
  getInfo._dailyjob._last_rewards_time = string.format("%s", os.time())
  local data = {
    "UI/alpha/HVGA/activity/activity_list_bg_2.png"
  }
  local extraData = {}
  local newInfo = {data = data, extraData = extraData}
  rebatepanel.prizeListView:removeItem(index)
  createPrizeIndex(getInfo)
end

local function completeTask(info, index)
  getInfo = info
  getIndex = index
  local msg = ed.upmsg.job_rewards()
  msg._job = info._dailyjob._id
  ed.netreply.tenPumping = "1"
  ed.send(msg, "job_rewards")
end

local function overTime(endtime)
  local currentTime = ed.getServerTime()
  if endtime > currentTime then
    return true
  end
  if 0 < currentTime - endTime then
    return false
  else
    return true
  end
end

local function overGetTime(endtime)
  local currentTime = ed.getServerTime()
  if endtime > currentTime then
    return true
  end
  if 86400 < currentTime - endTime then
    return false
  else
    return true
  end
end

local function setPostion(icon)
  local anchor = icon:getAnchorPoint()
  local size = icon:getContentSize()
  local scaleX = icon:getScaleX()
  local scaleY = icon:getScaleY()
  local w = size.width * scaleX
  local h = size.height * scaleY
  local pos = icon:getParent():convertToWorldSpace(ccp(icon:getPosition()))
  local posX = pos.x
  local posY = pos.y
  local x = posX
  local y = posY + (0.5 - anchor.y) * h
  return x, y
end

function rebateActivities.onListClick(itemData, x, y)
  if nil == itemData then
    return
  end
  if nil == itemData.extraData then
    return
  end
  local info = itemData.extraData
  if not overGetTime(endTime) then
    ed.showToast(T("\230\130\168\229\183\178\231\187\143\232\191\135\228\186\134\233\162\134\229\165\150\230\151\182\233\151\180"))
    return
  end
  if 0 == info.data._dailyjob._last_rewards_time then
    if info.isAllow then
      local index = rebatepanel.prizeListView:getClickIndex(x, y)
      completeTask(info.data, index)
      return
    end
    return
  end
  ed.showToast(T("\230\130\168\229\183\178\231\187\143\233\162\134\232\191\135\229\165\150\228\186\134"))
  return
end

local function suspensionLayer(itemData, i)
  local icon = itemData.controllers["icon" .. i]
  if nil == itemData then
    return
  end
  if nil == itemData.extraData then
    return
  end
  local info = itemData.extraData.data
  if showPanel then
    rebatepanel.frame1:removeChild(showPanel, true)
    showPanel = nil
  end
  if nil == showPanel then
    local pinfo = info._rewards[i]
    if not pinfo then
      return
    end
    if "rmb" == pinfo._type then
      showPanel = ed.readequip.getDetailCard("Diamond")
    elseif "money" == pinfo._type then
      showPanel = ed.readequip.getDetailCard("Gold")
    elseif "rand_soul" == pinfo._type then
      showPanel = ed.readequip.getDetailCard("rand_soul")
    else
      showPanel = ed.readequip.getDetailCard(pinfo._id)
    end
    local x, y = setPostion(icon)
    local pos = ccp(x, y)
    showPanel:setPosition(pos)
    showPanel:setScale(1)
  end
  rebatepanel.frame1:addChild(showPanel)
end

function rebateActivities.listDownClick(itemData, x, y)
  if ed.containsPoint(itemData.controllers.icon1, x, y) then
    suspensionLayer(itemData, 1)
    return
  end
  if ed.containsPoint(itemData.controllers.icon2, x, y) then
    suspensionLayer(itemData, 2)
    return
  end
  if ed.containsPoint(itemData.controllers.icon3, x, y) then
    suspensionLayer(itemData, 3)
    return
  end
end

function rebateActivities.listUpClick(itemData, x, y)
  if rebatepanel and showPanel then
    rebatepanel.frame1:removeChild(showPanel, true)
    showPanel = nil
    return
  end
  if ed.containsPoint(itemData.controllers.frame4, x, y) then
    rebateActivities.onListClick(itemData, x, y)
    return
  end
end

function rebateActivities.listMoveClick()
  if rebatepanel and showPanel then
    rebatepanel.frame1:removeChild(showPanel, true)
    showPanel = nil
    return
  end
end

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

function rebateActivities.create(info)
  if nil == info then
    return
  end
  if nil == rebatepanel then
    rebatepanel = panelMeta:new2(rebateActivities, EDTables.rebateActivitiesConfig.UIRes)
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:addChild(rebatepanel:getRootLayer(), 500)
  end
  activitieData = info
  init(info)
end

function rebateActivities.addRecharge()
  if not overTime(endTime) then
    ed.showToast(T("\230\173\164\230\180\187\229\138\168\229\183\178\231\187\143\232\191\135\230\156\159\230\151\160\230\179\149\229\143\130\229\138\160"))
    return
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(rebatepanel:getRootLayer(), true)
    rebatepanel = nil
    currentScene:removeChild(ed.ui.activitiesPanel:getRootLayer(), true)
    ed.ui.activitiesPanel = nil
    local rechargeMgr = ed.RechargeNewMgr.getInstance()
    if true == rechargeMgr:isUseNewRechargeMedule() then
      ed.pushScene(ed.ui.recharge.create({page = "Gift"}))
    else
      local rechargeLayer = ed.ui.recharge.create()
      currentScene:addChild(rechargeLayer.mainLayer, 200)
    end
  end
end

function rebateActivities.exit()
  if nil == rebatepanel then
    return
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(rebatepanel:getRootLayer(), true)
    rebatepanel = nil
  end
  release()
end

function rolepanelLogic.roleExit()
  if nil == rolepanel then
    return
  end
  local currentScene = getRunScene()
  if currentScene then
    currentScene:removeChild(rolepanel:getRootLayer(), true)
    rolepanel = nil
  end
end
