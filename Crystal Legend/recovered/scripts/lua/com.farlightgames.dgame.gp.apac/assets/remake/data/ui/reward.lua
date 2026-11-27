local class = newclass("g")
ed.reward = class
setfenv(1, class)
trans_keys = {
  diamond = "Diamond",
  gold = "Gold",
  item = "Item",
  hero = "Hero",
  vitality = "Vitality",
  playerexp = "PlayerEXP",
  crusadepoint = "CrusadePoint",
  arenapoint = "CrusadePoint",
  guildpoint = "GuildCoin",
  honourpoint = "TopPvpCoin",
  wood = "Wood",
  iron = "Iron",
  crystal = "Crystal",
  gcwpoint = ""
}

function isEnough(data)
  local rt = data._type
  local id = data._id
  local amount = data._amount
  local current_amounts = {
    diamond = ed.player._rmb,
    gold = ed.player._money,
    item = ed.player.equip_qunty[id],
    hero = ed.player.heroes[id] and 1 or 0,
    vitality = ed.player._vitality,
    playerexp = ed.player._exp,
    crusadepoint = ed.player:getPoint("crusadepoint"),
    arenapoint = ed.player:getPoint("arenapoint"),
    guildpoint = ed.player:getPoint("guildpoint"),
    honourpoint = ed.player:getPoint("honourpoint"),
    wood = ed.player:getPoint("wood"),
    iron = ed.player:getPoint("iron"),
    crystal = ed.player:getPoint("crystal"),
    gcwpoint = ed.player:getPoint("gcwpoint"),
    dreampoint = ed.player:getPoint("dreampoint")
  }
  return amount <= current_amounts[rt]
end

function adjust(data, isReward, rainbow)
  local isDouble = rainbow == 1 and true or false
  for _, item in ipairs(data) do
    local rt = item._type
    local id = item._id
    local amount = item._amount * (isReward and 1 or -1)
    if rt == "item" then
      if isDouble then
        amount = amount * 2
      end
      ed.player:addEquip(id, amount)
    elseif rt == "hero" then
      ed.player:addHero(id)
    elseif rt == "vitality" then
      ed.player:addVitality(amount)
    elseif rt == "playerexp" then
      ed.player:addExp(amount)
    else
      if isDouble then
        amount = amount * 2
      end
      ed.player:addPoint(rt, amount)
    end
  end
end

function get(rewards, rainbow)
  adjust(rewards, true, rainbow)
end

function recycle(recycles)
  adjust(recycles, false)
end

function show(rewards, rainbow)
  local items = {}
  for _, item in ipairs(rewards) do
    local rt = item._type
    local id = item._id
    local amount = item._amount
    if rt == "item" then
      table.insert(items, {
        type = "Item",
        id = id,
        amount = amount
      })
    elseif rt == "hero" then
      table.insert(items, {
        type = "Hero",
        id = id,
        amount = amount
      })
    elseif rt == "vitality" then
      table.insert(items, {type = "Vitality", amount = amount})
    elseif rt == "playerexp" then
      table.insert(items, {type = "Vitality", amount = amount})
    else
      table.insert(items, {
        type = trans_keys[rt],
        amount = amount
      })
    end
  end
  local config = {
    type = "getProp",
    param = {
      title = T("\232\142\183\229\190\151\230\138\165\233\133\172"),
      items = items,
      rainbow = rainbow
    }
  }
  ed.announce(config)
end

function getRewardType(name)
  return trans_keys[name]
end
