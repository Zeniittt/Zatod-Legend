local base = ed.ui.commonscene
local class = newclass(base.mt)
ed.ui.stageselect = class
local res = ed.ui.stageselectres
local lsr = ed.ui.stageselectlsr.create()
local drag_dis = 60
local drag_gap = 1
local KEY_STAGE_RADIUS = 75
local NOT_KEY_STAGE_RADIUS = 75
local change_chapter_gap = 0.5
local map_ori_pos = ccp(400, 205)
local challengeUnlockLevel = 90
local openChallengeData = {}
local unlocakChallengeEliteStageId = 303
ed.unlocakChallengeEliteStageId = unlocakChallengeEliteStageId
ListenEvent("activityCrossDays", function()
  local lastTime = ed.player:getEliteResetTime()
  local time = ed.getServerTime()
  if ed.checkTwoDateod(lastTime, time) then
    ed.player:resetEliteRequest_type0()
  end
end)

function class:getResMap(chapterId)
  if self.mode == "guild" then
    local _, id = ed.ui.guild.getInstanceInfo(chapterId)
    local raid = ed.getDataTable("Raid")[id or 0]
    if raid and raid.Difficulty > 1 then
      return res.map[string.format("chapter%d_%d", chapterId, raid.Difficulty)]
    end
  end
  return res.map["chapter" .. chapterId]
end

local function getEliteProgress(self)
  return ed.player:getEliteStageProgress()
end

class.getEliteProgress = getEliteProgress

local function getChallengeProgress(self)
  return ed.player:getChallengeProgress()
end

class.getChallengeProgress = getChallengeProgress

local function getNormalProgress(self)
  return ed.player:getStageProgress()
end

class.getNormalProgress = getNormalProgress

local function getMaxEliteChapter(self)
  local st = ed.getDataTable("Stage")
  local progress = self:getEliteProgress()
  return st[st[progress]["Stage Group"]]["Chapter ID"]
end

class.getMaxEliteChapter = getMaxEliteChapter

local function getMaxChallengeChapter(self)
  local st = ed.getDataTable("Stage")
  local maxChallengeChapter = 1
  local openChallengeStageIds = openChallengeData or {}
  for k, stageId in pairs(openChallengeStageIds) do
    maxChallengeChapter = math.max(maxChallengeChapter, st[stageId]["Chapter ID"])
  end
  return maxChallengeChapter
end

class.getMaxChallengeChapter = getMaxChallengeChapter

local function getMaxNormalChapter(self)
  local st = ed.getDataTable("Stage")
  local progress = self:getNormalProgress()
  return st[progress]["Chapter ID"]
end

class.getMaxNormalChapter = getMaxNormalChapter

local function getMinGuildInstanceChapter(self)
  for i = 1, ed.parameter.max_guild_chapter do
    local info = self:getResMap(i)
    if info and info.guildInstance == true then
      return i
    end
  end
end

class.getMinGuildInstanceChapter = getMinGuildInstanceChapter

local function getMaxGuildInstanceChapter(self)
  for i = getMaxNormalChapter(self), 1, -1 do
    local info = self:getResMap(i)
    if info and info.guildInstance == true then
      return i
    end
  end
  return getMinGuildInstanceChapter(self)
end

class.getMaxGuildInstanceChapter = getMaxGuildInstanceChapter

local function getMaxChapter(self)
  local maxChapters = {
    normal = self.normalInfo.maxChapter,
    elite = self.eliteInfo.maxChapter,
    guild = self.guildInfo.maxChapter,
    challenge = self.challengeInfo.maxChapter
  }
  return maxChapters[self.mode]
end

class.getMaxChapter = getMaxChapter

local function getMinChapter(self)
  if self.mode == "guild" then
    return getMinGuildInstanceChapter(self)
  else
    return 1
  end
end

class.getMinChapter = getMinChapter

local function getDotPos(self, max, current)
  local dx = res.chapter_dot_gap_x
  local y
  if self.isElite then
    y = res.elite_chapter_dot_y
  else
    y = res.normal_chapter_dot_y
  end
  local center = (max + 1) / 2
  local x = 477 + dx * (current - center)
  local newHei = ed.display.halfFixedHeight
  return ccp(x, y - newHei)
end

class.getDotPos = getDotPos

local function getChapter(self)
  local modes = {
    normal = self.normalInfo.chapter,
    elite = self.normalInfo.chapter,
    challenge = self.challengeInfo.chapter,
    guild = self.guildInfo.chapter
  }
  return modes[self.mode]
end

class.getChapter = getChapter

local function setChapter(self, chapter)
  self.lastOperation = "changeChapter"
  if self.mode == "elite" then
    self.preChapter = self.normalInfo.chapter
    self.normalInfo.chapter = chapter
  elseif self.mode == "normal" then
    self.preChapter = self.normalInfo.chapter
    self.normalInfo.chapter = chapter
  elseif self.mode == "challenge" then
    self.preChapter = self.challengeInfo.chapter
    self.challengeInfo.chapter = chapter
  else
    self.preChapter = self.guildInfo.chapter
    self.guildInfo.chapter = chapter
  end
end

class.setChapter = setChapter

local function isAllowChallengeStage(self, info)
  if self.mode == "challenge" then
    local stageIds = info.challengeInstanceId or {}
    local temp = {}
    for k, v in pairs(openChallengeData or {}) do
      temp[v] = k
    end
    for k, v in pairs(stageIds) do
      if temp[v] or ed.player:getStageStar(v) > 0 then
        return true
      end
    end
  end
end

class.isAllowChallengeStage = isAllowChallengeStage

local function isChallengeStageFinishPre(info)
  local temp = {}
  local stageTable = ed.getDataTable("Stage")
  local sid = info.challengeInstanceId[1]
  local requireStage = stageTable[sid]["Require Stage"]
  if requireStage then
    if ed.player:getStageStar(requireStage) > 0 then
      return true
    else
      return false
    end
  end
end

local function doStageTouch(self)
  local function handler(event, x, y)
    if self.mapContainer:getOpacity() ~= 255 then
      return
    end
    if self.mapContainer:numberOfRunningActions() > 0 then
      return
    end
    
    local function canTouch(info)
      if info.type == "current" or info.type == "passed" and info.eid or self.mode == "guild" and info.eid then
        return true
      end
    end
    
    xpcall(function()
      if event == "began" then
        if self.mode == "guild" then
          local fbshopButton = self.guildUI and self.guildUI.fbshop or nil
          if fbshopButton and fbshopButton:isVisible() and ed.containsPoint(fbshopButton, x, y) then
            return
          end
          local recordButton = self.guildUI and self.guildUI.record or nil
          if recordButton and recordButton:isVisible() and ed.containsPoint(recordButton, x, y) then
            return
          end
        end
        if self.puppet and ed.isPointInCircle(ccpAdd(ccp(self.puppet:getPosition()), ccp(30, 30)), KEY_STAGE_RADIUS, x, y, self.stageContainer) then
          self.puppet:setScale(0.48)
          return
        end
        for i = 1, #self.stageIcon do
          local info = self.stageIcon[i]
          if canTouch(info) then
            if info.eid or info.guildInstanceId then
              if ed.isPointInCircle(info.pos, KEY_STAGE_RADIUS, x, y, self.stageContainer) then
                self.pressStageID = i
                self.pressStageChapterID = self:getChapter()
                info.icon:setScale(0.95)
              end
            elseif ed.isPointInCircle(info.pos, NOT_KEY_STAGE_RADIUS, x, y, self.stageContainer) then
              self.pressStageID = i
              self.pressStageChapterID = self:getChapter()
              info.icon:setScale(0.95)
            end
          end
        end
      elseif event == "ended" then
        if self.puppet then
          self.puppet:setScale(0.5)
          if ed.isPointInCircle(ccpAdd(ccp(self.puppet:getPosition()), ccp(30, 30)), KEY_STAGE_RADIUS, x, y, self.stageContainer) then
            local info = self.lootStageInfo.lootStage
            self:gotoDetailScene(info, info.eid)
            return
          end
        end
        local preChapter = self.pressStageChapterID
        self.pressStageChapterID = nil
        local id = self.pressStageID
        self.pressStageID = nil
        if id then
          if self:getChapter() ~= preChapter then
            return
          end
          local info = self.stageIcon[id]
          info.icon:setScale(1)
          if self.isSelectStageTutorial and id == 1 then
            self.showTutorial = false
            self:refresh()
          end
          if info.eid or info.guildInstanceId or info.challengeInstanceId then
            if ed.isPointInCircle(info.pos, KEY_STAGE_RADIUS, x, y, self.stageContainer) and not self.isClickChangeChapterButton and not self.intoStageDetail then
              lsr:report("clickKeyStage")
              if self.isElite or self.mode == "challenge" then
                if (ed.player:getStageStar(info.id) or 0) == 0 then
                  ed.showToast(T("\233\128\154\229\133\179\230\153\174\233\128\154\230\168\161\229\188\143\229\144\142\229\188\128\229\144\175"))
                elseif self.mode == "challenge" then
                  if isChallengeStageFinishPre(info) then
                    if self:isAllowChallengeStage(info) then
                      self:gotoDetailScene(info, id)
                    else
                      ed.showToast(T("\230\173\164\229\133\179\229\141\161\229\176\134\233\154\143\230\151\182\233\151\180\229\188\128\230\148\190"))
                    end
                  else
                    local sid = info.challengeInstanceId[1]
                    local row = ed.getDataTable("Stage")[sid]
                    local rsid = row["Require Stage"]
                    local rRow = ed.getDataTable("Stage")[rsid]
                    local chapter = rRow["Chapter ID"]
                    local sname = rRow["Stage Name"]
                    ed.showToast(T("\229\174\140\230\136\144\231\172\172%d\231\171\160\231\154\132%s\229\144\142\229\188\128\229\144\175", chapter, sname))
                  end
                else
                  self:gotoDetailScene(info, id)
                end
              elseif self.mode == "guild" then
                if (ed.player:getStageStar(info.id) or 0) == 0 then
                  ed.showToast(T("\233\128\154\229\133\179\230\153\174\233\128\154\230\168\161\229\188\143\229\144\142\229\188\128\229\144\175"))
                else
                  self:gotoGuildInstance(info)
                end
              else
                self:gotoDetailScene(info, id)
              end
            end
          elseif ed.isPointInCircle(info.pos, NOT_KEY_STAGE_RADIUS, x, y, self.stageContainer) and not self.isClickChangeChapterButton and not self.intoStageDetail then
            lsr:report("clickNotKeyStage")
            self:gotoDetailScene(info, id)
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

class.doStageTouch = doStageTouch

local function maxChallengeStageId(self, info)
  local challengeInstanceId = info.challengeInstanceId or {}
  local stageid = challengeInstanceId[1]
  local challengePro = 0
  table.sort(challengeInstanceId, function(a, b)
    return a < b
  end)
  for k, v in pairs(challengeInstanceId) do
    local isFinish = ed.player:getStageStar(v)
    challengePro = challengePro + (0 < isFinish and 1 or 0)
  end
  if 0 < challengePro then
    stageid = challengeInstanceId[math.min(challengePro + 1, 3)]
  end
  return stageid
end

class.maxChallengeStageId = maxChallengeStageId

local function getCurrentStageId(self, info)
  if nil == info then
    return
  end
  local modeStageId = {
    normal = info.id,
    elite = info.eid,
    guild = info.guildInstanceId,
    challenge = self:maxChallengeStageId(info)
  }
  return modeStageId[self.mode]
end

local function gotoGuildInstance(self, info)
  if info.guildInstanceId then
    local instanceInfo = ed.ui.guild.getInstanceInfo(self:getChapter())
    if instanceInfo then
      local msg = ed.upmsg.guild()
      msg._instance_detail = {}
      msg._instance_detail._stage_id = info.guildInstanceId
      ed.send(msg, "guild")
    end
  end
end

class.gotoGuildInstance = gotoGuildInstance

local function gotoDetailScene(self, info)
  local isGetWay = self.identity == "stageSelectGWMode" and true or nil
  self.leftArrow:setVisible(false)
  self.rightArrow:setVisible(false)
  local panel = ed.ui.stagedetail.create(getCurrentStageId(self, info), {
    isGetWay = isGetWay,
    challengeModes = info.challengeInstanceId or {},
    lootStage = info.bossId ~= nil and info or {}
  }, self.mode, function()
    ListenTimer(Timer:Once(0.05), function(...)
      self:onEnterHandler()
    end, self.scope)
  end)
  panel:popWindow()
  self.intoStageDetail = true
  if self.getWayStage == info.id or self.getWayStage == info.eid or self.getWayStage == info.guildInstanceId then
    if self.circle then
      self.circle:setVisible(false)
      self.circle = nil
    end
    if self.finger then
      self.finger:setVisible(false)
      self.finger = nil
    end
    self.getWayMode = nil
    self.getWayStage = nil
  end
end

class.gotoDetailScene = gotoDetailScene
local modePressColor = ccc3(228, 183, 16)
local modeNormalColor = ccc3(255, 255, 255)

local function updateGuildInstanceButton(self)
end

local function updateModeButtonUI(self)
  if self.mode == "normal" or self.mode == "elite" then
    self.modeui[self.mode .. "_button"]:setVisible(false)
    self.modeui[self.mode .. "_button_press"]:setVisible(true)
    local mode = self.mode == "normal" and "elite" or "normal"
    self.modeui[mode .. "_button"]:setVisible(true)
    self.modeui[mode .. "_button_press"]:setVisible(false)
  end
end

class.updateModeButtonUI = updateModeButtonUI

local function updateModeButtonState(self)
  if not ed.playerlimit.checkAreaUnlock("Elite") then
    return
  end
  self:updateModeButtonUI()
  updateGuildInstanceButton(self)
end

class.updateModeButtonState = updateModeButtonState

local function addChangeModeToast(self)
  local tosts = {
    normal = T("\230\153\174\233\128\154\230\168\161\229\188\143"),
    elite = T("\231\178\190\232\139\177\230\168\161\229\188\143"),
    guild = T("\229\133\172\228\188\154\229\137\175\230\156\172"),
    challenge = T("\230\140\145\230\136\152\230\168\161\229\188\143")
  }
  local container = CCDirector:sharedDirector():getRunningScene()
  if not tolua.isnull(self.toast) then
    if container:getChildByTag(999) then
      container:removeChildByTag(999, true)
    end
    self.toast = nil
  end
  self.toast = ed.toast.createToast(tosts[self.mode])
  if not tolua.isnull(self.toast) then
    self.toast:setPosition(ccp(ed.display.winSize.width / 2, ed.display.winSize.height / 2))
    container:addChild(self.toast, 500, 999)
    local delay = CCDelayTime:create(0.2)
    local fadeout = CCFadeOut:create(0.6)
    local sequence = CCSequence:create(ed.ccArrayMake(delay, fadeout, CCCallFunc:create(function()
      self.toast = nil
    end)))
    self.toast:runAction(sequence)
  end
end

class.addChangeModeToast = addChangeModeToast

local function doChangeMode(self, mode)
  local isElite = (mode or "") == "elite"
  local preChapter = self:getChapter()
  self.isElite = isElite
  self.mode = mode
  self.lastOperation = "changeMode"
  self:createFrame(self:getChapter(), mode)
  self:createMap(self:getChapter(), mode)
  self:createTitle(self:getChapter())
  self:setChapterButtonState()
  updateModeButtonState(self)
  addChangeModeToast(self)
  self:updateModeStarRedVis()
  self:refreshBuff()
end

class.doChangeMode = doChangeMode
local numberStr = {
  T("\228\184\128"),
  T("\228\186\140"),
  T("\228\184\137"),
  T("\229\155\155"),
  T("\228\186\148"),
  T("\229\133\173"),
  T("\228\184\131"),
  T("\229\133\171"),
  T("\228\185\157"),
  T("\229\141\129"),
  T("\229\141\129\228\184\128"),
  T("\229\141\129\228\186\140"),
  T("\229\141\129\228\184\137"),
  T("\229\141\129\229\155\155")
}

local function doModeButtonTouch(self)
  local modeTouches = {}
  modeTouches[1] = {
    pressNormal = nil,
    normal = self.modeui.normal_button,
    normalPress = self.modeui.normal_button_press,
    normal_icon = self.modeui.normal,
    normal_icon_press = self.modeui.normal_press,
    handler = function()
      lsr:report("cliclNormalMode")
      self:doChangeMode("normal")
    end
  }
  modeTouches[2] = {
    pressNormal = nil,
    normal = self.modeui.elite_button,
    normalPress = self.modeui.elite_button_press,
    normal_icon = self.modeui.elite,
    normal_icon_press = self.modeui.elite_press,
    handler = function()
      local ds = ed.playerlimit.getAreaUnlockPrompt("Elite")
      if ds then
        ed.showToast(ds)
        return
      end
      local max, svrmax = ed.playerlimit.maxChapter("elite")
      svrmax = math.min(svrmax, self.eliteInfo.maxChapter)
      if svrmax < self.normalInfo.chapter then
        self.normalInfo.chapter = svrmax
        ed.showToast(T("\232\175\165\229\156\176\229\155\190\231\154\132\231\178\190\232\139\177\230\168\161\229\188\143\230\156\170\229\188\128\230\148\190\n\229\183\178\232\135\170\229\138\168\232\183\179\232\189\172\232\135\179\230\156\128\230\150\176\231\171\160\232\138\130"))
      end
      lsr:report("clickEliteMode")
      self:doChangeMode("elite")
      self.showTutorial = false
      self:refresh()
    end
  }
  local currentTouchMode = 1
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        for k, v in pairs(modeTouches) do
          if v.normal:isVisible() and not v.normalPress:isVisible() and ed.containsPoint(v.normal, x, y) then
            currentTouchMode = k
            v.pressNormal = true
            v.normal:setScale(1.1)
          end
        end
      elseif event == "ended" then
        local v = modeTouches[currentTouchMode]
        if v.pressNormal then
          if ed.containsPoint(v.normal, x, y) then
            v.handler()
            v.pressNormal = nil
            v.normal:setScale(1)
          else
            v.normal:setScale(1)
          end
        end
      end
    end, EDDebug)
  end
  
  return handler
end

class.doModeButtonTouch = doModeButtonTouch

local function getGuildInstanceId(self, chapter)
  local max = ed.parameter.max_guild_chapter
  max = math.min(max, self:getMaxChapter())
  local preChapter = self:getChapter()
  if 0 < chapter then
    for i = preChapter + 1, max do
      local info = self:getResMap(i)
      if info and info.guildInstance == true then
        return i
      end
    end
  else
    for i = preChapter - 1, 1, -1 do
      local info = self:getResMap(i)
      if info and info.guildInstance == true then
        return i
      end
    end
  end
  return preChapter
end

local function doChangeChapter(self, chapter)
  local preChapter = self:getChapter()
  local postChapter = preChapter + 1
  if chapter == "+" or chapter == 1 then
    local max, svrmax = ed.playerlimit.maxChapter(self.mode)
    if postChapter > svrmax then
      return
    end
    svrmax = math.min(svrmax, self:getMaxChapter())
    max = math.min(max, self:getMaxChapter())
    local c
    if self.mode == "guild" then
      c = getGuildInstanceId(self, chapter)
    else
      c = math.min(postChapter, max)
    end
    local str = ""
    local chapterName = ed.getDataTable("Chapter")[self:getChapter()]["Chapter Name"]
    if self:getChapter() == svrmax then
      str = str .. T("     \229\137\141\229\190\128\228\184\139\228\184\128\229\140\186\229\159\159\233\156\128:     \n    1.") .. T("\229\174\140\230\136\144\231\172\172%s\231\171\160%s", numberStr[self:getChapter()], chapterName)
    end
    local ul = ed.playerlimit.chapterUnlockLevel(postChapter)
    if ul and ul > ed.player:getLevel() then
      if str == "" then
        str = str .. T("     \229\137\141\229\190\128\228\184\139\228\184\128\229\140\186\229\159\159\233\156\128:     \n    1.") .. T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167", ul)
      else
        str = str .. T("     \n    2.\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176%d\231\186\167", ul)
      end
    else
      self:setChapter(c)
    end
    if str ~= "" then
      local bg, board, label = ed.showToast(str)
      label:setHorizontalAlignment(kCCTextAlignmentLeft)
    end
  end
  if chapter == "-" or chapter == -1 then
    if self.mode == "guild" then
      local c = getGuildInstanceId(self, chapter)
      if c then
        self:setChapter(c)
      end
    else
      self:setChapter(math.max(self:getChapter() - 1, 1))
    end
  end
  if self:getChapter() ~= preChapter then
    self:createMap(self:getChapter(), self.mode)
    self:createTitle(self:getChapter())
    self:setChapterButtonState()
  end
  self:updateModeButtonState()
  self:updateModeStarRedVis()
end

class.doChangeChapter = doChangeChapter

local function updateModeStarRedVis(self)
  local vis1, vis2 = ed.ui.stageselectres.getChapterIdStarRed(self:getChapter(), self.mode)
  self.leftArrow.red:setVisible(vis1)
  self.rightArrow.red:setVisible(vis2)
  local bek, index, mod = ed.ui.stageselectres.getStageStarBoxRed(self.mode == "elite" and "normal" or "elite")
  mod = mod or self.mode == "elite" and "normal" or "elite"
  self.modeui[mod .. "_button_red"]:setVisible(bek)
end

class.updateModeStarRedVis = updateModeStarRedVis

local function newChangeChapter(self, chapter)
  local preChapter = self:getChapter()
  if self.mode == "guild" then
    local c = getGuildInstanceId(self, chapter)
    if c then
      self:setChapter(c)
    end
  else
    self:setChapter(math.max(chapter, 1))
  end
  if self:getChapter() ~= preChapter then
    self:createMap(self:getChapter(), self.mode)
    self:createTitle(self:getChapter())
    self:setChapterButtonState()
  end
  self:updateModeButtonState()
end

class.newChangeChapter = newChangeChapter

local function doChapterDrag(self)
  local rect = CCRectMake(60, 35, 690, 325)
  local press, pressPos, pressTime
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if ed.isPointInRect(rect, x, y) then
          press = true
          pressPos = ccp(x, y)
          pressTime = ed.getSystemTime()
        end
      elseif event == "ended" then
        if press then
          local pos = pressPos
          local time = pressTime
          if math.abs(x - pos.x) > math.abs(y - pos.y) and math.abs(x - pos.x) > drag_dis and ed.getSystemTime() - time < drag_gap then
            self.dragMode = true
            if x > pos.x then
              self:doChangeChapter(-1)
            else
              self:doChangeChapter(1)
            end
          end
        end
        press = nil
        pressPos = nil
        pressTime = nil
      end
    end, EDDebug)
  end
  
  return handler
end

class.doChapterDrag = doChapterDrag

local function doChangeChapterButtonTouch(self)
  local pressLeft, pressRight
  local left = self.leftArrow
  local right = self.rightArrow
  
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if left:isVisible() and ed.containsPoint(left, x, y) then
          pressLeft = true
          left:setScale(left:getScale() - 0.1)
        end
        if right:isVisible() and ed.containsPoint(right, x, y) then
          pressRight = true
          right:setScale(right:getScale() - 0.1)
        end
      elseif event == "ended" then
        if pressLeft then
          left:setScale(left:getScale() + 0.1)
          if ed.containsPoint(left, x, y) and not self.dragMode then
            lsr:report("clickChangeChapter")
            self.isClickChangeChapterButton = true
            self:doChangeChapter(-1)
          end
        end
        pressLeft = nil
        if pressRight then
          right:setScale(right:getScale() + 0.1)
          if ed.containsPoint(right, x, y) and not self.dragMode then
            lsr:report("clickChangeChapter")
            self.isClickChangeChapterButton = true
            self:doChangeChapter(1)
          end
        end
        pressRight = nil
      end
    end, EDDebug)
  end
  
  return handler
end

class.doChangeChapterButtonTouch = doChangeChapterButtonTouch

local function getRaidIdByChapter(chapter)
  if not chapter then
    return
  end
  local _, raidId = ed.ui.guild.getInstanceInfo(chapter)
  if raidId then
    return raidId
  end
  local raidTable = ed.getDataTable("Raid")
  for id, raid in ipairs(raidTable) do
    if raid["Chapter ID"] == chapter and raid.Difficulty == 1 then
      return id
    end
  end
end

local function showGuildReward(self)
  local raidId = getRaidIdByChapter(self:getChapter())
  if raidId then
    local msg = ed.upmsg.guild()
    msg._instance_drop = {}
    msg._instance_drop._raid_id = raidId
    ed.send(msg, "guild")
  end
end

local function showFBShop(self)
  local raidId = getRaidIdByChapter(self:getChapter())
  if raidId then
    ListenTimer(Timer:Once(0.25), function()
      ed.pushScene(FBShop.FBShopFrame.create({raidId = raidId}))
    end)
  end
end

local function doGuildButtonTouch(self)
  local pressGuild
  local self = self
  
  local function handler(event, x, y)
    local guildButton = self.guildUI and self.guildUI.reward or nil
    if guildButton == nil then
      return
    end
    if self.mode ~= "guild" then
      return
    end
    if event == "began" then
      if guildButton:isVisible() and ed.containsPoint(guildButton, x, y) then
        pressGuild = true
        guildButton:setScale(0.95)
      end
    elseif event == "ended" then
      if pressGuild then
        guildButton:setScale(1)
        if ed.containsPoint(guildButton, x, y) then
          showGuildReward(self)
        end
      end
      pressGuild = nil
    end
  end
  
  return handler
end

class.doGuildButtonTouch = doGuildButtonTouch

local function doFBShopButtonTouch(self)
  local pressGuild
  local self = self
  
  local function handler(event, x, y)
    local fbshopButton = self.guildUI and self.guildUI.fbshop or nil
    if fbshopButton == nil then
      return
    end
    if self.mode ~= "guild" then
      return
    end
    if event == "began" then
      if fbshopButton:isVisible() and ed.containsPoint(fbshopButton, x, y) then
        pressGuild = true
        fbshopButton:setScale(0.95)
      end
    elseif event == "ended" then
      if pressGuild then
        fbshopButton:setScale(1)
        if ed.containsPoint(fbshopButton, x, y) then
          self.guildUI.fbshop_redlight:setVisible(false)
          showFBShop(self)
        end
      end
      pressGuild = nil
    end
  end
  
  return handler
end

class.doFBShopButtonTouch = doFBShopButtonTouch

local function doRecordTouch(self)
  local isPress
  local self = self
  
  local function handler(event, x, y)
    local button = self.guildUI and self.guildUI.record or nil
    if button == nil then
      return
    end
    if self.mode ~= "guild" then
      return
    end
    if event == "began" then
      if button:isVisible() and ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(0.95)
      end
    elseif event == "ended" then
      if isPress then
        button:setScale(1)
        if ed.containsPoint(button, x, y) then
          local raidId = getRaidIdByChapter(self:getChapter())
          if raidId then
            local msg = ed.upmsg.guild()
            msg._instance_damage = {}
            msg._instance_damage._raid_id = raidId
            ed.send(msg, "guild")
          end
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doRecordTouch = doRecordTouch

local function getMainTouchHandler(self)
  local modeButtonTouch = self:doModeButtonTouch()
  local chapterDrag = self:doChapterDrag()
  local changeChapterButtonTouch = self:doChangeChapterButtonTouch()
  local guildButtonTouch = self:doGuildButtonTouch()
  local fbShopButtonTouch = self:doFBShopButtonTouch()
  local recordTouch = self:doRecordTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      modeButtonTouch(event, x, y)
      chapterDrag(event, x, y)
      changeChapterButtonTouch(event, x, y)
      self:doStageTouch()(event, x, y)
      guildButtonTouch(event, x, y)
      fbShopButtonTouch(event, x, y)
      if recordTouch then
        recordTouch(event, x, y)
      end
      if event == "ended" then
        self.dragMode = nil
        self.isClickChangeChapterButton = nil
      end
    end, EDDebug)
    return true
  end
  
  return handler
end

class.getMainTouchHandler = getMainTouchHandler

local function setChapterButtonState(self)
  local max, svrmax = ed.playerlimit.maxChapter(self.mode)
  local min = self:getMinChapter()
  local chapter = self:getChapter()
  self.leftArrow:setVisible(chapter ~= min)
  self.rightArrow:setVisible(chapter ~= svrmax)
  svrmax = math.min(svrmax, self:getMaxChapter())
  local left = "UI/alpha/1080P/campaign/main/prevchap"
  local right = "UI/alpha/1080P/campaign/main/nextchap"
  if chapter == min then
    ed.initSpriteWithFrame(self.leftArrow, left .. "-mask.png")
    ed.initSpriteWithFrame(self.rightArrow, right .. ".png")
  end
  if chapter == svrmax then
    ed.initSpriteWithFrame(self.leftArrow, left .. ".png")
    ed.initSpriteWithFrame(self.rightArrow, right .. "-mask.png")
  end
  if min < chapter and chapter < svrmax then
    ed.initSpriteWithFrame(self.leftArrow, left .. ".png")
    ed.initSpriteWithFrame(self.rightArrow, right .. ".png")
  end
  if svrmax == min then
    ed.initSpriteWithFrame(self.leftArrow, left .. "-mask.png")
    ed.initSpriteWithFrame(self.rightArrow, right .. "-mask.png")
  end
end

class.setChapterButtonState = setChapterButtonState

local function refreshDot(self, showAnim)
  self:createDot(showAnim)
  if showAnim then
    self.dotContainer:setOpacity(0)
    local fadein = CCFadeIn:create(0.5)
    self.dotContainer:runAction(fadein)
  end
end

class.refreshDot = refreshDot

local function createDot(self)
  if self.dotContainer then
    self.dotContainer:removeFromParentAndCleanup(true)
  end
  local max = self:getMaxChapter()
  local current = self:getChapter()
  local dotContainer = CCSprite:create()
  self.dotContainer = dotContainer
  self.mainLayer:addChild(dotContainer, 30)
  dotContainer:setCascadeOpacityEnabled(true)
  local dotIcon = {}
  for i = 1, max do
    local icon
    if i == current then
      icon = ed.createSprite(res.dotRes.current)
    else
      icon = ed.createSprite(res.dotRes.normal)
    end
    icon:setPosition(self:getDotPos(max, i))
    dotContainer:addChild(icon)
  end
  self.dotIcon = dotIcon
  if self.mode == "guild" then
    self.dotContainer:setVisible(false)
  else
    self.dotContainer:setVisible(true)
  end
end

class.createDot = createDot

local function createChapterButton(self)
  local left = ed.createSprite("UI/alpha/1080P/campaign/main/prevchap.png")
  local right = ed.createSprite("UI/alpha/1080P/campaign/main/nextchap.png")
  local red = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  red:setPosition(28, 36)
  red:setScale(0.7)
  red:setVisible(false)
  left:addChild(red)
  left.red = red
  local red = ed.createSprite("UI/alpha/1080P/common/digit_red_tag_bg.png")
  red:setPosition(0, 36)
  red:setScale(0.7)
  red:setVisible(false)
  right:addChild(red)
  right.red = red
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local y = heightWin / 2 - newHei
  self.leftArrow = left
  self.rightArrow = right
  self.mainLayer:addChild(left, 30)
  self.mainLayer:addChild(right, 30)
  left:setPosition(ccp(78 - newWid, y))
  right:setPosition(ccp(widhtWin - 78 - newWid, y))
  left:setScale(1.5)
  right:setScale(1.5)
  local leftPosX = left:getPositionX()
  local rightPosX = right:getPositionX()
  local lmove = CCMoveTo:create(1, ccp(leftPosX - 10, y))
  local lreverse = CCMoveTo:create(1, ccp(leftPosX, y))
  local lsequence = CCSequence:createWithTwoActions(lmove, lreverse)
  self.leftArrow:runAction(CCRepeatForever:create(lsequence))
  local rmove = CCMoveTo:create(1, ccp(rightPosX + 10, y))
  local rreverse = CCMoveTo:create(1, ccp(rightPosX, y))
  local rsequence = CCSequence:createWithTwoActions(rmove, rreverse)
  self.rightArrow:runAction(CCRepeatForever:create(rsequence))
  self:setChapterButtonState()
end

class.createChapterButton = createChapterButton

local function createStarChestPro(self)
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local bigMapBtn = ed.createSprite("UI/alpha/1080P/campaign/campaign_map_bg_1.png")
  bigMapBtn:setPosition(ccp(60 - newWid + ed.display.getNotchHeight(), 53 - newHei))
  self.mainLayer:addChild(bigMapBtn, 30)
  local size = bigMapBtn:getContentSize()
  local bigMapImg = ed.createSprite("UI/alpha/1080P/campaign/campaign_map_icon.png")
  bigMapImg:setPosition(ccp(size.width / 2, size.height / 2 + 8))
  bigMapBtn:addChild(bigMapImg)
  local nameMapImgbj = ed.createSprite("UI/alpha/1080P/campaign/campaign_map_bg.png")
  nameMapImgbj:setPosition(ccp(size.width / 2, 8))
  bigMapBtn:addChild(nameMapImgbj)
  local labelName = ed.createttf(T("\228\184\150\231\149\140\229\156\176\229\155\190"), 16)
  ed.setLabelColor(labelName, ed.toccc3(16774579))
  ed.setLabelStroke(labelName, ed.toccc3(12283392), 1)
  labelName:setPosition(ccp(size.width / 2, 8))
  bigMapBtn:addChild(labelName)
  self:btRegisterButtonClick({
    button = bigMapBtn,
    key = "bigMapBtn",
    clickHandler = function()
      local max, elitemax = ed.playerlimit.maxChapter("elite")
      elitemax = math.min(elitemax, self.eliteInfo.maxChapter)
      local max, normalmax = ed.playerlimit.maxChapter("normal")
      normalmax = math.min(normalmax, self.normalInfo.maxChapter)
      local toScene = ed.ui.stageBigMap.create({
        stageselectSelf = self,
        config = self.StageStarData,
        elitemax = elitemax,
        normalmax = normalmax
      })
      ed.pushScene(toScene)
    end,
    pressScale = 0.92,
    force = true,
    mcpMode = true
  })
  local chestBg = ed.createScale9Sprite("UI/alpha/1080P/campaign/main/campaign_chest_bg.png", CCRectMake(6, 6, 6, 6))
  chestBg:setContentSize(CCSizeMake(480, 50))
  chestBg:setPosition(ccp(ed.display.resourceSize.width / 2 / 2, 53 - newHei))
  self.mainLayer:addChild(chestBg, 30)
  local res = self.mode == "elite" and "worldmap_star_hard" or "worldmap_star_normal"
  local starBg = ed.createSprite("UI/alpha/1080P/campaign/main/campaign_chest_star_bg.png")
  starBg:setPosition(ccp(90, 23.5))
  chestBg:addChild(starBg, 30)
  local star = ed.createSprite("UI/alpha/1080P/campaign/worldmap/" .. res .. ".png")
  star:setPosition(ccp(45, 22.5))
  chestBg:addChild(star, 30)
  star:setScale(1.3)
  self.stageStarImg = star
  local label = ed.createttf("13", 18)
  label:setPosition(ccp(87, 23.5))
  label:setColor(ccc3(ed.colorToStr("#ffb733")))
  chestBg:addChild(label, 31)
  label:setShadow(ccc3(0, 0, 0), ccp(0, 1))
  label:setAnchorPoint(ccp(1, 0.5))
  self.ui.starChestLab = label
  label = ed.createttf("/18", 18)
  label:setPosition(ccp(90, 23.5))
  label:setColor(ccc3(ed.colorToStr("#ffce7")))
  chestBg:addChild(label, 31)
  label:setShadow(ccc3(0, 0, 0), ccp(0, 1))
  label:setAnchorPoint(ccp(0, 0.5))
  self.ui.starChestMaxLab = label
  local progressBg = ed.createScale9Sprite("UI/alpha/1080P/campaign/main/campaign_chest_progress_1.png", CCRectMake(6, 6, 6, 6))
  progressBg:setContentSize(CCSizeMake(276.5, 14.5))
  progressBg:setPosition(ccp(143.25, 23))
  chestBg:addChild(progressBg, 30)
  progressBg:setAnchorPoint(ccp(0, 0.5))
  local progress = ed.createScale9Sprite("UI/alpha/1080P/campaign/main/campaign_chest_progress_2.png", CCRectMake(5, 0, 263.5, 0))
  progress:setContentSize(CCSizeMake(273.5, 11))
  progress:setPosition(ccp(1.5, 7.5))
  progressBg:addChild(progress)
  progress:setAnchorPoint(ccp(0, 0.5))
  self.identity = "stageselect"
  self.resourceBox = ed.ui.resourceBox.create(self)
  self.resourceBox:addTo(self.mainLayer)
  local tab = ed.getDataTable("StageStarReward")
  local normalTab = {}
  local eliteTab = {}
  local newTab = {}
  for i, v in ipairs(tab) do
    if type(v) == "table" then
      newTab = {}
      newTab.id = v.ID
      newTab.chapterId = v["Chapter ID"]
      newTab.StarNum = v["Require Star Count"]
      newTab.item = {}
      for m = 1, 3 do
        if v["Reward Type " .. m] then
          table.insert(newTab.item, {
            id = v["Reward ID " .. m],
            type = v["Reward Type " .. m],
            amount = v["Reward Amount " .. m]
          })
        end
      end
      table.insert(v.Difficulty and v.Difficulty == 1 and normalTab or eliteTab, newTab)
    end
  end
  self.StageStarData = {normal = normalTab, elite = eliteTab}
  local StageStarBox = CCLayer:create()
  self.ui.StageStarBox = StageStarBox
  chestBg:addChild(StageStarBox, 99)
  self.ui.chestBg = chestBg
  self.ui.chestProgress = progress
end

class.createStarChestPro = createStarChestPro

local function upDataStarChestPro(self, chapter)
  if not self.ui.StageStarBox then
    return
  end
  self.longChapter = chapter
  local chapterStar = self.newChapterStar or 0
  local chapterStarIds = ed.player:getChapterStarIds()
  self.ui.StageStarBox:removeAllChildrenWithCleanup(true)
  if self.stageStarImg then
    local res = self.mode == "elite" and "worldmap_star_hard" or "worldmap_star_normal"
    ed.initSpriteWithFrame(self.stageStarImg, "UI/alpha/1080P/campaign/worldmap/" .. res .. ".png")
  end
  local data = self.StageStarData[self.mode]
  if not data then
    self.ui.chestBg:setVisible(false)
    return
  else
    self.ui.chestBg:setVisible(true)
  end
  local starMax = 0
  local newStar = {}
  for i, v in ipairs(data) do
    if chapter == v.chapterId then
      starMax = starMax < v.StarNum and v.StarNum or starMax
      table.insert(newStar, v)
    end
  end
  table.sort(newStar, function(a, b)
    return a.StarNum < b.StarNum
  end)
  local scales = chapterStar / starMax
  scales = 1 < scales and 1 or scales
  self.ui.chestProgress:setVisible(0 < chapterStar)
  self.ui.chestProgress:setContentSize(CCSizeMake(273.5 * scales, 11))
  self.ui.starChestLab:setString(chapterStar)
  self.ui.starChestMaxLab:setString("/" .. starMax)
  self.starUi = {}
  local par = 255 / starMax
  local starUi = {}
  local ui_info = res.StageStar_ui_info
  local readNode
  self.starTipBg = nil
  for i, v in ipairs(newStar) do
    readNode = ed.readnode.create(self.ui.StageStarBox, starUi)
    readNode:addNode(ui_info)
    starUi.img_light:setVisible(false)
    if ed.isElementInTable(v.id, chapterStarIds) then
      ed.initSpriteWithFrame(starUi.img_chest, "UI/alpha/1080P/campaign/main/campaign_chest_1.png")
    elseif chapterStar >= v.StarNum then
      starUi.img_light:setVisible(true)
      starUi.img_light:runAction(CCRepeatForever:create(CCRotateBy:create(5, 360)))
      
      local function funcAction(icon, isOne)
        icon:runAction(CCSequence:create(ccArrayMake(unpack({
          CCDelayTime:create(isOne and i * 0.2 or 3),
          CCCallFunc:create(function()
            icon:stopAllActions()
            icon:runAction(CCSequence:create(ccArrayMake(unpack({
              CCEaseBackIn:create(CCRotateBy:create(0.18, -10)),
              CCRotateBy:create(0.12, 20),
              CCRotateBy:create(0.11, -20),
              CCRotateBy:create(0.1, 15),
              CCRotateBy:create(0.09, -10),
              CCEaseBackOut:create(CCRotateBy:create(0.15, 5))
            }))))
            local posx, posy = icon:getPosition()
            icon:runAction(CCSequence:create(ccArrayMake(unpack({
              CCMoveTo:create(0.55, ccp(posx, posy + 2)),
              CCMoveTo:create(0.2, ccp(posx, posy))
            }))))
            funcAction(icon)
          end)
        }))))
      end
      
      funcAction(starUi.img_chest, true)
    end
    starUi.star_box:setPosition(110 + par * v.StarNum, -11)
    starUi.label_chest:setString(v.StarNum)
    self.starUi[i] = starUi
    if i == 1 then
      local tipBg = ed.createScale9Sprite("UI/alpha/1080P/common/main_vit_tips.png", CCRectMake(6, 6, 6, 6))
      tipBg:setContentSize(CCSizeMake(75, 150))
      tipBg:setAnchorPoint(ccp(0, 0))
      tipBg:setPosition(ccp(105 + par * v.StarNum, 50))
      tipBg:setVisible(false)
      self.ui.StageStarBox:addChild(tipBg, 30)
      self.starTipBg = tipBg
    end
    self:btRegisterButtonClick({
      param = {
        item = v.item,
        id = v.id,
        isPass = starUi.img_light:isVisible(),
        posX = 105 + par * v.StarNum
      },
      button = starUi.img_chest,
      key = "img_chest_" .. i,
      pressHandler = function(param, x, y)
        if param.isPass then
          self:sendStageStarReward(param.id, chapter)
        else
          self.starTipBg:setVisible(true)
          self.starTipBg:setPositionX(param.posX)
          for i, v in ipairs(self.starTipBg.icon or {}) do
            v:removeFromParentAndCleanup(true)
          end
          self.starTipBg.icon = {}
          local totalItemHeight = 5
          local itemSpaceY = -3
          for i, v in ipairs(param.item) do
            local icon, label = ed.createItemIcon(v, true)
            if icon.amountLabel then
              icon.amountLabel:limitWidthByScale(70 * icon:getScaleX())
              icon.amountLabel:setScale(icon.amountLabel:getScaleX() / icon:getScaleX())
            end
            label:limitSizeByScale(75 / icon:getScaleX())
            local labelHeight = label:getContentSize().height * label:getScaleX()
            label:setPositionY(-labelHeight * 0.5 + 5)
            labelHeight = labelHeight * icon:getScaleX()
            local iconHeight = icon:getContentSize().height * icon:getScaleX()
            icon:setPosition(37.5, totalItemHeight + labelHeight + iconHeight * 0.5)
            self.starTipBg:addChild(icon)
            self.starTipBg.icon[i] = icon
            totalItemHeight = totalItemHeight + (iconHeight + labelHeight) + itemSpaceY
          end
          if #param.item > 0 then
            totalItemHeight = totalItemHeight - itemSpaceY
          end
          totalItemHeight = totalItemHeight + 5
          self.starTipBg:setContentSize(CCSizeMake(75, totalItemHeight))
        end
      end,
      cancelPressHandler = function()
        if self.starTipBg then
          self.starTipBg:setVisible(false)
        end
      end,
      pressScale = 0.96,
      force = true,
      mcpMode = true
    })
  end
end

class.upDataStarChestPro = upDataStarChestPro

function class:sendStageStarReward(starId, chapter)
  self:eventStageStarReward(starId, chapter)
  local msg = ed.upmsg.stage_star_reward()
  msg._star_id = starId
  ed.send(msg, "stage_star_reward")
end

function class:eventStageStarReward(starId, chapter)
  ListenEventOnce("stageStarRewardFire", function(data)
    if data._result == "success" then
      ed.player:setChapterStarIds(starId)
      if data._rewards and #data._rewards > 0 then
        ed.UITool.showRewardsFromServer(data._rewards)
        ed.player:addRewards(data._rewards)
      end
      if self.longChapter == chapter and self.thisSceneOpen then
        self:upDataStarChestPro(chapter)
      end
      local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
      FireEvent("MainBuildRedTagChange", BuilddingType.Chapter)
    else
      ed.showToast(T("\233\162\134\229\143\150\229\164\177\232\180\165"))
    end
  end)
end

local normalModeButtonRes = {
  normal = {normal = "", press = ""},
  elite = {normal = "", press = ""},
  guild = {normal = "", press = ""},
  challenge = {normal = "", press = ""}
}
class.normalModeButtonRes = normalModeButtonRes
local selectModeButtonRes = {
  normal = {normal = "", press = ""},
  select = {normal = "", press = ""}
}
class.selectModeButtonRes = selectModeButtonRes

local function createModeButton(self)
  local modeContainer = CCSprite:create()
  self.modeContainer = modeContainer
  self.mainLayer:addChild(modeContainer, 20)
  self.modeContainer:setPosition(-72 - ed.display.halfFixedWidth, 0)
  ed.layout.layoutWithMagin(self.modeContainer, {top = 424})
  self.modeui = {}
  local ui = self.modeui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "normal_button",
        res = "UI/alpha/1080P/campaign/main/campaign_difficulty_normal_1.png"
      },
      layout = {
        position = ccp(500, 385)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        parent = "normal_button",
        name = "label_normal_1",
        text = T("\230\153\174\233\128\154"),
        size = 15
      },
      layout = {
        position = ccp(30, 22)
      },
      config = {
        color = ed.toccc3(12758429),
        stroke = {
          color = ed.toccc3(2565412),
          size = 1
        }
      }
    },
    {
      t = "Sprite",
      base = {
        parent = "normal_button",
        name = "normal_button_red",
        res = "UI/alpha/1080P/common/digit_red_tag_bg.png"
      },
      layout = {
        position = ccp(47.5, 53)
      },
      config = {
        fix_scale = {y = 1, x = 1},
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "normal_button_press",
        res = "UI/alpha/1080P/campaign/main/campaign_difficulty_normal_2.png"
      },
      layout = {
        position = ccp(500, 385)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        parent = "normal_button_press",
        name = "label_normal_2",
        text = T("\230\153\174\233\128\154"),
        size = 15
      },
      layout = {
        position = ccp(30, 22)
      },
      config = {
        color = ed.toccc3(16772503),
        stroke = {
          color = ed.toccc3(9128457),
          size = 1
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "normal",
        res = class.normalModeButtonRes.normal.normal
      },
      layout = {
        position = ccp(500, 385)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "normal_press",
        res = class.normalModeButtonRes.normal.press
      },
      layout = {
        position = ccp(500, 385)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "elite_button",
        res = "UI/alpha/1080P/campaign/main/campaign_difficulty_hard_1.png"
      },
      layout = {
        position = ccp(560, 385)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        parent = "elite_button",
        name = "label_hard_1",
        text = T("\231\178\190\232\139\177"),
        size = 15
      },
      layout = {
        position = ccp(30, 22)
      },
      config = {
        color = ed.toccc3(12758429),
        stroke = {
          color = ed.toccc3(2565412),
          size = 1
        }
      }
    },
    {
      t = "Sprite",
      base = {
        parent = "elite_button",
        name = "elite_button_red",
        res = "UI/alpha/1080P/common/digit_red_tag_bg.png"
      },
      layout = {
        position = ccp(47.5, 53)
      },
      config = {
        fix_scale = {y = 1, x = 1},
        visible = false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "elite_button_press",
        res = "UI/alpha/1080P/campaign/main/campaign_difficulty_hard_2.png"
      },
      layout = {
        position = ccp(560, 385)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        parent = "elite_button_press",
        name = "label_hard_2",
        text = T("\231\178\190\232\139\177"),
        size = 15
      },
      layout = {
        position = ccp(30, 22)
      },
      config = {
        color = ed.toccc3(16772503),
        stroke = {
          color = ed.toccc3(9128457),
          size = 1
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "elite",
        res = class.normalModeButtonRes.elite.normal
      },
      layout = {
        position = ccp(560, 385)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "elite_press",
        res = class.normalModeButtonRes.elite.press
      },
      layout = {
        position = ccp(560, 385)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(modeContainer, ui)
  readNode:addNode(ui_info)
end

class.createModeButton = createModeButton

local function getTitleAndBGRes(self, chapter)
  local chapterName = ed.getDataTable("Chapter")[chapter]["Chapter Name"] or ""
  local title = T("\231\172\172%s\231\171\160 %s", ed.numberToChinese(chapter), chapterName)
  if self.mode == "normal" then
    return title, "UI/alpha/1080P/campaign/main/campaign_title_normal_bg.png"
  else
    return title, "UI/alpha/1080P/campaign/main/campaign_title_hard_bg.png"
  end
end

class.getTitleAndBGRes = getTitleAndBGRes

local function createTitle(self, chapter)
  local preTitle
  if not tolua.isnull(self.titleContainer) then
    if not tolua.isnull(self.preTitle) then
      self.preTitle:removeFromParentAndCleanup(true)
    end
    preTitle = self.titleContainer
    self.preTitle = preTitle
  end
  local titleui = {}
  local titleContainer = CCSprite:create()
  self.titleContainer = titleContainer
  titleContainer:setCascadeOpacityEnabled(true)
  self.mainLayer:addChild(titleContainer, 10)
  local titleText, resBg, hasDiffcult = self:getTitleAndBGRes(chapter)
  if not self.titleBg then
    local titleBg = ed.createSprite(resBg)
    self.titleBg = titleBg
    self.mainLayer:addChild(titleBg, 9)
    local titleBg2 = ed.createSprite("UI/alpha/1080P/campaign/main/campaign_title_hard.png")
    titleBg2:setPosition(ccp(195, 23))
    titleBg:addChild(titleBg2)
    self.titleBg.bar = titleBg2
  else
    ed.initSpriteWithFrame(self.titleBg, resBg)
  end
  self.titleBg.bar:setVisible(self.mode ~= "normal")
  local title = ed.createttf(titleText, 30)
  if self.mode == "normal" then
    ed.setLabelColor(title, ed.toccc3(16775353))
    ed.setLabelStroke(title, ed.toccc3(4533012), 1.5)
  else
    local titleTextBg = ed.createSprite("UI/alpha/1080P/campaign/main/chaptername_hard_bg.png")
    titleContainer:addChild(titleTextBg)
    titleTextBg:setPosition(ccp(185, hasDiffcult and 5 or 0))
    ed.setLabelColor(title, ed.toccc3(16776657))
    ed.setLabelStroke(title, ed.toccc3(13394435), 1)
  end
  title:setFontName(ed.fontBold)
  title:limitWidthByScale(280)
  titleui.title = title
  title:setPosition(ccp(185, hasDiffcult and 5 or 0))
  titleContainer:addChild(title)
  self.titleui = titleui
  ed.layout.layoutWithMagin(self.titleBg, {left = 50, top = 15})
  ed.layout.layoutWithMagin(titleContainer, {left = 60, top = 38})
  if preTitle then
    titleContainer:setOpacity(0)
    local fadeout = CCFadeOut:create(0.2)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(titleContainer) then
          local fadein = CCFadeIn:create(0.2)
          titleContainer:runAction(fadein)
        end
        if not tolua.isnull(preTitle) then
          preTitle:removeFromParentAndCleanup(true)
          self.preTitle = nil
        end
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(fadeout, func)
    preTitle:runAction(sequence)
  end
end

class.createTitle = createTitle

local function refreshBuff(self)
  local buffMgr = ed.activityBuffMgr.getInstance()
  local buffType, extraTypeList
  if self.mode == "normal" then
    buffType = {
      "normal_stage_item_multi",
      "spar_stage_item_multi"
    }
  elseif self.mode == "elite" then
    buffType = {
      "elite_stage_item_multi",
      "spar_stage_item_multi"
    }
    extraTypeList = {
      "elite_stage_item_multi"
    }
  end
  local param = {
    buffIdList = buffMgr:getbuffByType(buffType),
    extraTypeList = extraTypeList,
    column = 5
  }
  if not self.buffTipsPanel then
    self.buffTipsPanel = ed.buffTipsPanel.create(param)
    self.mainLayer:addChild(self.buffTipsPanel.container)
    ed.layout.layoutWithMagin(self.buffTipsPanel.container, {left = 140, top = 90})
  else
    self.buffTipsPanel:refreshPanel(param)
  end
end

class.refreshBuff = refreshBuff

local function createFrame(self, chapter, mode)
  local preFrame
  if not tolua.isnull(self.frameContainer) then
    preFrame = self.frameContainer
    preFrame:setZOrder(6)
  end
end

class.createFrame = createFrame

local function getStageRes(info, tag, mode, chapter)
  local stageRes = res.stageRes
  local keyStageRes = res.keyStageRes
  local id = info.id
  local eid = info.eid or 0
  local resid = info.resid or id
  local guildInstanceId = info.guildInstanceId
  local challengeInstanceId = info.challengeInstanceId or {}
  local stageInfo = ed.getDataTable("Stage")
  local iskey = stageInfo[id]["Key Stage"]
  
  local function stageState(stageidList, stageidFrontList)
    local function notGetStar(list)
      for k, v in pairs(list) do
        if ed.player:getStageStar(v) > 0 then
          return false
        end
      end
      return true
    end
    
    local function isFirstStageOfChapter(list)
      local stageType = ""
      for k, v in pairs(list) do
        stageType = ed.getDataTable("Stage")[v]["Requirement Type 2"]
        if stageType == "FirstStage" then
          break
        end
      end
      return stageType
    end
    
    if iskey then
      if isFirstStageOfChapter(stageidList) == "FirstStage" then
        return "current", string.format(keyStageRes.icon.current, resid), string.format(keyStageRes.mask.current, resid)
      elseif 1 < id and notGetStar(stageidList) and notGetStar(stageidFrontList) then
        return "locked", string.format(keyStageRes.icon.locked, resid)
      elseif notGetStar(stageidList) then
        return "current", string.format(keyStageRes.icon.current, resid), string.format(keyStageRes.mask.current, resid)
      else
        return "passed", string.format(keyStageRes.icon.passed, resid), string.format(keyStageRes.mask.passed, resid)
      end
    elseif mode == "normal" then
      if 1 < id and notGetStar(stageidList) and notGetStar(stageidFrontList) then
        return "locked", string.format(stageRes.locked, tag)
      elseif notGetStar(stageidList) then
        return "current", stageRes.current
      else
        return "passed", stageRes.passed
      end
    else
      return "locked", stageRes.elite
    end
  end
  
  if mode == "elite" then
    return stageState({eid}, {
      eid - 1
    })
  elseif mode == "challenge" then
    local challengeInstanceIdFront = {}
    for k, v in pairs(challengeInstanceId) do
      challengeInstanceIdFront[k] = v - 1
    end
    return stageState(challengeInstanceId, challengeInstanceIdFront)
  elseif mode == "normal" then
    return stageState({id}, {
      id - 1
    })
  else
    local raidInfo, id = ed.ui.guild.getInstanceInfo(chapter)
    if iskey then
      if raidInfo == nil or guildInstanceId > raidInfo.stageId then
        return "locked", string.format(keyStageRes.icon.locked, resid)
      elseif guildInstanceId == raidInfo.stageId and raidInfo.RaidProgress ~= ed.GuildRaidConfig.MaxStageProgress then
        return "current", string.format(keyStageRes.icon.passed, resid), string.format(keyStageRes.mask.passed, resid)
      else
        return "passed", string.format(keyStageRes.icon.passed, resid), string.format(keyStageRes.mask.passed, resid)
      end
    else
      return "locked", stageRes.elite
    end
  end
end

class.getStageRes = getStageRes

local function getEliteStageLeftTimes(self, eId)
  local stageTable = ed.getDataTable("Stage")
  local row = stageTable[eId]
  local s = ed.elite2NormalStage(eId)
  local count = (row["Daily Limit"] or 999) - ((ed.player.stage_limit or {})[s] or 0)
  local limit = ed.parameter.default_elite_sweep_times
  limit = math.min(count, limit)
  return limit
end

class.getEliteStageLeftTimes = getEliteStageLeftTimes

local function createStage(self, chapter, mode, skipAnim)
  local function getRewardInformation(stage)
    local info = {}
    
    local row = ed.getDataTable("Stage")[stage]
    local ids = {}
    local cnts = {}
    local index = 0
    for i = 1, 20 do
      local tn = "UI reward" .. i
      local reward = row[tn]
      if reward then
        index = index + 1
        ids[index] = reward
      end
    end
    for i, v in ipairs(ids) do
      if v ~= 0 then
        local row = ed.getDataTable("equip")[v]
        if row then
          local category = row.Category
          if category == T("\231\129\181\233\173\130\231\159\179") then
            return v
          end
        end
      end
    end
    return 0
  end
  
  local stageContainer = CCSprite:create()
  self.stageContainer = stageContainer
  stageContainer:setCascadeOpacityEnabled(true)
  local info = self:getResMap(chapter)
  if self.currentTag then
    self.currentTag:removeFromParentAndCleanup(true)
    self.currentTag = nil
  end
  self.newChapterStar = 0
  local stageIcon = {}
  local stageMask = {}
  for i = 1, #info.stage do
    local t = info.stage[i]
    local type, iconRes, iconMask = self.getStageRes(t, info.tag, mode, chapter)
    local z = t.z or 0
    local pos = ccp(t.pos.x, t.pos.y)
    if iconMask then
      local mask = ed.createSprite(iconMask)
      mask:setPosition(pos)
      mask:setScale(1)
      stageMask[t.id] = mask
      stageContainer:addChild(mask)
      local action = CCFadeTo:create(1, 0)
      local reverse = CCFadeTo:create(1, 255)
      local sequence = CCSequence:createWithTwoActions(action, reverse)
      mask:runAction(CCRepeatForever:create(sequence))
    end
    local icon = ed.createSprite(iconRes)
    icon:setPosition(pos)
    stageContainer:addChild(icon, z)
    local spos = {
      {
        ccp(37, 15)
      },
      {
        ccp(26, 18),
        ccp(48, 18)
      },
      {
        ccp(17, 18),
        ccp(37, 15),
        ccp(57, 18)
      }
    }
    local stars = {}
    local starBg, spiritStone
    local res = mode == "elite" and "worldmap_star_hard" or "worldmap_star_normal"
    if mode ~= "guild" then
      local id = mode == "elite" and t.eid or t.id
      local sn = ed.player:getStageStar(id)
      if self.mode == "challenge" then
        local stars = 0
        for k, v in pairs(t.challengeInstanceId or {}) do
          if 0 < ed.player:getStageStar(v) then
            stars = stars + 1
          end
        end
        sn = stars
      end
      local itemId = getRewardInformation(mode == "elite" and t.eid or t.id)
      if itemId and itemId ~= 0 and t.eid then
        spiritStone = ed.createScale9Sprite("UI/alpha/1080P/campaign/main/campaign_stage_soulstone.png", CCRectMake(22.5, 15, 15, 17.5))
        spiritStone:setContentSize(CCSizeMake(62, 65.5))
        spiritStone:setPosition(ccp(154, 146))
        icon:addChild(spiritStone)
        spiritStone:setScale(1)
        spiritStone:setCascadeOpacityEnabled(true)
        local item = ed.createItemIcon({
          id = itemId,
          type = "item",
          amount = 1
        })
        spiritStone:addChild(item)
        item:setScale(0.55)
        item:setPosition(31.5, 36)
        local heroId = ed.readhero.getMakeid(itemId)
        local hero = ed.player.heroes[heroId]
        if hero and hero._stars >= 5 then
          local stoneFull = ed.createSprite("UI/alpha/1080P/campaign/main/campaign_stage_soulstone_full.png")
          stoneFull:setPosition(45, 55)
          spiritStone:addChild(stoneFull)
        end
        if 0 >= self:getEliteStageLeftTimes(t.eid) then
          local commonMark = ed.createSprite("UI/alpha/1080P/common/common_mark.png")
          commonMark:setPosition(47, 22)
          commonMark:setScale(0.55)
          spiritStone:addChild(commonMark)
        end
      end
      if 0 < sn and t.eid then
        starBg = ed.createSprite("UI/alpha/1080P/campaign/campaign_star_bg.png")
        starBg:setPosition(ccp(104, 40))
        icon:setCascadeOpacityEnabled(true)
        icon:addChild(starBg)
        starBg:setCascadeOpacityEnabled(true)
        starBg:setScale(1.3)
        for i = 1, sn do
          local star = ed.createSprite("UI/alpha/1080P/campaign/worldmap/" .. res .. ".png")
          star:setPosition(spos[sn][i].x - 4, spos[sn][i].y - 5)
          starBg:addChild(star)
          stars[i] = star
        end
        self.newChapterStar = self.newChapterStar + sn
      end
    end
    table.insert(stageIcon, {
      icon = icon,
      id = t.id,
      eid = t.eid,
      guildInstanceId = t.guildInstanceId,
      challengeInstanceId = t.challengeInstanceId,
      type = type,
      pos = pos,
      stars = stars,
      starBg = starBg
    })
    if type == "current" then
      self.currentStageIcon = icon
      if self.isElite and 0 < (ed.player:getStageStar(t.id) or 0) or not self.isElite then
        local currentTag = ed.createSprite("UI/alpha/1080P/campaign/main/campaign_stage_arrow.png")
        local cpos
        if t.eid then
          cpos = ccp(pos.x, pos.y + 80)
        else
          cpos = ccp(pos.x - 1, pos.y + 50)
        end
        currentTag:setPosition(cpos)
        self.mainLayer:addChild(currentTag, 50)
        local move = CCMoveTo:create(0.5, ccp(cpos.x, cpos.y + 10))
        local back = CCMoveTo:create(0.5, cpos)
        local sequence = CCSequence:createWithTwoActions(move, back)
        currentTag:runAction(CCRepeatForever:create(sequence))
        self.currentTag = currentTag
        if self.forGetWay or self.showTutorial then
          currentTag:setVisible(false)
        end
        if self.mode == "challenge" then
          currentTag:setVisible(false)
        end
      end
    end
  end
  if self.puppet then
    self.puppet:removeFromParentAndCleanup(true)
    self.puppet = nil
  end
  if info.lootStage and info.lootStage.show() and mode == "elite" then
    local uidKey = ed.getRoleKey("lootStage")
    if not ed.storage.getBool(uidKey) then
      ed.showToast(T("\231\165\158\231\167\152\229\133\179\229\141\161\229\183\178\231\187\143\229\135\186\231\142\176\239\188\140\233\152\159\233\149\191\229\164\167\229\164\167\229\191\171\229\142\187\232\142\183\229\190\151\229\191\131\230\132\191\231\129\181\233\173\130\231\159\179\229\144\167"))
      ed.storage.setValue(uidKey, true)
    end
    local puppet = self:createLootStageIcon(info.lootStage)
    stageContainer:addChild(puppet, info.lootStage.z)
    self.puppet = puppet
  else
    self.lootStageInfo = nil
  end
  self.stageIcon = stageIcon
  self.stageMask = stageMask
  self.mapContainer:addChild(stageContainer, 15)
end

class.createStage = createStage

local function createLootStageIcon(self, lootStage)
  local puppet, cha = ed.readhero.getActor(lootStage.bossId, "Idle", true, false, nil, false)
  puppet:setPosition(lootStage.pos)
  puppet:setScale(0.5)
  self:addFca(puppet)
  local particle = CCParticleSystemQuad:create("UI/particle/xingxing.plist")
  puppet:addChild(particle, -1)
  particle:setEmissionRate(999)
  particle:setPosition(-30, 50)
  local particle = CCParticleSystemQuad:create("UI/particle/xingxing.plist")
  puppet:addChild(particle, -1)
  particle:setEmissionRate(999)
  particle:setPosition(30, 50)
  local particle = CCParticleSystemQuad:create("UI/particle/xingxing.plist")
  puppet:addChild(particle, -1)
  particle:setEmissionRate(999)
  particle:setPosition(0, 20)
  local nullImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/campaign/selectsoul_4.png",
    pos = ccp(100, 160),
    parent = puppet,
    scale = 1.6
  })
  local addImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/add_big.png",
    pos = ccp(34, 37),
    parent = nullImg
  })
  addImg:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(1.5, 50), CCFadeTo:create(1, 255))))
  local selectedImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/campaign/main/campaign_stage_soulstone.png",
    pos = ccp(110, 160),
    parent = puppet,
    scale = 2,
    rectMake = CCRectMake(22.5, 15, 15, 17.5),
    sizeMake = CCSizeMake(62, 65.5)
  })
  ed.createSpriteTools({
    res = "UI/alpha/1080P/shop/shop_gold_exchange_button.png",
    pos = ccp(53, 53),
    parent = selectedImg,
    scale = 0.5,
    z = 99
  })
  local mark = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/common_mark.png",
    pos = ccp(47, 22),
    parent = selectedImg,
    scale = 0.55,
    z = 99,
    notShow = true
  })
  local stageItemId, item
  for i, v in ipairs(ed.player:getStageSelectReward() or {}) do
    if v._stage_id == lootStage.eid then
      stageItemId = v._reward_id
      break
    end
  end
  local redImg = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
    pos = ccp(62, 202),
    parent = puppet,
    scale = 2,
    z = 99
  })
  redImg:setVisible(ed.ui.stageselectres.getLootStagesNewRedShow(lootStage.eid))
  if stageItemId then
    nullImg:setVisible(false)
    item = ed.createItemIcon({
      id = stageItemId,
      type = "item",
      amount = 1
    })
    selectedImg:addChild(item)
    item:setScale(0.55)
    item:setPosition(31.5, 36)
    mark:setVisible(0 >= self:getEliteStageLeftTimes(lootStage.eid))
    local stoneFull = ed.createSpriteTools({
      res = "UI/alpha/1080P/campaign/main/campaign_stage_soulstone_full.png",
      pos = ccp(45, 55),
      parent = selectedImg,
      z = 89,
      notShow = true
    })
    local heroId = ed.readhero.getMakeid(stageItemId)
    local hero = ed.player.heroes[heroId]
    stoneFull:setVisible(hero and hero._stars >= 5)
  else
    selectedImg:setVisible(false)
  end
  self.lootStageInfo = {
    lootStage = lootStage,
    nullImg = nullImg,
    selectedImg = selectedImg,
    item = item,
    mark = mark,
    redImg = redImg
  }
  return puppet
end

class.createLootStageIcon = createLootStageIcon

local function createMap(self, chapter, mode, skipAnim)
  local preMap
  if not tolua.isnull(self.mapContainer) then
    if not tolua.isnull(self.preMap) then
      self.preMap:removeFromParentAndCleanup(true)
    end
    preMap = self.mapContainer
    preMap:setZOrder(1)
    self.preMap = preMap
  end
  if self.hideStages and #self.hideStages > 0 then
    for i = 1, #self.hideStages do
      local hideStage = self.hideStages[i]
      local stageFca = hideStage.stageFca
      local touchHandlerKey = hideStage.touchHandlerKey
      self:removeFca(stageFca)
      self:btRemoveMainTouchHandler({key = touchHandlerKey})
    end
  end
  self.circle = nil
  self.finger = nil
  local ui = {}
  local info = self:getResMap(chapter)
  local mapContainer = CCSprite:create()
  self.mapContainer = mapContainer
  mapContainer:setCascadeOpacityEnabled(true)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local clipLayer = CCLayer:create()
  mapContainer:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(0 - newWid, 0 - newHei, widhtWin, heightWin))
  local bg = ed.createSprite(info.bg.res)
  bg:setPosition(480, 270)
  clipLayer:addChild(bg)
  ui.bg = bg
  self.mapContainer.bg = bg
  local route = ed.createSprite()
  route:setPosition(480, 270)
  mapContainer:addChild(route)
  ui.route = route
  self.mapui = ui
  self.clipLayer:addChild(self.mapContainer)
  self:createStage(chapter, mode, skipAnim)
  if self.mapActionFun then
    self.mapActionFun(bg, route, self.stageContainer)
  end
  self.mapActionFun = nil
  self:upDataStarChestPro(chapter)
  if preMap then
    local winSize = ed.display.winSize
    if not skipAnim then
      local action, showDotAnim
      if self.lastOperation == "changeChapter" then
        action = CCFadeOut:create(0.5)
        local come = CCFadeTo:create(change_chapter_gap, 255)
        mapContainer:setOpacity(0)
        mapContainer:runAction(come)
        mapContainer.bg:setOpacity(0)
        mapContainer.bg:runAction(CCFadeIn:create(0.5))
        preMap:stopAllActions()
        preMap.bg:runAction(CCFadeOut:create(0.5))
      elseif self.lastOperation == "changeMode" then
        action = CCFadeOut:create(0.3)
        local come = CCFadeTo:create(change_chapter_gap, 255)
        mapContainer:setOpacity(0)
        mapContainer:runAction(come)
        mapContainer.bg:setOpacity(0)
        mapContainer.bg:runAction(CCFadeIn:create(0.3))
        preMap:stopAllActions()
        preMap.bg:runAction(CCFadeOut:create(0.3))
        self:refreshDot(true)
      end
      local func = CCCallFunc:create(function()
        xpcall(function()
          if not tolua.isnull(preMap) then
            preMap:removeFromParentAndCleanup(true)
            if not showDotAnim then
              self:refreshDot()
            end
            self.preMap = nil
          end
        end, EDDebug)
      end)
      preMap.bg:runAction(action)
      local sequence = CCSequence:createWithTwoActions(action, func)
      preMap:runAction(sequence)
    else
      preMap:removeFromParentAndCleanup(true)
    end
  end
  updateGuildInstanceButton(self)
end

class.createMap = createMap

local function getNormalInformation(self)
  local normalInfo = {}
  normalInfo.progress = self:getNormalProgress()
  normalInfo.chapter = math.min(self:getMaxNormalChapter(), ed.playerlimit.maxChapter("normal"))
  normalInfo.maxChapter = self:getMaxNormalChapter()
  if ed.guildStageStar and ed.guildStageStar[2] == 0 then
    local star = ed.player:getStageStar(ed.guildStageStar[1]) or 0
    if 0 < star then
      FireEvent(ed.guide.eventNames.COMPLETE_STAGE, ed.guildStageStar[1])
      ed.guildStageStar[2] = star
    end
  end
  self.normalInfo = normalInfo
end

class.getNormalInformation = getNormalInformation

local function getEliteInformation(self)
  local eliteInfo = {}
  eliteInfo.progress = self:getEliteProgress()
  local stageInfo = ed.getDataTable("Stage")
  eliteInfo.chapter = math.min(self:getMaxEliteChapter(), ed.playerlimit.maxChapter("elite"))
  eliteInfo.maxChapter = self:getMaxEliteChapter()
  self.eliteInfo = eliteInfo
end

class.getEliteInformation = getEliteInformation

local function getGuildInfomation(self)
  local guildInfo = {}
  guildInfo.chapter = self:getMinGuildInstanceChapter()
  guildInfo.maxChapter = self:getMaxGuildInstanceChapter()
  self.guildInfo = guildInfo
end

class.getGuildInfomation = getGuildInfomation

local function getChallengeInfomation(self)
  local challengeInfo = {}
  challengeInfo.progress = self:getChallengeProgress()
  challengeInfo.chapter = math.min(self:getMaxChallengeChapter(), ed.playerlimit.maxChapter())
  challengeInfo.maxChapter = self:getMaxChallengeChapter()
  self.challengeInfo = challengeInfo
end

class.getChallengeInfomation = getChallengeInfomation

local function getInformation(self)
  self:getNormalInformation()
  self:getEliteInformation()
  self:getGuildInfomation()
  self:getChallengeInfomation()
end

class.getInformation = getInformation

local function onEnterHandler(self)
  self.intoStageDetail = false
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
  local preNormal, preElite, preGuildInstance, preChallenge
  self.eliteInfo.chapter = self.normalInfo.chapter
  local preNormalChapter = self.normalInfo.chapter
  local preEliteChapter = self.eliteInfo.chapter
  local preChallengeChapter = self.challengeInfo.chapter
  local preMaxChapter
  if self.mode == "elite" then
    if self.eliteInfo then
      preElite = self.eliteInfo.progress
      preMaxChapter = self.eliteInfo.maxChapter
    end
  elseif self.mode == "normal" then
    if self.normalInfo then
      preNormal = self.normalInfo.progress
      preMaxChapter = self.normalInfo.maxChapter
    end
  elseif self.mode == "challenge" then
    if self.challengeInfo then
      preChallenge = self.challengeInfo.progress
      preMaxChapter = self.challengeInfo.maxChapter
    end
  else
    self:createMap(self.guildInfo.chapter, "guild", true)
  end
  if preNormal or preElite or preChallenge then
    self:getInformation()
    if preNormalChapter then
      self.normalInfo.chapter = preNormalChapter
    end
    if preEliteChapter then
      self.eliteInfo.chapter = preEliteChapter
    end
    if preChallengeChapter then
      self.challengeInfo.chapter = preChallengeChapter
    end
    
    local function setPreMode(preNormal, preMaxChapter, mode, modeInfo, maxModeChapter)
      if preNormal and preNormal ~= modeInfo.progress then
        if preMaxChapter ~= modeInfo.maxChapter and maxModeChapter <= ed.playerlimit.maxChapter(self.mode) then
          modeInfo.chapter = modeInfo.maxChapter
          self.normalInfo.chapter = modeInfo.maxChapter
          self.eliteInfo.chapter = modeInfo.maxChapter
          self:createMap(modeInfo.maxChapter, mode, true)
          self:createTitle(modeInfo.maxChapter)
          self:refreshDot()
        else
          self:createMap(modeInfo.chapter, mode, true)
        end
      elseif preNormal then
        self:createMap(modeInfo.chapter, mode, true)
      end
    end
    
    setPreMode(preNormal, preMaxChapter, "normal", self.normalInfo, self:getMaxNormalChapter())
    setPreMode(preElite, preMaxChapter, "elite", self.eliteInfo, self:getMaxEliteChapter())
    setPreMode(preChallenge, preMaxChapter, "challenge", self.challengeInfo, self:getMaxChallengeChapter())
  end
  self:setChapterButtonState()
  if ed.playerlimit.checkAreaUnlock("Elite") then
    self.modeui.normal:setVisible(true)
    self.modeui.normal_button:setVisible(true)
    self.modeui.elite:setVisible(true)
    self.modeui.elite_button:setVisible(true)
    updateGuildInstanceButton(self)
    updateModeButtonState(self)
  else
    self.modeui.normal_button:setVisible(false)
    self.modeui.normal:setVisible(false)
    self.modeui.elite:setVisible(false)
    self.modeui.elite_button:setVisible(false)
  end
  return handler
end

class.onEnterHandler = onEnterHandler

local function getGuildInstanceChapter(self)
  local min = self.guildInfo.chapter
  local max = self.guildInfo.maxChapter
  local st = ed.getDataTable("Stage")
  local progress = ed.player:getStageProgress()
  local maxChapter = st[progress]["Chapter ID"]
  for i = max, min, -1 do
    local id = ed.ui.guild.getInstanceInfo(i)
    if id and i <= maxChapter then
      self.guildInfo.chapter = i
      return
    end
  end
end

class.getGuildInstanceChapter = getGuildInstanceChapter

local function setOpenStageData(data)
  local challenge = data._challenge_reply or {}
  openChallengeData = challenge._challenge_id or {}
  ed.netreply.getChallengeInfomation()
  FireEvent("MainRedTagChange", ed.ui.configs.mainButton.ButtonType.TASK)
  if data._guild_quests then
    ed.offlinequest.offline_mgr:initQuestShow(data)
  end
end

class.setOpenStageData = setOpenStageData

local function updateStageInfo(self)
  if self.getWayStage then
    self.getWayStage = nil
    self.getWayMode = nil
    self.forGetWay = nil
  end
end

ed.UITool.registViewOpenFunc("stageSelect", function()
  lsr:report("clickpve")
  ed.pushScene(ed.ui.stageselect.create())
end)

local function create(chapter, mode, stage)
  local identity
  if stage then
    identity = "stageSelectGWMode"
  else
    identity = "stageSelect"
  end
  local self = base.create(identity, ed.stageSelectParam)
  setmetatable(self, class.mt)
  self:getInformation()
  if not chapter then
    if mode == "elite" then
      chapter = self.eliteInfo.chapter
      self.normalInfo.chapter = chapter
    else
      chapter = self.normalInfo.chapter
    end
  else
    self.normalInfo.chapter = chapter
    if mode == "elite" then
      self.eliteInfo.chapter = chapter
    end
  end
  local mode = mode or "normal"
  self.isElite = mode == "elite"
  self.mode = mode
  if stage then
    if self.mode ~= "guild" then
      self.getWayStage = stage
      self.getWayMode = self.isElite
      self.forGetWay = true
    end
    if mode == "elite" then
      self.eliteInfo.chapter = chapter
    elseif mode == "normal" then
      self.normalInfo.chapter = chapter
    else
      self.guildInfo.chapter = chapter
    end
  elseif mode == "elite" then
    chapter = self.eliteInfo.chapter
  elseif mode == "challenge" then
    if ed.player:getStageStar(unlocakChallengeEliteStageId) > 0 then
      chapter = self.challengeInfo.chapter
    else
      mode = "normal"
      self.mode = mode
      chapter = self.normalInfo.chapter
    end
  elseif mode == "normal" then
    chapter = self.normalInfo.chapter
  elseif mode == "guild" then
    self.guildInfo.chapter = chapter
  end
  local mainLayer = self.mainLayer
  local winSize = ed.display.winSize
  local newWid = ed.display.halfFixedWidth
  local newHei = ed.display.halfFixedHeight
  local layer = CCLayerColor:create(ccc4(255, 255, 255, 222))
  self.colorLayer = layer
  mainLayer:addChild(layer, 999)
  layer:setVisible(false)
  layer:setPosition(newWid * -1, newHei * -1)
  local clipLayer = CCLayer:create()
  self.clipLayer = clipLayer
  mainLayer:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(newWid * -1, newHei * -1, winSize.width, winSize.height))
  self:registerRefreshHandler("refreshCurrentTag", self:refreshCurrentTag())
  local campaign_bg = ed.createSprite("UI/alpha/1080P/campaign/campaign_bg.jpg")
  campaign_bg:setPosition(ccp(480, 270))
  self.mainLayer:addChild(campaign_bg, -2)
  self:createStarChestPro()
  self:createMap(chapter, mode)
  self:createFrame(chapter, mode)
  self:createTitle(chapter)
  self:createModeButton()
  self:createChapterButton()
  self:createDot()
  self:refreshBuff()
  updateModeButtonState(self)
  self:btRegisterHandler({
    handler = self:getMainTouchHandler(),
    key = "stage_select_main"
  })
  self.thisSceneOpen = true
  self.scope = self.scope or {}
  self:registerOnEnterHandler("onEnter", function()
    self.thisSceneOpen = true
    ListenEvent("ResourceNumChange", function(resType, id)
      self.resourceBox:updateResourceValue(resType, id)
    end, self.scope)
    if self.backScene then
      self:onEnterHandler()
    end
    self.backScene = true
  end)
  self:registerOnExitHandler("exit", function()
    self.thisSceneOpen = false
    CloseScope(self.scope)
    if self.buffTipsPanel then
      self.buffTipsPanel:CloseScope()
    end
  end)
  self:registerOnPopSceneHandler("onPop", function()
    CloseEvent("GuildInstanceQuery")
  end)
  ListenEvent("GuildInstanceQuery", function(stagePass)
    if stagePass == nil then
      self:getGuildInstanceChapter()
    end
    self:doChangeMode("guild")
  end)
  ListenEvent("WinBackToStageSelect", function()
    updateStageInfo(self)
  end)
  ListenEvent("FinishDailyTask", function()
    self:createEquipPropTT(true)
  end)
  ListenEvent("stageRewardReply", function(data)
    if self.puppet then
      local stageItemId, item
      for i, v in ipairs(ed.player:getStageSelectReward() or {}) do
        if v._stage_id == self.lootStageInfo.lootStage.eid then
          stageItemId = v._reward_id
          break
        end
      end
      if stageItemId then
        self.lootStageInfo.nullImg:setVisible(false)
        self.lootStageInfo.selectedImg:setVisible(true)
        item = ed.createItemIcon({
          id = stageItemId,
          type = "item",
          amount = 1
        })
        self.lootStageInfo.selectedImg:addChild(item)
        item:setScale(0.55)
        item:setPosition(31.5, 36)
        self.lootStageInfo.mark:setVisible(self:getEliteStageLeftTimes(self.lootStageInfo.lootStage.eid) <= 0)
      else
        self.lootStageInfo.nullImg:setVisible(true)
        self.lootStageInfo.selectedImg:setVisible(false)
      end
      if self.lootStageInfo.item then
        self.lootStageInfo.item:removeFromParentAndCleanup(true)
      end
      self.lootStageInfo.item = item
      local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
      FireEvent("MainBuildRedTagChange", BuilddingType.Chapter)
    end
  end, self.scope)
  ListenEvent("lootStagesNewShow", function(data)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Chapter)
    if self.lootStageInfo and data.eid == self.lootStageInfo.lootStage.eid then
      self.lootStageInfo.redImg:setVisible(false)
    end
  end, self.scope)
  updateGuildInstanceButton(self)
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:setBackground()
  self:updateModeStarRedVis()
  local lastTime = ed.player:getEliteResetTime()
  local time = ed.getServerTime()
  if ed.checkTwoDateod(lastTime, time) then
    ed.player:resetEliteRequest_type0()
  end
  return self
end

class.create = create

local function createByStage(stage)
  local chapter, mode
  local stageTable = ed.getDataTable("Stage")
  local type = ed.stageType(stage)
  if type == "normal" then
    mode = "normal"
    local row = stageTable[stage]
    chapter = row["Chapter ID"]
  elseif type == "raid" then
    mode = "guild"
    stage = stageTable[stage]["Stage Group"]
    local row = stageTable[stage]
    chapter = row["Chapter ID"]
  else
    mode = "elite"
    stage = stageTable[stage]["Stage Group"]
    local row = stageTable[stage]
    chapter = row["Chapter ID"]
  end
  local self = create(chapter, mode, stage)
  return self
end

class.createByStage = createByStage

local function refreshCurrentTag(self)
  local function handler()
    if tolua.isnull(self.currentTag) then
      return
    end
    if self.showTutorial then
      self.currentTag:setVisible(false)
    else
      self.currentTag:setVisible(true)
    end
  end
  
  return handler
end

class.refreshCurrentTag = refreshCurrentTag
ListenEvent("OpenStageReply", setOpenStageData)

local function showYunMoveWin(self)
  if self.mapui and self.mapui.bg then
    self.colorLayer:setVisible(true)
    self.colorLayer:setOpacity(222)
    self.colorLayer:runAction(CCEaseExponentialOut:create(CCFadeTo:create(4, 0)))
    
    function self.mapActionFun(bg, route, stageContainer)
      bg:setScale(0.9)
      bg:runAction(CCScaleTo:create(0.4, 1))
      route:setScale(0.9)
      route:runAction(CCScaleTo:create(0.4, 1))
      stageContainer:setPosition(50, 30)
      stageContainer:runAction(CCMoveTo:create(0.4, ccp(0, 0)))
      stageContainer:setScale(0.9)
      stageContainer:runAction(CCScaleTo:create(0.4, 1))
    end
  end
end

class.showYunMoveWin = showYunMoveWin

function class:getGuideNode(nodeKey)
  if nodeKey == "1stageIcon" then
    return self.stageIcon[1].icon
  end
  return self.modeui[nodeKey] or base.getGuideNode(self, nodeKey)
end
