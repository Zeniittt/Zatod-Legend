local class = newclass("g")
ed.rogueEventChoiceEnableHandle = class

function class.create(mgr)
  local self = {}
  setmetatable(self, {__index = class})
  setmetatable(class, {__index = mgr})
  self:init()
  return self
end

function class:getHandleFunc(type)
  return self.eventChoiceEnableHandler[type]
end

function class:init()
  self.eventChoiceEnableHandler = {
    ["Pearl Single Store"] = self.pearlSingleStore,
    ["Pearl Global Store"] = self.pearlGlobalStore,
    ["Appoint Bless"] = self.appointBless,
    ["Retry Times Cut"] = self.retryTimesCut,
    ["Pearl Cut"] = self.pearlCut,
    ["Pearl Cut All"] = self.pearlCutAll,
    ["Bless Enhance"] = self.blessEnhance,
    ["Blue Bless Enhance"] = self.blueBlessEnhance,
    ["Purple Bless Enhance"] = self.purpleBlessEnhance,
    ["Yellow Bless Enhance"] = self.yellowBlessEnhance,
    ["Low Bless Cut"] = self.lowBlessCut,
    ["Total Bless Cut"] = self.totalBlessCut,
    ["Hero Reborn"] = self.heroReborn,
    ["Kill Hero"] = self.killHero
  }
end

function class:pearlSingleStore(param)
  local amount = param[1] or 0
  if amount > self:getPearl() then
    return false
  end
  return true
end

function class:pearlGlobalStore(param)
  local amount = param[1] or 0
  if amount > self:getPearl() then
    return false
  end
  return true
end

function class:appointBless(param)
  return true
end

function class:retryTimesCut(param)
  local cutTimes = param[1]
  local retryTimes = self:getRetryTimes()
  if cutTimes > retryTimes then
    return false
  end
  return true
end

function class:pearlCut(param)
  local cutPearlAmount = param[1] or 0
  if cutPearlAmount > self:getPearl() then
    return false
  end
  return true
end

function class:pearlCutAll()
  if self:getPearl() <= 0 then
    return false
  end
  return true
end

function class:blessEnhance(param)
  local enhanceAmount = param[1]
  local curChapter = self:getCurChapter()
  local blessList = curChapter._bless_list or {}
  if #blessList == 0 then
    return false, T("\229\189\147\229\137\141\230\156\170\230\139\165\230\156\137\231\165\157\231\166\143")
  end
  for _, rogueBless in ipairs(blessList) do
    local blessId = rogueBless._bless
    local level = rogueBless._level
    local canBeReinforced = ed.getDataTable("RogueBless")[blessId]["Can Be Reinforced"]
    if canBeReinforced and level == 1 then
      return true
    end
  end
  return false, T("\230\137\128\230\140\129\230\156\137\231\165\157\231\166\143\229\183\178\229\133\168\233\131\168\229\188\186\229\140\150")
end

function class:blueBlessEnhance(param)
  local enhanceAmount = param[1]
  local curChapter = self:getCurChapter()
  local blessList = curChapter._bless_list or {}
  if #blessList == 0 then
    return false, T("\229\189\147\229\137\141\230\156\170\230\139\165\230\156\137\231\165\157\231\166\143")
  end
  for _, rogueBless in ipairs(blessList) do
    local blessId = rogueBless._bless
    local level = rogueBless._level
    local blessCfg = ed.getDataTable("RogueBless")[blessId]
    local canBeReinforced = blessCfg["Can Be Reinforced"]
    local rarity = blessCfg.Rarity
    if canBeReinforced and level == 1 and rarity == 1 then
      return true
    end
  end
  return false, T("\230\137\128\230\140\129\230\156\137\231\165\157\231\166\143\229\183\178\229\133\168\233\131\168\229\188\186\229\140\150")
end

function class:purpleBlessEnhance(param)
  local enhanceAmount = param[1]
  local curChapter = self:getCurChapter()
  local blessList = curChapter._bless_list or {}
  if #blessList == 0 then
    return false, T("\229\189\147\229\137\141\230\156\170\230\139\165\230\156\137\231\165\157\231\166\143")
  end
  for _, rogueBless in ipairs(blessList) do
    local blessId = rogueBless._bless
    local level = rogueBless._level
    local blessCfg = ed.getDataTable("RogueBless")[blessId]
    local canBeReinforced = blessCfg["Can Be Reinforced"]
    local rarity = blessCfg.Rarity
    if canBeReinforced and level == 1 and rarity == 2 then
      return true
    end
  end
  return false, T("\230\137\128\230\140\129\230\156\137\231\165\157\231\166\143\229\183\178\229\133\168\233\131\168\229\188\186\229\140\150")
end

function class:yellowBlessEnhance(param)
  local enhanceAmount = param[1]
  local curChapter = self:getCurChapter()
  local blessList = curChapter._bless_list or {}
  if #blessList == 0 then
    return false, T("\229\189\147\229\137\141\230\156\170\230\139\165\230\156\137\231\165\157\231\166\143")
  end
  for _, rogueBless in ipairs(blessList) do
    local blessId = rogueBless._bless
    local level = rogueBless._level
    local blessCfg = ed.getDataTable("RogueBless")[blessId]
    local canBeReinforced = blessCfg["Can Be Reinforced"]
    local rarity = blessCfg.Rarity
    if canBeReinforced and level == 1 and rarity == 3 then
      return true
    end
  end
  return false, T("\230\137\128\230\140\129\230\156\137\231\165\157\231\166\143\229\183\178\229\133\168\233\131\168\229\188\186\229\140\150")
end

function class:lowBlessCut(param)
  local curChapter = self:getCurChapter()
  local blessList = curChapter._bless_list or {}
  if #blessList == 0 then
    return false, T("\229\189\147\229\137\141\230\156\170\230\139\165\230\156\137\231\165\157\231\166\143")
  end
  return true
end

function class:totalBlessCut(param)
  local curChapter = self:getCurChapter()
  local blessList = curChapter._bless_list or {}
  if #blessList == 0 then
    return false, T("\229\189\147\229\137\141\230\156\170\230\139\165\230\156\137\231\165\157\231\166\143")
  end
  return true
end

function class:heroReborn(param)
  local heroList = self:getAllHeroInfo()
  local hasHeroDead = false
  for index, heroInfo in ipairs(heroList) do
    if heroInfo._hp_perc <= 0 then
      hasHeroDead = true
    end
  end
  if hasHeroDead then
    return true
  else
    return false
  end
end

function class:killHero(param)
  local heroList = self:getAllHeroInfo()
  local alive = 0
  for index, heroInfo in ipairs(heroList) do
    if 0 < heroInfo._hp_perc then
      alive = alive + 1
    end
  end
  return 2 <= alive
end
