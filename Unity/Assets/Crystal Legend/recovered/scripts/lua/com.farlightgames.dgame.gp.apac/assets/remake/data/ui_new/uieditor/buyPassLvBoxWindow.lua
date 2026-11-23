ed.uieditor = ed.uieditor or {}
ed.uieditor.buyPassLvBoxWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(515, 311.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 55, 400, 200),
      res = "UI/alpha/1080P/taskModel/task_pop_buy_level.png",
      name = "ImageView_286",
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
      fix_scale = {y = 0.9, x = 0.9},
      fix_wh = {w = 40.5, h = 41.25},
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
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(714, 410)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_title.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 423)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(1, 1, 1),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "str_text",
      z = 0,
      parent = "ImageView_286",
      text = T("\232\180\173\228\185\176\230\136\152\232\175\129\231\173\137\231\186\167\239\188\140\229\143\175\233\162\134\229\143\150\228\187\165\228\184\139\229\165\150\229\138\177"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255, 260.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 87)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 29.5, 400, 29.5),
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_item_bg2.png",
      name = "conent_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 315.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(469.5, 76.5)
    },
    t = "Layer",
    base = {
      name = "input_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(245, 194)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(459, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17, 0.5, 17, 0.5),
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_305",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(477.5, 200.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(153.5, 46.55),
      flip = "",
      labelConfig = {
        color = ccc3(250, 242, 165)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_a_butt.png",
      name = "btn_buy",
      z = 0,
      capInsets = CCRectMake(32.5, 15, 32.5, 15),
      text = T("\232\180\173\228\185\176"),
      press = "UI/alpha/1080P/common/button_a_butt.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 148)
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
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "cost_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(452, 183.5)
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
      name = "ImageView_288",
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
      name = "title_text",
      z = 0,
      parent = "title_bg",
      text = T("\232\180\173\228\185\176\231\173\137\231\186\167"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.5, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(64, 63)
    },
    t = "Layer",
    base = {
      parent = "conent_bg",
      name = "icon_parent",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(27.25, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 54, h = 55},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_reduce",
      z = 1,
      parent = "input_panel",
      text = "-",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 54, h = 55},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_add",
      z = 1,
      parent = "input_panel",
      text = "+",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 54, h = 55},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_max",
      z = 0,
      parent = "input_panel",
      text = T("\230\156\128\229\164\167"),
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(388.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(135, 48)
    },
    t = "Scale9Sprite",
    base = {
      name = "input_bg",
      z = 0,
      parent = "input_panel",
      res = "UI/alpha/1080P/package/bg_soldout.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(459, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 0,
      parent = "ImageView_305",
      res = "UI/alpha/1080P/common/line_2b.png",
      capInsets = CCRectMake(17, 0.5, 17, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(696.5, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_305",
      res = "UI/alpha/1080P/common/line_star_2b.png",
      name = "ImageView_307",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(463.5, 13.25)
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
      name = "cost_value",
      z = 0,
      parent = "cost_icon",
      text = "25",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31, 13.5)
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
      name = "input_label",
      z = 0,
      parent = "input_bg",
      text = "1",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 24)
    }
  }
}
