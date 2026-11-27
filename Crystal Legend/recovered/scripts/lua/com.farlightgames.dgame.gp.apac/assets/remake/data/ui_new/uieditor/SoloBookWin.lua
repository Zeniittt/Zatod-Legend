ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloBookWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 860, h = 511},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/solobook/gallery_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(503, 261)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/power_null.png",
      name = "btn_back",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(830.5, 498)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/label.png",
      name = "btn_page_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23, 279)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 89.5, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/label_1.png",
      name = "btn_page_selected_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-28, 279)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 255, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_page_power",
      z = 0,
      parent = "btn_page_3",
      text = T("\229\174\157\231\137\169"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/label.png",
      name = "btn_page_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23, 341.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 89.5, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/label_1.png",
      name = "btn_page_selected_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-28, 341.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(124, 85, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_page_power_selected",
      z = 0,
      parent = "btn_page_selected_3",
      text = T("\229\174\157\231\137\169"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.25, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/label.png",
      name = "btn_page_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23, 402.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 89.5, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/label_1.png",
      name = "btn_page_selected_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-28, 402.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 255, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_page_hero",
      z = 0,
      parent = "btn_page_2",
      text = T("\232\139\177\233\155\132"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 25.75)
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
    base = {
      parent = "bg",
      name = "Panel_page_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(430, 255.5)
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
    base = {
      parent = "bg",
      name = "Panel_page_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(430, 255.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(124, 85, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_page_hero_selected",
      z = 0,
      parent = "btn_page_selected_2",
      text = T("\232\139\177\233\155\132"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.25, 26.25)
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
    base = {
      parent = "bg",
      name = "Panel_page_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(430, 255.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 255, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_page_faction",
      z = 0,
      parent = "btn_page_1",
      text = T("\230\181\129\230\180\190"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(124, 85, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_page_faction_selected",
      z = 0,
      parent = "btn_page_selected_1",
      text = T("\230\181\129\230\180\190"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.25, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(796.5, 412)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_565",
      z = 7,
      parent = "Panel_page_1",
      res = "UI/alpha/1080P/chesscard/solobook/page_bg_1.png",
      capInsets = CCRectMake(125, 25, 500, 63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7.5, -17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(768.5, 404.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_page_1",
      name = "Panel_item_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-391.5, -220)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 797, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_page_1",
      res = "UI/alpha/1080P/chesscard/solobook/page_title_1.png",
      name = "img_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7, 213.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(210.5, 156.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "switch_bg",
      z = 0,
      parent = "Panel_page_1",
      res = "UI/alpha/1080P/chesscard/solobook/page_switch_bg.png",
      capInsets = CCRectMake(0, 50, 0.5, 50)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-295.5, 107.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 796.5, h = 465},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_page_2",
      res = "UI/alpha/1080P/chesscard/solobook/page_bg_2.png",
      name = "ImageView_580",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-6.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(389, 446.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_page_2",
      name = "Panel_item_2",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-390, -217.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 796.5, h = 465},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_page_3",
      res = "UI/alpha/1080P/chesscard/solobook/page_bg_3.png",
      name = "ImageView_584",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-6, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(389, 446.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_page_3",
      name = "Panel_item_3",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-390, -217.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 140, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title",
      res = "UI/alpha/1080P/chesscard/solobook/selectbox_2.png",
      name = "ImageView_568",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title",
      res = "UI/alpha/1080P/chesscard/solobook/page_satr_bg.png",
      name = "ImageView_572",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.5, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(318, 409)
    },
    t = "Layer",
    base = {
      parent = "ImageView_580",
      name = "Panel_card_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(436.75, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(318, 409)
    },
    t = "Layer",
    base = {
      parent = "ImageView_584",
      name = "Panel_card_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(435.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_568",
      res = "UI/alpha/1080P/chesscard/solobook/switch.png",
      name = "btn_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.399999917, x = 0.399999917},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.599995103, h = 23.599995103},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_568",
      res = "UI/alpha/1080P/chesscard/faction_1.png",
      name = "ImageView_570",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 16.5)
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
      name = "Label_select",
      z = 0,
      parent = "ImageView_568",
      text = T("\230\153\174\230\148\187\230\181\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(63.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.5, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_572",
      res = "UI/alpha/1080P/chesscard/solobook/lower.png",
      name = "btn_lower",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_572",
      res = "UI/alpha/1080P/chesscard/solobook/increase.png",
      name = "btn_increase",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 182, 8),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_575",
      z = 0,
      parent = "ImageView_572",
      text = T("1\230\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_item_name",
      z = 0,
      parent = "Panel_card_2",
      text = "",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156.5, 356.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_card_2",
      res = "UI/alpha/1080P/chesscard/solobook/switch_1.png",
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.5, 104.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_card_2",
      res = "UI/alpha/1080P/chesscard/solobook/switch_1.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 222, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_level",
      z = 0,
      parent = "Panel_card_2",
      text = T("\231\172\172\228\184\128\233\152\182\230\174\181"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160.5, 105)
    }
  }
}
