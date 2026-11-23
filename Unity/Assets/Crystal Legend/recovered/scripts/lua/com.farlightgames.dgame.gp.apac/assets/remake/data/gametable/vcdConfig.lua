EDDefineTable("vcdConfig")
UIRes = {
  {
    layerName = "pvpLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -300,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "pvpBg",
          res = "UI/alpha/1080P/common/mail_bj9_1.png",
          capInsets = CCRectMake(10, 10, 10, 10)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(480, 270)
        },
        config = {
          scaleSize = CCSizeMake(800, 240)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "replay",
          parent = "pvpBg",
          buttonName = {
            text = T("\229\134\141\231\156\139\228\184\128\233\129\141"),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 0.5, 0.5),
          handleName = "showReplay"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 40)
        },
        config = {
          scaleSize = CCSizeMake(130, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "data",
          parent = "pvpBg",
          buttonName = {
            text = T("\230\149\176\230\141\174\231\187\159\232\174\161"),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 0.5, 0.5),
          handleName = "showData"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 40)
        },
        config = {
          scaleSize = CCSizeMake(130, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "exit",
          parent = "pvpBg",
          buttonName = {
            text = T("\233\128\128\229\135\186\229\155\158\230\148\190"),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 0.5, 0.5),
          handleName = "closePvp"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(600, 40)
        },
        config = {
          scaleSize = CCSizeMake(130, 45)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "left",
          res = "UI/alpha/1080P/crusade/bg_replay_self.png",
          parent = "pvpBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(242.5, 145)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "right",
          res = "UI/alpha/1080P/crusade/bg_replay_enemy.png",
          parent = "pvpBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(557.5, 145)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "ui",
          res = "UI/alpha/1080P/crusade/replay_vs.png",
          parent = "pvpBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 124.5)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "leftResult",
          parent = "left",
          res = "UI/alpha/1080P/crusade/icon_win.png"
        },
        layout = {
          position = ccp(28.5, 115.5)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "leftLabelResult",
          text = T("\232\131\156"),
          size = 16,
          parent = "leftResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(12.5, 18.75)
        },
        config = {
          color = ccc3(255, 244, 194),
          scalexy = {x = 1, y = 1}
        }
      },
      {
        t = "Sprite",
        base = {
          name = "leftIcon",
          parent = "left",
          z = 10
        },
        layout = {
          position = ccp(67.5, 106)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "leftNameBg",
          res = "UI/alpha/1080P/crusade/bg_name_reply_item.png",
          parent = "left"
        },
        layout = {
          position = ccp(199, 106.5)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "leftLevelBg",
          res = "UI/alpha/1080P/ranking/lv_bg.png",
          parent = "leftNameBg",
          z = 10
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(37, 10)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "leftLevel",
          text = "",
          size = 16,
          parent = "leftNameBg",
          z = 11
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(37, 10)
        },
        config = {
          color = ccc3(226, 206, 174)
        }
      },
      {
        t = "Label",
        base = {
          name = "leftName",
          text = "",
          size = 18,
          parent = "leftNameBg",
          z = 11
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(70, 10)
        },
        config = {
          color = ccc3(255, 255, 255)
        }
      },
      {
        t = "Sprite",
        base = {name = "leftHero5", parent = "left"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(44, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero4", parent = "left"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(107.5, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero3", parent = "left"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(171, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero2", parent = "left"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(234.5, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "leftHero1", parent = "left"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(297, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "rightResult",
          parent = "right",
          res = "UI/alpha/1080P/crusade/icon_win.png"
        },
        layout = {
          position = ccp(398.5, 115.5)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "rightLabelResult",
          text = T("\232\131\156"),
          size = 16,
          parent = "rightResult"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(12.5, 18.75)
        },
        config = {
          color = ccc3(255, 244, 194),
          scalexy = {x = 1, y = 1}
        }
      },
      {
        t = "Sprite",
        base = {
          name = "rightIcon",
          parent = "right",
          z = 10
        },
        layout = {
          position = ccp(359.5, 106)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {
          name = "rightNameBg",
          res = "UI/alpha/1080P/crusade/bg_name_reply_item.png",
          parent = "right"
        },
        layout = {
          position = ccp(234, 106.5)
        },
        config = {
          scalexy = {x = -1, y = 1}
        }
      },
      {
        t = "Sprite",
        base = {
          name = "rightLevelBg",
          res = "UI/alpha/1080P/ranking/lv_bg.png",
          parent = "right",
          z = 10
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(318, 106.5)
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          name = "rightLevel",
          text = "",
          size = 16,
          parent = "right",
          z = 11
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(318, 106.5)
        },
        config = {
          color = ccc3(226, 206, 174)
        }
      },
      {
        t = "Label",
        base = {
          name = "rightName",
          text = "",
          size = 18,
          parent = "rightNameBg",
          z = 11
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(65, 10)
        },
        config = {
          color = ccc3(255, 255, 255),
          scalexy = {x = -1, y = 1}
        }
      },
      {
        t = "Sprite",
        base = {name = "rightHero5", parent = "right"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(383, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero4", parent = "right"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(319.5, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero3", parent = "right"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(256, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero2", parent = "right"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(192.5, 46)
        },
        config = {}
      },
      {
        t = "Sprite",
        base = {name = "rightHero1", parent = "right"},
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(130, 46)
        },
        config = {}
      }
    }
  }
}
PveUIRes = {
  {
    layerName = "pveLayer",
    iPriority = 200,
    layerColor = ccc4(0, 0, 0, 190),
    touchInfo = {
      iPriority = -300,
      bSwallowsTouches = true,
      alert = true
    },
    uiRes = {
      {
        t = "Scale9Sprite",
        base = {
          name = "pvpBg",
          res = "UI/alpha/1080P/common/mail_bj9_1.png",
          capInsets = CCRectMake(10, 10, 10, 10)
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(480, 270)
        },
        config = {
          scaleSize = CCSizeMake(800, 240)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "replay",
          parent = "pvpBg",
          buttonName = {
            text = T("\229\134\141\231\156\139\228\184\128\233\129\141"),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 0.5, 0.5),
          handleName = "showReplay"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(200, 40)
        },
        config = {
          scaleSize = CCSizeMake(130, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "data",
          parent = "pvpBg",
          buttonName = {
            text = T("\230\149\176\230\141\174\231\187\159\232\174\161"),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 0.5, 0.5),
          handleName = "showData"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 40)
        },
        config = {
          scaleSize = CCSizeMake(130, 45)
        }
      },
      {
        t = "Scale9Button",
        base = {
          name = "exit",
          parent = "pvpBg",
          buttonName = {
            text = T("\233\128\128\229\135\186\229\155\158\230\148\190"),
            fontInfo = "normal_button"
          },
          res = {
            normal = "UI/alpha/1080P/common/button_com_sys.png",
            press = "UI/alpha/1080P/common/button_com_sys.png"
          },
          capInsets = CCRectMake(10, 10, 0.5, 0.5),
          handleName = "closePvp"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(600, 40)
        },
        config = {
          scaleSize = CCSizeMake(130, 45)
        }
      },
      {
        t = "Sprite",
        base = {
          name = "log",
          res = "UI/alpha/1080P/dreamland/dream_record_end.png",
          parent = "pvpBg"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(400, 147)
        }
      }
    }
  }
}
