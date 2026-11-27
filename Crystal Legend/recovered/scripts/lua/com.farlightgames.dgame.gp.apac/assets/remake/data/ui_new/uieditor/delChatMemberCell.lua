ed.uieditor = ed.uieditor or {}
ed.uieditor.delChatMemberCell = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 127,
      visible = true,
      scaleSize = CCSizeMake(456, 65)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 8, 9),
      res = "UI/alpha/1080P/chat/new/chat_recent_del_bg_1.png",
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
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.8, h = 43.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 32.5)
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
      res = "UI/alpha/1080P/chat/new/chat_level_bg.png",
      name = "level_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94, 32.5)
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
      verticalAlignment = 1,
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
      position = ccp(116.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 29, h = 29},
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
      normal = "UI/alpha/1080P/chat/new/chat_recent_del_choose.png",
      name = "select_btn",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/chat/new/chat_recent_del_choose.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 409.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chat/new/chat_recent_del_bg_2.png",
      name = "back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(228, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(247, 228, 153),
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
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.4, h = 18.8},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "select_btn",
      res = "UI/alpha/1080P/package/selected.png",
      name = "selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 14.5)
    }
  }
}
