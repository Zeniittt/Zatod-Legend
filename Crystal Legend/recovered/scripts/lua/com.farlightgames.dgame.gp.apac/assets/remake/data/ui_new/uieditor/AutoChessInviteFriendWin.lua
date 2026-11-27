ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessInviteFriendWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 653, h = 358},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/mode/Invite_bg_2.png",
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
      position = ccp(326.5, 196.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 219, h = 45.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/mode/Invite_bg_1.png",
      name = "btn_world",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328.5, 36.5)
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
      position = ccp(3.5, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
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
      position = ccp(123, 23.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 219, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/mode/Invite_bg_1.png",
      name = "btn_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326.5, 43)
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
      z = 0,
      parent = "bg",
      text = T("\233\130\128\232\175\183\229\165\189\229\143\139"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333, 336)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647, 353)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
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
      position = ccp(123, 23.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_1645",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}
