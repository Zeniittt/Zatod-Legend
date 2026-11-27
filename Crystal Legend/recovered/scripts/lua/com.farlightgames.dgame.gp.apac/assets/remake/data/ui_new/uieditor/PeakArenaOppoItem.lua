ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaOppoItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_bg_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 227, h = 396},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_enemy_info_bg.png",
      name = "banner",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 283.5)
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
      name = "gs",
      z = 1,
      parent = "banner",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 143.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_gs",
      z = 1,
      parent = "banner",
      text = T("\230\136\152\229\138\155:"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(83.5, 143.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.4999865, h = 31.24999375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_1.png",
      name = "grade",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 195)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(211, 255, 25),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "score",
      z = 1,
      parent = "banner",
      text = "1234",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/toparena/toparena_score_icon.png",
      name = "title_score",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 100.5)
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
      name = "server",
      z = 1,
      parent = "banner",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 169)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_server",
      z = 1,
      parent = "banner",
      text = T("\229\140\186\230\156\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(83.5, 169)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_grade",
      z = 1,
      parent = "banner",
      text = T("\230\174\181\228\189\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(83.5, 195)
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
      name = "name",
      z = 1,
      parent = "banner",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 231.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_score",
      z = 0,
      parent = "title_score",
      text = T("\231\167\175\229\136\134"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 110},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "head",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112.5, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 52.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_battle",
      z = 1,
      parent = "banner",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 81.5, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, -1.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 36},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_chapter_hard_bg_1.png",
      name = "tag_evolve",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 375.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.55, h = 116.1},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/toparena/toparena_total_rank_bg2.png",
      name = "bg_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 392.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212.5, h = 150.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/toparena/toparena_promotion_battle_win.png",
      name = "bg_result_win",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212.5, h = 113.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/toparena/toparena_promotion_battle_lose.png",
      name = "bg_result_lose",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 225.9, h = 109.35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "banner",
      res = "UI/alpha/1080P/toparena/toparena_total_rank_bg1.png",
      name = "bg_rank_low",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112.5, 398)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_battle",
      z = 0,
      parent = "btn_battle",
      text = T("\230\140\145 \230\136\152"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_battle",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "ImageView_1944",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 243, 213),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tag_evolve",
      z = 1,
      parent = "tag_evolve",
      text = T("\230\153\139\231\186\167\229\174\136\229\141\171"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_rank",
      res = "UI/alpha/1080P/toparena/text_no.png",
      name = "rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.25, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 208),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_win",
      z = 0,
      parent = "bg_result_win",
      text = T("\229\183\178\232\131\156\229\136\169"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.75, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 235, 243),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_lose",
      z = 0,
      parent = "bg_result_lose",
      text = T("\229\183\178\229\164\177\232\180\165"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.75, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_rank_low",
      res = "UI/alpha/1080P/toparena/text_no.png",
      name = "rank_low",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_des",
      z = 0,
      parent = "bg_rank",
      text = T("\229\133\168\230\156\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.75, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_des2",
      z = 0,
      parent = "bg_rank_low",
      text = T("\229\133\168\230\156\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 29.25)
    }
  }
}
