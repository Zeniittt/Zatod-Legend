ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_grow_plan = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
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
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_bg_2340.jpg",
      name = "image_bg",
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
      fix_wh = {w = 282.5, h = 125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_title.png",
      name = "image_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(336.5, 463.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 247.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_timeup_bg.png",
      name = "ImageView_112",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.25, -15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_time",
      z = 0,
      parent = "ImageView_112",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(77.75, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(513, 281.5)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "task_list",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(454.5, 77)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_word_bg1.png",
      name = "target_label_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(545.5, 383.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_word_bg2.png",
      name = "target_label_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(725, 383)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_reward_word_bg1.png",
      name = "target_label_bg3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(887.5, 383)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 663, h = 310},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_bg_mask.png",
      name = "image_mask1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(733, 208.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_112",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_timeup.png",
      name = "ImageView_368",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1123.5, h = 75.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_bar1.png",
      name = "progress_bar_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487, 443)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "target_reward1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(520, 417)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "target_reward2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(698.5, 417)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "target_reward3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(863.5, 416)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(186.5, 313)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "layer_hero_card",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(237, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186.5, h = 313},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero_card",
      res = "UI/alpha/1080P/activity/grow_plan/panda_img_bg.png",
      name = "hero_card_frame",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.5, 148.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 418, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero_card",
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_bg_mask2.png",
      name = "image_mask2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.5, 29)
    }
  }
}
