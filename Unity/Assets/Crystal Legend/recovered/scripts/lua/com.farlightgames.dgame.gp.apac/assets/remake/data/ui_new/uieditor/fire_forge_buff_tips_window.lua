ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_buff_tips_window = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.78},
      flip = "",
      opacity = 255,
      fix_wh = {w = 428.61, h = 187.8},
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
      position = ccp(480, 270)
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
      size = 15,
      text = T("\232\167\163\233\148\129\232\191\156\229\143\164\231\134\148\231\130\137\229\138\159\232\131\189\229\144\142\239\188\140\233\152\159\233\149\191\228\188\154\229\143\151\229\136\176\233\148\187\233\128\160\228\185\139\231\165\158\231\154\132\232\181\144\231\166\143"),
      name = "label_desc_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 300)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 50)
    },
    t = "Layer",
    base = {name = "panel_desc", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(307.5, 233.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(379.5, 31)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(16.5, 13, 16.5, 13),
      res = "UI/alpha/1080P/fireforge/bless_dec.png",
      name = "image_tips_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481, 208.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("\231\165\157\231\166\143\230\149\136\230\158\156"),
      name = "label_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481.5, 343)
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
      name = "label_tips",
      z = 0,
      parent = "image_tips_bg",
      text = T("\229\135\186\231\130\137\229\148\175\228\184\128\232\163\133\229\164\135\230\149\180\232\163\133\229\144\142\231\165\157\231\166\143\230\182\136\229\164\177"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(189.75, 15.5)
    }
  }
}
