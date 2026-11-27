ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 679.5, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guildmount/rank/first_floor.png",
      name = "bg",
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
      scaleSize = CCSizeMake(150, 27.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_rank",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(33, 27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(270, 65)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "reward_panel",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(267.5, 7)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(694, 93)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_my_rank",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg01.png",
      capInsets = CCRectMake(20, 20, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(339.5, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_normal",
      z = 0,
      parent = "bg",
      text = "1000-1555",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(76.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zone_des",
      z = 0,
      parent = "bg",
      text = T("\232\181\155\229\140\186"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33.5, 40.5)
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
      parent = "image_my_rank",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg02.png",
      name = "my_grade_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(618.5, 47.5)
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
      parent = "image_my_rank",
      text = T("\230\136\145\231\154\132\230\142\146\229\144\141"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(618.5, 47.5)
    }
  }
}
