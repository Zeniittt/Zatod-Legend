local class = newclass("g")
ed.battleprepareUiFun = class
local uiTab = ed.uieditor.battlePrepareLong

local function newWin(selfMain, key, objData)
  local self = {}
  setmetatable(self, class.mt)
  self.objData = type(objData) == "table" and objData or {}
  if key == "stageDetail" and self.objData.detail == nil then
    key = "exerciseStageDetail"
  end
  if key == "AwakeStage" and objData.isBoss then
    key = "AwakeStageBoss"
  end
  if key == "GuildMountBoss" then
    key = "GuildMount"
  end
  self.pageKey = key and "Panel_" .. key or "nil"
  self.uiTab = uiTab
  local readNode = ed.readnode.create(selfMain.mainLayer, selfMain.ui)
  readNode:addNode(self.uiTab)
  if not class.setPagesParent then
    for i, v in ipairs(ed.uieditor.battlePreparePages) do
      if v.base.name == "Panel_Pages" then
        v.base.parent = "Panel_right"
        break
      end
    end
  end
  readNode:addNode(ed.uieditor.battlePreparePages)
  self.ui = selfMain.ui
  self.mainSelf = selfMain
  self:setUiPoslays()
  self:setpageInit()
  if self.ui[self.pageKey] then
    self.ui[self.pageKey]:setVisible(true)
  end
  self:addPresetLayer()
  if self.mode == "HadesHeat" then
    self:addFireworkLayer()
  end
  self:createRecommendBtn()
  return self
end

class.newWin = newWin

local function setUiPoslays(self)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local newWid = ed.display.halfFixedWidth * 2
  local newHei = ed.display.halfFixedHeight * 2
  local lrWne = 0.25
  newWid = newWid - ed.display.getNotchHeight()
  self.mainSelf.mainLayer:setPositionX(self.mainSelf.mainLayer:getPositionX() + ed.display.getNotchHeight())
  self.ui.enemy_layFitNum:setVisible(false)
  ed.adaptLabel(self.ui.enemyLabel, {maxWidth = 25, minScale = 0.3})
  local leftMoPosX = (1 - lrWne) * newWid
  local thisCon = self.ui.lay9BJ:getContentSize()
  self.ui.lay9BJ:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, heightWin - 4))
  thisCon = self.ui.layBgs:getContentSize()
  self.ui.layBgs:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, heightWin - 5))
  self.ui.battlePrepare_fx_L:setVisible(false)
  self.ui.battlePrepare_fx_R:setVisible(false)
  self.mainSelf:btRegisterButtonClick({
    button = self.ui.battlePrepare_fx_L_1,
    pressHandler = function()
      self.mainSelf:topHerosIconTeamNewIdenx(self.mainSelf.teamNewIdenx - 1)
    end,
    force = true,
    pressScale = 1.1
  })
  self.mainSelf:btRegisterButtonClick({
    button = self.ui.battlePrepare_fx_R_1,
    pressHandler = function()
      self.mainSelf:topHerosIconTeamNewIdenx(self.mainSelf.teamNewIdenx + 1)
    end,
    force = true,
    pressScale = 1.1
  })
  local posXloc = leftMoPosX / 2
  local posYloc = newHei / 2
  self.ui.starImg_1:setPosition(self.ui.starImg_1:getPositionX() + posXloc, self.ui.starImg_1:getPositionY() + newHei)
  self.ui.starImg_2:setPositionX(self.ui.starImg_2:getPositionX() + posXloc)
  self.ui.starImg_3:setPositionY(self.ui.starImg_3:getPositionY() + posYloc)
  self.ui.starImg_4:setPosition(self.ui.starImg_4:getPositionX() + leftMoPosX, self.ui.starImg_4:getPositionY() + posYloc)
  local newPosY = self.ui.layEmeHeros:getPositionY()
  self.ui.layEmeHeros:setPositionY(newPosY + newHei)
  thisCon = self.ui.layEmeHeros:getContentSize()
  self.ui.layEmeHeros:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  self.ui.enemyTeamTit:setStroke(ccc3(39, 37, 36), 1.5)
  self.ui.yshe:setStroke(ccc3(39, 37, 36), 1.5)
  ed.setLabelStroke(self.ui.enemyLabel, ed.toccc3(4593174), 1)
  self.ui.enemyLabel:setFontName(ed.fontBold)
  local newPosX = self.ui.eneTeamItem:getPositionX()
  newPosX = newPosX + leftMoPosX * 0.5
  newPosX = newPosX < 174 and 174 or newPosX
  self.ui.eneTeamItem:setPositionX(newPosX)
  newPosY = self.ui.layLeftButs:getPositionY()
  self.ui.layLeftButs:setPositionY(newPosY + newHei)
  thisCon = self.ui.heros_items:getContentSize()
  self.ui.heros_items:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height + newHei))
  thisCon = self.ui.isbg:getContentSize()
  self.ui.isbg:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  self.ui.butts_list:setPositionX(self.ui.butts_list:getPositionX() + posXloc)
  self.ui.lin_L:setPositionX(self.ui.lin_L:getPositionX() + posXloc)
  self.ui.lin_R:setPositionX(self.ui.lin_R:getPositionX() + posXloc)
  self.ui.preset:setPositionX(self.ui.preset:getPositionX() + leftMoPosX)
  self.ui.preset_back:setPositionX(self.ui.preset_back:getPositionX() + leftMoPosX)
  thisCon = self.ui.myTeam9Img_4:getContentSize()
  self.ui.myTeam9Img_4:setContentSize(CCSizeMake(thisCon.width + leftMoPosX, thisCon.height))
  self.ui.myTeam9Img_4:setPositionX(self.ui.myTeam9Img_4:getPositionX() + leftMoPosX / 2)
  self.ui.layTeamitems:setPositionX(self.ui.layTeamitems:getPositionX() + leftMoPosX / 2)
  self.ui.image_total_add_bg:setPositionX(thisCon.width - self.ui.image_total_add_bg:getContentSize().width / 2 + leftMoPosX - 20)
  local thisCon9L = self.ui.myTeam9Img_2:getContentSize()
  local thisCon9R = self.ui.myTeam9Img_3:getContentSize()
  local thisCon9LrWne = thisCon9L.width / thisCon9R.width
  self.ui.myTeam9Img_2:setContentSize(CCSizeMake(thisCon9L.width + (1 - thisCon9LrWne) * leftMoPosX, thisCon9L.height))
  self.ui.myTeam9Img_3:setContentSize(CCSizeMake(thisCon9R.width + thisCon9LrWne * leftMoPosX, thisCon9R.height))
  self.ui.myTeam9Img_3:setPositionX(self.ui.myTeam9Img_3:getPositionX() + leftMoPosX)
  local posX, gapX = 15, 7
  for i = 1, self.mainSelf.totalSlotNum do
    local slotImg = ed.createSprite("UI/alpha/1080P/rogue/instance/instance_battle_hero_hc.png")
    local lightImg = ed.createSprite("UI/alpha/1080P/battle/herobucket-halo.png")
    local lockImg = ed.createSprite("UI/alpha/1080P/dungeon/stageinfo/lock.png")
    local slotSize = slotImg:getContentSize()
    slotImg:addChild(lightImg)
    lightImg:setScale(1.5)
    lightImg:setPosition(slotSize.width * 0.5, slotSize.height * 0.5)
    lightImg:setOpacity(0)
    slotImg:addChild(lockImg)
    lockImg:setPosition(slotSize.width * 0.5, slotSize.height * 0.5 + 3)
    self.ui["member_slot_" .. i] = slotImg
    self.ui["member_lock_" .. i] = lockImg
    self.ui["member_light_" .. i] = lightImg
    self.ui.layTeamitems:addChild(slotImg)
    slotImg:setPosition(posX + slotSize.width * 0.5, slotSize.height * 0.5 + 7)
    posX = posX + slotSize.width + gapX
  end
  local slotTeamSize = self.ui.layTeamitems:getContentSize()
  slotTeamSize.width = posX
  self.ui.layTeamitems:setContentSize(slotTeamSize)
  local maxSlotTeamWidth = self.ui.myTeam9Img_4:getContentSize().width
  if maxSlotTeamWidth < slotTeamSize.width then
    self.ui.layTeamitems:removeFromParentAndCleanup(false)
    
    local function refreshArrow()
      local listX, _ = self.ui.teamDraglist:getListPos()
      if -20 < listX then
        self.ui.team_left_arrow:setVisible(false)
      else
        self.ui.team_left_arrow:setVisible(true)
      end
      if listX < self.ui.teamDraglist.width - self.ui.teamDraglist.listWidth + 20 then
        self.ui.team_right_arrow:setVisible(false)
      else
        self.ui.team_right_arrow:setVisible(true)
      end
    end
    
    self.ui.teamDraglist = ed.UITool.createDraglist(self.ui.layMyTeams, {
      width = maxSlotTeamWidth - 10,
      height = slotTeamSize.height,
      doScroll = refreshArrow
    })
    self.ui.teamDraglist.mainLayer:setPositionX(5)
    self.ui.teamDraglist:addItem(self.ui.layTeamitems)
    self.ui.layTeamitems:setPosition(0, 0)
    self.ui.teamDraglist:initListWidth(slotTeamSize.width)
    self.ui.teamDraglist:makePosRightMost()
    self.ui.team_left_arrow:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
    self.ui.team_right_arrow:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
    self.ui.team_left_arrow:setPositionX(self.ui.team_left_arrow:getContentSize().width * 0.5 + 5)
    self.ui.team_right_arrow:setPositionX(maxSlotTeamWidth - self.ui.team_left_arrow:getContentSize().width * 0.5 - 5)
    self.ui.team_left_arrow:setZOrder(999)
    self.ui.team_right_arrow:setZOrder(999)
    refreshArrow()
  else
    self.ui.team_left_arrow:setVisible(false)
    self.ui.team_right_arrow:setVisible(false)
    self.ui.layTeamitems:setPositionX((maxSlotTeamWidth - slotTeamSize.width) * 0.5)
  end
  ed.layout.layoutWithMagin(self.ui.butt_off, {left = 30, top = 0})
  newPosX = self.ui.Panel_right:getPositionX()
  self.ui.Panel_right:setPositionX(newPosX + (1 - lrWne) * newWid)
  local rightMoPosX = lrWne * newWid
  thisCon = self.ui.bgRig:getContentSize()
  self.ui.bgRig:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, heightWin - 7.5))
  newPosX, newPosY = self.ui.bgRig2:getPosition()
  local rightMoPosXLocal = rightMoPosX / 2
  self.ui.bgRig2:setPosition(newPosX + rightMoPosXLocal, newPosY + newHei)
  self.ui.go:setPositionX(self.ui.go:getPositionX() + rightMoPosXLocal)
  self.ui.go_next:setPositionX(self.ui.go_next:getPositionX() + rightMoPosXLocal)
  self.ui.go_disable:setPositionX(self.ui.go_disable:getPositionX() + rightMoPosXLocal)
  self.ui.Panel_Pages:setPositionX(self.ui.Panel_Pages:getPositionX() + rightMoPosXLocal)
  self.ui.lin:setPosition(self.ui.lin:getPositionX() + rightMoPosXLocal, self.ui.lin:getPositionY() + newHei)
  self.ui.Label_title:setPositionY(self.ui.Label_title:getPositionY() + newHei)
  local newHeilocal = newHei / 1.5
  if self.pageKey == "Panel_dreamland" then
    thisCon = self.ui.ysmj_monster_txt:getContentSize()
    self.ui.ysmj_monster_txt:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.ysmj_monster_txt:setPositionX(self.ui.ysmj_monster_txt:getPositionX() - rightMoPosXLocal)
    self.ui.ysmj_modPos:setPositionY(self.ui.ysmj_modPos:getPositionY() + newHeilocal - 5)
    self.ui.Label_6277:setPositionY(self.ui.Label_6277:getPositionY() + posYloc)
    self.ui.ysmj_monster_txt:setPositionY(self.ui.ysmj_monster_txt:getPositionY() + posYloc)
    self.ui.Label_6277:setPositionX(self.ui.Label_6277:getPositionX() - rightMoPosXLocal)
    self.ui.Label_6277:setStroke(ccc3(39, 37, 36), 1.5)
    self.localRichtext = richText:new()
    self.ui.ysmj_num_pos:addChild(self.localRichtext.rootNode)
  elseif self.pageKey == "Panel_crusade" then
    local rightMoPosXlocal = rightMoPosX / 3
    self.ui.yz_level_1:setPosition(self.ui.yz_level_1:getPositionX() - rightMoPosXlocal, self.ui.yz_level_1:getPositionY() + posYloc)
    self.ui.yz_guil_1:setPosition(self.ui.yz_guil_1:getPositionX() - rightMoPosXlocal, self.ui.yz_guil_1:getPositionY() + posYloc)
    self.ui.yz_level_2:setPosition(self.ui.yz_level_2:getPositionX() + rightMoPosXlocal, self.ui.yz_level_2:getPositionY() + posYloc)
    self.ui.yz_guil_2:setPosition(self.ui.yz_guil_2:getPositionX() + rightMoPosXlocal, self.ui.yz_guil_2:getPositionY() + posYloc)
    self.ui.yuanzheng_name_bg:setPositionY(self.ui.yuanzheng_name_bg:getPositionY() + newHeilocal)
    self.ui.Panel_headPos:setPositionY(self.ui.Panel_headPos:getPositionY() + newHeilocal)
  elseif self.pageKey == "Panel_stageDetail" then
    thisCon = self.ui.detBossTxt:getContentSize()
    self.ui.detBossTxt:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.detBossTxt:setPositionX(self.ui.detBossTxt:getPositionX() - rightMoPosXLocal)
    self.ui.detBossTxt:setPositionY(self.ui.detBossTxt:getPositionY() + newHeilocal)
    self.ui.gaveitm:setPositionY(self.ui.gaveitm:getPositionY() + posYloc)
    self.ui.gaveitm:setPositionX(self.ui.gaveitm:getPositionX() - rightMoPosXLocal)
    self.ui.gaveitm:setStroke(ccc3(39, 37, 36), 1.5)
    self.ui.det_xiao:setPositionY(self.ui.det_xiao:getPositionY() + posYloc)
    self.ui.det_xiao:setPositionX(self.ui.det_xiao:getPositionX() - rightMoPosXLocal)
    self.ui.det_xiao:setStroke(ccc3(39, 37, 36), 1.5)
    self.ui.tiLiPos:setPositionY(self.ui.tiLiPos:getPositionY() + posYloc)
    self.ui.tiLiPos:setPositionX(self.ui.tiLiPos:getPositionX() - rightMoPosXLocal)
    thisCon = self.ui.gaveItemPos:getContentSize()
    self.ui.gaveItemPos:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.gaveItemPos:setPositionX(self.ui.gaveItemPos:getPositionX() - rightMoPosXLocal)
    self.ui.gaveItemPos:setPositionY(self.ui.gaveItemPos:getPositionY() + posYloc)
  elseif self.pageKey == "Panel_attack" then
    local strStroke = {
      "jjc_level_",
      "jjc_zhanLi_",
      "jjc_paim_",
      "jjc_shenLi_",
      "jjc_guild_"
    }
    for i, v in ipairs(strStroke) do
      for s = 1, 2 do
        self.ui[v .. s]:setStroke(ccc3(39, 37, 36), 1.5)
      end
    end
    self.ui.jjc_headPos:setPositionY(self.ui.jjc_headPos:getPositionY() + newHeilocal)
    self.ui.jjc_name_bg:setPositionY(self.ui.jjc_name_bg:getPositionY() + newHeilocal)
    self.ui.jjc_titStrpanel:setPositionY(self.ui.jjc_titStrpanel:getPositionY() + newHeilocal)
  elseif self.pageKey == "Panel_share_fight" then
    local strStroke = {
      "share_fight_level_",
      "share_fight_zhanLi_",
      "share_fight_guild_"
    }
    for i, v in ipairs(strStroke) do
      for s = 1, 2 do
        self.ui[v .. s]:setStroke(ccc3(39, 37, 36), 1.5)
      end
    end
    self.ui.share_fight_headPos:setPositionY(self.ui.share_fight_headPos:getPositionY() + newHeilocal)
    self.ui.share_fight_name_bg:setPositionY(self.ui.share_fight_name_bg:getPositionY() + newHeilocal)
    self.ui.share_fight_titStrpanel:setPositionY(self.ui.share_fight_titStrpanel:getPositionY() + newHeilocal)
  elseif self.pageKey == "Panel_exerciseStageDetail" then
    thisCon = self.ui.exercise_txt:getContentSize()
    self.ui.exercise_txt:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.exercise_txt:setPositionX(self.ui.exercise_txt:getPositionX() - rightMoPosXLocal)
    self.ui.exercise_txt:setPositionY(self.ui.exercise_txt:getPositionY() + newHeilocal)
    self.localRichtextWat = richText:new()
    self.ui.shuiCi_num_pos:addChild(self.localRichtextWat.rootNode)
    thisCon = self.ui.shuiCi_monster_txt:getContentSize()
    self.ui.shuiCi_monster_txt:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.shuiCi_monster_txt:setPositionX(self.ui.shuiCi_monster_txt:getPositionX() - rightMoPosXLocal)
    self.ui.shuiCi_monster_txt:setPositionY(self.ui.shuiCi_monster_txt:getPositionY() + posYloc)
    self.ui.shuiCi_modPos:setPositionY(self.ui.shuiCi_modPos:getPositionY() + newHeilocal)
    self.ui.shuiCi_6277:setPositionY(self.ui.shuiCi_6277:getPositionY() + posYloc)
    self.ui.shuiCi_6277:setPositionX(self.ui.shuiCi_6277:getPositionX() - rightMoPosXLocal)
  elseif self.pageKey == "Panel_FancyTower" then
    self.ui.Label_tower:setPositionX(self.ui.Label_tower:getPositionX() - rightMoPosXLocal)
    self.ui.Label_tower:setPositionY(self.ui.Label_tower:getPositionY() + newHeilocal)
    self.ui.Label_tower:setStroke(ccc3(39, 37, 36), 1.5)
    thisCon = self.ui.tower_txt:getContentSize()
    self.ui.tower_txt:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.tower_txt:setPositionX(self.ui.tower_txt:getPositionX() - rightMoPosXLocal)
    self.ui.tower_txt:setPositionY(self.ui.tower_txt:getPositionY() + newHeilocal)
    self.ui.Label_tower_item:setPositionY(self.ui.Label_tower_item:getPositionY() + posYloc)
    self.ui.Label_tower_item:setPositionX(self.ui.Label_tower_item:getPositionX() - rightMoPosXLocal)
    self.ui.Label_tower_item:setStroke(ccc3(39, 37, 36), 1.5)
    thisCon = self.ui.tower_item_pos:getContentSize()
    self.ui.tower_item_pos:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.tower_item_pos:setPositionX(self.ui.tower_item_pos:getPositionX() - rightMoPosXLocal)
    self.ui.tower_item_pos:setPositionY(self.ui.tower_item_pos:getPositionY() + posYloc)
  elseif self.pageKey == "Panel_ActivityAdventure" then
    thisCon = self.ui.adventure_stage_desc:getContentSize()
    self.ui.adventure_stage_desc:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.adventure_stage_desc:setPositionX(self.ui.adventure_stage_desc:getPositionX() - rightMoPosXLocal)
    self.ui.adventure_stage_desc:setPositionY(self.ui.adventure_stage_desc:getPositionY() + newHeilocal)
    self.ui.Label_adventure_item:setPositionY(self.ui.Label_adventure_item:getPositionY() + posYloc)
    self.ui.Label_adventure_item:setPositionX(self.ui.Label_adventure_item:getPositionX() - rightMoPosXLocal)
    self.ui.Label_adventure_item:setStroke(ccc3(39, 37, 36), 1.5)
    thisCon = self.ui.adventure_item_pos:getContentSize()
    self.ui.adventure_item_pos:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.adventure_item_pos:setPositionX(self.ui.adventure_item_pos:getPositionX() - rightMoPosXLocal)
    self.ui.adventure_item_pos:setPositionY(self.ui.adventure_item_pos:getPositionY() + posYloc)
  elseif self.pageKey == "Panel_FancyAbyss" then
    thisCon = self.ui.fancyabyss_stage_desc:getContentSize()
    self.ui.fancyabyss_stage_desc:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.fancyabyss_stage_desc:setPositionX(self.ui.fancyabyss_stage_desc:getPositionX() - rightMoPosXLocal)
    self.ui.fancyabyss_stage_desc:setPositionY(self.ui.fancyabyss_stage_desc:getPositionY() + newHeilocal)
    self.ui.Label_fancyabyss_item:setPositionY(self.ui.Label_fancyabyss_item:getPositionY() + posYloc)
    self.ui.Label_fancyabyss_item:setPositionX(self.ui.Label_fancyabyss_item:getPositionX() - rightMoPosXLocal)
    self.ui.Label_fancyabyss_item:setStroke(ccc3(39, 37, 36), 1.5)
    self.ui.img_time:setPositionY(self.ui.img_time:getPositionY() + posYloc)
    self.ui.img_time:setPositionX(self.ui.img_time:getPositionX() - rightMoPosXLocal)
    thisCon = self.ui.fancyabyss_item_pos:getContentSize()
    self.ui.fancyabyss_item_pos:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.fancyabyss_item_pos:setPositionX(self.ui.fancyabyss_item_pos:getPositionX() - rightMoPosXLocal)
    self.ui.fancyabyss_item_pos:setPositionY(self.ui.fancyabyss_item_pos:getPositionY() + posYloc)
  elseif self.pageKey == "Panel_AwakeStage" then
    ed.setLabelStroke(self.ui.as_condition_title, ed.toccc3(1907737), 1)
    ed.setLabelStroke(self.ui.as_efficiency_title, ed.toccc3(1907737), 1)
    thisCon = self.ui.as_des:getContentSize()
    self.ui.as_des:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.as_des:setPositionX(self.ui.as_des:getPositionX() - rightMoPosXLocal)
    self.ui.as_des:setPositionY(self.ui.as_des:getPositionY() + newHeilocal)
    self.ui.as_energy_title:setPositionX(self.ui.as_energy_title:getPositionX() - rightMoPosXLocal)
    self.ui.as_energy_title:setStroke(ccc3(39, 37, 36), 1.5)
    self.ui.as_reward_title:setPositionX(self.ui.as_reward_title:getPositionX() - rightMoPosXLocal)
    self.ui.as_reward_title:setStroke(ccc3(39, 37, 36), 1.5)
    thisCon = self.ui.as_reward_panel:getContentSize()
    self.ui.as_reward_panel:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.as_reward_panel:setPositionX(self.ui.as_reward_panel:getPositionX() - rightMoPosXLocal)
    self.ui.as_efficiency_title:setPositionX(self.ui.as_efficiency_title:getPositionX() - rightMoPosXLocal)
    thisCon = self.ui.as_efficiency_panel:getContentSize()
    self.ui.as_efficiency_panel:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.as_efficiency_panel:setPositionX(self.ui.as_efficiency_panel:getPositionX() - rightMoPosXLocal)
    self.ui.as_condition_title:setPositionX(self.ui.as_condition_title:getPositionX() - rightMoPosXLocal)
    thisCon = self.ui.as_condition_panel:getContentSize()
    self.ui.as_condition_panel:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.as_condition_panel:setPositionX(self.ui.as_condition_panel:getPositionX() - rightMoPosXLocal)
    self.ui.as_buff_bg:setPositionX(self.ui.as_buff_bg:getPositionX() - rightMoPosXLocal)
  elseif self.pageKey == "Panel_AwakeStageBoss" then
    local layer = CCLayer:create()
    layer:setContentSize(CCSizeMake(206, 475))
    self.ui.Panel_Pages:addChild(layer)
    self.AwakeStageBossLayer = layer
    layer:setContentSize(CCSizeMake(206, 475 + newHei))
  elseif self.pageKey == "Panel_HadesHeat" then
    thisCon = self.ui.detBossTxt:getContentSize()
    self.ui.detBossTxt:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.detBossTxt:setPositionX(self.ui.detBossTxt:getPositionX() - rightMoPosXLocal)
    self.ui.detBossTxt:setPositionY(self.ui.detBossTxt:getPositionY() + newHeilocal)
    self.ui.image_firework_tattoo:setPositionY(self.ui.image_firework_tattoo:getPositionY() + newHeilocal)
    self.ui.hades_boss_pos:setPositionY(self.ui.hades_boss_pos:getPositionY() + newHeilocal)
    self.ui.hades_heat_boss_desc:setPositionY(self.ui.hades_heat_boss_desc:getPositionY() + newHeilocal)
    self.ui.label_firework:setPositionY(self.ui.label_firework:getPositionY() + newHeilocal)
    self.ui.panel_firework:setPositionY(self.ui.panel_firework:getPositionY() + newHeilocal)
  elseif self.pageKey == "Panel_GuildClash" then
    ed.setLabelStroke(self.ui.guildClash_tips1, ed.toccc3(2565412), 1)
    ed.setLabelStroke(self.ui.guildClash_guild_team_amount, ed.toccc3(2565412), 1)
    ed.setLabelStroke(self.ui.guildClash_tips2, ed.toccc3(2565412), 1)
    ed.setLabelStroke(self.ui.guildClash_my_team_amount, ed.toccc3(2565412), 1)
    self.ui.guildClash_boss_pos:setPositionX(self.ui.guildClash_boss_pos:getPositionX() - rightMoPosXLocal + 20)
  elseif self.pageKey == "Panel_GuildMount" then
    thisCon = self.ui.boss_desc:getContentSize()
    self.ui.boss_desc:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.boss_desc:setPositionX(self.ui.boss_desc:getPositionX() - rightMoPosXLocal)
    thisCon = self.ui.buff_desc:getContentSize()
    self.ui.buff_desc:setContentSize(CCSizeMake(thisCon.width + rightMoPosX, thisCon.height))
    self.ui.buff_desc:setPositionX(self.ui.buff_desc:getPositionX() - rightMoPosXLocal)
    self.ui.boss_modPos:setPositionY(self.ui.boss_modPos:getPositionY() + newHeilocal - 5)
    self.ui.stage_buff:setPositionY(self.ui.stage_buff:getPositionY() + newHeilocal - 5)
    self.ui.boss_desc:setPositionY(self.ui.boss_desc:getPositionY() + newHeilocal - 5)
  end
  self.ui.shuiCi_6277:setStroke(ccc3(39, 37, 36), 1.5)
end

class.setUiPoslays = setUiPoslays

local function setLeftWinInit(self)
end

class.setLeftWinInit = setLeftWinInit

local function setpageInit(self)
  if self.pageFunSet[self.pageKey] then
    self.pageFunSet[self.pageKey].init(self)
  end
  if self.objData and self.fitNum then
    self.ui.enemy_layFitNum:setVisible(true)
    self.ui.gs_eme:setString(self.fitNum or "0")
  end
end

class.setpageInit = setpageInit

local function PanelYsmjFun(self)
  self.mainSelf:initTopHerosIconTeam(1)
  local strs = "<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5 >" .. self.objData.monsSkil.skli .. "</lable>"
  local thisCon = self.ui.ysmj_monster_txt:getContentSize()
  local label_boss_desc = ed.ui.autoText.new()
  label_boss_desc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 5,
    maxWidth = thisCon.width,
    maxHeight = thisCon.height * 1.7,
    color = ccc3(255, 252, 231)
  })
  self.ui.ysmj_monster_txt:addChild(label_boss_desc.node)
  label_boss_desc.node:setPositionY(thisCon.height - 10)
  self.localRichtext:setString(self.objData.monsSkil.chance)
  self.ui.Label_title:setString(self.objData.modTxt.name)
  self.ui.Label_title:limitWidthByScale(thisCon.width)
  local layer = self.ui.ysmj_modPos
  local config = self.objData.modTxt
  local fca_res = self.objData.modTxt.fca
  local fca_name, actor
  local puppet_tbl_data = ed.getDataTable("Puppet")[fca_res]
  if puppet_tbl_data and puppet_tbl_data.Resource then
    fca_name = puppet_tbl_data.Resource
    actor = ed.createFcaActor(fca_name, 1)
    local comps = puppet_tbl_data["Change Components"]
    if comps and 0 < #comps then
      for i = 1, #comps, 2 do
        actor:setComponent(comps[i], comps[i + 1])
      end
    end
  else
    fca_name = string.gsub(fca_res, "%.cha$", "") or ""
    actor = ed.createFcaActor(fca_name, config.scale)
  end
  layer:addChild(actor, 10)
  self.mainSelf:addFca(actor)
  local action_name = config.action or "Idle"
  actor:setAction(action_name)
  actor:setLoop(true)
  if self.mainSelf.mode == "GuildMountBoss" then
    local tbData = ed.getDataTable("GuildMountBoss")[ed.GuildMountManager:getCurBoss()._id]
    if tbData then
      ed.useHSVShaderV2(actor, tbData.Hue, tbData.Saturation, tbData.Value)
      local bossEffect = ed.createFcaNode("eff_UI_GuildMount_boss")
      bossEffect:setScale(0.5)
      self.mainSelf:addFca(bossEffect)
      actor:addChild(bossEffect)
    end
    self.localRichtext:setVisible(false)
    self.ui.Label_6277_Copy0:setVisible(false)
    local posx, posy = self.ui.go:getPosition()
    local extraInfo = ed.GuildMountManager:getExtraTime()
    if extraInfo then
      local time = extraInfo and (extraInfo._duration or 0) or 0
      ed.createLabelTools({
        txt = string.format(T("\230\136\152\230\150\151\232\161\165\230\151\182\239\188\154%d\231\167\146"), time),
        size = 15,
        pos = ccp(posx, posy + 40),
        color = ccc3(ed.colorToStr("#b1b0c0")),
        parent = self.ui.go:getParent()
      })
    end
  end
end

local function PanelYsmjFunUpData(self)
end

local function PanelCrusadeFun(self)
  if self.objData.isAdvanceTeam then
    self.ui.enemyLabel:setVisible(false)
    self.ui.enemyTeamTit:setString(T("\230\142\168\232\141\144\232\139\177\233\155\132"))
    self.ui.enemyTeamTit:setColor(ccc3(255, 252, 229))
    ed.setLabelStroke(self.ui.enemyTeamTit, ccc3(0, 0, 0), 1)
    local thisCon = self.ui.isbg:getContentSize()
    local isScale = thisCon.width <= 660
    ed.createSpriteTools({
      res = "UI/alpha/1080P/crusade/rush/icon_2.png",
      pos = ccp(self.ui.enemyLabel:getPosition()),
      parent = self.ui.enemyFitLay
    })
    local posx, posy = 0, 0
    if isScale then
      self.teamGradeBj = ed.createSpriteTools({
        res = "UI/alpha/1080P/crusade/rush/score_bg_small.png",
        pos = ccp(-23, 80),
        parent = self.ui.lay9BJ
      })
      ed.createLabelTools({
        txt = T("\232\175\132\228\187\183"),
        size = 14,
        pos = ccp(30, 76),
        color = ccc3(255, 252, 231),
        stroke = {
          ccc3(ed.colorToStr("#614017")),
          1
        },
        parent = self.teamGradeBj
      })
      posx, posy = -30, 65
    else
      self.teamGradeBj = ed.createSpriteTools({
        res = "UI/alpha/1080P/crusade/rush/score_bg.png",
        pos = ccp(30, thisCon.height / 2 + 20 - 58),
        parent = self.ui.layUp_ButOrBg
      })
      ed.createLabelTools({
        txt = T("\232\175\132\228\187\183\239\188\154"),
        size = 14,
        pos = ccp(30, 13),
        color = ccc3(255, 252, 231),
        stroke = {
          ccc3(ed.colorToStr("#614017")),
          1
        },
        parent = self.teamGradeBj
      })
    end
    self.teamGradeIcons = {
      gradeA = ed.createSpriteTools({
        res = "UI/alpha/1080P/crusade/rush/a.png",
        pos = ccp(60 + posx, -30 + posy),
        parent = self.teamGradeBj,
        notShow = true
      }),
      gradeB = ed.createSpriteTools({
        res = "UI/alpha/1080P/crusade/rush/b.png",
        pos = ccp(60 + posx, -30 + posy),
        parent = self.teamGradeBj,
        notShow = true
      }),
      gradeC = ed.createSpriteTools({
        res = "UI/alpha/1080P/crusade/rush/c.png",
        pos = ccp(60 + posx, -30 + posy),
        parent = self.teamGradeBj,
        notShow = true
      }),
      gradeD = ed.createSpriteTools({
        res = "UI/alpha/1080P/crusade/rush/d.png",
        pos = ccp(60 + posx, -30 + posy),
        parent = self.teamGradeBj,
        notShow = true
      }),
      gradeS = ed.createSpriteTools({
        res = "UI/alpha/1080P/crusade/rush/s.png",
        pos = ccp(60 + posx, -30 + posy),
        parent = self.teamGradeBj,
        notShow = true
      })
    }
    if self.mainSelf.currentGrade then
      self.teamGradeIcons[self.mainSelf.currentGrade]:setVisible(true)
    end
    self.ui.yz_level_1:setVisible(false)
    self.ui.yz_level_2:setVisible(false)
    self.ui.yz_guil_1:setVisible(false)
    self.ui.yz_guil_2:setVisible(false)
    self.ui.Panel_headPos:setVisible(false)
    self.ui.yuanzheng_name_bg:setVisible(false)
    self.ui.Label_title:setString(T("\229\133\136\233\129\163\233\152\159"))
    local txts = {
      T("1.\229\133\136\233\129\163\233\152\159\229\176\134\229\138\169\229\138\155\233\152\159\233\149\191<lable color=ccc3(255,236,183)>\229\191\171\233\128\159\230\137\171\232\141\161\232\191\156\229\190\129</lable>"),
      T("2.\229\133\136\233\129\163\233\152\159<lable color=ccc3(255,236,183)>\232\175\132\231\186\167\232\182\138\233\171\152</lable>\239\188\140\229\143\175\230\137\171\232\141\161<lable color=ccc3(255,236,183)>\232\191\155\229\186\166\232\182\138\233\171\152</lable>"),
      T("3.\228\189\191\231\148\168<lable color=ccc3(255,236,183)>\230\142\168\232\141\144\232\139\177\233\155\132</lable>,\229\176\134\229\156\168\232\175\132\231\186\167\230\151\182\232\142\183\229\190\151<lable color=ccc3(255,236,183)>\229\138\160\230\136\144</lable>")
    }
    local size = self.ui.Panel_crusade:getContentSize()
    for i, v in ipairs(txts) do
      local pict = ed.createSprite("UI/alpha/1080P/crusade/rush/score_rules_bg.png")
      self.ui.Panel_crusade:addChild(pict)
      pict:setPosition(100, size.height - 75 * i - 30)
      pict:setOpacity(80)
      if isScale then
        pict:setScale(0.85)
      end
      local autoText = ed.ui.autoText.new()
      autoText:initParam({
        context = v,
        maxWidth = 220,
        color = ccc3(255, 252, 231),
        maxHeight = pict:getContentSize().height * pict:getScale()
      })
      autoText.node:setPosition(ccp(16, 38))
      pict:addChild(autoText.node)
    end
  else
    self.ui.Label_title:setString(T("\232\191\156\229\190\129 %s", self.objData.currentBattle))
    self.ui.yz_level_2:setString(T("%s\231\186\167", self.objData.newLevel))
    self.ui.yz_guil_2:setString(self.objData.guildName == "" and T("\230\151\160") or self.objData.guildName)
    local name = ed.getPlayerName(ed.transBotName(self.objData.heroName), self.objData.heroMedal, {
      anchorPoint = self.ui.yuanzheng_name:getAnchorPoint()
    })
    ed.UITool.replaceUI(self.ui, "yuanzheng_name_bg", "yuanzheng_name", name)
    if self.objData.param then
      local head = ed.getHeroIconByID(self.objData.param)
      if head then
        self.ui.Panel_headPos:removeAllChildrenWithCleanup(true)
        self.ui.Panel_headPos:addChild(head)
      end
    end
  end
end

local function PanelMonsterFun(self)
  self.mainSelf:initTopHerosIconTeam(1)
  self.ui.Label_title:setString(self.objData.titleName or "")
  local strs = "<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5 >" .. self.objData.detail .. "</lable>"
  local thisCon = self.ui.detBossTxt:getContentSize()
  local label_boss_desc = ed.ui.autoText.new()
  label_boss_desc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 5,
    maxWidth = thisCon.width,
    color = ccc3(255, 252, 231)
  })
  self.ui.detBossTxt:addChild(label_boss_desc.node)
  label_boss_desc.node:setPositionY(thisCon.height - 10)
  local _, height = label_boss_desc:getCurContentSize()
  local heis = height - thisCon.height
  if 0 < heis then
    self.ui.gaveitm:setPositionY(self.ui.gaveitm:getPositionY() - heis)
    self.ui.det_xiao:setPositionY(self.ui.det_xiao:getPositionY() - heis)
    self.ui.tiLiPos:setPositionY(self.ui.tiLiPos:getPositionY() - heis)
    self.ui.gaveItemPos:setPositionY(self.ui.gaveItemPos:getPositionY() - heis)
  end
  local lable = richText:new()
  local str = T("<text|battleprepare_title|%s ><sprite|UI/alpha/1080P/icon/vitality.png|1>", self.objData.powerNum or 0)
  lable:setString(str)
  local posx, posy = self.ui.tiLiPos:getPosition()
  lable:setPosition(ccp(posx, posy))
  self.ui.Panel_stageDetail:addChild(lable.rootNode)
  if self.objData and self.objData.items then
    local thisCon = self.ui.gaveItemPos:getContentSize()
    local itemWid = 50
    local maxNu = math.floor(thisCon.width / itemWid)
    local addWid = (thisCon.width - maxNu * itemWid) / maxNu
    itemWid = itemWid + addWid
    local posX, posY = itemWid / 2, thisCon.height - itemWid / 2
    for i, v in ipairs(self.objData.items) do
      local icon
      if v.isSpring then
        icon = ed.readequip.createIconWithAmount(v.id, nil, v.cnt)
      else
        icon = ed.readequip.createIcon(v.id, nil, v.cnt)
      end
      icon:setPosition(posX, posY)
      if posX + itemWid * 1.5 > thisCon.width then
        posX, posY = itemWid / 2, posY - itemWid - 5
      else
        posX = posX + itemWid
      end
      self.ui.gaveItemPos:addChild(icon)
      icon:setScale(0.55)
      self.mainSelf:btRegisterButtonClick({
        button = icon,
        key = "BtnItemClick" .. i,
        pressHandler = function()
          self:createDetailCard(icon, v.id)
        end,
        cancelPressHandler = function()
          self:removeDetailCard()
        end,
        force = true
      })
    end
    self.ui.gaveItemPos:setPositionX(self.ui.gaveItemPos:getPositionX() - addWid - 4)
  else
    self.ui.gaveitm:setVisible(false)
  end
end

local function PanelAttackFun(self)
  self.ui.Label_title:setString(T("\231\171\158\230\138\128\229\156\186\229\175\185\230\137\139"))
  local summary = self.objData._summary
  local head = ed.getTeamHead({
    id = summary._avatar,
    vip = summary._vip > 0
  })
  head:setPosition(self.ui.jjc_headPos:getPosition())
  self.ui.Panel_attack:addChild(head)
  local name = ed.getPlayerName(ed.transBotName(summary._name), summary._medal, {
    anchorPoint = self.ui.jjc_role_name:getAnchorPoint()
  })
  ed.UITool.replaceUI(self.ui, "jjc_name_bg", "jjc_role_name", name)
  self.ui.jjc_level_2:setString(summary._level)
  self.ui.jjc_guild_2:setString(summary._guild_name or T("\230\151\160"))
  self.ui.jjc_paim_2:setString(self.objData._rank or "")
  self.ui.jjc_shenLi_2:setString(self.objData._win_cnt or "")
  self.ui.jjc_zhanLi_2:setString(self.objData._gs or "")
  self.fitNum = self.objData._gs or ""
end

local function PanelShareFightFun(self)
  self.ui.Label_title:setString(T("\229\136\135\231\163\139\229\175\185\230\137\139"))
  local summary = self.objData._summary
  local head = ed.getTeamHead({
    id = summary._avatar,
    vip = summary._vip > 0
  })
  head:setPosition(self.ui.jjc_headPos:getPosition())
  self.ui.Panel_share_fight:addChild(head)
  local name = ed.getPlayerName(summary._name, summary._medal, {
    anchorPoint = self.ui.share_fight_role_name:getAnchorPoint()
  })
  ed.UITool.replaceUI(self.ui, "share_fight_name_bg", "share_fight_role_name", name)
  self.ui.share_fight_level_2:setString(summary._level)
  self.ui.share_fight_guild_2:setString(summary._guild_name or T("\230\151\160"))
  self.ui.share_fight_zhanLi_2:setString(self.objData._gs or "")
end

local function PanelExerciseStageFun(self)
  self.mainSelf:initTopHerosIconTeam(1)
  self.ui.Label_title:setString(self.objData.titleName)
  local strs = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5>%s</lable>", self.objData.detail)
  local thisCon = self.ui.exercise_txt:getContentSize()
  local label_boss_desc = ed.ui.autoText.new()
  label_boss_desc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 5,
    maxWidth = thisCon.width,
    color = ccc3(255, 252, 231)
  })
  self.ui.exercise_txt:addChild(label_boss_desc.node)
  label_boss_desc.node:setPositionY(thisCon.height - 10)
  local chance = self.objData.countLimit.count or 0
  local colors = chance <= 0 and "dreamland_red" or "dreamland_white"
  local str = string.format("<text|%s|%s><text|dreamland_white|/><text|dreamland_white|%s>", colors, chance, self.objData.countLimit.countLimit or 0)
  self.localRichtextWat:setString(str)
  for k, v in pairs(self.objData.monMod) do
    local fn = ed.createFcaActor(v.res, v.scale)
    fn:setAction(v.fcaaction or "Idle")
    fn:setLoop(true)
    self.ui.shuiCi_modPos:addChild(fn, 10)
    self.mainSelf:addFca(fn)
    if v.shader then
      fn:useShader(v.shader)
    end
    fn:setScale(1.5)
  end
  if self.objData and self.objData.items then
    local thisCon = self.ui.shuiCi_monster_txt:getContentSize()
    local itemWid = 50
    local maxNu = math.floor(thisCon.width / itemWid)
    local addWid = (thisCon.width - maxNu * itemWid) / maxNu
    itemWid = itemWid + addWid
    local posX, posY = itemWid / 2, thisCon.height - itemWid / 2
    for i, v in ipairs(self.objData.items) do
      local icon
      if v.isSpring then
        icon = ed.readequip.createIconWithAmount(v.id, nil, v.cnt)
      else
        icon = ed.readequip.createIcon(v.id, nil, v.cnt)
      end
      icon:setPosition(posX, posY)
      if posX + itemWid * 1.5 > thisCon.width then
        posX, posY = itemWid / 2, posY - itemWid - 5
      else
        posX = posX + itemWid
      end
      self.ui.shuiCi_monster_txt:addChild(icon)
      icon:setScale(0.55)
      if v.type and not ed.getVirtualName(string.lower(v.type)) then
        self.mainSelf:btRegisterButtonClick({
          button = icon,
          key = "BtnItemClick" .. i,
          pressHandler = function()
            self:createDetailCard(icon, v.id)
          end,
          cancelPressHandler = function()
            self:removeDetailCard()
          end,
          force = true
        })
      end
    end
    self.ui.shuiCi_monster_txt:setPositionX(self.ui.shuiCi_monster_txt:getPositionX() - addWid + 4)
  else
    self.ui.shuiCi_6277:setVisible(false)
  end
end

local function PanelDefend(self)
  self.ui.Label_title:setString(T("\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136"))
  local strs = "<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5 >" .. T("\230\140\135\230\140\165\229\174\152\229\164\167\228\186\186\239\188\140\232\175\183\232\174\190\231\189\174\230\130\168\231\154\132\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136\233\152\181\229\174\185\229\147\166\239\188\129") .. "</lable>"
  local thisCon = self.ui.bgRig:getContentSize()
  local label_boss_desc = ed.ui.autoText.new()
  label_boss_desc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 5,
    maxWidth = thisCon.width - 30,
    color = ccc3(255, 252, 231)
  })
  self.ui.bgRig:addChild(label_boss_desc.node)
  label_boss_desc.node:setPosition(15, thisCon.height * 0.55)
  self.ui.layEmeHeros:setVisible(false)
  local thisCon = self.ui.heros_items:getContentSize()
  self.ui.heros_items:setContentSize(CCSizeMake(thisCon.width, thisCon.height + 70))
end

local function PanelFancyTower(self)
  local thisCon = self.ui.tower_txt:getContentSize()
  local tit = {
    T("\229\138\155\228\185\139\232\175\149\231\130\188"),
    T("\230\149\143\228\185\139\232\175\149\231\130\188"),
    T("\230\153\186\228\185\139\232\175\149\231\130\188")
  }
  local titleStr = T("%s.\231\172\172%s\229\177\130", tit[self.objData.towerId] or T("\232\191\183\228\185\139\232\175\149\231\130\188"), self.objData.floorid or 0)
  self.ui.Label_title:setString(titleStr)
  self.ui.Label_title:limitWidthByScale(thisCon.width)
  self.ui.label_mony:setString(self.objData.candle)
  local strs = ""
  for i, v in ipairs(self.objData.taskStr or {}) do
    strs = strs .. " <sprite src=UI/alpha/1080P/common/detail_star.png scale=0.6>" .. v .. "<br/>"
    local strBg = ed.createSprite("UI/alpha/1080P/battle/battle_prepare_bg.png")
    strBg:setAnchorPoint(ccp(0, 0.5))
    strBg:setPosition(ccp(5, thisCon.height - 35 * i + 25))
    self.ui.tower_txt:addChild(strBg)
    local bgSize = strBg:getContentSize()
    local starImg = ed.createSprite("UI/alpha/1080P/common/detail_star.png")
    starImg:setScale(0.6)
    starImg:setAnchorPoint(ccp(0, 0.5))
    starImg:setPosition(ccp(4, bgSize.height * 0.5 + 1))
    strBg:addChild(starImg)
    local desTxt = ed.createttf(v, 14)
    desTxt:setAnchorPoint(ccp(0, 0.5))
    local desTxtPosX = starImg:getPositionX() + starImg:getContentSize().width * starImg:getScale()
    desTxt:setPosition(ccp(desTxtPosX, bgSize.height * 0.5 - 1))
    desTxt:setColor(ccc3(255, 252, 231))
    strBg:addChild(desTxt)
    desTxt:limitWidthByScale(thisCon.width - desTxtPosX)
  end
  if self.objData and self.objData.items then
    local thisCon = self.ui.tower_item_pos:getContentSize()
    local itemWid = 50
    local maxNu = math.floor(thisCon.width / itemWid)
    local addWid = (thisCon.width - maxNu * itemWid) / maxNu
    itemWid = itemWid + addWid
    local posX, posY = itemWid / 2, thisCon.height - itemWid / 2
    for i, v in ipairs(self.objData.items) do
      local icon = ed.createItemIcon(v)
      icon:setPosition(posX + 10, posY)
      if posX + itemWid * 1.5 > thisCon.width then
        posX, posY = itemWid / 2, posY - itemWid + 3
      else
        posX = posX + itemWid
      end
      self.ui.tower_item_pos:addChild(icon)
      icon:setScale(0.55)
      if v.isOne then
        local firstIcon = ed.createSprite("UI/alpha/1080P/skilltower/icon_first.png")
        firstIcon:setPosition(ccp(45, 80))
        firstIcon:setScale(2)
        icon:addChild(firstIcon)
        local labelFirst = ed.createttf(T("\233\166\150\230\172\161"), 11)
        ed.setLabelColor(labelFirst, ed.toccc3(16776919))
        firstIcon:addChild(labelFirst)
        labelFirst:setPosition(ccp(24, 16.5))
      end
      self.mainSelf:btRegisterButtonClick({
        button = icon,
        key = "BtnItemClick" .. i,
        pressHandler = function()
          if ed.resToIconId[string.lower(v.type)] then
            self:createDetailCard(icon, ed.resToIconId[string.lower(v.type)])
          else
            self:createDetailCard(icon, v.id)
          end
        end,
        cancelPressHandler = function()
          self:removeDetailCard()
        end,
        force = true
      })
    end
    self.ui.tower_item_pos:setPositionX(self.ui.tower_item_pos:getPositionX() - addWid - 4)
  else
    self.ui.Label_6277_Copy1:setVisible(false)
  end
end

local function PanelActivityAdventure(self)
  self.mainSelf:initTopHerosIconTeam(1)
  self.ui.Label_title:setString(self.objData.titleName)
  self.ui.label_adventure_cost:setString(self.objData.cost or "")
  ed.setTexture(self.ui.img_money, self.objData.costRes)
  local strs = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5>%s</lable>", self.objData.detail)
  local thisCon = self.ui.adventure_stage_desc:getContentSize()
  local autoTextDesc = ed.ui.autoText.new()
  autoTextDesc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 5,
    maxWidth = thisCon.width,
    color = ccc3(255, 252, 231)
  })
  self.ui.adventure_stage_desc:addChild(autoTextDesc.node)
  autoTextDesc.node:setPositionY(thisCon.height - 10)
  if self.objData and self.objData.items then
    local thisCon = self.ui.adventure_item_pos:getContentSize()
    local itemWid = 50
    local maxNu = math.floor(thisCon.width / itemWid)
    local addWid = (thisCon.width - maxNu * itemWid) / maxNu
    itemWid = itemWid + addWid
    local posX, posY = itemWid / 2, thisCon.height - itemWid / 2
    for i, v in ipairs(self.objData.items) do
      local icon = ed.createItemIcon(v)
      icon:setPosition(posX + 10, posY)
      if posX + itemWid * 1.5 > thisCon.width then
        posX, posY = itemWid / 2, posY - itemWid - 5
      else
        posX = posX + itemWid
      end
      self.ui.adventure_item_pos:addChild(icon)
      icon:setScale(0.55)
      if v.isOne then
        local firstIcon = ed.createSprite("UI/alpha/1080P/skilltower/icon_first.png")
        firstIcon:setPosition(ccp(45, 80))
        firstIcon:setScale(2)
        icon:addChild(firstIcon)
        local labelFirst = ed.createttf(T("\233\166\150\230\172\161"), 11)
        ed.setLabelColor(labelFirst, ed.toccc3(16776919))
        firstIcon:addChild(labelFirst)
        labelFirst:setPosition(ccp(24, 16.5))
      end
      self.mainSelf:btRegisterButtonClick({
        button = icon,
        key = "BtnItemClick" .. i,
        clickHandler = function()
          ed.ui.packageDetailWin.create({
            id = v.id,
            type = v.type
          }):popWindow()
        end,
        force = true
      })
    end
    self.ui.adventure_item_pos:setPositionX(self.ui.adventure_item_pos:getPositionX() - addWid - 4)
  else
    self.ui.Label_adventure_item:setVisible(false)
  end
end

local function PanelFancyAbyss(self)
  local towerData = ed.SkillTowerManager.exTowerData
  self.mainSelf:initTopHerosIconTeam(1)
  local desc = ed.getDataTable("FancyAbyssStage")[self.objData.stageid]["Stage Describe"]
  local strs = T("<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5>%s</lable>", desc)
  local thisCon = self.ui.fancyabyss_stage_desc:getContentSize()
  local dlDesc = ed.UITool.createDraglist(self.ui.fancyabyss_stage_desc, {})
  local autoTextDesc = ed.ui.autoText.new()
  autoTextDesc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 2,
    maxWidth = thisCon.width,
    color = ccc3(255, 252, 231)
  })
  dlDesc:addItem(autoTextDesc.node)
  autoTextDesc.node:setPositionY(thisCon.height - 10)
  local _, dlHei = autoTextDesc:getCurContentSize()
  dlDesc:initListHeight(dlHei + 5)
  self.ui.Label_title:setString(string.format(T("\229\185\187\229\162\131\230\183\177\230\184\138-\231\172\172%d\229\177\130"), self.objData.floorid))
  self.ui.Label_title:limitWidthByScale(thisCon.width)
  local buffId = ed.getDataTable("FancyAbyssBattle")[self.objData.stageid][1]["Stage Skill ID"]
  local fixHeight = -10
  local buffContainer
  if buffId and buffId ~= 0 then
    local hei = self.ui.bg_buff:getPositionY() - 120
    buffContainer = CCLayer:create()
    self.ui.Panel_FancyAbyss:addChild(buffContainer)
    buffContainer:setPosition(ccp(self.ui.fancyabyss_item_pos:getPositionX(), 110))
    buffContainer:setContentSize(CCSizeMake(thisCon.width, hei))
    local buffDList = ed.UITool.createDraglist(buffContainer, {})
    local skillId = ed.getDataTable("StageSkill")[buffId]["Skill 1 ID"]
    local skillDesc = ed.getDataTable("Skill")[skillId][0]["Full Description"]
    self.ui.bg_buff:setVisible(true)
    local name = ed.getDataTable("FancyAbyssSeason")[ed.SkillTowerManager.curAbyssSeason]["Skill Name"] or T("\230\183\177\230\184\138BUFF")
    local buffName = ed.ui.autoText.new()
    buffName:initParam({
      context = string.format("<sprite src=UI/alpha/1080P/skilltower/abyss/abyss_battle_icon.png scale=0.8>" .. T("<lable color=ccc3(255,228,150) strokeColor=strokeColor1 strokeSize=1>\230\156\172\230\156\159\229\138\160\230\136\144:%s</lable>"), name),
      fontSize = 15,
      color = ccc3(255, 252, 231)
    })
    buffName:limitWidthByScale(180)
    buffName.node:setPosition(ccp(5, 15))
    self.ui.bg_buff:addChild(buffName.node)
    local width, height = buffName:getCurContentSize()
    local buffDesc = ed.ui.autoText.new()
    buffDesc:initParam({
      context = skillDesc,
      fontSize = 14,
      maxWidth = thisCon.width,
      color = ccc3(255, 252, 231),
      strokeColor = ccc3(27, 25, 24),
      strokeSize = 1
    })
    buffDesc.node:setPosition(ccp(0, hei - 10))
    width, height = buffDesc:getCurContentSize()
    buffDList:addItem(buffDesc.node)
    buffDList:initListHeight(height + 10)
  end
  if self.objData.passTime and 0 < self.objData.passTime then
    self.ui.Label_fancyabyss_item:setVisible(false)
    self.ui.img_time:setVisible(true)
    ed.setLabelStroke(self.ui.label_fancyabyss_time, ed.toccc3(0), 1)
    ed.setString(self.ui.label_fancyabyss_time, ed.getmsNString(self.objData.passTime))
    self.ui.label_fancyabyss_time:setPositionX(math.max(self.ui.label_fancyabyss_time:getPositionX(), self.ui.Label_4565:getPositionX() + self.ui.Label_4565:getContentSize().width + self.ui.label_fancyabyss_time:getContentSize().width * 0.5 + 2))
    if buffContainer then
      self.ui.img_time:setPositionY(95)
    else
      ed.UITool.setPositionBy(self.ui.img_time, ccp(0, -fixHeight))
    end
  else
    self.ui.img_time:setVisible(false)
    if self.objData and self.objData.firstRewards then
      local thisCon = self.ui.fancyabyss_item_pos:getContentSize()
      local itemWid = 40
      local maxNu = math.floor(thisCon.width / itemWid)
      local addWid = (thisCon.width - maxNu * itemWid) / maxNu
      itemWid = itemWid + addWid
      local posX, posY = itemWid / 2, thisCon.height - itemWid / 2 + 5
      for i, v in ipairs(self.objData.firstRewards) do
        local icon = ed.createItemIcon(v)
        icon:setPosition(posX + 10, posY)
        if posX + itemWid * 1.5 > thisCon.width then
          posX, posY = itemWid / 2, posY - itemWid - 5
        else
          posX = posX + itemWid
        end
        self.ui.fancyabyss_item_pos:addChild(icon)
        icon:setScale(0.55)
        self.mainSelf:btRegisterButtonClick({
          button = icon,
          key = "BtnItemClick" .. i,
          clickHandler = function()
            ed.ui.packageDetailWin.create({
              id = v.id,
              type = v.type
            }):popWindow()
          end,
          force = true
        })
      end
      self.ui.fancyabyss_item_pos:setPositionX(self.ui.fancyabyss_item_pos:getPositionX() - addWid - 4)
    else
      self.ui.Label_fancyabyss_item:setVisible(false)
    end
    if buffContainer then
      self.ui.Label_fancyabyss_item:setPositionY(95)
      local tempHei = self.ui.fancyabyss_item_pos:getContentSize().height
      self.ui.fancyabyss_item_pos:setPositionY(80 - tempHei)
    else
      ed.UITool.setPositionBy(self.ui.fancyabyss_item_pos, ccp(0, -fixHeight))
      ed.UITool.setPositionBy(self.ui.Label_fancyabyss_item, ccp(0, -fixHeight))
    end
  end
  local autoText = ed.ui.autoText.new()
  local colorStr = towerData.curEnterTime == 0 and "ccc3(238,86,66)" or "ccc3(255,252,231)"
  local str = string.format(T("<lable color=ccc3(255,252,231) strokeColor=ccc3(0,0,0) strokeSize=1>\228\187\138\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176</lable>") .. T("<lable color=%s  strokeColor=ccc3(0,0,0) strokeSize=1>%d</lable>") .. T("<lable color=ccc3(255,252,231) strokeColor=ccc3(0,0,0) strokeSize=1>/%d</lable>"), colorStr, towerData.curEnterTime, towerData.maxEnterTime)
  autoText:initParam({context = str, fontSize = 15})
  local width, height = autoText:getCurContentSize()
  autoText.node:setPosition(ccp(103 - width / 2, 20))
  self.ui.Panel_FancyAbyss:addChild(autoText.node)
end

local function PanelBattGuild(self)
  self.mainSelf:initTopHerosIconTeam("battGuild")
  self.ui.Label_title:setString(self.objData.titleName or T("\229\155\162\230\156\172\228\184\138\233\152\181"))
  local detail = self.objData.detail or ""
  local strs = string.format("<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5 >%s</lable><br/><br/>", detail) .. T("<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5 >\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176:</lable>") .. T("<lable color=ccc3(255,233,143) strokeColor=strokeColor1 strokeSize=1>%d/%d</lable>", self.objData.curBattleTimes, self.objData.maxBattleTimes)
  local thisCon = self.ui.bgRig:getContentSize()
  self.ui.Label_title:limitWidthByScale(thisCon.width - 30)
  local label_boss_desc = ed.ui.autoText.new()
  label_boss_desc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 5,
    maxWidth = thisCon.width - 30,
    color = ccc3(255, 252, 231)
  })
  self.ui.bgRig:addChild(label_boss_desc.node)
  label_boss_desc.node:setPosition(15, thisCon.height * 0.84)
end

local function PanelAwakeStage(self)
  self.mainSelf:initTopHerosIconTeam(1)
  self.ui.Label_title:setString(self.objData.titleName or "")
  ed.setLabelStroke(self.ui.Label_title, ed.toccc3(0), 1)
  local desPanelSize = self.ui.as_des:getContentSize()
  local posY = self.ui.as_des:getPositionY() + desPanelSize.height
  if self.objData and self.objData.type == "Special" then
    local effectTitle = ed.createttf(T("\229\156\186\229\156\176\230\149\136\230\158\156\239\188\154"), 15)
    effectTitle:setColor(ccc3(255, 252, 231))
    ed.setLabelStroke(effectTitle, ed.toccc3(0), 1)
    self.ui.as_des:getParent():addChild(effectTitle)
    effectTitle:setAnchorPoint(ccp(0, 0.5))
    local titleSize = effectTitle:getContentSize()
    effectTitle:setPosition(self.ui.as_energy_title:getPositionX(), posY - titleSize.height * 0.5)
    posY = posY - titleSize.height
    posY = posY - 10
  end
  posY = posY - desPanelSize.height
  self.ui.as_des:setPositionY(posY)
  local strs = "<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5 >" .. self.objData.detail .. "</lable>"
  local desLabel = ed.ui.autoText.new()
  desLabel:initParam({
    context = strs,
    fontSize = 15,
    lineSpacing = 5,
    maxWidth = desPanelSize.width,
    color = ccc3(255, 252, 231),
    strokeColor = ed.toccc3(0),
    strokeSize = 1
  })
  self.ui.as_des:addChild(desLabel.node)
  desLabel.node:setPositionY(desPanelSize.height - desLabel:getFirstLineHeight() * 0.5)
  local _, desHeight = desLabel:getCurContentSize()
  posY = posY - math.max(0, desHeight - desPanelSize.height)
  local nodeSize
  if self.objData and self.objData.cost then
    ed.setLabelString(self.ui.as_power_number, self.objData.cost)
    ed.adaptLabel(self.ui.as_energy_title, {maxWidth = 85, minScale = 0.7})
    self.ui.as_energy_title:setHorizontalAlignment(kCCTextAlignmentCenter)
    posY = posY - 15
    nodeSize = self.ui.as_energy_title:getContentSize()
    self.ui.as_energy_title:setPositionY(posY - nodeSize.height * 0.5)
    self.ui.as_power_number:setPositionX(self.ui.as_energy_title:getPositionX() + nodeSize.width + 11)
    self.ui.as_power_icon:setPositionX(self.ui.as_power_number:getPositionX() + self.ui.as_power_number:getContentSize().width + 14)
    self.ui.as_power_number:setPositionY(self.ui.as_energy_title:getPositionY())
    self.ui.as_power_icon:setPositionY(self.ui.as_energy_title:getPositionY())
    posY = posY - nodeSize.height
    self.ui.as_energy_title:setVisible(true)
    self.ui.as_power_number:setVisible(true)
    self.ui.as_power_icon:setVisible(true)
  else
    self.ui.as_energy_title:setVisible(false)
    self.ui.as_power_number:setVisible(false)
    self.ui.as_power_icon:setVisible(false)
  end
  if self.objData and self.objData.items then
    posY = posY - 15
    nodeSize = self.ui.as_reward_title:getContentSize()
    self.ui.as_reward_title:setPositionY(posY - nodeSize.height * 0.5)
    posY = posY - nodeSize.height
    posY = posY - 2
    nodeSize = self.ui.as_reward_panel:getContentSize()
    self.ui.as_reward_panel:setPositionY(posY - nodeSize.height)
    local rewardPanelSize = self.ui.as_reward_panel:getContentSize()
    local startX, startY = -2, rewardPanelSize.height
    local spaceX, spaceY = 0, 0
    local scale = 0.55
    local addSpaceY = 0
    local itemWidth, itemHeight = 0, 0
    for i, v in ipairs(self.objData.items) do
      startY = startY - addSpaceY
      addSpaceY = 0
      local rewardIcon = ed.createItemIcon(v)
      self.ui.as_reward_panel:addChild(rewardIcon)
      rewardIcon:setScale(scale)
      local iconSize = rewardIcon:getContentSize()
      iconSize.width = iconSize.width * scale
      iconSize.height = iconSize.height * scale
      self.mainSelf:btRegisterButtonClick({
        button = rewardIcon,
        key = "BtnItemClick" .. i,
        pressHandler = function()
          ed.UITool.openView("packageDetail", v)
        end,
        force = true
      })
      rewardIcon:setPosition(startX + iconSize.width * 0.5, startY - iconSize.height * 0.5)
      if 0 == itemWidth then
        itemWidth = iconSize.width
        itemHeight = iconSize.height
      end
      startX = startX + itemWidth
      startX = startX + spaceX
      if startX + itemWidth * 1.1 > rewardPanelSize.width then
        startX, startY = 0, startY - itemHeight
        addSpaceY = spaceY
      end
    end
    posY = posY - (rewardPanelSize.height - startY + itemHeight)
    self.ui.as_reward_title:setVisible(true)
    self.ui.as_reward_panel:setVisible(true)
  else
    self.ui.as_reward_title:setVisible(false)
    self.ui.as_reward_panel:setVisible(false)
  end
  if self.objData and self.objData.efficiencys then
    posY = posY - 15
    nodeSize = self.ui.as_efficiency_title:getContentSize()
    self.ui.as_efficiency_title:setPositionY(posY - nodeSize.height * 0.5)
    ed.setLabelStroke(addLabel, ed.toccc3(0), 1)
    posY = posY - nodeSize.height
    posY = posY - 2
    nodeSize = self.ui.as_efficiency_panel:getContentSize()
    self.ui.as_efficiency_panel:setPositionY(posY - nodeSize.height)
    local startX, startY = -2, nodeSize.height
    local spaceX, spaceY = 2, 0
    local scale = 0.55
    local addSpaceY = 0
    local itemWidth, itemHeight = 0, 0
    for i, v in ipairs(self.objData.efficiencys) do
      startY = startY - addSpaceY
      addSpaceY = 0
      local rewardIcon = ed.createItemIcon({
        type = v.type,
        id = v.id
      })
      self.ui.as_efficiency_panel:addChild(rewardIcon)
      rewardIcon:setScale(scale)
      local iconSize = rewardIcon:getContentSize()
      iconSize.width = iconSize.width * scale
      iconSize.height = iconSize.height * scale
      rewardIcon:setPosition(startX + iconSize.width * 0.5, startY - iconSize.height * 0.5)
      startX = startX + iconSize.width
      self.mainSelf:btRegisterButtonClick({
        button = rewardIcon,
        key = "EfficiencyItemClick" .. i,
        pressHandler = function()
          ed.UITool.openView("packageDetail", v)
        end,
        force = true
      })
      local addLabel = ed.createttf(T("+%d/\230\172\161", v.add), 15)
      self.ui.as_efficiency_panel:addChild(addLabel)
      addLabel:setAnchorPoint(ccp(0, 0))
      addLabel:setColor(ccc3(107, 255, 49))
      ed.setLabelStroke(addLabel, ed.toccc3(0), 1)
      addLabel:setPosition(startX, startY - iconSize.height * 0.5 - 10)
      local labelSize = addLabel:getContentSize()
      startX = startX + labelSize.width
      startX = startX + spaceX
      if 0 == itemWidth then
        itemWidth = iconSize.width + labelSize.width
        itemHeight = iconSize.height
      end
      if startX + itemWidth > nodeSize.width then
        startX, startY = 0, startY - itemHeight
        addSpaceY = spaceY
      end
    end
    posY = posY - (nodeSize.height - startY + itemHeight)
    self.ui.as_efficiency_title:setVisible(true)
    self.ui.as_efficiency_panel:setVisible(true)
  else
    self.ui.as_efficiency_title:setVisible(false)
    self.ui.as_efficiency_panel:setVisible(false)
  end
  if self.objData and self.objData.conditions then
    self.ui.as_condition_panel:removeAllChildrenWithCleanup(true)
    local conditionPanelSize = self.ui.as_condition_panel:getContentSize()
    local itemSpace = 6
    local conditionPosY = conditionPanelSize.height
    for i, v in ipairs(self.objData.conditions) do
      local bgImg = ed.createScale9Sprite("UI/alpha/1080P/dungeon/stageinfo/list_bg.png", CCRectMake(10, 5, 240, 10))
      bgImg:setAnchorPoint(ccp(0.5, 0))
      self.ui.as_condition_panel:addChild(bgImg)
      local posX = 5
      local iconImg = ed.createSprite("UI/alpha/1080P/dungeon/stageinfo/list_icon.png")
      iconImg:setAnchorPoint(ccp(0, 0.5))
      bgImg:addChild(iconImg)
      iconImg:setPosition(posX, 0)
      posX = posX + iconImg:getContentSize().width + 5
      local desLabel = ed.ui.autoText.new()
      desLabel:initParam({
        context = v.str,
        fontSize = 14,
        color = ed.toccc3(16776423),
        lineSpacing = 4,
        maxWidth = conditionPanelSize.width - posX + 5,
        isTripLastSpacing = true
      })
      bgImg:addChild(desLabel.node)
      local desWidth, desHeight = desLabel:getCurContentSize()
      local bgSize = CCSizeMake(conditionPanelSize.width + 10, math.max(22, desHeight + 5))
      bgImg:setContentSize(bgSize)
      local desPosY = bgSize.height * 0.5 + desHeight * 0.5 - desLabel:getFirstLineHeight() * 0.5
      desLabel.node:setPosition(posX, desPosY)
      iconImg:setPositionY(desPosY)
      conditionPosY = conditionPosY - bgSize.height
      bgImg:setPosition(bgSize.width * 0.5 - 10, conditionPosY)
      conditionPosY = conditionPosY - itemSpace
    end
    self.ui.as_condition_title:setVisible(true)
    self.ui.as_condition_panel:setVisible(true)
  else
    self.ui.as_condition_title:setVisible(false)
    self.ui.as_condition_panel:setVisible(false)
  end
  local chapterId = self.objData.chapterId
  local dungeonMgr = ed.awakeDungeonMgr.getInstance()
  local buffInfo = dungeonMgr:getBuffInfoByChapterId(chapterId)
  if buffInfo then
    ed.setLabelString(self.ui.as_buff, ed.awakeDungeonDefine.getBuffDes(buffInfo.shortDesc))
    self.mainSelf:btRegisterButtonClick({
      button = self.ui.as_buff_bg,
      key = "as_buff_bg",
      pressScale = 0.95,
      clickHandler = function()
        if not chapterId then
          return
        end
        local win = ed.ui.awakeDungeonBuffDetailWin.create({chapterId = chapterId})
        win:popWindow()
        ed.layout.relateLayout(self.ui.as_buff_bg, win.ui.image_bg, {top = 180})
        ed.layout.layoutWithMagin(win.ui.image_bg, {
          right = ed.display.getNotchHeight()
        })
      end,
      force = true
    })
    self.ui.as_buff_bg:setVisible(true)
  else
    self.ui.as_buff_bg:setVisible(false)
  end
end

local function localCreatettf(param)
  local label = ed.createttf(param.txt or 0, param.size or 17)
  label:setPosition(param.pos or ccp(0, 0))
  label:setColor(param.color or ccc3(243, 220, 181))
  label:setAnchorPoint(param.anchor or ccp(0.5, 0.5))
  param.parent:addChild(label)
  if param.stroke then
    ed.setLabelStroke(label, param.stroke.color, param.stroke.size or 1)
  end
  return label
end

local function PanelAwakeStageBoss(self)
  self.mainSelf:initTopHerosIconTeam(1)
  local layer = self.AwakeStageBossLayer
  local data = self.objData
  self.ui.Label_title:setString(data.titleName)
  local size = layer:getContentSize()
  self.ui.Label_title:limitWidthByScale(size.width * 0.9)
  local puppet, cha = ed.readhero.getActor(data.bossHeroId, "Idle", true, false)
  local row = ed.getDataTable("Puppet")[cha]
  local scale = row and row.Scale or 1
  self.mainSelf:addFca(puppet)
  puppet:setScale(scale)
  puppet:update(0)
  layer:addChild(puppet)
  puppet:setPosition(size.width / 2, size.height - 150)
  local tmp_label = localCreatettf({
    txt = T("\229\142\134\229\143\178\230\156\128\233\171\152\230\140\145\230\136\152\229\165\150\229\138\177\239\188\154"),
    size = 16,
    pos = ccp(size.width / 2 - 90, size.height - 180),
    anchor = ccp(0, 0.5),
    color = ccc3(ed.colorToStr("#fff5a4")),
    parent = layer,
    stroke = {
      color = ccc3(ed.colorToStr("#181513")),
      size = 1
    }
  })
  tmp_label:limitWidthByScale(size.width * 0.65)
  localCreatettf({
    txt = data.maxProgress,
    size = 19,
    pos = ccp(size.width / 2 + 48, size.height - 180),
    anchor = ccp(0, 0.5),
    color = ccc3(ed.colorToStr("#57ec50")),
    parent = layer,
    stroke = {
      color = ccc3(ed.colorToStr("#181513")),
      size = 1
    }
  }):setFontName(ed.fontBold)
  local subPosY = 80
  if self.objData.items.next and 0 < #self.objData.items.next then
    subPosY = 0
    tmp_label = localCreatettf({
      txt = T("\228\184\139\228\184\128\230\140\145\230\136\152\232\191\155\229\186\166\229\165\150\229\138\177\239\188\154"),
      size = 16,
      pos = ccp(size.width / 2 - 90, size.height - 210),
      anchor = ccp(0, 0.5),
      color = ccc3(ed.colorToStr("#fffce7")),
      parent = layer,
      stroke = {
        color = ccc3(ed.colorToStr("#181513")),
        size = 1
      }
    })
    tmp_label:limitWidthByScale(size.width * 0.65)
    localCreatettf({
      txt = data.nextProgress,
      size = 19,
      pos = ccp(size.width / 2 + 48, size.height - 210),
      anchor = ccp(0, 0.5),
      color = ccc3(ed.colorToStr("#eb9830")),
      parent = layer,
      stroke = {
        color = ccc3(ed.colorToStr("#181513")),
        size = 1
      }
    }):setFontName(ed.fontBold)
    for i, v in ipairs(self.objData.items.next) do
      local icon = ed.createItemIcon(v)
      icon:setPosition(i * 48 - 10, size.height - 248)
      layer:addChild(icon)
      icon:setScale(0.55)
      self.mainSelf:btRegisterButtonClick({
        button = icon,
        key = "BtnItemClick" .. i,
        pressHandler = function()
          ed.UITool.openView("packageDetail", v)
        end,
        force = true
      })
    end
  end
  local reward_label = localCreatettf({
    txt = T("\229\141\149\230\172\161\229\165\150\229\138\177\239\188\154"),
    size = 16,
    pos = ccp(size.width / 2 - 90, size.height - 290 + subPosY),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = layer,
    anchor = ccp(0, 0.5),
    stroke = {
      color = ccc3(ed.colorToStr("#181513")),
      size = 1
    }
  })
  reward_label:limitWidthByScale(100)
  for i, v in ipairs(self.objData.items.once) do
    local icon = ed.createItemIcon(v)
    icon:setPosition(i * 48 - 10, size.height - 327 + subPosY)
    layer:addChild(icon)
    icon:setScale(0.55)
    self.mainSelf:btRegisterButtonClick({
      button = icon,
      key = "BtnOnceItemClick" .. i,
      pressHandler = function()
        ed.UITool.openView("packageDetail", v)
      end,
      force = true
    })
  end
  if self.objData.shortDesc then
    local buffBg = ed.createSprite("UI/alpha/1080P/dungeon/stageinfo/buff_icon_bg.png")
    layer:addChild(buffBg)
    buffBg:setScale(0.7)
    local buffIcon = ed.createSprite("UI/alpha/1080P/dungeon/stageinfo/buff_icon.png")
    buffBg:addChild(buffIcon)
    buffIcon:setPosition(9.75, 11.5)
    local label = ed.createttf(ed.awakeDungeonDefine.getBuffDes(self.objData.shortDesc), 13)
    ed.setLabelColor(label, ed.toccc3(16760594))
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(ccp(36.75, 12.5))
    buffBg:addChild(label)
    buffBg:setPosition(ccp(size.width / 2 + 10, 108))
    self.mainSelf:btRegisterButtonClick({
      button = buffBg,
      key = "buffBg",
      normalScale = 0.7,
      pressScale = 0.66,
      clickHandler = function()
        local chapterId = self.objData.chapterId
        if not chapterId then
          return
        end
        local win = ed.ui.awakeDungeonBuffDetailWin.create({chapterId = chapterId})
        win:popWindow()
        ed.layout.relateLayout(buffBg, win.ui.image_bg, {top = 180})
        ed.layout.layoutWithMagin(win.ui.image_bg, {
          right = ed.display.getNotchHeight()
        })
      end,
      force = true
    })
  end
  localCreatettf({
    txt = T("\230\182\136\232\128\151\239\188\154"),
    size = 16,
    pos = ccp(size.width / 2 - 30, 85),
    color = ccc3(ed.colorToStr("#fffce7")),
    parent = layer,
    stroke = {
      color = ccc3(ed.colorToStr("#181513")),
      size = 1
    }
  })
  localCreatettf({
    txt = data.cost,
    size = 16,
    pos = ccp(size.width / 2 + 10, 85),
    color = ccc3(ed.colorToStr("#fff5a4")),
    parent = layer,
    stroke = {
      color = ccc3(ed.colorToStr("#181513")),
      size = 1
    }
  })
  local icon = ed.createSprite("UI/alpha/1080P/icon/dungeon_energy.png")
  icon:setPosition(size.width / 2 + 40, 85)
  layer:addChild(icon)
end

local function PanelHadesHeat(self)
  self.mainSelf:initTopHerosIconTeam(1)
  local data = self.objData
  self.ui.Label_title:setString(data.bossName)
  self.ui.hades_boss_pos:setContentSize(CCSizeMake(205, 100))
  self.ui.hades_boss_pos:setPosition(ccp(0, 253))
  local bossIdList = data.bossIdList or {}
  local stageId = data.stageId
  local bossCfg = ed.getDataTable("HeatBoss")[stageId]
  local len = #bossIdList
  for index = 1, len do
    local bossId = bossIdList[index]
    local puppet, cha = ed.readhero.getActor(bossId, "Idle", true, false)
    self.mainSelf:addFca(puppet)
    puppet:update(0)
    puppet:setScale(bossCfg.UISize * 0.6)
    self.ui.hades_boss_pos:addChild(puppet)
    puppet:setPositionX(self.ui.hades_boss_pos:getContentSize().width * (len + 1 - index) / (len + 1))
  end
  ed.setLabelString(self.ui.hades_heat_boss_desc, data.bossDesc or "")
  ed.setLabelStroke(self.ui.hades_heat_boss_desc, ed.toccc3(1578259), 1)
  ed.setLabelDimensions(self.ui.hades_heat_boss_desc, CCSizeMake(200, 0))
  ed.setLabelStroke(self.ui.label_firework, ed.toccc3(1578259), 1)
  self.ui.label_firework:setVisible(false)
  ed.setLabelStroke(self.ui.label_total_heat, ed.toccc3(14116371), 1)
  ed.setLabelString(self.ui.label_total_heat, data.totalHeat)
  self.ui.label_total_heat:setFontName(ed.fontBold)
  local groupIdToIconCfg = {
    [1] = {
      iconPath = "UI/alpha/1080P/hades/hades_hot.png"
    },
    [2] = {
      iconPath = "UI/alpha/1080P/nianmonster/nian_main_boss_heat.png",
      scale = 0.72,
      offset = ccp(0, 7)
    }
  }
  local config = groupIdToIconCfg[self.objData.groupId] or groupIdToIconCfg[1]
  ed.setTexture(self.ui.image_heat_icon, config.iconPath, true)
  self.ui.image_heat_icon:setScale(config.scale or 1)
  local offset = config.offset or ccp(0, 0)
  ed.UITool.setPositionBy(self.ui.image_heat_icon, offset)
  self:refreshFireworkSelect()
  ed.UITool.registerBtn(self.mainSelf, "hades_heat_btn_detail", function()
    local allHeatWin = ed.ui.hadesAllHeatWin.create({
      chooseHeat = self.objData.chooseHeat,
      groupId = self.objData.groupId
    })
    allHeatWin:popWindow()
    ed.layout.relateLayout(self.ui.hades_heat_bg, allHeatWin.ui.image_bg, {top = 35})
    ed.layout.layoutWithMagin(allHeatWin.ui.image_bg, {
      right = ed.display.getNotchHeight()
    })
  end, {pressScale = 0.85, normalScale = 0.9})
  self.mainSelf:listenEvent("nianMonsterSelectItem", function()
    self:refreshFireworkSelect()
  end)
end

function class:refreshFireworkSelect()
  if not self.mainSelf:canShowFirework() then
    self.ui.label_firework:setVisible(false)
    self.ui.panel_firework:setVisible(false)
    return
  end
  local itemId = ed.nianMonsterMgr.getInstance():getSelectItem()
  self.ui.panel_firework:removeAllChildrenWithCleanup(true)
  if itemId then
    local amount = ed.player:getEquipAmount(itemId)
    local itemIcon = ed.readequip.createIconWithAmount(itemId, nil, amount)
    itemIcon:setScale(0.7)
    self.ui.panel_firework:addChild(itemIcon)
    ed.layout.centerInParent(itemIcon)
  else
    local itemIcon = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
    local frame = ed.createSprite("UI/alpha/1080P/common/frame/equip_frame_white.png")
    local add = ed.createSprite("UI/alpha/1080P/common/add_big.png")
    itemIcon:addChild(frame)
    itemIcon:addChild(add)
    local action1 = CCFadeTo:create(1, 100)
    local action2 = CCFadeTo:create(1, 255)
    local breathAction = CCRepeatForever:create(CCSequence:create(ccArrayMake(action1, action2)))
    add:runAction(breathAction)
    ed.layout.centerInParent(frame)
    ed.layout.centerInParent(add)
    itemIcon:setScale(0.7)
    self.ui.panel_firework:addChild(itemIcon)
    ed.layout.centerInParent(itemIcon)
  end
  self.mainSelf:btRegisterButtonClick({
    button = self.ui.panel_firework,
    key = "firework",
    clickHandler = function()
      self.mainSelf:doChangeTag("firework")
    end,
    force = true
  })
end

local lineIconCfg = {
  [1] = {
    titleBg = "UI/alpha/1080P/guild/guild_clash_deploy/formation_nature_titlefloor.png",
    defendTower = "effect/eff_UI_GVG_nature_tower/eff_UI_GVG_nature_tower",
    [1] = {
      path = "UI/alpha/1080P/guild/guild_clash_deploy/tab_toproad_selected.png",
      title = T("\228\184\138\232\183\175\229\184\131\233\152\178"),
      scale = 0.8
    },
    [2] = {
      path = "UI/alpha/1080P/guild/guild_clash_deploy/tab_midroad_selected.png",
      title = T("\228\184\173\232\183\175\229\184\131\233\152\178"),
      scale = 0.8
    },
    [3] = {
      path = "UI/alpha/1080P/guild/guild_clash_deploy/tab_botroad_selected.png",
      title = T("\228\184\139\232\183\175\229\184\131\233\152\178"),
      scale = 0.8
    }
  },
  [2] = {
    titleBg = "UI/alpha/1080P/guild/guild_clash_deploy/formation_dark_titlefloor.png",
    defendTower = "effect/eff_UI_GVG_dark_tower/eff_UI_GVG_dark_tower",
    [1] = {
      path = "UI/alpha/1080P/guild/guild_clash_deploy/operate_toproad.png",
      title = T("\228\184\138\232\183\175\229\184\131\233\152\178")
    },
    [2] = {
      path = "UI/alpha/1080P/guild/guild_clash_deploy/operate_midroad.png",
      title = T("\228\184\173\232\183\175\229\184\131\233\152\178")
    },
    [3] = {
      path = "UI/alpha/1080P/guild/guild_clash_deploy/operate_botroad.png",
      title = T("\228\184\139\232\183\175\229\184\131\233\152\178")
    }
  }
}

local function PanelGuildClash(self)
  self.ui.layEmeHeros:setVisible(false)
  local oldSize = self.ui.heros_items:getContentSize()
  self.ui.heros_items:setContentSize(CCSizeMake(oldSize.width, oldSize.height + self.ui.layEmeHeros:getContentSize().height))
  local objData = self.objData
  local camp = objData.camp or 1
  local lineId = objData.lineId or 1
  local guildTeamAmount = objData.guildTeamAmount
  local myTeamAmount = objData.myTeamAmount
  local campCfg = lineIconCfg[camp]
  local lineCfg = campCfg[lineId]
  ed.setTexture(self.ui.guildClash_line, lineCfg.path, true)
  ed.setLabelColor(self.ui.guildClash_title, ed.toccc3(16776423))
  ed.setLabelString(self.ui.guildClash_title, lineCfg.title or "")
  ed.setLabelStroke(self.ui.guildClash_title, ed.toccc3(0), 1)
  local iconScale = lineCfg.scale or 1
  local adaptScale = math.min(1, 180 / (self.ui.guildClash_line:getContentSize().width * iconScale + self.ui.guildClash_title:getContentSize().width))
  self.ui.guildClash_line:setScale(adaptScale * iconScale)
  self.ui.guildClash_title:setScale(adaptScale)
  ed.layout.horizontalSortNode({
    self.ui.guildClash_line,
    self.ui.guildClash_title
  }, {2.5, 0}, self.ui.guildClash_title_bg:getContentSize().width * 0.5)
  ed.setTexture(self.ui.guildClash_title_bg, campCfg.titleBg)
  ed.setLabelString(self.ui.guildClash_guild_team_amount, guildTeamAmount or 0)
  ed.setLabelStroke(self.ui.guildClash_guild_team_amount, ed.toccc3(2565412), 1)
  ed.setLabelString(self.ui.guildClash_my_team_amount, myTeamAmount or 0)
  ed.setLabelStroke(self.ui.guildClash_my_team_amount, ed.toccc3(2565412), 1)
  local tower = ed.createSpine(campCfg.defendTower, 0.5)
  tower:setAnimation(0, "Idle", true)
  self.ui.guildClash_boss_pos:addChild(tower)
  ed.layout.centerInParent(tower)
end

local function PanelGuildMount(self)
  self.mainSelf:initTopHerosIconTeam(1)
  local strs = "<lable color=ccc3(255,252,231) strokeColor=ccc3(39,37,36) strokeSize=1.5 >" .. self.objData.monsSkil.skli .. "</lable>"
  local thisCon = self.ui.boss_desc:getContentSize()
  local label_boss_desc = ed.ui.autoText.new()
  label_boss_desc:initParam({
    context = strs,
    fontSize = 16,
    lineSpacing = 5,
    maxWidth = thisCon.width,
    color = ccc3(255, 252, 231)
  })
  self.ui.boss_desc:addChild(label_boss_desc.node)
  label_boss_desc.node:setPositionY(thisCon.height - 10)
  ed.setLabelStroke(self.ui.Buff_title, ed.toccc3(2565412), 1)
  self.ui.Label_title:setString(self.objData.modTxt.name)
  local draglist = ed.UITool.createDraglist(self.ui.buff_desc, {})
  local buffName = self.objData.monsBuff.name
  if buffName then
    buffName = buffName .. "\239\188\154"
  else
    buffName = ""
  end
  local buffDesc = self.objData.monsBuff.desc or T("\230\151\160")
  strs = "<lable color=ccc3(254,211,109)>" .. buffName .. "</lable>" .. buffDesc
  thisCon = self.ui.buff_desc:getContentSize()
  local label_buff_desc = ed.ui.autoText.new()
  label_buff_desc:initParam({
    context = strs,
    fontSize = 15,
    maxWidth = thisCon.width,
    color = ccc3(255, 252, 231),
    strokeSize = 1,
    strokeColor = ccc3(20, 16, 42)
  })
  local atWid, atHei = label_buff_desc:getContentSize()
  local dlSize = self.ui.buff_desc:getContentSize()
  label_buff_desc.node:setPosition(ccp(0, dlSize.height - 10))
  draglist:addItem(label_buff_desc.node)
  draglist:initListHeight(atHei)
  local layer = self.ui.boss_modPos
  local bossActor = ed.readhero.getActorNew(self.objData.bossTblData["Unit ID"])
  bossActor:setScale(self.objData.bossTblData["Body Size"] - 0.4)
  self.mainSelf:addFca(bossActor)
  EDLoadShader("HSVtoRGBShaderV2")
  ed.useHSVShaderV2(bossActor, self.objData.bossTblData.Hue, self.objData.bossTblData.Saturation, self.objData.bossTblData.Value)
  layer:addChild(bossActor, 10)
  local bossEffect = ed.createFcaNode("eff_UI_GuildMount_boss")
  bossEffect:setScale(1 / self.objData.bossTblData["Body Size"])
  self.mainSelf:addFca(bossEffect)
  bossActor:addChild(bossEffect)
  local posx, posy = self.ui.go:getPosition()
  local extraInfo = ed.GuildMountManager:getExtraTime()
  if extraInfo then
    local time = extraInfo and (extraInfo._duration or 0) or 0
    ed.createLabelTools({
      txt = string.format(T("\230\136\152\230\150\151\232\161\165\230\151\182\239\188\154%d\231\167\146"), time),
      size = 15,
      pos = ccp(posx, posy + 40),
      color = ccc3(ed.colorToStr("#b1b0c0")),
      parent = self.ui.go:getParent()
    })
  end
end

class.pageFunSet = {
  Panel_dreamland = {init = PanelYsmjFun, update = PanelYsmjFunUpData},
  Panel_crusade = {init = PanelCrusadeFun, update = nil},
  Panel_stageDetail = {init = PanelMonsterFun, update = nil},
  Panel_attack = {init = PanelAttackFun, update = nil},
  Panel_share_fight = {init = PanelShareFightFun, update = nil},
  Panel_exerciseStageDetail = {init = PanelExerciseStageFun, update = nil},
  Panel_defend = {init = PanelDefend, update = nil},
  Panel_FancyTower = {init = PanelFancyTower, update = nil},
  Panel_guildInstance = {init = PanelBattGuild},
  Panel_ActivityAdventure = {init = PanelActivityAdventure, update = nil},
  Panel_FancyAbyss = {init = PanelFancyAbyss, update = nil},
  Panel_AwakeStage = {init = PanelAwakeStage, update = nil},
  Panel_AwakeStageBoss = {init = PanelAwakeStageBoss, update = nil},
  Panel_HadesHeat = {init = PanelHadesHeat, update = nil},
  Panel_GuildClash = {init = PanelGuildClash, update = nil},
  Panel_GuildMount = {init = PanelGuildMount, update = nil}
}

local function createDetailCard(self, node, id)
  self:removeDetailCard()
  if id then
    local w_pos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
    local l_pos = self.mainSelf.mainLayer:convertToNodeSpace(w_pos)
    l_pos.y = l_pos.y + 80
    local detailCard = ed.readequip.getDetailCard(id)
    if detailCard then
      self.detailCard = detailCard
      self.detailCard:setPosition(l_pos)
      self.mainSelf.mainLayer:addChild(self.detailCard, 1000)
    end
  end
end

class.createDetailCard = createDetailCard

local function removeDetailCard(self)
  if self.detailCard then
    self.mainSelf.mainLayer:removeChild(self.detailCard, true)
    self.detailCard = nil
  end
end

class.removeDetailCard = removeDetailCard

local function addPresetLayer(self)
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
  label:limitWidthByScale(70)
  btn:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self.mainSelf:btRegisterButtonClick({
    button = btn,
    key = "btnPreset",
    clickHandler = function()
      if self.isTouch then
        return
      end
      self:showPresetLayer()
    end,
    pressScale = 0.95,
    force = true
  })
  self.touch = true
  local addHeight = 0
  if self.mainSelf.pvpMode == "defend" then
    addHeight = 70
  end
  local layBgsSize = self.ui.layBgs:getContentSize()
  local presetBg = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_bg.png", CCRectMake(45, 70, 7, 16))
  presetBg:setContentSize(CCSizeMake(layBgsSize.width - 12, 350 + ed.display.halfFixedHeight * 2 + addHeight))
  presetBg:setPosition(ccp(layBgsSize.width / 2, layBgsSize.height / 2 + 30 + addHeight / 2))
  self.ui.layBgs:addChild(presetBg)
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
  label:limitWidthByScale(90)
  btn:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#4e3b25")), 1)
  self.mainSelf:btRegisterButtonClick({
    button = btn,
    key = "btnPresetExit",
    clickHandler = function()
      if self.isTouch then
        return
      end
      self:showPresetLayer()
    end,
    pressScale = 0.95,
    force = true
  })
  presetBg:setVisible(false)
  self.presetDraglist:setVisible(false)
  self.presetBg = presetBg
  self.groupId = 1
  self:refreshPresetLayer(self)
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
    self.mainSelf:btRegisterButtonClick({
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
          self:refreshPresetLayer(self)
          self.buttonPress[self.groupId]:setVisible(true)
          self:refreshpreseHeros()
        end
      end,
      pressScale = 0.85,
      normalScale = 0.9,
      force = true
    })
  end
  self.buttonDraglist:initListWidth(buttonIndex * widths)
  self.buttonDraglist:setVisible(false)
  self.mainSelf:listenEvent("scene_preset_reply", function(info)
    self.refreshIdx = nil
    local indexId, groupId = ed.presetData.analyzePreseIds(info.refreshIdx)
    if self.groupId ~= groupId then
      self.buttonPress[self.groupId]:setVisible(false)
      self.groupId = groupId
      self.buttonPress[self.groupId]:setVisible(true)
    end
    self.refreshIdx = indexId
    self:refreshPresetLayer()
    self:refreshpreseHeros()
  end)
  self.mainSelf:listenEvent("legendEquip_refresh", function(info)
    self:refreshPresetLayer()
  end)
  self.battleprepareHandler = self.mainSelf:doClickInList(self)
end

class.addPresetLayer = addPresetLayer

function class:onClickBtnSwitchPreset(groupId, indexId)
  local switchIds = ed.presetData.packPreseIds(indexId, groupId)
  if not self.switchIds then
    self.switchIds = switchIds
    self:refreshSwitchPresetItem()
  else
    ed.presetNetwork.switchLineupReq(self.switchIds, switchIds)
    self.switchIds = nil
    self:refreshSwitchPresetItem()
  end
end

function class:refreshSwitchPresetItem()
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

local function refreshPresetLayer(self)
  local con = self.ui.heros_items:getContentSize()
  local layBgsSize = self.ui.layBgs:getContentSize()
  self.teamNumlabel:setString(ed.presetData.teamNum .. "/" .. ed.presetData.preseMaxTeam)
  self.presetDraglist:clearList()
  for i, v in ipairs(self.btnToucRemovehKey or {}) do
    self.mainSelf:btRemoveMainTouchHandler({key = v})
  end
  self.btnToucRemovehKey = {}
  self.heroIcons = {}
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
        local hero = ed.readhero.createIconByHero(ed.player.heroes[heros[s]], {
          hmMode = self.mainSelf.mode == "crusade" and "crusade" or "",
          state = "idle",
          isShowLegendEquip = ed.openLegendEquip()
        })
        hero:showLegendEquip(ed.off_legendEquipOp)
        hero.icon:setPosition(posx + (6 - s) * width, sizeH / 2)
        itemBg:addChild(hero.icon)
        hero.icon:setScale(0.75)
        if self.mainSelf.mode == "GuildMountBoss" and ed.GuildMountManager:isHeroUsed(heros[s]) and self.mainSelf.objData.practice then
          hero:showPracticeUsedTag()
        elseif self.mainSelf:checkHeroUsed(heros[s]) then
          hero:showUsedTag()
        end
        table.insert(self.heroIcons, {
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
    self.mainSelf:btRegisterButtonClick({
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
    self.mainSelf:btRegisterButtonClick({
      button = btnSwitch,
      key = "btnSwitch" .. i,
      clickInterval = 0.3,
      clickHandler = function(param, x, y)
        if self.touch then
          self:onClickBtnSwitchPreset(self.groupId, v.indexId)
        end
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
    local label = ed.createttf(T("\228\189\191\231\148\168"), 16)
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
    self.mainSelf:btRegisterButtonClick({
      button = passImg,
      key = "passImg" .. i,
      clickInterval = 1,
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
        local heros = v.heros or {}
        self.mainSelf:usePresetTeam(heros)
        self.mainSelf:listenTimer(Timer:Once(0.1), function()
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
  self:refreshSwitchPresetItem()
  local addTeamImgBg = ed.createScale9Sprite("UI/alpha/1080P/battle/preset/preset_addteam_bg.png", CCRectMake(45, 40, 5, 25))
  addTeamImgBg:setContentSize(CCSizeMake(layBgsSize.width - 20, sizeH + 4))
  addTeamImgBg:setPosition(layBgsSize.width / 2 + 68, posY)
  self.presetDraglist.listLayer:addChild(addTeamImgBg)
  height = height + sizeH
  local addImg = ed.createSprite("UI/alpha/1080P/battle/preset/preset_add.png")
  addImg:setPositionY(sizeH / 2)
  addTeamImgBg:addChild(addImg)
  addImg:setScale(1.24)
  local label = ed.createttf(T("\231\130\185\229\135\187\229\162\158\229\138\160\230\150\176\233\162\132\232\174\190\233\152\181\229\174\185"), 24)
  label:setPositionY(sizeH / 2)
  label:setColor(ccc3(ed.colorToStr("#FFFCE7")))
  addTeamImgBg:addChild(label)
  ed.setLabelStroke(label, ccc3(ed.colorToStr("#674907")), 1)
  ed.layout.horizontalSortNode({addImg, label}, {-10, 0}, layBgsSize.width * 0.5)
  self.mainSelf:btRegisterButtonClick({
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
        ed.showToast(T("\233\152\181\229\174\185\230\149\176\233\135\143\229\183\178\232\190\190\228\184\138\233\153\144\239\188\129"))
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
        error(T("\230\151\160\230\179\149\229\162\158\229\138\160\233\152\181\229\174\185"))
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

class.refreshPresetLayer = refreshPresetLayer

local function refreshpreseHeros(self)
  local goStageId = {}
  for i, v in ipairs(self.mainSelf.team or {}) do
    goStageId[v.heroIcon.info.id] = true
  end
  for i, v in ipairs(self.heroIcons) do
    if v.hero.isUsed then
    elseif goStageId[v.id] then
      v.hero:showSelectTag()
    else
      v.hero:deleteSelectTag()
    end
  end
end

class.refreshpreseHeros = refreshpreseHeros

local function showPresetLayer(self, noShow)
  local isShow = self.presetBg:isVisible()
  if noShow then
    isShow = true
  end
  self.presetBg:setVisible(not isShow)
  self.mainSelf.buttonDraglist:setVisible(isShow)
  self.mainSelf.draglist:setVisible(isShow)
  self.mainSelf.ui.isbg:setVisible(isShow)
  self.btnShowPresetLay:setVisible(isShow)
  self.btnExitPresetLay:setVisible(not isShow)
  self.presetDraglist:setVisible(not isShow)
  self.buttonDraglist:setVisible(not isShow)
  if not isShow then
    self:refreshpreseHeros()
  end
end

class.showPresetLayer = showPresetLayer

local function addFireworkLayer(self)
  local posX, posY = self.ui.heros_items:getPosition()
  local con = self.ui.heros_items:getContentSize()
  local offsetY = 45
  local info = {
    cliprect = CCRectMake(posX, posY - offsetY, con.width, con.height + offsetY),
    container = self.ui.Panel_left,
    zorder = 20,
    doPressIn = function(x, y)
      for index, ui in ipairs(self.fireworkUI or {}) do
        if ed.containsPoint(ui.image_bg, x, y) then
          return ui
        end
      end
    end,
    doClickIn = function(x, y, cell)
      local itemData = cell.itemData
      local amount = itemData.itemAmount or 0
      local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
      local battlePrepareSceneCfg = nianMonsterMgr:getActivityUIConfig().battlePrepareSceneCfg
      if amount <= 0 then
        ed.showToast(battlePrepareSceneCfg.noItemTips)
        return
      end
      if cell == self.fireworkSelect then
        self:setFireworkSelect(self.fireworkSelect, false)
        self.fireworkSelect = nil
        ed.nianMonsterMgr.getInstance():setSelectItem(nil)
      else
        if self.fireworkSelect then
          self:setFireworkSelect(self.fireworkSelect, false)
        end
        self.fireworkSelect = cell
        self:setFireworkSelect(cell, true)
        ed.nianMonsterMgr.getInstance():setSelectItem(cell.itemId)
      end
    end,
    noshade = true
  }
  self.fireworkDraglist = ed.draglist.create(info)
  self:refreshFireworkLayer()
  local mgr = ed.nianMonsterMgr.getInstance()
  local battlePrepareSceneCfg = mgr:getActivityUIConfig().battlePrepareSceneCfg
  ed.setLabelString(self.mainSelf.ui.label4_1, battlePrepareSceneCfg.tabName)
  ed.setLabelString(self.mainSelf.ui.label4_2, battlePrepareSceneCfg.tabName)
  ed.setTexture(self.mainSelf.ui.image_firework_1, battlePrepareSceneCfg.fireworkTabPath1)
  ed.setTexture(self.mainSelf.ui.image_firework_2, battlePrepareSceneCfg.fireworkTabPath2)
end

class.addFireworkLayer = addFireworkLayer

local function refreshFireworkLayer(self)
  local listPosX, listPosY = self.fireworkDraglist:getListPos()
  self.fireworkDraglist:clearList()
  local goodsGroupId = self.objData.goodsGroupId
  if not goodsGroupId then
    return
  end
  local con = self.ui.heros_items:getContentSize()
  local layBgsSize = self.ui.layBgs:getContentSize()
  local nianMonsterMgr = ed.nianMonsterMgr.getInstance()
  local battlePrepareSceneCfg = nianMonsterMgr:getActivityUIConfig().battlePrepareSceneCfg
  local labelTitle = ed.createLabelWithFontInfo(battlePrepareSceneCfg.fireworkTitle, "title_while")
  local listTitleBg = ed.createSprite("UI/alpha/1080P/nianmonster/nian_pre_firework_choose.png")
  listTitleBg:addChild(labelTitle)
  ed.layout.centerInParent(labelTitle)
  self.fireworkDraglist:addItem(listTitleBg)
  listTitleBg:setPosition(ccp(con.width / 2 + layBgsSize.width / 9, 450))
  local totalHeight = 0
  local gapY = 3
  local size = CCSizeMake(0, 0)
  local fireworkList = {}
  for itemId, itemCfg in pairs(ed.getDataTable("NianMonsterGoods")[goodsGroupId] or {}) do
    table.insert(fireworkList, {
      itemId = itemId,
      itemAmount = ed.player:getEquipAmount(itemId),
      itemCfg = itemCfg
    })
  end
  table.sort(fireworkList, ed.cmpSort({
    {
      getValue = function(t)
        return t.itemAmount > 0 and 0 or 1
      end
    },
    {key = "itemId"}
  }))
  self.fireworkUI = {}
  local selectItemId = ed.nianMonsterMgr.getInstance():getSelectItem()
  for index, itemData in ipairs(fireworkList) do
    local itemId = itemData.itemId
    local itemCfg = itemData.itemCfg
    local item, ui = self:createFireworkItem(itemId, itemCfg)
    ui.itemData = itemData
    ui.itemId = itemId
    if selectItemId == itemId then
      self:setFireworkSelect(ui, true)
      self.fireworkSelect = ui
    end
    table.insert(self.fireworkUI, ui)
    self.fireworkDraglist:addItem(item)
    size = item:getContentSize()
    local x = con.width / 2 + 80
    local y = -totalHeight + con.height + size.height
    item:setPosition(ccp(x, y))
    totalHeight = totalHeight + size.height + gapY
  end
  self.fireworkDraglist:setVisible(false)
  self.fireworkDraglist:initListHeight(totalHeight + 22)
  self.fireworkDraglist:setListPos(ccp(listPosX, listPosY))
end

class.refreshFireworkLayer = refreshFireworkLayer

local function createFireworkItem(self, itemId, itemCfg)
  local container, ui = ed.editorui(ed.uieditor.battlePrepareFireworkItem)
  container:setContentSize(ui.image_bg:getContentSize())
  local layBgsSize = self.ui.layBgs:getContentSize()
  local oldSize = ui.image_bg:getContentSize()
  ui.image_bg:setContentSize(CCSizeMake(layBgsSize.width - 40, 107))
  local newSize = ui.image_bg:getContentSize()
  ui.image_mask:setContentSize(newSize)
  ui.image_select_frame:setContentSize(CCSizeMake(layBgsSize.width - 20, 125))
  ui.panel_item:setPositionX(ui.panel_item:getPositionX() - (newSize.width - oldSize.width) / 2)
  ui.label_item_name:setPositionX(ui.label_item_name:getPositionX() - (newSize.width - oldSize.width) / 2)
  ui.label_desc:setPositionX(ui.label_desc:getPositionX() - (newSize.width - oldSize.width) / 2)
  ui.image_select:setPositionX(ui.image_select:getPositionX() + (newSize.width - oldSize.width) / 2)
  local itemAmount = ed.player:getEquipAmount(itemId)
  local icon = ed.readequip.createIconWithAmount(itemId, nil, itemAmount)
  ui.panel_item:addChild(icon)
  ed.layout.centerInParent(icon)
  if itemAmount <= 0 then
    ui.label_have:setVisible(true)
    ui.image_mask:setVisible(true)
  else
    ui.label_have:setVisible(false)
    ui.image_mask:setVisible(false)
  end
  local itemName = ed.getDataTable("equip")[itemId].Name
  ed.setLabelString(ui.label_item_name, itemName)
  ed.setLabelStroke(ui.label_item_name, ed.toccc3(2366999), 1)
  ui.label_have:setPositionX(ui.label_item_name:getPositionX() + ui.label_item_name:getContentSize().width / 2)
  local desStr = ed.readequip.value(itemId, "Description")
  ui.label_desc:setDimensions(CCSizeMake(ui.image_bg:getContentSize().width - 130, 0))
  ui.label_desc:setHorizontalAlignment(kCCTextAlignmentLeft)
  ui.label_desc:setString(desStr)
  ui.image_select:setVisible(false)
  ui.image_select_frame:setVisible(false)
  return container, ui
end

class.createFireworkItem = createFireworkItem

local function setFireworkSelect(self, ui, isSelect)
  if isSelect then
    ui.image_select:setVisible(true)
    ui.image_select_frame:setVisible(true)
    local size = ui.image_bg:getContentSize()
    ui.image_bg:setSpriteFrame(ed.getSpriteFrame("UI/alpha/1080P/herolist/bg_hero_summon.png"))
    ui.image_bg:setContentSize(size)
  else
    ui.image_select:setVisible(false)
    ui.image_select_frame:setVisible(false)
    local size = ui.image_bg:getContentSize()
    ui.image_bg:setSpriteFrame(ed.getSpriteFrame("UI/alpha/1080P/herolist/bg_hero_normal.png"))
    ui.image_bg:setContentSize(size)
  end
end

class.setFireworkSelect = setFireworkSelect

local function showFireworkLayer(self, isShow)
  if self.fireworkDraglist then
    self.fireworkDraglist:setVisible(isShow)
  end
  self.mainSelf.buttonDraglist:setVisible(not isShow)
  self.mainSelf.ui.layUp_ButOrBg:setVisible(not isShow)
  self.mainSelf.draglist:setVisible(not isShow)
  self.mainSelf.ui.isbg:setVisible(not isShow)
  self.buttonDraglist:setVisible(not isShow)
end

class.showFireworkLayer = showFireworkLayer

local function createRecommendBtn(self)
  local main = self.mainSelf
  local mode = main.mode
  if mode ~= "dreamland" and mode ~= "stageDetail" then
    return
  end
  self.mainSelf:listenEvent("hh_common_lineup_recommend_reply", function(info)
    self:handleHotRecommend(info)
  end)
  self.mainSelf:listenEvent("hh_lineup_recommend_reply", function(info)
    self:handleHotRecommend(info)
  end)
  local modeConfig = {
    dreamland = {
      gameplay = "dreamland_team",
      stageid = self.mainSelf.stage,
      normal_icon_res = "UI/alpha/1080P/dreamland/dream_prepare_recommend_tab1.png",
      select_icon_res = "UI/alpha/1080P/dreamland/dream_prepare_recommend_tab2.png"
    },
    stageDetail = {
      gameplay = "stage",
      stageid = self.mainSelf.stage,
      normal_icon_res = "UI/alpha/1080P/dreamland/dream_prepare_recommend_tab1.png",
      select_icon_res = "UI/alpha/1080P/dreamland/dream_prepare_recommend_tab2.png"
    }
  }
  self.recom_gameplay = modeConfig[mode].gameplay
  self.recom_stageid = modeConfig[mode].stageid
  local normal_icon_res = modeConfig[mode].normal_icon_res
  local select_icon_res = modeConfig[mode].select_icon_res
  local pos
  if main:canShowMercenary() then
    pos = ccp(33, 49.5)
  else
    pos = ccp(33, 133)
  end
  local normal_recom_Btn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
    pos = pos,
    parent = self.ui.layLeftButs
  })
  local normal_size = normal_recom_Btn:getContentSize()
  local n_width, n_height = normal_size.width * 0.5, normal_size.height * 0.5
  self.ui.layLeftButs:addChild(normal_recom_Btn)
  local normal_label = ed.createLabelTTF(T("\230\148\187\231\149\165"), 18)
  ed.setLabelColor(normal_label, ed.toccc3(16776423))
  normal_label:setPosition(ccp(n_width + 3.5, n_height - 16))
  normal_recom_Btn:addChild(normal_label)
  local normal_icon = ed.createSpriteTools({
    res = normal_icon_res,
    pos = ccp(n_width + 3.5, n_height + 9.5),
    parent = normal_recom_Btn
  })
  normal_recom_Btn:addChild(normal_icon)
  local select_recom_Btn = ed.createSpriteTools({
    res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
    pos = ccp(pos.x + 3.5, pos.y),
    parent = self.ui.layLeftButs
  })
  local select_size = select_recom_Btn:getContentSize()
  local s_width, s_height = select_size.width * 0.5, select_size.height * 0.5
  local select_label = ed.createLabelTTF(T("\230\148\187\231\149\165"), 18)
  ed.setLabelColor(select_label, ed.toccc3(4405556))
  select_label:setPosition(ccp(s_width, s_height - 17))
  select_recom_Btn:addChild(select_label)
  local select_icon = ed.createSpriteTools({
    res = select_icon_res,
    pos = ccp(n_width + 3.5, n_height + 9.5),
    parent = select_recom_Btn
  })
  select_recom_Btn:addChild(select_icon)
  select_recom_Btn:setVisible(false)
  self.mainSelf:btRegisterButtonClick({
    button = normal_recom_Btn,
    key = "Recommend_btn",
    pressHandler = function()
      local vis = select_recom_Btn:isVisible()
      if vis then
        return
      end
      select_recom_Btn:setVisible(true)
    end,
    cancelPressHandler = function(param, x, y)
      if self.mainSelf.tag == "recom" then
        return
      end
      if ed.containsPoint(normal_recom_Btn, x, y) then
        main:doChangeTag("recom")
        self.ui.layUp_ButOrBg:setVisible(false)
        if not self.requireHotData then
          if self.mainSelf.mode == "stageDetail" then
            ed.HeroRecommendNetwork:sendLineupRecommend(self.recom_stageid or 1, self.recom_gameplay or "stage")
          else
            ed.HeroRecommendNetwork:sendHotRecommend(self.recom_stageid, self.recom_gameplay)
          end
          self.requireHotData = true
        end
      else
        select_recom_Btn:setVisible(false)
      end
    end
  })
  self.normal_recom_Btn = normal_recom_Btn
  self.select_recom_Btn = select_recom_Btn
  self:createRecommendDragList()
end

class.createRecommendBtn = createRecommendBtn

local function createRecommendDragList(self)
  local posX, posY = self.ui.heros_items:getPosition()
  local con = self.ui.heros_items:getContentSize()
  local recomLineupLayer = CCLayer:create()
  recomLineupLayer:setContentSize(CCSizeMake(con.width, con.height + 32))
  local size = recomLineupLayer:getContentSize()
  recomLineupLayer:setPosition(ccp(posX, posY - 32))
  self.ui.Panel_left:addChild(recomLineupLayer)
  self.recomLayer = recomLineupLayer
  local info = {
    container = recomLineupLayer,
    zorder = 20,
    doPressIn = self:doPressInRecomList(),
    bar = {
      bglen = size.height,
      bgpos = ccp(0, size.height / 2)
    },
    cancelPressIn = self:cancelPressInRecomList(),
    noshade = true
  }
  local draglist = ed.UITool.createDraglist(recomLineupLayer, info)
  self.recom_draglist = draglist
end

class.createRecommendDragList = createRecommendDragList

local function doPressInRecomList(self)
  local function handler(x, y)
    for i, v in ipairs(self.recomLineupUI or {}) do
      if ed.containsPoint(v, x, y) then
        v:setScale(0.9)
        
        return v
      end
    end
    return nil
  end
  
  return handler
end

class.doPressInRecomList = doPressInRecomList

local function cancelPressInRecomList(self)
  local function handler(x, y, v)
    if not v then
      return
    end
    v:setScale(1)
    if ed.containsPoint(v, x, y) then
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:useRecomLineup(v.index or 0)
    end
  end
  
  return handler
end

class.cancelPressInRecomList = cancelPressInRecomList

local function refreshRecomLayer(self, isSelect)
  if not self.recom_draglist then
    return
  end
  local show = isSelect
  self.recom_draglist:setVisible(show)
  self.mainSelf.draglist:setVisible(not show)
  self.select_recom_Btn:setVisible(show)
end

class.refreshRecomLayer = refreshRecomLayer

local function handleHotRecommend(self, info)
  self.recomLineups = {}
  self.recomLineupUI = {}
  self.recomHeroIcons = {}
  if self.mainSelf.mode == "stageDetail" then
    self.recomLineups = info._stage_lineups or {}
  else
    self.recomLineups = info._lineups or {}
  end
  local size = self.recomLayer:getContentSize()
  if #self.recomLineups > 0 then
    if self.mainSelf.mode == "stageDetail" then
      self.recomLineups = ed.copyProto(self.recomLineups)
      table.sort(self.recomLineups or {}, function(a, b)
        if a._gs == b._gs then
          return a._stars < b._stars
        else
          return a._gs < b._gs
        end
      end)
      for i, v in ipairs(self.recomLineups) do
        self:createLineupItem({}, i, v._heros, v._gs, v._stars)
      end
      self.recom_draglist:initListHeight(93 * #self.recomLineups)
    else
      for i, v in ipairs(self.recomLineups) do
        local heroids = v._hero_id
        self:createLineupItem(heroids, i)
      end
      self.recom_draglist:initListHeight(93 * #self.recomLineups)
    end
    self:refreshRecomHeroIcon()
  elseif #self.recomLineups == 0 then
    local label_bg = ed.createScale9Sprite("UI/alpha/1080P/dreamland/dream_prepare_recommend_bg.png", CCRectMake(150, 15, 50, 10))
    label_bg:setContentSize(CCSizeMake(508, 42))
    label_bg:setPosition(ccp(size.width * 0.5, size.height * 0.5))
    local label_no_recom = ed.createLabelTTF(T("\230\149\176\230\141\174\230\173\163\229\156\168\231\187\159\232\174\161\228\184\173\239\188\140\230\154\130\230\151\160\230\142\168\232\141\144\232\139\177\233\155\132"), 21)
    ed.setLabelColor(label_no_recom, ed.toccc3(13484461))
    label_bg:addChild(label_no_recom)
    ed.layout.centerInParent(label_no_recom)
    self.recom_draglist:addItem(label_bg)
  end
end

class.handleHotRecommend = handleHotRecommend

local function createLineupItem(self, heroids, index, heros, gs, star)
  local function cmp(id1, id2)
    return ed.readhero.getHeroMaxRange(id1) < ed.readhero.getHeroMaxRange(id2)
  end
  
  table.sort(heroids, cmp)
  local size, itemHei = self.recomLayer:getContentSize(), 90
  local itemBg
  if self.mainSelf.mode == "dreamland" then
    itemBg = ed.createScale9Sprite("UI/alpha/1080P/skilltower/bg_had_get.png", CCRectMake(45, 70, 7, 16))
    itemBg:setContentSize(CCSizeMake(size.width - 10, itemHei))
    local leftImg = ed.createSprite("UI/alpha/1080P/dreamland/dream_prepare_recommend_tag.png")
    leftImg:setPosition(60, itemHei * 0.5)
    itemBg:addChild(leftImg)
    local label_recom = ed.createLabelTTF(T("\230\142\168\232\141\144") .. index, 17)
    ed.setLabelColor(label_recom, ed.toccc3(16776423))
    ed.setLabelStroke(label_recom, ed.toccc3(11096064), 1)
    leftImg:addChild(label_recom)
    ed.layout.centerInParent(label_recom)
    local posx = 160
    local fixWid = ed.display.halfFixedWidth * 0.7
    for i = 1, #heroids do
      local ind = #heroids - i + 1
      local heroid = heroids[i]
      local hero = ed.readhero.createIcon({id = heroid, rank = 1})
      local icon = hero.icon
      if ed.player.heroes[heroid] then
        table.insert(self.recomHeroIcons, {id = heroid, hero = hero})
      else
        local opacity = CCLayerColor:create(ccc4(0, 0, 0, 102))
        opacity:setContentSize(icon:getContentSize())
        icon:addChild(opacity, 999)
        ed.createLabelTools({
          txt = T("\230\156\170\230\139\165\230\156\137"),
          size = 14,
          pos = ccp(35, 35),
          color = ed.toccc3(16740401),
          parent = opacity,
          stroke = {
            ed.toccc3(656398),
            1
          }
        })
      end
      icon:setScale(0.75)
      icon:setPosition(ccp(size.width * 0.22 + (ind - 0.5) * (60 + fixWid / 4), itemHei * 0.5))
      itemBg:addChild(icon)
    end
    local useBtn = ed.createScale9Sprite("UI/alpha/1080P/common/button_com_mini.png", CCRectMake(10, 10, 81.5, 20))
    useBtn:setContentSize(CCSizeMake(100, 40))
    useBtn:setPosition(size.width * 0.87, itemHei * 0.5)
    useBtn.index = index
    itemBg:addChild(useBtn)
    local label_use = ed.createLabelTTF(T("\228\189\191\231\148\168"), 16)
    label_use:setColor(ccc3(ed.colorToStr("#FCF1A6")))
    useBtn:addChild(label_use)
    ed.layout.centerInParent(label_use)
    ed.setLabelShadow(label_use, ccc3(0, 0, 0), ccp(0, 2))
    table.insert(self.recomLineupUI, useBtn)
    
    local function cntPos(ind)
      local itemHei, topHei = 93, size.height
      local posX, posY = size.width * 0.5, topHei - (ind - 0.5) * itemHei
      return ccp(posX, posY)
    end
    
    self.recom_draglist:addItem(itemBg, cntPos(index))
  elseif self.mainSelf.mode == "stageDetail" then
    local function cmp(a, b)
      return ed.readhero.getHeroMaxRange(a._tid) > ed.readhero.getHeroMaxRange(b._tid)
    end
    
    table.sort(heros, cmp)
    local ui = {}
    ui.bg = ed.createSpriteTools({
      res = "UI/alpha/1080P/campaign/lineup_guide/short.png",
      rectMake = CCRectMake(280, 45, 100, 2),
      sizeMake = CCSizeMake(size.width - 6, 92)
    })
    local res1, res2 = "UI/alpha/1080P/campaign/main/campaign_stage_star_1.png", "UI/alpha/1080P/campaign/main/campaign_stage_star_3.png"
    ed.createSpriteTools({
      res = 1 <= star and res1 or res2,
      pos = ccp(60, 46 + (1 <= star and 12 or 13)),
      parent = ui.bg,
      scale = 0.9
    })
    ed.createSpriteTools({
      res = 2 <= star and res1 or res2,
      pos = ccp(98, 46 + (2 <= star and 12 or 13)),
      parent = ui.bg,
      scale = 0.9
    })
    ed.createSpriteTools({
      res = 3 <= star and res1 or res2,
      pos = ccp(136, 46 + (3 <= star and 12 or 13)),
      parent = ui.bg,
      scale = 0.9
    })
    ui.gsbg = ed.createSpriteTools({
      res = "UI/alpha/1080P/campaign/lineup_guide/power_bg.png",
      rectMake = CCRectMake(15, 2, 10, 6),
      sizeMake = CCSizeMake(160, 26),
      pos = ccp(95, 26),
      parent = ui.bg,
      scale = 0.9
    })
    local gs_lab = ed.createLabelTools({
      txt = T("\230\136\152\229\138\155:"),
      size = 15,
      pos = ccp(18, 13),
      color = ed.toccc3(16776423),
      parent = ui.gsbg,
      anchor = ccp(0, 0.5)
    })
    local labSize = gs_lab:getContentSize()
    local gs_num = ed.createLabelTools({
      txt = gs,
      size = 20,
      pos = ccp(80 + labSize.width / 2, 13),
      color = ed.toccc3(16753969),
      parent = ui.gsbg,
      anchor = ccp(0.5, 0.5)
    })
    ed.left2(gs_lab, gs_num, 0)
    for i, v in ipairs(heros or {}) do
      local icon = ed.readhero.createIcon({
        id = v._tid,
        rank = v._rank,
        level = v._level,
        stars = v._stars,
        state = "idle"
      }).icon
      icon:setScale(0.67)
      icon:setPosition(size.width * 0.26 + i * 57, 46)
      ui.bg:addChild(icon)
      if not ed.player.heroes[v._tid] then
        local opacity = CCLayerColor:create(ccc4(0, 0, 0, 102))
        opacity:setContentSize(icon:getContentSize())
        icon:addChild(opacity, 999)
        ed.createLabelTools({
          txt = T("\230\156\170\230\139\165\230\156\137"),
          size = 14,
          pos = ccp(35, 35),
          color = ed.toccc3(16740401),
          parent = opacity,
          stroke = {
            ed.toccc3(656398),
            1
          }
        })
      end
    end
    itemBg = ui.bg
    ui.button = ed.createSpriteTools({
      res = "UI/alpha/1080P/common/button_com_mini.png",
      pos = ccp(size.width * 0.89, 46),
      parent = ui.bg,
      scale = 1
    })
    ed.createLabelTools({
      txt = T("\228\189\191\231\148\168"),
      size = 16,
      pos = ccp(51, 22),
      color = ed.toccc3(16576934),
      parent = ui.button,
      shadow = {
        ccc3(0, 0, 0),
        ccp(0, 2)
      }
    })
    ui.button.index = index
    table.insert(self.recomLineupUI, ui.button)
    
    local function cntPos(ind)
      local itemHei, topHei = 93, size.height
      local posX, posY = size.width * 0.5, topHei - (ind - 0.5) * itemHei
      return ccp(posX, posY)
    end
    
    self.recom_draglist:addItem(itemBg, cntPos(index))
  end
  return itemBg
end

class.createLineupItem = createLineupItem

local function useRecomLineup(self, index)
  if self.mainSelf.mode == "stageDetail" then
    local heros = self.recomLineups[index]._heros
    if not heros then
      return
    end
    local heroes = {}
    for i = 1, 5 do
      if heros[i] then
        local heroid = heros[i]._tid
        local hero = ed.readhero.getHero(heroid)
        if hero then
          table.insert(heroes, heroid)
        end
      else
        break
      end
    end
    self.mainSelf:usePresetTeam(heroes, true)
  else
    local heroids = self.recomLineups[index]._hero_id
    if not heroids then
      return
    end
    local heroes = {}
    for i = 1, 5 do
      local heroid = heroids[i]
      if not heroid then
        break
      end
      local hero = ed.readhero.getHero(heroid)
      if hero then
        table.insert(heroes, heroid)
      end
    end
    self.mainSelf:usePresetTeam(heroes, true)
  end
end

class.useRecomLineup = useRecomLineup

local function refreshRecomHeroIcon(self)
  if not self.recomHeroIcons or #self.recomHeroIcons < 1 then
    return
  end
  local goStageId = {}
  for i, v in ipairs(self.mainSelf.team or {}) do
    goStageId[v.heroIcon.info.id] = true
  end
  for i, v in ipairs(self.recomHeroIcons) do
    if not v or v.hero.isUsed then
    elseif goStageId[v.id] then
      v.hero:showSelectTag()
    else
      v.hero:deleteSelectTag()
    end
  end
end

class.refreshRecomHeroIcon = refreshRecomHeroIcon
