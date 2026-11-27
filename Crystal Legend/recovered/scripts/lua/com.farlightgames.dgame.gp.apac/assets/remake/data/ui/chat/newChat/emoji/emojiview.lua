local View = {}
View.__index = View
ed.ChatView = ed.ChatView or {}
ed.ChatView.HeroesView = View
local CHANNELHEROES = "CHANNELHEROES"
local CHANNELEMOJI = "CHANNELEMOJI"
local heroes_formt_name_list = {}
local self_heroes_name_list = {}
local heroes_name_cache = false
local MAXHEROCUN = 5
local scope = {}
local emoji_view_instance

function View.Create()
  local obj = {}
  setmetatable(obj, View)
  obj:Init()
  return obj
end

function View:Destroy()
  ed.ui.chatContext.Locked(false)
  ed.ui.chatServerContext.Locked(false)
  CloseScope(scope)
  self.container:removeFromParentAndCleanup(true)
  emoji_view_instance = nil
end

function View:Init()
  self:InitData()
  self:SetDelegate()
  self:ChangeDelegate(CHANNELEMOJI)
  self:InitApperance()
  self:ChangeChannel(CHANNELEMOJI)
  self:RegisterEvent()
  if ed.ui.chatMain.getInstace():getCurChannel() == "chatServer" then
    self.ui.heroes_button:setVisible(false)
  end
end

function View:InitData()
  self.dlgt = {}
  self.emoji_dlgt = {}
  self.heroes_dlgt = {}
  self.crt_channel = CHANNELHEROES
  self.cur_cnt = 0
end

function View:RegisterEvent()
  ListenEvent("close_chat_main_view", function()
    self:Destroy()
  end, scope)
end

function View:InitApperance()
  self:setContainer()
  self:CreateUI()
  self:CreateTableView()
end

function View:setContainer(ctner)
  local chatInstance = ed.ui.chatMain.getInstace()
  self.prt = chatInstance.mainLayer
end

function View:CreateUI()
  local ui_res = ed.uieditor.emojiView
  local cnt, ui = ed.editorui(ui_res)
  _, self.ui = cnt, ui
  cnt:setTouchEnabled(true)
  local ftn = ed.ui.basetouchnode.btCreate()
  cnt:registerScriptTouchHandler(ftn:btGetMainTouchHandler(), false, -506, false)
  self.prt:addChild(cnt, 500)
  self.container = cnt
  ftn:btRegisterButtonClick({
    button = ui.emoji_button,
    press = ui.emoji_button_press,
    key = "emoji_button",
    clickHandler = function()
      self:ChangeChannel(CHANNELEMOJI)
    end
  })
  ftn:btRegisterButtonClick({
    button = ui.heroes_button,
    press = ui.heroes_button_press,
    key = "heroes_button",
    clickHandler = function()
      self:ChangeChannel(CHANNELHEROES)
    end
  })
end

function View:CreateTableView()
  local param = {
    delegate = self.dlgt,
    container = self.ui.bg,
    cliprect = CCRectMake(60, 15, 375, 205),
    dragMode = 1,
    colNum = 5,
    zorder = 50,
    touchpriority = -507
  }
  self.tb_view = Tableview.create(param)
end

function View:ChangeDelegate(chnl)
  if chnl == CHANNELEMOJI then
    self.crt_channel = chnl
    self.dlgt = self.emoji_dlgt
  elseif chnl == CHANNELHEROES then
    self.crt_channel = chnl
    self.dlgt = self.heroes_dlgt
  else
    EDDebug(chnl .. " is not allowed")
  end
end

function View:ChangeChannel(chnl)
  local is_emoji = chnl == CHANNELEMOJI
  local is_hero = chnl == CHANNELHEROES
  self.ui.emoji_button_press:setVisible(is_emoji)
  self.ui.heroes_button_press:setVisible(is_hero)
  if self.crt_channel == chnl then
    return
  end
  self:ChangeDelegate(chnl)
  self.tb_view:setDelegate(self.dlgt)
  self.tb_view:reloadData()
end

function View:SetDelegate()
  self:SetEmojiDelegate()
  self:SetHeroesDelegate()
end

function View:SetEmojiDelegate()
  local dlgt = self.emoji_dlgt
  
  local function getEmoji()
    local data = ed.getDataTable("ChatEmoji")
    local rst = {}
    for _, row in ipairs(data) do
      rst[#rst + 1] = {
        id = row["Emoji ID"],
        res = row["Emoji Cha"]
      }
    end
    return rst
  end
  
  local data = getEmoji()
  
  function dlgt.numberOfCells()
    return #data
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(75, 75)
  end
  
  function dlgt.createCell(idx)
    local data = data[idx].res
    local item = ed.createSprite(data)
    local size = item:getContentSize()
    item:setScale(65 / size.width)
    return item
  end
  
  function dlgt.syncCell(cell, idx)
    local data = data[idx].res
    local item = ed.createSprite(data)
    local size = item:getContentSize()
    item:setScale(60 / size.width)
    return item
  end
  
  function dlgt.doClickIn(cell)
    local idx = cell.idx
    self:SendEmoji(data[idx].id)
  end
end

function View:SetHeroesDelegate()
  local dlgt = self.heroes_dlgt
  
  local function getHeroes()
    local tb = {}
    for k, v in pairs(ed.player.heroes) do
      tb[#tb + 1] = v
    end
    return tb
  end
  
  local heroes = getHeroes()
  
  function dlgt.numberOfCells()
    return #heroes
  end
  
  function dlgt.cellSizeFromIndex(idx)
    return CCSizeMake(75, 75)
  end
  
  function dlgt.createCell(idx)
    local data = heroes[idx]
    local hicon = ed.readhero.createIconByHero(data, {length = 65})
    return hicon.icon
  end
  
  function dlgt.syncCell(cell, idx)
    local data = heroes[idx]
    local hicon = ed.readhero.createIconByHero(data, {length = 60})
    return hicon.icon
  end
  
  function dlgt.doClickIn(cell)
    local idx = cell.idx
    local data = heroes[idx]
    self:SendHero(data)
  end
end

function View:getCurEdit()
  local chatInstance = ed.ui.chatMain.getInstace()
  local chatedit = chatInstance.chatSendMsgLogic
  local edit = chatedit:getEditBox()
  return edit
end

function View.formtCache()
  if not heroes_name_cache then
    local data = ed.getDataTable("Unit")
    for k, row in pairs(data) do
      if k ~= "name" then
        local dsnm = row["Display Name"]
        local name = row.Name
        local id = row.ID
        local param = {hid = id, name = name}
        if ed.player.heroes[id] then
          self_heroes_name_list[name] = param
        end
        heroes_formt_name_list[name] = dsnm
      end
    end
    heroes_name_cache = true
  end
  for k, v in pairs(ed.player.heroes) do
    local row = ed.getDataTable("Unit")[v._tid]
    local name = row.Name
    local id = row.ID
    local param = {hid = id, name = name}
    if not self_heroes_name_list[name] then
      self_heroes_name_list[name] = param
    end
  end
end

function View:SendEmoji(id)
  local instance = ed.ui.chatMain.getInstace()
  local sendMsg = instance.chatSendMsgLogic
  
  local function send_func()
    local channel = instance:getCurChannel()
    channel = ed.ui.chatMain.chatMode[channel]
    str = T("<emoji|%s|0.6>", id)
    local tb = ed.curChatRoomTarget or {}
    local tg = ed.curPrivateTarget or {}
    local data = {
      roomtype = tb.type,
      roomid = tb.id,
      roleId = tg.roleId
    }
    ed.ui.chat.sendMessage(str, 1, nil, channel, nil, data)
    FireEvent("close_chat_main_view")
  end
  
  if not sendMsg:CanSend(true, send_func) then
    return
  end
  send_func()
end

function View:SendHero(hero)
  View.formtCache()
  local instance = ed.ui.chatMain.getInstace()
  local sendMsg = instance.chatSendMsgLogic
  
  local function send_func()
    local row = ed.lookupDataTable("Unit", hero._tid)
    local hname = row["Display Name"]
    local name = row.Name
    local str = T("<text|dark_white|\229\136\134\228\186\171\228\184\128\228\184\139\230\136\145\231\154\132\232\139\177\233\155\132:><link|herolink|%s|%d>", name, 1)
    local hero_id_list = {}
    local param = self_heroes_name_list[name]
    if param then
      hero_id_list[#hero_id_list + 1] = param.hid
    end
    local link_param = {
      svr = tonumber(real_game_server_id),
      uid = ed.getUserid(),
      heroesid = hero_id_list,
      allow = #hero_id_list <= MAXHEROCUN
    }
    local accessory = {
      _type = "heroes_link",
      _chat_hero_link = {
        _role_id = link_param.roleId,
        _heroids = link_param.heroesid
      }
    }
    sendMsg:sendMessage(str, 2, accessory)
    FireEvent("close_chat_main_view")
  end
  
  if not sendMsg:CanSend(true, send_func) then
    return
  end
  send_func()
end

function View.FormatHeroName(content)
  View.formtCache()
  local dsnm = heroes_formt_name_list[content]
  if dsnm then
    content = dsnm
  end
  return content
end

ed.FormatHeroLinkName = View.FormatHeroName

function View:Open()
  if emoji_view_instance then
    emoji_view_instance:Destroy()
  else
    emoji_view_instance = View:Create()
    ed.ui.chatContext.Locked(true)
    ed.ui.chatServerContext.Locked(true)
  end
end

ListenEvent("destroy_emoji_view", function()
  if emoji_view_instance then
    emoji_view_instance:Destroy()
  end
end)
ListenEvent("open_emoji_view", function()
  ed.ChatView.HeroesView:Open()
end)
ListenEvent("chat_query_hero", function(data)
  if not data then
    return
  end
  if not ed.isOpenChat then
    return
  end
  local hero = ed.HeroCreate()
  hero:setup(data)
  local panel = HeroInfoPanel.create(hero)
  panel:popWindow()
end)
