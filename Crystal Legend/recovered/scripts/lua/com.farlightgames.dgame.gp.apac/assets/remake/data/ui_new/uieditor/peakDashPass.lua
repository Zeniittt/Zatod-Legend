ed.uieditor = ed.uieditor or {}
ed.uieditor.peakDashPass = {
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
      res = "UI/alpha/1080P/fundpeak/bg.jpg",
      name = "page_lay",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(520, 238)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "pass_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(423, 211.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(613.5, 40)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "title_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(330, 453)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level",
      z = 0,
      parent = "page_lay",
      text = T("\231\180\175\232\174\161\230\182\136\232\128\151\228\189\147\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377, 431.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 320, h = 363},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/fundpeak/Goblin.png",
      name = "ImageView_341",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1031.5, 256.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 189),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_base_reward",
      z = 0,
      parent = "page_lay",
      text = T("\229\159\186\231\161\128\230\148\182\231\155\138"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(373, 353.5)
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
      name = "label_advanced_reward",
      z = 0,
      parent = "page_lay",
      text = T("\230\138\149\232\181\132\229\155\158\230\138\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(373, 261)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 402, h = 105},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/fundpeak/title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(632.5, 524.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 203.575, h = 61.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_buy",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(632.5, 144.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(94.5, 20.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "cur_level_bg",
      z = 0,
      parent = "page_lay",
      res = "UI/alpha/1080P/fundpeak/showbg.png",
      capInsets = CCRectMake(40, 0, 6, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(376.5, 410.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/fundpeak/timebg.png",
      name = "left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(632.5, 187.5)
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
      name = "label_buy",
      z = 0,
      parent = "btn_buy",
      text = T("\232\180\173\228\185\176"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.25, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 213, 81),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cur_level_label",
      z = 0,
      parent = "cur_level_bg",
      text = "2500",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.25, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_time_bg",
      res = "UI/alpha/1080P/fundpeak/time.png",
      name = "left_time_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 221, 177),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_time_label",
      z = 0,
      parent = "left_time_bg",
      text = T("\229\137\169\228\189\15312\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148, 13)
    }
  }
}
