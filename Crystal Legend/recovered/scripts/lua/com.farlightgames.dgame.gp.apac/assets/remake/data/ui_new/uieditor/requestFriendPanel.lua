ed.uieditor = ed.uieditor or {}
ed.uieditor.requestFriendPanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(570, 380)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(557, 317.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "playerList",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 572.5, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/friend/friend_apply_bg.png",
      name = "titleBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285.5, 356)
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
      name = "noapply_tips",
      z = 0,
      parent = "bg",
      text = T("\230\154\130\230\151\160\229\165\189\229\143\139\231\148\179\232\175\183"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285, 166)
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
      name = "title",
      z = 0,
      parent = "titleBg",
      text = T("\229\165\189\229\143\139\231\148\179\232\175\183"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.25, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "titleBg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_131",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176.75, 25.25)
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
      parent = "titleBg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_132",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(396.75, 25.25)
    }
  }
}
