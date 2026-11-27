ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloRoomPrepare = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(904, 364.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(16.5, 16.5, 16.5, 16.5),
      res = "UI/alpha/1080P/chesscard/match/match_bg1.png",
      name = "bg",
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
      flip = "",
      opacity = 255,
      fix_wh = {w = 48.6, h = 48.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/close.png",
      name = "btn_close_wtr",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(894, 354.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 199.5, h = 210.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/create_bg.png",
      name = "img_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 203.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 199.5, h = 210.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/create_bg.png",
      name = "img_bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 203.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_wait_1",
      z = 0,
      parent = "img_bg_1",
      text = T("\229\140\185\233\133\141\228\184\173..."),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 227.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 36.5, h = 35.5},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/chat/chat_friend.png",
      name = "btn_addFriend_1",
      z = 2,
      parent = "img_bg_1",
      text = "",
      press = "UI/alpha/1080P/chat/chat_friend.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 199.5, h = 210.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/create_bg.png",
      name = "img_bg_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(557, 203.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139, h = 139},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg_1",
      res = "UI/alpha/1080P/chesscard/match/create.png",
      name = "btn_add_1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 105.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204.5, h = 222.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg_1",
      res = "UI/alpha/1080P/chesscard/match/player_bg.png",
      name = "player_bg1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.75, 110.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 199.5, h = 210.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/create_bg.png",
      name = "img_bg_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(767, 203.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 51.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_1",
      res = "UI/alpha/1080P/chesscard/match/closed_icon.png",
      name = "btn_kick_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.75, 178.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_wait_2",
      z = 0,
      parent = "img_bg_2",
      text = T("\229\140\185\233\133\141\228\184\173..."),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 227.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_1",
      res = "UI/alpha/1080P/chesscard/match/host_icon.png",
      name = "img_host_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 189.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139, h = 139},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg_2",
      res = "UI/alpha/1080P/chesscard/match/create.png",
      name = "btn_add_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 105.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 746.5, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/team_bg.png",
      name = "img_titlebar_wtr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(459, 404.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204.5, h = 222.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_2",
      res = "UI/alpha/1080P/chesscard/match/player_bg.png",
      name = "player_bg2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 110.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 51.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_2",
      res = "UI/alpha/1080P/chess/mode/Remove.png",
      name = "btn_kick_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.75, 178.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "prepare_time",
      z = 0,
      parent = "bg",
      text = T("\239\188\136\233\162\132\232\174\161\230\151\182\233\151\180 65S\239\188\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(454.5, 348.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_2",
      res = "UI/alpha/1080P/chesscard/match/host_icon.png",
      name = "img_host_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.75, 188.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_wait_3",
      z = 0,
      parent = "img_bg_3",
      text = T("\229\140\185\233\133\141\228\184\173..."),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 227.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 52, 26),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level1",
      z = 0,
      parent = "player_bg1",
      text = T("\229\163\171\229\133\181IV"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_bg1",
      res = "UI/alpha/1080P/chess/mode/player_title.png",
      name = "bg_name1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 50.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 36.5, h = 35.5},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/chat/chat_friend.png",
      name = "btn_addFriend_2",
      z = 2,
      parent = "img_bg_2",
      text = "",
      press = "UI/alpha/1080P/chat/chat_friend.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139, h = 139},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg_3",
      res = "UI/alpha/1080P/chesscard/match/create.png",
      name = "btn_add_3",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 105.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.55, x = 1.55},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170.5, h = 170.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player_bg1",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "avatar1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 138.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "prepare_time_left",
      z = 0,
      parent = "bg",
      text = T("\229\140\185\233\133\141\231\148\168\230\151\182\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(346.5, 347.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204.5, h = 222.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_3",
      res = "UI/alpha/1080P/chesscard/match/player_bg.png",
      name = "player_bg3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 110.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 51.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_3",
      res = "UI/alpha/1080P/chess/mode/Remove.png",
      name = "btn_kick_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.75, 178.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(119, 255, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "used_time",
      z = 0,
      parent = "bg",
      text = "00S",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(454.5, 347.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_3",
      res = "UI/alpha/1080P/chesscard/match/host_icon.png",
      name = "img_host_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.75, 188.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_wait_4",
      z = 0,
      parent = "img_bg_4",
      text = T("\229\140\185\233\133\141\228\184\173..."),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 227.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 52, 26),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level2",
      z = 0,
      parent = "player_bg2",
      text = T("\229\163\171\229\133\181IV"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_bg2",
      res = "UI/alpha/1080P/chess/mode/player_title.png",
      name = "bg_name2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 50.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 36.5, h = 35.5},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/chat/chat_friend.png",
      name = "btn_addFriend_3",
      z = 2,
      parent = "img_bg_3",
      text = "",
      press = "UI/alpha/1080P/chat/chat_friend.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139, h = 139},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg_4",
      res = "UI/alpha/1080P/chesscard/match/create.png",
      name = "btn_add_4",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 105.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.55, x = 1.55},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170.5, h = 170.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player_bg2",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "avatar2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 138.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(142.5, 46.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_start",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/match_button_2.png",
      capInsets = CCRectMake(10, 10, 80, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(796, 50.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204.5, h = 222.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_4",
      res = "UI/alpha/1080P/chesscard/match/player_bg.png",
      name = "player_bg4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 110.75)
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
      name = "name1",
      z = 0,
      parent = "bg_name1",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 51.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_4",
      res = "UI/alpha/1080P/chess/mode/Remove.png",
      name = "btn_kick_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.75, 178.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 249, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/mode/myteam_bg.png",
      name = "img_room_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.5, 51.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg_4",
      res = "UI/alpha/1080P/chesscard/match/host_icon.png",
      name = "img_host_4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.75, 188.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_title_wtr",
      z = 0,
      parent = "img_titlebar_wtr",
      text = T("\229\135\134\229\164\135\233\152\159\228\188\141"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(366.25, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 36.5, h = 35.5},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/chat/chat_friend.png",
      name = "btn_addFriend_4",
      z = 2,
      parent = "img_bg_4",
      text = "",
      press = "UI/alpha/1080P/chat/chat_friend.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 52, 26),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level3",
      z = 0,
      parent = "player_bg3",
      text = T("\229\163\171\229\133\181IV"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_bg3",
      res = "UI/alpha/1080P/chess/mode/player_title.png",
      name = "bg_name3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 50.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.55, x = 1.55},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170.5, h = 170.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player_bg3",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "avatar3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 138.25)
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
      name = "name2",
      z = 0,
      parent = "bg_name2",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 52, 26),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level4",
      z = 0,
      parent = "player_bg4",
      text = T("\229\163\171\229\133\181IV"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_bg4",
      res = "UI/alpha/1080P/chess/mode/player_title.png",
      name = "bg_name4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 50.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.55, x = 1.55},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170.5, h = 170.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player_bg4",
      res = "UI/alpha/1080P/mainhead/main_head_frame_dr.png",
      name = "avatar4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 138.25)
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
      name = "name3",
      z = 0,
      parent = "bg_name3",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 15.75)
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
      name = "lab_start",
      z = 0,
      parent = "btn_start",
      text = T("\229\188\128\229\167\139\229\140\185\233\133\141"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.25, 24.25)
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
      name = "name4",
      z = 0,
      parent = "bg_name4",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 212, 124),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_room_tag_wtr",
      z = 0,
      parent = "img_room_bar",
      text = T("\230\136\145\231\154\132\233\152\159\228\188\141ID:"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115.2, h = 52.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_room_bar",
      res = "UI/alpha/1080P/chesscard/match/match_button_1.png",
      name = "btn_copy_wtr",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-46.5, 21)
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
      name = "lab_room_id_wtr",
      z = 0,
      parent = "img_room_bar",
      text = "7370",
      size = 23
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(138.5, 21)
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
      name = "lab_copy_wtr",
      z = 0,
      parent = "btn_copy_wtr",
      text = T("\229\164\141\229\136\182"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_titlebar_wtr",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_749",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.75, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_titlebar_wtr",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_747_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473.25, 27.5)
    }
  }
}
