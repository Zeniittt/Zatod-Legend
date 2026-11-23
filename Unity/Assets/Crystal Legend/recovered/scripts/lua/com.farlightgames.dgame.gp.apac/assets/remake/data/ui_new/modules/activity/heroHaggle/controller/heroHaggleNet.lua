local class = newclass("g")
ed.heroHaggleNet = class
ed.heroHaggleNet.type = 2
class.debug = false

function class.dispatch(msg)
  if class.debug then
    print("-------------heroHaggleNet:replyReq--------------")
    ed.pt(msg)
  end
  local heroHaggleMgr = ed.heroHaggleMgr.getInstance()
  if msg._open_panel then
    heroHaggleMgr:handleOpenPanel(msg._open_panel)
  elseif msg._select_hero then
    heroHaggleMgr:handleSelectHero(msg._select_hero)
  elseif msg._haggle_price then
    heroHaggleMgr:handlerHagglePrice(msg._haggle_price)
  elseif msg._buy_hero then
    heroHaggleMgr:handleBuyHero(msg._buy_hero)
  end
end

function class.taskDispatch(msg)
  if class.debug then
    print("-------------heroHaggleNet:taskDispatch--------------")
    ed.pt(msg)
  end
  local type = ""
  if msg._open_panel then
    type = msg._open_panel._simple_assist._type
  elseif msg._get_task_rewards then
    type = msg._get_task_rewards._type
  elseif msg._get_line_rewards then
    type = msg._get_line_rewards._type
  end
  if type ~= "hero_haggle" then
    return
  end
  local heroHaggleMgr = ed.heroHaggleMgr.getInstance()
  if msg._open_panel then
    heroHaggleMgr:handleTaskOpenPanel(msg._open_panel)
  elseif msg._get_task_rewards then
    heroHaggleMgr:handleGetTaskRewards(msg._get_task_rewards)
  elseif msg._get_line_rewards then
    heroHaggleMgr:handleGetLineRewards(msg._get_line_rewards, self.tmpLineId)
  end
end

function class.notify(msg)
  if class.debug then
    print("-------------heroHaggleNet:notify reply--------------")
    ed.pt(msg)
  end
  local heroHaggleMgr = ed.heroHaggleMgr.getInstance()
  heroHaggleMgr:updateState(msg)
end

function class.notifyTask(data)
  data = ed.copyProto(data)
  data = data._reward_hints and data._reward_hints[2]
  if data and data._type ~= "hero_haggle" then
    return
  end
  if nil ~= data and nil ~= data._task then
    local heroHaggleMgr = ed.heroHaggleMgr.getInstance()
    heroHaggleMgr:setTaskRed(data._task)
  end
end

function class.createReq()
  local req = ed.upmsg.hero_haggle_req()
  return req
end

function class.sendReq(req)
  if class.debug then
    print("-------------heroHaggleNet:sendReq--------------")
    ed.pt(req)
  end
  ed.send(req, "hero_haggle")
end

function class:sendOpenPanel()
  local req = class.createReq()
  req._open_panel = ed.upmsg.hero_haggle_open_panel()
  class.sendReq(req)
end

function class:sendSelectHero(heroId)
  local req = class.createReq()
  self.selectHeroId = heroId
  req._select_hero = ed.upmsg.hero_haggle_select_hero()
  req._select_hero._hero_id = heroId
  class.sendReq(req)
end

function class:sendHeroHagglePrice()
  local req = class.createReq()
  req._haggle_price = ed.upmsg.hero_haggle_price()
  class.sendReq(req)
end

function class:getReq()
  return ed.upmsg.simple_assist_req()
end

function class:doSendReq(msg)
  ed.send(msg, "simple_assist")
end

function class:sendTaskOpenPanel()
  local msg = self:getReq()
  msg._open_panel = ed.upmsg.simple_assist_open_panel()
  msg._open_panel._type = ed.heroHaggleNet.type
  self:doSendReq(msg)
end

function class:sendGetTaskReward(taskId)
  self.tmpTaskId = taskId
  local msg = self:getReq()
  msg._get_task_rewards = ed.upmsg.simple_assist_get_task_rewards()
  msg._get_task_rewards._type = ed.heroHaggleNet.type
  msg._get_task_rewards._task_id = taskId
  self:doSendReq(msg)
end
