local ccp = ccp

function initResourceConfig()
  local language = ed.storage.getString("dt_lang") or ""
  language = language ~= "" and language or default_language
  language = string.upper(language)
  local translateKey = string.format("%s %s", "TRANSLATION", language)
  resource_config = {
    textconfig_translation_key = (language or "") == "TRANSLATION" and "" or translateKey
  }
end

resource_config = {}
setfenv(1, resource_config)
splash_logo_pos = ccp(700, 400)
show_last_season_real_arena = true
