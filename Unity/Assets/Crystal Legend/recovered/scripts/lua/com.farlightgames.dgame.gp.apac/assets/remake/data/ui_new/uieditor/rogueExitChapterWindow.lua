ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueExitChapterWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(405, 215)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(16.5, 16.5, 16.5, 16.5),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 266.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\150\176\230\137\139\230\157\145"),
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(196.5, 194.5)
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
      name = "image_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(316, 192)
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
      name = "image_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 191.5)
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
      name = "label_diff",
      z = 0,
      parent = "image_bg",
      text = T("\233\154\190\229\186\166III"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(210.5, 194.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 2, h = 23.199998608},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_title_line.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, 193.5)
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
      name = "label_progress_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\189\147\229\137\141\230\140\145\230\136\152\232\191\155\229\186\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187.5, 158.5)
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
      name = "label_progress",
      z = 0,
      parent = "image_bg",
      text = "0/0",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(243.5, 158)
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
      name = "label_exit_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\152\175\229\144\166\233\128\128\229\135\186\239\188\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206, 128)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(266, 28.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_left_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_quit_time_bg.png",
      capInsets = CCRectMake(16.5, 10, 16.5, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, 92.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_mini_red.png",
      name = "btn_end",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 31.5)
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
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(317, 31.5)
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
      name = "image_line_center",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, 65)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_left_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_time_icon2.png",
      name = "ImageView_53484",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 14.25)
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
      name = "label_left_time",
      z = 0,
      parent = "image_left_bg",
      text = "00:00:00",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(133, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(157, 155, 145),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time_tips",
      z = 0,
      parent = "image_left_bg",
      text = T("\229\144\142\230\140\145\230\136\152\231\187\147\230\157\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(135.5, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 173),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_end",
      z = 0,
      parent = "btn_end",
      text = T("\228\184\173\230\173\162\229\185\182\231\187\147\231\174\151"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 173),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left",
      z = 0,
      parent = "btn_left",
      text = T("\230\154\130\230\151\182\231\166\187\229\188\128"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 1.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line_left",
      z = 0,
      parent = "image_line_center",
      res = "UI/alpha/1080P/common/com_line_left.png",
      capInsets = CCRectMake(76, 0.5, 76, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-94.25, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 1.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line_right",
      z = 0,
      parent = "image_line_center",
      res = "UI/alpha/1080P/common/com_line_left.png",
      capInsets = CCRectMake(76, 0.5, 76, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.75, 4.25)
    }
  }
}
