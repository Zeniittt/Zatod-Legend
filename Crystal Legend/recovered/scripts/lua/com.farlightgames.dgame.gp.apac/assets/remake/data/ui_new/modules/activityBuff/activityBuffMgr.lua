local activityBuffMgr = {}
ed.activityBuffMgr = activityBuffMgr
local instance

function activityBuffMgr.getInstance()
  if not instance then
    instance = activityBuffMgr.create()
  end
  return instance
end

function activityBuffMgr.create()
  local self = {}
  setmetatable(self, {__index = activityBuffMgr})
  self:init()
  return self
end

function activityBuffMgr:init()
  self.buff = {}
  self.extraBuffInfo = {}
  self.timer = nil
  self.eventScope = {}
  self:initDataTable()
  self:initTimer()
  self:addEventListener()
end

function activityBuffMgr:initDataTable()
  self.activityConfig = ed.getDataTable("Activity")
  self.activityIconConfig = ed.getDataTable("ActivityIcon")
end

function activityBuffMgr:initTimer()
  self.timer = ListenTimer(Timer:Always(1), function()
    self:checkTimelyBuff()
  end, self.eventScope)
end

function activityBuffMgr:addBuff(buffId, buffData)
  if not self.buff[buffId] then
    self.buff[buffId] = buffData
    FireEvent("addBuff", buffId)
  else
    self:updateBuff(buffId, buffData)
  end
end

function activityBuffMgr:deleteBuff(param)
  local buffId = param.buffId
  local extraBuffType = param.extraBuffType
  if self.buff[buffId] then
    self.buff[buffId] = nil
  end
  if self.extraBuffInfo[extraBuffType] then
    self.extraBuffInfo[extraBuffType] = nil
  end
  FireEvent("deleteBuff", buffId, extraBuffType)
end

function activityBuffMgr:updateBuff(buffId, buffData)
  self.buff[buffId] = buffData
  FireEvent("updateBuff", buffId)
end

function activityBuffMgr:getBuff(buffId)
  return self.buff[buffId]
end

function activityBuffMgr:getBuffIconShow(buffId)
  local buffConfig = ed.getDataTable("Activity")[buffId]
  if buffConfig and buffConfig["Activity Type"] == "spar_stage_item_multi" then
    return ed.player:getLevel() >= 80
  end
  return true
end

function activityBuffMgr:addExtraBuff(type, extraBuffInfo)
  local endTime = extraBuffInfo.endTime
  if endTime and endTime <= ed.getServerTime() then
    return
  end
  self.extraBuffInfo[type] = extraBuffInfo
  FireEvent("addBuff", nil, type)
end

function activityBuffMgr:getExtraBuff(type)
  return self.extraBuffInfo[type]
end

function activityBuffMgr:getAllExtraBuff()
  return self.extraBuffInfo
end

function activityBuffMgr:getbuffByType(typeList)
  local buffList = {}
  for buffId, buffData in pairs(self.activityConfig or {}) do
    if (ed.isElementInTable(buffData["Activity Type"], typeList) or ed.tableEqual(typeList, {"all"})) and buffData["Activity Group"] == "system_settings" then
      table.insert(buffList, buffId)
    end
  end
  return buffList
end

function activityBuffMgr:getAllBuff()
  return self.buff
end

function activityBuffMgr:checkTimelyBuff()
  local delete = {}
  local deleteExtra = {}
  for buffId, buffData in pairs(self.buff) do
    local endTime = buffData.endTime
    if endTime and endTime <= ed.getServerTime() then
      table.insert(delete, buffId)
    end
  end
  for type, extraBuff in pairs(self.extraBuffInfo) do
    local endTime = extraBuff.endTime
    if endTime and endTime <= ed.getServerTime() then
      table.insert(deleteExtra, type)
    end
  end
  for index, buffId in ipairs(delete) do
    self:deleteBuff({buffId = buffId})
  end
  for index, type in ipairs(deleteExtra) do
    self:deleteBuff({extraBuffType = type})
  end
end

function activityBuffMgr:addEventListener()
end
