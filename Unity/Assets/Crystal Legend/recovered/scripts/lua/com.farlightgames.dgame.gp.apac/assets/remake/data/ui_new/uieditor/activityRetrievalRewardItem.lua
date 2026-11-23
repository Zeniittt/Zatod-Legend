ed.uieditor = ed.uieditor or {}
ed.uieditor.activityRetrievalRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 547.5, h = 106.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/retrievalreward/reward_bg.png",
      name = "image_bg",
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
      scaleSize = CCSizeMake(160.5, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/retrievalreward/title_bg.png",
      capInsets = CCRectMake(53.5, 10.5, 53.5, 10.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(35, 105)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(317, 65)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(38.5, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/retrievalreward/button_1.png",
      name = "btn_buy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(448.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/retrievalreward/button_1_off.png",
      name = "btn_finish",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(448.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 220, 249),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "title_bg",
      text = T("\230\137\190\229\155\158\230\175\143\230\151\165\229\174\157\231\174\177"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.2, h = 25.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buy",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "image_cost",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost",
      z = 0,
      parent = "btn_buy",
      text = "220",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(39, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buy",
      z = 0,
      parent = "btn_buy",
      text = T("\230\137\190\229\155\158"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(76.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buy",
      res = "UI/alpha/1080P/retrievalreward/discount.png",
      name = "image_discount",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129.5, 56.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(53, 34, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_finish",
      z = 0,
      parent = "btn_finish",
      text = T("\229\183\178\230\137\190\229\155\158"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 27.5)
    }
  },
  {
    config = {
      rotation = -15,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 46, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_discount",
      z = 0,
      parent = "image_discount",
      text = "-40",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, 23.75)
    }
  },
  {
    config = {
      rotation = -15,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 46, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_discount_percent",
      z = 0,
      parent = "image_discount",
      text = "%",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 27.75)
    }
  }
}
