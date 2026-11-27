function ed.taskCsvId(hid, isArtifact)
  local tb = ed.getDataTable("HeroTask")
  
  local taskLineId = 0
  local awakeTaskLine = 0
  local artifactTaskLine = 0
  for taskLineKey, taskTable in pairs(tb) do
    if taskLineKey ~= "name" then
      for taskId, _ in pairs(taskTable) do
        if taskTable[taskId]["Hero ID"] == hid and taskTable[taskId]["Task Progress Type"] == "EquipItem" then
          if taskTable[taskId]["Is Artifact"] then
            artifactTaskLine = taskLineKey
          else
            awakeTaskLine = taskLineKey
          end
        end
      end
    end
  end
  if isArtifact then
    taskLineId = artifactTaskLine
  else
    taskLineId = awakeTaskLine
  end
  if taskLineId == 0 then
    return 0
  end
  local taskTable = tb[taskLineId][1]
  if taskTable and taskTable["Task Progress Type"] == "EquipItem" then
    local equipTable = taskTable["Task Progress ID"]
    for k, v in pairs(equipTable) do
      if v ~= 0 then
        return v
      end
    end
  else
    return 0
  end
end

function ed.getHeroTaskCsvEquipid(hid)
  return ed.taskCsvId(hid, false)
end

function ed.getHeroSuperTaskCsvEquipid(hid)
  return ed.taskCsvId(hid, true)
end
