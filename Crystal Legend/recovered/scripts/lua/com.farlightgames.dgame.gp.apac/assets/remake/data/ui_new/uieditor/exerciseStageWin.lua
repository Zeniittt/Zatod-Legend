ed.uieditor = ed.uieditor or {}
ed.uieditor.exerciseStageWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(750, 417.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 190, 9.5, 11),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 265)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.5, 400)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/mail/mail_lin.png",
      capInsets = CCRectMake(3.5, 0, 0.5, 100)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177.5, 212.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(174, 395)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "stageListLayer",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(43, 44),
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
      capInsets = CCRectMake(10, 20, 30, 15),
      name = "close_btn",
      z = 3,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(737.5, 405.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_frame_1.png",
      name = "lefttop",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 405.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 50, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_frame_1.png",
      name = "leftbottom",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 19.75)
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
      parent = "close_btn",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "xy",
      opacity = 255,
      fix_wh = {w = 50, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_frame_1.png",
      name = "rightbottom",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(737.5, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 213, 141),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "degree_label",
      z = 0,
      parent = "bg",
      text = T(" \194\183 \233\154\190\229\186\16610"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(305.5, 388.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.6, h = 33.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/campaign/main/campaign_stage_star_2.png",
      name = "star_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(405, 393.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.6, h = 33.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/campaign/main/campaign_stage_star_2.png",
      name = "star_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(437.5, 393.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.6, h = 33.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/campaign/main/campaign_stage_star_2.png",
      name = "star_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470, 393.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "boss",
      z = 0,
      parent = "bg",
      text = T("\233\166\150\233\162\134\228\187\139\231\187\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(384, 326.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "skill1",
      z = 0,
      parent = "bg",
      text = T("\231\139\130\231\131\173\228\185\139\232\161\128"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(384, 306.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "skill2",
      z = 0,
      parent = "bg",
      text = T("\229\164\169\228\187\187\230\150\175\228\186\186"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(384, 248.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "enemy_label",
      z = 0,
      parent = "bg",
      text = T("\230\149\140\230\150\185\233\152\181\229\174\185\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(191, 173.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "reward_label",
      z = 0,
      parent = "bg",
      text = T("\229\143\175\232\142\183\229\190\151\229\165\150\229\138\177\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(191, 122.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 55)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "enemyLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(280, 148.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 40)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "rewardLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(280, 101.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 541.5, h = 3.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_line.png",
      name = "pool_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 96.25)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "sweep_label",
      z = 0,
      parent = "bg",
      text = T("\230\137\171\232\141\161\229\136\184\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(191, 79.75)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "sweep_num",
      z = 0,
      parent = "bg",
      text = "999",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(247, 79.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/raidticke.png",
      name = "sweep_image",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(271, 79.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "sweep_ten_btn",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(240, 42.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "sweep_btn",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348.5, 42.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(69, 70),
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(15, 15, 65, 12),
      name = "battle_btn",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(697, 53.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(182.5, 150)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "bossLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(190, 180.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 37.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "skill_desc_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(385, 258.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 35)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "skill_desc_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(385, 203.75)
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
      name = "sweep_ten",
      z = 0,
      parent = "sweep_ten_btn",
      text = T("\228\184\128\233\148\174\230\137\171\232\141\161"),
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
      name = "sweep",
      z = 0,
      parent = "sweep_btn",
      text = T("\230\137\171\232\141\161"),
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
      name = "battle_label",
      z = 0,
      parent = "battle_btn",
      text = T("\230\140\145\230\136\152"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 20)
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
      parent = "battle_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "battle_image",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 45)
    }
  }
}
