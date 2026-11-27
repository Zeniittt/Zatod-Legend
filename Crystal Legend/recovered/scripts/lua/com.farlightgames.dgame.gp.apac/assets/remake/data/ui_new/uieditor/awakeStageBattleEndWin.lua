ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeStageBattleEndWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 356},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battleresult/victory_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481, 241)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 528, h = 95},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/new_resource/victory_bg.png",
      name = "bg_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482, 380)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 193, h = 59},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/battleresult/battleEx.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_data",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(888.5, 372)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 867.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/splitline.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 184.5)
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
      parent = "btn_data",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
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
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 124.5, h = 50.5},
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
      name = "btn_back",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(852, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(633.5, 95)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(110.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 407.5, h = 119},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/victory_light.png",
      name = "light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(486.5, 418)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "curtime1",
      z = 0,
      parent = "bg",
      text = T("\230\156\172\230\172\161\229\135\187\232\180\165\232\191\155\229\186\166:"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(479, 304.5)
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
      name = "label_back",
      z = 0,
      parent = "btn_back",
      text = T("\233\128\128\229\135\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(87, 236, 80),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "historytime2",
      z = 0,
      parent = "bg",
      text = "",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(511, 268)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "historytime1",
      z = 0,
      parent = "bg",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\229\135\187\232\180\165\232\191\155\229\186\166:"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(479.5, 268)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 0,
      parent = "layer_reward",
      text = T("\229\165\150\229\138\177\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-32.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(87, 236, 80),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "curtime2",
      z = 0,
      parent = "bg",
      text = "",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(511, 304.5)
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
      name = "nextreward1",
      z = 0,
      parent = "bg",
      text = T("\228\184\139\228\184\128\229\165\150\229\138\177\230\137\128\233\156\128\232\191\155\229\186\166:"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(479.5, 230)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 152, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "nextreward2",
      z = 0,
      parent = "bg",
      text = "",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(511, 230)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(160, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "best_in_self",
      z = 0,
      parent = "bg",
      text = T("\230\150\176\231\186\170\229\189\149\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(576.5, 305.5)
    }
  }
}
