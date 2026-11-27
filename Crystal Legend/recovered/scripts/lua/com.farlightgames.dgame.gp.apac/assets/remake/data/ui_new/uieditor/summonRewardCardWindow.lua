ed.uieditor = ed.uieditor or {}
ed.uieditor.summonRewardCardWindow = {
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
      position = ccp(480, 270)
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
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.5, -0.5)
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
    base = {name = "card_panel", z = 0},
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
      scaleSize = CCSizeMake(442.5, 48.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_389",
      z = 9,
      parent = "content_panel",
      res = "UI/alpha/1080P/summon/reward_title_bg.png",
      capInsets = CCRectMake(45, 16.5, 45, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487, 454.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "content_panel",
      name = "pos",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(478, 264.5)
    }
  },
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
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/summon/skip_btn.png",
      name = "btn_skip",
      z = 0,
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
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 326.2500261, h = 71.2500057},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "content_panel",
      res = "UI/alpha/1080P/summon/get_new_hero_bar.png",
      name = "name_bg",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483, 114.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 355.5, h = 77.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_389",
      res = "UI/alpha/1080P/summon/text_got_hero.png",
      name = "title_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(216.25, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 37.5, h = 37.5},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/btn_bg.png",
      name = "btn_share",
      z = 9,
      parent = "content_panel",
      text = "",
      press = "UI/alpha/1080P/common/btn_bg.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(692.5, 115.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 241.2, h = 417.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card_panel",
      res = "UI/art/card_bg_big_2.jpg",
      name = "card",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 287)
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
      name = "tips",
      z = 9,
      parent = "card_panel",
      text = T("\233\135\141\229\164\141\232\142\183\229\190\151\232\175\165\232\139\177\233\155\132\239\188\140\229\183\178\232\135\170\229\138\168\229\136\134\232\167\163\228\184\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(315.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card_panel",
      res = "UI/alpha/1080P/icon/herodetail_soulstone_icon.png",
      name = "res_icon",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(589, 53)
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
      name = "name",
      z = 0,
      parent = "name_bg",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 28.75)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_share",
      res = "UI/alpha/1080P/crusade/btn_share.png",
      name = "ImageView_521",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 270, h = 466},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card",
      res = "UI/alpha/1080P/summon/card_quality_white.png",
      name = "card_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 229)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 151, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "res_num",
      z = 0,
      parent = "res_icon",
      text = "x9999",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 12.25)
    }
  }
}
