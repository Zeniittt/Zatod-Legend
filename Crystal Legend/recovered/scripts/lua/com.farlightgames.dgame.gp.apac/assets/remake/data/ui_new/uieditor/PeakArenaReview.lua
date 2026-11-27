ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaReview = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 406.5, h = 571.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_review_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 279)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.9999865, h = 37.49999375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_6.png",
      name = "image_grade_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206.75, 277.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.3, h = 109.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rank_icon_6.png",
      name = "image_grade_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204.75, 317.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(93.25, 172.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 40)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_season",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(155.25, 382.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_season_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\181\155\229\173\163"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 431.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_detail",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "image_bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, 79)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_detail",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "image_bg_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_detail",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "image_bg_zone_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_detail",
      res = "UI/alpha/1080P/toparena/toparena_review_detail_bg.png",
      name = "image_bg_server_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_1",
      z = 0,
      parent = "image_bg_score",
      text = T("\230\156\128\231\187\136\231\167\175\229\136\134"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 25.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg_score",
      name = "panel_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(92, -0.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_2",
      z = 0,
      parent = "image_bg_medal",
      text = T("\230\137\128\229\177\158\232\181\155\229\140\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
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
      name = "label_medal",
      z = 0,
      parent = "image_bg_medal",
      text = "1234",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(92.5, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_3",
      z = 0,
      parent = "image_bg_zone_rank",
      text = T("\232\181\155\229\140\186\230\142\146\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.86, x = 0.86},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.65, h = 11.61},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_zone_rank",
      res = "UI/alpha/1080P/toparena/text_no.png",
      name = "image_zone_rank_no",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zone_rank",
      z = 0,
      parent = "image_bg_zone_rank",
      text = T("\230\156\170\228\184\138\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(93, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_4",
      z = 0,
      parent = "image_bg_server_rank",
      text = T("\229\133\168\230\156\141\230\142\146\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.86, x = 0.86},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.65, h = 11.61},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_server_rank",
      res = "UI/alpha/1080P/toparena/text_no.png",
      name = "image_server_rank_no",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 220),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server_rank",
      z = 0,
      parent = "image_bg_server_rank",
      text = T("\230\156\170\228\184\138\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(93, 12.75)
    }
  }
}
