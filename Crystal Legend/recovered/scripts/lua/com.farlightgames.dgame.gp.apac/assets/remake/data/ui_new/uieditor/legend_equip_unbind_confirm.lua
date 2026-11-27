ed.uieditor = ed.uieditor or {}
ed.uieditor.legend_equip_unbind_confirm = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(405, 218)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 13, 13, 13),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 288)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279, 194)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126, 194)
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
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\143\144\231\164\186"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, 195)
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
      name = "label_tips_1",
      z = 0,
      parent = "image_bg",
      text = T("\230\152\175\229\144\166\232\167\163\233\153\164\232\136\185\233\149\191\228\184\142\228\188\160\229\165\135\194\183\229\134\176\231\148\178\231\154\132\231\187\145\229\174\154\239\188\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 153)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 33)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_confirm",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(318, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 189, 35),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips_2",
      z = 0,
      parent = "image_bg",
      text = T("\232\167\163\231\187\145"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 116.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/com_line_center.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, 67.5)
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
      name = "label_cancel",
      z = 0,
      parent = "btn_cancel",
      text = T("\229\143\150\230\182\136"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
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
      name = "label_confirm",
      z = 0,
      parent = "btn_confirm",
      text = T("\231\161\174\232\174\164"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 182.399989056, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_273",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-91.25, 3.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.799999952},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 182.399989056, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_274",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112.75, 4.25)
    }
  }
}
