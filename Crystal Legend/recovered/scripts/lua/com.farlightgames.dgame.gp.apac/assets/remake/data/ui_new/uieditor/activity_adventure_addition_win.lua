ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_adventure_addition_win = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(625, 411.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 73.5, 13, 73.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488.5, 268)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(562.5, 316)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(33, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 221, 187),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "image_bg",
      text = T("\230\156\172\230\156\159\229\138\160\230\136\144\232\139\177\233\155\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311.5, 383.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc",
      z = 0,
      parent = "image_bg",
      text = T("\228\184\138\233\152\181\229\138\160\230\136\144\232\139\177\233\155\132\230\151\182\239\188\140\232\180\157\229\163\179\232\142\183\229\143\150\233\135\143\230\143\144\229\141\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312, 353.75)
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
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_960",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(179, 9)
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
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_961",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-69.5, 9)
    }
  }
}
