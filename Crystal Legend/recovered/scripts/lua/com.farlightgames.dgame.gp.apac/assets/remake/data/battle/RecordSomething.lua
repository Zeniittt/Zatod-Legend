local NewBattleEngine = newclass("g")
ed.NewBattleEngineClass = NewBattleEngine
local Instance = {}
setmetatable(Instance, NewBattleEngine.mt)
ed.NewEngine = Instance

function NewBattleEngine:initMap(params)
end

function NewBattleEngine:startBattle(params)
end

local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(states)
  local sm = {}
  setmetatable(sm, StateMachine)
  sm.states = states
  sm.currentState = nil
  sm.events = {}
  return sm
end

function StateMachine:setState(stateName)
  local state = self.states[stateName]
  if state then
    self.currentState = state
    print("\231\138\182\230\128\129\230\148\185\229\143\152: " .. stateName)
    if state.onEnter then
      state.onEnter()
    end
  else
    print("\230\151\160\230\149\136\231\154\132\231\138\182\230\128\129: " .. stateName)
  end
end

function StateMachine:triggerEvent(eventName)
  local event = self.events[eventName]
  if event then
    event(self)
  else
    print("\230\151\160\230\149\136\231\154\132\228\186\139\228\187\182: " .. eventName)
  end
end

function StateMachine:addEvent(eventName, eventAction)
  self.events[eventName] = eventAction
end

local Idle = {
  onEnter = function()
    print("\232\191\155\229\133\165Idle")
  end,
  onUpdate = function()
    print("\231\138\182\230\128\1291\230\155\180\230\150\176\228\184\173...")
  end
}
local Move = {
  onEnter = function()
    print("\232\191\155\229\133\165\231\138\182\230\128\1292")
  end,
  onUpdate = function()
    print("\231\138\182\230\128\1292\230\155\180\230\150\176\228\184\173...")
  end
}
local State3 = {
  onEnter = function()
    print("\232\191\155\229\133\165\231\138\182\230\128\1293")
  end,
  onUpdate = function()
    print("\231\138\182\230\128\1293\230\155\180\230\150\176\228\184\173...")
  end
}
local sm = StateMachine.new({
  Idle = Idle,
  Move = Move,
  State3 = State3
})
sm:setState("Idle")
sm:addEvent("event1", function(sm)
  if sm.currentState == Idle then
    sm:setState("Move")
  end
end)
sm:addEvent("event2", function(sm)
  if sm.currentState == Move then
    sm:setState("State3")
  end
end)
sm:addEvent("event3", function(sm)
  if sm.currentState == State3 then
    sm:setState("State1")
  end
end)
sm:triggerEvent("event1")
sm:triggerEvent("event2")
sm:triggerEvent("event3")
