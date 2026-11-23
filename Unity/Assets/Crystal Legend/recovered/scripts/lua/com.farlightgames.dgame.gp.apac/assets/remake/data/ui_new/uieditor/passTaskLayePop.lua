ed.uieditor = ed.uieditor or {}
ed.uieditor.passTaskLayePop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "Panel_477", z = 0},
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
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_477",
      name = "Panel_left",
      z = 6
    },
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
      fix_wh = {w = 294, h = 495.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_left",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_fashion_top.png",
      name = "fashion_card_img",
      z = 98
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215.5, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 208.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_left",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_fashion_name_bg.png",
      name = "img_fashion_name_bg",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 373)
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
      parent = "Panel_477",
      name = "Panel_right",
      z = 0
    },
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
      fix_wh = {w = 346.5, h = 517.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_left",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_fashion_img.png",
      name = "fashion_card_img_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227.5, 294.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(260, 450)
    },
    t = "Layer",
    base = {
      parent = "Panel_left",
      name = "Panel_540",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(85, 63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.900000036},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48.600001944, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_477",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(871.5, 471)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 581.5, h = 395.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_bg.png",
      name = "ImageView_476",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(591.5, 284.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 302, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_title.png",
      name = "ImageView_480",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(609.5, 470)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(850, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_477",
      name = "panel_close_pos",
      z = 99
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(54.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(47, 32, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_ach_str",
      z = 0,
      parent = "Panel_right",
      text = T("\232\180\173\228\185\176\230\136\152\232\175\129\239\188\140\233\154\143\231\157\128\231\173\137\231\186\167\230\143\144\229\141\135\232\167\163\233\148\129\230\181\183\233\135\143\229\165\150\229\138\177"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(606, 428.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(325, 33.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_483",
      z = 0,
      parent = "Panel_right",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_time_txt_bg.png",
      capInsets = CCRectMake(100, 10, 117, 5.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(608.5, 380.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 231, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_item_str",
      z = 0,
      parent = "Panel_right",
      text = T("\230\136\152\232\175\129\232\190\190\229\136\17630\231\186\167\232\142\183\229\190\151\233\153\144\229\174\154\229\165\150\229\138\177"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(606, 380.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.3, h = 36.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_497",
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
      name = "label_str_title",
      z = 0,
      parent = "ImageView_480",
      text = T("\232\180\173\228\185\176\230\136\152\232\175\129"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 438, h = 87.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_item_bg1.png",
      name = "ImageView_485",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(611, 316)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 438, h = 87.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_item_bg2.png",
      name = "ImageView_485_Copy0",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(611, 176)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(432, 70)
    },
    t = "Layer",
    base = {
      parent = "Panel_right",
      name = "item_pos_1",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(395.5, 280)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(432, 70)
    },
    t = "Layer",
    base = {
      parent = "Panel_right",
      name = "item_pos_2",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(395.5, 140)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(325, 33.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_483_Copy0",
      z = 0,
      parent = "Panel_right",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_time_txt_bg.png",
      capInsets = CCRectMake(100, 10, 117, 5.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(604, 241)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 231, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_482_Copy1",
      z = 0,
      parent = "Panel_right",
      text = T("\229\133\182\228\187\150\229\165\150\229\138\177\233\162\132\232\167\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(601.5, 241.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_shoping_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(611.5, 84.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 237, 171),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_str",
      z = 0,
      parent = "btn_shoping_img",
      text = T("98\229\133\131"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 218, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_fashion_name_tips",
      z = 0,
      parent = "img_fashion_name_bg",
      text = T(""),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 28.75)
    }
  }
}
