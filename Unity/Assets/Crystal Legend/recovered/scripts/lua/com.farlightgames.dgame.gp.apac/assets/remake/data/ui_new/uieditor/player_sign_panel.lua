ed.uieditor = ed.uieditor or {}
ed.uieditor.player_sign_panel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 200)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 200),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "image_bg",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip",
      z = 0,
      parent = "image_bg",
      text = T("\232\175\183\231\188\150\232\190\145\231\173\190\229\144\141\229\134\133\229\174\185\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(28.5, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
      flip = "",
      labelConfig = {
        color = ccc3(254, 247, 170)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_confirm",
      z = 0,
      parent = "image_bg",
      text = T("\231\161\174\229\174\154"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(241, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
      flip = "",
      labelConfig = {
        color = ccc3(254, 247, 170)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_cancel",
      z = 0,
      parent = "image_bg",
      text = T("\229\143\150\230\182\136"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 27.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_edit_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/common/activate_input.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177, 109)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(288, 20)
    },
    t = "Layer",
    base = {
      parent = "image_edit_bg",
      name = "node_edit",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.5, 3.75)
    }
  }
}
