ed.uieditor = ed.uieditor or {}
ed.uieditor.KingsRecordBattleItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 738, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_detail_bg_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      parent = "bg",
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_win_1.png",
      name = "bg_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 31.25)
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "btn_replay",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(684, 28.75)
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "btn_statics",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(144, 96, 66),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_971",
      z = 0,
      parent = "bg",
      text = "1",
      size = 50
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 40.75)
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
  }
}
