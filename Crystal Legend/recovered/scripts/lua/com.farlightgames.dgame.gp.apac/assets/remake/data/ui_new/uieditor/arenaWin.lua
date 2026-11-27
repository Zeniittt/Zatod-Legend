ed.uieditor = ed.uieditor or {}
ed.uieditor.arenaWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(567.5, 387)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 95, 1, 107),
      res = "UI/alpha/1080P/pvp/farme_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(617, 249)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(306, 476)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_banner",
      z = 1,
      parent = "bg",
      res = "UI/alpha/1080P/pvp/banner.png",
      capInsets = CCRectMake(0.5, 224, 305, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-101.75, 208.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.60000014, x = 1.60000014},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82.40000721, h = 87.20000763},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/crusade/main_head_frame_kings_s8.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153, 332)
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
      name = "name",
      z = 0,
      parent = "bg_banner",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153, 278)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/battlenum_bg.png",
      name = "bg_times",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327.75, 358.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 223.5, h = 66.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/pvp/banner_bg.png",
      name = "bg_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153, 203)
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
      parent = "bg_banner",
      name = "layer_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(42.5, 67.5)
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
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 514)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(532, 331)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_enemy",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26.25, 9)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(120, 43),
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
      normal = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(20, 15.5, 90, 32.5),
      name = "btn_change",
      z = 0,
      parent = "bg_banner",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.5, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98.5, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_times",
      res = "UI/alpha/1080P/pvp/refresh_button.png",
      name = "btn_switch",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(308.5, 13.75)
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
      parent = "bg_reward",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141\229\165\150\229\138\177\233\162\132\232\167\136"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0.25, 78.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(220, 65)
    },
    t = "Layer",
    base = {
      parent = "bg_reward",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.75, 0.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.6, h = 25.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/crusade/number/crusade_1.png",
      name = "rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153, 415.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_times",
      z = 0,
      parent = "bg_times",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\1545/5"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 215, 119),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_btTime",
      z = 0,
      parent = "bg",
      text = "04:00",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.25, 359)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 128, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/pvp/rank.png",
      name = "banner_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153, 450)
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
      name = "label_team",
      z = 0,
      parent = "layer_team",
      text = T("\233\152\178\229\174\136\233\152\181\229\174\185"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 85)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_switch",
      z = 0,
      parent = "btn_switch",
      text = T("\230\141\162\228\184\128\230\137\185"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_team",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_switch",
      res = "UI/alpha/1080P/pvp/refresh.png",
      name = "icon_switch",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_team",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_switch",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "icon_redLight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.25, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_team",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-316.25, 198.5)
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
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_team",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.5, 45.5)
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
      name = "label_change",
      z = 0,
      parent = "btn_change",
      text = T("\232\176\131\230\149\180"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.57, x = 0.57},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.3, h = 51.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_team",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_13.png",
      name = "hero5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_change",
      res = "UI/alpha/1080P/pvp/lineup.png",
      name = "icon_change",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(65, 32),
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
      normal = "UI/alpha/1080P/common/button_mini_sys.png",
      capInsets = CCRectMake(22.5, 14, 45, 14),
      name = "btn_share",
      z = 0,
      parent = "layer_team",
      text = "",
      press = "UI/alpha/1080P/common/button_mini_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190, 84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 297, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/arena_phantom/buff_bg.png",
      name = "bg_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185.75, 416.5)
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
      name = "Label_7582",
      z = 0,
      parent = "label_btTime",
      text = T("\229\144\142\229\143\175\231\187\167\231\187\173\230\140\145\230\136\152"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(197.5, 58.75)
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
      color = ccc3(255, 230, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur_rank",
      z = 0,
      parent = "banner_title",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_share_times",
      z = 0,
      parent = "btn_share",
      text = T("\229\136\134\228\186\171(3)"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 17)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 65.5)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, -2)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, -69.5)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 133)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, -134.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 223, 237),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff_left_time",
      z = 0,
      parent = "bg_buff",
      text = "92:00:99",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207, 52.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 167, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff_1",
      z = 0,
      parent = "bg_buff",
      text = T("\229\137\169\228\189\153\230\151\182\233\151\180\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.5, 52.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(245, 29)
    },
    t = "Layer",
    base = {
      parent = "bg_buff",
      name = "bg_buff_touch",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(28, 38.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn2",
      res = "UI/alpha/1080P/pvp/shop.png",
      name = "icon_btn2",
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
      fix_wh = {w = 43, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn3",
      res = "UI/alpha/1080P/pvp/reward.png",
      name = "icon_btn3",
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
      fix_wh = {w = 46, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn4",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_btn4",
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
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn4",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "recordTag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn1",
      res = "UI/alpha/1080P/pvp/ranking.png",
      name = "icon_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn5",
      res = "UI/alpha/1080P/crusade/icon_hot.png",
      name = "icon_btn5",
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
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn2",
      z = 0,
      parent = "icon_btn2",
      text = T("\229\133\145\230\141\162"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, -4.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn3",
      z = 0,
      parent = "icon_btn3",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, -4.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn4",
      z = 0,
      parent = "icon_btn4",
      text = T("\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, -2.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn1",
      z = 0,
      parent = "icon_btn1",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, -3.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn5",
      z = 0,
      parent = "icon_btn5",
      text = T("\231\131\173\233\151\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -2.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_times",
      res = "UI/alpha/1080P/fireforge/others/Switch_off.png",
      name = "switch_equip_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-96.5, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192.5, h = 57.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/legendequip/arena_special/board.png",
      name = "bg_legend_equip_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473.75, 409.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_equip_bg",
      res = "UI/alpha/1080P/fireforge/others/Switch_on.png",
      name = "close_equip_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_equip_bg",
      res = "UI/alpha/1080P/fireforge/others/Switch_circle.png",
      name = "btn_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.75, 18.5)
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
      name = "label_equip",
      z = 0,
      parent = "switch_equip_bg",
      text = T("\229\177\149\231\164\186"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.75, 18.5)
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
      name = "label_equip_des",
      z = 0,
      parent = "switch_equip_bg",
      text = T("\228\188\160\229\165\135\232\163\133\229\164\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.75, 19)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_equip_enable",
      z = 0,
      parent = "switch_equip_bg",
      text = T("\228\184\141\230\152\190\231\164\186"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.25, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.24, x = 0.24},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/to_jpg_x_alpha/le1.png",
      name = "legend_equip_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.25, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.85, h = 9.15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/star_unlock.png",
      name = "image_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.85, h = 9.15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/star_unlock.png",
      name = "image_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.25, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.31, x = 0.31},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.145, h = 9.455},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/star_unlock.png",
      name = "image_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.31, x = 0.31},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.145, h = 9.455},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/star_unlock.png",
      name = "image_star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.31, x = 0.31},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.145, h = 9.455},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/star_unlock.png",
      name = "image_star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 247, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_legend_equip_time",
      z = 0,
      parent = "bg_legend_equip_buff",
      text = T("5\229\164\16922\229\176\143\230\151\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.25, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/arena_special/art2.png",
      name = "ImageView_25177",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 37.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/arena_special/art2.png",
      name = "ImageView_25177_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.25, 42.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip_buff",
      res = "UI/alpha/1080P/legendequip/arena_special/art2.png",
      name = "ImageView_25177_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84.25, 23.75)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, -137)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn5",
      res = "UI/alpha/1080P/pvp/arena_background.png",
      name = "icon_btn5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn5",
      z = 0,
      parent = "icon_btn5",
      text = T("\232\131\140\230\153\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, -2.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_btn5",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "bgTag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 47)
    }
  }
}
