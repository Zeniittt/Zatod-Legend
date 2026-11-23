ed.uieditor = ed.uieditor or {}
ed.uieditor.chat_battle_replay = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 87)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(6, 6, 3, 3),
      res = "UI/alpha/1080P/chat/chat_replay_input_bg.png",
      name = "player",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 29.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "player_title_bg",
      z = 0,
      parent = "player",
      res = "UI/alpha/1080P/chat/chat_share_input_bg.png",
      capInsets = CCRectMake(6, 6, 3, 3)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(0, 87)
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
      name = "player_name",
      z = 0,
      parent = "player_title_bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(63.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.1, h = 11.9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_title_bg",
      res = "UI/alpha/1080P/chat/new/chat_level_bg.png",
      name = "player_level_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player",
      res = "UI/alpha/1080P/crusade/icon_defead.png",
      name = "player_defead",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172, 69.5)
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
      name = "player_level",
      z = 0,
      parent = "player_title_bg",
      text = "99",
      size = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.05, h = 28.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_title_bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "player_head_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      fix_wh = {w = 43.2, h = 44},
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
      name = "detail_btn",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330, -117)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "player",
      res = "UI/alpha/1080P/crusade/icon_win.png",
      name = "player_win",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.9, h = 21.9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_title_bg",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "player_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 58)
    },
    t = "Layer",
    base = {
      parent = "player",
      name = "player_heroes",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      fix_wh = {w = 43.2, h = 44},
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
      name = "replay_btn",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(386, -117)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "detail_btn",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
      name = "detail_img",
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
      fix_wh = {w = 35.5, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chat/chat_battle.png",
      name = "VS",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, -21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 87)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(6, 6, 3, 3),
      res = "UI/alpha/1080P/chat/chat_replay_input_bg.png",
      name = "oppo",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(204.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "replay_btn",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "replay_img",
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
      fix_wh = {w = 17.5, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chat/new/chat_battle_campaign.png",
      name = "type_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, -50)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 29.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "oppo_title_bg",
      z = 0,
      parent = "oppo",
      res = "UI/alpha/1080P/chat/chat_share_input_bg.png",
      capInsets = CCRectMake(6, 6, 3, 3)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(0, 87)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "oppo",
      res = "UI/alpha/1080P/crusade/icon_win.png",
      name = "oppo_win",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "oppo",
      res = "UI/alpha/1080P/crusade/icon_defead.png",
      name = "oppo_defead",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 58)
    },
    t = "Layer",
    base = {
      parent = "oppo",
      name = "oppo_heroes",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.05, h = 28.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_title_bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "oppo_head_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.9, h = 21.9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_title_bg",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "oppo_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.1, h = 11.9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_title_bg",
      res = "UI/alpha/1080P/chat/new/chat_level_bg.png",
      name = "oppo_level_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.5, 15)
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
      name = "oppo_level",
      z = 0,
      parent = "oppo_title_bg",
      text = "99",
      size = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 15.5)
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
      name = "oppo_name",
      z = 0,
      parent = "oppo_title_bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 203, 177),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_defead",
      z = 0,
      parent = "player_defead",
      text = T("\232\180\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_win",
      z = 0,
      parent = "player_win",
      text = T("\232\131\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_win",
      z = 0,
      parent = "oppo_win",
      text = T("\232\131\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 203, 177),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_defead",
      z = 0,
      parent = "oppo_defead",
      text = T("\232\180\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 20.25)
    }
  }
}
