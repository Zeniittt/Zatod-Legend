ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/reward/reward_bg1.png",
      name = "image_upgrade_bg",
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
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.99999352, h = 49.999997},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_upgrade_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_5.png",
      name = "image_upgrade_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.65, x = 0.65},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.05, h = 79.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_upgrade_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rank_icon_2.png",
      name = "image_upgrade_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/reward/reward_bg1.png",
      name = "image_grade_bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(215, 75)
    },
    t = "Layer",
    base = {
      parent = "image_upgrade_bg",
      name = "upgrade_reward_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(444, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 142),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_upgrade_text",
      z = 0,
      parent = "image_upgrade_bg",
      text = T("\231\167\175\229\136\134:"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(224.5, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/reward/reward_bg1.png",
      name = "image_rank_bg",
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
      fix_wh = {w = 741.5, h = 93.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_upgrade_bg",
      res = "UI/alpha/1080P/toparena/reward/reward_highlight_frame.png",
      name = "image_upgrade_highlight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364.5, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.99999352, h = 49.999997},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_grade_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_2.png",
      name = "image_grade_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74.1999894, h = 43.3999938},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_upgrade_bg",
      res = "UI/alpha/1080P/toparena/reward/reward_achieve.png",
      name = "image_upgrade_achieve",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(681, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.65, x = 0.65},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.05, h = 79.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_grade_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rank_icon_2.png",
      name = "image_grade_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/reward/reward_bg1.png",
      name = "image_medal_bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(741.5, 93.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_grade_mygrade",
      z = 0,
      parent = "image_grade_bg",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg01.png",
      capInsets = CCRectMake(20, 20, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 75)
    },
    t = "Layer",
    base = {
      parent = "image_grade_bg",
      name = "grade_reward_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(295.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/reward/reward_bg1.png",
      name = "image_weekly_bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(741.5, 93.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_rank_myrank",
      z = 0,
      parent = "image_rank_bg",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg01.png",
      capInsets = CCRectMake(20, 20, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 55)
    },
    t = "Layer",
    base = {
      parent = "image_rank_bg",
      name = "panel_rank_ranking",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 12)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 75)
    },
    t = "Layer",
    base = {
      parent = "image_rank_bg",
      name = "rank_reward_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(295.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(186, 157, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_upgrade_achieve",
      z = 0,
      parent = "image_upgrade_achieve",
      text = T("\229\183\178\232\190\190\230\136\144"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 31)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_grade",
      z = 1,
      parent = "image_grade_mygrade",
      text = T("\230\136\145\231\154\132\230\174\181\228\189\141"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_grade_mygrade",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg02.png",
      name = "my_grade_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_medal_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_get_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rank_myrank",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg02.png",
      name = "my_rank_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_rank",
      z = 1,
      parent = "image_rank_myrank",
      text = T("\230\136\145\231\154\132\230\142\146\229\144\141"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_medal_bg",
      res = "UI/alpha/1080P/common/button_grey.png",
      name = "btn_uncomplete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647.5, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 62},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_medal_bg",
      res = "UI/alpha/1080P/toparena/reward/reward_achieve.png",
      name = "btn_complete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647, 41)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 40)
    },
    t = "Layer",
    base = {
      parent = "image_medal_bg",
      name = "panel_medal_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(11, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 128,
      fix_wh = {w = 728.5, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_medal_bg",
      res = "UI/alpha/1080P/toparena/reward/reward_bg2.png",
      name = "image_medal_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 55)
    },
    t = "Layer",
    base = {
      parent = "image_weekly_bg",
      name = "panel_weekly_ranking",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 12)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 75)
    },
    t = "Layer",
    base = {
      parent = "image_medal_bg",
      name = "medal_reward_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(295.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 75)
    },
    t = "Layer",
    base = {
      parent = "image_weekly_bg",
      name = "weekly_reward_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(295.5, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(741.5, 93.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_weekly_myrank",
      z = 0,
      parent = "image_weekly_bg",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg01.png",
      capInsets = CCRectMake(20, 20, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 230, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1225",
      z = 0,
      parent = "btn_get_reward",
      text = T("\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 224, 202),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1230",
      z = 0,
      parent = "btn_uncomplete",
      text = T("\230\156\170\232\190\190\230\136\144"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(186, 157, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_complete",
      z = 0,
      parent = "btn_complete",
      text = T("\229\183\178\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.3, x = 1.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 26.65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_medal_desc",
      res = "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1.png",
      name = "image_metal_token",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 243),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_medal_text",
      z = 0,
      parent = "panel_medal_desc",
      text = T("\231\180\175\231\167\175"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_weekly_myrank",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg02.png",
      name = "my_weekly_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_weekly",
      z = 1,
      parent = "image_weekly_myrank",
      text = T("\230\136\145\231\154\132\230\142\146\229\144\141"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665.75, 46.75)
    }
  }
}
