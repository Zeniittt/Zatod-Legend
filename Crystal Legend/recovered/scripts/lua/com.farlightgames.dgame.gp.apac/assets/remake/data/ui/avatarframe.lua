local class = {}
ed.ui.avatarframe = class
local avatarframePanel
local unlockframes = {}
local lockframes = {}
local self
local totols = 0

local function release()
  avatarframePanel = nil
  self = nil
  unlockframes = {}
  lockframes = {}
end

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local function insertFramesTable(ftable, id, res, des, name, sortid)
  local params = {
    id = id,
    picture = res,
    des = des,
    Name = name,
    sort = sortid
  }
  ftable[id] = params
end

local function getTableNum(tb)
  local i = 0
  for k, v in pairs(tb) do
    i = i + 1
  end
  return i
end

local function splitTable()
  local avatarframes = ed.getDataTable("AvatarFrame")
  for k, v in pairs(avatarframes) do
    if type(k) == "number" then
      local requirement = v["Requirement Type"]
      if requirement == "PlayerLevel" then
        insertFramesTable(unlockframes, v.ID, v.Picture, v["Unlock Description"], v.Name, v["Display ID"])
      elseif requirement == "VIPLevel" then
        if ed.player:getvip() >= v["Requirement Target"] then
          insertFramesTable(unlockframes, v.ID, v.Picture, v["Unlock Description"], v.Name, v["Display ID"])
        elseif not v.Hide then
          insertFramesTable(lockframes, v.ID, v.Picture, v["Unlock Description"], v.Name, v["Display ID"])
        end
      elseif requirement == "HaveItem" then
        if ed.player:getEquipAmount(v["Requirement ID"]) >= v["Requirement Target"] then
          insertFramesTable(unlockframes, v.ID, v.Picture, v["Unlock Description"], v.Name, v["Display ID"])
        elseif not v.Hide and not v["Lock Hide"] then
          insertFramesTable(lockframes, v.ID, v.Picture, v["Unlock Description"], v.Name, v["Display ID"])
        end
      end
    end
  end
end

local function getUnlockData(k)
  if unlockframes[k] and unlockframes[k].picture then
    totols = totols + 1
    return unlockframes[k].picture
  end
end

local function setUnlockFrame()
  avatarframePanel.ListView:changeItemConfig(1)
  avatarframePanel.ListView:addItem({
    T("\229\183\178\232\167\163\233\148\129\229\164\180\229\131\143\230\161\134")
  }, {})
  avatarframePanel.ListView:changeItemConfig(2)
  if #unlockframes == 0 then
    return
  end
  local sunLockframes = {}
  for k, v in pairs(unlockframes) do
    table.insert(sunLockframes, v)
  end
  table.sort(sunLockframes, function(a, b)
    return a.sort < b.sort
  end)
  for k, v in pairs(sunLockframes) do
    avatarframePanel.ListView:addItem({
      v.picture,
      v.Name
    }, {
      id = v.id
    })
  end
end

local function setLockFrame()
  if getTableNum(lockframes) == 0 then
    return
  end
  avatarframePanel.ListView:changeItemConfig(1)
  avatarframePanel.ListView:addItem({
    T("\230\156\170\232\167\163\233\148\129\229\164\180\229\131\143\230\161\134")
  }, {})
  avatarframePanel.ListView:changeItemConfig(3)
  local sLockframes = {}
  for k, v in pairs(lockframes) do
    table.insert(sLockframes, v)
  end
  table.sort(sLockframes, function(a, b)
    return a.sort < b.sort
  end)
  for k, v in pairs(sLockframes) do
    avatarframePanel.ListView:addItem({
      v.picture,
      v.Name
    }, {
      id = v.id
    })
  end
end

local function setListView()
  setUnlockFrame()
  setLockFrame()
end

local function initRomoteUI()
  if ed.TitleMgr.getInstance():isRemoteAvatarDisable() then
    avatarframePanel.spanBtn:setVisible(false)
    avatarframePanel.ui_world:setVisible(false)
    local x, y = avatarframePanel.frame2:getPosition()
    avatarframePanel.frame2:setPosition(ccp(x, y + 30))
  end
end

local function initData()
  splitTable()
  setListView()
  initRomoteUI()
end

function class.sendSet(itemData, x, y)
  if nil == itemData then
    return
  end
  if lockframes[itemData.extraData.id] then
    ed.showToast(lockframes[itemData.extraData.id].des)
    return
  end
  local res, key
  key = itemData.extraData.id
  if key then
    ed.ui.selectwindow.ofavatar:setSelfParam({
      name = "avatar",
      callback = function(key)
        local icon = ed.analyzeAvatar(key)
        local avatar, avatarFrame = icon.avatar, icon.avatarFrame
        local fres = ed.getDataTable("AvatarFrame")[avatarFrame].Picture
        self:createHeadIcon(avatar)
        self:createHeadFrame(fres)
      end
    })
    ed.ui.selectwindow.ofavatar:doSendSetFrame(key)
  end
end

function class.listDownClick(itemData, x, y)
  if itemData.controllers.ui3 and itemData.controllers.bg3 then
    itemData.controllers.ui3:setScale(0.95)
    itemData.controllers.bg3:setScale(0.95)
  end
end

function class.listUpClick(itemData, x, y)
  if itemData.controllers.ui3 and itemData.controllers.bg3 then
    itemData.controllers.ui3:setScale(1)
    itemData.controllers.bg3:setScale(1)
  end
end

function class.onSpanBtnClicked()
  class.exit()
  FireEvent("openSpanServerSet")
end

function class.onHeadBtnClicked()
  class.exit()
  FireEvent("openHeadFrame")
end

function class.onTitleBtnClicked()
  class.exit()
  FireEvent("openTitleFrame")
end

function class.create(id)
  self = id
  if nil == avatarframePanel then
    avatarframePanel = panelMeta:new2(class, EDTables.avatarframeConfig.UIRes)
  end
  if getRunScene() then
    getRunScene():addChild(avatarframePanel:getRootLayer(), 200)
  end
  initData()
end

function class.exit()
  if nil == avatarframePanel then
    return
  end
  if getRunScene() then
    getRunScene():removeChild(avatarframePanel:getRootLayer(), true)
  end
  release()
end

local function closePanel(result)
  if result and avatarframePanel then
    class.exit()
  end
end

ListenEvent("setAvatarFrame", closePanel)
