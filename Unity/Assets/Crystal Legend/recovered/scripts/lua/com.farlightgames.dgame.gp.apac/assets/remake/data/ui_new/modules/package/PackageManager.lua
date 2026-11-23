local PackageManager = {}
PackageManager.__index = PackageManager

function PackageManager.isDebug()
  return false
end

function PackageManager.isEnabled()
  return true
end

function PackageManager.getInstance()
  if not PackageManager.instance then
    PackageManager.instance = PackageManager.create()
  end
  return PackageManager.instance
end

function PackageManager.create()
  local self = {}
  setmetatable(self, PackageManager)
  self:initData()
  return self
end

function PackageManager:initData()
end
