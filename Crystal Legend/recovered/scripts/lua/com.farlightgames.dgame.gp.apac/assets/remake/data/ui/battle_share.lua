local class = {}
ed.battleshare = class
local oppoInformation, oppoNameData
local oppodynas = {}
local oppoheroes = {}
local battleResultInformation, playerInformation
local playerHeroes = {}
local playerHeroesDyna = {}
local warschoolInfo = {}
local bookReadingLevels = {}
local rseed, stage_id, replayName, showShareButton, shareSuccess, sharePanel, selectChannel

local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local function showShare()
  return showShareButton
end

class.showShare = showShare

local function clearShareButton()
  showShareButton = nil
end

class.clearShareButton = clearShareButton

local function setShareButton()
  showShareButton = true
end

class.setShareButton = setShareButton

local function setBattleMode(mode)
  battleResultInformation = {}
  battleResultInformation.msgName = mode
end

class.setBattleMode = setBattleMode

local function release()
  oppoInformation = nil
  oppoNameData = nil
  oppodynas = {}
  oppoheroes = {}
  battleResultInformation = nil
  playerInformation = nil
  playerHeroes = {}
  playerHeroesDyna = {}
  rseed = nil
  replayName = nil
  sharePanel = nil
  selectChannel = nil
  stage_id = nil
  showShareButton = nil
  warschoolInfo = nil
  bookReadingLevels = nil
end

class.release = release

local function setOppoHeroes(target, heroes)
  for k, v in pairs(heroes) do
    table.insert(target, v)
  end
end

local function checkTheChennal()
  if 1 == battleResultInformation.msgName then
    return "tbc"
  elseif 3 == battleResultInformation.msgName then
    return "real_pvp"
  elseif 4 == battleResultInformation.msgName then
    return "dreamland_pve"
  end
end

class.checkTheChennal = checkTheChennal

local function getOppoName(data)
  release()
  oppoNameData = data
end

class.getOppoName = getOppoName

local function sortDynaByHeros(dyna, heros)
  for k, v in pairs(heros) do
    if dyna[v._tid] then
      table.insert(oppodynas, dyna[v._tid])
    end
  end
end

local function getCrusadeOppoDyna(data)
  sortDynaByHeros(data, oppoheroes)
end

class.getCrusadeOppoDyna = getCrusadeOppoDyna

local function getExcavateOppoDyna(data)
  setOppoHeroes(oppodynas, data)
end

class.getExcavateOppoDyna = getExcavateOppoDyna

local function getRseed(data)
  rseed = data
end

class.getRseed = getRseed

local function setStageid(id)
  stage_id = id
end

class.setStageid = setStageid

local function getBattleData(data)
  battleResultInformation = data
end

class.getBattleData = getBattleData

local function setPlayerHeroes(playerInformation)
  if not playerInformation then
    return
  end
  for k, v in ipairs(playerInformation) do
    table.insert(playerHeroesDyna, v.crusadeData)
    table.insert(playerHeroes, v.data[".data"])
  end
end

local function getPlayerInfo(playerdata, oppodata)
  playerInformation = playerdata
  oppoInformation = oppodata
  setPlayerHeroes(playerInformation)
  setOppoHeroes(oppoheroes, oppoInformation)
  showShareButton = true
end

class.getPlayerInfo = getPlayerInfo

local function getWarschoolInfo(warschool)
  warschoolInfo = warschool
end

class.getWarschoolInfo = getWarschoolInfo

local function getBookReadingLevels(levels)
  bookReadingLevels = levels
end

class.getBookReadingLevels = getBookReadingLevels

local function returnOppoNameInfo()
  if not oppoNameData then
    return
  end
  if "tbc" == checkTheChennal() then
    return oppoNameData._summary._name, oppoNameData._summary._level, oppoNameData._summary._avatar, oppoNameData._summary._vip
  elseif "real_pvp" == checkTheChennal() then
    return oppoNameData._name
  end
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

class.copyTab = copyTab

local function setBinary()
  local msg = ed.upmsg.battle_record()
  msg._checkid = 1
  msg._userid = 1
  msg._username = ed.player:getName()
  msg._level = ed.player:getLevel()
  msg._avatar = ed.player:getAvatar()
  msg._vip = ed.player:getvip()
  msg._oppo_userid = 1
  msg._oppo_name, msg._oppo_level, msg._oppo_avatar, msg._oppo_vip = returnOppoNameInfo()
  msg._result = battleResultInformation.result
  msg._self_heroes = playerHeroes
  msg._self_dynas = playerHeroesDyna
  msg._oppo_heroes = oppoheroes
  msg._oppo_dynas = oppodynas
  msg._self_warschool_books = ed.player:initWarschoolUpData(warschoolInfo.selfschool)
  msg._oppo_warschool_books = ed.player:initWarschoolUpData(warschoolInfo.opposchool)
  msg._self_bookreading_level = (bookReadingLevels or {}).selfBookReadingLevel or 0
  msg._oppo_bookreading_level = (bookReadingLevels or {}).oppoBookReadingLevel or 0
  msg._rseed = rseed
  msg._param1 = stage_id
  msg._operations = battleResultInformation.oprations or {}
  msg._args = battleResultInformation.msgName
  msg._is_ladder_buff_open = false
  local code, err = msg:Serialize()
  local str = ed.upmsg.battle_record():Parse(code)
  return code
end

local function showReplay(data, stageid)
  if not data then
    return
  end
  if 1 == data._checkid then
    ed.showReplay(data, "tbc")
  end
end

class.showReplay = showReplay

local function exit()
  if nil == sharePanel then
    return
  end
  if sharePanel then
    getRunScene():removeChild(sharePanel:getRootLayer(), true)
    sharePanel = nil
  end
end

function class.shareToWorld()
  if ed.player:getLevel() < 24 then
    ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17624\231\186\167\230\137\141\232\131\189\229\156\168\228\184\150\231\149\140\233\162\145\233\129\147\229\136\134\228\186\171\230\136\152\230\150\151\229\189\149\229\131\143"))
    return
  end
  sharePanel.shareLayer.shareBg:setVisible(false)
  sharePanel.shareLayer.share:setVisible(true)
  selectChannel = "world_channel"
end

function class.shareToUnin()
  if ed.player:getGuildId() == 0 then
    ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
    return
  end
  sharePanel.shareLayer.shareBg:setVisible(false)
  sharePanel.shareLayer.share:setVisible(true)
  selectChannel = "guild_channel"
end

function class.cancelShare()
  exit()
end

function class.sendShare()
  if oppoInformation and battleResultInformation and playerInformation then
    local result, battledata
    if "tbc" == checkTheChennal() then
      result = string.format("<link|pvp|%s>", sharePanel.shareLayer.replayName:getString() .. T("(\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129)"))
    end
    local content = ""
    if content ~= "" then
      result = string.format("%s<><text|chat_content|%s|400>", result, content)
    end
    if "tbc" == checkTheChennal() then
      battledata = {}
      local data = {}
      data._hero_data = ed.engine:getHeroPvPBattleData()
      battledata[1] = data
    end
    ed.ui.chat.sendPvpLink(result, stage_id, selectChannel, setBinary(), "binary_replay", nil, battledata)
    shareSuccess = true
    exit()
  end
end

function class.closeShare()
  exit()
end

local function createTips()
  if "tbc" == checkTheChennal() then
    ed.setString(sharePanel.shareLayer.uititle, T("\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129\230\136\152\230\150\151\229\136\134\228\186\171"))
  elseif "real_pvp" == checkTheChennal() then
    ed.setString(sharePanel.shareLayer.uititle, T("\232\147\157\231\137\153\229\175\185\230\136\152\230\136\152\230\150\151\229\136\134\228\186\171"))
  end
end

local function create()
  if sharePanel == nil and getRunScene() then
    sharePanel = panelMeta:new2(class, EDTables.battleShareConfig.ShareUIRes)
    getRunScene():addChild(sharePanel:getRootLayer(), 200)
  else
    sharePanel:getRootLayer():setVisible(true)
  end
  sharePanel.shareLayer:setVisible(true)
  sharePanel.shareLayer.shareBg:setVisible(true)
  sharePanel.shareLayer.share:setVisible(false)
  replayName = string.format("[%s VS %s]", ed.player:getName(), returnOppoNameInfo() or "")
  ed.setString(sharePanel.shareLayer.replayName, replayName)
  createTips()
end

class.create = create

local function chatReply(data)
  if not shareSuccess then
    return
  end
  if data._say and data._say._result == "success" then
    ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
    shareSuccess = nil
  end
end

ListenEvent("ChatRsp", chatReply)
