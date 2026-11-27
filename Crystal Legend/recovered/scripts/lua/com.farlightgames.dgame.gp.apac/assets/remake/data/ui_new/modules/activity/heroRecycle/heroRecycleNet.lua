local class = newclass("g")
ed.HeroRecycleNet = class
class.debug = false

function class.dispatch(reply)
  if class.debug then
    print("-------------HeroRecycleNet:replyReq--------------")
    ed.pt(reply)
  end
  local heroRecycleMgr = ed.HeroRecycleMgr.getInstance()
  if reply._check then
    heroRecycleMgr:handleCheck(reply._check)
  elseif reply._preview then
    heroRecycleMgr:handlePreview(reply._preview)
  end
end

function class.notify(reply)
  if class.debug then
    print("-------------HeroRecycleNet:notify reply--------------")
    ed.pt(reply)
  end
  local rogueLikeMgr = ed.rogueLikeMgr.getInstance()
  rogueLikeMgr:handleNotify(reply)
end

function class.createReq()
  local req = ed.upmsg.hero_recycle_req()
  return req
end

function class.sendReq(req)
  if class.debug then
    print("-------------heroRecycleNet:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "hero_recycle")
end

function class.sendRecycleCheck(heroId)
  local req = class.createReq()
  req._check = ed.upmsg.hero_recycle_check()
  req._check._hero_id = heroId
  class.sendReq(req)
end

function class.sendRecyclePreview(heroId)
  local req = class.createReq()
  req._preview = ed.upmsg.hero_recycle_preview()
  req._preview._hero_id = heroId
  class.sendReq(req)
end
