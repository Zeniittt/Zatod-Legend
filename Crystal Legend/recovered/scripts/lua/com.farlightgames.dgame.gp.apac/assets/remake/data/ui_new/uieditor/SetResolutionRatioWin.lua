ed.uieditor = ed.uieditor or {}
ed.uieditor.SetResolutionRatioWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(531.25, 351.56)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(11.72, 11.72, 57.03, 7.81),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      name = "bg",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 239.84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 49.21875, h = 52.34375},
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
      normal = "UI/alpha/1080P/common/common_tips_button_close_1.png",
      name = "button_close",
      z = 10,
      parent = "bg",
      text = T(""),
      press = "UI/alpha/1080P/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(510.94, 332.81)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 468.984375, h = 31.249998125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/task_window_title_bg.png",
      name = "img_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.63, 332.03)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(105, 41.25),
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
      normal = "UI/alpha/1080P/common/button.png",
      capInsets = CCRectMake(11.72, 11.72, 51.56, 25.78),
      name = "button_ok",
      z = 0,
      parent = "bg",
      text = "\231\161\174\229\174\154",
      press = "UI/alpha/1080P/common/button_press.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.63, 27.34)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140.63, 140.63)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "selectLayer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(267.19, 182.03)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "img_title_bg",
      text = T("\232\174\190\231\189\174\229\136\134\232\190\168\231\142\135"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260.55, 19.53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, 121.09)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, 85.94)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, 50.78)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, 15.63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, -19.53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, -54.69)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, -89.84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "item8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, -125)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.03125, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selectLayer",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "itemFull",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-210.94, -155)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item1",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label1",
      z = 0,
      parent = "item1",
      text = T("\230\158\129\231\171\175\230\137\129         \230\175\148\231\142\1352.5:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item2",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label2",
      z = 0,
      parent = "item2",
      text = T("\228\184\137\230\152\159s20        \230\175\148\231\142\1352.22:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item3",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label3",
      z = 0,
      parent = "item3",
      text = T("IphoneX        \230\175\148\231\142\1352.165:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item4",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label4",
      z = 0,
      parent = "item4",
      text = T("\231\187\143\229\133\18416:9       \230\175\148\231\142\1351.778:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(53.52, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item5",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label5",
      z = 0,
      parent = "item5",
      text = T("Ipad Pro       \230\175\148\231\142\1351.402:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item6",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label6",
      z = 0,
      parent = "item6",
      text = T("Ipad 4:3       \230\175\148\231\142\1351.333:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item7",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label7",
      z = 0,
      parent = "item7",
      text = T("\230\158\129\231\171\175\230\150\185         \230\175\148\231\142\1351:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "item8",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selected8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 30.46875},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "itemFull",
      res = "UI/alpha/1080P/common/fragment_tick.png",
      name = "item_selectedFull",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 20.05)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_label8",
      z = 0,
      parent = "item8",
      text = T("\232\135\170\229\174\154\229\136\134\232\190\168\231\142\135     \229\174\158\230\151\182\230\175\148\231\142\1351.778:1"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 16.8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(62.5, 31.25)
    },
    t = "Scale9Sprite",
    base = {
      name = "width_bg",
      z = 0,
      parent = "item8",
      res = "UI/alpha/1080P/common/activate_input.png",
      capInsets = CCRectMake(9.38, 7.81, 9.38, 17.19)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.61, 19.14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(150, 150, 150),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_labelFull",
      z = 0,
      parent = "itemFull",
      text = T("\229\133\168\229\177\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.3, 12.8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(62.5, 31.25)
    },
    t = "Scale9Sprite",
    base = {
      name = "height_bg",
      z = 0,
      parent = "item8",
      res = "UI/alpha/1080P/common/activate_input.png",
      capInsets = CCRectMake(9.38, 7.81, 9.38, 17.19)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434.77, 19.14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 178, 12),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_21427",
      z = 0,
      parent = "item8",
      text = "X",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(391.8, 20.7)
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
      name = "width_label",
      z = 0,
      parent = "width_bg",
      text = "1600",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.25, 15.63)
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
      name = "height_label",
      z = 0,
      parent = "height_bg",
      text = "900",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.25, 15.63)
    }
  }
}
