ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonFirstBloodWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(286, 153)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 110, 0.5, 25),
      res = "UI/alpha/1080P/dungeon/dungeon_firstblood_info.png",
      name = "image_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 22)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(80, 115)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65, 65)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(11.5, 87)
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
      name = "label_guild",
      z = 0,
      parent = "image_bg",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 11
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(87.5, 108)
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
      name = "Label_23500",
      z = 0,
      parent = "image_bg",
      text = T("\233\128\154\229\133\179\230\151\182\233\151\180\239\188\154"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22.5, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pass_time",
      z = 0,
      parent = "image_bg",
      text = "2024-8-20  15:02:12",
      size = 12
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(264, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(280, 57)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(3, 8)
    }
  }
}
