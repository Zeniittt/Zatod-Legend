ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsBattleUI = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 799, h = 63.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battle/battle_ing_rb_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 500)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "ImageView_79785",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 32.75)
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
      name = "label_score_red",
      z = 1,
      parent = "image_bg",
      text = "0",
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444.5, 36.25)
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
      name = "label_score_blue",
      z = 1,
      parent = "image_bg",
      text = "0",
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(354.5, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battle/battle_signal.png",
      name = "image_sign_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.5, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(123, 220, 21),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_delay_blue",
      z = 0,
      parent = "image_bg",
      text = "0ms",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(196.5, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(170, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_name_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(171.5, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_head_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battle/battle_signal.png",
      name = "image_sign_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(583, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(123, 220, 21),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_delay_red",
      z = 0,
      parent = "image_bg",
      text = "0ms",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(628, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(170, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_name_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(459.5, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_head_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(634, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battle/battle_round_bg.png",
      name = "round_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399.5, -11.75)
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
      name = "label_round",
      z = 0,
      parent = "round_bg",
      text = T("\231\172\172\228\186\140\229\156\186"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/playerinfo/icon_account.png",
      name = "self_icon_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84.5, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/playerinfo/icon_account.png",
      name = "self_icon_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(714.5, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(84, 53)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_chat_selection_bg",
      z = 2,
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_main.png",
      capInsets = CCRectMake(20, 0, 124, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.5, -370.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_chat_selection_bg",
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_sticker_1.png",
      name = "btn_chat_sticker",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_chat_selection_bg",
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_sticker_2.png",
      name = "image_chat_sticker_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 28)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(189, 220)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_chat_sticker_bg",
      z = 2,
      parent = "image_chat_selection_bg",
      res = "UI/alpha/1080P/newkingspvp/chat/chat_tag_main.png",
      capInsets = CCRectMake(20, 25, 124, 0.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(174, 203)
    },
    t = "Layer",
    base = {
      parent = "image_chat_sticker_bg",
      name = "panel_sticker",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.5, 11)
    }
  }
}
