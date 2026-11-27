ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_jugg_page = {
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
      res = "UI/alpha/1080P/activity/jugg/jugg_bg.jpg",
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
      fix_wh = {w = 586.5, h = 391.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_bg_finish.png",
      name = "image_get_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(876.5, 340.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 247.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_countdown_bg.png",
      name = "left_time_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(994.5, 516)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 376, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_gold_bg.png",
      name = "item_bg1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(979, 469)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 376, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_yellow_bg.png",
      name = "item_bg2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1038, 399.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 376, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_brown_bg.png",
      name = "item_bg3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1093, 329.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 376, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_red_bg.png",
      name = "item_bg4",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1039, 259.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 376, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_green_bg.png",
      name = "item_bg5",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(980, 189.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 0,
      fix_wh = {w = 358.5, h = 358.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_sun_bg.png",
      name = "image_sun_bg",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(776.5, 322)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 327.5, h = 327.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_sun_lock.png",
      name = "image_sun_lock",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(778, 322)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 653, h = 646.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_art_lock.png",
      name = "image_art_avatar_lock",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 396.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 405.5, h = 148.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_title.png",
      name = "image_title",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(579.5, 545)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 639.5, h = 131},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_title_dec.png",
      name = "image_title_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(649.5, 562)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 254, h = 271.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_avatar_bg.png",
      name = "hero_bg",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 144},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_activate_dec5.png",
      name = "btn_activate",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(776.5, 323.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 532.5, h = 522},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_art.png",
      name = "image_art_avatar_unlock",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(608, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 584.5, h = 353.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour.png",
      name = "all_item_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(878, 322)
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
      parent = "left_time_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_clock.png",
      name = "ImageView_20410",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.25, 18.25)
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
      parent = "left_time_bg",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.75, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg1",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_gold_frame.png",
      name = "item_frame1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg1",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_gold.png",
      name = "item1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 54)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 230, 208),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name1",
      z = 0,
      parent = "item_bg1",
      text = T("\232\181\164\233\135\145"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 192),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_item_state1",
      z = 2,
      parent = "item_bg1",
      text = T("\229\183\178\232\142\183\229\190\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg2",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_yellow_frame.png",
      name = "item_frame2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg2",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_yellow.png",
      name = "item2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 54)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 192, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name2",
      z = 0,
      parent = "item_bg2",
      text = T("\233\155\132\233\187\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 207, 93),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_item_state2",
      z = 2,
      parent = "item_bg2",
      text = T("\229\183\178\232\142\183\229\190\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.5, 52)
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
      parent = "item_bg1",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_gold_point.png",
      name = "image_point1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.5, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg3",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_brown_frame.png",
      name = "item_frame3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 52.5)
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
      parent = "item_bg2",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_yellow_point.png",
      name = "image_point2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg3",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_brown.png",
      name = "item3",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 155, 112),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name3",
      z = 0,
      parent = "item_bg3",
      text = T("\229\178\169\232\181\173"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 155, 112),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_item_state3",
      z = 2,
      parent = "item_bg3",
      text = T("\229\183\178\232\142\183\229\190\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.5, 53)
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
      parent = "item_bg3",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_brown_point.png",
      name = "image_point3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg4",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_red_frame.png",
      name = "item_frame4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg4",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_red.png",
      name = "item4",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 82, 55),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name4",
      z = 0,
      parent = "item_bg4",
      text = T("\232\190\176\231\160\130"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 154, 120),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_item_state4",
      z = 2,
      parent = "item_bg4",
      text = T("\229\183\178\232\142\183\229\190\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147, 52.5)
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
      parent = "item_bg4",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_red_point.png",
      name = "image_point4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 279, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_get_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_get.png",
      name = "image_get",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(406.25, 193.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg5",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_green_frame.png",
      name = "item_frame5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg5",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_green.png",
      name = "item5",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 54)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 212, 173),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name5",
      z = 0,
      parent = "item_bg5",
      text = T("\230\179\149\231\191\160"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 251, 145),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_item_state5",
      z = 2,
      parent = "item_bg5",
      text = T("\229\183\178\232\142\183\229\190\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.5, 52.5)
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
      parent = "item_bg5",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_green_point.png",
      name = "image_point5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_sun_bg",
      res = "UI/alpha/1080P/activity/jugg/jugg_activate_unlock.png",
      name = "btn_unlock",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178.75, 179.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 164},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_activate",
      res = "UI/alpha/1080P/activity/jugg/jugg_activate_button_bg.png",
      name = "image_activate",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_activate",
      res = "UI/alpha/1080P/activity/jugg/jugg_activate_dec1.png",
      name = "image_dec1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.5, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_activate",
      res = "UI/alpha/1080P/activity/jugg/jugg_activate_dec2.png",
      name = "image_dec2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 131)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6, h = 6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_activate",
      res = "UI/alpha/1080P/activity/jugg/jugg_activate_dec3.png",
      name = "image_dec3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.5, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_activate",
      res = "UI/alpha/1080P/activity/jugg/jugg_activate_dec4.png",
      name = "image_dec4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg1",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_gold_lock.png",
      name = "item1_grey",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg2",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_yellow_lock.png",
      name = "item2_grey",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 54)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg3",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_brown_lock.png",
      name = "item3_grey",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 55.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg4",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_red_lock.png",
      name = "item4_grey",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_bg5",
      res = "UI/alpha/1080P/activity/jugg/jugg_colour_green_lock.png",
      name = "item5_grey",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 54.5)
    }
  },
  {
    config = {
      rotation = -58,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_sun_lock",
      res = "UI/alpha/1080P/activity/jugg/jugg_sun_unlock.png",
      name = "image_unlock1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.75, 262.75)
    }
  },
  {
    config = {
      rotation = -30,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_sun_lock",
      res = "UI/alpha/1080P/activity/jugg/jugg_sun_unlock.png",
      name = "image_unlock2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261.25, 221.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_sun_lock",
      res = "UI/alpha/1080P/activity/jugg/jugg_sun_unlock.png",
      name = "image_unlock3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277.75, 165.75)
    }
  },
  {
    config = {
      rotation = 60,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_sun_lock",
      res = "UI/alpha/1080P/activity/jugg/jugg_sun_unlock.png",
      name = "image_unlock5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222.25, 66.25)
    }
  },
  {
    config = {
      rotation = 30,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.5, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_sun_lock",
      res = "UI/alpha/1080P/activity/jugg/jugg_sun_unlock.png",
      name = "image_unlock4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.25, 108.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(130, 109, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unlock",
      z = 0,
      parent = "btn_unlock",
      text = T("\231\130\185\231\157\155"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 119, 28),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_activate",
      z = 2,
      parent = "image_activate",
      text = T("\231\130\185\231\157\155"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.5, 81.5)
    }
  }
}
