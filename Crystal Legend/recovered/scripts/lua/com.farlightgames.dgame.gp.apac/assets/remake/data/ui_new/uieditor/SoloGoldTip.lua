ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloGoldTip = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 250)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(90, 80, 8, 5),
      res = "UI/alpha/1080P/chesscard/tips/fream_1.png",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626",
      z = 0,
      parent = "bg",
      text = T("\229\175\185\230\136\152\228\184\173,\233\135\145\229\184\129\229\143\175\231\148\168\228\186\142\232\180\173\228\185\176\230\138\128\232\131\189"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112.5, 214.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 179.35, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/tips/line.png",
      name = "ImageView_628",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.5, 198)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 133, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy0",
      z = 0,
      parent = "bg",
      text = T("\229\159\186\231\161\128\239\188\154"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 182)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy1",
      z = 0,
      parent = "bg",
      text = T("\230\175\143\232\189\174\232\135\170\229\138\168\232\142\183\229\190\151300-400\233\135\145\229\184\129\239\188\140\233\154\143\229\155\158\229\144\136\230\149\176\229\162\158\233\149\191"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(55.5, 189.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 133, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy2",
      z = 0,
      parent = "bg",
      text = T("\229\136\169\230\129\175\239\188\154"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 150)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 133, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy3",
      z = 0,
      parent = "bg",
      text = T("\232\131\156\229\136\169\239\188\154"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 110)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 133, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy4",
      z = 0,
      parent = "bg",
      text = T("\232\191\158\232\131\156\239\188\154"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 76)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 133, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy5",
      z = 0,
      parent = "bg",
      text = T("\232\180\165\232\161\165\239\188\154"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 42)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy6",
      z = 0,
      parent = "bg",
      text = T("\230\175\143\231\149\153\229\173\152100\233\135\145\229\184\129\228\188\154\228\186\167\231\148\15910\233\135\145\229\184\129\229\136\169\230\129\175\239\188\140\229\136\169\230\129\175\228\184\138\233\153\14450"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(55.5, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy7",
      z = 0,
      parent = "bg",
      text = T("\230\136\152\230\150\151\232\131\156\229\136\169\232\142\183\229\190\15150\233\135\145\229\184\129\228\189\156\228\184\186\232\131\156\229\136\169\230\148\182\229\133\165"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(55.5, 118)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy8",
      z = 0,
      parent = "bg",
      text = T("\230\175\143\230\172\161\232\191\158\231\187\173\232\131\156\229\136\169\232\142\183\229\190\15110\233\162\157\229\164\150\233\135\145\229\184\129\239\188\140\230\156\128\229\164\154\228\184\141\232\182\133\232\191\13530"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(55.5, 84)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_626_Copy9",
      z = 0,
      parent = "bg",
      text = T("\230\175\143\232\162\171\230\149\140\230\150\185\230\137\147\230\142\1371\231\130\185\231\142\169\229\174\182\231\148\159\229\145\189\239\188\140\232\142\183\229\190\15130\233\135\145\229\184\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(55.5, 51)
    }
  }
}
