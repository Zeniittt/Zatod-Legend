ed.uieditor = ed.uieditor or {}
ed.uieditor.PetHatchWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(800, 450)
    },
    t = "Layer",
    base = {name = "panel", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "panel",
      name = "nest1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(173.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "panel",
      name = "nest2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(408.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "panel",
      name = "nest3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(643.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "panel",
      name = "nest4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(173.5, 82.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "panel",
      name = "nest6",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(643.5, 82.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "panel",
      name = "nest5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(408.5, 82.5)
    }
  }
}
