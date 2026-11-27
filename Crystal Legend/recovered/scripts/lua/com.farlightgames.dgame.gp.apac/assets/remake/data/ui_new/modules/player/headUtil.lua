local headUtil = {}
ed.ui.headUtil = headUtil

function headUtil:headIsActived(headId)
  local avatar = ed.getDataTable("Avatar")[headId]
  if not avatar then
    return false
  end
  local rt = avatar["Requirement Type"]
  local rid = avatar["Requirement ID"]
  local rtn = avatar["Requirement Target"]
  if rt == "HaveItem" then
    return rtn <= ed.player:getEquipAmount(rid)
  elseif rt == "HeroRank" then
    local hero = ed.player:getHero(rid)
    return hero and rtn <= hero._rank
  elseif rt == "PlayerLevel" then
    return rtn <= ed.player:getLevel()
  end
  return true
end

function headUtil:headFrameIsActived(frameId)
  local avatar = ed.getDataTable("AvatarFrame")[frameId]
  if not avatar then
    return false
  end
  local rt = avatar["Requirement Type"]
  local rid = avatar["Requirement ID"]
  local rtn = avatar["Requirement Target"]
  if rt == "HaveItem" then
    return rtn <= ed.player:getEquipAmount(rid)
  elseif rt == "PlayerLevel" then
    return rtn <= ed.player:getLevel()
  end
  return true
end
