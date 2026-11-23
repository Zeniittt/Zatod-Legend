ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_pet_fund = {
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
      res = "UI/alpha/1080P/fund/fund_bg_2_1.jpg",
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
      position = ccp(642, 172.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1018.5, h = 561},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/fund/fund_bg_2_2.png",
      name = "ImageView_156",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(679, 351.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(461.5, 238)
    },
    t = "Layer",
    base = {
      parent = "ImageView_156",
      name = "pass_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(300.75, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(537.5, 40)
    },
    t = "Layer",
    base = {
      parent = "ImageView_156",
      name = "title_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(200.75, 386)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level",
      z = 0,
      parent = "ImageView_156",
      text = T("\228\189\191\231\148\168\228\188\160\233\128\129\229\141\183\232\189\180"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248.75, 354.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 271.2, h = 360},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_156",
      res = "UI/alpha/1080P/fund/Goblin_2.png",
      name = "ImageView_341",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(843.25, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 189),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_base_reward",
      z = 0,
      parent = "ImageView_156",
      text = T("\229\159\186\231\161\128\230\148\182\231\155\138"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(246.25, 282.5)
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
      parent = "ImageView_156",
      text = T("\229\159\186\233\135\145\229\155\158\230\138\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(247.25, 190.5)
    }
  }
}
