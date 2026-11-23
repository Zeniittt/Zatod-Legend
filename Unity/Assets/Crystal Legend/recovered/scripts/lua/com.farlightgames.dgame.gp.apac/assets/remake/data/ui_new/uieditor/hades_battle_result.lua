ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_battle_result = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 371)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(320, 118.5, 320, 118.5),
      res = "UI/alpha/1080P/battleresult/victory_bg.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 245)
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
      position = ccp(480, 100)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 54, h = 55},
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
      name = "btn_data",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(890, 389.5)
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
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_data",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
      name = "data",
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
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_back",
      z = 0,
      parent = "btn_back",
      text = T("\233\128\128\229\135\186"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 774.5, h = 144.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hades/hades_result_victory.png",
      name = "image_result_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 366)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "label_1",
      z = 0,
      parent = "bg",
      text = T("\232\190\190\230\136\144\229\165\145\231\186\166\230\157\161\228\187\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 335)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(566, 220)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(249.5, 102)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 521, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hades/hades_result_bg.png",
      name = "image_victory_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(510.5, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 484.5, h = 68.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hades/hades_result_lose_bg.png",
      name = "image_fail_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(510.5, 52)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_tips",
      z = 0,
      parent = "bg",
      text = T("\229\176\154\230\156\170\231\173\190\232\174\162\229\165\145\231\186\166\230\157\161\228\187\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 225)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "label_2",
      z = 0,
      parent = "image_victory_tips",
      text = T("\230\156\172\230\172\161\231\131\173\229\138\155\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-52.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_victory_tips",
      res = "UI/alpha/1080P/hades/hades_hot.png",
      name = "image_heat_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_heat",
      z = 0,
      parent = "image_victory_tips",
      text = "1234",
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 85),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_battle_time",
      z = 0,
      parent = "image_victory_tips",
      text = T("\230\156\172\230\172\161\233\128\154\229\133\179\232\128\151\230\151\182  00\239\188\15430\239\188\15424"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(263, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(227, 237, 246),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_fail_tips",
      z = 0,
      parent = "image_fail_tips",
      text = T("\230\136\152\230\150\151\229\164\177\232\180\165\239\188\140\230\130\168\229\143\175\230\160\185\230\141\174\232\135\170\232\186\171\229\174\158\229\138\155\231\129\181\230\180\187\233\133\141\231\189\174\229\165\145\231\186\166"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.25, 33.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 61},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_result_title",
      res = "UI/alpha/1080P/hades/hades_result_victory_1.png",
      name = "image_victory",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(389.75, 87.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 56.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_result_title",
      res = "UI/alpha/1080P/hades/hades_result_lose_1.png",
      name = "image_fail",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(389.75, 92.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 196, h = 147.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_result_title",
      res = "UI/alpha/1080P/nianmonster/nian_result_win_head.png",
      name = "image_title_heat",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(387.25, 113.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 223),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_victory_result",
      z = 0,
      parent = "image_victory",
      text = T("\232\131\156\229\136\169"),
      size = 41
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(227, 237, 246),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_fail_result",
      z = 0,
      parent = "image_fail",
      text = T("\229\164\177\232\180\165"),
      size = 41
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.25, 27.25)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "label_record_breaking",
      z = 0,
      parent = "image_victory_tips",
      text = T("\230\150\176\232\174\176\229\189\149!"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176.5, 21)
    }
  }
}
