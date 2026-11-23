local class = newclass("g")
ed.selectlanguage = class
setfenv(1, class)

function doCreateSetupSelect()
  return setupselect.create()
end

function doDownload(param)
  if type(ed.getCurrentScene()) == "table" then
    ed.getCurrentScene().notExitYet = true
  end
  ed.pushScene(ed.ui.download.create(param))
end

function doSelectLanguage(language, force)
  local dtLanguage = ed.loadLanguage()
  if resource_config[string.format("%s_language_close", language)] then
    local textList = {
      cn = "\232\175\165\232\175\173\232\168\128\229\140\133\229\176\154\230\156\170\229\188\128\230\148\190\239\188\140\229\176\189\230\131\133\230\156\159\229\190\133",
      en = "This language is coming soon - get ready!",
      thai = "\224\184\129\224\184\165\224\185\136\224\184\173\224\184\135\224\184\160\224\184\178\224\184\169\224\184\178\224\184\162\224\184\177\224\184\135\224\185\132\224\184\161\224\185\136\224\185\136\224\185\128\224\184\155\224\184\180\224\184\148\224\185\131\224\184\138\224\185\137\224\184\135\224\184\178\224\184\153 \224\184\129\224\184\163\224\184\184\224\184\147\224\184\178\224\184\163\224\184\173\224\184\170\224\184\177\224\184\129\224\184\132\224\184\163\224\184\185\224\185\136"
    }
    ed.showToast(textList[language] or "")
    return "close"
  end
  if dtLanguage == language and not force then
    return "done"
  else
    if ed.checkLanguageUpdate(language) then
      local text = "\229\136\135\230\141\162\229\136\176\232\175\165\232\175\173\232\168\128\233\156\128\232\166\129\228\184\139\232\189\189\232\175\173\232\168\128\229\140\133\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159"
      if language == "thai" then
        text = "\224\184\129\224\184\178\224\184\163\224\185\128\224\184\155\224\184\165\224\184\181\224\185\136\224\184\162\224\184\153\224\184\160\224\184\178\224\184\169\224\184\178\224\184\153\224\184\177\224\185\137\224\184\153\224\184\149\224\185\137\224\184\173\224\184\135\224\184\148\224\184\179\224\185\128\224\184\153\224\184\180\224\184\153\224\184\129\224\184\178\224\184\163\224\184\148\224\184\178\224\184\167\224\184\153\224\185\140\224\185\130\224\184\171\224\184\165\224\184\148\224\184\129\224\184\165\224\185\136\224\184\173\224\184\135\224\184\160\224\184\178\224\184\169\224\184\178 \224\184\148\224\184\179\224\185\128\224\184\153\224\184\180\224\184\153\224\184\129\224\184\178\224\184\163\224\184\149\224\185\136\224\184\173\224\184\171\224\184\163\224\184\183\224\184\173\224\185\132\224\184\161\224\185\136?"
      end
      ed.showConfirmDialog({
        text = text,
        rightHandler = function()
          doDownload({
            language = language,
            callback = function()
              ed.setLanguage(language)
              doRestart()
            end,
            cancelHandler = function()
            end
          })
        end,
        showCloseButton = true
      })
    else
      ed.setLanguage(language)
      doRestart()
    end
    return "confirm"
  end
end

function doRestart(param)
  param = param or {}
  local text_list = {
    cn = "\232\174\190\231\189\174\232\175\173\232\168\128\230\136\144\229\138\159\239\188\140\233\135\141\229\144\175\229\174\162\230\136\183\231\171\175\229\144\142\231\148\159\230\149\136\227\128\130",
    en = "Language successfully changed - please restart the game."
  }
  ed.showAlertDialog({
    text = param.text or text_list[ed.loadLanguage()] or T("\232\174\190\231\189\174\232\175\173\232\168\128\230\136\144\229\138\159\239\188\140\233\135\141\229\144\175\229\174\162\230\136\183\231\171\175\229\144\142\231\148\159\230\149\136\227\128\130"),
    buttonText = T("\233\128\128\229\135\186"),
    handler = function()
      if EDFLAGANDROID then
        EDRestartGame()
      else
        EDExit()
      end
    end
  })
end
