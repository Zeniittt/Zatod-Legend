local base = ed.ui.activityBase
local NewRedBag = newclass(base.mt)
ed.ui.newRedBag = NewRedBag

function NewRedBag:getClickButton(x, y)
  local ui = self.listui
  local buttons = {
    record = {
      normal = ui.record_button,
      press = ui.record_button_press
    },
    send = {
      normal = ui.send_button,
      press = ui.send_button_press
    },
    get = {
      normal = ui.get_button,
      press = ui.get_button_press
    }
  }
  for k, button in pairs(buttons) do
    if ed.containsPoint(button.normal, x, y) and button.normal:isVisible() then
      return k, button
    end
  end
end

function NewRedBag:doPress(x, y)
  local key, clickButton = self:getClickButton(x, y)
  if key then
    clickButton.press:setVisible(true)
    return key
  end
end

function NewRedBag:resetButton(key)
  local ui = self.listui
  if key == "record" then
    ui.record_button_press:setVisible(false)
  elseif key == "send" then
    ui.send_button_press:setVisible(false)
  elseif key == "get" then
    ui.get_button_press:setVisible(false)
  end
end

function NewRedBag:doClick(x, y, k, i)
  local key = k
  self:resetButton(key)
  self:doClickButton(key)
end

function NewRedBag:cancelPress(x, y, k, i)
  self:resetButton(k)
end

function NewRedBag:cancelClick(x, y, k, i)
  self:resetButton(k)
end

function NewRedBag:doClickButton(key)
  if key == "record" then
    self:openRecord()
  elseif key == "send" then
    self:sendRedEnvelope()
  elseif key == "get" then
    self:getRedEnvelope()
  end
end

function NewRedBag:checkGetted(lastGetTime)
  return not ed.checkTwoDateod(lastGetTime, ed.getServerTime())
end

function NewRedBag:getRedEnvelope()
  if not self:isBegin() then
    ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\167\139"))
    return
  end
  if self:isEnd() then
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\143\231\187\147\230\157\159"))
    return
  end
  if self:checkGetted(self.lastGetTime) then
    ed.showToast(T("\228\189\160\228\187\138\229\164\169\229\183\178\231\187\143\233\162\134\232\191\135\231\186\162\229\140\133\228\186\134"))
    return
  end
  
  local function callback()
    self.lastGetTime = ed.getServerTime()
  end
  
  self:requestReward(self.data.jobid, callback)
end

function NewRedBag:openRecord()
  local id = self.data.envelopeId
  if id then
    ed.ui.redBag.requestRedBagInfo(id, 1)
  end
end

function NewRedBag:sendRedEnvelope()
  local id = self.data.envelopeId
  if id then
    ed.ui.redBag:create(id)
  end
end

function NewRedBag:resetEndState()
  local ui = self.listui
  ed.setString(ui.label_2, self.data.totalAmount)
  ed.setString(ui.label_1, "\229\183\178\233\154\143\230\156\186\229\136\134\229\133\165")
  ed.setString(ui.label_3, "\228\184\170\231\186\162\229\140\133")
  ed.setString(ui.label_7, self.data.totalNum)
  ed.setString(ui.label_8, T("(%s\228\186\186\233\162\134\229\143\150)", self.data.drawNum))
  ed.setString(ui.label_4, "\231\179\150\230\158\156\231\148\156\229\191\131\231\154\132\231\166\143\232\162\139\229\183\178\231\187\143\229\143\145\229\174\140\228\186\134\239\188\129")
  if self.data.drawNum == 0 then
    ui.label_8:setVisible(false)
  end
  ui.record_button:setVisible(true)
  ui.send_button:setVisible(true)
  ui.get_button:setVisible(false)
  local x, y = ui.label_1:getPositionX(), ui.label_1:getPositionY()
  ui.diamond:setPosition(ccp(x, y + 20))
  ed.right2(ui.label_2, ui.diamond)
  ed.right2(ui.label_1, ui.label_2)
  ed.right2(ui.label_7, ui.label_1)
  ed.right2(ui.label_3, ui.label_7)
  ed.right2(ui.label_8, ui.label_3)
  ui.label_5:setVisible(false)
  ui.label_6:setVisible(false)
  ui.activity_end:setVisible(true)
  ui.left:setVisible(false)
  ui.left_time:setVisible(false)
  ui.rmb_icon:setVisible(false)
end

function NewRedBag:resetStartState()
  local ui = self.listui
  ed.setString(ui.label_2, self.data.totalAmount)
  ed.setString(ui.label_5, self.data.drawAmount)
  ed.setString(ui.left_time, self.leftTime)
  ed.right2(ui.diamond, ui.label_1, 2)
  ed.right2(ui.label_2, ui.diamond, 2)
  ed.right2(ui.label_3, ui.label_2, 2)
  ed.right2(ui.rmb_icon, ui.label_4, 2)
  ed.right2(ui.label_5, ui.rmb_icon, 2)
  ed.right2(ui.label_6, ui.label_5, 2)
  ed.right2(ui.left_time, ui.left, 2)
  ui.label_7:setVisible(false)
  ui.label_8:setVisible(false)
  ui.activity_end:setVisible(false)
  ui.record_button:setVisible(false)
  ui.send_button:setVisible(false)
  ui.get_button:setVisible(true)
  if self:checkGetted(self.lastGetTime) then
    ed.setString(ui.label_4, "\228\189\160\229\183\178\231\187\143\233\162\134\232\191\135\228\187\138\229\164\169\231\154\132\231\166\143\232\162\139\228\186\134\239\188\129")
    ui.get_button:setVisible(false)
    ui.rmb_icon:setVisible(false)
    ui.label_5:setVisible(false)
    ui.label_6:setVisible(false)
  end
end

function NewRedBag:resetFutureState()
  local ui = self.listui
  ui.left:setVisible(false)
  ui.left_time:setVisible(false)
  ed.setString(ui.label_4, "\230\173\163\229\156\168\229\135\134\229\164\135\231\166\143\232\162\139\239\188\129")
  ui.rmb_icon:setVisible(false)
  ui.label_5:setVisible(false)
  ui.label_6:setVisible(false)
  ui.activity_end:setVisible(false)
  ed.setString(ui.label_1, "\230\149\172\232\175\183\230\156\159\229\190\133\230\180\187\229\138\168\229\188\128\229\167\139")
  ui.label_2:setVisible(false)
  ui.diamond:setVisible(false)
  ui.label_3:setVisible(false)
  ui.label_7:setVisible(false)
  ui.label_8:setVisible(false)
  ui.record_button:setVisible(false)
  ui.send_button:setVisible(false)
end

function NewRedBag:resetRewardsUI()
  if self:isEnd() then
    self:resetEndState()
  elseif self:isBegin() then
    self:resetStartState()
  else
    self:resetFutureState()
  end
end

function NewRedBag:createRewards()
  local dt = 15
  local container = self.ui.rewards_layer
  local listPanel, ui = ed.editorui(ed.uieditor.NewRedBag)
  self.listui = ui
  container:addChild(listPanel)
  local rHeight = ui.bg_top:getContentSize().height + ui.bg_buttom:getContentSize().height
  local cHeight = container:getContentSize().height
  local height = rHeight - cHeight + dt
  container:setPositionY(container:getPositionY() - height)
  self:resetRewardsUI()
  self:refreshListHeight(rHeight)
end

local function leftTime(endTime)
  local dt = 86400
  local str = ""
  local t = endTime - ed.getServerTime()
  if 0 < t then
    if dt <= t then
      local d = math.floor(t / dt)
      local h = math.floor((t - d * dt) / 3600)
      if 0 < h then
        d = d + 1
      end
      str = T("%d\229\164\169", d)
    else
      str = "1\229\164\169"
    end
  end
  return str
end

function NewRedBag:resetData(info)
  local rewards = info._rewards or {}
  local reward = rewards[1]
  local envelope = reward._extra_reward_info._red_envelope
  self.data = {}
  self.data.envelopeId = envelope._red_id
  self.data.totalAmount = envelope._red_amount
  self.data.totalNum = envelope._red_total
  self.data.drawNum = envelope._red_draw
  self.leftTime = leftTime(info._end_time)
  self.data.drawAmount = reward._rewards[1]._amount
  self.data.jobid = reward._dailyjob._id
  self.lastGetTime = reward._dailyjob._last_rewards_time
end

function NewRedBag:create(info)
  local param = {
    title = info._title,
    sTime = info._start_time,
    eTime = info._end_time,
    tContent = info._rules
  }
  local self = base.create(param)
  setmetatable(self, NewRedBag.mt)
  self:resetData(info)
  self:createRewards()
  return self
end
