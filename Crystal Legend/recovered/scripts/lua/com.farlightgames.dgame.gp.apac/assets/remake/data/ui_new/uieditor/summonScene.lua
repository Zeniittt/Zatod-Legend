ed.uieditor = ed.uieditor or {}
ed.uieditor.summonScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "Temp", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-21, -8)
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
    base = {name = "summon", z = 2},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 60.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 26.5, h = 26.5},
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
      normal = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_tips",
      z = 2,
      text = "",
      press = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(615, 458.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(123.5, 49),
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
      normal = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(35, 48, 35, 48),
      name = "btn_summon_once",
      z = 0,
      parent = "summon",
      text = T("\229\143\172\229\148\164"),
      press = "UI/alpha/1080P/common/button_a_butt.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-144, 3)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(123.5, 49),
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
      normal = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(35, 48, 35, 48),
      name = "btn_summon_ten",
      z = 0,
      parent = "summon",
      text = T("\229\143\172\229\148\164\229\141\129\230\172\161"),
      press = "UI/alpha/1080P/common/button_a_butt.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129, 3)
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
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/summon/skip_btn.png",
      name = "btn_skip",
      z = 1,
      text = "",
      press = "UI/alpha/1080P/summon/skip_btn.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(872, 502)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "summon",
      res = "UI/alpha/1080P/battle/battle_prepare_txt_bg.png",
      name = "ImageView_88",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-143.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "summon",
      res = "UI/alpha/1080P/battle/battle_prepare_txt_bg.png",
      name = "ImageView_89",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129.5, 42.5)
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
    base = {name = "layer1", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      parent = "btn_tips",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_207",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer2", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_88",
      res = "UI/alpha/1080P/icon/soulchest_ticket.png",
      name = "once_res_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 12.5)
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
      name = "once_res_nun",
      z = 0,
      parent = "ImageView_88",
      text = "x1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 86.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/tab_destiny_unchoose.png",
      name = "btn2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(882, 163.5)
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
      fix_wh = {w = 18.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_89",
      res = "UI/alpha/1080P/icon/soulchest_ticket.png",
      name = "ten_res_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 12)
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
      name = "ten_res_nun",
      z = 0,
      parent = "ImageView_89",
      text = "x10",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/tab_summon_unchoose.png",
      name = "btn1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(882.5, 243)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92, h = 87.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/tab_timely_unchoose.png",
      name = "btn3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(881.5, 321)
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
      parent = "layer1",
      name = "panel_middle",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(479.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 45, h = 46},
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
      normal = "UI/alpha/1080P/summon/transform_btn.png",
      name = "btn_change",
      z = 1,
      parent = "layer1",
      text = "",
      press = "UI/alpha/1080P/summon/transform_btn.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(616, 194.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer3", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 674.5, h = 257.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/summon/title.png",
      name = "img_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(413.5, 447.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 71, h = 69},
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
      normal = "UI/alpha/1080P/summon/hero_icon_bg.png",
      name = "btn_record",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/summon/hero_icon_bg.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 697.5, h = 320.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/summondestiny/destiny_title.png",
      name = "img_title1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(426, 435)
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
      parent = "layer2",
      name = "content_root_1",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(479, 269)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 71, h = 69},
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
      normal = "UI/alpha/1080P/summon/hero_icon_bg.png",
      name = "btn_hero_detail",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/summon/hero_icon_bg.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 86.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/tab_beginner_unchoose.png",
      name = "btn4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(882, 399)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 86.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn2",
      res = "UI/alpha/1080P/summon/tab_destiny_choose.png",
      name = "btn2_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 43.25)
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
      parent = "panel_middle",
      name = "content_root",
      z = 1
    },
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
      color = ccc3(219, 193, 176),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_destiny_name_unchoose",
      z = 0,
      parent = "btn2",
      text = T("\229\145\189\229\174\154\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44.25, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer4", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_change",
      res = "UI/alpha/1080P/summon/transform.png",
      name = "ImageView_59",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 46},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_change",
      res = "UI/alpha/1080P/summon/transform_btn2.png",
      name = "btn_change_img_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(219, 193, 176),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_summon_name_unchoose",
      z = 0,
      parent = "btn1",
      text = T("\232\139\177\233\155\132\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn1",
      res = "UI/alpha/1080P/summon/tab_summon_choose.png",
      name = "btn1_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(16, 11.5, 16, 11.5),
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      name = "btn_pdf_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92, h = 87.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn3",
      res = "UI/alpha/1080P/summon/tab_timely_choose.png",
      name = "btn3_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 43.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(643.5, 210)
    },
    t = "Scale9Sprite",
    base = {
      name = "dest_list_bg",
      z = 0,
      parent = "content_root_1",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_3.png",
      capInsets = CCRectMake(200, 0.5, 200, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7.5, -50.5)
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
      parent = "content_root",
      name = "desc",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, -8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(643.5, 191)
    },
    t = "Scale9Sprite",
    base = {
      name = "wish_list_bg",
      z = 0,
      parent = "content_root",
      res = "UI/alpha/1080P/summon/wish_scene_bg.png",
      capInsets = CCRectMake(200, 0.5, 200, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7.5, -50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(219, 193, 176),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_timely_name_unchoose",
      z = 0,
      parent = "btn3",
      text = T("\233\153\144\230\151\182\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(46, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 660, h = 141.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/summontimely/timely_info_bg.png",
      name = "bg_timely_info",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 176)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_destiny_name_choose",
      z = 0,
      parent = "btn2_selected",
      text = T("\229\145\189\229\174\154\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44.25, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 565.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/summontimely/slogan/slogan_bg.png",
      name = "bg_timely_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 455)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 181, h = 124},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/summontimely/timely_extra_reward_frame.png",
      name = "bg_timely_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 303)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/summon/record/summon_record_icon.png",
      name = "ImageView_2091",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 429.5, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "desc",
      res = "UI/alpha/1080P/summon/text_4.png",
      name = "desc_text_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "desc",
      name = "desc_value_root",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-159, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 490.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "desc",
      res = "UI/alpha/1080P/summon/text.png",
      name = "desc_text_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-6.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_list_bg",
      res = "UI/alpha/1080P/summon/wish_icon_bg.png",
      name = "wish_text_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(188.75, 75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 90)
    },
    t = "Layer",
    base = {
      parent = "wish_list_bg",
      name = "wish_heros_root",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(186.25, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 166.5, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_list_bg",
      res = "UI/alpha/1080P/summon/wish_str_bg.png",
      name = "text_tips_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328.75, 14)
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
      name = "label_record",
      z = 0,
      parent = "btn_record",
      text = T("\230\138\189\229\141\161\232\174\176\229\189\149"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 45, h = 46},
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
      normal = "UI/alpha/1080P/summon/transform_btn.png",
      name = "btn_change_1",
      z = 1,
      parent = "dest_list_bg",
      text = "",
      press = "UI/alpha/1080P/summon/transform_btn.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(522.25, 95)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 140.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_deshero",
      z = 0,
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_hero_bg.png",
      capInsets = CCRectMake(10.5, 46.5, 10.5, 46.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.75, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_1.png",
      name = "bg_icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(324.25, 108)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_1.png",
      name = "bg_icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(384.25, 108)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_hero_detail",
      res = "UI/alpha/1080P/summon/hero.png",
      name = "ImageView_97",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_summon_name_choose",
      z = 0,
      parent = "btn1_selected",
      text = T("\232\139\177\233\155\132\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_1.png",
      name = "bg_icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444.25, 108)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_1.png",
      name = "bg_icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(324.25, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_1.png",
      name = "bg_icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(384.25, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_1.png",
      name = "bg_icon6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444.25, 35)
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
      name = "text_detai",
      z = 0,
      parent = "btn_hero_detail",
      text = T("\232\139\177\233\155\132\230\131\133\230\138\165"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dest_list_bg",
      res = "UI/alpha/1080P/summondestiny/destiny_number_title.png",
      name = "image_dest_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(321.75, 187)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 86.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn4",
      res = "UI/alpha/1080P/summon/tab_beginner_choose.png",
      name = "btn4_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 43.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_timely_name_choose",
      z = 0,
      parent = "btn3_selected",
      text = T("\233\153\144\230\151\182\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(46, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_text_bg",
      res = "UI/alpha/1080P/summon/text_wish_list.png",
      name = "wish_text",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(219, 193, 176),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_newbie_name_unchoose",
      z = 0,
      parent = "btn4",
      text = T("\230\150\176\230\137\139\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44.25, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summon/unknow_hero_bg.png",
      name = "item_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summon/unknow_hero_bg.png",
      name = "item_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 47.5)
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
      name = "text_tips",
      z = 0,
      parent = "text_tips_bg",
      text = T("\229\134\141\229\143\172\229\148\164"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 17.25)
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
      name = "text_value",
      z = 0,
      parent = "text_tips_bg",
      text = "100",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.25, 16.75)
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
      name = "text_tips1",
      z = 0,
      parent = "text_tips_bg",
      text = T("\230\172\161\229\144\142\229\188\128\230\148\190"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.75, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 660, h = 141.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/summontimely/timely_info_bg.png",
      name = "bg_newbie_info",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481.5, 176)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 565.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/summonbeginner/beignner_title_bg.png",
      name = "bg_newbie_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 457.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 181, h = 124},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/summontimely/timely_extra_reward_frame.png",
      name = "bg_newbie_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 302.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_info",
      res = "UI/alpha/1080P/summontimely/timely_info_1.png",
      name = "timely_info1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 83.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_change_1",
      res = "UI/alpha/1080P/summon/transform.png",
      name = "ImageView_59",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 46},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_change_1",
      res = "UI/alpha/1080P/summon/transform_btn2.png",
      name = "btn_change_img_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_info",
      res = "UI/alpha/1080P/summontimely/timely_info_2.png",
      name = "timely_info2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 70.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_deshero",
      res = "UI/alpha/1080P/summondestiny/destiny_hero.png",
      name = "icon_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 69.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 248),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_destiny_hero",
      z = 0,
      parent = "bg_deshero",
      text = T("\229\145\189\229\174\154\232\139\177\233\155\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 123.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_deshero",
      res = "UI/alpha/1080P/summondestiny/destiny_number_bg_2.png",
      name = "ImageView_1801",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/summonbeginner/beignner_hero_ukw.png",
      name = "icon_newbie",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 335)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_info",
      res = "UI/alpha/1080P/summontimely/timely_info_3.png",
      name = "timely_info4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 70.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_icon1",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "percent1",
      z = 0,
      parent = "bg_icon1",
      text = "10%",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107, h = 73},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_info",
      res = "UI/alpha/1080P/summontimely/heroname/Panda_name.png",
      name = "timely_info3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(316.5, 79.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_icon2",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "percent2",
      z = 0,
      parent = "bg_icon2",
      text = "10%",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 351.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_info",
      res = "UI/alpha/1080P/summontimely/timely_timeup_bg.png",
      name = "bg_timely_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170, h = 46.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_title",
      res = "UI/alpha/1080P/summontimely/slogan/Panda_slogan.png",
      name = "timely_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_icon3",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "percent3",
      z = 0,
      parent = "bg_icon3",
      text = "10%",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_title",
      res = "UI/alpha/1080P/summontimely/slogan/slogan_star.png",
      name = "ImageView_1931",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_icon4",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "percent4",
      z = 0,
      parent = "bg_icon4",
      text = "10%",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_title",
      res = "UI/alpha/1080P/summontimely/slogan/slogan_star.png",
      name = "ImageView_1932",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.75, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_icon5",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_wish_list",
      z = 0,
      parent = "wish_text",
      text = T("\232\174\184\230\132\191\229\141\149"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "percent5",
      z = 0,
      parent = "bg_icon5",
      text = "10%",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_1",
      res = "UI/alpha/1080P/summon/pvp_battle_lock.png",
      name = "lock_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.75, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_icon6",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_2",
      res = "UI/alpha/1080P/summon/pvp_battle_lock.png",
      name = "lock_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.75, 41)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "percent6",
      z = 0,
      parent = "bg_icon6",
      text = "10%",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_reward",
      res = "UI/alpha/1080P/summontimely/timely_extra_title_bg.png",
      name = "bg_timely_reward_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 117)
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
      parent = "btn_pdf_detail",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "ImageView_10481",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 16.25)
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
      name = "label_pdf_detail",
      z = 0,
      parent = "btn_pdf_detail",
      text = T("\229\143\172\229\148\164\232\175\166\230\131\133"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_reward",
      res = "UI/alpha/1080P/summontimely/timely_extra_reward_bg.png",
      name = "ImageView_1913",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_change_img_up",
      res = "UI/alpha/1080P/summon/transform2.png",
      name = "ImageView_840",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_change_img_up",
      res = "UI/alpha/1080P/summon/transform2.png",
      name = "ImageView_840",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_hero",
      res = "UI/alpha/1080P/summondestiny/destiny_add.png",
      name = "ImageView_1277",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.75, 43)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 251),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "per_destiny",
      z = 0,
      parent = "ImageView_1801",
      text = "1%",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_newbie_name_choose",
      z = 0,
      parent = "btn4_selected",
      text = T("\230\150\176\230\137\139\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44.25, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_timely_time",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_icon.png",
      name = "icon_timely_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.25, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_timely_time",
      z = 0,
      parent = "bg_timely_time",
      text = T("\229\137\169\228\189\15312\229\164\1696\230\151\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(139.75, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_info",
      res = "UI/alpha/1080P/summontimely/timely_info_3.png",
      name = "newbie_info4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(376, 70.75)
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
      name = "label_timely_extra_title",
      z = 0,
      parent = "bg_timely_reward_title",
      text = T("\233\162\157\229\164\150\232\142\183\229\190\151"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 351.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_info",
      res = "UI/alpha/1080P/summontimely/timely_timeup_bg.png",
      name = "bg_newbie_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 81.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_info",
      res = "UI/alpha/1080P/summontimely/timely_info_1.png",
      name = "newbie_info1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.5, 83.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1914",
      z = 0,
      parent = "ImageView_1913",
      text = T("\229\183\178\233\162\134\229\143\150"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 39.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_info",
      res = "UI/alpha/1080P/summontimely/timely_info_2.png",
      name = "newbie_info2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206.5, 70.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107, h = 73},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_info",
      res = "UI/alpha/1080P/summontimely/heroname/Panda_name.png",
      name = "newbie_info3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.5, 77.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 286.5, h = 75.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_title",
      res = "UI/alpha/1080P/summonbeginner/beignner_title.png",
      name = "ImageView_94737",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.75, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_reward",
      res = "UI/alpha/1080P/summontimely/timely_extra_title_bg.png",
      name = "bg_newbie_reward_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 117)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_reward",
      res = "UI/alpha/1080P/summontimely/timely_extra_reward_bg.png",
      name = "ImageView_19131",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_newbie",
      res = "UI/alpha/1080P/summonbeginner/beignner_reward_unchoose.png",
      name = "ImageView_701",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.75, 41)
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
      parent = "ImageView_10481",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_10482",
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
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_newbie_time",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_icon.png",
      name = "icon_newbie_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.25, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_newbie_time",
      z = 0,
      parent = "bg_newbie_time",
      text = T("\229\137\169\228\189\15312\229\164\1696\230\151\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(148.25, 13.75)
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
      name = "label_timely_extra_title",
      z = 0,
      parent = "bg_newbie_reward_title",
      text = T("\233\162\157\229\164\150\232\142\183\229\190\151"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_19141",
      z = 0,
      parent = "ImageView_19131",
      text = T("\229\183\178\233\162\134\229\143\150"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 89.5, h = 84},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summonrisestar/risestar_icon2.png",
      name = "btn5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(882, 91)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer5", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 89.5, h = 84},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn5",
      res = "UI/alpha/1080P/summonrisestar/risestar_icon.png",
      name = "btn5_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.75, 42)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(219, 193, 176),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_RiseStar_name_unchoose",
      z = 0,
      parent = "btn5",
      text = T("\230\152\159\232\190\137\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44.75, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 660, h = 141.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer5",
      res = "UI/alpha/1080P/summontimely/timely_info_bg.png",
      name = "bg_riseStar_info",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481.5, 176)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 565.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer5",
      res = "UI/alpha/1080P/summonbeginner/beignner_title_bg.png",
      name = "bg_riseStar_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(417, 461.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 181, h = 124},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer5",
      res = "UI/alpha/1080P/summontimely/timely_extra_reward_frame.png",
      name = "bg_riseStar_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 302.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer5",
      res = "UI/alpha/1080P/summonbeginner/beignner_hero_ukw.png",
      name = "icon_riseStar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 335)
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
      parent = "layer5",
      name = "layer_fca",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tab_RiseStar_name_choose",
      z = 0,
      parent = "btn5_selected",
      text = T("\230\152\159\232\190\137\229\143\172\229\148\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(44.75, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_info",
      res = "UI/alpha/1080P/summontimely/timely_info_3.png",
      name = "riseStar_info4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(376, 70.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 351.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_info",
      res = "UI/alpha/1080P/summontimely/timely_timeup_bg.png",
      name = "bg_riseStar_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 81.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_info",
      res = "UI/alpha/1080P/summontimely/timely_info_1.png",
      name = "riseStar_info1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.5, 83.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 39.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_info",
      res = "UI/alpha/1080P/summontimely/timely_info_2.png",
      name = "riseStar_info2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206.5, 70.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107, h = 73},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_info",
      res = "UI/alpha/1080P/summontimely/heroname/Panda_name.png",
      name = "riseStar_info3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.5, 77.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 674.5, h = 117.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_title",
      res = "UI/alpha/1080P/summonrisestar/risestar_title.png",
      name = "ImageView_94737_Rise",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.75, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117.5, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_reward",
      res = "UI/alpha/1080P/summontimely/timely_extra_title_bg.png",
      name = "bg_riseStar_reward_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 117)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_reward",
      res = "UI/alpha/1080P/summontimely/timely_extra_reward_bg.png",
      name = "ImageView_19131_Rise",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_riseStar",
      res = "UI/alpha/1080P/summonbeginner/beignner_reward_unchoose.png",
      name = "ImageView_701",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.75, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_riseStar_time",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_icon.png",
      name = "icon_riseStar_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.25, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_riseStar_time",
      z = 0,
      parent = "bg_riseStar_time",
      text = T("\229\137\169\228\189\15312\229\164\1696\230\151\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(148.25, 13.75)
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
      name = "label_timely_extra_title",
      z = 0,
      parent = "bg_riseStar_reward_title",
      text = T("\233\162\157\229\164\150\232\142\183\229\190\151"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_19141_Rise",
      z = 0,
      parent = "ImageView_19131_Rise",
      text = T("\229\183\178\233\162\134\229\143\150"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 14.25)
    }
  }
}
