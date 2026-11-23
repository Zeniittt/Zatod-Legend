local base = ed.ui.commonscene
local GuildMainScene = newclass(base.mt)
ed.ui.GuildMainScene = GuildMainScene

function GuildMainScene:createItem(data, canWorshipList)
  local container, ui = ed.editorui(ed.uieditor.GuildMemberItem)
  local oriSize = ui.bg:getContentSize()
  ui.bg:setContentSize(CCSizeMake(oriSize.width + self.addWidth, oriSize.height))
  ed.setLabelStroke(ui.name, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.title, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.online, ed.toccc3(5586983), 1)
  ed.setLabelStroke(ui.label_worship, ed.toccc3(10048783), 1)
  ed.setLabelStroke(ui.online, ed.toccc3(5586983), 1)
  local name = ed.getPlayerName(data._summary._name, data._summary._medal, {left = true})
  ed.UITool.replaceUI(ui, "bg_name", "name", name)
  name:setScale(0.92)
  ed.setString(ui.liveness, data._active)
  local gs = ed.getNumberNode({
    text = data._full_gs,
    folder = "hero_gs",
    padding = -1
  }).node
  ed.UITool.replaceUI(ui, "bg", "gs", gs)
  local head, headIcon = ed.getWholeHeadIcon({
    id = data._summary._avatar,
    level = data._summary._level,
    lvoffset = {x = -48, y = -25},
    scale = 0.77
  })
  ed.UITool.replaceUI(ui, "bg", "icon", head)
  ui.icon = headIcon
  if data._is_online == 1 then
    ed.setString(ui.online, T("\229\156\168\231\186\191"))
    ed.setLabelColor(ui.online, ed.toccc3(9699198))
  else
    ed.setString(ui.online, T("\231\166\187\231\186\191"))
    ed.setLabelColor(ui.online, ed.toccc3(11181454))
  end
  if data._job == "member" then
    ui.title:setVisible(false)
    ed.setTexture(ui.bg_name, "UI/alpha/1080P/guild/members_bg.png")
  elseif data._job == "chairman" then
    ed.setString(ui.title, T("\228\188\154\233\149\191"))
    ed.setTexture(ui.bg_name, "UI/alpha/1080P/guild/president_bg.png")
  elseif data._job == "elder" then
    ed.setLabelColor(ui.title, ed.toccc3(13534950))
    ed.setString(ui.title, T("\233\149\191\232\128\129"))
  end
  ui.btn_worship:setVisible(ed.isElementInTable(data._summary._uid, canWorshipList))
  head:setPositionX(head:getPositionX() / self.fixScaleX)
  ui.bg_name:setPositionX(ui.bg_name:getPositionX() / self.fixScaleX)
  gs:setPositionX(gs:getPositionX() / self.fixScaleX)
  ui.btn_worship:setPositionX(ui.btn_worship:getPositionX() / self.fixScaleX)
  ui.online:setPositionX(ui.online:getPositionX() / self.fixScaleX)
  ui.liveness:setPositionX(ui.liveness:getPositionX() / self.fixScaleX)
  return container, ui
end

function GuildMainScene:refreshDraglist()
  local uiList = {}
  self.draglist:clearList()
  local size = self.ui.layer_item:getContentSize()
  local py, gapY = 75, 2
  local ox, oy = size.width / 2, size.height + py / 2
  
  local function getPos(i)
    return ccp(ox, oy - (py + gapY) * i)
  end
  
  local data = ed.GuildManager.members or {}
  local udate = ed.copyProto(ed.GuildManager.members)
  table.sort(udate, function(a, b)
    return a._full_gs > b._full_gs
  end)
  local canWorshipList = {}
  for k, v in ipairs(udate) do
    if v._summary._uid ~= ed.getUserid() and (k <= 4 or v._full_gs > ed.GuildManager.selfGs) then
      table.insert(canWorshipList, v._summary._uid)
    end
  end
  for k, v in ipairs(data) do
    local container, ui = self:createItem(v, canWorshipList)
    container:setPosition(getPos(k))
    self.draglist:addItem(container)
    ui.data = v
    table.insert(uiList, ui)
  end
  self.uiList = uiList
  self.draglist:initListHeight((py + gapY) * #data)
end

function GuildMainScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      if v.btn_worship:isVisible() and ed.containsPoint(v.btn_worship, x, y) then
        v.btn_worship:setScale(0.85)
        
        return v
      end
      if ed.containsPoint(v.icon, x, y) then
        v.icon:setScale(0.95)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function GuildMainScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if ed.containsPoint(v.icon, x, y) then
      ed.ui.GuildMemberInfoWin.create({
        info = v.data
      })
    end
    if ed.containsPoint(v.btn_worship, x, y) then
      local vipLevel = ed.player:getvip()
      local worshipTimes = ed.getDataTable("VIP")[vipLevel]["Worship Times"]
      if worshipTimes <= ed.GuildManager.curWorshipTime then
        ed.showToast(T("\232\134\156\230\139\156\230\172\161\230\149\176\228\184\141\232\182\179"))
      else
        ed.ui.GuildWorshipWin.create({
          uid = v.data._uid
        })
      end
    end
  end
  
  return handler
end

function GuildMainScene:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    v.btn_worship:setScale(0.9)
    v.icon:setScale(0.8)
  end
  
  return handler
end

function GuildMainScene:adaptUI()
  local ui = self.ui
  local fixX = ed.display.halfFixedWidth * 2
  local fixY = ed.display.halfFixedHeight * 2
  local addHeight = fixY * 0.5
  local addWidth = fixX * 0.5
  self.addWidth = addWidth
  local oriRightSize = ui.bg_main:getContentSize()
  local oriLeftSize = ui.bg:getContentSize()
  local layerItemSize = ui.layer_item:getContentSize()
  self.fixScaleX = oriRightSize.width / (oriRightSize.width + addWidth)
  ui.bg_main:setContentSize(CCSizeMake(oriRightSize.width + addWidth, oriRightSize.height + addHeight))
  ui.bg:setContentSize(CCSizeMake(oriLeftSize.width, oriLeftSize.height + addHeight))
  ui.layer_item:setContentSize(CCSizeMake(layerItemSize.width + addWidth, layerItemSize.height + addHeight))
  ed.UITool.setPositionBy(ui.layer_top, ccp(0, addHeight))
  ed.UITool.setPositionBy(ui.bg_text, ccp(0, addHeight))
  ed.UITool.setContentSizeBy(ui.bg_text, addWidth, 0)
  ed.UITool.setPositionBy(ui.layer_btn, ccp(addWidth, addHeight))
  ui.info:setPosition(ccp(ui.info:getPositionX() / self.fixScaleX, ui.info:getPositionY() + addHeight))
  ui.gs:setPosition(ccp(ui.gs:getPositionX() / self.fixScaleX, ui.gs:getPositionY() + addHeight))
  ui.Panel_5520:setPosition(ccp(ui.Panel_5520:getPositionX() / self.fixScaleX, ui.Panel_5520:getPositionY() + addHeight))
  ed.layout.layoutWithMagin(ui.bg, {
    bottom = (fixY - addHeight) / 2,
    left = (fixX - addWidth) / 2 + 50
  })
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  self.ui.btn_rule_liveness:setPositionX(self.ui.label_liveness:getPositionX() + self.ui.label_liveness:getContentSize().width + self.ui.btn_rule_liveness:getContentSize().width * 0.5 + 2)
  self.ui.vitality:setPositionX(self.ui.vitality1:getPositionX() + self.ui.vitality1:getContentSize().width * 0.5 + self.ui.vitality:getContentSize().width * 0.5 - 0.5)
  local limitWidth = 74
  local btnTitleScale = math.min(1, limitWidth / math.max(self.ui.label_log:getContentSize().width, self.ui.label_manage:getContentSize().width))
  self.ui.label_log:setScale(btnTitleScale)
  self.ui.label_manage:setScale(btnTitleScale)
  local labelGroup = {
    self.ui.label_weeklyjob,
    self.ui.label_guildwar,
    self.ui.label_worship,
    self.ui.label_raid,
    self.ui.label_mercenary,
    self.ui.label_shop,
    self.ui.label_mount
  }
  limitWidth = 74
  local maxWidth = 74
  for i, v in ipairs(labelGroup) do
    ed.adaptLabel(v, {maxWidth = 74, minScale = 0.7})
    v:setHorizontalAlignment(kCCTextAlignmentCenter)
  end
end

function GuildMainScene:initLabels()
  ed.setLabelDimensions(self.ui.label_slogan, CCSizeMake(210, 0))
  ed.setLabelStroke(self.ui.label_find, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.guildname, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_worship, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_weeklyjob, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_guildwar, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_mount, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_raid, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_mercenary, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_shop, ed.toccc3(594187), 1)
  ed.setLabelShadow(self.ui.label_manage, ed.toccc3(0), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_log, ed.toccc3(0), ccp(1, 0))
  ed.setLabelStroke(self.ui.title_slogan, ed.toccc3(2565412), 1)
  self.ui.title_slogan:setFontName(ed.fontBold)
end

function GuildMainScene:initLivenessPanel()
  local livenessStr = T("\229\133\172\228\188\154\230\136\144\229\145\152\230\175\143\230\182\136\232\128\151\228\184\128\231\130\185\228\189\147\229\138\155\239\188\140\229\133\172\228\188\154\229\176\177\232\142\183\229\190\151\228\184\128\231\130\185\230\180\187\232\183\131\229\128\188<br/>") .. T("\230\180\187\232\183\131\229\128\188\229\143\175\228\187\165\231\148\168\230\157\165\233\135\141\231\189\174\229\155\162\233\152\159\229\137\175\230\156\172<br/>") .. T("\229\133\172\228\188\154\230\180\187\232\183\131\229\128\188\228\184\138\233\153\144<lable color=ccc3(255,234,198)>315,000</lable>\231\130\185\239\188\140\230\175\143\228\184\170\230\136\144\229\145\152\230\175\143\229\164\169\230\156\128\229\164\154\232\180\161\231\140\174<lable color=ccc3(255,234,198)>900</lable>\231\130\185<br/>") .. T("\228\189\160\228\187\138\230\151\165\232\180\161\231\140\174\231\154\132\230\180\187\232\183\131\229\128\188\239\188\154<lable color=ccc3(255,234,198)>%d/900</lable><br/>", ed.GuildManager.selfVitality) .. T("\230\156\128\232\191\1457\230\151\165\232\180\161\231\140\174\230\180\187\232\183\131\229\128\188\239\188\154<lable color=ccc3(255,234,198)>%d</lable>", ed.GuildManager.selfActive)
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    fontSize = 14,
    context = livenessStr,
    maxWidth = 348,
    lineSpacing = 1,
    color = ccc3(232, 177, 82),
    strokeColor = ccc3(39, 37, 36),
    strokeSize = 1
  })
  self.ui.bg_liveness_info:addChild(autoText.node)
  local width, height = autoText:getContentSize()
  self.ui.bg_liveness_info:setContentSize(CCSizeMake(width + 30, height + 20))
  autoText.node:setPosition(15, height + 5)
end

function GuildMainScene:createMainFca()
  local rootPos = ccp(ed.display.center.x, ed.display.center.y)
  local mainFca = ed.createFcaNode("eff_UI_pvp_particle_main")
  mainFca:setPosition(rootPos)
  self:addFca(mainFca)
  self.mainLayer:addChild(mainFca, -1)
end

function GuildMainScene:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_item, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -131
  })
  self:refreshDraglist()
end

function GuildMainScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildMainScene, {
    container = self.mainLayer,
    ui = self.ui
  })
  self:setBackground("UI/alpha/1080P/bg/guild_bg.png")
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self.ui.title:setVisible(false)
  ed.UITool.createSceneTitle(T("\229\133\172 \228\188\154"), self.ui.bg_title, {
    position = ccp(20, 18)
  })
  self:adaptUI()
  self:initLabels()
  ed.setString(self.ui.guildname, ed.GuildManager.name)
  ed.setString(self.ui.member_num, string.format("%d/%d", ed.GuildManager.memberCnt, ed.GuildManager.maxMember))
  ed.setString(self.ui.guildid, ed.GuildManager.guildId)
  ed.setString(self.ui.liveness, ed.GuildManager.vitality)
  ed.setString(self.ui.label_slogan, ed.GuildManager.slogan or T("\230\156\170\232\174\190\231\189\174\229\174\163\232\168\128"))
  self.ui.btn_setSlogan:setVisible(ed.player:getGuildJob() ~= "member")
  local guildIcon = ed.createGuildAvatar(ed.GuildManager.avatar, ed.GuildManager.frame)
  ed.UITool.replaceUI(self.ui, "layer_top", "avatar", guildIcon)
  self:initLivenessPanel()
  self:createDraglist()
  self:createMainFca()
  self:refreshGuildClashEnter()
  self:refreshGuildMountEnter()
  self:refreshBtnPosition()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("guild_clash_enter", self, {
    handle = function(value)
      self.ui.image_guildwar_reddot:setVisible(0 < value)
    end
  })
  self.redPointMgr:registerValueChange(" guild_weeklyjob_enter", self, {
    handle = function(value)
      self.ui.image_weeklyjob_reddot:setVisible(0 < value)
    end
  })
  self.ui.image_mount_reddot:setVisible(ed.GuildMountManager:getRedFlag())
  self.ui.btn_manage_reddot:setVisible(ed.GuildManager.guildJoinNotify ~= nil)
  self:listenEvent("MainBuildRedTagChange", function(building)
    if building == ed.ui.configs.mainSceneMap.builddingType.Guild then
      self.ui.image_mount_reddot:setVisible(ed.GuildMountManager:getRedFlag())
      self.ui.btn_manage_reddot:setVisible(ed.GuildManager.guildJoinNotify ~= nil)
    end
  end)
  local red = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  red:setPosition(ccp(26, 30))
  self.ui.btn_find:addChild(red)
  red:setVisible(false)
  ed.GuildRecruitNetwork:sendGuildRecruitOpenPanel()
  self:listenEvent("GuildRecruitReply", function(type)
    if type == "OpenPanel" or type == "notify" then
      local redInfo = ed.GuildManager:getShowRecruitRed()
      red:setVisible(redInfo.subRed or redInfo.entryRed or redInfo.guideSubRed)
      self.ui.btn_find:stopAllActions()
      if redInfo.subRed or redInfo.entryRed or redInfo.guideSubRed then
        self.ui.btn_find:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(CCDelayTime:create(3), CCCallFunc:create(function()
          local posx, posy = self.ui.btn_find:getPosition()
          self.ui.btn_find:runAction(CCSequence:create(ccArrayMake(unpack({
            CCMoveTo:create(0.8, ccp(posx, posy + 7)),
            CCEaseElasticOut:create(CCMoveTo:create(0.9, ccp(posx, posy)))
          }))))
          self.ui.btn_find:runAction(CCSequence:create(ccArrayMake(unpack({
            CCEaseBackIn:create(CCRotateBy:create(0.2, -10)),
            CCRotateBy:create(0.14, 20),
            CCRotateBy:create(0.13, -20),
            CCRotateBy:create(0.12, 15),
            CCRotateBy:create(0.11, -10),
            CCEaseBackOut:create(CCRotateBy:create(0.17, 5))
          }))))
        end)))))
      end
    end
  end)
end

function GuildMainScene:showRuleInfo()
  ed.ui.GuildRuleWin.create({}):popWindow()
end

function GuildMainScene:refreshGuildClashEnter()
  local isOffSeason = ed.GuildClashManager:isOffSeason()
  self.ui.btn_guildwar:setVisible(not isOffSeason)
end

function GuildMainScene:refreshGuildMountEnter()
  local isOffSeason = ed.GuildMountManager:isOffSeason()
  self.ui.btn_mount:setVisible(not isOffSeason)
end

function GuildMainScene:refreshBtnPosition()
  if nil == self.funcBtnList then
    self.funcBtnList = {
      self.ui.btn_shop,
      self.ui.btn_mercenary,
      self.ui.btn_raid,
      self.ui.btn_worship,
      self.ui.btn_weeklyjob,
      self.ui.btn_guildwar,
      self.ui.btn_mount
    }
  end
  local posX = 855
  local spaceX = 75
  for i, v in ipairs(self.funcBtnList) do
    if ed.checkVisible(v) then
      v:setPositionX(posX)
      posX = posX - spaceX
    end
  end
end

function GuildMainScene:refreshSetting()
  ed.setString(self.ui.guildname, ed.GuildManager.name)
  ed.setString(self.ui.label_slogan, ed.GuildManager.slogan)
  local guildIcon = ed.createGuildAvatar(ed.GuildManager.avatar, ed.GuildManager.frame)
  ed.UITool.replaceUI(self.ui, "layer_top", "avatar", guildIcon)
end

function GuildMainScene:registerEvents()
  self:listenEvent("GuildSettingRefresh", function()
    self:refreshSetting()
  end)
  self:listenEvent("GuildMercenaryReply", function()
    if ed.getCurrentScene().identity == "GuildMainScene" then
      ed.ui.GuildSetMercenaryWin.create()
    end
  end)
  self:listenEvent("GuildWeeklyjobReply", function()
    if ed.getCurrentScene().identity == "GuildMainScene" and nil == ed.getPopWindow("GuildWeeklyjobWin") then
      ed.ui.GuildWeeklyjobWin.create()
    else
      FireEvent("GuildWeeklyjobWinRefresh")
    end
  end)
  self:listenEvent("GuildMemberRefresh", function()
    ed.setString(self.ui.member_num, string.format("%d/%d", #ed.GuildManager.members, ed.GuildManager.maxMember))
    self:refreshDraglist()
  end)
  self:listenEvent("GuildRaidOpenPanel", function()
    ed.ui.GuildSelectRaidWin.create({
      callback = function()
        ed.setString(self.ui.liveness, ed.GuildManager.vitality)
      end
    })
  end)
end

function GuildMainScene:doClickRaid()
  local ds = ed.playerlimit.getAreaUnlockPrompt("Raid")
  if ds then
    ed.showToast(ds)
    return
  end
  ed.GuildRaidNetwork:sendOpenPanel()
end

function GuildMainScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "btn_setSlogan", function()
    ed.ui.GuildSetSloganWin.create()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_rule", function()
    self:showRuleInfo()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_find", function()
    ed.GuildNetwork:sendQueryGuildList()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_manage", function()
    if ed.player:getGuildJob() == "member" then
      ed.ui.GuildManageMemWin.create()
    else
      ed.ui.GuildManageWin.create()
    end
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_log", function()
    ed.registerNetReply("query_guildlog", function(data)
      ed.showGuildLog(data)
    end)
    local msg = ed.upmsg.request_guild_log()
    ed.send(msg, "request_guild_log")
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_rule_liveness", function()
    self.ui.bg_liveness_info:setVisible(not self.ui.bg_liveness_info:isVisible())
  end, {pressScale = 0.55, normalScale = 0.6})
  ed.UITool.registerBtn(self, "btn_worship", function()
    ed.ui.GuildWorshipInfoWin.create()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_raid", function()
    self:doClickRaid()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_mercenary", function()
    ed.GuildNetwork:sendQueryMercenary()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_shop", function()
    ed.UITool.openView("shopMain", {page = 5})
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "btn_guildwar", function()
    if not ed.GuildClashManager:isOffSeason() then
      ed.UITool.openView("GuildClashMainScene", {})
    else
      ed.showToast(T("\229\133\172\228\188\154\230\136\152\230\154\130\230\156\170\229\188\128\229\144\175"))
    end
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_weeklyjob", function()
    ed.taskNetwork:sendWeeklyjob(ed.weeklyjobData.ModuleType.Guild)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_mount", function()
    ed.UITool.openView("GuildMountScene")
  end, {pressScale = 0.95})
  self:btRegisterOutClick({
    area = self.ui.bg_liveness_info,
    key = "clickOut",
    clickHandler = function()
      self.ui.bg_liveness_info:setVisible(false)
    end,
    force = true
  })
end

function GuildMainScene:onPopScene()
  self.redPointMgr:unregisterAllValueChange(self)
  base.onPopScene(self)
end

function GuildMainScene.create(param)
  local self = base.create("GuildMainScene", {noBottomButton = true})
  setmetatable(self, GuildMainScene.mt)
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  if param and param.toChairman then
    ed.showAlertDialog({
      text = T("\230\129\173\229\150\156\228\189\160\232\162\171\230\143\144\229\141\135\228\184\186\228\188\154\233\149\191"),
      skipDestroyAnim = true
    })
  end
  return self
end
