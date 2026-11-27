local base = ed.ui.basescene
local class = {}
class.__index = class
setmetatable(class, base.mt)
ed.ui.dragonBoatMainScene = class
ed.UITool.registViewOpenFunc("moonFestivalMainScene", function()
  if not ed.dragonBoatMgr:getInstance():isInRace() then
  end
  local scene = ed.ui.dragonBoatMainScene.create()
  ed.pushScene(scene)
  return scene
end)

function class.create()
  local self = base.create("moonFestivalRaceMainScene")
  setmetatable(self, class)
  self:init()
  return self
end

function class:init()
  self:initData()
  self:initUI()
  do return end
  self:initRedPoint()
  self:initNoticeBar()
  self:initBoatMgr()
  self:registerEvents()
  if self.mgr.openMovie then
    self:openMovie()
  else
    self:registerBtn()
  end
end

function class:initData()
  self.mgr = ed.dragonBoatMgr.getInstance()
  self.boatCurSpeed = self.mgr.start and self.mgr.getBoatSpeed(self.mgr.raceInfo._skin) or 0
  self.zongziCnt = ed.player:getEquipAmount(self.mgr.zongziItemId) or 0
  self.mgr.bgSpeed = self.mgr.normalBgSpeed
end

function class:createBtn(str, clickCallBack)
  local btn = ed.createSprite("UI/alpha/1080P/common/button_com_mini.png")
  local label = ed.createLabelTTF(str, 18)
  btn:addChild(label)
  label:limitSizeByScale(100, 40)
  ed.layout.centerInParent(label)
  self:btRegisterButtonClick({
    button = btn,
    key = str,
    clickHandler = function()
      clickCallBack()
    end,
    pressScale = 0.95
  })
  return btn
end

function class:initUI()
  self:setBackButton(function()
    self:close()
  end)
  local reward = self:createBtn("\229\165\150\229\138\177", function()
    ed.UITool.openView("moonFestivalRewardScene")
  end)
  reward:setPosition(ccp(100, 300))
  self.mainLayer:addChild(reward)
  local record = self:createBtn("\232\174\176\229\189\149", function()
    ed.ui.moonFestivalGiveRecordPop.create({}):popWindow()
  end)
  self.mainLayer:addChild(record)
  record:setPosition(ccp(200, 300))
  local pass = self:createBtn("\233\128\154\232\161\140\232\175\129", function()
    ed.ui.moonFestivalPassPop.create({controller = self}):popWindow()
  end)
  self.mainLayer:addChild(pass)
  pass:setPosition(ccp(300, 300))
  do return end
  local container, ui = ed.editorui(ed.uieditor.DragonBoatMainScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton(function()
    self:close()
  end)
  self:initLabel()
  self:initBG()
  self:adaptUI()
  local spine = ed.createSpine("effect/eff_UI_DragonBoat_reqi/eff_UI_DragonBoat_reqi", 0.5)
  self.spine = spine
  spine:setAnimation(0, "Idle", true)
  self.ui.reqi_pos:addChild(spine)
  self.spine:setVisible(0 < self.zongziCnt)
end

function class:initRedPoint()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("dragon_boat_reward_entry", self, {
    handle = function(value)
      self.ui.image_reward_red:setVisible(0 < value)
    end
  })
  self.redPointMgr:registerValueChange("dragon_boat_pass_entry", self, {
    handle = function(value)
      self.ui.image_pass_red:setVisible(0 < value)
    end
  })
end

function class:close()
  self.mgr.mainScene = nil
  ed.popScene()
end

function class:initLabel()
  local name = self.mgr:getActivityCfg()["Activity Name"]
  local title = ed.ui.gradientLabel.create({
    text = name,
    fontSize = 30,
    fontName = ed.fontBold,
    startColor = ed.toccc3(14677158),
    endColor = ed.toccc3(16383983),
    shadowColor = ccc3(39, 100, 105),
    shadowOffset = ccp(0, -2)
  })
  title.node:setAnchorPoint(ccp(0, 0.5))
  self.ui.label_title:addChild(title.node)
  title.node:setScale(math.min(1, 225 / title.node:getContentSize().width))
  self:updateLeftTime()
  ed.setLabelStroke(self.ui.label_left_time, ed.toccc3(1655099), 1.5)
  ed.setLabelStroke(self.ui.label_rank, ed.toccc3(1663532), 2.5)
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(1663532), 2.5)
  ed.setLabelStroke(self.ui.label_boat, ed.toccc3(1663532), 2.5)
  ed.setLabelStroke(self.ui.label_pass, ed.toccc3(1663532), 2.5)
  ed.setLabelStroke(self.ui.label_record, ed.toccc3(1663532), 2.5)
  ed.setLabelStroke(self.ui.label_can_eat, ed.toccc3(1392163), 1.5)
  ed.setLabelStroke(self.ui.label_get, ed.toccc3(11485953), 1.5)
  local cur_speed_txt = T("\232\136\170\233\128\159 %s \229\176\186/\230\151\182", string.format("<lable color=ccc3(149,255,55) fontSize=f18 strokeColor=ccc3(21,62,35) strokeSize=1 >%s</lable>", self.boatCurSpeed))
  local curSpeed = ed.ui.autoText.new()
  curSpeed:initParam({
    context = cur_speed_txt,
    fontSize = 15,
    color = ed.toccc3(10438151)
  })
  self.atCurSpeed = curSpeed
  local wid, _ = curSpeed:getCurContentSize()
  curSpeed.node:setPositionX(-wid * 0.5)
  self.ui.label_current_speed:addChild(curSpeed.node)
  local next_stage_txt = self.mgr.nextStageProgress < self.mgr.nextStageTotal and T("\228\184\139\233\152\182\230\174\181\229\165\150\229\138\177<lable color=ccc3(255,235,126) fontSize=f15> %s </lable>/%s\229\176\186", self.mgr.nextStageProgress, self.mgr.nextStageTotal) or T("")
  local nextStage = ed.ui.autoText.new()
  nextStage:initParam({
    context = next_stage_txt,
    fontSize = 15,
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(804921),
    stroeSize = 1
  })
  self.atNextStage = nextStage
  wid, _ = nextStage:getCurContentSize()
  nextStage.node:setPositionX(-wid * 0.5)
  self.ui.label_next_stage:addChild(nextStage.node)
  self.ui.ImageView_24382:setVisible(self.mgr.nextStageProgress < self.mgr.nextStageTotal)
end

function class:initBG()
  self.movedBGClass = ed.dragonBoatBGClass
  self.movedBGObj = {}
  local confs = ed.getDragonBoatBGConf()
  for ind, conf in ipairs(confs) do
    self.movedBGObj[ind] = self.movedBGClass.create({
      conf = conf,
      sceneSelf = self,
      container = self.ui.layer_BG
    })
  end
  self:preloadTexture()
end

function class:preloadTexture()
  local outPos = ccp(ed.display.winSize.width + 200, ed.display.winSize.height + 200)
  local layer_BG = self.ui.layer_BG
  local selfIconBg = ed.createSprite("UI/alpha/1080P/dragonboat/db_race/db_ziji_buttom.png")
  layer_BG:addChild(selfIconBg)
  selfIconBg:setPosition(outPos)
  local res = {
    "rank_1st.png",
    "rank_2nd.png",
    "rank_3rd.png"
  }
  for i = 1, 3 do
    local rankIcon = ed.createSprite("UI/alpha/1080P/toparena/rank/" .. res[i])
    layer_BG:addChild(rankIcon)
    rankIcon:setPosition(outPos)
    local haveRank = ed.createSprite(string.format("UI/alpha/1080P/dragonboat/db_race/flag%d_haverank.png", i))
    layer_BG:addChild(haveRank)
    haveRank:setPosition(outPos)
    local norank = ed.createSprite(string.format("UI/alpha/1080P/dragonboat/db_race/flag%d_norank.png", i))
    layer_BG:addChild(norank)
    norank:setPosition(outPos)
  end
end

function class:adaptUI()
  self.ui.layer_BG:setPosition(-ed.display.halfFixedWidth, 0)
  ed.layout.layoutWithMagin(self.ui.title_bg, {left = 65, top = 0})
  ed.layout.layoutWithMagin(self.ui.btn_rank, {left = 0})
  ed.layout.layoutWithMagin(self.ui.btn_reward, {left = 0})
  ed.layout.layoutWithMagin(self.ui.btn_boat, {left = 0})
  ed.layout.layoutWithMagin(self.ui.btn_pass, {left = 0})
  ed.layout.layoutWithMagin(self.ui.btn_record, {left = 0})
  ed.layout.layoutWithMagin(self.ui.current_speed_bg, {right = 110, top = 32}, true)
  local btnSize = self.ui.btn_use_zongzi:getContentSize()
  local btnScale = self.ui.btn_use_zongzi:getScaleX()
  local winS = ed.display.winSize
  self.ui.btn_use_zongzi:setPositionX(winS.width - btnSize.width * 0.5 * btnScale - 20 - ed.display.halfFixedWidth)
  self.ui.btn_use_zongzi:setPositionY(btnSize.height * 0.5 * btnScale + 20 - ed.display.halfFixedHeight * 0.6)
end

function class:showParticleEffect()
  local particle = CCParticleSystemQuad:create("UI/particle/fire_boat_heat.plist")
  self.particle = particle
  self.mainLayer:addChild(particle, 999)
  local winSize = ed.display.winSize
  local endPos = ccp(winSize.width / 2 - ed.display.halfFixedWidth, winSize.height / 2 - ed.display.halfFixedHeight)
  particle:setPosition(self.ui.btn_use_zongzi:getPosition())
  local actionMoveTo = CCEaseExponentialOut:create(CCMoveTo:create(0.7, endPos))
  local callFunc = CCCallFunc:create(function()
    particle:removeFromParentAndCleanup(true)
    self.particle = nil
  end)
  particle:runAction(ed.readaction.create({
    t = "seq",
    actionMoveTo,
    callFunc
  }))
  local delayTime = CCDelayTime:create(0.4)
  local callFuncAttack = CCCallFunc:create(function()
    local attack = CCParticleSystemQuad:create("UI/particle/fire_boat_heat2.plist")
    self.attackParticle = attack
    self.mainLayer:addChild(attack)
    attack:setPosition(endPos)
  end)
  if not self.particleNode then
    self.particleNode = CCNode:create()
    self.mainLayer:addChild(self.particleNode)
  end
  self.particleNode:runAction(ed.readaction.create({
    t = "seq",
    delayTime,
    callFuncAttack
  }))
end

function class:initBoatMgr()
  self.boatMgrClass = ed.dragonBoatBoatMgr
  self.boatMgr = self.boatMgrClass.create({
    container = self.ui.layer_BG,
    sceneSelf = self
  })
end

function class:registerEvents()
  self:registerOnEnterHandler("ZongziNumOnEnter", function()
    self:onEnterFunc()
  end)
  self:registerOnExitHandler("ZongziNumOnExit", function()
    self:onExitFunc()
  end)
  self:listenEvent("dragonBoatRefreshRewardStage", function()
    self:refreshRewardLabel()
  end)
  self:listenEvent("dragonBoatUpgrade", function(skin)
    self:refreshRewardLabel()
    self.boatMgr:doUpgrade(skin)
  end)
  self:listenEvent("DragonBoatSetRegisterTime", function(time)
    self.registerTime = time or ed.getServerTime()
  end)
  self:listenEvent("DragonBoatRefreshBoat", function(time)
    self:refreshBoat(time)
    self:refreshRewardLabel()
  end)
  self:registerUpdateHandler("dragonBoatUpdateBG", function(dt)
    for _, obj in ipairs(self.movedBGObj) do
      local conf = obj.conf
      if conf.continuity or conf.randomRange then
        obj:update(dt)
      end
    end
  end)
  self:registerUpdateHandler("dragonBoatCheckRefresh", function(dt)
    if not self.registerTime then
      return
    end
    if self.registerTime + 5 < ed.getServerTime() then
      self.registerTime = nil
      self.mgr:sendRace()
    end
  end)
  self:listenTimer(Timer:Always(1), function()
    self:updateLeftTime()
  end)
  self:listenEvent("dragonBoatNoticeQueue", function(txt)
    self:addNoticeQueue(txt)
    self:showNoticeBar()
  end)
  self:listenEvent("ResourceNumChange", function(resType, id)
    if id == self.mgr.zongziItemId then
      self:refreshZongziNum()
    end
  end)
end

function class:registerBtn()
  ed.UITool.registerBtn(self, "btn_pass", function()
    ed.ui.dragonBoatPassPop.create({controller = self}):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_rank", function()
    ed.UITool.openView("dragonBoatRankScene")
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.UITool.openView("dragonBoatRewardScene")
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_boat", function()
    ed.ui.dragonBoatBoatPop.create({
      boatLevel = self.mgr.skin + 1
    }):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_record", function()
    ed.dragonBoatNet:sendGiveRecord()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_rule", function()
    local rules = self.mgr:getActivityCfg().Rules
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = rules
    }):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_use_zongzi", function()
    if self.zongziCnt > 0 then
      ed.ui.dragonBoatUseZongziPop.create({
        controller = self,
        closeCallBack = function()
          self:showParticleEffect()
        end
      }):popWindow()
      self.ui.btn_use_zongzi:setScale(0.8)
    else
      ed.ui.dragonBoatPassPop.create({controller = self, page = "task"}):popWindow()
    end
  end, {pressScale = 0.77, normalScale = 0.8})
end

function class:updateLeftTime()
  local leftTime = self.mgr.endTime - ed.getServerTime()
  if leftTime <= 0 then
    self:close()
    ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
    self.redPointMgr:clearNode("dragon_boat_entry")
    FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.DRAGON_BOAT)
    return
  end
  ed.setLabelString(self.ui.label_left_time, T("\229\137\169\228\189\153 %s", ed.time2dhms(leftTime)))
end

function class.setAutoTextString(atNode, str, anchorX, anchorY)
  if not atNode or not str then
    return
  end
  local oriWid, oriHei = atNode:getCurContentSize()
  atNode.param.context = str
  atNode:initParam(atNode.param)
  if anchorX then
    local wid, _ = atNode:getCurContentSize()
    ed.UITool.setPositionBy(atNode.node, ccp((oriWid - wid) * anchorX, 0))
  end
  if anchorY then
    local _, hei = atNode:getCurContentSize()
    ed.UITool.setPositionBy(atNode.node, ccp(0, (hei - oriHei) * (1 - anchorY)))
  end
end

function class:refreshRewardLabel()
  self.boatCurSpeed = self.mgr.start and self.mgr.getBoatSpeed(self.mgr.skin) or 0
  local cur_speed_txt = T("\232\136\170\233\128\159 %s \229\176\186/\230\151\182", string.format("<lable color=ccc3(149,255,55) fontSize=f18 strokeColor=ccc3(21,62,35) strokeSize=1 >%s</lable>", self.boatCurSpeed))
  self.setAutoTextString(self.atCurSpeed, cur_speed_txt, 0.5)
  local next_stage_txt = self.mgr.nextStageProgress < self.mgr.nextStageTotal and T("\228\184\139\233\152\182\230\174\181\229\165\150\229\138\177<lable color=ccc3(255,235,126) fontSize=f15> %s </lable>/%s\229\176\186", self.mgr.nextStageProgress, self.mgr.nextStageTotal) or T("")
  self.setAutoTextString(self.atNextStage, next_stage_txt, 0.5)
  self.spine:setVisible(0 < self.zongziCnt)
  self.ui.ImageView_24382:setVisible(self.mgr.nextStageProgress < self.mgr.nextStageTotal)
end

function class:refreshZongziNum()
  self.zongziCnt = ed.player:getEquipAmount(self.mgr.zongziItemId) or 0
  ed.setLabelString(self.ui.label_zongzi_num, T("\230\149\176\233\135\143:%s", self.zongziCnt))
  self.ui.can_eat_bg:setVisible(self.zongziCnt > 0)
  self.ui.get_bg:setVisible(self.zongziCnt == 0)
  if self.zongziCnt == 0 and self.mgr.skin and 0 < self.mgr.skin then
    self.ui.btn_use_zongzi:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCScaleTo:create(1, 0.83), CCScaleTo:create(1, 0.8)))))
  else
    self.ui.btn_use_zongzi:stopAllActions()
  end
end

function class:onEnterFunc()
  if not self.mgr.start or self.mgr.start == 0 then
    ed.ui.dragonBoatBoatPop.create({boatLevel = 0}):popWindow()
  else
    self.boatMgr:refreshRace(self.registerTime ~= nil)
    self.registerTime = ed.getServerTime()
  end
  self:refreshZongziNum()
end

function class:onExitFunc()
  self.boatMgr:destroyBoats()
  if self.particle and not tolua.isnull(self.particle) then
    self.particle:removeFromParentAndCleanup(true)
    self.particle = nil
  end
  if self.attackParticle and not tolua.isnull(self.attackParticle) then
    self.attackParticle:removeFromParentAndCleanup(true)
    self.attackParticle = nil
  end
  if self.particleNode and not tolua.isnull(self.particleNode) then
    self.particleNode:stopAllActions()
  end
end

function class:refreshBoat(time)
  if not self.mgr.openMovie then
    self.boatMgr:refreshRace(nil, time)
  end
end

function class:initNoticeBar()
  self.noticeQueue = {}
  self:initNoticeUI()
  self:listenTimer(Timer:Always(0.2), function()
    self:checkNotice()
  end)
end

function class:initNoticeUI()
  local winSize = ed.display.winSize
  self.ui.notice_bar:setContentSize(CCSizeMake(winSize.width * 0.75, 62))
  self.ui.notice_bar:setPosition(winSize.width / 2 - ed.display.halfFixedWidth, winSize.height + 40 - 152)
  self.ui.notice_bar:setScale(0.6)
  local clipLayer = CCLayer:create()
  self.ui.notice_bar:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(48, 0, (winSize.width * 0.75 - 160) * 0.6, 62))
  self.noticeLayer = clipLayer
end

function class:checkNotice()
end

function class:addNoticeQueue(txt)
  table.insert(self.noticeQueue, {
    txt = txt or ""
  })
end

function class:setNoticeTxt(tip)
  if self.noticeText then
    self.noticeText.node:removeFromParentAndCleanup(true)
  end
  local size = self.ui.notice_bar:getContentSize()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = tip,
    fontSize = 28,
    maxWidth = size.width * 9,
    color = ccc3(255, 252, 231),
    strokeColor = ccc3(19, 92, 13),
    strokeSize = 2
  })
  autoText:setVerticalCenter()
  local width, height = autoText:getCurContentSize()
  autoText.node:setPosition(ccp((size.width - width) / 2, size.height / 2))
  self.noticeLayer:addChild(autoText.node)
  self.noticeText = autoText
  if autoText.node:getPositionX() < 80 then
    local movePosx = (80 - autoText.node:getPositionX()) * 2
    autoText.node:setPositionX(100)
    autoText.node:runAction(CCMoveBy:create(movePosx * 0.02, ccp(-movePosx - 20, 0)))
    return nil, movePosx * 0.02
  else
    return (autoText.node:getPositionX() - 80) * 2, 0.5
  end
end

function class:showNoticeBar()
  if #self.noticeQueue == 0 or self.actioning then
    return
  end
  
  local function actionFunc()
    local info = table.remove(self.noticeQueue, 1)
    if info then
      self.actioning = true
      self.ui.notice_bar:setContentSize(CCSizeMake(ed.display.winSize.width * 0.75, 62))
      self.noticeLayer:setPositionX(0)
      local adaptWidth, delayTime = self:setNoticeTxt(info.txt)
      if adaptWidth then
        local width = ed.display.winSize.width * 0.75 - adaptWidth
        self.ui.notice_bar:setContentSize(CCSizeMake(width, 62))
        self.noticeLayer:setPositionX(-adaptWidth / 2)
      end
      self.ui.notice_bar:setVisible(true)
      self.ui.notice_bar:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(delayTime + 0.5), CCCallFunc:create(function()
        self.ui.notice_bar:setVisible(false)
      end), CCDelayTime:create(0.4), CCCallFunc:create(function()
        actionFunc()
      end))))
    else
      self.actioning = false
    end
  end
  
  actionFunc()
end

function class:addNotice()
end

function class:refreshNotice()
end

function class:showNotice()
end

function class:openMovie()
  local speed = self.mgr.bgSpeed - 10
  local bu = -30
  self.mainLayer:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(2), CCCallFunc:create(function()
    self:registerUpdateHandler("openMovieUpdate", function(dt)
      bu = bu * 1.1
      speed = speed + bu
      if 80 <= speed then
        self.boatMgr:destroyOnceBoats()
        self.mgr.openMovie = false
        self.boatMgr.boats = nil
        self.boatMgr:refreshRace()
        self.mgr.bgSpeed = 80
        self:removeUpdateHandler("openMovieUpdate")
        self:registerBtn()
      elseif speed < -2500 then
        self.mgr.bgSpeed = -2500
        bu = 15
      else
        self.mgr.bgSpeed = speed
      end
    end)
  end))))
end
