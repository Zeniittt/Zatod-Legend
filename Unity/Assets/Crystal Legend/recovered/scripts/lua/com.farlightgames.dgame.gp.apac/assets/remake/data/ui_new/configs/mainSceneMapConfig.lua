local mapSize = {
  width = 4960 / ed.display.scaleFactor,
  height = 1440 / ed.display.scaleFactor
}
local limitX = {
  min = ed.display.winSize.width - mapSize.width - 100,
  max = -190
}
local dragModeJudgeDistance = 25
local dragInertanceGap = 0.5
local MapLayerDefine = {
  Bottom = 1,
  Middle = 2,
  Front = 3,
  Top = 4
}
ed.newSeasonOrActOpen = {}
local posZero = ccp(0, 0)
local mapLayersConfigs = {
  [MapLayerDefine.Bottom] = {
    damping = 0.32,
    commponents = {
      {
        name = "main_bg1",
        res = "UI/alpha/1080P/main/map/style_common/main_bg1.jpg",
        pos = ccp(480, 480.5),
        order = 0
      },
      {
        name = "main_bg2",
        res = "UI/alpha/1080P/main/map/style_common/main_bg2.jpg",
        pos = ccp(1440, 480.5),
        order = 0
      },
      {
        name = "main_bg3",
        res = "UI/alpha/1080P/main/map/style_common/main_bg3.jpg",
        pos = ccp(2400, 480.5),
        order = 0
      },
      {
        name = "mountain2_1",
        res = "UI/alpha/1080P/main/map/style_common/mountain2_1.png",
        pos = ccp(480, 265),
        order = 10
      },
      {
        name = "mountain2_2",
        res = "UI/alpha/1080P/main/map/style_common/mountain2_2.png",
        pos = ccp(1440, 265),
        order = 10
      },
      {
        name = "mountain2_3",
        res = "UI/alpha/1080P/main/map/style_common/mountain2_3.png",
        pos = ccp(2400, 265),
        order = 10
      },
      {
        name = "left_cloud1_1",
        res = "UI/alpha/1080P/main/map/style_common/cloud1_1.png",
        pos = ccp(-1775, 494.5),
        dest = ccp(mapSize.width, 494.5),
        order = 30
      },
      {
        name = "left_cloud1_2",
        res = "UI/alpha/1080P/main/map/style_common/cloud1_2.png",
        pos = ccp(-985, 494.5),
        dest = ccp(mapSize.width + 790, 494.5),
        order = 30
      },
      {
        name = "left_cloud1_3",
        res = "UI/alpha/1080P/main/map/style_common/cloud1_3.png",
        pos = ccp(-195, 494.5),
        dest = ccp(mapSize.width + 1580, 494.5),
        order = 35
      },
      {
        name = "right_cloud1_1",
        res = "UI/alpha/1080P/main/map/style_common/cloud1_1.png",
        pos = ccp(595, 494.5),
        dest = ccp(mapSize.width, 494.5),
        order = 30
      },
      {
        name = "right_cloud1_2",
        res = "UI/alpha/1080P/main/map/style_common/cloud1_2.png",
        pos = ccp(1385, 494.5),
        dest = ccp(mapSize.width + 790, 494.5),
        order = 30
      },
      {
        name = "right_cloud1_3",
        res = "UI/alpha/1080P/main/map/style_common/cloud1_3.png",
        pos = ccp(2175, 494.5),
        dest = ccp(mapSize.width + 1580, 494.5),
        order = 35
      },
      {
        name = "left_cloud2_1",
        res = "UI/alpha/1080P/main/map/style_common/cloud2_1.png",
        pos = ccp(-1517, 508),
        dest = ccp(mapSize.width, 508),
        order = 35
      },
      {
        name = "left_cloud2_2",
        res = "UI/alpha/1080P/main/map/style_common/cloud2_2.png",
        pos = ccp(-758, 508),
        dest = ccp(mapSize.width + 759, 508),
        order = 35
      },
      {
        name = "left_cloud2_3",
        res = "UI/alpha/1080P/main/map/style_common/cloud2_3.png",
        pos = ccp(1, 508),
        dest = ccp(mapSize.width + 1518, 508),
        order = 35
      },
      {
        name = "right_cloud2_1",
        res = "UI/alpha/1080P/main/map/style_common/cloud2_1.png",
        pos = ccp(760, 508),
        dest = ccp(mapSize.width, 508),
        order = 35
      },
      {
        name = "right_cloud2_2",
        res = "UI/alpha/1080P/main/map/style_common/cloud2_2.png",
        pos = ccp(1519, 508),
        dest = ccp(mapSize.width + 759, 508),
        order = 35
      },
      {
        name = "right_cloud2_3",
        res = "UI/alpha/1080P/main/map/style_common/cloud2_3.png",
        pos = ccp(2278, 508),
        dest = ccp(mapSize.width + 1518, 508),
        order = 35
      }
    }
  },
  [MapLayerDefine.Middle] = {
    damping = 0.32,
    commponents = {
      {
        name = "mountain1_1",
        res = "UI/alpha/1080P/main/map/style_common/mountain1_1.png",
        pos = ccp(480, 250),
        order = 10
      },
      {
        name = "mountain1_2",
        res = "UI/alpha/1080P/main/map/style_common/mountain1_2.png",
        pos = ccp(1440, 250),
        order = 20
      },
      {
        name = "mountain1_3",
        res = "UI/alpha/1080P/main/map/style_common/mountain1_3.png",
        pos = ccp(2400, 250),
        order = 20
      },
      {
        name = "island",
        res = "UI/alpha/1080P/main/map/style_common/island.png",
        pos = ccp(1500, 342),
        order = 50
      }
    }
  },
  [MapLayerDefine.Front] = {
    damping = 0,
    commponents = {
      {
        name = "front_bg1",
        res = "UI/alpha/1080P/main/map/style_common/front_bg1.png",
        pos = ccp(480, 360),
        order = 0
      },
      {
        name = "front_bg2",
        res = "UI/alpha/1080P/main/map/style_common/front_bg2.png",
        pos = ccp(1440, 360),
        order = 0
      },
      {
        name = "front_bg3",
        res = "UI/alpha/1080P/main/map/style_common/front_bg3.png",
        pos = ccp(2400, 360),
        order = 0
      }
    }
  },
  [MapLayerDefine.Top] = {
    damping = 0,
    commponents = {}
  }
}
local BuilddingTypeDefine = {
  Summon = 10,
  Chapter = 20,
  Mailbox = 30,
  Crusade = 40,
  Pvp = 50,
  Dreamland = 60,
  Guild = 70,
  Enhance = 80,
  SpaceVortex = 90,
  Tree = 100,
  Exercise = 110,
  Shop = 120,
  Ranking = 130,
  SkillTower = 140,
  PeakArena = 150,
  AwakeDungeon = 160,
  Tavern = 170,
  Rogue = 180,
  Pet = 190,
  LegendEquipForge = 200,
  PirateShop = 210
}
local tb = {}
for k, v in pairs(BuilddingTypeDefine) do
  tb[k] = v
  tb[v] = k
end
BuilddingTypeDefine = tb
local buildingsConfigs = {
  [BuilddingTypeDefine.Summon] = {
    res = "eff_UI_Main_SummonCircle",
    pos = ccp(1540, 120),
    scale = 0.9,
    touchCenter = ccp(0, 20),
    touchRadius = 90,
    titleRes = T("\229\143\172\229\148\164\230\179\149\233\152\181"),
    titleNotOpenRes = T("\229\143\172\229\148\164\230\179\149\233\152\181"),
    titlePos = ccp(1540, 75),
    lightPos = ccp(0, 48),
    lightSize = CCSizeMake(400, 300),
    layer = MapLayerDefine.Top,
    openViewIdentity = "summonScene",
    getRedPointStatus = function()
      return ed.summonMgr:getRedFlag()
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 1
  },
  [BuilddingTypeDefine.Chapter] = {
    res = "eff_UI_Main_Pve",
    pos = ccp(1240, 240),
    scale = 0.75,
    touchCenter = ccp(-10, 0),
    touchRadius = 110,
    titleRes = T("\230\136\152\229\189\185"),
    titleNotOpenRes = T("\230\136\152\229\189\185"),
    titlePos = ccp(1240, 140),
    lightPos = ccp(0, 9),
    lightSize = CCSizeMake(517, 400),
    layer = MapLayerDefine.Top,
    openViewIdentity = "stageSelect",
    getRedPointStatus = function()
      return ed.ui.stageselectres.getStageStarBoxRed()
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 1
  },
  [BuilddingTypeDefine.Mailbox] = {
    res = "eff_UI_Main_Mailbox",
    default_action = "Empty",
    scale = 0.7,
    gap_min = 2,
    gap_max = 4,
    pos = ccp(1070, 70),
    touchCenter = ccp(0, 40),
    touchRadius = 60,
    titleRes = T("\233\130\174\231\174\177"),
    titleNotOpenRes = T("\233\130\174\231\174\177"),
    titlePos = ccp(1070, 40),
    lightPos = ccp(-6, 45),
    lightSize = CCSizeMake(200, 200),
    layer = MapLayerDefine.Top,
    openViewIdentity = "mailbox",
    getRedPointStatus = function()
      return ed.player:checkunreadMail()
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 1
  },
  [BuilddingTypeDefine.Crusade] = {
    res = "eff_UI_Main_Volcano",
    scale = 0.95,
    pos = ccp(1220, 440),
    touchCenter = ccp(3, -50),
    touchRadius = 120,
    titleRes = T("\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129"),
    titleNotOpenRes = T("\232\139\177\233\155\132\231\154\132\232\191\156\229\190\129"),
    titlePos = ccp(1218, 300),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(400, 400),
    priority = 102,
    layer = MapLayerDefine.Middle,
    order = 51,
    openViewIdentity = "crusade",
    getRedPointStatus = function()
      return false
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 25
  },
  [BuilddingTypeDefine.Pvp] = {
    res = "eff_UI_Main_Pvp",
    pos = ccp(1720, 260),
    scale = 0.82,
    touchCenter = ccp(-15, 0),
    touchRadius = 90,
    titleRes = T("\231\171\158\230\138\128\229\156\186"),
    titleNotOpenRes = T("\231\171\158\230\138\128\229\156\186"),
    titlePos = ccp(1690, 180),
    lightPos = ccp(0, 40),
    bubblePos = ccp(55, 18),
    getBubbleShow = function()
      return ed.activityHints.data:getPvpActivityShow()
    end,
    getBubbleText = function()
      local pvpActivityInfo = ed.activityHints.data:getPvpActivityInfo()
      return pvpActivityInfo and pvpActivityInfo.bubbleText
    end,
    extraMaskPos = ccp(-80, -63),
    getExtraMaskShow = function()
      return ed.activityHints.data:getPvpActivityShow()
    end,
    getExtraMaskPath = function()
      local pvpActivityInfo = ed.activityHints.data:getPvpActivityInfo()
      return pvpActivityInfo and pvpActivityInfo.activityIcon
    end,
    lightSize = CCSizeMake(350, 400),
    layer = MapLayerDefine.Top,
    openViewIdentity = "PVP",
    getRedPointStatus = function()
      local data = ed.queryNotifyData("PvpNotifyData")
      return data and data._is_attacked == 1
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 5
  },
  [BuilddingTypeDefine.Dreamland] = {
    res = "eff_UI_Main_dreamland",
    pos = ccp(1800, 450),
    scale = 0.65,
    touchCenter = ccp(0, -20),
    touchRadius = 120,
    titleRes = T("\230\176\184\231\148\159\230\162\166\229\162\131"),
    titleNotOpenRes = T("\230\176\184\231\148\159\230\162\166\229\162\131"),
    titlePos = ccp(1800, 335),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(350, 400),
    layer = MapLayerDefine.Middle,
    order = 100,
    openViewIdentity = "dreamland",
    getRedPointStatus = function()
      return false
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 45
  },
  [BuilddingTypeDefine.Tavern] = {
    res = "eff_UI_Main_Tavern",
    spine = true,
    default_action = "Idle",
    pos = ccp(2360, 225),
    scale = 0.375,
    touchCenter = ccp(0, 50),
    touchRadius = 200,
    titleRes = T("\233\133\146\233\166\134"),
    titleNotOpenRes = T("\233\133\146\233\166\134"),
    titlePos = ccp(2360, 185),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(350, 400),
    layer = MapLayerDefine.Top,
    order = 100,
    openViewIdentity = ed.isAreaOverSea() and "AutoChessArenaScene" or "TavernScene",
    getRedPointStatus = function()
      local key = ed.getRoleKey("cricketFirstRed")
      return ed.redPointMgr.getInstance():getNodeValue("tavern_entry") > 0 or not ed.storage.getBool(key) and not ed.isAreaOverSea()
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 10
  },
  [BuilddingTypeDefine.Guild] = {
    res = "eff_UI_Main_Guild",
    pos = ccp(2130, 220),
    scale = 0.8,
    touchCenter = ccp(-20, 13),
    touchRadius = 120,
    titleRes = T("\229\133\172\228\188\154"),
    titleNotOpenRes = T("\229\133\172\228\188\154"),
    titlePos = ccp(2103, 140),
    lightPos = ccp(0, 48),
    lightSize = CCSizeMake(400, 300),
    layer = MapLayerDefine.Top,
    openViewIdentity = "guildScene",
    getRedPointStatus = function()
      if ed.GuildManager.guildJoinNotify then
        return true
      end
      local redInfo = ed.GuildManager:getShowRecruitRed()
      return (ed.GuildManager.guildRecruitNotify == 2 or redInfo.subRed or redInfo.entryRed or redInfo.guideSubRed) and ed.GuildManager.guildRecruitNotify and ed.GuildManager.guildRecruitNotify == 1 or ed.redPointMgr.getInstance():getNodeValue(" guild_weeklyjob_enter") > 0 or ed.GuildMountManager:getRedFlag()
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 9
  },
  [BuilddingTypeDefine.Exercise] = {
    res = "eff_UI_Main_Exercise",
    pos = ccp(1830, 150),
    scale = 0.75,
    touchCenter = ccp(0, 0),
    touchRadius = 70,
    titleRes = T("\232\139\177\233\155\132\232\175\149\231\130\188"),
    titleNotOpenRes = T("\232\139\177\233\155\132\232\175\149\231\130\188"),
    titlePos = ccp(1830, 90),
    lightPos = ccp(0, 48),
    lightSize = CCSizeMake(400, 300),
    layer = MapLayerDefine.Top,
    openViewIdentity = "exerciseMainScene",
    getRedPointStatus = function()
      return false
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 20
  },
  [BuilddingTypeDefine.Shop] = {
    res = "eff_UI_Main_Shop",
    pos = ccp(920, 235),
    scale = 0.8,
    touchCenter = ccp(0, 0),
    touchRadius = 95,
    titleRes = T("\229\149\134\229\186\151"),
    titleNotOpenRes = T("\229\149\134\229\186\151"),
    titlePos = ccp(900, 155),
    lightPos = ccp(0, 48),
    lightSize = CCSizeMake(400, 300),
    layer = MapLayerDefine.Top,
    openViewIdentity = "shopMain",
    getRedPointStatus = function()
      return ed.exteriorShopData.redNum and ed.exteriorShopData.redNum > 0
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 5
  },
  [BuilddingTypeDefine.Ranking] = {
    res = "eff_UI_Main_Rank",
    pos = ccp(1035, 289),
    scale = 0.8,
    touchCenter = ccp(0, 43),
    touchRadius = 70,
    titleRes = T("\230\142\146\232\161\140\230\166\156"),
    titleNotOpenRes = T("\230\142\146\232\161\140\230\166\156"),
    titlePos = ccp(1035, 395),
    lightPos = ccp(0, 48),
    lightSize = CCSizeMake(400, 300),
    layer = MapLayerDefine.Top,
    openViewIdentity = "ranklist",
    getRedPointStatus = function()
      return false
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 1
  },
  [BuilddingTypeDefine.SkillTower] = {
    res = "eff_UI_Main_fancytower",
    pos = ccp(1506, 473),
    scale = 0.73,
    touchCenter = ccp(0, -30),
    touchRadius = 110,
    bubblePos = ccp(70, -70),
    titleRes = T("\229\185\187\229\162\131\228\185\139\229\161\148"),
    titleNotOpenRes = T("\229\185\187\229\162\131\228\185\139\229\161\148"),
    titlePos = ccp(1510, 345),
    lightPos = ccp(0, 48),
    lightSize = CCSizeMake(400, 390),
    layer = MapLayerDefine.Middle,
    order = 100,
    openViewIdentity = "SkillTowerScene",
    getRedPointStatus = function()
      return false
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 30
  },
  [BuilddingTypeDefine.AwakeDungeon] = {
    res = "eff_UI_Main_Dungeon",
    spine = true,
    pos = ccp(340, 190),
    scale = 0.42,
    touchCenter = ccp(0, 36),
    touchRadius = 180,
    titleRes = T("\229\156\176\229\186\149\229\142\134\233\153\169"),
    titleNotOpenRes = T("\229\156\176\229\186\149\229\142\134\233\153\169"),
    titlePos = ccp(340, 150),
    lightPos = ccp(340, 150),
    lightSize = CCSizeMake(400, 390),
    layer = MapLayerDefine.Top,
    order = 100,
    openViewIdentity = "awakeDungeonScene",
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("awake_dungeon_entry") > 0
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 30,
    checkIsOpenBeforeLevel = function()
      local isOpen, reason = ed.awakeDungeonMgr.getInstance():awakeDungeonIsOpen()
      if not isOpen then
        ed.redPointMgr.getInstance():setNodeValue("awake_dungeon_entry", 0)
        if reason then
          ed.showToast(reason)
        end
        return false
      end
      return true
    end
  },
  [BuilddingTypeDefine.PeakArena] = {
    res = "eff_UI_Main_PeakArena",
    spine = true,
    pos = ccp(600, 100),
    scale = 0.48,
    touchCenter = ccp(0, 50),
    touchRadius = 185,
    titleRes = T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186"),
    titleNotOpenRes = T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186"),
    titlePos = ccp(600, 60),
    lightPos = ccp(600, 60),
    lightSize = CCSizeMake(400, 390),
    bubblePos = ccp(100, 150),
    layer = MapLayerDefine.Top,
    order = 100,
    openViewIdentity = "PeakArenaPvpScene",
    getRedPointStatus = function()
      return ed.PeakArenaRedDotTree:getFlag(ed.PeakArenaRedDotTreeKeys.ArenaBuilding)
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 30
  },
  [BuilddingTypeDefine.Rogue] = {
    res = "eff_UI_Main_Rogue",
    spine = true,
    pos = ccp(700, 283),
    scale = 0.48,
    touchCenter = ccp(0, 50),
    touchRadius = 185,
    titleRes = T("\229\185\187\228\185\166\229\165\135\232\176\173"),
    titleNotOpenRes = T("\229\185\187\228\185\166\229\165\135\232\176\173"),
    titlePos = ccp(700, 280),
    lightPos = ccp(700, 280),
    lightSize = CCSizeMake(400, 390),
    bubblePos = ccp(100, 150),
    layer = MapLayerDefine.Top,
    order = 100,
    openViewIdentity = "rogueMainScene",
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("rogue_entry") > 0
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 80
  },
  [BuilddingTypeDefine.LegendEquipForge] = not ed.isAreaOverSea() and {
    res = "eff_UI_Main_LegendForgeNormal",
    spine = true,
    pos = ccp(480, 338.5),
    scale = 0.38,
    touchCenter = ccp(0, 60),
    touchRadius = 190,
    titleRes = T("\232\191\156\229\143\164\231\134\148\231\130\137"),
    titleNotOpenRes = T("\232\191\156\229\143\164\231\134\148\231\130\137"),
    titlePos = ccp(480, 350),
    lightPos = ccp(480, 350),
    lightSize = CCSizeMake(400, 390),
    bubblePos = ccp(100, 150),
    layer = MapLayerDefine.Middle,
    order = 100,
    priority = 102,
    openViewIdentity = "fireForgeMainScene",
    getRedPointStatus = function()
      return ed.redPointMgr.getInstance():getNodeValue("fire_forge_entry") > 0
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 80
  } or nil,
  [BuilddingTypeDefine.PirateShop] = {
    res = "eff_UI_Main_Coco",
    spine = true,
    pos = ccp(830, 35),
    scale = 0.48,
    touchCenter = ccp(0, 50),
    touchRadius = 185,
    titleRes = T("\231\165\158\231\167\152\230\181\183\231\155\151"),
    titleNotOpenRes = T("\231\165\158\231\167\152\230\181\183\231\155\151"),
    titlePos = ccp(830, 25),
    lightPos = ccp(830, 25),
    lightSize = CCSizeMake(400, 300),
    bubblePos = ccp(100, 150),
    layer = MapLayerDefine.Top,
    order = 100,
    openViewIdentity = "pirateshopScene",
    getRedPointStatus = function()
      return ed.pirateshopManager.redShow
    end,
    onClick = function()
      ed.playEffect(ed.sound.deo.common_click_feedback)
    end,
    visibleLevel = 1,
    titleVisibleLevel = 50
  }
}
local sceneEffectsConfigs = {
  {
    res = "eff_UI_Main_Tree",
    pos = ccp(1310, 400),
    scale = 0.75,
    layer = MapLayerDefine.Top
  }
}
local fireworkEffectConfig = {
  [1] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(2100, 450),
      ccp(2070, 480),
      ccp(2038, 475),
      ccp(2000, 515),
      ccp(1978, 460),
      ccp(1945, 485),
      ccp(1912, 510),
      ccp(1890, 505)
    },
    scaleRange = {0.2, 0.4},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  },
  [2] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(1850, 511),
      ccp(1803, 460),
      ccp(1789, 477),
      ccp(1755, 501),
      ccp(1723, 494),
      ccp(1700, 488),
      ccp(1682, 516),
      ccp(1655, 505)
    },
    scaleRange = {0.25, 0.4},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  },
  [3] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(1627, 467),
      ccp(1603, 483),
      ccp(1577, 475),
      ccp(1549, 508),
      ccp(1516, 460),
      ccp(1500, 500),
      ccp(1480, 490),
      ccp(1460, 505)
    },
    scaleRange = {0.3, 0.45},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  },
  [4] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(1430, 499),
      ccp(1402, 484),
      ccp(1381, 503),
      ccp(1365, 450),
      ccp(1330, 469),
      ccp(1300, 504),
      ccp(1280, 495),
      ccp(1275, 471)
    },
    scaleRange = {0.3, 0.45},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  },
  [5] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(1244, 420),
      ccp(1210, 400),
      ccp(1192, 395),
      ccp(1165, 413),
      ccp(1120, 405),
      ccp(1086, 399),
      ccp(1046, 409),
      ccp(1000, 401),
      ccp(960, 407),
      ccp(925, 402)
    },
    scaleRange = {0.2, 0.4},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  },
  [6] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(900, 405),
      ccp(860, 395),
      ccp(833, 403),
      ccp(801, 390),
      ccp(769, 400),
      ccp(723, 405),
      ccp(675, 400),
      ccp(623, 490),
      ccp(600, 500)
    },
    scaleRange = {0.25, 0.45},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  },
  [7] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(580, 510),
      ccp(549, 495),
      ccp(512, 503),
      ccp(477, 480),
      ccp(452, 512),
      ccp(438, 499),
      ccp(409, 500),
      ccp(375, 495),
      ccp(368, 503)
    },
    scaleRange = {0.15, 0.45},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  },
  [8] = {
    res = "eff_UI_Fireworks_2",
    posGroup = {
      ccp(355, 470),
      ccp(315, 459),
      ccp(288, 438),
      ccp(253, 450),
      ccp(222, 460)
    },
    scaleRange = {0.2, 0.35},
    zOrder = 100,
    layer = MapLayerDefine.Bottom
  }
}
local defaultOffsetX = -1000
return {
  layerDefine = MapLayerDefine,
  builddingType = BuilddingTypeDefine,
  mapLayersConfigs = mapLayersConfigs,
  buildingsConfigs = buildingsConfigs,
  sceneEffectsConfigs = sceneEffectsConfigs,
  mapSize = mapSize,
  dragModeJudgeDistance = dragModeJudgeDistance,
  dragInertanceGap = dragInertanceGap,
  defaultOffsetX = defaultOffsetX,
  limitX = limitX,
  fireworkEffectConfig = fireworkEffectConfig,
  drawTouchCircle = false
}
