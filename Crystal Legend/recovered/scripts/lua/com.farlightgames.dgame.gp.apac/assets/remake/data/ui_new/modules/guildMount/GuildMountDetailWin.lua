local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.GuildMountDetailWin = class

function class:getBossSkills()
  local slotIdList = {}
  for i = 1, 6 do
    table.insert(slotIdList, self.bossTblData["Slot " .. i])
  end
  local skills = {}
  local skillGroupTbl = ed.getDataTable("SkillGroup")
  local skillDataTbl = ed.getDataTable("Skill")
  for i = 1, 6 do
    local slotId = slotIdList[i]
    if slotId and 0 < slotId then
      local skillGroupRow = skillGroupTbl[self.bossTblData["Unit ID"]][slotId]
      local skillGroupId = skillGroupRow["Skill Group ID"]
      local skillRow = skillDataTbl[skillGroupId][0]
      table.insert(skills, {
        id = skillGroupId,
        skillGroupRow = skillGroupRow,
        skillRow = skillRow
      })
    end
  end
  return skills
end

function class:getstageSkills()
  local row = self.bossTblData
  local an = row.StageSkill_AN
  local skills = {}
  for k, v in ipairs(an) do
    local stageSkill = ed.getDataTable("StageSkill")[v]
    local iconkeyStr = "Skill %d Icon"
    local deskeyStr = "Skill %d Description"
    for i = 1, 3 do
      local iconkey = string.format(iconkeyStr, i)
      local iconRes = stageSkill[iconkey]
      local deskey = string.format(deskeyStr, i)
      local des = stageSkill[deskey]
      if iconRes and des then
        skills[i] = {iconRes = iconRes, des = des}
      end
    end
  end
  return skills
end

function class:getStageBuff()
  local row = self.bossTblData
  local stageBuff = {
    name = row["Buff Name"],
    desc = row["Buff Dec"]
  }
  return stageBuff
end

function class:getRewardItems()
  local info = {}
  local rewardTblData = ed.getDataTable("GuildMountBoss")[self.bossId]
  table.insert(info, {
    type = "guildmountpoint",
    amount = rewardTblData["Coin Amount"]
  })
  return info
end

function class:initData(boss)
  self.curBossId = ed.GuildMountManager:getCurBoss()._id
  self.bossIds = ed.GuildMountManager.bossIds
  self.bossId = boss._id
  self.bossIdx = 1
  for idx, id in ipairs(self.bossIds) do
    if id == self.bossId then
      self.bossIdx = idx
      break
    end
  end
  self.bossTblData = ed.getDataTable("GuildMountBoss")[self.bossId]
  self.bossSkills = self:getBossSkills()
  self.stageSkills = self:getstageSkills()
  self.stageBuff = self:getStageBuff()
  self.rewardInfo = self:getRewardItems(self.bossId)
  self.skillIconWidth = 45
  self.rewardIconWidth = 30
  self.showDamageDetail = true
end

function class:createSkillIcon(slotId, iconWidth)
  local icon, bg = ed.readhero.createSkillIcon(self.bossTblData["Unit ID"], slotId)
  icon:setScale(iconWidth / icon:getContentSize().width)
  return icon
end

function class:initBossSkillIcons()
  if self.skillIcons then
    for _, iconData in ipairs(self.skillIcons) do
      iconData.icon:removeFromParentAndCleanup(true)
    end
  end
  self.skillIcons = {}
  local iconWidth = self.skillIconWidth
  local x, y = 22, -52
  local ox = 0
  local sepX = 20
  for i, skill in ipairs(self.bossSkills) do
    local icon = self:createSkillIcon(skill.skillGroupRow.Slot, iconWidth)
    icon:setPosition(ccp(x + ox + iconWidth / 2, y + iconWidth / 2))
    ox = ox + iconWidth + sepX
    self.ui.ImageView_1526_Copy0:addChild(icon)
    table.insert(self.skillIcons, {icon = icon, data = skill})
  end
end

function class:refreshBossHp()
  local curBoss = ed.GuildMountManager:getCurBoss()
  local curBossHp = curBoss._health
  ed.setString(self.ui.label_bar, string.format("%.2f%%", curBossHp / 100))
  self.bossHpBar:setPercentage(curBossHp / 100)
end

function class:initDraglist()
  self.dragList = ed.UITool.createDraglist(self.ui.boss_buff_desc, {})
end

function class:refreshDraglist()
  self.stageBuff = self:getStageBuff()
  self.dragList:clearList()
  ed.setString(self.ui.boss_desc, self.bossTblData["Boss Desc"])
  ed.setLabelDimensions(self.ui.boss_desc, CCSizeMake(320, 0))
  local buff_desc_bg = ed.createSprite("UI/alpha/1080P/guildmount/challenge/title_board.png")
  local bg_size = buff_desc_bg:getContentSize()
  local buff_desc_title = ed.createLabelTTF(T("\233\173\148\231\129\181\233\162\134\229\159\159"), 16)
  buff_desc_title:setAnchorPoint(ccp(0, 0.5))
  buff_desc_title:setPosition(ccp(17.5, bg_size.height / 2))
  ed.setLabelColor(buff_desc_title, ed.toccc3(16771782))
  buff_desc_bg:addChild(buff_desc_title)
  local oriWid, oriHei = 165, 65
  buff_desc_bg:setPosition(ccp(oriWid, oriHei))
  local buff_desc_text = ed.ui.autoText.new()
  local desc_str = string.format("<lable color=ccc3(254,211,109), strokeSize=1, strokeColor=ccc3(20,16,42)>%s\239\188\154</lable>%s", self.stageBuff.name, self.stageBuff.desc)
  buff_desc_text:initParam({
    context = desc_str,
    fontSize = 15,
    color = ed.toccc3(11645120),
    maxWidth = 320
  })
  buff_desc_text.node:setPosition(ccp(17.5, -10))
  buff_desc_bg:addChild(buff_desc_text.node)
  local text_width, text_height = buff_desc_text:getContentSize()
  self.dragList:addItem(buff_desc_bg)
  self.dragList:initListHeight(text_height + bg_size.height + 5)
end

function class:refreshBossInfo()
  local stageTblData = ed.getDataTable("Stage")[self.bossTblData["Stage ID"]]
  local bossActor = ed.readhero.getActorNew(self.bossTblData["Unit ID"])
  bossActor:setScale(self.bossTblData["Body Size"])
  self:addFca(bossActor)
  ed.UITool.replaceUINew(self.ui, "boss", bossActor)
  EDLoadShader("HSVtoRGBShaderV2")
  ed.useHSVShaderV2(bossActor, self.bossTblData.Hue, self.bossTblData.Saturation, self.bossTblData.Value)
  local bossEffect = ed.createFcaNode("eff_UI_GuildMount_boss")
  bossEffect:setScale(1 / self.bossTblData["Body Size"])
  self:addFca(bossEffect)
  bossActor:addChild(bossEffect)
  local stageId = self.bossTblData["Stage ID"]
  local lv = ed.getDataTable("Battle")[stageId][1]["Level 1"]
  local titleLabel = ed.ui.gradientLabel.create({
    text = string.format(T("\231\172\172%d\232\189\174  %s (Lv.%d)"), self.bossTblData["Appear Days"], self.bossTblData["Boss Name"], lv),
    fontSize = 20,
    fontName = ed.fontBold,
    startColor = ed.toccc3(16776687),
    endColor = ed.toccc3(16776687),
    strokeSize = 3,
    strokeStartColor = ed.toccc3(12077522),
    strokeEndColor = ed.toccc3(4468608)
  })
  ed.UITool.replaceUINew(self.ui, "name", titleLabel.node)
  local nameSize = self.ui.name:getContentSize()
  if nameSize.width > 240 then
    self.ui.name:setScale(240 / nameSize.width)
  end
  ed.setLabelStroke(self.ui.Label_4173, ed.toccc3(1314858), 1)
  ed.setString(self.ui.Label_4173, string.format(T("\233\154\190\229\186\166%s"), self.bossTblData.Difficult))
  self.ui.Label_4173:limitWidthByScale(55)
  self:refreshDraglist()
  ed.setString(self.ui.desc, self.bossTblData["Boss Desc"])
  ed.setLabelDimensions(self.ui.desc, CCSizeMake(280, 0))
  self:initBossSkillIcons()
end

function class:initStageSkillInfo()
  local stageSkills = self.stageSkills
  local parent = self.ui.Panel_buff
  local skillIcons = {}
  local ox = -48 * math.max(#stageSkills - 1, 0) / 2
  for i, skill in ipairs(stageSkills) do
    local icon = ed.createSprite(skill.iconRes)
    parent:addChild(icon)
    icon:setPosition(ccp(ox + (i - 1) * 48, 15))
    icon:setScale(0.6)
    skillIcons[i] = icon
  end
  self.stageSkillIcons = skillIcons
end

function class:initRewardIcons()
  self.rewardDraglist:clearList()
  for k, reward in ipairs(self.rewardInfo) do
    local icon = ed.createItemIcon({
      type = reward.type,
      amount = reward.amount,
      id = reward.id
    })
    icon:setScale(0.63)
    self.ui["reward_icon_" .. k] = icon
    icon:setAnchorPoint(ccp(0, 0))
    icon:setPosition(ccp(62 * (k - 1), -4))
    self.rewardDraglist.listLayer:addChild(icon)
  end
  self.rewardDraglist:initListWidth(62 * #self.rewardInfo)
end

function class:refreshAttackPlayer()
  local attackPlayer = ed.GuildMountManager:getAttackPlayer()
  if attackPlayer then
    self.ui.Panel_attack:setVisible(true)
    ed.setString(self.ui.label_player_name, attackPlayer._name)
    self.ui.label_player_state:setPositionX(self.ui.label_player_name:getPositionX() + self.ui.label_player_name:getContentSize().width + 5)
  else
    self.ui.Panel_attack:setVisible(false)
  end
end

function class:sortHeroesIDByMaxRange(heroes)
  heroes = heroes or {}
  local resultHeroes = {}
  for i, hero in ipairs(heroes) do
    if hero then
      resultHeroes[i] = {}
      resultHeroes[i].hero = hero
      resultHeroes[i].maxRange = hero._tid > 0 and ed.readhero.getHeroMaxRange(hero._tid) or 0
    end
  end
  table.sort(resultHeroes, function(a, b)
    return a.maxRange > b.maxRange
  end)
  return resultHeroes
end

function class:createHeroIconByHero(hero, len)
  local param = {
    id = hero._tid,
    rank = hero._rank,
    level = hero._level,
    stars = hero._stars,
    length = len,
    summary = hero,
    isNoLevelStar = hero._tid == 0,
    legendEquip = hero._legend_equip and hero._legend_equip._equip
  }
  local heroIcon = ed.readhero.createIcon(param)
  heroIcon:showLegendEquip(not ed.openLegendEquip())
  local icon = heroIcon.icon
  return icon
end

function class:createDamageItem(data, splitFlag)
  local rootNode, ui = ed.editorui(ed.uieditor.GuildMountBossRankItem)
  local userSummary = data._user_summary
  local playerName = userSummary._name or ""
  local str = string.format(T("<text|guildmount_white|%s><text|guildmount_normal|\233\128\160\230\136\144\228\186\134><text|guildmount_yellow|%s\231\130\185\228\188\164\229\174\179 >"), playerName, ed.formatNumber(data._damage or 0))
  local richtext = richText:new()
  richtext:setString(str)
  local posX = richtext:getContentSize().width * -0.5
  ed.UITool.replaceUINew(ui, "name", richtext.rootNode)
  ui.name:setPositionX(ui.name:getPositionX() + posX)
  if type(data._heroes) == "table" then
    local heroes = self:sortHeroesIDByMaxRange(data._heroes)
    for i, heroData in ipairs(heroes) do
      local hero = heroData.hero
      if hero and 0 < hero._tid then
        local heroIcon = self:createHeroIconByHero(hero, 45)
        ed.UITool.replaceUINew(ui, "icon" .. i, heroIcon)
      end
    end
  end
  return rootNode
end

function class:refreshLatestDamage()
  if not tolua.isnull(self.latestDamage) then
    self.latestDamage:removeFromParentAndCleanup(true)
  end
  local damageList = ed.GuildMountManager:getBossDamageList()
  if damageList[1] then
    local latestItem = self:createDamageItem(damageList[1])
    latestItem:setPosition(ccp(6, 8))
    self.ui.bg_rank_board:addChild(latestItem)
    self.latestDamage = latestItem
  end
  self.ui.Label_3338:setVisible(#damageList == 0)
end

function class:refreshDamageList()
  self.damageDragList:clearList()
  local damageList = ed.GuildMountManager:getBossDamageList()
  local startPosy = self.ui.Panel_damage_detail:getContentSize().height
  local height = 0
  for i, v in ipairs(damageList) do
    local damageItem = self:createDamageItem(damageList[i], true)
    damageItem:setPosition(ccp(2, startPosy - 70))
    self.damageDragList:addItem(damageItem)
    startPosy = startPosy - 70
    height = height + 70
  end
  self.ui.Label_3338_Copy0:setVisible(#damageList == 0)
  self.damageDragList:initListHeight(height)
end

function class:refreshExtraTime()
  local extraInfo = ed.GuildMountManager:getExtraTime()
  if not extraInfo then
    self.ui.Label_1537:setVisible(false)
  else
    self.ui.Label_1537:setVisible(true)
    local time = extraInfo._duration or 0
    ed.setString(self.ui.Label_1537, string.format(T("\230\136\152\230\150\151\232\161\165\230\151\182\239\188\154%sS"), time))
  end
end

function class:refreshBtnGoState()
  if self.ui.battleTimes then
    self.ui.battleTimes:removeFromParentAndCleanup(true)
  end
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format("(<lable color=ccc3(112,255,84) strokeColor=ccc3(18,16,16) strokeSize=1>%d</lable>/%d)", ed.GuildMountManager:getLeftChallengeNum(), ed.GuildMountManager:getAllChallengeNum()),
    color = ed.toccc3(16764532),
    strokeColor = ed.toccc3(1315346),
    strokeSize = 1,
    fontSize = 19
  })
  self.ui.btn_battle:addChild(autoText.node)
  local rightX = self.ui.ImageView_1534:getPositionX() + self.ui.ImageView_1534:getContentSize().width * 0.5 + self.ui.Label_1535:getContentSize().width * 0.5 + 10
  self.ui.Label_1535:setPositionX(math.max(self.ui.Label_1535:getPositionX(), rightX))
  ed.setLabelStroke(self.ui.Label_1535, ed.toccc3(1315346), 1)
  self.ui.battleTimes = autoText.node
  ed.right2(autoText.node, self.ui.Label_1535)
  local isGray = not ed.GuildMountManager:getExtraTime() and ed.GuildMountManager:getLeftChallengeNum() <= 0
  if isGray then
    ed.setTexture(self.ui.btn_battle, "UI/alpha/1080P/common/button_big_grey.png")
    ed.setLabelColor(self.ui.Label_1535, ed.toccc3(16739436))
  else
    ed.setTexture(self.ui.btn_battle, "UI/alpha/1080P/common/button_big_common.png")
    ed.setLabelColor(self.ui.Label_1535, ccc3(255, 206, 116))
  end
end

function class:createSkillPanel(skill)
  local panel_width = 350
  local panel = ed.createScale9Sprite("UI/alpha/1080P/common/mail_bj9_1.png", CCRectMake(10, 10, 19, 201.5))
  panel:setAnchorPoint(ccp(0.5, 0))
  local skill_name = skill.skillGroupRow["Display Name"] or ""
  local skill_desc = skill.skillRow.Description or ""
  local start_y, offset_x, margin_y = 12, 10, 10
  local label_desc = ed.createLabelWithFontInfo(T(skill_desc), "skill_white")
  label_desc:setAnchorPoint(ccp(0, 0))
  label_desc:setPosition(ccp(offset_x, start_y))
  label_desc:setHorizontalAlignment(kCCTextAlignmentLeft)
  ed.setLabelDimensions(label_desc, CCSizeMake(panel_width - offset_x * 2, 0))
  panel:addChild(label_desc)
  local size = label_desc:getContentSize()
  local desc_height = size.height
  local label_name = ed.createLabelWithFontInfo(T(skill_name), "title_yellow")
  label_name:setAnchorPoint(ccp(0, 0))
  label_name:setPosition(ccp(offset_x, start_y + desc_height + margin_y))
  label_name:setHorizontalAlignment(kCCTextAlignmentLeft)
  ed.setLabelDimensions(label_name, CCSizeMake(panel_width - offset_x * 2, 0))
  panel:addChild(label_name)
  size = label_name:getContentSize()
  local name_height = size.height
  panel:setContentSize(CCSizeMake(panel_width, start_y + desc_height + margin_y + name_height + margin_y))
  return panel
end

function class:onClickBossSkill(event, x, y)
  if event == "began" then
    for i, skill in ipairs(self.skillIcons or {}) do
      if ed.containsPoint(skill.icon, x, y) and skill.icon:checkVisible() then
        ed.playEffect(ed.sound.stageDetail.clickReward)
        local iconWidth = self.skillIconWidth
        local panel = self:createSkillPanel(skill.data)
        local x, y = skill.icon:getPosition()
        local orix, oriy = self.ui.ImageView_1526_Copy0:getPosition()
        panel:setPosition(ccp(orix + x - 175, oriy + y + iconWidth / 2))
        self.skillDetailPanel = panel
        self.ui.bg:addChild(panel, 50)
        break
      end
    end
  elseif event == "ended" and self.skillDetailPanel then
    self.skillDetailPanel:removeFromParentAndCleanup(true)
    self.skillDetailPanel = nil
  end
end

function class:onClickStageSkill(event, x, y)
  if event == "began" then
    for i, icon in ipairs(self.stageSkillIcons or {}) do
      if ed.containsPoint(icon, x, y) then
        local des = self.stageSkills[i].des
        if des then
          local desText = des
          x = math.max(x, 183)
          ed.showHintText(desText, ccp(x, 380))
        end
        return
      end
    end
  elseif event == "ended" then
    ed.closeHintText()
  end
end

function class:destroyRewardDetailPanel()
  if self.rewardDetailPanel then
    self.rewardDetailPanel:removeFromParentAndCleanup(true)
    self.rewardDetailPanel = nil
  end
end

function class:doRewardTouch()
  local function handler(event, x, y)
    if event == "began" then
      self:destroyRewardDetailPanel()
      
      for i = 1, #self.rewardInfo do
        local info = self.rewardInfo[i]
        if ed.containsPoint(self.ui["reward_icon_" .. i], x, y) and not ed.containsPoint(self.ui.btn_go, x, y) then
          if not self.recommendDetailPanel then
            ed.UITool.openView("packageDetail", {
              id = info.id,
              amount = info.amount,
              type = info.type
            })
          end
          break
        end
      end
    elseif event == "ended" then
      self:destroyRewardDetailPanel()
    end
  end
  
  return handler
end

function class:registerTouchEvents()
  self:btRegisterHandler({
    handler = function(event, x, y)
      self:onClickBossSkill(event, x, y)
      self:doRewardTouch()(event, x, y)
    end,
    key = "guildmount_touch_event"
  })
  ed.UITool.registerBtn(self, "btn_battle", function()
    local isGray = not ed.GuildMountManager:getExtraTime() and ed.GuildMountManager:getLeftChallengeNum() <= 0
    if not isGray then
      ed.GuildMountManager:enterBattlePrepare(self.bossId)
    else
      ed.showToast(T("\230\140\145\230\136\152\230\172\161\230\149\176\228\184\141\232\182\179"))
    end
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_practice", function()
    ed.GuildMountManager:enterPracticeBattlePrepare(self.bossId)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_practices", function()
    ed.GuildMountManager:enterPracticeBattlePrepare(self.bossId)
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end)
  ed.UITool.registerBtn(self, "left_arrow", function()
    self.bossIdx = self.bossIdx - 1
    self.bossId = self.bossIds[self.bossIdx]
    self.bossTblData = ed.getDataTable("GuildMountBoss")[self.bossId]
    self.bossSkills = self:getBossSkills()
    self.stageSkills = self:getstageSkills()
    self.rewardInfo = self:getRewardItems(self.bossId)
    self:refreshBossInfo()
    self:initStageSkillInfo()
    self:initRewardIcons()
    self:refreshUIState()
  end)
  ed.UITool.registerBtn(self, "right_arrow", function()
    if self.showingTip or not self.ui.ImageView_1499:isVisible() then
      return
    end
    local rightGray = self.bossIdx == 3
    if rightGray then
      self.ui.ImageView_2038:setVisible(true)
      self.showingTip = true
      self:listenTimer(Timer:Once(2), function()
        self.ui.ImageView_2038:setVisible(false)
        self.showingTip = false
      end)
      return
    end
    self.bossIdx = self.bossIdx + 1
    self.bossId = self.bossIds[self.bossIdx]
    self.bossTblData = ed.getDataTable("GuildMountBoss")[self.bossId]
    self.bossSkills = self:getBossSkills()
    self.stageSkills = self:getstageSkills()
    self.rewardInfo = self:getRewardItems(self.bossId)
    self:refreshBossInfo()
    self:initStageSkillInfo()
    self:initRewardIcons()
    self:refreshUIState()
  end)
  ed.UITool.registerBtn(self, "btn_detail", function()
    self.ui.bg_rank_board:setVisible(false)
    self.ui.bg_rank_board_detail:setVisible(true)
  end)
  ed.UITool.registerBtn(self, "btn_detail_close", function()
    self.ui.bg_rank_board:setVisible(true)
    self.ui.bg_rank_board_detail:setVisible(false)
  end)
  ed.UITool.registerBtn(self, "random_reward", function()
    self.ui.bg_reward_detail:setVisible(true)
  end)
  self:btRegisterOutClick({
    area = self.ui.bg_reward_detail,
    key = "reward_out_click",
    clickHandler = function()
      self.ui.bg_reward_detail:setVisible(false)
    end
  })
end

function class:initLabels()
  ed.setLabelStroke(self.ui.Label_3338_Copy0, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.Label_3338, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.Label_1537, ed.toccc3(1706756), 1)
  ed.setLabelStroke(self.ui.label_practice, ed.toccc3(1513513), 1)
  self.ui.Label_3338:setDimensions(CCSizeMake(270, 0))
  self.ui.Label_3338_Copy0:setDimensions(CCSizeMake(270, 0))
  self.ui.Label_3338:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.ui.Label_3338_Copy0:setHorizontalAlignment(kCCTextAlignmentCenter)
  self.recordTime = ed.getServerTime() + ed.getTimeBeforeResetTime()
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
  self:refreshLeftTime()
  atWid, _ = atTxt:getCurContentSize()
  atPosX = 0.5 * (bgSize.width - atWid)
  atTxt.node:setPosition(ccp(atPosX, bgSize.height * 0.5))
  self:listenTimer(Timer:Always(1), function()
    if self.recordTime <= ed.getServerTime() or ed.GuildMountManager.endTime <= ed.getServerTime() then
      self:destroy()
      return
    end
    self:refreshLeftTime()
    atWid, _ = atTxt:getCurContentSize()
    atPosX = 0.5 * (bgSize.width - atWid)
    atTxt.node:setPosition(ccp(atPosX, bgSize.height * 0.5))
  end)
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

function class:adaptUI()
  ed.adaptLabel(self.ui.label_rank_board, {maxWidth = 260, minScale = 0.6})
  ed.adaptLabel(self.ui.label_rank_board_detail, {maxWidth = 260, minScale = 0.6})
end

function class:initUI()
  ed.editorui(ed.uieditor.GuildMountBossDetail, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  self:adaptUI()
  local oriHei = self.ui.Label_1545:getContentSize().height
  ed.adaptLabel(self.ui.Label_1545, {maxWidth = 215})
  local delHei = self.ui.Label_1545:getContentSize().height - oriHei
  local oriSize = self.ui.bg_reward_detail:getContentSize()
  self.ui.bg_reward_detail:setContentSize(CCSizeMake(oriSize.width, oriSize.height + delHei))
  ed.UITool.setPositionBy(self.ui.Label_1543, ccp(0, delHei))
  ed.UITool.setPositionBy(self.ui.ImageView_1544, ccp(0, delHei))
  ed.UITool.setPositionBy(self.ui.Label_1545, ccp(0, delHei))
  self.ui.left_arrow:setZOrder(1)
  self.ui.right_arrow:setZOrder(1)
  self:initDraglist()
  self:refreshBossInfo()
  self:initStageSkillInfo()
  self.rewardDraglist = ed.UITool.createDraglist(self.ui.layer_reward, {})
  self:initRewardIcons()
  self.damageDragList = ed.UITool.createDraglist(self.ui.Panel_damage_detail, {})
  self:refreshArrowBtn()
  self:refreshLatestDamage()
  self:refreshDamageList()
  self:refreshExtraTime()
  self:refreshBtnGoState()
  self:refreshUIState()
end

function class:refreshArrowBtn()
  local rightGray = self.bossIdx < 3
  if rightGray then
    ed.resetSpriteShader(self.ui.ImageView_1499)
  else
    ed.setSpriteGray(self.ui.ImageView_1499)
  end
  local leftVis = self.bossIdx > 1
  self.ui.left_arrow:setVisible(leftVis)
  local bossRound = ed.getDataTable("GuildMountBoss")[self.bossId]["Appear Days"]
  if bossRound == 10 then
    self.ui.ImageView_1499:setVisible(false)
  else
    self.ui.ImageView_1499:setVisible(true)
  end
end

function class:refreshUIState()
  local curChallengeBoss = self.curBossId == self.bossId
  self.ui.layer_cur:setVisible(curChallengeBoss)
  self.ui.ImageView_2255:setVisible(not curChallengeBoss)
  self:refreshArrowBtn()
end

function class:registerEvents()
  self:listenEvent("EventGuildMountQueryDamage", function()
    self:refreshLatestDamage()
    self:refreshDamageList()
  end)
  self:listenEvent("EventGuildMountBossDead", function()
    self:destroy({skipAnim = true})
  end)
  self:listenEvent("EventGuildMountOpenPanel", function()
    self:refreshDamageList()
    self:refreshLatestDamage()
    self:refreshExtraTime()
    self:refreshBtnGoState()
  end)
end

function class.create(boss)
  local self = base.create("GuildMountDetailWin")
  setmetatable(self, class.mt)
  self:initData(boss)
  self:initUI()
  self:registerEvents()
  self:registerTouchEvents()
  self:registerOnEnterHandler("enter_guildmount_detail", function()
    ed.GuildMountNetwork:sendQueryDamageBoss(self.curBossId)
    self:refreshBossInfo()
  end)
  self:popWindow()
  self:show()
  return self
end
