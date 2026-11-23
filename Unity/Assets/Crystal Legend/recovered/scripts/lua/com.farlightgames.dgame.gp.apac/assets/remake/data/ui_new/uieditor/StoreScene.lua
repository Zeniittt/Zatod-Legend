ed.uieditor = ed.uieditor or {}
ed.uieditor.StoreScene = {
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
      fix_wh = {w = 2, h = 469},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/tab.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187.5, 226)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "line",
      res = "UI/alpha/1080P/newshop/tab01.png",
      name = "btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn1",
      res = "UI/alpha/1080P/newshop/tab03.png",
      name = "select1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select1",
      res = "UI/alpha/1080P/newshop/tab04.png",
      name = "spoint1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select1",
      res = "UI/alpha/1080P/newshop/diamond.png",
      name = "btn_sicon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "btn1",
      name = "unselect1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_sname1",
      z = 0,
      parent = "select1",
      text = T("\233\146\187 \231\159\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "line",
      res = "UI/alpha/1080P/newshop/tab01.png",
      name = "btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84.5, 378.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect1",
      res = "UI/alpha/1080P/newshop/tab02.png",
      name = "point1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect1",
      res = "UI/alpha/1080P/newshop/diamond01.png",
      name = "btn_icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-38, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 154, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_name1",
      z = 0,
      parent = "unselect1",
      text = T("\233\146\187 \231\159\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-14, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(688.5, 440)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(204, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "line",
      res = "UI/alpha/1080P/newshop/tab01.png",
      name = "btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84.5, 314.5)
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
      parent = "btn2",
      name = "unselect2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn2",
      res = "UI/alpha/1080P/newshop/tab03.png",
      name = "select2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "line",
      res = "UI/alpha/1080P/newshop/tab01.png",
      name = "btn5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84.5, 186.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect2",
      res = "UI/alpha/1080P/newshop/tab02.png",
      name = "point2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect2",
      res = "UI/alpha/1080P/newshop/gift_title1.png",
      name = "btn_icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-38, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 154, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_name2",
      z = 0,
      parent = "unselect2",
      text = T("\233\153\144 \232\180\173"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-14, 0)
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
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192.5, 504.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137.5, h = 35.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/titile_bg.png",
      name = "bg_secret",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(632.5, 502.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "line",
      res = "UI/alpha/1080P/newshop/tab01.png",
      name = "btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84.5, 250.5)
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
      parent = "btn3",
      name = "unselect3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select2",
      res = "UI/alpha/1080P/newshop/tab04.png",
      name = "spoint2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select2",
      res = "UI/alpha/1080P/newshop/gift_title.png",
      name = "btn_sicon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn3",
      res = "UI/alpha/1080P/newshop/tab03.png",
      name = "select3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_sname2",
      z = 0,
      parent = "select2",
      text = T("\233\153\144 \232\180\173"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "line",
      res = "UI/alpha/1080P/newshop/tab01.png",
      name = "btn6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84.5, 123)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(204.5, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_minor_tips",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      capInsets = CCRectMake(16, 11.5, 16, 11.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 39)
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
      parent = "btn5",
      name = "unselect5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect3",
      res = "UI/alpha/1080P/newshop/tab02.png",
      name = "point3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect3",
      res = "UI/alpha/1080P/newshop/monthcard_title1.png",
      name = "btn_icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-38, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn5",
      res = "UI/alpha/1080P/newshop/tab03.png",
      name = "select5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 154, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_name3",
      z = 0,
      parent = "unselect3",
      text = T("\230\156\136 \229\141\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-14, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select3",
      res = "UI/alpha/1080P/newshop/tab04.png",
      name = "spoint3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select3",
      res = "UI/alpha/1080P/newshop/monthcard_title.png",
      name = "btn_sicon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_sname3",
      z = 0,
      parent = "select3",
      text = T("\230\156\136 \229\141\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_secret",
      res = "UI/alpha/1080P/newshop/titile_icon_bg.png",
      name = "btn_secret",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.25, 17.75)
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
      parent = "btn4",
      name = "unselect4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn4",
      res = "UI/alpha/1080P/newshop/tab03.png",
      name = "select4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 220, 146),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_secret",
      z = 0,
      parent = "bg_secret",
      text = T("\231\167\152\229\175\134\229\174\157\229\140\163"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.75, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect5",
      res = "UI/alpha/1080P/newshop/tab02.png",
      name = "point5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect5",
      res = "UI/alpha/1080P/newshop/cndota_title1.png",
      name = "btn_icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-38, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 154, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_name5",
      z = 0,
      parent = "unselect5",
      text = T("\229\186\148\230\143\180\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-14, 0)
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
      parent = "btn6",
      name = "unselect6",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select5",
      res = "UI/alpha/1080P/newshop/tab04.png",
      name = "spoint5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select5",
      res = "UI/alpha/1080P/newshop/cndota_title.png",
      name = "btn_sicon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn6",
      res = "UI/alpha/1080P/newshop/tab03.png",
      name = "select6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_sname5",
      z = 0,
      parent = "select5",
      text = T("\229\186\148\230\143\180\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.5, 29.25)
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
      parent = "btn_minor_tips",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "ImageView_10481",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 16.25)
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
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_secret",
      res = "UI/alpha/1080P/newshop/titile_icon.png",
      name = "icon_secret",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.25, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect4",
      res = "UI/alpha/1080P/newshop/tab02.png",
      name = "point4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect4",
      res = "UI/alpha/1080P/newshop/celebration_title1.png",
      name = "btn_icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-38, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_secret",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "secret_redlight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.25, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 154, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_name4",
      z = 0,
      parent = "unselect4",
      text = T("\232\138\130\229\186\134\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-14, 0)
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
      name = "label_minor_tips",
      z = 0,
      parent = "btn_minor_tips",
      text = T("\230\156\170\230\136\144\229\185\180\232\180\173\228\185\176\230\179\168\230\132\143\228\186\139\233\161\185"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select4",
      res = "UI/alpha/1080P/newshop/tab04.png",
      name = "spoint4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select4",
      res = "UI/alpha/1080P/newshop/celebration_title .png",
      name = "btn_sicon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_sname4",
      z = 0,
      parent = "select4",
      text = T("\232\138\130\229\186\134\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect6",
      res = "UI/alpha/1080P/newshop/tab02.png",
      name = "point6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect6",
      res = "UI/alpha/1080P/newshop/allstar_title1.png",
      name = "btn_icon6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-38, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 154, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_name6",
      z = 0,
      parent = "unselect6",
      text = T("\229\135\176\231\190\189\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-14, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select6",
      res = "UI/alpha/1080P/newshop/tab04.png",
      name = "spoint6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select6",
      res = "UI/alpha/1080P/newshop/allstar_title.png",
      name = "btn_sicon6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_sname6",
      z = 0,
      parent = "select6",
      text = T("\229\135\176\231\190\189\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.5, 29.25)
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
      parent = "ImageView_10481",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_10482",
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
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "line",
      res = "UI/alpha/1080P/newshop/tab01.png",
      name = "btn7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84.5, 60.5)
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
      parent = "btn7",
      name = "unselect7",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn7",
      res = "UI/alpha/1080P/newshop/tab03.png",
      name = "select7",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect7",
      res = "UI/alpha/1080P/newshop/tab02.png",
      name = "point7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselect7",
      res = "UI/alpha/1080P/newshop/dragonboat_title1.png",
      name = "btn_icon7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-38, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 154, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_name7",
      z = 0,
      parent = "unselect7",
      text = T("\231\171\175\229\141\136\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-14, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select7",
      res = "UI/alpha/1080P/newshop/tab04.png",
      name = "spoint7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "select7",
      res = "UI/alpha/1080P/newshop/dragonboat_title.png",
      name = "btn_sicon7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_sname7",
      z = 0,
      parent = "select7",
      text = T("\231\171\175\229\141\136\231\164\188\229\140\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65.5, 29.25)
    }
  }
}
