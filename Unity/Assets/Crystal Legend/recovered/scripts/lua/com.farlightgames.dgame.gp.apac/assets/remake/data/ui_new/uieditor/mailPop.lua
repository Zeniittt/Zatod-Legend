ed.uieditor = ed.uieditor or {}
ed.uieditor.mailPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(880, 490)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 20.5, 39.5, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "mail9Bj_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 261)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(880.5, 490)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17, 17, 11, 11),
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      name = "mail9Bj_2",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 261)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.9, h = 46.75},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "mail_offBut",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(909.5, 500)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.5, 473.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 11, 0.5, 50),
      res = "UI/alpha/1080P/mail/mail_lin.png",
      name = "mail_lin",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(338, 265.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(293, 474)
    },
    t = "Layer",
    base = {name = "Panel_left", z = 2},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45.5, 28.5)
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
      parent = "mail_offBut",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_27",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 475.5)
    },
    t = "Layer",
    base = {
      name = "Panel_right",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(339, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 299, h = 313.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/package/fox.png",
      name = "foxMailNil",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267, 243.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_f_2.png",
      name = "mail_imgTag",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 451.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "mail_numMax",
      z = 9,
      parent = "Panel_left",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(283, 451.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(101, 39)
    },
    t = "Scale9Sprite",
    base = {
      name = "mail_butDele",
      z = 0,
      parent = "Panel_left",
      res = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(20, 10, 10, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 39)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(101, 39)
    },
    t = "Scale9Sprite",
    base = {
      name = "mail_butAuto",
      z = 0,
      parent = "Panel_left",
      res = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(20, 10, 10, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 39)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(282, 391.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_left",
      name = "mail_listPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7, 70)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 150,
      visible = true,
      scaleSize = CCSizeMake(416.5, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "mail_titles",
      z = 0,
      parent = "Panel_right",
      res = "UI/alpha/1080P/mail/mail_titname_bj.png",
      capInsets = CCRectMake(12, 11.5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275.5, 449.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(288, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_183",
      z = 8,
      parent = "Panel_left",
      res = "UI/alpha/1080P/mail/mail_tit_bj.png",
      capInsets = CCRectMake(10, 10, 20, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148, 450.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(545, 400)
    },
    t = "Layer",
    base = {
      parent = "Panel_right",
      name = "boyLays",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 403, h = 61},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "foxMailNil",
      res = "UI/alpha/1080P/package/fox_tip.png",
      name = "ImageView_278",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(509.5, 182.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mail_imgTag",
      res = "UI/alpha/1080P/mail/mail_icon_img.png",
      name = "ImageView_31",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 245, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "mail_butDelestr1",
      z = 1,
      parent = "mail_butDele",
      text = T("\229\136\160\233\153\164\229\183\178\232\175\187"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(71, 48, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "mail_butDelestr2",
      z = 0,
      parent = "mail_butDele",
      text = T("\229\136\160\233\153\164\229\183\178\232\175\187"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 245, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "mail_butAutostr1",
      z = 1,
      parent = "mail_butAuto",
      text = T("\228\184\128\233\148\174\233\162\134\229\143\150"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 20)
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
      name = "Label_titleStr",
      z = 0,
      parent = "mail_titles",
      text = "",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(71, 48, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "mail_butAutostr2",
      z = 0,
      parent = "mail_butAuto",
      text = T("\228\184\128\233\148\174\233\162\134\229\143\150"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(290, 0.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_48",
      z = 0,
      parent = "boyLays",
      res = "UI/alpha/1080P/package/seg_attr.png",
      capInsets = CCRectMake(0.5, 0.5, 210, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.5, 349.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(171, 170, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_timeLeft",
      z = 0,
      parent = "boyLays",
      text = T("\230\151\182\233\151\180\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, 363)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(234, 233, 223),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_nameLeft",
      z = 0,
      parent = "boyLays",
      text = T("\229\143\145\228\187\182\228\186\186\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 385.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(560, 162.5)
    },
    t = "Layer",
    base = {
      parent = "boyLays",
      name = "itemLay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-7.5, -15.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 53.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "getItemBut",
      z = 0,
      parent = "boyLays",
      res = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(20, 9.5, 40, 30)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(440, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(550, 350)
    },
    t = "Layer",
    base = {
      parent = "boyLays",
      name = "bodyPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.5, -1.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(171, 170, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 0,
      parent = "boyLays",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.5, 363)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(545, 200.5)
    },
    t = "Layer",
    base = {
      parent = "boyLays",
      name = "bodyPosItem",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2, 148)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(234, 233, 223),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_name",
      z = 0,
      parent = "boyLays",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(71.5, 385.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 251, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_foxSee",
      z = 0,
      parent = "ImageView_278",
      text = T("\229\136\171\231\156\139\229\149\166\233\157\147\228\187\148\239\188\140\232\191\152\230\178\161\230\156\137\233\130\174\228\187\182\239\188\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.5, 30)
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
      name = "Label_99",
      z = 0,
      parent = "itemLay",
      text = T("\233\153\132\228\187\182\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 139)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(487.5, 70)
    },
    t = "Layer",
    base = {
      parent = "itemLay",
      name = "Panel_itemPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(65.5, 84)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "itemLay",
      name = "mail_rig_lin",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(282.5, 162)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 240, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "getItemButStr",
      z = 1,
      parent = "getItemBut",
      text = T("\233\162\134 \229\143\150"),
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(71, 48, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "getItemButStr_bj",
      z = 0,
      parent = "getItemBut",
      text = T("\233\162\134 \229\143\150"),
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(520, 6)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_8463_Copy0",
      z = 5,
      parent = "mail_rig_lin",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(4, -3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6.75, h = 7.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mail_rig_lin",
      res = "UI/alpha/1080P/common/battle_star_lins.png",
      name = "ImageView_823232_Copy0",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 6)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_8432_Copy0",
      z = 5,
      parent = "mail_rig_lin",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(-4, -3)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 220, 114),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_mail_tag",
      z = 0,
      parent = "mail_imgTag",
      text = T("\233\130\174  \231\174\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40.25, 13.25)
    }
  }
}
