ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_breakdown_scene = {
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
      res = "UI/alpha/1080P/fireforge/bag/background.jpg",
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
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136, 504)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 169.5, h = 151.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/break/function_board3.png",
      name = "ImageView_913",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-20.5, 111)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 169.5, h = 151.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/break/function_board3.png",
      name = "ImageView_914",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(979.5, 111)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(900, 350)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(43.5, 33.5, 43.5, 33.5),
      res = "UI/alpha/1080P/fireforge/break/function_board2.png",
      name = "image_board_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 312)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 899.5, h = 165.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/break/function_board1.png",
      name = "image_board_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 93.5)
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
      parent = "image_title_bg",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.25, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(862.5, 295)
    },
    t = "Layer",
    base = {
      parent = "image_board_1",
      name = "panel_equip_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.5, 44)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 193, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward_tips",
      z = 0,
      parent = "image_board_2",
      text = T("\229\136\134\232\167\163\229\143\175\232\142\183\229\190\151\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40.75, 112.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(710, 70)
    },
    t = "Layer",
    base = {
      parent = "image_board_2",
      name = "panel_reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(164.75, 79.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_board_2",
      res = "UI/alpha/1080P/fireforge/break/function_order_board.png",
      name = "btn_sort",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.25, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_board_2",
      res = "UI/alpha/1080P/fireforge/break/typechoose_basic.png",
      name = "btn_filter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159.25, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_board_2",
      res = "UI/alpha/1080P/fireforge/break/quickchoose_clean.png",
      name = "btn_fast_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(360.25, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(191.5, 69.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_breakdown",
      z = 0,
      parent = "image_board_2",
      res = "UI/alpha/1080P/fireforge/forge_button.png",
      capInsets = CCRectMake(52, 23, 52, 23)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(779.75, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(192, 313)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_filter_bg",
      z = 0,
      parent = "image_board_2",
      res = "UI/alpha/1080P/fireforge/break/typechoose_board.png",
      capInsets = CCRectMake(30.5, 24, 30.5, 24)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.75, 207.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(204, 313)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_fast_select_bg",
      z = 0,
      parent = "image_board_2",
      res = "UI/alpha/1080P/fireforge/break/typechoose_board.png",
      capInsets = CCRectMake(30.5, 24, 30.5, 24)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(358.25, 206.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301.5, h = 238},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_board_1",
      res = "UI/alpha/1080P/fireforge/bag/empty_state.png",
      name = "image_empty_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(437.5, 191.5)
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
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_931",
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
      fix_wh = {w = 19, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_sort",
      res = "UI/alpha/1080P/fireforge/break/function_order1.png",
      name = "image_sort_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.25, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_filter",
      res = "UI/alpha/1080P/fireforge/break/typechoose_arrow.png",
      name = "image_filter_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.75, 16.5)
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
      name = "label_filter",
      z = 0,
      parent = "btn_filter",
      text = T("\232\163\133\229\164\135\231\173\155\233\128\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86.25, 18)
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
      name = "label_fast_select",
      z = 0,
      parent = "btn_fast_select",
      text = T("\229\191\171\233\128\159\233\128\137\230\139\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.75, 18)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 293)
    },
    t = "Layer",
    base = {
      parent = "image_filter_bg",
      name = "panel_filter_option",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(185, 253)
    },
    t = "Layer",
    base = {
      parent = "image_fast_select_bg",
      name = "panel_fast_select_option",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10.5, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 182.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_fast_select_bg",
      res = "UI/alpha/1080P/fireforge/break/quickchoose_select.png",
      name = "btn_clear_fast_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 30)
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
      name = "label_clear_fast_select",
      z = 0,
      parent = "btn_clear_fast_select",
      text = T("\230\184\133\233\153\164"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(181, 151, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_tips",
      z = 0,
      parent = "image_empty_tips",
      text = T("\229\176\154\230\156\170\232\142\183\229\190\151\232\163\133\229\164\135"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.75, 110.5)
    }
  }
}
