ed.uieditor = ed.uieditor or {}
ed.uieditor.dailylogin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 493.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bg/dailylogin_bj.png",
      name = "dailylogin_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379, 246.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 64)
    },
    t = "Layer",
    base = {name = "money_lay", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(11.5, 421)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 64)
    },
    t = "Layer",
    base = {
      name = "top_rig_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(346, 421)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "money_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_data_img2.png",
      name = "ImageView_26",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "money_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_month_7.png",
      name = "img_month_num",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.399998416, h = 26.399998416},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "button_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(723, 461.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.54999735, h = 18.54999735},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "money_lay",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "rule_butt",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_login_month",
      z = 0,
      parent = "money_lay",
      text = T("\230\156\136\231\173\190\229\136\176"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(87, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dailylogin/dailylogin_time_img.png",
      name = "ImageView_58",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.5, 387)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 210, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_33_1",
      z = 0,
      parent = "top_rig_lay",
      text = T("\229\164\169"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(39, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 255, 1),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "progress_day_num1",
      z = 0,
      parent = "top_rig_lay",
      text = "3",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(58, 35, 31),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 14,
      text = T("\230\175\143\230\151\165\231\173\190\229\136\176\229\136\183\230\150\176\229\128\146\232\174\161\230\151\182\239\188\154"),
      name = "Label_59",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40.5, 387.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15, 15)
    },
    t = "Layer",
    base = {
      parent = "top_rig_lay",
      name = "item_pos1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(62, 34)
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
      parent = "rule_butt",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_30",
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
      visible = true,
      scaleSize = CCSizeMake(15, 15)
    },
    t = "Layer",
    base = {
      parent = "top_rig_lay",
      name = "item_pos2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(140.5, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(58, 35, 31),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 14,
      text = "14:54:32",
      name = "txt_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(211.5, 387.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 255, 1),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "progress_day_num2",
      z = 0,
      parent = "top_rig_lay",
      text = "7",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 210, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_33_2",
      z = 0,
      parent = "top_rig_lay",
      text = T("\229\164\169"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(117.5, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(58, 35, 31),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 14,
      text = T("\230\156\172\230\156\136\229\183\178\231\180\175\232\174\161\231\173\190\229\136\1763\229\164\169"),
      name = "txt_money_day",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(732, 387.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15, 15)
    },
    t = "Layer",
    base = {
      parent = "top_rig_lay",
      name = "item_pos3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(220.5, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 255, 1),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "progress_day_num3",
      z = 0,
      parent = "top_rig_lay",
      text = "15",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(720, 355)
    },
    t = "Layer",
    base = {
      name = "day_item_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(18.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 210, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_33_3",
      z = 0,
      parent = "top_rig_lay",
      text = T("\229\164\169"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(197.5, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15, 15)
    },
    t = "Layer",
    base = {
      parent = "top_rig_lay",
      name = "item_pos4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(300.5, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 255, 1),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "progress_day_num4",
      z = 0,
      parent = "top_rig_lay",
      text = "30",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(256, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 210, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_33_4",
      z = 0,
      parent = "top_rig_lay",
      text = T("\229\164\169"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(277.5, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 299, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_rig_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_progress_bj.png",
      name = "img_progress_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 299, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_rig_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_progres.png",
      name = "img_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(5.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_rig_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_progress_pot.png",
      name = "img_progress_pot_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_rig_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_progress_pot.png",
      name = "img_progress_pot_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_rig_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_progress_pot.png",
      name = "img_progress_pot_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_rig_lay",
      res = "UI/alpha/1080P/dailylogin/dailylogin_progress_pot.png",
      name = "img_progress_pot_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301, 9.5)
    }
  }
}
