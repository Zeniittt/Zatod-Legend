ed.uieditor = ed.uieditor or {}
ed.uieditor.moonFestivalRewardScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_bg.jpg",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131.5, h = 173.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_building_left.png",
      name = "left_building",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 401.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 246.5, h = 280},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_mountain_right.png",
      name = "right_mountain1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1078.5, 412.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 285, h = 118},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_mountain_left.png",
      name = "left_mountain",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(346.5, 362.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 245.5, h = 114.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_mountain2_left.png",
      name = "right_mountain2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(839, 348.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 544, h = 237.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_left_village.png",
      name = "left_village",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(272, 283.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 626, h = 252},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_right_village.png",
      name = "right_village",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(856.5, 313)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 432, h = 402},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_moon.png",
      name = "moon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(588, 566)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 355.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_yard_floor.png",
      name = "floor",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 178)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 174.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_floor.png",
      name = "front_floor",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 881, h = 124},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_table.png",
      name = "table",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(582, 121.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "ui_layer",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105.5, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.5, h = 101.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light1.png",
      name = "light1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(341.5, 554)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51, h = 57.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light2.png",
      name = "light2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(820.5, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light3.png",
      name = "light3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(247.5, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 77.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light4.png",
      name = "light4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, 480.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light5.png",
      name = "light5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(813.5, 359.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = -0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = -21.85, h = 30.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light5.png",
      name = "light6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(389, 339.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.7, h = 28.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light5.png",
      name = "light7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(754, 313)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = -0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = -20.7, h = 28.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_light5.png",
      name = "light8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(704, 359.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 275.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_door.png",
      name = "left_door_1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-34.5, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -275.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_door.png",
      name = "right_door_1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1205, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -275.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_door.png",
      name = "right_door_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(960, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 275.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_door.png",
      name = "left_door_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.5, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 275.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_door.png",
      name = "left_door_3",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455.5, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -275.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_door.png",
      name = "right_door_3",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(715, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_big.png",
      name = "point1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(941.5, 384)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_big.png",
      name = "point2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 514.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_big.png",
      name = "point3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1087, 492)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.75, h = 7.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_big.png",
      name = "point4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(907.5, 430)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.75, h = 7.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_big.png",
      name = "point5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(848, 522)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(859.5, 411.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(859.5, 411.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 5.5, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(729.5, 413)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6.6, h = 6.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point9",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(409.5, 445.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 5.5, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point10",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306.5, 476.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 5.5, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point11",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265, 431)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point12",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(158, 467)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_medium.png",
      name = "point13",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377.5, 400)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.75, h = 7.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_big.png",
      name = "point14",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 404.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 5.5, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_spot_small.png",
      name = "point15",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(196.5, 391)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 266.5, h = 160},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "floor",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_stone.png",
      name = "stone",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.5, 241.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1003.5, h = 614},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "floor",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_tree.png",
      name = "tree",
      z = 1
    },
    layout = {
      anchor = ccp(0.76, 0.15),
      position = ccp(1026.5, 270.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 196.5, h = 225.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "floor",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_bunny.png",
      name = "bunny",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(579.5, 254.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 20},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "floor",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_osmanthus1.png",
      name = "flower1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(727.5, 275.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 16.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "floor",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_osmanthus2.png",
      name = "flower2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(503, 287.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "floor",
      name = "flower_pos2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(507, 394.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(867.5, 150)
    },
    t = "Layer",
    base = {
      parent = "ui_layer",
      name = "reward_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(44, 56.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "floor",
      name = "flower_pos1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(755.5, 514.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ui_layer",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 507.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 198.5, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_time_bg.png",
      name = "left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138.25, -8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "flower_pos2",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_osmanthus2.png",
      name = "fall_flower2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "flower_pos1",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_osmanthus1.png",
      name = "fall_flower1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 26.5, h = 26.5},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_tips",
      z = 2,
      parent = "bg_title",
      text = "",
      press = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223.75, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_time_bg",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_time.png",
      name = "left_time_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_tips",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_207",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  }
}
