ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessPetBagWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(726, 329.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 14, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(145, 143.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(406.5, 312.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_pet_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(160, 160, 160),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_tip",
      z = 100,
      parent = "bg",
      text = T("\230\154\130\230\151\160\232\163\133\229\164\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213, 167.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(282, 312.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(429.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(160, 160, 160),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_none_hero",
      z = 1,
      parent = "bg",
      text = T("\230\154\130\230\151\160\228\184\138\233\152\181\232\139\177\233\155\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(568.5, 250)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 298.5, h = 159.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_list",
      res = "UI/alpha/1080P/chess/battle/bag_equip_bg.png",
      name = "bg_bag_hero",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 83)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(208, 197, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bag_title",
      z = 0,
      parent = "bg_bag_hero",
      text = T("\228\187\147\229\186\147\232\139\177\233\155\132"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.25, 146.75)
    }
  }
}
