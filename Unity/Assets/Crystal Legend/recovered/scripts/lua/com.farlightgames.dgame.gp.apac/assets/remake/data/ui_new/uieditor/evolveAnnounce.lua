ed.uieditor = ed.uieditor or {}
ed.uieditor.evolveAnnounce = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(530.5, 248)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 264.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 348, h = 347.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_starup_light.png",
      name = "light",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.75, 247)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 264.00002112, h = 78.00000624},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_starup_word.png",
      name = "title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.25, 254)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 519.5, h = 107.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_upgrade_hero_bg.png",
      name = "bg_heroicon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(252.75, 149.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 491.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_star_lock_bg.png",
      name = "bg_star",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.25, 55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157.75, 53.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385.25, 52.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(274.25, 54.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(245.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(305.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star1",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "ImageView_11668",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star2",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "ImageView_11674",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star3",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "ImageView_11682",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star4",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "ImageView_11683",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "star5",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "ImageView_11684",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  }
}
