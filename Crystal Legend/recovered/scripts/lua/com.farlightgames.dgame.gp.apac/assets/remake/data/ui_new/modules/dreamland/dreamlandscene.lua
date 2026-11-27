module("ed", package.seeall)
DreamlandSceneScope = {}
DreamlandSceneOnEnterScope = {}
local lines = 10
dreamland.rank_edge = 10000
local DreamlandScene = {}
DreamlandScene.__index = DreamlandScene
ui.dreamlandscene = DreamlandScene
local base = ui.basescene
setmetatable(DreamlandScene, base.mt)
require("ui_new/modules/dreamland/dreamRewardPop")
require("ui_new/modules/dreamland/dreamRecordPop")
require("ui_new/modules/dreamland/dreamAnnouncedPop")
ed.UITool.registViewOpenFunc("dreamland", function()
  ed.dreamland.network_mgr:RequestOpenPanel()
end)

function DreamlandScene.create(proto_data)
  local dreamland_scene = base.create("dreamland")
  setmetatable(dreamland_scene, DreamlandScene)
  dreamland_scene:InitData(proto_data)
  for i, v in ipairs(uieditor.dreamlandmain) do
    if v.base and v.base.name and not v.base.font then
      local name = v.base.name
      if name == "label_title_boss_desc" or name == "label_title_boss_skill" then
        v.base.font = ed.fontBold
      end
    end
  end
  local container, ui = editorui(uieditor.dreamlandmain)
  dreamland_scene.container = container
  dreamland_scene.ui = ui
  dreamland_scene.mainLayer:addChild(container)
  dreamland_scene.ui.image_title:setVisible(false)
  local _, titleTxt = ed.UITool.createSceneTitle(T("\230\176\184\231\148\159\230\162\166\229\162\131"), dreamland_scene.ui.image_title_bg, {
    position = ccp(24, 20)
  })
  ed.layout.relateLayout(titleTxt, dreamland_scene.ui.btn_rule, {
    right = titleTxt:getContentSize().width * 0.5 + 20
  })
  dreamland_scene:laterProcessUI()
  dreamland_scene:InitAppearance()
  dreamland_scene:RegisterTouchHandler()
  dreamland_scene:registerOnEnterHandler("onEnter", function()
    dreamland_scene:OnEnter()
    dreamland_scene:DetailOnEnter()
  end)
  dreamland_scene:registerOnPopSceneHandler("onPop", function()
    dreamland_scene:Destroy()
  end)
  local widhtWin = ed.display.winSize.width
  local heightWin = ed.display.winSize.height
  local bl = widhtWin / heightWin
  local bjRes = "UI/alpha/1080P/bg/dreamland_bj_1080.jpg"
  if bl <= 1.4 then
    bjRes = "UI/alpha/1080P/bg/dreamland_bj_1440.jpg"
  elseif 1.78 <= bl then
    bjRes = "UI/alpha/1080P/bg/dreamland_bj_2340.jpg"
  end
  dreamland_scene:setBackground(bjRes)
  dreamland_scene:setBackButton(function()
    ed.playEffect(ed.sound.common.back)
  end)
  return dreamland_scene
end

function DreamlandScene:laterProcessUI()
  self.ui.image_interaction_bg:setContentSize(CCSizeMake(ed.display.winSize.width - 85, 90))
  ed.layout.layoutWithMagin(self.ui.image_interaction_bg, {bottom = 55.5}, true)
  ed.layout.layoutWithMagin(self.ui.layer_chance, {
    right = 26.5 + ed.display.halfFixedWidth * 0.6,
    bottom = 10
  })
  self.ui.label_left_chance_title_bg:setScaleX(ed.display.halfFixedWidth * 0.6 > 10 and 1 or 0.7)
  ed.layout.layoutWithMagin(self.ui.layer_status, {left = 46.5, bottom = 14})
  ed.layout.layoutWithMagin(self.ui.image_no_status_bg, {left = 46.5, bottom = 14})
  ed.layout.layoutWithMagin(self.ui.buttLay, {
    left = 47.5 + ed.display.halfFixedWidth * 0.3
  })
  self.ui.Panel_title_lay:setPosition(-ed.display.halfFixedWidth, 415 + ed.display.halfFixedHeight)
  ed.layout.layoutWithMagin(self.ui.Panel_bg, {left = 53.5, bottom = 17})
  local posX = self.ui.str1:getPositionX() + math.max(self.ui.str1:getContentSize().width, self.ui.str1_Copy0:getContentSize().width)
  self.ui.layer_rank_txt_Copy0:setPositionX(posX)
  self.ui.label_damage_txt_Copy0:setPositionX(posX)
  local posX = self.ui.label_rank_title:getPositionX() + math.max(self.ui.label_rank_title:getContentSize().width, self.ui.str1_Copy0:getContentSize().width)
  self.ui.layer_rank_txt:setPositionX(posX)
  self.ui.label_damage_txt:setPositionX(posX)
  self.ui.label_no_status:setDimensions(CCSizeMake(350, 0))
  self.ui.intteraction_bg:setVisible(false)
  self.ui.layer_boss_detail:setPositionX(self.ui.layer_boss_detail:getPositionX() + ed.display.halfFixedWidth / 2)
  local add = ed.display.halfFixedWidth / 120 * 0.2
  local wid = self.ui.boss_desc_bg:getContentSize().width * add
  self.ui.boss_desc_bg:setScaleX(1 + add)
  local con = self.ui.layer_boss_skill:getContentSize()
  self.ui.layer_boss_skill:setContentSize(CCSizeMake(con.width + wid, con.height))
  self.ui.layer_boss_skill:setPositionX(self.ui.layer_boss_skill:getPositionX() - wid / 2)
  self.ui.label_boss_desc:setPositionX(self.ui.label_boss_desc:getPositionX() - wid / 2)
  self.ui.label_title_boss_skill:setPositionX(self.ui.label_title_boss_skill:getPositionX() - wid / 2)
  self.ui.ImageView_5976_Copy2:setPositionX(self.ui.ImageView_5976_Copy2:getPositionX() - wid / 2)
  self.ui.label_title_boss_desc:setPositionX(self.ui.label_title_boss_desc:getPositionX() - wid / 2)
  self.ui.ImageView_5976:setPositionX(self.ui.ImageView_5976:getPositionX() - wid / 2)
  self.ui.ImageView_5976_Copy0:setPositionX(self.ui.ImageView_5976_Copy0:getPositionX() - wid / 2)
  self.ui.ImageView_5976_Copy1:setPositionX(self.ui.ImageView_5976_Copy1:getPositionX() - wid / 2)
  self.ui.label_title_boss_desc:setStroke(ccc3(13, 32, 14), 1)
  self.ui.label_title_boss_skill:setStroke(ccc3(13, 32, 14), 1)
  self.ui.label_reward_title:setStroke(ccc3(13, 32, 14), 1)
  self.ui.ImageView_6269:setPositionX(self.ui.ImageView_6269:getPositionX() + wid / 2)
  self.ui.layer_reward_items:setPositionX(self.ui.layer_reward_items:getPositionX() + wid / 2 - 10)
  self.ui.label_reward_title:setPositionX(self.ui.label_reward_title:getPositionX() + wid / 2 + 10)
  ed.setLabelString(self.ui.label_reward_title, T("\231\187\147\231\174\151\n\229\165\150\229\138\177"))
  self.ui.label_title_boss_desc:limitWidthByScale(90)
end

function DreamlandScene:Destroy()
  self:UnregisterEvents()
end

function DreamlandScene:RegisterTouchHandler()
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.btn_shop,
    press = ui.btn_shop_press,
    key = "btn_shop",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:OpenShop()
    end,
    pressScale = 1.1,
    force = true,
    mcpMode = true,
    clickInterval = 1
  })
  self:btRegisterButtonClick({
    button = ui.btn_rule,
    press = ui.btn_rule_press,
    key = "btn_rule",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:ShowRule()
    end,
    pressScale = 1.1,
    force = true,
    mcpMode = true,
    clickInterval = 1
  })
  self:btRegisterButtonClick({
    button = ui.btn_rank_list,
    press = ui.btn_rank_list_press,
    key = "btn_rank_list",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:OpenRankList()
    end,
    pressScale = 1.1,
    force = true,
    mcpMode = true,
    clickInterval = 1
  })
  ui.btn_hot_lay:setVisible(false)
  self:btRegisterButtonClick({
    button = ui.btn_hot,
    press = ui.btn_hot_press,
    key = "btn_hot",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.showToast(T("\230\154\130\230\151\160\231\131\173\233\151\168\232\139\177\233\155\132"))
    end,
    force = true,
    mcpMode = true,
    pressScale = 1.1,
    clickInterval = 1
  })
  self:btRegisterButtonClick({
    button = ui.btn_rewards,
    key = "btn_rewards",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.UITool.openView("dreamRewardPop")
    end,
    force = true,
    mcpMode = true,
    pressScale = 1.1,
    clickInterval = 1
  })
  self:btRegisterButtonClick({
    button = ui.btn_playback,
    key = "btn_playback",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.dreamland.network_mgr:sendBattleRecord()
    end,
    force = true,
    mcpMode = true,
    pressScale = 1.1,
    clickInterval = 1
  })
  self:btRegisterButtonClick({
    button = ui.chance_add_btn,
    key = "chance_add_btn",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      self:BuyChance()
    end,
    force = true,
    mcpMode = true,
    pressScale = 1.1,
    clickInterval = 1
  })
  self:btRegisterButtonClick({
    button = ui.btn_announced,
    key = "btn_announced",
    clickHandler = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
      ed.UITool.openView("dreamAnnouncedPop")
    end,
    force = true,
    mcpMode = true,
    pressScale = 1.1,
    clickInterval = 1
  })
  local center = self.config.center
  local radius = self.config.radius
  self:btRegisterHandler({
    handler = function(event, x, y)
      if event == "began" then
        if self.skillIconList and #self.skillIconList > 0 then
          for i, icon in ipairs(self.skillIconList) do
            if ed.containsPoint(icon, x, y) then
              local des = self.stageSkills[i].des
              if des then
                local desText = des
                ed.showHintText(desText, ccp(x - 100, 300))
              end
              return
            end
          end
        end
      elseif event == "ended" then
        ed.closeHintText()
      end
    end,
    key = "dreamland_boss_touch"
  })
  self:BossPressed()
end

function DreamlandScene:RegisterEvents()
  CloseScope(DreamlandSceneOnEnterScope)
  ListenEvent("DreamlandChanceReset", function(times)
    self:ChanceReset(times)
  end, DreamlandSceneOnEnterScope)
  ListenEvent("DreamlandStateChange", function(state)
    self:DreamlandStateChange(state)
  end, DreamlandSceneOnEnterScope)
end

function DreamlandScene:UnregisterEvents()
  CloseScope(DreamlandSceneScope)
  CloseScope(DreamlandSceneOnEnterScope)
end

function DreamlandScene:Return()
  self:Destroy()
  popScene()
end

function DreamlandScene:OnEnter()
  EDLog("DreamlandScene:OnEnter()")
  self:RegisterEvents()
  if self.dreamland:IsNone() then
    self:Return()
    return
  end
  self:RefreshAppearance()
end

function DreamlandScene:InitData(proto_data)
  self.proto_data = proto_data
  if dreamland.dreamland_object then
    dreamland.dreamland_object:ResetData(proto_data)
  else
    dreamland.dreamland_object = dreamland.Dreamland.Create(proto_data)
  end
  self.dreamland = dreamland.dreamland_object
  self.stage_id_buffer = self.dreamland:GetStage()
  self.config = dreamland.Config[self.stage_id_buffer]
  if self.config == nil then
    print("new monster table is nil , stageId = ", self.stage_id_buffer)
  end
end

function DreamlandScene:InitAppearance()
  self:InitTimeInfo()
  self:CreateBossFca()
  self:CreateBossName()
  self:InitChanceInfo()
  self:initBuffActivity()
end

function DreamlandScene:initBuffActivity()
  local activityInfo = ed.activityHints.data:getDreamBuffActivityInfo()
  local buffName = {
    [2001] = "\230\128\156\233\166\153\230\131\156\231\142\137",
    [2002] = "\230\156\137\229\139\135\230\151\160\232\176\139",
    [2003] = "\232\190\149\233\151\168\229\176\132\230\136\159",
    [2004] = "\228\184\137\229\155\189\230\157\128",
    [2005] = "\228\184\137\229\155\189\230\157\128"
  }
  if activityInfo then
    if self.BuffActivityLayer then
      self.BuffActivityLayer:removeFromParentAndCleanup(true)
    end
    local time = ed.getServerTime()
    local buffid = ed.activityHints.data:getDreamStageBuffId()
    if buffid then
      local newWid = ed.display.halfFixedWidth
      local newHei = ed.display.halfFixedHeight
      local skill = ed.getDataTable("StageSkill")[buffid]
      local bg = ed.createSpriteTools({
        res = "UI/alpha/1080P/activity/bubugaosheng/buff_bg.png",
        pos = ccp(180 - newWid / 2, ed.display.winSize.height - 90 - newHei),
        parent = self.container
      })
      local icon = ed.createSpriteTools({
        res = skill["Skill 1 Icon"],
        pos = ccp(42, 29),
        parent = bg
      })
      local thisCon = icon:getContentSize()
      icon:setScale(30 / thisCon.width)
      local iconBg = ed.createSpriteTools({
        res = "UI/alpha/1080P/activity/bubugaosheng/buff_frame.png",
        pos = ccp(42, 29),
        parent = bg
      })
      ed.createLabelTools({
        txt = buffName[buffid],
        size = 14,
        pos = ccp(70, 39),
        color = ed.toccc3(16776423),
        stroke = {
          ccc3(ed.colorToStr("#3a0806")),
          1.3
        },
        parent = bg,
        anchor = ccp(0, 0.5)
      })
      local h = ed.second2hms(activityInfo._end_time - ed.getServerTime())
      local d = math.ceil((time - activityInfo._start_time) / 86400)
      ed.createLabelTools({
        txt = T("\230\149\136\230\158\156\230\140\129\231\187\173:%d\229\164\169%d\230\151\182", d % 2, h % 24),
        size = 13,
        pos = ccp(70, 21),
        color = ed.toccc3(16770409),
        stroke = {
          ccc3(ed.colorToStr("#3a0806")),
          1.3
        },
        parent = bg,
        anchor = ccp(0, 0.5)
      })
      local actIcon = ed.createSpriteTools({
        res = "UI/alpha/1080P/activity/bubugaosheng/icon.png",
        pos = ccp(360 - newWid / 2, ed.display.winSize.height - 35 - newHei),
        parent = self.container
      })
      local actNamebg = ed.createSpriteTools({
        res = "UI/alpha/1080P/main/main_icon_name_bg.png",
        pos = ccp(38.75, -4),
        parent = actIcon
      })
      ed.createLabelTools({
        txt = T("\229\184\131\229\184\131\233\171\152\229\141\135"),
        size = 14,
        pos = ccp(38.75, 1),
        color = ed.toccc3(16776423),
        stroke = {
          ccc3(ed.colorToStr("#473f35")),
          1.3
        },
        parent = actIcon
      })
      actNamebg:setScaleX(1.8)
      self:btRegisterButtonClick({
        button = actIcon,
        key = "actNamebg",
        clickHandler = function()
          ed.UITool.openView("activityScene", {
            openActType = "dreamland_new_year"
          })
        end,
        force = true,
        clickInterval = 0.5,
        pressScale = 1.1
      })
      self:btRegisterButtonClick({
        button = bg,
        key = "BuffActivityLayer",
        clickHandler = function(event, x, y)
          ed.UITool.openView("showDictInfoPop", {
            index = 1,
            x = x,
            y = y,
            desc = ed.getDataTable("Skill")[skill["Skill 1 ID"]][0].Description
          })
        end,
        force = true,
        pressScale = 0.96
      })
      self.BuffActivityLayer = bg
    else
      print(" buffid = nil ")
    end
  end
end

function DreamlandScene:RefreshAppearance()
  local flag_boss_change = false
  if self.stage_id_buffer ~= self.dreamland:GetStage() then
    self.stage_id_buffer = self.dreamland:GetStage()
    self.config = dreamland.Config[self.stage_id_buffer]
    flag_boss_change = true
  end
  self:RefreshBossFca(flag_boss_change)
  self:RefreshBossName(flag_boss_change)
  self:RefreshTimeInfo(flag_boss_change)
  self:InitChanceInfo(flag_boss_change)
end

function DreamlandScene:InitTimeInfo()
  self.endTime = nil
  local ui = self.ui
  ui.layer_time_info:stopAllActions()
  if self.endTimeLabel then
    self.endTimeLabel:setString("")
  end
  local dreamland = self.dreamland
  local string_info = ""
  if dreamland:IsOpen() then
    local isLimit, level = ed.dreamland.mgr:isBossLimit()
    if isLimit then
      string_info = string.format(T("\231\173\137\231\186\167\232\190\190\229\136\176%d\232\167\163\233\148\129", level))
    else
      string_info = dreamland:GetEndTimeString()
      string_info = T("\230\182\136\229\164\177\229\128\146\232\174\161\230\151\182\239\188\154")
      local time_current = ed.getServerTime()
      self.endTime = time_current - dreamland.time_end
    end
  elseif dreamland:IsEnded() then
    string_info = T(self.config.name .. T("\229\183\178\231\187\143\230\182\136\229\164\177"))
  elseif dreamland:IsPrepare() then
    string_info = dreamland:GetStartTimeString()
    string_info = T("\233\153\141\228\184\180\229\128\146\232\174\161\230\151\182\239\188\154")
    local time_current = ed.getServerTime()
    self.endTime = time_current - dreamland.time_start
  end
  local label_info = ed.createLabelWithFontInfo(string_info, "dreamland_info")
  ui.layer_time_info:addChild(label_info, 1)
  label_info:setAnchorPoint(ccp(0.85, 0.5))
  if self.endTime and self.endTime > 0 then
    if not self.endTimeLabel then
      local label = ed.createttf("", 16)
      label:setPosition(ccp(40, 0))
      label:setColor(ccc3(ed.colorToStr("#70ff54")))
      label:setStroke(ccc3(13, 32, 14), 1)
      ui.layer_time_info:addChild(label)
      self.endTimeLabel = label
    end
    ui.layer_time_info:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCDelayTime:create(1),
      CCCallFunc:create(function()
        if self.endTime < 0 then
          ui.layer_time_info:stopAllActions()
        else
          local h, m, s = ed.second2hms(self.endTime)
          self.endTimeLabel:setString(h .. ":" .. m .. ":" .. s)
        end
        self.endTime = self.endTime - 1
      end)
    })))))
  end
  self.label_boss_info = label_info
end

function DreamlandScene:RefreshTimeInfo()
  self.endTime = nil
  local ui = self.ui
  ui.layer_time_info:stopAllActions()
  if self.endTimeLabel then
    self.endTimeLabel:setString("")
  end
  local dreamland = self.dreamland
  local string_info = ""
  if dreamland:IsOpen() then
    local isLimit, level = ed.dreamland.mgr:isBossLimit()
    if isLimit then
      string_info = string.format(T("\231\173\137\231\186\167\232\190\190\229\136\176%d\232\167\163\233\148\129", level))
    else
      string_info = dreamland:GetEndTimeString()
      string_info = T("\230\182\136\229\164\177\229\128\146\232\174\161\230\151\182\239\188\154")
      local time_current = ed.getServerTime()
      self.endTime = dreamland.time_end - time_current
    end
  elseif dreamland:IsEnded() then
    string_info = T(self.config.name .. T("\229\183\178\231\187\143\230\182\136\229\164\177"))
  elseif dreamland:IsPrepare() then
    string_info = dreamland:GetStartTimeString()
    string_info = T("\233\153\141\228\184\180\229\128\146\232\174\161\230\151\182\239\188\154")
    local time_current = ed.getServerTime()
    self.endTime = dreamland.time_start - time_current
  end
  if self.endTime and self.endTime > 0 then
    if not self.endTimeLabel then
      local label = ed.createttf("", 16)
      label:setPosition(ccp(40, 0))
      label:setColor(ccc3(ed.colorToStr("#70ff54")))
      label:setStroke(ccc3(13, 32, 14), 1)
      ui.layer_time_info:addChild(label)
      self.endTimeLabel = label
    end
    local h, m, s = ed.second2hms(self.endTime)
    self.endTimeLabel:setString(h .. ":" .. m .. ":" .. s)
    ui.layer_time_info:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCDelayTime:create(1),
      CCCallFunc:create(function()
        if self.endTime < 0 then
          ui.layer_time_info:stopAllActions()
        else
          local h, m, s = ed.second2hms(self.endTime)
          self.endTimeLabel:setString(h .. ":" .. m .. ":" .. s)
        end
        self.endTime = self.endTime - 1
      end)
    })))))
  end
  self.label_boss_info:setString(string_info)
end

function DreamlandScene:CreateBossFca()
  local layer = self.ui.layer_boss_fca
  local pos = self.ui.layer_boss_detail:getParent():convertToWorldSpace(ccp(self.ui.layer_boss_detail:getPosition()))
  pos.x = pos.x / 2
  pos = layer:getParent():convertToNodeSpace(pos)
  layer:setPositionX(pos.x + 50)
  local config = self.config
  local fca_res = config.fca
  local fca_name, actor
  local puppet_tbl_data = getDataTable("Puppet")[fca_res]
  if puppet_tbl_data and puppet_tbl_data.Resource then
    fca_name = puppet_tbl_data.Resource
    actor = createFcaActor(fca_name, config.scale)
    local comps = puppet_tbl_data["Change Components"]
    if comps and 0 < #comps then
      for i = 1, #comps, 2 do
        actor:setComponent(comps[i], comps[i + 1])
      end
    end
  else
    fca_name = string.gsub(fca_res, "%.cha$", "") or ""
    actor = createFcaActor(fca_name, config.scale)
  end
  actor:setScale(1.5)
  layer:addChild(actor, 10)
  self:addFca(actor)
  self.boss_actor = actor
  local action_name = config.action or "Idle"
  actor:setAction(action_name)
  actor:setLoop(true)
end

function DreamlandScene:RefreshBossFca(flag_boss_change)
  if self.boss_actor then
    self:removeFca(self.boss_actor)
    self.boss_actor = nil
    self.ui.layer_boss_fca:removeAllChildrenWithCleanup(true)
    if self.boss_bg_actor then
      self:removeFca(self.boss_bg_actor)
      self.boss_bg_actor = nil
    end
    self:CreateBossFca()
    local actor = self.boss_actor
    actor:tint(1, 1, 1)
    self:resumeFca(actor)
    local action_name = self.config.action or "Idle"
    actor:setAction(action_name)
    actor:setLoop(true)
  end
end

function DreamlandScene:CreateBossName(flag_boss_change)
  local layer = self.ui.layer_boss_name
  local config = self.config
  local nameLabel = ed.createttf(config.name or "", 24)
  nameLabel:setFontName(ed.fontBold)
  ed.setLabelColor(nameLabel, ed.toccc3(10026859))
  ed.setLabelStroke(nameLabel, ed.toccc3(2248760), 1)
  local nameBg = createSprite("UI/alpha/1080P/dreamland/dreamland_bossname_bg.png")
  nameBg:addChild(nameLabel)
  ed.layout.centerInParent(nameLabel)
  layer:addChild(nameBg)
  self.image_boss_name = nameBg
  local nameWidth = nameLabel:getContentSize().width
  if 150 < nameWidth then
    layer:setScale(150 / nameWidth)
  end
  halfWid = nameWidth * layer:getScaleX() * 0.5
  local oriX = layer:getPositionX()
  self.ui.image_bossName:setPositionX(oriX - halfWid - 25)
  self.ui.image_title_bg_Copy0:setPositionX(oriX + halfWid + 25)
end

function DreamlandScene:RefreshBossName(flag_boss_change)
  if flag_boss_change then
    self.image_boss_name:removeFromParentAndCleanup(true)
    self:CreateBossName()
  end
end

function DreamlandScene:InitChanceInfo()
  local ui = self.ui
  local dreamland = self.dreamland
  if not dreamland:IsOpen() then
    ui.layer_chance:setVisible(false)
    return
  end
  local chance = dreamland:GetChance()
  local colors = chance <= 0 and "dreamland_red" or "dreamland_white"
  local str = string.format("<text|%s|%s><text|dreamland_white|/><text|dreamland_white|%s>", colors, chance, 5)
  if not self.localRichtext then
    self.localRichtext = richText:new()
    ui.label_left_chance:addChild(self.localRichtext.rootNode)
    self.localRichtext.rootNode:setPositionY(self.localRichtext.rootNode:getPositionY() + 2)
  end
  self.localRichtext:setString(str)
  ui.chance_add_btn:setVisible(chance == 0)
  ui.label_left_chance:setPositionX(chance == 0 and 264.5 or 282)
  ui.label_left_chance_title:setPositionX(ui.label_left_chance:getPositionX() - ui.label_left_chance_title:getContentSize().width * 0.5)
  ui.label_left_chance_title_bg:setPositionX(chance == 0 and 228.5 or 234)
  self.descStrs = self.descStrs or {}
  self.descStrs.chance = str
end

function DreamlandScene:ShowRule()
  self:showRulePopWin()
end

function DreamlandScene:OpenShop()
  self:UnregisterEvents()
  ed.UITool.openView("shopMain", {page = 4})
end

function DreamlandScene:BossPressed()
  if self.dreamland:IsOpen() then
    if ed.dreamland.mgr:isBossLimit() then
      sefl:localDreamlandbossdetailwindow()
      return
    end
    self:DetailSceneCreate(self.dreamland)
  else
    self:localDreamlandbossdetailwindow()
  end
  self:btRegisterHandler({
    handler = function(event, x, y)
      self:BossSkillTouch(event, x, y)
    end,
    key = "dreamland_boss_skill_touch"
  })
  self:IsOpenDownWindShow()
end

function DreamlandScene:IsOpenDownWindShow()
  local vis = self.dreamland:IsOpen()
  self.ui.Panel_bg:setVisible(vis)
  self.ui.layer_chance:setVisible(vis)
  self.ui.image_interaction_bg:setVisible(vis)
  if vis then
    vis = self.dreamland:GetRank() > 0
    self.ui.layer_status:setVisible(vis)
    self.ui.image_no_status_bg:setVisible(not vis)
  else
    self.ui.layer_status:setVisible(false)
    self.ui.image_no_status_bg:setVisible(false)
  end
end

function DreamlandScene:OpenRankList()
  ed.UITool.openView("ranklist", {index = 4})
end

function DreamlandScene:BuyChance()
  if self.dreamland:CanBuyChance() then
    local priceTable = ed.getDataTable("GradientPrice")
    local cost = priceTable[self.dreamland:GetChanceBuyTimes() + 1]["Dreamland Buy"] or 50
    local info = {
      autoText = string.format(T("\230\152\175\229\144\166\232\166\129\232\138\177\232\180\185<sprite src=UI/alpha/1080P/icon/diamond.png><lable color=headlineOrange>%d</lable>\233\146\187\231\159\179\232\180\173\228\185\1765\230\172\161\230\140\145\230\136\152\230\156\186\228\188\154\239\188\159"), cost),
      leftText = T("\229\143\150\230\182\136"),
      rightHandler = function()
        if ed.player._rmb < cost then
          ed.showToast("\233\146\187\231\159\179\228\184\141\232\182\179\239\188\140\232\175\183\229\133\133\229\128\188")
        else
          FireEvent("DreamlandBuyChance")
        end
      end,
      rightText = T("\231\161\174\229\174\154"),
      mode = "simple",
      fontSize = 17
    }
    ed.showConfirmDialog(info)
  else
    ed.showToast("\228\187\138\230\151\165\229\183\178\232\190\190\230\140\145\230\136\152\230\172\161\230\149\176\228\184\138\233\153\144")
  end
end

function DreamlandScene:ChanceReset(times)
  local dreamland = self.dreamland
  local priceTable = ed.getDataTable("GradientPrice")
  local cost = priceTable[times]["Dreamland Buy"] or 50
  ed.player:subrmb(cost)
  dreamland:SetChanceBuyTimes(times)
  dreamland:ResetChance()
  self:InitChanceInfo()
end

function DreamlandScene:DreamlandStateChange(state)
  if self.dreamland:IsNone() then
    self:Return()
    return
  end
  self:RefreshAppearance()
end

function DreamlandScene:showSkillIcon()
  local stageSkills = self.dreamland:getStageSkills()
  self.stageSkills = stageSkills
  local fairPlaySkills = ed.dreamland.mgr:getFairPlayStageSkill()
  for i, v in ipairs(fairPlaySkills) do
    table.insert(self.stageSkills, v)
  end
  local skillIconList = {}
  for i, skill in ipairs(stageSkills) do
    local icon = ed.createSprite(skill.iconRes)
    self.ui.node_stage_skill:addChild(icon)
    icon:setPosition(ccp(i * 40 - 30, 0))
    icon:setScale(0.6)
    local mask = ed.createSprite("UI/alpha/1080P/skill/stage_skill_frame.png")
    self.ui.node_stage_skill:addChild(mask)
    mask:setPosition(ccp(i * 40 - 30, 0))
    skillIconList[i] = icon
  end
  self.skillIconList = skillIconList
end

function DreamlandScene:localDreamlandbossdetailwindow()
  ed.showToast(T("\230\182\136\230\129\175\230\143\144\231\164\186\239\188\154boss\228\187\139\231\187\141\229\146\140\230\138\128\232\131\189"), ccp(400, 430))
  self:InitBossDescription()
end

function DreamlandScene:DetailSceneCreate(data)
  self.dreamland = data
  self.detailConfig = dreamland.Config[data.stage_id]
  self:DetailInitAppearance()
  self:DetailRegisterTouchHandler()
  self:DetailInitMultiplayerEntrance()
end

function DreamlandScene:DetailRegisterTouchHandler()
  local ui = self.ui
  self:btRegisterHandler({
    handler = function(event, x, y)
      self:RewardHintTouch(event, x, y)
    end,
    key = "dreamland_reward_hint_touch"
  })
end

function DreamlandScene:DetailRegisterEvents()
end

function DreamlandScene:DetailOnEnter()
  self:DetailRegisterEvents()
  if self.dreamland:GetRank() > 0 then
    self.ui.layer_status:setVisible((self.dreamland:IsOpen()))
    self.ui.image_no_status_bg:setVisible(false)
    self:InitRankInfo()
    self:InitRewardInfo()
  else
    self.ui.layer_status:setVisible(false)
    self.ui.image_no_status_bg:setVisible((self.dreamland:IsOpen()))
  end
end

function DreamlandScene:DetailInitAppearance()
  self:InitBossDescription()
  if self.dreamland:GetRank() > 0 then
    self.ui.layer_status:setVisible(true)
    self.ui.image_no_status_bg:setVisible(false)
    self:InitRankInfo()
    self:InitRewardInfo()
  else
    self.ui.layer_status:setVisible(false)
    self.ui.image_no_status_bg:setVisible(true)
  end
end

local skill_icon_width = 75

function DreamlandScene:InitBossDescription()
  local ui = self.ui
  local skills_data = self.dreamland:GetBossSkillData()
  self.descStrs = self.descStrs or {}
  self.descStrs.skli = skills_data.desc
  local con = ui.layer_boss_skill:getContentSize()
  local label_boss_desc = ed.ui.autoText.new()
  local strs = "<lable color=ccc3(255,252,231) strokeColor=ccc3(13,32,14) strokeSize=1 >" .. skills_data.desc .. "</lable>"
  label_boss_desc:initParam({
    context = strs,
    fontSize = 14,
    lineSpacing = 5,
    maxWidth = con.width - 20
  })
  self.ui.layer_boss_detail:addChild(label_boss_desc.node)
  label_boss_desc.node:setPosition(ui.label_boss_desc:getPosition())
  label_boss_desc.node:setPositionY(label_boss_desc.node:getPositionY() - 10)
  skill_icon_width = 102
  local width = 372 + 372 * (ed.display.halfFixedWidth / 120) * 0.2
  local count = #skills_data.skills
  width = width / count
  local scales = width / skill_icon_width
  skill_icon_width = skill_icon_width * scales
  local posx = skill_icon_width / 2
  local layer = ui.layer_boss_skill
  self.boss_skills = {}
  for i, skill_data in ipairs(skills_data.skills) do
    local icon, bg = readhero.createSkillIcon(skills_data.unit_id, skill_data.skill_group_row.Slot)
    icon:setScale(1 < scales and 1 or scales)
    icon:setPosition(ccp(skill_icon_width * 0.84 * i - posx, 7))
    layer:addChild(icon)
    table.insert(self.boss_skills, {icon = icon, data = skill_data})
  end
  skill_icon_width = 93 < skill_icon_width and 93 or skill_icon_width
end

function DreamlandScene:CreateSkillPanel(skill_data, i)
  local panel = CCSprite:create()
  local panel_width = 350
  local capInsets = CCRectMake(60, 10, 2, 10)
  local panelBg = createScale9Sprite("UI/alpha/1080P/common/craft_promt_bg.png", capInsets)
  panelBg:setAnchorPoint(ccp(0, 0))
  panel:addChild(panelBg)
  panel:setAnchorPoint(ccp(0, 0))
  local skill_name = skill_data.skill_group_row["Display Name"] or ""
  local skill_desc = skill_data.skill_row.Description or ""
  local start_y, offset_x, margin_y = 30, 10, 10
  local label_desc = createLabelWithFontInfo(T(skill_desc), "skill_white")
  label_desc:setAnchorPoint(ccp(0, 0))
  label_desc:setPosition(ccp(offset_x, start_y))
  label_desc:setHorizontalAlignment(kCCTextAlignmentLeft)
  label_desc:limitSizeByScale(panel_width - offset_x * 2, 90, 0.01)
  panel:addChild(label_desc)
  local size = label_desc:getContentSize()
  size.width = size.width * label_desc:getScale()
  size.height = size.height * label_desc:getScale()
  local desc_height = size.height
  local label_name = createLabelWithFontInfo(T(skill_name), "title_yellow")
  label_name:setAnchorPoint(ccp(0, 0))
  label_name:setPosition(ccp(offset_x, start_y + desc_height + margin_y))
  label_name:setHorizontalAlignment(kCCTextAlignmentLeft)
  setLabelDimensions(label_name, CCSizeMake(panel_width - offset_x * 2, 0))
  panel:addChild(label_name)
  size = label_name:getContentSize()
  local name_height = size.height
  panelBg:setContentSize(CCSizeMake(panel_width, start_y + desc_height + margin_y + name_height + margin_y))
  return panel, panel_width + 268
end

function DreamlandScene:BossSkillTouch(event, x, y)
  if event == "began" then
    for i, skill in ipairs(self.boss_skills) do
      if containsPoint(skill.icon, x, y) and skill.icon:checkVisible() then
        playEffect(sound.stageDetail.clickReward)
        local panel, panel_width = self:CreateSkillPanel(skill.data, i)
        local x, y = skill.icon:getPosition()
        panel:setPosition(ccp(x + 40 - panel_width / 2, y + skill_icon_width / 2 - 5))
        self.skill_detail_panel = panel
        self.ui.layer_boss_skill:addChild(panel, 50)
        break
      end
    end
  elseif event == "ended" and self.skill_detail_panel then
    self.skill_detail_panel:removeFromParentAndCleanup(true)
    self.skill_detail_panel = nil
  end
end

local reward_icon_width = 40

function DreamlandScene:RewardHintTouch(event, x, y)
  if event == "began" then
    for i, item in ipairs(self.reward_items or {}) do
      if containsPoint(item.icon, x, y) and item.icon:checkVisible() then
        playEffect(sound.stageDetail.clickReward)
        local panel = readequip.getDetailCard(item.id, nil, {
          anchor = ccp(0.5, 0)
        })
        local x, y = item.icon:getPosition()
        panel:setPosition(ccp(x, y + reward_icon_width / 2))
        self.reward_detail_panel = panel
        self.ui.layer_reward_items:addChild(panel, 50)
        break
      end
    end
  elseif event == "ended" and self.reward_detail_panel then
    self.reward_detail_panel:removeFromParentAndCleanup(true)
    self.reward_detail_panel = nil
  end
end

function DreamlandScene:InitRankInfo()
  local ui = self.ui
  ui.label_damage_txt:setString(tostring(self.dreamland:GetTopDamage()))
  local rank = self.dreamland:GetRank()
  if rank > dreamland.rank_edge then
    ui.layer_rank_txt:setString("0")
  else
    ui.label_rank:setVisible(false)
    ui.layer_rank_txt:setString(tostring(self.dreamland:GetRank()))
  end
end

function DreamlandScene:InitRewardInfo()
  local reward_data = self.dreamland:GetRewardData()
  local reward_set = {}
  for i = 1, 7 do
    local reward_type = reward_data["Reward Type " .. i]
    if reward_type then
      local reward_amount = reward_data["Reward Amount " .. i]
      if 0 < reward_amount then
        table.insert(reward_set, {
          type = reward_type,
          amount = reward_amount,
          id = reward_data["Reward ID " .. i]
        })
      end
    end
  end
  self.reward_items = {}
  local layer = self.ui.layer_reward_items
  layer:removeAllChildrenWithCleanup(true)
  for i, reward in ipairs(reward_set) do
    local image_icon = ed.createItemIcon(reward)
    local id = ed.resToIconId[string.lower(reward.type)] or reward.id
    table.insert(self.reward_items, {icon = image_icon, id = id})
    image_icon:setScale(0.7)
    image_icon:setPosition(i * 65, 28.5)
    layer:addChild(image_icon, 5)
  end
  self.reward_set = reward_set
end

function DreamlandScene:EnterPrepare()
  if self.dreamland:GetChance() == 0 then
    ListenTimer(Timer:Once(0.1), function()
      self:BuyChance()
    end)
    return
  end
  local selectHeros
  if self.dreamland:getActivityOpen() then
    selectHeros = self:getLimitedHeros()
  end
  local stageId = self.dreamland:GetStage()
  local heroLimit = ed.dreamland.mgr:getStageLimit()
  pushScene(ui.battleprepare.create({
    mode = "dreamland",
    stage_id = stageId,
    hero_all_list = selectHeros,
    heroLimit = heroLimit,
    objData = {
      modTxt = self.config,
      monsSkil = self.descStrs
    }
  }))
end

function DreamlandScene:getLimitedHeros()
  local heroIds = self.dreamland:getAvailableHeroes()
  local heroGroups = {}
  for i, heroId in ipairs(heroIds) do
    heroGroups[heroId] = true
  end
  local allHeros = ed.player.heroes
  local selectHeros = {}
  for __, hero in pairs(allHeros) do
    if heroGroups[hero._tid] then
      table.insert(selectHeros, hero)
    end
  end
  return selectHeros
end

function DreamlandScene:DetailInitMultiplayerEntrance()
  self:createMultiplayerBtns()
end

function DreamlandScene:createMultiplayerBtns()
  local layer = self.ui.layer_chance
  self.entrance_layer = self.ui.layer_chance
  local btn1 = self:createMultiplayerBtn("UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png", T("\230\140\145\230\136\152"), function()
    ed.playEffect(ed.sound.deo.common_click_feedback)
    self:EnterPrepare()
  end)
  btn1:setPosition(ccp(240, 30))
  layer:addChild(btn1)
end

local btnIndex = 1

function DreamlandScene:createMultiplayerBtn(iconRes, text, callback)
  local btn = ed.createScale9Sprite("UI/alpha/1080P/common/button_a_butt.png", CCRectMake(20, 20, 20, 20))
  btn:setContentSize(CCSizeMake(146, 46))
  local icon = ed.createSprite(iconRes)
  icon:setPosition(ccp(40, 21))
  btn:addChild(icon)
  icon:setScale(0.7)
  local tt = ed.createttf(text, 22)
  tt:setColor(ccc3(247, 228, 153))
  tt:setAnchorPoint(ccp(0.5, 0.5))
  tt:setPosition(ccp(97, 22.5))
  btn:addChild(tt)
  self:btRegisterButtonClick({
    button = btn,
    key = "entrance_layer_" .. btnIndex,
    clickHandler = callback,
    force = true,
    clickInterval = 0.5,
    pressScale = 1.1
  })
  btnIndex = btnIndex + 1
  return btn
end

local strPageOne = T("\226\128\156\232\191\153\230\157\161\232\151\164\232\148\147\233\171\152\229\164\167\230\151\160\230\175\148\239\188\140\231\156\139\232\181\183\230\157\165\231\155\180\233\128\154\229\164\169\233\153\133\239\188\140\229\166\130\230\158\156\232\131\189\231\136\172\228\184\138\229\142\187\239\188\140\232\175\180\228\184\141\229\174\154\232\131\189\232\190\190\229\136\176\228\188\160\232\175\180\228\184\173\231\154\132\230\179\176\229\157\166\229\155\189\229\186\166\239\188\129\232\174\169\230\136\145\228\187\172\232\175\149\232\175\149\229\135\187\232\180\165\231\156\139\229\174\136\231\154\132\230\128\170\231\137\169......\231\179\159\231\179\149\239\188\140\228\187\150\228\187\172\232\175\165\228\184\141\228\188\154\230\152\175\230\176\184\231\148\159\231\154\132\229\144\167\239\188\159\226\128\157  <br/>") .. T("                                             \226\128\148\226\128\148\232\136\185\233\149\191\230\138\177\229\164\180\233\128\131\231\170\156\229\137\141\231\154\132\229\143\145\232\168\128<br/><br/><br/><br/><br/>") .. T(" <sprite src=UI/alpha/1080P/common/rivet_big.png>\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\176<lable color=summonRed>50\231\186\167</lable>\229\144\142\239\188\140\229\143\175\228\187\165\229\143\130\228\184\142\230\176\184\231\148\159\230\162\166\229\162\131\231\154\132\230\140\145\230\136\152\227\128\130<br/><br/>") .. T(" <sprite src=UI/alpha/1080P/common/rivet_big.png>\228\184\141\229\144\140\230\151\182\233\151\180\228\188\154\230\156\137\228\184\141\229\144\140\231\154\132\230\162\166\229\162\131\233\166\150\233\162\134\231\156\139\229\174\136\239\188\140\233\156\128\230\160\185\230\141\174\233\166\150\233\162\134\231\177\187\229\158\139\229\134\179\229\174\154\230\140\145\230\136\152\233\152\181\229\174\185\227\128\130<br/><br/>") .. T(" <sprite src=UI/alpha/1080P/common/rivet_big.png>\230\162\166\229\162\131\233\166\150\233\162\134<lable color=summonRed>\230\175\143\229\164\177\229\142\187\228\184\128\229\174\154\232\161\128\233\135\143\239\188\140\229\176\177\228\188\154\232\142\183\229\190\151\228\184\128\229\177\130\231\139\130\230\128\146\231\138\182\230\128\129</lable>\239\188\140\232\175\183\229\176\143\229\191\131\229\186\148\229\175\185\227\128\130<br/>")
local strPageTwo = T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\162\166\229\162\131\233\166\150\233\162\134\231\142\176\232\186\171\229\144\142\239\188\140\230\175\143\228\186\186\229\156\168\230\180\187\229\138\168\229\189\147\229\164\169\230\156\137<lable color=summonRed>5\230\172\161</lable>\229\133\141\232\180\185\230\140\145\230\136\152\230\156\186\228\188\154\239\188\140\229\176\134\230\140\137\231\133\167\229\189\147\230\151\165\230\137\128\233\128\160\230\136\144\231\154\132\230\156\128\233\171\152\228\188\164\229\174\179\232\174\161\229\133\165\228\184\170\228\186\186\230\142\146\232\161\140\230\166\156\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\230\162\166\229\162\131\233\166\150\233\162\134\229\176\134\228\186\142\231\142\176\232\186\171\229\189\147\230\151\165\231\154\132\230\153\15422\231\130\185\230\182\136\229\164\177\239\188\140\229\177\138\230\151\182\229\176\134\230\140\137\231\133\167\231\142\169\229\174\182\228\184\170\228\186\186\230\156\128\233\171\152\228\188\164\229\174\179\230\142\146\229\144\141\239\188\140\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\233\128\129\230\162\166\228\185\139\230\150\176\229\143\182\231\173\137\229\165\150\229\138\177\227\128\130<lable color=summonRed>\230\162\166\228\185\139\230\150\176\229\143\182\229\143\175\231\148\168\228\186\142\229\156\168\230\162\166\229\162\131\229\149\134\229\186\151\228\184\173\229\133\145\230\141\162\229\165\150\229\138\177</lable>\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\229\176\134\230\160\185\230\141\174\229\133\172\228\188\154\230\136\144\229\145\152\229\175\185\230\162\166\229\162\131\233\166\150\233\162\134\230\137\128\233\128\160\230\136\144\230\156\128\233\171\152\228\188\164\229\174\179\228\185\139\230\128\187\229\146\140\239\188\140\232\191\155\232\161\140\230\176\184\231\148\159\230\162\166\229\162\131\229\133\172\228\188\154\230\142\146\229\144\141\227\128\130<br/><br/>") .. T("<sprite src=UI/alpha/1080P/common/rivet_big.png>\233\166\150\233\162\134\230\182\136\229\164\177\229\144\142\239\188\140\229\176\134\230\160\185\230\141\174\229\133\172\228\188\154\230\142\146\229\144\141\239\188\140\229\144\145\229\133\172\228\188\154\231\142\169\229\174\182\229\143\145\230\148\190\230\162\166\228\185\139\230\150\176\229\143\182\227\128\130\229\189\147\230\151\165\230\156\170\229\143\130\229\138\160\230\162\166\229\162\131\230\140\145\230\136\152\231\154\132\231\142\169\229\174\182\230\151\160\230\179\149\232\142\183\229\190\151\232\175\165\229\165\150\229\138\177\227\128\130<br/>")

function DreamlandScene:showRulePopWin()
  if not self.ruleContainer then
    local function labelFunc(isRig)
      self.labelTwo:runAction(CCFadeTo:create(isRig and 0.1 or 0.4, isRig and 0 or 255))
      
      self.labelOne:runAction(CCFadeTo:create(isRig and 0.4 or 0.1, isRig and 255 or 0))
      local posx, posy = self.labelOne:getPosition()
      self.labelOne:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(isRig and posx + 100 or posx - 100, posy))))
      local posx, posy = self.labelTwo:getPosition()
      self.labelTwo:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(isRig and posx + 100 or posx - 100, posy))))
      self.ruleContainer.ui.ImageView_692:setPositionX(isRig and self.lineLeftPosX1 or self.lineLeftPosX2)
      self.ruleContainer.ui.ImageView_692_Copy0:setPositionX(isRig and self.lineRightPosX1 or self.lineRightPosX2)
    end
    
    local container = CCLayerColor:create(ccc4(0, 0, 0, 70))
    container:registerScriptTouchHandler(function(event, x, y)
      xpcall(function()
        if self.ruleContainer and self.ruleContainer:isVisible() then
          if self.noTonch then
            self.newTouPosX = nil
            self.newTouPosY = nil
            self.pressArrow = nil
            return
          end
          if event == "began" then
            self.newTouPosX = nil
            self.newTouPosY = nil
            self.pressArrow = nil
            if self.ruleContainer.ui.arrow_left:isVisible() and ed.containsPoint(self.ruleContainer.ui.arrow_left, x, y) then
              self.ruleContainer.ui.arrow_left:setScale(0.9)
              self.pressArrow = self.ruleContainer.ui.arrow_left
            elseif self.ruleContainer.ui.arrow_right:isVisible() and ed.containsPoint(self.ruleContainer.ui.arrow_right, x, y) then
              self.ruleContainer.ui.arrow_right:setScale(0.9)
              self.pressArrow = self.ruleContainer.ui.arrow_right
            elseif ed.containsPoint(self.ruleContainer.ui.panel_touch, x, y) then
              self.newTouPosX = x
              self.newTouPosY = y
              self.layPosX, self.layPosY = self.movelayer:getPosition()
            end
          elseif event == "ended" then
            if self.pressArrow then
              self.pressArrow:setScale(1)
              local layPosX = self.movelayer:getPositionX()
              self.movelayer:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(layPosX ~= 0 and 0 or -600, 0))))
              self.ruleContainer.ui.arrow_right:setVisible(layPosX ~= 0)
              self.ruleContainer.ui.arrow_left:setVisible(layPosX == 0)
              self.point:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(self.pointPos[layPosX ~= 0 and 1 or 2]:getPosition()))))
              labelFunc(layPosX ~= 0)
            elseif self.newTouPosX then
              local newX = self.newTouPosX - x
              if math.abs(newX) > 100 then
                if self.point:getPositionX() ~= self.pointPos[newX < 0 and 1 or 2]:getPositionX() then
                  labelFunc(newX < 0)
                end
                local curIndex = newX < 0 and 1 or 2
                self.point:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(self.pointPos[curIndex]:getPosition()))))
                local posY = ed.clamp(self.movelayer:getPositionY(), self.minPosY, self.maxPosYArr[curIndex])
                self.movelayer:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(newX < 0 and 0 or -600, posY))))
                self.ruleContainer.ui.arrow_left:setVisible(not (newX < 0))
                self.ruleContainer.ui.arrow_right:setVisible(newX < 0)
              else
                local curIndex = 1
                for i, v in ipairs(self.pointPos) do
                  if self.point:getPositionX() < v:getPositionX() + 1 then
                    curIndex = i
                    break
                  end
                end
                local posY = ed.clamp(self.movelayer:getPositionY(), self.minPosY, self.maxPosYArr[curIndex])
                self.movelayer:runAction(CCEaseBackOut:create(CCMoveTo:create(0.3, ccp(self.layPosX, posY))))
              end
              self.noTonch = true
              self.ruleContainer.ui.Image_bg:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.31), CCCallFunc:create(function()
                self.noTonch = false
              end))))
            elseif not ed.containsPoint(self.ruleContainer.ui.panel_touch, x, y) then
              self:closeRulePopwin()
            end
          elseif event == "moved" and self.newTouPosX then
            local posx = self.layPosX - (self.newTouPosX - x)
            if posx < -600 then
              posx = -600 - math.abs(posx + 600) / 10
            elseif 0 < posx then
              posx = posx / 10
            end
            local posY = self.layPosY - (self.newTouPosY - y)
            local curIndex = 1
            for i, v in ipairs(self.pointPos) do
              if self.point:getPositionX() < v:getPositionX() + 1 then
                curIndex = i
                break
              end
            end
            if posY < self.minPosY then
              posY = self.minPosY - math.abs(posY - self.minPosY) / 10
            elseif posY > self.maxPosYArr[curIndex] then
              posY = self.maxPosYArr[curIndex] + math.abs(posY - self.maxPosYArr[curIndex]) / 10
            end
            self.movelayer:setPosition(posx, posY)
          end
        end
      end, EDDebug)
      return true
    end, false, -999, true)
    self.mainLayer:addChild(container, 999)
    self.ruleContainer = container
    local containerSca = CCLayer:create()
    container:addChild(containerSca, 999)
    self.ruleContainer.sca = containerSca
    local widhtWin = ed.display.winSize.width
    local heightWin = ed.display.winSize.height
    local newWid = ed.display.halfFixedWidth
    local newHei = ed.display.halfFixedHeight
    local ui = {}
    container:setPosition(-newWid, -newHei)
    local readnode = ed.readnode.create(containerSca, ui)
    readnode:addNode(ed.uieditor.summonRuleTips)
    self.ruleContainer.ui = ui
    ui.Label_699:setVisible(false)
    ui.panel_win:setVisible(false)
    ui.panel_clipping:setVisible(false)
    ui.Image_bg:setPosition(widhtWin / 2, heightWin / 2)
    local posx, posy = ui.panel_touch:getPosition()
    ui.panel_touch:setPosition(posx + newWid, posy + newHei)
    local clipLayer = CCLayer:create()
    ui.Image_bg:addChild(clipLayer)
    clipLayer:setClipRect(CCRectMake(8, 10, ui.Image_bg:getContentSize().width - 16, ui.Image_bg:getContentSize().height - 50))
    local movelay = CCLayer:create()
    clipLayer:addChild(movelay, 999)
    local maxWidth = ui.Image_bg:getContentSize().width - 40
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = strPageOne,
      fontSize = 16,
      lineSpacing = 4,
      maxWidth = maxWidth
    })
    movelay:addChild(autoText.node)
    local _, height = autoText:getCurContentSize()
    self.minPosY = 0
    self.maxPosYArr = {}
    table.insert(self.maxPosYArr, math.max(self.minPosY, height - (ui.Image_bg:getContentSize().height - 50 + 10)))
    autoText.node:setPosition(20, ui.Image_bg:getContentSize().height - 50 + 10 - autoText:getFirstLineHeight() * 0.5)
    local autoText = ed.ui.autoText.new()
    autoText:initParam({
      context = strPageTwo,
      fontSize = 16,
      lineSpacing = 4,
      maxWidth = maxWidth
    })
    movelay:addChild(autoText.node)
    local _, height = autoText:getCurContentSize()
    table.insert(self.maxPosYArr, math.max(self.minPosY, height - (ui.Image_bg:getContentSize().height - 50 + 10)))
    autoText.node:setPosition(620, ui.Image_bg:getContentSize().height - 50 + 10 - autoText:getFirstLineHeight() * 0.5)
    self.bugTextVis = autoText.node
    local clipLayer = CCLayer:create()
    ui.Image_bg:addChild(clipLayer)
    clipLayer:setClipRect(CCRectMake(140, ui.Image_bg:getContentSize().height - 50, 330, 70))
    local label = ed.createttf(T("\230\140\145\230\136\152\230\162\166\229\162\131"), 18)
    label:setPosition(ccp(300, ui.Image_bg:getContentSize().height - 25))
    label:setColor(ccc3(249, 210, 102))
    clipLayer:addChild(label)
    local deltaPos = 0.5 * (label:getContentSize().width + ui.ImageView_692:getContentSize().width) + 10
    self.lineLeftPosX1 = ui.Label_699:getPositionX() - deltaPos
    self.lineRightPosX1 = ui.Label_699:getPositionX() + deltaPos
    self.labelOne = label
    local label = ed.createttf(T("\230\140\145\230\136\152\229\146\140\229\165\150\229\138\177"), 18)
    label:setPosition(ccp(402, ui.Image_bg:getContentSize().height - 25))
    label:setColor(ccc3(249, 210, 102))
    clipLayer:addChild(label)
    deltaPos = 0.5 * (label:getContentSize().width + ui.ImageView_692_Copy0:getContentSize().width) + 10
    self.lineLeftPosX2 = ui.Label_699:getPositionX() - deltaPos
    self.lineRightPosX2 = ui.Label_699:getPositionX() + deltaPos
    self.labelTwo = label
    label:setOpacity(0)
    self.movelayer = movelay
    self.pointPos = {}
    for i = 1, 2 do
      local point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_1.png")
      point:setPosition(272 + i * 20, 15)
      ui.Image_bg:addChild(point)
      self.pointPos[i] = point
    end
    self.point = ed.createSprite("UI/alpha/1080P/common/icon_rule_point_2.png")
    self.point:setPosition(292, 15)
    ui.Image_bg:addChild(self.point)
    ui.arrow_right:setVisible(true)
    ui.panel_touch:runAction(CCRepeatForever:create(CCSequence:create(ccArrayMake(unpack({
      CCDelayTime:create(1),
      CCCallFunc:create(function()
        ui.arrow_left:runAction(CCFadeTo:create(0.9, 255 - ui.arrow_left:getOpacity()))
        ui.arrow_right:runAction(CCFadeTo:create(0.9, 255 - ui.arrow_right:getOpacity()))
      end)
    })))))
    ui.ImageView_692:setPositionX(self.lineLeftPosX1)
    ui.ImageView_692_Copy0:setPositionX(self.lineRightPosX1)
  end
  if 0 <= self.movelayer:getPositionX() then
    self.bugTextVis:setVisible(false)
    self.bugTextVis:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(0.3), CCCallFunc:create(function()
      self.bugTextVis:setVisible(true)
    end))))
  end
  self.ruleContainer.sca:setScale(0)
  self.ruleContainer:setVisible(true)
  self.ruleContainer:setTouchEnabled(true)
  local s = CCScaleTo:create(0.2, 1)
  s = CCEaseBackOut:create(s)
  self.ruleContainer.sca:runAction(s)
end

function DreamlandScene:closeRulePopwin()
  if self.ruleContainer then
    if self.movelayer and self.movelayer:getPositionX() >= 0 then
      self.bugTextVis:setVisible(false)
    end
    local s = CCScaleTo:create(0.2, 0)
    s = CCEaseBackIn:create(s)
    local f = CCCallFunc:create(function()
      xpcall(function()
        self.ruleContainer:setVisible(false)
        self.ruleContainer:setTouchEnabled(false)
      end, EDDebug)
    end)
    s = CCSequence:createWithTwoActions(s, f)
    self.ruleContainer.sca:runAction(s)
  end
end
