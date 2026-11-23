module("ed.battleprepare", package.seeall)
Return = {}
Return.__index = Return
local lsr = ed.ui.battlepreparepeakarenalsr.create()

function Return:create(uiview)
  local obj = {}
  setmetatable(obj, self)
  obj:init(uiview)
  return obj
end

function Return:init(uiview)
  self.uiview = uiview
  self.layer = CCLayer:create()
  self.ui = {}
  local readNode = ed.readnode.create(self.layer, self.ui)
  readNode:addNode(self:getUiInfo())
  self:registerTouchEvent()
end

function Return:release()
  self.layer:removeFromParentAndCleanup(true)
  self.layer = nil
  self.ui = {}
end

function Return:getView()
  return self.layer
end

function Return:registerTouchEvent()
  local ispress = false
  WaitEvent("mainTouch", function(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui.back, x, y) then
        self.ui.back_press:setVisible(true)
        ispress = true
      end
    elseif event == "ended" then
      self.ui.back_press:setVisible(false)
      if ispress then
        ispress = false
        if ed.containsPoint(self.ui.back, x, y) then
          lsr:report("clickBack")
          if self.uiview.buttom and self.uiview.buttom:isMove() then
            return
          end
          SendEvent("popScene")
        end
      end
    end
  end)
end

function Return:getUiInfo()
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/1080P/common/backbtn.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(40, 465)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/1080P/common/backbtn-disabled.png",
        parent = "back"
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
