ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_reward_win = {
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
      scaleSize = CCSizeMake(787.5, 346)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(8.5, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 804.5, h = 143},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_reward_title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.5, 427)
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
      name = "layer_history_heat",
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
      parent = "layer_history_heat",
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
      name = "label_1",
      z = 0,
      parent = "layer_history_heat",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\231\131\173\229\138\155\239\188\154"),
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
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5999932, h = 46.8999933},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_history_heat",
      res = "UI/alpha/1080P/hades/hades_hot.png",
      name = "image_token",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(161.5, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 244, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_history_heat",
      z = 0,
      parent = "layer_history_heat",
      text = "12345",
      size = 25
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(182, 13)
    }
  }
}
