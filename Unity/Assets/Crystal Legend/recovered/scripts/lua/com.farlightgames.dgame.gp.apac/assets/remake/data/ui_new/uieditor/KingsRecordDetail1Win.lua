ed.uieditor = ed.uieditor or {}
ed.uieditor.KingsRecordDetail1Win = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 237.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_detail_bg_4.png",
      name = "bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77.5, h = 102},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_point_bg.png",
      name = "bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 187.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(129, 116, 97),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\231\169\186\231\153\189\229\164\132\233\128\128\229\135\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.999989, h = 76.999989},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "left_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(448, 185.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.3, x = 1.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 160.55, h = 27.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_player_name_bg.png",
      name = "bg_left_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(448, 145.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_result",
      z = 2,
      parent = "bg",
      text = T("\232\131\156"),
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488.5, 209.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.3, x = 1.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 160.55, h = 27.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_player_name_bg.png",
      name = "bg_right_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(721, 145.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(200, 199, 224),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "right_result",
      z = 2,
      parent = "bg",
      text = T("\232\180\165"),
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(682, 209.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.999989, h = 76.999989},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "right_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(721, 185.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_detail_bg_2.png",
      name = "bg_item",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(608, 82.75)
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
      name = "score",
      z = 0,
      parent = "bg_score",
      text = "2:1",
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(140, 241, 105),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_name",
      z = 0,
      parent = "bg_left_name",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 104, 104),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "right_name",
      z = 0,
      parent = "bg_right_name",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.55, x = 0.55},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.35, h = 45.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_item",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "btn_replay",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(679.25, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.55, x = 0.55},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.35, h = 45.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_item",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "btn_statics",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(621.25, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_item",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_win_1.png",
      name = "bg_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2, x = 2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_replay",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "ImageView_9351",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2, x = 2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_statics",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
      name = "ImageView_935",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result",
      z = 1,
      parent = "bg_result",
      text = T("\232\131\156"),
      size = 34
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 29)
    }
  }
}
