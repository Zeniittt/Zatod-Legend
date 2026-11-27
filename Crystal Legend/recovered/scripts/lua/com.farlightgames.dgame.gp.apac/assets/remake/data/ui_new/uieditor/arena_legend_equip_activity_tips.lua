ed.uieditor = ed.uieditor or {}
ed.uieditor.arena_legend_equip_activity_tips = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(424, 205)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13.5, 13.5, 13.5, 13.5),
      res = "UI/alpha/1080P/common/com_new_3.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(129.5, 184.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(294.5, 184.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\187\161\230\152\159\228\188\160\229\165\135\232\163\133\229\164\135\230\180\187\229\138\168"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212, 186.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 166, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/arena_special/art1.png",
      name = "image_tattoo",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212, 128.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 45)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 416, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/arena_special/dec_board.png",
      name = "image_tips_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_tips_bg",
      res = "UI/alpha/1080P/legendequip/arena_special/dec_icon.png",
      name = "image_tips_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.5, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(175, 163, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "image_tips_bg",
      text = T("\230\173\164\230\180\187\229\138\168\228\184\186\229\133\136\233\148\139\230\156\141\228\184\147\229\177\158\230\180\187\229\138\168"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(218.5, 9.75)
    }
  }
}
