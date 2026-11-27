local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.gm = class
ed.gmconfig = {attack_ratio = 1, exercise_open = nil}
local maxHeroRank = 9
local maxPlayerLevel = 100
local maxHeroLevel = maxPlayerLevel
local amostMaxHeroLevel = maxPlayerLevel - 10
local normal_button_color = ccc3(255, 213, 16)
local special_button_color = ccc3(128, 230, 15)
local press_button_color = ccc3(255, 255, 255)
local max_column = 1
local element_pos_col_row = {}

local function getElementPos(col, row, offset)
  for k, v in pairs(element_pos_col_row) do
    local c = v.c
    local r = v.r
    if col == c and r == row then
      print("column:", c, " and row:", r, " has been set repeated!")
    end
  end
  table.insert(element_pos_col_row, {c = col, r = row})
  max_column = math.max(col, max_column)
  offset = offset or ccp(0, 0)
  local ox, oy = 600, 360
  local pos = ccp(ox + 200 * (col - 1), oy - 60 * (row - 1))
  return ccpAdd(pos, offset)
end

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

local function getInputString(self)
  return tostring(self.number:getText()) or nil
end

class.getInputString = getInputString

local function getInput(self, number)
  return tonumber(self.number:getText()) or number
end

class.getInput = getInput
local toast_pos = ccp(400, 430)

local function getSkillLevels(hero, level)
  if not hero then
    return
  end
  local levels = {}
  local skills = ed.getAllSkills(hero._tid)
  local readingBuff = ed.getReadingLevelBuff()
  for i, v in pairs(skills) do
    levels[v.Slot] = level + readingBuff.skillLevelAdd
  end
  local baseSkillSlot = 5
  levels[baseSkillSlot] = 1
  return levels
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
        for i = 1, 6 do
          local item = ed.commonmsg.hero_equip()
          item._index = i
          item._item_id = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", h._tid, h._rank)
          item._exp = 0
          if item._item_id ~= 0 then
            item._exp = 3210
            local rl = ed.getDataTable("equip")[item._item_id]["Level Requirement"]
            if rl > h._level then
              item._item_id = 0
            end
          end
          h._items[i] = item
        end
        h._skill_levels = getSkillLevels(h, h._level)
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

local function awake_handler()
  for id, hero in pairs(ed.player.heroes) do
    if hero._arousal then
      hero._arousal._status = 1
    else
      hero._arousal = {_status = 1}
    end
    if not ed.canAwake(hero._tid) then
      hero._arousal._status = 0
    else
      local heroTaskTable = ed.getDataTable("HeroTask")
      for k, v in pairs(heroTaskTable) do
        if k ~= "name" and v[1] and v[1]["Hero ID"] == hero._tid and not v[1]["Is Artifact"] then
          for m, n in pairs(v) do
            if v[m]["Task Progress Type"] == "EquipItem" then
              local pid = v[m]["Task Progress ID"]
              if pid[1] ~= 0 then
                local item = ed.commonmsg.hero_equip()
                item._index = 1
                item._item_id = pid[1]
                item._exp = 3210
                hero._items[1] = item
              end
            end
          end
        end
      end
    end
  end
end

local function s_awake_handler()
  for id, hero in pairs(ed.player.heroes) do
    if hero._hero_rune then
      hero._hero_rune._status = 1
    else
      hero._hero_rune = {_status = 1}
    end
    if not ed.canSuperAwake(hero._tid) then
      hero._hero_rune._status = 0
    else
      local heroTaskTable = ed.getDataTable("HeroTask")
      for k, v in pairs(heroTaskTable) do
        if k ~= "name" and v[1] and v[1]["Hero ID"] == hero._tid and v[1]["Is Artifact"] then
          for m, n in pairs(v) do
            if v[m]["Task Progress Type"] == "EquipItem" then
              local pid = v[m]["Task Progress ID"]
              if pid[1] ~= 0 then
                local item = ed.commonmsg.hero_equip()
                item._index = 1
                item._item_id = pid[1]
                item._exp = 3210
                hero._items[1] = item
              end
            end
          end
        end
      end
    end
  end
end

local button_config = {
  {
    label = string.format("\230\136\145\230\152\175\229\156\159\232\177\170\n\239\188\136\233\187\152\232\174\164%s\231\186\167\239\188\137", maxHeroLevel),
    icon = "z10005_s.jpg",
    pos = getElementPos(-1, 1),
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
          local amount = 0
          local bits = ed.packItem(id, amount)
          table.insert(msg._set_items, bits)
        end
      end
      local sbdt = ed.getDataTable("SchoolBook")
      local bookList = {}
      for id, _ in ipairs(sbdt) do
        table.insert(bookList, id)
      end
      msg._set_books = bookList
      msg._set_buildings_max_level = 1
      ed.send(msg, "gm_cmd")
      imIsTyrant(rn, nextAction)
    end
  },
  {
    label = "\229\136\160\229\143\183\233\135\141\231\187\131",
    icon = "s595.jpg",
    pos = getElementPos(-1, 2),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._reset_device = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\136\160\229\143\183\233\135\141\231\187\131", toast_pos)
    end
  },
  {
    label = "\228\184\128\233\148\174\233\153\164\229\176\152",
    icon = "s454.jpg",
    pos = getElementPos(-1, 3),
    size = CCSizeMake(200, 60),
    handler = function()
      ed.guide.manager:skipAllGuide()
      ed.showToast("\229\183\178\229\142\187\233\153\164\230\137\128\230\156\137\230\150\176\230\137\139\229\188\149\229\175\188", toast_pos)
    end
  },
  {
    label = T("\230\136\145\230\152\175\228\191\157\229\174\136\231\154\132\229\156\159\232\177\170\n\230\136\152\228\186\137\229\173\166\233\153\162\231\173\137\231\186\167\228\184\1861"),
    icon = "z10005_s.jpg",
    pos = getElementPos(-1, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
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
          local amount = 0
          local bits = ed.packItem(id, amount)
          table.insert(msg._set_items, bits)
        end
      end
      ed.send(msg, "gm_cmd")
      imIsTyrant(rn)
    end
  },
  {
    label = T("\232\142\183\229\190\151\230\137\128\230\156\137\232\139\177\233\155\132"),
    icon = "1011.jpg",
    pos = getElementPos(-1, 5),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._get_all_heroes = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\137\128\230\156\137\232\139\177\233\155\132"), toast_pos)
    end
  },
  {
    label = "\229\188\128\229\144\175\231\165\158\231\167\152\229\149\134\229\186\151",
    icon = "b39+.jpg",
    pos = getElementPos(5, 2),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._open_mystery_shop = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\188\128\229\144\175\231\165\158\231\167\152\229\149\134\229\186\151", toast_pos)
    end
  },
  {
    label = "\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161",
    icon = "1308.jpg",
    pos = getElementPos(0, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._unlock_all_stages = 65536
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161", toast_pos)
    end
  },
  {
    label = "\229\188\128\229\144\175\229\133\179\229\141\161",
    icon = "716.jpg",
    pos = getElementPos(0, 2),
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
  {
    label = "\232\191\155\229\133\165\229\133\179\229\141\161",
    icon = "b23_0.jpg",
    pos = getElementPos(0, 3),
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
  {
    label = T("\232\142\183\229\190\151\233\135\145\233\146\177"),
    icon = "955.jpg",
    pos = getElementPos(0, 4),
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
  {
    label = T("\232\142\183\229\190\151\233\146\187\231\159\179"),
    icon = "957.jpg",
    pos = getElementPos(0, 5),
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
  {
    label = T("\229\133\133\229\128\188"),
    icon = "1650.jpg",
    pos = getElementPos(0, 6),
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
  {
    label = "<-",
    pos = getElementPos(1, 1, ccp(75, 0)),
    size = CCSizeMake(50, 50),
    inWidth = 30,
    color = special_button_color,
    handler = function(self)
      local num = tonumber(self.number:getText()) or 0
      if num == 0 then
        self.number:setText("")
      else
        self.number:setText(math.floor(num / 10))
      end
    end
  },
  {
    id = "atk_ratio",
    label = "\232\174\190\231\189\174\229\183\177\230\150\185\228\188\164\229\174\179\229\128\141\231\142\135\n\229\189\147\229\137\141\239\188\154" .. ed.gmconfig.attack_ratio,
    icon = "113.jpg",
    pos = getElementPos(1, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local num = tonumber(self.number:getText()) or 0
      ed.gmconfig.attack_ratio = num
      ed.setString(self.buttonLabel.atk_ratio, "\232\174\190\231\189\174\229\183\177\230\150\185\228\188\164\229\174\179\229\128\141\231\142\135\n\229\189\147\229\137\141\239\188\154" .. ed.gmconfig.attack_ratio)
      ed.showToast(string.format("\229\183\177\230\150\185\232\139\177\233\155\132\228\188\164\229\174\179\229\128\141\231\142\135\232\174\190\231\189\174\228\184\186%d\229\128\141", num))
    end
  },
  {
    label = "\232\142\183\229\190\151\230\136\152\233\152\159\231\187\143\233\170\140",
    pos = getElementPos(1, 6, ccp(-50, 0)),
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
  {
    label = "\230\152\190\231\164\186FPS",
    pos = getElementPos(1, 6, ccp(50, 0)),
    size = CCSizeMake(95, 60),
    color = special_button_color,
    handler = function(self)
      local isShow = CCDirector:sharedDirector():isDisplayStats()
      CCDirector:sharedDirector():setDisplayStats(not isShow)
    end
  },
  {
    label = T("\232\139\177\233\155\132\229\141\135\231\186\167\229\136\176"),
    icon = "s15.jpg",
    pos = getElementPos(2, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local num = tonumber(self.number:getText()) or 1
      num = math.min(math.max(num, 1), maxHeroLevel)
      for id, hero in pairs(ed.player.heroes) do
        hero._level = num
        hero._rank = math.ceil(num / 10)
        if hero:isTitan() then
          hero._rank = 16
        end
        for i, item in ipairs(hero._items) do
          item._item_id = 0
          item._exp = 0
        end
      end
      class.syncHero()
      ed.showToast("\230\137\128\230\156\137\232\139\177\233\155\132\229\141\135\231\186\167\229\136\176" .. num .. T("\231\186\167"), toast_pos)
    end
  },
  {
    label = T("\232\139\177\233\155\132\232\191\155\229\140\150\229\136\176"),
    icon = "564.jpg",
    pos = getElementPos(2, 2),
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
      class.syncHero()
      ed.showToast("\230\137\128\230\156\137\232\139\177\233\155\132\232\191\155\229\140\150\229\136\176" .. num .. "\230\152\159", toast_pos)
    end
  },
  {
    label = T("\230\136\152\233\152\159\229\141\135\231\186\167\232\135\179"),
    icon = "1253.jpg",
    pos = getElementPos(2, 3),
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
  {
    label = T("\232\142\183\229\190\151\230\137\128\230\156\137\232\163\133\229\164\135"),
    icon = "b8_0.jpg",
    pos = getElementPos(2, 4),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._gain_all_items = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\137\128\230\156\137\232\163\133\229\164\135"), toast_pos)
    end
  },
  {
    label = T("\230\183\187\229\138\160\233\129\147\229\133\183"),
    icon = "x24.jpg",
    pos = getElementPos(2, 5),
    size = CCSizeMake(200, 60),
    handler = function()
      package.loaded["gmtools/addequip"] = nil
      require("gmtools/addequip")
      ed.pushScene(ed.ui.addequip.create())
    end
  },
  {
    label = "\229\173\152\230\161\163\232\135\179",
    pos = getElementPos(2, 6, ccp(-50, 0)),
    size = CCSizeMake(95, 60),
    color = special_button_color,
    handler = function(self)
      local id = tonumber(self.number:getText())
      local msg = ed.upmsg.gm_cmd()
      msg._archive_id = id
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\173\152\230\161\163\230\136\144\229\138\159\239\188\154" .. id, toast_pos)
    end
  },
  {
    label = "\232\175\187\230\161\163\232\135\179",
    pos = getElementPos(2, 6, ccp(45, 0)),
    size = CCSizeMake(95, 60),
    color = special_button_color,
    handler = function(self)
      local id = tonumber(self.number:getText())
      local msg = ed.upmsg.gm_cmd()
      msg._restore_id = id
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\175\187\230\161\163\230\136\144\229\138\159\239\188\154" .. id, toast_pos)
    end
  },
  {
    label = "\232\174\190\231\189\174\232\191\158\231\187\173\231\153\187\233\153\134\229\164\169\230\149\176",
    icon = "x780.jpg",
    pos = getElementPos(3, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_dailylogin_days = tonumber(self.number:getText()) or 0
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = "\232\174\190\231\189\174\229\133\141\232\180\185\230\137\171\232\141\161\230\172\161\230\149\176",
    icon = "390.jpg",
    pos = getElementPos(3, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._reset_sweep = tonumber(self.number:getText()) or 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\141\232\180\185\230\137\171\232\141\161\230\172\161\230\149\176\231\189\174\228\184\186%d\230\172\161", msg._reset_sweep), toast_pos)
    end
  },
  {
    label = T("\232\139\177\233\155\132\230\138\128\232\131\189\230\187\161\231\186\167"),
    icon = "s14.jpg",
    pos = getElementPos(3, 3),
    size = CCSizeMake(200, 60),
    handler = function()
      for id, hero in pairs(ed.player.heroes) do
        local level = hero._level
        hero._skill_levels = getSkillLevels(hero, level)
      end
      class.syncHero()
      ed.showToast(T("\232\139\177\233\155\132\230\138\128\232\131\189\230\187\161\231\186\167"), toast_pos)
    end
  },
  {
    label = T("\229\133\133\229\128\188\230\184\133\233\155\182"),
    icon = "s260.jpg",
    pos = getElementPos(3, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_recharge_sum = 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\133\229\128\188\230\184\133\233\155\182"), toast_pos)
    end
  },
  {
    label = "\230\184\133\233\153\164\233\146\187\231\159\179",
    icon = "s614.jpg",
    pos = getElementPos(3, 5),
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
  {
    label = "\230\184\133\233\153\164\233\135\145\233\146\177",
    icon = "s650.jpg",
    pos = getElementPos(3, 6),
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
  {
    label = T("\232\139\177\233\155\132\230\138\128\232\131\189\233\135\141\231\189\174"),
    icon = "s180.jpg",
    pos = getElementPos(4, 1),
    size = CCSizeMake(200, 60),
    handler = function()
      for id, hero in pairs(ed.player.heroes) do
        hero._skill_levels = ed.getInitSkillLevels(hero._tid)
      end
      class.syncHero()
      ed.showToast(T("\232\139\177\233\155\132\230\138\128\232\131\189\233\135\141\231\189\174"), toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\232\191\156\229\190\129\231\161\172\229\184\129"),
    icon = "s33.jpg",
    pos = getElementPos(4, 2),
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
  {
    label = T("\232\142\183\229\190\151\231\171\158\230\138\128\229\156\186\231\161\172\229\184\129"),
    icon = "x673.jpg",
    pos = getElementPos(4, 3),
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
  {
    label = "\230\184\133\233\153\164\232\191\156\229\190\129\231\161\172\229\184\129",
    icon = "s10160.jpg",
    pos = getElementPos(4, 4),
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
  {
    label = "\230\184\133\233\153\164\231\171\158\230\138\128\229\156\186\231\161\172\229\184\129",
    icon = "s10295.jpg",
    pos = getElementPos(4, 5),
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
  {
    label = T("\232\142\183\229\190\151\232\139\177\233\155\132\229\138\168\231\148\187"),
    icon = "x673.jpg",
    pos = getElementPos(4, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      if not ed.player:getHero(number) then
        ed.showToast(T("\230\154\130\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
      else
        ed.ui.SummonRewardCardWindow.create({
          rewards = {
            {
              id = number,
              amount = 1,
              type = "hero"
            }
          },
          noRewards = true
        }):popWindow()
      end
    end
  },
  {
    label = "\229\188\128\229\144\175\230\152\159\233\153\133\229\149\134\229\186\151",
    icon = "b39+.jpg",
    pos = getElementPos(5, 1),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._open_mystery_shop = 6
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\188\128\229\144\175\230\152\159\233\153\133\229\149\134\229\186\151", toast_pos)
    end
  },
  {
    label = "\232\191\155\229\133\165\228\184\187\231\149\140\233\157\162",
    icon = "cs45.jpg",
    pos = getElementPos(-1, 6),
    size = CCSizeMake(200, 60),
    handler = function()
      ed.engine.running = false
      ed.popScene()
      ed.replaceScene(ed.ui.mainScene.create())
    end
  },
  {
    label = "\229\188\128\229\144\175\229\155\162\233\152\159\229\137\175\230\156\172",
    icon = "s655.jpg",
    pos = getElementPos(5, 3),
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
  {
    label = "\232\191\155\229\133\165\229\155\162\233\152\159\229\137\175\230\156\172",
    icon = "s715.jpg",
    pos = getElementPos(5, 4),
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
      guildInstanceData._wave_index = waveId
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
  {
    label = T("\232\142\183\229\190\151\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129"),
    icon = "s985.jpg",
    pos = getElementPos(5, 5),
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
  {
    label = "\230\184\133\233\153\164\229\133\132\229\188\159\228\188\154\231\161\172\229\184\129",
    icon = "s735.jpg",
    pos = getElementPos(5, 6),
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
  {
    label = "POM RUN",
    icon = "s332.jpg",
    pos = getElementPos(6, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      package.loaded["ui/fruit/mango"] = nil
      require("ui/fruit/mango")
      ed.pushScene(ed.fruit.mango.create())
    end
  },
  {
    label = "Console",
    pos = getElementPos(6, 2),
    size = CCSizeMake(200, 60),
    inWidth = 135,
    handler = function()
      print([[
								
	****************************************************
	1. Get equipments:
	>>> addEquip([equip ID], [count])

	2. Sync hero info to server:
	>>> syncHero([ID or name])
							
	3. Exit console and resume the game:
	>>> cont
	****************************************************
	
								]])
      
      function addEquip(id, count)
        ed.player:gmAddEquip(id, count)
      end
      
      EDDebug()
    end
  },
  {
    label = T("\232\174\190\231\189\174\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166"),
    icon = "s316.jpg",
    pos = getElementPos(6, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_liveness = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\229\133\172\228\188\154\230\180\187\232\183\131\229\186\166" .. number, toast_pos)
    end
  },
  {
    label = "\233\135\141\230\150\176\229\138\160\232\189\189gm\229\156\186\230\153\175",
    icon = "s774.jpg",
    color = special_button_color,
    pos = getElementPos(6, 4),
    size = CCSizeMake(200, 60),
    handler = function()
      EGClearLoaded("gmtools/gm")
      ed.popScene()
      ed.gggggm()
    end
  },
  {
    label = ed.gmconfig.exercise_open and "\229\133\179\233\151\173\230\137\128\230\156\137\230\180\187\229\138\168\229\137\175\230\156\172" or "\229\188\128\229\144\175\230\137\128\230\156\137\230\180\187\229\138\168\229\137\175\230\156\172",
    icon = "cs22.jpg",
    id = "exercise_switch",
    pos = getElementPos(6, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._stage_id = 0
      ed.send(msg, "gm_cmd")
      ed.gmconfig.exercise_open = not ed.gmconfig.exercise_open
      if ed.gmconfig.exercise_open then
        ed.setString(self.buttonLabel.exercise_switch, "\229\188\128\229\144\175\230\137\128\230\156\137\230\180\187\229\138\168\229\137\175\230\156\172")
        ed.showToast("\229\188\128\229\144\175\230\137\128\230\156\137\230\180\187\229\138\168\229\137\175\230\156\172", toast_pos)
      else
        ed.setString(self.buttonLabel.exercise_switch, "\229\133\179\233\151\173\230\137\128\230\156\137\230\180\187\229\138\168\229\137\175\230\156\172")
        ed.showToast("\229\133\179\233\151\173\230\137\128\230\156\137\230\180\187\229\138\168\229\137\175\230\156\172", toast_pos)
      end
    end
  },
  {
    label = T("\230\137\128\230\156\137\232\139\177\233\155\132\232\167\137\233\134\146"),
    icon = "s63.jpg",
    pos = getElementPos(6, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      awake_handler()
      class.syncHero()
      ed.showToast("\230\137\128\230\156\137\232\139\177\233\155\132\232\167\137\233\134\146", toast_pos)
    end
  },
  {
    label = T("\232\174\190\229\174\154\230\180\151\231\130\188NPC\231\187\143\233\170\140\228\184\186\239\188\154"),
    icon = "b32_0.jpg",
    pos = getElementPos(7, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._arousal_npc_exp = number
      ed.send(msg, "gm_cmd")
      ed.showToast(string.format("\232\174\190\229\174\154\230\180\151\231\130\188NPC\231\187\143\233\170\140\239\188\154%d", number), toast_pos)
    end
  },
  {
    label = "\229\174\140\230\136\144\229\189\147\229\137\141\232\167\137\233\134\146\228\187\187\229\138\161",
    icon = "cs43.jpg",
    pos = getElementPos(7, 2),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._finish_hero_task = 0
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\174\140\230\136\144\229\189\147\229\137\141\232\167\137\233\134\146\228\187\187\229\138\161", toast_pos)
    end
  },
  {
    label = string.format("\230\136\145\230\152\175\228\191\157\229\174\136\231\154\132\229\156\159\232\177\170\n\239\188\136\233\187\152\232\174\164%s\231\186\167\239\188\137", amostMaxHeroLevel),
    icon = "s205.jpg",
    pos = getElementPos(7, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local rn = math.min(tonumber(self.number:getText()) or amostMaxHeroLevel, amostMaxHeroLevel)
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
          local amount = 0
          local bits = ed.packItem(id, amount)
          table.insert(msg._set_items, bits)
        end
      end
      ed.send(msg, "gm_cmd")
      ed.showAlertDialog({
        text = string.format("%s\231\186\167\228\191\157\229\174\136\229\156\159\232\177\170\230\136\145\228\187\172\229\129\154\230\156\139\229\143\139\229\144\167\239\188\129\n\239\188\136\232\139\177\233\155\132\231\149\153\229\156\168\230\187\161\232\163\133\229\164\135\231\154\132\230\156\128\229\144\142\228\184\128\233\152\182\239\188\137", rn),
        buttonText = "\229\165\189\229\144\167",
        handler = function()
          local msg = ed.upmsg.gm_cmd()
          msg._set_money = ed.upmsg.set_money()
          msg._set_money._type = "diamond"
          msg._set_money._amount = 9999999
          msg._set_hero_info = {}
          for id, hero in pairs(ed.player.heroes) do
            local h = ed.commonmsg.hero()
            h._tid = hero._tid
            h._level = rn
            h._stars = 5
            h._rank = getAlmostMaxRank(h._tid, h._level)
            h._exp = 0
            h._gs = 5000
            h._state = "idle"
            h._items = {}
            for i = 1, 6 do
              local item = ed.commonmsg.hero_equip()
              item._index = i
              item._item_id = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", h._tid, h._rank)
              item._exp = 0
              if item._item_id ~= 0 then
                item._exp = 3210
                local rl = ed.getDataTable("equip")[item._item_id]["Level Requirement"]
                if rl > h._level then
                  item._item_id = 0
                end
              end
              h._items[i] = item
            end
            h._skill_levels = getSkillLevels(h, h._level)
            table.insert(msg._set_hero_info, h)
          end
          ed.send(msg, "gm_cmd")
        end
      })
    end
  },
  {
    label = "\232\142\183\229\190\151\228\184\170\228\186\186\230\156\136\229\141\161",
    icon = "536.jpg",
    pos = getElementPos(7, 4),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._get_month_card = 1
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = T("\232\142\183\229\190\151\229\183\133\229\179\176\231\161\172\229\184\129"),
    icon = "s203.jpg",
    pos = getElementPos(7, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "honourpoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\229\183\133\229\179\176\231\161\172\229\184\129\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = "\230\184\133\233\153\164\229\183\133\229\179\176\231\161\172\229\184\129",
    icon = "s195.jpg",
    pos = getElementPos(7, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "honourpoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\184\133\233\153\164\229\183\133\229\179\176\231\161\172\229\184\129\239\188\154", toast_pos)
    end
  },
  {
    label = "\229\188\128\229\144\175\231\165\158\231\167\152\233\129\151\232\191\185",
    icon = "s914.jpg",
    pos = getElementPos(8, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._open_ancients = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\231\165\158\231\167\152\233\129\151\232\191\185\229\183\178\231\187\143\229\188\128\229\144\175", toast_pos)
    end
  },
  {
    label = "\229\133\179\233\151\173\231\165\158\231\167\152\233\129\151\232\191\185",
    icon = "s920.jpg",
    pos = getElementPos(8, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._close_ancients = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\231\165\158\231\167\152\233\129\151\232\191\185\229\183\178\231\187\143\229\133\179\233\151\173", toast_pos)
    end
  },
  {
    label = "\232\191\155\229\133\165\230\151\182\232\163\133\229\149\134\229\186\151",
    icon = "b16_0.jpg",
    pos = getElementPos(8, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      ed.pushScene(ed.ui.fashionscene.create())
    end
  },
  {
    label = "\232\142\183\229\190\151\229\190\129\230\156\141\231\161\172\229\184\129",
    icon = "s112.jpg",
    pos = getElementPos(8, 4),
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
  {
    label = T("\232\142\183\229\190\151\230\162\166\229\162\131\229\184\129"),
    icon = "b28_0.jpg",
    pos = getElementPos(8, 5),
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
  {
    label = T("\230\184\133\233\153\164\230\137\128\230\156\137\232\163\133\229\164\135"),
    icon = "b27_0.jpg",
    pos = getElementPos(8, 6),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._clear_item = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\184\133\233\153\164\230\137\128\230\156\137\232\163\133\229\164\135"), toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\230\156\168\229\164\180"),
    icon = "700.jpg",
    pos = getElementPos(9, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "wood"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\156\168\229\164\180\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\233\147\129"),
    icon = "704.jpg",
    pos = getElementPos(9, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "iron"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\233\147\129\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\230\176\180\230\153\182"),
    icon = "708.jpg",
    pos = getElementPos(9, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "crystal"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\176\180\230\153\182\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\231\173\137\231\186\167"),
    icon = "s316.jpg",
    pos = getElementPos(9, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(117)
      local msg = ed.upmsg.gm_cmd()
      msg._set_real_arena = ed.upmsg.set_real_arena()
      msg._set_real_arena._type = "level"
      msg._set_real_arena._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\231\173\137\231\186\167\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\n\231\142\139\232\128\133\231\167\175\229\136\134"),
    icon = "s330.jpg",
    pos = getElementPos(9, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_real_arena = ed.upmsg.set_real_arena()
      msg._set_real_arena._type = "score"
      msg._set_real_arena._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\n\228\188\145\233\151\178\231\167\175\229\136\134"),
    icon = "s695.jpg",
    pos = getElementPos(9, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_real_arena = ed.upmsg.set_real_arena()
      msg._set_real_arena._type = "casual_score"
      msg._set_real_arena._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\228\188\145\233\151\178\231\167\175\229\136\134\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\230\184\133\231\169\186\230\156\168\229\164\180"),
    icon = "698.jpg",
    pos = getElementPos(10, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "wood"
      msg._set_money._amount = 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\178\230\184\133\231\169\186"), toast_pos)
    end
  },
  {
    label = T("\230\184\133\231\169\186\231\148\159\233\147\129"),
    icon = "702.jpg",
    pos = getElementPos(10, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "iron"
      msg._set_money._amount = 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\178\230\184\133\231\169\186"), toast_pos)
    end
  },
  {
    label = T("\230\184\133\231\169\186\230\176\180\230\153\182"),
    icon = "706.jpg",
    pos = getElementPos(10, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "crystal"
      msg._set_money._amount = 0
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\183\178\230\184\133\231\169\186"), toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\232\131\189\233\135\143"),
    icon = "372.jpg",
    pos = getElementPos(10, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "energy"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\232\131\189\233\135\143\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\229\156\163\231\186\185\231\161\172\229\184\129"),
    icon = "589.jpg",
    pos = getElementPos(10, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "gcwpoint"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\229\156\163\231\186\185\231\161\172\229\184\129\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\175\187\228\185\166\231\173\137\231\186\167"),
    icon = "1054.jpg",
    pos = getElementPos(11, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_book_level = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\175\187\228\185\166\231\173\137\231\186\167") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\175\187\228\185\166\231\187\143\233\170\140"),
    icon = "935.jpg",
    pos = getElementPos(11, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_book_exp = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\175\187\228\185\166\231\187\143\233\170\140\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\230\130\172\232\181\143\230\160\143\231\173\137\231\186\167"),
    icon = "s710.jpg",
    pos = getElementPos(11, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_quest_level = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\130\172\232\181\143\230\160\143\231\173\137\231\186\167\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\233\173\148\231\142\139\229\176\129\229\141\176\232\191\155\229\186\166"),
    icon = "s10214.jpg",
    pos = getElementPos(11, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(105)
      local msg = ed.upmsg.gm_cmd()
      msg._set_devilseal = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\230\136\152\230\150\151\230\160\161\233\170\140"),
    icon = "s100.jpg",
    pos = getElementPos(11, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      if not ed.testBattleCheck then
        ed.testBattleCheck = require("battle.test_battle_check"):new()
      end
      ed.testBattleCheck:battleCheckEnterStage(self:getInputString())
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\139\177\233\155\132\230\180\151\231\130\188\229\177\158\230\128\167"),
    icon = "s10202.jpg",
    pos = getElementPos(10, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local row = ed.getDataTable("AwakeNPC")[ed.player._arousal_level]
      local max = row["Max Limit"]
      local number = self:getInput(max)
      if max < number then
        number = max
      end
      for id, hero in pairs(ed.player.heroes) do
        if ed.awakeUnlocked(id) then
          hero._arousal._str = number
          hero._arousal._agi = number
          hero._arousal._int = number
        end
      end
      class.syncHero()
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\228\184\128\233\148\174\230\187\161\233\153\132\233\173\148"),
    icon = "s685.jpg",
    pos = getElementPos(11, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      for id, hero in pairs(ed.player.heroes) do
        for equip_idx = 1, 6 do
          local le, ml = ed.readequip.getEquipLevelExp(hero._tid, equip_idx)
          if ml then
            local maxExp = 0
            for i = 1, ml do
              maxExp = maxExp + le[i]
            end
            hero._items[equip_idx]._exp = maxExp
          end
        end
      end
      class.syncHero()
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\230\180\151\231\130\188\231\173\137\231\186\167"),
    icon = "s560.jpg",
    pos = getElementPos(12, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      if not number then
        ed.showToast(T("\232\175\183\229\133\136\232\190\147\229\133\165\230\180\151\231\130\188\231\173\137\231\186\167"), toast_pos)
        return
      end
      local msg = ed.upmsg.gm_cmd()
      msg._set_npc_level = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\233\169\190\233\169\182\232\131\189\233\135\143"),
    icon = "s605.jpg",
    pos = getElementPos(12, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      if not number then
        ed.showToast(T("\232\175\183\229\133\136\232\190\147\229\133\165\233\169\190\233\169\182\232\131\189\233\135\143"), toast_pos)
        return
      end
      local msg = ed.upmsg.gm_cmd()
      msg._set_drive_energy = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\233\169\190\233\169\182\231\187\143\233\170\140"),
    icon = "1250.jpg",
    pos = getElementPos(12, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      if not number then
        ed.showToast(T("\232\175\183\229\133\136\232\190\147\229\133\165\233\169\190\233\169\182\231\187\143\233\170\140"), toast_pos)
        return
      end
      local msg = ed.upmsg.gm_cmd()
      msg._set_drive_exp = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\229\133\172\228\188\154\n\232\139\177\233\155\132\231\173\137\231\186\167"),
    icon = "s645.jpg",
    pos = getElementPos(12, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      if not number then
        ed.showToast(T("\232\175\183\229\133\136\232\190\147\229\133\165\228\188\154\232\139\177\233\155\132\231\173\137\231\186\167"), toast_pos)
        return
      end
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_hero = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\230\183\187\229\138\160\229\133\172\228\188\154\n\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179"),
    icon = "s644.jpg",
    pos = getElementPos(12, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      if not number then
        ed.showToast(T("\232\175\183\229\133\136\232\190\147\229\133\165\229\133\172\228\188\154\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179\228\184\170\230\149\176"), toast_pos)
        return
      end
      local msg = ed.upmsg.gm_cmd()
      msg._add_guild_hero_stone = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\229\173\166\228\185\160\229\189\147\229\137\141\230\137\128\230\156\137\228\185\166\231\177\141\230\138\128\232\131\189"),
    icon = "1163.jpg",
    pos = getElementPos(12, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local sbdt = ed.getDataTable("SchoolBook")
      local bookList = {}
      for id, _ in ipairs(sbdt) do
        local bookInfo = ed.player:getWarschoolBook(id)
        if not bookInfo.composeInfo then
          table.insert(bookList, id)
        end
      end
      local msg = ed.upmsg.gm_cmd()
      msg._set_books = bookList
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\232\190\147\229\133\165\229\147\129\233\152\182\239\188\140\228\184\128\233\148\174\n\230\187\161\232\163\133\229\164\135\230\187\161\233\153\132\233\173\148"),
    icon = "935.jpg",
    pos = getElementPos(13, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      if not number then
        ed.showToast(T("\232\175\183\229\133\136\232\190\147\229\133\165\232\139\177\233\155\132\229\147\129\233\152\182"), toast_pos)
        return
      end
      if number < 1 or number > maxHeroRank then
        ed.showToast(T("\232\139\177\233\155\132\229\147\129\233\152\182\232\190\147\229\133\165\230\156\137\232\175\175"), toast_pos)
        return
      end
      local maxReqLevel = getAllHeroMaxReqLevel(number)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "diamond"
      msg._set_money._amount = 9999999
      msg._set_hero_info = {}
      for id, hero in pairs(ed.player.heroes) do
        local h = ed.commonmsg.hero()
        h._tid = hero._tid
        h._level = maxReqLevel
        h._stars = 5
        h._rank = number
        h._exp = 0
        h._gs = 5000
        h._state = "idle"
        h._items = {}
        for i = 1, 6 do
          local item = ed.commonmsg.hero_equip()
          item._index = i
          item._item_id = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", h._tid, h._rank)
          item._exp = 0
          if item._item_id ~= 0 then
            item._exp = 3300
            local rl = ed.getDataTable("equip")[item._item_id]["Level Requirement"]
            if rl > h._level then
              item._item_id = 0
            end
          end
          h._items[i] = item
        end
        h._skill_levels = getSkillLevels(h, h._level)
        table.insert(msg._set_hero_info, h)
      end
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\n\231\142\139\232\128\133\229\190\189\232\174\176"),
    icon = "1082.jpg",
    pos = getElementPos(13, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_real_arena = ed.upmsg.set_real_arena()
      msg._set_real_arena._type = "points"
      msg._set_real_arena._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\175\184\231\142\139\228\186\137\233\156\184\231\142\139\232\128\133\229\190\189\232\174\176\239\188\154") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\167\137\233\134\146\232\139\177\233\155\132"),
    icon = "s445.jpg",
    pos = getElementPos(13, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(0)
      if number ~= 0 then
        local msg = ed.upmsg.gm_cmd()
        msg._set_arousal_hero = number
        ed.send(msg, "gm_cmd")
        ed.showToast(T("\232\174\190\231\189\174\232\167\137\233\134\146\232\139\177\233\155\132\239\188\154") .. number, toast_pos)
      else
        ed.showToast(T("\232\174\190\231\189\174\232\167\137\233\134\146\232\139\177\233\155\132 ID \233\148\153\232\175\175\239\188\154") .. number, toast_pos)
      end
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\182\133\232\167\137\233\134\146\232\139\177\233\155\132"),
    icon = "s535.jpg",
    pos = getElementPos(13, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(0)
      local hero = ed.player:getHero(number)
      if hero then
        if not ed.protoAwake(hero) then
          ed.showToast(T("\232\175\183\229\133\136\232\167\137\233\134\146\232\175\165\232\139\177\233\155\132!"), toast_pos)
          return
        end
        local msg = ed.upmsg.gm_cmd()
        msg._set_rune_hero = number
        ed.send(msg, "gm_cmd")
        ed.showToast(T("\232\174\190\231\189\174\232\182\133\232\167\137\233\134\146\232\139\177\233\155\132\239\188\154") .. number, toast_pos)
      else
        ed.showToast(T("\233\157\158\230\179\149\231\154\132\232\139\177\233\155\132ID!"), toast_pos)
      end
    end
  },
  {
    label = T("\232\142\183\229\143\150\229\190\189\231\171\160"),
    icon = "1102.jpg",
    pos = getElementPos(13, 5),
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
  {
    label = T("\230\160\161\233\170\140Player\230\149\176\230\141\174"),
    icon = "s10135.jpg",
    color = special_button_color,
    pos = getElementPos(13, 6),
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
  {
    label = T("\232\174\190\231\189\174\233\173\148\230\179\149\233\157\162\229\140\133\230\149\176\233\135\143"),
    icon = "503.jpg",
    pos = getElementPos(14, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_shadow_runes = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\233\173\148\230\179\149\233\157\162\229\140\133\230\149\176\233\135\143 ") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174Module\nSwitch\232\189\172\230\141\162"),
    icon = "s665.jpg",
    pos = getElementPos(14, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 1
      local key, state = changeModuleOpen(number)
      ed.showToast(T("\232\189\172\230\141\162 ") .. key .. " \231\138\182\230\128\129\228\184\186 " .. state, toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\229\164\170\233\152\179\231\159\179\231\178\190\231\178\185"),
    icon = "1285.jpg",
    pos = getElementPos(14, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "sun"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\229\164\170\233\152\179\231\159\179\231\178\190\231\178\185") .. number, toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\230\150\176\230\156\136\231\159\179\231\178\190\231\178\185"),
    icon = "1292.jpg",
    pos = getElementPos(14, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "moon"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\150\176\230\156\136\231\159\179\231\178\190\231\178\185") .. number, toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\230\153\168\230\152\159\231\159\179\231\178\190\231\178\185"),
    icon = "1298.jpg",
    pos = getElementPos(14, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(9999999)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "star"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\230\153\168\230\152\159\231\159\179\231\178\190\231\178\185") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\233\128\154\229\164\169\229\161\148\229\177\130\230\149\176"),
    icon = "s10320.jpg",
    pos = getElementPos(14, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_babel_floor = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\233\128\154\229\164\169\229\161\148\229\177\130\230\149\176 ") .. number, toast_pos)
    end
  },
  {
    label = T("\233\128\154\229\164\169\229\161\148\230\140\145\230\136\152\230\172\161\230\149\176"),
    icon = "s10370.jpg",
    pos = getElementPos(15, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_babel_left_battle_time = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\233\128\154\229\164\169\229\161\148\230\140\145\230\136\152\230\172\161\230\149\176 ") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\229\133\172\228\188\154\229\184\129"),
    icon = "s10413.jpg",
    pos = getElementPos(15, 2),
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
  {
    label = "\230\129\162\229\164\141\228\189\147\229\138\155\229\128\188",
    icon = "505.jpg",
    pos = getElementPos(15, 3),
    size = CCSizeMake(200, 60),
    handler = function()
      local msg = ed.upmsg.gm_cmd()
      msg._set_vitality = 10000
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\129\162\229\164\141\228\189\147\229\138\155\229\128\188", toast_pos)
    end
  },
  {
    label = "\232\174\190\231\189\174\229\133\172\228\188\154\230\136\152\232\131\156\229\156\186\230\149\176",
    icon = "z23.jpg",
    pos = getElementPos(15, 4),
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
      ed.showToast("\232\174\190\231\189\174\229\133\172\228\188\154\230\136\152\232\131\156\229\156\186\230\149\176" .. number, toast_pos)
    end
  },
  {
    label = "\230\130\172\232\181\143\230\160\143\233\157\162\229\140\133",
    icon = "z23.jpg",
    pos = getElementPos(15, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 50
      local msg = ed.upmsg.gm_cmd()
      msg._set_bread = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\230\136\144\229\138\159\230\183\187\229\138\160\233\157\162\229\140\133" .. number, toast_pos)
    end
  },
  {
    label = "\229\188\128\229\144\175\229\185\180\229\133\189\230\180\187\229\138\168",
    icon = "z6_s.jpg",
    pos = getElementPos(15, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = 1
      local msg = ed.upmsg.gm_cmd()
      msg._set_monster = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\188\128\229\144\1753\229\164\169\229\185\180\229\133\189\230\180\187\229\138\168", toast_pos)
    end
  },
  {
    label = T("\230\137\128\230\156\137\232\139\177\233\155\132\232\182\133\232\167\137\233\134\146"),
    icon = "s63.jpg",
    pos = getElementPos(16, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      awake_handler()
      s_awake_handler()
      class.syncHero()
      ed.showToast("\230\137\128\230\156\137\232\139\177\233\155\132\232\182\133\232\167\137\233\134\146", toast_pos)
    end
  },
  {
    label = "\232\174\190\231\189\174\231\190\142\233\163\159\231\187\143\233\170\140",
    icon = "z6_s.jpg",
    pos = getElementPos(16, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = 1
      local msg = ed.upmsg.gm_cmd()
      msg._set_mastery_exp = tonumber(self.number:getText()) or 999999
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\174\190\231\189\174\231\190\142\233\163\159\231\187\143\233\170\140", toast_pos)
    end
  },
  {
    label = "\232\142\183\229\190\151\228\188\160\229\165\135\229\184\129",
    icon = "1082.jpg",
    pos = getElementPos(16, 3),
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
  {
    label = "\232\174\190\231\189\1742v2\228\188\145\233\151\178\231\167\175\229\136\134",
    icon = "1082.jpg",
    pos = getElementPos(16, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_multi_arena_causal_point = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\142\183\229\190\151\228\188\160\229\165\135\229\184\129" .. number, toast_pos)
    end
  },
  {
    label = "\232\174\190\231\189\1742v2\231\171\158\230\138\128\231\167\175\229\136\134",
    icon = "1082.jpg",
    pos = getElementPos(16, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._set_multi_arena_athletics_point = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\142\183\229\190\151\228\188\160\229\165\135\229\184\129" .. number, toast_pos)
    end
  },
  {
    label = "\232\191\156\229\190\129\229\188\128\229\144\175\229\133\179\229\141\161\230\149\176",
    icon = "1082.jpg",
    pos = getElementPos(16, 6),
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
  {
    label = "\232\142\183\229\190\151\229\164\154\228\186\186\229\137\175\230\156\172\233\151\168\231\165\168",
    icon = "1082.jpg",
    pos = getElementPos(17, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 999
      local msg = ed.upmsg.gm_cmd()
      msg._set_multi_stage_ticket = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\142\183\229\190\151\229\164\154\228\186\186\229\137\175\230\156\172\233\151\168\231\165\168" .. number, toast_pos)
    end
  },
  {
    label = "\233\135\141\231\189\174\232\191\156\229\190\129\230\140\145\230\136\152\230\172\161\230\149\176",
    icon = "1082.jpg",
    pos = getElementPos(17, 2),
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
  {
    label = "\232\142\183\229\143\150\232\175\184\231\165\158\229\184\129",
    icon = "1082.jpg",
    pos = getElementPos(17, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or 9999999
      local msg = ed.upmsg.gm_cmd()
      msg._set_mt_point = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\142\183\229\143\150\232\175\184\231\165\158\229\184\129")
    end
  },
  {
    label = "\230\159\165\231\156\139\230\156\172\229\156\176\230\138\165\233\148\153\230\150\135\228\187\182",
    icon = "1082.jpg",
    pos = getElementPos(17, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or ""
      if showLocalError then
        showLocalError(number)
      end
    end
  },
  {
    label = "\230\181\139\232\175\149\229\164\167\233\190\153http",
    icon = "1082.jpg",
    pos = getElementPos(17, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or "0"
      if tonumber(number) >= 1 then
        errReport("crash_dump", "Has Msg", true, 1)
      else
        errReport("crash_dump", "No Msg", false, 1)
      end
      ed.showToast("\229\143\145\233\128\129\230\136\144\229\138\159")
    end
  },
  {
    label = "\230\181\139\232\175\149\230\139\137\229\190\183http",
    icon = "1082.jpg",
    pos = getElementPos(17, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput()
      number = number or "0"
      if tonumber(number) >= 1 then
        errReport("crash_dump", "Has Msg", true, 2)
      else
        errReport("crash_dump", "No Msg", false, 2)
      end
      ed.showToast("\229\143\145\233\128\129\230\136\144\229\138\159")
    end
  },
  {
    label = "\232\142\183\229\143\150\230\137\128\230\156\137\229\174\160\231\137\169",
    icon = "z6_s.jpg",
    pos = getElementPos(17, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._operate_pet = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\143\145\233\128\129\230\136\144\229\138\159")
    end
  },
  {
    label = "\229\136\160\233\153\164\230\137\128\230\156\137\229\174\160\231\137\169",
    icon = "s63.jpg",
    pos = getElementPos(18, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      ed.player.pets = nil
      local msg = ed.upmsg.gm_cmd()
      msg._operate_pet = 0
      ed.send(msg, "gm_cmd")
      ed.showToast("\229\143\145\233\128\129\230\136\144\229\138\159")
    end
  },
  {
    label = "\232\163\133\229\164\135\229\174\160\231\137\169",
    icon = "s63.jpg",
    pos = getElementPos(18, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      ed.player.pets = nil
      local number = tonumber(self:getInput())
      number = number or 0
      local msg = ed.upmsg.gm_cmd()
      msg._equip_pet = number
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\163\133\229\164\135\229\174\160\231\137\169\230\136\144\229\138\159")
    end
  },
  {
    label = "\230\159\165\231\156\139\229\189\149\229\131\143",
    icon = "s63.jpg",
    pos = getElementPos(18, 3),
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
  {
    label = T("\232\174\190\231\189\174\230\183\177\230\181\183\233\177\188\232\130\157\230\178\185"),
    icon = "1298.jpg",
    pos = getElementPos(18, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(10000)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "pet_point"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\230\183\177\230\181\183\233\177\188\232\130\157\230\178\185") .. number, toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\143\150\230\152\159\229\184\129"),
    icon = "1298.jpg",
    pos = getElementPos(18, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(10000)
      local msg = ed.upmsg.gm_cmd()
      msg._set_money = ed.upmsg.set_money()
      msg._set_money._type = "star_point"
      msg._set_money._amount = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\143\150\230\152\159\229\184\129") .. number, toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\232\191\156\229\190\129\233\152\181\229\174\185"),
    icon = "1298.jpg",
    pos = getElementPos(18, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_tbc_oppos = ed.upmsg.set_tbc_oppos()
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\232\191\156\229\190\129\233\152\181\229\174\185\230\136\144\229\138\159"), toast_pos)
    end
  },
  {
    label = T("\232\174\190\231\189\174\229\155\162\230\156\172\232\191\155\229\186\166"),
    icon = "1298.jpg",
    pos = getElementPos(19, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_guild_stage_progress = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\155\162\230\156\172\232\191\155\229\186\166"), toast_pos)
    end
  },
  {
    label = T("\230\179\176\229\157\166\228\184\128\233\148\174\230\187\161\232\163\133"),
    icon = "1298.jpg",
    pos = getElementPos(19, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._imba_titan = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\179\176\229\157\166\228\184\128\233\148\174\230\187\161\232\163\133"), toast_pos)
    end
  },
  {
    label = T("\232\183\179\232\191\135\230\136\152\230\150\151\230\160\161\233\170\140"),
    icon = "1298.jpg",
    pos = getElementPos(19, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._skip_battlecheck = 1
      ed.send(msg, "gm_cmd")
      ed.showToast("\232\183\179\232\191\135\230\136\152\230\150\151\230\160\161\233\170\140", toast_pos)
    end
  },
  {
    label = T("\232\142\183\229\190\151\229\161\148\231\189\151\231\137\140"),
    icon = "1298.jpg",
    pos = getElementPos(19, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = tonumber(self.number:getText())
      if not number then
        ed.showToast("\232\175\183\232\190\147\229\133\165\229\161\148\231\189\151\231\137\140Id", toast_pos)
        return
      end
      local msg = ed.upmsg.gm_cmd()
      msg._gain_tarot_card = number
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = T("\228\184\128\233\148\174\232\142\183\229\143\150\230\169\153\232\137\178\229\161\148\231\189\151\231\137\140"),
    icon = "1298.jpg",
    pos = getElementPos(19, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._gain_all_tarot_cards = 1
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = T("\232\142\183\229\143\150\229\164\167\230\156\136\229\141\161"),
    icon = "1298.jpg",
    pos = getElementPos(19, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._gain_super_monthcard = 1
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = T("\229\162\158\229\138\160\232\135\170\232\181\176\230\163\139\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = getElementPos(20, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_chess_score = number
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = T("\229\162\158\229\138\160\229\165\179\231\165\158\228\185\139\230\136\152\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = getElementPos(20, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_cup_arena_score = number
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = T("\229\162\158\229\138\160\230\151\182\231\169\186\231\167\152\229\162\131\228\187\163\229\184\129"),
    icon = "971.jpg",
    pos = getElementPos(20, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._gain_myth_coin = number
      ed.send(msg, "gm_cmd")
    end
  },
  {
    label = T("\232\174\190\231\189\1745\228\184\170BOSS\232\191\155\229\186\166"),
    icon = "971.jpg",
    pos = getElementPos(20, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_ext()
      msg._five_boss_progress = ed.upmsg.gm_set_five_boss_progress()
      msg._five_boss_progress._set_five_boss_progress = number
      ed.send(msg, "gm_ext")
      ed.showToast(T("\232\174\190\231\189\1745\228\184\170BOSS\232\191\155\229\186\166%s", number))
    end
  },
  {
    label = T("\233\135\141\231\189\1745\228\184\170BOSS\230\140\145\230\136\152\230\172\161\230\149\176"),
    icon = "971.jpg",
    pos = getElementPos(20, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._reset_five_boss_battle = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\233\135\141\231\189\1745\228\184\170BOSS\230\140\145\230\136\152\230\172\161\230\149\176%d", number))
    end
  },
  {
    label = T("\229\162\158\229\138\1605\228\184\170BOSS\231\167\175\229\136\134"),
    icon = "971.jpg",
    pos = getElementPos(20, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._add_five_boss_score = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\162\158\229\138\1605\228\184\170BOSS\231\167\175\229\136\134%d", number))
    end
  },
  {
    label = T("\229\191\171\233\128\159\233\135\141\229\187\186\232\180\166\229\143\183"),
    icon = "971.jpg",
    pos = getElementPos(21, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local actions = {
        class.getButtonConfigByLabel(T("\229\136\160\229\143\183\233\135\141\231\187\131")).handler,
        class.getButtonConfigByLabel(T("\228\184\128\233\148\174\233\153\164\229\176\152")).handler,
        class.getButtonConfigByLabel(string.format(T("\230\136\145\230\152\175\229\156\159\232\177\170\n\239\188\136\233\187\152\232\174\164%s\231\186\167\239\188\137"), maxHeroLevel)).handler,
        class.getButtonConfigByLabel(T("\230\179\176\229\157\166\228\184\128\233\148\174\230\187\161\232\163\133")).handler,
        class.getButtonConfigByLabel(T("\229\188\128\229\144\175\230\137\128\230\156\137\229\133\179\229\141\161")).handler
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
            delayTime = delayTime + gapTime
            ListenTimer(Timer:Once(delayTime), function()
              actions[5](self)
            end)
          end
        end
        ListenTimer(Timer:Once(delayTime), function()
          v(self, nextAction)
        end)
      end
    end
  },
  {
    label = T("\233\135\141\231\189\174\231\167\141\230\151\143\229\161\148\230\140\145\230\136\152\230\172\161\230\149\176"),
    icon = "971.jpg",
    pos = getElementPos(21, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._reset_race_tower_battle = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\233\135\141\231\189\174\231\167\141\230\151\143\229\161\148\230\136\152\230\150\151"))
    end
  },
  {
    label = T("\232\174\190\231\189\174\231\167\141\230\151\143\229\161\148\230\140\145\230\136\152\229\177\130\230\149\176"),
    icon = "971.jpg",
    pos = getElementPos(21, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_race_tower_floor = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\231\167\141\230\151\143\229\161\148\230\140\145\230\136\152\229\177\130\230\149\176%d", number))
    end
  },
  {
    label = T("\229\133\172\228\188\154\229\177\177\229\137\141\232\191\155N\228\184\170BOSS"),
    icon = "971.jpg",
    pos = getElementPos(21, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._next_guild_mount_boss = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\229\133\172\228\188\154\229\177\177\229\137\141\232\191\155%d\228\184\170BOSS", number))
    end
  },
  {
    label = T("\232\139\177\233\155\132PASS\232\174\190\231\189\174\228\187\187\229\138\161\231\130\185"),
    icon = "971.jpg",
    pos = getElementPos(21, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._hero_pass_add_exp = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\139\177\233\155\132PASS\232\174\190\231\189\174\228\187\187\229\138\161\231\130\185%d", number))
    end
  },
  {
    label = T("\230\137\128\230\156\137\232\135\179\229\174\157\232\174\190\228\184\1862\231\186\167"),
    icon = "971.jpg",
    pos = getElementPos(21, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._gain_all_arcana = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\137\128\230\156\137\232\135\179\229\174\157\232\174\190\228\184\1862\231\186\167"))
    end
  },
  {
    label = T("\232\142\183\229\143\150\229\133\173\228\184\170\231\172\166\231\159\179"),
    icon = "971.jpg",
    pos = getElementPos(22, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._gain_some_magicstone = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\143\150\229\133\173\228\184\170\231\172\166\231\159\179"))
    end
  },
  {
    label = T("\232\142\183\229\143\150\230\137\128\230\156\137\231\172\166\231\159\179"),
    icon = "971.jpg",
    pos = getElementPos(22, 2),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._gain_all_magicstone = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\143\150\230\137\128\230\156\137\231\172\166\231\159\179"))
    end
  },
  {
    label = T("\232\142\183\229\143\150\229\191\131\229\138\168\231\164\188\229\140\133"),
    icon = "971.jpg",
    pos = getElementPos(22, 3),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(math.random(1, 40))
      local msg = ed.upmsg.gm_cmd()
      msg._gain_impluse_gift = number
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\142\183\229\190\151\231\164\188\229\140\133: ") .. number)
    end
  },
  {
    label = T("\232\174\190\231\189\174\229\133\168\232\139\177\233\155\132\230\180\151\231\187\131"),
    icon = "971.jpg",
    pos = getElementPos(22, 4),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_all_hero_arousal = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\174\190\231\189\174\229\133\168\232\139\177\233\155\132\230\180\151\231\187\131"))
    end
  },
  {
    label = T("\232\167\163\233\148\129\233\171\152\231\186\167\232\144\140\230\150\176\233\128\154\232\161\140\232\175\129"),
    icon = "971.jpg",
    pos = getElementPos(22, 5),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local number = self:getInput(1)
      local msg = ed.upmsg.gm_cmd()
      msg._set_exp_pass_advance = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\232\167\163\233\148\129\233\171\152\231\186\167\232\144\140\230\150\176\233\128\154\232\161\140\232\175\129"))
    end
  },
  {
    label = T("\230\183\187\229\138\160\231\153\189\229\144\141\229\141\149"),
    icon = "971.jpg",
    pos = getElementPos(22, 6),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_whitelist = 1
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\230\183\187\229\138\160\231\153\189\229\144\141\229\141\149"))
    end
  },
  {
    label = T("\231\167\187\233\153\164\231\153\189\229\144\141\229\141\149"),
    icon = "971.jpg",
    pos = getElementPos(23, 1),
    size = CCSizeMake(200, 60),
    handler = function(self)
      local msg = ed.upmsg.gm_cmd()
      msg._set_whitelist = 2
      ed.send(msg, "gm_cmd")
      ed.showToast(T("\231\167\187\233\153\164\231\153\189\229\144\141\229\141\149"))
    end
  }
}

function class:getButtonConfigByLabel(label)
  for k, v in ipairs(button_config) do
    if label == v.label then
      return v
    end
  end
  return nil
end

function class:getQueryReplayParam(text)
  if text then
    local recordid, serverid
    local len = #text
    local pos1 = string.find(text, "/")
    if pos1 then
      recordid = tonumber(string.sub(text, 1, pos1 - 1))
      serverid = tonumber(string.sub(text, pos1 + 1, len))
    else
      recordid = tonumber(text) or 0
    end
    return recordid, serverid
  end
  return 0
end

local t_number = {
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  "C",
  0,
  "/"
}

local function getNumberPos(i)
  local ox, oy = 550, 312
  local dx, dy = 45, 42
  return ccp(ox + dx * ((i - 1) % 3), oy - dy * math.floor((i - 1) / 3))
end

for i = 1, #t_number do
  local b = {
    label = t_number[i],
    pos = getNumberPos(i),
    size = CCSizeMake(50, 50),
    inWidth = 30,
    color = special_button_color,
    handler = function(self)
      local n = t_number[i]
      local nt = type(n)
      if nt == "string" and n == "C" then
        self.number:setText("")
      else
        local text = self.number:getText()
        if #text < 12 then
          self.number:setText(text .. n)
        end
      end
    end
  }
  table.insert(button_config, b)
end

local function createNumber(self)
  local button = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-detail-n.png", CCRectMake(10, 10, 148, 29))
  local pos = getElementPos(1, 1, ccp(-25, 0))
  local size = CCSizeMake(150, 50)
  local inSize = CCSizeMake(120, 60)
  local color = special_button_color
  local edit = CCEditBox:create(size, button, nil, nil, true)
  edit:setPlaceHolder("\232\175\183\232\190\147\229\133\165\239\188\154")
  edit:setFontColor(normal_button_color)
  edit:setFont(ed.font, 16)
  edit:setPosition(pos)
  self.draglist.listLayer:addChild(edit)
  self.number = edit
end

class.createNumber = createNumber

function syncHero(IDorName)
  local msg = ed.upmsg.gm_cmd()
  msg._set_hero_info = {}
  local hero_list = {}
  for id, hero in pairs(ed.player.heroes) do
    local name = ed.lookupDataTable("Unit", "Unit Name", hero._tid)
    if name == IDorName or hero._tid == IDorName then
      local h = ed.commonmsg.hero()
      h._tid = hero._tid
      h._level = hero._level
      h._stars = hero._stars
      h._rank = hero._rank
      h._exp = hero._exp
      h._state = "idle"
      h._gs = 0
      h._items = hero._items
      h._skill_levels = hero._skill_levels
      table.insert(hero_list, h)
    end
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
end

class.syncHero = syncHero

local function setAllHeroLevel(level)
  local msg = ed.upmsg.gm_cmd()
  msg._set_hero_info = {}
  for id, hero in pairs(ed.player.heroes) do
    hero.data._level = level
    local h = ed.commonmsg.hero()
    h._tid = hero._tid
    h._level = hero._level
    h._rank = math.ceil(level / 10)
    h._exp = hero._exp
    h._gs = 0
    h._state = "idle"
    h._stars = ed.lookupDataTable("Unit", "Initial Stars", h._tid)
    h._items = {}
    h._skill_levels = getSkillLevels(h, level)
    table.insert(msg._set_hero_info, h)
  end
  ed.send(msg, "gm_cmd")
end

class.setAllHeroLevel = setAllHeroLevel

local function setAllHeroToAlmostRanking()
  local msg = ed.upmsg.gm_cmd()
  msg._set_hero_info = {}
  for id, hero in pairs(ed.player.heroes) do
    local h = ed.commonmsg.hero()
    h._tid = hero._tid
    h._rank = hero._rank
    if hero._rank == 10 then
      h._level = 99
    else
      h._level = hero._rank * 10
    end
    local level = h._level
    h._exp = 0
    h._gs = 0
    h._state = "idle"
    h._items = hero._items
    h._skill_levels = {
      level,
      level,
      level,
      level
    }
    table.insert(msg._set_hero_info, h)
  end
  ed.send(msg, "gm_cmd")
end

class.setAllHeroToAlmostRanking = setAllHeroToAlmostRanking

local function doButtonTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      for k, v in pairs(self.numBtns) do
        if ed.containsPoint(v, x, y) then
          self.pressButtonID = k
          
          self.buttonPress[k]:setVisible(true)
          return
        end
      end
      if self.InputBg and ed.containsPoint(self.InputBg, x, y) then
        return
      end
      for k, v in pairs(self.button) do
        if ed.containsPoint(v, x, y) then
          self.pressButtonID = k
          self.buttonPress[k]:setVisible(true)
          break
        end
      end
    elseif event == "ended" then
      local k = self.pressButtonID
      self.pressButtonID = nil
      local dm = self.draglist:getDragMode()
      if k then
        self.buttonPress[k]:setVisible(false)
        if ed.containsPoint(self.button[k], x, y) and not dm and self.buttonHandler[k] then
          self.buttonHandler[k](self)
        end
      end
    end
  end
  
  return handler
end

class.doButtonTouch = doButtonTouch

local function doBackTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui.back, x, y) then
        self.isPressBack = true
        
        self.ui.back_press:setVisible(true)
      end
    elseif event == "ended" then
      local k = self.isPressBack
      self.isPressBack = nil
      if k then
        self.ui.back_press:setVisible(false)
        if ed.containsPoint(self.ui.back, x, y) then
          ed.popScene()
        end
      end
    end
  end
  
  return handler
end

class.doBackTouch = doBackTouch

local function doMainLayerTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      self:doBackTouch()(event, x, y)
      
      self:doButtonTouch()(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function createButton(self, info)
  local id = info.id
  local label = info.label
  local pos = info.pos
  local handler = info.handler
  local size = info.size
  local inWidth = info.inWidth or 120
  local color = info.color or normal_button_color
  local icon = info.icon or 0
  if not self.button then
    self.button = {}
    self.buttonPress = {}
    self.buttonLabel = {}
    self.buttonHandler = {}
  end
  local button = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-detail-n.png", CCRectMake(10, 10, 148, 29))
  local buttonPress = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-detail-pressed-n.png", CCRectMake(10, 10, 148, 29))
  buttonPress:setVisible(false)
  local buttonLabel = ed.createttf(label or "", 20)
  ed.setLabelColor(buttonLabel, color)
  local labelSize = buttonLabel:getContentSize()
  button:setContentSize(size)
  buttonPress:setContentSize(size)
  if inWidth < labelSize.width then
    buttonLabel:setScale(inWidth / labelSize.width)
  end
  buttonPress:setPosition(ccp(size.width / 2, size.height / 2))
  if icon ~= 0 then
    buttonLabel:setAnchorPoint(ccp(0, 0.5))
    buttonLabel:setPosition(ccp(60, size.height / 2))
    local iconres = ed.createSprite("UI/DOTA-ITEM/" .. icon)
    iconres:setScale(0.6)
    button:addChild(iconres)
    iconres:setPosition(35, size.height / 2)
  else
    buttonLabel:setPosition(ccp(size.width / 2, size.height / 2))
  end
  button:addChild(buttonPress)
  button:addChild(buttonLabel)
  button:setPosition(pos)
  self.draglist.listLayer:addChild(button)
  self.button[id or label] = button
  self.buttonPress[id or label] = buttonPress
  self.buttonLabel[id or label] = buttonLabel
  self.buttonHandler[id or label] = handler
end

class.createButton = createButton

local function createListLayer(self)
  local info = {
    cliprect = CCRectMake(2, 20, 800, 440),
    noshade = true,
    container = self.mainLayer,
    zorder = 10
  }
  self.draglist = ed.draglist.create(info)
  self.draglist:initListWidth(600 + 200 * max_column)
  self.draglist:getList():setPosition(ccp(-100, 0))
end

class.createListLayer = createListLayer

local function new()
  local self = base.create("gm")
  setmetatable(self, class.mt)
  return self
end

class.new = new

local function create()
  local self = class.new()
  local mainLayer = self.mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  self:createListLayer()
  self.ui = {}
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "title",
        text = "With great power, comes great responsibility.",
        size = 26
      },
      layout = {
        position = ccp(410, 440)
      },
      config = {
        color = ccc3(255, 0, 0),
        stroke = {
          color = ccc3(255, 255, 255),
          size = 3
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/1080P/common/backbtn.png"
      },
      layout = {
        position = ccp(70, 435)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/1080P/common/backbtn-disabled.png"
      },
      layout = {
        position = ccp(70, 435)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(self.mainLayer, self.ui)
  readNode:addNode(ui_info)
  for i = 1, #button_config do
    self:createButton(button_config[i])
  end
  self:createNumber()
  return self
end

class.create = create

local function ccScene(self)
  return self.scene
end

class.ccScene = ccScene
