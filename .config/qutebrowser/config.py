config = config  # noqa: F821
c = c  # noqa: F821

config.load_autoconfig()
config.source("gruvbox.py")

# Brave blocking, needs python-adblock
# auto, adblock, hosts, both
c.content.blocking.method = "adblock"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt",
    "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt",
]

c.qt.args = [
    "enable-gpu-rasterization",
    "enable-viz-display-compositor",
    "enable-accelerated-2d-canvas",
    # "ignore-gpu-blacklist",
    # "enable-native-gpu-memory-buffers",
    # "num-raster-threads=4",
]

# Fonts
c.fonts.default_family = "monospace"
c.fonts.web.family.cursive = "sans"
c.fonts.web.family.sans_serif = "sans-serif"
c.fonts.default_size = "14pt"
c.fonts.contextmenu = "14pt"
# c.fonts.hints = "18pt default_family"
c.fonts.hints = "bold 18pt default_family"

# Enhancements
c.colors.webpage.preferred_color_scheme = "dark"
c.url.start_pages = ["~/.local/src/startpage/index.html"]
c.url.default_page = "about:blank"
# c.content.user_stylesheets = "~/.config/qutebrowser/all-sites.css"


# Search engines
c.url.searchengines = {
    "DEFAULT": "https://www.google.fi/search?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "gw": "https://wiki.gentoo.org/?search-{}",
    "yt": "https://youtube.com/results?search_query={}",
    "w": "https://en.wikipedia.org/?search={}",
    "dg": "https://duckduckgo.com/?q={}",
    "dick": "http://en.wiktionary.org/?search={}",
    "r": "https://reddit.com/r/{}",
}

# Alias
c.aliases = {
    "w": "session-save",
    "wq": "quit --save",
    "mpv": "spawn -d mpv --profile=H60 {url}",
    "gh": "open -t https://github.com/twoeightdev",
    "wh": "open -t https://wallhaven.cc",
    "wt": "open -t https://www.webtoons.com/en/",
    "fb": "open -t https://facebook.com/",
    "ux": "open -t https://www.reddit.com/r/unixporn/",
    "tr": "open -t https://1337x.to/home/",
    "od": "open -t https://odysee.com/",
    "cs": "open -t https://based.cooking/",
    "ax": "open -t https://www.bilibili.tv/en/anime",
    "suck": "open -t http://suckless.org/",
}

# Better defaults
c.qt.highdpi = True
c.qt.force_software_rendering = "none"
c.zoom.default = "150%"
c.changelog_after_upgrade = "never"
c.editor.command = ["alacritty", "-e", "nvim '{}'"]
c.completion.show = "always"
c.auto_save.session = False
c.hints.radius = 0
c.hints.leave_on_load = False
# c.hints.scatter = True
c.confirm_quit = ["downloads"]
c.downloads.location.prompt = False
c.downloads.remove_finished = 1000
c.scrolling.smooth = True
c.scrolling.bar = "never"
c.content.autoplay = True
c.content.fullscreen.overlay_timeout = 3000
c.content.fullscreen.window = True
c.content.pdfjs = False
c.content.cookies.accept = "no-3rdparty"
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.headers.do_not_track = True
c.content.dns_prefetch = False
c.content.javascript.clipboard = "access"
c.content.local_content_can_access_remote_urls = True
c.input.insert_mode.auto_load = True
c.input.insert_mode.leave_on_load = True
c.tabs.show = "multiple"
c.tabs.indicator.width = 0
c.tabs.background = False
c.tabs.title.format = "{audio} {current_title}"
c.tabs.select_on_remove = "prev"
c.tabs.new_position.unrelated = "next"
c.tabs.last_close = "ignore"
c.tabs.position = "top"
c.tabs.favicons.scale = 1.0
c.tabs.padding = {"top": 2, "right": 2, "bottom": 2, "left": 2}
c.statusbar.widgets = ["url"]
c.statusbar.padding = {"top": 2, "right": 2, "bottom": 2, "left": 2}

# Keybinds
config.unbind("d")
config.bind("dd", "tab-close")
config.bind("q", "quit")
config.bind("K", "tab-next")
config.bind("J", "tab-prev")
config.bind("h", "scroll-px -100 0")
config.bind("j", "scroll-px 0 100")
config.bind("k", "scroll-px 0 -100")
config.bind("l", "scroll-px 100 0")
config.bind("0", "zoom")
config.bind("=", "zoom-in")
config.bind("-", "zoom-out")
config.bind("ya", "spawn yta {url}")
config.bind("yv", "spawn ytv {url}")
config.bind(
    "<Alt-f>", "hint links spawn --detach mpv --profile=L60 {hint-url}"
)
config.bind(
    "<Alt-Shift-f>", "hint links spawn --detach mpv --profile=M60 {hint-url}"
)
