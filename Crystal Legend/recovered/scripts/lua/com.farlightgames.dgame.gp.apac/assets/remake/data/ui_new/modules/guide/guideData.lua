local guideData = {}

local function init(self)
  ed.defineProperty(self, "records", {})
  self.undoneGuideIds = {}
  return self
end

function guideData:initGuideRecords(records)
  records = records or {}
  self:setRecords(records)
  self:initUndoneData()
  FireEvent(ed.guide.eventNames.GUIDE_DATA_READY)
end

function guideData:initUndoneData()
  for i, v in ipairs(self:getStaticData()) do
    local record = self:getRecordValue(i)
    self:setRecordValue(i, record)
    if not v.IsHide and not self:isCompleted(i) then
      self.undoneGuideIds[i] = i
    end
  end
end

function guideData:getUndoneIds()
  return self.undoneGuideIds
end

function guideData:init(id)
  local record = self:getRecordValue(id)
  self:setRecordValue(id, record + 1)
  local data = self:getStaticData(id)
  if data.IsKeyGuide then
    local msg = ed.upmsg.tutorial()
    msg._record = self:getRecords()
    ed.send(msg, "tutorial")
  end
end

function guideData:saveRecord(id)
  local record = self:getRecordValue(id)
  self:setRecordValue(id, record + 1)
  local data = self:getStaticData(id)
  if self:isCompleted(id) then
    self.undoneGuideIds[id] = nil
  end
  if data.IsKeyGuide then
    local msg = ed.upmsg.tutorial()
    msg._record = self:getRecords()
    ed.pt(msg)
    ed.send(msg, "tutorial")
  end
end

function guideData:isCompleted(id)
  if ed.guide.manager.isClosed then
    return true
  end
  local data = self:getStaticData(id)
  local record = self:getRecordValue(id)
  if id == 27 then
    local hero = ed.player:getHero(4)
    if hero then
      return true
    end
  elseif id == 47 or id == 48 or id == 49 then
    local finishedTask = ed.player:getFinishedTask()
    for k, v in pairs(finishedTask or {}) do
      if v._task_line == 3 then
        return true
      end
    end
    for k, v in pairs(ed.player._tasks or {}) do
      if v._line == 3 and v._id ~= 1 then
        return true
      end
    end
  end
  return record >= (data.TriggerTimes or 1)
end

function guideData:isCanGuide(id)
  local data = self:getStaticData(id)
  if not data.PreID or data.PreID == 0 then
    return not self:isCompleted(id)
  end
  return not self:isCompleted(id) and self:isCompleted(data.PreID)
end

function guideData:getRecordValue(id)
  return self:getRecords()[id] or 0
end

function guideData:setRecordValue(id, value)
  self:getRecords()[id] = value
end

function guideData:recordTrigger(id)
  local key = ed.getRoleKey("GUIDE-ID-" .. id)
  local num = ed.storage.getInt(key) or 0
  ed.storage.setValue(key, num + 1)
end

function guideData:isTriggered(id)
  local key = ed.getRoleKey("GUIDE-ID-" .. id)
  local num = ed.storage.getInt(key) or 0
  return 0 < num
end

function guideData:getStaticData(id)
  return id and ed.getDataTable("Guide")[id] or ed.getDataTable("Guide")
end

function guideData:getDialogData(id)
  return ed.getDataTable("Dialogue")[id]
end

function guideData:clear()
  self.undoneGuideIds = {}
  for i, v in ipairs(self:getStaticData()) do
    self:setRecordValue(i, v.TriggerTimes)
  end
  local msg = ed.upmsg.tutorial()
  msg._record = self:getRecords()
  ed.send(msg, "tutorial")
end

ed.guide.data = init(guideData)
