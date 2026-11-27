ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsRoomWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 868, h = 417},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/ob/08_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 282)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(325, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_player_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, 268)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(325, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_player_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(436, 268)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(647.5, 257.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_ob_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(111.5, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 0,
      fix_wh = {w = 344.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/newkingspvp/ob/id_1.png",
      name = "image_room_id_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(380.5, -28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_copy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(161, -30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 42.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_big_common.png",
      name = "btn_start",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(686.5, -31)
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
      position = ccp(734.5, 391.5)
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
      position = ccp(340.5, 393)
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
      position = ccp(527.5, 393)
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
      text = T("\229\135\134\229\164\135\233\152\159\228\188\141"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434, 394.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 212, 124),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_room_tips",
      z = 0,
      parent = "image_room_id_bg",
      text = T("\230\136\145\231\154\132\233\152\159\228\188\141ID\239\188\154"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.25, 21)
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
      name = "label_room_id",
      z = 0,
      parent = "image_room_id_bg",
      text = "123456",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(145.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_copy",
      z = 0,
      parent = "btn_copy",
      text = T("\229\164\141\229\136\182"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.25, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start",
      z = 0,
      parent = "btn_start",
      text = T("\229\188\128\229\167\139\230\184\184\230\136\143"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.5, 29.75)
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
  }
}
