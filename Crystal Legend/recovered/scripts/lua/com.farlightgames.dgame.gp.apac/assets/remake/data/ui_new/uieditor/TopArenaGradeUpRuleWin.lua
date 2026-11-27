ed.uieditor = ed.uieditor or {}
ed.uieditor.TopArenaGradeUpRuleWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 689.5, h = 443},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_promotion_rule.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470, 295)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_ok",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(10, 10, 95, 30)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(344.75, 41.5)
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
      name = "Label_896",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174 \229\174\154"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 222.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45.25, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210.5, h = 75.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/goback_bonus_txt_bg_tf.png",
      name = "ImageView_2119",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(341.25, 341.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "ImageView_2119",
      text = T("\229\188\128\229\144\175\230\153\139\231\186\167\232\181\155"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.25, 37.75)
    }
  }
}
