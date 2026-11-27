ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_new_equip_window = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 549.5, h = 313},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/forgewindow/window_background.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473.5, 290.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/forgewindow/window_close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(514.75, 286)
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
      text = T("\229\133\168\230\150\176\228\188\160\229\165\135\232\163\133\229\164\135\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.25, 276.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 133, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/forgewindow/window_cancel.png",
      name = "btn_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.25, 88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 133, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/forgewindow/window_confirm.png",
      name = "btn_confirm",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(406.75, 88)
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
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\152\175\229\144\166\231\171\139\229\136\187\229\138\160\229\133\165\233\148\187\233\128\160\229\191\131\230\132\191\239\188\159"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(274.75, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_equip_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(49.75, 156.5)
    }
  }
}
