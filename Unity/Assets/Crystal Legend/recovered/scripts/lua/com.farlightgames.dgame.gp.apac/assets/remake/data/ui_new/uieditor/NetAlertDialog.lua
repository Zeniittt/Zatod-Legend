ed.uieditor = ed.uieditor or {}
ed.uieditor.NetAlertDialog = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(480, 360)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 50),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 256.5)
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
      text = T("\231\189\145\231\187\156\230\163\128\230\181\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(240, 323)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "left_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156, 323)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "right_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(325, 323)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.35, h = 37.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.35, h = 37.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 242, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_ok",
      z = 0,
      parent = "btn_ok",
      text = T("\229\188\128\229\167\139\231\155\145\230\181\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(289.5, 154.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_label",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(73, 156.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 242, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn_back",
      z = 0,
      parent = "btn_back",
      text = T("\232\191\148\229\155\158"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 21)
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
      name = "Label_title_1",
      z = 0,
      parent = "Panel_label",
      text = T("HTTP\232\174\191\233\151\174\230\181\139\232\175\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 141.5)
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
      name = "Label_title_2",
      z = 0,
      parent = "Panel_label",
      text = T("CDN\232\174\191\233\151\174\230\181\139\232\175\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.5, 83.5)
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
      name = "Label_title_3",
      z = 0,
      parent = "Panel_label",
      text = T("TCP\233\147\190\230\142\165\230\181\139\232\175\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 25)
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
      name = "Label_title_4",
      z = 0,
      parent = "Panel_label",
      text = T("MTR\232\183\175\229\190\132\229\136\134\230\158\144"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, -33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6",
      z = 0,
      parent = "Panel_label",
      text = T("TraceID\239\188\154"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, -13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5",
      z = 0,
      parent = "Panel_label",
      text = T("\229\136\134\230\158\144\228\184\173"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3",
      z = 0,
      parent = "Panel_label",
      text = T("\229\136\134\230\158\144\229\174\140\230\136\144\239\188\154\230\173\163\229\184\184"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_8",
      z = 0,
      parent = "Panel_label",
      text = "TraceID",
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, -71.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1",
      z = 0,
      parent = "Panel_label",
      text = T("\229\136\134\230\158\144\228\184\173"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 122)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_7",
      z = 0,
      parent = "Panel_label",
      text = T("\229\136\134\230\158\144\228\184\173"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, -52.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2",
      z = 0,
      parent = "Panel_label",
      text = "TraceId:",
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 103)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(30, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4",
      z = 0,
      parent = "Panel_label",
      text = "TraceID",
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 45)
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
      name = "Label_9",
      z = 0,
      parent = "Panel_label",
      text = T("\232\174\190\229\164\135id"),
      size = 9
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-57.5, 188.5)
    }
  }
}
