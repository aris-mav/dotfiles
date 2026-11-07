-- Adapted from https://github.com/samlwood/vis-gruvbox/blob/master/gruvbox.lua
-- using the terminal's own palette

local lex                   = vis.lexers
local col                   = {
    black      = '0',
    orange     = '3',
    gray       = '8',
    white      = '15',

    -- bright colours - for dark versions, subtract 8 from these
    red        = '9',
    green      = '10',
    yellow     = '11',
    blue       = '12',
    purple     = '13',
    aqua       = '14',

    selection  = '239',
    cursors    = '238',
    bottombar  = '237',
    cursorline = '236',
}

lex.STYLE_NOTHING           = ''
lex.STYLE_WHITESPACE        = ''

lex.STYLE_CURSOR            = 'back:' .. col.cursors .. ',fore:' .. col.white
lex.STYLE_CURSOR_PRIMARY    = 'back:' .. col.black .. ',reverse'
lex.STYLE_CURSOR_LINE       = 'back:' .. col.cursorline
lex.STYLE_COLOR_COLUMN      = 'back:' .. col.cursorline
lex.STYLE_SELECTION         = 'back:' .. col.selection
lex.STYLE_STATUS            = 'fore:' .. col.gray .. ',back:' .. col.black
lex.STYLE_STATUS_FOCUSED    = 'fore:' .. col.white .. ',back:' .. col.bottombar
lex.STYLE_SEPARATOR         = 'fore:' .. col.selection
lex.STYLE_INFO              = 'fore:' .. col.yellow .. ',bold'
lex.STYLE_LINENUMBER        = 'fore:' .. col.gray
lex.STYLE_LINENUMBER_CURSOR = 'fore:' .. col.yellow
lex.STYLE_EOF               = 'fore:' .. col.gray

lex.STYLE_DEFAULT           = 'back:' .. col.black .. ',fore:' .. col.white
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
lex.STYLE_OPERATOR          = 'fore:' .. col.white
lex.STYLE_CODE              = 'fore:' .. col.yellow
