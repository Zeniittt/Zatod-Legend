ed.uieditor = ed.uieditor or {}
ed.uieditor.testShaderWin = {
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "subH",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(818, 450)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "addH",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(705, 450)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "subS",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(818, 400)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "addS",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(705, 400)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "subV",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(818, 350)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "addV",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(705, 350)
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
      size = 15,
      text = "Text Label",
      name = "label_H",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(908.5, 453)
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
      size = 15,
      text = "Text Label",
      name = "label_S",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(908.5, 402)
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
      size = 15,
      text = "Text Label",
      name = "label_V",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(909.5, 350.5)
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
      name = "Label_2663",
      z = 0,
      parent = "subH",
      text = T("\229\135\143\232\137\178\232\176\131"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_2664",
      z = 0,
      parent = "addH",
      text = T("\229\138\160\232\137\178\231\155\184"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_2665",
      z = 0,
      parent = "subS",
      text = T("\229\135\143\233\165\177\229\146\140\229\186\166"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_2666",
      z = 0,
      parent = "addS",
      text = T("\229\138\160\233\165\177\229\146\140\229\186\166"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_2667",
      z = 0,
      parent = "subV",
      text = T("\229\135\143\228\186\174\229\186\166"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_2668",
      z = 0,
      parent = "addV",
      text = T("\229\138\160\228\186\174\229\186\166"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  }
}
