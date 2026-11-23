local M = setmetatable({}, {__index = _G})
setfenv(1, M)
local lsr = ed.ui.battlepreparepeakarenalsr.create()
local member_count_max = 5
herosDragList = {}

function herosDragList.new(sceneSelf, param)
  return setmetatable({
    sceneSelf = sceneSelf,
    canClick = true,
    param = param
  }, {__index = herosDragList}):createDragList(param)
end

function herosDragList:getIndexToPosFun()
  self.listHeight = 20
  local width = 90
  local widCount = math.floor(self.thisCon.width / width)
  local py = (self.thisCon.width - widCount * width) / 2
  local poxx, poxy = width / 2 + py, self.thisCon.height + width / 2 - 10
  return function(idx)
    if idx % widCount == 1 then
      poxx, poxy = width / 2 + py, poxy - width
      self.listHeight = self.listHeight + width
    else
      poxx = poxx + width
    end
    return poxx, poxy
  end
end

function herosDragList:getTeamIndex(id)
  for i, v in ipairs(self.param.info.teamIdxInfo) do
    if ed.isElementInTable(id, v) then
      return i
    end
  end
end

function herosDragList:createDragList(param)
  self.thisCon = self.sceneSelf.ui.heros_items:getContentSize()
  self.draglist = ed.draglist.create({
    cliprect = CCRectMake(0, 0, self.thisCon.width, self.thisCon.height),
    container = self.sceneSelf.ui.heros_items,
    cancelClickIn = function(x, y, hero)
      if hero then
        hero.icon:setScale(1)
        self.cancelClick = false
      end
    end,
    doPressIn = function(x, y)
      for _, v in ipairs(self.newShowIndex or {}) do
        if ed.containsPoint(v.icon, x, y) then
          self.cancelClick = true
          v.icon:setScale(0.95)
          return v
        end
      end
    end,
    cancelPressIn = function(x, y, hero)
      if hero and self.cancelClick then
        hero.icon:setScale(1)
        if self.canClick then
          self.canClick = false
          self.sceneSelf:listenTimer(Timer:Once(0.3), function()
            self.canClick = true
          end)
          self:doClickInList(hero)
        end
      end
    end
  })
  local info = param.info
  local allTabs = info.heroCategoryInfo
  local teamTabs = info.teamIdxInfo
  self.banedHeroIdList = info.banedHeroIdList or {}
  local getpos = self:getIndexToPosFun()
  self.newShowIndex = {}
  for i, v in ipairs(allTabs) do
    local hero = ed.readhero.createIconByID(v._tid, {state = "idle", isShowLegendEquip = true})
    hero:showLegendEquip(ed.off_legendEquipOp)
    local isBaned = ed.isElementInTable(v._tid, self.banedHeroIdList)
    local team_index = self:getTeamIndex(v._tid)
    if team_index then
      hero:addLegendArenaTeamInfo({team_index = team_index, peakArena = true})
      hero.teamid = team_index
      if team_index == self.sceneSelf.newTeamIdx then
        hero:showSelectTag()
      end
    end
    if not ed.player.heroes[v._tid] then
      hero:addStateInfo("noOwn")
      hero.noOwn = true
    end
    if isBaned then
      hero:addPeakArenaBanTag()
      hero.isBaned = true
    end
    v.readhero = hero
    self.draglist:addItem(hero.icon)
    hero.icon:setPosition(getpos(i))
    hero.allIndex = i
    table.insert(self.newShowIndex, hero)
  end
  self.draglist:initListHeight(self.listHeight)
  return self
end

function herosDragList:refresh(info)
  self.param.info.heroCategoryInfo = info.heroCategoryInfo or self.param.info.heroCategoryInfo
  self.param.info.teamIdxInfo = info.teamIdxInfo or self.param.info.teamIdxInfo
  local info = self.param.info
  local allTabs = info.heroCategoryInfo
  local teamTabs = info.teamIdxInfo
  local idxKey = {
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
  local category = idxKey[self.sceneSelf.categoryIdx][1]
  local oldListHeight = self.listHeight
  local getpos = self:getIndexToPosFun()
  self.newShowIndex = {}
  for i, v in ipairs(allTabs) do
    local hero = v.readhero
    hero.teamid = nil
    if category == "all" or category == v.category then
      hero.icon:setVisible(true)
      hero:showLegendEquip(ed.off_legendEquipOp)
      hero:showKarlElement(self.sceneSelf.showElement)
      local team_index = self:getTeamIndex(v._tid)
      hero:deleteSelectTag()
      if team_index then
        hero:addLegendArenaTeamInfo({team_index = team_index, peakArena = true})
        hero.teamid = team_index
        if team_index == self.sceneSelf.newTeamIdx then
          hero:showSelectTag()
        end
      else
        hero:RemoveTeamInfo()
      end
      hero.icon:setPosition(getpos(#self.newShowIndex + 1))
      table.insert(self.newShowIndex, hero)
    else
      hero.icon:setVisible(false)
    end
  end
  if oldListHeight ~= self.listHeight then
    self.draglist:initListHeight(self.listHeight)
  end
end

function herosDragList:doClickInList(hero)
  local info = self.param.info
  local allTabs = info.heroCategoryInfo
  local teamTabs = info.teamIdxInfo
  if hero.noOwn then
    ed.showToast(T("\229\176\154\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
    return
  end
  if hero.isBaned then
    ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\232\162\171\231\166\129\231\148\168"))
    return
  end
  if hero.isSelected then
    hero:deleteSelectTag()
    for i, v in ipairs(teamTabs[self.sceneSelf.newTeamIdx]) do
      if allTabs[hero.allIndex]._tid == v then
        table.remove(teamTabs[self.sceneSelf.newTeamIdx], i)
        break
      end
    end
    hero.teamid = nil
    hero:RemoveTeamInfo()
    self.param.callbackOver({
      heroCategoryInfo = allTabs,
      teamIdxInfo = teamTabs,
      updateAllIdPos = true
    })
    return
  end
  if #teamTabs[self.sceneSelf.newTeamIdx] >= member_count_max then
    lsr:report("clickAddHeroTeamFilled")
    ed.playEffect(ed.sound.deo.common_popup_small)
    ed.showToast(T("\229\143\170\232\131\189\233\128\137\230\139\1695\228\184\170\232\139\177\233\155\132"))
    self.param.callbackOver({allShine = true})
    return
  end
  if hero.teamid and hero.teamid ~= self.sceneSelf.newTeamIdx then
    local function callback()
      hero:RemoveTeamInfo()
      
      hero:deleteSelectTag()
      for i, v in ipairs(teamTabs[hero.teamid]) do
        if v == allTabs[hero.allIndex]._tid then
          table.remove(teamTabs[hero.teamid], i)
        end
      end
      hero:showSelectTag()
      hero:addLegendArenaTeamInfo({
        team_index = self.sceneSelf.newTeamIdx,
        peakArena = true
      })
      table.insert(teamTabs[self.sceneSelf.newTeamIdx], allTabs[hero.allIndex]._tid)
      hero.teamid = self.sceneSelf.newTeamIdx
      self.param.callbackOver({
        heroCategoryInfo = allTabs,
        teamIdxInfo = teamTabs,
        updateAllIdPos = true
      })
    end
    
    ed.showConfirmDialog({
      text = T("\232\175\165\232\139\177\233\155\132\229\183\178\231\187\143\229\156\168\229\133\182\228\187\150\233\152\159\228\188\141\228\184\173\239\188\140\230\152\175\229\144\166\231\167\187\229\138\168\229\136\176\232\191\153\230\148\175\233\152\159\228\188\141\239\188\159"),
      rightHandler = callback
    })
    return
  end
  lsr:report("clickHeadRemoveHero")
  hero:showSelectTag()
  hero:addLegendArenaTeamInfo({
    team_index = self.sceneSelf.newTeamIdx,
    peakArena = true
  })
  table.insert(teamTabs[self.sceneSelf.newTeamIdx], allTabs[hero.allIndex]._tid)
  hero.teamid = self.sceneSelf.newTeamIdx
  self.param.callbackOver({
    heroCategoryInfo = allTabs,
    teamIdxInfo = teamTabs,
    updateAllIdPos = true
  })
end

btnsDragList = {}

function btnsDragList.new(sceneSelf, param)
  return setmetatable({sceneSelf = sceneSelf, param = param}, {__index = btnsDragList}):create()
end

function btnsDragList:create()
  self.btns = {}
  local con = self.sceneSelf.ui.butts_list:getContentSize()
  for i, v in ipairs(self.param.info.btnStr) do
    local button = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png")
    local press = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png")
    local label = ed.createLabelTTF(v[2], 18)
    ed.setLabelFontInfo(label, "dark_white_stroke")
    button:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    press:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    label:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    self.sceneSelf.ui.butts_list:addChild(button)
    self.sceneSelf.ui.butts_list:addChild(press)
    self.sceneSelf.ui.butts_list:addChild(label)
    press:setVisible(self.param.index == i)
    table.insert(self.btns, {
      type = v[2],
      press = press,
      label = label,
      button = button
    })
    self.sceneSelf:btRegisterButtonClick({
      button = button,
      key = "btnsDragListBtn" .. i,
      param = {index = i},
      clickHandler = function(param)
        if self.param.index ~= param.index then
          self:refresh(param.index)
          self.param.callbackOver(param.index)
        else
          self:refresh(param.index)
        end
      end,
      force = true,
      pressScale = 0.95,
      normalScale = 1
    })
  end
  return self
end

function btnsDragList:refresh(index)
  self.param.index = index
  for i, v in ipairs(self.btns) do
    v.press:setVisible(self.param.index == i)
  end
end

teamIdxDragList = {}

function teamIdxDragList.new(sceneSelf, param)
  return setmetatable({sceneSelf = sceneSelf, param = param}, {__index = teamIdxDragList}):create()
end

function teamIdxDragList:create()
  local info = self.param.info
  local newTeamIdx = info.newTeamIdx
  local teamCount = info.team_count
  self.btns = {}
  for i = 1, teamCount do
    if self.sceneSelf.ui["teamBtn_" .. i] then
      self.sceneSelf.ui["teamBtn_" .. i]:setVisible(true)
      self.sceneSelf.ui["teamBtnPass_" .. i]:setVisible(newTeamIdx == i)
      self.sceneSelf:btRegisterButtonClick({
        button = self.sceneSelf.ui["teamBtn_" .. i],
        key = "teamIndexBtn_" .. i,
        param = {newTeamIdx = i},
        clickHandler = function(param)
          if self.param.info.newTeamIdx ~= param.newTeamIdx then
            self:refresh(param.newTeamIdx)
            self.param.callbackOver(param.newTeamIdx)
          else
            self:refresh(param.newTeamIdx)
          end
        end,
        force = true,
        pressScale = 0.95,
        normalScale = 1
      })
      table.insert(self.btns, {
        btn = self.sceneSelf.ui["teamBtn_" .. i],
        pass = self.sceneSelf.ui["teamBtnPass_" .. i]
      })
    else
      error(" \233\152\159\229\136\151ui\228\184\141\229\140\185\233\133\141 ")
    end
  end
  return self
end

function teamIdxDragList:refresh(newTeamIdx)
  self.param.info.newTeamIdx = newTeamIdx
  for i, v in ipairs(self.btns) do
    v.pass:setVisible(newTeamIdx == i)
  end
end

newTeamDragList = {}

function newTeamDragList.new(sceneSelf, param)
  return setmetatable({sceneSelf = sceneSelf, param = param}, {__index = newTeamDragList}):create()
end

local function sortHeroes(list)
  local function attackRange(hid)
    local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
    
    return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0) or 0
  end
  
  table.sort(list, function(a, b)
    return attackRange(a) < attackRange(b)
  end)
  return list
end

function newTeamDragList:create()
  local info = self.param.info
  local newTeamIdx = info.newTeamIdx
  local teamIdxInfo = info.teamIdxInfo
  local newTeams = sortHeroes(teamIdxInfo[newTeamIdx])
  self.myTeamIcon = {}
  for i, v in ipairs(newTeams) do
    local hero = ed.readhero.createIconByID(v, {state = "idle", isShowLegendEquip = true})
    hero:showLegendEquip(ed.off_legendEquipOp)
    hero:showKarlElement(self.sceneSelf.showElement)
    hero.icon:setPosition(ccpAdd(ccp(self.sceneSelf.ui["member_light_" .. 6 - i]:getPosition()), ccp(0, 10)))
    self.sceneSelf.ui.layTeamitems:addChild(hero.icon)
    self.myTeamIcon[v] = {
      light = self.sceneSelf.ui["member_light_" .. 6 - i],
      hero = hero,
      clickKey = "clickMyTeamIcon" .. v,
      id = v,
      index = 6 - i
    }
    self.sceneSelf:btRegisterButtonClick({
      button = hero.icon,
      key = "clickMyTeamIcon" .. v,
      param = {
        removeId = v,
        idx = 6 - i
      },
      clickHandler = function(param)
        for i, v in ipairs(self.param.info.teamIdxInfo[self.param.info.newTeamIdx]) do
          if v == param.removeId then
            table.remove(self.param.info.teamIdxInfo[self.param.info.newTeamIdx], i)
            break
          end
        end
        self:refresh({
          newTeamIdx = self.param.info.newTeamIdx,
          updateAllIdPos = true
        })
        self.param.callbackOver({
          teamIdxInfo = self.param.info.teamIdxInfo
        })
      end,
      force = true,
      pressScale = 0.95,
      normalScale = 1
    })
  end
  return self
end

local function getIdIndex(table, Id)
  for i, v in ipairs(table) do
    if Id == v then
      return i
    end
  end
end

local function getDragListIdxPos(self, id, licon)
  local index = self.sceneSelf.idToIndex[id] or 1
  local icon = self.sceneSelf.heroCategoryInfo[index].readhero.icon
  local oripos = self.sceneSelf.herosDragList.draglist.listLayer:convertToWorldSpace(ccp(icon:getPosition()))
  local epos = licon:getParent():convertToNodeSpace(ccp(oripos.x, oripos.y))
  return epos.x, epos.y
end

function newTeamDragList:refresh(info)
  local oldNewTeamIdx = self.param.info.newTeamIdx
  self.param.info = {
    newTeamIdx = info.newTeamIdx or self.param.info.newTeamIdx,
    teamIdxInfo = info.teamIdxInfo or self.param.info.teamIdxInfo
  }
  local newTeamIdx = self.param.info.newTeamIdx
  local teamIdxInfo = self.param.info.teamIdxInfo
  local newTeams = sortHeroes(teamIdxInfo[newTeamIdx])
  if oldNewTeamIdx ~= newTeamIdx then
    for i, v in pairs(self.myTeamIcon) do
      self.sceneSelf:btRemoveMainTouchHandler({
        key = v.clickKey
      })
      v.hero.icon:removeFromParentAndCleanup(true)
    end
    self:create()
  elseif info.updateAllIdPos then
    local newMyTeamIcon = {}
    for i, v in ipairs(newTeams) do
      local hero
      if self.myTeamIcon[v] then
        if self.myTeamIcon[v].index ~= 6 - i then
          local x, y = self.sceneSelf.ui["member_light_" .. 6 - i]:getPosition()
          self.myTeamIcon[v].hero.icon:stopAllActions()
          self.myTeamIcon[v].hero.icon:runAction(CCEaseBackInOut:create(CCMoveTo:create(0.2, ccpAdd(ccp(x, y), ccp(0, 10)))))
          self.myTeamIcon[v].index = 6 - i
        end
        hero = self.myTeamIcon[v].hero
      else
        hero = ed.readhero.createIconByID(v, {state = "idle", isShowLegendEquip = true})
        hero:showLegendEquip(ed.off_legendEquipOp)
        self.sceneSelf.ui.layTeamitems:addChild(hero.icon)
        hero.icon:setPosition(getDragListIdxPos(self, v, hero.icon))
        local newIdx = getIdIndex(newTeams, v)
        local x, y = self.sceneSelf.ui["member_light_" .. 6 - newIdx]:getPosition()
        if info.notActmove then
          hero.icon:setPosition(ccpAdd(ccp(x, y), ccp(0, 10)))
          hero.icon:runAction(CCFadeIn:create(0.4))
        else
          hero.icon:runAction(CCSpawn:create(ccArrayMake(CCFadeIn:create(0.2), CCMoveTo:create(0.2, ccpAdd(ccp(x, y), ccp(0, 10))))))
        end
        self.sceneSelf.ui["member_light_" .. 6 - newIdx]:stopAllActions()
        self.sceneSelf.ui["member_light_" .. 6 - newIdx]:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.2), CCFadeOut:create(0.2)))
        self.sceneSelf:btRegisterButtonClick({
          button = hero.icon,
          key = "clickMyTeamIcon" .. v,
          param = {
            removeId = v,
            idx = 6 - newIdx
          },
          clickHandler = function(param)
            for i, v in ipairs(self.param.info.teamIdxInfo[self.param.info.newTeamIdx]) do
              if v == param.removeId then
                table.remove(self.param.info.teamIdxInfo[self.param.info.newTeamIdx], i)
                break
              end
            end
            self:refresh({
              newTeamIdx = self.param.info.newTeamIdx,
              updateAllIdPos = true
            })
            self.param.callbackOver({
              teamIdxInfo = self.param.info.teamIdxInfo
            })
          end,
          force = true,
          pressScale = 0.95,
          normalScale = 1
        })
      end
      hero:showLegendEquip(ed.off_legendEquipOp)
      hero:showKarlElement(self.sceneSelf.showElement)
      newMyTeamIcon[v] = {
        light = self.sceneSelf.ui["member_light_" .. 6 - i],
        hero = hero,
        clickKey = "clickMyTeamIcon" .. v,
        id = v,
        index = 6 - i
      }
    end
    for k, v in pairs(self.myTeamIcon) do
      if not newMyTeamIcon[v.id] then
        v.hero.icon:stopAllActions()
        if info.notActmove then
          v.hero.icon:setPosition(ccp(getDragListIdxPos(self, k, v.hero.icon)))
          v.hero.icon:runAction(CCFadeOut:create(0.4))
        else
          v.hero.icon:runAction(CCSpawn:create(ccArrayMake(CCFadeOut:create(0.2), CCMoveTo:create(0.35, ccp(getDragListIdxPos(self, k, v.hero.icon))))))
        end
        v.hero:showLegendEquip(ed.off_legendEquipOp)
        v.hero:showKarlElement(self.sceneSelf.showElement)
        self.sceneSelf.ui.layTeamitems:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.2), CCCallFunc:create(function()
          self.sceneSelf:btRemoveMainTouchHandler({
            key = v.clickKey
          })
          v.hero.icon:removeFromParentAndCleanup(true)
        end))))
      end
    end
    self.myTeamIcon = newMyTeamIcon
  elseif info.allShine then
    for i = 1, 5 do
      self.sceneSelf.ui["member_light_" .. i]:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.2), CCFadeOut:create(0.2)))
    end
  elseif info.allDelete then
    for k, v in pairs(self.myTeamIcon) do
      self.sceneSelf.ui["member_light_" .. v.index]:stopAllActions()
      self.sceneSelf.ui["member_light_" .. v.index]:runAction(CCSequence:createWithTwoActions(CCFadeIn:create(0.1), CCFadeOut:create(0.1)))
      v.hero.icon:runAction(CCFadeOut:create(0.1))
    end
    self.sceneSelf.ui.layTeamitems:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.1), CCCallFunc:create(function()
      for k, v in pairs(self.myTeamIcon) do
        self.sceneSelf:btRemoveMainTouchHandler({
          key = v.clickKey
        })
        v.hero.icon:removeFromParentAndCleanup(true)
      end
      self.myTeamIcon = {}
    end))))
  end
end

enemyTeamDragList = {}

function enemyTeamDragList.new(sceneSelf, param)
  return setmetatable({sceneSelf = sceneSelf, param = param}, {__index = enemyTeamDragList}):create()
end

function enemyTeamDragList:create()
  local info = self.param.info
  local oppoTeams = info.oppo_teams
  self.newTeamIdx = self.sceneSelf.newTeamIdx
  local layer = self.sceneSelf.ui.eneTeamItem
  local winSize = layer:getContentSize()
  local clipLayer = CCLayer:create()
  layer:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(0, 0, winSize.width, winSize.height))
  self.clipLayer = clipLayer
  self.enemyTeams = {}
  for i = 1, self.sceneSelf.param.team_count do
    local lay = CCLayer:create()
    local posx = i == self.newTeamIdx and 0 or i > self.newTeamIdx and 500 or -500
    lay:setPosition(posx - 33, 30)
    clipLayer:addChild(lay)
    local ids = oppoTeams[i] or {}
    local isHidden = false
    for index, info in ipairs(ids) do
      if not info._tid or info._tid == 0 then
        isHidden = true
        break
      end
    end
    if not isHidden then
      ids = ed.PeakArenaPvpBattlePrepareData.sortHeroesByAttackRange(ids)
    end
    local teams = {}
    for h = 1, 5 do
      local heroBg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head.png")
      heroBg:setPosition(h * 68, 0)
      lay:addChild(heroBg)
      local heroInfo = {heroBg = heroBg}
      if ids[h] then
        local info = ids[h]
        if not info._tid or info._tid == 0 then
          local imageHide = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head2.png")
          heroBg:addChild(imageHide)
          ed.layout.centerInParent(imageHide)
        else
          local heroData = ed.copyProto(info)
          heroData._fashion = nil
          local hero = ed.readhero.createIconByServer(heroData)
          hero.icon:setPosition(28, 28)
          hero.icon:setScale(0.7)
          hero:showLegendEquip(ed.off_legendEquipOp)
          heroBg:addChild(hero.icon)
          heroInfo.hero = hero
        end
      end
      table.insert(teams, heroInfo)
    end
    table.insert(self.enemyTeams, {lay = lay, teams = teams})
  end
  self.sceneSelf.ui.battlePrepare_fx_L_1:setVisible(self.newTeamIdx ~= 1)
  self.sceneSelf.ui.battlePrepare_fx_R_1:setVisible(self.newTeamIdx ~= self.sceneSelf.param.team_count)
  local uiName = {
    "battlePrepare_fx_L_1",
    "battlePrepare_fx_R_1"
  }
  for i, v in ipairs(uiName) do
    self.sceneSelf:btRegisterButtonClick({
      button = self.sceneSelf.ui[v],
      key = "enemy_Team_" .. v,
      param = {up = i},
      clickHandler = function(param)
        local idx = param.up == 1 and self.newTeamIdx - 1 or self.newTeamIdx + 1
        self:refresh({idx = idx})
        self.param.callbackOver(idx)
      end,
      force = true,
      pressScale = 1.1,
      normalScale = 1
    })
  end
  return self
end

function enemyTeamDragList:refresh(param)
  param.idx = ed.clamp(param.idx, 1, self.sceneSelf.param.team_count)
  if self.newTeamIdx ~= param.idx then
    for i, v in ipairs(self.enemyTeams) do
      local posx = i == param.idx and 0 or i > param.idx and 500 or -500
      v.lay:runAction(CCEaseExponentialInOut:create(CCMoveTo:create(0.2, ccp(posx - 33, 30))))
    end
    self.newTeamIdx = param.idx
  end
  self.sceneSelf.ui.battlePrepare_fx_L_1:setVisible(self.newTeamIdx ~= 1)
  self.sceneSelf.ui.battlePrepare_fx_R_1:setVisible(self.newTeamIdx ~= self.sceneSelf.param.team_count)
end

function battlePrepareEditorui(mainLayer, uieditor, mainSelf)
  local frameContainer, frameui = ed.editorui(uieditor)
  mainLayer:addChild(frameContainer)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local lrWne = 0.25
  newWid = newWid - ed.display.getNotchHeight()
  mainLayer:setPosition(mainLayer:getPositionX() + ed.display.getNotchHeight() - newWid / 2, mainLayer:getPositionY() - newHei / 2)
  local leftMoPosX = (1 - lrWne) * newWid
  local thisCon = frameui.lay9BJ:getContentSize()
  frameui.lay9BJ:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, heightWin - 4))
  thisCon = frameui.layBgs:getContentSize()
  frameui.layBgs:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, heightWin - 5))
  local posXloc = leftMoPosX / 2
  local posYloc = newHei / 2
  frameui.starImg_1:setPosition(frameui.starImg_1:getPositionX() + posXloc, frameui.starImg_1:getPositionY() + newHei)
  frameui.starImg_2:setPositionX(frameui.starImg_2:getPositionX() + posXloc)
  frameui.starImg_3:setPositionY(frameui.starImg_3:getPositionY() + posYloc)
  frameui.starImg_4:setPosition(frameui.starImg_4:getPositionX() + leftMoPosX, frameui.starImg_4:getPositionY() + posYloc)
  local newPosY = frameui.layEmeHeros:getPositionY()
  frameui.layEmeHeros:setPositionY(newPosY + newHei)
  thisCon = frameui.layEmeHeros:getContentSize()
  frameui.layEmeHeros:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  newPosY = frameui.defendTopImg:getPositionY()
  frameui.defendTopImg:setPositionY(newPosY + newHei)
  thisCon = frameui.defendTopImg:getContentSize()
  frameui.defendTopImg:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  frameui.defendTopImg:setPositionX(frameui.defendTopImg:getPositionX() + leftMoPosX / 2)
  frameui.toparena_star_icon_2:setPositionX(frameui.toparena_star_icon_2:getPositionX() + leftMoPosX * 0.45)
  frameui.defendTopStr:setPositionX(frameui.defendTopStr:getPositionX() + leftMoPosX * 0.45)
  frameui.defendTopName:setPositionX(frameui.defendTopName:getPositionX() + leftMoPosX * 0.45)
  frameui.search:setPositionX(frameui.search:getPositionX() + leftMoPosX * 0.45)
  frameui.enemyTeamTit:setStroke(ccc3(39, 37, 36), 1.5)
  frameui.yshe:setStroke(ccc3(39, 37, 36), 1.5)
  frameui.defendTopStr:setStroke(ccc3(39, 37, 36), 1.5)
  frameui.defendTopName:setStroke(ccc3(39, 37, 36), 1.5)
  local newPosX = frameui.eneTeamItem:getPositionX()
  newPosX = newPosX + leftMoPosX * 0.5
  newPosX = newPosX < 174 and 174 or newPosX
  frameui.eneTeamItem:setPositionX(newPosX)
  frameui.teamBtnStr_1:setFontName(ed.fontBold)
  frameui.teamBtnStr_2:setFontName(ed.fontBold)
  frameui.teamBtnStr_3:setFontName(ed.fontBold)
  frameui.teamBtnStr_4:setFontName(ed.fontBold)
  frameui.teamBtnStr_5:setFontName(ed.fontBold)
  frameui.layLeftButs:setClipRect(CCRectMake(0, 0, frameui.layLeftButs:getContentSize().width, frameui.layLeftButs:getContentSize().height))
  newPosY = frameui.layLeftButs:getPositionY()
  frameui.layLeftButs:setPositionY(newPosY + newHei)
  thisCon = frameui.heros_items:getContentSize()
  frameui.heros_items:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height + newHei))
  thisCon = frameui.isbg:getContentSize()
  frameui.isbg:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  frameui.butts_list:setPositionX(frameui.butts_list:getPositionX() + posXloc)
  frameui.lin_L:setPositionX(frameui.lin_L:getPositionX() + posXloc)
  frameui.lin_R:setPositionX(frameui.lin_R:getPositionX() + posXloc)
  frameui.preset:setPositionX(frameui.preset:getPositionX() + leftMoPosX)
  frameui.preset_back:setPositionX(frameui.preset_back:getPositionX() + leftMoPosX)
  thisCon = frameui.myTeam9Img_4:getContentSize()
  frameui.myTeam9Img_4:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  frameui.myTeam9Img_4:setPositionX(frameui.myTeam9Img_4:getPositionX() + leftMoPosX / 2)
  frameui.layTeamitems:setPositionX(frameui.layTeamitems:getPositionX() + leftMoPosX / 2)
  local thisCon9L = frameui.myTeam9Img_2:getContentSize()
  local thisCon9R = frameui.myTeam9Img_3:getContentSize()
  local thisCon9LrWne = thisCon9L.width / thisCon9R.width
  frameui.myTeam9Img_2:setContentSize(CCSizeMake(thisCon9L.width + (1 - thisCon9LrWne) * leftMoPosX, thisCon9L.height))
  frameui.myTeam9Img_3:setContentSize(CCSizeMake(thisCon9R.width + thisCon9LrWne * leftMoPosX, thisCon9R.height))
  frameui.myTeam9Img_3:setPositionX(frameui.myTeam9Img_3:getPositionX() + leftMoPosX)
  newPosX = frameui.Panel_right:getPositionX()
  frameui.Panel_right:setPositionX(newPosX + (1 - lrWne) * newWid)
  local rightMoPosX = lrWne * newWid
  thisCon = frameui.bgRig:getContentSize()
  frameui.bgRig:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, heightWin - 7.5))
  newPosX, newPosY = frameui.bgRig2:getPosition()
  local rightMoPosXLocal = rightMoPosX / 2
  frameui.bgRig2:setPosition(newPosX + rightMoPosXLocal, newPosY + newHei)
  frameui.Panel_Pages:setPositionX(frameui.Panel_Pages:getPositionX() + rightMoPosXLocal)
  frameui.Label_title:setPositionY(frameui.Label_title:getPositionY() + newHei)
  frameui.Label_title_Copy0:setPositionY(frameui.Label_title_Copy0:getPositionY() + newHei)
  frameui.Label_495:setPositionY(frameui.Label_495:getPositionY() + newHei)
  frameui.Label_495_Copy0:setPositionY(frameui.Label_495_Copy0:getPositionY() + newHei)
  frameui.image_rank_bg:setPositionY(frameui.image_rank_bg:getPositionY() + newHei)
  frameui.duanwei_txt:setPositionY(frameui.duanwei_txt:getPositionY() + newHei)
  frameui.name_bg:setPositionY(frameui.name_bg:getPositionY() + newHei)
  frameui.panel_duanwei:setPositionY(frameui.panel_duanwei:getPositionY() + newHei)
  frameui.qufu_txt:setPositionY(frameui.qufu_txt:getPositionY() + newHei)
  frameui.qufu:setPositionY(frameui.qufu:getPositionY() + newHei)
  frameui.label_gs:setPositionY(frameui.label_gs:getPositionY() + newHei)
  frameui.panel_gs:setPositionY(frameui.panel_gs:getPositionY() + newHei)
  frameui.Panel_headPos:setPositionY(frameui.Panel_headPos:getPositionY() + newHei)
  frameui.ImageView_497:setPositionY(frameui.ImageView_497:getPositionY() + newHei)
  return frameContainer, frameui
end

function addPresetLayer(self)
  local thisCon = self.ui.isbg:getContentSize()
  local btn = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_enter_button.png", CCRectMake(15, 15, 5, 5))
  btn:setContentSize(CCSizeMake(106, 35))
  btn:setPosition(ccp(thisCon.width - 60, thisCon.height / 2 + 20))
  self.ui.layUp_ButOrBg:addChild(btn)
  self.btnShowPresetLay = btn
  local icon = ed.createSprite("UI/alpha/1080P/battle/preset/preset_enter_icon.png")
  icon:setPosition(ccp(18, 18))
  btn:addChild(icon)
  local label = ed.createttf(T("\233\162\132\232\174\190\233\152\181\229\174\185"), 16)
  label:setPosition(ccp(66, 17))
  label:setColor(ccc3(ed.colorToStr("#fef1a9")))
  btn:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self:btRegisterButtonClick({
    button = btn,
    key = "btnPreset",
    clickHandler = function()
      if self.isTouch then
        return
      end
      showPresetLayer(self)
    end,
    pressScale = 0.95,
    force = true
  })
  local addHeight = 0
  if self.param.mode == "defend" then
    addHeight = 70
  end
  local layBgsSize = self.ui.layBgs:getContentSize()
  local presetBg = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_bg.png", CCRectMake(45, 70, 7, 16))
  presetBg:setContentSize(CCSizeMake(layBgsSize.width - 12, 350 + ed.display.halfFixedHeight * 2 + addHeight))
  presetBg:setPosition(ccp(layBgsSize.width / 2, layBgsSize.height / 2 + 30 + addHeight / 2))
  self.ui.layBgs:addChild(presetBg)
  self.touch = true
  local posX, posY = self.ui.heros_items:getPosition()
  local con = self.ui.heros_items:getContentSize()
  local info = {
    cliprect = CCRectMake(posX, posY, con.width, con.height),
    container = self.ui.Panel_left,
    zorder = 20,
    bar = {
      bglen = con.height,
      bgpos = ccp(posX, posY + con.height / 2)
    },
    doPressIn = function(_, y)
      return y
    end,
    cancelPressIn = function(_, y, oldy)
      self.touch = math.abs(oldy - y) < 20
    end,
    noshade = true
  }
  self.presetDraglist = ed.draglist.create(info)
  label = ed.createttf("", 15)
  label:setAnchorPoint(ccp(0.5, 0.5))
  label:setPosition(ccp(45, 30))
  label:setColor(ccc3(ed.colorToStr("#FFFFE5")))
  presetBg:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self.teamNumlabel = label
  local btn = ed.createSprite("UI/alpha/1080P/common/button_mini_red.png")
  btn:setPosition(ccp(thisCon.width - 60, thisCon.height / 2 + 20))
  self.ui.layUp_ButOrBg:addChild(btn)
  btn:setVisible(false)
  self.btnExitPresetLay = btn
  local label = ed.createttf(T("\233\128\128\229\135\186\233\162\132\232\174\190"), 16)
  label:setPosition(ccp(52, 21))
  label:setColor(ccc3(ed.colorToStr("#FFFFE5")))
  btn:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self:btRegisterButtonClick({
    button = btn,
    key = "btnPresetExit",
    clickHandler = function()
      if self.isTouch then
        return
      end
      showPresetLayer(self)
    end,
    pressScale = 0.95,
    force = true
  })
  presetBg:setVisible(false)
  self.presetDraglist:setVisible(false)
  self.presetBg = presetBg
  self.groupId = 1
  refreshPresetLayer(self)
  local posX, posY = self.ui.butts_list:getPosition()
  local con = self.ui.butts_list:getContentSize()
  local info = {
    cliprect = CCRectMake(posX, posY, con.width, con.height),
    container = self.ui.layUp_ButOrBg,
    zorder = 10,
    noshade = true
  }
  self.buttonDraglist = ed.draglist.create(info)
  self.buttonPress = {}
  local resConfig = {}
  for i = 1, 4 do
    resConfig[i] = {}
    resConfig[i].textImg = string.format("UI/alpha/1080P/battle/preset/preset_num_%d.png", i)
    resConfig[i].button = "UI/alpha/1080P/battle/preset/preset_choose2_button.png"
    resConfig[i].press = "UI/alpha/1080P/battle/preset/preset_choose_button.png"
  end
  local posX = posX + 31
  local buttonIndex, widths = 0, 70
  for i, res in ipairs(resConfig) do
    buttonIndex = buttonIndex + 1
    local button = ed.createSprite(res.button)
    local press = ed.createSprite(res.press)
    local textImg = ed.createSprite(res.textImg)
    button:setPosition(ccp(posX + (buttonIndex - 1) * widths + 20, con.height - 5))
    press:setPosition(ccp(posX + (buttonIndex - 1) * widths + 20, con.height - 5))
    textImg:setPosition(ccp(posX + (buttonIndex - 1) * widths + 21, con.height - 5))
    button:setScale(0.9)
    press:setScale(0.9)
    self.buttonDraglist.listLayer:addChild(button)
    self.buttonDraglist.listLayer:addChild(press)
    self.buttonDraglist.listLayer:addChild(textImg)
    press:setVisible(self.groupId == i)
    self.buttonPress[i] = press
    self:btRegisterButtonClick({
      button = button,
      key = "listButton" .. i,
      clickHandler = function()
        if self.isTouch then
          return
        end
        if self.groupId ~= i then
          self.refreshIdx = nil
          self.buttonPress[self.groupId]:setVisible(false)
          self.groupId = i
          refreshPresetLayer(self)
          self.buttonPress[self.groupId]:setVisible(true)
          refreshpreseHeros(self)
        end
      end,
      pressScale = 0.85,
      normalScale = 0.9,
      force = true
    })
  end
  self.buttonDraglist:initListWidth(buttonIndex * widths)
  self.buttonDraglist:setVisible(false)
  self:listenEvent("scene_preset_reply", function(info)
    self.refreshIdx = nil
    local indexId, groupId = ed.presetData.analyzePreseIds(info.refreshIdx)
    if self.groupId ~= groupId then
      self.buttonPress[self.groupId]:setVisible(false)
      self.groupId = groupId
      self.buttonPress[self.groupId]:setVisible(true)
    end
    self.refreshIdx = indexId
    refreshPresetLayer(self)
    refreshpreseHeros(self)
  end)
end

function onClickBtnSwitchPreset(self, groupId, indexId)
  local switchIds = ed.presetData.packPreseIds(indexId, groupId)
  if not self.switchIds then
    self.switchIds = switchIds
    refreshSwitchPresetItem(self)
  else
    ed.presetNetwork.switchLineupReq(self.switchIds, switchIds)
    self.switchIds = nil
    refreshSwitchPresetItem(self)
  end
end

function refreshSwitchPresetItem(self)
  for index, teamItem in ipairs(self.presetTeamItemList or {}) do
    if self.switchIds then
      teamItem.settingImgMask:setVisible(true)
      ed.setTexture(teamItem.imageSwitch, "UI/alpha/1080P/setting/setting_arrow_icon.png")
      teamItem.passImgMask:setVisible(true)
    else
      teamItem.settingImgMask:setVisible(false)
      ed.setTexture(teamItem.imageSwitch, "UI/alpha/1080P/setting/setting_exchange_icon.png")
      teamItem.passImgMask:setVisible(false)
    end
  end
end

function refreshPresetLayer(self)
  local con = self.ui.heros_items:getContentSize()
  local layBgsSize = self.ui.layBgs:getContentSize()
  self.teamNumlabel:setString(ed.presetData.teamNum .. "/" .. ed.presetData.preseMaxTeam)
  self.presetDraglist:clearList()
  for i, v in ipairs(self.btnToucRemovehKey or {}) do
    self:btRemoveMainTouchHandler({key = v})
  end
  self.btnToucRemovehKey = {}
  self.heroPresetIcons = {}
  self.presetTeamItemList = {}
  local showPosy, itemhand
  local posY, height, sizeH = con.height + 130, 10, 90
  for i, v in ipairs(ed.presetData.getPreseInfo(self.groupId)) do
    local itemBg = ed.createScale9Sprite("UI/alpha/1080P/skilltower/bg_had_get.png", CCRectMake(45, 70, 7, 16))
    itemBg:setContentSize(CCSizeMake(layBgsSize.width - 30, sizeH - 3))
    self.presetDraglist:addItem(itemBg, ccp(layBgsSize.width / 2 + 66, posY))
    table.insert(self.presetTeamItemList, itemBg)
    local leftImg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_number_bg.png")
    leftImg:setPosition(layBgsSize.width / 9 - 20, sizeH / 2)
    itemBg:addChild(leftImg, 99)
    leftImg:setScale(0.8)
    local label = ed.createttf(v.name or "", 14)
    label:setAnchorPoint(ccp(0.5, 0.5))
    label:setPosition(ccp(65.5, 35))
    label:setColor(ccc3(ed.colorToStr("#FFFFE5")))
    leftImg:addChild(label)
    ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
    local posx = layBgsSize.width / 8 - 18
    local width = 60 + (layBgsSize.width / 11 - 60)
    width = ed.clamp(width, 60, 100)
    local heros = v.heros or {}
    for s = 1, 5 do
      if heros[s] then
        local hero = ed.readhero.createIconByID(heros[s], {state = "idle", isShowLegendEquip = true})
        hero.icon:setPosition(posx + (6 - s) * width, sizeH / 2)
        itemBg:addChild(hero.icon)
        hero.icon:setScale(0.75)
        hero:showLegendEquip(ed.off_legendEquipOp)
        table.insert(self.heroPresetIcons, {
          id = heros[s],
          hero = hero
        })
      else
        local heroBg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_enemy_head.png")
        heroBg:setPosition(posx + (6 - s) * width, sizeH / 2 - 0.5)
        itemBg:addChild(heroBg)
        heroBg:setScale(1.05)
      end
    end
    local settingImg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_round_button.png")
    settingImg:setPosition(layBgsSize.width * 0.685, sizeH / 2)
    itemBg:addChild(settingImg)
    local btnImgTop = ed.createSprite("UI/alpha/1080P/setting/setting_edit_icon.png")
    btnImgTop:setPosition(21, 22)
    settingImg:addChild(btnImgTop)
    settingImg:setScale(0.9)
    btnImgTop:setScale(0.76)
    local settingImgMask = ed.createSprite("UI/alpha/1080P/setting/setting_circle_bg_dark.png")
    settingImg:addChild(settingImgMask)
    settingImgMask:setPosition(21, 22)
    settingImgMask:setVisible(false)
    itemBg.settingImg = settingImg
    itemBg.settingImgMask = settingImgMask
    local btnSwitch = ed.createSprite("UI/alpha/1080P/battle/preset/preset_round_button.png")
    btnSwitch:setPosition(layBgsSize.width * 0.755, sizeH / 2)
    itemBg:addChild(btnSwitch)
    local imageSwitch = ed.createSprite("UI/alpha/1080P/setting/setting_exchange_icon.png")
    imageSwitch:setPosition(21, 22)
    btnSwitch:addChild(imageSwitch)
    btnSwitch:setScale(0.9)
    itemBg.btnSwitch = btnSwitch
    itemBg.imageSwitch = imageSwitch
    self:btRegisterButtonClick({
      button = settingImg,
      key = "settingImg" .. i,
      clickInterval = 1,
      clickHandler = function(param, x, y)
        if self.switchIds then
          return
        end
        if self.isTouch then
          return
        end
        if self.touch then
          if not ed.containsPoint(self.ui.heros_items, x, y) then
            return
          end
          ed.UITool.openView("presetScene", {
            groupId = self.groupId,
            teamIdx = v.indexId,
            notAdd = true
          })
        end
      end,
      pressScale = 0.85,
      normalScale = 0.9,
      force = true
    })
    self:btRegisterButtonClick({
      button = btnSwitch,
      key = "btnSwitch" .. i,
      clickInterval = 0.3,
      clickHandler = function(param, x, y)
        onClickBtnSwitchPreset(self, self.groupId, v.indexId)
      end,
      pressScale = 0.85,
      normalScale = 0.9,
      force = true
    })
    table.insert(self.btnToucRemovehKey, "settingImg" .. i)
    table.insert(self.btnToucRemovehKey, "btnSwitch" .. i)
    local passImg = ed.createScale9Sprite("UI/alpha/1080P/common/button_com_mini.png", CCRectMake(10, 10, 81.5, 20))
    passImg:setContentSize(CCSizeMake(90, 44))
    passImg:setPosition(layBgsSize.width * 0.86, sizeH / 2)
    itemBg:addChild(passImg)
    passImg:setScale(0.9)
    local label = ed.createttf("\228\189\191\231\148\168", 16)
    label:setPosition(ccp(45, 22))
    label:setColor(ccc3(ed.colorToStr("#FCF1A6")))
    passImg:addChild(label)
    ed.setLabelShadow(label, ccc3(0, 0, 0), ccp(0, 2))
    itemBg.passImg = passImg
    local passImgMask = ed.createScale9Sprite("UI/alpha/1080P/setting/setting_rectangle_bg_dark.png")
    passImgMask:setContentSize(CCSizeMake(88, 42))
    passImg:addChild(passImgMask)
    passImgMask:setPosition(ccp(45, 23))
    passImgMask:setVisible(false)
    itemBg.passImgMask = passImgMask
    self:btRegisterButtonClick({
      button = passImg,
      key = "passImg" .. i,
      clickInterval = 0.2,
      clickHandler = function(param, x, y)
        if self.switchIds then
          return
        end
        if self.isTouch then
          return
        end
        if not self.touch then
          return
        end
        if not ed.containsPoint(self.ui.heros_items, x, y) then
          return
        end
        self.isTouch = true
        self.teamIdxInfo[self.newTeamIdx] = excludeHeros(self, ed.copyTable(v.heros or {}))
        self.herosDragList:refresh({})
        self.newTeamDragList:refresh({
          newTeamIdx = self.newTeamIdx,
          teamIdxInfo = self.teamIdxInfo,
          updateAllIdPos = true,
          notActmove = true
        })
        self:refreshGs()
        refreshpreseHeros(self)
        self:listenTimer(Timer:Once(0.2), function()
          self.isTouch = false
        end)
      end,
      pressScale = 0.85,
      normalScale = 0.9,
      force = true
    })
    table.insert(self.btnToucRemovehKey, "passImg" .. i)
    posY = posY - sizeH
    height = height + sizeH
    if self.refreshIdx == v.indexId then
      showPosy = height
      itemhand = itemBg
    end
  end
  self.switchIds = nil
  refreshSwitchPresetItem(self)
  local addTeamImgBg = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_addteam_bg.png", CCRectMake(45, 40, 5, 25))
  addTeamImgBg:setContentSize(CCSizeMake(layBgsSize.width - 20, sizeH + 4))
  addTeamImgBg:setPosition(layBgsSize.width / 2 + 68, posY)
  self.presetDraglist.listLayer:addChild(addTeamImgBg)
  height = height + sizeH
  local addImg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_add.png")
  addImg:setPosition(layBgsSize.width * 0.3, sizeH / 2)
  addTeamImgBg:addChild(addImg)
  addImg:setScale(1.24)
  local label = ed.createttf(T("\231\130\185\229\135\187\229\162\158\229\138\160\230\150\176\233\162\132\232\174\190\233\152\181\229\174\185"), 24)
  label:setPosition(ccp(layBgsSize.width * 0.51, sizeH / 2))
  label:setColor(ccc3(ed.colorToStr("#FFFCE7")))
  addTeamImgBg:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#674907")), 1)
  ed.layout.horizontalSortNode({addImg, label}, {-10, 0}, layBgsSize.width * 0.5)
  self:btRegisterButtonClick({
    button = addTeamImgBg,
    key = "addTeamImgBg",
    clickInterval = 1,
    clickHandler = function(param, x, y)
      if self.isTouch then
        return
      end
      if not self.touch then
        return
      end
      if not ed.containsPoint(self.ui.heros_items, x, y) then
        return
      end
      if not ed.presetData.canAdd() then
        ed.showToast("\233\152\181\229\174\185\230\149\176\233\135\143\229\183\178\232\190\190\228\184\138\233\153\144\239\188\129")
        return
      end
      local teamIdx = ed.presetData.getPreseTeamNewIndexId(self.groupId)
      if teamIdx then
        ed.UITool.openView("presetScene", {
          groupId = self.groupId,
          teamIdx = teamIdx,
          notAdd = false
        })
      else
        error("\230\151\160\230\179\149\229\162\158\229\138\160\233\152\181\229\174\185")
      end
    end,
    pressScale = 0.98,
    force = true
  })
  table.insert(self.btnToucRemovehKey, "addTeamImgBg")
  self.presetDraglist:initListHeight(height)
  if showPosy then
    showPosy = showPosy - (con.height + 130) / 2
    showPosy = ed.clamp(showPosy, 0, height - con.height)
    showPosy = showPosy < 0 and 0 or showPosy
    self.presetDraglist.listLayer:setPositionY(showPosy)
    local move1 = CCEaseBackOut:create(CCMoveBy:create(0.1, ccp(-5, 0)))
    local move2 = CCEaseBackOut:create(CCMoveBy:create(0.2, ccp(8, 0)))
    local move3 = CCEaseBackOut:create(CCMoveBy:create(0.1, ccp(-3, 0)))
    local sequence = CCSequence:create(ccArrayMake(move1, move2, move3))
    itemhand:runAction(sequence)
  end
end

function excludeHeros(self, heros)
  local goStageId = {}
  for i, v in ipairs(self.teamIdxInfo) do
    for ii, vv in ipairs(v) do
      goStageId[vv] = i
    end
  end
  local newHeros = {}
  for i, v in ipairs(heros) do
    if (not goStageId[v] or goStageId[v] == self.newTeamIdx) and not ed.isElementInTable(v, self.banedHeroIdList) then
      table.insert(newHeros, v)
    end
  end
  return newHeros
end

function refreshpreseHeros(self)
  local goStageId = {}
  for i, v in ipairs(self.teamIdxInfo) do
    for ii, vv in ipairs(v) do
      goStageId[vv] = i
    end
  end
  for i, v in ipairs(self.heroPresetIcons) do
    if goStageId[v.id] then
      v.hero:showSelectTag()
      v.hero:addLegendArenaTeamInfo({
        team_index = goStageId[v.id],
        peakArena = true
      })
      local posx, posy = v.hero.team_info_node:getPosition()
      v.hero.team_info_node:setPosition(posx - 10, posy - 7)
    else
      v.hero:deleteSelectTag()
      v.hero:RemoveTeamInfo()
    end
    local isBaned = ed.isElementInTable(v.id, self.banedHeroIdList)
    if isBaned then
      v.hero:addPeakArenaBanTag()
    end
  end
end

function showPresetLayer(self)
  local isShow = self.presetBg:isVisible()
  self.presetBg:setVisible(not isShow)
  self.ui.butts_list:setVisible(isShow)
  self.herosDragList.draglist:setVisible(isShow)
  self.ui.isbg:setVisible(isShow)
  self.btnShowPresetLay:setVisible(isShow)
  self.btnExitPresetLay:setVisible(not isShow)
  self.presetDraglist:setVisible(not isShow)
  self.buttonDraglist:setVisible(not isShow)
  if not isShow then
    refreshpreseHeros(self)
  end
end

return M
