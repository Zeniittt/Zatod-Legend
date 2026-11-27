ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_lottery_reward_pop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(812, 450)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 73.5, 39.5, 73.5),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 252.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(793, 348)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 803.5, h = 113.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_linereward_title.png",
      name = "image_title",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(406, 437.5)
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
      z = 99
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(21.5, 365)
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
      text = T("\229\183\178\231\191\187\231\137\140\239\188\154123456"),
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
      fix_scale = {y = 0.8, x = 0.8000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2000054, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "ImageView_2999",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(794, 433.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2999",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_3000",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28)
    }
  }
}
