ed.uieditor = ed.uieditor or {}
ed.uieditor.rankListItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725, 82)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 17, 500, 50),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "bj_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(363.5, 44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(725.5, 81.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(46.5, 20, 200, 50),
      res = "UI/alpha/1080P/rankingscene/myself.png",
      name = "bj_img_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(363, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(660, 74)
    },
    t = "Layer",
    base = {name = "panel_item", z = 9},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(11.5, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(250, 74)
    },
    t = "Layer",
    base = {
      name = "Panel_guild",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(425, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(300, 74)
    },
    t = "Layer",
    base = {name = "Panel_pvp", z = 9},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(425, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(300, 74)
    },
    t = "Layer",
    base = {
      name = "Panel_fighting",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(425, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(300, 74)
    },
    t = "Layer",
    base = {
      name = "Panel_fighting_star",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(425, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "panel_item",
      name = "num_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(36.5, 35)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "panel_item",
      name = "hand_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(111, 35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 39),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_role_name",
      z = 0,
      parent = "panel_item",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(170.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 39),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3098",
      z = 0,
      parent = "Panel_pvp",
      text = T("\229\133\172\228\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.5, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 157),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 0,
      parent = "Panel_pvp",
      text = T("\229\164\167\230\146\146\229\164\167\230\146\146"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170.5, h = 78.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bj_img",
      res = "UI/alpha/1080P/rankingscene/pattern_2.png",
      name = "ImageView_3110",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 145.5, h = 105.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bj_img",
      res = "UI/alpha/1080P/rankingscene/pattern_1.png",
      name = "ImageView_3110_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(622.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 39),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_31012",
      z = 0,
      parent = "Panel_fighting",
      text = T("\229\133\168\229\145\152\230\128\187\230\136\152\229\138\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_fighting",
      name = "fighting_num",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(198.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 39),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3101",
      z = 0,
      parent = "Panel_fighting_star",
      text = T("\232\139\177\233\155\132\230\128\187\230\152\159\231\186\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.5, 55)
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
      parent = "Panel_fighting_star",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_star_normal.png",
      name = "ImageView_3115",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(169, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 157),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fighting_star_num",
      z = 0,
      parent = "Panel_fighting_star",
      text = "999",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212, 24)
    }
  }
}
