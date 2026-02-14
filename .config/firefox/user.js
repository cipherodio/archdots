// These is automatically copy to firefox userprofile.default-release

// Set developer font size
user_pref("devtools.toolbox.zoomValue", "1.2");

// Enable custom userChrome.js:
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Blank Page background color
// user_pref("browser.display.background_color.dark", "#232326");

// Set homepage to blank page
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");

// Set New tab to blank page
user_pref("browser.newtabpage.enabled", false);

// Disable preloading the New Tab page (saves a bit of memory and avoids any flash of content)
user_pref("browser.newtab.preload", false);

// Enable compact mode
user_pref("browser.compactmode.show", true);

// Use compact density
user_pref("browser.uidensity", 1);

// Fix the issue where right mouse button instantly clicks
user_pref("ui.context_menus.after_mouseup", true);

// Remove full screen warning
user_pref("full-screen-api.warning.timeout", 0);

// Prevent the download panel from opening automatically
user_pref("browser.download.alwaysOpenPanel", false);

// Disable tab hover tooltip preview
user_pref("browser.tabs.hoverPreview.enabled", false);

// Disable the Twitter/R*ddit/Faceberg ads in the URL bar:
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.suggest.topsites", false);

// Do not suggest web history in the URL bar:
user_pref("browser.urlbar.suggest.history", false);

// Do not autocomplete in the URL bar:
user_pref("browser.urlbar.autoFill", false);

// Enable the addition of search keywords:
user_pref("keyword.enabled", true);

// Allow access to http (i.e. not https) sites:
user_pref("dom.security.https_only_mode", false);

// Don't autodelete cookies on shutdown:
user_pref("privacy.clearOnShutdown.cookies", false);

// This could otherwise cause some issues on bank logins and other annoying sites:
user_pref("network.http.referer.XOriginPolicy", 0);
