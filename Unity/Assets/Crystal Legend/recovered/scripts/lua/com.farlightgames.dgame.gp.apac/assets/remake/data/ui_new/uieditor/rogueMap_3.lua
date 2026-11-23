ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueMap_3 = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 116, h = 76.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_birth_point.png",
      name = "room_00",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_1.png",
      name = "route_00_01",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 113.5)
    }
  },
  {
    config = {
      rotation = 5,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 208.5, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_2.png",
      name = "route_01_03",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(591.5, 185)
    }
  },
  {
    config = {
      rotation = -4.5,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 208.5, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_2.png",
      name = "route_01_02",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(369, 185)
    }
  },
  {
    config = {
      rotation = -2,
      fix_scale = {y = 1, x = 1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 208.5, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_2.png",
      name = "route_06_07",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(628.5, 411.5)
    }
  },
  {
    config = {
      rotation = 1,
      fix_scale = {y = 1, x = 1},
      flip = "xy",
      opacity = 255,
      fix_wh = {w = 208.5, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_2.png",
      name = "route_04_07",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355, 409)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "room_01",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_01",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_shade.png",
      name = "room_01_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 11.5, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_1.png",
      name = "route_07_99",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 453)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_01",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png",
      name = "room_01_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "room_02",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248, 242.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "room_03",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(711, 242)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "room_04",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(247.5, 358.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "room_05",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(596, 359)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "room_06",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(776, 358.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_1.png",
      name = "route_02_04",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(246.5, 285)
    }
  },
  {
    config = {
      rotation = -40,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_1.png",
      name = "route_03_05",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(651.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "room_07",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 440)
    }
  },
  {
    config = {
      rotation = 30,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_1.png",
      name = "route_03_06",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(750.5, 286)
    }
  },
  {
    config = {
      rotation = -40,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/map/map_route_1.png",
      name = "route_05_07",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(545.5, 391.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "room_01_name",
      z = 0,
      parent = "room_01_name_bg",
      text = T("\230\153\174\233\128\154\230\136\152\230\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_01_name_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_shade.png",
      name = "room_01_name_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_02",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_shade.png",
      name = "room_02_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_02",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png",
      name = "room_02_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_03",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_shade.png",
      name = "room_03_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_03",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png",
      name = "room_03_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_04",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_shade.png",
      name = "room_04_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_04",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png",
      name = "room_04_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_05",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_shade.png",
      name = "room_05_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_05",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png",
      name = "room_05_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_06",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_shade.png",
      name = "room_06_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_06",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png",
      name = "room_06_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_07",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_shade.png",
      name = "room_07_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_07",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_bg.png",
      name = "room_07_name_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "room_02_name",
      z = 0,
      parent = "room_02_name_bg",
      text = T("\230\153\174\233\128\154\230\136\152\230\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_02_name_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_shade.png",
      name = "room_02_name_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "room_03_name",
      z = 0,
      parent = "room_03_name_bg",
      text = T("\230\153\174\233\128\154\230\136\152\230\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_03_name_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_shade.png",
      name = "room_03_name_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "room_04_name",
      z = 0,
      parent = "room_04_name_bg",
      text = T("\230\153\174\233\128\154\230\136\152\230\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_04_name_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_shade.png",
      name = "room_04_name_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "room_05_name",
      z = 0,
      parent = "room_05_name_bg",
      text = T("\230\153\174\233\128\154\230\136\152\230\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_05_name_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_shade.png",
      name = "room_05_name_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "room_06_name",
      z = 0,
      parent = "room_06_name_bg",
      text = T("\230\153\174\233\128\154\230\136\152\230\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_06_name_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_shade.png",
      name = "room_06_name_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "room_07_name",
      z = 0,
      parent = "room_07_name_bg",
      text = T("\230\153\174\233\128\154\230\136\152\230\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "room_07_name_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_name_shade.png",
      name = "room_07_name_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 13.75)
    }
  }
}
