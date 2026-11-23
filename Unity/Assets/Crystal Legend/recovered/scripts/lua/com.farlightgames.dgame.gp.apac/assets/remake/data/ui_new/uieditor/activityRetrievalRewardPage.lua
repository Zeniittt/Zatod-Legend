ed.uieditor = ed.uieditor or {}
ed.uieditor.activityRetrievalRewardPage = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/retrievalreward/bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(192, 169, 225),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_empty_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\154\130\230\151\160\229\143\175\230\137\190\229\155\158\231\154\132\229\165\150\229\138\177\229\147\166~"),
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(778.5, 354.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 300)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(495, 200)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 239.5, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/retrievalreward/button_2.png",
      name = "btn_buy_all",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(771.5, 144.5)
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
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\156\128\229\164\154\229\143\175\230\137\190\229\155\158\228\184\164\230\151\165\231\154\132\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(769.5, 191.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 239.5, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/retrievalreward/button_2_off.png",
      name = "btn_finish",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(771, 144.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(107, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "diamond_amount_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      capInsets = CCRectMake(16, 11.5, 16, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(972, 687.5)
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
      name = "label_all_cost",
      z = 0,
      parent = "btn_buy_all",
      text = "999",
      size = 23
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.75, 39.75)
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
      parent = "btn_buy_all",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "image_all_cost_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 40.25)
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
      name = "label_all",
      z = 0,
      parent = "btn_buy_all",
      text = T("\229\133\168\233\131\168\230\137\190\229\155\158"),
      size = 23
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(108.25, 39.75)
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
      parent = "btn_buy_all",
      res = "UI/alpha/1080P/retrievalreward/discount.png",
      name = "image_discount",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(226.25, 53.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 228, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_finish",
      z = 0,
      parent = "btn_finish",
      text = T("\229\183\178\229\133\168\230\137\190\229\155\158"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 41.75)
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
      name = "label_diamond_amount",
      z = 0,
      parent = "diamond_amount_bg",
      text = "999999",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33.5, 17.75)
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
      parent = "diamond_amount_bg",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "image_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, 17.75)
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
      size = 18
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
