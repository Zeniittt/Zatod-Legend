ed.uieditor = ed.uieditor or {}
ed.uieditor.skin_sale_pass_page = {
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
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_bg.jpg",
      name = "image_bg",
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
      fix_wh = {w = 423, h = 181.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(803, 550)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 260, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_countdown_bg.png",
      name = "time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(815.5, 479.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 512.5, h = 200.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_gift_bg.png",
      name = "reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(814.5, 354)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 227, h = 87},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_button.png",
      name = "btn_buy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(821.5, 200.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 150)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_pos",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(458.5, 161)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(230, 425)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_card",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(346, 147)
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
      parent = "time_bg",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_clock.png",
      name = "ImageView_94753",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 18)
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
      name = "label_left_time",
      z = 0,
      parent = "time_bg",
      text = T("\229\137\169\228\189\153"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(85, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_bg",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_slogan_deco.png",
      name = "ImageView_94756",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.75, 158.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_bg",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_slogan_deco.png",
      name = "ImageView_94757",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420.75, 158.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward_title",
      z = 0,
      parent = "reward_bg",
      text = T("\232\167\163\233\148\129\229\141\179\232\142\183\232\182\133\229\128\188\229\165\150\229\138\177"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261.75, 161.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 127.5)
    },
    t = "Layer",
    base = {
      parent = "reward_bg",
      name = "reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(62.25, 5.25)
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
      name = "label_buy",
      z = 0,
      parent = "btn_buy",
      text = T("\229\133\133\229\128\1886\229\133\131\232\167\163\233\148\129"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230.5, h = 428},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_card",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_rankframe_5.png",
      name = "hero_card_frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 212)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(220, 386)
    },
    t = "Layer",
    base = {
      parent = "panel_hero_card",
      name = "panel_card_clip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.5, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 166.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "hero_card_frame",
      res = "UI/alpha/1080P/activity/skin_sale/skin_sale_rank_5.png",
      name = "skin_name_bg",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(4.25, 300.5)
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
      name = "label_skin_name",
      z = 0,
      parent = "skin_name_bg",
      text = T("\233\155\170\229\164\156\229\176\132\230\137\139"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 99.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skin_name_bg",
      res = "UI/alpha/1080P/skin/skin_quality_bg_orange.png",
      name = "quality_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 26.25)
    }
  }
}
