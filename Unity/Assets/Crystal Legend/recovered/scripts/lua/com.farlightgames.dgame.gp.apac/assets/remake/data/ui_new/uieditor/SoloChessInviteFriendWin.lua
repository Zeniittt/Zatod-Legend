ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloChessInviteFriendWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(667, 358)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 0, 0, 0),
      res = "UI/alpha/1080P/chesscard/match/match_bg1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473, 283)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(160, 160, 160),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_none_friend_tip",
      z = 3,
      parent = "bg",
      text = T("\230\154\130\230\151\160\229\165\189\229\143\139\239\188\140\229\191\171\230\183\187\229\138\160\228\184\128\228\186\155\229\165\189\229\143\139\229\147\166\239\188\129"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332.5, 196.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 214, h = 53},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/match_button_3.png",
      name = "btn_world",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(649, 245)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_world",
      z = 0,
      parent = "btn_world",
      text = T("\229\143\145\229\184\131\228\184\150\231\149\140\233\130\128\232\175\183"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 214, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/match_button_3.png",
      name = "btn_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_invite_friend",
      z = 3,
      parent = "bg",
      text = T("\233\130\128\232\175\183\229\165\189\229\143\139"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332.5, 332.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.599997504, h = 41.599997504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/closed.png",
      name = "btn_back",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(653, 351.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild",
      z = 0,
      parent = "btn_guild",
      text = T("\229\143\145\229\184\131\229\133\172\228\188\154\233\130\128\232\175\183"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 597.199964168, h = 43.199997408},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/team_bg.png",
      name = "ImageView_746",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330.5, 333.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_747",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229, 333)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_747_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(438.5, 334)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_world",
      res = "UI/alpha/1080P/chesscard/match/gulid.png",
      name = "ImageView_752",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_guild",
      res = "UI/alpha/1080P/chesscard/match/gulid.png",
      name = "ImageView_751",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 27)
    }
  }
}
