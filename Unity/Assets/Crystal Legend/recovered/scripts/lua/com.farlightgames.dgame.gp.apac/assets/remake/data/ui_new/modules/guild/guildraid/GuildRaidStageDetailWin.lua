local base = ed.ui.popwindow
local GuildRaidStageDetailWin = newclass(base.mt)
ed.ui.GuildRaidStageDetailWin = GuildRaidStageDetailWin

function GuildRaidStageDetailWin.create(param)
  local self = base.create("GuildRaidStageDetailWin")
  setmetatable(self, GuildRaidStageDetailWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self:popWindow()
  return self
end

function GuildRaidStageDetailWin:initPlayerLevelRange()
  self.levels = {}
  local raids = ed.getDataTable("Raid")
  self.chapterLevel = raids[self.raidId]["Unlock Level"]
  self.curLevelInd = 1
  self.playerLevelInd = 1
  local playerLevel = ed.player:getLevel()
  for id, v in ipairs(raids) do
    table.insert(self.levels, v["Unlock Level"])
    if self.raidId == id then
      self.curLevelInd = id
    end
    if playerLevel >= v["Unlock Level"] then
      self.playerLevelInd = id
    end
  end
end

function GuildRaidStageDetailWin:checkPlayerLevelInRange()
  return self.playerLevelInd - self.curLevelInd < 2
end

function GuildRaidStageDetailWin:addOnceBtn(tip)
  self.tipPop = tip
  local ui = tip.ui
  local btn_check = ed.createSprite("UI/alpha/1080P/sharefight/checkbox.png")
  local img_check = ed.createSprite("UI/alpha/1080P/common/account_sifting_mark.png")
  local label_check = ed.createLabelTTF(T("\228\187\138\230\151\165\228\184\141\229\134\141\230\143\144\233\134\146"), 15)
  ed.setLabelColor(label_check, ccc3(46, 44, 46))
  btn_check:addChild(label_check)
  btn_check:addChild(img_check)
  ed.layout.centerInParent(img_check)
  ed.right2(label_check, img_check, 5)
  ui.bg:addChild(btn_check)
  btn_check:setPosition(ccp(334, 100))
  img_check:setVisible(false)
  tip:btRegisterButtonClick({
    button = btn_check,
    key = "check_button",
    clickHandler = function()
      img_check:setVisible(not img_check:isVisible())
    end
  })
  tip.img_check = img_check
end

function GuildRaidStageDetailWin:registerEvents()
  self:listenEvent("GuildRaidPrepareBattle", function(data)
    if data._result == "prepare_cd" then
      local nextPrepareTime = 0
      if data._next_prepare_time then
        nextPrepareTime = data._next_prepare_time - ed.getServerTime()
      end
      ed.showToast(string.format(T("\229\164\132\228\186\142\230\136\152\230\150\151\229\135\134\229\164\135\229\134\183\229\141\180\228\184\173,%d\231\167\146\229\144\142\229\143\175\232\191\155\229\133\165\230\136\152\230\150\151..."), nextPrepareTime))
      self:refreshUI()
    elseif data._result == "challenger_updated" then
      ed.showToast(T("\229\133\182\228\187\150\228\186\186\230\173\163\229\156\168\230\140\145\230\136\152..."))
      self:refreshUI()
    elseif data._result == "success" then
      ed.pushScene(ed.ui.battleprepare.create({
        stage_id = self.stageId,
        GWMode = false,
        heroLimit = nil,
        actType = nil,
        mode = "guildInstance",
        prepareTime = ed.GuildRaidManager.leftTime,
        objData = self.battleData
      }))
      self:destroy({skipAnim = true})
    end
  end)
  self:listenEvent("GuildRaidStageRank", function(data)
    ed.ui.GuildRaidStageRanklistWin.create(data)
  end)
end

function GuildRaidStageDetailWin:initData(param)
  self.stageData = param.stageInfo
  self.raidId = param.raidId
  self.stageId = self.stageData.stageId
  self.wave = self.stageData.wave
  self.raidData = ed.GuildRaidManager.raidInfo[self.raidId]
  self.stageName = ed.getDataTable("Stage")[self.stageId]["Stage Name"]
  self.chapterId = ed.getDataTable("Stage")[self.stageId]["Chapter ID"]
  self.chapterName = ed.getDataTable("Chapter")[self.chapterId]["Chapter Name"]
  self.battleData = {}
  self.battleData.titleName = self.chapterName .. "-" .. self.stageName
  self.battleData.detail = ed.getDataTable("Stage")[self.stageId].description
  self.battleData.curBattleTimes = self.raidData.maxBattleTimes - self.raidData.curBattleTimes
  self.battleData.maxBattleTimes = self.raidData.maxBattleTimes
  self.enemyInfo = ed.GuildRaidManager:getEnemyInformation(self.stageId, self.wave)
  self:initPlayerLevelRange()
end

function GuildRaidStageDetailWin:initLabels()
  ed.setLabelShadow(self.ui.label_rank, ed.toccc3(2565412), ccp(1, 0))
  ed.setLabelShadow(self.ui.label_go, ed.toccc3(2565412), ccp(2, 0))
  ed.layout.horizontalSortNode({
    self.ui.icon_go,
    self.ui.label_go
  }, {15, 0}, self.ui.btn_go:getContentSize().width * 0.5)
end

function GuildRaidStageDetailWin:destroyMonsterDetailCard()
  if not tolua.isnull(self.monsterDetailCardPanel) then
    self.monsterDetailCardPanel:removeFromParentAndCleanup(true)
    self.monsterDetailCardPanel = nil
  end
end

function GuildRaidStageDetailWin:addMonsterDetailCard(data, ui)
  self:destroyMonsterDetailCard()
  local panel = ed.readequip.getDetailCard(data.id, {
    level = data.level,
    rank = data.rank,
    isBoss = data.isBoss,
    isUnit = true
  })
  local posx, posy = ui:getPosition()
  panel:setPosition(ccp(posx, posy + 80))
  self.ui.bg:addChild(panel, 10)
  self.monsterDetailCardPanel = panel
end

function GuildRaidStageDetailWin:createEnemy()
  local ox, oy = 85, 238
  self.battleData.heroHp = {}
  self.battleData.wave = self.stageData.wave
  for i = 1, 5 do
    local info = self.enemyInfo[i]
    if info then
      if not info.rank or 1 > info.rank then
        info.rank = ed.heroLevel2Rank(info.level)
      end
      local params = {
        id = info.id,
        rank = info.rank,
        stars = info.stars,
        level = info.level
      }
      local unit = ed.readhero.createIcon(params)
      local icon = unit.icon
      icon:setFlipX(true)
      if info.isBoss then
        ox = ox + 77
        icon:setScale(0.8)
        unit:addMonsterBossInfo()
      else
        ox = ox + 72
        icon:setScale(0.7)
      end
      icon:setPosition(ccp(ox, oy))
      self.ui.bg:addChild(icon)
      if self.stageData.hpList[info.index] then
        unit:addMonsterHpInfo({
          hp = self.stageData.hpList[info.index]
        })
        self.battleData.heroHp[info.id] = {
          hp = self.stageData.hpList[info.index]
        }
      end
      self:btRegisterButtonClick({
        key = "clickMonsterActor" .. i,
        button = icon,
        pressHandler = function()
          self:addMonsterDetailCard(info, icon)
        end,
        cancelPressHandler = function()
          self:destroyMonsterDetailCard()
        end,
        force = true
      })
      self.ui["enemy" .. i] = icon
    end
  end
end

function GuildRaidStageDetailWin:createRewards()
  local reward = {
    type = "gold",
    amount = self.raidData.chanllengeGold
  }
  local icon = ed.createItemIcon(reward)
  icon:setPosition(157, 152)
  self.ui.bg:addChild(icon)
  self:btRegisterButtonClick({
    button = icon,
    key = "RewardIcon",
    clickHandler = function()
      ed.ui.packageDetailWin.create({
        id = reward.id,
        type = reward.type
      }):popWindow()
    end,
    force = true
  })
end

function GuildRaidStageDetailWin:refreshOtherMember()
  local curChallengeData = self.stageData.curChallenge
  if curChallengeData and curChallengeData._user_summary then
    self.ui.bg_other:setVisible(true)
    local summary = curChallengeData._user_summary
    if summary._uid == ed.getUserid() then
      self.isSelfChallenge = true
      self.ui.bg_other:setVisible(false)
      return
    else
      self.isSelfChallenge = false
    end
    local param = {
      id = summary._avatar,
      level = summary._level,
      scale = 1,
      lvoffset = {x = -48, y = -35}
    }
    local chanllenger = ed.getWholeHeadIcon(param)
    ed.UITool.replaceUI(self.ui, "bg_other", "avatar", chanllenger)
    if curChallengeData._status == "fighting" then
      ed.setString(self.ui.label_state, T("\230\140\145\230\136\152\228\184\173..."))
    elseif curChallengeData._status == "prepare" then
      ed.setString(self.ui.label_state, T("\229\135\134\229\164\135\228\184\173..."))
    else
      ed.setString(self.ui.label_state, T("\231\187\147\231\174\151\228\184\173..."))
    end
    ed.setString(self.ui.label_name, summary._name)
  else
    self.ui.bg_other:setVisible(false)
  end
end

function GuildRaidStageDetailWin:refreshUI()
  self:createEnemy()
  self:createRewards()
  self:refreshOtherMember()
end

function GuildRaidStageDetailWin:initUI()
  local layer, ui = ed.editorui(ed.uieditor.RaidStageDetailWin)
  self.ui = ui
  self.container:addChild(layer)
  self:initLabels()
  ed.adaptLabel(self.ui.label_reward, {maxWidth = 80})
  ed.setString(self.ui.Label_16895, self.chapterName .. "-" .. self.stageName)
  ed.setString(self.ui.label_step, string.format(T("\231\172\172%d\230\179\162\230\149\140\228\186\186\239\188\136\229\133\1773\230\179\162\239\188\137"), self.wave))
  local dlPanel = ed.UITool.createDraglist(self.ui.describe_panel, {})
  local panelSize = self.ui.describe_panel:getContentSize()
  local describe_label = ed.createLabelTTF(ed.getDataTable("Stage")[self.stageId].description, 15)
  ed.setLabelColor(describe_label, ed.toccc3(16776423))
  describe_label:setDimensions(CCSizeMake(panelSize.width, 0))
  describe_label:setHorizontalAlignment(kCCTextAlignmentLeft)
  dlPanel:addItem(describe_label)
  if describe_label:getContentSize().height < panelSize.height then
    describe_label:setAnchorPoint(ccp(0, 0.5))
    describe_label:setPosition(ccp(0, panelSize.height * 0.5))
  else
    describe_label:setAnchorPoint(ccp(0, 1))
    describe_label:setPosition(ccp(0, panelSize.height - 2))
    dlPanel:initListHeight(describe_label:getContentSize().height + 4)
  end
  local strs = string.format(T("<lable color=ccc3(255,252,231) strokeColor=strokeColor1 strokeSize=1>\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\154</lable>") .. "<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%d/%d</lable>", self.raidData.maxBattleTimes - self.raidData.curBattleTimes, self.raidData.maxBattleTimes)
  local chanllengeTime = ed.ui.autoText.new()
  chanllengeTime:initParam({context = strs, fontSize = 14})
  chanllengeTime.node:setPosition(ccp(425, 81.5))
  self.ui.bg:addChild(chanllengeTime.node)
  self.ui.label_rank:limitWidthByScale(70)
  self.ui.Label_16895:limitWidthByScale(270)
  self:refreshUI()
end

function GuildRaidStageDetailWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {normalScale = 0.8, pressScale = 0.75})
  ed.UITool.registerBtn(self, "btn_rank", function()
    ed.GuildRaidNetwork:sendStageRank(self.stageId)
  end, {pressScale = 0.97})
  ed.UITool.registerBtn(self, "btn_go", function()
    local recordTime = ed.storage.getInt(ed.getRoleKey("setRaidTipPopTime" .. self.raidId))
    local skipPop = false
    if recordTime then
      skipPop = not ed.checkTwoDateod(recordTime)
    end
    if self:checkPlayerLevelInRange() or skipPop then
      self:doBtnGo()
    else
      local strs = T("\228\189\142\231\173\137\231\186\167\229\137\175\230\156\172\232\173\166\229\145\138\239\188\129<br/>\230\130\168\230\173\163\229\156\168\230\140\145\230\136\152\239\188\154%s(Lv.%s)<br/>\230\179\168\230\132\143\239\188\154\232\175\183\230\163\128\230\159\165\229\185\182\232\176\131\230\149\180\233\152\181\229\174\185\239\188\140\233\129\191\229\133\141\230\132\143\229\164\150\233\128\154\229\133\179\239\188\129", self.chapterName, self.chapterLevel)
      local info = {
        title = T("\230\143\144\231\164\186"),
        autoText = strs,
        rightHandler = function()
          self:doBtnGo()
          self.tipPop = nil
        end
      }
      local tips = ed.showConfirmDialog(info)
      self:addOnceBtn(tips)
    end
  end, {
    normalScale = 0.8,
    pressScale = 0.75,
    clickInterval = 0.5
  })
end

function GuildRaidStageDetailWin:doBtnGo()
  if self.tipPop and self.tipPop.img_check and self.tipPop.img_check:isVisible() then
    local key = ed.getRoleKey("setRaidTipPopTime" .. self.raidId)
    ed.storage.setValue(key, ed.getServerTime())
  end
  if self.stageData.stageProgress == ed.GuildRaidConfig.MaxStageProgress then
    ed.showToast(T("\229\133\179\229\141\161\229\183\178\233\128\154\229\133\179"))
    return
  end
  if self.raidData.curBattleTimes >= self.raidData.maxBattleTimes then
    ed.showToast(T("\230\140\145\230\136\152\230\172\161\230\149\176\228\184\141\232\182\179"))
    return
  end
  local ul = ed.getDataTable("Stage")[self.stageId]["Unlock Level"]
  if ul > ed.player:getLevel() then
    ed.showToast(string.format(T("\230\136\152\233\152\159\231\173\137\231\186\167\229\136\176\232\190\190%d\231\186\167\229\143\175\232\191\155\229\133\165\230\173\164\229\133\179\229\141\161"), ul))
    return
  end
  local h, m = ed.time2HMS()
  if not ed.isAreaOverSea() and tonumber(h) >= 5 and tonumber(h) <= 7 then
    ed.showToast(T("\229\189\147\229\137\141\230\128\170\231\137\169\230\173\163\229\156\168\228\188\145\230\129\175\239\188\140\232\175\183\231\168\141\229\128\153\229\134\141\232\175\149"))
    return
  end
  ed.GuildRaidNetwork:sendPrepareBattle(self.stageId, self.stageData.stageProgress)
end

function GuildRaidStageDetailWin:destroy()
  if self.callback then
    self.callback()
  end
  base.destroy(self, {skipAnim = true})
end
