local Module = {}
ed.presetModule = Module
local lsr = ed.ui.battlepreparepeakarenalsr.create()
local member_count_max = 5
local karl_hero_tid = 53
local teamName = {}

function teamName:init(scene, param)
  self.scene = scene
  self.param = param
  self.callbackOver = param.callbackOver
  self.editbox = ed.UITool.createEditBox(scene.ui.panel_input, {
    placeHolder = T(""),
    maxLength = 7
  }, true)
  scene.editbox = self.editbox
  self.editbox:setString(param.info.teamName or "")
  self.editbox.edit:registerScriptEditBoxHandler(function(type, edit)
    if type == "began" then
    elseif type == "return" or type == "ended" then
      local teamName = self.editbox:getString()
      local _, count = string.gsub(teamName, "[^\128-\193]", "")
      if "" == teamName then
        ed.showToast(T("\233\162\132\232\174\190\229\144\141\231\167\176\228\184\141\232\131\189\228\184\186\231\169\186"))
        teamName = param.info.teamName
      elseif count > (ed.isAreaZhCn() and 7 or 13) then
        local tip = ed.isAreaZhCn() and T("\233\162\132\232\174\190\229\144\141\231\167\176\228\184\141\229\190\151\232\182\133\232\191\1357\228\184\170\229\173\151") or T("\233\162\132\232\174\190\229\144\141\231\167\176\228\184\141\229\190\151\232\182\133\232\191\13513\228\184\170\229\173\151\231\172\166")
        ed.showToast(tip)
        teamName = param.info.teamName
      elseif ed.dirtyword_check(teamName) then
        ed.showToast(T("\229\144\171\230\156\137\233\157\158\230\179\149\229\173\151\232\175\141\239\188\140\232\175\183\233\135\141\230\150\176\232\190\147\229\133\165"))
        teamName = param.info.teamName
      end
      if self.editbox:getString() ~= teamName then
        self.editbox:setString(teamName or "")
      else
        self.callbackOver({
          teamName = self.editbox:getString()
        })
      end
    end
  end)
  return self
end

function teamName:update(info)
  self.param.info.teamName = info.teamName
  self.editbox:setString(info.teamName)
end

Module.teamName = teamName
local sategoryBtns = {}

function sategoryBtns:init(scene, param)
  self.scene = scene
  self.param = param
  self.callbackOver = param.callbackOver
  self.btns = {}
  local con = scene.ui.butts_list:getContentSize()
  for i, v in ipairs(self.param.info.btnStr) do
    local button = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png")
    local press = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png")
    local label = ed.createLabelTTF(v[2], 18)
    ed.setLabelFontInfo(label, "dark_white_stroke")
    button:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    press:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    label:setPosition(ccp(i * 72 - 22, con.height / 2 - 3))
    scene.ui.butts_list:addChild(button)
    scene.ui.butts_list:addChild(press)
    scene.ui.butts_list:addChild(label)
    press:setVisible(self.param.index == i)
    table.insert(self.btns, {
      type = v[2],
      press = press,
      label = label,
      button = button
    })
    scene:btRegisterButtonClick({
      button = button,
      key = "btnsDragListBtn" .. i,
      param = {index = i},
      clickHandler = function(param)
        if self.param.index ~= param.index then
          self:update(param.index)
          self.param.callbackOver(param.index)
        else
          self:update(param.index)
        end
      end,
      force = true,
      pressScale = 0.95,
      normalScale = 1
    })
  end
  return self
end

function sategoryBtns:update(index)
  self.param.index = index
  for i, v in ipairs(self.btns) do
    v.press:setVisible(self.param.index == i)
  end
end

Module.sategoryBtns = sategoryBtns
local teamIdxDragList = {}

function teamIdxDragList:init(scene, param)
  self.param = param
  self.sceneSelf = scene
  self:create(param)
  return self
end

function teamIdxDragList:create()
  local info = self.param.info
  local newTeamIdx = info.newTeamIdx
  local teamCount = info.team_count
  self.btns = {}
  self.thisCon = self.sceneSelf.ui.panel_btn_list:getContentSize()
  self.draglist = ed.draglist.create({
    cliprect = CCRectMake(0, 0, self.thisCon.width, self.thisCon.height),
    container = self.sceneSelf.ui.panel_btn_list,
    cancelClickIn = function(x, y, btn)
      if btn then
        btn.btnBg:setScale(1)
        self.cancelClick = false
      end
    end,
    doPressIn = function(x, y)
      for i, v in ipairs(self.btns or {}) do
        if ed.containsPoint(v.bg, x, y) then
          self.cancelClick = true
          v.btnBg:setScale(0.95)
          return v
        end
      end
    end,
    cancelPressIn = function(x, y, btn)
      if btn and self.cancelClick then
        btn.btnBg:setScale(1)
        self:refresh(btn.index)
        self.param.callbackOver(btn.index)
      end
    end
  })
  local height, sizeH = 76, 76
  for i = 1, teamCount do
    local bg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_choose_bg.png")
    bg:setPosition(ccp(self.thisCon.width / 2, self.thisCon.height - sizeH * i))
    self.draglist.listLayer:addChild(bg)
    if newTeamIdx ~= i then
      bg:setOpacity(5)
    end
    local btnBg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_choose2_button.png")
    btnBg:setPosition(ccp(self.thisCon.width / 2, self.thisCon.height - sizeH * i))
    self.draglist.listLayer:addChild(btnBg)
    local btnTop = ed.createSprite("UI/alpha/1080P/battle/preset/preset_choose_button.png")
    btnTop:setPosition(ccp(self.thisCon.width / 2, self.thisCon.height - sizeH * i))
    self.draglist.listLayer:addChild(btnTop)
    local textImg = ed.createSprite(string.format("UI/alpha/1080P/battle/preset/preset_num_%d.png", i))
    textImg:setPosition(ccp(self.thisCon.width / 2 + 1, self.thisCon.height - sizeH * i))
    self.draglist.listLayer:addChild(textImg)
    if newTeamIdx ~= i then
      btnTop:setOpacity(5)
    end
    height = height + sizeH
    table.insert(self.btns, {
      bg = bg,
      textImg = textImg,
      btnBg = btnBg,
      btnTop = btnTop,
      isShow = newTeamIdx == i,
      index = i
    })
  end
  self.draglist:initListHeight(height)
  return self
end

function teamIdxDragList:refresh(newTeamIdx)
  local function showBtn(btn, vis)
    if btn.isShow ~= vis then
      btn.bg:runAction(CCFadeTo:create(0.2, vis and 255 or 5))
      
      btn.btnTop:runAction(CCFadeTo:create(0.2, vis and 255 or 5))
      btn.isShow = vis
    end
  end
  
  if self.param.info.newTeamIdx ~= newTeamIdx then
    for i, v in ipairs(self.btns) do
      showBtn(v, newTeamIdx == i)
    end
  end
  self.param.info.newTeamIdx = newTeamIdx
end

Module.teamIdxDragList = teamIdxDragList
local presetHerosDragList = {}

function presetHerosDragList:init(scene, param)
  self.param = param
  self.sceneSelf = scene
  self:createDragList(param)
  return self
end

function presetHerosDragList:getIndexToPosFun()
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

function presetHerosDragList:getTeamIndex(id)
  for i, v in ipairs(self.param.info.teamIdxInfo) do
    if ed.isElementInTable(id, v) then
      return i
    end
  end
end

function presetHerosDragList:createDragList(param)
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
      for i, v in ipairs(self.newShowIndex or {}) do
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
        self:doClickInList(hero)
      end
    end
  })
  local info = param.info
  local allTabs = info.heroCategoryInfo
  local teamTabs = info.teamIdxInfo
  local getpos = self:getIndexToPosFun()
  self.newShowIndex = {}
  for i, v in ipairs(allTabs) do
    local hero = ed.readhero.createIconByID(v._tid, {
      state = "idle",
      isShowLegendEquip = ed.openLegendEquip()
    })
    local team_index = self:getTeamIndex(v._tid)
    if team_index and team_index == self.sceneSelf.newTeamIdx then
      hero:showSelectTag()
    end
    if not ed.player.heroes[v._tid] then
      hero:addStateInfo("noOwn")
      hero.noOwn = true
    end
    v.readhero = hero
    self.draglist:addItem(hero.icon)
    hero.icon:setPosition(getpos(i))
    hero.allIndex = i
    hero:showKarlElement(self.showElement)
    hero:showLegendEquip(ed.off_legendEquipOp)
    table.insert(self.newShowIndex, hero)
  end
  self.draglist:initListHeight(self.listHeight)
end

function presetHerosDragList:refresh(info)
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
      local team_index = self:getTeamIndex(v._tid)
      hero:deleteSelectTag()
      if team_index then
        if team_index == self.sceneSelf.newTeamIdx then
          hero:showSelectTag()
        end
      else
        hero:RemoveTeamInfo()
      end
      hero:showLegendEquip(ed.off_legendEquipOp)
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

function presetHerosDragList:doClickInList(hero)
  local info = self.param.info
  local allTabs = info.heroCategoryInfo
  local teamTabs = info.teamIdxInfo
  if hero.noOwn then
    ed.showToast(T("\229\176\154\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
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
  table.insert(teamTabs[self.sceneSelf.newTeamIdx], allTabs[hero.allIndex]._tid)
  hero.teamid = self.sceneSelf.newTeamIdx
  self.param.callbackOver({
    heroCategoryInfo = allTabs,
    teamIdxInfo = teamTabs,
    updateAllIdPos = true
  })
end

Module.presetHerosDragList = presetHerosDragList
local newTeamDragList = {}

function newTeamDragList:init(scene, param)
  self.param = param
  self.sceneSelf = scene
  self:create(param)
  return self
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
    local hero = ed.readhero.createIconByID(v, {
      state = "idle",
      isShowLegendEquip = ed.openLegendEquip()
    })
    hero:showLegendEquip(ed.off_legendEquipOp)
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
  self:refreshGs()
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
  local oripos = self.sceneSelf.presetHerosDragList.draglist.listLayer:convertToWorldSpace(ccp(icon:getPosition()))
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
        hero = ed.readhero.createIconByID(v, {
          state = "idle",
          isShowLegendEquip = ed.openLegendEquip()
        })
        self.sceneSelf.ui.layTeamitems:addChild(hero.icon)
        hero.icon:setPosition(getDragListIdxPos(self, v, hero.icon))
        local newIdx = getIdIndex(newTeams, v)
        hero.icon:stopAllActions()
        local x, y = self.sceneSelf.ui["member_light_" .. 6 - newIdx]:getPosition()
        hero.icon:runAction(CCSpawn:create(ccArrayMake(CCFadeIn:create(0.2), CCMoveTo:create(0.2, ccpAdd(ccp(x, y), ccp(0, 10))))))
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
        v.hero.icon:runAction(CCSpawn:create(ccArrayMake(CCFadeOut:create(0.2), CCMoveTo:create(0.35, ccp(getDragListIdxPos(self, k, v.hero.icon))))))
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
  self:refreshGs()
  self:refreshKarlElementByTeam()
  self:refreshDraglistKarlElement()
end

function newTeamDragList:refreshGs()
  local newTeams = self.param.info.teamIdxInfo[self.param.info.newTeamIdx]
  local totalGs = 0
  for _, heroId in pairs(newTeams or {}) do
    local hero = ed.player:getHero(heroId)
    if hero then
      totalGs = totalGs + hero._gs
    end
  end
  ed.setString(self.sceneSelf.ui.gs, totalGs)
end

function newTeamDragList:refreshDraglistKarlElement()
  for key, value in pairs(self.myTeamIcon) do
    if nil ~= value then
      value.hero:showKarlElement(self.showElement)
    end
  end
  for key, value in pairs(self.sceneSelf.heroCategoryInfo) do
    if nil ~= value then
      value.readhero:showKarlElement(self.showElement)
    end
  end
end

function newTeamDragList:refreshKarlElementByTeam()
  local showState = false
  local newTeams = self.param.info.teamIdxInfo[self.param.info.newTeamIdx]
  for _, heroId in pairs(newTeams or {}) do
    local hero = ed.player:getHero(heroId)
    if hero._tid == karl_hero_tid then
      showState = true
    end
  end
  self.showElement = showState
end

function newTeamDragList:refreshLegendEquip()
  for key, value in pairs(self.myTeamIcon) do
    if nil ~= value then
      value.hero:showLegendEquip(ed.off_legendEquipOp)
    end
  end
end

Module.newTeamDragList = newTeamDragList

function Module.editorui(sceneSelf)
  local mainLayer = sceneSelf.mainLayer
  local frameContainer, frameui = ed.editorui(ed.uieditor.preparePresetScene)
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
  local newPosY = frameui.layEmeHeros:getPositionY()
  frameui.layEmeHeros:setPositionY(newPosY + newHei)
  thisCon = frameui.layEmeHeros:getContentSize()
  frameui.layEmeHeros:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  frameui.yshe:setStroke(ccc3(39, 37, 36), 1.5)
  local newPosX
  thisCon = frameui.heros_items:getContentSize()
  frameui.heros_items:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height + newHei))
  thisCon = frameui.isbg:getContentSize()
  frameui.isbg:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  frameui.butts_list:setPositionX(frameui.butts_list:getPositionX() + posXloc)
  frameui.lin_L:setPositionX(frameui.lin_L:getPositionX() + posXloc)
  frameui.lin_R:setPositionX(frameui.lin_R:getPositionX() + posXloc)
  frameui.preset:setPositionX(frameui.preset:getPositionX() + leftMoPosX)
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
  frameui.ImageView_line:setPosition(frameui.ImageView_line:getPositionX() + rightMoPosXLocal, frameui.ImageView_line:getPositionY() + newHei)
  frameui.ImageView_line2:setPosition(frameui.ImageView_line2:getPositionX() + rightMoPosXLocal, frameui.ImageView_line2:getPositionY())
  frameui.Label_title:setPosition(newPosX + rightMoPosXLocal, heightWin - 35)
  frameui.ImageView_6285:setPositionX(frameui.ImageView_6285:getPositionX() + posXloc)
  thisCon = frameui.panel_btn_list:getContentSize()
  frameui.panel_btn_list:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height + newHei))
  thisCon = frameui.panel_btn_list:getContentSize()
  frameui.img_btn_delete:setPositionX(thisCon.width * 0.25)
  frameui.img_btn_set:setPositionX(thisCon.width * 0.75)
  return frameContainer, frameui
end
