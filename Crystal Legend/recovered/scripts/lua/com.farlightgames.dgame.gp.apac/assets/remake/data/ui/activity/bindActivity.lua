local base = ed.ui.activityBase
local BindActivity = newclass(base.mt)
ed.ui.BindActivity = BindActivity
local minBindLevel = 10

function BindActivity:registerTouchNode()
  local ui = self.buttons
  self:btRegisterButtonClick({
    button = ui.left_button,
    press = ui.left_button_press,
    key = "bind_left_button",
    clickHandler = function()
      self:bindIphone()
    end,
    force = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.right_button,
    press = ui.right_button_press,
    key = "bind_right_button",
    clickHandler = function()
      self:openRules(self.chain)
    end,
    force = true,
    clickInterval = 0.5
  })
end

function BindActivity:bindIphone()
  if not self:isBegin() then
    ed.showToast(T("\230\180\187\229\138\168\230\156\170\229\188\128\229\167\139"))
    return
  end
  if self:isEnd() then
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\231\187\143\231\187\147\230\157\159"))
    return
  end
  if ed.player:getLevel() < minBindLevel then
    ed.showToast(T("10\231\186\167\228\187\165\228\184\138\231\142\169\229\174\182\230\137\141\232\131\189\229\143\130\229\138\160\232\175\165\230\180\187\229\138\168"))
    return
  end
  ed.ui.bindActivityRules:createNotes()
end

function BindActivity:openRules(index)
  ed.ui.bindActivityRules:createRules(index)
end

function BindActivity:doPress(x, y)
  local ui = self.topUi
  local button = ui.tshirt_button
  local press = ui.tshirt_button_press
  if ed.containsPoint(button, x, y) then
    press:setVisible(true)
    return true
  end
end

function BindActivity:doClick(x, y)
  self:resetTshirtButton()
  local url = "http://activity.j-zhuang.com/daota/prizes"
  ed.openURL(url)
end

function BindActivity:resetTshirtButton()
  local ui = self.topUi
  local press = ui.tshirt_button_press
  press:setVisible(false)
end

function BindActivity:cancelPress(x, y)
  self:resetTshirtButton()
end

function BindActivity:cancelClick(x, y)
  self:resetTshirtButton()
end

function BindActivity:initRewardsWithBinds(binds)
  if not binds then
    return
  end
  local rewards = {}
  local data = ed.getDataTable("BindingReward")[self.chain]
  for k, row in ipairs(data) do
    if row["Range 1"] <= self.binds and self.binds <= row["Range 2"] then
      for i = 1, 5 do
        local type = row[T("Reward Type %s", i)]
        if type then
          local percent = row[T("Reward Percent %s", i)]
          local type = row[T("Reward Type %s", i)]
          if type == "Diamond" then
            type = "ManayDiamonds"
          end
          local temp = {
            type = type,
            id = row[T("Reward Id %s", i)],
            amount = math.ceil(percent * self.binds),
            percent = percent * 100,
            itemCount = row[T("Reward Amount %s", i)]
          }
          local max = row[T("Reward Max %s", i)]
          if max then
            temp.itemCount = math.max(temp.itemCount, max)
          end
          table.insert(rewards, temp)
        end
      end
      local type = row["Default Type"]
      if type then
        local Percent = row["Default Percent"]
        local temp = {
          type = row["Default Type"],
          id = row["Default Id"],
          amount = math.ceil(Percent * self.binds),
          percent = Percent * 100,
          itemCount = row["Default Amount"]
        }
        local max = row["Default Max"]
        if max then
          temp.itemCount = math.max(temp.itemCount, max)
        end
        table.insert(rewards, temp)
      end
    end
  end
  local struct = {
    tshirt = rewards[1],
    rewards = {}
  }
  for k = #rewards, 1, -1 do
    local v = rewards[k]
    if 1 < k then
      table.insert(struct.rewards, v)
    end
  end
  return struct
end

function BindActivity:resetData(info)
  local extra = info._extra_info._bind_tel
  self.binds = extra._binds
  self.chain = extra._serial_no
  self.rewards = self:initRewardsWithBinds(self.binds)
  self.listData = {}
end

function BindActivity:createRewards()
  local bg, rewardsBg = ed.editorui(ed.uieditor.BindActivity3)
  local board = rewardsBg.board
  self.rewardsBg = rewardsBg
  local top, topUi = ed.editorui(ed.uieditor.BindActivity4)
  board:addChild(top)
  self.topUi = topUi
  local tshirt = self.rewards.tshirt
  ed.setString(topUi.popu, self.binds)
  local text = T("\229\133\177%s\228\187\189(%s%%)", tshirt.amount, tshirt.percent)
  ed.setString(topUi.tshirt_des, text)
  ed.right2(topUi.popu, topUi.popu_des)
  local temp = {container = top}
  table.insert(self.listData, temp)
  local temp = self.rewards.rewards
  for k = 1, #temp, 2 do
    local node, ui = ed.editorui(ed.uieditor.BindActivity5)
    board:addChild(node)
    self:resetRewardGroup(ui, k, temp)
    local config = {container = node}
    table.insert(self.listData, config)
  end
  local rh = self:refreshRewardsList()
  self:refreshListHeight(rh)
  local h = self.ui.a_rewards:getPositionY()
  board:setPositionY(h - 20)
  self.leftContainer:addChild(bg)
end

function BindActivity:refreshRewardsList()
  local vh = -30
  for k = #self.listData, 1, -1 do
    local v = self.listData[k]
    vh = vh + 45
    v.container:setPositionY(vh)
  end
  local scaleH = vh + 120
  self.rewardsBg.board:setContentSize(CCSizeMake(405, scaleH))
  return scaleH
end

function BindActivity:resetRewardGroup(ui, index, datas)
  for k = 1, 2 do
    local data = datas[index]
    local item_text = T("item_%s", k)
    local item_des_text = T("item_%s_des", k)
    if data then
      local id = data.type == "Item" and data.id or data.type
      local icon = ed.readequip.createIconWithAmount(id, 40, data.itemCount)
      ui[item_text]:addChild(icon)
      local text = T("\229\133\177%s\228\187\189(%s%%)", data.amount, data.percent)
      ed.setString(ui[item_des_text], text)
    else
      ui[item_text]:setVisible(false)
      ui[item_des_text]:setVisible(false)
    end
    index = index + 1
  end
end

function BindActivity:createButtomButton()
  local container, ui = ed.editorui(ed.uieditor.BindActivity6)
  self.container:addChild(container)
  self.buttons = ui
end

function BindActivity:create(info)
  local param = {
    title = info._title,
    sTime = info._start_time,
    eTime = info._end_time,
    tContent = info._rules,
    banner = info._banner,
    config = {touchpriority = -100}
  }
  local self = base.create(param)
  setmetatable(self, BindActivity.mt)
  self:resetData(info)
  self:createRewards()
  self:createButtomButton()
  self:registerTouchNode()
  return self
end
