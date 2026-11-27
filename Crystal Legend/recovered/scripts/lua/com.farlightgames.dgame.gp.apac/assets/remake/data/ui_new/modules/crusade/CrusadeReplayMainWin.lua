local CrusadeRecordPage = {}
CrusadeRecordPage.__index = CrusadeRecordPage

function CrusadeRecordPage.create(data)
  local object = {}
  setmetatable(object, CrusadeRecordPage)
  object:initData(data)
  object:initAppearence()
  return object
end

function CrusadeRecordPage:initData(data)
  self.record = data
end

function CrusadeRecordPage:initAppearence()
  self.container, self.ui = ed.editorui(ed.uieditor.CrusadeReplayItem)
  if self.record._replay_id == 0 then
    self.ui.btn_share:setVisible(false)
    self.ui.btn_data:setVisible(false)
    self.ui.btn_replay:setVisible(false)
  end
  if self.record._bt_result == "victory" then
    ed.setTexture(self.ui.img_win, "UI/alpha/1080P/crusade/icon_win.png")
    ed.setLabelString(self.ui.label_win, T("\232\131\156"))
    ed.setLabelColor(self.ui.label_win, ed.toccc3(16774293))
    ed.setLabelStroke(self.ui.label_win, ed.toccc3(1335817), 1)
  elseif self.record._bt_result == "defeat" then
    ed.setTexture(self.ui.img_win, "UI/alpha/1080P/crusade/icon_defead.png")
    ed.setLabelString(self.ui.label_win, T("\232\180\165"))
    ed.setLabelColor(self.ui.label_win, ed.toccc3(16763825))
    ed.setLabelStroke(self.ui.label_win, ed.toccc3(6168596), 1)
  end
  self.ui.label_win:limitWidthByScale(22)
  ed.setString(self.ui.lab_round, self.record._stage_id .. "/" .. 15)
  self:initTime()
  self:initUserSummary()
  self:initHeroes()
end

function CrusadeRecordPage:initTime()
  local curtime = ed.getServerTime()
  local time = curtime - self.record._bt_time
  local timestr = ed.time2dhms(time)
  timestr = T("%s\229\137\141", timestr)
  ed.setString(self.ui.lab_time, timestr)
end

function CrusadeRecordPage:initUserSummary()
  local summary = self.record._summary
  local name = summary._name == "NickName" and T("\230\156\170\229\145\189\229\144\141\231\142\169\229\174\182") or ed.transBotName(summary._name)
  local param = {
    id = summary._avatar,
    level = summary._level,
    name = name,
    scale = 0.35,
    config = {nameposition = 10},
    lvoffset = {x = -18, y = 0},
    medal = summary._medal
  }
  local playerHead = ed.getWholeHeadIcon(param)
  self.ui.bg_head:addChild(playerHead)
  playerHead:setPosition(ccp(0, 10))
end

function CrusadeRecordPage:initHeroes()
  for i, tbcHero in ipairs(self.record._heroes) do
    local heroIcon = self:createHeadIcon(tbcHero)
    self.ui.img_bg:addChild(heroIcon)
    heroIcon:setPosition(ccp(38 + i * 55, 32))
  end
end

function CrusadeRecordPage:createHeadIcon(tbcHero)
  local base = tbcHero._base
  local dyna = tbcHero._dyna
  local heroIcon
  if base._legend_equip then
    heroIcon = ed.readhero.createIcon({
      id = base._tid,
      rank = base._rank,
      level = base._level,
      stars = base._stars,
      hp = dyna._hp_perc,
      fashion_id = base._fashion,
      summary = base,
      legendEquip = base._legend_equip._equip
    })
  else
    heroIcon = ed.readhero.createIcon({
      id = base._tid,
      rank = base._rank,
      level = base._level,
      stars = base._stars,
      hp = dyna._hp_perc,
      fashion_id = base._fashion,
      summary = base,
      legendEquip = nil
    })
  end
  heroIcon:showLegendEquip(not ed.openLegendEquip())
  heroIcon.icon:setScale(0.6)
  return heroIcon.icon
end

local CrusadeReplayMainWin = {}
ed.ui.CrusadeReplayMainWin = CrusadeReplayMainWin
CrusadeReplayMainWin.__index = CrusadeReplayMainWin
local CrusadeReplayMainScope = {}
local base = ed.ui.popwindow
setmetatable(CrusadeReplayMainWin, base.mt)

function CrusadeReplayMainWin.create(data)
  local object = base.create("CrusadeReplayMainWin")
  setmetatable(object, CrusadeReplayMainWin)
  object:initData(data)
  object:initAppearence()
  object:registerTouchHandler()
  return object
end

function CrusadeReplayMainWin:destroy()
  self.sharePanel = nil
  CloseScope(CrusadeReplayMainScope)
  base.destroy(self)
end

function CrusadeReplayMainWin:initData(data)
  self.records = data._records or {}
end

function CrusadeReplayMainWin:initAppearence()
  self.window = ed.createui("CrusadeReplayMainWin", {
    mainLayer = self.container,
    touch_node = self
  })
  self.window.ui.bg_share:setVisible(false)
  self.window.ui.btn_back:setScale(0.8)
  self.window.ui.btn_fight_record:setVisible(false)
  self.window.ui.btn_arena_record:setVisible(false)
  self.window.ui.label_fight_record:setVisible(false)
  self.window.ui.label_arena_record:setVisible(false)
  ed.adaptLabel(self.window.ui.label_world, {maxWidth = 120, minScale = 0.7})
  ed.adaptLabel(self.window.ui.label_guild, {maxWidth = 120, minScale = 0.7})
  self.window.ui.label_world:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.window.ui.label_guild:setHorizontalAlignment(kCCTextAlignmentCenter)
  ed.left2(self.window.ui.image_title_left, self.window.ui.label_title, 10)
  ed.right2(self.window.ui.image_title_right, self.window.ui.label_title, 10)
  ed.setLabelStroke(self.window.ui.label_world, ccc3(81, 51, 27), 1)
  ed.setLabelStroke(self.window.ui.label_guild, ccc3(81, 51, 27), 1)
  self:createDraglist()
  self:createRecords()
end

function CrusadeReplayMainWin:createRecords()
  self.pages = {}
  for i, record in ipairs(self.records) do
    local page = CrusadeRecordPage.create(record)
    page.ui.index = i
    self.draglist.listLayer:addChild(page.container)
    page.container:setPosition(ccp(286, 380 - i * 92))
    table.insert(self.pages, page)
  end
  self.draglist:initListHeight(#self.pages * 92 + 5)
end

function CrusadeReplayMainWin:registerTouchHandler()
  self:btRegisterButtonClick({
    button = self.window.ui.btn_back,
    key = "btn_back",
    clickHandler = function()
      self:destroy()
    end,
    mcpMode = true,
    pressScale = 0.75,
    normalScale = 0.8,
    clickInterval = 0.5,
    priority = -400
  })
  self:registerPageToucher()
end

function CrusadeReplayMainWin:registerPageToucher()
  self:btRegisterButtonClick({
    button = self.window.ui.btn_world,
    key = "btn_share_world",
    clickHandler = function()
      if ed.player:getLevel() < 24 then
        ed.showToast(T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17624\231\186\167\230\137\141\232\131\189\229\156\168\228\184\150\231\149\140\233\162\145\233\129\147\229\136\134\228\186\171\230\136\152\230\150\151\229\189\149\229\131\143"))
        return
      end
      local content = string.format("<link|pvp|%s>", T("\231\135\131\231\131\167\231\154\132\232\191\156\229\190\129"))
      local record = self.records[self.index]
      local recordid = record._replay_id
      local param = {
        channel = "world_channel",
        type = 2,
        content = content,
        recordid = recordid,
        accessory = {
          _type = "tbc_replay",
          _record_id = recordid,
          _role_id = ed.getRoleId()
        }
      }
      ed.chatManager:setNeedSendMsg(param)
      ed.chatManager:sendChatMsg()
    end,
    mcpMode = true,
    pressScale = 0.95,
    clickInterval = 0.5,
    priority = -400
  })
  self:btRegisterButtonClick({
    button = self.window.ui.btn_guild,
    key = "btn_share_guild",
    clickHandler = function()
      if ed.player:getGuildId() == 0 then
        ed.showToast(T("\233\156\128\232\166\129\229\138\160\229\133\165\229\133\172\228\188\154\229\144\142\230\137\141\232\131\189\229\156\168\229\133\172\228\188\154\233\162\145\233\129\147\229\143\145\232\168\128"))
        return
      end
      local content = string.format("<link|pvp|%s>", T("\231\135\131\231\131\167\231\154\132\232\191\156\229\190\129"))
      local record = self.records[self.index]
      local recordid = record._replay_id
      local param = {
        channel = "guild_channel",
        type = 2,
        content = content,
        recordid = recordid,
        accessory = {
          _type = "tbc_replay",
          _record_id = recordid,
          _role_id = ed.getRoleId()
        }
      }
      ed.chatManager:setNeedSendMsg(param)
      ed.chatManager:sendChatMsg()
    end,
    mcpMode = true,
    clickInterval = 0.5,
    pressScale = 0.95,
    priority = -400
  })
end

function CrusadeReplayMainWin:doQueryBattleReplay(index)
  ListenEventOnce(ed.CrusadeEventNames.QueryReplay, function(data)
    self:showReplay(data)
  end, CrusadeReplayMainScope)
  local record = self.records[index]
  local recordid = record._replay_id
  self.stageid = record._stage_id
  ed.CrusadeNetwork:queryReply(recordid)
end

function CrusadeReplayMainWin:showReplay(data)
  if self.stageid then
    local stageid = -2 - self.stageid
    ed.showReplay(data._record, "tbc", stageid)
  end
end

function CrusadeReplayMainWin:doQueryBattleData(index)
  ListenEventOnce(ed.CrusadeEventNames.QueryBattleData, function(data)
    ed.ui.BattleStaticsWin.create(data[1], "crusade")
  end, CrusadeReplayMainScope)
  local record = self.records[index]
  local recordid = record._replay_id
  ed.CrusadeNetwork:querySummary(recordid)
end

function CrusadeReplayMainWin:doShareBattle(index)
  if self.window.ui.bg_share:isVisible() then
    self.window.ui.bg_share:setVisible(false)
  else
    local pos = self:getShardBtnPos(index)
    self.window.ui.bg_share:setPosition(ccp(pos.x - 190 - ed.display.halfFixedWidth, pos.y))
    self.window.ui.bg_share:setVisible(true)
  end
end

function CrusadeReplayMainWin:getShardBtnPos(index)
  local page = self.pages[index]
  local ui = page.ui
  local shardBtn = ui.btn_share
  local pos = ccp(shardBtn:getPosition())
  local shardBtnParent = shardBtn:getParent()
  local worldPos = shardBtnParent:convertToWorldSpace(pos)
  return worldPos
end

function CrusadeReplayMainWin:getPressInHandler()
  local function handler(x, y)
    for _, page in ipairs(self.pages or {}) do
      local item = page.ui
      
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
      self.window.ui.bg_share:setVisible(false)
    end
  end
  
  return handler
end

function CrusadeReplayMainWin:getClickInHandler()
  local function handler(x, y, item)
    if ed.containsPoint(item.btn_replay, x, y) and item.btn_replay:isVisible() then
      self:doQueryBattleReplay(item.index)
    end
    if ed.containsPoint(item.btn_data, x, y) and item.btn_data:isVisible() then
      self:doQueryBattleData(item.index)
    end
    if ed.containsPoint(item.btn_share, x, y) and item.btn_share:isVisible() then
      self.index = item.index
      self:doShareBattle(item.index)
    end
  end
  
  return handler
end

function CrusadeReplayMainWin:getCancelPressInHandler()
  local function handler(x, y, item)
    item.btn_share:setScale(0.8)
    
    item.btn_replay:setScale(0.8)
    item.btn_data:setScale(0.8)
    self.window.ui.bg_share:setVisible(false)
  end
  
  return handler
end

function CrusadeReplayMainWin:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.window.ui.layer_item, {
    priority = -300,
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    message = false
  }, self)
end
