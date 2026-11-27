function ed.isChallengeStage(stageId)
  local tb = ed.getDataTable("Challenge")
  
  if tb[stageId] then
    return true
  end
  return false
end

function ed.getChallengeType(stageId)
  local tb = ed.getDataTable("Challenge")
  if tb[stageId] then
    return tb[stageId].Type
  end
  return nil
end

function ed.getChallengeParam(stageId, index)
  local tb = ed.getDataTable("Challenge")
  if tb[stageId] then
    return tb[stageId]["Limit" .. index]
  end
  return nil
end

function ed.getChallengeHero(stageId)
  local tb = ed.getDataTable("Challenge")
  local type = ed.getChallengeType(stageId)
  if type and (type == "Guardian" or type == "StealKill") then
    return tb[stageId].Limit1
  end
  return nil
end

function ed.getChallengeName(stageId)
  local tb = ed.getDataTable("Challenge")
  if tb[stageId] then
    return tb[stageId].Name
  end
end

function ed.getChallengeIcon(stageId)
  local tb = ed.getDataTable("Challenge")
  if tb[stageId] then
    return tb[stageId]["Challenge Icon"]
  end
end

function ed.isLegendaryChallenge(stageId)
  local tb = ed.getDataTable("Challenge")
  if tb[stageId] then
    return tb[stageId].Type == "Legendary"
  end
end

function ed.isGuardAndKillMode(stageId)
  local stageType = ed.getChallengeType(stageId)
  if ed.isElementInTable(stageType, {"Guardian", "StealKill"}) then
    return true
  end
  return false
end
