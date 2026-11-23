local class = newclass("g")
ed.ui.rechargeGiftNetwork = class
local checkTag

local function triggerCheckTag()
  checkTag = true
end

class.triggerCheckTag = triggerCheckTag

local function resetCheckTag()
  checkTag = nil
end

class.resetCheckTag = resetCheckTag

local function updateRechargeGiftActivity(activity_infos)
  if checkTag and not activity_infos._activity_info then
    ed.player:resetRechargeGiftActivityid()
  end
  resetCheckTag()
end

class.updateRechargeGiftActivity = updateRechargeGiftActivity

local function dealRechargeGiftActivityReply(activity_infos)
  if not activity_infos then
    return
  end
  local activity = activity_infos._activity_info[1]
  if activity._type == "charge_gift" then
    local handler = ed.getNetReply("activity_infos")
    if handler then
      handler(activity)
    end
  end
end

class.dealRechargeGiftActivityReply = dealRechargeGiftActivityReply
