local base = Widget
local class = newclass(base.mt)
RadioButton = class
setfenv(1, class)

function create(params)
  local self = base.create("radiobutton")
  setmetatable(self, class.mt)
  params = params or {}
  buttons = params.buttons or {}
  self.buttons = buttons
  if params.default then
    self:click(default, true)
  end
  return self
end

function click(self, key, displayMode)
  for _, button in pairs(self.buttons) do
    if key == button.key then
      if not tolua.isnull(button.selected) then
        button.selected:setVisible(true)
      end
      if not displayMode and button.clickHandler then
        button.clickHandler()
      end
    elseif not tolua.isnull(button.selected) then
      button.selected:setVisible(false)
    end
  end
end

function register(self, button)
  if type(button) == "table" then
    table.insert(self.buttons, button)
  end
end

function remove(self, key)
  for index, button in pairs(self.buttons) do
    if button.key == key then
      table.remove(self.buttons, index)
      break
    end
  end
end
