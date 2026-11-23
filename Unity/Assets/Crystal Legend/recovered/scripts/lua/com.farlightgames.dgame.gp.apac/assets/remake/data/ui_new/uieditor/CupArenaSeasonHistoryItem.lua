ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaSeasonHistoryItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 377.5, h = 526},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/honor/history_bg.png",
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
      fix_wh = {w = 318.5, h = 90.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/history_dec.png",
      name = "ImageView_25318",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.25, 256)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_7_name.png",
      name = "img_grade_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.25, 290.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 105},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_7.png",
      name = "img_grade_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.25, 380)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/history_info_bg.png",
      name = "bg_zone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.75, 164.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/history_info_bg.png",
      name = "bg_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.75, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/history_info_bg.png",
      name = "bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.75, 108.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/history_info_bg.png",
      name = "bg_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.75, 80.5)
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
      parent = "bg",
      text = T("\232\181\155\229\173\163"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.75, 248)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(228, 191, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zone_des",
      z = 0,
      parent = "bg_zone",
      text = T("\232\181\155\229\140\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(228, 191, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp_des",
      z = 0,
      parent = "bg_camp",
      text = T("\233\152\181\232\144\165"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.25, 11.75)
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
      name = "label_camp_info",
      z = 0,
      parent = "bg_camp",
      text = "1234",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(103.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(228, 191, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_des",
      z = 0,
      parent = "bg_score",
      text = T("\231\167\175\229\136\134"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.25, 11.75)
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
      name = "label_score_val",
      z = 0,
      parent = "bg_score",
      text = T("\230\156\170\228\184\138\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(103.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(228, 191, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_medal_des",
      z = 0,
      parent = "bg_medal",
      text = T("\229\139\139\231\171\160"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.25, 13.25)
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
      name = "label_medal_val",
      z = 0,
      parent = "bg_medal",
      text = T("\230\156\170\228\184\138\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(103.75, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/honor/history_info_bg.png",
      name = "bg_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.75, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 20)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_season",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(141.25, 207)
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
      name = "label_zone_info",
      z = 0,
      parent = "bg_zone",
      text = T("\231\172\1721\232\181\155\229\140\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(103.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.25, h = 26.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_medal",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "img_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(228, 191, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_des",
      z = 0,
      parent = "bg_rank",
      text = T("\230\142\146\229\144\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.25, 13.25)
    }
  }
}
