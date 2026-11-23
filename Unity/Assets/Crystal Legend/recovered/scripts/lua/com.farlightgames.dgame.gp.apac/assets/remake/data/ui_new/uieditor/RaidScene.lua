ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/raid/bg.jpg",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 560.5, h = 62.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/raid/map_title.png",
      name = "bg_title",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420.5, 605)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(97, 10, 11),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg_title",
      text = T("1-1  \229\133\168\229\134\155\229\135\186\229\135\187"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(280.25, 33.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 64.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/arrow/pageup_arrow.png",
      name = "arrow_right",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(984.5, 373)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -47, h = 64.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/arrow/pageup_arrow.png",
      name = "arrow_left",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186, 373)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 81)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_info",
      z = 5,
      parent = "bg",
      res = "UI/alpha/1080P/raid/rank_bg.png",
      capInsets = CCRectMake(12, 12, 12, 12)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 149)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "info2",
      z = 0,
      parent = "bg_info",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 40.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "info1",
      z = 0,
      parent = "bg_info",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 64.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "info3",
      z = 0,
      parent = "bg_info",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_rank",
      z = 0,
      parent = "bg_info",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_shop",
      z = 0,
      parent = "bg_info",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(440, 40.5)
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
      parent = "btn_rank",
      text = T("\228\188\164\229\174\179\230\142\146\229\144\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 19.75)
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
      name = "label_shop",
      z = 0,
      parent = "btn_shop",
      text = T("\229\133\172\228\188\154\229\149\134\229\186\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 419, h = 19},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/raid/enter_progress.png",
      name = "enter_progress",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(280.25, -2.25)
    }
  }
}
