require("bit")
ed = {
  epsilon = 1.0E-6,
  emCampPlayer = 1,
  emCampEnemy = -1,
  emCampBoth = 0,
  emCampNeither = 2,
  emUnitStateBase = -1,
  emUnitState_Idle = 0,
  emUnitState_Walk = 1,
  emUnitState_Attack = 2,
  emUnitState_Hurt = 3,
  emUnitState_Dead = 4,
  emUnitState_Birth = 5,
  emUnitState_Dying = 6,
  emUnitStateCount = 7,
  opManualSkill = 0,
  opJoinHeroBattle = 1,
  opExitBattle = 2,
  opEnergyBean = 3,
  opJoinMagicBattle = 4,
  opJoinEchoSkill = 5,
  opKaelTapBall = 6,
  opControlTouch = 7,
  opPrepareJoinBattle = 8,
  opPrepareUndoJoinBattle = 9,
  opControlTarget = 10,
  opBitWidth4 = false,
  opDamageToBoss = 11,
  siegeUnitYBias = 220,
  deepProjectionX = math.cos(math.rad(90)),
  deepProjectionY = math.sin(math.rad(90)),
  ccp = ccp,
  ccpAdd = ccpAdd,
  ccpSub = ccpSub,
  ccpMult = ccpMult,
  ccpCompMult = ccpCompMult,
  ccpLengthSQ = ccpLengthSQ,
  ccpDistanceSQ = ccpDistanceSQ,
  ccpNormalize = ccpNormalize,
  CCRectGetMaxX = function(rect)
    return rect.origin.x + rect.size.width
  end,
  CCRectGetMaxY = function(rect)
    return rect.origin.y + rect.size.height
  end,
  CCRectIntersect = function(rectA, rectB)
    local max, min = math.max, math.min
    local intersection = CCRectMake(max(rectA.origin.x, rectB.origin.x), max(rectA.origin.y, rectB.origin.y), 0, 0)
    intersection.size.width = min(ed.CCRectGetMaxX(rectA), ed.CCRectGetMaxX(rectB)) - intersection.origin.x
    intersection.size.height = min(ed.CCRectGetMaxY(rectA), ed.CCRectGetMaxY(rectB)) - intersection.origin.y
    return intersection
  end,
  ui = {},
  rune = {},
  player = {},
  off_legendEquipOp = true,
  isNewDamageNum = false
}
local ed = ed
require("time")
local rshift = bit.rshift
local lshift = bit.lshift
local band = bit.band

local function bits(num, low, count)
  return band(rshift(num, low), 2 ^ count - 1)
end

ed.bits = bits

local function toBits(num)
  local t = {}
  local rest = 0
  while 0 < num do
    rest = math.fmod(num, 2)
    t[#t + 1] = rest
    num = (num - rest) / 2
  end
  return t
end

ed.toBits = toBits
local select = select

local function makebits(...)
  local value = 0
  local b0 = 0
  for i = select("#", ...), 1, -2 do
    local b = select(i - 1, ...)
    local v = select(i, ...)
    local v2 = bits(v, 0, b)
    if v ~= v2 then
      EDDebug("value out of bit boundry")
    end
    v = lshift(v, b0)
    value = value + v
    b0 = b0 + b
  end
  return value
end

ed.makebits = makebits

local function splitbits(value, ...)
  local list = {}
  local b0 = 0
  for i = select("#", ...), 1, -1 do
    local b = select(i, ...)
    table.insert(list, bits(value, b0, b))
    b0 = b0 + b
  end
  local l2 = {}
  for i, v in ipairs(list) do
    l2[#list - i + 1] = v
  end
  return unpack(l2)
end

ed.splitbits = splitbits
if ccp then
  ed.ccpZero = ccp(0, 0)
  local ccpWinSize = CCDirector:sharedDirector():getWinSize()
  ed.ccpWinSize = ccp(ccpWinSize.width, ccpWinSize.height)
  ed.winSize = {
    ccpWinSize.width,
    ccpWinSize.height
  }
  
  local function winPosition(x, y)
    return ed.edpCompMult(ed.winSize, ccp(x, y))
  end
  
  ed.winPosition = winPosition
  
  local function ccpWinPosition(x, y)
    return ed.ccpCompMult(ed.ccpWinSize, ccp(x, y))
  end
  
  ed.ccpWinPosition = ccpWinPosition
  local ccc3 = ccc3
  
  local function toccc3(hex)
    return ccc3(hex / 65536, hex / 256 % 256, hex % 256)
  end
  
  ed.toccc3 = toccc3
end

function log(...)
  if logfile then
    logfile:write(...)
    logfile:write("\n")
    logfile:flush()
  else
    print(...)
  end
end

ed.log = log
local multiplier = 3125
local moder = 34359738337
local random_seed = 1
local scene_pre_rand = false

function ed.setRandRunWithScene(bool)
  scene_pre_rand = bool
end

local function rand()
  local next_seed = random_seed * multiplier % moder
  local ret = next_seed / moder
  if not scene_pre_rand then
    random_seed = next_seed
  end
  if do_battle_log then
    btlog("Rand:" .. string.format("%.30f", ret))
  end
  return ret
end

ed.rand = rand
local logbuffer

local function srand(seed)
  if do_battle_log then
    logbuffer = ed.StringBufferCreate()
  end
  if seed == 0 then
    print("Error:srand(0)")
    seed = 1
  elseif do_battle_log then
    btlog("srand(" .. seed .. ")")
  end
  random_seed = seed
  for index = 1, 3 do
    ed.rand()
  end
  if ed.run_with_scene then
    ed.battleshare.getRseed(seed)
  end
end

ed.srand = srand

function ed.getrand()
  return random_seed
end

function ed.getLogBuffer()
  return logbuffer
end

local function toboolean(var)
  if var == nil or var == false then
    return false
  end
  if type(var) == "string" then
    local lower = string.lower(var)
    return lower == "yes" or lower == "true" or lower == "y"
  elseif type(var) == "number" then
    return var ~= 0
  else
    return true
  end
end

ed.toboolean = toboolean

function override(basefunc, derivedfunc)
  assert(basefunc)
  assert(derivedfunc)
  return function(...)
    return derivedfunc(basefunc, ...)
  end
end

ed.override = override

local function wraptable(table, patch)
  local __depth = table.__depth or 0
  table.__depth = __depth + 1
  setmetatable(patch, {__index = table})
  return patch
end

ed.wraptable = wraptable

function ccArrayMake(...)
  local arg = ed.pack(...)
  if #arg == 1 and type(arg[1]) == "table" then
    arg = arg[1]
  end
  local ret = CCArray:createWithCapacity(#arg)
  for k = 1, #arg do
    ret:addObject(arg[k])
  end
  return ret
end

ed.ccArrayMake = ccArrayMake
if not EDGetFileData then
  function EDGetFileData(file)
    local file = io.open(file)
    
    local content = file:read("*a")
    file:close()
    return content
  end
end

function multiinher(class, parents)
  setmetatable(class, {
    __index = function(t, key)
      for k, v in pairs(parents) do
        if v[key] then
          return v[key]
        end
      end
      return nil
    end
  })
end

function setimplements(class, ...)
  class = class or {}
  local amount = select("#", ...)
  for i = 1, amount do
    local tar = select(i, ...)
    local interface = tar.interface
    for k, v in pairs(interface or {}) do
      if class[k] then
        print("--<<setimplements>>-- Dumlicated key : ", k)
      else
        class[k] = interface[k]
      end
    end
  end
end

function newclass(superclass)
  local class = {
    mt = {}
  }
  class.mt.__index = class
  if superclass then
    if type(superclass) == "table" then
      setmetatable(class, superclass)
    elseif type(superclass) == "string" and superclass == "g" then
      setmetatable(class, {__index = _G})
    end
  end
  return class
end

function newwindow()
  local base = ed.ui.popwindow
  local class = newclass(base.mt)
  return class, base
end

local filter = {"create"}

function newscene(scene, identity)
  assert(type(scene) == "table")
  local base = ed.ui.basescene
  for fname, fvalue in pairs(scene) do
    if type(fvalue) == "function" and not ed.isElementInTable(fname, filter) and base[fname] then
      print(T("New Scene Can NOT Override Base Scene's Function(%s)!", fname))
      EDDebug()
    end
  end
  setmetatable(scene, base.mt)
  local new = base.create(identity)
  setmetatable(new, scene)
  return new
end

local math = math
local min = math.min
local max = math.max

local function allocPosition(full, left, right, len, auto_len, stretch)
  if left and right and len then
    if math.abs(full - (left + right + len)) < ed.epsilon then
    else
      EDDebug()
      return
    end
  elseif left and right then
    if stretch then
      len = full - left - right
    elseif auto_len then
      len = auto_len()
      if len then
        left = left + (full - left - right - len) / 2
      else
        len = full - left - right
      end
    else
      len = full - left - right
    end
  elseif left and len then
    right = full - left - len
  elseif right and len then
    left = full - len - right
  elseif len then
    left = (full - len) / 2
  else
    if auto_len then
      return allocPosition(full, left, right, auto_len(), nil, stretch)
    else
    end
  end
  if len < 0 then
    EDDebug("WARNING: UI panel size < 0")
  end
  return left, len
end

ed.allocPosition = allocPosition

local function castLayout2BottomLeftRect(layout, width, height)
  local x, w = allocPosition(width, layout.left, layout.right, layout.fix_width)
  local y, h = allocPosition(height, layout.bottom, layout.top, layout.fix_height)
  return CCRectMake(x, y, w, h)
end

ed.castLayout2BottomLeftRect = castLayout2BottomLeftRect

local function castLayout2TopLeftRect(layout, width, height)
  local x, w = allocPosition(width, layout.left, layout.right, layout.fix_width)
  local y, h = allocPosition(height, layout.top, layout.bottom, layout.fix_height)
  return CCRectMake(x, y, w, h)
end

ed.castLayout2TopLeftRect = castLayout2TopLeftRect

function ed.getRelativePosition(sprite, pos, offset)
  local x, y = 0, 0
  if offset then
    x, y = offset.x, offset.y
  end
  local size = sprite:getContentSize()
  return ccp(pos.x * size.width + x, pos.y * size.height + y)
end

local function checkVisible(node)
  local parent = node:getParent()
  if tolua.isnull(parent) then
    return node:isVisible()
  end
  return node:isVisible() and checkVisible(parent)
end

ed.checkVisible = checkVisible
local format = string.format
local sub = string.sub
local gsub = string.gsub

local function createNumbers(node, str, padding, rightAlignment, colorStr, addition)
  addition = addition or {}
  local oripath = addition.path
  local suffix = addition.suffix
  colorStr = colorStr or "white"
  padding = padding or -2
  local texture = ed.loadNumTexture()
  local bathnode = CCSpriteBatchNode:createWithTexture(texture)
  node:removeAllChildrenWithCleanup(true)
  local length = 0
  local height = 0
  for index = 1, #str do
    local i = index
    if rightAlignment then
      i = #str - i + 1
    end
    local c = sub(str, i, i)
    if c == ":" then
      c = "colon"
    end
    if c == "," then
      c = "comma"
    end
    if c == "/" then
      c = "slash"
    end
    if c == "." then
      c = "point"
    end
    local frameName = colorStr .. "_" .. c .. ".png"
    local spr = ed.creatNumSprite(frameName)
    if spr then
      local w = spr:getContentSize().width + padding
      height = spr:getContentSize().height
      local relativeX = length + w * 0.5
      if rightAlignment then
        relativeX = -relativeX
      end
      spr:setPosition(ccp(relativeX, 0))
      length = length + w
      bathnode:addChild(spr)
    else
    end
  end
  node:addChild(bathnode)
  return length, height
end

ed.createNumbers = createNumbers

local function getNumberNode(param)
  local rootNode = CCSprite:create()
  local batchNode = CCSpriteBatchNode:createWithTexture(ed.loadNumTexture())
  batchNode:setContentSize(CCSizeMake(0, 0))
  rootNode:addChild(batchNode)
  local nodeInfo = {
    node = rootNode,
    param = param,
    batchNode = batchNode,
    numNodeArr = {}
  }
  ed.refreshNumberNode(nodeInfo, param.text)
  return nodeInfo
end

ed.getNumberNode = getNumberNode

local function getNumberNodeEx(param)
  param = param or {}
  local text = tostring(param.text)
  local padding = param.padding or 0
  local path = param.path
  local folder = param.folder or "white"
  local suffix = param.suffix
  local scale = param.scale or 1
  local anchor = param.anchor
  if not text then
    return
  end
  local container_node = CCSprite:create()
  local texture = ed.loadNumTexture()
  local node = CCSprite:create()
  node:setContentSize(CCSizeMake(0, 0))
  if anchor then
    container_node:setAnchorPoint(anchor)
  end
  local w, h = 0, 0
  for i = 1, #text do
    local char = string.sub(text, i, i)
    local ct = {
      ["?"] = "what",
      [":"] = "colon",
      [","] = "comma",
      ["/"] = "slash",
      ["-"] = "-",
      ["+"] = "+"
    }
    char = ct[char] or char
    local frameName = folder .. "_" .. char .. ".png"
    local enode = ed.creatNumSprite(frameName)
    frameName = folder .. "_0" .. ".png"
    enode:setScale(scale)
    local esize = enode:getContentSize()
    local ew, eh = esize.width, esize.height
    h = math.max(eh, h)
    w = w + ew + padding
    local nsize = container_node:getContentSize()
    local nw, nh = nsize.width, nsize.height
    enode:setAnchorPoint(ccp(0, 0.5))
    enode:setPosition(ccp(nw, h / 2))
    node:addChild(enode)
    container_node:setContentSize(CCSizeMake(w * scale, h * scale))
  end
  container_node:addChild(node)
  node:setCascadeOpacityEnabled(true)
  return {node = container_node, param = param}
end

ed.getNumberNodeEx = getNumberNodeEx

local function refreshNumberNode(nodeInfo, text, newParam)
  nodeInfo.param = newParam or nodeInfo.param
  text = tostring(text)
  if not text then
    return
  end
  local padding = nodeInfo.param.padding or 0
  local path = nodeInfo.param.path
  local folder = nodeInfo.param.folder or "white"
  local suffix = nodeInfo.param.suffix
  local scale = nodeInfo.param.scale or 1
  local anchor = nodeInfo.param.anchor
  local w, h = 0, 0
  local textNum = #text
  for i = 1, textNum do
    local char = string.sub(text, i, i)
    local ct = {
      ["?"] = "what",
      [":"] = "colon",
      [","] = "comma",
      ["/"] = "slash",
      ["-"] = "-",
      ["+"] = "+"
    }
    char = ct[char] or char
    local frameName = folder .. "_" .. char .. ".png"
    local enode
    if i > #nodeInfo.numNodeArr then
      enode = ed.creatNumSprite(frameName)
      table.insert(nodeInfo.numNodeArr, enode)
      nodeInfo.batchNode:addChild(enode)
    else
      enode = ed.creatNumSprite(frameName, nodeInfo.numNodeArr[i])
      enode:setVisible(true)
    end
    enode:setScale(scale)
    local esize = enode:getContentSize()
    local ew, eh = esize.width, esize.height
    h = math.max(eh * scale, h)
    enode:setAnchorPoint(ccp(0, 0.5))
    enode:setPosition(ccp(w, h / 2))
    w = w + (ew + padding) * scale
  end
  for i = textNum + 1, #nodeInfo.numNodeArr do
    nodeInfo.numNodeArr[i]:setVisible(false)
  end
  nodeInfo.node:setContentSize(CCSizeMake(w, h))
end

ed.refreshNumberNode = refreshNumberNode

local function formatNumWithComma(amount)
  local formatted = string.format("%0.0f", amount)
  local k, subStr
  if EDCurLanguage == "es" then
    subStr = "%1 %2"
  else
    subStr = "%1,%2"
  end
  while true do
    formatted, k = gsub(formatted, "^(-?%d+)(%d%d%d)", subStr)
    if k == 0 then
      break
    end
  end
  return formatted
end

ed.formatNumWithComma = formatNumWithComma

local function cascadeSpriteFrame(target, frame)
  assert(not tolua.isnull(target), "ed.cascadeSpriteFrame() - target is not CCNode")
  if not tolua.isnull(frame) then
    local maskSprite = CCSprite:createWithSpriteFrame(frame)
    maskSprite:setAnchorPoint(ccp(0, 0))
    target:addChild(maskSprite)
  end
  return target
end

ed.cascadeSpriteFrame = cascadeSpriteFrame

local function getSplash()
  return "installer/splash.jpg"
end

ed.getSplash = getSplash

local function loadHeroExpRequirement(heroId)
  local heroExpRequired = {}
  local lvl = 1
  local expRequired = ed.lookupDataTable("Levels", "Exp", lvl)
  while expRequired do
    heroExpRequired[lvl] = expRequired
    lvl = lvl + 1
    expRequired = ed.lookupDataTable("Levels", "Exp", lvl)
  end
  return heroExpRequired
end

ed.loadHeroExpRequirement = loadHeroExpRequirement

local function getAwakeNode(awakeAttrTbl)
  awakeAttrTbl = awakeAttrTbl or {}
  local scale = 1
  local container_node = CCSprite:create()
  local texture = ed.loadAwakeTexture()
  local node = CCSpriteBatchNode:createWithTexture(texture)
  node:setContentSize(CCSizeMake(0, 0))
  local w, h = 0, 0
  for i = 1, #awakeAttrTbl do
    local frameKey
    if awakeAttrTbl[i] == true then
      frameKey = "unlock"
    else
      frameKey = "lock"
    end
    local enode = ed.creatAwakeSprite(frameKey)
    enode:setScale(scale)
    local esize = enode:getContentSize()
    local ew, eh = esize.width, esize.height
    h = math.max(eh, h)
    w = w + ew + 5
    local nsize = container_node:getContentSize()
    local nw, nh = nsize.width, nsize.height
    enode:setAnchorPoint(ccp(0, 0.5))
    enode:setPosition(ccp(nw, h / 2))
    node:addChild(enode)
    container_node:setContentSize(CCSizeMake(w * scale, h * scale))
  end
  container_node:addChild(node)
  return container_node
end

ed.getAwakeNode = getAwakeNode
local formulaLength = 4

local function loadFormula(id)
  local craft = ed.lookupDataTable("equipcraft", nil, id)
  local formula = {}
  for i = 1, formulaLength do
    local component
    if craft then
      component = craft["Component" .. i]
    else
      component = id
    end
    if component == id then
      return nil
    end
    if component and component ~= 0 then
      table.insert(formula, component)
    end
  end
  return formula
end

local callingLevel = 0

local function debugCrafting(str)
  print(string.rep("  ", callingLevel - 1) .. str)
end

local function enableCallingLevel(func)
  return function(...)
    callingLevel = callingLevel + 1
    local result = func(...)
    callingLevel = callingLevel - 1
    return result
  end
end

local function consume(pack, id)
  if pack[id] and 0 < pack[id] then
    pack[id] = pack[id] - 1
    return true
  end
  return false
end

local function tryCraft(pack, id)
  if consume(pack, id) then
    return true
  end
  local formula = loadFormula(id)
  if not formula then
    return false
  end
  for _, component in ipairs(formula) do
    if not tryCraft(pack, component) then
      return false
    end
  end
  return true
end

local function isCraftable(id)
  local pack = utils.functions.clone(ed.player.equip_qunty)
  return tryCraft(pack, id)
end

ed.isCraftable = isCraftable

local function isOwned(id)
  return ed.player.equip_qunty[id] and ed.player.equip_qunty[id] > 0
end

ed.isOwned = isOwned

local function getMaterials(cs, mt, id, temp_cost)
  local temp_cost = temp_cost or {}
  local ect = ed.getDataTable("equipcraft")
  local row = ect[id]
  local components = 0
  if row then
    components = row.Components or 0
  end
  local expense = ect[id].Expense
  local canOneTimeCraft = false
  for i = 1, components do
    local cid = row["Component" .. i]
    if cid ~= 0 then
      local need = math.max(row[string.format("Component%d Count", i)] or 1, 1)
      if ect[cid] and 0 < (ect[cid].Components or 0) then
        local use = 0
        for k, v in pairs(cs) do
          if k == cid then
            use = v
          end
        end
        for id, amount in pairs(temp_cost) do
          if id == cid then
            use = use + amount
          end
        end
        if use >= (ed.player.equip_qunty[cid] or 0) then
          local iterResult = getMaterials(cs, mt, cid)
          expense = expense + iterResult.expense
          canOneTimeCraft = true
        else
          cs[cid] = (cs[cid] or 0) + need
        end
      else
        mt[cid] = (mt[cid] or 0) + need
      end
    end
  end
  local result = {expense = expense, canOneTimeCraft = canOneTimeCraft}
  return result
end

local function equipCraftNeedItems(id, cost)
  local temp_cost = cost or {}
  local ect = ed.getDataTable("equipcraft")
  local row = ect[id]
  if not row then
    return false
  end
  if (row.Components or 0) < 1 then
    return false
  end
  local consume = {}
  local materials = {}
  local mtState = getMaterials(consume, materials, id, temp_cost)
  local totalconsume = {}
  for k, v in pairs(materials) do
    totalconsume[k] = v
  end
  for k, v in pairs(consume) do
    totalconsume[k] = v
  end
  return mtState.expense, totalconsume, consume
end

ed.equipCraftNeedItems = equipCraftNeedItems

local function isEquipCraftable(id, onetime, count)
  local ect = ed.getDataTable("equipcraft")
  local row = ect[id]
  local count = count or 1
  local has = count <= (ed.player.equip_qunty[id] or 0)
  if not row or 1 > (row.Components or 0) then
    return has
  end
  local consume = {}
  local materials = {}
  local mtState = getMaterials(consume, materials, id)
  if not has or onetime == true then
    for k, v in pairs(materials) do
      if (ed.player.equip_qunty[k] or 0) < v * count then
        return false
      end
    end
  end
  local totalconsume = {}
  for k, v in pairs(materials) do
    totalconsume[k] = v
  end
  for k, v in pairs(consume) do
    totalconsume[k] = v
  end
  return true, mtState.expense, mtState.canOneTimeCraft, totalconsume
end

ed.isEquipCraftable = isEquipCraftable

local function isCanGetFromChest(id)
  for k, chestId in ipairs(ed.chestIdOfEquipId[id] or {}) do
    if 0 < (ed.player.equip_qunty[chestId] or 0) then
      return true
    end
  end
  return false
end

ed.isCanGetFromChest = isCanGetFromChest

local function getTotalAmountById(id)
  return (ed.player.equip_qunty[id] or 0) + ed.ShopMgr.getInstance():getOneItemTotalAmountByItemid(id)
end

local function getBuyMaterials(cs, mt, id, ids)
  local ect = ed.getDataTable("equipcraft")
  local row = ect[id]
  ids[#ids + 1] = id
  local components = 0
  if row then
    components = row.Components or 0
  end
  for i = 1, components do
    local cid = row["Component" .. i]
    if cid ~= 0 then
      local need = math.max(row[string.format("Component%d Count", i)] or 1, 1)
      if ect[cid] and 0 < (ect[cid].Components or 0) then
        local use = 0
        for k, v in pairs(cs) do
          if k == cid then
            use = v
          end
        end
        if use >= getTotalAmountById(cid) then
          getBuyMaterials(cs, mt, cid, ids)
        else
          cs[cid] = (cs[cid] or 0) + need
        end
      else
        mt[cid] = (mt[cid] or 0) + need
      end
      if cs[cid] and (ed.player.equip_qunty[cid] or 0) >= cs[cid] then
      elseif mt[cid] and (ed.player.equip_qunty[cid] or 0) >= mt[cid] then
      else
        ids[#ids + 1] = cid
      end
    end
  end
end

local function isBuyEquipCraftable(id)
  local buy_ids = {}
  local ect = ed.getDataTable("equipcraft")
  local row = ect[id]
  local has = 0 < (ed.player.equip_qunty[id] or 0)
  if has then
    return false, buy_ids
  end
  if not has and 0 < ed.ShopMgr.getInstance():getOneItemTotalAmountByItemid(id) then
    buy_ids[1] = id
    return true, buy_ids
  end
  if not row or 1 > (row.Components or 0) then
    if not has and 0 < ed.ShopMgr.getInstance():getOneItemTotalAmountByItemid(id) then
      buy_ids[1] = id
      return true, buy_ids
    else
      return false, buy_ids
    end
  end
  local buy_consume = {}
  local buy_materials = {}
  getBuyMaterials(buy_consume, buy_materials, id, buy_ids)
  if not has then
    for k, v in pairs(buy_materials) do
      if v > getTotalAmountById(k) then
        return false, buy_ids
      end
    end
  end
  return true, buy_ids
end

ed.isBuyEquipCraftable = isBuyEquipCraftable

local function isPropEquipable(id)
  if ed.itemType(id) == "hero" then
    return false
  end
  local equipTable = ed.getDataTable("equip")
  local row = equipTable[id]
  if not row then
    return
  end
  local category = row.Category
  if category ~= T("\233\155\182\228\187\182") and category ~= T("\229\144\136\230\136\144\229\147\129") then
    return
  end
  local heroEquips = ed.getDataTable("hero_equip")
  for k, v in pairs(ed.player.heroes) do
    local hero = v
    local tid = hero._tid
    local rank = hero._rank
    local level = hero._level
    for i = 1, 6 do
      local eid = ed.getDataTable("hero_equip")[tid][rank]["Equip" .. i .. " ID"]
      local erow = ed.getDataTable("equip")[eid]
      if erow then
        local rl = erow["Level Requirement"]
        if ((hero._items or {})[i]._item_id or 0) == 0 and eid == id and level >= rl then
          return true
        end
      end
    end
  end
  return false
end

ed.isPropEquipable = isPropEquipable

local function setKeyBack(node, func)
  local keypadLayer = CCLayer:create()
  keypadLayer:setKeypadEnabled(true)
  if func then
    keypadLayer:registerScriptKeypadHandler(func)
  else
    keypadLayer:registerScriptKeypadHandler(function(event)
      if event == "backClicked" then
        ed.popScene()
      end
    end)
  end
  node:addChild(keypadLayer)
  return keypadLayer
end

ed.setKeyBack = setKeyBack

local function addKeyback(param)
  param = param or {}
  local node = param.node
  local handler = param.handler
  if tolua.isnull(node) then
    print("addKeyBack - U should to set the container!")
    return
  end
  return ed.setKeyBack(node, function(event)
    if event == "backClicked" then
      if handler then
        handler()
      else
        print("addKeyBack - U have not set the backkey-handler yet!")
      end
    end
  end)
end

ed.addKeyback = addKeyback

local function getNodeSize(node, bWithMessageRect)
  if tolua.isnull(node) then
    return
  end
  if node.getAnchorPoint == nil then
    return
  end
  if tolua.isnull(node:getParent()) then
    return
  end
  local anchor = node:getAnchorPoint()
  local posX, posY
  local pos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
  posX = pos.x
  posY = pos.y
  local size
  local messageRect = node:getMessageRect()
  if messageRect.size.width ~= 0 and messageRect.size.height ~= 0 and bWithMessageRect == true then
    size = messageRect.size
    posY = posY + messageRect.origin.y
  else
    size = node:getContentSize()
  end
  local scaleX = node:getScaleX()
  local scaleY = node:getScaleY()
  local w = size.width * scaleX
  local h = size.height * scaleY
  if scaleX < 0 then
    anchor.x = 1 - anchor.x
    w = -w
  end
  if scaleY < 0 then
    anchor.y = 1 - anchor.y
    h = -h
  end
  local x = posX + (0 - anchor.x) * w
  local y = posY + (0 - anchor.y) * h
  return CCRectMake(x, y, w, h)
end

ed.getNodeSize = getNodeSize

local function containsPoint(element, ex, ey)
  local rect = getNodeSize(element, true)
  if rect == nil then
    return false
  end
  return rect:containsPoint(ccp(ex, ey))
end

ed.containsPoint = containsPoint

local function containsPoint2(element, ex, ey, scale)
  local rect = getNodeSize(element, true)
  if rect == nil then
    return false
  end
  if scale then
    rect.size.width = rect.size.width * scale
    rect.size.height = rect.size.height * scale
    rect.origin.y = rect.size.height * (1 - scale) + rect.origin.y
  end
  return rect:containsPoint(ccp(ex, ey))
end

ed.containsPoint2 = containsPoint2

function ed.containsPointInLocal(node, x_world, y_world)
  local pos = node:convertToNodeSpace(ccp(x_world, y_world))
  local size = node:getContentSize()
  return CCRectMake(0, 0, size.width, size.height):containsPoint(pos)
end

local function isPointInRect(rect, x, y, element)
  local pos = rect.origin
  local size = rect.size
  if not tolua.isnull(element) then
    pos = element:convertToWorldSpace(pos)
    local size = element:getContentSize()
    size = CCSizeMake(size.width * element:getScaleX(), size.height * element:getScaleY())
  end
  rect = CCRectMake(pos.x, pos.y, size.width, size.height)
  return rect:containsPoint(ccp(x, y))
end

ed.isPointInRect = isPointInRect

local function isPointInCircle(centerPos, radius, x, y, element)
  local pos = centerPos
  if element and not tolua.isnull(element) then
    pos = element:convertToWorldSpace(pos)
    local size = element:getContentSize()
    radius = radius * math.min(element:getScaleX(), element:getScaleY())
  end
  local dis = (pos.x - x) * (pos.x - x) + (pos.y - y) * (pos.y - y)
  dis = math.sqrt(dis)
  return radius >= dis
end

ed.isPointInCircle = isPointInCircle

local function registerOverloadFunc(class, funcName, funcDetail, index)
  local funcList = funcName .. "Func"
  if not class[funcList] then
    class[funcList] = {}
  end
  if index then
    table.insert(class[funcList], index, funcDetail)
  else
    table.insert(class[funcList], funcDetail)
  end
end

ed.registerOverloadFunc = registerOverloadFunc

local function setOverloadFunc(class, funcName)
  local funcList = class[funcName .. "Func"]
  class[funcName] = function(...)
    local args_amount = select("#", ...)
    local args = {}
    for i = 1, args_amount do
      local arg = select(i, ...)
      if type(arg) == "nil" then
        arg = "this arg is nil"
      end
      table.insert(args, arg)
    end
    for k, v in pairs(funcList) do
      local isThis = true
      for i = 1, args_amount do
        if args[i] == "this arg is nil" then
          args[i] = nil
        end
        if args[i] ~= nil then
          if type(v.types[i]) ~= "table" then
            if type(args[i]) ~= v.types[i] then
              isThis = false
              break
            end
          else
            isThis = false
            for k, v in pairs(v.types[i]) do
              if type(args[i]) == v then
                isThis = true
                break
              end
            end
          end
        end
      end
      if isThis then
        return v.func(...)
      end
    end
  end
end

ed.setOverloadFunc = setOverloadFunc

local function getDisplayVertex()
  return -ed.display.halfFixedWidth, ed.display.winSize.width - ed.display.halfFixedWidth, ed.display.winSize.height - ed.display.halfFixedHeight, -ed.display.halfFixedHeight
end

ed.getDisplayVertex = getDisplayVertex

local function isElementInTable(element, table)
  if nil == table then
    return false
  end
  for k, v in pairs(table) do
    if element == v then
      return true
    end
  end
  return false
end

ed.isElementInTable = isElementInTable

local function canWearEquip(hid, eid, level)
  local hlv = level or ed.player.heroes[hid]._level or 0
  local elv = ed.getDataTable("equip")[eid]["Level Requirement"] or 0
  return hlv >= elv, hlv, elv
end

ed.canWearEquip = canWearEquip

local function removeElementFromTable(t, element)
  for k, v in pairs(t or {}) do
    if v == element then
      table.remove(t, k)
    end
  end
end

ed.removeElementFromTable = removeElementFromTable

local function orderHeroFunction(list)
  if nil == list then
    return
  end
  local unit = ed.getDataTable("Unit")
  table.sort(list, function(a, b)
    local titanA = unit[a._tid].IsTitan and 1 or 0
    local titanB = unit[b._tid].IsTitan and 1 or 0
    if titanA ~= titanB then
      return titanA > titanB
    elseif a._level ~= b._level then
      return b._level < a._level
    elseif a._stars ~= b._stars then
      return b._stars < a._stars
    elseif a._rank ~= b._rank then
      return b._rank < a._rank
    else
      return false
    end
  end)
  local openList = {}
  local serverTime = ed.getServerTime()
  for i, v in ipairs(list) do
    if ed.readhero.isHeroOpen(v._tid, serverTime) then
      table.insert(openList, v)
    end
  end
  return openList
end

ed.orderHeroFunction = orderHeroFunction

local function orderHeroes(hero_list, noSort)
  local heroes = hero_list or ed.player.heroes
  local list = {}
  for k, v in pairs(heroes or {}) do
    table.insert(list, v)
  end
  if noSort then
    return list
  else
    return ed.orderHeroFunction(list)
  end
end

ed.orderHeroes = orderHeroes

local function equipLvFromExp(id, exp)
  return 0
end

ed.equipLvFromExp = equipLvFromExp

local function equipExpFromLv(id, lv)
  local rank = ed.lookupDataTable("equip", "Quality", id)
  local exp = 0
  for i = 1, lv do
    local price = ed.lookupDataTable("enhancement", "Price " .. i, rank)
    exp = exp + price
  end
  return exp
end

ed.equipExpFromLv = equipExpFromLv

local function swapSizewh(size)
  local w, h = size.width, size.height
  return CCSizeMake(h, w)
end

ed.swapSizewh = swapSizewh

local function sizeAdd(s1, s2)
  local w1, h1 = s1.width, s1.height
  local w2, h2 = s2.width, s2.height
  return CCSizeMake(w1 + w2, h1 + h2)
end

ed.sizeAdd = sizeAdd
local select = select

local function pack(...)
  local n = select("#", ...)
  local t = {}
  for i = 1, n do
    t[i] = select(i, ...)
  end
  return t
end

ed.pack = pack

function ed.gggggm()
  require("gmtools/gm_uilist")
  ed.pushScene(ed.ui.newgm.create())
end

if EDFLAGWIN32 then
  ed.gm = ed.gggggm
end

local function getJson(t, isCheckArray)
  local function checkArrayct(tt)
    for k, v in pairs(tt) do
      if type(k) ~= "number" then
        return false
      elseif k < 1 then
        return false
      elseif 1 < k and tt[k - 1] == nil then
        return false
      end
    end
    return true
  end
  
  local function formatValue(str)
    str = string.gsub(str, "\"", "<quotation>")
    str = string.gsub(str, "\\", "<slash>")
    return str
  end
  
  t = t or {}
  local js = ""
  local isCTT
  if isCheckArray then
    isCTT = checkArrayct(t)
    if isCTT then
      js = "["
    end
  end
  if not isCTT then
    js = "{"
  end
  local index = 0
  for k, v in pairs(t) do
    if 0 < index then
      js = js .. ","
    end
    if type(v) == "table" then
      local cjs = getJson(v, true)
      if isCTT then
        js = js .. cjs
      else
        js = js .. "\"" .. k .. "\"" .. ":" .. cjs
      end
    else
      if not isCTT then
        js = js .. "\"" .. k .. "\"" .. ":"
      end
      if ed.isElementInTable(type(v), {"number", "boolean"}) then
        js = js .. v
      else
        js = js .. "\"" .. formatValue(v) .. "\""
      end
    end
    index = index + 1
  end
  if isCTT then
    js = js .. "]"
  else
    js = js .. "}"
  end
  return js
end

ed.getJson = getJson

local function getMailPoint(data, name)
  local value = 0
  for k, v in pairs(data._points or {}) do
    if v._type == name then
      value = value + v._value
    end
  end
  return value
end

ed.getMailPoint = getMailPoint

local function analyzeItem(item)
  local id = item._id
  local amount = item._amount
  return {id = id, amount = amount}
end

ed.analyzeItem = analyzeItem

local function analyzeTimelyItem(item)
end

ed.analyzeItem = analyzeItem

local function analyzeItem2(item)
  local info = analyzeItem(item)
  return info.id, info.amount
end

ed.analyzeItem2 = analyzeItem2

local function packItem(id, amount)
  return {_id = id, _amount = amount}
end

ed.packItem = packItem

local function analyzeAvatar(id)
  local avatar = ed.bits(id, 0, EDTables.globalConfig.avatarBitNum)
  local avatarFrame = ed.bits(id, EDTables.globalConfig.avatarBitNum, EDTables.globalConfig.avatarBitNum)
  avatarFrame = avatarFrame == 0 and 1 or avatarFrame
  return {avatar = avatar, avatarFrame = avatarFrame}
end

ed.analyzeAvatar = analyzeAvatar

local function packAvatar(avatarFrame, avatar)
  return ed.makebits(EDTables.globalConfig.avatarBitNum, avatarFrame, EDTables.globalConfig.avatarBitNum, avatar)
end

ed.packAvatar = packAvatar

local function copyTable(t)
  local tar = {}
  for k, v in pairs(t) do
    local vt = type(v)
    if vt == "table" then
      tar[k] = copyTable(v)
    else
      tar[k] = v
    end
  end
  return tar
end

ed.copyTable = copyTable

local function copyProto(t)
  local function protoTrans(pt)
    if type(pt) == "table" then
      if pt[".data"] then
        pt = pt[".data"]
      end
      for k, v in pairs(pt) do
        pt[k] = protoTrans(v)
      end
    end
    return pt
  end
  
  local tar = ed.copyTable(t)
  tar = protoTrans(tar)
  return tar
end

ed.copyProto = copyProto

local function heroLevel2Rank(level)
  level = level or 1
  local l = math.max(1, level)
  local r = math.ceil(l / 10)
  return math.min(r, ed.parameter.unit_max_rank)
end

ed.heroLevel2Rank = heroLevel2Rank

local function checkAndOpenURLInSDK(addr)
  local s, l = string.find(addr, "sdk://")
  if s == 1 then
    if EDFLAGIOS or EDFLAGANDROID then
      EDOpenLilithVipPage("https://vip.lilith.com/ingame?source=mail")
    end
    return true
  end
  return false
end

ed.checkAndOpenURLInSDK = checkAndOpenURLInSDK

local function openURL(addr)
  local b, e = string.find(addr, "http")
  if not b then
    if ed.checkAndOpenURLInSDK(addr) then
      return
    end
    ed.showToast(T("\229\156\176\229\157\128\228\184\141\229\144\136\230\179\149\239\188\140\232\175\183\230\163\128\230\159\165\227\128\130"))
    return
  end
  if EDFLAGIOS then
    EDOpenURL(addr)
  elseif EDFLAGANDROID then
    EDAndroidExtra("openURL", addr)
  else
    print("Open URL: ", addr)
  end
end

ed.openURL = openURL

local function openAppStore()
  local areaAddrs = {
    cn = "itms-apps://itunes.apple.com/cn/app/dao-ta-chuan-qi-dong-zuo-ka/id793077082?mt=8",
    tw = "itms-apps://itunes.apple.com/tw/app/%E5%B0%8F%E5%86%B0%E5%86%B0%E5%82%B3%E5%A5%87-%E5%9B%9E%E5%88%B0%E6%9C%80%E5%88%9D/id6478289988",
    en = "itms-apps://itunes.apple.com/us/app/crystal-legends/id6478289988",
    jp = "itms-apps://itunes.apple.com/jp/app/%E8%8B%B1%E9%9B%84%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88/id6478289988",
    ko = "itms-apps://itunes.apple.com/kr/app/%EC%8B%A0%ED%83%91%EC%A0%84%EA%B8%B0/id6478289988"
  }
  if EDFLAGIOS then
    local addr = areaAddrs[EDCurLanguage] or areaAddrs.en
    EDOpenURL(addr)
  end
end

ed.openAppStore = openAppStore

local function openEvaluate()
  print("-->>Open Evaluate")
end

ed.openEvaluate = openEvaluate

function ed.printTable(t, index, tableCache, addition, maxIndex)
  addition = addition or {}
  local func = addition.func or print
  local seperator = "\t"
  local noOutBrac = addition.noOutBrac
  local hideNumberKey = addition.hideNumberKey
  index = index or 1
  t = t or {}
  tableCache = tableCache or {}
  local pre = ""
  for i = 1, index - 1 do
    pre = pre .. seperator
  end
  if noOutBrac and index == 1 then
  else
    func(pre .. "{")
  end
  if not maxIndex or maxIndex >= index then
    for k, v in pairs(t) do
      if type(v) == "table" then
        if ed.isElementInTable(v, tableCache) then
          if hideNumberKey and type(k) == "number" then
            func(pre .. seperator .. "tableCache")
          else
            func(pre .. seperator .. tostring(k) .. " = " .. "tableCache")
          end
        else
          if hideNumberKey and type(k) == "number" then
          else
            func(pre .. seperator .. tostring(k) .. " = ")
          end
          table.insert(tableCache, v)
          ed.printTable(v, index + 1, tableCache, addition, maxIndex)
        end
      else
        local str = pre .. seperator
        if hideNumberKey and type(k) == "number" then
          str = str .. tostring(v)
        else
          str = str .. tostring(k) .. " = " .. tostring(v)
        end
        func(str)
      end
    end
  else
    func(pre .. "type is table")
  end
  if noOutBrac and index == 1 then
  else
    func(pre .. "}")
  end
end

function ed.pt(t, index, tableCache, addition, maxIndex)
  if type(t) ~= "table" then
    print(tostring(t))
    return
  end
  ed.printTable(t, index, tableCache, addition, maxIndex)
end

function ed.writeTable(input, outfile)
  local file = io.open(outfile or "logtt.txt", "w")
  if not file then
    return
  end
  
  local function doWrite(t, index, tableCache)
    index = index or 1
    t = t or {}
    tableCache = tableCache or {}
    local pre = ""
    for i = 1, index - 1 do
      pre = pre .. "\t"
    end
    file:write(pre .. "{")
    file:write("\n")
    for k, v in pairs(t) do
      if type(v) == "table" then
        if ed.isElementInTable(v, tableCache) then
          local key = type(k) == "number" and string.format("[%s]", k) or string.format("[\"%s\"]", tostring(k))
          file:write(pre .. "\t" .. key .. " = " .. "tableCache")
          file:write("\n")
        else
          local key = type(k) == "number" and string.format("[%s]", k) or string.format("[\"%s\"]", tostring(k))
          file:write(pre .. "\t" .. key .. " = ")
          file:write("\n")
          table.insert(tableCache, v)
          doWrite(v, index + 1, tableCache)
        end
      else
        local str = pre .. "\t"
        v = type(v) ~= "number" and type(v) ~= "boolean" and string.gsub(v, "\"", "\\\"") or v
        local key = type(k) == "number" and string.format("[%s]", k) or string.format("[\"%s\"]", tostring(k))
        local value = type(v) == "number" and string.format("%s", v) or string.format("\"%s\"", tostring(v))
        str = str .. key .. " = " .. value .. ","
        file:write(str)
        file:write("\n")
      end
    end
    file:write(pre .. "}" .. (index == 1 and "" or ","))
    file:write("\n")
  end
  
  doWrite(input)
  file:close()
end

function ed.writeTableKey(input, outfile)
  local file = io.open(outfile or "logtt.txt", "w")
  if not file then
    return
  end
  local str = ""
  for k, v in pairs(input) do
    str = str .. k .. "\n"
  end
  file:write(str)
  file:close()
end

local function checkChinese(text)
  text = tostring(text)
  for i = 1, #text do
    local t = string.byte(string.sub(text, i, i))
    if 127 < t then
      return true
    end
  end
  return false
end

ed.checkChinese = checkChinese

local function checkLanguageUpdate(language, definition)
  local function regain(count)
    for i = 1, count do
      EDRemoveSearchPath()
    end
  end
  
  local function checkDiff(versionKey)
    package.loaded["extversion/" .. versionKey] = nil
    require("extversion/" .. versionKey)
    if versionKey ~= "" then
      LoadResources:initAutoUpdateParam(versionKey)
    else
      LoadResources:initAutoUpdateParam()
    end
    return LoadResources:checkUpdate()
  end
  
  language = language or ed.loadLanguage()
  definition = definition or ed.loadDefinition()
  local addPathCount = 0
  local path = "patch"
  if definition ~= "" then
    path = path .. "_" .. definition
  end
  if path ~= "patch" then
    addPathCount = addPathCount + 1
    EDAddSearchPath(path)
  end
  local path = "patch"
  if language ~= "" then
    path = path .. "_" .. language
  end
  if definition ~= "" then
    path = path .. "_" .. definition
  end
  if path ~= "patch" then
    addPathCount = addPathCount + 1
    EDAddSearchPath(path)
  end
  local versionKey = ""
  if language ~= "" then
    versionKey = language
  end
  if definition ~= "" then
    versionKey = versionKey ~= "" and versionKey .. "_" .. definition or definition
  end
  if versionKey ~= "" and checkDiff(versionKey) then
    regain(addPathCount)
    return true
  end
  regain(addPathCount)
  return false
end

ed.checkLanguageUpdate = checkLanguageUpdate

local function setLanguage(language)
  language = string.upper(language)
  local key = string.format("%s %s", "TRANSLATION", language)
  if key ~= resource_config.textconfig_translation_key then
    resource_config.textconfig_translation_key = key
  end
  language = string.lower(language)
  local definition = ed.loadDefinition()
  local lPath = "patch"
  if language ~= "" then
    lPath = lPath .. "_" .. language
  end
  if definition ~= "" then
    lPath = lPath .. "_" .. definition
  end
  local dPath = "patch"
  if definition ~= "" then
    dPath = dPath .. "_" .. definition
  end
  local path = ""
  if lPath ~= "patch" then
    path = path .. lPath .. ","
  end
  if dPath ~= "patch" then
    path = path .. dPath .. ","
  end
  EDLog("-->>set path : " .. path)
  ed.storage.setValue("search_pathes", path)
  ed.saveLanguage(language)
  EDSynchronizeUserDefault()
  textCache = {}
end

ed.setLanguage = setLanguage

local function setDefinition(definition)
  if not definition then
    return
  end
  local language = ed.loadLanguage()
  local lPath = "patch"
  if language ~= "" then
    lPath = lPath .. "_" .. language
  end
  if definition ~= "" then
    lPath = lPath .. "_" .. definition
  end
  local dPath = "patch"
  if definition ~= "" then
    dPath = dPath .. "_" .. definition
  end
  local path = ""
  if lPath ~= "patch" then
    path = path .. lPath .. ","
  end
  if dPath ~= "patch" then
    path = path .. dPath .. ","
  end
  EDLog("-->>set path : " .. path)
  ed.storage.setValue("search_pathes", path)
  ed.saveDefinition(definition)
  EDSynchronizeUserDefault()
end

ed.setDefinition = setDefinition

local function loadTextCache()
  if EDCurLanguage == "cn" then
    return
  end
  require("texttable/texttable")
end

ed.loadTextCache = loadTextCache

local function isRichTextFormat(input)
  local ret = false
  ret = ret or string.find(input, "<sprite ")
  ret = ret or string.find(input, "<lable ")
  return ret
end

local function formatText(text)
  local mode = "<native>"
  if string.find(text, "<native>") then
    return string.gsub(text, mode, "")
  end
  textCache = textCache or {}
  local tc = textCache
  if EDCurLanguage == "cn" then
    text = string.gsub(text, "\\n", "\n")
    text = string.gsub(text, "<key:.*>", "")
    return text
  end
  if not ed.checkChinese(text) then
    return text
  end
  local key = string.match(text, "<key:(.*)>") or "nil"
  text = string.gsub(text, "<key:.*>", "")
  if EDCurLanguage ~= "cn" then
    local tfix = text
    tc[tfix] = tc[tfix] or {}
    if tc[tfix][key] then
      return tc[tfix][key]
    elseif ed.textConfig then
      local trans = ed.textConfig[tfix]
      if trans and trans[key] and trans[key][EDCurLanguage] then
        local trans = trans[key][EDCurLanguage]
        tc[tfix][key] = trans
        return trans
      end
      if resource_config.chinese_character_forbid then
        text = string.gsub(text, "\227\128\130", ".")
      end
    end
  end
  return text
end

ed.formatText = formatText

local function formatString(text, ...)
  text = ed.formatText(text)
  local argAmount = select("#", ...)
  if argAmount == 0 then
    return text
  else
    for i = 1, argAmount do
      local val = select(i, ...)
      if val then
        text = string.gsub(text, "{" .. i .. "}", val)
      end
    end
    return string.format(text, ...)
  end
end

ed.formatString = formatString

function PushTableValue(...)
  local amount = select("#", ...)
  if amount < 2 then
    print("invalid length of args.")
    return
  end
  local value = select(amount, ...)
  local t = _G
  for i = 1, amount - 1 do
    local key = select(i, ...)
    key = tostring(key)
    if i == amount - 1 then
      t[key] = value
    else
      t[key] = t[key] or {}
    end
    t = t[key]
  end
end

local function initSeed()
  math.randomseed(ed.getMillionTime())
  math.random()
  math.random()
  math.random()
end

ed.initSeed = initSeed

function T(text, ...)
  return ed.formatString(text, ...)
end

function M(moduleName, func)
  local function handler(...)
    local function checkModule(name)
      if type(name) == "table" then
        for _, moduleName in ipairs(name) do
          if not checkModule(moduleName) then
            return false
          end
        end
        return true
      else
        return isModuleOpen(name)
      end
    end
    
    if checkModule(moduleName) then
      return func(...)
    else
      return nil
    end
  end
  
  return handler
end

function checkStringValid(text)
  if EDFLAGANDROID then
    local inValid = {}
    for i, v in ipairs(inValid) do
      if string.find(text, v) then
        return false
      end
    end
  end
  return true
end

function ed.dump(t, index, tableCache)
  local traceback = ed.split(debug.traceback("", 2), "\n")
  print("dump from: " .. ed.trim(traceback[3]))
  ed.printTable(t, index, tableCache)
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

ed.trim = trim

function Split(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
    if not nFindLastIndex then
      nSplitArray[nSplitIndex] = trim(string.sub(szFullString, nFindStartIndex, string.len(szFullString)))
      break
    end
    nSplitArray[nSplitIndex] = trim(string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1))
    nFindStartIndex = nFindLastIndex + string.len(szSeparator)
    nSplitIndex = nSplitIndex + 1
  end
  return nSplitArray
end

ed.split = Split

function getNearbyDeviceBT(jsonstr)
  jsonstr = string.sub(jsonstr, 2, -2)
  local devicelist = Split(jsonstr, ",")
  return devicelist
end

ed.getNearbyDeviceBT = getNearbyDeviceBT

function logcut(...)
  EDLog("")
  EDLog("***************************")
  local amount = select("#", ...)
  for i = 1, amount do
    local log = select(i, ...)
    log = tostring(log)
    EDLog(log)
  end
  EDLog("***************************")
end

ed.logcut = logcut

function logerror(...)
  EDLog("")
  EDLog("***************************")
  EDLog("error:")
  local amount = select("#", ...)
  for i = 1, amount do
    local log = select(i, ...)
    log = tostring(log)
    EDLog(log)
  end
  EDLog("***************************")
end

ed.logerror = logerror

function getPlatform()
  local game_server_id1 = tonumber(game_server_id)
  if game_server_id1 < 1000 then
    return "Jailbreak"
  elseif game_server_id1 < 4000 then
    return "iOS"
  elseif game_server_id1 < 8000 then
    return "Android"
  elseif game_server_id1 < 10000 then
    return "Android360"
  elseif 15000 < game_server_id1 and game_server_id1 < 16000 then
    return "WinPhone"
  else
    return "AndroidLongtu"
  end
end

ed.getPlatform = getPlatform

local function getCharLen(str)
  str = string.gsub(str, "[\r\n]", "")
  local _, count = string.gsub(str, "[^\128-\193]", "")
  return count
end

ed.getCharLen = getCharLen

function removeNode(node)
  if not tolua.isnull(node) then
    node:removeFromParentAndCleanup(true)
  end
end

local function insert2Table(target, element)
  if type(element) == "table" then
    for _, v in ipairs(element) do
      table.insert(target, v)
    end
  else
    table.insert(target, element)
  end
end

ed.insert2Table = insert2Table

function ed.createCryptKey(sessionId, len)
  len = len or 16
  math.randomseed(os.time())
  local result = {}
  local sessionStr = sessionId .. ""
  local timeStr = ed.getServerTime() .. ""
  local deviceStr = ed.getDeviceId() .. ""
  local randomStr = tostring(math.random() * 10000000000000000)
  for i = 1, len do
    local tb = {
      nil,
      nil,
      nil,
      nil
    }
    tb[1] = string.byte(sessionStr, i) or 0
    tb[2] = string.byte(timeStr, i) or 0
    tb[3] = string.byte(deviceStr, i) or 0
    tb[4] = string.byte(randomStr, i) or 0
    result[i] = bit.bxor(unpack(tb))
  end
  return string.char(unpack(result))
end

function ed.isMainLand()
  local areas = {
    "PP91",
    "appstore",
    "android",
    "lemon",
    "360",
    "xianmin"
  }
  return ed.isElementInTable(big_area, areas)
end

function ed.randomSort(table)
  if not table then
    return
  end
  math.randomseed(os.time())
  local len = #table
  for i = 1, len do
    local j = math.random(len)
    table[i], table[j] = table[j], table[i]
  end
end

function ed.tabletostring(t)
  local function handler(dst, src, indent)
    indent = indent or ""
    
    local t = type(src)
    if t == "table" then
      dst[#dst + 1] = "{\n"
      do
        local indent = indent .. "\t"
        for k, v in pairs(src) do
          dst[#dst + 1] = indent
          dst[#dst + 1] = "["
          handler(dst, k, indent)
          dst[#dst + 1] = "] = "
          handler(dst, v, indent)
          dst[#dst + 1] = ",\n"
        end
      end
      dst[#dst + 1] = indent
      dst[#dst + 1] = "}"
    elseif t == "string" then
      local escape = string.gsub(src, "%c", function(c)
        return string.format("\\%03o", string.byte(c))
      end)
      dst[#dst + 1] = string.format("%q", escape)
    elseif t == "userdata" or t == "function" then
      dst[#dst + 1] = string.format("%q", tostring(src))
    elseif src == math.huge then
      dst[#dst + 1] = "math.huge"
    elseif src == -math.huge then
      dst[#dst + 1] = "-math.huge"
    else
      dst[#dst + 1] = tostring(src)
    end
  end
  
  local ret = {}
  handler(ret, t or {}, "")
  return table.concat(ret)
end

local function tableEqual(t1, t2)
  if t1 == t2 then
    return true
  end
  if type(t1) ~= "table" or type(t2) ~= "table" then
    return false
  end
  local v2
  for k, v1 in pairs(t1) do
    v2 = t2[k]
    if v1 ~= v2 and not tableEqual(v1, t2[k]) then
      return false
    end
  end
  for k, _ in pairs(t2) do
    if t1[k] == nil then
      return false
    end
  end
  return true
end

ed.tableEqual = tableEqual

function ed.getIPPortFromString(str)
  if not str or str == "" then
    return
  end
  local svrid, ip, port = string.match(str, "(.-)#(.+):(.+)")
  if svrid and ip and port then
    return ip, port, svrid
  end
  local ip, port = string.match(str, "(.+):(.+)")
  return ip, port
end

ed.isOpenBanHeroMode = true

local function copynchar(input, st, n)
  local ret = ""
  for i = 1, n do
    ret = ret .. string.char(string.byte(input, st + i - 1))
  end
  return ret
end

local function ignoreEmj(input)
  local length = string.len(input)
  local ret = ""
  local i = 1
  while length >= i do
    local byte = string.byte(input, i)
    if 252 <= byte then
      ret = ret .. copynchar(input, i, 6)
      i = i + 6
    elseif 248 <= byte then
      ret = ret .. string.sub(input, i, i + 5)
      i = i + 5
    elseif 240 <= byte then
      ret = ret .. "*"
      i = i + 4
    elseif 224 <= byte then
      ret = ret .. copynchar(input, i, 3)
      i = i + 3
    elseif 192 <= byte then
      ret = ret .. copynchar(input, i, 2)
      i = i + 2
    else
      ret = ret .. copynchar(input, i, 1)
      i = i + 1
    end
  end
  return ret
end

ed.ignoreEmj = ignoreEmj

function ed.copyString(str, tips)
  if not str then
    ed.showToast(T("\233\156\128\232\166\129copy\231\154\132\229\173\151\231\172\166\228\184\178\228\184\141\232\131\189\228\184\186\231\169\186\239\188\140\232\175\183\230\163\128\230\159\165\239\188\129\239\188\129\239\188\129"))
    return
  end
  if EDFLAGWIN32 then
    ed.showToast(T("\230\154\130\228\184\141\230\148\175\230\140\129win32\231\154\132copy\239\188\140\232\175\183\230\137\147\229\140\133\230\181\139\232\175\149"))
    return
  end
  if EDCopyStringToSystem then
    EDCopyStringToSystem(str)
  end
  tips = tips or T("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\229\136\135\230\157\191")
  ed.showToast(tips)
end

function ed.getUserUniquenStr()
  local userid = ed.getUserid()
  if game_server_id and userid then
    return game_server_id .. ed.getUserid()
  end
end

function ed.changeSpriteBlend(spr, notpremultiplied)
  local blendFunc1 = ccBlendFunc()
  if notpremultiplied then
    blendFunc1.src = GL_SRC_ALPHA
  else
    blendFunc1.src = GL_ONE
  end
  blendFunc1.dst = GL_ONE_MINUS_SRC_ALPHA
  spr:setBlendFunc(blendFunc1)
end

function ed.reportBattleLog(checkid, stagetype, svrid)
  if ed.engine.battleLog then
    local battleLog = ed.engine.battleLog
    local compressData = CCFileUtils:sharedFileUtils():compressDataQuickLz(battleLog)
    if compressData then
      local battle_msg = ed.upmsg.report_battle()
      battle_msg._id = checkid
      if stagetype then
        battle_msg._type = stagetype
      end
      if svrid then
        battle_msg._svr_id = svrid
      end
      battle_msg._data = compressData
      ed.send(battle_msg, "report_battle", true)
    end
  end
end

function ed.reportCtrBattleLog()
  if not ed.btc_ctrl_notify or ed.btc_ctrl_notify._open_btlog ~= 1 then
    return
  end
  local battleType = ed.btc_ctrl_notify._battle_type
  if ed.engine.battleLog then
    local compressData = CCFileUtils:sharedFileUtils():compressDataQuickLz(ed.engine.battleLog)
    if compressData then
      local btc_ctrl = ed.upmsg.btc_ctrl_report()
      btc_ctrl._battle_type = ed.btc_ctrl_notify._battle_type
      btc_ctrl._btlog_id = ed.btc_ctrl_notify._btlog_id
      btc_ctrl._btlog = compressData
      ed.send(btc_ctrl, "btc_ctrl_report", true)
    end
  end
end

function ed.numFormatStr(num)
  local num = num
  local str = ""
  local yi = math.floor(num / 100000000)
  num = num % 100000000
  local wan = math.floor(num / 10000)
  num = num % 10000
  if 0 < yi then
    str = yi .. "\228\186\191"
  end
  if 0 < wan then
    str = str .. wan .. "\228\184\135"
  end
  if 0 < num then
    str = str .. num
  end
  return str
end

function ed.isTitanById(id)
  return ed.lookupDataTable("Unit", "IsTitan", id)
end

function ed.getRewardUpperStyle(str)
  return ed.ui.configs:getResType(string.lower(str))
end

local ZERO = T("\233\155\182")
local digitMap = {
  T("\228\184\128"),
  T("\228\186\140"),
  T("\228\184\137"),
  T("\229\155\155"),
  T("\228\186\148"),
  T("\229\133\173"),
  T("\228\184\131"),
  T("\229\133\171"),
  T("\228\185\157"),
  T("\229\141\129"),
  [100] = T("\231\153\190"),
  [1000] = T("\229\141\131"),
  [10000] = T("\228\184\135")
}

local function getCNStyleDigits(number, hasPre)
  local w = math.floor(number / 10000)
  if 0 < w then
    return T("%s\228\184\135%s", getCNStyleDigits(w), getCNStyleDigits(number % 10000, true))
  end
  local arr = {}
  
  local function append(digit, suf)
    if digit == 0 then
      if arr[#arr] ~= ZERO then
        table.insert(arr, ZERO)
      end
    else
      table.insert(arr, digitMap[digit])
      table.insert(arr, suf)
    end
  end
  
  local thousand = math.floor(number / 1000)
  append(thousand, digitMap[1000])
  local hundred = math.floor(number / 100) % 10
  append(hundred, digitMap[100])
  local ten = math.floor(number / 10) % 10
  append(ten, digitMap[10])
  local single = number % 10
  append(single, "")
  for i = #arr, 1, -1 do
    local val = arr[i]
    if val ~= ZERO then
      break
    end
    table.remove(arr, i)
  end
  local newArr = {}
  local start = 1
  for i = 1, #arr do
    local val = arr[i]
    if val ~= ZERO then
      break
    end
    start = start + 1
  end
  for i = start, #arr do
    local val = arr[i]
    table.insert(newArr, val)
  end
  if not hasPre then
    arr = newArr
  end
  local s = table.concat(arr, "")
  return s
end

ed.getCNStyleDigits = getCNStyleDigits

function ed.isOnline(onlineTime, offlineTime)
  local serverTime = ed.getServerTime()
  if type(onlineTime) == "string" then
    onlineTime = ed.getTimeByYMDHMS(onlineTime)
    offlineTime = ed.getTimeByYMDHMS(offlineTime)
  end
  if type(onlineTime) ~= "number" then
    return false
  end
  if serverTime > onlineTime then
    if offlineTime and type(offlineTime) == "number" then
      if serverTime < offlineTime then
        return true
      else
        return false
      end
    else
      return true
    end
  end
  return false
end

function ed.formatNumber(num)
  if num <= 100000 then
    return tostring(num)
  elseif 100000 < num then
    local baseW = math.floor(num / 10000)
    return baseW .. T("\228\184\135")
  end
end

function ed.createScale9Sprite(res, capInsets)
  local frame = ed.getSpriteFrame(res)
  local sprite = CCScale9Sprite:createWithSpriteFrame(frame, capInsets)
  return sprite
end

function ed.getFristUpperStyleRewardType(rewardType)
  rewardType = string.lower(rewardType)
  local map = {
    money = "Gold",
    rmb = "Diamond",
    rand_soul = "Item",
    medal = "medal",
    diamond = "Diamond",
    gold = "Coin",
    item = "Item",
    hero = "Hero",
    vitality = "Vitality",
    playerexp = "PlayerEXP",
    crusadepoint = "CrusadePoint",
    arenapoint = "RealArenaCoin",
    guildpoint = "GuildCoin",
    dreampoint = "dreampoint",
    wood = "Wood",
    iron = "Iron",
    crystal = "Crystal",
    gcwpoint = "gcwpoint",
    energy = "Energy",
    guildheroexp = "GuildHeroExp",
    magicstone = "MagicStone",
    FreeMonthCard = "FreeMonthCard"
  }
  return map[rewardType]
end

function ed.getRegionKey()
  return "cn"
end

function ed.getSystemConfig(key, regionKey)
  regionKey = regionKey or ed.getRegionKey()
  local tb = ed.getDataTable("SystemConfig")
  local row = tb[key][regionKey]
  return row["Index Value"]
end

function ed.getRealRewardItemData(data)
  local r = {
    type = data.type,
    id = data.id,
    amount = data.amount
  }
  if r.type == "SimpleChest" then
    r.type = "Item"
    r.id = data.showId
    data.type = "Item"
    data.id = data.showId
  end
  return data
end

function ed.getRewardName(data)
  local rtype = data.type
  if rtype == "SimpleChest" then
    return T("\233\154\143\230\156\186\229\174\157\231\174\177")
  elseif rtype == "MagicStone" then
    return ed.MagicStoneUITool.getMagicStoneNameById(data.id)
  elseif rtype == "Item" then
    local row = ed.getDataTable("equip")[data.id]
    return row.Name
  end
end

function ed.nextFrame(handler)
  local schedule = CCDirector:sharedDirector():getScheduler()
  local entry_id = 0
  entry_id = schedule:scheduleScriptFunc(function(dt)
    schedule:unscheduleScriptEntry(entry_id)
    handler(dt)
  end, 0, false)
end

function ed.afterFrames(nframes, handler)
  local schedule = CCDirector:sharedDirector():getScheduler()
  local entry_id = 0
  local nframe = 0
  entry_id = schedule:scheduleScriptFunc(function(dt)
    nframe = nframe + 1
    if nframe >= nframes then
      schedule:unscheduleScriptEntry(entry_id)
      handler(dt)
    end
  end, 0, false)
end

function ed.bubbleSort(list, comparer)
  local len = #list
  for i = 1, len - 1 do
    for j = 1, len - i do
      if not comparer(list[j], list[j + 1]) then
        local temp = list[j + 1]
        list[j + 1] = list[j]
        list[j] = temp
      end
    end
  end
  return list
end

function ed.defineProperty(t, name, dafaultValue, customGettter, customSetter)
  t[name] = dafaultValue
  local porperty = string.gsub(name, "^%l", string.upper)
  t["get" .. porperty] = customGettter or function(self)
    return self[name]
  end
  t["set" .. porperty] = customSetter or function(self, value)
    self[name] = value
  end
end

function ed.tableIsNilOrEmpty(t)
  return not t or not next(t)
end

function ed.stringIsNilOrEmpty(str)
  return not str or str == ""
end

local mathMax = math.max
local mathMin = math.min

function ed.clamp(value, min, max)
  return mathMin(max, mathMax(value, min))
end

function ed.share(jsonTb)
  local jsonStr = ed.getJson(jsonTb)
  if EDShare then
    EDShare(jsonStr)
  end
end

function ed.screenshot(node, size, filename)
  filename = filename or "share_capture.png"
  size = size or ed.display.winSize
  if EDFLAGANDROID then
    filename = EDGetExternalStoragePath() .. "/" .. filename
  else
    filename = CCFileUtils:sharedFileUtils():getWritablePath() .. "/" .. filename
  end
  local scaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
  CCDirector:sharedDirector():setContentScaleFactor(1)
  local rt = CCRenderTexture:create(size.width, size.height, 0, 35056)
  rt:beginWithClear(0, 0, 0, 0)
  if node.changeFcaBlendfunc then
    local blendFunc1 = ccBlendFunc()
    blendFunc1.src = GL_ONE
    blendFunc1.dst = GL_ONE_MINUS_SRC_ALPHA
    node:changeFcaBlendfunc(blendFunc1)
  end
  node:visit()
  rt:endToLua()
  rt:saveToFile(filename)
  rt:release()
  CCDirector:sharedDirector():setContentScaleFactor(scaleFactor)
  return filename
end

function ed.getScreenshotTexture(node, size)
  node = node or ed.getCurrentScene().scene
  if not node then
    return
  end
  size = size or ed.display.winSize
  local glview = CCDirector:sharedDirector():getOpenGLView()
  local fixWidth = ed.display.frameSize.width / ed.display.scaleFactor
  local fixHeight = ed.display.frameSize.height / ed.display.scaleFactor
  glview:setDesignResolutionSize(fixWidth, fixHeight, 1)
  local rt = CCRenderTexture:create(size.width, size.height, 0, 35056)
  rt:beginWithClear(0, 0, 0, 0)
  node:visit()
  rt:endToLua()
  glview:setDesignResolutionSize(ed.display.fixDesignSize.width, ed.display.fixDesignSize.height, 1)
  local sprite = CCSprite:createWithTexture(rt:getSprite():getTexture())
  ed.setScreenBlur(sprite, 2)
  sprite:setFlipY(true)
  ed.getCurrentScene().scene:addChild(sprite, 999)
  ed.layout.centerInScreen(sprite)
  glview:setDesignResolutionSize(fixWidth, fixHeight, 1)
  rt:release()
  local rt = CCRenderTexture:create(size.width, size.height, 0, 35056)
  rt:beginWithClear(0, 0, 0, 0)
  node:visit()
  rt:endToLua()
  local texture = rt:getSprite():getTexture()
  sprite:removeFromParentAndCleanup(true)
  glview:setDesignResolutionSize(ed.display.fixDesignSize.width, ed.display.fixDesignSize.height, 1)
  rt:release()
  return texture
end

function ed.getRoleKey(prefix)
  return prefix .. "-" .. (ed.player:getUUID() or "") .. "-" .. ed.player:getCreateRoleTime()
end

function ed.cmpSort(keyList)
  local function sortFunc(a, b)
    for index, param in ipairs(keyList) do
      local cmp = param.cmp
      
      if cmp then
        local cmpResult = cmp(a, b)
        if 0 < cmpResult then
          return true
        elseif cmpResult < 0 then
          return false
        end
      else
        local key = param.key
        local reverse = param.reverse
        local getValueFunc = param.getValue
        local va, vb
        if getValueFunc then
          va = getValueFunc(a)
          vb = getValueFunc(b)
        elseif type(a) == "number" and type(b) == "number" then
          va = a
          vb = b
        else
          va = a[key]
          vb = b[key]
        end
        if va ~= vb then
          if reverse then
            return va > vb
          else
            return va < vb
          end
        end
      end
    end
    return false
  end
  
  return sortFunc
end

function ed.createDialogBubble(param)
  local text = param.text or ""
  local scale9Res = param.res or "UI/alpha/1080P/common/dialog_timely_summon_show.png"
  local scale9rectMake = param.scale9rectMake or CCRectMake(0, 0, 1, 1)
  local scale = param.scale or 1
  local fontColor = param.fontColor or ed.toccc3(16777215)
  local fontSize = param.fontSize or 16
  local labelMaxWidth = param.labelMaxWidth
  local labelAlignment = param.labelAlignment or kCCTextAlignmentLeft
  local bubbleDelayTime = param.bubbleDelayTime
  local bubbleFadeOutTime = param.bubbleFadeOutTime
  local labelDelayTime = param.labelDelayTime
  local labelFadeOutTime = param.labelFadeOutTime
  local magin = param.magin or {}
  local fadeOutEndCallBack = param.fadeOutEndCallBack
  local frame = ed.createScale9Sprite(scale9Res, scale9rectMake)
  frame:setScale(scale)
  frame:setAnchorPoint(ccp(0, 0))
  local labelTalk = ed.createLabelTTF(text, fontSize)
  labelTalk:setColor(fontColor)
  labelTalk:setHorizontalAlignment(labelAlignment)
  if labelMaxWidth then
    labelTalk:setDimensions(CCSizeMake(labelMaxWidth, 0))
  end
  local labelSize = labelTalk:getContentSize()
  local frameWidth = labelSize.width + (magin.left or 0) + (magin.right or 0)
  local frameHeight = labelSize.height + (magin.top or 0) + (magin.bottom or 0)
  frame:setContentSize(CCSizeMake(frameWidth, frameHeight))
  labelTalk:setAnchorPoint(ccp(0, 0))
  labelTalk:setPosition(ccp(magin.left or 0, magin.bottom or 0))
  frame:addChild(labelTalk)
  local delayAction, fadeOutAction, removeCall
  if labelDelayTime then
    delayAction = CCDelayTime:create(bubbleDelayTime)
  end
  if bubbleFadeOutTime then
    fadeOutAction = CCFadeOut:create(bubbleFadeOutTime)
  end
  removeCall = CCCallFunc:create(function()
    xpcall(function()
      if fadeOutEndCallBack then
        fadeOutEndCallBack()
      end
    end, EDDebug)
  end)
  if delayAction or fadeOutAction then
    frame:runAction(ed.readaction.create({
      t = "seq",
      delayAction,
      fadeOutAction,
      removeCall
    }))
  end
  local labelDelayAction, labelfadeOutAction
  if labelDelayTime then
    labelDelayAction = CCDelayTime:create(labelDelayTime)
  end
  if labelFadeOutTime then
    labelfadeOutAction = CCFadeOut:create(labelFadeOutTime)
  end
  if labelDelayAction or labelfadeOutAction then
    labelTalk:runAction(ed.readaction.create({
      t = "seq",
      labelDelayAction,
      labelfadeOutAction
    }))
  end
  return frame
end

function ed.drawTestRect(rect, parent, color)
  local drawNode = CCDrawNode:create()
  drawNode:drawRect(ccp(rect.origin.x, rect.origin.y + rect.size.height / 2), rect.size.width, rect.size.height, color or ccc4f(1, 0, 0, 1))
  parent:addChild(drawNode)
  return drawNode
end

function ed.isShowVersionChange()
  if EDSDKType == 302 then
    local platform_channel = EDGetParam("platformChannel") or ""
    if platform_channel == "douyin" then
      return false
    end
    return true
  end
  return false
end

function ed.isShowLilithVIPPage()
  if EDSDKType < 303 then
    return true
  end
  return false
end

function ed.isShowPersonalInformation()
  if EDSDKType < 500 then
    return true
  end
  return false
end

function math.clamp(value, min_val, max_val)
  return math.max(min_val, math.min(max_val, value))
end

function ed.numberToChinese(digit)
  if not ed.isAreaZh() then
    return digit
  end
  local wordDigit = ""
  local digitLength = 0
  local iNum = 0
  local iAddZero = 0
  local digitUnit = {
    "",
    T("\229\141\129"),
    T("\231\153\190"),
    T("\229\141\131"),
    T("\228\184\135"),
    T("\229\141\129"),
    T("\231\153\190"),
    T("\229\141\131"),
    T("\228\186\191"),
    T("\229\141\129"),
    T("\231\153\190"),
    T("\229\141\131"),
    T("\228\184\135"),
    T("\229\141\129"),
    T("\231\153\190"),
    T("\229\141\131")
  }
  local wordFigure = {
    T("\233\155\182"),
    T("\228\184\128"),
    T("\228\186\140"),
    T("\228\184\137"),
    T("\229\155\155"),
    T("\228\186\148"),
    T("\229\133\173"),
    T("\228\184\131"),
    T("\229\133\171"),
    T("\228\185\157")
  }
  if nil == tonumber(digit) then
    return tostring(digit)
  end
  if digit == 0 then
    return T("\233\155\182")
  end
  digitLength = string.len(digit)
  if 10 < digitLength or digitLength == 0 or 0 > tonumber(digit) then
    return tostring(digit)
  end
  for i = 1, digitLength do
    iNum = string.sub(digit, i, i)
    if iNum == 0 and i ~= digitLength then
      iAddZero = iAddZero + 1
    else
      if 0 < iAddZero then
        wordDigit = wordDigit .. wordFigure[1]
      end
      wordDigit = wordDigit .. wordFigure[iNum + 1]
      iAddZero = 0
    end
    if iAddZero < 4 and (0 == (digitLength - i) % 4 or 0 ~= tonumber(iNum)) then
      wordDigit = wordDigit .. digitUnit[digitLength - i + 1]
    end
  end
  
  local function removeZero(num)
    num = tostring(num)
    local szLen = string.len(num)
    local zero_num = 0
    for i = szLen, 1, -3 do
      digit = string.sub(num, i - 2, i)
      if digit == wordFigure[1] then
        zero_num = zero_num + 1
      else
        break
      end
    end
    num = string.sub(num, 1, szLen - zero_num * 3)
    digit = string.sub(num, 1, 6)
    if digit == wordFigure[2] .. digitUnit[2] then
      num = string.sub(num, 4, string.len(num))
    end
    return num
  end
  
  return removeZero(wordDigit)
end

function ed.numberToRoman(number)
  local romanNumList = {
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  }
  local result = ""
  for _, v in ipairs(romanNumList) do
    while number >= v[1] do
      number = number - v[1]
      for str in string.gmatch(v[2], "%w") do
        result = result .. str
      end
    end
  end
  return result
end

function ed.readfile(filename)
  filename = filename or "backdoor.lua"
  local path = "./../localbackdoor/" .. filename
  print("readfile:" .. path)
  local file = io.open(path, "r")
  if not file then
    return
  end
  local content = file:read("*all")
  file:close()
  return content
end

function ed.fixClient()
  print("fixClient")
  local gBundleversion = CCUserDefault:sharedUserDefault():getStringForKey("bundle-version") or ""
  local writablePath = CCFileUtils:sharedFileUtils():getWritablePath()
  local remakePatchPath = writablePath .. "/dgame/remake/"
  EDLog(remakePatchPath)
  local remakePatchPath2 = writablePath .. "/dgame/" .. gBundleversion .. "/remake/"
  EDLog(remakePatchPath2)
  local attPatchPath = writablePath .. "/dgame/att/"
  EDLog(attPatchPath)
  local attPatchPath2 = writablePath .. "/dgame/" .. gBundleversion .. "/att/"
  EDLog(attPatchPath2)
  local attAppendResPath = writablePath .. "/dgame/res/att/"
  EDLog(attAppendResPath)
  local versionFile = "patch/data/version.abc"
  
  local function lfs_clearFolder(path)
    EDLog("lfs begin to clearFolder:" .. path)
    os.cldir(path)
    EDLog("lfs clearFolder:" .. path)
  end
  
  local function removeFolder(path, version)
    if EDFLAGLFS then
      lfs_clearFolder(path)
      return
    end
    EDLog("begin to removeFolder:" .. path)
    if not EDFLAGWIN32 then
      local s = os.execute("rm -rf \"" .. path .. "\"")
      if s ~= 0 and version then
        ok, err = os.remove(path .. versionFile)
        print(ok, err)
      end
    end
    EDLog("removeFolder:" .. path)
  end
  
  local function resetVersionStorage()
    EDLog("resetVersionStorage")
    ed.storage.setValue("latest-version", "")
    ed.storage.setValue("current-version", "")
    ed.storage.setValue("cus_dir_servers", "")
    ed.storage.setValue("patch_res_version", "")
    CCUserDefault:sharedUserDefault():flush()
  end
  
  local function delayRestart()
    ListenTimer(Timer:Once(1), function()
      EDRestartGame()
    end)
  end
  
  ed.showAlertDialog({
    text = T("\231\130\185\229\135\187\231\161\174\229\174\154\239\188\140\230\184\133\233\153\164\230\156\172\229\156\176\231\188\147\229\173\152\230\150\135\228\187\182\229\164\185\239\188\140\233\135\141\229\144\175\230\184\184\230\136\143"),
    buttonText = T("\231\161\174\229\174\154"),
    handler = function()
      resetVersionStorage()
      removeFolder(remakePatchPath, true)
      if gBundleversion ~= "" then
        removeFolder(remakePatchPath2, true)
      end
      delayRestart()
    end
  })
end

function ed.setBlurBg(isBlurBg)
  ed.isBlurBg = isBlurBg
  ed.storage.setValue("-isOpenBlurBg-", isBlurBg and "true" or "false")
end

function ed.refreshBlurBg()
  local _BlurBg = ed.storage.getValue("string", "-isOpenBlurBg-")
  if _BlurBg and _BlurBg == "true" then
    ed.isBlurBg = true
  else
    ed.isBlurBg = false
  end
  print("ed.isBlurBg", ed.isBlurBg)
end

function ed.setDamageNumType(isNewDamageNum)
  ed.isNewDamageNum = isNewDamageNum
  ed.storage.setValue("-isNewDamageNum-", isNewDamageNum and "true" or "false")
end

function ed.getDamageNumType()
  local state = ed.storage.getValue("string", "-isNewDamageNum-")
  if state and state == "true" then
    ed.isNewDamageNum = true
  else
    ed.isNewDamageNum = false
  end
end

function ed.openLegendEquip()
  local state = false
  if ed.isAreaOverSea() then
    state = false
  else
    state = true
  end
  return state
end

function ed.getIntNumLenght(num)
  local length = 0
  while 0 < num do
    num = math.floor(num / 10)
    length = length + 1
  end
  return length
end

function ed.getFrontNum(num, frontLength)
  local length = ed.getIntNumLenght(num)
  local frontNum = math.floor(num / 10 ^ (length - frontLength))
  return frontNum
end

function ed.isOpenConsumeTips()
  return false
end

function ed.isOpenDownloadTips()
  if not EDGetEngineVersion or EDGetEngineVersion() < 15 then
    return false
  end
  if ed.isAreaOverSea() then
    local netType = EDGetNetworkType()
    print("netType", netType)
    if netType and string.find(netType, "WIFI") then
      return false
    end
    return true
  end
  return false
end

function ed.getCurDirServer()
  if not custom_dirserver then
    return dir_servers[1]
  end
  local ret = ed.storage.getString("cus_dir_servers")
  print("ret", ret)
  if ret == nil or ret == "" then
    return dir_servers[1]
  end
  return ret
end

function ed.isSupportFcaSpine()
  if not EDGetEngineVersion or EDGetEngineVersion() < 18 then
    return false
  end
  return true
end

function ed.formatLevel(str)
  if nil == str then
    str = "LV."
  end
  if EDCurLanguage == "en" then
    str = "Lvl "
  elseif EDCurLanguage == "es" then
    if string.match(str, ".") then
      str = "Nv."
    else
      str = "Nv"
    end
  end
  return str
end

function ed.formatFloat(str)
  if EDCurLanguage == "es" then
    str = string.gsub(str, "(%d+)%.(%d+)", "%1,%2")
  end
  return str
end

function ed.formatThousandthPlace(str)
  if EDCurLanguage == "es" then
    str = string.gsub(str, "(%d+)%,(%d+)", "%1 %2")
  end
  return str
end

function ed.transBotName(str)
  if ed.isAreaOverSea() then
    local function transFunc(cnStr, numStr)
      if cnStr and numStr then
        return T(cnStr) .. numStr
      end
      return nil
    end
    
    return string.gsub(str, "^([\128-\255]+)(%d+)$", transFunc) or str
  end
  return str
end

function ed.formatMultiLanMail(str)
  local languageTbl = {}
  for key, v in pairs(ed.lilith_language_code) do
    table.insert(languageTbl, key)
  end
  for _, lan in pairs(languageTbl) do
    local pattern = "<" .. lan .. ">(.-)</" .. lan .. ">"
    if lan == EDCurLanguage then
      str = string.gsub(str, pattern, function(lanContent)
        if lanContent then
          return lanContent
        else
          return ""
        end
      end)
    else
      str = string.gsub(str, pattern, "")
    end
  end
  return str
end

function ed.heroToSkill(name)
  local heroToSkillTbl = {
    [T("\230\178\137\233\187\152")] = {
      zh = "\230\178\137\233\187\152",
      en = "Silence",
      ja = "\230\178\136\233\187\153",
      tw = "\230\178\137\233\187\152",
      ko = "\236\185\168\235\172\181"
    }
  }
  for key, tbl in pairs(heroToSkillTbl) do
    if name == key then
      return tbl[EDCurLanguage] or name
    end
  end
  return name
end

function ed.smoothDamp(current, target, currentVel, smoothTime, maxSpeed, deltaTime)
  deltaTime = deltaTime or 0.016666
  maxSpeed = maxSpeed or 9999999
  local omega = 2 / smoothTime
  local x = omega * deltaTime
  local exp = 1 / (1 + x + 0.48 * x * x + 0.235 * x * x * x)
  local change = current - target
  local originalTo = target
  local maxChange = maxSpeed * smoothTime
  change = ed.clamp(change, -maxChange, maxChange)
  target = current - change
  local temp = (currentVel + omega * change) * deltaTime
  currentVel = (currentVel - omega * temp) * exp
  local newCurrent = target + (change + temp) * exp
  if 0 < originalTo - current == (0 < newCurrent - originalTo) then
    newCurrent = originalTo
    currentVel = 0
  end
  return newCurrent, currentVel
end
