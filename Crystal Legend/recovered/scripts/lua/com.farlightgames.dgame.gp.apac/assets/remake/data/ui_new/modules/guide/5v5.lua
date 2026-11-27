local registerListeners, unregisterListeners

local function start5v5()
  registerListeners()
  ed.srand(1)
  local left = {
    {_tid = 1, _level = 70},
    {_tid = 30, _level = 70},
    {_tid = 12, _level = 70},
    {_tid = 4, _level = 70},
    {_tid = 10, _level = 70}
  }
  local right = {
    {_tid = 28, _level = 70},
    {_tid = 16, _level = 70},
    {_tid = 25, _level = 70},
    {_tid = 7, _level = 70},
    {_tid = 17, _level = 70}
  }
  local stage = ed.lookupDataTable("Stage", nil, -2)
  local battle = ed.lookupDataTable("Battle", nil, -2, 1)
  ed.engine:enterStage(stage, left, true)
  local Coco = ed.engine:findHero("Coco")
  Coco.config.hp_mod = 20
  Coco:rebuild()
  Coco.hp = Coco.attribs.HP
  Coco.ai.will_cast_manual_skill = false
  local skill = Coco.skills.Coco_atk2
  skill.info["Plus Ratio"] = 2
  local ES = ed.engine:findHero("ES")
  ES.config.hp_mod = 3
  ES:rebuild()
  ES.hp = ES.attribs.HP
  ES.mp = 750
  ES.ai.will_cast_manual_skill = false
  local ESskill = ES.skills.ES_atk3
  ESskill.cd_remaining = 30
  local CM = ed.engine:findHero("CM")
  CM.config.hp_mod = 3
  CM.config.dps_mod = 0.5
  CM:rebuild()
  CM.hp = CM.attribs.HP
  CM.mp = 560
  CM.ai.will_cast_manual_skill = false
  skill = CM.skills.CM_atk2
  skill.info.CD = 24
  CM.aura_skill_list = {}
  CM.effect_enemy_aura_skill_list = {}
  local Zeus = ed.engine:findHero("Zeus")
  Zeus.config.hp_mod = 2.5
  Zeus.config.dps_mod = 2
  Zeus:rebuild()
  Zeus.hp = Zeus.attribs.HP
  Zeus.mp = 300
  Zeus.ai.will_cast_manual_skill = false
  Zeus.skills.Zeus_atk3.info.CD = 24
  local skill = Zeus.skills.Zeus_ult
  skill.info["Plus Ratio"] = 8
  local Sniper = ed.engine:findHero("Sniper")
  Sniper.config.hp_mod = 3
  Sniper.config.dps_mod = 1
  Sniper:rebuild()
  Sniper.hp = Sniper.attribs.HP
  Sniper.mp = 550
  skill = Sniper.skills.Sniper_ult
  skill.info["Plus Ratio"] = 5
  skill.info["Target Type"] = "farthest"
  Sniper.ai.will_cast_manual_skill = false
  local Axe = ed.engine:findMonster("Axe")
  Axe.config.hp_mod = 6.5
  Axe:rebuild()
  Axe.hp = Axe.attribs.HP
  Axe.mp = 1000
  skill = Axe.skills.Axe_ult
  skill.info["Target Type"] = "weakest"
  skill.info["Plus Ratio"] = 2
  Axe.skills.Axe_atk2.cd_remaining = 30
  local Med = ed.engine:findMonster("Med")
  Med.config.hp_mod = 4
  Med.config.dps_mod = 3
  Med:rebuild()
  Med.hp = Med.attribs.HP
  Med.mp = 0
  Med.skills.Med_ult.info["Plus Ratio"] = 1.5
  local SF = ed.engine:findMonster("SF")
  SF.config.hp_mod = 7
  SF.config.dps_mod = 1.2
  SF:rebuild()
  SF.hp = SF.attribs.HP
  skill = SF.skills.SF_ult
  skill.info["Plus Ratio"] = 1.5
  local QOP = ed.engine:findMonster("QOP")
  QOP.config.hp_mod = 5
  QOP.config.dps_mod = 2
  QOP:rebuild()
  QOP.mp = 0
  QOP.hp = QOP.attribs.HP
  local skill = QOP.skills.QOP_ult
  local skill3 = QOP.skills.QOP_atk3
  skill.info["Plus Ratio"] = 1
  skill3.cd_remaining = 25
  local Bone = ed.engine:findMonster("Bone")
  Bone.config.hp_mod = 3
  Bone:rebuild()
  Bone.hp = Bone.attribs.HP
  local isClickJump = false
  if ed.gm_mod then
    function ed.sceneui.jumpBtnTapHandler()
      xpcall(function()
        if not isClickJump then
          isClickJump = true
          
          unregisterListeners()
          ed.guide.manager:skipAllGuide()
          ed.engine:resetBattle()
          ed.engine.running = false
          ed.replaceScene(ed.ui.mainScene.create())
        end
      end, EDDebug)
    end
  end
  ed.scene:reset(stage, battle)
  ed.pushScene(ed.scene)
  ed.scene:setSpeedRate(1)
  ed.scene.auto_combat = false
  ed.sceneui.ui.speedButtonBg:setVisible(false)
  ed.sceneui.pause_btn:setVisible(false)
  ed.sceneui.auto_btn:setVisible(false)
  ed.sceneui.auto_btn:setEnabled(false)
  ed.sceneui:showBattleStage(false)
  ed.sceneui.goldmarker:setVisible(false)
  ed.sceneui.lootmarker:setVisible(false)
  if ed.debug_mode then
    ed.sceneui:showJumpButton()
  end
end

ed.start5v5 = start5v5

local function onSkillReady(unit)
  if ed.engine.wave_id == 1 then
    ed.scene:pauseBattle("5v5skill")
    ed.showStory("_5v5" .. unit.name)
  end
end

local function onSkillTouch(unit)
  if ed.engine.wave_id == 1 then
    ed.scene:resumeBattle("5v5skill")
  end
end

local function opening(stage, wave)
  if stage == -2 and ed.engine.wave_id == 1 then
    ed.showStory("_5v5Opening")
  end
  if stage == -2 and ed.engine.wave_id == 2 then
    ed.showStory("_5v5Opening_2")
  end
end

local count = 0
local counts = 0

local function unitDie(unit, killer)
  if unit.camp ~= ed.emCampPlayer and ed.engine.wave_id == 1 then
    count = count + 1
    if count == 5 then
      ed.showStory("_5v5Ending")
    end
  end
  if unit.camp == ed.emCampPlayer and ed.engine.wave_id == 2 then
    counts = counts + 1
    if counts == 4 then
      ed.showStory("_5v5newEnding")
      ed.scene:pauseBattle("5v5newEnding")
    end
  end
end

local function storyEnd(storyname)
  if storyname == "_5v5newEnding" then
    ed.engine.enabled = false
    ed.engine.running = false
    ed.reportHUE({
      action_type = "finish_guide_battle"
    })
    ed.replaceScene(ed.ui.mainScene.create({ps = "5v5"}))
    unregisterListeners()
  elseif storyname == "_5v5Ending" then
    FireEvent(ed.guide.eventNames.NEXT_WAVE)
  elseif string.match(storyname, "^_5v5") then
    local name = string.gsub(storyname, "^_5v5", "")
    local hero = ed.engine:findHero(name)
    if name and hero then
      FireEvent(ed.guide.eventNames.USE_SKILL_5V5, name)
    end
  end
end

local function SDKLogOut()
  local text = T("\230\179\168\233\148\128\230\136\144\229\138\159\239\188\140\232\175\183\233\135\141\230\150\176\229\144\175\229\138\168\230\184\184\230\136\143")
  local info = {
    text = text,
    buttonText = T("\231\161\174\229\174\154"),
    handler = function()
      xpcall(function()
        EDExit()
      end, EDDebug)
    end
  }
  ed.SDKLogouted = true
  ed.showAlertDialog(info)
end

function registerListeners()
  ListenEvent("ult_skill_ready", onSkillReady)
  ListenEvent("ult_skill_touch", onSkillTouch)
  ListenEvent("EnterBattleStage", opening)
  ListenEvent("UnitDieDelay", unitDie)
  ListenEvent("StoryEnd", storyEnd)
  ListenEvent("SDKLogOut", SDKLogOut)
end

function unregisterListeners()
  StopListenEvent("ult_skill_ready", onSkillReady)
  StopListenEvent("ult_skill_touch", onSkillTouch)
  StopListenEvent("EnterBattleStage", opening)
  StopListenEvent("UnitDieDelay", unitDie)
  StopListenEvent("StoryEnd", storyEnd)
  StopListenEvent("SDKLogOut", SDKLogOut)
end
