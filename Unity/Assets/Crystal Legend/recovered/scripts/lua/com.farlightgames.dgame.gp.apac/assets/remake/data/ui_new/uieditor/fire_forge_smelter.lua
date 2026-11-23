ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_smelter = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(795, 140)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(600, 46.5, 200.5, 46.5),
      res = "UI/alpha/1080P/fireforge/forge_board2.png",
      name = "image_bg",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 132, 106),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\231\165\158\231\129\171\231\134\148\231\130\137\194\183\228\184\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(62.5, 120)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/skip_all.png",
      name = "btn_skip_all",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(340, 119)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(233, 185, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_time",
      z = 0,
      parent = "image_bg",
      text = T("\233\148\187\233\128\160\230\128\187\230\151\182\233\149\191\239\188\1540\229\176\143\230\151\1820\229\136\134"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(313, 120)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/forge_button.png",
      name = "btn_forge",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(702.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(596, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.5, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 339.5, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/unlock_board.png",
      name = "image_unlock_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/art1.png",
      name = "icon_cost",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(684.5, 83.5)
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
      name = "label_cost_amount",
      z = 0,
      parent = "icon_cost",
      text = "10",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_unlock_tips",
      res = "UI/alpha/1080P/fireforge/lock.png",
      name = "ImageView_1036",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.25, 21.5)
    }
  }
}
