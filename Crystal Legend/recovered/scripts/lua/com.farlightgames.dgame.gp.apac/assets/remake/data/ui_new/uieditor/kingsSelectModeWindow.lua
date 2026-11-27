ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsSelectModeWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 956.5, h = 419},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/select_mode_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 273)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(770.75, 396.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_71528",
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
      fix_wh = {w = 200, h = 281},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/main/select_mode_1.png",
      name = "mode_bo3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(608.25, 205)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 200, h = 281},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/main/select_mode_2.png",
      name = "mode_bo1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348.75, 204)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 246, 205),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bo3",
      z = 0,
      parent = "mode_bo3",
      text = T("\228\184\137\229\177\128\228\184\164\232\131\156"),
      size = 34
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 207),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\233\128\137\230\139\169\230\136\152\230\150\151\230\150\185\229\188\143"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.25, 397)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_title_cursor.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(571.75, 395.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 246, 205),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bo1",
      z = 0,
      parent = "mode_bo1",
      text = T("\228\184\128\229\177\128\232\131\156\232\180\159"),
      size = 34
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 35, h = 5.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_title_cursor.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385.25, 395.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(328, 40)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(60, 12.5, 60, 12.5),
      res = "UI/alpha/1080P/newkingspvp/ob/ob_1.png",
      name = "btn_mode_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(850.5, 44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 180, h = 40},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_mode_bg",
      res = "UI/alpha/1080P/newkingspvp/ob/ob_2.png",
      name = "btn_match_select",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 1,
      fix_wh = {w = 180, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_mode_bg",
      res = "UI/alpha/1080P/newkingspvp/ob/ob_2.png",
      name = "btn_match",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 180, h = 40},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_mode_bg",
      res = "UI/alpha/1080P/newkingspvp/ob/ob_2.png",
      name = "btn_ob_select",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(238.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 1,
      fix_wh = {w = 180, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_mode_bg",
      res = "UI/alpha/1080P/newkingspvp/ob/ob_2.png",
      name = "btn_ob",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(238.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_match_select",
      res = "UI/alpha/1080P/newkingspvp/ob/01.png",
      name = "image_match_icon_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_match_select",
      z = 0,
      parent = "btn_match_select",
      text = T("\229\140\185\233\133\141\230\168\161\229\188\143"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_match",
      res = "UI/alpha/1080P/newkingspvp/ob/02.png",
      name = "image_match_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(151, 121, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_match",
      z = 0,
      parent = "btn_match",
      text = T("\229\140\185\233\133\141\230\168\161\229\188\143"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_ob_select",
      res = "UI/alpha/1080P/newkingspvp/ob/ob_tag2.png",
      name = "image_ob_icon_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_ob_select",
      z = 0,
      parent = "btn_ob_select",
      text = T("\230\175\148\232\181\155\230\168\161\229\188\143"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_ob",
      res = "UI/alpha/1080P/newkingspvp/ob/ob_tag3.png",
      name = "image_ob_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(151, 121, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_ob",
      z = 0,
      parent = "btn_ob",
      text = T("\230\175\148\232\181\155\230\168\161\229\188\143"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 20)
    }
  }
}
