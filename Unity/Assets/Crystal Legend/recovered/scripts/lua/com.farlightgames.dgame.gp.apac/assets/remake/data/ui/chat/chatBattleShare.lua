local chatBattleShareMgr = {}
chatBattleShareMgr.__index = chatBattleShareMgr
ed.chatBattleShareMgr = chatBattleShareMgr
ed.chatBattleShareMgr.buttonList = {}
local uiconfig, battleRoundNum, itemData, height, itemHeight
local battleType = ""
local record_data_table, battleMode, line_offset

function chatBattleShareMgr:initBattleShare(itemdata, height1)
  itemData = itemdata
  height = 0
  battleMode = itemData.extraData.acc._type
  uiconfig, battleRoundNum, itemHeight, line_offset = self:setUIConfig(itemData.extraData.acc)
  if battleMode == "pvp_replay" then
    battleType = "pvp"
  elseif battleMode == "top_pvp_replay" then
    battleType = "top_pvp"
  elseif battleMode == "binary_replay" then
    battleType = "tbc_pvp"
  elseif battleMode == "real_arena_replay" then
    battleType = "real_pvp"
  elseif battleMode == "babel_replay" then
    battleType = "babel"
  elseif battleMode == "multiarena_replay" then
    battleType = "multi_pvp"
  elseif battleMode == "dream_land_replay" then
    battleType = "dreamland_pve"
  elseif battleMode == "tbc_replay" then
    battleType = "tbc"
  end
  self:creatUiToView()
end

function chatBattleShareMgr:setUIConfig(data)
  local battleRoundNum = self:getBattleRoundNum(data._query_summary, data._type)
  if itemData.extraData.acc._type == "binary_replay" then
  end
  if battleRoundNum == 1 then
    return ed.uieditor.itemChatPvpOneBattlereport, battleRoundNum, 85, 5
  elseif battleRoundNum == 2 then
    return ed.uieditor.itemChatPvpTwoBattlereport, battleRoundNum, 165, 10
  elseif battleRoundNum == 3 then
    return ed.uieditor.itemChatPvpThreeBattlereport, battleRoundNum, 175, 15
  end
end

function chatBattleShareMgr:getBattleRoundNum(battleRoundData, battletype)
  if battletype == "babel_replay" then
    return 1
  end
  if battletype == "dreamland_pve" then
    return 1
  end
  if not battleRoundData then
    return 0
  end
  return #battleRoundData
end

function chatBattleShareMgr:creatUiToView()
  local ui = {}
  local container, ui = ed.editorui(uiconfig, {
    container = itemData.controllers.content_bg,
    ui = ui
  })
  ui.layer:setContentSize(CCSizeMake(390, itemData.ui_height))
  ui.layer:setAnchorPoint(ccp(0, 1))
  ui.layer:setScale(0.65)
  itemData.controllers.pvpview = ui
  local bubbleHeight = itemData.controllers.ui_bubble:getContentSize().height
  if itemData.isSelf then
    ui.layer:setPosition(ccp(10, -itemData.ui_height - 20))
  else
    ui.layer:setPosition(ccp(18, -itemData.ui_height - 20))
  end
  itemData.controllers.posY = bubbleHeight - 145
  self:initHeadData()
  self:initTeamData()
  self:initButton()
  if battleType == "pvp" then
    ui.pvp_ico:setVisible(true)
    ui.tbc_ico:setVisible(false)
    ui.top_ico:setVisible(false)
    ui.real_arena_ico:setVisible(false)
  elseif battleType == "tbc_pvp" or battleType == "tbc" then
    ui.pvp_ico:setVisible(false)
    ui.tbc_ico:setVisible(true)
    ui.top_ico:setVisible(false)
    ui.real_arena_ico:setVisible(false)
  elseif battleType == "top_pvp" then
    ui.pvp_ico:setVisible(false)
    ui.tbc_ico:setVisible(false)
    ui.top_ico:setVisible(true)
    ui.real_arena_ico:setVisible(false)
  elseif battleType == "real_pvp" then
    ui.pvp_ico:setVisible(false)
    ui.tbc_ico:setVisible(false)
    ui.top_ico:setVisible(false)
    ui.real_arena_ico:setVisible(true)
  elseif battleType == "babel" then
    ui.pvp_ico:setVisible(false)
    ui.tbc_ico:setVisible(false)
    ui.top_ico:setVisible(false)
    ui.real_arena_ico:setVisible(false)
  end
end

function chatBattleShareMgr:initButton()
  for i = 1, battleRoundNum do
    local statistics_button = itemData.controllers.pvpview["statistics_button_" .. i]
    local statistics_button_press = itemData.controllers.pvpview["statistics_button_" .. i .. "_press"]
    if battleType == "babel" then
      statistics_button:setVisible(false)
      statistics_button_press:setVisible(false)
    else
      local bttonHanler1 = {
        btn = statistics_button,
        btn_press = statistics_button_press,
        data = itemData.extraData.acc._query_summary[i],
        handler = function(data)
          if ed.checkIsCanClickChatLink() then
            return
          end
          ed.netdata.pvpQuerySummaryReply = {}
          ed.ui.battleStatist.create2(data, "pvp")
        end
      }
      table.insert(ed.chatBattleShareMgr.buttonList, bttonHanler1)
    end
    local sta_button = itemData.controllers.pvpview["sta_button_" .. i]
    local sta_button_press = itemData.controllers.pvpview["sta_button_" .. i .. "_press"]
    local bttonHanler2 = {
      btn = sta_button,
      btn_press = sta_button_press,
      data = record_data_table[i],
      round_index = i,
      mode = battleType,
      handler = function(data, mode, round_index)
        if ed.checkIsCanClickChatLink() then
          return
        end
        if mode == "pvp" or mode == "tbc_pvp" or mode == "real_pvp" or mode == "dreamland_pve" then
          ed.showReplay(data, mode)
        elseif mode == "top_pvp" then
          ed.chatBattleShareMgr:enterReplay(data, round_index)
        elseif mode == "multi_pvp" then
          ed.showReplay(data, "multi_arena")
        elseif mode == "tbc" then
          local stageid = itemData.extraData.acc._tbc_stage
          stageid = -2 - stageid
          ed.showReplay(data, "tbc", stageid)
        elseif mode == "babel" then
          local mode = "babel"
          local floorType = self:getFloorType(data)
          local stageid = data._oppo_userid
          local addtion = {
            babelReplayMode = {
              checkid = data._checkid
            }
          }
          if floorType == "monsterseal" then
            addtion = {
              babelMonstersealReplayMode = {
                checkid = data._checkid
              }
            }
          end
          ed.showReplay(data, mode, stageid, addtion)
        end
      end
    }
    table.insert(ed.chatBattleShareMgr.buttonList, bttonHanler2)
  end
end

function chatBattleShareMgr:getFloorType(data)
  local stageid = data._oppo_userid
  local floorid = self:getFlooridByStageid(stageid)
  local floorInfo = self:getFloorInfo(floorid)
  local floorType = floorInfo["Babel Type"]
  return floorType
end

local index, isPress

function chatBattleShareMgr:isHide(pnode)
  local node = pnode
  if not node then
    return false
  end
  if node:isVisible() == false then
    return true
  end
  while node:getParent() do
    if node:getParent():isVisible() == false then
      return true
    end
    node = node:getParent()
  end
  return false
end

function chatBattleShareMgr:touch(event, x, y)
  if event == "began" then
    for i = 1, #ed.chatBattleShareMgr.buttonList do
      local ic = ed.chatBattleShareMgr.buttonList[i]
      if ed.containsPoint2(ic.btn, x, y, 0.65) and not self:isHide(ic.btn) then
        isPress = true
        index = i
        ic.btn_press:setVisible(true)
      end
    end
    px = x
    py = y
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), ccp(px or 0, py or 0))
    if 10 < dis then
      isPress = false
      if index then
        ed.chatBattleShareMgr.buttonList[index].btn_press:setVisible(false)
      end
      index = nil
    end
  elseif event == "ended" then
    if not index then
      return
    end
    local ic = ed.chatBattleShareMgr.buttonList[index]
    if isPress and ed.containsPoint2(ic.btn, x, y, 0.7) and not self:isHide(ic.btn) then
      ic.btn_press:setVisible(false)
      if ic.mode then
        ic.handler(ic.data, ic.mode, ic.round_index)
      else
        ic.handler(ic.data)
      end
    end
    isPress = false
    index = nil
    px = nil
    py = nil
  end
end

function chatBattleShareMgr:getBattleResult()
  local victory = 0
  local defeat = 0
  for i, record_data in ipairs(record_data_table) do
    if record_data._result == "victory" or record_data._result == "honest" then
      victory = victory + 1
    elseif record_data._result == "defeat" then
      defeat = defeat + 1
    end
  end
  return victory > defeat
end

function chatBattleShareMgr:initTeamData()
  for i, data in ipairs(itemData.extraData.acc._query_summary) do
    if data._hero_data then
      self:creatHeroIcon(data._hero_data, i)
    end
  end
end

local teamPosRecord = {
  [1] = {
    [1] = {35, 30}
  },
  [2] = {
    [1] = {35, 85},
    [2] = {35, 30}
  },
  [3] = {
    [1] = {35, 140},
    [2] = {35, 85},
    [3] = {35, 30}
  }
}

function chatBattleShareMgr:creatHeroIcon(heroTeamList, index)
  local mCNum = 1
  local eCNum = 1
  local teamPos = teamPosRecord[battleRoundNum]
  for i, unit in ipairs(heroTeamList) do
    xpcall(function()
      if ed.emCampPlayer == unit._camp and mCNum <= 5 then
        local mSprite = CCSprite:create()
        mSprite:setPosition(ccp(teamPos[index][1] + (mCNum - 1) * 52, teamPos[index][2]))
        itemData.controllers.pvpview.L_board:addChild(mSprite)
        self:getIcon(unit, mSprite)
        mCNum = mCNum + 1
      elseif ed.emCampEnemy == unit._camp and eCNum <= 5 then
        local mSprite = CCSprite:create()
        mSprite:setPosition(ccp(teamPos[index][1] + (eCNum - 1) * 52, teamPos[index][2]))
        itemData.controllers.pvpview.board:addChild(mSprite)
        self:getIcon(unit, mSprite)
        eCNum = eCNum + 1
      end
    end, EDDebug)
  end
end

function chatBattleShareMgr:getIcon(UserInfo, panelSprite)
  local rank = UserInfo._rank
  local spriteIcon = ed.readhero.getIcon({
    id = UserInfo._tid,
    level = UserInfo._level,
    stars = UserInfo._stars,
    length = 45,
    rank = rank,
    summary = UserInfo
  })
  if UserInfo._hp and UserInfo._hp <= 0 then
    local die = ed.createttf(T("\229\183\178\233\152\181\228\186\161"), 21)
    ed.setLabelColor(die, ed.toccc3(16741231))
    ed.setLabelStroke(die, ed.toccc3(0), 2)
    die:setPosition(44, 65)
    spriteIcon:addChild(die, 10)
    local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade:setContentSize(spriteIcon:getContentSize())
    spriteIcon:addChild(shade)
  end
  panelSprite:addChild(spriteIcon)
end

function chatBattleShareMgr:initHeadData()
  record_data_table = {}
  if battleType == "pvp" or battleType == "tbc" then
    table.insert(record_data_table, itemData.extraData.acc._replay)
  end
  local record_data = record_data_table[1]
  local player = {
    ui_key = player_key,
    summary = {
      _avatar = record_data._avatar,
      _name = record_data._username,
      _vip = record_data._vip,
      _level = record_data._level
    },
    victory = function()
      return self:getBattleResult()
    end
  }
  local oppo = {
    ui_key = oppo_key,
    summary = {
      _avatar = record_data._oppo_avatar,
      _name = record_data._oppo_name,
      _vip = record_data._oppo_vip,
      _level = record_data._oppo_level
    },
    victory = function()
      return not self:getBattleResult()
    end
  }
  local cui = itemData.controllers.pvpview
  local summary = player.summary
  cui.L_tag_win:setVisible(false)
  cui.L_tag_lose:setVisible(false)
  if player.victory() then
    cui.L_tag_win:setVisible(true)
  else
    cui.L_tag_lose:setVisible(true)
  end
  local ct = cui.L_icon_container
  local headIcon = ed.getTeamHead({
    id = summary._avatar,
    length = ct:getContentSize().width,
    type = 0 < (summary._vip or 0) and "vip"
  })
  headIcon:setAnchorPoint(ccp(0, 0))
  ct:addChild(headIcon)
  if battleMode ~= "real_arena_replay" then
    local ct = cui.L_level_container
    local levelIcon = ed.getLevelIcon({
      level = summary._level,
      type = 0 < (summary._vip or 0) and "vip",
      vip = 0 < (summary._vip or 0),
      babelLevel = summary._babel_level
    })
    levelIcon:setAnchorPoint(ccp(0, 0))
    ct:addChild(levelIcon)
  end
  local ct = cui.L_name_label
  ed.setLabelString(ct, summary._name)
  if battleType == "babel" then
    cui.tag_win:setVisible(false)
    cui.tag_lose:setVisible(false)
    if oppo.victory() then
      cui.tag_win:setVisible(true)
    else
      cui.tag_lose:setVisible(true)
    end
    local stageid = record_data._oppo_userid
    local floorid = self:getFlooridByStageid(stageid)
    local stageDes = self:getStageDes(floorid, stageid)
    local posx = cui.name_label:getPositionX()
    cui.name_label:setPositionX(posx - 50)
    ed.setString(cui.name_label, stageDes)
  else
    summary = oppo.summary
    cui.tag_win:setVisible(false)
    cui.tag_lose:setVisible(false)
    if oppo.victory() then
      cui.tag_win:setVisible(true)
    else
      cui.tag_lose:setVisible(true)
    end
    ct = cui.icon_container
    headIcon = ed.getTeamHead({
      id = summary._avatar,
      length = ct:getContentSize().width,
      type = 0 < (summary._vip or 0) and "vip"
    })
    headIcon:setAnchorPoint(ccp(0, 0))
    ct:addChild(headIcon)
    if battleMode ~= "real_arena_replay" then
      local ct = cui.level_container
      local levelIcon = ed.getLevelIcon({
        level = summary._level,
        type = 0 < (summary._vip or 0) and "vip",
        vip = 0 < (summary._vip or 0),
        babelLevel = summary._babel_level
      })
      levelIcon:setAnchorPoint(ccp(0, 0))
      ct:addChild(levelIcon)
    end
    ct = cui.name_label
    ed.setLabelString(ct, summary._name)
  end
end

function chatBattleShareMgr:getFlooridByStageid(stageid)
  local babelTable = ed.getDataTable("Babel")
  for floorid, floorData in ipairs(babelTable) do
    local stages = floorData["Babel Stage ID"]
    for __, id in ipairs(stages) do
      if stageid == id then
        return floorid
      end
    end
  end
  return 1
end

function chatBattleShareMgr:getStageDes(floorid, stageid)
  local floorInfo = self:getFloorInfo(floorid)
  local stageIndex = self:getFloorStageIndex(floorInfo, stageid)
  local stageDes = "\229\164\169\231\169\186\232\166\129\229\161\158:" .. floorid .. "-" .. stageIndex
  return stageDes
end

function chatBattleShareMgr:getFloorInfo(floorid)
  local babelTable = ed.getDataTable("Babel")
  local floorInfo = babelTable[floorid]
  return floorInfo
end

function chatBattleShareMgr:getFloorStageIndex(floorInfo, stageid)
  local stageIds = floorInfo["Babel Stage ID"]
  for index, stageId in ipairs(stageIds) do
    if stageId == stageid then
      return index
    end
  end
  return 0
end

function chatBattleShareMgr:enterReplay(record_data, round_index)
  if not record_data then
    return
  end
  local mode = "pvp"
  local top_pvp_stage_id = {
    -28,
    -30,
    -31
  }
  local format_data = ed.copyProto(record_data)
  format_data._self_heroes = record_data._self_heroes._heroes
  format_data._oppo_heroes = record_data._oppo_heroes._heroes
  ed.ui.vcdLayer.setData(format_data, "toppvp")
  local stageid = top_pvp_stage_id[round_index]
  local stage = ed.lookupDataTable("Stage", nil, stageid)
  local battle = ed.lookupDataTable("Battle", nil, stageid, 1)
  local selfWarschool = ed.player:initFightWarschoolInfo(record_data._self_warschool_books or nil)
  local oppoWarschool = ed.player:initFightWarschoolInfo(record_data._oppo_warschool_books or nil)
  local info = {
    userId = record_data._userid,
    userName = record_data._username,
    userAvatar = record_data._avatar,
    vip = record_data._vip,
    oppoUserid = record_data._oppo_userid,
    oppoUserName = record_data._oppo_name,
    oppoUserAvatar = record_data._oppo_avatar,
    oppovip = record_data._oppo_vip,
    checkid = record_data._checkid,
    userMedal = record_data._self_medal,
    oppoMedal = record_data._oppo_medal
  }
  ed.srand(record_data._rseed)
  ed.engine:enterRelay({
    hero_list = record_data._self_heroes._heroes,
    hero_is_bot = 0 < (record_data._self_robot or 0),
    hero_warschool = selfWarschool,
    selfBookReadingLevel = record_data._self_bookreading_level,
    enemy_list = record_data._oppo_heroes._heroes,
    enemy_is_bot = 0 < (record_data._oppo_robot or 0),
    enemy_warschool = oppoWarschool,
    oppoBookReadingLevel = record_data._oppo_bookreading_level,
    stage_id = stageid,
    mode = mode,
    selfBonus = record_data._self_bonus or nil,
    oppoBonus = record_data._oppo_bonus or nil
  })
  ed.scene:reset(stage, battle, {replayInfo = info})
  ed.pushScene(ed.scene)
end
