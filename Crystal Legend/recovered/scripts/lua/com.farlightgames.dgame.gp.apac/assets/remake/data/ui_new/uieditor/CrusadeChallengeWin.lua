ed.uieditor = ed.uieditor or {}
ed.uieditor.CrusadeChallengeWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(569, 180)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "battleinfo",
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
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "battleinfo",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(550, 162)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.04999485, h = 38.14999455},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "battleinfo",
      res = "UI/alpha/1080P/crusade/main_head_frame_kings_s8.png",
      name = "enemyIcon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 152)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2, x = 2.79999924},
      flip = "",
      opacity = 192,
      fix_wh = {w = 225.39993882, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "battleinfo",
      res = "UI/alpha/1080P/crusade/tip_detail_bg.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160, 152)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.450001855, h = 35.750001925},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "battleinfo",
      res = "UI/alpha/1080P/ranking/lv_bg.png",
      name = "levelBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.5, 151)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 115),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level",
      z = 0,
      parent = "battleinfo",
      text = "99",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.5, 152)
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
      name = "heroName",
      z = 0,
      parent = "battleinfo",
      text = T("NickName"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.5, 152)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(172, 165, 163),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "currentBattle",
      z = 0,
      parent = "battleinfo",
      text = T("\229\133\179\229\141\161(9/10)"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320.5, 152.5)
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
      parent = "battleinfo",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "hero1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 56)
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
      parent = "battleinfo",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "hero2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.5, 56)
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
      parent = "battleinfo",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "hero3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231.5, 56)
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
      parent = "battleinfo",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "hero4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.5, 56)
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
      parent = "battleinfo",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "hero5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(396.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "battleinfo",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "start",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(503.5, 54)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildHint",
      z = 0,
      parent = "battleinfo",
      text = T("\230\157\165\232\135\170\229\133\172\228\188\154\239\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 115.5)
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
      name = "guildName",
      z = 0,
      parent = "battleinfo",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(124, 115)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2427",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.2, h = 36.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "start",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "ImageView_2443",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 50.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 225, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2444",
      z = 0,
      parent = "start",
      text = T("\230\140\145 \230\136\152"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 25.25)
    }
  }
}
