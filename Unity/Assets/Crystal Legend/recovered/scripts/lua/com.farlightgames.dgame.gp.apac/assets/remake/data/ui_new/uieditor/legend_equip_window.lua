ed.uieditor = ed.uieditor or {}
ed.uieditor.legend_equip_window = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(918.5, 495)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(890, 165, 5, 165),
      res = "UI/alpha/1080P/legendequip/upequip1.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 265.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(909.25, 480)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(364, 462)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_detail_bg",
      z = 2,
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/upequip2.png",
      capInsets = CCRectMake(13, 154, 13, 154)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724.25, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 372, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/equipname_board.png",
      name = "image_name_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.75, 462.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 227, h = 86.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/onlyequip_board.png",
      name = "image_only_tag",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.25, 428)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 250, h = 250},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/to_jpg_x_alpha/le1.png",
      name = "equip_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.25, 329.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 35)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_star",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(145.25, 227.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/newline1.png",
      name = "image_rank_bar_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.75, 189.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 433.5, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/upequip3.png",
      name = "next_star_tips_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.25, 161.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 180,
      visible = true,
      scaleSize = CCSizeMake(280, 64)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_item_bg",
      z = 2,
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/upequip4.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.25, 110.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 42.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_big_common.png",
      name = "btn_up",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(294.75, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 468, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/fullstar_board.png",
      name = "image_max_star",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.25, 105)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_bg.png",
      name = "btn_breakdown",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.75, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 38.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/bag/abandon.png",
      name = "btn_abandon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_110",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 251.5, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rank_bar_bg",
      res = "UI/alpha/1080P/legendequip/newline2.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rank_bar_bg",
      res = "UI/alpha/1080P/legendequip/line4.png",
      name = "image_rank_arrow",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rank_bar_bg",
      res = "UI/alpha/1080P/legendequip/line5.png",
      name = "image_next_star",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(287, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 335.5, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/attribute3.png",
      name = "image_title_attr",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 435)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(336, 124)
    },
    t = "Layer",
    base = {
      parent = "image_detail_bg",
      name = "panel_attr_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14, 295.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 335.5, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/attribute3.png",
      name = "image_title_skill",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 272)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 102,
      visible = true,
      scaleSize = CCSizeMake(336, 225)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_skill_detail_bg",
      z = 0,
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/upequip4.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 174.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_up",
      z = 0,
      parent = "btn_up",
      text = T("\230\143\144\229\141\135"),
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 336, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/alreadylock_board.png",
      name = "image_bind_info_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 33)
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
      parent = "image_name_bg",
      name = "equip_name_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(186, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(347, 82.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_bind",
      z = 0,
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/legendequip/add2.png",
      capInsets = CCRectMake(103, 27.5, 103, 27.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_attr",
      z = 0,
      parent = "image_title_attr",
      text = T("\232\163\133\229\164\135\229\177\158\230\128\167"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22.25, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_skill",
      z = 0,
      parent = "image_title_skill",
      text = T("\232\163\133\229\164\135\230\138\128\232\131\189"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22.25, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.5, h = 64.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_skill_detail_bg",
      res = "UI/alpha/1080P/legendequip/skill_board.png",
      name = "skill_icon_board",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 154)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_skill_detail_bg",
      res = "UI/alpha/1080P/legendequip/skill_line.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(197, 162)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(165, 149, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_name",
      z = 0,
      parent = "image_skill_detail_bg",
      text = T("\229\175\146\233\156\156\229\134\178\229\135\187"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(91, 178)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(230, 70)
    },
    t = "Layer",
    base = {
      parent = "image_skill_detail_bg",
      name = "panel_skill_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(89.5, 87)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 108, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_lock",
      z = 0,
      parent = "image_skill_detail_bg",
      text = T("3\230\152\159\232\167\163\233\148\129"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(318.5, 178)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(35, 35)
    },
    t = "Layer",
    base = {
      parent = "image_bind_info_bg",
      name = "panel_bind_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 204,
      visible = true,
      scaleSize = CCSizeMake(319, 37)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_rune_1",
      z = 0,
      parent = "image_skill_detail_bg",
      res = "UI/alpha/1080P/legendequip/upequip4.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 64)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(165, 149, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bind_hero",
      z = 0,
      parent = "image_bind_info_bg",
      text = T("\232\136\185\233\149\191\229\183\178\231\187\145\229\174\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(61.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.35, h = 37.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bind_info_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_unbind",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 204,
      visible = true,
      scaleSize = CCSizeMake(319, 37)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_rune_2",
      z = 0,
      parent = "image_skill_detail_bg",
      res = "UI/alpha/1080P/legendequip/upequip4.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.4, h = 68.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_breakdown",
      res = "UI/alpha/1080P/fireforge/breakdown.png",
      name = "ImageView_1217",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.5, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_icon_board",
      res = "UI/alpha/1080P/legendequip/skill_frame.png",
      name = "image_skill_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 32.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unbind",
      z = 0,
      parent = "btn_unbind",
      text = T("\232\167\163\233\153\164\231\187\145\229\174\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rune_1",
      res = "UI/alpha/1080P/legendequip/testicon1.png",
      name = "rune_icon_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(165, 149, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rune_name_1",
      z = 0,
      parent = "image_rune_1",
      text = T("\231\172\166\230\150\135-\229\134\176\229\135\140"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 108, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rune_lock_1",
      z = 0,
      parent = "image_rune_1",
      text = T("4\230\152\159\232\167\163\233\148\129"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(310, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rune_2",
      res = "UI/alpha/1080P/legendequip/testicon1.png",
      name = "rune_icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(165, 149, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rune_name_2",
      z = 0,
      parent = "image_rune_2",
      text = T("\231\172\166\230\150\135-\229\134\176\229\135\140"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 108, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rune_lock_2",
      z = 0,
      parent = "image_rune_2",
      text = T("5\230\152\159\232\167\163\233\148\129"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(310, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_icon_board",
      res = "UI/alpha/1080P/legendequip/equip_unlock.png",
      name = "image_skill_lock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 32.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_bind",
      res = "UI/alpha/1080P/legendequip/add1.png",
      name = "image_bind_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bind",
      z = 0,
      parent = "btn_bind",
      text = T("\231\130\185\229\135\187\231\187\145\229\174\154\232\139\177\233\155\132"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(188.5, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rank_bar_bg",
      res = "UI/alpha/1080P/legendequip/line3.png",
      name = "image_full_star",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 540, h = 201},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/art.png",
      name = "ImageView_23118",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.25, 109)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_bg.png",
      name = "btn_reset",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.25, 59)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reset",
      res = "UI/alpha/1080P/legendequip/reset/reset_icon.png",
      name = "img_reset",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reset",
      z = 0,
      parent = "btn_reset",
      text = T("\233\135\141\231\189\174"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 8)
    }
  }
}
