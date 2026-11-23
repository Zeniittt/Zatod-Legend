local class = {}
ed.rogueSkillMgr = class

function class.create(param)
  local self = {}
  setmetatable(self, {__index = class})
  self:initData(param)
  return self
end

function class:initData(param)
  self.rogueRevelationId = param.rogueRevelationId
  self.rogueBlessInfo = param.rogueBlessInfo
  self.rogueRevelationEnable = param.rogueRevelationEnable
  self.rogueRevelationEnergy = param.rogueRevelationEnergy or 0
  self.blessList = param.blessList or {}
  self.charmList = param.charmList or {}
  self.rogueTechTreeId = param.rogueTechTreeId
  self.rogueTechIdList = param.rogueTechIdList or {}
  self.rogueBlessList = {}
  self.rogueCharmMap = {}
  self.rogueRevelationList = {}
  self.rogueTechList = {}
end

function class:init()
  self:initSkillCaster()
  self:initRogueSkill()
  self:initRogueTech()
end

function class:clear()
  self.magicCaster = nil
  for _, rogueRevelation in pairs(self.rogueRevelationList) do
    rogueRevelation:clear()
  end
  for _, rogueBless in pairs(self.rogueBlessList) do
    rogueBless:clear()
  end
  self.rogueBlessList = {}
  for _, rogueCharm in pairs(self.rogueCharmTab) do
    rogueCharm:clear()
  end
  self.rogueCharmTab = {}
  self.rogueRevelationList = {}
  self.rogueTechList = {}
end

function class:reset()
  self.rogueRevelationEnergy = self:getRogueRevelation().energy
  for _, rogueRevelation in pairs(self.rogueRevelationList) do
    rogueRevelation:reset()
    ed.engine:addMagic(rogueRevelation)
  end
  for _, rogueBless in pairs(self.rogueBlessList) do
    rogueBless:reset()
  end
  for _, rogueCharm in pairs(self.rogueCharmTab) do
    rogueCharm:reset()
  end
  for _, rogueTech in pairs(self.rogueTechList) do
    rogueTech:reset()
  end
  self:clear()
  self:init()
end

function class:initSkillCaster()
  local proto = {
    _tid = 500,
    _level = 1,
    _stars = 1,
    _rank = 1
  }
  local caster = ed.UnitCreate(proto, ed.emCampPlayer)
  caster.rogueRevelationList = self.rogueRevelationList
  caster.rogueBlessList = self.rogueBlessList
  caster.what = "rogueSystem"
  caster.position = {400, 0}
  self.magicCaster = caster
  ed.engine:addStageUint(caster)
end

function class:initRogueSkill()
  local caster = self:getSkillCaster()
  local rogueSkillEnable = self:isRevelationEnable()
  local rogueSkill = ed.rogueSkill.rogueSkillCreate(caster, self.rogueRevelationId, rogueSkillEnable, self.rogueRevelationEnergy)
  local skillInfo = rogueSkill.info
  self.rogueRevelationList[self.rogueRevelationId] = rogueSkill
  self.rogueRevelationList[skillInfo["Destiny Name"]] = rogueSkill
  for index, subrogueRevelationId in pairs(skillInfo["Subordinate Skill"] or {}) do
    local subSkill = ed.rogueSkill.rogueSkillCreate(caster, subrogueRevelationId)
    local subSkillInfo = subSkill.info
    self.rogueRevelationList[subrogueRevelationId] = subSkill
    self.rogueRevelationList[subSkillInfo["Destiny Name"]] = subSkill
    subSkill:init()
  end
  self.rogueBlessList = {}
  for index, blessInfo in ipairs(self.blessList or {}) do
    local blessId = blessInfo._bless
    local level = blessInfo._level
    local bless = ed.rogueBlessBase.blessCreate(blessId, level, rogueSkill)
    self.rogueBlessList[blessId] = bless
  end
  self.rogueCharmTab = {}
  for index, charmInfo in ipairs(self.charmList or {}) do
    local charmId = charmInfo._id
    local exp = charmInfo._exp
    local charm = ed.rogueCharmBase.charmCreate(charmId, exp)
    self.rogueCharmTab[charmId] = charm
  end
  rogueSkill:init()
  ed.engine:addMagic(rogueSkill)
  for blessId, bless in pairs(self.rogueBlessList) do
    bless:init()
  end
  for charmId, charm in pairs(self.rogueCharmTab) do
    charm:init()
  end
end

function class:initRogueTech()
  if not self.rogueTechTreeId then
    return
  end
  self.rogueTechList = {}
  for index, techId in ipairs(self.rogueTechIdList) do
    local rogueTech = ed.rogueTechBase.techCreate(self.rogueTechTreeId, techId)
    self.rogueTechList[techId] = rogueTech
    rogueTech:init()
  end
end

function class:executeRogueSkill(rogueRevelationId)
  local rogueRevelation = self.rogueRevelationList[rogueRevelationId]
  if not rogueRevelation then
    return
  end
  rogueRevelation:setEffectStartCB(function()
    if ed.run_with_scene then
      FireEvent("rogueSkillEffectStart", rogueRevelationId)
    end
  end)
  rogueRevelation:setEffectEndCB(function()
    if ed.run_with_scene then
      FireEvent("rogueSkillEffectEnd", rogueRevelationId)
    end
  end)
  rogueRevelation:start()
end

function class:getDestinyId()
  return self.rogueRevelationId
end

function class:getRogueRevelation()
  local rogueSkill = self.rogueRevelationList[self.rogueRevelationId]
  return rogueSkill
end

function class:getSkillCaster()
  return self.magicCaster
end

function class:getAllBless()
  return self.rogueBlessList
end

function class:getBless(id)
  return self.rogueBlessList[id]
end

function class:getCharm(id)
  return self.rogueCharmTab[id]
end

function class:getBlessAmount(destinyId)
  local amount = 0
  local destinyBlessList
  if destinyId then
    destinyBlessList = ed.getDataTable("RogueDestiny")[destinyId].DestinyBless
  end
  for _, blessInfo in ipairs(self.blessList) do
    local blessId = blessInfo._bless
    if destinyBlessList then
      if ed.isElementInTable(blessId, destinyBlessList) then
        amount = amount + 1
      end
    else
      amount = amount + 1
    end
  end
  return amount
end

function class:isRevelationEnable()
  if self.rogueRevelationEnable then
    return true
  end
  local rogueDestinyCfg = ed.getDataTable("RogueDestiny")[self.rogueRevelationId]
  local destinyBlessList = rogueDestinyCfg.DestinyBless
  local requireBlessAmount = 3
  local satisfyAmount = 0
  for index, blessInfo in ipairs(self.blessList) do
    local blessId = blessInfo._bless
    if ed.isElementInTable(blessId, destinyBlessList) then
      satisfyAmount = satisfyAmount + 1
    end
  end
  if requireBlessAmount <= satisfyAmount then
    return true
  end
  return false
end
