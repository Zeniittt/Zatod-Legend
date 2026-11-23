local base = ed.ui.popwindow
local serverListWin = newclass(base.mt)
ed.ui.serverListWin = serverListWin
local stateColor = {
  [T("\231\187\180\230\138\164")] = ccc3(183, 183, 183),
  [T("\231\136\134\230\187\161")] = ccc3(255, 81, 20),
  [T("\231\185\129\229\191\153")] = ccc3(255, 225, 20),
  [T("\230\142\168\232\141\144")] = ccc3(20, 255, 59),
  [T("\230\150\176\229\140\186")] = ccc3(238, 204, 119),
  [T("\232\135\170\230\181\139")] = ccc3(230, 155, 58)
}
local stateRes = {
  [T("\231\187\180\230\138\164")] = "installer/login/free.png",
  [T("\231\136\134\230\187\161")] = "installer/login/hot.png",
  [T("\231\185\129\229\191\153")] = "installer/login/busy.png",
  [T("\230\142\168\232\141\144")] = "installer/login/free.png",
  [T("\230\150\176\229\140\186")] = "installer/login/free.png",
  [T("\232\135\170\230\181\139")] = "installer/login/free.png"
}
local FilterConfig = {
  {
    limitLv = 0,
    des = T("\228\184\141\233\154\144\232\151\143\232\180\166\229\143\183")
  },
  {
    limitLv = 1,
    des = T("\233\154\144\232\151\143%d\231\186\167\232\180\166\229\143\183")
  },
  {
    limitLv = 10,
    des = T("\233\154\144\232\151\143%d\231\186\167\228\187\165\228\184\139\232\180\166\229\143\183")
  },
  {
    limitLv = 20,
    des = T("\233\154\144\232\151\143%d\231\186\167\228\187\165\228\184\139\232\180\166\229\143\183")
  },
  {
    limitLv = 30,
    des = T("\233\154\144\232\151\143%d\231\186\167\228\187\165\228\184\139\232\180\166\229\143\183")
  }
}
local SERVER_RECOMMEND = "recommend"
local SERVER_RECALL = "recall"
local SERVER_NORMAL = "normal"

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

local function getLocalServerName(name)
  if ed.isAreaOverSea() then
    return ed.lookupDataTable("Servername", EDCurLanguage, name) or name
  end
  return name
end

ed.getLocalServerName = getLocalServerName

local function processServerName(str)
  local id, name = string.match(str, "^(%S+)%s+(.*)$")
  if not id or id:match("^%D+$") or not name then
    id = nil
    name = str
  end
  return id, name
end

ed.processServerName = processServerName

function serverListWin.create(data, accountData)
  FireEvent("NetStatus", "requestAcc", 1)
  local self = base.create("serverListWin")
  setmetatable(self, serverListWin.mt)
  self:init(data, accountData)
  return self
end

function serverListWin:refresh(data, accountData)
  FireEvent("NetStatus", "requestAcc", 1)
  self:initData(data, accountData)
  self:refreshAllServerList()
  self:refreshAllServerSelect(self.selectAllServerIndex)
end

function serverListWin.requestAccount()
  FireEvent("NetStatus", "requestAcc", 0)
  local up = pb_loader("acc_up")()
  local msg = up.account_query()
  print("userid", ed.getDeviceId())
  if sdkLogin.isNewLoginMode() then
    msg.uin = sdkLogin.loginLogic.getDeviceIdList()
  elseif not EDFLAGWIN32 then
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

function serverListWin:init(data, accountData)
  ListenTimer(Timer:Once(3), function()
    ed.loadEnd()
  end)
  self.serverListData = {}
  self.accountData = {}
  self.accServerListData = {}
  self.recallListData = {}
  self.lastServerInfo = {}
  self.colNum = 10
  self.selectAllServerIndex = 1
  self.allServerList = {}
  self.key = nil
  self.lastestOpenTime = nil
  self.filterConfigIndex = ed.storage.getInt("hideFilterIndex")
  if nil == self.filterConfigIndex or 0 == self.filterConfigIndex then
    self.filterConfigIndex = 1
  end
  self:initData(data, accountData)
  self:initView()
  self:addEventListener()
end

function serverListWin:initData(data, accountData)
  self.serverListData = self:tableReverse(data.serverListData or {})
  self.accountData = accountData
  self:initRecallListData(data.serverListData)
  self:getLastServerInfo()
  self:initOpenTime()
end

function serverListWin:tableReverse(array)
  local size = #array
  for index = 1, math.floor(size / 2) do
    local temp = array[index]
    array[index] = array[size + 1 - index]
    array[size + 1 - index] = temp
  end
  return array
end

function serverListWin:initView()
  local container, ui = ed.editorui(ed.uieditor.serverList)
  self.ui = ui
  self.container:addChild(container)
  self:adaptView()
  self:initLastServerInfo()
  self:initAllServerList()
  self:initFilterList()
  self:refreshAllServerSelect(self.selectAllServerIndex)
  self:setFilterVisible(false)
end

function serverListWin:adaptView()
  local offsetWidth = (ed.display.winSize.width - 960) * 0.66
  local offsetHeight = (ed.display.winSize.height - 540) * 0.66
  local allServerBgSize = self.ui.allServerBg:getContentSize()
  self.ui.allServerBg:setContentSize(CCSizeMake(allServerBgSize.width + offsetWidth * 0.1, allServerBgSize.height + offsetHeight))
  self.ui.allServerBg:setPositionX(self.ui.allServerBg:getPositionX() - offsetWidth * 0.33)
  self.ui.allServerLabel:setPositionX(self.ui.allServerLabel:getPositionX() + offsetWidth * 0.1)
  self.ui.allServerLabel:setPositionY(self.ui.allServerLabel:getPositionY() + offsetHeight)
  local allServerListSize = self.ui.allServerList:getContentSize()
  self.ui.allServerList:setContentSize(CCSizeMake(allServerListSize.width, allServerListSize.height + offsetHeight))
  self.ui.allServerList:setPositionX(self.ui.allServerList:getPositionX() + offsetWidth * 0.05)
  local lastServerBg = self.ui.lastServerBg:getContentSize()
  self.ui.lastServerBg:setContentSize(CCSizeMake(lastServerBg.width + offsetWidth * 0.9, lastServerBg.height))
  self.ui.lastServerBg:setPositionX(self.ui.lastServerBg:getPositionX() + offsetWidth * 0.17)
  self.ui.lastServerBg:setPositionY(self.ui.lastServerBg:getPositionY() + offsetHeight / 2)
  local serverListBg = self.ui.serverListBg:getContentSize()
  self.ui.serverListBg:setContentSize(CCSizeMake(serverListBg.width + offsetWidth * 0.9, serverListBg.height + offsetHeight))
  self.ui.serverListBg:setPositionX(self.ui.serverListBg:getPositionX() + offsetWidth * 0.17)
  self.ui.serverNum:setPositionY(self.ui.serverNum:getPositionY() + offsetHeight)
  self.ui.filterPanel:setPositionX(self.ui.filterPanel:getPositionX() + offsetWidth * 0.9)
  local serverListSize = self.ui.serverList:getContentSize()
  self.ui.serverList:setContentSize(CCSizeMake(serverListSize.width, serverListSize.height + offsetHeight))
  self.ui.serverList:setPositionX(self.ui.serverList:getPositionX() + offsetWidth * 0.45)
end

function serverListWin:initRecallListData(data)
  self.recallListData = {}
  for _, item in pairs(data or {}) do
    if item.type == SERVER_RECALL then
      table.insert(self.recallListData, item)
    end
  end
end

function serverListWin:getLastServerInfo()
  local info = ed.storage.getString(tostring(EDSDKType) .. "lastserverinfo")
  self.lastServerName = string.match(info, "name:([^,]*)")
  if self.lastServerName == "" then
    self.lastServerName = self.serverListData[1].name
  end
  self.lastServerInfo = self:getServerInfoByName(self.lastServerName)
end

function serverListWin:initOpenTime()
  self.lastestOpenTime = nil
  local sysTimeStamp = os.time()
  for index, serverData in ipairs(self.serverListData) do
    if serverData.open and sysTimeStamp < serverData.open then
      if not self.lastestOpenTime then
        self.lastestOpenTime = serverData.open
      else
        self.lastestOpenTime = serverData.open < self.lastestOpenTime and serverData.open or self.lastestOpenTime
      end
    end
  end
  if self.lastestOpenTime then
    self:listenTimer(Timer:Once(self.lastestOpenTime - sysTimeStamp), function()
      ed.doInitServer()
    end)
  end
end

function serverListWin:getServerInfoByName(name)
  if sdkLogin.isNewLoginMode() then
    local serverData = self.serverListData[1]
    serverData.serverIndex = 1
    return serverData
  end
  for serverIndex, v in ipairs(self.serverListData) do
    if v.name == name then
      v.serverIndex = serverIndex
      return v
    end
  end
  local serverData = self.serverListData[1]
  serverData.serverIndex = 1
  return serverData
end

function serverListWin:initLastServerInfo()
  local state = self.lastServerInfo.state
  local lastServerColor = self.lastServerInfo.color
  if lastServerColor or stateColor[state] then
    local color = lastServerColor or stateColor[state]
    local res = stateRes[state]
    self.ui.serverID:setColor(color)
    self.ui.serverName:setColor(color)
    self.ui.serverStateLabel:setVisible(true)
    self.ui.serverStateLabel:setColor(color)
    self.ui.serverStateLabel:setString(state)
    ed.setTexture(self.ui.serverStateImage, res)
  else
    self.ui.serverStateLabel:setVisible(false)
  end
  local serverID, serverName = ed.processServerName(self.lastServerInfo.name)
  if nil ~= serverID then
    self.ui.serverID:setVisible(true)
    ed.setString(self.ui.serverID, serverID)
    ed.setString(self.ui.serverName, ed.getLocalServerName(serverName))
  else
    self.ui.serverID:setVisible(false)
    ed.setString(self.ui.serverName, ed.getLocalServerName(serverName))
  end
end

function serverListWin:initAllServerList()
  self.allServerDragList = ed.UITool.createDraglist(self.ui.allServerList, {
    doPressIn = self:doPressInAllServerList(),
    priority = -300
  })
  self:refreshAllServerList()
end

function serverListWin:createFilterName(des)
  local contentSize = CCSizeMake(176, 30)
  local node = CCNode:create()
  node:setContentSize(contentSize)
  node:setAnchorPoint(ccp(0.5, 0.5))
  local selectBg = ed.createScale9Sprite("installer/login/button_choose.png", CCRectMake(30, 0, 28, 0))
  node:addChild(selectBg)
  selectBg:setContentSize(CCSizeMake(contentSize.width, selectBg:getContentSize().height))
  selectBg:setPosition(ccp(contentSize.width * 0.5, contentSize.height * 0.5))
  local bgSize = selectBg:getContentSize()
  local desTxt = ed.createttf(des, 15)
  node:addChild(desTxt)
  desTxt:setPosition(ccp(contentSize.width * 0.5, contentSize.height * 0.5))
  ed.setLabelColor(desTxt, ed.toccc3(16776423))
  ed.setLabelStroke(desTxt, ed.toccc3(2693915), 1)
  desTxt:limitWidthByScale(150)
  selectBg:setVisible(false)
  node.selectBg = selectBg
  node.desTxt = desTxt
  return node
end

function serverListWin:initServerList()
  local delegate = {
    numberOfCells = function()
      if self.key == SERVER_RECOMMEND then
        return #self.accServerListData
      elseif self.key == SERVER_RECALL then
        return #self.recallListData
      else
        return #self.normalServerList
      end
    end,
    cellSizeFromIndex = function(index)
      return self:getContentSizeByKey(self.key)
    end,
    createCell = function(index)
      local data = {}
      local node, ui
      if self.key == SERVER_RECOMMEND then
        data = self.accServerListData[index]
        node, ui = self:createRecommendServer(data)
      elseif self.key == SERVER_RECALL then
        data = self.recallListData[index]
        node, ui = self:createRecallServer(data)
      else
        data = self.normalServerList[index]
        node, ui = self:createNormalServer(data)
      end
      return node, {data = data, ui = ui}
    end,
    doClickIn = function(cell)
      if ed.checkVisible(self.ui.maskPanel) then
        return
      end
      local data = cell.data
      local serverName
      if self.key ~= SERVER_RECOMMEND and not ed.debug_mode and data.data.open then
        local sysTimeStamp = os.time()
        if sysTimeStamp < data.data.open then
          ed.showToast(T("\230\150\176\230\156\141\233\162\132\229\145\138\239\188\140\232\175\183\231\173\137\229\190\133\229\188\128\229\144\175"))
          return
        end
      end
      if self.key == SERVER_RECOMMEND then
        local serverData = {}
        for index, v in ipairs(self.serverListData) do
          if tostring(data.data.svrid) == tostring(v.id) then
            serverData = v
            break
          end
        end
        serverName = serverData.name
      else
        serverName = data.data.name
      end
      self:changeCurrentServerInfo(serverName)
    end
  }
  local size = self.ui.serverList:getContentSize()
  local colNum = self.key == SERVER_RECOMMEND and 3 or 2
  local param = {
    delegate = delegate,
    cliprect = CCRectMake(0, 0, size.width, size.height),
    container = self.ui.serverList,
    touchpriority = -315,
    zorder = 10,
    dragMode = 1,
    noshade = true,
    colNum = colNum
  }
  if self.serverTbView then
    if self.key == SERVER_RECOMMEND then
      self.serverTbView.colNum = 3
    else
      self.serverTbView.colNum = 2
    end
    self.serverTbView:reloadData()
  else
    self.serverTbView = Tableview.create(param)
  end
end

function serverListWin:getContentSizeByKey(key)
  if key == SERVER_RECOMMEND then
    return CCSize(171.5, 138.5)
  elseif key == SERVER_RECALL then
    return CCSize(288, 64)
  else
    return CCSize(288, 64)
  end
end

function serverListWin:refreshAllServerList()
  local allServerList = {}
  local groupNum = getGroupNum(#self.serverListData, self.colNum)
  if self.accountData and not sdkLogin.isNewLoginMode() then
    table.insert(allServerList, {
      name = T("\230\156\128\232\191\145\231\153\187\229\189\149"),
      key = SERVER_RECOMMEND
    })
  end
  if #self.recallListData > 0 then
    table.insert(allServerList, {
      name = T("\229\143\172\229\155\158\230\156\141"),
      key = SERVER_RECALL
    })
  end
  self.allServerList = allServerList
  for k = groupNum, 1, -1 do
    local minNum, maxNum = setItemData(self.colNum, k, #self.serverListData)
    local string = setZeroForNum(minNum) .. "--" .. setZeroForNum(maxNum) .. T("\229\140\186")
    table.insert(allServerList, {
      name = string,
      key = SERVER_NORMAL,
      minNum = minNum,
      maxNum = maxNum
    })
  end
  local posY = 0
  local gapY = 1
  local size = self.ui.allServerList:getContentSize()
  self.allServerDragList:clearList()
  for index, data in ipairs(allServerList) do
    local serverNameItem = self:createServerName(data.name)
    local height = serverNameItem:getContentSize().height
    self.allServerDragList:addItem(serverNameItem)
    serverNameItem:setPosition(ccp(size.width / 2, size.height - (posY + gapY) - height / 2))
    posY = posY + height + gapY
  end
  self.allServerDragList:initListHeight(posY)
end

function serverListWin:createServerName(name)
  local node = CCNode:create()
  local selectBg = ed.createSprite("installer/login/Select_bg.png")
  local bgSize = selectBg:getContentSize()
  local serverName = ed.createLabelWithFontInfo(name, "dark_yellow1")
  local line = ed.createSprite("installer/login/splitline.png")
  node:addChild(selectBg)
  node:addChild(serverName)
  node:addChild(line)
  line:setPositionY(-bgSize.height / 2)
  selectBg:setVisible(false)
  node.selectBg = selectBg
  node:setContentSize(CCSizeMake(bgSize.width, bgSize.height))
  return node
end

function serverListWin:refreshAllServerSelect(groupIndex)
  local lastSelectItem = self.allServerDragList.listItems[self.selectAllServerIndex]
  if lastSelectItem then
    lastSelectItem.selectBg:setVisible(false)
  end
  self.selectAllServerIndex = math.min(groupIndex, #self.allServerList)
  local currentSelectItem = self.allServerDragList.listItems[self.selectAllServerIndex]
  if currentSelectItem then
    currentSelectItem.selectBg:setVisible(true)
  end
  local itemData = self.allServerList[self.selectAllServerIndex]
  self.key = itemData.key
  if self.key == SERVER_RECOMMEND then
    self.ui.serverNum:setString(T("\230\156\172\232\180\166\229\143\183\230\137\128\230\156\137\230\136\152\233\152\159"))
    self.accServerListData = {}
    for index, serverData in ipairs(self.accountData and self.accountData or {}) do
      if self:checkServerValid(serverData) and serverData.level > FilterConfig[self.filterConfigIndex].limitLv then
        table.insert(self.accServerListData, serverData)
      end
    end
  elseif self.key == SERVER_RECALL then
    self.ui.serverNum:setString(T("\229\143\172\229\155\158\230\156\141\229\138\161\229\153\168"))
  elseif itemData.key == SERVER_NORMAL then
    local minNum = itemData.minNum
    local maxNum = itemData.maxNum
    self.ui.serverNum:setString(T("\230\156\141\229\138\161\229\153\168 ") .. minNum .. "-" .. maxNum)
    self.normalServerList = {}
    for k = minNum, maxNum do
      local serverData = self.serverListData[k]
      if serverData then
        serverData.serverIndex = k
        table.insert(self.normalServerList, serverData)
      end
    end
  end
  self:initServerList()
end

function serverListWin:doPressInAllServerList()
  local function handler(x, y)
    if ed.checkVisible(self.ui.maskPanel) then
      return
    end
    for index, item in ipairs(self.allServerDragList.listItems or {}) do
      if ed.containsPoint(item.selectBg, x, y) then
        self:refreshAllServerSelect(index)
        return item
      end
    end
  end
  
  return handler
end

function serverListWin:createRecommendServer(data)
  local container, ui = ed.editorui(ed.uieditor.serverPlayerItem)
  container:setContentSize(ui.bg:getContentSize())
  local serverData = {}
  for serverIndex, v in ipairs(self.serverListData) do
    if tostring(data.svrid) == tostring(v.id) then
      serverData = v
      break
    end
  end
  local serverID, serverName = ed.processServerName(serverData.name)
  if nil ~= serverID then
    ui.serverID:setVisible(true)
    ed.setString(ui.serverID, serverID)
    ed.setString(ui.serverName, ed.getLocalServerName(serverName))
  else
    ui.serverID:setVisible(false)
    ed.setString(ui.serverName, ed.getLocalServerName(serverName))
  end
  ui.playerName:setString(data.name)
  ui.playerLevel:setString(tostring(data.level))
  local head = ed.getHeroIconByID({
    id = data.avatar,
    avatar = data.avatar
  })
  ui.headFrameBg:addChild(head)
  local headFrameBgSize = ui.headFrameBg:getContentSize()
  head:setPosition(ccp(headFrameBgSize.width / 2, headFrameBgSize.height / 2))
  ui.headFrameBg:setScale(0.8)
  return container, ui
end

function serverListWin:createRecallServer(data)
  local container, ui = self:createServerItem(data)
  ui.openTimeBg:setVisible(false)
  ui.serverInfo:setPositionY(21)
  return container, ui
end

function serverListWin:createNormalServer(data)
  local container, ui = self:createServerItem(data)
  local open = data.open
  if open and os.time() < tonumber(open) then
    local formatStr = (ed.isAreaOverSea() and "!" or "") .. "%Y-%m-%d-%H-%M-%S"
    local openStr = os.date(formatStr, open)
    local y, m, d, h, mi, s = string.match(openStr, "(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)")
    ui.openTimeBg:setVisible(true)
    ui.serverInfo:setPositionY(31)
    ui.date:setString(string.format(T("%d\230\156\136%d\230\151\165"), m, d))
    ui.time:setString(string.format(T("%.2d:%.2d\229\188\128\229\144\175") .. ed.getUTCLabel(), h, mi))
  else
    ui.openTimeBg:setVisible(false)
    ui.serverInfo:setPositionY(21)
  end
  return container, ui
end

function serverListWin:createServerItem(data)
  local container, ui = ed.editorui(ed.uieditor.serverItem)
  container:setContentSize(ui.bg:getContentSize())
  if data.color or stateColor[data.state] then
    local color = data.color or stateColor[data.state]
    local res = stateRes[data.state]
    ui.serverName:setColor(color)
    ui.serverID:setColor(color)
    ui.serverStateLabel:setColor(color)
    ui.serverStateLabel:setVisible(true)
    ed.setString(ui.serverStateLabel, data.state)
    ed.setTexture(ui.serverState, res)
  else
    ui.serverStateLabel:setVisible(false)
  end
  local serverID, serverName = ed.processServerName(data.name)
  if nil ~= serverID then
    ui.serverID:setVisible(true)
    ed.setString(ui.serverID, serverID)
    ed.setString(ui.serverName, ed.getLocalServerName(serverName))
  else
    ui.serverID:setVisible(false)
    ed.setString(ui.serverName, ed.getLocalServerName(serverName))
  end
  if ed.isAreaOverSea() then
    ui.serverName:setPositionX(45)
  end
  return container, ui
end

function serverListWin:changeCurrentServerInfo(serverName)
  if sdkLogin.isNewLoginMode() then
    FireEvent("sdkLoginRefreshCurrentServerInfo", serverName)
  else
    FireEvent("refreshCurrentServerInfo", serverName)
  end
  self:close()
end

function serverListWin:checkServerValid(accData)
  for serverIndex, v in ipairs(self.serverListData) do
    if v and tostring(accData.svrid) == tostring(v.id) then
      return true
    end
  end
  return false
end

function serverListWin:doPressInFilterList()
  local function handler(x, y)
    if not ed.checkVisible(self.ui.filterContentBg) then
      return
    end
    for index, item in ipairs(self.filterDragList.listItems or {}) do
      if ed.containsPoint(item, x, y) then
        return item, index
      end
    end
  end
  
  return handler
end

function serverListWin:doClickInFilterList()
  local function handler(x, y, item, index)
    if not ed.checkVisible(self.ui.filterContentBg) or not ed.containsPoint(item, x, y) then
      return
    end
    self:onFilterItemEvent(index)
  end
  
  return handler
end

function serverListWin:initFilterList()
  local x, y = self.ui.filterPanel:getPosition()
  self.ui.filterPanel:setPosition(x - ed.display.halfFixedWidth / 2, y + ed.display.halfFixedHeight * 1.3)
  self.filterDragList = ed.UITool.createDraglist(self.ui.filterListPanel, {
    doPressIn = self:doPressInFilterList(),
    doClickIn = self:doClickInFilterList(),
    priority = -300
  })
  local itemHeight = 0
  local size = self.ui.filterListPanel:getContentSize()
  self.filterDragList:clearList()
  for index, data in ipairs(FilterConfig) do
    local filterItem = self:createFilterName(string.format(data.des, data.limitLv))
    itemHeight = filterItem:getContentSize().height
    self.filterDragList:addItem(filterItem)
    filterItem:setPosition(ccp(size.width / 2, size.height - (index - 0.5) * itemHeight))
  end
  self.filterDragList:initListHeight(itemHeight * #FilterConfig)
  self:refreshFilterList(self.filterConfigIndex)
end

function serverListWin:refreshFilterList(newIndex)
  local lastSelectItem = self.filterDragList.listItems[self.filterConfigIndex]
  if nil ~= lastSelectItem then
    lastSelectItem.selectBg:setVisible(false)
  end
  self.filterConfigIndex = newIndex
  ed.storage.setValue("hideFilterIndex", self.filterConfigIndex)
  local curSelectItem = self.filterDragList.listItems[self.filterConfigIndex]
  if nil ~= curSelectItem then
    curSelectItem.selectBg:setVisible(true)
    ed.setString(self.ui.filterDesTxt, curSelectItem.desTxt:getString())
    self.ui.filterDesTxt:limitWidthByScale(150)
  end
end

function serverListWin:onFilterItemEvent(newIndex)
  self:refreshFilterList(newIndex)
  self:refreshAllServerSelect(1)
  self:setFilterVisible(false)
end

function serverListWin:setFilterVisible(isVisible)
  self.ui.filterContentBg:setVisible(isVisible)
  self.ui.filterSelectBg:setVisible(isVisible)
  self.ui.maskPanel:setVisible(isVisible)
  self.ui.filterNormalBg:setVisible(not isVisible)
  ed.setLabelStroke(self.ui.filterDesTxt, ed.toccc3(isVisible and 10440970 or 2693915), 1)
  self.serverTbView.dragList:setTouchEnabled(not isVisible)
end

function serverListWin:addEventListener()
  self:btRegisterButtonClick({
    button = self.ui.filterNormalBg,
    key = "filterSelect",
    clickHandler = function()
      self:setFilterVisible(true)
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.maskPanel,
    key = "filterMask",
    clickHandler = function(node, x, y)
      self:setFilterVisible(false)
    end,
    extraCheckHandler = function(x, y)
      if ed.containsPoint(self.ui.filterPanel, x, y) then
        return false
      else
        return true
      end
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.lastServerBg,
    press = self.ui.lastServerBg_press,
    pressScale = 0.98,
    key = "lastServer",
    force = true,
    clickHandler = function()
      self:changeCurrentServerInfo(self.lastServerName)
    end
  })
end

function serverListWin:close()
  self:destroy({skipAnim = true})
end
