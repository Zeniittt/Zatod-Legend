ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessPetItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 75)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 12, 7.5, 50),
      res = "UI/alpha/1080P/chess/battle/equip_details_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "node_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 185, 249),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pet_name",
      z = 10,
      parent = "bg",
      text = T("\232\163\133\229\164\135\229\144\141\231\167\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(71.5, 54.5)
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
      name = "label_pet_equip_desc",
      z = 10,
      parent = "bg",
      text = T("\228\191\161\228\189\191\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(71.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_team_shade.png",
      name = "img_pet_icon_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(363.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_pet_icon_bg",
      res = "UI/alpha/1080P/common/add_big.png",
      name = "img_pet_add",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.25, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73, h = 73},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_pet_icon_bg",
      res = "UI/alpha/1080P/chess/battle/chess_equip_fream_2.png",
      name = "img_select",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.75, 27.5)
    }
  }
}
