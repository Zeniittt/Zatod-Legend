ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_lottery_reward_pop_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(785, 105)
    },
    t = "Layer",
    base = {name = "Panel_3005", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 784, h = 101.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_3005",
      res = "UI/alpha/1080P/lottery/lottery_progress_bar_1.png",
      name = "Image_over",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 784, h = 101.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_3005",
      res = "UI/alpha/1080P/lottery/lottery_progress_bar_2.png",
      name = "Image_available",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 784, h = 101.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_3005",
      res = "UI/alpha/1080P/lottery/lottery_progress_bar_3.png",
      name = "Image_ing",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(173, 170, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_over",
      z = 0,
      parent = "Image_over",
      text = T("\231\180\175\232\174\161\231\191\187\231\137\140 10 \230\172\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 52.25)
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
      parent = "Image_over",
      res = "UI/alpha/1080P/activityadventure/adventure_reward_finish.png",
      name = "ImageView_3003211",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(677.5, 51.25)
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
      name = "label_available",
      z = 0,
      parent = "Image_available",
      text = T("\231\180\175\232\174\161\231\191\187\231\137\140 10 \230\172\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(128, 49)
    },
    t = "Scale9Sprite",
    base = {
      name = "Image_gift_btn",
      z = 0,
      parent = "Image_available",
      res = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(20, 0, 37.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(676.5, 51.75)
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
      name = "label_ing",
      z = 0,
      parent = "Image_ing",
      text = T("\231\180\175\232\174\161\231\191\187\231\137\140 10 \230\172\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 52.25)
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
      name = "Label_btn_ing",
      z = 0,
      parent = "Image_ing",
      text = T("\232\191\155\232\161\140\228\184\173"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(676, 52.75)
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
      name = "Label_3004",
      z = 0,
      parent = "ImageView_3003211",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(60, 56, 51),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_30044534",
      z = 0,
      parent = "Image_gift_btn",
      text = T("\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 24)
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
      name = "Label_30043634",
      z = 0,
      parent = "Image_gift_btn",
      text = T("\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 25)
    }
  }
}
