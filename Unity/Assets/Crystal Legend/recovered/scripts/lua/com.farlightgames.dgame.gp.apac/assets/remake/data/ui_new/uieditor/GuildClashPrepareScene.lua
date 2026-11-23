ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashPrepareScene = {
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
      name = "bg_title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.5, 496)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(831.5, 498.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.6, h = 47.6},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/herolist/tab_unselected.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.6, h = 47.6},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/herolist/tab_unselected.png",
      name = "btn_shop",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(707, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.6, h = 47.6},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/herolist/tab_unselected.png",
      name = "btn_book",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143, 74)
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
    base = {name = "layer_1", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
    base = {name = "layer_2", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
    base = {name = "layer_3", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/toparena/toparena_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(47.75, 17.75)
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
      name = "icon_rule",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_225",
      z = 0,
      parent = "btn_rule",
      text = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.25, 14.75)
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
      name = "label_reward",
      z = 0,
      parent = "btn_reward",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 28)
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
      name = "label_shop",
      z = 0,
      parent = "btn_shop",
      text = T("\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 28)
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
      name = "label_book",
      z = 0,
      parent = "btn_book",
      text = T("\231\142\169\230\179\149\230\148\187\231\149\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_235",
      z = 0,
      parent = "layer_1",
      text = T("\229\164\167\230\160\135\233\162\152\239\188\154\229\133\172\228\188\154\230\136\152\228\184\128\232\167\166\229\141\179\229\143\145"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477, 326)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_236",
      z = 0,
      parent = "layer_1",
      text = T("\229\137\175\230\160\135\233\162\152\239\188\1542\229\176\143\230\151\182\229\144\142\229\188\128\229\144\175"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481, 287)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 86.275, h = 35.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_2",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(837.5, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_243",
      z = 0,
      parent = "layer_2",
      text = T("\228\187\138\230\151\165\232\180\161\231\140\174\230\180\187\232\183\131\239\188\154500/900"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(834.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_244",
      z = 0,
      parent = "layer_2",
      text = T("\230\182\136\232\128\151\228\189\147\229\138\155\239\188\154\229\162\158\229\138\160\229\133\172\228\188\154\230\180\187\232\183\131"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(842, 97)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 300)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_info1",
      z = 0,
      parent = "layer_2",
      res = "UI/alpha/1080P/common/com_new_4.png",
      capInsets = CCRectMake(17.5, 17.5, 17.5, 17.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489.5, 286)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_256",
      z = 0,
      parent = "layer_2",
      text = T("\232\181\155\229\137\141---\229\133\172\228\188\154\229\174\154\231\186\167"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 472.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_257",
      z = 0,
      parent = "layer_2",
      text = T("2\229\164\16923\229\176\143\230\151\182\229\128\153\229\174\154\231\186\167\231\187\147\230\157\159"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 452)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 300)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_info2",
      z = 0,
      parent = "layer_3",
      res = "UI/alpha/1080P/common/com_new_4.png",
      capInsets = CCRectMake(17.5, 17.5, 17.5, 17.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489, 286)
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
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\229\137\141\229\190\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_246",
      z = 0,
      parent = "bg_info1",
      text = T("\229\133\168\229\145\152\232\142\183\229\190\151\230\180\187\232\183\131\239\188\140\230\143\144\233\171\152\229\133\172\228\188\154\229\174\154\231\186\167"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, 272)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guild_name",
      z = 0,
      parent = "bg_info1",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_info1",
      res = "UI/alpha/1080P/common/chest1.png",
      name = "guild_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 139)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_251",
      z = 0,
      parent = "bg_info1",
      text = T("\230\128\187\230\180\187\232\183\131\239\188\154102500"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 114)
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
      parent = "bg_info1",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_active",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92, 81)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 476, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_info1",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_bar_2.png",
      name = "bg_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375.5, 159)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2461",
      z = 0,
      parent = "bg_info2",
      text = T("\229\133\168\229\145\152\232\142\183\229\190\151\230\180\187\232\183\131\239\188\140\230\143\144\233\171\152\229\133\172\228\188\154\229\174\154\231\186\167"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, 272)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guild_name1",
      z = 0,
      parent = "bg_info2",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_info2",
      res = "UI/alpha/1080P/common/chest1.png",
      name = "guild_icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 139)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2511",
      z = 0,
      parent = "bg_info2",
      text = T("\230\128\187\230\180\187\232\183\131\239\188\154102500"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 114)
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
      parent = "bg_info2",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_active1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92, 81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_282",
      z = 0,
      parent = "bg_info2",
      text = T("\230\136\152\229\140\186\229\136\146\229\136\134\239\188\154"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(335, 145)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_283",
      z = 0,
      parent = "bg_info2",
      text = T("\230\156\128\231\187\136\229\174\154\231\186\167\239\188\154"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(335, 184)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_info2",
      res = "UI/alpha/1080P/achievement/achievement_abyss.png",
      name = "ImageView_284",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(583, 244.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_285",
      z = 0,
      parent = "bg_info2",
      text = T("xxx\229\144\142\229\188\128\229\144\175\229\133\172\228\188\154\230\136\152"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(342.5, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 473, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_bar_1.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(3, 12.75)
    }
  }
}
