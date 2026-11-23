function ed.getSkillExpBase(tid)
  local skillGroupTb = ed.getDataTable("SkillGroup")
  
  local info = ed.lookupDataTable("Unit", nil, tid)
  if not info then
    return
  end
  local skills = {}
  for slot, group in pairs(skillGroupTb[tid]) do
    if info["Basic Skill"] ~= group["Skill Group ID"] and group["Subordinate To"] == 0 then
      table.insert(skills, group)
    end
  end
  table.sort(skills, function(a, b)
    return a.Slot < b.Slot
  end)
  return skills
end

function ed.getSkillSlotId(tid, skillId)
  local tb = ed.getDataTable("SkillGroup")
  for slot, group in pairs(tb[tid]) do
    if skillId == group["Skill Group ID"] then
      return slot
    end
  end
end

function ed.getSkillWithID(tid, skillId)
  local tb = ed.getDataTable("SkillGroup")
  for slot, group in pairs(tb[tid]) do
    if skillId == group["Skill Group ID"] then
      return group
    end
  end
end

function ed.getShowOnCardSkills(tid)
  local tb = ed.getDataTable("SkillGroup")
  local info = ed.lookupDataTable("Unit", nil, tid)
  if not info then
    return
  end
  local skills = {}
  for slot, group in pairs(tb[tid]) do
    local level = group["Init Level"]
    if info["Basic Skill"] ~= group["Skill Group ID"] and not group["Hide On Card"] then
      table.insert(skills, group)
    end
  end
  table.sort(skills, function(a, b)
    return a.Slot < b.Slot
  end)
  return skills
end

function ed.getAllSkills(tid)
  local tb = ed.getDataTable("SkillGroup")
  return tb[tid]
end

function ed.getInitSkillLevels(tid)
  local tb = ed.getDataTable("SkillGroup")
  local levels = {}
  for slot, group in pairs(tb[tid]) do
    local level = group["Init Level"]
    levels[slot] = level
  end
  return levels
end
