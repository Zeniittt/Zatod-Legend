ed.uieditor = ed.uieditor or {}
ed.uieditor.blackListCell = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(455, 64.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7, 7, 2, 2),
      res = "UI/alpha/1080P/chat/chat_blacklist_input_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.1, h = 56.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "head_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 32.5)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\232\183\175\229\174\158@\229\189\188\229\178\184\229\190\152\229\190\138\232\128\133"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(117.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chat/chat_level_bg.png",
      name = "level_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(77.5, 35),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(35, 15, 7.5, 5.5),
      name = "clear_btn",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.5, 31.5)
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
      parent = "head_bg",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 48)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "level",
      z = 0,
      parent = "level_bg",
      text = "99",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.5, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "clear_label",
      z = 0,
      parent = "clear_btn",
      text = T("\231\167\187\233\153\164"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 18.5)
    }
  }
}
