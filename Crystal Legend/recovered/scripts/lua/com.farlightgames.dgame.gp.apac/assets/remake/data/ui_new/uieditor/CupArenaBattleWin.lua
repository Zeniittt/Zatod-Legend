ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaBattleWin = {
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_jump",
      z = 0,
      capInsets = CCRectMake(11.72, 11.72, 51.56, 25.78),
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 99.5)
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
      name = "Label_2923",
      z = 0,
      parent = "btn_jump",
      text = T("\232\183\179\232\191\135\230\136\152\230\150\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 39.5, h = 39.5},
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
      normal = "UI/alpha/1080P/common/btn_back.png",
      name = "btn_close",
      z = 6,
      text = "",
      press = "UI/alpha/1080P/common/btn_back.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(908.5, 472.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(39, 39)
    },
    t = "Layer",
    base = {
      name = "node_effect_impact",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(39, 39)
    },
    t = "Layer",
    base = {
      name = "node_effect_battle",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {name = "image_bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 249)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 353.5, h = 50},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/cuparena_battle_5.png",
      name = "bg_result_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481.5, 393)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 311, h = 31.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_info_bg2.png",
      name = "node_self_head",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-264.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 349.5, h = 31.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_info_bg1.png",
      name = "node_oppo_head",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(276, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(460, 85.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_self_hero",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-508, -94.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(460, 85.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_oppo_hero",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, -94.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 605.5, h = 220.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_bg_player.png",
      name = "bg_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-282.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_5_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.75, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 619, h = 220.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_bg_enemy.png",
      name = "bg_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_5_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178.25, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_5_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.75, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_5_1",
      z = 0,
      parent = "bg_result_5",
      text = T("\231\172\172\228\184\128\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.75, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_5_2",
      z = 0,
      parent = "bg_result_5",
      text = T("\231\172\172\228\186\140\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.75, 25)
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
      name = "label_name1",
      z = 1,
      parent = "node_self_head",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 21
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(280.5, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_5_3",
      z = 0,
      parent = "bg_result_5",
      text = T("\231\172\172\228\184\137\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177.75, 25)
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
      name = "label_name2",
      z = 0,
      parent = "node_oppo_head",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33.25, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_5_1",
      z = 0,
      parent = "result_5_1",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_5_3",
      z = 0,
      parent = "result_5_3",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_5_2",
      z = 0,
      parent = "result_5_2",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 504.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/cuparena_battle_7.png",
      name = "bg_result_7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481.5, 393)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_5_4",
      z = 0,
      parent = "bg_result_5",
      text = T("\231\172\172\229\155\155\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(253.25, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_5_5",
      z = 0,
      parent = "bg_result_5",
      text = T("\231\172\172\228\186\148\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327.75, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_5_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(253.25, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_5",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_5_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327.75, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_7",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_7_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_7",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_7_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.25, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_7",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_7_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177.75, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_7",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_7_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(252.75, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_7",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_7_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327.25, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_7_2",
      z = 0,
      parent = "bg_result_7",
      text = T("\231\172\172\228\186\140\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_7_3",
      z = 0,
      parent = "bg_result_7",
      text = T("\231\172\172\228\184\137\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_7_4",
      z = 0,
      parent = "bg_result_7",
      text = T("\231\172\172\229\155\155\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(252.75, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_7_5",
      z = 0,
      parent = "bg_result_7",
      text = T("\231\172\172\228\186\148\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(327.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_7_6",
      z = 0,
      parent = "bg_result_7",
      text = T("\231\172\172\229\133\173\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(403.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_7_7",
      z = 0,
      parent = "bg_result_7",
      text = T("\231\172\172\228\184\131\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_7",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_7_6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(403.75, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_result_7",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose.png",
      name = "result_7_7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.75, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(155, 106, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round_7_1",
      z = 0,
      parent = "bg_result_7",
      text = T("\231\172\172\228\184\128\229\156\186"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, 26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_5_4",
      z = 0,
      parent = "result_5_4",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_5_5",
      z = 0,
      parent = "result_5_5",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_7_1",
      z = 0,
      parent = "result_7_1",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_7_2",
      z = 0,
      parent = "result_7_2",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_7_3",
      z = 0,
      parent = "result_7_3",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_7_4",
      z = 0,
      parent = "result_7_4",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_7_5",
      z = 0,
      parent = "result_7_5",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_7_6",
      z = 0,
      parent = "result_7_6",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 216, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_7_7",
      z = 0,
      parent = "result_7_7",
      text = T("\232\180\159"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 29.5)
    }
  }
}
