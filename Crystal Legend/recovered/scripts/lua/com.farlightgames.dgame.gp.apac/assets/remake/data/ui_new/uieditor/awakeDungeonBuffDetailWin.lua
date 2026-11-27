ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonBuffDetailWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 419.5, h = 161.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/dungeon_buff_info.png",
      name = "image_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_buff_dec.png",
      name = "ImageView_24652",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.25, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 28, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_buff_dec.png",
      name = "ImageView_24653",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.75, 139.5)
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
      name = "label_buff_title",
      z = 0,
      parent = "image_bg",
      text = T("\229\133\136\229\143\145\230\140\145\230\136\152"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(209.75, 139)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 191, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff_desc1",
      z = 0,
      parent = "image_bg",
      text = T("\230\149\140\230\150\185\230\148\187\233\152\178\232\161\128\230\143\144\229\141\135200%"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19.25, 106.5)
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
      name = "label_buff_desc2",
      z = 0,
      parent = "image_bg",
      text = T("\229\156\168\229\156\176\229\186\149\230\142\162\231\180\162\228\184\173\239\188\140\232\182\138\233\157\160\229\144\142\231\154\132\231\171\160\232\138\130\230\149\140\228\186\186\229\188\186\229\186\166\229\176\134\229\190\151\229\136\176\232\182\138\233\171\152\229\138\160\230\136\144\232\191\153\231\167\141\229\138\160\230\136\144\228\188\154\233\154\143\230\151\182\233\151\180\232\161\176\229\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19.75, 79)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_next_buff_time",
      z = 0,
      parent = "image_bg",
      text = T("\229\176\134\229\156\16829\229\164\16923\230\151\182\229\144\142\232\161\176\229\135\143\228\184\186150%"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(209.75, 25)
    }
  }
}
