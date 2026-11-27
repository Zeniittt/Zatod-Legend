local function getFashionId()
  local dataObj = ed.taskData:getPageDataObj("pass")
  
  local dayPassInfo = dataObj:getDayPassInfo()
  local lv = 0
  for i, v in ipairs(dayPassInfo) do
    lv = v.level or lv
  end
  local fashionId = 0
  
  local function func()
    local items = dataObj:getAdvancedRewardToLevel(lv) or {}
    for i, v in ipairs(items) do
      if v.id and v.id > 0 then
        local id = ed.getDataTable("equip")[v.id]["Fashion ID"]
        if id then
        end
        fashionId = 0 < id and id or fashionId or fashionId
      end
    end
    if 0 < #items and fashionId <= 0 and 0 < lv then
      lv = lv - 1
      return func()
    else
      return fashionId
    end
  end
  
  return func()
end

local task_ui_res = {
  "UI/alpha/1080P/taskModel/task_pop_bg.png",
  "UI/alpha/1080P/taskModel/task_pop_bg_2.png",
  "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_right_bg.png",
  "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_card_top.png",
  "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_item_bg.png",
  "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_card_img.jpg",
  "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_left_bg.jpg",
  "UI/alpha/1080P/taskModel/pass_task/pass_task_left_warrior_log.png"
}

local function prepareLoadRes()
  ed.ui.taskScene.DailyPassReplyInTime = true
  local fashion_id = getFashionId()
  print("fashion_id", fashion_id)
  if not fashion_id or fashion_id == 0 then
    print("[---   find fashion_id nil !!!   ---]")
  end
  local preloadList = {}
  local cardres = ed.lookupDataTable("Fashion", "Art Switch", fashion_id)
  table.insert(preloadList, {type = "image", res = cardres})
  local fashion_spine_res = ed.lookupDataTable("Fashion", "Art Spine", fashion_id)
  local fashion_effect_res = ed.lookupDataTable("Fashion", "Art Fca", fashion_id)
  if fashion_effect_res and fashion_id == 13 and not ed.isAreaZhCn() then
    fashion_effect_res = fashion_effect_res .. "_globe"
  end
  if fashion_spine_res and ed.isSupportSpine() then
    print("fashion_spine_res", fashion_spine_res)
    table.insert(preloadList, {
      type = "image",
      res = string.format("spine/effect/%s/%s.png", fashion_spine_res, fashion_spine_res)
    })
  elseif fashion_effect_res then
    print("fashion_effect_res", fashion_effect_res)
  end
  for i, v in ipairs(task_ui_res) do
    table.insert(preloadList, {type = "image", res = v})
  end
  ed.asyncload.preloadByList(preloadList)
  ed.asyncload.registLoadingListener(function(...)
    print("asyncload finish!")
  end)
end

local preload_inmainscene = {}
preload_inmainscene.scope = {}
preload_inmainscene.taskPassData = false
ed.preload_inmainscene = preload_inmainscene

local function preloadInMainScene()
  if ed.playerlimit.getAreaUnlockPrompt("DailyPass") then
    return
  end
  if ed.preload_inmainscene.taskPassData then
    prepareLoadRes()
    return
  end
  CloseScope(ed.preload_inmainscene.scope)
  ListenEvent("activityCrossDays", function()
    ed.preload_inmainscene.taskPassData = false
  end, ed.preload_inmainscene.scope)
  ed.taskNetwork:taskPassPush()
  CloseEvent("DailyPassReply")
  ListenEvent("DailyPassReply", function()
    CloseEvent("DailyPassReply")
    ed.preload_inmainscene.taskPassData = true
    prepareLoadRes()
  end)
end

ed.preloadInMainScene = preloadInMainScene
