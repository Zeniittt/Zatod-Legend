ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaVoteWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725, 425)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17.5, 17, 17.5, 17),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 282.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(716.5, 420)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 285)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(37.5, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(191.5, 54.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_vote",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(38.5, 16, 38.5, 16)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(362.5, 40.5)
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
      parent = "image_bg",
      text = T("\233\128\137\230\139\169\228\189\160\232\166\129\231\166\129\231\148\168\231\154\132\232\139\177\233\155\132"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(338, 405)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 219, 136),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_select",
      z = 0,
      parent = "image_bg",
      text = "0/5",
      size = 23
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(441, 405)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(175, 173, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lable_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\190\151\231\165\168\230\149\176\230\156\128\233\171\152\231\154\1325\228\184\170\232\139\177\233\155\132\229\176\134\229\156\168\228\184\139\228\184\170\230\173\163\229\188\143\232\181\155\229\173\163\228\184\173\231\166\129\231\148\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(360.5, 377.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "image_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156.5, 377.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(562.5, 377.5)
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
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_91736",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 216, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vote",
      z = 0,
      parent = "btn_vote",
      text = T("\230\138\149\231\165\168"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.75, 28.75)
    }
  }
}
