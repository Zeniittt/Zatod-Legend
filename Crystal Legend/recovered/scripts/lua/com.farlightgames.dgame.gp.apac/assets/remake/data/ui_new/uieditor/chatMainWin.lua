ed.uieditor = ed.uieditor or {}
ed.uieditor.chatMainWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(635, 525)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 22.5, 6, 6),
      res = "UI/alpha/1080P/chat/new/chat_bg.png",
      name = "chat_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(45, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(534, 528)
    },
    t = "Scale9Sprite",
    base = {
      name = "chat_content_bg",
      z = 0,
      parent = "chat_bg",
      res = "UI/alpha/1080P/chat/chat_content_bg.png",
      capInsets = CCRectMake(15, 20, 9.5, 4.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(100, -4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(526, 47.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "chat_input_bg",
      z = 0,
      parent = "chat_content_bg",
      res = "UI/alpha/1080P/chat/chat_input_bg.png",
      capInsets = CCRectMake(8.5, 8.5, 1, 3.5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(267, 8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(330, 30)
    },
    t = "Scale9Sprite",
    base = {
      name = "chat_input_frame",
      z = 0,
      parent = "chat_input_bg",
      res = "UI/alpha/1080P/chat/chat_input_frame.png",
      capInsets = CCRectMake(5, 5, 5, 5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 33.5, h = 35.5},
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
      normal = "UI/alpha/1080P/chat/icon_emoji_big.png",
      name = "emoji_win_btn",
      z = 0,
      parent = "chat_input_bg",
      text = "",
      press = "UI/alpha/1080P/chat/icon_config_selected.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(360.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(525, 450)
    },
    t = "Layer",
    base = {
      parent = "chat_content_bg",
      name = "msg_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5, 60)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.72, x = 0.58},
      fix_wh = {w = 110.49, h = 40.68},
      flip = "",
      labelConfig = {
        color = ccc3(247, 228, 153)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/buttion_big.png",
      name = "send_btn",
      z = 0,
      parent = "chat_input_bg",
      text = "",
      press = "UI/alpha/1080P/common/button_big_red.png",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(451.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "sned_label",
      z = 0,
      parent = "chat_input_bg",
      text = T("\229\143\145\233\128\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(451.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.55, x = 0.55},
      fix_wh = {w = 33, h = 59.125},
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
      normal = "UI/alpha/1080P/chat/chat_entrance_big.png",
      name = "close_btn",
      z = 0,
      parent = "chat_bg",
      text = "",
      press = "UI/alpha/1080P/chat/chat_entrance_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(633.5, 237)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(526, 247.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "emoji_bg",
      z = 1,
      parent = "chat_content_bg",
      res = "UI/alpha/1080P/chat/emoji_bg.png",
      capInsets = CCRectMake(9.5, 5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 55.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(330, 30)
    },
    t = "Scale9Sprite",
    base = {
      name = "chat_input_frame_real",
      z = 1,
      parent = "chat_input_bg",
      res = "UI/alpha/1080P/chat/chat_input_frame.png",
      capInsets = CCRectMake(5, 5, 5, 5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(250, 225, 199),
      opacity = 255,
      verticalAlignment = 1,
      visible = false
    },
    t = "Label",
    base = {
      name = "msg_list_tip",
      z = 0,
      parent = "msg_list",
      text = T("\233\128\137\230\139\169\228\184\128\228\189\141\232\129\148\231\179\187\228\186\186\239\188\140\230\136\150\230\152\175\230\183\187\229\138\160\230\150\176\229\175\185\232\175\157"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(247.5, 236)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(530, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "suspension_bg",
      z = 0,
      parent = "chat_content_bg",
      res = "UI/alpha/1080P/chat/chat_input.png",
      capInsets = CCRectMake(10, 10, 2, 2)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(267, 55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 52, h = 53},
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
      normal = "UI/alpha/1080P/chat/chat_but_bj.png",
      name = "set_btn",
      z = 0,
      parent = "chat_bg",
      text = "",
      press = "UI/alpha/1080P/chat/chat_but_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "close_btn",
      res = "UI/alpha/1080P/chat/left_arrow.png",
      name = "arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 53.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(2, 247.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 0,
      parent = "emoji_bg",
      res = "UI/alpha/1080P/chat/emoji_dividingline.png",
      capInsets = CCRectMake(0.5, 2, 0.5, 1)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(54.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "emoji_bg",
      res = "UI/alpha/1080P/chat/button_chat_unselected.png",
      name = "btn_bg",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(54.5, 200)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 22, h = 23.5},
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
      normal = "UI/alpha/1080P/chat/icon_emoji_grey.png",
      name = "emoji_btn",
      z = 0,
      parent = "emoji_bg",
      text = "",
      press = "UI/alpha/1080P/chat/icon_config_selected.png",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 208)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      fix_wh = {w = 45, h = 45},
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
      normal = "UI/alpha/1080P/battle/battle_prepare_team_2.png",
      name = "hero_btn",
      z = 0,
      parent = "emoji_bg",
      text = "",
      press = "UI/alpha/1080P/battle/battle_prepare_team_1.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 154)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "chat_bg",
      name = "channel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(51.5, 525)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(420, 210)
    },
    t = "Layer",
    base = {
      parent = "emoji_bg",
      name = "emoji_hero_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(80, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 30, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "suspension_bg",
      res = "UI/alpha/1080P/chat/skip.png",
      name = "skip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "emoji_label",
      z = 0,
      parent = "emoji_bg",
      text = T("\232\161\168\230\131\133"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 188.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "hero_label",
      z = 0,
      parent = "emoji_bg",
      text = T("\232\139\177\233\155\132"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 136)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      fix_wh = {w = 29.25, h = 29.25},
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
      normal = "UI/alpha/1080P/chat/icon_sticker_grey.png",
      name = "sticker_btn",
      z = 0,
      parent = "emoji_bg",
      text = "",
      press = "UI/alpha/1080P/chat/icon_sticker_selected.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 100)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "chat_bg",
      name = "extra_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(734, 262.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "set_btn",
      res = "UI/alpha/1080P/chat/icon_config_big.png",
      name = "set_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "sticker_label",
      z = 0,
      parent = "emoji_bg",
      text = T("\232\161\168\230\131\133\229\140\133"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 81)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(127.5, 100.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "config_bg",
      z = 0,
      parent = "set_btn",
      res = "UI/alpha/1080P/chat/config_bg.png",
      capInsets = CCRectMake(85, 10, 7.5, 50)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(55, 59)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 95, h = 39.5},
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
      normal = "UI/alpha/1080P/chat/new/chat_button_unclick.png",
      name = "world_channel",
      z = 0,
      parent = "channel_list",
      text = "",
      press = "UI/alpha/1080P/chat/new/chat_button_click.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 95, h = 39.5},
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
      normal = "UI/alpha/1080P/chat/new/chat_button_unclick.png",
      name = "guild_channel",
      z = 0,
      parent = "channel_list",
      text = "",
      press = "UI/alpha/1080P/chat/new/chat_button_click.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -100)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 95, h = 39.5},
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
      normal = "UI/alpha/1080P/chat/new/chat_button_unclick.png",
      name = "personal_channel",
      z = 0,
      parent = "channel_list",
      text = "",
      press = "UI/alpha/1080P/chat/new/chat_button_click.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -150)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(112.5, 37.5),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(35, 7.5, 15, 5.5),
      name = "blacklist_btn",
      z = 0,
      parent = "config_bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.75, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(112.5, 37.5),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(35, 7.5, 15, 5.5),
      name = "chatset_btn",
      z = 0,
      parent = "config_bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.75, 75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(86.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(35, 15, 7.5, 5.5),
      name = "clear_btn",
      z = 0,
      parent = "extra_layer",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-52, -237)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(201.5, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg",
      z = 0,
      parent = "extra_layer",
      res = "UI/alpha/1080P/chat/lately_bg.png",
      capInsets = CCRectMake(17.5, 0, 5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(0, 262.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(203, 420)
    },
    t = "Layer",
    base = {
      parent = "extra_layer",
      name = "member_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-101.5, -200)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(97.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(35, 15, 7.5, 5.5),
      name = "add_btn",
      z = 0,
      parent = "extra_layer",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, -236.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "blacklist_btn",
      res = "UI/alpha/1080P/chat/icon_blacklist.png",
      name = "blacklist_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 18.75)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "blacklist_label",
      z = 0,
      parent = "blacklist_btn",
      text = T("\233\187\145\229\144\141\229\141\149"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.75, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(250, 225, 199),
      opacity = 255,
      verticalAlignment = 1,
      visible = false
    },
    t = "Label",
    base = {
      name = "member_list_tip",
      z = 0,
      parent = "extra_layer",
      text = T("\230\154\130\230\151\160\230\156\128\232\191\145\232\129\148\231\179\187\228\186\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "chatset_btn",
      res = "UI/alpha/1080P/chat/icon_config.png",
      name = "chatset_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, 18.75)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "chatset_label",
      z = 0,
      parent = "chatset_btn",
      text = T("\232\129\138\229\164\169\232\174\190\231\189\174"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(39.25, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 17.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "personal_channel",
      res = "UI/alpha/1080P/chat/new/new_tips.png",
      name = "personal_redpoint",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 35.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "clear_label",
      z = 0,
      parent = "clear_btn",
      text = T("\230\184\133\233\153\164\229\175\185\232\175\157"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.25, 23)
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
      parent = "title_bg",
      res = "UI/alpha/1080P/chat/icon_chat.png",
      name = "title_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "title_bg",
      text = T("\230\156\128\232\191\145\232\129\148\231\179\187\228\186\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.75, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "add_label",
      z = 0,
      parent = "add_btn",
      text = T("\230\183\187\229\138\160\230\150\176\229\175\185\232\175\157"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.75, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "personal_rednum",
      z = 0,
      parent = "personal_redpoint",
      text = "99",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.75, 8.75)
    }
  }
}
