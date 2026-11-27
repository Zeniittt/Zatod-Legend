local class = newclass("g")
ed.tutorialcheck = class
local tutorial = ed.tutorial
setfenv(1, class)

function StageFailedGuide()
  if ed.player:getStageStar(55) > 0 then
    return false
  end
  if (tutorial.getRecord("SFSelectStage") or 0) >= ed.parameter.satge_failed_guide_times then
    return false
  end
  return true
end

function SFStageFailedExit()
  if not StageFailedGuide() then
    return false
  end
  if not ed.readhero.canAdvanceEquip() then
    return false
  end
  if (tutorial.getRecord("SFStageFailedExit") or 0) >= 3 then
    return false
  end
  return true
end

function SFOpenShortcut()
  if not StageFailedGuide() then
    return false
  end
  if (tutorial.getRecord("SFStageFailedExit") or 0) <= (tutorial.getRecord("SFOpenShortcut") or 0) then
    return false
  end
  if (tutorial.getRecord("SFOpenShortcut") or 0) > (tutorial.getRecord("SFSelectHero") or 0) then
    return false
  end
  return true
end

function SFOpenHeroPackage()
  if not StageFailedGuide() then
    return false
  end
  if (tutorial.getRecord("SFStageFailedExit") or 0) <= (tutorial.getRecord("SFOpenHeroPackage") or 0) then
    return false
  end
  if (tutorial.getRecord("SFOpenHeroPackage") or 0) > (tutorial.getRecord("SFSelectHero") or 0) then
    return false
  end
  return true
end

function SFSelectHero()
  if not StageFailedGuide() then
    return false
  end
  if (tutorial.getRecord("SFOpenHeroPackage") or 0) <= (tutorial.getRecord("SFSelectHero") or 0) then
    return false
  end
  if (tutorial.getRecord("SFSelectHero") or 0) > (tutorial.getRecord("SFSelectEquip") or 0) then
    return false
  end
  return true
end

function SFSelectEquip()
  if not StageFailedGuide() then
    return false
  end
  if (tutorial.getRecord("SFSelectHero") or 0) <= (tutorial.getRecord("SFSelectEquip") or 0) then
    return false
  end
  if (tutorial.getRecord("SFSelectEquip") or 0) > (tutorial.getRecord("SFCheckDrop") or 0) then
    return false
  end
  return true
end

function SFCheckDrop()
  if not StageFailedGuide() then
    return false
  end
  if (tutorial.getRecord("SFSelectEquip") or 0) <= (tutorial.getRecord("SFCheckDrop") or 0) then
    return false
  end
  if (tutorial.getRecord("SFCheckDrop") or 0) > (tutorial.getRecord("SFSelectStage") or 0) then
    return false
  end
  return true
end

function SFSelectStage()
  if not StageFailedGuide() then
    return false
  end
  if (tutorial.getRecord("SFCheckDrop") or 0) <= (tutorial.getRecord("SFSelectStage") or 0) then
    return false
  end
  return true
end
