local tools = {}
ed.CupArenaUITool = tools
ed.CupArenaUITool.title_red = ccc3(136, 43, 9)
ed.CupArenaUITool.title_orange = ccc3(229, 140, 72)
ed.CupArenaUITool.title_brown = ccc3(119, 16, 19)
ed.CupArenaUITool.button_red = ccc3(146, 41, 20)

function tools.getServerName(info)
  if info._show_server_id == 0 then
    return "\228\184\141\229\143\175\232\167\129"
  end
  local platShift = {
    ["iOS\232\182\138\231\139\177"] = "\232\182\138\231\139\177",
    iOS = "IOS",
    ["\229\174\137\229\141\147\230\183\183\230\156\141"] = "\229\174\137\230\183\183",
    ["360\228\184\147\230\156\141"] = "360",
    ["\233\190\153\229\155\190\228\184\147\230\156\141"] = "\233\190\153\229\155\190",
    ["\229\174\137\229\141\147\229\174\152\230\156\141"] = "\229\174\152\230\156\141"
  }
  local plat = platShift[info._plat] or info._plat
  local showServerid = info._show_server_id
  local serverName = plat .. "-" .. showServerid .. "\229\140\186"
  return serverName
end

function tools.createRankSprite(rank)
  local ranking
  if rank == 1 then
    ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_1st.png")
  elseif rank == 2 then
    ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_2nd.png")
  elseif rank == 3 then
    ranking = ed.createSprite("UI/alpha/HVGA/pvp/pvp_rank_3rd.png")
  else
    ranking = ed.getNumberNode({text = rank, folder = "big_pvp"}).node
  end
  return ranking
end

function tools.createYLine(startY, startHeight, targetY, posX, isWin, parent, lineArr)
  local lineRes = isWin and "UI/alpha/1080P/cuparena/knockout/course/course_line_1.png" or "UI/alpha/1080P/cuparena/knockout/course/course_line_3.png"
  local zOrder = isWin and -1 or -2
  local dir = startY < targetY and 1 or -1
  local y = startY + startHeight * 0.5 * dir
  repeat
    local lineSprite = ed.createSprite(lineRes)
    lineSprite:setRotation(-90)
    lineSprite:setAnchorPoint(ccp(0 < dir and 0 or 1, 0.5))
    parent:addChild(lineSprite, zOrder)
    table.insert(lineArr, lineSprite)
    lineSprite:setPosition(ccp(posX, y))
    y = y + lineSprite:getContentSize().width * dir
    if 0 < dir then
      if targetY < y then
        break
      end
    elseif targetY > y then
      break
    end
  until false
end

function tools.createXLine(startX, startWidth, targetX, posY, isWin, parent, lineArr)
  local lineRes = isWin and "UI/alpha/1080P/cuparena/knockout/course/course_line_1.png" or "UI/alpha/1080P/cuparena/knockout/course/course_line_3.png"
  local zOrder = isWin and -1 or -2
  local dir = startX < targetX and 1 or -1
  local x = startX + startWidth * 0.5 * dir
  repeat
    local lineSprite = ed.createSprite(lineRes)
    lineSprite:setAnchorPoint(ccp(0 < dir and 0 or 1, 0.5))
    parent:addChild(lineSprite, zOrder)
    table.insert(lineArr, lineSprite)
    lineSprite:setPosition(ccp(x, posY))
    x = x + lineSprite:getContentSize().width * dir
    if 0 < dir then
      if targetX < x then
        break
      end
    elseif targetX > x then
      break
    end
  until false
end

function tools.calcuRotation(startPos, targetPos)
  if startPos.x < targetPos.x and startPos.y < targetPos.y then
    return 180
  elseif startPos.x < targetPos.x and startPos.y > targetPos.y then
    return 90
  elseif startPos.x > targetPos.x and startPos.y < targetPos.y then
    return 270
  elseif startPos.x > targetPos.x and startPos.y > targetPos.y then
    return 0
  end
end

local MatchNameTab = {
  [1001] = T("128\232\191\15564"),
  [1002] = T("128\232\191\15564"),
  [1003] = T("128\232\191\15564"),
  [1004] = T("128\232\191\15564"),
  [1005] = T("128\232\191\15564"),
  [1006] = T("128\232\191\15564"),
  [1007] = T("128\232\191\15564"),
  [1008] = T("128\232\191\15564"),
  [1009] = T("64\232\191\15532"),
  [1010] = T("64\232\191\15532"),
  [1011] = T("64\232\191\15532"),
  [1012] = T("64\232\191\15532"),
  [1013] = T("32\232\191\15516"),
  [1014] = T("32\232\191\15516"),
  [1015] = T("16\232\191\1558"),
  [2001] = T("8\232\191\1554"),
  [2002] = T("8\232\191\1554"),
  [2003] = T("8\232\191\1554"),
  [2004] = T("8\232\191\1554"),
  [2005] = T("4\232\191\1552"),
  [2006] = T("4\232\191\1552"),
  [2007] = T("\229\134\179\232\181\155")
}

function tools.getMatchName(pos)
  return MatchNameTab[pos] or ""
end

function tools.getRankName(rank)
  if nil == rank then
    rank = 1
  end
  if rank <= 1 then
    return T("\229\134\160\229\134\155")
  elseif rank <= 2 then
    return T("\228\186\154\229\134\155")
  elseif rank <= 4 then
    return T("4\229\188\186")
  elseif rank <= 8 then
    return T("8\229\188\186")
  elseif rank <= 16 then
    return T("16\229\188\186")
  elseif rank <= 32 then
    return T("32\229\188\186")
  elseif rank <= 64 then
    return T("64\229\188\186")
  elseif rank <= 128 then
    return T("128\229\188\186")
  else
    return T("n\229\188\186")
  end
end
