ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_adventure_reward_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 775, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activityadventure/adventure_reward_bg1.png",
      name = "image_bg",
      z = 0
    },
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
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\148\182\233\155\1341234"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 75)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(269.5, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_get_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(675.5, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(128.5, 51)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "btn_uncomplete",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(611.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126, h = 74},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/adventure_reward_finish.png",
      name = "btn_complete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(675.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.3, x = 1.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 26.65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1.png",
      name = "image_token",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130, 45)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 230, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1225",
      z = 0,
      parent = "btn_get_reward",
      text = T("\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_uncomplete",
      res = "UI/alpha/1080P/common/button_grey.png",
      name = "image",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 224, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1230",
      z = 0,
      parent = "btn_uncomplete",
      text = T("\230\156\170\229\174\140\230\136\144"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(220, 179, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1225",
      z = 0,
      parent = "btn_complete",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 38.5)
    }
  }
}
