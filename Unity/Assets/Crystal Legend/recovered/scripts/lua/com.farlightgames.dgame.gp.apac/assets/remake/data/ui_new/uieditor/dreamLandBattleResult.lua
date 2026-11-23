ed.uieditor = ed.uieditor or {}
ed.uieditor.dreamLandBattleResult = {
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
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 237.5)
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
      name = "info_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 380.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 407.5, h = 136},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/new_resource/victory_bg_1.png",
      name = "light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(480, 343.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/damage_up.png",
      name = "title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 393.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(488.5, 69)
    },
    t = "Scale9Sprite",
    base = {
      name = "rank_first_bg",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/rank_bg.png",
      capInsets = CCRectMake(5, 5, 8, 5.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434, 287.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "award_title",
      z = 0,
      parent = "bg",
      text = T("\229\165\150\229\138\177\233\162\132\232\167\136\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(287.5, 216)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "award_mail",
      z = 0,
      parent = "bg",
      text = T("\239\188\136\231\187\147\231\174\151\229\144\142\233\130\174\228\187\182\229\143\145\230\148\190\239\188\137"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(287.5, 190.5)
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
      position = ccp(480, 157)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "rank_first_title",
      z = 0,
      parent = "rank_first_bg",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "damage_first_title",
      z = 0,
      parent = "rank_first_bg",
      text = T("\230\156\172\230\172\161\228\188\164\229\174\179\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(314, 75)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "lootLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(363.5, 168)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "milestone_title",
      z = 0,
      parent = "bg",
      text = T("\232\142\183\229\190\151\230\155\180\229\164\154\230\142\146\229\144\141\229\165\150\229\138\177\233\156\128\232\182\133\232\182\138"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(100, 135.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(433.5, 90)
    },
    t = "Scale9Sprite",
    base = {
      name = "milestone_rank_bg",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/dreamland_beyond_bg.png",
      capInsets = CCRectMake(5, 5, 5.5, 5.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(310, 66)
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
      position = ccp(890, 376.5)
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
      position = ccp(853.5, 44.5)
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
      name = "btn_share",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(707.5, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(488.5, 80)
    },
    t = "Scale9Sprite",
    base = {
      name = "rank_top_bg",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/rank_bg.png",
      capInsets = CCRectMake(5, 5, 8, 5.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434.5, 287.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73, h = 73},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "milestone_rank_bg",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "player_head",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.25, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 110},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "milestone_rank_bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "player_head_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.25, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 229.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "milestone_rank_bg",
      res = "UI/alpha/1080P/battleresult/name_bg.png",
      name = "name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(166.75, 73)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "milestone_rank_title",
      z = 0,
      parent = "milestone_rank_bg",
      text = T("\228\187\150\231\154\132\230\142\146\229\144\141\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.75, 45)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "milestone_damage_title",
      z = 0,
      parent = "milestone_rank_bg",
      text = T("\230\156\128\233\171\152\228\188\164\229\174\179\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.75, 19)
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
      name = "label_share",
      z = 0,
      parent = "btn_share",
      text = T("\229\136\134\228\186\171"),
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "rank_top_title",
      z = 0,
      parent = "rank_top_bg",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 66)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "damage_top_title",
      z = 0,
      parent = "rank_top_bg",
      text = T("\230\156\172\230\172\161\228\188\164\229\174\179\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 40)
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
      name = "my_milestone_damage_title",
      z = 0,
      parent = "rank_top_bg",
      text = T("\230\156\128\233\171\152\231\186\170\229\189\149\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "name_bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\230\152\175\229\133\171\228\184\170\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50.75, 15)
    }
  }
}
