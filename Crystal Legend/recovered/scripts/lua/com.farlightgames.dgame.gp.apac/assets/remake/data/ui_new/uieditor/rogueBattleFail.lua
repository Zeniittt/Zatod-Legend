ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBattleFail = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 975, h = 347.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battleresult/fail_bg.png",
      name = "image_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 213)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 271, h = 130},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/battleresult/new_resource/fail_bg_1.png",
      name = "light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484.5, 416.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 75)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "lootLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(112.5, 11.75)
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
      parent = "image_bg",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(897.5, 375.25)
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
      parent = "image_bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(862.5, 43.25)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 867.5, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/battleresult/splitline.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 101.25)
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
      position = ccp(62.25, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "heroLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(237, 180.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 528, h = 117},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/battleresult/new_resource/fail_bg.png",
      name = "ImageView_1150",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484.5, 391.75)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "loot_label",
      z = 0,
      parent = "image_bg",
      text = T("\229\165\150\229\138\177\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.5, 48.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_again",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(727.5, 43.25)
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
      name = "label_fail_tips",
      z = 0,
      parent = "image_bg",
      text = T("\233\128\137\230\139\169\233\135\141\232\175\149\229\143\175\229\155\158\229\136\176\230\140\145\230\136\152\229\137\141\231\154\132\231\138\182\230\128\129\239\188\140\233\128\137\230\139\169\233\128\128\229\135\186\229\176\134\231\187\147\230\157\159\230\156\172\230\172\161\230\184\184\231\142\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 155.75)
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
      name = "label_again",
      z = 0,
      parent = "btn_again",
      text = T("\233\135\141\232\175\149\239\188\1362/2\239\188\137"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.75)
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
      name = "label_end_fail_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\130\168\230\156\170\230\173\163\229\184\184\231\187\147\230\157\159\230\140\145\230\136\152"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 229.75)
    }
  }
}
