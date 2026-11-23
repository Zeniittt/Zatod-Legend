local base = ed.ui.commonscene
local pvpMainScene = newclass(base.mt)
ed.ui.pvpMainScene = pvpMainScene

function pvpMainScene:adaptUI()
  local ui = self.ui
  local bgFixWidth = ed.display.halfFixedWidth * 1
  local bgFixHeight = ed.display.halfFixedHeight * 0.8
  self.bgFixWidth = bgFixWidth
  self.bgFixHeight = bgFixHeight
  ed.UITool.setContentSizeBy(ui.bg, bgFixWidth, bgFixHeight)
  ed.UITool.setContentSizeBy(ui.layer_enemy, bgFixWidth, bgFixHeight)
  ed.UITool.setContentSizeBy(ui.bg_banner, 0, bgFixHeight, true)
  ed.UITool.setPositionBy(ui.bg_times, ccp(bgFixWidth, bgFixHeight))
  ed.UITool.setPositionBy(ui.banner_title, ccp(0, bgFixHeight))
  ed.UITool.setPositionBy(ui.head, ccp(0, bgFixHeight))
  ed.UITool.setPositionBy(ui.rank, ccp(0, bgFixHeight))
  ed.UITool.setPositionBy(ui.bg_reward, ccp(0, bgFixHeight * 5 / 8))
  ed.UITool.setPositionBy(ui.layer_team, ccp(0, bgFixHeight * 4 / 8))
  ed.UITool.setPositionBy(ui.btn_change, ccp(0, bgFixHeight * 2 / 8))
  ed.UITool.setPositionBy(ui.name, ccp(0, bgFixHeight * 7 / 8))
  ed.UITool.setPositionBy(ui.bg_legend_equip_buff, ccp(bgFixWidth, bgFixHeight))
  ed.layout.layoutWithMagin(self.ui.bg_title, {left = 70, top = 18})
end

function pvpMainScene:initLabels()
  ed.setLabelStroke(self.ui.label_times, ccc3(0, 0, 0), 1)
  ed.setLabelStroke(self.ui.name, ccc3(85, 64, 39), 1)
  ed.setLabelStroke(self.ui.label_reward, ccc3(39, 37, 36), 1)
  ed.setLabelStroke(self.ui.label_team, ccc3(39, 37, 36), 1)
  self.ui.label_team:limitWidthByScale(60)
  ed.setLabelShadow(self.ui.label_change, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelStroke(self.ui.label_btn1, ccc3(9, 17, 27), 1)
  self.ui.label_btn1:limitWidthByScale(60)
  ed.setLabelStroke(self.ui.label_btn2, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_btn3, ccc3(9, 17, 27), 1)
  self.ui.label_btn3:limitWidthByScale(60)
  ed.setLabelStroke(self.ui.label_btn4, ccc3(9, 17, 27), 1)
  self.ui.label_btn4:limitWidthByScale(60)
  ed.setLabelStroke(self.ui.label_btn5, ccc3(9, 17, 27), 1)
  ed.setLabelStroke(self.ui.label_buff_1, ed.toccc3(6761599), 1)
  ed.setLabelStroke(self.ui.label_buff_left_time, ed.toccc3(6761599), 1)
  ed.setLabelStroke(self.ui.label_cur_rank, ed.toccc3(5124887), 1.5)
  ed.setLabelStroke(self.ui.label_legend_equip_time, ed.toccc3(7223558), 1)
  self.ui.label_cur_rank:setFontName(ed.fontBold)
end

function pvpMainScene:refreshRedLight()
  local data = ed.queryNotifyData("PvpNotifyData")
  self.ui.recordTag:setVisible(data and data._is_attacked == 1)
end

function pvpMainScene:createMainFca()
  local mainFca = ed.createFcaNode("eff_UI_pvp_particle_main")
  mainFca:setPosition(ccp(ed.display.center.x, ed.display.center.y))
  self:addFca(mainFca)
  self.container:addChild(mainFca, -1)
end

function pvpMainScene:refreshGS()
  if not tolua.isnull(self.ui.gsLabel) then
    self.ui.gsLabel:removeFromParentAndCleanup(true)
  end
  local gs = ed.pvpManager.gs
  local posX = 93
  local richText = richText:new()
  richText:setString(string.format("<text|arenags1|%s:><text|arenags2|%d>", T("\230\136\152\230\150\151\229\138\155"), gs))
  richText:setAnchor(ccp(1, 0.5))
  richText:setVerticalCenter()
  while 10 <= gs do
    gs = gs / 10
    posX = posX - 7
  end
  richText:setPosition(ccp(posX, 85))
  self.ui.gsLabel = richText.rootNode
  self.ui.layer_team:addChild(richText.rootNode)
end

function pvpMainScene:refreshLineupUI()
  for i = 1, 5 do
    self.ui["hero" .. i]:setVisible(false)
    local heroData = ed.pvpManager.lineup[#ed.pvpManager.lineup + 1 - i]
    if heroData then
      local heroinfo = ed.readhero.createIconByServer(heroData)
      local head = heroinfo.icon
      heroinfo:showLegendEquip(ed.off_legendEquipOp)
      head:setScale(0.57)
      ed.UITool.replaceUI(self.ui, "layer_team", "hero" .. i, head)
      self:btRegisterButtonClick({
        button = head,
        key = "self_" .. i,
        force = true,
        pressScale = 0.55,
        normalScale = 0.57,
        clickHandler = function()
          ed.ui.checkOthersHeroWindow.create(heroData):popWindow()
        end
      })
    end
  end
  self:refreshGS()
end

function pvpMainScene:refreshEnemyDraglist()
  local newPY = 83 + self.bgFixHeight / 4
  local rx = self.ui.layer_enemy:getContentSize().width / 2
  local ry = self.ui.layer_enemy:getContentSize().height + newPY / 2
  local uiList = {}
  self.draglist:clearList()
  for i = 1, #ed.pvpManager.oppos do
    local oppo = ed.pvpManager.oppos[i]
    local container, ui
    if oppo._rank < ed.pvpManager.rank then
      container, ui = self:createEnemyItem(oppo)
    else
      container, ui = self:createSweepEnemyItem(oppo)
    end
    ui.data = oppo
    table.insert(uiList, ui)
    self.draglist:addItem(container)
    container:setPosition(ccp(rx, ry - newPY * i))
  end
  self.uiList = uiList
end

function pvpMainScene:updateBtnState()
  local nowTime = ed.getServerTime()
  local passTime = nowTime - ed.pvpManager.lastBtTime
  if passTime < 16 then
    self.state = "unable"
    self.ui.icon_switch:setVisible(false)
    self.ui.label_switch:setPositionX(49)
    ed.setString(self.ui.label_switch, T("\233\135\141\231\189\174%s\231\167\146", ed.getmsNString(16 - passTime)))
  elseif ed.pvpManager.leftTime > 0 then
    self.state = "switchEnemy"
    self.ui.icon_switch:setVisible(true)
    self.ui.label_switch:setPositionX(59)
    ed.setString(self.ui.label_switch, T("\230\141\162\228\184\128\230\137\185"))
  else
    self.state = "buyTime"
    self.ui.icon_switch:setVisible(false)
    self.ui.label_switch:setPositionX(49)
    ed.setString(self.ui.label_switch, T("\232\180\173\228\185\176\230\172\161\230\149\176"))
  end
end

function pvpMainScene:refreshUI()
  ed.UITool.replaceUI(self.ui, "bg_banner", "head", ed.getWholeHeadIcon({
    id = ed.player:getAvatarId(),
    frameId = ed.player:getAvatarFrame()
  }))
  ed.UITool.replaceUI(self.ui, "bg_banner", "rank", ed.getNumberNode({
    text = ed.pvpManager.rank,
    folder = "big_pvp",
    padding = -1
  }).node)
  ed.setString(self.ui.label_times, string.format(T("\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176%d/5"), ed.pvpManager.leftTime))
  if not self.nameBgImg then
    local sprite = ed.createSprite("UI/alpha/1080P/pvp/diamond_bg.png")
    sprite:setPosition(ccpAdd(ccp(self.ui.name:getPosition()), ccp(0, 0)))
    sprite:setScale(0.6)
    self.ui.name:getParent():addChild(sprite)
    self.nameBgImg = sprite
  end
  local name = ed.getPlayerName(ed.player:getName() or T("\230\156\170\229\145\189\229\144\141\231\142\169\229\174\182"), ed.player:getMedal().wearInfo, {
    anchorPoint = ccp(0.5, 0.5)
  })
  ed.UITool.replaceUI(self.ui, "bg_banner", "name", name)
  self:refreshLineupUI()
  self:refreshRewardDraglist()
  self:refreshEnemyDraglist()
  self:updateBtnState()
  self:refreshShareTime()
  self:switchLegendEquipMenu(ed.off_legendEquipOp)
end

function pvpMainScene:initUI()
  self.container = self.mainLayer
  local container, ui = ed.editorui(ed.uieditor.arenaWin, {
    container = self.container,
    ui = self.ui
  })
  self:setBackground("UI/alpha/1080P/pvp/bg.jpg")
  self:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  self:adaptUI()
  self:initLabels()
  local title_bg, title_text = ed.UITool.createSceneTitle(T("\231\171\158\230\138\128\229\156\186"), self.ui.bg_title, {
    position = ccp(18, 18)
  })
  local rightPos = title_bg:getContentSize().width + title_bg:getPositionX() + 15
  rightPos = math.max(rightPos, self.ui.btn_rule:getPositionX())
  self.ui.btn_rule:setPosition(ccp(rightPos, self.ui.btn_rule:getPositionY()))
  self.draglist = ed.UITool.createDraglist(self.ui.layer_enemy, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    priority = -300
  })
  self.rewardDraglist = ed.UITool.createDraglist(self.ui.layer_reward)
  self:refreshRedLight()
  self:createMainFca()
  self:refreshUI()
  self:updateActivityLeftTime()
  self:initLegendEquip()
  self:initLegendEquipActivity()
  self:addBtnClick()
end

function pvpMainScene:initLegendEquip()
  if not ed.openLegendEquip() then
    self.ui.switch_equip_bg:setVisible(false)
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

function pvpMainScene:initLegendEquipActivity()
  if not self.pvpLegendEquipAct or self.pvpLegendEquipAct.endTime < ed.getServerTime() then
    self.ui.bg_legend_equip_buff:setVisible(false)
    return
  end
  self.ui.bg_legend_equip_buff:setVisible(true)
  self.legendEquipActEndTime = self.pvpLegendEquipAct.endTime
  local legendEquipId = self.pvpLegendEquipAct.legendEquipId
  local legendEquipCfg = ed.getDataTable("LegendEquip")[legendEquipId]
  ed.setTexture(self.ui.legend_equip_icon, legendEquipCfg.Painting)
  self:updateLegendEquipActLeftTime()
end

function pvpMainScene:addBtnClick()
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

function pvpMainScene:switchLegendEquipMenu(open)
  self.ui.close_equip_bg:setVisible(not open)
  self.ui.label_equip:setVisible(not open)
  self.ui.label_equip_enable:setVisible(open)
  self.ui.btn_equip:setPositionX(open and 17 or 59)
  self:refreshLegendEquip()
end

function pvpMainScene:refreshLegendEquip()
  self:refreshLineupUI()
  self:refreshEnemyDraglist()
end

function pvpMainScene:adjustHero()
  ed.playEffect(ed.sound.pvp.clickChangeTeam)
  if ed.getServerTime() < ed.pvpManager.adjustTime then
    ed.showToast(string.format(T("\232\191\152\230\156\137%ds\229\144\142\230\137\141\229\143\175\232\176\131\230\149\180\233\152\181\229\174\185"), ed.pvpManager.adjustTime - ed.getServerTime()))
    return
  end
  local heroIdList = {}
  for index, heroData in ipairs(ed.pvpManager.lineup) do
    table.insert(heroIdList, heroData._tid)
  end
  ed.pushScene(ed.ui.battleprepare.create({
    pvpMode = "defend",
    banHero = ed.pvpManager.banHero,
    heros = heroIdList,
    stage_id = -1,
    pvpActivityInfo = self:isOpenPvpActivity() and self.pvpActivityInfo or nil,
    pvpLegendEquipAct = self:isOpenLegendEquipAct() and self.pvpLegendEquipAct or nil
  }))
end

function pvpMainScene:changeEnemy()
  if self.state == "unable" then
    return
  elseif self.state == "switchEnemy" then
    ed.pvpNetwork:sendApplyOpponent()
  elseif self.state == "buyTime" then
    self:buyPvpTime()
  end
end

function pvpMainScene:registerTouchEvents()
  ed.UITool.registerBtn(self, "bg_btn1", function()
    ed.UITool.openView("ranklist", {index = 1})
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_btn2", function()
    ed.UITool.openView("shopMain", {page = 2})
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_btn3", function()
    ed.ui.pvpRewardWin.create()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_btn4", function()
    self.ui.recordTag:setVisible(false)
    ed.changeNotifyData("PvpNotifyData", nil, nil)
    local BuilddingType = ed.ui.configs.mainSceneMap.builddingType
    FireEvent("MainBuildRedTagChange", BuilddingType.Pvp)
    local msg = ed.upmsg.ladder()
    msg._query_records = {}
    ed.send(msg, "ladder")
    ed.ui.pvpRecordWin.create()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_btn5", function()
    ReloadModule("ui_new/modules/pvp/pvpBackgroundPop")
    ed.ui.pvpBackgroundPop.create({}):popWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_change", function()
    self:adjustHero()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_switch", function()
    self:changeEnemy()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_rule", function()
    ed.ui.commonRulePop.create({
      title = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      txt = ed.ui.pvpRuleTips.strPage
    }):popWindow()
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "btn_share", function()
    ed.UITool.openView("shareGuildOrFriend")
  end, {pressScale = 0.95})
  ed.UITool.registerBtn(self, "bg_buff_touch", function()
  end, {
    pressHandler = function()
      if not self.buffTipsPanel then
        local buffTipsPanel = self:showBuffTips()
        self.container:addChild(buffTipsPanel)
        ed.layout.relateLayout(self.ui.bg_buff, buffTipsPanel, {bottom = 30})
        self.buffTipsPanel = buffTipsPanel
      end
    end,
    cancelPressHandler = function()
      if self.buffTipsPanel then
        self.buffTipsPanel:removeFromParentAndCleanup(true)
        self.buffTipsPanel = nil
      end
    end,
    mcpMode = false
  })
  ed.UITool.registerBtn(self, "bg_legend_equip_buff", function()
    local window = ed.UITool.openView("pvpLegendEquipActTips", {
      legendEquipId = self.pvpLegendEquipAct.legendEquipId
    })
    local bgSize = window.ui.image_bg:getContentSize()
    ed.layout.relateLayout(self.ui.bg_legend_equip_buff, window.ui.image_bg, {
      bottom = bgSize.height / 2 + 23
    })
    ed.layout.layoutWithMagin(window.ui.image_bg, {
      right = ed.display.getNotchHeight()
    })
  end, {pressScale = 0.95})
end

function pvpMainScene:registerEvents()
  self:listenTimer(Timer:Always(1), function()
    self:updateBtnState()
    self:updateActivityLeftTime()
    self:updateLegendEquipActLeftTime()
  end)
  self:listenEvent("ChatRsp", function(data)
    self:OnChatRsp(data)
  end)
  self:listenEvent("SetNameSuccess", function()
    ed.setString(self.ui.name, ed.player:getName())
  end)
  self:listenEvent("RefreshPvpData", function()
    self:refreshUI()
  end)
  self:listenEvent("PvpSweepReply", function()
    self:refreshChallengeTimes()
  end)
  self:listenEvent("PvpBuyTimesReply", function()
    self:refreshChallengeTimes()
  end)
  self:listenEvent("SetLineupReply", function()
    self:refreshLineupUI()
  end)
  self:listenEvent("ChangeEnemyReply", function()
    self:refreshUI()
  end)
  self:listenEvent("PvpQueryOppo", function(data)
    self:showHeroInfo(data)
  end)
  self:listenEvent("LeftShareTimesChange", function()
    self:refreshShareTime()
  end)
end

function pvpMainScene.create()
  local self = base.create("pvp", {noBottomButton = true})
  setmetatable(self, pvpMainScene.mt)
  self.pvpActivityInfo = ed.activityHints.data:getPvpActivityInfo()
  self.pvpLegendEquipAct = ed.activityHints.data:getPvpLegendEquipActivityInfo()
  self.endTime = self.pvpActivityInfo and self.pvpActivityInfo.endTime
  self:initUI()
  self:registerTouchEvents()
  self:registerEvents()
  self:registerOnEnterHandler("onEnterwork", function()
    ed.pvpNetwork:sendOpenPanel()
    local msg = ed.upmsg.ladder()
    msg._query_records = {}
    ed.send(msg, "ladder")
    if ed.player:getName() == "" then
      ed.ui.renameWindow.create({
        cancleCallback = function()
          ed.popScene()
        end
      }):popWindow()
    end
  end)
  self:registerOnPopSceneHandler("onPopScene", function()
    ed.pvpManager.win = nil
  end)
  return self
end

function pvpMainScene:buyPvpTime()
  local cost = ed.getDataTable("GradientPrice")[ed.pvpManager.buyTime + 1]["PVP Buy"]
  local maxBuyTime = ed.getDataTable("VIP")[ed.player:getvip()]["PVP Buy"]
  if cost <= ed.player._rmb and maxBuyTime > ed.pvpManager.buyTime then
    ed.showConfirmDialog({
      text = string.format(T("\232\191\153\230\152\175\228\189\160\228\187\138\229\164\169\231\172\172 %d \230\172\161\232\180\173\228\185\176\233\151\168\231\165\168\n\230\152\175\229\144\166\232\166\129\230\148\175\228\187\152 %d \233\146\187\231\159\179\229\162\158\229\138\1605\230\172\161\230\140\145\230\136\152\230\156\186\228\188\154\239\188\159"), ed.pvpManager.buyTime + 1, cost),
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.pvpManager.buyTimeCost = cost
        ed.pvpNetwork:sendBuyTimes()
      end
    })
  elseif cost > ed.player._rmb then
    ed.showHandyDialog("toRecharge")
  else
    ed.showToast(T("\229\183\178\232\190\190\228\187\138\230\151\165\230\156\128\229\164\167\232\180\173\228\185\176\230\172\161\230\149\176"))
  end
end

function pvpMainScene:refreshChallengeTimes()
  ed.setString(self.ui.label_times, string.format(T("\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176%d/5"), ed.pvpManager.leftTime))
end

function pvpMainScene:challengeEnemy(data)
  if ed.pvpManager.leftTime == 0 then
    self:buyPvpTime()
    return
  end
  if ed.pvpManager.lastBtTime ~= 0 and ed.getServerTime() - ed.pvpManager.lastBtTime < 16 then
    ed.showToast(T("\228\184\138\228\184\128\230\172\161\230\140\145\230\136\152\231\154\13215\231\167\146\229\144\142\230\137\141\232\131\189\230\140\145\230\136\152"))
    return
  end
  ed.pushScene(ed.ui.battleprepare.create({
    pvpMode = "attack",
    enemyId = data._user_id,
    stage_id = -1,
    enemyHeros = data._heros,
    objData = data,
    pvpActivityInfo = self:isOpenPvpActivity() and self.pvpActivityInfo or nil,
    pvpLegendEquipAct = self:isOpenLegendEquipAct() and self.pvpLegendEquipAct or nil
  }))
end

function pvpMainScene:createSweepEnemyItem(data)
  local container, ui = self:createEnemyItem(data)
  ui.btn_start:setVisible(false)
  ui.btn_sweep1:setVisible(true)
  ui.btn_sweep5:setVisible(true)
  return container, ui
end

local function adapt(parent, ui, oSize)
  local size = parent:getContentSize()
  local x, y = ui:getPosition()
  ui:setPosition(x / oSize.width * size.width, y / oSize.height * size.height)
end

function pvpMainScene:createEnemyItem(data)
  local container, ui = ed.editorui(ed.uieditor.arenaEnemyItem)
  ed.setLabelStroke(ui.name, ed.toccc3(2366999), 1)
  ed.setLabelStroke(ui.gs_num, ed.toccc3(2366999), 1)
  ed.setLabelShadow(ui.label_start, ccc3(0, 0, 0), ccp(1, 0))
  ed.setLabelShadow(ui.Label_7493, ccc3(15, 94, 144), ccp(1, 0))
  ed.setLabelShadow(ui.Label_7494, ccc3(15, 94, 144), ccp(1, 0))
  local size = ui.bg:getContentSize()
  ui.bg:setContentSize(CCSizeMake(size.width + self.bgFixWidth, size.height + self.bgFixHeight / 4 - 2))
  adapt(ui.bg, ui.head, size)
  adapt(ui.bg, ui.rankNum, size)
  adapt(ui.bg, ui.gs, size)
  adapt(ui.bg, ui.gs_num, size)
  adapt(ui.bg, ui.rank, size)
  adapt(ui.bg, ui.layer_mid, size)
  adapt(ui.bg, ui.btn_start, size)
  adapt(ui.bg, ui.btn_sweep1, size)
  adapt(ui.bg, ui.btn_sweep5, size)
  adapt(ui.bg, ui.bg_gs, size)
  ui.label_start:limitWidthByScale(65)
  ui.rank:limitWidthByScale(60)
  ed.right2(ui.rankNum, ui.rank, 2)
  local summary = data._summary
  local nameScale = 0.8
  if summary._guild_name and summary._guild_name == ed.player:getGuildName() then
    local bg_gs = ed.createSpriteTools({
      res = "UI/alpha/1080P/pvp/same_guild_name_bg.png",
      pos = ccp(ui.bg_gs:getPosition()),
      anchor = ccp(0, 0.5),
      parent = ui.bg_gs:getParent(),
      rectMake = CCRectMake(17, 1, 300, 1),
      sizeMake = CCSizeMake(330, 24),
      scale = 0.85
    })
    ui.bg_gs:removeFromParentAndCleanup(true)
    ui.bg_gs = bg_gs
    local samebg = ed.createSpriteTools({
      res = "UI/alpha/1080P/pvp/same_guild_icon.png",
      pos = ccp(220, 12),
      parent = ui.bg_gs,
      scale = 1.2
    })
    ed.createLabelTools({
      txt = T("\229\144\140\229\133\172\228\188\154"),
      size = 12,
      pos = ccp(29.25, 9.25),
      color = ed.toccc3(16776423),
      parent = samebg,
      anchor = ccp(0.5, 0.5),
      stroke = {
        ed.toccc3(8082195),
        1
      }
    })
    nameScale = 0.93
    ui.name:setPositionY(ui.name:getPositionY() + 2)
  end
  local nameStr = summary._name or ""
  if self.endTime and self.endTime >= ed.getServerTime() and self.pvpActivityInfo.activityType == "arena_phantom" and nameStr == "\231\139\130\230\172\162\231\154\132\233\173\133\229\189\177" then
    nameStr = T(nameStr)
  end
  nameStr = ed.transBotName(nameStr)
  local name = ed.getPlayerName(nameStr, summary._medal, {left = true})
  ed.UITool.replaceUI(ui, "bg_gs", "name", name)
  name:setScale(nameScale)
  ed.setString(ui.gs_num, data._gs)
  local rankNum = ed.getNumberNode({
    text = data._rank,
    folder = "big_pvp",
    padding = -1
  }).node
  rankNum:setAnchorPoint(ccp(0, 0.5))
  rankNum:setScale(0.7)
  ed.UITool.replaceUI(ui, "bg", "rankNum", rankNum)
  local param = {
    id = summary._avatar,
    level = 0 < summary._level and summary._level or nil,
    lvoffset = {x = -47, y = -35}
  }
  local head, headIcon = ed.getWholeHeadIcon(param)
  head:setScale(0.8)
  ed.UITool.replaceUI(ui, "bg", "head", head)
  self:btRegisterButtonClick({
    button = headIcon,
    key = string.format("head%s", data._user_id),
    force = true,
    pressScale = 0.95,
    clickHandler = function()
      if self.endTime and self.endTime >= ed.getServerTime() and self.pvpActivityInfo.activityType == "arena_phantom" then
        ed.showToast(T("\229\129\135\233\157\162\231\139\130\230\172\162\230\156\159\233\151\180\230\151\160\230\179\149\232\183\179\232\189\172\230\136\152\233\152\159\232\141\163\232\170\137"))
      else
        ed.UITool.openView("playerInfoPanel", summary._role_id)
      end
    end
  })
  for i = 1, 5 do
    ui["hero" .. i]:setVisible(false)
    if data._heros[i] then
      local x, y = ui["hero" .. i]:getPosition()
      local heroinfo = ed.readhero.createIconByServer(data._heros[i])
      local head = heroinfo.icon
      heroinfo:showLegendEquip(ed.off_legendEquipOp)
      head:setPosition(ccp(x, y))
      head:setScale(0.57)
      ui.layer_mid:addChild(head)
      self:btRegisterButtonClick({
        button = head,
        key = string.format("hero_%s_%s", data._user_id, i),
        force = true,
        pressScale = 0.55,
        normalScale = 0.57,
        clickHandler = function()
          ed.ui.checkOthersHeroWindow.create(data._heros[i]):popWindow()
        end
      })
    end
  end
  return container, ui
end

function pvpMainScene:showHeroInfo(data)
  local param
  if ed.netreply.pvpRecordOppoInfoReply then
    param = ed.netreply.pvpRecordOppoInfoReply
    ed.netreply.pvpRecordOppoInfoReply = nil
  end
  local panel = ed.ui.userPvpSummaryWin.create(data, nil, param)
  panel:popWindow()
end

function pvpMainScene:sweep(uid, times)
  if ed.pvpManager.rank > 2000 then
    ed.showToast(T("2000\229\144\141\228\187\165\229\134\133\232\167\163\233\148\129\230\137\171\232\141\161\229\138\159\232\131\189\239\188\140\230\182\136\232\128\151\230\140\145\230\136\152\230\172\161\230\149\176\232\142\183\229\190\151\229\165\150\229\138\177"))
    return
  end
  if times > ed.pvpManager.leftTime then
    ed.showToast(T("\230\140\145\230\136\152\230\172\161\230\149\176\228\184\141\232\182\179"))
    return
  end
  local pvpSweep = ed.storage.getBool("pvpSweep")
  if not pvpSweep then
    ed.showConfirmDialog({
      text = T("\230\137\171\232\141\161\229\176\134\228\188\154\230\182\136\232\128\151\230\140\145\230\136\152\230\172\161\230\149\176\232\142\183\229\190\151\230\140\145\230\136\152\230\172\161\230\149\176\229\165\150\229\138\177\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\230\137\171\232\141\161?"),
      leftText = T("\229\143\150\230\182\136"),
      rightText = T("\231\161\174\229\174\154"),
      rightHandler = function()
        ed.pvpNetwork:sendSweepPvp(uid, times)
        ed.storage.setValue("pvpSweep", true)
      end
    })
  else
    local overfull = {}
    if ed.player:isItemOverfull({
      type = "arenapoint",
      amount = times * 100
    }) then
      table.insert(overfull, {
        type = "arenapoint",
        amount = times * 100
      })
    end
    if 0 < #overfull then
      ed.showConfirmDialog({
        text = T("\230\137\171\232\141\161\229\144\142\231\171\158\230\138\128\229\156\186\229\184\129\229\176\134\232\182\133\228\184\138\233\153\144\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\230\137\171\232\141\161?"),
        leftText = T("\229\143\150\230\182\136"),
        rightText = T("\231\161\174\229\174\154"),
        rightHandler = function()
          ed.pvpNetwork:sendSweepPvp(uid, times)
        end
      })
    else
      ed.pvpNetwork:sendSweepPvp(uid, times)
    end
  end
end

function pvpMainScene:initSelfRewards()
  local pvpRewardTable = ed.getDataTable("PVPRankReward")
  local selfRewardIndex
  for i, v in ipairs(pvpRewardTable) do
    if ed.pvpManager.rank <= v["Floor Rank"] and selfRewardIndex == nil then
      selfRewardIndex = i
      break
    end
  end
  if selfRewardIndex then
    local reward = pvpRewardTable[selfRewardIndex]
    local items = {}
    if reward then
      for i = 1, 10 do
        if reward["Reward Type " .. i] then
          local item = {
            type = reward["Reward Type " .. i],
            id = reward["Reward ID " .. i],
            amount = reward["Reward Amount " .. i]
          }
          table.insert(items, item)
        end
      end
    end
    self.curRewardList = items
  end
end

function pvpMainScene:refreshRewardDraglist()
  self:initSelfRewards()
  if not self.curRewardList then
    return
  end
  self.rewardDraglist:clearList()
  
  local function getPos(i)
    i = i - 1
    local ox, oy = 20, 48
    local dx, dy = 70, 28
    local row = math.floor(i / 3)
    local col = i - row * 3
    return ccp(ox + dx * col, oy - row * dy)
  end
  
  for k, v in ipairs(self.curRewardList) do
    local icon, label
    if v.type == "Diamond" then
      icon = ed.createSprite("UI/alpha/1080P/icon/diamond.png")
    elseif v.type == "Gold" then
      icon = ed.createSprite("UI/alpha/1080P/icon/gold.png")
    elseif v.type == "ArenaPoint" then
      icon = ed.createSprite("UI/alpha/1080P/icon/money_arenatoken_big.png")
    elseif v.type == "Item" then
      icon = ed.readequip.createIcon(v.id, 32)
    end
    label = ed.createLabelTTF("x" .. v.amount, 14)
    local pos = getPos(k)
    label:setColor(ccc3(255, 252, 231))
    label:setAnchorPoint(ccp(0, 0))
    label:setPosition(ccp(pos.x + 15, pos.y - 10))
    ed.setLabelStroke(label, ccc3(0, 0, 0), 1)
    icon:setPosition(pos)
    self.rewardDraglist:addItem(label)
    self.rewardDraglist:addItem(icon)
  end
  self.rewardDraglist:initListHeight(math.ceil(#self.curRewardList / 3) * 28)
end

function pvpMainScene:doPressInList()
  local function handler(x, y)
    for k, v in ipairs(self.uiList or {}) do
      local btn_start = v.btn_start
      
      if btn_start:isVisible() and ed.containsPoint(btn_start, x, y) then
        btn_start:setScale(0.86)
        return v
      end
      if v.btn_sweep1:isVisible() and ed.containsPoint(v.btn_sweep1, x, y) then
        v.btn_sweep1:setScale(0.9)
        return v
      end
      if v.btn_sweep5:isVisible() and ed.containsPoint(v.btn_sweep5, x, y) then
        v.btn_sweep5:setScale(0.9)
        return v
      end
      if v.head:isVisible() and ed.containsPoint(v.head, x, y) then
        v.head:setScale(0.75)
        return v
      end
    end
    return nil
  end
  
  return handler
end

function pvpMainScene:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if not tolua.isnull(v.btn_start) and v.btn_start:isVisible() and ed.containsPoint(v.btn_start, x, y) then
      self:challengeEnemy(v.data)
    end
    if not tolua.isnull(v.btn_sweep1) and v.btn_sweep1:isVisible() and ed.containsPoint(v.btn_sweep1, x, y) then
      self:sweep(ed.pvpManager.oppos[#ed.pvpManager.oppos]._summary._uid, 1)
    end
    if not tolua.isnull(v.btn_sweep5) and v.btn_sweep5:isVisible() and ed.containsPoint(v.btn_sweep5, x, y) then
      self:sweep(ed.pvpManager.oppos[#ed.pvpManager.oppos]._summary._uid, 5)
    end
    if not tolua.isnull(v.head) and v.head:isVisible() and ed.containsPoint(v.head, x, y) then
      ed.pvpNetwork:sendQueryOppo(v.data._user_id)
    end
  end
  
  return handler
end

function pvpMainScene:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    if not tolua.isnull(v.btn_start) then
      v.btn_start:setScale(0.9)
      v.btn_sweep1:setScale(1)
      v.btn_sweep5:setScale(1)
      v.head:setScale(0.8)
    end
  end
  
  return handler
end

function pvpMainScene:OnChatRsp(data)
  if not data._say or data._say._result == "success" then
  end
end

function pvpMainScene:refreshShareTime()
  local count = ed.pvpManager.leftShareCount
  ed.setLabelStroke(self.ui.label_share_times, ed.toccc3(4861743), 1)
  self.ui.label_share_times:setString(string.format(T("\229\136\134\228\186\171(%s)"), count))
  self.ui.label_share_times:limitWidthByScale(50)
end

function pvpMainScene:updateActivityLeftTime()
  if not self.endTime or self.endTime <= ed.getServerTime() then
    self.ui.bg_buff:setVisible(false)
    if self.endTime == ed.getServerTime() then
      ed.pvpNetwork:sendApplyOpponent()
    end
  else
    local buffBgPath = self.pvpActivityInfo.pvpActivityBuffBg
    self.ui.bg_buff:setVisible(true)
    if buffBgPath then
      ed.setTexture(self.ui.bg_buff, buffBgPath, true)
    end
    local leftTime = self.endTime - ed.getServerTime()
    leftTime = math.max(0, leftTime)
    local hour = math.floor(leftTime / 3600)
    local min = math.floor(leftTime % 3600 / 60)
    local second = math.floor(leftTime % 60)
    self.ui.label_buff_left_time:setString(T(string.format(T("%.2d:%.2d:%.2d"), hour, min, second)))
  end
end

function pvpMainScene:updateLegendEquipActLeftTime()
  if not self.legendEquipActEndTime or self.legendEquipActEndTime < ed.getServerTime() then
    return
  end
  local endTime = self.legendEquipActEndTime
  if endTime == ed.getServerTime() then
    ed.pvpNetwork:sendOpenPanel()
  else
    local leftTime = endTime - ed.getServerTime()
    leftTime = math.max(0, leftTime)
    local day = math.floor(leftTime / 86400)
    local hour = math.floor(leftTime % 86400 / 3600)
    local min = math.floor(leftTime % 3600 / 60)
    if 0 < day then
      self.ui.label_legend_equip_time:setString(string.format(T("%d\229\164\169%.2d\230\151\182"), day, hour))
    else
      self.ui.label_legend_equip_time:setString(string.format(T("%.2d\230\151\182%.2d\229\136\134"), hour, min))
    end
  end
end

function pvpMainScene:isOpenPvpActivity()
  if self.endTime and self.endTime > ed.getServerTime() then
    return true
  end
  return false
end

function pvpMainScene:isOpenLegendEquipAct()
  if self.pvpLegendEquipAct and self.pvpLegendEquipAct.endTime > ed.getServerTime() then
    return true
  end
  return false
end

function pvpMainScene:showBuffTips()
  local bg = ed.createScale9Sprite("UI/alpha/1080P/common/com_new_3.png", CCRectMake(8, 8, 37, 37))
  bg:setAnchorPoint(ccp(0.5, 1))
  local autoText = ed.ui.autoText.new()
  local rule = self.pvpActivityInfo and self.pvpActivityInfo.rules or ""
  local labelWidth = 400
  autoText:initParam({
    context = rule,
    fontSize = 18,
    lineSpacing = 4,
    maxWidth = labelWidth,
    color = ed.toccc3(16710632)
  })
  bg:addChild(autoText.node)
  local autoTextW, autoTextH = autoText:getCurContentSize()
  autoText.node:setPosition(25, autoTextH)
  bg:setContentSize(CCSizeMake(labelWidth + 40, autoTextH + 20))
  return bg
end
