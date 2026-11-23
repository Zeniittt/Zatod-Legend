local class = newclass()
ed.readequip = class
local frame_res = {
  "white",
  "green",
  "blue",
  "purple",
  "purple",
  "orange",
  "red",
  "pink",
  "prismatic"
}

local function isEquipOpen(id)
  local banList = (ed.player.global_config._module_switch or {})._ban_item or {}
  if ed.isElementInTable(id, banList) then
    return false
  end
  return true
end

class.isEquipOpen = isEquipOpen

local function getAttRes()
  local res = ed.ui.baseres
  return res.att_name, res.att_pre, res.att_suffix, res.att_cn_name
end

class.getAttRes = getAttRes

local function info()
  return ed.getDataTable("equip")
end

class.info = info

local function row(id)
  local info = info() or {}
  return info[id] or {}
end

class.row = row

local function value(id, name)
  local row = row(id) or {}
  return row[name]
end

class.value = value

local function quality(id)
  return row(id).Quality
end

class.quality = quality

local function getAttList(id)
  local att = {}
  local name, pre, suffix = getAttRes()
  for i = 1, #name do
    local attNumber = row(id)[name[i]] or 0
    if attNumber ~= 0 then
      local nm = name[i]
      att[nm] = attNumber
    end
  end
  return att
end

class.getAttList = getAttList

local function getAddAttList(id, level)
  local att = {}
  local name, pre, suffix = getAttRes()
  for i = 1, #name do
    local attNumber = (row(id)["+" .. name[i]] or 0) * level
    if 0 < attNumber then
      local nm = name[i]
      att[nm] = attNumber
    end
  end
  return att
end

class.getAddAttList = getAddAttList

local function getTitanAddAttList(id, level)
  local att = {}
  local name, pre, suffix = getAttRes()
  for i = 1, #name do
    local attNumber = ed.lookupDataTable("TitanEquipLevel", "+" .. name[i], id, level) or 0
    if 0 < attNumber then
      local nm = name[i]
      att[nm] = attNumber
    end
  end
  return att
end

class.getTitanAddAttList = getTitanAddAttList

local function getDescription(id, level, titanEquipLevel)
  local function formatList(list)
    local str = list.STR or 0
    
    local int = list.INT or 0
    local agi = list.AGI or 0
    if str == int and str == agi then
      list.ALL_ATT = str
      list.STR = 0
      list.INT = 0
      list.AGI = 0
    end
  end
  
  level = level or 0
  local res = ed.ui.baseres
  local name, pre, suffix, cn = getAttRes()
  local attList = {}
  local addList = {}
  local sufList = {}
  local att = getAttList(id)
  local add = getAddAttList(id, level)
  if titanEquipLevel then
    local titanEquipLevelAdd = getTitanAddAttList(id, titanEquipLevel)
    for i = 1, #name do
      local nm = name[i]
      att[nm] = (att[nm] or 0) + (titanEquipLevelAdd[nm] or 0)
    end
  end
  formatList(att)
  formatList(add)
  if 0 < (att.ALL_ATT or 0) then
    local element = ""
    element = cn.ALL_ATT .. "+"
    element = element .. att.ALL_ATT
    table.insert(attList, element)
    if 0 < (add.ALL_ATT or 0) then
      element = "+" .. add.ALL_ATT
      addList[#attList] = element
    else
      addList[#attList] = nil
    end
  end
  for k, v in pairs(name) do
    if 416 == id and "INT" == v then
      att[v] = 1
    end
    if (att[v] or 0) ~= 0 then
      local element = ""
      if cn[v] ~= "" then
        if 416 == id and "INT" == v then
          element = element .. cn[v]
        elseif "TEN" == v then
          element = element .. cn[v]
          element = element .. (0 < att[v] and att[v] or "")
        else
          element = element .. cn[v]
          element = element .. (0 < att[v] and "+" or "")
          element = element .. att[v]
        end
      elseif 0 < att[v] or 0 < add[v] then
        element = element .. att[v]
      end
      if 416 == id and "INT" == v and (add[v] or 0) == 0 then
        table.insert(attList, "")
      else
        table.insert(attList, element)
      end
      if (add[v] or 0) ~= 0 then
        element = "+" .. add[v]
        addList[#attList] = element
        sufList[#attList] = suffix[v]
      else
        addList[#attList] = nil
        attList[#attList] = attList[#attList] .. (suffix[v] or "")
      end
    end
  end
  return attList, addList, sufList
end

class.getDescription = getDescription

local function getDescriptionNew(id, level)
  level = level or 0
  local res = ed.ui.baseres
  local name, pre, suffix, cn = getAttRes()
  local attList = {}
  local addList = {}
  local sufList = {}
  local att = getAttList(id)
  local add = getAddAttList(id, level)
  local attrs = {}
  for k, v in pairs(name) do
    if (att[v] or 0) ~= 0 then
      local item = {}
      local element = ""
      if cn[v] ~= "" then
        element = element .. cn[v]
        element = element .. (0 < att[v] and "+" or "")
        element = element .. att[v]
        local num = 0 < att[v] and "+" or ""
        num = num .. att[v]
        if add[v] and 0 < add[v] then
          num = num .. "+" .. add[v]
        end
        if suffix[v] then
          num = num .. suffix[v]
        end
        item = {
          cn[v],
          num
        }
      end
      table.insert(attrs, item)
    end
  end
  return attrs
end

class.getDescriptionNew = getDescriptionNew

local function getAttDesc(id)
  local res = ed.ui.baseres
  local name, pre, suffix, cn = getAttRes()
  local number = {}
  local attList = {}
  number = getAttList(id)
  for k, v in pairs(name) do
    if (number[v] or 0) ~= 0 then
      local element = ""
      element = element .. cn[v]
      if cn[v] ~= "" then
        element = element .. (0 < number[v] and "+" or "")
      end
      element = element .. number[v]
      element = element .. (suffix[v] or "")
      table.insert(attList, element)
    end
  end
  return attList
end

class.getAttDesc = getAttDesc

local function getRuneAttDesc(id)
  local attDes = {}
  if not id then
    return attDes
  end
  local levelDes = string.format(T("%d\231\186\167\231\172\166\231\159\179"), ed.rune.getNewRuneLevel(id))
  local attrDesc = ed.rune.getNewRuneAttrDesc(id)
  attrDesc = T("\231\172\166\231\159\179\229\177\158\230\128\167:") .. attrDesc
  table.insert(attDes, levelDes)
  table.insert(attDes, attrDesc)
  local words_ID = ed.rune.getRuneWordsID(id)
  if words_ID and 0 < words_ID then
    local runeWordsTbl = ed.getDataTable("RuneWords")
    if runeWordsTbl and runeWordsTbl[words_ID] then
      local row = runeWordsTbl[words_ID]
      local needAmount = row["Rune Amount"]
      local words_name = row["Chinese Name"]
      local words_name = string.format("%s\229\165\151\232\163\133(%d\228\187\182)", words_name, needAmount)
      table.insert(attDes, words_name)
      local attrStr = string.gsub(row["Chinese Attr Name"], "#", row["Attr Value"])
      attrStr = "\229\165\151\232\163\133\229\177\158\230\128\167:" .. attrStr
      table.insert(attDes, attrStr)
    end
  end
  return attDes
end

class.getRuneAttDesc = getRuneAttDesc

local function isUniversalFragment(id)
  if value(id, "Name") == T("\228\184\135\232\131\189\231\162\142\231\137\135") then
    return true
  end
  return false
end

class.isUniversalFragment = isUniversalFragment

local function getFragmentAmount(id)
  local ufcan, uftotal = 0, 0
  local need, ufneed = 0, 0
  local isFragment = false
  local it = ed.itemType(id)
  if it == "equip" and ed.readequip.value(id, "Category") == T("\231\162\142\231\137\135") then
    isFragment = true
    for k, v in pairs(ed.getDataTable("fragment")) do
      if v["Fragment ID"] == id then
        local ufid = v["Universal Fragment ID"]
        uftotal = ed.player.equip_qunty[ufid] or 0
        need = v["Fragment Count"]
        ufneed = v["Universal Fragment Count"]
        if uftotal > ufneed then
          ufcan = ufneed
        else
          ufcan = uftotal
        end
      end
    end
  end
  return {
    isFragment = isFragment,
    need = need,
    ufcan = ufcan,
    uftotal = uftotal,
    ufneed = ufneed
  }
end

class.getFragmentAmount = getFragmentAmount

local function getHeroItems(hid, hero)
  local hero = hero and hero or ed.player.heroes[hid]
  if not hero then
    return {}
  else
    return hero._items
  end
end

class.getHeroItems = getHeroItems

local function getHeroItem(hid, slot, hero)
  local items = getHeroItems(hid, hero)
  local item = items[slot]
  if not item then
    return nil
  else
    return item._item_id, item._exp
  end
end

class.getHeroItem = getHeroItem

local function canHeroItemsEnhance(hid)
  local items = getHeroItems(hid)
  if not items then
    return false
  end
  local mq = 0
  local ml = true
  for i = 1, 6 do
    local id = getHeroItem(hid, i)
    if 0 < (id or 0) then
      mq = math.max(mq, ed.readequip.quality(id))
    end
    ml = ml and class.checkMaxLevel(hid, i)
  end
  return 1 < mq and not ml
end

class.canHeroItemsEnhance = canHeroItemsEnhance

local function getEquipExp(hid, slot, hero)
  local hero = hero and hero or ed.player.heroes[hid]
  local exp = hero._items[slot]._exp
  return exp
end

class.getEquipExp = getEquipExp

local function getMaxLevel(id)
  local row = row(id)
  local quality = row.Quality
  local ehc = ed.getDataTable("enhancement")
  local erow = ehc[quality]
  local ml = erow["Max Level"]
  return ml
end

class.getMaxLevel = getMaxLevel

local function getEquipLevelExp(hid, slot, hero)
  local hero = hero and hero or ed.player.heroes[hid]
  if nil == hero then
    return
  end
  local id = hero._items[slot]._item_id
  if id == 0 then
    return
  end
  local row = row(id)
  local quality = row.Quality
  local ehc = ed.getDataTable("enhancement")
  local erow = ehc[quality]
  local ml = erow["Max Level"]
  local le = {}
  for i = 1, ml do
    table.insert(le, erow["Price " .. i])
  end
  return le, ml
end

class.getEquipLevelExp = getEquipLevelExp

local function getEquipLevel(hid, slot, exp, hero)
  local eid = getHeroItem(hid, slot, hero)
  if (eid or 0) <= 0 or ed.Hero.isTitanById(hid) then
    return 0, 0, 0, 0
  end
  exp = exp or getEquipExp(hid, slot, hero)
  local le, ml = getEquipLevelExp(hid, slot, hero)
  local te = 0
  for i = 1, #le do
    local pte = te + le[i]
    if exp < pte then
      return i - 1, exp - te, ml, le[i]
    end
    te = pte
  end
  return ml, le[ml], ml, le[ml]
end

class.getEquipLevel = getEquipLevel

local function checkIfWearAwakeEquip(hid)
  local eid = getHeroItem(hid, 1)
  if (eid or 0) <= 0 then
    return false
  end
  return false
end

class.checkIfWearAwakeEquip = checkIfWearAwakeEquip

local function checkEquipEnchant(hid, beginIndex)
  if beginIndex == nil then
    beginIndex = 1
  end
  local maxSlot = 6
  for i = beginIndex, maxSlot do
    local level, exp = getEquipLevel(hid, i)
    if level and exp and 0 < level + exp then
      return true
    end
  end
  return false
end

class.checkEquipEnchant = checkEquipEnchant

local function checkMaxLevel(hid, slot, exp)
  local l, e, ml, me = getEquipLevel(hid, slot, exp)
  if l == ml and e == me then
    return true
  end
  return false
end

class.checkMaxLevel = checkMaxLevel

local function getComposedID(id)
  for k, v in pairs(ed.getDataTable("fragment")) do
    if v["Fragment ID"] == id then
      return k
    end
  end
  return nil
end

class.getComposedID = getComposedID

local function getComponents(id)
  local row = ed.getDataTable("equipcraft")[id]
  if row then
    return row.Components
  else
    return 0
  end
end

class.getComponents = getComponents

local function orderEquips(list, key)
  if type(key) == "string" then
    for i = 1, #list do
      for j = i, 2, -1 do
        if (list[j][key] or 0) < (list[j - 1][key] or 0) then
          local temp = list[j - 1]
          list[j - 1] = list[j]
          list[j] = temp
        end
      end
    end
  elseif type(key) == "table" then
    if key[1] then
      orderEquips(list, key[1])
    end
    for m = 2, #key do
      for i = 1, #list do
        for j = i, 2, -1 do
          if (list[j][key[m]] or 0) < (list[j - 1][key[m]] or 0) and list[j][key[m - 1]] == list[j - 1][key[m - 1]] then
            local temp = list[j - 1]
            list[j - 1] = list[j]
            list[j] = temp
          end
        end
      end
    end
  end
end

class.orderEquips = orderEquips

local function getMaterialList()
  local list = {}
  local fragCsv = ed.getDataTable("fragment")
  local equipCsv = ed.getDataTable("equip")
  for v, k in pairs(ed.player.equip_qunty) do
    local id = v
    local amount = ed.player.equip_qunty[v]
    local category = value(v, "Category")
    local rlevel = value(v, "Level Requirement")
    local ehc = value(v, "Enhance Value") or 0
    local ct = value(v, "Consume Type")
    local name = value(v, "Name")
    local invisible = value(v, "Invisible")
    local checkBook = value(v, "Is Book Fragment")
    
    local function checkValid()
      if amount == 0 then
        return false
      end
      if category == T("\231\129\181\233\173\130\231\159\179") then
        return false
      end
      if category == T("\230\182\136\232\128\151\229\147\129") and ct ~= "\233\153\132\233\173\148\230\157\144\230\150\153" then
        return false
      end
      if category == T("\231\162\142\231\137\135") and name == T("\228\184\135\232\131\189\231\162\142\231\137\135") then
        return false
      end
      if category == T("\231\162\142\231\137\135") and checkBook == true then
        for item_id, item_frag_info in pairs(fragCsv) do
          if item_frag_info["Fragment ID"] == id and equipCsv[item_id].Category == T("\228\185\166\230\156\172") and (not ed.player.equip_qunty[item_id] or ed.player.equip_qunty[item_id] == 0) then
            return false
          end
        end
      end
      if invisible then
        return false
      end
      if ehc == 0 then
        return false
      end
      if not ed.readequip.isEquipOpen(id) then
        return false
      end
      return true
    end
    
    if checkValid() then
      table.insert(list, {
        id = id,
        amount = amount,
        ehc = ehc,
        category = category,
        ct = ct,
        name = name,
        bookFragment = checkBook
      })
    end
  end
  table.sort(list, function(a, b)
    local ap = a and a.ct == T("\233\153\132\233\173\148\230\157\144\230\150\153") and 1 or 0
    local bp = b and b.ct == T("\233\153\132\233\173\148\230\157\144\230\150\153") and 1 or 0
    local abook = a.bookFragment and 1 or 0
    local bbook = b.bookFragment and 1 or 0
    if ap > bp then
      return true
    elseif ap == bp and abook > bbook then
      return true
    elseif ap == bp and abook == bbook and a.ehc < b.ehc then
      return true
    else
      return false
    end
  end)
  return list
end

class.getMaterialList = getMaterialList

local function orderFragmentList(list)
  for k, v in pairs(list) do
    for i = 1, #(v or {}) do
      for j = i, 2, -1 do
        local e, pe = v[j], v[j - 1]
        local id, pid = e.id, pe.id
        if e.needAmount and pe.needAmount then
          local en, pen = ed.player:getEquipAmount(id) >= e.needAmount, ed.player:getEquipAmount(pid) >= pe.needAmount
          if en and not pen then
            local t = v[j]
            v[j] = v[j - 1]
            v[j - 1] = t
          end
        end
      end
    end
  end
end

class.orderFragmentList = orderFragmentList

local function classify(list)
  local list, flist = {}, {}
  for k, v in ipairs(ed.player.equip_order) do
    list[k] = {}
    list[k].id = v
    list[k].makeId = v
    list[k].itemName = value(v, "Name")
    list[k].order = tonumber(value(v, "Order"))
    list[k].amount = ed.player.equip_qunty[v]
    list[k].category = value(v, "Category")
    if list[k].category == T("\231\162\142\231\137\135") then
      list[k].type = 2
      flist = flist or {}
      flist[v] = k
    else
      list[k].type = 1
    end
  end
  local cinfo = ed.getDataTable("fragment")
  for k, v in pairs(cinfo) do
    local fid = v["Fragment ID"]
    local kid = flist[fid]
    if kid then
      list[kid].needAmount = v["Fragment Count"]
      list[kid].makeId = k
      if ed.itemType(k) == "equip" then
        list[kid].category = value(k, "Category")
      elseif ed.itemType(k) == "hero" then
        list[kid].category = T("\232\139\177\233\155\132")
      end
    end
  end
  local prop = {
    all = {},
    equip = {},
    scroll = {},
    stone = {},
    consume = {},
    book = {},
    rune = {},
    eggs = {},
    tarot = {}
  }
  local fragment = {
    all = {},
    equip = {},
    scroll = {},
    hero = {},
    consume = {},
    rune = {},
    book = {}
  }
  local both = {prop, fragment}
  for k, v in ipairs(list) do
    if isEquipOpen(v.id) and not value(v.id, "Invisible") and v.amount > 0 then
      if v.category == T("\229\141\183\232\189\180") then
        table.insert(both[v.type].scroll, v)
      elseif v.category == T("\230\182\136\232\128\151\229\147\129") then
        table.insert(both[v.type].consume, v)
      elseif v.category == T("\232\139\177\233\155\132") then
        table.insert(both[v.type].hero, v)
      elseif v.category == T("\231\129\181\233\173\130\231\159\179") then
        table.insert(both[v.type].stone, v)
      elseif v.category == T("\228\185\166\230\156\172") then
        table.insert(both[v.type].book, v)
      elseif v.category == T("\231\172\166\230\150\135\231\159\179") then
        table.insert(both[v.type].rune, v)
      elseif v.category == T("\228\191\161\228\189\191\232\155\139") then
        table.insert(both[v.type].eggs, v)
      elseif v.category == T("\229\141\161\229\140\133") then
        table.insert(both[v.type].tarot, v)
      else
        table.insert(both[v.type].equip, v)
      end
      table.insert(both[v.type].all, v)
    end
  end
  orderFragmentList(fragment)
  return prop, fragment
end

class.classify = classify

local function classifyEquip()
  local equip = {
    ALL = {},
    STR = {},
    AGI = {},
    INT = {},
    HP = {},
    AD = {},
    AP = {},
    ARM = {},
    CRIT = {},
    HPS = {},
    MPS = {},
    HEAL = {}
  }
  for k, v in pairs(info()) do
    if type(k) == "number" and isEquipOpen(k) then
      local category = v.Category
      local isHide = v.Hide
      if not isHide and (category == T("\233\155\182\228\187\182") or category == T("\229\144\136\230\136\144\229\147\129")) then
        for tk, tv in pairs(equip) do
          if tk == "CRIT" then
            if 0 < (v[tk] or 0) or 0 < (v.MCRIT or 0) then
              table.insert(equip[tk], {
                id = k,
                name = v.Name,
                lr = v["Display Level"]
              })
            end
          elseif 0 < (v[tk] or 0) then
            table.insert(equip[tk], {
              id = k,
              name = v.Name,
              lr = v["Display Level"]
            })
          end
        end
        table.insert(equip.ALL, {
          id = k,
          name = v.Name,
          lr = v["Display Level"]
        })
      end
    end
  end
  for k, v in pairs(equip) do
    orderEquips(equip[k], {"lr", "id"})
  end
  return equip
end

class.classifyEquip = classifyEquip

local function createFragment(id, length, quality, addition)
  addition = addition or {}
  local fres = addition.fres
  quality = quality or value(id, "Quality") or 1
  local bg = ed.createSprite("UI/alpha/1080P/common/frame/fragment_frame_" .. frame_res[quality] .. ".png")
  bg:setCascadeOpacityEnabled(true)
  local equipBg = ed.createSprite("UI/alpha/1080P/common/frame/fragment_bg.png")
  equipBg:setAnchorPoint(ccp(0, 0))
  equipBg:setPosition(ccp(0, 0))
  bg:addChild(equipBg, -2)
  local res = fres or value(id, "Icon") or ""
  local result = string.find(res, ".png") or string.find(res, ".jpg")
  local fragment, fragmentIcon
  if result then
    fragment, fragmentIcon = ed.createClippingNode(res, "UI/alpha/1080P/common/frame/fragment_stencil.png", nil, CCSizeMake(10, 8))
  else
    print("< " .. "Fragment ID : " .. id .. " > < Illegal Icon : " .. res .. " >")
    fragment, fragmentIcon = CCSprite:create(), CCSprite:create()
  end
  fragment:setPosition(ed.getCenterPos(bg))
  bg:addChild(fragment, -1)
  local tag = ed.createSprite("UI/alpha/1080P/icon/fragment_tag.png")
  tag:setScale(1.6)
  tag:setPosition(ccp(20, 70))
  bg:addChild(tag)
  local s2 = (bg:getContentSize().width - 16) / fragmentIcon:getContentSize().width
  fragment:setScale(s2)
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  return bg, fragment, fragmentIcon, tag
end

class.createFragment = createFragment

local function createHeroStone(id, length, quality, addition)
  addition = addition or {}
  local fres = addition.fres
  quality = quality or value(id, "Quality") or 1
  local bg = ed.createSprite("UI/alpha/1080P/common/frame/fragment_frame_" .. frame_res[quality] .. ".png")
  bg:setCascadeOpacityEnabled(true)
  local equipBg = ed.createSprite("UI/alpha/1080P/common/frame/fragment_bg.png")
  equipBg:setAnchorPoint(ccp(0, 0))
  equipBg:setPosition(ccp(0, 0))
  bg:addChild(equipBg, -2)
  local res = fres or value(id, "Icon")
  local result = string.find(res, ".png") or string.find(res, ".jpg")
  local stone, stoneIcon
  if result then
    stone, stoneIcon = ed.createClippingNode(res, "UI/alpha/1080P/common/frame/fragment_stencil.png")
  else
    print("< " .. "Fragment ID : " .. id .. " > < Illegal Icon : " .. res .. " >")
    stone, stoneIcon = CCSprite:create(), CCSprite:create()
  end
  local size = bg:getContentSize()
  stone:setPosition(ccp(size.width / 2, size.height / 2))
  stone:setScale(1.4)
  bg:addChild(stone, -1)
  local tagres = "UI/alpha/1080P/icon/herodetail_soulstone_icon.png"
  local tag = ed.createSprite(tagres)
  tag:setPosition(ccp(18, 70))
  bg:addChild(tag)
  local s2 = (bg:getContentSize().width - 9) / stoneIcon:getContentSize().width
  stone:setScale(s2)
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  return bg, stone, stoneIcon, tag
end

class.createHeroStone = createHeroStone

function class.createTarotPackage(id, length, quality, addition)
  addition = addition or {}
  local fres = addition.fres
  local fres2 = addition.fres2
  quality = quality or value(id, "Quality") or 1
  local bg = ed.createSprite("UI/alpha/1080P/common/frame/fragment_frame_" .. frame_res[quality] .. ".png")
  bg:setCascadeOpacityEnabled(true)
  local equipBg = ed.createSprite("UI/alpha/1080P/common/frame/fragment_bg.png")
  equipBg:setAnchorPoint(ccp(0, 0))
  equipBg:setPosition(ccp(0, 0))
  bg:addChild(equipBg, -2)
  local res = fres or value(id, "Icon")
  local res2 = fres2 or value(id, "Icon2")
  local result = string.find(res, ".png") or string.find(res, ".jpg")
  local package, packageIcon
  if result then
    package, packageIcon = ed.createClippingNode(res, "UI/alpha/1080P/common/frame/fragment_stencil.png")
  else
    print("< " .. "Fragment ID : " .. id .. " > < Illegal Icon : " .. res .. " >")
    package, packageIcon = CCSprite:create(), CCSprite:create()
  end
  if res2 then
    local res2Spr = CCSprite:create(res2)
    if res2Spr then
      local packageIconSize = packageIcon:getContentSize()
      res2Spr:setPosition(ccp(packageIconSize.width / 2, packageIconSize.height / 2))
      packageIcon:addChild(res2Spr)
    end
  end
  package:setPosition(36, 38.5)
  bg:addChild(package, -1)
  local tagres = "UI/alpha/HVGA/tarot_card/equip_tarot_package_tag.png"
  local scale = 1
  local tag = ed.createSprite(tagres)
  tag:setScale(scale)
  tag:setPosition(ccp(12, 62))
  bg:addChild(tag)
  local s2 = (bg:getContentSize().width - 9) / packageIcon:getContentSize().width
  package:setScale(s2)
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  return bg, package, packageIcon, tag
end

local function getUnknownIcon(quality, length)
  local node, icon = ed.readequip.createIcon(nil, length, quality or 1, {
    fres = "UI/alpha/1080P/common/handbook_icon_lock.png",
    offset = ccp(0, 2)
  })
  icon:setScale(1.005)
  local light = ed.readequip.getActionLight(node)
  return node, icon, light
end

class.getUnknownIcon = getUnknownIcon

local function getActionLight(node)
  local light = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/hero_equip_button_light.png"
    },
    layout = {
      position = ed.getCenterPos(node)
    }
  }, node)
  local f1 = CCFadeOut:create(1)
  local f2 = CCFadeIn:create(1)
  light:runAction(ed.readaction.create({
    t = "seq",
    isRepeat = true,
    f1,
    f2
  }))
  light:setVisible(false)
  return light
end

class.getActionLight = getActionLight

local function getUnknownIconYellow(quality, length)
  local node, icon = ed.readequip.createIcon(nil, length, quality or 1, {
    fres = "UI/alpha/HVGA/herodetail_icon_question_yellow.png",
    offset = ccp(0, 2)
  })
  icon:setScale(1.5)
  local light = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/hero_equip_button_light.png"
    },
    layout = {
      position = ed.getCenterPos(node)
    }
  }, node)
  local f1 = CCFadeOut:create(1)
  local f2 = CCFadeIn:create(1)
  light:runAction(ed.readaction.create({
    t = "seq",
    isRepeat = true,
    f1,
    f2
  }))
  light:setVisible(false)
  return node, icon, light
end

class.getUnknownIconYellow = getUnknownIconYellow

local function getUnknownHeroStone()
  local node, icon = ed.readequip.createHeroStone(nil, nil, 1, {
    fres = "UI/alpha/1080P/common/handbook_icon_lock.png"
  })
  icon:setScale(1.005)
  return node, icon
end

class.getUnknownHeroStone = getUnknownHeroStone

local function createSmallFragment(id, quality)
  local bg, fragment = createFragment(id, 38, quality)
  return bg, fragment
end

class.createSmallFragment = createSmallFragment

local function setNodesGray(...)
  for i = 1, select("#", ...) do
    local node = select(i, ...)
    if node then
      ed.setSpriteGray(node)
    end
  end
end

local function setEquipScale(equip, trwidth, bgwidth)
  if not tolua.isnull(equip) then
    local orwidth = bgwidth - 9
    local s2 = orwidth / trwidth
    equip:setScale(s2)
  end
end

class.setEquipScale = setEquipScale

local function setBgScale(bg, length, addition)
  if addition.bgscale then
    bg:setScale(addition.bgscale)
  elseif length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
end

local function canSetBgScale(id)
  local category = value(id, "Category")
  return category ~= T("\231\162\142\231\137\135") and category ~= T("\231\129\181\233\173\130\231\159\179")
end

local function getFrameRes(quality)
  quality = quality or 1
  return "UI/alpha/1080P/common/frame/equip_frame_" .. frame_res[quality] .. ".png"
end

ed.getFrameRes = getFrameRes

local function createIconWithFres(quality, addition)
  local bg, equip
  local addition = addition or {}
  local fres = addition.fres
  local bgres = addition.bgres
  equip = ed.createSprite(fres)
  bg = ed.createSprite(bgres or getFrameRes(quality))
  equip:setPosition(ccpAdd(ed.getCenterPos(bg), addition.offset or ccp(0, 0)))
  bg:addChild(equip, -1)
  if addition.scale then
    equip:setScale(addition.scale)
  end
  if not addition.bgscale then
    local equipBg = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
    equipBg:setAnchorPoint(ccp(0, 0))
    equipBg:setPosition(ccp(0, 0))
    bg:addChild(equipBg, -2)
  end
  return bg, equip
end

class.createIconWithFres = createIconWithFres

local function createIconWithString(id)
  local bg, equip
  local icon_res = {
    Gold = "UI/alpha/1080P/icon/gold_icon.png",
    Diamond = "UI/alpha/1080P/icon/diamond_icon.png",
    Vitality = "UI/alpha/HVGA/task_vit_icon.png",
    ManayDiamonds = "UI/alpha/HVGA/recharge_diamond_icon_3.png",
    MagicBox = "UI/alpha/HVGA/activity/magicboxicon.png",
    StarPoint = "UI/alpha/HVGA/stargate/money_stargate.png",
    riseStarPoint = "UI/alpha/1080P/risestar/itemicon1.jpg"
  }
  equip = ed.createSprite(icon_res[id])
  local Quality = 1
  if id == "riseStarPoint" then
    Quality = 5
  end
  bg = ed.createSprite(getFrameRes(Quality))
  equip:setPosition(ccpAdd(ed.getCenterPos(bg), ccp(0, 1)))
  bg:addChild(equip, -1)
  local bwidth = bg:getContentSize().width
  local twidth = equip:getContentSize().width
  class.setEquipScale(equip, twidth, bwidth)
  return bg, equip
end

class.createIconWithString = createIconWithString

local function getHeroIconRes(id, fashion_id)
  local res = ed.getPortraitSwitchRowName({_tid = id})
  if res == "Portrait Switch" then
    res = ed.getUnitPortraitSwitch(id)
  elseif res == "Portrait" then
    res = ed.getUnitPortrait(id)
  end
  return res
end

class.getHeroIconRes = getHeroIconRes

local function createIconDefaultBgWithPath(path)
  local bg = ed.createSprite(path)
  bg:setCascadeOpacityEnabled(true)
  local equipBg = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
  equipBg:setAnchorPoint(ccp(0, 0))
  equipBg:setPosition(ccp(0, 0))
  bg:addChild(equipBg, -2)
  return bg
end

class.createIconDefaultBgWithPath = createIconDefaultBgWithPath

local function createIconDefaultBg(quality)
  local path = getFrameRes(quality)
  return createIconDefaultBgWithPath(path)
end

class.createIconDefaultBg = createIconDefaultBg

local function createIconWithId(id, length, quality, addition)
  local bg, equip, enode, icon, tag
  local fashion_id = addition.fashion_id
  local stone_in_package = addition.stone_in_package
  local type = ed.itemType(id)
  quality = quality or 1
  local res
  if type == "equip" then
    res = value(id, "Icon")
    quality = quality or value(id, "Quality")
    local category = value(id, "Category")
    if category == T("\231\162\142\231\137\135") then
      bg, equip, icon, tag = createFragment(id, length, quality)
    elseif category == T("\231\129\181\233\173\130\231\159\179") then
      if not stone_in_package then
        bg, equip, icon, tag = createHeroStone(id, length, quality)
      end
    elseif category == T("\231\172\166\230\150\135\231\159\179") then
      local res2 = value(id, "Icon2")
      bg = class.createIconDefaultBg(quality)
      equip = ed.createSprite(res)
      if res2 ~= "none" then
        local flag = ed.createSprite(res2)
        flag:setPosition(ccp(30, 32))
        equip:addChild(flag)
      end
      equip:setPosition(ed.getCenterPos(bg))
      bg:addChild(equip, -1)
    elseif category == T("\229\141\161\229\140\133") then
      bg, equip, icon, tag = class.createTarotPackage(id, length, quality)
    elseif value(id, "Is Tarot Chest") then
      bg, equip, icon = class.createTarotChest(id, length, quality)
    else
      bg = class.createIconDefaultBg(quality)
      equip = ed.createSprite(res)
      equip:setPosition(ed.getCenterPos(bg))
      bg:addChild(equip, -1)
      if category == T("\228\191\161\228\189\191\232\155\139") then
        local tagres = "UI/alpha/1080P/icon/petegg_tag.png"
        local tag = ed.createSprite(tagres)
        tag:setPosition(ccp(22, 70))
        bg:addChild(tag)
      elseif category == T("\230\150\151\232\155\144\232\155\144\232\167\163\233\148\129\232\139\177\233\155\132") then
        local tag = ed.createSprite("UI/alpha/1080P/chesscard/icon.png")
        tag:setPosition(24, 70)
        bg:addChild(tag)
      end
    end
  elseif type == "hero" then
    bg = class.createIconDefaultBg(quality)
    res = class.getHeroIconRes(id, fashion_id)
    equip, enode = ed.createClippingNode(res, "UI/alpha/1080P/common/equip_stencil.png", 0.02)
    equip:setPosition(ed.getCenterPos(bg))
    bg:addChild(equip, -1)
  end
  local config = {
    bg = bg,
    equip = equip,
    enode = enode,
    icon = icon,
    tag = tag
  }
  return config
end

class.createIconWithId = createIconWithId

local function createIcon(id, length, quality, addition)
  quality = quality or value(id, "Quality")
  local bg, equip, enode, icon, tag, itemType
  addition = addition or {}
  local fres = addition.fres
  local bgres = addition.bgres
  local bGray = addition.bGray
  local fashion_id = addition.fashion_id
  if fres then
    bg, equip = class.createIconWithFres(quality, addition)
  elseif type(id) == "string" then
    bg, equip = class.createIconWithString(id)
  elseif type(id) == "number" then
    itemType = ed.itemType(id)
    local config = class.createIconWithId(id, length, quality, addition)
    bg, equip, enode, icon, tag = config.bg, config.equip, config.enode, config.icon, config.tag
  end
  if canSetBgScale(id) then
    setBgScale(bg, length, addition)
  end
  if bGray then
    setNodesGray(bg, equip, icon, tag)
  end
  return bg, equip
end

class.createIcon = createIcon

function class.createLegendEquipIcon(legendEquip)
  local typeId = legendEquip._type_id
  local star = legendEquip._star
  local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
  local bg = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
  local size = bg:getContentSize()
  local centerPos = ccp(size.width / 2, size.height / 2)
  bg:setContentSize(size)
  local equip = ed.createSprite(legendEquipCfg.Icon)
  bg:addChild(equip)
  equip:setPosition(centerPos)
  local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_orange.png")
  bg:addChild(frame)
  frame:setPosition(centerPos)
  local node = CCSprite:create()
  node:setCascadeOpacityEnabled(true)
  node:setAnchorPoint(ccp(0, 0))
  bg:addChild(node)
  local stars = {}
  for i = star, 1, -1 do
    local path = "UI/alpha/1080P/hero/hero_star_1.png"
    local pict = ed.createSprite(path)
    pict:setScale(0.5)
    node:addChild(pict, 5)
    stars[i] = pict
  end
  local gs = CCSizeMake(13, 13)
  local ps = CCSizeMake(gs.width * star, 13)
  ed.layout.layoutChildrenWithSize(node, ps, ed.layoutType.Grid, {gridSize = gs})
  node:setPosition((size.width - ps.width) / 2, 9)
  bg.equip = equip
  bg.star = node
  return bg, equip
end

function class.createBasicLegendEquipIcon(typeId, amount)
  local legendEquipCfg = ed.getDataTable("LegendEquip")[typeId]
  local bg, equip = class.createLegendEquipIcon({
    _type_id = typeId,
    _star = legendEquipCfg["Basic Star"],
    _rank = legendEquipCfg["Basic Rank"]
  })
  local amountLabel
  if amount and 1 < amount then
    local bgsize = bg:getContentSize()
    amountLabel = ed.createttf(amount, 16)
    amountLabel:setAnchorPoint(ccp(1, 0))
    ed.setLabelColor(amountLabel, ccc3(255, 251, 231))
    ed.setLabelStroke(amountLabel, ccc3(39, 37, 36), 2)
    amountLabel:setPosition(bgsize.width - 10, 10)
    amountLabel:setScale(1 / bg:getScale())
    bg:addChild(amountLabel)
  end
  return bg, equip, amountLabel
end

function class.createCampIcon(unitId)
  if not ed.isTitanById(unitId) then
    return
  end
  local campId = ed.Hero.getCampIdByUnitId(unitId)
  if not campId then
    return
  end
  local iconRes = string.format("UI/alpha/HVGA/camp/camp_icon_for_head_%d.png", campId)
  local icon = ed.createSprite(iconRes)
  return icon
end

local function createUnitIcon(id, length, quality, awakenstatus)
  if (quality or 0) <= 1 then
    quality = 1
  end
  local bg = ed.createSprite(ed.Hero.getIconFrameByRank(quality))
  bg:setCascadeOpacityEnabled(true)
  local portrait_res = ed.getPortraitSwitchRowName({_tid = id})
  if portrait_res == "Portrait Switch" then
    portrait_res = ed.getUnitPortraitSwitch(id)
  elseif portrait_res == "Portrait" then
    portrait_res = ed.getUnitPortrait(id)
  end
  local unit = ed.createSprite(portrait_res)
  unit:setAnchorPoint(ccp(0, 0))
  unit:setPosition(ccp(8, 7))
  bg:addChild(unit, -1)
  local s2 = (bg:getContentSize().width - 18) / unit:getContentSize().width
  unit:setScale(s2)
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  if awakenstatus then
    local shardLogo = ed.createSprite("UI/alpha/1080P/shard/shard_logo.png")
    local size = bg:getContentSize()
    shardLogo:setPosition(size.width / 2, size.height - 11)
    bg:addChild(shardLogo, 2)
  end
  return bg
end

class.createUnitIcon = createUnitIcon

local function createIconWithFirstTag(id, length, amount, quality, addition)
  local bg, icon = class.createIconWithAmount(id, length, amount, quality, addition)
  local scale = bg:getScale()
  bg:setScale(1)
  local tag = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/activity/recharge_gift_tip_1.png"
    },
    layout = {
      position = ccpAdd(ed.getCenterPos(bg), ccp(-12, 12))
    },
    config = {}
  }, bg)
  bg:setScale(scale)
  return bg, icon, tag
end

class.createIconWithFirstTag = createIconWithFirstTag

local function createIconWithGiftTag(id, length, amount, quality, addition)
  local bg, icon = class.createIconWithAmount(id, length, amount, quality, addition)
  local scale = bg:getScale()
  bg:setScale(1)
  local tag = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/activity/recharge_gift_tip_2.png"
    },
    layout = {
      position = ccpAdd(ed.getCenterPos(bg), ccp(-10, 10))
    },
    config = {}
  }, bg)
  bg:setScale(scale)
  return bg, icon, tag
end

class.createIconWithGiftTag = createIconWithGiftTag

local function createIconWithAmount(id, length, amount, quality, addition)
  local bg, equip = createIcon(id, length, quality, addition)
  amount = amount or ed.player.equip_qunty[id] or 0
  local amountLabel
  if 1000000 <= amount then
    local bgsize = bg:getContentSize()
    amountLabel = ed.createttf(amount, 16)
    amountLabel:setAnchorPoint(ccp(1, 0))
    ed.setLabelColor(amountLabel, ccc3(255, 251, 231))
    ed.setLabelStroke(amountLabel, ccc3(39, 37, 36), 2)
    amountLabel:setPosition(bgsize.width - 10, 10)
    local bg_wid = bg:getContentSize().width
    amountLabel:setScale(bg_wid * 0.8 / amountLabel:getContentSize().width)
    bg:addChild(amountLabel)
  elseif 1 < amount then
    local bgsize = bg:getContentSize()
    amountLabel = ed.createttf(amount, 16)
    amountLabel:setAnchorPoint(ccp(1, 0))
    ed.setLabelColor(amountLabel, ccc3(255, 251, 231))
    ed.setLabelStroke(amountLabel, ccc3(39, 37, 36), 2)
    amountLabel:setPosition(bgsize.width - 10, 10)
    amountLabel:setScale(1 / bg:getScale())
    bg:addChild(amountLabel)
  end
  return bg, equip, amountLabel
end

class.createIconWithAmount = createIconWithAmount

local function createIconWithAmountNew(param)
  local id, length, amount, quality, addition = param.id, param.length, param.amount, param.quality, param.addition
  local bg, equip = createIcon(id, length, quality, addition)
  amount = amount or ed.player.equip_qunty[id] or 0
  local amountLabel
  if 1 < amount then
    amountLabel = ed.getNumberNode({
      text = "" .. amount,
      folder = "prop_amount",
      padding = -1
    })
    local alNode = amountLabel.node
    alNode:setAnchorPoint(ccp(1, 1))
    local center = ed.getCenterPos(bg)
    alNode:setPosition(ccpAdd(center, ccp(20, -5)))
    bg:addChild(alNode)
  end
  return bg, equip, amountLabel
end

class.createIconWithAmountNew = createIconWithAmountNew

local function isFragmentEnough(id)
  if not id then
    return false
  end
  if not ed.getDataTable("equip")[id] then
    return false
  end
  local category = ed.getDataTable("equip")[id].Category
  if category ~= T("\231\162\142\231\137\135") then
    return
  end
  local info = ed.getDataTable("fragment")
  local makeId
  local needAmount = 0
  for k, v in pairs(info) do
    if v["Fragment ID"] == id then
      needAmount = v["Fragment Count"]
      makeId = k
      break
    end
  end
  if needAmount > ed.player.equip_qunty[id] then
    return false
  else
    if ed.itemType(makeId) == "hero" and ed.player.heroes[makeId] then
      return false
    end
    return true
  end
end

class.isFragmentEnough = isFragmentEnough

local function createIconWithTag(id, length, amount, quality)
  local info = ed.getDataTable("fragment")[id]
  local fid, needAmount, universalId, needUniversalAmount
  if not info then
    fid = id
    needAmount = 999999
    universalId = 0
    needUniversalAmount = 99999
  else
    fid = info["Fragment ID"]
    needAmount = info["Fragment Count"]
    universalId = info["Universal Fragment ID"]
    needUniversalAmount = info["Universal Fragment Count"]
  end
  local canCompose
  local lack = needAmount - (ed.player.equip_qunty[fid] or 0)
  if lack <= 0 then
    canCompose = true
  else
    canCompose = false
  end
  local bg, fragment, amountLabel = createIconWithAmount(fid, length, amount, quality)
  local isOwnedHero
  if ed.itemType(id) == "hero" and ed.player.heroes[id] then
    isOwnedHero = true
  end
  local tag
  if canCompose and not isOwnedHero then
    tag = ed.createSprite("UI/alpha/1080P/common/fragment_tick.png")
    tag:setAnchorPoint(ccp(0, 0))
    tag:setPosition(ccp(4, 4))
    bg:addChild(tag)
  end
  return bg, fragment, amountLabel, tag
end

class.createIconWithTag = createIconWithTag

local function createSmallIcon(id, quality)
  local bg, equip = createIcon(id, 38, quality)
  return bg, equip
end

class.createSmallIcon = createSmallIcon

local function getNameCard(name)
  local namePanel = ed.createSprite("UI/alpha/1080P/common/craft_promt_bg.png")
  namePanel:setAnchorPoint(ccp(0.5, 0))
  namePanel:setCascadeOpacityEnabled(true)
  local label = ed.createttf(name, 20)
  label:setPosition(ccp(namePanel:getContentSize().width / 2, namePanel:getContentSize().height / 2 + 5))
  namePanel:addChild(label)
  if label:getContentSize().width > namePanel:getContentSize().width then
    namePanel:setScaleX(label:getContentSize().width / namePanel:getContentSize().width * 1.06)
    label:setScaleX(namePanel:getContentSize().width / label:getContentSize().width / 1.06)
  end
  return namePanel
end

class.getNameCard = getNameCard

local function getDetailCard(id, info, config, awakenstatus)
  config = config or {}
  local ow, oh = config.ow, config.oh
  local anchor = config.anchor or ccp(0.5, 0)
  local noArrow = config.noArrow or true
  oh = oh or 0
  local pw, ph = ow or 280, 70
  local lh = 0
  
  local function createLabel(text)
    local label = ed.createttf(text, 16)
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentTop)
    ed.setLabelDimensions(label, CCSizeMake(pw - 40, 0))
    label:setAnchorPoint(ccp(0, 0))
    return label
  end
  
  info = info or {}
  local basey = 30
  local panel, panel_2
  panel = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 20, 200)
    }
  })
  if resource_config.detailcard_frame_darker then
    panel_2 = ed.createNode({
      t = "Scale9Sprite",
      base = {
        res = "UI/alpha/1080P/common/mail_bj9_1.png",
        capInsets = CCRectMake(10, 25, 10, 200)
      }
    })
    panel_2:setAnchorPoint(ccp(0, 0))
    panel:addChild(panel_2)
  end
  
  local function setPanelSize(size)
    panel:setContentSize(size)
    if not tolua.isnull(panel_2) then
      panel_2:setContentSize(size)
    end
  end
  
  local scItemHeight = 15
  if info.ps then
    local ps = ed.createttf(info.ps, 16)
    ed.setLabelShadow(ps, ccc3(0, 0, 0), ccp(0, 2))
    ed.setLabelDimensions(ps, CCSizeMake(pw - 40, 0))
    local size = ps:getContentSize()
    local psh = size.height
    ps:setHorizontalAlignment(kCCTextAlignmentLeft)
    ps:setAnchorPoint(ccp(0, 0.5))
    ps:setPosition(ccp(20, 10 + psh / 2))
    ed.setLabelColor(ps, ccc3(238, 204, 119))
    panel:addChild(ps)
    oh = psh + oh - 10
    scItemHeight = 30
  end
  local s_des = {
    Gold = T("\233\135\145\229\184\129\230\152\175\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\228\184\150\231\149\140\233\135\140\228\184\128\232\136\172\231\154\132\232\180\167\229\184\129\227\128\130"),
    Diamond = T("\233\146\187\231\159\179\230\152\175\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\228\184\150\231\149\140\233\135\140\230\156\128\233\128\154\231\148\168\231\154\132\232\180\167\229\184\129\227\128\130"),
    rand_soul = T("\229\143\175\232\131\189\230\152\175\228\187\187\228\189\149\232\139\177\233\155\132\231\154\132\231\129\181\233\173\130\231\159\179"),
    Medal = T("\229\190\189\231\171\160"),
    MagicBox = T("\231\174\177\229\173\144\233\135\140\230\156\137\229\165\189\229\164\154\229\165\189\229\164\154\232\163\133\229\164\135\231\154\132\229\147\159"),
    ActPoint = T("\228\187\187\229\138\161\231\130\185\239\188\140\231\148\168\228\186\142\230\143\144\229\141\135\230\136\152\232\175\129\231\173\137\231\186\167"),
    PlayerEXP = T("\230\136\152\233\152\159\231\187\143\233\170\140\239\188\140\231\148\168\228\186\142\230\136\152\233\152\159\229\141\135\231\186\167"),
    Coin = T("\233\135\145\229\184\129\230\152\175\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\228\184\150\231\149\140\233\135\140\228\184\128\232\136\172\231\154\132\232\180\167\229\184\129\227\128\130"),
    money = T("\233\135\145\229\184\129\230\152\175\229\176\143\229\134\176\229\134\176\228\188\160\229\165\135\228\184\150\231\149\140\233\135\140\228\184\128\232\136\172\231\154\132\232\180\167\229\184\129\227\128\130"),
    Vitality = T("\233\165\191\228\186\134\229\144\151\239\188\140\230\157\165\229\157\151\233\184\161\232\133\191~"),
    PvpMoney = T("\231\171\158\230\138\128\229\184\129"),
    ArenaPoint = T("\231\171\158\230\138\128\229\184\129\239\188\140\231\148\168\228\186\142\229\156\168\231\171\158\230\138\128\229\156\186\229\149\134\229\186\151\228\184\173\232\180\173\228\185\176\229\149\134\229\147\129"),
    arenapoint = T("\231\171\158\230\138\128\229\184\129\239\188\140\231\148\168\228\186\142\229\156\168\231\171\158\230\138\128\229\156\186\229\149\134\229\186\151\228\184\173\232\180\173\228\185\176\229\149\134\229\147\129"),
    CrusadePoint = T("\231\186\162\233\190\153\233\128\134\233\179\158\239\188\140\231\148\168\228\186\142\229\156\168\232\191\156\229\190\129\229\149\134\229\186\151\228\184\173\232\180\173\228\185\176\229\149\134\229\147\129"),
    DreamPoint = T("\230\162\166\228\185\139\230\150\176\229\143\182\239\188\140\231\148\168\228\186\142\229\156\168\230\162\166\229\162\131\229\149\134\229\186\151\228\184\173\232\180\173\228\185\176\229\149\134\229\147\129")
  }
  local equipType
  if type(id) == "string" then
    local ds = s_des[id] or s_des[info.kind or info.type]
    local ds = s_des[id]
    equipType = id
    if ed.tokenTblLower[string.lower(equipType)] then
      panel = ed.ui.packageDetailWin.create({id = id, type = equipType})
      panel:popWindow(800)
      return CCNode:create()
    end
    if not ds and info and info.des then
      ds = info.des
    end
    if id == "Medal" then
      ds = info.medal
    end
    ds = ds or "nil id = " .. id
    if ds then
      local descLabel = createLabel(ds)
      descLabel:setPosition(ccp(20, scItemHeight + lh + oh))
      panel:addChild(descLabel, 5)
      lh = lh + descLabel:getContentSize().height
      ed.setLabelColor(descLabel, ccc3(241, 193, 113))
      lh = lh + 10
    end
    setPanelSize(CCSizeMake(pw, scItemHeight + lh + oh))
    return panel
  end
  if info.kind and info.kind == "selfmonthcard" then
    local ds = T("\232\191\158\231\187\17330\229\164\169\239\188\140\230\175\143\229\164\169\229\143\175\228\187\165\233\162\134\229\143\150120\233\146\187\231\159\179\227\128\130")
    if ds then
      pw = 300
      local descLabel = createLabel(ds)
      descLabel:setPosition(ccp(20, scItemHeight + lh + oh))
      panel:addChild(descLabel, 5)
      lh = lh + descLabel:getContentSize().height
      ed.setLabelColor(descLabel, ccc3(241, 193, 113))
      lh = lh + 10
    end
    setPanelSize(CCSizeMake(pw, scItemHeight + lh + oh))
    return panel
  end
  local level, levelText, category
  local description = {}
  local detail
  local descLabel = {}
  local detailLabel, row
  if ed.itemType(id) == "hero" or info.isUnit then
    row = ed.getDataTable("Unit")[id]
    level = info.level or 1
    levelText = ed.formatLevel("LV.") .. level
    if not row then
      ed.showToast(T("Unit id\228\184\141\229\173\152\229\156\168"))
      return
    end
    description = row.Description
    if description then
      descLabel = createLabel(description)
      descLabel:setPosition(ccp(20, basey + lh + oh))
      panel:addChild(descLabel, 5)
      lh = lh + descLabel:getContentSize().height
      ed.setLabelColor(descLabel, ccc3(241, 193, 113))
      lh = lh + 10
    end
  elseif ed.itemType(id) == "equip" then
    local dt = ed.getDataTable("equip")
    row = dt[id]
    if not row then
      ed.showToast(T("equip id\228\184\141\229\173\152\229\156\168"))
      return
    else
      if not equipType then
        for type, itemID in pairs(ed.resToIconId) do
          if itemID == id then
            equipType = type
            break
          end
        end
      end
      panel = ed.ui.packageDetailWin.create({id = id, type = equipType})
      panel:popWindow()
      return CCNode:create()
    end
  end
  local detailBg = ed.createSprite("UI/alpha/1080P/common/tip_detail_bg.png")
  detailBg:setAnchorPoint(ccp(0, 0))
  detailBg:setPosition(ccp(0, basey - 5 + oh))
  panel:addChild(detailBg)
  local s = detailBg:getContentSize()
  detailBg:setScaleX(pw / s.width)
  detailBg:setScaleY(lh / s.height)
  lh = lh + 10
  if not info.hidelv then
    local level = ed.createttf(levelText, 15)
    level:setAnchorPoint(ccp(0, 0))
    level:setPosition(ccp(70, lh + 20 + oh))
    ed.setLabelColor(level, ccc3(255, 234, 198))
    panel:addChild(level)
  end
  local icon
  if ed.itemType(id) == "hero" or info.isUnit then
    local hr = ed.heroLevel2Rank(info.level)
    if info.rank and 0 < info.rank then
      hr = info.rank
    end
    icon = createUnitIcon(id, 40, hr, awakenstatus)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setPosition(20, lh + 20 + oh)
    panel:addChild(icon)
    local name, w, h = ed.readhero.createHeroNameByInfo({
      tid = id,
      name = row["Display Name"],
      rank = hr
    })
    name:setScale(info.nameScale or 0.75)
    name:setPosition(ccp(70, info.namePosY or lh + 40 + oh + h / 2 * 0.75))
    panel.name = name
    panel:addChild(name)
    if info.isBoss then
      local bossLabel = ed.createttf("BOSS", 15)
      bossLabel:setAnchorPoint(ccp(0, 0.5))
      local x = name:getPositionX() + w * 0.75 + 10
      local y = name:getPositionY()
      bossLabel:setPosition(ccp(x, y))
      ed.setLabelColor(bossLabel, ccc3(255, 102, 49))
      panel:addChild(bossLabel)
    end
  elseif ed.itemType(id) == "equip" then
    icon = createIcon(id, 40)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setPosition(20, lh + 20 + oh)
    panel:addChild(icon)
    local name = ed.createttf(row.Name, 15)
    name:setAnchorPoint(ccp(0, 0.5))
    name:setPosition(ccp(70, lh + 40 + oh + name:getContentSize().height / 2))
    ed.setNodeMaxWidth(name, 124)
    panel:addChild(name)
    if ed.isElementInTable(row.Category, {
      T("\231\162\142\231\137\135"),
      T("\231\129\181\233\173\130\231\159\179"),
      T("\228\185\166\230\156\172")
    }) then
      local amount, need = 0, 0
      if row.Category == T("\231\162\142\231\137\135") then
        amount = ed.player.equip_qunty[id] or 0
        need = getFragmentAmount(id).need or 999
      elseif row.Category == T("\228\185\166\230\156\172") then
        local bookIsOTB = ed.ui.warcollege.equipIsOTB(id)
        if not bookIsOTB then
          local fid = ed.getDataTable("equipcraft")[id].Component1
          need = ed.getDataTable("equipcraft")[id]["Component1 Count"] or 0
          amount = ed.player.equip_qunty[fid] or 0
        end
      else
        local makeid = getComposedID(id)
        if ed.itemType(makeid) == "hero" then
          amount = ed.readhero.getStoneAmount(makeid)
          need = ed.readhero.getStoneNeed(makeid)
        end
      end
      if need then
        local lb1 = ed.createttf("(", 15)
        lb1:setPosition(ed.getRightSidePos(name, 5))
        lb1:setAnchorPoint(ccp(0, 0.5))
        ed.setLabelColor(lb1, ed.toccc3(16114110))
        panel:addChild(lb1)
        local lb2 = ed.createttf(amount, 15)
        lb2:setPosition(ed.getRightSidePos(lb1))
        lb2:setAnchorPoint(ccp(0, 0.5))
        ed.setLabelColor(lb2, amount < need and ed.toccc3(16737841) or ed.toccc3(16114110))
        panel:addChild(lb2)
        local lb3 = ed.createttf(string.format("/%d)", need), 15)
        lb3:setPosition(ed.getRightSidePos(lb2))
        lb3:setAnchorPoint(ccp(0, 0.5))
        ed.setLabelColor(lb3, ed.toccc3(16114110))
        panel:addChild(lb3)
      end
    else
      local amount = ed.player:getEquipAmount(id)
      if 0 < amount then
        local lb1 = ed.createttf(string.format(T("(\230\139\165\230\156\137%d\228\187\182)"), amount), 15)
        if EDLanguageArea == "southeastasia_en" then
          ed.setLabelString(lb1, amount .. "/999")
        end
        lb1:setPosition(ccp(pw - 20, lh + 40 + oh))
        lb1:setAnchorPoint(ccp(1, 0))
        ed.setLabelColor(lb1, ed.toccc3(16114110))
        panel:addChild(lb1)
      end
    end
  end
  setPanelSize(CCSizeMake(pw, ph + lh + oh))
  return panel, icon
end

class.getDetailCard = getDetailCard

function class.getCampLevelTextFormat(info)
  return T("\233\152\181\232\144\165\231\173\137\231\186\167:LV.%d")
end

local function getEquipableHeroList(id)
  local hList = {}
  local eid = id
  local row = ed.getDataTable("equip")[id]
  if not row then
    return {}
  end
  local category = row.Category
  if category == T("\231\162\142\231\137\135") then
    local ft = ed.getDataTable("fragment")
    for k, v in pairs(ft) do
      if v["Fragment ID"] == id then
        eid = k
        break
      end
    end
  end
  for k, v in pairs(ed.player.heroes) do
    local hero = v
    local tid = hero._tid
    local rank = hero._rank
    for i = 1, 6 do
      local equip = ed.getDataTable("hero_equip")[tid][rank]["Equip" .. i .. " ID"]
      if equip == eid and hero:getEquipid(i) == 0 then
        table.insert(hList, hero)
        break
      end
    end
  end
  return hList
end

class.getEquipableHeroList = getEquipableHeroList

local function createStagedoneLootIcon(id, length, amount, quality)
  local bg, equip, amountLabel = createIconWithAmount(id, length, amount, quality)
  local tag
  if ed.isPropEquipable(id) then
    tag = ed.createSprite("UI/alpha/1080P/common/can_deal_tag.png")
    local size = bg:getContentSize()
    local px = length and length - 8 or size.width - 8
    local py = px
    tag:setPosition(ccp(px, py))
    bg:addChild(tag)
  end
  return bg, equip, amountLabel, tag
end

class.createStagedoneLootIcon = createStagedoneLootIcon

local function getShapeFrameRes(id)
  local fres
  if 0 < (id or 0) then
    local fm
    local it = ed.itemType(id)
    if it == "equip" then
      local category = ed.readequip.value(id, "Category")
      if category == T("\231\162\142\231\137\135") or category == T("\231\129\181\233\173\130\231\159\179") then
        fm = true
      end
    end
    if fm then
      fres = "UI/alpha/HVGA/task_fragment_icon_bg.png"
    else
      fres = "UI/alpha/HVGA/task_icon_bg.png"
    end
  else
    fres = "UI/alpha/HVGA/task_icon_bg.png"
  end
  return fres
end

class.getShapeFrameRes = getShapeFrameRes

local function createIconWithLevel(id, level, showGray)
  local ox, oy = 70, 20
  local dx, dy = 0, 13
  local bg, equip = createIcon(id)
  local star = {}
  local ml = getMaxLevel(id)
  if (showGray or 0 < level) and 1 <= ml then
    local starBg = ed.createSprite("UI/alpha/1080P/common/equipupgrade_equip_bg.png")
    starBg:setScale(1.2)
    starBg:setAnchorPoint(ccp(1, 0.5))
    starBg:setScaleY(bg:getContentSize().height / starBg:getContentSize().height - 0.06)
    starBg:setPosition(ccp(bg:getContentSize().width - 5, bg:getContentSize().height / 2 - 1))
    bg:addChild(starBg)
  end
  for i = 1, level do
    local goldStar = ed.createSprite("UI/alpha/1080P/common/equipupgrade_star_blue.png")
    goldStar:setScale(1.6)
    goldStar:setPosition(ccp(ox + 2, oy + dy * (i - 1)))
    bg:addChild(goldStar)
    star[i] = {type = "y", icon = goldStar}
  end
  if showGray then
    for i = level + 1, ml do
      local grayStar = ed.createSprite("UI/alpha/1080P/common/equipupgrade_star_grey.png")
      grayStar:setScale(1.6)
      grayStar:setPosition(ccp(ox + 2, oy + dy * (i - 1)))
      bg:addChild(grayStar)
      star[i] = {type = "n", icon = grayStar}
    end
  end
  return bg, equip, star
end

class.createIconWithLevel = createIconWithLevel

local function createTitanIconWithLevel(id, level)
  local ox, oy = 58, 18
  local dx, dy = 0, 10
  if level == nil then
    level = 0
  end
  local bg, equip = createIcon(id)
  local levelLabel
  if 0 < level then
    local levelBg = ed.createSprite("UI/alpha/HVGA/Resource_for_titan/titanlevel_bg.png")
    levelLabel = ed.createLabelTTF(level, 14)
    levelBg:addChild(levelLabel)
    local contentSize = levelBg:getContentSize()
    levelLabel:setAnchorPoint(ccp(0.5, 0.5))
    levelLabel:setPosition(ccp(contentSize.width / 2, contentSize.height / 2))
    equip:addChild(levelBg)
    levelBg:setPosition(ccp(9, 51))
  end
  return bg, equip, levelLabel
end

class.createTitanIconWithLevel = createTitanIconWithLevel

local function createHeroItem(hid, slot, showGray, hero)
  local id = getHeroItem(hid, slot, hero)
  local l, e, ml, me = getEquipLevel(hid, slot, nil, hero)
  if ed.Hero.isTitanById(hid) then
    local l = getEquipExp(hid, slot, hero)
    return createTitanIconWithLevel(id, l)
  else
    return createIconWithLevel(id, l, showGray)
  end
end

class.createHeroItem = createHeroItem

local function createESHeroItem(hid, slot)
  return createHeroItem(hid, slot, true)
end

class.createESHeroItem = createESHeroItem

local function refreshHeroItemStar(hid, slot, stars)
  local l, e, ml, me = getEquipLevel(hid, slot)
  for i = 1, l do
    if stars[i].type == "n" then
      local parent = stars[i].icon:getParent()
      local pos = ccp(stars[i].icon:getPosition())
      local goldStar = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_star_blue.png")
      goldStar:setScale(1.6)
      goldStar:setPosition(pos)
      parent:addChild(goldStar)
      stars[i].icon = goldStar
    end
  end
end

class.refreshHeroItemStar = refreshHeroItemStar

local function getEquipWithType(type)
  local equips = {}
  local tb = ed.getDataTable("equip")
  for k, v in pairs(tb) do
    if v[type] and 0 < v[type] and not equips[v.Item_ID] then
      equips[v.Item_ID] = v
    end
  end
  return equips
end

class.getEquipWithType = getEquipWithType

local function getVitalityEquip()
  return getEquipWithType("Vitality")
end

class.getVitalityEquip = getVitalityEquip

local function getExpEquip()
  return getEquipWithType("Exp")
end

class.getExpEquip = getExpEquip
local resource_res = {
  Gold = "UI/alpha/1080P/icon/gold.png",
  Coin = "UI/alpha/1080P/icon/gold.png",
  Diamond = "UI/alpha/1080P/icon/diamond.png",
  Vitality = "UI/alpha/HVGA/task_vit_icon_2.png",
  PlayerEXP = "UI/alpha/HVGA/task_exp_icon_2.png",
  GuildCoin = "UI/alpha/HVGA/money_guildtoken_small.png",
  MonthlyCardPeriod = "UI/alpha/HVGA/recharge_monthlycard_1.png",
  CrusadePoint = "UI/alpha/1080P/icon/money_crusadepoint_new.png",
  Wood = "UI/alpha/HVGA/warschool/resource_wood.png",
  Iron = "UI/alpha/HVGA/warschool/resource_iron.png",
  Crystal = "UI/alpha/HVGA/warschool/resource_crystal.png"
}
local resource_res_withboard = {
  Gold = 1578,
  Wood = 697,
  Iron = 701,
  Crystal = 705
}
local guildhero_frame_res = {
  "green",
  "blue",
  "purple",
  "red"
}

function class.getResourceRes(name, withBoard)
  local res, frame
  if withBoard then
    local number = (resource_res_withboard[name] or 0) + withBoard
    res = "UI/DOTA-ITEM/" .. number .. ".jpg"
    frame = "UI/alpha/1080P/common/frame/equip_frame_" .. guildhero_frame_res[withBoard] .. ".png"
  else
    res = resource_res[name]
  end
  return res, frame
end

function class.getResourceIcon(name, withBoard)
  local res, frame = class.getResourceRes(name, withBoard)
  if not res then
    return
  end
  local resIcon = ed.createSprite(res)
  if frame then
    local resFrame = createIconDefaultBgWithPath(frame)
    resFrame:addChild(resIcon, -1)
    resIcon:setPosition(ed.getCenterPos(resFrame))
    resIcon = resFrame
  end
  return resIcon
end

function class.getGuildHeroResIcon(name, id, withBoard)
  if "Item" == name then
    return ed.readequip.createIcon(id)
  else
    return ed.readequip.getResourceIcon(name, withBoard)
  end
end

local function getPlayerOwnRuneInfo()
  local info = {
    sun = false,
    moon = false,
    star = false
  }
  for k, v in ipairs(ed.player.equip_order) do
    local category = value(v, "Category")
    local amount = ed.player.equip_qunty[v]
    if 0 < amount and 1600 < v and category == T("\231\172\166\230\150\135\231\159\179") then
      local slot = ed.rune.getRuneSlot(v)
      info[slot] = true
    end
  end
  return {
    info.sun,
    info.moon,
    info.star
  }
end

class.getPlayerOwnRuneInfo = getPlayerOwnRuneInfo

function class.createTarotChest(id, length, quality, addition)
  addition = addition or {}
  local fres = addition.fres
  local fres2 = addition.fres2
  quality = quality or value(id, "Quality") or 2
  local frameRes = getFrameRes(quality)
  local frame = ed.createSprite(frameRes)
  frame:setCascadeOpacityEnabled(true)
  local centerPos = ed.getCenterPos(frame)
  
  local function assertResExist(res)
    local result = string.find(res, ".png") or string.find(res, ".jpg")
    if not result then
      error(string.format("Illegal TarotChest Icon id = %d, res = %s", id, res))
    end
  end
  
  local bgRes = fres or value(id, "Icon")
  local icon2Res = fres2 or value(id, "Icon2")
  assertResExist(bgRes)
  assertResExist(icon2Res)
  local bg = ed.createSprite(bgRes)
  bg:setPosition(ccpAdd(centerPos, ccp(0, 2)))
  frame:addChild(bg, -2)
  local icon2 = ed.createSprite(icon2Res)
  icon2:setPosition(ccpAdd(centerPos, ccp(-2.5, 7)))
  icon2:setScale(75 / icon2:getContentSize().width)
  frame:addChild(icon2, -4)
  if length then
    local s1 = length / frame:getContentSize().width
    frame:setScale(s1)
  end
  return frame, bg, icon2
end
