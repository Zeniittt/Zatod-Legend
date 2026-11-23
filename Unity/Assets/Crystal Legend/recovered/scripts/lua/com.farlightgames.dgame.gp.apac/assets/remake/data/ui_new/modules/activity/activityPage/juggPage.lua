local class = {}
ed.ui.ActivityJuggPage = class
local ItemStateConfig = {
  [1] = {
    nameColor1 = ed.toccc3(16049584),
    nameStroke1 = ed.toccc3(8218661),
    nameColor2 = ed.toccc3(15854032),
    nameStroke2 = ed.toccc3(8218661),
    color = ccc3(255, 231, 124),
    strokeColor = ed.toccc3(12549645),
    Path1 = "UI/alpha/1080P/activity/jugg/jugg_colour_gold_bg.png",
    Path2 = "UI/alpha/1080P/activity/jugg/jugg_colour_gold_bg2.png"
  },
  [2] = {
    nameColor1 = ed.toccc3(16367707),
    nameStroke1 = ed.toccc3(10179856),
    nameColor2 = ed.toccc3(16109209),
    nameStroke2 = ed.toccc3(10179856),
    color = ccc3(255, 207, 93),
    strokeColor = ed.toccc3(11621942),
    Path1 = "UI/alpha/1080P/activity/jugg/jugg_colour_yellow_bg.png",
    Path2 = "UI/alpha/1080P/activity/jugg/jugg_colour_yellow_bg2.png"
  },
  [3] = {
    nameColor1 = ed.toccc3(16023860),
    nameStroke1 = ed.toccc3(6438196),
    nameColor2 = ed.toccc3(15638140),
    nameStroke2 = ed.toccc3(6438196),
    color = ccc3(243, 155, 112),
    strokeColor = ed.toccc3(6499869),
    Path1 = "UI/alpha/1080P/activity/jugg/jugg_colour_brown_bg.png",
    Path2 = "UI/alpha/1080P/activity/jugg/jugg_colour_brown_bg2.png"
  },
  [4] = {
    nameColor1 = ed.toccc3(16142903),
    nameStroke1 = ed.toccc3(5776411),
    nameColor2 = ed.toccc3(15631740),
    nameStroke2 = ed.toccc3(5649456),
    color = ccc3(243, 154, 120),
    strokeColor = ed.toccc3(7680283),
    Path1 = "UI/alpha/1080P/activity/jugg/jugg_colour_red_bg.png",
    Path2 = "UI/alpha/1080P/activity/jugg/jugg_colour_red_bg2.png"
  },
  [5] = {
    nameColor1 = ccc3(201, 212, 173),
    nameStroke1 = ed.toccc3(5069369),
    nameColor2 = ed.toccc3(13159868),
    nameStroke2 = ed.toccc3(5069369),
    color = ccc3(212, 251, 145),
    strokeColor = ed.toccc3(5660220),
    Path1 = "UI/alpha/1080P/activity/jugg/jugg_colour_green_bg.png",
    Path2 = "UI/alpha/1080P/activity/jugg/jugg_colour_green_bg2.png"
  }
}
class.ItemStateConfig = ItemStateConfig
local TASK_STATE_TODO = "todo"
local TASK_STATE_AVAILABLE = "available"
local TASK_STATE_FINISHED = "finished"
class.TASK_STATE_TODO = TASK_STATE_TODO
class.TASK_STATE_AVAILABLE = TASK_STATE_AVAILABLE
class.TASK_STATE_FINISHED = TASK_STATE_FINISHED

function class.create(base, param, pageKey)
  local self = {}
  setmetatable(class, {__index = base})
  setmetatable(self, {__index = class})
  self:init(param, pageKey)
  return self
end

function class:init(param, pageKey)
  self.pageKey = pageKey or ""
  self.param = param
  self.allTaskList = param._tasks or {}
  self.endTime = param._end_time
  self.activityId = param._id
  self.cfgId = param._cfg_id
  self.isVisible = true
  self.taskState = TASK_STATE_TODO
  self.objWork:activityPull(self.activityId)
  self:initTask()
  self:initView()
  self:addTouchEvent()
  self:addListenEvent()
end

function class:initTask()
  if #self.allTaskList <= 0 then
    return
  end
  self.itemExchangeTask = self.allTaskList[1]
  self.itemGroupId = self.itemExchangeTask._cond_id
  self:initTaskState()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.activity_jugg_page)
  self.container = container
  self.ui = ui
  ed.UITool.setPositionBy(self.ui.image_art_avatar_unlock, ccp(63, -27.5))
  self:adaptUI()
  self:initLabel()
  self:initHero()
  self:initEffect()
  self:initParticle()
  self:refreshUI()
  self:startCountDown()
  for index = 1, 5 do
    local rotateAction = CCRepeatForever:create(CCRotateBy:create(15, 360, 360))
    self.ui["item_frame" .. index]:runAction(rotateAction)
  end
end

function class:adaptUI()
  local offsetWidth = ed.display.winSize.width - 960
  for index = 1, 5 do
    local item_bg = self.ui["item_bg" .. index]
    ed.UITool.setPositionBy(item_bg, ccp(-40 + offsetWidth / 6, 0))
  end
  ed.UITool.setPositionBy(self.ui.left_time_bg, ccp(-40 + offsetWidth / 6, 0))
  ed.UITool.setPositionBy(self.ui.image_get, ccp(-40 + offsetWidth / 6, 0))
  ed.UITool.setPositionBy(self.ui.all_item_bg, ccp(-40 + offsetWidth / 6, 0))
end

function class:initParticle()
  local particle1 = CCParticleSystemQuad:create("UI/particle/jinlizi.plist")
  particle1:setScaleX(-1)
  self.ui.image_bg:addChild(particle1, 0)
  particle1:setPosition(ccp(470, 540))
  local particle2 = CCParticleSystemQuad:create("UI/particle/jinlizi.plist")
  self.ui.image_bg:addChild(particle2, 0)
  particle2:setPosition(ccp(760, 540))
  local chijin = CCParticleSystemQuad:create("UI/particle/chijin.plist")
  self.itemPlist1 = chijin
  self.ui.item_bg1:addChild(chijin, 1)
  chijin:setPosition(ccp(110, 55))
  local xionghuang = CCParticleSystemQuad:create("UI/particle/xionghuang.plist")
  self.itemPlist2 = xionghuang
  self.ui.item_bg2:addChild(xionghuang, 1)
  xionghuang:setPosition(ccp(110, 55))
  local yanzhe = CCParticleSystemQuad:create("UI/particle/yanzhe.plist")
  self.itemPlist3 = yanzhe
  self.ui.item_bg3:addChild(yanzhe, 1)
  yanzhe:setPosition(ccp(110, 55))
  local chensha = CCParticleSystemQuad:create("UI/particle/chensha.plist")
  self.itemPlist4 = chensha
  self.ui.item_bg4:addChild(chensha, 1)
  chensha:setPosition(ccp(110, 55))
  local facui = CCParticleSystemQuad:create("UI/particle/facui.plist")
  self.itemPlist5 = facui
  self.ui.item_bg5:addChild(facui, 1)
  facui:setPosition(ccp(110, 55))
end

function class:initEffect()
  local juggFashionEff = ed.createSpine("effect/eff_JUGG_fashion_1_ui_art/eff_JUGG_fashion_1_ui_art", 0.54)
  self.juggFashionEff = juggFashionEff
  self.juggFashionEff:setAnimation(0, "Idle", true)
  self.juggFashionEff:setVisible(false)
  juggFashionEff:setPosition(ccp(463, 60))
  self.ui.image_bg:addChild(juggFashionEff, 2)
  local skinBtn = ed.createSpine("effect/eff_UI_JUGG_skin_button/eff_UI_JUGG_skin_button", 0.5)
  skinBtn:setAnimation(0, "Idle", true)
  skinBtn:setPosition(ccp(78, 81))
  self.ui.image_activate:addChild(skinBtn, 1)
  local skinClick = ed.createFcaActor("eff_UI_JUGG_skin_click")
  skinClick:setAction("Loop")
  skinClick:setLoop(true)
  self:addFca(skinClick)
  skinClick:setPosition(ccp(79.5, 82.5))
  self.ui.image_activate:addChild(skinClick, 1)
  local cloudEff = ed.createSpine("effect/eff_UI_JUGG_skin_cloud/eff_UI_JUGG_skin_cloud", 0.5)
  self.cloudEff = cloudEff
  cloudEff:setAnimation(0, "Idle", true)
  cloudEff:setPosition(ccp(545, 655))
  self.ui.image_bg:addChild(cloudEff, 2)
end

function class:showUnlockAction(callBack)
  self.ui.image_sun_bg:setVisible(false)
  self.ui.btn_activate:setVisible(false)
  self.ui.image_sun_lock:setVisible(false)
  self.ui.all_item_bg:setVisible(false)
  self.ui.left_time_bg:setVisible(false)
  for index = 1, 5 do
    self.ui["item_bg" .. index]:setVisible(false)
  end
  local artUnlockEff = ed.createFcaActor("eff_UI_JUGG_skin_exchange")
  artUnlockEff:setAction("Start")
  artUnlockEff:setLoop(false)
  self:addFca(artUnlockEff)
  self.ui.image_bg:addChild(artUnlockEff, 999)
  artUnlockEff:setPosition(ccp(580, 360))
  self:listenTimer(Timer:Once(0.8), function()
    self:showClipShader()
    self.ui.image_art_avatar_unlock:setScale(1.2)
    local scaleAction1 = CCScaleTo:create(0.3, 1.08)
    local callFunc = CCCallFunc:create(function()
      self:unlockActionEnd(callBack)
    end)
    self.ui.image_art_avatar_unlock:runAction(CCSequence:create(ccArrayMake(scaleAction1, callFunc)))
  end)
end

function class:unlockActionEnd(callBack)
  self.ui.image_art_avatar_lock:runAction(CCFadeTo:create(1, 0))
  self.ui.image_art_avatar_unlock:runAction(CCFadeTo:create(1, 0))
  local delay1 = CCDelayTime:create(0.25)
  local callFunc1 = CCCallFunc:create(function()
    self.juggFashionEff:setVisible(true)
    self.juggFashionEff:setAnimation(0, "Idle", true)
  end)
  local delay2 = CCDelayTime:create(1.2)
  local callFunc2 = CCCallFunc:create(function()
    if callBack then
      callBack()
    end
  end)
  local action = CCSequence:create(ccArrayMake(delay1, callFunc1, delay2, callFunc2))
  self.juggFashionEff:runAction(action)
end

function class:showClipShader()
  self.ui.image_art_avatar_unlock:setVisible(true)
  local size = self.ui.image_art_avatar_unlock:getContentSize()
  ed.useShader(self.ui.image_art_avatar_unlock, "ClipSpriteCircle")
  local shader = self.ui.image_art_avatar_unlock:getShaderProgram()
  local location = shader:getUniformLocationForName("resolution")
  shader:setUniformLocationWith2f(location, size.width, size.height)
  local location = shader:getUniformLocationForName("circleCenter")
  shader:setUniformLocationWith2f(location, size.width / 2.63, size.height / 2)
  local location = shader:getUniformLocationForName("virtualRadius")
  shader:setUniformLocationWith2f(location, 75, 75)
  local startRadius = 50
  local endRadius = 400
  local location = shader:getUniformLocationForName("radius")
  shader:setUniformLocationWith2f(location, startRadius, startRadius)
  local tick = 0
  local m_fRate = 4
  local speed = 10
  self:listenTimer(Timer:Always(0.016666666666666666, "showClip"), function(dt)
    tick = tick + dt
    local time = math.pow(tick, 1 / m_fRate)
    startRadius = startRadius + time * speed
    startRadius = math.min(startRadius, endRadius)
    if endRadius == startRadius then
      CloseTimer("showClip")
      return
    end
    shader:use()
    shader:setUniformLocationWith2f(location, startRadius, startRadius)
  end)
end

function class:initTaskState()
  local isAllTaskFinish = self.itemExchangeTask._cur_reward_times >= self.itemExchangeTask._max_reward_times
  local itemGroupId = self.itemExchangeTask._cond_id
  local state
  if isAllTaskFinish then
    state = TASK_STATE_FINISHED
  else
    local hasAllItem = true
    for index, itemCfg in ipairs(ed.getDataTable("ActivityItemGroup")[itemGroupId] or {}) do
      local itemId = itemCfg["Item ID"]
      local needAmount = itemCfg["Item Amount"]
      if needAmount > ed.player:getEquipAmount(itemId) then
        hasAllItem = false
      end
    end
    if hasAllItem then
      state = TASK_STATE_AVAILABLE
    else
      state = TASK_STATE_TODO
    end
  end
  self.taskState = state
end

function class:getTaskState()
  return self.taskState
end

function class:initHero()
  local heroId = 27
  local fashionId = 272
  local puppet, cha = ed.readhero.getActor(heroId, "Idle", true, false, fashionId, false)
  self.puppet = puppet
  puppet:setPosition(128, 30)
  self.ui.hero_bg:addChild(puppet, 10)
  self:addFca(puppet)
  local actions = {}
  local row = ed.getDataTable("AnimDuration")[cha]
  for k, v in pairs(row or {}) do
    if not ed.isElementInTable(k, {"Idle"}) then
      table.insert(actions, {
        act = k,
        time = v.Duration
      })
    end
  end
  self.actions = actions
end

function class:initLabel()
  for index = 1, 5 do
    self.ui["item_name" .. index]:setFontName(ed.fontBold)
  end
  self.ui.label_activate:setFontName(ed.fontBold)
  self.ui.label_unlock:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_activate, ed.toccc3(16776888), 1)
  ed.setLabelStroke(self.ui.label_unlock, ed.toccc3(16776427), 1)
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(9263891), 1)
end

function class:startCountDown()
  self:refreshCountDown()
  self:listenTimer(Timer:Always(1), function()
    self:refreshCountDown()
  end)
end

function class:refreshCountDown()
  local leftTime = self.endTime - ed.getServerTime()
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  if day <= 0 and hour <= 0 then
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\230\151\182%s\229\136\134", hour, min))
  else
    self.ui.label_left_time:setString(T("\229\137\169\228\189\153 %s\229\164\169%s\230\151\182", day, hour))
  end
end

function class:refreshItem(index)
  local taskState = self:getTaskState()
  self.ui["item_bg" .. index]:setVisible(taskState ~= TASK_STATE_FINISHED)
  local labelState = self.ui["label_item_state" .. index]
  local labelName = self.ui["item_name" .. index]
  local itemGroupCfg = ed.getDataTable("ActivityItemGroup")[self.itemGroupId][index]
  if not itemGroupCfg then
    return
  end
  local itemId = itemGroupCfg["Item ID"]
  local needAmount = itemGroupCfg["Item Amount"]
  local haveItem = needAmount <= ed.player:getEquipAmount(itemId)
  local itemCfg = ItemStateConfig[index]
  if haveItem then
    self.ui["image_unlock" .. index]:setVisible(true)
    self.ui["item_frame" .. index]:setVisible(true)
    self.ui["item" .. index]:setVisible(true)
    self.ui["item" .. index .. "_grey"]:setVisible(false)
    ed.setTexture(self.ui["item_bg" .. index], itemCfg.Path1)
    ed.setLabelColor(labelState, itemCfg.color)
    ed.setLabelStroke(labelState, itemCfg.strokeColor, 1)
    ed.setLabelString(labelState, T("\229\183\178\232\142\183\229\190\151"))
    ed.setLabelColor(labelName, itemCfg.nameColor1)
    ed.setLabelStroke(labelName, itemCfg.nameStroke1, 1)
    self["itemPlist" .. index]:setVisible(true)
  else
    self.ui["image_unlock" .. index]:setVisible(false)
    self.ui["item_frame" .. index]:setVisible(false)
    self.ui["item" .. index]:setVisible(false)
    self.ui["item" .. index .. "_grey"]:setVisible(true)
    ed.setLabelColor(labelName, itemCfg.nameColor2)
    ed.setLabelStroke(labelName, itemCfg.nameStroke2, 1)
    self["itemPlist" .. index]:setVisible(false)
    ed.setTexture(self.ui["item_bg" .. index], itemCfg.Path2)
    ed.setLabelColor(labelState, ccc3(255, 241, 192))
    ed.setLabelStroke(labelState, ed.toccc3(14193184), 1)
    ed.setLabelString(labelState, T("\229\142\187\232\142\183\229\143\150"))
  end
end

function class:refreshUI()
  local taskState = self:getTaskState()
  for index = 1, 5 do
    self:refreshItem(index)
  end
  if taskState == TASK_STATE_FINISHED then
    self.ui.all_item_bg:setVisible(false)
    self.ui.image_sun_lock:setVisible(false)
    self.ui.btn_activate:setVisible(false)
    self.ui.image_sun_bg:setVisible(false)
    self.ui.image_get_bg:setVisible(true)
    self.ui.left_time_bg:setVisible(false)
    self.ui.image_art_avatar_lock:setVisible(false)
    self.ui.image_art_avatar_unlock:setVisible(false)
    self.juggFashionEff:setVisible(true)
  else
    self.ui.all_item_bg:setVisible(true)
    self.ui.image_sun_lock:setVisible(true)
    self.ui.left_time_bg:setVisible(true)
    self.ui.image_get_bg:setVisible(false)
    self.ui.image_art_avatar_lock:setVisible(true)
    self.ui.image_art_avatar_unlock:setVisible(false)
    self.juggFashionEff:setVisible(false)
    if taskState == TASK_STATE_AVAILABLE then
      self.ui.image_sun_bg:setVisible(false)
      self.ui.btn_activate:setVisible(true)
    else
      self.ui.image_sun_bg:setVisible(true)
      self.ui.btn_activate:setVisible(false)
    end
  end
end

function class:setVisibleCallBack(isVisible)
  self.isVisible = isVisible
end

function class:pageUpDate(param)
  self.param = param
  self.allTaskList = param._tasks or {}
  self.endTime = param._end_time
  self.activityId = param._id
  local oldTaskState = self.taskState
  self:initTask()
  if self.taskState == TASK_STATE_FINISHED and oldTaskState ~= TASK_STATE_FINISHED then
    for index = 1, 5 do
      local itemGroupCfg = ed.getDataTable("ActivityItemGroup")[self.itemGroupId][index]
      if not itemGroupCfg then
        break
      end
      ed.player:consumeEquip(itemGroupCfg["Item ID"], 1)
    end
  end
  self:refreshUI()
end

function class:onClickPuppet()
  if self.isRunningAction then
    return
  end
  local actions = ed.copyProto(self.actions)
  if self.oldIdx then
    table.remove(actions, self.oldIdx)
  end
  self.oldIdx = math.random(1, #actions)
  local action = actions[self.oldIdx].act
  self.puppet:setAction(action)
  self.puppet:setLoop(action == "Move")
  self.isRunningAction = true
  self:listenTimer(Timer:Once(actions[self.oldIdx].time), function()
    self.puppet:setAction("Idle")
    self.puppet:setLoop(true)
    self.isRunningAction = false
  end)
end

function class:onClickUnlockBtn()
  ed.showToast(T("\229\176\154\230\156\170\233\155\134\233\189\144\230\137\128\230\156\137\233\129\147\229\133\183"))
end

function class:onClickActivateBtn()
  self:showUnlockAction(function()
    self.objWork:activitySubmit(self.activityId, self.itemExchangeTask._id)
    self.objWork:activityPull(self.activityId)
  end)
end

function class:onClickItem(index)
  local itemGroupCfg = ed.getDataTable("ActivityItemGroup")[self.itemGroupId][index]
  if not itemGroupCfg then
    return
  end
  local itemId = itemGroupCfg["Item ID"]
  ed.ui.packageDetailWin.create({id = itemId}):popWindow()
end

function class:addTouchEvent()
  self:btRegisterButtonClick({
    button = self.ui.hero_bg,
    key = "hero_bg",
    force = true,
    mcpMode = true,
    clickHandler = function()
      self:onClickPuppet()
    end
  })
  ed.UITool.registerBtn(self, "btn_unlock", function()
    self:onClickUnlockBtn()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_activate", function()
    self:onClickActivateBtn()
  end, {pressScale = 0.98})
  for index = 1, 5 do
    ed.UITool.registerBtn(self, "item_bg" .. index, function()
      self:onClickItem(index)
    end, {pressScale = 0.98, priority = index})
  end
end

function class:addListenEvent()
  self:listenEvent("ResourceNumChange", function(type, itemId)
    for index = 1, 5 do
      local itemGroupCfg = ed.getDataTable("ActivityItemGroup")[self.itemGroupId][index]
      if not itemGroupCfg then
        return
      end
      if itemId == itemGroupCfg["Item ID"] then
        self:initTaskState()
        self:refreshUI()
        return
      end
    end
  end)
end
