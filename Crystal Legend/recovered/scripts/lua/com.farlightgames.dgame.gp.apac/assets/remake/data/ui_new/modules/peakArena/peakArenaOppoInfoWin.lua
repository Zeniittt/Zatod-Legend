local base = ed.ui.popwindow
local peakArenaOppoInfoWin = newclass(base.mt)
ed.ui.peakArenaOppoInfoWin = peakArenaOppoInfoWin

function peakArenaOppoInfoWin:initData(params, canChallenge, callback)
  self.canChallenge = canChallenge
  self.data = params or {}
  self.mgr = ed.PeakArenaManager
  self.callback = callback
end

function peakArenaOppoInfoWin:initLabels()
  ed.setLabelStroke(self.ui.title, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.name, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.zone2, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.server2, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.score2, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.guild2, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.zonerank2, ed.toccc3(3087902), 1)
  ed.setLabelStroke(self.ui.label_team1, ed.toccc3(11954462), 1)
  ed.setLabelStroke(self.ui.label_team2, ed.toccc3(3890862), 1)
  ed.setLabelStroke(self.ui.label_team3, ed.toccc3(12273222), 1)
  ed.setLabelStroke(self.ui.label_team4, ed.toccc3(6098306), 1)
  ed.setLabelStroke(self.ui.label_team5, ed.toccc3(1921631), 1)
  ed.setLabelStroke(self.ui.label_gs_tips, ed.toccc3(11821085), 1)
  self.ui.label_gs_tips:setFontName(ed.fontBold)
  self.ui.server1:limitWidthByScale(75)
  self.ui.grade1:limitWidthByScale(75)
  self.ui.zone1:limitWidthByScale(75)
  self.ui.guild1:limitWidthByScale(75)
  self.ui.zonerank1:limitWidthByScale(75)
  self.ui.score1:limitWidthByScale(75)
end

function peakArenaOppoInfoWin:createHeroIcon(hero, isHidden)
  local heroIconItem = ed.readhero.createIconByServer(hero, {state = "idle"})
  heroIconItem:showLegendEquip(not ed.openLegendEquip())
  if isHidden then
    heroIconItem:addShade()
    local icon = heroIconItem.icon
    local iconHidden = ed.createSprite("UI/alpha/1080P/topArena/toparena_team_invisible.png")
    iconHidden:setScale(2)
    local size = icon:getContentSize()
    iconHidden:setPosition(ccp(size.width - 15, size.height - 15))
    icon:addChild(iconHidden, 10)
  end
  return heroIconItem.icon
end

function peakArenaOppoInfoWin:initUI()
  ed.editorui(ed.uieditor.PeakArenaOppoInfoWin, {
    container = self.container,
    ui = self.ui
  })
  self:initLabels()
  ed.left2(self.ui.title_left, self.ui.title, 10)
  ed.right2(self.ui.title_right, self.ui.title, 10)
  local grade = ed.createSprite(ed.PeakArenaManager:getGradeTextRes(self.data._grade or 1))
  grade:setAnchorPoint(ccp(0, 0.5))
  ed.UITool.replaceUI(self.ui, "bg", "grade2", grade)
  self.ui.grade2:setPositionX(self.ui.grade2:getPositionX() - 15)
  local maxgradeIconWidth = self.ui.score1:getPositionX() - 5 - (self.ui.grade1:getPositionX() + self.ui.grade1:getContentSize().width + 5)
  local adaptScale = math.min(maxgradeIconWidth / (self.ui.grade2:getContentSize().width * 0.5), 1) * 0.5
  grade:setScale(adaptScale)
  local summary = self.data._summary
  local guildName = summary._guild_name or ""
  local score = self.data._score
  local roleGs = self.data._gs
  local zoneRank = self.data._zone_rank
  if self.mgr.masked.isMasked(self.data._grade) then
    summary._name = self.mgr.masked.name
    summary._avatar = self.mgr.masked.avatar
    guildName = self.mgr.masked.guild
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
    if zoneRank then
      local length = ed.getIntNumLenght(zoneRank)
      zoneRank = ""
      for _ = 1, length do
        zoneRank = zoneRank .. "?"
      end
    end
  end
  local gsNode = ed.getNumberNode({
    text = roleGs or 0,
    folder = "hero_gs"
  }).node
  ed.UITool.replaceUI(self.ui, "bg_gs", "label_gs", gsNode)
  gsNode:setPositionX(self.ui.label_gs_tips:getContentSize().width + self.ui.label_gs_tips:getPositionX() + gsNode:getContentSize().width / 2 + 20)
  if self.mgr.masked.isMasked(self.data._grade) then
    ed.setString(self.ui.server2, "???")
  else
    ed.setString(self.ui.server2, self.data._svr_name)
  end
  self.ui.server2:limitWidthByScale(80)
  if self.mgr.masked.isMasked(self.data._grade) then
    ed.setString(self.ui.zone2, "???")
  else
    ed.setString(self.ui.zone2, string.format(T("\231\172\172%d\232\181\155\229\140\186"), self.data._zone))
  end
  self.ui.zone2:limitWidthByScale(80)
  ed.setString(self.ui.score2, score)
  ed.setString(self.ui.zonerank2, zoneRank or T("\230\156\170\228\184\138\230\166\156"))
  if self.mgr:isEvolving() then
    ed.setString(self.ui.zonerank2, T("\229\134\187\231\187\147\228\184\173"))
  end
  if self.mgr.masked.isMasked(self.data._grade) then
    ed.setString(self.ui.name, summary._name)
  else
    local name = ed.getPlayerName(ed.transBotName(summary._name), summary._medal, {
      anchorPoint = self.ui.name:getAnchorPoint()
    })
    ed.UITool.replaceUI(self.ui, "bg", "name", name)
    name:setScale(1.1)
  end
  local param = {
    id = summary._avatar,
    level = summary._level,
    lvoffset = {x = -47, y = -38}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(self.ui, "bg", "icon", head)
  ed.setString(self.ui.guild2, guildName)
  local teamCount = not (not (self.data._grade >= self.mgr.reserve.grade) or ed.isAreaOverSea()) and 5 or 3
  for i = 1, teamCount do
    local team = self.data._teams[i] or {}
    local isHidden = false
    for index, info in ipairs(team._heroes or {}) do
      if not info._tid or info._tid == 0 then
        isHidden = true
        break
      end
    end
    if not isHidden then
      ed.PeakArenaPvpBattlePrepareData.sortHeroesByAttackRange(team._heroes or {})
    end
    for k, hero in ipairs(team._heroes or {}) do
      local icon
      if hero._tid == 0 then
        icon = ed.ui.peakArenaUITool.createHideIcon()
        icon:setScale(0.72)
        icon:setPosition(ccp(60 + k * 67, 36))
      else
        hero = ed.copyProto(hero)
        hero._fashion = nil
        local heroInfo = ed.readhero.createIconByServer(hero, {state = "idle"})
        icon = heroInfo.icon
        heroInfo:showLegendEquip(not ed.openLegendEquip())
        self:btRegisterButtonClick({
          button = icon,
          key = "icon" .. hero._tid,
          clickHandler = function()
            if self.notPass then
              return
            end
            ed.ui.checkOthersHeroWindow.create(hero):popWindow()
          end,
          force = true
        })
        icon:setScale(0.8)
        icon:setPosition(ccp(60 + k * 67, 38))
      end
      self.ui["bg_team" .. i]:addChild(icon)
    end
  end
  if not self.canChallenge then
    self.ui.btn_battle:setVisible(false)
  end
end

function peakArenaOppoInfoWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    clickHandler = function()
      self:destroy()
    end,
    key = "clickout"
  })
  ed.UITool.registerBtn(self, "btn_battle", function()
    if self.callback then
      self.callback()
      self:destroy({skipAnim = true})
    end
  end)
  if self.data._grade >= self.mgr.reserve.grade and not ed.isAreaOverSea() then
    local size = self.ui.item_layer:getContentSize()
    self.ui.Panel_item:setClipRect(CCRectMake(0, 0, size.width, size.height))
    local container = self.ui.Panel_item
    local posy, old = 0, 0
    container:registerScriptTouchHandler(function(event, x, y)
      if event == "began" then
        posy = y
        old = self.ui.item_layer:getPositionY()
        self.ui.item_layer:stopAllActions()
        return ed.containsPoint(self.ui.Panel_item, x, y)
      elseif event == "moved" then
        self.ui.item_layer:setPositionY(old - (posy - y))
      elseif event == "ended" then
        local new = self.ui.item_layer:getPositionY()
        if new < 0 then
          self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 0))))
        elseif 155 < new then
          self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(0, 155))))
        elseif math.abs(old - new) > 5 then
          self.ui.item_layer:runAction(CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, 0 < posy - y and -30 or 30))))
        end
        self.notPass = math.abs(posy - y) > 5
      end
    end, false, -300, false)
    container:setTouchEnabled(true)
  else
    self.ui.item_layer:setPositionY(-3)
    self.ui.bg_team4:setVisible(false)
    self.ui.bg_team5:setVisible(false)
  end
end

function peakArenaOppoInfoWin.create(params, canChallenge, callback)
  local self = base.create("peakArenaOppoInfoWin")
  setmetatable(self, peakArenaOppoInfoWin.mt)
  self:initData(params, canChallenge, callback)
  self:initUI()
  self:registerTouchHandlers()
  self:show()
  self:popWindow()
  return self
end
