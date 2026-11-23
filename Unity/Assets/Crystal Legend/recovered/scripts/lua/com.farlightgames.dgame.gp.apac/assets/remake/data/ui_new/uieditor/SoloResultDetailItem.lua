ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloResultDetailItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 672, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/log/otherplayer_bg.png",
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
      fix_wh = {w = 57, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/label_1.png",
      name = "bg_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.999991, h = 44.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_bg.png",
      name = "icon_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 23.5)
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
      name = "label_level",
      z = 0,
      parent = "bg",
      text = "Lv.12",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 10)
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
      name = "label_name",
      z = 0,
      parent = "bg",
      text = T("\231\142\139\230\137\145\229\133\139"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(108, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76, h = 10.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/bar_2.png",
      name = "bg_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145.5, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.999991, h = 44.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "power2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(601, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.999991, h = 44.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "power3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(646.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.999991, h = 44.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "power1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(555.5, 23.5)
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
      name = "label_score",
      z = 0,
      parent = "bg",
      text = "20",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229.5, 23.5)
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
      name = "label_vic",
      z = 0,
      parent = "bg",
      text = "20",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(354, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/faction_bg1.png",
      name = "ImageView_13148",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(472, 23.5)
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
      name = "label_rank",
      z = 0,
      parent = "bg_rank",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76, h = 10.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/chesscard/log/bar_1.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 5.25)
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
      name = "label_bar",
      z = 0,
      parent = "bg_bar",
      text = "0/30",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 5.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.72, x = 0.72},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.52, h = 25.56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13148",
      res = "UI/alpha/1080P/chesscard/faction_6.png",
      name = "icon_faction",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(4, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13148",
      res = "UI/alpha/1080P/chesscard/log/star.png",
      name = "bg_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-2, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13148",
      res = "UI/alpha/1080P/chesscard/log/star.png",
      name = "bg_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7.5, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13148",
      res = "UI/alpha/1080P/chesscard/log/star.png",
      name = "bg_star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13148",
      res = "UI/alpha/1080P/chesscard/log/star.png",
      name = "bg_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-12.5, 4.75)
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
      name = "label_exp",
      z = 0,
      parent = "ImageView_13148",
      text = "25/40",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star2",
      res = "UI/alpha/1080P/chesscard/log/star_1.png",
      name = "star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 7.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star3",
      res = "UI/alpha/1080P/chesscard/log/star_1.png",
      name = "star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 7.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star4",
      res = "UI/alpha/1080P/chesscard/log/star_1.png",
      name = "star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 7.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star1",
      res = "UI/alpha/1080P/chesscard/log/star_1.png",
      name = "star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 7.75)
    }
  }
}
