ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaGambleItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 809, h = 195},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_race_list_1.png",
      name = "bg",
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
      fix_wh = {w = 196.5, h = 25.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_red_bg_2.png",
      name = "bg_pick_red",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0),
      position = ccp(220, 159.5)
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
      parent = "bg",
      text = T("A\231\187\132 128\232\191\15564"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(408.5, 171.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_pick_red",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_red_button_2.png",
      name = "btn_pick_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 196.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_red_bg_1.png",
      name = "bg_selected_red",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0),
      position = ccp(220, 155.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "img_head_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 98)
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
      name = "label_support_red",
      z = 0,
      parent = "bg",
      text = T("\230\148\175\230\140\129\231\142\135\239\188\15412%"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(196, 68.5)
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
      name = "label_name_red",
      z = 0,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(142.5, 133)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_1.png",
      name = "img_camp_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.5, 101)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp_red",
      z = 0,
      parent = "bg",
      text = T("\229\190\183\233\178\129\228\188\138\233\152\181\232\144\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(174.5, 100.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp_blue",
      z = 0,
      parent = "bg",
      text = T("\229\190\183\233\178\129\228\188\138\233\152\181\232\144\165"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(666, 100.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_1.png",
      name = "img_camp_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(565, 100.5)
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
      name = "label_name_blue",
      z = 0,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(666, 133)
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
      name = "label_support_blue",
      z = 0,
      parent = "bg",
      text = T("\230\148\175\230\140\129\231\142\135\239\188\15412%"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(598.5, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104.5, h = 104.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "img_head_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(723.5, 98)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192.5, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_blue_bg_1.png",
      name = "bg_selected_blue",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0),
      position = ccp(797.5, 150.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 194.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_blue_bg_2.png",
      name = "bg_pick_blue",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0),
      position = ccp(794.5, 159)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_video_button.png",
      name = "btn_report",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(404, 60)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 196),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pick_red",
      z = 0,
      parent = "bg_pick_red",
      text = T("\230\148\175\230\140\129"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_selected_red",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_red_button_1.png",
      name = "btn_add_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 196),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_value_red",
      z = 0,
      parent = "bg_selected_red",
      text = T("\229\183\178\228\184\139\230\179\168"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_selected_blue",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_blue_button_1.png",
      name = "btn_add_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178.5, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 196),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_value_blue",
      z = 0,
      parent = "bg_selected_blue",
      text = T("\229\183\178\228\184\139\230\179\1685000\228\184\135"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(161.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_pick_blue",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_pick_red_button_2.png",
      name = "btn_pick_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 196),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pick_blue",
      z = 0,
      parent = "bg_pick_blue",
      text = T("\230\148\175\230\140\129"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(167, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 213),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_report",
      z = 0,
      parent = "btn_report",
      text = T("\230\136\152\229\134\181"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 20.75)
    }
  }
}
