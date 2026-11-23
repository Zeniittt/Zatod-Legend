local class = {}
ed.membershare = class
local sharPanel, memberData, memberNum, shareData, backMemberData, targetMember

local function release()
  sharPanel = nil
end

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local function copyTab(st)
  local tab = {}
  for k, v in pairs(st or {}) do
    if type(v) ~= "table" then
      tab[k] = v
    else
      tab[k] = copyTab(v)
    end
  end
  return tab
end

local function resortTargetMemeber(data)
  local targets = {}
  for k, v in pairs(targetMember) do
    table.insert(targets, k)
  end
  return targets
end

local function getTargetsNum(data)
  local i = 0
  for k, v in pairs(data or {}) do
    i = i + 1
  end
  return i
end

function class.choiceUnit()
  targetMember = {}
  local listData = sharPanel.memberlist:getALLListData()
  for k, v in pairs(listData) do
    v.controllers.select_frame:setVisible(true)
    targetMember[v.extraData.id] = v.extraData.name
  end
  sharPanel.num:setString(string.format(T("%d\228\186\186"), getTargetsNum(targetMember)))
end

function class.clearAll()
  local listData = sharPanel.memberlist:getALLListData()
  for k, v in pairs(listData) do
    v.controllers.select_frame:setVisible(false)
  end
  targetMember = {}
  sharPanel.num:setString(string.format(T("%d\228\186\186"), 0))
end

function class.choicePrivate()
  if getTargetsNum(targetMember) == 0 then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\229\143\145\233\128\129\229\175\185\232\177\161"))
    return
  end
  if getTargetsNum(targetMember) == memberNum then
    targetMember = {}
    memberNum = nil
    ed.ui.excavateinvite:setShareTarget()
    class.exit()
    return
  end
  local icon = CCNode:create()
  icon:setAnchorPoint(ccp(0, 0.5))
  icon:setPosition(ccp(0, 0))
  local ui1 = ed.createLabelWithFontInfo(T("\233\130\128\232\175\183:"), "dark_yellow")
  ui1:setAnchorPoint(ccp(0, 0.5))
  icon:addChild(ui1)
  local name = {}
  for k, v in pairs(targetMember) do
    table.insert(name, ed.createLabelWithFontInfo(v, "normal_button"))
  end
  name[1]:setAnchorPoint(ccp(0, 0.5))
  name[1]:setPosition(ccp(50, 0))
  icon:addChild(name[1])
  if 1 < #name then
    ui1:setPosition(ccp(0, 17))
    name[1]:setPosition(ccp(50, 17))
    name[2]:setAnchorPoint(ccp(0, 0.5))
    name[2]:setPosition(ccp(50, 0))
    icon:addChild(name[2])
    local t = ed.createLabelWithFontInfo(T("\231\173\137%s\228\186\186", #name), "normal_button")
    t:setAnchorPoint(ccp(0, 0.5))
    t:setPosition(ccp(50, -17))
    icon:addChild(t)
  end
  ed.ui.excavateinvite:setShareTarget(icon)
  class.exit()
end

function class.onListClick(index)
  local itemData = sharPanel.memberlist:getListData(index)
  if itemData.controllers.select_frame:isVisible() == false then
    itemData.controllers.select_frame:setVisible(true)
    targetMember[itemData.extraData.id] = itemData.extraData.name
  else
    itemData.controllers.select_frame:setVisible(false)
    targetMember[itemData.extraData.id] = nil
  end
  sharPanel.num:setString(string.format(T("%d\228\186\186"), getTargetsNum(targetMember)))
end

function class.shareToUnit()
  local content = shareData.content
  local excavateId = shareData.excavateId
  ed.ui.chat.sendExcavateDefendLink({
    content = content or "",
    excavateId = excavateId,
    callback = function(isSuccess)
      if isSuccess then
        ed.showToast(T("\233\147\190\230\142\165\229\183\178\230\136\144\229\138\159\229\143\145\233\128\129\232\135\179\229\133\172\228\188\154\230\137\128\230\156\137\228\186\186\231\154\132\229\174\157\232\151\143\229\136\134\228\186\171\233\162\145\233\129\147"))
        class.exit()
      else
        ed.showToast(T("\233\147\190\230\142\165\229\143\145\233\128\129\229\164\177\232\180\165"))
      end
    end
  })
end

local function resortTargetMemeber(data)
  local targets = {}
  for k, v in pairs(targetMember or {}) do
    table.insert(targets, k)
  end
  return targets
end

function class.shareToPrivate(param)
  if getTargetsNum(targetMember) == 0 then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\229\143\145\233\128\129\229\175\185\232\177\161"))
    return
  end
  local content = param.content
  local excavateId = param.excavateId
  local targets = resortTargetMemeber(targetMember)
  local devid = ed.getDeviceId()
  for i = 1, #targets do
    local key = string.format("%s-%s-inviteTimesOf%d", game_server_id, devid, targets[i])
    local times = ed.storage.getInt(key)
    if times == "" then
      times = 0
    end
    ed.storage.setValue(key, times + 1)
  end
  ed.ui.chat.sendExcavateDefendLink({
    content = content or "",
    excavateId = excavateId,
    channel = "personal_channel",
    targets = targets,
    callback = function(isSuccess)
      if isSuccess then
        ed.showToast(T("\233\147\190\230\142\165\229\183\178\230\136\144\229\138\159\229\143\145\233\128\129\232\135\179\229\175\185\230\150\185\231\154\132\229\174\157\232\151\143\229\136\134\228\186\171\233\162\145\233\129\147"))
        class.exit()
      else
        ed.showToast(T("\233\147\190\230\142\165\229\143\145\233\128\129\229\164\177\232\180\165"))
      end
    end
  })
end

function class.destoryData()
  targetMember = nil
end

local function sortTheMembers(data)
  if not data then
    return
  end
  local InviteTimes = {}
  local devid = ed.getDeviceId()
  for i = 1, #data do
    local target_uid = data[i]._uid
    local key = string.format("%s-%s-inviteTimesOf%d", game_server_id, devid, target_uid)
    local times = ed.storage.getInt(key)
    if times == "" then
      times = 0
    end
    InviteTimes[target_uid] = times
  end
  table.sort(data, function(a, b)
    return a._summary._level > b._summary._level
  end)
  table.sort(data, function(a, b)
    return InviteTimes[a._uid] > InviteTimes[b._uid]
  end)
end

local function initData()
  if not memberData then
    return
  end
  targetMember = targetMember or {}
  backMemberData = copyTab(targetMember)
  sortTheMembers(memberData._guild_member)
  for k = 1, #memberData._guild_member do
    local v = memberData._guild_member[k]
    if v._role_id ~= ed.getRoleId() then
      local param = {
        id = v._summary._avatar,
        scale = 0.6,
        vip = v._summary._vip > 0,
        level = v._summary._level,
        name = v._summary._name
      }
      local itemData = sharPanel.memberlist:addItem({param}, {
        id = v._role_id,
        name = v._summary._name
      })
    end
  end
  if getTargetsNum(targetMember) == 0 then
    for k, v in pairs(sharPanel.memberlist:getALLListData()) do
      targetMember[v.extraData.id] = v.extraData.name
    end
  end
  for k, v in pairs(sharPanel.memberlist:getALLListData()) do
    if targetMember[v.extraData.id] then
      v.controllers.select_frame:setVisible(true)
    end
  end
  memberNum = #memberData._guild_member - 1
  sharPanel.num:setString(string.format(T("%d\228\186\186"), getTargetsNum(targetMember)))
end

local function setMembersData(data)
  memberData = data
end

class.setData = setMembersData

function class.getTargetMember()
  return resortTargetMemeber(targetMember)
end

local function setLinkData(data)
  shareData = data
end

local function create(data)
  if nil == sharPanel then
    sharPanel = panelMeta:new2(class, EDTables.membershareConfig.UIRes)
  end
  if getRunScene() then
    getRunScene():addChild(sharPanel:getRootLayer(), 200)
  end
  setMembersData(data)
  initData()
end

class.create = create

function class.exit1()
  targetMember = copyTab(backMemberData)
  class.exit()
end

function class.exit()
  if nil == sharPanel then
    return
  end
  if getRunScene() then
    getRunScene():removeChild(sharPanel:getRootLayer(), true)
  end
  release()
end

local function sendMessage()
  local msg = ed.upmsg.guild()
  msg._guild_query_member = {}
  ed.send(msg, "guild")
end

function class.shareToMembers(data)
  setLinkData(data)
  sendMessage()
end

local function OnGuildRsp(data)
  if data._guild_members then
    create(data._guild_members)
  end
end

ListenEvent("GuildRsp", OnGuildRsp)
