ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildWeeklyjobWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 402)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(509.5, 264)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 173),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 1,
      parent = "bg",
      text = T("\229\133\172\228\188\154\228\187\187\229\138\161"),
      size = 27
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18, 371)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 631, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_weektask/art1.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(325.5, 357.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(622, 290)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 203),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "des",
      z = 1,
      parent = "bg",
      text = T("\229\133\172\228\188\154\228\187\187\229\138\161\230\175\143\229\145\168\228\184\1285\231\130\185\233\135\141\231\189\174"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 338)
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
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(631, 384)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 203),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "total_progress",
      z = 1,
      parent = "bg",
      text = "(2/8)",
      size = 27
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(130, 371)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 1.36, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.5, h = 633.08},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mail/mail_lin.png",
      name = "ImageView_6218_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(325.5, 317.5)
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
      name = "ImageView_2427",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}
