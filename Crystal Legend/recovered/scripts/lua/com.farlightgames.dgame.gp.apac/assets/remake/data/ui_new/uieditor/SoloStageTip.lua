ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloStageTip = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 540)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/loser_bg.png",
      name = "img_round_start_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -111.5)
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
      name = "label_gain_title",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\232\142\183\229\190\151\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(211.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_round_start_bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12173",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gain_gold",
      z = 0,
      parent = "img_round_start_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(417.25, 21)
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
      name = "label_award_title",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\229\136\169\230\129\175\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/loser_bg.png",
      name = "img_battle_start_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9.5, -111.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_round_start_bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12174",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_gold",
      z = 0,
      parent = "img_round_start_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(266.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 128.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/time_bg.png",
      name = "img_prepare_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -24)
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
      name = "label_failed",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\232\191\158\232\131\156\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(524.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_round_start_bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12175",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(558.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/loser_bg.png",
      name = "img_battle_lose_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9.5, -111.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_failed_gold",
      z = 0,
      parent = "img_round_start_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(575.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 120, 78),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5395",
      z = 0,
      parent = "img_round_start_bg",
      text = T("\229\155\158\229\144\136\229\188\128\229\167\139"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 54)
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
      name = "Label_5394",
      z = 0,
      parent = "img_battle_start_bg",
      text = T("\230\136\152\230\150\151\229\188\128\229\167\139"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 464, h = 48},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/start_bg.png",
      name = "img_wait_info_bg",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9.5, -111.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/winer_bg.png",
      name = "img_battle_victory_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9.5, -111.5)
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
      name = "label_timer",
      z = 10,
      parent = "img_prepare_bg",
      text = "12",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.25, 27.25)
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
      name = "label_stage",
      z = 10,
      parent = "img_prepare_bg",
      text = T("\229\135\134\229\164\135\233\152\182\230\174\181"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 109, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_prepare_bg",
      res = "UI/alpha/1080P/chesscard/time_bg_1.png",
      name = "bg_time_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.25, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(74, 117, 204),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5392",
      z = 0,
      parent = "img_battle_lose_bg",
      text = T("\230\136\152\230\150\151\229\164\177\232\180\165"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 39)
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
      name = "label_wait_title",
      z = 0,
      parent = "img_wait_info_bg",
      text = T("\231\173\137\229\190\133\229\133\182\228\187\150\231\142\169\229\174\182\231\187\147\230\157\159\230\136\152\230\150\151"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_time_bar",
      res = "UI/alpha/1080P/chesscard/time_bg_2.png",
      name = "time_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 120, 78),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5393",
      z = 0,
      parent = "img_battle_victory_bg",
      text = T("\230\136\152\230\150\151\232\131\156\229\136\169"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 78},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/loser_bg.png",
      name = "img_battle_addspeed",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-9.5, -111.5)
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
      name = "Label_5394",
      z = 0,
      parent = "img_battle_addspeed",
      text = T("\230\136\152\230\150\151\229\183\178\232\182\133\232\191\13520\231\167\146\239\188\140\230\136\152\230\150\151\229\138\160\233\128\159\228\184\173..."),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 39)
    }
  }
}
