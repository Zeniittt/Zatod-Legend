local base = ed.ui.popwindow
local CrusadeChallengeWin = {}
CrusadeChallengeWin.__index = CrusadeChallengeWin
setmetatable(CrusadeChallengeWin, base.mt)
ed.ui.CrusadeChallengeWin = CrusadeChallengeWin
local CrusadeChallengeWinScope = {}

function CrusadeChallengeWin.create(param, stageId)
  local self = base.create("CrusadeChallengeWin")
  setmetatable(self, CrusadeChallengeWin)
  self:initData(param, stageId)
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  self:popWindow()
  return self
end

function CrusadeChallengeWin:initData(data, stageId)
  self.data = data
  self.stageId = stageId
end

function CrusadeChallengeWin:initUI()
  self.ui = {}
  local readnode = ed.readnode.create(self.container, self.ui)
  readnode:addNode(ed.uieditor.CrusadeChallengeWin)
  ed.setLabelShadow(self.ui.Label_2444, ed.toccc3(0), ccp(1, 0))
  ed.adaptLabel(self.ui.Label_2444, {maxWidth = 60, minScale = 0.7})
  self:refreshUI()
end

function CrusadeChallengeWin:getLocalHerosInfo(data, curSelectStage)
  if data and data._oppos == nil then
    data._oppos = {}
    for i = 1, 5 do
      local index = (curSelectStage - 1) * 5 + i
      local sLevel = string.format("tbcHeroLevel%d", index)
      local sStar = string.format("tbcHeroStar%d", index)
      local sRank = string.format("tbcHeroRank%d", index)
      local sId = string.format("tbcHero%d", index)
      local sArousaStatus = string.format("tbcHeroStatus%d", index)
      local id = ed.storage.getInt(sId)
      if nil ~= id and id ~= 0 then
        local hero = {}
        local base = {}
        base._tid = id
        base._level = ed.storage.getInt(sLevel)
        base._stars = ed.storage.getInt(sStar)
        base._rank = ed.storage.getInt(sRank)
        hero._base = base
        local dyna = {}
        dyna._hp_perc = 0
        hero._dyna = dyna
        table.insert(data._oppos, hero)
      end
    end
  end
end

function CrusadeChallengeWin:refreshUI()
  local ui = self.ui
  local LocalObjData = ed.CrusadeManager.LocalObjData
  local data = self.data
  local name = ed.getPlayerName(ed.transBotName(data._summary._name), data._summary._medal, {
    anchorPoint = ccp(0, 0.5)
  })
  ed.UITool.replaceUI(ui, "battleinfo", "heroName", name)
  ed.setString(self.ui.currentBattle, string.format(T("\229\133\179\229\141\161(%d/%d)"), self.stageId, ed.CrusadeManager.sumOfCrusadeStage))
  ed.setString(self.ui.level, data._summary._level)
  local hasOppos = data._oppos ~= nil
  if nil == data._oppos then
    self:getLocalHerosInfo(data, self.stageId)
  end
  local param = {
    id = data._summary._avatar,
    vip = 0 < data._summary._vip
  }
  local head = ed.getHeroIconByID(param)
  head:setScale(0.5)
  ed.UITool.replaceUI(self.ui, "battleinfo", "enemyIcon", head)
  LocalObjData.param = param
  LocalObjData.heroName = data._summary._name
  LocalObjData.heroMedal = data._summary._medal
  LocalObjData.currentBattle = string.format("%d/%d", self.stageId, ed.CrusadeManager.sumOfCrusadeStage)
  LocalObjData.newLevel = data._summary._level
  ed.CrusadeManager.enemyRobot = data._is_robot and 0 < data._is_robot
  if ed.CrusadeManager.battleState[self.stageId] == "passed" or ed.CrusadeManager.battleState[self.stageId] == "rewarded" then
    self.ui.start:setVisible(false)
  else
    self.ui.start:setVisible(true)
  end
  if data._oppos == nil or 0 >= #data._oppos then
    for i = 1, 5 do
      self.ui["hero" .. i]:setVisible(false)
    end
    ed.createLabelTools({
      txt = T("\232\175\165\233\152\181\229\174\185\229\183\178\232\162\171\229\133\136\233\129\163\233\152\159\229\135\187\232\180\165"),
      size = 22,
      anchor = ccp(0.5, 0.5),
      pos = ccp(280, 67),
      color = ccc3(147, 151, 156),
      parent = self.ui.battleinfo
    })
  end
  ed.CrusadeManager.enemyHeros = {}
  ed.CrusadeManager.crusadeData = {}
  for i = 1, #data._oppos do
    local hero = string.format("hero%d", i)
    local base = data._oppos[i]._base
    local dyna = data._oppos[i]._dyna
    if 0 < dyna._hp_perc then
      table.insert(ed.CrusadeManager.enemyHeros, base)
      local crusadeData = {
        _hp_perc = dyna._hp_perc,
        _mp_perc = dyna._mp_perc,
        _custom_data = dyna._custom_data
      }
      ed.CrusadeManager.crusadeData[base._tid] = crusadeData
    end
    local icon = ed.readhero.createIcon({
      id = base._tid,
      rank = base._rank,
      fashion_id = base._fashion,
      level = base._level,
      stars = base._stars,
      hp = dyna._hp_perc,
      summary = base,
      legendEquip = base._legend_equip and base._legend_equip._equip
    })
    icon:showLegendEquip(not ed.openLegendEquip())
    local heroIcon = icon.icon
    ed.UITool.replaceUI(self.ui, "battleinfo", "hero" .. i, heroIcon)
    self:btRegisterButtonClick({
      button = heroIcon,
      key = "hero" .. i,
      force = true,
      clickHandler = function()
        if hasOppos then
          ed.ui.checkOthersHeroWindow.create(base):popWindow()
        else
          ed.ui.checkOthersHeroWindow.create():popWindow()
          ed.PlayerInfoNetwork:requestHeroData(data._summary._role_id, base._tid)
        end
      end
    })
  end
  self.ui.levelBg:setPositionX(self.ui.levelBg:getPositionX() + 2)
  self.ui.level:setPositionX(self.ui.level:getPositionX() + 2)
  self.ui.heroName:setPositionX(self.ui.heroName:getPositionX() - 2)
  ed.battleshare.getOppoName(data)
  LocalObjData.guildName = ""
  if data._summary._guild_name and data._summary._guild_name ~= "" then
    self.ui.guildName:setVisible(true)
    ed.setString(self.ui.guildHint, T("\230\157\165\232\135\170\229\133\172\228\188\154:"))
    ed.setString(self.ui.guildName, data._summary._guild_name)
    LocalObjData.guildName = data._summary._guild_name
    ed.setLabelColor(self.ui.guildHint, ccc3(255, 215, 126))
    ed.setLabelColor(self.ui.guildName, ccc3(255, 215, 126))
  else
    ed.setString(self.ui.guildHint, T("\230\156\170\229\138\160\229\133\165\229\133\172\228\188\154"))
    ed.setString(self.ui.guildName, T(""))
    ed.setLabelColor(self.ui.guildHint, ccc3(173, 165, 162))
    ed.setLabelColor(self.ui.guildName, ccc3(173, 165, 162))
  end
end

function CrusadeChallengeWin:start()
  local stageId = -2 - ed.CrusadeManager.curStageIndex
  local crusadeMercenary = ed.GuildManager.crusadeMercenary
  ed.pushScene(ed.ui.battleprepare.create({
    mode = "crusade",
    extraMode = "normal",
    stage_id = stageId,
    heroLimit = {type = "level", detail = 20},
    hireMercenary = crusadeMercenary,
    enemyHeros = ed.CrusadeManager.enemyHeros,
    objData = ed.CrusadeManager.LocalObjData
  }))
  ed.battleshare.setStageid(stageId)
end

function CrusadeChallengeWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "start", function()
    if ed.CrusadeManager:canRush() then
      ed.showConfirmDialog({
        text = T("\227\128\144\229\189\147\230\151\165\229\133\136\233\129\163\233\152\159\230\156\170\229\144\175\231\148\168\239\188\140\230\152\175\229\144\166\229\137\141\229\190\128\230\180\190\233\129\163\227\128\145"),
        rightText = T("\229\137\141\229\190\128"),
        leftText = T("\230\154\130\228\184\141"),
        rightHandler = function()
          local crusadeMercenary = ed.GuildManager.crusadeMercenary
          ed.pushScene(ed.ui.battleprepare.create({
            mode = "crusade",
            extraMode = "normal",
            tbc_rush_mode = true,
            tbc_recommend_heros = ed.CrusadeManager.rushHeros or {},
            heroLimit = {type = "level", detail = 65},
            hireMercenary = crusadeMercenary,
            objData = {isAdvanceTeam = true}
          }))
        end,
        leftHandler = function()
          self:start()
        end
      })
    else
      self:start()
    end
    self:destroy({skipAnim = true})
  end, {clickInterval = 0.5, pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {
    clickInterval = 0.5,
    pressScale = 0.75,
    normalScale = 0.8
  })
end
