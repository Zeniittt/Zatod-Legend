ed.uieditor = ed.uieditor or {}
ed.uieditor.BattlePauseWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 193},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_pause.png",
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
      fix_wh = {w = 77, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "exit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255, 96.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "sound",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(405, 96.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "soundEffect",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(555, 96.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "resume",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(705, 96.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "exit",
      res = "UI/alpha/1080P/crusade/btn_back.png",
      name = "exitIcon",
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
      color = ccc3(254, 205, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "exitLabel",
      z = 0,
      parent = "exit",
      text = T("\233\128\128\229\135\186\230\136\152\230\150\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, -6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "sound",
      res = "UI/alpha/1080P/crusade/btn_back.png",
      name = "soundIcon",
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
      color = ccc3(254, 205, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "soundLabel",
      z = 0,
      parent = "sound",
      text = T("\232\131\140\230\153\175\229\163\176\233\159\179\239\188\154\229\188\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, -6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "soundEffect",
      res = "UI/alpha/1080P/crusade/btn_back.png",
      name = "soundEffectIcon",
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
      color = ccc3(254, 205, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "soundEffectLabel",
      z = 0,
      parent = "soundEffect",
      text = T("\231\137\185\230\149\136\229\163\176\233\159\179\239\188\154\229\188\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, -6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "resume",
      res = "UI/alpha/1080P/crusade/btn_back.png",
      name = "resumeIcon",
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
      color = ccc3(254, 205, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "resumeLabel",
      z = 0,
      parent = "resume",
      text = T("\231\187\167\231\187\173\230\136\152\230\150\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, -6.25)
    }
  }
}
