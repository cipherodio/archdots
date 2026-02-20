// These is automatically copy to firefox userprofile.default-release

// Set developer font size
user_pref("devtools.toolbox.zoomValue", "1.2");

// Enable custom userChrome.js:
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);


// Set Startup to blank page
user_pref("browser.startup.page", 0);
// Set Homepage/New Window to blank
user_pref("browser.startup.homepage", "about:blank");
// Set New Tab page to blank
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.url", "about:blank");


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


// Enable DRM content (Widevine)
user_pref("media.eme.enabled", true);
user_pref("media.gmp-manager.updateEnabled", true);
user_pref("media.gmp-widevinecdm.enabled", true);
user_pref("media.gmp-widevinecdm.visible", true);


// Disable Recommended extensions as you browse (CFR)
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
// Disable personalized extension recommendations
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
// Disable the "Discover" pane in Add-ons
user_pref("extensions.htmlaboutaddons.discover.enabled", false);
// Disable showing the recommendation pane
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.webservice.discoverURL", "");
user_pref("extensions.getAddons.discovery.api_url", "");


// Disable the new Firefox Sidebar revamp
user_pref("sidebar.revamp", false);
// Ensure the sidebar is hidden
user_pref("sidebar.visibility", "hide-sidebar");
// Optional: If you enabled vertical tabs, disable them
user_pref("sidebar.verticalTabs", false);


// Disable ask to save password
user_pref("signon.rememberSignons", false);
// Disable auto filling existing passwords
user_pref("signon.autofillForms", false);
// Disable form autocomplete
user_pref("browser.formfill.enable", false);


// Disable saving and filling payment methods
user_pref("extensions.formautofill.creditCards.available", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.creditCards.save", false);
// Disable address autofill
user_pref("extensions.formautofill.addresses.enabled", false);
// Disable saving addresses
user_pref("extensions.formautofill.addresses.save", false);


// Disable send daily usage ping to Mozilla
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.usage.uploadEnabled", false);


// Disable Telemetry
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);

// Disable Data Submission
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.policy.dataSubmissionPolicyAcceptedVersion", 2);

// Disable personalized extension recommendations
user_pref("browser.discovery.enabled", false);
