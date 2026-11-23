local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.guildClashGradeResultScene = class
local GUILD_GRADE_TO_NAME = {
  [1] = T("\230\151\160\229\174\154\231\186\167"),
  [2] = T("\231\153\189\233\147\182"),
  [3] = T("\233\187\132\233\135\145"),
  [4] = T("\231\142\139\232\128\133")
}
class.GUILD_GRADE_TO_NAME = GUILD_GRADE_TO_NAME
ed.UITool.registViewOpenFunc("guildClashGradeResultScene", function(param)
  local scene = ed.ui.guildClashGradeResultScene.create(param)
  local currentScene = ed.getCurrentScene()
  if currentScene and currentScene.identity == "guildClashGradingScene" then
    ed.replaceScene(scene)
  else
    ed.pushScene(scene)
  end
end)

function class.create(param)
  local self = base.create("guildClashGradeResultScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.data = param.data or {}
  self.scheduleId = self.data._schedule_id or 1
  self.rateInfo = self.data._rate_info or {}
  self.gradeId = self.rateInfo._grade or 1
  self.mgr = ed.GuildClashManager
  self:initView()
  self:adaptUI()
  self:refreshView()
  self:addTouchEvent()
  self:addEventListen()
  self:startCountDown()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashGradeResultScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  local _, titleTxt = ed.UITool.createSceneTitle(T("\229\133\172\228\188\154\230\136\152"), self.ui.scene_title_bg, {
    position = ccp(13, 18)
  })
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(11880981), 2)
  self.ui.label_title:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_exchange, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_gameplay, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_no_grade, ed.toccc3(8873783), 1.5)
  self.ui.label_no_grade:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_zone_level, ed.toccc3(7015958), 1.5)
  self.ui.label_zone_level:setFontName(ed.fontBold)
  if 1 < self.gradeId then
    local iconRes = self.mgr:getGuildGradeIconRes(self.gradeId)
    ed.setTexture(self.ui.image_guild_grade, iconRes, true)
    self.ui.image_zone_level_bg:setVisible(true)
    self.ui.image_guild_grade:setVisible(true)
    self.ui.image_no_grade:setVisible(false)
    self.ui.btn_zone_tips:setVisible(true)
    ed.setLabelString(self.ui.label_zone_level, T("%s\231\186\167\229\133\172\228\188\154", GUILD_GRADE_TO_NAME[self.gradeId]))
  else
    self.ui.image_zone_level_bg:setVisible(false)
    self.ui.image_guild_grade:setVisible(false)
    self.ui.image_no_grade:setVisible(true)
    self.ui.btn_zone_tips:setVisible(false)
  end
  self.ui.Label_10825:limitWidthByScale(80)
  ed.adaptLabel(self.ui.label_title, {maxWidth = 290, minScale = 0.7})
  self:runGradeResultAction()
end

function class:adaptUI()
  ed.layout.layoutWithMagin(self.ui.btn_rule, {right = 30, top = 15}, false, true)
  ed.layout.layoutWithMagin(self.ui.scene_title_bg, {left = 60, top = 20}, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_reward, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_exchange, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
  ed.layout.layoutWithMagin(self.ui.btn_gameplay, {
    right = 30 + ed.display.getNotchHeight()
  }, false, true)
  self.ui.label_no_grade:limitWidthByScale(80)
  self.ui.label_check:limitWidthByScale(140)
end

function class:runGradeResultAction()
  local season = self.data._season_id or 1
  local key = ed.getRoleKey("GuildClash" .. season)
  local hasShowGradeEff = ed.storage.getBool(key)
  if hasShowGradeEff then
    return
  end
  ed.storage.setValue(key, true)
  self.ui.image_art:setScale(3)
  self.ui.image_art:runAction(CCEaseExponentialIn:create(CCScaleTo:create(0.4, 1)))
end

function class:refreshView()
  self:refreshGuildInfo()
end

function class:startCountDown()
  if self.scheduleId >= 7 or self.gradeId <= 1 then
    self.ui.image_time_bg:setVisible(false)
    return
  end
  self:refreshLeftTime()
  local adaptScale = math.min(1, 300 / (self.ui.label_left_time:getContentSize().width + self.ui.Label_11008:getContentSize().width))
  self.ui.label_left_time:setScale(adaptScale)
  self.ui.Label_11008:setScale(adaptScale)
  ed.layout.horizontalSortNode({
    self.ui.label_left_time,
    self.ui.Label_11008
  }, {2.5, 0}, self.ui.image_time_bg:getContentSize().width * 0.5)
  self.countDownTimer = self:listenTimer(Timer:Always(1, "countDownTimer"), function()
    self:refreshLeftTime()
  end)
end

function class:refreshLeftTime()
  local targetScheduleId = 7
  local leftTime = ed.GuildClashManager:getSecondBetweenTwoState(self.scheduleId, targetScheduleId)
  if leftTime < 0 and self.countDownTimer then
    CloseTimer(self.countDownTimer.Name)
    self.countDownTimer = nil
    ed.GuildClashNetwork:sendOpenPanel()
    return
  end
  leftTime = math.max(0, leftTime)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local second = math.floor(leftTime % 60)
  self.ui.label_left_time:setString(T(string.format(T("%d\230\151\182%.2d\229\136\134%.2d\231\167\146"), hour, min, second)))
end

function class:refreshGuildInfo()
  local selfGuildSummary = self.data._self_guild_summary or {}
  local guildSummary = selfGuildSummary._guild_summary or {}
  local avatarData = ed.analyzeAvatar(guildSummary._avatar or 1)
  local guildIcon = ed.createGuildAvatar(avatarData.avatar, avatarData.avatarFrame)
  self.ui.panel_guild_icon:removeAllChildrenWithCleanup(true)
  self.ui.panel_guild_icon:addChild(guildIcon)
  guildIcon:setScale(1.2)
  ed.layout.centerInParent(guildIcon)
  ed.setLabelString(self.ui.label_guild_name, guildSummary._name or "")
  ed.setLabelString(self.ui.label_total_activity, T("\230\128\187\230\180\187\232\183\131\229\186\166\239\188\154%s", self.rateInfo._guild_liveness or 0))
  local gradeId = self.rateInfo._grade or 1
  local zoneId = self.rateInfo._zone_id or 1
  if 1 < gradeId then
    self.ui.label_no_zone:setVisible(false)
    self.ui.label_zone_tips:setVisible(true)
    self.ui.label_zone:setVisible(true)
    ed.setLabelString(self.ui.label_zone, T("%s%s\230\136\152\229\140\186", class.GUILD_GRADE_TO_NAME[gradeId], zoneId))
    local adaptScale = math.min(1, 220 / (self.ui.label_zone_tips:getContentSize().width + self.ui.label_zone:getContentSize().width))
    self.ui.label_zone_tips:setScale(adaptScale)
    self.ui.label_zone:setScale(adaptScale)
    ed.layout.horizontalSortNode({
      self.ui.label_zone_tips,
      self.ui.label_zone
    }, {2, 0}, self.ui.image_zone_bg:getContentSize().width * 0.5)
  else
    self.ui.label_no_zone:setVisible(true)
    self.ui.label_no_zone:limitWidthByScale(250)
    self.ui.label_zone_tips:setVisible(false)
    self.ui.label_zone:setVisible(false)
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_check", function()
    ed.UITool.openView("guildClashMemberActiveWin")
  end, {pressScale = 0.65, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = ed.GuildClashDefine.RULES_TITLE,
      txt = ed.GuildClashDefine.RULES_TEXT
    }):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.UITool.openView("guildClashRewardWin")
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_exchange", function()
    ed.GuildClashNetwork:sendQueryGoods()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_gameplay", function()
    ed.UITool.openView("guildClashGameGuideWin")
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_zone_tips", function()
    ed.showToast(T("\229\133\172\228\188\154\230\136\152\231\154\132\230\175\148\232\181\155\233\152\182\230\174\181\239\188\140\228\188\154\229\140\185\233\133\141\229\144\140\230\136\152\229\140\186\231\154\132\229\133\172\228\188\154\228\189\156\228\184\186\229\175\185\230\137\139"))
  end, {pressScale = 0.65, normalScale = 0.7})
end

function class:addEventListen()
end
