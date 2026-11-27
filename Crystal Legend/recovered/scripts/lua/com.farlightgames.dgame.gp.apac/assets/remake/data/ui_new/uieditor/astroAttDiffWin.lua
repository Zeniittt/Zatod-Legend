ed.uieditor = ed.uieditor or {}
ed.uieditor.astroAttDiffWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(585.5, 390.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 50),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(189, 55.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\230\143\144\231\164\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290.5, 367)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "left_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(211.5, 366)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "right_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(369.5, 365.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "left_button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173, 37)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "right_button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 242, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_button_label",
      z = 0,
      parent = "left_button",
      text = T("\229\143\150\230\182\136"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "middle_button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(287.75, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 242, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "middle_button_label",
      z = 0,
      parent = "middle_button",
      text = T("\228\184\141\228\191\157\229\173\152"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 242, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "right_button_label",
      z = 0,
      parent = "right_button",
      text = T("\231\161\174\232\174\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/com_line_center.png",
      name = "ImageView_305",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(299, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(515, 245.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_1.png",
      capInsets = CCRectMake(25, 35, 63, 5)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(33, 351)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(231, 22.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_gs_pre",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_3.png",
      capInsets = CCRectMake(25, 7.5, 55.5, 7.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.5, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(231, 22.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_gs",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_3.png",
      capInsets = CCRectMake(25, 7.5, 55.5, 7.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(311, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.09999315, h = 31.49999475},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/bless/bless_reinforce_arrow.png",
      name = "ImageView_294_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289.5, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_305",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-114, 3.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 228, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_305",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_307",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.5, 3.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(197, 188, 244),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_287",
      z = 0,
      parent = "bg_attr",
      text = T("\230\156\137\228\187\165\228\184\139\231\154\132\229\177\158\230\128\167\229\143\152\229\140\150\229\176\154\230\156\170\228\191\157\229\173\152\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261.5, 230)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gs_pre",
      z = 0,
      parent = "bg_gs_pre",
      text = T("\230\136\152\229\138\155"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(72, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gs",
      z = 0,
      parent = "bg_gs",
      text = T("\230\136\152\229\138\155"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(72.5, 11.75)
    }
  }
}
