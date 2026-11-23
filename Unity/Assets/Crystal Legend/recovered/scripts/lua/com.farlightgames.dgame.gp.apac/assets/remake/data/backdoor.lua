local class = newclass("g")
Backdoor = class
setfenv(1, class)
version = nil
content = nil
updateFlag = false
targetVersion = nil

function init(ver, data)
  if updateFlag and targetVersion == ver then
    updateFlag = nil
  end
  version = ver
  content = data
  if data then
    local func, err = loadstring(data)
    if err then
      EDDebug(err)
      return
    else
      return func()
    end
  end
end

function setTargetVersion(ver)
  updateFlag = true
  targetVersion = ver
end

function load()
  if updateFlag then
    local msg = ed.upmsg.update_backdoor()
    ed.send(msg, "update_backdoor")
  end
end
