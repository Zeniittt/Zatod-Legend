ed.uieditor = ed.uieditor or {}
ed.uieditor.ranklistwindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/herodetail_arrow_left.png",
      name = "left_arrow",
      z = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/herodetail_arrow_right.png",
      name = "right_arrow",
      z = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(340.5, 29.5)
    }
  },
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
      name = "img_title_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229, 507.5)
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
    base = {name = "pan_window", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 17),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "lab_title",
      z = 0,
      parent = "img_title_bg",
      text = "",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.75, 68.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(710, 475)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2685",
      z = 98,
      parent = "pan_window",
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      capInsets = CCRectMake(20, 20, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399, 245.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(702.5, 465)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2687",
      z = 0,
      parent = "pan_window",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      capInsets = CCRectMake(25, 25, 30, 330)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399, 245.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 692, h = 169},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_window",
      res = "UI/alpha/1080P/rankingscene/podium_g.png",
      name = "img_top",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 392)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 175)
    },
    t = "Layer",
    base = {
      parent = "pan_window",
      name = "pan_top",
      z = 99
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75, 307)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title_bg",
      res = "UI/alpha/1080P/rankingscene/ranking_text.png",
      name = "ImageView_2735",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "back_button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-28.75, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(690, 7.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2720",
      z = 9,
      parent = "pan_window",
      res = "UI/alpha/1080P/rankingscene/split_line_1.png",
      capInsets = CCRectMake(2.5, 2.5, 2.5, 2.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 304.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(682, 279.5)
    },
    t = "Layer",
    base = {
      parent = "pan_window",
      name = "pan_list_pos",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(58.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(173, 469)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2722",
      z = 9,
      parent = "pan_window",
      res = "UI/alpha/1080P/rankingscene/gery_polygon.png",
      capInsets = CCRectMake(15, 25, 25, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(832, 248)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(141, 456.5)
    },
    t = "Layer",
    base = {
      parent = "pan_window",
      name = "pan_butt_pos",
      z = 11
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(761, 22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 170)
    },
    t = "Layer",
    base = {
      parent = "pan_top",
      name = "Panel_rank_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-20.5, -1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 170)
    },
    t = "Layer",
    base = {
      parent = "pan_top",
      name = "Panel_rank_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(209, -1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 170)
    },
    t = "Layer",
    base = {
      parent = "pan_top",
      name = "Panel_rank_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(439, -1)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "back_button",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_2737",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 38)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2689",
      z = 0,
      parent = "Panel_rank_2",
      res = "UI/alpha/1080P/rankingscene/ranking_gery_bg.png",
      capInsets = CCRectMake(5, 5, 5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_2",
      z = 1,
      parent = "Panel_rank_2",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 52)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_name_2",
      z = 1,
      parent = "Panel_rank_2",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_var_2",
      z = 1,
      parent = "Panel_rank_2",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_2",
      res = "UI/alpha/1080P/rankingscenescene/2nd_name.png",
      name = "ImageView_2698",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 51)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_2",
      res = "UI/alpha/1080P/rankingscene/2nd_base.png",
      name = "img_2_base",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.5, 85.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_2",
      res = "UI/alpha/1080P/common/pvp_rank_2nd.png",
      name = "ImageView_2700",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.5, 160.5)
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
      parent = "Panel_rank_2",
      name = "pan_icon_pos_2",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 38)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2689",
      z = 0,
      parent = "Panel_rank_1",
      res = "UI/alpha/1080P/rankingscene/ranking_gery_bg.png",
      capInsets = CCRectMake(5, 5, 5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_1",
      res = "UI/alpha/1080P/rankingscene/1st_name.png",
      name = "ImageView_2698",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 51)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_1",
      res = "UI/alpha/1080P/rankingscene/1st_base.png",
      name = "img_1_base",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_1",
      res = "UI/alpha/1080P/rankingscene/1st.png",
      name = "ImageView_2700",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 160.5)
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
      parent = "Panel_rank_1",
      name = "pan_icon_pos_1",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(116.5, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_1",
      z = 1,
      parent = "Panel_rank_1",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 52)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_name_1",
      z = 1,
      parent = "Panel_rank_1",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_var_1",
      z = 1,
      parent = "Panel_rank_1",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(230, 38)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2689",
      z = 0,
      parent = "Panel_rank_3",
      res = "UI/alpha/1080P/rankingscene/ranking_gery_bg.png",
      capInsets = CCRectMake(5, 5, 5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 129.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_3",
      res = "UI/alpha/1080P/rankingscene/3rd_name.png",
      name = "ImageView_2698",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 51)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_3",
      res = "UI/alpha/1080P/rankingscene/3rd_base.png",
      name = "img_3_base",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 85.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_3",
      res = "UI/alpha/1080P/rankingscene/3rd.png",
      name = "ImageView_2700",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 160.5)
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
      parent = "Panel_rank_3",
      name = "pan_icon_pos_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_3",
      z = 1,
      parent = "Panel_rank_3",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 52)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild_name_3",
      z = 1,
      parent = "Panel_rank_3",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_var_3",
      z = 1,
      parent = "Panel_rank_3",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119.5, h = 79.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_2",
      res = "UI/alpha/1080P/rankingscene/ranking_blue_2.png",
      name = "ImageView_2738",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.5, h = 92},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_2",
      res = "UI/alpha/1080P/rankingscene/ranking_blue.png",
      name = "ImageView_2739",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69, 153)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 70},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_1",
      res = "UI/alpha/1080P/rankingscene/ranking_yellow.png",
      name = "ImageView_2739_Copy0",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 154.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155.5, h = 104},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_1",
      res = "UI/alpha/1080P/rankingscene/ranking_yellow_2.png",
      name = "ImageView_2738_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 133.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119.5, h = 79.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_3",
      res = "UI/alpha/1080P/rankingscene/ranking_gold_2.png",
      name = "ImageView_2742",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 133)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 84},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_rank_3",
      res = "UI/alpha/1080P/rankingscene/ranking_gold.png",
      name = "ImageView_2743",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 154)
    }
  }
}
