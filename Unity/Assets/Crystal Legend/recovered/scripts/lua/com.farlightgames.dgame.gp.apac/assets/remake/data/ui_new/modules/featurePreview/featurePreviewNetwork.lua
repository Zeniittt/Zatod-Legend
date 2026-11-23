local class = newclass("g")
ed.featurePreviewNetwork = class

function class.createReq()
  local req = ed.upmsg.feature_preview_req()
  return req
end

function class.sendReq(req)
  ed.send(req, "feature_preview")
end

function class.sendOpenPanel()
  local req = class.createReq()
  req._open_panel = ed.upmsg.feature_preview_open_panel()
  class.sendReq(req)
end

function class.sendFeaturePreviewReward(ids)
  local req = class.createReq()
  req._reward = ed.upmsg.feature_preview_reward()
  req._reward._ids = ids
  class.sendReq(req)
end

function class.dispatch(reply)
  if reply._open_panel then
    local data = ed.copyProto(reply._open_panel)
    ed.featurePreviewManager:setRewards(data._items or {})
    ed.ui.featurePreviewWindow.create():popWindow()
  elseif reply._reward then
    ed.featurePreviewManager:setRewardsToIds(reply._reward._ids)
    local rewards = ed.featurePreviewManager:getRewardByServer(reply._reward._ids or {})
    ed.player:addRewards(rewards)
    ed.UITool.showRewardsFromServer(rewards)
    FireEvent("featurePreviewWindowRefresh")
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.FEATURE_PREVIEW)
  end
end
