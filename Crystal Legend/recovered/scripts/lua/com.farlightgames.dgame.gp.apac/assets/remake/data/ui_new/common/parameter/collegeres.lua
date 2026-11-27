local base = ed.ui.uires
local class = newclass(base.mt)
ed.ui.collegeres = class
class.techptx = {
  [1] = 330,
  [2] = 445,
  [3] = 560,
  [4] = 675
}
class.disx = class.techptx[2] - class.techptx[1]
class.techpty = {
  [1] = 321,
  [2] = 291,
  [3] = 261,
  [4] = 231,
  [5] = 201
}
class.disy = class.techpty[1] - class.techpty[3]
class.iconPos = {
  [1] = {613, 65},
  [2] = {613, 95},
  [3] = {613, 125},
  [4] = {710, 125}
}
class.resTbl = {
  Iron = "iron",
  Wood = "wood",
  Crystal = "crystal",
  Gold = "gold"
}
class.iconTbl = {
  Gold = "UI/alpha/1080P/common/goldicon_small.png",
  Iron = "UI/alpha/HVGA/warschool/resource_iron.png",
  Wood = "UI/alpha/HVGA/warschool/resource_wood.png",
  Crystal = "UI/alpha/HVGA/warschool/resource_crystal.png"
}
class.buildingTbl = {
  [1] = T("\230\136\152\228\186\137\229\173\166\233\153\162"),
  [2] = T("\230\136\152\228\186\137\231\134\148\231\130\137"),
  [3] = T("\230\136\152\228\186\137\229\183\165\229\157\138"),
  [4] = T("\229\141\154\229\173\166\231\164\190"),
  [5] = T("\232\180\184\230\152\147\229\184\130\233\155\134"),
  [6] = T("\230\130\172\232\181\143\230\160\143")
}
class.font_red = ccc3(255, 35, 35)
class.font_green = ccc3(119, 255, 92)
class.font_gray = ccc3(67, 59, 56)
class.font_gray_2 = ccc3(147, 142, 119)
class.font_white = ccc3(255, 255, 255)
class.font_yellow = ccc3(241, 193, 113)
class.font_yellow_2 = ccc3(251, 206, 16)
class.redpt_tag = 101
class.icon_side = 61
class.background = {
  BottomMap = {
    {
      t = "Sprite",
      base = {
        name = "bg1_left1",
        res = ed.main.mainresManager.spriteRes.main_bg_sky_left_part_1
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {scale = 2}
    },
    {
      t = "Sprite",
      base = {
        name = "bg1_left",
        res = ed.main.mainresManager.spriteRes.main_bg_sky_left_part_2
      },
      layout = {
        anchor = ccp(0, 0)
      },
      config = {scale = 2}
    }
  },
  BottomMapCloud = {
    {
      t = "Sprite",
      base = {
        name = "cloud1",
        res = ed.main.mainresManager.spriteRes.main_cloud_1
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(400, 255)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "cloud2",
        res = ed.main.mainresManager.spriteRes.main_cloud_2
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(850, 265)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "cloud3",
        res = ed.main.mainresManager.spriteRes.main_cloud_3
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(850, 370)
      },
      config = {}
    }
  },
  HideLeft = {
    {
      t = "Sprite",
      base = {
        name = "bg_hideleft2",
        res = ed.main.mainresManager.spriteRes.main_bg_grass_school_2
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(-407, 0)
      },
      config = {fix_height = 480}
    },
    {
      t = "Sprite",
      base = {
        name = "bg_hideleft1",
        res = ed.main.mainresManager.spriteRes.main_bg_grass_school_1
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(272, 0)
      }
    }
  }
}
class.drag_range = {
  x = {min = -40, max = 405},
  y = {min = 0, max = 0}
}
class.drag_mode_judge_range = 50
class.sky_coefficient = 0.3
class.res_pos = {
  warterritory = {
    res = "eff_UI_School_guidepost_1",
    pos = ccp(1135, 285),
    scale = 0.8,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 80,
    titleres = "UI/alpha/HVGA/main_school_title.png",
    titlePressres = "UI/alpha/HVGA/main_school_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_school_title_unavailable.png",
    titlePos = ccp(-5, -45),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(400, 400)
  },
  warterritoryout = {
    res = "eff_UI_School_guidepost_2",
    pos = ccp(160, 220),
    scale = 0.7,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 60,
    titleres = "UI/alpha/HVGA/main_home_title.png",
    titlePressres = "UI/alpha/HVGA/main_home_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_home_title_unavailable.png",
    titlePos = ccp(2, -42),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(400, 400)
  },
  warschool = {
    res = "eff_UI_Main_School",
    default_action = "lv1_Work",
    pos = ccp(30, 180),
    scale = 0.7,
    gap_min = 1.6,
    gap_max = 1.6,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(10, 0),
    touchRadius = 80,
    titleres = "UI/alpha/HVGA/main_school_school_title.png",
    titlePressres = "UI/alpha/HVGA/main_school_school_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_school_school_title_unavailable.png",
    titlePos = ccp(5, -125),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(250, 250)
  },
  warmake = {
    res = "eff_UI_Main_forge2",
    default_action = "lv1_Idle",
    pos = ccp(350, 245),
    scale = 0.65,
    gap_min = 1.6,
    gap_max = 1.6,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 80,
    titleres = "UI/alpha/HVGA/main_school_forge_title.png",
    titlePressres = "UI/alpha/HVGA/main_school_forge_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_school_forge_title_unavailable.png",
    titlePos = ccp(-5, -100),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(250, 250)
  },
  wardecompose = {
    res = "eff_UI_Main_forge",
    default_action = "lv1_Work",
    pos = ccp(-220, 170),
    scale = 0.7,
    gap_min = 1.6,
    gap_max = 1.6,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 80,
    titleres = "UI/alpha/HVGA/main_school_smelter_title.png",
    titlePressres = "UI/alpha/HVGA/main_school_smelter_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_school_smelter_title_unavailable.png",
    titlePos = ccp(5, -80),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(250, 250)
  },
  warresource = {
    res = "eff_UI_TeamTerritory_Market",
    default_action = "lv1_Loop",
    pos = ccp(690, 240),
    scale = 0.32,
    gap_min = 2.1,
    gap_max = 2.1,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 200,
    titleres = "UI/alpha/HVGA/main_resourceshop_title.png",
    titlePressres = "UI/alpha/HVGA/main_resourceshop_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_resourceshop_title_unavailable.png",
    titlePos = ccp(0, -75),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(750, 750)
  },
  riverflow = {
    res = "eff_UI_Main_River",
    pos = ccp(32, 142),
    scale = 1,
    gap_min = 1,
    gap_max = 1,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0
  },
  readinghouse = {
    res = "eff_UI_Main_Book",
    highlight_startAction = "Start_LvUp",
    highlight_loopAction = "Loop_LvUp",
    pos = ccp(142, 110),
    scale = 0.35,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    touchCenter = ccp(0, 0),
    touchRadius = 80,
    titleres = "UI/alpha/HVGA/school_learned_title.png",
    titlePressres = "UI/alpha/HVGA/school_learned_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/school_learned_title_unavailable.png",
    titlePos = ccp(10, -55),
    lightPos = ccp(0, 0),
    lightSize = CCSizeMake(400, 400)
  },
  warchef = {
    res = "eff_UI_chef_improved",
    pos = ccp(525, 120),
    scale = 0.15,
    default_action = "Idle",
    default_loop = true,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    titleres = "UI/alpha/HVGA/main_chief_title.png",
    titlePressres = "UI/alpha/HVGA/main_chief_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_chief_title_unablailable.png",
    titlePos = ccp(10, -28),
    touchCenter = ccp(-10, 40),
    touchRadius = 500
  },
  pethouse = {
    res = "eff_UI_Main_Pethouse",
    pos = ccp(525, 335),
    scale = 0.3,
    default_action = "Loop",
    default_loop = true,
    loop_gap = 0,
    loop_times_min = 0,
    loop_times_max = 0,
    titleres = "UI/alpha/HVGA/main_pethouse_title.png",
    titlePressres = "UI/alpha/HVGA/main_pethouse_title_press.png",
    titlenotopenres = "UI/alpha/HVGA/main_pethouse_title_unavailable.png",
    titlePos = ccp(10, -75),
    touchCenter = ccp(0, 0),
    touchRadius = 250
  }
}
class.button_key = {
  "warterritory",
  "warterritoryout",
  "warschool",
  "wardecompose",
  "warmake",
  "warresource",
  "readinghouse",
  "warchef",
  "pethouse"
}
class.red_light = {
  {
    t = "Sprite",
    base = {
      name = "warschoolRedLight",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      z = 11
    },
    layout = {
      position = ccp(class.res_pos.warschool.pos.x + 57, class.res_pos.warschool.pos.y - 112)
    },
    config = {visible = false}
  },
  {
    t = "Sprite",
    base = {
      name = "wardecomposeRedLight",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      z = 11
    },
    layout = {
      position = ccp(class.res_pos.wardecompose.pos.x + 53, class.res_pos.wardecompose.pos.y - 68)
    },
    config = {visible = false}
  },
  {
    t = "Sprite",
    base = {
      name = "warmakeRedLight",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      z = 11
    },
    layout = {
      position = ccp(class.res_pos.warmake.pos.x + 43, class.res_pos.warmake.pos.y - 92)
    },
    config = {visible = false}
  },
  {
    t = "Sprite",
    base = {
      name = "readinghouseRedLight",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      z = 11
    },
    layout = {
      position = ccp(class.res_pos.readinghouse.pos.x + class.res_pos.readinghouse.titlePos.x + 46, class.res_pos.readinghouse.pos.y + class.res_pos.readinghouse.titlePos.y + 8)
    },
    config = {visible = false}
  },
  {
    t = "Sprite",
    base = {
      name = "warresourceRedLight",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      z = 11
    },
    layout = {
      position = ccp(class.res_pos.warresource.pos.x + class.res_pos.warresource.titlePos.x + 46, class.res_pos.warresource.pos.y + class.res_pos.warresource.titlePos.y + 8)
    },
    config = {visible = false}
  },
  {
    t = "Sprite",
    base = {
      name = "pethouseRedLight",
      res = "UI/alpha/HVGA/main_deal_tag.png",
      z = 11
    },
    layout = {
      position = ccp(class.res_pos.pethouse.pos.x + 57, class.res_pos.pethouse.pos.y - 64)
    },
    config = {visible = false}
  }
}
