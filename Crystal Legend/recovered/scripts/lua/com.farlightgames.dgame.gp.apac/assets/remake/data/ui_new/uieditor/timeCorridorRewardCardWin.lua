ed.uieditor = ed.uieditor or {}
ed.uieditor.timeCorridorRewardCardWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 84.5, h = 40},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/summon/skip_btn.png",
      name = "btn_skip",
      z = 999,
      text = "",
      press = "UI/alpha/1080P/summon/skip_btn.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(873, 503)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "content_panel",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, -0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 443},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/tavern_get_hero_bg_blue.jpg",
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
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "fashion_panel",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, -0.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 222, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skip",
      z = 0,
      parent = "btn_skip",
      text = T("\232\183\179\232\191\135"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(49.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(415, 48.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "content_title",
      z = 0,
      parent = "content_panel",
      res = "UI/alpha/1080P/summon/reward_title_bg.png",
      capInsets = CCRectMake(45, 16.5, 45, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 452)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(20, 20)
    },
    t = "Layer",
    base = {
      parent = "content_panel",
      name = "pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 290)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "content_panel",
      name = "content_decomp",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 165)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(415, 48.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "fashion_title",
      z = 9,
      parent = "fashion_panel",
      res = "UI/alpha/1080P/summon/reward_title_bg.png",
      capInsets = CCRectMake(45, 16.5, 45, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 452)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(20, 20)
    },
    t = "Layer",
    base = {
      parent = "fashion_panel",
      name = "puppet_pos",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 290)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.3, x = 1.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 282.75, h = 61.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "fashion_panel",
      res = "UI/alpha/1080P/summon/get_new_hero_bar.png",
      name = "fashion_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 143.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 90, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fashion_name_label",
      z = 0,
      parent = "fashion_panel",
      text = T("\232\151\143\229\137\145\228\185\139\229\191\131"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "fashion_panel",
      name = "fashion_decomp",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 346.5, h = 351.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "fashion_panel",
      res = "UI/alpha/1080P/skin/skin_get_light.png",
      name = "get_skin_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 290)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263.5, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "content_panel",
      res = "UI/alpha/1080P/timecorridor/timecorridor_text_bg_3.png",
      name = "content_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 215)
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
      name = "label_title",
      z = 0,
      parent = "content_title",
      text = T("\230\129\173\229\150\156\232\142\183\229\190\151"),
      size = 33
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.5, 24.25)
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
      name = "content_decomp_tip",
      z = 0,
      parent = "content_decomp",
      text = T("\229\183\178\230\139\165\230\156\137\239\188\140\229\183\178\232\135\170\229\138\168\229\136\134\232\167\163\228\184\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "content_decomp",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_token_1.png",
      name = "content_decomp_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80, 0)
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
      name = "content_decomp_num",
      z = 0,
      parent = "content_decomp",
      text = "+99",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 159.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "fashion_title",
      res = "UI/alpha/1080P/skin/skin_get_slogan.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.5, 24.25)
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
      name = "fashion_decomp_tip",
      z = 0,
      parent = "fashion_decomp",
      text = T("\229\183\178\230\139\165\230\156\137\239\188\140\229\183\178\232\135\170\229\138\168\229\136\134\232\167\163\228\184\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "fashion_decomp",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_token_1.png",
      name = "fashion_decomp_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80, 0)
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
      name = "fashion_decomp_num",
      z = 0,
      parent = "fashion_decomp",
      text = "+99",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(102, 70, 32),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 0,
      parent = "content_name_bg",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.75, 16.25)
    }
  }
}
