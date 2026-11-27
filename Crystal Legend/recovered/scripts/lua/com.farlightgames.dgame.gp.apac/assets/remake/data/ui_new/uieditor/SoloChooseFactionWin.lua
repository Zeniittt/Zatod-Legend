ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloChooseFactionWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135.5, h = 291},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/powerselect_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(0, 0)
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
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\233\128\137\230\139\169\230\181\129\230\180\190"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 287)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_1.png",
      name = "faction1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 254)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_2.png",
      name = "faction2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 224)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_3.png",
      name = "faction3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 194)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_4.png",
      name = "faction4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 164)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_5.png",
      name = "faction5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 134)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_6.png",
      name = "faction6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 104)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_7.png",
      name = "faction7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/powerselect_8.png",
      name = "faction8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.7999872, h = 34.7999942},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/match_button_1.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 22.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/select_bg.png",
      name = "icon_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.25, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.199998848, h = 17.599998944},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction1",
      res = "UI/alpha/1080P/chesscard/tagicon1.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name1",
      z = 0,
      parent = "faction1",
      text = T("\230\153\174\230\148\187\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.799998752, h = 15.99999904},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction2",
      res = "UI/alpha/1080P/chesscard/tagicon2.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name2",
      z = 0,
      parent = "faction2",
      text = T("\233\151\170\233\129\191\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.599998824, h = 18.799998872},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction3",
      res = "UI/alpha/1080P/chesscard/tagicon3.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name3",
      z = 0,
      parent = "faction3",
      text = T("\230\154\180\229\135\187\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.599998824, h = 16.399999016},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction4",
      res = "UI/alpha/1080P/chesscard/tagicon4.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name4",
      z = 0,
      parent = "faction4",
      text = T("\231\148\159\229\145\189\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.799998872, h = 19.9999988},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction5",
      res = "UI/alpha/1080P/chesscard/tagicon5.png",
      name = "icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name5",
      z = 0,
      parent = "faction5",
      text = T("\229\155\158\229\164\141\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.199998848, h = 19.599998824},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction6",
      res = "UI/alpha/1080P/chesscard/tagicon6.png",
      name = "icon6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name6",
      z = 0,
      parent = "faction6",
      text = T("\229\164\167\230\139\155\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.799998992, h = 16.799998992},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction7",
      res = "UI/alpha/1080P/chesscard/tagicon7.png",
      name = "icon7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name7",
      z = 0,
      parent = "faction7",
      text = T("\228\184\173\230\175\146\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.199999088, h = 19.9999988},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "faction8",
      res = "UI/alpha/1080P/chesscard/tagicon8.png",
      name = "icon8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.25)
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
      name = "name8",
      z = 0,
      parent = "faction8",
      text = T("\229\134\176\229\134\187\230\181\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 11.25)
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
      name = "Label_12527",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174\232\174\164"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_selected",
      res = "UI/alpha/1080P/chesscard/select.png",
      name = "ImageView_12529",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 13.75)
    }
  }
}
