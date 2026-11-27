local function getRunScene()
  return CCDirector:sharedDirector():getRunningScene()
end

local class = {}
ed.ui.redBag = class
local isJoinRedBagActivity = false
local shareSuccess
local scope = {}

function class.release()
  class.panel = nil
  isJoinRedBagActivity = false
end

function class.exit()
  if not class.panel then
    return
  end
  getRunScene():removeChild(class.panel:getRootLayer(), true)
  CloseScope(scope)
  class.release()
end

function class.outExit(index, event, x, y)
  if not class.panel.send:isVisible() and class.panel.record:isVisible() then
    class.exit()
  end
end

function class.initEditBox()
  local edit = class.panel.redBagLayer.input.edit
  edit:setPlaceHolder(T("\229\143\145\231\186\162\229\140\133\229\149\166\239\188\129\229\133\136\229\136\176\229\133\136\229\190\151\229\147\166\239\188\129"))
end

function class.init()
  class.initEditBox()
end

function class:create(id)
  if not class.panel then
    class.panel = panelMeta:new2(class, EDTables.readBagConfig.UIRes)
    getRunScene():addChild(class.panel:getRootLayer(), 500)
    class.redBagId = id
    class:init()
  end
end

function class.sendShare()
  if ed.player:getGuildId() == 0 then
    ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
    return
  end
  local result = "<link|redBag|\227\128\144\229\143\145\231\186\162\229\140\133\229\149\166\239\188\129\229\133\136\229\136\176\229\133\136\229\190\151\229\147\166\239\188\129\227\128\145>"
  local content = class.panel.redBagLayer.input:getString()
  if content ~= "" then
    if string.len(content) > 48 then
      ed.showToast(T("\232\190\147\229\133\165\229\134\133\229\174\185\228\184\141\232\131\189\229\164\154\228\186\14216\228\184\170\230\177\137\229\173\151!"))
      return
    end
    if string.len(content) < 6 then
      ed.showToast(T("\232\190\147\229\133\165\229\134\133\229\174\185\228\184\141\232\131\189\229\176\143\228\186\1422\228\184\170\230\177\137\229\173\151!"))
      return
    end
    result = string.format("<link|redBag|\227\128\144%s\227\128\145>", content)
  end
  ed.ui.chat.sendPvpLink(result, 0, "guild_channel", class.redBagId, "red_envelope")
  shareSuccess = true
  class.exit()
end

function class.recordExit()
  if not class.panel then
    return
  end
  getRunScene():removeChild(class.panel:getRootLayer(), true)
  class.panel = nil
end

function class.initRecord(data)
  local data = data or {}
  for k, v in pairs(data) do
    local param = {
      id = v._user_summary._avatar,
      level = v._user_summary._level,
      vip = v._user_summary._vip
    }
    local head = ed.getTeamHead(param)
    head:setPosition(ccp(27, 27))
    local name = v._user_summary._name
    local str = T("<text|normal_black|\232\142\183\229\190\151\228\186\134><text|normal_red|%s><sprite|UI/alpha/1080P/common/rmbicon.png|0.5>", tostring(v._amount))
    class.panel.recordList:addItem({
      head,
      name,
      str
    }, {})
  end
end

function class.recordCreate(data)
  if not class.panel then
    class.panel = panelMeta:new2(class, EDTables.readBagConfig.recordUIRes)
    getRunScene():addChild(class.panel:getRootLayer(), 500)
    class.initRecord(data)
  end
end

function class.clearIsJoinRedBagActivity()
  isJoinRedBagActivity = false
end

function class.setIsJoinRedBagActivity()
  isJoinRedBagActivity = true
end

function class.isJoinRedBagActivity()
  return isJoinRedBagActivity
end

function class.joinAct()
  class.exit()
  ed.activity.NetworkMgr.openPanle()
  class.setIsJoinRedBagActivity()
  ed.ui.chatMain.getInstace():pushWindow()
end

function class.showRecord()
  local data = class.data or {}
  class.exit()
  class.recordCreate(data._record)
end

function class.createLightFca(light)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
end

function class.registerUpdate()
  local function handler(dt)
    xpcall(function()
      if not tolua.isnull(class.diemondFca) then
        class.diemondFca:update(dt)
      end
      if not tolua.isnull(class.redBagFca) then
        class.redBagFca:update(dt)
      end
    end, EDDebug)
  end
  
  return handler
end

function class.createDiemond()
  local panel = class.panel
  class.diemondFca = ed.createFcaActor("eff_UI_Treasure_diamond")
  class.diemondFca:setAction("Start")
  class.diemondFca:setPosition(ccp(400, 200))
  panel:getRootLayer():addChild(class.diemondFca, 200)
  panel.bluelight:setVisible(true)
  class.createLightFca(panel.bluelight)
end

function class.createOpenRedBag()
  local panel = class.panel
  panel.send:setVisible(true)
  panel.send:setPosition(ccp(500, 120))
  panel.record:setVisible(true)
  panel.record:setPosition(ccp(300, 120))
  panel.content:setVisible(true)
  local data = class.findSelfInRecord(class.data._record or {})
  local str = T("<text|op_act_title|\230\129\173\229\150\156\228\189\160\230\138\162\229\136\176><text|normal_button|%s ><sprite|UI/alpha/1080P/common/rmbicon.png|0.5 >", tostring(data._amount or 0))
  panel.content:setString(str)
  ed.player:addrmb(data._amount or 0)
end

function class.showResult()
  local function handler()
    class.createOpenRedBag()
    
    class:createDiemond()
  end
  
  return handler
end

function class.hideContract()
  class.panel.light:setVisible(false)
  class.panel.title:setVisible(false)
end

function class.movebag(position)
  local act1 = CCScaleTo:create(0.3, 0.3)
  local act2 = CCMoveTo:create(0.3, position)
  act2 = CCSpawn:create(ccArrayMake(act1, act2))
  class.panel.redbag_open:runAction(act2)
end

function class.openbag()
  local data = class.data or {}
  if 0 == data._is_get_now then
    return
  end
  ed.playEffect(ed.sound.battle.clickLoot)
  local panel = class.panel
  local bagOpen = panel.redbag
  if tolua.isnull(bagOpen) then
    return
  end
  if not bagOpen:isVisible() then
    return
  end
  bagOpen:setVisible(false)
  class.redBagFca = ed.createFcaActor("eff_UI_red_package")
  class.redBagFca:setAction("Start")
  class.redBagFca:setPosition(ccp(400, 200))
  panel:getRootLayer():addChild(class.redBagFca, 280)
  class.hideContract()
  ListenTimer(Timer:Once(1.3), class:showResult())
end

function class.createSealRedBag()
  local light = class.panel.light
  if not tolua.isnull(light) then
    class.createLightFca(light)
  end
end

function class.findSelfInRecord(data)
  for k, v in pairs(data or {}) do
    if v._uid == ed.getUserid() then
      return v
    end
  end
end

function class.createOpenedRedBag(data)
  local panel = class.panel
  if class.findSelfInRecord(data._record) then
    panel.title:setString("\228\189\160\229\183\178\231\187\143\233\162\134\229\136\176\232\175\165\231\186\162\229\140\133\229\149\166\239\188\129")
    panel.redbag:setVisible(false)
    panel.redbag_open:setVisible(true)
  else
    panel.title:setString("\228\189\160\230\157\165\230\153\154\228\186\134\239\188\140\231\186\162\229\140\133\229\183\178\231\187\143\229\143\145\229\174\140\228\186\134\239\188\129")
  end
  panel.light:setVisible(false)
  panel.record:setVisible(true)
  panel.send:setVisible(false)
  panel.record:setPosition(ccp(400, 100))
end

function class.initRedBagUI(data)
  local data = data or {}
  class.panel.record:setVisible(false)
  class.panel.send:setVisible(false)
  if 0 ~= data._is_get_now then
    class.createSealRedBag()
  else
    class.createOpenedRedBag(data)
  end
end

function class.initRedBag(data)
  class.initRedBagUI(data)
end

function class.redBagCreate(data)
  if not class.panel then
    class.panel = panelMeta:new2(class, EDTables.readBagConfig.newRedBagUIRes)
    getRunScene():addChild(class.panel:getRootLayer(), 200)
    class.initRedBag(data)
    ListenTimer(Timer:Always(0.01), class.registerUpdate(), scope)
  end
end

function class.requestRedBagError(data)
  if data._err_code then
    local error = data._err_code
    if error == "not_in_activity_time" then
      ed.showToast(T("\228\184\141\229\156\168\230\180\187\229\138\168\230\151\182\233\151\180\229\134\133"))
    elseif error == "invalid_redenvelope" then
      ed.showToast(T("\233\157\158\230\179\149\231\154\132\231\186\162\229\140\133"))
    elseif error == "redenvelope_count_limit" then
      ed.showToast(T("\228\189\160\229\143\175\228\187\165\233\162\134\229\143\150\231\154\132\231\186\162\229\140\133\229\183\178\232\190\190\229\136\176\228\184\138\233\153\144"))
    end
    return true
  end
end

function class.requestRedBagSuccess(data)
  if data._redenvelope_open_reply then
    class.data = data._redenvelope_open_reply
    if class.data._flag and class.data._flag == 1 then
      class.recordCreate(class.data._record)
    else
      class.redBagCreate(class.data)
    end
  end
end

local function requestRedBagReply(data)
  if class.requestRedBagError(data) then
    return
  end
  class.requestRedBagSuccess(data)
end

function class.requestRedBagInfo(id, flag)
  local msg = ed.upmsg.redenvelope()
  msg._open_panel = {}
  msg._open_panel._red_id = id
  msg._open_panel._flag = flag or 0
  ed.send(msg, "redenvelope")
end

function class.openLink(data)
  if not data then
    return
  end
  class.data = data
  class.requestRedBagInfo(data._red_id)
end

local function chatReply(data)
  if data._say then
    if not shareSuccess then
      return
    end
    if data._say._result == "success" then
      ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
      shareSuccess = nil
    end
  elseif data._fetch then
    local data = data._fetch._accessory or {}
    if data._type and data._type == "red_envelope" then
      class.openLink(data._red_envelope)
    elseif ed.superlink_current_type == "redBag" then
      ed.showToast(T("\228\189\160\230\151\160\230\179\149\230\159\165\231\156\139\233\157\158\230\156\172\229\133\172\228\188\154\230\136\144\229\145\152\231\154\132\231\186\162\229\140\133"))
    end
  end
end

ListenEvent("ChatRsp", chatReply)
