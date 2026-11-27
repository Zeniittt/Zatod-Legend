local serverlist = {}
ed.serverlist = serverlist
local serverlistPanel
local up = pb_loader("acc_up")()
local down = pb_loader("acc_down")()
local upmsg = up.acc_up_msg
local downmsg = down.acc_down_msg
local connection
local bSendblock = false
local currentMsg, currentMsgType
local connect_succ = false
local cryptkey = "182173557"
local up_code
local serverListData = {}
local serverListRecommend = {}
local accServerListData = {}
local recallListData = {}
local lastServerInfo = {}
local currentServerName = ""
local bSDKLoginSucess = false
local colNum = 10
local sessionId = ""
local user_id = ""
local stateColor = {
  [T("\231\187\180\230\138\164")] = ccc3(183, 183, 183),
  [T("\231\136\134\230\187\161")] = ccc3(255, 81, 20),
  [T("\231\185\129\229\191\153")] = ccc3(255, 225, 20),
  [T("\230\142\168\232\141\144")] = ccc3(20, 255, 59),
  [T("\230\150\176\229\140\186")] = ccc3(238, 204, 119)
}

local function release()
  serverListData = {}
  lastServerInfo = {}
  currentServerName = ""
  bSDKLoginSucess = false
  sessionId = ""
  user_id = ""
  serverlistPanel = nil
  accServerListData = {}
end

local function getServerInfoByName(name)
  if sdkLogin.isNewLoginMode() then
    return serverListData[1]
  end
  for k, v in ipairs(serverListData) do
    if v.name == name then
      return v
    end
  end
  return serverListData[1]
end

local function getLastServerInfo()
  local info = ed.storage.getString(tostring(EDSDKType) .. "lastserverinfo")
  local lastServerName = string.match(info, "name:([^,]*)")
  if lastServerName == "" then
    lastServerName = serverListData[1].name
  end
  lastServerInfo = getServerInfoByName(lastServerName)
end

local function getGroupNum(data, num)
  if 0 == num then
    return
  end
  return math.ceil(data / num)
end

local function setItemData(n, k, dataLen)
  local minNum = k * n - (n - 1)
  local maxNum = k * n
  if dataLen < maxNum then
    maxNum = dataLen
  end
  return minNum, maxNum
end

local function setZeroForNum(num)
  local sNum = tostring(num)
  if #sNum < 3 then
    for k = 3 - #sNum, 1, -1 do
      sNum = "0" .. sNum
    end
  end
  return sNum
end

local function initListView(serverData, accServerList)
  local groupNum = getGroupNum(#serverData, colNum)
  if accServerList and not sdkLogin.isNewLoginMode() then
    serverlistPanel.ListView:changeItemConfig()
    serverlistPanel.ListView:addItem({"\230\142\168\232\141\144"}, {"recommend"})
    serverlistPanel.lastlogin:setString("\228\184\138\230\172\161\231\153\187\229\189\149\230\156\141\229\138\161\229\153\168")
  end
  if 0 < #recallListData then
    serverlistPanel.ListView:changeItemConfig()
    serverlistPanel.ListView:addItem({"\229\143\172\229\155\158\230\156\141"}, {"recall"})
    serverlistPanel.lastlogin:setString("\228\184\138\230\172\161\231\153\187\229\189\149\230\156\141\229\138\161\229\153\168")
  end
  for k = groupNum, 1, -1 do
    local minNum, maxNum = setItemData(colNum, k, #serverData)
    local string = setZeroForNum(minNum) .. "--" .. setZeroForNum(maxNum) .. T("\229\140\186")
    serverlistPanel.ListView:changeItemConfig()
    serverlistPanel.ListView:addItem({string}, {minNum, maxNum})
  end
end

local function setNodeColor(node1, node2, color)
  if node1 then
    node1:setColor(color)
  end
  if node2 then
    node2:setColor(color)
  end
end

local function createServerItem(minNum, maxNum)
  ed.setString(serverlistPanel.servernum, T("\230\156\141\229\138\161\229\153\168 ") .. minNum .. "-" .. maxNum)
  serverlistPanel.recommend:setVisible(false)
  serverlistPanel.serverInfo:setVisible(true)
  serverlistPanel.serverInfo:clear()
  serverlistPanel.serverInfo:changeItemConfig()
  for k = minNum, maxNum do
    local index = #serverListData + 1 - k
    if serverListData[index] then
      local itemData = serverlistPanel.serverInfo:addItem({
        serverListData[index].name,
        serverListData[index].state
      }, {
        serverListData[index],
        k
      })
      if serverListData[index].color then
        setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, serverListData[index].color)
      end
      if stateColor[serverListData[index].state] then
        setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, serverListData[index].color or stateColor[serverListData[index].state])
      end
      if itemData.extraData[2] == maxNum or itemData.extraData[2] == maxNum - 1 then
        itemData.controllers.lineinfo:setVisible(false)
      end
    end
  end
end

local function sortAccData(data)
  table.sort(data, function(a, b)
    if a.level > b.level then
      return true
    elseif a.level == b.level and a.vip > b.vip then
      return true
    end
  end)
end

local function createRecallServer(listData)
  ed.setString(serverlistPanel.servernum, T("\229\143\172\229\155\158\230\156\141\229\138\161\229\153\168"))
  serverlistPanel.recommend:setVisible(false)
  serverlistPanel.serverInfo:setVisible(true)
  serverlistPanel.serverInfo:clear()
  serverlistPanel.serverInfo:changeItemConfig()
  for index = 1, #listData do
    local data = listData[index]
    if data then
      local itemData = serverlistPanel.serverInfo:addItem({
        data.name,
        data.state
      }, {data, index})
      if data.color then
        setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, serverListData[index].color)
      end
      if stateColor[data.state] then
        setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, serverListData[index].color or stateColor[serverListData[index].state])
      end
    end
  end
end

local function createRecommendServer(accData)
  ed.setString(serverlistPanel.servernum, T("\230\156\172\232\180\166\229\143\183\230\137\128\230\156\137\230\136\152\233\152\159"))
  local lbl = ed.createLabelTTF(#(accData or {}), 12)
  lbl:setPosition(30, 30)
  serverlistPanel.serverlistLayer.mainLayer:addChild(lbl)
  serverlistPanel.serverInfo:setVisible(false)
  serverlistPanel.recommend:setVisible(true)
  serverlistPanel.recommend:clear()
  serverlistPanel.recommend:changeItemConfig()
  local state = ed.storage.getString("hideOneGradeAccount")
  sortAccData(accData)
  for k, v in pairs(accData) do
    if state == "true" and v.level == 1 then
    else
      local index = 0
      local param = {
        id = v.avatar,
        uid = v.uid,
        level = v.level,
        vip = ed.getVipLevel(v.vip),
        avatar = v.avatar,
        name = v.name,
        babelLevel = v.babel_level
      }
      local svrData = {}
      for i, j in pairs(serverListData) do
        if tostring(v.svrid) == tostring(j.id) then
          index = i
          svrData = j
        end
      end
      local head = ed.createMainFrameHead(param)
      head:setAnchorPoint(ccp(1, 1))
      head:setPosition(ccp(35, 30))
      local itemData = serverlistPanel.recommend:addItem({
        head,
        svrData.name or ""
      }, {svrData, k})
    end
  end
end

local function showHideButton()
  local hide = serverlistPanel.hide
  local hidePress = serverlistPanel.hidePress
  local hideMark = serverlistPanel.hideMark
  local hideTitleLabel = serverlistPanel.hideTitleLabel
  local state = ed.storage.getString("hideOneGradeAccount")
  hideTitleLabel:setVisible(true)
  if state == "true" then
    hidePress:setVisible(true)
    hideMark:setVisible(true)
  else
    hide:setVisible(true)
  end
  local touchLayer = CCLayer:create()
  serverlistPanel.serverlistLayer.mainLayer:addChild(touchLayer)
  local touchNode = ed.ui.basetouchnode.btCreate()
  touchLayer:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -130, false)
  touchLayer:setTouchEnabled(true)
  touchNode:btRegisterButtonClick({
    button = hide,
    key = "hideOneGrade",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      hide:setVisible(false)
      hidePress:setVisible(true)
      hideMark:setVisible(true)
      ed.storage.setValue("hideOneGradeAccount", "true")
      createRecommendServer(accServerListData)
    end,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = hidePress,
    key = "showOneGrade",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      hide:setVisible(true)
      hidePress:setVisible(false)
      hideMark:setVisible(false)
      ed.storage.setValue("hideOneGradeAccount", "false")
      createRecommendServer(accServerListData)
    end,
    clickInterval = 0.5
  })
end

serverlist.showHideButton = showHideButton

local function initLastServerInfo()
  local itemData = serverlistPanel.lastServerInfo:addItem({
    lastServerInfo.name,
    lastServerInfo.state
  }, {lastServerInfo})
  if lastServerInfo.color then
    setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, lastServerInfo.color)
  end
  if stateColor[lastServerInfo.state] then
    setNodeColor(itemData.controllers.servername, itemData.controllers.serverstate, lastServerInfo.color or stateColor[lastServerInfo.state])
  end
end

local function initServerInfo()
  createServerItem(1, 10)
end

local function exit()
  if nil == serverlistPanel then
    return
  end
  local currentScene = ed.getCurrentScene()
  if currentScene then
    currentScene.scene:removeChild(serverlistPanel:getRootLayer(), true)
  end
  release()
end

function serverlist.listDownClick(itemData, x, y)
  local listData = serverlistPanel.ListView:getALLListData()
  for k = 1, #listData do
    if listData[k] == itemData then
      listData[k].controllers.bg:setVisible(true)
      listData[k].controllers.servername:setColor(ccc3(255, 234, 198))
    else
      listData[k].controllers.servername:setColor(ccc3(238, 204, 119))
      listData[k].controllers.bg:setVisible(false)
    end
  end
end

local function initRecallListData(data)
  recallListData = {}
  for _, item in pairs(data or {}) do
    if item.type == "recall" then
      table.insert(recallListData, item)
    end
  end
end

local function initData(data, accData)
  serverListData = data.serverListData
  accServerListData = accData
  initRecallListData(data.serverListData)
  currentServerName = data.currentServerName
  user_id = userid
  sessionId = data.sessionId
  bSDKLoginSucess = data.bSDKLoginSucess
  getLastServerInfo()
end

local function requestAcc()
  local msg = up.account_query()
  print("userid", ed.getDeviceId())
  if sdkLogin.isNewLoginMode() then
    msg.uin = sdkLogin.loginLogic.getDeviceIdList()
  elseif not EDFLAGWIN32 and not EDNativeDebug then
    local sdktype = ed.ui.serverlogin.changeType or EDSDKType
    if ed.isElementInTable(sdktype, {
      140,
      141,
      142,
      147
    }) then
      sdktype = 142
    end
    msg.uin = {
      string.format("%d-%s", sdktype, ed.getDeviceId())
    }
    EDLog("__________requestAcc_________" .. string.format("%d-%s", sdktype, ed.getDeviceId()))
  else
    msg.uin = {
      ed.getDeviceId()
    }
  end
  ed.ui.newbie.send(msg, "account_query")
end

serverlist.requestAcc = requestAcc

local function createLayer(data, accData)
  ListenTimer(Timer:Once(3), function()
    ed.loadEnd()
  end)
  initData(data, accData)
  if nil == serverlistPanel then
    serverlistPanel = panelMeta:new2(serverlist, EDTables.serverlistConfig.UIRes)
  end
  local currentScene = ed.getCurrentScene()
  if currentScene then
    currentScene.scene:addChild(serverlistPanel:getRootLayer(), 500)
  end
  initListView(serverListData, accServerListData)
  initLastServerInfo()
  if accData then
    showHideButton()
    createRecommendServer(accData)
  else
    initServerInfo()
  end
end

serverlist.createLayer = createLayer

function serverlist.create()
  requestAcc()
end

local function setLabelText(index, text)
  ed.setString(serverlistPanel.servername .. index, text)
end

function serverlist.onListClick(itemData, x, y)
  if not itemData.extraData then
    return
  end
  if not itemData.extraData[1] then
    return
  end
  if "recommend" == itemData.extraData[1] then
    createRecommendServer(accServerListData)
  elseif "recall" == itemData.extraData[1] then
    createRecallServer(recallListData)
  else
    createServerItem(itemData.extraData[1], itemData.extraData[2])
  end
end

function serverlist.changeCurrentServerInfo(name)
  if sdkLogin.isNewLoginMode() then
    ed.ui.serverlogin.sdkLoginRefreshCurrentServerInfo(name)
  else
    ed.ui.serverlogin.refreshCurrentServerInfo(name)
  end
  exit()
end

function serverlist.onClickServerinfo(itemData, x, y)
  serverlist.changeCurrentServerInfo(itemData.extraData[1].name)
end

function serverlist.entergame(index)
  local itemData = serverlistPanel.recommend:getListData(index)
  serverlist.changeCurrentServerInfo(itemData.extraData[1].name)
end

function serverlist.serverInfoDownClick(itemData, x, y)
  local listData = serverlistPanel.serverInfo:getALLListData()
  local lastServerlistData = serverlistPanel.lastServerInfo:getALLListData()
  if lastServerlistData[1] == itemData then
    lastServerlistData[1].controllers.bg:setVisible(true)
    for k = 1, #listData do
      listData[k].controllers.bg:setVisible(false)
    end
  else
    lastServerlistData[1].controllers.bg:setVisible(false)
    for k = 1, #listData do
      if listData[k] == itemData then
        listData[k].controllers.bg:setVisible(true)
      else
        listData[k].controllers.bg:setVisible(false)
      end
    end
  end
end

function serverlist.serverInfoUpClick()
  local listData = serverlistPanel.serverInfo:getALLListData()
  for k = 1, #listData do
    listData[k].controllers.bg:setVisible(false)
  end
  serverlistPanel.lastServerInfo:getListData(1).controllers.bg:setVisible(false)
end
