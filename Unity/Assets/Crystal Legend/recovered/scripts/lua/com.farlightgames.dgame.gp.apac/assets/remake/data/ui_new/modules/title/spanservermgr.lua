local SpanServerMgr = {}
ed.SpanServerMgr = SpanServerMgr
local instance

function SpanServerMgr.getInstance()
  if instance == nil then
    instance = SpanServerMgr.create()
  end
  return instance
end

function SpanServerMgr.create()
  local self = {
    serverListData = {},
    roleData = {},
    eleData = {
      head = {},
      kuang = {},
      medal = {}
    },
    isRequestRoleData = false
  }
  setmetatable(self, SpanServerMgr)
  SpanServerMgr.__index = SpanServerMgr
  instance = self
  return self
end

function SpanServerMgr:setIsReqRoleData(isReq)
  self.isRequestRoleData = isReq
end

function SpanServerMgr:getIsReqRoleData()
  return self.isRequestRoleData
end

function SpanServerMgr:setServerListData(serverListData)
  if type(serverListData) ~= "table" then
    EDLog("Failed:-------------->setServerListData Failed")
    return
  end
  self.serverListData = serverListData
end

function SpanServerMgr:getServerNameBySerId(serId)
  for _, v in pairs(self.serverListData) do
    if tostring(serId) == tostring(v.id) then
      return v.name
    end
  end
  return T("")
end

function SpanServerMgr:setRoleData(accounts)
  if type(accounts) ~= "table" then
    EDLog("Failed:-------------->setRoleData Failed")
    return
  end
  table.sort(accounts, function(a, b)
    if a.level > b.level then
      return true
    elseif a.level == b.level and a.vip > b.vip then
      return true
    end
  end)
  self.roleData = accounts
end

function SpanServerMgr:getRoleData()
  return self.roleData
end

function SpanServerMgr:setEleData(data)
  if type(data) ~= "table" then
    EDLog("Failed:--------------->setEleData Failed")
    return
  end
  self.eleData = {
    head = {},
    kuang = {},
    medal = {}
  }
  local avatar_ids, avatar_frame_ids, medal_item = data._avatar_ids or {}, data._avatar_frame_ids or {}, data._medal_item or {}
  for _, v in ipairs(avatar_ids) do
    local id = ed.analyzeAvatar(v).avatar
    local row = ed.getDataTable("Avatar")[id]
    if not row then
      return
    end
    local res = row.Picture
    local is_dyna = row["Is Dynamic"]
    local avt_fca = row["Dynamic Model"]
    local avt_spine = row["Spine Dynamic Model"]
    local avt_scale = row.Scale
    local onValue = {
      id = v,
      res = res,
      is_dyna = is_dyna,
      avt_fca = avt_fca,
      avt_spine = avt_spine,
      avt_scale = avt_scale
    }
    table.insert(self.eleData.head, onValue)
  end
  for _, v in ipairs(avatar_frame_ids) do
    local fid = v
    if fid == 0 then
      fid = 1
    end
    local fres = ed.getDataTable("AvatarFrame")[fid]
    local fres = row.Picture
    local is_dyna = row["Is Dynamic"]
    local frame_fca = row["Dynamic Model"]
    local frame_spine = row["Spine Dynamic Model"]
    local frame_scale = row.Scale
    local onValue = {
      id = v,
      res = fres,
      is_dyna = is_dyna,
      frame_fca = frame_fca,
      frame_spine = frame_spine,
      frame_scale = frame_scale
    }
    table.insert(self.eleData.kuang, onValue)
  end
  for _, v in ipairs(medal_item) do
    local id = v.medal_id
    local res = ed.TitleMgr.getInstance():getOneTitleById(id).image
    local onValue = {id = id, res = res}
    table.insert(self.eleData.medal, onValue)
  end
end

function SpanServerMgr:getEleData()
  return self.eleData
end
