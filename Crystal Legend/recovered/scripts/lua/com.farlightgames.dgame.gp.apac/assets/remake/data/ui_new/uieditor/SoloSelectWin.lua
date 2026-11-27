ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloSelectWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/btn_refresh.png",
      name = "btn_refresh",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(790.5, 131.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/hero/point_refresh.png",
      name = "ImageView_9031",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.25, 55.75)
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
      name = "Label_9032",
      z = 0,
      parent = "ImageView_9031",
      text = "1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 157.99999052, h = 57.99999652},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/main/teammatch_bg.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/gold_4.png",
      name = "bg_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(659, 504)
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
      name = "Label_11788",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174 \229\174\154"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.75, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 233.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/power_bg.png",
      name = "card2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 233.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/power_bg.png",
      name = "card1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold",
      res = "UI/alpha/1080P/chesscard/gold_2.png",
      name = "ImageView_11795",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.25, 13.25)
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
      name = "Label_11796",
      z = 0,
      parent = "bg_gold",
      text = "99999",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.75, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 233.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/power_bg.png",
      name = "card3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(670, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 233.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/power_bg.png",
      name = "card4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(660, 297)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card2",
      res = "UI/alpha/1080P/chesscard/hero/hero_unlock.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 171.75)
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
      name = "name2",
      z = 0,
      parent = "card2",
      text = T("\229\138\168\229\138\155\229\176\143\229\173\144"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.75, 107.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 233.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/power_bg.png",
      name = "card5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(824, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(69, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc2",
      z = 0,
      parent = "card2",
      text = "Text Label",
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(17.25, 81.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card1",
      res = "UI/alpha/1080P/chesscard/hero/hero_unlock.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 169.75)
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
      name = "name1",
      z = 0,
      parent = "card1",
      text = T("\229\138\168\229\138\155\229\176\143\229\173\144"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.75, 107.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(69, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc1",
      z = 0,
      parent = "card1",
      text = "Text Label",
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(17.25, 81.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card3",
      res = "UI/alpha/1080P/chesscard/hero/hero_unlock.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 170.75)
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
      name = "name3",
      z = 0,
      parent = "card3",
      text = T("\229\138\168\229\138\155\229\176\143\229\173\144"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 108.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(69, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc3",
      z = 0,
      parent = "card3",
      text = "Text Label",
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(17.25, 81.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 26.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/hero/icon_refresh_item.png",
      name = "ImageView_3084",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.25, 80.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.74999375, h = 69.99999},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card4",
      res = "UI/alpha/1080P/chesscard/hero/power_random.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 170.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/hero/bg_refresh.png",
      name = "ImageView_191",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 4.25)
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
      name = "name4",
      z = 0,
      parent = "card4",
      text = T("\233\154\143\230\156\186\229\174\157\231\137\169"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 112.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(69, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc4",
      z = 0,
      parent = "card4",
      text = T("\229\176\134\228\187\142\229\133\182\228\189\153\229\143\175\228\190\155\233\128\137\230\139\169\231\154\132\229\174\157\231\137\169\228\184\173\239\188\140\233\154\143\230\156\186\232\142\183\229\190\151\228\184\128\228\187\182"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(15.75, 72.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card5",
      res = "UI/alpha/1080P/chesscard/hero/hero_unlock.png",
      name = "icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 171.75)
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
      name = "name5",
      z = 0,
      parent = "card5",
      text = T("\229\176\154\230\156\170\232\167\163\233\148\129"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 112.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(69, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc5",
      z = 0,
      parent = "card5",
      text = T("\229\176\129\229\141\176\230\156\170\232\167\163\239\188\140\229\138\155\233\135\143\230\136\144\231\156\160"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(15.75, 72.75)
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
      name = "Label_3085",
      z = 0,
      parent = "ImageView_3084",
      text = "3/3",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_192",
      z = 0,
      parent = "ImageView_191",
      text = T("\229\136\183\230\150\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 10.75)
    }
  }
}
