ed.UITool.registViewOpenFunc("GuildMountScene", function(param)
  local prompt = ed.playerlimit.getAreaUnlockPrompt("GuildMount")
  if prompt then
    ed.showToast(prompt)
    return
  end
  if ed.player:getGuildId() == 0 then
    ed.showToast(T("\232\175\183\229\133\136\229\138\160\229\133\165\229\133\172\228\188\154"))
    return
  end
  if ed.GuildMountManager:isOffSeason() then
    return
  end
  if ed.GuildMountManager:getState() == "preview" then
    local curSeasonId = ed.GuildMountManager.season
    local startTime = ed.getDataTable("GuildMountSeason")[curSeasonId]["Battle Start Time"]
    local time = ed.getTimeByYMDHMS(startTime) - ed.getFitServerTime()
    if 0 < time then
      ed.showToast(string.format(T("\231\142\169\230\179\149\229\176\134\228\186\142%s\229\144\142\229\188\128\229\144\175"), ed.time2dhm(time)))
      return
    end
  end
  ed.GuildMountNetwork:sendOpenPanel()
end)
local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.GuildMountMainScene = class

function class:initData()
  self.playerMap = {}
  self.displayBossId = ed.GuildMountManager:getCurBoss()._id
  ed.storage.setValue(ed.getRoleKey("LastLoginTimeStamp"), ed.getFitServerTime())
  self.loadList = {}
  self.atkFcaList = {}
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 75, top = 18})
  ed.layout.layoutWithMagin(self.ui.bg_endtime, {left = 35})
  ed.layout.layoutWithMagin(self.ui.bg_future_title, {left = 65})
  ed.layout.layoutWithMagin(self.ui.Panel_3472, {left = 35})
  ed.layout.layoutWithMagin(self.ui.btn_challenge, {right = 40})
  ed.layout.layoutWithMagin(self.ui.bg_guild_rank, {right = 90}, true)
  ed.layout.layoutWithMagin(self.ui.btn_shop, {right = 15})
  ed.layout.layoutWithMagin(self.ui.btn_reward, {right = 15})
  ed.layout.layoutWithMagin(self.ui.btn_ranklist, {right = 15})
  ed.layout.layoutWithMagin(self.ui.btn_changecloth, {left = 35})
end

function class:initLabels()
  ed.setLabelStroke(self.ui.label_boss_title, ed.toccc3(3152916), 1)
  ed.setLabelStroke(self.ui.Label_1100, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.Label_1123, ed.toccc3(8137732), 1)
  ed.setLabelFontName(self.ui.Label_1124, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_1124, ed.toccc3(8137732), 1.5)
  ed.setLabelStroke(self.ui.label_ranklist, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_reward, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_shop, ccc3(9, 17, 27), 1)
  ed.setLabelFontName(self.ui.Label_1119, ed.fontBold)
  ed.setLabelStroke(self.ui.Label_1119, ed.toccc3(5117958), 1.5)
  ed.setLabelFontName(self.ui.label_reward_point, ed.fontBold)
  ed.setLabelStroke(self.ui.label_reward_point, ed.toccc3(6170625), 1.5)
  ed.setLabelStroke(self.ui.Label_1103, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_endtime, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_extra_time, ed.toccc3(1706756), 1)
  self.ui.Label_1124:limitWidthByScale(120)
  self.ui.Label_1124:setHorizontalAlignment(kCCTextAlignmentCenter)
  local label_wid = self.ui.Label_1124:getContentSize().width * self.ui.Label_1124:getScale()
  local rightPos = self.ui.ImageView_2301:getPositionX() + self.ui.ImageView_2301:getContentSize().width * 0.5
  local newPos = math.max(rightPos + label_wid * 0.5, self.ui.Label_1124:getPositionX())
  self.ui.Label_1124:setPositionX(newPos)
  self.ui.Label_1123:limitWidthByScale(80)
  self.ui.Label_1121:limitWidthByScale(170)
  self.recordTime = ed.getTimeBeforeResetTime() + ed.getServerTime()
  local txt = ed.time2dhms(self.recordTime - ed.getServerTime())
  local atTxt = ed.ui.autoText.new()
  atTxt:initParam({
    context = T("<lable color=ccc3(255,230,130) >%s</lable>\229\144\142\232\191\142\230\136\152\230\150\176BOSS", txt),
    color = ed.toccc3(16776423),
    strokeColor = ed.toccc3(0),
    strokeSize = 1,
    fontSize = 16
  })
  self.ui.bg_left_time:addChild(atTxt.node)
  local bgSize = self.ui.bg_left_time:getContentSize()
  local atWid, _ = atTxt:getCurContentSize()
  local atPosX = 0.5 * (bgSize.width - atWid)
  atTxt.node:setPosition(ccp(atPosX, bgSize.height * 0.5))
  self.leftTimeAt = atTxt
  if ed.GuildMountManager:getState() ~= "show" then
    self:refreshLeftTime()
    atWid, _ = atTxt:getCurContentSize()
    atPosX = 0.5 * (bgSize.width - atWid)
    atTxt.node:setPosition(ccp(atPosX, bgSize.height * 0.5))
    self:listenTimer(Timer:Always(1), function()
      if ed.GuildMountManager:getState() == "show" then
        return
      end
      if ed.GuildMountManager.endTime <= ed.getServerTime() then
        if ed.getCurrentScene().identity == "GuildMountMainScene" then
          ed.GuildMountManager.isOpenPanel = false
          ed.GuildMountNetwork:sendOpenPanel()
        end
        return
      end
      if self.recordTime < ed.getServerTime() then
        self.recordTime = self.recordTime + 86400
        if ed.getCurrentScene().identity == "GuildMountMainScene" then
          ed.GuildMountNetwork:sendOpenPanel()
        end
      end
      self:refreshLeftTime()
      atWid, _ = atTxt:getCurContentSize()
      atPosX = 0.5 * (bgSize.width - atWid)
      atTxt.node:setPosition(ccp(atPosX, bgSize.height * 0.5))
    end)
  end
end

function class:refreshLeftTime()
  if #ed.GuildMountManager.bossIds == 1 then
    self.leftTimeAt:setString(T("\229\183\178\230\136\152\230\150\151\232\135\179\230\156\128\229\144\142\228\184\128\232\189\174"))
  elseif #ed.GuildMountManager.bossIds > 1 then
    local txt = ed.time2dhms(self.recordTime - ed.getServerTime())
    self.leftTimeAt:setString(T("<lable color=ccc3(255,230,130) >%s</lable>\229\144\142\232\191\142\230\136\152\230\150\176BOSS", txt))
  end
  self.leftTimeAt:drawTextNode()
end

function class:refreshTimeInfo()
  local season = ed.GuildMountManager:getSeason() or 1
  local seasonData = ed.getDataTable("GuildMountSeason")[season]
  if not seasonData then
    ed.showAlertDialog({
      text = T("\230\180\187\229\138\168\229\183\178\231\187\147\230\157\159"),
      buttonText = T("\231\161\174\229\174\154"),
      handler = function()
        ed.popScene()
      end
    })
    return
  end
  local state = ed.GuildMountManager:getState()
  local timeStr = ""
  local _, bs_m, bs_d, bs_h = ed.ymdhmsNString2YMDHMS(seasonData["Battle Start Time"])
  local _, be_m, be_d, be_h = ed.ymdhmsNString2YMDHMS(seasonData["Battle End Time"])
  local _, e_m, e_d, e_h = ed.ymdhmsNString2YMDHMS(seasonData["End Time"])
  if state == "wait" then
    timeStr = T("\229\176\134\229\156\168%d\230\156\136%d\230\151\165%d\230\151\182\229\188\128\229\167\139\230\140\145\230\136\152 ", bs_m, bs_d, bs_h) .. ed.getUTCLabel()
    ed.setString(self.ui.label_endtime, timeStr)
  elseif state == "open" then
    timeStr = T("S%d\232\181\155\229\173\163 \229\133\179\233\151\173\230\151\182\233\151\180:%s", ed.GuildMountManager.season or 1, T("%d\230\156\136%d\230\151\165 %02d:%02d", be_m, be_d, be_h, 0)) .. ed.getUTCLabel()
    ed.setString(self.ui.label_endtime, timeStr)
  elseif state == "show" then
    self.ui.bg_left_time:setVisible(false)
    self.ui.bg_season_end:setVisible(true)
    self.ui.bg_endtime:setVisible(false)
    timeStr = T("\229\176\134\229\156\168%d\230\156\136%d\230\151\165%d\230\151\182\229\133\179\233\151\173", e_m, e_d, e_h) .. ed.getUTCLabel()
    ed.setString(self.ui.Label_2641, timeStr)
    local titleLabel = ed.ui.gradientLabel.create({
      text = T("\230\175\148\232\181\155\231\187\147\230\157\159"),
      fontSize = 22,
      fontName = ed.fontBold,
      startColor = ed.toccc3(16777215),
      endColor = ed.toccc3(14536190),
      strokeSize = 1,
      strokeStartColor = ed.toccc3(6041771),
      strokeEndColor = ed.toccc3(6041771)
    })
    ed.UITool.replaceUINew(self.ui, "Label_2640", titleLabel.node)
    self.ui.Panel_1540:setVisible(false)
    self.ui.btn_challenge:setVisible(false)
    self.ui.bg_future_title:setVisible(false)
    self.ui.Panel_3472:setVisible(false)
  end
end

function class:createDamageItem(data, splitFlag)
  local rootNode = ed.createSprite("UI/alpha/1080P/common/notice_bg.png")
  rootNode:setCascadeOpacityEnabled(true)
  local name = data._nick_name or ""
  local bossName = ""
  if data._boss_id then
    local bossTblData = ed.getDataTable("GuildMountBoss")[data._boss_id]
    bossName = bossTblData["Boss Name"]
  end
  local damage = data._damage or 0
  local lefttime = ed.time2dhms(ed.getServerTime() - data._time or 0)
  local str = string.format(T("<text|chat_content_highline_yellow|%s><text|chat_content|\229\175\185%s\233\128\160\230\136\144\228\186\134><text|guild_clash_name_oppo|%s><text|chat_content|\228\188\164\229\174\179(%s\229\137\141)>"), name, bossName, ed.formatNumber(damage), lefttime)
  local richtext2 = richText:new()
  richtext2:setString(str)
  richtext2:setPosition(ccp(150, 18))
  rootNode:addChild(richtext2.rootNode)
  return rootNode
end

function class:playBattleEvent()
  if self.latestItem and not tolua.isnull(self.latestItem) then
    self.latestItem:stopAllActions()
    self.latestItem:removeFromParentAndCleanup(true)
  end
  local damageList = ed.GuildMountManager:getDamageEvent()
  local damage
  for k, v in ipairs(damageList) do
    if not ed.GuildMountManager.playDamageMap[v._time] then
      damage = v
      break
    end
  end
  if damage then
    local latestItem = self:createDamageItem(damage)
    latestItem:setPosition(ccp(480, 480))
    self.ui.bg:addChild(latestItem)
    ed.GuildMountManager.playDamageMap[damage._time] = true
    local action1 = CCSpawn:create(ccArrayMake({
      CCEaseSineIn:create(CCFadeIn:create(0.2)),
      CCEaseSineIn:create(CCScaleTo:create(0.2, 1.06))
    }))
    local action2 = CCEaseSineOut:create(CCScaleTo:create(0.3, 1))
    local action3 = CCDelayTime:create(0.45)
    local action4 = CCFadeOut:create(1.1)
    local action5 = CCCallFunc:create(function()
      latestItem:removeFromParentAndCleanup(true)
      self:playBattleEvent()
    end)
    local sequence = CCSequence:create(ccArrayMake(action1, action2, action3, action4, action5))
    latestItem:runAction(sequence)
    self.latestItem = latestItem
  end
end

function class:refreshExtraTime()
  local extraInfo = ed.GuildMountManager:getExtraTime()
  if not extraInfo then
    self.ui.bg_extra_time:setVisible(false)
  else
    self.ui.bg_extra_time:setVisible(true)
    local time = extraInfo._duration or 0
    ed.setString(self.ui.label_extra_time, string.format(T("\230\136\152\230\150\151\232\161\165\230\151\182:%d\231\167\146"), time))
  end
end

function class:onBossClick()
  local curBoss = ed.GuildMountManager:getCurBoss()
  local curBossId = curBoss and curBoss._id or 0
  ed.GuildMountManager.openBossId = curBossId
  ed.GuildMountNetwork:sendOpenBoss(curBossId)
end

function class:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_tips", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = ed.ui.GuildMountRuleWin.strPage
    }):popWindow()
  end, {pressScale = 0.9})
  local isShow = true
  self.ui.Panel_3472:setClipRect(CCRectMake(0, 0, 400, 102))
  ed.UITool.registerBtn(self, "btn_detail", function()
    if isShow then
      self.ui.bg_future:runAction(CCMoveBy:create(0.1, ccp(0, 100)))
      self.ui.icon_detail:setScaleY(1)
    else
      self.ui.bg_future:runAction(CCMoveBy:create(0.1, ccp(0, -100)))
      self.ui.icon_detail:setScaleY(-1)
    end
    isShow = not isShow
  end)
  ed.UITool.registerBtn(self, "btn_changecloth", function()
    ed.ui.GuildMountChangeActorWin.create()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_shop", function()
    if ed.GuildMountManager:isOffSeason() then
      ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
      return
    end
    ed.GuildMountNetwork:sendQueryGoods()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_reward", function()
    if ed.GuildMountManager:isOffSeason() then
      ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
      return
    end
    ed.UITool.openView("GuildMountRewardWin")
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_ranklist", function()
    if ed.GuildMountManager:isOffSeason() then
      ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
      return
    end
    ed.UITool.openView("GuildMountRankListWin")
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_guild_rank", function()
    if ed.GuildMountManager:isOffSeason() then
      ed.showToast(T("\230\180\187\229\138\168\229\183\178\229\133\179\233\151\173"))
      return
    end
    ed.UITool.openView("GuildMountRankListWin")
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "Panel_1540", function()
    self:onBossClick()
  end)
  ed.UITool.registerBtn(self, "btn_challenge", function()
    self.challengeFca:setAction("Start2")
    self:onBossClick()
  end)
end

function class:refreshPreviewBoss()
  local curBoss = ed.GuildMountManager:getCurBoss()
  local curBossId = curBoss._id
  local tb = ed.getDataTable("GuildMountBoss")
  for i = 1, 3 do
    local bossId = ed.GuildMountManager.bossIds[i]
    if tb[bossId] then
      local icon = ed.readhero.createPureIcon({
        id = tb[bossId]["Unit ID"]
      }).icon
      self.ui["future" .. i]:removeAllChildrenWithCleanup(true)
      self.ui["future" .. i]:addChild(icon, 1)
      ed.setString(self.ui["round" .. i], string.format(T("\231\172\172%d\232\189\174"), ed.GuildMountManager.getBossRoundById(bossId)))
      if i == 1 then
        local frame = ed.createSprite("UI/alpha/1080P/guildmount/changehero_selected.png")
        icon:addChild(frame)
        frame:setScale(0.97)
        frame:setPosition(ccp(35.3, 34.2))
      end
      ed.layout.centerInParent(icon)
      icon:setScale(0.7)
      self:btRemoveMainTouchHandler({
        key = "boss" .. bossId
      })
      self:btRegisterButtonClick({
        button = icon,
        key = "boss" .. bossId,
        clickHandler = function()
          ed.ui.GuildMountDetailWin.create({_id = bossId})
        end
      })
    else
      self.ui["round" .. i]:setVisible(false)
      self.ui["future" .. i]:setVisible(false)
    end
  end
end

function class:refreshGuildRank()
  local rank = ed.GuildMountManager:getGuildRank()
  if rank and 0 < rank then
    ed.setString(self.ui.Label_1124, rank)
    self.ui.Label_1124:limitWidthByScale(120)
    self.ui.Label_1124:setHorizontalAlignment(kCCTextAlignmentCenter)
    local label_wid = self.ui.Label_1124:getContentSize().width * self.ui.Label_1124:getScale()
    local rightPos = self.ui.ImageView_2301:getPositionX() + self.ui.ImageView_2301:getContentSize().width * 0.5
    local newPos = math.max(rightPos + label_wid * 0.5, self.ui.Label_1123:getPositionX())
    self.ui.Label_1124:setPositionX(newPos)
  end
end

function class:refreshChallengeTimes()
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    color = ed.toccc3(16774837),
    context = string.format(T("(<lable color=ccc3(141,244,118) strokeColor=ccc3(77,24,6) strokeSize=1.5>%s</lable>/%d)"), ed.GuildMountManager:getLeftChallengeNum(), ed.GuildMountManager:getAllChallengeNum()),
    fontSize = 19,
    strokeColor = ed.toccc3(5117958),
    strokeSize = 1.5
  })
  ed.UITool.replaceUINew(self.ui, "label_challenge_time", autoText.node)
  ed.right2(autoText.node, self.ui.Label_1119)
end

function class:refreshBossActor()
  local curBoss = ed.GuildMountManager:getCurBoss()
  local tbData = ed.getDataTable("GuildMountBoss")[curBoss._id]
  local bossActor = ed.readhero.getActorNew(tbData["Unit ID"])
  bossActor:setScaleX(-1 * tbData["Body Size"])
  bossActor:setScaleY(tbData["Body Size"])
  EDLoadShader("HSVtoRGBShaderV2")
  ed.useHSVShaderV2(bossActor, tbData.Hue, tbData.Saturation, tbData.Value, 1)
  self:addFca(bossActor)
  local bossEffect = ed.createFcaNode("eff_UI_GuildMount_boss")
  bossEffect:setScale(1 / tbData["Body Size"])
  self:addFca(bossEffect)
  bossActor:addChild(bossEffect)
  if self.displayBossId ~= curBoss._id then
    local roundEffect = ed.createFcaNode("eff_UI_GuildMount_boss2")
    bossActor:addChild(roundEffect)
    self:addFca(roundEffect)
    self:listenTimer(Timer:Once(1.2), function()
      if roundEffect and not tolua.isnull(roundEffect) then
        roundEffect:removeFromParentAndCleanup(true)
      end
    end)
  end
  self.displayBossId = curBoss._id
  ed.UITool.replaceUINew(self.ui, "boss_pos", bossActor)
  local bossId = curBoss._id
  local monsterName = ed.getDataTable("GuildMountBoss")[bossId]["Boss Name"]
  local stageId = ed.getDataTable("GuildMountBoss")[bossId]["Stage ID"]
  local lv = ed.getDataTable("Battle")[stageId][1]["Level 1"]
  local titleLabel = ed.ui.gradientLabel.create({
    text = string.format(T("\231\172\172%d\232\189\174  %s (Lv.%d)"), ed.GuildMountManager.getBossRoundById(bossId), monsterName, lv),
    fontSize = 20,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776687),
    endColor = ed.toccc3(16776687),
    strokeSize = 1.5,
    strokeStartColor = ed.toccc3(12077522),
    strokeEndColor = ed.toccc3(4468608)
  })
  ed.UITool.replaceUINew(self.ui, "name_boss", titleLabel.node)
  titleLabel.node:setAnchorPoint(ccp(0, 0.5))
end

function class:createPlayerActor(data, showRefreshFca)
  local node = CCNode:create()
  local actor = ed.readhero.getActorNew(data._hero_summary._tid, data._hero_summary._fashion)
  local bgName = ed.createScale9Sprite("UI/alpha/1080P/guildmount/playername_background.png")
  bgName:setContentSize(CCSizeMake(120, 18))
  self:addFca(actor)
  bgName:setPositionY(110)
  node:addChild(actor)
  node:addChild(bgName)
  local guildName = ed.createLabelTTF(ed.player:getGuildName(), 13)
  guildName:setPositionY(90)
  guildName:setColor(ed.toccc3(16770690))
  ed.setLabelStroke(guildName, ccc3(0, 0, 0), 1)
  node:addChild(guildName)
  local name
  if data._user_summary._uid == ed.getUserid() then
    name = ed.getPlayerName(data._user_summary._name, data._user_summary._medal, {
      anchorPoint = ccp(0.5, 0.5),
      labelColor = "ccc3(102,255,84)",
      notClick = true
    })
    local meEffect = ed.createFcaNode("eff_UI_GuildMount_me")
    self:addFca(meEffect)
    node:addChild(meEffect, -1)
  else
    name = ed.getPlayerName(data._user_summary._name, data._user_summary._medal, {
      anchorPoint = ccp(0.5, 0.5),
      notClick = true
    })
  end
  name:setScale(0.8)
  bgName:addChild(name)
  ed.layout.centerInParent(name)
  local atkEffect = ed.createFcaNode("eff_UI_GuildMount_sword")
  atkEffect:setScale(0.7)
  atkEffect:setPositionY(130)
  self:addFca(atkEffect)
  actor:addChild(atkEffect)
  atkEffect:setVisible(data._is_in_battle == 1)
  if showRefreshFca then
    local changeEffect = ed.createFcaNode("eff_UI_GuildMount_exchang")
    self:addFcaOnce(changeEffect)
    actor:addChild(changeEffect)
  end
  local clickLayer = CCLayerColor:create(ccc4(255, 0, 0, 0))
  clickLayer:ignoreAnchorPointForPosition(false)
  clickLayer:setContentSize(CCSizeMake(50, 50))
  clickLayer:setPosition(ccp(0, 50))
  node:addChild(clickLayer)
  self:btRemoveMainTouchHandler({
    key = "member" .. data._user_summary._uid
  })
  self:btRegisterButtonClick({
    button = clickLayer,
    key = "member" .. data._user_summary._uid,
    clickHandler = function()
      ed.registerNetReply("req_home_page", function(data)
        local panel = ed.ui.PlayerInfoPanel.create(data, false)
        panel:popWindow()
      end)
      ed.PlayerInfoNetwork:requestHomePage(data._user_summary._role_id)
    end
  })
  return node, atkEffect
end

function class:handleEnterEvents(data)
  local newPlayers = {}
  local alivePos = {}
  data = ed.copyProto(data)
  local showList = {}
  for k, v in ipairs(data) do
    if v._user_summary._uid == ed.getUserid() then
      ed.GuildMountManager:setDisplayTid(v._hero_summary._tid)
      ed.asyncload.preloadFcaByUnitID(v._hero_summary._tid)
      local player = self.playerMap[1]
      if not player then
        showList[1] = {data = v, showFca = false}
      else
        if v._hero_summary._tid ~= player._hero_summary._tid then
          showList[1] = {data = v, showFca = true}
        else
        end
      end
      alivePos[1] = true
      v.isShowed = true
      if self.atkFcaList[1] and not tolua.isnull(self.atkFcaList[1]) then
        self.atkFcaList[1]:setVisible(v._is_in_battle == 1)
      end
    end
    for i = 2, 9 do
      if not alivePos[i] then
        local player = self.playerMap[i]
        if player and v._user_summary._uid == player._user_summary._uid and v._hero_summary._tid == player._hero_summary._tid then
          v.isShowed = true
          alivePos[i] = true
          if self.atkFcaList[i] and not tolua.isnull(self.atkFcaList[i]) then
            self.atkFcaList[i]:setVisible(v._is_in_battle == 1)
          end
          break
        end
      end
    end
  end
  for i = 2, 9 do
    if alivePos[i] ~= true then
      for k, v in ipairs(data) do
        if v.isShowed ~= true then
          ed.asyncload.preloadFcaByUnitID(v._hero_summary._tid)
          showList[i] = {data = v, showFca = false}
          alivePos[i] = true
          v.isShowed = true
          break
        end
      end
    end
  end
  ed.asyncload.registLoadingListener(function()
    for i, v in pairs(showList) do
      self.playerMap[i] = v.data
      local node, atkFca = self:createPlayerActor(v.data, v.showFca)
      self.atkFcaList[i] = atkFca
      ed.UITool.replaceUINew(self.ui, "pos" .. i, node)
      node:setZOrder(math.floor(node:getPositionY() * -1))
    end
  end)
end

function class:hintBox(i)
  local curScore = ed.GuildMountManager:getChallengeTimes()
  local requireTimes = self.boxFcas[i].requireTimes
  local actState = ed.GuildMountManager:getState()
  if curScore >= requireTimes and not ed.GuildMountManager:isGetLineReward(i) then
    ed.GuildMountNetwork:sendGainReward(i)
  else
    self:initRewardUI(i)
  end
end

function class:initRewardUI(index)
  local data = self.boxFcas[index].rewards
  if nil == data then
    return
  end
  if not tolua.isnull(self.ui.rewardInfo) then
    self.ui.rewardInfo:removeFromParentAndCleanup(true)
  end
  local dx = 60
  local rewardBg = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 20, 19, 181.5))
  rewardBg:setContentSize(CCSizeMake(22 + dx * #data, 74))
  self.ui.bg_reward_bar:addChild(rewardBg, 12)
  local x, y = self.ui["box" .. index]:getPosition()
  self.ui.rewardInfo = rewardBg
  self.ui.rewardInfo:setPosition(ccp(x + 15, 63))
  local ox = dx * #data - 19
  for i, v in ipairs(data) do
    local itemIcon = ed.createItemIcon({
      type = v.type,
      amount = v.amount,
      id = v.id
    })
    itemIcon:setPosition(ox, 38)
    rewardBg:addChild(itemIcon)
    ox = ox + dx
    self:btRemoveMainTouchHandler({
      key = "icon_" .. index .. "_" .. i
    })
    self:btRegisterButtonClick({
      button = itemIcon,
      key = "icon_" .. index .. "_" .. i,
      clickHandler = function()
        ed.UITool.openView("packageDetail", {
          id = v.id,
          amount = v.amount,
          type = v.type
        })
      end
    })
  end
  self:btRegisterOutClick({
    area = rewardBg,
    key = "closerewardInfo",
    clickHandler = function()
      self.ui.rewardInfo:removeFromParentAndCleanup(true)
      self:btRemoveMainTouchHandler({
        key = "closerewardInfo"
      })
    end,
    priority = -1
  })
end

function class:initLineReward()
  local tb = ed.getDataTable("GuildMountLineReward")
  self.boxFcas = {}
  for k, v in ipairs(tb or {}) do
    table.insert(self.boxFcas, {
      id = v.Index,
      requireTimes = v.RequireTimes,
      got = false,
      rewards = {
        {
          type = "guildmountpoint",
          amount = v["Coin Amount"]
        }
      },
      fcaName = v["Fca Name"]
    })
  end
  local maxRequire = self.boxFcas[#self.boxFcas].requireTimes
  for k, v in ipairs(self.boxFcas) do
    local container, ui = ed.editorui(ed.uieditor.GuildMountMainSceneRewardItem)
    local light = ed.createSprite("UI/alpha/1080P/campaign/main/campaign_chest_light.png")
    ui.bg:addChild(light, -1)
    ed.layout.centerInParent(light)
    light:runAction(CCRepeatForever:create(CCRotateBy:create(5, 360)))
    light:setVisible(false)
    local boxFca = ed.createFcaNode(v.fcaName)
    self.boxFcas[k].fcaNode = boxFca
    self.boxFcas[k].lightNode = light
    boxFca:setScale(0.45)
    ed.setString(ui.score, v.requireTimes)
    ed.UITool.replaceUINew(ui, "fca", boxFca)
    boxFca:setAction("Close")
    self:addFca(boxFca)
    local percent = v.requireTimes / maxRequire
    container:setPosition(ccp(500 * percent, -20))
    self.ui["box" .. k] = container
    self.ui.bg_reward_bar:addChild(container, 2)
    self:btRegisterButtonClick({
      button = ui.bg,
      pressHandler = function()
      end,
      cancelPressHandler = function()
      end,
      clickHandler = function()
        self:hintBox(k)
      end
    })
  end
end

function class:refreshLineReward()
  local barSize = self.ui.reward_bar:getContentSize()
  local challengeTimes = ed.GuildMountManager:getChallengeTimes()
  local maxRequireTimes = ed.GuildMountManager:getMaxRequireTimes()
  ed.setString(self.ui.label_reward_point, challengeTimes)
  self.ui.reward_bar:setContentSize(CCSizeMake(10 + 500 * math.min(1, challengeTimes / maxRequireTimes), 10))
  self.ui.reward_bar:setVisible(0 < challengeTimes)
  local rewardRedFlag = false
  for k, v in ipairs(self.boxFcas) do
    local requireTimes = v.requireTimes
    local curTimes = ed.GuildMountManager:getChallengeTimes()
    if requireTimes <= curTimes and not ed.GuildMountManager:isGetLineReward(k) then
      rewardRedFlag = true
    end
  end
  ed.GuildMountManager:setRedFlag(rewardRedFlag)
end

function class:initUI()
  ed.editorui(ed.uieditor.GuildMountMainScene, {
    container = self.mainLayer,
    ui = self.ui
  })
  self:setBackground("UI/alpha/1080P/guildmount/art.png")
  self:setBackButton(function()
    ed.asyncload.unregistLoadingListener()
  end)
  local topBg = ed.createSprite("UI/alpha/1080P/guildmount/art2.jpg")
  self.bg:addChild(topBg, -1)
  topBg:setPosition(ccp(585, 604))
  local fca = ed.createFcaNode("eff_UI_GuildMount_board")
  topBg:addChild(fca)
  fca:setPosition(ccp(610, 107))
  self:addFca(fca)
  local fca2 = ed.createFcaNode("eff_UI_GuildMount_board2")
  self.bg:addChild(fca2, 22)
  self:addFca(fca2)
  fca2:setPosition(ccp(600, 590))
  self:setBackButton(function()
  end)
  local label_bg, label = ed.UITool.createSceneTitle(T("\233\173\148\231\149\140\232\174\168\228\188\144"), self.ui.bg_title, {
    position = ccp(18, 18),
    maxWidth = 180
  })
  self.ui.btn_tips:setPositionX(math.max(self.ui.btn_tips:getPositionX(), label_bg:getPositionX() + label_bg:getContentSize().width + 10))
  self.ui.bg_extra_time:setVisible(false)
  self:adaptUI()
  self:initLabels()
  self.ui.layer_area:setVisible(true)
  ed.setLabelStroke(self.ui.Label_2302, ccc3(16, 14, 14), 1)
  ed.setString(self.ui.Label_2302, string.format(T("\231\172\172%d\232\181\155\229\140\186"), ed.GuildMountManager.zoneId))
  self.ui.Label_2302:limitWidthByScale(50)
  self:initLineReward()
  self.challengeFca = ed.createFcaNode("eff_UI_GuildMount_go")
  ed.UITool.replaceUINew(self.ui, "fca_challenge", self.challengeFca)
  self.challengeFca:setAction("Start")
  self:addFca(self.challengeFca)
  self:refreshBossActor()
  self:refreshPreviewBoss()
end

function class:refreshRank()
  local rank = ed.GuildMountManager:getGuildRank()
  ed.setString(self.ui.label_rank_value, 0 < rank and rank or "--")
end

function class:refreshCurBoss()
  if not tolua.isnull(self.nameLabel) then
    self.nameLabel:removeFromParentAndCleanup(true)
  end
  if not tolua.isnull(self.otherLabel) then
    self.otherLabel:removeFromParentAndCleanup(true)
  end
  local attackPlayer = ed.GuildMountManager:getAttackPlayer()
  if attackPlayer then
    local nameLabel = ed.createLabelTTF(attackPlayer._name, 15)
    nameLabel:setColor(ccc3(241, 193, 113))
    nameLabel:setPosition(ccp(90, 50))
    self.nameLabel = nameLabel
    local otherLabel = ed.createLabelTTF(T("\230\173\163\229\156\168\230\191\128\230\136\152..."), 15)
    ed.right2(otherLabel, nameLabel, 5)
    self.otherLabel = otherLabel
    self.ui.boss_name_bg:addChild(nameLabel)
    self.ui.boss_name_bg:addChild(otherLabel)
  end
  if self.displayBossId ~= ed.GuildMountManager:getCurBoss()._id then
    FireEvent("EventGuildMountBossDead")
    self:refreshBossActor()
    self:refreshPreviewBoss()
  end
end

function class:refreshBaseInfo()
  self:refreshGuildRank()
  self:refreshChallengeTimes()
  self:refreshLineReward()
  self:refreshTimeInfo()
end

function class:playNextRoundAnim()
  self.roundEffect = ed.createFcaNode("eff_UI_GuildMount_boss2")
  self.ui.Panel_1540:addChild(self.roundEffect)
  self:addFca(self.roundEffect)
end

function class:onEnterMainScene()
  ed.showStory("GuildMountStory")
  ed.GuildMountNetwork:sendOpenPanel()
  if ed.player:getGuildId() == 0 then
    return
  end
  ed.GuildMountNetwork:sendPullEvent(true)
  self:shakeBoxes()
  CloseTimer("BoxesShake")
  self:listenTimer(Timer:Always(2.5, "BoxesShake"), function()
    self:shakeBoxes()
  end)
end

function class:shakeBoxes()
  local curScore = ed.GuildMountManager:getChallengeTimes()
  for k, v in ipairs(self.boxFcas) do
    local boxFca = v.fcaNode
    local requireTimes = v.requireTimes
    local action = "Close"
    if curScore >= requireTimes then
      action = ed.GuildMountManager:isGetLineReward(k) and "Opened" or "Shake"
    end
    v.lightNode:setVisible(action == "Shake")
    boxFca:setAction(action)
  end
end

function class:onPopMainScene()
  ed.GuildMountManager:resetOpenPanel()
end

function class:registerEvents()
  self:listenEvent("GuildMountEnterEvent", function(data)
    self:handleEnterEvents(data)
  end)
  self:listenEvent("GuildMountDamageEvent", function()
    self:playBattleEvent()
  end)
  self:listenEvent("EventGuildMountStageEnd", function()
    if ed.GuildMountManager.endTime <= ed.getServerTime() then
      ed.GuildMountManager.isOpenPanel = false
    end
    ed.GuildMountNetwork:sendOpenPanel()
  end)
  self:listenEvent("EventGuildMountOpenPanel", function()
    self:refreshBaseInfo()
    self:refreshCurBoss()
    self:refreshPreviewBoss()
  end)
  self:listenEvent("GuildMountRefreshBossInfo", function()
    self:refreshCurBoss()
  end)
  self:listenEvent("EventGuildMountGainReward", function(index, rewards)
    self:onEventGainReward(index, rewards)
  end)
  self:listenEvent("GuildMountChangeDisplaySuccess", function()
    ed.GuildMountNetwork:sendPullEvent(false)
  end)
end

function class:onEventGainReward(index, reward)
  local rewardDatas = {}
  for i, v in ipairs(reward) do
    table.insert(rewardDatas, {
      id = v._id,
      type = v._type:gsub("^%l", string.upper),
      amount = v._amount
    })
  end
  local config = {
    type = "getProp",
    param = {
      title = T("\232\142\183\229\190\151"),
      items = rewardDatas
    }
  }
  ed.announce(config)
  local box = self.boxFcas[index].fcaNode
  box:setAction("Opening")
  self:listenTimer(Timer:Once(0.8), function()
    box:setAction("Opened")
    self.boxFcas[index].lightNode:setVisible(false)
  end)
  local rewardRedFlag = false
  for k, v in ipairs(self.boxFcas) do
    local requireTimes = v.requireTimes
    local curTimes = ed.GuildMountManager:getChallengeTimes()
    if requireTimes <= curTimes and not ed.GuildMountManager:isGetLineReward(k) then
      rewardRedFlag = true
    end
  end
  ed.GuildMountManager:setRedFlag(rewardRedFlag)
end

function class:sendRefreshBoss()
  ed.GuildMountManager.openBossId = -1
  local curBoss = ed.GuildMountManager:getCurBoss()
  local curBossId = curBoss and curBoss._id or 0
  ed.GuildMountNetwork:sendOpenBoss(curBossId)
end

function class.create()
  local self = base.create("GuildMountMainScene")
  setmetatable(self, class.mt)
  self:initData()
  self:initUI()
  self:registerEvents()
  self:registerTouchEvents()
  self:listenTimer(Timer:Always(10), function()
    if not ed.GuildMountManager:isOffSeason() and ed.getCurrentScene().identity == "GuildMountMainScene" then
      self:sendRefreshBoss()
      ed.GuildMountNetwork:sendPullEvent(true)
    end
  end)
  self:registerOnEnterHandler("enter_guildmount_main", function()
    if not ed.GuildMountManager:isOffSeason() then
      self:sendRefreshBoss()
      self:onEnterMainScene()
    end
  end)
  self:registerOnPopSceneHandler("pop_guildmount_main", function()
    self:onPopMainScene()
  end)
  return self
end
