ed.uieditor = ed.uieditor or {}
ed.uieditor.petDecompWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(780, 443)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 7.5, 1, 1),
      res = "UI/alpha/1080P/pet/hero_pet_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(416, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(740, 340)
    },
    t = "Scale9Sprite",
    base = {
      name = "panel_pet",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/goback/goods/goback_goods_sold_out.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(391, 262)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_get",
      z = 0,
      parent = "bg",
      text = T("\230\148\190\231\148\159\232\142\183\229\190\151\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(445, 68)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_getList",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(118, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(125, 50),
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
      normal = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(40, 15, 40, 15),
      name = "btn_decomp",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(679, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(710, 267.5)
    },
    t = "Layer",
    base = {
      parent = "panel_pet",
      name = "panel_showPet",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_note",
      z = 0,
      parent = "panel_pet",
      text = T("\230\179\168\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_select",
      z = 0,
      parent = "panel_pet",
      text = T("\229\133\168\233\128\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(711, 30)
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
      name = "label_decomp",
      z = 0,
      parent = "btn_decomp",
      text = T("\231\161\174 \232\174\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.75, h = 32.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_pet",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "check_box",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(640, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.75, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "check_box",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "check",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11.75, 14.25)
    }
  }
}
