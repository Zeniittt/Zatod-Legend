local base = ed.ui.popwindow
local authenticationMainPop = {}
authenticationMainPop.__index = authenticationMainPop
setmetatable(authenticationMainPop, base.mt)
ed.ui.authenticationMainPop = authenticationMainPop

function authenticationMainPop.create(params)
  local self = base.create("authenticationMainPop")
  setmetatable(self, authenticationMainPop)
  self:initData(params)
  self:initUI()
  self:registerTouchHandlers()
  self:registerListener()
  return self
end

function authenticationMainPop:initData()
  self.editbox_scope = {}
  self.sideCellUI = {}
  self.authConfirmScope = {}
end

function authenticationMainPop:initUI()
  local container, ui = ed.editorui(ed.uieditor.authenticationMainPop)
  self.ui = ui
  self.container:addChild(container)
  local winSize = ed.display.winSize
  container:setPosition(ccp(480, 260))
  local rectSize = self.ui.block_list_layer:getContentSize()
  self.ui.block_list_layer:setClipRect(CCRectMake(0, 0, rectSize.width + 10, rectSize.height))
  self:initMain()
  self:initEditBox()
  self:initSelect()
  self:initServer()
end

function authenticationMainPop:initMain()
  self.mode = "main"
  self:setTitle(T("\232\174\164\232\175\129\230\180\187\229\138\168"))
  local text = T("\233\152\159\233\149\191\229\143\175\228\187\165\233\128\154\232\191\135\229\161\171\229\134\153Soulhunter\231\154\132<lable color=ccc3(255,239,130)>\230\156\141\229\138\161\229\153\168\227\128\129\231\148\168\230\136\183ID\227\128\129\230\152\181\231\167\176</lable>\239\188\140\230\136\145\228\187\172\229\176\134\228\188\154\233\128\154\232\191\135<lable color=ccc3(255,239,130)>\233\130\174\228\187\182</lable>\231\154\132\230\150\185\229\188\143\231\187\153\233\152\159\233\149\191\229\161\171\229\134\153\231\154\132\232\180\166\229\143\183\229\143\145\233\128\129\228\184\128\229\176\129\233\130\174\228\187\182\227\128\130") .. T("\229\133\182\228\184\173\229\140\133\229\144\171<lable color=ccc3(255,170,69)>Authentication Code</lable>\227\128\130<br/>") .. T("\229\156\168\229\143\179\228\184\139\232\167\146\231\154\132\230\140\137\233\146\174\228\184\173\229\161\171\229\134\153\228\189\160\230\137\128\232\142\183\229\143\150\231\154\132<lable color=ccc3(255,170,69)>Authentication Code</lable>\239\188\140\229\136\153\229\143\175\228\187\165\232\142\183\229\190\151\232\174\164\232\175\129\229\165\150\229\138\177\227\128\130<br/><br/>") .. T("\232\175\183\230\179\168\230\132\143\239\188\129\232\139\165\230\130\168\228\189\191\231\148\168\229\189\147\229\137\141\232\167\146\232\137\178\229\143\145\233\128\129\232\174\164\232\175\129\232\175\183\230\177\130\239\188\140\228\185\159\229\191\133\233\161\187\228\189\191\231\148\168\232\175\165\232\167\146\232\137\178\232\191\155\232\161\140\229\161\171\229\134\153\232\174\164\232\175\129\231\160\129\232\142\183\229\143\150\229\165\150\229\138\177\227\128\130\230\130\168\230\156\172\232\180\166\229\143\183<lable color=ccc3(255,239,130)>\229\143\170\229\143\175\228\187\165\232\142\183\229\143\150\228\184\128\230\172\161\232\174\164\232\175\129\229\165\150\229\138\177</lable>\227\128\130\230\130\168\230\137\128\230\143\144\228\190\155\232\174\164\232\175\129\231\154\132\232\180\166\229\143\183\228\185\159<lable color=ccc3(255,239,130)>\229\143\170\229\143\175\228\187\165\230\143\144\228\190\155\228\184\128\230\172\161\232\174\164\232\175\129\229\165\150\229\138\177</lable>\239\188\129")
  local atText = ed.ui.autoText.new()
  local containerSize = self.ui.layer_text:getContentSize()
  atText:initParam({
    context = text,
    color = ed.toccc3(16776423),
    maxWidth = containerSize.width,
    fontSize = 14
  })
  local wid, hei = atText:getContentSize()
  local draglist = ed.UITool.createDraglist(self.ui.layer_text, {})
  draglist:addItem(atText.node)
  atText.node:setPosition(ccp(0, containerSize.height - 10))
  draglist:initListHeight(hei)
end

function authenticationMainPop:initEditBox()
  local info = {
    config = {
      editSize = self.ui.userid_input:getContentSize(),
      maxLength = 20,
      fontColor = ccc3(255, 252, 231),
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setPlaceHolder("")
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  self.ui.userid_input:addChild(edit_box.edit)
  self.ui.userid_input:setClipRect(CCRectMake(0, 0, info.config.editSize.width, info.config.editSize.height))
  edit_box.edit:setVisible(false)
  self.userid_editbox = edit_box
  local info1 = {
    config = {
      editSize = self.ui.code_input:getContentSize(),
      maxLength = 20,
      fontColor = ccc3(255, 252, 231),
      fontSize = 20
    }
  }
  edit_box = editBox:new(info1)
  edit_box:setPlaceHolder("")
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  self.ui.code_input:addChild(edit_box.edit)
  self.ui.code_input:setClipRect(CCRectMake(0, 0, info1.config.editSize.width, info1.config.editSize.height))
  edit_box.edit:setVisible(false)
  self.code_editbox = edit_box
end

function authenticationMainPop:initSelect()
  local sideDelegate = {
    numberOfCells = function()
      return math.ceil(#(self.serverList or {}) / 10)
    end,
    cellSizeFromIndex = function(index)
      return CCSizeMake(148.5, 33)
    end,
    createCell = function(index)
      local num = #self.serverList
      local totalInd = math.ceil(num / 10)
      local min = (totalInd - index) * 10 + 1
      local max = math.min(min + 9, num)
      local container, ui = self:createSideServerItem(min, max)
      ui.bg:setVisible(self.serverSideIndex == index)
      self.sideCellUI[index] = {
        info = {
          min = min,
          max = max,
          index = index
        },
        ui = ui
      }
      return container, index
    end,
    doPressIn = function(cell, x, y)
      return cell
    end,
    doClickIn = function(cell, x, y)
      self.serverSideIndex = cell.data
      self:refreshServerList()
    end
  }
  local sideSize = self.ui.side_list_layer:getContentSize()
  local sideParam = {
    delegate = sideDelegate,
    cliprect = CCRectMake(0, 0, sideSize.width, sideSize.height),
    container = self.ui.side_list_layer,
    touchpriority = -300,
    zorder = 10,
    dragMode = 1,
    noshade = true,
    colNum = 1
  }
  self.sideTblView = Tableview.create(sideParam)
end

function authenticationMainPop:initServer()
  self:updateSendCodeBtn()
  self:listenTimer(Timer:Always(1), function()
    self:updateSendCodeBtn()
  end)
end

function authenticationMainPop:updateSendCodeBtn()
  local canSendCode = ed.authenticationMgr.nextSendCodeTime < ed.getServerTime()
  self.ui.btn_GetAuthentication:setVisible(canSendCode)
  self.ui.btn_timeLimit:setVisible(not canSendCode)
  if not canSendCode then
    local diff = ed.authenticationMgr.nextSendCodeTime - ed.getServerTime()
    ed.setLabelString(self.ui.label_timeLimit, T("%s\229\144\142\229\143\175\229\134\141\230\172\161\229\143\145\233\128\129", ed.time2dhms(diff)))
  end
end

function authenticationMainPop:createSideServerItem(min, max)
  local node = CCNode:create()
  node:setContentSize(CCSizeMake(148.5, 33))
  local bg = ed.createSprite("UI/alpha/1080P/common/global/authentication/server_write.png")
  local cutoff = ed.createSprite("UI/alpha/1080P/common/global/authentication/cut_off.png")
  bg:setAnchorPoint(ccp(0, 0))
  node:addChild(bg)
  bg:setVisible(false)
  cutoff:setAnchorPoint(ccp(0.5, 0.5))
  cutoff:setPosition(ccp(74.25, 0))
  node:addChild(cutoff)
  local label = ed.createLabelTTF(T("%s--%s\229\140\186", min, max), 16)
  ed.setLabelColor(label, ed.toccc3(16755269))
  node:addChild(label)
  label:setPosition(ccp(74.25, 16.5))
  local ui = {
    container = node,
    bg = bg,
    cutoff = cutoff,
    label = label
  }
  return node, ui
end

function authenticationMainPop:showMain()
  self.mode = "main"
  self:setTitle(T("\232\174\164\232\175\129\230\180\187\229\138\168"))
  self.ui.layer_main:setVisible(true)
end

function authenticationMainPop:showServer(mode)
  self.mode = "server"
  if mode then
    self.serverMode = mode == "Soulhunter" and "SH" or "TW"
    self.modeName = mode
    local lastId = ed.authenticationMgr.lastId
    self.userid_editbox:setString(ed.authenticationMgr.lastZone == self.serverMode and lastId or "")
    ListenTimer(Timer:Always(0.1), function()
      local str = self.userid_editbox:getString()
      local color = str == "" and ed.toccc3(8815735) or ed.toccc3(16772992)
      ed.setLabelString(self.ui.userid_text, str == "" and T("\229\161\171\229\134\153\228\189\160\231\154\132userid") or str)
      ed.setLabelColor(self.ui.userid_text, color)
    end, self.editbox_scope)
  end
  local lastServer = ed.authenticationMgr.lastServer
  local setServerConf = lastServer and ed.authenticationMgr.lastZone == self.serverMode
  ed.setLabelString(self.ui.server_name, setServerConf and string.format("%s %s", lastServer._server_display_id, lastServer._server_name) or T("\233\128\137\230\139\169\230\156\141\229\138\161\229\153\168"))
  ed.setLabelColor(self.ui.server_name, setServerConf and ed.toccc3(16772992) or ed.toccc3(8815735))
  self:setTitle(T("%s\232\174\164\232\175\129", self.modeName))
  self.ui.layer_server:setVisible(true)
end

function authenticationMainPop:showCode()
  if self.mode ~= "confirm" then
    self.code_editbox:setString("")
  end
  self.mode = "code"
  self:setTitle("Authentication Code")
  self.ui.layer_code:setVisible(true)
  self.ui.btn_confirm:setVisible(true)
  self.ui.code_bg:setVisible(true)
  self.ui.layer_confirm:setVisible(false)
  ListenTimer(Timer:Always(0.1), function()
    local str = self.code_editbox:getString()
    local color = str == "" and ed.toccc3(8815735) or ed.toccc3(16772992)
    ed.setLabelString(self.ui.code_text, str == "" and T("\229\161\171\229\134\153\228\189\160\231\154\132Authentication Code") or str)
    ed.setLabelColor(self.ui.code_text, color)
  end, self.editbox_scope)
end

function authenticationMainPop:showSelect()
  self.mode = "select"
  self:setTitle(T("server\233\128\137\230\139\169"))
  self.ui.layer_select:setVisible(true)
  self.sideCellUI = {}
  self.sideTblView:reloadData()
  self.serverSideIndex = 1
  self:refreshServerList()
end

function authenticationMainPop:refreshServerList()
  if self.lastServerSideIndex and self.sideCellUI[self.lastServerSideIndex] and not tolua.isnull(self.sideCellUI[self.lastServerSideIndex].ui.bg) then
    self.sideCellUI[self.lastServerSideIndex].ui.bg:setVisible(false)
  end
  self.lastServerSideIndex = self.serverSideIndex
  local serverBlock = self.sideCellUI[self.serverSideIndex]
  local ui = serverBlock.ui
  local info = serverBlock.info
  ui.bg:setVisible(true)
  ed.setLabelString(self.ui.label_server_block, T("\230\156\141\229\138\161\229\153\168%s--%s\229\140\186", info.min, info.max))
  for i = 1, 10 do
    local serverIndex = info.min + i - 1
    local isValid = serverIndex <= info.max
    if isValid then
      local serverTblInfo = self.serverList[serverIndex]
      ed.setLabelString(self.ui["server_name" .. i], string.format("%s %s", serverIndex, serverTblInfo._server_name))
      self.ui["server_name" .. i]:setFontSize(self.serverMode == "SH" and 14 or 16)
    end
    if self.ui["cutoff" .. i - 2] then
      self.ui["cutoff" .. i - 2]:setVisible(isValid)
    end
    if self.ui["server_name" .. i] then
      self.ui["server_name" .. i]:setVisible(isValid)
    end
  end
end

function authenticationMainPop:showAuthConfirm(data)
  self.mode = "confirm"
  local text = T("\231\161\174\232\174\164\233\162\134\229\143\150\230\130\168\231\154\132\232\174\164\232\175\129\231\166\143\229\136\169\229\136\176\232\175\165\232\180\166\229\143\183<lable color=ccc3(255,239,130)>%s</lable>\231\154\132\232\175\165\232\167\146\232\137\178<lable color=ccc3(255,239,130)>%s</lable>\228\184\139\239\188\140\233\162\134\229\143\150\229\174\140\230\175\149\229\144\142\239\188\140\229\176\134\232\167\134\228\184\186\230\130\168\230\143\144\228\190\155\232\174\164\232\175\129\231\154\132\232\128\129\232\180\166\229\143\183\228\184\142\232\175\165\232\180\166\229\143\183\229\183\178\229\143\130\228\184\142\232\191\135\230\180\187\229\138\168\227\128\130", data._self_app_uid or 0, data._self_role_id or 0) .. T("\229\144\142\231\187\173\230\130\168\230\143\144\228\190\155\232\174\164\232\175\129\231\154\132\232\128\129\232\180\166\229\143\183\228\184\142\232\175\165\232\180\166\229\143\183<lable color=ccc3(255,239,130)>\230\151\160\230\179\149\229\134\141\230\172\161\229\143\130\228\184\142\232\175\165\230\180\187\229\138\168</lable>\233\162\134\229\143\150\232\174\164\232\175\129\231\166\143\229\136\169\227\128\130")
  local atText = ed.ui.autoText.new()
  local containerSize = self.ui.layer_auth_confirm_tip:getContentSize()
  atText:initParam({
    context = text,
    color = ed.toccc3(16776423),
    maxWidth = containerSize.width,
    fontSize = 14
  })
  local wid, hei = atText:getContentSize()
  local draglist = ed.UITool.createDraglist(self.ui.layer_auth_confirm_tip, {})
  draglist:addItem(atText.node)
  atText.node:setPosition(ccp(0, containerSize.height - 10))
  draglist:initListHeight(hei)
  local serverInfo = data._server_info or {}
  ed.setLabelString(self.ui.label_auth_server, string.format("%s %s", serverInfo._server_display_id or 0, serverInfo._server_name or ""))
  ed.setLabelString(self.ui.label_auth_id, data._user_id or 0)
  ed.setLabelString(self.ui.label_auth_name, data._nickname or 0)
  ed.setLabelString(self.ui.label_auth_confirm, "\231\161\174\232\174\164\230\151\160\232\175\175(5)")
  local cnt = 4
  ListenTimer(Timer:Times(1, 5), function()
    if 0 < cnt then
      ed.setLabelString(self.ui.label_auth_confirm, T("\231\161\174\232\174\164\230\151\160\232\175\175(%s)", cnt))
    else
      ed.setLabelString(self.ui.label_auth_confirm, T("\231\161\174\232\174\164\230\151\160\232\175\175"))
      self.canConfirm = true
    end
    cnt = cnt - 1
  end, self.authConfirmScope)
  self.ui.layer_auth_confirm:setVisible(true)
end

function authenticationMainPop:setTitle(string)
  ed.setLabelString(self.ui.title, string)
  ed.left2(self.ui.title_left, self.ui.title, 5)
  local length = (self.ui.title_right:getContentSize().width + self.ui.title:getContentSize().width) * 0.5 + 5
  self.ui.title_right:setPositionX(self.ui.title:getPositionX() + length)
  self.ui.title_bg:setVisible("main" ~= self.mode)
  self.ui.title_back:setVisible("main" ~= self.mode)
end

function authenticationMainPop:registerBtn(key, func, params)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    clickHandler = function(_, x, y)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.5
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function authenticationMainPop:close()
  CloseScope(self.editbox_scope)
  self:destroy()
end

function authenticationMainPop:registerTouchHandlers()
  self:registerBtn("btn_close", function()
    self:close()
  end, {pressScale = 0.7, normalScale = 0.75})
  self:registerBtn("title_back", function()
    if self.mode == "server" then
      self.ui.layer_server:setVisible(false)
      self.userid_editbox:setString("")
      ListenTimer(Timer:Once(0.1), function()
        CloseScope(self.editbox_scope)
      end)
      self:showMain()
    elseif self.mode == "code" then
      self.ui.layer_code:setVisible(false)
      self.code_editbox:setString("")
      ListenTimer(Timer:Once(0.1), function()
        CloseScope(self.editbox_scope)
      end)
      self:showMain()
    elseif self.mode == "select" then
      self.ui.layer_select:setVisible(false)
      self.serverSideIndex = nil
      self:showServer()
    elseif self.mode == "confirm" then
      self.ui.layer_auth_confirm:setVisible(false)
      CloseScope(self.authConfirmScope)
      self.canConfirm = nil
      self:showCode()
    end
  end, {pressScale = 0.95, normalScale = 1})
  self:registerBtn("btn_soulhunter", function()
    self.ui.layer_main:setVisible(false)
    self:showServer("Soulhunter")
  end, {pressScale = 0.7, normalScale = 0.75})
  self:registerBtn("btn_legend", function()
    self.ui.layer_main:setVisible(false)
    self:showServer(T("\229\176\143\229\134\176\229\134\176\229\130\179\229\165\135"))
  end, {pressScale = 0.7, normalScale = 0.75})
  self:registerBtn("btn_Authentication", function()
    self.ui.layer_main:setVisible(false)
    self:showCode()
  end, {pressScale = 0.95, normalScale = 1})
  self:btRegisterHandler({
    handler = function(event, x, y)
      self.userid_editbox:touch(event, x, y)
      self.code_editbox:touch(event, x, y)
    end,
    key = "editbox_register",
    priority = -100
  })
  self:registerBtn("server_bg", function()
    ed.authenticationNet:sendServerList(self.serverMode)
  end, {})
  for i = 1, 10 do
    self:registerBtn("server_name" .. i, function()
      local info = self.sideCellUI[self.serverSideIndex].info
      local serverIndex = info.min + i - 1
      local serverId = self.serverList[serverIndex]._server_id
      ed.authenticationNet:sendSelectServer(serverId)
    end, {})
  end
  self:registerBtn("btn_GetAuthentication", function()
    self:onClickSendCode()
  end, {
    normalScale = 1,
    pressScale = 0.95,
    clickInterval = 0.3
  })
  self:registerBtn("btn_confirm", function()
    self:onClickAuthCode()
  end, {
    normalScale = 1,
    pressScale = 0.95,
    clickInterval = 0.3
  })
  self:registerBtn("btn_auth_confirm", function()
    self:onClickAuthConfirm()
  end, {
    normalScale = 1,
    pressScale = 0.95,
    clickInterval = 0.3
  })
end

function authenticationMainPop:registerListener()
  self:listenEvent("PlayerShiftServerReply", self:handleServerList())
  self:listenEvent("PlayerShiftSelectServerReply", self:handleSelectServer())
  self:listenEvent("PlayerShiftAuthCodeReply", self:handleAuthCode())
  self:listenEvent("PlayerShiftGainRewardReply", self:handleGainReward())
end

function authenticationMainPop:handleServerList()
  local function handler(serverList)
    self.ui.layer_server:setVisible(false)
    
    self.serverList = serverList
    self:showSelect()
  end
  
  return handler
end

function authenticationMainPop:handleSelectServer()
  local function handler(serverInfo)
    ed.authenticationMgr.lastServer = serverInfo
    
    ed.authenticationMgr.lastZone = self.serverMode
    self.ui.layer_select:setVisible(false)
    self.serverSideIndex = nil
    self:showServer()
  end
  
  return handler
end

function authenticationMainPop:handleGetCode()
end

function authenticationMainPop:handleAuthCode()
  local function handler(data)
    if data._result ~= "success" then
      ed.showToast("\232\174\164\232\175\129\229\164\177\232\180\165\239\188\129")
      
      return
    end
    self.ui.layer_code:setVisible(false)
    self:showAuthConfirm(data)
  end
  
  return handler
end

function authenticationMainPop:handleGainReward()
  local function handler(data)
    if data._result == "success" then
      local rewards = data._rewards or {}
      
      ed.player:addRewards(rewards)
      ed.UITool.showRewardsFromServer(rewards)
      ed.showToast(T("\232\174\164\232\175\129\230\136\144\229\138\159"))
    else
      ed.showToast(T("\232\174\164\232\175\129\229\164\177\232\180\165"))
    end
    self:close()
  end
  
  return handler
end

function authenticationMainPop:onClickSendCode()
  if nil == ed.authenticationMgr.lastZone or ed.authenticationMgr.lastZone ~= self.serverMode then
    ed.showToast(T("\232\175\183\233\128\137\230\139\169\232\166\129\232\174\164\232\175\129\232\167\146\232\137\178\230\137\128\229\156\168\231\154\132\230\156\141\229\138\161\229\153\168"))
    return
  end
  if self.userid_editbox:getString() == "" then
    ed.showToast(T("\232\175\183\229\161\171\229\134\153\232\166\129\232\174\164\232\175\129\231\154\132\232\167\146\232\137\178ID"))
    return
  end
  local userId = self.userid_editbox:getString()
  if tonumber(userId) == nil then
    ed.showToast(T("\231\148\168\230\136\183id\228\184\141\232\167\132\232\140\131"))
    return
  end
  ed.ui.authenticationConfirmPop.create({
    status = "confirm",
    serverInfo = ed.authenticationMgr.lastServer,
    playerId = tonumber(userId),
    controller = self
  }):popWindow()
end

function authenticationMainPop:onClickAuthCode()
  if self.code_editbox:getString() == "" then
    ed.showToast(T("\232\175\183\229\161\171\229\134\153Authentication Code"))
    return
  end
  local authCode = self.code_editbox:getString()
  ed.authenticationNet:sendAuthCode(authCode)
end

function authenticationMainPop:onClickAuthConfirm()
  if self.canConfirm then
    ed.authenticationNet:sendGainReward()
  end
end
