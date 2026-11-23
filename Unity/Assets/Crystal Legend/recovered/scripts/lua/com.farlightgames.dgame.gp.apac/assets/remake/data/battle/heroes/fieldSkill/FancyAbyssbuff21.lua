module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff21 = {}

function FancyAbyssbuff21.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.cantreduce = true
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff21.Buff_onDamaged)
  local stageid = ed.engine.stage_info and ed.engine.stage_info["Stage ID"] or 0
  local difficulty = stageid - 12122000
  local waveId = ed.engine.wave_id or 1
  if difficulty then
    if difficulty <= 10 then
      if waveId == 1 then
        buff.shield = 6
      else
        buff.shield = 10
      end
    end
    if 10 < difficulty and difficulty <= 15 then
      if waveId == 1 then
        buff.shield = 8
      else
        buff.shield = difficulty
      end
    end
    if 15 < difficulty and difficulty <= 18 then
      buff.shield = 10
      if waveId == 3 then
        buff.shield = 80
      end
    end
    if 18 < difficulty then
      buff.shield = 12
      if waveId == 2 then
        buff.shield = 60
      end
      if waveId == 3 then
        buff.shield = 100
      end
    end
  end
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff21.Buff_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = self.info
  local owner = self.owner
  local skill = skill
  field = field and field or "hp"
  if not self.shield then
    return damage
  elseif not self.info["No Pass"] == true and (skill and skill.info["Ignore Shield"] == true or damageinfo and damageinfo["Ignore Shield"]) then
    return damage
  else
    local block = false
    local stype = info["Shield Type"]
    if stype == "mp" then
      if field == "mp" then
        self.shield = self.shield - damage
        if self.shield < 0 then
          self.owner:removeBuff(self)
          return -self.shield
        end
        if owner.actor then
          local color = owner.camp == ed.emCampPlayer and "blue" or "red"
          ed.PopupCreate("immune", color, owner.actor, nil, "text")
        end
        return 0
      else
        return damage
      end
    elseif stype == damage_type or stype == "all" then
      if damage_type == "Holy" or damage_type == "AD" then
        damage = 1
      end
      if damage_type == "AP" then
        damage = 2
      end
      self.shield = self.shield - damage
      if self.shield < 0 then
        self.owner:removeBuff(self)
        return -self.shield
      end
      if owner.actor then
        local color = owner.camp == ed.emCampPlayer and "blue" or "red"
        local str = {
          AD = "physical_immune",
          AP = "magic_immune",
          all = "immune"
        }
        ed.PopupCreate(str[stype] or "immune", color, owner.actor, nil, "text")
      end
      return 0
    end
  end
  return damage
end

function FancyAbyssbuff21.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff21.createBuff)
  return skill
end

return FancyAbyssbuff21.init_fieldSkill
