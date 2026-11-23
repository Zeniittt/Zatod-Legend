local class = newclass("g")
ed.legendEquip = class

function class.create(proto, camp, owner)
  local self = {
    proto = proto,
    owner = owner,
    camp = camp
  }
  setmetatable(self, {__index = class})
  self:init()
  return self
end

ed.legendEquipCreate = class.create

function class:initScript()
  if self.info["Script Name"] then
    local init_func = require(self.info["Script Name"])
    self = init_func(self)
  end
end

function class:init()
  self.info = self:getSkillInfo()
  self:initSkill()
  self:initScript()
end

function class:getSkillInfo()
  local equipCfg = ed.getDataTable("LegendEquip")[self.proto._type_id]
  local equip_info = setmetatable({}, {__index = equipCfg})
  return equip_info
end

function class:initSkill()
  self.skills = {}
  self.skill_list = {}
  local typeId = self.proto._type_id
  for star = 1, self.proto._star do
    for rank = 0, self.proto._rank do
      if not ed.getDataTable("LegendEquipEnhance")[typeId] then
        break
      end
      if not ed.getDataTable("LegendEquipEnhance")[typeId][star] then
        break
      end
      if not ed.getDataTable("LegendEquipEnhance")[typeId][star][rank] then
        break
      end
      local equipEnhanceCfg = ed.getDataTable("LegendEquipEnhance")[typeId][star][rank]
      for skillIndex = 1, 10 do
        local skillId = equipEnhanceCfg["Skill ID " .. skillIndex]
        if not skillId or skillId == 0 then
          break
        end
        local skillInfo = ed.getDataTable("LegendEquipSkill")[skillId]
        local equipSkill = ed.legendEquipSkillBase.create(self.proto, self.owner, skillId)
        self.skills[skillInfo["Skill Name"]] = equipSkill
        table.insert(self.skill_list, equipSkill)
      end
    end
  end
end

function class:castSkill(skill, target)
  local skillName = skill.info["Skill Name"]
  if not self.skills[skillName] then
    return
  end
  skill:start(target)
end

function class:collectSkillHit(deliverer, skill, receiver)
end

function class:update(dt)
  for index, equipSkill in ipairs(self.skill_list) do
    equipSkill:update(dt)
  end
end

function class:reset()
  for _, equipSkill in ipairs(self.skill_list) do
    equipSkill:reset()
  end
end
