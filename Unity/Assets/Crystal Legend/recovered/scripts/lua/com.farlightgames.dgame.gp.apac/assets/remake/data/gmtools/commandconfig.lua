local maxHeroRank = ed.parameter.unit_max_rank
local maxPlayerLevel = 80
local maxHeroLevel = maxPlayerLevel
local amostMaxHeroLevel = maxPlayerLevel - 10
local special_button_color = ccc3(128, 230, 15)
local toast_pos = ccp(400, 430)
ed.gmconfig = {attack_ratio = 1, exercise_open = nil}

local function getMaxRank(hid, level)
  for rk = 1, maxHeroRank do
    for i = 1, 6 do
      local iid = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", hid, rk)
      if iid ~= 0 then
        local rl = ed.getDataTable("equip")[iid]["Level Requirement"]
        if level < rl then
          return rk
        end
      end
    end
  end
  return maxHeroRank
end

local function getAlmostMaxRank(hid, level)
  for rk = 1, maxHeroRank do
    for i = 1, 6 do
      local iid = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", hid, rk)
      if iid ~= 0 then
        local rl = ed.getDataTable("equip")[iid]["Level Requirement"]
        if level < rl then
          return rk - 1
        end
      end
    end
  end
  return maxHeroRank - 2
end

local function getMaxReqLevel(hid, rank)
  local level = 0
  for i = 1, 6 do
    local iid = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", hid, rank)
    if iid ~= 0 then
      local rl = ed.getDataTable("equip")[iid]["Level Requirement"]
      if level < rl then
        level = rl
      end
    end
  end
  return level
end

local function getAllHeroMaxReqLevel(rank)
  local reqLevel = 0
  for hid, hero in pairs(ed.player.heroes) do
    local thisReqLevel = getMaxReqLevel(hid, rank)
    if reqLevel < thisReqLevel then
      reqLevel = thisReqLevel
    end
  end
  return reqLevel
end

local function getSkillLevels(hero, level)
  if not hero then
    return
  end
  local levels = {}
  local skills = ed.getAllSkills(hero._tid)
  for i, v in pairs(skills) do
    if v["Subordinate To"] == 0 and #v["School SkillGroup KN"] == 0 then
      levels[v.Slot] = level
    end
  end
  local baseSkillSlot = 5
  levels[baseSkillSlot] = 1
  local keys = {}
  for key, _ in pairs(levels) do
    table.insert(keys, key)
  end
  table.sort(keys)
  local sortLevels = {}
  for _, key in ipairs(keys) do
    table.insert(sortLevels, levels[key])
  end
  return sortLevels
end

local function imIsTyrant(rn, nextAction)
  ed.showAlertDialog({
    text = string.format("%s\231\186\167\229\156\159\232\177\170\230\136\145\228\187\172\229\129\154\230\156\139\229\143\139\229\144\167\239\188\129\n\239\188\136\232\131\189\232\191\155\233\152\182\228\184\128\229\174\154\232\191\155\233\152\182\239\188\137", rn),
    buttonText = "\229\165\189\229\144\167",
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "diamond"
      msg._set_money._amount = 9999999
      msg._set_hero_info = {}
      local index = 1
      local hero_list = {}
      for id, hero in pairs(ed.player.heroes) do
        local h = ed.commonmsg.hero()
        h._tid = hero._tid
        h._level = rn
        h._stars = 5
        h._rank = getMaxRank(h._tid, h._level)
        h._exp = 0
        h._gs = 5000
        h._state = "idle"
        h._items = {}
        h._fashion = nil
        for i = 1, 6 do
          local item = ed.commonmsg.hero_equip()
          item._index = i
          item._item_id = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", h._tid, h._rank)
          item._exp = 0
          h._items[i] = item
        end
        h._skill_levels = getSkillLevels(h, h._level)
        local shards = ed.heroDetailManager.shardList[hero._tid]
        if shards then
          h._shard = {
            _id = shards[1],
            _level = 25
          }
        end
        table.insert(hero_list, h)
      end
      for k = 1, math.floor(#hero_list / 2) do
        local hero = hero_list[k]
        table.insert(msg._set_hero_info, hero)
      end
      
      function ed.gmNetReplyHander()
        ed.gmNetReplyHander = nil
        msg._set_hero_info = {}
        for k = math.floor(#hero_list / 2) + 1, #hero_list do
          local hero = hero_list[k]
          table.insert(msg._set_hero_info, hero)
        end
        ed.send(msg, "gm_cmd")
      end
      
      ed.send(msg, "gm_cmd")
      if nextAction then
        nextAction()
      end
    end
  })
end

local command_config = {
  [1] = {
    name = "\230\136\145\230\152\175\229\156\159\232\177\170",
    label = string.format("\230\136\145\230\152\175\229\156\159\232\177\170\n\239\188\136\233\187\152\232\174\164%s\231\186\167\239\188\137", maxHeroLevel),
    icon = "z10005_s.jpg",
    pos = ccp(-1, 1),
    size = CCSizeMake(200, 60),
    handler = function(self, nextAction)
      local rn = math.min(tonumber(self.number:getText()) or maxHeroLevel, maxHeroLevel)
      local msg = ed.upmsg.gm_cmd()
      msg._unlock_all_stages = 1
      msg._get_all_heroes = 1
      msg._set_recharge_sum = 999999
      msg._set_player_level = rn
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "gold"
      msg._set_money._amount = 99999999
      msg._set_items = {}
      for id, item in pairs(ed.getDataTable("equip")) do
        if type(id) == "number" then
          local item = ed.commonmsg.item()
          item._id = id
          item._amount = 0
          table.insert(msg._set_items, item)
        end
      end
      ed.send(msg, "gm_cmd")
      imIsTyrant(rn, nextAction)
    end
  },
  [2] = {
    name = "\228\184\128\233\148\174\233\153\164\229\176\152",
    label = "\228\184\128\233\148\174\233\153\164\229\176\152",
    icon = "s454.jpg",
    pos = ccp(-1, 3),
    size = CCSizeMake(200, 60),
    handler = function()
      ed.guide.manager:skipAllGuide()
      ed.showToast("\229\183\178\229\142\187\233\153\164\230\137\128\230\156\137\230\150\176\230\137\139\229\188\149\229\175\188", toast_pos)
    end
  },
  [3] = {
    name = "\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161",
    label = "\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161",
    icon = "1308.jpg",
    pos = ccp(0, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._unlock_all_stages = 65536
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161", toast_pos)
    end
  },
  [4] = {
    name = "\229\191\171\233\128\159\233\135\141\229\187\186\232\180\166\229\143\183",
    label = T("\229\191\171\233\128\159\233\135\141\229\187\186\232\180\166\229\143\183"),
    icon = "971.jpg",
    pos = ccp(21, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local actions = {
        self:getButtonConfigByLabel(T("\229\136\160\229\143\183\233\135\141\231\187\131")).handler,
        self:getButtonConfigByLabel(T("\228\184\128\233\148\174\233\153\164\229\176\152")).handler,
        self:getButtonConfigByLabel(string.format(T("\230\136\145\230\152\175\229\156\159\232\177\170\n\239\188\136\233\187\152\232\174\164%s\231\186\167\239\188\137"), maxHeroLevel)).handler,
        self:getButtonConfigByLabel(T("\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161")).handler
      }
      local gapTime = 0.5
      local delayTime = 0
      for i = 1, 3 do
        local v = actions[i]
        delayTime = delayTime + gapTime
        local nextAction
        if i == 3 then
          function nextAction()
            delayTime = 0
            
            delayTime = delayTime + gapTime
            ListenTimer(Timer:Once(delayTime), function()
              actions[4](self)
            end)
          end
        end
        ListenTimer(Timer:Once(delayTime), function()
          v(self, nextAction)
        end)
      end
    end
  },
  [5] = {
    name = "\229\136\160\229\143\183\233\135\141\231\187\131",
    label = "\229\136\160\229\143\183\233\135\141\231\187\131",
    icon = "s595.jpg",
    pos = ccp(-1, 2),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._reset_device = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\136\160\229\143\183\233\135\141\231\187\131", toast_pos)
    end
  },
  [6] = {
    name = "\230\136\152\233\152\159\229\141\135\231\186\167\232\135\179",
    label = T("\230\136\152\233\152\159\229\141\135\231\186\167\232\135\179"),
    icon = "1253.jpg",
    pos = ccp(2, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      local num = tonumber(self.number:getText()) or 1
      num = math.min(num, maxPlayerLevel)
      num = math.max(num, 1)
      msg._set_player_level = num
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\136\152\233\152\159\229\141\135\231\186\167\232\135\179") .. num .. T("\231\186\167"), toast_pos)
    end
  },
  [7] = {
    name = "\232\142\183\229\190\151\230\137\128\230\156\137\232\139\177\233\155\132",
    label = T("\232\142\183\229\190\151\230\137\128\230\156\137\232\139\177\233\155\132"),
    icon = "1011.jpg",
    pos = ccp(-1, 5),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._get_all_heroes = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\137\128\230\156\137\232\139\177\233\155\132"), toast_pos)
    end
  },
  [8] = {
    name = "\232\139\177\233\155\132\229\141\135\233\152\182\229\136\176",
    label = T("\232\139\177\233\155\132\229\141\135\233\152\182\229\136\176"),
    icon = "1011.jpg",
    pos = ccp(-1, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local num = tonumber(self.number:getText()) or 1
      num = math.min(math.max(num, 1), maxHeroLevel)
      for id, hero in pairs(ed.player.heroes) do
        hero._level = math.min(maxHeroLevel, num * 10)
        if 6 < num then
          hero._level = 69 + num
        end
        hero._level = math.min(maxHeroLevel, hero._level)
        hero._rank = math.min(num, maxHeroRank)
        hero._skill_levels = getSkillLevels(hero, hero._level)
        for i, item in ipairs(hero._items) do
          item._item_id = 0
          item._exp = 0
        end
      end
      ed.ui.newgm:syncHero()
      ed.showToast("\230\137\128\230\156\137\232\139\177\233\155\132\233\152\182\229\136\176" .. num .. T("\231\186\167"), toast_pos)
    end
  },
  [9] = {
    name = "\230\183\187\229\138\160\233\129\147\229\133\183",
    label = T("\230\183\187\229\138\160\233\129\147\229\133\183"),
    icon = "x24.jpg",
    pos = ccp(2, 5),
    size = CCSizeMake(200, 60),
    handler = function()
      package.loaded["gmtools/addequip"] = nil
      require("gmtools/addequip")
      ed.pushScene(ed.ui.addequip.create())
    end
  },
  [10] = {
    name = "\232\142\183\229\190\151\230\137\128\230\156\137\232\163\133\229\164\135",
    label = T("\232\142\183\229\190\151\230\137\128\230\156\137\232\163\133\229\164\135"),
    icon = "b8_0.jpg",
    pos = ccp(2, 4),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._gain_all_items = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\137\128\230\156\137\232\163\133\229\164\135"), toast_pos)
    end
  },
  [11] = {
    name = "\230\184\133\233\153\164\230\137\128\230\156\137\232\163\133\229\164\135",
    label = T("\230\184\133\233\153\164\230\137\128\230\156\137\232\163\133\229\164\135"),
    icon = "b27_0.jpg",
    pos = ccp(8, 6),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._clear_item = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\184\133\233\153\164\230\137\128\230\156\137\232\163\133\229\164\135"), toast_pos)
    end
  },
  [12] = {
    name = "\232\142\183\229\190\151\233\135\145\233\146\177",
    label = T("\232\142\183\229\190\151\233\135\145\233\146\177"),
    icon = "955.jpg",
    pos = ccp(0, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "gold"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\233\135\145\233\146\177\239\188\154") .. number, toast_pos)
    end
  },
  [13] = {
    name = "\232\142\183\229\190\151\233\146\187\231\159\179",
    label = T("\232\142\183\229\190\151\233\146\187\231\159\179"),
    icon = "957.jpg",
    pos = ccp(0, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "diamond"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\233\146\187\231\159\179" .. number, msg._set_recharge_sum), toast_pos)
    end
  },
  [14] = {
    name = "\230\184\133\233\153\164\233\146\187\231\159\179",
    label = "\230\184\133\233\153\164\233\146\187\231\159\179",
    icon = "s614.jpg",
    pos = ccp(3, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      local rn = 0
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "diamond"
      msg._set_money._amount = rn
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\184\133\233\153\164\233\146\187\231\159\179"), toast_pos)
    end
  },
  [15] = {
    name = "\230\184\133\233\153\164\233\135\145\233\146\177",
    label = "\230\184\133\233\153\164\233\135\145\233\146\177",
    icon = "s650.jpg",
    pos = ccp(3, 6),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "gold"
      msg._set_money._amount = 0
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\184\133\233\153\164\233\135\145\233\146\177", toast_pos)
    end
  },
  [16] = {
    name = T("\229\133\133\229\128\188"),
    label = T("\229\133\133\229\128\188"),
    icon = "1650.jpg",
    pos = ccp(0, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      local rn = tonumber(self.number:getText()) or 9999999
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "diamond"
      msg._set_money._amount = rn + ed.player._rmb
      msg._set_recharge_sum = ed.player._vip_exp + rn
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\133\229\128\188%d\233\146\187\231\159\179", rn), toast_pos)
    end
  },
  [17] = {
    name = "\229\133\133\229\128\188\230\184\133\233\155\182",
    label = T("\229\133\133\229\128\188\230\184\133\233\155\182"),
    icon = "s260.jpg",
    pos = ccp(3, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_recharge_sum = 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\133\229\128\188\230\184\133\233\155\182"), toast_pos)
    end
  },
  [18] = {
    name = "\232\142\183\229\143\150\229\134\176\229\134\176\229\184\129",
    label = T("\232\142\183\229\143\150\229\134\176\229\134\176\229\184\129"),
    icon = "s260.jpg",
    pos = ccp(3, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      ed.showToast(T("\229\183\178\229\186\159\229\188\131"), toast_pos)
    end
  },
  [19] = {
    name = "\232\174\190\231\189\174\232\191\156\229\190\129\233\152\181\229\174\185",
    label = T("\232\174\190\231\189\174\232\191\156\229\190\129\233\152\181\229\174\185"),
    icon = "1298.jpg",
    pos = ccp(18, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_tbc_oppos = ed.upmsg.set_tbc_oppos()
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\191\156\229\190\129\233\152\181\229\174\185\230\136\144\229\138\159"), toast_pos)
    end
  },
  [20] = {
    name = "\233\135\141\231\189\174\232\191\156\229\190\129\230\140\145\230\136\152\230\172\161\230\149\176",
    label = "\233\135\141\231\189\174\232\191\156\229\190\129\230\140\145\230\136\152\230\172\161\230\149\176",
    icon = "1082.jpg",
    pos = ccp(17, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 999
      local msg = ed.upmsg.gm_cmd()
      msg._reset_tbc_use_count = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\233\135\141\231\189\174\232\191\156\229\190\129" .. number, toast_pos)
    end
  },
  [21] = {
    name = "\232\174\190\231\189\174\229\183\177\230\150\185\228\188\164\229\174\179\229\128\141\231\142\135",
    id = "atk_ratio",
    label = "\232\174\190\231\189\174\229\183\177\230\150\185\228\188\164\229\174\179\229\128\141\231\142\135\n\229\189\147\229\137\141\239\188\154" .. ed.gmconfig.attack_ratio,
    icon = "113.jpg",
    pos = ccp(1, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local num = tonumber(self.number:getText()) or 0
      ed.gmconfig.attack_ratio = num
      ed.setString(self.buttonLabel.atk_ratio, "\232\174\190\231\189\174\229\183\177\230\150\185\228\188\164\229\174\179\229\128\141\231\142\135\n\229\189\147\229\137\141\239\188\154" .. ed.gmconfig.attack_ratio)
      ed.showToast(string.format("\229\183\177\230\150\185\232\139\177\233\155\132\228\188\164\229\174\179\229\128\141\231\142\135\232\174\190\231\189\174\228\184\186%d\229\128\141", num))
    end
  },
  [22] = {
    label = T("\232\183\179\232\191\135\230\136\152\230\150\151\230\160\161\233\170\140"),
    icon = "1298.jpg",
    pos = ccp(19, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._skip_battlecheck = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\183\179\232\191\135\230\136\152\230\150\151\230\160\161\233\170\140", toast_pos)
    end
  },
  [23] = {
    name = "\230\159\165\231\156\139\229\189\149\229\131\143",
    label = "\230\159\165\231\156\139\229\189\149\229\131\143",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local text = self.number:getText()
      local recordid, serverid = self:getQueryReplayParam(text)
      print("recordid,serverid,round", recordid, serverid)
      local msg = ed.upmsg.gm_ext()
      msg._query_replay = ed.upmsg.gm_query_replay()
      msg._query_replay._check_id = recordid
      if serverid then
        msg._query_replay._server_id = serverid
      end
      ed.send(msg, "gm_ext")
    end
  },
  [24] = {
    name = "\230\129\162\229\164\141\228\189\147\229\138\155\229\128\188",
    label = "\230\129\162\229\164\141\228\189\147\229\138\155\229\128\188",
    icon = "505.jpg",
    pos = ccp(15, 3),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._set_vitality = 10000
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\129\162\229\164\141\228\189\147\229\138\155\229\128\188", toast_pos)
    end
  },
  [25] = {
    name = "\232\174\190\231\189\174\229\183\165\228\188\154\230\136\152\232\131\156\229\156\186\230\149\176",
    label = "\232\174\190\231\189\174\229\183\165\228\188\154\230\136\152\232\131\156\229\156\186\230\149\176",
    icon = "z23.jpg",
    pos = ccp(15, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      if 8 < number then
        number = 8
      end
      local msg = ed.upmsg.gm_cmd()
      msg._set_gvg_win = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\229\183\165\228\188\154\230\136\152\232\131\156\229\156\186\230\149\176" .. number, toast_pos)
    end
  },
  [26] = {
    name = "\232\139\177\233\155\132\229\141\135\231\186\167\229\136\176",
    label = T("\232\139\177\233\155\132\229\141\135\231\186\167\229\136\176"),
    icon = "s15.jpg",
    pos = ccp(2, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local num = tonumber(self.number:getText()) or 1
      num = math.min(math.max(num, 1), maxHeroLevel)
      for id, hero in pairs(ed.player.heroes) do
        hero._level = num
        hero._rank = math.ceil(num / 10)
        hero._skill_levels = getSkillLevels(hero, hero._level)
        for i, item in ipairs(hero._items) do
          item._item_id = 0
          item._exp = 0
        end
      end
      ed.ui.newgm:syncHero()
      ed.showToast("\230\137\128\230\156\137\232\139\177\233\155\132\229\141\135\231\186\167\229\136\176" .. num .. T("\231\186\167"), toast_pos)
    end
  },
  [27] = {
    name = "\232\139\177\233\155\132\232\191\155\229\140\150\229\136\176",
    label = T("\232\139\177\233\155\132\232\191\155\229\140\150\229\136\176"),
    icon = "564.jpg",
    pos = ccp(2, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local num = tonumber(self.number:getText()) or 1
      local stars = math.min(math.max(num, 1), 5)
      for id, hero in pairs(ed.player.heroes) do
        if hero:isTitan() then
          hero._stars = math.min(math.max(num, 1), 10)
        else
          hero._stars = stars
        end
      end
      ed.ui.newgm:syncHero()
      ed.showToast("\230\137\128\230\156\137\232\139\177\233\155\132\232\191\155\229\140\150\229\136\176" .. num .. "\230\152\159", toast_pos)
    end
  },
  [28] = {
    name = "\232\139\177\233\155\132\230\138\128\232\131\189\230\187\161\231\186\167",
    label = T("\232\139\177\233\155\132\230\138\128\232\131\189\230\187\161\231\186\167"),
    icon = "s14.jpg",
    pos = ccp(3, 3),
    size = CCSizeMake(200, 60),
    handler = function()
      for id, hero in pairs(ed.player.heroes) do
        local level = hero._level
        hero._skill_levels = getSkillLevels(hero, level)
      end
      ed.ui.newgm:syncHero()
      ed.showToast(T("\232\139\177\233\155\132\230\138\128\232\131\189\230\187\161\231\186\167"), toast_pos)
    end
  },
  [29] = {
    name = "\232\139\177\233\155\132\230\138\128\232\131\189\233\135\141\231\189\174",
    label = T("\232\139\177\233\155\132\230\138\128\232\131\189\233\135\141\231\189\174"),
    icon = "s180.jpg",
    pos = ccp(4, 1),
    size = CCSizeMake(200, 60),
    handler = function()
      for id, hero in pairs(ed.player.heroes) do
        hero._skill_levels = getSkillLevels(hero, 1)
      end
      ed.ui.newgm:syncHero()
      ed.showToast(T("\232\139\177\233\155\132\230\138\128\232\131\189\233\135\141\231\189\174"), toast_pos)
    end
  },
  [30] = {
    name = "\229\188\128\229\144\175\229\133\179\229\141\161",
    label = "\229\188\128\229\144\175\229\133\179\229\141\161",
    icon = "716.jpg",
    pos = ccp(0, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local num = self:getInput(65536)
      local msg = ed.upmsg.gm_cmd()
      msg._unlock_all_stages = num
      ed.send(msg, "gm_cmd")
      if num == 65536 then
        ed.showToast("\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161", toast_pos)
      else
        ed.showToast("\229\188\128\229\144\175\229\136\176" .. num .. "\229\133\179", toast_pos)
      end
    end
  },
  [31] = {
    name = "\232\191\155\229\133\165\229\133\179\229\141\161",
    label = "\232\191\155\229\133\165\229\133\179\229\141\161",
    icon = "b23_0.jpg",
    pos = ccp(0, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = tonumber(self.number:getText())
      if not number then
        ed.showToast("\232\175\183\232\190\147\229\133\165\229\133\179\229\141\161ID", toast_pos)
        return
      end
      local id = number
      ed.pushScene(ed.ui.battleprepare.create({stage_id = id}))
    end
  },
  [32] = {
    name = "\232\191\156\229\190\129\229\188\128\229\144\175\229\133\179\229\141\161\230\149\176",
    label = "\232\191\156\229\190\129\229\188\128\229\144\175\229\133\179\229\141\161\230\149\176",
    icon = "1082.jpg",
    pos = ccp(16, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_tbc_stage = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\188\128\229\144\175\232\191\156\229\190\129\229\133\179\229\141\161\229\188\128\229\144\175" .. number, toast_pos)
    end
  },
  [33] = {
    name = "\230\136\152\230\150\151\230\160\161\233\170\140",
    label = T("\230\136\152\230\150\151\230\160\161\233\170\140"),
    icon = "s100.jpg",
    pos = ccp(11, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      if not ed.testBattleCheck then
        ed.testBattleCheck = require("battle.test_battle_check"):new()
      end
      ed.testBattleCheck:battleCheckEnterStage(self:getInputString())
    end
  },
  [34] = {
    name = "\232\142\183\229\143\150\229\190\189\231\171\160",
    label = T("\232\142\183\229\143\150\229\190\189\231\171\160"),
    icon = "1102.jpg",
    pos = ccp(13, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      local rn = tonumber(self.number:getText()) or 0
      msg._get_medal = rn
      ed.send(msg, "gm_cmd")
      if rn == 0 then
        ed.showToast(T("\232\142\183\229\190\151\230\137\128\230\156\137\229\190\189\231\171\160"), toast_pos)
      else
        ed.showToast(T("\232\142\183\229\190\151\229\190\189\231\171\160%d", rn), toast_pos)
      end
    end
  },
  [35] = {
    name = "\232\142\183\229\143\150\228\187\152\232\180\185\230\156\136\229\141\161",
    label = T("\232\142\183\229\143\150\228\187\152\232\180\185\230\156\136\229\141\161"),
    icon = "1298.jpg",
    pos = ccp(19, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._get_monthcard = "payed"
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\143\150\228\187\152\232\180\185\230\156\136\229\141\161"))
    end
  },
  [36] = {
    name = "\232\142\183\229\190\151\230\176\184\228\185\133\230\156\136\229\141\161",
    label = "\232\142\183\229\190\151\230\176\184\228\185\133\230\156\136\229\141\161",
    icon = "536.jpg",
    pos = ccp(7, 4),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._get_monthcard = "free"
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\176\184\228\185\133\230\156\136\229\141\161"))
    end
  },
  [37] = {
    name = "\232\142\183\229\190\151\232\191\156\229\190\129\231\161\172\229\184\129",
    label = T("\232\142\183\229\190\151\232\191\156\229\190\129\231\161\172\229\184\129"),
    icon = "s33.jpg",
    pos = ccp(4, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "crusadepoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\233\190\153\233\179\158\231\161\172\229\184\129\239\188\154") .. number, toast_pos)
    end
  },
  [38] = {
    name = "\232\142\183\229\190\151\231\171\158\230\138\128\229\156\186\231\161\172\229\184\129",
    label = T("\232\142\183\229\190\151\231\171\158\230\138\128\229\156\186\231\161\172\229\184\129"),
    icon = "x673.jpg",
    pos = ccp(4, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "arenapoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\232\167\146\230\150\151\229\163\171\231\161\172\229\184\129\239\188\154") .. number, toast_pos)
    end
  },
  [39] = {
    name = "\232\142\183\229\190\151\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129",
    label = T("\232\142\183\229\190\151\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129"),
    icon = "s985.jpg",
    pos = ccp(5, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "guildpoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129\239\188\154") .. number, toast_pos)
    end
  },
  [40] = {
    name = "\232\142\183\229\190\151\229\183\133\229\179\176\231\161\172\229\184\129",
    label = T("\232\142\183\229\190\151\229\183\133\229\179\176\231\161\172\229\184\129"),
    icon = "s203.jpg",
    pos = ccp(7, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_peak_arena_coins = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\143\150\229\183\133\229\179\176\229\184\129") .. number)
    end
  },
  [41] = {
    name = "\230\184\133\233\153\164\232\191\156\229\190\129\231\161\172\229\184\129",
    label = "\230\184\133\233\153\164\232\191\156\229\190\129\231\161\172\229\184\129",
    icon = "s10160.jpg",
    pos = ccp(4, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "crusadepoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\184\133\233\153\164\232\191\156\229\190\129\231\161\172\229\184\129\239\188\154", toast_pos)
    end
  },
  [42] = {
    name = "\230\184\133\233\153\164\231\171\158\230\138\128\229\156\186\231\161\172\229\184\129",
    label = "\230\184\133\233\153\164\231\171\158\230\138\128\229\156\186\231\161\172\229\184\129",
    icon = "s10295.jpg",
    pos = ccp(4, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "arenapoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\184\133\233\153\164\232\167\146\230\150\151\229\163\171\231\161\172\229\184\129\239\188\154", toast_pos)
    end
  },
  [43] = {
    name = "\230\184\133\233\153\164\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129",
    label = "\230\184\133\233\153\164\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129",
    icon = "s735.jpg",
    pos = ccp(5, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "guildpoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\184\133\233\153\164\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129\239\188\154", toast_pos)
    end
  },
  [44] = {
    name = "\230\184\133\233\153\164\229\183\133\229\179\176\231\161\172\229\184\129",
    label = "\230\184\133\233\153\164\229\183\133\229\179\176\231\161\172\229\184\129",
    icon = "s195.jpg",
    pos = ccp(7, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._add_peak_arena_coins = 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\184\133\233\153\164\229\183\133\229\179\176\229\184\129"))
    end
  },
  [45] = {
    name = "\232\142\183\229\190\151\229\190\129\230\156\141\231\161\172\229\184\129",
    label = "\232\142\183\229\190\151\229\190\129\230\156\141\231\161\172\229\184\129",
    icon = "s112.jpg",
    pos = ccp(8, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "gvgpoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\229\190\129\230\156\141\231\161\172\229\184\129\239\188\154") .. number, toast_pos)
    end
  },
  [46] = {
    name = "\232\142\183\229\190\151\230\162\166\229\162\131\229\184\129",
    label = T("\232\142\183\229\190\151\230\162\166\229\162\131\229\184\129"),
    icon = "b28_0.jpg",
    pos = ccp(8, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "dreampoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\162\166\229\162\131\229\184\129\239\188\154") .. number, toast_pos)
    end
  },
  [47] = {
    name = "\232\142\183\229\190\151\228\188\160\229\165\135\229\184\129",
    label = "\232\142\183\229\190\151\228\188\160\229\165\135\229\184\129",
    icon = "1082.jpg",
    pos = ccp(16, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_legend_point = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\142\183\229\190\151\228\188\160\229\165\135\229\184\129" .. number, toast_pos)
    end
  },
  [48] = {
    name = "\232\142\183\229\190\151\230\136\152\233\152\159\231\187\143\233\170\140",
    label = "\232\142\183\229\190\151\230\136\152\233\152\159\231\187\143\233\170\140",
    pos = ccp(1, 6),
    size = CCSizeMake(100, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      local rn = tonumber(self.number:getText()) or 1
      ed.player:addExp(rn)
      msg._set_player_level = ed.player:getLevel()
      msg._set_player_exp = ed.player:getExp()
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151%d\230\136\152\233\152\159\231\187\143\233\170\140", rn), toast_pos)
    end
  },
  [49] = {
    name = "\232\174\190\231\189\174\229\133\141\232\180\185\230\137\171\232\141\161\230\172\161\230\149\176",
    label = "\232\174\190\231\189\174\229\133\141\232\180\185\230\137\171\232\141\161\230\172\161\230\149\176",
    icon = "390.jpg",
    pos = ccp(3, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._reset_sweep = tonumber(self.number:getText()) or 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\141\232\180\185\230\137\171\232\141\161\230\172\161\230\149\176\231\189\174\228\184\186%d\230\172\161", msg._reset_sweep), toast_pos)
    end
  },
  [50] = {
    name = T("\232\142\183\229\190\151\233\153\144\230\151\182\233\129\147\229\133\183"),
    label = T("\232\142\183\229\190\151\233\153\144\230\151\182\233\129\147\229\133\183"),
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      local timelys = ed.common.item()
      timelys._id = number or 1
      timelys._amount = 1
      msg._set_timely_items = timelys
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\233\153\144\230\151\182\233\129\147\229\133\183"))
    end
  },
  [51] = {
    name = T("\232\142\183\229\190\151\229\185\187\231\148\159\231\131\155"),
    label = T("\232\142\183\229\190\151\229\185\187\231\148\159\231\131\155"),
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_candle_count = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\229\185\187\231\148\159\231\131\155"))
    end
  },
  [52] = {
    name = T("\232\174\190\231\189\174\229\185\187\229\162\131\229\161\148\230\140\145\230\136\152\229\177\130\230\149\176"),
    label = T("\232\174\190\231\189\174\229\185\187\229\162\131\229\161\148\230\140\145\230\136\152\229\177\130\230\149\176"),
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_fancy_tower_floor = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\185\187\229\162\131\229\161\148\230\140\145\230\136\152\229\177\130\230\149\176"))
    end
  },
  [53] = {
    name = "\230\152\190\231\164\186FPS",
    label = "\230\152\190\231\164\186FPS",
    pos = ccp(1, 6),
    size = CCSizeMake(95, 60),
    color = special_button_color,
    handler = function(self)
      local isShow = CCDirector:sharedDirector():isDisplayStats()
      CCDirector:sharedDirector():setDisplayStats(not isShow)
      ed.ui.server_ping:showPing(not isShow)
      ed.ui.server_ping:showBattleFPS(not isShow)
    end
  },
  [54] = {
    name = "\232\174\190\231\189\174\232\139\177\233\155\132\230\138\128\232\131\189\231\173\137\231\186\167",
    label = "\232\174\190\231\189\174\232\139\177\233\155\132\230\138\128\232\131\189\231\173\137\231\186\167",
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_hero_skill_level = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\139\177\233\155\132\230\138\128\232\131\189\231\173\137\231\186\167"))
    end
  },
  [55] = {
    name = "\232\174\190\231\189\174\232\139\177\233\155\132\230\138\128\232\131\189\233\152\182\230\149\176",
    label = "\232\174\190\231\189\174\232\139\177\233\155\132\230\138\128\232\131\189\233\152\182\230\149\176",
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_hero_skill_evo = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\139\177\233\155\132\230\138\128\232\131\189\233\152\182\230\149\176"))
    end
  },
  [56] = {
    name = "\230\129\162\229\164\141\232\139\177\233\155\132\232\175\149\231\130\188\230\172\161\230\149\176",
    label = "\230\129\162\229\164\141\232\139\177\233\155\132\232\175\149\231\130\188\230\172\161\230\149\176",
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._clear_act_stage = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\129\162\229\164\141\232\139\177\233\155\132\232\175\149\231\130\188\230\172\161\230\149\176"))
    end
  },
  [57] = {
    name = "\229\143\145\229\164\154\229\176\145\230\156\137\233\153\132\228\187\182\233\149\191\233\130\174\228\187\182",
    label = "\229\143\145\229\164\154\229\176\145\230\156\137\233\153\132\228\187\182\233\149\191\233\130\174\228\187\182",
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._send_long_mail = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\143\145\229\164\154\229\176\145\230\156\137\233\153\132\228\187\182\233\149\191\233\130\174\228\187\182"))
    end
  },
  [58] = {
    name = "\229\143\145\229\164\154\229\176\145\229\176\129\231\159\173\233\130\174\228\187\182",
    label = "\229\143\145\229\164\154\229\176\145\229\176\129\231\159\173\233\130\174\228\187\182",
    pos = ccp(2, 6),
    size = CCSizeMake(95, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._send_small_mail = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\143\145\229\164\154\229\176\145\229\176\129\231\159\173\233\130\174\228\187\182"))
    end
  },
  [59] = {
    name = "\230\160\161\233\170\140Player\230\149\176\230\141\174",
    label = T("\230\160\161\233\170\140Player\230\149\176\230\141\174"),
    icon = "s10135.jpg",
    color = special_button_color,
    pos = ccp(13, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      function ed.netreply.gmCheckPlayerDataCallback(data)
        ed.gmCheckPlayerData = false
        
        local tip = ""
        tip = tip .. "rmb "
        if ed.player._rmb ~= data._rmb then
          tip = tip .. "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        else
          tip = tip .. "good \n"
        end
        tip = tip .. "money "
        if ed.player._money ~= data._money then
          tip = tip .. "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        else
          tip = tip .. "good \n"
        end
        tip = tip .. "vitality "
        if ed.player:getVitality() ~= data._vitality._current then
          tip = tip .. "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        else
          tip = tip .. "good \n"
        end
        tip = tip .. "items "
        local itemAllGood = true
        for _, v in pairs(data._items or {}) do
          local item = ed.analyzeItem(v)
          if not ed.player.equip_qunty[item.id] or ed.player.equip_qunty[item.id] ~= item.amount then
            itemAllGood = false
            tip = tip .. item.id .. " "
          end
        end
        if itemAllGood then
          tip = tip .. "good \n"
        else
          tip = tip .. "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        end
        tip = tip .. "heroes "
        local heroAllGood = true
        for k, v in pairs(data._heroes) do
          local hero = ed.player:getHero(v._tid)
          if not hero or not ed.tableEqual(hero.data, v) then
            heroAllGood = false
            tip = tip .. k .. " "
          end
        end
        if heroAllGood then
          tip = tip .. "good \n"
        else
          tip = tip .. "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        end
        tip = tip .. "level "
        if ed.player:getLevel() ~= data._level then
          tip = tip .. "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        else
          tip = tip .. "good \n"
        end
        tip = tip .. "exp "
        if ed.player:getExp() ~= data._exp then
          tip = tip .. "ERROR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n"
        else
          tip = tip .. "good \n"
        end
        ed.showToast(tip)
      end
      
      ed.gmCheckPlayerData = true
      local loginLanguage = {
        cn = "seazh",
        en = "seaen",
        thai = "seath"
      }
      local login = ed.upmsg.login()
      login._active_code = 0
      login._old_deviceid = ed.ui.serverlogin.getOldDeviceId()
      login._version = ed.ui.serverlogin.getClientVersion()
      login._os = EDGetParam("deviceOS") or ""
      login._os_version = EDGetParam("deviceVersionRelease") or ""
      login._device = EDGetParam("deviceModel") or ""
      login._lang = EDGetParam("deviceLanguage") or ""
      login._region = loginLanguage[ed.loadLanguage()]
      login._is_adult = ed.getIsAdult() and 1 or 0
      ed.send(login, "login")
    end
  },
  [60] = {
    name = "\232\174\190\231\189\174\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166",
    label = T("\232\174\190\231\189\174\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166"),
    icon = "s316.jpg",
    pos = ccp(6, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_liveness = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166" .. number, toast_pos)
    end
  },
  [61] = {
    name = "\229\188\128\229\144\175\229\155\162\233\152\159\229\137\175\230\156\172",
    label = "\229\188\128\229\144\175\229\155\162\233\152\159\229\137\175\230\156\172",
    icon = "s655.jpg",
    pos = ccp(5, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = tonumber(self.number:getText()) or 0
      local msg = ed.upmsg.gm_cmd()
      msg._open_guild_raid = {}
      msg._open_guild_raid._raid_id = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\188\128\229\144\175\229\155\162\233\152\159\229\137\175\230\156\172", toast_pos)
    end
  },
  [62] = {
    name = "\232\191\155\229\133\165\229\155\162\233\152\159\229\137\175\230\156\172",
    label = "\232\191\155\229\133\165\229\155\162\233\152\159\229\137\175\230\156\172",
    icon = "s715.jpg",
    pos = ccp(5, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local text = self.number:getText()
      local ids = {}
      for id in string.gmatch(text, "%d+") do
        table.insert(ids, tonumber(id))
      end
      local stageId = ids[1]
      local waveId = ids[2]
      if not stageId or not waveId then
        ed.showToast("\232\175\183\232\190\147\229\133\165stageId waveId heroIds", toast_pos)
        return
      end
      local hero_id = {
        1,
        2,
        3,
        4,
        5
      }
      local hero_list = {}
      for i = 1, #hero_id do
        local hero = ed.player.heroes[ids[2 + i] or hero_id[i]]
        if hero then
          table.insert(hero_list, hero)
        end
      end
      local guildInstanceData = {}
      guildInstanceData._raid_id = 1
      guildInstanceData.wave = waveId
      local stage = ed.lookupDataTable("Stage", nil, stageId)
      local battle = ed.lookupDataTable("Battle", nil, stageId, waveId)
      ed.engine:enterGuildInstance(stage, hero_list, guildInstanceData)
      local extraInfo = {}
      extraInfo.guildInstanceInfo = {}
      ed.scene:reset(stage, battle, extraInfo)
      ed.replaceScene(ed.scene)
      ed.engine:enterGmMode()
    end
  },
  [63] = {
    name = "\229\155\162\230\156\172\230\151\160\233\153\144\230\140\145\230\136\152",
    label = "\229\155\162\230\156\172\230\151\160\233\153\144\230\140\145\230\136\152",
    icon = "s715.jpg",
    pos = ccp(5, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_raid_unlimited_battle = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\155\162\230\156\172\232\191\155\229\186\166"), toast_pos)
    end
  },
  [64] = {
    name = "\232\174\190\231\189\174\229\155\162\230\156\172\232\191\155\229\186\166",
    label = T("\232\174\190\231\189\174\229\155\162\230\156\172\232\191\155\229\186\166"),
    icon = "1298.jpg",
    pos = ccp(19, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 10000
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_raid_progress = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\155\162\230\156\172\232\191\155\229\186\166"), toast_pos)
    end
  },
  [65] = {
    name = "\232\174\190\231\189\174\229\133\172\228\188\154\229\184\129",
    label = T("\232\174\190\231\189\174\229\133\172\228\188\154\229\184\129"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      local msg = ed.upmsg.gm_cmd()
      msg._set_raid_point = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\229\155\162\230\156\172\232\180\161\231\140\174\231\130\185 ") .. number, toast_pos)
    end
  },
  [66] = {
    name = "\232\142\183\229\190\151\228\187\163\229\184\129",
    label = T("\232\142\183\229\190\151\228\187\163\229\184\129"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      local msg = ed.upmsg.gm_cmd()
      msg._gain_gift_tickets = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\228\187\163\229\184\129 ") .. number, toast_pos)
    end
  },
  [67] = {
    name = "\232\142\183\229\190\151\228\187\163\229\184\129\233\129\147\229\133\183",
    label = T("\232\142\183\229\190\151\228\187\163\229\184\129\233\129\147\229\133\183"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      local msg = ed.upmsg.gm_cmd()
      msg._gain_gift_ticket_items = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\228\187\163\229\184\129\233\129\147\229\133\183 ") .. number, toast_pos)
    end
  },
  [68] = {
    name = T("\228\184\128\233\148\174\230\138\181\232\190\190\229\155\162\230\156\172BOSS"),
    label = T("\228\184\128\233\148\174\230\138\181\232\190\190\229\155\162\230\156\172BOSS"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_raid_progress = -1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\228\184\128\233\148\174\230\138\181\232\190\190\229\155\162\230\156\172BOSS "), toast_pos)
    end
  },
  [69] = {
    name = T("\232\174\190\231\189\174\229\143\172\229\148\164\230\128\187\230\149\176"),
    label = T("\232\174\190\231\189\174\229\143\172\229\148\164\230\128\187\230\149\176"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      local msg = ed.upmsg.gm_cmd()
      msg._set_summon_sum = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\143\172\229\148\164\230\128\187\230\149\176"), toast_pos)
    end
  },
  [70] = {
    name = T("\230\183\187\229\138\160\228\184\128\228\184\170\230\180\187\229\138\168(ActID)"),
    label = T("\230\183\187\229\138\160\228\184\128\228\184\170\230\180\187\229\138\168"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or -1
      local msg = ed.upmsg.gm_cmd()
      msg._add_activity = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\183\187\229\138\160\228\184\128\228\184\170\230\180\187\229\138\168 "), toast_pos)
    end
  },
  [71] = {
    name = T("\232\174\190\231\189\174\230\180\187\229\138\168\228\187\187\229\138\161\232\191\155\229\186\166(0\230\184\133\233\153\164)"),
    label = T("\232\174\190\231\189\174\230\180\187\229\138\168\228\187\187\229\138\161\232\191\155\229\186\166"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 1
      local msg = ed.upmsg.gm_cmd()
      msg._set_act_task_progress = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\180\187\229\138\168\228\187\187\229\138\161\232\191\155\229\186\166 "), toast_pos)
    end
  },
  [72] = {
    name = T("\232\174\190\231\189\174\232\139\177\233\155\132\232\175\149\231\130\188\229\177\130\230\149\176"),
    label = T("\232\174\190\231\189\174\232\139\177\233\155\132\232\175\149\231\130\188\229\177\130\230\149\176"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      local msg = ed.upmsg.gm_cmd()
      msg._set_actstage_floor = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\139\177\233\155\132\232\175\149\231\130\188\229\177\130\230\149\176"), toast_pos)
    end
  },
  [73] = {
    name = T("\229\162\158\229\138\160\229\133\133\229\128\188\229\174\157\229\186\147\231\167\175\229\136\134"),
    label = T("\229\162\158\229\138\160\229\133\133\229\128\188\229\174\157\229\186\147\231\167\175\229\136\134"),
    icon = "s10413.jpg",
    pos = ccp(15, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 99999
      local msg = ed.upmsg.gm_cmd()
      msg._add_charge_vault_score = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\162\158\229\138\160\229\133\133\229\128\188\229\174\157\229\186\147\231\167\175\229\136\134"), toast_pos)
    end
  },
  [74] = {
    name = "\232\139\177\233\155\132PASS\232\174\190\231\189\174\228\187\187\229\138\161\231\130\185",
    label = T("\232\139\177\233\155\132PASS\232\174\190\231\189\174\228\187\187\229\138\161\231\130\185"),
    icon = "971.jpg",
    pos = ccp(21, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._daily_pass_add_exp = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\139\177\233\155\132PASS\232\174\190\231\189\174\228\187\187\229\138\161\231\130\185%d", number))
    end
  },
  [75] = {
    name = "\229\162\158\229\138\160PTR\232\191\148\229\136\169",
    label = T("\229\162\158\229\138\160PTR\232\191\148\229\136\169"),
    icon = "971.jpg",
    pos = ccp(21, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_ptr_rebate = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\162\158\229\138\160PTR\232\191\148\229\136\169%d", number))
    end
  },
  [76] = {
    name = "\229\162\158\229\138\160\229\164\143\230\151\165\229\134\146\233\153\169\228\189\147\229\138\155",
    label = T("\229\162\158\229\138\160\229\164\143\230\151\165\229\134\146\233\153\169\228\189\147\229\138\155"),
    icon = "971.jpg",
    pos = ccp(21, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_act_adventure_vitality = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\162\158\229\138\160\229\164\143\230\151\165\229\134\146\233\153\169\228\189\147\229\138\155%d", number))
    end
  },
  [77] = {
    name = "\229\185\187\229\162\131\230\183\177\230\184\138\233\128\154\229\133\179",
    label = T("\229\185\187\229\162\131\230\183\177\230\184\138\233\128\154\229\133\179"),
    icon = "971.jpg",
    pos = ccp(21, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._fancy_abyss_pass_floor = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\185\187\229\162\131\230\183\177\230\184\138\233\128\154\229\133\179%d", number))
    end
  },
  [78] = {
    name = "\229\174\162\230\136\183\231\171\175\232\181\176\233\169\172\231\129\175",
    label = T("\229\174\162\230\136\183\231\171\175\232\181\176\233\169\172\231\129\175"),
    icon = "971.jpg",
    pos = ccp(21, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      tip(number)
    end
  },
  [79] = {
    name = "\230\156\141\229\138\161\229\153\168\232\181\176\233\169\172\231\129\175",
    label = T("\230\156\141\229\138\161\229\153\168\232\181\176\233\169\172\231\129\175"),
    icon = "971.jpg",
    pos = ccp(21, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._lantern_trigger = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\181\176\233\169\172\231\129\175%d", number))
    end
  },
  [80] = {
    name = "\230\184\133\231\144\134\232\181\155\229\173\163\230\180\187\229\138\168",
    label = "\230\184\133\231\144\134\232\181\155\229\173\163\230\180\187\229\138\168",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_ext()
      msg._reset_activity_season = ed.upmsg.gm_reset_activity_season()
      local number = self:getInput(1)
      msg._reset_activity_season._type = "fancy_abyss"
      if number ~= 1 then
      end
      ed.send(msg, "gm_ext")
    end
  },
  [81] = {
    name = "\230\156\141\229\138\161\229\153\168\231\137\136\230\156\172\229\143\183",
    label = "\230\156\141\229\138\161\229\153\168\231\137\136\230\156\172\229\143\183",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_ext()
      msg._server_full_version = ed.upmsg.gm_server_full_version()
      ed.send(msg, "gm_ext")
    end
  },
  [82] = {
    name = "\229\156\176\229\186\149\229\142\134\233\153\169 \229\162\158\229\138\160\231\187\143\233\170\140",
    label = "\229\156\176\229\186\149\229\142\134\233\153\169 \229\162\158\229\138\160\231\187\143\233\170\140",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._awake_dungeon_add_exp = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\162\158\229\138\160\231\187\143\233\170\140%d", number))
    end
  },
  [83] = {
    name = "\229\156\176\229\186\149\229\142\134\233\153\169 \232\174\190\231\189\174\231\173\137\231\186\167",
    label = "\229\156\176\229\186\149\229\142\134\233\153\169 \232\174\190\231\189\174\231\173\137\231\186\167",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._awake_dungeon_set_level = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\231\173\137\231\186\167%d", number))
    end
  },
  [84] = {
    name = "\229\156\176\229\186\149\229\142\134\233\153\169 \229\162\158\229\138\160\228\189\147\229\138\155",
    label = "\229\156\176\229\186\149\229\142\134\233\153\169 \229\162\158\229\138\160\228\189\147\229\138\155",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._awake_dungeon_add_vitality = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\162\158\229\138\160\228\189\147\229\138\155%d", number))
    end
  },
  [85] = {
    name = "\229\156\176\229\186\149\229\142\134\233\153\169 \229\174\140\230\136\144\231\171\160\232\138\130",
    label = "\229\156\176\229\186\149\229\142\134\233\153\169 \229\174\140\230\136\144\231\171\160\232\138\130",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._awake_dungeon_pass_stage = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\174\140\230\136\144\231\171\160\232\138\130%d", number))
    end
  },
  [86] = {
    name = "\229\162\158\229\138\160\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\230\156\186\229\153\168\228\186\186",
    label = "\229\162\158\229\138\160\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\230\156\186\229\153\168\228\186\186",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._peak_arena_add_pile = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\162\158\229\138\160\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\230\156\186\229\153\168\228\186\186") .. number)
    end
  },
  [87] = {
    name = "\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\230\148\185\229\136\134",
    label = "\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\230\148\185\229\136\134",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._peak_arena_set_grade_score = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\230\148\185\229\136\134") .. number)
    end
  },
  [88] = {
    name = "\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\232\174\190\231\189\174\229\139\139\231\171\160",
    label = "\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\232\174\190\231\189\174\229\139\139\231\171\160",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._peak_arena_set_medal = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\232\174\190\231\189\174\229\139\139\231\171\160") .. number)
    end
  },
  [89] = {
    name = "\229\183\133\229\179\176\230\140\145\230\136\152\230\172\161\230\149\176",
    label = "\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._peak_arena_add_challenge_time = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176") .. number)
    end
  },
  [90] = {
    name = "\229\183\133\229\179\176\229\136\183\230\150\176\230\172\161\230\149\176",
    label = "\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\162\158\229\138\160\229\136\183\230\150\176\230\172\161\230\149\176",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._peak_arena_add_refresh_time = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\162\158\229\138\160\229\136\183\230\150\176\230\172\161\230\149\176") .. number)
    end
  },
  [91] = {
    name = "\229\183\133\229\179\176\229\162\158\229\138\160\232\181\155\229\140\186",
    label = "\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\162\158\229\138\160\232\181\155\229\140\186",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._peak_arena_add_zone = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\162\158\229\138\160\232\181\155\229\140\186") .. number)
    end
  },
  [92] = {
    name = "\232\174\190\231\189\174\231\166\187\231\186\191\229\164\169\230\149\176",
    label = "\232\174\190\231\189\174\231\166\187\231\186\191\229\164\169\230\149\176",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_left_days = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\231\166\187\231\186\191\229\164\169\230\149\176") .. number)
    end
  },
  [93] = {
    name = "\232\174\190\231\189\174\229\155\158\229\189\146\228\187\187\229\138\161\232\191\155\229\186\166",
    label = "\232\174\190\231\189\174\229\155\158\229\189\146\228\187\187\229\138\161\232\191\155\229\186\166",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_goback_task_line = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\155\158\229\189\146\228\187\187\229\138\161\232\191\155\229\186\166") .. number)
    end
  },
  [94] = {
    name = "\230\149\176\230\141\174\229\164\141\229\136\187",
    label = "\230\149\176\230\141\174\229\164\141\229\136\187",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    color = special_button_color,
    handler = function(self)
      local number = self:getInputString()
      if not number or number == "" then
        ed.showToast(T("\232\175\183\229\156\168\229\183\166\228\190\167\232\190\147\229\133\165\230\161\134\232\190\147\229\133\165key"))
        return
      end
      local msg = ed.upmsg.gm_cmd()
      msg._online_data_transfer = tostring(number)
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\149\176\230\141\174\229\164\141\229\136\187") .. number)
    end
  },
  [95] = {
    name = "\228\184\138\228\188\160\231\142\169\229\174\182\230\149\176\230\141\174",
    label = "\228\184\138\228\188\160\231\142\169\229\174\182\230\149\176\230\141\174",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    color = special_button_color,
    handler = function(self)
      local msg = ed.upmsg.gm_ext()
      msg._upload_user_data = ed.upmsg.gm_upload_user_data()
      ed.send(msg, "gm_ext")
    end
  },
  [96] = {
    name = "\230\180\187\229\138\168\229\133\179\229\141\161\232\174\190\231\189\174\230\140\145\230\136\152\231\173\137\231\186\167",
    label = "\230\180\187\229\138\168\229\133\179\229\141\161\232\174\190\231\189\174\230\140\145\230\136\152\231\173\137\231\186\167",
    icon = "s63.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._act_adventure_challenge_level = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\180\187\229\138\168\229\133\179\229\141\161\232\174\190\231\189\174\230\140\145\230\136\152\231\173\137\231\186\167") .. number)
    end
  },
  [97] = {
    name = "\232\142\183\229\190\151\232\167\137\233\134\146\229\184\129",
    label = T("\232\142\183\229\190\151\232\167\137\233\134\146\229\184\129"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "shard_point"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\232\167\137\233\134\146\229\184\129") .. number, toast_pos)
    end
  },
  [98] = {
    name = "\232\174\190\231\189\174\232\167\137\233\134\146\229\184\129(\230\175\143\230\151\165)",
    label = T("\232\174\190\231\189\174\232\167\137\233\134\146\229\184\129(\230\175\143\230\151\165)"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "shard_point_daily"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\167\137\233\134\146\229\184\129(\230\175\143\230\151\165)\239\188\154") .. number, toast_pos)
    end
  },
  [99] = {
    name = "\232\174\190\231\189\174\230\156\141\229\138\161\229\153\168\229\188\128\230\156\141\230\151\182\233\151\180",
    label = T("\232\174\190\231\189\174\230\156\141\229\138\161\229\153\168\229\188\128\230\156\141\230\151\182\233\151\180"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_svr_open_time = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\156\141\229\138\161\229\153\168\229\188\128\230\156\141\230\151\182\233\151\180") .. number)
    end
  },
  [100] = {
    name = "\229\133\172\228\188\154\230\136\152\232\174\190\231\189\174\229\175\185\230\137\139\229\133\172\228\188\154",
    label = T("\229\133\172\228\188\154\230\136\152\232\174\190\231\189\174\229\175\185\230\137\139\229\133\172\228\188\154"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_clash_set_oppo_guild = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\230\136\152\232\174\190\231\189\174\229\175\185\230\137\139\229\133\172\228\188\154") .. number)
    end
  },
  [101] = {
    name = "\229\133\172\228\188\154\230\136\152\232\174\161\231\174\151\230\136\152\230\150\151",
    label = T("\229\133\172\228\188\154\230\136\152\232\174\161\231\174\151\230\136\152\230\150\151"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_clash_calc_battle = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\230\136\152\232\174\161\231\174\151\230\136\152\230\150\151") .. number)
    end
  },
  [102] = {
    name = "\229\133\172\228\188\154\230\136\152\229\188\128\229\167\139\230\188\148\230\146\173",
    label = T("\229\133\172\228\188\154\230\136\152\229\188\128\229\167\139\230\188\148\230\146\173"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_clash_start_replay = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\230\136\152\229\188\128\229\167\139\230\188\148\230\146\173") .. number)
    end
  },
  [103] = {
    name = "\229\133\172\228\188\154\230\136\152\229\162\158\229\138\160\228\184\170\228\186\186\230\180\187\232\183\131\229\186\166",
    label = T("\229\133\172\228\188\154\230\136\152\229\162\158\229\138\160\228\184\170\228\186\186\230\180\187\232\183\131\229\186\166"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_clash_add_user_liveness = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\230\136\152\229\162\158\229\138\160\228\184\170\228\186\186\230\180\187\232\183\131\229\186\166") .. number)
    end
  },
  [104] = {
    name = "\229\133\172\228\188\154\230\136\152\233\135\141\229\144\175\232\181\155\229\173\163\229\145\168\230\156\159",
    label = T("\229\133\172\228\188\154\230\136\152\233\135\141\229\144\175\232\181\155\229\173\163\229\145\168\230\156\159"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_clash_restart_schedule = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\230\136\152\233\135\141\229\144\175\232\181\155\229\173\163\229\145\168\230\156\159") .. number)
    end
  },
  [105] = {
    name = "\229\133\172\228\188\154\230\136\152\233\154\143\230\156\186\230\183\187\229\138\160\233\152\159\228\188\141",
    label = T("\229\133\172\228\188\154\230\136\152\233\154\143\230\156\186\230\183\187\229\138\160\233\152\159\228\188\141"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_clash_add_random_teams = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\230\136\152\233\154\143\230\156\186\230\183\187\229\138\160\233\152\159\228\188\141"))
    end
  },
  [106] = {
    name = "\230\129\162\229\164\141\230\179\149\233\152\181\229\145\168\228\186\148\230\152\159\228\191\157\229\186\149",
    label = T("\230\129\162\229\164\141\230\179\149\233\152\181\229\145\168\228\186\148\230\152\159\228\191\157\229\186\149"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._restore_summon_weekly = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\129\162\229\164\141\230\179\149\233\152\181\229\145\168\228\186\148\230\152\159\228\191\157\229\186\149"))
    end
  },
  [107] = {
    name = "\230\137\147\229\188\128\229\133\172\228\188\154\230\139\155\229\139\159\229\164\167\229\142\133",
    label = T("\230\137\147\229\188\128\229\133\172\228\188\154\230\139\155\229\139\159\229\164\167\229\142\133"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_ext()
      msg._open_guild_enlist = ed.upmsg.gm_open_guild_enlist()
      msg._open_guild_enlist._entry_all = 1
      ed.send(msg, "gm_ext")
    end
  },
  [108] = {
    name = "\232\174\190\231\189\174\229\133\172\228\188\154\230\152\168\230\151\165\230\180\187\232\183\131",
    label = T("\232\174\190\231\189\174\229\133\172\228\188\154\230\152\168\230\151\165\230\180\187\232\183\131"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_yesterday_liveness = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\133\172\228\188\154\230\152\168\230\151\165\230\180\187\232\183\131"))
    end
  },
  [109] = {
    name = "\232\174\190\231\189\174\230\151\165\229\184\184\228\187\187\229\138\161\231\180\175\232\174\161\230\149\176\233\135\143",
    label = T("\232\174\190\231\189\174\230\151\165\229\184\184\228\187\187\229\138\161\231\180\175\232\174\161\230\149\176\233\135\143"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_dailyjob_acc = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\151\165\229\184\184\228\187\187\229\138\161\231\180\175\232\174\161\230\149\176\233\135\143"))
    end
  },
  [110] = {
    name = "\233\135\141\231\189\174\230\162\166\229\162\131\230\172\161\230\149\176",
    label = T("\233\135\141\231\189\174\230\162\166\229\162\131\230\172\161\230\149\176"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._reset_dreamland_use_count = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\233\135\141\231\189\174\230\162\166\229\162\131\230\172\161\230\149\176"))
    end
  },
  [111] = {
    name = "\228\184\138\228\188\160\229\133\172\228\188\154\230\149\176\230\141\174",
    label = T("\228\184\138\228\188\160\229\133\172\228\188\154\230\149\176\230\141\174"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(0)
      local msg = ed.upmsg.gm_ext()
      msg._upload_guild_data = ed.upmsg.gm_upload_guild_data()
      msg._upload_guild_data._guild_id = number
      ed.send(msg, "gm_ext")
    end
  },
  [112] = {
    name = "\228\184\139\232\189\189\229\133\172\228\188\154\230\149\176\230\141\174\229\136\176\232\135\170\229\183\177\230\156\141\229\138\161\229\153\168",
    label = T("\228\184\139\232\189\189\229\133\172\228\188\154\230\149\176\230\141\174\229\136\176\232\135\170\229\183\177\230\156\141\229\138\161\229\153\168"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local str = self.number:getText()
      local msg = ed.upmsg.gm_ext()
      msg._download_guild_data = ed.upmsg.gm_download_guild_data()
      msg._download_guild_data._data_key = str
      msg._download_guild_data._be_chairman = 0
      ed.send(msg, "gm_ext")
    end
  },
  [113] = {
    name = "\228\184\139\232\189\189\229\133\172\228\188\154\230\149\176\230\141\174\229\136\176\232\135\170\229\183\177\230\156\141\229\138\161\229\153\168(\228\188\154\233\149\191)",
    label = T("\228\184\139\232\189\189\229\133\172\228\188\154\230\149\176\230\141\174\229\136\176\232\135\170\229\183\177\230\156\141\229\138\161\229\153\168(\228\188\154\233\149\191)"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local str = self.number:getText()
      local msg = ed.upmsg.gm_ext()
      msg._download_guild_data = ed.upmsg.gm_download_guild_data()
      msg._download_guild_data._data_key = str
      msg._download_guild_data._be_chairman = 1
      ed.send(msg, "gm_ext")
    end
  },
  [114] = {
    name = "\229\162\158\229\138\160\232\135\170\232\181\176\230\163\139\231\167\175\229\136\134",
    label = T("\229\162\158\229\138\160\232\135\170\232\181\176\230\163\139\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_chess_score = number
      ed.send(msg, "gm_cmd")
    end
  },
  [115] = {
    name = "\232\174\190\231\189\174\232\130\137\233\184\189\229\145\168\231\167\175\229\136\134",
    label = T("\232\174\190\231\189\174\232\130\137\233\184\189\229\145\168\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_set_weekly_point = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\232\130\137\233\184\189\229\145\168\231\167\175\229\136\134" .. number)
    end
  },
  [116] = {
    name = "\232\174\190\231\189\174\232\130\137\233\184\189\233\129\135\232\167\129\231\165\157\231\166\143\230\149\176\233\135\143",
    label = T("\232\174\190\231\189\174\232\130\137\233\184\189\233\129\135\232\167\129\231\165\157\231\166\143\230\149\176\233\135\143"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_set_view_bless_num = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\232\130\137\233\184\189\233\129\135\232\167\129\231\165\157\231\166\143\230\149\176\233\135\143" .. number)
    end
  },
  [117] = {
    name = "\232\174\190\231\189\174\232\130\137\233\184\189\233\129\135\232\167\129\228\186\139\228\187\182",
    label = T("\232\174\190\231\189\174\232\130\137\233\184\189\233\129\135\232\167\129\228\186\139\228\187\182"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_set_view_event = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\232\130\137\233\184\189\233\129\135\232\167\129\228\186\139\228\187\182" .. number)
    end
  },
  [118] = {
    name = "\232\130\137\233\184\189\229\138\160\231\143\141\231\143\160",
    label = T("\232\130\137\233\184\189\229\138\160\231\143\141\231\143\160"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_add_pearl = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\130\137\233\184\189\229\138\160\231\143\141\231\143\160" .. number)
    end
  },
  [119] = {
    name = "\232\130\137\233\184\189\230\184\133\233\153\164\229\189\147\229\137\141\231\171\160\232\138\130",
    label = T("\232\130\137\233\184\189\230\184\133\233\153\164\229\189\147\229\137\141\231\171\160\232\138\130"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_gm_clear_chapter = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\130\137\233\184\189\230\184\133\233\153\164\229\189\147\229\137\141\231\171\160\232\138\130")
    end
  },
  [120] = {
    name = "\232\174\190\231\189\174\229\189\147\229\137\141\230\136\191\233\151\180\231\154\132\228\186\139\228\187\182",
    label = T("\232\174\190\231\189\174\229\189\147\229\137\141\230\136\191\233\151\180\231\154\132\228\186\139\228\187\182"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_gm_set_event = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\229\189\147\229\137\141\230\136\191\233\151\180\231\154\132\228\186\139\228\187\182")
    end
  },
  [121] = {
    name = "\232\130\137\233\184\189\230\183\187\229\138\160\231\167\145\230\138\128\231\130\185",
    label = T("\232\130\137\233\184\189\230\183\187\229\138\160\231\167\145\230\138\128\231\130\185"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_gm_add_tech = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\130\137\233\184\189\230\183\187\229\138\160\231\167\145\230\138\128\231\130\185" .. number)
    end
  },
  [122] = {
    name = "\232\130\137\233\184\189\232\174\190\231\189\174\230\136\191\233\151\180\230\136\144\229\149\134\229\186\151",
    label = T("\232\130\137\233\184\189\232\174\190\231\189\174\230\136\191\233\151\180\230\136\144\229\149\134\229\186\151"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_gm_set_shop = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\130\137\233\184\189\232\174\190\231\189\174\230\136\191\233\151\180\230\136\144\229\149\134\229\186\151" .. number)
    end
  },
  [123] = {
    name = "\231\187\153\230\137\128\230\156\137\232\139\177\233\155\132\233\154\143\230\156\186\229\174\137\232\163\133\228\191\161\228\189\191",
    label = T("\231\187\153\230\137\128\230\156\137\232\139\177\233\155\132\233\154\143\230\156\186\229\174\137\232\163\133\228\191\161\228\189\191"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._pet_equip_all_hero = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\231\187\153\230\137\128\230\156\137\232\139\177\233\155\132\233\154\143\230\156\186\229\174\137\232\163\133\228\191\161\228\189\191" .. number)
    end
  },
  [124] = {
    name = "\232\130\137\233\184\189\233\128\154\229\133\179\230\159\144\231\171\160\231\154\132\230\137\128\230\156\137\233\154\190\229\186\166",
    label = T("\232\130\137\233\184\189\233\128\154\229\133\179\230\159\144\231\171\160\231\154\132\230\137\128\230\156\137\233\154\190\229\186\166"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_unlock_chapter = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\232\130\137\233\184\189\233\128\154\229\133\179\231\172\172%s\231\171\160\231\154\132\230\137\128\230\156\137\233\154\190\229\186\166", number))
    end
  },
  [125] = {
    name = "\232\142\183\229\143\150\230\137\128\230\156\137\230\187\161\229\188\186\229\140\150\228\191\161\228\189\191",
    label = T("\232\142\183\229\143\150\230\137\128\230\156\137\230\187\161\229\188\186\229\140\150\228\191\161\228\189\191"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._pet_get_all_pets = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\142\183\229\143\150\230\137\128\230\156\137\230\187\161\229\188\186\229\140\150\228\191\161\228\189\191")
    end
  },
  [126] = {
    name = "\232\142\183\229\143\150\232\130\137\233\184\189\233\135\141\232\175\149\230\172\161\230\149\176",
    label = T("\232\142\183\229\143\150\232\130\137\233\184\189\233\135\141\232\175\149\230\172\161\230\149\176"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_add_retry_times = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\232\142\183\229\143\150\232\130\137\233\184\189\233\135\141\232\175\149\230\172\161\230\149\176", number))
    end
  },
  [127] = {
    name = "\232\142\183\229\143\150\232\130\137\233\184\189\230\159\144\228\184\170\229\145\189\233\128\148\228\184\139\230\137\128\230\156\137\231\165\157\231\166\143",
    label = T("\232\142\183\229\143\150\232\130\137\233\184\189\230\159\144\228\184\170\229\145\189\233\128\148\228\184\139\230\137\128\230\156\137\231\165\157\231\166\143"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_add_destiny_bless = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\232\142\183\229\143\150\232\130\137\233\184\189\230\159\144\228\184\170\229\145\189\233\128\148\228\184\139\230\137\128\230\156\137\231\165\157\231\166\143", number))
    end
  },
  [128] = {
    name = "Solo\232\174\190\231\189\174\233\133\141\231\189\174",
    label = T("Solo\232\174\190\231\189\174\233\133\141\231\189\174"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local str = self:getInputString()
      local msg = ed.upmsg.gm_cmd()
      msg._set_solo_rules = ed.commonmsg.solo_rules()
      msg._set_solo_rules._str_config = str
      ed.send(msg, "gm_cmd")
    end
  },
  [129] = {
    name = "chess\232\174\190\231\189\174\232\181\183\229\167\139\233\135\145\229\184\129",
    label = T("chess\232\174\190\231\189\174\232\181\183\229\167\139\233\135\145\229\184\129"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_chess_rules = ed.commonmsg.chess_rules()
      msg._set_chess_rules._common = ed.commonmsg.chess_rules_common()
      msg._set_chess_rules._common._start_gold = number
      ed.send(msg, "gm_cmd")
    end
  },
  [130] = {
    name = "chess\229\188\128\229\144\175\229\133\179\233\151\173\229\138\159\232\131\189",
    label = T("chess\229\188\128\229\144\175\229\133\179\233\151\173\229\138\159\232\131\189"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_chess_rules = ed.commonmsg.chess_rules()
      msg._set_chess_rules._hero_power = ed.commonmsg.chess_rules_hero_power()
      msg._set_chess_rules._hero_power._disable = number
      ed.send(msg, "gm_cmd")
    end
  },
  [131] = {
    name = "chess\232\174\190\231\189\174\232\167\166\229\143\145\229\155\158\229\144\136\230\149\176",
    label = T("chess\232\174\190\231\189\174\232\167\166\229\143\145\229\155\158\229\144\136\230\149\176"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_chess_rules = ed.commonmsg.chess_rules()
      msg._set_chess_rules._hero_power = ed.commonmsg.chess_rules_hero_power()
      msg._set_chess_rules._hero_power._round = number
      ed.send(msg, "gm_cmd")
    end
  },
  [132] = {
    name = "chess\233\148\129\229\174\154\232\131\189\229\138\155ID",
    label = T("chess\233\148\129\229\174\154\232\131\189\229\138\155ID"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_chess_rules = ed.commonmsg.chess_rules()
      msg._set_chess_rules._hero_power = ed.commonmsg.chess_rules_hero_power()
      msg._set_chess_rules._hero_power._lock_power_id = number
      ed.send(msg, "gm_cmd")
    end
  },
  [133] = {
    name = "chess\232\174\190\231\189\174\233\128\137\230\139\169\228\184\170\230\149\176",
    label = T("chess\232\174\190\231\189\174\233\128\137\230\139\169\228\184\170\230\149\176"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_chess_rules = ed.commonmsg.chess_rules()
      msg._set_chess_rules._common = ed.commonmsg.chess_rules_common()
      msg._set_chess_rules._hero_power = ed.commonmsg.chess_rules_hero_power()
      msg._set_chess_rules._hero_power._choose_count = number
      ed.send(msg, "gm_cmd")
    end
  },
  [134] = {
    name = "\229\133\172\228\188\154\229\162\158\229\138\160\229\164\180\229\131\143\230\161\134",
    label = T("\229\133\172\228\188\154\229\162\158\229\138\160\229\164\180\229\131\143\230\161\134"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_add_frame = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\229\162\158\229\138\160\229\164\180\229\131\143\230\161\134"))
    end
  },
  [135] = {
    name = "\233\173\148\231\149\140\232\174\168\228\188\144\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176",
    label = T("\233\173\148\231\149\140\232\174\168\228\188\144\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_mount_add_battle_time = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\233\173\148\231\149\140\232\174\168\228\188\144\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176"))
    end
  },
  [136] = {
    name = "\233\135\141\231\189\174\229\133\172\228\188\154\229\177\177\230\136\152\230\150\151",
    label = T("\233\135\141\231\189\174\229\133\172\228\188\154\229\177\177\230\136\152\230\150\151"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._reset_guild_mount_battle = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\233\135\141\231\189\174\229\133\172\228\188\154\229\177\177\230\136\152\230\150\151"))
    end
  },
  [137] = {
    name = "\230\142\168\232\191\155\229\133\172\228\188\154\229\177\177BOSS\239\188\140\229\137\141\232\191\155N\228\184\170BOSS",
    label = T("\230\142\168\232\191\155\229\133\172\228\188\154\229\177\177BOSS\239\188\140\229\137\141\232\191\155N\228\184\170BOSS"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._next_guild_mount_boss = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\142\168\232\191\155\229\133\172\228\188\154\229\177\177BOSS\239\188\140\229\137\141\232\191\155N\228\184\170BOSS"))
    end
  },
  [138] = {
    name = "\233\173\148\231\149\140\232\174\168\228\188\144\232\174\190\231\189\174boss\232\161\128\233\135\143",
    label = T("\233\173\148\231\149\140\232\174\168\228\188\144\232\174\190\231\189\174boss\232\161\128\233\135\143"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_mount_set_boss_hp = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\233\173\148\231\149\140\232\174\168\228\188\144\232\174\190\231\189\174boss\232\161\128\233\135\143"))
    end
  },
  [139] = {
    name = "\232\130\137\233\184\189\230\182\136\232\128\151\228\188\160\233\128\129\229\141\183\232\189\180\230\149\176\233\135\143",
    label = T("\232\130\137\233\184\189\230\182\136\232\128\151\228\188\160\233\128\129\229\141\183\232\189\180\230\149\176\233\135\143"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_exchange_vit = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\232\130\137\233\184\189\230\182\136\232\128\151\228\188\160\233\128\129\229\141\183\232\189\180x%d", number))
    end
  },
  [140] = {
    name = "\232\130\137\233\184\189\229\162\158\229\138\160\228\188\160\233\128\129\229\141\183\232\189\180\230\149\176\233\135\143",
    label = T("\232\130\137\233\184\189\229\162\158\229\138\160\228\188\160\233\128\129\229\141\183\232\189\180\230\149\176\233\135\143"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_add_vit = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\232\130\137\233\184\189\229\162\158\229\138\160\228\188\160\233\128\129\229\141\183\232\189\180x%d", number))
    end
  },
  [141] = {
    name = "\229\162\158\229\138\160\230\152\159\231\155\152\231\165\136\231\166\143\230\172\161\230\149\176",
    label = T("\229\162\158\229\138\160\230\152\159\231\155\152\231\165\136\231\166\143\230\172\161\230\149\176"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._astrolabe_add_times = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\162\158\229\138\160\230\152\159\231\155\152\231\165\136\231\166\143\230\172\161\230\149\176x%d", number))
    end
  },
  [142] = {
    name = "\232\142\183\229\143\150\228\184\128\228\184\170\229\191\131\229\138\168\231\164\188\229\140\133",
    label = T("\232\142\183\229\143\150\228\184\128\228\184\170\229\191\131\229\138\168\231\164\188\229\140\133"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._gain_impulse_gift = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\143\150\228\184\128\228\184\170\229\191\131\229\138\168\231\164\188\229\140\133"))
    end
  },
  [143] = {
    name = "\232\130\137\233\184\189\229\174\140\230\136\144\229\137\167\230\156\172",
    label = T("\232\130\137\233\184\189\229\174\140\230\136\144\229\137\167\230\156\172"),
    icon = "s33.jpg",
    pos = ccp(18, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_complete_script = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\130\137\233\184\189\229\174\140\230\136\144\229\137\167\230\156\172") .. number)
    end
  },
  [144] = {
    name = "\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\230\156\186\229\153\168\228\186\186",
    label = T("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\230\156\186\229\153\168\228\186\186"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._cup_arena_add_pile = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\230\156\186\229\153\168\228\186\186%d", number))
    end
  },
  [145] = {
    name = "\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\139\139\231\171\160",
    label = T("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\139\139\231\171\160"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._cup_arena_add_medal = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\139\139\231\171\160x%d", number))
    end
  },
  [146] = {
    name = "\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176",
    label = T("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._cup_arena_add_challenge_time = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\230\140\145\230\136\152\230\172\161\230\149\176", number))
    end
  },
  [147] = {
    name = "\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\136\183\230\150\176\230\172\161\230\149\176",
    label = T("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\136\183\230\150\176\230\172\161\230\149\176"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._cup_arena_add_refresh_time = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\136\183\230\150\176\230\172\161\230\149\176", number))
    end
  },
  [148] = {
    name = "\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\232\181\155\229\140\186",
    label = T("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\232\181\155\229\140\186"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._cup_arena_add_zone = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\232\181\155\229\140\186%d", number))
    end
  },
  [149] = {
    name = "\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182",
    label = T("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._cup_arena_add_player = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182%d", number))
    end
  },
  [150] = {
    name = "\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\231\167\175\229\136\134",
    label = T("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_cup_arena_score = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\229\165\179\231\165\158\228\185\139\230\136\152\229\162\158\229\138\160\231\167\175\229\136\134%d", number))
    end
  },
  [151] = {
    name = "\229\164\169\228\184\139\232\167\146\233\128\144\230\175\143\230\151\165\231\187\147\231\174\151",
    label = T("\229\164\169\228\184\139\232\167\146\233\128\144\230\175\143\230\151\165\231\187\147\231\174\151"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_contest_tally = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\164\169\228\184\139\232\167\146\233\128\144\230\175\143\230\151\165\231\187\147\231\174\151")
    end
  },
  [152] = {
    name = "\229\164\169\228\184\139\232\167\146\233\128\144\233\135\141\229\144\175",
    label = T("\229\164\169\228\184\139\232\167\146\233\128\144\233\135\141\229\144\175"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._guild_contest_restart = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\164\169\228\184\139\232\167\146\233\128\144\233\135\141\229\144\175")
    end
  },
  [153] = {
    name = "\232\130\137\233\184\189\232\142\183\229\190\151\230\140\135\229\174\154\231\171\160\232\138\130\230\137\128\230\156\137\230\138\164\231\172\166",
    label = T("\232\130\137\233\184\189\232\142\183\229\190\151\230\140\135\229\174\154\231\171\160\232\138\130\230\137\128\230\156\137\230\138\164\231\172\166"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_add_chapter_charm = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\142\183\229\190\151\230\140\135\229\174\154\231\171\160\232\138\130\228\184\139\230\137\128\230\156\137\230\138\164\231\172\166")
    end
  },
  [154] = {
    name = "\232\130\137\233\184\189\229\162\158\229\138\160\230\137\128\230\156\137\230\138\164\231\172\166\231\187\143\233\170\140",
    label = T("\232\130\137\233\184\189\229\162\158\229\138\160\230\137\128\230\156\137\230\138\164\231\172\166\231\187\143\233\170\140"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._rogue_add_charm_exp = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\162\158\229\138\160\230\137\128\230\156\137\230\138\164\231\172\166\231\187\143\233\170\140")
    end
  },
  [155] = {
    name = "\231\148\159\230\136\144\228\188\160\229\165\135\232\163\133\229\164\135",
    label = T("\231\148\159\230\136\144\228\188\160\229\165\135\232\163\133\229\164\135"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._generate_legend_equip = {number}
      ed.send(msg, "gm_cmd")
      ed.showToast("\231\148\159\230\136\144\228\188\160\229\165\135\232\163\133\229\164\135")
    end
  },
  [156] = {
    name = "\231\148\159\230\136\144\230\187\161\230\152\159\228\188\160\229\165\135\232\163\133\229\164\135",
    label = T("\231\148\159\230\136\144\230\187\161\230\152\159\228\188\160\229\165\135\232\163\133\229\164\135"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._full_star_legend_equip = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\231\148\159\230\136\144\230\187\161\230\152\159\228\188\160\229\165\135\232\163\133\229\164\135")
    end
  },
  [157] = {
    name = "\231\142\169\229\174\182\229\175\188\230\181\129\230\183\187\229\138\160\232\135\170\229\183\177",
    label = T("\231\142\169\229\174\182\229\175\188\230\181\129\230\183\187\229\138\160\232\135\170\229\183\177"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._player_shift_add_self = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\231\142\169\229\174\182\229\175\188\230\181\129\230\183\187\229\138\160\232\135\170\229\183\177")
    end
  },
  [158] = {
    name = "\229\136\146\233\190\153\232\136\159\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182\239\188\136\232\190\147\229\133\165\230\140\135\229\174\154\229\176\186\229\175\184\239\188\137",
    label = T("\229\136\146\233\190\153\232\136\159\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182\239\188\136\232\190\147\229\133\165\230\140\135\229\174\154\229\176\186\229\175\184\239\188\137"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._dragon_boat_add_single_player = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\136\146\233\190\153\232\136\159\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182(\229\176\186\229\175\184\239\188\154" .. number .. ")")
    end
  },
  [159] = {
    name = "\229\136\146\233\190\153\232\136\159\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182\239\188\136\232\190\147\229\133\165\230\149\176\233\135\143\239\188\137",
    label = T("\229\136\146\233\190\153\232\136\159\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182\239\188\136\232\190\147\229\133\165\230\149\176\233\135\143\239\188\137"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._dragon_boat_add_mult_player = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\136\146\233\190\153\232\136\159\229\162\158\229\138\160\229\129\135\231\142\169\229\174\182(\230\149\176\233\135\143\239\188\154" .. number .. ")")
    end
  },
  [160] = {
    name = "\229\174\162\230\136\183\231\171\175\232\176\131\232\175\149\229\183\165\229\133\183",
    label = "\229\174\162\230\136\183\231\171\175\232\176\131\232\175\149\229\183\165\229\133\183",
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      require("debug/debugTools/init")
      ed.UITool.openView("debugScene")
    end
  },
  [161] = {
    name = "\233\135\141\231\189\174\229\164\154\233\152\159\230\162\166\229\162\131\232\181\155\229\173\163",
    label = T("\233\135\141\231\189\174\229\164\154\233\152\159\230\162\166\229\162\131\232\181\155\229\173\163"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._crevice_defend_reset_season = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\233\135\141\231\189\174\229\164\154\233\152\159\230\162\166\229\162\131\232\181\155\229\173\163")
    end
  },
  [162] = {
    name = "\233\135\141\231\189\174\229\164\154\233\152\159\230\162\166\229\162\131\230\140\145\230\136\152\230\172\161\230\149\176",
    label = T("\233\135\141\231\189\174\229\164\154\233\152\159\230\162\166\229\162\131\230\140\145\230\136\152\230\172\161\230\149\176"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._crevice_defend_challenge_count = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\233\135\141\231\189\174\229\164\154\233\152\159\230\162\166\229\162\131\230\140\145\230\136\152\230\172\161\230\149\176")
    end
  },
  [163] = {
    name = "\232\174\190\231\189\174\233\128\137\230\138\128\231\167\175\229\136\134",
    label = T("\232\174\190\231\189\174\233\128\137\230\138\128\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_solo_score = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\233\128\137\230\138\128\231\167\175\229\136\134")
    end
  },
  [164] = {
    name = "\229\162\158\229\138\160\233\128\137\230\138\128\231\167\175\229\136\134",
    label = T("\229\162\158\229\138\160\233\128\137\230\138\128\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_solo_score = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\162\158\229\138\160\233\128\137\230\138\128\231\167\175\229\136\134")
    end
  },
  [165] = {
    name = "\227\128\144BAN\231\140\155\231\138\184\227\128\145\229\162\158\229\138\160\229\133\168\230\156\141\230\180\187\229\138\168\229\138\169\229\138\155",
    label = T("\227\128\144BAN\231\140\155\231\138\184\227\128\145\229\162\158\229\138\160\229\133\168\230\156\141\230\180\187\229\138\168\229\138\169\229\138\155"),
    icon = "971.jpg",
    pos = ccp(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_all_server_assist = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\227\128\144BAN\231\140\155\231\138\184\227\128\145\229\162\158\229\138\160\229\133\168\230\156\141\230\180\187\229\138\168\229\138\169\229\138\155" .. number)
    end
  }
}
local gm_command = {
  wings = {
    1,
    2,
    4,
    5,
    6,
    24,
    34,
    48,
    53,
    57,
    58,
    59,
    69,
    73,
    74,
    78,
    79,
    81,
    92,
    93,
    94,
    95,
    99,
    106,
    109
  },
  resources = {
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    50,
    66,
    67,
    97,
    98
  },
  hero = {
    7,
    8,
    26,
    27,
    28,
    29,
    54,
    55
  },
  level = {
    3,
    19,
    20,
    21,
    22,
    23,
    30,
    31,
    32,
    33,
    56,
    110
  },
  play = {
    19,
    20,
    51,
    52,
    70,
    71,
    72,
    76,
    77,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    90,
    91,
    96,
    104,
    115,
    116,
    117,
    118,
    119,
    120,
    121,
    122,
    124,
    126,
    127,
    139,
    140,
    128,
    129,
    130,
    131,
    132,
    133,
    135,
    136,
    137,
    138,
    143
  },
  guild = {
    25,
    60,
    61,
    62,
    63,
    64,
    65,
    68,
    100,
    101,
    102,
    103,
    104,
    105,
    107,
    108,
    111,
    112,
    113,
    134
  }
}
local commandType = {
  [1] = {
    name = "\229\133\168\233\131\168",
    label = "\229\133\168\233\131\168",
    icon = "z10005_s.jpg",
    pos = ccp(0, 0),
    handler = function(self)
      self:refreshCommand("all")
    end
  },
  [2] = {
    name = "\230\136\152\233\152\159",
    label = "\230\136\152\233\152\159",
    icon = "z10005_s.jpg",
    pos = ccp(0, 0),
    handler = function(self)
      self:refreshCommand("wings")
    end
  },
  [3] = {
    name = "\232\181\132\230\186\144",
    label = "\232\181\132\230\186\144",
    icon = "z10005_s.jpg",
    pos = ccp(0, 0),
    handler = function(self)
      self:refreshCommand("resources")
    end
  },
  [4] = {
    name = "\232\139\177\233\155\132",
    label = "\232\139\177\233\155\132",
    icon = "z10005_s.jpg",
    pos = ccp(0, 0),
    handler = function(self)
      self:refreshCommand("hero")
    end
  },
  [5] = {
    name = "\229\133\179\229\141\161",
    label = "\229\133\179\229\141\161",
    icon = "z10005_s.jpg",
    pos = ccp(0, 0),
    handler = function(self)
      self:refreshCommand("level")
    end
  },
  [6] = {
    name = "\231\142\169\230\179\149",
    label = "\231\142\169\230\179\149",
    icon = "z10005_s.jpg",
    pos = ccp(0, 0),
    size = CCSizeMake(200, 60),
    handler = function(self)
      self:refreshCommand("play")
    end
  },
  [7] = {
    name = "\229\133\172\228\188\154",
    label = "\229\133\172\228\188\154",
    icon = "z10005_s.jpg",
    pos = ccp(0, 0),
    handler = function(self)
      self:refreshCommand("guild")
    end
  }
}
ed.gmtools.commandType = commandType
ed.gmtools.gm_command = gm_command
ed.gmtools.command_config = command_config
