ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountRewardWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 966.5, h = 576.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guildmount/rank/background.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 309.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 186, 78),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_info",
      z = 0,
      parent = "bg",
      text = T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\230\142\146\229\144\141\229\143\145\230\148\190\228\184\170\228\186\186\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.75, 384.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(694, 335)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(136.25, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(105, 295)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(895.25, 114.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/rank/close_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(855.25, 455.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guildmount/rank/tab_selected.png",
      name = "btn_tab1_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-13.5, 209.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guildmount/rank/tab_unselected.png",
      name = "btn_tab1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-13.5, 209.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guildmount/rank/tab_unselected.png",
      name = "btn_tab2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-13.5, 134)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/guildmount/rank/tab_selected.png",
      name = "btn_tab2_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-13.5, 134)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 205),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab1_selected",
      z = 0,
      parent = "btn_tab1_selected",
      text = T("\229\133\172\228\188\154\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(144, 132, 156),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab1",
      z = 0,
      parent = "btn_tab1",
      text = T("\229\133\172\228\188\154\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(144, 132, 156),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab2",
      z = 0,
      parent = "btn_tab2",
      text = T("\228\184\170\228\186\186\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 205),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab2_selected",
      z = 0,
      parent = "btn_tab2_selected",
      text = T("\228\184\170\228\186\186\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(434.25, 409.25)
    }
  }
}
