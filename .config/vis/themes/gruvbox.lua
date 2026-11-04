-- Adapted from https://github.com/samlwood/vis-gruvbox/blob/master/gruvbox.lua
-- using the terminal's own palette

-- ANSI palette reference (Gruvbox dark, standard terminal theme)
--   0   black                 #282828
--   1   red                   #cc241d
--   2   green                 #98971a
--   3   yellow                #d79921
--   4   blue                  #458588
--   5   purple                #b16286
--   6   aqua                  #689d6a
--   7   white (light grey)    #a89984
--   8   bright black (grey)   #928374
--   9   bright red            #fb4934
--  10   bright green          #b8bb26
--  11   bright yellow         #fabd2f
--  12   bright blue           #83a598
--  13   bright purple         #d3869b
--  14   bright aqua           #8ec07c
--
-- Slots 16-255 are fixed and don't change with the theme:
--   16-231   6x6x6 colour cube: index = 16 + 36*R + 6*G + B  (R,G,B in 0-5)
--   232-255  24 greys, #080808 to #eeeeee in steps of 10

local lex                   = vis.lexers
local col                   = {
    bg           = '0',
    fg           = '15',
    gray         = '8',
    red          = '9',
    green        = '10',
    yellow       = '11',
    blue         = '12',
    purple       = '13',
    aqua         = '14',
    orange       = '11',

    bg_selection = '239',
    bg_cur       = '238',
    bg_bar       = '237',
    bg_line      = '236',
    bg_dark      = '235'
}

lex.STYLE_NOTHING           = ''
lex.STYLE_WHITESPACE        = ''

lex.STYLE_CURSOR            = 'back:' .. col.bg_cur .. ',fore:' .. col.fg
lex.STYLE_CURSOR_PRIMARY    = 'back:' .. col.bg_dark .. ',reverse'

lex.STYLE_CURSOR_LINE       = 'back:' .. col.bg_line
lex.STYLE_COLOR_COLUMN      = 'back:' .. col.bg_line
lex.STYLE_SELECTION         = 'back:' .. col.bg_selection
lex.STYLE_STATUS            = 'fore:' .. col.gray .. ',back:' .. col.bg
lex.STYLE_STATUS_FOCUSED    = 'fore:' .. col.fg .. ',back:' .. col.bg_bar
lex.STYLE_SEPARATOR         = 'fore:' .. col.bg_selection
lex.STYLE_INFO              = 'fore:' .. col.yellow .. ',bold'
lex.STYLE_LINENUMBER        = 'fore:' .. col.gray
lex.STYLE_LINENUMBER_CURSOR = 'fore:' .. col.yellow

lex.STYLE_OPERATOR          = vis.lexers.STYLE_DEFAULT
lex.STYLE_EOF               = vis.lexers.STYLE_LINENUMBER

lex.STYLE_DEFAULT           = 'back:' .. col.bg .. ',fore:' .. col.fg
lex.STYLE_CLASS             = 'fore:' .. col.yellow
lex.STYLE_COMMENT           = 'fore:' .. col.gray .. ',italics'
lex.STYLE_CONSTANT          = 'fore:' .. col.purple
lex.STYLE_DEFINITION        = 'fore:' .. col.yellow
lex.STYLE_ERROR             = 'fore:' .. col.red .. ',reverse'
lex.STYLE_FUNCTION          = 'fore:' .. col.green .. ',bold'
lex.STYLE_KEYWORD           = 'fore:' .. col.red
lex.STYLE_LABEL             = 'fore:' .. col.red
lex.STYLE_NUMBER            = 'fore:' .. col.purple
lex.STYLE_REGEX             = 'fore:' .. col.aqua
lex.STYLE_STRING            = 'fore:' .. col.green
lex.STYLE_PREPROCESSOR      = 'fore:' .. col.aqua
lex.STYLE_TAG               = 'fore:' .. col.blue
lex.STYLE_TYPE              = 'fore:' .. col.yellow
lex.STYLE_VARIABLE          = 'fore:' .. col.blue
lex.STYLE_EMBEDDED          = 'fore:' .. col.orange
lex.STYLE_IDENTIFIER        = 'fore:' .. col.blue
