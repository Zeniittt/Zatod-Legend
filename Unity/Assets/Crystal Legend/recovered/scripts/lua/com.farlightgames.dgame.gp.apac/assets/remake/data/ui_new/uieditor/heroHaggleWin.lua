ed.uieditor = ed.uieditor or {}
ed.uieditor.heroHaggleWin = {
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
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_bg.jpg",
      name = "page_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.5, 272.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 324.5, h = 133},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_title.png",
      name = "title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434, 478.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 189},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_hero_select.png",
      name = "btn_hero",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(739.5, 473.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 633.5, h = 161.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_bg.png",
      name = "layer_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(745, 219)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75.5, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_task_entrance.png",
      name = "btn_currency",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1021, 518)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 231.5, h = 259},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_art.png",
      name = "image_art",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351, 278.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_task_entrance_text_bg.png",
      name = "label_task",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1018.5, 480.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 305.5, h = 343.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_hero_art.png",
      name = "btn_fca",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(725.5, 452)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(111, 100)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "layer_progressInfo",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(745, 219)
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
      parent = "page_lay",
      name = "layer_haggleFca",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(585, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 147.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_line",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_button_orange.png",
      name = "btn_unlock",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(189.25, 38.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139.5, h = 38},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_got.png",
      name = "btn_haggle_done",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(747.5, 185)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 215.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_time_text_bg.png",
      name = "image_time",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 400)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "layer_art",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(109, 140.5)
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
      parent = "page_lay",
      name = "layer_art_fca",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(731, 307)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_item_text_bg.png",
      name = "image_haggleNum",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(502, 303)
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
      z = 3,
      parent = "btn_unlock",
      text = T("328\229\133\131\232\167\163\233\148\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.75, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 147.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_line",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_button_red.png",
      name = "btn_haggle",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(446.75, 38.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 585.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_line",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_progress_1.png",
      name = "image_progressBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319.25, 108.75)
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
      parent = "layer_line",
      name = "layer_rewardStep",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(157.25, 213.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_currency1",
      z = 3,
      parent = "btn_currency",
      text = T("\232\142\183\229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.75, 10.25)
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
      name = "label_currency2",
      z = 3,
      parent = "btn_currency",
      text = T("\231\140\170\231\140\170\229\184\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.75, -8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 305.5, h = 343.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_fca",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_hero_art.png",
      name = "image_fca",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.75, 171.75)
    }
  },
  {
    config = {
      rotation = 9.74549,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_currency",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "task_redpoint",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 15.75)
    }
  },
  {
    config = {
      rotation = 42.1951828,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_hero",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "select_redpoint",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.25, 145.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(199, 298.5)
    },
    t = "Layer",
    base = {
      parent = "btn_fca",
      name = "layer_fca",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(62.75, 25.25)
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
      parent = "btn_unlock",
      name = "layer_refreshEffect",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(73.75, 24)
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
      name = "label_haggle_done",
      z = 3,
      parent = "btn_haggle_done",
      text = T("\229\183\178\232\142\183\229\143\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.75, 20)
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
      parent = "image_time",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_time.png",
      name = "image_time_Copy0",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.75, 14)
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
      name = "label_title_time",
      z = 3,
      parent = "image_time",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48.25, 14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 400)
    },
    t = "Layer",
    base = {
      parent = "layer_art",
      name = "layer_clickFca",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(28.5, -2.5)
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
      parent = "image_haggleNum",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_item_icon.png",
      name = "image_haggleNum_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-1, 14.25)
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
      name = "label_currency_num",
      z = 3,
      parent = "image_haggleNum",
      text = "100/260",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 14.25)
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
      name = "label_haggle",
      z = 3,
      parent = "btn_haggle",
      text = T("\231\160\141\228\184\128\229\136\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.75, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_2.png",
      name = "step2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, -103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_3.png",
      name = "step1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-108, -103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_1.png",
      name = "step3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223.5, -103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_1.png",
      name = "step4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(310, -103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_1.png",
      name = "step5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(374, -103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_key_1.png",
      name = "step6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(438, -103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_price_tag.png",
      name = "ImageView_36434",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.5, -133)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119.5, h = 72},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_rewardStep",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_discount_bg.png",
      name = "image_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420.5, -44)
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
      parent = "layer_rewardStep",
      name = "layer_price",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(432.5, -80.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_fca",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_hero_change.png",
      name = "btn_change",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.75, 313.25)
    }
  },
  {
    config = {
      rotation = 9.74549,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_haggle",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "haggle_redpoint",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.75, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(546, 10)
    },
    t = "Layer",
    base = {
      parent = "image_progressBg",
      name = "image_clipNode",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19.25, 9.75)
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
      name = "label_price2",
      z = 0,
      parent = "step2",
      text = T("328\229\133\131"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.5, -5.25)
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
      name = "label_price1",
      z = 0,
      parent = "step1",
      text = T("648\229\133\131"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, -5.25)
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
      name = "label_price3",
      z = 0,
      parent = "step3",
      text = T("198\229\133\131"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, -5.25)
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
      name = "label_price4",
      z = 0,
      parent = "step4",
      text = T("128\229\133\131"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, -5.25)
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
      name = "label_price5",
      z = 0,
      parent = "step5",
      text = T("98\229\133\131"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, -5.25)
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
      name = "label_price6",
      z = 0,
      parent = "step6",
      text = T("68\229\133\131"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.5, -5.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(70, 60, 62),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_ BenefitPrice",
      z = 0,
      parent = "ImageView_36434",
      text = T("\229\145\168\229\185\180\231\166\143\229\136\169\228\187\183"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(15.75, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 573.5, h = 10},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_clipNode",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_line_progress_2.png",
      name = "image_progress",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-3, 5.5)
    }
  }
}
