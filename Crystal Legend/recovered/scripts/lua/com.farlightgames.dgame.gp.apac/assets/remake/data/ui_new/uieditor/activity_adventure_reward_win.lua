ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_adventure_reward_win = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(803, 439)
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
      position = ccp(481, 254)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(778.5, 346)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.5, 12)
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
      z = 1,
      parent = "image_bg",
      text = T("\228\184\138\233\152\181\229\138\160\230\136\144\232\139\177\233\155\132\230\151\182\239\188\140\232\180\157\229\163\179\232\142\183\229\143\150\233\135\143\230\143\144\229\141\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401, 367.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 804.5, h = 132.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_reward_title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.5, 422.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_collection",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17, 358)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_collection",
      res = "UI/alpha/1080P/activityadventure/adventure_collection_star.png",
      name = "ImageView_1208",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14, 12)
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
      name = "label_collection",
      z = 0,
      parent = "layer_collection",
      text = T("\229\183\178\230\148\182\233\155\134\239\188\154123456"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_collection",
      res = "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1.png",
      name = "image_token",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182.5, 13)
    }
  }
}
