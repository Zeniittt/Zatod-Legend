ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsSelectRoomModeWindow = {
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
      res = "UI/alpha/1080P/newkingspvp/main/join_room.png",
      name = "mode_join_room",
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
      res = "UI/alpha/1080P/newkingspvp/main/create_room.png",
      name = "mode_create_room",
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
      name = "label_join_room",
      z = 0,
      parent = "mode_join_room",
      text = T("\229\138\160\229\133\165\230\136\191\233\151\180"),
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
      text = T("\233\128\137\230\139\169\230\136\191\233\151\180\230\168\161\229\188\143"),
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
      name = "label_create_room",
      z = 0,
      parent = "mode_create_room",
      text = T("\229\136\155\229\187\186\230\136\191\233\151\180"),
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
  }
}
