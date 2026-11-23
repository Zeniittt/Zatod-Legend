local chatEmoji = newclass()

function chatEmoji.create(delegate)
  local self = {}
  setmetatable(self, chatEmoji.mt)
  self:init(delegate)
  return self
end

function chatEmoji:init(delegate)
  self:initData(delegate)
  self:initView()
  self:addEventListener()
end

function chatEmoji:initData(delegate)
  self.delegate = delegate
  self.ui = self.delegate.ui
  self.heroes_formt_name_list = {}
  self.self_heroes_name_list = {}
  self.heroes_name_cache = false
  self.MAXHEROCUN = 5
  self.btn_bg_origin = self.ui.btn_bg:getPositionY()
  self.btn_bg_offset = self.ui.btn_bg:getContentSize().height
  self:setEmojiOrHeroTab(ed.chatManager.EmojiTab.emoji)
  self.pxy = ccp(0, 0)
end

function chatEmoji:createTableView()
  self.tb_dlgt = self:setEmojiOrHeroDelegate()
  local list = self.ui.emoji_hero_list
  local param = {
    delegate = self.tb_dlgt,
    container = list,
    cliprect = CCRectMake(0, 0, list:getContentSize().width, list:getContentSize().height),
    dragMode = 1,
    colNum = 5,
    touchpriority = -301,
    noshade = true,
    offset = {10, 0}
  }
  self.tableview = Tableview.create(param)
  self.tableview.dragList:setTouchEnabled(false)
end

function chatEmoji:reloadTableView()
  self.tb_dlgt = self:setEmojiOrHeroDelegate()
  self.tableview:setDelegate(self.tb_dlgt)
  self.tableview:reloadData()
end

function chatEmoji:initView()
  local posx, posy = self.ui.emoji_btn_press:getPosition()
  self.ui.emoji_btn_press:setPosition(posx - 1, posy - 1)
  self:setEmojiOrHeroBtn()
  self:createTableView()
end

function chatEmoji:addEventListener()
  local posx, posy = self.ui.emoji_btn:getPosition()
  self.delegate:btRegisterButtonClick({
    button = self.ui.emoji_btn,
    key = "emoji_btn",
    clickHandler = function()
      if self:setEmojiOrHeroTab(ed.chatManager.EmojiTab.emoji) then
        ed.pt(self.ui.emoji_btn)
        self:setEmojiOrHeroBtn()
        self:reloadTableView()
      end
    end,
    radius = 30,
    centerOffset = ccp(posx - 12, posy - 8)
  })
  self.ui.hero_btn:setVisible(true)
  self.ui.hero_label:setVisible(true)
  self.delegate:btRegisterButtonClick({
    button = self.ui.hero_btn,
    key = "hero_btn",
    clickHandler = function()
      if self:setEmojiOrHeroTab(ed.chatManager.EmojiTab.hero) then
        self:setEmojiOrHeroBtn()
        self:reloadTableView()
      end
    end
  })
  posx, posy = self.ui.sticker_btn:getPosition()
  self.delegate:btRegisterButtonClick({
    button = self.ui.sticker_btn,
    key = "sticker_btn",
    clickHandler = function()
      if self:setEmojiOrHeroTab(ed.chatManager.EmojiTab.sticker) then
        self:setEmojiOrHeroBtn()
        self:reloadTableView()
      end
    end,
    radius = 30,
    centerOffset = ccp(posx - 12, posy - 8)
  })
end

function chatEmoji:showChatEmoji(force)
  local visible = self.ui.emoji_bg:isVisible()
  ed.pt(force ~= nil)
  if force ~= nil then
    visible = not force
  end
  self.ui.emoji_bg:setVisible(not visible)
  self.tableview.dragList:setTouchEnabled(not visible)
  ed.chatManager:setOperateChatWin(visible and ed.chatManager.ChatWinEnum.chatMainWin or ed.chatManager.ChatWinEnum.chatEmoji)
  self.delegate.chatMsgList:setTouchEnabled(visible)
end

function chatEmoji:setEmojiOrHeroTab(tab)
  if self.tab ~= tab then
    self.tab = tab
    return true
  end
  return false
end

function chatEmoji:getEmojiOrHeroTab()
  return self.tab
end

function chatEmoji:setEmojiOrHeroBtn()
  if self:getEmojiOrHeroTab() == ed.chatManager.EmojiTab.hero then
    self.ui.hero_btn_press:setVisible(true)
    self.ui.emoji_btn_press:setVisible(false)
    self.ui.sticker_btn_press:setVisible(false)
    self.ui.btn_bg:setPositionY(self.btn_bg_origin - self.btn_bg_offset)
  elseif self:getEmojiOrHeroTab() == ed.chatManager.EmojiTab.emoji then
    self.ui.hero_btn_press:setVisible(false)
    self.ui.emoji_btn_press:setVisible(true)
    self.ui.sticker_btn_press:setVisible(false)
    self.ui.btn_bg:setPositionY(self.btn_bg_origin)
  elseif self:getEmojiOrHeroTab() == ed.chatManager.EmojiTab.sticker then
    self.ui.hero_btn_press:setVisible(false)
    self.ui.emoji_btn_press:setVisible(false)
    self.ui.sticker_btn_press:setVisible(true)
    self.ui.btn_bg:setPositionY(self.btn_bg_origin - self.btn_bg_offset * 2)
  end
end

function chatEmoji:setEmojiOrHeroDelegate()
  local originsize = 128
  local realsize = 128 / ed.display.scaleFactor
  local offsetX = 20
  local offsetY = 10
  local dlgt = {}
  if self:getEmojiOrHeroTab() == ed.chatManager.EmojiTab.hero then
    local function getHeroes()
      local tb = {}
      
      for k, v in pairs(ed.player.heroes) do
        tb[#tb + 1] = v
      end
      return tb
    end
    
    local heroes = getHeroes()
    table.sort(heroes, ed.cmpSort({
      {
        getValue = function(o)
          return o._gs or 0
        end,
        reverse = true
      }
    }))
    
    function dlgt.numberOfCells()
      return #heroes
    end
    
    function dlgt.cellSizeFromIndex(idx)
      return CCSizeMake(realsize + offsetX, realsize + offsetY)
    end
    
    function dlgt.createCell(idx)
      local data = heroes[idx]
      local hicon = ed.readhero.createIconByHero(data, {length = realsize})
      return hicon.icon
    end
    
    function dlgt.syncCell(cell, idx)
      local data = heroes[idx]
      local hicon = ed.readhero.createIconByHero(data, {length = realsize})
      return hicon.icon
    end
    
    function dlgt.doClickIn(cell)
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatEmoji then
        local idx = cell.idx
        local hero = heroes[idx]
        self:formtCache()
        local row = ed.lookupDataTable("Unit", hero._tid)
        local hname = row["Display Name"]
        local name = row.Name
        local str = T("<emoji|12|0.32><text|chat_content|\232\191\153\229\164\170\230\156\137\232\182\163\228\186\134\229\144\167\239\188\140\231\187\153\228\189\160\228\187\172\231\156\139\230\136\145\231\154\132\232\139\177\233\155\132><link|herolink|%s|%d>", name, 1)
        local hero_id_list = {}
        local param = self.self_heroes_name_list[name]
        if param then
          hero_id_list[#hero_id_list + 1] = param.hid
        end
        local accessory = {
          _type = "heroes_link",
          _chat_hero_link = {
            _role_id = ed.getRoleId(),
            _heroids = hero_id_list
          }
        }
        ed.chatManager:setNeedSendMsg({
          type = 2,
          content = str,
          accessory = accessory
        })
        ed.chatManager:sendChatMsg(false)
        self:showChatEmoji()
      end
    end
  elseif self:getEmojiOrHeroTab() == ed.chatManager.EmojiTab.emoji then
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
      return CCSizeMake(realsize + offsetX, realsize + offsetY)
    end
    
    function dlgt.createCell(idx)
      local data = data[idx].res
      local item = ed.createSprite(data)
      local size = item:getContentSize()
      item:setScale(realsize / size.width)
      return item
    end
    
    function dlgt.syncCell(cell, idx)
      local data = data[idx].res
      local item = ed.createSprite(data)
      local size = item:getContentSize()
      item:setScale(realsize / size.width)
      return item
    end
    
    function dlgt.doClickIn(cell)
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatEmoji then
        local idx = cell.idx
        local str = self.delegate:getEditBoxString() .. "#" .. idx .. "#"
        self.delegate:setEditBoxString(str)
      end
    end
  elseif self:getEmojiOrHeroTab() == ed.chatManager.EmojiTab.sticker then
    local function getSticker()
      local data = ed.getDataTable("Sticker")
      
      local rst = {}
      for _, row in ipairs(data) do
        local isInsert = false
        local requirement = row["Requirement Type"]
        if requirement == "HaveItem" then
          if ed.player:getEquipAmount(row["Requirement ID"]) >= row["Requirement Target"] then
            isInsert = true
          end
        else
          isInsert = true
        end
        if isInsert then
          rst[#rst + 1] = {
            id = row["Sticker ID"],
            res = row.Picture
          }
        end
      end
      return rst
    end
    
    local data = getSticker()
    
    function dlgt.numberOfCells()
      return #data
    end
    
    function dlgt.cellSizeFromIndex(idx)
      return CCSizeMake(realsize + offsetX, realsize + offsetY)
    end
    
    function dlgt.createCell(idx)
      local data = data[idx].res
      local item = ed.createSprite(data)
      local size = item:getContentSize()
      item:setScale(realsize / size.width)
      return item
    end
    
    function dlgt.syncCell(cell, idx)
      local data = data[idx].res
      local item = ed.createSprite(data)
      local size = item:getContentSize()
      item:setScale(realsize / size.width)
      return item
    end
    
    function dlgt.doClickIn(cell)
      if ed.chatManager:getOperateChatWin() == ed.chatManager.ChatWinEnum.chatEmoji then
        local idx = cell.idx
        ed.chatManager:setNeedSendMsg({
          type = 1,
          content = string.format("<sticker|%s|1>", data[idx].id)
        })
        ed.chatManager:sendChatMsg(false)
        self:showChatEmoji()
      end
    end
  end
  return dlgt
end

function chatEmoji:formtCache()
  if not self.heroes_name_cache then
    local data = ed.getDataTable("Unit")
    for k, row in pairs(data) do
      if k ~= "name" then
        local dsnm = row["Display Name"]
        local name = row.Name
        local id = row.ID
        local param = {hid = id, name = name}
        if ed.player.heroes[id] then
          self.self_heroes_name_list[name] = param
        end
        self.heroes_formt_name_list[name] = dsnm
      end
    end
    self.heroes_name_cache = true
  end
  for k, v in pairs(ed.player.heroes) do
    local row = ed.getDataTable("Unit")[v._tid]
    local name = row.Name
    local id = row.ID
    local param = {hid = id, name = name}
    if not self.self_heroes_name_list[name] then
      self.self_heroes_name_list[name] = param
    end
  end
end

function chatEmoji:touch(event, x, y)
  if event == "began" then
    self.isPress = false
    if not ed.containsPoint(self.ui.chat_input_bg, x, y) and not ed.containsPoint(self.ui.emoji_bg, x, y) then
      self.isPress = true
    end
    if self.isPress then
      self.pxy = ccp(x, y)
      return true
    end
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), self.pxy)
    if 10 < dis then
      self.isPress = false
    end
  elseif event == "ended" and self.isPress and not ed.containsPoint(self.ui.chat_input_bg, x, y) and not ed.containsPoint(self.ui.emoji_bg, x, y) then
    self:showChatEmoji()
    return true
  end
  return false
end

ed.ui.chatEmoji = chatEmoji
