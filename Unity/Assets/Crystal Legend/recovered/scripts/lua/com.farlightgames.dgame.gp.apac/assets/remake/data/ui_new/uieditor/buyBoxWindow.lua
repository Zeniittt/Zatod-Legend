ed.uieditor = ed.uieditor or {}
ed.uieditor.buyBoxWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(484, 311.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 149, 40, 200),
      res = "UI/alpha/1080P/package/bg_normal.png",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(493.5, 312)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_294",
      z = 0,
      parent = "ImageView_286",
      res = "UI/alpha/1080P/scale9/frame_common1.png",
      capInsets = CCRectMake(25, 125, 25, 125)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242, 155.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
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
      visible = true,
      scaleSize = CCSizeMake(314, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(65, 7.5, 65, 7.5),
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483, 403)
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
      color = ccc3(107, 97, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("\228\187\138\230\151\165\229\143\175\232\180\173\228\185\176\230\172\161\230\149\176\239\188\154123"),
      name = "text_buy_num_limit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(467.5, 87)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 29.5, 15, 29.5),
      res = "UI/alpha/1080P/scale9/box_bg.png",
      name = "conent_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 337.5)
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
      text = T("\232\180\173\228\185\176\233\173\130\229\140\163\229\136\184"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.5, 16.75)
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
      scaleSize = CCSizeMake(153.5, 46.5),
      flip = "",
      labelConfig = {
        color = ccc3(250, 242, 165)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_a_butt.png",
      name = "btn_buy_123",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name",
      z = 0,
      parent = "conent_bg",
      text = T("\233\173\130\229\140\163\229\165\150\229\136\184"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(111.75, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_buy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 147.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_desc",
      z = 0,
      parent = "conent_bg",
      text = T("\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(111.75, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(44, 82, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "amount",
      z = 0,
      parent = "conent_bg",
      text = "123",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(441.75, 71.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(107, 97, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_amount_str",
      z = 0,
      parent = "conent_bg",
      text = T("\230\140\129\230\156\137\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(424.75, 71.5)
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
      size = 26
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
      size = 26
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
      size = 21
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
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(320, 50)
    },
    t = "Layer",
    base = {
      parent = "conent_bg",
      name = "item_desc_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(111.75, 8.5)
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
      text = "1239999999999",
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
      color = ccc3(250, 242, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buy",
      z = 0,
      parent = "btn_buy",
      text = T("\232\180\173\228\185\176"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 28.25)
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
      text = "99999",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 24)
    }
  }
}
