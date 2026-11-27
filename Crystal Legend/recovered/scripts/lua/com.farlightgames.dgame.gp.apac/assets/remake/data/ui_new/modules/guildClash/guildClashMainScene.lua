local base = ed.ui.commonscene
local GuildClashMainScene = newclass(base.mt)
ed.ui.GuildClashMainScene = GuildClashMainScene
local walkTime = 2
local resConfig = {
  victory = 1,
  narrow_victory = 3,
  kill = 2,
  triple_kill = 4,
  ultra_kill = 5,
  rampage = 6
}
local popMsgType = {
  T("  %s\229\135\187\232\180\165\228\186\134%s  "),
  T("  %s\231\167\146\230\157\128\228\186\134%s  "),
  T("  %s\233\153\169\232\131\156\228\186\134%s  "),
  T("  %s\229\135\187\232\180\165\228\186\134%s,\229\174\140\230\136\144\228\186\134\228\184\137\230\157\128  "),
  T("  %s\229\135\187\232\180\165\228\186\134%s,\229\174\140\230\136\144\228\186\134\229\155\155\230\157\128  "),
  T("  %s\229\135\187\232\180\165\228\186\134%s,\229\183\178\231\187\143\230\154\180\232\181\176  ")
}
local lineIconRes = {
  "icon_toproad",
  "icon_midroad",
  "icon_botroad"
}

function GuildClashMainScene:initLabels()
  local _, titleTxt = ed.UITool.createSceneTitle(T("\229\133\172\228\188\154\230\136\152"), self.ui.bg_title, {
    position = ccp(13, 18)
  })
  ed.layout.relateLayout(titleTxt, self.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  if EDCurLanguage == "es" then
    local bg_step_info_posY = self.ui.bg_step_info:getPositionY()
    ed.layout.relateLayout(self.ui.btn_rule, self.ui.bg_step_info, {right = 20})
    self.ui.bg_step_info:setPositionY(bg_step_info_posY)
    ed.layout.relateLayout(self.ui.btn_rule, self.ui.ImageView_131, {right = 20})
    self.ui.ImageView_131:setPositionY(bg_step_info_posY)
  end
  self.ui.name_camp1_guild:setFontName(ed.fontBold)
  self.ui.name_camp1_guild1:setFontName(ed.fontBold)
  self.ui.name_camp2_guild:setFontName(ed.fontBold)
  self.ui.name_camp2_guild1:setFontName(ed.fontBold)
  local camp1Color = ed.toccc3(16776423)
  local camp1StrokeColor = ed.toccc3(6496031)
  local camp2Color = ed.toccc3(16751724)
  local camp2StrokeColor = ed.toccc3(5380371)
  if self.mgr.campId == 2 then
    camp1Color = ed.toccc3(16751724)
    camp1StrokeColor = ed.toccc3(5380371)
    camp2Color = ed.toccc3(16776423)
    camp2StrokeColor = ed.toccc3(6496031)
    ed.setLabelStroke(self.ui.label_notice_title, ed.toccc3(4071199), 1)
    ed.setLabelColor(self.ui.label_notice_title, ed.toccc3(16307844))
    ed.setLabelStroke(self.ui.Label_564, ed.toccc3(4203556), 1)
    ed.setLabelColor(self.ui.Label_564, ed.toccc3(15969688))
    ed.setLabelStroke(self.ui.label_notice, ed.toccc3(4203556), 1)
    ed.setLabelColor(self.ui.label_notice, ed.toccc3(16776423))
  else
    ed.setLabelStroke(self.ui.label_notice_title, ed.toccc3(1319466), 1)
    ed.setLabelStroke(self.ui.Label_564, ed.toccc3(2373672), 1)
    ed.setLabelStroke(self.ui.label_notice, ed.toccc3(2373672), 1)
  end
  ed.setLabelColor(self.ui.name_camp1_guild, camp1Color)
  ed.setLabelStroke(self.ui.name_camp1_guild, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.name_camp1_guild1, camp1Color)
  ed.setLabelStroke(self.ui.name_camp1_guild1, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_guild_chair1, camp1Color)
  ed.setLabelStroke(self.ui.camp1_guild_chair1, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_guild_member1, camp1Color)
  ed.setLabelStroke(self.ui.camp1_guild_member1, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_guild_wincount1, camp1Color)
  ed.setLabelStroke(self.ui.camp1_guild_wincount1, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_guild_server, camp1Color)
  ed.setLabelStroke(self.ui.camp1_guild_server, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_guild_chair, camp1Color)
  ed.setLabelStroke(self.ui.camp1_guild_chair, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_guild_member, camp1Color)
  ed.setLabelStroke(self.ui.camp1_guild_member, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_guild_wincount, camp1Color)
  ed.setLabelStroke(self.ui.camp1_guild_wincount, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_name_tower_bottom, camp1Color)
  ed.setLabelStroke(self.ui.camp1_name_tower_bottom, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_name_tower_mid, camp1Color)
  ed.setLabelStroke(self.ui.camp1_name_tower_mid, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.camp1_name_tower_top, camp1Color)
  ed.setLabelStroke(self.ui.camp1_name_tower_top, camp1StrokeColor, 1)
  ed.setLabelColor(self.ui.name_camp2_guild, camp2Color)
  ed.setLabelStroke(self.ui.name_camp2_guild, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.name_camp2_guild1, camp2Color)
  ed.setLabelStroke(self.ui.name_camp2_guild1, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_guild_chair1, camp2Color)
  ed.setLabelStroke(self.ui.camp2_guild_chair1, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_guild_member1, camp2Color)
  ed.setLabelStroke(self.ui.camp2_guild_member1, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_guild_wincount1, camp2Color)
  ed.setLabelStroke(self.ui.camp2_guild_wincount1, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_guild_server, camp2Color)
  ed.setLabelStroke(self.ui.camp2_guild_server, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_guild_chair, camp2Color)
  ed.setLabelStroke(self.ui.camp2_guild_chair, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_guild_member, camp2Color)
  ed.setLabelStroke(self.ui.camp2_guild_member, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_guild_wincount, camp2Color)
  ed.setLabelStroke(self.ui.camp2_guild_wincount, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_name_tower_bottom, camp2Color)
  ed.setLabelStroke(self.ui.camp2_name_tower_bottom, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_name_tower_mid, camp2Color)
  ed.setLabelStroke(self.ui.camp2_name_tower_mid, camp2StrokeColor, 1)
  ed.setLabelColor(self.ui.camp2_name_tower_top, camp2Color)
  ed.setLabelStroke(self.ui.camp2_name_tower_top, camp2StrokeColor, 1)
  ed.setLabelShadow(self.ui.Label_6141, ed.toccc3(0), ccp(1, 1))
  ed.setLabelShadow(self.ui.Label_614, ed.toccc3(0), ccp(1, 1))
  ed.setLabelStroke(self.ui.Label_555, ed.toccc3(7680032), 1)
  ed.setLabelStroke(self.ui.label_stepname, ed.toccc3(1446670), 1)
  ed.setLabelStroke(self.ui.label_steptime, ed.toccc3(1446670), 1)
  ed.setLabelStroke(self.ui.label_steptime1, ed.toccc3(3744789), 1)
  ed.setLabelStroke(self.ui.label_stepname1, ed.toccc3(3744789), 1)
  ed.setLabelDimensions(self.ui.label_notice, CCSizeMake(180, 0))
  ed.setLabelStroke(self.ui.label_btn1, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_btn2, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.label_btn3, ed.toccc3(594187), 1)
  ed.setLabelStroke(self.ui.Label_132, ed.toccc3(3744789), 1)
  self.ui.Label_132:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.ui.Label_132:limitSizeByScale(300, 40)
  self.camp1Color = string.gsub(tostring(camp1Color), " ", "")
  self.camp1StrokeColor = string.gsub(tostring(camp1StrokeColor), " ", "")
  self.camp2Color = string.gsub(tostring(camp2Color), " ", "")
  self.camp2StrokeColor = string.gsub(tostring(camp2StrokeColor), " ", "")
  self.ui.label_notice_title:limitWidthByScale(62)
  ed.right2(self.ui.camp1_guild_chair1, self.ui.camp1_guild_chair, 6)
  ed.right2(self.ui.camp1_guild_member1, self.ui.camp1_guild_member, 6)
  ed.right2(self.ui.camp1_guild_wincount1, self.ui.camp1_guild_wincount, 6)
  ed.right2(self.ui.camp2_guild_chair1, self.ui.camp2_guild_chair, 6)
  ed.right2(self.ui.camp2_guild_member1, self.ui.camp2_guild_member, 6)
  ed.right2(self.ui.camp2_guild_wincount1, self.ui.camp2_guild_wincount, 6)
  self.ui.Label_564:limitWidthByScale(150)
  local lab_wid = self.ui.Label_564:getContentSize().width * self.ui.Label_564:getScale()
  local btn_size = self.ui.btn_edit_notice:getContentSize()
  if lab_wid + 25 > btn_size.width then
    self.ui.btn_edit_notice:setContentSize(CCSizeMake(lab_wid + 25, btn_size.height))
  end
end

function GuildClashMainScene:initData()
  self.mgr = ed.GuildClashManager
  self.playingLanterns = 0
  self.camp1Team = {}
  self.camp2Team = {}
  self.curBattleData = {}
  self.battleUI = {}
  self.curTime = ed.getServerTime() - self.mgr:getStateStartTime()
  if self.mgr.campId == 1 or self.mgr.campId == 2 then
    ed.GuildClashNetwork:sendSummaryInfo(3)
    ed.GuildClashNetwork:sendUserTeam()
  end
end

function GuildClashMainScene:adaptUI()
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
  ed.layout.layoutWithMagin(self.ui.bg_step_info, {left = 300})
  ed.layout.layoutWithMagin(self.ui.ImageView_131, {left = 300})
  ed.layout.layoutWithMagin(self.ui.bg_guild_notice, {left = 30})
  ed.layout.layoutWithMagin(self.ui.bg_btn1, {right = 30})
  ed.layout.layoutWithMagin(self.ui.bg_btn2, {right = 30})
  ed.layout.layoutWithMagin(self.ui.bg_btn3, {right = 30})
  ed.layout.layoutWithMagin(self.ui.btn_set_defend, {right = 210})
  ed.layout.layoutWithMagin(self.ui.btn_set_team, {right = 40})
end

function GuildClashMainScene:initKeyPoint()
  self.lineKeyPoints = {}
  self.distance = {}
  for k, v in ipairs({
    "top",
    "mid",
    "bottom"
  }) do
    self.lineKeyPoints[k] = {}
    for i = 0, 4 do
      local x, y = self.ui[v .. i]:getPosition()
      table.insert(self.lineKeyPoints[k], ccp(x, y))
    end
    self.distance[k] = {}
    for i = 1, 4 do
      local distance = ccpDistance(self.lineKeyPoints[k][i], self.lineKeyPoints[k][i + 1])
      table.insert(self.distance[k], distance)
    end
  end
end

function GuildClashMainScene:createGuildIdents()
  local camp1MainTowerFca = ed.createSpine("effect/eff_UI_GVG_nature_base/eff_UI_GVG_nature_base", 0.5)
  camp1MainTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "bg", "camp1_main", camp1MainTowerFca)
  local camp1TopTowerFca = ed.createSpine("effect/eff_UI_GVG_nature_tower/eff_UI_GVG_nature_tower", 0.5)
  camp1TopTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "touchArea_camp1_top", "camp1_tower_top", camp1TopTowerFca)
  local camp1MidTowerFca = ed.createSpine("effect/eff_UI_GVG_nature_tower/eff_UI_GVG_nature_tower", 0.5)
  camp1MidTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "touchArea_camp1_mid", "camp1_tower_mid", camp1MidTowerFca)
  local camp1BottomTowerFca = ed.createSpine("effect/eff_UI_GVG_nature_tower/eff_UI_GVG_nature_tower", 0.5)
  camp1BottomTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "touchArea_camp1_bottom", "camp1_tower_bottom", camp1BottomTowerFca)
  local camp2MainTowerFca = ed.createSpine("effect/eff_UI_GVG_dark_base/eff_UI_GVG_dark_base", 0.5)
  camp2MainTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "bg", "camp2_main", camp2MainTowerFca)
  local camp2TopTowerFca = ed.createSpine("effect/eff_UI_GVG_dark_tower/eff_UI_GVG_dark_tower", 0.5)
  camp2TopTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "touchArea_camp2_top", "camp2_tower_top", camp2TopTowerFca)
  local camp2MidTowerFca = ed.createSpine("effect/eff_UI_GVG_dark_tower/eff_UI_GVG_dark_tower", 0.5)
  camp2MidTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "touchArea_camp2_mid", "camp2_tower_mid", camp2MidTowerFca)
  local camp2BottomTowerFca = ed.createSpine("effect/eff_UI_GVG_dark_tower/eff_UI_GVG_dark_tower", 0.5)
  camp2BottomTowerFca:setAnimation(0, "Idle", true)
  ed.UITool.replaceUI(self.ui, "touchArea_camp2_bottom", "camp2_tower_bottom", camp2BottomTowerFca)
end

function GuildClashMainScene:createSceneParticle()
  local points = {
    ccp(352, 380),
    ccp(529, 388),
    ccp(708, 258),
    ccp(773, 319)
  }
  for i = 1, 4 do
    local particle1 = CCParticleSystemQuad:create("UI/particle/GVG_dark.plist")
    particle1:setPosition(points[i])
    self.ui.bg:addChild(particle1)
  end
  local points = {
    ccp(215, 278),
    ccp(512, 142),
    ccp(338, 240),
    ccp(306, 130)
  }
  for i = 1, 4 do
    local particle1 = CCParticleSystemQuad:create("UI/particle/GVG_nature.plist")
    particle1:setPosition(points[i])
    self.ui.bg:addChild(particle1)
  end
end

function GuildClashMainScene:createSceneFca()
  self:createGuildIdents()
  self:createSceneParticle()
end

function GuildClashMainScene:refreshStateInfo()
  if self.mgr.campId == 0 then
    self.ui.ImageView_131:setVisible(true)
    self.ui.bg_step_info:setVisible(false)
    if ed.isElementInTable(self.mgr.stateType, {
      "SeasonEnd",
      "ClashEnd",
      "MatchGuilds"
    }) then
      self.ui.ImageView_131:setVisible(false)
      self.ui.bg_step_info:setVisible(true)
      ed.setString(self.ui.label_stepname1, self.mgr.stateName)
      ed.setString(self.ui.label_steptime1, self.mgr:getTimeToNextState())
    elseif ed.isElementInTable(self.mgr.stateType, {"ClashShow"}) then
      self.ui.ImageView_131:setVisible(false)
      self.ui.bg_step_info:setVisible(true)
      ed.setString(self.ui.label_steptime1, self.mgr:getTimeToNextState())
      if self.mgr.roundId < self.mgr.totalRound then
        ed.setString(self.ui.label_stepname1, T("\232\183\157\231\166\187\228\184\139\232\189\174\229\188\128\229\167\139"))
      else
        ed.setString(self.ui.label_stepname1, T("\232\181\155\229\173\163\229\183\178\231\187\147\230\157\159"))
        ed.setString(self.ui.label_steptime, T("\232\183\157\231\166\187\232\181\155\229\173\163\229\133\179\233\151\173"))
      end
    end
  else
    self.ui.ImageView_131:setVisible(false)
    self.ui.bg_step_info:setVisible(true)
    ed.setString(self.ui.label_stepname1, self.mgr.stateName)
    ed.setString(self.ui.label_steptime1, self.mgr:getTimeToNextState())
    if self.mgr.stateType == "ClashShow" and self.mgr.clashShowEnd >= self.mgr.roundId then
      if self.mgr.roundId < self.mgr.totalRound then
        ed.setString(self.ui.label_stepname1, T("\232\183\157\231\166\187\228\184\139\232\189\174\229\188\128\229\167\139"))
      else
        ed.setString(self.ui.label_stepname1, T("\232\181\155\229\173\163\229\183\178\231\187\147\230\157\159"))
        ed.setString(self.ui.label_steptime, T("\232\183\157\231\166\187\232\181\155\229\173\163\229\133\179\233\151\173"))
      end
    elseif ed.isElementInTable(self.mgr.stateType, {"SeasonEnd", "ClashEnd"}) then
      ed.setString(self.ui.label_steptime, T("\232\183\157\231\166\187\232\181\155\229\173\163\229\133\179\233\151\173"))
    end
    if self.mgr.stateType == "HeadModifyDefender" then
      ed.setString(self.ui.Label_14791, T("\228\188\154\233\149\191\232\176\131\230\149\180\228\184\173"))
    else
      ed.setString(self.ui.Label_14791, self.mgr:getTimeToChairSetting() .. T("\229\144\142\233\148\129\229\174\154"))
    end
  end
end

function GuildClashMainScene:refreshNotice()
  local notice = self.mgr.notice
  local isChairMan = ed.player:getGuildJob() == "chairman"
  if notice and notice ~= "" then
    self.ui.btn_edit_notice:setVisible(false)
    self.ui.label_notice:setVisible(true)
    self.ui.label_notice:setString(notice)
  else
    self.ui.btn_edit_notice:setVisible(isChairMan)
    self.ui.label_notice:setVisible(not isChairMan)
    if not isChairMan then
      self.ui.label_notice:setString(T("\228\188\154\233\149\191\229\190\136\230\135\146\239\188\140\228\187\128\228\185\136\233\131\189\230\178\161\231\149\153\228\184\139\227\128\130"))
    end
  end
end

function GuildClashMainScene:refreshCamp1GuildInfo()
  local camp1GuildInfo = self.mgr.camp1GuildSummary or {}
  local guildSummary = camp1GuildInfo._guild_summary
  if not guildSummary then
    self.ui.bg_camp1_guild:setVisible(false)
    return
  end
  local avatarData = ed.analyzeAvatar(guildSummary._avatar)
  local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  guildIcon:setScale(0.6)
  ed.UITool.replaceUI(self.ui, "bg_camp1_guild", "icon_camp1_guild", guildIcon)
  ed.setString(self.ui.name_camp1_guild, guildSummary._name)
  local guildIconBig = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  guildIconBig:setScale(0.7)
  ed.UITool.replaceUI(self.ui, "bg_camp1_guild_detail", "icon_camp1_guild1", guildIconBig)
  ed.setString(self.ui.name_camp1_guild1, guildSummary._name)
  ed.setString(self.ui.camp1_guild_chair1, guildSummary._president._name)
  local name = ed.getPlayerName(guildSummary._president._name, guildSummary._president._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = self.camp1Color,
    labelStroke = self.camp1StrokeColor
  })
  ed.UITool.replaceUI(self.ui, "bg_camp1_guild_detail", "camp1_guild_chair1", name)
  name:setScale(0.9)
  ed.setString(self.ui.camp1_guild_wincount1, string.format(T("%d\232\131\156%d\232\180\159"), camp1GuildInfo._win_cnt, camp1GuildInfo._lose_cnt or 0))
  ed.adaptLabel(self.ui.camp1_guild_wincount1, {maxWidth = 110, minScale = 0.6})
  ed.setString(self.ui.camp1_guild_member1, string.format(T("%d\229\144\141"), guildSummary._member_cnt))
  ed.setString(self.ui.camp1_guild_server, camp1GuildInfo._svr_name or T("\230\156\170\231\159\165\233\148\153\232\175\175"))
end

function GuildClashMainScene:refreshCamp2GuildInfo()
  local camp2GuildInfo = self.mgr.camp2GuildSummary or {}
  local guildSummary = camp2GuildInfo._guild_summary
  if not guildSummary then
    self.ui.bg_camp2_guild:setVisible(false)
    return
  end
  local avatarData = ed.analyzeAvatar(guildSummary._avatar)
  local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  guildIcon:setScale(0.6)
  ed.UITool.replaceUI(self.ui, "bg_camp2_guild", "icon_camp2_guild", guildIcon)
  ed.setString(self.ui.name_camp2_guild, guildSummary._name)
  local guildIconBig = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  guildIconBig:setScale(0.7)
  ed.UITool.replaceUI(self.ui, "bg_camp2_guild_detail", "icon_camp2_guild1", guildIconBig)
  ed.setString(self.ui.name_camp2_guild1, guildSummary._name)
  ed.setString(self.ui.camp2_guild_chair1, guildSummary._president._name)
  local name = ed.getPlayerName(guildSummary._president._name, guildSummary._president._medal, {
    anchorPoint = ccp(0, 0.5),
    labelColor = self.camp2Color,
    labelStroke = self.camp2StrokeColor
  })
  ed.UITool.replaceUI(self.ui, "bg_camp2_guild_detail", "camp2_guild_chair1", name)
  name:setScale(0.9)
  ed.setString(self.ui.camp2_guild_wincount1, string.format(T("%d\232\131\156%d\232\180\159"), camp2GuildInfo._win_cnt or 0, camp2GuildInfo._lose_cnt or 0))
  ed.adaptLabel(self.ui.camp2_guild_wincount1, {maxWidth = 110, minScale = 0.6})
  ed.setString(self.ui.camp2_guild_member1, string.format(T("%d\229\144\141"), guildSummary._member_cnt))
  ed.setString(self.ui.camp2_guild_server, camp2GuildInfo._svr_name or T("\230\156\170\231\159\165\233\148\153\232\175\175"))
end

function GuildClashMainScene:initLineTeamInfo()
  if self.mgr.campId == 1 then
    ed.setString(self.ui.camp1_name_tower_top, string.format(T("%s\233\152\159"), self.mgr:getTotalGuildTeam(1)))
    ed.setString(self.ui.camp1_name_tower_mid, string.format(T("%s\233\152\159"), self.mgr:getTotalGuildTeam(2)))
    ed.setString(self.ui.camp1_name_tower_bottom, string.format(T("%s\233\152\159"), self.mgr:getTotalGuildTeam(3)))
  elseif self.mgr.campId == 2 then
    ed.setString(self.ui.camp2_name_tower_top, string.format(T("%s\233\152\159"), self.mgr:getTotalGuildTeam(1)))
    ed.setString(self.ui.camp2_name_tower_mid, string.format(T("%s\233\152\159"), self.mgr:getTotalGuildTeam(2)))
    ed.setString(self.ui.camp2_name_tower_bottom, string.format(T("%s\233\152\159"), self.mgr:getTotalGuildTeam(3)))
  end
end

function GuildClashMainScene:refreshTowerInfo()
  if self.mgr.campId == 0 then
    return
  end
  local name = {
    "top",
    "mid",
    "bottom"
  }
  if self.mgr.stateType == "ClashShow" then
    local curTime = ed.getServerTime() - self.mgr:getStateStartTime()
    local battleInfos = self.mgr.battleInfos
    if battleInfos then
      for i = 1, 3 do
        if battleInfos[i]._camp1_team_sum == 0 and battleInfos[i]._camp2_team_sum == 0 then
          self.ui["camp1_bg_tower_" .. name[i]]:setVisible(false)
          self.ui["camp2_bg_tower_" .. name[i]]:setVisible(false)
        else
          self.ui["camp1_bg_tower_" .. name[i]]:setVisible(true)
          self.ui["camp2_bg_tower_" .. name[i]]:setVisible(true)
          if battleInfos[i]._camp1_team_count == 0 then
            if curTime > battleInfos[i]._summary_time then
              self.ui["camp1_bg_tower_" .. name[i]]:setVisible(false)
              self.ui["camp2_bg_tower_" .. name[i]]:setVisible(false)
              self.ui["camp1_tower_" .. name[i]]:setAnimation(0, "Death", true)
            end
          elseif battleInfos[i]._camp2_team_count == 0 then
            if curTime > battleInfos[i]._summary_time then
              self.ui["camp1_bg_tower_" .. name[i]]:setVisible(false)
              self.ui["camp2_bg_tower_" .. name[i]]:setVisible(false)
              self.ui["camp2_tower_" .. name[i]]:setAnimation(0, "Death", true)
            end
          else
            ed.setString(self.ui["camp1_name_tower_" .. name[i]], string.format("%s\233\152\159", battleInfos[i]._camp1_team_count))
            ed.setString(self.ui["camp2_name_tower_" .. name[i]], string.format("%s\233\152\159", battleInfos[i]._camp2_team_count))
          end
        end
      end
    end
  elseif ed.isElementInTable(self.mgr.stateType, {
    "ClashEnd",
    "SeasonEnd",
    "MatchGuilds"
  }) then
    self.ui.camp1_bg_tower_top:setVisible(false)
    self.ui.camp1_bg_tower_mid:setVisible(false)
    self.ui.camp1_bg_tower_bottom:setVisible(false)
    self.ui.camp2_bg_tower_top:setVisible(false)
    self.ui.camp2_bg_tower_mid:setVisible(false)
    self.ui.camp2_bg_tower_bottom:setVisible(false)
  elseif self.mgr.campId == 1 then
    self.ui.camp2_bg_tower_top:setVisible(false)
    self.ui.camp2_bg_tower_mid:setVisible(false)
    self.ui.camp2_bg_tower_bottom:setVisible(false)
  elseif self.mgr.campId == 2 then
    self.ui.camp1_bg_tower_top:setVisible(false)
    self.ui.camp1_bg_tower_mid:setVisible(false)
    self.ui.camp1_bg_tower_bottom:setVisible(false)
  end
end

function GuildClashMainScene:refreshBtnState()
  if self.mgr.campId == 0 then
    self.ui.btn_set_team:setVisible(false)
    self.ui.bg_guild_notice:setVisible(false)
    self.ui.btn_set_defend:setVisible(false)
    self.ui.touchArea_camp2_top:setVisible(false)
    self.ui.touchArea_camp2_mid:setVisible(false)
    self.ui.touchArea_camp2_bottom:setVisible(false)
    self.ui.touchArea_camp2_main:setVisible(false)
    return
  end
  self.ui.btn_set_team:setVisible(true)
  self.ui.bg_guild_notice:setVisible(true)
  self.ui.btn_set_defend:setVisible(true)
  local isChairMan = ed.player:getGuildJob() == "chairman" or ed.player:getGuildJob() == "elder"
  if self.mgr.stateType == "HeadModifyDefender" then
    ed.setSpriteShader(self.ui.btn_set_team, "GrayScalingShader_2")
    ed.setSpriteShader(self.ui.ImageView_615, "GrayScalingShader_2")
    self.ui.Label_614:setColor(ccc3(200, 200, 200))
    ed.setString(self.ui.Label_14791, T("\228\188\154\233\149\191\232\176\131\230\149\180\228\184\173"))
    self.ui.btn_set_team:setVisible(not isChairMan)
  else
    ed.updateSpriteGray(self.ui.btn_set_team, false)
    ed.updateSpriteGray(self.ui.ImageView_615, false)
    self.ui.Label_614:setColor(ed.toccc3(16708009))
    ed.setString(self.ui.Label_14791, self.mgr:getTimeToChairSetting() .. T("\229\144\142\233\148\129\229\174\154"))
  end
  if isChairMan then
    if ed.isElementInTable(self.mgr.stateType, {
      "ClashShow",
      "MarchBegin",
      "CountClashResult"
    }) then
      ed.setString(self.ui.Label_6141, T("\230\128\187\232\167\136"))
    else
      ed.setString(self.ui.Label_6141, T("\232\176\131\230\149\180\229\184\131\233\152\178"))
      self.ui.Label_6141:limitWidthByScale(110)
      self.ui.Label_614:setScale(self.ui.Label_6141:getScaleX())
    end
  else
    ed.setString(self.ui.Label_6141, T("\230\128\187\232\167\136"))
  end
  if ed.isElementInTable(self.mgr.stateType, {
    "ClashShow",
    "MarchBegin",
    "CountClashResult",
    "MatchGuilds",
    "ClashEnd",
    "SeasonEnd"
  }) then
    self.ui.btn_set_team:setVisible(false)
    self.ui.bg_guild_notice:setVisible(false)
  end
  if ed.isElementInTable(self.mgr.stateType, {
    "ClashShow",
    "ClashEnd",
    "SeasonEnd",
    "MatchGuilds"
  }) then
    self.ui.btn_set_defend:setVisible(false)
  end
  ed.layout.layoutWithMagin(self.ui.btn_set_defend, {
    right = self.ui.btn_set_team:isVisible() and 210 or 40
  })
end

function GuildClashMainScene:refreshUI()
  self:syncEvents()
  self:refreshStateInfo()
  self:refreshNotice()
  self:refreshCamp1GuildInfo()
  self:refreshCamp2GuildInfo()
  self:refreshTowerInfo()
  self:refreshBtnState()
end

function GuildClashMainScene:initUI()
  local container, ui = ed.editorui(ed.uieditor.GuildClashMainScene)
  self.ui = ui
  self.mainLayer:addChild(container)
  self:setBackButton(function()
    self.mgr.maxEventTime = 0
    self.mgr.eventMap = {}
    self.mgr.mainScene = nil
  end)
  local img_detail = ed.createSprite("UI/alpha/1080P/guild/guild_clash/brawls_details.png")
  self.ui.img_detail = img_detail
  self.ui.ImageView_131:addChild(img_detail)
  img_detail:setPosition(ccp(44.5, 50))
  local lab_detail = ed.createLabelTTF(T("\230\175\148\232\181\155\232\175\166\230\131\133"), 14)
  self.ui.lab_detail = lab_detail
  self.ui.ImageView_131:addChild(lab_detail)
  lab_detail:setPosition(ccp(44, 22))
  ed.setLabelColor(self.ui.lab_detail, ccc3(255, 252, 231))
  ed.setLabelStroke(self.ui.lab_detail, ed.toccc3(7680032), 1)
  self:adaptUI()
  self:initLabels()
  self:initKeyPoint()
  self:createSceneFca()
  if self.mgr.campId == 2 then
    ed.setTexture(self.ui.bg_guild_notice, "UI/alpha/1080P/guild/guild_clash/dark_notice_floor.png")
  end
  self:refreshUI()
  self.redPointMgr = ed.redPointMgr.getInstance()
  self.redPointMgr:registerValueChange("guild_clash_set_team", self, {
    handle = function(value)
      self.ui.image_set_team_reddot:setVisible(0 < value)
    end
  })
end

function GuildClashMainScene:onClickTower(campId, lineId)
  if self.mgr.campId == 0 then
    ed.showToast(T("\230\156\172\232\189\174\230\136\152\230\150\151\229\183\178\232\189\174\231\169\186"))
    return
  end
  if self.mgr.stateType == "ClashShow" then
    self.watchLineId = lineId
    if not self.mgr.teamList[lineId] then
      ed.GuildClashNetwork:sendQueryBattleTeams(lineId)
    else
      FireEvent("GuildClashBattleTeams", self.mgr.teamList[lineId])
    end
  elseif ed.isElementInTable(self.mgr.stateType, {
    "MatchGuilds",
    "ClashEnd",
    "SeasonEnd"
  }) then
  elseif campId == self.mgr.campId then
    if self.mgr.stateType == "HeadModifyDefender" then
      ed.ui.guildClashSetTeamWin.create({lineId = lineId, chairTime = true})
    elseif self.mgr.stateType == "MarchBegin" or self.mgr.stateType == "CountClashResult" then
      ed.ui.guildClashSetTeamWin.create({lineId = lineId, showTime = true})
    else
      ed.ui.guildClashSetTeamWin.create({lineId = lineId})
    end
  elseif self.mgr.stateType == "MarchBegin" or self.mgr.stateType == "CountClashResult" then
    ed.showToast(T("\230\149\140\230\150\185\233\152\159\228\188\141\229\183\178\232\147\132\229\138\191\229\190\133\229\143\145"))
  else
    ed.showToast(T("\230\149\140\230\150\185\230\173\163\229\156\168\233\131\168\231\189\178\229\135\186\229\190\129\233\152\159\228\188\141..."))
  end
end

function GuildClashMainScene:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = ed.GuildClashDefine.RULES_TEXT
    }):popWindow()
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "icon_stepinfo", function()
    ed.UITool.openView("guildClashBattlePop")
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "img_detail", function()
    ed.UITool.openView("guildClashBattlePop")
  end, {pressScale = 0.9})
  ed.UITool.registerBtn(self, "bg_guild_notice", function()
    if ed.player:getGuildJob() == "chairman" then
      ed.ui.GuildClashSetNoticeWin.create({
        callback = function()
          self:refreshNotice()
        end
      })
    end
  end)
  ed.UITool.registerBtn(self, "touchArea_camp1_main", function()
    self.ui.bg_camp1_guild_detail:setVisible(true)
  end, {pressScale = 1})
  ed.UITool.registerBtn(self, "touchArea_camp2_main", function()
    self.ui.bg_camp2_guild_detail:setVisible(not self.ui.bg_camp2_guild_detail:isVisible())
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "touchArea_camp1_bottom", function()
    self:onClickTower(1, 3)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "touchArea_camp1_mid", function()
    self:onClickTower(1, 2)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "touchArea_camp1_top", function()
    self:onClickTower(1, 1)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "touchArea_camp2_bottom", function()
    if self.ui.bg_camp2_guild_detail:isVisible() then
      return
    end
    self:onClickTower(2, 3)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "touchArea_camp2_mid", function()
    self:onClickTower(2, 2)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "touchArea_camp2_top", function()
    self:onClickTower(2, 1)
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "btn_set_defend", function()
    ed.ui.GuildClashChairSetTeam.create()
  end, {pressScale = 0.78, normalScale = 0.8})
  ed.UITool.registerBtn(self, "btn_set_team", function()
    self.redPointMgr:setNodeValue("guild_clash_set_team", false)
    self:onClickTower(self.mgr.campId, 1)
    local seasonId = self.mgr:getSeasonId()
    local roundId = self.mgr:getRoundId()
    ed.storage.setValue(ed.getRoleKey("GuildClashSetTeam" .. seasonId .. roundId), true)
  end, {pressScale = 0.78, normalScale = 0.8})
  ed.UITool.registerBtn(self, "bg_btn1", function()
    ed.UITool.openView("guildClashRankScene", {})
  end, {pressScale = 0.98, priority = -999})
  ed.UITool.registerBtn(self, "bg_btn2", function()
    ed.UITool.openView("guildClashRewardWin")
  end, {pressScale = 0.98, priority = -999})
  ed.UITool.registerBtn(self, "bg_btn3", function()
    ed.GuildClashNetwork:sendQueryGoods()
  end, {pressScale = 0.98, priority = -999})
  self:btRegisterOutClick({
    area = self.ui.touchArea_camp1_main,
    key = "camp1_out_click",
    clickHandler = function()
      self.ui.bg_camp1_guild_detail:setVisible(false)
    end,
    force = true
  })
  self:btRegisterOutClick({
    area = self.ui.touchArea_camp2_main,
    key = "camp2_out_click",
    clickHandler = function()
      self.ui.bg_camp2_guild_detail:setVisible(false)
    end,
    force = true
  })
end

function GuildClashMainScene:timeMoving()
  self:refreshStateInfo()
  self.curTime = ed.getServerTime() - self.mgr:getStateStartTime()
  if ed.getServerTime() >= self.mgr:getStateEndTime() and self.mgr.newData then
    ed.GuildClashNetwork:sendOpenPanel()
    self.mgr.newData = false
  end
  local endTime = 0
  for k, v in pairs(ed.getDataTable("GuildClashSchedule")) do
    if v["State Type"] == "SeasonEnd" then
      endTime = ed.dateStringToTime(v["Start Time"]) - ed.getFitServerTime()
    end
  end
  if endTime <= 0 and ed.getCurrentScene().identity == "GuildClashMainScene" then
    ed.popScene()
  end
end

function GuildClashMainScene:syncEvents(isFirst)
  if self.mgr.stateType == "ClashShow" and self.mgr.clashShowEnd < self.mgr.roundId then
    ed.GuildClashNetwork:sendSyncEvents(self.mgr.maxEventTime)
  end
end

function GuildClashMainScene:touch()
  local function handler(event, x, y)
    xpcall(function()
      print(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

function GuildClashMainScene:getActorHeroId(campId, battle)
  return campId == 1 and battle._camp1_hero or battle._camp2_hero
end

function GuildClashMainScene:createTeamName(campId, userId)
  local bg = ed.createSprite("UI/alpha/1080P/guild/guild_clash/role_background.png")
  local summary = self.mgr:getUserSummary(userId, campId)
  local fontName = campId == self.mgr.campId and "guild_clash_self" or "guild_clash_oppo"
  local head = ed.getWholeHeadIcon({
    id = summary._avatar,
    name = summary._name,
    medal = summary._medal,
    scale = 0.3,
    no_name_bg = true,
    config = {namefont = fontName, nameposition = -28}
  })
  bg:addChild(head)
  head:setPosition(ccp(13, 14))
  if campId == 1 then
    bg:setPositionY(75)
  elseif campId == 2 then
    bg:setPositionY(75)
  end
  return bg
end

function GuildClashMainScene:createTeamActor(lineId, campId, heroId, userId, actionName)
  local lineData = self.lineKeyPoints[lineId]
  local node = CCSprite:create()
  node:setCascadeOpacityEnabled(true)
  local initPosIdx = 3
  local actionName = actionName
  local offsetPos = campId == 1 and ccp(-10, -10) or ccp(10, 10)
  if actionName == "Move" then
    initPosIdx = campId == 1 and 1 or 5
    offsetPos = ccp(0, 0)
  elseif actionName == "Cheer" then
    offsetPos = ccp(0, 0)
  end
  node:setPosition(ccpAdd(offsetPos, lineData[initPosIdx]))
  local actor = ed.readhero.getActor(heroId, actionName, true)
  self:addFca(actor)
  node:addChild(actor)
  node:addChild(self:createTeamName(campId, userId))
  self.ui.bg:addChild(node, campId == 1 and 1 or 0)
  actor:setScale(0.3)
  if campId ~= 1 then
    actor:setScaleX(-0.3)
  end
  table.insert(self.battleUI, node)
  return {node = node, actor = actor}
end

function GuildClashMainScene:getRightAtkActions(lineId, actions, battle)
  local actor = self.camp2Team[lineId].actor
  local node = self.camp2Team[lineId].node
  local nowTime = ed.getServerTime() - self.mgr:getStateStartTime()
  table.insert(actions, CCCallFunc:create(function()
    actor:setAction("atk")
    if battle._win_camp == 1 then
      self.camp2Team[lineId] = nil
    end
  end))
  table.insert(actions, CCDelayTime:create(math.max(0, battle._end_time - battle._start_time - 1)))
  local callfunc = CCCallFunc:create(function()
    if battle._win_camp ~= 1 then
      actor:setAction("Cheer")
    else
      actor:setAction("Death")
      self:listenTimer(Timer:Once(1), function()
        self:removeFca(actor)
        if not tolua.isnull(node) then
          node:removeFromParentAndCleanup(true)
        end
      end)
    end
  end)
  table.insert(actions, callfunc)
end

function GuildClashMainScene:getRightMoveActions(lineId, actions, battle)
  local nowTime = ed.getServerTime() - self.mgr:getStateStartTime()
  local lineData = self.lineKeyPoints[lineId]
  local load1 = CCMoveTo:create(math.max(0, battle._start_time - nowTime) / 2, lineData[4])
  table.insert(actions, load1)
  local load2 = CCMoveTo:create(math.max(0, battle._start_time - nowTime) / 2, ccpAdd(ccp(10, 10), lineData[3]))
  table.insert(actions, load2)
end

function GuildClashMainScene:getRightActions(lineId, actions, battle, actionName)
  local nowTime = ed.getServerTime() - self.mgr:getStateStartTime()
  if actionName == "Move" then
    self:getRightMoveActions(lineId, actions, battle)
  else
    table.insert(actions, CCDelayTime:create(math.max(0, battle._start_time - nowTime)))
  end
  self:getRightAtkActions(lineId, actions, battle)
  return actions
end

function GuildClashMainScene:getLeftMoveActions(lineId, actions, battle)
  local nowTime = ed.getServerTime() - self.mgr:getStateStartTime()
  local lineData = self.lineKeyPoints[lineId]
  local load1 = CCMoveTo:create(math.max(0, battle._start_time - nowTime) / 2, lineData[2])
  table.insert(actions, load1)
  local load2 = CCMoveTo:create(math.max(0, battle._start_time - nowTime) / 2, ccpAdd(ccp(-10, -10), lineData[3]))
  table.insert(actions, load2)
end

function GuildClashMainScene:getLeftAtkActions(lineId, actions, battle)
  local actor = self.camp1Team[lineId].actor
  local node = self.camp1Team[lineId].node
  local nowTime = ed.getServerTime() - self.mgr:getStateStartTime()
  table.insert(actions, CCCallFunc:create(function()
    actor:setAction("atk")
    if battle._win_camp ~= 1 then
      self.camp1Team[lineId] = nil
    end
  end))
  table.insert(actions, CCDelayTime:create(math.max(0, battle._end_time - battle._start_time - 1)))
  local callfunc = CCCallFunc:create(function()
    if battle._win_camp == 1 then
      actor:setAction("Cheer")
    else
      actor:setAction("Death")
      self:listenTimer(Timer:Once(1), function()
        self:removeFca(actor)
        if not tolua.isnull(node) then
          node:removeFromParentAndCleanup(true)
        end
      end)
    end
  end)
  table.insert(actions, callfunc)
end

function GuildClashMainScene:getLeftActions(lineId, actions, battle, actionName)
  local nowTime = ed.getServerTime() - self.mgr:getStateStartTime()
  if actionName == "Move" then
    self:getLeftMoveActions(lineId, actions, battle)
  else
    table.insert(actions, CCDelayTime:create(math.max(0, battle._start_time - nowTime)))
  end
  self:getLeftAtkActions(lineId, actions, battle)
  return actions
end

function GuildClashMainScene:PopResultImg(lineId, battle)
  local name = {
    "top",
    "mid",
    "bottom"
  }
  local lineData = self.lineKeyPoints[lineId]
  local resultImg = ed.createSprite(string.format("UI/alpha/1080P/guild/guild_clash/art%d.png", resConfig[battle._type]))
  self.ui.bg:addChild(resultImg)
  resultImg:setPosition(ccpAdd(ccp(0, 90), lineData[3]))
  resultImg:setOpacity(0)
  resultImg:setScale(0.1)
  local sequence = CCSequence:create(ccArrayMake({
    CCSpawn:create(ccArrayMake({
      CCEaseSineIn:create(CCFadeIn:create(0.25)),
      CCEaseSineIn:create(CCScaleTo:create(0.25, 1.2))
    })),
    CCScaleTo:create(0.1, 1),
    CCDelayTime:create(0.3),
    CCSpawn:create(ccArrayMake({
      CCFadeOut:create(1),
      CCMoveBy:create(1, ccp(0, 30))
    }))
  }))
  resultImg:runAction(sequence)
  local battleInfo = self.mgr.battleInfos[lineId]
  local winCamp = battle._win_camp
  local win = self.mgr:getUserSummary(battle._team1._uid, 1)
  local lose = self.mgr:getUserSummary(battle._team2._uid, 2)
  if winCamp ~= 1 then
    win = self.mgr:getUserSummary(battle._team2._uid, 2)
    lose = self.mgr:getUserSummary(battle._team1._uid, 1)
  end
  FireEvent("GuildClashPopBattleMsg", {
    winCamp = battle._win_camp,
    lineId = lineId,
    type = battle._type,
    win = win,
    lose = lose
  })
  if winCamp == 2 then
    battleInfo._camp1_team_count = math.max(0, battleInfo._camp1_team_count - 1)
    local labelName = string.format("camp1_name_tower_%s", name[lineId])
    ed.setString(self.ui[labelName], string.format("%s\233\152\159", battleInfo._camp1_team_count))
  else
    battleInfo._camp2_team_count = math.max(0, battleInfo._camp2_team_count - 1)
    local labelName = string.format("camp2_name_tower_%s", name[lineId])
    ed.setString(self.ui[labelName], string.format("%s\233\152\159", battleInfo._camp2_team_count))
  end
end

function GuildClashMainScene:testOneBattle()
  local DebugData = {
    _line_id = 1,
    _end_time = ed.getServerTime() + 100 - self.mgr:getStateStartTime(),
    _start_time = ed.getServerTime() + 2 - self.mgr:getStateStartTime(),
    _team1 = {_uid = 1},
    _team2 = {_uid = 1},
    _camp1_hero = 1,
    _camp2_hero = 2,
    _team1_win = 0,
    _team2_win = 0,
    _win_camp = 1,
    _type = "victory"
  }
  self:playOneBattle(DebugData)
end

function GuildClashMainScene:playOneBattle(battle)
  local nowTime = ed.getServerTime() - self.mgr:getStateStartTime()
  local lineId = battle._line_id
  self.curBattleData[lineId] = battle
  print("curTime:", nowTime, "startTime:", battle._start_time, "endTime:", battle._end_time)
  if nowTime >= battle._end_time then
    return
  end
  local leftActions = {}
  local rightActions = {}
  local userId1 = battle._team1._uid
  local heroId1 = battle._camp1_hero
  local userId2 = battle._team2._uid
  local heroId2 = battle._camp2_hero
  if nowTime < battle._start_time then
    if not self.camp2Team[lineId] then
      if battle._team2_win > 0 then
        self.camp2Team[lineId] = self:createTeamActor(lineId, 2, heroId2, userId2, "Cheer")
        self:getRightActions(lineId, rightActions, battle, "Cheer")
      else
        self.camp2Team[lineId] = self:createTeamActor(lineId, 2, heroId2, userId2, "Move")
        self:getRightActions(lineId, rightActions, battle, "Move")
      end
      self.camp2Team[lineId].node:runAction(CCSequence:create(ccArrayMake(unpack(rightActions))))
    else
      self:getRightActions(lineId, rightActions, battle, "Cheer")
      self.camp2Team[lineId].node:runAction(CCSequence:create(ccArrayMake(unpack(rightActions))))
    end
    if not self.camp1Team[lineId] then
      if 0 < battle._team1_win then
        self.camp1Team[lineId] = self:createTeamActor(lineId, 1, heroId1, userId1, "Cheer")
        self:getLeftActions(lineId, leftActions, battle, "Cheer")
      else
        self.camp1Team[lineId] = self:createTeamActor(lineId, 1, heroId1, userId1, "Move")
        self:getLeftActions(lineId, leftActions, battle, "Move")
      end
      self.camp1Team[lineId].node:runAction(CCSequence:create(ccArrayMake(unpack(leftActions))))
    else
      self:getLeftActions(lineId, leftActions, battle, "Cheer")
      self.camp1Team[lineId].node:runAction(CCSequence:create(ccArrayMake(unpack(leftActions))))
    end
  else
    if not self.camp2Team[lineId] then
      self.camp2Team[lineId] = self:createTeamActor(lineId, 2, heroId2, userId2, "atk")
      self:getRightActions(lineId, rightActions, battle, "atk")
      self.camp2Team[lineId].node:runAction(CCSequence:create(ccArrayMake(unpack(rightActions))))
    end
    if not self.camp1Team[lineId] then
      self.camp1Team[lineId] = self:createTeamActor(lineId, 1, heroId1, userId1, "atk")
      self:getLeftActions(lineId, leftActions, battle, "atk")
      self.camp1Team[lineId].node:runAction(CCSequence:create(ccArrayMake(unpack(leftActions))))
    end
  end
  if nowTime < battle._end_time then
    self:listenTimer(Timer:Once(battle._end_time - nowTime), function()
      self:PopResultImg(lineId, battle)
    end)
  end
end

function GuildClashMainScene:test1()
  local summary = {
    _line_id = 3,
    _win_camp = 2,
    _team = {_uid = 1},
    _hero_id = 1
  }
  self:playLineEnd(summary)
end

function GuildClashMainScene:playLineEnd(summary)
  local name = {
    "top",
    "mid",
    "bottom"
  }
  local lineId = summary._line_id
  self.curBattleData[lineId] = nil
  local lineData = self.lineKeyPoints[lineId]
  local winCamp = summary._win_camp
  if not summary._team then
    return
  end
  local actions = {}
  local node, actor
  if winCamp == 1 then
    if self.camp2Team[lineId] then
      self.camp2Team[lineId].node:removeFromParentAndCleanup(true)
    end
    if not self.camp1Team[lineId] then
      local userId = summary._team._uid
      local heroId = summary._hero_id
      self.camp1Team[lineId] = self:createTeamActor(lineId, 1, heroId, userId, "Move")
      table.insert(actions, CCMoveTo:create(walkTime / 2, lineData[2]))
      table.insert(actions, CCMoveTo:create(walkTime / 2, lineData[3]))
    end
    node = self.camp1Team[lineId].node
    actor = self.camp1Team[lineId].actor
    actor:setAction("Move")
    table.insert(actions, CCMoveTo:create(walkTime / 2, lineData[4]))
    table.insert(actions, CCMoveTo:create(walkTime / 2, ccpAdd(ccp(-10, -10), lineData[5])))
    table.insert(actions, CCCallFunc:create(function()
      actor:setAction("atk")
      self.ui["camp2_tower_" .. name[lineId]]:setAnimation(0, "Imapct", true)
      self:listenTimer(Timer:Times(0.6, 3), function()
        local hurtFca = ed.createFcaNode("eff_impact_TitanSR_atk3")
        self:addFca(hurtFca)
        hurtFca:setPosition(ccp(60, 20))
        self.ui["touchArea_camp2_" .. name[lineId]]:addChild(hurtFca, 10)
      end)
    end))
    table.insert(actions, CCDelayTime:create(2.4))
    table.insert(actions, CCCallFunc:create(function()
      actor:setAction("Cheer")
      self.ui["camp2_bg_tower_" .. name[lineId]]:setCascadeOpacityEnabled(true)
      self.ui["camp2_bg_tower_" .. name[lineId]]:runAction(CCFadeOut:create(0.4))
      self.ui["camp2_tower_" .. name[lineId]]:setAnimation(0, "Death", true)
      self.camp1Team[lineId] = nil
    end))
    table.insert(actions, CCDelayTime:create(2))
    table.insert(actions, CCCallFunc:create(function()
      node:removeFromParentAndCleanup(true)
    end))
    node:stopAllActions()
    node:runAction(CCSequence:create(ccArrayMake(unpack(actions))))
  elseif winCamp == 2 then
    if self.camp1Team[lineId] then
      self.camp1Team[lineId].node:removeFromParentAndCleanup(true)
    end
    if not self.camp2Team[lineId] then
      local userId = summary._team._uid
      local heroId = summary._hero_id
      self.camp2Team[lineId] = self:createTeamActor(lineId, 2, heroId, userId, "Move")
      table.insert(actions, CCMoveTo:create(walkTime / 2, lineData[4]))
      table.insert(actions, CCMoveTo:create(walkTime / 2, lineData[3]))
    end
    node = self.camp2Team[lineId].node
    actor = self.camp2Team[lineId].actor
    actor:setAction("Move")
    table.insert(actions, CCMoveTo:create(walkTime / 2, lineData[2]))
    table.insert(actions, CCMoveTo:create(walkTime / 2, ccpAdd(ccp(10, 10), lineData[1])))
    table.insert(actions, CCCallFunc:create(function()
      actor:setAction("atk")
      self.ui["camp1_tower_" .. name[lineId]]:setAnimation(0, "Imapct", true)
      self:listenTimer(Timer:Times(0.6, 3), function()
        local hurtFca = ed.createFcaNode("eff_impact_TitanSR_atk3")
        self:addFca(hurtFca)
        hurtFca:setPosition(ccp(60, 20))
        self.ui["touchArea_camp1_" .. name[lineId]]:addChild(hurtFca, 10)
      end)
    end))
    table.insert(actions, CCDelayTime:create(2.4))
    table.insert(actions, CCCallFunc:create(function()
      actor:setAction("Cheer")
      self.ui["camp1_bg_tower_" .. name[lineId]]:setCascadeOpacityEnabled(true)
      self.ui["camp1_bg_tower_" .. name[lineId]]:runAction(CCFadeOut:create(0.4))
      self.ui["camp1_tower_" .. name[lineId]]:setAnimation(0, "Death", true)
      self.camp2Team[lineId] = nil
    end))
    table.insert(actions, CCDelayTime:create(2))
    table.insert(actions, CCCallFunc:create(function()
      node:removeFromParentAndCleanup(true)
    end))
    node:stopAllActions()
    node:runAction(CCSequence:create(ccArrayMake(unpack(actions))))
  end
end

function GuildClashMainScene:popLantern(data)
  local lineId = data.lineId
  local type = resConfig[data.type]
  local winName = data.win._name
  local loseName = data.lose._name
  local bg = ed.createSprite("UI/alpha/1080P/common/notice_bg.png")
  bg:setPosition(ccp(ed.display.winSize.width / 2 + 60, 560 - self.playingLanterns * 22))
  bg:setCascadeOpacityEnabled(true)
  self.ui.bg:addChild(bg, 999)
  if data.winCamp == 1 then
    winName = string.format("<lable color=ccc3(255,252,231) strokeColor=ccc3(99,31,31) strokeSize=1>%s</lable>", winName)
    loseName = string.format("<lable color=ccc3(255,156,108) strokeColor=ccc3(82,25,19) strokeSize=1>%s</lable>", loseName)
  else
    winName = string.format("<lable color=ccc3(255,156,108) strokeColor=ccc3(82,25,19) strokeSize=1>%s</lable>", winName)
    loseName = string.format("<lable color=ccc3(255,252,231) strokeColor=ccc3(99,31,31) strokeSize=1>%s</lable>", loseName)
  end
  if data.win._medal then
    winName = string.format("<sprite src=%s scale=0.12 >", ed.getMedalRes(data.win._medal)) .. winName
  end
  if data.lose._medal then
    loseName = string.format("<sprite src=%s scale=0.12 >", ed.getMedalRes(data.lose._medal)) .. loseName
  end
  local autoText = ed.ui.autoText.new()
  local iconRes = string.format("UI/alpha/1080P/guild/guild_clash_fightshow/%s.png", lineIconRes[lineId])
  local iconText = string.format("<sprite src=%s scale=0.6>", iconRes)
  local nameText = string.format(popMsgType[type], winName, loseName)
  autoText:initParam({
    context = iconText .. nameText,
    fontSize = 16,
    fontColor = ccc3(255, 255, 255),
    strokeColor = ed.toccc3(2057010),
    strokeSize = 1,
    maxWidth = 500
  })
  bg:addChild(autoText.node, 1)
  ed.layout.centerInParent(autoText.node)
  local width, height = autoText:getCurContentSize()
  local posX, posY = autoText.node:getPosition()
  autoText.node:setPosition(ccp(posX - width / 2, posY + 2))
  bg:setOpacity(0)
  bg:setScale(0.65)
  local action1 = CCSpawn:create(ccArrayMake({
    CCEaseSineIn:create(CCFadeIn:create(0.2)),
    CCEaseSineIn:create(CCScaleTo:create(0.2, 1.06))
  }))
  local action2 = CCEaseSineOut:create(CCScaleTo:create(0.3, 1))
  local action3 = CCDelayTime:create(0.45)
  local action4 = CCFadeOut:create(1.1)
  local action5 = CCCallFunc:create(function()
    bg:removeFromParentAndCleanup(true)
    self.playingLanterns = self.playingLanterns - 1
  end)
  local sequence = CCSequence:create(ccArrayMake(action1, action2, action3, action4, action5))
  bg:runAction(sequence)
  self.playingLanterns = self.playingLanterns + 1
end

function GuildClashMainScene:registerEvents()
  self:listenTimer(Timer:Always(1), function()
    self:timeMoving()
  end)
  self:listenEvent("GuildClashBattleTeams", function()
    ed.ui.GuildClashBattleInfoWin.create({
      lineId = self.watchLineId,
      curBattle = self.curBattleData[self.watchLineId]
    })
  end)
  self:listenEvent("GuildClashCloseBattleInfo", function()
    self.watchLineId = nil
  end)
  self:syncEvents()
  self:listenTimer(Timer:Always(5), function()
    self:syncEvents()
  end)
  self:listenEvent("GuildClashBattleEventPop", function(event)
    if event._type == "battle" then
      self:playOneBattle(event._battle_data)
    elseif event._type == "summary" then
      local data = event._summary_data
      if data._battle_summarys then
        self:playLineEnd(data._battle_summarys)
      end
    elseif event._type == "result" then
      local winCamp = event._win_camp
      self.mgr.clashShowEnd = self.mgr.roundId
      self:listenTimer(Timer:Once(5), function()
        if self.mgr.roundId == self.mgr.totalRound then
          function self.battleRecordCallBack()
            ed.UITool.openView("guildClashResultWin")
            
            self.battleRecordCallBack = nil
          end
        end
        ed.GuildClashNetwork:sendQueryBattleSummary()
      end)
      ed.GuildClashNetwork:sendOpenPanel()
    end
  end)
  self:listenEvent("GuildClashBattleSummary", function(data)
    ed.ui.GuildClashBattleRecordWin.create({
      data = data,
      callback = self.battleRecordCallBack
    })
  end)
  self:listenEvent("GuildClashChairChangeTeam", function()
    ed.GuildClashNetwork:sendGuildTeam()
  end)
  self:listenEvent("TESTLINEEND", function()
    self:test1()
  end)
  self:listenEvent("TESTONEBATTLESTART", function()
    self:testOneBattle()
  end)
  self:listenEvent("GuildClashChairSetting", function()
    if self.mgr.stateType ~= "ClashShow" then
      if self.mgr.campId == 1 then
        ed.setString(self.ui.camp1_name_tower_top, string.format("%s\233\152\159", #self.mgr.linesTeamList[1]))
        ed.setString(self.ui.camp1_name_tower_mid, string.format("%s\233\152\159", #self.mgr.linesTeamList[2]))
        ed.setString(self.ui.camp1_name_tower_bottom, string.format("%s\233\152\159", #self.mgr.linesTeamList[3]))
      elseif self.mgr.campId == 2 then
        ed.setString(self.ui.camp2_name_tower_top, string.format("%s\233\152\159", #self.mgr.linesTeamList[1]))
        ed.setString(self.ui.camp2_name_tower_mid, string.format("%s\233\152\159", #self.mgr.linesTeamList[2]))
        ed.setString(self.ui.camp2_name_tower_bottom, string.format("%s\233\152\159", #self.mgr.linesTeamList[3]))
      end
    end
  end)
  self:listenEvent("GuildClashPopBattleMsg", function(data)
    self:popLantern(data)
  end)
  self:listenEvent("GuildClashLineTeamInfo", function(data)
    if self.mgr.stateType ~= "ClashShow" then
      self:initLineTeamInfo()
    end
  end)
end

function GuildClashMainScene:onPopScene()
  self.redPointMgr:unregisterAllValueChange(self)
  self.mgr.mainScene = nil
  base.onPopScene(self)
end

function GuildClashMainScene.create()
  local self = base.create("GuildClashMainScene", {noBottomButton = true})
  setmetatable(self, GuildClashMainScene.mt)
  self:initData()
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:registerOnExitHandler("onExit", function()
    for k, v in pairs(self.battleUI) do
      if not tolua.isnull(v) then
        v:removeFromParentAndCleanup(true)
      end
    end
    self.battleUI = {}
    self.camp1Team = {}
    self.camp2Team = {}
    self.curBattleData = {}
  end)
  self.firstEnterScene = true
  self:registerOnEnterHandler("onEnter", function()
    if self.firstEnterScene then
      self.firstEnterScene = false
      return
    end
    if self.watchLineId then
      ed.GuildClashNetwork:sendQueryLine(self.watchLineId)
    end
    ed.GuildClashNetwork:sendOpenPanel()
  end)
  return self
end
