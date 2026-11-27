ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerExVictoryWin = {
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
      fix_wh = {w = 107.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/battleresult/victory.png",
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
      position = ccp(479, 99.5)
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
      position = ccp(852.5, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 80)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(110.5, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 407.5, h = 119},
      visible = false
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
      position = ccp(478, 426.5)
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
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_again",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(713.5, 41.5)
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
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "curtime1",
      z = 0,
      parent = "bg",
      text = T("\230\156\172\230\172\161\233\128\154\229\133\179\232\128\151\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(462, 286.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
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
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(479, 255)
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
      position = ccp(-32.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "historytime1",
      z = 0,
      parent = "bg",
      text = T("\229\142\134\229\143\178\230\156\128\229\191\171"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(462, 255.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
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
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(479.5, 286)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 636, h = 114.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_result_record_1.png",
      name = "best_in_server",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 170)
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
      name = "label_again",
      z = 0,
      parent = "btn_again",
      text = T("\229\134\141\230\172\161\230\140\145\230\136\152"),
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 585, h = 111.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_result_infobg.png",
      name = "bg_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488.5, 156.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "besttime1",
      z = 0,
      parent = "bg_head",
      text = T("\230\156\172\230\156\141\230\156\128\229\191\171\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(266, 93.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "besttime2",
      z = 0,
      parent = "bg_head",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(282.5, 93.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.09999065, h = 56.3999906},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_head",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "icon_head",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(189.5, 47.75)
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
      name = "guildname",
      z = 0,
      parent = "bg_head",
      text = T("\228\188\151\231\165\158\228\185\139\229\183\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(223.5, 31.25)
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
      name = "label_name",
      z = 0,
      parent = "bg_head",
      text = T("\231\165\158\231\167\152\228\186\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(223.5, 55.75)
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
      text = T("\230\150\176\232\174\176\229\189\149\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(618.5, 286)
    }
  }
}
