ed.uieditor = ed.uieditor or {}
ed.uieditor.friendPanel = {
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 103.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/friend/friend_tag_2.png",
      name = "btnFriendBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 354)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnFriendBg",
      res = "UI/alpha/1080P/friend/friend_tag_1.png",
      name = "btnFriendSelect",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 12.5)
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
      name = "btnFriendLabel",
      z = 0,
      parent = "btnFriendBg",
      text = T("\229\165\189\229\143\139"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 103.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/friend/friend_tag_2.png",
      name = "btnBlacklistBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.5, 354)
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
      name = "friendAmountLabel",
      z = 0,
      parent = "bg",
      text = T("\229\165\189\229\143\139\230\149\176\233\135\143\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(522.5, 353.5)
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
      name = "friendAmount",
      z = 0,
      parent = "bg",
      text = "0/0",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(522.5, 353.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btnBlacklistBg",
      res = "UI/alpha/1080P/friend/friend_tag_1.png",
      name = "btnBlacklistSelect",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 12.5)
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
      name = "btnBlacklistLabel",
      z = 0,
      parent = "btnBlacklistBg",
      text = T("\233\187\145\229\144\141\229\141\149"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 16.5)
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
      name = "nofriend_tips",
      z = 0,
      parent = "bg",
      text = T("\230\130\168\232\191\152\230\178\161\230\156\137\229\165\189\229\143\139\239\188\140\229\142\187\230\183\187\229\138\160\228\184\128\228\186\155\229\144\167"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285, 180)
    }
  }
}
