module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff14 = {}

function FancyAbyssbuff14.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  owner.canfancy14buff = true
  buff.update = override(buff.update, FancyAbyssbuff14.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff14.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  local fancy14shield
  if owner.level <= 70 then
    fancy14shield = 30000
  end
  if owner.level > 70 and owner.level <= 75 then
    fancy14shield = 40000
  end
  if owner.level > 75 and owner.level <= 80 then
    fancy14shield = 50000
  end
  if owner.level > 80 and owner.level <= 85 then
    fancy14shield = 80000
  end
  if owner.level > 85 and owner.level < 90 then
    fancy14shield = 100000
  end
  if owner.level >= 90 then
    fancy14shield = 125000
  end
  if owner.canfancy14buff == true then
    local bid1 = 6190
    local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
    local buff1 = ed.BuffCreate(binfo1, owner, caster)
    buff1.shield = fancy14shield
    buff1.onDamaged = override(buff1.onDamaged, FancyAbyssbuff14.shield_onDamaged)
    owner.havefancy14buff = owner:addBuff(buff1, caster)
    owner.canfancy14buff = false
  end
end

function FancyAbyssbuff14.shield_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
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
      if damage_type == "Holy" then
        damage = damage * 2
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
      if damage_type == "Holy" then
        return damage
      end
      return 0
    end
  end
  return damage
end

function FancyAbyssbuff14.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff14.createBuff)
  return skill
end

return FancyAbyssbuff14.init_fieldSkill
