package.path = package.path .. ";./lib/?.lua;./lua/?.lua;"
require("edebug")
require("tools")
require("stringbuffer")
CCNode = {}
CCSprite = {}
ed.HpBar = {}
EDLog = log

function ccp(x, y)
  return {x = x, y = y}
end

require("resource_manager")
require("datatable")
require("battle/edp")
require("battle/battle_engine")
require("gamedatatables/gamedatatables")
require("gamedatatables/battlemetatable")
require("battle/battle_check")
require("pb")
require("gamedatatables/gamedatatables")
require("gamedatatables/battlemetatable")
require("gamedatatables/herotasktable")
require("gamedatatables/skillgrouptable")
require("gamedatatables/challengetable")
require("gamedatatables/unittable")
require("ui/awake/runetools")
xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  do_battle_log = true
  if not arg[1] then
    print("please enter battle mode!!")
    return
  end
  local msg, mode = battle_check.getMsg(arg[1])
  battle_check.enterBattle(msg, mode)
  ed.engine.running = true
  while ed.engine.running do
    ed.engine:tick()
  end
  battle_check.endBattle()
end, EDDebug)
