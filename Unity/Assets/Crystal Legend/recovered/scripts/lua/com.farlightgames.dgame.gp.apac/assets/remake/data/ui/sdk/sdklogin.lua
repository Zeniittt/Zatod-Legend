module("sdkLogin", package.seeall)
panel = nil
ChangeAccount = {}
logic = {}
serverInfo = nil
accountList = nil

function logic.onExit()
  panel:getRootLayer():removeFromParentAndCleanup(true)
  ed.ui.newbie.setEnterContainerVisible(true)
  panel = nil
end

function logic.onSearchAccount()
  print("on searchAccount")
end

function logic.onCreateAccount()
  print("on createAccount")
  local serverListWin = ed.getPopWindow("serverListWin")
  if serverListWin then
    serverListWin:refresh(serverInfo)
  else
    ed.ui.serverListWin.create(serverInfo):popWindow()
  end
  logic.onExit()
end

function logic.onClickAccount(itemData, x, y)
  print("on click account ")
  local extraData = itemData.extraData
  local userInfo = extraData[2]
  local serverInfo = extraData[1]
  loginLogic.setDeviceId(userInfo.deviceid)
  ed.setDeviceId(userInfo.deviceid)
  FireEvent("sdkLoginRefreshCurrentServerInfo", serverInfo.name, userInfo.uid)
  logic.onExit()
end

function logic.getCurrentServerAccount(sverid, uid)
  local param = {
    avatar = 1,
    name = "",
    vip = 0,
    user_id = "",
    level = 0,
    deviceid = 0
  }
  local userInfo
  for k, v in pairs(accountList or {}) do
    if tostring(v.svrid) == tostring(sverid) then
      userInfo = v
      break
    end
  end
  for k, v in pairs(accountList or {}) do
    if tostring(v.svrid) == tostring(sverid) and v.uid == uid then
      userInfo = v
      break
    end
  end
  if userInfo then
    param = {
      avatar = userInfo.avatar,
      name = userInfo.name,
      vip = userInfo.vip,
      user_id = userInfo.uid,
      level = userInfo.level,
      deviceid = userInfo.deviceid
    }
  end
  return param
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

local function initPanel(accData)
  if not accData or #accData == 0 then
    panel.hasNotAccount:setVisible(true)
    return
  end
  local list = panel.accountList
  list:clear()
  list:changeItemConfig()
  sortAccData(accData)
  for k, v in pairs(accData) do
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
    for i, j in pairs(serverInfo.serverListData) do
      if tostring(v.svrid) == tostring(j.id) then
        index = i
        svrData = j
      end
    end
    local head = ed.createMainFrameHead(param)
    head:setAnchorPoint(ccp(1, 1))
    head:setPosition(ccp(35, 30))
    local itemData = list:addItem({
      head,
      svrData.name or ""
    }, {
      svrData,
      v,
      k
    })
    if loginLogic.isLastLoginAccount(v.deviceid, svrData.id) then
      itemData.controllers.tag:setVisible(true)
    end
  end
end

function ChangeAccount.initData(serverList, accList)
  serverInfo = serverList
  accountList = accList
end

function ChangeAccount:create(serverList, accList)
  if panel == nil then
    panel = panelMeta:new2(logic, EDTables.sdkConfig.ChangeAccountRes)
    ChangeAccount.initData(serverList, accList)
  end
  local parent = ed.getCurrentScene()
  if parent then
    parent:ccScene():addChild(panel:getRootLayer(), 500)
  end
  initPanel(accList)
end
