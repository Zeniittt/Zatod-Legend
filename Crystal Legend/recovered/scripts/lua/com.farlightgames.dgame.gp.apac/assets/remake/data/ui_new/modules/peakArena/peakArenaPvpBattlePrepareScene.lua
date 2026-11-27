local base = ed.ui.basescene
local PeakArenaPvpBattlePrepareScene = newclass(base.mt)
ed.ui.PeakArenaPvpBattlePrepareScene = PeakArenaPvpBattlePrepareScene
local prepareData = ed.PeakArenaPvpBattlePrepareData.getInstance()
local lsr = ed.ui.battlepreparepeakarenalsr.create()
setfenv(1, require("ui_new.modules.peakArena.peakArenaPvpBattlePrepareModule"))
ed.UITool.registViewOpenFunc("PeakArenaPvpBattlePrepareScene", function(param)
  ed.pushScene(PeakArenaPvpBattlePrepareScene.create(param))
end)

function PeakArenaPvpBattlePrepareScene.create(param)
  return setmetatable(base.create("peakArenaPvpBattlePrepare"), PeakArenaPvpBattlePrepareScene.mt):init(param)
end

local enemy_label_config = {
  [2] = {
    color = ed.toccc3(3981816),
    strokeColor = ed.toccc3(2763346),
    strokeSize = 1
  },
  [1] = {
    color = ed.toccc3(16766555),
    strokeColor = ed.toccc3(7748629),
    strokeSize = 1
  },
  [3] = {
    color = ed.toccc3(15619897),
    strokeColor = ed.toccc3(4593174),
    strokeSize = 1
  },
  [4] = {
    color = ed.toccc3(15713279),
    strokeColor = ed.toccc3(8142744),
    strokeSize = 1
  },
  [5] = {
    color = ed.toccc3(10086869),
    strokeColor = ed.toccc3(3372130),
    strokeSize = 1
  }
}

function PeakArenaPvpBattlePrepareScene:init(param)
  self.param = param
  self.banedHeroIdList = self.param.baned_hero_id_list
  self.frameContainer, self.ui = battlePrepareEditorui(self.mainLayer, ed.uieditor.battlePrepareSeasonArena, self)
  self:adaptUI()
  if ed.isAreaOverSea() then
    ed.setLabelString(self.ui.Label_495, T("\230\140\135\230\140\165\229\174\152\229\164\167\228\186\186\239\188\140\232\175\183\232\174\190\231\189\174\230\130\168\231\154\132\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136\233\152\181\229\174\185\229\147\166\239\188\129"))
  end
  if param.mode == "defend" then
    self:defendInit()
    self.teamIdxInfo = param.heroes_defend
  elseif param.mode == "attack" then
    self:attackInit()
    self.teamIdxInfo = self:getTeamsData()
  else
    return self
  end
  self.canClick = true
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:getKarlElementByExistTeam()
  self:moduleInitCreate()
  self:rightWindowInit()
  self.ui.Image_select:setVisible(ed.storage.getBool("PEAKARENA_SKIP_BATTLE"))
  addPresetLayer(self)
  ed.right2(self.ui.Label_select_str, self.ui.Image_select_bg, 10)
  ed.setLabelDimensions(self.ui.Label_495, CCSizeMake(165, 0))
  ed.setLabelStroke(self.ui.label_score_des, ed.toccc3(12542248), 1)
  ed.setLabelFontName(self.ui.label_score_des, ed.fontBold)
  ed.setLabelStroke(self.ui.label_rank_des, ed.toccc3(14969387), 1)
  for i = 1, 5 do
    ed.adaptLabel(self.ui["teamBtnPassStr_" .. i], {maxWidth = 50, minScale = 0.6})
    ed.adaptLabel(self.ui["teamBtnStr_" .. i], {maxWidth = 50, minScale = 0.6})
    ed.setLabelStroke(self.ui["teamBtnPassStr_" .. i], ed.toccc3(8142744), 1)
    ed.setLabelFontName(self.ui["teamBtnPassStr_" .. i], ed.fontBold)
  end
  local enemy_label = ed.createLabelTTF(T("\230\149\140"), 18, ed.fontBold)
  local config = enemy_label_config[self.newTeamIdx] or enemy_label_config[3]
  ed.setLabelColor(enemy_label, config.color)
  ed.setLabelStroke(enemy_label, config.strokeColor, config.strokeSize)
  ed.UITool.replaceUINew(self.ui, "enemyimg", enemy_label)
  enemy_label:limitWidthByScale(30)
  ed.adaptLabel(self.ui.enemyTeamTit, {maxWidth = 70, minScale = 0.8})
  self.ui.enemyTeamTit:setHorizontalAlignment(kCCTextAlignmentCenter)
  self:rightWindowRefresh()
  self:refreshGs()
  ed.layout.horizontalSortNode({
    self.ui.toparena_star_icon_2,
    self.ui.defendTopStr,
    self.ui.defendTopName,
    self.ui.search
  }, {
    4.5,
    5,
    11.5,
    0
  }, self.ui.defendTopImg:getContentSize().width * 0.5 - 80, 0)
  return self
end

function PeakArenaPvpBattlePrepareScene:adaptUI()
  ed.adaptLabel(self.ui.Label_title_Copy0, {maxWidth = 200, minScale = 0.6})
  ed.adaptLabel(self.ui.Label_title, {maxWidth = 200, minScale = 0.6})
end

function PeakArenaPvpBattlePrepareScene:getKarlElementByExistTeam()
  self.showElement = false
  for index, teaminfo in ipairs(self.teamIdxInfo) do
    if index == self.newTeamIdx then
      for index, heroId in ipairs(teaminfo) do
        if heroId == 53 then
          self.showElement = true
          break
        end
      end
    end
  end
end

function PeakArenaPvpBattlePrepareScene:moduleInitCreate()
  local param = self.param
  self.heroCategoryInfo, self.idToIndex = prepareData:InitHeroListData({
    banedHeroIdList = self.banedHeroIdList
  })
  self.enemyTeamInfo = {}
  self.newTeamIdx = 1
  self.categoryIdx = 1
  self.herosDragList = herosDragList.new(self, {
    info = {
      heroCategoryInfo = self.heroCategoryInfo,
      teamIdxInfo = self.teamIdxInfo,
      banedHeroIdList = self.banedHeroIdList
    },
    callbackOver = function(info)
      self.heroCategoryInfo = info.heroCategoryInfo or self.heroCategoryInfo
      self.teamIdxInfo = info.teamIdxInfo or self.teamIdxInfo
      info.newTeamIdx = self.newTeamIdx
      self:getKarlElementByExistTeam()
      self.newTeamDragList:refresh(info)
      self:refreshGs()
      refreshpreseHeros(self)
    end
  })
  self.btnsDragList = btnsDragList.new(self, {
    index = self.categoryIdx,
    info = {
      btnStr = {
        {
          "all",
          T("\229\133\168\233\131\168")
        },
        {
          "front",
          T("\229\137\141\230\142\146")
        },
        {
          "middle",
          T("\228\184\173\230\142\146")
        },
        {
          "back",
          T("\229\144\142\230\142\146")
        }
      }
    },
    callbackOver = function(categoryIdx)
      self.categoryIdx = categoryIdx
      self:getKarlElementByExistTeam()
      self.herosDragList:refresh({})
    end
  })
  self.teamIdxDragList = teamIdxDragList.new(self, {
    info = {
      newTeamIdx = self.newTeamIdx,
      team_count = param.team_count
    },
    callbackOver = function(idx)
      self.newTeamIdx = idx or self.newTeamIdx
      self:getKarlElementByExistTeam()
      self.herosDragList:refresh({})
      self.newTeamDragList:refresh({
        newTeamIdx = self.newTeamIdx,
        teamIdxInfo = self.teamIdxInfo
      })
      if self.enemyTeamDragList then
        self.enemyTeamDragList:refresh({
          idx = self.newTeamIdx
        })
      end
      self:rightWindowRefresh()
      self:refreshGs()
      refreshpreseHeros(self)
    end
  })
  self:getKarlElementByExistTeam()
  self.newTeamDragList = newTeamDragList.new(self, {
    info = {
      newTeamIdx = self.newTeamIdx,
      teamIdxInfo = self.teamIdxInfo
    },
    callbackOver = function(info)
      self.teamIdxInfo = info.teamIdxInfo or self.teamIdxInfo
      self:getKarlElementByExistTeam()
      self.herosDragList:refresh({})
      self:refreshGs()
      refreshpreseHeros(self)
    end
  })
  if param.mode == "attack" then
    self.enemyTeamDragList = enemyTeamDragList.new(self, {
      info = {
        oppo_teams = param.oppo_teams
      },
      callbackOver = function(up)
        self.newTeamIdx = ed.clamp(up, 1, self.param.team_count)
        self.herosDragList:refresh({})
        self.teamIdxDragList:refresh(self.newTeamIdx)
        self.newTeamDragList:refresh({
          newTeamIdx = self.newTeamIdx,
          teamIdxInfo = self.teamIdxInfo
        })
        self:rightWindowRefresh()
        self:refreshGs()
        refreshpreseHeros(self)
      end
    })
  end
end

function PeakArenaPvpBattlePrepareScene:rightWindowRefresh()
  if not self.oldnewTeamIdx or self.newTeamIdx ~= self.oldnewTeamIdx then
    self.ui.go_next:setVisible(self.newTeamIdx ~= self.param.team_count)
    self.ui.go:setVisible(self.newTeamIdx == self.param.team_count)
    local config = enemy_label_config[self.newTeamIdx] or enemy_label_config[3]
    ed.setLabelColor(self.ui.enemyimg, config.color)
    ed.setLabelStroke(self.ui.enemyimg, config.strokeColor, config.strokeSize)
    local color = {
      "#F3C328",
      "#57C1FD",
      "#E5593B",
      "#EFC3FF",
      "#99E9D5"
    }
    self.ui.enemyTeamTit:setString(T("\229\175\185\230\150\185%s\233\152\159", self.newTeamIdx))
    self.ui.enemyTeamTit:setColor(ccc3(ed.colorToStr(color[self.newTeamIdx])))
    self:refreshOppoGs()
  end
  self.oldnewTeamIdx = self.newTeamIdx
end

function PeakArenaPvpBattlePrepareScene:refreshGs()
  local heroIdList = self.teamIdxInfo[self.newTeamIdx]
  local totalGs = 0
  for _, heroId in pairs(heroIdList or {}) do
    local hero = ed.player:getHero(heroId)
    if hero then
      totalGs = totalGs + hero._gs
    end
  end
  ed.setString(self.ui.gs, totalGs)
end

function PeakArenaPvpBattlePrepareScene:refreshOppoGs()
  if not self.param.oppo_teams then
    return
  end
  local oppoHeroList = self.param.oppo_teams[self.newTeamIdx]
  local oppoTotalGs = 0
  for _, heroInfo in pairs(oppoHeroList or {}) do
    local gs = heroInfo._gs or 0
    oppoTotalGs = oppoTotalGs + gs
  end
  local summary = self.param.oppo_summary
  if not summary then
    return
  end
  if ed.PeakArenaManager.masked.isMasked(summary._grade) then
    local length = ed.getIntNumLenght(oppoTotalGs)
    oppoTotalGs = ""
    for _ = 1, length do
      oppoTotalGs = oppoTotalGs .. "?"
    end
  end
  ed.setString(self.ui.gs_eme, oppoTotalGs)
end

function PeakArenaPvpBattlePrepareScene:rightWindowInit()
  if self.param.mode == "attack" then
    local summary = self.param.oppo_summary
    local userSummary = summary._summary
    local myHead = ed.getWholeHeadIcon({
      id = userSummary._avatar
    })
    self.ui.Panel_headPos:addChild(myHead)
    local name = ed.getPlayerName(ed.transBotName(userSummary._name), userSummary._medal, {
      anchorPoint = self.ui.txt_name:getAnchorPoint()
    })
    ed.UITool.replaceUI(self.ui, "name_bg", "txt_name", name)
    local roleGs = summary._lineup_gs
    local score = summary._score
    local scoreRank
    if ed.PeakArenaManager.masked.isMasked(summary._grade) then
      local length = ed.getIntNumLenght(score)
      score = ""
      for _ = 1, length do
        score = score .. "?"
      end
      length = ed.getIntNumLenght(roleGs)
      roleGs = ""
      for _ = 1, length do
        roleGs = roleGs .. "?"
      end
      if summary._score_rank and summary._score_rank > 0 then
        local length = ed.getIntNumLenght(summary._score_rank)
        scoreRank = ""
        for _ = 1, length do
          scoreRank = scoreRank .. "?"
        end
        scoreRank = "???"
      end
    end
    local gradeTextPath = ed.PeakArenaManager:getGradeTextRes(summary._grade or 1)
    local gradeText = ed.createSprite(gradeTextPath)
    gradeText:setAnchorPoint(ccp(0, 0.5))
    self.ui.panel_duanwei:addChild(gradeText)
    gradeText:setScale(0.5)
    gradeText:setPositionX(-12)
    ed.layout.centerYInParent(gradeText)
    if ed.PeakArenaManager.masked.isMasked(summary._grade) then
      ed.setLabelString(self.ui.qufu, "???")
    else
      ed.setLabelString(self.ui.qufu, summary._server_name or "")
    end
    if summary._score_rank then
      self.ui.image_rank_bg:setVisible(true)
      local rankText = ed.getNumberNode({
        text = scoreRank or 0,
        folder = "peak_rank"
      }).node
      self.ui.image_rank_bg:addChild(rankText)
      rankText:setPosition(ccp(120, 32))
      self.ui.image_rank_no:setPositionX(rankText:getPositionX() - rankText:getContentSize().width / 2 - self.ui.image_rank_no:getContentSize().width / 2)
    else
      self.ui.image_rank_bg:setVisible(false)
    end
    local gsText = ed.getNumberNode({
      text = roleGs or 0,
      folder = "hero_gs"
    }).node
    self.ui.panel_gs:addChild(gsText)
    gsText:setPositionX(gsText:getContentSize().width / 2)
    ed.layout.centerYInParent(gsText)
    local gsText = ed.getNumberNode({
      text = score or 0,
      folder = "peak_score"
    }).node
    self.ui.panel_score:addChild(gsText)
    gsText:setScale(0.8)
    ed.layout.centerInParent(gsText)
  end
  self.ui.label_go:setString(T(self.param.mode == "attack" and T("\230\136\152\230\150\151") or T("\229\174\140\230\136\144")))
  ed.setLabelShadow(self.ui.label_go, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_go_dele, ccc3(0, 0, 0), ccp(0, 2))
  ed.setLabelShadow(self.ui.label_go_next, ccc3(0, 0, 0), ccp(0, 2))
  self:initLegendEquip()
  self:registerTouchHandler()
end

function PeakArenaPvpBattlePrepareScene:registerTouchHandler()
  ed.UITool.registerBtn(self, "Image_select_bg", function()
    self.ui.Image_select:setVisible(not self.ui.Image_select:isVisible())
    ed.storage.setValue("PEAKARENA_SKIP_BATTLE", self.ui.Image_select:isVisible())
  end)
  ed.UITool.registerBtn(self, "Label_select_str", function()
    self.ui.Image_select:setVisible(not self.ui.Image_select:isVisible())
    ed.storage.setValue("PEAKARENA_SKIP_BATTLE", self.ui.Image_select:isVisible())
  end)
  ed.UITool.registerBtn(self, "go_dele", function()
    self:onClickBtnGoDele()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "go_next", function()
    self:onClickBtnGoNext()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "go", function()
    self:onClickBtnGo()
  end, {pressScale = 0.98})
  ed.UITool.registerBtn(self, "search", function()
    ed.ui.peakArenaStarWin.create()
  end, {pressScale = 0.98})
  self:btRegisterButtonClick({
    button = self.ui.switch_equip_bg,
    key = "switch_equip_bg",
    clickInterval = 0.3,
    force = true,
    clickHandler = function()
      ed.off_legendEquipOp = not ed.off_legendEquipOp
      ed.saveLegendEquip()
      self:switchLegendEquipMenu(ed.off_legendEquipOp)
    end
  })
end

function PeakArenaPvpBattlePrepareScene:initLegendEquip()
  if not ed.openLegendEquip() then
    self.ui.switch_equip_bg:setVisible(false)
  end
  local constAdaptScale = 1.8
  local currentScale = ed.display.winSize.width / ed.display.winSize.height
  if constAdaptScale >= currentScale then
    self.ui.switch_equip_bg:setScale(0.85)
    self.ui.switch_equip_bg:setPositionX(62)
  else
    self.ui.switch_equip_bg:setPositionX(75)
  end
  self.ui.close_equip_bg:setVisible(not ed.off_legendEquipOp)
  self.ui.label_equip:setVisible(not ed.off_legendEquipOp)
  self.ui.btn_equip:setPositionX(ed.off_legendEquipOp and 17 or 59)
  self.ui.label_equip_enable:setVisible(ed.off_legendEquipOp)
  if not ed.off_legendEquipOp then
    self.ui.label_equip:setPositionX(17)
    self.ui.btn_equip:setPositionX(59)
  end
  ed.setString(self.ui.label_equip_enable, "\228\184\141\229\177\149\231\164\186")
  ed.setLabelColor(self.ui.label_equip_des, ed.toccc3(16771194))
  ed.setLabelStroke(self.ui.label_equip_des, ed.toccc3(1973790), 1.5)
  ed.setLabelColor(self.ui.label_equip, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip, ed.toccc3(65793), 1.5)
  ed.setLabelColor(self.ui.label_equip_enable, ed.toccc3(16776423))
  ed.setLabelStroke(self.ui.label_equip_enable, ed.toccc3(65793), 1.5)
end

function PeakArenaPvpBattlePrepareScene:switchLegendEquipMenu(open)
  self.ui.close_equip_bg:setVisible(not open)
  self.ui.label_equip:setVisible(not open)
  self.ui.label_equip_enable:setVisible(open)
  self.ui.btn_equip:setPositionX(open and 17 or 59)
  self:refreshLegendEquip()
end

function PeakArenaPvpBattlePrepareScene:refreshLegendEquip()
  self.herosDragList:refresh({})
  self.teamIdxDragList:refresh(self.newTeamIdx)
  self.newTeamDragList:refresh({
    newTeamIdx = self.newTeamIdx,
    teamIdxInfo = self.teamIdxInfo
  })
end

function PeakArenaPvpBattlePrepareScene:onClickBtnGoDele()
  if not self.canClick then
    return
  end
  ed.showConfirmDialog({
    text = T("\230\152\175\229\144\166\230\184\133\231\169\186\230\137\128\230\156\137\233\152\159\231\154\132\232\139\177\233\155\132"),
    rightText = T("\231\161\174\229\174\154"),
    skipDestroyAnim = true,
    rightHandler = function()
      self.teamIdxInfo = {
        {},
        {},
        {},
        {},
        {}
      }
      self:getKarlElementByExistTeam()
      self.herosDragList:refresh({
        teamIdxInfo = self.teamIdxInfo
      })
      self.newTeamDragList:refresh({
        newTeamIdx = self.newTeamIdx,
        teamIdxInfo = self.teamIdxInfo,
        allDelete = true
      })
      self:refreshGs()
      refreshpreseHeros(self)
    end
  })
end

function PeakArenaPvpBattlePrepareScene:onClickBtnGoNext()
  local heroIdList = self.teamIdxInfo[self.newTeamIdx]
  if not heroIdList or #heroIdList == 0 then
    ed.showConfirmDialog({
      text = string.format(T("\230\130\168\231\154\132%s\233\152\159\230\178\161\230\156\137\233\128\137\230\139\169\232\139\177\233\155\132\239\188\140\232\175\183\232\135\179\229\176\145\233\128\137\230\139\169\228\184\128\228\184\170\229\135\186\230\136\152\232\139\177\233\155\132"), self.newTeamIdx),
      rightText = T("\231\161\174\229\174\154"),
      skipDestroyAnim = true
    })
    return
  end
  self.newTeamIdx = ed.clamp(self.newTeamIdx + 1, 1, self.param.team_count)
  self:getKarlElementByExistTeam()
  self.herosDragList:refresh({})
  self.teamIdxDragList:refresh(self.newTeamIdx)
  self.newTeamDragList:refresh({
    newTeamIdx = self.newTeamIdx,
    teamIdxInfo = self.teamIdxInfo
  })
  if self.enemyTeamDragList then
    self.enemyTeamDragList:refresh({
      idx = self.newTeamIdx
    })
  end
  self:rightWindowRefresh()
  self:refreshGs()
  refreshpreseHeros(self)
end

function PeakArenaPvpBattlePrepareScene:onClickBtnGo()
  local tipsContent = ""
  for teamIndex = 1, self.param.team_count do
    local heroIdList = self.teamIdxInfo[teamIndex]
    if not heroIdList or #heroIdList == 0 then
      tipsContent = tipsContent .. string.format(T("%s\233\152\159"), teamIndex)
    end
  end
  if tipsContent ~= "" then
    ed.showConfirmDialog({
      text = string.format(T("\230\130\168\231\154\132%s\230\178\161\230\156\137\233\128\137\230\139\169\232\139\177\233\155\132\239\188\140\232\175\183\232\135\179\229\176\145\233\128\137\230\139\169\228\184\128\228\184\170\229\135\186\230\136\152\232\139\177\233\155\132"), tipsContent),
      rightText = T("\231\161\174\229\174\154"),
      skipDestroyAnim = true
    })
    return
  end
  if self.param.mode == "attack" then
    self:GoAttack()
  else
    self:GoDefend()
  end
end

function PeakArenaPvpBattlePrepareScene:GoDefend()
  local defend_team = self.teamIdxInfo
  local data = {defendTeam = defend_team}
  ed.popScene()
  FireEvent("PeakArenaSetDefendTeam", data)
end

local team_data_key = {
  "PeakArena_1",
  "PeakArena_2",
  "PeakArena_3",
  "PeakArena_4",
  "PeakArena_5"
}

function PeakArenaPvpBattlePrepareScene:setTeamsData(data)
  if data == nil then
    EDLog("PeakArenaBattlePrepareScene:setTeamsData - Data is nil!")
    return
  end
  for i = 1, self.param.team_count do
    ed.setTeamData(team_data_key[i], data[i])
  end
end

function PeakArenaPvpBattlePrepareScene:getTeamsData()
  local data = {}
  local used = {}
  for i = 1, self.param.team_count do
    local heroIdList = ed.getTeamData(team_data_key[i])
    local filterData = {}
    for _, heroId in pairs(heroIdList or {}) do
      if ed.player:getHero(heroId) and not ed.isElementInTable(heroId, self.banedHeroIdList) and nil == used[heroId] then
        used[heroId] = i
        table.insert(filterData, heroId)
      end
    end
    data[i] = filterData
  end
  return data
end

function PeakArenaPvpBattlePrepareScene:GoAttack()
  ed.PeakArenaNetwork.skipBattle = self.ui.Image_select:isVisible()
  local attack_teams = self.teamIdxInfo
  self:setTeamsData(attack_teams)
  local data = {attackTeam = attack_teams}
  self.canClick = false
  ed.popScene()
  FireEvent("PeakArenaSetAttackTeam", data)
end

function PeakArenaPvpBattlePrepareScene:defendInit()
  self.ui.layEmeHeros:setVisible(false)
  self.ui.panel_defend:setVisible(true)
  local thisCon = self.ui.heros_items:getContentSize()
  if #ed.PeakArenaManager.seasonBuffs > 0 then
    self.ui.defendTopName:setString(ed.PeakArenaManager:getSeasonBuff((ed.PeakArenaManager.seasonBuffs[1] or {})._key)["Buff Name"])
    self.ui.heros_items:setContentSize(CCSizeMake(thisCon.width, thisCon.height + 35))
  else
    self.ui.heros_items:setContentSize(CCSizeMake(thisCon.width, thisCon.height + 70))
    self.ui.defendTopImg:setVisible(false)
  end
end

function PeakArenaPvpBattlePrepareScene:attackInit()
  self.ui.panel_attack:setVisible(true)
  if #ed.PeakArenaManager.seasonBuffs > 0 then
    self.ui.defendTopName:setString(ed.PeakArenaManager:getSeasonBuff((ed.PeakArenaManager.seasonBuffs[1] or {})._key)["Buff Name"])
    self.ui.defendTopImg:setPositionY(self.ui.defendTopImg:getPositionY() - 70)
    local thisCon = self.ui.heros_items:getContentSize()
    self.ui.heros_items:setContentSize(CCSizeMake(thisCon.width, thisCon.height - 35))
  else
    self.ui.defendTopImg:setVisible(false)
  end
end
