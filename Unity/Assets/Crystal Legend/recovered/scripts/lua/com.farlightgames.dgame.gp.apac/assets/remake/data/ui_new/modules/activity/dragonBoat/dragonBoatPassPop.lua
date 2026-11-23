local base = ed.ui.popwindow
local class = {}
class.__index = class
setmetatable(class, base.mt)
ed.ui.dragonBoatPassPop = class

function class.create(params)
  local self = base.create("dragonBoatPassPop", {notBlurBg = true})
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initUI()
  self:initPage()
  self:registerTouchHandler()
  self:show()
end

function class:initData(params)
  params = params or {}
  self.mgr = ed.dragonBoatMgr.getInstance()
  self.passTbl = ed.getDataTable("SimplePass")[self.mgr.passId or 8]
  self.controller = params.controller
  self.page = params.page or "reward"
end

function class:initUI()
  self.controller.ui.current_speed_bg:setVisible(false)
  self.controller.ui.btn_use_zongzi:setVisible(false)
  local container, ui = ed.editorui(ed.uieditor.DragonBoatPassPop)
  self.container:addChild(container)
  self.container:setScale(0.95)
  self.ui = ui
  self:initLabel()
  self:initRedPoint()
end

function class:initRedPoint()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("dragon_boat_pass_reward", self, {
    handle = function(value)
      self.ui.image_reward_tag_red:setVisible(0 < value)
    end
  })
  self.redPointMgr:registerValueChange("dragon_boat_pass_task", self, {
    handle = function(value)
      self.ui.image_task_tag_red:setVisible(0 < value)
    end
  })
end

function class:initLabel()
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(7418136), 1.5)
  ed.setLabelStroke(self.ui.label_level_num, ed.toccc3(8076090), 2.5)
  ed.setLabelStroke(self.ui.label_exp_title, ed.toccc3(16774082), 1.5)
  ed.setLabelStroke(self.ui.label_exp_num, ed.toccc3(2901306), 1.5)
  ed.setLabelStroke(self.ui.label_exp_base, ed.toccc3(16774082), 1.5)
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(8666682), 1.5)
  ed.setLabelStroke(self.ui.label_task, ed.toccc3(8666682), 1.5)
  ed.setLabelStroke(self.ui.label_reward_select, ed.toccc3(16776696), 1.5)
  ed.setLabelStroke(self.ui.label_task_select, ed.toccc3(16776696), 1.5)
  local leftTime = ed.dragonBoatMgr.getInstance().endTime - ed.getServerTime()
  ed.setLabelString(self.ui.label_left_time, T("\229\137\169\228\189\153 %s", ed.time2dhms(leftTime)))
  local passPrice = ed.lookupDataTable("SimplePass", "R1 Price Value", self.mgr.passId)
  local unlockLabel = ed.ui.gradientLabel.create({
    text = T("%s\232\167\163\233\148\129", ed.RechargeManager:getCostDisplayByCNYCost(passPrice)),
    fontSize = 18,
    strokeColor = ed.toccc3(8661543),
    strokeSize = 1.5,
    startColor = ed.toccc3(16771956),
    endColor = ed.toccc3(16711606)
  })
  self.ui.btn_pass_unlock:addChild(unlockLabel.node)
  ed.layout.centerInParent(unlockLabel.node)
  unlockLabel.node:setScale(math.min(1, 100 / unlockLabel.node:getContentSize().width))
end

function class:initPage()
  ed.passNetWork:simplePassOpenPanel(self.mgr.passId)
  if self.page == "reward" then
    self:onBtnReward()
  elseif self.page == "task" then
    self:onBtnReward()
    self:onBtnTask()
  end
end

function class:handleTaskSubmitUpdate(_task_submit)
  local actId = _task_submit._act_id
  if actId == self.mgr.activityInfo._id then
    local _rewards = _task_submit._rewards or {}
    ed.UITool.showRewardsFromServer(_rewards)
    ed.player:addRewards(_rewards)
    ed.activityHints:updateReds({_act_id = actId})
  end
end

function class:registerBtn(key, func, params)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    clickHandler = function(_, x, y)
      func(x, y)
    end,
    force = true,
    mcpMode = true,
    mcp_dis = 30,
    clickInterval = 0.5
  }
  for k, v in pairs(params or {}) do
    config[k] = v
  end
  self:btRegisterButtonClick(config)
end

function class:registerTouchHandler()
  self:registerBtn("btn_close", function()
    self:close()
  end, {normalScale = 1, pressScale = 0.95})
  self:registerBtn("btn_reward", function()
    self:onBtnReward()
  end, {normalScale = 1, pressScale = 0.95})
  self:registerBtn("btn_task", function()
    self:onBtnTask()
  end, {normalScale = 1, pressScale = 0.95})
  self:listenEvent("UpdatePassData", function(id)
    self:onPassUpdate(id)
  end)
  self:listenEvent("scope_activity_reply", function(msg)
    if msg._task_submit then
      self:handleTaskSubmitUpdate(msg._task_submit)
    end
  end)
  ed.UITool.registerBtn(self, "btn_pass_unlock", function()
    ed.showConfirmDialog({
      text = T("\230\152\175\229\144\166\232\138\177\232\180\18530\229\133\131\232\180\173\228\185\176\231\178\189\233\159\181\233\148\166\231\168\139"),
      rightHandler = function()
        ed.passDataMgr:doRechargePass(self.mgr.passId, 1)
      end
    })
  end, {normalScale = 1, pressScale = 0.95})
  self:listenEvent("passBuySuccess", function(id, rank)
    if id == self.mgr.passId then
      self.reward_page:refreshPage()
    end
  end)
end

function class:close()
  self.controller.ui.current_speed_bg:setVisible(true)
  self.controller.ui.btn_use_zongzi:setVisible(true)
  self:destroy()
end

function class:onBtnReward()
  if self.ui.btn_reward_select:isVisible() then
    return
  end
  self.ui.btn_reward_select:setVisible(true)
  self.ui.btn_task_select:setVisible(false)
  self.ui.btn_reward:setVisible(false)
  self.ui.btn_task:setVisible(true)
  if not self.layer_reward then
    self.reward_page = ed.ui.dragonBoatPassReward.create({controller = self})
    self.layer_reward = self.reward_page.container
    self.ui.layer_panel:addChild(self.layer_reward)
  end
  self.layer_reward:setVisible(true)
  if self.layer_task then
    self.layer_task:setVisible(false)
  end
  self.reward_page:refreshBtnUnlock()
end

function class:onBtnTask()
  self.ui.btn_pass_unlock:setVisible(false)
  if self.ui.btn_task_select:isVisible() then
    return
  end
  self.ui.btn_reward_select:setVisible(false)
  self.ui.btn_task_select:setVisible(true)
  self.ui.btn_reward:setVisible(true)
  self.ui.btn_task:setVisible(false)
  if not self.layer_task then
    self.task_page = ed.ui.dragonBoatPassTask.create({controller = self})
    self.layer_task = self.task_page.container
    self.ui.layer_panel:addChild(self.layer_task)
  end
  self.layer_task:setVisible(true)
  if self.layer_reward then
    self.layer_reward:setVisible(false)
  end
end

function class:onPassUpdate(id)
  if id == self.mgr.passId and self.reward_page then
    self.reward_page:refreshPage()
  end
end
