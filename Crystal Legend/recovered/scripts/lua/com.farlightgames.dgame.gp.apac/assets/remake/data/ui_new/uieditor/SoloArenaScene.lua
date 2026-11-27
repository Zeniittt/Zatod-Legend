ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloArenaScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
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
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 509)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/chess/main/title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.25, 17.75)
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
      parent = "bg_title",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192.25, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 107},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/heart.png",
      name = "rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 395.5)
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
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_1339",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 249.5, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/limitefree.png",
      name = "bg_free",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173.5, 255.5)
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
      z = 9,
      parent = "rank",
      text = T("\231\167\175\229\136\134:150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "rank",
      res = "UI/alpha/1080P/chesscard/main/rank_text.png",
      name = "ImageView_2555",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -1.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 240.5, h = 89},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/button_1.png",
      name = "btn_match",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 169.575, h = 63.325},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/button_2.png",
      name = "btn_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(769, 167)
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
      name = "label_free",
      z = 0,
      parent = "bg_free",
      text = T("\230\156\172\229\145\168\233\153\144\229\133\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.75, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 229, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_grade",
      z = 0,
      parent = "ImageView_2555",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_free_time",
      z = 0,
      parent = "bg_free",
      text = "4.27-5.6",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.25, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/bg.png",
      name = "btn_book",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(898, 443.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/bg.png",
      name = "btn_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(898, 350.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_match",
      res = "UI/alpha/1080P/chesscard/main/match.png",
      name = "icon_match",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.25, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(477, 197)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 199.5, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/button_2.png",
      name = "btn_robot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(755, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_team",
      res = "UI/alpha/1080P/chesscard/main/teammatch.png",
      name = "icon_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.75, 37.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/bg.png",
      name = "btn_history",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(898, 257.5)
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
      name = "label_match",
      z = 0,
      parent = "icon_match",
      text = T("\229\164\169\230\162\175\229\140\185\233\133\141"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.75, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 250, 227),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_compendium",
      z = 1,
      parent = "btn_book",
      text = T("\229\155\190\233\137\180"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_book",
      res = "UI/alpha/1080P/chesscard/main/gallery.png",
      name = "btn_book_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 250, 227),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 1,
      parent = "btn_rank",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 8.5)
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
      name = "label_team",
      z = 0,
      parent = "icon_team",
      text = T("\231\187\132\233\152\159"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank",
      res = "UI/alpha/1080P/chesscard/main/ranking.png",
      name = "btn_rank_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_robot",
      res = "UI/alpha/1080P/chesscard/main/casual.png",
      name = "icon_robot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.75, 37.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 250, 227),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_history",
      z = 1,
      parent = "btn_history",
      text = T("\232\174\176\229\189\149"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_history",
      res = "UI/alpha/1080P/chesscard/main/history.png",
      name = "btn_history_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 199.5, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/button_2.png",
      name = "btn_leisure",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213.5, 74)
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
      name = "label_robot",
      z = 0,
      parent = "icon_robot",
      text = T("\228\186\186\230\156\186"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.25, 22.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_leisure",
      res = "UI/alpha/1080P/chesscard/main/casual.png",
      name = "icon_leisure",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.75, 37.25)
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
      name = "label_leisure",
      z = 0,
      parent = "icon_leisure",
      text = T("\228\188\145\233\151\178"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.25, 22.75)
    }
  }
}
