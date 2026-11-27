local ptrRewardPage = {}
ed.ui.activityPtrRewardPage = ptrRewardPage

function ptrRewardPage.create(base, param, pageKey)
  local self = {}
  setmetatable(ptrRewardPage, {__index = base})
  setmetatable(self, {__index = ptrRewardPage})
  local container, ui = ed.editorui(ed.uieditor.activity_ptr_page)
  self.ui = ui
  self.param = param
  self.pageKey = pageKey or ""
  self.container = container
  self:initData()
  self:initUI()
  return self
end

function ptrRewardPage:initData()
  self.tasks = self.param._tasks
  self.actId = self.param._id
end

function ptrRewardPage:pageUpDate(param)
  self.param = param
  self:initData()
  self:refreshUI()
end

function ptrRewardPage:refreshUI()
  for i = 1, 2 do
    if self.tasks[i]._cur_reward_times >= self.tasks[i]._max_reward_times then
      ed.setTexture(self.ui["btn" .. i], "UI/alpha/1080P/common/button_mini_grey.png")
    end
  end
end

function ptrRewardPage:initUI()
  for i = 1, 2 do
    local task = self.tasks[i]
    local rewards = task._rewards or {}
    local reward = rewards[1]
    if reward then
      local r = {
        type = reward._type,
        amount = reward._amount,
        id = reward._id
      }
      local icon = ed.createItemIcon(r)
      ed.UITool.replaceUI(self.ui, "item" .. i, "icon" .. i, icon)
      if task._cur_reward_times < task._max_reward_times then
        ed.UITool.registerBtn(self, "btn" .. i, function()
          if self.tasks[i]._cur_reward_times < self.tasks[i]._max_reward_times then
            ed.showConfirmDialog({
              text = T("\230\173\164\231\166\143\229\136\169\229\143\170\232\131\189\233\162\134\229\143\150\228\184\128\230\172\161\239\188\140\230\152\175\229\144\166\231\161\174\232\174\164\228\189\191\231\148\168\230\156\172\230\156\141\232\167\146\232\137\178\233\162\134\229\143\150\239\188\159"),
              rightText = T("\231\161\174\229\174\154"),
              rightHandler = function()
                ed.ActivityNetwork:activitySubmit(self.actId, task._id)
              end
            })
          else
            ed.showToast(T("\229\183\178\233\162\134\229\143\150"))
          end
        end, {pressScale = 0.95})
      else
        ed.setTexture(self.ui["btn" .. i], "UI/alpha/1080P/common/button_mini_grey.png")
      end
      ed.UITool.registerBtn(self, "icon" .. i, function()
        ed.ui.packageDetailWin.create(r):popWindow()
      end)
    else
      self.ui["item" .. i]:setVisible(false)
    end
  end
end
