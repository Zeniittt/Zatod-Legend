local class = newclass("g")
ed.featurePreviewManager = class
ed.UITool.registViewOpenFunc("featurePreviewWindow", function()
  if ReloadModule then
    ReloadModule("ui_new/modules/featurePreview/featurePreviewWindow")
  end
  ed.featurePreviewNetwork.sendOpenPanel()
end)

function class:notify(data)
  self.isOpen = data._is_open == 1
  self.red = data._rewards > 0
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.FEATURE_PREVIEW)
  FireEvent("RefreshRightTopButtons")
end

function class:setRewards(data)
  self.already = {}
  self.showTask = {}
  for i, v in ipairs(data) do
    self.showTask[v._id] = true
    if v._rewarded > 0 then
      self.already[v._id] = true
    end
  end
end

function class:setRewardsToId(id, already)
  self.already[id] = already
end

function class:setRewardsToIds(ids)
  for i, v in ipairs(ids) do
    self:setRewardsToId(v, true)
  end
end

function class:getTasks()
  self.taskItems = {}
  self.treatIds = {}
  self.receiving = false
  
  local function getStatus(lv)
    return lv > ed.player:getLevel() and 0 or 1
  end
  
  local tab = ed.getDataTable("FeaturePreview")
  local t = {}
  for k, v in pairs(tab) do
    if self.showTask[v.ID] and ed.player:getLevel() + 20 >= v.Level then
      table.insert(t, {
        id = v.ID,
        name = v["Function Name"],
        str = v.Description,
        limited = v.Limited,
        type = v.Function,
        level = v.Level,
        isNew = v["Is New"],
        res = v.Icon,
        reward = {
          id = v["Get Reward ID"],
          amount = v["Get Reward Amount"],
          type = v["Get Reward Type"]
        },
        status = self.already[v.ID] and 2 or getStatus(v.Level)
      })
      self.taskItems[v.ID] = {
        _id = v["Get Reward ID"],
        _amount = v["Get Reward Amount"],
        _type = v["Get Reward Type"]
      }
      if t[#t].status == 1 then
        table.insert(self.treatIds, v.ID)
      elseif t[#t].status ~= 2 then
        self.receiving = true
      end
    end
  end
  self.red = #self.treatIds > 0
  local sort = {
    [1] = 99,
    [0] = 9,
    [2] = 0
  }
  table.sort(t, function(a, b)
    if sort[a.status] == sort[b.status] then
      return a.level < b.level
    else
      return sort[a.status] > sort[b.status]
    end
  end)
  return t
end

function class:getAllRewardId()
  return self.treatIds
end

function class:getRewardByServer(ids)
  local t = {}
  for i, v in ipairs(ids) do
    if self.taskItems[v] then
      table.insert(t, self.taskItems[v])
    end
  end
  return t
end
