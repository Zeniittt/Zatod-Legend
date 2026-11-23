function needFlip()
  if not ed.IsMultiArena() then
    return false
  end
  local isHost = battle_tick.getHost()
  return not isHost
end

function FlipXPosition(pos)
  return pos
end

function FlipViewXPosition(pos)
  if needFlip() then
    return ccp(ed.display.winSize.width - pos.x, pos.y)
  end
  return pos
end

function FlipXVector(vector)
  if needFlip() then
    return {
      -vector[1],
      vector[2]
    }
  end
  return vector
end

function FlipDirection(direction)
  if needFlip() then
    return -direction
  end
  return direction
end
