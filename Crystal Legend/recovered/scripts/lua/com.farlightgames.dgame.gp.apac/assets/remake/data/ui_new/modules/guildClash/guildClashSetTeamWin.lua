local base = ed.ui.popwindow
local guildClashSetTeamWin = newclass(base.mt)
ed.ui.guildClashSetTeamWin = guildClashSetTeamWin
local linesName = {
  "top",
  "mid",
  "bottom"
}
local MAXTEAM = 10

function guildClashSetTeamWin.create(param)
  local self = base.create("guildClashSetTeamWin")
  setmetatable(self, guildClashSetTeamWin.mt)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self:registerEvents()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:popWindow()
  self:show()
  return self
end

function guildClashSetTeamWin:initData(param)
  self.mgr = ed.GuildClashManager
  self.initLineId = param.lineId or 1
  self.chairTime = param.chairTime
  self.showTime = param.showTime
end

function guildClashSetTeamWin:initLabels()
  if self.mgr.campId == 1 then
    ed.setLabelStroke(self.ui.label_top_selected, ed.toccc3(5014603), 1)
    ed.setLabelStroke(self.ui.label_mid_selected, ed.toccc3(5014603), 1)
    ed.setLabelStroke(self.ui.label_bottom_selected, ed.toccc3(5014603), 1)
    ed.setLabelStroke(self.ui.label_top, ed.toccc3(2239016), 1)
    ed.setLabelStroke(self.ui.label_mid, ed.toccc3(2239016), 1)
    ed.setLabelStroke(self.ui.label_bottom, ed.toccc3(2239016), 1)
  elseif self.mgr.campId == 2 then
    ed.setLabelStroke(self.ui.label_top_selected, ed.toccc3(2761506), 1)
    ed.setLabelStroke(self.ui.label_mid_selected, ed.toccc3(2761506), 1)
    ed.setLabelStroke(self.ui.label_bottom_selected, ed.toccc3(2761506), 1)
    ed.setLabelStroke(self.ui.label_top, ed.toccc3(10903837), 1)
    ed.setLabelStroke(self.ui.label_mid, ed.toccc3(10903837), 1)
    ed.setLabelStroke(self.ui.label_bottom, ed.toccc3(10903837), 1)
  end
  self.ui.label_title:setFontName(ed.fontBold)
  ed.setLabelStroke(self.ui.label_title, ed.toccc3(5255982), 1)
  ed.setLabelStroke(self.ui.label_team_num, ed.toccc3(4466467), 1)
  ed.right2(self.ui.label_team_num, self.ui.label_title, 10)
  self.ui.label_top:limitWidthByScale(50)
  self.ui.label_top_selected:limitWidthByScale(50)
  self.ui.label_mid:limitWidthByScale(50)
  self.ui.label_mid_selected:limitWidthByScale(50)
  self.ui.label_bottom:limitWidthByScale(50)
  self.ui.label_bottom_selected:limitWidthByScale(50)
  self.ui.label_set1:limitWidthByScale(62)
  self.ui.label_set2:limitWidthByScale(62)
  self.ui.label_edit:limitWidthByScale(62)
  self.ui.label_delete:limitWidthByScale(62)
end

function guildClashSetTeamWin:refreshTeamNumber()
  ed.setString(self.ui.label_team_num, T("%s\233\152\159", #self.linesData[self.lineId].userTeam))
end

function guildClashSetTeamWin:setCurOpTeam(item)
  if item == nil and self.curSelectTeam then
    self.curSelectTeam.ui.btn_oppo_selected:setVisible(false)
  end
  self.ui.bg_oppoBtn:setVisible(item ~= nil)
  self.curSelectTeam = item
end

function guildClashSetTeamWin:refreshUI()
  self:setCurOpTeam(nil)
  self:refreshDraglist()
  self:refreshTeamNumber()
end

function guildClashSetTeamWin:createUserTeamItem(data, index)
  local container, ui = ed.editorui(ed.uieditor.GuildClashSelfTeam)
  if self.mgr.campId == 2 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/guild/guild_clash_deploy/dark_guildteam_teaminfo.png")
    ed.setTexture(ui.bg_gs, "UI/alpha/1080P/guild/guild_clash_deploy/dark_myteam_fightinfo.png")
  end
  ed.setLabelShadow(ui.Label_120, ccc3(0, 0, 0), ccp(1, 1))
  local gs = 0
  for k, v in ipairs(data._heroes) do
    local icon = ed.readhero.createIconByID(v._hero_id).icon
    icon:setScale(0.6)
    ed.UITool.replaceUI(ui, "bg", "icon" .. k, icon)
    gs = gs + ed.player:getHero(v._hero_id)._gs
  end
  ed.setString(ui.Label_105, gs)
  if self.chairTime or self.showTime then
    ui.btn_oppo:setVisible(false)
  end
  return container, ui
end

function guildClashSetTeamWin:updateOpPanel()
  if self.lineId == 1 then
    ed.setTexture(self.ui.icon_set1, "UI/alpha/1080P/guild/guild_clash_deploy/operate_midroad.png")
    ed.setString(self.ui.label_set1, T("\230\180\190\229\190\128\228\184\173\232\183\175"))
    ed.setTexture(self.ui.icon_set2, "UI/alpha/1080P/guild/guild_clash_deploy/operate_botroad.png")
    ed.setString(self.ui.label_set2, T("\230\180\190\229\190\128\228\184\139\232\183\175"))
  elseif self.lineId == 2 then
    ed.setTexture(self.ui.icon_set1, "UI/alpha/1080P/guild/guild_clash_deploy/operate_toproad.png")
    ed.setString(self.ui.label_set1, T("\230\180\190\229\190\128\228\184\138\232\183\175"))
    ed.setTexture(self.ui.icon_set2, "UI/alpha/1080P/guild/guild_clash_deploy/operate_botroad.png")
    ed.setString(self.ui.label_set2, T("\230\180\190\229\190\128\228\184\139\232\183\175"))
  else
    ed.setTexture(self.ui.icon_set1, "UI/alpha/1080P/guild/guild_clash_deploy/operate_toproad.png")
    ed.setString(self.ui.label_set1, T("\230\180\190\229\190\128\228\184\138\232\183\175"))
    ed.setTexture(self.ui.icon_set2, "UI/alpha/1080P/guild/guild_clash_deploy/operate_midroad.png")
    ed.setString(self.ui.label_set2, T("\230\180\190\229\190\128\228\184\173\232\183\175"))
  end
end

function guildClashSetTeamWin:getTotalTeam()
  local total = 0
  for k, v in ipairs(self.linesData) do
    total = total + #v.userTeam
  end
  return total
end

function guildClashSetTeamWin:getAllUsedHero()
  local heroIds = {}
  for k, line in ipairs(self.linesData) do
    for i, team in ipairs(line.userTeam) do
      for id, hero in ipairs(team._heroes) do
        if not ed.isElementInTable(hero._hero_id, heroIds) then
          table.insert(heroIds, hero._hero_id)
        end
      end
    end
  end
  return heroIds
end

function guildClashSetTeamWin:getTotalGuildTeam(lineId)
  local total = 0
  for i, member in ipairs(self.linesData[lineId].guildUserTeamCount) do
    total = total + member._team_count
  end
  return total
end

function guildClashSetTeamWin:createAddTeamBtn()
  local container, ui = ed.editorui(ed.uieditor.GuildClashSetTeamTip)
  if self.mgr.campId == 2 then
    ed.setTexture(ui.bg, "UI/alpha/1080P/guild/guild_clash_deploy/dark_addteam_floor.png")
    ed.setTexture(ui.ImageView_140, "UI/alpha/1080P/guild/guild_clash_deploy/dark_addteam_addicon.png")
    ed.setLabelStroke(ui.Label_141, ed.toccc3(9983288), 1)
  elseif self.mgr.campId == 1 then
    ed.setLabelColor(ui.Label_141, ed.toccc3(16118941))
    ed.setLabelStroke(ui.Label_141, ed.toccc3(7634714), 1)
  end
  if self:getTotalTeam() < MAXTEAM then
    ui.bg:setCascadeOpacityEnabled(true)
    ui.bg:runAction(ed.UITool.getBreathAction(0.6))
  else
    ed.setSpriteShader(ui.bg, "GrayScalingShader_2")
    ed.setSpriteShader(ui.ImageView_140, "GrayScalingShader_2")
    ed.setSpriteShader(ui.Label_141, "GrayScalingShader_2")
  end
  ed.layout.horizontalSortNode({
    ui.ImageView_140,
    ui.Label_141
  }, {5, 0}, ui.bg:getContentSize().width * 0.5)
  return container, ui
end

function guildClashSetTeamWin:createAddTeamTip()
  local root = CCSprite:create()
  local desStr = T("\232\191\152\229\143\175\230\183\187\229\138\160%d\230\148\175\233\152\159\228\188\141\229\136\176\229\144\132\229\136\134\232\183\175\229\135\186\229\190\129\230\136\152\230\150\151")
  local paramStartIndex, paramEndIndex = string.find(desStr, "%%d")
  local labelDesc1 = ed.createttf(string.sub(desStr, 1, paramStartIndex - 1), 16)
  local labelDesc2 = ed.createttf(MAXTEAM - self:getTotalTeam(), 16)
  local labelDesc3 = ed.createttf(string.sub(desStr, paramEndIndex + 1), 16)
  if self.mgr.campId == 1 then
    labelDesc1:setColor(ed.toccc3(9349759))
    labelDesc2:setColor(ed.toccc3(15921578))
    ed.setLabelStroke(labelDesc2, ed.toccc3(3622186), 1)
    labelDesc3:setColor(ed.toccc3(9349759))
  elseif self.mgr.campId == 2 then
    labelDesc1:setColor(ed.toccc3(11633498))
    labelDesc2:setColor(ed.toccc3(16775297))
    ed.setLabelStroke(labelDesc2, ed.toccc3(9000248), 1)
    labelDesc3:setColor(ed.toccc3(11633498))
  end
  root:addChild(labelDesc1)
  root:addChild(labelDesc2)
  root:addChild(labelDesc3)
  ed.left2(labelDesc1, labelDesc2)
  ed.right2(labelDesc3, labelDesc2)
  ed.layout.horizontalSortNode({
    labelDesc1,
    labelDesc2,
    labelDesc3
  }, {
    0,
    0,
    0
  }, 0)
  if self.numAction then
    labelDesc2:runAction(ed.UITool.getRefreshAction())
    self.numAction = nil
  end
  return root
end

function guildClashSetTeamWin:createSelfTeamList(data, ox, oy)
  for k, v in ipairs(data) do
    local container, ui = self:createUserTeamItem(v, k)
    local itemHeight = ui.bg:getContentSize().height
    if self.needRefreshAction then
      container:setPosition(ccp(ox - 400, oy - itemHeight / 2))
      local sequence = CCSequence:create(ccArrayMake({
        CCDelayTime:create(k * 0.02),
        CCEaseSineIn:create(CCMoveBy:create(0.1, ccp(400, 0)))
      }))
      container:runAction(sequence)
    else
      container:setPosition(ccp(ox, oy - itemHeight / 2))
    end
    local item = {
      ui = ui,
      container = container,
      data = v,
      type = "SelfTeam"
    }
    table.insert(self.uiList, item)
    oy = oy - itemHeight
    self.draglist:addItem(container)
  end
  self.needRefreshAction = false
  return oy
end

function guildClashSetTeamWin:createAddBtnTip(ox, oy)
  if self.chairTime then
    local tip = ed.createttf(T("\229\189\147\229\137\141\228\187\133\228\188\154\233\149\191\229\146\140\233\149\191\232\128\129\229\143\175\232\176\131\230\149\180\229\136\134\232\183\175"), 16)
    tip:setColor(ed.toccc3(11633498))
    tip:setPosition(ccp(ox, oy - 15))
    oy = oy - 20
    self.draglist:addItem(tip)
  elseif self.showTime then
  else
    local tip = self:createAddTeamTip()
    tip:setPosition(ccp(ox, oy - 15))
    oy = oy - 20
    self.draglist:addItem(tip)
    local container, ui = self:createAddTeamBtn()
    local itemHeight = ui.bg:getContentSize().height
    container:setPosition(ccp(ox, oy - itemHeight / 2))
    oy = oy - itemHeight
    local item = {
      ui = ui,
      container = container,
      data = {},
      type = "AddBtn"
    }
    table.insert(self.uiList, item)
    self.draglist:addItem(container)
  end
  return oy
end

function guildClashSetTeamWin:createGuildTeamBg(ox, oy)
  local num = self:getTotalGuildTeam(self.lineId)
  local container, ui = ed.editorui(ed.uieditor.GuildClashTeamInfoBg)
  container:setPosition(ccp(ox, oy - 85))
  ui.label_title_guild:setFontName(ed.fontBold)
  ed.setLabelStroke(ui.label_title_guild, ed.toccc3(4468775), 1)
  ed.setLabelStroke(ui.label_guild_num, ed.toccc3(3418918), 1)
  ed.setString(ui.label_guild_num, T("%s\233\152\159", num))
  ed.right2(ui.label_guild_num, ui.label_title_guild, 10)
  oy = oy - 35
  self.draglist:addItem(container)
  return oy
end

function guildClashSetTeamWin:createGuildTeams(data, ox, oy)
  for k, v in ipairs(data) do
    local container, ui = self:createGuildTeamItem(v)
    local itemHeight = ui.bg:getContentSize().height
    container:setPosition(ccp(ox, oy - itemHeight / 2))
    oy = oy - itemHeight
    self.draglist:addItem(container)
  end
  return oy
end

function guildClashSetTeamWin:refreshDraglist()
  local lineData = self.linesData[self.lineId] or {}
  self.draglist:clearList()
  local contentSize = self.ui.layer_self:getContentSize()
  local ox, oy = contentSize.width / 2, contentSize.height
  local data = lineData.userTeam or {}
  self.uiList = {}
  oy = self:createSelfTeamList(data, ox, oy)
  oy = self:createAddBtnTip(ox, oy)
  oy = self:createGuildTeamBg(ox, oy)
  data = lineData.guildUserTeamCount or {}
  oy = self:createGuildTeams(data, ox, oy)
  self.draglist:initListHeight(contentSize.height - oy)
end

function guildClashSetTeamWin:createGuildTeamItem(data)
  local container, ui = ed.editorui(ed.uieditor.GuildClashTeamInfo)
  local summary = self.mgr:getUserSummary(data._uid, self.mgr.campId)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = ui.name:getAnchorPoint()
  })
  ed.UITool.replaceUI(ui, "bg", "name", name)
  local teamTotal = data._team_count
  local heroTotal = data._hero_count
  local autoText = ed.ui.autoText.new()
  autoText:initParam({
    context = string.format(T("\230\180\190\229\135\186<lable color=ccc3(255,212,181)>%d</lable>\233\152\159\239\188\140\229\133\177<lable color=ccc3(255,212,181)>%d</lable>\229\144\141\232\139\177\233\155\132"), teamTotal, heroTotal),
    color = ed.toccc3(13212287),
    strokeColor = ed.toccc3(3418918),
    strokeSize = 1,
    fontSize = 16
  })
  ed.UITool.replaceUI(ui, "bg", "info", autoText.node)
  local param = {
    id = summary._avatar,
    level = summary._level,
    scale = 0.56,
    lvoffset = {x = -47, y = -19}
  }
  local avatar = ed.getWholeHeadIcon(param)
  ed.UITool.replaceUI(ui, "bg", "avatar", avatar)
  return container, ui
end

function guildClashSetTeamWin:getCancelPressInHandler()
  local function handler(x, y)
  end
  
  return handler
end

function guildClashSetTeamWin:getPressInHandler()
  local function handler(x, y)
    for k, v in ipairs(self.uiList) do
      if v.type == "AddBtn" then
        if ed.containsPoint(v.ui.bg, x, y) then
          return v
        end
      elseif v.type == "SelfTeam" and ed.containsPoint(v.ui.bg, x, y) and v.ui.btn_oppo:isVisible() then
        return v
      end
    end
  end
  
  return handler
end

function guildClashSetTeamWin:onClickAddTeam()
  if self:getTotalTeam() >= MAXTEAM then
    ed.showToast(string.format(T("\229\183\178\229\161\171\230\187\161\239\188\140\230\156\128\229\164\154\229\143\175\230\183\187\229\138\160%d\230\148\175\233\152\159\228\188\141\229\136\176\229\144\132\229\136\134\232\183\175"), MAXTEAM))
    return
  end
  local objData = {
    camp = self.mgr.campId,
    lineId = self.lineId,
    guildTeamAmount = self:getTotalGuildTeam(self.lineId),
    myTeamAmount = #self.linesData[self.lineId].userTeam
  }
  self.curOp = "AddTeam"
  ed.pushScene(ed.ui.battleprepare.create({
    guildClashMode = true,
    mode = "GuildClash",
    cantUseHero = self:getAllUsedHero(),
    stage_id = -1,
    objData = objData
  }))
end

function guildClashSetTeamWin:onClickOp(item)
  if self.curSelectTeam then
    self:setCurOpTeam(nil)
    item.ui.btn_oppo_selected:setVisible(false)
  else
    ListenTimer(Timer:Once(0), function()
      item.ui.btn_oppo_selected:setVisible(true)
      self:setCurOpTeam(item)
    end)
  end
end

function guildClashSetTeamWin:getClickInHandler()
  local function handler(x, y, item)
    if not item then
      return
    end
    if item.type == "AddBtn" then
      self:onClickAddTeam()
    elseif item.type == "SelfTeam" then
      self:onClickOp(item)
    end
  end
  
  return handler
end

function guildClashSetTeamWin:initUI()
  if self.mgr.campId == 1 then
    ed.editorui(ed.uieditor.GuildClashSetTeamWin, {
      container = self.container,
      ui = self.ui
    })
  else
    ed.editorui(ed.uieditor.GuildClashSetTeamDarkWin, {
      container = self.container,
      ui = self.ui
    })
  end
  self.ui.bg_oppoBtn:setPosition(ccp(770, 382.5))
  self:initLabels()
  self:updateLineBtn(self.initLineId)
  self:updateOpPanel()
  self.draglist = ed.UITool.createDraglist(self.ui.layer_self, {
    doPressIn = self:getPressInHandler(),
    doClickIn = self:getClickInHandler(),
    cancelPressIn = self:getCancelPressInHandler(),
    bar = {
      bglen = 458,
      bgpos = ccp(465, 229),
      barres = "UI/alpha/1080P/guild/guild_clash_deploy/guildteam_slider1.png",
      bgres = "UI/alpha/1080P/guild/guild_clash_deploy/guildteam_slider2.png"
    }
  })
end

function guildClashSetTeamWin:updateLineBtn(lineId)
  self.lineId = self.lineId or 1
  local lineName = linesName[self.lineId]
  self.ui["btn_" .. lineName .. "_selected"]:setVisible(false)
  self.ui["icon_" .. lineName]:setVisible(true)
  self.lineId = lineId
  lineName = linesName[self.lineId]
  self.ui["btn_" .. lineName .. "_selected"]:setVisible(true)
  self.ui["icon_" .. lineName]:setVisible(false)
end

function guildClashSetTeamWin:onClickLineTab(lineId)
  if self.lineId == lineId then
    return
  end
  self.needRefreshAction = true
  self:updateLineBtn(lineId)
  self:updateOpPanel()
  self:refreshUI()
end

function guildClashSetTeamWin:registerEvents()
  self:btRegisterOutClick({
    area = self.ui.bg_oppoBtn,
    key = "clickOutOppo",
    clickHandler = function()
      self:setCurOpTeam(nil)
    end
  })
  self:listenEvent("GuildClashLineTeamInfo", function(data)
    self.linesData = self.mgr.linesTeamInfo
    self:refreshUI()
  end)
  self:listenEvent("GuildClashChangeLineSuccess", function()
    local CNName = {
      T("\228\184\138\232\183\175"),
      T("\228\184\173\232\183\175"),
      T("\228\184\139\232\183\175")
    }
    ed.showToast(string.format(T("\232\175\165\233\152\159\228\188\141\229\183\178\230\180\190\229\190\128%s"), CNName[self.targetLine]))
    ed.GuildClashNetwork:sendUserTeam()
  end)
  self:listenEvent("GuildClashAddTeamSuccess", function(data)
    self.numAction = true
    ed.GuildClashNetwork:sendUserTeam()
  end)
  self:listenEvent("GuildClashEditTeamSuccess", function()
    ed.showToast(T("\232\176\131\230\149\180\230\136\144\229\138\159"))
    ed.GuildClashNetwork:sendUserTeam()
  end)
  self:listenEvent("GuildClashDelTeamSuccess", function()
    self.numAction = true
    ed.showToast(T("\229\136\160\233\153\164\230\136\144\229\138\159"))
    ed.GuildClashNetwork:sendUserTeam()
  end)
  self:listenEvent("GuildClashEditTeam", function(data)
    if self.curOp == "AddTeam" then
      ed.GuildClashNetwork:sendAddTeam({
        lineId = self.lineId,
        heroIds = data
      })
    elseif self.curSelectTeam then
      ed.GuildClashNetwork:sendEditTeam({
        id = self.curSelectTeam.data._id,
        heroIds = data
      })
    end
    self.curOp = nil
  end)
  ed.GuildClashNetwork:sendUserTeam()
end

function guildClashSetTeamWin:filterTeamMember(usedHero, heroIds)
  local result = {}
  for index, heroId in ipairs(usedHero or {}) do
    if not ed.isElementInTable(heroId, heroIds or {}) then
      table.insert(result, heroId)
    end
  end
  return result
end

function guildClashSetTeamWin:onClickChangeLineA()
  if not self.curSelectTeam then
    return
  end
  local curData = self.curSelectTeam.data
  self.curOp = "ChangeLine"
  if self.lineId == 1 then
    self.targetLine = 2
  elseif self.lineId == 2 then
    self.targetLine = 1
  elseif self.lineId == 3 then
    self.targetLine = 1
  end
  ed.GuildClashNetwork:sendChangeLine(curData._id, self.targetLine)
end

function guildClashSetTeamWin:onClickChangeLineB()
  if not self.curSelectTeam then
    return
  end
  local curData = self.curSelectTeam.data
  if self.lineId == 1 then
    self.targetLine = 3
  elseif self.lineId == 2 then
    self.targetLine = 3
  elseif self.lineId == 3 then
    self.targetLine = 2
  end
  ed.GuildClashNetwork:sendChangeLine(curData._id, self.targetLine)
end

function guildClashSetTeamWin:onClickEditTeam()
  if not self.curSelectTeam then
    return
  end
  local curTeamData = self.curSelectTeam.data
  local objData = {
    camp = self.mgr.campId,
    lineId = self.lineId,
    guildTeamAmount = self:getTotalGuildTeam(self.lineId),
    myTeamAmount = #self.linesData[self.lineId].userTeam
  }
  local heroIds = {}
  for k, v in ipairs(curTeamData._heroes) do
    table.insert(heroIds, v._hero_id)
  end
  self.curOp = "EditTeam"
  ed.pushScene(ed.ui.battleprepare.create({
    guildClashMode = true,
    mode = "GuildClash",
    cantUseHero = self:filterTeamMember(self:getAllUsedHero(), heroIds),
    heros = heroIds,
    stage_id = -1,
    objData = objData
  }))
end

function guildClashSetTeamWin:onClickDeleteTeam()
  if not self.curSelectTeam then
    return
  end
  ed.showConfirmDialog({
    text = T("\231\161\174\229\174\154\229\136\160\233\153\164\232\175\165\233\152\159\228\188\141\239\188\159"),
    rightText = T("\231\161\174\229\174\154"),
    rightHandler = function()
      ed.GuildClashNetwork:sendDelTeam(self.curSelectTeam.data._id)
    end
  })
end

function guildClashSetTeamWin:registerTouchHandlers()
  ed.UITool.registerBtn(self, "btn_top_touchArea", function()
    self:onClickLineTab(1)
  end)
  ed.UITool.registerBtn(self, "btn_mid_touchArea", function()
    self:onClickLineTab(2)
  end)
  ed.UITool.registerBtn(self, "btn_bottom_touchArea", function()
    self:onClickLineTab(3)
  end)
  ed.UITool.registerBtn(self, "btn_back", function()
    self:destroy()
  end, {pressScale = 0.66, normalScale = 0.7})
  ed.UITool.registerBtn(self, "btn_set1", function()
    self:onClickChangeLineA()
  end)
  ed.UITool.registerBtn(self, "btn_set2", function()
    self:onClickChangeLineB()
  end)
  ed.UITool.registerBtn(self, "btn_edit", function()
    self:onClickEditTeam()
  end)
  ed.UITool.registerBtn(self, "btn_delete", function()
    self:onClickDeleteTeam()
  end)
end
