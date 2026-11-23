module("ed.battlehero", package.seeall)
local ed = ed
Dungeon6 = {}

function Dungeon6.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, Dungeon6.Buff_update)
  buff.unremoveable = true
  return buff
end

function Dungeon6.Buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  local level = owner.level
  if buff.dt == dt then
    local bid = 99000061
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff1 = ed.BuffCreate(binfo, owner, owner)
    buff1.shield = level - 30
    buff1.onDamaged = override(buff.onDamaged, Dungeon6.Buff1_onDamaged)
    buff1.cantreduce = true
    owner:addBuff(buff1, owner)
  end
end

function Dungeon6.Buff1_onDamaged(basefunc, self, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
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
      if damage_type == "Holy" or damage_type == "AD" or damage_type == "AP" then
        damage = 1
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

function Dungeon6.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, Dungeon6.createBuff)
  return skill
end

return Dungeon6.init_fieldSkill
