ed.uieditor = ed.uieditor or {}
ed.uieditor.BattleStaticWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(677.5, 450)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(656.75, 437.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 667, h = 300.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_statics_main.png",
      name = "bg_item",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(338.75, 225)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2427",
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
      fix_wh = {w = 667, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_title_statics.png",
      name = "sub_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(338.75, 387.5)
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
      parent = "bg",
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(338.75, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "sub_title",
      res = "UI/alpha/1080P/crusade/icon_pk.png",
      name = "icon_pk",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333.5, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "self_statistics",
      z = 0,
      parent = "sub_title",
      text = T("\230\136\145\230\150\185\233\128\160\230\136\144\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "enemy_statistics",
      z = 0,
      parent = "sub_title",
      text = T("\230\149\140\230\150\185\233\128\160\230\136\144\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/sperator_line.png",
      name = "line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_bg.png",
      name = "bg_btn2",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-45, 0)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_bg.png",
      name = "bg_btn3",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 0)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_bg.png",
      name = "bg_btn4",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135, 0)
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
      parent = "bg",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(338.75, 431)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_bg.png",
      name = "bg_btn1",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-135, 0)
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
      parent = "title",
      text = T("\230\136\152\231\187\169\230\149\176\230\141\174"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "title_left_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-90, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/sperator_line.png",
      name = "line3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.5, 0)
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
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "title_right_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/sperator_line.png",
      name = "line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-90, 0)
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
      parent = "bg_btn2",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn2",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_btn2",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_selected.png",
      name = "selected_btn2",
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
      color = ccc3(146, 146, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn2",
      z = 0,
      parent = "bg_btn2",
      text = T("\230\137\191\229\143\151\228\188\164\229\174\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      parent = "bg_btn3",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn3",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_btn3",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_selected.png",
      name = "selected_btn3",
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
      color = ccc3(146, 146, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn3",
      z = 0,
      parent = "bg_btn3",
      text = T("\230\178\187\231\150\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      parent = "bg_btn4",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn4",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_btn4",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_selected.png",
      name = "selected_btn4",
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
      color = ccc3(146, 146, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn4",
      z = 0,
      parent = "bg_btn4",
      text = T("\229\135\187\230\157\128"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      parent = "bg_btn1",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn1",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn1",
      res = "UI/alpha/1080P/crusade/btn_statics_tag_selected.png",
      name = "selected_btn1",
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
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn1",
      z = 0,
      parent = "bg_btn1",
      text = T("\233\128\160\230\136\144\228\188\164\229\174\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 285)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13.75, 85)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 285)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(363.75, 85)
    }
  }
}
