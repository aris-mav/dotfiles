local lex = vis.lexers

local function run(cmd)
    local f = io.popen(cmd .. ' 2>/dev/null')
    if not f then return '' end
    local out = f:read('*a') or ''
    f:close()
    return out:lower()
end

local function system_theme()
    local out = run('gdbus call --session'
        .. '--dest org.freedesktop.portal.Desktop '
        .. '--object-path /org/freedesktop/portal/desktop '
        .. '--method org.freedesktop.portal.Settings.Read '
        .. 'org.freedesktop.appearance color-scheme')
    if out:find('uint32 1') then return 'dark' end
    if out:find('uint32 2') then return 'light' end

    out = run('gsettings get org.gnome.desktop.interface color-scheme')
    if out:find('dark') then return 'dark' end
    if out:find('light') or out:find('default') then return 'light' end

    return 'dark'
end

local mode = system_theme()
local contrast = 'medium'

local colours = {
    dark = {
        bg0 = { hard = '#1d2021', medium = '#282828', soft = '#32302f' },
        bg1 = '#3c3836',
        bg2 = '#504945',
        bg3 = '#665c54',
        bg4 = '#7c6f64',
    },
    light = {
        bg0 = { hard = '#f9f5d7', medium = '#fbf1c7', soft = '#f2e5bc' },
        bg1 = '#ebdbb2',
        bg2 = '#d5c4a1',
        bg3 = '#bdae93',
        bg4 = '#a89984',
    },
}

colours = colours[mode]
colours.bg0 = colours.bg0[contrast]

for k, v in pairs(lex) do
    if type(k) == 'string' and k:match('^STYLE_') then
        lex[k] = ''
    end
end

lex.STYLE_CURSOR_PRIMARY = 'reverse, keep_attribute'

lex.STYLE_COLOR_COLUMN   = 'back:' .. colours.bg1
lex.STYLE_WHITESPACE     = 'fore:' .. colours.bg1
lex.STYLE_SELECTION      = 'back:' .. colours.bg1 .. ', keep_attribute'
lex.STYLE_LINENUMBER     = 'fore:' .. colours.bg2
lex.STYLE_COMMENT        = 'fore:' .. colours.bg2 .. ', italics'
lex.STYLE_STATUS         = 'fore:' .. colours.bg3
lex.STYLE_SEPARATOR      = 'fore:' .. colours.bg3
lex.STYLE_STATUS_FOCUSED = 'fore:' .. colours.bg4
lex.STYLE_ERROR          = 'underlined'
lex.STYLE_STRING         = 'italics'
lex.STYLE_FUNCTION       = 'bold'
lex.STYLE_KEYWORD        = 'bold'
lex.STYLE_LABEL          = 'bold'
