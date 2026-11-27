ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendRankWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1012, 712.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(19.5, 18, 0.5, 0.5),
      res = "UI/alpha/1080P/crevicedefend/rankbg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 264.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(690, 279)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_record",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(163, 186.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 172, h = 143.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/null.png",
      name = "img_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(499, 313.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(872, 490.75)
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
      name = "label_title_des",
      z = 1,
      parent = "bg",
      text = T("\230\136\141\229\141\171\230\142\146\232\161\140\230\166\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505.5, 482.75)
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
      name = "label_title",
      z = 0,
      parent = "bg",
      text = "",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(504, 523.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 732, h = 89.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/rank_me.png",
      name = "self_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507, 138.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 535.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/tank_tip.png",
      name = "ImageView_35220",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(506, 481.25)
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
      parent = "bg",
      name = "layer_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(504, 523.75)
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
      name = "label_empty",
      z = 0,
      parent = "img_empty",
      text = T("\230\154\130\230\151\160\228\184\138\230\166\156"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 3.25)
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
      name = "label_rank",
      z = 0,
      parent = "self_bg",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 44.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_bg",
      res = "UI/alpha/1080P/toparena/rank/rank_1st.png",
      name = "image_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "self_bg",
      name = "root_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(236.5, 20.25)
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
      name = "label_name",
      z = 0,
      parent = "self_bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(302.5, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild",
      z = 0,
      parent = "self_bg",
      text = T("\229\190\183\233\178\129\228\188\138\233\152\181\229\174\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(302.5, 30.75)
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
      name = "label_damage",
      z = 0,
      parent = "self_bg",
      text = T("\230\128\187\228\188\164\229\174\179:"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(571.5, 44.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 238, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_value",
      z = 0,
      parent = "self_bg",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(576.5, 44.75)
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
      parent = "self_bg",
      name = "layer_damage_value",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(576.5, 44.75)
    }
  }
}
