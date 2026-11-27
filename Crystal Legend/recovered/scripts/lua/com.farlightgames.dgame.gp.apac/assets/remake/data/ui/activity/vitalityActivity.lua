local lastGetTime = 0
local base = ed.ui.activityBase
local maxVitality = 500
local VitalityActivity = newclass(base.mt)
ed.ui.VitalityActivity = VitalityActivity

function VitalityActivity:resetButton()
  local ui = self.listui
  local press = ui.get_button_press
  press:setVisible(false)
end

function VitalityActivity:getVitality()
  if ed.getServerTime() - lastGetTime < 5 then
    return
  end
  lastGetTime = ed.getServerTime()
  if not self:isBegin() then
    ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\167\139"))
    return
  end
  if self.leftVitality == 0 then
    ed.showToast(T("\230\154\130\230\151\182\230\178\161\230\156\137\229\164\154\228\189\153\231\154\132\228\189\147\229\138\155\229\143\175\233\162\134"))
    return
  end
  if ed.player:getVitality() >= maxVitality then
    ed.showToast(T("\228\189\160\231\154\132\228\189\147\229\138\155\229\164\170\229\164\154\229\149\166\239\188\140\230\182\136\232\128\151\228\184\128\228\186\155\229\134\141\230\157\165\233\162\134\229\143\150\229\144\167\227\128\130"))
    return
  end
  
  local function callback()
    self.leftVitality = 0
    local ui = self.listui
    ed.setString(ui.label_5, self.leftVitality)
  end
  
  self:requestReward(self.rewardId, callback)
end

function VitalityActivity:doPress(x, y)
  local ui = self.listui
  local button = ui.get_button
  local press = ui.get_button_press
  if ed.containsPoint(button, x, y) then
    press:setVisible(true)
    return true
  end
end

function VitalityActivity:doClick(x, y, k, i)
  self:resetButton()
  self:getVitality()
end

function VitalityActivity:cancelPress(x, y, k, i)
  self:resetButton(k)
end

function VitalityActivity:cancelClick(x, y, k, i)
  self:resetButton(k)
end

function VitalityActivity:createIcon(root, node)
  local x, y = node:getPositionX(), node:getPositionY()
  node:setVisible(false)
  local icon = ed.createSprite("UI/alpha/HVGA/tutorial_head_cm.png")
  icon:setPosition(ccp(x, y - 5))
  icon:setScale(0.5)
  root:addChild(icon)
end

function VitalityActivity:resetRewardsUI()
  local ui = self.listui
  ed.setString(ui.label_4, T("\229\143\175\228\187\165\233\162\134\229\143\150\228\189\147\229\138\155:"))
  ed.setString(ui.label_5, self.leftVitality)
  ed.setString(ui.title, T("\229\176\143\229\134\176\229\134\176\231\154\132\229\134\176\231\174\177"))
  ui.label_6:setVisible(false)
  ui.rmb_icon:setVisible(false)
  ui.left:setVisible(false)
  ui.left_time:setVisible(false)
  ui.activity_end:setVisible(false)
  local icon = ed.createSprite("UI/alpha/HVGA/task_vit_icon_2.png")
  ui.bg_buttom:addChild(icon)
  ed.right2(icon, ui.label_4, 2)
  ed.right2(ui.label_5, icon, 2)
end

function VitalityActivity:createRewards()
  local dt = 15
  local container = self.ui.rewards_layer
  local listPanel, ui = ed.editorui(ed.uieditor.NewRedBag)
  self.listui = ui
  container:addChild(listPanel)
  local rHeight = ui.bg_top:getContentSize().height + ui.bg_buttom:getContentSize().height
  ui.bg_top:setVisible(false)
  local x, y = ui.bg_top:getPositionX(), ui.bg_top:getPositionY()
  ui.bg_buttom:setPosition(ccp(x, y))
  local cHeight = container:getContentSize().height
  local height = rHeight - cHeight + dt
  container:setPositionY(container:getPositionY() - height)
  self:createIcon(ui.bg_buttom, ui.hero_icon)
  self:resetRewardsUI()
  self:refreshListHeight(rHeight)
end

function VitalityActivity:getRerward(info)
  local rewards = info._rewards
  local reward = rewards[1]._rewards[1]
  return reward._amount, rewards[1]._dailyjob._id
end

function VitalityActivity:resetData(info)
  self.leftVitality, self.rewardId = self:getRerward(info)
end

function VitalityActivity:create(info)
  local param = {
    title = info._title,
    sTime = info._start_time,
    eTime = info._end_time,
    tContent = info._rules
  }
  local self = base.create(param)
  setmetatable(self, VitalityActivity.mt)
  self:resetData(info)
  self:createRewards()
  return self
end
