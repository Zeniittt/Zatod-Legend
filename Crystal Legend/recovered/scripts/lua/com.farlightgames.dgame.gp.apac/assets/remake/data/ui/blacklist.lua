local class = {}
ed.blacklist = class
local blacklistPanel, targetUid, targetSid, currentIndex, targetRoleId

local function release()
  blacklistPanel = nil
  targetUid = nil
  currentIndex = nil
  targetRoleId = nil
end

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local function getBlacklistData()
  return ed.player._chat._black_list or {}
end

class.getBlacklistData = getBlacklistData

local function setBlacklistData(data)
  ed.player._chat._black_list = data
end

class.setBlacklistData = setBlacklistData

local function initData(data)
  if not data then
    return
  end
  for k, v in ipairs(data) do
    local param = {
      scale = 0.8,
      id = v._user_summary._avatar,
      vip = v._user_summary._vip > 0,
      level = v._user_summary._level,
      name = v._user_summary._name
    }
    local direct = ""
    if v._status and v._status == 1 then
      direct = T("\229\183\178\232\162\171\231\166\129\232\168\128")
    end
    blacklistPanel.ListView:addItem({param, direct}, {
      roleId = v._role_id
    })
  end
end

function class.create(data)
  if nil == blacklistPanel then
    blacklistPanel = panelMeta:new2(class, EDTables.blacklistConfig.UIRes)
  end
  if getRunScene() then
    getRunScene():addChild(blacklistPanel:getRootLayer(), 200)
  end
  initData(data._chat_blacklist_user)
end

function class.cancelShielding(index)
  currentIndex = index
  local item = blacklistPanel.ListView:getListData(index)
  if item.extraData then
    targetRoleId = item.extraData.roleId
    local msg = ed.upmsg.chat()
    msg._chat_del_bl = {}
    msg._chat_del_bl._role_id = targetRoleId
    ed.send(msg, "chat")
  end
end

function class.exit()
  if nil == blacklistPanel then
    return
  end
  if getRunScene() then
    getRunScene():removeChild(blacklistPanel:getRootLayer(), true)
  end
  release()
end

function class.getBlacklist()
  local msg = ed.upmsg.chat()
  msg._chat_fetch_bl = {}
  ed.send(msg, "chat")
end

local function findIdInBlacklist(list, roleId)
  list = list or {}
  for k, v in ipairs(list) do
    if v._role_id == roleId then
      return k
    end
  end
  return false
end

function class.addBlacklist(roleId)
  if not roleId then
    return
  end
  local data = getBlacklistData()
  if not findIdInBlacklist(data, roleId) then
    table.insert(data, {_role_id = roleId})
  end
  setBlacklistData(data)
  ed.applyFriend.delApplyFriend(roleId)
  ed.showToast(T("\228\189\160\229\183\178\231\187\143\230\136\144\229\138\159\229\177\143\232\148\189\232\175\165\231\142\169\229\174\182\231\154\132\230\137\128\230\156\137\232\129\138\229\164\169\228\191\161\230\129\175\n\228\189\160\229\143\175\228\187\165\229\156\168\229\165\189\229\143\139\231\149\140\233\157\162\228\184\173\229\143\150\230\182\136\229\177\143\232\148\189"))
end

function class.deleteBlacklist(roleId)
  if not roleId then
    return
  end
  local data = getBlacklistData()
  local k = findIdInBlacklist(data, roleId)
  if k then
    table.remove(data, k)
  end
  setBlacklistData(data)
  ed.showToast(T("\230\136\144\229\138\159\229\176\134\232\175\165\231\142\169\229\174\182\228\187\142\233\187\145\229\144\141\229\141\149\228\184\173\231\167\187\233\153\164"))
end

function class.isInBlacklist(roleId)
  local data = getBlacklistData()
  local k = findIdInBlacklist(data, roleId)
  if k then
    return true
  end
  return false
end

function class.setTargetUid(uid, sid)
  targetUid = uid
  targetSid = sid
end

function class.setTargetRoleId(roleId)
end

ed.friendlist = {}
local friendlist = ed.friendlist
ed.friendlist.MAX_FRIEND_AMOUNT = 70

local function setFriendlistData(data)
  ed.player._chat._friend_list = data
end

friendlist.setFriendlistData = setFriendlistData

local function getFriendlistData()
  return ed.player._chat._friend_list or {}
end

friendlist.getFriendlistData = getFriendlistData

local function getFriendAmount()
  return #getFriendlistData()
end

friendlist.getFriendAmount = getFriendAmount

local function isInFriendlist(roleId)
  for k, v in ipairs(getFriendlistData()) do
    if roleId == v._role_id then
      return true
    end
  end
  return false
end

ed.friendlist.isInFriendlist = isInFriendlist

local function findIdInFriendlist(list, roleId)
  list = list or {}
  for k, v in ipairs(list) do
    if v._role_id == roleId then
      return k
    end
  end
  return false
end

friendlist.findIdInFriendlist = findIdInFriendlist

function friendlist.deleteFriendlist(roleId)
  local data = getFriendlistData()
  local k = findIdInFriendlist(data, roleId)
  if k then
    table.remove(data, k)
  end
  setFriendlistData(data)
  FireEvent("deleteFriend", roleId)
end

function friendlist.addFriendlist(roleId)
  local data = getFriendlistData()
  if not findIdInFriendlist(data, roleId) then
    table.insert(data, {_role_id = roleId})
  end
  setFriendlistData(data)
  FireEvent("addFriend", roleId)
end

ed.applyFriend = {}
local applyFriend = ed.applyFriend

function applyFriend.setApplyFriendListData(data)
  ed.player._chat._apply_list = data
end

function applyFriend.getApplyFriendListData()
  if not ed.player._chat._apply_list then
    ed.player._chat._apply_list = {}
  end
  return ed.player._chat._apply_list
end

function applyFriend.getApplyFriendCount()
  local count = 0
  local applyFriendList = applyFriend.getApplyFriendListData()
  for index, applyFriend in ipairs(applyFriendList) do
    local roleId = applyFriend._role_id
    if not ed.blacklist.isInBlacklist(roleId) and not ed.friendlist.isInFriendlist(roleId) then
      count = count + 1
    end
  end
  return count
end

function applyFriend.addApplyFriend(addRoleId)
  local applyFriendList = applyFriend.getApplyFriendListData()
  if applyFriend.IsinApplyFriendList(addRoleId) then
    return
  end
  table.insert(applyFriendList, {_role_id = addRoleId})
  FireEvent("refreshApplyFriend")
  local ButtonType = ed.ui.configs.mainButton.ButtonType
  FireEvent("MainRedTagChange", ButtonType.FRIEND)
end

function applyFriend.delApplyFriend(delRoleId)
  local applyFriendList = applyFriend.getApplyFriendListData()
  local index = applyFriend.IsinApplyFriendList(delRoleId)
  if index then
    table.remove(applyFriendList, index)
  end
  local pos
  local applyFriendList = ed.chatNetDataMrg.applyFriendList or {}
  for index, chatContactUser in ipairs(applyFriendList) do
    if chatContactUser._role_id == delRoleId then
      pos = index
      break
    end
  end
  if pos then
    table.remove(applyFriendList, pos)
  end
  FireEvent("refreshApplyFriend")
  local ButtonType = ed.ui.configs.mainButton.ButtonType
  FireEvent("MainRedTagChange", ButtonType.FRIEND)
end

function applyFriend.IsinApplyFriendList(checkRoleId)
  local applyFriendList = applyFriend.getApplyFriendListData()
  for index, role in ipairs(applyFriendList) do
    if role._role_id == checkRoleId then
      return index
    end
  end
  return false
end
