ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessResultPanel = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 990.5, h = 400},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/result/bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 287)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 828, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/result/1_bg.png",
      name = "img_player_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494.75, 304.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.8, h = 57.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_1",
      res = "UI/alpha/1080P/chess/result/1.png",
      name = "img_rank_title_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(124, 50.5),
      flip = "",
      labelConfig = {
        color = ccc3(255, 212, 124)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 81.5, 20),
      name = "btn_leave",
      z = 0,
      parent = "bg",
      text = T("\231\166\187 \229\188\128"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495.25, -44.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_1",
      z = 0,
      parent = "img_player_bg_1",
      text = "10",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd_1",
      z = 0,
      parent = "img_player_bg_1",
      text = "0-0",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 31.25)
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
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/battleEx.png",
      name = "icon_result",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(496.75, 375)
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
      parent = "img_player_bg_1",
      name = "node_hero_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(326.5, 40.75)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_leave_tip",
      z = 0,
      parent = "btn_leave",
      text = T("5s\229\144\142\232\191\148\229\155\158\228\184\187\231\149\140\233\157\162"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 59.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_1",
      z = 0,
      parent = "img_player_bg_1",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151\228\184\131"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(181.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 828, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/result/2_bg.png",
      name = "img_player_bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495.25, 219)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score1_1",
      z = 0,
      parent = "img_player_bg_1",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 828, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/result/3_bg.png",
      name = "img_player_bg_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495.25, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd1_1",
      z = 0,
      parent = "img_player_bg_1",
      text = T("\232\131\156\232\180\159\230\175\148"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 828, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/result/4_bg.png",
      name = "img_player_bg_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495.25, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_player_bg_2",
      name = "node_head_2",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(138, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_2",
      z = 0,
      parent = "img_player_bg_2",
      text = "10",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd_2",
      z = 0,
      parent = "img_player_bg_2",
      text = "0-0",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_player_bg_2",
      name = "node_hero_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(326.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_player_bg_3",
      name = "node_head_3",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(138, 40.75)
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
      name = "label_name_2",
      z = 0,
      parent = "img_player_bg_2",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(181.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_3",
      z = 0,
      parent = "img_player_bg_3",
      text = "10",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 45.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_2",
      res = "UI/alpha/1080P/chess/result/2.png",
      name = "img_rank_title_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd_3",
      z = 0,
      parent = "img_player_bg_3",
      text = "0-0",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score1_2",
      z = 0,
      parent = "img_player_bg_2",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_player_bg_3",
      name = "node_hero_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(326.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd1_2",
      z = 0,
      parent = "img_player_bg_2",
      text = T("\232\131\156\232\180\159\230\175\148"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_player_bg_4",
      name = "node_head_4",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(138, 40.75)
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
      name = "label_name_3",
      z = 0,
      parent = "img_player_bg_3",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(181.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_4",
      z = 0,
      parent = "img_player_bg_4",
      text = "10",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.8, h = 45.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_3",
      res = "UI/alpha/1080P/chess/result/3.png",
      name = "img_rank_title_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd_4",
      z = 0,
      parent = "img_player_bg_4",
      text = "0-0",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score1_3",
      z = 0,
      parent = "img_player_bg_3",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_player_bg_4",
      name = "node_hero_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(326.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd1_3",
      z = 0,
      parent = "img_player_bg_3",
      text = T("\232\131\156\232\180\159\230\175\148"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 56.75)
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
      name = "label_name_4",
      z = 0,
      parent = "img_player_bg_4",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(181.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 46.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_4",
      res = "UI/alpha/1080P/chess/result/4.png",
      name = "img_rank_title_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score1_4",
      z = 0,
      parent = "img_player_bg_4",
      text = T("\231\167\175\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_vd1_4",
      z = 0,
      parent = "img_player_bg_4",
      text = T("\232\131\156\232\180\159\230\175\148"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.66, x = 0.66},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.16, h = 39.6},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_1",
      res = "UI/alpha/1080P/chess/heropower/frame_1.png",
      name = "img_xxx_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(661.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_player_bg_1",
      name = "node_head_1",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(139.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.66, x = 0.66},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.16, h = 39.6},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_2",
      res = "UI/alpha/1080P/chess/heropower/frame_1.png",
      name = "img_xxx_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(661.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.66, x = 0.66},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.16, h = 39.6},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_3",
      res = "UI/alpha/1080P/chess/heropower/frame_1.png",
      name = "img_xxx_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(661.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.66, x = 0.66},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.16, h = 39.6},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_player_bg_4",
      res = "UI/alpha/1080P/chess/heropower/frame_1.png",
      name = "img_xxx_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(661.5, 40.75)
    }
  }
}
