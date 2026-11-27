ed.uieditor = ed.uieditor or {}
ed.uieditor.chatEntrance = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 244, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chat/chat_Info_board_bg.png",
      name = "chat_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(61.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 47)
    },
    t = "Layer",
    base = {
      parent = "chat_bg",
      name = "msg_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chat/chat_but_bj.png",
      name = "bubble_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 35)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 47)
    },
    t = "Layer",
    base = {
      name = "enter_touch",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(30, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bubble_bg",
      res = "UI/alpha/1080P/chat/chat_bubble_hint1.png",
      name = "bubble",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 17.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bubble_bg",
      res = "UI/alpha/1080P/chat/new/new_tips.png",
      name = "redpoint",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "rednum",
      z = 0,
      parent = "redpoint",
      text = "99",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.75, 8.75)
    }
  }
}
