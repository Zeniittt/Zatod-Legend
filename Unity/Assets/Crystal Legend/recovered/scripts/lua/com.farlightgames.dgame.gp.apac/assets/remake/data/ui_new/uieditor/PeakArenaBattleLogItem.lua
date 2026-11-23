ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaBattleLogItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(768, 85)
    },
    t = "Layer",
    base = {
      name = "panel_container",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 705.5, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_container",
      res = "UI/alpha/1080P/toparena/toparena_record_lose_bg.png",
      name = "image_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(58, 1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(372, 80)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_summary",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(174.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {
      parent = "layer_summary",
      name = "layer_head",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 229, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_summary",
      res = "UI/alpha/1080P/friend/friend_name_bg.png",
      name = "image_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115.5, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_a_butt.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(625, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 39),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server",
      z = 0,
      parent = "layer_summary",
      text = T("3\229\140\186\229\183\168\233\190\153\229\174\136\230\138\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81.5, 19.5)
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
      parent = "image_name_bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 39),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_date",
      z = 0,
      parent = "layer_summary",
      text = T("\228\184\128\229\145\168\229\137\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(304.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83, h = 84},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_container",
      res = "UI/alpha/1080P/toparena/toparena_record_lose.png",
      name = "image_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_score_icon2.png",
      name = "image_score_text",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 231, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_261",
      z = 0,
      parent = "btn_detail",
      text = T("\232\175\166 \230\131\133"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.75, 25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 35)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(20.5, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_container",
      res = "UI/alpha/1080P/toparena/toparena_record_defend.png",
      name = "image_defend",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_score_icon3.png",
      name = "image_evolve",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.199999208, h = 16.799998992},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_score",
      res = "UI/alpha/1080P/pvp/arrow_down.png",
      name = "image_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 97, 66),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_change",
      z = 0,
      parent = "panel_score",
      text = "123",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(96.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 240, 213),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_defend",
      z = 0,
      parent = "image_defend",
      text = T("\233\152\178"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(210, 223, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_text",
      z = 0,
      parent = "image_score_text",
      text = T("\231\167\175\229\136\134"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/toparena_fail_protect_bg.png",
      name = "image_protect",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 221),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_evolve",
      z = 0,
      parent = "image_evolve",
      text = T("\230\153\139\231\186\167\232\181\155"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_protect",
      z = 0,
      parent = "image_protect",
      text = T("\229\164\177\232\180\165\228\191\157\230\138\164"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 13.25)
    }
  }
}
