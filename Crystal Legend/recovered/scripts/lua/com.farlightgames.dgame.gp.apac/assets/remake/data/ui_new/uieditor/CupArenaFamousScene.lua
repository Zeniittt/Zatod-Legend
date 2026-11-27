ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaFamousScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1124, 630)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 600, 0.5, 5),
      res = "UI/alpha/1080P/cuparena/knockout/honor/honor_bg_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 225)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 181.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/honor_season_bg_1.png",
      name = "bg_season_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(564.5, 536.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 389)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(262, 90)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(167.5, 168)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_zone_list",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/honor_zone_2.png",
      capInsets = CCRectMake(50, 20, 0.5, 2.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(366.5, 511.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.5, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/honor_zone_1.png",
      name = "bg_cur_zone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(367, 500)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(248.5, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 0, 40, 35.5),
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191, 502.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 168.5, h = 84.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/honor/honor_page_arrow.png",
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-6.5, 271)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 168.5, h = 84.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/honor/honor_page_arrow.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(968, 271)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(167, 135)
    },
    t = "Layer",
    base = {
      parent = "bg_zone_list",
      name = "panel_zone",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.25, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_cur_zone",
      res = "UI/alpha/1080P/cuparena/knockout/honor/honor_zone_arrow.png",
      name = "btn_zone_list",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.25, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur_zone",
      z = 0,
      parent = "bg_cur_zone",
      text = T("\231\172\1721\232\181\155\229\140\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.75, 12.5)
    }
  }
}
