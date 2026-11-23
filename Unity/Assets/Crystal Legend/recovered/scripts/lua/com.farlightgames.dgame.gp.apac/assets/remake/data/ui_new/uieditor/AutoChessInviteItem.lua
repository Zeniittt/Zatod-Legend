ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessInviteItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646, h = 69},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/mode/Invite_bg_3.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.09999065, h = 56.3999906},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(136, 233, 76),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "online",
      z = 0,
      parent = "bg",
      text = T("\229\156\168\231\186\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(502.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_invite",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(583, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 42},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_mini_grey.png",
      name = "btn_invite_already",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(583, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 206, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_invite",
      z = 0,
      parent = "btn_invite",
      text = T("\233\130\128\232\175\183"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
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
      name = "label_invite_already",
      z = 0,
      parent = "btn_invite_already",
      text = T("\229\183\178\233\130\128\232\175\183"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 21.5)
    }
  }
}
