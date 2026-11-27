local PlayerInfoNetwork = {}
PlayerInfoNetwork.__index = PlayerInfoNetwork
local PlayerInfoNetworkScope = {}

function PlayerInfoNetwork.create()
  local net = {}
  setmetatable(net, PlayerInfoNetwork)
  net:registerEvent()
  return net
end

function PlayerInfoNetwork:registerEvent()
  ListenEvent("player_info_reply", function(replyInfo)
    self:dispatch(replyInfo)
  end, PlayerInfoNetworkScope)
end

function PlayerInfoNetwork:openPanel()
  if ed.player:getLevel() < 32 then
    ed.showToast(T("\230\136\152\233\152\159\232\141\163\232\170\137\229\138\159\232\131\18932\231\186\167\232\167\163\233\148\129"))
    return
  end
  local msg = ed.upmsg.personal_home_page()
  msg._open_panel = ed.upmsg.php_open_panel()
  ed.send(msg, "personal_home_page")
end

function PlayerInfoNetwork:requestHomePage(roleId)
  local msg = ed.upmsg.personal_home_page()
  msg._req_home_page = ed.upmsg.php_req_home_page()
  msg._req_home_page._role_id = roleId
  ed.send(msg, "personal_home_page")
end

function PlayerInfoNetwork:requestHomePageSpecial(roleId)
  self.roleId = roleId
  local msg = ed.upmsg.personal_home_page()
  msg._req_home_page_specail = ed.upmsg.php_req_home_page_specail()
  msg._req_home_page_specail._php_req_home_page = ed.upmsg.php_req_home_page()
  msg._req_home_page_specail._php_req_home_page._role_id = roleId
  ed.send(msg, "personal_home_page")
end

function PlayerInfoNetwork:saveHonorWall(items)
  local msg = ed.upmsg.personal_home_page()
  msg._set_honor_wall = ed.upmsg.php_set_honor_wall()
  local wall = {}
  for _, item in pairs(items) do
    local wallItem = ed.commonmsg.honor_wall_item()
    if item.type == "avatar" then
      wallItem._type = "avatar"
      wallItem._id = ed.packAvatar(item.frameId, item.headId)
    elseif item.type == "hero" then
      wallItem._type = "hero_summary"
      wallItem._id = item.heroId
    elseif item.type == "medal" then
      wallItem._type = "medal"
      wallItem._id = item.medalId
    elseif item.type == "achievement" then
      wallItem._type = "pixel"
      wallItem._id = item.achievementId
    elseif item.type == "photo" then
      wallItem._type = "photo"
      wallItem._photo = ed.commonmsg.custom_photo()
      wallItem._photo._photo = item.photoId
      wallItem._photo._frame_id = item.frameId
    end
    wallItem._x = item.x
    wallItem._y = item.y
    table.insert(wall, wallItem)
  end
  msg._set_honor_wall._honor_wall = wall
  ed.send(msg, "personal_home_page")
end

function PlayerInfoNetwork:saveSign(sign)
  self.sign = sign
  local msg = ed.upmsg.personal_home_page()
  msg._set_signature = ed.upmsg.php_set_signature()
  msg._set_signature._signature = sign
  ed.send(msg, "personal_home_page")
end

function PlayerInfoNetwork:requestHeroData(roleId, heroId)
  local msg = ed.upmsg.personal_home_page()
  msg._req_hero = ed.upmsg.php_req_hero()
  msg._req_hero._role_id = roleId
  msg._req_hero._hero_id = heroId
  ed.send(msg, "personal_home_page")
end

function PlayerInfoNetwork:dispatch(replyInfo)
  if replyInfo._error_code then
    if replyInfo._error_code == "userid_not_found" then
      FireEvent("userid_not_found", {
        sid = self.sid,
        uid = self.uid
      })
    end
  elseif replyInfo._personal_home_page then
    EDLog("replyInfo._personal_home_page")
    local panel = ed.ui.PlayerInfoPanel.create(replyInfo._personal_home_page, true)
    panel:popWindow()
  elseif replyInfo._req_home_page then
    EDLog("replyInfo._req_home_page")
    FireEvent("req_home_page", replyInfo._req_home_page)
    local handler = ed.getNetReply("req_home_page")
    if handler then
      handler(replyInfo._req_home_page)
    end
  elseif replyInfo._set_honor_wall then
    EDLog("replyInfo._set_honor_wall")
    FireEvent("set_honor_wall", replyInfo._set_honor_wall)
  elseif replyInfo._set_signature then
    EDLog("replyInfo._set_signature")
    local result = replyInfo._set_signature
    if result == "success" then
      FireEvent("set_signature", self.sign)
    else
      EDLog("set_signature failed!!!")
    end
  elseif replyInfo._req_hero then
    EDLog("replyInfo._req_hero")
    FireEvent("req_hero_info", replyInfo._req_hero)
    local handler = ed.getNetReply("req_hero_info")
    if handler then
      handler(replyInfo._req_hero)
    end
  end
end

ed.PlayerInfoNetwork = PlayerInfoNetwork.create()
