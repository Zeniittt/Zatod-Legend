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
      fix_wh = {w = 120, h = 152.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/rank_bg.png",
      name = "bg_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.5, 417)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 558, h = 87},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/freetime_bg.png",
      name = "bg_free",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 238.5, h = 87},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/match_button.png",
      name = "btn_match",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(812, 67)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 72.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/teammatch_bg.png",
      name = "btn_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(831.5, 157)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/gallery.png",
      name = "btn_book",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(896, 490.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/ranking.png",
      name = "btn_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(896, 394.5)
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
      position = ccp(463, 195.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 72.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/main/teammatch_bg.png",
      name = "btn_robot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(831.5, 239)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 107},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_rank",
      res = "UI/alpha/1080P/chesscard/main/rank.png",
      name = "rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 76.25)
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
      parent = "bg_rank",
      text = T("\231\167\175\229\136\134:150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, -2.75)
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
      position = ccp(60.5, 57)
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
      name = "label_free_time",
      z = 0,
      parent = "bg_free",
      text = "4.27-5.6",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
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
      position = ccp(62.25, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 48.5},
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
      position = ccp(64.75, 36.25)
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
      name = "label_compendium",
      z = 1,
      parent = "btn_book",
      text = T("\229\155\190\233\137\180"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, -2)
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
      name = "label_rank",
      z = 1,
      parent = "btn_rank",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, -1.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 48.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_robot",
      res = "UI/alpha/1080P/chesscard/main/teammatch.png",
      name = "icon_robot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.75, 36.25)
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
      name = "label_match",
      z = 0,
      parent = "icon_match",
      text = T("\229\188\128\229\167\139\229\140\185\233\133\141"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.75, 27.5)
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
      name = "label_team",
      z = 0,
      parent = "icon_team",
      text = T("\231\187\132\233\152\159"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 24.25)
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
      name = "label_robot",
      z = 0,
      parent = "icon_robot",
      text = T("\228\186\186\230\156\186"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 24.25)
    }
  }
}
