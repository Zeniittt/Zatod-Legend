ed.uieditor = ed.uieditor or {}
ed.uieditor.dragonBoatRankScene = {
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
      res = "UI/alpha/1080P/dragonboat/db_ranking_list/bg_1.jpg",
      name = "bj",
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
      fix_wh = {w = 1006, h = 597},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_ranking_list/bg_ranking_list.png",
      name = "ImageView_2668",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 300)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(115, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(22.5, 0, 3, 0.5),
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      name = "ImageView_2669",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(930, 507)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 333, h = 59},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_db_title.png",
      name = "img_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127, 509)
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
      name = "Label_count",
      z = 0,
      parent = "ImageView_2669",
      text = "999",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(76.5, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(623, 272)
    },
    t = "Layer",
    base = {
      parent = "ImageView_2668",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(199, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2669",
      res = "UI/alpha/1080P/dragonboat/db_race/db_zongzi_icon.png",
      name = "ImageView_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 627.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2668",
      res = "UI/alpha/1080P/dragonboat/db_ranking_list/db_list_mask.png",
      name = "ImageView_2673",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(509.5, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2668",
      res = "UI/alpha/1080P/dragonboat/db_ranking_list/bg_ranking_time.png",
      name = "ImageView_2679",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(457.5, 437.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 255, 224),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 0,
      parent = "ImageView_2668",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(479, 438)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "ImageView_2668",
      name = "Panel_head_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(323.5, 376)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "img_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-1, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title_bg",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "img_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_close",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_313",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_315",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  }
}
