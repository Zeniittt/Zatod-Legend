ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailSkDemo = {
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
      z = 0,
      name = "layer_skill"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(478.5, 253.5)
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
      z = 0,
      name = "layer_skill_small",
      parent = "layer_skill"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      fix_scale = {x = 1, y = 1},
      fix_wh = {w = 345, h = 228.5}
    },
    t = "Sprite",
    base = {
      z = 0,
      name = "image_bg_name",
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/hero/hero_bg_mid_2.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-219, 118)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      fix_scale = {x = 1, y = 1},
      fix_wh = {w = 213, h = 38}
    },
    t = "Sprite",
    base = {
      z = 0,
      name = "frame_name_bg",
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/hero/rank/hero_rank_1.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-218.5, 205.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scalexy = {x = 1, y = 1},
      color = ccc3(255, 252, 231),
      horizontalAlignment = 0,
      verticalAlignment = 1
    },
    t = "Label",
    base = {
      z = 0,
      name = "hero_name",
      parent = "frame_name_bg",
      yfont = T("fonts/DFYuanW7-GB2312.ttf"),
      text = T("\232\136\185\233\149\191+2"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 460.5)
    },
    t = "Scale9Sprite",
    base = {
      z = 0,
      name = "bg_skill_info",
      parent = "layer_skill",
      res = "UI/alpha/1080P/hero/hero_info_bg_0.png",
      capInsets = CCRectMake(18, 150, 18.5, 160)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204, 4)
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
      z = 0,
      name = "layer_skill_bottom",
      parent = "bg_skill_info"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(225, 230.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(153, 43),
      scalexy = {x = 1, y = 1},
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      z = 0,
      name = "btn_skillup",
      parent = "layer_skill_bottom",
      yfont = T("fonts/DFYuanW7-GB2312.ttf"),
      text = T("\229\141\135\231\186\167"),
      size = 24,
      normal = "UI/alpha/1080P/package/btn_package2.png",
      press = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(35.5, 13, 21.5, 13)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -200)
    }
  },
  {
    config = {
      rotation = 30,
      flip = "",
      opacity = 118,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      z = 0,
      name = "layer_test",
      parent = "layer_skill"
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-270.3724, -66.0906)
    }
  },
  {
    config = {
      rotation = 5,
      flip = "xy",
      opacity = 229,
      visible = false,
      fix_scale = {x = 1, y = 1},
      fix_wh = {w = 33.5, h = 35.5}
    },
    t = "Sprite",
    base = {
      z = 0,
      name = "sprite_test",
      parent = "layer_test",
      res = "UI/alpha/1080P/activity/activity_tag_img_days_login_b.png"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 20,
      flip = "xy",
      opacity = 229,
      visible = false,
      scaleSize = CCSizeMake(100, 150)
    },
    t = "Scale9Sprite",
    base = {
      z = 0,
      name = "image_test",
      parent = "layer_test",
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      capInsets = CCRectMake(15.5, 11.5, 17, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296.1102, 199.5025)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scalexy = {x = 1, y = 1},
      color = ccc3(255, 255, 255),
      horizontalAlignment = 1,
      verticalAlignment = 1
    },
    t = "Label",
    base = {
      z = 0,
      name = "label_test",
      parent = "layer_test",
      yfont = T("fonts/DFYuanW7-GB2312.ttf"),
      text = T("Text Label"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scalexy = {x = 1, y = 1},
      color = ccc3(255, 255, 255),
      horizontalAlignment = 2,
      verticalAlignment = 2
    },
    t = "Label",
    base = {
      z = 0,
      name = "label_test_0",
      parent = "layer_test",
      yfont = T("fonts/DFYuanW7-GB2312.ttf"),
      text = T("Text Label"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.83015, -1.83015)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scalexy = {x = 1, y = 1},
      color = ccc3(255, 255, 255),
      horizontalAlignment = 0,
      verticalAlignment = 0
    },
    t = "Label",
    base = {
      z = 0,
      name = "label_test_0_0",
      parent = "layer_test",
      yfont = T("fonts/DFYuanW7-GB2312.ttf"),
      text = T("Text Label"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.66035, -3.66035)
    }
  }
}
