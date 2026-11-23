local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.guildClashGradingScene = class
local desc2 = T("<lable color=%s fontSize=f14>\232\167\163\233\148\129\229\133\172\228\188\154\230\136\152</lable>") .. T("<lable color=%s fontSize=f14>\229\143\130\228\184\142\232\181\132\230\160\188</lable>")
local desc3 = T("<lable color=%s fontSize=f14>\232\191\155\229\133\165\229\133\172\228\188\154\230\136\152-</lable>") .. T("<lable color=%s fontSize=f14>\233\187\132\233\135\145\230\136\152\229\140\186</lable>")
local desc4 = T("<lable color=%s fontSize=f14>\232\191\155\229\133\165\229\133\172\228\188\154\230\136\152-</lable>") .. T("<lable color=%s fontSize=f14>\231\142\139\232\128\133\230\136\152\229\140\186</lable>")
class.desc2 = desc2
class.desc3 = desc3
class.desc4 = desc4
local needActDesc1 = T("<lable color=ccc3(196,153,118) fontSize=f14>\230\137\128\233\156\128\230\180\187\232\183\131\239\188\154</lable>") .. T("<lable color=ccc3(246,223,204) fontSize=f14>%s</lable>")
local needActDesc2 = T("<lable color=ccc3(239,235,214) fontSize=f16>\230\137\128\233\156\128\230\180\187\232\183\131\239\188\154</lable>") .. T("<lable color=ccc3(255,222,133) fontSize=f16>%s</lable>")
class.needActDesc1 = needActDesc1
class.needActDesc2 = needActDesc2
ed.UITool.registViewOpenFunc("guildClashGradingScene", function(param)
  local scene = ed.ui.guildClashGradingScene.create(param)
  local currentScene = ed.getCurrentScene()
  if currentScene and currentScene.identity == "guildClashPreviewScene" then
    ed.replaceScene(scene)
  else
    ed.pushScene(scene)
  end
end)

function class.create(param)
  local self = base.create("guildClashGradingScene", {noBottomButton = true})
  setmetatable(self, class.mt)
  self:init(param)
  return self
end

function class:init(param)
  param = param or {}
  self.data = param.data or {}
  local guildClashGradeTB = ed.getDataTable("GuildClashGrade")
  self.firstEnterScene = true
  self.needActList = {}
  self.actLevel = 1
  self.rateInfo = self.data._rate_info or {}
  self.scheduleId = self.data._schedule_id or 1
  self.curState = self.data._cur_state
  self.guildLiveness = self.rateInfo._guild_liveness or 0
  self.stateType = ed.getDataTable("GuildClashSchedule")[self.scheduleId]["State Type"]
  for grade, guildClashGradeCfg in ipairs(guildClashGradeTB or {}) do
    local livenessMin = guildClashGradeCfg["Liveness Min"]
    table.insert(self.needActList, livenessMin)
    if livenessMin <= self.guildLiveness then
      self.actLevel = grade
    end
  end
  if self.stateType == "CountGradingResult" then
    self.data._state_end_time = self.data._state_end_time + 900
  end
  self:initView()
  self:adaptUI()
  self:refreshView()
  self:addTouchEvent()
  self:addEventListen()
  self:startCountDown()
end

function class:initView()
  local container, ui = ed.editorui(ed.uieditor.GuildClashGradingScene)
  self.mainLayer:addChild(container)
  self.ui = ui
  self:setBackButton()
  ed.UITool.createSceneTitle(T("\229\133\172\228\188\154\230\136\152"), self.ui.scene_title_bg, {
    position = ccp(13, 18)
  })
  self:setBackground("UI/alpha/1080P/guild/guild_grading/grading_bg.jpg")
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(11880981), 2)
  self.ui.label_title:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_reward, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_exchange, ed.toccc3(2565412), 1)
  ed.setLabelStroke(self.ui.label_gameplay, ed.toccc3(2565412), 1)
  self.ui.Label_10825:limitWidthByScale(80)
  local progress = CCProgressTimer:create(self.ui.bar)
  progress:setType(kCCProgressTimerTypeBar)
  progress:setMidpoint(ccp(0, 0.5))
  progress:setBarChangeRate(ccp(1, 0))
  self.ui.bar_bg:addChild(progress)
  self.ui.bar:setVisible(false)
  progress:setPosition(self.ui.bar:getPosition())
  self.bar = progress
  if self.stateType == "GradingBegin" then
    self.ui.panel_grading:setVisible(true)
    self.ui.image_countgrade_bg:setVisible(false)
    self.ui.image_time_bg:setVisible(true)
    self.ui.today_devote_bg:setVisible(true)
    self.ui.label_tips:setVisible(true)
    local lab = self.ui.label_tips
    local parent = lab:getParent()
    local pos = parent:convertToWorldSpace(ccp(lab:getPosition()))
    if lab:getContentSize().width * 0.5 + pos.x > ed.display.winSize.width then
      ed.layout.layoutWithMagin(lab, {right = 5})
    end
    self.ui.btn_go:setVisible(true)
  elseif self.stateType == "CountGradingResult" or self.stateType == "DivideZone" then
    self.ui.panel_grading:setVisible(false)
    self.ui.image_countgrade_bg:setVisible(true)
    self.ui.image_time_bg:setVisible(false)
    self.ui.today_devote_bg:setVisible(false)
    self.ui.label_tips:setVisible(false)
    self.ui.btn_go:setVisible(false)
  end
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
  self.ui.label_check:limitWidthByScale(140)
  local totalWidth = self.ui.label_time:getContentSize().width + self.ui.Label_10792:getContentSize().width
  local contentWidth = self.ui.image_time_bg:getContentSize().width
  local adaptScale = math.min(1, (contentWidth - 40) / totalWidth)
  self.ui.label_time:setScale(adaptScale)
  self.ui.Label_10792:setScale(adaptScale)
  ed.layout.horizontalSortNode({
    self.ui.label_time,
    self.ui.Label_10792
  }, {0, 0}, contentWidth * 0.5)
  ed.layout.horizontalSortNode({
    self.ui.Label_10831,
    self.ui.label_grade_end_time
  }, {5, 0}, self.ui.ImageView_10829:getContentSize().width * 0.5)
  ed.adaptLabel(self.ui.label_title, {maxWidth = 290, minScale = 0.7})
end

function class:refreshView()
  self:refreshGuildInfo()
  self:refreshActInfo()
  self:refreshBar()
  self:refreshActive()
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
  ed.setLabelString(self.ui.label_total_activity, T("\230\128\187\230\180\187\232\183\131\229\186\166\239\188\154%s", self.guildLiveness))
end

function class:refreshActInfo()
  local descWidth = 0
  local descArr = {}
  for level = 2, 4 do
    local isCurrentLevel = level == self.actLevel
    local descColor1, descColor2, descStroke, titleBgPath, needActDesc, needActBgPath
    if isCurrentLevel then
      descColor1 = "ccc3(55,29,6)"
      descColor2 = "ccc3(202,62,62)"
      descStroke = "guildClashGrading1"
      titleBgPath = "UI/alpha/1080P/guild/guild_grading/currentgrade_textfloor.png"
      needActDesc = string.format(class.needActDesc2, self.needActList[level])
      needActBgPath = "UI/alpha/1080P/guild/guild_grading/currentgrade_needfloor.png"
      ed.setLabelColor(self.ui["label_name_" .. level], ed.toccc3(16776423))
      self.ui["guild_icon_light_" .. level]:setVisible(true)
    else
      descColor1 = "ccc3(255,252,231)"
      descColor2 = "ccc3(255,239,133)"
      descStroke = "guildClashGrading2"
      titleBgPath = "UI/alpha/1080P/guild/guild_grading/othergrade_textfloor.png"
      needActDesc = string.format(class.needActDesc1, self.needActList[level])
      needActBgPath = "UI/alpha/1080P/guild/guild_grading/othergrade_needfloor.png"
      ed.setLabelColor(self.ui["label_name_" .. level], ed.toccc3(15253406))
      self.ui["guild_icon_light_" .. level]:setVisible(false)
    end
    self.ui["point_" .. level]:setVisible(level <= self.actLevel)
    local desc = string.format(class["desc" .. level], descColor1, descColor2)
    local titleAutoText = ed.ui.autoText.new()
    titleAutoText:initParam({
      context = desc,
      strokeColor = descStroke,
      strokeSize = 1
    })
    local titleBg = self.ui["title_bg_" .. level]
    ed.setTexture(titleBg, titleBgPath)
    titleBg:setZOrder(1)
    titleBg:removeAllChildrenWithCleanup(true)
    titleBg:addChild(titleAutoText.node)
    ed.layout.centerYInParent(titleAutoText.node)
    table.insert(descArr, titleAutoText)
    local curWidth, _ = titleAutoText:getCurContentSize()
    descWidth = math.max(descWidth, curWidth)
    self.ui["image_current_" .. level]:setVisible(isCurrentLevel)
    local actAutoText = ed.ui.autoText.new()
    actAutoText:initParam({context = needActDesc})
    actAutoText:limitWidthByScale(130)
    local needActBg = self.ui["need_act_bg_" .. level]
    needActBg:addChild(actAutoText.node)
    ed.setTexture(needActBg, needActBgPath, true)
    ed.layout.centerYInParent(actAutoText.node)
    actAutoText.node:setPositionX(needActBg:getContentSize().width / 2 - actAutoText:getCurContentSize() * actAutoText.node:getScale() / 2)
  end
  local descScale = math.min(1, self.ui.title_bg_2:getContentSize().width / descWidth)
  for i, v in ipairs(descArr) do
    v.node:setScale(descScale)
    local curWidth, _ = v:getCurContentSize()
    v.node:setPositionX((v.node:getParent():getContentSize().width - curWidth * descScale) * 0.5)
  end
end

function class:refreshBar()
  local percent = 0
  local act1 = self.needActList[2]
  local act2 = self.needActList[3]
  local act3 = self.needActList[4]
  if act1 >= self.guildLiveness then
    percent = self.guildLiveness / act1 * 15
  elseif act1 < self.guildLiveness and act2 >= self.guildLiveness then
    percent = 15 + (self.guildLiveness - act1) / (act2 - act1) * 35
  elseif act2 < self.guildLiveness and act3 >= self.guildLiveness then
    percent = 50 + (self.guildLiveness - act2) / (act3 - act2) * 34.5
  elseif act3 < self.guildLiveness then
    percent = 84.5 + (self.guildLiveness - act3) / (act3 + 70000 - act3) * 15.5
  end
  percent = math.min(percent, 100)
  self.bar:setPercentage(percent)
end

function class:refreshActive()
  local todayLiveness = self.rateInfo._user_today_liveness or 0
  local todayLivenessMax = self.rateInfo._user_today_liveness_max or 0
  ed.setLabelString(self.ui.label_today_devote, T("\228\187\138\230\151\165\232\180\161\231\140\174\239\188\154%s/%s", todayLiveness, todayLivenessMax))
end

function class:startCountDown()
  self:refreshLeftTime()
  self.countDownTimer = self:listenTimer(Timer:Always(1, "countDownTimer"), function()
    self:refreshLeftTime()
  end)
end

function class:refreshLeftTime()
  local endTime = self.data._state_end_time or 0
  local leftTime = endTime - ed.getServerTime()
  if leftTime < 0 and self.countDownTimer then
    CloseTimer(self.countDownTimer.Name)
    self.countDownTimer = nil
    ed.GuildClashNetwork:sendOpenPanel()
    return
  end
  leftTime = math.max(0, leftTime)
  local day = math.floor(leftTime / 86400)
  local hour = math.floor(leftTime % 86400 / 3600)
  local min = math.floor(leftTime % 3600 / 60)
  local second = math.floor(leftTime % 60)
  if self.stateType == "GradingBegin" then
    self.ui.label_time:setString(T(string.format(T("%s\229\164\169%.2d:%.2d:%.2d"), day, hour, min, second)))
  elseif self.stateType == "CountGradingResult" or self.stateType == "DivideZone" then
    self.ui.label_grade_end_time:setString(T("%s\229\136\134%s\231\167\146", min, second))
  end
end

function class:addTouchEvent()
  ed.UITool.registerBtn(self, "btn_check", function()
    ed.UITool.openView("guildClashMemberActiveWin")
  end, {pressScale = 0.65, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_go", function()
    ed.UITool.openView("stageSelect")
  end, {pressScale = 0.65, normalScale = 0.75})
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = ed.GuildClashDefine.RULES_TITLE,
      txt = ed.GuildClashDefine.RULES_TEXT
    }):popWindow()
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_reward", function()
    ed.UITool.openView("guildClashRewardWin")
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_gameplay", function()
    ed.UITool.openView("guildClashGameGuideWin")
  end, {pressScale = 0.95, normalScale = 1})
  ed.UITool.registerBtn(self, "btn_exchange", function()
    ed.GuildClashNetwork:sendQueryGoods()
  end, {pressScale = 0.95, normalScale = 1})
end

function class:addEventListen()
  self:registerOnEnterHandler("onEnter", function()
    if self.firstEnterScene then
      self.firstEnterScene = false
      return
    end
    ed.GuildClashNetwork:sendOpenPanel()
  end)
end
