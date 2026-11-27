local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.exerciseres = class
class.entry_stage = {
  exp = 20001,
  money = 20002,
  int = 20003,
  agi = 20004,
  str = 20005,
  spring1 = 20006,
  spring2 = 20007,
  spring3 = 20008,
  spring4 = 20009,
  spring5 = 20010,
  spring6 = 20011,
  spring7 = 20012,
  artifact1 = 20014,
  artifact2 = 20013,
  artifact3 = 20015,
  artifact4 = 20016
}
local centerX, centerY = 75, 160
local disX = 40
class.entry = {
  {
    type = "equip",
    key = "int",
    fca = {"Golem.cha"},
    pos = {
      ccp(centerX, centerY - 15)
    },
    scale = {0.9},
    descres = "UI/alpha/HVGA/act/act_popup_title_2_1.png",
    descres_b = "UI/alpha/HVGA/act/act_popup_title_big_1.png",
    descres_s = "UI/alpha/HVGA/act/act_popup_title_small_1.png",
    f_bg = "UI/alpha/HVGA/act/act_popup_future_bg_1.png",
    gs = 2
  },
  {
    type = "equip",
    key = "agi",
    fca = {
      "DragonBaby.cha"
    },
    pos = {
      ccp(centerX, centerY - 10)
    },
    scale = {0.9},
    descres = "UI/alpha/HVGA/act/act_popup_title_3_1.png",
    descres_b = "UI/alpha/HVGA/act/act_popup_title_big_2.png",
    descres_s = "UI/alpha/HVGA/act/act_popup_title_small_2.png",
    f_bg = "UI/alpha/HVGA/act/act_popup_future_bg_2.png",
    gs = 2
  },
  {
    type = "equip",
    key = "str",
    fca = {
      "DR.cha",
      "Ench.cha",
      "WR.cha"
    },
    pos = {
      ccp(centerX, centerY + 13),
      ccp(centerX + 25, centerY - 13),
      ccp(centerX - 25, centerY - 13)
    },
    scale = {
      0.9,
      0.9,
      0.9
    },
    descres = "UI/alpha/HVGA/act/act_popup_title_5_1.png",
    descres_b = "UI/alpha/HVGA/act/act_popup_title_big_3.png",
    descres_s = "UI/alpha/HVGA/act/act_popup_title_small_3.png",
    f_bg = "UI/alpha/HVGA/act/act_popup_future_bg_3.png",
    gs = 2
  },
  {
    type = "artifact",
    key = "artifact4",
    fca = {"Earth.cha"},
    pos = {
      ccp(centerX, centerY - 15)
    },
    scale = {1},
    descres = "UI/alpha/HVGA/artifact/act_popup_title_earth.png",
    descres_b = "UI/alpha/HVGA/act/act_popup_title_big_4.png",
    descres_s = "UI/alpha/HVGA/act/act_popup_title_small_4.png",
    f_bg = "UI/alpha/HVGA/act/act_popup_future_bg_4.png",
    gs = 1
  },
  {
    type = "artifact",
    key = "artifact1",
    fca = {
      "FireElement.cha"
    },
    pos = {
      ccp(centerX, centerY - 15)
    },
    scale = {1},
    descres = "UI/alpha/HVGA/artifact/act_popup_title_fire.png",
    descres_b = "UI/alpha/HVGA/act/act_popup_title_big_5.png",
    descres_s = "UI/alpha/HVGA/act/act_popup_title_small_5.png",
    f_bg = "UI/alpha/HVGA/act/act_popup_future_bg_7.png",
    gs = 1
  },
  {
    type = "artifact",
    key = "artifact3",
    fca = {"Razor.cha"},
    pos = {
      ccp(centerX, centerY - 15)
    },
    scale = {1},
    descres = "UI/alpha/HVGA/artifact/act_popup_title_sky.png",
    descres_b = "UI/alpha/HVGA/act/act_popup_title_big_6.png",
    descres_s = "UI/alpha/HVGA/act/act_popup_title_small_6.png",
    f_bg = "UI/alpha/HVGA/act/act_popup_future_bg_6.png",
    gs = 1
  },
  {
    type = "artifact",
    key = "artifact2",
    fca = {
      "WaterElement.cha"
    },
    pos = {
      ccp(centerX, centerY - 15)
    },
    scale = {1},
    descres = "UI/alpha/HVGA/artifact/act_popup_title_water.png",
    descres_b = "UI/alpha/HVGA/act/act_popup_title_big_7.png",
    descres_s = "UI/alpha/HVGA/act/act_popup_title_small_7.png",
    f_bg = "UI/alpha/HVGA/act/act_popup_future_bg_5.png",
    gs = 1
  },
  {
    type = "spring",
    key = "spring1",
    fca = {"Loz.cha"},
    pos = {
      ccp(centerX, centerY)
    },
    scale = {1.2},
    descres = "UI/alpha/HVGA/act/act_spring_title_big_1.png",
    descres_s = "UI/alpha/HVGA/act/act_spring_title_small_1.png",
    gs = 3
  },
  {
    type = "spring",
    key = "spring2",
    fca = {
      "SilverDragon.cha"
    },
    fcaaction = "Idlefix",
    pos = {
      ccp(centerX, centerY)
    },
    scale = {0.7},
    descres = "UI/alpha/HVGA/act/act_spring_title_big_2.png",
    descres_s = "UI/alpha/HVGA/act/act_spring_title_small_2.png",
    gs = 3
  },
  {
    type = "spring",
    key = "spring3",
    fca = {
      "ExBossHuskar.cha"
    },
    pos = {
      ccp(centerX, centerY)
    },
    scale = {1.2},
    descres = "UI/alpha/HVGA/act/act_spring_title_big_3.png",
    descres_s = "UI/alpha/HVGA/act/act_spring_title_small_3.png",
    gs = 3
  },
  {
    type = "spring",
    key = "spring4",
    fca = {
      "ExPhoenix.cha"
    },
    shader = "FireShader",
    pos = {
      ccp(centerX, centerY)
    },
    scale = {1.2},
    descres = "UI/alpha/HVGA/act/act_spring_title_big_4.png",
    descres_s = "UI/alpha/HVGA/act/act_spring_title_small_4.png",
    gs = 3
  },
  {
    type = "spring",
    key = "spring5",
    fca = {
      "ExBossSpider.cha"
    },
    pos = {
      ccp(centerX - 5, centerY)
    },
    scale = {1.2},
    descres = "UI/alpha/HVGA/act/act_spring_title_big_5.png",
    descres_s = "UI/alpha/HVGA/act/act_spring_title_small_5.png",
    gs = 3
  },
  {
    type = "spring",
    key = "spring6",
    fca = {
      "ExBossSF.cha"
    },
    pos = {
      ccp(centerX, centerY - 10)
    },
    scale = {1.2},
    descres = "UI/alpha/HVGA/act/act_spring_title_big_6.png",
    descres_s = "UI/alpha/HVGA/act/act_spring_title_small_6.png",
    gs = 3
  },
  {
    type = "spring",
    key = "spring7",
    fca = {
      "ExBossZeus.cha"
    },
    pos = {
      ccp(centerX, centerY)
    },
    scale = {1.2},
    descres = "UI/alpha/HVGA/act/act_spring_title_big_7.png",
    descres_s = "UI/alpha/HVGA/act/act_spring_title_small_7.png",
    gs = 3
  }
}
class.equip = {
  uires = {
    frame = "UI/alpha/HVGA/stage-map-guildraid-frame.png",
    map = "UI/alpha/HVGA/act/act_map_bg_brown.png",
    titleShadow = "UI/alpha/HVGA/act/act_title_bg.png",
    titleBg = "UI/alpha/HVGA/equip_detail_title_bg.png",
    title = "UI/alpha/HVGA/act/act_title_1.png"
  },
  entry = {
    int = {
      fca = {"Golem.cha"},
      pos = {
        ccp(165, 162)
      },
      scale = {0.8},
      center = ccp(165, 162),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_popup_title_2_1.png",
      pos_cd = ccp(165, 63),
      font_info_cd = "cd_equip"
    },
    agi = {
      fca = {
        "DragonBaby.cha"
      },
      pos = {
        ccp(385, 162)
      },
      scale = {0.8},
      center = ccp(385, 162),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_popup_title_3_1.png",
      pos_cd = ccp(393, 73),
      font_info_cd = "cd_equip"
    },
    str = {
      fca = {
        "DR.cha",
        "Ench.cha",
        "WR.cha"
      },
      pos = {
        ccp(620, 197),
        ccp(645, 162),
        ccp(595, 162)
      },
      scale = {
        0.9,
        0.9,
        0.9
      },
      center = ccp(640, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_popup_title_5_1.png",
      pos_cd = ccp(628, 73),
      font_info_cd = "cd_equip"
    }
  }
}
class.artifact = {
  uires = {
    frame = "UI/alpha/HVGA/stage-map-guildraid-frame.png",
    map = "UI/alpha/HVGA/artifact/exercises_temple_0.png",
    titleShadow = "UI/alpha/HVGA/act/act_title_bg.png",
    titleBg = "UI/alpha/HVGA/equip_detail_title_bg.png",
    title = "UI/alpha/HVGA/artifact/exercise_temple_title.png"
  },
  entry = {
    artifact1 = {
      fca = {
        "FireElement.cha",
        "Phoenix.cha",
        "WL.cha"
      },
      pos = {
        ccp(10, 140),
        ccp(50, 188),
        ccp(90, 140)
      },
      scale = {
        0.8,
        0.8,
        0.8
      },
      center = ccp(50, 168),
      radius = 85,
      descres = "UI/alpha/HVGA/artifact/act_popup_title_fire.png",
      pos_cd = ccp(10, 73),
      font_info_cd = "cd_equip"
    },
    artifact2 = {
      fca = {
        "WaterElement.cha",
        "SG.cha",
        "NC.cha"
      },
      pos = {
        ccp(240, 200),
        ccp(280, 140),
        ccp(320, 200)
      },
      scale = {
        0.85,
        0.8,
        0.9
      },
      center = ccp(285, 165),
      radius = 85,
      descres = "UI/alpha/HVGA/artifact/act_popup_title_water.png",
      pos_cd = ccp(285, 73),
      font_info_cd = "cd_equip"
    },
    artifact3 = {
      fca = {
        "Kael.cha",
        "Luna.cha",
        "Razor.cha"
      },
      pos = {
        ccp(515, 190),
        ccp(480, 140),
        ccp(540, 140)
      },
      scale = {
        0.8,
        0.8,
        0.8
      },
      center = ccp(515, 170),
      radius = 85,
      descres = "UI/alpha/HVGA/artifact/act_popup_title_sky.png",
      pos_cd = ccp(550, 73),
      font_info_cd = "cd_equip"
    },
    artifact4 = {
      fca = {
        "Earth.cha",
        "Treant.cha",
        "Crusher.cha"
      },
      pos = {
        ccp(705, 195),
        ccp(770, 195),
        ccp(740, 140)
      },
      scale = {
        0.8,
        0.8,
        0.8
      },
      center = ccp(740, 170),
      radius = 85,
      descres = "UI/alpha/HVGA/artifact/act_popup_title_earth.png",
      pos_cd = ccp(750, 125),
      font_info_cd = "cd_equip"
    }
  }
}
class.spring = {
  uires = {
    frame = "UI/alpha/HVGA/act/act_spring_frame.png",
    map = "UI/alpha/HVGA/act/act_spring_bg.png",
    titleShadow = "UI/alpha/HVGA/act/act_title_bg.png",
    titleBg = "UI/alpha/HVGA/equip_detail_title_bg.png",
    title = "UI/alpha/HVGA/act/act_spring_title.png"
  },
  entry = {
    spring1 = {
      fca = {"Loz.cha"},
      pos = {
        ccp(400, 170)
      },
      scale = {1.2},
      center = ccp(400, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_spring_title_big_1.png",
      descres_s = "UI/alpha/HVGA/act/act_spring_title_small_1.png",
      pos_cd = ccp(380, 125),
      font_info_cd = "cd_em"
    },
    spring2 = {
      fca = {
        "SilverDragon.cha"
      },
      fcaaction = "Idlefix",
      pos = {
        ccp(400, 170)
      },
      scale = {0.7},
      center = ccp(400, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_spring_title_big_2.png",
      descres_s = "UI/alpha/HVGA/act/act_spring_title_small_2.png",
      pos_cd = ccp(380, 125),
      font_info_cd = "cd_em"
    },
    spring3 = {
      fca = {
        "ExBossHuskar.cha"
      },
      pos = {
        ccp(400, 170)
      },
      scale = {1.2},
      center = ccp(400, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_spring_title_big_3.png",
      descres_s = "UI/alpha/HVGA/act/act_spring_title_small_3.png",
      pos_cd = ccp(380, 125),
      font_info_cd = "cd_em"
    },
    spring4 = {
      fca = {
        "ExPhoenix.cha"
      },
      shader = "FireShader",
      pos = {
        ccp(400, 170)
      },
      scale = {1.2},
      center = ccp(400, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_spring_title_big_4.png",
      descres_s = "UI/alpha/HVGA/act/act_spring_title_small_4.png",
      pos_cd = ccp(380, 125),
      font_info_cd = "cd_em"
    },
    spring5 = {
      fca = {
        "ExBossSpider.cha"
      },
      pos = {
        ccp(400, 170)
      },
      scale = {1.2},
      center = ccp(400, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_spring_title_big_5.png",
      descres_s = "UI/alpha/HVGA/act/act_spring_title_small_5.png",
      pos_cd = ccp(380, 125),
      font_info_cd = "cd_em"
    },
    spring6 = {
      fca = {
        "ExBossSF.cha"
      },
      pos = {
        ccp(400, 170)
      },
      scale = {1.2},
      center = ccp(400, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_spring_title_big_6.png",
      descres_s = "UI/alpha/HVGA/act/act_spring_title_small_6.png",
      pos_cd = ccp(380, 125),
      font_info_cd = "cd_em"
    },
    spring7 = {
      fca = {
        "ExBossZeus.cha"
      },
      pos = {
        ccp(400, 170)
      },
      scale = {1.2},
      center = ccp(400, 185),
      radius = 85,
      descres = "UI/alpha/HVGA/act/act_spring_title_big_7.png",
      descres_s = "UI/alpha/HVGA/act/act_spring_title_small_7.png",
      pos_cd = ccp(380, 125),
      font_info_cd = "cd_em"
    }
  }
}
