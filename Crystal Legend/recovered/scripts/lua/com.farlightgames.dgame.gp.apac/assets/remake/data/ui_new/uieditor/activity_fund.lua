ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_fund = {
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
      res = "UI/alpha/1080P/fund/fund_bg.jpg",
      name = "page_lay",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 679.5, h = 383},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/fund/fung_bg1.png",
      name = "main_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(669.5, 351.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(463.5, 238)
    },
    t = "Layer",
    base = {
      parent = "main_bg",
      name = "pass_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(121.75, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 403, h = 105.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "main_bg",
      res = "UI/alpha/1080P/fund/fund_banner.png",
      name = "title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328.75, 372)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 612.5, h = 180.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/fund/fund_banner_up.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(651, 545.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 40)
    },
    t = "Layer",
    base = {
      parent = "main_bg",
      name = "title_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(28.75, 297)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 121, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level",
      z = 0,
      parent = "main_bg",
      text = T("\230\136\152\233\152\159\231\173\137\231\186\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 274)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 203.575, h = 61.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_buy",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(639.5, 178)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 281, h = 261.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "main_bg",
      res = "UI/alpha/1080P/fund/Goblin.png",
      name = "ImageView_341",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(684.75, 91.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 189, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_base_reward",
      z = 0,
      parent = "main_bg",
      text = T("\229\159\186\231\161\128\230\148\182\231\155\138"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 210.5)
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
      name = "label_buy",
      z = 0,
      parent = "btn_buy",
      text = T("\232\180\173\228\185\176"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.25, 40.5)
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
      name = "label_advanced_reward",
      z = 0,
      parent = "main_bg",
      text = T("\230\138\149\232\181\132\229\155\158\230\138\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.25, 107)
    }
  }
}
