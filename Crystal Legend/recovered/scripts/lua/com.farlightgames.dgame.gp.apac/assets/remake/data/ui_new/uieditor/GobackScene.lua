ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 502.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(137, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(22.5, 0, 3, 0.5),
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      name = "bg_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(846, 507)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/goback/goback_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.75, 19.25)
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
      parent = "bg_rule",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 16.25)
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
      name = "label_rule",
      z = 0,
      parent = "bg_rule",
      text = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 18.25)
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
      name = "ImageView_176",
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
      fix_wh = {w = 2, h = 302.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/goback/goback_tag_line.png",
      name = "bg_btn",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 287)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/goback/goback_img_letter.png",
      name = "btn_mail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(230.25, 19.25)
    }
  }
}
