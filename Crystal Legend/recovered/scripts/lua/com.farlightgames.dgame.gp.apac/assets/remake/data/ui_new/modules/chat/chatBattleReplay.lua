local chatBattleReplay = {}
chatBattleReplay.__index = chatBattleReplay
ed.chatBattleReplay = chatBattleReplay
ed.chatBattleReplay.buttonList = {}
ed.chatBattleReplay.button = nil
ed.chatBattleReplay.buttonHandle = nil
ed.chatBattleReplay.pxy = ccp(0, 0)
ed.chatBattleReplay.isPress = false

function chatBattleReplay.create(data)
  local object = {}
  setmetatable(object, chatBattleReplay)
  object:initData(data)
  object:initView()
  return object
end

function chatBattleReplay:initData(data)
  self.width = 810 / ed.display.scaleFactor
  self.height = 278 / ed.display.scaleFactor
  self.heroIconSize = 65 / ed.display.scaleFactor
  self.heroIconSpaceX = 10 / ed.display.scaleFactor
  self.heroIconPosX = 17.5 / ed.display.scaleFactor
  self.heroIconPosY = 20 / ed.display.scaleFactor
  self.data = data
  self.buttonList = {}
  self.battle_record = nil
end

function chatBattleReplay:initView()
  self.container = CCNode:create()
  self.ui = {}
  ed.editorui(ed.uieditor.chat_battle_replay, {
    container = self.container,
    ui = self.ui
  })
  self:initLabel()
  self:initBaseInfoView()
  self:initTeamView()
  self:initButtons()
end

function chatBattleReplay:initLabel()
  self.ui.player_level:setStroke(ccc3(169, 104, 27), 2)
  self.ui.oppo_level:setStroke(ccc3(169, 104, 27), 2)
  self.ui.player_name:setStroke(ccc3(85, 64, 39), 2)
  self.ui.oppo_name:setStroke(ccc3(85, 64, 39), 2)
  ed.setLabelStroke(self.ui.label_player_defead, ed.toccc3(6168596), 1)
  ed.setLabelStroke(self.ui.label_oppo_defead, ed.toccc3(6168596), 1)
  ed.setLabelStroke(self.ui.label_player_win, ed.toccc3(1335817), 1)
  ed.setLabelStroke(self.ui.label_oppo_win, ed.toccc3(1335817), 1)
end

function chatBattleReplay:initBaseInfoView()
  ed.pt(self.data._summary._type)
  if self.data._summary._type == "pvp_replay" then
    self.battle_record = self.data._summary._replay
    self.ui.type_img:setVisible(true)
    ed.setTexture(self.ui.type_img, "UI/alpha/1080P/chat/new/chat_battle_pvp.png")
  elseif self.data._summary._type == "tbc_replay" then
    self.battle_record = self.data._summary._replay
    self.ui.type_img:setVisible(true)
    ed.setTexture(self.ui.type_img, "UI/alpha/1080P/chat/new/chat_battle_crusade.png")
  elseif self.data._summary._type == "dreamland_replay" then
    self.battle_record = self.data._summary._replay
    self.ui.type_img:setVisible(true)
    ed.setTexture(self.ui.type_img, "UI/alpha/1080P/chat/new/chat_battle_dreamland.png")
    local uid = ed.lookupDataTable("DreamlandBossDesc", "Unit ID", self.data._summary._dreamland_stage)
    local oppo_name = ed.lookupDataTable("Unit", "Display Name", uid)
    ed.createLabelTools({
      txt = T("[\230\176\184\231\148\159\230\162\166\229\162\131] %s", oppo_name),
      size = 12,
      anchor = ccp(0, 0.5),
      pos = ccp(27.5, 15),
      color = ccc3(255, 252, 231),
      stroke = {
        ccc3(0, 0, 0),
        1
      },
      parent = self.ui.oppo_title_bg
    })
    self.ui.oppo_head:setVisible(false)
    self.ui.oppo_level_bg:setVisible(false)
    self.ui.oppo_level:setVisible(false)
    self.ui.oppo_name:setVisible(false)
    self.ui.oppo_head_bg:setVisible(false)
  else
    self.battle_record = nil
    self.ui.type_img:setVisible(false)
  end
  if self.battle_record == nil then
    return
  end
  local name = ed.getPlayerName(self.battle_record._username, self.battle_record._self_medal, {left = true})
  ed.UITool.replaceUI(self.ui, "player_title_bg", "player_name", name)
  name:setScale(0.65)
  self.ui.player_level:setString(self.battle_record._level)
  local name = ed.getPlayerName(self.battle_record._oppo_name, self.battle_record._oppo_medal, {left = true})
  ed.UITool.replaceUI(self.ui, "oppo_title_bg", "oppo_name", name)
  name:setScale(0.65)
  self.ui.oppo_level:setString(self.battle_record._oppo_level or "")
  local head = ed.getTeamHead({
    id = self.battle_record._avatar
  })
  head:setPosition(self.ui.player_head:getPosition())
  self.ui.player_title_bg:addChild(head, 9)
  head:setScale(0.3)
  if self.battle_record._oppo_avatar then
    head = ed.getTeamHead({
      id = self.battle_record._oppo_avatar
    })
    head:setPosition(self.ui.oppo_head:getPosition())
    self.ui.oppo_title_bg:addChild(head, 9)
    head:setScale(0.3)
  end
  if self.data._summary._type == "dreamland_replay" then
    self.ui.player_win:setVisible(false)
    self.ui.player_defead:setVisible(false)
    self.ui.oppo_win:setVisible(false)
    self.ui.oppo_defead:setVisible(false)
  else
    local defeat = self.battle_record._result == "defeat"
    self.ui.player_win:setVisible(not defeat)
    self.ui.player_defead:setVisible(defeat)
    self.ui.oppo_win:setVisible(defeat)
    self.ui.oppo_defead:setVisible(not defeat)
  end
end

function chatBattleReplay:initTeamView()
  if self.data._summary._query_summary == nil then
    return
  end
  for i, data in ipairs(self.data._summary._query_summary) do
    if data._hero_data then
      self:createHeroIcon(data._hero_data)
    end
  end
end

function chatBattleReplay:createHeroIcon(heroTeamList)
  local playerposx = self.heroIconPosX + self.heroIconSize / 2
  local oppoposx = playerposx
  local posy = self.heroIconPosY + self.heroIconSize / 2
  local self_index = 1
  local oppo_index = 1
  for i, unit in ipairs(heroTeamList) do
    xpcall(function()
      local mSprite
      if ed.emCampPlayer == unit._camp then
        local heroinfo
        if self.data._summary._replay._self_heroes then
          heroinfo = self.data._summary._replay._self_heroes[self_index]
        end
        local legendEquip
        if heroinfo then
          legendEquip = heroinfo._legend_equip and heroinfo._legend_equip._equip
        end
        mSprite = self:getHeroIcon(unit, legendEquip)
        mSprite:setPosition(ccp(playerposx, posy))
        self.ui.player_heroes:addChild(mSprite)
        playerposx = playerposx + self.heroIconSize + self.heroIconSpaceX
        self_index = self_index + 1
      elseif ed.emCampEnemy == unit._camp then
        local heroinfo
        if self.data._summary._replay._oppo_heroes then
          heroinfo = self.data._summary._replay._oppo_heroes[oppo_index]
        end
        local legendEquip
        if heroinfo and nil ~= heroinfo._legend_equip then
          legendEquip = heroinfo._legend_equip and heroinfo._legend_equip._equip
        end
        mSprite = self:getHeroIcon(unit, legendEquip)
        mSprite:setPosition(ccp(oppoposx, posy))
        self.ui.oppo_heroes:addChild(mSprite)
        oppoposx = oppoposx + self.heroIconSize + self.heroIconSpaceX
        oppo_index = oppo_index + 1
      end
    end, EDDebug)
  end
end

function chatBattleReplay:getHeroIcon(heroInfo, legendEquip)
  local fashion_id = heroInfo._fashion_id
  local rank = heroInfo._rank
  local spriteIcon, info = ed.readhero.getIcon({
    id = heroInfo._tid,
    level = heroInfo._level,
    stars = heroInfo._stars,
    length = self.heroIconSize,
    rank = rank,
    fashion_id = fashion_id,
    summary = heroInfo,
    legendEquip = legendEquip
  })
  info:showLegendEquip(not ed.openLegendEquip())
  if heroInfo._hp and heroInfo._hp <= 0 then
    local die = ed.createttf(T("\229\183\178\233\152\181\228\186\161"), 21)
    ed.setLabelColor(die, ed.toccc3(16741231))
    ed.setLabelStroke(die, ed.toccc3(0), 2)
    die:setPosition(36, 60)
    spriteIcon:addChild(die, 10)
    local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade:setContentSize(spriteIcon:getContentSize())
    spriteIcon:addChild(shade)
  end
  return spriteIcon
end

function chatBattleReplay:initButtons()
  if self.data._summary._type == "pvp_replay" then
    table.insert(ed.chatBattleReplay.buttonList, {
      data = self.data,
      detail_btn = self.ui.detail_btn,
      replay_btn = self.ui.replay_btn,
      detail_handler = function()
        local msg = ed.upmsg.ladder()
        msg._query_summary = {}
        msg._query_summary._record_index = self.battle_record._checkid
        ed.send(msg, "ladder")
      end,
      replay_handler = function()
        ed.pvpNetwork:sendQueryReplay(self.battle_record._checkid)
      end
    })
  elseif self.data._summary._type == "tbc_replay" then
    table.insert(ed.chatBattleReplay.buttonList, {
      data = self.data,
      detail_btn = self.ui.detail_btn,
      replay_btn = self.ui.replay_btn,
      detail_handler = function()
        ListenEventOnce(ed.CrusadeEventNames.QueryBattleData, function(data)
          ed.ui.BattleStaticsWin.create(data[1], "crusade")
        end)
        local msg = ed.upmsg.tbc()
        msg._query_summary = ed.upmsg.query_summary()
        msg._query_summary._record_index = self.battle_record._checkid
        ed.send(msg, "tbc")
      end,
      replay_handler = function()
        ListenEventOnce(ed.CrusadeEventNames.QueryReplay, function(data)
          local stageid = self.data._summary._tbc_stage
          if stageid then
            local stageid = -2 - stageid
            ed.showReplay(self.battle_record, "tbc", stageid)
          end
        end)
        local msg = ed.upmsg.tbc()
        msg._query_replay = ed.upmsg.query_replay()
        msg._query_replay._record_index = self.battle_record._checkid
        ed.send(msg, "tbc")
      end
    })
  elseif self.data._summary._type == "dreamland_replay" then
    table.insert(ed.chatBattleReplay.buttonList, {
      data = self.data,
      detail_btn = self.ui.detail_btn,
      replay_btn = self.ui.replay_btn,
      detail_handler = function()
        ed.dreamland.network_mgr:sendQuerySummary(self.battle_record._checkid)
      end,
      replay_handler = function()
        ed.dreamland.network_mgr.ReplayStageId = self.data._summary._dreamland_stage
        ed.dreamland.network_mgr:sendQueryReplay(self.battle_record._checkid)
      end
    })
  end
end

function chatBattleReplay.touch(event, x, y)
  if event == "began" then
    ed.chatBattleReplay.isPress = false
    for index, button in ipairs(ed.chatBattleReplay.buttonList) do
      if ed.containsPoint(button.detail_btn, x, y) then
        ed.chatBattleReplay.button = button.detail_btn
        ed.chatBattleReplay.buttonHandle = button.detail_handler
        ed.chatBattleReplay.isPress = true
      elseif ed.containsPoint(button.replay_btn, x, y) then
        ed.chatBattleReplay.button = button.replay_btn
        ed.chatBattleReplay.buttonHandle = button.replay_handler
        ed.chatBattleReplay.isPress = true
      end
    end
    if ed.chatBattleReplay.isPress then
      ed.pt(ed.chatBattleReplay.isPress)
      ed.chatBattleReplay.pxy = ccp(x, y)
    end
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), ed.chatBattleReplay.pxy)
    if 10 < dis then
      ed.chatBattleReplay.isPress = false
    end
  elseif event == "ended" and ed.chatBattleReplay.isPress and ed.containsPoint(ed.chatBattleReplay.button, x, y) and ed.chatBattleReplay.buttonHandle ~= nil then
    ed.chatBattleReplay.buttonHandle()
    ed.chatBattleReplay.buttonHandle = nil
    return true
  end
end

function chatBattleReplay.clear()
  ed.chatBattleReplay.buttonList = {}
  ed.chatBattleReplay.button = nil
  ed.chatBattleReplay.buttonHandle = nil
  ed.chatBattleReplay.pxy = ccp(0, 0)
  ed.chatBattleReplay.isPress = false
end
