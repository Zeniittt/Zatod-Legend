ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendBattleResultWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 403.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(19.5, 18, 0.5, 0.5),
      res = "UI/alpha/1080P/battleresult/victory_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 246)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(692.5, 290)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_record",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(130, 1.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/battle_close.png",
      name = "btn_close",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(881, 437.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 875.5, h = 361.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/end_bg.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(492, 401.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_title",
      z = 1,
      parent = "bg",
      text = T("\230\156\172\230\172\161\230\128\187\228\188\164\229\174\179\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(303, 319.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zonerank_title",
      z = 1,
      parent = "bg",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(634.5, 340.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zonerank_value",
      z = 1,
      parent = "bg",
      text = T("\232\181\155\229\140\186\230\142\146\229\144\141\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(302.5, 342.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_title_value",
      z = 1,
      parent = "bg",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(636.5, 320.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damagerank",
      z = 1,
      parent = "bg",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(472.5, 365.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_high_score",
      z = 1,
      parent = "bg",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\230\128\187\228\188\164\229\174\179\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(302, 296.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_high_scorevalue",
      z = 1,
      parent = "bg",
      text = "",
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(641, 297.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(133, 122, 103),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_des",
      z = 1,
      parent = "bg",
      text = T("\230\156\172\233\152\159\230\156\128\233\171\152\228\188\164\229\174\179\229\143\150\232\135\170\227\128\144\229\142\134\229\143\178\230\156\128\233\171\152\228\188\164\229\174\179\227\128\145\228\184\173\231\154\132\230\156\172\233\152\159\228\188\164\229\174\179,\229\143\175\229\137\141\229\190\128\227\128\144\232\174\176\229\189\149\227\128\145\228\184\173\230\159\165\231\156\139\232\175\166\230\131\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484, -17.25)
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
      name = "layer_damagerank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(472.5, 365.75)
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
      name = "layer_damage_title_value",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(636.5, 320.25)
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
      name = "layer_zonerank_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(634.5, 340.75)
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
      z = 2,
      parent = "bg_title",
      text = "",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.25, 182.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 149, h = 63.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/crevicedefend/battle_result_bg.png",
      name = "image_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420.75, 182.25)
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
      parent = "bg_title",
      name = "fcaNode",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(422.75, 170.75)
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
      parent = "bg_title",
      name = "layer_title",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(423.25, 182.75)
    }
  }
}
