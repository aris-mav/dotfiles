local lex = vis.lexers

for k, v in pairs(lex) do
    if type(k) == 'string' and k:match('^STYLE_') then
        lex[k] = ''
    end
end

lex.STYLE_CURSOR_PRIMARY = 'reverse'
lex.STYLE_SELECTION      = 'back:0'
lex.STYLE_COLOR_COLUMN   = 'back:0'
lex.STYLE_WHITESPACE     = 'fore:0'
lex.STYLE_STATUS_FOCUSED = 'dim,bold'
lex.STYLE_STATUS         = 'dim'
lex.STYLE_SEPARATOR      = 'dim'
lex.STYLE_LINENUMBER     = 'dim'
lex.STYLE_COMMENT        = 'dim,italics'
lex.STYLE_ERROR          = 'underlined'
lex.STYLE_STRING         = 'italics'
lex.STYLE_FUNCTION       = 'bold'
lex.STYLE_KEYWORD        = 'bold'
lex.STYLE_LABEL          = 'bold'
lex.STYLE_OPERATOR       = 'bold'
