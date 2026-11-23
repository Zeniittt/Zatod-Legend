ed.uieditor = ed.uieditor or {}
ed.uieditor.BattleEndWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(800, 240)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 10, 15, 10),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 427, h = 133},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_replay_self.png",
      name = "ImageView_2860",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.5, 145)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/replay_vs.png",
      name = "ImageView_2863",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 427, h = 133},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_replay_enemy.png",
      name = "ImageView_2860_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(557.5, 145)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(130, 45),
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
      name = "btn_replay_Copy0",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(197, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(130, 45),
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
      name = "btn_replay_Copy1",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(130, 45),
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
      name = "btn_replay_Copy2",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(603, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/crusade/icon_win.png",
      name = "ImageView_2862",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 115.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head_bj.png",
      name = "ImageView_2864",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 106)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 250.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/crusade/bg_name_reply_item.png",
      name = "bg_head_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199, 106.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(171, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(234.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(297, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/crusade/icon_win.png",
      name = "ImageView_2862",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.5, 115.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head_bj.png",
      name = "ImageView_2864",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(359.5, 106)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 250.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/crusade/bg_name_reply_item.png",
      name = "bg_head_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(228, 106.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(383, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(256, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2860_Copy0",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "ImageView_2867_Copy3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130, 46)
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
      name = "label_replay",
      z = 0,
      parent = "btn_replay_Copy0",
      text = T("\229\156\168\231\156\139\228\184\128\233\129\141"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 24)
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
      name = "label_replay",
      z = 0,
      parent = "btn_replay_Copy1",
      text = T("\230\149\176\230\141\174\231\187\159\232\174\161"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 24)
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
      name = "label_replay",
      z = 0,
      parent = "btn_replay_Copy2",
      text = T("\233\128\128\229\135\186\229\155\158\230\148\190"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 24)
    }
  }
}
