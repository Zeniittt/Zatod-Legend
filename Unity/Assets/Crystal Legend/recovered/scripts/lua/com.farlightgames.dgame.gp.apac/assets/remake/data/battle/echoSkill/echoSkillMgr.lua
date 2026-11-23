local class = {}
ed.echoSkillMgr = class

function class.create(param)
  local self = {}
  setmetatable(self, {__index = class})
  self:init(param)
  return self
end

function class:init(param)
  self.echoId = param.echoId
  self.mode = param.mode
  self.magicCaster = nil
  self:initSkillCaster()
  self:initEchoSkill()
end

function class:clear()
  self.echoId = nil
  self.mode = nil
  self.magicCaster = nil
end

function class:initSkillCaster()
  local hpMod = 2
  local skillLevel = {
    100,
    100,
    100,
    100,
    100
  }
  local proto = {
    _tid = 1,
    _level = 100,
    _stars = 5,
    _skill_levels = skillLevel,
    _rank = 16
  }
  local config = {
    hp_mod = hpMod,
    dps_mod = 1,
    size_mod = 1.6
  }
  local caster = ed.UnitCreate(proto, ed.emCampPlayer, config)
  for k, param in pairs(caster) do
    if type(param) == "function" then
      caster[k] = function()
      end
    end
  end
  
  function caster.display()
    return "magic "
  end
  
  caster.what = "magicSystem"
  caster.echoSkillList = {}
  self.magicCaster = caster
end

function class:initEchoSkill()
  local caster = self:getSkillCaster()
  local echoInfo = ed.echoSkillEffect.getEchoInfo(self.echoId)
  local echoSkill = ed.echoSkillEffect.MagicCreate(echoInfo, caster)
  caster.echoSkillList[self.echoId] = echoSkill
  caster.echoSkillList[echoInfo["Echo Name"]] = echoSkill
  local echoSkillTB = ed.getDataTable("EchoSkill")
  for index, subEchoId in ipairs(echoSkillTB[self.echoId]["Subordinate Skill"] or {}) do
    local subEchoInfo = ed.echoSkillEffect.getEchoInfo(subEchoId)
    local subEchoSkill = ed.echoSkillEffect.MagicCreate(subEchoInfo, caster)
    caster.echoSkillList[subEchoId] = subEchoSkill
    caster.echoSkillList[subEchoInfo["Echo Name"]] = subEchoSkill
  end
end

function class:createEchoSkill(echoId)
  local magic = self.magicCaster.echoSkillList[echoId]
  if not magic then
    return
  end
  local echoInfo = ed.echoSkillEffect.getEchoInfo(echoId)
  local magic = ed.echoSkillEffect.MagicCreate(echoInfo, self.magicCaster)
  magic:setEffectStartCallBack(function()
    if ed.run_with_scene then
      FireEvent("echoSkillEffectStart", echoId)
    end
  end)
  magic:setEffectEndCallBack(function()
    if ed.run_with_scene then
      FireEvent("echoSkillEffectEnd", echoId)
    end
  end)
  magic:start()
  ed.engine:addMagic(magic)
end

function class:getEchoId()
  return self.echoId
end

function class:getSkillCaster()
  return self.magicCaster
end
