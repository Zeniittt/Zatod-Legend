ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_directly_rate = {
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(44.5, 45),
      flip = "",
      labelConfig = {
        color = ccc3(253, 240, 158)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/activity/ench_mailbox/ench_button_close.png",
      name = "closeBtn",
      z = 0,
      capInsets = CCRectMake(15, 15, 15, 10),
      text = "",
      press = "UI/alpha/1080P/activity/ench_mailbox/ench_button_close.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(769, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 625, h = 486.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/ench_mailbox/ench_bg.png",
      name = "image_left_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "text_tips",
      z = 0,
      parent = "image_left_bg",
      text = T("\228\186\178\231\136\177\231\154\132\233\152\159\233\149\191\239\188\140\229\175\185\228\186\142\230\128\128\230\151\167\230\156\141\231\154\132\228\189\147\233\170\140\230\152\175\229\144\166\230\187\161\230\132\143\229\145\162\239\188\159\230\136\145\230\131\179\229\144\172\229\143\150\228\184\139\230\130\168\231\154\132\232\175\132\228\187\183\229\146\140\229\187\186\232\174\174\229\147\166\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 214.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.65, x = 0.65},
      fix_wh = {w = 156.975, h = 50.05},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/activity/ench_mailbox/ench_button_1.png",
      name = "btn_switch_left",
      z = 0,
      parent = "image_left_bg",
      text = "",
      press = "UI/alpha/1080P/activity/ench_mailbox/ench_button_1.png",
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.5, 73.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.65, x = 0.65},
      fix_wh = {w = 155.675, h = 46.8},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/activity/ench_mailbox/ench_button_2.png",
      name = "btn_switch_right",
      z = 0,
      parent = "image_left_bg",
      text = "",
      press = "UI/alpha/1080P/activity/ench_mailbox/ench_button_2.png",
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(417.5, 73.25)
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
      name = "text_left",
      z = 0,
      parent = "btn_switch_left",
      text = T("\230\136\145\230\131\179\229\144\144\230\167\189"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.75, 41.5)
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
      name = "text_right",
      z = 0,
      parent = "btn_switch_right",
      text = T("\233\128\159\229\142\187\232\175\132\228\187\183"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 39)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(177, 34, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_left_bg",
      text = T("\231\187\153\229\176\143\233\185\191\231\154\132\231\149\153\232\168\128"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 317.25)
    }
  }
}
