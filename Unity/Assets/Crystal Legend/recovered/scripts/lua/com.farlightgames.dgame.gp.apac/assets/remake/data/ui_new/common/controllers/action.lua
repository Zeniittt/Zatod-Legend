Actions = {}
Actions.__index = Actions

function Actions.RepeatLight(light)
  local fadein = CCFadeIn:create(0.8)
  local fadeout = CCFadeOut:create(0.8)
  local sequence = CCSequence:createWithTwoActions(fadein, fadeout)
  light:stopAllActions()
  light:runAction(CCRepeatForever:create(sequence))
end

function Actions.showLight(light)
  local fadein = CCFadeIn:create(0.2)
  local fadeout = CCFadeOut:create(0.2)
  local sequence = CCSequence:createWithTwoActions(fadein, fadeout)
  light:stopAllActions()
  light:runAction(sequence)
end

function Actions.RotateLight(light)
  local r = CCRotateBy:create(5, 360)
  r = CCRepeatForever:create(r)
  light:runAction(r)
end

function Actions.moveNodeTo(node, tpos, callback)
  if not node then
    EDDebug("node is nil !!! ")
  end
  local action = CCMoveTo:create(0.2, tpos)
  action = CCEaseSineOut:create(action)
  local actionEnd = CCCallFunc:create(function()
    if callback then
      callback()
    end
  end)
  node:runAction(ed.readaction.create({
    t = "seq",
    action,
    actionEnd
  }))
end

function Actions.moveNodeToAndScale(node, tpos, scale, callback)
  if not node then
    EDDebug("node is nil !!! ")
  end
  local dt = 0.7
  local action = CCMoveTo:create(dt, tpos)
  action = CCEaseSineOut:create(action)
  local scale = CCScaleTo:create(dt, scale)
  local spawn = CCSpawn:createWithTwoActions(action, scale)
  local actionEnd = CCCallFunc:create(function()
    if callback then
      callback()
    end
  end)
  node:runAction(ed.readaction.create({
    t = "seq",
    spawn,
    actionEnd
  }))
end

function Actions.createHeroAndMoveTo(layer, hid, bpos, epos, callback)
  local node = ed.readhero.createIconByID(hid, {state = "idle"})
  layer:addChild(node.icon, 30)
  node.icon:setPosition(bpos)
  
  local function endcall()
    node.icon:removeFromParentAndCleanup(false)
    if callback then
      callback()
    end
  end
  
  Actions.moveNodeTo(node.icon, epos, endcall)
end

function Actions.createHeroScaleAndMoveTo(layer, node, bpos, epos, bscale, escale, callback)
  layer:addChild(node, 50)
  node:setPosition(bpos)
  node:setScale(bscale)
  
  local function endcall()
    node:removeFromParentAndCleanup(false)
    if callback then
      callback()
    end
  end
  
  Actions.moveNodeToAndScale(node, epos, escale, endcall)
end

function Actions.flyNodeToMakerAndCleanup(sprite, pos, callback, duration)
  local duration = duration or 0.3
  local move = CCMoveTo:create(duration, pos)
  local scale = CCScaleBy:create(duration, 0.5)
  local action = CCSpawn:create(ed.ccArrayMake(move, scale))
  action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
    if callback then
      callback()
    end
    sprite:removeFromParentAndCleanup(true)
  end))
  return action
end
