ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessRankGradeChangePanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204.4000146, h = 281.4000201},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/season/6.png",
      name = "iconGrade",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -36)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "buttonOk",
      z = 0,
      parent = "bg",
      text = T("\231\161\174\229\174\154"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -203.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.00000012, x = 1.00000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.00000324, h = 27.5000033},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star1",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-67, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.00000012, x = 1.00000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.00000324, h = 27.5000033},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star2",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-40, 103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.00000012, x = 1.00000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.00000324, h = 27.5000033},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star3",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-13.5, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.00000012, x = 1.00000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.00000324, h = 27.5000033},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star4",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.00000012, x = 1.00000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.00000324, h = 27.5000033},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star5",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.00000012, x = 1.00000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.00000324, h = 27.5000033},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "star6",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 102.5)
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
      name = "labelGrade",
      z = 20,
      parent = "bg",
      text = T("\229\155\189\231\142\139"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -112.5)
    }
  }
}
