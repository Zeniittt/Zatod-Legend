module("ed.battleprepare", package.seeall)
Action = {}
Action.__index = Action

function Action:showLight(light)
  Actions.showLight(light)
end

function Action:moveNodeTo(node, tpos, callback)
  Actions.moveNodeTo(node, tpos, callback)
end

function Action:createHeroAndMoveTo(layer, hid, bpos, epos, callback)
  Actions.createHeroAndMoveTo(layer, hid, bpos, epos, callback)
end
