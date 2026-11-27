ed.uieditor = ed.uieditor or {}
ed.uieditor.CrusadeReplayMainWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(572.5, 386)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 40, 0.5, 200),
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 390)
    },
    t = "Scale9Sprite",
    base = {
      name = "main_frame",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(250, 103.5, 0.5, 107)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.25, 193)
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
      text = T("\232\191\156\229\190\129\230\136\152\230\150\151\229\189\149\229\131\143"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.25, 361)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.25, 360)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(384.75, 360)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(570, 330)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.25, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
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
      position = ccp(558.75, 370.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 177.5, h = 96.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_share.png",
      name = "bg_share",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(415.25, 268)
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
      scaleSize = CCSizeMake(166.5, 38.5),
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
      capInsets = CCRectMake(10, 10, 0.5, 0.5),
      name = "btn_guild",
      z = 0,
      parent = "bg_share",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 35.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_arena_record",
      z = 10,
      parent = "bg",
      text = T("\231\171\158\230\138\128"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-32.25, 305.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = -64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_arena_record",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-32.25, 305.5)
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
      name = "label_fight_record",
      z = 10,
      parent = "bg",
      text = T("\229\136\135\231\163\139"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.75, 216)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = -64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_fight_record",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-32.25, 216)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(166.5, 40),
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
      capInsets = CCRectMake(10, 10, 0.5, 0.5),
      name = "btn_world",
      z = 0,
      parent = "bg_share",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 72.75)
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
      name = "label_guild",
      z = 0,
      parent = "btn_guild",
      text = T("\229\136\134\228\186\171\229\136\176\229\133\172\228\188\154\233\162\145\233\129\147"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_guild",
      res = "UI/alpha/1080P/crusade/btn_guild.png",
      name = "icon_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.25, 19.25)
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
      name = "label_world",
      z = 0,
      parent = "btn_world",
      text = T("\229\136\134\228\186\171\229\136\176\228\184\150\231\149\140\233\162\145\233\129\147"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_world",
      res = "UI/alpha/1080P/crusade/btn_world.png",
      name = "icon_world",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_arena_record",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_arena_selected",
      z = 3
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(64.75, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_fight_record",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_fight_selected",
      z = 3
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(64.75, 36.25)
    }
  }
}
