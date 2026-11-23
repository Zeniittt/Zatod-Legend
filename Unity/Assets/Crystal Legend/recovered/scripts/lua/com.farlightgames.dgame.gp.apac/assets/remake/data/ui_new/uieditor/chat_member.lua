ed.uieditor = ed.uieditor or {}
ed.uieditor.chat_member = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 203, h = 50},
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
      normal = "UI/alpha/1080P/chat/new/chat_recent_unchoose.png",
      name = "member_btn",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/chat/new/chat_recent_choose.png",
      size = 7
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.47, x = 0.47},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.945, h = 44.18},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "member_btn",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "head_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.47, x = 0.47},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.31, h = 34.31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "member_btn",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 25)
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
      parent = "member_btn",
      res = "UI/alpha/1080P/chat/new/new_tips.png",
      name = "redpoint",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 41)
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
      parent = "member_btn",
      text = T("\232\183\175\229\174\158@\229\189\188\229\178\184\229\190\152\229\190\138\232\128\133"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49, 34)
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
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_svr_name",
      z = 0,
      parent = "member_btn",
      text = T("1\230\156\141 \233\187\132\233\135\145\229\156\163\230\160\145"),
      size = 11
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(88, 15)
    }
  }
}
