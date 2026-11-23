ed.uieditor = ed.uieditor or {}
ed.uieditor.heroAttWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 350)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_2454",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385, 325)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\232\175\166\231\187\134\229\177\158\230\128\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 325)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_2453",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.5, 325)
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
      name = "desc",
      z = 0,
      parent = "bg",
      text = T("\228\184\173\230\142\146\230\179\149\229\184\136\239\188\140\228\189\191\231\148\168\233\187\145\230\154\151\231\154\132\229\183\171\230\156\175\230\157\128\228\188\164\229\175\185\230\137\139\239\188\140\232\135\170\232\186\171\230\139\165\230\156\137\229\188\186\229\164\167\231\154\132\231\187\173\232\136\170\232\131\189\229\138\155\227\128\130"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "comment",
      z = 0,
      parent = "bg",
      text = T("\226\128\156\228\189\160\230\131\179\231\159\165\233\129\147\231\167\128\229\143\145\231\154\132\231\167\152\229\175\134\229\144\151\226\128\157"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 263.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 223.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_att",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 21)
    }
  }
}
