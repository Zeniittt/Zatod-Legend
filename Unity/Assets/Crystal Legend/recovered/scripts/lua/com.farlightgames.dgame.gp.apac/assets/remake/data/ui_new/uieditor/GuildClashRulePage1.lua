ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashRulePage1 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 430)
    },
    t = "Layer",
    base = {name = "panel_rule", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "panel_rule",
      text = T("\229\133\172\228\188\154\230\136\152\229\136\134\228\184\186\228\184\164\228\184\170\233\152\182\230\174\181\239\188\140\233\166\150\229\145\168\228\184\186\229\174\154\231\186\167\233\152\182\230\174\181\239\188\140\229\174\154\231\186\167\229\144\142\229\188\128\229\167\139\230\175\148\232\181\155\233\152\182\230\174\181"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 416.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 754.5, h = 489.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_rule",
      res = "UI/alpha/1080P/guild/guild_gamedec/dec01.png",
      name = "ImageView_10883",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_rule",
      res = "UI/alpha/1080P/guild/guild_gamedec/littletitle.png",
      name = "ImageView_10893",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 387.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 11),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num_1",
      z = 0,
      parent = "ImageView_10883",
      text = "01",
      size = 45
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.75, 367.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 11),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num_2",
      z = 0,
      parent = "ImageView_10883",
      text = "02",
      size = 45
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378.75, 367.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 11),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num_3",
      z = 0,
      parent = "ImageView_10883",
      text = "03",
      size = 45
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.75, 219.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc_1",
      z = 0,
      parent = "ImageView_10883",
      text = T("\229\145\168\230\151\16521\231\130\185\239\188\140\230\160\185\230\141\174\229\133\172\228\188\154\230\180\187\232\183\131\231\187\153\229\144\132\229\133\172\228\188\154\229\174\154\231\186\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(170.75, 347.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc_2",
      z = 0,
      parent = "ImageView_10883",
      text = T("\231\155\184\232\191\145\230\156\141\229\138\161\229\153\168\229\134\133\231\155\184\229\144\140\231\186\167\229\136\171\229\133\172\228\188\154\239\188\140\228\188\154\232\162\171\229\136\146\229\136\134\232\191\155\229\144\140\228\184\128\230\136\152\229\140\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(364.75, 291.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 341, h = 202},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_10883",
      res = "UI/alpha/1080P/guild/guild_gamedec/girl1.png",
      name = "ImageView_10890",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(517.75, 122.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 209, 175),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_little_title",
      z = 0,
      parent = "ImageView_10893",
      text = T("\229\174\154\231\186\167\233\152\182\230\174\181"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 50)
    },
    t = "Layer",
    base = {
      parent = "ImageView_10890",
      name = "panel_desc_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10, 126)
    }
  }
}
