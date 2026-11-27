ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaWeeklyWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(527.5, 346)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 256)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 505.5, h = 227},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/peakarena_weekly_report_bg1.png",
      name = "bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.75, 228.5)
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
      name = "Label_4141",
      z = 0,
      parent = "bg1",
      text = T("\231\187\147\231\174\151\230\174\181\228\189\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(167.75, 147.5)
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
      name = "Label_4141_Copy0",
      z = 0,
      parent = "bg1",
      text = T("\231\187\147\231\174\151\231\167\175\229\136\134\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(167.75, 112)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(514.25, 334.5)
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
      name = "Label_4141_Copy1",
      z = 0,
      parent = "bg1",
      text = T("\232\141\163\232\170\137\229\139\139\231\171\160\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(167.75, 75)
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
      name = "Label_4141_Copy2",
      z = 0,
      parent = "bg1",
      text = T("\231\187\147\231\174\151\230\142\146\229\144\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(167.75, 39)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(122.5, 49)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_ok",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(10, 10, 95, 30)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.95, h = 42.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg1",
      res = "UI/alpha/1080P/toparena/rank/toparena_rank_icon_3.png",
      name = "ImageView_4145",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279.25, 151)
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
      fix_scale = {y = 0.49999997, x = 0.49999997},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.49999595, h = 31.249998125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg1",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_3.png",
      name = "ImageView_4146",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(324.75, 148)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4149",
      z = 0,
      parent = "bg1",
      text = T("\229\145\168\229\165\150\229\138\177\229\183\178\233\128\154\232\191\135\233\130\174\228\187\182\229\143\145\230\148\190\239\188\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254.75, -17.5)
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
      name = "Label_4150",
      z = 0,
      parent = "bg1",
      text = "No.12345",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(264.75, 39)
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
      name = "Label_4150_Copy0",
      z = 0,
      parent = "bg1",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(264.75, 75)
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
      name = "Label_896",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174 \229\174\154"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.25, 25.5)
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
      name = "Label_4150_Copy1",
      z = 0,
      parent = "bg1",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(264.75, 112)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg1",
      res = "UI/alpha/1080P/icon/money_top_pvp_big.png",
      name = "ImageView_4153",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(317.25, 75)
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
      name = "label_title",
      z = 0,
      parent = "bg1",
      text = T("\229\145\168\230\138\165"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(252.75, 209.5)
    }
  }
}
