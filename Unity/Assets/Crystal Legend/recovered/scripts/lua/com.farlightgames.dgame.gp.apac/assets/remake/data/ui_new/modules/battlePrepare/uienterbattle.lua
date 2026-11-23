module("ed.battleprepare", package.seeall)
EnterBattle = {}
EnterBattle.__index = EnterBattle

function EnterBattle:create(uiview, param)
  local obj = {}
  setmetatable(obj, self)
  obj:init(uiview, param)
  return obj
end

function EnterBattle:init(uiview, param)
  local param = param or {}
  self.layer = CCLayer:create()
  self.ui = {}
  self.uiview = uiview
  self.type = param.type or "normal"
  local readNode = ed.readnode.create(self.layer, self.ui)
  readNode:addNode(self:getUiInfo())
  self:registerTouchEvent()
end

function EnterBattle:release()
  self.layer:removeFromParentAndCleanup(true)
  self.layer = nil
  self.ui = {}
end

function EnterBattle:getView()
  return self.layer
end

function EnterBattle:setVisible(visible)
  self.layer:setVisible(visible)
end

function EnterBattle:isVisible()
  return self.layer:isVisible()
end

function EnterBattle:registerTouchEvent()
  local clickTimePoint
  WaitEvent("mainTouch", function(event, x, y)
    if not self:isVisible() then
      return
    end
    local button = self.ui.go
    local press = self.ui.go_press
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        press:setVisible(true)
      end
    elseif event == "ended" then
      press:setVisible(false)
      if ed.containsPoint(button, x, y) then
        if not self.uiview.pool:isLoadEnd() then
          return
        end
        if clickTimePoint then
          if ed.getMillionTime() - clickTimePoint > 0.5 then
            SendEvent("enterBattle")
            clickTimePoint = ed.getMillionTime()
          end
        else
          SendEvent("enterBattle")
          clickTimePoint = ed.getMillionTime()
        end
      end
    end
  end)
end

function EnterBattle:setPosition(pos)
  self.ui.go:setPosition(pos)
end

function EnterBattle:getUiInfo()
  local go = "UI/alpha/HVGA/prepare_go_battle.png"
  local go_press = "UI/alpha/HVGA/prepare_go_battle_press.png"
  if self.type == "firstTeam" then
    go = "UI/alpha/HVGA/nextstagebtn.png"
    go_press = "UI/alpha/HVGA/nextstagebtn-disabled.png"
  end
  local ui_info = {
    {
      t = "Sprite",
      base = {name = "go", res = go},
      layout = {
        position = ccp(710, 62)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "go_press",
        res = go_press,
        parent = "go"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    }
  }
  return ui_info
end
