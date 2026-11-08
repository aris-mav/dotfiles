local lex = vis.lexers

local col = {
    gray      = '8',
    selection = '239',
    cursors   = '238',
    bar       = '237',
}

for k, v in pairs(lex) do
    if type(k) == 'string' and k:match('^STYLE_') then
        lex[k] = ''
    end
end

lex.STYLE_CURSOR_PRIMARY = 'reverse'
lex.STYLE_SELECTION      = 'back:' .. col.selection

lex.STYLE_WHITESPACE     = 'fore:' .. col.selection
lex.STYLE_EOF            = 'fore:' .. col.bar

lex.STYLE_STATUS_FOCUSED = 'dim,bold'
lex.STYLE_STATUS         = 'dim'
lex.STYLE_COLOR_COLUMN   = 'back:' .. col.bar

lex.STYLE_SEPARATOR      = 'dim'
lex.STYLE_LINENUMBER     = 'dim'
lex.STYLE_COMMENT        = 'dim,italics'
lex.STYLE_ERROR          = 'underlined'
lex.STYLE_STRING         = 'italics'
lex.STYLE_FUNCTION       = 'bold'
lex.STYLE_KEYWORD        = 'bold'
lex.STYLE_LABEL          = 'bold'
lex.STYLE_OPERATOR       = 'bold'
