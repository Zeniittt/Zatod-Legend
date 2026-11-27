ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 680, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/listnormal.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 0,
      parent = "bg",
      text = T("\230\136\145\231\154\132\229\165\150\229\138\177"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(34.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 70)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "root_icon_new",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(214.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/rank/rank_1st.png",
      name = "image_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/reward/zone_1.png",
      name = "Image_zone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 694, h = 93},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/rewardme.png",
      name = "bg_select",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(343, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 113, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/reward_wordbg.png",
      name = "image_rewardme",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(591, 38)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage",
      z = 0,
      parent = "image_rewardme",
      text = T("\230\136\145\231\154\132\229\165\150\229\138\177"),
      size = 20
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(92.5, 31)
    }
  }
}
