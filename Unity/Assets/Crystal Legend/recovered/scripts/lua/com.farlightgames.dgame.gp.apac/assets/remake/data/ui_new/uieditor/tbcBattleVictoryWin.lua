ed.uieditor = ed.uieditor or {}
ed.uieditor.tbcBattleVictoryWin = {
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
      position = ccp(480, 245)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 326.2500261, h = 71.2500057},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summon/get_new_hero_bar.png",
      name = "bg_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 357)
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
      position = ccp(894, 373.5)
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
      name = "label_playerlevel",
      z = 0,
      parent = "bg",
      text = T("\230\136\152\233\152\159\231\173\137\231\186\167   Lv.30"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(273, 280)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(310, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_exp_bar",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/progressbar_bg.png",
      capInsets = CCRectMake(5, 4.5, 5, 4.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(275, 252)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(67.5, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar1",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/heroexp_bg.png",
      capInsets = CCRectMake(2.5, 3.5, 2.5, 3.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(275, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(67.5, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar2",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/heroexp_bg.png",
      capInsets = CCRectMake(2.5, 3.5, 2.5, 3.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(363.5, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(67.5, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar3",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/heroexp_bg.png",
      capInsets = CCRectMake(2.5, 3.5, 2.5, 3.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(450, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(67.5, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar4",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/heroexp_bg.png",
      capInsets = CCRectMake(2.5, 3.5, 2.5, 3.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(537, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(67.5, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar5",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/battleresult/heroexp_bg.png",
      capInsets = CCRectMake(2.5, 3.5, 2.5, 3.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(624, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_back",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(864, 53)
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
      parent = "bg",
      text = T("\229\165\150\229\138\177:"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 59)
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
      position = ccp(117.5, 10.5)
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
      position = ccp(480, 344)
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
      name = "Label_7831",
      z = 0,
      parent = "bg",
      text = T("\229\183\178\232\167\163\233\148\129\230\156\172\229\133\179\229\141\161\230\137\171\232\141\161"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 320.5)
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
      name = "btn_share",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(835, 373.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.49998925, h = 35.09999415},
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
      position = ccp(108.75, 29.25)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(308, 10)
    },
    t = "Scale9Sprite",
    base = {
      name = "exp_bar",
      z = 0,
      parent = "bg_exp_bar",
      res = "UI/alpha/1080P/battleresult/team_expbar.png",
      capInsets = CCRectMake(1.5, 3.5, 390, 3.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(1, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_exp_bar",
      res = "UI/alpha/1080P/battleresult/exp.png",
      name = "exp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(363, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 245, 64),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp",
      z = 0,
      parent = "bg_exp_bar",
      text = "+30",
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(417.5, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65.5, 9)
    },
    t = "Scale9Sprite",
    base = {
      name = "bar1",
      z = 0,
      parent = "bg_bar1",
      res = "UI/alpha/1080P/battleresult/expbar.png",
      capInsets = CCRectMake(1.5, 2.5, 72, 3)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar1",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 47.5)
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
      name = "exp1",
      z = 0,
      parent = "bg_bar1",
      text = "EXP+30",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, -9.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65.5, 9)
    },
    t = "Scale9Sprite",
    base = {
      name = "bar2",
      z = 0,
      parent = "bg_bar2",
      res = "UI/alpha/1080P/battleresult/expbar.png",
      capInsets = CCRectMake(1.5, 2.5, 72, 3)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0.5, 5.5)
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
      name = "exp2",
      z = 0,
      parent = "bg_bar2",
      text = "EXP+30",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, -9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar2",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65.5, 9)
    },
    t = "Scale9Sprite",
    base = {
      name = "bar3",
      z = 0,
      parent = "bg_bar3",
      res = "UI/alpha/1080P/battleresult/expbar.png",
      capInsets = CCRectMake(1.5, 2.5, 72, 3)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 5.5)
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
      name = "exp3",
      z = 0,
      parent = "bg_bar3",
      text = "EXP+30",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, -9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar3",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65.5, 8)
    },
    t = "Scale9Sprite",
    base = {
      name = "bar4",
      z = 0,
      parent = "bg_bar4",
      res = "UI/alpha/1080P/battleresult/expbar.png",
      capInsets = CCRectMake(1.5, 2.5, 72, 3)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 5.5)
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
      name = "exp4",
      z = 0,
      parent = "bg_bar4",
      text = "EXP+30",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, -9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar4",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65.5, 8)
    },
    t = "Scale9Sprite",
    base = {
      name = "bar5",
      z = 0,
      parent = "bg_bar5",
      res = "UI/alpha/1080P/battleresult/expbar.png",
      capInsets = CCRectMake(1.5, 2.5, 72, 3)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 5.5)
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
      name = "exp5",
      z = 0,
      parent = "bg_bar5",
      text = "EXP+30",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, -9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar5",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 47.5)
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
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 20)
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
      parent = "btn_share",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "share",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}
