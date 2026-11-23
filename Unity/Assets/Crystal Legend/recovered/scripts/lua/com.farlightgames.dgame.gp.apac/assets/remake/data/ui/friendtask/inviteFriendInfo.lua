local base = ed.ui.popwindow
local FriendInfo = newclass(base.mt)
ed.ui.FriendInfo = FriendInfo
local touch = ed.ui.basetouchnode
local describe = {
  callback = {
    {
      "-\232\162\171\229\143\172\229\155\158\230\151\182\231\173\137\231\186\167",
      "-\229\189\147\229\137\141\231\173\137\231\186\167"
    },
    {
      "-\232\162\171\229\143\172\229\155\158\230\151\182\232\139\177\233\155\132\230\149\176\233\135\143",
      "-\229\189\147\229\137\141\232\139\177\233\155\132\230\149\176\233\135\143"
    },
    {
      "-\232\162\171\229\143\172\229\155\158\230\151\182\229\133\133\229\128\188\233\146\187\231\159\179",
      "-\229\189\147\229\137\141\229\133\133\229\128\188\233\146\187\231\159\179"
    }
  },
  invite = {
    {
      "-\232\162\171\233\130\128\232\175\183\230\151\182\231\173\137\231\186\167",
      "-\229\189\147\229\137\141\231\173\137\231\186\167"
    },
    {
      "-\232\162\171\233\130\128\232\175\183\230\151\182\232\139\177\233\155\132\230\149\176\233\135\143",
      "-\229\189\147\229\137\141\232\139\177\233\155\132\230\149\176\233\135\143"
    },
    {
      "-\232\162\171\233\130\128\232\175\183\230\151\182\229\133\133\229\128\188\233\146\187\231\159\179",
      "-\229\189\147\229\137\141\229\133\133\229\128\188\233\146\187\231\159\179"
    }
  }
}

local function initDescribe(type, ui)
  local ds = describe[type]
  for k, row in ipairs(ds) do
    for i, column in ipairs(row) do
      local label = T("label_%d_%d", k, i)
      ed.setString(ui[label], column)
      ed.setLabelShadow(ui[label], ccc3(0, 0, 0), ccp(0, 2))
    end
  end
end

local function initValue(data, ui)
  for k, row in ipairs(data) do
    for i, column in ipairs(row) do
      local label = T("label_%d_%d", k, i + 2)
      ed.setString(ui[label], column)
      ed.setLabelShadow(ui[label], ccc3(0, 0, 0), ccp(0, 2))
    end
  end
end

function FriendInfo:registerTouchHandler(touchNode)
  local ui = self.ui
  touchNode:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:destroy()
    end
  })
end

function FriendInfo:initTouch()
  self.container:setTouchEnabled(true)
  local touchNode = touch.btCreate()
  self.touchPriority = -420
  self.container:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, self.touchPriority, true)
  self.touchNode = touchNode
  self:registerTouchHandler(self.touchNode)
end

function FriendInfo:initUI()
  local frame, ui = ed.editorui(ed.uieditor.inviteFriendInfo)
  self.frame, self.ui = frame, ui
  self.container:addChild(frame)
  initDescribe(self.type, ui)
  initValue(self.data, ui)
end

function FriendInfo:initData(type, data)
  self.type = type
  self.data = data
end

function FriendInfo:create(type, info)
  local self = base.create("applylist")
  setmetatable(self, FriendInfo.mt)
  self:initData(type, info)
  self:initUI()
  self:initTouch()
  self:show()
  return self
end

function FriendInfo:pop(type, info)
  local window = FriendInfo:create(type, info)
  if window then
    window:popWindow()
  end
end
