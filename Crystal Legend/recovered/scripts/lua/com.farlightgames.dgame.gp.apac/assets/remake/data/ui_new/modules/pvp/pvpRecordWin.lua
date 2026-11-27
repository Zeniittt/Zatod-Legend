local base = ed.ui.popwindow
local pvpRecordWin = {}
pvpRecordWin.__index = pvpRecordWin
setmetatable(pvpRecordWin, base.mt)
ed.ui.pvpRecordWin = pvpRecordWin
local pvpRecordWinScope = {}
local RecordArena = "RecordArena"
local RecordFight = "RecordFight"

function pvpRecordWin.create()
  local self = base.create("pvpRecordWin")
  setmetatable(self, pvpRecordWin)
  self.tabIndex = RecordArena
  self:initUI()
  self:registerTouchHandlers()
  self:popWindow()
  self:show()
  return self
end

function pvpRecordWin:initData(params)
  self.allRecordData = params
  self.data = self.allRecordData._arena_records or {}
end

function pvpRecordWin:getPressInHandler()
  local function handler(x, y)
    for _, item in ipairs(self.uiList or {}) do
      if ed.containsPoint(item.btn_replay, x, y) then
        item.btn_replay:setScale(0.72)
        
        return item
      end
      if ed.containsPoint(item.btn_data, x, y) then
        item.btn_data:setScale(0.72)
        return item
      end
      if ed.containsPoint(item.btn_share, x, y) then
        item.btn_share:setScale(0.72)
        return item
      end
      if ed.containsPoint(item.Panel_73, x, y) then
        return item
      end
      self.ui.bg_share:setVisible(false)
    end
  end
  
  return handler
end

function pvpRecordWin:getClickInHandler()
  local function handler(x, y, item)
    if ed.containsPoint(item.btn_replay, x, y) then
      self:doQueryBattleReplay(item.index)
    end
    if ed.containsPoint(item.btn_data, x, y) then
      self:doQueryBattleData(item.index)
    end
    if ed.containsPoint(item.btn_share, x, y) then
      self.index = item.index
      self:doShareBattle(item.index)
    end
    if ed.containsPoint(item.Panel_73, x, y) and self.tabIndex ~= RecordFight then
      self:doQueryOppo(item.index)
    end
  end
  
  return handler
end

function pvpRecordWin:getCancelPressInHandler()
  local function handler(x, y, item)
    item.btn_share:setScale(0.8)
    
    item.btn_replay:setScale(0.8)
    item.btn_data:setScale(0.8)
    self.ui.bg_share:setVisible(false)
    if ed.newShowMedalPop then
      ed.newShowMedalPop:destroy({skipAnim = false})
      ed.newShowMedalPop = nil
    end
  end
  
  return handler
end

function pvpRecordWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.CrusadeReplayMainWin)
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    priority = -300,
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    message = false
  }, self)
  ed.setString(self.ui.label_title, T("\231\171\158\230\138\128\229\156\186\230\136\152\230\150\151\232\174\176\229\189\149"))
  ed.left2(self.ui.image_title_left, self.ui.label_title, 10)
  ed.right2(self.ui.image_title_right, self.ui.label_title, 10)
  self.ui.label_guild:limitWidthByScale(115)
  self.ui.label_world:limitWidthByScale(115)
  self.ui.bg_share:setVisible(false)
end

function pvpRecordWin:createHeadIcon(hero)
  local heroIcon
  if hero._legend_equip == nil then
    heroIcon = ed.readhero.createIcon({
      id = hero._tid,
      rank = hero._rank,
      level = hero._level,
      stars = hero._stars,
      fashion_id = hero._fashion,
      summary = hero
    })
  else
    heroIcon = ed.readhero.createIcon({
      id = hero._tid,
      rank = hero._rank,
      level = hero._level,
      stars = hero._stars,
      fashion_id = hero._fashion,
      summary = hero,
      legendEquip = hero._legend_equip and hero._legend_equip._equip
    })
  end
  heroIcon:showLegendEquip(not ed.openLegendEquip())
  heroIcon.icon:setScale(0.6)
  return heroIcon.icon
end

function pvpRecordWin:createRecordItem(data, type)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.PvpReplayItem)
  local resultNum, resultIcon
  if data._bt_result == "victory" then
    ed.setTexture(ui.img_win, "UI/alpha/1080P/crusade/icon_win.png")
    ed.setLabelString(ui.label_win, T("\232\131\156"))
    ed.setLabelColor(ui.label_win, ed.toccc3(16774293))
    ed.setLabelStroke(ui.label_win, ed.toccc3(1335817), 1)
    resultIcon = ed.createSprite("UI/alpha/1080P/pvp/arrow_up.png")
    resultNum = ed.createttf(data._deta_rank, 14)
    resultNum:setColor(ccc3(112, 255, 84))
    ed.setLabelStroke(resultNum, ccc3(23, 49, 31), 1)
    resultNum:setPosition(ccp(8, -10))
    resultIcon:addChild(resultNum)
    local x, y = ui.lab_round:getPosition()
    ui.lab_round:setVisible(false)
    resultIcon:setPosition(ccp(x, y + 15))
    ui.img_bg:addChild(resultIcon)
  elseif data._bt_result == "defeat" then
    ed.setTexture(ui.img_win, "UI/alpha/1080P/crusade/icon_defead.png")
    ed.setLabelString(ui.label_win, T("\232\180\165"))
    ed.setLabelColor(ui.label_win, ed.toccc3(16763825))
    ed.setLabelStroke(ui.label_win, ed.toccc3(6168596), 1)
    resultIcon = ed.createSprite("UI/alpha/1080P/pvp/arrow_down.png")
    resultNum = ed.createttf(data._deta_rank * -1, 14)
    resultNum:setColor(ccc3(255, 88, 84))
    ed.setLabelStroke(resultNum, ccc3(85, 3, 3), 1)
    resultNum:setPosition(ccp(8, -8))
    resultIcon:addChild(resultNum)
    local x, y = ui.lab_round:getPosition()
    ui.lab_round:setVisible(false)
    resultIcon:setPosition(ccp(x, y + 15))
    ui.img_bg:addChild(resultIcon)
  end
  if resultNum and resultIcon then
    if type == RecordArena then
      resultNum:setVisible(true)
      resultIcon:setVisible(true)
    else
      resultNum:setVisible(false)
      resultIcon:setVisible(false)
    end
  else
  end
  ed.setLabelStroke(ui.label_defend, ed.toccc3(11689512), 1)
  ui.label_defend:setFontName(ed.fontBold)
  ui.icon_defend:setVisible(data._active ~= 1 and self.tabIndex ~= RecordFight)
  local timestr = ed.time2dhms(ed.getServerTime() - data._bt_time) .. T("\229\137\141")
  ed.setString(ui.lab_time, timestr)
  local summary = data._summary
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.33,
    config = {nameposition = 12},
    lvoffset = {x = -16, y = 0}
  }
  local playerHead = ed.getWholeHeadIcon(param)
  ui.bg_head:addChild(playerHead)
  playerHead:setPosition(ccp(0, 10))
  local name, i, autoText = ed.getPlayerName(ed.transBotName(summary._name), summary._medal, {medalScale = 0.13, left = true})
  ui.bg_head:addChild(name)
  if summary._medal then
    name:setPosition(ccp(40, 10))
    autoText.spriteNode.medalIcon:setPositionX(20)
  else
    name:setPosition(ccp(50, 10))
  end
  for i, opppHero in ipairs(data._oppo_heroes) do
    local heroIcon = self:createHeadIcon(opppHero)
    ui.img_bg:addChild(heroIcon)
    heroIcon:setPosition(ccp(38 + i * 55, 32))
  end
  return container, ui
end

function pvpRecordWin:doQueryBattleReplay(index)
  local record = self.data[index]
  local recordid = record._replay_id
  ed.pvpNetwork:sendQueryReplay(recordid)
end

function pvpRecordWin:doQueryOppo(index)
  local record = self.data[index]
  ed.registerNetReply("query_pvp_oppo", function(data)
    ed.ui.PvpOppoInfoWin.create(data, record._bt_result ~= "victory" and record._active ~= 1)
  end)
  ed.pvpNetwork:sendQueryOppo(record._user_id)
end

function pvpRecordWin:doQueryBattleData(index)
  local record = self.data[index]
  local recordid = record._replay_id
  local side
  if record._deta_rank > 0 then
    side = 1
  elseif record._deta_rank < 0 then
    side = 2
  elseif record._bt_result == "victory" then
    side = 2
  else
    side = 1
  end
  ed.netdata.pvpQuerySummaryReply = {
    roleId = record._user_id,
    side = side
  }
  local msg = ed.upmsg.ladder()
  msg._query_summary = {}
  msg._query_summary._record_index = recordid
  ed.send(msg, "ladder")
end

function pvpRecordWin:getShardBtnPos(index)
  local ui = self.uiList[index]
  local shardBtn = ui.btn_share
  local pos = ccp(shardBtn:getPosition())
  local shardBtnParent = shardBtn:getParent()
  local worldPos = shardBtnParent:convertToWorldSpace(pos)
  return worldPos
end

function pvpRecordWin:doShareBattle(index)
  local ui = self.ui
  if ui.bg_share:isVisible() then
    ui.bg_share:setVisible(false)
  else
    local pos = self:getShardBtnPos(index)
    self.ui.bg_share:setPosition(ccp(pos.x - 190 - ed.display.halfFixedWidth, pos.y))
    ui.bg_share:setVisible(true)
  end
end

function pvpRecordWin:refreshDraglist()
  local uiList = {}
  if self.tabIndex == RecordArena then
    self.data = self.allRecordData._arena_records
  elseif self.tabIndex == RecordFight then
    self.data = self.allRecordData._fight_records
  else
    self.data = {}
  end
  self.draglist.listLayer:removeAllChildrenWithCleanup(true)
  local oy = self.ui.layer_item:getContentSize().height
  local ox = self.ui.layer_item:getContentSize().width / 2
  local dy = 92
  
  local function getPos(i)
    return ccp(ox, oy - dy * i + 47)
  end
  
  self.data = self.data or {}
  for k, v in ipairs(self.data) do
    local container, ui = self:createRecordItem(v, self.tabIndex)
    ui.data = v
    ui.index = k
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(getPos(k))
  end
  self.uiList = uiList
  self.draglist:initListHeight(#self.data * dy)
end

function pvpRecordWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    CloseScope(pvpRecordWinScope)
    base.destroy(self)
  end, {
    pressScale = 0.75,
    normalScale = 0.8,
    priority = -400
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_guild,
    key = "btn_share_guild",
    clickHandler = function()
      if ed.player:getGuildId() == 0 then
        ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
        return
      end
      local content = string.format("<link|pvp|%s>", T("\231\171\158\230\138\128\229\156\186"))
      local inputStr = ""
      if inputStr ~= "" then
        content = string.format("%s<><text|chat_content|%s|400>", content, inputStr)
      end
      local record = self.data[self.index]
      local recordid = record._replay_id
      local param = {
        channel = "guild_channel",
        type = 2,
        content = content,
        recordid = recordid,
        accessory = {
          _type = "pvp_replay",
          _record_id = recordid,
          _role_id = ed.getRoleId()
        }
      }
      ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
      ed.chatManager:setNeedSendMsg(param)
      ed.chatManager:sendChatMsg()
    end,
    mcpMode = true,
    clickInterval = 0.5,
    priority = -400,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_world,
    key = "btn_share_world",
    clickHandler = function()
      if ed.player:getLevel() < 24 then
        ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17624\231\186\167\230\137\141\232\131\189\229\156\168\228\184\150\231\149\140\233\162\145\233\129\147\229\136\134\228\186\171\230\136\152\230\150\151\229\189\149\229\131\143"))
        return
      end
      local content = string.format("<link|pvp|%s>", T("\231\171\158\230\138\128\229\156\186"))
      local inputStr = ""
      if inputStr ~= "" then
        content = string.format("%s<><text|chat_content|%s|400>", content, inputStr)
      end
      local record = self.data[self.index]
      local recordid = record._replay_id
      local param = {
        channel = "world_channel",
        type = 2,
        content = content,
        recordid = recordid,
        accessory = {
          _type = "pvp_replay",
          _record_id = recordid,
          _role_id = ed.getRoleId()
        }
      }
      ed.showToast(T("\229\136\134\228\186\171\230\136\144\229\138\159"))
      ed.chatManager:setNeedSendMsg(param)
      ed.chatManager:sendChatMsg()
    end,
    mcpMode = true,
    clickInterval = 0.5,
    priority = -400,
    pressScale = 0.95
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_arena_record,
    key = "btn_arena_record",
    clickInterval = 0.3,
    priority = -400,
    clickHandler = function()
      if self.tabIndex == RecordArena then
        return
      end
      self.tabIndex = RecordArena
      ed.setLabelColor(self.ui.label_arena_record, ccc3(67, 57, 52))
      ed.setLabelStroke(self.ui.label_arena_record, ccc3(255, 252, 231), 1)
      ed.setLabelColor(self.ui.label_fight_record, ccc3(255, 252, 231))
      ed.setLabelStroke(self.ui.label_fight_record, ccc3(56, 38, 34), 1)
      self.ui.btn_arena_selected:setVisible(true)
      self.ui.btn_fight_selected:setVisible(false)
      ed.setString(self.ui.label_title, T("\231\171\158\230\138\128\229\156\186\230\136\152\230\150\151\232\174\176\229\189\149"))
      ed.left2(self.ui.image_title_left, self.ui.label_title, 10)
      ed.right2(self.ui.image_title_right, self.ui.label_title, 10)
      self:refreshDraglist()
    end
  })
  self:btRegisterButtonClick({
    button = self.ui.btn_fight_record,
    key = "btn_fight_record",
    clickInterval = 0.3,
    priority = -400,
    clickHandler = function()
      if self.tabIndex == RecordFight then
        return
      end
      self.tabIndex = RecordFight
      ed.setLabelColor(self.ui.label_fight_record, ccc3(67, 57, 52))
      ed.setLabelStroke(self.ui.label_fight_record, ccc3(255, 252, 231), 1)
      ed.setLabelColor(self.ui.label_arena_record, ccc3(255, 252, 231))
      ed.setLabelStroke(self.ui.label_arena_record, ccc3(56, 38, 34), 1)
      self.ui.btn_arena_selected:setVisible(false)
      self.ui.btn_fight_selected:setVisible(true)
      ed.setString(self.ui.label_title, T("\229\136\135\231\163\139\230\136\152\230\150\151\232\174\176\229\189\149"))
      ed.left2(self.ui.image_title_left, self.ui.label_title, 10)
      ed.right2(self.ui.image_title_right, self.ui.label_title, 10)
      self:refreshDraglist()
    end
  })
  self:listenEvent("PvpRecordRefresh", function(params)
    self:initData(params)
    self:refreshDraglist()
  end)
end
