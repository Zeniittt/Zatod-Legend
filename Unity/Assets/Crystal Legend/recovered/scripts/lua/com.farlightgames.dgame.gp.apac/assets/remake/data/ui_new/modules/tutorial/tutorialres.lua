local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.tutorialres = class
class.default_drag_range = 7
local t_keys = {
  FTintoMain = {id = 1},
  FTBronzeOpen = {id = 2},
  FTBronzeOne = {
    id = 3,
    pre = "FTBronzeOpen"
  },
  FTBronzeClose = {
    id = 4,
    pre = "FTBronzeOne"
  },
  _NOT_SET_1 = {id = 5},
  _NOT_SET_2 = {id = 6},
  _NOT_SET_3 = {id = 7},
  FTGoldOpen = {
    id = 8,
    pre = "FTBronzeClose"
  },
  FTGoldOne = {id = 9, pre = "FTGoldOpen"},
  FTGoldClose = {id = 10, pre = "FTGoldOne"},
  FTbackToMain = {
    id = 11,
    pre = "FTGoldClose"
  },
  gotoSelectStage = {
    id = 12,
    pre = "FTbackToMain"
  },
  selectStage = {
    id = 13,
    pre = "gotoSelectStage"
  },
  gotoPrepare = {
    id = 14,
    pre = "selectStage"
  },
  selectHero = {
    id = 15,
    pre = "gotoPrepare"
  },
  gotoBattle = {id = 16, pre = "selectHero"},
  clickNextStage = {id = 17},
  openShortcutToEquip = {
    id = 18,
    pre = "clickNextStage"
  },
  gotoEquipProp = {
    id = 19,
    pre = "clickNextStage",
    addition = {
      "openShortcutToEquip"
    }
  },
  gotoHeroDetailToEquip = {
    id = 20,
    pre = "gotoEquipProp"
  },
  canEquipProp = {
    id = 21,
    pre = "gotoHeroDetailToEquip"
  },
  equipProp = {
    id = 22,
    pre = "canEquipProp"
  },
  closeHeroDetail = {id = 23, pre = "equipProp"},
  backToStageSelect = {
    id = 24,
    pre = "closeHeroDetail"
  },
  firstTaskOpenShortcut = {id = 25},
  firstTaskOpenTaskWindow = {
    id = 26,
    addition = {
      "firstTaskOpenShortcut"
    }
  },
  firstTaskClickComplete = {
    id = 27,
    pre = "firstTaskOpenTaskWindow"
  },
  firstTaskClickok = {
    id = 28,
    pre = "firstTaskClickComplete"
  },
  firstTaskClickClose = {
    id = 29,
    pre = "firstTaskClickok"
  },
  SHopenShortcut = {id = 30},
  SHclickHeroPackage = {
    id = 31,
    addition = {
      "SHopenShortcut"
    }
  },
  SHclickHero = {
    id = 32,
    pre = "SHclickHeroPackage"
  },
  SHclickok = {
    id = 33,
    pre = "SHclickHero"
  },
  EEclickHero = {id = 34},
  EEselectHero = {
    id = 35,
    pre = "EEclickHero"
  },
  EEclickEquip = {
    id = 36,
    pre = "EEselectHero"
  },
  EEopenMaterial = {
    id = 37,
    pre = "EEclickEquip"
  },
  EEclickMaterial = {
    id = 38,
    pre = "EEopenMaterial"
  },
  EEclickEnhance = {
    id = 39,
    pre = "EEclickMaterial"
  },
  clickEliteModeButton = {id = 40},
  openShop = {id = 41},
  openSpecialShop = {id = 42},
  openSoSpecialShop = {id = 43},
  openSkillUpgrade = {id = 44},
  openpvp = {id = 45},
  openMidas = {id = 46},
  opencot = {id = 47},
  openEnhance = {id = 48},
  openExercise = {id = 49},
  unlockEliteMode = {id = 50},
  unlockShop = {id = 51},
  unlockSpecialShop = {id = 52},
  unlockSoSpecialShop = {id = 53},
  unlockSkillUpgrade = {id = 54},
  unlockpvp = {id = 55},
  unlockMidas = {id = 56},
  unlockcot = {id = 57},
  unlockEnhance = {id = 58},
  unlockExercise = {id = 59},
  equipSuccess = {id = 60},
  aboutHandbook = {id = 61},
  aboutShop = {id = 62},
  aboutSpecialShop = {id = 63},
  aboutSkillUpgrade = {id = 64},
  aboutSkillHeroPackage = {id = 65},
  SUopenShortcut = {id = 66},
  SUclickHeroPackage = {id = 67},
  SUclickHero = {
    id = 68,
    pre = "SUclickHeroPackage",
    addition = {
      "SUopenShortcut"
    }
  },
  SUclickSkillButton = {
    id = 69,
    pre = "SUclickHero"
  },
  SUclickLevelup = {
    id = 70,
    pre = "SUclickSkillButton"
  },
  SUcomplete = {id = 71},
  composeFragment = {id = 72},
  autoBattle = {id = 73},
  useSkill = {id = 74, pre = "FTintoMain"},
  canCraftProp = {id = 75},
  heroUpgrade = {id = 76},
  heroEvolve = {id = 77},
  refreshShop = {id = 78},
  nextWave = {id = 79},
  addHeroToTeam = {id = 80},
  heroExpMax = {id = 81},
  _5v5UseSkill = {id = 82},
  _5v5Anim = {id = 83},
  gotoTavernEnch = {id = 84},
  openTavernEnch = {
    id = 85,
    pre = "gotoTavernEnch"
  },
  tavernEnch = {
    id = 86,
    pre = "openTavernEnch",
    addition = {
      "gotoTavernEnch",
      "openTavernEnch"
    }
  },
  unlockCrusade = {id = 87},
  firstMercenary = {id = 88},
  unlockGuild = {id = 89},
  unlockWorldChannel = {id = 90},
  unlockExcavate = {id = 91},
  unlockStarShop = {id = 92},
  openExcavate = {id = 93},
  openStarshop = {id = 94},
  clickExcavatePoint2 = {id = 95},
  clickExcavatePoint3 = {id = 96},
  showMagicTavernExplain = {id = 97},
  openAwake = {id = 98},
  unlockAwake = {id = 99},
  FTchooseExcavate = {id = 100},
  unlockSpring = {id = 101},
  openSpring = {id = 102},
  openTopPvp = {id = 103},
  unlockTopPvp = {id = 104},
  unlockAncients = {id = 105},
  openAncients = {id = 106},
  ancientsQuit = {id = 107},
  SFStageFailedExit = {id = 108},
  SFOpenShortcut = {id = 109},
  SFOpenHeroPackage = {id = 110},
  SFSelectHero = {id = 111},
  SFSelectEquip = {id = 112},
  SFCheckDrop = {id = 113},
  SFSelectStage = {id = 114},
  unlockThroneTower = {id = 115},
  openThroneTower = {id = 116},
  unlockActivitySweep = {id = 117},
  unlockStageSweep = {id = 118},
  openCrusade = {id = 119},
  unlockWarschool = {id = 120},
  openRealArena = {id = 121},
  unlockRealArena = {id = 122},
  unlockWarTerritory = {id = 123},
  openWarTerritory = {id = 124},
  openWarDecompose = {id = 125},
  openWarMake = {id = 126},
  openWarCollege = {id = 127},
  WSClickIcon = {id = 128},
  WSClickUpgrade = {id = 129},
  WDClickConfirm = {id = 130},
  unlockChallengeMod = {id = 131},
  GCWClickAttack = {id = 132},
  GCWClickAssist = {id = 133},
  unlockRankFastUpgrade = {id = 134},
  openMonsterseal = {id = 135},
  WRClickLeft = {id = 136},
  WRClickDiamond = {id = 137},
  WRClickWood = {id = 138},
  warresourceEnd = {id = 139},
  UPGradeLack = {id = 140},
  PlayoffsClick = {id = 141},
  openArtifact = {id = 142},
  ArtifactMode = {id = 143},
  openSpecialMailbox = {id = 144},
  readSpecialMail = {id = 145},
  getSpecialEquipInMail = {id = 146},
  openConfigureSet = {id = 147},
  openMedalSet = {id = 148},
  selectTowerHero = {id = 149},
  placeTowerHero = {id = 150},
  EEselectBranch = {id = 151},
  EEselectBranch2 = {id = 152},
  EEselectOneKeyResolveRune = {id = 153},
  unlockBabel = {id = 154},
  openBabel = {id = 155},
  tryOnFashion = {id = 156},
  openOfflineQuest = {id = 157},
  dispatchOfflineQuest = {id = 158},
  unlockLegendArena = {id = 154},
  openLegendArena = {id = 155},
  cookSelectTalent1 = {id = 159},
  cookSelectTalent2 = {id = 160},
  cookSelectTalent3 = {id = 161},
  openHerorecommend = {id = 162},
  unlockPetHouse1 = {id = 163},
  unlockPetHouse2 = {id = 164},
  openHomePage1 = {id = 165},
  openHomePage2 = {id = 166},
  openHomePage3 = {id = 167},
  openHomePage4 = {id = 168},
  voideplayer1 = {id = 169},
  voideplayer2 = {id = 170},
  openTitanAltar = {id = 171},
  openTarot = {id = 172},
  unlockDiamondShop = {id = 173},
  selectTavern = {id = 174},
  arcanaTeach = {id = 175},
  arcanaHeroPackageTeach = {id = 176},
  arcanaHeroDetailTeach = {id = 177},
  arcanaTrialLimitTeach = {id = 178},
  arcanaStageDetailTeach1 = {id = 179},
  arcanaStageDetailTeach2 = {id = 180},
  arcanaGameMainSceneTeach = {id = 181},
  arcanaSceneAttrTeach = {id = 182},
  arcanaSceneSkillTeach = {id = 183},
  arcanaStageDetailDamageBuffTeach = {id = 184},
  openCupArena = {id = 185},
  openMyth = {id = 186},
  treasureStartResearch = {id = 187, no_gm_skip = true},
  treasureBuyFragment = {
    id = 188,
    pre = "treasureStartResearch",
    no_gm_skip = true
  },
  treasureBuyFragmentAgain = {
    id = 189,
    pre = "treasureBuyFragment",
    no_gm_skip = true
  },
  treasureCompose = {
    id = 190,
    pre = "treasureBuyFragmentAgain",
    no_gm_skip = true
  }
}
class.t_key = t_keys
local c_times = {
  useSkill = 2,
  _5v5UseSkill = 4,
  SFStageFailedExit = 5,
  SFOpenShortcut = 5,
  SFOpenHeroPackage = 5,
  SFSelectHero = 5,
  SFSelectEquip = 5,
  SFSelectStage = 5,
  SHclickHeroPackage = 2,
  SHclickHero = 2,
  PlayoffsClick = 99999999,
  openArtifact = 99999999,
  readSpecialMail = 99999999,
  openConfigureSet = 99999999,
  openMedalSet = 99999999,
  unlockDiamondShop = 99999999
}
class.c_times = c_times
class.label_size = 20
class.label_color = ccc3(255, 255, 255)
class.stroke_color = ccc3(61, 40, 32)
class.label_dimensions = {
  big_vertical = CCSizeMake(125, 0),
  big_horizontal = CCSizeMake(0, 70),
  small_vertical = CCSizeMake(110, 0),
  small_horizontal = CCSizeMake(160, 80)
}
class.bubble_res = {
  big = "UI/alpha/1080P/guide/tutorial_bubble_big.png",
  small = "UI/alpha/1080P/guide/tutorial_bubble_small.png"
}
class.bubble_size = {
  big = CCSizeMake(113, 87),
  small = CCSizeMake(112, 58.5)
}
class.spriteRect = {
  big = CCRectMake(50, 25, 12, 7),
  small = CCRectMake(50, 25, 12, 7)
}
class.bubble_arrow_gap = {
  big = {
    left = 60,
    right = -60,
    down = 50,
    up = -50
  },
  small = {
    left = 60,
    right = -60,
    down = 40,
    up = -40
  }
}
class.arrow_res = {
  left = "UI/alpha/1080P/guide/tutorial_arrow_left.png",
  right = "UI/alpha/1080P/guide/tutorial_arrow_right.png",
  down = "UI/alpha/1080P/guide/tutorial_arrow_down.png",
  up = "UI/alpha/1080P/guide/tutorial_arrow_down.png"
}
class.arrow_amplitude_xy = {
  left = ccp(-10, 0),
  right = ccp(10, 0),
  down = ccp(0, 10),
  up = ccp(0, -10)
}
class.arrow_anim_period = 1
class.use_bubble_duration = true
class.base_show_duration = 10
class.popTop = 580
class.popBottom = -100
class.popLeft = -600
class.popRight = 600
class.popGap = 0.2
class.FTintoMain = {
  type = "tips",
  dialog_text = T("\228\187\142\232\191\153\233\135\140\232\131\189\230\139\155\229\139\159\229\136\176\230\156\128\229\142\137\229\174\179\231\154\132\233\152\159\229\143\139\239\188\129"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 300,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.FTBronzeOpen = {
  type = "tips",
  dialog_text = T("\229\133\141\232\180\185\231\154\132\231\187\143\233\170\140\232\141\175\232\134\143\239\188\129\231\156\139\231\156\139\228\188\154\233\153\132\233\128\129\228\187\128\228\185\136"),
  dialog_head_pos = ccp(0.5, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 250,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.FTBronzeOne = {type = "tips"}
class.FTBronzeClose = {
  type = "tips",
  dialog_text = T("\230\156\137\228\186\134\231\129\171\229\165\179\231\154\132\229\138\160\229\133\165\239\188\140\230\136\145\229\188\128\229\167\139\228\184\186\230\136\145\228\187\172\231\154\132\230\149\140\228\186\186\229\147\128\230\130\188\228\186\134")
}
class.FTSilverOpen = {
  type = "tips",
  dialog_text = T("\231\187\143\233\170\140\232\141\175\232\134\143\228\185\159\229\133\141\232\180\185\232\128\182!"),
  dialog_head_pos = ccp(0.8, 0.25),
  dialog_talk_width = 250,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_from = "right"
}
class.FTSilverOne = {type = "tips"}
class.FTSilverClose = {
  type = "tips",
  dialog_text = T("\230\156\137\228\186\134\231\129\171\229\165\179\231\154\132\229\138\160\229\133\165\239\188\140\230\136\145\229\188\128\229\167\139\228\184\186\230\136\145\228\187\172\231\154\132\230\149\140\228\186\186\229\147\128\230\130\188\228\186\134"),
  dialog_head_pos = ccp(0.1, 0.12)
}
class.FTGoldOpen = {
  type = "tips",
  dialog_text = T("\229\134\141\232\175\149\232\175\149\229\133\141\232\180\185\231\154\132\229\165\182\233\133\170\239\188\129"),
  dialog_head_pos = ccp(0.2, 0.15)
}
class.FTGoldOne = {type = "tips"}
class.FTGoldClose = {
  type = "tips",
  dialog_text = T("\229\176\143\233\187\145\239\188\140\230\172\162\232\191\142\228\189\160\231\154\132\229\138\160\229\133\165\239\188\129\230\136\145\228\187\172\231\154\132\229\174\158\229\138\155\230\155\180\229\188\186\229\164\167\228\186\134"),
  dialog_head_pos = ccp(0.2, 0.12)
}
class.FTbackToMain = {type = "tips", still_show = true}
class.gotoSelectStage = {
  type = "finger",
  need_check_drag = true,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  circle_radius = 100,
  dialog_lock = false,
  dialog_text = T("\229\188\128\229\167\139\228\188\159\229\164\167\231\154\132\229\134\146\233\153\169\229\144\167\239\188\129"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.selectStage = {
  type = "finger",
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\191\155\229\133\165\229\133\179\229\141\161\227\128\130"),
  dialog_head_pos = ccp(0.75, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "right",
  duration = 0
}
class.gotoPrepare = {type = "finger"}
class.selectHero = {
  type = "finger",
  dialog_lock = false,
  dialog_text = T("\230\138\138\232\139\177\233\155\132\228\187\172\233\131\189\230\180\190\228\184\138\229\156\186\227\128\130"),
  dialog_head_pos = ccp(0.2, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  duration = 0
}
class.gotoBattle = {
  type = "finger",
  dialog_lock = false,
  dialog_text = T("\230\138\138\232\139\177\233\155\132\228\187\172\233\131\189\230\180\190\228\184\138\229\156\186\227\128\130"),
  dialog_head_pos = ccp(0.2, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  duration = 0
}
class.nextWave = {
  type = "tips",
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  duration = 0,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\191\142\230\136\152\228\184\139\228\184\128\230\179\162\230\149\140\228\186\186\227\128\130"),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  dialog_head_flip = false
}
class.useSkill = {
  type = "tips",
  must_show = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\230\148\190\229\164\167\230\139\155\227\128\130"),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0,
  showDelay = 2
}
class._5v5UseSkill = {
  type = "finger",
  must_show = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\230\150\189\230\148\190\230\138\128\232\131\189"),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0,
  showDelay = 0
}
class.addHeroToTeam = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\232\174\169\230\150\176\232\139\177\233\155\132\229\138\160\229\133\165\230\136\152\230\150\151\239\188\129"),
  dialog_head_pos = ccp(0.2, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.autoBattle = {
  type = "tips",
  text = T("\229\188\128\229\144\175\232\135\170\229\138\168\230\136\152\230\150\151"),
  offsetx = -20,
  offsety = 50,
  arrowOffsetx = 0,
  showDelay = 1,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.getEquipableProp = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\232\191\153\230\152\175\228\184\128\228\187\182\229\143\175\228\187\165\231\169\191\231\154\132\231\137\169\229\147\129\239\188\140\233\149\191\230\140\137\230\159\165\231\156\139"),
  dialog_head_pos = ccp(0.65, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "right",
  dialog_pop_from = "right",
  duration = 0
}
class.clickNextStage = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\232\142\183\229\190\151\228\186\134\228\184\128\228\187\182\229\143\175\228\187\165\231\169\191\231\154\132\232\163\133\229\164\135,\229\142\187\231\169\191\228\184\138\229\174\131\229\144\167"),
  dialog_head_pos = ccp(0.25, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.cookSelectTalent1 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\230\136\152\228\186\137\233\162\134\229\156\176\230\156\137\230\150\176\231\154\132\228\184\156\232\165\191\229\135\186\231\142\176\239\188\140\229\191\171\229\142\187\231\156\139\231\156\139\229\144\167"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.cookSelectTalent2 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\229\142\168\229\168\152\233\151\173\229\133\179\229\144\142\229\142\168\232\137\186\229\164\167\229\164\167\230\143\144\229\141\135\239\188\140\229\191\171\229\191\171\230\159\165\231\156\139\232\175\166\231\187\134\229\134\133\229\174\185"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.cookSelectTalent3 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\229\142\168\229\168\152\230\142\140\230\143\161\228\186\134\228\184\137\231\167\141\228\184\141\229\144\140\231\154\132\232\143\156\231\179\187\239\188\140\233\128\137\230\139\169\228\184\128\231\167\141\231\187\167\231\187\173\231\160\148\231\169\182"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.EEselectOneKeyResolveRune = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\229\176\134\230\151\167\231\137\136\231\172\166\231\159\179\232\135\170\229\138\168\229\136\134\232\167\163\228\184\186\231\173\137\228\187\183\231\154\132\231\172\166\231\159\179\231\178\190\229\141\142"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.tryOnFashion = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\231\154\174\232\130\164\229\143\175\228\187\165\232\175\149\231\169\191,\232\180\173\228\185\176\229\144\142\229\143\175\231\130\185\229\135\187\231\169\191\228\184\138\229\146\140\232\132\177\228\184\139"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openShortcutToEquip = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\232\174\169\230\136\145\230\157\165\230\149\153\228\189\160\230\128\142\228\185\136\231\169\191\232\163\133\229\164\135"),
  dialog_head_pos = ccp(0.1, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  duration = 0,
  finger_be_left = true
}
class.gotoEquipProp = {
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.gotoHeroDetailToEquip = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\233\128\137\230\139\169\228\184\128\228\184\170\229\143\175\228\187\165\231\169\191\232\163\133\229\164\135\231\154\132\232\139\177\233\155\132"),
  dialog_head_pos = ccp(0.1, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.equipProp = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\231\161\174\232\174\164\232\163\133\229\164\135\n\239\188\136\232\163\133\229\164\135\229\144\142\229\176\134\228\184\142\232\139\177\233\155\132\231\187\145\229\174\154\239\188\137"),
  dialog_head_pos = ccp(0.1, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.canEquipProp = {
  type = "tips",
  must_show = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\163\133\229\164\135\228\189\141"),
  dialog_head_pos = ccp(0.1, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.canCraftProp = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\163\133\229\164\135\228\189\141"),
  dialog_head_pos = ccp(0.1, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.composeFragment = {
  type = "tips",
  must_show = true,
  dialog_lock = false,
  dialog_text = T("\232\191\153\228\184\170\231\162\142\231\137\135\229\143\175\228\187\165\229\144\136\230\136\144\228\186\134\239\188\140\231\130\185\229\135\187\230\159\165\231\156\139"),
  dialog_head_pos = ccp(0.1, 0.08),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.heroUpgrade = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\232\191\153\228\184\170\232\139\177\233\155\132\229\143\175\228\187\165\232\191\155\233\152\182\228\186\134"),
  dialog_head_pos = ccp(-0.3, 0.2),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.refreshShop = {
  type = "tips",
  text = T("\229\136\183\230\150\176\229\143\175\228\187\165\230\141\162\228\184\128\230\137\185\229\149\134\229\147\129"),
  offsetx = -60,
  arrowDirection = "right"
}
class.stageFailToEquipProp = {
  type = "tips",
  text = T("\230\155\180\230\150\176\232\163\133\229\164\135\229\144\142\229\134\141\230\157\165\232\175\149\232\175\149"),
  offsetx = -80,
  showDelay = 1,
  arrowDirection = "right"
}
class.stageFailToUpgradeHero = {
  type = "tips",
  text = T("\230\143\144\229\141\135\232\139\177\233\155\132\231\173\137\231\186\167\229\144\142\229\134\141\230\157\165\232\175\149\232\175\149"),
  offsetx = -80,
  showDelay = 1,
  arrowDirection = "right"
}
class.clickEliteModeButton = {
  type = "tips",
  text = T("\230\150\176\229\188\128\229\144\175\231\178\190\232\139\177\229\133\179\229\141\161"),
  offsety = -50,
  arrowDirection = "up",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  duration = 0
}
class.closeHeroDetail = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\231\169\191\230\187\161\229\133\173\228\187\182\232\163\133\229\164\135\229\144\142\239\188\140\232\139\177\233\155\132\229\176\177\232\131\189\232\191\155\233\152\182\229\143\152\229\190\151\230\155\180\229\188\186"),
  dialog_head_pos = ccp(-0.3, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left"
}
class.backToStageSelect = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\231\142\176\229\156\168\231\187\167\231\187\173\229\134\146\233\153\169\229\144\167"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left"
}
class.firstTaskOpenShortcut = {
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.firstTaskOpenTaskWindow = {
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.firstTaskClickComplete = {type = "tips"}
class.firstTaskClickok = {type = "tips"}
class.firstTaskClickClose = {type = "tips"}
class.SHopenShortcut = {
  dialog_lock = false,
  dialog_text = T("\232\183\159\230\136\145\230\157\165"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SHclickHeroPackage = {
  dialog_lock = false,
  dialog_text = T("\230\136\145\233\162\132\230\132\159\229\136\176\230\156\137\230\150\176\231\154\132\232\139\177\233\155\132\232\166\129\229\138\160\229\133\165\230\136\145\228\187\172\228\186\134"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SHclickHero = {
  dialog_lock = false,
  dialog_text = T("\232\139\177\233\155\132\239\188\140\229\144\172\228\187\142\230\136\145\231\154\132\229\143\172\229\148\164\239\188\129"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SHclickok = {type = "tips"}
class.EEclickHero = {
  type = "tips",
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\233\128\137\230\139\169\232\139\177\233\155\132"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.2,
  dialog_pop_from = "left"
}
class.EEselectBranch = {
  type = "finger",
  must_show = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\191\155\229\133\165\232\163\133\229\164\135\233\153\132\233\173\148"),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0,
  showDelay = 0
}
class.EEselectBranch2 = {
  type = "finger",
  must_show = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\191\155\229\133\165\230\180\151\231\130\188"),
  dialog_head_pos = ccp(0, 0.3),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0,
  showDelay = 0
}
class.EEselectHero = {type = "tips"}
class.EEclickEquip = {type = "tips"}
class.EEopenMaterial = {type = "tips"}
class.EEclickMaterial = {type = "tips"}
class.EEclickEnhance = {type = "tips"}
class.SUopenShortcut = {
  dialog_lock = false,
  dialog_text = T("\232\183\159\230\136\145\230\157\165"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips",
  finger_be_left = true
}
class.SUclickHeroPackage = {
  dialog_lock = false,
  dialog_text = T("\230\152\175\230\151\182\229\128\153\230\149\153\228\189\160\229\141\135\231\186\167\230\138\128\232\131\189\228\186\134\227\128\130"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips",
  must_show = true,
  finger_be_left = true
}
class.SUclickHero = {
  dialog_lock = false,
  dialog_text = T("\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132\227\128\130"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SUclickSkillButton = {
  dialog_lock = false,
  dialog_text = T("\228\187\142\232\191\153\233\135\140\232\191\155\229\133\165\230\138\128\232\131\189\233\157\162\230\157\191"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SUclickLevelup = {
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\191\153\228\184\170\230\140\137\233\146\174\229\141\135\231\186\167\230\138\128\232\131\189"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  type = "tips"
}
class.SUcomplete = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\230\138\128\232\131\189\231\130\185\228\188\154\233\154\143\230\151\182\233\151\180\232\135\170\229\138\168\230\129\162\229\164\141\239\188\140\229\165\189\229\165\189\228\189\191\231\148\168\227\128\130"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left"
}
class.gotoTavernEnch = {type = "tips", must_show = true}
class.openTavernEnch = {type = "tips", must_show = true}
class.tavernEnch = {type = "tips", must_show = true}
class.openWarDecompose = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\232\191\153\233\135\140\230\152\175\230\136\152\228\186\137\231\134\148\231\130\137\239\188\140\229\143\175\228\187\165\229\176\134\232\163\133\229\164\135\229\136\134\232\167\163\230\136\144\229\144\132\231\167\141\232\181\132\230\186\144"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.2,
  dialog_pop_from = "left"
}
class.openWarMake = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\232\191\153\233\135\140\230\152\175\230\136\152\228\186\137\229\183\165\229\157\138\239\188\140\229\143\175\228\187\165\229\136\169\231\148\168\232\181\132\230\186\144\233\148\187\233\128\160\229\135\186\233\156\128\232\166\129\231\154\132\232\163\133\229\164\135"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.2,
  dialog_pop_from = "left"
}
class.openWarCollege = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\232\191\153\233\135\140\230\152\175\230\136\152\228\186\137\229\173\166\233\153\162\239\188\140\229\143\175\228\187\165\229\173\166\228\185\160\229\144\132\231\167\141\230\138\128\232\131\189\230\157\165\229\138\160\229\188\186\230\136\145\228\187\172\231\154\132\230\136\152\233\152\159"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.2,
  dialog_pop_from = "left"
}
class.WDClickConfirm = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\232\181\132\230\186\144\228\185\159\229\143\175\229\156\168\232\151\143\229\174\157\229\156\176\231\169\180\227\128\129\230\151\182\231\169\186\230\188\169\230\182\161\227\128\129\229\149\134\229\186\151\231\173\137\229\156\176\230\150\185\232\142\183\229\143\150"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.2,
  dialog_pop_from = "left"
}
class.aboutHandbook = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\233\154\143\231\157\128\230\136\152\233\152\159\231\173\137\231\186\167\231\154\132\230\143\144\233\171\152\239\188\140\228\188\154\229\156\168\232\191\153\233\135\140\231\156\139\229\136\176\230\155\180\229\164\154\232\163\133\229\164\135"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.5,
  dialog_pop_from = "left"
}
class.aboutShop = {still_show = true}
class.aboutSkillUpgrade = {still_show = true}
class.aboutSpecialShop = {still_show = true}
class.equipSuccess = {still_show = true}
class.aboutSkillHeroPackage = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\233\128\137\230\139\169\233\156\128\232\166\129\229\188\186\229\140\150\230\138\128\232\131\189\231\154\132\232\139\177\233\155\132"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.5,
  dialog_pop_from = "left"
}
class.heroExpMax = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\230\143\144\229\141\135\230\136\152\233\152\159\231\173\137\231\186\167\229\143\175\228\187\165\229\162\158\229\138\160\232\139\177\233\155\132\231\173\137\231\186\167\228\184\138\233\153\144"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.5,
  dialog_pop_from = "left"
}
class.FTchooseExcavate = {
  dialog_text = T("\230\175\143\231\167\141\229\174\157\232\151\143\233\131\189\228\188\154\228\186\167\229\135\186\233\146\187\231\159\179\229\147\166"),
  dialog_head_pos = ccp(0.2, 0.12),
  dialog_click_destroy = true
}
class.unlockShop = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\229\149\134\229\186\151\229\138\159\232\131\189"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop",
  fca_pos = ccp(280, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockSkillUpgrade = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\230\138\128\232\131\189\229\188\186\229\140\150"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_elitemode.png",
  icon_pos = ccp(275, 270),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockEliteMode = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\229\133\179\229\141\161\231\178\190\232\139\177\230\168\161\229\188\143"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_elitemode.png",
  icon_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockActivitySweep = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\230\151\182\231\169\186\230\188\169\230\182\161\239\188\140\229\183\178\232\167\163\233\148\129\230\137\171\232\141\161\239\188\129"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/todolist_icon_spring.png",
  icon_pos = ccp(259, 240),
  bg_pos = ccp(400, 237),
  light_pos = ccp(263, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockpvp = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\231\171\158\230\138\128\229\156\186\229\138\159\232\131\189"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Pvp",
  fca_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockMidas = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\231\130\185\233\135\145\230\137\139\229\138\159\232\131\189"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_elitemode.png",
  icon_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockEnhance = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\232\163\133\229\164\135\233\153\132\233\173\148"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_magicSchool",
  fca_pos = ccp(269, 255),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockExercise = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\230\151\182\231\169\186\230\188\169\230\182\161"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/main_spring.png",
  icon_pos = ccp(275, 253),
  icon_scale = 0.75,
  fca_res = "eff_UI_Main_spaceVortex",
  fca_pos = ccp(275, 270),
  fca_scale = 0.75,
  bg_pos = ccp(400, 237),
  light_pos = ccp(255, 250),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockCrusade = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Volcano",
  fca_scale = 0.8,
  fca_pos = ccp(269, 275),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockGuild = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\229\136\155\229\187\186\229\143\138\229\138\160\229\133\165\229\133\172\228\188\154"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Guild",
  fca_scale = 0.6,
  fca_pos = ccp(269, 260),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockWorldChannel = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\228\184\150\231\149\140\233\162\145\233\129\147\229\143\145\232\168\128"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_worldchannel.png",
  icon_pos = ccp(269, 240),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockExcavate = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\232\151\143\229\174\157\229\156\176\231\169\180"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Treasure",
  fca_scale = 0.5,
  fca_pos = ccp(285, 230),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockStarShop = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\230\152\159\233\153\133\229\149\134\228\186\186\230\157\165\232\174\191\239\188\136\232\180\167\231\137\169\229\183\178\229\136\183\230\150\176\239\188\137"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop_Star",
  fca_scale = 1.2,
  fca_pos = ccp(285, 230),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockSpecialShop = {
  type = "announce",
  still_show = true,
  text = T("\229\183\178\229\143\145\231\142\176\239\188\129\229\156\176\231\178\190\229\149\134\228\186\186"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop2",
  fca_pos = ccp(269, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockSoSpecialShop = {
  type = "announce",
  still_show = true,
  text = T("\229\183\178\229\143\145\231\142\176\239\188\129\233\187\145\232\161\163\229\149\134\228\186\186"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Shop3",
  fca_pos = ccp(285, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockAwake = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\230\180\151\231\130\188"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_magicSchool",
  fca_pos = ccp(295, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockSpring = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\230\151\182\231\169\186\230\188\169\230\182\161\239\188\140\229\137\175\230\156\172\230\150\176\229\162\158\239\188\129"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/main_spring.png",
  icon_pos = ccp(275, 253),
  icon_scale = 0.75,
  fca_res = "eff_UI_Main_spaceVortex",
  fca_pos = ccp(275, 270),
  fca_scale = 0.75,
  bg_pos = ccp(400, 237),
  light_pos = ccp(255, 250),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockTopPvp = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_TopPvp",
  fca_pos = ccp(280, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(255, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockRealArena = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\232\175\184\231\142\139\228\186\137\233\156\184"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_kings",
  fca_pos = ccp(280, 263),
  bg_pos = ccp(400, 237),
  light_pos = ccp(255, 260),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockAncients = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\141\138\231\169\186\228\184\173\229\135\186\231\142\176\228\186\134\231\165\158\231\167\152\233\129\151\232\191\185"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_Monument",
  fca_scale = 1,
  fca_pos = ccp(255, 230),
  bg_pos = ccp(400, 237),
  light_pos = ccp(260, 260),
  light_scale = 1,
  label_pos = ccp(455, 240)
}
class.unlockLegendArena = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_LegendPVP",
  fca_scale = 1,
  fca_pos = ccp(289, 275),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 1,
  label_pos = ccp(455, 240)
}
class.unlockBabel = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\229\164\169\231\169\186\232\166\129\229\161\158"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Main_LegendPVP",
  fca_scale = 1,
  fca_pos = ccp(289, 275),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 1,
  label_pos = ccp(455, 240)
}
class.unlockBabelLevel = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\229\164\169\231\169\186\232\166\129\229\161\158\231\173\137\231\186\167"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_Babel_levelup",
  fca_scale = 1,
  fca_pos = ccp(289, 275),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 1,
  label_pos = ccp(455, 240)
}
class.unlockWarTerritory = {
  type = "announce",
  must_show = true,
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\230\136\152\233\152\159\233\162\134\229\156\176"),
  fontColor = ccc3(103, 47, 0),
  fca_res = "eff_UI_School_guidepost_1",
  fca_scale = 1,
  fca_pos = ccp(269, 270),
  bg_pos = ccp(400, 237),
  light_pos = ccp(275, 260),
  light_scale = 1,
  label_pos = ccp(455, 240)
}
class.openShop = {
  type = "tips",
  must_show = true,
  circle_radius = 68,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\229\149\134\229\186\151"),
  offsety = 60,
  offsetx = 0,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openSpecialShop = {
  type = "tips",
  must_show = true,
  circle_radius = 68,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\229\156\176\231\178\190\229\149\134\228\186\186"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openSoSpecialShop = {
  type = "tips",
  must_show = true,
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\233\187\145\232\161\163\229\149\134\228\186\186"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openStarshop = {
  type = "tips",
  must_show = true,
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\152\159\233\153\133\229\149\134\228\186\186\230\157\165\232\174\191\239\188\136\232\180\167\231\137\169\229\183\178\229\136\183\230\150\176\239\188\137"),
  offsetx = -60,
  arrowDirection = "right",
  bubbleType = "small",
  bubbleScaleMode = "vertical",
  need_check_drag = true
}
class.openEnhance = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\232\163\133\229\164\135\233\153\132\233\173\148"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openpvp = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\231\171\158\230\138\128\229\156\186"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openMidas = {type = "tips"}
class.opencot = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\230\151\182\229\133\137\228\185\139\231\169\180"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openEnhance = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\232\163\133\229\164\135\233\153\132\233\173\148"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openExercise = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\230\151\182\231\169\186\230\188\169\230\182\161"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openTradehouse = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\228\186\164\230\152\147\232\161\140"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openExcavate = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\232\151\143\229\174\157\229\156\176\231\169\180"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openOfflineQuest = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\230\130\172\232\181\143\230\160\143"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.dispatchOfflineQuest = {
  type = "tips",
  circle_radius = 70,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\231\130\185\232\191\153\233\135\140\232\176\131\230\149\180\233\152\181\229\174\185"),
  offsety = 0,
  offsetx = -70,
  arrowDirection = "right",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openCrusade = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.firstMercenary = {
  type = "tips",
  dialog_text = T("\228\189\160\229\143\175\228\187\165\228\187\142\233\155\135\228\189\163\229\133\181\232\144\165\229\156\176\232\175\183\230\157\165\229\144\140\229\133\172\228\188\154\230\136\152\233\152\159\231\154\132\229\188\186\229\138\155\229\164\150\230\143\180\239\188\129"),
  dialog_head_pos = ccp(0, 0.15),
  dialog_head_width = 76,
  dialog_talk_width = 300,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openAwake = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\230\180\151\231\130\188"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openSpring = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\151\182\231\169\186\230\188\169\230\182\161\239\188\140\229\137\175\230\156\172\230\150\176\229\162\158\239\188\129"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openTopPvp = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186"),
  offsety = 60,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openRealArena = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\232\175\184\231\142\139\228\186\137\233\156\184"),
  offsety = 70,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openAncients = {
  type = "tips",
  must_show = true,
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\231\165\158\231\167\152\233\129\151\232\191\185"),
  offsetx = -60,
  arrowDirection = "right",
  bubbleType = "small",
  bubbleScaleMode = "vertical",
  need_check_drag = true
}
class.openLegendArena = {
  type = "tips",
  must_show = true,
  circle_radius = 50,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186"),
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "vertical",
  need_check_drag = true
}
class.openBabel = {
  type = "tips",
  must_show = true,
  circle_radius = 50,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\229\164\169\231\169\186\232\166\129\229\161\158"),
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "vertical",
  need_check_drag = true
}
class.openWarTerritory = {
  type = "tips",
  must_show = true,
  circle_center = ccp(1135, 285),
  circle_radius = 50,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\230\136\152\233\152\159\233\162\134\229\156\176"),
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "vertical",
  need_check_drag = true
}
class.openMonsterseal = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\233\173\148\231\142\139\229\176\129\229\141\176"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.WRClickLeft = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\232\191\153\233\135\140\239\188\140\233\128\137\230\139\169\229\133\145\230\141\162\228\189\191\231\148\168\231\154\132\232\181\132\230\186\144\231\177\187\229\158\139"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.WRClickDiamond = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\233\128\137\230\139\169\233\146\187\231\159\179"),
  dialog_head_pos = ccp(0.75, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "right",
  duration = 0
}
class.WRClickWood = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\233\128\137\230\139\169\230\156\168\230\157\144\228\184\186\229\133\145\230\141\162\232\142\183\229\190\151\231\154\132\232\181\132\230\186\144"),
  dialog_head_pos = ccp(0.75, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "right",
  dialog_head_flip = true,
  dialog_pop_delay = 0,
  dialog_pop_from = "right",
  duration = 0
}
class.warresourceEnd = {
  still_show = true,
  dialog_lock = false,
  dialog_text = T("\230\142\165\228\184\139\230\157\165\233\152\159\233\149\191\229\164\167\229\164\167\229\176\177\229\143\175\228\187\165\228\189\191\231\148\168\233\146\187\231\159\179\229\133\145\230\141\162\230\156\168\230\157\144"),
  dialog_head_pos = ccp(0.1, 0.1),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0.2,
  dialog_pop_from = "left"
}
class.ancientsQuit = {type = "finger"}
class.SFStageFailedExit = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\228\189\160\233\156\128\232\166\129\232\138\177\228\184\128\231\130\185\230\151\182\233\151\180\230\157\165\230\144\156\233\155\134\232\163\133\229\164\135\227\128\130"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.SFOpenShortcut = {type = "finger", need_check_drag = true}
class.SFOpenHeroPackage = {type = "finger", need_check_drag = true}
class.SFSelectHero = {type = "finger", need_check_drag = true}
class.SFSelectEquip = {type = "finger", need_check_drag = true}
class.SFCheckDrop = {type = "finger", need_check_drag = true}
class.SFSelectStage = {type = "finger", need_check_drag = true}
class.WSClickIcon = {type = "finger"}
class.WSClickUpgrade = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\229\191\171\231\130\185\229\173\166\228\188\154\232\191\153\228\184\170\230\138\128\232\131\189\239\188\140\232\174\169\230\136\145\228\187\172\230\155\180\229\138\160\229\188\186\229\164\167"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.GCWClickAttack = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\230\173\164\229\164\132\229\143\175\228\187\165\229\144\145\230\173\164\230\141\174\231\130\185\230\180\190\229\135\186\232\191\155\230\148\187\233\152\159\228\188\141"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.GCWClickAssist = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\230\173\164\229\164\132\229\143\175\228\187\165\229\144\145\230\173\164\230\141\174\231\130\185\230\180\190\229\135\186\233\152\159\228\188\141\232\191\155\232\161\140\233\169\187\233\152\178"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 322,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.PlayoffsClick = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\228\186\178\231\136\177\231\154\132\233\152\159\233\149\191\239\188\140\230\156\172\232\181\155\229\173\163\231\154\132\229\173\163\229\144\142\232\181\155\229\188\128\229\167\139\230\138\165\229\144\141\229\149\166\239\188\140\229\191\171\230\157\165\231\156\139\231\156\139\229\144\167\239\188\129"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openArtifact = {
  type = "finger",
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\230\156\137\230\150\176\231\154\132\230\151\182\231\169\186\230\188\169\230\182\161\229\137\175\230\156\172\229\143\175\230\140\145\230\136\152\228\186\134\239\188\140\229\191\171\229\142\187\231\156\139\231\156\139\229\144\167\227\128\130"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openSpecialMailbox = {
  type = "finger",
  fca_scale = 0.6,
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\228\188\188\228\185\142\230\148\182\229\136\176\228\186\134\228\186\134\228\184\141\229\190\151\231\154\132\228\191\161\228\187\182\239\188\140\229\191\171\229\142\187\231\156\139\231\156\139\229\144\167\227\128\130"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.readSpecialMail = {
  type = "finger",
  fca_scale = 0.8,
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\229\146\166\239\188\140\230\152\175\229\176\143\233\187\145\229\175\132\230\157\165\231\154\132\228\191\161\227\128\130"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.getSpecialEquipInMail = {
  type = "finger",
  fca_scale = 0.6,
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\229\164\170\229\165\189\228\186\134\239\188\140\230\156\137\228\186\134\230\150\176\229\156\176\229\155\190\229\176\177\229\143\175\228\187\165\229\142\187\230\137\190\229\175\187\231\165\158\229\153\168\228\186\134\239\188\129"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.ArtifactMode = {type = "finger", fca_scale = 0.6}
class.openConfigureSet = {
  type = "finger",
  fca_scale = 0.8,
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\231\165\157\232\180\186\233\152\159\233\149\191\239\188\140\233\137\180\228\186\142\230\130\168\231\154\132\228\188\152\231\167\128\232\161\168\231\142\176\239\188\140\232\142\183\229\190\151\228\186\134\232\174\176\232\189\189\230\130\168\232\141\163\232\170\137\229\146\140\230\136\152\231\187\169\231\154\132\229\190\189\231\171\160\239\188\140\232\175\183\230\137\147\229\188\128\228\186\186\231\137\169\231\149\140\233\157\162\230\159\165\231\156\139"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openMedalSet = {
  type = "finger",
  fca_scale = 0.6,
  need_check_drag = true,
  dialog_lock = false,
  dialog_text = T("\231\130\185\229\135\187\228\184\170\230\128\167\232\174\190\231\189\174\230\140\137\233\146\174\239\188\140\232\191\155\229\133\165\229\190\189\231\171\160\232\174\190\231\189\174\233\161\181\233\157\162\228\189\169\230\136\180\229\177\158\228\186\142\232\135\170\229\183\177\231\154\132\229\190\189\231\171\160\229\144\167\239\188\129"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.UPGradeLack = {type = "finger", fca_scale = 0.6}
class.unlockStageSweep = {
  type = "announce",
  must_show = true,
  still_show = true,
  fontColor = ccc3(103, 47, 0),
  icon_pos = ccp(280, 245),
  fca_pos = ccp(280, 220),
  fca_scale = 0.8,
  bg_pos = ccp(400, 237),
  light_pos = ccp(280, 235),
  light_scale = 0.8,
  label_pos = ccp(455, 240),
  label_posup = ccp(455, 253),
  label_posdown = ccp(455, 228)
}
class.unlockWarschool = {
  type = "announce",
  must_show = true,
  still_show = true,
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/walschool_sign.png",
  icon_pos = ccp(253, 247),
  fca_pos = ccp(240, 220),
  fca_scale = 0.8,
  bg_pos = ccp(400, 237),
  light_pos = ccp(237, 235),
  light_scale = 0.8,
  label_pos = ccp(455, 240)
}
class.unlockChallengeMod = {
  type = "announce",
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\230\140\145\230\136\152\230\168\161\229\188\143"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_challenge.png",
  icon_pos = ccp(265, 247),
  bg_pos = ccp(400, 237),
  light_bg = "UI/alpha/HVGA/unlock_light_purple.png",
  light_pos = ccp(275, 260),
  light_scale = 1.6,
  label_pos = ccp(455, 240)
}
class.unlockRankFastUpgrade = {
  type = "announce",
  still_show = true,
  text = T("\229\183\178\232\167\163\233\148\129\239\188\129\229\191\171\233\128\159\232\191\155\233\152\182"),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/unlock_awake.png",
  icon_pos = ccp(265, 242),
  bg_pos = ccp(400, 237),
  light_pos = ccp(270, 250),
  light_scale = 1,
  label_pos = ccp(455, 240)
}
class.selectTowerHero = {
  type = "finger",
  dialog_text = T("\232\131\189\233\135\143\229\183\178\231\187\143\229\133\133\232\182\179\239\188\140\232\175\183\233\128\137\230\139\169\228\184\128\228\184\170\232\139\177\233\155\132\239\188\129"),
  dialog_head_pos = ccp(0, 0.22),
  dialog_head_width = 76,
  dialog_talk_width = 300,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  fca_scale = 0.6
}
class.placeTowerHero = {
  type = "finger",
  dialog_text = T("\231\130\185\229\135\187\229\156\176\233\157\162\230\138\138\232\139\177\233\155\132\230\180\190\228\184\138\230\136\152\229\156\186\239\188\129"),
  dialog_head_pos = ccp(0, 0.22),
  dialog_head_width = 76,
  dialog_talk_width = 300,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  fca_scale = 0.6
}
class.openHerorecommend = {type = "tips", still_show = true}
class.unlockPetHouse1 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\228\191\161\228\189\191\229\177\139\229\188\128\228\184\154\228\186\134\239\188\140\229\191\171\229\142\187\231\156\139\231\156\139\229\144\167"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.unlockPetHouse2 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\229\156\168\228\191\161\228\189\191\229\177\139\229\143\175\228\187\165\229\173\181\229\140\150\228\191\161\228\189\191\232\155\139\239\188\140\232\142\183\229\190\151\229\144\132\231\167\141\228\191\161\228\189\191"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openHomePage1 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\231\142\176\229\156\168\233\152\159\233\149\191\229\143\175\228\187\165\229\142\187\232\174\190\231\189\174\228\184\170\230\128\167\229\140\150\231\154\132\229\177\149\231\164\186\229\134\133\229\174\185\229\149\166"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openHomePage2 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\230\136\152\233\152\159\232\141\163\232\170\137\229\143\175\228\187\165\229\177\149\231\164\186\233\152\159\233\149\191\230\137\128\233\170\132\229\130\178\231\154\132\232\139\177\233\155\132\228\187\172\239\188\140\229\190\189\231\171\160\229\146\140\229\164\180\229\131\143\229\164\150\232\167\130\239\188\129"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openHomePage3 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\231\142\176\229\156\168\229\176\177\230\183\187\229\138\160\229\135\160\228\184\170\232\139\177\233\155\132\232\174\169\229\136\171\231\154\132\233\152\159\233\149\191\231\156\139\231\156\139\229\144\167\239\188\129"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.openHomePage4 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\230\139\150\230\139\189\230\147\141\228\189\156\232\131\189\229\164\159\231\167\187\229\138\168\229\177\149\231\164\186\231\154\132\228\189\141\231\189\174~"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 380,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0
}
class.voideplayer1 = {
  type = "finger",
  fca_scale = 0.6,
  dialog_lock = false,
  dialog_text = T("\230\129\173\229\150\156\230\130\168\239\188\140\230\130\168\231\154\132\230\136\144\231\187\169\232\191\155\229\133\165\228\186\134\229\133\168\230\156\141\230\142\146\232\161\140\230\166\156\229\137\14150\239\188\140\230\130\168\231\154\132\229\189\149\229\131\143\229\176\134\232\162\171\229\136\134\228\186\171\231\187\153\229\133\168\230\156\141\231\142\169\229\174\182\239\188\140\230\130\168\228\185\159\229\143\175\228\187\165\229\156\168\230\142\146\232\161\140\230\166\156\230\137\139\229\138\168\233\154\144\232\151\143\232\135\170\229\183\177\231\154\132\229\189\149\229\131\143"),
  dialog_head_pos = ccp(0, 0.05),
  dialog_head_width = 76,
  dialog_talk_width = 450,
  dialog_head_side = "left",
  dialog_head_flip = false,
  dialog_pop_delay = 0,
  dialog_pop_from = "left",
  duration = 0,
  still_show = true
}
class.voideplayer2 = {type = "tips", still_show = true}
class.openTitanAltar = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\230\179\176\229\157\166\231\165\173\229\157\155"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openTarot = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\229\145\189\232\191\144\229\176\143\229\177\139"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.unlockDiamondShop = {
  type = "announce",
  still_show = true,
  text = T("\233\153\144\230\151\182\228\188\152\230\131\160\229\149\134\229\186\151\229\135\186\231\142\176\229\149\166\239\188\129\n\231\142\176\229\156\168\229\143\175\228\187\165\229\137\141\229\190\128\233\155\134\229\184\130\232\191\155\229\133\165"),
  label_posup = ccp(400, 237),
  label_posdown = ccp(400, 210),
  fontColor = ccc3(103, 47, 0),
  icon_res = "UI/alpha/HVGA/shop_head_diamond.png",
  icon_pos = ccp(400, 330),
  icon_scale = 0.8,
  icon_bg_res = "UI/alpha/HVGA/shop_icon_gold_background.png",
  icon_bg_pos = ccp(400, 300),
  icon_bg_scale = 0.8,
  bg_pos = ccp(400, 237),
  light_pos = ccp(400, 300),
  light_scale = 0.8
}
class.selectTavern = {type = "finger", duration = 10}
class.openCupArena = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\229\165\179\231\165\158\228\185\139\230\136\152"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openMyth = {
  type = "tips",
  circle_radius = 85,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle_big.png",
  text = T("\230\150\176\229\188\128\229\144\175\230\151\182\231\169\186\231\167\152\229\162\131"),
  offsety = 0,
  offsetx = 60,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openChessShop = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\232\180\173\228\185\176\230\163\139\229\173\144"),
  offsety = 0,
  offsetx = 40,
  txtOffsety = -8,
  label_size = 14,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.closeChessShop = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\229\133\179\233\151\173\229\149\134\229\186\151"),
  offsety = 0,
  offsetx = -60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "right",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.dragChessBattle = {
  type = "dragchess",
  circle_radius = 140,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\230\139\150\230\139\189\230\163\139\229\173\144\229\136\176\230\136\152\229\156\186"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.showChessDetail = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\230\159\165\231\156\139\230\163\139\229\173\144\229\177\158\230\128\167"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.showPrepareTip = {
  type = "nofingertip",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\229\135\134\229\164\135\233\152\182\230\174\181\229\143\175\228\187\165\232\176\131\230\149\180\233\152\181\229\174\185\239\188\140\229\128\146\232\174\161\230\151\182\231\187\147\230\157\159\232\191\155\229\133\165\230\136\152\230\150\151"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  contentSize = CCSizeMake(225, 60),
  txtOffsety = -4,
  arrowDirection = "up",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  use_bubble_duration = true,
  duration = 3,
  need_check_drag = true
}
class.openChessShopTwo = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\232\180\173\228\185\176\230\163\139\229\173\144"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openChessTag = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\230\159\165\231\156\139\231\167\141\230\151\143\232\175\166\230\131\133"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openChessShopThree = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\232\180\173\228\185\176\231\155\184\229\144\140\230\163\139\229\173\144\229\143\175\228\187\165\229\141\135\230\152\159"),
  offsety = 0,
  offsetx = 60,
  label_size = 14,
  txtOffsety = -1,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.openChessShopFour = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\232\180\173\228\185\176\230\163\139\229\173\144"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  need_check_drag = true
}
class.showStarUpTip = {
  type = "nofingertip",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\230\129\173\229\150\156\229\144\136\230\136\144\228\184\128\228\184\1702\230\152\159\230\163\139\229\173\144"),
  offsety = 0,
  offsetx = 60,
  label_size = 14,
  txtOffsety = -5,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  use_bubble_duration = true,
  duration = 5,
  need_check_drag = true
}
class.showLimitTip = {
  type = "nofingertip",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\230\136\152\229\156\186\230\163\139\229\173\144\230\149\176\233\135\143\232\190\190\229\136\176\228\184\138\233\153\144\239\188\140\233\156\128\232\166\129\229\141\135\231\186\167\232\167\163\233\148\129"),
  offsety = 0,
  offsetx = 60,
  label_size = 13,
  txtOffsety = 0,
  arrowDirection = "down",
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  use_bubble_duration = true,
  duration = 5,
  need_check_drag = true
}
class.openChessLevel = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\232\180\173\228\185\176\231\187\143\233\170\140\229\141\135\231\186\167\239\188\140\230\143\144\233\171\152\230\136\152\229\156\186\230\163\139\229\173\144\230\149\176\233\135\143\228\184\138\233\153\144"),
  offsety = 0,
  offsetx = 60,
  label_size = 13,
  txtOffsety = 0,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.showChessPetTip = {
  type = "newtips",
  circle_radius = 60,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\230\128\170\231\137\169\230\142\137\232\144\189\228\186\134\228\191\161\228\189\191\239\188\140\231\130\185\229\135\187\232\191\153\233\135\140\232\163\133\229\164\135\228\191\161\228\189\191"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaTeach = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T(""),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -12,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaGameMainSceneTeach = {
  type = "newtips",
  circle_radius = 30,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\228\188\188\228\185\142\230\156\137\232\139\177\233\155\132\229\143\175\228\187\165\232\167\137\233\134\146\230\150\176\231\154\132\232\131\189\229\138\155\228\186\134\239\188\140\229\191\171\230\157\165\231\156\139\231\156\139\229\144\167"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -12,
  arrowDirection = "right",
  arrowOffsetx = -50,
  arrowOffsety = 0,
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  bubbleOffsetx = -60,
  bubbleOffsety = 0
}
class.arcanaHeroPackageTeach = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\233\128\137\230\139\169\232\191\153\228\184\170\232\139\177\233\155\132"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -28,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaHeroDetailTeach = {
  type = "newtips",
  circle_radius = 30,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\232\135\179\229\174\157\229\155\190\230\160\135\229\188\128\229\144\175\232\139\177\233\155\132\232\135\179\229\174\157\233\161\181\233\157\162"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -22,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaSceneAttrTeach = {
  type = "newtips",
  circle_radius = 30,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\229\177\158\230\128\167\229\155\190\230\160\135\229\143\175\228\187\165\230\159\165\231\156\139\231\155\184\229\186\148\231\154\132\229\177\158\230\128\167\229\144\141\231\167\176"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -18,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaSceneSkillTeach = {
  type = "newtips",
  circle_radius = 30,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\230\156\170\232\167\163\233\148\129\231\154\132\232\135\179\229\174\157\230\138\128\232\131\189\230\159\165\231\156\139\230\138\128\232\131\189\232\167\163\233\148\129\230\157\161\228\187\182"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -18,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaTrialLimitTeach = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\230\159\165\231\156\139\232\135\179\229\174\157\232\175\149\231\130\188\229\188\128\229\144\175\230\157\161\228\187\182"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -18,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaMainSceneNewTrialTeach = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\229\188\128\229\144\175\230\150\176\231\154\132\232\135\179\229\174\157\232\175\149\231\130\188"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaStageDetailDamageBuffTeach = {
  type = "newtips",
  circle_radius = 40,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187BOSS\230\159\165\231\156\139\229\175\185BOSS\229\133\183\230\156\137\228\188\164\229\174\179\229\138\160\230\136\144\231\154\132\232\139\177\233\155\132"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -16,
  arrowDirection = "left",
  bubbleType = "small",
  bubbleScaleMode = "horizontal"
}
class.arcanaStageDetailTeach1 = {
  type = "newtips",
  circle_radius = 30,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\229\188\128\229\144\175\232\135\179\229\174\157\228\187\187\229\138\161\229\144\142\239\188\140\231\155\184\229\186\148\231\154\132\232\135\179\229\174\157\228\187\187\229\138\161\228\188\154\229\135\186\231\142\176\229\156\168\228\187\187\229\138\161\229\136\151\232\161\168\228\184\173"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -12,
  arrowDirection = "right",
  arrowOffsetx = -50,
  arrowOffsety = 0,
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  bubbleOffsetx = -60,
  bubbleOffsety = 0
}
class.arcanaStageDetailTeach2 = {
  type = "newtips",
  circle_radius = 30,
  circle_res = "UI/alpha/1080P/guide/tutorial_circle.png",
  text = T("\231\130\185\229\135\187\228\187\187\229\138\161\230\140\137\233\146\174"),
  offsety = 0,
  offsetx = 60,
  label_size = 16,
  txtOffsety = -4,
  arrowDirection = "right",
  arrowOffsetx = -50,
  arrowOffsety = 0,
  bubbleType = "small",
  bubbleScaleMode = "horizontal",
  bubbleOffsetx = -60,
  bubbleOffsety = 0
}
class.treasureStartResearch = {}
class.treasureBuyFragment = {}
class.treasureBuyFragmentAgain = {}
class.treasureCompose = {}
