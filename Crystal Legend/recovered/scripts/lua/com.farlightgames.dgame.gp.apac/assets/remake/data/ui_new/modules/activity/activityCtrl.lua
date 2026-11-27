local activityCtrl = {}
ed.activityCtrl = activityCtrl
ed.UITool.registViewOpenFunc("activityScene", function(param)
  local cpl = ed.playerlimit.getAreaUnlockPrompt("Activity")
  if cpl then
    ed.showToast(cpl)
    return
  end
  local object = activityCtrl.create(param)
  ed.pushScene(object.scene)
end)

function activityCtrl.create(param)
  local self = {}
  setmetatable(self, {__index = activityCtrl})
  self.data = ed.activityData.create()
  self.network = ed.ActivityNetwork.create()
  self.scene = ed.ui.activityScene.create(param, self.onExit(self), self.network, self.data)
  self.scopes = {}
  self.data:initActivityData(ed.activityHints.data.activityInfo, ed.activityHints.data.activityKey, ed.activityHints.data.ptrShow, ed.activityHints.data.othActConfig)
  self.scene:createPage()
  self.scene:listenEvent("scope_activity_reply", function(info)
    self:activityReply(info)
  end)
  self.scene:listenEvent("daily_vitality_reply", function(info)
    self:vitalityReply(info)
  end)
  return self
end

function activityCtrl:activityReply(infos)
  local info = ed.copyProto(infos)
  if info._pull then
    local data = info._pull._activity_list or {}
    self.data:setActivityData(data)
    self.scene:createPage()
  elseif info._task_submit or info._choose_reward then
    info._task_submit = info._task_submit or info._choose_reward or {}
    local cfgId = self.data:getActivityInfoToKey(info._task_submit._act_id)._cfg_id
    if not self.data.activityConfig[cfgId].Show then
      return
    end
    self.data:updateActivityData(info._task_submit)
    self.scene:pageUpdate(info._task_submit)
    ed.player:addRewards(info._task_submit._rewards or {}, ed.showDirectlyRate)
    local items = {}
    for i, v in ipairs(info._task_submit._rewards or {}) do
      v._type = v._type == "free_monthcard" and "FreeMonthCard" or v._type
      if v._type ~= "hero" then
        table.insert(items, v)
      end
    end
    if 0 < #items then
      ed.UITool.showRewardsFromServer(items, nil, ed.showDirectlyRate, nil)
    elseif info._task_submit._task and info._task_submit._task._rewards then
      local items = {}
      for i, v in ipairs(info._task_submit._task._rewards) do
        v._type = v._type == "free_monthcard" and "FreeMonthCard" or v._type
        if v._type ~= "hero" then
          table.insert(items, v)
        end
      end
      if 0 < #items then
        ed.UITool.showRewardsFromServer(items, nil, ed.showDirectlyRate, nil)
      end
    end
    ed.checkShowDirectlyRate(info._task_submit)
  end
end

function activityCtrl:vitalityReply(info)
  local submit = {
    _act_id = 9999902,
    _task = {},
    _rewards = {}
  }
  self.data:updateActivityData(submit)
  self.scene:pageUpdate(submit)
  local addVit = self.network.Vitality or 0
  local newVit = info._current_vitality or 0
  local panel = ed.ui.maillocalbox.create({
    type = "addItem",
    item = {
      {
        type = "Vitality",
        id = nil,
        amount = addVit
      }
    }
  })
  panel:popWindow()
  ed.player:addVitality(addVit)
  if self.network.Diamond then
    ed.player:subPoint("diamond", -1 * self.network.Diamond)
  end
end

function activityCtrl:onExit()
  return function()
    print("onExit ")
  end
end
